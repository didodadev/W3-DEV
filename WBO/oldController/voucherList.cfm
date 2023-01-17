<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.list_vouchers">
<cfparam name="attributes.due_start_date" default="">
<cfparam name="attributes.due_finish_date" default="">
<cfparam name="attributes.record_date1" default="">
<cfparam name="attributes.record_date2" default="">
<cfparam name="attributes.payroll_date1" default="">
<cfparam name="attributes.payroll_date2" default="">
<cfparam name="attributes.oby" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.owner_company" default="">
<cfparam name="attributes.owner_company_id" default="">
<cfparam name="attributes.owner_consumer_id" default="">
<cfparam name="attributes.owner_employee_id" default="">
<cfparam name="attributes.owner_member_type" default="">
<cfparam name="attributes.debt_company" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.account_id" default="">
<cfparam name="attributes.from_account_id" default="">
<cfparam name="attributes.cash" default="">
<cfparam name="attributes.paper_type" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.currency_id" default="">
<cfparam name="attributes.status" default="">
<cfquery name="get_user_process_info" datasource="#dsn3#">
	SELECT
		DISTINCT
		SPC.PROCESS_CAT_ID,
		SPC.PROCESS_CAT,
		SPC.PROCESS_TYPE,
		SPC.IS_ACCOUNT,
		SPC.IS_ZERO_STOCK_CONTROL,
		SPC.IS_DEFAULT,
		SPC.IS_PROJECT_BASED_ACC,
		SPC.DISPLAY_FILE_NAME,
		SPC.DISPLAY_FILE_FROM_TEMPLATE
	FROM
		#dsn3_alias#.SETUP_PROCESS_CAT_ROWS AS SPCR,
		#dsn3_alias#.SETUP_PROCESS_CAT_FUSENAME AS SPCF,
		#dsn_alias#.EMPLOYEE_POSITIONS AS EP,
		#dsn3_alias#.SETUP_PROCESS_CAT SPC
	WHERE
		SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID AND
		SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID AND
		SPC.PROCESS_TYPE =1053 AND
		<cfif isDefined("session.ep.position_code")>
			EP.POSITION_CODE=#session.ep.position_code# AND
			(
				SPCR.POSITION_CODE=EP.POSITION_CODE OR
				SPCR.POSITION_CAT_ID=EP.POSITION_CAT_ID
			)
		<cfelseif isDefined("session.pp.company_id")>
			SPC.IS_PARTNER = 1
		<cfelseif isDefined("session.ww.our_company_id")>
			SPC.IS_PUBLIC = 1
		</cfif>
		ORDER BY SPC.PROCESS_CAT		
</cfquery>
<cfquery name="get_user_process_info2" datasource="#dsn3#">
	SELECT
		DISTINCT
		SPC.PROCESS_CAT_ID,
		SPC.PROCESS_CAT,
		SPC.PROCESS_TYPE,
		SPC.IS_ZERO_STOCK_CONTROL,
		SPC.IS_DEFAULT,
		SPC.IS_PROJECT_BASED_ACC,
		SPC.DISPLAY_FILE_NAME,
		SPC.DISPLAY_FILE_FROM_TEMPLATE
	FROM
		#dsn3_alias#.SETUP_PROCESS_CAT_ROWS AS SPCR,
		#dsn3_alias#.SETUP_PROCESS_CAT_FUSENAME AS SPCF,
		#dsn_alias#.EMPLOYEE_POSITIONS AS EP,
		#dsn3_alias#.SETUP_PROCESS_CAT SPC
	WHERE
		SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID AND
		SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID AND
		SPC.PROCESS_TYPE =1056 AND
		<cfif isDefined("session.ep.position_code")>
			EP.POSITION_CODE=#session.ep.position_code# AND
			(
				SPCR.POSITION_CODE=EP.POSITION_CODE OR
				SPCR.POSITION_CAT_ID=EP.POSITION_CAT_ID
			)
		<cfelseif isDefined("session.pp.company_id")>
			SPC.IS_PARTNER = 1
		<cfelseif isDefined("session.ww.our_company_id")>
			SPC.IS_PUBLIC = 1
		</cfif>
		ORDER BY SPC.PROCESS_CAT		
</cfquery>
<cfquery name="check_our_company" datasource="#dsn#">
	SELECT IS_REMAINING_AMOUNT FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfinclude template="../cheque/query/get_money2.cfm">
<cfif isdefined("attributes.is_form_submitted")>
	<cfif len(attributes.due_start_date) and isdate(attributes.due_start_date)>
        <cf_date tarih = "attributes.due_start_date">
    </cfif>
    <cfif len(attributes.due_finish_date) and isdate(attributes.due_finish_date)>
        <cf_date tarih = "attributes.due_finish_date">
    </cfif>
    <cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
        <cf_date tarih = "attributes.record_date1">
    </cfif>
    <cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
        <cf_date tarih = "attributes.record_date2">
    </cfif>
    <cfif len(attributes.payroll_date1) and isdate(attributes.payroll_date1)>
        <cf_date tarih = "attributes.payroll_date1">
    </cfif>
    <cfif len(attributes.payroll_date2) and isdate(attributes.payroll_date2)>
        <cf_date tarih = "attributes.payroll_date2">
    </cfif>
	<cfinclude template="../cheque/query/get_vouchers.cfm">
<cfelse>
	<cfset get_vouchers.recordcount = 0 >
</cfif>
<cfset sistem_toplam = 0>
<cfset sistem2_toplam = 0>
<cfoutput query="get_money">
	<cfset 'toplam_#money#' = 0>
    <cfset 'toplam_ilk_#money#' = 0>
    <cfset 'toplam_paid_#money#' = 0>
</cfoutput>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_vouchers.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfinclude template="../cheque/query/get_cashes.cfm">
<cfset process_type_info3 = '1054,1051'>
<script type="text/javascript">
	$(document).ready(function(){
		document.getElementById('keyword').focus();	
	});
	function show_bank_info()
	{
		var is_selected=0;
		if(document.getElementsByName('row_voucher').length > 0)
		{
			var voucher_id_list_="";
			var voucher_currency_list="";
			if(document.getElementsByName('row_voucher').length ==1)
			{
				if(document.getElementById('row_voucher').checked==true){
					is_selected=1;
					voucher_id_list_+=list_getat(document.upd_all_vouchers.row_voucher.value,1,';');
					voucher_currency_list+=list_getat(document.upd_all_vouchers.row_voucher.value,2,';');
				}
			}	
			else
			{
				for (i=0;i<document.getElementsByName('row_voucher').length;i++)
				{
					if(document.upd_all_vouchers.row_voucher[i].checked==true)
					{ 
						if(voucher_id_list_ != '')
						{
							voucher_id_list_+=','+list_getat(document.upd_all_vouchers.row_voucher[i].value,1,';');
							if(!list_find(voucher_currency_list,list_getat(document.upd_all_vouchers.row_voucher[i].value,2,';'),','))
							{voucher_currency_list+=','+list_getat(document.upd_all_vouchers.row_voucher[i].value,2,';');}
						}
						else
						{
							voucher_id_list_+=list_getat(document.upd_all_vouchers.row_voucher[i].value,1,';');
							if(!list_find(voucher_currency_list,list_getat(document.upd_all_vouchers.row_voucher[i].value,2,';'),','))
							{voucher_currency_list+=list_getat(document.upd_all_vouchers.row_voucher[i].value,2,';');}
							is_selected=1;
						}
					}
				}		
			}
			if(voucher_id_list_ == '')
			{
				alert("İşlem Yapılacak Senetleri Seçiniz");
				document.getElementById('process_cat').value = '';
				return false;
			}
			if(list_len(voucher_currency_list) > 1)
			{
				alert("Farklı Para Birimleri Olan Senetler Mevcut. Lütfen Aynı Para Birimli Senetleri Seçiniz!");
				document.getElementById('process_cat').value = '';
				return false;
			}
		<cfif listfind(process_type_info3,1051)>
			var selected_ptype = document.upd_all_vouchers.process_cat.options[document.upd_all_vouchers.process_cat.selectedIndex].value;
			if(selected_ptype != '')
			{
				var proc_control = document.getElementById('ct_process_type_'+selected_ptype).value;
				if(proc_control == 1051)
				{
					show_bank.style.display = '';
				}
				else
					show_bank.style.display = 'none';
			}
			else
				show_bank.style.display = 'none';
		</cfif>
		bank_accounts_control(voucher_currency_list);
		}
	}
	function bank_accounts_control(list)
	{
		var list_ = list;
		var send_address = "<cfoutput>#request.self#?fuseaction=cheque.emptypopup_bank_accounts_ajax</cfoutput>&currency_id=";
		send_address += list;
		AjaxPageLoad(send_address,'bank_accounts_ajax_');
	}	
	
	function update_vouchers(type)
	{ 
		document.getElementById('type').value = type;
		if(type==0)
		{
			if(document.getElementById('process_type_info1').value == '')
				{
					alert("Lütfen Tahsil Edildi İşlem Tipi Seçiniz!");
					return false;
				}
			else
			{
				var is_selected=0;
				if(document.getElementsByName('row_voucher').length > 0)
				{
					var voucher_id_list="";
					var voucher_date_list="";
					if(document.getElementsByName('row_voucher').length ==1)
					{
						if(document.getElementById('row_voucher').checked==true){
							is_selected=1;
							voucher_id_list+=list_getat(document.upd_all_vouchers.row_voucher.value,1,';')+',';
							var row_date=eval("document.all.row_date_"+list_getat(document.upd_all_vouchers.row_voucher.value,1,';')).value;
							voucher_date_list+=row_date+',';
						}
					}	
					else
					{
						for (i=0;i<document.getElementsByName('row_voucher').length;i++)
						{
							if(document.upd_all_vouchers.row_voucher[i].checked==true)
							{ 
								voucher_id_list+=list_getat(document.upd_all_vouchers.row_voucher[i].value,1,';')+',';
								var row_date=eval("document.all.row_date_"+list_getat(document.upd_all_vouchers.row_voucher[i].value,1,';')).value;
								voucher_date_list+=row_date+',';
								is_selected=1;
							}
						}		
					}
					if(is_selected==1)
					{
						if(confirm("Seçtiğiniz Senetlerin Bankadan Tahsil İşlemleri Gerçekleşecek. Emin misiniz?"))
						{
							var kontrol_process_date = voucher_date_list;
							if(kontrol_process_date != '')
							{
								var liste_uzunlugu = list_len(kontrol_process_date);
								for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
								{
									var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
									var sonuc_ = datediff(document.all.act_date.value,tarih_,0);
									if(sonuc_ > 0)
									{
										alert("<cf_get_lang no='13.İşlem Tarihi Seçilen Senetlerin Son İşlem Tarihinden Önce Olamaz'>!");
										return false;
									}
								}
							}
							if(list_len(voucher_id_list,',') > 1)
							{
								voucher_id_list = voucher_id_list.substr(0,voucher_id_list.length-1);	
								document.getElementById('voucher_id_list').value=voucher_id_list;
								user_message='İşlemler Yapılıyor Lütfen Bekleyiniz!';
								AjaxFormSubmit(upd_all_vouchers,'user_message_demand',1,user_message,'<cf_get_lang_main no="1374.Tamamlandı">!','','',1);
							}
						}
					}
					else
					{
						alert("İşlem Yapılacak Senetleri Seçiniz!");
						return false;
					}
				}
			}
		}
		else if (type==1)
		{
			if(document.getElementById('process_type_info2').value == '')
				{
					alert("Lütfen Protestolu İşlem Tipi Seçiniz!");
					return false;
				}
			else
			{
				var is_selected=0;
				if(document.getElementsByName('row_voucher').length > 0)
				{
					var voucher_id_list="";
					var voucher_date_list="";
					if(document.getElementsByName('row_voucher').length ==1)
					{
						if(document.getElementById('row_voucher').checked==true){
							is_selected=1;
							voucher_id_list+=list_getat(document.upd_all_vouchers.row_voucher.value,1,';')+',';
							var row_date=eval("document.all.row_date_"+list_getat(document.upd_all_vouchers.row_voucher.value,1,';')).value;
							voucher_date_list+=row_date+',';
						}
					}	
					else
					{
						for (i=0;i<document.getElementsByName('row_voucher').length;i++)
						{
							if(document.upd_all_vouchers.row_voucher[i].checked==true)
							{ 
								voucher_id_list+=list_getat(document.upd_all_vouchers.row_voucher[i].value,1,';')+',';
								var row_date=eval("document.all.row_date_"+list_getat(document.upd_all_vouchers.row_voucher[i].value,1,';')).value;
								voucher_date_list+=row_date+',';
								is_selected=1;
							}
						}		
					}
					if(is_selected==1)
					{
						if(confirm("Seçtiğiniz Senetlerin Protestolu İşlemleri Gerçekleşecek. Emin misiniz?"))
						{
							var kontrol_process_date = voucher_date_list;
							if(kontrol_process_date != '')
							{
								var liste_uzunlugu = list_len(kontrol_process_date);
								for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
								{
									var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
									var sonuc_ = datediff(document.all.act_date.value,tarih_,0);
									if(sonuc_ > 0)
									{
										alert("<cf_get_lang no='13.İşlem Tarihi Seçilen Senetlerin Son İşlem Tarihinden Önce Olamaz'>!");
										return false;
									}
								}
							}
							if(list_len(voucher_id_list,',') > 1)
							{
								voucher_id_list = voucher_id_list.substr(0,voucher_id_list.length-1);	
								document.getElementById('voucher_id_list').value=voucher_id_list;
								user_message='İşlemler Yapılıyor Lütfen Bekleyiniz!';
								AjaxFormSubmit(upd_all_vouchers,'user_message_demand',1,user_message,'<cf_get_lang_main no="1374.Tamamlandı">!','','',1);
							}
						}
					}
					else
					{
						alert("İşlem Yapılacak Senetleri Seçiniz!");
						return false;
					}
				}
			}
		}
		else
		{
			if(document.getElementById('process_cat').value == '')
				{
					alert("Lütfen Ödendi İşlem Tipi Seçiniz!");
					return false;
				}
			else
			{
				var is_selected=0;
				if(document.getElementsByName('row_voucher').length > 0)
				{
					var voucher_id_list="";
					var voucher_date_list="";
					if(document.getElementsByName('row_voucher').length ==1)
					{
						if(document.getElementById('row_voucher').checked==true){
							is_selected=1;
							voucher_id_list+=list_getat(document.upd_all_vouchers.row_voucher.value,1,';')+',';
							var row_date=eval("document.all.row_date_"+list_getat(document.upd_all_vouchers.row_voucher.value,1,';')).value;
							voucher_date_list+=row_date+',';
						}
					}	
					else
					{
						for (i=0;i<document.getElementsByName('row_voucher').length;i++)
						{
							if(document.upd_all_vouchers.row_voucher[i].checked==true)
							{
								voucher_id_list+=list_getat(document.upd_all_vouchers.row_voucher[i].value,1,';')+',';
								var row_date=eval("document.all.row_date_"+list_getat(document.upd_all_vouchers.row_voucher[i].value,1,';')).value;
								voucher_date_list+=row_date+',';
								is_selected=1;
							}
						}		
					}
					if(is_selected==1)
					{
						var selected_ptype = document.upd_all_vouchers.process_cat.options[document.upd_all_vouchers.process_cat.selectedIndex].value;
						if(selected_ptype != '')
						{
							var proc_control = document.getElementById('ct_process_type_'+selected_ptype).value;
							if(proc_control == 1051 && document.upd_all_vouchers.from_account_id.value == '')
							{
								alert("Lütfen Banka Hesabı Seçiniz !");
								return false;
							}
						}
						if(confirm("Seçtiğiniz Senetlerin Ödendi İşlemleri Gerçekleşecek. Emin misiniz?"))
						{
							var kontrol_process_date = voucher_date_list;
							if(kontrol_process_date != '')
							{
								var liste_uzunlugu = list_len(kontrol_process_date);
								for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
								{
									var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
									var sonuc_ = datediff(document.all.act_date.value,tarih_,0);
									if(sonuc_ > 0)
									{
										alert("<cf_get_lang no='13.İşlem Tarihi Seçilen Senetlerin Son İşlem Tarihinden Önce Olamaz'>!");
										return false;
									}
								}
							}
							if(list_len(voucher_id_list,',') > 1)
							{
								voucher_id_list = voucher_id_list.substr(0,voucher_id_list.length-1);	
								document.getElementById('voucher_id_list').value=voucher_id_list;
								user_message='İşlemler Yapılıyor Lütfen Bekleyiniz!';
								AjaxFormSubmit(upd_all_vouchers,'user_message_demand',1,user_message,'<cf_get_lang_main no="1374.Tamamlandı">!','','',1);
							}
						}
					}
					else
					{
						alert("İşlem Yapılacak Senetleri Seçiniz!");
						return false;
					}
				}
			}
			return false;
		}
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'cheque.list_vouchers';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'cheque/display/list_vouchers.cfm';

</cfscript>
