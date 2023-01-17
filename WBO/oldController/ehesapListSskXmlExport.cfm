<cfif (isdefined("attributes.event") and (attributes.event is 'list' or attributes.event is 'add')) or not isdefined("attributes.event")>
	<cfparam name="attributes.sal_year" default="#year(now())#">
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
	<cfinclude template="../hr/ehesap/query/get_branch.cfm">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		<cfparam name="attributes.ssk_office_" default="">
		<cfif isdefined("attributes.form_submitted")>
			<cfquery name="GET_SSK_XML_EXPORTS" datasource="#DSN#">
			    SELECT 
			        EMPLOYEES_SSK_EXPORTS.SSK_OFFICE,
			        EMPLOYEES_SSK_EXPORTS.SSK_OFFICE_NO,
			        EMPLOYEES_SSK_EXPORTS.RECORD_DATE,
			        EMPLOYEES_SSK_EXPORTS.IS_5073,
			        EMPLOYEES_SSK_EXPORTS.IS_5084,
			        EMPLOYEES_SSK_EXPORTS.IS_5615,
			        EMPLOYEES_SSK_EXPORTS.IS_5510,
			        EMPLOYEES_SSK_EXPORTS.IS_5921,
			        EMPLOYEES_SSK_EXPORTS.IS_5746,
			        EMPLOYEES_SSK_EXPORTS.IS_4691,
			        EMPLOYEES_SSK_EXPORTS.IS_6111,
			        EMPLOYEES_SSK_EXPORTS.IS_6486,
			        EMPLOYEES_SSK_EXPORTS.IS_6322,
			        EMPLOYEES_SSK_EXPORTS.IS_25510,
			        EMPLOYEES_SSK_EXPORTS.ESE_ID,
			        EMPLOYEES_SSK_EXPORTS.FILE_NAME,
			        EMPLOYEES_SSK_EXPORTS.SAL_MON,
			        BRANCH.BRANCH_NAME,
			        EMPLOYEES.EMPLOYEE_NAME,
			        EMPLOYEES.EMPLOYEE_SURNAME
			    FROM 
			        EMPLOYEES_SSK_EXPORTS
			        INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_SSK_EXPORTS.RECORD_EMP
			        INNER JOIN BRANCH ON BRANCH.BRANCH_ID = EMPLOYEES_SSK_EXPORTS.SSK_BRANCH_ID
			    WHERE
			        1=1
			        <cfif not session.ep.ehesap>
			        AND BRANCH.BRANCH_ID IN 
			                    (
			                    SELECT
			                        BRANCH_ID
			                    FROM
			                        EMPLOYEE_POSITION_BRANCHES
			                    WHERE
			                        EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
			                    )
			        </cfif>
					<cfif len(attributes.sal_year)>
						AND EMPLOYEES_SSK_EXPORTS.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
					</cfif>
					<cfif len(attributes.sal_mon)>
						AND EMPLOYEES_SSK_EXPORTS.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
					</cfif>
					<cfif len(attributes.ssk_office_)>
						AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_office_#">
					</cfif>
			    ORDER BY
			        EMPLOYEES_SSK_EXPORTS.RECORD_DATE DESC
			</cfquery>
		<cfelse>
		    <cfset get_ssk_xml_exports.recordcount = 0>
		</cfif>
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
		<cfparam name="attributes.totalrecords" default='#get_ssk_xml_exports.recordcount#'>
		<cfscript>
			attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
			adres=attributes.fuseaction;
			if (isdefined ("attributes.sal_year"))
				adres = "#adres#&sal_year=#attributes.sal_year#";
			if (isdefined ("attributes.sal_mon"))
				adres = "#adres#&sal_mon=#attributes.sal_mon#";
			if (isdefined("attributes.ssk_office"))
				adres = "#adres#&ssk_office=#attributes.ssk_office#";
			if (isdefined("attributes.form_submitted"))
				adres = "#adres#&form_submitted=#attributes.form_submitted#";
		</cfscript>
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		<cf_xml_page_edit fuseact="ehesap.popup_form_export_ssk_xml">
	</cfif>
</cfif>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_ssk_xml_export';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_ssk_xml_export.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_export_ssk_xml';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/export_ssk_xml.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/export_ssk_xml.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_ssk_xml_export';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_export_ssk_xml';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_export_ssk_xml.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_export_ssk_xml.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_ssk_xml_export';
	}
</cfscript>
