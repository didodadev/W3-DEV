<cfquery name="GET_SPECT_ROW" datasource="#dsn3#">
        SELECT 
			STOCKS.IS_PRODUCTION,
			SPECTS_ROW.RELATED_SPECT_ID AS SPECT_MAIN_ID,
			SPECTS_ROW.*,
			STOCKS.STOCK_CODE,
			STOCKS.PROPERTY,
			STOCKS.IS_PRODUCTION,
            STOCKS.PRODUCT_UNIT_ID,
            SPECTS_ROW.LINE_NUMBER,
			(SELECT SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.SPECT_MAIN_ID = SPECTS_ROW.RELATED_SPECT_ID) SPECT_MAIN_NAME
		FROM 
			SPECTS_ROW,
			STOCKS
		WHERE 
			SPECT_ID = <cfqueryparam value = "#attributes.id#" CFSQLType = "cf_sql_integer">
			AND SPECTS_ROW.STOCK_ID=STOCKS.STOCK_ID
	UNION 
		SELECT
			0 AS IS_PRODUCTION,
			SPECTS_ROW.RELATED_SPECT_ID AS SPECT_MAIN_ID,
			SPECTS_ROW.*,
			'',
			'',
			0 AS IS_PRODUCTION,
            '' AS PRODUCT_UNIT_ID,
            SPECTS_ROW.LINE_NUMBER,
			(SELECT SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.SPECT_MAIN_ID = SPECTS_ROW.RELATED_SPECT_ID) SPECT_MAIN_NAME
		FROM 
			SPECTS_ROW
		WHERE 
			SPECT_ID = <cfqueryparam value = "#attributes.id#" CFSQLType = "cf_sql_integer"> AND
			STOCK_ID IS NULL
       ORDER BY  
       		SPECTS_ROW.LINE_NUMBER    
</cfquery>
<cfparam name="attributes.price_catid" default="">
<cfset module_name="product">
<cfset var_="upd_purchase_basket">

<cfquery name="get_product_is_karma" datasource="#dsn1#">
	SELECT IS_KARMA_SEVK FROM PRODUCT WHERE PRODUCT_ID = #attributes.product_id#
</cfquery>
<cfquery name="get_money_product" datasource="#DSN1#">
	SELECT * FROM PRICE_STANDART WHERE PRICE_STANDART.PURCHASESALES = 1 AND PRICE_STANDART.PRICESTANDART_STATUS = 1 AND PRICE_STANDART.PRODUCT_ID = #attributes.product_id# 
</cfquery>
<cfset recordnumber = 0>
<cfif IsDefined("attributes.product_id")>
    <cfquery name="get_product_price_lists" datasource="#DSN3#">
        SELECT 	
            SUM(TOTAL_PRODUCT_PRICE) AS TOTAL_PRODUCT_PRICE,COUNT(TOTAL_PRODUCT_PRICE) AS TOPLAM_URUN,PRICE_CATID,START_DATE,FINISH_DATE,LIST_MONEY,PRICE_ID,PROCESS_STAGE
        FROM
            KARMA_PRODUCTS_PRICE
        WHERE
            KARMA_PRODUCT_ID = #attributes.product_id# 
        GROUP BY
            PRICE_CATID,START_DATE,FINISH_DATE,LIST_MONEY,PRICE_ID,PROCESS_STAGE
        ORDER BY
            TOPLAM_URUN DESC
    </cfquery>
    <cfset attributes.pid = attributes.product_id />
    <cfinclude template="../../product/query/get_karma_products.cfm">
    <cfif isdefined('attributes.price_catid') and len(attributes.price_catid)>
		<cfquery name="get_karma_products_price" datasource="#DSN3#">
			SELECT * FROM KARMA_PRODUCTS_PRICE WHERE KARMA_PRODUCT_ID = #attributes.product_id#
		</cfquery>
	</cfif>
  	<cfquery name="get_product_cost_all" datasource="#dsn1#">
		SELECT  
			PRODUCT_ID,
			PURCHASE_NET_SYSTEM,
			PURCHASE_EXTRA_COST_SYSTEM
		FROM
			PRODUCT_COST	
		WHERE
			PRODUCT_COST_STATUS = 1
			ORDER BY START_DATE DESC,RECORD_DATE DESC
	</cfquery>
	<cfset recordnumber = GET_SPECT_ROW.RecordCount>
	<cfquery name="get_product_prop_detail" datasource="#dsn1#">
		SELECT 
			PRODUCT_DT_PROPERTIES.PROPERTY_ID,
			PRODUCT_PROPERTY.PROPERTY
		FROM 
			PRODUCT_DT_PROPERTIES,
			PRODUCT_PROPERTY
		WHERE
			PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID AND
			PRODUCT_DT_PROPERTIES.PRODUCT_ID = #attributes.product_id#
	</cfquery>
</cfif>
<cfset module_name="product">
<cfquery name="get_price_cat" datasource="#DSN3#">
	SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT
</cfquery>

<cfoutput>
<input type="hidden" name="selected_money" id="selected_money" value="#get_money_product.MONEY#">
<input type="hidden" name="record_num" id="record_num" value="#recordnumber#">
<input type="hidden" name="is_mix_product" id="is_mix_product" value="1">
</cfoutput>

<cf_grid_list>
	<thead>
		<tr>
			<th><a href="javascript:openProducts();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
			<cfif isdefined('is_show_line_number') and is_show_line_number eq 1><th width="30"><cf_get_lang dictionary_id='57487.No'></th></cfif>
			<th width="100"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
			<th><cf_get_lang dictionary_id ='57657.Ürün'>/<cf_get_lang dictionary_id ='57629.Açıklama'></th>
			<th><cf_get_lang dictionary_id='57647.Spec'></th>
			<th class="text-right"><cf_get_lang dictionary_id='58176.alış'> <cf_get_lang dictionary_id='57639.KDV'></th>
			<th class="text-right"><cf_get_lang dictionary_id='57448.satış'> <cf_get_lang dictionary_id='57639.KDV'></th>
			<th class="text-right"><cf_get_lang dictionary_id='57636.Birim'> <cf_get_lang dictionary_id='58258.Maliyet'></th>
			<th class="text-right"><cf_get_lang dictionary_id='37183.Ek Maliyet'></th>
			<th class="text-right"><cf_get_lang dictionary_id='37419.Liste Fiyatı'></th>
			<th class="text-right"><cf_get_lang dictionary_id='37248.Döviz Fiyat'></th>
			<th><cf_get_lang dictionary_id='57489.Para birimi'></th>
			<th class="text-right"><cf_get_lang dictionary_id='37042.Satış Fiyatı'></th>
			<th class="text-right"><cf_get_lang dictionary_id='57635.Miktar'></th>
			<th class="text-right"><cf_get_lang dictionary_id='37497.Toplam Maliyet'></th>
			<th class="text-right"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='37042.Satış Fiyatı'></th>
		</tr>
	</thead>
	<tbody name="table1" id="table1">
		<cfif IsDefined("attributes.product_id") and recordnumber>
			<cfset spec_main_id_list = listdeleteduplicates(ValueList(GET_SPECT_ROW.SPECT_MAIN_ID,','))>
			<cfif len(spec_main_id_list)>
				<cfquery name="get_spec_name" datasource="#dsn3#">
					SELECT SPECT_MAIN_NAME,SPECT_MAIN_ID FROM SPECT_MAIN WHERE SPECT_MAIN_ID IN (#spec_main_id_list#)
				</cfquery>
				<cfscript>
					specObject = StructNew();
					for(si_=1;si_ lte get_spec_name.recordcount;si_=si_+1){
						"specObject.Spec_Main_#get_spec_name.SPECT_MAIN_ID[si_]#" ='#get_spec_name.SPECT_MAIN_NAME[si_]#';
					}
				</cfscript>
			</cfif>
			<cfoutput query="GET_SPECT_ROW">
				<cfquery name = "getMixedInfo" dbtype="query">
                    SELECT * FROM GET_KARMA_PRODUCT WHERE STOCK_CODE = '#GET_SPECT_ROW.STOCK_CODE#'
                </cfquery>
                <cfquery name="GET_PRODUCT_NAME" datasource="#dsn3#">
					SELECT PRODUCT_NAME,MANUFACT_CODE FROM PRODUCT WHERE PRODUCT_ID = #PRODUCT_ID#
				</cfquery>
				<cfquery name="get_product_cost" dbtype="query"><!--- Maliyetler geliyor. --->
					SELECT * FROM get_product_cost_all WHERE PRODUCT_ID = #GET_SPECT_ROW.product_id#
				</cfquery>
                <cfif isdefined('attributes.price_catid') and len(attributes.price_catid)><!--- Liste seçilmiş ise --->
					<cfquery name="get_karma_products_price_" dbtype="query"><!--- LİSTE FİYATLARI GELİYOR. --->
						SELECT * FROM get_karma_products_price WHERE PRICE_CATID = #attributes.price_catid# AND ENTRY_ID = #GET_KARMA_PRODUCT.ENTRY_ID# AND PRODUCT_ID = #GET_KARMA_PRODUCT.PRODUCT_ID#
					</cfquery>
					<cfif len(get_karma_products_price_.SALES_PRICE)><!--- Liste fiyatı yoksa standart fiyatları getir.s --->
						<cfset P_SALES_PRICE = get_karma_products_price_.SALES_PRICE>
					<cfelse>
						<cfset P_SALES_PRICE = getMixedInfo.OTHER_LIST_PRICE >
					</cfif>
				</cfif>

                <cfset P_TOTAL_PRODUCT_PRICE = GET_SPECT_ROW.TOTAL_VALUE / GET_SPECT_ROW.AMOUNT_VALUE >
                <cfset P_TOTAL_PRODUCT_PRICE_ALL = GET_SPECT_ROW.TOTAL_VALUE >

				<cfif len(get_product_cost.PURCHASE_NET_SYSTEM)><!--- maliyetleri yoksa 0 set ediliyor. --->
					<cfset PURCHASE_NET_SYSTEM = get_product_cost.PURCHASE_NET_SYSTEM>
				<cfelse>
					<cfset PURCHASE_NET_SYSTEM = 0 >
				</cfif>
				<cfif len(get_product_cost.PURCHASE_EXTRA_COST_SYSTEM)>
					<cfset PURCHASE_EXTRA_COST_SYSTEM = get_product_cost.PURCHASE_EXTRA_COST_SYSTEM>
				<cfelse>
					<cfset PURCHASE_EXTRA_COST_SYSTEM = 0 >
				</cfif>
				<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
				<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#PRODUCT_ID#">
				<input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#PRODUCT_UNIT_ID#">
				<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#STOCK_ID#">
				<input type="hidden" name="property_id#currentrow#" id="property_id#currentrow#" value="#PROPERTY_ID#"><!--- renk mi beden mi--->
				<input type="hidden" name="is_production#currentrow#" id="is_production#currentrow#" value="#IS_PRODUCTION#">
				<tr id="frm_row#currentrow#">
					<td width="20">
						<cfsavecontent variable="alert"><cf_get_lang dictionary_id='57533.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
						<a style="cursor:pointer" <cfif (isdefined('attributes.price_catid') and len(attributes.price_catid)) or ((isdefined('get_product_price_lists') and get_product_price_lists.recordcount))>onClick="uyar(2);"<cfelse> onClick="sil(#currentrow#);"</cfif>><i class="fa fa-minus" title="<cf_get_lang dictionary_id='37111.Ürünü Sil'>"></i></a>
					</td>
					<cfif isdefined('is_show_line_number') and is_show_line_number eq 1><td nowrap>#currentrow#</td></cfif>		
					<td>
						<div class="form-group" id="item-stock_code_">
							<input type="text" name="stock_code_#currentrow#" id="stock_code_#currentrow#" value="#GET_SPECT_ROW.STOCK_CODE#"  readonly> 
						</div>
					</td>
					<td width="165">
						<div class="form-group" id="item-product_name_row">
							<div class="input-group">
								<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" style="width:155px;"  value="#GET_SPECT_ROW.product_name#" readonly>
								<span class="input-group-addon icon-ellipsis btn_Pointer" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','medium');"></span>
							</div>
						</div>
					</td>
					<td width="165">
						<div class="form-group" id="item-spec_main">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<input type="text" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" value="#SPECT_MAIN_ID#" style="width:35px;" title="Spec Main ID" readonly>
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="text" name="spec_name#currentrow#" id="spec_name#currentrow#" style="width:100px;" value="<cfif isdefined('specObject.Spec_Main_#SPECT_MAIN_ID#')>#Evaluate('specObject.Spec_Main_#SPECT_MAIN_ID#')#</cfif>" onChange="clearSpecM('#currentrow#');"> 
									<span class="input-group-addon icon-ellipsis btn_Pointer" href="javascript://" onClick="open_spec_page(#currentrow#);"></span>
								</div>
							</div>
						</div>
					</td>
					<td>
						<div class="form-group" id="item-tax_purchase">
							<input type="text" name="tax_purchase#currentrow#" id="tax_purchase#currentrow#" value="#TLFormat(getMixedInfo.tax_purchase,0)#" class="moneybox" readonly>
						</div>
					</td>
					<td>
						<div class="form-group" id="item-tax">
							<input type="text" name="tax#currentrow#" id="tax#currentrow#" value="#TLFormat(getMixedInfo.tax,0)#" class="moneybox" readonly>
						</div>
					</td>
					<td>
						<div class="form-group" id="item-products_cost">
							<input type="text" name="products_cost#currentrow#" id="products_cost#currentrow#" value="#TLFormat(PURCHASE_NET_SYSTEM,session.ep.our_company_info.sales_price_round_num)#" onBlur="calculate_amount(#currentrow#);" onKeyUp="return(FormatCurrency(this,event));" class="moneybox" readonly>
						</div>
					</td>
					<td>
						<div class="form-group" id="item-extra_product_cost">
							<input type="text" name="extra_product_cost#currentrow#" id="extra_product_cost#currentrow#" value="#TLFormat(PURCHASE_EXTRA_COST_SYSTEM,session.ep.our_company_info.sales_price_round_num)#" class="moneybox" readonly>
						</div>
					</td>
					<td>
						<div class="form-group" id="item-list_price">
							<input type="text" name="list_price#currentrow#" id="list_price#currentrow#" value="#TLFormat(getMixedInfo.LIST_PRICE,session.ep.our_company_info.sales_price_round_num)#" class="moneybox" readonly>
						</div>
					</td>
					<td>
						<div class="form-group" id="item-other_list_price">
							<input type="text" name="other_list_price#currentrow#" id="other_list_price#currentrow#" value="<cfif isdefined('P_SALES_PRICE') and len(P_SALES_PRICE)>#TLFormat(P_SALES_PRICE,session.ep.our_company_info.sales_price_round_num)#<cfelse>#TLFormat(getMixedInfo.OTHER_LIST_PRICE,session.ep.our_company_info.sales_price_round_num)#</cfif>" class="moneybox" readonly>
						</div>
					</td>
					<td>
						<div class="form-group" id="item-product_money">
							<select name="product_money#currentrow#" id="product_money#currentrow#" onChange="hesapla_row(2,#currentrow#);">
								<cfloop query="get_money">
									<option value="#money#;#rate2#" <cfif get_money.money eq GET_SPECT_ROW.MONEY_CURRENCY>selected</cfif>>#money#</option>
								</cfloop>
							</select>
						</div>
					</td>
					<td width="90">
						<div class="form-group" id="item-p_price">
							<div class="input-group">
								<input type="text" class="moneybox" name="s_price#currentrow#" id="s_price#currentrow#" style="width:80px;" onKeyUp="hesapla_row(3,#currentrow#);" value="#TLFormat(P_TOTAL_PRODUCT_PRICE,session.ep.our_company_info.sales_price_round_num)#" onBlur="if(this.value=='')this.value=0;calculate_amount(#currentrow#);"><span class="input-group-addon icon-ellipsis btn_Pointer" href="javascript://" onclick="open_price(#currentrow#);"></span>
                                <input type="hidden" name="p_price#currentrow#" id="p_price#currentrow#" value="0">
							</div>
						</div>
					</td>
					<td>
						<div class="form-group" id="item-row_amount">
							<input type="text" class="moneybox" name="row_amount#currentrow#" id="row_amount#currentrow#" value="#AmountFormat(AMOUNT_VALUE,3)#" onBlur="calculate_amount(#currentrow#);" onkeyup="return(FormatCurrency(this,event));" <cfif (isdefined('attributes.price_catid') and len(attributes.price_catid)) or ((isdefined('get_product_price_lists') and get_product_price_lists.recordcount))>readonly onClick="uyar(1);"</cfif>>
						</div>
					</td>
					<td>
						<div class="form-group" id="item-total_product_cost">
							<input type="text" class="moneybox" name="total_product_cost#currentrow#" id="total_product_cost#currentrow#" value="#TLFormat((PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)*AMOUNT_VALUE,session.ep.our_company_info.sales_price_round_num)#" readonly>
						</div>
					</td>
					<td class="text-right">
						<div class="form-group" id="item-total_product_price">
							<input type="text" name="total_product_price#currentrow#" id="total_product_price#currentrow#" style="width:100%;" value="#TLFormat(P_TOTAL_PRODUCT_PRICE_ALL,session.ep.our_company_info.sales_price_round_num)#" class="box" readonly>
						</div>
					</td>
				</tr>
			</cfoutput>
		</cfif>
	</tbody>
</cf_grid_list>

<div id="sepetim_total" class="col col-12 pdn-l-0 pdn-r-0">
	<div class="col col-4 col-md-5 col-sm-6 col-xs-12 pdn-l-0">
		<div class="totalBox">
			<div class="totalBoxHead font-grey-mint">
				<span class="headText"><cf_get_lang dictionary_id ='33851.Dövizler'></span>
				<div class="collapse">
					<span class="icon-minus"></span>
				</div>
			</div>
			<div class="totalBoxBody">
				<table>
					<cfoutput>
						<input type="hidden" name="rd_money_num" id="rd_money_num" value="#get_money.recordcount#">
						<cfloop query="get_money">
							<tr>
								<input type="hidden" name="urun_para_birimi#money#" id="urun_para_birimi#money#" value="#rate2/rate1#">
								<input type="hidden" name="rd_money_name_#currentrow#" id="rd_money_name_#currentrow#" value="#money#">
								<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
								<td><input type="radio" name="rd_money" id="rd_money" value="#money#,#rate1#,#rate2#" onClick="hesapla();" <cfif money eq session.ep.money2>checked</cfif>>#money#</td>
								<td>#TLFormat(rate1,4)#/</td>
								<td><input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,4)#" style="width:50px;" class="box" onkeyup="return(FormatCurrency(this,event,4));" onBlur="hesapla();"></td>
							</tr>
						</cfloop>
					</cfoutput>
				</table>
			</div>
		</div>
	</div>
	<div class="col col-4 col-md-5 col-sm-6 col-xs-12">
		<div class="totalBox">
			<div class="totalBoxHead font-grey-mint">
				<span class="headText"><cf_get_lang dictionary_id ='57492.Toplam'> </span>
				<div class="collapse">
					<span class="icon-minus"></span>
				</div>
			</div>
			<div class="totalBoxBody">
				<table>
					<thead>
						<tr>
							<th class="text-right"><cf_get_lang dictionary_id ='57492.Toplam'></td>
							<th class="text-right"><cf_get_lang dictionary_id ='58124.Döviz Toplam'></td>
						</tr>
					</thead>
					<cfoutput>
						<tr>
							<td class="text-right"><input type="text" name="toplam_miktar" id="toplam_miktar" value="0" style="width:100px;" class="box" readonly=""><cfoutput>#session.ep.money#</cfoutput></td>
							<td class="text-right"><input type="text" name="other_toplam" id="other_toplam" value="" style="width:100px;" class="box" readonly="">&nbsp;
							<input type="text" name="doviz_name" id="doviz_name" value="" style="width:50px;" class="box" readonly=""></td>
						</tr>
					</cfoutput>
				</table>
			</div>
		</div>
	</div>
</div>