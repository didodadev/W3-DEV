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
        <cfquery name="check_table" datasource="#dsn2#">
        	IF EXISTS (select * from tempdb.sys.tables where name='####GET_ALL_STOCK_#session.ep.userid#')
            DROP TABLE ####GET_ALL_STOCK_#session.ep.userid#
        </cfquery>
		<cfquery name="GET_ALL_STOCK" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#" result="xxx">
			SELECT DISTINCT	
                  	     CASE
                            WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
                         ,CASE   
                            WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
                        ,CASE    
                            WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
                        ,CASE    
                            WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
                        ,CASE    
                            WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
                        ,CASE    
                            WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
                        ,CASE    
                            WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
                        ,CASE    
                            WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
                        ,CASE    
                            WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
                        ,CASE    
                            WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
                        ,CASE    
                            WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
                        ,CASE    
                            WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
                        ,CASE    
                            WHEN P.IS_COST = 1 THEN 13 END AS t_13
                        ,CASE    
                            WHEN P.IS_SALES = 1 THEN 14 END AS t_14
                        ,CASE    
                            WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
                        ,CASE    
                            WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
                        ,(SR.STOCK_IN - SR.STOCK_OUT) AS MIKTAR,    
                S.PRODUCT_STATUS,
                S.PRODUCT_ID,
                S.IS_PRODUCTION,
				P_cost.ALL_START_COST,
                ISNULL(P_cost.ALL_START_COST_2,0) ALL_START_COST_2,
                ISNULL(P1_cost.ALL_FINISH_COST,0) AS ALL_FINISH_COST,
                P1_cost.ALL_FINISH_COST_2
                <cfif isdefined("attributes.display_cost_money")>
                    ,ISNULL((
                        SELECT TOP 1 
                            <cfif isdefined("attributes.location_based_cost")>
                                PURCHASE_NET_MONEY_LOCATION
							<cfelseif isdefined("attributes.department_based_cost")>
                                PURCHASE_NET_MONEY_DEPARTMENT
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
                           
                            <cfif isdefined("attributes.location_based_cost") or isdefined("attributes.department_based_cost")>
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
                            <cfelseif isdefined("attributes.department_based_cost")>
                                PURCHASE_NET_MONEY_DEPARTMENT
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
                           
                            <cfif isdefined("attributes.location_based_cost") or isdefined("attributes.department_based_cost")>
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
                JOIN
                #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = S.PRODUCT_ID and SR.PRODUCT_ID = P.PRODUCT_ID
				OUTER APPLY
				(
                    SELECT TOP 1
                        <cfif isdefined("attributes.location_based_cost")>
                            <cfif isdefined("attributes.display_cost_money")>
                                (PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION) AS ALL_START_COST,
                            <cfelse>
                                (PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION) AS ALL_START_COST,
                            </cfif> 
						<cfelseif isdefined("attributes.department_based_cost")>
                            <cfif isdefined("attributes.display_cost_money")>
                                (PURCHASE_NET_DEPARTMENT_ALL+PURCHASE_EXTRA_COST_DEPARTMENT) AS ALL_START_COST,
                            <cfelse>
                                (PURCHASE_NET_SYSTEM_DEPARTMENT_ALL+PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT) AS ALL_START_COST,
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
						<cfelseif isdefined("attributes.department_based_cost")>
                            ISNULL((PURCHASE_NET_DEPARTMENT_ALL+PURCHASE_EXTRA_COST_DEPARTMENT),0) AS ALL_START_COST_2
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
                        <cfif isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")>
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
				) AS P_cost
				OUTER APPLY
				(
                    SELECT TOP 1 
                        <cfif isdefined("attributes.location_based_cost")>
                            <cfif isdefined("attributes.display_cost_money")>
                                (PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION) AS ALL_FINISH_COST,
                            <cfelse>
                                (PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION) AS ALL_FINISH_COST,
                            </cfif>
						<cfelseif isdefined("attributes.department_based_cost")>
                            <cfif isdefined("attributes.display_cost_money")>
                                (PURCHASE_NET_DEPARTMENT_ALL+PURCHASE_EXTRA_COST_DEPARTMENT) AS ALL_FINISH_COST,
                            <cfelse>
                                (PURCHASE_NET_SYSTEM_DEPARTMENT_ALL+PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT) AS ALL_FINISH_COST,
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
                        <cfelseif isdefined("attributes.department_based_cost")>
                            (PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL+PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT) AS ALL_FINISH_COST_2
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
              
                        <cfif isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")>
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
				) AS P1_cost,
                #dsn3_alias#.PRODUCT_UNIT PU WITH (NOLOCK)
            	,#dsn_alias#.STOCKS_LOCATION SL WITH (NOLOCK)
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
				1 = 1
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
            <cfif listfind('2,3,4,5,6,9',attributes.report_type) and (isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost"))>
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
		</cfquery>
        <cfquery name="GET_ALL_STOCK" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#" result="YYY">
			SELECT 
           		SUM(MIKTAR) AS MIKTAR,SUM(ALL_FINISH_COST) AS ALL_FINISH_COST,SUM(ALL_FINISH_COST_2) AS ALL_FINISH_COST_2,ALAN,PRODUCT_TYPE,PRODUCT_ID
             FROM
                (
                	SELECT *
                 	FROM ####GET_ALL_STOCK_#session.ep.userid#
                 ) t
                UNPIVOT
                (PRODUCT_TYPE FOR ALAN IN
                    (	
                    	 t_1,
                         t_2, 
                         t_3, 
                         t_4,
                         t_5,
                         t_6,
                         t_7,
                         t_8,
                         t_9,
                         t_10,
                         t_11,
                         t_12,
                         t_13,
                         t_14,
                         t_15,
                         t_16
                     )
                ) AS u
            GROUP BY 
                ALAN,PRODUCT_TYPE,PRODUCT_ID
		</cfquery>
		<cfset attributes.totalrecords='#GET_ALL_STOCK.recordcount#'>
		<cfif listfind('1,2',attributes.is_excel) and not isdefined('attributes.ajax')>
			<cfset page_maxrows = 100000>
		<cfelse>
			<cfset page_maxrows = attributes.maxrows>
		</cfif>
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
<cfif isdate(attributes.date)>
	<cfset attributes.date = dateformat(attributes.date, dateformat_style)>
</cfif>
<cfif isdate(attributes.date2)>
	<cfset attributes.date2 = dateformat(attributes.date2, dateformat_style)>
</cfif>
