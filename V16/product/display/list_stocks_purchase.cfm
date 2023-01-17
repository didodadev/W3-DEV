<cf_xml_page_edit>
<cfif isdefined("attributes.compid")>
	<cfset dsn3 = "#dsn#_#attributes.compid#">
</cfif>
<cfparam name="attributes.is_filter" default="0">
<cfparam name="attributes.product_cat" default=''>
<cfparam name="attributes.product_catid" default=''>
<cfparam name="attributes.search_company_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.modal_id" default="">
<cfif isdefined("attributes.price_cat")><cfset attributes.price_catid = attributes.price_cat></cfif>
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_product_cat_basket.cfm">
<cfif attributes.is_filter>
	<cfinclude template="../query/get_stocks_purchase.cfm">
	<cfif isdefined('attributes.add_product_cost')><!--- Maliyet çekilmek isteniyorsa. --->
		<cfquery name="get_product_cost_all" datasource="#dsn1#">
			SELECT  
				PRODUCT_ID,
				PURCHASE_NET_SYSTEM AS SISTEM_MALIYET,
				PURCHASE_EXTRA_COST_SYSTEM AS EK_MALIYET,
				PRODUCT_COST_ID
			FROM
				PRODUCT_COST	
			WHERE
				PRODUCT_COST_STATUS = 1
				ORDER BY START_DATE DESC,RECORD_DATE DESC
		</cfquery>
	</cfif>
<cfelse>
	<cfset PRODUCTS.recordcount = 0>
</cfif>
<cfquery name="get_money" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY
</cfquery>
<cfinclude template="../query/get_price_cats_basket.cfm">
<cfparam name="attributes.maxrows" default="#SESSION.EP.MAXROWS#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default=#products.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfoutput query="get_money">
	<cfset "rate2_#money#" = rate2>
</cfoutput>
<cfset url_str = "">
<cfif isdefined("module_name")>
	<cfset url_str = "#url_str#&module_name=#module_name#">
</cfif>
<cfif isdefined("attributes.add_product_cost")><!--- Maliyet atmak için --->
	<cfset url_str = "#url_str#&add_product_cost=#attributes.add_product_cost#">
</cfif>
<cfif isdefined("attributes.startdate")>
	<cfset url_str = "#url_str#&startdate=#attributes.startdate#">
</cfif>
<cfif isdefined("attributes.price_lists")>
	<cfset url_str = "#url_str#&price_lists=#attributes.price_lists#">
</cfif>
<cfif isdefined("attributes.compid")>
	<cfset url_str = "#url_str#&compid=#attributes.compid#">
</cfif>
<cfset attributes.startdate2 = attributes.startdate>
<cf_date tarih='attributes.startdate2'>
<!--- Harfler --->
<cfsavecontent variable="message"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfoutput>                
	<cf_flat_list>
		<tr>
			<td>
				<td><a onclick="harf_gonder('A');">A</a></td>
				<td><a onclick="harf_gonder('B');">B</a></td>
				<td><a onclick="harf_gonder('C');">C</a></td>
				<td><a onclick="harf_gonder('D');">D</a></td>
				<td><a onclick="harf_gonder('E');">E</a></td>
				<td><a onclick="harf_gonder('F');">F</a></td>
				<td><a onclick="harf_gonder('G');">G</a></td>
				<td><a onclick="harf_gonder('H');">H</a></td>
				<td><a onclick="harf_gonder('I');">I</a></td>
				<td><a onclick="harf_gonder('İ');">İ</a></td>
				<td><a onclick="harf_gonder('J');">J</a></td>
				<td><a onclick="harf_gonder('K');">K</a></td>
				<td><a onclick="harf_gonder('L');">L</a></td>
				<td><a onclick="harf_gonder('M');">M</a></td>
				<td><a onclick="harf_gonder('N');">N</a></td>
				<td><a onclick="harf_gonder('O');">O</a></td>
				<td><a onclick="harf_gonder('P');">P</a></td>
				<td><a onclick="harf_gonder('Q');">Q</a></td>
				<td><a onclick="harf_gonder('R');">R</a></td>
				<td><a onclick="harf_gonder('S');">S</a></td>
				<td><a onclick="harf_gonder('Ş');">Ş</a></td>
				<td><a onclick="harf_gonder('T');">T</a></td>
				<td><a onclick="harf_gonder('U');">U</a></td>
				<td><a onclick="harf_gonder('Ü');">Ü</a></td>
				<td><a onclick="harf_gonder('V');">V</a></td>
				<td><a onclick="harf_gonder('W');">W</a></td>
				<td><a onclick="harf_gonder('X');">X</a></td>
				<td><a onclick="harf_gonder('Y');">Y</a></td>
				<td><a onclick="harf_gonder('Z');">Z</a></td>
			</td>
		</tr>
	</cf_flat_list>     
</cfoutput> 
<cfform name="price_cat" action="#request.self#?fuseaction=product.popup_stocks#url_str#&var_=#attributes.var_#" method="post">
	<cf_box_search>
		<div class="form-group">
			<cfinput type="text" placeholder="#getlang('','settings','57460')#" name="keyword" maxlength="50" value="#attributes.keyword#" style="width:100px;"></td>
		</div><div class="form-group">
			<cfif isdefined("is_show_pricecat") and is_show_pricecat eq 1>
							<select name="price_catid" id="price_catid" style="width:180px;">
								<option value=""><cf_get_lang dictionary_id='58964.Fiyat Listesi'></option>
								<option value="-1" <cfif isdefined("attributes.price_catid") and attributes.price_catid eq -1>selected</cfif>><cf_get_lang dictionary_id='58722.Standart Alış'></option>
								<option value="-2" <cfif isdefined("attributes.price_catid") and attributes.price_catid eq -2>selected</cfif>><cf_get_lang dictionary_id='58721.Standart Satış'></option>
								<cfoutput query="price_cats">
									<option value="#price_catid#" <cfif isdefined("attributes.price_catid") and attributes.price_catid eq price_catid>selected</cfif>>#price_cat#</option>
								</cfoutput>
							</select>
					</cfif>
				 </div><div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</div><div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="input_control()">
					</div>
		</cf_box_search>
		<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('price_cat' , #attributes.modal_id#)"),DE(""))#">
			<input type="hidden" name="is_filter" id="is_filter" value="1">
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<div class="input-group">
					<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
					<input type="text" placeholder="<cfoutput>#getlang('','settings','57544')#</cfoutput>" name="employee" id="employee" style="width:120px;" value="<cfif len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)><cfoutput>#get_emp_info(attributes.employee_id,1,0)#</cfoutput></cfif>" maxlength="255">
					<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=price_cat.employee_id&field_name=price_cat.employee&select_list=1','list');">
					</span>
				</div></div>
			</div>
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<div class="input-group">
					<input type="hidden" name="search_company_id" id="search_company_id" value="<cfoutput>#attributes.search_company_id#</cfoutput>">
						<input type="text" placeholder="<cfoutput>#getlang('','Tedarikçi','29533')#</cfoutput>" name="search_company" id="search_company" style="width:120px;" value="<cfif len(attributes.search_company_id) and isdefined("attributes.search_company") and len(attributes.search_company)><cfoutput>#get_par_info(attributes.search_company_id,1,1,0)#</cfoutput></cfif>">
						<span  class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=price_cat.search_company&field_comp_id=price_cat.search_company_id&select_list=2','list');">
					</span>
				</div></div>
			</div>
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<div class="input-group">
					<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
						<input type="text" placeholder="<cfoutput>#getlang('','Kategori','57486')#</cfoutput>" name="product_cat" id="product_cat" value="<cfoutput>#attributes.product_cat#</cfoutput>" style="width:120px;" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_catid','','3','200');">
						<span class="input-group-addon icon-ellipsis" title="<cf_get_lang dictionary_id ='58730.Ürün Kategorisi Seç'> !" href="javascript://"onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=price_cat.product_catid&field_name=price_cat.product_cat&keyword='+encodeURIComponent(document.price_cat.product_cat.value)</cfoutput>);">
						</span>
					</div></div>
			</div>
		
		</cf_box_search_detail>
</cfform>
<cf_grid_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
			<th><cf_get_lang dictionary_id='57633.Barkod'></th>
			<th><cf_get_lang dictionary_id='57657.Ürün'></th>
			<th width="130"><cf_get_lang dictionary_id='57634.Üretici Kodu'></th>
			<th width="120" style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'></th>
		<th width="15"><a title="<cf_get_lang dictionary_id="57464.Güncelle">"><i class="fa fa-pencil"></i></th>
		</tr>
	</thead>
	<tbody>
		<cfif products.recordcount>
		<cfoutput query="products" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
			<cfquery name="get_product_cost" dbtype="query" maxrows="1"><!--- Maliyetler geliyor. --->
				SELECT * FROM get_product_cost_all WHERE PRODUCT_ID = #products.product_id# ORDER BY PRODUCT_COST_ID DESC
			</cfquery>
			<cfquery  name="get_discount_pur" datasource="#DSN3#" maxrows="1">
				SELECT
					*
				FROM
					CONTRACT_PURCHASE_PROD_DISCOUNT
				WHERE
					PRODUCT_ID = #product_id#
				ORDER BY
					START_DATE DESC
			</cfquery>
            <cfif (session.ep.period_year lt 2009 and products.money is 'TL') or (session.ep.period_year gte 2009 and products.money is 'YTL')>
				<cfset str_money=session.ep.money>
            <cfelse>
                <cfset str_money=products.money>
            </cfif>
			<cfloop query="moneys">
				<cfif str_money eq moneys.money>
					<cfset row_money =  str_money>
					<cfset row_money_rate1 = moneys.rate1>
					<cfset row_money_rate2 = moneys.rate2>
				</cfif>
			</cfloop>
			<cfquery  name="get_prices" datasource="#DSN3#">
			SELECT  
				PRICE_STANDART.PRICE,
				PRICE_STANDART.MONEY,
				PRICE_STANDART.PURCHASESALES		
			FROM
				PRODUCT,
				PRICE_STANDART,
				PRODUCT_UNIT
			WHERE
				PRODUCT.IS_SALES = 1 AND
				PRODUCT_UNIT.PRODUCT_UNIT_ID = #products.product_unit_id# AND	
				PRODUCT.PRODUCT_STATUS = 1 AND		
				PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
				PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
				PRICE_STANDART.PRICESTANDART_STATUS = 1 AND 
				PRICE_STANDART.PRODUCT_ID = #PRODUCT_ID# AND 
				PRICE_STANDART.PRICESTANDART_STATUS = 1	AND
				PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
			</cfquery>			
			<cfquery  name="get_product_company_id" datasource="#DSN3#">
				SELECT
					COMPANY_ID
				FROM
					PRODUCT
				WHERE
					PRODUCT_ID = #PRODUCT_ID# AND
					PRODUCT.COMPANY_ID IS NOT NULL
			</cfquery>
			<cfquery  name="get_price_cat_branches" datasource="#DSN3#">
				SELECT
					BRANCH
				FROM
					PRICE_CAT
				<cfif attributes.price_lists neq "">
				WHERE
					PRICE_CATID IN (#attributes.price_lists#)
				</cfif>
			</cfquery>
			<cfset price_branch_ids = ListDeleteDuplicates(ValueList(get_price_cat_branches.BRANCH))>
			<cfif isdefined("attributes.startdate")>
				<cfquery  name="get_contract_general_discounts" datasource="#DSN3#" maxrows="5">
					SELECT
						CPGD.*
					FROM
						CONTRACT_PURCHASE_GENERAL_DISCOUNT AS CPGD,
						CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES AS CPGDB
					WHERE
						CPGD.GENERAL_DISCOUNT_ID = CPGDB.GENERAL_DISCOUNT_ID AND
						CPGD.COMPANY_ID = #iif(isNumeric(get_product_company_id.COMPANY_ID),get_product_company_id.COMPANY_ID,-1000)# AND
						CPGD.START_DATE <= #attributes.startdate2# AND CPGD.FINISH_DATE >= #attributes.startdate2# 
						<cfif len(price_branch_ids)>AND CPGDB.BRANCH_ID IN (#price_branch_ids#)</cfif> 
				</cfquery>
				<cfif get_contract_general_discounts.RecordCount>
					<cfloop query="get_contract_general_discounts">
						<cfset 'indirim#5+get_contract_general_discounts.currentrow#' = get_contract_general_discounts.DISCOUNT>
					</cfloop>
					<cfif get_contract_general_discounts.RecordCount lt 5>
						<cfloop from="#10-5+get_contract_general_discounts.RecordCount+1#" to="10" index="indirim_kalan">
							<cfset 'indirim#indirim_kalan#' = 0>
						</cfloop>
					</cfif>
				<cfelse>
					<cfloop from="6" to="10" index="indirim_index">
						<cfset 'indirim#indirim_index#' = 0>
					</cfloop>
				</cfif>
			</cfif>
			<form name="product#currentrow#" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_session2module#url_str#&var_=#attributes.var_#">
				<input type="Hidden" name="product_id" id="product_id" value="#product_id#">
				<input type="Hidden" name="account_code" id="account_code" value="">
				<input type="Hidden" name="amount" id="amount" value="1">
				<input type="Hidden" name="product_name" id="product_name" value="#product_name#"><!--- #&nbsp;#property# --->
				<input type="Hidden" name="tax" id="tax" value="#tax#">
				<input type="Hidden" name="tax_purchase" id="tax_purchase" value="#tax_purchase#">
				<input type="Hidden" name="unit" id="unit" value="#products.add_unit#">
				<input type="Hidden" name="unit_id" id="unit_id" value="#products.product_unit_id#">
				<input type="Hidden" name="POPUP_DELIVERY_DATENO" id="POPUP_DELIVERY_DATENO" value="#get_discount_pur.DELIVERY_DATENO#">
				<input type="hidden" name="is_serial_no" id="is_serial_no" value="#IS_SERIAL_NO#">				
				<input type="hidden" name="disc_ount" id="disc_ount" value="<cfif len(get_discount_pur.DISCOUNT1) >#get_discount_pur.DISCOUNT1#<cfelse>0</cfif>">
				<input type="hidden" name="disc_ount2_" id="disc_ount2_" value="<cfif len(get_discount_pur.DISCOUNT2) >#get_discount_pur.DISCOUNT2#<cfelse>0</cfif>">
				<input type="hidden" name="disc_ount3_" id="disc_ount3_" value="<cfif len(get_discount_pur.DISCOUNT3) >#get_discount_pur.DISCOUNT3#<cfelse>0</cfif>">
				<input type="hidden" name="disc_ount4_" id="disc_ount4_" value="<cfif len(get_discount_pur.DISCOUNT4) >#get_discount_pur.DISCOUNT4#<cfelse>0</cfif>">
				<input type="hidden" name="disc_ount5_" id="disc_ount5_" value="<cfif len(get_discount_pur.DISCOUNT5) >#get_discount_pur.DISCOUNT5#<cfelse>0</cfif>">
				<input type="hidden" name="delivery_dateno" id="delivery_dateno" value="<cfif len(get_discount_pur.DELIVERY_DATENO)>#get_discount_pur.DELIVERY_DATENO#<cfelse>0</cfif>">				
				<cfif isdefined("attributes.is_action")>
                    <input type="hidden" name="is_action" id="is_action" value="1">
                </cfif>
				<cfquery dbtype="query" name="get_p_price">SELECT PRICE FROM get_prices WHERE PURCHASESALES = 0</cfquery>
				<cfquery dbtype="query" name="get_s_price">SELECT PRICE FROM get_prices WHERE PURCHASESALES = 1</cfquery>
				<input type="Hidden" name="p_price" id="p_price" value="#iif(IsNumeric(get_p_price.PRICE),get_p_price.PRICE,0)#">
				<input type="Hidden" name="s_price" id="s_price" value="#iif(IsNumeric(get_s_price.PRICE),get_s_price.PRICE,0)#">
			<tr height="20" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">           
				<td>#products.STOCK_CODE#</td>
				<td>#products.BARCOD#</td>
				<cfscript>
					product_price = products.price;
					temp_prod_property=replace(PROPERTY,'"','','all');
					temp_prod_property=replace(temp_prod_property,"'","","all");
					temp_prod_property=replace(temp_prod_property,";","","all");
					temp_prod_name=replace(product_name,'"','','all');
					temp_prod_name=replace(temp_prod_name,"'","","all");
					temp_prod_name=replace(temp_prod_name,";","","all");
					if ((session.ep.period_year gt "2008") and (money eq 'YTL'))
						temp_money = 'TL';
					else
						temp_money = money;
					new_price = price * evaluate("rate2_#temp_money#");
						if(isDefined("attributes.price_catid_ref") and attributes.price_catid_ref gt 0){
							get_ref_prices = queryExecute(
							"SELECT PRICE, MONEY FROM workcube_dev_1.PRICE WHERE STOCK_ID = #STOCK_ID# AND PRICE_CATID = #attributes.price_catid_ref#",{},
							{datasource = "#DSN3#"} 
							);		

							if(len(get_ref_prices.price)){
								product_price = get_ref_prices.price;
								new_price = get_ref_prices.price * evaluate("rate2_#get_ref_prices.money#");
							}
						}
				</cfscript>
				<td><a href="javascript://" data-id="prod-rows" onclick="<cfif not isdefined("attributes.draggable")>opener.</cfif>add_row(#STOCK_ID#,'#temp_prod_property#','#currentrow#','#product_id#','#temp_prod_name#','#STOCK_CODE#','#PROPERTY#', '#MANUFACT_CODE#', '#iif(len(tax),tax,0)#','#iif(len(tax_purchase),tax_purchase,0)#','#products.add_unit#','#products.product_unit_id#','#products.money#','#IS_SERIAL_NO#','#iif(len(get_discount_pur.DISCOUNT1),get_discount_pur.DISCOUNT1,0)#','#iif(len(get_discount_pur.DISCOUNT2),get_discount_pur.DISCOUNT2,0)#','#iif(len(get_discount_pur.DISCOUNT3),get_discount_pur.DISCOUNT3,0)#','#iif(len(get_discount_pur.DISCOUNT4),get_discount_pur.DISCOUNT4,0)#','#iif(len(get_discount_pur.DISCOUNT5),get_discount_pur.DISCOUNT5,0)#','#indirim6#','#indirim7#','#indirim8#','#indirim9#','#indirim10#','#iif(len(get_discount_pur.DELIVERY_DATENO),get_discount_pur.DELIVERY_DATENO,0)#','#iif(IsNumeric(get_p_price.PRICE),get_p_price.PRICE,0)#','#iif(IsNumeric(new_price),new_price,0)#' <cfif isdefined('attributes.add_product_cost')>,'#iif(len(get_product_cost.SISTEM_MALIYET),get_product_cost.SISTEM_MALIYET,0)#','#iif(len(get_product_cost.EK_MALIYET),get_product_cost.EK_MALIYET,0)#'</cfif>,#IS_PRODUCTION#,#new_price#,#product_price#,<cfif len(SPECT_MAIN_ID)>'#SPECT_MAIN_ID#','#SPECT_MAIN_NAME#'<cfelse>'',''</cfif>,<cfif len(assortment_default_amount)>#assortment_default_amount#<cfelse>1</cfif>);">#product_name# #property#</a></td> 
				<td>#products.MANUFACT_CODE#</td>
				<td style="text-align:right;">#TLFormat(product_price)#&nbsp;#money# (#products.add_unit#)</td>
				<td width="15"><a href="javascript://" title="<cf_get_lang dictionary_id="57464.Güncelle">" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCTS.PRODUCT_ID#')"><i class="fa fa-pencil"></i></a></td>
			</tr>
		  </form>
		</cfoutput> 
		<cfelse>
			<tr> 
				<td colspan="6">
					<cfif attributes.is_filter>
						<cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!
					<cfelse>
						<cf_get_lang dictionary_id='57701.Filtre Ediniz'>!
					</cfif>
				</td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="99%">
	  <tr> 
		<td>
			<cfset adres = "product.popup_stocks&is_filter=1">
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.var_)>
				<cfset adres = "#adres#&var_=#attributes.var_#">
			</cfif>
			<cfif isDefined('attributes.product_catid') and len(attributes.product_catid)>
				<cfset adres = "#adres#&product_catid=#attributes.product_catid#">
			</cfif>
			<cfif isDefined('attributes.product_cat') and len(attributes.product_cat)>
				<cfset adres = "#adres#&product_cat=#attributes.product_cat#">
			</cfif>
			<cfif isDefined('attributes.module_name') and len(attributes.module_name)>
				<cfset adres = "#adres#&module_name=#attributes.module_name#">
			</cfif>
			<cfif isdefined("attributes.startdate")>
				<cfset adres = "#adres#&startdate=#attributes.startdate#">
			</cfif>
			<cfif isdefined("attributes.price_lists")>
				<cfset adres = "#adres#&price_lists=#attributes.price_lists#">
			</cfif>
			<cfif isdefined("attributes.compid")>
				<cfset adres = "#adres#&compid=#attributes.compid#">
			</cfif>
			<cfif isdefined("attributes.price_catid")>
				<cfset adres = "#adres#&price_catid=#attributes.price_catid#">
			</cfif>
			<cfif isdefined("attributes.add_product_cost")>
				<cfset adres = "#adres#&add_product_cost=#attributes.add_product_cost#">
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		  </td>
		  <!-- sil --><td style="text-align:right;"> <cfoutput> <cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> 
		  </td><!-- sil -->
	  </tr>
	</table>
</cfif>
</cf_box>
<script type="text/javascript">
	<cfif isDefined("attributes.karma_product_id") and len(attributes.karma_product_id)>
		$(function() {
			$( "a[data-id=prod-rows]" ).each(function() {
				$( this ).click();
			});
			closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
		});
	</cfif>
/* 	price_cat.keyword.focus(); */
function harf_gonder(harf)
	{
		price_cat.keyword.value=harf;
		<cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('price_cat' , #attributes.modal_id#);"),DE(""))#</cfoutput>
	}
	function input_control()
	{
		<cfif not session.ep.our_company_info.unconditional_list>
			if (price_cat.keyword.value.length == 0 && price_cat.product_cat.value.length == 0 && (price_cat.employee_id.value.length == 0 || price_cat.employee.value.length == 0) && (price_cat.search_company_id.value.length == 0 || price_cat.search_company.value.length == 0) )
				{
					alert("<cf_get_lang dictionary_id='58950.En az bir alanda filtre etmelisiniz'>!");
					return false;
				}
			else <cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('price_cat' , #attributes.modal_id#);return false;"),DE(""))#</cfoutput>
		<cfelse>
			<cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('price_cat' , #attributes.modal_id#);return false;"),DE(""))#</cfoutput>
		</cfif>
	}
</script>
