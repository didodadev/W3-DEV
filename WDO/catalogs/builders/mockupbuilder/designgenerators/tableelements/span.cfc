<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.mockup">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            attrs = "";
            precode = [];
            if (this.data.devCSS.value neq "")
            {
                cssattribute = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.attributes.cssattribute").init(this.data);
                attrs = attrs & ' ' & cssattribute.generate(function(code) {
                    arrayAppend(precode, code);
                });
            }

            if (this.data.devMethod.value neq "" and (this.data.devMethod.type neq "threepoint")) {
                methodname = this.data.label & "_method_" & iif( isDefined( "this.data.devMethod.name" ), "this.data.devMethod.name", de("customcode") );
                codegenerator = createObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator").createGenerator(this.data.devMethod.type);
                code = codegenerator.generate(this.data.devMethod, methodname);
                if (this.data.devMethod.type eq "lists") {
                    code = "<c" & 'fset ' & methodname & '_value = createObject("component", "WDO.catalogs.elementListManager").getValue(''%%s'')>';
                }
            }

            //js konusu konuşulmalı
            //getWidgetDependencyManager().addDependency( dependStruct: this.domain.name, dependEvent: this.eventtype );

            if (this.data.devMethod.value neq "" and this.data.devMethod.type eq "lists") {
                template = '<span %s>##createObject("component", "WDO.catalogs.elementListManager").getValue(#methodname#, "%%s")##</span>';
            } else {
                template = '<span %s>%%s</span>';
            }
            precodeList = arrayToList(listToArray(arrayToList(precode, crlf()), crlf()), crlf() & ident());            
            result = iIf(len(precodeList), DE(precodeList & crlf() & ident()), DE("")) & super.stringFormat(template, [attrs]);
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>