<!---SöZLEŞME EKLE SAYFASI HEM NORMAL, HEM POPUP SAYFALARDA KULLANILDIĞI İÇİN NORMAL SAYFALARA GÖRE DÜZENLENMİŞTİR.--->
<cf_xml_page_edit fuseact="contract.popup_add_contract">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.short_code" default="">
<cfinclude template="../query/get_cat.cfm">
<cfinclude template="../query/get_moneys.cfm">
<cfquery name="GET_KDV" datasource="#DSN2#">
	SELECT TAX_ID, TAX FROM SETUP_TAX ORDER BY TAX
</cfquery>
<cfquery name="get_module_cat" datasource="#DSN#">
	SELECT TEMPLATE_ID,TEMPLATE_HEAD FROM TEMPLATE_FORMS WHERE TEMPLATE_MODULE = 17
</cfquery>
<cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
	SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 ORDER BY PRICE_CAT
</cfquery>

<cfif isdefined("attributes.contract_id") and len(attributes.contract_id)>
	<cfquery name="get_price_cat_exceptions" datasource="#DSN3#">
		SELECT 
        	PRICE_CAT_EXCEPTION_ID, 
            IS_GENERAL, 
            COMPANY_ID, 
            PRODUCT_CATID, 
            CONSUMER_ID, 
            BRAND_ID, 
            PRODUCT_ID, 
            PRICE_CATID, 
            DISCOUNT_RATE, 
            COMPANYCAT_ID, 
            SUPPLIER_ID, 
            ACT_TYPE, 
            IS_DEFAULT, 
            PURCHASE_SALES, 
            DISCOUNT_RATE_2, 
            DISCOUNT_RATE_3, 
            DISCOUNT_RATE_4, 
            DISCOUNT_RATE_5, 
            PAYMENT_TYPE_ID, 
            SHORT_CODE_ID, 
            CONTRACT_ID, 
            PRICE, 
            PRICE_MONEY, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP 
        FROM 
    	    PRICE_CAT_EXCEPTIONS 
        WHERE 
	        CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contract_id#"> AND ISNULL(ACT_TYPE,1) IN(1,3)
	</cfquery>
<cfelse>
	<cfset get_price_cat_exceptions.recordcount = 0>
</cfif>
<cfset row = get_price_cat_exceptions.RecordCount>
<cf_catalystHeader>
<cfform method="post" name="add_contr" id="add_contr" action="#request.self#?fuseaction=contract.add">
<cfif attributes.fuseaction contains 'popup'><input type="hidden" name="is_popup" id="is_popup" value="1"></cfif>
<cfsavecontent variable="right_">
	<select name="template_id" id="template_id" style="width:150px;" onChange="document.add_contr.action = '';document.add_contr.submit();">
		<option value="" selected> <cf_get_lang dictionary_id='58640.Şablon'>
		<cfoutput query="get_module_cat">
			<option value="#template_id#"<cfif isDefined("attributes.template_id") and (attributes.template_id eq template_id)> selected</cfif>>#TEMPLATE_HEAD#</option> 
		</cfoutput>
	</select>
</cfsavecontent>
	<div class="col col-9 col-xs-12">
		<cf_box>
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-is_active">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
							<div class="col col-8 col-xs-12">
								<input type="checkbox" name="is_active" id="is_active" value="1" checked="checked" />
							</div>
					</div>
					 <cfif isdefined("x_process_cat") and x_process_cat eq 1> 
						<div class="form-group" id="item-process_cat">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'>*</label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process_cat slct_width="150" form_name="add_contr" process_cat="">                           
							</div>
						</div> 
					</cfif>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='145' is_detail='0' is_select_text="1">
						</div>
					</div>	
					<div class="form-group" id="item-contract_head">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>*</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="contract_head" id="contract_head" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-contract_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30044.Sözleşme No'>*</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="contract_no" id="contract_no" value="" maxlength="50">
						</div>
					</div>
					
					<div class="form-group" id="item-contract_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51040.Sözleşme Tipi'></label>
						<div class="col col-8 col-xs-12">
							<select name="contract_type" id="contract_type">
								<option value="1"><cf_get_lang dictionary_id='58176.Alış'></option>
								<option value="2"><cf_get_lang dictionary_id='57448.Satış'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-start">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'>*</label>
						<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='58053.Başlangıç Tarihi !'></cfsavecontent>
							<cfinput required="Yes" message="#message#" type="text" name="start" validate="#validate_style#" value="">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start"></span>
						</div>
						</div>
					</div>
					<div class="form-group" id="item-finish">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi !'></cfsavecontent>
								<cfinput required="Yes" message="#message#" type="text" name="finish" validate="#validate_style#" value="">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish"></span>
							</div>
						</div>
					</div>		
					<div class="form-group" id="item-contract_cat_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
						<div class="col col-8 col-xs-12">
							<select name="contract_cat_id" id="contract_cat_id">
								<option value="" selected><cf_get_lang dictionary_id='57734.Kategori Seçiniz'> 
								<cfoutput query="get_cat">
									<option value="#contract_cat_id#">#contract_cat#</option>
								</cfoutput>
							</select>
						</div>
					</div>																									
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-member_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
									<cfquery name="get_consumer" datasource="#DSN#">
										SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
									</cfquery>
									<cfset member_name = '#get_consumer.consumer_name# #get_consumer.consumer_surname#'>
								<cfelseif isdefined('attributes.company_id') and len(attributes.company_id)>
									<cfquery name="get_company" datasource="#DSN#">
										SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
									</cfquery>
									<cfset member_name = get_company.fullname>
								<cfelse>
									<cfset member_name = ''>
								</cfif>
								<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company_id') and len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>" >
								<input type="hidden" name="consumer_id" id="consumer_id"  value="<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
								<input type="text" name="member_name" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'0\',\'\',\'\',\'2\',\'1\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','add_contr','3','250')" value="<cfoutput>#member_name#</cfoutput>" autocomplete="off">
								<cfset str_linke_ait="field_consumer=add_contr.consumer_id&field_comp_id=add_contr.company_id&field_comp_name=add_contr.member_name&field_name=add_contr.member_name">
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-project_head">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="project_id" id="project_id" value="">
								<input type="text" name="project_head" id="project_head" value=""  onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','add_contr','3','140')"autocomplete="off">
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_contr.project_id&project_head=add_contr.project_head');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-tevkifat_oran">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58022.Tevkifat'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="tevkifat_oran_id" id="tevkifat_oran_id" value=""  />
								<input type="text" name="tevkifat_oran" id="tevkifat_oran" value="" />
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_tevkifat_rates&field_tevkifat_rate=add_contr.tevkifat_oran&field_tevkifat_rate_id=add_contr.tevkifat_oran_id</cfoutput>','small')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-stopaj">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57711.Stopaj'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="stoppage_oran_id" id="stoppage_oran_id" value=""  />
								<input type="text" name="stoppage_oran" id="stoppage_oran" value="" />
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stoppage_rates&field_stoppage_rate=add_contr.stoppage_oran&field_stoppage_rate_id=add_contr.stoppage_oran_id&field_decimal=#session.ep.our_company_info.purchase_price_round_num#</cfoutput>','small')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-copy_number">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='39010.Kopya'><cf_get_lang dictionary_id='39852.Sayısı'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="copy_number" id="copy_number" value="" />
						</div>
					</div>						
					<div class="form-group" id="item-contract_calculation">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51043.Hesaplama Yöntemi'></label>
						<div class="col col-8 col-xs-12">
							<select name="contract_calculation" id="contract_calculation">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<option value="1">%</option>
								<option value="2"><cf_get_lang dictionary_id='29513.Süre'></option>
								<option value="3"><cf_get_lang dictionary_id='57635.Miktar'></option>
							</select>
						</div>
					</div>									
					<div class="form-group" id="item-paymethod_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Odeme Yontemi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
								<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
								<input type="hidden" name="commission_rate" id="commission_rate" value="">
								<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
								<input type="text" name="pay_method" id="pay_method" value="" onFocus="AutoComplete_Create('pay_method','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMENT_TYPE_ID,COMMISSION_MULTIPLIER,PAYMETHOD_ID,PAYMENT_VEHICLE','card_paymethod_id,commission_rate,paymethod_id,paymethod_vehicle','','3','200');" autocomplete="off">
								<cfset card_link="&field_card_payment_id=add_contr.card_paymethod_id&field_card_payment_name=add_contr.pay_method&field_commission_rate=add_contr.commission_rate&field_paymethod_vehicle=add_contr.paymethod_vehicle">
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&function_parameter=order_date&field_id=add_contr.paymethod_id&field_name=add_contr.pay_method#card_link#</cfoutput>','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-ship_method_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="ship_method_id" id="ship_method_id" value="">
								<input type="text" name="ship_method_name" id="ship_method_name" value="" onFocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','','3','140');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method_id','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-deliver_dept_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57646.Teslim Depo'></label>
						<div class="col col-8 col-xs-12">
							<cf_wrkdepartmentlocation 
								returnInputValue="deliver_loc_id,deliver_dept_name,deliver_dept_id,branch_id"
								returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
								fieldName="deliver_dept_name"
								fieldid="deliver_loc_id"
								department_fldId="deliver_dept_id"
								branch_fldId="branch_id"
								user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
								width="143"
								is_branch="1">
						</div>
					</div>					
				</div>	
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">						
					<div class="form-group" id="item-contract_amount">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50985.Sözleşme Tutarı'></label>
						<div class="col col-4 col-xs-8">
							<input type="text" name="contract_amount" id="contract_amount" value="0" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onblur="hesapla(1);hesapla(4);hesapla(6);hesapla(8);"/>
						</div>
						<label class="col col-1 text-center">-</label>
						<div class="col col-3">
							<select name="contract_tax" id="contract_tax" onchange="hesapla(1);">
								<cfoutput query="get_kdv">
									<option value="#tax#">#tax#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-money">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58716.KDVli'> <cf_get_lang dictionary_id='57673.Tutar'></label>
						<div class="col col-4 col-xs-8">
								<input type="text" name="contract_tax_amount" id="contract_tax_amount" value="0" class="moneybox" onkeyup="hesapla(2);return(FormatCurrency(this,event));"/>
						</div>
						<label class="col col-1 text-center">-</label>
						<div class="col col-3">
							<select name="contract_money" id="contract_money">
								<cfoutput query="get_moneys">
									<option value="#money#" <cfif money is session.ep.money> selected</cfif>>#money#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-contract_unit_price">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57638.Birim Fiyat'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="contract_unit_price" id="contract_unit_price" value="0" class="moneybox" onkeyup="return(FormatCurrency(this,event));"/>
						</div>
					</div>
													
					<cfif x_contract_discount eq 1>
						<div class="form-group" id="item-discount">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38190.İskonto Oranı'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="discount" id="discount" value="" class="moneybox" onkeyup="return(FormatCurrency(this,event));" placeholder="%"/>
							</div>
						</div>
					</cfif>			
					<div class="form-group" id="item-guarantee_amount">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58689.Teminat'><cf_get_lang dictionary_id='58671.Oran'>/<cf_get_lang dictionary_id='54452.Tutar'></label>
						<div class="col col-3 col-xs-12">
							<input type="text" name="guarantee_rate" id="guarantee_rate" value="" class="moneybox" onkeyup="hesapla(4);return(FormatCurrency(this,event));" placeholder="%"/>
						</div>
						<label class="col col-1 text-center">-</label>
						<div class="col col-4 col-xs-12">							
							<input type="text" name="guarantee_amount" id="guarantee_amount" value="0" class="moneybox" onkeyup="hesapla(3);return(FormatCurrency(this,event));"/>
						</div>
					</div>
					<div class="form-group" id="item-advance_amount">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58204.Avans'><cf_get_lang dictionary_id='58671.Oran'>/<cf_get_lang dictionary_id='54452.Tutar'></label>
						<div class="col col-3 col-xs-12">
							<input type="text" name="advance_rate" id="advance_rate" value="" class="moneybox" onkeyup="hesapla(6);return(FormatCurrency(this,event));" placeholder="%"/>
						</div>
						<label class="col col-1 text-center">-</label>
						<div class="col col-4 col-xs-12">
							<input type="text" name="advance_amount" id="advance_amount" value="0"  class="moneybox" onkeyup="hesapla(5);return(FormatCurrency(this,event));"/>
						</div>
					</div>
					<div class="form-group" id="item-stamp_tax">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53252.Damga Vergisi'><cf_get_lang dictionary_id='58671.Oran'>/<cf_get_lang dictionary_id='54452.Tutar'></label>
						<div class="col col-3 col-xs-12">
							<input type="text" name="stamp_tax_rate" id="stamp_tax_rate" value="" class="moneybox" onkeyup="hesapla(8);return(FormatCurrency(this,event,4));" placeholder="%"/>
						</div>
						<label class="col col-1 text-center">-</label>
						<div class="col col-4 col-xs-12">
							<input type="text" name="stamp_tax" id="stamp_tax" value="0" class="moneybox" onkeyup="hesapla(7);return(FormatCurrency(this,event));"/>
						</div>
					</div>		
					<div class="form-group" id="ıtem-wrk_add_info">
						<label class="col col-4 col-xs-12"><cfoutput>#getlang('main',398)#</cfoutput></label>
						<div class="col col-8 col-xs-12">
						   <cf_wrk_add_info info_type_id="-21" upd_page="0" colspan="9">
					   </div>
				   </div>																	
				</div>	
			</cf_box_elements>
			<div class="row" type="row">
				<div class="col-12 col-xs-12">
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-12">
							<cfmodule
							template="/fckeditor/fckeditor.cfm"
							toolbarSet="Basic"
							basePath="/fckeditor/"
							instanceName="contract_body"
							valign="top"
							value=""
							width="100%"
							height="100%">
						</div>
					</div>
				</div>
			</div>
			<cf_box_footer>	<!---/// footer alanı record info ve submit butonu--->
				<div class="col col-12 text-right pull-right"><cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'></div> <!---///butonlar--->
			</cf_box_footer>
		</cf_box>
	</div>
	<div class="col col-3 col-xs-12">
		<cfsavecontent variable="txt"><cf_get_lang dictionary_id='50706.Taraflar'></cfsavecontent>
		<cf_box title="#txt#" closable="0">
				<!--- Taraflar --->
				<div class="form-group">
					<label style="display:none;"><cf_get_lang dictionary_id='50706.Taraflar'></label>
					<div class="col col-6 col-xs-12">
						<div id="contract_sag">
							<cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='50706.Taraflar'> (<cf_get_lang dictionary_id='58885.Partner'>)</cfsavecontent>
							<cf_workcube_to_cc is_update="0" cc_dsp_name="#txt_2#" form_name="add_contr" str_list_param="2,3" data_type="1">
						</div>
					</div>
					<div class="col col-6 col-xs-12">
						<div id="contract_sag">
							<cfsavecontent variable="txt_1"><cf_get_lang dictionary_id='50706.Taraflar'> (<cf_get_lang dictionary_id='57576.Çalışan'>)</cfsavecontent>
							<cf_workcube_to_cc is_update="0" to_dsp_name="#txt_1#" form_name="add_contr" str_list_param="1" data_type="1">
						</div>
					</div>
				</div>
				<!--- Taraflar --->
		</cf_box>
	</div>
	<!---
	<div class="row">
		<div class="col col-9 col-xs-12">
			<!--- Fiyat listeleri --->
			<cfsavecontent variable="title"><cf_get_lang dictionary_id='60280.Anlaşlmaya Özel Fiyatlar'></cfsavecontent>
			<cf_box 
				closable="0"
				id="price_cont"
				unload_body="1"
				box_page="#request.self#?fuseaction=contract.list_prices_contract"
				title="#title#">
			</cf_box>
			<!---<cfinclude template="../display/list_prices_contract.cfm">--->
			<!--- Fiyat listeleri --->
		</div>
	</div>--->
</cfform>
<script type="text/javascript">
	<cfif isdefined("attributes.template_id")>
		<cfinclude template="../query/get_templates.cfm">  	
		document.add_contr.contract_body.value = '<cfoutput>#SETUP_TEMPLATE.TEMPLATE_CONTENT#</cfoutput>';	
	</cfif>	
	function kontrol()
	{
		 <cfif isdefined("x_process_cat") and x_process_cat eq 1> 
            if(!chk_process_cat('add_contr')) return false;
            if (!check_display_files('add_contr')) return false;
        </cfif>   
		if (add_contr.contract_cat_id.value == '')
		{	
			alert("<cf_get_lang dictionary_id='57471.Zorunlu alan'>:<cf_get_lang dictionary_id='57486.Kategori !'>");
			return false;		
		}
		if (document.getElementById('contract_head').value == '')
		{	
			alert("<cf_get_lang dictionary_id='57471.Zorunlu alan'>:<cf_get_lang dictionary_id='50759.Başlık !'>");
			return false;		
		}
			if((document.getElementById('company_id').value ==  '' || document.getElementById('member_name').value == '') && (document.getElementById('consumer_id').value == '' ||document.getElementById('member_name').value == ''))
			{
				alert("<cf_get_lang dictionary_id='57471.Zorunlu alan'>:<cf_get_lang dictionary_id='58061.Cari !'>");
				return false;
			}
			if (document.getElementById('contract_no').value == '')
			{	
				alert("<cf_get_lang dictionary_id='57471.Zorunlu alan'>:<cf_get_lang dictionary_id='30044.Sözleşme No'>");
				return false;		
			}
		<cfif x_tevkifat_rate eq 1>
			if(document.all.start.value != '' && document.all.finish.value != '')
			{
				var start_d = document.all.start.value.split(/\D+/);// \D sayı olmayan karakterleri temsil ediyor.
				var finish_d = document.all.finish.value.split(/\D+/);
				var d1=new Date(start_d[2]*1, start_d[1]-1, start_d[0]*1);
				var d2=new Date(finish_d[2]*1, finish_d[1]-1, finish_d[0]*1);
				var start_y = d1.getFullYear();
				var finish_y = d2.getFullYear();
				var fark = Math.abs(finish_y-start_y);
				if(fark != 0)
				{
					if(document.add_contr.tevkifat_oran_id.value == '' || document.add_contr.tevkifat_oran.value == '')
					{
						alert("<cf_get_lang dictionary_id='57471.Zorunlu alan'>:<cf_get_lang dictionary_id="50734.Tevkifat Oranı">");
						return false;
					}
				}
			}
		</cfif>
		
			if((document.getElementById('cc_par_ids') == undefined || document.getElementById('cc_par_ids').value == '') && (document.getElementById('cc_cons_ids') == undefined || document.getElementById('cc_cons_ids').value == '') && (document.getElementById('to_emp_ids') == undefined || document.getElementById('to_emp_ids').value == ''))
			{
				alert("<cf_get_lang dictionary_id='57471.Zorunlu alan'>:<cf_get_lang dictionary_id='50706.Taraf !'>");
				return false;
			}
		
		unformat_fields();
		return process_cat_control();
		return true;
	}
	
	function hesapla(type)
	{
		
		tax_ = document.all.contract_tax.value;
		if(document.all.contract_amount.value != 0 )
		{
			document.all.contract_amount.value=filterNum(document.all.contract_amount.value);
			document.all.contract_amount.value =commaSplit(document.all.contract_amount.value,'2');
		}

		if(type == 1)
		{
			amount_ = filterNum(document.all.contract_amount.value,'2');
			if(tax_ != 0 && amount_ != '')
			{
				kdvli_amount = ((parseFloat(tax_)*parseFloat(amount_))/100)+parseFloat(amount_);
				document.all.contract_tax_amount.value = commaSplit(kdvli_amount,'2');
			}
			else
				document.all.contract_tax_amount.value = commaSplit(amount_,'2');
		}
		
		else if(type == 2)
		{
			kdv_amount_ = filterNum(document.all.contract_tax_amount.value,'2');
			if(tax_ != 0 && kdv_amount_ != '')
			{
				amount_ = (parseFloat(kdv_amount_)*100)/(parseFloat(tax_)+100);
				document.all.contract_amount.value = commaSplit(amount_,'2');
			}
			else
				document.all.contract_amount.value = commaSplit(kdv_amount_,'2');
		}

		else if(type == 3 || type == 4 || type == 5 || type == 6 || type == 7 || type == 8)
		{
			if(document.all.contract_amount.value != '')
			{
				contract_amount_ = filterNum(document.all.contract_amount.value);
				if(document.all.guarantee_amount.value != "" && parseFloat(document.all.guarantee_amount.value)) guarantee_amount_ = filterNum(document.all.guarantee_amount.value); else guarantee_amount_ = 0;
				if(document.all.guarantee_rate.value != "") guarantee_rate_ = filterNum(document.all.guarantee_rate.value); else guarantee_rate_ = 0;
				if(document.all.advance_amount.value != "" && parseFloat(document.all.advance_amount.value)) advance_amount_ = filterNum(document.all.advance_amount.value); else advance_amount_ = 0;
				if(document.all.advance_rate.value != "") advance_rate_ = filterNum(document.all.advance_rate.value); else advance_rate_ = 0;
				if(document.all.stamp_tax.value != "" && parseFloat(document.all.stamp_tax.value)) stamp_tax_ = filterNum(document.all.stamp_tax.value); else stamp_tax_ = 0;
				if(document.all.stamp_tax_rate.value != "") stamp_tax_rate_ = filterNum(document.all.stamp_tax_rate.value); else stamp_tax_rate_ = 0;
				if(type == 3)
				{
					if(parseFloat(contract_amount_) != 0)
						var deger_guarantee_rate = (parseFloat(guarantee_amount_)/parseFloat(contract_amount_))*100;
					else
						var deger_guarantee_rate = 0;
					document.all.guarantee_rate.value = commaSplit(deger_guarantee_rate);
				}
				if(type == 4)
				{
					var deger_guarantee_amount = (parseFloat(contract_amount_)*parseFloat(guarantee_rate_))/100;
					document.all.guarantee_amount.value = commaSplit(deger_guarantee_amount,'2');
				}
				if(type == 5)
				{
					if(parseFloat(contract_amount_) != 0)
						var deger_advance_rate = (parseFloat(advance_amount_)/parseFloat(contract_amount_))*100;
					else
						var deger_advance_rate = 0;
					document.all.advance_rate.value = commaSplit(deger_advance_rate);
				}
				if(type == 6)
				{
					var deger_advance_amount = (parseFloat(contract_amount_)*parseFloat(advance_rate_))/100;
					document.all.advance_amount.value = commaSplit(deger_advance_amount,'2');
				}
				if(type == 7)
				{
					if(parseFloat(contract_amount_) != 0)
						var deger_stamp_tax_rate = (parseFloat(stamp_tax_)/parseFloat(contract_amount_))*100;
					else
						var deger_stamp_tax_rate = 0;
					document.all.stamp_tax_rate.value = commaSplit(deger_stamp_tax_rate);
				}
				if(type == 8)
				{
					var deger_stamp_tax = (parseFloat(contract_amount_)*parseFloat(stamp_tax_rate_))/100;
					document.all.stamp_tax.value = commaSplit(deger_stamp_tax,'2');
				}
				
			}
			else
			{
				alert("<cf_get_lang dictionary_id='57471.Zorunlu alan'>:<cf_get_lang dictionary_id="50985.Sözleşme Tutarı">!");
				document.all.advance_amount.value = '';
				document.all.advance_rate.value = '';
			}
		}
	}
	
	//fiyat listeleri
	row_count_2=<cfoutput>#row#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("add_contr.row_kontrol_2"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_2"+sy);
		my_element.style.display="none";
	}

	function add_row()
	{
		row_count_2++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);	
		newRow.setAttribute("name","frm_row_2" + row_count_2);
		newRow.setAttribute("id","frm_row_2" + row_count_2);		
		document.add_contr.record_num_.value=row_count_2;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input  type="hidden" value="1"  name="row_kontrol_2'+row_count_2 +'" ><a style="cursor:pointer" onclick="sil(' + row_count_2 + ');"><img  src="images/delete_list.gif" border="0"></a>';				
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<select name="price_cat' + row_count_2 + '" style="width:130px;"><cfoutput query="GET_PRICE_CATS"><option value="#PRICE_CATID#">#PRICE_CAT#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input  type="hidden"  name="PRODUCT_CAT_ID' + row_count_2 +'" ><input type="text" name="product_cat_name' + row_count_2 + '" style="width:90px;">&nbsp;<a href="javascript://" onClick="pencere_ac(' + row_count_2 + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Kategori Seç"></a>';			
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input  type="hidden"  name="brand_id' + row_count_2 +'" ><input type="text" name="brand_name' + row_count_2 + '" style="width:90px;">&nbsp;<a href="javascript://" onClick="markaBul(' + row_count_2 + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Marka Seç"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input  type="hidden"  name="short_code_id' + row_count_2 +'" ><input type="text" name="short_code' + row_count_2 + '" style="width:90px;">&nbsp;<a href="javascript://" onClick="modelBul(' + row_count_2 + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Model Seç"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input  type="hidden"  name="PRODUCT_ID' + row_count_2 +'" ><input type="text" name="product_name' + row_count_2 + '" style="width:90px;">&nbsp;<a href="javascript://" onClick="pencere_pos(' + row_count_2 + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Ürün Seç"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input  type="hidden"  name="payment_type_id' + row_count_2 +'"><input type="text" name="payment_type' + row_count_2 + '" style="width:90px;">&nbsp;<a href="javascript://" onClick="pencere_paymethod(' + row_count_2 + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Ödeme Yöntemi Seç"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="price' + row_count_2 + '" style="width:60px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<select name="price_money' + row_count_2  +'" id="money_id' + row_count_2  +'" style="width:60px;" class="moneybox">';
		<cfoutput query="get_moneys">
			a += '<option value="#money#">#money#</option>';
		</cfoutput>
		newCell.innerHTML =a+ '</select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="discount_info' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="discount_info2' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="discount_info3' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="discount_info4' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="discount_info5' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
	}
	function pencere_ac(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=add_contr.PRODUCT_CAT_ID' + no + '&field_name=add_contr.product_cat_name' + no);	/*&process=purchase_contract      var_=purchase_contr_cat_premium&*/
	}
	function pencere_paymethod(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&is_paymethods=1&field_id=add_contr.payment_type_id' + no + '&field_name=add_contr.payment_type' + no,'list');
	}
	function pencere_pos(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products_only&product_id=add_contr.PRODUCT_ID' + no + '&field_name=add_contr.product_name' + no,'list'); /*&process=purchase_contract  var_=purchase_contr_cat_premium&*/
	}
	function markaBul(no)
	{
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&brand_id=add_contr.brand_id' + no + '&brand_name=add_contr.brand_name' + no + '</cfoutput>','list');
	}
	function modelBul(no)
	{
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_product_model&model_id=add_contr.short_code_id' + no + '&model_name=add_contr.short_code' + no + '</cfoutput>','list');
	}
	
	function unformat_fields()
	{
		add_contr.contract_amount.value = filterNum(add_contr.contract_amount.value);
		add_contr.contract_tax_amount.value = filterNum(add_contr.contract_tax_amount.value);
		add_contr.contract_unit_price.value = filterNum(add_contr.contract_unit_price.value);
		add_contr.guarantee_amount.value = filterNum(add_contr.guarantee_amount.value);
		add_contr.guarantee_rate.value = filterNum(add_contr.guarantee_rate.value);
		add_contr.advance_amount.value = filterNum(add_contr.advance_amount.value);
		add_contr.advance_rate.value = filterNum(add_contr.advance_rate.value);
		add_contr.tevkifat_oran.value = filterNum(add_contr.tevkifat_oran.value);
		add_contr.stamp_tax.value = filterNum(add_contr.stamp_tax.value);
		add_contr.stamp_tax_rate.value = filterNum(add_contr.stamp_tax_rate.value);
		add_contr.stoppage_oran.value = filterNum(add_contr.stoppage_oran.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		<cfif x_contract_discount eq 1>
			add_contr.discount.value = filterNum(add_contr.discount.value);
		</cfif>
		return true;
	}	
</script>
