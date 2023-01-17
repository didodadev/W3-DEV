<cf_xml_page_edit fuseact="product.form_add_product">
<cfinclude template="../query/get_product_unit.cfm">
<cfinclude template="../../sales/query/get_counter_type.cfm">
<cfinclude template="../query/get_money.cfm">
<cfquery name="GET_PROPERTIES" datasource="#DSN1#">
	SELECT
		PRODUCT_DT_PROPERTIES.*,
		PRODUCT_PROPERTY.PROPERTY,
		PRODUCT_PROPERTY.VARIATION_ID
	FROM 
		PRODUCT_DT_PROPERTIES,
		PRODUCT_PROPERTY
	WHERE
		PRODUCT_ID = #attributes.pid# AND
		PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID
</cfquery>
<cfquery name="stock_count" datasource="#DSN3#">
	SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
</cfquery>
<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
    SELECT IS_BARCOD_REQUIRED FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
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
<cfquery name="get_main_product_unit" dbtype="query">
	SELECT PRODUCT_UNIT_ID, MAIN_UNIT, UNIT_ID, ADD_UNIT FROM get_product_unit WHERE IS_MAIN = 1
</cfquery>
<cfquery name="get_main_product_price_standart" datasource="#DSN1#">
    SELECT
        PRICESTANDART_ID, 
        PURCHASESALES,
        ISNULL(PRICE,0) AS PRICE, 
        IS_KDV,
        PRICE_KDV,
        MONEY
    FROM PRICE_STANDART 
    WHERE PRODUCT_ID = <cfqueryparam value="#attributes.pid#" cfsqltype="cf_sql_integer"> AND PRICESTANDART_STATUS = 1
</cfquery>

<cfif get_main_product_price_standart.recordcount>
    <cfquery name="price_standart_purchase" dbtype="query">
        SELECT * FROM get_main_product_price_standart WHERE PURCHASESALES = 0
    </cfquery>
    <cfset totalPurchasePrice = price_standart_purchase.recordcount ? price_standart_purchase.PRICE : 0 />

    <cfquery name="price_standart_sales" dbtype="query">
        SELECT * FROM get_main_product_price_standart WHERE PURCHASESALES = 1
    </cfquery>
    <cfset totalSalesPrice = price_standart_sales.recordcount ? price_standart_sales.PRICE : 0 />
<cfelse>
    <cfset price_standart_purchase = { recordcount: 0 } />
    <cfset price_standart_sales = { recordcount: 0 } />
    <cfset totalPurchasePrice = 0 />
    <cfset totalSalesPrice = 0 />
</cfif>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='57518.Stok Kodu'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#message#" popup_box="1">
        <cfform name="add_property" method="post" action="#request.self#?fuseaction=product.add_popup_stock_code">
            <cf_box_elements>
                <cfif not get_properties.recordcount>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='37309.Özellik kategorileri eklenmemiş'>...<br/>
                        <cf_get_lang dictionary_id='37364.Stok kodlarını özelikleri görerek girmek için ilk önce özellik kategorileri ekleyin'>...<br/><br/>
                        </label>
                    </div>  
                </cfif> 
                <input type="hidden" name="barcode_require" id="barcode_require" value="<cfoutput>#get_our_company_info.is_barcod_required#</cfoutput>">
                <input type="hidden" name="product_code" id="product_code" value="<cfoutput>#url.pcode#</cfoutput>">
                <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#url.pid#</cfoutput>">
                <input type="hidden" name="purchase_is_kdv" id="purchase_is_kdv" value="<cfoutput>#price_standart_purchase.recordcount ? price_standart_purchase.IS_KDV : 0#</cfoutput>">
                <input type="hidden" name="purchase_price_kdv" id="purchase_price_kdv" value="<cfoutput>#price_standart_purchase.recordcount ? price_standart_purchase.PRICE_KDV : 0#</cfoutput>">
                <input type="hidden" name="sales_is_kdv" value="<cfoutput>#price_standart_sales.recordcount ? price_standart_sales.IS_KDV : 0#</cfoutput>">
                <input type="hidden" name="sales_price_kdv" value="<cfoutput>#price_standart_sales.recordcount ? price_standart_sales.PRICE_KDV : 0#</cfoutput>">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true" >
                    <div class="form-group" id="item-new_stock_code">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57518.Stok Kodu'> *</label>  
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='37418.Stok Kodu girmelisiniz'>?</cfsavecontent>
                        <cfif isdefined('x_is_stock_change') and x_is_stock_change eq 1>
                            <clear></clear></clear>
                            <div class="input-group">
                                <cfinput type="text" id="tmp_stock_code_1" name="tmp_stock_code_1" readonly="yes" message="#message#" value="#url.pcode#." width="130px">
                                <cfinput type="text" id="tmp_stock_code_2" name="tmp_stock_code_2" required="yes" message="#message#" value="" style="width:40px;">	
                            </div>
                            <cfinput type="hidden" name="new_stock_code" required="yes" readonly="yes" message="#message#" value="" style="width:170px;">
                        <cfelse>
                            <cfinput type="text" name="new_stock_code" required="yes" readonly="yes" message="#message#" value="#url.pcode#.#stock_count.recordcount+1#" style="width:170px;">			 			 	
                        </cfif>
                    </div>
                </div>
                <div class="form-group" id="item-stock_code_2">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>  
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57789.Özel Kod'> ?</cfsavecontent>
                        <cfinput type="text" name="stock_code_2" message="#message#" value="" maxlength="150">				
                    </div>
                </div>
                <div class="form-group" id="item-barcod">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57633.Barkod'></label>  
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <input type="text" name="barcod" id="barcod" value="" maxlength="50"  onKeyUp="barcod_control();">
                            <cfif is_auto_barcode eq 0>
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:document.add_property.barcod.value='<cfoutput>#get_barcode_no()#</cfoutput>'"><img src="/images/plus_thin.gif" border="0" id="barcode_image" title="<cf_get_lang dictionary_id='37940.Otomatik barkod'> !" align="absbottom"><span>
                            <cfelse>
                                <span class="input-group-addon btnPointer icon-ellipsis"onclick="javascript:document.add_property.barcod.value='<cfoutput>#get_barcode_no(1)#</cfoutput>'"><img src="/images/plus_thin.gif" border="0" id="barcode_image" title="<cf_get_lang dictionary_id='37940.Otomatik barkod'>" align="absbottom"></span>
                            </cfif>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-friendly_url">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63171.Friendly url'></label>  
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="text" name="friendly_url" id="friendly_url" maxlength="1000">
                    </div>
                </div> 
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-MANUFACT_CODE">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57634.Üretici Kodu'></label>  
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <input type="text" name="MANUFACT_CODE" id="MANUFACT_CODE" maxlength="50" value="" >
                    </div>
                </div>
                <div class="form-group" id="item-property_detail">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>  
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="text" name="property_detail" id="property_detail" maxlength="100" value="" >
                    </div>
                </div>
                <div class="form-group" id="item-property_detail">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57636.Birim'></label>  
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="unit" id="unit" >
                            <cfoutput query="get_product_unit"> 
                            <option value="#product_unit_id#">#add_unit#</option>
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
                                <option value="#counter_type_id#">#counter_type#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-counter_multiplier" style="display:none;">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64089.Sayaç Çarpanı'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">	
								<cfinput type="text" name="counter_multiplier" id="counter_multiplier" onkeyup="FormatCurrency(this,event,2)" class="moneybox" onblur="calculate_purchase_sales_price('counter_multiplier')">
								<span class="input-group-addon bold">*<cfoutput>#get_product_unit.main_unit#</cfoutput></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-purchase_price" style="display:none;">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64091.Stok Alış Fiyatı'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
                                <cfinput type="text" name="purchase_price" id="purchase_price" onkeyup="FormatCurrency(this,event,2)" class="moneybox" onblur="calculate_purchase_sales_price('purchase_price')">
                                <span class="input-group-addon width">
									<select name="purchase_money" id="purchase_money">
										<cfoutput query="get_money">
											<option value="#money#">#get_money.money#</option>
										</cfoutput>
									</select>
								</span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-sales_price" style="display:none;">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64092.Stok Satış Fiyatı'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
                                <cfinput type="text" name="sales_price" id="sales_price" onkeyup="FormatCurrency(this,event,2)" class="moneybox" onblur="calculate_purchase_sales_price('sales_price')">
								<span class="input-group-addon width">
									<select name="sales_money" id="sales_money">
										<cfoutput query="get_money">
											<option value="#money#">#get_money.money#</option>
										</cfoutput>
									</select>
								</span>
							</div>
						</div>
					</div>
            </div>
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
                            <td width="100">
                                <input type="hidden" name="property_id_<cfoutput>#currentrow#</cfoutput>" id="property_id_<cfoutput>#currentrow#</cfoutput>" value="<cfoutput>#get_properties.property_id#</cfoutput>">
                                <cfoutput>#get_properties.property#</cfoutput>
                            </td>
                            <td>
                                <cfquery name="GET_ALL_PROPERTY_DETAIL_ROW" dbtype="query">
                                    SELECT 
                                        PROPERTY_DETAIL,
                                        PROPERTY_DETAIL_ID 
                                    FROM 
                                        GET_ALL_PROPERTY_DETAIL
                                    WHERE
                                        PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_properties.property_id#">
                                </cfquery>                	
                                <cfset variation_id_ = get_properties.variation_id>
                                <select name="sub_property_list_<cfoutput>#currentrow#</cfoutput>" id="sub_property_list_<cfoutput>#currentrow#</cfoutput>" style="width:170px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
                                    <cfoutput query="Get_All_Property_Detail_Row">
                                        <option value="#property_detail_id#"<cfif variation_id_ eq property_detail_id>selected</cfif>>#property_detail#</option>
                                    </cfoutput>
                                </select>				
                            </td>
                            <td><input type="text" name="property_detail2_<cfoutput>#currentrow#</cfoutput>" id="property_detail2_<cfoutput>#currentrow#</cfoutput>" value="<cfoutput>#get_properties.detail#</cfoutput>" maxlength="150" style="width:220px;" /></td>
                            <td><input type="text" name="total_min_<cfoutput>#currentrow#</cfoutput>" id="total_min_<cfoutput>#currentrow#</cfoutput>" value="<cfoutput>#tlformat(total_min,2)#</cfoutput>" onKeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:60px;"></td>
                            <td><input type="text" name="total_max_<cfoutput>#currentrow#</cfoutput>" id="total_max_<cfoutput>#currentrow#</cfoutput>" value="<cfoutput>#tlformat(total_max,2)#</cfoutput>" onKeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:60px;"></td>
                        </cfif>
                    </cfloop>
                </tbody>				
                <input type="hidden" name="property_count" id="property_count" value="<cfoutput>#get_properties.recordcount#</cfoutput>">
            </cf_grid_list>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='form_kontrol()'>
        </cf_box_footer>
    </cfform>
</cf_box>
</div>		
<script type="text/javascript">
	row_count = <cfoutput>#get_properties.recordcount#</cfoutput>;
	function form_kontrol()
	{
		<cfif isDefined('attributes.is_inventory') and attributes.is_inventory is 1>
		  if(add_property.barcode_require.value == 1 && trim(add_property.barcod.value).length<7)
		  {
			alert("<cf_get_lang dictionary_id='37682.Envantere Dahil Ürünler İçin En Az 7 Karakter Barkod Girmelisiniz'>!");
			return false;
		  }
		</cfif>		
		<cfif isDefined('attributes.is_terazi') and attributes.is_terazi is 1>
		  if(trim(add_property.barcod.value).length!=7)
		  {
			alert("<cf_get_lang dictionary_id='37681.Teraziye Giden Ürünler İçin Barkod 7 Karakter Olmalıdır'>!");
			return false;
		  }
		</cfif>
	
		for(var k=1;k<=row_count;k++)
		{
			eval("document.add_property.total_max_"+k).value = filterNum(eval("document.add_property.total_max_"+k).value);
			eval("document.add_property.total_min_"+k).value = filterNum(eval("document.add_property.total_min_"+k).value);
		}
        <cfif isDefined("attributes.draggable")>
			loadPopupBox('add_property', <cfoutput>#attributes.modal_id#</cfoutput>);
			return false;
		<cfelse>
			return true;
		</cfif>
	}
	<cfif isDefined("attributes.draggable")>
        if(form_upd_product.product_code_2 != undefined) add_property.stock_code_2.value = form_upd_product.product_code_2.value+'.<cfoutput>#stock_count.recordcount+1#</cfoutput>';
    <cfelse>
        if(opener.form_upd_product.product_code_2 != undefined) add_property.stock_code_2.value = opener.form_upd_product.product_code_2.value+'.<cfoutput>#stock_count.recordcount+1#</cfoutput>';
    </cfif>
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
					alert("[space],!,\"\,#,$,%,&,',(,),*,+,,;,<,=,>,?,@,[,\,],],`,{,|,},£,~ <cf_get_lang dictionary_id='45688.Karakterlerinden Oluşan Barcod Girilemez'>!");
					barcode.value = '';
					break;
				}
			}
		}
	}

    $("form[name = add_property] select[name = unit], form[name = add_property] select[name = counter_type_id]").on('change', function(){
		if( $("form[name = add_property] select[name = counter_type_id]").val() != '' && $("form[name = add_property] select[name = unit]").val() != '<cfoutput>#get_main_product_unit.PRODUCT_UNIT_ID#</cfoutput>' )
			$("#item-counter_multiplier, #item-purchase_price, #item-sales_price").show();
		else{
			$("#item-counter_multiplier, #item-purchase_price, #item-sales_price").hide().find("input").val('');
		}
	});

	function calculate_purchase_sales_price( element_type )
	{
		var totalPurchasePrice = <cfoutput>#totalPurchasePrice#</cfoutput>;
		var totalSalesPrice = <cfoutput>#totalSalesPrice#</cfoutput>;

		var counter_multiplier = document.add_property.counter_multiplier;
		var purchase_price = document.add_property.purchase_price;
		var sales_price = document.add_property.sales_price;

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
