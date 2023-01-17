<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.list_cheques">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.record_date1" default="">
<cfparam name="attributes.record_date2" default="">
<cfparam name="attributes.payroll_date1" default="">
<cfparam name="attributes.payroll_date2" default="">
<cfparam name="attributes.oby" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.owner_company" default="">
<cfparam name="attributes.process_cat_id" default="">
<cfparam name="attributes.owner_company_id" default="">
<cfparam name="attributes.owner_consumer_id" default="">
<cfparam name="attributes.owner_employee_id" default="">
<cfparam name="attributes.owner_member_type" default="">
<cfparam name="attributes.debt_company" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.list_bank_name" default="">
<cfparam name="attributes.list_bank_branch_name" default="">
<cfparam name="attributes.account_id" default="">
<cfparam name="attributes.cash" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.is_excel" default="">

<cfscript>
	excelCheques = createobject("component","cheque.cfc.cheque");
	excelCheques.dsn2 = dsn2;
	excelCheques.dsn = dsn;
	excelCheques.dsn_alias = dsn_alias;
	excelCheques.dsn3_alias = dsn3_alias;
	excelCheques.upload_folder = upload_folder;
</cfscript>
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
		SPC.PROCESS_TYPE =1043 AND
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
		SPC.PROCESS_TYPE =1046 AND
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
<cfquery name="get_user_process_info3" datasource="#dsn3#">
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
		SPC.PROCESS_TYPE =1044 AND
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
<cfinclude template="../cheque/query/get_money2.cfm">
<cfif isdefined("attributes.is_form_submitted")>
	<cfif len(attributes.start_date) and isdate(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    </cfif>
    <cfif len(attributes.finish_date) and isdate(attributes.finish_date)>
        <cf_date tarih = "attributes.finish_date">
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
	<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
    	<cfscript>
        	getChequeExcel = excelCheques.getChequeExcel(
				is_excel : attributes.is_excel,
				start_date : attributes.start_date,
				finish_date : attributes.finish_date,
				record_date1 : attributes.record_date1,
				record_date2 : attributes.record_date2,
				payroll_date1 : attributes.payroll_date1,
				payroll_date2 : attributes.payroll_date2,
				oby : attributes.oby,
				status : attributes.status,
				company : attributes.company,
				company_id : attributes.company_id,
				consumer_id : attributes.consumer_id,
				employee_id : attributes.employee_id,
				member_type : attributes.member_type,
				owner_company : attributes.owner_company,
				process_cat_id : attributes.process_cat_id,
				owner_company_id : attributes.owner_company_id,
				owner_consumer_id : attributes.owner_consumer_id,
				owner_employee_id : attributes.owner_employee_id,
				owner_member_type : attributes.owner_member_type,
				debt_company : attributes.debt_company,
				keyword : attributes.keyword,
				list_bank_name : attributes.list_bank_name,
				list_bank_branch_name : attributes.list_bank_branch_name,
				account_id : attributes.account_id,
				cash : attributes.cash,
				project_head : attributes.project_head,
				project_id : attributes.project_id,
				x_is_dsp_notes : x_is_dsp_notes,
				x_bordro_no : x_bordro_no,
				fuseaction : attributes.fuseaction,
				title_list : '#lang_array.item[54]#,#lang_array.item[55]#,#lang_array.item[56]#,#lang_array.item[57]#,#lang_array.item[58]#,#lang_array.item[59]#,#lang_array.item[60]#,#lang_array_main.item[1094]#,#lang_array_main.item[1621]#,#lang_array.item[58]#-#lang_array.item[54]#,#lang_array.item[168]#,#lang_array.item[272]#,#lang_array_main.item[1156]#'
			);
        </cfscript>
       	<cfset get_cheques.recordcount = 0>
    <cfelse>
    	<cfinclude template="../cheque/query/get_cheques.cfm">
    </cfif>
<cfelse>
	<cfset get_cheques.recordcount = 0>
</cfif>
<cfset sistem_toplam = 0>
<cfset sistem2_toplam = 0>
<cfoutput query="get_money">
	<cfset 'toplam_#money#' = 0>
</cfoutput>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_cheques.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfinclude template="../cheque/query/get_cashes.cfm">
<script type="text/javascript">
	$(document).ready(function(){
		document.getElementById('keyword').focus();
	});
	function update_cheques(type)
	{
		document.getElementById('type').value = type;
		if(type==0)
		{
			if(document.getElementById('process_type_info1').value == '')
				{
					alert("<cf_get_lang dictionary_id='51780.Lütfen Tahsil Edildi İşlem Tipi Seçiniz'>!");
					return false;
				}
			else
			{
				var is_selected=0;
				if(document.getElementsByName('row_cheque').length > 0)
				{
					var cheque_id_list="";
					var cheque_date_list="";
					if(document.getElementsByName('row_cheque').length ==1)
					{
						if(document.getElementById('row_cheque').checked==true){
							is_selected=1;
							cheque_id_list+=document.upd_all_cheques.row_cheque.value+',';
							var row_date=eval("document.all.row_date_"+document.upd_all_cheques.row_cheque.value).value;
							cheque_date_list+=row_date+',';
						}
					}	
					else
					{
						for (i=0;i<document.getElementsByName('row_cheque').length;i++)
						{
							if(document.upd_all_cheques.row_cheque[i].checked==true)
							{ 
								cheque_id_list+=document.upd_all_cheques.row_cheque[i].value+',';
								var row_date=eval("document.all.row_date_"+document.upd_all_cheques.row_cheque[i].value).value;
								cheque_date_list+=row_date+',';
								is_selected=1;
							}
						}		
					}
					if(is_selected==1)
					{
						if(confirm("<cf_get_lang dictionary_id='51702.Seçtiğiniz Çeklerin Bankadan Tahsil İşlemleri Gerçekleşecek'>.<cf_get_lang dictionary_id='58588.Emin misiniz'>"))
						{
							var kontrol_process_date = cheque_date_list;
							if(kontrol_process_date != '')
							{
								var liste_uzunlugu = list_len(kontrol_process_date);
								for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
								{
									var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
									var sonuc_ = datediff(document.all.act_date.value,tarih_,0);
									if(sonuc_ > 0)
									{
										alert("<cf_get_lang no='12.İşlem Tarihi Seçilen Çeklerin Son İşlem Tarihinden Önce Olamaz'>!");
										return false;
									}
								}
							}
							if(list_len(cheque_id_list,',') > 1)
							{
								cheque_id_list = cheque_id_list.substr(0,cheque_id_list.length-1);	
								document.getElementById('cheque_id_list').value=cheque_id_list;
								user_message="<cf_get_lang dictionary_id='51708.İşlemler Yapılıyor Lütfen Bekleyiniz'>!";
								AjaxFormSubmit(upd_all_cheques,'user_message_demand',1,user_message,'<cf_get_lang_main no="1374.Tamamlandı">!','','',1);
							}
						}
					}
					else
					{
						alert("<cf_get_lang dictionary_id='51713.İşlem Yapılacak Çekleri Seçiniz'>!");
						return false;
					}
				}
			}
		}
		else if(type==1)
		{
			if(document.getElementById('process_type_info2').value == '')
				{
					alert("<cf_get_lang dictionary_id='51714.Lütfen Karşılıksız İşlem Tipi Seçiniz'>");
					return false;
				}
			else
			{
				var is_selected=0;
				if(document.getElementsByName('row_cheque').length > 0)
				{
					var cheque_id_list="";
					var cheque_date_list="";
					if(document.getElementsByName('row_cheque').length ==1)
					{
						if(document.getElementById('row_cheque').checked==true){
							is_selected=1;
							cheque_id_list+=document.upd_all_cheques.row_cheque.value+',';
							var row_date=eval("document.all.row_date_"+document.upd_all_cheques.row_cheque.value).value;
							cheque_date_list+=row_date+',';
						}
					}	
					else
					{
						for (i=0;i<document.getElementsByName('row_cheque').length;i++)
						{
							if(document.upd_all_cheques.row_cheque[i].checked==true)
							{ 
								cheque_id_list+=document.upd_all_cheques.row_cheque[i].value+',';
								var row_date=eval("document.all.row_date_"+document.upd_all_cheques.row_cheque[i].value).value;
								cheque_date_list+=row_date+',';
								is_selected=1;
							}
						}		
					}
					if(is_selected==1)
					{
						if(confirm("<cf_get_lang dictionary_id='51715.Seçtiğiniz Çeklerin Karşılıksız İşlemleri Gerçekleşecek'>.<cf_get_lang dictionary_id='58588.Emin misiniz'>"))
						{
							var kontrol_process_date = cheque_date_list;
							if(kontrol_process_date != '')
							{
								var liste_uzunlugu = list_len(kontrol_process_date);

								for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
								{
									var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
									var sonuc_ = datediff(document.all.act_date.value,tarih_,0);
									if(sonuc_ > 0)
									{
										alert("<cf_get_lang no='12.İşlem Tarihi Seçilen Çeklerin Son İşlem Tarihinden Önce Olamaz'>!");
										return false;
									}
								}
							}
							if(list_len(cheque_id_list,',') > 1)
							{
								cheque_id_list = cheque_id_list.substr(0,cheque_id_list.length-1);	
								document.getElementById('cheque_id_list').value=cheque_id_list;
								user_message='İşlemler Yapılıyor Lütfen Bekleyiniz!';
								AjaxFormSubmit(upd_all_cheques,'user_message_demand',1,user_message,'<cf_get_lang_main no="1374.Tamamlandı">!','','',1);
							}
						}
					}
					else
					{
						alert("<cf_get_lang dictionary_id='51713.İşlem Yapılacak Çekleri Seçiniz'>!");
						return false;
					}
				}
			}
		}
		else
		{
			if(document.getElementById('process_type_info3').value == '')
			{
				alert("<cf_get_lang dictionary_id='51732.Lütfen Ödendi İşlem Tipi Seçiniz'>!");
				return false;
			}
			else
			{
				var is_selected=0;
				if(document.getElementsByName('row_cheque').length > 0)
				{
					var cheque_id_list="";
					var cheque_date_list="";
					if(document.getElementsByName('row_cheque').length ==1)
					{
						if(document.getElementById('row_cheque').checked==true){
							is_selected=1;
							cheque_id_list+=document.upd_all_cheques.row_cheque.value+',';
							var row_date=eval("document.all.row_date_"+document.upd_all_cheques.row_cheque.value).value;
							cheque_date_list+=row_date+',';
						}
					}	
					else
					{
						for (i=0;i<document.getElementsByName('row_cheque').length;i++)
						{
							if(document.upd_all_cheques.row_cheque[i].checked==true)
							{ 
								cheque_id_list+=document.upd_all_cheques.row_cheque[i].value+',';
								var row_date=eval("document.all.row_date_"+document.upd_all_cheques.row_cheque[i].value).value;
								cheque_date_list+=row_date+',';
								is_selected=1;
							}
						}		
					}
					if(is_selected==1)
					{
						if(confirm("<cf_get_lang dictionary_id='51731.Seçtiğiniz Çeklerin Ödendi İşlemleri Gerçekleşecek'>.<cf_get_lang dictionary_id='58588.Emin misiniz'>"))
						{
							var kontrol_process_date = cheque_date_list;
							if(kontrol_process_date != '')
							{
								var liste_uzunlugu = list_len(kontrol_process_date);
								for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
								{
									var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
									var sonuc_ = datediff(document.all.act_date.value,tarih_,0);
									if(sonuc_ > 0)
									{
										alert("<cf_get_lang no='12.İşlem Tarihi Seçilen Çeklerin Son İşlem Tarihinden Önce Olamaz'>!");
										return false;
									}
								}
							}
							if(list_len(cheque_id_list,',') > 1)
							{
								cheque_id_list = cheque_id_list.substr(0,cheque_id_list.length-1);	
								document.getElementById('cheque_id_list').value=cheque_id_list;
								user_message="<cf_get_lang dictionary_id='51708.İşlemler Yapılıyor Lütfen Bekleyiniz'>!";
								AjaxFormSubmit(upd_all_cheques,'user_message_demand',1,user_message,'<cf_get_lang_main no="1374.Tamamlandı">!','','',1);
							}
						}
					}
					else
					{
						alert("<cf_get_lang dictionary_id='51713.İşlem Yapılacak Çekleri Seçiniz'>!");
						return false;
					}
				}
			}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'cheque.list_cheques';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'cheque/display/list_cheques.cfm';

</cfscript>
