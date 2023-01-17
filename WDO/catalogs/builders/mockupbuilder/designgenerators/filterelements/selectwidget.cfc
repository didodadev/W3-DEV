<!---
    File :          filterelements/selectwidget.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          11.10.2018
    Description :   Filtre alanında select kullanmak için kod üretici
    Notes :         
--->
<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            precode = [];

            template = '<c' & 'foutput>' & crlf() & ident() & '<select name="%s" id="%s">' & crlf();
            optionsVal = options(element, function(any code) {
                arrayAppend(precode, code);
            });

            precodeList = arrayToList(listToArray(arrayToList(precode, crlf()), crlf()), crlf() & ident());
            result = iif(len(precodeList), DE(precodeList & crlf() & ident()), DE(ident())) & super.stringFormat(template, [super.emptyAsNull(element.clientName)?:element.label, super.emptyAsNull(element.clientName)?:element.label]);
            result = result & crlf() & optionsVal;
            result = result & crlf() & ident() & "</select>";
            result = result & crlf() & ident() & "</cfoutput>";
        </cfscript>
        <cfreturn result>
    </cffunction>

    <cffunction name="options" access="public" returntype="string">
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
                iteratorname = arguments.element.label & "_method_" & arguments.element.method.name & "_iterator";
                iteratorcode = "<c" & 'fset ' & iteratorname & ' = createObject("component", "WDO.helpers.queryiterator").init(' & arguments.element.label & '_method_' & arguments.element.method.name & ')>';
                arguments.precodeCallback(iteratorcode);
                return ident(this.identcount + 1) & "<c" & 'floop condition="##' & iteratorname & '.hasiter()##">' & crlf() & ident(this.identcount +  1) & '<option value="##' & iteratorname & '.get(1)##">##' & iteratorname & '.get(2)##</option>' & crlf() & ident(this.identcount + 1) & '<cfset ' & iteratorname & '.next()>' & crlf() & ident(this.identcount + 1) & '</cfloop>';
            }
        </cfscript>
    </cffunction>

</cfcomponent>