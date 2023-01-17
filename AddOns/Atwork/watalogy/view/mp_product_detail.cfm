<cfset attributes.pid = attributes.product_id>
<cfparam name="is_commission" default="">
<cf_xml_page_edit fuseact="product.form_add_product">
<cf_get_lang_set module_name="product"><!--- sayfanin en altinda kapanisi var --->
<cfscript>
	if (isnumeric(attributes.pid))
	{
		get_product_list_action = createObject("component", "V16.product.cfc.get_product");
		get_product_list_action.dsn1 = dsn1;
		get_product_list_action.dsn_alias = dsn_alias;
		GET_PRODUCT = get_product_list_action.get_product_
		(
			pid : attributes.pid
		);
	}
	else
	{
		get_product.recordcount = 0;
	}
</cfscript>
<cfinclude template="../../../../product/query/get_code_cat.cfm">
<cfquery name="get_product_period" datasource="#dsn3#">
    	SELECT 
			PRODUCT_PERIOD.PRODUCT_PERIOD_CAT_ID 
		FROM 
			PRODUCT_PERIOD,
			#dsn_alias#.SETUP_PERIOD SP
		WHERE 
			SP.PERIOD_ID = PRODUCT_PERIOD.PERIOD_ID 
		AND 
			SP.PERIOD_YEAR = #session.ep.period_year# 
		AND 
			PRODUCT_PERIOD.PRODUCT_ID = #attributes.pid# 
		AND 
			SP.OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>

<cfif get_product_period.recordcount>
	<cfset product_period_cat_id = get_product_period.PRODUCT_PERIOD_CAT_ID>
</cfif>
<cfif not get_product.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1230.Urun Kaydı Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
    SELECT IS_BRAND_TO_CODE,IS_BARCOD_REQUIRED,IS_GUARANTY_FOLLOWUP,IS_PRODUCT_COMPANY FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="GET_PRODUCT_TREE" datasource="#DSN3#">
	SELECT 
        PT.PRODUCT_ID
    FROM 
        PRODUCT_TREE PT,
        STOCKS S
    WHERE 
        S.STOCK_ID = PT.STOCK_ID AND
        S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
</cfquery>
<cfinclude template="../../../../product/query/get_product_stock_id.cfm">
</cfif>

<cfif GET_OUR_COMPANY_INFO.IS_PRODUCT_COMPANY EQ 1>
<!--- Sirket Akis Parametrelerinde Ürün parametre bilgisi şirkete bağlı olarak gelsin mi secenegi evet ise buradan ceker, degilse eski yapi devam eder --->
    <cfquery name="get_general_parameters" datasource="#dsn1#">
        SELECT
            PRODUCT_PARAMETERS_ID, 
            PRODUCT_ID, 
            COMPANY_ID, 
            PRODUCT_STATUS, 
            IS_INVENTORY, 
            IS_PRODUCTION, 
            IS_SALES, 
            IS_PURCHASE, 
            IS_PROTOTYPE, 
            IS_INTERNET, 
            IS_EXTRANET, 
            IS_TERAZI, 
            IS_KARMA, IS_ZERO_STOCK, 
            IS_LIMITED_STOCK, 
            IS_SERIAL_NO, 
            IS_COST, 
            IS_QUALITY, 
            IS_COMMISSION, 
            OUR_COMPANY_ID, 
            PRODUCT_MANAGER, 
            IS_ADD_XML, 
            IS_GIFT_CARD, 
            GIFT_VALID_DAY, 
            QUALITY_START_DATE, 
            IS_LOT_NO
        FROM 
            PRODUCT_GENERAL_PARAMETERS
        WHERE 
            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> 
            AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
    <cfif get_general_parameters.recordcount>
		<cfset get_product.product_status =get_general_parameters.product_status>
        <cfset get_product.is_inventory = get_general_parameters.is_inventory>
        <cfset get_product.is_production = get_general_parameters.is_production>
        <cfset get_product.is_sales = get_general_parameters.is_sales>
        <cfset get_product.is_purchase = get_general_parameters.is_purchase>
        <cfset get_product.is_prototype = get_general_parameters.is_prototype>
        <cfset get_product.is_internet = get_general_parameters.is_internet>
        <cfset get_product.is_extranet = get_general_parameters.is_extranet>
        <cfset get_product.is_terazi = get_general_parameters.is_terazi>
        <cfset get_product.is_karma = get_general_parameters.is_karma>
        <cfset get_product.is_zero_stock = get_general_parameters.is_zero_stock>
        <cfset get_product.is_limited_stock = get_general_parameters.is_limited_stock>
        <cfset get_product.is_serial_no = get_general_parameters.is_serial_no>
        <cfset get_product.is_lot_no = get_general_parameters.is_lot_no>
        <cfset get_product.is_cost = get_general_parameters.is_cost>
        <cfset get_product.is_quality = get_general_parameters.is_quality>
        <cfset get_product.is_commission = get_general_parameters.is_commission>
        <cfset get_product.is_add_xml = get_general_parameters.is_add_xml>
        <cfset get_product.is_gift_card = get_general_parameters.is_gift_card>
        <cfset get_product.company_id = get_general_parameters.company_id>
        <cfset get_product.quality_start_date = get_general_parameters.quality_start_date>
        <cfset get_product.gift_valid_day = get_general_parameters.gift_valid_day>
        <cfset get_product.product_manager = get_general_parameters.product_manager>
	</cfif>
</cfif> 
<style>
body {font-family: Arial;}

/* Style the tab */
.tab {
    overflow: hidden;
    border: 1px solid #ccc;
    background-color: #f1f1f1;
}

/* Style the buttons inside the tab */
.tab button {
    background-color: inherit;
    float: left;
    border: none;
    outline: none;
    cursor: pointer;
    padding: 14px 16px;
    transition: 0.3s;
    font-size: 17px;
}

/* Change background color of buttons on hover */
.tab button:hover {
    background-color: #ddd;
}

/* Create an active/current tablink class */
.tab button.active {
    background-color: #ccc;
}

/* Style the tab content */
.tabcontent {
    display: none;
    padding: 6px 12px;
    border: 1px solid #ccc;
    border-top: none;
}
</style>
<cfquery name="get_stock" datasource="#dsn2#">
SELECT 
	GPS.PRODUCT_TOTAL_STOCK,
	(SELECT TOP 1 PI.PATH FROM #dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = GPS.PRODUCT_ID AND PI.IMAGE_SIZE = 2) AS URUN_RESMI
FROM 
	GET_PRODUCT_STOCK GPS
WHERE 
	PRODUCT_ID = #attributes.pid#
</cfquery>
<cfquery name="get_guaranty_cat" datasource="#dsn#">
	SELECT * FROM SETUP_GUARANTY
</cfquery>
<cfquery name="get_product_guaranty" datasource="#dsn3#">
	SELECT * FROM PRODUCT_GUARANTY WHERE PRODUCT_ID = #attributes.pid#
</cfquery>
<cfquery name="get_market_place" datasource="#dsn#">
	SELECT MARKET_PLACE_ID,MARKET_PLACE FROM MARKET_PLACE_SETTINGS
</cfquery>
<cfquery name="get_market_place_product_info" datasource="#dsn#">
	SELECT * FROM MARKET_PLACE_PRODUCT WHERE PRODUCT_ID = #attributes.pid#
</cfquery>

<cfoutput>
<div class="row">
	<div class="col col-3 col-md-6 col-sm-6 col-xs-12">
		<div class="col col-12 portBox">                                                    
			<div class="portHead color-">Ürün Detay</div>
			<div class="portBody" style="display: block;">
			<cfif isdefined("get_stock.URUN_RESMI") and len(get_stock.URUN_RESMI)>
				<img src="/#get_stock.URUN_RESMI#" style="width:100%;"></img>
			<cfelse>
				<img src="/documents/images/urun-resim-yok.png"></img>
			</cfif>
			</div>
		</div>
	</div>
	<div class="col col-9 col-md-6 col-sm-6 col-xs-12">
		<div class="col col-12 portBox">                                                    
			<div class="portHead color-"></div>
			<div class="portBody" style="display: block;">
				<div class="product-tab" id="product-tab-div">
					<div class="tab">
					  <button class="tablinks active" onclick="openTab(event, 'Urun_Detay')">Ürün Detay</button>
					<cfloop query="get_market_place">
					  <button class="tablinks" onclick="openTab(event, 'mp_ayar_#get_market_place.market_place#')">#get_market_place.market_place#</button>					 
					</cfloop>
					</div>

					<div id="Urun_Detay" class="tabcontent active">
					<h3>Genel Bilgiler</h3>
					<p>&nbsp;</p>
					  <h5>Ürün İsmi</h5>
					  <p></p>
					  <label class="input-group">
						<input type="text" name="invoice_name" id="invoice_name" value="#get_product.product_name#" style="width:300px !important" readonly>
					  </label>
					   <h5>Kategori</h5>
					   <cfset attributes.ID = get_product.product_catid>
						<cfinclude template="../../../../product/query/get_product_cat.cfm">
					   <label class="input-group">
						<input type="text" name="kategori_name" id="kategori_name" value="#get_product_cat.hierarchy# #get_product_cat.product_cat#" style="width:300px !important" readonly>
					  </label>
					  <div class="form-group require">
							<label class="form-check-label">
								<p>Garanti(Ay)</p>
								<input type="text" name="garanti" id="garanti" value="#get_product_guaranty.support_duration#" readonly>
							</label>&nbsp;&nbsp;&nbsp;
							<label>
								<p>Ürün Kodu</p>
								<input type="text" name="product_code" id="product_code" value="#get_product.product_code#" readonly>
							</label>&nbsp;&nbsp;&nbsp;
							<label>
								<p>Stok</p>
								<input type="text" name="stock_code" id="stock_code" value="#get_stock.PRODUCT_TOTAL_STOCK#" readonly>
							</label>&nbsp;&nbsp;&nbsp;
							<label>
								<p>Kdv</p>
								<input type="text" name="kdv" id="kdv" value="#get_product.tax#" readonly>
							</label>&nbsp;&nbsp;&nbsp;
							<label>
								<p>Barkod</p>
								<input type="text" name="barkod" id="barkod" value="#get_product.barcod#" readonly>
							</label>&nbsp;&nbsp;&nbsp;
							<label>
								<p>Desi</p>
								<input type="text" name="desi" id="desi" value="#get_product.desi_value#" readonly>
							 </label>
						</div>
						<p>&nbsp;</p>
						<p>&nbsp;</p>
						<h3>Tedarikçi Bilgileri</h3>
						<p>&nbsp;</p>

						<div class="form-group require">
							<label class="form-check-label">
								<p>Tedarikçi Adı</p>
								<input type="text" name="tedarikci_name" id="tedarikci_name" value="" style="width:350px !important;" readonly>
							</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<label>
								<p>Tedarikçi Kategorisi</p>
								<input type="text" name="tedarikci_cat" id="tedarikci_cat" value="" style="width:350px !important;" readonly>
							</label>
						</div>
						<p>&nbsp;</p>
						<p>&nbsp;</p>
						<div class="form-group require">
							<label class="form-check-label">
								<p>Tedarikçi Fiyatı</p>
								<input type="text" name="tedarikci_fiyat" id="tedarikci_fiyat" style="width:180px !important;" value=""> 
							</label>&nbsp;&nbsp;&nbsp;
						
							<label class="form-check-label">
								<p>Psf Fiyatı</p>
								<input type="text" name="psf_fiyat" id="psf_fiyat" style="width:180px !important;" value="">
							</label>&nbsp;&nbsp;&nbsp;
							
							<label class="form-check-label">
								<p>Tedarikçi Ürün Kodu</p>
								<input type="text" name="ted_product_code" id="ted_product_code" style="width:180px !important;" value="">
							</label>&nbsp;&nbsp;&nbsp;
							
							<label class="form-check-label">
								<p>Tedarikçi Marka</p>
								<input type="text" name="ted_marka" id="ted_marka" style="width:180px !important;" value="">
							</label>
						</div>
						
					</div>
				<form name="mp_product_set" id="mp_product_set" action="#request.self#?fuseaction=product.emptypopup_upd_mp_product_detail" method="post">
				<input type="hidden" name="mp_id" id="mp_id" value="">
				<input type="hidden" name="mp_product_id" id="mp_product_id" value="#attributes.pid#">
				<input type="hidden" name="mp_product_cat_id" id="mp_product_cat_id" value="#attributes.ID#">
					<cfloop query="get_market_place">
					<cfquery name="get_market_place_product_info" datasource="#dsn#">
						SELECT * FROM MARKET_PLACE_PRODUCT WHERE PRODUCT_ID = #attributes.pid# AND MARKET_PLACE_ID = #get_market_place.market_place_id#
					</cfquery>
						<div id="mp_ayar_#get_market_place.market_place#" class="tabcontent">
							<p>#get_market_place.market_place# Ayarları</p>
							<p>&nbsp;</p>
							<h3>Ürün Bilgileri</h3><hr>
							<p>&nbsp;</p>
							<h5>Ürün İsmi</h5>
							<label class="input-group">
								<input type="text" name="mp_product_name_#get_market_place.market_place_id#" id="mp_product_name_#get_market_place.market_place_id#" value="<cfif isdefined("get_market_place_product_info.product_name") and len(get_market_place_product_info.product_name) and (get_market_place_product_info.market_place_id) eq (get_market_place.market_place_id)>#get_market_place_product_info.product_name#</cfif>" style="width:200px !important;">
							</label>
							<div class="form-group require">
								<label class="form-check-label">
									<p>Fiyat</p>
									<input type="text" name="mp_product_price_#get_market_place.market_place_id#" id="mp_product_price_#get_market_place.market_place_id#" value="<cfif isdefined("get_market_place_product_info.mp_price") and len(get_market_place_product_info.mp_price) and (get_market_place_product_info.market_place_id) eq (get_market_place.market_place_id)>#get_market_place_product_info.mp_price#</cfif>" style="width:200px !important;">
								</label>&nbsp;&nbsp;&nbsp;
						
								<label class="form-check-label">
									<p>Perakende Satış fiyatı(Psf)</p>
									<input type="text" name="mp_product_prk_price_#get_market_place.market_place_id#" id="mp_product_prk_price_#get_market_place.market_place_id#" value="<cfif isdefined("get_market_place_product_info.psf_price") and len(get_market_place_product_info.psf_price) and (get_market_place_product_info.market_place_id) eq (get_market_place.market_place_id)>#get_market_place_product_info.psf_price#</cfif>" style="width:200px !important;">
								</label>&nbsp;&nbsp;&nbsp;
							 
								<label  class="form-check-label">
									<p>Stok</p>
									<input type="text" name="mp_product_stock_#get_market_place.market_place_id#" id="mp_product_stock_#get_market_place.market_place_id#" value="<cfif isdefined("get_market_place_product_info.stock") and len(get_market_place_product_info.stock) and (get_market_place_product_info.market_place_id) eq (get_market_place.market_place_id)>#get_market_place_product_info.stock#</cfif>" style="width:200px !important;">
								</label>&nbsp;&nbsp;&nbsp;
								<label class="form-check-label">
									<p>Desi</p>
									<input type="text" name="mp_product_desi_#get_market_place.market_place_id#" id="mp_product_desi_#get_market_place.market_place_id#" value="<cfif isdefined("get_market_place_product_info.desi") and len(get_market_place_product_info.desi) and (get_market_place_product_info.market_place_id) eq (get_market_place.market_place_id)>#get_market_place_product_info.desi#</cfif>" style="width:200px !important;">
								</label>
								<p>&nbsp;</p>
								<cf_record_info query_name="get_product" record_emp="record_emp" update_emp="update_emp">
								<div align="right">
									<input type="submit" value="<cfif get_market_place_product_info.recordcount>GÜNCELLE<cfelse>KAYDET</cfif>" onclick="document.getElementById('mp_id').value = #get_market_place.market_place_id#"></input>
								</div>
							</div>
					 
							<div class="form-group require">
								<h3>Kargo Ayarları</h3><hr>
								<p>&nbsp;</p>
								<label class="form-check-label">
									Kargo Ödeme Bilgisi
									<select name="cargo_payment_info" id="cargo_payment_info" value="">
										<option value=""  id="cargo_payment_info_id"></option>
									</select>
								</label>&nbsp;&nbsp;&nbsp;
								<label class="form-check-label">
									Kargo Şirketi
									<select name="shipping_company" id="shipping_company_N11" value="">
										<option value=""  id="shipping_company_id"></option>
									</select>
								</label>&nbsp;&nbsp;&nbsp;
								<label class="form-check-label">
									Gönderim Saati
									<select name="shipping_time" id="shipping_time" value="">
										<option value=""  id="shipping_time_id"></option>
									</select>
								</label>&nbsp;&nbsp;&nbsp;
								<label class="form-check-label">
									Kargo Süresi
									<input type="text" name="cargo_time" id="cargo_time" value="">
								</label>&nbsp;&nbsp;&nbsp;
								<label class="form-check-label">
									Teslimat Şablonu
									<input type="text" name="delivery_template" id="delivery_template" value="">
								</label>&nbsp;&nbsp;&nbsp;
								<p>&nbsp;</p>
								<cf_record_info query_name="get_product" record_emp="record_emp" update_emp="update_emp">
								<div align="right">
									<input type="submit" value="KAYDET" onclick="document.getElementById('mp_id').value == #get_market_place.market_place_id#"></input>
								</div>
							</div>
							<div align="right">
								<p>&nbsp;</p>
								<input type="submit" value="Pazar Yerine Kaydet" onclick=""></input>
								<input type="submit" value="Pazar Yerinde Yayınla" onclick=""></input>
								<input type="submit" value="Yayından Kaldır" onclick=""></input>
							</div>
						</div>
					</cfloop>
					</form>
				</div>
			</div>
		</div>
	</div>
</div> 


</cfoutput>
<script>
function openTab(evt, tabName) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
    document.getElementById(tabName).style.display = "block";
    evt.currentTarget.className += " active";
	
	pageload("Urun_Detay");
}
</script>
   