<!--- 
	/* Popup Basket Sayfasinda acilan Ürün Fiyati secme popup sayfasi*/
	// Amaç        : Basketlerde ki ürün fiyatini degistirebilmeyi saglamak
--->

<cf_xml_page_edit fuseact="objects.popup_product_price_history_js,objects.popup_product_price_history_public_js">

	<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
		<cfinclude template="../../member/query/get_ims_control.cfm">
	</cfif>
	
	<cfinclude template="../query/get_moneys.cfm">
	<cfset url_str = ''>
	<cfif isdefined("is_sale_product")>
		<cfset url_str = "#url_str#&is_sale_product=#is_sale_product#">
	</cfif>
	<cfif isdefined("attributes.is_cost")>
		<cfset url_str = "#url_str#&is_cost=#attributes.is_cost#">
	</cfif>
	<cfif isdefined("attributes.search_process_date") and isdate(attributes.search_process_date)>
		<cfset url_str = "#url_str#&search_process_date=#attributes.search_process_date#">
	</cfif>
	<cfif isdefined("sepet_process_type")>
		<cfset url_str = "#url_str#&sepet_process_type=#sepet_process_type#">
	</cfif>
	<cfif isdefined("attributes.int_basket_id")>
		<cfset url_str = "#url_str#&int_basket_id=#attributes.int_basket_id#">
	</cfif>
	<cfif isdefined("attributes.company_id")>
		<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
	</cfif>
	<cfif isDefined('attributes.rowcount') and len(attributes.rowcount)>
		<cfset url_str = "#url_str#&rowcount=#attributes.rowcount#">
	</cfif>
	<cfif isDefined('attributes.is_price') and len(attributes.is_price)>
		<cfset url_str = "#url_str#&is_price=#attributes.is_price#">
	</cfif>
	<cfloop query="moneys">
		<cfif isdefined("attributes.#money#")>
			<cfset url_str = "#url_str#&#money#=#evaluate("attributes.#money#")#">
		</cfif>
	</cfloop>
	<cfif isdefined("attributes.satir")>
		<cfset url_str = "#url_str#&satir=#attributes.satir#">
	</cfif>
	
	<cfquery name="get_urun_birim" datasource="#DSN3#">
		SELECT ADD_UNIT,MULTIPLIER FROM PRODUCT_UNIT WHERE PRODUCT_ID = #attributes.product_id#
	</cfquery>
	<cfinclude template="../query/get_rival_prices.cfm">
	<cfinclude template="../query/get_product_price_sales.cfm">
	<cfquery name="GET_STOCK_STRATEGIES" datasource="#dsn3#">
		SELECT
			MINIMUM_ORDER_UNIT_ID,
			MINIMUM_ORDER_STOCK_VALUE
		FROM
			STOCK_STRATEGY
		WHERE
			STOCK_ID = #attributes.STOCK_ID#
			AND DEPARTMENT_ID IS NULL
	</cfquery>
	<cffunction name="get_stock_strat" output="false" returntype="numeric">
		<cfargument name="unit_id" required="true" type="numeric">
		<cfquery name="get_stock_strategy" dbtype="query">
			SELECT MINIMUM_ORDER_STOCK_VALUE FROM GET_STOCK_STRATEGIES WHERE MINIMUM_ORDER_UNIT_ID = #ARGUMENTS.UNIT_ID#
		</cfquery>
		<cfif get_stock_strategy.recordcount and isnumeric(get_stock_strategy.MINIMUM_ORDER_STOCK_VALUE) and get_stock_strategy.MINIMUM_ORDER_STOCK_VALUE neq 0>
			<cfset amount_ = get_stock_strategy.MINIMUM_ORDER_STOCK_VALUE>
		<cfelse>
			<cfset amount_ = 1>
		</cfif>
		<cfreturn amount_>
	</cffunction>
	
	<cfif isdefined("session.ep.money")>
		<cfset money_value = session.ep.money>
	<cfelseif isdefined("session.pp.money")>
		<cfset money_value = session.pp.money>
	</cfif>
	<cfquery name="get_pro_name" datasource="#DSN3#">SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = #attributes.product_id#</cfquery>
	<!--- Ürün Bilgileri --->
	<cfinclude template="../query/get_product_prices_sa_ss.cfm">
	<!--- Satış Fiyatları --->
	<!---<cfinclude template="product_cost_detail.cfm"> Yeni Maliyete Göre Düzenlenmeli ---> 
	<cfsavecontent variable="image">
		<a href="##" onClick="history.go(-1);"><img src="/images/back.gif" border="0" title="<cf_get_lang dictionary_id='57432.Geri'>"></a>
	</cfsavecontent>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='33016.Fiyat Detay'></cfsavecontent>
	<cf_popup_box title="#message# :#get_pro_name.product_name#" right_images='#image#'>
		<cfset max_col_num_1 = 0 >
		<cfset unit_liste_1 = ValueList(get_urun_birim.ADD_UNIT) >
		<cfset max_col_num_1 = ListLen(unit_liste_1) >
		<cf_medium_list>
			<thead>
				<tr>
					<th colspan="5"><cf_get_lang dictionary_id='33017.Listeler'></th>
				</tr>
				<tr>
					<th width="150"><cf_get_lang dictionary_id='57509.Liste'></th>
					<cfloop list="#unit_liste_1#" index="liste_1">
						<th><cf_get_lang dictionary_id='58084.Fiyat'>(<cfoutput>#liste_1#</cfoutput>)</th>
						<th>%<cf_get_lang dictionary_id='33021.Marj'></th>
					</cfloop>
				</tr>
			</thead>
			<tbody>
				<cfoutput>
					<cfif not isdefined("attributes.is_store_module")>
						<tr>
							<td><cf_get_lang dictionary_id='58722.Standart Alış'></td>
							<cfloop list="#unit_liste_1#" index="liste_1">
								<td  style="text-align:right;">
									<cfquery name="get_pr" dbtype="query">SELECT * FROM GET_PRICE_SA WHERE ADD_UNIT = '#liste_1#'</cfquery>
									<cfif get_pr.recordcount>							
									<cfif len(get_pr.PRICE)><cfset flt_price = get_pr.PRICE><cfelse><cfset flt_price = 0></cfif>
										<a href="##" onClick="set_opener_money('#flt_price#', '#get_pr.money#', '#get_pr.product_unit_id#', '#get_pr.add_unit#', '#get_stock_strat(get_pr.product_unit_id)#','','')" class="tableyazi">#TLFormat(flt_price,4)#&nbsp;#get_pr.money#</a>
									</cfif>
								</td>
								<td></td>
							</cfloop>
						</tr>
					</cfif>
					<tr>
						<td><cf_get_lang dictionary_id='58721.Standart Satış'></td>
						<cfloop list="#unit_liste_1#" index="liste_1">
							<td  style="text-align:right;">
								<cfquery name="get_pr" dbtype="query">SELECT * FROM GET_PRICE_SS WHERE ADD_UNIT='#liste_1#'</cfquery>
								<cfif get_pr.recordcount>
								<cfif len(get_pr.PRICE)><cfset flt_price = get_pr.PRICE ><cfelse><cfset flt_price = 0 ></cfif>
									<a href="##" onClick="set_opener_money('#flt_price#', '#get_pr.money#', '#get_pr.product_unit_id#', '#get_pr.add_unit#', '#get_stock_strat(get_pr.product_unit_id)#','','')" class="tableyazi">#TLFormat(flt_price)#&nbsp;#get_pr.money#</a>
								</cfif>							
							</td>
							<td align="center">
								<cfif get_pr.money neq money_value>
									<cfquery name="get_pur_price" datasource="#DSN2#" maxrows="1">
										SELECT
											PRICE,STOCK_ID,UNIT
										FROM 
											INVOICE_ROW,
											INVOICE 
										WHERE
											INVOICE_ROW.INVOICE_ID = INVOICE.INVOICE_ID AND
											ISNULL(INVOICE.IS_IPTAL,0)=0 AND 
											PRODUCT_ID = #attributes.product_id# AND
											UNIT='#get_pr.ADD_UNIT#' AND
											INVOICE.PURCHASE_SALES = 0 
										ORDER BY
											INVOICE.INVOICE_DATE DESC 
									  </cfquery>				
									<cfif isnumeric(get_pur_price.PRICE) and (get_pur_price.PRICE neq 0)>
										(#TLFormat(((flt_price-get_pur_price.PRICE)/get_pur_price.PRICE)*100)#)
									</cfif>				
								</cfif>						
							</td>
						</cfloop>
					</tr>
					</cfoutput>
					<cfoutput query="GET_PRODUCT_PRICE" maxrows="10">
						<tr>
							<td>#PRICE_CAT#</td>
							<cfloop list="#unit_liste_1#" index="liste_1">
								<td  style="text-align:right;">
									<cfif GET_PRODUCT_PRICE.ADD_UNIT eq liste_1>
										<a href="##" onClick="set_opener_money('#price#', '#money#', '#GET_PRODUCT_PRICE.product_unit_id#', '#GET_PRODUCT_PRICE.ADD_unit#', '#get_stock_strat(GET_PRODUCT_PRICE.product_unit_id)#','','','#GET_PRODUCT_PRICE.NUMBER_OF_INSTALLMENT#','#GET_PRODUCT_PRICE.AVG_DUE_DAY#','#GET_PRODUCT_PRICE.PRICE_CATID#');" class="tableyazi">#TLFormat(PRICE)#&nbsp;#money#</a>
									</cfif>
								</td>
								<td align="center">
									<cfif GET_PRODUCT_PRICE.ADD_UNIT eq liste_1 >
										<cfquery name="get_pur_price" datasource="#DSN2#" maxrows="1">
											SELECT
												PRICE,STOCK_ID,UNIT
											FROM 
												INVOICE_ROW,
												INVOICE
											WHERE
												INVOICE_ROW.INVOICE_ID = INVOICE.INVOICE_ID AND 
												ISNULL(INVOICE.IS_IPTAL,0)=0 AND 
												PRODUCT_ID = #attributes.product_id# AND
												UNIT='#ADD_UNIT#' AND
												INVOICE.PURCHASE_SALES = 0 
											ORDER BY
												INVOICE.INVOICE_DATE DESC 
										  </cfquery>				
										<cfif isnumeric(get_pur_price.PRICE)  and (get_pur_price.PRICE neq 0)>
											(#TLFormat(((PRICE-get_pur_price.PRICE)/get_pur_price.PRICE)*100)#)
										</cfif>
									</cfif>							
								</td>
							</cfloop>
						</tr>
				</cfoutput> 
			</tbody>
		</cf_medium_list>
		  <!--- Satis fiyatlari --->
		  <br/>
		  <cfif isdefined("attributes.company_id") or isdefined("attributes.consumer_id")>
		  <!--- musteri satis Fiyatlari  --->
			<cfquery name="GET_COMP_PRICES" datasource="#DSN2#"	>
				SELECT
					IR.PRICE, 
					I.INVOICE_DATE,
					I.COMPANY_ID,
					IR.NAME_PRODUCT, 
					I.SALE_EMP,
					I.CONSUMER_ID,
					IR.UNIT
				FROM
					INVOICE I,
					INVOICE_ROW IR
				WHERE
					I.INVOICE_ID = IR.INVOICE_ID
					AND ISNULL(I.IS_IPTAL,0)=0 
					AND IR.PRODUCT_ID = #attributes.product_id#
				<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
					AND I.COMPANY_ID = #attributes.company_id#
				<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
					AND I.CONSUMER_ID = #attributes.consumer_id#
				<cfelse>
					AND I.INVOICE_ID IS NULL <!--- kayıt getirmesin --->
				</cfif>
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
					AND
						(
						(I.CONSUMER_ID IS NULL AND I.COMPANY_ID IS NULL) 
						OR (I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						)
				</cfif>
			</cfquery>  
			<cf_medium_list>
				<thead>
					<tr>
						<th colspan="5"><cf_get_lang dictionary_id='33022.Müşteri Satış Fiyatları'></th>
					</tr>
					<tr>
						<th width="150"><cf_get_lang dictionary_id='33008.satış yapan'></th>
						<th><cf_get_lang dictionary_id="57629.Açıklama"></th>			
						<th><cf_get_lang dictionary_id='58084.Fiyat'></th>
						<th><cf_get_lang dictionary_id="57636.Birim"></th>
						<th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="GET_COMP_PRICES" maxrows="10">
						<tr>
							<td><cfif len(sale_emp)>#get_emp_info(sale_emp,0,1)#</cfif></td>
							<cfquery name="get_property" datasource="#dsn3#">SELECT STOCKS.PROPERTY,PU.PRODUCT_UNIT_ID FROM STOCKS,PRODUCT_UNIT PU WHERE PU.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND PU.PRODUCT_ID = #attributes.product_id# AND ADD_UNIT='#UNIT#'</cfquery>
							<td>#NAME_PRODUCT# #get_property.PROPERTY#</td>
							<td  style="text-align:right;">
								<cfif get_property.recordcount>
									<a href="##" onClick="set_opener_money('#price#', '#money_value#', '#get_property.PRODUCT_UNIT_ID#', '#unit#', '#get_stock_strat(get_property.product_unit_id)#','','')" class="tableyazi">#TLFormat(PRICE)#&nbsp;#money_value#</a>
								</cfif>
							</td>
							<td align="center">#UNIT#</td>
							<td>#dateformat(INVOICE_DATE,dateformat_style)#</td>
						</tr>
					</cfoutput> 
				</tbody>
			</cf_medium_list>
		  </cfif>
		  <!--- // musteri satis Fiyatlari --->	  
		  <br/>
		  <!--- son alis fiyatlari --->
			<cf_medium_list>
				<thead>
					<tr>
						<th colspan="7"><cf_get_lang dictionary_id='32531.Son Alış Fiyatları'>/<cf_get_lang dictionary_id='30024.kdvsiz'></th>
					</tr>
					<tr>
						<th width="150"><cf_get_lang dictionary_id='57658.üye'></th>
						<th><cf_get_lang dictionary_id="57629.Açıklama"></th>
						<th width="150" style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'></th>
						<th width="150" style="text-align:right;"><cf_get_lang dictionary_id="57796.Dövizli"> <cf_get_lang dictionary_id='58084.Fiyat'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id='33030.İndirimli Fiyat'></th>
						<th><cf_get_lang dictionary_id="57636.Birim"></th>
						<th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
					</tr>
				</thead>
				<tbody>
					<cfinclude template="../query/get_purchase_cost.cfm">
					<cfoutput query="get_purchase_cost" maxrows="10">
						<cfquery name="get_property" datasource="#dsn3#">SELECT PROPERTY,PU.PRODUCT_UNIT_ID FROM STOCKS,PRODUCT_UNIT PU WHERE PU.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND PU.PRODUCT_ID = #attributes.product_id# AND ADD_UNIT='#UNIT#'</cfquery>
						<cfif get_property.recordcount>
							<tr>
								<td><cfif len(COMPANY_ID)>#get_par_info(member_id:COMPANY_ID,company_or_partner:1,with_link:1,with_company_partner:1)#<cfelse>#get_cons_info(consumer_id:CONSUMER_ID,with_company:1,with_link:1)#</cfif></td>
								<td>#NAME_PRODUCT#</td>
								<td  style="text-align:right;">
									<a href="##" onClick="set_opener_money('#GET_PURCHASE_COST.PRICE#', '#money_value#', '#get_property.PRODUCT_UNIT_ID#', '#unit#', '#get_stock_strat(get_property.product_unit_id)#','','')" class="tableyazi">#TLFormat(GET_PURCHASE_COST.PRICE,4)#&nbsp;#money_value#</a>
								</td>
								<td  style="text-align:right;">
									<cfif len(OTHER_MONEY) and len(PRICE_OTHER)>
										#TLFormat(PRICE_OTHER,session.ep.our_company_info.sales_price_round_num)#&nbsp;#OTHER_MONEY#
									</cfif>
								</td>
								<cfscript>
									indirimli_alis_fiyat = PRICE;
										indirim1 = DISCOUNT1;
										indirim2 = DISCOUNT2;
										indirim3 = DISCOUNT3;
										indirim4 = DISCOUNT4;
										indirim5 = DISCOUNT5;
									if (not len(indirim1)){indirim1 = 0;}
									if (not len(indirim2)){indirim2 = 0;}
									if (not len(indirim3)){indirim3 = 0;}
									if (not len(indirim4)){indirim4 = 0;}
									if (not len(indirim5)){indirim5 = 0;}
									indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim1)/100;
									indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim2)/100;
									indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim3)/100;
									indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim4)/100;
									indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim5)/100;
								</cfscript>
								<td  style="text-align:right;">#TLFormat(indirimli_alis_fiyat,4)#&nbsp;#money_value#</td>
								<td align="center">#UNIT#</td>
								<td>#dateformat(GET_PURCHASE_COST.INVOICE_DATE,dateformat_style)#</td>
							</tr>
						</cfif>
					</cfoutput>
				</tbody>
			</cf_medium_list>
		  <!--- // son alis fiyatları --->
		  <br/>
		  <!--- son satis fiyatlari --->
			 <cf_medium_list>
			 <thead>
				<tr>
					<th colspan="8"><cf_get_lang dictionary_id='33018.Son Satış Fiyatları'>/<cf_get_lang dictionary_id='30024.kdvsiz'></th>
				</tr>
				<tr>
					<th width="150"><cf_get_lang dictionary_id='33008.satış yapan'></th>
					<th><cf_get_lang dictionary_id="57629.Açıklama"></th>
					<th width="150"><cf_get_lang dictionary_id='57658.üye'></th>
					<th width="120" style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'></th>
					<th width="120" style="text-align:right;"><cf_get_lang dictionary_id="33366.Dövizli Fiyat"></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='33030.İndirimli Fiyat'></th>
					<th><cf_get_lang dictionary_id="57636.Birim"></th>
					<th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
				  </tr>
			  </thead>
			  <tbody>
				<cfinclude template="../query/get_sale_cost.cfm">
				<cfoutput query="get_sale_cost" maxrows="10">
					<cfquery name="get_property" datasource="#dsn3#">SELECT PROPERTY,PU.PRODUCT_UNIT_ID FROM STOCKS,PRODUCT_UNIT PU WHERE PU.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND PU.PRODUCT_ID = #attributes.product_id# AND ADD_UNIT='#UNIT#'</cfquery>
					<cfif get_property.recordcount>
					<tr>
						<td><cfif len(sale_emp)>#get_emp_info(sale_emp,0,1)#</cfif></td>
						<td>#NAME_PRODUCT#</td>
						<td><cfif len(COMPANY_ID)>#get_par_info(member_id:COMPANY_ID,company_or_partner:1,with_link:1,with_company_partner:1)#<cfelse>#get_cons_info(CONSUMER_ID,1,1)#</cfif></td>
						<td  style="text-align:right;">
						<a href="##" onClick="set_opener_money('#PRICE#', '#money_value#', '#get_property.PRODUCT_UNIT_ID#', '#unit#', '#get_stock_strat(get_property.product_unit_id)#','','')" class="tableyazi">#TLFormat(PRICE)#&nbsp;#money_value#</a>
						</td>
						<td  style="text-align:right;">
							<cfif len(OTHER_MONEY) and len(PRICE_OTHER)>
								#TLFormat(PRICE_OTHER,session.ep.our_company_info.sales_price_round_num)#&nbsp;#OTHER_MONEY#
							</cfif>
						</td>
						<cfscript>
							indirimli_satis_fiyat = PRICE;
							indirim1 = DISCOUNT1;
							indirim2 = DISCOUNT2;
							indirim3 = DISCOUNT3;
							indirim4 = DISCOUNT4;
							indirim5 = DISCOUNT5;
							if (not len(indirim1)){indirim1 = 0;}
							if (not len(indirim2)){indirim2 = 0;}
							if (not len(indirim3)){indirim3 = 0;}
							if (not len(indirim4)){indirim4 = 0;}
							if (not len(indirim5)){indirim5 = 0;}
							indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim1)/100;
							indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim2)/100;
							indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim3)/100;
							indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim4)/100;
							indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim5)/100;
						</cfscript>
						<td  style="text-align:right;">#TLFormat(indirimli_satis_fiyat)#&nbsp;#money_value#</td>
						<td align="center">#UNIT#</td>
						<td>#dateformat(INVOICE_DATE,dateformat_style)#</td>
					</tr>
					</cfif>
				</cfoutput>
			</tbody>
		</cf_medium_list>
		  <!--- // son satis fiyatları --->
		  <br/>
		  <!--- rakip Fiyatlar --->
			<cf_medium_list>
				<thead>
					<tr>
						<th colspan="4"><cf_get_lang dictionary_id='45825.Rakip Fiyatlar'></th>
					</tr>
					<tr>
						<th width="150"><cf_get_lang dictionary_id='58779.Rakip'></th>
						<th><cf_get_lang dictionary_id="57632.Özellik"></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'></th>
						<th><cf_get_lang dictionary_id="57636.Birim"></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="GET_RIVAL_PRICES" maxrows="10">
						<cfquery name="get_property" datasource="#dsn3#">SELECT STOCKS.PROPERTY,PU.PRODUCT_UNIT_ID FROM STOCKS,PRODUCT_UNIT PU WHERE PU.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND PU.PRODUCT_ID = #attributes.product_id# AND ADD_UNIT='#UNIT#'</cfquery>
						<tr>
							<td>#RIVAL_NAME#</td>
							<td>#get_property.PROPERTY#</td>
							<td style="text-align:right;">
							<cfif len(PRICE) ><cfset flt_price = PRICE ><cfelse><cfset flt_price = 0 ></cfif>
							<cfif get_property.recordcount>
								<a href="##" onClick="set_opener_money('#PRICE#', '#money#', '#get_property.PRODUCT_UNIT_ID#', '#unit#', '#get_stock_strat(get_property.product_unit_id)#','','')" class="tableyazi">#TLFormat(PRICE)#&nbsp;#MONEY#</a>
							</cfif>
							</td>
							<td>#UNIT#</td>
						</tr>
					</cfoutput> 
				</tbody>
			</cf_medium_list>
		  <!--- Rakip Fiyatlar --->
	</cf_popup_box>
	<cfoutput>
	<form name="form_product" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_basket_row#url_str#">
		<input type="Hidden" name="from_price_page" id="from_price_page" value="1">
		<input type="Hidden" name="update_product_row_id" id="update_product_row_id" value="<cfif isdefined("update_product_row_id")>#update_product_row_id#<cfelse>0</cfif>">
		<input type="Hidden" name="product_id" id="product_id" value="#product_id#">
		<input type="Hidden" name="stock_id" id="stock_id" value="#stock_id#">
		<input type="Hidden" name="stock_code" id="stock_code" value="#stock_code#">
		<input type="Hidden" name="barcod" id="barcod" value="#barcod#">
		<input type="Hidden" name="manufact_code" id="manufact_code" value="#manufact_code#">
		<input type="Hidden" name="product_name" id="product_name" value="#product_name#">
		<input type="Hidden" name="unit_id" id="unit_id" value="">
		<input type="Hidden" name="unit" id="unit" value="">
		<input type="Hidden" name="branch_id" id="branch_id" value="<cfif isdefined("attributes.branch_id")>#attributes.branch_id#</cfif>">
		<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
		<input type="Hidden" name="department_id" id="department_id" value="#attributes.department_id#">
		<input type="Hidden" name="department_name" id="department_name" value="<cfif isdefined("attributes.department_name")>#attributes.department_name#</cfif>">
		</cfif>
		<input type="Hidden" name="unit_multiplier" id="unit_multiplier" value="#unit_multiplier#">
		<input type="Hidden" name="product_code" id="product_code" value="#product_code#">
		<input type="Hidden" name="amount" id="amount" value="#amount#">
		<input type="hidden" name="is_serial_no" id="is_serial_no" value="#is_serial_no#">
		 <input type="hidden" name="kur_hesapla" id="kur_hesapla" value="#kur_hesapla#">	
		<!--- 20041230 ??? <input type="hidden" name="is_sale_product" value="<cfif isdefined("is_sale_product")><cfoutput>#is_sale_product#</cfoutput>-1</cfif>">--->
		<input type="hidden" name="is_sale_product" id="is_sale_product" value="<cfif isdefined("is_sale_product")><cfoutput>#is_sale_product#</cfoutput><cfelse>-1</cfif>">
		<input type="hidden" name="tax" id="tax"  value="#tax#">
		<input type="hidden" name="flt_price_other_amount" id="flt_price_other_amount"  value="">
		<input type="hidden" name="str_money_currency" id="str_money_currency"  value="">
		<input type="hidden" name="is_inventory" id="is_inventory" value="#is_inventory#">
		<cfif isdefined("attributes.amount_multiplier") and len(attributes.amount_multiplier) and isnumeric(attributes.amount_multiplier)>
		<input type="hidden" name="amount_multiplier" id="amount_multiplier" value="#amount_multiplier#">
		</cfif>
		<input type="hidden" name="net_maliyet" id="net_maliyet"  value="">
		<input type="hidden" name="marj" id="marj"  value="">	
		<input type="Hidden" name="due_day_value" id="due_day_value" value="<cfif isdefined("attributes.due_day_value")>#attributes.due_day_value#</cfif>">	
		<input type="hidden" name="row_promotion_id" id="row_promotion_id" value="#row_promotion_id#">
		<input type="hidden" name="promosyon_yuzde" id="promosyon_yuzde" value="#promosyon_yuzde#">
		<input type="hidden" name="promosyon_maliyet" id="promosyon_maliyet" value="#promosyon_maliyet#">
		<input type="hidden" name="promosyon_form_info" id="promosyon_form_info" value="">
		<input type="hidden" name="basket_id" id="basket_id"> <!--- basket_id,perakende sektorunde kullanılan urun listesinden taşındı --->
		<input type="hidden" name="spec_id" id="spec_id" value="#attributes.spec_id#">
		<input type="hidden" name="is_production" id="is_production" value="#attributes.is_production#">
		<input type="hidden" name="ek_tutar" id="ek_tutar" value="#attributes.ek_tutar#"><!--- //ek_tutar//work_product_price --->
		<input type="hidden" name="unit_other" id="unit_other" value="#attributes.unit_other#"><!--- //unit_other --->
		<input type="hidden" name="shelf_number" id="shelf_number" value="">
		<input type="hidden" name="deliver_date" id="deliver_date" value="">
		<input type="hidden" name="otv" id="otv" value="<cfif isdefined("attributes.otv")>#attributes.otv#</cfif>">
		<input type="hidden" name="price_catid" id="price_catid" value="<cfif isdefined("attributes.price_catid")>#attributes.price_catid#</cfif>">
		<input type="hidden" name="number_of_installment" id="number_of_installment" value="<cfif isdefined("attributes.number_of_installment")>#attributes.number_of_installment#</cfif>">
		<input type="hidden" name="list_price" id="list_price" value="<cfif isdefined("attributes.list_price")>#attributes.list_price#</cfif>">
	</form>
	</cfoutput>
	<br/>
	<script type="text/javascript">
		function set_opener_money(flt_price,str_other_currency,unit_id,unit_str,amount_,net_maliyet,marj,number_of_installment,due_day_value,price_catid)
		{
		<!---	/*
			product_exists = false;
		 <cfif workcube_sector is "it">
			if (opener.rowCount > 1)
				{
				for (i=1; (!product_exists) && (i<=opener.rowCount); i++)
					if (opener.form_basket.stock_id[i-1].value == <cfoutput>#stock_id#</cfoutput>)
						{
						product_exists = true;
						opener.form_basket.amount[i-1].value++;
						opener.hesapla('amount',i);
						}
				}
			else if (opener.rowCount == 1)
				{
				if (opener.form_basket.stock_id.value == <cfoutput>#stock_id#</cfoutput>)
					{
					product_exists = true;
					opener.form_basket.amount.value++;
					opener.hesapla('amount',1);
					}
				}
		 </cfif> 
		if (!product_exists)
			{
			*/--->
			form_product.unit.value = unit_str;	
			form_product.unit_id.value = unit_id;
			form_product.amount.value = amount_;
			form_product.str_money_currency.value = str_other_currency;
			form_product.flt_price_other_amount.value = flt_price;		
			form_product.net_maliyet.value = net_maliyet;
			form_product.marj.value = marj;	
			if(number_of_installment!=undefined) form_product.number_of_installment.value=number_of_installment; else form_product.number_of_installment.value='';
			if(due_day_value!=undefined) form_product.due_day_value.value=due_day_value; else form_product.due_day_value.value='';
			if(price_catid!=undefined) form_product.price_catid.value=price_catid; else form_product.price_catid.value='';
			form_product.submit();
			/*
			}
			*/
		}
	</script>