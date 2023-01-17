<cfquery name="get_cost_type" datasource="#dsn#">
	SELECT ISNULL(INVENTORY_CALC_TYPE,3) AS INVENTORY_CALC_TYPE FROM SETUP_PERIOD WHERE PERIOD_ID = #session.ep.period_id#
</cfquery>
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
		<cfif start_period_cost_date is '01/01/#session.ep.period_year#'>
			<cfset start_period_cost_date=start_date>
		<cfelse>
			<cfset start_period_cost_date=date_add('d',-1,start_date)>
		</cfif>
		<cfquery name="check_table" datasource="#dsn2#">
            IF EXISTS(SELECT * FROM tempdb.sys.tables where name = '####GET_ALL_STOCK_#session.ep.userid#')
            BEGIN
                DROP TABLE ####GET_ALL_STOCK_#session.ep.userid#
            END     
        </cfquery>    
        <cfquery name="GET_ALL_STOCK" datasource="#dsn2#" >
            SELECT DISTINCT
            <cfif attributes.report_type eq 1>
                S.STOCK_CODE,		 
                S.STOCK_ID AS PRODUCT_GROUPBY_ID,
                (S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,'')) ACIKLAMA,
                S.MANUFACT_CODE,
                S.PRODUCT_UNIT_ID,
                PU.MAIN_UNIT,
                (SELECT TOP 1 PCC.PRODUCT_CAT FROM #dsn3_alias#.PRODUCT PR LEFT JOIN #dsn3_alias#.PRODUCT_CAT PCC ON PCC.PRODUCT_CATID = PR.PRODUCT_CATID WHERE S.PRODUCT_ID = PR.PRODUCT_ID) AS PRODUCT_CAT,
                <cfif x_show_second_unit>
                    (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                    (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
                </cfif>	
                PU.DIMENTION,
                S.BARCOD,
                S.PRODUCT_CODE,
                S.STOCK_CODE_2,
            <cfelseif attributes.report_type eq 2>
                S.PRODUCT_ID AS PRODUCT_GROUPBY_ID,
                S.PRODUCT_NAME AS ACIKLAMA,
                (SELECT TOP 1 PP.MANUFACT_CODE FROM #dsn3_alias#.PRODUCT PP WHERE PP.PRODUCT_ID = S.PRODUCT_ID) MANUFACT_CODE,
                (SELECT TOP 1 PCC.PRODUCT_CAT FROM #dsn3_alias#.PRODUCT_CAT PCC WHERE S.PRODUCT_CATID = PCC.PRODUCT_CATID) AS PRODUCT_CAT,
                PU.MAIN_UNIT,
                <cfif x_show_second_unit>
                    (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                    (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
                </cfif>	
                PU.DIMENTION,
                S.BARCOD,
                S.PRODUCT_CODE,
                S.PRODUCT_CODE_2,
            <cfelseif attributes.report_type eq 3>
                S.PRODUCT_CATID AS PRODUCT_GROUPBY_ID,
                PC.PRODUCT_CAT AS ACIKLAMA,
                PC.PRODUCT_CAT,
            <cfelseif attributes.report_type eq 4>
                S.PRODUCT_MANAGER AS PRODUCT_GROUPBY_ID,
                (EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME) AS ACIKLAMA,
                (SELECT TOP 1 PCC.PRODUCT_CAT FROM #dsn3_alias#.PRODUCT_CAT PCC WHERE S.PRODUCT_CATID = PCC.PRODUCT_CATID) AS PRODUCT_CAT,
            <cfelseif attributes.report_type eq 5>
                 PB.BRAND_ID AS PRODUCT_GROUPBY_ID,
                 PB.BRAND_NAME AS ACIKLAMA,
                 (SELECT TOP 1 PCC.PRODUCT_CAT FROM #dsn3_alias#.PRODUCT_CAT PCC WHERE S.PRODUCT_CATID = PCC.PRODUCT_CATID) AS PRODUCT_CAT,
            <cfelseif attributes.report_type eq 6>
                 S.COMPANY_ID AS PRODUCT_GROUPBY_ID,
                 C.NICKNAME AS ACIKLAMA,
                 (SELECT TOP 1 PCC.PRODUCT_CAT FROM #dsn3_alias#.PRODUCT_CAT PCC WHERE S.PRODUCT_CATID = PCC.PRODUCT_CATID) AS PRODUCT_CAT,
            <cfelseif attributes.report_type eq 9>
                 SR.STORE AS PRODUCT_GROUPBY_ID,
                 D.DEPARTMENT_HEAD AS ACIKLAMA,
                 (SELECT TOP 1 PCC.PRODUCT_CAT FROM #dsn3_alias#.PRODUCT_CAT PCC WHERE S.PRODUCT_CATID = PCC.PRODUCT_CATID) AS PRODUCT_CAT,
            <cfelseif attributes.report_type eq 10>
                (SELECT TOP 1 PCC.PRODUCT_CAT FROM #dsn3_alias#.PRODUCT PR LEFT JOIN #dsn3_alias#.PRODUCT_CAT PCC ON PCC.PRODUCT_CATID = PR.PRODUCT_CATID WHERE S.PRODUCT_ID = PR.PRODUCT_ID) AS PRODUCT_CAT,
                 CAST(SR.STORE AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.STORE_LOCATION,0) AS NVARCHAR(50)) AS PRODUCT_GROUPBY_ID,
                 D.DEPARTMENT_HEAD+' - '+SL.COMMENT AS ACIKLAMA,
            <cfelseif attributes.report_type eq 8>
                S.STOCK_CODE,
                S.STOCK_ID,
                (SELECT TOP 1 PCC.PRODUCT_CAT FROM #dsn3_alias#.PRODUCT PR LEFT JOIN #dsn3_alias#.PRODUCT_CAT PCC ON PCC.PRODUCT_CATID = PR.PRODUCT_CATID WHERE S.PRODUCT_ID = PR.PRODUCT_ID) AS PRODUCT_CAT,
                CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)) AS PRODUCT_GROUPBY_ID,
                SR.SPECT_VAR_ID SPECT_VAR_ID,
				<cfif isdefined('x_dsp_spec_name') and x_dsp_spec_name eq 1>
                    ISNULL((SELECT TOP 1 SPECT_MAIN_NAME FROM #dsn3_alias#.SPECT_MAIN SP WHERE SP.SPECT_MAIN_ID = SR.SPECT_VAR_ID),'') AS SPECT_NAME,
                </cfif>
                <cfif x_show_second_unit>
                    (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                    (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
                </cfif>	
                (S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,'')) ACIKLAMA,
                S.MANUFACT_CODE,
                S.PRODUCT_UNIT_ID,
                PU.MAIN_UNIT,
                PU.DIMENTION,
                S.BARCOD,
                S.PRODUCT_CODE,
             <cfelseif attributes.report_type eq 12>
                S.STOCK_CODE,
                S.STOCK_ID,
                <cfif x_show_second_unit>
                    (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                    (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
                </cfif>	
                (SELECT TOP 1 PCC.PRODUCT_CAT FROM #dsn3_alias#.PRODUCT PR LEFT JOIN #dsn3_alias#.PRODUCT_CAT PCC ON PCC.PRODUCT_CATID = PR.PRODUCT_CATID WHERE S.PRODUCT_ID = PR.PRODUCT_ID) AS PRODUCT_CAT,
                CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(REPLACE(SR.LOT_NO,'-','_'),0) AS NVARCHAR(50)) AS PRODUCT_GROUPBY_ID,
                SR.LOT_NO LOT_NO,
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
            <cfif listfind('2,3,4,5,6,9',attributes.report_type) and (isdefined("attributes.location_based_cost") or isdefined("attributes.department_based_cost")) and isdefined("attributes.display_cost")>
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
                        <cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                            AND PRODUCT_COST.STOCK_ID = SR.STOCK_ID 
                        </cfif>
                        <cfif isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")>
                            <cfif len(attributes.department_id)>
                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                <cfif listlen(attributes.department_id,'-') eq 2>
                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                </cfif>
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
                        START_DATE < #dateAdd('d',1,finish_date)#
                        AND PRODUCT_ID = S.PRODUCT_ID
                        <cfif attributes.report_type eq 8>
                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
                        </cfif>
                        <cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                            AND PRODUCT_COST.STOCK_ID = SR.STOCK_ID 
                        </cfif>
                        <cfif isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")>
                            <cfif len(attributes.department_id)>
                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                <cfif listlen(attributes.department_id,'-') eq 2>
                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                            	</cfif>
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
            <cfif listfind('3,8,12,5,9',attributes.report_type)>
                INTO  ####GET_ALL_STOCK_#session.ep.userid#
            </cfif>
            FROM        
            STOCKS_ROW  SR WITH (NOLOCK) INNER JOIN
            <cfif listfind('1,8,10,12',attributes.report_type)>
                #dsn3_alias#.STOCKS S WITH (NOLOCK) ON (SR.STOCK_ID=S.STOCK_ID)
            <cfelse>
                #dsn3_alias#.PRODUCT S WITH (NOLOCK) ON (SR.PRODUCT_ID=S.PRODUCT_ID)
            </cfif>
            <cfif get_cost_type.inventory_calc_type eq 3><!--- Ağırlıklı ortalama ise --->
                OUTER APPLY
                (
                    SELECT TOP 1
                        <cfif isdefined("attributes.location_based_cost") or isdefined("attributes.department_based_cost")>
                            <cfif isdefined("attributes.display_cost_money")>
                            	<cfif isdefined("attributes.location_based_cost")>
                                	(PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION) AS ALL_START_COST,
                                <cfelse>
                                	(PURCHASE_NET_DEPARTMENT_ALL+PURCHASE_EXTRA_COST_DEPARTMENT) AS ALL_START_COST,
                                </cfif>
                            <cfelse>
                            	<cfif isdefined("attributes.location_based_cost")>
                                	(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION) AS ALL_START_COST,
                                <cfelse>
                                	(PURCHASE_NET_SYSTEM_DEPARTMENT_ALL+PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT) AS ALL_START_COST,
                                </cfif>
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
                        <cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                            AND PRODUCT_COST.STOCK_ID = SR.STOCK_ID 
                        </cfif>
                        <cfif isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")>
                            <cfif len(attributes.department_id)>
                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                <cfif listlen(attributes.department_id,'-') eq 2>
                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                </cfif>
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
            <cfelse><!---Fifo ise --->
                OUTER APPLY
                (
                    SELECT TOP 1
                        LAST_COST_PRICE ALL_START_COST,
                        LAST_COST_PRICE/SM.RATE2 ALL_START_COST_2
                    FROM 
                        #dsn2_alias#.STOCKS_ROW_CLOSED WITH (NOLOCK),
                        #dsn2_alias#.SETUP_MONEY SM
                    WHERE 
                        PROCESS_DATE_OUT < #dateAdd('d',1,start_date)# 
                        AND SM.MONEY = '#session.ep.money2#'
                        AND PRODUCT_ID = S.PRODUCT_ID
                        <cfif attributes.report_type eq 8>
                             AND ISNULL(STOCKS_ROW_CLOSED.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
                        </cfif>
                        <cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                            AND STOCKS_ROW_CLOSED.STOCK_ID = SR.STOCK_ID 
                        </cfif>
                    ORDER BY 
                        PROCESS_DATE_OUT DESC, 
                        STOCKS_ROW_CLOSED.RECORD_DATE DESC,
                        STOCKS_ROW_CLOSED_ID DESC
                ) AS P
            </cfif>
            <cfif get_cost_type.inventory_calc_type eq 3><!--- Ağırlıklı ortalama ise --->
                OUTER APPLY
                (
                    SELECT TOP 1 
                        <cfif isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")>
                        	<cfif isdefined("attributes.location_based_cost")>
								<cfif isdefined("attributes.display_cost_money")>
                                    (PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION) AS ALL_FINISH_COST,
                                <cfelse>
                                    (PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION) AS ALL_FINISH_COST,
                                </cfif>
                            <cfelse>
                            	<cfif isdefined("attributes.display_cost_money")>
                                    (PURCHASE_NET_DEPARTMENT_ALL+PURCHASE_EXTRA_COST_DEPARTMENT) AS ALL_FINISH_COST,
                                <cfelse>
                                    (PURCHASE_NET_SYSTEM_DEPARTMENT_ALL+PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT) AS ALL_FINISH_COST,
                                </cfif>
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
                        START_DATE < #dateAdd('d',1,finish_date)# 
                        AND PRODUCT_ID = S.PRODUCT_ID
                        <cfif attributes.report_type eq 8>
                             AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
                        </cfif>
                        <cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                            AND PRODUCT_COST.STOCK_ID = SR.STOCK_ID 
                        </cfif>
                        <cfif isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")>
                            <cfif len(attributes.department_id)>
                                AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                <cfif listlen(attributes.department_id,'-') eq 2>
                                    AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                </cfif>
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
            <cfelse><!---Fifo ise --->
                OUTER APPLY
                (
                    SELECT TOP 1
                        LAST_COST_PRICE ALL_FINISH_COST,
                        LAST_COST_PRICE/SM.RATE2 ALL_FINISH_COST_2
                    FROM 
                        #dsn2_alias#.STOCKS_ROW_CLOSED WITH (NOLOCK),
                        #dsn2_alias#.SETUP_MONEY SM
                    WHERE 
                        PROCESS_DATE_OUT <= #finish_date# 
                        AND SM.MONEY = '#session.ep.money2#'
                        AND PRODUCT_ID = S.PRODUCT_ID
                        <cfif attributes.report_type eq 8>
                             AND ISNULL(STOCKS_ROW_CLOSED.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
                        </cfif>
                        <cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                            AND STOCKS_ROW_CLOSED.STOCK_ID = SR.STOCK_ID 
                        </cfif>
                    ORDER BY 
                        PROCESS_DATE_OUT DESC, 
                        STOCKS_ROW_CLOSED.RECORD_DATE DESC,
                        STOCKS_ROW_CLOSED_ID DESC
                ) AS P1,
            </cfif>
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
            <cfif listfind('2,3,4,5,6,9',attributes.report_type) and (isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")) and isdefined("attributes.display_cost")>
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
            <!--- rapor tipi lot no bazında alındığında da lot no girilmeden yapılan hareketlerin listeye gelmesi gerekir. Mahmut 13.10.2021
			<cfif attributes.report_type eq 12>
                AND SR.LOT_NO IS NOT NULL
            </cfif> --->
            <cfif attributes.report_type neq 9 and attributes.report_type neq 10>
                <cfif len(attributes.department_id)>
                    AND
                        (
                        <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                        (
                        	SR.STORE = #listfirst(dept_i,'-')# 
                            <cfif listlen(dept_i,'-') eq 2>
                                AND SR.STORE_LOCATION = #listlast(dept_i,'-')#
                            </cfif>
                        )
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
            <cfif listfind('1,8,12',attributes.report_type)>
                AND S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID
            <cfelse>
                AND PU.IS_MAIN = 1
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
            <cfelseif attributes.report_type eq 9>
            AND SR.STORE=D.DEPARTMENT_ID
            <cfelseif attributes.report_type eq 10>
            AND SR.STORE=D.DEPARTMENT_ID
            AND SR.STORE=SL.DEPARTMENT_ID
            AND SR.STORE_LOCATION=SL.LOCATION_ID
            </cfif>
            <cfif listfind('2,3,4,5,6,9',attributes.report_type) and (isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")) and isdefined("attributes.display_cost")>
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
            AND S.PRODUCT_CODE LIKE '#attributes.product_code#%'
            </cfif>
            <cfif listfind('1,2,3,4,5,6,8,9,10,12',attributes.report_type,',') and ((isdefined('attributes.control_total_stock') and len(attributes.control_total_stock)) or isdefined('attributes.is_stock_action'))><!--- sadece pozitif stoklar veya sadece hareket gormus stokların gelmesi --->
            AND <cfif attributes.report_type eq 8>(CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)))
			<cfelseif attributes.report_type eq 12> (CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(REPLACE(ISNULL(SR.LOT_NO,0),'-','_') AS NVARCHAR(50)))
			<cfelseif attributes.report_type eq 1 >S.STOCK_ID 
            <cfelse>S.PRODUCT_ID</cfif>
            <cfif isdefined('attributes.control_total_stock') and attributes.control_total_stock eq 0 and not isdefined('attributes.is_stock_action')>
                NOT IN
            <cfelse>
                IN
            </cfif>
                (
                SELECT   
                    <cfif attributes.report_type eq 8>
                        (CAST(SRW.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SRW.SPECT_VAR_ID,0) AS NVARCHAR(50))) <!--- spec bazında stok durumu kontrol ediliyor --->
                    <cfelseif attributes.report_type eq 1 >
                        SRW.STOCK_ID
					<cfelseif attributes.report_type eq 12>
                        (CAST(SRW.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(REPLACE(ISNULL(SRW.LOT_NO,0),'-','_') AS NVARCHAR(50))) 
                    <cfelse>
                        SRW.PRODUCT_ID	
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
                    AND SRW.PROCESS_DATE < #dateadd('d',1,attributes.date2)#	
                    <cfif isdefined('attributes.is_stock_action')>
                    	 AND SRW.PROCESS_DATE >= #attributes.date#	
                    </cfif>
                     <cfif attributes.report_type neq 9 and attributes.report_type neq 10>
                        <cfif len(attributes.department_id)>
                            AND
                                (
            
                                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                (
                                	SRW.STORE = #listfirst(dept_i,'-')# 
                                    <cfif listlen(dept_i,'-') eq 2>
                                        AND SRW.STORE_LOCATION = #listlast(dept_i,'-')#
                                   	</cfif>
                                )
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
                        GROUP BY                             
                        <cfif attributes.report_type eq 8>
                        SRW.STOCK_ID,ISNULL(SRW.SPECT_VAR_ID,0)
                        <cfelseif attributes.report_type eq 12>
                        SRW.STOCK_ID,ISNULL(SRW.LOT_NO,0)
                        <cfelseif attributes.report_type eq 1 >
                        SRW.STOCK_ID
                        <cfelse>
                        SRW.PRODUCT_ID
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
                STOCK_CODE
            <cfelse>
                ACIKLAMA
            </cfif>
        </cfquery>
		<cfif listfind('1,2',attributes.is_excel) and not isdefined('attributes.ajax')>
			<cfset page_maxrows = 100000>
		<cfelse>
			<cfset page_maxrows = attributes.maxrows>
		</cfif>
		<cfif listfind('1,2,8,12',attributes.report_type)>
			<cfif len(attributes.process_type) and (listfind(attributes.process_type,4) or listfind(attributes.process_type,5) or listfind(attributes.process_type,12) or listfind(attributes.process_type,9) or listfind(attributes.process_type,14) or listfind(attributes.process_type,18))>    	
        	
				<cfquery name="GET_STOCK_FIS" datasource="#dsn2#">
					SELECT
						GC.PRODUCT_ID,
						GC.STOCK_ID,
						<cfif stock_table>
                            S.PRODUCT_CATID,
                            S.BRAND_ID,
						</cfif>
						SF.DEPARTMENT_IN,
						SF.DEPARTMENT_OUT,
						SF.LOCATION_IN,
						SF.LOCATION_OUT,
                        SFR.AMOUNT,
						GC.STOCK_IN,
						GC.STOCK_OUT,
						((GC.MALIYET_2*ABS(GC.STOCK_IN-GC.STOCK_OUT))) AS TOTAL_COST_2,
						(GC.MALIYET*ABS(GC.STOCK_IN-GC.STOCK_OUT)) AS TOTAL_COST,
						<cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
							<cfif isdefined('attributes.is_system_money_2')> <!---  sistem 2. para br. checkboxı işaretlenmişse, maliyet para br. olarak sadece sistem para br secilebilir  --->
							GC.MALIYET MALIYET,
							GC.MALIYET_2 MALIYET_2,
                            ISNULL((SELECT TOP 1 
                                    (SFR.AMOUNT*ISNULL(COST_PRICE,0))/(SF_M.RATE2/SF_M.RATE1)
                                FROM 
                                    STOCK_FIS_ROW WITH (NOLOCK)
                                WHERE 
                                    STOCK_ID = GC.STOCK_ID AND
                                    FIS_ID = SF.FIS_ID
                            ),0) TOTAL_COST_PRICE_2,
                            ISNULL((SELECT TOP 1 
                                    (SFR.AMOUNT*ISNULL(EXTRA_COST,0))/(SF_M.RATE2/SF_M.RATE1)
                                FROM 
                                    STOCK_FIS_ROW WITH (NOLOCK)
                                WHERE 
                                    STOCK_ID = GC.STOCK_ID AND
                                    FIS_ID = SF.FIS_ID
                            ),0) TOTAL_EXTRA_COST_2,
							<cfelse>
							(GC.MALIYET/(SF_M.RATE2/SF_M.RATE1)) MALIYET,
							</cfif>
						<cfelse>
							(GC.MALIYET) MALIYET,
						</cfif>
						<cfif attributes.report_type eq 8>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
                        <cfif attributes.report_type eq 12>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(REPLACE(GC.LOT_NO,'-','_'),0) AS NVARCHAR(50)) STOCK_LOT_NO,
						</cfif>
						SF.FIS_DATE ISLEM_TARIHI,
						SF.PROCESS_CAT,
						SF.FIS_TYPE PROCESS_TYPE,
						ISNULL(SF.PROD_ORDER_NUMBER,0) AS PROD_ORDER_NUMBER,
						ISNULL(SF.PROD_ORDER_RESULT_NUMBER,0) AS PROD_ORDER_RESULT_NUMBER,
                        ISNULL((SELECT TOP 1 
                                    AMOUNT*ISNULL(COST_PRICE,0)
                                FROM 
                                    STOCK_FIS_ROW WITH (NOLOCK)
                                WHERE 
                                    STOCK_ID = GC.STOCK_ID AND
                                    FIS_ID = SF.FIS_ID
                            ),0) TOTAL_COST_PRICE,
                         ISNULL((SELECT TOP 1 
                                    AMOUNT*ISNULL(EXTRA_COST,0)
                                FROM 
                                    STOCK_FIS_ROW WITH (NOLOCK)
                                WHERE 
                                    STOCK_ID = GC.STOCK_ID AND
                                    FIS_ID = SF.FIS_ID
                            ),0) TOTAL_EXTRA_COST
					FROM 
                    	STOCK_FIS_ROW SFR WITH (NOLOCK),
						STOCK_FIS SF WITH (NOLOCK),
						<cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
						STOCK_FIS_MONEY SF_M,
						</cfif>
						<cfif is_store or isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")>
							<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC
							<cfelseif attributes.report_type eq 12>
								GET_STOCKS_ROW_COST_LOT_LOCATION AS GC
							<cfelse>
								GET_STOCKS_ROW_COST_LOCATION AS GC
							</cfif>
						<cfelse>
							<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT AS GC
							<cfelseif attributes.report_type eq 12>
								GET_STOCKS_ROW_COST_LOT AS GC
							<cfelse>
								(
									SELECT 
										PRODUCT_ID,
										STOCK_ID,
										SPECT_VAR_ID,
										LOT_NO,
										ISNULL((SELECT
											TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
										FROM 
											GET_PRODUCT_COST_PERIOD
										WHERE
											GET_PRODUCT_COST_PERIOD.START_DATE <= STOCKS_ROW.PROCESS_DATE
											AND GET_PRODUCT_COST_PERIOD.PRODUCT_ID = STOCKS_ROW.PRODUCT_ID
											AND ISNULL(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID,0)=ISNULL(STOCKS_ROW.SPECT_VAR_ID,0)
										ORDER BY
											GET_PRODUCT_COST_PERIOD.START_DATE DESC,
											GET_PRODUCT_COST_PERIOD.RECORD_DATE DESC,
											GET_PRODUCT_COST_PERIOD.PRODUCT_COST_ID DESC
											),0) AS MALIYET,
										ISNULL((SELECT
											TOP 1 (PURCHASE_NET_SYSTEM_2 + PURCHASE_EXTRA_COST_SYSTEM_2)  
										FROM 
											GET_PRODUCT_COST_PERIOD
										WHERE
											GET_PRODUCT_COST_PERIOD.START_DATE <= STOCKS_ROW.PROCESS_DATE
											AND GET_PRODUCT_COST_PERIOD.PRODUCT_ID = STOCKS_ROW.PRODUCT_ID
											AND ISNULL(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID,0)=ISNULL(STOCKS_ROW.SPECT_VAR_ID,0)
										ORDER BY 
											GET_PRODUCT_COST_PERIOD.START_DATE DESC,
											GET_PRODUCT_COST_PERIOD.RECORD_DATE DESC,
											GET_PRODUCT_COST_PERIOD.PRODUCT_COST_ID DESC
											),0) AS MALIYET_2,
										STOCK_IN,
										STOCK_OUT,
										UPD_ID,
										PROCESS_DATE,
										PROCESS_TYPE,
										STORE,
										STORE_LOCATION
									FROM 
										STOCKS_ROW 
								) AS GC
							</cfif>
						</cfif>
						<cfif stock_table>
						,#dsn3_alias#.STOCKS S WITH (NOLOCK)
						</cfif>
					WHERE 
						GC.UPD_ID = SF.FIS_ID AND
                        SFR.FIS_ID=	SF.FIS_ID AND
                        GC.STOCK_ID=SFR.STOCK_ID AND
						GC.PROCESS_TYPE = SF.FIS_TYPE AND
						<cfif stock_table>
						S.STOCK_ID = GC.STOCK_ID AND
						</cfif>
						SF.FIS_TYPE  IN (110,111,112,113,115,119) AND 
						SF.FIS_DATE >= #attributes.date# AND
						<cfif attributes.report_type eq 8>
						ISNULL((SELECT TOP 1 SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SFR.SPECT_VAR_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
						</cfif>
						SF.FIS_DATE < #DATEADD('d',1, attributes.date2)#
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
								(
                                	SF.DEPARTMENT_OUT = #listfirst(dept_i,'-')# 
                                	<cfif listlen(dept_i,'-') eq 2>
                                    	AND SF.LOCATION_OUT = #listlast(dept_i,'-')#
                                    </cfif>
                                )
								<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
							)
						OR 
							(
								SF.DEPARTMENT_IN IS NOT NULL AND
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
								(
                                	SF.DEPARTMENT_IN  = #listfirst(dept_i,'-')# 
                                    <cfif listlen(dept_i,'-') eq 2>
                                    	AND SF.LOCATION_IN = #listlast(dept_i,'-')#
                                    </cfif>
                                )
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
        	<cfif len(attributes.process_type) and listfind(attributes.process_type,21)>
				<cfquery name="GET_STOCK_VIRMAN_IN" datasource="#dsn2#" >
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
						ABS(GC.STOCK_IN-GC.STOCK_OUT)*ISNULL((SELECT TOP 1 
															(PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2)
														FROM 
															#dsn3_alias#.PRODUCT_COST 
														WHERE 
															START_DATE < SF.PROCESS_DATE AND
															PRODUCT_ID = SF.EXIT_PRODUCT_ID
														ORDER BY 
															START_DATE DESC, 
															RECORD_DATE DESC,
															PRODUCT_COST_ID DESC
													),0) AS TOTAL_COST_2,
						ABS(GC.STOCK_IN-GC.STOCK_OUT)*ISNULL((SELECT TOP 1 
															(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
														FROM 
															#dsn3_alias#.PRODUCT_COST 
														WHERE 
															START_DATE < SF.PROCESS_DATE AND
															PRODUCT_ID = SF.EXIT_PRODUCT_ID
														ORDER BY 
															START_DATE DESC, 
															RECORD_DATE DESC,
															PRODUCT_COST_ID DESC
													),0) AS TOTAL_COST,
						<cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
							<cfif isdefined('attributes.is_system_money_2')>
							ISNULL((SELECT TOP 1 
												(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
											FROM 
												#dsn3_alias#.PRODUCT_COST 
											WHERE 
												START_DATE < SF.PROCESS_DATE AND
												PRODUCT_ID = SF.EXIT_PRODUCT_ID
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0) MALIYET,
							ISNULL((SELECT TOP 1 
												(PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2)
											FROM 
												#dsn3_alias#.PRODUCT_COST 
											WHERE 
												START_DATE < SF.PROCESS_DATE AND
												PRODUCT_ID = SF.EXIT_PRODUCT_ID
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0) MALIYET_2,
							(SF.EXIT_AMOUNT*GC.MALIYET) AS TOTAL_COST_PRICE,
							0 AS TOTAL_EXTRA_COST,
							(SF.EXIT_AMOUNT*GC.MALIYET_2) AS TOTAL_COST_PRICE_2,
							0 AS TOTAL_EXTRA_COST_2,
							<cfelse>
								ISNULL((SELECT TOP 1 
												(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
											FROM 
												#dsn3_alias#.PRODUCT_COST 
											WHERE 
												START_DATE < SF.PROCESS_DATE AND
												PRODUCT_ID = SF.EXIT_PRODUCT_ID
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0) MALIYET,
								(SF.EXIT_AMOUNT*ISNULL((SELECT TOP 1 
												(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
											FROM 
												#dsn3_alias#.PRODUCT_COST 
											WHERE 
												START_DATE < SF.PROCESS_DATE AND
												PRODUCT_ID = SF.EXIT_PRODUCT_ID
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0)) AS TOTAL_COST_PRICE,
								0 AS TOTAL_EXTRA_COST,
							</cfif>
						<cfelse>
							ISNULL((SELECT TOP 1 
												(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
											FROM 
												#dsn3_alias#.PRODUCT_COST 
											WHERE 
												START_DATE < SF.PROCESS_DATE AND
												PRODUCT_ID = SF.EXIT_PRODUCT_ID
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0) MALIYET,
							(SF.EXIT_AMOUNT*ISNULL((SELECT TOP 1 
												(PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2)
											FROM 
												#dsn3_alias#.PRODUCT_COST 
											WHERE 
												START_DATE < SF.PROCESS_DATE AND
												PRODUCT_ID = SF.EXIT_PRODUCT_ID
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0)) AS TOTAL_COST_PRICE,
							0 AS TOTAL_EXTRA_COST,
						</cfif>
						<cfif attributes.report_type eq 8>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
                         <cfif attributes.report_type eq 12>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(REPLACE(GC.LOT_NO,'-','_'),0) AS NVARCHAR(50)) STOCK_LOT_NO,
						</cfif>
						SF.PROCESS_DATE ISLEM_TARIHI,
						SF.PROCESS_CAT,
						SF.PROCESS_TYPE,
						0 AS PROD_ORDER_NUMBER,
						0 AS PROD_ORDER_RESULT_NUMBER
					FROM 
						STOCK_EXCHANGE SF WITH (NOLOCK),
						<cfif is_store or isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")>
							<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC
							<cfelseif attributes.report_type eq 12>
								GET_STOCKS_ROW_COST_LOT_LOCATION AS GC
							<cfelse>
								GET_STOCKS_ROW_COST_LOCATION AS GC
							</cfif>
						<cfelse>
							<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT AS GC
							<cfelseif attributes.report_type eq 12>
								GET_STOCKS_ROW_COST_LOT AS GC
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
						ISNULL((SELECT TOP 1 SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SF.SPECT_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
						</cfif>
						SF.PROCESS_DATE < #DATEADD('d',1, attributes.date2)#
						<cfif len(attributes.department_id)>
						AND
						(
							SF.DEPARTMENT_ID IS NOT NULL AND
							<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(
                            	SF.DEPARTMENT_ID = #listfirst(dept_i,'-')# 
                                <cfif listlen(dept_i,'-') eq 2>
                                	AND SF.LOCATION_ID = #listlast(dept_i,'-')#
                            	</cfif>
                            )
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
				</cfquery>
				<cfquery name="GET_STOCK_VIRMAN_OUT" datasource="#dsn2#" >
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
                         <cfif attributes.report_type eq 12>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(REPLACE(GC.LOT_NO,'-','_'),0) AS NVARCHAR(50)) STOCK_LOT_NO,
						</cfif>
						SF.PROCESS_DATE ISLEM_TARIHI,
						SF.PROCESS_CAT,
						SF.PROCESS_TYPE,
						0 AS PROD_ORDER_NUMBER,
						0 AS PROD_ORDER_RESULT_NUMBER
					FROM 
						STOCK_EXCHANGE SF WITH (NOLOCK),
						<cfif is_store or isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")>
							<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC
							<cfelseif attributes.report_type eq 12>
								GET_STOCKS_ROW_COST_LOT_LOCATION AS GC
							<cfelse>
								GET_STOCKS_ROW_COST_LOCATION AS GC
							</cfif>
						<cfelse>
							<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT AS GC
							<cfelseif attributes.report_type eq 12>
								GET_STOCKS_ROW_COST_LOT AS GC
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
						ISNULL((SELECT TOP 1 SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SF.EXIT_SPECT_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
						</cfif>
						SF.PROCESS_DATE < #DATEADD('d',1, attributes.date2)#
						<cfif len(attributes.department_id)>
						AND
						(
							SF.EXIT_DEPARTMENT_ID IS NOT NULL AND
							<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(
                            	SF.EXIT_DEPARTMENT_ID = #listfirst(dept_i,'-')# 
                            	<cfif listlen(dept_i,'-') eq 2>
                            		AND SF.EXIT_LOCATION_ID = #listlast(dept_i,'-')#
                            	</cfif>
                            )
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
			<!--- demirbaş stok ve iade fişleri --->
			<cfif len(attributes.process_type) and listfind(attributes.process_type,22)>
				<cfquery name="GET_INVENT_STOCK_FIS" datasource="#dsn2#">
					SELECT
						S.PRODUCT_ID,
						S.STOCK_ID,
						S.PRODUCT_CATID,
						S.BRAND_ID,
						SFR.AMOUNT,
						SF.DEPARTMENT_OUT DEPARTMENT_ID,
						SF.LOCATION_OUT LOCATION_ID,
						0 STOCK_IN,
						SFR.AMOUNT STOCK_OUT,
						<cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
							<cfif isdefined('attributes.is_system_money_2')>
								ISNULL((SELECT TOP 1 
												(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
											FROM 
												#dsn3_alias#.PRODUCT_COST 
											WHERE 
												START_DATE <= SF.FIS_DATE AND
												PRODUCT_ID = S.PRODUCT_ID
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0) MALIYET,
								SFR.PRICE PRICE,
								ISNULL((SELECT TOP 1 
												(PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2)
											FROM 
												#dsn3_alias#.PRODUCT_COST 
											WHERE 
												START_DATE <= SF.FIS_DATE AND
												PRODUCT_ID = S.PRODUCT_ID
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0) MALIYET_2,
							<cfelse>
								ISNULL((SELECT TOP 1 
												(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
											FROM 
												#dsn3_alias#.PRODUCT_COST 
											WHERE 
												START_DATE <= SF.FIS_DATE AND
												PRODUCT_ID = S.PRODUCT_ID
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0) MALIYET,
								SFR.PRICE PRICE,
							</cfif>
						<cfelse>
							ISNULL((SELECT TOP 1 
												(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
											FROM 
												#dsn3_alias#.PRODUCT_COST 
											WHERE 
												START_DATE <= SF.FIS_DATE AND
												PRODUCT_ID = S.PRODUCT_ID
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0) MALIYET,
							SFR.PRICE PRICE,
						</cfif>
						<cfif attributes.report_type eq 8>
						CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = SFR.SPECT_VAR_ID),0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
                         <cfif attributes.report_type eq 12>
						CAST(SFR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(REPLACE(SFR.LOT_NO,'-','_'),0) AS NVARCHAR(50)) STOCK_LOT_NO,
						</cfif>
						SF.FIS_DATE ISLEM_TARIHI,
						SF.PROCESS_CAT,
						SF.FIS_TYPE PROCESS_TYPE,
						0 AS PROD_ORDER_NUMBER,
						0 AS PROD_ORDER_RESULT_NUMBER
					FROM 
						STOCK_FIS SF WITH (NOLOCK),
						STOCK_FIS_ROW SFR WITH (NOLOCK),
						#dsn3_alias#.STOCKS S WITH (NOLOCK)
						<cfif not (isdefined("attributes.is_stock_fis_control") and attributes.is_stock_fis_control eq 1)>
							,STOCKS_ROW SR WITH (NOLOCK)
						</cfif>
					WHERE 
						SF.FIS_ID = SFR.FIS_ID
						AND SF.FIS_TYPE = 118
						AND SF.FIS_DATE >= #attributes.date#
						AND SF.FIS_DATE < #DATEADD('d',1, attributes.date2)#
						<cfif not (isdefined("attributes.is_stock_fis_control") and attributes.is_stock_fis_control eq 1)>
							AND SR.UPD_ID = SF.FIS_ID
							AND SR.PROCESS_TYPE = SF.FIS_TYPE
						</cfif>
						<cfif isdefined("attributes.is_stock_fis_control") and attributes.is_stock_fis_control eq 1>
							AND SF.RELATED_SHIP_ID IS NOT NULL
						</cfif>
						AND S.STOCK_ID = SFR.STOCK_ID 
						<cfif len(attributes.department_id)>
							AND
							(
								SF.DEPARTMENT_OUT IS NOT NULL AND
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
								(
                                	SF.DEPARTMENT_OUT = #listfirst(dept_i,'-')# 
                                	<cfif listlen(dept_i,'-') eq 2>
                                    	AND SF.LOCATION_OUT = #listlast(dept_i,'-')#
                                	</cfif>
                                )
								<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
							)
						<cfelseif is_store>
							AND SF.DEPARTMENT_OUT IN (#branch_dep_list#)
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
				<cfquery name="GET_INVENT_STOCK_FIS_RETURN" datasource="#dsn2#" >
					SELECT
						S.PRODUCT_ID,
						S.STOCK_ID,
						S.PRODUCT_CATID,
						S.BRAND_ID,
						SFR.AMOUNT,
						SF.DEPARTMENT_IN DEPARTMENT_ID,
						SF.LOCATION_IN LOCATION_ID,
						SFR.AMOUNT STOCK_IN,
						0 STOCK_OUT,
						ABS(SFR.AMOUNT)*SFR.PRICE AS TOTAL_COST_2,
						ABS(SFR.AMOUNT)*SFR.PRICE AS TOTAL_COST,
						<cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
							<cfif isdefined('attributes.is_system_money_2')>
								ISNULL((SELECT TOP 1 
												(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
											FROM 
												#dsn3_alias#.PRODUCT_COST 
											WHERE 
												START_DATE <= SF.FIS_DATE AND
												PRODUCT_ID = SR.PRODUCT_ID
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0) MALIYET,
								SFR.PRICE PRICE,
								ISNULL((SELECT TOP 1 
												(PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2)
											FROM 
												#dsn3_alias#.PRODUCT_COST 
											WHERE 
												START_DATE <= SF.FIS_DATE AND
												PRODUCT_ID = S.PRODUCT_ID
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0) MALIYET_2,
							<cfelse>
								ISNULL((SELECT TOP 1 
												(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
											FROM 
												#dsn3_alias#.PRODUCT_COST 
											WHERE 
												START_DATE <= SF.FIS_DATE AND
												PRODUCT_ID = S.PRODUCT_ID
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0) MALIYET,
								SFR.PRICE PRICE,
							</cfif>
						<cfelse>
							ISNULL((SELECT TOP 1 
												(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
											FROM 
												#dsn3_alias#.PRODUCT_COST 
											WHERE 
												START_DATE <= SF.FIS_DATE AND
												PRODUCT_ID = S.PRODUCT_ID
											ORDER BY 
												START_DATE DESC, 
												RECORD_DATE DESC,
												PRODUCT_COST_ID DESC
										),0) MALIYET,
							SFR.PRICE PRICE,
						</cfif>
						<cfif attributes.report_type eq 8>
						CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = SFR.SPECT_VAR_ID),0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
                         <cfif attributes.report_type eq 12>
						CAST(SFR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(REPLACE(SFR.LOT_NO,'-','_'),0) AS NVARCHAR(50)) STOCK_LOT_NO,
						</cfif>
						SF.FIS_DATE ISLEM_TARIHI,
						SF.PROCESS_CAT,
						SF.FIS_TYPE PROCESS_TYPE,
						0 AS PROD_ORDER_NUMBER,
						0 AS PROD_ORDER_RESULT_NUMBER
					FROM 
						STOCK_FIS SF WITH (NOLOCK),
						STOCK_FIS_ROW SFR WITH (NOLOCK),
						#dsn3_alias#.STOCKS S WITH (NOLOCK)
						<cfif not (isdefined("attributes.is_stock_fis_control") and attributes.is_stock_fis_control eq 1)>
							,STOCKS_ROW SR WITH (NOLOCK)
						</cfif>
					WHERE 
						SF.FIS_ID = SFR.FIS_ID
						AND SF.FIS_TYPE = 1182
						AND SF.FIS_DATE < #DATEADD('d',1, attributes.date2)#
						AND SF.FIS_DATE >= #attributes.date#
						<cfif not (isdefined("attributes.is_stock_fis_control") and attributes.is_stock_fis_control eq 1)>
							AND SR.UPD_ID = SF.FIS_ID
							AND SR.PROCESS_TYPE = SF.FIS_TYPE
						</cfif>
						<cfif isdefined("attributes.is_stock_fis_control") and attributes.is_stock_fis_control eq 1>
							AND SF.RELATED_SHIP_ID IS NOT NULL
						</cfif>
						AND S.STOCK_ID = SFR.STOCK_ID 
						<cfif len(attributes.department_id)>
							AND
							(
								SF.DEPARTMENT_IN IS NOT NULL AND
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
								(
                                    SF.DEPARTMENT_IN = #listfirst(dept_i,'-')# 
                                    <cfif listlen(dept_i,'-') eq 2>
                                        AND SF.LOCATION_IN = #listlast(dept_i,'-')#
                                    </cfif>
                                )
								<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
							)
						<cfelseif is_store>
							AND SF.DEPARTMENT_IN IN (#branch_dep_list#)
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
				<cfquery name="GET_EXPENSE" datasource="#dsn2#" >
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
                         <cfif attributes.report_type eq 12>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(REPLACE(GC.LOT_NO,'-','_'),0) AS NVARCHAR(50)) STOCK_LOT_NO,
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
							<cfelseif attributes.report_type eq 12>
								GET_STOCKS_ROW_COST_LOT_LOCATION AS GC
							<cfelse>
								GET_STOCKS_ROW_COST_LOCATION AS GC
							</cfif>
						<cfelse>
							<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT AS GC
							<cfelseif attributes.report_type eq 12>
								GET_STOCKS_ROW_COST_LOT AS GC
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
						EIP.EXPENSE_DATE < #DATEADD('d',1, attributes.date2)# AND
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
								(
                                	EIP.DEPARTMENT_ID = #listfirst(dept_i,'-')# 
                                	<cfif listlen(dept_i,'-') eq 2>
                                    	AND EIP.LOCATION_ID = #listlast(dept_i,'-')#
                                    </cfif>
                                )
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
			<cfif len(attributes.process_type) and (listfind(attributes.process_type,14) or listfind(attributes.process_type,13))>
				<cfquery name="GET_DEMONTAJ" datasource="#dsn2#">
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
                         <cfif attributes.report_type eq 12>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(REPLACE(GC.LOT_NO,'-','_'),0) AS NVARCHAR(50)) STOCK_LOT_NO,
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
							<cfelseif attributes.report_type eq 12>
								GET_STOCKS_ROW_COST_LOT_LOCATION AS GC,
							<cfelse>
								GET_STOCKS_ROW_COST_LOCATION AS GC,
							</cfif>
						<cfelse>
							<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT AS GC,
							<cfelseif attributes.report_type eq 12>
								GET_STOCKS_ROW_COST_LOT AS GC,
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
						SF.FIS_DATE < #DATEADD('d',1, attributes.date2)#
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
									(
                                    	SF.DEPARTMENT_OUT = #listfirst(dept_i,'-')# 
                                        <cfif listlen(dept_i,'-') eq 2>
                                        	AND SF.LOCATION_OUT = #listlast(dept_i,'-')#
                                        </cfif>
                                    )
									<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
									</cfloop>  
								)
							OR 
								(
									SF.DEPARTMENT_IN IS NOT NULL AND
									<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
									(
                                    	SF.DEPARTMENT_IN  = #listfirst(dept_i,'-')# 
                                        <cfif listlen(dept_i,'-') eq 2>
                                        	AND SF.LOCATION_IN = #listlast(dept_i,'-')#
                                    	</cfif>
                                    )
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
			<cfif (len(attributes.process_type) and listfind(attributes.process_type,2)) or listfind(attributes.process_type,3) or isdefined('attributes.stock_rate')>
				<cfquery name="GET_INV_PURCHASE" datasource="#dsn2#">
					SELECT 
						IR.STOCK_ID,
						IR.PRODUCT_ID,
						<cfif attributes.report_type eq 8>
						CAST(IR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS NVARCHAR(50))  STOCK_SPEC_ID,
						</cfif>
                         <cfif attributes.report_type eq 12>
                    	'' as STOCK_LOT_NO,
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
						I.INVOICE_DATE < #DATEADD('d',1, attributes.date2)#
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
							(
                            	I.DEPARTMENT_ID = #listfirst(dept_i,'-')# 
                                <cfif listlen(dept_i,'-') eq 2>
                                	AND I.DEPARTMENT_LOCATION = #listlast(dept_i,'-')#
                                </cfif>
                            )
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
			<cfif len(attributes.process_type) or isdefined('attributes.stock_rate')>
				<cfquery name="GET_SHIP_ROWS" datasource="#dsn2#">
					SELECT
						GC.STOCK_ID,
						GC.PRODUCT_ID,
						<cfif attributes.report_type eq 8>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
                        <cfif attributes.report_type eq 12>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.LOT_NO,0) AS NVARCHAR(50)) STOCK_LOT_NO,
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
										(PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION)
									<cfelse>
										(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
									</cfif>
                                <cfelseif isdefined("attributes.department_based_cost")>
									<cfif isdefined("attributes.display_cost_money")>
										(PURCHASE_NET_DEPARTMENT_ALL+PURCHASE_EXTRA_COST_DEPARTMENT)
									<cfelse>
										(PURCHASE_NET_SYSTEM_DEPARTMENT_ALL+PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT)
									</cfif>
								<cfelse>
									<cfif isdefined("attributes.display_cost_money")>
										(PURCHASE_NET_ALL+PURCHASE_EXTRA_COST)
									<cfelse>
										(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
									</cfif>	
								</cfif>
							FROM 
								#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
							WHERE 
								START_DATE < #dateAdd('d',1,finish_date)#
								AND PRODUCT_ID = GC.PRODUCT_ID
								<cfif attributes.report_type eq 8>
									 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
								</cfif>
								<cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
									AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
								</cfif>
								<cfif isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")>
									<cfif len(attributes.department_id)>
										AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                        <cfif listlen(attributes.department_id,'-') eq 2>
                                            AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                        </cfif>
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
									(PURCHASE_NET_SYSTEM_2_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                <cfelseif isdefined("attributes.department_based_cost")>
                                	(PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL+PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT)
								<cfelse>
									(PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2)
								</cfif>
							FROM 
								#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
							WHERE 
								START_DATE < #dateAdd('d',1,finish_date)# 
								AND PRODUCT_ID = GC.PRODUCT_ID
								<cfif attributes.report_type eq 8>
									 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
								</cfif>
								<cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
									AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
								</cfif>
								<cfif isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")>
									<cfif len(attributes.department_id)>
										AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                        <cfif listlen(attributes.department_id,'-') eq 2>
                                            AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
										</cfif>
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
						<cfif is_store or isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")>
							<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
							<cfelseif attributes.report_type eq 12>
								GET_STOCKS_ROW_COST_LOT_LOCATION AS GC,
							<cfelse>
								GET_STOCKS_ROW_COST_LOCATION AS GC,
							</cfif>
						<cfelse>
							<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT AS GC,
							<cfelseif attributes.report_type eq 12>
								GET_STOCKS_ROW_COST_LOT AS GC,
							<cfelse>
								GET_STOCKS_ROW_COST AS GC,
							</cfif>
						</cfif>
						<cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3) or isdefined('attributes.stock_rate')>
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
						AND GC.PROCESS_TYPE <> 811
						AND GC.STORE_LOCATION=SL.LOCATION_ID
						<cfif not isdefined('is_belognto_institution')>
						AND SL.BELONGTO_INSTITUTION = 0
						</cfif>
						<cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3) or isdefined('attributes.stock_rate')>
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
						AND GC.PROCESS_DATE < #DATEADD('d',1,attributes.date2)#
						<cfif len(attributes.department_id)>
						AND
							(
							<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(
                            	GC.STORE = #listfirst(dept_i,'-')# 
                             	<cfif listlen(dept_i,'-') eq 2>
                                	AND GC.STORE_LOCATION = #listlast(dept_i,'-')#
                                </cfif>
                             )
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
				<cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3) or isdefined('attributes.stock_rate')>
				UNION ALL
					SELECT
						GC.STOCK_ID,
						GC.PRODUCT_ID,
						<cfif attributes.report_type eq 8>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
                         <cfif attributes.report_type eq 12>
						CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.LOT_NO,0) AS NVARCHAR(50)) STOCK_LOT_NO,
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
										(PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION)
									<cfelse>
										(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION)
									</cfif>
                                <cfelseif isdefined("attributes.department_based_cost")>
									<cfif isdefined("attributes.display_cost_money")>
										(PURCHASE_NET_DEPARTMENT_ALL+PURCHASE_EXTRA_COST_DEPARTMENT)
									<cfelse>
										(PURCHASE_NET_SYSTEM_DEPARTMENT_ALL+PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT)
									</cfif>
								<cfelse>
									<cfif isdefined("attributes.display_cost_money")>
										(PURCHASE_NET_ALL+PURCHASE_EXTRA_COST)
									<cfelse>
										(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
									</cfif>	
								</cfif>
							FROM 
								#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
							WHERE 
								START_DATE < #dateAdd('d',1,finish_date)#
								AND PRODUCT_ID = GC.PRODUCT_ID
								<cfif attributes.report_type eq 8>
									 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
								</cfif>
								<cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
									AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
								</cfif>
								<cfif isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")>
									<cfif len(attributes.department_id)>
										AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                        <cfif listlen(attributes.department_id,'-') eq 2>
											AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                        </cfif>
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
									(PURCHASE_NET_SYSTEM_2_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)
                                <cfelseif isdefined("attributes.department_based_cost")>
                                	(PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL+PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT)
								<cfelse>
									(PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2)
								</cfif>
							FROM 
								#dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
							WHERE 
								START_DATE < #dateAdd('d',1,finish_date)#
								AND PRODUCT_ID = GC.PRODUCT_ID
								<cfif attributes.report_type eq 8>
									 AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
								</cfif>
								<cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
									AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
								</cfif>
								<cfif isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")>
									<cfif len(attributes.department_id)>
										AND DEPARTMENT_ID = #listgetat(attributes.department_id,1,'-')#
                                        <cfif listlen(attributes.department_id,'-') eq 2>
											AND LOCATION_ID = #listgetat(attributes.department_id,2,'-')#
                                        </cfif>
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
						<cfif is_store or isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost")>
							<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT_LOCATION AS GC,
							<cfelseif attributes.report_type eq 12>
								GET_STOCKS_ROW_COST_LOT_LOCATION AS GC,
							<cfelse>
								GET_STOCKS_ROW_COST_LOCATION AS GC,
							</cfif>
						<cfelse>
							<cfif attributes.report_type eq 8>
								GET_STOCKS_ROW_COST_SPECT AS GC,
							<cfelseif attributes.report_type eq 12>
								GET_STOCKS_ROW_COST_LOT AS GC,
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
						AND GC.PROCESS_DATE < #DATEADD('d',1, attributes.date2)#
						<cfif len(attributes.department_id)>
						AND
							(
							<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(
                            	GC.STORE = #listfirst(dept_i,'-')# 
                                <cfif listlen(dept_i,'-') eq 2>
                                	AND GC.STORE_LOCATION = #listlast(dept_i,'-')#
                            	</cfif>
                            )
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
						CAST(IR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS NVARCHAR(50))  STOCK_SPEC_ID,
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
					I.SHIP_DATE < #DATEADD('d',1, attributes.date2)#
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
						CAST(IR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS NVARCHAR(50))  STOCK_SPEC_ID,
					</cfif>
					IR.AMOUNT,
					I.FIS_DATE ISLEM_TARIHI,
					ISNULL(DATEDIFF(day,DATEADD(day,-1*DUE_DATE,FIS_DATE),#attributes.date2#),DATEDIFF(day,FIS_DATE,#attributes.date2#)) AS GUN_FARKI,
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
					I.FIS_DATE < #DATEADD('d',1, attributes.date2)#
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
		<cfif listfind('3,8,5,12,9',attributes.report_type)>
        	<cfquery name="check_table" datasource="#dsn2#">
            	IF EXISTS(SELECT * FROM tempdb.sys.tables where name = '####GET_STOCK_ROWS_#session.ep.userid#')
                BEGIN
                	DROP TABLE ####GET_STOCK_ROWS_#session.ep.userid#
                END
            </cfquery>
        </cfif>
        <cfquery name="GET_STOCK_ROWS" datasource="#dsn2#">
			SELECT 
				SR.UPD_ID,
				S.STOCK_ID,
				S.PRODUCT_ID,
				<cfif listfind('2,3,4,5,6,9',attributes.report_type) and (isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost"))>
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
                <cfif attributes.report_type eq 12>
                	CAST(SR.STOCK_ID AS NVARCHAR(50))+'_'+CAST(ISNULL(REPLACE(SR.LOT_NO,'-','_'),0) AS NVARCHAR(50)) AS STOCK_LOT_NO,
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
			<cfif listfind('3,8,5,12,9',attributes.report_type)>
            	INTO ####GET_STOCK_ROWS_#session.ep.userid#
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
				AND SR.PROCESS_DATE < #DATEADD('d',1, attributes.date2)#	
				<cfif len(attributes.department_id)>
				AND
					(
					<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
					(
                    	SR.STORE = #listfirst(dept_i,'-')# 
                        <cfif listlen(dept_i,'-') eq 2>
                            AND SR.STORE_LOCATION = #listlast(dept_i,'-')#
                        </cfif>
                    )
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
				<!--- rapor tipi lot no bazında alındığında da lot no girilmeden yapılan hareketlerin listeye gelmesi gerekir. Mahmut 13.10.2021
                <cfif attributes.report_type eq 12>
                    AND SR.LOT_NO IS NOT NULL
                </cfif> --->
			GROUP BY
				SR.UPD_ID,
				S.STOCK_ID,
				S.PRODUCT_ID,
                SR.SPECT_VAR_ID,
				<cfif listfind('2,3,4,5,6,9',attributes.report_type) and (isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost"))>
					SR.STORE,
					SR.STORE_LOCATION,
				</cfif>
                <cfif attributes.report_type eq 8>
                	CAST(SR.STOCK_ID AS NVARCHAR(50))+'_'+CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)),
                </cfif>
                  <cfif attributes.report_type eq 12>
                	CAST(SR.STOCK_ID AS NVARCHAR(50))+'_'+CAST(ISNULL(REPLACE(SR.LOT_NO,'-','_'),0) AS NVARCHAR(50)),
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
        <cfif listfind('3,8,5,12,9',attributes.report_type)>
            <cfquery name="check_table" datasource="#dsn2#">
                IF EXISTS(SELECT * FROM tempdb.sys.tables where name = '####acilis_stok2_#session.ep.userid#')
                    BEGIN
                        DROP TABLE ####acilis_stok2_#session.ep.userid#
                    END
                IF EXISTS(SELECT * FROM tempdb.sys.tables where name = '####get_total_stok_#session.ep.userid#')
                    BEGIN
                        DROP TABLE ####get_total_stok_#session.ep.userid#
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
                INTO ####acilis_stok2_#session.ep.userid#
                FROM
                    (
                    SELECT * FROM ####GET_STOCK_ROWS_#session.ep.userid#
                    ) AS 
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
            <cfquery name="get_total_stok" datasource="#dsn2#">
                SELECT 
                    SUM(AMOUNT) AS TOTAL_STOCK,
                    SUM(AMOUNT*MALIYET) AS TOTAL_PRODUCT_COST,
                    <cfif isdefined('attributes.is_system_money_2')>
                    SUM(AMOUNT*MALIYET_2) AS TOTAL_PRODUCT_COST_2,
                    </cfif>
                    <cfif listfind('2,3,4,5,6,9',attributes.report_type) and (isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost"))>
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
                     ) AS 
                       GET_STOCK_ROWS
                WHERE
                    ISLEM_TARIHI < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1, attributes.date2)#">
                    <cfif not len(attributes.department_id) and attributes.report_type neq 9 and attributes.report_type neq 10>
                    AND PROCESS_TYPE NOT IN (81,811)
                    </cfif>
                GROUP BY
                    <cfif listfind('2,3,4,5,6,9',attributes.report_type) and (isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost"))>
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
            <cfif listfind('8,12',attributes.report_type)>
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
            <cfelseif listfind('3,5,9',attributes.report_type)>
            	<cfquery name="get_all_stock" datasource="#dsn2#">
                    SELECT
                         SUM(ISNULL(GTS.TOTAL_STOCK,0)) AS TOTAL_STOCK ,
                         SUM(ISNULL(GTS.TOTAL_PRODUCT_COST,0)) AS TOTAL_PRODUCT_COST,
                         SUM(ISNULL(AST.DB_STOK_MIKTAR,0)) AS DB_STOK_MIKTAR ,
                         SUM(ISNULL(AST.DB_STOK_MALIYET,0)) AS  DB_STOK_MALIYET,
                         SUM(ISNULL(GTS.TOTAL_STOCK*ALL_FINISH_COST,0)) AS MALIYET,
                         SUM(ISNULL(GTS.TOTAL_STOCK*ALL_FINISH_COST_2,0)) AS MALIYET2,
                         PRODUCT_GROUPBY_ID,
                         ACIKLAMA    
                    FROM
                        ####GET_ALL_STOCK_#session.ep.userid#  GAS  
                    LEFT JOIN
                        ####get_total_stok_#session.ep.userid# GTS
                    ON
                        GAS.PRODUCT_ID = GTS.GROUPBY_ALANI   
                    LEFT JOIN
                        ####acilis_stok2_#session.ep.userid# AST		    
                    ON 
                        GAS.PRODUCT_ID = AST.GROUPBY_ALANI
                    GROUP BY 
                    	PRODUCT_GROUPBY_ID,ACIKLAMA    
                </cfquery>
            </cfif>
            <cfset GET_STOCK_ROWS.recordcount = 0 >
        </cfif>
   </cfif>
<cfelse>
	<cfscript>
		GET_STOCK_ROWS.recordcount = 0;
		GET_ALL_STOCK.recordcount = 0;
		GET_TOTAL_STOK.recordcount = 0;
		GET_ALL_STOCK.query_count = 0;
		GET_INV_PURCHASE.recordcount = 0;
		GET_SHIP_ROWS.recordcount = 0;
		GET_DS_SPEC_COST.recordcount = 0;
		DB_SPEC_COST.recordcount = 0;
		GET_EXPENSE.recordcount = 0;
	</cfscript>
</cfif>
<cfif attributes.report_type neq 7><!--- belge bazında raporlama degilse  --->
	<cfparam name="attributes.totalrecords" default="#get_all_stock.recordcount#"><!--- belge bazında raporlama secilmis ise detail_stock_row_list.cfm de set ediliyor  --->
    <cfif GET_STOCK_ROWS.recordcount>
		<cfif not listfind('3,5,8,12,9',attributes.report_type)>
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
                    <cfif listfind('2,3,4,5,6,9',attributes.report_type) and (isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost"))>
                        STORE,
                        STORE_LOCATION,
                    </cfif>
                    <cfif attributes.report_type eq 9 or attributes.report_type eq 10>
                       PRODUCT_ID AS GROUPBY_ALANI,
                       #ALAN_ADI# AS GROUPBY_ALANI_2
                    <cfelse>
                       #ALAN_ADI# AS GROUPBY_ALANI
                    </cfif>
                FROM
                    GET_STOCK_ROWS
                WHERE
                    ISLEM_TARIHI < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1, attributes.date2)#">
                    <cfif not len(attributes.department_id) and attributes.report_type neq 9 and attributes.report_type neq 10>
                    AND PROCESS_TYPE NOT IN (81,811)
                    </cfif>
                GROUP BY
                    <cfif listfind('2,3,4,5,6,9',attributes.report_type) and (isdefined("attributes.location_based_cost") OR isdefined("attributes.department_based_cost"))>
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
        </cfif>
      <!---depo-lokasyon secili, islem tiplerinde de ithal mal girişi secili ise ithal mal girişi ayrı bölümde gosterilir.--->
	<cfelse>
		<cfset acilis_stok2.recordcount = 0>
		<cfset get_total_stok.recordcount = 0>
	</cfif>
    <cfif listfind('1,2,8,12',attributes.report_type)>
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
					PROCESS_TYPE = 78
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
		<cfif len(attributes.process_type) and listfind(attributes.process_type,17)>
			<cfquery name="get_ithal_mal_girisi_total" datasource="#dsn2#">
				SELECT 
					SUM(STOCK_IN) AS ITHAL_MAL_GIRIS_MIKTARI,
					SUM(STOCK_IN*MALIYET_IN) AS ITHAL_MAL_GIRIS_MALIYETI,
					SUM(STOCK_OUT) AS ITHAL_MAL_CIKIS_MIKTARI,
					SUM(STOCK_OUT*MALIYET_OUT) AS ITHAL_MAL_CIKIS_MALIYETI,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(STOCK_IN*MALIYET_IN_2) AS ITHAL_MAL_GIRIS_MALIYETI_2,
					SUM(STOCK_OUT*MALIYET_OUT_2) AS ITHAL_MAL_CIKIS_MALIYETI_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
				(
					SELECT
						S.PRODUCT_ID,
						S.STOCK_ID,
						<cfif attributes.report_type eq 8>
							CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT TOP 1 SP.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = ISNULL(SR.SPECT_VAR_ID,0)),0) AS NVARCHAR(50)) STOCK_SPEC_ID,
						</cfif>
                        <cfif attributes.report_type eq 12>
							CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(REPLACE(SR.LOT_NO,'-','_'),0) AS NVARCHAR(50))  STOCK_LOT_NO,
						</cfif>
						<cfif stock_table>
                            S.PRODUCT_CATID,
                            S.BRAND_ID,
						</cfif>
						SRR.STOCK_IN,
						SRR.STOCK_OUT,
						(((SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000))+EXTRA_COST MALIYET_IN,
						(((SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000))+ISNULL((SELECT TOP 1 IRR.EXTRA_COST FROM INVOICE_ROW IRR WHERE IRR.INVOICE_ID = SR.IMPORT_INVOICE_ID AND SR.IMPORT_PERIOD_ID = #session.ep.period_id# AND IRR.STOCK_ID = SR.STOCK_ID),0) MALIYET_OUT,
						<cfif isdefined('attributes.is_system_money_2')>
							((((SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000))+EXTRA_COST)/SM.RATE2 MALIYET_IN_2,
							((((SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)))/SM.RATE2 MALIYET_OUT_2,
						</cfif>
						SS.SHIP_DATE ISLEM_TARIHI,
						SRR.PROCESS_TYPE
					FROM
						(
							SELECT 
                                SUM(PRICE) PRICE,
                                SUM(DISCOUNT) DISCOUNT,
                                SUM(DISCOUNT2) DISCOUNT2,
                                SUM(DISCOUNT3) DISCOUNT3,
                                SUM(DISCOUNT4) DISCOUNT4,
                                SUM(DISCOUNT5) DISCOUNT5,
                                SUM(EXTRA_COST)  EXTRA_COST,
                                IMPORT_INVOICE_ID,
                                IMPORT_PERIOD_ID,
                                STOCK_ID,
                                LOT_NO,
                                SHIP_ID
                                FROM 
                                SHIP_ROW 
							GROUP BY 
                                STOCK_ID,
                                LOT_NO,
                                SHIP_ID ,
                                IMPORT_INVOICE_ID,
                                IMPORT_PERIOD_ID

                            ) AS  SR,
                            (
						SELECT 
                            PROCESS_TYPE,
                            UPD_ID,
                            STORE,
                            STORE_LOCATION,
                            PROCESS_DATE,
                            STOCK_ID,
                            SUM(STOCK_IN) AS STOCK_IN ,
                            SUM(STOCK_OUT) AS STOCK_OUT
						FROM
                            STOCKS_ROW 
						WHERE
							PROCESS_TYPE = 811
                        GROUP BY 
                            PROCESS_TYPE,
                            UPD_ID,
                            STORE_LOCATION,
                            STORE,
                            PROCESS_DATE,
                            STOCK_ID
						) AS SRR,
						SHIP SS,
						#dsn3_alias#.STOCKS S,
						#dsn_alias#.STOCKS_LOCATION SL
						<cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
							,SHIP_MONEY SM
						</cfif>
					WHERE
						SR.SHIP_ID = SS.SHIP_ID
						AND SR.STOCK_ID = S.STOCK_ID
						AND SRR.UPD_ID = SS.SHIP_ID
						AND SRR.PROCESS_TYPE = SS.SHIP_TYPE
						AND SS.SHIP_TYPE = 811
						AND SL.DEPARTMENT_ID = SRR.STORE
						AND SRR.STOCK_ID = Sr.STOCK_ID
						AND SRR.STORE_LOCATION=SL.LOCATION_ID
						<cfif not isdefined('is_belognto_institution')>
						AND SL.BELONGTO_INSTITUTION = 0
						</cfif>
						<cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
							AND SS.SHIP_ID = SM.ACTION_ID
							<cfif isdefined('attributes.is_system_money_2')>
								AND SM.MONEY_TYPE = '#session.ep.money2#'
							<cfelse>
								AND SM.MONEY_TYPE = '#attributes.cost_money#'
							</cfif>
						</cfif>
						AND SRR.PROCESS_DATE >= #attributes.date#
						AND SRR.PROCESS_DATE < #DATEADD('d',1, attributes.date2)#
						<cfif len(attributes.department_id)>
						AND
							(
							<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(SRR.STORE = #listfirst(dept_i,'-')# 
                            <cfif listlen(dept_i,'-') eq 2>
                            	AND SRR.STORE_LOCATION = #listlast(dept_i,'-')#
                            </cfif>
                            )
							<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
							</cfloop>  
							)
						<cfelseif is_store>
							AND SRR.STORE IN (#branch_dep_list#)
						</cfif>
						<cfif stock_table>
						AND	SRR.STOCK_ID=S.STOCK_ID
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
				)T1
				WHERE
					ISLEM_TARIHI < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1, attributes.date2)#">
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
					ISLEM_TARIHI < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1, attributes.date2)#">
					AND PROCESS_TYPE = 81
				GROUP BY
					#ALAN_ADI#
				ORDER BY
					#ALAN_ADI# 
			</cfquery>
		</cfif>
		<cfif (len(attributes.process_type) and listfind(attributes.process_type,3)) or isdefined('attributes.stock_rate')>
			<cfif isdefined('attributes.from_invoice_actions')>
                <cfquery name="d_fatura_satis_tutar" dbtype="query">
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
                        <cfif isdefined('x_show_sale_inoice_cost') and x_show_sale_inoice_cost eq 1><!--- satış faturası satırlarındaki maliyet alınıyor --->
                            SUM(INV_COST+INV_EXTRA_COST) AS  FATURA_SATIS_IADE_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                                SUM(INV_COST_2+INV_EXTRA_COST_2) AS FATURA_SATIS_IADE_MALIYET_2,
                            </cfif>
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
		<!--- Mal Satıs İrsaliyelerindeki toplam miktar, ihracat irsaliyesi dahil (Alış iadeler ve Sevkıyatta Birleştirilen ürünler olmayacak)--->
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
					PROCESS_TYPE IN (70,71,88)
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
				UNION ALL
				SELECT	
					SUM(AMOUNT) AS TOPLAM_SATIS_IADE,
					SUM(BIRIM_COST) AS TOP_SAT_IADE_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(BIRIM_COST_2) AS TOP_SAT_IADE_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_INV_PURCHASE
				WHERE
					PROCESS_TYPE IN (690)
					AND IS_RETURN = 1
				GROUP BY
					#ALAN_ADI#	
			</cfquery>
		</cfif>
		<!--- giden konsinye --->
		<cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
			<cfquery name="konsinye_cikis" dbtype="query">
				SELECT	
					SUM(AMOUNT) AS KONS_CIKIS_MIKTAR,
					<cfif x_kons_cost_date eq 1>
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
					<cfif x_kons_cost_date eq 1>
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
					<cfif x_kons_cost_date eq 1>
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
					<cfif x_kons_cost_date eq 1>
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
		<!--- RMA Giriş :Servis - Üreticiden Giriş İrsaliyesi  --->
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
		<!--- RMA Çıkış :Servis-Üreticiye Çıkış İrsaliyesi (Çıkış)--->
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
					SUM(STOCK_IN) AS TOPLAM_URETIM,
					SUM(TOTAL_COST_PRICE+TOTAL_EXTRA_COST) AS URETIM_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
						SUM(TOTAL_COST_PRICE_2+TOTAL_EXTRA_COST) AS URETIM_MALIYET_2,
					</cfif>
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
					ISLEM_TARIHI < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1, attributes.date2)#">
					AND PROCESS_TYPE = 113
					<cfif len(attributes.department_id)>
					AND(
						DEPARTMENT_IN IS NOT NULL AND
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(
                        	DEPARTMENT_IN  = #listfirst(dept_i,'-')# 
                            <cfif listlen(dept_i,'-') eq 2>
                            	AND LOCATION_IN = #listlast(dept_i,'-')#
                            </cfif>
                        )
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
					ISLEM_TARIHI < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1, attributes.date2)#">
					AND PROCESS_TYPE = 113
					<cfif len(attributes.department_id)>
					AND(
						DEPARTMENT_OUT IS NOT NULL AND
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(
                        	DEPARTMENT_OUT  = #listfirst(dept_i,'-')# 
                            <cfif listlen(dept_i,'-') eq 2>
                            	AND LOCATION_OUT = #listlast(dept_i,'-')#
                            </cfif>
                        )
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
		<cfif len(attributes.process_type) and listfind(attributes.process_type,21)>
			<cfquery name="get_stok_virman_total_in" dbtype="query">
				SELECT 
					SUM(STOCK_IN) AS STOK_VIRMAN_GIRIS_MIKTARI,
					SUM(STOCK_IN*MALIYET) AS STOK_VIRMAN_GIRIS_MALIYETI,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(STOCK_IN*MALIYET_2) AS STOK_VIRMAN_GIRIS_MALIYETI_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_STOCK_VIRMAN_IN
				WHERE
					ISLEM_TARIHI < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1, attributes.date2)#">
					<cfif len(attributes.department_id)>
					AND(
						DEPARTMENT_IN IS NOT NULL AND
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(
                        	DEPARTMENT_IN  = #listfirst(dept_i,'-')# 
                            <cfif listlen(dept_i,'-') eq 2>
                            	AND LOCATION_IN = #listlast(dept_i,'-')#
                            </cfif>
                        )
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
						</cfloop>  
					)
					</cfif>
				GROUP BY
					#ALAN_ADI#
				ORDER BY
					#ALAN_ADI# 
			</cfquery>
			<cfquery name="get_stok_virman_total_out" dbtype="query">
				SELECT 
					SUM(STOCK_OUT) AS STOK_VIRMAN_CIKIS_MIKTARI,
					SUM(STOCK_OUT*MALIYET) AS STOK_VIRMAN_CIKIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(STOCK_OUT*MALIYET_2) AS STOK_VIRMAN_CIKIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_STOCK_VIRMAN_OUT
				WHERE
					ISLEM_TARIHI < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1, attributes.date2)#">
					<cfif len(attributes.department_id)>
					AND(
						DEPARTMENT_OUT IS NOT NULL AND
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(
                        	DEPARTMENT_OUT  = #listfirst(dept_i,'-')# 
                            <cfif listlen(dept_i,'-') eq 2>
                            	AND LOCATION_OUT = #listlast(dept_i,'-')#
                            </cfif>
                        )
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
		<cfif len(attributes.process_type) and listfind(attributes.process_type,22)>
			<cfquery name="get_invent_stock_fis_all" dbtype="query">
				SELECT 
					SUM(STOCK_OUT) AS AMOUNT,
					SUM(STOCK_OUT*MALIYET) AS COST,
					SUM(STOCK_OUT*PRICE) AS PRICE,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(STOCK_OUT*MALIYET_2) AS COST_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_INVENT_STOCK_FIS
				WHERE
					ISLEM_TARIHI < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1, attributes.date2)#">
					<cfif len(attributes.department_id)>
					AND(
						DEPARTMENT_ID IS NOT NULL AND
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(
                        	DEPARTMENT_ID = #listfirst(dept_i,'-')# 
                        	<cfif listlen(dept_i,'-') eq 2>
                            	AND LOCATION_ID = #listlast(dept_i,'-')#
                            </cfif>
                        )
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
						</cfloop>  
					)
					</cfif>
				GROUP BY
					#ALAN_ADI#
				ORDER BY
					#ALAN_ADI# 
			</cfquery>
			<cfquery name="get_invent_stock_fis_return_all" dbtype="query">
				SELECT 
					SUM(STOCK_IN) AS AMOUNT,
					SUM(STOCK_IN*MALIYET) AS COST,
					SUM(STOCK_IN*PRICE) AS PRICE,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(STOCK_IN*MALIYET_2) AS COST_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					GET_INVENT_STOCK_FIS_RETURN
				WHERE
					ISLEM_TARIHI < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1, attributes.date2)#">
					<cfif len(attributes.department_id)>
					AND(
						DEPARTMENT_ID IS NOT NULL AND
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(
                        	DEPARTMENT_ID  = #listfirst(dept_i,'-')# 
                            <cfif listlen(dept_i,'-') eq 2>
                            	AND LOCATION_ID = #listlast(dept_i,'-')#
                            </cfif>
                        )
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
	<cfif GET_ALL_STOCK.recordcount>
		<cfif listfind('4,6,9,10', attributes.report_type)>
			<cfquery name="GET_PROD_CATS" dbtype="query">
				SELECT DISTINCT PRODUCT_GROUPBY_ID,ACIKLAMA FROM GET_ALL_STOCK
			</cfquery>
			<cfset attributes.totalrecords='#GET_PROD_CATS.recordcount#'>
			<cfoutput query="GET_ALL_STOCK">
				<cfscript>
					//specli urunler icin donem sonu miktar ve maliyetleri set ediliyor
					if(isdefined('DONEM_SONU_SPEC_COST') and (DONEM_SONU_SPEC_COST.recordcount gt 0) )
					{
						for(tyy=1; tyy lte DONEM_SONU_SPEC_COST.recordcount; tyy=tyy+1)
						{
							if(DONEM_SONU_SPEC_COST.GROUPBY_ALANI[tyy] eq GET_ALL_STOCK.PRODUCT_ID) 
							{
								'donem_sonu_specli_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = DONEM_SONU_SPEC_COST.DONEM_SONU_COST[tyy];
								'donem_sonu_specli_maliyet_br_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = DONEM_SONU_SPEC_COST.SPEC_COST[tyy];
								if(isdefined('attributes.is_system_money_2'))
								{
									'donem_sonu_specli_maliyet2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = DONEM_SONU_SPEC_COST.DONEM_SONU_COST_2[tyy];
									'donem_sonu_specli_maliyet2_br_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = DONEM_SONU_SPEC_COST.SPEC_COST_2[tyy];
								}
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
						if(attributes.report_type eq 9 or attributes.report_type eq 10)
						{
							if(attributes.report_type eq 9 and isdefined("attributes.location_based_cost"))
							{
								if(get_total_stok.GROUPBY_ALANI[tt] eq GET_ALL_STOCK.PRODUCT_ID and get_total_stok.GROUPBY_ALANI_2[tt] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID and get_total_stok.STORE[tt] eq GET_ALL_STOCK.DEPARTMENT_ID and get_total_stok.STORE_LOCATION[tt] eq GET_ALL_STOCK.LOCATION_ID) 
								{
									'donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#' = get_total_stok.TOTAL_STOCK[tt];
									break;
								}
							}
							else if(attributes.report_type eq 9 and isdefined("attributes.department_based_cost"))
							{
								if(get_total_stok.GROUPBY_ALANI[tt] eq GET_ALL_STOCK.PRODUCT_ID and get_total_stok.GROUPBY_ALANI_2[tt] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID and get_total_stok.STORE[tt] eq GET_ALL_STOCK.DEPARTMENT_ID) 
								{
									'donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#' = get_total_stok.TOTAL_STOCK[tt];
									break;
								}
							}
							else if(get_total_stok.GROUPBY_ALANI[tt] eq GET_ALL_STOCK.PRODUCT_ID and get_total_stok.GROUPBY_ALANI_2[tt] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
							{
								'donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#' = get_total_stok.TOTAL_STOCK[tt];
								break;
							}
							else
							'donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#' = 0;
						}
						else
						{
							if(listfind('2,3,4,5,6',attributes.report_type) and isdefined("attributes.location_based_cost"))
							{
								if(get_total_stok.GROUPBY_ALANI[tt] eq GET_ALL_STOCK.PRODUCT_ID and get_total_stok.STORE[tt] eq GET_ALL_STOCK.DEPARTMENT_ID and get_total_stok.STORE_LOCATION[tt] eq GET_ALL_STOCK.LOCATION_ID) 
								{
									'donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#' = get_total_stok.TOTAL_STOCK[tt];
									break;
								}
							}
							else if(listfind('2,3,4,5,6',attributes.report_type) and isdefined("attributes.department_based_cost"))
							{
								if(get_total_stok.GROUPBY_ALANI[tt] eq GET_ALL_STOCK.PRODUCT_ID and get_total_stok.STORE[tt] eq GET_ALL_STOCK.DEPARTMENT_ID) 
								{
									'donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#' = get_total_stok.TOTAL_STOCK[tt];
									break;
								}
							}
							else if(get_total_stok.GROUPBY_ALANI[tt] eq GET_ALL_STOCK.PRODUCT_ID) 
							{
								'donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#' = get_total_stok.TOTAL_STOCK[tt];
								break;
							}
						}
					}
					if(isdefined("GET_ALL_STOCK.PRODUCT_ID") and isdefined('donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#') and len(evaluate('donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#')))
					{
						donem_sonu_maliyet3=0;
						'prod_cat_total_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#'=( evaluate('prod_cat_total_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#')+ evaluate('donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#') );
						if(isdefined('attributes.display_cost'))
						{
							donem_sonu_maliyet3=wrk_round(evaluate('donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#')*GET_ALL_STOCK.ALL_FINISH_COST);
							if(isdefined('attributes.is_system_money_2') and isdefined('donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#') and len(GET_ALL_STOCK.ALL_FINISH_COST_2))
								ds_other_cost=wrk_round(evaluate('donem_sonu_#GET_ALL_STOCK.PRODUCT_ID#')*GET_ALL_STOCK.ALL_FINISH_COST_2);
							else
								ds_other_cost= 0;
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
		<cfelseif not listfind('3,5,9',attributes.report_type) >
			<cfif isdefined('attributes.is_excel') and listfind('1,2',attributes.is_excel)>
				<cfset attributes.startrow=1>
			</cfif>
			<cfoutput query="GET_ALL_STOCK" startrow="#attributes.startrow#" maxrows="#GET_ALL_STOCK.recordcount#">
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
					if(not listfind('8,12',attributes.report_type))
					{
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
	
					if(len(attributes.process_type) and listfind(attributes.process_type,17) )
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
					if(len(attributes.process_type) and listfind(attributes.process_type,21))
					{
						//donem ici sevk irs miktar ve maliyetleri set ediliyor
						for(s4=1; s4 lte get_stok_virman_total_in.recordcount; s4=s4+1)
						{
							if( get_stok_virman_total_in.GROUPBY_ALANI[s4] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'stok_virman_giris_miktari_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_stok_virman_total_in.stok_virman_GIRIS_MIKTARI[s4];
								'stok_virman_giris_maliyeti_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_stok_virman_total_in.stok_virman_GIRIS_MALIYETI[s4];
								if(isdefined('attributes.is_system_money_2'))
									'stok_virman_giris_maliyeti2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_stok_virman_total_in.stok_virman_GIRIS_MALIYETI_2[s4];
								break;
							}
						}
						
						for(s5=1; s5 lte get_stok_virman_total_out.recordcount; s5=s5+1)
						{
							if( get_stok_virman_total_out.GROUPBY_ALANI[s5] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'stok_virman_cikis_miktari_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_stok_virman_total_out.stok_virman_CIKIS_MIKTARI[s5];
								'stok_virman_cikis_maliyeti_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_stok_virman_total_out.stok_virman_CIKIS_MALIYET[s5];
								if(isdefined('attributes.is_system_money_2'))
									'stok_virman_cikis_maliyeti2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_stok_virman_total_out.stok_virman_CIKIS_MALIYET_2[s5];
								break;
							}
						}
					}
					if(len(attributes.process_type) and listfind(attributes.process_type,22))
					{
						for(s4=1; s4 lte get_invent_stock_fis_all.recordcount; s4=s4+1)
						{
							if( get_invent_stock_fis_all.GROUPBY_ALANI[s4] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'invent_stock_fis_amount_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_invent_stock_fis_all.AMOUNT[s4];
								'invent_stock_fis_cost_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_invent_stock_fis_all.COST[s4];
								'invent_stock_fis_price_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_invent_stock_fis_all.PRICE[s4];
								if(isdefined('attributes.is_system_money_2'))
									'invent_stock_fis_cost2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_invent_stock_fis_all.COST_2[s4];
								break;
							}
						}
						
						for(s5=1; s5 lte get_invent_stock_fis_return_all.recordcount; s5=s5+1)
						{
							if( get_invent_stock_fis_return_all.GROUPBY_ALANI[s5] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID ) 
							{
								'invent_stock_fis_return_amount_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_invent_stock_fis_return_all.AMOUNT[s5];
								'invent_stock_fis_return_cost_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_invent_stock_fis_return_all.COST[s5];
								'invent_stock_fis_return_price_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_invent_stock_fis_return_all.PRICE[s5];
								if(isdefined('attributes.is_system_money_2'))
									'invent_stock_fis_return_cost2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = get_invent_stock_fis_return_all.COST_2[s5];
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
				if( (len(attributes.process_type) and listfind(attributes.process_type,3)) or isdefined('attributes.stock_rate'))
				{
					if(isdefined('attributes.from_invoice_actions'))/*faturadan hesapla secilmisse, satıs hareketleri fatura tutarlarından getiriliyor*/
					{
						for(inv_k=1; inv_k lte d_fatura_satis_tutar.recordcount; inv_k=inv_k+1)
						{
							if(d_fatura_satis_tutar.GROUPBY_ALANI[inv_k] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
							{
								'fatura_satis_tutar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_fatura_satis_tutar.FATURA_SATIS_TUTAR[inv_k];
								'fatura_satis_miktar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_fatura_satis_tutar.FATURA_SATIS_MIKTAR[inv_k];
								if(isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1)
								{
									'fatura_satis_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_fatura_satis_tutar.FATURA_SATIS_MALIYET[inv_k];
									if(isdefined('attributes.is_system_money_2'))
										'fatura_satis_maliyet_2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_fatura_satis_tutar.FATURA_SATIS_MALIYET_2[inv_k];
								}
								if(isdefined('attributes.is_system_money_2'))
								{
									'fatura_satis_tutar2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_fatura_satis_tutar.FATURA_SATIS_TUTAR_2[inv_k];
								}
								break;
							}
						}
						for(inv_t=1; inv_t lte d_fatura_satis_iade_tutar.recordcount; inv_t=inv_t+1)
						{
							if(d_fatura_satis_iade_tutar.GROUPBY_ALANI[inv_t] eq GET_ALL_STOCK.PRODUCT_GROUPBY_ID) 
							{
								'fatura_satis_iade_tutar_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_TUTAR[inv_t];
								if(isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1)
								{
									'fatura_satis_iade_maliyet_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_MALIYET[inv_t];
									if(isdefined('attributes.is_system_money_2'))
										'fatura_satis_iade_maliyet_2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_MALIYET_2[inv_t];
								}
								if(isdefined('attributes.is_system_money_2'))
								{
									'fatura_satis_iade_tutar2_#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#' = d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_TUTAR_2[inv_t];
								}
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