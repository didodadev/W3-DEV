<!--- SM 20071016 Fiyat Listeli Ürün Popupından açılan div deki sayfa. Her ürün için bütün fiyat listelerindeki
fiyatları getiriyor --->
<cfsetting showdebugoutput="no">
<cfquery name="get_product" datasource="#dsn3#">
	SELECT 
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_CODE,
		GS.PRODUCT_STOCK,
		STOCKS.PRODUCT_NAME,
		STOCKS.PROPERTY,
		STOCKS.BARCOD AS BARCOD,
		STOCKS.IS_INVENTORY,
		STOCKS.IS_PRODUCTION,
		STOCKS.TAX AS TAX,
		STOCKS.OTV AS OTV,
		STOCKS.IS_ZERO_STOCK,
		STOCKS.IS_PRODUCTION,
		STOCKS.PRODUCT_CATID,
		STOCKS.PRODUCT_CODE,
		STOCKS.MANUFACT_CODE,
		STOCKS.IS_SERIAL_NO,
		PRICE_STANDART.PRICE,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN PRICE_STANDART.MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE PRICE_STANDART.MONEY END AS MONEY,
		<cfelse>
			PRICE_STANDART.MONEY,
		</cfif> 
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_UNIT.MULTIPLIER
	FROM
		STOCKS,
		<cfif isdefined("attributes.is_store_module") and len(attributes.is_store_module)>
			#dsn2_alias#.GET_STOCK_PRODUCT_BRANCH GS,
		<cfelse>
			#dsn2_alias#.GET_STOCK GS,
		</cfif>
		PRICE_STANDART,
		PRODUCT_UNIT
	WHERE
		<cfif isdefined("attributes.product_id")>
			STOCKS.PRODUCT_ID = #attributes.product_id# AND
		</cfif>
		<cfif isdefined("attributes.stock_id")>
			STOCKS.STOCK_ID = #attributes.stock_id# AND
		</cfif>
		PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND 
		GS.STOCK_ID = STOCKS.STOCK_ID AND
		PRICE_STANDART.PRICESTANDART_STATUS = 1 AND 
		PRICE_STANDART.PURCHASESALES = 1 AND 
		STOCKS.PRODUCT_STATUS = 1 AND 
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND 
		STOCKS.IS_SALES=1 AND
		PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND 
		PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
</cfquery>
<cfquery name="get_deps_" datasource="#dsn#">
	SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #listgetat(session.ep.user_location,1,'-')#
</cfquery>
<cfset department_name_ = get_deps_.DEPARTMENT_HEAD>
<cfquery name="get_moneys" datasource="#dsn#">
	SELECT
		MONEY,
		RATE1,
		RATE2
	FROM
		SETUP_MONEY
	WHERE
		COMPANY_ID = #session.ep.company_id# AND
		PERIOD_ID = #session.ep.period_id# AND
		MONEY_STATUS = 1
</cfquery>
<cfquery name="get_default_money" datasource="#dsn#">
	SELECT
		MONEY
	FROM
		SETUP_MONEY
	WHERE
		COMPANY_ID = #session.ep.company_id# AND
		PERIOD_ID = #session.ep.period_id# AND
		RATE2 = 1 AND
		RATE1 = 1
</cfquery>
<cfquery name="get_price_cats" datasource="#dsn3#">
	SELECT
		PRICE_CAT.PRICE_CATID,
		PRICE_CAT.PRICE_CAT,
		PRICE_CAT.NUMBER_OF_INSTALLMENT,
		PRICE_CAT.AVG_DUE_DAY,
		PRICE_CAT.DUE_DIFF_VALUE,
		PRICE.PRICE,
		PRICE.MONEY,
		PRICE.CATALOG_ID
	FROM
		PRICE_CAT,
		PRICE
		<cfif not isdefined("attributes.product_id") and isdefined("attributes.stock_id")>
			,STOCKS
		</cfif>
	WHERE
		PRICE_CAT.PRICE_CAT_STATUS = 1 AND
		PRICE_CAT.PRICE_CATID = PRICE.PRICE_CATID AND
		PRICE.STARTDATE <= #now()# AND
		ISNULL(PRICE.STOCK_ID,0)=0 AND
		ISNULL(PRICE.SPECT_VAR_ID,0)=0 AND
		(PRICE.FINISHDATE >= #now()# OR PRICE.FINISHDATE IS NULL)
		<cfif isdefined("attributes.product_id")>
			AND PRICE.PRODUCT_ID = #attributes.product_id#
		<cfelseif isdefined("attributes.stock_id")> 
			AND STOCKS.STOCK_ID = #attributes.stock_id#
			AND PRICE.PRODUCT_ID = STOCKS.PRODUCT_ID
		</cfif>
		<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
			AND PRICE_CAT.PAYMETHOD = 4
		<cfelseif isdefined("attributes.paymethod_vehicle") and len(attributes.paymethod_vehicle)>
			AND PRICE_CAT.PAYMETHOD = #attributes.paymethod_vehicle#
		</cfif>
		<cfif (isdefined("attributes.var_") and (session.ep.isBranchAuthorization) or (isdefined('attributes.is_store_module'))>
			AND PRICE_CAT.BRANCH LIKE '%,#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#,%'
		</cfif>
	ORDER BY
		NUMBER_OF_INSTALLMENT,PRICE_CAT
</cfquery>
<cfloop query="get_moneys">
	<cfif get_moneys.money is attributes.money_type>
		<cfset row_money = get_moneys.money>
		<cfset row_money_rate1 = get_moneys.rate1>
		<cfset row_money_rate2 = get_moneys.rate2>
	</cfif>
</cfloop>
<cfset pro_price = get_product.price>
<div style="float:right"><a href="javascript://" onClick="close_div(<cfoutput>'#attributes.no#'</cfoutput>);"><img src="/images/closethin.gif" border="0" title="<cf_get_lang dictionary_id='57553.Kapat'>"></a></div>
<table cellpadding="2" cellspacing="1" class="color-header">
	<tr class="color-list" height="22">
		<td width="200" class="txtboldblue"><cf_get_lang dictionary_id="58964.Fiyat Listesi"></td>
		<td width="40"  nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="32505.Taksit"></td>
		<td width="40"  nowrap class="txtboldblue" style="text-align:right;">O.<cf_get_lang dictionary_id="57640.Vade"></font></td>
		<td width="60"  nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="33001.VFarkı">%</td>
		<td width="100"  nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="58084.Fiyat"></td>
	</tr>
	<cfoutput>
		<cfscript>
			musteri_flt_other_money_value = pro_price;
			musteri_str_other_money = row_money;
			if(session.ep.period_year lt 2009 and row_money is 'TL')
				musteri_row_money='YTL';
			else
				musteri_row_money=row_money;

			musteri_flag_prc_other = 1;
			musteri_pro_price = pro_price*(row_money_rate2/row_money_rate1);
			musteri_str_other_money = get_default_money.money;
		</cfscript>
		<cfif not ((isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)) or (isdefined("attributes.paymethod_vehicle") and len(attributes.paymethod_vehicle)))>
		<tr height="20" class="color-row">
			<td><cf_get_lang dictionary_id="58721.Standart Satış"></td>
			<td></td><td></td><td></td>
			<td  style="text-align:right;">
				<cfif isdefined("attributes.is_add_basket") and (attributes.basket_zero_stock_ eq 1 or attributes.usable_stock_amount_ gt 0 or (attributes.usable_stock_amount_ lte 0 and (get_product.IS_ZERO_STOCK eq 1 or (isdefined('attributes.int_basket_id_') and len(attributes.int_basket_id_) and ( (attributes.int_basket_id_ eq 4 and get_product.IS_PRODUCTION eq 1) or ((listfind('10,21,48',attributes.int_basket_id_) or (listfind('52,53,62',spt_process_type))) and get_product.IS_INVENTORY eq 1))))))>
					<a href="##" onClick="sepete_ekle(1,'#attributes.product_id#','#get_product.stock_id#','#get_product.stock_code#','#get_product.barcod#','#get_product.manufact_code#','#get_product.product_name# #get_product.property#','#get_product.product_unit_id#','#get_product.add_unit#','#get_product.PRODUCT_CODE#',1,'#get_product.IS_SERIAL_NO#','#musteri_flag_prc_other#','1','#get_product.tax#','#get_product.otv#','#musteri_flt_other_money_value#','#musteri_row_money#','#listgetat(session.ep.user_location,1,'-')#','#department_name_#','#get_product.IS_INVENTORY#','#get_product.MULTIPLIER#',<cfif len(attributes.promotion_id)>'#attributes.promotion_id#'<cfelse>''</cfif>,<cfif len(attributes.prom_discount)>'#attributes.prom_discount#'<cfelse>''</cfif>,<cfif len(attributes.prom_cost)>'#attributes.prom_cost#'<cfelse>''</cfif>,<cfif len(attributes.prom_limit_value)>'#attributes.prom_limit_value#'<cfelse>''</cfif>,<cfif len(attributes.prom_gift_info)>'#attributes.prom_gift_info#'<cfelse>''</cfif>,'',
					'#get_product.IS_PRODUCTION#','','','-2','','','','#musteri_flt_other_money_value#','')">							
						#Tlformat(pro_price)# #row_money#
					</a>
				<cfelse>
					#Tlformat(pro_price)# #row_money#
				</cfif>
			</td>
		</tr>
		</cfif>
	</cfoutput>
	<cfif get_price_cats.recordcount>
		<cfoutput query="get_price_cats">
			<cfscript>
				row_price_catalog_id='';
				if(len(PRICE))
				{ 
					musteri_pro_price = PRICE; 
					if(session.ep.period_year lt 2009 and row_money is 'TL')
						musteri_row_money='YTL';
					else
						musteri_row_money=row_money;
					if(len(CATALOG_ID)) row_price_catalog_id =CATALOG_ID; 
				}
				else
				{ 
					musteri_pro_price = 0;
					musteri_row_money =	get_default_money.money;
				}
			</cfscript>
			<cfloop query="get_moneys">
				<cfif get_moneys.money is musteri_row_money>
					<cfset musteri_row_money_rate1 = get_moneys.rate1>
					<cfset musteri_row_money_rate2 = get_moneys.rate2>
				</cfif>
			</cfloop>				
			<cfscript>
				if(musteri_row_money is get_default_money.money)
				{
					musteri_str_other_money = musteri_row_money; 
					musteri_flt_other_money_value = musteri_pro_price;	
					musteri_flag_prc_other = 0;
				}
				else
				{
					musteri_flag_prc_other = 1 ;
					musteri_str_other_money = musteri_row_money; 
					musteri_flt_other_money_value = musteri_pro_price;
					musteri_pro_price = musteri_pro_price*(musteri_row_money_rate2/musteri_row_money_rate1);
				}
			</cfscript>
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#price_cat#</td>
				<td  style="text-align:right;">#number_of_installment#</td>
				<td  style="text-align:right;">#avg_due_day#</td>
				<td  style="text-align:right;">#tlformat(due_diff_value)#</td>
				<td  style="text-align:right;">
					<cfif isdefined("attributes.is_add_basket") and (attributes.basket_zero_stock_ eq 1 or attributes.usable_stock_amount_ gt 0 or (attributes.usable_stock_amount_ lte 0 and (get_product.IS_ZERO_STOCK eq 1 or (isdefined('attributes.int_basket_id_') and len(attributes.int_basket_id_) and ( (attributes.int_basket_id_ eq 4 and get_product.IS_PRODUCTION eq 1) or ((listfind('10,21,48',attributes.int_basket_id_) or (listfind('52,53,62',spt_process_type))) and get_product.IS_INVENTORY eq 1))))))>
						<a href="##" onClick="sepete_ekle(1,'#attributes.product_id#','#get_product.stock_id#','#get_product.stock_code#','#get_product.barcod#','#get_product.manufact_code#','#get_product.product_name# #get_product.property#','#get_product.product_unit_id#','#get_product.add_unit#','#get_product.PRODUCT_CODE#',1,'#get_product.IS_SERIAL_NO#','#musteri_flag_prc_other#','1','#get_product.tax#','#get_product.otv#','#musteri_flt_other_money_value#','#musteri_row_money#','#listgetat(session.ep.user_location,1,'-')#','#department_name_#','#get_product.IS_INVENTORY#','#get_product.MULTIPLIER#',<cfif len(attributes.promotion_id)>'#attributes.promotion_id#'<cfelse>''</cfif>,<cfif len(attributes.prom_discount)>'#attributes.prom_discount#'<cfelse>''</cfif>,<cfif len(attributes.prom_cost)>'#attributes.prom_cost#'<cfelse>''</cfif>,<cfif len(attributes.prom_limit_value)>'#attributes.prom_limit_value#'<cfelse>''</cfif>,<cfif len(attributes.prom_gift_info)>'#attributes.prom_gift_info#'<cfelse>''</cfif>,'',
						'#get_product.IS_PRODUCTION#','','','#price_catid#','','',<cfif len(avg_due_day)>'#avg_due_day#'<cfelse>''</cfif>,'#musteri_flt_other_money_value#','#number_of_installment#','','#row_price_catalog_id#')">							
							#Tlformat(price)# #money#
						</a>
					<cfelse>
						#Tlformat(price)# #money#
					</cfif>
				</td>
			</tr>
		</cfoutput>
	</cfif>
</table>


