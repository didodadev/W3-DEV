<cfif isdate(attributes.date)>
	<cf_date tarih = 'attributes.date'>
	<cfset start_date =attributes.date>
</cfif>
<cfif isdate(attributes.date2)>
	<cf_date tarih = 'attributes.date2'>
	<cfset finish_date =attributes.date2>
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
    SELECT  DISTINCT
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
        S.BARCOD,
        S.PRODUCT_CODE,
        S.PRODUCT_CODE_2,
    <cfelseif attributes.report_type eq 8>
        S.STOCK_CODE,
        S.STOCK_ID,
        CAST(S.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(SR.SPECT_VAR_ID,0) AS NVARCHAR(50)) AS PRODUCT_GROUPBY_ID,
        SR.SPECT_VAR_ID SPECT_VAR_ID,
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
        P.ALL_START_COST,
        ISNULL(P.ALL_START_COST_2,0) ALL_START_COST_2,
        ISNULL(P1.ALL_FINISH_COST,0) AS ALL_FINISH_COST,
        P1.ALL_FINISH_COST_2
    INTO  ####GET_ALL_STOCK_#session.ep.userid#
    FROM        
    STOCKS_ROW  SR WITH (NOLOCK) INNER JOIN
    <cfif attributes.report_type eq 1 or attributes.report_type eq 8>
        #dsn3_alias#.STOCKS S WITH (NOLOCK) ON (SR.STOCK_ID=S.STOCK_ID)
    <cfelse>
        #dsn3_alias#.PRODUCT S WITH (NOLOCK) ON (SR.PRODUCT_ID=S.PRODUCT_ID)
    </cfif>
    <cfif get_cost_type.inventory_calc_type eq 3><!--- Ağırlıklı ortalama ise --->
        OUTER APPLY
        (
            SELECT TOP 1
				<cfif isdefined("attributes.display_cost_money")>
                    (PURCHASE_NET_ALL+PURCHASE_EXTRA_COST) AS ALL_START_COST
                <cfelse>
                    (PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM) AS ALL_START_COST
                </cfif>
	                ,ISNULL((PURCHASE_NET_ALL+PURCHASE_EXTRA_COST),0) AS ALL_START_COST_2	
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
                PROCESS_DATE_OUT <= #start_date# 
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
                
				<cfif isdefined("attributes.display_cost_money")>
                    (PURCHASE_NET_ALL+PURCHASE_EXTRA_COST) AS ALL_FINISH_COST
                <cfelse>
                    (PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM) AS ALL_FINISH_COST
                </cfif>	
                	,(PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2) AS ALL_FINISH_COST_2
            FROM 
                #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
            WHERE 
                START_DATE <= #finish_date# 
                AND PRODUCT_ID = S.PRODUCT_ID
                <cfif attributes.report_type eq 8>
                     AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
                </cfif>
                <cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                    AND PRODUCT_COST.STOCK_ID = SR.STOCK_ID 
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
    WHERE
		S.PRODUCT_ID=PU.PRODUCT_ID
		<cfif attributes.report_type eq 1 or attributes.report_type eq 8>
            AND S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID
        <cfelse>
            AND PU.IS_MAIN = 1
        </cfif>
        <cfif isdefined('attributes.is_envantory')>
            AND S.IS_INVENTORY=1
        </cfif>
    ORDER BY 
		<cfif attributes.report_type eq 1>
            STOCK_CODE
        <cfelse>
            ACIKLAMA
        </cfif>
</cfquery>
        
<!---GET_STOCK_FIS--->
<cfif len(attributes.process_type) and (listfind(attributes.process_type,4) or listfind(attributes.process_type,5) or listfind(attributes.process_type,12) or listfind(attributes.process_type,14) or listfind(attributes.process_type,18))>
    <cfquery name="CHECK_TABLE" datasource="#DSN2#">
        IF EXISTS (SELECT * FROM tempdb.SYS.TABLES WHERE name = '####GET_STOCK_FIS')
        drop table ####GET_STOCK_FIS
    </cfquery>
    <cfquery name="GET_STOCK_FIS" datasource="#dsn2#">
        SELECT
            GC.PRODUCT_ID,
            GC.STOCK_ID,
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
        INTO ####GET_STOCK_FIS
        FROM 
            STOCK_FIS SF WITH (NOLOCK),
            STOCK_FIS_ROW SFR WITH (NOLOCK),
            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
            STOCK_FIS_MONEY SF_M,
            </cfif>
            <cfif attributes.report_type eq 8>
                GET_STOCKS_ROW_COST_SPECT AS GC
            <cfelse>
                GET_STOCKS_ROW_COST AS GC
            </cfif>
        WHERE 
            GC.UPD_ID = SF.FIS_ID AND
            SFR.FIS_ID=	SF.FIS_ID AND
            GC.PROCESS_TYPE = SF.FIS_TYPE AND
            GC.STOCK_ID=SFR.STOCK_ID AND
            SF.FIS_TYPE  IN (110,111,112,113,115,119) AND 
            SF.FIS_DATE >= #attributes.date# AND
            <cfif attributes.report_type eq 8>
            ISNULL((SELECT TOP 1 SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SFR.SPECT_VAR_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
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
    </cfquery>
</cfif>



<!--- GET_STOCK_VIRMAN_OUT---><!---GET_STOCK_VIRMAN_IN--->
<cfif len(attributes.process_type) and listfind(attributes.process_type,21)>
	<cfquery name="CHECK_TABLE" datasource="#DSN2#">
        IF EXISTS (SELECT * FROM tempdb.SYS.TABLES WHERE name = '####GET_STOCK_VIRMAN_IN')
        drop table ####GET_STOCK_VIRMAN_IN
    </cfquery>
    <cfquery name="CHECK_TABLE" datasource="#DSN2#">
        IF EXISTS (SELECT * FROM tempdb.SYS.TABLES WHERE name = '####GET_STOCK_VIRMAN_OUT')
        drop table ####GET_STOCK_VIRMAN_OUT
    </cfquery>
    <cfquery name="GET_STOCK_VIRMAN_IN" datasource="#dsn2#" >
        SELECT
            GC.PRODUCT_ID,
            GC.STOCK_ID,
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
            SF.PROCESS_DATE ISLEM_TARIHI,
            SF.PROCESS_CAT,
            SF.PROCESS_TYPE,
            0 AS PROD_ORDER_NUMBER,
            0 AS PROD_ORDER_RESULT_NUMBER
        INTO ####GET_STOCK_VIRMAN_IN
        FROM 
            STOCK_EXCHANGE SF WITH (NOLOCK),
			<cfif attributes.report_type eq 8>
                GET_STOCKS_ROW_COST_SPECT AS GC
            <cfelse>
                GET_STOCKS_ROW_COST AS GC
            </cfif>
        WHERE 
            GC.UPD_ID = SF.STOCK_EXCHANGE_ID AND
            GC.PROCESS_TYPE = SF.PROCESS_TYPE AND
            GC.STOCK_ID=SF.STOCK_ID AND
            SF.PROCESS_DATE >= #attributes.date# AND
            <cfif attributes.report_type eq 8>
            ISNULL((SELECT TOP 1 SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SF.SPECT_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
            </cfif>
            SF.PROCESS_DATE <= #attributes.date2#
    </cfquery>
    <cfquery name="GET_STOCK_VIRMAN_OUT" datasource="#dsn2#" >
        SELECT
            GC.PRODUCT_ID,
            GC.STOCK_ID,
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
        INTO ####GET_STOCK_VIRMAN_OUT
        FROM 
			STOCK_EXCHANGE SF WITH (NOLOCK),
			<cfif attributes.report_type eq 8>
                GET_STOCKS_ROW_COST_SPECT AS GC
            <cfelse>
                GET_STOCKS_ROW_COST AS GC
            </cfif>
        WHERE 
            GC.UPD_ID = SF.STOCK_EXCHANGE_ID AND
            GC.PROCESS_TYPE = SF.PROCESS_TYPE AND
            GC.STOCK_ID=SF.EXIT_STOCK_ID AND
            SF.PROCESS_DATE >= #attributes.date# AND
            <cfif attributes.report_type eq 8>
            ISNULL((SELECT TOP 1 SM.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SM WHERE SM.SPECT_VAR_ID = SF.EXIT_SPECT_ID),0) = ISNULL(GC.SPECT_VAR_ID,0) AND
            </cfif>
            SF.PROCESS_DATE <= #attributes.date2#
    </cfquery>
</cfif>
<!---GET_INVENT_STOCK_FIS---><!---GET_INVENT_STOCK_FIS_RETURN--->
<cfif len(attributes.process_type) and listfind(attributes.process_type,22)>
    <cfquery name="CHECK_TABLE" datasource="#DSN2#">
        IF EXISTS (SELECT * FROM tempdb.SYS.TABLES WHERE name = '####GET_INVENT_STOCK_FIS')
        drop table ####GET_INVENT_STOCK_FIS
    </cfquery>
    <cfquery name="CHECK_TABLE" datasource="#DSN2#">
        IF EXISTS (SELECT * FROM tempdb.SYS.TABLES WHERE name = '####GET_INVENT_STOCK_FIS_RETURN')
        drop table ####GET_INVENT_STOCK_FIS_RETURN
    </cfquery>
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
            SF.FIS_DATE ISLEM_TARIHI,
            SF.PROCESS_CAT,
            SF.FIS_TYPE PROCESS_TYPE,
            0 AS PROD_ORDER_NUMBER,
            0 AS PROD_ORDER_RESULT_NUMBER
        INTO ####GET_INVENT_STOCK_FIS
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
            AND SF.FIS_DATE <= #attributes.date2#
            <cfif not (isdefined("attributes.is_stock_fis_control") and attributes.is_stock_fis_control eq 1)>
                AND SR.UPD_ID = SF.FIS_ID
                AND SR.PROCESS_TYPE = SF.FIS_TYPE
            </cfif>
            <cfif isdefined("attributes.is_stock_fis_control") and attributes.is_stock_fis_control eq 1>
                AND SF.RELATED_SHIP_ID IS NOT NULL
            </cfif>
            AND S.STOCK_ID = SFR.STOCK_ID 
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
            SF.FIS_DATE ISLEM_TARIHI,
            SF.PROCESS_CAT,
            SF.FIS_TYPE PROCESS_TYPE,
            0 AS PROD_ORDER_NUMBER,
            0 AS PROD_ORDER_RESULT_NUMBER
        INTO ####GET_INVENT_STOCK_FIS_RETURN
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
            AND SF.FIS_DATE <= #attributes.date2#
            AND SF.FIS_DATE >= #attributes.date#
            <cfif not (isdefined("attributes.is_stock_fis_control") and attributes.is_stock_fis_control eq 1)>
                AND SR.UPD_ID = SF.FIS_ID
                AND SR.PROCESS_TYPE = SF.FIS_TYPE
            </cfif>
            <cfif isdefined("attributes.is_stock_fis_control") and attributes.is_stock_fis_control eq 1>
                AND SF.RELATED_SHIP_ID IS NOT NULL
            </cfif>
            AND S.STOCK_ID = SFR.STOCK_ID 
    </cfquery>
</cfif>
<!---GET_EXPENSE--->

<cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
    <cfquery name="CHECK_TABLE" datasource="#DSN2#">
        IF EXISTS (SELECT * FROM tempdb.SYS.TABLES WHERE name = '####GET_EXPENSE')
        drop table ####GET_EXPENSE
    </cfquery>
    <cfquery name="GET_EXPENSE" datasource="#dsn2#" >
        SELECT
            GC.PRODUCT_ID,
            GC.STOCK_ID,
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
        INTO ####GET_EXPENSE
        FROM 
            EXPENSE_ITEM_PLANS EIP,
            EXPENSE_ITEMS_ROWS EIR,
            EXPENSE_ITEM_PLANS_MONEY EIRM,
			<cfif attributes.report_type eq 8>
                GET_STOCKS_ROW_COST_SPECT AS GC
            <cfelse>
                GET_STOCKS_ROW_COST AS GC
            </cfif>
        WHERE 
            GC.UPD_ID = EIP.EXPENSE_ID AND
            EIR.EXPENSE_ID=	EIP.EXPENSE_ID AND
            EIP.EXPENSE_ID = EIRM.ACTION_ID AND
            GC.PROCESS_TYPE = EIP.ACTION_TYPE AND
            GC.STOCK_ID=EIR.STOCK_ID_2 AND 
            EIP.ACTION_TYPE=122 AND
            EIP.EXPENSE_DATE >= #attributes.date# AND 
            EIP.EXPENSE_DATE <= #attributes.date2# AND
            <cfif isdefined('attributes.is_system_money_2')>
                EIRM.MONEY_TYPE = '#session.ep.money2#'
            <cfelse>
                EIRM.MONEY_TYPE = '#attributes.cost_money#'
            </cfif>
    </cfquery>
</cfif>

<!---GET_dEMONTAJ--->

<cfif len(attributes.process_type) and (listfind(attributes.process_type,14) or listfind(attributes.process_type,13))>
    <cfquery name="CHECK_TABLE" datasource="#DSN2#">
	IF EXISTS (SELECT * FROM tempdb.SYS.TABLES WHERE name = '####GET_DEMONTAJ')
    drop table ####GET_DEMONTAJ
	</cfquery>
    <cfquery name="GET_DEMONTAJ" datasource="#dsn2#">
        SELECT
            GC.PRODUCT_ID,
            GC.STOCK_ID,
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
        INTO ####GET_DEMONTAJ
        FROM 
            STOCK_FIS SF,
            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
            STOCK_FIS_MONEY SF_M,
            </cfif>
			<cfif attributes.report_type eq 8>
                GET_STOCKS_ROW_COST_SPECT AS GC,
            <cfelse>
                GET_STOCKS_ROW_COST AS GC,
            </cfif>
            #dsn3_alias#.PRODUCTION_ORDERS PO
                  WHERE 
            GC.UPD_ID = SF.FIS_ID AND
            GC.PROCESS_TYPE = SF.FIS_TYPE AND
            SF.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND
            SF.PROD_ORDER_NUMBER IS NOT NULL AND
            PO.IS_DEMONTAJ = 1 AND 
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
    </cfquery>
</cfif>
<!---GET_INV_PRUCHASE--->
<cfif (len(attributes.process_type) and listfind(attributes.process_type,2)) or listfind(attributes.process_type,3)>
    <cfquery name="CHECK_TABLE" datasource="#DSN2#">
        IF EXISTS (SELECT * FROM tempdb.SYS.TABLES WHERE name = '####GET_INV_PURCHASE')
        drop table ####GET_INV_PURCHASE
    </cfquery>
    <cfquery name="GET_INV_PURCHASE" datasource="#dsn2#">
        SELECT 
            IR.STOCK_ID,
            IR.PRODUCT_ID,
            <cfif attributes.report_type eq 8>
            CAST(IR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS NVARCHAR(50))  STOCK_SPEC_ID,
            </cfif>
            IR.AMOUNT,
            I.INVOICE_DATE ISLEM_TARIHI,
            I.INVOICE_CAT PROCESS_TYPE,
            ISNULL(I.IS_RETURN,0) IS_RETURN,
            <cfif isdefined('attributes.from_invoice_actions')><!--- satış faturası satırlarındaki maliyet alınıyor --->
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
        INTO ####GET_INV_PURCHASE
        FROM 
            INVOICE I WITH (NOLOCK),
            INVOICE_ROW IR WITH (NOLOCK)
            <cfif isdefined('attributes.is_system_money_2') or attributes.cost_money is not session.ep.money>
            ,INVOICE_MONEY IM
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
    </cfquery>
</cfif>
<!---GET_SHIP_ROWS--->
<cfif len(attributes.process_type)>
    <cfquery name="CHECK_TABLE" datasource="#DSN2#">
        IF EXISTS (SELECT * FROM tempdb.SYS.TABLES WHERE name = '####GET_SHIP_ROWS')
        drop table ####GET_SHIP_ROWS
    </cfquery>
    <cfquery name="GET_SHIP_ROWS" datasource="#dsn2#">
    SELECT *
    INTO ####GET_SHIP_ROWS
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
                    <cfif isdefined("attributes.display_cost_money")>
                        (PURCHASE_NET_ALL+PURCHASE_EXTRA_COST)
                    <cfelse>
                        (PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
                    </cfif>	
                FROM 
                    #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                WHERE 
                    START_DATE <= #finish_date# 
                    AND PRODUCT_ID = GC.PRODUCT_ID
                    <cfif attributes.report_type eq 8>
                         AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                    </cfif>
                    <cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                        AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                    </cfif>
                ORDER BY 
                    START_DATE DESC, 
                    RECORD_DATE DESC,
                    PRODUCT_COST_ID DESC
            ),0) ALL_FINISH_COST,
            ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                SELECT TOP 1 
                        (PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2)
                FROM 
                    #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                WHERE 
                    START_DATE <= #finish_date# 
                    AND PRODUCT_ID = GC.PRODUCT_ID
                    <cfif attributes.report_type eq 8>
                         AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                    </cfif>
                    <cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                        AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                    </cfif>
                ORDER BY 
                    START_DATE DESC, 
                    RECORD_DATE DESC,
                    PRODUCT_COST_ID DESC
            ),0) ALL_FINISH_COST_2
        FROM
            
            <cfif attributes.report_type eq 8>
                GET_STOCKS_ROW_COST_SPECT AS GC,
            <cfelse>
                GET_STOCKS_ROW_COST AS GC,
            </cfif>
            <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2') or listfind(attributes.process_type,3) or isdefined('attributes.stock_rate')>
            SHIP WITH (NOLOCK),	
            </cfif>
            <cfif attributes.cost_money is not session.ep.money or isdefined('attributes.is_system_money_2')>
            SHIP_MONEY SM,
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
            AND GC.PROCESS_DATE <= #attributes.date2#
    <cfif attributes.cost_money is not session.ep.money or listfind(attributes.process_type,3) or isdefined('attributes.stock_rate')>
    UNION ALL
        SELECT
            GC.STOCK_ID,
            GC.PRODUCT_ID,
            <cfif attributes.report_type eq 8>
            CAST(GC.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL(GC.SPECT_VAR_ID,0) AS NVARCHAR(50)) STOCK_SPEC_ID,
            </cfif>
            INVOICE.INVOICE_CAT,
            ISNULL(INVOICE.IS_RETURN,0) IS_RETURN,
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
                    
                        <cfif isdefined("attributes.display_cost_money")>
                            (PURCHASE_NET_ALL+PURCHASE_EXTRA_COST)
                        <cfelse>
                            (PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
                        </cfif>	
                FROM 
                    #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                WHERE 
                    START_DATE <= #finish_date# 
                    AND PRODUCT_ID = GC.PRODUCT_ID
                    <cfif attributes.report_type eq 8>
                         AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                    </cfif>
                    <cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                        AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
                    </cfif>
                ORDER BY 
                    START_DATE DESC, 
                    RECORD_DATE DESC,
                    PRODUCT_COST_ID DESC
            ),0) ALL_FINISH_COST,
            ISNULL(ABS(GC.STOCK_IN-GC.STOCK_OUT)*(
                SELECT TOP 1 
                    
                        (PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2)
                FROM 
                    #dsn3_alias#.PRODUCT_COST WITH (NOLOCK) 
                WHERE 
                    START_DATE <= #finish_date# 
                    AND PRODUCT_ID = GC.PRODUCT_ID
                    <cfif attributes.report_type eq 8>
                         AND ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL(GC.SPECT_VAR_ID,0)
                    </cfif>
                    <cfif session.ep.our_company_info.is_stock_based_cost eq 1 and attributes.report_type neq 2>
                        AND PRODUCT_COST.STOCK_ID = GC.STOCK_ID 
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
            
            <cfif attributes.report_type eq 8>
                GET_STOCKS_ROW_COST_SPECT AS GC,
            <cfelse>
                GET_STOCKS_ROW_COST AS GC,
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
    </cfif>
     ) AS XXX
    </cfquery>
</cfif>    

<!---GET_STOCK_ROWS--->
<cfquery name="CHECK_TABLE" datasource="#DSN2#">
	IF EXISTS (SELECT * FROM tempdb.SYS.TABLES WHERE name = '####GET_STOCK_ROWS')
    drop table ####GET_STOCK_ROWS
</cfquery>
<cfquery name="GET_STOCK_ROWS" datasource="#dsn2#">
    SELECT 
        SR.UPD_ID,
        S.STOCK_ID,
        S.PRODUCT_ID,
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
    INTO ####GET_STOCK_ROWS
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
    GROUP BY
        SR.UPD_ID,
        S.STOCK_ID,
        S.PRODUCT_ID,
        SR.SPECT_VAR_ID,
        S.PRODUCT_MANAGER,
        S.PRODUCT_CATID,
        S.BRAND_ID,
        SR.PROCESS_DATE,
        SR.PROCESS_TYPE
</cfquery>



<cfif isdefined('attributes.stock_age')> <!--- Stok Yaşı Seçili ise --->
    <cfquery name="GET_STOCK_AGE" datasource="#dsn2#" >
        SELECT * FROM
        (
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
            I.SHIP_ID SHIP_ID,
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
            I.SHIP_TYPE IN(76,87) AND
            I.IS_SHIP_IPTAL = 0 AND
            <!--- I.SHIP_DATE >= #attributes.date# AND  --->
            I.SHIP_DATE <= #attributes.date2#
    UNION ALL
        SELECT 
            IR.STOCK_ID,
            S.PRODUCT_ID,
            <cfif attributes.report_type eq 8>
                CAST(IR.STOCK_ID AS NVARCHAR(50)) +'_'+ CAST(ISNULL((SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS NVARCHAR(50))  STOCK_SPEC_ID,
            </cfif>
            IR.AMOUNT,
            I.FIS_DATE ISLEM_TARIHI,
            <!--- ISNULL(DATEDIFF(day,DATEADD(day,-1*DUE_DATE,FIS_DATE),#attributes.date2#),DATEDIFF(day,FIS_DATE,#attributes.date2#)) AS GUN_FARKI, --->
            DATEDIFF(day,FIS_DATE,#attributes.date2#) + ISNULL(DUE_DATE,0) GUN_FARKI,
            I.DEPARTMENT_IN,
            I.LOCATION_IN,
            I.FIS_ID SHIP_ID,
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
            I.FIS_TYPE IN (110,114,115,119) AND
            I.FIS_DATE <= #attributes.date2#
        ) T1
        ORDER BY
            ISLEM_TARIHI DESC,
            SHIP_ID DESC
    </cfquery>
    <cfquery name="crate_stock_age_table" datasource="#dsn#">
        IF EXISTS (SELECT * FROM tempdb.sys.tables where name ='####stock_age_table')
        BEGIN
        DROP TABLE  ####stock_age_table
        END
        CREATE TABLE ####stock_age_table ( #ALAN_ADI# INT,AG_TOPLAM FLOAT )
    </cfquery>
    <cfquery name="GET_ALL_STOCK" datasource="#dsn2#">
    	SELECT * 
        FROM 
        	####GET_ALL_STOCK_#session.ep.userid# GS
        LEFT JOIN <!---get_total_stok--->
        (
            SELECT 
                SUM(AMOUNT) AS TOTAL_STOCK,
                SUM(AMOUNT*MALIYET) AS TOTAL_PRODUCT_COST,
                <cfif isdefined('attributes.is_system_money_2')>
                SUM(AMOUNT*MALIYET_2) AS TOTAL_PRODUCT_COST_2,
                </cfif>
                #ALAN_ADI# AS GROUPBY_ALANI
            FROM
                ####GET_STOCK_ROWS
            WHERE
                ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                AND PROCESS_TYPE NOT IN (81,811)
            GROUP BY
               #ALAN_ADI#
        ) as get_total_stok
        ON GS.PRODUCT_GROUPBY_ID = get_total_stok.GROUPBY_ALANI
    </cfquery>
    <cfoutput query="GET_ALL_STOCK">
    <cfif isdefined('attributes.stock_age')>
        <cfset agirlikli_toplam=0>
        <cfif GET_ALL_STOCK.TOTAL_STOCK gt 0>
            <cfset kalan=GET_ALL_STOCK.TOTAL_STOCK>
            <cfquery name="get_product_detail" dbtype="query">
                SELECT 
                    AMOUNT AS PURCHASE_AMOUNT,
                    GUN_FARKI 
                FROM 
                    GET_STOCK_AGE 
                WHERE 
                    #ALAN_ADI# =<cfif attributes.report_type eq 8>'#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#'<cfelse>#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#</cfif>
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
            <cfset agırlıklı_toplam=agırlıklı_toplam/GET_ALL_STOCK.TOTAL_STOCK>
            <CFQUERY name="INS_STOCK_AGE_TABLE" datasource="#dsn#">
                INSERT INTO ####stock_age_table  ( #ALAN_ADI#  ,AG_TOPLAM  )  VALUES  (<cfif attributes.report_type eq 8>'#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#'<cfelse>#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#</cfif> ,#agırlıklı_toplam#)
            </CFQUERY>
        </cfif>
    </cfif>
    </cfoutput>
</cfif>

<cfquery name="GET_QUERY" datasource="#DSN2#">
       SELECT
		<cfif attributes.report_type eq 1><!---Stok Bazında--->
            GS.STOCK_CODE AS "Stok Kodu",<!--- Stok Kodu --->
            GS.STOCK_CODE_2 AS "Özel Kod" ,<!--- Özel Kod --->
        <cfelseif attributes.report_type eq 2><!--- Ürün Bazında--->
            GS.PRODUCT_CODE_2 AS "Özel Kod",<!---Özel Kod--->
        </cfif>
        <cfif attributes.report_type eq 1>    
            GS.ACIKLAMA as "Stok",<!---Stok--->
        <cfelseif attributes.report_type eq 2>
        	GS.ACIKLAMA as "Ürün",<!---Ürün--->
		</cfif>     
            BARCOD as "Barkod",<!---Barkod--->
            PRODUCT_CODE as "Ürün Kodu",<!---Ürün Kodu--->
            MANUFACT_CODE as "Üretici Kodu",<!---Üretici Kodu--->
            MAIN_UNIT as "Birim",<!---Birim--->
            ISNULL(acilis_stok2.DB_STOK_MIKTAR,0) AS "Dönem Başı Stok Miktarı" ,<!---Dönem Başı Stok Miktarı --->
            ISNULL((ALL_START_COST*DB_STOK_MIKTAR),0) AS "Dönem Başı Stok Maliyeti"<!---Dönem Başı Stok Maliyeti --->
        <cfif len(attributes.process_type) and listfind(attributes.process_type,2)><!---Alış Ve Alış İadeler--->
            ,ISNULL(d_alis_miktar.TOPLAM_ALIS,0) as  "Alım Miktarı" <!---Alım Miktarı--->
            ,ISNULL(d_alis_iade_miktar.TOPLAM_ALIS_IADE,0) as  "Alım İade Miktarı"<!---Alım İade Miktarı--->
            ,ISNULL((ISNULL(d_alis_miktar.TOPLAM_ALIS,0) -  ISNULL(d_alis_iade_miktar.TOPLAM_ALIS_IADE,0)),0)AS "Net Alım Miktarı"<!---Net Alım Miktarı--->
            ,ISNULL(d_alis_tutar.TOPLAM_ALIS_MALIYET,0) as "Alım Tutar" <!---Alım Tutar--->
            ,ISNULL(d_alis_iade_tutar.TOPLAM_ALIS_IADE_MALIYET,0) as  "Alım İade Tutarı"<!---Alım İade Tutarı--->
            ,ISNULL((ISNULL(d_alis_tutar.TOPLAM_ALIS_MALIYET,0) - ISNULL(d_alis_iade_tutar.TOPLAM_ALIS_IADE_MALIYET,0)),0) AS "Net Alım Tutarı" <!---Net Alım Tutarı--->
       	</cfif>
        <cfif (len(attributes.process_type) and listfind(attributes.process_type,3))><!---Satış Ve Satış İadeler--->
            ,ISNULL(d_satis.TOPLAM_SATIS,0) as  "Satış Miktar"<!---Satış Miktar--->
            ,ISNULL(d_satis.TOPLAM_SATIS_MALIYET,0) as "Satış Maliyeti"<!---Satış Maliyeti--->
            ,ISNULL(d_satis_iade.TOPLAM_SATIS_IADE,0) as "Satış İade Miktar"<!---Satış İade Miktar--->
            ,ISNULL(d_satis_iade.TOP_SAT_IADE_MALIYET,0) as "Satış İade Maliyeti"<!---Satış İade Maliyeti--->
            ,ISNULL((ISNULL(d_satis.TOPLAM_SATIS,0) - ISNULL(d_satis_iade.TOPLAM_SATIS_IADE,0)),0) AS "Net Satış Miktar"<!---Net Satış Miktar--->            
            ,ISNULL((ISNULL(d_satis.TOPLAM_SATIS_MALIYET,0)-ISNULL(d_satis_iade.TOP_SAT_IADE_MALIYET,0)),0) AS "Net Satış Maliyeti"<!---Net Satış Maliyeti--->
            <cfif isdefined('attributes.from_invoice_actions')><!---Satış Faturası Miktarı-Tutarı --->
            	,ISNULL(d_fatura_satis_tutar.FATURA_SATIS_MIKTAR,0)  as "Fatura Satış Miktar"<!---Fatura Satış Miktar--->
                ,ISNULL(d_fatura_satis_tutar.FATURA_SATIS_TUTAR,0) AS  "Fatura Satış Tutar" <!---Fatura Satış Tutar--->
                ,ISNULL(d_fatura_satis_tutar.FATURA_SATIS_MALIYET,0) AS "-Fatura Satış Maliyet"<!---Fatura Satış Maliyet--->
                ,ISNULL(d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_MIKTAR,0) AS "Fatura Satış İade Miktar"<!---Fatura Satış İade Miktar--->
                ,ISNULL(d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_TUTAR,0) AS "Fatura Satış İade Tutar"<!---Fatura Satış İade Tutar--->
                ,ISNULL(d_fatura_satis_iade_tutar.FATURA_SATIS_IADE_TUTAR,0) AS "Fatura Satış İade Maliyet"<!---Fatura Satış İade Maliyet--->
            </cfif>
        </cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,4)><!---Üretim --->
			,ISNULL(donemici_uretim.TOPLAM_URETIM,0) AS "Üretim Miktar" <!---Üretim Miktar--->
            ,ISNULL(donemici_uretim.URETIM_MALIYET,0) AS "Üretim Maliyet" <!---Üretim Maliyet--->
        </cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,5)><!---Sarf ve Fireler--->
            ,ISNULL(donemici_sarf.TOPLAM_SARF,0) AS "Sarf Miktar"<!---Sarf Miktar--->
            ,ISNULL(donemici_sarf.SARF_MALIYET,0) AS "Sarf Maliyet"<!---Sarf Maliyet--->
            ,ISNULL(donemici_production_sarf.TOPLAM_URETIM_SARF,0) AS "Üretim Sarf Miktar"<!---Üretim Sarf Miktar--->
            ,ISNULL(donemici_production_sarf.URETIM_SARF_MALIYET,0) AS "Üretim Sarf Maliyet"<!---Üretim Sarf Maliyet--->
            ,ISNULL(donemici_fire.TOPLAM_FIRE,0) AS "Fire Miktar"<!---Fire Miktar--->
            ,ISNULL(donemici_fire.FIRE_MALIYET,0) AS "Fire Maliyet"<!---Fire Maliyet--->
        </cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,6)><!---Dönem içi Giden Konsinye--->
			,ISNULL(konsinye_cikis.KONS_CIKIS_MIKTAR,0) AS "Konsinye Çıkış Miktar"<!---Konsinye Çıkış Miktar--->
            ,ISNULL(konsinye_cikis.KONS_CIKIS_MALIYET,0) AS "Konsinye Çıkış Maliyet"<!---Konsinye Çıkış Maliyet--->
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,7)><!---Dönem İçi İade Gelen Konsinye--->
            ,ISNULL(konsinye_iade.KONS_IADE_MIKTAR,0) AS "Konsinye İade Miktar" <!---Konsinye İade Miktar--->
            ,ISNULL(konsinye_iade.KONS_IADE_MALIYET,0) AS "Konsinye İade Maliyet"<!---Konsinye İade Maliyet--->
		</cfif> 
        <cfif len(attributes.process_type) and listfind(attributes.process_type,19)><!---Dönem İçi Konsinye Giriş--->
            ,ISNULL(konsinye_giris.KONS_GIRIS_MIKTAR,0) AS "Konsinye Giriş Miktar"<!---Konsinye Giriş Miktar--->
            ,ISNULL(konsinye_giris.KONS_GIRIS_MALIYET,0) AS "Konsinye Giriş Maliyet"<!---Konsinye Giriş Maliyet--->
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,20)><!---Dönem İçi Konsinye Giriş İade--->
            ,ISNULL(konsinye_giris_iade.KONS_GIRIS_IADE_MIKTAR,0) AS "Konsinye Giriş İade Miktar"<!---Konsinye Giriş İade Miktar--->
            ,ISNULL(konsinye_giris_iade.KONS_GIRIS_IADE_MALIYET,0) AS "Konsinye Giriş İade Maliyet"<!---Konsinye Giriş İade Maliyet--->
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,8)><!---Teknik Servisten Giren--->
            ,ISNULL(servis_giris.SERVIS_GIRIS_MIKTAR,0) AS "Teknik Servisten Giren Miktar "<!---Miktar--->
            ,ISNULL(servis_giris.SERVIS_GIRIS_MALIYET,0) AS "Teknik Servisten Giren Maliyet"<!---Maliyet--->
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,9)> <!---Teknik Servisten Çıkan--->
            ,ISNULL(servis_cikis.SERVIS_CIKIS_MIKTAR,0) AS "Teknik Servisten Çıkan Miktar "<!---Miktar--->
            ,ISNULL(servis_cikis.SERVIS_CIKIS_MALIYET,0) AS "Teknik Servisten Çıkan Maliyet"<!---Maliyet--->
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,10)><!---RMA Çıkış--->
			,ISNULL(rma_cikis.RMA_CIKIS_MIKTAR,0) AS "RMA Çıkış Miktar"<!---Miktar--->
            ,ISNULL(rma_cikis.RMA_CIKIS_MALIYET,0) AS "RMA Çıkış Maliyet"<!---Maliyet--->
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,11)><!---RMA Giriş--->
			,ISNULL(rma_giris.RMA_GIRIS_MIKTAR,0) AS "RMA Giriş Miktar" <!---Miktar--->
            ,ISNULL(rma_giris.RMA_GIRIS_MALIYET,0) AS "RMA Giriş Maliyet"<!---Maliyet--->
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,12)><!---Sayım--->
			,ISNULL(donemici_sayim.TOPLAM_SAYIM,0) AS "Sayım Miktar"
            ,ISNULL(donemici_sayim.SAYIM_MALIYET,0) AS "Sayım Maliyet"
        </cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,13)><!---Dönem İçi Demontaja Giden--->
            ,ISNULL(demontaj_giden.DEMONTAJ_GIDEN,0) AS "Dönem İçi Demontaja Giden Miktar"<!---Miktar--->
            ,ISNULL(demontaj_giden.DEMONTAJ_GIDEN_MALIYET,0) AS "Dönem İçi Demontaja Giden Maliyet"<!---Maliyet--->
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,14)><!---Dönem İçi Demontajdan Giriş--->
			,ISNULL(donemici_demontaj_giris.DEMONTAJ_GIRIS,0) AS "Dönem İçi Demontajdan Giriş Miktar"<!---Miktar--->
            ,ISNULL(donemici_demontaj_giris.DEMONTAJ_GIRIS_MALIYET,0) AS "Dönem İçi Demontajdan Giriş Maliyet"<!---Maliyet--->
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,15)><!---donemici_masraf--->
			,ISNULL(donemici_masraf.TOPLAM_MASRAF_MIKTAR,0) AS "Donemici masraf Miktar"<!---Miktar--->
            ,ISNULL(donemici_masraf.MASRAF_MALIYET,0) AS "Donemici masraf Maliyet"<!---Maliyet--->
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,21)><!---Stok Virman--->
			,ISNULL(get_stok_virman_total_in.STOK_VIRMAN_GIRIS_MIKTARI,0) AS "Stok Virman Stok Giriş Miktar"<!---Stok Giriş Miktar--->
            ,ISNULL(get_stok_virman_total_in.STOK_VIRMAN_GIRIS_MALIYETI,0) AS "Stok Virman Stok Giriş Maliyeti"<!---Stok Giriş Maliyeti--->
            ,ISNULL(get_stok_virman_total_out.STOK_VIRMAN_CIKIS_MIKTARI,0) AS "Stok Virman Stok Çıkış Miktar"<!---Stok Çıkış Miktar--->
            ,ISNULL(get_stok_virman_total_out.STOK_VIRMAN_CIKIS_MALIYET,0) AS "Stok Virman Stok Çıkış Maliyeti"<!---Stok Çıkış Maliyeti--->
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,22)>
            ,ISNULL(get_invent_stock_fis_all.AMOUNT,0) AS "Demirbaş Stok Fişi Miktar"<!---Demirbaş Stok Fişi Miktar--->
            ,ISNULL(get_invent_stock_fis_all.COST,0) AS "Demirbaş Stok Fişi Kayıtlı Maliyet"<!---Demirbaş Stok Fişi Kayıtlı Maliyet--->
            ,ISNULL(get_invent_stock_fis_all.PRICE,0) AS "Demirbaş Stok Fişi Fiyat"<!---Demirbaş Stok Fişi Fiyat--->
            ,ISNULL(get_invent_stock_fis_return_all.AMOUNT,0) AS "Demirbaş Stok İade Fişi Miktar"<!---Demirbaş Stok İade Fişi Miktar--->
            ,ISNULL(get_invent_stock_fis_return_all.COST,0) AS "Demirbaş Stok İade Fişi Kayıtlı Maliyet"<!---Demirbaş Stok İade Fişi Kayıtlı Maliyet--->
            ,ISNULL(get_invent_stock_fis_return_all.PRICE,0) AS "Demirbaş Stok İade Fişi Fiyat"<!---Demirbaş Stok İade Fişi Fiyat--->
		</cfif>   
 		,ISNULL(get_total_stok.TOTAL_STOCK,0) as "Döenem Sonu Stok Miktar"
		,ISNULL((get_total_stok.TOTAL_STOCK*ALL_FINISH_COST),0) as "Dönem Sonu Stok Maliyet"
        <cfif isdefined("attributes.display_ds_prod_cost")>
        	,ISNULL(ALL_FINISH_COST,0) AS "Dönem Sonu Birim Maliyet"
        </cfif>
        <cfif isdefined('attributes.stock_age')>
        	,SAT.AG_TOPLAM AS "Stok Yaşı"
        </cfif>
       FROM 
        ####GET_ALL_STOCK_#session.ep.userid# GS
        LEFT JOIN <!---acilis_stok2--->
        (
           SELECT	
                SUM(AMOUNT) AS DB_STOK_MIKTAR,
                SUM(AMOUNT*MALIYET) AS DB_STOK_MALIYET,
                <cfif isdefined('attributes.is_system_money_2')>
                SUM(AMOUNT*MALIYET_2) AS DB_STOK_MALIYET_2,
                </cfif>
                #ALAN_ADI# AS GROUPBY_ALANI
            FROM
                 ####GET_STOCK_ROWS
            WHERE
            <cfif attributes.date is '01/01/#session.ep.period_year#'>
                ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date#">
                AND PROCESS_TYPE = 114
            <cfelse>
                (
                    (
                    ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',-1,attributes.date)#">
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
        ) AS acilis_stok2
        ON GS.PRODUCT_GROUPBY_ID = acilis_stok2.GROUPBY_ALANI
        LEFT JOIN <!---get_total_stok--->
        (
        SELECT 
            SUM(AMOUNT) AS TOTAL_STOCK,
            SUM(AMOUNT*MALIYET) AS TOTAL_PRODUCT_COST,
            <cfif isdefined('attributes.is_system_money_2')>
            SUM(AMOUNT*MALIYET_2) AS TOTAL_PRODUCT_COST_2,
            </cfif>
            #ALAN_ADI# AS GROUPBY_ALANI
        FROM
            ####GET_STOCK_ROWS
        WHERE
            ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
            AND PROCESS_TYPE NOT IN (81,811)
        GROUP BY
           #ALAN_ADI#
        ) as get_total_stok
        ON GS.PRODUCT_GROUPBY_ID = get_total_stok.GROUPBY_ALANI
        <cfif isdefined('attributes.stock_age')> <!--- Stok Yaşı Seçili ise --->
             LEFT JOIN 
             ####stock_age_table SAT  ON SAT.#ALAN_ADI# =  GS.PRODUCT_GROUPBY_ID  <!--- Stok Yaşı seçili ise--->
 		</cfif>       
		<cfif len(attributes.process_type) and listfind(attributes.process_type,2)><!---Alış Ve Alış İadeler--->
              LEFT JOIN <!---d_alis_miktar--->
              (
                SELECT	
                    SUM(AMOUNT) AS TOPLAM_ALIS,
                    SUM(TOTAL_COST) AS TOPLAM_ALIS_MALIYET,
                    <cfif isdefined('attributes.is_system_money_2')>
                    SUM(TOTAL_COST_2) AS TOPLAM_ALIS_MALIYET_2,
                    </cfif>
                    #ALAN_ADI# AS GROUPBY_ALANI
                FROM
                    ####GET_SHIP_ROWS
                WHERE
                     <!--- satıs iade faturaları da mal alım irs. kaydediyor, bunları alıslara dahil etmiyoruz zaten satıs iade bolumunde gosteriliyor --->
                    (
                        PROCESS_TYPE IN (76,80,87)
                        AND INVOICE_CAT NOT IN (54,55)
                    )
                    OR 
                    (
                        PROCESS_TYPE = 84 AND IS_RETURN = 0
                    )
                GROUP BY
                    #ALAN_ADI#
              ) AS d_alis_miktar
              ON
              GS.PRODUCT_GROUPBY_ID = d_alis_miktar.GROUPBY_ALANI
              
              LEFT JOIN <!---d_alis_iade_miktar--->
              (
                SELECT
                    SUM(AMOUNT) AS TOPLAM_ALIS_IADE,
                    SUM(TOTAL_COST) AS TOPLAM_ALIS_IADE_MALIYET,
                    <cfif isdefined('attributes.is_system_money_2')>
                    SUM(TOTAL_COST_2) AS TOPLAM_ALIS_IADE_MALIYET_2,
                    </cfif>
                    #ALAN_ADI# AS GROUPBY_ALANI
                FROM
                    ####GET_SHIP_ROWS
                WHERE
                    PROCESS_TYPE = 78
                GROUP BY
                    #ALAN_ADI#   
              ) AS d_alis_iade_miktar 
              ON GS.PRODUCT_GROUPBY_ID = d_alis_iade_miktar.GROUPBY_ALANI
               LEFT JOIN<!---d_alis_tutar--->
              (
                SELECT
                    <cfif isdefined('attributes.is_system_money_2')>
                    SUM(BIRIM_COST_2 + EXTRA_COST_2) AS TOPLAM_ALIS_MALIYET_2,
                    SUM(BIRIM_COST_2) AS TOPLAM_ALIS_TUTAR_2,
                    </cfif>
                    SUM(BIRIM_COST + EXTRA_COST) AS TOPLAM_ALIS_MALIYET,
                    SUM(BIRIM_COST) AS TOPLAM_ALIS_TUTAR,
                    #ALAN_ADI# AS GROUPBY_ALANI
                FROM
                    ####GET_INV_PURCHASE
                WHERE
                    PROCESS_TYPE IN (59,64,68,591)
                    OR
                    (
                        PROCESS_TYPE = 690 AND IS_RETURN = 0
                    )
                GROUP BY
                    #ALAN_ADI#     
              ) AS d_alis_tutar
              ON
              GS.PRODUCT_GROUPBY_ID = d_alis_tutar.GROUPBY_ALANI
              
              LEFT JOIN <!---d_alis_iade_tutar--->
              (
                SELECT	
                    SUM(EXTRA_COST + BIRIM_COST) AS TOPLAM_ALIS_IADE_MALIYET,
                    <cfif isdefined('attributes.is_system_money_2')>
                    SUM(EXTRA_COST_2 + BIRIM_COST_2) AS TOPLAM_ALIS_IADE_MALIYET_2,
                    </cfif>
                    #ALAN_ADI# AS GROUPBY_ALANI
                FROM
                     ####GET_INV_PURCHASE
                WHERE
                    PROCESS_TYPE = 62
                GROUP BY
                    #ALAN_ADI#    
              ) as d_alis_iade_tutar
              ON GS.PRODUCT_GROUPBY_ID = d_alis_iade_tutar.GROUPBY_ALANI
        </cfif>
		<cfif (len(attributes.process_type) and listfind(attributes.process_type,3))><!---Satış Ve Satış İadeler--->
              LEFT JOIN<!--- d_satis--->
              (
                SELECT	
                    SUM(AMOUNT) AS TOPLAM_SATIS,
                    SUM(TOTAL_COST) AS TOPLAM_SATIS_MALIYET,
                    <cfif isdefined('attributes.is_system_money_2')>
                        SUM(TOTAL_COST_2) AS TOPLAM_SATIS_MALIYET_2,
                    </cfif>
                    #ALAN_ADI# AS GROUPBY_ALANI
                FROM
                    ####GET_SHIP_ROWS
                WHERE
                    PROCESS_TYPE IN (70,71,88)
                GROUP BY
                    #ALAN_ADI#                
              ) AS d_satis ON GS.PRODUCT_GROUPBY_ID = d_satis.GROUPBY_ALANI
              LEFT JOIN <!---d_satis_iade--->
              (
                SELECT	
                    SUM(AMOUNT) AS TOPLAM_SATIS_IADE,
                    SUM(TOTAL_COST) AS TOP_SAT_IADE_MALIYET,
                    <cfif isdefined('attributes.is_system_money_2')>
                    SUM(TOTAL_COST_2) AS TOP_SAT_IADE_MALIYET_2,
                    </cfif>
                    #ALAN_ADI# AS GROUPBY_ALANI
                FROM
                    ####GET_SHIP_ROWS
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
                    ####GET_INV_PURCHASE
                WHERE
                    PROCESS_TYPE IN (690)
                    AND IS_RETURN = 1
                GROUP BY
                    #ALAN_ADI#	
              )  as d_satis_iade ON GS.PRODUCT_GROUPBY_ID = d_satis_iade.GROUPBY_ALANI
			  <cfif isdefined('attributes.from_invoice_actions')><!---Satış Faturası Miktarı-Tutarı Maliyet--->
                    LEFT JOIN <!---d_fatura_satis_tutar--->
                        (
                        SELECT	
                            SUM(BIRIM_COST) AS FATURA_SATIS_TUTAR,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(BIRIM_COST_2) AS FATURA_SATIS_TUTAR_2,
                            </cfif>
                            SUM(INV_COST+INV_EXTRA_COST) AS FATURA_SATIS_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(INV_COST_2+INV_EXTRA_COST_2) AS FATURA_SATIS_MALIYET_2,
                            </cfif>
                            SUM(AMOUNT) AS FATURA_SATIS_MIKTAR,
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            ####GET_INV_PURCHASE
                        WHERE
                            PROCESS_TYPE IN (52,53,531) 
                        GROUP BY
                            #ALAN_ADI#
                     ) AS d_fatura_satis_tutar ON GS.PRODUCT_GROUPBY_ID = d_fatura_satis_tutar.GROUPBY_ALANI
                     LEFT JOIN<!---d_fatura_satis_iade_tutar--->
                        (    
                        SELECT	
                            SUM(BIRIM_COST) AS FATURA_SATIS_IADE_TUTAR,
                            <cfif isdefined('attributes.is_system_money_2')>
                            SUM(BIRIM_COST_2) AS FATURA_SATIS_IADE_TUTAR_2,
                            </cfif>
                            SUM(INV_COST+INV_EXTRA_COST) AS  FATURA_SATIS_IADE_MALIYET,
                            <cfif isdefined('attributes.is_system_money_2')>
                                SUM(INV_COST_2+INV_EXTRA_COST_2) AS FATURA_SATIS_IADE_MALIYET_2,
                            </cfif>
                            SUM(AMOUNT) AS FATURA_SATIS_IADE_MIKTAR,
                            #ALAN_ADI# AS GROUPBY_ALANI
                        FROM
                            ####GET_INV_PURCHASE
                        WHERE
                            PROCESS_TYPE IN (54,55) 
                        GROUP BY
                            #ALAN_ADI#
                    ) AS d_fatura_satis_iade_tutar ON GS.PRODUCT_GROUPBY_ID = d_fatura_satis_iade_tutar.GROUPBY_ALANI 
              </cfif>
        </cfif>
		<cfif len(attributes.process_type) and listfind(attributes.process_type,4)><!---Üretimden Giriş--->
            LEFT JOIN <!---donemici_uretim--->
                (
                SELECT	
                    SUM(AMOUNT) AS TOPLAM_URETIM,
                    SUM(TOTAL_COST_PRICE+TOTAL_EXTRA_COST) AS URETIM_MALIYET,
                    <cfif isdefined('attributes.is_system_money_2')>
                        SUM(TOTAL_COST_PRICE_2+TOTAL_EXTRA_COST) AS URETIM_MALIYET_2,
                    </cfif>
                    #ALAN_ADI# AS GROUPBY_ALANI
                FROM
                    ####GET_STOCK_FIS
                WHERE
                    ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
                    AND PROCESS_TYPE = 110
                    <cfif isdefined('process_cat_list') and len(process_cat_list)>
                        AND PROCESS_CAT  IN (#process_cat_list#)
                    </cfif>
                GROUP BY
                    #ALAN_ADI#		
                ) as donemici_uretim
                ON 	GS.PRODUCT_GROUPBY_ID = donemici_uretim.GROUPBY_ALANI		
        </cfif>
		<cfif len(attributes.process_type) and listfind(attributes.process_type,5)><!---Sarf Ve Fireler--->
         	LEFT JOIN <!---donemici_sarf--->       
                (
                    SELECT	
                        SUM(AMOUNT) AS TOPLAM_SARF,
                        SUM(MALIYET*AMOUNT) AS SARF_MALIYET,
                        <cfif isdefined('attributes.is_system_money_2')>
                        SUM(MALIYET_2*AMOUNT) AS SARF_MALIYET_2,
                        </cfif>
                        #ALAN_ADI# AS GROUPBY_ALANI			
                    FROM
                        ####GET_STOCK_FIS
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
                ) AS  donemici_sarf ON GS.PRODUCT_GROUPBY_ID = donemici_sarf.GROUPBY_ALANI
            LEFT JOIN <!--- üretim sarfları--->
				(
                SELECT	
					SUM(AMOUNT) AS TOPLAM_URETIM_SARF,
					SUM(MALIYET*AMOUNT) AS URETIM_SARF_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(MALIYET_2*AMOUNT) AS URETIM_SARF_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI			
				FROM
					####GET_STOCK_FIS
				WHERE
					ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
					AND PROCESS_TYPE = 111
					<cfif isdefined('process_cat_list') and len(process_cat_list)>
					AND PROCESS_CAT  IN (#process_cat_list#)
					</cfif>
					AND PROD_ORDER_NUMBER <> 0
				GROUP BY
					#ALAN_ADI#			
				) AS donemici_production_sarf ON GS.PRODUCT_GROUPBY_ID = donemici_production_sarf.GROUPBY_ALANI   
            LEFT JOIN <!---donemici_fire--->
                (
                SELECT	
					SUM(AMOUNT) AS TOPLAM_FIRE,
					SUM(MALIYET*AMOUNT) AS FIRE_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(MALIYET_2*AMOUNT) AS FIRE_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI			
				FROM
					####GET_STOCK_FIS
				WHERE
					ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
					AND PROCESS_TYPE =112
					<cfif isdefined('process_cat_list') and len(process_cat_list)>
					AND PROCESS_CAT  IN (#process_cat_list#)
					</cfif>
				GROUP BY
					#ALAN_ADI#		
                )  as  donemici_fire  ON GS.PRODUCT_GROUPBY_ID = donemici_fire.GROUPBY_ALANI
                    
        </cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,6)><!---konsinye_cikis--->
			LEFT JOIN 	
            (
				SELECT	
					SUM(AMOUNT) AS KONS_CIKIS_MIKTAR,
						SUM(TOTAL_COST) AS KONS_CIKIS_MALIYET,
						<cfif isdefined('attributes.is_system_money_2')>
						SUM(TOTAL_COST_2) AS KONS_CIKIS_MALIYET_2,
						</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					####GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 72
				GROUP BY
					#ALAN_ADI#
			) as konsinye_cikis ON GS.PRODUCT_GROUPBY_ID = konsinye_cikis.GROUPBY_ALANI
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,7)><!---konsinye_iade--->
            LEFT JOIN 
            (
				SELECT	
					SUM(AMOUNT) AS KONS_IADE_MIKTAR,
                    SUM(TOTAL_COST) AS KONS_IADE_MALIYET,
                    <cfif isdefined('attributes.is_system_money_2')>
                    SUM(TOTAL_COST_2) AS KONS_IADE_MALIYET_2,
                    </cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					####GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 75
				GROUP BY
					#ALAN_ADI#
			) AS konsinye_iade ON GS.PRODUCT_GROUPBY_ID = konsinye_iade.GROUPBY_ALANI
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,19)><!---konsinye_giris--->
            LEFT JOIN 
            (
				SELECT	
					SUM(AMOUNT) AS KONS_GIRIS_MIKTAR,
                    SUM(TOTAL_COST) AS KONS_GIRIS_MALIYET,
                    <cfif isdefined('attributes.is_system_money_2')>
                    SUM(TOTAL_COST_2) AS KONS_GIRIS_MALIYET_2,
                    </cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					####GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 77
				GROUP BY
					#ALAN_ADI#
			) AS konsinye_giris ON GS.PRODUCT_GROUPBY_ID = konsinye_giris.GROUPBY_ALANI
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,20)><!---konsinye_giris_iade--->
            LEFT JOIN 
            (
				SELECT	
					SUM(AMOUNT) AS KONS_GIRIS_IADE_MIKTAR,
                    SUM(TOTAL_COST) AS KONS_GIRIS_IADE_MALIYET,
                    <cfif isdefined('attributes.is_system_money_2')>
                    SUM(TOTAL_COST_2) AS KONS_GIRIS_IADE_MALIYET_2,
                    </cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					####GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 79
				GROUP BY
					#ALAN_ADI#
			) AS konsinye_giris_iade ON GS.PRODUCT_GROUPBY_ID = konsinye_giris_iade.GROUPBY_ALANI
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,8)><!---servis_giris--->
            LEFT JOIN 
            (
				SELECT	
					SUM(AMOUNT) AS SERVIS_GIRIS_MIKTAR,
					SUM(TOTAL_COST) AS SERVIS_GIRIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST) AS SERVIS_GIRIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					####GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 140
				GROUP BY
					#ALAN_ADI#
			) as servis_giris ON GS.PRODUCT_GROUPBY_ID = servis_giris.GROUPBY_ALANI
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,9)> <!---servis_cikis--->
            LEFT JOIN 
            (
				SELECT	
					SUM(AMOUNT) AS SERVIS_CIKIS_MIKTAR,
					SUM(TOTAL_COST) AS SERVIS_CIKIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_2) AS SERVIS_CIKIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					####GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 141
				GROUP BY
					#ALAN_ADI#
			) AS servis_cikis ON GS.PRODUCT_GROUPBY_ID = servis_cikis.GROUPBY_ALANI
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,10)><!---rma_cikis--->
			LEFT JOIN 
            (
				SELECT	
					SUM(AMOUNT) AS RMA_CIKIS_MIKTAR,
					SUM(TOTAL_COST) AS RMA_CIKIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_2) AS RMA_CIKIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					####GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 85
				GROUP BY
					#ALAN_ADI#
			) AS rma_cikis ON GS.PRODUCT_GROUPBY_ID = rma_cikis.GROUPBY_ALANI
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,11)><!---rma_giris--->
			LEFT JOIN 
            (
				SELECT	
					SUM(AMOUNT) AS RMA_GIRIS_MIKTAR,
					SUM(TOTAL_COST) AS RMA_GIRIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(TOTAL_COST_2) AS RMA_GIRIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					####GET_SHIP_ROWS
				WHERE
					PROCESS_TYPE = 86
				GROUP BY
					#ALAN_ADI#
            ) AS rma_giris ON GS.PRODUCT_GROUPBY_ID = rma_giris.GROUPBY_ALANI
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,12)><!---donemici_sayim--->
			LEFT JOIN 
            (
				SELECT
					SUM(AMOUNT) AS TOPLAM_SAYIM,
					SUM(MALIYET*AMOUNT) AS SAYIM_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(MALIYET_2*AMOUNT) AS SAYIM_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI			
				FROM
					####GET_STOCK_FIS
				WHERE
					ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
					AND PROCESS_TYPE =115
				GROUP BY
					#ALAN_ADI#					
			) AS donemici_sayim ON GS.PRODUCT_GROUPBY_ID = donemici_sayim.GROUPBY_ALANI
        </cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,13)><!---demontaj_giden--->
            LEFT JOIN 
            (
				SELECT	
					(SUM(STOCK_IN)-SUM(STOCK_OUT)) AS DEMONTAJ_GIDEN,
					SUM((STOCK_IN-STOCK_OUT)*MALIYET) AS DEMONTAJ_GIDEN_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM((STOCK_IN-STOCK_OUT)*MALIYET_2) AS DEMONTAJ_GIDEN_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI			
				FROM
					####GET_DEMONTAJ
				WHERE
					ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
				GROUP BY
					#ALAN_ADI#			
			) AS demontaj_giden ON  GS.PRODUCT_GROUPBY_ID = demontaj_giden.GROUPBY_ALANI
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,14)><!---donemici_demontaj_giris--->
			LEFT JOIN 
            (
				SELECT	
					SUM(AMOUNT) AS DEMONTAJ_GIRIS,
					SUM(MALIYET*AMOUNT) AS DEMONTAJ_GIRIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(MALIYET_2*AMOUNT) AS DEMONTAJ_GIRIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI			
				FROM
					####GET_STOCK_FIS
				WHERE
					ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
					AND PROCESS_TYPE = 119
					<cfif isdefined('process_cat_list') and len(process_cat_list)>
					AND PROCESS_CAT  IN (#process_cat_list#)
					</cfif>
				GROUP BY
					#ALAN_ADI#					
            ) AS donemici_demontaj_giris ON  GS.PRODUCT_GROUPBY_ID = donemici_demontaj_giris.GROUPBY_ALANI
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,15)><!---donemici_masraf--->
			LEFT JOIN 
            (
				SELECT	
					SUM(AMOUNT) AS TOPLAM_MASRAF_MIKTAR,
					SUM(MALIYET*AMOUNT) AS MASRAF_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(MALIYET_2*AMOUNT) AS MASRAF_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI			
				FROM
					####GET_EXPENSE
				WHERE
					ISLEM_TARIHI >= <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#attributes.date#">
				GROUP BY
					#ALAN_ADI#					
            ) AS donemici_masraf ON  GS.PRODUCT_GROUPBY_ID = donemici_masraf.GROUPBY_ALANI
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,21)><!---Stok Virman--->
			LEFT JOIN 
            (
				SELECT 
					SUM(STOCK_IN) AS STOK_VIRMAN_GIRIS_MIKTARI,
					SUM(STOCK_IN*MALIYET) AS STOK_VIRMAN_GIRIS_MALIYETI,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(STOCK_IN*MALIYET_2) AS STOK_VIRMAN_GIRIS_MALIYETI_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					####GET_STOCK_VIRMAN_IN
				WHERE
					ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				GROUP BY
					#ALAN_ADI#
			) AS get_stok_virman_total_in ON  GS.PRODUCT_GROUPBY_ID = get_stok_virman_total_in.GROUPBY_ALANI
            LEFT JOIN 
            (
            	SELECT 
					SUM(STOCK_OUT) AS STOK_VIRMAN_CIKIS_MIKTARI,
					SUM(STOCK_OUT*MALIYET) AS STOK_VIRMAN_CIKIS_MALIYET,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(STOCK_OUT*MALIYET_2) AS STOK_VIRMAN_CIKIS_MALIYET_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					####GET_STOCK_VIRMAN_OUT
				WHERE
					ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				GROUP BY
					#ALAN_ADI#
            ) AS get_stok_virman_total_out  ON  GS.PRODUCT_GROUPBY_ID = get_stok_virman_total_out.GROUPBY_ALANI
		</cfif>
        <cfif len(attributes.process_type) and listfind(attributes.process_type,22)>
			LEFT JOIN 
            (
            	SELECT 
					SUM(STOCK_OUT) AS AMOUNT,
					SUM(STOCK_OUT*MALIYET) AS COST,
					SUM(STOCK_OUT*PRICE) AS PRICE,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(STOCK_OUT*MALIYET_2) AS COST_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					####GET_INVENT_STOCK_FIS
				WHERE
					ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				GROUP BY
					#ALAN_ADI#
            ) AS get_invent_stock_fis_all ON  GS.PRODUCT_GROUPBY_ID = get_invent_stock_fis_all.GROUPBY_ALANI
            LEFT JOIN
            (
            	SELECT 
					SUM(STOCK_IN) AS AMOUNT,
					SUM(STOCK_IN*MALIYET) AS COST,
					SUM(STOCK_IN*PRICE) AS PRICE,
					<cfif isdefined('attributes.is_system_money_2')>
					SUM(STOCK_IN*MALIYET_2) AS COST_2,
					</cfif>
					#ALAN_ADI# AS GROUPBY_ALANI
				FROM
					####GET_INVENT_STOCK_FIS_RETURN
				WHERE
					ISLEM_TARIHI <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				GROUP BY
					#ALAN_ADI#
            )AS get_invent_stock_fis_return_all ON GS.PRODUCT_GROUPBY_ID = get_invent_stock_fis_return_all.GROUPBY_ALANI
		</cfif>
  ORDER BY
  	<cfif attributes.report_type eq 1 >
    	STOCK_CODE
    <cfelseif attributes.report_type eq 2>
    	ACIKLAMA
    </cfif>        
</cfquery>
<cfspreadsheet action="write" filename="#trim(upload_folder)#/reserve_files/stock_analyse_.xls" sheetname="Stok Analiz" overwrite=true query="GET_QUERY"> 
<script type="text/javascript">
    <cfoutput>
        get_wrk_message_div("Excel","Excel","/documents/reserve_files/stock_analyse_.xls") ;
    </cfoutput>
</script>
