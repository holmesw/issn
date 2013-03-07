(:~
 : XQuery library module containing functions to 
 : handle ISSNs
 : 
 : @see http://en.wikipedia.org/wiki/International_Standard_Serial_Number
 : @see http://www.regular-expressions.info/reference.html
 : 
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 : 
 : @author holmesw
 :)
xquery version "3.0";

module namespace issn = "http://github.com/holmesw/issn";

declare default function namespace "http://github.com/holmesw/issn";

(:~
 : format ISSN
 : uses a regex to do this
 : 
 : @author holmesw
 : 
 : @param $issn the ISSN
 : @return the formatted ISSN
 :)
declare function format-issn(
    $issn as xs:string
) as xs:string? 
{
    fn:replace(prepare-issn($issn), "(.{4})(.{4})", "$1-$2")
};

(:~
 : prepare ISSN
 : remove characters not in 0-9, A-Z or a-z
 : uses a regex to do this
 : 
 : @author holmesw
 : 
 : @param $issn the ISSN
 : @return the prepared ISSN
 :)
declare function prepare-issn(
    $issn as xs:string
) as xs:string? 
{
    fn:replace(fn:upper-case($issn), "(ISSN)?[^0-9A-Za-z]", "")
};

(:~
 : ISSN Check Digit
 : 
 : @author holmesw
 : 
 : @param $issn the ISSN
 : @return the ISSN check digit
 :)
declare function issn-check-digit(
    $issn as xs:string 
) as xs:string? 
{
    issn-check-digit-display(
        11 - (
            issn-apply-check-digit-weights(
                split-issn(
                    issn-7($issn)
                ), 
                xs:unsignedInt(7)
            ) mod 11
        )
    )
};

(:~
 : Display ISSN Check Digit
 : 
 : @author holmesw
 : 
 : @param $checkdigit the ISSN check digit
 : @return the ISSN check digit
 :)
declare %private function issn-check-digit-display(
    $checkdigit as xs:double 
) as xs:string? 
{
    if ($checkdigit le 9) then fn:string($checkdigit)
    else if ($checkdigit ge 11) then "0"
    else "X"
};

(:~
 : ISSN 7 (for ISSN Check Digit)
 : 
 : @author holmesw
 : 
 : @param $issn the ISSN
 : @return the ISSN-7 string
 :)
declare %private function issn-7(
    $issn as xs:string 
) as xs:string? 
{
    fn:substring(
        prepare-issn($issn), 
        1, 
        7
    )
};

(:~
 : Apply ISSN Check Digit Weights (recursive)
 : 
 : @author holmesw
 : 
 : @param $issn-chars the ISSN Characters
 : @param $pos the index position in the sequence
 : @return some numbers
 :)
declare %private function issn-apply-check-digit-weights(
    $issn-chars as xs:string*, 
    $pos as xs:unsignedInt
) as xs:double 
{
    if ($pos gt 1) then
        fn:number(
            (
                $issn-chars
            )[xs:integer($pos)]
        ) * 
        (
            8 - $pos + 1
        ) + 
        issn-apply-check-digit-weights(
            $issn-chars, 
            xs:unsignedInt($pos - 1)
        )
    else
        fn:number(
            (
                $issn-chars[1]
            )
        ) * 8
};

(:~
 : split ISSN into single-length strings
 : 
 : borrowed from functx:chars function
 : @see http://www.xqueryfunctions.com/xq/functx_chars.html
 : 
 : @author holmesw
 : 
 : @param $issn the ISSN
 : @return some single-length strings
 :)
declare %private function split-issn(
    $issn as xs:string
) as xs:string* 
{
    for $codepoint as xs:integer in 
        fn:string-to-codepoints(
            prepare-issn($issn)
        ) 
    return 
        fn:codepoints-to-string($codepoint)
};

(:~
 : ensure ISSN is valid length and ends with check digit
 : 
 : @author holmesw
 : 
 : @param $issn the ISSN
 : @return true/false
 :)
declare function is-valid-issn(
    $issn as xs:string
) as xs:boolean 
{
    is-valid-issn-length($issn) and 
    is-valid-issn-check-digit($issn)
};

(:~
 : ensure ISSN is valid length (8 chars)
 : 
 : @author holmesw
 : 
 : @param $issn the ISSN
 : @return true/false
 :)
declare %private function is-valid-issn-length(
    $issn as xs:string
) as xs:boolean 
{
    fn:string-length(prepare-issn($issn)) eq 8
};

(:~
 : ensure ISSN ends with valid check digit
 : 
 : @author holmesw
 : 
 : @param $issn the ISSN
 : @return true/false
 :)
declare %private function is-valid-issn-check-digit(
    $issn as xs:string
) as xs:boolean 
{
    fn:ends-with(
        prepare-issn($issn), 
        issn-check-digit($issn)
    )
};