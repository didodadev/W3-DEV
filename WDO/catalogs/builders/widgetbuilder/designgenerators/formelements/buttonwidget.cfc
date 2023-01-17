<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            stck = this.domain[arrayFind(this.domain, function(elm) {
                return elm.name eq this.data.struct;
            })];
            element = stck.listOfElements[arrayFind(stck.listOfElements, function(elm) {
                return elm.label eq this.data.label;
            })];
            precode = [];
            postcode = [];
            
            //attributes
            attrbuilder = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.attributes.attributebuilder");
            attrVal = attrbuilder.generate(element, stck.name, function(any code) {
                arrayAppend(precode, code);
            });
            
            //template
            template = '<button type="button" name="%s" id="%s" %s>%%s</button>';
            
            if ( this.hasoutputtag ) {
                template = "<c" & 'foutput>' & template & '</cfoutput>';
            }

            precodeList = arrayToList(listToArray(arrayToList(precode, crlf()), crlf()), crlf() & ident());
            result = iif(len(precodeList), DE(precodeList & crlf() & ident()), DE("")) & super.stringFormat(template, [element.label & this.index, stck.name & "_" & element.label & this.index, attrVal]);
            postcodeList = crlf() & ident() & arrayToList(listToArray(arrayToList(postcode, crlf()), crlf()), crlf() & ident());
            result = result & postcodeList;
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>