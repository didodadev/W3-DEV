<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.designgenerators.attributes.attribute">
    
    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="precodeCallback" type="any">
        <cfif this.element.devCSS.value eq "">
            <cfreturn "">
        <cfelse>
            <cfscript>
                if (this.element.devCSS.type eq "customCode")
                {
                    return 'style="' & this.element.devCSS.formula & '"';
                }
                else
                {
                    codegen = createObject("component", "WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator").createGenerator(this.element.devCSS.type);
                    code = codegen.generate(this.element.devCSS, this.element.label & "_css_");
                    arguments.precodeCallback(code);
                    return 'style="##' & this.element.label & "_css_" & this.element.devCSS.name & '##"';
                }
            </cfscript>
        </cfif>
    </cffunction>

</cfcomponent>