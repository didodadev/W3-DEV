<cf_get_lang_set module_name="settings">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfif isdefined("attributes.is_form_submitted")>
        <cfset form_varmi = 1>
    <cfelse>
        <cfset form_varmi = 0>
    </cfif>
    <cfparam name="attributes.module" default="">
    <cfparam name="attributes.keyword" default=''>
    <cfparam name="attributes.page" default=1>
    <cfparam name="TRANS_TYPES" default="">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif form_varmi eq 1>
        <cfquery name="GET_PROCESS_CATS" datasource="#dsn3#">
            SELECT 
                SPC.PROCESS_CAT_ID,
                SPC.PROCESS_CAT,
                SPC.PROCESS_TYPE,
                SPC.PROCESS_MODULE,				
                SPC.IS_CARI,
                SPC.IS_ACCOUNT,
                SPC.IS_BUDGET,
                SPC.IS_COST,
                SPC.IS_STOCK_ACTION,
                SPC.IS_PAYMETHOD_BASED_CARI,
                SPC.IS_EXP_BASED_ACC,
                SPC.IS_PARTNER,
                SPC.IS_PUBLIC,
                SPC.IS_ROW_PROJECT_BASED_CARI,
                SPC.SPECIAL_CODE,
                SPC.RECORD_DATE,
                SPC.RECORD_IP,
                SPC.RECORD_EMP,
                SPC.INVOICE_TYPE_CODE,
                SPC.PROFILE_ID, 
                M.MODULE_NAME,
                CASE
                WHEN ACDT.DOCUMENT_TYPE_ID < 0 THEN ACDT.DETAIL
                ELSE ACDT.DOCUMENT_TYPE
            END AS DOCUMENT_TYPE,
                ACPT.PAYMENT_TYPE
            FROM 
                SETUP_PROCESS_CAT SPC
                    LEFT JOIN #dsn_alias#.ACCOUNT_CARD_DOCUMENT_TYPES ACDT ON ACDT.DOCUMENT_TYPE_ID = SPC.DOCUMENT_TYPE
                    LEFT JOIN #dsn_alias#.ACCOUNT_CARD_PAYMENT_TYPES ACPT ON ACPT.PAYMENT_TYPE_ID = SPC.PAYMENT_TYPE,
                #dsn_alias#.MODULES M
            WHERE
                SPC.PROCESS_MODULE = M.MODULE_ID
            <cfif len(attributes.keyword)>
                AND 
                (SPC.PROCESS_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                 <cfif isnumeric(attributes.keyword)>
                     OR SPC.PROCESS_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.keyword#">
                 </cfif>
                 )
            </cfif>
            <cfif len(attributes.module)>
                AND M.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.module#">
            </cfif>
            <cfif isdefined("TRANS_TYPES") and len(TRANS_TYPES)>
                AND
                    (
                    1=1
                    <cfloop list="#TRANS_TYPES#" delimiters="," index="i">
                        <cfif i eq 1>
                            AND	IS_CARI=1 
                        </cfif>
                        <cfif i eq 2>
                            AND IS_CARI=0 
                        </cfif>
                        <cfif i eq 3>
                            AND IS_ACCOUNT=1  
                        </cfif>
                        <cfif i eq 4>
                            AND IS_ACCOUNT=0
                        </cfif>
                        <cfif i eq 5>
                            AND IS_BUDGET=1 
                        </cfif>
                        <cfif i eq 6>
                            AND IS_BUDGET=0
                        </cfif>
                        <cfif i eq 7>
                            AND IS_STOCK_ACTION=1
                        </cfif>
                        <cfif i eq 8>
                            AND IS_STOCK_ACTION=0  
                        </cfif>
                        <cfif i eq 9>
                            AND IS_COST=1  
                        </cfif>
                        <cfif i eq 10>
                            AND IS_COST=0  
                        </cfif>
                    <cfif session.ep.our_company_info.is_efatura>
                        <cfif i eq 11>
                            AND INVOICE_TYPE_CODE='SATIS'  
                        </cfif>
                        <cfif i eq 12>
                            AND INVOICE_TYPE_CODE='IADE'  
                        </cfif>
                        <cfif i eq 13>
                            AND PROFILE_ID='TEMELFATURA'  
                        </cfif>
                        <cfif i eq 14>
                            AND PROFILE_ID='TICARIFATURA'  
                        </cfif>
                    </cfif>
                        <cfif i eq 15>
                            AND IS_PAYMETHOD_BASED_CARI=1
                        </cfif>
                        <cfif i eq 16>
                            AND IS_PAYMETHOD_BASED_CARI=0  
                        </cfif>
                        <cfif i eq 17>
                            AND IS_EXP_BASED_ACC=1  
                        </cfif>
                        <cfif i eq 18>
                            AND IS_EXP_BASED_ACC=0  
                        </cfif>
                    </cfloop>
                    )
            </cfif>
            ORDER BY
                SPC.PROCESS_CAT
        </cfquery>
    <cfelse>
        <cfset GET_PROCESS_CATS.RecordCount = 0>
    </cfif>
    <cfquery name="get_modules" datasource="#dsn#">
        SELECT MODULE_ID, MODULE_NAME FROM MODULES WHERE MODULE_NAME IS NOT NULL ORDER BY MODULE_NAME
    </cfquery>
    <cfscript>
        TRANS_TYPE = QueryNew("TYPE_ID, TYPE_NAME");
    if (session.ep.our_company_info.is_efatura)
        QueryAddRow(TRANS_TYPE,18);
    else
        QueryAddRow(TRANS_TYPE,14);
    
        QuerySetCell(TRANS_TYPE,"TYPE_ID",1,1);
        QuerySetCell(TRANS_TYPE,"TYPE_NAME","#lang_array.item[553]#",1);
        QuerySetCell(TRANS_TYPE,"TYPE_ID",2,2);
        QuerySetCell(TRANS_TYPE,"TYPE_NAME","#lang_array.item[554]#",2);
        QuerySetCell(TRANS_TYPE,"TYPE_ID",3,3);
        QuerySetCell(TRANS_TYPE,"TYPE_NAME","#lang_array.item[565]#",3);
        QuerySetCell(TRANS_TYPE,"TYPE_ID",4,4);
        QuerySetCell(TRANS_TYPE,"TYPE_NAME","#lang_array.item[569]#",4);
        QuerySetCell(TRANS_TYPE,"TYPE_ID",5,5);
        QuerySetCell(TRANS_TYPE,"TYPE_NAME","#lang_array.item[571]#",5);
        QuerySetCell(TRANS_TYPE,"TYPE_ID",6,6);
        QuerySetCell(TRANS_TYPE,"TYPE_NAME","#lang_array.item[583]#",6);
        QuerySetCell(TRANS_TYPE,"TYPE_ID",7,7);
        QuerySetCell(TRANS_TYPE,"TYPE_NAME","#lang_array.item[585]#",7);
        QuerySetCell(TRANS_TYPE,"TYPE_ID",8,8);
        QuerySetCell(TRANS_TYPE,"TYPE_NAME","#lang_array.item[655]#",8);
        QuerySetCell(TRANS_TYPE,"TYPE_ID",9,9);
        QuerySetCell(TRANS_TYPE,"TYPE_NAME","#lang_array.item[656]#",9);
        QuerySetCell(TRANS_TYPE,"TYPE_ID",10,10);
        QuerySetCell(TRANS_TYPE,"TYPE_NAME","#lang_array.item[676]#",10);
        QuerySetCell(TRANS_TYPE,"TYPE_ID",11,11);
        QuerySetCell(TRANS_TYPE,"TYPE_NAME","Ödeme Yöntemi Bazında Cari İşlem Yapar",11);
        QuerySetCell(TRANS_TYPE,"TYPE_ID",12,12);
        QuerySetCell(TRANS_TYPE,"TYPE_NAME","Ödeme Yöntemi Bazında Cari İşlem Yapmaz",12);
        QuerySetCell(TRANS_TYPE,"TYPE_ID",13,13);
        QuerySetCell(TRANS_TYPE,"TYPE_NAME","Hizmet Kalemiyle Muhasebeleştirme Yapar",13);
        QuerySetCell(TRANS_TYPE,"TYPE_ID",14,14);
        QuerySetCell(TRANS_TYPE,"TYPE_NAME","Hizmet Kalemiyle Muhasebeleştirme Yapmaz",14);
        if (session.ep.our_company_info.is_efatura)
        {
            QuerySetCell(TRANS_TYPE,"TYPE_ID",15,15);
            QuerySetCell(TRANS_TYPE,"TYPE_NAME","Fatura Tipi Satış",15);
            QuerySetCell(TRANS_TYPE,"TYPE_ID",16,16);
            QuerySetCell(TRANS_TYPE,"TYPE_NAME","Fatura Tipi İade",16);
            QuerySetCell(TRANS_TYPE,"TYPE_ID",17,17);
            QuerySetCell(TRANS_TYPE,"TYPE_NAME","Senaryo Temel Fatura",17);
            QuerySetCell(TRANS_TYPE,"TYPE_ID",18,18);
            QuerySetCell(TRANS_TYPE,"TYPE_NAME","Senaryo Ticari Fatura",18);
        }
    </cfscript>
    <cfparam name="attributes.totalrecords" default="#GET_PROCESS_CATS.RecordCount#">
    <cfset process_sales_cost_list = "59,76,171,54,55,73,74,62,78,114,115,116,811,591,58,81,113,1131,63,48,50,49,51,110,761,592,1182"><!--- 761 hal irsaliyesi 592 hal fat. IS_COST--->
    <cfset process_stock_list = "171,52,53,54,55,59,62,64,65,66,69,690,591,592,531,532,70,71,72,73,74,75,76,77,78,79,80,81,811,82,83,84,85,86,88,761,110,111,112,113,1131,114,115,116,140,141,120,122,118,1182"><!---IS_STOCK_ACTION--->
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	<cfscript>
        netbook = createObject("component","account.cfc.netbook");
        netbook.dsn = dsn;
        get_account_card_document_types = netbook.getAccountCardDocumentTypes(is_company : 1, is_active : 1);
        get_account_card_payment_types = netbook.getAccountCardPaymentTypes(is_active : 1);
    </cfscript>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>  
	<cfscript>
        netbook = createObject("component","account.cfc.netbook");
        netbook.dsn = dsn;
        get_account_card_document_types = netbook.getAccountCardDocumentTypes(is_company : 1, is_active : 1);
        get_account_card_payment_types = netbook.getAccountCardPaymentTypes(is_active : 1);
    </cfscript>
    <cfset a_hata = 0>
    <cfset b_hata = 0>
    <cfinclude template="../settings/query/get_process_cat.cfm">
    <cfinclude template="../settings/query/get_process_cat_rows.cfm">
    <cfset list_invoice_type_code= ''>
    <cfif session.ep.our_company_info.is_efatura eq 1>
<!---    <cfdump var="#ExpandPath( "./" )#"><cfabort>
--->        <cfset upload_folder = '#ExpandPath( "./" )##dir_seperator#admin_tools#dir_seperator#'>
        <cffile action="read" variable="xmldosyam" file="#upload_folder#xml#dir_seperator#setup_process_cat.xml" charset = "UTF-8">
        <cfset dosyam = XmlParse(xmldosyam)>
        <cfset xml_dizi = dosyam.workcube_process_types.XmlChildren>
        <cfloop from='1' to='#ArrayLen(xml_dizi)#' index='i'>
            <cfif len(dosyam.workcube_process_types.process[i].invoice_type_code.XmlText)>
                <cfset list_invoice_type_code= listappend(list_invoice_type_code,dosyam.workcube_process_types.process[i].process_type.XmlText,',')>
            </cfif>    
        </cfloop>
    </cfif>  
		<cfif listfind('62,52,53,690,592,531,532,64,59,54,55',get_process_cat.process_type)>
			<!--- Faturdan kesilen irsaliyelerde islem tipi belirlenir 20140617 --->
            <cfswitch expression="#get_process_cat.process_type#">
                <cfcase value="62">
                    <!--- alim iade faturasi --->
                    <cfset ship_type_id = 78>
                </cfcase>
                <cfcase value="52">
                    <!--- perakende satis faturasi --->
                    <cfset ship_type_id = 70>
                </cfcase>
                <cfcase value="53">
                    <!--- toptan satis faturasi --->
                    <cfset ship_type_id = 71>
                </cfcase>
                <cfcase value="690">
                    <!--- gider pusulasi (mal) --->
                    <cfset ship_type_id = 84>
                </cfcase>
                <cfcase value="592">
                    <!--- hal faturasi --->
                    <cfset ship_type_id = 761>
                </cfcase>
                <cfcase value="531">
                    <!--- ihracat faturasi --->
                    <cfset ship_type_id = 88>
                </cfcase>
                <cfcase value="532">
                    <!--- konsinye faturasi --->
                    <cfset ship_type_id = 72>
                </cfcase>
                <cfcase value="64">
                    <!--- müsatahsil makbuzu --->
                    <cfset ship_type_id = 80>
                </cfcase>
                <cfcase value="59">
                    <!--- mal alim faturasi --->
                    <cfset ship_type_id = 76>
                </cfcase>
                <cfcase value="54">
                    <!--- perakende satis iade --->
                    <cfset ship_type_id = 73>
                </cfcase>
                <cfcase value="55">
                    <!--- toptan satis iade faturasi --->
                    <cfset ship_type_id = 74>
                </cfcase>
                <cfdefaultcase>
                    <!--- default --->
                    <cfset ship_type_id = "">
                </cfdefaultcase>
            </cfswitch>
            <cfif len(ship_type_id)>
                <cfquery name="get_ship_types" datasource="#dsn3#">
                    SELECT PROCESS_CAT, PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = #ship_type_id#
                </cfquery>
         </cfif>
         </cfif>    
</cfif>

<script type="text/javascript">
//Event : list
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	document.getElementById('keyword').focus();
	function kontrol()
	{
		//Query Tipler için kontrol		
		if((document.getElementById('TRANS_TYPES').options[0].selected== true && document.getElementById('TRANS_TYPES').options[1].selected== true) || (document.getElementById('TRANS_TYPES').options[2].selected== true && document.getElementById('TRANS_TYPES').options[3].selected== true) || 
		(document.getElementById('TRANS_TYPES').options[4].selected== true && document.getElementById('TRANS_TYPES').options[5].selected== true) || (document.getElementById('TRANS_TYPES').options[6].selected== true && document.getElementById('TRANS_TYPES').options[7].selected== true) ||
		(document.getElementById('TRANS_TYPES').options[8].selected== true && document.getElementById('TRANS_TYPES').options[9].selected== true) || (document.getElementById('TRANS_TYPES').options[10].selected== true && document.getElementById('TRANS_TYPES').options[11].selected== true) ||
		(document.getElementById('TRANS_TYPES').options[12].selected== true && document.getElementById('TRANS_TYPES').options[13].selected== true)
		<cfif session.ep.our_company_info.is_efatura>|| 
			(document.getElementById('TRANS_TYPES').options[14].selected== true && document.getElementById('TRANS_TYPES').options[15].selected== true) ||
			(document.getElementById('TRANS_TYPES').options[16].selected== true && document.getElementById('TRANS_TYPES').options[17].selected== true)
		</cfif>
		)
		{
			alert('Kategorileri Kendi Arasında Seçemezsiniz !');
			return false;
		}
		return true;
	}
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	function document_payment_types()
		{
			if(document.getElementById('is_account').checked == true && !(list_find('160,11,12,13',document.form_process_cat.process_type_id.value)))
			{
				document.getElementById('tr_document_type').style.display = '';
				document.getElementById('tr_payment_type').style.display = '';
			}
			else
			{
				document.getElementById('tr_document_type').style.display = 'none';
				document.getElementById('tr_document_type').value = '';
				document.getElementById('tr_payment_type').style.display = 'none';
				document.getElementById('tr_payment_type').value = '';
			}
		}
		function sil_process_cat(param_sil)
		{
			var my_element = eval("document.all.table_row_pcat" + param_sil);
			my_element.disabled=true;
			try{
			my_element.innerHTML = '';//Chrome'da sorun cikartiyordu diye ekledim. Silinen öge tekrar yükleniyordu.
			}catch(e){}
			my_element.style.display = "none";
		}
		function kontrol()
		{
	
			if (form_process_cat.process_type_id.value =="")
			{
				alert("<cf_get_lang no='1259.İşlem Kategorisi Seçiniz'>");
				return false;
			}
			/* ilgili fatura tiplerinde irsaliye tipi secme zorunlulugu */
			if (list_find("62,52,53,690,592,531,591,532,64,59,54,55",document.form_process_cat.process_type_id.value) && document.getElementById('ship_type') != undefined && document.getElementById('ship_type').value == "")
			{
				alert("İrsaliye Tipi Seçiniz!");
				return false;
			}
	
			var obj =  document.form_process_cat.action_file_name.value;
			var obj_template =  document.form_process_cat.action_file_name_template.value;
			extention = list_getat(obj,list_len(obj,'.'),'.');
			extention_template = list_getat(obj_template,list_len(obj_template,'.'),'.');
			if((obj != '' && extention != 'cfm') || (obj_template != '' && extention_template != 'cfm'))
			{
				alert("<cf_get_lang no ='1905.Lütfen Action File İçin cfm Dosyası Seçiniz '>!");
				return false;
			}
	
			var obj2 =  document.form_process_cat.display_file_name.value;
			var obj2_template =  document.form_process_cat.display_file_name_template.value;
			extention2 = list_getat(obj2,list_len(obj2,'.'),'.');
			extention2_template = list_getat(obj2_template,list_len(obj2_template,'.'),'.');
			if((obj2 != '' && extention2 != 'cfm') || (obj2_template != '' && extention2_template != 'cfm'))
			{
				alert("<cf_get_lang no ='2588.Lütfen Display File İçin cfm Dosyası Seçiniz '>!");
				return false;
			}
			if(document.form_process_cat.is_upd_cari_row != undefined && document.form_process_cat.is_upd_cari_row.checked == true && document.form_process_cat.is_cheque_based_action.checked == false)
			{
				alert("Tahsilat Değeri Ekstreyi Günceller Seçeneğini Seçmek İçin Çek ve Senet Bazında Cari İşlem Yapılsın Seçeneği Seçili Olmalıdır ! ");
				return false;
			}
	
			if(document.form_process_cat.is_default!=undefined && document.form_process_cat.is_default.checked==true)
			{
				var listParam = document.form_process_cat.module_id.value + "*" + document.form_process_cat.process_type_id.value;
				if(list_find("51,54,55,59,60,61,63,591",document.form_process_cat.process_type_id.value))// versiyondan tekrar ekledim bu satırı py
					str_default_sql= 'set_get_default_process';
				else if(list_find("50,52,53,56,57,58,62,531",document.form_process_cat.process_type_id.value))
					str_default_sql= 'set_get_default_process_2';
				else if(list_find("73,74,75,76,77",document.form_process_cat.process_type_id.value))
					str_default_sql= 'set_get_default_process_3';
				else if(list_find("70,71,72,78,79",document.form_process_cat.process_type_id.value))
					str_default_sql= 'set_get_default_process_4';
				else if(list_find("140,141",document.form_process_cat.process_type_id.value))
					str_default_sql= 'set_get_default_process_5';
				else
					str_default_sql= 'set_get_default_process_6';
				var get_default_process_ = wrk_safe_query(str_default_sql,'dsn3',0,listParam);
				if(get_default_process_.recordcount)
					if(confirm("Aynı Process Tipli ' " +get_default_process_.PROCESS_CAT+ "' İşlem Kategorisi Default Seçenek Olarak Tanımlanmış.\n Default Seçenek Değiştirilecektir, Değişikliği Kaydetmek İstiyor musunuz?")); else return false;
			}
			<cfif session.ep.our_company_info.is_efatura>
				if(document.getElementById('invoice_type_code').value != '' && document.getElementById('profile_id').value == '')
				{
					alert('Senaryo Seçiniz !');
					return false;
				}
			</cfif>
	
			document.getElementById('invoice_type_code').disabled = false;
	
			return true;
		}
	
		function del_template_action_file()
		{
			form_process_cat.action_file_name.style.display='';
			form_process_cat.action_file_name_template.style.display='none';
			form_process_cat.action_file_name_template.value='';
			value21.style.display='';
			value22.style.display='none';
		}
		function del_template_display_file()
		{
			form_process_cat.display_file_name.style.display='';
			form_process_cat.display_file_name_template.style.display='none';
			form_process_cat.display_file_name_template.value='';
			value11.style.display='';
			value12.style.display='none';
		}
		function change_based_cari(type_info)
		{
			if(type_info == 1)
			{
				document.getElementById('is_paymethod_based_cari').checked = false;
				document.getElementById('is_row_project_based_cari').checked = false;
			}
			else if(type_info == 2)
			{
				document.getElementById('is_due_date_based_cari').checked = false;
				document.getElementById('is_row_project_based_cari').checked = false;
			}
			else
			{
				document.getElementById('is_due_date_based_cari').checked = false;
				document.getElementById('is_paymethod_based_cari').checked = false;
			}
		}
		function change_based_acc(type_info)
		{
			if(type_info == 1)
			{
				if(document.getElementById('is_exp_based_acc') != undefined)
					document.getElementById('is_exp_based_acc').checked = false;
			}
			else if(type_info == 2)
			{
				if(document.getElementById('is_project_based_acc') != undefined)
					document.getElementById('is_project_based_acc').checked = false;
			}
		}
		function addOption(value,text)
		{
			var selectBox = document.getElementById('ship_type');
			if(selectBox.options.length != 1)
				selectBox.options[0]=new Option('<cf_get_lang_main no="322.Seçiniz">','',false,true);
			selectBox.options[selectBox.options.length] = new Option(value,text);
		}
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
	if ($.browser.msie) { // ie8'deki onchange bug'ı için hack
			$(function() {
			  $('input:radio, input:checkbox').click(function() {
				this.blur();
				this.focus();
			  });
			});
		  }
		function document_payment_types()
		{
			if(document.getElementById('is_account').checked == true && !(list_find('160,11,12,13',document.upd_process_cat.process_type.value)))
			{
				document.getElementById('tr_document_type').style.display = '';
				document.getElementById('tr_payment_type').style.display = '';
			}
			else
			{
				document.getElementById('tr_document_type').style.display = 'none';
				document.getElementById('tr_document_type').value = '';
				document.getElementById('tr_payment_type').style.display = 'none';
				document.getElementById('tr_payment_type').value = '';
			}
		}
		function sil_process_cat(param_sil)
		{
			var my_element = eval("document.all.table_row_pcat" + param_sil);
			my_element.style.display = "none";
			try{
			my_element.innerHTML = '';//Chrome'da sorun cikartiyordu diye ekledim. Silinen öge tekrar yükleniyordu.
			}catch(e){}
			my_element.disabled = true;
		}
		function control_action_file()
		{
			if(document.upd_process_cat.is_default!=undefined && document.upd_process_cat.is_default.checked==true)
			{
				var listParam = document.getElementById("process_cat_id").value + "*" + document.upd_process_cat.module_id.value + "*" + document.upd_process_cat.process_type.value;
				if(list_find("51,54,55,59,60,61,63,591",document.upd_process_cat.process_type.value))
					str_default_sql= 'set_get_inventory_7';
				else if(list_find("50,52,53,56,57,58,62,531",document.upd_process_cat.process_type.value))
					str_default_sql= 'set_get_inventory_8';
				else if(list_find("73,74,75,76,77",document.upd_process_cat.process_type.value))
					str_default_sql= 'set_get_inventory_9';
				else if(list_find("70,71,72,78,79",document.upd_process_cat.process_type.value))
					str_default_sql= 'set_get_inventory_10';
				else if(list_find("140,141",document.upd_process_cat.process_type.value))
					str_default_sql= 'set_get_inventory_11';
				else
					str_default_sql= 'set_get_inventory_12';
				var get_default_process_ = wrk_safe_query(str_default_sql,'dsn3',0,listParam);
				if(get_default_process_.recordcount)
						if(confirm("Aynı Process Tipli ' " +get_default_process_.PROCESS_CAT+ "' İşlem Kategorisi Default Seçenek Olarak Tanımlanmış.\n Default Seçenek Değiştirilecektir, Değişikliği Kaydetmek İstiyor musunuz?")); else return false;
			}
			if(document.upd_process_cat.is_upd_cari_row != undefined && document.upd_process_cat.is_upd_cari_row.checked == true && document.upd_process_cat.is_cheque_based_action.checked == false)
			{
				alert("Tahsilat Değeri Ekstreyi Günceller Seçeneğini Seçmek İçin Çek ve Senet Bazında Cari İşlem Yapılsın Seçeneği Seçili Olmalıdır ! ");
				return false;
			}
			var obj =  document.upd_process_cat.action_file_name.value;
			extention = list_getat(obj,list_len(obj,'.'),'.');
			/* ilgili fatura tiplerinde irsaliye tipi secme zorunlulugu */
			if (document.getElementById('ship_type') != undefined && document.getElementById('ship_type').value == "")
			{
				alert("İrsaliye Tipi Seçiniz!");
				return false;
			}
			if(obj != '' && extention != 'cfm')
			{
				alert("<cf_get_lang no ='1905.Lütfen Action File İçin cfm Dosyası Seçiniz '>!");
				return false;
			}
			var obj2 =  document.upd_process_cat.display_file_name.value;
			extention2 = list_getat(obj2,list_len(obj2,'.'),'.');
			if(obj2 != '' && extention2 != 'cfm')
			{
				alert("<cf_get_lang no ='2588.Lütfen Display File İçin cfm Dosyası Seçiniz '>!");
				return false;
			}
	
			<cfif session.ep.our_company_info.is_efatura>
				if(document.getElementById('invoice_type_code').value != '' && document.getElementById('profile_id').value == '')
				{
					alert('Senaryo Seçiniz !');
					return false;
				}
			</cfif>
	
			document.getElementById('invoice_type_code').disabled = false;
	
			return true;
		}
		function del_template_action_file(file_type)
		{
			if(file_type ==1)
			{
				upd_process_cat.action_file_name.style.display='';
				upd_process_cat.action_file_name_template.style.display='none';
				upd_process_cat.action_file_name_template.value='';
				value21.style.display='';
				value22.style.display='none';
			}
			else
			{
				upd_process_cat.display_action_file.value='';
				upd_process_cat.display_action_file.style.display='none';
				display_action_file_id.style.display='none';
				list_action_file_menu.style.display='none';
				list_action_file.style.display='none';
			}
			upd_process_cat.action_file_del.value = 1;
		}
		function del_template_display_file(file_type)
		{
			if(file_type ==1)
			{
				upd_process_cat.display_file_name.style.display='';
				upd_process_cat.display_file_name_template.style.display='none';
				upd_process_cat.display_file_name_template.value='';
				value11.style.display='';
				value12.style.display='none';
			}
			else
			{
				upd_process_cat.display_display_file.value='';
				upd_process_cat.display_display_file.style.display='none';
				display_display_file_id.style.display='none';
				display_upd.style.display='none';
				list_display_file.style.display='none';
			}
			upd_process_cat.display_file_del.value = 1;
		}
		function dosya_guncelle(type)
		{
			if (type==2)//Action File
				{
				document.upd_files.dosya_icerik.value = document.getElementById('action_file_read').value;
					//eğer action file inbox klasöründen yüklenmişse 1 olsun değilse 0
					<cfif get_process_cat.ACTION_FILE_FROM_TEMPLATE eq 1>
						document.upd_files.ftype.value = 1;
					<cfelse>
						document.upd_files.ftype.value = 0;
					</cfif>
				}
			if (type==1)//Display File
				{
				document.upd_files.dosya_icerik.value = document.getElementById('display_file_read').value;
					//eğer action file inbox klasöründen yüklenmişse 1 olsun değilse 0
					<cfif get_process_cat.DISPLAY_FILE_FROM_TEMPLATE eq 1>
						document.upd_files.ftype.value = 1;
					<cfelse>
						document.upd_files.ftype.value = 0;
					</cfif>
				}
			document.upd_files.type.value = type;
			upd_files.submit();
		}
		function change_based_cari(type_info)
		{
			if(type_info == 1)
			{
				document.getElementById('is_paymethod_based_cari').checked = false;
				document.getElementById('is_row_project_based_cari').checked = false;
			}
			else if(type_info == 2)
			{
				document.getElementById('is_due_date_based_cari').checked = false;
				document.getElementById('is_row_project_based_cari').checked = false;
			}
			else
			{
				document.getElementById('is_due_date_based_cari').checked = false;
				document.getElementById('is_paymethod_based_cari').checked = false;
			}
		}
		function change_based_acc(type_info)
		{
			if(type_info == 1)
			{
				if(document.getElementById('is_exp_based_acc') != undefined)
					document.getElementById('is_exp_based_acc').checked = false;
			}
			else if(type_info == 2)
			{
				if(document.getElementById('is_project_based_acc') != undefined)
					document.getElementById('is_project_based_acc').checked = false;
			}
		}
		function addOption(value,text)
		{
			var selectBox = document.getElementById('ship_type');
			if(selectBox.options.length != 1)
				selectBox.options[0]=new Option('<cf_get_lang_main no="322.Seçiniz">','',false,true);
			selectBox.options[selectBox.options.length] = new Option(value,text);
		}
</cfif>
</script>


<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.list_process_cats';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'settings/display/list_process_cats.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.list_process_cats';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'settings/form/add_process_cat.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'settings/query/add_process_cat.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.list_process_cats&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.list_process_cats';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'settings/form/upd_process_cat.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'settings/query/upd_process_cat.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.list_process_cats&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'process_cat_id=##attributes.process_cat_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.process_cat_id##';
	
				
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	
	// Upd //	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=process.emtypopup_dsp_process_cat_file_history&process_cat_id=#attributes.process_cat_id#','wwide1');";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
