<cf_get_lang_set module_name = "account">
<cf_xml_page_edit fuseact="account.list_cards">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.belge_no" default="">
<cfparam name="attributes.fis_type" default="">
<cfparam name="attributes.page_action_type" default="">
<cfparam name="attributes.acc_branch_id" default="">
<cfparam name="attributes.list_type_form" default="1">
<cfparam name="attributes.acc_code1_1" default="">
<cfparam name="attributes.acc_code2_1" default="">
<cfparam name="attributes.acc_code1_2" default="">
<cfparam name="attributes.acc_code2_2" default="">
<cfparam name="attributes.acc_code1_3" default="">
<cfparam name="attributes.acc_code2_3" default="">
<cfparam name="attributes.acc_code1_4" default="">
<cfparam name="attributes.acc_code2_4" default="">
<cfparam name="attributes.acc_code1_5" default="">
<cfparam name="attributes.acc_code2_5" default="">
<cfparam name="attributes.action_process_cat" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">

<cfif xml_get_today eq 1 and not isdefined("attributes.start_date")>
	<cfparam name="attributes.start_date" default="#wrk_get_today()#">
<cfelseif session.ep.our_company_info.UNCONDITIONAL_LIST>
	<cfparam name="attributes.start_date" default="">
<cfelse>
	<cfparam name="attributes.start_date" default="#wrk_get_today()#">
</cfif>
<cfif xml_get_today eq 1 and not isdefined("attributes.finish_date")>
	<cfparam name="attributes.finish_date" default="#wrk_get_today()#">
<cfelseif session.ep.our_company_info.UNCONDITIONAL_LIST>
	<cfparam name="attributes.finish_date" default="">
<cfelse>
	<cfparam name="attributes.finish_date" default="#wrk_get_today()#">
</cfif>
<cfif xml_get_today eq 1 and not isdefined("attributes.record_date")>
	<cfparam name="attributes.record_date" default="#wrk_get_today()#">
<cfelse>
	<cfparam name="attributes.record_date" default="">
</cfif>
<cfif xml_get_today eq 1 and not isdefined("attributes.finish_record_date")>
	<cfparam name="attributes.finish_record_date" default="#wrk_get_today()#">
<cfelse>
	<cfparam name="attributes.finish_record_date" default="">
</cfif>

<cfparam name="attributes.page" default="1" >
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif isdefined("attributes.maxrows") and attributes.maxrows gt 250>
	<cfset attributes.maxrows = 250>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.totalrecords" default='0'>
<cfif isdefined("attributes.form_varmi")>
	<cfif isdate(attributes.start_date)>
		<cf_date tarih = "attributes.start_date">
	</cfif>
	<cfif isdate(attributes.finish_date)>
		<cf_date tarih = "attributes.finish_date">
	</cfif>
	<cfif isdate(attributes.record_date)>
		<cf_date tarih="attributes.record_date">
	</cfif>
    <cfif isdate(attributes.finish_record_date)>
		<cf_date tarih = "attributes.finish_record_date">
	</cfif>
	<cfscript>
		get_cards_action = createObject("component", "account.cfc.get_cards");
		get_cards_action.dsn2 = dsn2;
		get_cards_action.dsn_alias = dsn_alias;
	</cfscript>
	<cfif isdefined('attributes.fis_type') and (attributes.fis_type eq 3 or attributes.fis_type eq 5)>
		<cfscript>
			get_cards = get_cards_action.get_cards_fnc
				(
					fis_type : '#IIf(IsDefined("attributes.fis_type"),"attributes.fis_type",DE(""))#',
					start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
					finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
					employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
					employee_name : '#IIf(IsDefined("attributes.employee_name"),"attributes.employee_name",DE(""))#',
					record_date : '#IIf(IsDefined("attributes.record_date"),"attributes.record_date",DE(""))#',
					finish_record_date : '#IIf(IsDefined("attributes.finish_record_date"),"attributes.finish_record_date",DE(""))#',
					keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
					oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
					acc_branch_id : '#IIf(IsDefined("attributes.acc_branch_id"),"attributes.acc_branch_id",DE(""))#',
					project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
					project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
					startrow : '#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
					action_process_cat : '#IIf(IsDefined("attributes.action_process_cat"),"attributes.action_process_cat",DE(""))#',
					maxrows : '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
				);
		</cfscript>
	<cfelseif isdefined('attributes.fis_type') and attributes.fis_type eq 6>
		<cfscript>
			get_cards = get_cards_action.get_cards_fnc2
				(
					main_card_id : '#IIf(IsDefined("attributes.main_card_id"),"attributes.main_card_id",DE(""))#',
					start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
					finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
					employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
					employee_name : '#IIf(IsDefined("attributes.employee_name"),"attributes.employee_name",DE(""))#',
					record_date : '#IIf(IsDefined("attributes.record_date"),"attributes.record_date",DE(""))#',
					finish_record_date : '#IIf(IsDefined("attributes.finish_record_date"),"attributes.finish_record_date",DE(""))#',
					keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
					oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
					acc_branch_id : '#IIf(IsDefined("attributes.acc_branch_id"),"attributes.acc_branch_id",DE(""))#',
					project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
					project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
					startrow : '#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
					action_process_cat : '#IIf(IsDefined("attributes.action_process_cat"),"attributes.action_process_cat",DE(""))#',
					maxrows : '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
				);
		</cfscript>
	<cfelse>
		<cfscript>
			get_cards = get_cards_action.get_cards_fnc3
				(
					fis_type : '#IIf(IsDefined("attributes.fis_type"),"attributes.fis_type",DE(""))#',
					list_type_form : '#IIf(IsDefined("attributes.list_type_form"),"attributes.list_type_form",DE(""))#',
					start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
					finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
					employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
					employee_name : '#IIf(IsDefined("attributes.employee_name"),"attributes.employee_name",DE(""))#',
					record_date : '#IIf(IsDefined("attributes.record_date"),"attributes.record_date",DE(""))#',
					finish_record_date : '#IIf(IsDefined("attributes.finish_record_date"),"attributes.finish_record_date",DE(""))#',
					keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
					oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
					acc_branch_id : '#IIf(IsDefined("attributes.acc_branch_id"),"attributes.acc_branch_id",DE(""))#',
					action_process_cat : '#IIf(IsDefined("attributes.action_process_cat"),"attributes.action_process_cat",DE(""))#',
					page_action_type : '#IIf(IsDefined("attributes.page_action_type"),"attributes.page_action_type",DE(""))#',
					belge_no : '#IIf(IsDefined("attributes.belge_no"),"attributes.belge_no",DE(""))#',
					card_id : '#IIf(IsDefined("attributes.card_id"),"attributes.card_id",DE(""))#',
					company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
					company : '#IIf(IsDefined("attributes.company"),"attributes.company",DE(""))#',
					consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
					acc_code1_1 : '#IIf(IsDefined("attributes.acc_code1_1"),"attributes.acc_code1_1",DE(""))#',
					acc_code1_2 : '#IIf(IsDefined("attributes.acc_code1_2"),"attributes.acc_code1_2",DE(""))#',
					acc_code1_3 : '#IIf(IsDefined("attributes.acc_code1_3"),"attributes.acc_code1_3",DE(""))#',
					acc_code1_4 : '#IIf(IsDefined("attributes.acc_code1_4"),"attributes.acc_code1_4",DE(""))#',
					acc_code1_5 : '#IIf(IsDefined("attributes.acc_code1_5"),"attributes.acc_code1_5",DE(""))#',
					acc_code2_1 : '#IIf(IsDefined("attributes.acc_code2_1"),"attributes.acc_code2_1",DE(""))#',
					acc_code2_2 : '#IIf(IsDefined("attributes.acc_code2_2"),"attributes.acc_code2_2",DE(""))#',
					acc_code2_3 : '#IIf(IsDefined("attributes.acc_code2_3"),"attributes.acc_code2_3",DE(""))#',
					acc_code2_4 : '#IIf(IsDefined("attributes.acc_code2_4"),"attributes.acc_code2_4",DE(""))#',
					acc_code2_5 : '#IIf(IsDefined("attributes.acc_code2_5"),"attributes.acc_code2_5",DE(""))#',
					project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
					project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
					is_add_main_page : '#IIf(IsDefined("attributes.is_add_main_page"),"attributes.is_add_main_page",DE(""))#',
					startrow : '#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
					maxrows : '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
				);
		</cfscript>
	</cfif>
	<cfset attributes.totalrecords=get_cards.query_count>
</cfif>
<cfquery name="CONTROL_ACC_UPDATE" datasource="#DSN#">
    SELECT ISNULL(IS_ACCOUNT_CARD_UPDATE,0) AS IS_ACCOUNT_CARD_UPDATE FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.COMPANY_ID#
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,BRANCH_NAME 
	FROM 
		BRANCH 
	WHERE
		BRANCH_STATUS = 1 
		AND COMPANY_ID = #session.ep.company_id#
	<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
		AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	</cfif>
	ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_ALL_PROCESS_CAT" datasource="#DSN3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT,IS_ACCOUNT FROM SETUP_PROCESS_CAT
</cfquery>
<cfset list_card_type_ = '10,11,12,13,14,19'>
<cfquery name="GET_PROCESS_CAT_" dbtype="query">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM GET_ALL_PROCESS_CAT WHERE PROCESS_TYPE IN (#list_card_type_#) ORDER BY PROCESS_TYPE
</cfquery>
<cfquery name="get_process_cat" dbtype="query">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM GET_ALL_PROCESS_CAT WHERE IS_ACCOUNT = 1 ORDER BY PROCESS_TYPE
</cfquery>
<cfquery name="get_process_cat_process_type" dbtype="query">
	SELECT DISTINCT PROCESS_TYPE FROM GET_ALL_PROCESS_CAT WHERE IS_ACCOUNT = 1 ORDER BY PROCESS_TYPE
</cfquery>
<cfsavecontent variable="message1"><cf_get_lang no ='155.Bu Fiş Entegreden Oluşturulmuş'><cf_get_lang_main no ='1175.Devam etmek istiyor musunuz'></cfsavecontent>
<cfsavecontent variable="message2"><cf_get_lang no='75.Kayıtlı Muhasebe Fişini Siliyorsunuz  Emin misiniz'></cfsavecontent>
<cfsavecontent variable="message3"><cf_get_lang no='75.Kayıtlı Muhasebe Fişini Siliyorsunuz  Emin misiniz'></cfsavecontent>
<cfsavecontent variable="message4"><cf_get_lang no ='156.Birleştirilmiş Fiş Yeniden Oluşturulacaktır'>.<cf_get_lang_main no ='1176.Emin Misiniz'></cfsavecontent>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	if(isdefined('is_add_main_page') )
	{
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'popup';
	}
	else
	{
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	}
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_cards';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'account/display/list_cards.cfm';
	
</cfscript>
<script type="text/javascript">
	$( document ).ready(function() {
	   document.getElementById('keyword').focus();
	});
	
	function input_control()
	{
		<cfif not session.ep.our_company_info.UNCONDITIONAL_LIST>
			if (form.keyword.value.length == 0 && form.belge_no.value.length == 0
				&& (form.finish_date.value.length == 0 || form.start_date.value.length == 0 ) 
				&& (form.employee_id.value.length == 0 || form.employee_name.value.length == 0) 
				&& (form.action.value.length == 0 && form.fis_type.value.length==0)
				<cfif isdefined('is_dsp_cari_member') and is_dsp_cari_member eq 1>
				&& (form.company_id.value.length == 0 || form.company.value.length == 0)
				</cfif>
				)
				{
					alert("<cf_get_lang_main no='1538.En Az Bir Alanda Filtre Etmelisiniz'> !");
					return false;
				}
		<cfelse>
			return true;
		</cfif>
		if(form.list_type_form.options[form.list_type_form.selectedIndex].value== 2 && form.fis_type.options[form.fis_type.selectedIndex].value==3)
		{
			alert("<cf_get_lang no ='154.Geçiçi Açık Fişler Satır Bazında Listelenemez'>!");
			return false;
		}
		return true;
	}
	function go_to_sil(int_tip,int_card,card_date)
	{
		/* ilgili donemde e-defter olup olmadiginin kontrolu, aynı zamanda query icerisinde de kontrol edilir (javascript hatalarina karsin) */
		get_netbooks = wrk_query("SELECT TOP 1 NETBOOK_ID FROM NETBOOKS WHERE STATUS = 1 AND "+  js_date(card_date) + " BETWEEN START_DATE AND FINISH_DATE","dsn2");
		if(get_netbooks.recordcount)
		{
			alert('<cf_get_lang dictionary_id="51859.İşlem Tarihine Ait E-defter Bulunmaktadır">!');
			return false;	
		}
		/* ilgili donemde e-defter olup olmadiginin kontrolu, aynı zamanda query icerisinde de kontrol edilir (javascript hatalarina karsin) */
		if (!global_date_check_value("<cfoutput>#dateformat(SESSION.EP.PERIOD_DATE,'dd/mm/yyyy')#</cfoutput>",card_date, '<cf_get_lang_main no="1539.Tarih Kısıtı Nedeniyle Muhasebe Fişini Silemezsiniz">!'))
			return false;
		else if(int_tip==1){
			 if (confirm("<cfoutput>#message1#</cfoutput>")){
				if (confirm("<cfoutput>#message2#</cfoutput>")) windowopen('<cfoutput>#request.self#?fuseaction=account.del_card&card_id=</cfoutput>'+int_card+'&actionDate='+card_date,'small'); else return false;
			 }else{
				return false;
			 }
		}else{
			if (confirm("<cfoutput>#message3#</cfoutput>")) windowopen('<cfoutput>#request.self#?fuseaction=account.del_card&card_id=</cfoutput>'+int_card+'&actionDate='+card_date,'small'); else return false;
		}
	}
	function sum_bills(new_card_id)
	{  
		if (confirm("<cfoutput>#message4#</cfoutput>")) windowopen('<cfoutput>#request.self#?fuseaction=account.emptypopup_add_sum_bills&is_temporary_solve=1&card_id=</cfoutput>'+new_card_id,'small'); else return false;
	}
	function check_manuel()
	{ 
		alert('<cf_get_lang dictionary_id="51860.Manuel Olarak Oluşan Fişler, Fiş Çözülerek Çıkarılabilir">!');
		return false;
	}
</script>
