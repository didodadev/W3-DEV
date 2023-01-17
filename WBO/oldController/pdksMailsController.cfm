<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.employee_id" default="">
    <cfparam name="attributes.employee_name" default="">
    <cfparam name="attributes.answer_state" default="">
	<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
        <cf_date tarih = "attributes.startdate">
    </cfif>
    <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
        <cf_date tarih = "attributes.finishdate">
    </cfif>
    <cfinclude template="../hr/ehesap/query/get_branch_name.cfm">
    <cfset emp_branch_list=valuelist(GET_BRANCH_NAMES.BRANCH_ID)>
    <cfif isdefined('attributes.form_varmi')>
        <cfquery name="GET_MAILS" datasource="#DSN#">
            SELECT
                EPP.ACTION_DATE,
                EPP.FIRST_MAIL_DATE,
                EPP.LAST_MAIL_DATE,
                EPP.FIRST_READ_DATE,
                EPP.LAST_READ_DATE,
                E.EMPLOYEE_ID,
                E.EMPLOYEE_EMAIL,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                (SELECT TOP 1 PROTEST_DETAIL FROM EMPLOYEE_DAILY_IN_OUT_PROTESTS DP WHERE DP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EPP.ACTION_DATE IS NOT NULL AND DP.ACTION_DATE = EPP.ACTION_DATE) AS PROTEST_DETAIL,
                (SELECT TOP 1 ANSWER_DETAIL FROM EMPLOYEE_DAILY_IN_OUT_PROTESTS DP WHERE DP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EPP.ACTION_DATE IS NOT NULL AND DP.ACTION_DATE = EPP.ACTION_DATE) AS ANSWER_DETAIL,
                (SELECT TOP 1 PROTEST_ID FROM EMPLOYEE_DAILY_IN_OUT_PROTESTS DP WHERE DP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EPP.ACTION_DATE IS NOT NULL AND DP.ACTION_DATE = EPP.ACTION_DATE) AS PROTEST_ID
            FROM
                EMPLOYEE_DAILY_IN_OUT_MAILS EPP INNER JOIN 
                EMPLOYEES E ON EPP.EMPLOYEE_ID = E.EMPLOYEE_ID 
                INNER JOIN EMPLOYEES_IN_OUT EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID 
            WHERE 
                <cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and len(attributes.employee_name)>
                     EPP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
                </cfif>
                <cfif isDefined("attributes.STARTDATE")>
                    <cfif len(attributes.STARTDATE) AND len(attributes.FINISHDATE)>
                        (
                            EPP.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.STARTDATE#"> AND
                            EPP.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.FINISHDATE#">
                        )
                        AND
                    <cfelseif len(attributes.STARTDATE)>
                        EPP.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.STARTDATE#"> AND
                    <cfelseif len(attributes.FINISHDATE)>
                        EPP.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.FINISHDATE#"> AND
                    </cfif>
                </cfif>
                <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                    EI.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
                </cfif>
                EI.FINISH_DATE IS NULL AND
                EI.BRANCH_ID IN (
                	SELECT BRANCH_ID FROM BRANCH
					<cfif not session.ep.ehesap>
                        WHERE BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                    </cfif>
                )
                <cfif len(attributes.answer_state)>
                    AND E.EMPLOYEE_ID IN
                    (
                        SELECT
                            EPP_.EMPLOYEE_ID
                        FROM
                            EMPLOYEE_DAILY_IN_OUT_PROTESTS EPP_
                        WHERE
                            EPP_.ACTION_DATE = EPP.ACTION_DATE
                             <cfif attributes.answer_state eq 0 >
                                AND EPP_.ANSWER_DETAIL IS NOT NULL 
                             <cfelse>
                                AND EPP_.ANSWER_DETAIL IS NULL 
                             </cfif>
                    )
                </cfif>
            ORDER BY
                EPP.ACTION_DATE DESC
        </cfquery>
    <cfelse>
        <cfset GET_MAILS.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#GET_MAILS.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfset adres="hr.list_emp_daily_in_out_mails&form_varmi=1">
	<cfif isDefined('attributes.employee_id') and len(attributes.employee_name)>
        <cfset adres="#adres#&employee_id=#attributes.employee_id#">
    </cfif>
    <cfif isDefined('attributes.employee_name') and len(attributes.employee_name)>
        <cfset adres="#adres#&employee_name=#attributes.employee_name#">
    </cfif>
    <cfif isDefined('attributes.branch_id')>
        <cfset adres="#adres#&branch_id=#attributes.branch_id#">
    </cfif>
    <cfif isDefined('attributes.answer_state')>
        <cfset adres="#adres#&answer_state=#attributes.answer_state#">
    </cfif>
    <cfif isDefined('attributes.startdate')>
        <cfset adres="#adres#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#">
    </cfif>
    <cfif isDefined('attributes.finishdate')>
        <cfset adres="#adres#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
    </cfif>
<cfelseif isdefined('attributes.event') and attributes.event is 'add'>
    <cfquery name="get_mail_warnings" datasource="#dsn#">
        SELECT 
            * 
        FROM 
            SETUP_MAIL_WARNING
        ORDER BY
            MAIL_CAT
    </cfquery>
    <script type="text/javascript">
		function make_action()
		{
		<cfoutput query="get_mail_warnings">
			gizle(alan_#MAIL_CAT_ID#);
			goster(eval("alan_"+document.send_.message_type.value));
		</cfoutput>
		}
	</script>

</cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_emp_daily_in_out_mails';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_emp_daily_in_out_mails.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.list_emp_daily_in_out_mails';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/display/send_pdks_mails.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/send_pdks_mails.cfm';
	WOStruct['#attributes.fuseaction#']['add']['parameters'] = 'employee_id=##attributes.employee_id##&aktif_gun=##attributes.aktif_gun##';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_emp_daily_in_out_mails';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'pdksMailsController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEE_DAILY_IN_OUT_MAILS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
	
</cfscript>