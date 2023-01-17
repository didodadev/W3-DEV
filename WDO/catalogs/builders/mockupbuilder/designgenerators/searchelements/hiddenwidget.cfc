<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            stck = this.domain[arrayFind(this.domain, function(elm) {
                return elm.name eq this.data.struct;
            })];
            element = stck.listOfElements[arrayFind(stck.listOfElements, function(elm) {
                return elm.label eq this.data.label;
            })];

            precode = [];

            //autocomplete
            autocompleteBuilder = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.methodbuilders.autocomplete");
            autocompleteVal = autocompleteBuilder.generate(element, function(any code) {
                arrayAppend(precode, code);
            });

            defaultvalue = '##iif(isDefined("attributes.' & element.label & '"), "attributes.' & element.label & '", de(""))##';

            //template
            template = "<c" & 'foutput><input type="hidden" name="%s" id="%s" value="%s" %s></cfoutput>';

            precodeList = arrayToList(listToArray(arrayToList(precode, crlf()), crlf()), crlf() & ident());
            result = iif(len(precodeList), DE(precodeList & crlf() & ident()), DE("")) & super.stringFormat(template, [element.label, stck.name & "_" & element.label, defaultvalue, autocompleteVal]);

        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>