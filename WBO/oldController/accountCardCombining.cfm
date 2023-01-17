<cf_get_lang_set module_name = "account">
<cfset xml_page_control_list = 'x_selected_process_id'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="account.popup_add_sum_bills">
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME 
	FROM
		BRANCH
	ORDER BY
		BRANCH_ID
</cfquery>
<cfset list_card_type_ = '11,12,13,14'>
<cfquery name="GET_ALL_PROCESS_CAT" datasource="#DSN3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT,IS_ACCOUNT FROM SETUP_PROCESS_CAT
</cfquery>
<cfquery name="get_acc_card_type" dbtype="query">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM GET_ALL_PROCESS_CAT WHERE IS_ACCOUNT = 1 AND PROCESS_TYPE IN (#list_card_type_#) ORDER BY PROCESS_TYPE
</cfquery>
<cfquery name="get_acc_card_process_type" dbtype="query">
	SELECT DISTINCT PROCESS_TYPE FROM GET_ALL_PROCESS_CAT WHERE IS_ACCOUNT = 1 AND PROCESS_TYPE IN (#list_card_type_#) ORDER BY PROCESS_TYPE
</cfquery>
<cfquery name="get_process_cat" dbtype="query">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT,IS_ACCOUNT FROM GET_ALL_PROCESS_CAT WHERE 1=1 <cfif is_selected_account eq 0>AND IS_ACCOUNT = 1</cfif> ORDER BY PROCESS_TYPE
</cfquery>
<cfquery name="get_process_cat_process_type" dbtype="query">
	SELECT DISTINCT PROCESS_TYPE FROM GET_ALL_PROCESS_CAT WHERE 1=1 <cfif is_selected_account eq 0>AND IS_ACCOUNT = 1</cfif> AND PROCESS_TYPE NOT IN (10,19) ORDER BY PROCESS_TYPE
</cfquery>
<cfquery name="get_group_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE_GROUP_ID,
		PROCESS_NAME,
		PROCESS_TYPE
	FROM  
        BILLS_PROCESS_GROUP
</cfquery>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.popup_add_sum_bills';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/form/add_sum_bill.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/query/add_sum_bills.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.popup_add_sum_bills';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'accountCardCombining';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ACCOUNT_CARD';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-12','item-13','item-15']"; 
	
</cfscript>
<script type="text/javascript">
	function is_claim_debt()
	{
		if(document.getElementById("is_account_group").checked == true)
		{
			document.getElementById("is_claim_text_td").style.display = "";
			document.getElementById("is_claim_check_td").style.display = "";
			document.getElementById("is_debt_text_td").style.display = "";
			document.getElementById("is_debt_check_td").style.display = "";				
		}	
		else
		{
			document.getElementById("is_claim_text_td").style.display = "none";
			document.getElementById("is_claim_check_td").style.display = "none";
			document.getElementById("is_debt_text_td").style.display = "none";
			document.getElementById("is_debt_check_td").style.display = "none";				
		}
	}
	function is_none_checked(type)
	{
		if(type == 1)
		{
			if(document.getElementById("is_claim_group").checked == false && document.getElementById("is_debt_group").checked == false)
				document.getElementById("is_claim_group").checked = true;		
		}
		else if(type == 2)
		{
			if(document.getElementById("is_claim_group").checked == false && document.getElementById("is_debt_group").checked == false)
				document.getElementById("is_debt_group").checked = true;		
		}
	}
	function get_proc_cat()
	{
		selected_type = document.add_sum_bills.process_type_group.value;
		if(selected_type != '')
		{
			get_process_cat = wrk_query('SELECT IS_ACCOUNT_GROUP,IS_DAY_GROUP,ACCOUNT_CODE_1,ACCOUNT_CODE_2,ACTION_DETAIL FROM BILLS_PROCESS_GROUP WHERE PROCESS_TYPE_GROUP_ID ='+selected_type,'dsn3');
			
			document.add_sum_bills.bill_detail.value = String(get_process_cat.ACTION_DETAIL);
			document.add_sum_bills.code1.value = get_process_cat.ACCOUNT_CODE_1;
			document.add_sum_bills.code2.value = get_process_cat.ACCOUNT_CODE_2;
			if(get_process_cat.IS_ACCOUNT_GROUP == 1)
				document.add_sum_bills.is_account_group.checked = true;
			if(get_process_cat.IS_DAY_GROUP == 1)
				document.add_sum_bills.is_day_group.checked = true;
		}
	}
	function pencere_ac_muavin(str_alan_1,str_alan_2,str_alan)
	{
		var txt_keyword = eval(str_alan_1 + ".value" );
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id='+str_alan_1+'&field_id2='+str_alan_1+'&keyword='+txt_keyword,'list');
	}
	function kontrol_fis_birlestir()
	{
		if (!chk_period(add_sum_bills.PROCESS_DATE,'İşlem')) return false;
		if(document.add_sum_bills.is_day_group.checked == false)
		{
			if(add_sum_bills.CARD_NO_STR.value != '' && add_sum_bills.CARD_NO_FIN.value != '' && add_sum_bills.START_DATE.value !='' && add_sum_bills.FINISH_DATE.value!='')
			{
				alert("<cf_get_lang_main no ='641.Başlangıç Tarihi'>-<cf_get_lang_main no='288.Bitiş Tarihi'><cf_get_lang_main no='586.veya'><cf_get_lang no ='175.Başlangıç ve Bitiş Numaralarını Yazınız'>!");
				return false;
			}
			else if(add_sum_bills.START_DATE.value =='' && add_sum_bills.FINISH_DATE.value=='' && add_sum_bills.CARD_NO_STR.value == '' && add_sum_bills.CARD_NO_FIN.value == '')
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='641.Başlangıç Tarihi'> - <cf_get_lang_main no='288.Bitiş Tarihi'>");
				return false;
			}
			else if((add_sum_bills.START_DATE.value =='' && add_sum_bills.FINISH_DATE.value!='') || (add_sum_bills.START_DATE.value != '' && add_sum_bills.FINISH_DATE.value == ''))
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='641.Başlangıç Tarihi'> - <cf_get_lang_main no='288.Bitiş Tarihi'>");
				return false;
			}
			else if((add_sum_bills.CARD_NO_STR.value =='' && add_sum_bills.CARD_NO_FIN.value!='') || (add_sum_bills.CARD_NO_STR.value != '' && add_sum_bills.CARD_NO_FIN.value == ''))
			{
				alert("<cf_get_lang no ='175.Başlangıç ve Bitiş Numaralarını Yazınız'>!");
				return false;
			}
			if((add_sum_bills.code1.value =='' && add_sum_bills.code2.value!='') || (add_sum_bills.code1.value != '' && add_sum_bills.code2.value == ''))
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='46.Başlangıç Hesabı'> - <cf_get_lang no='49.Bitiş Hesabı'>");
				return false;
			}
		}
		else
		{
			if(add_sum_bills.START_DATE.value == '' || add_sum_bills.FINISH_DATE.value =='')
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='641.Başlangıç Tarihi'> - <cf_get_lang_main no='288.Bitiş Tarihi'>");
				return false;
			}
			if((add_sum_bills.START_DATE.value =='' && add_sum_bills.FINISH_DATE.value!='') || (add_sum_bills.START_DATE.value != '' && add_sum_bills.FINISH_DATE.value == ''))
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='641.Başlangıç Tarihi'> - <cf_get_lang_main no='288.Bitiş Tarihi'>");
				return false;
			}
			if((add_sum_bills.CARD_NO_STR.value =='' && add_sum_bills.CARD_NO_FIN.value!='') || (add_sum_bills.CARD_NO_STR.value != '' && add_sum_bills.CARD_NO_FIN.value == ''))
			{
				alert("<cf_get_lang no ='175.Başlangıç ve Bitiş Numaralarını Yazınız'>!");
				return false;
			}
			if((add_sum_bills.code1.value =='' && add_sum_bills.code2.value!='') || (add_sum_bills.code1.value != '' && add_sum_bills.code2.value == ''))
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='46.Başlangıç Hesabı'> - <cf_get_lang no='49.Bitiş Hesabı'>");
				return false;
			}
		}
		kontrol_group = 0;
		if(add_sum_bills.process_type_group.value != '')
			kontrol_group = parseFloat(kontrol_group+1);
		if(add_sum_bills.PROCESS_TYPE.value != '' || add_sum_bills.CARD_TYPE.value != '')
			kontrol_group = parseFloat(kontrol_group+1);
		
		if(kontrol_group > 1)
		{
			alert('<cf_get_lang dictionary_id="52184.İşlem Grubu, İşlem tipi ve/veya Fiş Türü Seçeneklerinden Sadece Birini Seçmelisiniz">!');
			return false;
		}

		if( add_sum_bills.START_DATE.value !='' && add_sum_bills.FINISH_DATE.value!='')
		{
			<cfif x_month_count eq 1>
				day_count_kontrol = 31;
				day_count_kontrol_alert = "<cf_get_lang no ='177.Tarih Aralığını Bir Aydan Fazla Olmamalıdır'> !";
			<cfelse>
				day_count_kontrol = 92;
				day_count_kontrol_alert = "<cf_get_lang no ='147.Tarih Aralığını Üç Aydan Fazla Olmamalıdır'> !";
			</cfif>
			if(datediff(add_sum_bills.START_DATE.value,add_sum_bills.FINISH_DATE.value,0) > day_count_kontrol)
			{
				alert(day_count_kontrol_alert);
				return false;
			}
		}
		return true;
	}
</script>
