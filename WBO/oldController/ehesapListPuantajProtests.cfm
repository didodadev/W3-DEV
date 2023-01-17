<cf_get_lang_set module_name="ehesap">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.employee_id" default="">
	<cfparam name="attributes.employee_name" default="">
	<cfparam name="attributes.answer_state" default="1">
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#"> 
	<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
	<cfscript>
		include "../hr/ehesap/query/get_branch_name.cfm";
		emp_branch_list=valuelist(get_branch_names.branch_id);
		if (isdefined("attributes.form_varmi"))
		{
			include "../hr/ehesap/query/get_protests.cfm";
			arama_yapilmali=0;
		}
		else
		{
			get_protests.recordcount=0;
			arama_yapilmali=1;
		}
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		include "../hr/ehesap/query/get_protests.cfm";
		adres="ehesap.list_puantaj_protests";
		if (isDefined('attributes.form_varmi') and len(attributes.form_varmi))
			adres="#adres#&form_varmi=#attributes.form_varmi#";
		if (isDefined('attributes.employee_id') and len(attributes.employee_name))
			adres="#adres#&employee_id=#attributes.employee_id#";
		if (isDefined('attributes.employee_name') and len(attributes.employee_name))
			adres="#adres#&employee_name=#attributes.employee_name#";
		if (isDefined('attributes.sal_mon'))
			adres="#adres#&sal_mon=#attributes.sal_mon#";
		if (isDefined('attributes.sal_year'))
			adres="#adres#&sal_year=#attributes.sal_year#";
		if (isDefined('attributes.answer_state'))
			adres="#adres#&answer_state=#attributes.answer_state#";
	</cfscript>
	<cfparam name="attributes.totalrecords" default="#get_protests.recordcount#">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfparam name="employee_id" default="#session.ep.userid#">
	<cfparam name="salary_mon" default="#attributes.sal_mon#">
	<cfparam name="salary_year" default="#attributes.sal_year#">
	<cfparam name="id" default="#attributes.id#">
	<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
	SELECT
	   EMPLOYEE_NAME,EMPLOYEE_SURNAME
	FROM 
	   EMPLOYEES
	WHERE 
	   EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
	</cfquery>
	<cfquery name="GET_PROTESTS" datasource="#DSN#">
		SELECT
			ANSWER_DETAIL,
		    EMPLOYEE_ID,
		    PROTEST_DETAIL
		FROM
			EMPLOYEES_PUANTAJ_PROTESTS
		WHERE 
		    PROTEST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">		
	</cfquery>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#employee_name').focus();
		});
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_puantaj_protests';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_puantaj_protests.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_add_protest_answer';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/add_protest_answer.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/add_protest_answer.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_puantaj_protests&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#lang_array.item[690]#';
</cfscript>
