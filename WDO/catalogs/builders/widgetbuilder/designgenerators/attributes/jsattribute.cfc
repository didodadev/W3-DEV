<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.designgenerators.attributes.attribute">
    
    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="precodeCallback" type="any">
        <cfif this.element.devJS.value eq "">
            <cfreturn "">
        <cfelse>
            <cfscript>
                if (this.element.devJS.type eq "customCode")
                {
                    return this.element.devJS.formula;
                }
                else
                {
                    codegen = createObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator").createGenerator(this.element.devJS.type);
                    code = codegen.generate(this.element.devJS, this.element.label & "_js_");
                    arguments.precodeCallback(code);
                    return "##" & this.element.label & "_js_" & this.element.devJS.name & "##";
                }
            </cfscript>
        </cfif>
    </cffunction>

</cfcomponent>