<cfparam name="attributes.search_date1" default="">
<cfparam name="attributes.search_date2" default="">
<cfif len(attributes.search_date1)><cf_date tarih='attributes.search_date1'></cfif>
<cfif len(attributes.search_date2)><cf_date tarih='attributes.search_date2'></cfif>

<cfinclude template="../rules/query/get_content.cfm">
<cfif isdefined("attributes.chpid") or isdefined("id")>
  <cfinclude template="../rules/query/get_chapter_name.cfm">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_content.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset attributes.is_home = 1>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'rule.list_rule';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'rules/display/list_rule.cfm';	
	
</cfscript>
