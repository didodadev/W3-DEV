<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="0">
<cfparam name="attributes.purchase_sales" default="1">
<cfparam name="attributes.get_company_id" default="">
<cfparam name="attributes.get_company" default="">
<cfparam name="attributes.rec_date" default="">
<cfparam name="attributes.product_name" default="">
<cfset d6 = "">
<cfset d7 = "">
<cfset d8 = "">
<cfif len(attributes.rec_date)><cf_date tarih='attributes.rec_date'></cfif>
<cfquery name="GET_PAYMETHOD_TYPE" datasource="#DSN#">
	SELECT 
		SP.PAYMETHOD_ID,
		SP.PAYMETHOD
	FROM 
		SETUP_PAYMETHOD SP,
		SETUP_PAYMETHOD_OUR_COMPANY SPOC
	WHERE 
		SP.PAYMETHOD_STATUS = 1
		AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
		AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<!-- sil --> 
<cfif not isdefined("attributes.print")>
	<cfsavecontent variable="head">
		<cf_get_lang dictionary_id='37043.Ürün Koşulları'> : 
		<cfif attributes.purchase_sales eq 1>
			<cf_get_lang dictionary_id='57449.Satınalma'>
		<cfelseif attributes.purchase_sales eq 2>
			<cf_get_lang dictionary_id='57448.Satış'>
		</cfif>
	</cfsavecontent>
	<cfsavecontent variable="right">
		<a href="<cfoutput>#request.self#?fuseaction=product.popup_temp_conditions#page_code#&print=true</cfoutput>"><img src="/images/print.gif" title="<cf_get_lang dictionary_id='58743.Gönder'>" border="0"></a> 
		<cf_workcube_file_action pdf='1' mail='1' doc='1' print='0'>
	</cfsavecontent>
	<cf_popup_box title='#head#' right_images='#right#'>
		<cfoutput>
			<table style="width:150mm;" align="left">
				<tr>
					<td class="formbold" style="width:30mm;"><cf_get_lang dictionary_id='57567.Ürün Kategorisi'></td>
					<td style="width:120mm;">: #attributes.product_cat#</td>
				</tr>
				<tr>
					<td class="formbold"><cf_get_lang dictionary_id='57574.Firma'></td>
					<td>: #attributes.get_company#</td>
				</tr>
				<tr>
					<td class="formbold"><cf_get_lang dictionary_id='57544.Sorumlu'></td>
					<td>: #attributes.employee#</td>
				</tr>
				<tr>
					<td class="formbold"><cf_get_lang dictionary_id='57742.Tarih'></td>
					<td>: #dateformat(now(),dateformat_style)#</td>
				</tr>
				<tr>
					<td colspan="2"><hr noshade style="width:700px;"></td>
				</tr>
			</table>
		</cfoutput>
		<cf_medium_list>
			<thead>
				<tr>
					<th colspan="4"></th>
					<th colspan="8" align="center"><cf_get_lang dictionary_id='37068.İskontolar'></th>
					<th colspan="2" align="center"><cf_get_lang dictionary_id='58084.Fiyat'></th>
					<th colspan="4"></th>
				</tr>
				<tr>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th width="65"><cf_get_lang dictionary_id='57501.Baslangic'></th>
					<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='58722.Standart Alış'></th>		 
					<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='58721.Standart Satış'></th>
					<th width="100" style="text-align:right;">Rebate (<cf_get_lang dictionary_id='57673.Tutar'>)</th>
					<th width="20" align="center">1</th>
					<th width="20" align="center">2</th>
					<th width="20" align="center">3</th>
					<th width="20" align="center">4</th>
					<th width="20" align="center">5</th>
					<th width="20" align="center">6</th>
					<th width="20" align="center">7</th>
					<th width="20" align="center">8</th>
					<th width="75" style="text-align:right;"><cf_get_lang dictionary_id='37362.İskontolu'></th>
					<th width="75" style="text-align:right;"><cf_get_lang dictionary_id='58716.KDV li'> </th>
					<th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57173.Marj'> </th>
					<th width="65"><cf_get_lang dictionary_id='58516.Ödeme'></th>
					<cfif isdefined('attributes.all_conditions')>
						<th width="50" ><cf_get_lang dictionary_id='37755.Back End Rebate'></th>
						<th width="60" ><cf_get_lang dictionary_id='37660.Mal Fazlası'></th>
						<th width="60" ><cf_get_lang dictionary_id='37662.İade Gün'> - <cf_get_lang dictionary_id='58456.Oran'></th>
						<th width="20" ><cf_get_lang dictionary_id='37661.Fiyat Koruma Gün'></th>
					</cfif>
					<th width="65"><cf_get_lang dictionary_id='37283.Aksiyon Bilgisi'></th>
				</tr>
			</thead>
			<tbody>
				<input type="hidden" name="employee" id="employee" value="<cfoutput>#attributes.employee#</cfoutput>">
				<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
				<input type="hidden" name="product_cat" id="product_cat" value="<cfoutput>#attributes.product_cat#</cfoutput>">
				<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
				<input type="hidden" name="purchase_sales" id="purchase_sales" value="<cfoutput>#attributes.purchase_sales#</cfoutput>">
				<input type="hidden" name="get_company_id" id="get_company_id" value="<cfoutput>#attributes.get_company_id#</cfoutput>">
				<input type="hidden" name="get_company" id="get_company" value="<cfoutput>#attributes.get_company#</cfoutput>">
				<cfif isDefined('attributes.get_company_id') and len(attributes.get_company_id)>
					<cfif attributes.purchase_sales eq 1><!--- Satın Alma ise --->
						<cfset TABLE_NAME ='CONTRACT_PURCHASE_GENERAL_DISCOUNT'>
					<cfelseif attributes.purchase_sales eq 2><!--- Satış ise --->
						<cfset TABLE_NAME ='CONTRACT_SALES_GENERAL_DISCOUNT'>
					</cfif>
					<cfquery name="get_c_general_discounts" datasource="#dsn3#" maxrows="3">
						SELECT
							DISCOUNT
						FROM
							#TABLE_NAME# AS CPGD
						WHERE
							CPGD.START_DATE <= #now()# AND
							CPGD.FINISH_DATE >= #now()# AND
							CPGD.COMPANY_ID = #attributes.get_company_id#
						ORDER BY
							CPGD.GENERAL_DISCOUNT_ID
					</cfquery>
					<cfif get_c_general_discounts.recordcount>
						<cfloop query="get_c_general_discounts">
							<cfset 'd#currentrow+6#' = get_c_general_discounts.DISCOUNT>
						</cfloop>
					</cfif>
				</cfif>
				<cfif len(attributes.product_cat) and len(attributes.product_catid)>
					<cfquery name="GET_PRODUCT_CATS" datasource="#dsn3#">
						SELECT 
							PRODUCT_CATID, 
							HIERARCHY
						FROM 
							PRODUCT_CAT 
						WHERE 
							PRODUCT_CATID IS NOT NULL AND
							PRODUCT_CATID = #attributes.product_catid#
						ORDER BY
							HIERARCHY
					</cfquery>
				</cfif>		  
				<cfquery name="GET_PRODUCT" datasource="#DSN3#">
					SELECT 
						PRODUCT.PRODUCT_NAME, 
						PRODUCT.RECORD_DATE, 
						PRODUCT.PRODUCT_CODE,
						PRODUCT.PRODUCT_ID,
						PRODUCT.TAX,
						PRODUCT.TAX_PURCHASE
					FROM 
						PRODUCT 
					WHERE 
						PRODUCT.PRODUCT_STATUS = 1
						<cfif len(attributes.brand_id)>
							AND PRODUCT.BRAND_ID =#attributes.brand_id#
						</cfif>
						<cfif len(attributes.product_cat) and len(attributes.product_catid)>
							AND PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
						</cfif>
						<cfif len(attributes.employee) and len(attributes.pos_code)>
							AND PRODUCT_MANAGER=#attributes.pos_code#
						</cfif>
						<cfif len(attributes.get_company) and len(attributes.get_company_id)>
							AND COMPANY_ID = #attributes.get_company_id#
						</cfif>
						<cfif len(attributes.rec_date)>
							AND RECORD_DATE >= #attributes.rec_date#
						</cfif>
						<cfif len(attributes.product_name)>
							AND PRODUCT.PRODUCT_NAME LIKE '%#attributes.product_name#%'
						</cfif>
				</cfquery>
				<cfif get_product.recordcount>
					<cfoutput query="get_product">
						<cfif attributes.purchase_sales eq 1>
							<cfquery name="GET_PURCHASE_SALES_DISCOUNT" datasource="#DSN3#" maxrows="1">
								SELECT 
								DISCOUNT1, 
								DISCOUNT2, 
								DISCOUNT3, 
								DISCOUNT4,
								DISCOUNT5, 
								PAYMETHOD_ID,
								RECORD_DATE,
								START_DATE,
								PRODUCT_ID,
							<cfif isdefined('all_conditions')>
								EXTRA_PRODUCT_1,
								EXTRA_PRODUCT_2,
								REBATE_CASH_1,
								REBATE_CASH_1_MONEY,
								RETURN_DAY,
								RETURN_RATE,
								PRICE_PROTECTION_DAY,
							</cfif> 
								DISCOUNT_CASH,
								DISCOUNT_CASH_MONEY
							FROM 
								CONTRACT_PURCHASE_PROD_DISCOUNT 
							WHERE 
								PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID#
							ORDER BY
								START_DATE DESC
							</cfquery>
					<cfelseif attributes.purchase_sales eq 2>
						<cfquery name="GET_PURCHASE_SALES_DISCOUNT" datasource="#DSN3#" maxrows="1">
							SELECT 
								CSPD.DISCOUNT1, 
								CSPD.DISCOUNT2, 
								CSPD.DISCOUNT3, 
								CSPD.DISCOUNT4,
								CSPD.DISCOUNT5, 
								CSPD.PAYMETHOD_ID,
								CSPD.RECORD_DATE,
								CSPD.START_DATE,
								CSPD.PRODUCT_ID,
							<cfif isdefined('all_conditions')>
								CSPD.EXTRA_PRODUCT_1,
								CSPD.EXTRA_PRODUCT_2,
								CSPD.REBATE_CASH_1,
								CSPD.REBATE_CASH_1_MONEY,
								CSPD.RETURN_DAY,
								CSPD.RETURN_RATE,
								CSPD.PRICE_PROTECTION_DAY,
							</cfif> 
								CSPD.DISCOUNT_CASH,
								CSPD.DISCOUNT_CASH_MONEY
							FROM 
								CONTRACT_SALES_PROD_DISCOUNT AS CSPD 
							WHERE 
								CSPD.PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID#
							ORDER BY
								RECORD_DATE DESC
						</cfquery>
					</cfif>
					<cfquery name="GET_PRODUCT_PRICE" datasource="#DSN3#">
						SELECT
							MONEY,
							PRICE
						FROM
							PRICE_STANDART
						WHERE
							PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID# AND
							PRICESTANDART_STATUS = 1 AND
							PURCHASESALES = 0
					</cfquery>
					<cfquery name="GET_PRODUCT_PRICE_SALES" datasource="#DSN3#">
						SELECT
							MONEY,
							PRICE
						FROM
							PRICE_STANDART
						WHERE
							PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID# AND
							PRICESTANDART_STATUS = 1 AND
							PURCHASESALES = 1
					</cfquery>
					<cfquery name="get_aksiyon" datasource="#dsn3#">
						SELECT 
							CATALOG_ID 
						FROM 
							PRICE 
						WHERE 
							PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID# AND
							<!---ISNULL(STOCK_ID,0)=0 AND--->
							ISNULL(SPECT_VAR_ID,0)=0 AND
							ISNULL(SPECT_VAR_ID,0)=0 AND
							STARTDATE <= #now()# AND 
							(FINISHDATE >= #now()# OR FINISHDATE IS NULL) AND
							CATALOG_ID IS NOT NULL
					</cfquery>
					<cfscript>
						toplam_tutar_iskontolu = get_product_price.price;
						kar_marj_deger = 0;
						
						if (len(get_purchase_sales_discount.DISCOUNT_CASH))
							rebate = get_purchase_sales_discount.DISCOUNT_CASH;
						else
							rebate = 0;
						
						toplam_tutar_iskontolu = toplam_tutar_iskontolu - rebate;
						if (len(get_purchase_sales_discount.discount1))
							alan_indirim_1 = get_purchase_sales_discount.discount1;
						else
							alan_indirim_1 = 0;
						if (len(get_purchase_sales_discount.discount2))
							alan_indirim_2 = get_purchase_sales_discount.discount2;
						else
							alan_indirim_2 = 0;
						if (len(get_purchase_sales_discount.discount3))
							alan_indirim_3 = get_purchase_sales_discount.discount3;
						else
							alan_indirim_3 = 0;
						if (len(get_purchase_sales_discount.discount4))
							alan_indirim_4 = get_purchase_sales_discount.discount4;
						else
							alan_indirim_4 = 0;
						if (len(get_purchase_sales_discount.discount5))
							alan_indirim_5 = get_purchase_sales_discount.discount5;
						else
							alan_indirim_5 = 0;
						
						toplam_tutar_iskontolu = toplam_tutar_iskontolu*(((100-alan_indirim_1)/100));
						toplam_tutar_iskontolu = toplam_tutar_iskontolu*(((100-alan_indirim_2)/100));
						toplam_tutar_iskontolu = toplam_tutar_iskontolu*(((100-alan_indirim_3)/100));
						toplam_tutar_iskontolu = toplam_tutar_iskontolu*(((100-alan_indirim_4)/100));
						toplam_tutar_iskontolu = toplam_tutar_iskontolu*(((100-alan_indirim_5)/100));
						toplam_tutat_iskontolu_kdvli = toplam_tutar_iskontolu;
						
						if ( (toplam_tutat_iskontolu_kdvli neq 0) and len(GET_PRODUCT_PRICE_SALES.price) and (GET_PRODUCT_PRICE_SALES.price neq 0) )
							kar_marj_deger = wrk_round(((GET_PRODUCT_PRICE_SALES.price-toplam_tutat_iskontolu_kdvli)*100)/toplam_tutat_iskontolu_kdvli);
					</cfscript>
					
					<cfif attributes.purchase_sales eq 1>
						<cfif tax_purchase neq 0>
							<cfset toplam_tutat_iskontolu_kdvli  = (toplam_tutat_iskontolu_kdvli*(100+tax_purchase)/100)>
						</cfif>
					<cfelseif attributes.purchase_sales eq 2>
						<cfif tax neq 0>
							<cfset toplam_tutat_iskontolu_kdvli  = (toplam_tutat_iskontolu_kdvli*(100+tax)/100)>
						</cfif>
					</cfif>
					<cfset toplam_tutar_iskontolu = wrk_round(toplam_tutar_iskontolu)>
					<cfset toplam_tutat_iskontolu_kdvli = wrk_round(toplam_tutat_iskontolu_kdvli)>			  
					<tr>
						<td>#product_name#</td>
						<td><cfif len(get_purchase_sales_discount.start_date)>#dateformat(get_purchase_sales_discount.start_date,dateformat_style)#</cfif>&nbsp;</td>
						<td style="text-align:right;">#tlformat(get_product_price.price)#</td>				
						<td style="text-align:right;">#tlformat(get_product_price_sales.price)#</td>
						<td style="text-align:right;">#tlformat(get_purchase_sales_discount.DISCOUNT_CASH)#</td>
						<td style="text-align:right;">#tlformat(get_purchase_sales_discount.discount1)#</td>
						<td style="text-align:right;">#tlformat(get_purchase_sales_discount.discount2)#</td>
						<td style="text-align:right;">#tlformat(get_purchase_sales_discount.discount3)#</td>
						<td style="text-align:right;">#tlformat(get_purchase_sales_discount.discount4)#</td>
						<td style="text-align:right;">#tlformat(get_purchase_sales_discount.discount5)#</td>
						<td style="text-align:right;"><cfif len(d6)>#tlformat(d6)#<cfelse><font size="+1">-</font></cfif></td>
						<td style="text-align:right;"><cfif len(d7)>#tlformat(d7)#<cfelse><font size="+1">-</font></cfif></td>
						<td style="text-align:right;"><cfif len(d8)>#tlformat(d8)#<cfelse><font size="+1">-</font></cfif></td>
						<td style="text-align:right;">#tlformat(toplam_tutar_iskontolu)#</td>
						<td style="text-align:right;">#tlformat(toplam_tutat_iskontolu_kdvli)# #get_product_price.money#</td>
						<td style="text-align:right;">#tlformat(kar_marj_deger)#</td>
						<td><cfloop query="get_paymethod_type">
								<cfif get_purchase_sales_discount.paymethod_id eq paymethod_id>#paymethod#</cfif>
							</cfloop>&nbsp;
						</td>
						<cfif isdefined('attributes.all_conditions')>
							<td width="50" nowrap>
								#tlformat(get_purchase_sales_discount.REBATE_CASH_1)#
								#get_purchase_sales_discount.REBATE_CASH_1_MONEY#
							</td>
							<td width="50" nowrap>
								#tlformat(get_purchase_sales_discount.extra_product_1)#
								#tlformat(get_purchase_sales_discount.extra_product_2)#
							</td>
							<td width="50" nowrap>#tlformat(get_purchase_sales_discount.RETURN_DAY)# - #tlformat(get_purchase_sales_discount.RETURN_RATE)#</td>
							<td width="20" nowrap>#tlformat(get_purchase_sales_discount.PRICE_PROTECTION_DAY)#</td>
						</cfif>
						<td align="center"><cfif get_aksiyon.recordcount><font size="+1">*</font></cfif></td>
					</tr>
					</cfoutput>
				</cfif>		
			</tbody>
		</cf_medium_list>
	</cf_popup_box>
</cfif>
<cfif isdefined("attributes.print")>
	<script type="text/javascript">
		window.print();
	</script>
</cfif>
