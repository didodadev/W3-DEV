<cfif isdefined("attributes.is_form_submitted")>
	<cfif attributes.report_type neq 7>
		<cfif isdate(attributes.date)>
			<cf_date tarih = 'attributes.date'>
			<cfset start_date =attributes.date>
		</cfif>
		<cfif isdate(attributes.date2)>
			<cf_date tarih = 'attributes.date2'>
			<cfset finish_date =attributes.date2>
		</cfif>
		<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
			<cfset stock_table=1>
		<cfelseif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
			<cfset stock_table=1>
		<cfelseif len(trim(attributes.product_name)) and len(attributes.product_id)>
			<cfset stock_table=1>
		<cfelseif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
			<cfset stock_table=1>
		<cfelseif len(trim(attributes.product_cat)) and len(attributes.product_code)>
			<cfset stock_table=1>
		<cfelse>
			<cfset stock_table=0>
		</cfif>
	<cfquery name="GET_PERIODS_" datasource="#dsn#">
		SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID=#session.ep.company_id# AND PERIOD_YEAR IN (#session.ep.period_year#,#session.ep.period_year-1#,#session.ep.period_year-2# )
	</cfquery>
	<cfset new_period_id_list_ = valuelist(GET_PERIODS_.PERIOD_ID)>
	<!--- donem bası stok maliyet bu kurdan hesaplanıyor --->
	<cfquery name="START_RATE" datasource="#dsn#" maxrows="1">
		SELECT
			(RATE2/RATE1) AS RATE,MONEY 
		FROM 
			MONEY_HISTORY
		WHERE 
			VALIDATE_DATE <= #DATEADD('d',1, attributes.date)#
			AND PERIOD_ID = #session.ep.period_id#
			AND MONEY = '#attributes.cost_money#'
		ORDER BY 
			VALIDATE_DATE DESC
	</cfquery>
	<cfif len(START_RATE.RATE)>
		<cfset donem_basi_kur = START_RATE.RATE>
	<cfelse>
		<cfset donem_basi_kur=1>
	</cfif>
	<!--- donem sonu stok maliyeti bu kurdan hesaplanıyor --->
	<cfquery name="FINISH_RATE" datasource="#dsn#">
		SELECT
			(RATE2/RATE1) AS RATE,MONEY 
		FROM 
			MONEY_HISTORY
		WHERE 
			VALIDATE_DATE <= #DATEADD('d',1, attributes.date2)#
			AND PERIOD_ID = #session.ep.period_id#
			AND MONEY = '#attributes.cost_money#'
		ORDER BY 
			VALIDATE_DATE DESC
	</cfquery>
	<cfif len(FINISH_RATE.RATE)>
		<cfset donem_sonu_kur = FINISH_RATE.RATE>
	<cfelse>
		<cfset donem_sonu_kur=1>
	</cfif>
	<cfif isdefined('attributes.display_cost') and attributes.display_cost eq 1>
		<cfquery name="GET_ALL_PRODUCT_COST" datasource="#dsn3#" cachedwithin="#fusebox.general_cached_time#">
			SELECT 
				PRODUCT_ID,
				PRODUCT_COST_ID,
                <cfif is_store>
					PURCHASE_NET_LOCATION PURCHASE_NET, PURCHASE_EXTRA_COST_LOCATION PURCHASE_EXTRA_COST, PURCHASE_NET_MONEY_LOCATION PURCHASE_NET_MONEY,START_DATE,RECORD_DATE,
                    PURCHASE_NET_SYSTEM_LOCATION PURCHASE_NET_SYSTEM,PURCHASE_NET_SYSTEM_MONEY_LOCATION PURCHASE_NET_SYSTEM_MONEY,PURCHASE_EXTRA_COST_SYSTEM_LOCATION PURCHASE_EXTRA_COST_SYSTEM
                    <cfif isdefined('attributes.is_system_money_2')>
                    ,PURCHASE_NET_SYSTEM_2_LOCATION PURCHASE_NET_SYSTEM_2,PURCHASE_NET_SYSTEM_MONEY_2_LOCATION PURCHASE_NET_SYSTEM_MONEY_2,PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION PURCHASE_EXTRA_COST_SYSTEM_2
                    </cfif>
                    ,DEPARTMENT_ID
                    ,LOCATION_ID
				<cfelse>                
                    PURCHASE_NET, PURCHASE_EXTRA_COST, PURCHASE_NET_MONEY ,START_DATE,RECORD_DATE,
                    PURCHASE_NET_SYSTEM,PURCHASE_NET_SYSTEM_MONEY,PURCHASE_EXTRA_COST_SYSTEM
                    <cfif isdefined('attributes.is_system_money_2')>
                    ,PURCHASE_NET_SYSTEM_2,PURCHASE_NET_SYSTEM_MONEY_2,PURCHASE_EXTRA_COST_SYSTEM_2
                    </cfif>
                </cfif>
			FROM 
				PRODUCT_COST
			WHERE 
				START_DATE <= #attributes.date2#
				AND ACTION_PERIOD_ID IN (#new_period_id_list_#)
                <cfif is_store>
					AND DEPARTMENT_ID IN (#branch_dep_list#)
				</cfif>
			ORDER BY PRODUCT_ID, RECORD_DATE DESC, START_DATE DESC,PRODUCT_COST_ID DESC
		</cfquery>
		<cffunction name="produc_cost_func" returntype="struct" output="true">
			<cfargument name="cost_product_id" required="true">
			<cfargument name="cost_date" type="date" required="yes">
			<cfquery name="FUNC_PRODUCT_COST" dbtype="query" maxrows="1">
				SELECT 
					PRODUCT_ID, PURCHASE_NET, PURCHASE_EXTRA_COST, PURCHASE_NET_MONEY,START_DATE,RECORD_DATE,
					PURCHASE_NET_SYSTEM,PURCHASE_NET_SYSTEM_MONEY,PURCHASE_EXTRA_COST_SYSTEM
					<cfif isdefined('attributes.is_system_money_2')>
					,PURCHASE_NET_SYSTEM_2,PURCHASE_NET_SYSTEM_MONEY_2,PURCHASE_EXTRA_COST_SYSTEM_2
					</cfif>
				FROM 
					GET_ALL_PRODUCT_COST 
				WHERE 
					START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.cost_date#"> 
					AND PRODUCT_ID = #arguments.cost_product_id#
				ORDER BY START_DATE DESC, RECORD_DATE DESC,PRODUCT_COST_ID DESC
			</cfquery>
			<cfscript>
				product_cost_detail = StructNew();
				
				if(len(FUNC_PRODUCT_COST.PURCHASE_NET_SYSTEM)) //sistem para birimi cinsinden urun maliyeti
					product_cost_detail.PURCHASE_NET_SYSTEM = FUNC_PRODUCT_COST.PURCHASE_NET_SYSTEM; 
				else
					product_cost_detail.PURCHASE_NET_SYSTEM = 0;
				if(len(FUNC_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM)) //sistem para birimi cinsinden ek maliyeti
					product_cost_detail.PURCHASE_EXTRA_COST_SYSTEM =FUNC_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM; 
				else
					product_cost_detail.PURCHASE_EXTRA_COST_SYSTEM = 0;
				if(len(FUNC_PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY)) //sistem para birimi 
					product_cost_detail.PURCHASE_NET_SYSTEM_MONEY =FUNC_PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY; 
				else
					product_cost_detail.PURCHASE_NET_SYSTEM_MONEY = '';

				//sistem 2.parabirimi cinsinden maliyetler
				if(isdefined('attributes.is_system_money_2') )
				{
					if(len(FUNC_PRODUCT_COST.PURCHASE_NET_SYSTEM_2)) //sistem para birimi cinsinden urun maliyeti
						product_cost_detail.PURCHASE_NET_SYSTEM_2 =FUNC_PRODUCT_COST.PURCHASE_NET_SYSTEM_2; 
					else
						product_cost_detail.PURCHASE_NET_SYSTEM_2 = 0;
					if(len(FUNC_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_2)) //sistem para birimi cinsinden ek maliyeti
						product_cost_detail.PURCHASE_EXTRA_COST_SYSTEM_2 =FUNC_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_2; 
					else
						product_cost_detail.PURCHASE_EXTRA_COST_SYSTEM_2 = 0;
					if(len(FUNC_PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_2)) //sistem para birimi 
						product_cost_detail.PURCHASE_NET_SYSTEM_MONEY_2 =FUNC_PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_2; 
					else
						product_cost_detail.PURCHASE_NET_SYSTEM_MONEY_2 = '';
				}
				product_cost_detail.PRODUCT_ID = arguments.cost_product_id;
			</cfscript>
			<cfreturn product_cost_detail>
		</cffunction>
	</cfif>
	<!--- urunlerin speclere gore DONEM SONU maliyet ve miktarlarını getiriyor --->
		<cfif isdefined('attributes.display_cost') and attributes.display_cost eq 1>
			<cfquery name="GET_DS_SPEC_COST" datasource="#dsn1#" cachedwithin="#fusebox.general_cached_time#">
				SELECT  
					(SUM(STOCK_IN)-SUM(STOCK_OUT)) AS PRODUCT_STOCK,
					SR.STOCK_ID,
					SR.PRODUCT_ID,
					SR.SPECT_VAR_ID,
					<cfif stock_table>
					S.PRODUCT_CATID,
					</cfif>
                    <cfif attributes.report_type eq 8>
						CAST(SR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)) AS STOCK_SPEC_ID,
                    </cfif>
					<cfif is_store>
                        ISNULL((SELECT
                                TOP 1 (PURCHASE_NET_SYSTEM_LOCATION + PURCHASE_EXTRA_COST_SYSTEM_LOCATION)  
                            FROM 
                                #dsn3_alias#.PRODUCT_COST GPCP
                            WHERE
                                GPCP.START_DATE <=  #attributes.date2#
                                AND GPCP.PRODUCT_ID = SR.PRODUCT_ID
                                AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL(SR.SPECT_VAR_ID,0)
                                AND GPCP.DEPARTMENT_ID = SR.STORE
                                AND GPCP.LOCATION_ID = SR.STORE_LOCATION
                            ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC,GPCP.PRODUCT_COST_ID DESC
                                ),0) AS MALIYET
                        <cfif isdefined('attributes.is_system_money_2')>
                        ,ISNULL((SELECT
                                TOP 1 (PURCHASE_NET_SYSTEM_2_LOCATION + PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)  
                            FROM 
                                #dsn3_alias#.PRODUCT_COST GPCP
                            WHERE
                                GPCP.START_DATE <=  #attributes.date2#
                                AND GPCP.PRODUCT_ID = SR.PRODUCT_ID
                                AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL(SR.SPECT_VAR_ID,0)
                                AND GPCP.DEPARTMENT_ID = SR.STORE
                                AND GPCP.LOCATION_ID = SR.STORE_LOCATION
                            ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC,GPCP.PRODUCT_COST_ID DESC
                                ),0) AS MALIYET_2
                        </cfif>
                    <cfelse>
						ISNULL((SELECT
							TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
						FROM 
							#dsn3_alias#.PRODUCT_COST GPCP
						WHERE
							GPCP.START_DATE <=  #attributes.date2#
							AND GPCP.PRODUCT_ID = SR.PRODUCT_ID
							AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL(SR.SPECT_VAR_ID,0)
						ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC,GPCP.PRODUCT_COST_ID DESC
							),0) AS MALIYET
						<cfif isdefined('attributes.is_system_money_2')>
                        ,ISNULL((SELECT
                                TOP 1 (PURCHASE_NET_SYSTEM_2 + PURCHASE_EXTRA_COST_SYSTEM_2)  
                            FROM 
                                #dsn3_alias#.PRODUCT_COST GPCP
                            WHERE
                                GPCP.START_DATE <=  #attributes.date2#
                                AND GPCP.PRODUCT_ID = SR.PRODUCT_ID
                                AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL(SR.SPECT_VAR_ID,0)
                            ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC,GPCP.PRODUCT_COST_ID DESC
                                ),0) AS MALIYET_2
                        </cfif>
					</cfif>
				FROM 
					#dsn2_alias#.STOCKS_ROW SR,
					<cfif stock_table>
					#dsn3_alias#.STOCKS S,
					</cfif>
					#dsn_alias#.STOCKS_LOCATION SL
				WHERE 
					SR.STORE = SL.DEPARTMENT_ID
					AND SR.STORE_LOCATION=SL.LOCATION_ID
					<cfif not isdefined('is_belognto_institution')>
					AND SL.BELONGTO_INSTITUTION = 0
					</cfif>
					AND SR.PROCESS_DATE <= #attributes.date2#
					<cfif not len(attributes.department_id)>
                        AND SR.PROCESS_TYPE NOT IN (81,811)
                    </cfif>
					<cfif stock_table>
					AND S.STOCK_ID=SR.STOCK_ID
					</cfif>
					<cfif len(attributes.department_id)>
					AND	(
							SR.STORE IS NOT NULL AND
							<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(SR.STORE = #listfirst(dept_i,'-')# AND SR.STORE_LOCATION = #listlast(dept_i,'-')#)
							<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
							</cfloop>  
						)
					<cfelseif is_store>
                    	AND	SR.STORE IN (#branch_dep_list#)
					</cfif>
					<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
						AND S.COMPANY_ID = #attributes.sup_company_id#
					</cfif>
					<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
						AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
					</cfif>
					<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
						AND S.PRODUCT_ID = #attributes.product_id#
					</cfif>
					<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
						AND S.BRAND_ID = #attributes.brand_id# 
					</cfif>	
					<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
						AND S.STOCK_CODE LIKE '#attributes.product_code#%'
					</cfif>
				GROUP BY 
					SR.PRODUCT_ID,
					SR.STOCK_ID,
					SR.SPECT_VAR_ID
					<cfif stock_table>
					,S.PRODUCT_CATID
					</cfif>
					<cfif is_store>
						,SR.STORE,
						SR.STORE_LOCATION
					</cfif>
			</cfquery>
			<!--- urunlerin speclere gore DONEM BASI maliyet ve miktarlarını getiriyor --->
			<cfquery name="DB_SPEC_COST" datasource="#dsn1#" cachedwithin="#fusebox.general_cached_time#">
				SELECT  
					(SUM(STOCK_IN)-SUM(STOCK_OUT)) AS DB_PRODUCT_STOCK,
					SR.STOCK_ID,
					SR.PRODUCT_ID,
					SR.SPECT_VAR_ID,
                    <cfif attributes.report_type eq 8>
						CAST(SR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)) AS STOCK_SPEC_ID,
                    </cfif>
                    <cfif is_store>
                        ISNULL((SELECT
                                TOP 1 (PURCHASE_NET_SYSTEM_LOCATION + PURCHASE_EXTRA_COST_SYSTEM_LOCATION)  
                            FROM 
                                #dsn3_alias#.PRODUCT_COST GPCP
                            WHERE
                                GPCP.START_DATE <= #attributes.date#
                                AND GPCP.PRODUCT_ID = SR.PRODUCT_ID
                                AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL(SR.SPECT_VAR_ID,0)
                                AND GPCP.DEPARTMENT_ID = SR.STORE
                                AND GPCP.LOCATION_ID = SR.STORE_LOCATION
                            ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC,GPCP.PRODUCT_COST_ID DESC
                                ),0) AS DB_PRODUCT_MALIYET
                        <cfif isdefined('attributes.is_system_money_2')>
                        ,ISNULL((SELECT
                                TOP 1 (PURCHASE_NET_SYSTEM_2_LOCATION + PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)  
                            FROM 
                                #dsn3_alias#.PRODUCT_COST GPCP
                            WHERE
                                GPCP.START_DATE <= #attributes.date#
                                AND GPCP.PRODUCT_ID = SR.PRODUCT_ID
                                AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL(SR.SPECT_VAR_ID,0)
                                AND GPCP.DEPARTMENT_ID = SR.STORE
                                AND GPCP.LOCATION_ID = SR.STORE_LOCATION
                            ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC
                                ),0) AS DB_PRODUCT_MALIYET_2
                        </cfif>
					<cfelse>
                        ISNULL((SELECT
                                TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
                            FROM 
                                #dsn3_alias#.PRODUCT_COST GPCP
                            WHERE
                                GPCP.START_DATE <= #attributes.date#
                                AND GPCP.PRODUCT_ID = SR.PRODUCT_ID
                                AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL(SR.SPECT_VAR_ID,0)
                            ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC,GPCP.PRODUCT_COST_ID DESC
                                ),0) AS DB_PRODUCT_MALIYET
                        <cfif isdefined('attributes.is_system_money_2')>
                        ,ISNULL((SELECT
                                TOP 1 (PURCHASE_NET_SYSTEM_2 + PURCHASE_EXTRA_COST_SYSTEM_2)  
                            FROM 
                                #dsn3_alias#.PRODUCT_COST GPCP
                            WHERE
                                GPCP.START_DATE <= #attributes.date#
                                AND GPCP.PRODUCT_ID = SR.PRODUCT_ID
                                AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL(SR.SPECT_VAR_ID,0)
                            ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC,GPCP.PRODUCT_COST_ID DESC
                                ),0) AS DB_PRODUCT_MALIYET_2
                        </cfif>
					</cfif>
				FROM 
					#dsn2_alias#.STOCKS_ROW SR,
					<cfif stock_table>
					#dsn3_alias#.STOCKS S,
					</cfif>
					#dsn_alias#.STOCKS_LOCATION SL
				WHERE 
					SR.STORE = SL.DEPARTMENT_ID
					AND SR.STORE_LOCATION=SL.LOCATION_ID
					<cfif not isdefined('is_belognto_institution')>
						AND SL.BELONGTO_INSTITUTION = 0
					</cfif>
					<cfif attributes.date is '01/01/#session.ep.period_year#'>
						AND SR.PROCESS_DATE <= #attributes.date# 
						AND PROCESS_TYPE = 114
					<cfelse>
						AND 
						(
							( 
								SR.PROCESS_DATE <= #DATEADD('d',-1,attributes.date)#
								<cfif not len(attributes.department_id)>
									AND SR.PROCESS_TYPE NOT IN (81,811)
								</cfif> 
							)
							OR
							(
								SR.PROCESS_DATE = #attributes.date# 
								AND PROCESS_TYPE = 114
							)
						)
					</cfif>
					<cfif stock_table>
						AND S.STOCK_ID=SR.STOCK_ID
					</cfif>
					<cfif len(attributes.department_id)>
						AND (
								SR.STORE IS NOT NULL AND
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
								(SR.STORE = #listfirst(dept_i,'-')# AND SR.STORE_LOCATION = #listlast(dept_i,'-')#)
								<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
							)
					<cfelseif is_store>
                    	AND	SR.STORE IN (#branch_dep_list#)
					</cfif>
					<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
						AND S.COMPANY_ID = #attributes.sup_company_id#
					</cfif>
					<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
						AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
					</cfif>
					<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
						AND S.PRODUCT_ID = #attributes.product_id#
					</cfif>
					<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
						AND S.BRAND_ID = #attributes.brand_id# 
					</cfif>	
					<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
						AND S.STOCK_CODE LIKE '#attributes.product_code#%'
					</cfif>
				GROUP BY 
					SR.PRODUCT_ID,
					SR.STOCK_ID,
					SR.SPECT_VAR_ID
                    <cfif is_store>
						,SR.STORE,
						SR.STORE_LOCATION
					</cfif>
			</cfquery>
		<cfelse>
			<cfset GET_DS_SPEC_COST.recordcount = 0>
			<cfset DB_SPEC_COST.recordcount = 0>
		</cfif>
		<cfquery name="GET_ALL_STOCK" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			SELECT DISTINCT			 
			<cfif attributes.report_type eq 1>
				S.STOCK_CODE,
				S.STOCK_ID AS PRODUCT_GROUPBY_ID,
				(S.PRODUCT_NAME + ' ' + S.PROPERTY) ACIKLAMA,
				S.MANUFACT_CODE,
				S.PRODUCT_UNIT_ID,
				PU.MAIN_UNIT,
				S.BARCOD,
				S.PRODUCT_CODE,
			<cfelseif attributes.report_type eq 2>
				S.PRODUCT_ID AS PRODUCT_GROUPBY_ID,
				S.PRODUCT_NAME AS ACIKLAMA,
				S.MANUFACT_CODE,
				PU.MAIN_UNIT,
				S.BARCOD,
				S.PRODUCT_CODE,
			<cfelseif attributes.report_type eq 3>
				S.PRODUCT_CATID AS PRODUCT_GROUPBY_ID,
				PC.PRODUCT_CAT AS ACIKLAMA,
			<cfelseif attributes.report_type eq 4>
				S.PRODUCT_MANAGER AS PRODUCT_GROUPBY_ID,
				(EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME) AS ACIKLAMA,
			<cfelseif attributes.report_type eq 5>
				 PB.BRAND_ID AS PRODUCT_GROUPBY_ID,
				 PB.BRAND_NAME AS ACIKLAMA,
			<cfelseif attributes.report_type eq 6>
				 S.COMPANY_ID AS PRODUCT_GROUPBY_ID,
				 C.NICKNAME AS ACIKLAMA,
            <cfelseif attributes.report_type eq 8>
            	S.STOCK_CODE,
                S.STOCK_ID,
				CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)) AS PRODUCT_GROUPBY_ID,
                SR.SPECT_VAR_ID SPECT_VAR_ID,
				(S.PRODUCT_NAME + ' ' + S.PROPERTY) ACIKLAMA,
				S.MANUFACT_CODE,
				S.PRODUCT_UNIT_ID,
				PU.MAIN_UNIT,
				S.BARCOD,
				S.PRODUCT_CODE,
			</cfif>
				S.PRODUCT_STATUS,
				S.PRODUCT_ID,
				S.IS_PRODUCTION
			FROM        
				STOCKS_ROW AS SR,
				#dsn3_alias#.STOCKS S,
				#dsn3_alias#.PRODUCT_UNIT PU
			<cfif attributes.report_type eq 3>
				,#dsn3_alias#.PRODUCT_CAT PC
			<cfelseif attributes.report_type eq 4>
				,#dsn_alias#.EMPLOYEE_POSITIONS EP
			<cfelseif attributes.report_type eq 5>
				,#dsn3_alias#.PRODUCT_BRANDS PB
			<cfelseif attributes.report_type eq 6>
				 ,#dsn_alias#.COMPANY C
			</cfif>
			WHERE
				SR.STOCK_ID=S.STOCK_ID
				<cfif len(attributes.department_id)>
					AND
						(
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(SR.STORE = #listfirst(dept_i,'-')# AND SR.STORE_LOCATION = #listlast(dept_i,'-')#)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
						</cfloop>  
						)
				<cfelseif is_store>
					AND	SR.STORE IN (#branch_dep_list#)
				</cfif>
				<cfif len(attributes.product_status)>AND S.PRODUCT_STATUS = #attributes.product_status#</cfif>
				AND S.PRODUCT_ID=PU.PRODUCT_ID
				AND S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID
            <cfif attributes.report_type eq 8>
				AND S.IS_PRODUCTION = 1 
			</cfif>
			<cfif isdefined('attributes.is_envantory')>
				AND S.IS_INVENTORY=1
			</cfif>
			<cfif attributes.report_type eq 3>
				AND PC.PRODUCT_CATID = S.PRODUCT_CATID
			<cfelseif attributes.report_type eq 4>
				AND EP.POSITION_CODE = S.PRODUCT_MANAGER
			<cfelseif attributes.report_type eq 5>
				AND PB.BRAND_ID=S.BRAND_ID
			<cfelseif attributes.report_type eq 6>
				AND S.COMPANY_ID=C.COMPANY_ID
			</cfif>
			<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
				AND S.COMPANY_ID = #attributes.sup_company_id#
			</cfif>
			<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
				AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
			</cfif>
			<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
				AND S.PRODUCT_ID = #attributes.product_id#
			</cfif>
			<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
				AND S.BRAND_ID = #attributes.brand_id# 
			</cfif>	
			<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
				AND S.STOCK_CODE LIKE '#attributes.product_code#%'
			</cfif>
			<cfif listfind('1,2,3,4,5,6',attributes.report_type,',') and (isdefined('attributes.positive_stock') or isdefined('attributes.negatif_stock') or isdefined('attributes.is_stock_action'))><!--- sadece pozitif stoklar veya sadece hareket gormus stokların gelmesi --->
				AND S.STOCK_ID IN (
						SELECT   
							SR.STOCK_ID
						FROM        
							STOCKS_ROW SR,
							#dsn_alias#.STOCKS_LOCATION SL
						WHERE
							SR.STORE = SL.DEPARTMENT_ID
							AND SR.STORE_LOCATION=SL.LOCATION_ID
							<cfif isdefined('attributes.is_stock_action')>
							AND SR.UPD_ID IS NOT NULL
							</cfif>
							<cfif not isdefined('is_belognto_institution')>
							AND SL.BELONGTO_INSTITUTION = 0
							</cfif>
							AND SR.PROCESS_DATE <= #attributes.date2#	
							<cfif len(attributes.department_id)>
							AND
								(
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
								(SR.STORE = #listfirst(dept_i,'-')# AND SR.STORE_LOCATION = #listlast(dept_i,'-')#)
								<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
								)
                            <cfelseif is_store>
		                    	AND	SR.STORE IN (#branch_dep_list#)
							</cfif>
							<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
								AND S.COMPANY_ID = #attributes.sup_company_id#
							</cfif>
							<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
								AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
							</cfif>
							<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
								AND S.PRODUCT_ID = #attributes.product_id#
							</cfif>
							<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
								AND S.BRAND_ID = #attributes.brand_id# 
							</cfif>	
							<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
								AND S.STOCK_CODE LIKE '#attributes.product_code#%'
							</cfif>
							<cfif isdefined('attributes.positive_stock')>
							GROUP BY STOCK_ID HAVING round((SUM(STOCK_IN)-SUM(STOCK_OUT)),2) > 0
							</cfif>
							<cfif isdefined('attributes.negatif_stock')>
							GROUP BY STOCK_ID HAVING round((SUM(STOCK_IN)-SUM(STOCK_OUT)),2) < 0
							</cfif>
						)
			</cfif>
			ORDER BY 
			<cfif attributes.report_type eq 1>
				S.STOCK_CODE
			<cfelse>
				ACIKLAMA
			</cfif>
		</cfquery>
		<cfif listfind('1,2,8',attributes.report_type)>
			<cfif len(attributes.process_type) and (listfind(attributes.process_type,4) or listfind(attributes.process_type,5) or listfind(attributes.process_type,12) or listfind(attributes.process_type,14) or listfind(attributes.process_type,18))>
				<cfquery name="GET_STOCK_FIS" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
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
						<cfif isdefined('attributes.is_system_money_2')> <!--- sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir --->
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
						<cfif attributes.report_type eq 8>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
						SF.FIS_DATE ISLEM_TARIHI,
						SF.PROCESS_CAT,
						SF.FIS_TYPE PROCESS_TYPE,
						ISNULL(SF.PROD_ORDER_NUMBER,0) AS PROD_ORDER_NUMBER,
						ISNULL(SF.PROD_ORDER_RESULT_NUMBER,0) AS PROD_ORDER_RESULT_NUMBER
					FROM 
						STOCK_FIS SF,
						STOCK_FIS_ROW SFR,
						STOCK_FIS_MONEY SF_M,
                        <cfif is_store>
                        	<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC
							<cfelse>
                            	GET_STOCKS_ROW_COST_LOCATION AS GC
							</cfif>
						<cfelse>
                        	<cfif attributes.report_type eq 8>
                                GET_STOCKS_ROW_COST_SPECT AS GC
                            <cfelse>
                                GET_STOCKS_ROW_COST AS GC
                            </cfif>
						</cfif>
						<cfif stock_table>
						,#dsn3_alias#.STOCKS S
						</cfif>
					WHERE 
						GC.UPD_ID = SF.FIS_ID AND
						SFR.FIS_ID=	SF.FIS_ID AND
						SF.FIS_ID = SF_M.ACTION_ID AND
						GC.PROCESS_TYPE = SF.FIS_TYPE AND
						<cfif stock_table>
						S.STOCK_ID = GC.STOCK_ID AND
						</cfif>
						GC.STOCK_ID=SFR.STOCK_ID AND
						SF.FIS_TYPE  IN (110,111,112,113,115,119) AND 
						SF.FIS_DATE >= #attributes.date# AND 
						SF.FIS_DATE <= #attributes.date2# AND
						<cfif isdefined('attributes.is_system_money_2')>
							SF_M.MONEY_TYPE = '#session.ep.money2#'
						<cfelse>
							SF_M.MONEY_TYPE = '#attributes.cost_money#'
						</cfif>
						<cfif len(attributes.department_id)>
						AND(
							(
								SF.DEPARTMENT_OUT IS NOT NULL AND
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
								(SF.DEPARTMENT_OUT = #listfirst(dept_i,'-')# AND SF.LOCATION_OUT = #listlast(dept_i,'-')#)
								<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
							)
						OR 
							(
								SF.DEPARTMENT_IN IS NOT NULL AND
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
								(SF.DEPARTMENT_IN  = #listfirst(dept_i,'-')# AND SF.LOCATION_IN = #listlast(dept_i,'-')#)
								<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
                        <cfelseif is_store>
		                    AND (
                            		SF.DEPARTMENT_OUT IN (#branch_dep_list#) OR SF.DEPARTMENT_IN IN (#branch_dep_list#)
                                 )
						</cfif>
						<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
							AND S.COMPANY_ID = #attributes.sup_company_id#
						</cfif>
						<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
							AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
						</cfif>
						<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
							AND S.PRODUCT_ID = #attributes.product_id#
						</cfif>
						<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
							AND S.BRAND_ID = #attributes.brand_id# 
						</cfif>	
						<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
							AND S.STOCK_CODE LIKE '#attributes.product_code#%'
						</cfif>
				</cfquery>
			</cfif>
			<!--- masraf fişleri--->
			<cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
				<cfquery name="GET_EXPENSE" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
					SELECT
						GC.PRODUCT_ID,
						GC.STOCK_ID,
						<cfif stock_table>
						S.PRODUCT_CATID,
						S.BRAND_ID,
						</cfif>
						EIR.QUANTITY AS AMOUNT,
						<cfif isdefined('attributes.is_system_money_2')> <!--- sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir --->
						GC.MALIYET MALIYET,
						GC.MALIYET_2 MALIYET_2,
						<cfelse>
						(GC.MALIYET/(EIRM.RATE2/EIRM.RATE1)) MALIYET,
						</cfif>
						<cfif attributes.report_type eq 8>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
						EIP.EXPENSE_DATE ISLEM_TARIHI,
						EIP.ACTION_TYPE PROCESS_TYPE
					FROM 
						EXPENSE_ITEM_PLANS EIP,
						EXPENSE_ITEMS_ROWS EIR,
						EXPENSE_ITEM_PLANS_MONEY EIRM,
                        <cfif is_store>
                        	<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC
							<cfelse>
                            	GET_STOCKS_ROW_COST_LOCATION AS GC
							</cfif>
						<cfelse>
                        	<cfif attributes.report_type eq 8>
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
						EIP.EXPENSE_DATE >= #attributes.date# AND 
						EIP.EXPENSE_DATE <= #attributes.date2# AND
						<cfif isdefined('attributes.is_system_money_2')>
							EIRM.MONEY_TYPE = '#session.ep.money2#'
						<cfelse>
							EIRM.MONEY_TYPE = '#attributes.cost_money#'
						</cfif>
						<cfif len(attributes.department_id)>
						AND(
							(
								EIP.DEPARTMENT_ID IS NOT NULL AND
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
								(EIP.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND EIP.LOCATION_ID = #listlast(dept_i,'-')#)
								<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
						</cfif>
						<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
							AND S.COMPANY_ID = #attributes.sup_company_id#
						</cfif>
						<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
							AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
						</cfif>
						<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
							AND S.PRODUCT_ID = #attributes.product_id#
						</cfif>
						<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
							AND S.BRAND_ID = #attributes.brand_id# 
						</cfif>	
						<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
							AND S.STOCK_CODE LIKE '#attributes.product_code#%'
						</cfif>
				</cfquery>
			</cfif>
			<!--- demontaj islemleri secili ise --->
			<cfif len(attributes.process_type) and (listfind(attributes.process_type,14) or listfind(attributes.process_type,13) )>
				<cfquery name="GET_DEMONTAJ" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
					SELECT
						GC.PRODUCT_ID,
						GC.STOCK_ID,
						<cfif stock_table>
						S.PRODUCT_CATID,
						S.BRAND_ID,
						</cfif>
						GC.STOCK_IN,
						GC.STOCK_OUT,
						<cfif isdefined('attributes.is_system_money_2')>
						GC.MALIYET MALIYET,
						GC.MALIYET_2 MALIYET_2,
						<cfelse>
						(GC.MALIYET/(SF_M.RATE2/SF_M.RATE1)) MALIYET,
						</cfif>
                        <cfif attributes.report_type eq 8>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
						SF.FIS_DATE ISLEM_TARIHI,
						SF.FIS_TYPE PROCESS_TYPE
					FROM 
						STOCK_FIS SF,
						STOCK_FIS_MONEY SF_M,
						 <cfif is_store>
                        	<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
							<cfelse>
                            	GET_STOCKS_ROW_COST_LOCATION AS GC,
							</cfif>
						<cfelse>
                        	<cfif attributes.report_type eq 8>
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
						SF.FIS_ID = SF_M.ACTION_ID AND
						GC.PROCESS_TYPE = SF.FIS_TYPE AND
						SF.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND
						SF.PROD_ORDER_NUMBER IS NOT NULL AND
						PO.IS_DEMONTAJ = 1 AND 
						<cfif stock_table>
						S.STOCK_ID = GC.STOCK_ID AND
						</cfif>
						SF.FIS_TYPE =111 AND 
						SF.FIS_DATE >= #attributes.date# AND 
						SF.FIS_DATE <= #attributes.date2# AND 
						<cfif isdefined('attributes.is_system_money_2')>
						SF_M.MONEY_TYPE = '#session.ep.money2#'
						<cfelse>
						SF_M.MONEY_TYPE = '#attributes.cost_money#'
						</cfif>
						<cfif len(attributes.department_id)>
                            AND(
                                (
                                    SF.DEPARTMENT_OUT IS NOT NULL AND
                                    <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                    (SF.DEPARTMENT_OUT = #listfirst(dept_i,'-')# AND SF.LOCATION_OUT = #listlast(dept_i,'-')#)
                                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                    </cfloop>  
                                )
                            OR 
                                (
                                    SF.DEPARTMENT_IN IS NOT NULL AND
                                    <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                    (SF.DEPARTMENT_IN  = #listfirst(dept_i,'-')# AND SF.LOCATION_IN = #listlast(dept_i,'-')#)
                                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                    </cfloop>  
                                )
                            )
                        <cfelseif is_store>
		                    AND (
                            		SF.DEPARTMENT_OUT IN (#branch_dep_list#) OR SF.DEPARTMENT_IN IN (#branch_dep_list#)
                                 )
						</cfif>
						<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
							AND S.COMPANY_ID = #attributes.sup_company_id#
						</cfif>
						<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
							AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
						</cfif>
						<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
							AND S.PRODUCT_ID = #attributes.product_id#
						</cfif>
						<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
							AND S.BRAND_ID = #attributes.brand_id# 
						</cfif>	
						<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
							AND S.STOCK_CODE LIKE '#attributes.product_code#%'
						</cfif>
				</cfquery>
			</cfif>
			<cfif len(attributes.process_type) and listfind(attributes.process_type,2) or listfind(attributes.process_type,3)>
				<cfquery name="GET_INV_PURCHASE" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
					SELECT 
						IR.STOCK_ID,
						IR.PRODUCT_ID,
                        <cfif attributes.report_type eq 8>
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
						<cfif isdefined('attributes.is_system_money_2')>
						(IR.EXTRA_COST * IR.AMOUNT) EXTRA_COST,
						CASE WHEN I.SA_DISCOUNT=0 THEN IR.NETTOTAL ELSE ( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) END AS BIRIM_COST,
						((IR.EXTRA_COST * IR.AMOUNT)/(IM.RATE2/IM.RATE1))EXTRA_COST_2,
						CASE WHEN I.SA_DISCOUNT=0 THEN (IR.NETTOTAL/(IM.RATE2/IM.RATE1)) ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(IM.RATE2/IM.RATE1)) END AS BIRIM_COST_2
						<cfelse>
						((IR.EXTRA_COST * IR.AMOUNT)/(IM.RATE2/IM.RATE1))EXTRA_COST,
						CASE WHEN I.SA_DISCOUNT=0 THEN (IR.NETTOTAL/(IM.RATE2/IM.RATE1)) ELSE (( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(IM.RATE2/IM.RATE1)) END AS BIRIM_COST
						</cfif>
					FROM 
						INVOICE I,
						INVOICE_ROW IR,
						INVOICE_MONEY IM
						<cfif stock_table>
						,#dsn3_alias#.STOCKS S
						</cfif>
					WHERE 
						I.INVOICE_ID = IM.ACTION_ID AND
						I.INVOICE_ID = IR.INVOICE_ID AND
						<cfif not isdefined('attributes.from_invoice_actions')>
						I.INVOICE_CAT IN (51,54,55,59,60,61,62,63,64,65,68,690,691,591,592) AND
						</cfif>
						I.IS_IPTAL = 0 AND
						I.NETTOTAL > 0 AND
						I.INVOICE_DATE >= #attributes.date# AND 
						I.INVOICE_DATE <= #attributes.date2# AND
						<cfif isdefined('attributes.is_system_money_2')>
						IM.MONEY_TYPE = '#session.ep.money2#'
						<cfelse>
						IM.MONEY_TYPE = '#attributes.cost_money#'
						</cfif>
						<cfif stock_table>
						AND IR.STOCK_ID=S.STOCK_ID
						</cfif>
						<cfif len(attributes.department_id)>
							AND
							(
							<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(I.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND I.DEPARTMENT_LOCATION = #listlast(dept_i,'-')#)
							<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
							</cfloop>  
							)
						 <cfelseif is_store>
		                    AND I.DEPARTMENT_ID IN (#branch_dep_list#)
						</cfif>
						<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
							AND S.COMPANY_ID = #attributes.sup_company_id#
						</cfif>
						<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
							AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
						</cfif>
						<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
							AND S.PRODUCT_ID = #attributes.product_id#
						</cfif>
						<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
							AND S.BRAND_ID = #attributes.brand_id# 
						</cfif>	
						<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
							AND S.STOCK_CODE LIKE '#attributes.product_code#%'
						</cfif>
				</cfquery>
			</cfif>
			<cfif len(attributes.process_type)>
				<cfquery name="GET_SHIP_ROWS" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
					SELECT
						GC.STOCK_ID,
						GC.PRODUCT_ID,
                        <cfif attributes.report_type eq 8>
                        CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                        </cfif>
						1 AS INVOICE_CAT,
						<cfif stock_table>
						S.PRODUCT_MANAGER,
						S.PRODUCT_CATID,
						S.BRAND_ID,
						</cfif>
						<cfif isdefined('attributes.is_system_money_2')>
						GC.MALIYET_2,
						GC.MALIYET,
						((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
						(GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
						<cfelse>
							<cfif attributes.cost_money is not session.ep.money>
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
						GC.PROCESS_TYPE PROCESS_TYPE
					FROM
                    	<cfif is_store>
                        	<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
							<cfelse>
                            	GET_STOCKS_ROW_COST_LOCATION AS GC,
                            </cfif>
                        <cfelse>
							<cfif attributes.report_type eq 8>
                                GET_STOCKS_ROW_COST_SPECT AS GC,
                            <cfelse>
                                GET_STOCKS_ROW_COST AS GC,
                            </cfif>
						</cfif>
						<cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
						SHIP,	
						</cfif>
						<cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
						SHIP_MONEY SM,
						</cfif>
						<cfif stock_table>
						#dsn3_alias#.STOCKS S,
						</cfif>
						#dsn_alias#.STOCKS_LOCATION SL
					WHERE
						GC.STORE = SL.DEPARTMENT_ID
						AND GC.STORE_LOCATION=SL.LOCATION_ID
						<cfif not isdefined('is_belognto_institution')>
						AND SL.BELONGTO_INSTITUTION = 0
						</cfif>
						<cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3)>
						AND GC.UPD_ID = SHIP.SHIP_ID
						AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
						AND ISNULL(SHIP.IS_WITH_SHIP,0)=0
						</cfif>
						<cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
						AND SHIP.SHIP_ID = SM.ACTION_ID
							<cfif isdefined('attributes.is_system_money_2')>
								AND SM.MONEY_TYPE = '#session.ep.money2#'
							<cfelse>
								AND SM.MONEY_TYPE = '#attributes.cost_money#'
							</cfif>
						</cfif>
						AND GC.PROCESS_DATE >= #attributes.date#
						AND GC.PROCESS_DATE <= #attributes.date2#
						<cfif len(attributes.department_id)>
						AND
							(
							<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
							<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
							</cfloop>  
							)
						<cfelseif is_store>
		                    AND GC.STORE IN (#branch_dep_list#)
						</cfif>
						<cfif stock_table>
						AND	GC.STOCK_ID=S.STOCK_ID
						</cfif>
						<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
						AND S.COMPANY_ID = #attributes.sup_company_id#
						</cfif>
						<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
						AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
						</cfif>
						<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
						AND S.PRODUCT_ID = #attributes.product_id#
						</cfif>
						<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
						AND S.BRAND_ID = #attributes.brand_id# 
						</cfif>	
						<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
						AND S.STOCK_CODE LIKE '#attributes.product_code#%'
						</cfif>
				<cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3)>
				UNION ALL
					SELECT
						GC.STOCK_ID,
						GC.PRODUCT_ID,
                        <cfif attributes.report_type eq 8>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                        </cfif>
						INVOICE.INVOICE_CAT,
						<cfif stock_table>
						S.PRODUCT_MANAGER,
						S.PRODUCT_CATID,
						S.BRAND_ID,
						</cfif>
						<cfif isdefined('attributes.is_system_money_2')>
						GC.MALIYET_2,
						GC.MALIYET,
						((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
						(GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
						<cfelse>
							(GC.MALIYET/(IM.RATE2/IM.RATE1)) AS MALIYET,
							((GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT))/(IM.RATE2/IM.RATE1)) AS TOTAL_COST,
						</cfif>
						ABS(GC.STOCK_IN-GC.STOCK_OUT) AS AMOUNT,
						GC.STOCK_IN,
						GC.STOCK_OUT,
						GC.PROCESS_DATE ISLEM_TARIHI,
						GC.PROCESS_TYPE PROCESS_TYPE
					FROM
						SHIP,
						INVOICE,
						INVOICE_SHIPS INV_S,
						INVOICE_MONEY IM,
						<cfif is_store>
                        	<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
							<cfelse>
                            	GET_STOCKS_ROW_COST_LOCATION AS GC,
                            </cfif>
                        <cfelse>
							<cfif attributes.report_type eq 8>
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
						AND IM.ACTION_ID=INVOICE.INVOICE_ID
						AND INV_S.IS_WITH_SHIP = 1
						AND INV_S.SHIP_PERIOD_ID = #session.ep.period_id#
						AND SHIP.IS_WITH_SHIP=1
						AND SHIP.SHIP_ID = GC.UPD_ID
						AND SHIP.SHIP_TYPE = GC.PROCESS_TYPE
						AND GC.STORE = SL.DEPARTMENT_ID
						AND GC.STORE_LOCATION=SL.LOCATION_ID
						<cfif not isdefined('is_belognto_institution')>
						AND SL.BELONGTO_INSTITUTION = 0
						</cfif>
						<cfif isdefined('attributes.is_system_money_2')>
						AND IM.MONEY_TYPE = '#session.ep.money2#'
						<cfelse>
						AND IM.MONEY_TYPE = '#attributes.cost_money#'
						</cfif>
						AND GC.PROCESS_DATE >= #attributes.date#
						AND GC.PROCESS_DATE <= #attributes.date2#
						<cfif len(attributes.department_id)>
						AND
							(
							<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(GC.STORE = #listfirst(dept_i,'-')# AND GC.STORE_LOCATION = #listlast(dept_i,'-')#)
							<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
							</cfloop>  
							)
                        <cfelseif is_store>
		                    AND GC.STORE IN (#branch_dep_list#)
						</cfif>
						<cfif stock_table>
						AND	GC.STOCK_ID=S.STOCK_ID
						</cfif>
						<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
							AND S.COMPANY_ID = #attributes.sup_company_id#
						</cfif>
						<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
							AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
						</cfif>
						<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
							AND S.PRODUCT_ID = #attributes.product_id#
						</cfif>
						<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
							AND S.BRAND_ID = #attributes.brand_id# 
						</cfif>	
						<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
							AND S.STOCK_CODE LIKE '#attributes.product_code#%'
						</cfif>
				</cfif>
				</cfquery>
			<cfelse>
				<cfset GET_SHIP_ROWS.recordcount = 0>
			</cfif>
		<cfelse>
			<cfset GET_STOCK_FIS.recordcount = 0>
			<cfset GET_DEMONTAJ.recordcount = 0>
			<cfset GET_INV_PURCHASE.recordcount = 0>
		</cfif>
		<cfif isdefined('attributes.stock_age')>
			<cfquery name="GET_STOCK_AGE" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
				SELECT 
					IR.STOCK_ID,
					IR.PRODUCT_ID,
					<cfif attributes.report_type eq 8>
						CAST(IR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS NVARCHAR(50))  STOCK_SPEC_ID,
					</cfif>
					IR.AMOUNT,
					ISNULL(I.DELIVER_DATE,I.SHIP_DATE) AS ISLEM_TARIHI,
					ISNULL(DATEDIFF(day,I.DELIVER_DATE,#attributes.date2#),DATEDIFF(day,I.SHIP_DATE,#attributes.date2#))  AS GUN_FARKI,
					I.DEPARTMENT_IN,
					I.LOCATION_IN,
					S.BRAND_ID,
					S.PRODUCT_CATID,
					S.PRODUCT_MANAGER
				FROM 
					SHIP I,
					SHIP_ROW IR,
					#dsn3_alias#.STOCKS S
				WHERE 
					I.SHIP_ID = IR.SHIP_ID AND
					S.STOCK_ID=IR.STOCK_ID AND	
					<cfif len(attributes.department_id)><!--- depo varsa depolar arası sevk VE ithal mal girisine bak --->
					I.SHIP_TYPE IN (76,81,811) AND
					<cfelse>
					I.SHIP_TYPE =76 AND
					</cfif>
					I.IS_SHIP_IPTAL = 0 AND
					<!--- I.SHIP_DATE >= #attributes.date# AND  --->
					I.SHIP_DATE <= #attributes.date2#
					<cfif len(attributes.department_id)>
					AND
						(
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(I.DEPARTMENT_IN = #listfirst(dept_i,'-')# AND I.LOCATION_IN = #listlast(dept_i,'-')#)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
						</cfloop>  
						)
					<cfelseif is_store>
						AND I.DEPARTMENT_IN IN (#branch_dep_list#)
					</cfif>
					<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
						AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
					</cfif>
					<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
						AND S.PRODUCT_ID = #attributes.product_id#
					</cfif>
					<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
						AND S.BRAND_ID = #attributes.brand_id# 
					</cfif>	
					<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
						AND S.STOCK_CODE LIKE '#attributes.product_code#%'
					</cfif>
			UNION ALL
				SELECT 
					IR.STOCK_ID,
					S.PRODUCT_ID,
                    <cfif attributes.report_type eq 8>
						CAST(IR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS NVARCHAR(50))  STOCK_SPEC_ID,
					</cfif>
					IR.AMOUNT,
					I.FIS_DATE ISLEM_TARIHI,
					<!--- ISNULL(DATEDIFF(day,DATEADD(day,-1*DUE_DATE,FIS_DATE),#attributes.date2#),DATEDIFF(day,FIS_DATE,#attributes.date2#)) AS GUN_FARKI, --->
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
					<cfif len(attributes.department_id)><!--- depo varsa ambar fisine bak --->
					I.FIS_TYPE IN (110,113,114,115,119) AND
					<cfelse>
					I.FIS_TYPE IN (110,114,115,119) AND
					</cfif>
					<!--- I.FIS_DATE >= #attributes.date# AND  --->
					I.FIS_DATE <= #attributes.date2#
					<cfif len(attributes.department_id)>
					AND
						(
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(I.DEPARTMENT_IN = #listfirst(dept_i,'-')# AND I.LOCATION_IN = #listlast(dept_i,'-')#)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
						</cfloop>  
						)
					<cfelseif is_store>
						AND I.DEPARTMENT_IN IN (#branch_dep_list#)
					</cfif>
					<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
						AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
					</cfif>
					<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
						AND S.PRODUCT_ID = #attributes.product_id#
					</cfif>
					<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
						AND S.BRAND_ID = #attributes.brand_id# 
					</cfif>	
					<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
						AND S.STOCK_CODE LIKE '#attributes.product_code#%'
					</cfif>
			</cfquery>
		</cfif>
		<cfquery name="GET_STOCK_ROWS" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			SELECT   
				S.STOCK_ID,
				S.PRODUCT_ID,
                SR.SPECT_VAR_ID SPECT_VAR_ID,
                <cfif attributes.report_type eq 8>
                	CAST(SR.STOCK_ID AS NVARCHAR(50))+'_'+CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)) AS STOCK_SPEC_ID,
                </cfif>
				S.PRODUCT_MANAGER,
				S.PRODUCT_CATID,
				S.BRAND_ID,
				(SR.STOCK_IN-SR.STOCK_OUT) AMOUNT,
				SR.STOCK_IN,
				SR.STOCK_OUT,
				SR.PROCESS_DATE ISLEM_TARIHI,
				SR.PROCESS_TYPE,
				0 AS MALIYET
				<cfif isdefined('attributes.is_system_money_2')>
				,0 AS MALIYET_2
				</cfif>
			FROM        
				STOCKS_ROW SR,
				#dsn3_alias#.STOCKS S,
				#dsn_alias#.STOCKS_LOCATION SL
			WHERE
				SR.STOCK_ID=S.STOCK_ID
				AND SR.STORE = SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				<cfif not isdefined('is_belognto_institution')>
				AND SL.BELONGTO_INSTITUTION = 0
				</cfif>
				AND SR.PROCESS_DATE <= #attributes.date2#	
				<cfif len(attributes.department_id)>
				AND
					(
					<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
					(SR.STORE = #listfirst(dept_i,'-')# AND SR.STORE_LOCATION = #listlast(dept_i,'-')#)
					<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
					</cfloop>  
					)
				<cfelseif is_store>
					AND SR.STORE IN (#branch_dep_list#)
				</cfif>
				<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
					AND S.COMPANY_ID = #attributes.sup_company_id#
				</cfif>
				<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
					AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
				</cfif>
				<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
					AND S.PRODUCT_ID = #attributes.product_id#
				</cfif>
				<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
					AND S.BRAND_ID = #attributes.brand_id# 
				</cfif>	
				<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
					AND S.STOCK_CODE LIKE '#attributes.product_code#%'
				</cfif>
		</cfquery>
	</cfif>
<cfelse>
	<cfscript>
		GET_STOCK_ROWS.recordcount = 0;
		GET_ALL_STOCK.recordcount = 0;
		GET_INV_PURCHASE.recordcount = 0;
		GET_SHIP_ROWS.recordcount = 0;
		GET_DS_SPEC_COST.recordcount = 0;
		DB_SPEC_COST.recordcount = 0;
		GET_EXPENSE.recordcount = 0;
	</cfscript>
</cfif>
<cfif attributes.report_type neq 7><!--- belge bazında raporlama degilse  --->
	<cfparam name="attributes.totalrecords" default=#GET_ALL_STOCK.recordcount#><!--- belge bazında raporlama secilmis ise detail_stock_row_list.cfm de set ediliyor  --->
	<cfif GET_STOCK_ROWS.recordcount>
		<cfquery name="acilis_stok2" dbtype="query">
			SELECT	
				SUM(AMOUNT) AS DB_STOK_MIKTAR,
				SUM(AMOUNT*MALIYET) AS DB_STOK_MALIYET,
				<cfif isdefined('attributes.is_system_money_2')>
				SUM(AMOUNT*MALIYET_2) AS DB_STOK_MALIYET_2,
				</cfif>
				#ALAN_ADI# AS GROUPBY_ALANI
			FROM
				GET_STOCK_ROWS
			WHERE
			 <cfif attributes.date is '01/01/#session.ep.period_year#'>
				ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date#">
				AND PROCESS_TYPE = 114
			<cfelse>
				(
					(
					ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',-1,attributes.date)#">
					<cfif not len(attributes.department_id)>
						AND PROCESS_TYPE NOT IN (81,811)
					</cfif>
					)
					OR
					(
					ISLEM_TARIHI = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date#">
					AND PROCESS_TYPE = 114
					)
				)
			</cfif>
			GROUP BY
				#ALAN_ADI#
			ORDER BY 
				#ALAN_ADI#
		</cfquery>
		<cfquery name="get_total_stok" dbtype="query">
			SELECT 
				SUM(AMOUNT) AS TOTAL_STOCK,
				SUM(AMOUNT*MALIYET) AS TOTAL_PRODUCT_COST,
				<cfif isdefined('attributes.is_system_money_2')>
				SUM(AMOUNT*MALIYET_2) AS TOTAL_PRODUCT_COST_2,
				</cfif>
				#ALAN_ADI# AS GROUPBY_ALANI
			FROM
				GET_STOCK_ROWS
			WHERE
				ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				<cfif not len(attributes.department_id)>
				AND PROCESS_TYPE NOT IN (81,811)
				</cfif>
			GROUP BY
				#ALAN_ADI#
			ORDER BY
				#ALAN_ADI# 
		</cfquery>
		<!---depo-lokasyon secili, islem tiplerinde de ithal mal girişi secili ise ithal mal girişi ayrı bölümde gosterilir.--->
	<cfelse>
		<cfset acilis_stok2.recordcount = 0>
		<cfset get_total_stok.recordcount = 0>
	</cfif>
	<cfif listfind('1,2,8',attributes.report_type)>
		<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
		<!---Dönem İçi Alış Miktar : Yurtiçi ve Yurtdışı Mal alım irsaliyelerindeki toplam miktar (Demirbaş, Konsinye, İade olmayacak)  --->
			<cfquery name="d_alis_miktar" dbtype="query">
				SELECT	
					SUM(AMOUNT) AS TOPLAM_ALIS,
					SUM(TOTAL_COST) AS TOPLAM_ALIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_2) AS TOPLAM_ALIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE IN (76,80,84,87)<!--- 811 kaldırıldı neden var?--->
					AND INVOICE_CAT NOT IN (54,55) <!--- satıs iade faturaları da mal alım irs. kaydediyor, bunları alıslara dahil etmiyoruz zaten satıs iade bolumunde gosteriliyor --->
				GROUP BY
					#ALAN_ADI#
				ORDER BY 
					#ALAN_ADI#
			</cfquery>
			<cfquery name="d_alis_tutar" dbtype="query">
				SELECT
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(BIRIM_COST_2 + EXTRA_COST_2) AS TOPLAM_ALIS_MALIYET_2,
					SUM(BIRIM_COST_2) AS TOPLAM_ALIS_TUTAR_2,
					</cfif>
					SUM(BIRIM_COST + EXTRA_COST) AS TOPLAM_ALIS_MALIYET,
					SUM(BIRIM_COST) AS TOPLAM_ALIS_TUTAR,
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_INV_PURCHASE
				WHERE
					PROCESS_TYPE IN (59,64,68,690,591) 
				GROUP BY
					#ALAN_ADI#
				ORDER BY
					#ALAN_ADI# 
			</cfquery>
			<cfquery name="d_alis_iade_miktar" dbtype="query">
				SELECT
					SUM(AMOUNT) AS TOPLAM_ALIS_IADE,
					SUM(TOTAL_COST) AS TOPLAM_ALIS_IADE_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_2) AS TOPLAM_ALIS_IADE_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE=78
				GROUP BY
					#ALAN_ADI#
				ORDER BY 
					#ALAN_ADI#
			</cfquery>
			<cfquery name="d_alis_iade_tutar" dbtype="query">
				SELECT	
					SUM(EXTRA_COST + BIRIM_COST) AS TOPLAM_ALIS_IADE_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(EXTRA_COST_2 + BIRIM_COST_2) AS TOPLAM_ALIS_IADE_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_INV_PURCHASE
				WHERE
					PROCESS_TYPE = 62
				GROUP BY
					#ALAN_ADI#
				ORDER BY
					#ALAN_ADI#
			</cfquery>
		</cfif>
		<!---depo-lokasyon secili, islem tiplerinde de ithal mal girişi secili ise ithal mal girişi ayrı bölümde gosterilir.--->
		<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,17)>
			<cfquery name="get_ithal_mal_girisi_total" dbtype="query">
				SELECT 
					SUM(STOCK_IN) AS ITHAL_MAL_GIRIS_MIKTARI,
					SUM(STOCK_IN*MALIYET) AS ITHAL_MAL_GIRIS_MALIYETI,
					SUM(STOCK_OUT) AS ITHAL_MAL_CIKIS_MIKTARI,
					SUM(STOCK_OUT*MALIYET) AS ITHAL_MAL_CIKIS_MALIYETI,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(STOCK_IN*MALIYET_2) AS ITHAL_MAL_GIRIS_MALIYETI_2,
					SUM(STOCK_OUT*MALIYET_2) AS ITHAL_MAL_CIKIS_MALIYETI_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_SHIP_ROWS
				WHERE
					ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
					AND PROCESS_TYPE = 811
				GROUP BY
					#ALAN_ADI#
				ORDER BY
					#ALAN_ADI# 
			</cfquery>
		</cfif>
		<!---depo-lokasyon secili, islem tiplerinde de depo sevk secili ise sevk irs. ayrı bölümde gosterilir.--->
		<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
			<cfquery name="get_sevk_irs_total" dbtype="query">
				SELECT 
					SUM(STOCK_IN) AS SEVK_GIRIS_MIKTARI,
					SUM(STOCK_IN*MALIYET) AS SEVK_GIRIS_MALIYETI,
					SUM(STOCK_OUT) AS SEVK_CIKIS_MIKTARI,
					SUM(STOCK_OUT*MALIYET) AS SEVK_CIKIS_MALIYETI,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(STOCK_IN*MALIYET_2) AS SEVK_GIRIS_MALIYETI_2,
					SUM(STOCK_OUT*MALIYET_2) AS SEVK_CIKIS_MALIYETI_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_SHIP_ROWS
				WHERE
					ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
					AND PROCESS_TYPE = 81
				GROUP BY
					#ALAN_ADI#
				ORDER BY
					#ALAN_ADI# 
			</cfquery>
		</cfif>
		<cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
		<cfif isdefined('attributes.from_invoice_actions')>
			<cfquery name="d_fatura_satis_tutar" dbtype="query">
				SELECT	
					SUM(BIRIM_COST) AS FATURA_SATIS_TUTAR,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(BIRIM_COST_2) AS FATURA_SATIS_TUTAR_2,
					</cfif>
					SUM(AMOUNT) AS FATURA_SATIS_MIKTAR,
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_INV_PURCHASE
				WHERE
					PROCESS_TYPE IN (52,53,531) 
				GROUP BY
					#ALAN_ADI#
				ORDER BY
					#ALAN_ADI# 
			</cfquery>
			<cfquery name="d_fatura_satis_iade_tutar" dbtype="query">
				SELECT	
					SUM(BIRIM_COST) AS FATURA_SATIS_IADE_TUTAR,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(BIRIM_COST_2) AS FATURA_SATIS_IADE_TUTAR_2,
					</cfif>
					SUM(AMOUNT) AS FATURA_SATIS_IADE_MIKTAR,
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_INV_PURCHASE
				WHERE
					PROCESS_TYPE IN (54,55) 
				GROUP BY
					#ALAN_ADI#
				ORDER BY
					#ALAN_ADI# 
			</cfquery>
		</cfif>
		<!--- Mal Satıs İrsaliyelerindeki toplam miktar (Alış iadeler ve Sevkıyatta Birleştirilen ürünler olmayacak)--->
			<cfquery name="d_satis" dbtype="query">
				SELECT	
					SUM(AMOUNT) AS TOPLAM_SATIS,
					SUM(TOTAL_COST) AS TOPLAM_SATIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_2) AS TOPLAM_SATIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE IN (70,71)
				GROUP BY
					#ALAN_ADI#
				ORDER BY 
					#ALAN_ADI#
			</cfquery>
			<cfquery name="d_satis_iade" dbtype="query">
				SELECT	
					SUM(AMOUNT) AS TOPLAM_SATIS_IADE,
					SUM(TOTAL_COST) AS TOP_SAT_IADE_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_2) AS TOP_SAT_IADE_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE IN (73,74)
					OR INVOICE_CAT IN (54,55)
				GROUP BY
					#ALAN_ADI#
				ORDER BY 
					#ALAN_ADI#
			</cfquery>
		</cfif>
		<!--- giden konsinye --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
			<cfquery name="konsinye_cikis" dbtype="query">
				SELECT	
					SUM(AMOUNT) AS KONS_CIKIS_MIKTAR,
					SUM(TOTAL_COST) AS KONS_CIKIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_2) AS KONS_CIKIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 72
				GROUP BY
					#ALAN_ADI#
				ORDER BY 
					#ALAN_ADI#
			</cfquery>
		</cfif>
		<!--- iade gelen konsinye --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
			<cfquery name="konsinye_iade" dbtype="query">
				SELECT	
					SUM(AMOUNT) AS KONS_IADE_MIKTAR,
					SUM(TOTAL_COST) AS KONS_IADE_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_2) AS KONS_IADE_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 75
				GROUP BY
					#ALAN_ADI#
				ORDER BY 
					#ALAN_ADI#
			</cfquery>
		</cfif>
		<!--- konsinye giris--->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
			<cfquery name="konsinye_giris" dbtype="query">
				SELECT	
					SUM(AMOUNT) AS KONS_GIRIS_MIKTAR,
					SUM(TOTAL_COST) AS KONS_GIRIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_2) AS KONS_GIRIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 77
				GROUP BY
					#ALAN_ADI#
				ORDER BY 
					#ALAN_ADI#
			</cfquery>
		</cfif>
		<!--- konsinye giris iade--->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
			<cfquery name="konsinye_giris_iade" dbtype="query">
				SELECT	
					SUM(AMOUNT) AS KONS_GIRIS_IADE_MIKTAR,
					SUM(TOTAL_COST) AS KONS_GIRIS_IADE_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_2) AS KONS_GIRIS_IADE_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 79
				GROUP BY
					#ALAN_ADI#
				ORDER BY 
					#ALAN_ADI#
			</cfquery>
		</cfif>
		<!--- Teknik Servis Giriş --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,8)>
			<cfquery name="servis_giris" dbtype="query">
				SELECT	
					SUM(AMOUNT) AS SERVIS_GIRIS_MIKTAR,
					SUM(TOTAL_COST) AS SERVIS_GIRIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST) AS SERVIS_GIRIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 140
				GROUP BY
					#ALAN_ADI#
				ORDER BY 
					#ALAN_ADI#
			</cfquery>
		</cfif>
		<!--- Teknik Servis Çıkıs --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
			<cfquery name="servis_cikis" dbtype="query">
				SELECT	
					SUM(AMOUNT) AS SERVIS_CIKIS_MIKTAR,
					SUM(TOTAL_COST) AS SERVIS_CIKIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_2) AS SERVIS_CIKIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 141
				GROUP BY
					#ALAN_ADI#
				ORDER BY 
					#ALAN_ADI#
			</cfquery>
		</cfif>
		<!--- RMA Giriş --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
			<cfquery name="rma_giris" dbtype="query">
				SELECT	
					SUM(AMOUNT) AS RMA_GIRIS_MIKTAR,
					SUM(TOTAL_COST) AS RMA_GIRIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_2) AS RMA_GIRIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 86
				GROUP BY
					#ALAN_ADI#
				ORDER BY 
					#ALAN_ADI#
			</cfquery>
		</cfif>
		<!--- RMA Çıkış --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
			<cfquery name="rma_cikis" dbtype="query">
				SELECT	
					SUM(AMOUNT) AS RMA_CIKIS_MIKTAR,
					SUM(TOTAL_COST) AS RMA_CIKIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_2) AS RMA_CIKIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 85
				GROUP BY
					#ALAN_ADI#
				ORDER BY 
					#ALAN_ADI#
			</cfquery>
		</cfif>
		<!--- donemici uretim --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
			<cfquery name="donemici_uretim" dbtype="query">
				SELECT	
					SUM(AMOUNT) AS TOPLAM_URETIM,
					SUM(TOTAL_COST_PRICE+TOTAL_EXTRA_COST) AS URETIM_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_PRICE_2+TOTAL_EXTRA_COST_2) AS URETIM_MALIYET_2,
					</cfif>
					<!--- SUM(MALIYET*AMOUNT) AS URETIM_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(MALIYET_2*AMOUNT) AS URETIM_MALIYET_2,
					</cfif> --->
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_STOCK_FIS
				WHERE
					ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
					AND PROCESS_TYPE = 110
					<cfif isdefined('process_cat_list') and len(process_cat_list)>
					AND PROCESS_CAT  IN (#process_cat_list#)
					</cfif>
				GROUP BY
					#ALAN_ADI#		
				ORDER BY
					#ALAN_ADI#			
			</cfquery>
		</cfif>
		<cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
			<cfquery name="donemici_masraf" dbtype="query"> <!--- uretimle ilgisi olmayan sarflar --->
				SELECT	
					SUM(AMOUNT) AS TOPLAM_MASRAF_MIKTAR,
					SUM(MALIYET*AMOUNT) AS MASRAF_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(MALIYET_2*AMOUNT) AS MASRAF_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI			
				FROM
					GET_EXPENSE
				WHERE
					ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
				GROUP BY
					#ALAN_ADI#			
				ORDER BY
					#ALAN_ADI#			
			</cfquery>
		</cfif>
		<!---depo-lokasyon secili, islem tiplerinde de ambar fişi secili ise fişler ayrı bölümde gosterilir.--->
		<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
			<cfquery name="get_ambar_fis_total_in" dbtype="query">
				SELECT 
					SUM(STOCK_IN) AS AMBAR_FIS_GIRIS_MIKTARI,
					SUM(STOCK_IN*MALIYET) AS AMBAR_FIS_GIRIS_MALIYETI,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(STOCK_IN*MALIYET_2) AS AMBAR_FIS_GIRIS_MALIYETI_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_STOCK_FIS
				WHERE
					ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
					AND PROCESS_TYPE = 113
					<cfif len(attributes.department_id)>
					AND(
						DEPARTMENT_IN IS NOT NULL AND
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(DEPARTMENT_IN  = #listfirst(dept_i,'-')# AND LOCATION_IN = #listlast(dept_i,'-')#)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
						</cfloop>  
					)
					</cfif>
				GROUP BY
					#ALAN_ADI#
				ORDER BY
					#ALAN_ADI# 
			</cfquery>
			<cfquery name="get_ambar_fis_total_out" dbtype="query">
				SELECT 
					SUM(STOCK_OUT) AS AMBAR_FIS_CIKIS_MIKTARI,
					SUM(STOCK_OUT*MALIYET) AS AMBAR_FIS_CIKIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(STOCK_OUT*MALIYET_2) AS AMBAR_FIS_CIKIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_STOCK_FIS
				WHERE
					ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
					AND PROCESS_TYPE = 113
					<cfif len(attributes.department_id)>
					AND(
						DEPARTMENT_OUT IS NOT NULL AND
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(DEPARTMENT_OUT  = #listfirst(dept_i,'-')# AND LOCATION_OUT = #listlast(dept_i,'-')#)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
						</cfloop>  
					)
					</cfif>
				GROUP BY
					#ALAN_ADI#
				ORDER BY
					#ALAN_ADI# 
			</cfquery>
		</cfif>

		<!--- donemici sarf --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
			<cfquery name="donemici_sarf" dbtype="query"> <!--- uretimle ilgisi olmayan sarflar --->
				SELECT	
					SUM(AMOUNT) AS TOPLAM_SARF,
					SUM(MALIYET*AMOUNT) AS SARF_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(MALIYET_2*AMOUNT) AS SARF_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI			
				FROM
					GET_STOCK_FIS
				WHERE
					ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
					AND PROCESS_TYPE = 111
					<cfif isdefined('process_cat_list') and len(process_cat_list)>
					AND PROCESS_CAT  IN (#process_cat_list#)
					</cfif>
					AND PROD_ORDER_NUMBER=0
					AND PROD_ORDER_RESULT_NUMBER=0
				GROUP BY
					#ALAN_ADI#			
				ORDER BY
					#ALAN_ADI#			
			</cfquery>
			<cfquery name="donemici_production_sarf" dbtype="query"> <!--- üretim sarfları--->
				SELECT	
					SUM(AMOUNT) AS TOPLAM_URETIM_SARF,
					SUM(MALIYET*AMOUNT) AS URETIM_SARF_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(MALIYET_2*AMOUNT) AS URETIM_SARF_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI			
				FROM
					GET_STOCK_FIS
				WHERE
					ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
					AND PROCESS_TYPE = 111
					<cfif isdefined('process_cat_list') and len(process_cat_list)>
					AND PROCESS_CAT  IN (#process_cat_list#)
					</cfif>
					AND PROD_ORDER_NUMBER <> 0
				GROUP BY
					#ALAN_ADI#			
				ORDER BY
					#ALAN_ADI#			
			</cfquery>
		<!--- donemici fire --->
			<cfquery name="donemici_fire" dbtype="query">
				SELECT	
					SUM(AMOUNT) AS TOPLAM_FIRE,
					SUM(MALIYET*AMOUNT) AS FIRE_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(MALIYET_2*AMOUNT) AS FIRE_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI			
				FROM
					GET_STOCK_FIS
				WHERE
					ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
					AND PROCESS_TYPE =112
					<cfif isdefined('process_cat_list') and len(process_cat_list)>
					AND PROCESS_CAT  IN (#process_cat_list#)
					</cfif>
				GROUP BY
					#ALAN_ADI#			
				ORDER BY
					#ALAN_ADI#			
			</cfquery>
		</cfif>
		<!--- demontajdan giris --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
			<cfquery name="donemici_demontaj_giris" dbtype="query">
				SELECT	
					SUM(AMOUNT) AS DEMONTAJ_GIRIS,
					SUM(MALIYET*AMOUNT) AS DEMONTAJ_GIRIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(MALIYET_2*AMOUNT) AS DEMONTAJ_GIRIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI			
				FROM
					GET_STOCK_FIS
				WHERE
					ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
					AND PROCESS_TYPE = 119
					<cfif isdefined('process_cat_list') and len(process_cat_list)>
					AND PROCESS_CAT  IN (#process_cat_list#)
					</cfif>
				GROUP BY
					#ALAN_ADI#			
				ORDER BY
					#ALAN_ADI#			
			</cfquery>
		</cfif>
		<!--- demontaja giden --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
			<cfquery name="demontaj_giden" dbtype="query">
				SELECT	
					(SUM(STOCK_IN)-SUM(STOCK_OUT)) AS DEMONTAJ_GIDEN,
					SUM((STOCK_IN-STOCK_OUT)*MALIYET) AS DEMONTAJ_GIDEN_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM((STOCK_IN-STOCK_OUT)*MALIYET_2) AS DEMONTAJ_GIDEN_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI			
				FROM
					GET_DEMONTAJ
				WHERE
					ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
				GROUP BY
					#ALAN_ADI#			
				ORDER BY
					#ALAN_ADI#			
			</cfquery>
		</cfif>
		<!--- Sayım fişleri --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
			<cfquery name="donemici_sayim" dbtype="query">
				SELECT
					SUM(AMOUNT) AS TOPLAM_SAYIM,
					SUM(MALIYET*AMOUNT) AS SAYIM_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(MALIYET_2*AMOUNT) AS SAYIM_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI			
				FROM
					GET_STOCK_FIS
				WHERE
					ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
					AND PROCESS_TYPE =115
					<!--- <cfif isdefined('process_cat_list') and len(process_cat_list)>
					AND PROCESS_CAT  IN (#process_cat_list#)
					</cfif> --->
				GROUP BY
					#ALAN_ADI#			
				ORDER BY
					#ALAN_ADI#			
			</cfquery>
		</cfif>
	</cfif>
	<cfif GET_DS_SPEC_COST.recordcount>
		<cfquery name="DONEM_SONU_SPEC_COST" dbtype="query">
			SELECT 
				SUM(PRODUCT_STOCK*MALIYET) AS DONEM_SONU_COST,
				<cfif isdefined('attributes.is_system_money_2')>
				SUM(PRODUCT_STOCK*MALIYET_2) AS DONEM_SONU_COST_2,
				</cfif>
				SUM(PRODUCT_STOCK) AS DONEM_SONU_STOCK,
				#ALAN_ADI# AS GROUPBY_ALANI
			FROM
				GET_DS_SPEC_COST
			GROUP BY
				#ALAN_ADI#
			ORDER BY 
				#ALAN_ADI#
		</cfquery>
	</cfif>
	<cfif DB_SPEC_COST.recordcount>
		<cfquery name="DONEM_BASI_SPEC_COST" dbtype="query">
			SELECT 
				SUM(DB_PRODUCT_MALIYET*DB_PRODUCT_STOCK) AS DONEM_BASI_COST,
				<cfif isdefined('attributes.is_system_money_2')>
				SUM(DB_PRODUCT_MALIYET_2*DB_PRODUCT_STOCK) AS DONEM_BASI_COST_2,
				</cfif>
				SUM(DB_PRODUCT_STOCK) AS DONEM_BASI_STOCK,
				#ALAN_ADI# AS GROUPBY_ALANI
			FROM
				DB_SPEC_COST
			GROUP BY
				#ALAN_ADI#
			ORDER BY 
				#ALAN_ADI#
		</cfquery>	
	</cfif>
	<cfif GET_ALL_STOCK.recordcount>
		<cfif isdefined('attributes.is_excel')>
			<cfset filename = "#createuuid()#">
				<cfheader name="Expires" value="#Now()#">
				<cfcontent type="application/vnd.msexcel;charset=utf-8">
				<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
				<meta http-equiv="content-type" content="text/plain; charset=utf-8">
		</cfif>
		<cfif listfind('3,4,5,6', attributes.report_type)>
			<cfquery name="GET_PROD_CATS" dbtype="query">
				SELECT DISTINCT PRODUCT_GROUPBY_ID,ACIKLAMA FROM GET_ALL_STOCK
			</cfquery>
			<cfset attributes.totalrecords='#GET_PROD_CATS.recordcount#'>
			<cfoutput query="GET_ALL_STOCK" group="PRODUCT_GROUPBY_ID">
				<cfoutput>
					<cfscript>
						//specli urunler icin donem sonu miktar ve maliyetleri set ediliyor
						if(isdefined('DONEM_SONU_SPEC_COST') and (DONEM_SONU_SPEC_COST.recordcount gt 0) )
						{
							for(tyy=1; tyy lte DONEM_SONU_SPEC_COST.recordcount; tyy=tyy+1)
							{
								if(DONEM_SONU_SPEC_COST.GROUPBY_ALANI[tyy] eq GET_ALL_STOCK.PRODUCT_ID) 
								{
									'donem_sonu_specli_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = DONEM_SONU_SPEC_COST.DONEM_SONU_COST[tyy];
									if(isdefined('attributes.is_system_money_2'))
										'donem_sonu_specli_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = DONEM_SONU_SPEC_COST.DONEM_SONU_COST_2[tyy];
									break;
								}
							}
						}
					
						if( (GET_ALL_STOCK.currentrow eq 1) or (GET_ALL_STOCK.PRODUCT_GROUPBY_ID[currentrow] neq GET_ALL_STOCK.PRODUCT_GROUPBY_ID[currentrow-1]) )
						{
							'prod_cat_total_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#'=0;
							'prod_cat_cost_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#'=0;
							'prod_cat_cost2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#'=0; //sistem 2.para br karsılıgı
						}
											
						for(tt=1; tt lte get_total_stok.recordcount; tt=tt+1)
						{
							if( get_total_stok.GROUPBY_ALANI[tt] eq GET_ALL_STOCK.PRODUCT_ID) 
							{
								'donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#' = get_total_stok.TOTAL_STOCK[tt];
								break;
							}
						}
						if(isdefined('donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#') and len(evaluate('donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#')))
						{
							donem_sonu_maliyet3=0;
							'prod_cat_total_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#'=( evaluate('prod_cat_total_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#')+ evaluate('donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#') );
							if(isdefined('attributes.display_cost'))
							{
								if (GET_ALL_STOCK.IS_PRODUCTION eq 1)
								{
									if(isdefined("donem_sonu_specli_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#") and len(evaluate("donem_sonu_specli_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#")))
										donem_sonu_maliyet3=evaluate("donem_sonu_specli_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#");
									if(isdefined("donem_sonu_specli_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#") and len(evaluate("donem_sonu_specli_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#")))
										ds_other_cost=evaluate("donem_sonu_specli_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#");
								}
								else
								{
									db_maliyet3 = produc_cost_func(cost_product_id:GET_ALL_STOCK.PRODUCT_ID,cost_date:finish_date);
									donem_sonu_maliyet3=wrk_round(evaluate('donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#')*( db_maliyet3.PURCHASE_NET_SYSTEM + db_maliyet3.PURCHASE_EXTRA_COST_SYSTEM));

									if(isdefined('attributes.is_system_money_2') )
										ds_other_cost=wrk_round(evaluate('donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#')*( db_maliyet3.PURCHASE_NET_SYSTEM_2 + db_maliyet3.PURCHASE_EXTRA_COST_SYSTEM_2));
								}
								if(isdefined('donem_sonu_maliyet3') and  donem_sonu_maliyet3 neq 0)
								{
									'prod_cat_cost_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = (evaluate('prod_cat_cost_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#')+donem_sonu_maliyet3);
								}
								if(isdefined('ds_other_cost') and  ds_other_cost neq 0)
									'prod_cat_cost2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = (evaluate('prod_cat_cost2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#')+ds_other_cost);
							}
						}
					</cfscript>
				</cfoutput>
			</cfoutput>
		<cfelse>
			<cfif isdefined('attributes.is_excel')>
				<cfset attributes.startrow=1>
				<cfset attributes.maxrows=GET_ALL_STOCK.recordcount>
			</cfif>
			<cfoutput query="GET_ALL_STOCK" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfscript>
				//specli urunler icin donem sonu miktar ve maliyetleri set ediliyor
				if(isdefined('DONEM_SONU_SPEC_COST') and (DONEM_SONU_SPEC_COST.recordcount gt 0) )
				{
					for(tyy=1; tyy lte DONEM_SONU_SPEC_COST.recordcount; tyy=tyy+1)
					{
						if(DONEM_SONU_SPEC_COST.GROUPBY_ALANI[tyy] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
						{
							'donem_sonu_specli_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = DONEM_SONU_SPEC_COST.DONEM_SONU_STOCK[tyy];
							'donem_sonu_specli_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = DONEM_SONU_SPEC_COST.DONEM_SONU_COST[tyy];
							if(isdefined('attributes.is_system_money_2'))
								'donem_sonu_specli_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = DONEM_SONU_SPEC_COST.DONEM_SONU_COST_2[tyy];
							break;
						}
					}
				}
				//specli urunler icin donem basi miktar ve maliyetleri set ediliyor
				if(isdefined('DONEM_BASI_SPEC_COST') and (DONEM_BASI_SPEC_COST.recordcount gt 0) )
				{
					for(tyy=1; tyy lte DONEM_BASI_SPEC_COST.recordcount; tyy=tyy+1)
					{
						if(DONEM_BASI_SPEC_COST.GROUPBY_ALANI[tyy] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
						{
							'donem_basi_specli_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = DONEM_BASI_SPEC_COST.DONEM_BASI_STOCK[tyy];
							'donem_basi_specli_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = DONEM_BASI_SPEC_COST.DONEM_BASI_COST[tyy];
							if(isdefined('attributes.is_system_money_2'))
								'donem_basi_specli_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = DONEM_BASI_SPEC_COST.DONEM_BASI_COST_2[tyy];
							break;
						}
					}
				}
				if(GET_STOCK_ROWS.recordcount neq 0)
				{
					//donem bası toplam stok miktarı set ediliyor
					if(isdefined('acilis_stok2') and (acilis_stok2.recordcount gt 0) )
					{
						for(i=1;i lte acilis_stok2.recordcount;i=i+1)
						{
						if( acilis_stok2.GROUPBY_ALANI[i] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'acilis_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = acilis_stok2.DB_STOK_MIKTAR[i];
								//'acilis_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = acilis_stok2.DB_STOK_MALIYET[i];
								break;
							}
						}
					}
					//donem sonu stok miktar ve maliyetleri set ediliyor
					for(tt=1; tt lte get_total_stok.recordcount; tt=tt+1)
					{
						if( get_total_stok.GROUPBY_ALANI[tt] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
						{
							'donem_sonu_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_total_stok.TOTAL_STOCK[tt];
							//'ds_urun_maliyeti_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_total_stok.TOTAL_PRODUCT_COST[tt];
							break;
						}
					}
				
					if(len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16) )
					{
						//donem ici sevk irs miktar ve maliyetleri set ediliyor
						for(s2=1; s2 lte get_sevk_irs_total.recordcount; s2=s2+1)
						{
							if( get_sevk_irs_total.GROUPBY_ALANI[s2] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'sevk_giris_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_sevk_irs_total.SEVK_GIRIS_MIKTARI[s2];
								'sevk_cikis_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_sevk_irs_total.SEVK_CIKIS_MIKTARI[s2];
								'sevk_giris_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_sevk_irs_total.SEVK_GIRIS_MALIYETI[s2];
								'sevk_cikis_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_sevk_irs_total.SEVK_CIKIS_MALIYETI[s2];
								if(isdefined('attributes.is_system_money_2'))
								{
									'sevk_giris_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_sevk_irs_total.SEVK_GIRIS_MALIYETI_2[s2];
									'sevk_cikis_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_sevk_irs_total.SEVK_CIKIS_MALIYETI_2[s2];
								}
								break;
							}
						}
					}
	
					if(len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,17) )
					{
						//donem ici sevk irs miktar ve maliyetleri set ediliyor
						for(s3=1; s3 lte get_ithal_mal_girisi_total.recordcount; s3=s3+1)
						{
							if( get_ithal_mal_girisi_total.GROUPBY_ALANI[s3] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'ithal_mal_giris_miktari_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_ithal_mal_girisi_total.ITHAL_MAL_GIRIS_MIKTARI[s3];
								'ithal_mal_cikis_miktari_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_ithal_mal_girisi_total.ITHAL_MAL_CIKIS_MIKTARI[s3];
								'ithal_mal_giris_maliyeti_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_ithal_mal_girisi_total.ITHAL_MAL_GIRIS_MALIYETI[s3];
								'ithal_mal_cikis_maliyeti_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_ithal_mal_girisi_total.ITHAL_MAL_CIKIS_MALIYETI[s3];
								if(isdefined('attributes.is_system_money_2'))
								{
									'ithal_mal_giris_maliyeti2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_ithal_mal_girisi_total.ITHAL_MAL_GIRIS_MALIYETI_2[s3];
									'ithal_mal_cikis_maliyeti2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_ithal_mal_girisi_total.ITHAL_MAL_CIKIS_MALIYETI_2[s3];
								}
								break;
							}
						}
					}
					if(len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18) )
					{
						//donem ici sevk irs miktar ve maliyetleri set ediliyor
						for(s4=1; s4 lte get_ambar_fis_total_in.recordcount; s4=s4+1)
						{
							if( get_ambar_fis_total_in.GROUPBY_ALANI[s4] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'ambar_fis_giris_miktari_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_ambar_fis_total_in.AMBAR_FIS_GIRIS_MIKTARI[s4];
								'ambar_fis_giris_maliyeti_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_ambar_fis_total_in.AMBAR_FIS_GIRIS_MALIYETI[s4];
								if(isdefined('attributes.is_system_money_2'))
									'ambar_fis_giris_maliyeti2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_ambar_fis_total_in.AMBAR_FIS_GIRIS_MALIYETI_2[s4];
								break;
							}
						}
						
						for(s5=1; s5 lte get_ambar_fis_total_out.recordcount; s5=s5+1)
						{
							if( get_ambar_fis_total_out.GROUPBY_ALANI[s5] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'ambar_fis_cikis_miktari_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_ambar_fis_total_out.AMBAR_FIS_CIKIS_MIKTARI[s5];
								'ambar_fis_cikis_maliyeti_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_ambar_fis_total_out.AMBAR_FIS_CIKIS_MALIYET[s5];
								if(isdefined('attributes.is_system_money_2'))
									'ambar_fis_cikis_maliyeti2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_ambar_fis_total_out.AMBAR_FIS_CIKIS_MALIYET_2[s5];
								break;
							}
						}
						
						
					}
				}
				if( len(attributes.process_type) and listfind(attributes.process_type,6))
				{
					//konsinye cikis irs miktar ve maliyetleri
					for(kons=1; kons lte konsinye_cikis.recordcount; kons=kons+1)
					{
						if( konsinye_cikis.GROUPBY_ALANI[kons] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
						{
							'kons_cikis_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = konsinye_cikis.KONS_CIKIS_MIKTAR[kons];
							'kons_cikis_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = konsinye_cikis.KONS_CIKIS_MALIYET[kons];
							if(isdefined('attributes.is_system_money_2'))
								'kons_cikis_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = konsinye_cikis.KONS_CIKIS_MALIYET_2[kons];
							break;
						}
					}
				}
				if( len(attributes.process_type) and listfind(attributes.process_type,7))
				{
					//konsinye iade irs miktar ve maliyetleri
					for(kons_i=1; kons_i lte konsinye_iade.recordcount; kons_i=kons_i+1)
					{
						if(konsinye_iade.GROUPBY_ALANI[kons_i] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
						{
							'kons_iade_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = konsinye_iade.KONS_IADE_MIKTAR[kons_i];
							'kons_iade_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = konsinye_iade.KONS_IADE_MALIYET[kons_i];
							if(isdefined('attributes.is_system_money_2'))
								'kons_iade_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = konsinye_iade.KONS_IADE_MALIYET_2[kons_i];
							break;
						}
					}
				}
				if( len(attributes.process_type) and listfind(attributes.process_type,19))			
				{
					//konsinye giriş irs.
					for(kons_g=1; kons_g lte konsinye_giris.recordcount; kons_g=kons_g+1)
					{
						if(konsinye_giris.GROUPBY_ALANI[kons_g] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
						{
							'konsinye_giris_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = konsinye_giris.KONS_GIRIS_MIKTAR[kons_g];
							'konsinye_giris_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = konsinye_giris.KONS_GIRIS_MALIYET[kons_g];
							if(isdefined('attributes.is_system_money_2'))
								'konsinye_giris_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = konsinye_giris.KONS_GIRIS_MALIYET_2[kons_g];
							break;
						}
					}
				}
				if( len(attributes.process_type) and listfind(attributes.process_type,20))			
				{
					//konsinye giriş iade irs.
					for(kons_gi=1; kons_gi lte konsinye_giris_iade.recordcount; kons_gi=kons_gi+1)
					{
						if(konsinye_giris_iade.GROUPBY_ALANI[kons_gi] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
						{
							'kons_giris_iade_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = konsinye_giris_iade.KONS_GIRIS_IADE_MIKTAR[kons_gi];
							'kons_giris_iade_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = konsinye_giris_iade.KONS_GIRIS_IADE_MALIYET[kons_gi];
							if(isdefined('attributes.is_system_money_2'))
								'kons_giris_iade_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = konsinye_giris_iade.KONS_GIRIS_IADE_MALIYET_2[kons_gi];
							break;
						}
					}
				}
				if( len(attributes.process_type) and listfind(attributes.process_type,8))			
				{
					//teknik servis giris irs.
					for(ser_i=1; ser_i lte servis_giris.recordcount; ser_i=ser_i+1)
					{
						if(servis_giris.GROUPBY_ALANI[ser_i] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
						{
							'servis_giris_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = servis_giris.SERVIS_GIRIS_MIKTAR[ser_i];
							'servis_giris_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = servis_giris.SERVIS_GIRIS_MALIYET[ser_i];
							if(isdefined('attributes.is_system_money_2'))
								'servis_giris_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = servis_giris.SERVIS_GIRIS_MALIYET_2[ser_i];
							break;
						}
					}
				}
				
				if( len(attributes.process_type) and listfind(attributes.process_type,9))
				{
					//teknik servis cikis irs.
					for(kkk=1; kkk lte servis_cikis.recordcount; kkk=kkk+1)
					{
						if(servis_cikis.GROUPBY_ALANI[kkk] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
						{
							'servis_cikis_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = servis_cikis.SERVIS_CIKIS_MIKTAR[kkk];
							'servis_cikis_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = servis_cikis.SERVIS_CIKIS_MALIYET[kkk];
							if(isdefined('attributes.is_system_money_2'))
								'servis_cikis_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = servis_cikis.SERVIS_CIKIS_MALIYET_2[kkk];
							break;
						}
					}
				}
				if(len(attributes.process_type) and listfind(attributes.process_type,10))
				{
					//RMA Çıkış
					for(ttt=1; ttt lte rma_cikis.recordcount; ttt=ttt+1)
					{
						if(rma_cikis.GROUPBY_ALANI[ttt] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
						{
							'rma_cikis_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = rma_cikis.RMA_CIKIS_MIKTAR[ttt];
							'rma_cikis_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = rma_cikis.RMA_CIKIS_MALIYET[ttt];
							if(isdefined('attributes.is_system_money_2'))
								'rma_cikis_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = rma_cikis.RMA_CIKIS_MALIYET_2[ttt];
							break;
						}
					}
				}
				if(len(attributes.process_type) and listfind(attributes.process_type,11))
				{
					//RMA Giriş
					for(ffg=1; ffg lte rma_giris.recordcount; ffg=ffg+1)
					{
						if(rma_giris.GROUPBY_ALANI[ffg] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
						{
							'rma_giris_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = rma_giris.RMA_GIRIS_MIKTAR[ffg];
							'rma_giris_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = rma_giris.RMA_GIRIS_MALIYET[ffg];
							if(isdefined('attributes.is_system_money_2'))
								'rma_giris_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = rma_giris.RMA_GIRIS_MALIYET_2[ffg];
							break;
						}
					}
				}
				if( len(attributes.process_type) and listfind(attributes.process_type,2))
				{
					//donem içi alış miktarları set ediliyor (irsaliyeden)
					for(irs_m=1; irs_m lte d_alis_miktar.recordcount; irs_m=irs_m+1)
					{
						if(d_alis_miktar.GROUPBY_ALANI[irs_m] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
						{
							'alis_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_alis_miktar.TOPLAM_ALIS[irs_m];
							break;
						}
					}
					//donem ici toplam alis tutarları set ediliyor (faturadan)
					for(j=1;j lte d_alis_tutar.recordcount;j=j+1)
					{
						if(d_alis_tutar.GROUPBY_ALANI[j] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
						{
							'alis_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_alis_tutar.TOPLAM_ALIS_MALIYET[j];
							'alis_fat_tutar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#'= d_alis_tutar.TOPLAM_ALIS_TUTAR[j];
							if(isdefined('attributes.is_system_money_2'))
							{
								'alis_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_alis_tutar.TOPLAM_ALIS_MALIYET_2[j];
								'alis_fat_tutar2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#'= d_alis_tutar.TOPLAM_ALIS_TUTAR_2[j];
							}
							break;
						}
					}
					//donem içi alış iade miktarları set ediliyor (irsaliyeden)
					for(iade_m=1; iade_m lte d_alis_iade_miktar.recordcount; iade_m=iade_m+1)
					{
						if(d_alis_iade_miktar.GROUPBY_ALANI[iade_m] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
						{
							'alis_iade_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_alis_iade_miktar.TOPLAM_ALIS_IADE[iade_m];
							break;
						}
					}
					//donem ici toplam alıs iade tutarları set ediliyor (faturadan)
					for(m=1; m lte d_alis_iade_tutar.recordcount; m=m+1)
					{
						if(d_alis_iade_tutar.GROUPBY_ALANI[m] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
						{
							'alis_iade_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_alis_iade_tutar.TOPLAM_ALIS_IADE_MALIYET[m];
							if(isdefined('attributes.is_system_money_2'))
								'alis_iade_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_alis_iade_tutar.TOPLAM_ALIS_IADE_MALIYET_2[m];
							break;
						}
					}
				}
				if( len(attributes.process_type) and listfind(attributes.process_type,3))
				{
					if(isdefined('attributes.from_invoice_actions'))/*faturadan hesapla secilmisse, satıs hareketleri fatura tutarlarından getiriliyor*/
					{
						for(inv_k=1; inv_k lte d_fatura_satis_tutar.recordcount; inv_k=inv_k+1)
						{
							if(d_fatura_satis_tutar.GROUPBY_ALANI[inv_k] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
							{
								'fatura_satis_tutar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_fatura_satis_tutar.FATURA_SATIS_TUTAR[inv_k];
								if(isdefined('attributes.is_system_money_2'))
									'fatura_satis_tutar2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_fatura_satis_tutar.FATURA_SATIS_TUTAR_2[inv_k];
								'fatura_satis_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_fatura_satis_tutar.FATURA_SATIS_MIKTAR[inv_k];
								break;
							}
						}
						for(inv_t=1; inv_t lte d_fatura_satis_iade_tutar.recordcount; inv_t=inv_t+1)
						{
							if(d_fatura_satis_iade_tutar.GROUPBY_ALANI[inv_t] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
							{
								'fatura_satis_iade_tutar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_TUTAR[inv_t];
								if(isdefined('attributes.is_system_money_2'))
									'fatura_satis_iade_tutar2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_TUTAR_2[inv_t];
								'fatura_satis_iade_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_MIKTAR[inv_t];
								break;
							}
						}
					}
					//donem ici toplam satıs miktarları set ediliyor
					for(k=1; k lte d_satis.recordcount; k=k+1)
					{
						if(d_satis.GROUPBY_ALANI[k] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
						{
							'satis_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_satis.TOPLAM_SATIS[k];
							'satis_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_satis.TOPLAM_SATIS_MALIYET[k];
							if(isdefined('attributes.is_system_money_2'))
								'satis_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_satis.TOPLAM_SATIS_MALIYET_2[k];
							break;
						}
					}
					//donem ici toplam satıs iade miktarları set ediliyor
					for(n=1; n lte d_satis_iade.recordcount; n=n+1)
					{
						if(d_satis_iade.GROUPBY_ALANI[n] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
						{

							'satis_iade_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_satis_iade.TOPLAM_SATIS_IADE[n];
							'satis_iade_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_satis_iade.TOP_SAT_IADE_MALIYET[n];
							if(isdefined('attributes.is_system_money_2'))
								'satis_iade_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_satis_iade.TOP_SAT_IADE_MALIYET_2[n];
							break;
						}
					}
				}
				if(isdefined('GET_EXPENSE') and GET_EXPENSE.recordcount gt 0) //MASRAF FISLERI
				{
					if(len(attributes.process_type) and listfind(attributes.process_type,15) )
					{
						//donem ici masraf fişi miktar ve maliyetleri set ediliyor
						for(m_1=1; m_1 lte donemici_masraf.recordcount; m_1=m_1+1)
						{
							if( donemici_masraf.GROUPBY_ALANI[m_1] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'masraf_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_masraf.TOPLAM_MASRAF_MIKTAR[m_1];
								'masraf_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_masraf.MASRAF_MALIYET[m_1];
								if(isdefined('attributes.is_system_money_2'))
									'masraf_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_masraf.MASRAF_MALIYET_2[m_1];
								break;
							}
						}
					}
				}
				if(isdefined('GET_STOCK_FIS') and GET_STOCK_FIS.recordcount gt 0)
				{
					if (len(attributes.process_type) and listfind(attributes.process_type,12))
					{
						//donem ici toplam sayım fisi miktarları set ediliyor
						for(i=1;i lte donemici_sayim.recordcount;i=i+1)
						{
							if( donemici_sayim.GROUPBY_ALANI[i] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'sayim_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_sayim.TOPLAM_SAYIM[i];
								'sayim_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_sayim.SAYIM_MALIYET[i];
								if(isdefined('attributes.is_system_money_2'))
									'sayim_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_sayim.SAYIM_MALIYET_2[i];
								break;
							}
						}
					}
					if( len(attributes.process_type) and listfind(attributes.process_type,4))
					{
						//donem ici toplam uretim fisi miktarları set ediliyor
						for(t=1; t lte donemici_uretim.recordcount; t=t+1)
						{
							if( donemici_uretim.GROUPBY_ALANI[t] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'uretim_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_uretim.TOPLAM_URETIM[t];
								'uretim_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_uretim.URETIM_MALIYET[t];
								if(isdefined('attributes.is_system_money_2'))
									'uretim_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_uretim.URETIM_MALIYET_2[t];
								break;
							}
						}
					}
					if(len(attributes.process_type) and listfind(attributes.process_type,14))
					{
						//donem ici demontajdan giris
						for(dem=1; dem lte donemici_demontaj_giris.recordcount; dem=dem+1)
						{
							if( donemici_demontaj_giris.GROUPBY_ALANI[dem] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'demontaj_giris_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_demontaj_giris.DEMONTAJ_GIRIS[dem];
								'demontaj_giris_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_demontaj_giris.DEMONTAJ_GIRIS_MALIYET[dem];
								if(isdefined('attributes.is_system_money_2'))
									'demontaj_giris_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_demontaj_giris.DEMONTAJ_GIRIS_MALIYET_2[dem];
								break;
							}
						}
					}
					if(len(attributes.process_type) and listfind(attributes.process_type,13) )
					{
						//donem ici demontaja giden urun miktar ve maliyetleri set ediliyor
						for(dem2=1; dem2 lte demontaj_giden.recordcount; dem2=dem2+1)
						{
							if( demontaj_giden.GROUPBY_ALANI[dem2] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'demontaj_giden_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = demontaj_giden.DEMONTAJ_GIDEN[dem2];
								'demontaj_giden_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = demontaj_giden.DEMONTAJ_GIDEN_MALIYET[dem2];
								if(isdefined('attributes.is_system_money_2'))
									'demontaj_giden_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = demontaj_giden.DEMONTAJ_GIDEN_MALIYET_2[dem2];
								break;
							}
						}
					}
					if( len(attributes.process_type) and listfind(attributes.process_type,5))
					{
						//donem ici toplam sarf miktarları set ediliyor
						for(s=1; s lte donemici_sarf.recordcount; s=s+1)
						{
							if( donemici_sarf.GROUPBY_ALANI[s] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'sarf_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_sarf.TOPLAM_SARF[s];
								'sarf_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_sarf.SARF_MALIYET[s];
								if(isdefined('attributes.is_system_money_2'))
									'sarf_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_sarf.SARF_MALIYET_2[s];
								break;
							}
						}
						//donem ici uretimden gelen sarf miktar-tutarları set ediliyor
						for(prod_s=1; prod_s lte donemici_production_sarf.recordcount; prod_s=prod_s+1)
						{
							if( donemici_production_sarf.GROUPBY_ALANI[prod_s] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'uretim_sarf_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_production_sarf.TOPLAM_URETIM_SARF[prod_s];
								'uretim_sarf_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_production_sarf.URETIM_SARF_MALIYET[prod_s];
								if(isdefined('attributes.is_system_money_2'))
									'uretim_sarf_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_production_sarf.URETIM_SARF_MALIYET_2[prod_s];
								break;
							}
						}
						//donem ici toplam fire miktarları set ediliyor
						for(s=1; s lte donemici_fire.recordcount; s=s+1)
						{
							if( donemici_fire.GROUPBY_ALANI[s] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'fire_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_fire.TOPLAM_FIRE[s];
								'fire_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_fire.FIRE_MALIYET[s];
								if(isdefined('attributes.is_system_money_2'))
									'fire_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = donemici_fire.FIRE_MALIYET_2[s];
								break;
							}
						}
					}
				}
			</cfscript>
		</cfoutput>
		</cfif>
	</cfif>
	<cfif isdate(attributes.date)>
		<cfset attributes.date = dateformat(attributes.date, dateformat_style)>
	</cfif>
	<cfif isdate(attributes.date2)>
		<cfset attributes.date2 = dateformat(attributes.date2, dateformat_style)>
	</cfif>
</cfif>

