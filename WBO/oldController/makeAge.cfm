<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.is_date_filter" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.close_method" default="">
<cfquery name="GET_MONEY" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY
</cfquery>
<cfset xml_page_control_list = 'is_revenue_duedate'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="1" fuseact="ch.list_company_extre,ch.list_comp_extre,ch.list_extre,ch.dsp_make_age">
<cfif not isdefined("is_revenue_duedate")>
	<cfset is_revenue_duedate = 0>
</cfif>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfset comp_id = attributes.company_id>
	<cfset cons_id = "">
	<cfset comp_name = get_par_info(attributes.company_id,1,1,0)>
<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfset comp_id = "">
	<cfset cons_id = attributes.consumer_id>
	<cfset comp_name = get_cons_info(attributes.consumer_id,0,0)>
<cfelse>
	<cfset cons_id = "">
	<cfset comp_id = "">
	<cfset comp_name = "">
</cfif>
<cfif isdefined("attributes.due_date_1") and isdate(attributes.due_date_1)>
	<cf_date tarih = "attributes.due_date_1">
</cfif>
<cfif isdefined("attributes.due_date_2") and isdate(attributes.due_date_2)>
	<cf_date tarih = "attributes.due_date_2">
</cfif>
<cfif isdefined("attributes.action_date_1") and isdate(attributes.action_date_1)>
	<cf_date tarih = "attributes.action_date_1">
</cfif>
<cfif isdefined("attributes.action_date_2") and isdate(attributes.action_date_2)>
	<cf_date tarih = "attributes.action_date_2">
</cfif>
<cfif is_make_age_date>
	<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
		<cf_date tarih = "attributes.date1">
	<cfelse>
		<cfset date1="01/01/#session.ep.period_year#">
		<cfparam name="attributes.date1" default="#date1#">
	</cfif>
	<cfif isdefined('attributes.date2') and isdate(attributes.date2)>
		<cf_date tarih = "attributes.date2">
	<cfelse>
		<cfset date2 = "31/12/#session.ep.period_year#">
		<cfparam name="attributes.date2" default="#date2#">
	</cfif>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ch.dsp_make_age';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'ch/display/dsp_make_age.cfm';
</cfscript>

