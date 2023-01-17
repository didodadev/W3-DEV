
<cfif not isdefined("new_dsn2")>
	<cfset new_dsn2 =  dsn2>
</cfif>
<cfset new_stock_id_list = ''>
<cfif isdefined("attributes.tree_stock_id") and len(attributes.tree_stock_id) and len(attributes.tree_product_name)>
	<cfscript>
		deep_level = 0;
		function get_subs(spect_main_id,next_stock_id,type)
		{										
			if(type eq 0) where_parameter = 'PT.STOCK_ID = #next_stock_id#'; else where_parameter = 'RELATED_PRODUCT_TREE_ID = #spect_main_id#';
			SQLStr = "
					SELECT
						PRODUCT_TREE_ID RELATED_ID,
						ISNULL(PT.STOCK_ID,0) STOCK_ID,
						ISNULL(PT.SPECT_MAIN_ID,0) SPECT_MAIN_ROW_ID,
						ISNULL(PT.SPECT_MAIN_ID,0) AS SPECT_MAIN_ID,
						ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
						ISNULL(PT.PRODUCT_ID,0) AS PRODUCT_ID,
						ISNULL(PT.OPERATION_TYPE_ID,0) OPERATION_TYPE_ID,
						ISNULL(PT.RELATED_ID,0) STOCK_RELATED_ID
					FROM 
						PRODUCT_TREE PT
					WHERE
						#where_parameter#
					ORDER BY
						LINE_NUMBER,
						STOCK_ID DESC
				";
			query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
			stock_id_ary='';
			for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
			{
				stock_id_ary=listappend(stock_id_ary,query1.RELATED_ID[str_i],'█');
				stock_id_ary=listappend(stock_id_ary,query1.OPERATION_TYPE_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.STOCK_RELATED_ID[str_i],'§');
			}
			return stock_id_ary;
		}
		function writeTree(next_spect_main_id,next_stock_id,type)
		{
			var i = 1;
			var sub_products = get_subs(next_spect_main_id,next_stock_id,type);
			deep_level = deep_level + 1;
			for (i=1; i lte listlen(sub_products,'█'); i = i+1)
			{
				_next_spect_main_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
				_n_operation_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),2,'§');
				_n_stock_related_id_= ListGetAt(ListGetAt(sub_products,i,'█'),3,'§');
				if(_n_stock_related_id_ gt 0) new_stock_id_list = listappend(new_stock_id_list,_n_stock_related_id_);
				if(_n_operation_id_ gt 0) type_=3;else type_=0;
				writeTree(_next_spect_main_id_,_n_stock_related_id_,type_);
			 }
			 deep_level = deep_level-1;
		}
	</cfscript>
	<cfscript>							
		 writeTree(0,attributes.tree_stock_id,0);
	</cfscript>
</cfif>

<cfquery name="PRODUCTS" datasource="#DSN1#">
	WITH CTE1 AS (
	SELECT  DISTINCT
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_CODE,
		<cfif (basket_prod_list.PRODUCT_SELECT_TYPE eq 13 or basket_prod_list.PRODUCT_SELECT_TYPE eq 11) and attributes.int_basket_id neq 4>
        	<cfif is_lot_no_based eq 1> 
            	SUM(SR.STOCK_IN - SR.STOCK_OUT) PRODUCT_STOCK, 
        	 <cfelse>
   				GS.PRODUCT_STOCK,
        	</cfif>
        <cfelse>
        GS.PRODUCT_STOCK,
   		</cfif>
		#dsn_alias#.Get_Dynamic_Language(PRODUCT.PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,PRODUCT.PRODUCT_NAME) AS PRODUCT_NAME,
		PRODUCT.PRODUCT_CODE,
		STOCKS.STOCK_CODE_2 PRODUCT_CODE_2,
		STOCKS.STOCK_CODE_2,
        PRODUCT.PRODUCT_DETAIL,
		PRODUCT.PRODUCT_DETAIL2,
		STOCKS.PROPERTY,
		STOCKS.BARCOD AS BARCOD,
		PRODUCT.IS_INVENTORY,
		PRODUCT.IS_PRODUCTION,
		PRODUCT.CUSTOMS_RECIPE_CODE,
		<cfif isdefined('attributes.is_sale_product') and attributes.is_sale_product eq 0>
			PRODUCT.TAX_PURCHASE AS TAX,
		<cfelse>
			PRODUCT.TAX AS TAX,
		</cfif>
		PRODUCT.OTV AS OTV,
		PRODUCT.OIV,
		PRODUCT.IS_ZERO_STOCK,
		PRODUCT.PRODUCT_CATID,
		PRODUCT.IS_SERIAL_NO,
		STOCKS.MANUFACT_CODE,
		PRICE_STANDART.PRICE,
		PRICE_STANDART.PRICE_KDV,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN PRICE_STANDART.MONEY ='YTL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE PRICE_STANDART.MONEY END AS MONEY,
		<cfelse>
			PRICE_STANDART.MONEY,
		</cfif> 
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_UNIT.MULTIPLIER
		<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>
			,GS.SHELF_ID
		</cfif>
		<cfif listfind('6,9',basket_prod_list.PRODUCT_SELECT_TYPE,',')>
			,GS.SPECT_VAR_ID
			,SPM.SPECT_MAIN_NAME
			,SPM.SPECT_MAIN_ID
		</cfif>
		<cfif listfind('8,9',basket_prod_list.PRODUCT_SELECT_TYPE,',')>
			,PRODUCT.WORK_STOCK_ID
			,PRODUCT.WORK_STOCK_AMOUNT
		</cfif>,
		GPA.UNIT GPA_UNIT,
		GPA.PRICE AS GPA_PRICE,
		GPA.PRICE_KDV GPA_PRICE_KDV,
		GPA.MONEY GPA_MONEY,
		GPA.PRICE_CATID GPA_PRICE_CATID,
		GPA.CATALOG_ID GPA_CATALOG_ID
		<cfif (basket_prod_list.PRODUCT_SELECT_TYPE eq 13 or basket_prod_list.PRODUCT_SELECT_TYPE eq 11) and attributes.int_basket_id neq 4>
			<cfif is_lot_no_based eq 1>			
				,LOT_NO
				<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>
					,SR.DELIVER_DATE
				</cfif>
			</cfif>
		<cfelseif basket_prod_list.PRODUCT_SELECT_TYPE eq 11 and is_lot_no_based neq 1>
		,GS.DELIVER_DATE
		</cfif>	
	FROM    	
		PRODUCT
		JOIN STOCKS ON STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
		JOIN PRODUCT_OUR_COMPANY ON   PRODUCT_OUR_COMPANY.PRODUCT_ID = PRODUCT.PRODUCT_ID
		JOIN PRODUCT_UNIT ON PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID
		JOIN PRICE_STANDART ON PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
        <cfif (basket_prod_list.PRODUCT_SELECT_TYPE eq 13 or basket_prod_list.PRODUCT_SELECT_TYPE eq 11) and attributes.int_basket_id neq 4>
			<cfif is_lot_no_based eq 1>
            LEFT JOIN #dsn2_alias#.STOCKS_ROW SR ON STOCKS.STOCK_ID = SR.STOCK_ID   
            </cfif>
        </cfif>
		<cfif listfind('6,9',basket_prod_list.PRODUCT_SELECT_TYPE,',')>
			LEFT JOIN 
			<cfif isdefined("attributes.is_store") or isdefined("attributes.is_store_module")>
				#new_dsn2#.GET_STOCK_PRODUCT_BRANCH_SPECT GS 
			<cfelse>
				#new_dsn2#.GET_STOCK_SPECT GS
			</cfif>
			ON  GS.STOCK_ID = STOCKS.STOCK_ID
			LEFT JOIN #dsn3_alias#.SPECT_MAIN SPM ON SPM.SPECT_MAIN_ID = GS.SPECT_VAR_ID
		<cfelseif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>
			<cfif isdefined("attributes.is_store") or isdefined("attributes.is_store_module")>
				LEFT JOIN #new_dsn2#.GET_STOCK_SHELF GS ON GS.STOCK_ID = STOCKS.STOCK_ID
				LEFT JOIN #new_dsn2#.PRODUCT_PLACE PRO_P ON GS.SHELF_ID =  PRO_P.PRODUCT_PLACE_ID
				LEFT JOIN #new_dsn2#.DEPARTMENT D ON PRO_P.STORE_ID = D.DEPARTMENT_ID
			<cfelse>
				<cfif xml_group_shelf>
					JOIN #new_dsn2#.GET_STOCK_SHELF_ONLY GS ON GS.STOCK_ID = STOCKS.STOCK_ID
				<cfelse>
					JOIN #new_dsn2#.GET_STOCK_SHELF GS ON GS.STOCK_ID = STOCKS.STOCK_ID
				</cfif>
			</cfif>
		<cfelse>
			LEFT JOIN
			<cfif isdefined("attributes.is_store") or isdefined("attributes.is_store_module")>
				 #new_dsn2#.GET_STOCK_PRODUCT_BRANCH GS
			<cfelse>
					#new_dsn2#.GET_STOCK GS
				</cfif>
			ON GS.STOCK_ID = STOCKS.STOCK_ID
		</cfif>
		
		LEFT JOIN
		(
			SELECT 
				price_all.*,
				SM.RATE1,
				SM.RATE2
			FROM 
			(
				SELECT  
					P.UNIT,
					P.PRICE,
					P.PRICE_KDV,
					P.PRODUCT_ID,
					<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
						ISNULL(P.STOCK_ID,0) AS STOCK_ID,
						ISNULL(P.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
					</cfif>
					P.MONEY,
					P.PRICE_CATID,
					P.CATALOG_ID
				FROM 
					#dsn3#.PRICE P,
					#dsn3#.PRODUCT PR
				WHERE
					P.PRODUCT_ID = PR.PRODUCT_ID AND 
					P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
					(
						P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> AND
						(P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> OR P.FINISHDATE IS NULL)
					)
					<cfif not listfind("6,9",basket_prod_list.PRODUCT_SELECT_TYPE,",")>
						AND ISNULL(P.SPECT_VAR_ID,0) = 0
					</cfif>
					<cfif get_price_exceptions_pid.recordcount or get_price_exceptions_pcatid.recordcount or get_price_exceptions_brid.recordcount OR GET_PRICE_EXCEPTIONS_SHORTCODE.RECORDCOUNT>
						<cfif get_price_exceptions_pid.recordcount>
						AND	P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#)
						</cfif>
						<cfif get_price_exceptions_pcatid.recordcount>
						AND PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#)
						</cfif>
						<cfif get_price_exceptions_brid.recordcount>
						AND ( PR.BRAND_ID NOT IN (#valuelist(get_price_exceptions_brid.BRAND_ID)#) OR PR.BRAND_ID IS NULL )
						</cfif>
						<cfif get_price_exceptions_shortcode.recordcount>
						AND ( PR.SHORT_CODE_ID NOT IN (#valuelist(get_price_exceptions_shortcode.SHORT_CODE_ID)#) OR PR.SHORT_CODE_ID IS NULL )
						</cfif>
					</cfif>
					<cfif len(attributes.product_cat) and len(attributes.product_catid)>
						AND PR.PRODUCT_CODE LIKE (SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">)+'.%' <!---kategori hiyerarşisine gore arama yapıyor --->
					</cfif>
					<cfif len(attributes.employee) and len(attributes.pos_code)>
						AND PR.PRODUCT_MANAGER=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">
					</cfif>
					<cfif len(attributes.get_company) and len(attributes.get_company_id)>
						AND PR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.get_company_id#">
					</cfif>
					<cfif len(attributes.brand_id) and len(attributes.brand_name)>
						AND PR.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
					</cfif>
					<cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id) and len(attributes.short_code_name)>
						AND PR.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#">
					</cfif>	
					<cfif isDefined("attributes.keyword") and len(attributes.keyword) gt 1>
						AND
							(
								(
									PR.PRODUCT_ID IN
										(
											SELECT
												S.PRODUCT_ID
											FROM
												STOCKS S
											WHERE
												S.PRODUCT_ID = PR.PRODUCT_ID AND
												(S.STOCK_CODE LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%' OR
												S.STOCK_CODE_2 LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%')
										) OR
									PR.PRODUCT_CODE LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%' OR
									PR.PRODUCT_CODE_2 LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%' OR
									PR.PRODUCT_DETAIL LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%' OR
									PR.PRODUCT_NAME LIKE #sql_unicode()#'%#attributes.keyword#%'
									<cfif listlen(attributes.keyword,"+") gt 1 and len(attributes.keyword) gt 3>
									OR	(
											<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
												PR.PRODUCT_NAME LIKE #sql_unicode()#'<cfif pro_index neq 1>%</cfif>#ListGetAt(attributes.keyword,pro_index,"+")#%' 
												<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
											</cfloop>
										)		
									</cfif>
								) OR
								PR.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR
								PR.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
							)
					<cfelseif isDefined("attributes.keyword") and len(attributes.keyword) eq 1>
						AND	PR.PRODUCT_NAME LIKE #sql_unicode()#'#attributes.keyword#%' 
					</cfif>
					<cfif isdefined("sepet_process_type") and (sepet_process_type neq -1)>
						<cfif ListFind("561,60",sepet_process_type)><!--- 56,58,63, envantere dahil olsada ürünler gelsin kapatılan işlem tiplerinde çünkü artık ürünlerin bu işlem tipleri için muhasebe kodları var--->
							AND PR.IS_INVENTORY = 0
						</cfif>
					</cfif>						
				<cfif get_price_exceptions_pid.recordcount>
				UNION
					SELECT
						UNIT,
						PRICE,
						PRICE_KDV,
						PRODUCT_ID,
						<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
							ISNULL(STOCK_ID,0) AS STOCK_ID,
							ISNULL(SPECT_VAR_ID,0) AS SPECT_VAR_ID,
						</cfif>
						MONEY,
						PRICE_CATID,
						CATALOG_ID
					FROM
						#dsn3#.PRICE
					WHERE 
						STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> AND
						(FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> OR FINISHDATE IS NULL) AND
						<cfif get_price_exceptions_pid.recordcount gt 1>(</cfif>
							<cfoutput query="get_price_exceptions_pid">
							(PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#"> AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
							<cfif get_price_exceptions_pid.recordcount neq get_price_exceptions_pid.currentrow>
							OR
							</cfif>
							</cfoutput>
						<cfif get_price_exceptions_pid.recordcount gt 1>)</cfif>
				</cfif>
				<cfif get_price_exceptions_pcatid.recordcount>
				UNION
					SELECT
						P.UNIT,P.PRICE,P.PRICE_KDV,P.PRODUCT_ID,
						<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
							ISNULL(P.STOCK_ID,0) AS STOCK_ID, ISNULL(P.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
						</cfif>
						P.MONEY,P.PRICE_CATID,P.CATALOG_ID
					FROM
						#dsn3#.PRICE P,
						#dsn3#.PRODUCT PR
					WHERE
						<cfif get_price_exceptions_pid.recordcount>
						P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
						</cfif>
						P.PRODUCT_ID = PR.PRODUCT_ID AND
						P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> AND
						(P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> OR P.FINISHDATE IS NULL) AND
						<cfif get_price_exceptions_pcatid.recordcount gt 1>(</cfif>
						<cfoutput query="get_price_exceptions_pcatid">
						(PR.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_CATID#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
						<cfif get_price_exceptions_pcatid.recordcount neq get_price_exceptions_pcatid.currentrow>
						OR
						</cfif>
						</cfoutput>
						<cfif get_price_exceptions_pcatid.recordcount gt 1>)</cfif>
				</cfif>
				<cfif get_price_exceptions_brid.recordcount>
				UNION
					SELECT  
						P.UNIT,P.PRICE,P.PRICE_KDV,P.PRODUCT_ID,
						<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
							ISNULL(P.STOCK_ID,0) AS STOCK_ID, ISNULL(P.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
						</cfif>
						P.MONEY,P.PRICE_CATID,P.CATALOG_ID
					FROM 
						#dsn3#.PRICE P,
						#dsn3#.PRODUCT PR
					WHERE 
						<cfif get_price_exceptions_pid.recordcount>
						P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
						</cfif>
						<cfif get_price_exceptions_pcatid.recordcount>
						PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#) AND
						</cfif>
						P.PRODUCT_ID = PR.PRODUCT_ID AND 
						P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> AND
						(P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> OR P.FINISHDATE IS NULL) AND
						<cfif get_price_exceptions_brid.recordcount gt 1>(</cfif>		
						<cfoutput query="get_price_exceptions_brid">		
						(PR.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BRAND_ID#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
						<cfif get_price_exceptions_brid.recordcount neq get_price_exceptions_brid.currentrow>
						OR
						</cfif>
						</cfoutput>
						<cfif get_price_exceptions_brid.recordcount gt 1>)</cfif>		
				</cfif>
				<cfif get_price_exceptions_shortcode.recordcount>
				UNION
					SELECT  
						P.UNIT,P.PRICE,P.PRICE_KDV,P.PRODUCT_ID,
						<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
							ISNULL(P.STOCK_ID,0) AS STOCK_ID, ISNULL(P.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
						</cfif>
						P.MONEY,P.PRICE_CATID,P.CATALOG_ID
					FROM 
						#dsn3#.PRICE P,
						#dsn3#.PRODUCT PR
					WHERE 
						<cfif get_price_exceptions_pid.recordcount>
						P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
						</cfif>
						<cfif get_price_exceptions_pcatid.recordcount>
						PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#) AND
						</cfif>
						P.PRODUCT_ID = PR.PRODUCT_ID AND 
						P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> AND
						(P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> OR P.FINISHDATE IS NULL) AND
						<cfif get_price_exceptions_brid.recordcount gt 1>(</cfif>		
						<cfoutput query="get_price_exceptions_brid">		
							(PR.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BRAND_ID#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
							<cfif get_price_exceptions_brid.recordcount neq get_price_exceptions_brid.currentrow>
							OR
							</cfif>
						</cfoutput>
						<cfif get_price_exceptions_brid.recordcount gt 1>)  AND<cfelseif get_price_exceptions_brid.recordcount eq 1>AND</cfif>	
						<cfif get_price_exceptions_shortcode.recordcount gt 1>(</cfif>		
						<cfoutput query="get_price_exceptions_shortcode">		
						(PR.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SHORT_CODE_ID#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
						<cfif get_price_exceptions_shortcode.recordcount neq get_price_exceptions_shortcode.currentrow>
						OR
						</cfif>
						</cfoutput>
						<cfif get_price_exceptions_shortcode.recordcount gt 1>)</cfif>	
				</cfif>
				<cfif listfind('8,9',basket_prod_list.PRODUCT_SELECT_TYPE,',')>
				UNION
					SELECT
						P.UNIT,
						P.PRICE,
						P.PRICE_KDV,
						P.PRODUCT_ID,
						<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
							ISNULL(P.STOCK_ID,0) AS STOCK_ID, ISNULL(P.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
						</cfif>
						P.MONEY,
						P.PRICE_CATID,
						P.CATALOG_ID
					FROM 
						#dsn3#.PRICE P,
						#dsn3#.PRODUCT PR,
						#dsn3#.STOCKS
					WHERE
						STOCKS.STOCK_ID=PR.WORK_STOCK_ID AND
						P.PRODUCT_ID = PR.PRODUCT_ID AND 
						P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
						(
							P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> AND
							(P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> OR P.FINISHDATE IS NULL)
						)
				</cfif>
			) AS price_all
			JOIN #dsn2_alias#.SETUP_MONEY SM ON SM.MONEY = price_all.MONEY
		) AS GPA ON GPA.PRODUCT_ID = PRODUCT.PRODUCT_ID AND GPA.UNIT = PRODUCT_UNIT.PRODUCT_UNIT_ID 
			<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
				AND (GPA.STOCK_ID = STOCKS.STOCK_ID OR ISNULL(GPA.STOCK_ID,0)=0) 
				AND GPA.STOCK_ID IN (0,STOCKS.STOCK_ID)  
				<cfif listfind("6,9",basket_prod_list.PRODUCT_SELECT_TYPE,",")>
					AND GPA.SPECT_VAR_ID IN (0,GS.SPECT_VAR_ID)
				<cfelse>
					AND GPA.SPECT_VAR_ID = 0
				</cfif>
			</cfif>
	WHERE
    	
		PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		<cfif len(attributes.serial_number) and listlen(seri_stock_id_list)>
			STOCKS.STOCK_ID IN (#seri_stock_id_list#) AND
		<cfelseif len(attributes.serial_number) and not listlen(seri_stock_id_list)>
			STOCKS.STOCK_ID IS NULL AND
		</cfif>
		PRODUCT.PRODUCT_STATUS = 1 AND
		STOCKS.STOCK_STATUS = 1 AND
		<!--- PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND  --->
		PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 
		<!--- PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND  --->
		<!--- GS.STOCK_ID = STOCKS.STOCK_ID --->
		<!--- PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID --->
		<cfif (basket_prod_list.PRODUCT_SELECT_TYPE eq 13 or basket_prod_list.PRODUCT_SELECT_TYPE eq 11) and attributes.int_basket_id neq 4>
			<cfif is_lot_no_based eq 1 and len(attributes.keyword2) gt 0>
				AND SR.LOT_NO LIKE '<cfif len(attributes.keyword2) gte 3>%</cfif>#attributes.keyword2#%'
		</cfif>
		</cfif>
	<cfif not isdefined('attributes.is_condition_sale_or_purchase')><!--- alış veya satış olsada bu deger geldi ise urunlerin alış veya satışlarına bakmaz --->
		AND PRODUCT.IS_SALES=1
	</cfif>
	<cfif len(attributes.product_cat) and len(attributes.product_catid)>
		AND PRODUCT.PRODUCT_CODE LIKE (SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">)+'.%' <!---kategori hiyerarşisine gore arama yapıyor --->
	</cfif>
	<cfif len(attributes.employee) and len(attributes.pos_code)>
		AND PRODUCT.PRODUCT_MANAGER=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">
	</cfif>
	<cfif isdefined('xml_use_project_filter') and xml_use_project_filter eq 1 and isdefined("attributes.project_id") and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
		<!--- xml de proje filtresi secilmisse, secilen projenin masraf merkezine baglı urunler listelenir --->
		AND PRODUCT.PRODUCT_ID IN (
									SELECT 
										DISTINCT CP.PRODUCT_ID
									FROM
										#dsn3_alias#.PRODUCT_PERIOD CP,
										#dsn2_alias#.EXPENSE_CENTER EXC,
										#dsn_alias#.PRO_PROJECTS PRJ
									WHERE
										CP.PRODUCT_ID =PRODUCT.PRODUCT_ID
										AND CP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
										AND PRJ.PROJECT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
										AND (CP.EXPENSE_CENTER_ID=EXC.EXPENSE_ID OR CP.COST_EXPENSE_CENTER_ID=EXC.EXPENSE_ID)
										AND SUBSTRING(PRJ.EXPENSE_CODE,1,3) = EXC.EXPENSE_CODE
									)
	</cfif>
	<cfif len(attributes.get_company) and len(attributes.get_company_id)>
		AND PRODUCT.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.get_company_id#">
	</cfif>
	<cfif len(attributes.brand_id) and len(attributes.brand_name)>
		AND PRODUCT.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
	</cfif>
	<cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id) and len(attributes.short_code_name)>
		AND PRODUCT.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#">
	</cfif>
		AND PRICE_STANDART.PRICESTANDART_STATUS = 1
		AND PRICE_STANDART.PURCHASESALES = 1
		<!--- AND PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID
		AND PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID --->
	<cfif isdefined('attributes.is_store_module') and ( (isdefined('attributes.sepet_process_type') and listfind('49,51,52,54,55,59,591,60,601,63,73,74,75,76,77,80,82,86,87',attributes.sepet_process_type)) or (isdefined('attributes.int_basket_id') and attributes.int_basket_id eq 6) )><!--- sube modulunden perakende faturasına urun secilirken --->
		AND PRODUCT.PRODUCT_ID IN (SELECT DISTINCT PRODUCT_ID FROM #dsn1_alias#.PRODUCT_BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">)
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword) gt 1>
		AND
			(
				(
				STOCKS.STOCK_CODE LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' OR
				STOCKS.STOCK_CODE_2 LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' OR
				PRODUCT.PRODUCT_DETAIL LIKE '#attributes.keyword#%' OR
				PRODUCT.PRODUCT_CODE_2 LIKE '#attributes.keyword#%'
				<cfif len(attributes.keyword) lte 2>
					OR PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'#attributes.keyword#%' 
				<cfelseif len(attributes.keyword) gt 2>
					<cfif listlen(attributes.keyword,"+") gt 1>
					OR	(
							<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
								PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'<cfif pro_index neq 1>%</cfif>#ListGetAt(attributes.keyword,pro_index,"+")#%' 
								<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
							</cfloop>
						)		
					<cfelse>
						OR PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'%#attributes.keyword#%'
						OR PRODUCT.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#replace(attributes.keyword,"+","")#%">
					</cfif>
				</cfif>
				) OR
				STOCKS.BARCOD = '#attributes.keyword#' OR
				STOCKS.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				<cfif isDefined('attributes.property_keyword') and len(attributes.property_keyword)>
                    OR PRODUCT.PRODUCT_ID IN (
                                            SELECT 
                                                PDP.PRODUCT_ID 
                                            FROM 
                                                #dsn1_alias#.PRODUCT_PROPERTY_DETAIL PPD, 
                                                #dsn1_alias#.PRODUCT_DT_PROPERTIES PDP
                                            WHERE 
                                                PPD.PROPERTY_DETAIL_ID = PDP.VARIATION_ID AND
                                                PPD.PROPERTY_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.property_keyword#%">
                                        ) 
                    OR PRODUCT.PRODUCT_ID IN (
                    						SELECT 
                                                PDP.PRODUCT_ID
                                            FROM 
                                                #dsn1_alias#.PRODUCT_DT_PROPERTIES PDP,
                                                #dsn1_alias#.PRODUCT_PROPERTY PP
                                            WHERE 
                                                PDP.PROPERTY_ID = PP.PROPERTY_ID AND
                                                PP.PROPERTY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.property_keyword#%">
										)
                </cfif>
			)
	<cfelseif isDefined("attributes.keyword") and len(attributes.keyword) eq 1>
		AND	PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'#attributes.keyword#%' 
	</cfif>
	<cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id) and len(attributes.list_variation_id)>
		AND
		PRODUCT.PRODUCT_ID IN
		(
			SELECT
				PRODUCT_ID
			FROM
				#dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
			WHERE
				(
			  <cfloop from="1" to="#listlen(attributes.list_property_id,',')#" index="pro_index">
				(PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_property_id,pro_index,",")#"> AND VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_variation_id,pro_index,",")#">)
				<cfif pro_index lt listlen(attributes.list_property_id,',')>OR</cfif>
			  </cfloop>
				)
			GROUP BY
				PRODUCT_ID
			HAVING
				COUNT(PRODUCT_ID)> = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlen(attributes.list_property_id,',')#">
		)
	</cfif>
	<cfif isdefined("attributes.is_store") or isdefined("attributes.is_store_module")>
		<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>
			AND D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
		<cfelse>
			AND GS.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#"> 
			AND PRODUCT.PRODUCT_ID IN (SELECT DISTINCT PRODUCT_ID FROM #dsn1_alias#.PRODUCT_BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">)
		</cfif>
	</cfif>
	<cfif attributes.stok_turu eq 2>
		AND 
		(
			GS.PRODUCT_STOCK > 0
		)
	</cfif>
	<cfif isdefined("attributes.zero_stock_status") and (attributes.zero_stock_status eq 1)>
		AND GS.PRODUCT_STOCK > 0
	</cfif>
	<cfif isdefined("sepet_process_type") and (sepet_process_type neq -1)>
		<cfif ListFind("561,60",sepet_process_type)><!--- 56,58,63, envantere dahil olsada ürünler gelsin kapatılan işlem tiplerinde çünkü artık ürünlerin bu işlem tipleri için muhasebe kodları var--->
			AND PRODUCT.IS_INVENTORY = 0
		</cfif>
	</cfif>
    <cfif isdefined("is_price_list") and is_price_list eq 1 and len(attributes.price_catid) and attributes.price_catid neq -2>
		<!--- AND GPA.PRODUCT_ID IS NOT NULL --->
		AND PRODUCT.PRODUCT_ID IN (
			SELECT PRODUCT_ID FROM (
				SELECT 
					price_all.*,
					SM.RATE1,
					SM.RATE2
				FROM 
				(
					SELECT
						P.UNIT,
						P.PRICE,
						P.PRICE_KDV,
						P.PRODUCT_ID,
						<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
							ISNULL(P.STOCK_ID,0) AS STOCK_ID,
							ISNULL(P.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
						</cfif>
						P.MONEY,
						P.PRICE_CATID,
						P.CATALOG_ID
					FROM 
						#dsn3#.PRICE P,
						#dsn3#.PRODUCT PR
					WHERE
						P.PRODUCT_ID = PR.PRODUCT_ID AND 
						P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
						(
							P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> AND
							(P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> OR P.FINISHDATE IS NULL)
						)
						<cfif not listfind("6,9",basket_prod_list.PRODUCT_SELECT_TYPE,",")>
							AND ISNULL(P.SPECT_VAR_ID,0) = 0
						</cfif>
						<cfif get_price_exceptions_pid.recordcount or get_price_exceptions_pcatid.recordcount or get_price_exceptions_brid.recordcount OR GET_PRICE_EXCEPTIONS_SHORTCODE.RECORDCOUNT>
							<cfif get_price_exceptions_pid.recordcount>
							AND	P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#)
							</cfif>
							<cfif get_price_exceptions_pcatid.recordcount>
							AND PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#)
							</cfif>
							<cfif get_price_exceptions_brid.recordcount>
							AND ( PR.BRAND_ID NOT IN (#valuelist(get_price_exceptions_brid.BRAND_ID)#) OR PR.BRAND_ID IS NULL )
							</cfif>
							<cfif get_price_exceptions_shortcode.recordcount>
							AND ( PR.SHORT_CODE_ID NOT IN (#valuelist(get_price_exceptions_shortcode.SHORT_CODE_ID)#) OR PR.SHORT_CODE_ID IS NULL )
							</cfif>
						</cfif>
						<cfif len(attributes.product_cat) and len(attributes.product_catid)>
							AND PR.PRODUCT_CODE LIKE (SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">)+'.%' <!---kategori hiyerarşisine gore arama yapıyor --->
						</cfif>
						<cfif len(attributes.employee) and len(attributes.pos_code)>
							AND PR.PRODUCT_MANAGER=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">
						</cfif>
						<cfif len(attributes.get_company) and len(attributes.get_company_id)>
							AND PR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.get_company_id#">
						</cfif>
						<cfif len(attributes.brand_id) and len(attributes.brand_name)>
							AND PR.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
						</cfif>
						<cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id) and len(attributes.short_code_name)>
							AND PR.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#">
						</cfif>	
						<cfif isDefined("attributes.keyword") and len(attributes.keyword) gt 1>
							AND
								(
									(
										PR.PRODUCT_ID IN
											(
												SELECT
													S.PRODUCT_ID
												FROM
													STOCKS S
												WHERE
													S.PRODUCT_ID = PR.PRODUCT_ID AND
													(S.STOCK_CODE LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%' OR
													S.STOCK_CODE_2 LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%')
											) OR
										PR.PRODUCT_CODE LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%' OR
										PR.PRODUCT_CODE_2 LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%' OR
										PR.PRODUCT_DETAIL LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%' OR
										PR.PRODUCT_NAME LIKE #sql_unicode()#'%#attributes.keyword#%'
										<cfif listlen(attributes.keyword,"+") gt 1 and len(attributes.keyword) gt 3>
										OR	(
												<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
													PR.PRODUCT_NAME LIKE #sql_unicode()#'<cfif pro_index neq 1>%</cfif>#ListGetAt(attributes.keyword,pro_index,"+")#%' 
													<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
												</cfloop>
											)		
										</cfif>
									) OR
									PR.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR
									PR.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
								)
						<cfelseif isDefined("attributes.keyword") and len(attributes.keyword) eq 1>
							AND	PR.PRODUCT_NAME LIKE #sql_unicode()#'#attributes.keyword#%' 
						</cfif>
						<cfif isdefined("sepet_process_type") and (sepet_process_type neq -1)>
							<cfif ListFind("561,60",sepet_process_type)><!--- 56,58,63, envantere dahil olsada ürünler gelsin kapatılan işlem tiplerinde çünkü artık ürünlerin bu işlem tipleri için muhasebe kodları var--->
								AND PR.IS_INVENTORY = 0
							</cfif>
						</cfif>						
					<cfif get_price_exceptions_pid.recordcount>
					UNION
						SELECT
							UNIT,
							PRICE,
							PRICE_KDV,
							PRODUCT_ID,
							<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
								ISNULL(STOCK_ID,0) AS STOCK_ID,
								ISNULL(SPECT_VAR_ID,0) AS SPECT_VAR_ID,
							</cfif>
							MONEY,
							PRICE_CATID,
							CATALOG_ID
						FROM
							#dsn3#.PRICE
						WHERE 
							STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> AND
							(FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> OR FINISHDATE IS NULL) AND
							<cfif get_price_exceptions_pid.recordcount gt 1>(</cfif>
								<cfoutput query="get_price_exceptions_pid">
								(PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#"> AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
								<cfif get_price_exceptions_pid.recordcount neq get_price_exceptions_pid.currentrow>
								OR
								</cfif>
								</cfoutput>
							<cfif get_price_exceptions_pid.recordcount gt 1>)</cfif>
					</cfif>
					<cfif get_price_exceptions_pcatid.recordcount>
					UNION
						SELECT
							P.UNIT,P.PRICE,P.PRICE_KDV,P.PRODUCT_ID,
							<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
								ISNULL(P.STOCK_ID,0) AS STOCK_ID, ISNULL(P.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
							</cfif>
							P.MONEY,P.PRICE_CATID,P.CATALOG_ID
						FROM
							#dsn3#.PRICE P,
							#dsn3#.PRODUCT PR
						WHERE
							<cfif get_price_exceptions_pid.recordcount>
							P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
							</cfif>
							P.PRODUCT_ID = PR.PRODUCT_ID AND
							P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> AND
							(P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> OR P.FINISHDATE IS NULL) AND
							<cfif get_price_exceptions_pcatid.recordcount gt 1>(</cfif>
							<cfoutput query="get_price_exceptions_pcatid">
							(PR.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_CATID#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
							<cfif get_price_exceptions_pcatid.recordcount neq get_price_exceptions_pcatid.currentrow>
							OR
							</cfif>
							</cfoutput>
							<cfif get_price_exceptions_pcatid.recordcount gt 1>)</cfif>
					</cfif>
					<cfif get_price_exceptions_brid.recordcount>
					UNION
						SELECT  
							P.UNIT,P.PRICE,P.PRICE_KDV,P.PRODUCT_ID,
							<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
								ISNULL(P.STOCK_ID,0) AS STOCK_ID, ISNULL(P.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
							</cfif>
							P.MONEY,P.PRICE_CATID,P.CATALOG_ID
						FROM 
							#dsn3#.PRICE P,
							#dsn3#.PRODUCT PR
						WHERE 
							<cfif get_price_exceptions_pid.recordcount>
							P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
							</cfif>
							<cfif get_price_exceptions_pcatid.recordcount>
							PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#) AND
							</cfif>
							P.PRODUCT_ID = PR.PRODUCT_ID AND 
							P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> AND
							(P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> OR P.FINISHDATE IS NULL) AND
							<cfif get_price_exceptions_brid.recordcount gt 1>(</cfif>		
							<cfoutput query="get_price_exceptions_brid">		
							(PR.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BRAND_ID#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
							<cfif get_price_exceptions_brid.recordcount neq get_price_exceptions_brid.currentrow>
							OR
							</cfif>
							</cfoutput>
							<cfif get_price_exceptions_brid.recordcount gt 1>)</cfif>		
					</cfif>
					<cfif get_price_exceptions_shortcode.recordcount>
					UNION
						SELECT  
							P.UNIT,P.PRICE,P.PRICE_KDV,P.PRODUCT_ID,
							<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
								ISNULL(P.STOCK_ID,0) AS STOCK_ID, ISNULL(P.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
							</cfif>
							P.MONEY,P.PRICE_CATID,P.CATALOG_ID
						FROM 
							#dsn3#.PRICE P,
							#dsn3#.PRODUCT PR
						WHERE 
							<cfif get_price_exceptions_pid.recordcount>
							P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
							</cfif>
							<cfif get_price_exceptions_pcatid.recordcount>
							PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#) AND
							</cfif>
							P.PRODUCT_ID = PR.PRODUCT_ID AND 
							P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> AND
							(P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> OR P.FINISHDATE IS NULL) AND
							<cfif get_price_exceptions_brid.recordcount gt 1>(</cfif>		
							<cfoutput query="get_price_exceptions_brid">		
								(PR.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BRAND_ID#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
								<cfif get_price_exceptions_brid.recordcount neq get_price_exceptions_brid.currentrow>
								OR
								</cfif>
							</cfoutput>
							<cfif get_price_exceptions_brid.recordcount gt 1>)  AND</cfif>	
							<cfif get_price_exceptions_shortcode.recordcount gt 1>(</cfif>		
							<cfoutput query="get_price_exceptions_shortcode">		
							(PR.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SHORT_CODE_ID#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
							<cfif get_price_exceptions_shortcode.recordcount neq get_price_exceptions_shortcode.currentrow>
							OR
							</cfif>
							</cfoutput>
							<cfif get_price_exceptions_shortcode.recordcount gt 1>)</cfif>	
					</cfif>
					<cfif listfind('8,9',basket_prod_list.PRODUCT_SELECT_TYPE,',')>
					UNION
						SELECT
							P.UNIT,
							P.PRICE,
							P.PRICE_KDV,
							P.PRODUCT_ID,
							<cfif isdefined('xml_use_stock_price') and xml_use_stock_price eq 1>
								ISNULL(P.STOCK_ID,0) AS STOCK_ID, ISNULL(P.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
							</cfif>
							P.MONEY,
							P.PRICE_CATID,
							P.CATALOG_ID
						FROM 
							#dsn3#.PRICE P,
							#dsn3#.PRODUCT PR,
							#dsn3#.STOCKS
						WHERE
							STOCKS.STOCK_ID=PR.WORK_STOCK_ID AND
							P.PRODUCT_ID = PR.PRODUCT_ID AND 
							P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
							(
								P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> AND
								(P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> OR P.FINISHDATE IS NULL)
							)
					</cfif>
				) AS price_all
				JOIN #dsn2_alias#.SETUP_MONEY SM ON SM.MONEY = price_all.MONEY
			) AS prid
		)
	</cfif>
	<cfif isdefined("new_stock_id_list") and listlen(new_stock_id_list)>
		AND STOCKS.STOCK_ID IN(#new_stock_id_list#)
	</cfif>
    <cfif (basket_prod_list.PRODUCT_SELECT_TYPE eq 13 or basket_prod_list.PRODUCT_SELECT_TYPE eq 11) and attributes.int_basket_id neq 4>
		<cfif is_lot_no_based eq 1>
		GROUP BY
        STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_CODE,
		--GS.PRODUCT_STOCK,
		PRODUCT.PRODUCT_NAME,
		PRODUCT.PRODUCT_CODE,
		STOCKS.STOCK_CODE_2,
		STOCKS.STOCK_CODE_2,
        PRODUCT.PRODUCT_DETAIL,
		PRODUCT.PRODUCT_DETAIL2,
		STOCKS.PROPERTY,
		STOCKS.BARCOD,
		PRODUCT.IS_INVENTORY,
		PRODUCT.IS_PRODUCTION,
		PRODUCT.CUSTOMS_RECIPE_CODE,
		<cfif isdefined('attributes.is_sale_product') and attributes.is_sale_product eq 0>
			PRODUCT.TAX_PURCHASE,
		<cfelse>
			PRODUCT.TAX,
		</cfif>
		PRODUCT.OTV,
		PRODUCT.OIV,
		PRODUCT.IS_ZERO_STOCK,
		PRODUCT.PRODUCT_CATID,
		PRODUCT.IS_SERIAL_NO,
		STOCKS.MANUFACT_CODE,
		PRICE_STANDART.PRICE,
		PRICE_STANDART.PRICE_KDV,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN PRICE_STANDART.MONEY ='YTL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE PRICE_STANDART.MONEY,
		<cfelse>
			PRICE_STANDART.MONEY,
		</cfif> 
		PRODUCT_UNIT.ADD_UNIT,
		PRODUCT_UNIT.PRODUCT_UNIT_ID,
		PRODUCT_UNIT.MAIN_UNIT,
		PRODUCT_UNIT.MULTIPLIER
	<cfif listfind('6,9',basket_prod_list.PRODUCT_SELECT_TYPE,',')>
		,GS.SPECT_VAR_ID
		,SPM.SPECT_MAIN_NAME
		,SPM.SPECT_MAIN_ID
	</cfif>
	<cfif listfind('8,9',basket_prod_list.PRODUCT_SELECT_TYPE,',')>
		,PRODUCT.WORK_STOCK_ID
		,PRODUCT.WORK_STOCK_AMOUNT
	</cfif>,
	PRODUCT.PRODUCT_ID,
	GPA.UNIT,
	GPA.PRICE,
	GPA.PRICE_KDV,
	GPA.MONEY ,
	GPA.PRICE_CATID,
	GPA.CATALOG_ID
	<cfif (basket_prod_list.PRODUCT_SELECT_TYPE eq 13 or basket_prod_list.PRODUCT_SELECT_TYPE eq 11) and attributes.int_basket_id neq 4>
        <cfif is_lot_no_based eq 1>
			,SR.DELIVER_DATE,SR.LOT_NO
		</cfif>
    </cfif>	
	<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>
		<cfif is_lot_no_based eq 0 or  xml_group_shelf eq 0>,GS.DELIVER_DATE</cfif>
			,GS.SHELF_ID
    </cfif>	
   		</cfif>
	</cfif>
),
		CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (
											<cfif isdefined('attributes.sort_type') and attributes.sort_type eq 0>
												ORDER BY PRODUCT_NAME, PROPERTY
											<cfelseif isdefined('attributes.sort_type') and attributes.sort_type eq 1>
												ORDER BY STOCK_CODE
											<cfelse>
												ORDER BY STOCK_CODE_2, PRODUCT_NAME
											</cfif>
											<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>
												<cfif is_lot_no_based eq 1 and ((basket_prod_list.PRODUCT_SELECT_TYPE eq 13 or basket_prod_list.PRODUCT_SELECT_TYPE eq 11) and attributes.int_basket_id neq 4)>
													,DELIVER_DATE,LOT_NO
												<cfelse>
													<cfif xml_group_shelf eq 0>
														,DELIVER_DATE
													</cfif>	
													,SHELF_ID
												</cfif>
											</cfif>
										) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)	
</cfquery>

