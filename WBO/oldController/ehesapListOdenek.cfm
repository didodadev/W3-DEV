<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
	<cfif isdefined("attributes.is_submit")>
		<cfquery name="get_odenek" datasource="#dsn#">
			SELECT
				SO.AMOUNT_PAY,
				SO.CALC_DAYS,
				SO.COMMENT_PAY,
				SO.END_SAL_MON,
				SO.FROM_SALARY,
				SO.IS_DAMGA,
				SO.IS_ISSIZLIK,
				SO.METHOD_PAY,
				SO.MONEY,
				SO.ODKES_ID,
				SO.SSK,
				SO.START_SAL_MON,
				SO.TAX
			FROM 
				SETUP_PAYMENT_INTERRUPTION SO
			WHERE 
				SO.IS_ODENEK = 1
				<cfif len(attributes.keyword)> 
					AND SO.COMMENT_PAY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				</cfif>
				<cfif isDefined("attributes.status") and len(attributes.status)>
					AND STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
				</cfif>
		</cfquery>
	<cfelse>
		<cfset get_odenek.recordcount = 0>
	</cfif>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default='#get_odenek.recordcount#'>
<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
	<cfif attributes.event is 'upd'>
		<cfquery name="get_odenek" datasource="#dsn#">
			SELECT
				ACC_TYPE_ID,
				AMOUNT_MULTIPLIER,
				AMOUNT_PAY,
				CALC_DAYS,
				COMMENT_PAY,
				COMMENT_TYPE,
				END_SAL_MON,
				FACTOR_TYPE,
				FROM_SALARY,
				IS_AYNI_YARDIM,
				IS_DAMGA,
				IS_EHESAP,
				IS_INCOME,
				IS_ISSIZLIK,
				IS_KIDEM,
				METHOD_PAY,
				MONEY,
				PERIOD_PAY,
				RECORD_DATE,
				RECORD_EMP,
				SHOW,
				SSK,
				SSK_EXEMPTION_RATE,
				SSK_EXEMPTION_TYPE,
				START_SAL_MON,
				STATUS,
				TAX,
				TAX_EXEMPTION_RATE,
				TAX_EXEMPTION_VALUE,
				UPDATE_DATE,
				UPDATE_EMP
			FROM 
				SETUP_PAYMENT_INTERRUPTION 
			WHERE 
				ODKES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.odkes_id#">
		</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		function form_chk()
		{
			if($('#is_ayni_yardim').is(':checked') == true)
			{  
				if($('#show').is(':checked') == true)
				{
					alert("<cf_get_lang dictionary_id='54603.Ayni Yardım ile Bordroyu Aynı Anda Seçemezsiniz'>");
					return false;
				}
					
				if($('#is_kidem').is(':checked') == false)
				{
					alert("<cf_get_lang dictionary_id='54605.Ayni Yardım Kıdeme Dahil Bir Ödenektir. Düzenleyiniz'>!");
					return false;
				}	
			}
			$('#amount').val(filterNum($('#amount').val()));
			 if($('#amount_multiplier').val() != '')
				$('#amount_multiplier').val(filterNum($('#amount_multiplier').val(),6));
			if($('#gelir_vergisi_limiti').val() != '')
				$('#gelir_vergisi_limiti').val(filterNum($('#gelir_vergisi_limiti').val()));
			return true;
		}
		<cfif isdefined("attributes.event") and attributes.event is 'add'>
			function control_chckbx(i)
			{
				if ($('#'+i).attr("checked"))
					if (i == 'show')
						$('#ayni_yardım').attr('checked',false);
					else
						$('#show').attr('checked',false);
			}
		</cfif>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_odenek';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_odenek.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_odenek';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_odenek.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_odenek.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_odenek&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_form_upd_odenek';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_odenek.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_odenek.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_odenek&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'odkes_id=##attributes.odkes_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_odenek.comment_pay##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.list_odenek';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_odenek.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_odenek.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_odenek';
	}
	
	if ((isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event"))
	{
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		if (isdefined("attributes.is_submit"))
		{
			url_str = "";
			if (len(attributes.keyword))
				url_str = "#url_str#&keyword=#attributes.keyword#";
			url_str = "#url_str#&sal_year=#attributes.sal_year#";
			if (len(attributes.is_submit))
				url_str = "#url_str#&is_submit=#attributes.is_submit#";
			if (isdefined("attributes.status") and len(attributes.status))
				url_str = "#url_str#&status=#attributes.status#";
		}
	}
	else if(attributes.event is 'add' or attributes.event is 'upd')
	{
		include "../hr/ehesap/query/get_moneys.cfm";
		if (attributes.event is 'upd')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_odenek&event=add";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListOdenek.cfm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SETUP_PAYMENT_INTERRUPTION';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-comment','item-amount']";
</cfscript>
