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
		<cfelseif len(trim(attributes.product_cat)) and len(attributes.product_code) or (len(attributes.product_code) and not isdefined("attributes.product_cat"))>
			<cfset stock_table=1>
		<cfelse>
			<cfset stock_table=0>
		</cfif>
        <cfset islem_tipi = '78,81,82,83,112,113,114,811,761,70,71,72,73,74,75,76,77,79,80,84,85,86,88,110,111,115,116,118,1182,119,140,141,811,1131'>
        <cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
            SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
        </cfquery>
		<cfquery name="GET_PERIODS_" datasource="#dsn#">
			SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID=#session.ep.company_id#
		</cfquery>
		<cfset new_period_id_list_ = valuelist(GET_PERIODS_.PERIOD_ID)>
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
		<cfset start_period_cost_date = dateformat(start_date,dateformat_style)>
		<cfset start_period_cost_date=date_add('d',-1,start_date)>
        <cfquery name="CHECK_TABLE" datasource="#DSN2#">
        	IF EXISTS(SELECT * FROM tempdb.sys.tables where name = '####GET_STOCK_ROWS_#session.ep.userid#')
           		BEGIN
                	DROP TABLE ####GET_STOCK_ROWS_#session.ep.userid#
                END
            IF EXISTS(SELECT * FROM tempdb.sys.tables where name = '####acilis_stok2_#session.ep.userid#')
           		BEGIN
                	DROP TABLE ####acilis_stok2_#session.ep.userid#
                END
            IF EXISTS(SELECT * FROM tempdb.sys.tables where name = '####get_total_stok_#session.ep.userid#')
           		BEGIN
                	DROP TABLE ####get_total_stok_#session.ep.userid#
                END
           IF EXISTS(SELECT * FROM tempdb.sys.tables where name = '####GET_STOCK_AGE_#session.ep.userid#')
                BEGIN
                    DROP TABLE ####GET_STOCK_AGE_#session.ep.userid#
                END 
            IF EXISTS(SELECT * FROM tempdb.sys.tables where name = '####GET_ALL_STOCK_#session.ep.userid#')
                BEGIN
                    DROP TABLE ####GET_ALL_STOCK_#session.ep.userid#
                END     
        </cfquery>
        <cfquery name="GET_STOCK_ROWS" datasource="#dsn2#">
			SELECT 
				SR.UPD_ID,
				S.STOCK_ID,
				S.PRODUCT_ID,
				<cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
					SR.STORE,
					SR.STORE_LOCATION,
				</cfif>
                <cfif attributes.report_type eq 9>
					SR.STORE,
				</cfif>
                <cfif attributes.report_type eq 10>
					CAST(SR.STORE AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.STORE_LOCATION,0) AS NVARCHAR(50)) STORE_LOCATION,
				</cfif>
                SR.SPECT_VAR_ID SPECT_VAR_ID,
                <cfif attributes.report_type eq 8>
                	CAST(SR.STOCK_ID AS NVARCHAR(50))+'_'+CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)) AS STOCK_SPEC_ID,
                </cfif>
				S.PRODUCT_MANAGER,
				S.PRODUCT_CATID,
				S.BRAND_ID,
				SUM(SR.STOCK_IN-SR.STOCK_OUT) AMOUNT,
				SR.PROCESS_DATE ISLEM_TARIHI,
				SR.PROCESS_TYPE,
				0 AS MALIYET
				<cfif isdefined('attributes.is_system_money_2')>
				,0 AS MALIYET_2
				</cfif>
			INTO ####GET_STOCK_ROWS_#session.ep.userid#
            FROM        
				STOCKS_ROW SR WITH (NOLOCK),
				#dsn3_alias#.STOCKS S WITH (NOLOCK),
				#dsn_alias#.STOCKS_LOCATION SL WITH (NOLOCK)
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
			GROUP BY
				SR.UPD_ID,
				S.STOCK_ID,
				S.PRODUCT_ID,
                SR.SPECT_VAR_ID,
				<cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
					SR.STORE,
					SR.STORE_LOCATION,
				</cfif>
                <cfif attributes.report_type eq 8>
                	CAST(SR.STOCK_ID AS NVARCHAR(50))+'_'+CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)),
                </cfif>
				<cfif attributes.report_type eq 9>
					SR.STORE,
				</cfif>
                <cfif attributes.report_type eq 10>
					SR.STORE,
					SR.STORE_LOCATION,
				</cfif>
				S.PRODUCT_MANAGER,
				S.PRODUCT_CATID,
				S.BRAND_ID,
				SR.PROCESS_DATE,
				SR.PROCESS_TYPE
		</cfquery>
        
        
        <cfquery name="acilis_stok2" datasource="#dsn2#">
			SELECT	
				SUM(AMOUNT) AS DB_STOK_MIKTAR,
				SUM(AMOUNT*MALIYET) AS DB_STOK_MALIYET,
				<cfif isdefined('attributes.is_system_money_2')>
				SUM(AMOUNT*MALIYET_2) AS DB_STOK_MALIYET_2,
				</cfif>
				#ALAN_ADI# AS GROUPBY_ALANI
			INTO ####acilis_stok2_#session.ep.userid#
            FROM
				(
                	SELECT * FROM ####GET_STOCK_ROWS_#session.ep.userid#
                )GET_STOCK_ROWS
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
        
        
        
        <cfquery name="get_total_stok" datasource="#dsn2#">
			SELECT 
				SUM(AMOUNT) AS TOTAL_STOCK,
				SUM(AMOUNT*MALIYET) AS TOTAL_PRODUCT_COST,
				<cfif isdefined('attributes.is_system_money_2')>
				SUM(AMOUNT*MALIYET_2) AS TOTAL_PRODUCT_COST_2,
				</cfif>
				<cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
					STORE,
					STORE_LOCATION,
				</cfif>
                <cfif attributes.report_type eq 9 or attributes.report_type eq 10>
                   PRODUCT_ID AS GROUPBY_ALANI,
                   #ALAN_ADI# AS GROUPBY_ALANI_2
				<cfelse>
                   #ALAN_ADI# AS GROUPBY_ALANI
				</cfif>
			INTO ####get_total_stok_#session.ep.userid#
            FROM
				(
                	SELECT * FROM ####GET_STOCK_ROWS_#session.ep.userid#
                )GET_STOCK_ROWS
			WHERE
				ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				<cfif not len(attributes.department_id) and attributes.report_type neq 9 and attributes.report_type neq 10>
				AND PROCESS_TYPE NOT IN (81,811)
				</cfif>
			GROUP BY
				<cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
					STORE,
					STORE_LOCATION,
				</cfif>
           		<cfif attributes.report_type eq 9 or attributes.report_type eq 10>
                   PRODUCT_ID,
                   #ALAN_ADI#
				<cfelse>
                   #ALAN_ADI#
				</cfif>
			ORDER BY
				<cfif attributes.report_type eq 9 or attributes.report_type eq 10>
                   PRODUCT_ID,
                   #ALAN_ADI#
				<cfelse>
                   #ALAN_ADI#
				</cfif>
		</cfquery>
        
         <cfquery name="GET_STOCK_AGE" datasource="#dsn2#">
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
					SHIP I WITH (NOLOCK),
					SHIP_ROW IR WITH (NOLOCK),
					#dsn3_alias#.STOCKS S
				WHERE 
					I.SHIP_ID = IR.SHIP_ID AND
					S.STOCK_ID=IR.STOCK_ID AND	
					<cfif len(attributes.department_id)><!--- depo varsa depolar arası sevk VE ithal mal girisine bak --->
						I.SHIP_TYPE IN (76,81,811,87) AND
					<cfelse>
						I.SHIP_TYPE IN(76,87) AND
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
        
        
        
        
        
        <cfquery name="GET_ALL_STOCK" datasource="#dsn2#">
			SELECT DISTINCT	
			<cfif attributes.report_type eq 1>
				S.STOCK_CODE,		 
                S.STOCK_ID AS PRODUCT_GROUPBY_ID,
                (S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,'')) ACIKLAMA,
                S.MANUFACT_CODE,
                S.PRODUCT_UNIT_ID,
                PU.MAIN_UNIT,
                PU.DIMENTION,
                S.BARCOD,
                S.PRODUCT_CODE,
                S.STOCK_CODE_2,
            <cfelseif attributes.report_type eq 2>
                S.PRODUCT_ID AS PRODUCT_GROUPBY_ID,
                S.PRODUCT_NAME AS ACIKLAMA,
               	(SELECT TOP 1 PP.MANUFACT_CODE FROM #dsn3_alias#.PRODUCT PP WHERE PP.PRODUCT_ID = S.PRODUCT_ID) MANUFACT_CODE,
                PU.MAIN_UNIT,
                PU.DIMENTION,
                S.PRODUCT_BARCOD AS BARCOD,
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
            <cfelseif attributes.report_type eq 9>
                 SR.STORE AS PRODUCT_GROUPBY_ID,
                 D.DEPARTMENT_HEAD AS ACIKLAMA,
            <cfelseif attributes.report_type eq 10>
                 CAST(SR.STORE AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.STORE_LOCATION,0) AS NVARCHAR(50)) AS PRODUCT_GROUPBY_ID,
                 D.DEPARTMENT_HEAD+' - '+SL.COMMENT AS ACIKLAMA,
            <cfelseif attributes.report_type eq 8>
                S.STOCK_CODE,
                S.STOCK_ID,
                CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)) AS PRODUCT_GROUPBY_ID,
                SR.SPECT_VAR_ID SPECT_VAR_ID,
                <cfif isdefined('x_dsp_spec_name') and x_dsp_spec_name eq 1>
                ISNULL((SELECT TOP 1 SPECT_MAIN_NAME FROM #dsn3_alias#.SPECT_MAIN SP WHERE SP.SPECT_MAIN_ID = SR.SPECT_VAR_ID),'') AS SPECT_NAME,
                </cfif>
                (S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,'')) ACIKLAMA,
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
                <cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost") and isdefined("attributes.display_cost")>
                    SL.DEPARTMENT_ID,
                    SL.LOCATION_ID,
                </cfif>
				P.ALL_START_COST,
                 ISNULL(P.ALL_START_COST_2,0) ALL_START_COST_2,
                ISNULL(P1.ALL_FINISH_COST,0) AS ALL_FINISH_COST,
                P1.ALL_FINISH_COST_2
                <cfif isdefined("attributes.display_cost_money")>
                    ,ISNULL((
                        SELECT TOP 1 
                            <cfif isdefined("attributes.location_based_cost")>
                                PURCHASE_NET_MONEY_LOCATION
                            <cfelse>
                                PURCHASE_NET_MONEY
                            </cfif>
                        FROM 
                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                        WHERE 
                            START_DATE <= #start_period_cost_date# 
                            AND PRODUCT_ID = S.PRODUCT_ID
                            <cfif attributes.report_type eq 8>
                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
                            </cfif>
                           
                            <cfif isdefined("attributes.location_based_cost")>
                                <cfif len(attributes.department_id)>
                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                <cfelse>
                                    AND DEPARTMENT_ID = D.DEPARTMENT_ID
                                    AND LOCATION_ID = SL.LOCATION_ID
                                </cfif>
                            </cfif>
                        ORDER BY 
                            START_DATE DESC, 
                            RECORD_DATE DESC,
                            PRODUCT_COST_ID DESC
                    ),'') ALL_START_MONEY,
                    ISNULL((
                        SELECT TOP 1 
                            <cfif isdefined("attributes.location_based_cost")>
                                PURCHASE_NET_MONEY_LOCATION
                            <cfelse>
                                PURCHASE_NET_MONEY
                            </cfif>
                        FROM 
                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                        WHERE 
                            START_DATE <= #finish_date# 
                            AND PRODUCT_ID = S.PRODUCT_ID
                            <cfif attributes.report_type eq 8>
                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
                            </cfif>
                           
                            <cfif isdefined("attributes.location_based_cost")>
                                <cfif len(attributes.department_id)>
                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                <cfelse>
                                    AND DEPARTMENT_ID = D.DEPARTMENT_ID
                                    AND LOCATION_ID = SL.LOCATION_ID
                                </cfif>
                            </cfif>
                        ORDER BY 
                            START_DATE DESC, 
                            RECORD_DATE DESC,
                            PRODUCT_COST_ID DESC
                    ),'') ALL_FINISH_MONEY
                </cfif>
            INTO ####GET_ALL_STOCK_#session.ep.userid#
            FROM        
                STOCKS_ROW  SR WITH (NOLOCK) INNER JOIN 
                #dsn3_alias#.STOCKS S WITH (NOLOCK) ON (SR.STOCK_ID=S.STOCK_ID)
				OUTER APPLY
				(
                    SELECT TOP 1
                        <cfif isdefined("attributes.location_based_cost")>
                            <cfif isdefined("attributes.display_cost_money")>
                                (PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION) AS ALL_START_COST,
                            <cfelse>
                                (PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION) AS ALL_START_COST,
                            </cfif>
                        <cfelse>
                            <cfif isdefined("attributes.display_cost_money")>
                                (PURCHASE_NET_ALL+PURCHASE_EXTRA_COST) AS ALL_START_COST,
                            <cfelse>
                                (PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM) AS ALL_START_COST,
                            </cfif>	
                        </cfif>
						<cfif isdefined("attributes.location_based_cost")>
                            ISNULL((PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION),0) AS ALL_START_COST_2
                        <cfelse>
                            ISNULL((PURCHASE_NET_ALL+PURCHASE_EXTRA_COST),0) AS ALL_START_COST_2
                        </cfif>
                    FROM 
                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK)
                    WHERE 
                        START_DATE <= #start_period_cost_date# 
                        AND PRODUCT_ID = S.PRODUCT_ID
                        <cfif attributes.report_type eq 8>
                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
                        </cfif>
                        <cfif isdefined("attributes.location_based_cost")>
                            <cfif len(attributes.department_id)>
                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                            <cfelse>
                                AND DEPARTMENT_ID = D.DEPARTMENT_ID
                                AND LOCATION_ID = SL.LOCATION_ID
                            </cfif>
                        </cfif>
                    ORDER BY 
                        START_DATE DESC, 
                        RECORD_DATE DESC,
                        PRODUCT_COST_ID DESC
				) AS P
				OUTER APPLY
				(
                    SELECT TOP 1 
                        <cfif isdefined("attributes.location_based_cost")>
                            <cfif isdefined("attributes.display_cost_money")>
                                (PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION) AS ALL_FINISH_COST,
                            <cfelse>
                                (PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION) AS ALL_FINISH_COST,
                            </cfif>
                        <cfelse>
                            <cfif isdefined("attributes.display_cost_money")>
                                (PURCHASE_NET_ALL+PURCHASE_EXTRA_COST) AS ALL_FINISH_COST,
                            <cfelse>
                                (PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM) AS ALL_FINISH_COST,
                            </cfif>	
                        </cfif>
						<cfif isdefined("attributes.location_based_cost")>
                            (PURCHASE_NET_SYSTEM_2_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION) AS ALL_FINISH_COST_2
                        <cfelse>
                            (PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2) AS ALL_FINISH_COST_2
                        </cfif>
                    FROM 
                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                    WHERE 
                        START_DATE <= #finish_date# 
                        AND PRODUCT_ID = S.PRODUCT_ID
                        <cfif attributes.report_type eq 8>
                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
                        </cfif>
              
                        <cfif isdefined("attributes.location_based_cost")>
                            <cfif len(attributes.department_id)>
                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                            <cfelse>
                                AND DEPARTMENT_ID = D.DEPARTMENT_ID
                                AND LOCATION_ID = SL.LOCATION_ID
                            </cfif>
                        </cfif>
                    ORDER BY 
                        START_DATE DESC, 
                        RECORD_DATE DESC,
                        PRODUCT_COST_ID DESC
				) AS P1,
                #dsn3_alias#.PRODUCT_UNIT PU WITH (NOLOCK)
            <cfif attributes.report_type eq 3>
                ,#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK)
            <cfelseif attributes.report_type eq 4>
                ,#dsn_alias#.EMPLOYEE_POSITIONS EP WITH (NOLOCK)
            <cfelseif attributes.report_type eq 5>
                ,#dsn3_alias#.PRODUCT_BRANDS PB WITH (NOLOCK)
            <cfelseif attributes.report_type eq 6>
                 ,#dsn_alias#.COMPANY C WITH (NOLOCK)
            <cfelseif attributes.report_type eq 9>
                 ,#dsn_alias#.DEPARTMENT D WITH (NOLOCK)
            <cfelseif attributes.report_type eq 10>
                 ,#dsn_alias#.DEPARTMENT D WITH (NOLOCK)
                 ,#dsn_alias#.STOCKS_LOCATION SL WITH (NOLOCK)
            </cfif>
            <cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost") and isdefined("attributes.display_cost")>
                <cfif attributes.report_type neq 9>
                     ,#dsn_alias#.DEPARTMENT D WITH (NOLOCK)
                </cfif>
                 ,#dsn_alias#.STOCKS_LOCATION SL WITH (NOLOCK)
            </cfif>
            WHERE
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
					S.IS_PURCHASE = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
					S.IS_INVENTORY = 0 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
					S.IS_INVENTORY = 1 AND S.IS_PRODUCTION = 0 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
					S.IS_TERAZI = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
					S.IS_PURCHASE = 0 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
					S.IS_PRODUCTION = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
					S.IS_SERIAL_NO = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
					S.IS_KARMA = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
					S.IS_INTERNET = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
					S.IS_PROTOTYPE = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
					S.IS_ZERO_STOCK = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
					S.IS_EXTRANET = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
					S.IS_COST = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
					S.IS_SALES = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
					S.IS_QUALITY = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
					S.IS_INVENTORY = 1 AND
				</cfif>
                1=1
                <cfif attributes.report_type neq 9>
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
                <cfelse>
                    <cfif len(attributes.department_id_new)>
                        AND SR.STORE IN (#attributes.department_id_new#)
                    <cfelseif is_store>
                        AND	SR.STORE IN (#branch_dep_list#)
                    </cfif>	
                </cfif>
                <cfif len(attributes.product_status)>AND S.PRODUCT_STATUS = #attributes.product_status#</cfif>
                AND S.PRODUCT_ID=PU.PRODUCT_ID
                AND S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID
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
            <cfelseif attributes.report_type eq 9>
                AND SR.STORE=D.DEPARTMENT_ID
            <cfelseif attributes.report_type eq 10>
                AND SR.STORE=D.DEPARTMENT_ID
                AND SR.STORE=SL.DEPARTMENT_ID
                AND SR.STORE_LOCATION=SL.LOCATION_ID
            </cfif>
            <cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost") and isdefined("attributes.display_cost")>
                AND SR.STORE=D.DEPARTMENT_ID
                AND SR.STORE=SL.DEPARTMENT_ID
                AND SR.STORE_LOCATION=SL.LOCATION_ID
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
            <cfif listfind('1,2,3,4,5,6,8,9,10',attributes.report_type,',') and ((isdefined('attributes.control_total_stock') and len(attributes.control_total_stock)) or isdefined('attributes.is_stock_action'))><!--- sadece pozitif stoklar veya sadece hareket gormus stokların gelmesi --->
                AND <cfif attributes.report_type eq 8>(CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)))<cfelse>S.STOCK_ID</cfif>
                <cfif isdefined('attributes.control_total_stock') and attributes.control_total_stock eq 0 and not isdefined('attributes.is_stock_action')>
                    NOT IN
                <cfelse>
                    IN
                </cfif>
                    (
                    SELECT   
                        <cfif attributes.report_type eq 8>
                        	(CAST(SRW.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SRW.SPECT_VAR_ID,0) AS NVARCHAR(50))) <!--- spec bazında stok durumu kontrol ediliyor --->
                        <cfelse>
                        	SRW.STOCK_ID
                        </cfif>
                    FROM        
                        STOCKS_ROW SRW WITH (NOLOCK),
                        #dsn_alias#.STOCKS_LOCATION SL
                    WHERE
                        SRW.STORE = SL.DEPARTMENT_ID
                        AND SRW.STORE_LOCATION=SL.LOCATION_ID
                        <cfif isdefined('attributes.is_stock_action')>
                        AND SRW.UPD_ID IS NOT NULL
                        </cfif>
                        <cfif not isdefined('is_belognto_institution')>
                        AND SL.BELONGTO_INSTITUTION = 0
                        </cfif>
                        AND SRW.PROCESS_DATE <= #attributes.date2#	
                         <cfif attributes.report_type neq 9>
                            <cfif len(attributes.department_id)>
                                AND
                                    (
                                    <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                    (SRW.STORE = #listfirst(dept_i,'-')# AND SRW.STORE_LOCATION = #listlast(dept_i,'-')#)
                                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                    </cfloop>  
                                    )
                            <cfelseif is_store>
                                AND	SRW.STORE IN (#branch_dep_list#)
                            </cfif>
                        <cfelse>
                            <cfif len(attributes.department_id_new)>
                                AND SRW.STORE IN (#attributes.department_id_new#)
                            <cfelseif is_store>
                                AND	SRW.STORE IN (#branch_dep_list#)
                            </cfif>	
                        </cfif>
                        <cfif isdefined('attributes.control_total_stock') and len(attributes.control_total_stock)>
                            GROUP BY SRW.STOCK_ID
                            <cfif attributes.report_type eq 8>
                            ,ISNULL(SRW.SPECT_VAR_ID,0)
                            <!--- ,SRW.SPECT_VAR_ID --->
                            </cfif>
                            <cfif attributes.control_total_stock eq 0> <!--- sıfır stok --->
                                <cfif not isdefined('attributes.is_stock_action')>
                                    HAVING round((SUM(SRW.STOCK_IN)-SUM(SRW.STOCK_OUT)),2) <> 0
                                <cfelse>
                                    HAVING round((SUM(SRW.STOCK_IN)-SUM(SRW.STOCK_OUT)),2) = 0
                                </cfif>
                            <cfelseif attributes.control_total_stock eq 1> <!--- pozitif stok --->
                                HAVING round((SUM(SRW.STOCK_IN)-SUM(SRW.STOCK_OUT)),2) > 0
                            <cfelseif attributes.control_total_stock eq 2> <!--- negatif stok --->
                                HAVING round((SUM(SRW.STOCK_IN)-SUM(SRW.STOCK_OUT)),2) < 0
                            </cfif>
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
        
        
        
        <cfquery name="get_all_stock" datasource="#dsn2#">
            SELECT
                 GTS.TOTAL_STOCK,
                 GTS.TOTAL_PRODUCT_COST,
                 AST.DB_STOK_MIKTAR,
                 AST.DB_STOK_MALIYET,
                 GAS.*
            FROM
                ####GET_ALL_STOCK_#session.ep.userid#  GAS  
            LEFT JOIN
                ####get_total_stok_#session.ep.userid# GTS
            ON
                GAS.PRODUCT_GROUPBY_ID = GTS.GROUPBY_ALANI   
            LEFT JOIN
                ####acilis_stok2_#session.ep.userid# AST		    
            ON 
                GAS.PRODUCT_GROUPBY_ID = AST.GROUPBY_ALANI
            ORDER BY 
				<cfif attributes.report_type eq 1>
					S.STOCK_CODE
				<cfelse>
					ACIKLAMA
				</cfif>    
                
        </cfquery>
        
        
        <cfif attributes.report_type eq 8 and isdefined("attributes.display_cost") and isdefined("attributes.stock_age")> 
			<cfoutput query="GET_ALL_STOCK" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr>
                <td>
                    #replace(GET_ALL_STOCK.STOCK_CODE,";","","all")#
                </td>
                <td>
                     #replace(GET_ALL_STOCK.ACIKLAMA,";","","all")#
                </td>
                 <td>
                     #replace(GET_ALL_STOCK.BARCOD,";","","all")#
                </td>
                 <td>
                     #GET_ALL_STOCK.SPECT_NAME# 
                </td>
                 <td>
                    #replace(GET_ALL_STOCK.PRODUCT_CODE,";","","all")# 
                </td>
                <td width="130">
                    #replace(GET_ALL_STOCK.MANUFACT_CODE,";","","all")# 
                </td>
                <td width="100">
                    #replace(GET_ALL_STOCK.MAIN_UNIT,";","","all")# 
                </td>
                <td>
                    #DB_STOK_MIKTAR# 
                </td>
                <td>
                    #DB_STOK_MALIYET# 
                </td>
                <td>
                    #TOTAL_STOCK# 
                </td>
                <td>
                    #TOTAL_PRODUCT_COST# 
                </td>
                    <cfset agirlikli_toplam=0>
                    <cfif TOTAL_STOCK gt 0>
                        <cfset kalan=TOTAL_STOCK>
                        <cfquery name="get_product_detail" dbtype="query">
                            SELECT 
                                AMOUNT AS PURCHASE_AMOUNT,
                                GUN_FARKI 
                            FROM 
                                GET_STOCK_AGE 
                            WHERE 
                               STOCK_SPEC_ID ='#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#'
                            ORDER BY ISLEM_TARIHI DESC
                        </cfquery>
                        <cfloop query="get_product_detail">
                            <cfif kalan gt 0 and PURCHASE_AMOUNT lte kalan>
                                <cfset kalan = kalan - PURCHASE_AMOUNT>
                                <cfset agırlıklı_toplam=  agırlıklı_toplam + (PURCHASE_AMOUNT*GUN_FARKI)>
                            <cfelseif kalan gt 0 and PURCHASE_AMOUNT gt kalan>
                                <cfset agırlıklı_toplam=  agırlıklı_toplam + (kalan*GUN_FARKI)>
                                <cfbreak>
                            </cfif>
                        </cfloop>
                        <cfset agırlıklı_toplam=agırlıklı_toplam/TOTAL_STOCK>
                    </cfif>
                 <td></td>
                <td>
                    <cfif agırlıklı_toplam gt 0>#TLFormat(agırlıklı_toplam)#</cfif>
                </td>
            </tr>
            </cfoutput>	
    <cfelse>   
        
        
        
        
        <cfset attributes.TOTALRECORDS = get_all_stock.recordcount>
        
		
       
		<cfif listfind('1,2',attributes.is_excel) and not isdefined('attributes.ajax')>
			<cfset page_maxrows = 100000>
		<cfelse>
			<cfset page_maxrows = attributes.maxrows>
		</cfif>
</cfif>
</cfif>        
