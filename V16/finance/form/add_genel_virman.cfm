<cf_xml_page_edit fuseact="finance.list_genel_virman">
<cf_get_lang_set module_name="finance">
<cf_papers paper_type="virman">
<cfparam name="attributes.expense_employee" default="#session.ep.name# #session.ep.surname#">
<cfparam name="attributes.expense_employee_id" default="#session.ep.userid#">
<cfquery name="GET_MONEY" datasource="#dsn#">
    SELECT 
    	CASE 
        	WHEN (DSP_RATE_PUR IS NOT NULL AND DSP_RATE_PUR <> '') THEN
        		DSP_RATE_PUR
       		ELSE
            	RATE2
        END AS RATE2,
        MONEY,
    	RATE1,
        RATE2,
        0 AS IS_SELECTED 
   	FROM
    	SETUP_MONEY 
    WHERE 
    	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#"> AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY_ID
</cfquery>
<cfset expense_bank_id = ''>
<cfset expense_branch_id = ''>
<cfquery name="KASA" datasource="#dsn2#">
	SELECT
		*
	FROM
		CASH
	WHERE
		CASH_ACC_CODE IS NOT NULL
		AND CASH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
		<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
			AND (BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">)
		</cfif>
	ORDER BY
		CASH_NAME
</cfquery>
<cfif isdefined("attributes.virman_id")>
    <cfquery name="get_virman_rows" datasource="#dsn2#">
		SELECT * FROM VIRMAN_ROWS WHERE VIRMAN_ID = #url.virman_id#
	</cfquery>
</cfif>
<cfscript>
	CreateComponent = CreateObject("component","/../workdata/getAccounts");
	queryResult = CreateComponent.getCompenentFunction(is_system_money:0,money_type_control:'',is_branch_control:0,control_status:1,is_open_accounts:0,currency_id_info:'',account_type:0);	
</cfscript>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33756.Vade Tarihi İçin Geçerli Bir Format Giriniz'></cfsavecontent>
<cf_catalystHeader>
<cfform name="add_costplan" method="post" action="V16/finance/cfc/genel_virman.cfc?method=add_genel_virman" onsubmit="return unformat_fields();">
	<cfif isdefined("attributes.keyword")>
		<input type="hidden" name="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" />
		<input type="hidden" name="start_date" value="<cfoutput>#attributes.start_date#</cfoutput>" />
		<input type="hidden" name="finish_date" value="<cfoutput>#attributes.finish_date#</cfoutput>" />
		<input type="hidden" name="action_type_id" value="<cfoutput>#attributes.action_type_id#</cfoutput>" />
	</cfif>
	<cf_box>
		<cf_box_elements vertical="0">
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">	
				<div class="form-group" id="item-process_cat">
					<div class="col col-4 col-xs-12">
						<label><cfoutput>#getLang('main',388)#</cfoutput> *</label>
					</div>
					<div class="col col-8 col-xs-12">
						<cf_workcube_process_cat slct_width="270">
					</div>
				</div>
				<div class="form-group" id="item-process_stage">
					<div class="col col-4 col-xs-12">
						<label><cf_get_lang dictionary_id='58859.Süreç'>*</label>
					</div>
					<div class="col col-8 col-xs-12">
						<cfif isdefined("get_data.process_stage")>
							<cf_workcube_process is_upd='0' select_value='#get_data.process_stage#' is_detail='0'>
						<cfelse>
							<cf_workcube_process is_upd='0' process_cat_width='300' is_detail='0'>
						</cfif>
					</div>
				</div>						
			</div>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-expense_date">
					<div class="col col-4 col-xs-12">
						<label><cf_get_lang dictionary_id='48087.Belge Tarihi'> *</label>
					</div>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='48087.Tarih'>!</cfsavecontent>
							<cfinput type="text" name="expense_date" id="expense_date" required="yes" message="Tarih Seçiniz!" value="#dateformat(now(),'dd/mm/yyyy')#" maxlength="10" style="width:115px;"  onblur="change_money_info('add_costplan','expense_date');">
							<span class="input-group-addon"><cf_wrk_date_image date_field="expense_date" call_function="change_money_info"></span>
						</div>
					</div>
				</div>	
				<div class="form-group" id="item-expense_employee_id">
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<label><cf_get_lang dictionary_id='43121.Kayıt Eden'></label>
					</div>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="expense_employee_id" id="expense_employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
							<input type="hidden" name="expense_employee_type" id="expense_employee_type" value="employee">
							<input type="text" name="expense_employee" id="expense_employee"  onFocus="AutoComplete_Create('expense_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID,MEMBER_TYPE','expense_employee_id,expense_employee_type','','3','135');" value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" autocomplete="off">
							<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_costplan.expense_employee_id&field_name=add_costplan.expense_employee&field_type=add_costplan.expense_employee_type&select_list=1,9','list');" title="<cfoutput>#getLang('main',107)#</cfoutput>"></span>
						</div>
					</div>
				</div>	
			</div>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
				<div class="form-group" id="item-process_cat">
					<div class="col col-4 col-xs-12">
						<label><cf_get_lang dictionary_id='58616.Belge Numarası'></label>
					</div>
					<div class="col col-8 col-xs-12">
						<cfinput type="text" name="virman_no" id="virman_no" value="GAV-#paper_number#"/>
					</div>
				</div>
				<div class="form-group" id="item-detail">
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<label><cfoutput>#getLang('main',217)#</cfoutput></label>
					</div>
					<div class="col col-8 col-xs-12">
						<textarea name="expense_detail" id="expense_detail" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<div class="row">
			<cfset x_row_project_priority_from_product = 0><!--- Satırda Proje Seçilmeden Ürün Seçilemesin --->
			<cfset x_is_add_position_to_asset_list = 0><!--- Varlık Sorumlusu Harcama Yapan Olsun --->
			<cfset x_row_workgroup_project = 0><!--- Satırda Proje Seçilince İş Grubu Otomatik Gelsin --->
			<cfset x_is_project_select = 1><!--- Satırda Ürün Varken Proje Değiştirilebilsin --->
			<cfset x_row_copy_product_info = 1><!--- Satır Kopyalanırken Ürün Bilgileri Taşınsın --->
			<cfset x_row_copy_asset_info = 1><!--- Satır Kopyalanırken Fiziki Varlık Bilgileri Taşınsın --->
			<cfset is_income = 1><!--- Gider/Gelir Kalemi Belirlenir. --->
			<cfinclude template="../../objects/display/list_plan_rows_cost_genel_virman.cfm">
		</div>
	</cf_box>		
</cfform>
<script type="text/javascript">
row_count=parseInt(document.getElementById('record_num').value);
<!---
function kontrol_et()
{
	if(row_count ==0) return false;
	else return true;
}
--->
<cfoutput>
function hesapla(field_name,satir,hesap_type,extra_type)
{
	if(eval("document.add_costplan."+field_name+""+satir)!=undefined && eval("document.add_costplan."+field_name+""+satir).value == "")
		eval("document.add_costplan."+field_name+""+satir).value = 0;
	var toplam_dongu_0 = 0;//satir toplam
	if(document.getElementById("row_kontrol"+satir).value==1)
	{
		if(document.getElementById("total"+satir) != undefined) deger_total = document.getElementById("total"+satir); else deger_total="";//tutar
		if(document.getElementById("quantity"+satir) != undefined) deger_quantity = document.getElementById("quantity"+satir); else deger_quantity="";//miktar
		if(document.getElementById("kdv_total"+satir) != undefined) deger_kdv_total= document.getElementById("kdv_total"+satir); else deger_kdv_total="";//kdv tutarı
		if(document.getElementById("otv_total"+satir) != undefined) deger_otv_total= document.getElementById("otv_total"+satir); else deger_otv_total="";//ötv tutarı
		if(document.getElementById("net_total"+satir) != undefined) deger_net_total = document.getElementById("net_total"+satir); else deger_net_total="";//kdvli tutar
		if(document.getElementById("tax_rate"+satir) != undefined) deger_tax_rate = document.getElementById("tax_rate"+satir); else deger_tax_rate="";//kdv oranı
		if(document.getElementById("otv_rate"+satir) != undefined) deger_otv_rate = document.getElementById("otv_rate"+satir); else deger_otv_rate="";//ötv oranı
		if(document.getElementById("other_net_total"+satir) != undefined) deger_other_net_total = document.getElementById("other_net_total"+satir); else deger_other_net_total="";//dovizli tutar kdv dahil
		if(document.getElementById("money_id"+satir) != undefined)
		{
			deger_money_id = document.getElementById("money_id"+satir);
			deger_money_id =  list_getat(deger_money_id.value,1,',');
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				money_deger =list_getat(document.all.rd_money[s-1].value,1,',');
				if(money_deger == deger_money_id)
				{
					deger_diger_para_satir = document.all.rd_money[s-1];
					form_value_rate_satir = document.getElementById("txt_rate2_"+s);
				}
			}
			deger_para_satir = list_getat(deger_diger_para_satir.value,3,',');
		}
		else
		{
			deger_money_id="";
			deger_para_satir="";
			form_value_rate_satir="";
		}
		if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
		if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#'); else deger_quantity.value = 1;
		if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
		if(deger_otv_total != "") deger_otv_total.value = filterNum(deger_otv_total.value,'#xml_satir_number#');
		if(deger_net_total != "") deger_net_total.value = filterNum(deger_net_total.value,'#xml_satir_number#');
		if(deger_other_net_total != "") deger_other_net_total.value = filterNum(deger_other_net_total.value,'#xml_satir_number#');
		if(hesap_type ==undefined)
		{
			if(deger_kdv_total != "" && deger_total != "") deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)) * deger_tax_rate.value)/100;
			if(deger_otv_total != "" && deger_total != "") deger_otv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)) * deger_otv_rate.value)/100;
		}
		else if(hesap_type == 2)
		{
			if(deger_total != "" && deger_tax_rate != "" && deger_otv_rate != "") deger_total.value = ((parseFloat(deger_net_total.value)/parseFloat(deger_quantity.value))*100)/ (parseFloat(deger_tax_rate.value)+parseFloat(deger_otv_rate.value)+100);
			if(deger_kdv_total != "" && deger_total != "") deger_kdv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_tax_rate.value))/100;
			if(deger_otv_total != "" && deger_total != "") deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_otv_rate.value))/100;
		}
		toplam_dongu_0 = parseFloat(deger_total.value * deger_quantity.value);
		if(deger_kdv_total != "") toplam_dongu_0 = toplam_dongu_0 + parseFloat(deger_kdv_total.value);
		if(deger_otv_total != "") toplam_dongu_0 = toplam_dongu_0 + parseFloat(deger_otv_total.value);
		//if(deger_other_net_total != undefined) deger_other_net_total.value = ((parseFloat(deger_total.value * deger_quantity.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value)) * parseFloat(deger_para_satir) / (parseFloat(form_value_rate_satir.value)));
		if(deger_other_net_total != "") deger_other_net_total.value = ((toplam_dongu_0) * parseFloat(deger_para_satir) / (parseFloat(form_value_rate_satir.value)));
		if(deger_net_total != "") deger_net_total.value = commaSplit(toplam_dongu_0,'#xml_satir_number#');
		if(deger_total != "") deger_total.value = commaSplit(deger_total.value,'#xml_satir_number#');
		if(deger_quantity != "") deger_quantity.value = commaSplit(deger_quantity.value,'#xml_satir_number#');
		if(deger_kdv_total != "") deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#xml_satir_number#');
		if(deger_otv_total != "") deger_otv_total.value = commaSplit(deger_otv_total.value,'#xml_satir_number#');
		if(deger_other_net_total != "") deger_other_net_total.value = commaSplit(deger_other_net_total.value,'#xml_satir_number#');
	}
	if(extra_type == undefined)
		toplam_hesapla();
		MoneyClass();
}
function toplam_hesapla()
{
	var toplam_dongu_1 = 0;//tutar genel toplam
	var toplam_dongu_2 = 0;// kdv genel toplam
	var toplam_dongu_3 = 0;// kdvli genel toplam
	var toplam_dongu_4 = 0;// ötv genel toplam
	var toplam_borc = 0;
	var toplam_alacak = 0;
	doviz_hesapla();
	for(r=1; r<= document.getElementById("record_num").value;r++)
	{
		if(document.getElementById("row_kontrol"+r).value==1)
		{
			if(document.getElementById("total"+r) != undefined) deger_total = document.getElementById("total"+r); else deger_total="";//tutar
			if(document.getElementById("quantity"+r) != undefined) deger_quantity = document.getElementById("quantity"+r); else deger_quantity="";//miktar
			if(document.getElementById("kdv_total"+r) != undefined) deger_kdv_total= document.getElementById("kdv_total"+r); else deger_kdv_total="";//kdv tutarı
			if(document.getElementById("otv_total"+r) != undefined) deger_otv_total= document.getElementById("otv_total"+r); else deger_otv_total="";//ötv tutarı
			if(document.getElementById("net_total"+r) != undefined) deger_net_total = document.getElementById("net_total"+r); else deger_net_total="";//kdvli tutar
			if(document.getElementById("tax_rate"+r) != undefined) deger_tax_rate = document.getElementById("tax_rate"+r); else deger_tax_rate="";//kdv oranı
			if(document.getElementById("otv_rate"+r) != undefined) deger_otv_rate = document.getElementById("otv_rate"+r); else deger_otv_rate="";//ötv oranı
			if(document.getElementById("other_net_total"+r) != undefined) deger_other_net_total = document.getElementById("other_net_total"+r); else deger_other_net_total="";//dovizli tutar kdv dahil
		
			if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
			if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#');
			if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
			
			if(document.getElementById("ba"+r) != undefined)
			{
				if(document.getElementById("ba"+r).value==0)
				{
					toplam_borc = toplam_borc + parseFloat(deger_total.value);
				}
				if(document.getElementById("ba"+r).value==1)
				{
					toplam_alacak = toplam_alacak + parseFloat(deger_total.value);
				}
			}
			if(document.getElementById("tax_rate"+r) != undefined && document.getElementById("kdv_total"+r) != undefined)
			{
				if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true && document.getElementById("expense_cost_type").value != 122)
				{//tevkifat hesaplamaları
					
					beyan_tutar = beyan_tutar + wrk_round(deger_kdv_total.value*filterNum(document.getElementById("tevkifat_oran").value)/100);
					if(new_taxArray.length != 0)
						for (var m=0; m < new_taxArray.length; m++)
						{	
							var tax_flag = false;
							if(new_taxArray[m] == deger_tax_rate.value){
								tax_flag = true;
								taxBeyanArray[m] += wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value)/100)));
								taxTevkifatArray[m] += wrk_round(deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value)/100));
								break;
							}
						}
					if(!tax_flag){
						new_taxArray[new_taxArray.length] = deger_tax_rate.value;
						taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value)/100)));
						taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value)/100));
					}
				}
			}
			if(deger_otv_total != "") deger_otv_total.value = filterNum(deger_otv_total.value,'#xml_satir_number#');
			if(deger_net_total != "") deger_net_total.value = filterNum(deger_net_total.value,'#xml_satir_number#');
			if(deger_total != "") toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_quantity.value);
			if(deger_kdv_total != "") toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value);
			if(deger_otv_total != "") toplam_dongu_4 = toplam_dongu_4 + parseFloat(deger_otv_total.value);
			if(deger_total != "") toplam_dongu_3 = toplam_dongu_3 + (parseFloat(deger_total.value * deger_quantity.value));
			if(deger_kdv_total != "") toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_kdv_total.value);
			if(deger_otv_total != "") toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_otv_total.value);
			if(deger_net_total != "") deger_net_total.value = commaSplit(deger_net_total.value,'#xml_satir_number#');
			if(deger_total != "") deger_total.value = commaSplit(deger_total.value,'#xml_satir_number#');
			if(deger_quantity != "") deger_quantity.value = commaSplit(deger_quantity.value,'#xml_satir_number#');
			if(deger_kdv_total != "") deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#xml_satir_number#');
			if(deger_otv_total != "") deger_otv_total.value = commaSplit(deger_otv_total.value,'#xml_satir_number#');
			<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),6)>
			if(document.getElementById("product_id"+r) != undefined && document.getElementById("product_id"+r) != '')
					view_product_info(r);
			</cfif>
		}
	}
	
	document.getElementById("borc_toplam").value = commaSplit(toplam_borc,'#xml_genel_number#');
	document.getElementById("alacak_toplam").value = commaSplit(toplam_alacak,'#xml_genel_number#');
	
	<!---document.getElementById("total_amount").value = commaSplit(toplam_dongu_1,'#xml_genel_number#');
	document.getElementById("kdv_total_amount").value = commaSplit(toplam_dongu_2,'#xml_genel_number#');
	document.getElementById("net_total_amount").value = commaSplit(toplam_dongu_3,'#xml_genel_number#');--->
	for(s=1;s<=document.getElementById("kur_say").value;s++)
	{
		form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
		if(form_txt_rate2_.value == "")
			form_txt_rate2_.value = 1;
	}
	if(document.getElementById("kur_say").value == 1)
		for(s=1;s<=document.getElementById("kur_say").value;s++)
		{
			if(document.add_costplan.rd_money[s-1].checked == true)
			{
				deger_diger_para = document.getElementById("rd_money");
				form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
			}
		}
	else 
		for(s=1;s<=document.getElementById("kur_say").value;s++)
		{
			if(document.add_costplan.rd_money[s-1] != undefined && document.add_costplan.rd_money[s-1].checked == true)
			{
				deger_diger_para = document.add_costplan.rd_money[s-1];
				form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
			}
		}
	deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
	deger_money_id_2 = list_getat(deger_diger_para.value,2,',');
	deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
	form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'#xml_genel_number#');
	<!---document.getElementById("other_total_amount").value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#xml_genel_number#')),'#xml_genel_number#');
	document.getElementById("other_kdv_total_amount").value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#xml_genel_number#')),'#xml_genel_number#');
	document.getElementById("other_net_total_amount").value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#xml_genel_number#')),'#xml_genel_number#');
	document.getElementById("tl_value1").value = deger_money_id_1;
	document.getElementById("tl_value2").value = deger_money_id_1;
	document.getElementById("tl_value3").value = deger_money_id_1; --->
	form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'#xml_genel_number#');
	MoneyClass();
}
function doviz_hesapla(type)
{
	for(k=1;k<=document.getElementById("record_num").value;k++)
	{		
		if(document.getElementById("money_id"+k) != undefined)
		{
			deger_money_id = document.getElementById("money_id"+k);
			deger_money_id =  list_getat(deger_money_id.value,1,',');
			for (var t=1; t<=document.getElementById("kur_say").value; t++)
			{
				money_deger =list_getat(document.add_costplan.rd_money[t-1].value,1,',');
				if(money_deger == deger_money_id)	
				{						
					rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'#xml_satir_number#')/filterNum(document.getElementById("txt_rate1_"+t).value,'#xml_satir_number#');
					document.getElementById("other_net_total"+k).value = commaSplit(filterNum(document.getElementById("net_total"+k).value,'#xml_satir_number#')/rate2_value,'#xml_satir_number#');
				}
			}
		}
	}
}
</cfoutput>
function kontrol()
{
	deger = add_costplan.process_cat.options[add_costplan.process_cat.selectedIndex].value;
	if(deger == '')
	{
		alert("<cf_get_lang dictionary_id='58770.İşlem Tipi Seçmelisiniz'> !");
		return false;
	}
	var aktif_s = 0;
	row_count=parseInt(document.getElementById('record_num').value);
	for(var i=1;i<=row_count;i++)
	{	
		if(document.getElementById("row_kontrol"+i).value==1)
		{
			aktif_s++;
			if((document.getElementById("action_type"+i).value == 1) && (document.getElementById("banka"+i).value == ''))
			{
				alert(aktif_s + ". Satır Banka Seçiniz!");
				return false;
			}
			else if((document.getElementById("action_type"+i).value == 2) && (document.getElementById("kasa"+i).value == ''))
			{
				alert(aktif_s + ". Satır Kasa Seçmelisiniz!");
				return false;
			}
			else if((document.getElementById("action_type"+i).value == 3) && (document.getElementById("ch_account_code"+i).value == ''))
			{
				alert(aktif_s + ". Satır Cari Seçmelisiniz!");
				return false;
			}
			else if(document.getElementById("action_type"+i).value == '' && (document.getElementById("expense_item_id"+i).value == '' || document.getElementById("expense_item_name"+i).value == ''))
			{
				alert(aktif_s + ". Satır Gider Kalemi Seçmelisiniz! ");
				return false;
			} 
			else if((document.getElementById("action_type"+i).value == 4) && (document.getElementById("account_code"+i).value == ''))
			{
				alert(aktif_s + ". Muhasebe Kodu Seçiniz!");
				return false;
			}
			else if(document.getElementById("action_type"+i).value == '' && document.getElementById("account_code"+i).value == '')
			{
				alert(aktif_s + ". Satır Muhasebe Kodu Seçmelisiniz! ");
				return false;
			} 
			else if(document.getElementById("action_type"+i).value == '' && (document.getElementById("expense_center_id"+i).value == ''|| document.getElementById("expense_center_name"+i).value == ''))
			{
				alert(aktif_s + ". Satır Masraf Merkezi Seçmelisiniz! ");
				return false;
			} 
			else if(document.getElementById("row_detail"+i).value == '')
			{
				alert(aktif_s + ". Satır Açıklama Girmelisiniz! ");
				return false;
			} 			
		}
	}

	if(document.getElementById("expense_employee_id").value == "")
	{
		alert("<cf_get_lang dictionary_id='33486.Lütfen Tahsil Eden Giriniz'>");
		return false;
	}
	if(document.getElementById("expense_date").value == "")
	{
		alert("<cf_get_lang dictionary_id='33454.Lütfen Harcama Tarihi Giriniz'>!");
		return false;
	}
	var paper_control = wrk_safe_query('get_virman_paper','dsn2' , 0, document.getElementById('virman_no').value);
	if(paper_control.recordcount){
		alert("<cf_get_lang dictionary_id='33711.Bu belge numarası kullanılmıştır'>");
		return false;

	}
	record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
	for(r=1;r<=document.getElementById("record_num").value;r++)
	{
		deger_row_kontrol = document.getElementById("row_kontrol"+r);
		if(document.getElementById("expense_center_id"+r) != undefined) deger_expense_center_id = document.getElementById("expense_center_id"+r); else deger_expense_center_id ="";
		if(document.getElementById("expense_item_id"+r) != undefined) deger_expense_item_id = document.getElementById("expense_item_id"+r); else deger_expense_item_id = "";
		if(document.getElementById("row_detail"+r) != undefined) deger_row_detail = document.getElementById("row_detail"+r); else deger_row_detail = "";
		if(document.getElementById("authorized"+r) != undefined) harcama_yapan = document.getElementById("authorized"+r); else harcama_yapan="";
		if(document.getElementById("company"+r) != undefined) harcama_yapan_firma = document.getElementById("company"+r); else harcama_yapan_firma="";
		deger_total = document.getElementById("total"+r);
		
		if(deger_row_kontrol.value == 1)
		{
		    record_exist=1;

			if (deger_row_detail == "")
			{ 
				alert ("<cf_get_lang dictionary_id='33463.Lütfen Açıklama Giriniz'>");
				return false;
			}
			if (parseFloat(filterNum(deger_total.value)) == 0 || deger_total.value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz'>");
				return false;
			}
		}
	}
	if (record_exist == 0) 
	{
		alert("Satır Eklemelisiniz!");
		return false;
	}
}
function unformat_fields()
{
	<cfoutput>
	for(r=1;r<=document.getElementById("record_num").value;r++)
	{
		if(document.getElementById("total"+r) != undefined) deger_total = document.getElementById("total"+r); else deger_total="";
		if(document.getElementById("quantity"+r) != undefined) deger_quantity = document.getElementById("quantity"+r); else deger_quantity="";
		if(document.getElementById("kdv_total"+r) != undefined) deger_kdv_total= document.getElementById("kdv_total"+r); else deger_kdv_total="";
		if(document.getElementById("otv_total"+r) != undefined) deger_otv_total= document.getElementById("otv_total"+r); else deger_otv_total="";
		if(document.getElementById("net_total"+r) != undefined) deger_net_total = document.getElementById("net_total"+r); else deger_net_total="";
		if(document.getElementById("other_net_total"+r) != undefined) deger_other_net_total = document.getElementById("other_net_total"+r); else deger_other_net_total="";
		
		if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
		if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#');
		if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
		if(deger_otv_total != "") deger_otv_total.value = filterNum(deger_otv_total.value,'#xml_satir_number#');
		if(deger_net_total != "") deger_net_total.value = filterNum(deger_net_total.value,'#xml_satir_number#');
		if(deger_other_net_total != "") deger_other_net_total.value = filterNum(deger_other_net_total.value,'#xml_satir_number#');
	}
	<!---document.getElementById("total_amount").value = filterNum(document.getElementById("total_amount").value,'#xml_genel_number#');
	document.getElementById("kdv_total_amount").value = filterNum(document.getElementById("kdv_total_amount").value,'#xml_genel_number#');
	document.getElementById("net_total_amount").value = filterNum(document.getElementById("net_total_amount").value,'#xml_genel_number#');
	document.getElementById("other_total_amount").value = filterNum(document.getElementById("other_total_amount").value,'#xml_genel_number#');
	document.getElementById("other_kdv_total_amount").value = filterNum(document.getElementById("other_kdv_total_amount").value,'#xml_genel_number#');
	document.getElementById("other_net_total_amount").value = filterNum(document.getElementById("other_net_total_amount").value,'#xml_genel_number#');--->
	for(s=1;s<=document.getElementById("kur_say").value;s++)
	{
		document.getElementById("txt_rate2_" + s).value = filterNum(document.getElementById("txt_rate2_" + s).value,'#xml_genel_number#');
		document.getElementById("txt_rate1_" + s).value = filterNum(document.getElementById("txt_rate1_" + s).value,'#xml_genel_number#');
	}
<!---
	<cfif not (browserdetect() contains 'MSIE') or (browserdetect() contains 'MSIE' and browserdetect() contains '9')>
		for(i=1;i<=document.all.record_num.value-row_count_ilk;i++)
		{
			var satir_ = i + row_count_ilk;
			document.add_costplan.appendChild(document.getElementById("row_kontrol" + satir_));
			document.add_costplan.appendChild(document.getElementById("row_detail" + satir_));
			document.add_costplan.appendChild(document.getElementById("expense_center_id" + satir_));
			document.add_costplan.appendChild(document.getElementById("expense_center_name" + satir_));
			document.add_costplan.appendChild(document.getElementById("expense_item_id" + satir_));
			document.add_costplan.appendChild(document.getElementById("expense_item_name" + satir_));
			document.add_costplan.appendChild(document.getElementById("account_code" + satir_));
			if(document.getElementById("expense_date" + satir_) != undefined)
				document.add_costplan.appendChild(document.getElementById("expense_date" + satir_));
			if(document.getElementById("project_id" + satir_) != undefined && document.getElementById("project" + satir_) != undefined)
			{
				document.add_costplan.appendChild(document.getElementById("project_id" + satir_));
				document.add_costplan.appendChild(document.getElementById("project" + satir_));
			}
			if(document.getElementById("product_id" + satir_) != undefined && document.getElementById("product_name" + satir_) != undefined)
			{
				document.add_costplan.appendChild(document.getElementById("product_id" + satir_));
				document.add_costplan.appendChild(document.getElementById("stock_id" + satir_));
				document.add_costplan.appendChild(document.getElementById("product_name" + satir_));
			}
			if(document.getElementById("stock_unit" + satir_) != undefined)
			{
				document.add_costplan.appendChild(document.getElementById("stock_unit" + satir_));
				document.add_costplan.appendChild(document.getElementById("stock_unit_id" + satir_));
			}
			document.add_costplan.appendChild(document.getElementById("quantity" + satir_));
			document.add_costplan.appendChild(document.getElementById("total" + satir_));
			document.add_costplan.appendChild(document.getElementById("tax_rate" + satir_));
			document.add_costplan.appendChild(document.getElementById("otv_rate" + satir_));
			document.add_costplan.appendChild(document.getElementById("kdv_total" + satir_));
			document.add_costplan.appendChild(document.getElementById("otv_total" + satir_));
			document.add_costplan.appendChild(document.getElementById("net_total" + satir_));
			document.add_costplan.appendChild(document.getElementById("money_id" + satir_));
			document.add_costplan.appendChild(document.getElementById("other_net_total" + satir_));
			if(document.getElementById("activity_type" + satir_) != undefined)
				document.add_costplan.appendChild(document.getElementById("activity_type" + satir_));
			if(document.getElementById("subscription_id" + satir_) != undefined && document.getElementById("subscription_name" + satir_) != undefined)
			{
				document.add_costplan.appendChild(document.getElementById("subscription_id" + satir_));
				document.add_costplan.appendChild(document.getElementById("subscription_name" + satir_));
			}
			document.add_costplan.appendChild(document.getElementById("member_type" + satir_));
			document.add_costplan.appendChild(document.getElementById("member_id" + satir_));
			document.add_costplan.appendChild(document.getElementById("company_id" + satir_));
			document.add_costplan.appendChild(document.getElementById("authorized" + satir_));
			document.add_costplan.appendChild(document.getElementById("company" + satir_));
			if(document.getElementById("asset_id" + satir_) != undefined && document.getElementById("asset" + satir_) != undefined)
			{
				document.add_costplan.appendChild(document.getElementById("asset_id" + satir_));
				document.add_costplan.appendChild(document.getElementById("asset" + satir_));
			}
			if(document.getElementById("workgroup_id" + satir_) != undefined)
				document.add_costplan.appendChild(document.getElementById("workgroup_id" + satir_));
			if(document.getElementById("work_id" + satir_) != undefined && document.getElementById("work_head" + satir_) != undefined)
			{
				document.add_costplan.appendChild(document.getElementById("work_id" + satir_));
				document.add_costplan.appendChild(document.getElementById("work_head" + satir_));
			}
			if(document.getElementById("opp_id" + satir_) != undefined && document.getElementById("opp_head" + satir_) != undefined)
			{
				document.add_costplan.appendChild(document.getElementById("opp_id" + satir_));
				document.add_costplan.appendChild(document.getElementById("opp_head" + satir_));
			}
		}
	</cfif>
--->
	</cfoutput>
}

<!---
function change_due_date(type)
{
	if (type==1)
	{
		document.getElementById("basket_due_value").value = datediff(document.getElementById("expense_date").value,document.getElementById("basket_due_value_date_").value,0);
	}
	else
	{
		if(isNumber(document.getElementById("basket_due_value"))!= false && (document.getElementById("basket_due_value").value != 0))
			document.getElementById("basket_due_value_date_").value = date_add('d',+document.getElementById("basket_due_value").value,document.getElementById("expense_date").value);
		else
			document.getElementById("basket_due_value_date_").value = document.getElementById("expense_date").value;
	}
}
--->
toplam_hesapla();
MoneyClass();

<cfoutput>
	function other_calc(row_info,type_info)
	{
		if(row_info != undefined)
		{
			if(document.getElementById("row_kontrol"+row_info).value==1)
			{
				deger_money_id = list_getat(document.getElementById("money_id"+row_info).value,1,',');
				for(kk=1; kk<= document.getElementById("kur_say").value;kk++)
				{
					money_deger =list_getat(document.all.rd_money[kk-1].value,1,',');
					if(money_deger == deger_money_id)
					{
						deger_diger_para_satir = document.all.rd_money[kk-1];
						form_value_rate_satir = document.getElementById("txt_rate2_"+kk);
					}
				}
				document.getElementById("other_net_total"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
				document.getElementById("total"+row_info).value = document.getElementById("other_net_total"+row_info).value*filterNum(form_value_rate_satir.value,'#xml_satir_number#');
				document.getElementById("other_net_total"+row_info).value = commaSplit(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
				document.getElementById("total"+row_info).value = commaSplit(document.getElementById("total"+row_info).value,'#xml_satir_number#');
			}
			if(type_info==undefined)
				hesapla('other_net_total',row_info,2);
			else
				hesapla('other_net_total',row_info,2,1);
		}
		else
		{
			for(yy=1; yy<= document.getElementById("record_num").value;yy++)
			{	
				if(document.getElementById("row_kontrol"+yy).value==1)
				{
					other_calc(yy,1);
				}
			}
			toplam_hesapla();
		}
	}
</cfoutput>

function MoneyClass(){
	deger_artis =  { <cfoutput query="get_money"> #money# : { money : 0.0, counter : 0 , system_money : 0.0 , system_money_counter : 0 } ,</cfoutput> };
	var default_deger = [];
		for(var i in deger_artis) default_deger.push([i, deger_artis[i]]);

		default_deger.forEach( (e) => {
			$('#deger_artis_'+e[0]).val(0).parent().find("span.input-group-addon > strong").html(0);
		});
	i=0;
	$('select.money_class').each(function() {
		i++;
		var selectName = $("select[name=money_id"+i+"]").val();
		var total_value = parseFloat(filterNum($("input[id=other_net_total"+i+"]").val(),<cfoutput>#xml_satir_number#</cfoutput>));
		type = selectName.split(',')[0];
		deger_artis[type]["money"] += total_value;
		deger_artis["<cfoutput>#session.ep.money#</cfoutput>"]["system_money"] += total_value / filterNum($("input[money_type=<cfoutput>#session.ep.money#</cfoutput>]").val()) * filterNum($("input[money_type="+type+"]").val()); 
		deger_artis[type]["counter"] ++;
		deger_artis["<cfoutput>#session.ep.money#</cfoutput>"]["system_money_counter"]++;		 
		$('#deger_artis_'+type).val(commaSplit(deger_artis[type]["money"],<cfoutput>#xml_satir_number#</cfoutput>)).parent().find("span.input-group-addon > strong").html(deger_artis[type]["counter"]);

	});

 	$("#deger_artis_system").val(commaSplit(deger_artis["<cfoutput>#session.ep.money#</cfoutput>"]["system_money"],2)).parent().find("span.input-group-addon > strong").html(deger_artis["<cfoutput>#session.ep.money#</cfoutput>"]["system_money_counter"]);

	};
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
