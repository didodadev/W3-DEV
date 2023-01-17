<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<cfparam name="caller.denied_pages" default="">
<cfparam name="caller.module_name" default="#listfirst(caller.attributes.fuseaction,'.')#">
<cfif caller.workcube_mode><!--- development ortamda 5 dakika, production ortamda 1 saat de query calissin --->
	<cfset caller.get_denied_page_cached_time = CreateTimeSpan(0,1,0,0)>
<cfelse>
	<cfset caller.get_denied_page_cached_time = CreateTimeSpan(0,0,5,0)>
</cfif>
<cfset caller.izinli_pages = ''>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
