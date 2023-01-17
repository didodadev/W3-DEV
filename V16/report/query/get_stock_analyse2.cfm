<cfsetting showdebugoutput="no">
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
		<cfif start_period_cost_date is '01/01/#session.ep.period_year#'>
			<cfset start_period_cost_date=start_date>
		<cfelse>
			<cfset start_period_cost_date=date_add('d',-1,start_date)>
		</cfif>
		<!--- GET ALL STOCK CREATE EDILIYOR--->
        <cfquery name="get_all_stock_control" datasource="#dsn_report#">
        	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'GET_ALL_STOCK')
            	BEGIN
                	DROP TABLE GET_ALL_STOCK
                END
        </cfquery>
        <cfquery name="GET_ALL_STOCK" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			SELECT DISTINCT	
				S.STOCK_CODE,		 
			<cfif attributes.report_type eq 1>
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
                S.MANUFACT_CODE,
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
                S.STOCK_ID,
                CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)) AS PRODUCT_GROUPBY_ID,
                SR.SPECT_VAR_ID SPECT_VAR_ID,
                <cfif isdefined('x_dsp_spec_name') and x_dsp_spec_name eq 1>
                ISNULL((SELECT SPECT_MAIN_NAME FROM #dsn3_alias#.SPECT_MAIN SP WHERE SP.SPECT_MAIN_ID = SR.SPECT_VAR_ID),'') AS SPECT_NAME,
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
                <cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
                    SL.DEPARTMENT_ID,
                    SL.LOCATION_ID,
                </cfif>
				ISNULL(P.ALL_START_COST,0) AS ALL_START_COST,
                ISNULL(P.ALL_START_COST_2,0) AS ALL_START_COST_2 ,
                ISNULL(P1.ALL_FINISH_COST,0) AS ALL_FINISH_COST,
                ISNULL(P1.ALL_FINISH_COST_2,0) AS ALL_FINISH_COST_2 
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
            INTO #dsn_report#.GET_ALL_STOCK
            FROM        
                STOCKS_ROW  SR WITH (NOLOCK) INNER JOIN 
                #dsn3_alias#.STOCKS S WITH (NOLOCK) ON (SR.STOCK_ID=S.STOCK_ID)
				OUTER APPLY
				(
                    SELECT TOP 1
                        <cfif isdefined("attributes.location_based_cost")>
                            <cfif isdefined("attributes.display_cost_money")>
                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION) AS ALL_START_COST,
                            <cfelse>
                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0)) AS ALL_START_COST,
                            </cfif>
                        <cfelse>
                            <cfif isdefined("attributes.display_cost_money")>
                                (PURCHASE_NET+PURCHASE_EXTRA_COST) AS ALL_START_COST,
                            <cfelse>
                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0)) AS ALL_START_COST,
                            </cfif>	
                        </cfif>
						 <cfif isdefined("attributes.location_based_cost")>
                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION) AS ALL_START_COST_2
                        <cfelse>
                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2) AS ALL_START_COST_2
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
                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION) AS ALL_FINISH_COST,
                            <cfelse>
                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0)) AS ALL_FINISH_COST,
                            </cfif>
                        <cfelse>
                            <cfif isdefined("attributes.display_cost_money")>
                                (PURCHASE_NET+PURCHASE_EXTRA_COST) AS ALL_FINISH_COST,
                            <cfelse>
                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0)) AS ALL_FINISH_COST,
                            </cfif>	
                        </cfif>
						<cfif isdefined("attributes.location_based_cost")>
                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION) AS ALL_FINISH_COST_2
                        <cfelse>
                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2) AS ALL_FINISH_COST_2
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
            <cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
                <cfif attributes.report_type neq 9>
                     ,#dsn_alias#.DEPARTMENT D WITH (NOLOCK)
                </cfif>
                 ,#dsn_alias#.STOCKS_LOCATION SL WITH (NOLOCK)
            </cfif>





            WHERE
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
            <cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
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
        <!--- GET ALL STOCK CREATE EDILIYOR--->
        
        <cfif listfind('1,2',attributes.is_excel) and not isdefined('attributes.ajax')>
			<cfset page_maxrows = 100000>
		<cfelse>
			<cfset page_maxrows = attributes.maxrows>
		</cfif>
        
        <cfif listfind('1,2,8',attributes.report_type)>
        	<cfif len(attributes.process_type) and listfind(attributes.process_type,21)>
                <cfquery name="GET_STOCK_VIRMAN_OUT" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
					SELECT
						GC.PRODUCT_ID,
						GC.STOCK_ID,
						<cfif stock_table>
                            S.PRODUCT_CATID,
                            S.BRAND_ID,
						</cfif>
						SF.EXIT_AMOUNT AMOUNT,
						SF.DEPARTMENT_ID DEPARTMENT_IN,
						SF.EXIT_DEPARTMENT_ID DEPARTMENT_OUT,
						SF.LOCATION_ID LOCATION_IN,
						SF.EXIT_LOCATION_ID LOCATION_OUT,
						GC.STOCK_IN,
						GC.STOCK_OUT,
						((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
						(GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
						<cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
							<cfif isdefined('attributes.is_system_money_2')>
							GC.MALIYET MALIYET,
							GC.MALIYET_2 MALIYET_2,
							(SF.EXIT_AMOUNT*GC.MALIYET) AS TOTAL_COST_PRICE,
							0 AS TOTAL_EXTRA_COST,
							(SF.EXIT_AMOUNT*GC.MALIYET_2) AS TOTAL_COST_PRICE_2,
							0 AS TOTAL_EXTRA_COST_2,
							<cfelse>
								(GC.MALIYET) MALIYET,
								(SF.EXIT_AMOUNT*GC.MALIYET) AS TOTAL_COST_PRICE,
								0 AS TOTAL_EXTRA_COST,
							</cfif>
						<cfelse>
							(GC.MALIYET) MALIYET,
							(SF.EXIT_AMOUNT*GC.MALIYET) AS TOTAL_COST_PRICE,
							0 AS TOTAL_EXTRA_COST,
						</cfif>
						<cfif attributes.report_type eq 8>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
						SF.PROCESS_DATE ISLEM_TARIHI,
						SF.PROCESS_CAT,
						SF.PROCESS_TYPE,
						0 AS PROD_ORDER_NUMBER,
						0 AS PROD_ORDER_RESULT_NUMBER
					INTO #DSN_REPORT#.GET_STOCK_VIRMAN_OUT
                    FROM 
						STOCK_EXCHANGE SF WITH (NOLOCK),
						<cfif is_store or isdefined("attributes.location_based_cost")>
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
						,#dsn3_alias#.STOCKS S WITH (NOLOCK)
						</cfif>
					WHERE 
						GC.UPD_ID = SF.STOCK_EXCHANGE_ID AND
						GC.PROCESS_TYPE = SF.PROCESS_TYPE AND
						<cfif stock_table>
						S.STOCK_ID = GC.STOCK_ID AND
						</cfif>
						GC.STOCK_ID=SF.EXIT_STOCK_ID AND
						SF.PROCESS_DATE >= #attributes.date# AND
						<cfif attributes.report_type eq 8>
						ISNULL((SELECT SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SF.EXIT_SPECT_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
						</cfif>
						SF.PROCESS_DATE <= #attributes.date2#
						<cfif len(attributes.department_id)>
						AND
						(
							SF.EXIT_DEPARTMENT_ID IS NOT NULL AND
							<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(SF.EXIT_DEPARTMENT_ID = #listfirst(dept_i,'-')# AND SF.EXIT_LOCATION_ID = #listlast(dept_i,'-')#)
							<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
							</cfloop>  
						)
						<cfelseif is_store>
							AND SF.EXIT_DEPARTMENT_ID IN (#branch_dep_list#)
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
			<cfelse>
				<cfset GET_SHIP_ROWS.recordcount = 0>
			</cfif>
		<cfelse>
			<cfset GET_STOCK_FIS.recordcount = 0>
			<cfset GET_DEMONTAJ.recordcount = 0>
			<cfset GET_INV_PURCHASE.recordcount = 0>
		</cfif>
        <!---stok yaşı--->
        <cfif isdefined('attributes.stock_age')>
        <cfquery name="control_GET_STOCK_AGE" datasource="#DSN_REPORT#">
        	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'GET_STOCK_AGE')
            	BEGIN
                	DROP TABLE GET_STOCK_AGE
                END
        </cfquery>
        <cfquery name="GET_STOCK_AGE" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
                 SELECT *   
                 INTO #DSN_REPORT#.GET_STOCK_AGE
                 FROM 
                 (
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
                	)AS XXX  
                </cfquery>
        </cfif>
        
        <!---acilis_stok_2--->
        <cfquery name="control_acilis_stok_2" datasource="#dsn_report#">
        	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'acilis_stok2')
            	BEGIN
                	DROP TABLE acilis_stok2
                END
        </cfquery>
        <cfquery name="acilis_stok2" datasource="#dsn2#">
			SELECT	
				SUM(AMOUNT) AS DB_STOK_MIKTAR,
				SUM(AMOUNT*MALIYET) AS DB_STOK_MALIYET,
				<cfif isdefined('attributes.is_system_money_2')>
				SUM(AMOUNT*MALIYET_2) AS DB_STOK_MALIYET_2,
				</cfif>
				#ALAN_ADI# AS GROUPBY_ALANI
			INTO #DSN_REPORT#.acilis_stok2
            FROM
				(
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
                ) as GET_STOCK_ROWS
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
        
		<!---get_total_stok--->
        <cfquery name="control_acilis_stok_2" datasource="#dsn_report#">
        	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'get_total_stok')
            	BEGIN
                	DROP TABLE get_total_stok
                END
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
			INTO #DSN_REPORT#.get_total_stok
            FROM
				(
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
                ) as 
                GET_STOCK_ROWS
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
        
        <cfif listfind('1,2,8',attributes.report_type)>
        	<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
                <!---d_alis_miktar--->
                <cfquery name="control_acilis_stok_2" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'd_alis_miktar')
                        BEGIN
                            DROP TABLE d_alis_miktar
                        END
                </cfquery>
                <cfquery name="d_alis_miktar" datasource="#dsn2#">
				SELECT	
					SUM(AMOUNT) AS TOPLAM_ALIS,
					SUM(TOTAL_COST) AS TOPLAM_ALIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_2) AS TOPLAM_ALIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				INTO #DSN_REPORT#.d_alis_miktar
                FROM
					(
                            SELECT
                                GC.STOCK_ID,
                                GC.PRODUCT_ID,
                                <cfif attributes.report_type eq 8>
                                CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                </cfif>
                                1 AS INVOICE_CAT,
                                0 AS IS_RETURN,
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
                                GC.PROCESS_TYPE PROCESS_TYPE,
                                ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                    SELECT TOP 1 
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>
                                        <cfelse>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>	
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("EP.OUR_COMPANY_INFO.IS_STOCK_BASED_COST") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                SHIP WITH (NOLOCK),	
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
                                ISNULL(INVOICE.IS_RETURN,0) IS_RETURN,
                                <cfif stock_table>
                                S.PRODUCT_MANAGER,
                                S.PRODUCT_CATID,
                                S.BRAND_ID,
                                </cfif>
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    <cfif isdefined('attributes.is_system_money_2')>
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>
                                        <cfelse>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>	
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                INVOICE_MONEY IM,
                                </cfif>
                                <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    AND IM.MONEY_TYPE = '#session.ep.money2#'
                                    <cfelse>
                                    AND IM.MONEY_TYPE = '#attributes.cost_money#'
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
                        </cfif>
                    ) AS GET_SHIP_ROWS
				WHERE
					 <!--- satıs iade faturaları da mal alım irs. kaydediyor, bunları alıslara dahil etmiyoruz zaten satıs iade bolumunde gosteriliyor --->
					(
						PROCESS_TYPE IN (76,80,87)<!--- 811 kaldırıldı neden var?--->
						AND INVOICE_CAT NOT IN (54,55)
					)
					OR 
					(
						PROCESS_TYPE = 84 AND IS_RETURN = 0
					)
				GROUP BY
					#ALAN_ADI#
				ORDER BY 
					#ALAN_ADI#
			</cfquery>
				<!---d_alis_tutar--->
                <cfquery name="control_acilis_stok_2" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'd_alis_tutar')
                        BEGIN
                            DROP TABLE d_alis_tutar
                        END
                </cfquery>	            
                <cfquery name="d_alis_tutar" datasource="#dsn2#">
				SELECT
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(BIRIM_COST_2 + EXTRA_COST_2) AS TOPLAM_ALIS_MALIYET_2,
					SUM(BIRIM_COST_2) AS TOPLAM_ALIS_TUTAR_2,
					</cfif>
					SUM(BIRIM_COST + EXTRA_COST) AS TOPLAM_ALIS_MALIYET1,
					SUM(BIRIM_COST) AS TOPLAM_ALIS_TUTAR,
					#ALAN_ADI# AS GROUPBY_ALANI
				INTO #DSN_REPORT#.d_alis_tutar
                FROM
					(
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
                            ISNULL(I.IS_RETURN,0) IS_RETURN,
                            <cfif isdefined('attributes.from_invoice_actions') and isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                                <cfif isdefined('attributes.is_system_money_2')>
                                    (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                    (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                    ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST_2,
                                    ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST_2,
                                <cfelseif attributes.cost_money is not session.ep.money>
                                    ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST,
                                    ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST,
                                <cfelse>
                                    (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                    (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                </cfif>
                            </cfif>
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                <cfif isdefined('attributes.is_system_money_2')>
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
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                            ,INVOICE_MONEY IM
                            </cfif>
                            <cfif stock_table>
                            ,#dsn3_alias#.STOCKS S
                            </cfif>
                        WHERE 
                            I.INVOICE_ID = IR.INVOICE_ID AND
                            <cfif not isdefined('attributes.from_invoice_actions')>
                            I.INVOICE_CAT IN (51,54,55,59,60,61,62,63,64,65,68,690,691,591,592) AND
                            </cfif>
                            I.IS_IPTAL = 0 AND
                            I.NETTOTAL > 0 AND
                            I.INVOICE_DATE >= #attributes.date# AND 
                            I.INVOICE_DATE <= #attributes.date2#
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                 AND I.INVOICE_ID = IM.ACTION_ID
                                <cfif isdefined('attributes.is_system_money_2')>
                                 AND IM.MONEY_TYPE = '#session.ep.money2#'
                                <cfelse>
                                 AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                </cfif>
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
                        
                     ) AS 
                        GET_INV_PURCHASE
                    WHERE
                        PROCESS_TYPE IN (59,64,68,591)
                        OR
                        (
                            PROCESS_TYPE = 690 AND IS_RETURN = 0
                        )
                    GROUP BY
                        #ALAN_ADI#
                    ORDER BY
                        #ALAN_ADI# 
                </cfquery>
                <!---d_alis_iade_miktar--->
                <cfquery name="control_acilis_stok_2" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'd_alis_iade_miktar')
                        BEGIN
                            DROP TABLE d_alis_iade_miktar
                        END
                </cfquery>
                <cfquery name="d_alis_iade_miktar" datasource="#dsn2#">
				SELECT
					SUM(AMOUNT) AS TOPLAM_ALIS_IADE,
					SUM(TOTAL_COST) AS TOPLAM_ALIS_IADE_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_2) AS TOPLAM_ALIS_IADE_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				INTO #dsn_report#.d_alis_iade_miktar
                FROM
					(
                        SELECT
                            GC.STOCK_ID,
                            GC.PRODUCT_ID,
                            <cfif attributes.report_type eq 8>
                            CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                            </cfif>
                            1 AS INVOICE_CAT,
                            0 AS IS_RETURN,
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
                            GC.PROCESS_TYPE PROCESS_TYPE,
                            ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                SELECT TOP 1 
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif isdefined("attributes.display_cost_money")>
                                            (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                        </cfif>
                                    <cfelse>
                                        <cfif isdefined("attributes.display_cost_money")>
                                            (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                        </cfif>	
                                    </cfif>
                                FROM 
                                    #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                WHERE 
                                    START_DATE <= #finish_date# 
                                    AND PRODUCT_ID = GC.PRODUCT_ID
                                    <cfif attributes.report_type eq 8>
                                         AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                    </cfif>
                                    <cfif IsDefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                        AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                    </cfif>
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif len(attributes.department_id)>
                                            AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                            AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                    <cfif isdefined("attributes.location_based_cost")>
                                        (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                    <cfelse>
                                        (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                    </cfif>

                                FROM 
                                    #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                WHERE 
                                    START_DATE <= #finish_date# 
                                    AND PRODUCT_ID = GC.PRODUCT_ID
                                    <cfif attributes.report_type eq 8>
                                         AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                    </cfif>
                                    <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                        AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                    </cfif>
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif len(attributes.department_id)>
                                            AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                            AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                            <cfif is_store or isdefined("attributes.location_based_cost")>
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
                            SHIP WITH (NOLOCK),	
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
                            ISNULL(INVOICE.IS_RETURN,0) IS_RETURN,
                            <cfif stock_table>
                            S.PRODUCT_MANAGER,
                            S.PRODUCT_CATID,
                            S.BRAND_ID,
                            </cfif>
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                <cfif isdefined('attributes.is_system_money_2')>
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
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif isdefined("attributes.display_cost_money")>
                                            (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                        </cfif>
                                    <cfelse>
                                        <cfif isdefined("attributes.display_cost_money")>
                                            (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                        </cfif>	
                                    </cfif>
                                FROM 
                                    #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                WHERE 
                                    START_DATE <= #finish_date# 
                                    AND PRODUCT_ID = GC.PRODUCT_ID
                                    <cfif attributes.report_type eq 8>
                                         AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                    </cfif>
                                    <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                        AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                    </cfif>
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif len(attributes.department_id)>
                                            AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                            AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                    <cfif isdefined("attributes.location_based_cost")>
                                        (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                    <cfelse>
                                        (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                    </cfif>
                                FROM 
                                    #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                WHERE 
                                    START_DATE <= #finish_date# 
                                    AND PRODUCT_ID = GC.PRODUCT_ID
                                    <cfif attributes.report_type eq 8>
                                         AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                    </cfif>
                                    <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                        AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                    </cfif>
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif len(attributes.department_id)>
                                            AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                            AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                            INVOICE_MONEY IM,
                            </cfif>
                            <cfif is_store or isdefined("attributes.location_based_cost")>
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
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                <cfif isdefined('attributes.is_system_money_2')>
                                AND IM.MONEY_TYPE = '#session.ep.money2#'
                                <cfelse>
                                AND IM.MONEY_TYPE = '#attributes.cost_money#'
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
                    </cfif>
                    )
                    GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 78
				GROUP BY
					#ALAN_ADI#
				ORDER BY 
					#ALAN_ADI#
			</cfquery>
            	<!---d_alis_iade_tutar--->
            	<cfquery name="d_alis_iade_tutar" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'd_alis_iade_tutar')
                        BEGIN
                            DROP TABLE d_alis_iade_tutar
                        END
                </cfquery>
                <cfquery name="d_alis_iade_tutar" datasource="#dsn2#">
				SELECT	
					SUM(EXTRA_COST + BIRIM_COST) AS TOPLAM_ALIS_IADE_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(EXTRA_COST_2 + BIRIM_COST_2) AS TOPLAM_ALIS_IADE_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				INTO #DSN_REPORT#.d_alis_iade_tutar
                FROM
					(
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
                        ISNULL(I.IS_RETURN,0) IS_RETURN,
                        <cfif isdefined('attributes.from_invoice_actions') and isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                            <cfif isdefined('attributes.is_system_money_2')>
                                (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST_2,
                                ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST_2,
                            <cfelseif attributes.cost_money is not session.ep.money>
                                ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST,
                                ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST,
                            <cfelse>
                                (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                            </cfif>
                        </cfif>
                        <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                            <cfif isdefined('attributes.is_system_money_2')>
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
                        <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                        ,INVOICE_MONEY IM
                        </cfif>
                        <cfif stock_table>
                        ,#dsn3_alias#.STOCKS S
                        </cfif>
                    WHERE 
                        I.INVOICE_ID = IR.INVOICE_ID AND
                        <cfif not isdefined('attributes.from_invoice_actions')>
                        I.INVOICE_CAT IN (51,54,55,59,60,61,62,63,64,65,68,690,691,591,592) AND
                        </cfif>
                        I.IS_IPTAL = 0 AND
                        I.NETTOTAL > 0 AND
                        I.INVOICE_DATE >= #attributes.date# AND 
                        I.INVOICE_DATE <= #attributes.date2#
                        <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                             AND I.INVOICE_ID = IM.ACTION_ID
                            <cfif isdefined('attributes.is_system_money_2')>
                             AND IM.MONEY_TYPE = '#session.ep.money2#'
                            <cfelse>
                             AND IM.MONEY_TYPE = '#attributes.cost_money#'
                            </cfif>
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
                    ) AS 
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
            	<!---get_ithal_mal_girisi_total--->
                <cfquery name="get_ithal_mal_girisi_total" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'get_ithal_mal_girisi_total')
                        BEGIN
                            DROP TABLE get_ithal_mal_girisi_total
                        END
                </cfquery>
                <cfquery name="get_ithal_mal_girisi_total" datasource="#dsn2#">
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
                    INTO #DSN_REPORT#.get_ithal_mal_girisi_total
                    FROM
                        (
                         
                            SELECT
                                GC.STOCK_ID,
                                GC.PRODUCT_ID,
                                <cfif attributes.report_type eq 8>
                                CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                </cfif>
                                1 AS INVOICE_CAT,
                                0 AS IS_RETURN,
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
                                GC.PROCESS_TYPE PROCESS_TYPE,
                                ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                    SELECT TOP 1 
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>
                                        <cfelse>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>	
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif IsDefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                SHIP WITH (NOLOCK),	
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
                                ISNULL(INVOICE.IS_RETURN,0) IS_RETURN,
                                <cfif stock_table>
                                S.PRODUCT_MANAGER,
                                S.PRODUCT_CATID,
                                S.BRAND_ID,
                                </cfif>
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    <cfif isdefined('attributes.is_system_money_2')>
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>
                                        <cfelse>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>	
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                INVOICE_MONEY IM,
                                </cfif>
                                <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    AND IM.MONEY_TYPE = '#session.ep.money2#'
                                    <cfelse>
                                    AND IM.MONEY_TYPE = '#attributes.cost_money#'
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
                        </cfif>
                        ) AS 
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
            <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
                <!---get_sevk_irs_total--->
                <cfquery name="get_sevk_irs_total" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'get_sevk_irs_total')
                        BEGIN
                            DROP TABLE get_sevk_irs_total
                        END
                </cfquery>
                <cfquery name="get_sevk_irs_total" datasource="#dsn2#">
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
                    INTO #DSN_REPORT#.get_sevk_irs_total
                    FROM
                        (
                         	SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    1 AS INVOICE_CAT,
                                    0 AS IS_RETURN,
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
                                    GC.PROCESS_TYPE PROCESS_TYPE,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            <cfif IsDefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                                AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                            </cfif>
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                                AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                            </cfif>
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                    SHIP WITH (NOLOCK),	
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
                                    ISNULL(INVOICE.IS_RETURN,0) IS_RETURN,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
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
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                                AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                            </cfif>
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                                AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                            </cfif>
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    INVOICE_MONEY IM,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                        AND IM.MONEY_TYPE = '#attributes.cost_money#'
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
                            </cfif>
                        ) AS 
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
					<!---d_fatura_satis_tutar--->
                    <cfquery name="d_fatura_satis_tutar" datasource="#dsn_report#">
                        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'd_fatura_satis_tutar')
                            BEGIN
                                DROP TABLE d_fatura_satis_tutar
                            END
                    </cfquery>
                    <cfquery name="d_fatura_satis_tutar" datasource="#dsn2#">
                        SELECT	
                            SUM(BIRIM_COST) AS FATURA_SATIS_TUTAR,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(BIRIM_COST_2) AS FATURA_SATIS_TUTAR_2,
                            </cfif>
                            <cfif isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                                SUM(INV_COST+INV_EXTRA_COST) AS FATURA_SATIS_MALIYET,
                                <cfif isdefined('attributes.is_system_money_2')>
                                SUM(INV_COST_2+INV_EXTRA_COST_2) AS FATURA_SATIS_MALIYET_2,
                                </cfif>
                            </cfif>
                            SUM(AMOUNT) AS FATURA_SATIS_MIKTAR,
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            (
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
                                    ISNULL(I.IS_RETURN,0) IS_RETURN,
                                    <cfif isdefined('attributes.from_invoice_actions') and isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                            (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                            ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST_2,
                                            ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST_2,
                                        <cfelseif attributes.cost_money is not session.ep.money>
                                            ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST,
                                            ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST,
                                        <cfelse>
                                            (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                            (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                        </cfif>
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
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
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    ,INVOICE_MONEY IM
                                    </cfif>
                                    <cfif stock_table>
                                    ,#dsn3_alias#.STOCKS S
                                    </cfif>
                                WHERE 
                                    I.INVOICE_ID = IR.INVOICE_ID AND
                                    <cfif not isdefined('attributes.from_invoice_actions')>
                                    I.INVOICE_CAT IN (51,54,55,59,60,61,62,63,64,65,68,690,691,591,592) AND
                                    </cfif>
                                    I.IS_IPTAL = 0 AND
                                    I.NETTOTAL > 0 AND
                                    I.INVOICE_DATE >= #attributes.date# AND 
                                    I.INVOICE_DATE <= #attributes.date2#
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                         AND I.INVOICE_ID = IM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                         AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                         AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
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
                            ) AS
                            GET_INV_PURCHASE
                        WHERE
                            PROCESS_TYPE IN (52,53,531) 
                        GROUP BY
                            #ALAN_ADI#
                        ORDER BY
                            #ALAN_ADI# 
                    </cfquery>
                    <!---d_fatura_satis_iade_tutar--->
                    <cfquery name="d_fatura_satis_iade_tutar" datasource="#dsn_report#">
                        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'd_fatura_satis_iade_tutar')
                            BEGIN
                                DROP TABLE d_fatura_satis_iade_tutar
                            END
                    </cfquery>
                    <cfquery name="d_fatura_satis_iade_tutar" datasource="#dsn2#">
                        SELECT	
                            SUM(BIRIM_COST) AS FATURA_SATIS_IADE_TUTAR,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(BIRIM_COST_2) AS FATURA_SATIS_IADE_TUTAR_2,
                            </cfif>
                            <cfif isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                                SUM(INV_COST+INV_EXTRA_COST) AS  FATURA_SATIS_IADE_MALIYET,
                                <cfif isdefined('attributes.is_system_money_2')>
                                    SUM(INV_COST_2+INV_EXTRA_COST_2) AS FATURA_SATIS_IADE_MALIYET_2,
                                </cfif>
                            </cfif>
                            SUM(AMOUNT) AS FATURA_SATIS_IADE_MIKTAR,
                            #ALAN_ADI# AS GROUPBY_ALANI
                        #DSN_REPORT#.d_fatura_satis_iade_tutar
                        FROM
                            (
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
                                    ISNULL(I.IS_RETURN,0) IS_RETURN,
                                    <cfif isdefined('attributes.from_invoice_actions') and isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                            (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                            ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST_2,
                                            ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST_2,
                                        <cfelseif attributes.cost_money is not session.ep.money>
                                            ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST,
                                            ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST,
                                        <cfelse>
                                            (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                            (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                        </cfif>
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
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
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    ,INVOICE_MONEY IM
                                    </cfif>
                                    <cfif stock_table>
                                    ,#dsn3_alias#.STOCKS S
                                    </cfif>
                                WHERE 
                                    I.INVOICE_ID = IR.INVOICE_ID AND
                                    <cfif not isdefined('attributes.from_invoice_actions')>
                                    I.INVOICE_CAT IN (51,54,55,59,60,61,62,63,64,65,68,690,691,591,592) AND
                                    </cfif>
                                    I.IS_IPTAL = 0 AND
                                    I.NETTOTAL > 0 AND
                                    I.INVOICE_DATE >= #attributes.date# AND 
                                    I.INVOICE_DATE <= #attributes.date2#
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                         AND I.INVOICE_ID = IM.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                         AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                         AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
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
                            ) AS  	
                            GET_INV_PURCHASE
                        WHERE
                            PROCESS_TYPE IN (54,55) 
                        GROUP BY
                            #ALAN_ADI#
                        ORDER BY
                            #ALAN_ADI# 
                    </cfquery>
           	     </cfif>
                 
            	 <!---d_satis--->
                 <cfquery name="d_satis" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'd_satis')
                        BEGIN
                            DROP TABLE d_satis
                        END
                </cfquery>
                 <cfquery name="d_satis" datasource="#dsn2#">
                    SELECT	
                        SUM(AMOUNT) AS TOPLAM_SATIS,
                        SUM(TOTAL_COST) AS TOPLAM_SATIS_MALIYET,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(TOTAL_COST_2) AS TOPLAM_SATIS_MALIYET_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI
                    INTO #dsn_report#.d_satis
                    FROM
                         (
                            SELECT
                                GC.STOCK_ID,
                                GC.PRODUCT_ID,
                                <cfif attributes.report_type eq 8>
                                CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                </cfif>
                                1 AS INVOICE_CAT,
                                0 AS IS_RETURN,
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
                                GC.PROCESS_TYPE PROCESS_TYPE,
                                ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                    SELECT TOP 1 
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>
                                        <cfelse>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>	
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif IsDefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                SHIP WITH (NOLOCK),	
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
                                ISNULL(INVOICE.IS_RETURN,0) IS_RETURN,
                                <cfif stock_table>
                                S.PRODUCT_MANAGER,
                                S.PRODUCT_CATID,
                                S.BRAND_ID,
                                </cfif>
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    <cfif isdefined('attributes.is_system_money_2')>
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>
                                        <cfelse>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>	
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                INVOICE_MONEY IM,
                                </cfif>
                                <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    AND IM.MONEY_TYPE = '#session.ep.money2#'
                                    <cfelse>
                                    AND IM.MONEY_TYPE = '#attributes.cost_money#'
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
                        </cfif>
                        ) AS GET_SHIP_ROWS 
                    WHERE
                        PROCESS_TYPE IN (70,71,88)
                    GROUP BY
                        #ALAN_ADI#
                    ORDER BY 
                        #ALAN_ADI#
				</cfquery>
            	 <!---d_satis_iade--->
            	 <cfquery name="d_satis_iade" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'd_satis_iade')
                        BEGIN
                            DROP TABLE d_satis_iade
                        END
                </cfquery>
            	 <cfquery name="d_satis_iade" datasource="#dsn2#">
                    SELECT *
                    INTO #DSN_REPORT#.d_satis_iade
                    FROM 
                    	(
                            SELECT	
                                SUM(AMOUNT) AS TOPLAM_SATIS_IADE,
                                SUM(TOTAL_COST) AS TOP_SAT_IADE_MALIYET,
                                <cfif isdefined('attributes.is_system_money_2')>
                                SUM(TOTAL_COST_2) AS TOP_SAT_IADE_MALIYET_2,
                                </cfif>
                                #ALAN_ADI# AS GROUPBY_ALANI
                            FROM
                                (
                                    
                                    SELECT
                                        GC.STOCK_ID,
                                        GC.PRODUCT_ID,
                                        <cfif attributes.report_type eq 8>
                                        CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                        </cfif>
                                        1 AS INVOICE_CAT,
                                        0 AS IS_RETURN,
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
                                        GC.PROCESS_TYPE PROCESS_TYPE,
                                        ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                            SELECT TOP 1 
                                                <cfif isdefined("attributes.location_based_cost")>
                                                    <cfif isdefined("attributes.display_cost_money")>
                                                        (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                    <cfelse>
                                                        (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                                    </cfif>
                                                <cfelse>
                                                    <cfif isdefined("attributes.display_cost_money")>
                                                        (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                    <cfelse>
                                                        (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                                    </cfif>	
                                                </cfif>
                                            FROM 
                                                #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                            WHERE 
                                                START_DATE <= #finish_date# 
                                                AND PRODUCT_ID = GC.PRODUCT_ID
                                                <cfif attributes.report_type eq 8>
                                                     AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                                </cfif>
                                                <cfif IsDefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                                    AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                                </cfif>
                                                <cfif isdefined("attributes.location_based_cost")>
                                                    <cfif len(attributes.department_id)>
                                                        AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                        AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                                <cfif isdefined("attributes.location_based_cost")>
                                                    (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                                </cfif>
                                            FROM 
                                                #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                            WHERE 
                                                START_DATE <= #finish_date# 
                                                AND PRODUCT_ID = GC.PRODUCT_ID
                                                <cfif attributes.report_type eq 8>
                                                     AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                                </cfif>
                                                <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                                    AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                                </cfif>
                                                <cfif isdefined("attributes.location_based_cost")>
                                                    <cfif len(attributes.department_id)>
                                                        AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                        AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                        <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                        SHIP WITH (NOLOCK),	
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
                                        ISNULL(INVOICE.IS_RETURN,0) IS_RETURN,
                                        <cfif stock_table>
                                        S.PRODUCT_MANAGER,
                                        S.PRODUCT_CATID,
                                        S.BRAND_ID,
                                        </cfif>
                                        <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                            <cfif isdefined('attributes.is_system_money_2')>
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
                                                <cfif isdefined("attributes.location_based_cost")>
                                                    <cfif isdefined("attributes.display_cost_money")>
                                                        (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                    <cfelse>
                                                        (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                                    </cfif>
                                                <cfelse>
                                                    <cfif isdefined("attributes.display_cost_money")>
                                                        (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                    <cfelse>
                                                        (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                                    </cfif>	
                                                </cfif>
                                            FROM 
                                                #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                            WHERE 
                                                START_DATE <= #finish_date# 
                                                AND PRODUCT_ID = GC.PRODUCT_ID
                                                <cfif attributes.report_type eq 8>
                                                     AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                                </cfif>
                                                <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                                    AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                                </cfif>
                                                <cfif isdefined("attributes.location_based_cost")>
                                                    <cfif len(attributes.department_id)>
                                                        AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                        AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                                <cfif isdefined("attributes.location_based_cost")>
                                                    (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                                </cfif>
                                            FROM 
                                                #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                            WHERE 
                                                START_DATE <= #finish_date# 
                                                AND PRODUCT_ID = GC.PRODUCT_ID
                                                <cfif attributes.report_type eq 8>
                                                     AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                                </cfif>
                                                <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                                    AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                                </cfif>
                                                <cfif isdefined("attributes.location_based_cost")>
                                                    <cfif len(attributes.department_id)>
                                                        AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                        AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                        <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        INVOICE_MONEY IM,
                                        </cfif>
                                        <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                        <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                            AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                            <cfif isdefined('attributes.is_system_money_2')>
                                            AND IM.MONEY_TYPE = '#session.ep.money2#'
                                            <cfelse>
                                            AND IM.MONEY_TYPE = '#attributes.cost_money#'
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
                                </cfif>
                                ) AS 
                                GET_SHIP_ROWS
                            WHERE
                                PROCESS_TYPE IN (73,74)
                                OR INVOICE_CAT IN (54,55)
                            GROUP BY
                                #ALAN_ADI#
                            UNION ALL
                            SELECT	
                                SUM(AMOUNT) AS TOPLAM_SATIS_IADE,
                                SUM(BIRIM_COST) AS TOP_SAT_IADE_MALIYET,
                                <cfif isdefined('attributes.is_system_money_2')>
                                SUM(BIRIM_COST_2) AS TOP_SAT_IADE_MALIYET_2,
                                </cfif>
                                #ALAN_ADI# AS GROUPBY_ALANI
                            FROM
                                (
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
                                        ISNULL(I.IS_RETURN,0) IS_RETURN,
                                        <cfif isdefined('attributes.from_invoice_actions') and isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                                            <cfif isdefined('attributes.is_system_money_2')>
                                                (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                                (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                                ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST_2,
                                                ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST_2,
                                            <cfelseif attributes.cost_money is not session.ep.money>
                                                ((IR.COST_PRICE* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_COST,
                                                ((IR.EXTRA_COST* IR.AMOUNT)/(IM.RATE2/IM.RATE1)) INV_EXTRA_COST,
                                            <cfelse>
                                                (IR.COST_PRICE* IR.AMOUNT) INV_COST,
                                                (IR.EXTRA_COST* IR.AMOUNT) INV_EXTRA_COST,
                                            </cfif>
                                        </cfif>
                                        <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                            <cfif isdefined('attributes.is_system_money_2')>
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
                                        <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        ,INVOICE_MONEY IM
                                        </cfif>
                                        <cfif stock_table>
                                        ,#dsn3_alias#.STOCKS S
                                        </cfif>
                                    WHERE 
                                        I.INVOICE_ID = IR.INVOICE_ID AND
                                        <cfif not isdefined('attributes.from_invoice_actions')>
                                        I.INVOICE_CAT IN (51,54,55,59,60,61,62,63,64,65,68,690,691,591,592) AND
                                        </cfif>
                                        I.IS_IPTAL = 0 AND
                                        I.NETTOTAL > 0 AND
                                        I.INVOICE_DATE >= #attributes.date# AND 
                                        I.INVOICE_DATE <= #attributes.date2#
                                        <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                             AND I.INVOICE_ID = IM.ACTION_ID
                                            <cfif isdefined('attributes.is_system_money_2')>
                                             AND IM.MONEY_TYPE = '#session.ep.money2#'
                                            <cfelse>
                                             AND IM.MONEY_TYPE = '#attributes.cost_money#'
                                            </cfif>
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
                                 ) AS  GET_INV_PURCHASE
                            WHERE
                                PROCESS_TYPE IN (690)
                                AND IS_RETURN = 1
                            GROUP BY
                                #ALAN_ADI#
                         ) AS XXX       	
            	</cfquery>
            </cfif>
            
            <cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
                <!---konsinye_cikis--->
                <cfquery name="konsinye_cikis" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'konsinye_cikis')
                        BEGIN
                            DROP TABLE konsinye_cikis
                        END
                </cfquery>
                <cfquery name="konsinye_cikis" datasource="#dsn2#">
                    SELECT	
                        SUM(AMOUNT) AS KONS_CIKIS_MIKTAR,
                        <cfif isdefined("x_kons_cost_date") and x_kons_cost_date eq 1>
                            SUM(ALL_FINISH_COST) AS KONS_CIKIS_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(ALL_FINISH_COST_2) AS KONS_CIKIS_MALIYET_2,
                            </cfif>
                        <cfelse>	
                            SUM(TOTAL_COST) AS KONS_CIKIS_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(TOTAL_COST_2) AS KONS_CIKIS_MALIYET_2,
                            </cfif>
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI
                    INTO #dsn_report#.konsinye_cikis
                    FROM
                        (      
                             SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    1 AS INVOICE_CAT,
                                    0 AS IS_RETURN,
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
                                    GC.PROCESS_TYPE PROCESS_TYPE,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            <cfif IsDefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                                AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                            </cfif>
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                                AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                            </cfif>
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                    SHIP WITH (NOLOCK),	
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
                                    ISNULL(INVOICE.IS_RETURN,0) IS_RETURN,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
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
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                                AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                            </cfif>
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                                AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                            </cfif>
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    INVOICE_MONEY IM,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                        AND IM.MONEY_TYPE = '#attributes.cost_money#'
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
                            </cfif>	
                        )GET_SHIP_ROWS
                    WHERE
                        PROCESS_TYPE = 72
                    GROUP BY
                        #ALAN_ADI#
                    ORDER BY 
                        #ALAN_ADI#
                </cfquery>
			</cfif>
            <cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
                <!---konsinye_iade--->
                <cfquery name="konsinye_iade" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'konsinye_iade')
                        BEGIN
                            DROP TABLE konsinye_iade
                        END
                </cfquery>
                <cfquery name="konsinye_iade" datasource="#dsn2#">
                    SELECT	
                        SUM(AMOUNT) AS KONS_IADE_MIKTAR,
                        <cfif isdefined("x_kons_cost_date") and x_kons_cost_date eq 1>
                            SUM(ALL_FINISH_COST) AS KONS_IADE_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(ALL_FINISH_COST_2) AS KONS_IADE_MALIYET_2,
                            </cfif>
                        <cfelse>	
                            SUM(TOTAL_COST) AS KONS_IADE_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(TOTAL_COST_2) AS KONS_IADE_MALIYET_2,
                            </cfif>
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI
                    INTO #DSN_REPORT#.konsinye_iade
                    FROM
                        (
                            SELECT
                                GC.STOCK_ID,
                                GC.PRODUCT_ID,
                                <cfif attributes.report_type eq 8>
                                CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                </cfif>
                                1 AS INVOICE_CAT,
                                0 AS IS_RETURN,
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
                                GC.PROCESS_TYPE PROCESS_TYPE,
                                ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                    SELECT TOP 1 
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>
                                        <cfelse>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>	
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif IsDefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                SHIP WITH (NOLOCK),	
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
                                ISNULL(INVOICE.IS_RETURN,0) IS_RETURN,
                                <cfif stock_table>
                                S.PRODUCT_MANAGER,
                                S.PRODUCT_CATID,
                                S.BRAND_ID,
                                </cfif>
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    <cfif isdefined('attributes.is_system_money_2')>
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>
                                        <cfelse>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>	
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                INVOICE_MONEY IM,
                                </cfif>
                                <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    AND IM.MONEY_TYPE = '#session.ep.money2#'
                                    <cfelse>
                                    AND IM.MONEY_TYPE = '#attributes.cost_money#'
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
                        </cfif>
                        ) AS GET_SHIP_ROWS 
                        
                    WHERE
                        PROCESS_TYPE = 75
                    GROUP BY
                        #ALAN_ADI#
                    ORDER BY 
                        #ALAN_ADI#
                </cfquery>
			</cfif>
            <cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
                <!---konsinye_giris--->
                <cfquery name="konsinye_giris" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'konsinye_giris')
                        BEGIN
                            DROP TABLE konsinye_giris
                        END
                </cfquery>
                <cfquery name="konsinye_giris" datasource="#dsn2#">
                    SELECT	
                        SUM(AMOUNT) AS KONS_GIRIS_MIKTAR,
                        <cfif isdefined("x_kons_cost_date") and x_kons_cost_date eq 1>
                            SUM(ALL_FINISH_COST) AS KONS_GIRIS_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(ALL_FINISH_COST_2) AS KONS_GIRIS_MALIYET_2,
                            </cfif>
                        <cfelse>	
                            SUM(TOTAL_COST) AS KONS_GIRIS_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(TOTAL_COST_2) AS KONS_GIRIS_MALIYET_2,
                            </cfif>
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI
                    INTO #DSN_REPORT#.konsinye_giris
                    FROM
                        (       
                   		       SELECT
                            GC.STOCK_ID,
                            GC.PRODUCT_ID,
                            <cfif attributes.report_type eq 8>
                            CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                            </cfif>
                            1 AS INVOICE_CAT,
                            0 AS IS_RETURN,
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
                            GC.PROCESS_TYPE PROCESS_TYPE,
                            ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                SELECT TOP 1 
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif isdefined("attributes.display_cost_money")>
                                            (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                        </cfif>
                                    <cfelse>
                                        <cfif isdefined("attributes.display_cost_money")>
                                            (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                        </cfif>	
                                    </cfif>
                                FROM 
                                    #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                WHERE 
                                    START_DATE <= #finish_date# 
                                    AND PRODUCT_ID = GC.PRODUCT_ID
                                    <cfif attributes.report_type eq 8>
                                         AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                    </cfif>
                                    <cfif IsDefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                        AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                    </cfif>
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif len(attributes.department_id)>
                                            AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                            AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                    <cfif isdefined("attributes.location_based_cost")>
                                        (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                    <cfelse>
                                        (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                    </cfif>
                                FROM 
                                    #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                WHERE 
                                    START_DATE <= #finish_date# 
                                    AND PRODUCT_ID = GC.PRODUCT_ID
                                    <cfif attributes.report_type eq 8>
                                         AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                    </cfif>
                                    <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                        AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                    </cfif>
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif len(attributes.department_id)>
                                            AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                            AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                            <cfif is_store or isdefined("attributes.location_based_cost")>
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
                            SHIP WITH (NOLOCK),	
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
                            ISNULL(INVOICE.IS_RETURN,0) IS_RETURN,
                            <cfif stock_table>
                            S.PRODUCT_MANAGER,
                            S.PRODUCT_CATID,
                            S.BRAND_ID,
                            </cfif>
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                <cfif isdefined('attributes.is_system_money_2')>
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
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif isdefined("attributes.display_cost_money")>
                                            (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                        </cfif>
                                    <cfelse>
                                        <cfif isdefined("attributes.display_cost_money")>
                                            (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                        </cfif>	
                                    </cfif>
                                FROM 
                                    #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                WHERE 
                                    START_DATE <= #finish_date# 
                                    AND PRODUCT_ID = GC.PRODUCT_ID
                                    <cfif attributes.report_type eq 8>
                                         AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                    </cfif>
                                    <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                        AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                    </cfif>
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif len(attributes.department_id)>
                                            AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                            AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                    <cfif isdefined("attributes.location_based_cost")>
                                        (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                    <cfelse>
                                        (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                    </cfif>
                                FROM 
                                    #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                WHERE 
                                    START_DATE <= #finish_date# 
                                    AND PRODUCT_ID = GC.PRODUCT_ID
                                    <cfif attributes.report_type eq 8>
                                         AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                    </cfif>
                                    <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                        AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                    </cfif>
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif len(attributes.department_id)>
                                            AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                            AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                            INVOICE_MONEY IM,
                            </cfif>
                            <cfif is_store or isdefined("attributes.location_based_cost")>
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
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                <cfif isdefined('attributes.is_system_money_2')>
                                AND IM.MONEY_TYPE = '#session.ep.money2#'
                                <cfelse>
                                AND IM.MONEY_TYPE = '#attributes.cost_money#'
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
                    </cfif>
                        ) AS GET_SHIP_ROWS
                    WHERE
                        PROCESS_TYPE = 77
                    GROUP BY
                        #ALAN_ADI#
                    ORDER BY 
                        #ALAN_ADI#
                </cfquery>
			</cfif>
            <cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
                <!---konsinye_giris_iade--->
                <cfquery name="konsinye_giris_iade" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'konsinye_giris_iade')
                        BEGIN
                            DROP TABLE konsinye_giris_iade
                        END
                </cfquery>
                <cfquery name="konsinye_giris_iade" datasource="#dsn2#">
                    SELECT	
                        SUM(AMOUNT) AS KONS_GIRIS_IADE_MIKTAR,
                        <cfif isdefined("x_kons_cost_date") and x_kons_cost_date eq 1>
                            SUM(ALL_FINISH_COST) AS KONS_GIRIS_IADE_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(ALL_FINISH_COST_2) AS KONS_GIRIS_IADE_MALIYET_2,
                            </cfif>
                        <cfelse>	
                            SUM(TOTAL_COST) AS KONS_GIRIS_IADE_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(TOTAL_COST_2) AS KONS_GIRIS_IADE_MALIYET_2,
                            </cfif>
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI
                    INTO #DSN_REPORT#.konsinye_giris_iade
                    FROM
                        (      
                       	    SELECT
                            GC.STOCK_ID,
                            GC.PRODUCT_ID,
                            <cfif attributes.report_type eq 8>
                            CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                            </cfif>
                            1 AS INVOICE_CAT,
                            0 AS IS_RETURN,
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
                            GC.PROCESS_TYPE PROCESS_TYPE,
                            ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                SELECT TOP 1 
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif isdefined("attributes.display_cost_money")>
                                            (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                        </cfif>
                                    <cfelse>
                                        <cfif isdefined("attributes.display_cost_money")>
                                            (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                        </cfif>	
                                    </cfif>
                                FROM 
                                    #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                WHERE 
                                    START_DATE <= #finish_date# 
                                    AND PRODUCT_ID = GC.PRODUCT_ID
                                    <cfif attributes.report_type eq 8>
                                         AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                    </cfif>
                                    <cfif IsDefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                        AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                    </cfif>
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif len(attributes.department_id)>
                                            AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                            AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                    <cfif isdefined("attributes.location_based_cost")>
                                        (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                    <cfelse>
                                        (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                    </cfif>
                                FROM 
                                    #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                WHERE 
                                    START_DATE <= #finish_date# 
                                    AND PRODUCT_ID = GC.PRODUCT_ID
                                    <cfif attributes.report_type eq 8>
                                         AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                    </cfif>
                                    <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                        AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                    </cfif>
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif len(attributes.department_id)>
                                            AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                            AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                            <cfif is_store or isdefined("attributes.location_based_cost")>
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
                            SHIP WITH (NOLOCK),	
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
                            ISNULL(INVOICE.IS_RETURN,0) IS_RETURN,
                            <cfif stock_table>
                            S.PRODUCT_MANAGER,
                            S.PRODUCT_CATID,
                            S.BRAND_ID,
                            </cfif>
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                <cfif isdefined('attributes.is_system_money_2')>
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
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif isdefined("attributes.display_cost_money")>
                                            (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                        </cfif>
                                    <cfelse>
                                        <cfif isdefined("attributes.display_cost_money")>
                                            (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                        </cfif>	
                                    </cfif>
                                FROM 
                                    #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                WHERE 
                                    START_DATE <= #finish_date# 
                                    AND PRODUCT_ID = GC.PRODUCT_ID
                                    <cfif attributes.report_type eq 8>
                                         AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                    </cfif>
                                    <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                        AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                    </cfif>
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif len(attributes.department_id)>
                                            AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                            AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                    <cfif isdefined("attributes.location_based_cost")>
                                        (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                    <cfelse>
                                        (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                    </cfif>
                                FROM 
                                    #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                WHERE 
                                    START_DATE <= #finish_date# 
                                    AND PRODUCT_ID = GC.PRODUCT_ID
                                    <cfif attributes.report_type eq 8>
                                         AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                    </cfif>
                                    <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                        AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                    </cfif>
                                    <cfif isdefined("attributes.location_based_cost")>
                                        <cfif len(attributes.department_id)>
                                            AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                            AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                            INVOICE_MONEY IM,
                            </cfif>
                            <cfif is_store or isdefined("attributes.location_based_cost")>
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
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                <cfif isdefined('attributes.is_system_money_2')>
                                AND IM.MONEY_TYPE = '#session.ep.money2#'
                                <cfelse>
                                AND IM.MONEY_TYPE = '#attributes.cost_money#'
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
                    </cfif>
                        ) AS GET_SHIP_ROWS
                    WHERE
                        PROCESS_TYPE = 79
                    GROUP BY
                        #ALAN_ADI#
                    ORDER BY 
                        #ALAN_ADI#
                </cfquery>
			</cfif>
            <cfif len(attributes.process_type) and listfind(attributes.process_type,8)>
                <!---servis_giris--->
                <cfquery name="servis_giris" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'servis_giris')
                        BEGIN
                            DROP TABLE servis_giris
                        END
                </cfquery>
                <cfquery name="servis_giris" datasource="#dsn2#">
                    SELECT	
                        SUM(AMOUNT) AS SERVIS_GIRIS_MIKTAR,
                        SUM(TOTAL_COST) AS SERVIS_GIRIS_MALIYET,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(TOTAL_COST) AS SERVIS_GIRIS_MALIYET_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI
                    INTO #DSN_REPORT#.servis_giris
                    FROM
                        (       
                            SELECT
                                GC.STOCK_ID,
                                GC.PRODUCT_ID,
                                <cfif attributes.report_type eq 8>
                                CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                </cfif>
                                1 AS INVOICE_CAT,
                                0 AS IS_RETURN,
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
                                GC.PROCESS_TYPE PROCESS_TYPE,
                                ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                    SELECT TOP 1 
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>
                                        <cfelse>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>	
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif IsDefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                SHIP WITH (NOLOCK),	
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
                                ISNULL(INVOICE.IS_RETURN,0) IS_RETURN,
                                <cfif stock_table>
                                S.PRODUCT_MANAGER,
                                S.PRODUCT_CATID,
                                S.BRAND_ID,
                                </cfif>
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    <cfif isdefined('attributes.is_system_money_2')>
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>
                                        <cfelse>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>	
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                INVOICE_MONEY IM,
                                </cfif>
                                <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    AND IM.MONEY_TYPE = '#session.ep.money2#'
                                    <cfelse>
                                    AND IM.MONEY_TYPE = '#attributes.cost_money#'
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
                        </cfif>
                        ) AS 
                        GET_SHIP_ROWS
                    WHERE
                        PROCESS_TYPE = 140
                    GROUP BY
                        #ALAN_ADI#
                    ORDER BY 
                        #ALAN_ADI#
                </cfquery>
			</cfif>
            <cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
                <!---servis_cikis--->
                <cfquery name="servis_cikis" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'servis_cikis')
                        BEGIN
                            DROP TABLE servis_cikis
                        END
                </cfquery>
                <cfquery name="servis_cikis" datasource="#DSN2#">
                    SELECT	
                        SUM(AMOUNT) AS SERVIS_CIKIS_MIKTAR,
                        SUM(TOTAL_COST) AS SERVIS_CIKIS_MALIYET,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(TOTAL_COST_2) AS SERVIS_CIKIS_MALIYET_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI
                    INTO #DSN_REPORT#.servis_cikis
                    FROM
                        (     
                             SELECT
                                    GC.STOCK_ID,
                                    GC.PRODUCT_ID,
                                    <cfif attributes.report_type eq 8>
                                    CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                    </cfif>
                                    1 AS INVOICE_CAT,
                                    0 AS IS_RETURN,
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
                                    GC.PROCESS_TYPE PROCESS_TYPE,
                                    ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                        SELECT TOP 1 
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            <cfif IsDefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                                AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                            </cfif>
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                                AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                            </cfif>
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                    SHIP WITH (NOLOCK),	
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
                                    ISNULL(INVOICE.IS_RETURN,0) IS_RETURN,
                                    <cfif stock_table>
                                    S.PRODUCT_MANAGER,
                                    S.PRODUCT_CATID,
                                    S.BRAND_ID,
                                    </cfif>
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')>
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
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                                </cfif>
                                            <cfelse>
                                                <cfif isdefined("attributes.display_cost_money")>
                                                    (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                                <cfelse>
                                                    (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                                </cfif>	
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                                AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                            </cfif>
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                            <cfif isdefined("attributes.location_based_cost")>
                                                (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                            </cfif>
                                        FROM 
                                            #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                        WHERE 
                                            START_DATE <= #finish_date# 
                                            AND PRODUCT_ID = GC.PRODUCT_ID
                                            <cfif attributes.report_type eq 8>
                                                 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                            </cfif>
                                            <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                                AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                            </cfif>
                                            <cfif isdefined("attributes.location_based_cost")>
                                                <cfif len(attributes.department_id)>
                                                    AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    INVOICE_MONEY IM,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        AND IM.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                        AND IM.MONEY_TYPE = '#attributes.cost_money#'
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
                            </cfif>
                        ) AS 
                        GET_SHIP_ROWS
                    WHERE
                        PROCESS_TYPE = 141
                    GROUP BY
                        #ALAN_ADI#
                    ORDER BY 
                        #ALAN_ADI#
                </cfquery>
			</cfif>
            <cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
                <!---rma_giris--->
                <cfquery name="rma_giris" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'rma_giris')
                        BEGIN
                            DROP TABLE rma_giris
                        END
                </cfquery>
                <cfquery name="rma_giris" datasource="#dsn2#">
                    SELECT	
                        SUM(AMOUNT) AS RMA_GIRIS_MIKTAR,
                        SUM(TOTAL_COST) AS RMA_GIRIS_MALIYET,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(TOTAL_COST_2) AS RMA_GIRIS_MALIYET_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI
                    INTO #DSN_REPORT#.rma_giris
                    FROM
                        (      
                            SELECT
                                GC.STOCK_ID,
                                GC.PRODUCT_ID,
                                <cfif attributes.report_type eq 8>
                                CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                </cfif>
                                1 AS INVOICE_CAT,
                                0 AS IS_RETURN,
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
                                GC.PROCESS_TYPE PROCESS_TYPE,
                                ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                    SELECT TOP 1 
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>
                                        <cfelse>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>	
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif IsDefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                SHIP WITH (NOLOCK),	
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
                                ISNULL(INVOICE.IS_RETURN,0) IS_RETURN,
                                <cfif stock_table>
                                S.PRODUCT_MANAGER,
                                S.PRODUCT_CATID,
                                S.BRAND_ID,
                                </cfif>
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    <cfif isdefined('attributes.is_system_money_2')>
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>
                                        <cfelse>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>	
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                INVOICE_MONEY IM,
                                </cfif>
                                <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    AND IM.MONEY_TYPE = '#session.ep.money2#'
                                    <cfelse>
                                    AND IM.MONEY_TYPE = '#attributes.cost_money#'
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
                        </cfif>	
                        ) AS
                        GET_SHIP_ROWS
                    WHERE
                        PROCESS_TYPE = 86
                    GROUP BY
                        #ALAN_ADI#
                    ORDER BY 
                        #ALAN_ADI#
                </cfquery>
			</cfif>
            <cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
                <!---rma_cikis--->
                <cfquery name="rma_cikis" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'rma_cikis')
                        BEGIN
                            DROP TABLE rma_cikis
                        END
                </cfquery>
                <cfquery name="rma_cikis" datasource="#dsn2#">
                    SELECT	
                        SUM(AMOUNT) AS RMA_CIKIS_MIKTAR,
                        SUM(TOTAL_COST) AS RMA_CIKIS_MALIYET,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(TOTAL_COST_2) AS RMA_CIKIS_MALIYET_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI
                    INTO #dsn_report#.rma_cikis
                    FROM
                        (     
                            SELECT
                                GC.STOCK_ID,
                                GC.PRODUCT_ID,
                                <cfif attributes.report_type eq 8>
                                CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                                </cfif>
                                1 AS INVOICE_CAT,
                                0 AS IS_RETURN,
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
                                GC.PROCESS_TYPE PROCESS_TYPE,
                                ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                                    SELECT TOP 1 
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>
                                        <cfelse>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>	
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif IsDefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                SHIP WITH (NOLOCK),	
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
                                ISNULL(INVOICE.IS_RETURN,0) IS_RETURN,
                                <cfif stock_table>
                                S.PRODUCT_MANAGER,
                                S.PRODUCT_CATID,
                                S.BRAND_ID,
                                </cfif>
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    <cfif isdefined('attributes.is_system_money_2')>
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET_LOCATION+PURCHASE_EXTRA_COST_LOCATION)
                                            <cfelse>

                                                (PURCHASE_NET_SYSTEM_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_LOCATION+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>
                                        <cfelse>
                                            <cfif isdefined("attributes.display_cost_money")>
                                                (PURCHASE_NET+PURCHASE_EXTRA_COST)
                                            <cfelse>
                                                (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PRICE_PROTECTION,0)+ISNULL(PRICE_PROTECTION_LOCATION,0))
                                            </cfif>	
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                        <cfif isdefined("attributes.location_based_cost")>
                                            (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                        <cfelse>
                                            (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                                        </cfif>
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                                    WHERE 
                                        START_DATE <= #finish_date# 
                                        AND PRODUCT_ID = GC.PRODUCT_ID
                                        <cfif attributes.report_type eq 8>
                                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                                        </cfif>
                                        <cfif isdefined("session.ep.our_company_info.is_stock_based_cost") and session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                                            AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                                        </cfif>
                                        <cfif isdefined("attributes.location_based_cost")>
                                            <cfif len(attributes.department_id)>
                                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                                AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
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
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                INVOICE_MONEY IM,
                                </cfif>
                                <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    AND IM.ACTION_ID=INVOICE.INVOICE_ID
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    AND IM.MONEY_TYPE = '#session.ep.money2#'
                                    <cfelse>
                                    AND IM.MONEY_TYPE = '#attributes.cost_money#'
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
                        </cfif>
                        ) AS
                        GET_SHIP_ROWS
                    WHERE
                        PROCESS_TYPE = 85
                    GROUP BY
                        #ALAN_ADI#
                    ORDER BY 
                        #ALAN_ADI#
                </cfquery>
			</cfif>
            <cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
                <!---donemici_uretim--->
                <cfquery name="donemici_uretim" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'donemici_uretim')
                        BEGIN
                            DROP TABLE donemici_uretim
                        END
                </cfquery>
                <cfquery name="donemici_uretim" datasource="#dsn2#">
                    SELECT	
                        SUM(AMOUNT) AS TOPLAM_URETIM,
                        SUM(TOTAL_COST) AS URETIM_MALIYET,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(TOTAL_COST_2) AS URETIM_MALIYET_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI
                    INTO #DSN_REPORT#.donemici_uretim
                    FROM
                        (
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
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    <cfif isdefined('attributes.is_system_money_2')> <!---  sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir  --->
                                    GC.MALIYET MALIYET,
                                    GC.MALIYET_2 MALIYET_2,
                                    (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE, <!---uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
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
                                <cfif attributes.report_type eq 8>
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
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                STOCK_FIS_MONEY SF_M,
                                </cfif>
                                <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                SF.FIS_DATE >= #attributes.date# AND
                                <cfif attributes.report_type eq 8>
                                ISNULL((SELECT SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SFR.SPECT_VAR_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
                                </cfif>
                                SF.FIS_DATE <= #attributes.date2#
                                <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                     AND SF.FIS_ID = SF_M.ACTION_ID
                                    <cfif isdefined('attributes.is_system_money_2')>
                                     AND SF_M.MONEY_TYPE = '#session.ep.money2#'
                                    <cfelse>
                                     AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                    </cfif>
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
                        ) as
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
                <!---donemici_masraf--->
                <cfquery name="donemici_masraf" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'donemici_masraf')
                        BEGIN
                            DROP TABLE donemici_masraf
                        END
                </cfquery>
                <cfquery name="donemici_masraf" datasource="#DSN2#"> <!--- uretimle ilgisi olmayan sarflar --->
                    SELECT	
                        SUM(AMOUNT) AS TOPLAM_MASRAF_MIKTAR,
                        SUM(MALIYET*AMOUNT) AS MASRAF_MALIYET,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(MALIYET_2*AMOUNT) AS MASRAF_MALIYET_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI			
                    INTO #DSN_REPORT#.donemici_masraf
                    FROM
                        (
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
                        )
                         AS GET_EXPENSE
                    WHERE
                        ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
                    GROUP BY
                        #ALAN_ADI#			
                    ORDER BY
                        #ALAN_ADI#			
                </cfquery>
			</cfif>
            <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
                <!---get_ambar_fis_total_in--->
                <cfquery name="get_ambar_fis_total_in" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'get_ambar_fis_total_in')
                        BEGIN
                            DROP TABLE get_ambar_fis_total_in
                        END
                </cfquery>
                <cfquery name="get_ambar_fis_total_in" datasource="#dsn2#">
                    SELECT 
                        SUM(STOCK_IN) AS AMBAR_FIS_GIRIS_MIKTARI,
                        SUM(STOCK_IN*MALIYET) AS AMBAR_FIS_GIRIS_MALIYETI,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(STOCK_IN*MALIYET_2) AS AMBAR_FIS_GIRIS_MALIYETI_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI
                    INTO #dsn_report#.get_ambar_fis_total_in
                    FROM
                        (
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
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')> <!---  sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir  --->
                                        GC.MALIYET MALIYET,
                                        GC.MALIYET_2 MALIYET_2,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE, <!---uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
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
                                    <cfif attributes.report_type eq 8>
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
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    STOCK_FIS_MONEY SF_M,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                    SF.FIS_DATE >= #attributes.date# AND
                                    <cfif attributes.report_type eq 8>
                                    ISNULL((SELECT SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SFR.SPECT_VAR_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
                                    </cfif>
                                    SF.FIS_DATE <= #attributes.date2#
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                         AND SF.FIS_ID = SF_M.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                         AND SF_M.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                         AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
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
                        )
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
                
                <!---get_ambar_fis_total_out--->
                <cfquery name="get_ambar_fis_total_out" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'get_ambar_fis_total_out')
                        BEGIN
                            DROP TABLE get_ambar_fis_total_out
                        END
                </cfquery>
                <cfquery name="get_ambar_fis_total_out" datasource="#dsn2#">
                    SELECT 
                        SUM(STOCK_OUT) AS AMBAR_FIS_CIKIS_MIKTARI,
                        SUM(STOCK_OUT*MALIYET) AS AMBAR_FIS_CIKIS_MALIYET,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(STOCK_OUT*MALIYET_2) AS AMBAR_FIS_CIKIS_MALIYET_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI
                    INTO #dsn_report#.get_ambar_fis_total_out
                    FROM
                        (
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
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                        <cfif isdefined('attributes.is_system_money_2')> <!---  sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir  --->
                                        GC.MALIYET MALIYET,
                                        GC.MALIYET_2 MALIYET_2,
                                        (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE, <!---uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
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
                                    <cfif attributes.report_type eq 8>
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
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                    STOCK_FIS_MONEY SF_M,
                                    </cfif>
                                    <cfif is_store or isdefined("attributes.location_based_cost")>
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
                                    SF.FIS_DATE >= #attributes.date# AND
                                    <cfif attributes.report_type eq 8>
                                    ISNULL((SELECT SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SFR.SPECT_VAR_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
                                    </cfif>
                                    SF.FIS_DATE <= #attributes.date2#
                                    <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                         AND SF.FIS_ID = SF_M.ACTION_ID
                                        <cfif isdefined('attributes.is_system_money_2')>
                                         AND SF_M.MONEY_TYPE = '#session.ep.money2#'
                                        <cfelse>
                                         AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                        </cfif>
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
                        )
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
            <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,21)>
                <!---get_stok_virman_total_in--->
                <cfquery name="get_stok_virman_total_in" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'get_stok_virman_total_in')
                        BEGIN
                            DROP TABLE get_stok_virman_total_in
                        END
                </cfquery>
                <cfquery name="get_stok_virman_total_in" datasource="#dsn2#">
                    SELECT 
                        SUM(STOCK_IN) AS STOK_VIRMAN_GIRIS_MIKTARI,
                        SUM(STOCK_IN*MALIYET) AS STOK_VIRMAN_GIRIS_MALIYETI,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(STOCK_IN*MALIYET_2) AS STOK_VIRMAN_GIRIS_MALIYETI_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI
                    INTO #DSN_REPORT#.get_stok_virman_total_in
                    FROM
                        (
                        	SELECT
                            GC.PRODUCT_ID,
                            GC.STOCK_ID,
                            <cfif stock_table>
                                S.PRODUCT_CATID,
                                S.BRAND_ID,
                            </cfif>
                            SF.AMOUNT AMOUNT,
                            SF.DEPARTMENT_ID DEPARTMENT_IN,
                            SF.EXIT_DEPARTMENT_ID DEPARTMENT_OUT,
                            SF.LOCATION_ID LOCATION_IN,
                            SF.EXIT_LOCATION_ID LOCATION_OUT,
                            GC.STOCK_IN,
                            GC.STOCK_OUT,
                            ((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
                            (GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                <cfif isdefined('attributes.is_system_money_2')>
                                GC.MALIYET MALIYET,
                                GC.MALIYET_2 MALIYET_2,
                                (SF.EXIT_AMOUNT*GC.MALIYET) AS TOTAL_COST_PRICE,
                                0 AS TOTAL_EXTRA_COST,
                                (SF.EXIT_AMOUNT*GC.MALIYET_2) AS TOTAL_COST_PRICE_2,
                                0 AS TOTAL_EXTRA_COST_2,
                                <cfelse>
                                    (GC.MALIYET) MALIYET,
                                    (SF.EXIT_AMOUNT*GC.MALIYET) AS TOTAL_COST_PRICE,
                                    0 AS TOTAL_EXTRA_COST,
                                </cfif>
                            <cfelse>
                                (GC.MALIYET) MALIYET,
                                (SF.EXIT_AMOUNT*GC.MALIYET) AS TOTAL_COST_PRICE,
                                0 AS TOTAL_EXTRA_COST,
                            </cfif>
                            <cfif attributes.report_type eq 8>
                            CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                            </cfif>
                            SF.PROCESS_DATE ISLEM_TARIHI,
                            SF.PROCESS_CAT,
                            SF.PROCESS_TYPE,
                            0 AS PROD_ORDER_NUMBER,
                            0 AS PROD_ORDER_RESULT_NUMBER
                        FROM 
                            STOCK_EXCHANGE SF WITH (NOLOCK),
                            <cfif is_store or isdefined("attributes.location_based_cost")>
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
                            ,#dsn3_alias#.STOCKS S WITH (NOLOCK)
                            </cfif>
                        WHERE 
                            GC.UPD_ID = SF.STOCK_EXCHANGE_ID AND
                            GC.PROCESS_TYPE = SF.PROCESS_TYPE AND
                            <cfif stock_table>
                            S.STOCK_ID = GC.STOCK_ID AND
                            </cfif>
                            GC.STOCK_ID=SF.STOCK_ID AND
                            SF.PROCESS_DATE >= #attributes.date# AND
                            <cfif attributes.report_type eq 8>
                            ISNULL((SELECT SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SF.SPECT_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
                            </cfif>
                            SF.PROCESS_DATE <= #attributes.date2#
                            <cfif len(attributes.department_id)>
                            AND
                            (
                                SF.DEPARTMENT_ID IS NOT NULL AND
                                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                (SF.DEPARTMENT_ID = #listfirst(dept_i,'-')# AND SF.LOCATION_ID = #listlast(dept_i,'-')#)
                                <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                </cfloop>  
                            )
                            <cfelseif is_store>
                                AND SF.DEPARTMENT_ID IN (#branch_dep_list#)
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
                        ) AS 
                        GET_STOCK_VIRMAN_IN
                    WHERE
                        ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
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
                
                <!---get_stok_virman_total_out--->
                <cfquery name="get_stok_virman_total_out" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'get_stok_virman_total_out')
                        BEGIN
                            DROP TABLE get_stok_virman_total_out
                        END
                </cfquery>
                <cfquery name="get_stok_virman_total_out" datasource="#dsn2#">
                    SELECT 
                        SUM(STOCK_OUT) AS STOK_VIRMAN_CIKIS_MIKTARI,
                        SUM(STOCK_OUT*MALIYET) AS STOK_VIRMAN_CIKIS_MALIYET,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(STOCK_OUT*MALIYET_2) AS STOK_VIRMAN_CIKIS_MALIYET_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI
                    INTO #DSN_REPORT#.get_stok_virman_total_out
                    FROM
                        (
						   SELECT
						GC.PRODUCT_ID,
						GC.STOCK_ID,
						<cfif stock_table>
                            S.PRODUCT_CATID,
                            S.BRAND_ID,
						</cfif>
						SF.EXIT_AMOUNT AMOUNT,
						SF.DEPARTMENT_ID DEPARTMENT_IN,
						SF.EXIT_DEPARTMENT_ID DEPARTMENT_OUT,
						SF.LOCATION_ID LOCATION_IN,
						SF.EXIT_LOCATION_ID LOCATION_OUT,
						GC.STOCK_IN,
						GC.STOCK_OUT,
						((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
						(GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
						<cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
							<cfif isdefined('attributes.is_system_money_2')>
							GC.MALIYET MALIYET,
							GC.MALIYET_2 MALIYET_2,
							(SF.EXIT_AMOUNT*GC.MALIYET) AS TOTAL_COST_PRICE,
							0 AS TOTAL_EXTRA_COST,
							(SF.EXIT_AMOUNT*GC.MALIYET_2) AS TOTAL_COST_PRICE_2,
							0 AS TOTAL_EXTRA_COST_2,
							<cfelse>
								(GC.MALIYET) MALIYET,
								(SF.EXIT_AMOUNT*GC.MALIYET) AS TOTAL_COST_PRICE,
								0 AS TOTAL_EXTRA_COST,
							</cfif>
						<cfelse>
							(GC.MALIYET) MALIYET,
							(SF.EXIT_AMOUNT*GC.MALIYET) AS TOTAL_COST_PRICE,
							0 AS TOTAL_EXTRA_COST,
						</cfif>
						<cfif attributes.report_type eq 8>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
						SF.PROCESS_DATE ISLEM_TARIHI,
						SF.PROCESS_CAT,
						SF.PROCESS_TYPE,
						0 AS PROD_ORDER_NUMBER,
						0 AS PROD_ORDER_RESULT_NUMBER
                    FROM 
						STOCK_EXCHANGE SF WITH (NOLOCK),
						<cfif is_store or isdefined("attributes.location_based_cost")>
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
						,#dsn3_alias#.STOCKS S WITH (NOLOCK)
						</cfif>
					WHERE 
						GC.UPD_ID = SF.STOCK_EXCHANGE_ID AND
						GC.PROCESS_TYPE = SF.PROCESS_TYPE AND
						<cfif stock_table>
						S.STOCK_ID = GC.STOCK_ID AND
						</cfif>
						GC.STOCK_ID=SF.EXIT_STOCK_ID AND
						SF.PROCESS_DATE >= #attributes.date# AND
						<cfif attributes.report_type eq 8>
						ISNULL((SELECT SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SF.EXIT_SPECT_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
						</cfif>
						SF.PROCESS_DATE <= #attributes.date2#
						<cfif len(attributes.department_id)>
						AND
						(
							SF.EXIT_DEPARTMENT_ID IS NOT NULL AND
							<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(SF.EXIT_DEPARTMENT_ID = #listfirst(dept_i,'-')# AND SF.EXIT_LOCATION_ID = #listlast(dept_i,'-')#)
							<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
							</cfloop>  
						)
						<cfelseif is_store>
							AND SF.EXIT_DEPARTMENT_ID IN (#branch_dep_list#)
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
                        ) AS 
                        GET_STOCK_VIRMAN_OUT
                    WHERE
                        ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
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
            
            <cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
                <!---donemici_sarf--->
                <cfquery name="donemici_sarf" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'donemici_sarf')
                        BEGIN
                            DROP TABLE donemici_sarf
                        END
                </cfquery>
                <cfquery name="donemici_sarf" datasource="#dsn2#"> <!--- uretimle ilgisi olmayan sarflar --->
                    SELECT	
                        SUM(AMOUNT) AS TOPLAM_SARF,
                        SUM(MALIYET*AMOUNT) AS SARF_MALIYET,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(MALIYET_2*AMOUNT) AS SARF_MALIYET_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI			
                    INTO #dsn_report#.donemici_sarf
                    FROM
                        (
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
						<cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
							<cfif isdefined('attributes.is_system_money_2')> <!---  sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir  --->
							GC.MALIYET MALIYET,
							GC.MALIYET_2 MALIYET_2,
							(SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE, <!---uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
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
						<cfif attributes.report_type eq 8>
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
						<cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
						STOCK_FIS_MONEY SF_M,
						</cfif>
						<cfif is_store or isdefined("attributes.location_based_cost")>
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
						SF.FIS_DATE >= #attributes.date# AND
						<cfif attributes.report_type eq 8>
						ISNULL((SELECT SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SFR.SPECT_VAR_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
						</cfif>
						SF.FIS_DATE <= #attributes.date2#
						<cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
							 AND SF.FIS_ID = SF_M.ACTION_ID
							<cfif isdefined('attributes.is_system_money_2')>
							 AND SF_M.MONEY_TYPE = '#session.ep.money2#'
							<cfelse>
							 AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
							</cfif>
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
                        )as
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
                
                <!---donemici_production_sarf--->
                <cfquery name="donemici_production_sarf" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'donemici_production_sarf')
                        BEGIN
                            DROP TABLE donemici_production_sarf
                        END
                </cfquery>
                <cfquery name="donemici_production_sarf" datasource="#dsn2#"> <!--- üretim sarfları--->
                    SELECT	
                        SUM(AMOUNT) AS TOPLAM_URETIM_SARF,
                        SUM(MALIYET*AMOUNT) AS URETIM_SARF_MALIYET,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(MALIYET_2*AMOUNT) AS URETIM_SARF_MALIYET_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI			
                    INTO #dsn_report#.donemici_production_sarf
                    FROM
                        (
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
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                <cfif isdefined('attributes.is_system_money_2')> <!---  sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir  --->
                                GC.MALIYET MALIYET,
                                GC.MALIYET_2 MALIYET_2,
                                (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE, <!---uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
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
                            <cfif attributes.report_type eq 8>
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
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                            STOCK_FIS_MONEY SF_M,
                            </cfif>
                            <cfif is_store or isdefined("attributes.location_based_cost")>
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
                            SF.FIS_DATE >= #attributes.date# AND
                            <cfif attributes.report_type eq 8>
                            ISNULL((SELECT SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SFR.SPECT_VAR_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
                            </cfif>
                            SF.FIS_DATE <= #attributes.date2#
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                 AND SF.FIS_ID = SF_M.ACTION_ID
                                <cfif isdefined('attributes.is_system_money_2')>
                                 AND SF_M.MONEY_TYPE = '#session.ep.money2#'
                                <cfelse>
                                 AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                </cfif>
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
                        )as  GET_STOCK_FIS
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
            	<!---donemici_fire--->
                <cfquery name="donemici_fire" datasource="#dsn_report#">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'donemici_fire')
                        BEGIN
                            DROP TABLE donemici_fire
                        END
                </cfquery>
                <cfquery name="donemici_fire" datasource="#dsn2#">
                    SELECT	
                        SUM(AMOUNT) AS TOPLAM_FIRE,
                        SUM(MALIYET*AMOUNT) AS FIRE_MALIYET,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(MALIYET_2*AMOUNT) AS FIRE_MALIYET_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI			
                    INTO #DSN_REPORT#.donemici_fire
                    FROM
                         (
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
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                <cfif isdefined('attributes.is_system_money_2')> <!---  sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir  --->
                                GC.MALIYET MALIYET,
                                GC.MALIYET_2 MALIYET_2,
                                (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE, <!---uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
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
                            <cfif attributes.report_type eq 8>
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
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                            STOCK_FIS_MONEY SF_M,
                            </cfif>
                            <cfif is_store or isdefined("attributes.location_based_cost")>
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
                            SF.FIS_DATE >= #attributes.date# AND
                            <cfif attributes.report_type eq 8>
                            ISNULL((SELECT SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SFR.SPECT_VAR_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
                            </cfif>
                            SF.FIS_DATE <= #attributes.date2#
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                 AND SF.FIS_ID = SF_M.ACTION_ID
                                <cfif isdefined('attributes.is_system_money_2')>
                                 AND SF_M.MONEY_TYPE = '#session.ep.money2#'
                                <cfelse>
                                 AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                </cfif>
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
                        )as  GET_STOCK_FIS
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
            
            <cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
                <!---donemici_demontaj_giris--->
                <cfquery name="donemici_demontaj_giris" datasource="#dsn_report#">
                        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'donemici_demontaj_giris')
                            BEGIN
                                DROP TABLE donemici_demontaj_giris
                            END
                </cfquery>
                <cfquery name="donemici_demontaj_giris" datasource="#dsn2#">
                    SELECT	
                        SUM(AMOUNT) AS DEMONTAJ_GIRIS,
                        SUM(MALIYET*AMOUNT) AS DEMONTAJ_GIRIS_MALIYET,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(MALIYET_2*AMOUNT) AS DEMONTAJ_GIRIS_MALIYET_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI			
                    INTO #dsn_report#.donemici_demontaj_giris
                    FROM
                         (
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
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                <cfif isdefined('attributes.is_system_money_2')> <!---  sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir  --->
                                GC.MALIYET MALIYET,
                                GC.MALIYET_2 MALIYET_2,
                                (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE, <!---uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
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
                            <cfif attributes.report_type eq 8>
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
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                            STOCK_FIS_MONEY SF_M,
                            </cfif>
                            <cfif is_store or isdefined("attributes.location_based_cost")>
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
                            SF.FIS_DATE >= #attributes.date# AND
                            <cfif attributes.report_type eq 8>
                            ISNULL((SELECT SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SFR.SPECT_VAR_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
                            </cfif>
                            SF.FIS_DATE <= #attributes.date2#
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                 AND SF.FIS_ID = SF_M.ACTION_ID
                                <cfif isdefined('attributes.is_system_money_2')>
                                 AND SF_M.MONEY_TYPE = '#session.ep.money2#'
                                <cfelse>
                                 AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                </cfif>
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
                        )as  GET_STOCK_FIS
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
            <cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
				<!---demontaj_giden--->
                <cfquery name="demontaj_giden" datasource="#dsn_report#">
                        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'demontaj_giden')
                            BEGIN
                                DROP TABLE demontaj_giden
                            END
                </cfquery>
                <cfquery name="demontaj_giden" datasource="#dsn2#">
				SELECT	
					(SUM(STOCK_IN)-SUM(STOCK_OUT)) AS DEMONTAJ_GIDEN,
					SUM((STOCK_IN-STOCK_OUT)*MALIYET) AS DEMONTAJ_GIDEN_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM((STOCK_IN-STOCK_OUT)*MALIYET_2) AS DEMONTAJ_GIDEN_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI			
				INTO #DSN_REPORT#.demontaj_giden
                FROM
					(
                      SELECT
                            GC.PRODUCT_ID,
                            GC.STOCK_ID,
                            <cfif stock_table>
                            S.PRODUCT_CATID,
                            S.BRAND_ID,
                            </cfif>
                            GC.STOCK_IN,
                            GC.STOCK_OUT,
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                <cfif isdefined('attributes.is_system_money_2')>
                                GC.MALIYET MALIYET,
                                GC.MALIYET_2 MALIYET_2,
                                <cfelse>
                                (GC.MALIYET/(SF_M.RATE2/SF_M.RATE1)) MALIYET,
                                </cfif>
                            <cfelse>
                                (GC.MALIYET) MALIYET,
                            </cfif>
                            <cfif attributes.report_type eq 8>
                            CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
                            </cfif>
                            SF.FIS_DATE ISLEM_TARIHI,
                            SF.FIS_TYPE PROCESS_TYPE
                        FROM 
                            STOCK_FIS SF,
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                            STOCK_FIS_MONEY SF_M,
                            </cfif>
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
                            GC.PROCESS_TYPE = SF.FIS_TYPE AND
                            SF.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND
                            SF.PROD_ORDER_NUMBER IS NOT NULL AND
                            PO.IS_DEMONTAJ = 1 AND 
                            <cfif stock_table>
                            S.STOCK_ID = GC.STOCK_ID AND
                            </cfif>
                            SF.FIS_TYPE =111 AND 
                            SF.FIS_DATE >= #attributes.date# AND 
                            SF.FIS_DATE <= #attributes.date2#
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                 AND SF.FIS_ID = SF_M.ACTION_ID
                                <cfif isdefined('attributes.is_system_money_2')>
                                 AND SF_M.MONEY_TYPE = '#session.ep.money2#'
                                <cfelse>
                                AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                </cfif>
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
                    ) as GET_DEMONTAJ
				WHERE
					ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
				GROUP BY
					#ALAN_ADI#			
				ORDER BY
					#ALAN_ADI#			
			</cfquery>
			</cfif>
            <cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
                <!---donemici_sayim--->
                <cfquery name="donemici_sayim" datasource="#dsn_report#">
                        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'donemici_sayim')
                            BEGIN
                                DROP TABLE donemici_sayim
                            END
                </cfquery>
                <cfquery name="donemici_sayim" datasource="#dsn2#">
                    SELECT
                        SUM(AMOUNT) AS TOPLAM_SAYIM,
                        SUM(MALIYET*AMOUNT) AS SAYIM_MALIYET,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(MALIYET_2*AMOUNT) AS SAYIM_MALIYET_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI			
                    INTO #DSN_REPORT#.donemici_sayim
                    FROM
                           (
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
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                <cfif isdefined('attributes.is_system_money_2')> <!---  sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir  --->
                                GC.MALIYET MALIYET,
                                GC.MALIYET_2 MALIYET_2,
                                (SFR.AMOUNT*ISNULL(COST_PRICE,0)) AS TOTAL_COST_PRICE, <!---uretimden giris fislerinde belge uzerindeki maliyet kullanılıyor --->
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
                            <cfif attributes.report_type eq 8>
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
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                            STOCK_FIS_MONEY SF_M,
                            </cfif>
                            <cfif is_store or isdefined("attributes.location_based_cost")>
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
                            SF.FIS_DATE >= #attributes.date# AND
                            <cfif attributes.report_type eq 8>
                            ISNULL((SELECT SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SFR.SPECT_VAR_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
                            </cfif>
                            SF.FIS_DATE <= #attributes.date2#
                            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
                                 AND SF.FIS_ID = SF_M.ACTION_ID
                                <cfif isdefined('attributes.is_system_money_2')>
                                 AND SF_M.MONEY_TYPE = '#session.ep.money2#'
                                <cfelse>
                                 AND SF_M.MONEY_TYPE = '#attributes.cost_money#'
                                </cfif>
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
                       	   )as  GET_STOCK_FIS
                    WHERE
                        ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
                        AND PROCESS_TYPE =115
                    GROUP BY
                        #ALAN_ADI#			
                    ORDER BY
                        #ALAN_ADI#			
                </cfquery>
			</cfif>
        
        </cfif>
        		<cfif isdefined("attributes.is_excel") AND attributes.is_excel eq 1>
        			<cfquery name="get_all_stock" datasource="#dsn_report#">
                	SELECT DISTINCT
                    	 GET_ALL_STOCK.STOCK_CODE		 
					<cfif attributes.report_type eq 1>
                        ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                        ,GET_ALL_STOCK.ACIKLAMA
                        ,GET_ALL_STOCK.MANUFACT_CODE
                        ,GET_ALL_STOCK.PRODUCT_UNIT_ID
                        ,GET_ALL_STOCK.MAIN_UNIT
                        ,GET_ALL_STOCK.DIMENTION
                        ,GET_ALL_STOCK.BARCOD
                        ,GET_ALL_STOCK.PRODUCT_CODE
                        ,GET_ALL_STOCK.STOCK_CODE_2
                    <cfelseif attributes.report_type eq 2>
                        ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                        ,GET_ALL_STOCK.ACIKLAMA
                        ,GET_ALL_STOCK.MANUFACT_CODE
                        ,GET_ALL_STOCK.MAIN_UNIT
                        ,GET_ALL_STOCK.DIMENTION
                        ,GET_ALL_STOCK.BARCOD
                        ,GET_ALL_STOCK.PRODUCT_CODE
                    <cfelseif attributes.report_type eq 3>
                        ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                        ,GET_ALL_STOCK.ACIKLAMA
                    <cfelseif attributes.report_type eq 4>
                        ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                        ,GET_ALL_STOCK.ACIKLAMA
                    <cfelseif attributes.report_type eq 5>
                         ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                         ,GET_ALL_STOCK.ACIKLAMA
                    <cfelseif attributes.report_type eq 6>
                         ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                         ,GET_ALL_STOCK.ACIKLAMA
                    <cfelseif attributes.report_type eq 9>
                         ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                         ,GET_ALL_STOCK.ACIKLAMA
                    <cfelseif attributes.report_type eq 10>
                         ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                         ,GET_ALL_STOCK.ACIKLAMA
                    <cfelseif attributes.report_type eq 8>
                        ,GET_ALL_STOCK.STOCK_ID
                        ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                        ,GET_ALL_STOCK.SPECT_VAR_ID
                        <cfif isdefined('x_dsp_spec_name') and x_dsp_spec_name eq 1>
                        ,GET_ALL_STOCK.SPECT_NAME
                        </cfif>
                        ,GET_ALL_STOCK.ACIKLAMA
                        ,GET_ALL_STOCK.MANUFACT_CODE
                        ,GET_ALL_STOCK.PRODUCT_UNIT_ID
                        ,GET_ALL_STOCK.MAIN_UNIT
                        ,GET_ALL_STOCK.DIMENTION
                        ,GET_ALL_STOCK.BARCOD
                        ,GET_ALL_STOCK.PRODUCT_CODE
                    </cfif>
                        ,GET_ALL_STOCK.PRODUCT_STATUS
                        ,GET_ALL_STOCK.PRODUCT_ID
                        ,GET_ALL_STOCK.IS_PRODUCTION
                        <cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
                            ,GET_ALL_STOCK.DEPARTMENT_ID
                            ,GET_ALL_STOCK.LOCATION_ID
                        </cfif>
                        ,GET_ALL_STOCK.ALL_START_COST 
                        ,GET_ALL_STOCK.ALL_START_COST_2 
                        ,GET_ALL_STOCK.ALL_FINISH_COST
                        ,GET_ALL_STOCK.ALL_FINISH_COST_2
                        <cfif isdefined("attributes.display_cost_money")>
                        ,GET_ALL_STOCK.ALL_START_MONEY
                        ,GET_ALL_STOCK.ALL_FINISH_MONEY
                        </cfif>
                        <!---get_all_stock --->
                        
                        ,ISNULL(acilis_stok2.DB_STOK_MIKTAR,0) AS DB_STOK_MIKTAR
                        ,acilis_stok2.DB_STOK_MALIYET
                        <cfif isdefined('attributes.is_system_money_2')>
                        ,acilis_stok2.DB_STOK_MALIYET_2
                        </cfif>
                        ,acilis_stok2.GROUPBY_ALANI
                        <!---acilis_stok2--->
                        
                        ,ISNULL(get_total_stok.TOTAL_STOCK,0) AS TOTAL_STOCK
                        ,get_total_stok.TOTAL_PRODUCT_COST
                        <cfif isdefined('attributes.is_system_money_2')>
                        ,get_total_stok.TOTAL_PRODUCT_COST_2
                        </cfif>
                        <cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
                            ,get_total_stok.STORE
                            ,get_total_stok.STORE_LOCATION
                        </cfif>
                        <cfif attributes.report_type eq 9 or attributes.report_type eq 10>
                           ,get_total_stok.GROUPBY_ALANI
                           ,get_total_stok.GROUPBY_ALANI_2
                        <cfelse>
                           ,get_total_stok.GROUPBY_ALANI
                        </cfif>
                        <!---get_total_stok--->
                        
						<cfif listfind('1,2,8',attributes.report_type)>
        					<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
                        		,ISNULL(d_alis_miktar.TOPLAM_ALIS,0) AS TOPLAM_ALIS
                                ,ISNULL(d_alis_miktar.TOPLAM_ALIS_MALIYET,0) AS TOPLAM_ALIS_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,d_alis_miktar.TOPLAM_ALIS_MALIYET_2
                                </cfif>
                                ,d_alis_miktar.GROUPBY_ALANI
                        <!---d_alis_miktar--->
                        
								<cfif isdefined('attributes.is_system_money_2')>
                                ,d_alis_tutar.TOPLAM_ALIS_MALIYET_2
                                ,d_alis_tutar.TOPLAM_ALIS_TUTAR_2
                                </cfif>
                                ,ISNULL(d_alis_tutar.TOPLAM_ALIS_MALIYET1,0) AS TOPLAM_ALIS_MALIYET1
                                ,d_alis_tutar.TOPLAM_ALIS_TUTAR
                                ,d_alis_tutar.GROUPBY_ALANI
						<!---d_alis_tutar--->
                        		
                                ,ISNULL(d_alis_iade_miktar.TOPLAM_ALIS_IADE,0) AS TOPLAM_ALIS_IADE
                                ,ISNULL(d_alis_iade_miktar.TOPLAM_ALIS_IADE_MALIYET,0) AS TOPLAM_ALIS_IADE_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,d_alis_iade_miktar.TOPLAM_ALIS_IADE_MALIYET_2
                                </cfif>
                                ,d_alis_iade_miktar.GROUPBY_ALANI
                        <!---d_alis_iade_miktar--->
                               
                                ,ISNULL(d_alis_iade_tutar.TOPLAM_ALIS_IADE_MALIYET,0) AS TOPLAM_ALIS_IADE_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,d_alis_iade_tutar.TOPLAM_ALIS_IADE_MALIYET_2
                                </cfif>
                                ,d_alis_iade_tutar.GROUPBY_ALANI
                        <!---d_alis_iade_tutar--->
                            </cfif>	   
							   
                               
                                <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,17)>
                                    ,get_ithal_mal_girisi_total.ITHAL_MAL_GIRIS_MIKTARI
                                    ,get_ithal_mal_girisi_total.ITHAL_MAL_GIRIS_MALIYETI
                                    ,get_ithal_mal_girisi_total.ITHAL_MAL_CIKIS_MIKTARI
                                    ,get_ithal_mal_girisi_total.ITHAL_MAL_CIKIS_MALIYETI
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    ,get_ithal_mal_girisi_total.ITHAL_MAL_GIRIS_MALIYETI_2
                                    ,get_ithal_mal_girisi_total.ITHAL_MAL_CIKIS_MALIYETI_2
                                    </cfif>
                                    ,get_ithal_mal_girisi_total.GROUPBY_ALANI
                                </cfif>
                        <!---get_ithal_mal_girisi_total--->
                        		
								<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
                        			,get_sevk_irs_total.SEVK_GIRIS_MIKTARI
                                    ,get_sevk_irs_total.SEVK_GIRIS_MALIYETI
                                    ,get_sevk_irs_total.SEVK_CIKIS_MIKTARI
                                    ,get_sevk_irs_total.SEVK_CIKIS_MALIYETI
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    ,get_sevk_irs_total.SEVK_GIRIS_MALIYETI_2
                                   	,get_sevk_irs_total.SEVK_CIKIS_MALIYETI_2
                                    </cfif>
                                    ,get_sevk_irs_total.GROUPBY_ALANI	       	
                                </cfif>
                        <!---get_sevk_irs_total--->
                            
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
            					<cfif isdefined('attributes.from_invoice_actions')>
                                    ,d_fatura_satis_tutar.FATURA_SATIS_TUTAR
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    ,d_fatura_satis_tutar.FATURA_SATIS_TUTAR_2
                                    </cfif>
                                    <cfif isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                                        ,d_fatura_satis_tutar.FATURA_SATIS_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,d_fatura_satis_tutar.FATURA_SATIS_MALIYET_2
                                        </cfif>
                                    </cfif>
                                    ,d_fatura_satis_tutar.FATURA_SATIS_MIKTAR
                                    ,d_fatura_satis_tutar.GROUPBY_ALANI
						<!---d_fatura_satis_tutar--->  
								   
                                   ,d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_TUTAR
									<cfif isdefined('attributes.is_system_money_2')>
                                   ,d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_TUTAR_2
                                    </cfif>
                                    <cfif isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                                        ,d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            ,d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_MALIYET_2
                                        </cfif>
                                    </cfif>
                                    ,d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_MIKTAR
                                    ,d_fatura_satis_iade_tutar.GROUPBY_ALANI
						<!---d_fatura_satis_iade_tutar--->
                        		</cfif>    
                        		
                        		,ISNULL(d_satis.TOPLAM_SATIS,0) AS TOPLAM_SATIS
                                ,ISNULL(d_satis.TOPLAM_SATIS_MALIYET,0) AS TOPLAM_SATIS_MALIYET 
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,d_satis.TOPLAM_SATIS_MALIYET_2
                                </cfif>
                                ,d_satis.GROUPBY_ALANI	
						<!---d_satis--->   	
                            
                            
                        		,ISNULL(d_satis_iade.TOPLAM_SATIS_IADE,0) AS TOPLAM_SATIS_IADE 
                                ,ISNULL(d_satis_iade.TOP_SAT_IADE_MALIYET,0) AS TOP_SAT_IADE_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,d_satis_iade.TOP_SAT_IADE_MALIYET_2
                                </cfif>
                                ,d_satis_iade.GROUPBY_ALANI     
                        <!---d_satis_iade--->    
                            
                            </cfif>
                        
                        
                       	    <cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
                            	 ,konsinye_cikis.KONS_CIKIS_MIKTAR
								<cfif isdefined("x_kons_cost_date") and x_kons_cost_date eq 1>
                                    ,konsinye_cikis.KONS_CIKIS_MALIYET
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    ,konsinye_cikis.KONS_CIKIS_MALIYET_2
                                    </cfif>
                                <cfelse>	
                                    ,konsinye_cikis.KONS_CIKIS_MALIYET
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    ,konsinye_cikis.KONS_CIKIS_MALIYET_2
                                    </cfif>
                                </cfif>
                        		,konsinye_cikis.GROUPBY_ALANI
                            </cfif> 
                        <!---konsinye_cikis--->
                        
                        
                        	<cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
                                ,konsinye_iade.KONS_IADE_MIKTAR
                                <cfif isdefined("x_kons_cost_date") and x_kons_cost_date eq 1>
                                    ,konsinye_iade.KONS_IADE_MALIYET
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    ,konsinye_iade.KONS_IADE_MALIYET_2
                                    </cfif>
                                <cfelse>	
                                    ,konsinye_iade.KONS_IADE_MALIYET
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    ,konsinye_iade.KONS_IADE_MALIYET_2
                                    </cfif>
                                </cfif>
                                ,konsinye_iade.GROUPBY_ALANI	
                            </cfif>
                		<!---konsinye_iade--->
                        
						   <cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
                           		 ,konsinye_giris.KONS_GIRIS_MIKTAR
								<cfif isdefined("x_kons_cost_date") and x_kons_cost_date eq 1>
                                    ,konsinye_giris.KONS_GIRIS_MALIYET
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    ,konsinye_giris.KONS_GIRIS_MALIYET_2
                                    </cfif>
                                <cfelse>	
                                    ,konsinye_giris.KONS_GIRIS_MALIYET
                                    <cfif isdefined('attributes.is_system_money_2')>

                                    ,konsinye_giris.KONS_GIRIS_MALIYET_2
                                    </cfif>
                                </cfif>
                                ,konsinye_giris.GROUPBY_ALANI		
                           </cfif>
					   <!---konsinye_giris--->
                       		
							<cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
                	   			 ,konsinye_giris_iade.KONS_GIRIS_IADE_MIKTAR
								<cfif isdefined("x_kons_cost_date") and x_kons_cost_date eq 1>
                                    ,konsinye_giris_iade.KONS_GIRIS_IADE_MALIYET
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    ,konsinye_giris_iade.KONS_GIRIS_IADE_MALIYET_2
                                    </cfif>
                                <cfelse>	
                                    ,konsinye_giris_iade.KONS_GIRIS_IADE_MALIYET
                                    <cfif isdefined('attributes.is_system_money_2')>
                                   ,konsinye_giris_iade.KONS_GIRIS_IADE_MALIYET_2
                                    </cfif>
                                </cfif>
                               ,konsinye_giris_iade.GROUPBY_ALANI
                            </cfif>
					   <!---konsinye_giris_iade--->
                       
						   <cfif len(attributes.process_type) and listfind(attributes.process_type,8)>
                                ,servis_giris.SERVIS_GIRIS_MIKTAR
                                ,servis_giris.SERVIS_GIRIS_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,servis_giris.SERVIS_GIRIS_MALIYET_2
                                </cfif>
                                ,servis_giris.GROUPBY_ALANI
                           </cfif>
						<!---servis_giris---> 
                        
                        	<cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
                				,servis_cikis.SERVIS_CIKIS_MIKTAR
                                ,servis_cikis.SERVIS_CIKIS_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,servis_cikis.SERVIS_CIKIS_MALIYET_2
                                </cfif>
                                ,servis_cikis.GROUPBY_ALANI
                            </cfif>
						<!---servis_cikis--->
                        
                        	<cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
                				,rma_giris.RMA_GIRIS_MIKTAR
                                ,rma_giris.RMA_GIRIS_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,rma_giris.RMA_GIRIS_MALIYET_2
                                </cfif>
                                ,rma_giris.GROUPBY_ALANI	
                            </cfif>
						<!---rma_giris--->
                        
                        	<cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
                				,rma_cikis.RMA_CIKIS_MIKTAR
                                ,rma_cikis.RMA_CIKIS_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,rma_cikis.RMA_CIKIS_MALIYET_2
                                </cfif>
                                ,rma_cikis.GROUPBY_ALANI	
                            </cfif>
						<!---rma_cikis--->
                        
                        	<cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
                				,donemici_uretim.TOPLAM_URETIM
                                ,donemici_uretim.URETIM_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,donemici_uretim.URETIM_MALIYET_2
                                </cfif>
                                ,donemici_uretim.GROUPBY_ALANI	
                            </cfif>
						<!---donemici_uretim--->
                        
                        	<cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
                				,donemici_masraf.TOPLAM_MASRAF_MIKTAR
                                ,donemici_masraf.MASRAF_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,donemici_masraf.MASRAF_MALIYET_2
                                </cfif>
                                ,donemici_masraf.GROUPBY_ALANI	
                            </cfif>
						<!---donemici_masraf--->
                        	
							<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
                				,get_ambar_fis_total_in.AMBAR_FIS_GIRIS_MIKTARI
                                ,get_ambar_fis_total_in.AMBAR_FIS_GIRIS_MALIYETI
                                <cfif isdefined('attributes.is_system_money_2')>
                               ,get_ambar_fis_total_in.AMBAR_FIS_GIRIS_MALIYETI_2
                                </cfif>
                                ,get_ambar_fis_total_in.GROUPBY_ALANI
                            	
                                ,get_ambar_fis_total_out.AMBAR_FIS_CIKIS_MIKTARI
                                ,get_ambar_fis_total_out.AMBAR_FIS_CIKIS_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,get_ambar_fis_total_out.AMBAR_FIS_CIKIS_MALIYET_2
                                </cfif>
                                ,get_ambar_fis_total_out.GROUPBY_ALANI
                            	
                            </cfif>
						<!---get_ambar_fis_total_in---><!---get_ambar_fis_total_out--->
                        
							<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,21)>
                                 ,get_stok_virman_total_in.STOK_VIRMAN_GIRIS_MIKTARI
                                 ,get_stok_virman_total_in.STOK_VIRMAN_GIRIS_MALIYETI
                                 <cfif isdefined('attributes.is_system_money_2')>
                                 ,get_stok_virman_total_in.STOK_VIRMAN_GIRIS_MALIYETI_2
                                 </cfif>
                                 ,get_stok_virman_total_in.GROUPBY_ALANI
                                 
                                ,get_stok_virman_total_out.STOK_VIRMAN_CIKIS_MIKTARI
                                ,get_stok_virman_total_out.STOK_VIRMAN_CIKIS_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,get_stok_virman_total_out.STOK_VIRMAN_CIKIS_MALIYET_2
                                </cfif>
                                ,get_stok_virman_total_out.GROUPBY_ALANI
                            </cfif>
						<!---get_stok_virman_total_in---><!---get_stok_virman_total_out--->
                        
                        	<cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
                			   ,donemici_sarf.TOPLAM_SARF
                               ,donemici_sarf.SARF_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,donemici_sarf.SARF_MALIYET_2
                                </cfif>
                                ,donemici_sarf.GROUPBY_ALANI
                                			
                            	,donemici_production_sarf.TOPLAM_URETIM_SARF
                                ,donemici_production_sarf.URETIM_SARF_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,donemici_production_sarf.URETIM_SARF_MALIYET_2
                                </cfif>
                                ,donemici_production_sarf.GROUPBY_ALANI	
                            	
                                ,donemici_fire.TOPLAM_FIRE
                                ,donemici_fire.FIRE_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,donemici_fire.FIRE_MALIYET_2
                                </cfif>
                                ,donemici_fire.GROUPBY_ALANI	
                            
                            </cfif>
						<!---donemici_sarf---><!---donemici_production_sarf---><!---donemici_fire--->
                        
                        	<cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
                                ,donemici_demontaj_giris.DEMONTAJ_GIRIS
                                ,donemici_demontaj_giris.DEMONTAJ_GIRIS_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,donemici_demontaj_giris.DEMONTAJ_GIRIS_MALIYET_2
                                </cfif>
                                ,donemici_demontaj_giris.GROUPBY_ALANI	
                            </cfif>
						<!---donemici_demontaj_giris--->
                        
                        	<cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
								,demontaj_giden.DEMONTAJ_GIDEN
                                ,demontaj_giden.DEMONTAJ_GIDEN_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,demontaj_giden.DEMONTAJ_GIDEN_MALIYET_2
                                </cfif>
                                ,demontaj_giden.GROUPBY_ALANI	
                            </cfif>
						<!---demontaj_giden--->
                        
                         <cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
                         	,donemici_sayim.TOPLAM_SAYIM
                            ,donemici_sayim.SAYIM_MALIYET
                            <cfif isdefined('attributes.is_system_money_2')>
                            ,donemici_sayim.SAYIM_MALIYET_2
                            </cfif>
                            ,donemici_sayim.GROUPBY_ALANI
                         </cfif>
                		<!---donemici_sayim--->
                        </cfif>
                    FROM 
                         GET_ALL_STOCK 
                         			LEFT JOIN 
                         acilis_stok2 
                                    ON 
                         GET_ALL_STOCK.PRODUCT_GROUPBY_ID = acilis_stok2.GROUPBY_ALANI
                         			LEFT JOIN
                         get_total_stok
                         			ON
                         get_total_stok.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                     	<cfif listfind('1,2,8',attributes.report_type)>
        					<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
                                    			LEFT JOIN
                                     d_alis_miktar
                                                ON
                                     d_alis_miktar.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID         
                                                LEFT JOIN
                                     d_alis_tutar
                                                ON
                                     d_alis_tutar.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID            
                                                LEFT JOIN
                                     d_alis_iade_miktar
                                                ON
                                     d_alis_iade_miktar.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                                LEFT JOIN
                                     d_alis_iade_tutar
                                                ON
                                     d_alis_iade_tutar.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                         	 </cfif>         
                            <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,17)>
            					<!---get_ithal_mal_girisi_total--->
                        		left join 	get_ithal_mal_girisi_total
                                on get_ithal_mal_girisi_total.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                        	</cfif>
                            <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
                			<!---get_sevk_irs_total--->
                        		left join get_sevk_irs_total
                                on get_sevk_irs_total.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>	
                        	<cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
            					<cfif isdefined('attributes.from_invoice_actions')>
									<!---d_fatura_satis_tutar--->
                                    left join d_fatura_satis_tutar
                                    on d_fatura_satis_tutar.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                        			left join d_fatura_satis_iade_tutar
                                    on d_fatura_satis_iade_tutar.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                </cfif>
                            	left join d_satis
                                on d_satis.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                left join d_satis_iade
                                on d_satis_iade.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>
                        	<cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
								<!---konsinye_cikis--->
                                left join konsinye_cikis
                                on konsinye_cikis.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>       
                        	<cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
                				<!---konsinye_iade--->
                            	left join konsinye_iade
                                on konsinye_iade.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>    
                        	<cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
                				<!---konsinye_giris--->
                            	left join konsinye_giris
                                on konsinye_giris.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
                				<!---konsinye_giris_iade--->
                            	left join konsinye_giris_iade
                                on konsinye_giris_iade.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,8)>
                				<!---servis_giris--->
                            	left join servis_giris
                                on servis_giris.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
                				<!---servis_cikis--->       
                        		left join servis_cikis
                                on servis_cikis.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>
                        	<cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
                				<!---rma_giris--->
                            	left join rma_giris
                                on rma_giris.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
                				<!---rma_cikis--->
                            	left join rma_cikis
                                on rma_cikis.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
                				<!---donemici_uretim--->
                        		left join donemici_uretim
                                on donemici_uretim.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
                				<!---donemici_masraf--->
                           		left join donemici_masraf
                                on donemici_masraf.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>
                            <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
                				<!---get_ambar_fis_total_in--->     
                            	left join get_ambar_fis_total_in 
                                on get_ambar_fis_total_in.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                left join get_ambar_fis_total_out
                                on get_ambar_fis_total_out.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>
                            <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,21)>
                				<!---get_stok_virman_total_in--->
                        		left join get_stok_virman_total_in
                                on get_stok_virman_total_in.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                left join get_stok_virman_total_out
                                on get_stok_virman_total_out.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
                				<!---donemici_sarf--->
                        		left join donemici_sarf
                                on donemici_sarf.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                left join  donemici_production_sarf
                                on donemici_production_sarf.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                left join donemici_fire
                                on donemici_fire.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
                				<!---donemici_demontaj_giris--->
                        		left join donemici_demontaj_giris
                                on donemici_demontaj_giris.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
								<!---demontaj_giden--->
                        		left join demontaj_giden
                                on demontaj_giden.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
                				<!---donemici_sayim--->
                            	left join donemici_sayim
                                on donemici_sayim.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                            </cfif>
                        </cfif>   
                </cfquery>
                <cfelse>
                    <cfquery name="check_table" datasource="#dsn_report#">
                        drop table GET_ALL_STOCK_REPORT
                    </cfquery>
                	<cfquery name="get_all_stock" datasource="#dsn_report#">
                            SELECT DISTINCT
                                GET_ALL_STOCK.STOCK_CODE
								<cfif isdefined("attributes.display_cost")>
                               		,(acilis_stok2.DB_STOK_MIKTAR*GET_ALL_STOCK.ALL_START_COST/1) AS STOK_MALIYET	
								</cfif>
                                <cfif isdefined('attributes.is_system_money_2')>
                                	,(acilis_stok2.DB_STOK_MIKTAR*GET_ALL_STOCK.ALL_START_COST_2/1) as  Maliyet
								</cfif>
                                <cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
                                	,d_alis_miktar.TOPLAM_ALIS-d_alis_iade_miktar.TOPLAM_ALIS_IADE AS Net_Alim_Miktari
                                    <cfif isdefined('attributes.display_cost')>
                                    	,d_alis_tutar.TOPLAM_ALIS_MALIYET1 - d_alis_iade_miktar.TOPLAM_ALIS_IADE_MALIYET  as Net_Alim_Tutari
									</cfif>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    	,d_alis_miktar.TOPLAM_ALIS_MALIYET_2- d_alis_iade_tutar.TOPLAM_ALIS_IADE_MALIYET_2 AS  Net_Alim_Tutari_2
									</cfif>
                                </cfif>
                                 		 
								<cfif attributes.report_type eq 1>
                                    ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    ,GET_ALL_STOCK.ACIKLAMA
                                    ,GET_ALL_STOCK.MANUFACT_CODE
                                    ,GET_ALL_STOCK.PRODUCT_UNIT_ID
                                    ,GET_ALL_STOCK.MAIN_UNIT
                                    ,GET_ALL_STOCK.DIMENTION
                                    ,GET_ALL_STOCK.BARCOD
                                    ,GET_ALL_STOCK.PRODUCT_CODE
                                    ,GET_ALL_STOCK.STOCK_CODE_2
                                <cfelseif attributes.report_type eq 2>
                                    ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    ,GET_ALL_STOCK.ACIKLAMA
                                    ,GET_ALL_STOCK.MANUFACT_CODE
                                    ,GET_ALL_STOCK.MAIN_UNIT
                                    ,GET_ALL_STOCK.DIMENTION
                                    ,GET_ALL_STOCK.BARCOD
                                    ,GET_ALL_STOCK.PRODUCT_CODE
                                <cfelseif attributes.report_type eq 3>
                                    ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    ,GET_ALL_STOCK.ACIKLAMA
                                <cfelseif attributes.report_type eq 4>
                                    ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    ,GET_ALL_STOCK.ACIKLAMA
                                <cfelseif attributes.report_type eq 5>
                                     ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                     ,GET_ALL_STOCK.ACIKLAMA
                                <cfelseif attributes.report_type eq 6>
                                     ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                     ,GET_ALL_STOCK.ACIKLAMA
                                <cfelseif attributes.report_type eq 9>
                                     ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                     ,GET_ALL_STOCK.ACIKLAMA
                                <cfelseif attributes.report_type eq 10>
                                     ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                     ,GET_ALL_STOCK.ACIKLAMA
                                <cfelseif attributes.report_type eq 8>
                                    ,GET_ALL_STOCK.STOCK_ID
                                    ,GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    ,GET_ALL_STOCK.SPECT_VAR_ID
                                    <cfif isdefined('x_dsp_spec_name') and x_dsp_spec_name eq 1>
                                    ,GET_ALL_STOCK.SPECT_NAME
                                    </cfif>
                                    ,GET_ALL_STOCK.ACIKLAMA
                                    ,GET_ALL_STOCK.MANUFACT_CODE
                                    ,GET_ALL_STOCK.PRODUCT_UNIT_ID
                                    ,GET_ALL_STOCK.MAIN_UNIT
                                    ,GET_ALL_STOCK.DIMENTION
                                    ,GET_ALL_STOCK.BARCOD
                                    ,GET_ALL_STOCK.PRODUCT_CODE
                                </cfif>
                                ,GET_ALL_STOCK.PRODUCT_STATUS
                                ,GET_ALL_STOCK.PRODUCT_ID
                                ,GET_ALL_STOCK.IS_PRODUCTION
                                <cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
                                    ,GET_ALL_STOCK.DEPARTMENT_ID
                                    ,GET_ALL_STOCK.LOCATION_ID
                                </cfif>
                                ,GET_ALL_STOCK.ALL_START_COST 
                                ,GET_ALL_STOCK.ALL_START_COST_2 
                                ,GET_ALL_STOCK.ALL_FINISH_COST
                                ,GET_ALL_STOCK.ALL_FINISH_COST_2
                                <cfif isdefined("attributes.display_cost_money")>
                                ,GET_ALL_STOCK.ALL_START_MONEY
                                ,GET_ALL_STOCK.ALL_FINISH_MONEY
                                </cfif>
                                <!---get_all_stock --->
                                ,ISNULL(acilis_stok2.DB_STOK_MIKTAR,0) AS DB_STOK_MIKTAR
                                ,acilis_stok2.DB_STOK_MALIYET
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,acilis_stok2.DB_STOK_MALIYET_2
                                </cfif>
                                --,acilis_stok2.GROUPBY_ALANI
                                <!---acilis_stok2--->
                                
                                ,ISNULL(get_total_stok.TOTAL_STOCK,0) AS TOTAL_STOCK
                                ,get_total_stok.TOTAL_PRODUCT_COST
                                <cfif isdefined('attributes.is_system_money_2')>
                                ,get_total_stok.TOTAL_PRODUCT_COST_2
                                </cfif>
                                <cfif listfind('2,3,4,5,6,9',attributes.report_type) and isdefined("attributes.location_based_cost")>
                                    ,get_total_stok.STORE
                                    ,get_total_stok.STORE_LOCATION
                                </cfif>
                                <cfif attributes.report_type eq 9 or attributes.report_type eq 10>
                                   --,get_total_stok.GROUPBY_ALANI
                                   --,get_total_stok.GROUPBY_ALANI_2
                                <cfelse>
                                   --,get_total_stok.GROUPBY_ALANI
                                </cfif>
                                <!---get_total_stok--->
                                
                                <cfif listfind('1,2,8',attributes.report_type)>
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
                                        ,ISNULL(d_alis_miktar.TOPLAM_ALIS,0) AS TOPLAM_ALIS
                                        ,ISNULL(d_alis_miktar.TOPLAM_ALIS_MALIYET,0) AS TOPLAM_ALIS_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,d_alis_miktar.TOPLAM_ALIS_MALIYET_2
                                        </cfif>
                                        --,d_alis_miktar.GROUPBY_ALANI
                                <!---d_alis_miktar--->
                                
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,d_alis_tutar.TOPLAM_ALIS_MALIYET_2 AS TOPLAM_ALIS_MALIYET1_2
                                        ,d_alis_tutar.TOPLAM_ALIS_TUTAR_2
                                        </cfif>
                                        ,ISNULL(d_alis_tutar.TOPLAM_ALIS_MALIYET1,0) AS TOPLAM_ALIS_MALIYET1
                                        ,d_alis_tutar.TOPLAM_ALIS_TUTAR
                                        --,d_alis_tutar.GROUPBY_ALANI
                                <!---d_alis_tutar--->
                                        
                                        ,ISNULL(d_alis_iade_miktar.TOPLAM_ALIS_IADE,0) AS TOPLAM_ALIS_IADE
                                        ,ISNULL(d_alis_iade_miktar.TOPLAM_ALIS_IADE_MALIYET,0) AS TOPLAM_ALIS_IADE_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,d_alis_iade_miktar.TOPLAM_ALIS_IADE_MALIYET_2
                                        </cfif>
                                        --,d_alis_iade_miktar.GROUPBY_ALANI
                                <!---d_alis_iade_miktar--->
                                       
                                        ,ISNULL(d_alis_iade_tutar.TOPLAM_ALIS_IADE_MALIYET,0) AS TOPLAM_ALIS_IADE_MALIYET1
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,d_alis_iade_tutar.TOPLAM_ALIS_IADE_MALIYET_2 AS TOPLAM_ALIS_IADE_MALIYET1_2
                                        </cfif>
                                        --,d_alis_iade_tutar.GROUPBY_ALANI
                                <!---d_alis_iade_tutar--->
                                    </cfif>	   
                                       
                                       
									<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,17)>
                                        ,get_ithal_mal_girisi_total.ITHAL_MAL_GIRIS_MIKTARI
                                        ,get_ithal_mal_girisi_total.ITHAL_MAL_GIRIS_MALIYETI
                                        ,get_ithal_mal_girisi_total.ITHAL_MAL_CIKIS_MIKTARI
                                        ,get_ithal_mal_girisi_total.ITHAL_MAL_CIKIS_MALIYETI
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,get_ithal_mal_girisi_total.ITHAL_MAL_GIRIS_MALIYETI_2
    
                                        ,get_ithal_mal_girisi_total.ITHAL_MAL_CIKIS_MALIYETI_2
                                        </cfif>
                                        --,get_ithal_mal_girisi_total.GROUPBY_ALANI
                                    </cfif>
                                <!---get_ithal_mal_girisi_total--->
                                        
                                        <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
                                            ,get_sevk_irs_total.SEVK_GIRIS_MIKTARI
                                            ,get_sevk_irs_total.SEVK_GIRIS_MALIYETI
                                            ,get_sevk_irs_total.SEVK_CIKIS_MIKTARI
                                            ,get_sevk_irs_total.SEVK_CIKIS_MALIYETI
                                            <cfif isdefined('attributes.is_system_money_2')>
                                                ,get_sevk_irs_total.SEVK_GIRIS_MALIYETI_2
                                                ,get_sevk_irs_total.SEVK_CIKIS_MALIYETI_2
                                            </cfif>
                                            --,get_sevk_irs_total.GROUPBY_ALANI	       	
                                        </cfif>
                                <!---get_sevk_irs_total--->
                                    
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
                                        <cfif isdefined('attributes.from_invoice_actions')>
                                            ,d_fatura_satis_tutar.FATURA_SATIS_TUTAR
                                            <cfif isdefined('attributes.is_system_money_2')>
                                            ,d_fatura_satis_tutar.FATURA_SATIS_TUTAR_2
                                            </cfif>
                                            <cfif isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                                                ,d_fatura_satis_tutar.FATURA_SATIS_MALIYET
                                                <cfif isdefined('attributes.is_system_money_2')>
                                                ,d_fatura_satis_tutar.FATURA_SATIS_MALIYET_2
                                                </cfif>
                                            </cfif>
                                            ,d_fatura_satis_tutar.FATURA_SATIS_MIKTAR
                                            --,d_fatura_satis_tutar.GROUPBY_ALANI
                                <!---d_fatura_satis_tutar--->  
                                           
                                           ,d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_TUTAR
                                            <cfif isdefined('attributes.is_system_money_2')>
                                           ,d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_TUTAR_2
                                            </cfif>
                                            <cfif isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                                                ,d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_MALIYET
                                                <cfif isdefined('attributes.is_system_money_2')>
                                                    ,d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_MALIYET_2
                                                </cfif>
                                            </cfif>
                                            ,d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_MIKTAR
                                           -- ,d_fatura_satis_iade_tutar.GROUPBY_ALANI
                                <!---d_fatura_satis_iade_tutar--->
                                        </cfif>    
                                        
                                        ,ISNULL(d_satis.TOPLAM_SATIS,0) AS TOPLAM_SATIS
                                        ,ISNULL(d_satis.TOPLAM_SATIS_MALIYET,0) AS TOPLAM_SATIS_MALIYET 
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,d_satis.TOPLAM_SATIS_MALIYET_2
                                        </cfif>
                                       -- ,d_satis.GROUPBY_ALANI	
                                <!---d_satis--->   	
                                    
                                    
                                        ,ISNULL(d_satis_iade.TOPLAM_SATIS_IADE,0) AS TOPLAM_SATIS_IADE 
                                        ,ISNULL(d_satis_iade.TOP_SAT_IADE_MALIYET,0) AS TOP_SAT_IADE_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,d_satis_iade.TOP_SAT_IADE_MALIYET_2
                                        </cfif>
                                        --,d_satis_iade.GROUPBY_ALANI     
                                <!---d_satis_iade--->    
                                    
                                    </cfif>
                                
                                
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
                                         ,konsinye_cikis.KONS_CIKIS_MIKTAR
                                        <cfif isdefined("x_kons_cost_date") and x_kons_cost_date eq 1>
                                            ,konsinye_cikis.KONS_CIKIS_MALIYET
                                            <cfif isdefined('attributes.is_system_money_2')>
                                            ,konsinye_cikis.KONS_CIKIS_MALIYET_2
                                            </cfif>
                                        <cfelse>	
                                            ,konsinye_cikis.KONS_CIKIS_MALIYET
                                            <cfif isdefined('attributes.is_system_money_2')>
                                            ,konsinye_cikis.KONS_CIKIS_MALIYET_2
                                            </cfif>
                                        </cfif>
                                        --,konsinye_cikis.GROUPBY_ALANI
                                    </cfif> 
                                <!---konsinye_cikis--->
                                
                                
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
                                        ,konsinye_iade.KONS_IADE_MIKTAR
                                        <cfif isdefined("x_kons_cost_date") and x_kons_cost_date eq 1>
                                            ,konsinye_iade.KONS_IADE_MALIYET
                                            <cfif isdefined('attributes.is_system_money_2')>
                                            ,konsinye_iade.KONS_IADE_MALIYET_2
                                            </cfif>
                                        <cfelse>	
                                            ,konsinye_iade.KONS_IADE_MALIYET
                                            <cfif isdefined('attributes.is_system_money_2')>
                                            ,konsinye_iade.KONS_IADE_MALIYET_2
                                            </cfif>
                                        </cfif>
                                        --,konsinye_iade.GROUPBY_ALANI	
                                    </cfif>
                                <!---konsinye_iade--->
                                
                                   <cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
                                         ,konsinye_giris.KONS_GIRIS_MIKTAR
                                        <cfif isdefined("x_kons_cost_date") and x_kons_cost_date eq 1>
                                            ,konsinye_giris.KONS_GIRIS_MALIYET
                                            <cfif isdefined('attributes.is_system_money_2')>
                                            ,konsinye_giris.KONS_GIRIS_MALIYET_2
                                            </cfif>
                                        <cfelse>	
                                            ,konsinye_giris.KONS_GIRIS_MALIYET
                                            <cfif isdefined('attributes.is_system_money_2')>
                                            ,konsinye_giris.KONS_GIRIS_MALIYET_2
                                            </cfif>
                                        </cfif>
                                       -- ,konsinye_giris.GROUPBY_ALANI		
                                   </cfif>
                               <!---konsinye_giris--->
                                    
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
                                         ,konsinye_giris_iade.KONS_GIRIS_IADE_MIKTAR
                                        <cfif isdefined("x_kons_cost_date") and x_kons_cost_date eq 1>
                                            ,konsinye_giris_iade.KONS_GIRIS_IADE_MALIYET
                                            <cfif isdefined('attributes.is_system_money_2')>
                                            ,konsinye_giris_iade.KONS_GIRIS_IADE_MALIYET_2
                                            </cfif>
                                        <cfelse>	
                                            ,konsinye_giris_iade.KONS_GIRIS_IADE_MALIYET
                                            <cfif isdefined('attributes.is_system_money_2')>
                                           ,konsinye_giris_iade.KONS_GIRIS_IADE_MALIYET_2
                                            </cfif>
                                        </cfif>
                                       --,konsinye_giris_iade.GROUPBY_ALANI
                                    </cfif>
                               <!---konsinye_giris_iade--->
                               
                                   <cfif len(attributes.process_type) and listfind(attributes.process_type,8)>
                                        ,servis_giris.SERVIS_GIRIS_MIKTAR
                                        ,servis_giris.SERVIS_GIRIS_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,servis_giris.SERVIS_GIRIS_MALIYET_2
                                        </cfif>
                                        --,servis_giris.GROUPBY_ALANI
                                   </cfif>
                                <!---servis_giris---> 
                                
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
                                        ,servis_cikis.SERVIS_CIKIS_MIKTAR
                                        ,servis_cikis.SERVIS_CIKIS_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,servis_cikis.SERVIS_CIKIS_MALIYET_2
                                        </cfif>
                                        --,servis_cikis.GROUPBY_ALANI
                                    </cfif>
                                <!---servis_cikis--->
                                
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
                                        ,rma_giris.RMA_GIRIS_MIKTAR
                                        ,rma_giris.RMA_GIRIS_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,rma_giris.RMA_GIRIS_MALIYET_2
                                        </cfif>
                                       -- ,rma_giris.GROUPBY_ALANI	
                                    </cfif>
                                <!---rma_giris--->
                                
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
                                        ,rma_cikis.RMA_CIKIS_MIKTAR
                                        ,rma_cikis.RMA_CIKIS_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,rma_cikis.RMA_CIKIS_MALIYET_2
                                        </cfif>
                                        --,rma_cikis.GROUPBY_ALANI	
                                    </cfif>
                                <!---rma_cikis--->
                                
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
                                        ,donemici_uretim.TOPLAM_URETIM
                                        ,donemici_uretim.URETIM_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,donemici_uretim.URETIM_MALIYET_2
                                        </cfif>
                                        --,donemici_uretim.GROUPBY_ALANI	
                                    </cfif>
                                <!---donemici_uretim--->
                                
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
                                        ,donemici_masraf.TOPLAM_MASRAF_MIKTAR
                                        ,donemici_masraf.MASRAF_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,donemici_masraf.MASRAF_MALIYET_2
                                        </cfif>
                                       -- ,donemici_masraf.GROUPBY_ALANI	
                                    </cfif>
                                <!---donemici_masraf--->
                                    
                                    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
                                        ,get_ambar_fis_total_in.AMBAR_FIS_GIRIS_MIKTARI
                                        ,get_ambar_fis_total_in.AMBAR_FIS_GIRIS_MALIYETI
                                        <cfif isdefined('attributes.is_system_money_2')>
                                       ,get_ambar_fis_total_in.AMBAR_FIS_GIRIS_MALIYETI_2
                                        </cfif>
                                       -- ,get_ambar_fis_total_in.GROUPBY_ALANI
                                        
                                        ,get_ambar_fis_total_out.AMBAR_FIS_CIKIS_MIKTARI
                                        ,get_ambar_fis_total_out.AMBAR_FIS_CIKIS_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,get_ambar_fis_total_out.AMBAR_FIS_CIKIS_MALIYET_2
                                        </cfif>
                                        --,get_ambar_fis_total_out.GROUPBY_ALANI
                                        
                                    </cfif>
                                <!---get_ambar_fis_total_in---><!---get_ambar_fis_total_out--->
                                
                                    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,21)>
                                         ,get_stok_virman_total_in.STOK_VIRMAN_GIRIS_MIKTARI
                                         ,get_stok_virman_total_in.STOK_VIRMAN_GIRIS_MALIYETI
                                         <cfif isdefined('attributes.is_system_money_2')>
                                         ,get_stok_virman_total_in.STOK_VIRMAN_GIRIS_MALIYETI_2
                                         </cfif>
                                        --,get_stok_virman_total_in.GROUPBY_ALANI
                                         
                                        ,get_stok_virman_total_out.STOK_VIRMAN_CIKIS_MIKTARI
                                        ,get_stok_virman_total_out.STOK_VIRMAN_CIKIS_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,get_stok_virman_total_out.STOK_VIRMAN_CIKIS_MALIYET_2
                                        </cfif>
                                        --,get_stok_virman_total_out.GROUPBY_ALANI
                                    </cfif>
                                <!---get_stok_virman_total_in---><!---get_stok_virman_total_out--->
                                
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
                                       ,donemici_sarf.TOPLAM_SARF
                                       ,donemici_sarf.SARF_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,donemici_sarf.SARF_MALIYET_2
                                        </cfif>
                                        --,donemici_sarf.GROUPBY_ALANI
                                                    
                                        ,donemici_production_sarf.TOPLAM_URETIM_SARF
                                        ,donemici_production_sarf.URETIM_SARF_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,donemici_production_sarf.URETIM_SARF_MALIYET_2
                                        </cfif>
                                        --,donemici_production_sarf.GROUPBY_ALANI	
                                        
                                        ,donemici_fire.TOPLAM_FIRE
                                        ,donemici_fire.FIRE_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,donemici_fire.FIRE_MALIYET_2
                                        </cfif>
                                        --,donemici_fire.GROUPBY_ALANI	
                                    
                                    </cfif>
                                <!---donemici_sarf---><!---donemici_production_sarf---><!---donemici_fire--->
                                
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
                                        ,donemici_demontaj_giris.DEMONTAJ_GIRIS
                                        ,donemici_demontaj_giris.DEMONTAJ_GIRIS_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,donemici_demontaj_giris.DEMONTAJ_GIRIS_MALIYET_2
                                        </cfif>
                                        --,donemici_demontaj_giris.GROUPBY_ALANI	
                                    </cfif>
                                <!---donemici_demontaj_giris--->
                                
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
                                        ,demontaj_giden.DEMONTAJ_GIDEN
                                        ,demontaj_giden.DEMONTAJ_GIDEN_MALIYET
                                        <cfif isdefined('attributes.is_system_money_2')>
                                        ,demontaj_giden.DEMONTAJ_GIDEN_MALIYET_2
                                        </cfif>
                                       -- ,demontaj_giden.GROUPBY_ALANI	
                                    </cfif>
                                <!---demontaj_giden--->
                                
                                 <cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
                                    ,donemici_sayim.TOPLAM_SAYIM
                                    ,donemici_sayim.SAYIM_MALIYET
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    ,donemici_sayim.SAYIM_MALIYET_2
                                    </cfif>
                                    --,donemici_sayim.GROUPBY_ALANI
                                 </cfif>
                                <!---donemici_sayim--->
                                </cfif>
                            INTO #dsn_report#.GET_ALL_STOCK_REPORT
                            FROM 
                                 GET_ALL_STOCK 
                                            LEFT JOIN 
                                 acilis_stok2 
                                            ON 
                                 GET_ALL_STOCK.PRODUCT_GROUPBY_ID = acilis_stok2.GROUPBY_ALANI
                                            LEFT JOIN
                                 get_total_stok
                                            ON
                                 get_total_stok.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                <cfif listfind('1,2,8',attributes.report_type)>
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
                                                        LEFT JOIN
                                             d_alis_miktar
                                                        ON
                                             d_alis_miktar.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID         
                                                        LEFT JOIN
                                             d_alis_tutar
                                                        ON
                                             d_alis_tutar.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID            
                                                        LEFT JOIN
                                             d_alis_iade_miktar
                                                        ON
                                             d_alis_iade_miktar.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                                        LEFT JOIN
                                             d_alis_iade_tutar
                                                        ON
                                             d_alis_iade_tutar.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                     </cfif>         
                                    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,17)>
                                        <!---get_ithal_mal_girisi_total--->
                                        left join 	get_ithal_mal_girisi_total
                                        on get_ithal_mal_girisi_total.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>
                                    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
                                    <!---get_sevk_irs_total--->
                                        left join get_sevk_irs_total
                                        on get_sevk_irs_total.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>	
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
                                        <cfif isdefined('attributes.from_invoice_actions')>
                                            <!---d_fatura_satis_tutar--->
                                            left join d_fatura_satis_tutar
                                            on d_fatura_satis_tutar.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                            left join d_fatura_satis_iade_tutar
                                            on d_fatura_satis_iade_tutar.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                        </cfif>
                                        left join d_satis
                                        on d_satis.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                        left join d_satis_iade
                                        on d_satis_iade.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
                                        <!---konsinye_cikis--->
                                        left join konsinye_cikis
                                        on konsinye_cikis.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>       
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
                                        <!---konsinye_iade--->
                                        left join konsinye_iade
                                        on konsinye_iade.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>    
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
                                        <!---konsinye_giris--->
                                        left join konsinye_giris
                                        on konsinye_giris.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
                                        <!---konsinye_giris_iade--->
                                        left join konsinye_giris_iade
                                        on konsinye_giris_iade.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,8)>
                                        <!---servis_giris--->
                                        left join servis_giris
                                        on servis_giris.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
                                        <!---servis_cikis--->       
                                        left join servis_cikis
                                        on servis_cikis.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
                                        <!---rma_giris--->
                                        left join rma_giris
                                        on rma_giris.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
                                        <!---rma_cikis--->
                                        left join rma_cikis
                                        on rma_cikis.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
                                        <!---donemici_uretim--->
                                        left join donemici_uretim
                                        on donemici_uretim.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
                                        <!---donemici_masraf--->
                                        left join donemici_masraf
                                        on donemici_masraf.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>
                                    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
                                        <!---get_ambar_fis_total_in--->     
                                        left join get_ambar_fis_total_in 
                                        on get_ambar_fis_total_in.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                        left join get_ambar_fis_total_out
                                        on get_ambar_fis_total_out.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>
                                    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,21)>
                                        <!---get_stok_virman_total_in--->
                                        left join get_stok_virman_total_in
                                        on get_stok_virman_total_in.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                        left join get_stok_virman_total_out
                                        on get_stok_virman_total_out.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
                                        <!---donemici_sarf--->
                                        left join donemici_sarf
                                        on donemici_sarf.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                        left join  donemici_production_sarf
                                        on donemici_production_sarf.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                        left join donemici_fire
                                        on donemici_fire.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
                                        <!---donemici_demontaj_giris--->
                                        left join donemici_demontaj_giris
                                        on donemici_demontaj_giris.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
                                        <!---demontaj_giden--->
                                        left join demontaj_giden
                                        on demontaj_giden.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>
                                    <cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
                                        <!---donemici_sayim--->
                                        left join donemici_sayim
                                        on donemici_sayim.GROUPBY_ALANI = GET_ALL_STOCK.PRODUCT_GROUPBY_ID
                                    </cfif>
                                </cfif> 
                            <!---    ),
                                CTE2 AS (
                                        SELECT
                                            CTE1.*,
                                                ROW_NUMBER() OVER (
                                                                         ORDER BY STOCK_CODE             
                                                    			  ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                                                            FROM
                                                                CTE1
                                                        )
                                                        SELECT
                                                            CTE2.*
                                                        FROM
                                                            CTE2
                                                        WHERE
                                                            RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)--->
                        </cfquery>
                        
                </cfif>
                <cfif isdefined("attributes.is_excel") and listfind('1,2,8',attributes.is_excel)>
                	<cfinclude template="stok_analiz_excel.cfm">
                </cfif>
 <cfelse>
	<cfscript>
		GET_STOCK_ROWS.recordcount = 0;
		GET_ALL_STOCK.recordcount = 0;
		GET_ALL_STOCK.query_count = 0;
		GET_INV_PURCHASE.recordcount = 0;
		GET_SHIP_ROWS.recordcount = 0;
		GET_DS_SPEC_COST.recordcount = 0;
		DB_SPEC_COST.recordcount = 0;
		GET_EXPENSE.recordcount = 0;
	</cfscript>
   </cfif>
<cfelse>
	<cfscript>
		GET_STOCK_ROWS.recordcount = 0;
		GET_ALL_STOCK.query_count = 0;
		GET_ALL_STOCK.recordcount = 0;
		GET_INV_PURCHASE.recordcount = 0;
		GET_SHIP_ROWS.recordcount = 0;
		GET_DS_SPEC_COST.recordcount = 0;
		DB_SPEC_COST.recordcount = 0;
		GET_EXPENSE.recordcount = 0;
	</cfscript>
</cfif>

<cfif attributes.report_type neq 7>
<!---<cfif isdefined("get_all_stock.query_count")>
	<cfparam name="attributes.totalrecords" default="#get_all_stock.query_count#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="#get_all_stock.recordcount#">
</cfif>--->

<cfif isdefined("get_all_stock.query_count")>
	<cfparam name="attributes.totalrecords" default="500">
<cfelse>
	<cfparam name="attributes.totalrecords" default="500">
</cfif>
</cfif>

<cfif listfind('3,4,5,6,9,10', attributes.report_type)>
			<cfquery name="GET_PROD_CATS" dbtype="query">
				SELECT DISTINCT PRODUCT_GROUPBY_ID,ACIKLAMA FROM GET_ALL_STOCK
			</cfquery>
			<cfset attributes.totalrecords='#GET_PROD_CATS.recordcount#'>
</cfif>

<cfif isdate(attributes.date)>
	<cfset attributes.date = dateformat(attributes.date, dateformat_style)>
</cfif>
<cfif isdate(attributes.date2)>
    <cfset attributes.date2 = dateformat(attributes.date2, dateformat_style)>
</cfif>
