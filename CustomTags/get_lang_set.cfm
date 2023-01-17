<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<cfparam name="attributes.module_name" default="#listFirst(caller.attributes.fuseaction,'.')#">
<cfif listFirst(caller.attributes.fuseaction,'.') is 'schedules'>
	<cfset attributes.module_name = 'report'>
</cfif>
<cfif listFirst(caller.attributes.fuseaction,'.') is 'contact'>
	<cfset attributes.module_name = 'member'>
</cfif>
<cfif listFirst(caller.attributes.fuseaction,'.') is 'health'>
	<cfset attributes.module_name = 'hr'>
</cfif>
<cfif listFirst(caller.attributes.fuseaction,'.') is 'lab'>
	<cfset attributes.module_name = 'prod'>
</cfif>
<cfset caller.variables.module_name = attributes.module_name>
<cfset caller.variables.lang_array.item = application.langArray['#attributes.module_name#']>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">