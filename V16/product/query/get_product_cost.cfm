<cfif session.ep.isBranchAuthorization eq 0>
	<cfquery name="GET_PRODUCT_COST" datasource="#DSN3#"><!---  cachedwithin="#fusebox.general_cached_time#" --->
		SELECT 
			PC.*,
			P.PRODUCT_NAME,
			P.PRODUCT_ID,
			P.PRODUCT_CODE,
			PC.SPECT_MAIN_ID
		FROM 
			PRODUCT P,
			PRODUCT_COST PC
		WHERE
			P.PRODUCT_ID = PC.PRODUCT_ID AND
			PC.PRODUCT_COST_STATUS = 1
			<cfif (isDefined("attributes.product_status") and (attributes.product_status neq 2))> AND PRODUCT_STATUS = #attributes.product_status#</cfif>
			<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
				AND P.IS_PURCHASE=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
				AND P.IS_INVENTORY=0 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
				AND P.IS_TERAZI=1
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
				AND P.IS_INVENTORY=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
				AND P.IS_PURCHASE=0 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
				AND P.IS_PRODUCTION=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
				AND P.IS_SERIAL_NO=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
				AND P.IS_KARMA=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
				AND P.IS_INTERNET=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
				AND P.IS_PROTOTYPE=1
			</cfif>
			<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>AND P.PRODUCT_MANAGER = #attributes.pos_code#</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>AND P.COMPANY_ID = #attributes.company_id#</cfif>
			<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>AND P.BRAND_ID = #attributes.brand_id#</cfif>				
			<cfif isdefined("attributes.cat") and len(attributes.cat)>AND P.PRODUCT_CODE LIKE '#attributes.cat#.%'</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND 
				(
					<cfif isnumeric(attributes.keyword)>
					(
						P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM STOCKS WHERE STOCK_ID = #attributes.keyword#)
					) 
					OR
					</cfif>
					(
					<cfif len(attributes.keyword) lte 3>
						P.PRODUCT_NAME LIKE '#attributes.keyword#%' 
					<cfelseif len(attributes.keyword) gt 3>
						<cfif listlen(attributes.keyword,"+") gt 1>
							(
								<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
									P.PRODUCT_NAME LIKE '<cfif pro_index neq 1>%</cfif>#ListGetAt(attributes.keyword,pro_index,"+")#%' 
									<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
								</cfloop>
							)		
						<cfelse>
							P.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
							P.PRODUCT_CODE LIKE '%#replace(attributes.keyword,"+","")#%' OR
							P.BARCOD='#attributes.keyword#' OR 
							P.MANUFACT_CODE LIKE '%#attributes.keyword#%' 
						</cfif>
					</cfif>		
					)
				)
			</cfif>
			<cfif isDefined("attributes.special_code") and len(attributes.special_code)>AND P.PRODUCT_CODE_2 LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.special_code#%'</cfif>
			<cfif isdefined("attributes.inventory_calc_type") and len(attributes.inventory_calc_type)>AND PC.INVENTORY_CALC_TYPE = #attributes.inventory_calc_type#</cfif>
		ORDER BY 
			P.PRODUCT_NAME
	</cfquery>
<cfelse>
	<cfquery name="GET_PRODUCT_COST" datasource="#DSN2#">
	 	SELECT 
			PC.*,
			P.PRODUCT_NAME,
			P.PRODUCT_ID,
			P.PRODUCT_CODE,
			DEPARTMENT_HEAD
			<cfif database_type is 'MSSQL'>
			+'-'+
			<cfelseif database_type is 'DB2'>
			||'-'||
			</cfif>
			  SL.COMMENT AS DEPARTMENT
		FROM 
			#dsn3_alias#.PRODUCT P,
			GET_PRODUCT_COST_PERIOD PC,
			#DSN_ALIAS#.STOCKS_LOCATION SL,
			#DSN_ALIAS#.DEPARTMENT D
		WHERE
			P.PRODUCT_ID = PC.PRODUCT_ID AND
			SL.LOCATION_ID = PC.LOCATION_ID AND
			SL.DEPARTMENT_ID = PC.DEPARTMENT_ID AND
			D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND
			PC.PRODUCT_COST_ID IN (SELECT MAX(PRODUCT_COST_ID) FROM GET_PRODUCT_COST_PERIOD WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#) GROUP BY PRODUCT_ID,SPECT_MAIN_ID )
			
			<cfif (isDefined("attributes.product_status") and (attributes.product_status neq 2))> AND PRODUCT_STATUS = #attributes.product_status#</cfif>
			<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
				AND P.IS_PURCHASE=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
				AND P.IS_INVENTORY=0 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
				AND P.IS_TERAZI=1
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
				AND P.IS_INVENTORY=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
				AND P.IS_PURCHASE=0 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
				AND P.IS_PRODUCTION=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
				AND P.IS_SERIAL_NO=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
				AND P.IS_KARMA=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
				AND P.IS_INTERNET=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
				AND P.IS_PROTOTYPE=1
			</cfif>
			<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>AND P.PRODUCT_MANAGER = #attributes.pos_code#</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>AND P.COMPANY_ID = #attributes.company_id#</cfif>
			<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>AND P.BRAND_ID = #attributes.brand_id#</cfif>				
			<cfif isdefined("attributes.cat") and len(attributes.cat)>AND P.PRODUCT_CODE LIKE '#attributes.cat#.%'</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND 
				(
					<cfif isnumeric(attributes.keyword)>
					(
						P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn3_alias#.STOCKS STOCKS WHERE STOCK_ID = #attributes.keyword#)
					) 
					OR
					</cfif>
					(
					<cfif len(attributes.keyword) lte 3>
						P.PRODUCT_NAME LIKE '#attributes.keyword#%' 
					<cfelseif len(attributes.keyword) gt 3>
						<cfif listlen(attributes.keyword,"+") gt 1>
							(
								<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
									P.PRODUCT_NAME LIKE '<cfif pro_index neq 1>%</cfif>#ListGetAt(attributes.keyword,pro_index,"+")#%' 
									<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
								</cfloop>
							)		
						<cfelse>
							P.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
							P.PRODUCT_CODE LIKE '%#replace(attributes.keyword,"+","")#%' OR
							P.BARCOD='#attributes.keyword#' OR 
							P.MANUFACT_CODE LIKE '%#attributes.keyword#%' 
						</cfif>
					</cfif>		
					)
				)
			</cfif>
			<cfif isDefined("attributes.special_code") and len(attributes.special_code)>AND P.PRODUCT_CODE_2 LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.special_code#%'</cfif>
		ORDER BY 
			P.PRODUCT_NAME,
			PC.START_DATE DESC,
			PC.RECORD_DATE DESC
		<!--- SELECT 
			PC.*,
			P.PRODUCT_NAME,
			P.PRODUCT_ID,
			P.PRODUCT_CODE,
			P.INVENTORY_CALC_TYPE
		FROM 
			#dsn3_alias#.PRODUCT P,
			GET_PRODUCT_COST_BRANCH_PERIOD PC
		WHERE
			P.PRODUCT_ID = PC.PRODUCT_ID AND
			PC.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
			<cfif (isDefined("attributes.product_status") and (attributes.product_status neq 2))> AND PRODUCT_STATUS = #attributes.product_status#</cfif>
			<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
				AND P.IS_PURCHASE=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
				AND P.IS_INVENTORY=0 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
				AND P.IS_TERAZI=1
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
				AND P.IS_INVENTORY=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
				AND P.IS_PURCHASE=0 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
				AND P.IS_PRODUCTION=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
				AND P.IS_SERIAL_NO=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
				AND P.IS_KARMA=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
				AND P.IS_INTERNET=1 
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
				AND P.IS_PROTOTYPE=1
			</cfif>
			<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>AND P.PRODUCT_MANAGER = #attributes.pos_code#</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>AND P.COMPANY_ID = #attributes.company_id#</cfif>
			<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>AND P.BRAND_ID = #attributes.brand_id#</cfif>				
			<cfif isdefined("attributes.cat") and len(attributes.cat)>AND P.PRODUCT_CODE LIKE '#attributes.cat#.%'</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND 
				(
					<cfif isnumeric(attributes.keyword)>
					(
						P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM STOCKS WHERE STOCK_ID = #attributes.keyword#)
					) 
					OR
					</cfif>
					(
					<cfif len(attributes.keyword) lte 3>
						P.PRODUCT_NAME LIKE '#attributes.keyword#%' 
					<cfelseif len(attributes.keyword) gt 3>
						<cfif listlen(attributes.keyword,"+") gt 1>
							(
								<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
									P.PRODUCT_NAME LIKE '<cfif pro_index neq 1>%</cfif>#ListGetAt(attributes.keyword,pro_index,"+")#%' 
									<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
								</cfloop>
							)		
						<cfelse>
							P.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
							P.PRODUCT_CODE LIKE '%#replace(attributes.keyword,"+","")#%' OR
							P.BARCOD='#attributes.keyword#' OR 
							P.MANUFACT_CODE LIKE '%#attributes.keyword#%' 
						</cfif>
					</cfif>		
					)
				)
			</cfif>
			<cfif isDefined("attributes.special_code") and len(attributes.special_code)>AND P.PRODUCT_CODE_2 LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.special_code#%'</cfif>
			<cfif isdefined("attributes.inventory_calc_type") and len(attributes.inventory_calc_type)>AND P.INVENTORY_CALC_TYPE = #attributes.inventory_calc_type#</cfif>
		ORDER BY 
			P.PRODUCT_NAME --->
	</cfquery>
</cfif>
