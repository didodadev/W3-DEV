<cf_xml_page_edit default_value="0" fuseact="product.popup_dsp_karma_contents">
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
	<cfparam name="attributes.price_catid" default="">
	<cfparam name="attributes.price_catid_karma" default="">
	<cfsetting showdebugoutput="no">
	<cfinclude template="../../../JS/div_function.cfm">
	<cfquery name="get_product_is_karma" datasource="#dsn1#">
		SELECT IS_KARMA_SEVK FROM PRODUCT WHERE PRODUCT_ID = #attributes.pid#
	</cfquery>
	<cfquery name="get_money_product" datasource="#DSN1#">
		SELECT * FROM PRICE_STANDART WHERE PRICE_STANDART.PURCHASESALES = 1 AND PRICE_STANDART.PRICESTANDART_STATUS = 1 AND PRICE_STANDART.PRODUCT_ID = #attributes.pid# 
	</cfquery>
	<cfset recordnumber = 0>
	<cfset liste_para_birimi = get_money_product.money>
	<cfquery name="get_record_info" datasource="#DSN3#">
		SELECT 	
			TOP 1 RECORD_DATE, RECORD_EMP
		FROM
			KARMA_PRODUCTS_PRICE
		WHERE
			KARMA_PRODUCT_ID = #attributes.pid# AND RECORD_EMP IS NOT NULL
	</cfquery>
	<cfquery name="get_product_price_lists" datasource="#DSN3#">
		SELECT 	
			SUM(TOTAL_PRODUCT_PRICE) AS TOTAL_PRODUCT_PRICE,COUNT(TOTAL_PRODUCT_PRICE) AS TOPLAM_URUN,PRICE_CATID,START_DATE,FINISH_DATE,LIST_MONEY,PRICE_ID,PROCESS_STAGE
		FROM
			KARMA_PRODUCTS_PRICE
		WHERE
			KARMA_PRODUCT_ID = #attributes.pid# 
		GROUP BY
			PRICE_CATID,START_DATE,FINISH_DATE,LIST_MONEY,PRICE_ID,PROCESS_STAGE
		ORDER BY
			TOPLAM_URUN DESC
	</cfquery>
	<cfif IsDefined("attributes.pid")>
		<cfinclude template="../query/get_karma_products.cfm">
		<cfif isdefined('attributes.price_catid') and len(attributes.price_catid)>
			<cfquery name="get_karma_products_price" datasource="#DSN3#">
				SELECT * FROM KARMA_PRODUCTS_PRICE WHERE KARMA_PRODUCT_ID = #attributes.pid#
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
		<cfset recordnumber = GET_KARMA_PRODUCT.RecordCount>
		<cfquery name="get_product_prop_detail" datasource="#dsn1#">
			SELECT 
				PRODUCT_DT_PROPERTIES.PROPERTY_ID,
				PRODUCT_PROPERTY.PROPERTY
			FROM 
				PRODUCT_DT_PROPERTIES,
				PRODUCT_PROPERTY
			WHERE
				PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID AND
				PRODUCT_DT_PROPERTIES.PRODUCT_ID = #attributes.pid#
		</cfquery>
	</cfif>
	<cfset module_name="product">
	<cfset var_="upd_purchase_basket">
	<cfinclude template="../../contract/query/get_moneys.cfm">
	<cfinclude template="../../contract/query/get_units.cfm">
	<cfinclude template="../query/get_unit.cfm">
	<cfquery name="get_price_cat" datasource="#DSN3#">
		SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT
	</cfquery>
	<cfif isdefined('attributes.price_catid') and len(attributes.price_catid)>
	<cfquery name="get_price_cat_list_one" datasource="#DSN3#">
		SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT  WHERE PRICE_CATID =#attributes.price_catid# ORDER BY PRICE_CATID
	</cfquery>
	</cfif>
	
	<cf_catalystHeader>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cfform name="form_basket" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_karma_contents">
			<input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.pid#</cfoutput>">
			<input type="hidden" name="price_row_count" id="price_row_count" value="4">
			<cfif recordnumber eq 0>
				<cfset attributes.karma_product_id = attributes.pid>
				<cfset attributes.karma_product_barcod = get_product.barcod>
				<cfset reference_catid = attributes.price_catid>
				<cfset attributes.price_catid = ''>
				<cfinclude template="../query/get_stocks_purchase.cfm">
				<cfset attributes.price_catid = reference_catid>
				<cf_box>
					<cfif products.recordcount eq 0>
						<cfinput type="hidden" name="price_catid" id="price_catid" value="-1">
						<p><strong><cf_get_lang dictionary_id='57425.Uyarı'>!</strong> <cf_get_lang dictionary_id='65389.Bu ürünün varyasyonları olmadığı için farklı ürünler seçerek karma koli oluşturabilirsiniz.'></p>
					<cfelse>
						<cf_box_elements vertical="1">
							<div class="form-group col col-3 col-md-3 col-sm-4 col-xs-12">
								<label><cf_get_lang dictionary_id='112.Master Ürün'></label>
								<div class="input-group">
									<input type="hidden" name="master_product_id" id="master_product_id" value="<cfoutput>#attributes.pid#</cfoutput>">
									<input type="text" name="master_product_name" id="master_product_name" value="<cfoutput>#get_product_name(attributes.pid)#</cfoutput>" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','200');">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=form_basket.master_product_id&field_name=form_basket.master_product_name');"></span>
								</div>
							</div>
							<div class="form-group col col-2 col-md-3 col-sm-3 col-xs-12" id="item-price_cat">							
								<label><cf_get_lang dictionary_id='30108.Reference Price'></label>
								<select name="price_catid" id="price_catid" onChange="change_price_cat(this.value)">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="-1"><cf_get_lang dictionary_id='37600.Standard Sales Price'></option> <!--- Ürünün standartından gelir --->
									<cfoutput query="get_price_cat">
										<option value="#PRICE_CATID#"<cfif attributes.price_catid eq PRICE_CATID> selected</cfif>>#PRICE_CAT#</option>
									</cfoutput>
								</select>						
							</div>
							<div class="form-group col col-2 col-md-3 col-sm-4 col-xs-12">
								<label> &nbsp;</label>
								<input type="button" class="ui-wrk-btn ui-wrk-btn-success" value="<cf_get_lang dictionary_id='46212.Stok Çeşitlerinden Master Karma Koli Oluştur'>" onclick="addMasterStocks()">
							</div>
						</cf_box_elements>
					</cfif>				
				</cf_box>
			<cfelse>
				<cfinput type="hidden" name="price_catid" id="price_catid" value="-1">
			</cfif>
			<!--- <cfif isdefined('is_show_filter') and is_show_filter eq 1>
				<cf_box>
					<cf_box_search>
						<cfif isdefined('attributes.price_catid') and len(attributes.price_catid)>
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<p><cfoutput>(#get_price_cat_list_one.PRICE_CAT#)</cfoutput></p>
							</div>
						</cfif>
						<div class="form-group" id="item-product_name">
							<div class="input-group">
								<cfsavecontent variable="urun"><cf_get_lang dictionary_id='57657.Ürün'></cfsavecontent>
								<input type="hidden" name="product_id" id="product_id" value="" >
								<input name="product_name" type="text" id="product_name" style="width:125px;" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','130',true,'test()');" value="" autocomplete="off" placeholder="<cfoutput>#urun#</cfoutput>">
								<span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&run_function=test()&product_id=form_basket.product_id&field_name=form_basket.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(form_basket.product_name.value),'list');"></span>
							</div>
						</div>
						<div class="form-group" id="item-prod_detail">
							<select name="prod_detail" id="prod_detail" >
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							</select>
						</div>	
						<div class="form-group" id="item-prod_varyasyon">
							<select name="prod_varyasyon" id="prod_varyasyon" >
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							</select>
						</div>
						<div class="form-group" id="item-price_list">
							<select name="price_list" id="price_list">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							</select>
						</div>	
						<div class="form-group" id="item-add_prod_row">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57582.Ekle'></cfsavecontent>
							<a class="ui-btn ui-btn-gray" href="javascript://" name="add_" id="add_" onclick="add_prod_row();" title="<cfoutput>#message#</cfoutput>"><i class="fa fa-plus"></i></a>
						</div>
					</cf_box_search>
				</cf_box>
			</cfif> --->
			<cfoutput>
			<input type="hidden" name="selected_money" id="selected_money" value="#get_money_product.MONEY#">
			<input type="Hidden" name="var_" id="var_" value="#var_#">
			<input type="Hidden" name="module_name" id="module_name" value="#module_name#">
			<input type="Hidden" name="karma_product_id" id="karma_product_id" value="#attributes.pid#">
			<input type="Hidden" name="record_num" id="record_num" value="#recordnumber#">
			</cfoutput>
			
			<cfsavecontent variable="message"><cfoutput>#get_product_name(attributes.pid)#</cfoutput></cfsavecontent>
			<cf_box title="#message#" uidrop="1" hide_table_column="1">
				<cf_grid_list>
					<thead>
						<tr>
							<!-- sil -->
							<th>
								<cfif (isdefined('get_product_price_lists') and get_product_price_lists.recordcount)><a onClick="uyar(2);"><cfelse> <a href="javascript:openProducts();"></cfif><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
							</th>
							<!-- sil -->
							<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
							<th width="140"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
							<th><cf_get_lang dictionary_id='57657.Ürün'><cf_get_lang dictionary_id='57629.Açıklama'></th>
							<th width="120"><cf_get_lang dictionary_id='57647.Spec'></th>
								<cfif len(GET_KARMA_PRODUCT.KARMA_PROPERTY_SIZE_ID)>
									<cfquery name="GET_KARMA_" datasource="#dsn1#"><!--- Karma Ürününün beden veya boy özellikleri.--->
										SELECT 
											KP.KARMA_PRODUCT_ID,
											P.PRODUCT_ID,
											PP.PROPERTY,
											P.KARMA_PROPERTY_SIZE_ID
										FROM 
											KARMA_PRODUCTS AS KP
											LEFT JOIN PRODUCT P ON P.PRODUCT_ID=KP.KARMA_PRODUCT_ID
											LEFT JOIN PRODUCT_PROPERTY PP ON PP.PROPERTY_ID =P.KARMA_PROPERTY_SIZE_ID <!--- renk için --->
										WHERE
											KP.KARMA_PRODUCT_ID = <cfqueryparam value = "#attributes.pid#" CFSQLType = "cf_sql_integer">
											
										ORDER BY 
											ENTRY_ID
									</cfquery>
									<th width="50"><cfoutput>#GET_KARMA_.PROPERTY#</cfoutput></th>
								</cfif>
							<cfif len(GET_KARMA_PRODUCT.KARMA_PROPERTY_COLLAR_ID)>
								<cfquery name="GET_KARMA" datasource="#dsn1#"><!---Karma Ürününün renk özellikler--->
									SELECT 
										KP.KARMA_PRODUCT_ID,
										P.PRODUCT_ID,
										PP.PROPERTY,
										P.KARMA_PROPERTY_COLLAR_ID 
									FROM 
										KARMA_PRODUCTS AS KP
										LEFT JOIN #dsn1#.PRODUCT P ON P.PRODUCT_ID=KP.KARMA_PRODUCT_ID
										LEFT JOIN PRODUCT_PROPERTY PP ON PP.PROPERTY_ID =P.KARMA_PROPERTY_COLLAR_ID <!--- renk için --->
									WHERE
										KP.KARMA_PRODUCT_ID = <cfqueryparam value = "#attributes.pid#" CFSQLType = "cf_sql_integer">
										
									ORDER BY 
										ENTRY_ID
								</cfquery>
								<th width="50"><cfoutput>#GET_KARMA.PROPERTY#</cfoutput></th>
							</cfif>
							
							<th class="text-right" width="30"><cf_get_lang dictionary_id='57635.Miktar'></th>
							<th width="50"><cf_get_lang dictionary_id='57636.Birim'></th>
							<th class="text-right"  width="30"><cf_get_lang dictionary_id='58176.alış'> <cf_get_lang dictionary_id='57639.KDV'></th>
							<th class="text-right"  width="30"><cf_get_lang dictionary_id='57448.satış'> <cf_get_lang dictionary_id='57639.KDV'></th>
							<th class="text-right" width="70"><cf_get_lang dictionary_id='57636.Birim'> <cf_get_lang dictionary_id='58258.Maliyet'></th>
							<th class="text-right" width="70"><cf_get_lang dictionary_id='37183.Ek Maliyet'></th>
							<th class="text-right" width="70"><cf_get_lang dictionary_id='37419.Liste Fiyatı'></th>
							<th class="text-right" width="70"><cf_get_lang dictionary_id='37248.Döviz Fiyat'></th>
							<th  width="40"><cf_get_lang dictionary_id='57489.Para birimi'></th>
							<th class="text-right"  width="70"><cf_get_lang dictionary_id='37042.Satış Fiyatı'></th>
							<th class="text-center"  width="70"><cf_get_lang dictionary_id='37497.Toplam Maliyet'></th>
							<th class="text-center" width="70"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='37042.Satış Fiyatı'></th>
						</tr>
					</thead>
					<tbody name="table1" id="table1">
						<cfif IsDefined("attributes.pid") and recordnumber>
							<cfset grosstotal_cost = 0>
							<cfset grosstotal_price = 0>
							<cfif get_product_price_lists.recordcount>
								<cfset get_price_catid_list=''>
								<cfoutput query="get_product_price_lists">
									<cfif len(PRICE_CATID) and not listfind(get_price_catid_list,PRICE_CATID)>
										<cfset get_price_catid_list = Listappend(get_price_catid_list,PRICE_CATID)>
									</cfif>
								</cfoutput>
								<cfif len(get_price_catid_list)>
									<cfset get_price_catid_list=listsort(get_price_catid_list,"numeric","ASC",",")>
									<cfquery name="get_price_cat_list" datasource="#DSN3#">
										SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT  WHERE PRICE_CATID IN (#get_price_catid_list#) ORDER BY PRICE_CATID
									</cfquery>
									<cfset get_price_catid_list = listsort(listdeleteduplicates(valuelist(get_price_cat_list.PRICE_CATID,',')),'numeric','ASC',',')>
								</cfif>
							</cfif>
							<cfset spec_main_id_list = listdeleteduplicates(ValueList(GET_KARMA_PRODUCT.SPEC_MAIN_ID,','))>
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
							<cfoutput query="GET_KARMA_PRODUCT">
								<cfquery name="GET_PRODUCT_NAME" datasource="#dsn3#">
									SELECT PRODUCT_NAME,MANUFACT_CODE FROM PRODUCT WHERE PRODUCT_ID = #PRODUCT_ID#
								</cfquery>
								<cfquery name="get_product_cost" dbtype="query"><!--- Maliyetler geliyor. --->
									SELECT * FROM get_product_cost_all WHERE PRODUCT_ID = #GET_KARMA_PRODUCT.product_id#
								</cfquery>
								<cfif isdefined('attributes.price_catid') and len(attributes.price_catid)><!--- Liste seçilmiş ise --->
									<cfquery name="get_karma_products_price_" dbtype="query"><!--- LİSTE FİYATLARI GELİYOR. --->
										SELECT * FROM get_karma_products_price WHERE PRICE_CATID = #attributes.price_catid# AND ENTRY_ID = #GET_KARMA_PRODUCT.ENTRY_ID# AND PRODUCT_ID = #GET_KARMA_PRODUCT.PRODUCT_ID#
									</cfquery>
									<cfif get_karma_products_price_.recordcount>
										<cfset liste_para_birimi = get_karma_products_price_.LIST_MONEY>
									<cfelse>
										<cfset liste_para_birimi = GET_KARMA_PRODUCT.KARMA_PRODUCT_MONEY>
									</cfif> 
									<cfif len(get_karma_products_price_.SALES_PRICE)><!--- Liste fiyatı yoksa standart fiyatları getir.s --->
										<cfset P_SALES_PRICE = get_karma_products_price_.SALES_PRICE>
									<cfelse>
										<cfset P_SALES_PRICE = OTHER_LIST_PRICE >
									</cfif>
									<cfif len(get_karma_products_price_.TOTAL_PRODUCT_PRICE)>
										<cfset P_TOTAL_PRODUCT_PRICE = get_karma_products_price_.TOTAL_PRODUCT_PRICE/product_amount>
									<cfelse>
										<cfset P_TOTAL_PRODUCT_PRICE = TOTAL_PRODUCT_PRICE/product_amount ><!--- Liste fiyatı yoksa standart fiyatları getir.s --->
									</cfif>
									<cfif len(get_karma_products_price_.TOTAL_PRODUCT_PRICE)>
										<cfset P_TOTAL_PRODUCT_PRICE_ALL = get_karma_products_price_.TOTAL_PRODUCT_PRICE>
									<cfelse>
										<cfset P_TOTAL_PRODUCT_PRICE_ALL = TOTAL_PRODUCT_PRICE ><!--- Liste fiyatı yoksa standart fiyatları getir.s --->
									</cfif>
								</cfif>
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
								<cfset grosstotal_cost = grosstotal_cost + (PURCHASE_NET_SYSTEM +PURCHASE_EXTRA_COST_SYSTEM ) >
								<input type="Hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
								<input type="Hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#PRODUCT_ID#">
								<input type="Hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#PRODUCT_UNIT_ID#">
								<input type="Hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#STOCK_ID#">
								<input type="Hidden" name="property_id#currentrow#" id="unit_id#currentrow#" value="#PROPERTY_ID#"><!--- renk mi beden mi--->
								<input type="Hidden" name="property_detail_id#currentrow#" id="property_detail_id#currentrow#" value="#PROPERTY_DETAIL_ID#"><!--- hangi renk yada hangi beden--->
								<tr id="frm_row#currentrow#">
									<!-- sil -->
									<td width="20">
										<cfsavecontent variable="alert"><cf_get_lang dictionary_id='57533.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
										<a style="cursor:pointer"<!--- <cfif (isdefined('attributes.price_catid') and len(attributes.price_catid)) or ((isdefined('get_product_price_lists') and get_product_price_lists.recordcount))>onClick="uyar(2);"<cfelse> onClick="sil(#currentrow#);"</cfif> --->onClick="sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='37111.Ürünü Sil'>"></i></a>
									</td>
									<!-- sil -->
									<td nowrap>#currentrow#</td>				
									<td>
										<div class="form-group" id="item-stock_code_">
											<input type="text" name="stock_code_#currentrow#" id="stock_code_#currentrow#" value="#GET_KARMA_PRODUCT.STOCK_CODE#"  readonly> 
										</div>
									</td>
									<td width="165">
										<div class="form-group" id="item-product_name_row">
											<div class="input-group">
												<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" style="width:155px;"  value="#GET_KARMA_PRODUCT.product_name#">
												<span class="input-group-addon icon-ellipsis btn_Pointer" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#');"></span>
											</div>
										</div>
									</td>
									<td width="165">
										<div class="form-group" id="item-spec_main">
											<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
												<input type="text" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" value="#SPEC_MAIN_ID#" style="width:35px;" title="Spec Main ID" readonly>
											</div>
											<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
												<div class="input-group">
													<input type="text" name="spec_name#currentrow#" id="spec_name#currentrow#" style="width:100px;" value="<cfif isdefined('specObject.Spec_Main_#SPEC_MAIN_ID#')>#Evaluate('specObject.Spec_Main_#SPEC_MAIN_ID#')#</cfif>" onChange="clearSpecM('#currentrow#');"> 
													<span class="input-group-addon icon-ellipsis btn_Pointer" href="javascript://" onClick="open_spec_page(#currentrow#);"></span>
												</div>
											</div>
										</div>
									</td>
								
									<cfif len(GET_KARMA_PRODUCT.PROPERTY_1)>
										<td>
											<div class="form-group" id="item-property_1_">
												<input type="text" name="property_1_#currentrow#" id="property_1_#currentrow#" value="#GET_KARMA_PRODUCT.PROPERTY_1#"  > 
											</div>
										</td>
									<cfelseif len(GET_KARMA_PRODUCT.KARMA_PROPERTY_SIZE_ID) and not len(GET_KARMA_PRODUCT.PROPERTY_1)>
										<td>
											<div class="form-group" id="item-property_1_">
												<input type="text" name="property_1_#currentrow#" id="property_1_#currentrow#" value="" > 
											</div>
										</td>
									</cfif>
									<cfif len(GET_KARMA_PRODUCT.PROPERTY_2)>
										<td>
											<div class="form-group" id="item-property_2_">
												<input type="text" name="property_2_#currentrow#" id="property_2_#currentrow#" value="#GET_KARMA_PRODUCT.PROPERTY_2#"  > 
											</div>
										</td>
									<cfelseif len(GET_KARMA_PRODUCT.KARMA_PROPERTY_COLLAR_ID) and not len(GET_KARMA_PRODUCT.PROPERTY_2)>
										<td>
											<div class="form-group" id="item-property_2_">
												<input type="text" name="property_2_#currentrow#" id="property_2_#currentrow#" value=""  > 
											</div>
										</td>
									</cfif>
								
									<td>
										<div class="form-group" id="item-row_amount">
											<input type="text" class="moneybox" name="row_amount#currentrow#" id="row_amount#currentrow#" value="#AmountFormat(product_amount,3)#" onBlur="calculate_amount(#currentrow#);" <!--- <cfif (isdefined('attributes.price_catid') and len(attributes.price_catid)) or ((isdefined('get_product_price_lists') and get_product_price_lists.recordcount))>readonly onClick="uyar(1);"</cfif> --->>
										</div>
									</td>
									<td>
										<div class="form-group" id="item-unit">
											<input type="text" name="unit#currentrow#" id="unit#currentrow#" value="#UNIT#"  readonly>
										</div>
									</td>
									<td>
										<div class="form-group" id="item-tax_purchase">
											<input type="text" name="tax_purchase#currentrow#" id="tax_purchase#currentrow#" value="#TLFormat(tax_purchase,0)#" class="moneybox" readonly>
										</div>
									</td>
									<td>
										<div class="form-group" id="item-tax">
											<input type="text" name="tax#currentrow#" id="tax#currentrow#" value="#TLFormat(tax,0)#" class="moneybox" readonly>
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
											<input type="text" name="list_price#currentrow#" id="list_price#currentrow#" value="#TLFormat(LIST_PRICE,session.ep.our_company_info.sales_price_round_num)#" class="moneybox" readonly>
										</div>
									</td>
									<td>
										<div class="form-group" id="item-other_list_price">
											<input type="text" name="other_list_price#currentrow#" id="other_list_price#currentrow#" value="<cfif isdefined('P_SALES_PRICE') and len(P_SALES_PRICE)>#TLFormat(P_SALES_PRICE,session.ep.our_company_info.sales_price_round_num)#<cfelse>#TLFormat(OTHER_LIST_PRICE,session.ep.our_company_info.sales_price_round_num)#</cfif>" onKeyUp="return(FormatCurrency(this,event))&&hesapla_row(1,#currentrow#);" class="moneybox" >
										</div>
									</td>
									<td>
										<div class="form-group" id="item-money">
											<select name="money#currentrow#" id="money#currentrow#" onChange="hesapla_row(2,#currentrow#);">
												<cfloop query="get_moneys">
													<option value="#money#;#rate2#" <cfif get_moneys.money eq get_karma_product.money>selected</cfif>>#money#</option>
												</cfloop>
											</select>
										</div>
									</td>
									<td width="90">
										<div class="form-group" id="item-p_price">
											<div class="input-group">
												<input type="text" class="moneybox" name="s_price#currentrow#" id="s_price#currentrow#" style="width:80px;" onKeyUp="return(FormatCurrency(this,event))&&hesapla_row(3,#currentrow#);" value="<cfif isdefined('P_TOTAL_PRODUCT_PRICE') and len(P_TOTAL_PRODUCT_PRICE)>#TLFormat(P_TOTAL_PRODUCT_PRICE,session.ep.our_company_info.sales_price_round_num)#<cfelseif len(SALES_PRICE)>#TLFormat(SALES_PRICE,session.ep.our_company_info.sales_price_round_num)#<cfelse>#TLFormat(0,session.ep.our_company_info.sales_price_round_num)#</cfif>" onBlur="if(this.value=='')this.value=0;calculate_amount(#currentrow#);"><span class="input-group-addon icon-ellipsis btn_Pointer" href="javascript://" onclick="open_price(#currentrow#);"></span>
												<input type="hidden" name="p_price#currentrow#" id="p_price#currentrow#" value="0">
											</div>
											<cfif isdefined('P_TOTAL_PRODUCT_PRICE') and len(P_TOTAL_PRODUCT_PRICE)>
												<cfset p_price_sales = filterNum(TLFormat(P_TOTAL_PRODUCT_PRICE,session.ep.our_company_info.sales_price_round_num))-filterNum(TLFormat((PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)*product_amount,session.ep.our_company_info.sales_price_round_num))>
											<cfelseif len(SALES_PRICE)>
												<cfset p_price_sales = filterNum(TLFormat(SALES_PRICE,session.ep.our_company_info.sales_price_round_num))-filterNum(TLFormat((PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)*product_amount,session.ep.our_company_info.sales_price_round_num))>
											<cfelse>
												<cfset p_price_sales = filterNum(TLFormat(0,session.ep.our_company_info.sales_price_round_num))-filterNum(TLFormat((PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)*product_amount,session.ep.our_company_info.sales_price_round_num))>
											</cfif>
										</div>
										<input type="hidden" value="#p_price_sales#" name="p_price_hidden#currentrow#" id="p_price_hidden#currentrow#">
									</td>								
									<td>
										<div class="form-group" id="item-total_product_cost">
											<input type="text" class="moneybox" name="total_product_cost#currentrow#" id="total_product_cost#currentrow#" value="#TLFormat((PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)*product_amount,session.ep.our_company_info.sales_price_round_num)#" readonly>
										</div>
									</td>
									<td class="text-right">
										<div class="form-group" id="item-total_product_price">
											<input type="text" name="total_product_price#currentrow#" id="total_product_price#currentrow#" style="width:100%;"  class="moneybox" value="<cfif isdefined('P_TOTAL_PRODUCT_PRICE_ALL') and len(P_TOTAL_PRODUCT_PRICE_ALL)>#TLFormat(P_TOTAL_PRODUCT_PRICE_ALL,session.ep.our_company_info.sales_price_round_num)#<cfelseif len(TOTAL_PRODUCT_PRICE)>#TLFormat(TOTAL_PRODUCT_PRICE,session.ep.our_company_info.sales_price_round_num)#<cfelse>#TLFormat(0,session.ep.our_company_info.sales_price_round_num)#</cfif>" class="box" readonly>
										</div>
									</td>
								</tr>
							</cfoutput>
						</cfif>
					</tbody>
				</cf_grid_list>
				<br>
				<cf_box_elements>
					<div class="ui-row">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group margin-bottom-10" id="item-is_karma_sevk">
								<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
									<b><cf_get_lang dictionary_id='37605.Karma Koli İçeriğindeki Ürünler Hareket Etsin'>!</b>
									<input type="checkbox" name="is_karma_sevk" id="is_karma_sevk" value="1"<cfif get_product_is_karma.IS_KARMA_SEVK EQ 1>checked="checked"</cfif>>
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='51646.Bu seçeneğe tıkladığınızda basketli işlemlerde karma koli bileşenleri stokları işlem kategorisine göre hareket eder.'></label>
								</label>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cfsavecontent variable="head"><cf_get_lang dictionary_id='57636.Birim'> - <cf_get_lang dictionary_id='36590.Paket Bilgisi'></cfsavecontent>
				<cf_seperator title="#head#" id="unit_body">
				<div id="unit_body">
					<cfquery name="GET_PRODUCT_UNIT" datasource="#DSN3#">
						SELECT 
							PRODUCT_UNIT_ID, 
							CASE
								WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
								ELSE ADD_UNIT
							END AS ADD_UNIT,
							IS_MAIN,
							UNIT_ID,
							MULTIPLIER,
							QUANTITY,
							DIMENTION, 
							VOLUME, 
							WEIGHT,
							UNIT_MULTIPLIER, 
							UNIT_MULTIPLIER_STATIC, 
							IS_SHIP_UNIT, 
							IS_ADD_UNIT,
							CASE
								WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
								ELSE MAIN_UNIT
							END AS MAIN_UNIT, 
							MAIN_UNIT_ID,
							PACKAGES,
							PATH,
							PACKAGE_CONTROL_TYPE,
							INSTRUCTION 
						FROM 
							PRODUCT_UNIT 
								LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PRODUCT_UNIT.UNIT_ID
								AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="UNIT">
								AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_UNIT">
								AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
						WHERE 
							PRODUCT_UNIT_ID = (SELECT TOP(1) PRODUCT_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND PRODUCT_UNIT_STATUS = 1)
						ORDER BY 
							ADD_UNIT
					</cfquery>
					<cf_box_elements>  
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">                
							<input type="hidden" name="product_unit_id" id="product_unit_id" value="<cfoutput>#get_product_unit.product_unit_id#</cfoutput>">
							<input type="hidden" name="main_unit" id="main_unit" value="<cfoutput>#get_product_unit.main_unit#</cfoutput>">
							<input type="hidden" name="main_unit_id" id="main_unit_id" value="<cfoutput>#get_product_unit.main_unit_id#</cfoutput>">
							<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#get_product.product_id#</cfoutput>">
							<input type="hidden" name="unit_id_" id="unit_id_" value="<cfoutput>#get_product_unit.unit_id#</cfoutput>">
							<!--- <div class="form-group">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
								<label class="col col-8 col-md-8 col-sm-8 col-xs-12 txtbold"><cfoutput>#get_product.product_name#</cfoutput></label>
							</div> --->
							
							<cfif get_product_unit.is_main neq 1>
								<div class="form-group">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37166.Ana Birim'></label>
									<label class="col col-8 col-md-8 col-sm-8 col-xs-12 txtbold"><cfoutput>#get_product_unit.main_unit#</cfoutput></label>
								</div>
							<cfelse>
								<div class="form-group">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37166.Ana Birim'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<select name="main_unit" id="main_unit" onchange="mess();">
											<cfoutput query="get_unit">
												<option value="#unit_id#,#unit#" <cfif get_product_unit.main_unit is unit> selected</cfif>>#unit#</option>
											</cfoutput>
										</select>
										<input type="hidden" name="old_main_unit" id="old_main_unit" value="<cfoutput>#get_product_unit.main_unit#</cfoutput>">
									</div>
								</div>
							</cfif>                
							<cfif get_product_unit.is_main neq 1>
								<div class="form-group">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37186.Ek Birim'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<select name="add_unit" id="add_unit">
											<cfoutput query="get_unit">
												<cfif get_product_unit.main_unit_id neq get_unit.unit_id>
													<option value="#unit_id#,#unit#" <cfif get_product_unit.add_unit is unit> selected</cfif>>#unit#</option>
												</cfif>
											</cfoutput>
										</select>
									</div>
								</div>
							</cfif>
							<cfif get_product_unit.is_main neq 1>
								<cfif xml_select_amount eq 1>
									<div class="form-group">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57635.Miktar'></label>
										<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
											<cfif len(get_product_unit.quantity)>
												<cfset amount_new_ = wrk_round(get_product_unit.quantity,8,1)>
											<cfelse>
												<cfset amount_new_ = wrk_round(get_product_unit.multiplier,8,1)>
											</cfif>
											<cfinput type="text" name="quantity" id="quantity" value="#tlformat(amount_new_,xml_quantity_round)#" onBlur="hesapla_amount();" required="Yes" onkeyup="FormatCurrency(this,event,#xml_quantity_round#)" class="moneybox">
										</div>
									</div>
								</cfif>
								<div class="form-group">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58865.Çarpan'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='37433.Çarpan girmelisiniz'></cfsavecontent>
											<cfset amount_new = wrk_round(get_product_unit.multiplier,8,1)>
											<cfinput type="text" name="multiplier" id="multiplier" required="Yes" onkeyup="FormatCurrency(this,event,4)" message="#message#" value="#tlformat(amount_new,4)#" class="moneybox">
											<span class="input-group-addon bold">*<cfoutput>#get_product_unit.main_unit#</cfoutput></span>
										</div>
									</div>
								</div>
							</cfif>
							 <div class="form-group">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57713.Boyut'> (<cf_get_lang dictionary_id='29703.cm'>)</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfinput type="text" name="dimention" id="dimention" value="#get_product_unit.dimention#" onBlur="return volume_calculate();">
										<span class="input-group-addon bold">a*b*h</span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="30114.Hacim"></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfinput type="text" name="volume" id="volume" value="#get_product_unit.volume#">
										<span class="input-group-addon bold"><cf_get_lang dictionary_id='37318.cm3'></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29784.Ağırlık'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfinput type="text" name="weight" id="weight" value="#tlformat(get_product_unit.weight,8)#" onkeyup="FormatCurrency(this,event,8)" class="moneybox">
										<span class="input-group-addon bold"><cf_get_lang dictionary_id='37188.kg'></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37612.Birim Çarpanı'></label>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
									<cfinput type="text" name="unit_multiplier" id="unit_multiplier" value="#tlformat(get_product_unit.unit_multiplier,4)#" onkeyup="FormatCurrency(this,event,4)" class="moneybox">
								</div><!--- maxlength="6" kaldirildi, ondalik hane degisebilir --->
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12"> 
									<select name="multiplier_static" id="multiplier_static">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<option value="1"<cfif get_product_unit.unit_multiplier_static eq 1> selected</cfif>><cf_get_lang dictionary_id='37613.Litre'></option>
										<option value="2"<cfif get_product_unit.unit_multiplier_static eq 2> selected</cfif>><cf_get_lang dictionary_id='37188.kg'></option>
										<option value="3"<cfif get_product_unit.unit_multiplier_static eq 3> selected</cfif>><cf_get_lang dictionary_id='58082.Adet'></option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-6 col-md-6 col-sm-6 col-xs-12"> 2.<cf_get_lang dictionary_id="57636.Birim"><input type="checkbox" name="is_add_unit" id="is_add_unit" <cfif get_product_unit.is_add_unit eq 1> checked</cfif> value="1"></label>
								<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='37859.Bu Birim İle Sevk Edilir'><input type="checkbox" name="is_ship_unit" id="is_ship_unit" <cfif get_product_unit.is_ship_unit eq 1> checked</cfif>></label>						
							</div>
						</div>
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-package">
								<label class="col col-5 col-md-5 col-sm-5 col-xs-12"><cf_get_lang dictionary_id='34799.Paket Tipi'></label>  
								<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
									<cfquery name="PACKAGES" datasource="#dsn#">
										SELECT 
											PACKAGE_TYPE_ID, 
											PACKAGE_TYPE
										FROM 
											SETUP_PACKAGE_TYPE
									</cfquery>
									<select name="packages" id="packages" >
										<option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
										<cfoutput query="PACKAGES">
											<option value="#PACKAGE_TYPE_ID#" <cfif get_product_unit.PACKAGES eq package_type_id>selected</cfif>>#PACKAGE_TYPE#</option>
										</cfoutput>
									</select>
								</div>
							</div> 
						<input type="hidden" name="master_code" id="master_code" value="<cfif isdefined('is_change_code') and is_change_code eq 1 and len(get_product_unit.PACKAGES)><cfoutput>#get_product.product_code#-#get_product_unit.PACKAGES#</cfoutput></cfif>">
							<div class="form-group" id="item-package_control_type">
								<label class="col col-5 col-md-5 col-sm-5 col-xs-12"><cf_get_lang dictionary_id ='37768.Paket Kontrol Tipi'></label>
								<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
									<select name="package_control_type" id="package_control_type">
										<option value="1" <cfif get_product_unit.package_control_type eq 1> selected</cfif>><cf_get_lang dictionary_id ='40429.Kendisi'></option>
										<option value="2" <cfif get_product_unit.package_control_type eq 2> selected</cfif>><cf_get_lang dictionary_id ='37770.Bileşenleri'></option>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-instruction">
								<label class="col col-5 col-md-5 col-sm-5 col-xs-12"><cf_get_lang dictionary_id='45222.Paketleme ve Taşıma Talimatı'></label>  
								<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
									<input type="text" name="instruction" id="instruction" value="<cfoutput>#get_product_unit.INSTRUCTION#</cfoutput>" >
								</div>
							</div>
							<div class="form-group">
								<label class="col col-5 col-md-5 col-sm-5 col-xs-12"><cf_get_lang dictionary_id='42647.Etiket Şablonu'></label>
								<div class="col col-7 col-md-7 col-sm-7 col-xs-12"><input type="File" name="image_file" id="image_file"/></div>
							</div>
							<div class="form-group">
								<label class="col col-5 col-md-5 col-sm-5 col-xs-12"></label>
								<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
									<input type="hidden" name="old_image_file" id="old_image_file" value="<cfoutput>#get_product_unit.path#</cfoutput>">
									<cfoutput>#get_product_unit.path#</cfoutput></div>
							</div>
						</div>
					</cf_box_elements>
				</div>
				<cfsavecontent variable="head"><cf_get_lang dictionary_id='50453.Fiyat ve Maliyet'></cfsavecontent>
				<cf_seperator title="#head#" id="price_body">
				<div id="price_body">
					<cf_box_elements vertical="1">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-grosstotal_cost">
								<label><cf_get_lang dictionary_id='58258.Maliyet'></label>							
								<input type="text" name="grosstotal_cost" id="grosstotal_cost" class="text-right" value="<cfoutput><cfif isdefined('grosstotal_cost')>#TLFormat(grosstotal_cost,session.ep.our_company_info.sales_price_round_num)#<cfelse>0</cfif></cfoutput>" readonly>				            
							</div> 
							<div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-grosstotal_price">
								<label><cf_get_lang dictionary_id='48183.Satış Fiyatı'></label>
								<div class="input-group">
									<input type="text" name="grosstotal_price" id="grosstotal_price" class="text-right" value="<cfoutput><cfif isdefined('grosstotal_price') and grosstotal_price gt 0>#TLFormat(filterNum(grosstotal_price,session.ep.our_company_info.sales_price_round_num),session.ep.our_company_info.sales_price_round_num)#<cfelse>0</cfif></cfoutput>" readonly>
									<span class="input-group-addon width">
										<select name="price_money" id="price_money" onChange="calculate_grosstotal(this.value);">
											<cfloop query="GET_MONEYS">
												<cfoutput><option value="#MONEY#"
												<cfif not GET_KARMA_PRODUCT.RECORDCOUNT>
													<cfif get_money_product.money eq MONEY>selected</cfif>
												<cfelseif isdefined('get_karma_products_price_') and get_karma_products_price_.RECORDCOUNT>
													<cfif get_karma_products_price_.LIST_MONEY eq MONEY>selected</cfif>
												<cfelse>
													<cfif GET_KARMA_PRODUCT.KARMA_PRODUCT_MONEY eq MONEY>selected</cfif>
												</cfif>>#MONEY#</option></cfoutput>
											</cfloop>
										</select>
									</span>
								</div>			
							</div>						
							<div class="form-group col col-2 col-md-3 col-sm-3 col-xs-12" id="item-price_cats">							
								<label><cf_get_lang dictionary_id='61708.Price Category'></label>
								<select name="price_catid_karma" id="price_catid_karma">
									<option value="-1"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="-1" <cfif get_product_price_lists.PRICE_CATID eq -1>selected</cfif> ><cf_get_lang dictionary_id='37600.Standard Sales Price'></option> <!--- Ürünün standartından gelir --->
									<cfoutput query="get_price_cat">
										<option value="#PRICE_CATID#" <cfif get_product_price_lists.PRICE_CATID eq PRICE_CATID> selected</cfif>>#PRICE_CAT#</option>
									</cfoutput>
								</select>						
							</div>
							<cfif get_product_price_lists.recordcount>
								<cfloop query="get_product_price_lists">
									<cfif PRICE_CATID eq get_product_price_lists.PRICE_CATID >
										<cfset attributes.start_date = get_product_price_lists.START_DATE>
										<cfset attributes.finish_date = get_product_price_lists.FINISH_DATE>
									</cfif>
								</cfloop>
							</cfif>
							<div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-start_date">
								<label><cf_get_lang dictionary_id='58053.Baslangic Tarihi'>*</label>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz '>!</cfsavecontent>
										<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
											<input required="Yes" message="<cfoutput>#message#</cfoutput>" type="text" name="start_date" id="start_date" style="width:65px;" value="<cfoutput>#dateformat(attributes.start_date,dateformat_style)#</cfoutput>"> 
										<cfelse>
											<input required="Yes" message="<cfoutput>#message#</cfoutput>" type="text" name="start_date" id="start_date" style="width:65px;" value="">
										</cfif>									
										<span class="input-group-addon btn_Pointer"><cf_wrk_date_image date_field="start_date"></span>
									</div>
								</div>
								<cfoutput>
									<div class="col col-3 col-md-3 col-sm-3 col-xs-6">
										<select name="start_h" id="start_h">
											<cfloop from="0" to="23" index="i">
												<option value="#i#" <cfif isdefined('attributes.start_date') and timeformat(attributes.start_date,'HH') eq i> selected</cfif>><cfif i lt 10>0</cfif><cfoutput>#i#</cfoutput></option>
											</cfloop>
										</select>
									</div>
									<div class="col col-3 col-md-3 col-sm-3 col-xs-6">
										<select name="start_m" id="start_m">
											<cfloop from="0" to="59" index="i">
												<option value="#i#" <cfif isdefined('attributes.start_date') and timeformat(attributes.start_date,'MM') eq i> selected</cfif>><cfif i lt 10>0</cfif><cfoutput>#i#</cfoutput></option>
											</cfloop>
										</select>
									</div>
								</cfoutput>					
							</div>
							<div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-finish_date">
								<label>	<cf_get_lang dictionary_id='57700.Bitis Tarihi'></label>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='53330.Son Ödeme Tarihi girmelisiniz'></cfsavecontent>
										<cfoutput>
											<cfif isdefined('attributes.finish_date')  and isdate(attributes.finish_date)>
												<input  type="text" name="finish_date" id="finish_date" style="width:65px;"value="#dateformat(attributes.finish_date,dateformat_style)#"> 
											<cfelse>
												<input   type="text" name="finish_date" id="finish_date" value="" validate="#validate_style#" style="width:65px;">
											</cfif>
										</cfoutput>
										<span class="input-group-addon btn_Pointer"><cf_wrk_date_image date_field="finish_date"></span>
									</div>
								</div>
								<cfoutput>
									<div class="col col-3 col-md-3 col-sm-3 col-xs-6">
										<select name="finish_h" id="finish_h">
											<cfloop from="0" to="23" index="i">
												<option value="#i#" <cfif isdefined('attributes.finish_date') and timeformat(attributes.finish_date,'HH') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
											</cfloop>
										</select>
									</div>
									<div class="col col-3 col-md-3 col-sm-3 col-xs-6">
										<select name="finish_m" id="finish_m">
											<cfloop from="0" to="59" index="i">
												<option value="#i#"<cfif isdefined('attributes.finish_date') and timeformat(attributes.finish_date,'MM') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
											</cfloop>
										</select>
									</div>
								</cfoutput>			
							</div>
							<div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-process_stage">
								<label><cf_get_lang dictionary_id="58859.Süreç"></label>
								<cf_workcube_process 
									is_upd='0' 
									select_value='#get_product_price_lists.process_stage#' 
									process_cat_width='140' 
									is_detail='0'>
							</div>
							
						</div>
					</cf_box_elements>
				</div>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<cf_box_footer>
						<cf_record_info query_name="get_record_info" record_emp="RECORD_EMP">
						<cf_workcube_buttons type_format='1' is_upd='0' is_cancel='0' add_function='controlForm()'>
					</cf_box_footer>
				</div>
			</cf_box>
			<cfsavecontent variable="head"><cf_get_lang dictionary_id='29411.Fiyatlar'></cfsavecontent>
			<cf_box title="#head#">
				<cf_grid_list id="fiyatlar1">
					<thead>
						<tr>
							<!-- sil --><th width="20"><a href="javascript://"><i class="fa fa-minus"></i></a></th><!-- sil -->
							<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
							<th><cf_get_lang dictionary_id='37144.Liste Adı'></th>
							<th><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang dictionary_id='58084.Fiyat'></th>
							<th><cf_get_lang dictionary_id='57677.DÖVİZ'> <cf_get_lang dictionary_id='58084.Fiyat'></th>
						</tr>
					</thead>
					<tbody>
						<cfif get_product_price_lists.recordcount and recordnumber>
							<cfoutput query="get_product_price_lists">
								<cfset l_money = LIST_MONEY>
								<cfset l_price = TOTAL_PRODUCT_PRICE>
								<tr>
									<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='37775.Kayıtlı Fiyatı Siliyorsunuz! Emin misiniz'>?</cfsavecontent>
									<!-- sil --><td><a href="javascript://" onClick="javascript:if (confirm('#alert#')) windowopen('#request.self#?fuseaction=product.emptypopup_del_price&price_id=#price_id#&pid=#attributes.pid#&price_catid=#price_catid#','small'); else return false;"><i class="fa fa-minus"></i></a></td><!-- sil -->
									<td>#currentrow#</td>
									<td>
										<cfif len(get_price_catid_list) and len(PRICE_CATID)>
											<a href="##" onClick="change_price_cat(#get_product_price_lists.PRICE_CATID#)">#get_price_cat_list.PRICE_CAT[listfind(get_price_catid_list,get_product_price_lists.PRICE_CATID,',')]#&nbsp;<font color="FFF0000">(#TOPLAM_URUN# ÜRÜN)</font></a>
										</cfif>
									</td>
									<td class="text-right">#Tlformat(TOTAL_PRODUCT_PRICE,session.ep.our_company_info.sales_price_round_num)# #session.ep.money#</td>
									<td class="text-right">
										<cfloop query="GET_MONEYS">
											<cfset p_money = GET_MONEYS.MONEY>
											<cfset p_rate = GET_MONEYS.RATE2>
												<cfif p_money eq l_money>
													#Tlformat(l_price/p_rate,session.ep.our_company_info.sales_price_round_num)# #MONEY#
												</cfif>
										</cfloop>
									</td>
								</tr>
							</cfoutput>
						<cfelse>
							<tr>
								<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
							</tr>
						</cfif>
					</tbody>
				</cf_grid_list>
			</cf_box>
		</cfform>
	</div>
	<cfsavecontent variable="delete_alert"><cf_get_lang dictionary_id='57533.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
	<script type="text/javascript">
		function test()
		{
			
			sql = "SELECT PDP.PROPERTY_ID,PP.PROPERTY FROM PRODUCT_DT_PROPERTIES PDP,PRODUCT_PROPERTY PP WHERE PDP.PROPERTY_ID = PP.PROPERTY_ID AND PDP.PRODUCT_ID=" + $('#product_id').val() ;
			get_product = wrk_query(sql,'DSN1');
			$('#prod_detail').empty();
			
			$('#prod_detail').append('<option value="">Seçiniz</option>');
			for ( var i = 0; i < get_product.recordcount; i++ ) {
				$("#prod_detail").append('<option value='+get_product.PROPERTY_ID[i]+'>'+get_product.PROPERTY[i]+'</option>');
			}
		}
		function warningCost(){
			$("input[id*=p_price_hidden]").each(function(){
				if($(this).val() <= 0)
					$(this).parent().parent().find("input").css("color","#ff0000");
				else
					$(this).parent().parent().find("input").css("color","#008000");
	
			});
			$("input[id*=s_price]").each(function(){
				if($(this).val() == "" || $(this).val() == 0)
					$(this).css("color","#ff0000");
			});
			$("input[id*=total_product_cost]").each(function(){
				if($(this).val() == "" || $(this).val() == 0)
					$(this).css("color","#ff0000");
			});
		}
		$(document).ready(function(){
			$("#prod_detail").change(function(){
				sql = "SELECT PPD.PROPERTY_DETAIL_ID,PPD.PROPERTY_DETAIL FROM PRODUCT_PROPERTY PP,PRODUCT_PROPERTY_DETAIL PPD,PRODUCT_DT_PROPERTIES PDTP WHERE PP.PROPERTY_ID = PPD.PRPT_ID AND PDTP.PROPERTY_ID = PP.PROPERTY_ID AND PDTP.PRODUCT_ID="+  $('#product_id').val() +"AND PP.PROPERTY_ID =  " + document.getElementById('prod_detail').value +"AND PPD.PROPERTY_DETAIL_ID IN (SELECT PROPERTY_DETAIL_ID FROM STOCKS_PROPERTY WHERE STOCK_ID IN (SELECT STOCK_ID  FROM STOCKS WHERE PRODUCT_ID="+$('#product_id').val()+"))" ;
				get_varyasyon = wrk_query(sql,'DSN1');
				$('#prod_varyasyon').empty();
				$('#prod_varyasyon').append('<option value="">Seçiniz</option>');
				for ( var i = 0; i < get_varyasyon.recordcount; i++ ) {
					$("#prod_varyasyon").append('<option value='+get_varyasyon.PROPERTY_DETAIL_ID[i]+'>'+get_varyasyon.PROPERTY_DETAIL[i]+'</option>');
				}
		
			});
			warningCost();
			$("#prod_varyasyon").change(function(){
				pricelist($('#product_id').val());
				});
			
			});		
			
		
		//function add_prod_row(stockid,product_id,product_unit_id,product_name)
	//	{
	//			for ( var i = 0; i < document.getElementById('price_row_count').value; i++ ) {
	//		row_count++;
	//		var newRow;
	//		var newCell;
	//		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
	//		newRow.className = 'color-row';
	//		newRow.setAttribute("name","frm_row" + row_count);
	//		newRow.setAttribute("id","frm_row" + row_count);		
	//		newRow.setAttribute("NAME","frm_row" + row_count);
	//		newRow.setAttribute("ID","frm_row" + row_count);
	//		document.form_basket.record_num.value=row_count;
	//		newCell = newRow.insertCell(newRow.cells.length);
	//		newCell.setAttribute('nowrap','nowrap');
	//		newCell.innerHTML='<a style="cursor:pointer" onclick="sil('+row_count+');"><img src="images/delete_list.gif" border="0" alt=""></a>';
	//		newCell = newRow.insertCell(newRow.cells.length);
	//		newCell.setAttribute('nowrap','nowrap');
	//		newCell.innerHTML=row_count;
	//		newCell = newRow.insertCell(newRow.cells.length);
	//		newCell.setAttribute('nowrap','nowrap');
	//		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol'+row_count+'">';
	//		newCell.innerHTML = newCell.innerHTML + '<input type="Hidden" name="stock_id'+row_count+'" value="' +stock_id  + '">';
	//		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="product_id'+row_count+'" value="'+product_id+'">';
	//		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="unit_id'+row_count+'" value="'+product_unit_id+'">';
	//		newCell.innerHTML = newCell.innerHTML + '<input type="text" name="product_name' + row_count + '" style="width:150px;"  value="'+product_name+'"><a href="javascript://" onClick="pencere_ac('+product_id+');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="<cf_get_lang no ="775.Ürün Seç">"></a>';
	//		}
	//		return false;
	//		
	//	}
		
		function open_spec_page(row)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=form_basket.spec_main_id'+row+'&field_name=form_basket.spec_name'+row+'&is_display=1&stock_id='+document.getElementById('stock_id'+row).value,'list');
		}
		row_count=<cfoutput>#recordnumber#</cfoutput>;
		satir_count = 0;
		if (<cfoutput>#recordnumber#</cfoutput>>0)calculate_grosstotal(<cfoutput>'#GET_KARMA_PRODUCT.KARMA_PRODUCT_MONEY#'</cfoutput>);
		if('<cfoutput>#liste_para_birimi#</cfoutput>' != undefined)calculate_grosstotal(<cfoutput>'#liste_para_birimi#'</cfoutput>);
		function sil(sy)
		{
			if(confirm('<cfoutput>#delete_alert#</cfoutput>')){
				var is_liste_fiyat = <cfoutput>#get_product_price_lists.recordcount#</cfoutput>
				if (is_liste_fiyat == "" || is_liste_fiyat == 0)
				{
					var my_element=eval("form_basket.row_kontrol"+sy);
					my_element.value=0;
					var my_element=eval("frm_row"+sy);
					my_element.style.display="none";
					calculate_grosstotal(document.form_basket.selected_money.value);
					
					//$(my_element).parents('input').remove();
					$("#product_id" + sy).remove();//#79263 işi için kullanılıyor.Silme
					$("#property_id" + sy).remove();//#79263 işi için kullanılıyor.Silme
					$("#property_detail_id" + sy).remove();//#79263 işi için kullanılıyor.Silme
					
					
				}
				else
				alert("<cf_get_lang dictionary_id ='37785.Ürün Silmek İçin Öncelikle Liste Fiyatlarını Siliniz'>.");
			}	
		}
		function clearSpecM(row){
			if(document.getElementById('spec_name'+row).value =="")
				document.getElementById('spec_main_id'+row).value ="";
		}
		function add_row(stockid,stockprop,sirano,product_id,product_name,stock_code,property,manufact_code,tax,tax_purchase,add_unit,product_unit_id,money,is_serial_no,discount1,discount2,discount3,discount4,discount5,discount6,discount7,discount8,discount9,discount10,del_date_no,p_price,s_price,product_cost,extra_product_cost,is_production,list_price,other_list_price,spec_main_id,spec_main_name,assortment_default_amount)
		{
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.className = 'color-row';
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
			document.form_basket.record_num.value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML='<a style="cursor:pointer" onclick="sil('+row_count+');"><i class="fa fa-minus"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML='<div class="form-group"><input type="text" name="stock_code_'+row_count+'" id="stock_code_'+row_count+'" value="'+stock_code+'"  readonly> </div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" value="1" id="row_kontrol'+row_count+'" name="row_kontrol'+row_count+'">';
			newCell.innerHTML = newCell.innerHTML + '<input type="Hidden" id="stock_id'+row_count+'" name="stock_id'+row_count+'" value="' + stockid + '">';
			newCell.innerHTML = newCell.innerHTML + '<input type="hidden" id="product_id'+row_count+'" name="product_id'+row_count+'" value="'+product_id+'">';
			newCell.innerHTML = newCell.innerHTML + '<input type="hidden" id="unit_id'+row_count+'" name="unit_id'+row_count+'" value="'+product_unit_id+'">';
			newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><div class="input-group"><input type="text" name="product_name' + row_count + '" id="product_name' + row_count + '" style="width:150px;"  value="'+product_name+' - '+property+'"><span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac('+product_id+');"></span></div></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<div class="form-group"><div class="col col-3"><input type="text" id="spec_main_id'+row_count+'" name="spec_main_id'+row_count+'" title="Spec Main ID" value="'+spec_main_id+'" style="width:35px;" readonly></div><div class="col col-9"><div class="input-group"> <input type="text" style="width:100px;" id="spec_name'+row_count+'" name="spec_name'+row_count+'" value="'+spec_main_name+'" onChange="clearSpecM('+row_count+')"> <span class="input-group-addon icon-ellipsis btnPointer" onClick="open_spec_page('+row_count+');"></span></div></div></div>';
			<cfif len(GET_KARMA_PRODUCT.KARMA_PROPERTY_SIZE_ID)>
				newCell = newRow.insertCell(newRow.cells.length);//Özellik 1
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<div class="form-group"><input type="text"  id="property_1_'+row_count+'" name="property_1_'+row_count+'" readonly="yes"></div>';
			</cfif>
			<cfif len(GET_KARMA_PRODUCT.KARMA_PROPERTY_COLLAR_ID)>
				newCell = newRow.insertCell(newRow.cells.length);//Özellik 2
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<div class="form-group"><input type="text"  id="property_2_'+row_count+'" name="property_2_'+row_count+'" readonly="yes"></div>';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);//Miktar
			newCell.innerHTML = '<div class="form-group"><input type="text" class="moneybox" name="row_amount' + row_count + '" id="row_amount' + row_count + '" value="'+assortment_default_amount+'" onBlur="calculate_amount(' + row_count + ');"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" style="display:none" name="manufact_code' + row_count + '" value="'+manufact_code+'">';
			newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input type="text" id="unit' + row_count + '" name="unit' + row_count + '"  readonly value="' + add_unit + '"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<div class="form-group"><input class="moneybox" type="text" id="tax_purchase' + row_count + '" name="tax_purchase' + row_count + '" value="' + commaSplit(tax_purchase,0) + '"style="width:100%;" readonly="yes"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<div class="form-group"><input class="moneybox" type="text" name="tax' + row_count + '" id="tax' + row_count + '"  value="' + commaSplit(tax,0) + '" readonly="yes" ></div>';
			newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="action_profit_margin' + row_count + '" id="action_profit_margin' + row_count + '"  value="0">';
			/*newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="action_price' + row_count + '" >';*/
			newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="duedate' + row_count + '" id="duedate' + row_count + '"  value="0">';
			newCell.innerHTML = newCell.innerHTML + '<input type="hidden"  name="shelf_id' + row_count + '"><input type="hidden" name="shelf_name' + row_count + '" value="">';
			newCell = newRow.insertCell(newRow.cells.length);//birim maliyet
			newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input class="moneybox" type="text" readonly="readonly" id="products_cost'+row_count+'" name="products_cost'+row_count+'" value="' + commaSplit(product_cost,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"></div>';
			newCell = newRow.insertCell(newRow.cells.length);//Ek maliyet
			newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input class="moneybox" type="text" readonly="readonly" id="extra_product_cost'+row_count+'" name="extra_product_cost'+row_count+'" value="' + commaSplit(extra_product_cost,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"></div>';//ek maliyet
			newCell = newRow.insertCell(newRow.cells.length);//Liste Fiyatı
			newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input class="moneybox" type="text" readonly="readonly" id="list_price'+row_count+'" name="list_price'+row_count+'" value="' + commaSplit(list_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"></div>';
			newCell = newRow.insertCell(newRow.cells.length);//Döviz Liste Fiyatı
			newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input class="moneybox" type="text" onKeyUp="hesapla_row(1,'+row_count+');" id="other_list_price'+row_count+'" name="other_list_price'+row_count+'" value="' + commaSplit(other_list_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"></div>';
			newCell = newRow.insertCell(newRow.cells.length);//Para birimi
			c = '<div class="form-group"><select name="money' + row_count  +'" id="money' + row_count  +'" onChange="hesapla_row(1,'+row_count+');">';
				<cfoutput query="get_moneys">
				if('#money#' == money)
					c += '<option value="#money#;#rate2#" selected>#money#</option>';
				else
					c += '<option value="#money#;#rate2#">#money#</option>';
				</cfoutput>
				newCell.innerHTML =c+ '</select></div>';
			newCell = newRow.insertCell(newRow.cells.length);//Satış Fiyatı
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input class="moneybox" type="text" id="s_price' + row_count + '" name="s_price' + row_count + '" onKeyUp="hesapla_row(3,'+row_count+');"  value="' + commaSplit(s_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"  style="width:80px;" onBlur="if(this.value==\'\')this.value=0;calculate_amount(' + row_count + ');"><span class="input-group-addon icon-ellipsis btnPointer" onclick="open_price(' + row_count + ');"></span><input type="hidden" name="p_price' + row_count + '" value="' + commaSplit(p_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"><input type="hidden" name="profit_margin' + row_count + '" value="0"></div></div>';
			
			newCell = newRow.insertCell(newRow.cells.length);//Toplam Maliyet
			newCell.innerHTML = '<div class="form-group"><input  class="moneybox" type="text" name="total_product_cost' + row_count + '" id="total_product_cost' + row_count + '" readonly value="1" onBlur="calculate_amount(' + row_count + ');"></div><input type="hidden" value="" name="p_price_hidden' + row_count + '" id="p_price_hidden' + row_count + '">';
			newCell = newRow.insertCell(newRow.cells.length);//Toplam satış fiyatı
			newCell.innerHTML = '<div class="form-group"><input  class="moneybox" type="text" name="total_product_price' + row_count + '" id="total_product_price' + row_count + '"readonly value="1" onBlur="calculate_amount(' + row_count + ');"></div>';
			
			calculate_amount(row_count);
			$("#p_price_hidden"+row_count).val(parseFloat($("#s_price"+row_count).val())-parseFloat($("#total_product_cost"+row_count).val()));
			warningCost();
		}		
		function pencere_ac(no)
		{
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&is_sub_category=1&pid='+no);
		}
		function getShelf(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_list_shelf&shelf_id=form_basket.shelf_id'+no+'&shelf_name=form_basket.shelf_name'+no,'medium');
		}
		function openProducts()
		{
			openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.popup_stocks<cfif isdefined("attributes.compid")>&compid=#attributes.compid#</cfif>&add_product_cost=1&is_filter=1&module_name=product&var_=#var_#&is_action=1&startdate=&price_lists=</cfoutput>');
		
		}
		function addMasterStocks(){
			var barcod = $('#master_product_id').val()==<cfoutput>#attributes.pid#</cfoutput> ?"<cfoutput>&karma_product_barcod=#get_product.barcod#</cfoutput>":"";
			openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.popup_stocks<cfif isdefined("attributes.compid")>&compid=#attributes.compid#</cfif>&add_product_cost=1&module_name=product&var_=#var_#&is_action=1&startdate=&price_lists=&is_filter=1</cfoutput>&price_catid_ref='+$('#price_catid').val()+'&karma_product_id='+$('#master_product_id').val()+barcod);
		}
		function controlForm()
		{
		
			
			if(row_count>0 &&  document.form_basket.start_date != undefined && document.form_basket.finish_date != undefined && document.form_basket.finish_date.value.length != 0 && document.form_basket.price_catid.value != "")
			{
			if  (time_check(document.form_basket.start_date,document.form_basket.start_h,document.form_basket.start_m,document.form_basket.finish_date,document.form_basket.finish_h,document.form_basket.finish_m,'Başlangıç Ve Bitiş Tarihlerini Kontrol Ediniz !')==false)
				return false;
			}
			for(var i=1; i<=row_count; i++)
			{
				var str_me=eval("form_basket.p_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
				var str_me=eval("form_basket.s_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
				var str_me=eval("form_basket.profit_margin"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
				var str_me=eval("form_basket.extra_product_cost"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
				var str_me=eval("form_basket.products_cost"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
				var str_me=document.getElementById('total_product_cost'+i);
				if(str_me!= null)
					str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
					
				var str_me=eval("form_basket.total_product_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
				var str_me=eval("form_basket.tax_purchase"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
				var str_me=eval("form_basket.row_lasttotal"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
				var str_me=eval("form_basket.row_amount"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
				var str_me=eval("form_basket.tax"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
				var str_me=eval("form_basket.list_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
				var str_me=eval("form_basket.other_list_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
			}
			var str_me=form_basket.grosstotal_price;if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
			<cfif get_product_unit.is_main neq 1>
				document.getElementById('multiplier').value = filterNum(document.getElementById('multiplier').value,4);    
				if(document.getElementById('multiplier').value == 0)
				{
					alert("<cf_get_lang dictionary_id='37109.Çarpan alanına sıfır değerini giremezsiniz!'>");
					return false;	
				}      
			</cfif>
			document.getElementById('weight').value = filterNum(document.getElementById('weight').value,8);
			document.getElementById('unit_multiplier').value = filterNum(document.getElementById('unit_multiplier').value,4);
			$('#price_catid').val($('#price_catid_karma option:selected').val());
			return true;
		}
		function calculate_amount(rowno)
		{
			var money_count = <cfoutput>#GET_MONEYS.RECORDCOUNT#</cfoutput>;
			var temp_products_cost = parseFloat(filterNum(document.getElementById('products_cost'+rowno).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>'));
			var temp_extra_product_cost = parseFloat(filterNum(document.getElementById('extra_product_cost'+rowno).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>'));
			var temp_row_amount = parseFloat(filterNum(document.getElementById('row_amount'+rowno).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>'));
			document.getElementById('total_product_cost'+rowno).value = commaSplit( ( (temp_products_cost + temp_extra_product_cost)* temp_row_amount ),'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');//Burada birim maliyet ve ek maliyeti toplayarak miktar ile çarpıyoruz.
			
			<cfloop query=GET_MONEYS>
			 if(list_getat(document.getElementById('money'+rowno).value,1,';') == '<cfoutput>#money#</cfoutput>')
			{
				//KDV 'li eval("document.form_basket.total_product_price"+rowno).value = commaSplit(Number((Number(filterNum(eval('document.form_basket.tax'+rowno).value)) + 100) / 100) * Number(filterNum(eval('document.form_basket.s_price'+rowno).value)*(filterNum(eval('document.form_basket.row_amount'+rowno).value))));//Burada liste satış fiyatı kdv oranı ve miktarı ile çarpılıyor.
				document.getElementById('total_product_price'+rowno).value = commaSplit(Number(filterNum(document.getElementById('s_price'+rowno).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>')*(filterNum(document.getElementById('row_amount'+rowno).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>'))),'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');//Burada liste satış fiyatı kdv oranı ve miktarı ile çarpılıyor.
				//eval("document.form_basket.total_product_price"+rowno).value = commaSplit((<cfoutput>#GET_MONEYS.RATE2#</cfoutput>)*filterNum(eval("document.form_basket.total_product_price"+rowno).value));//Burada 1 üst satırda oluşturulan toplam liste satış fiyatı döviz kuru rate2 ile çarpılarak genel toplam sistem para birimi cinsinden yazılıyor.
				calculate_grosstotal(document.form_basket.selected_money.value);
				
			}	
			</cfloop>
			
		}
		function calculate_grosstotal(type)
		{
	
			document.form_basket.grosstotal_cost.value = 0;
			document.form_basket.grosstotal_price.value = 0;
			for(ix=1;ix<row_count+1;ix++){
				if(document.getElementById('row_kontrol'+ix).value==1){
					document.form_basket.grosstotal_cost.value = commaSplit(Number(filterNum(document.form_basket.grosstotal_cost.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>')) + Number(filterNum(eval("document.form_basket.total_product_cost"+ix).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>')),'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
					<cfloop query=GET_MONEYS>
						if(type =='<cfoutput>#GET_MONEYS.MONEY#</cfoutput>')
						{
						document.form_basket.grosstotal_price.value = commaSplit(Number(filterNum(document.form_basket.grosstotal_price.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>')) + Number(filterNum(eval("document.form_basket.total_product_price"+ix).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>'))/<cfoutput>#GET_MONEYS.RATE2[currentrow]#</cfoutput>,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
						}
					</cfloop>
					document.form_basket.selected_money.value=type;
				}
			}
		}
		function change_price_cat(id)
		{
			document.form_basket.action = '<cfoutput>#request.self#?fuseaction=product.dsp_karma_contents&pid=#attributes.pid#&price_catid='+id+'</cfoutput>';
			document.form_basket.submit();
		}
		function uyar(type)
		{
			if (type==1)
			alert("<cf_get_lang dictionary_id ='37783.Bir Liste Fiyatı Varken ya da Seçili İken, Miktar Üzerinde Değişiklik Yapamazsınız Liste Fiyatlarını Silerek Standart Ürün Listesini Tekrar Düzenleyiniz'>.");
			if (type==2)
			alert("<cf_get_lang dictionary_id ='37784.Bir Liste Fiyatı Varken ya da Seçili İken, Ürün Listesine Ekleme Yada Çıkarma Yapamazsınız Liste Fiyatlarını Silerek Standart Ürün Listesini Tekrar Düzenleyiniz'>.");
		}
		function open_price(satir)
		{
			url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_price_history_js&is_from_product&row_no='+satir+'';
			product_id = eval("document.form_basket.product_id"+satir).value;
			stock_id = eval("document.form_basket.stock_id"+satir).value;
			product_name = '';
			unit_ = eval("document.form_basket.unit_id"+satir).value;
			url_str = url_str + '&sepet_process_type=-1';
			url_str = url_str + '&product_id=' + product_id + '&stock_id=' + stock_id + '&pid=' + product_id + '&product_name=' + product_name + '&unit=' + unit_ + '&row_id=' + satir;
			<cfloop query="get_moneys">
				url_str = url_str + '&<cfoutput>#money#=#rate2/rate1#</cfoutput>';
			</cfloop>
			if(product_id != "")
				windowopen(url_str,'medium');
		}
		function hesapla_row(type,row_info)
		{
			
			form_value_rate_satir = list_getat(eval("document.getElementById('money" + row_info + "')").value,2,';');
			if(type != 3)
			{
				eval("document.form_basket.s_price"+row_info).value = commaSplit(filterNum(eval("document.form_basket.other_list_price"+row_info).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>')*form_value_rate_satir,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
			}
			else
			{
				eval("document.form_basket.other_list_price"+row_info).value = commaSplit(filterNum(eval("document.form_basket.s_price"+row_info).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>')/form_value_rate_satir,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
			}
			
			calculate_amount(row_info);
		}
		moneyArray = new Array(<cfoutput>#get_moneys.recordcount#</cfoutput>);
		rate1Array = new Array(<cfoutput>#get_moneys.recordcount#</cfoutput>);
		rate2Array = new Array(<cfoutput>#get_moneys.recordcount#</cfoutput>);
		<cfoutput query="get_moneys">
			/*javascript array doldurulur*/
			<cfif session.ep.period_year gte 2009 and get_moneys.MONEY is 'YTL'>
				moneyArray[#currentrow-1#] = '#session.ep.money#';
			<cfelse>
				moneyArray[#currentrow-1#] = '#MONEY#';
			</cfif>
			rate1Array[#currentrow-1#] = #rate1#;
			rate2Array[#currentrow-1#] = #rate2#;
			/*javascript array doldurulur*/
		</cfoutput>
		
		function add_prod_row(){
			// $("#table1").empty();
			
		for(h=1;h<row_count+1;h++){
		if($('#product_id'+h).val()!=$('#product_id').val() &&  typeof $('#product_id'+h).val() !== 'undefined')//Koliye Farklı Bir Ürün Eklenemez.
			{
				alert("<cf_get_lang dictionary_id='60379.Koliye Farklı Ürün Eklenemez'>");
				return false;
		}
			}	
			
		url_ = "/V16/product/cfc/GetPrice.cfc?method=getPrice&product_id="+$('#product_id').val()+"&prod_detail="+$('#prod_detail').val()+"&prod_varyasyon="+$('#prod_varyasyon').val()+"&price_id="+$('#price_list').val();
		$.ajax({
		url: url_,
		dataType: "text",
		success: function(read_data) {
			read_data = read_data.substring(2, read_data.length);
		data_ = jQuery.parseJSON(read_data);
		if(data_.DATA.length !=0)
		{
			
			$.each(data_.DATA,function(i){
			$.each(data_.COLUMNS,function(k){
			var PROPERTY_DETAIL_ID = data_.DATA[i][0];
			var PROPERTY_DETAIL = data_.DATA[i][1];
			var STOCK_ID = data_.DATA[i][2];
			var PROPERTY_ID = data_.DATA[i][3];
			var PRODUCT_NAME = data_.DATA[i][4];
			var MAIN_UNIT = data_.DATA[i][5];
			var PRODUCT_UNIT_ID = data_.DATA[i][6];
			var TAX = data_.DATA[i][7];
			var TAX_PURCHASE = data_.DATA[i][8];
			var PRODUCT_ID = data_.DATA[i][9];
			var SISTEM_MALIYET = data_.DATA[i][10];
			var EK_MALIYET = data_.DATA[i][11];
			var PRICE = data_.DATA[i][12];
			var MONEY = data_.DATA[i][13];
			if( k == 7 )
			add_modal_orders(PRODUCT_NAME,PRODUCT_UNIT_ID,STOCK_ID,PRODUCT_ID,MAIN_UNIT,TAX_PURCHASE,TAX,SISTEM_MALIYET,EK_MALIYET,PRICE,MONEY,PROPERTY_ID,PROPERTY_DETAIL_ID);
	
		});
		});
	
		}
		}
	});
					
	
		}
		
		
		function add_modal_orders(PRODUCT_NAME,PRODUCT_UNIT_ID,STOCK_ID,PRODUCT_ID,MAIN_UNIT,TAX_PURCHASE,TAX,SISTEM_MALIYET,EK_MALIYET,PRICE,MONEY,PROPERTY_ID,PROPERTY_DETAIL_ID)// siparis listesi olusturuluyor
		{
			
			var is_error = 0;
		for(h=1;h<row_count+1;h++){
				if($('#stock_id'+h).val()==STOCK_ID)
					{
						//alert($('#stock_id'+h).val()+' : aynı stok zaten var : '+STOCK_ID);
						h++;
						is_error = 1;
						return false;
					}
				if($('#property_detail_id'+h).val()!=PROPERTY_DETAIL_ID &&  typeof $('#property_detail_id'+h).val() !== 'undefined')
				{
					alert('<cf_get_lang dictionary_id="60380.Koliye Aynı Ürünün Farklı Varyasyonunu Ekleyemezsiniz">.');
					is_error= 1 ;
					break;
					return false;
				}
			}
			if(is_error==0)
			{
				row_count++;
				document.form_basket.record_num.value=row_count;
				var k=$('#table1 tbody').children().length;
				if(row_count == 1)
				{
					var new_row = new_row+'<tr name="frm_row'+ row_count +'" id="frm_row' + row_count + '">';
				}
				
				else
				{
					$('#table1').children("tr:last").after("<tr id=frm_row"+row_count+" name=frm_row"+row_count+">");
				}
				var new_row = new_row+'<td><input type="hidden" name="row_kontrol'+ row_count +'" id="row_kontrol' + row_count + '" value="1"><a style="cursor:pointer" onclick="sil('+row_count+');"><i class="fa fa-minus"></i></a></td>';
				var new_row = new_row+'<td>'+ row_count +'</td>';
				var new_row = new_row+'<td><input type="hidden" name="stock_id'+row_count+'" id="stock_id'+row_count+'" value="'+STOCK_ID+'">';
				var new_row = new_row+'<input type="hidden" name="product_id'+row_count+'" id="product_id'+row_count+'" value="'+PRODUCT_ID+'">';
				var new_row = new_row+'<input type="hidden" name="unit_id'+row_count+'" id="unit_id'+row_count+'" value="'+PRODUCT_UNIT_ID+'">';
				var new_row = new_row+'<input type="Hidden" name="property_id'+row_count+'" id="property_id'+row_count+'" value="'+PROPERTY_ID+'">';
				var new_row = new_row+'<input type="Hidden" name="property_detail_id'+row_count+'" id="property_detail_id'+row_count+'" value="'+PROPERTY_DETAIL_ID+'">';
				var new_row = new_row+'<input type="hidden" name="product_name'+row_count+'" value="'+PRODUCT_NAME+'" style="width:155px;" >'+ PRODUCT_NAME;
				var new_row = new_row+'<a href="javascript://" onClick="pencere_ac('+PRODUCT_ID+');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="<cf_get_lang dictionary_id ="37786.Ürün Seç">"></a></td>'; 
				var new_row = new_row+'<td><input type="text" style="width:35px;" name="spec_main_id'+row_count+'" id="spec_main_id'+row_count+'" value="" readonly>';
				var new_row = new_row+'<input type="text" name="spec_name'+row_count+'" id="spec_name'+row_count+'" style="width:100px;" onChange="clearSpecM('+row_count+')" value=""><a href="javascript://" onClick="open_spec_page('+row_count+');"><img src="/images/plus_thin.gif"></a></td>';
				var new_row = new_row+'<td><div class="form-group"><input type="text" name="unit'+row_count+'" id="unit'+row_count+'" value="'+MAIN_UNIT+'"  readonly></div></td>';
				var new_row = new_row+'<td><div class="form-group"><input type="text" name="tax_purchase'+row_count+'" readonly="yes" id="tax_purchase'+row_count+'" value="'+TAX_PURCHASE+'"></div></td>';
				var new_row = new_row+'<td><div class="form-group"><input type="text" name="tax'+row_count+'" readonly="yes" id="tax'+row_count+'" value="'+TAX+'"></div></td>';
				var new_row = new_row+'<td><div class="form-group"><input type="text" name="products_cost'+row_count+'" readonly id="products_cost'+row_count+'" value="'+commaSplit(SISTEM_MALIYET,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)+'"></div></td>';
				var new_row = new_row+'<td><div class="form-group"><input type="text" style="width:100%"; name="extra_product_cost'+row_count+'" readonly="yes" id="extra_product_cost'+row_count+'" value="'+commaSplit(EK_MALIYET,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)+'"></div></td>';
				var new_row = new_row+'<td><div class="form-group"><input type="text" style="width:100%"; name="list_price'+row_count+'" readonly="yes" id="list_price'+row_count+'" value="'+commaSplit(PRICE,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)+'"><</div>/td>';
				var new_row = new_row+'<td><div class="form-group"><input type="text"  name="other_list_price'+row_count+'"  id="other_list_price'+row_count+'" value="" onKeyUp="hesapla_row(1,'+row_count+');"></div></td>';
				c = '<select name="money' + row_count  +'" id="money' + row_count  +'" onChange="hesapla_row(1,'+row_count+');">';
					<cfoutput query="get_moneys">
					if('#money#' == MONEY)
						c += '<option value="#money#;#rate2#" selected>#money#</option>';
					else
						c += '<option value="#money#;#rate2#">#money#</option>';
					</cfoutput>
				var new_row = new_row+'<td>'+c+ '</select></td>';
				
				var new_row = new_row+'<td><div class="form-group"><div class="input-group"><input type="text" name="s_price' + row_count + '" id="s_price' + row_count + '" onKeyUp="hesapla_row(3,'+row_count+');"   value="'+commaSplit(PRICE,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)+'"  style="width:80px;" onBlur="if(this.value==\'\')this.value=0;calculate_amount(' + row_count + ');"><span class="input-group-addon icon-ellipsis btnPointer" onclick="open_price(' + row_count + ');"></span></div></div></td>';
				var new_row = new_row+'<td><div class="form-group"><input type="text" name="row_amount' + row_count + '" id="row_amount' + row_count + '" value="1" onBlur="calculate_amount(' + row_count + ');"></div></td>';
				
				var new_row = new_row+'<td><div class="form-group"><input type="text" name="total_product_cost'  + row_count + '" id="total_product_cost'  + row_count + '" readonly value="1" onBlur="calculate_amount(' + row_count + ');"></div></td>';
				var new_row = new_row+'<td><div class="form-group"><input type="text" name="total_product_price' + row_count + '" id="total_product_price' + row_count + '"readonly value="1" onBlur="calculate_amount(' + row_count + ');"></div></td></tr>';
				//var new_row = new_row+'<td>'+  +'</td></tr>';
				
				if(row_count==1)
				{
					$("#table1").append(new_row);
				}
				else
				{
				$('#table1').find('tr:last').append(new_row);
				}
				calculate_amount(row_count);
			}
		}
		
		function pricelist(product_id)
		{
			url_ = "/V16/product/cfc/GetPrice.cfc?method=getPriceList&product_id="+product_id;
			$.ajax({
			url: url_,
			dataType: "text",
			success: function(read_data) {
			read_data = read_data.substring(2, read_data.length);
			data_ = jQuery.parseJSON(read_data);
		if(data_.DATA.length !=0)
		{
			$('#price_list').empty();
			$('#price_list').append('<option value="">Seçiniz</option>');
			$.each(data_.DATA,function(i){
			$.each(data_.COLUMNS,function(k){
			var PRICE_ID = data_.DATA[i][0];
			var PRICE_CAT = data_.DATA[i][1];
			 if( k == 1 )
			$("#price_list").append('<option value='+PRICE_ID+'>'+PRICE_CAT+'</option>');
			
		});
		});
	
		}
		}
	});
		}
	
	</script>
	
	