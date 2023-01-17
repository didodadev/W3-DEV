<cfquery name="get_cat_prom_actions" datasource="#DSN3#">
	SELECT
		EXTRA_PRICE_CATID,
		CATALOG_HEAD,
		CATALOG_ID,
		STARTDATE,
		FINISHDATE
	FROM
		CATALOG_PROMOTION
	WHERE
		CATALOG_ID = #attributes.catalog_id#
</cfquery>
<cfquery name="GET_CATALOG_PRODUCTS" datasource="#DSN3#">
	SELECT 
		P.PRODUCT_ID,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,		
		CP.EXTRA_PRICEKDV_1,
		CP.EXTRA_PRICEKDV_2,
		CP.EXTRA_PRICEKDV_3,
		P.TAX,
		CP.SALE_MONEY_TYPE AS MONEY
	FROM 
		CATALOG_PROMOTION_PRODUCTS CP, 
		PRODUCT P,
		PRODUCT_UNIT
	WHERE 
		CP.CATALOG_ID = #attributes.catalog_id# AND
		PRODUCT_UNIT.IS_MAIN = 1 AND 
		PRODUCT_UNIT.PRODUCT_ID = P.PRODUCT_ID AND
		P.PRODUCT_ID = CP.PRODUCT_ID AND
		CP.SALE_TYPE_INFO IN(1,5)
</cfquery>
<cfset cat_prom_prod_list = "#ValueList(GET_CATALOG_PRODUCTS.PRODUCT_ID)#">
<cfif len(cat_prom_prod_list)>
	<cf_get_lang no ='864.Fiyat Oluşturma İşlemi Başladı, Lütfen Bekleyiniz'>...<br/><br/>
	<cflock name="#createuuid()#" timeout="60">
		<cftransaction>
			<cfquery name="add_del_rows" datasource="#DSN3#">
				INSERT INTO 
					PRICE_DELETED_ROWS
					(PRICE_ID,PRICE_CATID,PRODUCT_ID,FINISHDATE,STARTDATE,PRICE,PRICE_KDV,PRICE_DISCOUNT,IS_KDV,ROUNDING,UNIT,MONEY,CATALOG_ID,PRICE_RECORD_DATE,PRICE_RECORD_EMP,PRICE_RECORD_IP,RECORD_DATE,RECORD_IP,RECORD_EMP)
				SELECT 
					PRICE_ID,PRICE_CATID,PRODUCT_ID,FINISHDATE,STARTDATE,PRICE,PRICE_KDV,PRICE_DISCOUNT,IS_KDV,ROUNDING,UNIT,MONEY,CATALOG_ID,RECORD_DATE,RECORD_EMP,RECORD_IP,#now()#,'#remote_addr#',#session.ep.userid#
				FROM 
					PRICE 
				WHERE 
					PRODUCT_ID IN (#cat_prom_prod_list#) AND
					ISNULL(STOCK_ID,0) = 0 AND
					ISNULL(SPECT_VAR_ID,0) = 0 AND
					PRICE_CATID IN (#get_cat_prom_actions.extra_price_catid#) AND
					STARTDATE >= #CreateODBCDateTime(get_cat_prom_actions.startdate)# AND 
					STARTDATE <= #CreateODBCDateTime(get_cat_prom_actions.finishdate)#				
			</cfquery>
			<cfquery name="del_cat_prom_prod_price_ALL" datasource="#DSN3#">
				DELETE FROM 
					PRICE 
				WHERE 
					PRODUCT_ID IN (#cat_prom_prod_list#) AND
					ISNULL(STOCK_ID,0)=0 AND
					ISNULL(SPECT_VAR_ID,0)=0 AND
					PRICE_CATID IN (#get_cat_prom_actions.EXTRA_PRICE_CATID#) AND
					STARTDATE >= #CreateODBCDateTime(get_cat_prom_actions.STARTDATE)# AND 
					STARTDATE <= #CreateODBCDateTime(get_cat_prom_actions.FINISHDATE)#
			</cfquery>
			<cfquery name="del_cat_prom_prod_history_price_ALL" datasource="#DSN3#">
				DELETE FROM 
					PRICE_HISTORY 
				WHERE 
					PRODUCT_ID IN (#cat_prom_prod_list#) AND
					ISNULL(STOCK_ID,0)=0 AND
					ISNULL(SPECT_VAR_ID,0)=0 AND
					PRICE_CATID IN (#get_cat_prom_actions.EXTRA_PRICE_CATID#) AND
					STARTDATE >= #CreateODBCDateTime(get_cat_prom_actions.STARTDATE)# AND 
					STARTDATE <= #CreateODBCDateTime(get_cat_prom_actions.FINISHDATE)#
			</cfquery>
			<cfoutput query="GET_CATALOG_PRODUCTS">
				<cfloop from="1" to="3" index="kk">
					<cfif len(evaluate("GET_CATALOG_PRODUCTS.EXTRA_PRICEKDV_#kk#")) and evaluate("GET_CATALOG_PRODUCTS.EXTRA_PRICEKDV_#kk#") gt 0>
						<cfscript>
							end_price = wrk_round(((evaluate("GET_CATALOG_PRODUCTS.EXTRA_PRICEKDV_#kk#") * 100) / (TAX + 100)) ,session.ep.our_company_info.sales_price_round_num);
							add_price(
								product_id : PRODUCT_ID,
								product_unit_id : PRODUCT_UNIT_ID,
								price_cat : listgetat(get_cat_prom_actions.EXTRA_PRICE_CATID,kk,','),
								start_date : CreateODBCDateTime(get_cat_prom_actions.STARTDATE),
								price : end_price,
								price_money : MONEY,
								price_with_kdv : wrk_round(evaluate("GET_CATALOG_PRODUCTS.EXTRA_PRICEKDV_#kk#"),session.ep.our_company_info.sales_price_round_num),
								is_kdv : 1,
								catalog_id : get_cat_prom_actions.CATALOG_ID,
								price_discount: 0						
								);
						</cfscript>				
					</cfif>
				</cfloop>
			</cfoutput>
		</cftransaction>
	</cflock>
	<cfquery name="UPD_CATALOG" datasource="#DSN3#">
		UPDATE
			CATALOG_PROMOTION
		SET
			IS_APPLIED = 1,
			VALIDATE_DATE = #now()#,
			VALID_EMP = #session.ep.userid#,
			VALID = 1
		WHERE
			CATALOG_ID = #attributes.catalog_id#
	</cfquery>
	<br/>
	<cf_get_lang no ='866.Fiyat oluşturma işlemi tamamen bitti'> !!!<br/>	
</cfif>

