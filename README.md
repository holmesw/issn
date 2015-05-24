#ISSN XQuery 3.0 and XSLT 2.0 Function Library#

ISSNs (or International Standard Serial Numbers), are used by publishers (and others) to identify book series and periodical publications etc.  

This function library contains functions to: 
*   Format ISSNs
*   Remove formatting from ISSNs
*   Calculate ISSN check digits (for validation)
*   Validate ISSNs

##XQuery##

To use the ISBN XQuery functions, first import the isbn.xqy module into the prolog desired main module or library module of your XQuery code base: 

```xquery
    xquery version "3.0";
    
    import module namespace issn = "http://github.com/holmesw/issn" at "/xqy/modules/issn.xqy";
```

###Format ISSN###

An **ISSN**s is formatted in the following way: NNNN-NNNC 
This means that 12345679 is formatted as: 1234-5679

##XSLT##

