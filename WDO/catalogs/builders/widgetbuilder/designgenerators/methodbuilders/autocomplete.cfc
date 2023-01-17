<cfcomponent>

    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="element" type="any">
        <cfargument name="structname" type="any">
        <cfargument name="precodeCallback" type="any">
        <cfscript>
            autocomplete = iif(isDefined("arguments.element.devAutocomplete"), "arguments.element.devAutocomplete", "arguments.element.autocomplete");
            if (autocomplete.value eq "")
            {
                return "";
            }
            else
            {
                return ' onfocus="AutoComplete_Create(''' & iif(isDefined("arguments.element.clientName") and len(arguments.element.clientName), de(arguments.element.clientName), de( arguments.element.label )) & ''', ''' & autocomplete.findfield & ''', ''' & autocomplete.visible_field & ''', ''' & listfirst(autocomplete.path, ".") & ''', ''' & autocomplete.formula & ''', ''' & autocomplete.datafield & ''', ''' & arguments.structname & "_" & arguments.element.label & ''', 0,0,0,0, '''')" autocomplete="off"';
            }
        </cfscript>
    </cffunction>

</cfcomponent>