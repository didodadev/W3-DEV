<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.designgenerators.attributes.attribute">
    
    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="precodeCallback" type="any">
        <cfargument name="postcodeCallback" type="any">
        <cfscript>
            result = "";
            if (this.element.formula neq "" and this.element.datacompute eq "")
            {
                result = 'data-clientformula="' & this.element.formula & '"';
                
            }
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>