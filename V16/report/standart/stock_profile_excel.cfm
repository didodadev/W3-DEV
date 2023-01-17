

<cfquery name="GET_ALL_STOCK1" datasource="#dsn2#">
	
SELECT
	  STOCK_CODE as "Stok Kodu",
	  BARCOD  as "Barkod",
	  STOCK_CODE_2 as "Özel Kod",
	  PRODUCT_NAME as "Ürün Adı",
	  MAIN_UNIT as "Birim",
	  REAL_STOCK AS "Gerçek Stok",
	  SALEABLE_STOCK as "Satılabilir Stok",
	  MINIMUM_STOCK as "Minumun Stok",
	  MAXIMUM_STOCK as "Maksimum Stok",
	  BLOCK_STOCK_VALUE as "Bloke Stok",
	  REPEAT_STOCK_VALUE as "Yeniden Sipariş Noktası",
	  MINIMUM_ORDER_STOCK_VALUE as "Minumum Sipariş Miktarı",
	  MAXIMUM_ORDER_STOCK_VALUE as "Maksimum Sipariş Miktarı",
	  RESERVED_PROD_STOCK as  "Sipariş Miktarı",
	  CASE WHEN (SALEABLE_STOCK) <= 0 THEN 'Stok Yok'
		   WHEN (SALEABLE_STOCK) <= MINIMUM_STOCK THEN 'Yetersiz Stok'
		   WHEN (SALEABLE_STOCK) <= REPEAT_STOCK_VALUE AND SALEABLE_STOCK > MINIMUM_STOCK THEN 'Sipariş Ver'
		   WHEN (SALEABLE_STOCK) < MAXIMUM_STOCK AND SALEABLE_STOCK > REPEAT_STOCK_VALUE THEN 'Yeterli Stok'
		   WHEN  SALEABLE_STOCK >= MAXIMUM_STOCK THEN 'Fazla Stok' END  AS DURUM ,
	  STOCK_ACTION_MESSAGE AS "Strateji Türü"
 
 FROM      
  (  
    	<cfif attributes.strategy_status eq 1 or not len(attributes.strategy_status)>
			SELECT
				S.PRODUCT_UNIT_ID,
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				S.STOCK_CODE_2,
				S.STOCK_CODE,
				S.BARCOD,
				S.STOCK_ID AS PRODUCT_GROUPBY_ID,
				<cfif x_show_second_unit>
                	(SELECT PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                    (SELECT PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
                </cfif>	
				(S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,'')) PROD_NAME,
				<cfif isDefined("attributes.is_strategy")>
					GS_STRATEGY.MAXIMUM_STOCK MAXIMUM_STOCK,
					GS_STRATEGY.REPEAT_STOCK_VALUE REPEAT_STOCK_VALUE,
					GS_STRATEGY.MINIMUM_STOCK MINIMUM_STOCK,
					GS_STRATEGY.BLOCK_STOCK_VALUE BLOCK_STOCK_VALUE,
					GS_STRATEGY.MINIMUM_ORDER_STOCK_VALUE MINIMUM_ORDER_STOCK_VALUE,
					GS_STRATEGY.MAXIMUM_ORDER_STOCK_VALUE MAXIMUM_ORDER_STOCK_VALUE,
					GS_STRATEGY.STOCK_ACTION_ID STOCK_ACTION_ID,
				</cfif>
				SUM(GSL.REAL_STOCK) REAL_STOCK,
				SUM(GSL.SALEABLE_STOCK) SALEABLE_STOCK,
				SUM(GSL.RESERVE_SALE_ORDER_STOCK) RESERVE_SALE_ORDER_STOCK,
				SUM(GSL.RESERVE_PURCHASE_ORDER_STOCK) RESERVE_PURCHASE_ORDER_STOCK,
				SUM(GSL.RESERVED_PROD_STOCK) RESERVED_PROD_STOCK,
				SUM(GSL.PURCHASE_PROD_STOCK) PURCHASE_PROD_STOCK,
				SUM(GSL.NOSALE_STOCK) NOSALE_STOCK,
				SUM(GSL.BELONGTO_INSTITUTION_STOCK) BELONGTO_INSTITUTION_STOCK,
				SUM(GSL.NOSALE_RESERVED_STOCK) NOSALE_RESERVED_STOCK,
                PU.MAIN_UNIT,
                SETUP_SALEABLE_STOCK_ACTION.STOCK_ACTION_MESSAGE 
			FROM
				<cfif not len(attributes.department_id)>
					GET_STOCK_LAST_PROFILE GSL,
				<cfelse>
					GET_STOCK_LAST_LOCATION GSL,
				</cfif>
				#dsn3_alias#.STOCKS S
				LEFT JOIN #dsn3_alias#.PRODUCT P ON P.PRODUCT_ID = S.PRODUCT_ID
                LEFT JOIN #dsn3_alias#.PRODUCT_UNIT PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID 
				<cfif isDefined("attributes.is_strategy")>
					,GET_STOCK_STRATEGY GS_STRATEGY LEFT JOIN   #dsn3_alias#.SETUP_SALEABLE_STOCK_ACTION ON SETUP_SALEABLE_STOCK_ACTION.STOCK_ACTION_ID = GS_STRATEGY.STOCK_ACTION_ID
				</cfif>
			WHERE
				GSL.STOCK_ID = S.STOCK_ID 
				AND P.IS_INVENTORY = 1
				<cfif len(attributes.product_id) and len(attributes.product_name)>
					AND S.PRODUCT_ID = #attributes.product_id#
				</cfif>
				<cfif len(attributes.company_id) and len(attributes.company)>
					AND S.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(attributes.pos_code) and len(attributes.employee)>
					AND S.PRODUCT_MANAGER = #attributes.pos_code#
				</cfif>
				<cfif len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
					AND S.BRAND_ID = #attributes.brand_id# 
				</cfif>	
				<cfif len(attributes.product_code) and len(attributes.product_cat)>
					AND S.STOCK_CODE LIKE '#attributes.product_code#%'
				</cfif>
				<cfif isDefined("attributes.is_strategy")>
					AND S.STOCK_ID = GS_STRATEGY.STOCK_ID
				</cfif>
				<cfif len(attributes.department_id)>
					AND
					(
						(
							<cfif isDefined("attributes.is_strategy") and listlen(attributes.dept_name) eq 1>
								GS_STRATEGY.DEPARTMENT_ID = GSL.DEPARTMENT_ID AND
							</cfif>
							(
							<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
								(GSL.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND GSL.LOCATION_ID = #listlast(dept_i,'-')#)
								<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
							</cfloop>
							)
						)
						OR 
						(
							GSL.DEPARTMENT_ID = -1 
							<cfif isDefined("attributes.is_strategy") and listlen(attributes.dept_name) eq 1>
								AND GS_STRATEGY.DEPARTMENT_ID = #listfirst(attributes.department_id,'-')#
							<cfelseif isDefined("attributes.is_strategy")>
								AND GS_STRATEGY.DEPARTMENT_ID IS NULL
							</cfif>
						)
					)	
				<cfelseif isDefined("attributes.is_strategy")>
					AND	GS_STRATEGY.DEPARTMENT_ID IS NULL
                    AND GS_STRATEGY.MAXIMUM_STOCK IS NOT NULL
                    AND GS_STRATEGY.MINIMUM_STOCK IS NOT NULL
                    AND GS_STRATEGY.REPEAT_STOCK_VALUE IS NOT NULL
                    AND GS_STRATEGY.MINIMUM_ORDER_STOCK_VALUE IS NOT NULL
                    AND GS_STRATEGY.PROVISION_TIME IS NOT NULL		
				</cfif>
				<cfif len(attributes.product_status)>AND S.PRODUCT_STATUS = #attributes.product_status#</cfif>
				<cfif isdefined("attributes.is_price_list") and attributes.price_catid neq -2>
					AND S.PRODUCT_ID IN(
											SELECT  
												P.PRODUCT_ID
											FROM 
												#dsn3_alias#.PRICE P,
												#dsn3_alias#.PRODUCT_UNIT AS PU
											WHERE 
												P.PRODUCT_ID = PU.PRODUCT_ID
												AND ((ISNULL(P.STOCK_ID,0) = S.STOCK_ID AND P.STOCK_ID IS NOT NULL) OR (ISNULL(P.STOCK_ID,0) = 0 AND P.STOCK_ID IS NULL))
												AND ISNULL(P.SPECT_VAR_ID,0)=0
												AND PU.IS_MAIN = 1
												AND P.PRICE_CATID = #attributes.price_catid#
												AND P.STARTDATE <= #createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')#
												AND (P.FINISHDATE >= #createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')# OR P.FINISHDATE IS NULL)
												AND P.PRODUCT_ID = S.PRODUCT_ID
										)
				<cfelseif isdefined("attributes.is_price_list") and attributes.price_catid eq -2>
					AND S.PRODUCT_ID IN(
											SELECT  
												PS.PRODUCT_ID
											FROM 
												#dsn3_alias#.PRICE_STANDART PS,
												#dsn3_alias#.PRODUCT_UNIT AS PU
											WHERE 
												PS.PRODUCT_ID = PU.PRODUCT_ID
												AND PU.IS_MAIN = 1
												AND PS.PURCHASESALES = 1
												AND PS.PRICESTANDART_STATUS = 1
												AND PS.PRODUCT_ID = S.PRODUCT_ID
										)
				</cfif>
			GROUP BY
                 SETUP_SALEABLE_STOCK_ACTION.STOCK_ACTION_MESSAGE ,
                PU.MAIN_UNIT,
				S.PRODUCT_UNIT_ID,
				S.STOCK_CODE_2,
				STOCK_CODE,
				S.BARCOD,
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				<cfif isDefined("attributes.is_strategy")>
					GS_STRATEGY.MAXIMUM_STOCK,
					GS_STRATEGY.REPEAT_STOCK_VALUE,
					GS_STRATEGY.MINIMUM_STOCK,
					GS_STRATEGY.BLOCK_STOCK_VALUE,
					GS_STRATEGY.MINIMUM_ORDER_STOCK_VALUE,
					GS_STRATEGY.MAXIMUM_ORDER_STOCK_VALUE,
					GS_STRATEGY.STOCK_ACTION_ID,
				</cfif>
				PROPERTY,
				GSL.STOCK_ID,
				GSL.PRODUCT_ID
			<cfif isDefined("attributes.is_zero_stock")>
				HAVING SUM(GSL.REAL_STOCK) <>0
			</cfif>
		</cfif>
		<cfif isDefined("attributes.is_strategy") and not len(attributes.strategy_status)>
			UNION ALL
		</cfif>
		<cfif isDefined("attributes.is_strategy") and (attributes.strategy_status eq 2 or not len(attributes.strategy_status))>
			SELECT
				S.PRODUCT_UNIT_ID,
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				S.STOCK_CODE_2,
				S.STOCK_CODE,
				S.BARCOD,
				S.STOCK_ID AS PRODUCT_GROUPBY_ID,
				(S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,'')) PROD_NAME,
				<cfif isDefined("attributes.is_strategy")>
					0 MAXIMUM_STOCK,
					0 REPEAT_STOCK_VALUE,
					0 MINIMUM_STOCK,
					0 BLOCK_STOCK_VALUE,
					0 MINIMUM_ORDER_STOCK_VALUE,
					0 MAXIMUM_ORDER_STOCK_VALUE,
					0 STOCK_ACTION_ID,
				</cfif>
				SUM(GSL.REAL_STOCK) REAL_STOCK,
				SUM(GSL.SALEABLE_STOCK) SALEABLE_STOCK,
				SUM(GSL.RESERVE_SALE_ORDER_STOCK) RESERVE_SALE_ORDER_STOCK,
				SUM(GSL.RESERVE_PURCHASE_ORDER_STOCK) RESERVE_PURCHASE_ORDER_STOCK,
				SUM(GSL.RESERVED_PROD_STOCK) RESERVED_PROD_STOCK,
				SUM(GSL.PURCHASE_PROD_STOCK) PURCHASE_PROD_STOCK,
				SUM(GSL.NOSALE_STOCK) NOSALE_STOCK,
				SUM(GSL.BELONGTO_INSTITUTION_STOCK) BELONGTO_INSTITUTION_STOCK,
				SUM(GSL.NOSALE_RESERVED_STOCK) NOSALE_RESERVED_STOCK,
                PU.MAIN_UNIT,
                '' as STOCK_ACTION_MESSAGE
			FROM
				<cfif not len(attributes.department_id)>
					GET_STOCK_LAST_PROFILE GSL,
				<cfelse>
					GET_STOCK_LAST_LOCATION GSL,
				</cfif>
				#dsn3_alias#.STOCKS S
                LEFT JOIN #dsn3_alias#.PRODUCT_UNIT PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
				LEFT JOIN #dsn3_alias#.PRODUCT P ON P.PRODUCT_ID = S.PRODUCT_ID
			WHERE
				GSL.STOCK_ID = S.STOCK_ID 
				AND P.IS_INVENTORY = 1
				<cfif len(attributes.product_id) and len(attributes.product_name)>
					AND S.PRODUCT_ID = #attributes.product_id#
				</cfif>
				<cfif len(attributes.company_id) and len(attributes.company)>
					AND S.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(attributes.pos_code) and len(attributes.employee)>
					AND S.PRODUCT_MANAGER = #attributes.pos_code#
				</cfif>
				<cfif len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
					AND S.BRAND_ID = #attributes.brand_id# 
				</cfif>	
				<cfif len(attributes.product_code) and len(attributes.product_cat)>
					AND S.STOCK_CODE LIKE '#attributes.product_code#%'
				</cfif>
				<cfif isDefined("attributes.is_strategy")>
					AND S.STOCK_ID NOT IN(SELECT STOCK_ID FROM GET_STOCK_STRATEGY WHERE STOCK_ID IS NOT NULL)
				</cfif>
				<cfif len(attributes.department_id)>
					AND((
					<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(GSL.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND GSL.LOCATION_ID = #listlast(dept_i,'-')#)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
					</cfloop>)
					OR 
					GSL.DEPARTMENT_ID = -1)	
				</cfif>
				<cfif len(attributes.product_status)>AND S.PRODUCT_STATUS = #attributes.product_status#</cfif>
				<cfif isdefined("attributes.is_price_list") and attributes.price_catid neq -2>
					AND S.PRODUCT_ID IN(
											SELECT  
												P.PRODUCT_ID
											FROM 
												#dsn3_alias#.PRICE P,
												#dsn3_alias#.PRODUCT_UNIT AS PU
											WHERE 
												P.PRODUCT_ID = PU.PRODUCT_ID
												AND ((ISNULL(P.STOCK_ID,0) = S.STOCK_ID AND P.STOCK_ID IS NOT NULL) OR (ISNULL(P.STOCK_ID,0) = 0 AND P.STOCK_ID IS NULL))
												AND ISNULL(P.SPECT_VAR_ID,0)=0
												AND PU.IS_MAIN = 1
												AND P.PRICE_CATID = #attributes.price_catid#
												AND P.STARTDATE <= #createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')#
												AND (P.FINISHDATE >= #createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')# OR P.FINISHDATE IS NULL)
												AND P.PRODUCT_ID = S.PRODUCT_ID
										)
				<cfelseif isdefined("attributes.is_price_list") and attributes.price_catid eq -2>
					AND S.PRODUCT_ID IN(
											SELECT  
												PS.PRODUCT_ID
											FROM 
												#dsn3_alias#.PRICE_STANDART PS,
												#dsn3_alias#.PRODUCT_UNIT AS PU
											WHERE 
												PS.PRODUCT_ID = PU.PRODUCT_ID
												AND PU.IS_MAIN = 1
												AND PS.PURCHASESALES = 1
												AND PS.PRICESTANDART_STATUS = 1
												AND PS.PRODUCT_ID = S.PRODUCT_ID
										)
				</cfif>
			GROUP BY
				S.PRODUCT_UNIT_ID,
				S.STOCK_CODE_2,
				STOCK_CODE,
				S.BARCOD,
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				PROPERTY,
				GSL.STOCK_ID,
				GSL.PRODUCT_ID,
                PU.MAIN_UNIT
			<cfif isDefined("attributes.is_zero_stock")>
				HAVING SUM(GSL.REAL_STOCK) <>0
			</cfif>
		</cfif>
) AS GET_STOCK_PROFILE_  
ORDER BY
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME          
</cfquery>
<cfif not DirectoryExists("#upload_folder#/reserve_files/#dateFormat(now(),'yyyymmdd')#")>
	<cfdirectory action="create" directory="#upload_folder#/reserve_files/#dateFormat(now(),'yyyymmdd')#">
</cfif>
<cfset file_name = "stok_profil_#session.ep.userid#_#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#.xls">
<cfspreadsheet action="write"  filename="#upload_folder#/reserve_files/#dateFormat(now(),'yyyymmdd')#/#file_name#" QUERY="GET_ALL_STOCK1"  
sheet=1 sheetname="Stok Profil" overwrite=true> 
<!---   <cfspreadsheet action="write" filename="#trim(upload_folder)#/reserve_files/stock_profile_.xls" sheetname="Stok Profil" overwrite=true query="GET_ALL_STOCK1"> 
---><script type="text/javascript">
    <cfoutput>
        get_wrk_message_div("Excel","Excel","documents/reserve_files/#dateFormat(now(),'yyyymmdd')#/#file_name#") ;
    </cfoutput>
</script>
