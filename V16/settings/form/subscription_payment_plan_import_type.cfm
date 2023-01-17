<!---
    File: subscription_payment_plan_import_type.cfm
    Author: 
    Date: 
    Controller: 
    Description: satış abone modülü altındaki ödeme plan import işlemlerinin tanımlanması için kullanılır
		
--->
<cfsetting showdebugoutput="yes">
<cfset contract_cmp = createObject("component","V16.sales.cfc.subscription_contract")>
<cfset gsa = createObject("component","V16.objects.cfc.subscriptionNauthority")/>
<cfset GET_SUBSCRIPTION_AUTHORITY= gsa.SelectAuthority()/>
<cfset GET_SUBSCRIPTION_TYPE = contract_cmp.GET_SUBSCRIPTION_TYPE(dsn3:dsn3,IS_SUBSCRIPTION_AUTHORITY:get_subscription_authority.IS_SUBSCRIPTION_AUTHORITY)>

<cfscript>
	if(not isdefined("attributes.import_type_id")) attributes.import_type_id = "";
	if(not isdefined("attributes.import_type_name")) attributes.import_type_name = "";  
	if(not isdefined("attributes.subscription_type_id")) attributes.subscription_type_id = "";
	if(not isdefined("attributes.import_type")) attributes.import_type = "";
	if(not isdefined("attributes.paymethod_id")) attributes.paymethod_id = "";
	if(not isdefined("attributes.product_id")) attributes.product_id = "";
	if(not isdefined("attributes.stock_id")) attributes.stock_id = "";
	if(not isdefined("attributes.detail")) attributes.detail = "";
	if(not isdefined("attributes.is_payment_date")) attributes.is_payment_date = "";
	if(not isdefined("attributes.use_product_price")) attributes.use_product_price = "";
	if(not isdefined("attributes.use_product_reason_code")) attributes.use_product_reason_code = "";
	if(not isdefined("attributes.use_product_tax")) attributes.use_product_tax = 0;
	if(not isdefined("attributes.use_product_paymethod")) attributes.use_product_paymethod = "";
	if(not isdefined("attributes.is_collected_invoice")) attributes.is_collected_invoice = "";
	if(not isdefined("attributes.is_group_invoice")) attributes.is_group_invoice = "";
	if(not isdefined("attributes.is_row_description")) attributes.is_row_description = "";
	if(not isdefined("attributes.is_allow_zero_price")) attributes.is_allow_zero_price = "";
	if(not isdefined("attributes.cfc_file")) attributes.cfc_file = "";
	if(not isdefined("attributes.type_description")) attributes.type_description = "";

	if(attributes.event == "upd"){
		if(len(attributes.import_type_id)){
			type_comp = createobject("component","V16.settings.cfc.subscriptionpaymentplanimporttype");
			type = type_comp.get_byid(import_type_id:attributes.import_type_id);

			if(type.recordcount eq 0){
				hata  = 10;
				include(template="../../dsp_hata.cfm");
				abort;
			}

			attributes.import_type_id = type.import_type_id;
			attributes.import_type_name = type.import_type_name;
			attributes.subscription_type_id =   type.subscription_type_id;
			attributes.import_type = type.import_type;
			attributes.paymethod_id = type.paymethod_id;
			attributes.product_id = type.product_id;
			attributes.stock_id = type.stock_id;
			attributes.detail = type.detail;
			attributes.is_payment_date = type.is_payment_date;
			attributes.use_product_price = type.use_product_price;
			attributes.use_product_reason_code = type.use_product_reason_code;
			attributes.use_product_tax = type.use_product_tax;
			attributes.use_product_paymethod = type.use_product_paymethod;
			attributes.is_collected_invoice = type.is_collected_invoice;
			attributes.is_group_invoice = type.is_group_invoice;
			attributes.is_row_description = type.is_row_description;
			attributes.is_allow_zero_price = type.is_allow_zero_price;
			attributes.cfc_file = type.cfc_file;
			attributes.type_description = type.type_description;
		}else{
			writeOutput("<script>alert('Hata Oluştu');</script>");
			exit;
		}
	}
</cfscript>

<cfif len(attributes.PRODUCT_ID) and len(attributes.STOCK_ID)>
	<cfquery name="GET_PRODCUT" datasource="#DSN3#">
		SELECT
			PRODUCT.PRODUCT_NAME
		FROM 
			PRODUCT
			INNER JOIN STOCKS on PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID
		WHERE
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.STOCK_ID#">
	</cfquery>
	<cfset attributes.PRODUCT_NAME = GET_PRODCUT.PRODUCT_NAME>
<cfelse>
	<cfset attributes.PRODUCT_NAME = "">
</cfif>

<cfif len(attributes.paymethod_id) and len(attributes.paymethod_id)>
	<cfquery name="GET_PAY" datasource="#DSN#">
		SELECT
			SP.PAYMETHOD
		FROM
			SETUP_PAYMETHOD SP
		WHERE
			SP.PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#"> 
	</cfquery>
	<cfset attributes.payment_type = GET_PAY.PAYMETHOD>
<cfelse>
	<cfset attributes.payment_type = "">
</cfif>

<cf_catalystHeader>
<form name="import_type" id="import_type" method="post" action="<cfoutput>#request.self#?fuseaction=#url.fuseaction#</cfoutput>&event=upd&import_type_id=<cfoutput>#attributes.import_type_id#</cfoutput>">
	<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
	<input type="hidden" name="IMPORT_TYPE_ID" id="IMPORT_TYPE_ID" value="<cfoutput>#attributes.import_type_id#</cfoutput>" />
	
	<div class="row">
		<div class="col col-12  uniqueRow">
			<div class="row formContent">
				<div class="row" type="row">
					<div class="form-group" id="item-import_type_name">
						<label class="col col-2 col-xs-12" for="import_type_name"><cf_get_lang dictionary_id='58233.Tanım'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="import_type_name" id="import_type_name" value="<cfoutput>#attributes.import_type_name#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="form_ul_suscription_type">
                        <label class="col col-2 col-xs-12"><cf_get_lang_main no ='74.kategori'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="subscription_type_id" id="subscription_type_id" required>
                                <option value=""><cf_get_lang_main no ='74.kategori'></option>
                                    <cfoutput query="get_subscription_type">
                                        <option value="#subscription_type_id#" <cfif attributes.subscription_type_id eq subscription_type_id>selected</cfif>>#subscription_type#</option>
                                    </cfoutput>
                            </select>
                        </div>
                    </div>
					<div class="form-group" id="item-import_type">
						<label class="col col-2 col-xs-12" for="table_name"><cf_get_lang dictionary_id='42990.Aktarım Tipi'> *</label>
						<div class="col col-8 col-xs-12">
							<select name="import_type" id="import_type">
								<option value="1" <cfif attributes.import_type eq 1>selected</cfif>>Dosya</option>
								<option value="2" <cfif attributes.import_type eq 2>selected</cfif>>Tarih Aralığı</option>
                            </select>
						</div>
					</div>
					<div class="form-group" id="item-form_ul_payment_type">
						<label class="col col-2 col-xs-12"><cf_get_lang_main no='1104.ödeme yöntemi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#attributes.paymethod_id#</cfoutput>">
								<input type="text" name="payment_type" id="payment_type" value="<cfoutput>#attributes.payment_type#</cfoutput>">
								<span class="input-group-addon btn_pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&field_id=import_type.paymethod_id&field_name=import_type.payment_type','list','popup_paymethods');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="form_ul_product_name">
                        <label class="col col-2 col-xs-12"><cf_get_lang_main no='245.ürün'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
								<input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_id) and len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
								<input type="hidden" name="stock_id" id="stock_id" <cfif len(attributes.stock_id) and len(attributes.stock_id)>value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
								<input name="product_name" type="text" id="product_name" value="<cfif len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>">
                                <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_price_unit&field_id=import_type.product_id&field_stock_id=import_type.stock_id&field_name=import_type.product_name','list');"></span>
                            </div>
                        </div>
                    </div>
					<div class="form-group" id="item-detail">
						<label class="col col-2 col-xs-12" for="detail"><cf_get_lang dictionary_id='58221.ürün'> Detail</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="detail" id="detail" value="<cfoutput>#attributes.detail#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-is_payment_date">
						<label class="col col-2 col-xs-12" for="is_payment_date"><cf_get_lang dictionary_id='41112.Tahakkum Tarihi'> Formda Gelsin</label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="is_payment_date" id="is_payment_date" value="1" <cfif len(attributes.is_payment_date) and attributes.is_payment_date>checked</cfif>>
						</div>
					</div>
					<div class="form-group" id="item-use_product_price">
						<label class="col col-2 col-xs-12" for="use_product_price"><cf_get_lang dictionary_id='58778.Ürün Fiyatı'> Kullanılsın(Standart Satış)</label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="use_product_price" id="use_product_price" <cfif len(attributes.use_product_price) and attributes.use_product_price>checked</cfif> value="1">
						</div>
					</div>
					<div class="form-group" id="item-use_product_reason_code">
						<label class="col col-2 col-xs-12" for="use_product_reason_code"><cf_get_lang dictionary_id='43458.İstisna Kodu'> Kullanılsın</label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="use_product_reason_code" id="use_product_reason_code" <cfif len(attributes.use_product_reason_code) and attributes.use_product_reason_code>checked</cfif> value="1">
						</div>
					</div>
					<div class="form-group" id="item-use_product_tax">
						<label class="col col-2 col-xs-12" for="use_product_tax">Ürün Vergi Oranlarını Kullanılsın</label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="use_product_tax" id="use_product_tax" <cfif len(attributes.use_product_tax) and attributes.use_product_tax>checked</cfif> value="1">
						</div>
					</div>
					<div class="form-group" id="item-use_product_paymethod">
						<label class="col col-2 col-xs-12" for="use_product_paymethod">Ürün Satış Ödeme Yöntemi Kullanılsın</label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="use_product_paymethod" id="use_product_paymethod" <cfif len(attributes.use_product_paymethod) and attributes.use_product_paymethod>checked</cfif> value="1">
						</div>
					</div>
					<div class="form-group" id="item-is_collected_invoice">
						<label class="col col-2 col-xs-12" for="is_collected_invoice"><cf_get_lang dictionary_id="41376.Toplu Fatura"></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="is_collected_invoice" id="is_collected_invoice" <cfif len(attributes.is_collected_invoice) and attributes.is_collected_invoice>checked</cfif> value="1">
						</div>
					</div>
					<div class="form-group" id="item-is_group_invoice">
						<label class="col col-2 col-xs-12" for="is_group_invoice"><cf_get_lang dictionary_id='41377.Grup Faturalama'></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="is_group_invoice" id="is_group_invoice" <cfif len(attributes.is_group_invoice) and attributes.is_group_invoice>checked</cfif> value="1">
						</div>
					</div>
					<div class="form-group" id="item-is_row_description">
						<label class="col col-2 col-xs-12" for="is_row_description">Formda Satır Açıklaması Gelsin</label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="is_row_description" id="is_row_description" <cfif len(attributes.is_row_description) and attributes.is_row_description>checked</cfif> value="1">
						</div>
					</div>
					<div class="form-group" id="item-is_allow_zero_price">
						<label class="col col-2 col-xs-12" for="is_allow_zero_price">Sıfır fiyatlı Satırlara İzin Ver</label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="is_allow_zero_price" id="is_allow_zero_price" <cfif len(attributes.is_allow_zero_price) and attributes.is_allow_zero_price>checked</cfif> value="1">
						</div>
					</div>
					<div class="form-group" id="item-cfc_file">
						<label class="col col-2 col-xs-12" for="cfc_file"><cf_get_lang dictionary_id="57691.Dosya"> (cfc) *</label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="file_del" id="file_del" value="">
							<div id="cfc_file_link_div"  style="<cfif len(attributes.cfc_file)>display:'';<cfelse>display:none;</cfif>">
								<cfoutput>#attributes.cfc_file#</cfoutput>.cfc
								<a href="javascript://" id="del_file" onclick="del_file();">
								<img src="/images/minus1.gif" border="0" align="absmiddle"></a>
							</div>
							<input type="file" name="cfc_file" id="cfc_file" style="<cfif not len(attributes.cfc_file)>display:'';<cfelse>display:none;</cfif>">
						</div>
					</div>
					<div class="form-group" id="item-type_description">
						<label class="col col-2 col-xs-12" for="type_description"><cf_get_lang dictionary_id="57629.Açıklama"></label>
						<div class="col col-8 col-xs-12">
							<cfmodule
								template="../../../fckeditor/fckeditor.cfm"
								toolbarSet="WRKContent"
								basePath="/fckeditor/"
								instanceName="type_description"
								valign="top"
								value="#attributes.type_description#"
								width="800"
								height="200">
						</div>
					</div>
				</div>
				<div class="row formContentFooter">
					<div class="col col-6">
						<cfif isDefined("type") and type.RecordCount gt 0>
							<cf_record_info query_name="type">
						</cfif>
					</div>
					<div class="col col-6">
						<cfif attributes.event EQ "upd">
							<cf_workcube_buttons is_upd='1' is_delete="0" add_function="controlFormImportType()">
						<cfelse>
							<cf_workcube_buttons is_upd='0' add_function="controlFormImportType()">
						</cfif>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>
<script type="text/javascript">
    function controlFormImportType()
    {
		if(!$("#import_type_name").val().length)
		{
			alert('<cf_get_lang_main no="782.girilmesi zorunlu alan">');
			$("#import_type_name").focus();
			return false;
		}
		
		if(document.getElementById("cfc_file").style.display =="" && !$("#cfc_file").val().length)
		{
			alert('<cf_get_lang_main no="782.girilmesi zorunlu alan">');
			$("#cfc_file").focus();
			return false;
		}
		if(document.getElementById("is_collected_invoice").checked && document.getElementById("is_group_invoice").checked){
			alert('Grup Faturalama ve Toplu Faturalama Aynı Anda Seçilemez');
			return false;
		}
		return true;
	}
	
	function del_file()
	{
		document.import_type.cfc_file.style.display='';
		document.getElementById("cfc_file_link_div").style.display='none';	
		document.import_type.file_del.value = 1;
	}
</script>