<cfinclude  template="#controllerFilePath#">
<cfset attributes.event = len(attributes.event) ? attributes.event : WOStruct['#attributes.wo#']['default'] />

<cfset filePath = replace("/workcube/#WOStruct['#attributes.wo#']['#attributes.event#']['filePath']#", '\', '/', 'all') />
<cfset expandFilePath = replace(ExpandPath(filePath), '\', '/', 'all') />

<cfif len(WOStruct['#attributes.wo#']['#attributes.event#']['filePath']) and fileExists(expandFilePath)>
    <cfinclude  template="#filePath#">
<cfelse>
    File Path is not defined in controller file or file not found
</cfif>