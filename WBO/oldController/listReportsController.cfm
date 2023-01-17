<cfset x = structdelete(session,'report')>
<cfparam name="attributes.record_date" default="">
<cfif isdefined("attributes.record_date") and isdate(attributes.record_date)>
	<cf_date tarih="attributes.record_date">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../report/query/get_reports.cfm">
<cfelse>
	<cfset get_reports.recordcount=0>
</cfif>
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.report_cat_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.recorder_id" default="">
<cfparam name="attributes.report_status" default="1">
<cfset url_string = "">
<cfset url_string = "#url_string#&report_status=#attributes.report_status#">
<cfif len(attributes.report_cat_id)>
	<cfset url_string = "#url_string#&special_report_cat=#attributes.report_cat_id#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.employee_id)>
	<cfset url_string="#url_string#&employee_id=#attributes.employee_id#">
</cfif>
<cfif len(attributes.employee)>
	<cfset url_string="#url_string#&employee=#attributes.employee#">
</cfif>
<cfif isdate(attributes.record_date)>
	<cfset url_string = "#url_string#&record_date=#dateformat(attributes.record_date,'dd/mm/yyyy')#">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfset url_string = '#url_string#&form_submitted=#attributes.form_submitted#'>
</cfif>
<cfquery name="get_special_report_cats" datasource="#dsn#">
	SELECT
    	REPORT_CAT_ID,
        REPORT_CAT,
        HIERARCHY
    FROM
    	SETUP_REPORT_CAT
    ORDER BY
    	HIERARCHY
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_reports.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'report.list_reports';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'report/display/list_reports.cfm';

</cfscript>
