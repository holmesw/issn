<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:issn="http://github.com/holmesw/issn" 
    extension-element-prefixes=""
    exclude-result-prefixes="xsi xs fn issn" 
    version="2.0">
    
    <!-- 
    Unless required by applicable law or agreed to in writing, software 
    distributed under the License is distributed on an "AS IS" BASIS, 
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
    See the License for the specific language governing permissions and 
    limitations under the License.  
    -->
    
    <xsl:function name="issn:format-issn" as="xs:string">
        <xsl:param name="issn" as="xs:string" />
        <xsl:value-of select="fn:replace(issn:prepare-issn($issn), 
            '(.{4})(.{4})', '$1-$2')" />
    </xsl:function>
    
    <xsl:function name="issn:prepare-issn" as="xs:string">
        <xsl:param name="issn" as="xs:string" />
        <xsl:value-of select="fn:replace(fn:upper-case($issn), 
            '(ISSN)?[^0-9A-Za-z]', '')" />
    </xsl:function>
    
    <xsl:function name="issn:issn-check-digit" as="xs:string?">
        <xsl:param name="issn" as="xs:string" />
        <!-- convert first seven chars of ISSN into individual characters -->
        <xsl:variable name="issn-chars" as="xs:string+" 
            select="issn:split-issn(issn:issn-7($issn))" />
        <xsl:if test="issn:issn-7($issn) castable as xs:unsignedLong" >
                <!-- sum of applied weights -->
            <xsl:variable name="check-sum" select="xs:unsignedLong((fn:sum((
                fn:number(($issn-chars)[fn:position() eq 1]) * 8, 
                fn:number(($issn-chars)[fn:position() eq 2]) * 7, 
                fn:number(($issn-chars)[fn:position() eq 3]) * 6, 
                fn:number(($issn-chars)[fn:position() eq 4]) * 5, 
                fn:number(($issn-chars)[fn:position() eq 5]) * 4, 
                fn:number(($issn-chars)[fn:position() eq 6]) * 3, 
                fn:number(($issn-chars)[fn:position() eq 7]) * 2)), 0)[. castable as xs:unsignedLong][1])" 
                as="xs:unsignedLong" />
            <!-- substract remiander of 11 (of checksum) from 11 -->
            <xsl:variable name="check-digit" as="xs:unsignedLong" 
                select="xs:unsignedLong(11 - (fn:number($check-sum) mod 11))" />
            <!-- determine check digit -->
            <xsl:choose>
                <xsl:when test="$check-digit le 9">
                    <xsl:value-of select="$check-digit" />
                </xsl:when>
                <xsl:when test="$check-digit eq 11">0</xsl:when>
                <xsl:when test="$check-digit eq 10">X</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="fn:error(())" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:function>
    
    <xsl:function name="issn:is-valid-issn" as="xs:boolean">
        <xsl:param name="issn" as="xs:string" />
        <xsl:variable name="is-issn7-numeric" as="xs:boolean" 
            select="issn:issn-7($issn) castable as xs:unsignedLong" />
        <xsl:variable name="is-valid-issn-length" as="xs:boolean" 
            select="fn:string-length(issn:prepare-issn($issn)) eq 8" />
        <xsl:variable name="is-valid-issn-check-digit" as="xs:boolean" 
            select="fn:ends-with(fn:upper-case(issn:prepare-issn($issn)), 
            issn:issn-check-digit($issn)) and $is-issn7-numeric" />
        <xsl:value-of 
            select="$is-valid-issn-length and $is-valid-issn-check-digit" />
    </xsl:function>
    
    <xsl:function name="issn:validate-issn-length" as="xs:string?">
        <xsl:param name="issn" as="xs:string" />
        <xsl:variable name="prepared-issn" as="xs:string" 
            select="issn:prepare-issn($issn)" />
        <xsl:if test="fn:string-length($prepared-issn) eq 8">
            <xsl:value-of select="$prepared-issn" />
        </xsl:if>
    </xsl:function>
    
    <xsl:function name="issn:issn-7" as="xs:string">
        <xsl:param name="issn" as="xs:string" />
        <xsl:value-of select="fn:substring(issn:prepare-issn($issn), 1, 7)" />
    </xsl:function>
    
    <!-- @see http://www.xsltfunctions.com/xsl/functx_chars.html -->
    <xsl:function name="issn:split-issn" as="xs:string*">
        <xsl:param name="issn" as="xs:string" />
        <xsl:variable name="issn-8" as="xs:string" 
            select="issn:pad-string-to-length($issn, 'X', 8)"/>
        <xsl:sequence select=" 
            for $codepoint in 
                fn:string-to-codepoints(
                    issn:validate-issn-length($issn-8)
                )
            return 
                fn:codepoints-to-string($codepoint)
        "/>
    </xsl:function>
    
    <!--
        @see http://www.xsltfunctions.com/xsl/functx_pad-string-to-length.html
    --> 
    <xsl:function name="issn:pad-string-to-length" as="xs:string" 
        xmlns:functx="http://www.functx.com" >
        <xsl:param name="stringToPad" as="xs:string?"/> 
        <xsl:param name="padChar" as="xs:string"/> 
        <xsl:param name="length" as="xs:integer"/> 
        
        <xsl:sequence select="fn:substring(
            fn:string-join (($stringToPad, 
            for $i in (1 to $length) return $padChar),'')
            ,1,$length) "/>
    </xsl:function>
    
</xsl:stylesheet>
