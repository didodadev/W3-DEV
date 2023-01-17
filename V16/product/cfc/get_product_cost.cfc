<cfset dsn = application.systemParam.systemParam().dsn>
<cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
<cfset dsn3 = dsn & '_' & session.ep.company_id>
<cffunction name="get_product_cost_fnc" returntype="query">
<cfargument name="product_status" default="">
<cfargument name="product_types" default="">
<cfargument name="pos_code" default="">
<cfargument name="company_id" default="">
<cfargument name="brand_id" default="">
<cfargument name="brand_name" default="">
<cfargument name="cat" default="">
<cfargument name="keyword" default="">
<cfargument name="special_code" default="">
<cfargument name="inventory_calc_type" default="">
<cfargument name="module_name" default="">
<cfif session.ep.isBranchAuthorization eq 0>
	<cfquery name="GET_PRODUCT_COST" datasource="#this.DSN3#"><!---  cachedwithin="#fusebox.general_cached_time#" --->
		SELECT 
			PC.*,
            PC.PURCHASE_NET_ALL,
			P.PRODUCT_NAME,
			P.PRODUCT_ID,
			P.PRODUCT_CODE,
			PC.SPECT_MAIN_ID
		FROM 
			PRODUCT P,
			PRODUCT_COST PC
		WHERE
			P.PRODUCT_ID = PC.PRODUCT_ID AND
			PC.PRODUCT_COST_ID = (SELECT MAX(PCC.PRODUCT_COST_ID) FROM PRODUCT_COST PCC WHERE PCC.PRODUCT_ID = PC.PRODUCT_ID AND ISNULL(PCC.SPECT_MAIN_ID,0) = ISNULL(PC.SPECT_MAIN_ID,0))
			<cfif (isDefined("arguments.product_status") and (arguments.product_status neq 2))> AND PRODUCT_STATUS = #arguments.product_status#</cfif>
			<cfif isdefined('arguments.product_types') and (arguments.product_types eq 1)>
				AND P.IS_PURCHASE=1 
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 2)>
				AND P.IS_INVENTORY=0 
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 3)>
				AND P.IS_TERAZI=1
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 4)>
				AND P.IS_INVENTORY=1 
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 5)>
				AND P.IS_PURCHASE=0 
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 6)>
				AND P.IS_PRODUCTION=1 
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 7)>
				AND P.IS_SERIAL_NO=1 
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 8)>
				AND P.IS_KARMA=1 
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 9)>
				AND P.IS_INTERNET=1 
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 10)>
				AND P.IS_PROTOTYPE=1
			</cfif>
			<cfif isdefined("arguments.pos_code") and len(arguments.pos_code)>AND P.PRODUCT_MANAGER = #arguments.pos_code#</cfif>
			<cfif isdefined("arguments.company_id") and len(arguments.company_id)>AND P.COMPANY_ID = #arguments.company_id#</cfif>
			<cfif isdefined("arguments.brand_id") and len(arguments.brand_id) and len(arguments.brand_name)>AND P.BRAND_ID = #arguments.brand_id#</cfif>				
			<cfif isdefined("arguments.cat") and len(arguments.cat)>AND P.PRODUCT_CODE LIKE '#arguments.cat#.%'</cfif>
			<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
				AND 
				(
					<cfif isnumeric(arguments.keyword)>
					(
						P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM STOCKS WHERE STOCK_ID = #arguments.keyword#)
					) 
					OR
					</cfif>
					(
					<cfif len(arguments.keyword) lte 3>
						P.PRODUCT_NAME LIKE '#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
					<cfelseif len(arguments.keyword) gt 3>
						<cfif listlen(arguments.keyword,"+") gt 1>
							(
								<cfloop from="1" to="#listlen(arguments.keyword,'+')#" index="pro_index">
									P.PRODUCT_NAME LIKE '<cfif pro_index neq 1>%</cfif>#ListGetAt(arguments.keyword,pro_index,"+")#%' COLLATE SQL_Latin1_General_CP1_CI_AI
									<cfif pro_index neq listlen(arguments.keyword,'+')>AND</cfif>
								</cfloop>
							)		
						<cfelse>
							P.PRODUCT_NAME LIKE '%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
							P.PRODUCT_CODE LIKE '%#replace(arguments.keyword,"+","")#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
							P.BARCOD='#arguments.keyword#' COLLATE SQL_Latin1_General_CP1_CI_AI OR 
							P.MANUFACT_CODE LIKE '%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
						</cfif>
					</cfif>		
					)
				)
			</cfif>
			<cfif isDefined("arguments.special_code") and len(arguments.special_code)>AND P.PRODUCT_CODE_2 LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.special_code#%'</cfif>
			<cfif len(arguments.inventory_calc_type)>AND PC.INVENTORY_CALC_TYPE = #arguments.inventory_calc_type#</cfif>
		ORDER BY 
			P.PRODUCT_NAME
	</cfquery>
<cfelse>
	<cfquery name="GET_PRODUCT_COST" datasource="#this.DSN2#">
	 	SELECT 
			PC.*,
			P.PRODUCT_NAME,
			P.PRODUCT_ID,
			P.PRODUCT_CODE,
			DEPARTMENT_HEAD + '-' + SL.COMMENT AS DEPARTMENT
		FROM 
			#this.dsn3_alias#.PRODUCT P,
			GET_PRODUCT_COST_PERIOD PC,
			#this.DSN_ALIAS#.STOCKS_LOCATION SL,
			#this.DSN_ALIAS#.DEPARTMENT D
		WHERE
			P.PRODUCT_ID = PC.PRODUCT_ID AND
			SL.LOCATION_ID = PC.LOCATION_ID AND
			SL.DEPARTMENT_ID = PC.DEPARTMENT_ID AND
			D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND
			PC.PRODUCT_COST_ID IN (SELECT MAX(PRODUCT_COST_ID) FROM GET_PRODUCT_COST_PERIOD WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #this.dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#) GROUP BY PRODUCT_ID,SPECT_MAIN_ID )
			<cfif (isDefined("arguments.product_status") and (arguments.product_status neq 2))> AND PRODUCT_STATUS = #arguments.product_status#</cfif>
			<cfif isdefined('arguments.product_types') and (arguments.product_types eq 1)>
				AND P.IS_PURCHASE=1 
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 2)>
				AND P.IS_INVENTORY=0 
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 3)>
				AND P.IS_TERAZI=1
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 4)>
				AND P.IS_INVENTORY=1 
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 5)>
				AND P.IS_PURCHASE=0 
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 6)>
				AND P.IS_PRODUCTION=1 
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 7)>
				AND P.IS_SERIAL_NO=1 
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 8)>
				AND P.IS_KARMA=1 
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 9)>
				AND P.IS_INTERNET=1 
			<cfelseif isdefined('arguments.product_types') and (arguments.product_types eq 10)>
				AND P.IS_PROTOTYPE=1
			</cfif>
			<cfif isdefined("arguments.pos_code") and len(arguments.pos_code)>AND P.PRODUCT_MANAGER = #arguments.pos_code#</cfif>
			<cfif isdefined("arguments.company_id") and len(arguments.company_id)>AND P.COMPANY_ID = #arguments.company_id#</cfif>
			<cfif isdefined("arguments.brand_id") and len(arguments.brand_id) and len(arguments.brand_name)>AND P.BRAND_ID = #arguments.brand_id#</cfif>				
			<cfif isdefined("arguments.cat") and len(arguments.cat)>AND P.PRODUCT_CODE LIKE '#arguments.cat#.%'</cfif>
			<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
				AND 
				(
					<cfif isnumeric(arguments.keyword)>
					(
						P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn3_alias#.STOCKS STOCKS WHERE STOCK_ID = #arguments.keyword#)
					) 
					OR
					</cfif>
					(
					<cfif len(arguments.keyword) lte 3>
						P.PRODUCT_NAME LIKE '#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
					<cfelseif len(arguments.keyword) gt 3>
						<cfif listlen(arguments.keyword,"+") gt 1>
							(
								<cfloop from="1" to="#listlen(arguments.keyword,'+')#" index="pro_index">
									P.PRODUCT_NAME LIKE '<cfif pro_index neq 1>%</cfif>#ListGetAt(arguments.keyword,pro_index,"+")#%' COLLATE SQL_Latin1_General_CP1_CI_AI
									<cfif pro_index neq listlen(arguments.keyword,'+')>AND</cfif>
								</cfloop>
							)		
						<cfelse>
							P.PRODUCT_NAME LIKE '%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
							P.PRODUCT_CODE LIKE '%#replace(arguments.keyword,"+","")#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
							P.BARCOD='#arguments.keyword#' COLLATE SQL_Latin1_General_CP1_CI_AI OR 
							P.MANUFACT_CODE LIKE '%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
						</cfif>
					</cfif>		
					)
				)
			</cfif>
			<cfif isDefined("arguments.special_code") and len(arguments.special_code)>AND P.PRODUCT_CODE_2 LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.special_code#%'</cfif>
		ORDER BY 
			P.PRODUCT_NAME,
			PC.START_DATE DESC,
			PC.RECORD_DATE DESC
	</cfquery>
</cfif>
<cfreturn GET_PRODUCT_COST>
</cffunction>
<cffunction name="PRODUCT_EXT_COST_DET" returntype="query">
	<cfargument name="prod_id" default="">
	<cfargument name="pr_id" default="">
	<cfquery name="PRODUCT_EXT_COST_DET" datasource="#dsn3#">
		SELECT 
			P.PRODUCT_NAME,
			EC.EXPENSE,
			AP.ACCOUNT_NAME,
			PD.EXPENSE_SHIFT,
			PD.AMOUNT,
			PD.MONEY
		FROM 
			PRODUCT_EXTRA_COST_DETAIL PD
				LEFT JOIN PRODUCT P ON P.PRODUCT_ID = PD.PRODUCT_ID
				LEFT JOIN #dsn2#.EXPENSE_CENTER EC ON EC.EXPENSE_ID = PD.EXPENSE_ID
				LEFT JOIN #dsn2#.ACCOUNT_PLAN AP ON AP.ACCOUNT_CODE = PD.ACCOUNT_ID           
		WHERE 
			PD.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prod_id#"> AND
			PD.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pr_id#">
	</cfquery>
	<cfreturn PRODUCT_EXT_COST_DET>
</cffunction>