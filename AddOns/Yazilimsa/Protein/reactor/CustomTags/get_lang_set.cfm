<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<cfparam name="attributes.module_name" default="#listFirst(caller.attributes.fuseaction,'.')#">
<cfif listFirst(caller.attributes.fuseaction,'.') is 'schedules'>
	<cfset attributes.module_name = 'report'>
</cfif>
<cfif listFirst(caller.attributes.fuseaction,'.') is 'contact'>
	<cfset attributes.module_name = 'member'>
</cfif>
<cfset caller.variables.module_name = attributes.module_name>
<cfset caller.variables.lang_array.item = application.langArray['#attributes.module_name#']>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">