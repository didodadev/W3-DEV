<cfcomponent>

    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="element" type="any">
        <cfargument name="structname" type="any">
        <cfargument name="precodeCallback" type="any">
        <cfargument name="postcodeCallback" type="any">
        <cfscript>
            if (arguments.element.devMethod.value neq "" && arguments.element.devMethod.type eq "threepoint")
            {
                arguments.precodeCallback('<div class="input-group">');
                arguments.postcodeCallback('<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen(''index.cfm?fuseaction=#arguments.element.devMethod.fuseaction#&#arguments.element.devMethod.formula#'', ''list'')"></span></div>');
                return "";
            }
            else
            {
                return "";
            }
        </cfscript>
    </cffunction>

</cfcomponent>