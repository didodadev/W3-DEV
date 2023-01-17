<cfcomponent displayname="get_stock" hint="">
	<cffunction name="get_stock_analyses" returntype="query" hint="">
        <cfargument name="report_type" default="">
        <cfargument name="location_based_cost" default="">
        <cfargument name="display_cost_money" default="">
        <cfargument name="department_id" default="">
        <cfargument name="department_id_new" default="">
        <cfargument name="product_status" default="">
        <cfargument name="is_envantory" default="">
        <cfargument name="sup_company" default="">
        <cfargument name="sup_company_id" default="">
        <cfargument name="employee_name" default="">
        <cfargument name="product_employee_id" default="">
        <cfargument name="product_name" default="">
        <cfargument name="product_id" default="">
        <cfargument name="brand_id" default="">
        <cfargument name="brand_name" default="">
        <cfargument name="product_cat" default="">
        <cfargument name="product_code" default="">
        <cfargument name="control_total_stock" default="">
        <cfargument name="is_stock_action" default="">
        <cfargument name="date2" default="">
        <cfargument name="startrow" default="">
        <cfargument name="data_source" default="">
        <cfargument name="maxrows" default="">
        <cfargument name="page" default="1"> 
        <cfargument name="dsn_alias" default="">
        <cfargument name="dsn3_alias" default="">
        <cfargument name="dsn2_alias" default="">
        <cfargument name="dsn3" default="">
        <cfargument name="start_period_cost_date" default="">
        <cfargument name="finish_date" default="">
        <cfargument name="is_store" default="">
        <cfargument name="x_dsp_spec_name" default="">
        <cfargument name="is_stock_based_cost" default="">
		<cfargument name="is_belognto_institution" default="">
		<cfargument name="branch_dep_list" default="">

        <cfsavecontent variable="order_by">
			<cfif arguments.report_type eq 1>
				STOCK_CODE
			<cfelse>
				ACIKLAMA
			</cfif>
		</cfsavecontent>
		<cf_wrk_cfc_query datasource="#data_source#" query_name="get_all_stock" startrow="#startrow#" maxrows="#maxrows#" order_by ="#order_by#">
		<cfoutput>
			SELECT DISTINCT
			<cfif arguments.report_type eq 1>
					S.STOCK_CODE,
					S.STOCK_ID AS PRODUCT_GROUPBY_ID,
					(S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,' ')) ACIKLAMA,
					S.MANUFACT_CODE,
					S.PRODUCT_UNIT_ID,
					PU.MAIN_UNIT,
					PU.DIMENTION,
					S.BARCOD,
					S.PRODUCT_CODE,
					S.STOCK_CODE_2,
				<cfelseif arguments.report_type eq 2>
					S.PRODUCT_ID AS PRODUCT_GROUPBY_ID,
					S.PRODUCT_NAME AS ACIKLAMA,
					S.MANUFACT_CODE,
					PU.MAIN_UNIT,
					PU.DIMENTION,
					S.PRODUCT_BARCOD AS BARCOD,
					S.PRODUCT_CODE,
				<cfelseif arguments.report_type eq 3>
					S.PRODUCT_CATID AS PRODUCT_GROUPBY_ID,
					PC.PRODUCT_CAT AS ACIKLAMA,
				<cfelseif arguments.report_type eq 4>
					S.PRODUCT_MANAGER AS PRODUCT_GROUPBY_ID,
					(EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME) AS ACIKLAMA,
				<cfelseif arguments.report_type eq 5>
					 PB.BRAND_ID AS PRODUCT_GROUPBY_ID,
					 PB.BRAND_NAME AS ACIKLAMA,
				<cfelseif arguments.report_type eq 6>
					 S.COMPANY_ID AS PRODUCT_GROUPBY_ID,
					 C.NICKNAME AS ACIKLAMA,
				<cfelseif arguments.report_type eq 9>
					 SR.STORE AS PRODUCT_GROUPBY_ID,
					 D.DEPARTMENT_HEAD AS ACIKLAMA,
				<cfelseif arguments.report_type eq 10>
					 CAST(SR.STORE AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.STORE_LOCATION,0) AS NVARCHAR(50)) AS PRODUCT_GROUPBY_ID,
					 D.DEPARTMENT_HEAD+' - '+SL.COMMENT AS ACIKLAMA,
				<cfelseif arguments.report_type eq 8>
					S.STOCK_CODE,
					S.STOCK_ID,
					CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)) AS PRODUCT_GROUPBY_ID,
					SR.SPECT_VAR_ID SPECT_VAR_ID,
					<cfif len(x_dsp_spec_name) and x_dsp_spec_name eq 1>
					ISNULL((SELECT SPECT_MAIN_NAME FROM #dsn3_alias#.SPECT_MAIN SP WHERE SP.SPECT_MAIN_ID = SR.SPECT_VAR_ID),' ') AS SPECT_NAME,
					</cfif>
					(S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,' ')) ACIKLAMA,
					S.MANUFACT_CODE,
					S.PRODUCT_UNIT_ID,
					PU.MAIN_UNIT,
					PU.DIMENTION,
					S.BARCOD,
					S.PRODUCT_CODE,
				</cfif>
				S.PRODUCT_STATUS,
				S.PRODUCT_ID,
				S.IS_PRODUCTION,
				<cfif listfind('2,3,4,5,6,9',arguments.report_type) and len(arguments.location_based_cost)>
					SL.DEPARTMENT_ID,
					SL.LOCATION_ID,
				</cfif>
				ISNULL((
					SELECT TOP 1
						<cfif len(arguments.location_based_cost)>
							<cfif isdefined("arguments.display_cost_money") and len(arguments.display_cost_money)>
								(PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
							<cfelse>
								(PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
							</cfif>
						<cfelse>
							<cfif isdefined("arguments.display_cost_money") and len(arguments.display_cost_money)>
								(PURCHASE_NET+PURCHASE_EXTRA_COST)
							<cfelse>
								(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
							</cfif>	
						</cfif>
					FROM 
						#dsn3_alias#.PRODUCT_COST WITH (NOLOCK)
					WHERE 
						START_DATE <= #start_period_cost_date# 
						AND PRODUCT_ID = S.PRODUCT_ID
						<cfif arguments.report_type eq 8>
							 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
						</cfif>
						<cfif is_stock_based_cost eq 1 and arguments.report_type neq 2>
							AND PRODUCT_COST.STOCK_ID = SR.STOCK_ID 
						</cfif>
						<cfif len(arguments.location_based_cost)>
							<cfif len(arguments.department_id)>
								AND DEPARTMENT_ID = #listgetat(arguments.department_id,1,'-')#
								AND LOCATION_ID = #listgetat(arguments.department_id,2,'-')#
							<cfelse>
								AND DEPARTMENT_ID = D.DEPARTMENT_ID
								AND LOCATION_ID = SL.LOCATION_ID
							</cfif>
						</cfif>
					ORDER BY 
						START_DATE DESC, 
						RECORD_DATE DESC,
						PRODUCT_COST_ID DESC
				),0) ALL_START_COST,
				ISNULL((
					SELECT TOP 1 
						<cfif len(arguments.location_based_cost)>
							(PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
						<cfelse>
							(PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
						</cfif>
					FROM 
						#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
					WHERE 
						START_DATE <= #start_period_cost_date# 
						AND PRODUCT_ID = S.PRODUCT_ID
						<cfif arguments.report_type eq 8>
							 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
						</cfif>
						<cfif is_stock_based_cost eq 1 and arguments.report_type neq 2>
							AND PRODUCT_COST.STOCK_ID = SR.STOCK_ID 
						</cfif>
						<cfif len(arguments.location_based_cost)>
							<cfif len(arguments.department_id)>
								AND DEPARTMENT_ID = #listgetat(arguments.department_id,1,'-')#
								AND LOCATION_ID = #listgetat(arguments.department_id,2,'-')#
							<cfelse>
								AND DEPARTMENT_ID = D.DEPARTMENT_ID
								AND LOCATION_ID = SL.LOCATION_ID
							</cfif>
						</cfif>
					ORDER BY 
						START_DATE DESC, 
						RECORD_DATE DESC,
						PRODUCT_COST_ID DESC
				),0) ALL_START_COST_2,
				ISNULL((
					SELECT TOP 1 
						<cfif len(arguments.location_based_cost)>
							<cfif isdefined("arguments.display_cost_money") and len(arguments.display_cost_money)>
								(PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
							<cfelse>
								(PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
							</cfif>
						<cfelse>
							<cfif isdefined("arguments.display_cost_money") and len(arguments.display_cost_money)>
								(PURCHASE_NET+PURCHASE_EXTRA_COST)
							<cfelse>
								(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
							</cfif>	
						</cfif>
					FROM 
						#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
					WHERE 
						START_DATE <= #finish_date# 
						AND PRODUCT_ID = S.PRODUCT_ID
						<cfif arguments.report_type eq 8>
							 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
						</cfif>
						<cfif is_stock_based_cost eq 1 and arguments.report_type neq 2>
							AND PRODUCT_COST.STOCK_ID = SR.STOCK_ID 
						</cfif>
						<cfif len(arguments.location_based_cost)>
							<cfif len(arguments.department_id)>
								AND DEPARTMENT_ID = #listgetat(arguments.department_id,1,'-')#
								AND LOCATION_ID = #listgetat(arguments.department_id,2,'-')#
							<cfelse>
								AND DEPARTMENT_ID = D.DEPARTMENT_ID
								AND LOCATION_ID = SL.LOCATION_ID
							</cfif>
						</cfif>
					ORDER BY 
						START_DATE DESC, 
						RECORD_DATE DESC,
						PRODUCT_COST_ID DESC
				),0) ALL_FINISH_COST,
				ISNULL((
					SELECT TOP 1
						<cfif len(arguments.location_based_cost)>
							(PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
						<cfelse>
							(PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
						</cfif>
					FROM 
						#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
					WHERE 
						START_DATE <= #finish_date# 
						AND PRODUCT_ID = S.PRODUCT_ID
						<cfif arguments.report_type eq 8>
							 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
						</cfif>
						<cfif is_stock_based_cost eq 1 and arguments.report_type neq 2>
							AND PRODUCT_COST.STOCK_ID = SR.STOCK_ID 
						</cfif>
						<cfif len(arguments.location_based_cost)>
							<cfif len(arguments.department_id)>
								AND DEPARTMENT_ID = #listgetat(arguments.department_id,1,'-')#
								AND LOCATION_ID = #listgetat(arguments.department_id,2,'-')#
							<cfelse>
								AND DEPARTMENT_ID = D.DEPARTMENT_ID
								AND LOCATION_ID = SL.LOCATION_ID
							</cfif>
						</cfif>
					ORDER BY 
						START_DATE DESC, 
						RECORD_DATE DESC,
						PRODUCT_COST_ID DESC
				),0) ALL_FINISH_COST_2
				<cfif isdefined("arguments.display_cost_money") and len(arguments.display_cost_money)>
					,ISNULL((
						SELECT TOP 1 
							<cfif len(arguments.location_based_cost)>
								PURCHASE_NET_MONEY_LOCATION
							<cfelse>
								PURCHASE_NET_MONEY
							</cfif>
						FROM 
							#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
						WHERE 
							START_DATE <= #start_period_cost_date# 
							AND PRODUCT_ID = S.PRODUCT_ID
							<cfif arguments.report_type eq 8>
								 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
							</cfif>
							<cfif is_stock_based_cost eq 1 and arguments.report_type neq 2>
								AND PRODUCT_COST.STOCK_ID = SR.STOCK_ID 
							</cfif>
							<cfif len(arguments.location_based_cost)>
								<cfif len(arguments.department_id)>
									AND DEPARTMENT_ID = #listgetat(arguments.department_id,1,'-')#
									AND LOCATION_ID = #listgetat(arguments.department_id,2,'-')#
								<cfelse>
									AND DEPARTMENT_ID = D.DEPARTMENT_ID
									AND LOCATION_ID = SL.LOCATION_ID
								</cfif>
							</cfif>
						ORDER BY 
							START_DATE DESC, 
							RECORD_DATE DESC,
							PRODUCT_COST_ID DESC
					),' ') ALL_START_MONEY,
					ISNULL((
						SELECT TOP 1 
							<cfif len(arguments.location_based_cost)>
								PURCHASE_NET_MONEY_LOCATION
							<cfelse>
								PURCHASE_NET_MONEY
							</cfif>
						FROM 
							#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
						WHERE 
							START_DATE <= #finish_date# 
							AND PRODUCT_ID = S.PRODUCT_ID
							<cfif arguments.report_type eq 8>
								 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
							</cfif>
							<cfif is_stock_based_cost eq 1 and arguments.report_type neq 2>
								AND PRODUCT_COST.STOCK_ID = SR.STOCK_ID 
							</cfif>
							<cfif len(arguments.location_based_cost)>
								<cfif len(arguments.department_id)>
									AND DEPARTMENT_ID = #listgetat(arguments.department_id,1,'-')#
									AND LOCATION_ID = #listgetat(arguments.department_id,2,'-')#
								<cfelse>
									AND DEPARTMENT_ID = D.DEPARTMENT_ID
									AND LOCATION_ID = SL.LOCATION_ID
								</cfif>
							</cfif>
						ORDER BY 
							START_DATE DESC, 
							RECORD_DATE DESC,
							PRODUCT_COST_ID DESC
					),' ') ALL_FINISH_MONEY
				</cfif>	
			FROM		
				#dsn3_alias#.STOCKS S WITH (NOLOCK),
				#dsn3_alias#.PRODUCT_UNIT PU WITH (NOLOCK)
				<cfif arguments.report_type eq 3>
					,#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK)
				<cfelseif arguments.report_type eq 4>
					,#dsn_alias#.EMPLOYEE_POSITIONS EP WITH (NOLOCK)
				<cfelseif arguments.report_type eq 5>
					,#dsn3_alias#.PRODUCT_BRANDS PB WITH (NOLOCK)
				<cfelseif arguments.report_type eq 6>
					 ,#dsn_alias#.COMPANY C WITH (NOLOCK)
				<cfelseif arguments.report_type eq 8>
					 ,#dsn2_alias#.STOCKS_ROW SR WITH (NOLOCK)
				<cfelseif arguments.report_type eq 9>
					 ,#dsn_alias#.DEPARTMENT D WITH (NOLOCK)
					 ,#dsn2_alias#.STOCKS_ROW SR WITH (NOLOCK)
				<cfelseif arguments.report_type eq 10>
					 ,#dsn_alias#.DEPARTMENT D WITH (NOLOCK)
					 ,#dsn_alias#.STOCKS_LOCATION SL WITH (NOLOCK)
					 ,#dsn2_alias#.STOCKS_ROW SR WITH (NOLOCK)
				</cfif>
				<cfif listfind('2,3,4,5,6,9',arguments.report_type) and len(arguments.location_based_cost)>
					<cfif arguments.report_type neq 9>
						 ,#dsn_alias#.DEPARTMENT D WITH (NOLOCK)
					</cfif>
					 ,#dsn_alias#.STOCKS_LOCATION SL WITH (NOLOCK)
				</cfif>
			WHERE
				S.STOCK_ID IN
				(
					SELECT
						SR.STOCK_ID
					FROM
						STOCKS_ROW AS SR WITH (NOLOCK)
					WHERE
						SR.STOCK_ID=S.STOCK_ID
						<cfif arguments.report_type neq 9>
							<cfif len(arguments.department_id)>
								AND
									(
									<cfloop list="#arguments.department_id#" delimiters="," index="dept_i">
									(SR.STORE = #listfirst(dept_i,'-')# AND SR.STORE_LOCATION = #listlast(dept_i,'-')#)
									<cfif dept_i neq listlast(arguments.department_id,',') and listlen(arguments.department_id,',') gte 1> OR</cfif>
									</cfloop>  
									)
							<cfelseif is_store>
								AND	SR.STORE IN (#branch_dep_list#)
							</cfif>
						<cfelse>
							<cfif len(arguments.department_id_new)>
								AND SR.STORE IN (#arguments.department_id_new#)
							<cfelseif is_store>
								AND	SR.STORE IN (#branch_dep_list#)
							</cfif>	
						</cfif>
				)
				AND S.PRODUCT_ID=PU.PRODUCT_ID
				AND S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID
				<cfif len(arguments.product_status)>AND S.PRODUCT_STATUS = #arguments.product_status#</cfif>
				<cfif len(arguments.is_envantory)>
					AND S.IS_INVENTORY=1
				</cfif>
				<cfif arguments.report_type eq 3>
					AND PC.PRODUCT_CATID = S.PRODUCT_CATID
				<cfelseif arguments.report_type eq 4>
					AND EP.POSITION_CODE = S.PRODUCT_MANAGER
				<cfelseif arguments.report_type eq 5>
					AND PB.BRAND_ID=S.BRAND_ID
				<cfelseif arguments.report_type eq 6>
					AND S.COMPANY_ID=C.COMPANY_ID
				<cfelseif arguments.report_type eq 8>
					AND SR.STOCK_ID=S.STOCK_ID
				<cfelseif arguments.report_type eq 9>
					AND SR.STORE=D.DEPARTMENT_ID
				<cfelseif arguments.report_type eq 10>
					AND SR.STORE=D.DEPARTMENT_ID
					AND SR.STORE=SL.DEPARTMENT_ID
					AND SR.STORE_LOCATION=SL.LOCATION_ID
				</cfif>
				<cfif listfind('2,3,4,5,6,9',arguments.report_type) and len(arguments.location_based_cost)>
					AND SR.STORE=D.DEPARTMENT_ID
					AND SR.STORE=SL.DEPARTMENT_ID
					AND SR.STORE_LOCATION=SL.LOCATION_ID
				</cfif>
				<cfif len(trim(arguments.sup_company)) and len(arguments.sup_company_id)>
					AND S.COMPANY_ID = #arguments.sup_company_id#
				</cfif>
				<cfif len(trim(arguments.employee_name)) and len(arguments.product_employee_id)>
					AND S.PRODUCT_MANAGER = #arguments.product_employee_id#
				</cfif>
				<cfif len(trim(arguments.product_name)) and len(arguments.product_id)>
					AND S.PRODUCT_ID = #arguments.product_id#
				</cfif>
				<cfif len(trim(arguments.brand_name)) and len(arguments.brand_id)>
					AND S.BRAND_ID = #arguments.brand_id# 
				</cfif>	
				<cfif len(trim(arguments.product_cat)) and len(arguments.product_code)>
					AND S.STOCK_CODE LIKE '#arguments.product_code#%'
				</cfif>
				<cfif listfind('1,2,3,4,5,6,8,9,10',arguments.report_type,',') and ((len(arguments.control_total_stock)) or len(arguments.is_stock_action))><!--- sadece pozitif stoklar veya sadece hareket gormus stokların gelmesi --->
					AND <cfif arguments.report_type eq 8>(CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)))<cfelse>S.STOCK_ID</cfif>
					<cfif len(arguments.control_total_stock) and arguments.control_total_stock eq 0 and not len(arguments.is_stock_action)>
						NOT IN
					<cfelse>
						IN
					</cfif>
						(
						SELECT   
							<cfif arguments.report_type eq 8>
							(CAST(SR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50))) <!--- spec bazında stok durumu kontrol ediliyor --->
							<cfelse>
							SR.STOCK_ID
							</cfif>
						FROM        
							STOCKS_ROW SR WITH (NOLOCK),
							#dsn_alias#.STOCKS_LOCATION SL
						WHERE
							SR.STORE = SL.DEPARTMENT_ID
							AND SR.STORE_LOCATION=SL.LOCATION_ID
							<cfif len(arguments.is_stock_action)>
							AND SR.UPD_ID IS NOT NULL
							</cfif>
							<cfif isdefined("is_belognto_institution") and not len(is_belognto_institution)>
							AND SL.BELONGTO_INSTITUTION = 0
							</cfif>
							AND SR.PROCESS_DATE <= #arguments.date2#	
							 <cfif arguments.report_type neq 9>
								<cfif len(arguments.department_id)>
									AND
										(
										<cfloop list="#arguments.department_id#" delimiters="," index="dept_i">
										(SR.STORE = #listfirst(dept_i,'-')# AND SR.STORE_LOCATION = #listlast(dept_i,'-')#)
										<cfif dept_i neq listlast(arguments.department_id,',') and listlen(arguments.department_id,',') gte 1> OR</cfif>
										</cfloop>  
										)
								<cfelseif is_store>
									AND	SR.STORE IN (#branch_dep_list#)
								</cfif>
							<cfelse>
								<cfif len(arguments.department_id_new)>
									AND SR.STORE IN (#arguments.department_id_new#)
								<cfelseif is_store>
									AND	SR.STORE IN (#branch_dep_list#)
								</cfif>	
							</cfif>
							<cfif len(arguments.control_total_stock)>
								GROUP BY STOCK_ID
								<cfif arguments.report_type eq 8>
								,ISNULL(SR.SPECT_VAR_ID,0)
								,SR.SPECT_VAR_ID
								</cfif>
								<cfif arguments.control_total_stock eq 0> <!--- sıfır stok --->
									<cfif not len(arguments.is_stock_action)>
										HAVING round((SUM(STOCK_IN)-SUM(STOCK_OUT)),2) <> 0
									<cfelse>
										HAVING round((SUM(STOCK_IN)-SUM(STOCK_OUT)),2) = 0
									</cfif>
								<cfelseif arguments.control_total_stock eq 1> <!--- pozitif stok --->
									HAVING round((SUM(STOCK_IN)-SUM(STOCK_OUT)),2) > 0
								<cfelseif arguments.control_total_stock eq 2> <!--- negatif stok --->
									HAVING round((SUM(STOCK_IN)-SUM(STOCK_OUT)),2) < 0
								</cfif>
							</cfif>
						)
				</cfif>
			</cfoutput>	
	</cf_wrk_cfc_query>
<cfreturn #get_all_stock# />
</cffunction>
	<cffunction name="get_start_rate_func" returntype="query">
		<cfargument name="date" default="">
		<cfargument name="period_id" default="">
		<cfargument name="cost_money" default="">
		<cfargument name="dsn" default="">
			<cfquery name="START_RATE" datasource="#dsn#" maxrows="1">
				SELECT
					(RATE2/RATE1) AS RATE,MONEY 
				FROM 
					MONEY_HISTORY
				WHERE 
					VALIDATE_DATE <= #DATEADD('d',1,arguments.date)#
					AND PERIOD_ID = #arguments.period_id#
					AND MONEY = '#arguments.cost_money#'
				ORDER BY 
					VALIDATE_DATE DESC
			</cfquery>
			<cfreturn #start_rate#>
	</cffunction>
	<cffunction name="get_finish_rate_func" returntype="query">
		<cfargument name="date" default="">
		<cfargument name="perio_id" default="">
		<cfargument name="cost_money" default="">
		<cfargument name="dsn" default="">
			<cfquery name="FINISH_RATE" datasource="#dsn#">
				SELECT
					(RATE2/RATE1) AS RATE,MONEY 
				FROM 
					MONEY_HISTORY
				WHERE 
					VALIDATE_DATE <= #DATEADD('d',1,arguments.date)#
					AND PERIOD_ID = #arguments.period_id#
					AND MONEY = '#arguments.cost_money#'
				ORDER BY 
					VALIDATE_DATE DESC
			</cfquery>
			<cfreturn #FINISH_RATE#>
	</cffunction>
	<cffunction name="get_stock_fis" returntype="query">
			<cfargument name="data_source" default="">
			<cfargument name="dsn_alias" default="">		
			<cfargument name="dsn3_alias" default="">		
			<cfargument name="dsn3" default="">				
			<cfargument name="query_name" default="">	
			<cfargument name="method_name" default="">		
			<cfargument name="is_system_money_2" default="">		
			<cfargument name="cost_money" default="">		
			<cfargument name="money" default="">		
			<cfargument name="money2" default="">		
			<cfargument name="report_type" default="">		
			<cfargument name="location_based_cost" default="">		
			<cfargument name="is_store" default="">		
			<cfargument name="date" default="">		
			<cfargument name="date2" default="">		
			<cfargument name="department_id" default="">		
			<cfargument name="sup_company" default="">		
			<cfargument name="sup_company_id" default="">	
			<cfargument name="employee_name" default="">		
			<cfargument name="product_employee_id" default="">		
			<cfargument name="product_name" default="">		
			<cfargument name="product_id" default="">		
			<cfargument name="brand_name" default="">		
			<cfargument name="brand_id" default="">		
			<cfargument name="product_cat" default="">		
			<cfargument name="product_code" default="">		
			<cfargument name="general_cached_time" default="">
			<cfargument name="stock_table" default="">
			<cfquery name="GET_STOCK_FIS" datasource="#data_source#" cachedwithin="#general_cached_time#">
					SELECT
						GC.PRODUCT_ID,
						GC.STOCK_ID,
						<cfif stock_table>
                            S.PRODUCT_CATID,
                            S.BRAND_ID,
						</cfif>
						SFR.AMOUNT,
						SF.DEPARTMENT_IN,
						SF.DEPARTMENT_OUT,
						SF.LOCATION_IN,
						SF.LOCATION_OUT,
						GC.STOCK_IN,
						GC.STOCK_OUT,
						((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
						(GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
						<cfif len(arguments.is_system_money_2) or arguments.cost_money is not money>
							<cfif len(arguments.is_system_money_2)> <!--- sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir --->
							GC.MALIYET MALIYET,
							GC.MALIYET_2 MALIYET_2,
							(SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,<!--- uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
							(SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
							(SFR.AMOUNT*ISNULL(COST_PRICE,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_COST_PRICE_2,
							(SFR.AMOUNT*ISNULL(EXTRA_COST,0))/(SF_M.RATE2/SF_M.RATE1) AS TOTAL_EXTRA_COST_2,
							<cfelse>
							(GC.MALIYET/(SF_M.RATE2/SF_M.RATE1)) MALIYET,
							(SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
							(SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
							</cfif>
						<cfelse>
							(GC.MALIYET) MALIYET,
							(SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE,
							(SFR.AMOUNT*ISNULL(EXTRA_COST,0)) AS TOTAL_EXTRA_COST,
						</cfif>
						<cfif arguments.report_type eq 8>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
						SF.FIS_DATE ISLEM_TARIHI,
						SF.PROCESS_CAT,
						SF.FIS_TYPE PROCESS_TYPE,
						ISNULL(SF.PROD_ORDER_NUMBER,0) AS PROD_ORDER_NUMBER,
						ISNULL(SF.PROD_ORDER_RESULT_NUMBER,0) AS PROD_ORDER_RESULT_NUMBER
					FROM 
						STOCK_FIS SF WITH (NOLOCK),
						STOCK_FIS_ROW SFR WITH (NOLOCK),
						<cfif len(arguments.is_system_money_2) or arguments.cost_money is not money>
						STOCK_FIS_MONEY SF_M,
						</cfif>
						<cfif (len(is_store) and is_store eq 1)  or (len(arguments.location_based_cost) and arguments.location_based_cost eq 1)>
							<cfif arguments.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC
							<cfelse>
								GET_STOCKS_ROW_COST_LOCATION AS GC
							</cfif>
						<cfelse>
							<cfif arguments.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT AS GC
							<cfelse>
								GET_STOCKS_ROW_COST AS GC
							</cfif>
						</cfif>
						<cfif stock_table>
						,#dsn3_alias#.STOCKS S WITH (NOLOCK)
						</cfif>
					WHERE 
						GC.UPD_ID = SF.FIS_ID AND
						SFR.FIS_ID=	SF.FIS_ID AND
						GC.PROCESS_TYPE = SF.FIS_TYPE AND
						<cfif stock_table>
						S.STOCK_ID = GC.STOCK_ID AND
						</cfif>
						GC.STOCK_ID=SFR.STOCK_ID AND
						SF.FIS_TYPE  IN (110,111,112,113,115,119) AND 
						SF.FIS_DATE >= #arguments.date# AND 
						SF.FIS_DATE <= #arguments.date2#
						<cfif len(arguments.is_system_money_2) or arguments.cost_money is not money>
							 AND SF.FIS_ID = SF_M.ACTION_ID
							<cfif len(arguments.is_system_money_2)>
							 AND SF_M.MONEY_TYPE = '#arguments.money2#'
							<cfelse>
							 AND SF_M.MONEY_TYPE = '#arguments.cost_money#'
							</cfif>
						</cfif>
						<cfif len(arguments.department_id)>
						AND(
							(
								SF.DEPARTMENT_OUT IS NOT NULL AND
								<cfloop list="#arguments.department_id#" delimiters="," index="dept_i">
								(SF.DEPARTMENT_OUT = #listfirst(dept_i,'-')# AND SF.LOCATION_OUT = #listlast(dept_i,'-')#)
								<cfif dept_i neq listlast(arguments.department_id,',') and listlen(arguments.department_id,',') gte 1> OR</cfif>
								</cfloop>  
							)
						OR 
							(
								SF.DEPARTMENT_IN IS NOT NULL AND
								<cfloop list="#arguments.department_id#" delimiters="," index="dept_i">
								(SF.DEPARTMENT_IN  = #listfirst(dept_i,'-')# AND SF.LOCATION_IN = #listlast(dept_i,'-')#)
								<cfif dept_i neq listlast(arguments.department_id,',') and listlen(arguments.department_id,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
						<cfelseif is_store>
							AND (
									SF.DEPARTMENT_OUT IN (#branch_dep_list#) OR SF.DEPARTMENT_IN IN (#branch_dep_list#)
								 )
						</cfif>
						<cfif len(trim(arguments.sup_company)) and len(arguments.sup_company_id)>
							AND S.COMPANY_ID = #arguments.sup_company_id#
						</cfif>
						<cfif len(trim(arguments.employee_name)) and len(arguments.product_employee_id)>
							AND S.PRODUCT_MANAGER = #arguments.product_employee_id#
						</cfif>
						<cfif len(trim(arguments.product_name)) and len(arguments.product_id)>
							AND S.PRODUCT_ID = #arguments.product_id#
						</cfif>
						<cfif len(trim(arguments.brand_name)) and len(arguments.brand_id)>
							AND S.BRAND_ID = #arguments.brand_id# 
						</cfif>	
						<cfif len(trim(arguments.product_cat)) and len(arguments.product_code)>
							AND S.STOCK_CODE LIKE '#arguments.product_code#%'
						</cfif>
				</cfquery>
			<cfreturn #GET_STOCK_FIS#>		
	</cffunction>
	<cffunction name="get_expense" returntype="query">
		<cfargument name="data_source" default="">
			<cfargument name="dsn_alias" default="">		
			<cfargument name="dsn3_alias" default="">		
			<cfargument name="dsn3" default="">						
			<cfargument name="is_system_money_2" default="">		
			<cfargument name="cost_money" default="">			
			<cfargument name="report_type" default="">				
			<cfargument name="is_store" default="">		
			<cfargument name="date" default="">		
			<cfargument name="date2" default="">		
			<cfargument name="department_id" default="">		
			<cfargument name="sup_company" default="">		
			<cfargument name="sup_company_id" default="">	
			<cfargument name="employee_name" default="">		
			<cfargument name="product_employee_id" default="">		
			<cfargument name="product_name" default="">		
			<cfargument name="product_id" default="">		
			<cfargument name="brand_name" default="">		
			<cfargument name="brand_id" default="">		
			<cfargument name="product_cat" default="">		
			<cfargument name="product_code" default="">		
			<cfargument name="general_cached_time" default="">
			<cfargument name="money2" default="">		
		<cfquery name="GET_EXPENSE" datasource="#data_source#" cachedwithin="#general_cached_time#">
					SELECT
						GC.PRODUCT_ID,
						GC.STOCK_ID,
						<cfif stock_table>
						S.PRODUCT_CATID,
						S.BRAND_ID,
						</cfif>
						EIR.QUANTITY AS AMOUNT,
						<cfif len(arguments.is_system_money_2)> <!--- sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir --->
						GC.MALIYET MALIYET,
						GC.MALIYET_2 MALIYET_2,
						<cfelse>
						(GC.MALIYET/(EIRM.RATE2/EIRM.RATE1)) MALIYET,
						</cfif>
						<cfif arguments.report_type eq 8>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
						EIP.EXPENSE_DATE ISLEM_TARIHI,
						EIP.ACTION_TYPE PROCESS_TYPE
					FROM 
						EXPENSE_ITEM_PLANS EIP,
						EXPENSE_ITEMS_ROWS EIR,
						EXPENSE_ITEM_PLANS_MONEY EIRM,
						<cfif is_store>
							<cfif arguments.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC
							<cfelse>
								GET_STOCKS_ROW_COST_LOCATION AS GC
							</cfif>
						<cfelse>
							<cfif arguments.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT AS GC
							<cfelse>
								GET_STOCKS_ROW_COST AS GC
							</cfif>
						</cfif>
						<cfif stock_table>
						,#dsn3_alias#.STOCKS S
						</cfif>
					WHERE 
						GC.UPD_ID = EIP.EXPENSE_ID AND
						EIR.EXPENSE_ID=	EIP.EXPENSE_ID AND
						EIP.EXPENSE_ID = EIRM.ACTION_ID AND
						GC.PROCESS_TYPE = EIP.ACTION_TYPE AND
						<cfif stock_table>
						S.STOCK_ID = GC.STOCK_ID AND
						</cfif>
						GC.STOCK_ID=EIR.STOCK_ID_2 AND 
						EIP.ACTION_TYPE=122 AND
						EIP.EXPENSE_DATE >= #arguments.date# AND 
						EIP.EXPENSE_DATE <= #arguments.date2# AND
						<cfif len(arguments.is_system_money_2)>
							EIRM.MONEY_TYPE = '#arguments.money2#'
						<cfelse>
							EIRM.MONEY_TYPE = '#arguments.cost_money#'
						</cfif>
						<cfif len(arguments.department_id)>
						AND(
							(
								EIP.DEPARTMENT_ID IS NOT NULL AND
								<cfloop list="#arguments.department_id#" delimiters="," index="dept_i">
								(EIP.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND EIP.LOCATION_ID = #listlast(dept_i,'-')#)
								<cfif dept_i neq listlast(arguments.department_id,',') and listlen(arguments.department_id,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
						</cfif>
						<cfif len(trim(arguments.sup_company)) and len(arguments.sup_company_id)>
							AND S.COMPANY_ID = #arguments.sup_company_id#
						</cfif>
						<cfif len(trim(arguments.employee_name)) and len(arguments.product_employee_id)>
							AND S.PRODUCT_MANAGER = #arguments.product_employee_id#
						</cfif>
						<cfif len(trim(arguments.product_name)) and len(arguments.product_id)>
							AND S.PRODUCT_ID = #arguments.product_id#
						</cfif>
						<cfif len(trim(arguments.brand_name)) and len(arguments.brand_id)>
							AND S.BRAND_ID = #arguments.brand_id# 
						</cfif>	
						<cfif len(trim(arguments.product_cat)) and len(arguments.product_code)>
							AND S.STOCK_CODE LIKE '#arguments.product_code#%'
						</cfif>
				</cfquery>
				<cfreturn #GET_EXPENSE#>
	</cffunction>

	<cffunction name="GET_DEMONTAJ" returntype="query">
		<cfargument name="data_source" default="">
			<cfargument name="dsn_alias" default="">		
			<cfargument name="dsn3_alias" default="">		
			<cfargument name="dsn3" default="">						
			<cfargument name="is_system_money_2" default="">		
			<cfargument name="cost_money" default="">			
			<cfargument name="report_type" default="">				
			<cfargument name="is_store" default="">		
			<cfargument name="date" default="">		
			<cfargument name="date2" default="">		
			<cfargument name="department_id" default="">		
			<cfargument name="sup_company" default="">		
			<cfargument name="sup_company_id" default="">	
			<cfargument name="employee_name" default="">		
			<cfargument name="product_employee_id" default="">		
			<cfargument name="product_name" default="">		
			<cfargument name="product_id" default="">		
			<cfargument name="brand_name" default="">		
			<cfargument name="brand_id" default="">		
			<cfargument name="product_cat" default="">		
			<cfargument name="product_code" default="">		
			<cfargument name="general_cached_time" default="">
		<cfquery name="GET_DEMONTAJ" datasource="#data_source#" cachedwithin="#general_cached_time#">
					SELECT
						GC.PRODUCT_ID,
						GC.STOCK_ID,
						<cfif stock_table>
						S.PRODUCT_CATID,
						S.BRAND_ID,
						</cfif>
						GC.STOCK_IN,
						GC.STOCK_OUT,
						<cfif len(arguments.is_system_money_2) or arguments.cost_money is not money>
							<cfif len(arguments.is_system_money_2)>
							GC.MALIYET MALIYET,
							GC.MALIYET_2 MALIYET_2,
							<cfelse>
							(GC.MALIYET/(SF_M.RATE2/SF_M.RATE1)) MALIYET,
							</cfif>
						<cfelse>
							(GC.MALIYET) MALIYET,
						</cfif>
						<cfif arguments.report_type eq 8>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
						SF.FIS_DATE ISLEM_TARIHI,
						SF.FIS_TYPE PROCESS_TYPE
					FROM 
						STOCK_FIS SF,
						<cfif len(arguments.is_system_money_2) or arguments.cost_money is not money>
						STOCK_FIS_MONEY SF_M,
						</cfif>
						 <cfif is_store>
							<cfif arguments.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
							<cfelse>
								GET_STOCKS_ROW_COST_LOCATION AS GC,
							</cfif>
						<cfelse>
							<cfif arguments.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT AS GC,
							<cfelse>
								GET_STOCKS_ROW_COST AS GC,
							</cfif>
						</cfif>
						#dsn3_alias#.PRODUCTION_ORDERS PO
						<cfif stock_table>
						,#dsn3_alias#.STOCKS S
						</cfif>
					WHERE 
						GC.UPD_ID = SF.FIS_ID AND
						GC.PROCESS_TYPE = SF.FIS_TYPE AND
						SF.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND
						SF.PROD_ORDER_NUMBER IS NOT NULL AND
						PO.IS_DEMONTAJ = 1 AND 
						<cfif stock_table>
						S.STOCK_ID = GC.STOCK_ID AND
						</cfif>
						SF.FIS_TYPE =111 AND 
						SF.FIS_DATE >= #arguments.date# AND 
						SF.FIS_DATE <= #arguments.date2#
						<cfif len(arguments.is_system_money_2) or arguments.cost_money is not money>
							 AND SF.FIS_ID = SF_M.ACTION_ID
							<cfif len(arguments.is_system_money_2)>
							 AND SF_M.MONEY_TYPE = '#arguments.money2#'
							<cfelse>
							AND SF_M.MONEY_TYPE = '#arguments.cost_money#'
							</cfif>
						</cfif>
						<cfif len(arguments.department_id)>
							AND(
								(
									SF.DEPARTMENT_OUT IS NOT NULL AND
									<cfloop list="#arguments.department_id#" delimiters="," index="dept_i">
									(SF.DEPARTMENT_OUT = #listfirst(dept_i,'-')# AND SF.LOCATION_OUT = #listlast(dept_i,'-')#)
									<cfif dept_i neq listlast(arguments.department_id,',') and listlen(arguments.department_id,',') gte 1> OR</cfif>
									</cfloop>  
								)
							OR 
								(
									SF.DEPARTMENT_IN IS NOT NULL AND
									<cfloop list="#arguments.department_id#" delimiters="," index="dept_i">
									(SF.DEPARTMENT_IN  = #listfirst(dept_i,'-')# AND SF.LOCATION_IN = #listlast(dept_i,'-')#)
									<cfif dept_i neq listlast(arguments.department_id,',') and listlen(arguments.department_id,',') gte 1> OR</cfif>
									</cfloop>  
								)
							)
						<cfelseif is_store>
							AND (
									SF.DEPARTMENT_OUT IN (#branch_dep_list#) OR SF.DEPARTMENT_IN IN (#branch_dep_list#)
								 )
						</cfif>
						<cfif len(trim(arguments.sup_company)) and len(arguments.sup_company_id)>
							AND S.COMPANY_ID = #arguments.sup_company_id#
						</cfif>
						<cfif len(trim(arguments.employee_name)) and len(arguments.product_employee_id)>
							AND S.PRODUCT_MANAGER = #arguments.product_employee_id#
						</cfif>
						<cfif len(trim(arguments.product_name)) and len(arguments.product_id)>
							AND S.PRODUCT_ID = #arguments.product_id#
						</cfif>
						<cfif len(trim(arguments.brand_name)) and len(arguments.brand_id)>
							AND S.BRAND_ID = #arguments.brand_id# 
						</cfif>	
						<cfif len(trim(arguments.product_cat)) and len(arguments.product_code)>
							AND S.STOCK_CODE LIKE '#arguments.product_code#%'
						</cfif>
				</cfquery>
				<cfreturn #GET_DEMONTAJ#>
	</cffunction>
	<cffunction name="GET_INV_PURCHASE" returntype="query">
		<cfargument name="data_source" default="">
		<cfargument name="dsn_alias" default="">		
		<cfargument name="dsn3_alias" default="">		
		<cfargument name="dsn3" default="">						
		<cfargument name="is_system_money_2" default="">		
		<cfargument name="cost_money" default="">			
		<cfargument name="report_type" default="">				
		<cfargument name="is_store" default="">		
		<cfargument name="date" default="">		
		<cfargument name="date2" default="">		
		<cfargument name="department_id" default="">		
		<cfargument name="sup_company" default="">		
		<cfargument name="sup_company_id" default="">	
		<cfargument name="employee_name" default="">		
		<cfargument name="product_employee_id" default="">		
		<cfargument name="product_name" default="">		
		<cfargument name="product_id" default="">		
		<cfargument name="brand_name" default="">		
		<cfargument name="brand_id" default="">		
		<cfargument name="product_cat" default="">		
		<cfargument name="product_code" default="">		
		<cfargument name="general_cached_time" default="">
		<cfargument name="x_show_sale_inoice_cost" default="">
		<cfargument name="money" default="">		
		<cfargument name="money2" default="">
		<cfquery name="GET_INV_PURCHASE" datasource="#data_source#" cachedwithin="#general_cached_time#">
				SELECT 
						IR.STOCK_ID,
						IR.PRODUCT_ID,
						<cfif arguments.report_type eq 8>
						CAST(IR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS NVARCHAR(50))  STOCK_SPEC_ID,
						</cfif>
						<cfif stock_table>
						S.PRODUCT_MANAGER,
						S.PRODUCT_CATID,
						S.BRAND_ID,
						</cfif>
						IR.AMOUNT,
						I.INVOICE_DATE ISLEM_TARIHI,
						I.INVOICE_CAT PROCESS_TYPE,
						ISNULL(I.IS_RETURN,0) IS_RETURN,
						<cfif len(arguments.from_invoice_actions) and len(x_show_sale_inoice_cost) and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
							<cfif len(arguments.is_system_money_2)>
								(IR.COST_PRICE* IR.AMOUNT) INV_COST,
								(IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
								((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST_2,
								((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST_2,
							<cfelseif arguments.cost_money is not money>
								((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST,
								((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST,
							<cfelse>
								(IR.COST_PRICE* IR.AMOUNT) INV_COST,
								(IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
							</cfif>
						</cfif>
						<cfif len(arguments.is_system_money_2) or arguments.cost_money is not money>
							<cfif len(arguments.is_system_money_2)>
							(IR.EXTRA_COST * IR.AMOUNT) EXTRA_COST,
							CASE WHEN I.SA_DISCOUNT=0 THEN IR.NETTOTAL ELSE ( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) END AS BIRIM_COST,
							((IR.EXTRA_COST * IR.AMOUNT)/(IM.RATE2/IM.RATE1))EXTRA_COST_2,
							CASE WHEN I.SA_DISCOUNT=0 THEN (IR.NETTOTAL/(IM.RATE2/IM.RATE1)) ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(IM.RATE2/IM.RATE1)) END AS BIRIM_COST_2
							<cfelse>
							((IR.EXTRA_COST * IR.AMOUNT)/(IM.RATE2/IM.RATE1))EXTRA_COST,
							CASE WHEN I.SA_DISCOUNT=0 THEN (IR.NETTOTAL/(IM.RATE2/IM.RATE1)) ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(IM.RATE2/IM.RATE1)) END AS BIRIM_COST
							</cfif>
						<cfelse>
							(IR.EXTRA_COST * IR.AMOUNT) EXTRA_COST,
							CASE WHEN I.SA_DISCOUNT=0 THEN IR.NETTOTAL ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) END AS BIRIM_COST
						</cfif>
					FROM 
						INVOICE I WITH (NOLOCK),
						INVOICE_ROW IR WITH (NOLOCK)
						<cfif len(arguments.is_system_money_2) or arguments.cost_money is not money>
						,INVOICE_MONEY IM
						</cfif>
						<cfif stock_table>
						,#dsn3_alias#.STOCKS S
						</cfif>
					WHERE 
						I.INVOICE_ID = IR.INVOICE_ID AND
						<cfif not len(arguments.from_invoice_actions)>
						I.INVOICE_CAT IN (51,54,55,59,60,61,62,63,64,65,68,690,691,591,592) AND
						</cfif>
						I.IS_IPTAL = 0 AND
						I.NETTOTAL > 0 AND
						I.INVOICE_DATE >= #arguments.date# AND 
						I.INVOICE_DATE <= #arguments.date2#
						<cfif len(arguments.is_system_money_2) or arguments.cost_money is not money>
							 AND I.INVOICE_ID = IM.ACTION_ID
							<cfif len(arguments.is_system_money_2)>
							 AND IM.MONEY_TYPE = '#arguments.money2#'
							<cfelse>
							 AND IM.MONEY_TYPE = '#arguments.cost_money#'
							</cfif>
						</cfif>
						<cfif stock_table>
						AND IR.STOCK_ID=S.STOCK_ID
						</cfif>
						<cfif len(arguments.department_id)>
							AND
							(
							<cfloop list="#arguments.department_id#" delimiters="," index="dept_i">
							(I.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND I.DEPARTMENT_LOCATION = #listlast(dept_i,'-')#)
							<cfif dept_i neq listlast(arguments.department_id,',') and listlen(arguments.department_id,',') gte 1> OR</cfif>
							</cfloop>  
							)
						 <cfelseif is_store>
							AND I.DEPARTMENT_ID IN (#branch_dep_list#)
						</cfif>
						<cfif len(trim(arguments.sup_company)) and len(arguments.sup_company_id)>
							AND S.COMPANY_ID = #arguments.sup_company_id#
						</cfif>
						<cfif len(trim(arguments.employee_name)) and len(arguments.product_employee_id)>
							AND S.PRODUCT_MANAGER = #arguments.product_employee_id#
						</cfif>
						<cfif len(trim(arguments.product_name)) and len(arguments.product_id)>
							AND S.PRODUCT_ID = #arguments.product_id#
						</cfif>
						<cfif len(trim(arguments.brand_name)) and len(arguments.brand_id)>
							AND S.BRAND_ID = #arguments.brand_id# 
						</cfif>	
						<cfif len(trim(arguments.product_cat)) and len(arguments.product_code)>
							AND S.STOCK_CODE LIKE '#arguments.product_code#%'
						</cfif>
				</cfquery>
		<cfreturn #GET_INV_PURCHASE#>
	</cffunction>
	<cffunction name="GET_SHIP_ROWS" returntype="query">
			<cfargument name="stock_table" default="">
			<cfargument name="data_source" default="">
			<cfargument name="dsn_alias" default="">		
			<cfargument name="dsn3_alias" default="">		
			<cfargument name="dsn3" default="">						
			<cfargument name="is_system_money_2" default="">		
			<cfargument name="cost_money" default="">			
			<cfargument name="report_type" default="">				
			<cfargument name="is_store" default="">		
			<cfargument name="date" default="">
			<cfargument name="finish_date" default="">		
			<cfargument name="date2" default="">		
			<cfargument name="department_id" default="">		
			<cfargument name="sup_company" default="">		
			<cfargument name="sup_company_id" default="">	
			<cfargument name="employee_name" default="">		
			<cfargument name="product_employee_id" default="">		
			<cfargument name="product_name" default="">		
			<cfargument name="product_id" default="">		
			<cfargument name="brand_name" default="">		
			<cfargument name="brand_id" default="">		
			<cfargument name="product_cat" default="">		
			<cfargument name="product_code" default="">		
			<cfargument name="general_cached_time" default="">
			<cfargument name="x_show_sale_inoice_cost" default="">
			<cfargument name="money" default="">		
			<cfargument name="money2" default="">
			<cfargument name="location_based_cost" default="">
			<cfargument  name="display_cost_money" default="">
			<cfargument name="is_stock_based_cost" default="">
			<cfargument name="process_type" default="">
			<cfargument name="is_belognto_institution" default="">
			<cfargument name="period_id" default="">
			
			<cfquery name="GET_SHIP_ROWS" datasource="#data_source#" cachedwithin="#general_cached_time#">
					SELECT
						GC.STOCK_ID,
						GC.PRODUCT_ID,
						<cfif arguments.report_type eq 8>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
						1 AS INVOICE_CAT,
						0 AS IS_RETURN,
						<cfif stock_table>
						S.PRODUCT_MANAGER,
						S.PRODUCT_CATID,
						S.BRAND_ID,
						</cfif>
						<cfif len(arguments.is_system_money_2)>
						GC.MALIYET_2,
						GC.MALIYET,
						((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
						(GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
						<cfelse>
							<cfif arguments.cost_money is not money>
							(GC.MALIYET/(SM.RATE2/SM.RATE1)) AS MALIYET,
							((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(SM.RATE2/SM.RATE1)) AS TOTAL_COST,
							<cfelse>
							GC.MALIYET,
							(GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,				
							</cfif>
						</cfif>
						ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
						GC.STOCK_IN,
						GC.STOCK_OUT,
						GC.PROCESS_DATE ISLEM_TARIHI,
						GC.PROCESS_TYPE PROCESS_TYPE,
						ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
							SELECT TOP 1 
								<cfif len(arguments.location_based_cost)>
									<cfif isdefined("arguments.display_cost_money") and len(arguments.display_cost_money)>
										(PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
									<cfelse>
										(PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
									</cfif>
								<cfelse>
									<cfif isdefined("arguments.display_cost_money") and len(arguments.display_cost_money)>
										(PURCHASE_NET+PURCHASE_EXTRA_COST)
									<cfelse>
										(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
									</cfif>	
								</cfif>
							FROM 
								#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
							WHERE 
								START_DATE <= #finish_date# 
								AND PRODUCT_ID = GC.PRODUCT_ID
								<cfif arguments.report_type eq 8>
									 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
								</cfif>
								<cfif is_stock_based_cost eq 1 and arguments.report_type neq 2>
									AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
								</cfif>
								<cfif len(arguments.location_based_cost)>
									<cfif len(arguments.department_id)>
										AND DEPARTMENT_ID = #listgetat(arguments.department_id,1,'-')#
										AND LOCATION_ID = #listgetat(arguments.department_id,2,'-')#
									<cfelse>
										AND DEPARTMENT_ID = SL.DEPARTMENT_ID
										AND LOCATION_ID = SL.LOCATION_ID
									</cfif>
								</cfif>
							ORDER BY 
								START_DATE DESC, 
								RECORD_DATE DESC,
								PRODUCT_COST_ID DESC
						),0) ALL_FINISH_COST,
						ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
							SELECT TOP 1 
								<cfif len(arguments.location_based_cost)>
									(PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
								<cfelse>
									(PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
								</cfif>
							FROM 
								#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
							WHERE 
								START_DATE <= #finish_date# 
								AND PRODUCT_ID = GC.PRODUCT_ID
								<cfif arguments.report_type eq 8>
									 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
								</cfif>
								<cfif is_stock_based_cost eq 1 and arguments.report_type neq 2>
									AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
								</cfif>
								<cfif len(arguments.location_based_cost)>
									<cfif len(arguments.department_id)>
										AND DEPARTMENT_ID = #listgetat(arguments.department_id,1,'-')#
										AND LOCATION_ID = #listgetat(arguments.department_id,2,'-')#
									<cfelse>
										AND DEPARTMENT_ID = SL.DEPARTMENT_ID
										AND LOCATION_ID = SL.LOCATION_ID
									</cfif>
								</cfif>
							ORDER BY 
								START_DATE DESC, 
								RECORD_DATE DESC,
								PRODUCT_COST_ID DESC
						),0) ALL_FINISH_COST_2
					FROM
						<cfif (len(is_store) and is_store eq 1)  or (len(arguments.location_based_cost) and arguments.location_based_cost eq 1)>
							<cfif arguments.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
							<cfelse>
								GET_STOCKS_ROW_COST_LOCATION AS GC,
							</cfif>
						<cfelse>
							<cfif arguments.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT AS GC,
							<cfelse>
								GET_STOCKS_ROW_COST AS GC,
							</cfif>
						</cfif>
						<cfif arguments.cost_money is not money or len(arguments.is_system_money_2) or listfind(arguments.process_type,3)>
						SHIP WITH (NOLOCK),	
						</cfif>
						<cfif arguments.cost_money is not money or len(arguments.is_system_money_2)>
						SHIP_MONEY SM,
						</cfif>
						<cfif stock_table>
						#dsn3_alias#.STOCKS S,
						</cfif>
						#dsn_alias#.STOCKS_LOCATION SL
					WHERE
						GC.STORE = SL.DEPARTMENT_ID
						AND GC.STORE_LOCATION=SL.LOCATION_ID
						<cfif isdefined("is_belognto_institution") and not len(is_belognto_institution)>
						AND SL.BELONGTO_INSTITUTION = 0
						</cfif>
						<cfif arguments.cost_money is not money or len(arguments.is_system_money_2) or listfind(arguments.process_type,3)>
						AND GC.UPD_ID = SHIP.SHIP_ID
						AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
						AND ISNULL(SHIP.IS_WITH_SHIP,0)=0
						</cfif>
						<cfif arguments.cost_money is not money or len(arguments.is_system_money_2)>
						AND SHIP.SHIP_ID = SM.ACTION_ID
							<cfif len(arguments.is_system_money_2)>
								AND SM.MONEY_TYPE = '#arguments.money2#'
							<cfelse>
								AND SM.MONEY_TYPE = '#arguments.cost_money#'
							</cfif>
						</cfif>
						AND GC.PROCESS_DATE >= #arguments.date#
						AND GC.PROCESS_DATE <= #arguments.date2#
						<cfif len(arguments.department_id)>
						AND
							(
							<cfloop list="#arguments.department_id#" delimiters="," index="dept_i">
							(GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
							<cfif dept_i neq listlast(arguments.department_id,',') and listlen(arguments.department_id,',') gte 1> OR</cfif>
							</cfloop>  
							)
						<cfelseif is_store>
							AND GC.STORE IN (#branch_dep_list#)
						</cfif>
						<cfif stock_table>
						AND	GC.STOCK_ID=S.STOCK_ID
						</cfif>
						<cfif len(trim(arguments.sup_company)) and len(arguments.sup_company_id)>
						AND S.COMPANY_ID = #arguments.sup_company_id#
						</cfif>
						<cfif len(trim(arguments.employee_name)) and len(arguments.product_employee_id)>
						AND S.PRODUCT_MANAGER = #arguments.product_employee_id#
						</cfif>
						<cfif len(trim(arguments.product_name)) and len(arguments.product_id)>
						AND S.PRODUCT_ID = #arguments.product_id#
						</cfif>
						<cfif len(trim(arguments.brand_name)) and len(arguments.brand_id)>
						AND S.BRAND_ID = #arguments.brand_id# 
						</cfif>	
						<cfif len(trim(arguments.product_cat)) and len(arguments.product_code)>
						AND S.STOCK_CODE LIKE '#arguments.product_code#%'
						</cfif>
				<cfif arguments.cost_money is not money or listfind(arguments.process_type,3)>
				UNION ALL
					SELECT
						GC.STOCK_ID,
						GC.PRODUCT_ID,
						<cfif arguments.report_type eq 8>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
						INVOICE.INVOICE_CAT,
						ISNULL(INVOICE.IS_RETURN,0) IS_RETURN,
						<cfif stock_table>
						S.PRODUCT_MANAGER,
						S.PRODUCT_CATID,
						S.BRAND_ID,
						</cfif>
						<cfif len(arguments.is_system_money_2) or arguments.cost_money is not money>
							<cfif len(arguments.is_system_money_2)>
							GC.MALIYET_2,
							GC.MALIYET,
							((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
							(GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
							<cfelse>
								(GC.MALIYET/(IM.RATE2/IM.RATE1)) AS MALIYET,
								((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(IM.RATE2/IM.RATE1)) AS TOTAL_COST,
							</cfif>
						<cfelse>
							(GC.MALIYET) AS MALIYET,
							((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST,
						</cfif>
						ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
						GC.STOCK_IN,
						GC.STOCK_OUT,
						GC.PROCESS_DATE ISLEM_TARIHI,
						GC.PROCESS_TYPE PROCESS_TYPE,
						ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
							SELECT TOP 1 
								<cfif len(arguments.location_based_cost)>
									<cfif isdefined("arguments.display_cost_money") and len(arguments.display_cost_money)>
										(PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
									<cfelse>
										(PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
									</cfif>
								<cfelse>
									<cfif isdefined("arguments.display_cost_money") and len(arguments.display_cost_money)>
										(PURCHASE_NET+PURCHASE_EXTRA_COST)
									<cfelse>
										(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
									</cfif>	
								</cfif>
							FROM 
								#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
							WHERE 
								START_DATE <= #finish_date# 
								AND PRODUCT_ID = GC.PRODUCT_ID
								<cfif arguments.report_type eq 8>
									 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
								</cfif>
								<cfif is_stock_based_cost eq 1 and arguments.report_type neq 2>
									AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
								</cfif>
								<cfif len(arguments.location_based_cost)>
									<cfif len(arguments.department_id)>
										AND DEPARTMENT_ID = #listgetat(arguments.department_id,1,'-')#
										AND LOCATION_ID = #listgetat(arguments.department_id,2,'-')#
									<cfelse>
										AND DEPARTMENT_ID = SL.DEPARTMENT_ID
										AND LOCATION_ID = SL.LOCATION_ID
									</cfif>
								</cfif>
							ORDER BY 
								START_DATE DESC, 
								RECORD_DATE DESC,
								PRODUCT_COST_ID DESC
						),0) ALL_FINISH_COST,
						ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
							SELECT TOP 1 
								<cfif len(arguments.location_based_cost)>
									(PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
								<cfelse>
									(PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
								</cfif>
							FROM 
								#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
							WHERE 
								START_DATE <= #finish_date# 
								AND PRODUCT_ID = GC.PRODUCT_ID
								<cfif arguments.report_type eq 8>
									 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
								</cfif>
								<cfif is_stock_based_cost eq 1 and arguments.report_type neq 2>
									AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
								</cfif>
								<cfif len(arguments.location_based_cost)>
									<cfif len(arguments.department_id)>
										AND DEPARTMENT_ID = #listgetat(arguments.department_id,1,'-')#
										AND LOCATION_ID = #listgetat(arguments.department_id,2,'-')#
									<cfelse>
										AND DEPARTMENT_ID = SL.DEPARTMENT_ID
										AND LOCATION_ID = SL.LOCATION_ID
									</cfif>
								</cfif>
							ORDER BY 
								START_DATE DESC, 
								RECORD_DATE DESC,
								PRODUCT_COST_ID DESC
						),0) ALL_FINISH_COST_2
					FROM
						SHIP WITH (NOLOCK),
						INVOICE WITH (NOLOCK),
						INVOICE_SHIPS INV_S,
						<cfif len(arguments.is_system_money_2) or arguments.cost_money is not money>
						INVOICE_MONEY IM,
						</cfif>
						<cfif (len(is_store) and is_store eq 1)  or (len(arguments.location_based_cost) and arguments.location_based_cost eq 1)>
							<cfif arguments.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
							<cfelse>
								GET_STOCKS_ROW_COST_LOCATION AS GC,
							</cfif>
						<cfelse>
							<cfif arguments.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT AS GC,
							<cfelse>
								GET_STOCKS_ROW_COST AS GC,
							</cfif>
						</cfif>
						<cfif stock_table>
						#dsn3_alias#.STOCKS S,
						</cfif>
						#dsn_alias#.STOCKS_LOCATION SL
					WHERE
						SHIP.SHIP_ID = INV_S.SHIP_ID
						AND INVOICE.INVOICE_ID= INV_S.INVOICE_ID
						AND INV_S.IS_WITH_SHIP = 1
						AND INV_S.SHIP_PERIOD_ID = #period_id#
						AND SHIP.IS_WITH_SHIP=1
						AND SHIP.SHIP_ID = GC.UPD_ID
						AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
						AND GC.STORE = SL.DEPARTMENT_ID
						AND GC.STORE_LOCATION=SL.LOCATION_ID
						<cfif isdefined("is_belognto_institution") and not len(is_belognto_institution)>
						AND SL.BELONGTO_INSTITUTION = 0
						</cfif>
						<cfif len(arguments.is_system_money_2) or arguments.cost_money is not money>
							AND IM.ACTION_ID=INVOICE.INVOICE_ID
							<cfif len(arguments.is_system_money_2)>
							AND IM.MONEY_TYPE = '#arguments.money2#'
							<cfelse>
							AND IM.MONEY_TYPE = '#arguments.cost_money#'
							</cfif>
						</cfif>
						AND GC.PROCESS_DATE >= #arguments.date#
						AND GC.PROCESS_DATE <= #arguments.date2#
						<cfif len(arguments.department_id)>
						AND
							(
							<cfloop list="#arguments.department_id#" delimiters="," index="dept_i">
							(GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
							<cfif dept_i neq listlast(arguments.department_id,',') and listlen(arguments.department_id,',') gte 1> OR</cfif>
							</cfloop>  
							)
						<cfelseif is_store>
							AND GC.STORE IN (#branch_dep_list#)
						</cfif>
						<cfif stock_table>
						AND	GC.STOCK_ID=S.STOCK_ID
						</cfif>
						<cfif len(trim(arguments.sup_company)) and len(arguments.sup_company_id)>
							AND S.COMPANY_ID = #arguments.sup_company_id#
						</cfif>
						<cfif len(trim(arguments.employee_name)) and len(arguments.product_employee_id)>
							AND S.PRODUCT_MANAGER = #arguments.product_employee_id#
						</cfif>
						<cfif len(trim(arguments.product_name)) and len(arguments.product_id)>
							AND S.PRODUCT_ID = #arguments.product_id#
						</cfif>
						<cfif len(trim(arguments.brand_name)) and len(arguments.brand_id)>
							AND S.BRAND_ID = #arguments.brand_id# 
						</cfif>	
						<cfif len(trim(arguments.product_cat)) and len(arguments.product_code)>
							AND S.STOCK_CODE LIKE '#arguments.product_code#%'
						</cfif>
				</cfif>
				</cfquery>
			<cfreturn #GET_SHIP_ROWS#>
	</cffunction>
	
	<cffunction name="GET_STOCK_AGE" returntype="query">
			<cfargument name="dsn_alias" default="">		
			<cfargument name="dsn3_alias" default="">		
			<cfargument name="dsn3" default="">						
			<cfargument name="is_system_money_2" default="">		
			<cfargument name="cost_money" default="">			
			<cfargument name="report_type" default="">				
			<cfargument name="is_store" default="">		
			<cfargument name="date" default="">
			<cfargument name="finish_date" default="">		
			<cfargument name="date2" default="">		
			<cfargument name="department_id" default="">		
			<cfargument name="sup_company" default="">		
			<cfargument name="sup_company_id" default="">	
			<cfargument name="employee_name" default="">		
			<cfargument name="product_employee_id" default="">		
			<cfargument name="product_name" default="">		
			<cfargument name="product_id" default="">		
			<cfargument name="brand_name" default="">		
			<cfargument name="brand_id" default="">		
			<cfargument name="product_cat" default="">		
			<cfargument name="product_code" default="">		
			<cfargument name="general_cached_time" default="">
			<cfargument name="x_show_sale_inoice_cost" default="">
			<cfargument name="money" default="">		
			<cfargument name="money2" default="">
			<cfargument name="location_based_cost" default="">
			<cfargument  name="display_cost_money" default="">
			<cfargument name="is_stock_based_cost" default="">
			<cfargument name="process_type" default="">
			<cfargument name="is_belognto_institution" default="">
			<cfargument name="period_id" default="">
			
			<cfquery name="GET_STOCK_AGE" datasource="#data_source#" cachedwithin="#general_cached_time#">
				SELECT 
					IR.STOCK_ID,
					IR.PRODUCT_ID,
					<cfif arguments.report_type eq 8>
						CAST(IR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS NVARCHAR(50))  STOCK_SPEC_ID,
					</cfif>
					IR.AMOUNT,
					ISNULL(I.DELIVER_DATE,I.SHIP_DATE) AS ISLEM_TARIHI,
					ISNULL(DATEDIFF(day,I.DELIVER_DATE,#arguments.date2#),DATEDIFF(day,I.SHIP_DATE,#arguments.date2#))  AS GUN_FARKI,
					I.DEPARTMENT_IN,
					I.LOCATION_IN,
					S.BRAND_ID,
					S.PRODUCT_CATID,
					S.PRODUCT_MANAGER
				FROM 
					SHIP I WITH (NOLOCK),
					SHIP_ROW IR WITH (NOLOCK),
					#dsn3_alias#.STOCKS S
				WHERE 
					I.SHIP_ID = IR.SHIP_ID AND
					S.STOCK_ID=IR.STOCK_ID AND	
					<cfif len(arguments.department_id)><!--- depo varsa depolar arası sevk VE ithal mal girisine bak --->
						I.SHIP_TYPE IN (76,81,811,87) AND
					<cfelse>
						I.SHIP_TYPE IN(76,87) AND
					</cfif>
					I.IS_SHIP_IPTAL = 0 AND
					<!--- I.SHIP_DATE >= #arguments.date# AND  --->
					I.SHIP_DATE <= #arguments.date2#
					<cfif len(arguments.department_id)>
					AND
						(
						<cfloop list="#arguments.department_id#" delimiters="," index="dept_i">
						(I.DEPARTMENT_IN = #listfirst(dept_i,'-')# AND I.LOCATION_IN = #listlast(dept_i,'-')#)
						<cfif dept_i neq listlast(arguments.department_id,',') and listlen(arguments.department_id,',') gte 1> OR</cfif>
						</cfloop>  
						)
					<cfelseif is_store>
						AND I.DEPARTMENT_IN IN (#branch_dep_list#)
					</cfif>
					<cfif len(trim(arguments.employee_name)) and len(arguments.product_employee_id)>
						AND S.PRODUCT_MANAGER = #arguments.product_employee_id#
					</cfif>
					<cfif len(trim(arguments.product_name)) and len(arguments.product_id)>
						AND S.PRODUCT_ID = #arguments.product_id#
					</cfif>
					<cfif len(trim(arguments.brand_name)) and len(arguments.brand_id)>
						AND S.BRAND_ID = #arguments.brand_id# 
					</cfif>	
					<cfif len(trim(arguments.product_cat)) and len(arguments.product_code)>
						AND S.STOCK_CODE LIKE '#arguments.product_code#%'
					</cfif>
			UNION ALL
				SELECT 
					IR.STOCK_ID,
					S.PRODUCT_ID,
                    <cfif arguments.report_type eq 8>
						CAST(IR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS NVARCHAR(50))  STOCK_SPEC_ID,
					</cfif>
					IR.AMOUNT,
					I.FIS_DATE ISLEM_TARIHI,
					<!--- ISNULL(DATEDIFF(day,DATEADD(day,-1*DUE_DATE,FIS_DATE),#arguments.date2#),DATEDIFF(day,FIS_DATE,#arguments.date2#)) AS GUN_FARKI, --->
					DATEDIFF(day,FIS_DATE,#attributes.date2#) + ISNULL(DUE_DATE,0) GUN_FARKI,
					I.DEPARTMENT_IN,
					I.LOCATION_IN,
					S.BRAND_ID,
					S.PRODUCT_CATID,
					S.PRODUCT_MANAGER
				FROM 
					STOCK_FIS I,
					STOCK_FIS_ROW IR,
					#dsn3_alias#.STOCKS S
				WHERE 
					I.FIS_ID = IR.FIS_ID AND
					S.STOCK_ID=IR.STOCK_ID AND
					<cfif len(arguments.department_id)><!--- depo varsa ambar fisine bak --->
					I.FIS_TYPE IN (110,113,114,115,119) AND
					<cfelse>
					I.FIS_TYPE IN (110,114,115,119) AND
					</cfif>
					<!--- I.FIS_DATE >= #arguments.date# AND  --->
					I.FIS_DATE <= #arguments.date2#
					<cfif len(arguments.department_id)>
					AND
						(
						<cfloop list="#arguments.department_id#" delimiters="," index="dept_i">
						(I.DEPARTMENT_IN = #listfirst(dept_i,'-')# AND I.LOCATION_IN = #listlast(dept_i,'-')#)
						<cfif dept_i neq listlast(arguments.department_id,',') and listlen(arguments.department_id,',') gte 1> OR</cfif>
						</cfloop>  
						)
					<cfelseif is_store>
						AND I.DEPARTMENT_IN IN (#branch_dep_list#)
					</cfif>
					<cfif len(trim(arguments.employee_name)) and len(arguments.product_employee_id)>
						AND S.PRODUCT_MANAGER = #arguments.product_employee_id#
					</cfif>
					<cfif len(trim(arguments.product_name)) and len(arguments.product_id)>
						AND S.PRODUCT_ID = #arguments.product_id#
					</cfif>
					<cfif len(trim(arguments.brand_name)) and len(arguments.brand_id)>
						AND S.BRAND_ID = #arguments.brand_id# 
					</cfif>	
					<cfif len(trim(arguments.product_cat)) and len(arguments.product_code)>
						AND S.STOCK_CODE LIKE '#arguments.product_code#%'
					</cfif>
			</cfquery>
		<cfreturn #GET_STOCK_AGE#>
	</cffunction>
	
	<cffunction name="GET_STOCK_ROWS" returntype="query">
		<cfargument name="dsn_alias" default="">		
		<cfargument name="dsn3_alias" default="">		
		<cfargument name="dsn3" default="">						
		<cfargument name="is_system_money_2" default="">		
		<cfargument name="cost_money" default="">			
		<cfargument name="report_type" default="">				
		<cfargument name="is_store" default="">		
		<cfargument name="date" default="">
		<cfargument name="finish_date" default="">		
		<cfargument name="date2" default="">		
		<cfargument name="department_id" default="">		
		<cfargument name="sup_company" default="">		
		<cfargument name="sup_company_id" default="">	
		<cfargument name="employee_name" default="">		
		<cfargument name="product_employee_id" default="">		
		<cfargument name="product_name" default="">		
		<cfargument name="product_id" default="">		
		<cfargument name="brand_name" default="">		
		<cfargument name="brand_id" default="">		
		<cfargument name="product_cat" default="">		
		<cfargument name="product_code" default="">		
		<cfargument name="general_cached_time" default="">
		<cfargument name="x_show_sale_inoice_cost" default="">
		<cfargument name="money" default="">		
		<cfargument name="money2" default="">
		<cfargument name="location_based_cost" default="">
		<cfargument  name="display_cost_money" default="">
		<cfargument name="is_stock_based_cost" default="">
		<cfargument name="process_type" default="">
		<cfargument name="is_belognto_institution" default="">
		<cfargument name="period_id" default="">
		<cfquery name="GET_STOCK_ROWS" datasource="#data_source#" cachedwithin="#general_cached_time#">
			SELECT 
				SR.UPD_ID,
				S.STOCK_ID,
				S.PRODUCT_ID,
				<cfif listfind('2,3,4,5,6,9',arguments.report_type) and len(arguments.location_based_cost)>
					SR.STORE,
					SR.STORE_LOCATION,
				</cfif>
                <cfif arguments.report_type eq 9>
					SR.STORE,
				</cfif>
                <cfif arguments.report_type eq 10>
					CAST(SR.STORE AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.STORE_LOCATION,0) AS NVARCHAR(50)) STORE_LOCATION,
				</cfif>
                SR.SPECT_VAR_ID SPECT_VAR_ID,
                <cfif arguments.report_type eq 8>
                	CAST(SR.STOCK_ID AS NVARCHAR(50))+'_'+CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)) AS STOCK_SPEC_ID,
                </cfif>
				S.PRODUCT_MANAGER,
				S.PRODUCT_CATID,
				S.BRAND_ID,
				SUM(SR.STOCK_IN-SR.STOCK_OUT) AMOUNT,
				SR.PROCESS_DATE ISLEM_TARIHI,
				SR.PROCESS_TYPE,
				0 AS MALIYET
				<cfif len(arguments.is_system_money_2)>
				,0 AS MALIYET_2
				</cfif>
			FROM        
				STOCKS_ROW SR WITH (NOLOCK),
				#dsn3_alias#.STOCKS S WITH (NOLOCK),
				#dsn_alias#.STOCKS_LOCATION SL WITH (NOLOCK)
			WHERE
				SR.STOCK_ID=S.STOCK_ID
				AND SR.STORE = SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				<cfif isdefined("is_belognto_institution") and not len(is_belognto_institution)>
				AND SL.BELONGTO_INSTITUTION = 0
				</cfif>
				AND SR.PROCESS_DATE <= #arguments.date2#	
				<cfif len(arguments.department_id)>
				AND
					(
					<cfloop list="#arguments.department_id#" delimiters="," index="dept_i">
					(SR.STORE = #listfirst(dept_i,'-')# AND SR.STORE_LOCATION = #listlast(dept_i,'-')#)
					<cfif dept_i neq listlast(arguments.department_id,',') and listlen(arguments.department_id,',') gte 1> OR</cfif>
					</cfloop>  
					)
				<cfelseif is_store>
					AND SR.STORE IN (#branch_dep_list#)
				</cfif>
				<cfif len(trim(arguments.sup_company)) and len(arguments.sup_company_id)>
					AND S.COMPANY_ID = #arguments.sup_company_id#
				</cfif>
				<cfif len(trim(arguments.employee_name)) and len(arguments.product_employee_id)>
					AND S.PRODUCT_MANAGER = #arguments.product_employee_id#
				</cfif>
				<cfif len(trim(arguments.product_name)) and len(arguments.product_id)>
					AND S.PRODUCT_ID = #arguments.product_id#
				</cfif>
				<cfif len(trim(arguments.brand_name)) and len(arguments.brand_id)>
					AND S.BRAND_ID = #arguments.brand_id# 
				</cfif>	
				<cfif len(trim(arguments.product_cat)) and len(arguments.product_code)>
					AND S.STOCK_CODE LIKE '#arguments.product_code#%'
				</cfif>
			GROUP BY
				SR.UPD_ID,
				S.STOCK_ID,
				S.PRODUCT_ID,
                SR.SPECT_VAR_ID,
				<cfif listfind('2,3,4,5,6,9',arguments.report_type) and len(arguments.location_based_cost)>
					SR.STORE,
					SR.STORE_LOCATION,
				</cfif>
                <cfif arguments.report_type eq 8>
                	CAST(SR.STOCK_ID AS NVARCHAR(50))+'_'+CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)),
                </cfif>
				<cfif arguments.report_type eq 9>
					SR.STORE,
				</cfif>
                <cfif arguments.report_type eq 10>
					SR.STORE,
					SR.STORE_LOCATION,
				</cfif>
				S.PRODUCT_MANAGER,
				S.PRODUCT_CATID,
				S.BRAND_ID,
				SR.PROCESS_DATE,
				SR.PROCESS_TYPE
		</cfquery>
	<cfreturn #GET_STOCK_ROWS#>		
	</cffunction>
	<!---<cffunction name="acilis_stok2" returntype="query">
		<cfargument name="dsn_alias" default="">		
		<cfargument name="dsn3_alias" default="">		
		<cfargument name="dsn3" default="">					
		<cfargument name="alan_adi" default="">
		<cfargument name="is_system_money_2" default="">
		<cfargument name="department_id" default="">
		<cfargument name="date" default="">
		cfargument name="GET_STOCK_ROWS" default="">
		<cfquery name="acilis_stok2" dbtype="query">
			SELECT	
				SUM(AMOUNT) AS DB_STOK_MIKTAR,
				SUM(AMOUNT*MALIYET) AS DB_STOK_MALIYET,
				<cfif len(arguments.is_system_money_2)>
				SUM(AMOUNT*MALIYET_2) AS DB_STOK_MALIYET_2,
				</cfif>
				#ALAN_ADI# AS GROUPBY_ALANI
			FROM
				#arguments.GET_STOCK_ROWS#
			WHERE
			<cfif arguments.date is '01/01/#session.ep.period_year#'>
				ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date#">
				AND PROCESS_TYPE = 114
			<cfelse>
				(
					(
					ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',-1,arguments.date)#">
					<cfif not len(arguments.department_id)>
						AND PROCESS_TYPE NOT IN (81,811)
					</cfif>
					)
					OR
					(
					ISLEM_TARIHI = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date#">
					AND PROCESS_TYPE = 114
					)
				)
			</cfif>
			GROUP BY
				#ALAN_ADI#
			ORDER BY 
				#ALAN_ADI#
		</cfquery>
		<cfreturn #acilis_stok2#>
	</cffunction>--->
</cfcomponent>

