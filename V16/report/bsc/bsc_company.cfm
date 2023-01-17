<cfparam name="attributes.module_id_control" default="4">
<cfinclude template="../../report/standart/report_authority_control.cfm">
<cfparam name="attributes.sales_position_code" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.graph_type" default="">
<cfparam name="attributes.modal_id" default="">


<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
</cfif>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME
	FROM 
		BRANCH
	WHERE 
		BRANCH_STATUS = 1 AND
		BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		BRANCH_NAME
</cfquery>

	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#getLang('','Üye/Çalışan Raporu',55642)#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
			<cfform name="search_form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
				<cf_box_search>
					<cfif session.ep.ehesap>
						<cfoutput>
							<div class="form-group" id="employee_id">
								<div class="input-group">     
									<input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.employee)>#attributes.employee_id#</cfif>">
									<input type="text" name="employee" id="employee" placeholder="#getLang('main',164)#" onFocus="AutoComplete_Create('employee','FULLNAME','FULLNAME','get_emp_pos','','employee_id','employee_id','','3','120');" value="<cfif len(attributes.employee)>#attributes.employee#</cfif>" style="width:100px;">	
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="kontrol(2);openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=search_form.employee_id&field_name=search_form.employee&select_list=1,9');"></span>		   
								</div>
							</div>  
						</cfoutput>
					</cfif>
					<div class="form-group" id="item-start_date">
						<div class="input-group"> 
							<cfsavecontent variable="message"><cf_get_lang_main no='1333.Başlama Tarihi Girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
						</div>
					</div>   
					<div class="form-group" id="item-finish_date">
						<div class="input-group">         
							<cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz '></cfsavecontent>
							<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
						</div>
					<div class="form-group">       
						<cf_wrk_search_button button_type='4' search_function="control()">
					</div>
				</cf_box_search>
				<cf_box_search_detail search_function="control()">
					<cfif isdefined('attributes.is_popup')>
						<script type="text/javascript">
							document.search_form.action = "<cfoutput>#request.self#</cfoutput>?fuseaction=report.popup_bsc_company&is_popup=1"
						</script>
					</cfif>
					<cfoutput>
					<!-- sil -->
						<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
							<div class="form-group" id="item-member_name">
								<label>#getLang('main',246)#</label>
								<div class="input-group"> 
									<input type="hidden" name="partner_id" id="partner_id" value="<cfif len(attributes.member_name) and len(attributes.partner_id)>#attributes.partner_id#</cfif>">	
									<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.member_name) and len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">	
									<input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.member_name) and len(attributes.company_id)>#attributes.company_id#</cfif>">
									<cfsavecontent  variable="variable"><cf_get_lang dictionary_id="57734.Seçiniz">
									</cfsavecontent>
									<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")>#attributes.member_type#</cfif>">
									<input type="text" name="member_name" placeholder="#variable#" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0,0','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE,PARTNER_ID','consumer_id,company_id,member_type,partner_id','','3','250');" id="member_name" value="<cfif len(attributes.member_name)>#attributes.member_name#</cfif>" style="width:175px;">
									<cfset str_linke_ait="&field_consumer=search_form.consumer_id&field_comp_id=search_form.company_id&field_member_name=search_form.member_name&field_type=search_form.member_type&field_partner=search_form.partner_id">
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="kontrol(1);openBoxDraggable('#request.self#?fuseaction=objects.popup_list_all_pars#str_linke_ait#&select_list=7,8&keyword='+encodeURIComponent(document.search_form.member_name.value));"></span>
								</div>
							</div>   
							<div class="form-group" id="item-graph_type">
								<label><cf_get_lang no='59.Grafik'></label>
								<select name="graph_type" id="graph_type">
									<option value="pie"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
									<option value="pie" <cfif attributes.graph_type is 'pie'>selected</cfif>><cf_get_lang_main no='1316.Pasta'></option>
									<option value="bar" <cfif attributes.graph_type is 'bar'>selected</cfif>><cf_get_lang_main no='251.Bar'></option>
								</select>
							</div>
							<div class="form-group" id="item-branch_id">
								<label><cfoutput>#getLang('main',41)#</cfoutput></label>
								<select name="branch_id" id="branch_id" multiple>
									<cfloop query="get_branch">
									<option value="#branch_id#"<cfif listfind(attributes.branch_id,branch_id)> selected</cfif>>#branch_name#</option>
									</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12">
							<label>	<input name="check_all" id="check_all" type="checkbox" value="1" <cfif isdefined("attributes.check_all") and attributes.check_all eq 1>checked</cfif>><b><cf_get_lang_main no ='669.Hepsi'></label>
							<label>	<input name="finance" id="finance" type="checkbox" value="1" <cfif isdefined("attributes.finance") and attributes.finance eq 1>checked</cfif>> <cf_get_lang_main no='673.Finansal Özet'> </label>
							<label>	<input name="activity_summary" id="activity_summary" type="checkbox" value="1" <cfif isdefined("attributes.activity_summary") and attributes.activity_summary eq 1>checked</cfif>> <cf_get_lang_main no='509.Cari Faaliyet Özeti'> </label>
							<label>	<input name="sale_invoice" id="sale_invoice" type="checkbox" value="1" <cfif isdefined("attributes.sale_invoice") and attributes.sale_invoice eq 1>checked</cfif>> <cf_get_lang no='783.Satış Faturaları'> </label>
							<label>	<input name="sale_order" id="sale_order" type="checkbox" value="1" <cfif isdefined("attributes.sale_order") and attributes.sale_order eq 1>checked</cfif>> <cf_get_lang_main no='795.Satış Siparişleri'> </label>
							<label><input name="sale_offer" id="sale_offer" type="checkbox" value="1" <cfif isdefined("attributes.sale_offer") and attributes.sale_offer eq 1>checked</cfif>> <cf_get_lang_main no='2210.Satış Teklifleri'> </label>
							<label><input name="opportunity" id="opportunity" type="checkbox" value="1" <cfif isdefined("attributes.opportunity") and attributes.opportunity eq 1>checked</cfif>> <cf_get_lang no='791.Satış Fırsatları'> </label>
							<label><input name="service" id="service" type="checkbox" value="1" <cfif isdefined("attributes.service") and attributes.service eq 1>checked</cfif>> <cf_get_lang_main no='2242.Servis Başvuruları'></label>
							<label><input name="system" id="system" type="checkbox" value="1" <cfif isdefined("attributes.system") and attributes.system eq 1>checked</cfif>> <cf_get_lang no='794.Sistemler'>/<cf_get_lang no='795.Abonelikler'></label>
							<label><input name="event" id="event" type="checkbox" value="1" <cfif isdefined("attributes.event") and attributes.event eq 1>checked</cfif>> <cf_get_lang no='797.Toplantı ve Ziyaretler'> </label>
							<label><input name="sale_category" id="sale_category" type="checkbox" value="1" <cfif isdefined("attributes.sale_category") and attributes.sale_category eq 1>checked</cfif>><cf_get_lang no='1143.Kategorilere Göre Satışlar'></label>
							<label><input name="sale_product" id="sale_product" type="checkbox" value="1" <cfif isdefined("attributes.sale_product") and attributes.sale_product eq 1>checked</cfif>> <cf_get_lang no='1144.Ürünlere Göre Satışlar'></label>
						</div>
						<div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12">
							<label><input name="quota" id="quota" type="checkbox" value="1" <cfif isdefined("attributes.quota") and attributes.quota eq 1>checked</cfif>> <cf_get_lang no='849.Satış Hedefleri'></label>
							<label><input name="expense_cost" id="expense_cost" type="checkbox" value="1" <cfif isdefined("attributes.expense_cost") and attributes.expense_cost eq 1>checked</cfif>> <cf_get_lang no='807.Harcamalar'> </label>
							<label><input name="expense_time" id="expense_time" type="checkbox" value="1" <cfif isdefined("attributes.expense_time") and attributes.expense_time eq 1>checked</cfif>> <cf_get_lang_main no='149.Zaman Harcamaları'> </label>
							<label><input name="purchase_invoice" id="purchase_invoice" type="checkbox" value="1" <cfif isdefined("attributes.purchase_invoice") and attributes.purchase_invoice eq 1>checked</cfif>> <cf_get_lang no='782.Alış Faturaları'> </label>
							<label><input name="purchase_order" id="purchase_order" type="checkbox" value="1" <cfif isdefined("attributes.purchase_order") and attributes.purchase_order eq 1>checked</cfif>> <cf_get_lang no='778.Alış Siparişleri'> </label>
							<label><input name="purchase_offer" id="purchase_offer" type="checkbox" value="1" <cfif isdefined("attributes.purchase_offer") and attributes.purchase_offer eq 1>checked</cfif>> <cf_get_lang no='808.Alış Teklifleri'> </label>
							<label><input name="purchase_category" id="purchase_category" type="checkbox" value="1" <cfif isdefined("attributes.purchase_category") and attributes.purchase_category eq 1>checked</cfif>> <cf_get_lang no='1149.Kategorilere Göre Alışlar'></label>
							<label><input name="purchase_product" id="purchase_product" type="checkbox" value="1" <cfif isdefined("attributes.purchase_product") and attributes.purchase_product eq 1>checked</cfif>> <cf_get_lang no='1150.Ürünlere Göre Alışlar'></label>
							<label><input name="stock" id="stock" type="checkbox" value="1" <cfif isdefined("attributes.stock") and attributes.stock eq 1>checked</cfif>> <cf_get_lang_main no='510.Tedarikçisi Olduğu Stoklar'> </label>
							<label><input name="service_supplier" id="service_supplier" type="checkbox" value="1" <cfif isdefined("attributes.service_supplier") and attributes.service_supplier eq 1>checked</cfif>> <cf_get_lang_main no='506.Tedarikçi Servisleri'></label>
							<label><input name="multi_level_sales" id="multi_level_sales" type="checkbox" value="1" <cfif isdefined("attributes.multi_level_sales") and attributes.multi_level_sales eq 1>checked</cfif>><cf_get_lang no ='1332.Satış Primleri'></label>
						</div>
					<!-- sil -->
					</cfoutput>
				</cf_box_search_detail>
				<div id="bsc_company_div">
					<!--- Finansal Ozet --->
					<cfif isdefined("attributes.finance") and attributes.finance eq 1>
						<cfinclude template="bsc_company_financial_summary.cfm">
					</cfif>
					<!--- Cari Ozet --->
					<cfif isdefined("attributes.activity_summary") and attributes.activity_summary eq 1>
						<cfinclude template="dsp_activity_summary.cfm">
					</cfif>
					<!--- Satis Faturalari --->
					<cfif isdefined("attributes.sale_invoice") and attributes.sale_invoice eq 1>
						<cfinclude template="display_sale_invoices.cfm">
					</cfif>
					<!--- Satis Siparisleri --->
					<cfif isdefined("attributes.sale_order") and attributes.sale_order eq 1>
						<cfinclude template="display_sale_orders.cfm">
					</cfif>
					<!--- Satis Teklifleri --->
					<cfif isdefined("attributes.sale_offer") and attributes.sale_offer eq 1>
						<cfinclude template="dsp_sale_offers.cfm">
					</cfif>
					<!--- Satis Firsatlari --->
					<cfif isdefined("attributes.opportunity") and attributes.opportunity eq 1>
						<cfinclude template="dsp_sale_opportunity.cfm">
					</cfif>
					<!--- Servis Basvurulari ve Asamalari--->
					<cfif isdefined("attributes.service") and attributes.service eq 1>
						<cfinclude template="dsp_services.cfm">
					</cfif>
					<!--- Sistemler --->
					<cfif isdefined("attributes.system") and attributes.system eq 1>
						<cfinclude template="dsp_subs_contracts.cfm">
					</cfif>
					<!--- Toplantı ve Ziyaretler --->
					<cfif isdefined("attributes.event") and attributes.event eq 1>
						<cfinclude template="dsp_agenda_events.cfm">
					</cfif>
					<!--- Kategorilere Gore Satislar --->
					<cfif isdefined("attributes.sale_category") and attributes.sale_category eq 1>
						<cfinclude template="dsp_product_cat_sales.cfm">
					</cfif>
					<!--- Urunlere Gore Satislar --->
					<cfif isdefined("attributes.sale_product") and attributes.sale_product eq 1>
						<cfinclude template="dsp_high_sale_products.cfm">
					</cfif>	 
					<!--- Kotalar --->
					<cfif isdefined("attributes.quota") and attributes.quota eq 1>
						<cfinclude template="dsp_sale_quotas.cfm">
					</cfif>	 
					<!--- Alis Faturalari --->
					<cfif isdefined("attributes.purchase_invoice") and attributes.purchase_invoice eq 1>
						<cfinclude template="display_purchase_invoices.cfm">
					</cfif>
					<!--- Alis Siparisler --->
					<cfif isdefined("attributes.purchase_order") and attributes.purchase_order eq 1>
						<cfinclude template="display_purchase_orders.cfm">
					</cfif>	 
					<!--- Alis Teklifler --->
					<cfif isdefined("attributes.purchase_offer") and attributes.purchase_offer eq 1>
						<cfinclude template="dsp_purchase_offers.cfm">
					</cfif>	 
					<!--- Kategorilerine Göoe Alislar --->
					<cfif isdefined("attributes.purchase_category") and attributes.purchase_category eq 1>
						<cfinclude template="dsp_product_cat_purchases.cfm">
					</cfif>	 
					<!--- Ürünlere Göre Alışlar --->
					<cfif isdefined("attributes.purchase_product") and attributes.purchase_product eq 1>
						<cfinclude template="dsp_high_purchase_products.cfm">
					</cfif>	 
					<!--- Tedarikçi Olunan Stoklar --->
					<cfif isdefined("attributes.stock") and attributes.stock eq 1>
						<cfinclude template="dsp_stock_detail.cfm">
					</cfif>	
					<!--- Harcamalar --->
					<cfif isdefined("attributes.expense_cost") and attributes.expense_cost eq 1>
						<cfinclude template="dsp_expense_cost.cfm">
					</cfif>	
					<!--- Zaman Harcamaları --->
					<cfif isdefined("attributes.expense_time") and attributes.expense_time eq 1>
						<cfinclude template="dsp_time_cost.cfm">
					</cfif>
					<!--- Tedarikçi Servisleri --->
					<cfif isdefined("attributes.service_supplier") and attributes.service_supplier eq 1>
						<cfinclude template="dsp_service_supplier.cfm">
					</cfif>
					<!--- Tedarikçi Servisleri --->
					<cfif isdefined("attributes.multi_level_sales") and attributes.multi_level_sales eq 1>
						<cfinclude template="dsp_multi_level_sales.cfm">
					</cfif>
				</div>
			</cfform>
		</cf_box>
	</div>

<script type="text/javascript">
var hesap_ = <cfoutput>#session.ep.ehesap#</cfoutput>;
/* function check()
{
	if(document.search_form.check_all.checked)
		$("form#search_form input[type=checkbox]").attr("checked","true");
	else
		$("form#search_form input[type=checkbox]").removeAttr("checked");
} */
$("#check_all").click(function(){
	
	if($(this).is(":checked")) $("form#search_form input[type=checkbox]").prop("checked",true);
	else $("form#search_form input[type=checkbox]").prop("checked",false) ;
});

function control()
{
	
	if(hesap_ == 1)
	{
		if((document.search_form.company_id.value =='' || document.search_form.member_name.value == '' ) && ( document.search_form.consumer_id.value=='' || document.search_form.member_name.value == '' ) 
		&& (document.search_form.employee.value == '' || document.search_form.employee_id.value=='') && document.search_form.branch_id.value=='')
		{
			alert("<cf_get_lang no ='1935.Üye Çalışan veya Şube Seçeneklerinden En Az Birini Seçmelisiniz!'>");
			return false;
		}
	}
	else
	{
		if((document.search_form.company_id.value =='' || document.search_form.member_name.value == '' ) && ( document.search_form.consumer_id.value=='' || document.search_form.member_name.value == '' ) && document.search_form.branch_id.value=='')
		{
			alert("<cf_get_lang no ='1936.Üye Veya Şube Seçeneklerinden En Az Birini Seçmelisiniz!'>");
			return false;
		}
	}
	return true;
	
}

function kontrol(a)
{
	if (a == 1 && hesap_ == 1)
	{
		$("form#search_form input[name=employee]").val('');
		$("form#search_form input[name=employee_id]").val('');
	}
	else if (a == 2)
	{
		$("form#search_form input[name=member_name]").val('');
		$("form#search_form input[name=consumer_id]").val('');
		$("form#search_form input[name=company_id]").val('');
		$("form#search_form input[name=partner_id]").val('');
	}
}


</script>
