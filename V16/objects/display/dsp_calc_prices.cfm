<!--- SM 20071016 Taksitli Urun Popupından açılan div deki sayfa. Her Ürün İçin ödeme yöntemlerine göre yeni fiyatları dinamik olarak hesaplayıp getiriyor. --->
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
<cfquery name="get_price_expections" datasource="#dsn3#">
	SELECT
		*
	FROM 
		PRICE_CAT_EXCEPTIONS
	WHERE
		ISNULL(IS_GENERAL,0)=0 AND
		ACT_TYPE = 1 AND 
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		COMPANY_ID = #attributes.company_id#
	<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		CONSUMER_ID = #attributes.consumer_id#
	<cfelse>
		1=0
	</cfif>	
</cfquery>
<cfquery name="get_price_exception_pid" dbtype="query">
	SELECT * FROM get_price_expections WHERE PRODUCT_ID IS NOT NULL
</cfquery>
<cfquery name="get_price_exception_pcatid" dbtype="query">
	SELECT * FROM get_price_expections WHERE PRODUCT_CATID IS NOT NULL
</cfquery>
<cfquery name="get_price_exception_brid" dbtype="query">
	SELECT * FROM get_price_expections WHERE BRAND_ID IS NOT NULL
</cfquery>
<cfif isdefined("attributes.search_process_date") and isdate(attributes.search_process_date)>
	<cfset price_date_ = attributes.search_process_date>
	<cf_date tarih='price_date_'>
<cfelse>
	<cfset price_date_ = now()>
</cfif>
<cfquery name="get_price_all_" datasource="#DSN3#">
	SELECT  
		P.UNIT,
		P.PRICE,
		P.PRODUCT_ID,
		P.MONEY,
		P.PRICE_CATID,
		P.CATALOG_ID
	FROM 
		PRICE P,
		PRODUCT PR
	WHERE 
		P.PRODUCT_ID = PR.PRODUCT_ID AND
		ISNULL(P.STOCK_ID,0)=0 AND 
		ISNULL(P.SPECT_VAR_ID,0)=0 AND 
		P.PRICE_CATID = #attributes.price_catid# AND
		(
			P.STARTDATE <= #price_date_# AND
			(P.FINISHDATE >= #price_date_# OR P.FINISHDATE IS NULL)
		)
		<cfif get_price_exception_pid.recordcount or get_price_exception_pcatid.recordcount or get_price_exception_brid.recordcount>
			<cfif get_price_exception_pid.recordcount>
			AND	P.PRODUCT_ID NOT IN (#valuelist(get_price_exception_pid.PRODUCT_ID)#)
			</cfif>
			<cfif get_price_exception_pcatid.recordcount>
			AND PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exception_pcatid.PRODUCT_CATID)#)
			</cfif>
			<cfif get_price_exception_brid.recordcount>
			AND ( PR.BRAND_ID NOT IN (#valuelist(get_price_exception_brid.BRAND_ID)#) OR PR.BRAND_ID IS NULL )
			</cfif>
		</cfif>
		<cfif isdefined("attributes.spt_process_type") and (attributes.spt_process_type neq -1)>
			<cfif ListFind("56,561,58,60,63",attributes.spt_process_type)>
				AND PR.IS_INVENTORY = 0
			</cfif>
		</cfif>						
	<cfif get_price_exception_pid.recordcount>
	UNION
	SELECT  
		UNIT,
		PRICE,
		PRODUCT_ID,
		MONEY,
		PRICE_CATID,
		CATALOG_ID
	FROM 
		PRICE
	WHERE 
		STARTDATE <= #price_date_# AND
		(FINISHDATE >= #price_date_# OR FINISHDATE IS NULL) AND
		ISNULL(STOCK_ID,0)=0 AND 
		ISNULL(SPECT_VAR_ID,0)=0 AND 
		<cfif get_price_exception_pid.recordcount gt 1>(</cfif>		
			<cfoutput query="get_price_exception_pid">		
			(PRODUCT_ID = #PRODUCT_ID# AND PRICE_CATID = #PRICE_CATID#)
			<cfif get_price_exception_pid.recordcount neq get_price_exception_pid.currentrow>
			OR
			</cfif>
			</cfoutput>
		<cfif get_price_exception_pid.recordcount gt 1>)</cfif>		
	</cfif>
	<cfif get_price_exception_pcatid.recordcount>
	UNION
	SELECT  
		P.UNIT,P.PRICE,P.PRODUCT_ID,P.MONEY,P.PRICE_CATID,P.CATALOG_ID
	FROM 
		PRICE P,
		PRODUCT PR
	WHERE 
		<cfif get_price_exception_pid.recordcount>
		P.PRODUCT_ID NOT IN (#valuelist(get_price_exception_pid.PRODUCT_ID)#) AND
		</cfif>
		P.PRODUCT_ID = PR.PRODUCT_ID AND 
		ISNULL(P.STOCK_ID,0)=0 AND 
		ISNULL(P.SPECT_VAR_ID,0)=0 AND 
		P.STARTDATE <= #price_date_# AND
		(P.FINISHDATE >= #price_date_# OR P.FINISHDATE IS NULL) AND
		<cfif get_price_exception_pcatid.recordcount gt 1>(</cfif>		
		<cfoutput query="get_price_exception_pcatid">		
		(PR.PRODUCT_CATID = #PRODUCT_CATID# AND P.PRICE_CATID = #PRICE_CATID#)
		<cfif get_price_exception_pcatid.recordcount neq get_price_exception_pcatid.currentrow>
		OR
		</cfif>
		</cfoutput>
		<cfif get_price_exception_pcatid.recordcount gt 1>)</cfif>		
	</cfif>
	<cfif get_price_exception_brid.recordcount>
	UNION
	SELECT  
		P.UNIT,P.PRICE,P.PRODUCT_ID,P.MONEY,P.PRICE_CATID,P.CATALOG_ID
	FROM 
		PRICE P,
		PRODUCT PR
	WHERE 
		<cfif get_price_exception_pid.recordcount>
		P.PRODUCT_ID NOT IN (#valuelist(get_price_exception_pid.PRODUCT_ID)#) AND
		</cfif>
		<cfif get_price_exception_pcatid.recordcount>
		PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exception_pcatid.PRODUCT_CATID)#) AND
		</cfif>
		P.PRODUCT_ID = PR.PRODUCT_ID AND 
		ISNULL(P.STOCK_ID,0)=0 AND 
		ISNULL(P.SPECT_VAR_ID,0)=0 AND 
		P.STARTDATE <= #price_date_# AND
		(P.FINISHDATE >= #price_date_# OR P.FINISHDATE IS NULL) AND
		<cfif get_price_exception_brid.recordcount gt 1>(</cfif>		
		<cfoutput query="get_price_exception_brid">		
		(PR.BRAND_ID = #BRAND_ID# AND P.PRICE_CATID = #PRICE_CATID#)
		<cfif get_price_exception_brid.recordcount neq get_price_exception_brid.currentrow>
		OR
		</cfif>
		</cfoutput>
		<cfif get_price_exception_brid.recordcount gt 1>)</cfif>		
	</cfif>
</cfquery>
<cfquery name="get_moneys" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		COMPANY_ID = #session.ep.company_id# AND
		PERIOD_ID = #session.ep.period_id# AND
		MONEY_STATUS = 1
</cfquery>
<cfquery name="get_default_money" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		COMPANY_ID = #session.ep.company_id# AND
		PERIOD_ID = #session.ep.period_id# AND
		RATE2= 1 AND
		RATE1= 1
</cfquery>
<cfoutput query="get_product">
	<cfloop query="get_moneys">
		<cfif get_moneys.money is attributes.money_type>
			<cfset row_money = get_moneys.money >
			<cfset row_money_rate1 = get_moneys.rate1 >
			<cfset row_money_rate2 = get_moneys.rate2 >
		</cfif>
	</cfloop>
	<cfset pro_price = get_product.price>
	<cfset row_price_catalog_id =''>
	<cfif attributes.price_catid neq -2>
		<cfquery name="get_p_" dbtype="query">
			SELECT * FROM get_price_all_ WHERE UNIT = #get_product.PRODUCT_UNIT_ID[currentrow]# AND PRODUCT_ID = #PRODUCT_ID#
		</cfquery>
		<cfscript>
			price_cat_id = get_p_.price_catid;
			if(len(get_p_.PRICE))
			{ 
				musteri_pro_price = get_p_.PRICE; 
				if(session.ep.period_year lt 2009 and len(get_p_.MONEY) and get_p_.MONEY is 'TL')
					musteri_row_money=session.ep.money;
				else
					musteri_row_money=get_p_.MONEY;
				if(len(get_p_.CATALOG_ID)) row_price_catalog_id =get_p_.CATALOG_ID; 
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
	<cfelse>
		<cfscript>
			price_cat_id = -2;
			musteri_flt_other_money_value = pro_price;
			musteri_str_other_money = row_money;
			musteri_row_money = row_money;

			musteri_flag_prc_other = 1;
			musteri_pro_price = pro_price*(row_money_rate2/row_money_rate1);
			musteri_str_other_money = get_default_money.money;
		</cfscript>
	</cfif>
</cfoutput>
<cfquery name="get_paymethods" datasource="#dsn#">
	SELECT 
		SP.* 
	FROM 
		SETUP_PAYMETHOD SP,
		SETUP_PAYMETHOD_OUR_COMPANY SPOC 
	WHERE 
		SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
		AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		AND SP.PAYMENT_VEHICLE IN(1,2)
</cfquery>
<table cellpadding="0" cellspacing="0" width="98%">
	<tr>
		<td width="10"></td>
		<td width="130"><font color="003399"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></font></td>
		<td width="70"><font color="003399"><cf_get_lang dictionary_id="57640.Vade"></font></td>
		<td width="70"><font color="003399"><cf_get_lang dictionary_id="58501.Vade Farkı"></font></td>
		<td width="70"><font color="003399"><cf_get_lang dictionary_id="33002.Ek Tutar"></font></td>
		<td width="250"><font color="003399"><cf_get_lang dictionary_id="33003.Vade Farklı Fiyatı"></font></td>
		<td width="50"  style="text-align:right;">
			<a href="javascript://" onClick="close_div(<cfoutput>'#attributes.no#'</cfoutput>);"><cf_get_lang dictionary_id="57553.Kapat"></a>
		</td>
	</tr>
	<cfif get_paymethods.recordcount>
		<cfoutput query="get_paymethods">
			<cfif len(due_date_rate)>
				<cfset new_value = attributes.price + wrk_round(attributes.price*due_date_rate/100)>
			<cfelse>
				<cfset new_value = attributes.price>
			</cfif>
			<cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id) and attributes.paymethod_id eq paymethod_id>
				<cfset color_value = "FF0000">
			<cfelse>
				<cfset color_value = "000000">
			</cfif>
			<cfset last_value = new_value-attributes.price>
			<tr height="20">
				<td></td>
				<td nowrap><font color="#color_value#">#paymethod#</font></td>
				<td nowrap><font color="#color_value#">#due_day#</font></td>
				<td nowrap><font color="#color_value#">% <cfif len(due_date_rate)>#Tlformat(due_date_rate)#<cfelse>0</cfif></font></td>
				<td nowrap><font color="#color_value#">#Tlformat(last_value)#</font></td>
				<td nowrap>
					<cfif isdefined("attributes.is_add_basket") and (attributes.basket_zero_stock_ eq 1 or attributes.usable_stock_amount_ gt 0 or (attributes.usable_stock_amount_ lte 0 and (get_product.IS_ZERO_STOCK eq 1 or (isdefined('attributes.int_basket_id_') and len(attributes.int_basket_id_) and ( (attributes.int_basket_id_ eq 4 and get_product.IS_PRODUCTION eq 1) or ((listfind('10,21,48',attributes.int_basket_id_) or (listfind('52,53,62',spt_process_type))) and get_product.IS_INVENTORY eq 1))))))>
						<a href="##" onClick="sepete_ekle(1,'#attributes.product_id#','#get_product.stock_id#','#get_product.stock_code#','#get_product.barcod#','#get_product.manufact_code#','#get_product.product_name# #get_product.property#','#get_product.product_unit_id#','#get_product.add_unit#','#get_product.PRODUCT_CODE#',1,'#get_product.IS_SERIAL_NO#','#musteri_flag_prc_other#','1','#get_product.tax#','#get_product.otv#','#musteri_flt_other_money_value#','#musteri_row_money#','#listgetat(session.ep.user_location,1,'-')#','#department_name_#','#get_product.IS_INVENTORY#','#get_product.MULTIPLIER#',<cfif len(attributes.promotion_id)>'#attributes.promotion_id#'<cfelse>''</cfif>,<cfif len(attributes.prom_discount)>'#attributes.prom_discount#'<cfelse>''</cfif>,<cfif len(attributes.prom_cost)>'#attributes.prom_cost#'<cfelse>''</cfif>,<cfif len(attributes.prom_limit_value)>'#attributes.prom_limit_value#'<cfelse>''</cfif>,<cfif len(attributes.prom_gift_info)>'#attributes.prom_gift_info#'<cfelse>''</cfif>,'',
						'#get_product.IS_PRODUCTION#','#last_value#','','#price_cat_id#','','',<cfif len(due_day)>'#due_day#'<cfelse>''</cfif>,'#musteri_flt_other_money_value#','','','#row_price_catalog_id#');change_due_value('#paymethod_id#','#paymethod#','#due_day#');">							
							<font color="#color_value#">#Tlformat(new_value)# #attributes.price_money#</font>
						</a>
					<cfelse>
						<font color="#color_value#">#Tlformat(new_value)# #attributes.price_money#</font>
					</cfif>
				</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr><td width="10"></td><td height="20" colspan="6"><cf_get_lang dictionary_id="33007.Çek ve Senet İçin Ödeme Yöntemi Tanımlanmamış">!</td></tr>
	</cfif>
</table>
