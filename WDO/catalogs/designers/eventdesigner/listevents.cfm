<cfset getPageContext().getCFOutput().clear()>
<cfset result = structNew()>
<cfif structKeyExists(application.objects, attributes.fromfuse)>
    <cfset currentObject = application.objects[attributes.fromfuse]>
    <cfif currentObject.LEGACY eq 2>
        <cfset currentObjectEvents = get_events(fuseaction: attributes.fromfuse)>
        <cfset result.type = "list">
        <cfset result.resultList = arrayNew(1)>
        <cfloop query="#currentObjectEvents#">
            <cfset arrayAppend(result.resultList, EVENT_TYPE)>
        </cfloop>
    <cfelseif currentObject.LEGACY eq 0 and len(currentObject.CONTROLLER_FILE_PATH) gt 0>
        <cfset result.type = "list">
        <cfset attributes.tabMenuController = 0>
        <cffunction name="wostructLoader">
            <cfargument name="controllerPath">
            <cffile action="read" file="#replaceNoCase(getTemplatePath(), "index.cfm", "")##arguments.controllerPath#" variable="controllerContent" charset="utf-8">
            <cfset fmatches = reFindNoCase("if\s*\(\s*isDefined\s*\(\s*""attributes.([a-zA-Z0-9_-]+)""\s*\)\s*\)", controllerContent, 1, 1)>
            <cfif arrayLen(fmatches.len) eq 2>
                <cfset attributes[fmatches.match[2]] = 1>
                <cfinclude template="../../../../#arguments.controllerPath#">
                <cfreturn WOStruct>
            </cfif>
            <cfreturn []>
        </cffunction>
        <cfset result.resultList = structKeyArray( wostructLoader(currentObject.CONTROLLER_FILE_PATH)[attributes.fuseaction] )>
    <cfelse>
        <cfset result.type = "value">
        <cfset result.resultList = "[]">
    </cfif>
</cfif>
<cfoutput>#replace(serializeJSON(result), "//", "")#</cfoutput>
<cfabort>
<cfscript>

</cfscript>