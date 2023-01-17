<cfparam name="attributes.form_submitted" default="">
<cfinclude template="../rules/query/get_position_cats.cfm">
<cfquery name="TITLES" datasource="#dsn#">
	SELECT TITLE_ID,TITLE FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
</cfquery>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.department_id" default="0">
<cfif isdefined("attributes.keyword")>
	<cfset filtered = 1>	
<cfelse>
	<cfset filtered = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.title_id" default="">
<cfset url_str = "">
<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
<cfif len(attributes.hierarchy)>
	<cfset url_str = "#url_str#&hierarchy=#attributes.hierarchy#">
</cfif>
<cfif len(attributes.position_cat_id)>
	<cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
</cfif>
<cfif len(attributes.title_id)>
	<cfset url_str="#url_str#&title_id=#attributes.title_id#">
</cfif>
<cfif isdefined("attributes.branch_id")>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
	<cfset attributes.id = attributes.branch_id>
</cfif>

<cfif isdefined("attributes.emp_status") and len(attributes.emp_status)>
	<cfset url_str = "#url_str#&emp_status=#attributes.emp_status#">
</cfif>
<cfinclude template="../rules/query/get_our_comp_and_branchs.cfm">
<cfparam name="attributes.totalrecords" default='0'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif filtered eq 1>
	<cfinclude template="../rules/query/get_hrs.cfm">
	<cfset attributes.totalrecords = get_hrs.recordcount>
<cfelse>
	<cfset get_hrs.recordcount = 0>
</cfif>

<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>



<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'rule.list_hr';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'rules/display/list_hr.cfm';	
	
</cfscript>
