#ISSN XQuery 3.0 and XSLT 2.0 Function Library#

ISSNs (or **International Standard Serial Number**s), are used by publishers (and others) to identify periodical publications  of different media types (e.g. print or electronic etc.)  

This function library contains functions to: 
*   Format ISSNs
*   Remove formatting from ISSNs
*   Calculate ISSN check digits (for validation)
*   Validate ISSNs

##XQuery##

To use the ISSN XQuery functions, first import the issn.xqy module into the prolog of the desired main or library module of your XQuery code base, as follows: 

```xquery
    import module namespace issn = "http://github.com/holmesw/issn" at "/xqy/modules/issn.xqy";
```

###Format ISSN###

An **ISSN** is formatted in the following way: 
``NNNN-NNNC`` 

This means that the example ISSN "12345679" is formatted as: 1234-5679

Here is an example of how to format an ISSN: 

```xquery
    xquery version "3.0";
    
    import module namespace issn = 
      "http://github.com/holmesw/issn" at 
      "/xqy/modules/issn.xqy";
    
    issn:format-issn("12345679"), 
    (: the output of the above function call is: "1234-5679" :)
    
    issn:format-issn("1234-5679"), 
    (: the output of the above function call is: "1234-5679" :)
    
    ()
```

##XSLT 2.0##

To use the XSLT 2.0 functions, import the ISSN XSLT 2.0 function library (with the ISSN XSLT function namespace) into your style sheet.  
Example: 

```xslt
    <?xml version="1.0" encoding="ISO-8859-1"?>
    <xsl:stylesheet 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:issn="http://github.com/holmesw/issn" 
        exclude-result-prefixes="isbn" 
        version="2.0">
        
        <xsl:include href="/xsl/issn.xsl"/>
    </xsl:stylesheet>
```

