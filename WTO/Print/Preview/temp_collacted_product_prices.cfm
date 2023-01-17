<cfsetting showdebugoutput="no">
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID#
</cfquery>

<cfquery name="GET_EMP_POSITION_CAT_ID" datasource="#DSN#">
	SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
</cfquery>
<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
	SELECT 
		* 
	FROM 
		PRICE_CAT
	WHERE
		PRICE_CATID IS NOT NULL AND
		PRICE_CAT_STATUS = 1
	<cfif session.ep.isBranchAuthorization>
		AND BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#,%">
	</cfif>
	<cfif isDefined("attributes.pcat_id") and len(attributes.pcat_id)>
		AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pcat_id#">
	</cfif>
	<!--- Pozisyon tipine gore yetki veriliyor  --->
	<cfif isDefined("xml_related_position_cat") and xml_related_position_cat eq 1>
		AND POSITION_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_emp_position_cat_id.position_cat_id#,%">
	</cfif>
	<!--- //Pozisyon tipine gore yetki veriliyor  --->
	ORDER BY
		PRICE_CAT
</cfquery>

<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_catid" default="0">
<cfparam name="attributes.get_company_id" default="">
<cfparam name="attributes.get_company" default="">
<cfparam name="attributes.is_active" default="-2">
<cfparam name="attributes.rec_date" default="">
<cfparam name="attributes.price_rec_date" default="">
<cfparam name="attributes.brand_id" default="">
<cfif isdefined('attributes.rec_date') and len(attributes.rec_date)><cf_date tarih='attributes.rec_date'></cfif>
<cfif isdefined('attributes.price_rec_date') and len(attributes.price_rec_date)><cf_date tarih='attributes.price_rec_date'></cfif>
	<cfif attributes.is_active eq -1>
		<cfset title = '#getLang('main',1310)#'>
	<cfelseif attributes.is_active eq -2>
		<cfset title = '#getLang('main',1309)#'>
	</cfif>
	<cfoutput query="get_price_cat"> 
		<cfif (price_catid is attributes.is_active)>#price_cat#</cfif>
	</cfoutput>
<!-- sil --> 
<!-- sil --><cf_box>
<cfoutput>
	
<table width="100%" cellpadding="2" cellspacing="1">
	<tr>
		<td class="formbold" width="130"><cf_get_lang dictionary_id='57567.Ürün Kategorisi'></td>
		<td>: #attributes.product_cat#</td>
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
		<td>: 
			<cfif isdefined('attributes.price_rec_date') and len(attributes.price_rec_date)>
				#dateformat(attributes.price_rec_date,dateformat_style)#
			<cfelse>
				#dateformat(now(),dateformat_style)#
			</cfif>
		</td>
	</tr>
</table>
</cfoutput>
<cf_grid_list>
	<thead>
		<tr height="25" class="formbold">
			<th colspan="2">&nbsp;</th>
			<th colspan="2" align="center"><cf_get_lang dictionary_id='37045.Marj'></th>
			<th colspan="2" align="center"><cf_get_lang dictionary_id='37041.Alış Fiyatları'> - <cf_get_lang dictionary_id='57489.Para Birimi'></th>
			<th colspan="3" align="center"><cf_get_lang dictionary_id='37419.Liste Fiyatı'> - <cf_get_lang dictionary_id='57639.KDV'> - <cf_get_lang dictionary_id='57489.Para Birimi'></th>
			<th colspan="2">&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
	<thead>
	<thead>
		<tr height="22" class="txtbold">
			<th><cf_get_lang dictionary_id='57657.Ürün'></th>
			<th width="40"><cf_get_lang dictionary_id='57633.Barcod'></th>
			<th width="45"><cf_get_lang dictionary_id='57486.Kategori'></th>
			<th width="40"><cf_get_lang dictionary_id='57636.Birim'></th>
			<th width="25"><cf_get_lang dictionary_id='37375.Max'></th>
			<th width="25"><cf_get_lang dictionary_id='37374.Min'></th>
			<th width="100" align="right" style="text-align:right;"><cf_get_lang dictionary_id='37227.Standart'></th>
			<th width="100" align="right" style="text-align:right;"><cf_get_lang dictionary_id='37380.İskontolu KDV li'></th>
			<th width="90" align="right" style="text-align:right;"><cf_get_lang dictionary_id='57448.Satış'></th>
			<th width="25"><cf_get_lang dictionary_id='57639.KDV'></th>
			<th width="90" align="right" style="text-align:right;"><cf_get_lang dictionary_id='58716.KDV li'></th>
			<th width="30"><cf_get_lang dictionary_id='37045.Marj'></th>
		</tr>
	</thead>
	<cfif isDefined("attributes.product_catid") and len(attributes.product_catid)>
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
			P.PRODUCT_NAME, 
			P.RECORD_DATE, 
			P.PRODUCT_CODE,
			P.PRODUCT_ID,
			P.TAX,
			P.TAX_PURCHASE,
			P.MAX_MARGIN,
			P.MIN_MARGIN,
			PU.PRODUCT_UNIT_ID,
			PU.MAIN_UNIT,
			P.BARCOD,
			PC.PRODUCT_CAT
		FROM 
			PRODUCT P,
			PRODUCT_UNIT PU ,
			 PRODUCT_CAT PC
		WHERE 
			P.PRODUCT_STATUS = 1 AND
			P.PRODUCT_ID = PU.PRODUCT_ID AND
			PU.IS_MAIN = 1 AND
			PC.PRODUCT_CATID = P.PRODUCT_CATID
		<cfif len(attributes.product_cat)>
			AND P.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
		</cfif>
		<cfif len(attributes.employee) and len(attributes.pos_code)>
			AND P.PRODUCT_MANAGER=#attributes.pos_code#
		</cfif>
		<cfif len(attributes.get_company) and len(attributes.get_company_id)>
			AND P.COMPANY_ID = #attributes.get_company_id#
		</cfif>
		<cfif len(attributes.rec_date)>
			AND P.RECORD_DATE >= #attributes.rec_date#
		</cfif>
		<cfif len(attributes.product_name)>
			AND P.PRODUCT_NAME LIKE '%#attributes.product_name#%'
		</cfif>
		<cfif len(attributes.product_name)>
			AND P.PRODUCT_NAME LIKE '%#attributes.product_name#%'
		</cfif>
		<cfif attributes.is_active eq -1>
			AND P.IS_PURCHASE = 1
		</cfif>
		ORDER BY 
			P.PRODUCT_NAME
	</cfquery>
	<cfif get_product.recordcount>
		<cfquery name="GET_PRODUCT_P_DISCOUNT_ALL" datasource="#DSN3#">
			SELECT
				CPPD.DISCOUNT1,
				CPPD.DISCOUNT2,
				CPPD.DISCOUNT3,
				CPPD.DISCOUNT4,
				CPPD.DISCOUNT5,
				CPPD.PRODUCT_ID,
				CPPD.RECORD_DATE
			FROM
				CONTRACT_PURCHASE_PROD_DISCOUNT CPPD,
				PRODUCT PR
			WHERE
				CPPD.PRODUCT_ID = PR.PRODUCT_ID AND
				PR.PRODUCT_STATUS = 1
			<cfif len(attributes.product_cat) and len(attributes.product_catid)>
				AND PR.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
			</cfif>
			<cfif len(attributes.employee) and len(attributes.employee_id)>
				AND PR.PRODUCT_MANAGER = #attributes.employee_id#
			</cfif>
			<cfif len(attributes.get_company) and len(attributes.get_company_id)>
				AND PR.COMPANY_ID = #attributes.get_company_id#
			</cfif>
			<!--- BK ekledi 20080515 ustteki get_product ile ayni olmasi adina --->
			<cfif len(attributes.brand_id) and len(attributes.brand_name)>
				AND PR.BRAND_ID = #attributes.brand_id#
			</cfif>
			<cfif len(attributes.rec_date)>
				AND PR.RECORD_DATE >= #attributes.rec_date#
			</cfif>
			<cfif len(attributes.product_name)>
				AND PR.PRODUCT_NAME LIKE '%#attributes.product_name#%'
			</cfif>
			<cfif attributes.is_active eq -1>
				AND PR.IS_PURCHASE = 1
			</cfif>
			ORDER BY 
				CPPD.START_DATE DESC
		</cfquery>
		<cfquery name="GET_PRICE_STANDART_ALL" datasource="#DSN3#">
			SELECT
				PS.MONEY,
				PS.PRICE,
				PS.PRICE_KDV,
				PS.IS_KDV,
				PS.PRODUCT_ID,
				PS.PURCHASESALES,
				PS.PRICESTANDART_STATUS,
				PS.UNIT_ID,
				PS.START_DATE,
				PS.RECORD_DATE
			FROM
				PRICE_STANDART PS,
				PRODUCT PR,
				PRODUCT_UNIT PU
			WHERE
				PS.PRODUCT_ID = PR.PRODUCT_ID AND
				PR.PRODUCT_ID = PU.PRODUCT_ID AND
				PR.PRODUCT_STATUS = 1 AND
				PU.IS_MAIN = 1
			<cfif isdefined('attributes.price_rec_date') and len(attributes.price_rec_date)>
				AND PS.START_DATE <= #attributes.price_rec_date#
			<cfelse>
				AND PS.PRICESTANDART_STATUS = 1
			</cfif>
			<cfif len(attributes.product_cat) and len(attributes.product_catid)>
				AND PR.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
			</cfif>
			<cfif len(attributes.employee) and len(attributes.employee_id)>
				AND PR.PRODUCT_MANAGER=#attributes.employee_id#
			</cfif>
			<cfif len(attributes.get_company) and len(attributes.get_company_id)>
				AND PR.COMPANY_ID = #attributes.get_company_id#
			</cfif>
			<!--- BK ekledi 20080515 ustteki get_product ile ayni olmasi adina --->
			<cfif len(attributes.brand_id) and len(attributes.brand_name)>
				AND PR.BRAND_ID = #attributes.brand_id#
			</cfif>
			<cfif len(attributes.rec_date)>
				AND PR.RECORD_DATE >= #attributes.rec_date#
			</cfif>
			<cfif len(attributes.product_name)>
				AND PR.PRODUCT_NAME LIKE '%#attributes.product_name#%'
			</cfif>
			<cfif attributes.is_active eq -1>
				AND PR.IS_PURCHASE = 1
			</cfif>
		</cfquery>
		<cfif attributes.is_active neq -2>
			<cfquery name="GET_PRICE_STANDART_SALES_ALL" datasource="#DSN3#">
				SELECT
					P.MONEY,
					P.PRICE,
					P.PRICE_KDV,
					P.IS_KDV,
					P.PRODUCT_ID,
					P.PRICE_CATID,
					P.UNIT
				FROM
					PRICE P,
					PRODUCT PR,
					PRODUCT_UNIT PU
				WHERE
					P.PRODUCT_ID = PR.PRODUCT_ID AND
					PR.PRODUCT_ID = PU.PRODUCT_ID AND
					<!---ISNULL(P.STOCK_ID,0)=0 AND--->
					ISNULL(P.SPECT_VAR_ID,0)=0 AND
					P.STARTDATE <= #now()# AND
					(P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
					PR.PRODUCT_STATUS = 1 AND
					PU.IS_MAIN = 1
				<cfif len(attributes.product_cat) and len(attributes.product_catid)>
					AND PR.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
				</cfif>
				<cfif len(attributes.employee) and len(attributes.employee_id)>
					AND PR.PRODUCT_MANAGER=#attributes.employee_id#
				</cfif>
				<cfif len(attributes.get_company) and len(attributes.get_company_id)>
					AND PR.COMPANY_ID = #attributes.get_company_id#
				</cfif>
					AND P.PRICE_CATID = #attributes.is_active#
				<!--- BK ekledi 20080515 ustteki get_product ile ayni olmasi adina --->
				<cfif len(attributes.brand_id) and len(attributes.brand_name)>
					AND PR.BRAND_ID = #attributes.brand_id#
				</cfif>
				<cfif len(attributes.rec_date)>
					AND PR.RECORD_DATE >= #attributes.rec_date#
				</cfif>
				<cfif len(attributes.product_name)>
					AND PR.PRODUCT_NAME LIKE '%#attributes.product_name#%'
				</cfif>
				<cfif attributes.is_active eq -1>
					AND PR.IS_PURCHASE = 1
				</cfif>
			</cfquery>
		</cfif>
		<cfoutput query="GET_PRODUCT">
			<cfquery name="GET_PRODUCT_P_DISCOUNT" dbtype="query" maxrows="1">
				SELECT * FROM GET_PRODUCT_P_DISCOUNT_ALL WHERE PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID# ORDER BY RECORD_DATE DESC
			</cfquery>
			<cfquery name="GET_PRICE_STANDART_PURCHASE" dbtype="query" maxrows="1">
				SELECT
					MONEY,
					PRICE,
					PRICE_KDV
				FROM
					GET_PRICE_STANDART_ALL
				WHERE
				<cfif isdefined('attributes.price_rec_date') and len(attributes.price_rec_date)>
					START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.price_rec_date#"> AND
					START_DATE < <cfqueryparam cfsqltype="cf_sql_date" value="#DATEADD('d',1,attributes.price_rec_date)#"> AND
				<cfelse>
					PRICESTANDART_STATUS = 1 AND
				</cfif>
					PRODUCT_ID = #PRODUCT_ID# AND
					PURCHASESALES = 0 AND
					UNIT_ID = #PRODUCT_UNIT_ID#
			<cfif isdefined('attributes.price_rec_date') and len(attributes.price_rec_date)>
				ORDER BY 
					START_DATE DESC,
					RECORD_DATE DESC
			</cfif>
			</cfquery>
			<cfquery name="GET_PRICE_STANDART_SALES_COLUMN" dbtype="query" maxrows="1">
				SELECT
					MONEY,
					PRICE,
					PRICE_KDV,
					IS_KDV
				FROM
					GET_PRICE_STANDART_ALL
				WHERE
				<cfif isdefined('attributes.price_rec_date') and len(attributes.price_rec_date)>
					START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.price_rec_date#"> AND
					START_DATE < <cfqueryparam cfsqltype="cf_sql_date" value="#DATEADD('d',1,attributes.price_rec_date)#"> AND
				<cfelse>
					PRICESTANDART_STATUS = 1 AND
				</cfif>
					PRODUCT_ID = #PRODUCT_ID# AND
					PURCHASESALES = 1 AND
					UNIT_ID = #PRODUCT_UNIT_ID#
			<cfif isdefined('attributes.price_rec_date') and len(attributes.price_rec_date)>
				ORDER BY 
					START_DATE DESC,
					RECORD_DATE DESC
			</cfif>
			</cfquery>
			<cfif attributes.is_active eq -2>
				<cfquery name="GET_PRICE_STANDART_SALES" dbtype="query" maxrows="1">
					SELECT
						MONEY,
						PRICE,
						PRICE_KDV,
						IS_KDV
					FROM
						GET_PRICE_STANDART_ALL
					WHERE
					<cfif isdefined('attributes.price_rec_date') and len(attributes.price_rec_date)>
						START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.price_rec_date#"> AND
						START_DATE < <cfqueryparam cfsqltype="cf_sql_date" value="#DATEADD('d',1,attributes.price_rec_date)#"> AND
					<cfelse>
						PRICESTANDART_STATUS = 1 AND
					</cfif>
						PRODUCT_ID = #PRODUCT_ID# AND
						PURCHASESALES = 1 AND
						UNIT_ID = #PRODUCT_UNIT_ID#
				<cfif isdefined('attributes.price_rec_date') and len(attributes.price_rec_date)>
					ORDER BY 
						START_DATE DESC,
						RECORD_DATE DESC
				</cfif>
				</cfquery>
			<cfelse>
				<cfquery name="GET_PRICE_STANDART_SALES" dbtype="query">
					SELECT
						MONEY,
						PRICE,
						PRICE_KDV,
						IS_KDV
					FROM
						GET_PRICE_STANDART_SALES_ALL
					WHERE
						PRODUCT_ID = #PRODUCT_ID# AND 
						PRICE_CATID = #attributes.is_active# AND
						UNIT = #PRODUCT_UNIT_ID#
				</cfquery>
			</cfif>
			<cfscript>		  
				tax_alis_toplam = 0;
				kar_marj_deger = 0;
				
				if (len(get_product_p_discount.discount1))
					indirim_1_values = get_product_p_discount.discount1;
				else
					indirim_1_values = 0;
				if (len(get_product_p_discount.discount2))
					indirim_2_values = get_product_p_discount.discount2;
				else
					indirim_2_values = 0;
				if (len(get_product_p_discount.discount3))
					indirim_3_values = get_product_p_discount.discount3;
				else
					indirim_3_values = 0;
				if (len(get_product_p_discount.discount4))
					indirim_4_values = get_product_p_discount.discount4;
				else
					indirim_4_values = 0;
				if (len(get_product_p_discount.discount5))
					indirim_5_values = get_product_p_discount.discount5;
				else
					indirim_5_values = 0;
				if (not len(get_price_standart_purchase.price))
					tax_alis_toplam = 0;
				else
					tax_alis_toplam = get_price_standart_purchase.price;
				
				tax_alis_toplam = tax_alis_toplam * ((100 - indirim_1_values)/100);
				tax_alis_toplam = tax_alis_toplam * ((100 - indirim_2_values)/100);
				tax_alis_toplam = tax_alis_toplam * ((100 - indirim_3_values)/100);
				tax_alis_toplam = tax_alis_toplam * ((100 - indirim_4_values)/100);
				tax_alis_toplam = tax_alis_toplam * ((100 - indirim_5_values)/100);
				tax_alis_toplam = wrk_round(tax_alis_toplam);
				
				if ( (tax_alis_toplam neq 0) and len(get_price_standart_sales.price) and (get_price_standart_sales.price neq 0) )
					kar_marj_deger = wrk_round(((get_price_standart_sales.price-tax_alis_toplam)*100)/tax_alis_toplam);
				if (len(tax))
				tax_alis_toplam = tax_alis_toplam*((tax_purchase+100)/100);
				
				tax_alis_toplam = wrk_round(tax_alis_toplam);

				tax_satis_column = 0;
				if ( len(get_price_standart_sales_column.price) and len(get_price_standart_sales_column.price_kdv) and get_price_standart_sales_column.is_kdv )
					tax_satis_column = wrk_round(get_price_standart_sales_column.price_kdv);
				else if (len(get_price_standart_sales_column.price))
					tax_satis_column = wrk_round(get_price_standart_sales_column.price*((tax+100)/100));

				tax_satis_toplam = 0;
				if ( len(get_price_standart_sales.price) and len(get_price_standart_sales.price_kdv) and get_price_standart_sales.is_kdv )
					tax_satis_toplam = wrk_round(get_price_standart_sales.price_kdv);
				else if (len(get_price_standart_sales.price))
					tax_satis_toplam = wrk_round(get_price_standart_sales.price*((tax+100)/100));
			</cfscript>
			<cfif not len(attributes.price_rec_date) or (len(attributes.price_rec_date) and attributes.is_active eq -1 and get_price_standart_purchase.recordcount) or (len(attributes.price_rec_date) and attributes.is_active eq -2 and get_price_standart_sales_column.recordcount)>
				<tbody>
					<tr height="20">
						<td>#product_name#</td>
						<td>#barcod#</td>
						<td>#product_cat#</td>
						<td>#main_unit#</td>
						<td align="right" style="text-align:right;">#max_margin#&nbsp;</td>
						<td align="right" style="text-align:right;">#min_margin#&nbsp;</td>
						<td align="right" style="text-align:right;">#tlformat(get_price_standart_purchase.price)#</td>
						<td align="right" style="text-align:right;">#tlformat(tax_alis_toplam)# <cfloop query="get_money"><cfif money eq get_price_standart_purchase.money>#money#</cfif></cfloop></td>
						<td align="right" style="text-align:right;">#tlformat(get_price_standart_sales.price)#</td>
						<td align="center">#tax#</td>
						<td align="right" style="text-align:right;">#tlformat(tax_satis_toplam)# <cfloop query="get_money"><cfif money eq get_price_standart_sales.money>#money#</cfif></cfloop></td>
						<cfset red = "red">
						<cfset black = "black">
						<cfset blue = "blue">
						<td align="right" style="text-align:right;">#tlformat(kar_marj_deger)#</td>
					</tr>
				</tbody>
			</cfif>
		</cfoutput>       
	</cfif>
</cf_grid_list>
</cf_box>
<!-- sil -->

