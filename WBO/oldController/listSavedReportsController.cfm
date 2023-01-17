<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfset x = structdelete(session,'report')>
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="get_saved_reports" datasource="#dsn#">
            SELECT 
                SAVED_REPORTS.SR_ID,
                SAVED_REPORTS.REPORT_NAME,
                SAVED_REPORTS.REPORT_DETAIL,
                SAVED_REPORTS.RECORD_DATE AS RECORD_DATE,
                SAVED_REPORTS.RECORD_EMP,
                SAVED_REPORTS.UPDATE_EMP,
                EMPLOYEES.EMPLOYEE_NAME,
                EMPLOYEES.EMPLOYEE_SURNAME
            FROM
                SAVED_REPORTS,
                EMPLOYEES
            WHERE
                SAVED_REPORTS.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID
                <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
                AND REPORT_NAME like '%#attributes.keyword#%'
                </cfif>
            UNION ALL
            (
            SELECT 
                SR_ID,
                REPORT_NAME,
                REPORT_DETAIL,
                RECORD_DATE,
                RECORD_EMP,
                UPDATE_EMP,
                '' AS EMPLOYEE_NAME,
                '' AS EMPLOYEE_SURNAME
            FROM
                SAVED_REPORTS
            WHERE
                RECORD_EMP = 0
                <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
                AND REPORT_NAME like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                </cfif>
            )	
            ORDER BY 
                RECORD_DATE DESC
        </cfquery>
    <cfelse>
        <cfset get_saved_reports.recordcount=0>
    </cfif>
    <cfinclude template="../report/query/get_modules.cfm">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default=#get_saved_reports.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfset url_string = "">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.module_id" default="">
    <cfif len(attributes.keyword)>
        <cfset url_string = "#url_string#&keyword=#attributes.keyword#">
    </cfif>
    <cfif len(attributes.module_id)>
        <cfset url_string = "#url_string#&module_id=#attributes.module_id#">
    </cfif>
    
    
    <cfset adres = attributes.fuseaction>
    <cfif isdefined ('attributes.form_submitted') and len(attributes.form_submitted)>
        <cfset url_string = '#url_string#&form_submitted=#attributes.form_submitted#'>
    </cfif>
    
    <script type="text/javascript">
        document.getElementById('keyword').focus();
    </script>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfquery name="get_saved_report" datasource="#dsn#">
            SELECT 
                SAVED_REPORTS.REPORT_NAME,
                SAVED_REPORTS.REPORT_DETAIL,
                SAVED_REPORTS.RECORD_DATE,
                SAVED_REPORTS.RECORD_EMP
            FROM
                SAVED_REPORTS
            WHERE
                SAVED_REPORTS.SR_ID = #ATTRIBUTES.SR_ID#
    </cfquery>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'report.list_saved_reports';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'report/display/list_saved_reports.cfm';
	
	
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'report.popup_form_upd_saved_report';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'report/form/upd_saved_report.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'report/query/upd_saved_report.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'report.list_saved_reports&event=list';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'SR_ID=##attributes.SR_ID##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.SR_ID##';
	
	WOStruct['#attributes.fuseaction#']['del'] = structNew();
	WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'report.emptypopup_del_saved_report';
	WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'report/query/del_saved_report.cfm';
	WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'report/query/del_saved_report.cfm';
	WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'report.list_saved_reports&event=list';
	WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'SR_ID=##attributes.SR_ID##';
	WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.SR_ID##';

</cfscript>
