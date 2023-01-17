<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.date1" default="01/#Month(now())#/#year(now())#">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.status" default="">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.hierarchy" default="">
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cf_date tarih='attributes.date1'>
	<cfscript>
		url_str="";
		url_str="keyword=#attributes.keyword#&status=#attributes.status#&hierarchy=#attributes.hierarchy#&branch_id=#attributes.branch_id#";
		if (IsDefined('attributes.form_submit') and len(attributes.form_submit))
			url_str="#url_str#&form_submit=#attributes.form_submit#";
		//sorgu sirayi bozmayin
		include "../hr/ehesap/query/get_our_comp_and_branchs.cfm";
		if (isdefined('attributes.form_submit'))
			include "../hr/ehesap/query/get_other_payment_request.cfm";
		else
			get_other_requests.recordcount = 0;
		attributes.date1=dateformat(attributes.date1,'dd/mm/yyyy');
		url_str="#url_str#&date1=#attributes.date1#";
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
	</cfscript>
	<cfparam name="attributes.totalrecords" default="#get_other_requests.recordcount#">
<cfelseif isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'det')>
	<cf_get_lang_set module_name="ehesap">
	<cfquery name="get_payment_request" datasource="#DSN#">
		SELECT
			AMOUNT_GET,
			DETAIL,
			EMPLOYEE_ID,
			IS_VALID,
			RECORD_DATE,
			RECORD_EMP,
			TAKSIT_NUMBER,
			UPDATE_DATE,
			UPDATE_EMP,
			VALID_1,
			VALID_2,
			VALID_EMP,
			VALIDATOR_POSITION_CODE,
			VALIDATOR_POSITION_CODE_1,
			VALIDATOR_POSITION_CODE_2
		FROM 
			SALARYPARAM_GET_REQUESTS 
		WHERE
		    SPGR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	</cfquery>
	<cfif attributes.event is 'upd'>
		<cfset val_degeri=get_payment_request.is_valid>
		<cfquery name="GET_IN_OUTS" datasource="#DSN#">
			SELECT 
				EIO.IN_OUT_ID,E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,B.BRANCH_NAME 
			FROM 
				EMPLOYEES_IN_OUT EIO
				INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
				INNER JOIN BRANCH B ON B.BRANCH_ID = EIO.BRANCH_ID
			WHERE 
				EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_payment_request.employee_id#"> AND 
				(EIO.FINISH_DATE IS NULL OR EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">)
		</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function UnformatFields()
		{
			$('#amount_get').val(filterNum($('#amount_get').val()));
		}
		function kontrol()
		{
			if ($('#amount_get').val() =='' || $('#amount_get').val() == 0)
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='261.Tutar'>");
				return false;		
			}
			UnformatFields();
			return true;
		}
		function onay_islemi()
		{
			if ($('#employee_in_out_id').val() == "")
			{ 
				alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no ='235.Giriş-Çıkış'>");
				return false;
			}
			else
			{
				my_id = $('#employee_in_out_id').val();
				window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_deny_other_payment_request&request_id=#attributes.id#&upd_id=1&employee_in_out_id=</cfoutput>'+my_id;
			}
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'det'>
		function kapat()
		{
			window.close();
		}
		function sil()
		{
			window.location.href = '<cfoutput>#request.self#?fuseaction=ehesap.list_other_payment_requests&event=del&id=#attributes.id#</cfoutput>';
		}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_other_payment_requests';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_other_payment_requests.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_upd_other_payment_requests';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_other_payment_request.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_other_payment_request.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_other_payment_requests&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'ehesap.popup_dsp_other_pay_request_detail';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'hr/ehesap/display/dsp_other_pay_request_detail.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'hr/ehesap/query/upd_other_payment_request.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'ehesap.list_other_payment_requests&event=upd';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.id##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_other_payment_request';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_other_payment_request.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_other_payment_request.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_other_payment_requests';
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListOtherPaymentRequests';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'det,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SALARYPARAM_GET_REQUESTS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "";
</cfscript>
