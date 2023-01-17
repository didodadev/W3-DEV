
<cfif form.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang no ='862.İşlemin Muhasebe Dönemi İle Aktif Muhasebe Döneminiz Farklı'>...<cf_get_lang no ='863.Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=product.list_price_cat</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfsetting requestTimeout="2000">
<cfif isdefined('attributes.target_due_date') and isdate(attributes.target_due_date)>
	<cf_date tarih="attributes.target_due_date">
</cfif>

<cf_date tarih="attributes.startdate">
<cfset attributes.startdate = date_add("h",form.start_clock,attributes.startdate)>
<cfset attributes.startdate = date_add("n",form.start_min,attributes.startdate)>
<cfif isdefined	("product_finishdate")>
    <cf_date tarih="attributes.product_startdate">
    <cf_date tarih="attributes.product_finishdate">
    <cfset attributes.product_finishdate = date_add("d",1,attributes.product_finishdate)>
</cfif>


<cfquery name="UPD_PRICE_CAT" datasource="#DSN3#">
	UPDATE
		PRICE_CAT 
	SET 
		PRICE_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.price_cat#">,
		COMPANY_CAT =  <cfif isDefined("attributes.company_cat")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.company_cat#,"><cfelse>NULL</cfif>,
		CONSUMER_CAT = <cfif isDefined("attributes.consumer_cat")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.consumer_cat#,"><cfelse>NULL</cfif>,
		BRANCH = <cfif isDefined("attributes.branch")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.branch#,"><cfelse>NULL</cfif>,
		POSITION_CAT = <cfif isDefined("attributes.position_cat")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.position_cat#,"><cfelse>NULL</cfif>,
		<cfif isDefined("form.discount") and len(form.discount)>DISCOUNT = 	<cfqueryparam cfsqltype="cf_sql_float" value="#form.discount#">,</cfif>
		<cfif isDefined("form.margin") and len(form.margin) and isnumeric(form.margin)>
			TARGET_MARGIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.target_margin#">,
			MARGIN = <cfqueryparam cfsqltype="cf_sql_float" value="#form.margin#">,
		<cfelse>
			TARGET_MARGIN_ID = NULL,
			MARGIN = NULL,
		</cfif>
		<cfif isDefined("form.rounding") and len(form.rounding)>ROUNDING = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.rounding#">,</cfif>
		IS_KDV = <cfif isDefined('is_kdv')>1<cfelse>0</cfif>,
		STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">,
		NUMBER_OF_INSTALLMENT = <cfif len(attributes.number_of_installment)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.number_of_installment#"><cfelse>0</cfif>,
		AVG_DUE_DAY = <cfif len(attributes.avg_due_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.avg_due_day#"><cfelse>0</cfif>,
		DUE_DIFF_VALUE =<cfif len(attributes.due_diff_value)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.due_diff_value#"><cfelse>0</cfif>,
		EARLY_PAYMENT = <cfif len(attributes.early_payment)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.early_payment#"><cfelse>0</cfif>,
		PAYMETHOD = <cfif isdefined('attributes.paymethod') and len(attributes.paymethod)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod#"><cfelse>0</cfif>,
		TARGET_DUE_DATE = <cfif isdefined('attributes.target_due_date') and len(attributes.target_due_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.target_due_date#"><cfelse>NULL</cfif>,
		IS_CALC_PRODUCTCAT = <cfif isdefined("attributes.is_price_from_category")>1<cfelse>0</cfif>,
		IS_PURCHASE = <cfif isdefined("attributes.is_purchase")>1<cfelse>0</cfif>,
		IS_SALES = <cfif isdefined("attributes.is_sales")>1<cfelse>0</cfif>,
		PRICE_CAT_STATUS = <cfif isdefined("attributes.price_cat_status")>1<cfelse>0</cfif>,
		UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">		
	WHERE 
		PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pcat_id#"> 
</cfquery>
<cfif form.go_val is 0>
	<script type="text/javascript">
    	window.location.reload();
    </script>
<cfelse>
	<cfinclude template="../query/get_price_cat.cfm">
	<cfquery name="GET_PRODUCT" datasource="#DSN3#">
		SELECT 
			P.PRODUCT_ID,
			PU.PRODUCT_UNIT_ID,
			P.TAX,
			P.PRODUCT_CATID,
			S.STOCK_ID
		FROM 
			PRODUCT AS P,
			STOCKS S,
			PRODUCT_UNIT AS PU
		WHERE
			S.PRODUCT_ID = P.PRODUCT_ID AND
			P.PRODUCT_ID = PU.PRODUCT_ID AND
			PU.IS_MAIN = 1
            <cfif isdefined ("attributes.product_startdate") and len(attributes.product_startdate) and isdefined ("attributes.product_finishdate") and len(attributes.product_finishdate)>
            	AND P.RECORD_DATE BETWEEN #attributes.product_startdate# AND #attributes.product_finishdate#
            </cfif>       
	</cfquery>
    	<cflock name="#CreateUUID()#" timeout="70">
		<cftransaction>		
			<cfquery name="DELETE_PRICE_TO_OLD" datasource="#DSN3#">
				DELETE 
                FROM	PRICE 
                WHERE PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pcat_id#"> 
                      AND STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                      <cfif isdefined ("attributes.product_startdate") and len(attributes.product_startdate) and isdefined ("attributes.product_finishdate") and len(attributes.product_finishdate)>
                      AND PRODUCT_ID IN (SELECT 
                                            P.PRODUCT_ID
                                        FROM 
                                            PRODUCT AS P,
                                            PRODUCT_UNIT AS PU
                                        WHERE
                                            P.PRODUCT_ID = PU.PRODUCT_ID AND
                                            PU.IS_MAIN = 1
                                            <cfif isdefined ("attributes.product_startdate") and len(attributes.product_startdate) and isdefined ("attributes.product_finishdate") and len(attributes.product_finishdate)>
                                                AND P.RECORD_DATE BETWEEN #attributes.product_startdate# AND #attributes.product_finishdate#
                                            </cfif> 
                                         )
                     </cfif>
			</cfquery>			
			<cfloop from="1" to="#get_product.recordcount#" index="prd_index">				
				<cfif len(form.margin) or isdefined("attributes.is_price_from_category")>				
					<cfif form.target_margin eq -1><!--- standart alis fiyatina ekleme veya çıkarma --->
						<cfquery name="GET_PRICE" datasource="#DSN3#">
							SELECT 
								PRICE,
								MONEY 
							FROM
								PRICE_STANDART
							WHERE 
								PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_id[prd_index]#"> AND
								PRICESTANDART_STATUS = 1 AND
								PURCHASESALES = 0 AND
								UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_unit_id[prd_index]#">
						</cfquery>
					<cfelseif  form.target_margin eq -3><!--- son maliyetine ekleme veya çıkarma--->
						<cfquery name="GET_PRICE" datasource="#DSN3#">
							SELECT TOP 1
								PRODUCT_COST AS PRICE,
								MONEY
							FROM
								#dsn1_alias#.PRODUCT_COST	
							WHERE
								PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_id[prd_index]#"> AND
								PRODUCT_COST_STATUS = 1
							ORDER BY 
								START_DATE DESC,
								RECORD_DATE DESC
						</cfquery>
					<cfelseif form.target_margin eq -4><!--- ortalama fiyatina ekleme  veya çıkarma--->
						<cfquery name="GET_PRICE" datasource="#DSN3#">
                            SELECT 
                                AVG(PRICE) AS PRICE
                                ,MONEY
                            FROM
                                (
                                SELECT DISTINCT
                                    IR.PRICE, 
                                    IR.OTHER_MONEY MONEY
                                FROM	
                                    #dsn2_alias#.INVOICE_ROW AS IR,
                                    #dsn2_alias#.INVOICE AS I,
                                    STOCKS AS ST
                                WHERE
                                    ST.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_id[prd_index]#">
                                    AND	ST.STOCK_ID = IR.STOCK_ID
                                    AND	I.PURCHASE_SALES = 0
                                    AND ISNULL(I.IS_IPTAL,0)=0 
                                    AND	I.INVOICE_ID = IR.INVOICE_ID
                                    AND IR.UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_unit_id[prd_index]#">
                                    ) AS T
                            GROUP BY
                            MONEY
						</cfquery>
                    <cfelseif form.target_margin eq -5><!--- son alis fiyatina ekleme  veya çıkarma--->
						<cfquery name="GET_PRICE" datasource="#DSN3#">
                             SELECT DISTINCT
                                IR.PRICE, 
                                IR.OTHER_MONEY MONEY,
                                I.INVOICE_DATE
                            FROM	
                                #dsn2_alias#.INVOICE_ROW AS IR,
                                #dsn2_alias#.INVOICE AS I,
                                STOCKS AS ST
                            WHERE
                                ST.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_id[prd_index]#">
                                AND	ST.STOCK_ID = IR.STOCK_ID
                                AND	I.PURCHASE_SALES = 0
                                AND ISNULL(I.IS_IPTAL,0)=0 
                                AND	I.INVOICE_ID = IR.INVOICE_ID
                                AND IR.UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_unit_id[prd_index]#">
                            ORDER BY
                                I.INVOICE_DATE DESC
						</cfquery>
					<cfelseif form.target_margin eq -2><!--- standart satış fiyatina ekleme  veya çıkarma--->
						<cfquery name="GET_PRICE" datasource="#DSN3#">
							SELECT 
								PRICE,
								MONEY 
							FROM
								PRICE_STANDART
							WHERE 
								PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_id[prd_index]#"> AND
								PRICESTANDART_STATUS = 1 AND
								PURCHASESALES = 1 AND
								UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_unit_id[prd_index]#">
						</cfquery>
					<cfelseif form.target_margin gt 0><!--- seçilen fiyat listesindeki fiyatına ekleme  veya çıkarma--->
						<cfquery name="GET_PRICE" datasource="#DSN3#">
							SELECT 
								PRICE,
								MONEY 
							FROM
								PRICE
							WHERE 
								PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_id[prd_index]#"> AND
								<!---ISNULL(STOCK_ID,0)=0 AND--->		 
								ISNULL(SPECT_VAR_ID,0)=0 AND		 
								UNIT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_unit_id[prd_index]#"> AND
								PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.target_margin#">
						</cfquery>
					<cfelse>
						<cfset get_price.recordcount = 0>
					</cfif>
					<cfif get_price.recordcount neq 0>
						<cfif len(get_price_cat.margin)>
							<cfset get_price_cat_margin = get_price_cat.margin>
						<cfelseif len(get_price_cat.is_calc_productcat) and get_price_cat.is_calc_productcat eq 1>
							<cfquery name="get_margin" datasource="#DSN3#">
								SELECT ISNULL(PROFIT_MARGIN,0) PROFIT_MARGIN FROM PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_catid[prd_index]#">
							</cfquery>
							<cfset get_price_cat_margin = get_margin.profit_margin>
						<cfelse>
							<cfset get_price_cat_margin = 0>
						</cfif>
						<cfif isdefined("attributes.is_calculate_type") and attributes.is_calculate_type eq 1>
							<cfset end_price = get_price.price / ((100+get_price_cat_margin) / 100)>
						<cfelseif len(get_price.price) and len(get_price_cat_margin)>
							<cfset end_price = get_price.price + ((get_price.price * get_price_cat_margin) / 100)>	
						<cfelse>
							<cfset end_price =0>						
						</cfif>
					</cfif>
				<cfelse>
					<cfset get_price.recordcount = 0>
				</cfif>
				<cfif get_price.recordcount neq 0 and end_price>
					<cfscript>
						end_price_with_kdv = wrk_round(end_price+((end_price*get_product.tax[prd_index])/100),2);
						add_price(product_id : get_product.product_id[prd_index],
							product_unit_id : get_product.product_unit_id[prd_index],
							price_cat : attributes.pcat_id,
							start_date : attributes.startdate,
							price : end_price,
							price_money : get_price.money,
							is_kdv : #iif(isDefined('IS_KDV'),1,0)#,
							price_with_kdv : end_price_with_kdv,
							stock_id : get_product.stock_id[prd_index]
							);
					</cfscript>
				</cfif>
			</cfloop>
		</cftransaction>
	</cflock>
    <script type="text/javascript">
		window.location.reload();   
 </script>
</cfif>

