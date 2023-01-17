<!---
    File :          filterelements/radiowidget.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          11.10.2019
    Description :   filtre alanında radio kullanmak için üretici
    Notes :         
--->
<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="struct" type="string">
        <cfscript>
            precode =  [];

            template = radios(element, function(any code) {
                arrayAppend(precode, code);
            });

            precodeList = arrayToList(listToArray(arrayToList(precode, crlf()), crlf()), crlf() & ident());
            result = iif(len(precodeList), DE(precodeList & crlf() & ident()), DE(ident())) & template;
        </cfscript>
    </cffunction>

    <cffunction name="radios" access="public" returntype="string">
        <cfargument name="element" type="any">
        <cfargument name="precodeCallback" type="any">
        <cfscript>
            if (arguments.element.method.value eq "")
            {
                return "";
            }
            else 
            {
                codegen = createObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator").createGenerator(arguments.element.method.type);
                code = codegen.generate(arguments.element.method, arguments.element.label & "_method_");
                arguments.precodeCallback(code);
                return "<c" & 'foutput query="' & arguments.element.label & "_method_" & arguments.element.method.name & '">' & crlf() & ident(this.identcount + 1) & '<input type="radio" name="' & super.emptyAsNull(arguments.element.clientName)?: arguments.element.label & '" value="' & '">' & crlf() & ident() & '</cfoutput>';
            }
        </cfscript>
    </cffunction>

<cfcomponent>