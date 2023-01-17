<cfinclude template="../query/get_stock.cfm">
<!---<cfinclude template="../query/get_stock_properties.cfm">--->
<cfinclude template="../query/get_product_unit.cfm">
<cfinclude template="../../sales/query/get_counter_type.cfm">
<cfinclude template="../query/get_money.cfm">
<cfquery name="GET_PROPERTIES" datasource="#DSN3#">
	SELECT
		STOCKS_PROPERTY.PROPERTY_ID,
		PRODUCT_PROPERTY.PROPERTY,
		STOCKS_PROPERTY.PROPERTY_DETAIL_ID,
		STOCKS_PROPERTY.PROPERTY_DETAIL,
		STOCKS_PROPERTY.TOTAL_MIN,
		STOCKS_PROPERTY.TOTAL_MAX
	FROM 
		#dsn1_alias#.PRODUCT_PROPERTY PRODUCT_PROPERTY,
		STOCKS_PROPERTY
	WHERE
		STOCKS_PROPERTY.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.stock_id#"> AND
		PRODUCT_PROPERTY.PROPERTY_ID = STOCKS_PROPERTY.PROPERTY_ID
	UNION ALL
	SELECT
		PRODUCT_PROPERTY.PROPERTY_ID,
		PRODUCT_PROPERTY.PROPERTY,
		'' PROPERTY_DETAIL_ID,
		'' PROPERTY_DETAIL,
		0 TOTAL_MIN,
		0 TOTAL_MAX
	FROM 
		#dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES,
		#dsn1_alias#.PRODUCT_PROPERTY PRODUCT_PROPERTY
	WHERE
		PRODUCT_ID = #get_stock.product_id# AND
		PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID AND
		PRODUCT_DT_PROPERTIES.PROPERTY_ID NOT IN(
			SELECT
				STOCKS_PROPERTY.PROPERTY_ID
			FROM 
				#dsn1_alias#.PRODUCT_PROPERTY PRODUCT_PROPERTY,
				STOCKS_PROPERTY
			WHERE
				STOCKS_PROPERTY.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.stock_id#"> AND
				PRODUCT_PROPERTY.PROPERTY_ID = STOCKS_PROPERTY.PROPERTY_ID
		)
	ORDER BY
		PRODUCT_PROPERTY.PROPERTY
</cfquery>
<cfif get_propertıes.recordcount>
	<cfquery name="GET_ALL_PROPERTY_DETAIL" datasource="#DSN1#">
		SELECT 
			PRPT_ID,
			PROPERTY_DETAIL,
			PROPERTY_DETAIL_ID
		FROM 
			PRODUCT_PROPERTY_DETAIL 
		WHERE 
			PRPT_ID IN (#valueList(get_propertıes.property_id)#)
		ORDER BY 
			PROPERTY_DETAIL
	</cfquery>
<cfelse>
	<cfset Get_All_Property_Detail.recordcount=0>
</cfif>
<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
	SELECT IS_BARCOD_REQUIRED FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="GET_LOT_NO" datasource="#DSN1#">
	SELECT * FROM LOT_NO_COUNTER WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.stock_id#">
</cfquery>
<cfquery name="get_main_product_unit" dbtype="query">
	SELECT PRODUCT_UNIT_ID, MAIN_UNIT, UNIT_ID, ADD_UNIT FROM get_product_unit WHERE IS_MAIN = 1
</cfquery>
<cfquery name="get_main_product_price_standart" datasource="#DSN3#">
	SELECT 
		SUM(TOTAL.PURCHASE_PRICE) AS TOTAL_PURCHASE_PRICE,
		SUM(TOTAL.SALES_PRICE) AS TOTAL_SALES_PRICE
	FROM(
		SELECT 
			ISNULL(PRICE,0) AS PURCHASE_PRICE, 
			0 AS SALES_PRICE
			FROM PRICE_STANDART WHERE PRODUCT_ID = #get_stock.PRODUCT_ID# AND PURCHASESALES = 0 AND PRICESTANDART_STATUS = 1
		UNION
		SELECT 0 AS PURCHASE_PRICE, ISNULL(PRICE,0) AS SALES_PRICE FROM PRICE_STANDART WHERE PRODUCT_ID = #get_stock.PRODUCT_ID# AND PURCHASESALES = 1 AND PRICESTANDART_STATUS = 1
	) AS TOTAL
</cfquery>

<cfif get_main_product_price_standart.recordcount>
	<cfset totalPurchasePrice = get_main_product_price_standart.TOTAL_PURCHASE_PRICE />
	<cfset totalSalesPrice = get_main_product_price_standart.TOTAL_SALES_PRICE />
<cfelse>
	<cfset totalPurchasePrice = 0 />
	<cfset totalSalesPrice = 0 />
</cfif>

<cfif len(get_stock.COUNTER_TYPE_ID) and get_stock.PRODUCT_UNIT_ID neq get_main_product_unit.PRODUCT_UNIT_ID>
	<cfquery name="get_stock_price_standart_purchase" datasource="#DSN1#">
		SELECT ISNULL(PRICE,0) AS PRICE,IS_KDV,PRICE_KDV,MONEY FROM PRICE_STANDART WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND PURCHASESALES = 0 AND PRICESTANDART_STATUS = 1
	</cfquery>
<cfelse>
	<cfset get_stock_price_standart_purchase = { PRICE: '', PRICE_KDV: '', IS_KDV: 0, MONEY: '' } />
	<cfset get_stock_price_standart_purchase .recordCount=0>
</cfif>

<cfif len(get_stock.COUNTER_TYPE_ID) and get_stock.PRODUCT_UNIT_ID neq get_main_product_unit.PRODUCT_UNIT_ID>
	<cfquery name="get_stock_price_standart_sales" datasource="#DSN1#">
		SELECT ISNULL(PRICE,0) AS PRICE,IS_KDV,PRICE_KDV,MONEY FROM PRICE_STANDART WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND PURCHASESALES = 1 AND PRICESTANDART_STATUS = 1
	</cfquery>
<cfelse>
	<cfset get_stock_price_standart_sales = { PRICE: '', PRICE_KDV: '', IS_KDV: 0, MONEY: '' } />
	<cfset get_stock_price_standart_sales.recordCount=0>
</cfif>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='57518.Stok Kodu'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#" popup_box="1">
		<cfform name="upd_property" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_stock_code">
			<cf_box_elements>
				<cfif not get_properties.recordcount>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='37309.Özellik kategorileri eklenmemiş'>...<br/>
						<cf_get_lang dictionary_id='37364.Stok kodlarını özelikleri görerek girmek için ilk önce özellik kategorileri ekleyin'>...<br/><br/>
						</label>
					</div>  
				</cfif>
	
				<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#url.pid#</cfoutput>">
				<input type="hidden" name="barcode_require" id="barcode_require" value="<cfoutput>#get_our_company_info.is_barcod_required#</cfoutput>">
				<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#get_stock.stock_id#</cfoutput>">
				<input type="hidden" name="pcode" id="pcode" value="<cfoutput>#attributes.pcode#</cfoutput>">
				<input type="hidden" name="purchase_is_kdv" id="purchase_is_kdv" value="<cfoutput>#get_stock_price_standart_purchase.recordcount ? get_stock_price_standart_purchase.IS_KDV : 0#</cfoutput>">
                <input type="hidden" name="purchase_price_kdv" id="purchase_price_kdv" value="<cfoutput>#get_stock_price_standart_purchase.recordcount ? get_stock_price_standart_purchase.PRICE_KDV : 0#</cfoutput>">
                <input type="hidden" name="sales_is_kdv" value="<cfoutput>#get_stock_price_standart_sales.recordcount ? get_stock_price_standart_sales.IS_KDV : 0#</cfoutput>">
                <input type="hidden" name="sales_price_kdv" value="<cfoutput>#get_stock_price_standart_sales.recordcount ? get_stock_price_standart_sales.PRICE_KDV : 0#</cfoutput>">
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true" >
					<div class="form-group" id="item-stock_status">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>  
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="stock_status" id="stock_status" 
							<cfif get_stock.stock_code eq attributes.pcode>
								<cfif attributes.is_product_status eq 1>
									checked
								</cfif>
							<cfelseif get_stock.stock_status eq 1>
									checked
							</cfif>>
						
						<cf_get_lang dictionary_id='57493.Aktif'>
						</div>
					</div> 
					<div class="form-group" id="item-stock_status">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43506.Seri Takip'></label>  
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="text" name="serial_barcod" id="serial_barcod" onkeyup="isNumber(this);" maxlength="6" value="<cfoutput>#get_stock.serial_barcod#</cfoutput>" style="width:170px;">
						</div>
					</div>
				
					<div class="form-group" id="item-new_stock_code">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57518.Stok Kodu'> *</label>  
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57518.Stok Kodu'>?</cfsavecontent>
						<cfinput type="text" name="new_stock_code" id="new_stock_code" value="#get_stock.stock_code#" required="yes" message="#message#" style="width:170px;">
						</div>
					</div>             
					<div class="form-group" id="item-barcod">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57633.Barkod'></label>  
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="old_barcod" id="old_barcod" value="<cfoutput>#get_stock.barcod#</cfoutput>">
								<input type="text" name="barcod" id="barcod" value="<cfoutput>#get_stock.barcod#</cfoutput>" maxlength="50" style="width:170px;" onKeyUp="barcod_control();">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="33505.Yeni Otomatik Barkod Oluşturulacak! Emin misiniz?"></cfsavecontent>
								<cfif is_auto_barcode eq 0>
									<span class="input-group-addon btnPointer icon-ellipsis"onclick="javascript:if (confirm('<cfoutput>#message#</cfoutput>')) document.upd_property.barcod.value='<cfoutput>#get_barcode_no()#</cfoutput>'; else return;"><img src="/images/plus_thin.gif" border="0" id="barcode_image" title="<cf_get_lang dictionary_id='37940.Otomatik barkod'> !" align="absbottom"></span>
								<cfelse>
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:if (confirm('<cfoutput>#message#</cfoutput>')) document.upd_property.barcod.value='<cfoutput>#get_barcode_no(1)#</cfoutput>'; else return;"><img src="/images/plus_thin.gif" border="0" id="barcode_image" title="<cf_get_lang dictionary_id='37940.Otomatik barkod'>" align="absbottom"></span>
								</cfif>
							</div>
						</div>
					</div> 
					<div class="form-group" id="item-stock_code_2">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>  
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57789.Özel Kod'> ?</cfsavecontent>
							<cfinput type="text" name="stock_code_2" id="stock_code_2" message="#message#" value="#get_stock.stock_code_2#"  maxlength="150">
							<input type="hidden" name="old_stock_code_2" id="old_stock_code_2" value="<cfoutput>#get_stock.stock_code_2#</cfoutput>">
						</div>
					</div> 
					<div class="form-group" id="item-friendly_url">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63171.Friendly url'></label>  
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="friendly_url" id="friendly_url" maxlength="1000" value="<cfoutput>#get_stock.friendly_url#</cfoutput>" >
						</div>
					</div>
					<div class="form-group" id="item-lot_no">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37155.Lot No'></label>  
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="lot_no" id="lot_no" maxlength="50" value="<cfoutput>#GET_LOT_NO.LOT_NO#</cfoutput>" >
						</div>
					</div> 
					<div class="form-group" id="item-lot_number">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37624.Sıra No'></label>  
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="lot_number" id="lot_number" maxlength="50" value="<cfoutput>#GET_LOT_NO.LOT_NUMBER#</cfoutput>" >
						</div>
					</div> 
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true" >
					<div class="form-group" id="item-property_detail">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>  
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="text" name="property_detail" id="property_detail" maxlength="500" value="<cfoutput>#get_stock.property#</cfoutput>" >
								<span class="input-group-addon">
									<cf_language_info 
										table_name="STOCKS" 
										column_name="PROPERTY" 
										column_id_value="#url.stock_id#" 
										maxlength="500" 
										datasource="#dsn1#" 
										column_id="STOCK_ID" 
										control_type="0">
								</span>
							</div>
						</div>
					</div> 
					<div class="form-group" id="item-MANUFACT_CODE">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57634.Üretici Kodu'></label>  
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="hidden" name="old_manufact_code" id="old_manufact_code" value="<cfoutput>#get_stock.manufact_code#</cfoutput>">
							<input type="text" name="manufact_code" id="manufact_code" maxlength="50" value="<cfoutput>#get_stock.manufact_code#</cfoutput>" >
						</div>
					</div> 
					<div class="form-group" id="item-property_detail">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57636.Birim'></label>  
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="unit" id="unit" >
								<cfoutput query="get_product_unit">
									<option value="#product_unit_id#" <cfif product_unit_id eq get_stock.product_unit_id>selected</cfif>>#add_unit#</option>
								</cfoutput>
							</select>
						</div>
					</div> 
					<div class="form-group" id="item-counter_type_id">
						<label class="col col-4"><cf_get_lang dictionary_id='41282.Sayaç Tipi'> *</label>
						<div class="col col-8">
							<select name="counter_type_id" id="counter_type_id">
								<option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
								<cfoutput query="get_counter_type">
									<option value="#counter_type_id#" <cfif get_stock.COUNTER_TYPE_ID eq counter_type_id> selected</cfif>>#counter_type#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-counter_multiplier" <cfif not len(get_stock.COUNTER_TYPE_ID) or get_stock.PRODUCT_UNIT_ID eq get_main_product_unit.PRODUCT_UNIT_ID>style="display:none;"</cfif>>
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64089.Sayaç Çarpanı'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">	
								<cfinput type="text" name="counter_multiplier" id="counter_multiplier" onkeyup="FormatCurrency(this,event,2)" class="moneybox" value="#len( get_stock.COUNTER_MULTIPLIER ) ? TLFormat(get_stock.COUNTER_MULTIPLIER) : ''#" onblur="calculate_purchase_sales_price('counter_multiplier')">
								<span class="input-group-addon bold">*<cfoutput>#get_product_unit.main_unit#</cfoutput></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-purchase_price" <cfif not len(get_stock.COUNTER_TYPE_ID) or get_stock.PRODUCT_UNIT_ID eq get_main_product_unit.PRODUCT_UNIT_ID>style="display:none;"</cfif>>
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64091.Stok Alış Fiyatı'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="purchase_price" id="purchase_price" onkeyup="FormatCurrency(this,event,2)" class="moneybox" onblur="calculate_purchase_sales_price('purchase_price')" value="#len( get_stock_price_standart_purchase.PRICE ) ? TLFormat(get_stock_price_standart_purchase.PRICE, 2) : ''#">
								<span class="input-group-addon width">
									<select name="purchase_money" id="purchase_money">
										<cfoutput query="get_money">
											<option value="#money#" <cfif get_stock_price_standart_purchase.MONEY eq get_money.money> selected</cfif>>#get_money.money#</option>
										</cfoutput>
									</select>
								</span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-sales_price" <cfif not len(get_stock.COUNTER_TYPE_ID) or get_stock.PRODUCT_UNIT_ID eq get_main_product_unit.PRODUCT_UNIT_ID>style="display:none;"</cfif>>
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64092.Stok Satış Fiyatı'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="sales_price" id="sales_price" onkeyup="FormatCurrency(this,event,2)" class="moneybox" onblur="calculate_purchase_sales_price('sales_price')" value="#len( get_stock_price_standart_sales.PRICE ) ? TLFormat(get_stock_price_standart_sales.PRICE, 2) : ''#">
								<span class="input-group-addon width">
									<select name="sales_money" id="sales_money">
										<cfoutput query="get_money">
											<option value="#money#" <cfif get_stock_price_standart_sales.MONEY eq get_money.money> selected</cfif>>#get_money.money#</option>
										</cfoutput>
									</select>
								</span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-MANUFACT_CODE">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62907.Asorti Miktarı'></label>  
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="assortment_default_amount" id="assortment_default_amount" maxlength="10" value="<cfoutput>#get_stock.ASSORTMENT_DEFAULT_AMOUNT#</cfoutput>" >
						</div>
					</div> 
				</div>
			</cf_box_elements>
		<cfset sayi = 009>
		<cfset sayi = add_one(sayi)>
		 <cfscript>
		/* 	writeOutput(sayi); */
		</cfscript>
		 <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="3" sort="true">
		<cfif  get_properties.recordcount>
			
			<cf_grid_list>
				<thead>
				<tr>
					<cfif get_properties.recordcount>
						<th><cf_get_lang dictionary_id='58910.Özellikler'></th>
						<th><cf_get_lang dictionary_id='37249.Varyasyon'></th>
						<th><cf_get_lang dictionary_id='57629.Aciklama'></th>
						<th colspan="2"><cf_get_lang dictionary_id='37388.Degerler'></th>
					</cfif>
				</tr>
				</thead>
				<tbody>
					<cfloop query="get_properties">
						<cfif get_All_Property_Detail.recordcount>				  	
							<tr>
								<td width="80">
									<input type="hidden" id="property_id_<cfoutput>#currentrow#</cfoutput>" name="property_id_<cfoutput>#currentrow#</cfoutput>" value="<cfoutput>#get_properties.property_id#</cfoutput>">
									<cfoutput>#get_properties.property#</cfoutput>
								</td>
								<td width="200px">
									<cfquery name="GET_ALL_PROPERTY_DETAIL_ROW" dbtype="query">
										SELECT 
											PROPERTY_DETAIL,
											PROPERTY_DETAIL_ID 
										FROM 
											GET_ALL_PROPERTY_DETAIL
										WHERE
											PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_properties.property_id#">
											
									</cfquery>					
									<select id="sub_property_list_<cfoutput>#currentrow#</cfoutput>" name="sub_property_list_<cfoutput>#currentrow#</cfoutput>" style="width:200px;">
										<option value=""><cf_get_lang dictionary_id='57734.Seç'></option>
										<cfoutput query="Get_All_Property_Detail_Row">
											<option value="#property_detail_id#" <cfif get_properties.property_detail_id eq property_detail_id>selected</cfif>>#property_detail#</option>
										</cfoutput>
									</select>
								</td>
								<td><input type="text" name="property_detail2_<cfoutput>#currentrow#</cfoutput>" id="property_detail2_<cfoutput>#currentrow#</cfoutput>" value="<cfoutput>#get_properties.property_detail#</cfoutput>" maxlength="150"  style="width:220px;"></td>
								<td><input type="text" name="total_min_<cfoutput>#currentrow#</cfoutput>" id="total_min_<cfoutput>#currentrow#</cfoutput>" value="<cfoutput>#tlformat(get_properties.total_min,2)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:60px;"></td>
								<td><input type="text" name="total_max_<cfoutput>#currentrow#</cfoutput>" id="total_max_<cfoutput>#currentrow#</cfoutput>" value="<cfoutput>#tlformat(get_properties.total_max,2)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:60px;"></td>
							</tr>
						</cfif> 
					</cfloop>
				</tbody>
			</cf_grid_list>
		
		</cfif>
			<input type="hidden" name="property_count" id="property_count" value="<cfoutput>#get_properties.recordcount#</cfoutput>">
	
		<cf_box_footer>
			<cf_record_info query_name="get_stock">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>
			<cf_workcube_buttons is_upd='0' insert_info='#message#' add_function='form_kontrol()'>
		</cf_box_footer>
	</div>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	row_count = <cfoutput>#get_properties.recordcount#</cfoutput>;
	function form_kontrol()
	{
		<cfif isDefined('attributes.is_inventory') and attributes.is_inventory is 1>
			if(document.getElementById('barcode_require').value == 1 && trim(document.getElementById('barcod').value).length<7)
			{
				alert("<cf_get_lang dictionary_id='37682.Envantere Dahil Ürünler İçin En Az 7 Karakter Barkod Girmelisiniz'>!");
				return false;
			}
		</cfif>		
		<cfif isDefined('attributes.is_terazi') and attributes.is_terazi is 1>
			if(trim(document.getElementById('barcod').value).length!=7)
			{
				alert("<cf_get_lang dictionary_id='37681.Teraziye Giden Ürünler İçin Barkod 7 Karakter Olmalıdır'>!");
				return false;
			}
		</cfif>
		for(var k=1;k<=row_count;k++)
		{
			if(eval("document.getElementById('total_max_"+k+"')") != undefined) eval("document.getElementById('total_max_"+k+"')").value = filterNum(eval("document.getElementById('total_max_"+k+"')").value);
			if(eval("document.getElementById('total_min_"+k+"')") != undefined) eval("document.getElementById('total_min_"+k+"')").value = filterNum(eval("document.getElementById('total_min_"+k+"')").value);
		}
		<cfif isDefined("attributes.draggable")>
			loadPopupBox('upd_property', <cfoutput>#attributes.modal_id#</cfoutput>);
			return false;
		<cfelse>
			return true;
		</cfif>	
	}
 	function barcod_control()
	{
		var prohibited_asci='32,33,34,35,36,37,38,39,40,41,42,43,44,59,60,61,62,63,64,91,92,93,94,96,123,124,125,156,171,187,163,126';
	    barcode = document.getElementById('barcod');
		toplam_ = barcode.value.length;
		deger_ = barcode.value;
		if(toplam_>0)
		{
			for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
			{
				tus_ = deger_.charAt(this_tus_);
				cont_ = list_find(prohibited_asci,tus_.charCodeAt());
				if(cont_>0)
				{
					alert("[space],!,\"\,#,$,%,&,',(,),*,+,,;,<,=,>,?,@,[,\,],],`,{,|,},£,~ Karakterlerinden Oluşan Barcod Girilemez!");
					barcode.value = '';
					break;
				}
			}
		}
	}

	$("form[name = upd_property] select[name = unit], form[name = upd_property] select[name = counter_type_id]").on('change', function(){
		if( $("form[name = upd_property] select[name = counter_type_id]").val() != '' && $("form[name = upd_property] select[name = unit]").val() != '<cfoutput>#get_main_product_unit.PRODUCT_UNIT_ID#</cfoutput>' )
			$("#item-counter_multiplier, #item-purchase_price, #item-sales_price").show();
		else{
			$("#item-counter_multiplier, #item-purchase_price, #item-sales_price").hide().find("input").val('');
		}
	});

	function calculate_purchase_sales_price( element_type )
	{
		var totalPurchasePrice = <cfoutput>#totalPurchasePrice#</cfoutput>;
		var totalSalesPrice = <cfoutput>#totalSalesPrice#</cfoutput>;

		var counter_multiplier = document.upd_property.counter_multiplier;
		var purchase_price = document.upd_property.purchase_price;
		var sales_price = document.upd_property.sales_price;

		if( element_type == 'counter_multiplier' ){
			if( counter_multiplier.value != '' ){
				counter_multiplier.value = commaSplit( filterNum(counter_multiplier.value, 2), 2 );
				purchase_price.value = commaSplit( (filterNum( counter_multiplier.value, 2 ) * totalPurchasePrice),2 );
				sales_price.value = commaSplit( (filterNum( counter_multiplier.value, 2 ) * totalSalesPrice),2 );
			}else{
				purchase_price.value = 0;
				sales_price.value = 0;
			}
		}else if( element_type == 'purchase_price' ){
			if( purchase_price.value != '' ){
				purchase_price.value = commaSplit( filterNum(purchase_price.value, 2),2 );
				counter_multiplier.value = commaSplit( (filterNum( purchase_price.value, 2 ) / totalPurchasePrice), 2 );
				sales_price.value = commaSplit( (filterNum( counter_multiplier.value, 2 ) * totalSalesPrice),2 );
			}
		}else if( element_type == 'sales_price' ){
			if( sales_price.value != '' ){
				sales_price.value = commaSplit( filterNum(sales_price.value, 2),2 );
				counter_multiplier.value = commaSplit( (filterNum( sales_price.value, 2 ) / totalSalesPrice),2 );
				purchase_price.value = commaSplit( (filterNum( counter_multiplier.value, 2 ) * totalPurchasePrice),2 );
			}
		}

	}

</script>