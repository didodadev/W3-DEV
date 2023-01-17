<cf_xml_page_edit fuseaction="product.popup_form_add_product_price">
	<cfparam name="attributes.modal_id" default="">
<cfset bugun = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
<cfscript>
		get_product_list_action = createObject("component", "V16.product.cfc.get_product");
		get_product_list_action.dsn1 = dsn1;
		get_product_list_action.dsn_alias = dsn_alias;
		GET_PRODUCT = get_product_list_action.get_product_
		(
			module_name : fusebox.circuit,
			pid : attributes.pid
		);
</cfscript>
<cfinclude template="../query/get_price_cat.cfm">
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_product_unit.cfm">
<cfif len(get_product.PROFIT_MARGIN)>
	<cfset product_cat_profit_margin = get_product.PROFIT_MARGIN>
<cfelse>
	<cfset product_cat_profit_margin = 0>
</cfif>
<!--- net maliyet hesabı --->
<cfquery name="GET_PURCHASE_PROD_DISCOUNT_DETAIL" datasource="#dsn3#" maxrows="1">
	SELECT
		*
	FROM
		CONTRACT_PURCHASE_PROD_DISCOUNT
	WHERE
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PID#"> AND
		CONTRACT_ID IS NULL
	ORDER BY 
		START_DATE DESC
</cfquery>
<cfquery name="GET_STOCK_INFO" datasource="#dsn3#" maxrows="1">
	SELECT PROPERTY,PRODUCT_NAME,PRODUCT_UNIT_ID,STOCK_ID,STOCK_STATUS,PRODUCT_ID FROM STOCKS WHERE STOCK_STATUS = 1 AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PID#"> AND PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.PRODUCT_UNIT_ID#"> ORDER BY STOCK_ID ASC
</cfquery>
<cfif GET_STOCK_INFO.recordcount>
	<cfset attributes.stock_id_ = GET_STOCK_INFO.STOCK_ID>
	<cfset attributes.product_name_ = GET_STOCK_INFO.PRODUCT_NAME>
</cfif>
<cfquery name="GET_PRICE_SA" datasource="#DSN3#">
	SELECT 
		PU.ADD_UNIT,
		PS.PRICE,
		PS.MONEY
	FROM 
		PRICE_STANDART PS, 
		PRODUCT_UNIT PU
	WHERE
		PS.PURCHASESALES = 0 AND
		PS.PRICESTANDART_STATUS = 1 AND 
		PS.UNIT_ID = PU.PRODUCT_UNIT_ID	AND
		PS.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PID#">
</cfquery>
<cfquery name="GET_PRODUCT_COST" DATASOURCE="#DSN3#" MAXROWS="1">
	SELECT
		* 
	FROM 
		PRODUCT_COST 
	WHERE 
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PID#">
	ORDER BY 
		RECORD_DATE DESC
</cfquery>
<cfscript>
	indirim1 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT1;
	indirim2 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT2;
	indirim3 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT3;
	indirim4 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT4;
	indirim5 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT5;
	if (not len(indirim1)){indirim1 = 0;}
	if (not len(indirim2)){indirim2 = 0;}
	if (not len(indirim3)){indirim3 = 0;}
	if (not len(indirim4)){indirim4 = 0;}
	if (not len(indirim5)){indirim5 = 0;}
	satis_kdv = GET_PRODUCT.TAX;
	alis_kdv = GET_PRODUCT.TAX_PURCHASE;
	toplam_diger_maliyet = 0;
	standart_maliyet = 0;
	indirimli_standart_maliyet = 0;
	if (not GET_PRODUCT_COST.recordcount)
	{		
		indirimli_alis_fiyat = GET_PRICE_SA.price;
		indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim1)/100;
		indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim2)/100;
		indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim3)/100;
		indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim4)/100;
		indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim5)/100;
	}	
	else
	{
		toplam_diger_maliyet = GET_PRODUCT_COST.STANDARD_COST + ((GET_PRICE_SA.price*GET_PRODUCT_COST.STANDARD_COST_RATE)/100);//GET_PRODUCT_COST.GENERAL_COST + GET_PRODUCT_COST.TRANSPORT_COST + GET_PRODUCT_COST.OTHER_COST
		
		standart_maliyet = GET_PRICE_SA.price - toplam_diger_maliyet;
		indirimli_standart_maliyet = standart_maliyet;
		indirimli_standart_maliyet = indirimli_standart_maliyet*(100-indirim1)/100;
		indirimli_standart_maliyet = indirimli_standart_maliyet*(100-indirim2)/100;
		indirimli_standart_maliyet = indirimli_standart_maliyet*(100-indirim3)/100;
		indirimli_standart_maliyet = indirimli_standart_maliyet*(100-indirim4)/100;
		indirimli_standart_maliyet = indirimli_standart_maliyet*(100-indirim5)/100;
		
		indirimli_alis_fiyat = indirimli_standart_maliyet + toplam_diger_maliyet;
	}
</cfscript>
<!--- net maliyet hesabı --->
<cfloop query="get_product_unit">
	<cfif len(is_main)>
		<cfset product_main_unit = add_unit>
	</cfif>
</cfloop>
<cfsavecontent variable="right">
	<cfoutput>
		<a href="javascript://" style="color:##E08283;font-size:15px;" onClick="windowopen('#request.self#?fuseaction=product.popup_actions_price&pid=#url.pid#','list')" ><i class="fa fa-gears" alt="<cf_get_lang dictionary_id='58988.Aksiyon'>"  title="<cf_get_lang dictionary_id='58988.Aksiyon'>"></i></a>&nbsp;&nbsp;&nbsp;
		<a href="javascript://" style="color:##E08283;font-size:15px;" onClick="windowopen('#request.self#?fuseaction=product.popup_product_contract&pid=#url.pid#','medium');"><i  class="fa fa-handshake-o"  title="<cf_get_lang dictionary_id='37277.Satınalma Koşulları'>" ></i></a>&nbsp;
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37306.Yeni Fiyat'></cfsavecontent>
<cf_box title="#message# : #get_product.product_name#" right_images='#right#' scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=product.emptypopup_add_price" method="post" name="price">
	<cfoutput>
	<input type="hidden" name="active_company" id="active_company" value="#session.ep.company_id#"> 
	<input type="hidden" name="pid" id="pid" value="#url.pid#">
	<input type="hidden" name="alis_kdv" id="alis_kdv" value="#alis_kdv#">
	<input type="hidden" name="satis_kdv" id="satis_kdv" value="#satis_kdv#">
	<input type="hidden" name="product_name" id="product_name" value="#get_product.product_name#">
	</cfoutput>
	<cf_box_elements>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group" id="item-unit_id">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57636.Birim'></label>
			<div class="col col-8 col-md-8 col-xs-12">
				<select name="unit_id" id="unit_id" style="width:75px;">
					<cfoutput query="get_product_unit">
						<option value="#product_unit_id#" <cfif isdefined("product_main_unit") and product_main_unit eq add_unit>selected</cfif>>#add_unit#</option>
					</cfoutput>
				</select>
			</div>
			</div>
						<cfif isDefined("attributes.price_catid") and (attributes.price_catid neq -1) and  (attributes.price_catid neq -2)>
							<cfset attributes.pcat_id = attributes.price_catid>
							<cfinclude template="../query/get_price_cat_rows.cfm">
							<div class="form-group" id="item-start">
								<div class="input-group">
								<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58053.Baslangic Tarihi'> *</label>
							<div class="col col-4 col-md-4 col-xs-12">
								<cfinput type="text" name="startdate" value="" maxlength="10" style="width:65px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"> 	</span>
								</div>
							</div>
							<div class="col col-2 col-md-2 col-xs-12">
														
							<cfif hour(get_price_Cat.startdate)>
							<cf_wrkTimeFormat name="start_clock" value="#hour(get_price_Cat.startdate)#">
							<cfelse>
							<cf_wrkTimeFormat name="start_clock" value="">
							</cfif>
						</div><div class="col col-2 col-md-2 col-xs-12">
							<select name="start_min" id="start_min" style="width:40px;">
								<option value="00" <cfif minute(get_price_Cat.startdate) eq 0> selected</cfif>>00</option>
								<option value="05" <cfif minute(get_price_Cat.startdate) eq 5> selected</cfif>>05</option>
								<option value="10" <cfif minute(get_price_Cat.startdate) eq 10> selected</cfif>>10</option>
								<option value="15" <cfif minute(get_price_Cat.startdate) eq 15> selected</cfif>>15</option>
								<option value="20" <cfif minute(get_price_Cat.startdate) eq 20> selected</cfif>>20</option>
								<option value="25" <cfif minute(get_price_Cat.startdate) eq 25> selected</cfif>>25</option>
								<option value="30" <cfif minute(get_price_Cat.startdate) eq 30> selected</cfif>>30</option>
								<option value="35" <cfif minute(get_price_Cat.startdate) eq 35> selected</cfif>>35</option>
								<option value="40" <cfif minute(get_price_Cat.startdate) eq 40> selected</cfif>>40</option>
								<option value="45" <cfif minute(get_price_Cat.startdate) eq 45> selected</cfif>>45</option>
								<option value="50" <cfif minute(get_price_Cat.startdate) eq 50> selected</cfif>>50</option>
								<option value="55" <cfif minute(get_price_Cat.startdate) eq 55> selected</cfif>>55</option>
							</select>
						<cfelse>
							<div class="form-group" id="item-start">
								<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58053.Baslangic Tarihi'> *</label>
							<div class="col col-4 col-md-4 col-xs-12">
								<div class="input-group">
								<cfinput type="text" name="startdate" maxlength="10" style="width:65px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
								</div>
							</div>
							<div class="col col-2 col-md-2 col-xs-12">
								<cf_wrkTimeFormat name="start_clock" value="0">
								
							</div><div class="col col-2 col-md-2 col-xs-12">
								<select name="start_min" id="start_min" style="width:40px;">
									<option value="00" selected>00</option>
									<option value="05">05</option>
									<option value="10">10</option>
									<option value="15">15</option>
									<option value="20">20</option>
									<option value="25">25</option>
									<option value="30">30</option>
									<option value="35">35</option>
									<option value="40">40</option>
									<option value="45">45</option>
									<option value="50">50</option>
									<option value="55">55</option>
								</select>
							</div>
							</div>
						</cfif>
						<div class="form-group" id="item-process">
							<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58859.süreç'><!--- surec var ancak burda sureci kaydetmiyoruz hic bir yere sadece surec dosyalari ile diger sirketlere v.s. fiyat kopyalama gibi islemler icin kullanilacak --->
							</label>
						<div class="col col-8 col-md-8 col-xs-12">
							<cf_workcube_process 
							is_upd='0' 
							process_cat_width='130' 
							is_detail='0'>
						</div>
					</div>
				
						<cfif (isdefined('x_stock_based_price') and x_stock_based_price eq 1) or (isdefined('x_spec_based_price') and x_spec_based_price eq 1)><!--- stok ve spec bazında fiyat tanımlama yapılabiliyorsa , xml e baglı --->
							<div class="form-group" id="item-process">
								<label class="col col-4 col-md-4 col-xs-12">
									<cf_get_lang dictionary_id='57452.Stok'>
								</label>
							<div class="col col-8 col-md-8 col-xs-12">
								<div class="input-group">
								<input type="hidden" name="stock_id_" id="stock_id_" value="<cfif isdefined('attributes.stock_id_') and len(attributes.stock_id_) and isdefined('attributes.product_name_') and len(attributes.product_name_)><cfoutput>#attributes.stock_id_#</cfoutput></cfif>">
								<input type="text"   name="product_name_" id="product_name_" style="width:120px;" value="<cfif isdefined('attributes.stock_id_') and len(attributes.stock_id_) and isdefined('attributes.product_name_') and len(attributes.product_name_)><cfoutput>#attributes.product_name_#</cfoutput></cfif>" onFocus="AutoComplete_Create('product_name_','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id_,stock_id_','','3','225');" autocomplete="off">
								<span href="javascript://" class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=price.product_id_&field_id=price.stock_id_&field_name=price.product_name_<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.price.product_name.value),'list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>
								<input type="hidden" name="product_id_" id="product_id_" value="<cfif isdefined('attributes.pid') and len(attributes.pid)><cfoutput>#attributes.pid#</cfoutput></cfif>">
							</div>
						</div>
					</div>
						</cfif>
						<cfif isdefined('x_spec_based_price') and x_spec_based_price eq 1><!--- spec bazında fiyat tanımlama yapılabiliyorsa, xml e baglı --->
							<div class="form-group" id="item-process">
								<label class="col col-4 col-md-4 col-xs-12">
									<cf_get_lang dictionary_id="57647.Spec">
								</label>
							<div class="col col-8 col-md-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfif isdefined('attributes.spect_main_id') and len(attributes.spect_main_id) and isdefined('attributes.spect_name') and len(attributes.spect_name)><cfoutput>#attributes.spect_main_id#</cfoutput></cfif>">
									<input type="text" name="spect_name" id="spect_name" style="width:120px;" value="<cfif isdefined('attributes.spect_main_id') and len(attributes.spect_main_id) and isdefined('attributes.spect_name') and len(attributes.spect_name)><cfoutput>#attributes.spect_name#</cfoutput></cfif>">
									<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="stock_control();"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>
								</div>
							</div>
						</div>
						</cfif>
				
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<cfoutput>
					<div class="form-group" id="item-Standart">
						<label class="col col-4 col-md-4 col-xs-12">
							<cf_get_lang dictionary_id='58722.Standart Alış'>
						</label>
						<div class="col col-8 col-md-8 col-xs-12">
							: #TLFormat(get_price_sa.price,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#get_price_sa.money#
						</div>
					</div>
					<div class="form-group" id="item-Maliyet">
						<label class="col col-4 col-md-4 col-xs-12">
							<cf_get_lang dictionary_id='37358.Net Maliyet'>
						</label>
						<div class="col col-8 col-md-8 col-xs-12">
							: #TLFormat(indirimli_alis_fiyat,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#get_price_sa.money#
						</div>
					</div>
					<div class="form-group" id="item-kdvli_netmaliyet">
						<label class="col col-4 col-md-4 col-xs-12">
							<cf_get_lang dictionary_id='37411.KDV li Net Maliyet'>
						</label>
						<div class="col col-8 col-md-8 col-xs-12">
							: 
							 <cfset kdvli_netmaliyet = ((indirimli_alis_fiyat * alis_kdv) / 100) + indirimli_alis_fiyat>
							 #TLFormat(kdvli_netmaliyet,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#get_price_sa.money#&nbsp;&nbsp;&nbsp;
						</div>
					</div>
					<div class="form-group" id="item-Sabit">
						<label class="col col-4 col-md-4 col-xs-12">
						Min - Max Marj
						</label>
						<div class="col col-8 col-md-8 col-xs-12">
							: #TLFormat(get_product.min_margin)# - #TLFormat(get_product.max_margin)#
						</div>
					</div>
				<cfif toplam_diger_maliyet> 
							<div class="form-group" id="item-Sabit">
								<label class="col col-4 col-md-4 col-xs-12">
								<cf_get_lang dictionary_id='37511.Sabit Maliyet'>
								</label>
								<div class="col col-8 col-md-8 col-xs-12">
									: #tlformat(toplam_diger_maliyet,session.ep.our_company_info.purchase_price_round_num)#
									<input type="hidden" name="standart_p_price_cost" id="standart_p_price_cost" value="#wrk_round(toplam_diger_maliyet,session.ep.our_company_info.purchase_price_round_num)#">
								</div>
							</div>
							<div class="form-group" id="item-Sabit">
								<label class="col col-4 col-md-4 col-xs-12">
									<cf_get_lang dictionary_id='58258.Maliyet'>
								</label>
								<div class="col col-8 col-md-8 col-xs-12">
									
									<input type="text" class="moneybox" name="standart_p_price_net" id="standart_p_price_net" value="#tlformat(standart_maliyet,session.ep.our_company_info.purchase_price_round_num)#" style="width:130px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" onBlur="return calc_p_price();">&nbsp;
								</div>
							</div>
							<div class="form-group" id="item-Sabit">
								<label class="col col-4 col-md-4 col-xs-12">
									<cf_get_lang dictionary_id='37511.Sabit Maliyet'>
								</label>
								<div class="col col-8 col-md-8 col-xs-12">
									: #tlformat(standart_maliyet,session.ep.our_company_info.purchase_price_round_num)#
								</div>
							</div>
							<div class="form-group" id="item-Sabit">
								<label class="col col-4 col-md-4 col-xs-12">
									<cf_get_lang dictionary_id='37654.İndirimli Standart Maliyet'>
								</label>
								<div class="col col-8 col-md-8 col-xs-12">
									:
							  #tlformat(indirimli_standart_maliyet,session.ep.our_company_info.purchase_price_round_num)# #get_price_sa.money#
								</div>
							</div>
					
							   <!---  S.M. olarak kısaltılmıştı  --->
						<cfelse>
					<input type="hidden" name="standart_p_price_cost" id="standart_p_price_cost" value="0">
					<input type="hidden" name="standart_p_price_net" id="standart_p_price_net" value="0">
				 </cfif>
				 </cfoutput>
		</div>
	</cf_box_elements>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="15"><input type="checkbox" name="herkes" id="herkes" value="1" onClick="check_all(this.checked);"></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id='37028.Fiyat Listeleri'> </th>					
					<th width="110" nowrap="nowrap"><cf_get_lang dictionary_id='37348.Mevcut Fiyat'></th>
					<th width="110" nowrap="nowrap"><cf_get_lang dictionary_id='37365.KDV Dahil'><cf_get_lang dictionary_id='37348.Mevcut Fiyat'></th>
					<th width="35"><cf_get_lang dictionary_id ='37045.Marj'> (%)</th>
					<th width="35"><cf_get_lang dictionary_id ='37843.Kategori Marjı'>&nbsp;(%)</th>
					<th width="35" align="center"><cf_get_lang dictionary_id='37365.KDV Dahil'></th>
					<th width="150"><cf_get_lang dictionary_id='37306.Yeni Fiyat'></th>
				</tr>
			</thead>
			<tbody>
				<cfset pricecatid = -1>
				<cfinclude template="../query/get_product_prices.cfm">
				<cfoutput>
				<tr>
				</cfoutput>
					<td width="15"><input name="price_cat_list" id="price_cat_list" <cfif isDefined("attributes.price_catid") and attributes.price_catid eq -1> checked</cfif> type="checkbox" value="-1"></td>
					<td><cf_get_lang dictionary_id='58722.Standart Alış'></td>	
					<td><cfoutput query="get_product_prices">#TLFormat(price,session.ep.our_company_info.purchase_price_round_num)# #money# - #add_unit#<cfif currentrow neq get_product_prices.RecordCount><br/></cfif></cfoutput></td>
					<td><cfoutput query="get_product_prices"><cfif is_kdv is 0>#TLFormat(wrk_round(PRICE*(1+(alis_kdv/100)),session.ep.our_company_info.purchase_price_round_num),session.ep.our_company_info.purchase_price_round_num)#<cfelseif is_kdv is 1>#TLFormat(price_kdv,session.ep.our_company_info.purchase_price_round_num)#</cfif> #money# -#add_unit#<cfif currentrow neq get_product_prices.RecordCount><br/></cfif></cfoutput></td>
					<td>-</td>
					<td>-</td>
					<td align="center"><input type="checkbox" name="is_kdv_minus_1" id="is_kdv_minus_1" value="-1"></td>
					<td nowrap="nowrap">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='37347.Yeni Fiyat girmelisiniz'></cfsavecontent>
						<cfinput type="text" class="moneybox" name="price_minus_1" message="#message#" validate="float" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" onBlur="st_p_price_changed();" style="width:110px;">
						<select name="money_minus_1" id="money_minus_1" style="width:50px;" onBlur="st_p_price_changed();">
						<cfoutput query="get_money">
							<option value="#get_money.money#" <cfif get_product_prices.money eq get_money.money> selected</cfif>>#get_money.money#</option>
						</cfoutput>
						</select>
					</td>                  
				</tr>
				<cfset pricecatid = -2>
				<cfinclude template="../query/get_product_prices.cfm">
					<cfoutput><tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row"></cfoutput>
					<td width="15"><input name="price_cat_list"  id="price_cat_list" <cfif isDefined("attributes.price_catid") and attributes.price_catid eq -2>checked</cfif> type="checkbox" value="-2"></td>                      
					<td><cf_get_lang dictionary_id='58721.Standart Satış'></td>
					<td><cfoutput query="get_product_prices">#TLFormat(price,session.ep.our_company_info.sales_price_round_num)# #money# - #add_unit#<cfif currentrow neq get_product_prices.RecordCount><br/></cfif></cfoutput></td>
					<td><cfoutput query="get_product_prices"><cfif is_kdv is 0>#TLFormat(wrk_round(price*(1+(alis_kdv/100)),session.ep.our_company_info.sales_price_round_num),session.ep.our_company_info.sales_price_round_num)#<cfelseif is_kdv is 1>#TLFormat(price_kdv,session.ep.our_company_info.sales_price_round_num)#</cfif>  #money# - #add_unit#<cfif currentrow neq get_product_prices.RecordCount><br/></cfif></cfoutput></td>
					<td align="right" style="text-align:right;">
						<cfset ind_oran_minus_2=0>
						<cfoutput query="get_product_prices">
							<cfif product_main_unit is add_unit and indirimli_alis_fiyat>
								<cfquery name="GET_SALE_CURRENCY" datasource="#dsn#">
									SELECT DISTINCT RATE2 FROM MONEY_HISTORY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_PRODUCT_PRICES.MONEY#"> AND VALIDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCDateTime(dateFormat(GET_PRODUCT_PRICES.RECORD_DATE))#">
								</cfquery>
								<cfif GET_SALE_CURRENCY.recordcount>
									<cfset satis_fiyat = GET_PRODUCT_PRICES.PRICE*GET_SALE_CURRENCY.RATE2>
								<cfelse>
									<cfset satis_fiyat = GET_PRODUCT_PRICES.PRICE>
								</cfif>
								<cfquery name="GET_PURCHASE_CURRENCY" datasource="#dsn#">
									SELECT DISTINCT RATE2 FROM MONEY_HISTORY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_PRICE_SA.MONEY#"> AND VALIDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCDateTime(dateFormat(GET_PRODUCT_PRICES.RECORD_DATE))#">
								</cfquery>
								<cfif GET_PURCHASE_CURRENCY.recordcount>
									<cfset indirimli_alis_fiyat = indirimli_alis_fiyat*GET_PURCHASE_CURRENCY.RATE2>
								</cfif>
								<cfset ind_oran_minus_2 = wrk_round(((satis_fiyat-indirimli_alis_fiyat)/indirimli_alis_fiyat)*100,session.ep.our_company_info.sales_price_round_num)>
							</cfif>
						</cfoutput>
						<cfoutput>#tlformat(ind_oran_minus_2)#</cfoutput>
					</td>
					<td align="center">
						<cfset ind_oran_minus_2=product_cat_profit_margin>
						<cfinput type="text" value="#tlformat(ind_oran_minus_2)#" name="margin" class="moneybox" message="Marjda hata var !" validate="float" onBlur="hesapla_fiyat(#pricecatid#,3);" onkeyup="return(FormatCurrency(this,event));" style="width:35px;">
					</td>
					<td align="center"><input type="checkbox" name="is_kdv_minus_2" id="is_kdv_minus_2" value="-2" onClick="check_all_ss(this.checked);" <cfif session.ep.OUR_COMPANY_INFO.WORKCUBE_SECTOR is 'per'>checked</cfif>></td>
					<td nowrap="nowrap">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='37347.Yeni Fiyat girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="price_minus_2" style="width:110px;" class="moneybox" message="#message#" validate="float" onBlur="hesapla_fiyat(#pricecatid#,4);" onkeyup="if (FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#)) return true; else {updOtherLists(); return false;}">
						<select name="money_minus_2" id="money_minus_2" style="width:50px;" onBlur="updOtherLists();">
							<cfoutput query="get_money">
								<option value="#get_money.money#"<cfif get_product_prices.money eq get_money.money> selected</cfif>>#get_money.money#</option>
							</cfoutput>
						</select>
					</td>                      
					</tr>
				<cfoutput query="get_price_cat">
					<cfset pricecatid = price_catid>
					<cfset productmainunit = product_main_unit>
					<cfinclude template="../query/get_product_prices.cfm">
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td width="15"><input name="price_cat_list" id="price_cat_list" <cfif isDefined("attributes.price_catid") and attributes.price_catid eq price_catid>checked</cfif> type="checkbox" value="#price_catid#"></td>
					<td>#price_cat#</td>
					<td><cfloop query="get_product_prices">#TLFormat(price,session.ep.our_company_info.sales_price_round_num)# #money# - #add_unit#<cfif currentrow neq get_product_prices.RecordCount><br/></cfif></cfloop></td>
					<td><cfloop query="get_product_prices"><cfif is_kdv is 0>#TLFormat(wrk_round(price*(1+(alis_kdv/100)),session.ep.our_company_info.sales_price_round_num),session.ep.our_company_info.sales_price_round_num)#<cfelseif is_kdv is 1>#TLFormat(price_kdv,session.ep.our_company_info.sales_price_round_num)#</cfif> #money# - #add_unit#<cfif currentrow neq get_product_prices.RecordCount><br/></cfif></cfloop></td>
					<td align="right" style="text-align:right;">
						<cfset ind_oran=0>
						<cfloop query="get_product_prices">
							<cfif productmainunit is add_unit and indirimli_alis_fiyat>
								<cfquery name="GET_SALE_CURRENCY" datasource="#dsn#">
									SELECT DISTINCT RATE2 FROM MONEY_HISTORY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_PRODUCT_PRICES.MONEY#"> AND VALIDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCDateTime(dateFormat(GET_PRODUCT_PRICES.RECORD_DATE))#">
								</cfquery>
								<cfif GET_SALE_CURRENCY.recordcount>
									<cfset satis_fiyat = GET_PRODUCT_PRICES.PRICE*GET_SALE_CURRENCY.RATE2>
								<cfelse>
									<cfset satis_fiyat = GET_PRODUCT_PRICES.PRICE>
								</cfif>
								<cfquery name="GET_PURCHASE_CURRENCY" datasource="#dsn#">
									SELECT DISTINCT RATE2 FROM MONEY_HISTORY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_PRICE_SA.MONEY#"> AND VALIDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCDateTime(dateFormat(GET_PRODUCT_PRICES.RECORD_DATE))#">
								</cfquery>
								<cfif GET_PURCHASE_CURRENCY.recordcount>
									<cfset indirimli_alis_fiyat = indirimli_alis_fiyat*GET_PURCHASE_CURRENCY.RATE2>
								</cfif>
								<cfset ind_oran = wrk_round(((satis_fiyat-indirimli_alis_fiyat)/indirimli_alis_fiyat)*100,session.ep.our_company_info.sales_price_round_num)>
							</cfif>
						</cfloop>
						#tlformat(ind_oran)#
					</td>
					<td align="center">	
						<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='37844.Marjda hata var'></cfsavecontent>		
						<cfinput type="text" value="" name="margin_#price_catid#" style="width:35px;" class="moneybox" message="#alert#" validate="float" onBlur="hesapla_fiyat(#price_catid#,1);" onkeyup="return(FormatCurrency(this,event));">	
					</td>
					<td align="center"><input type="checkbox" name="is_kdv_#price_catid#" id="is_kdv_#price_catid#" value="#price_catid#" <cfif session.ep.OUR_COMPANY_INFO.WORKCUBE_SECTOR is 'per'>checked</cfif>></td>
					<td nowrap="nowrap">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='37347.Yeni Fiyat girmelisiniz'></cfsavecontent>
						<cfinput type="text" class="moneybox" name="price_#price_catid#" style="width:110px;" message="#message#" validate="float" onBlur="hesapla_fiyat(#price_catid#,2);" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));">
						<select name="money_#price_catid#" id="money_#price_catid#" style="width:50px;">
						<cfloop query="get_money">
							<option value="#get_money.money#" <cfif session.ep.money eq get_money.money> selected</cfif>>#get_money.money#</option>
						</cfloop>
						</select>
					</td>                      	
				</tr>
			</tbody>
				</cfoutput>
		</cf_grid_list>
		<cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function='unformat_fields()'>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	function stock_control(){/*Ürün seçmeden spec seçemesin.*/
		if(document.getElementById('stock_id_').value=="" || document.getElementById('product_name_').value == "" ){
			alert("<cf_get_lang dictionary_id ='37923.Spect Seçmek için Önce ürün seçmeniz gerekmektedir'>");
			return false;
		}
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=price.spect_main_id&field_name=price.spect_name&is_display=1&stock_id='+document.getElementById('stock_id_').value,'list');
	}
	function calc_p_price()
	{
		var t1 = parseFloat(filterNum(price.standart_p_price_net.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));
		if (isNaN(t1)) {t1 = 0; price.standart_p_price_net.value = 0;}
		var t2 = parseFloat(price.standart_p_price_cost.value);
		if (isNaN(t2)) {t2 = 0; price.standart_p_price_cost.value = 0;}
		st_alis_alani = t1 + t2;
		price.price_minus_1.value = commaSplit(st_alis_alani,4);
		<cfoutput>
		t1 = t1*(100-#indirim1#)/100;
		t1 = t1*(100-#indirim2#)/100;
		t1 = t1*(100-#indirim3#)/100;
		t1 = t1*(100-#indirim4#)/100;
		t1 = t1*(100-#indirim5#)/100;
		</cfoutput>
		if (isNaN(parseFloat(filterNum(price.margin.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)))) 
			price.margin.value = 0; 
		yeni_st_alis_alani = t1 + t2;
		
		if(price.is_kdv_minus_2.checked == true)
			st_satis_alani = yeni_st_alis_alani*(1+(price.satis_kdv.value/100));
		else
			st_satis_alani = yeni_st_alis_alani;

		st_satis_alani = st_satis_alani*(1+(parseFloat(filterNum(price.margin.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>))/100));
		price.price_minus_2.value = commaSplit(st_satis_alani,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);		
		
		updOtherLists();
		updOtherLists2();
	}
	function check_all(deger)
	{
		<cfif get_price_cat.recordcount gt 1>
			for(i=1; i<price.price_cat_list.length; i++)
				price.price_cat_list[i].checked = deger;
		<cfelseif get_price_cat.recordcount eq 1>
			price.price_cat_list.checked = deger;
		</cfif>
	}
	function check_all_ss(deger)
	{
		<cfoutput query="get_price_cat">
		price.is_kdv_#price_catid#.checked = deger;</cfoutput>
	}
	function unformat_fields()
	{
		if(process_cat_control()==false)
			return false;
		if(!CheckEurodate(price.startdate.value,"<cf_get_lang dictionary_id ='57655.Başlama Tarihi'>") || !price.startdate.value.length) 
		{
			alert("<cf_get_lang dictionary_id ='58745.Başlama Tarihi girmelisiniz'> !");
			return false;
		}
		<cfif isdefined('x_stock_based_price') and x_stock_based_price eq 1>
		var price_prod_id="<cfoutput>#attributes.pid#</cfoutput>";
		if(document.getElementById('product_id_').value != '' && document.getElementById('product_id_').value!=price_prod_id)
		{
			alert("<cf_get_lang dictionary_id='60463.Farklı Ürüne Ait Bir Stok Seçtiniz'>! <cf_get_lang dictionary_id='60464.Stok Seçiminizi Kontrol Ediniz'>");
			return false;
		}
		</cfif>
		if
		(
			document.price.price_cat_list[0].checked == false 
			&&
			document.price.price_cat_list[1].checked == false
		<cfif get_price_cat.recordcount gt 1>
			<cfoutput query="get_price_cat">
			&&
			document.price.price_cat_list[#currentrow+1#].checked == false</cfoutput>			
		<cfelseif get_price_cat.recordcount eq 1>
			&&
			document.price.price_cat_list.checked == false
		</cfif>
		)
		{
			window.alert("<cf_get_lang dictionary_id='37346.En az bir liste seçmelisiniz'>!");
			return false;		
		}
		
		if(document.price.price_cat_list[0].checked == true)
		{
			if(document.price.price_minus_1.value == 0 || document.price.price_minus_1.value == '')
			{
				window.alert("<cf_get_lang dictionary_id='37347.Seçili listeler için yeni fiyat girmelisiniz'> !");
				return false;
			}
		}
		price.price_minus_1.value = filterNum(price.price_minus_1.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);

		if(document.price.price_cat_list[1].checked == true)
		{
			if(document.price.price_minus_2.value == 0 || document.price.price_minus_2.value == '')
			{
				window.alert("<cf_get_lang dictionary_id='37347.Seçili listeler için yeni fiyat girmelisiniz'> !");
				return false;
			}
		}
		price.price_minus_2.value = filterNum(price.price_minus_2.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
		price.margin.value = filterNum(price.margin.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);

		<cfoutput query="get_price_cat">
		if(document.price.price_cat_list[#currentrow+1#].checked == true)
		{
			if(document.price.price_#price_catid#.value == 0 || document.price.price_#price_catid#.value == '')
			{
				window.alert("<cf_get_lang dictionary_id='37347.Seçili listeler için yeni fiyat girmelisiniz'> !");
				return false;
			}
		}
		price.price_#price_catid#.value = filterNum(price.price_#price_catid#.value,#session.ep.our_company_info.sales_price_round_num#);
		price.margin_#price_catid#.value = filterNum(price.margin_#price_catid#.value);
		</cfoutput>
		
		return true;
	}

	function updOtherLists()
	{	
		<cfoutput query="get_price_cat">
		price.price_#price_catid#.value = price.price_minus_2.value;
		price.money_#price_catid#.selectedIndex = price.money_minus_2.selectedIndex;
		</cfoutput>
	}
	function updOtherLists2()
	{	
		<cfoutput query="get_price_cat">
		price.margin_#price_catid#.value = price.margin.value;
		</cfoutput>
	}
	function hesapla_fiyat(k,deger)
	{
		kdvsiz_net_alis = parseFloat(<cfoutput>#indirimli_alis_fiyat#</cfoutput>,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		if(!kdvsiz_net_alis) kdvsiz_net_alis = 0; 
		kdv_orani = parseFloat(<cfoutput>#satis_kdv#</cfoutput>);

		if(!kdv_orani) kdv_orani = 0; 
		<!--- kdv_li_net_alis = wrk_round(parseFloat(kdvsiz_net_alis*(100+kdv_orani)/100),4); --->
		if(deger==1 || deger==2)
		{
			if(eval('price.is_kdv_'+k).checked == true)
				kdv_li_net_alis = wrk_round(parseFloat(kdvsiz_net_alis*(100+kdv_orani)/100,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			else
				kdv_li_net_alis = wrk_round(parseFloat(kdvsiz_net_alis,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			sales_price_with_tax = eval('price.price_'+k);
			margin_ = eval('price.margin_'+k);
		}
		else if(deger==3 || deger==4)
		{
			if(price.is_kdv_minus_2.checked == true)
				kdv_li_net_alis = wrk_round(parseFloat((kdvsiz_net_alis*(100+kdv_orani)/100),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			else
				kdv_li_net_alis = wrk_round(parseFloat(kdvsiz_net_alis,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			sales_price_with_tax = eval('price.price_minus_2');
			margin_ = eval('price.margin');
		}
		/*Alanlar F1'den geçirilerek Javascript'in anlayacağı hale getiriliyor*/
		sales_price_with_tax_value = parseFloat(filterNum(sales_price_with_tax.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));
		if(!sales_price_with_tax_value) {sales_price_with_tax_value = 0; sales_price_with_tax.value = 0;}
		margin_value = parseFloat(filterNum(margin_.value));
		if(!margin_value) {margin_value = 0; margin_.value = 0;} 
		/*Marj üzerinden KDV'li Satış Fiyatı Hesaplanıyor*/
		if(deger==1 || deger==3)
			sales_price_with_tax.value = commaSplit( wrk_round(kdv_li_net_alis*((100+margin_value)/100),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
		/*KDV'li Satış Fiyatı Üzerinden Marj Hesaplanlıyor*/
		if(deger==2 || deger==4)
		{
			if(isNaN(kdv_li_net_alis) || kdv_li_net_alis == 0)
				margin_.value = 0;
			else
				margin_.value = commaSplit( wrk_round((((sales_price_with_tax_value - kdv_li_net_alis) * 100) / kdv_li_net_alis)));
		}
		/*İlgili alanlarıda girilen değerlere göre düzeltme işlemi*/
		if(deger==3)
			{
				updOtherLists();
				updOtherLists2();
			}
		if(deger==4)
			updOtherLists2();
	}
	function st_p_price_changed()
	{
		if (isNaN(parseFloat(filterNum(price.price_minus_1.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)))) 
			price.price_minus_1.value = 0;
		else
		{
			<cfoutput>
			var t1 = parseFloat(filterNum(price.price_minus_1.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)) - #toplam_diger_maliyet#;
			t1 = t1*(100-#indirim1#)/100;
			t1 = t1*(100-#indirim2#)/100;
			t1 = t1*(100-#indirim3#)/100;
			t1 = t1*(100-#indirim4#)/100;
			t1 = t1*(100-#indirim5#)/100;
			yeni_st_alis_alani = t1 + #toplam_diger_maliyet#;
			</cfoutput>
			if(price.is_kdv_minus_2.checked == true)
				st_satis_alani = yeni_st_alis_alani*(1+(price.satis_kdv.value/100));
			else				
				st_satis_alani = yeni_st_alis_alani;
			if (isNaN(parseFloat(filterNum(price.margin.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)))) 
				price.margin.value = 0; 
			st_satis_alani = st_satis_alani*(1+(parseFloat(filterNum(price.margin.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>))/100));
			price.price_minus_2.value = commaSplit(st_satis_alani,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			
			price.money_minus_2.selectedIndex = price.money_minus_1.selectedIndex;		
			updOtherLists();
			updOtherLists2();		
		}
	}

	hesapla_fiyat(-2,3);
	<cfif GET_PRODUCT_COST.recordcount>
	calc_p_price();
	</cfif>
</script>
