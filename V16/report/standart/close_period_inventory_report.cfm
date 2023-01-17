<!--- Donem Kapama Envanteri Tablosu FBS 20110906 --->
<cfparam name="attributes.module_id_control" default="13">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.category" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.is_excel" default="">
<cfsetting showdebugoutput="no">
<cfif isDate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
<cfif isDate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
<cfif isdefined("attributes.submitted")>
	<cfquery name="check_table" datasource="#dsn3#">
    	IF EXISTS(SELECT * FROM tempdb.SYS.TABLES where name = '####CLOSE_PERIOD_INVENTORY_#session.ep.userid#')
   		DROP TABLE 	####CLOSE_PERIOD_INVENTORY_#session.ep.userid#
    </cfquery>
    <cfquery name="I_Get_Stocks_Info" datasource="#dsn3#" result="xxx">
		SELECT DISTINCT
			S.STOCK_ID,
			S.STOCK_CODE,
			S.PRODUCT_CODE_2,
            S.PRODUCT_ID,
			S.PRODUCT_NAME,
			ISNULL((	SELECT TOP 1
							(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
						FROM 
							#dsn3_alias#.PRODUCT_COST 
						WHERE 
							START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							PRODUCT_ID = S.PRODUCT_ID
						ORDER BY 
							START_DATE DESC, 
							RECORD_DATE DESC,
							PRODUCT_COST_ID DESC
					),0) ALL_START_COST,
			ISNULL((	SELECT TOP 1 
							(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
						FROM 
							#dsn3_alias#.PRODUCT_COST 
						WHERE 
							START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
							PRODUCT_ID = S.PRODUCT_ID
						ORDER BY 
							START_DATE DESC, 
							RECORD_DATE DESC,
							PRODUCT_COST_ID DESC
					),0) ALL_FINISH_COST
		INTO 
        	####CLOSE_PERIOD_INVENTORY_#session.ep.userid#
        FROM
			STOCKS S 
		LEFT JOIN
        	#DSN2_ALIAS#.STOCKS_ROW  SR
		ON
        	SR.STOCK_ID = S.STOCK_ID AND 
            SR.PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
			SR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">  
		WHERE
			<cfif Len(attributes.category)>
				(
				<cfloop from="1" to="#listlen(attributes.category)#" index="kk">
					(	
						S.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(attributes.category,kk)#"> OR 
						S.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(attributes.category,kk)#%">
					)
					<cfif kk neq listlen(attributes.category)>OR</cfif>
				</cfloop>
				)
				AND
			</cfif>
			<cfif Len(attributes.product_id) and Len(attributes.product_name)>
				S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
			</cfif>
			S.STOCK_STATUS = 1
		ORDER BY
			S.STOCK_CODE,
			S.PRODUCT_NAME
	</cfquery>
	<cfset Process_Type_List = "0">
	<cfset Process_Type_List_Ship = "0">
    <cfset Process_Type_List_Fis = "0">
    <cfset Process_Type_List_Ship_Other = "0">
    <cfset Process_Type_List_Fis_Other = "0">
    <cfset Process_Type_List_Exchange_Other = "0">
    <cfquery name="Get_Stocks_Info" datasource="#dsn3#">
    	SELECT TOP 1 * FROM ####CLOSE_PERIOD_INVENTORY_#session.ep.userid#
    </cfquery>
	<cfif Get_Stocks_Info.RecordCount>
		<!--- ESTde Stok Hareketlerinde Kullanilan Process_Type (81 Sevklerin Alinmamasi Gerektigi Bildirildiginden Kaldirildi) --->
		<cfset Process_Type_List = "70,71,74,76,77,78,84,87,88,110,111,112,114,115,116">
        <cfquery name="check_table" datasource="#dsn3#">
            IF EXISTS(SELECT * FROM tempdb.SYS.TABLES where name = '####Get_Stocks_Row_Info_#session.ep.userid#')
            DROP TABLE 	####Get_Stocks_Row_Info_#session.ep.userid#
        </cfquery>
        <cfquery name="I_Get_Stocks_Row_Info" datasource="#dsn2#">
			SELECT
				SUM(STOCK_IN) STOCK_IN,
				SUM(STOCK_OUT) STOCK_OUT,
				PROCESS_DATE,
				PROCESS_TYPE,
				UPD_ID,
				STOCK_ID
			INTO ####Get_Stocks_Row_Info_#session.ep.userid#
            FROM
				STOCKS_ROW
			WHERE
				UPD_ID IS NOT NULL AND
				PROCESS_TYPE IS NOT NULL AND
				PROCESS_TYPE IN (#Process_Type_List#) AND
				STOCK_ID IN (SELECT STOCK_ID FROM ####CLOSE_PERIOD_INVENTORY_#session.ep.userid# ) AND
				PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
				PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
			GROUP BY
				PROCESS_DATE,
				PROCESS_TYPE,
				UPD_ID,
				STOCK_ID
		</cfquery>
        <cfquery name="Get_Stocks_Row_Info" datasource="#dsn2#">
        	SELECT * FROM ####Get_Stocks_Row_Info_#session.ep.userid#
        </cfquery>
        
        <cfquery name="check_table" datasource="#dsn3#">
            IF EXISTS(SELECT * FROM tempdb.SYS.TABLES where name = '####Get_Stocks_Row_Info2#session.ep.userid#')
            DROP TABLE 	####Get_Stocks_Row_Info2#session.ep.userid#
        </cfquery>
		<cfquery name="I_Get_Stocks_Row_Info2" datasource="#dsn2#">
			SELECT
				SUM(STOCK_IN) STOCK_IN,
				SUM(STOCK_OUT) STOCK_OUT,
				PROCESS_DATE,
				PROCESS_TYPE,
				UPD_ID,
				STOCK_ID
			INTO ####Get_Stocks_Row_Info2#session.ep.userid#
            FROM
				STOCKS_ROW
			WHERE
				UPD_ID IS NOT NULL AND
				PROCESS_TYPE IS NOT NULL AND
				PROCESS_TYPE IN (#Process_Type_List#) AND
				STOCK_ID IN (SELECT STOCK_ID FROM ####CLOSE_PERIOD_INVENTORY_#session.ep.userid# ) 
			GROUP BY
				PROCESS_DATE,
				PROCESS_TYPE,
				UPD_ID,
				STOCK_ID
		</cfquery>
        <cfquery name="Get_Stocks_Row_Info2" datasource="#dsn2#">
        	SELECT * FROM ####Get_Stocks_Row_Info2#session.ep.userid#
        </cfquery>
        
		<cfoutput query="Get_Stocks_Row_Info">
			<cfif ListFind("76,77,84,811",Process_Type) and not ListFind(Process_Type_List_Ship,Process_Type)><!--- 70,71,78,88, --->
				<cfset Process_Type_List_Ship = ListAppend(Process_Type_List_Ship,Process_Type)>
			<cfelseif ListFind("111,112,115,110",Process_Type) and not ListFind(Process_Type_List_Fis,Process_Type)>
				<cfset Process_Type_List_Fis = ListAppend(Process_Type_List_Fis,Process_Type)>
			<cfelse>
				<cfif ListFind("114",Process_Type) and not ListFind(Process_Type_List_Fis_Other,Process_Type)>
					<cfset Process_Type_List_Fis_Other = ListAppend(Process_Type_List_Fis_Other,Process_Type)>
				<cfelseif ListFind("116",Process_Type) and not ListFind(Process_Type_List_Exchange_Other,Process_Type)>
					<cfset Process_Type_List_Exchange_Other = ListAppend(Process_Type_List_Exchange_Other,Process_Type)>
				<cfelse>
					<cfset Process_Type_List_Ship_Other = ListAppend(Process_Type_List_Ship_Other,Process_Type)>
				</cfif>
			</cfif>
		</cfoutput>
        <cfquery name="CHECK_TABLE" datasource="#DSN3#">
             IF EXISTS(SELECT * FROM tempdb.SYS.TABLES where name = '####CLOSE_PERIOD_INVENTORY_2#session.ep.userid#')
                DROP TABLE ####CLOSE_PERIOD_INVENTORY_2#session.ep.userid#
        </cfquery>
        <cfquery name="Get_Stocks_Info_1" datasource="#dsn3#">
            SELECT 
                Get_Stocks_Info.STOCK_ID,
                Get_Stocks_Info.STOCK_CODE,
                Get_Stocks_Info.PRODUCT_CODE_2,
                Get_Stocks_Info.PRODUCT_ID,
                Get_Stocks_Info.PRODUCT_NAME,
                ISNULL(Get_Stocks_Info.ALL_START_COST,0) AS ALL_START_COST ,
                ISNULL(Get_Stocks_Info.ALL_FINISH_COST,0) AS ALL_FINISH_COST ,
                ISNULL(Get_First_Stocks.DIFF_STOCK,0) AS DIFF_STOCK ,
                 <cfif attributes.startdate is '01/01/#session.ep.period_year#'>
                ISNULL(Get_Stock_Fis.TOTAL_COST_PRICE,0) AS TOTAL_COST_PRICE,
                </cfif>
                ISNULL(Get_Process_Type_Control.NETTOTAL,0) AS NETTOTAL,
                ISNULL(Get_Process_Type_Control.STOCK_IN,0) AS STOCK_IN
            INTO ####CLOSE_PERIOD_INVENTORY_2#session.ep.userid#
            FROM 
                ####CLOSE_PERIOD_INVENTORY_#session.ep.userid# Get_Stocks_Info
            LEFT JOIN
            (
            SELECT
                SUM(STOCK_IN-STOCK_OUT) DIFF_STOCK,STOCK_ID
            FROM
                ####Get_Stocks_Row_Info2#session.ep.userid#
            WHERE
                <cfif attributes.startdate is '01/01/#session.ep.period_year#'>
                    PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND 
                    PROCESS_TYPE = 114
                <cfelse>
                    PROCESS_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                </cfif>
            GROUP BY
                 STOCK_ID      
            ) AS Get_First_Stocks  ON  Get_Stocks_Info.STOCK_ID = Get_First_Stocks.STOCK_ID
            <cfif attributes.startdate is '01/01/#session.ep.period_year#'>
                LEFT JOIN
                (
                SELECT 
                    SUM(AMOUNT*COST_PRICE) AS  TOTAL_COST_PRICE ,STOCK_ID
                FROM 
                    (
                       SELECT
                            SFR.AMOUNT AMOUNT,
                            SFR.COST_PRICE COST_PRICE,
                            STOCK_ID
                        FROM 
                            #DSN2_ALIAS#.STOCK_FIS SF,
                            #DSN2_ALIAS#.STOCK_FIS_ROW SFR
                        WHERE
                            SF.FIS_ID = SFR.FIS_ID AND
                            FIS_TYPE = 114 AND
                            SF.FIS_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                    )
                    Get_Stock_Fis_All 
                GROUP BY  
                    STOCK_ID 
                ) AS Get_Stock_Fis  ON Get_Stocks_Info.STOCK_ID = Get_Stock_Fis.STOCK_ID
            </cfif>
            <cfif (isDefined("Process_Type_List_Ship") and ListLen(Process_Type_List_Ship)) or ( isDefined("Process_Type_List_Fis") and ListLen(Process_Type_List_Fis))>
                   LEFT JOIN	
                   ( 
                           SELECT
                                ISNULL(SUM(NETTOTAL),0) NETTOTAL,
                                ISNULL(SUM(Get_All_Types.AMOUNT),0) STOCK_IN,
                                STOCK_ID
                            FROM
                                (
                                    <cfif ListLen(Process_Type_List_Ship)>
                                        <!--- Alis Faturalari --->
                                        SELECT
                                            1 TYPE,
                                            NULL PROD_ORDER_RESULT_NUMBER,										
                                            (SELECT TOP 1 SHIP_TYPE FROM  #DSN2_ALIAS#.SHIP, #DSN2_ALIAS#.INVOICE_SHIPS ISH WHERE SHIP.SHIP_ID = ISH.SHIP_ID AND ISH.INVOICE_ID = I.INVOICE_ID) PROCESS_TYPE,
                                            I.INVOICE_ID PAPER_ID,
                                            SUM(IR.AMOUNT) AMOUNT,
                                            SUM(IR.NETTOTAL+(IR.AMOUNT*IR.EXTRA_COST)) NETTOTAL,
                                            IR.STOCK_ID
                                        FROM
                                             #DSN2_ALIAS#.INVOICE I,
                                             #DSN2_ALIAS#.INVOICE_ROW IR
                                        WHERE
                                            I.PURCHASE_SALES = 0 AND
                                            I.INVOICE_ID = IR.INVOICE_ID AND
                                            I.INVOICE_ID IN (SELECT INVOICE_ID FROM  #DSN2_ALIAS#.INVOICE_SHIPS ISH, #DSN2_ALIAS#.SHIP WHERE SHIP.SHIP_ID = ISH.SHIP_ID AND SHIP.SHIP_TYPE IN (76,87)) AND
                                            <!--- IR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Stocks_Info.Stock_Id#"> AND --->
                                            I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                                            I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                                        GROUP BY
                                            I.INVOICE_ID,
                                            IR.STOCK_ID
                                    </cfif>
                                    <cfif ListLen(Process_Type_List_Ship) and ListLen(Process_Type_List_Fis)>
                                    UNION
                                    </cfif>
                                    <cfif ListLen(Process_Type_List_Fis)>
                                        SELECT
                                            2 TYPE,
                                            PROD_ORDER_RESULT_NUMBER,
                                            S.FIS_TYPE PROCESS_TYPE,
                                            S.FIS_ID PAPER_ID,
                                            SUM(SR.AMOUNT) AMOUNT,
                                            SUM((PORR.PURCHASE_NET_SYSTEM+PORR.PURCHASE_EXTRA_COST_SYSTEM+ISNULL(PORR.STATION_REFLECTION_COST_SYSTEM,0)+ISNULL(PORR.LABOR_COST_SYSTEM,0))*PORR.AMOUNT) NETTOTAL,
                                            SR.STOCK_ID
                                        FROM
                                            #DSN2_ALIAS#. STOCK_FIS S,
                                             #DSN2_ALIAS#.STOCK_FIS_ROW SR,
                                            #dsn3_alias#.PRODUCTION_ORDER_RESULTS_ROW PORR
                                        WHERE
                                            S.FIS_ID = SR.FIS_ID AND
                                            S.FIS_TYPE IN (110) AND<!--- #Process_Type_List_Fis# --->
                                            S.FIS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                                            S.FIS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
                                            S.PROD_ORDER_RESULT_NUMBER = PORR.PR_ORDER_ID AND
                                            SR.STOCK_ID = PORR.STOCK_ID
                                        GROUP BY
                                            PROD_ORDER_RESULT_NUMBER,
                                            S.FIS_TYPE,
                                            S.FIS_ID,
                                            SR.STOCK_ID
                                    </cfif>
                                ) Get_All_Types
                            GROUP BY 
                                STOCK_ID    
                    ) as Get_Process_Type_Control ON Get_Process_Type_Control.STOCK_ID = Get_Stocks_Info.STOCK_ID
            </cfif>
        </cfquery>
        <cfquery name="Get_Stocks_Info" datasource="#dsn3#">
            SELECT 
                 Get_Stocks_Info.STOCK_ID,
                 STOCK_CODE,
                 PRODUCT_CODE_2,
                 PRODUCT_ID,
                 PRODUCT_NAME,
                 ISNULL(ALL_START_COST,0) AS ALL_START_COST ,
                 ALL_FINISH_COST,
                 DIFF_STOCK,
                  <cfif attributes.startdate is '01/01/#session.ep.period_year#'>
                 TOTAL_COST_PRICE,
                 </cfif>
                 NETTOTAL,
                 STOCK_IN
                 <cfif ListLen(Process_Type_List_Ship_Other) or ListLen(Process_Type_List_Fis_Other) or ListLen(Process_Type_List_Exchange_Other)>
                    ,ISNULL(STOCK_IN1,0) AS STOCK_IN1
                 </cfif>
                 ,ISNULL(INV_DIFF_PRICE,0) AS  INV_DIFF_PRICE
                 ,ISNULL(INV_DIFF_AMOUNT,0) AS INV_DIFF_AMOUNT
                 ,ISNULL(EXTRA_COST_PRICE,0) AS EXTRA_COST_PRICE
                 ,ISNULL(EXTRA_COST_AMOUNT,0) AS EXTRA_COST_AMOUNT
                 ,ISNULL(STOCK_OUT,0) AS STOCK_OUT
                 ,ISNULL(get_alim_iade.NETTOTAL1,0)AS NETTOTAL1
                 ,ISNULL(get_alim_iade.AMOUNT1,0) AS AMOUNT1
                 ,ISNULL(DIFF_STOCK1,0) AS DIFF_STOCK1
            FROM
            
                ####CLOSE_PERIOD_INVENTORY_2#session.ep.userid# Get_Stocks_Info
                <cfif ListLen(Process_Type_List_Ship_Other) or ListLen(Process_Type_List_Fis_Other) or ListLen(Process_Type_List_Exchange_Other)>
                    LEFT JOIN
                    (
                                    SELECT
                                        <!--- ISNULL(SUM(Get_Stocks_Row_Info.STOCK_IN),0) STOCK_IN --->
                                        ISNULL(SUM(Get_Other_Types.AMOUNT),0) STOCK_IN1,
                                         Get_Stocks_Row_Info.STOCK_ID
                                    FROM
                                        (
                                            SELECT
                                                STOCK_IN,
                                                STOCK_OUT,
                                                PROCESS_DATE,
                                                PROCESS_TYPE,
                                                UPD_ID,
                                                STOCK_ID
                                            FROM
                                                ####Get_Stocks_Row_Info_#session.ep.userid#
                                        ) Get_Stocks_Row_Info,
                                        (
                                            
                                            <cfif ListLen(Process_Type_List_Ship_Other)>
                                                SELECT
                                                    3 TYPE,
                                                    NULL PROD_ORDER_RESULT_NUMBER,
                                                    (SELECT SHIP_TYPE FROM #DSN2_ALIAS#.SHIP WHERE SHIP.SHIP_ID = ISH.SHIP_ID) PROCESS_TYPE,
                                                    ISH.SHIP_ID PAPER_ID,
                                                    SUM(IR.AMOUNT) AMOUNT,
                                                    SUM(IR.NETTOTAL) NETTOTAL,
                                                    IR.STOCK_ID
                                                FROM
                                                    #DSN2_ALIAS#.INVOICE I,
                                                    #DSN2_ALIAS#.INVOICE_ROW IR,
                                                    #DSN2_ALIAS#.INVOICE_SHIPS ISH
                                                WHERE
                                                    I.PURCHASE_SALES = 0 AND
                                                    I.INVOICE_ID = IR.INVOICE_ID AND
                                                    I.INVOICE_ID = ISH.INVOICE_ID AND
                                                    IR.INVOICE_ID = ISH.INVOICE_ID AND
                                                    ISH.SHIP_ID IN (SELECT SHIP_ID FROM #DSN2_ALIAS#.SHIP WHERE SHIP.SHIP_ID = ISH.SHIP_ID AND SHIP.SHIP_TYPE IN (#Process_Type_List#) AND SHIP.SHIP_TYPE NOT IN (76,87) AND SHIP.SHIP_TYPE NOT IN (#Process_Type_List_Fis#)) AND
                                                    I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                                                    I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                                                GROUP BY
                                                    ISH.SHIP_ID,
                                                    IR.STOCK_ID
                                            </cfif>
                                            <cfif ListLen(Process_Type_List_Ship_Other) and (ListLen(Process_Type_List_Fis_Other) or ListLen(Process_Type_List_Exchange_Other))>
                                            UNION
                                            </cfif>
                                            <!--- Fisler --->
                                            <cfif ListLen(Process_Type_List_Fis_Other)>
                                                SELECT
                                                    4 TYPE,
                                                    PROD_ORDER_RESULT_NUMBER,
                                                    S.FIS_TYPE PROCESS_TYPE,
                                                    S.FIS_ID PAPER_ID,
                                                    SUM(SR.AMOUNT) AMOUNT,
                                                    SUM(SR.NET_TOTAL) NETTOTAL,
                                                    SR.STOCK_ID
                                                FROM
                                                    #DSN2_ALIAS#.STOCK_FIS S,
                                                    #DSN2_ALIAS#.STOCK_FIS_ROW SR
                                                WHERE
                                                    S.FIS_ID = SR.FIS_ID AND
                                                    S.FIS_TYPE IN (#Process_Type_List#) AND
                                                    S.FIS_TYPE NOT IN (114,110) AND
                                                    S.FIS_TYPE NOT IN (#Process_Type_List_Ship#) AND
                                                    S.FIS_TYPE NOT IN (#Process_Type_List_Fis#) 
                                                GROUP BY
                                                    PROD_ORDER_RESULT_NUMBER,
                                                    S.FIS_TYPE,
                                                    S.FIS_ID,
                                                    SR.STOCK_ID
                                            UNION ALL
                                                SELECT
                                                    4 TYPE,
                                                    PROD_ORDER_RESULT_NUMBER,
                                                    S.FIS_TYPE PROCESS_TYPE,
                                                    S.FIS_ID PAPER_ID,
                                                    SUM(SR.AMOUNT) AMOUNT,
                                                    SUM(SR.NET_TOTAL) NETTOTAL,
                                                    SR.STOCK_ID
                                                FROM
                                                    #DSN2_ALIAS#.STOCK_FIS S,
                                                    #DSN2_ALIAS#.STOCK_FIS_ROW SR
                                                WHERE
                                                    S.FIS_ID = SR.FIS_ID AND
                                                    S.FIS_TYPE IN (115) 
                                                GROUP BY
                                                    PROD_ORDER_RESULT_NUMBER,
                                                    S.FIS_TYPE,
                                                    S.FIS_ID,
                                                    SR.STOCK_ID
                                            </cfif>
                                            <cfif ListLen(Process_Type_List_Fis_Other) and ListLen(Process_Type_List_Exchange_Other)>
                                            UNION
                                            </cfif>
                                            <!--- Stok Virman --->
                                            <cfif ListLen(Process_Type_List_Exchange_Other)>
                                                SELECT
                                                    5 TYPE,
                                                    NULL PROD_ORDER_RESULT_NUMBER,
                                                    S.PROCESS_TYPE PROCESS_TYPE,
                                                    S.STOCK_EXCHANGE_ID PAPER_ID,
                                                    S.AMOUNT AMOUNT,
                                                    0 NETTOTAL,
                                                    S.STOCK_ID
                                                FROM
                                                    #DSN2_ALIAS#.STOCK_EXCHANGE S
                                                WHERE
                                                    S.PROCESS_TYPE IN (#Process_Type_List#) AND
                                                    S.PROCESS_TYPE NOT IN (#Process_Type_List_Ship#) AND
                                                    S.PROCESS_TYPE NOT IN (#Process_Type_List_Fis#) AND
                                                    S.PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                                                    S.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                                            </cfif>
                                        ) Get_Other_Types
                                    WHERE
                                        Get_Stocks_Row_Info.UPD_ID = Get_Other_Types.PAPER_ID AND
                                        Get_Stocks_Row_Info.PROCESS_TYPE = Get_Other_Types.PROCESS_TYPE AND
                                        Get_Stocks_Row_Info.STOCK_ID = Get_Other_Types.STOCK_ID 
                                    GROUP BY
                                            Get_Stocks_Row_Info.STOCK_ID
                            ) AS Get_Other_Process_Type_Control   ON  	Get_Other_Process_Type_Control.STOCK_ID = Get_Stocks_Info.STOCK_ID 			
                </cfif>
            LEFT JOIN
                    (	
                            SELECT
                                    SUM(NETTOTAL) INV_DIFF_PRICE,
                                    SUM(AMOUNT) INV_DIFF_AMOUNT,
                                    STOCK_ID
                                FROM
                                (
                                SELECT
                                    DISTINCT 
                                    IR2.INVOICE_ROW_ID,
                                    IR2.AMOUNT,
                                    IR2.NETTOTAL,
                                    IR2.STOCK_ID
                                FROM
                                    #DSN2_ALIAS#.INVOICE I,
                                    #DSN2_ALIAS#.INVOICE_ROW IR,
                                    #DSN2_ALIAS#.INVOICE I2,
                                    #DSN2_ALIAS#.INVOICE_ROW IR2,
                                    #DSN2_ALIAS#.INVOICE_SHIPS ISH,
                                    #DSN2_ALIAS#.INVOICE_CONTRACT_COMPARISON IC
                                WHERE
                                    IC.MAIN_INVOICE_ID = I.INVOICE_ID AND
                                    I2.INVOICE_ID=IC.DIFF_INVOICE_ID AND
                                    IR2.INVOICE_ID=I2.INVOICE_ID AND
                                    I.PURCHASE_SALES = 0 AND
                                    I.INVOICE_ID = IR.INVOICE_ID AND
                                    I2.INVOICE_ID = IR2.INVOICE_ID AND
                                    I.INVOICE_ID = ISH.INVOICE_ID AND
                                    IR.INVOICE_ID = ISH.INVOICE_ID AND
                                    ISH.SHIP_ID IN (SELECT SHIP_ID FROM #DSN2_ALIAS#.SHIP WHERE SHIP.SHIP_ID = ISH.SHIP_ID AND SHIP.SHIP_TYPE IN (0,76)) AND
                                    I2.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                                    I2.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
                                    I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                                    I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                                )T1
                                GROUP BY
                                    STOCK_ID
                    ) AS get_price_diff ON get_price_diff.STOCK_ID = Get_Stocks_Info.STOCK_ID
                    
             LEFT JOIN
                                (
                                SELECT
                                    SUM(NETTOTAL) EXTRA_COST_PRICE,
                                    SUM(AMOUNT) EXTRA_COST_AMOUNT,
                                    STOCK_ID
                                FROM
                                (
                                    SELECT
                                        SUM(IR.AMOUNT) AMOUNT,
                                        SUM(IR.EXTRA_COST*IR.AMOUNT) NETTOTAL,
                                        IR.STOCK_ID
                                    FROM
                                        #DSN2_ALIAS#.SHIP I,
                                        #DSN2_ALIAS#.SHIP_ROW IR
                                    WHERE
                                        I.SHIP_TYPE = 811 AND
                                        I.SHIP_ID = IR.SHIP_ID AND
                                        I.SHIP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                                        I.SHIP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                                    GROUP BY
                                        IR.STOCK_ID
                                )T1
                                GROUP BY
                                    STOCK_ID
                             ) AS get_extra_cost ON get_extra_cost.STOCK_ID =  Get_Stocks_Info.STOCK_ID
            
            
            LEFT JOIN
                (
                                SELECT
                                    SUM(STOCK_OUT) STOCK_OUT,
                                    STOCK_ID
                                FROM
                                    ####Get_Stocks_Row_Info_#session.ep.userid# 
                                WHERE
                                     PROCESS_TYPE <> 78
                                GROUP BY 
                                    STOCK_ID      
                ) AS Get_Between_Stocks_Out ON Get_Between_Stocks_Out.STOCK_ID = Get_Stocks_Info.STOCK_ID
            LEFT JOIN
            (
                                SELECT
                                    ISNULL(SUM(IR.NETTOTAL+(IR.AMOUNT*IR.EXTRA_COST)),0) NETTOTAL1,
                                    ISNULL(SUM(IR.AMOUNT),0) AMOUNT1,
                                    STOCK_ID
                                FROM
                                    #DSN2_ALIAS#.INVOICE I,
                                    #DSN2_ALIAS#.INVOICE_ROW IR
                                WHERE
                                    I.INVOICE_ID = IR.INVOICE_ID AND
                                    I.INVOICE_ID IN (SELECT INVOICE_ID FROM #DSN2_ALIAS#.INVOICE_SHIPS ISH,#DSN2_ALIAS#.SHIP WHERE SHIP.SHIP_ID = ISH.SHIP_ID AND SHIP.SHIP_TYPE IN (78)) AND
                                    I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                                    I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                               GROUP BY STOCK_ID     
            ) AS get_alim_iade ON get_alim_iade.STOCK_ID =  Get_Stocks_Info.STOCK_ID
            LEFT JOIN
            (
                                SELECT
                                    SUM(STOCK_IN-STOCK_OUT) DIFF_STOCK1,
                                    STOCK_ID
                                FROM
                                     ####Get_Stocks_Row_Info2#session.ep.userid#
                                WHERE
                                    PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                                GROUP BY STOCK_ID     
            ) AS Get_Last_Stocks ON Get_Last_Stocks.STOCK_ID = Get_Stocks_Info.STOCK_ID
            ORDER BY Get_Stocks_Info.STOCK_ID,
                 STOCK_CODE
        </cfquery>    
	</cfif>
<cfelse>
	<cfset Get_Stocks_Info.RecordCount = 0>	
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#Get_Stocks_Info.RecordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
    <cfset attributes.startrow=1>
    <cfset attributes.maxrows = Get_Stocks_Info.recordcount>
</cfif> 
<cfquery name="Get_Category" datasource="#dsn3#">
	SELECT PRODUCT_CAT,PRODUCT_CATID,HIERARCHY,IS_SUB_PRODUCT_CAT FROM PRODUCT_CAT ORDER BY HIERARCHY,PRODUCT_CAT
</cfquery>
<cfform name="rapor" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
    <cfoutput>  
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='40756.Dönem Kapama Envanteri Raporu'></cfsavecontent>
        <cf_report_list_search title="#title#">
            <cf_report_list_search_area>
                <div class="row">
                    <div class="col col-12 col-xs-12">
                        <div class="row formContent">
                            <div class="row" type="row">
                                <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                                    <div class="col col-12 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                                            <div class="col col-12">
                                                <select name="category" id="category" multiple>
                                                    <cfloop query="Get_Category">
                                                        <option value="#hierarchy#" <cfif ListFind(attributes.category,Get_Category.Hierarchy)>selected</cfif>><cfif Get_Category.Is_Sub_Product_Cat eq 0>&nbsp;&nbsp;&nbsp;</cfif>#Get_Category.Hierarchy# #Product_Cat#</option>
                                                    </cfloop>
                                                </select>	
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                                    <div class="col col-12 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'>*</label>
                                            <div class="col col-6">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                                                    <cfinput type="text" name="startdate" value="#DateFormat(attributes.startdate,dateformat_style)#" validate="#validate_style#" required="yes" message="#message#" maxlength="10" style="width:65px;">
                                                    <span class="input-group-addon">
                                                    <cf_wrk_date_image date_field="startdate">
                                                    </span>	    
                                                </div>
                                            </div>
                                            <div class="col col-6">
                                                <div class="input-group">
                                                    <cfinput type="text" name="finishdate" value="#DateFormat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" required="yes" message="#message#" maxlength="10" style="width:65px;">
                                                    <span class="input-group-addon">
                                                    <cf_wrk_date_image date_field="finishdate">
                                                    </span>    
                                                </div>                                                 
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57657.Urun'></label>
                                            <div class="col col-12">
                                                <div class="input-group">
                                                    <input type="hidden" name="product_id" id="product_id" value="<cfif len(attributes.product_name)>#attributes.product_id#</cfif>">
                                                    <input type="text" name="product_name" id="product_name" value="#attributes.product_name#" style="width:155px;" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','225');" autocomplete="off">
                                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&product_id=rapor.product_id&field_name=rapor.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row ReportContentBorder">
                            <div class="ReportContentFooter">
                                <input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'> <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                                    <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" maxlength="3" style="width:25px;">
                                    <cfelse>
                                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" range="1,999" message="#message#" maxlength="3" style="width:25px;" >
                                    </cfif>
                                    <input type="hidden" name="submitted" value="1">
                                <cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'>					
                            </div>	  
                        </div>
                    </div>
                </div>
            </cf_report_list_search_area>
        </cf_report_list_search>
    </cfoutput>
</cfform>
<div id="close_period">
     <!--- Excel TableToExcel.convert fonksiyonu ile alındığı için kapatıldı. --->
<!---     <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
        <cfset filename = "#createuuid()#">
        <cfheader name="Expires" value="#Now()#">
        <cfcontent type="application/vnd.msexcel;charset=utf-16">
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
            <cfset type_ = 1>
        <cfelse>
        <cfset type_ = 0>
    </cfif>
     --->
    <cfif isdefined("attributes.submitted")>    
        <cf_report_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                    <th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                    <th><cf_get_lang dictionary_id='40490.Stok Adı'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='40492.Devir Miktar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='40527.Devir Tutar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='40531.Giren Miktar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='40534.Giren Tutar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='39331.Fiyat Farkı'> <cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='39331.Fiyat Farkı'> <cf_get_lang dictionary_id='57673.Tutar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='29588.İthal Mal Girişi'> <cf_get_lang dictionary_id='57673.Tutar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='29588.İthal Mal Girişi'> <cf_get_lang dictionary_id='40023.Ek Maliyet'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='40535.Çıkan Miktar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='40536.Çıkan Tutar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='40270.Kalan Miktar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='40204.Birim Maliyet'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='40203.Toplam Maliyet'></th>
                </tr>
            </thead>
            <cfset SayfaToplam_EkMaliyet_miktar = 0>
            <cfset SayfaToplam_EkMaliyet = 0>
            <cfset SayfaToplam_FiyatFarki_miktar = 0>
            <cfset SayfaToplam_FiyatFarki = 0>
            <cfset SayfaToplam_DevirMiktar = 0>
            <cfset SayfaToplam_DevirTutar = 0>
            <cfset SayfaToplam_GirenMiktar = 0>
            <cfset SayfaToplam_GirenTutar = 0>
            <cfset SayfaToplam_CikanMiktar = 0>
            <cfset SayfaToplam_CikanTutar = 0>
            <cfset SayfaToplam_KalanMiktar = 0>
            <cfset SayfaToplam_BirimMaliyet = 0>
            <cfset SayfaToplam_ToplamMaliyet = 0>
            
            <cfset GenelToplam_EkMaliyet_miktar = 0>
            <cfset GenelToplam_EkMaliyet = 0>
            <cfset GenelToplam_FiyatFarki_miktar = 0>
            <cfset GenelToplam_FiyatFarki = 0>
            <cfset GenelToplam_DevirMiktar = 0>
            <cfset GenelToplam_DevirTutar = 0>
            <cfset GenelToplam_GirenMiktar = 0>
            <cfset GenelToplam_GirenTutar = 0>
            <cfset GenelToplam_CikanMiktar = 0>
            <cfset GenelToplam_CikanTutar = 0>
            <cfset GenelToplam_KalanMiktar = 0>
            <cfset GenelToplam_BirimMaliyet = 0>
            <cfset GenelToplam_ToplamMaliyet = 0>
            
            <cfif Get_Stocks_Info.recordcount>  
                <tbody>
                    <cfoutput query="Get_Stocks_Info" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfset EkMaliyet = 0>
                        <cfset EkMaliyet_miktar = 0>
                        <cfset FiyatFarki = 0>
                        <cfset FiyatFarki_miktar = 0>
                        <cfset Devir_Miktar = 0>
                        <cfset Devir_Tutar = 0>
                        <cfset Giren_Miktar = 0>
                        <cfset Giren_Tutar = 0>
                        <cfset Cikan_Miktar = 0>
                        <cfset Cikan_Tutar = 0>
                        <cfset Kalan_Miktar = 0>
                        <cfset Toplam_Maliyet = 0>
                        <cfset Devir_Miktar = Diff_Stock>
                        <cfif attributes.startdate is '01/01/#session.ep.period_year#'>
                            <cfset Devir_Tutar = Total_Cost_Price>
                        <cfelse>
                            <cfset Devir_Tutar = All_Start_Cost*Devir_Miktar>
                        </cfif>
                        <!--- Islem Tipine Bakilarak Ilgili Belgenin Tutari Alinacak --->
                        <cfif ListLen(Process_Type_List_Ship) or ListLen(Process_Type_List_Fis)>
                            <cfset Giren_Miktar = Giren_Miktar + Stock_In>
                            <cfset Giren_Tutar = Giren_Tutar + (NetTotal)><!--- (Get_Process_Type_Control.Stock_In*Get_Process_Type_Control.NetTotal) --->
                        </cfif>
                        <cfif ListLen(Process_Type_List_Ship_Other) or ListLen(Process_Type_List_Fis_Other) or ListLen(Process_Type_List_Exchange_Other)>
                            <cfset Giren_Miktar = Giren_Miktar + STOCK_IN1>
                            <cfset Giren_Tutar = Giren_Tutar + (STOCK_IN1*All_finish_Cost)>
                        </cfif>
                        <cfset Cikan_Miktar = Stock_Out>
                        <cfset Cikan_Tutar = Cikan_Miktar*All_Finish_Cost>
                        <cfset Cikan_Miktar = Cikan_Miktar+AMOUNT1>
                        <cfset Cikan_Tutar = Cikan_Tutar+NETTOTAL1>
                            <cfset FiyatFarki = inv_diff_price>
                            <cfset FiyatFarki_miktar = inv_diff_amount>
                            <cfset EkMaliyet = extra_cost_price>
                            <cfset EkMaliyet_miktar = extra_cost_amount>
                        <cfset Kalan_Miktar = Diff_Stock1>
                        <cfset Toplam_Maliyet = Kalan_Miktar*All_Finish_Cost>
                        <tr class="color-row">
                            <td style="mso-number-format:\@;"><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#Get_Stocks_Info.product_id#">#STOCK_CODE#</a></td>
                            <td style="mso-number-format:\@;">#Product_Code_2#</td>
                            <td>#Product_Name#</td>
                            <td style="text-align:right;">#TLFormat(Devir_Miktar,6)#</td>
                            <td style="text-align:right;">#TLFormat(Devir_Tutar,6)#</td>
                            <td style="text-align:right;">#TLFormat(Giren_Miktar,6)#</td>
                            <td style="text-align:right;">#TLFormat(Giren_Tutar,6)#</td>
                            <td style="text-align:right;">#TLFormat(FiyatFarki_miktar,6)#</td>
                            <td style="text-align:right;">#TLFormat(FiyatFarki,6)#</td>
                            <td style="text-align:right;">#TLFormat(EkMaliyet_miktar,6)#</td>
                            <td style="text-align:right;">#TLFormat(EkMaliyet,6)#</td>
                            <td style="text-align:right;">#TLFormat(Cikan_Miktar,6)#</td>
                            <td style="text-align:right;">#TLFormat(Cikan_Tutar,6)#</td>
                            <td style="text-align:right;">#TLFormat(Kalan_Miktar,6)#</td>
                            <td style="text-align:right;">#TLFormat(All_Finish_Cost,6)#</td>
                            <td style="text-align:right;">#TLFormat(Toplam_Maliyet,6)#</td>
                        </tr>
                        <cfset SayfaToplam_EkMaliyet_miktar = SayfaToplam_EkMaliyet_miktar + EkMaliyet_miktar>
                        <cfset SayfaToplam_EkMaliyet = SayfaToplam_EkMaliyet + EkMaliyet>
                        <cfset SayfaToplam_FiyatFarki_miktar = SayfaToplam_FiyatFarki_miktar + FiyatFarki_miktar>
                        <cfset SayfaToplam_FiyatFarki = SayfaToplam_FiyatFarki + FiyatFarki>
                        <cfset SayfaToplam_DevirMiktar = SayfaToplam_DevirMiktar + Devir_Miktar>
                        <cfset SayfaToplam_DevirTutar = SayfaToplam_DevirTutar + Devir_Tutar>
                        <cfset SayfaToplam_GirenMiktar = SayfaToplam_GirenMiktar + Giren_Miktar>
                        <cfset SayfaToplam_GirenTutar = SayfaToplam_GirenTutar + Giren_Tutar>
                        <cfset SayfaToplam_CikanMiktar = SayfaToplam_CikanMiktar + Cikan_Miktar>
                        <cfset SayfaToplam_CikanTutar = SayfaToplam_CikanTutar + Cikan_Tutar>
                        <cfset SayfaToplam_KalanMiktar = SayfaToplam_KalanMiktar + Kalan_Miktar>
                        <cfset SayfaToplam_BirimMaliyet = SayfaToplam_BirimMaliyet + All_Finish_Cost>
                        <cfset SayfaToplam_ToplamMaliyet = SayfaToplam_ToplamMaliyet + Toplam_Maliyet>   
                    </cfoutput>
                </tbody>                   
                <tfoot>
                    <cfoutput>
                        <tr>
                            <td colspan="3" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(SayfaToplam_DevirMiktar,6)#</td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(SayfaToplam_DevirTutar,6)#</td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(SayfaToplam_GirenMiktar,6)#</td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(SayfaToplam_GirenTutar,6)#</td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(SayfaToplam_FiyatFarki_miktar,6)#</td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(SayfaToplam_FiyatFarki,6)#</td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(SayfaToplam_EkMaliyet_miktar,6)#</td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(SayfaToplam_EkMaliyet,6)#</td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(SayfaToplam_CikanMiktar,6)#</td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(SayfaToplam_CikanTutar,6)#</td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(SayfaToplam_KalanMiktar,6)#</td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(SayfaToplam_BirimMaliyet,6)#</td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(SayfaToplam_ToplamMaliyet,6)#</td>
                        </tr>
                    </cfoutput>
                    <cfset rec_num = attributes.maxrows*attributes.page>
                    <cfoutput query="Get_Stocks_Info" startrow="1" maxrows="#rec_num#">
                        <cfset EkMaliyet = 0>
                        <cfset EkMaliyet_miktar = 0>
                        <cfset FiyatFarki = 0>
                        <cfset FiyatFarki_miktar = 0>
                        <cfset Devir_Miktar = 0>
                        <cfset Devir_Tutar = 0>
                        <cfset Giren_Miktar = 0>
                        <cfset Giren_Tutar = 0>
                        <cfset Cikan_Miktar = 0>
                        <cfset Cikan_Tutar = 0>
                        <cfset Kalan_Miktar = 0>
                        <cfset Toplam_Maliyet = 0>
                        <cfset Devir_Miktar = Diff_Stock>
                        <cfif attributes.startdate is '01/01/#session.ep.period_year#'>
                            <cfset Devir_Tutar = Total_Cost_Price>
                        <cfelse>
                            <cfset Devir_Tutar = All_Start_Cost*Devir_Miktar>
                        </cfif>

                        <!--- Islem Tipine Bakilarak Ilgili Belgenin Tutari Alinacak --->
                        <cfif ListLen(Process_Type_List_Ship) or ListLen(Process_Type_List_Fis)>
                            <cfset Giren_Miktar = Giren_Miktar + Stock_In>
                            <cfset Giren_Tutar = Giren_Tutar + (NetTotal)><!--- (Get_Process_Type_Control.Stock_In*Get_Process_Type_Control.NetTotal) --->
                        </cfif>
                        <cfif ListLen(Process_Type_List_Ship_Other) or ListLen(Process_Type_List_Fis_Other) or ListLen(Process_Type_List_Exchange_Other)>
                            <cfset Giren_Miktar = Giren_Miktar + STOCK_IN1>
                            <cfset Giren_Tutar = Giren_Tutar + (STOCK_IN1*All_finish_Cost)>
                        </cfif>
                        <cfset Cikan_Miktar = Stock_Out>
                        <cfset Cikan_Tutar = Cikan_Miktar*All_Finish_Cost>
                        <cfset Cikan_Miktar = Cikan_Miktar+AMOUNT1>
                        <cfset Cikan_Tutar = Cikan_Tutar+NETTOTAL1>
                        <cfset FiyatFarki = inv_diff_price>
                        <cfset FiyatFarki_miktar = inv_diff_amount>
                        <cfset EkMaliyet = extra_cost_price>
                        <cfset EkMaliyet_miktar = extra_cost_amount>
                        <cfset Kalan_Miktar = Diff_Stock1>
                        <cfset Toplam_Maliyet = Kalan_Miktar*All_Finish_Cost>
                        <cfset GenelToplam_EkMaliyet_miktar = GenelToplam_EkMaliyet_miktar + EkMaliyet_miktar>
                        <cfset GenelToplam_EkMaliyet = GenelToplam_EkMaliyet + EkMaliyet>
                        <cfset GenelToplam_FiyatFarki_miktar = GenelToplam_FiyatFarki_miktar + FiyatFarki_miktar>
                        <cfset GenelToplam_FiyatFarki = GenelToplam_FiyatFarki + FiyatFarki>
                        <cfset GenelToplam_DevirMiktar = GenelToplam_DevirMiktar + Devir_Miktar>
                        <cfset GenelToplam_DevirTutar = GenelToplam_DevirTutar + Devir_Tutar>
                        <cfset GenelToplam_GirenMiktar = GenelToplam_GirenMiktar + Giren_Miktar>
                        <cfset GenelToplam_GirenTutar =GenelToplam_GirenTutar + Giren_Tutar>
                        <cfset GenelToplam_CikanMiktar = GenelToplam_CikanMiktar + Cikan_Miktar>
                        <cfset GenelToplam_CikanTutar = GenelToplam_CikanTutar + Cikan_Tutar>
                        <cfset GenelToplam_KalanMiktar = GenelToplam_KalanMiktar + Kalan_Miktar>
                        <cfset GenelToplam_BirimMaliyet = GenelToplam_BirimMaliyet + All_Finish_Cost>
                        <cfset GenelToplam_ToplamMaliyet = GenelToplam_ToplamMaliyet + Toplam_Maliyet>  
                    </cfoutput>
                    <cfoutput>
                        <tr class="color-row">
                            <td colspan="3" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
                            <td style="text-align:right;">#TLFormat(GenelToplam_DevirMiktar,6)#</td>
                            <td style="text-align:right;">#TLFormat(GenelToplam_DevirTutar,6)#</td>
                            <td style="text-align:right;">#TLFormat(GenelToplam_GirenMiktar,6)#</td>
                            <td style="text-align:right;">#TLFormat(GenelToplam_GirenTutar,6)#</td>
                            <td style="text-align:right;">#TLFormat(GenelToplam_FiyatFarki_miktar,6)#</td>
                            <td style="text-align:right;">#TLFormat(GenelToplam_FiyatFarki,6)#</td>
                            <td style="text-align:right;">#TLFormat(GenelToplam_EkMaliyet_miktar,6)#</td>
                            <td style="text-align:right;">#TLFormat(GenelToplam_EkMaliyet,6)#</td>
                            <td style="text-align:right;">#TLFormat(GenelToplam_CikanMiktar,6)#</td>
                            <td style="text-align:right;">#TLFormat(GenelToplam_CikanTutar,6)#</td>
                            <td style="text-align:right;">#TLFormat(GenelToplam_KalanMiktar,6)#</td>
                            <td style="text-align:right;">#TLFormat(GenelToplam_BirimMaliyet,6)#</td>
                            <td style="text-align:right;">#TLFormat(GenelToplam_ToplamMaliyet,6)#</td>
                        </tr>
                    </cfoutput>
                </tfoot>
            <cfelse>
                <tbody>
                    <tr>
                    <td colspan="16"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </tbody>
            </cfif>
        </cf_report_list>
    </cfif> 
</div>   
<cfif isdefined("attributes.submitted") and Get_Stocks_Info.RecordCount and (attributes.totalrecords gt attributes.maxrows) and attributes.is_excel neq 1>
	<cfset adres = "#attributes.fuseaction#&submitted=1">
	<cfif Len(attributes.startdate)><cfset adres = adres & "&startdate=#DateFormat(attributes.startdate,dateformat_style)#"></cfif>
	<cfif Len(attributes.finishdate)><cfset adres = adres & "&finishdate=#DateFormat(attributes.finishdate,dateformat_style)#"></cfif>
	<cfif Len(attributes.category)><cfset adres = adres & "&category=#attributes.category#"></cfif>
	<cfif Len(attributes.product_id) and Len(attributes.product_name)><cfset adres = adres & "&product_id=#attributes.product_id#&product_name=#attributes.product_name#"></cfif>
    <cf_paging
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#adres#">
</cfif>
<script>
 <cfif attributes.is_excel eq 1>
    $(function(){TableToExcel.convert(document.getElementById('close_period'));});
</cfif>
	function control()
	{
        if ((document.rapor.startdate.value != '') && (document.rapor.finishdate.value != '') &&
	    !date_check(rapor.startdate,rapor.finishdate,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	    return false;
		if(document.rapor.is_excel.checked==false)
		{
			document.rapor.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
			return true;
		}
        else $('#maxrows').val('<cfoutput>#Get_Stocks_Info.recordcount#</cfoutput>');
		/* else
			document.rapor.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_close_period_inventory_report</cfoutput>"; */
	}
</script>
