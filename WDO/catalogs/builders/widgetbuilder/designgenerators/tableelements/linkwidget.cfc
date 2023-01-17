<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            attrs = "";
            precode = [];
            if (this.data.devCSS.value neq "")
            {
                cssattribute = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.attributes.cssattribute").init(this.data);
                attrs = attrs & ' ' & cssattribute.generate(function(code) {
                    arrayAppend(precode, code);
                });
            }

            //js konusu konuşulmalı

            link = replace(this.data.devLink.formula, "####", "##", "all");

            getWidgetDependencyManager().addDependency( dependStruct: this.domain.name, dependEvent: this.eventtype );

            template = '<a href="%s" %s>%%s</a>';
            precodeList = arrayToList(listToArray(arrayToList(precode, crlf()), crlf()), crlf() & ident());            
            result = iIf(len(precodeList), DE(precodeList & crlf() & ident()), DE("")) & super.stringFormat(template, [link, attrs]);

        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>