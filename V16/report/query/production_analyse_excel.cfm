<cfif len(attributes.start_date2)><cf_date tarih='attributes.start_date2'></cfif>
<cfset file_name_list = "">
<cfif not DirectoryExists("#upload_folder#reserve_files#dir_seperator##session.ep.userid#_production")>
	<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder#reserve_files#dir_seperator##session.ep.userid#_production">
</cfif>
<cfif not DirectoryExists("#upload_folder#reserve_files#dir_seperator##session.ep.userid#_production_zip")>
	<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder#reserve_files#dir_seperator##session.ep.userid#_production_zip">
<cfelse>
	<cfdirectory  action="delete" directory="#upload_folder#reserve_files#dir_seperator##session.ep.userid#_production_zip" recurse="yes">
	<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder#reserve_files#dir_seperator##session.ep.userid#_production_zip">
</cfif>


<cfif listfind(attributes.is_view,2,',')>
    <cfquery name="get_period" datasource="#dsn#">
        SELECT  PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#
    </cfquery>
    <cfset list_year = valuelist(get_period.PERIOD_YEAR)>
    <cfquery name="check_list" datasource="#dsn3#">
        IF EXISTS (SELECT * FROM tempdb.sys.tables where name='####GET_FIS')
        BEGIN
            DROP TABLE ####GET_FIS
        END
    </cfquery>
    <cfquery name="GET_FIS" datasource="#DSN3#">
        SELECT * 
            INTO ####GET_FIS
        FROM
        (
        <cfloop list="#list_year#" index="ind_year" delimiters=",">
            <cfset donem_dsn_alias='#dsn#_#ind_year#_#session.ep.company_id#'>
            SELECT 
                FIS_ID PAPER_ID,
                FIS_NUMBER PAPER_NUMBER,
                PROD_ORDER_NUMBER,
                PROD_ORDER_RESULT_NUMBER,
                FIS_TYPE PAPER_TYPE
            FROM
                #donem_dsn_alias#.STOCK_FIS STOCK_FIS
            WHERE
                FIS_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="110,111,112,113,119" list="yes">) AND
                PROD_ORDER_NUMBER IS NOT NULL
        UNION ALL
            SELECT 
                SHIP_ID,
                SHIP_NUMBER,
                PROD_ORDER_NUMBER,
                PROD_ORDER_RESULT_NUMBER,
                SHIP_TYPE
            FROM
                #donem_dsn_alias#.SHIP SHIP
            WHERE
                SHIP_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="81">  AND
                PROD_ORDER_NUMBER IS NOT NULL
        <cfif listlast(list_year,',') neq ind_year>UNION ALL</cfif>
        </cfloop>
        ) as xxx
    </cfquery>
</cfif>
<cfquery name="check_list" datasource="#dsn3#">
    IF EXISTS (SELECT * FROM tempdb.sys.tables where name='####GET_PRODUCTION_ANALYSE_#session.ep.userid#')
    BEGIN
        DROP TABLE ####GET_PRODUCTION_ANALYSE_#session.ep.userid#
    END
</cfquery>
<cfquery name="GET_PRODUCTION" datasource="#DSN3#" ><!--- KOSULLARA UYAN TUM URETİM SATIRLARI ILE ALINIYOR --->
    SELECT 
        * 
    INTO ####GET_PRODUCTION_ANALYSE_#session.ep.userid#
    FROM    
    (
    SELECT
        PO.P_ORDER_ID,
        PO.QUANTITY,
        PO.STATUS_ID,
        PO.STATUS,
        PO.PROJECT_ID,
        PO.P_ORDER_NO,
        PO.SPEC_MAIN_ID SPECT_MAIN_ID,
        PO.SPECT_VAR_NAME,
        POR.PR_ORDER_ID,
        POR.RESULT_NO,
        POR.START_DATE,
        POR.FINISH_DATE,
        YEAR(POR.FINISH_DATE) PR_YEAR,
        POR.STATION_ID,
        POR.PROD_ORD_RESULT_STAGE,
        POR.POSITION_ID,
        PORR.TYPE,
        PORR.STOCK_ID,
        PORR.PRODUCT_ID,
        PORR.AMOUNT,
         SETUP_UNIT.UNIT,
        EMPLOYEES.EMPLOYEE_NAME +' '+ EMPLOYEES.EMPLOYEE_SURNAME AS EMPLOYEE_NAME,
        datediff(minute,POR.START_DATE,POR.FINISH_DATE) AS PR_MINUTE,
        1 AS SONUC,
        PORR.UNIT_NAME,
        PORR.UNIT_ID,
        PORR.IS_SEVKIYAT,
        PORR.PURCHASE_NET_SYSTEM,
        PORR.PURCHASE_NET_SYSTEM_MONEY,
        PORR.PURCHASE_EXTRA_COST_SYSTEM,
        ISNULL(PORR.STATION_REFLECTION_COST_SYSTEM,0) AS  STATION_REFLECTION_COST_SYSTEM,
        S.PRODUCT_CATID,
        S.PRODUCT_NAME,
        S.PROPERTY,
        S.STOCK_CODE,
        S.PRODUCT_UNIT_ID,
        <cfif (attributes.report_type eq 1 or attributes.report_type eq 2 or attributes.report_type eq 4 or attributes.report_type eq 7 or attributes.report_type eq 9) and xml_show_manufact_code>
            S.MANUFACT_CODE,
        </cfif>
        (SELECT TOP 1 MAIN_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID) MAIN_UNIT_ID,
        (SELECT AVG_COST/60 FROM WORKSTATIONS WHERE STATION_ID = POR.STATION_ID)*datediff(minute,POR.START_DATE,POR.FINISH_DATE) STATION_COST_VALUE
        <cfif listfind(attributes.is_view,2,',')>
            ,XXX.PAPER_ID_110,
            XXX.PAPER_NUMBER_110,
            YYY.PAPER_ID_111,
            YYY.PAPER_NUMBER_111,
            ZZZ.PAPER_ID_112,
            ZZZ.PAPER_NUMBER_112,
            MMM.PAPER_ID_113,
            MMM.PAPER_NUMBER_113,
            NNN.PAPER_ID_81,
            NNN.PAPER_NUMBER_81
        </cfif>
    FROM 
        STOCKS S
        LEFT JOIN #dsn_alias#.SETUP_UNIT ON SETUP_UNIT.UNIT_ID = (SELECT TOP 1 MAIN_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID)
        LEFT JOIN PRODUCT_CAT PC ON PC.PRODUCT_CATID = S.PRODUCT_CATID,
        PRODUCTION_ORDERS PO JOIN 
        PRODUCTION_ORDER_RESULTS POR ON   PO.P_ORDER_ID=POR.P_ORDER_ID
         LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = POR.POSITION_ID
        <cfif listfind(attributes.is_view,2,',')>
            LEFT JOIN
            (
                SELECT 
                    PAPER_ID AS PAPER_ID_110, 
                    PAPER_NUMBER AS PAPER_NUMBER_110,
                    PROD_ORDER_NUMBER,
                    PROD_ORDER_RESULT_NUMBER,
                    PAPER_TYPE
                FROM 
                    ####GET_FIS
                WHERE
                    PAPER_TYPE = 110 OR  PAPER_TYPE = 119    
            ) AS XXX ON XXX.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND XXX.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
             LEFT JOIN
            (
                SELECT 
                    PAPER_ID AS PAPER_ID_111, 
                    PAPER_NUMBER AS PAPER_NUMBER_111,
                    PROD_ORDER_NUMBER,
                    PROD_ORDER_RESULT_NUMBER,
                    PAPER_TYPE
                FROM 
                    ####GET_FIS
                WHERE
                    PAPER_TYPE = 111   
            ) AS YYY ON YYY.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND YYY.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
            LEFT JOIN
            (
                SELECT 
                    PAPER_ID AS PAPER_ID_112, 
                    PAPER_NUMBER AS PAPER_NUMBER_112,
                    PROD_ORDER_NUMBER,
                    PROD_ORDER_RESULT_NUMBER,
                    PAPER_TYPE
                FROM 
                    ####GET_FIS
                WHERE
                    PAPER_TYPE = 112   
            ) AS ZZZ ON ZZZ.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND ZZZ.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
             LEFT JOIN
            (
                SELECT 
                    PAPER_ID AS PAPER_ID_113, 
                    PAPER_NUMBER AS PAPER_NUMBER_113,
                    PROD_ORDER_NUMBER,
                    PROD_ORDER_RESULT_NUMBER,
                    PAPER_TYPE
                FROM 
                    ####GET_FIS
                WHERE
                    PAPER_TYPE = 113   
            ) AS MMM ON MMM.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND MMM.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
            
              LEFT JOIN
            (
                SELECT 
                    PAPER_ID AS PAPER_ID_81, 
                    PAPER_NUMBER AS PAPER_NUMBER_81,
                    PROD_ORDER_NUMBER,
                    PROD_ORDER_RESULT_NUMBER,
                    PAPER_TYPE
                FROM 
                    ####GET_FIS
                WHERE
                    PAPER_TYPE = 81   
            ) AS NNN ON NNN.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND NNN.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
        </cfif>
        ,PRODUCTION_ORDER_RESULTS_ROW PORR
    WHERE
        S.PRODUCT_ID=PORR.PRODUCT_ID
        AND S.STOCK_ID=PORR.STOCK_ID
        AND POR.PR_ORDER_ID=PORR.PR_ORDER_ID
        AND PORR.SPECT_ID IS NULL
        <cfif listfind(attributes.is_view,0,',') and not listfind(attributes.is_view,1,',') and not listfind(attributes.is_view,3,',')>
            AND PORR.TYPE=1
            <cfif len(attributes.product_id) and len(attributes.product_name)>
                AND PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
                <cfif len(attributes.spec_id) and len(attributes.spec_name)>
                    AND PORR.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spec_id#">
                </cfif>
            </cfif>	
        <cfelseif listfind(attributes.is_view,1,',') and not listfind(attributes.is_view,0,',') and not listfind(attributes.is_view,3,',')>
            AND PORR.TYPE=2
            <cfif len(attributes.sarf_product_id) and len(attributes.sarf_product_name)>
                AND PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_product_id#">
                <cfif len(attributes.sarf_spec_id) and len(attributes.sarf_spec_name)>
                    AND PORR.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_spec_id#">
                </cfif>
            </cfif>	
        <cfelseif listfind(attributes.is_view,3,',') and not listfind(attributes.is_view,0,',') and not listfind(attributes.is_view,1,',')>
            AND PORR.TYPE=3
            <cfif len(attributes.fire_product_id) and len(attributes.fire_product_name)>
                AND PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_product_id#">
                <cfif len(attributes.fire_spec_id) and len(attributes.fire_spec_name)>
                    AND PORR.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_spec_id#">
                </cfif>
            </cfif>	
        </cfif>
        <cfif len(attributes.product_id) and len(attributes.product_name)>
            AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">)
            <cfif len(attributes.spec_id) and len(attributes.spec_name)>
                AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spec_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">)
            </cfif>
        </cfif>	
        <cfif len(attributes.sarf_product_id) and len(attributes.sarf_product_name)>
            AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_product_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2">)
            <cfif len(attributes.sarf_spec_id) and len(attributes.sarf_spec_name)>
                AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_spec_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2">)
            </cfif>
            <cfif listfind(attributes.is_view,1,',')>
                AND 
                (
                (PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_product_id#">)
                <cfif listfind(attributes.is_view,0,',')>
                    <cfif len(attributes.product_id) and len(attributes.product_name)>
                        OR (PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">)
                    </cfif>
                </cfif>
                <cfif listfind(attributes.is_view,3,',')>
                    <cfif len(attributes.fire_product_id) and len(attributes.fire_product_name)>
                        OR (PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_product_id#">)
                    </cfif>
                </cfif>
                )
            </cfif>
        </cfif>	
        <cfif len(attributes.fire_product_id) and len(attributes.fire_product_name)>
            AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_product_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="3">)
            <cfif len(attributes.fire_spec_id) and len(attributes.fire_spec_name)>
                AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_spec_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="3">)
            </cfif>
            <cfif listfind(attributes.is_view,3,',')>
                AND 
                (
                (PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_product_id#">)
                <cfif listfind(attributes.is_view,0,',')>
                    <cfif len(attributes.product_id) and len(attributes.product_name)>
                        OR (PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">)
                    </cfif>
                </cfif>
                <cfif listfind(attributes.is_view,1,',')>
                    <cfif len(attributes.sarf_product_id) and len(attributes.sarf_product_name)>
                        OR (PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_product_id#">)
                    </cfif>
                </cfif>
                )
            </cfif>
        </cfif>	
        <cfif len(attributes.product_cat_code) and len(attributes.product_cat)>
           AND PORR.PR_ORDER_ID IN 
                     (
                     SELECT PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW JOIN STOCKS ON STOCKS.STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND PRODUCTION_ORDER_RESULTS_ROW.TYPE = 1 AND STOCKS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_cat_code#.%"> AND PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID = PORR.PR_ORDER_ID
                     )
		
        </cfif>
        <cfif len(attributes.project_id) and len(attributes.project_head)>
            AND PO.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
        </cfif>
        <cfif isdefined('attributes.process') and len(attributes.process)>
            AND POR.PROD_ORD_RESULT_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process#" list="yes">)
        </cfif>
        <cfif len(attributes.start_date1)>
            AND POR.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date1#">
        </cfif>
        <cfif len(attributes.start_date2)>
            AND POR.START_DATE < #DATE_ADD('d',1,attributes.start_date2)#
        </cfif>
        <cfif len(attributes.finish_date1)>
            AND POR.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date1#">
        </cfif>
        <cfif len(attributes.finish_date2)>
            AND POR.FINISH_DATE < #DATE_ADD('d',1,attributes.finish_date2)#
        </cfif>
        <cfif attributes.member_type eq 'partner' and len(attributes.member_name)>
            AND 
            PO.P_ORDER_ID IN (SELECT 
                                    PRODUCTION_ORDER_ID
                                FROM 
                                    ORDERS, 
                                    PRODUCTION_ORDERS_ROW 
                                WHERE 
                                    ORDERS.ORDER_ID=PRODUCTION_ORDERS_ROW.ORDER_ID
                                    AND ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                                )
        <cfelseif attributes.member_type eq 'consumer' and len(attributes.member_name)>
            AND 
            PO.P_ORDER_ID IN (SELECT 
                                    PRODUCTION_ORDER_ID
                                FROM 
                                    ORDERS, 
                                    PRODUCTION_ORDERS_ROW 
                                WHERE 
                                    ORDERS.ORDER_ID=PRODUCTION_ORDERS_ROW.ORDER_ID
                                    AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                                )
        </cfif>
        <cfif isdefined("attributes.station_id_") and len(attributes.station_id_)>
            AND POR.STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.station_id_#" list="yes">)
        </cfif>
        <cfif len(attributes.brand_id) and len(attributes.brand_name)>
            AND S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
        </cfif>
        <cfif attributes.report_type eq 6 or attributes.report_type eq 11>
            AND POR.STATION_ID IS NOT NULL
        <cfelseif attributes.report_type eq 9>
            AND PO.IS_DEMONTAJ = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
        </cfif>
        <cfif len(attributes.stock_fis_status)>
            <cfif attributes.stock_fis_status eq 1>
                AND POR.IS_STOCK_FIS = 1
            <cfelse>
                AND POR.IS_STOCK_FIS = 0
            </cfif>
        </cfif>
    UNION ALL
    SELECT
        PO.P_ORDER_ID,
        PO.QUANTITY,
        PO.STATUS_ID,
        PO.STATUS,
        PO.PROJECT_ID,
        PO.P_ORDER_NO,
        SM.SPECT_MAIN_ID,
        SM.SPECT_VAR_NAME,
        POR.PR_ORDER_ID,
        POR.RESULT_NO,
        POR.START_DATE,
        POR.FINISH_DATE,
        YEAR(POR.FINISH_DATE) PR_YEAR,
        POR.STATION_ID,
        POR.PROD_ORD_RESULT_STAGE,
        POR.POSITION_ID,
        PORR.TYPE,
        PORR.STOCK_ID,
        PORR.PRODUCT_ID,
        PORR.AMOUNT,
         SETUP_UNIT.UNIT,
        EMPLOYEES.EMPLOYEE_NAME +' '+ EMPLOYEES.EMPLOYEE_SURNAME AS EMPLOYEE_NAME,
        datediff(minute,POR.START_DATE,POR.FINISH_DATE) AS PR_MINUTE,
        1 AS SONUC,
        PORR.UNIT_NAME,
        PORR.UNIT_ID,
        PORR.IS_SEVKIYAT,
        PORR.PURCHASE_NET_SYSTEM,
        PORR.PURCHASE_NET_SYSTEM_MONEY,
        PORR.PURCHASE_EXTRA_COST_SYSTEM,
        ISNULL(PORR.STATION_REFLECTION_COST_SYSTEM,0) AS  STATION_REFLECTION_COST_SYSTEM,
        S.PRODUCT_CATID,
        S.PRODUCT_NAME,
        S.PROPERTY,
        S.STOCK_CODE,
        S.PRODUCT_UNIT_ID,
        <cfif (attributes.report_type eq 1 or attributes.report_type eq 2 or attributes.report_type eq 4 or attributes.report_type eq 7 or attributes.report_type eq 9) and xml_show_manufact_code>
            S.MANUFACT_CODE,
        </cfif>
        (SELECT TOP 1 MAIN_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID) MAIN_UNIT_ID,
        (SELECT AVG_COST/60 FROM WORKSTATIONS WHERE STATION_ID = POR.STATION_ID)*datediff(minute,POR.START_DATE,POR.FINISH_DATE) STATION_COST_VALUE
        <cfif listfind(attributes.is_view,2,',')>
            ,XXX.PAPER_ID_110,
            XXX.PAPER_NUMBER_110,
            YYY.PAPER_ID_111,
            YYY.PAPER_NUMBER_111,
            ZZZ.PAPER_ID_112,
            ZZZ.PAPER_NUMBER_112,
            MMM.PAPER_ID_113,
            MMM.PAPER_NUMBER_113,
            NNN.PAPER_ID_81,
            NNN.PAPER_NUMBER_81
        </cfif>
    FROM 
        STOCKS S
        LEFT JOIN #dsn_alias#.SETUP_UNIT ON SETUP_UNIT.UNIT_ID = (SELECT TOP 1 MAIN_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID)
        LEFT JOIN PRODUCT_CAT PC ON PC.PRODUCT_CATID = S.PRODUCT_CATID,
        PRODUCTION_ORDERS PO JOIN
        PRODUCTION_ORDER_RESULTS POR ON PO.P_ORDER_ID=POR.P_ORDER_ID
         LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = POR.POSITION_ID
        <cfif listfind(attributes.is_view,2,',')>
            LEFT JOIN
            (
                SELECT 
                    PAPER_ID AS PAPER_ID_110, 
                    PAPER_NUMBER AS PAPER_NUMBER_110,
                    PROD_ORDER_NUMBER,
                    PROD_ORDER_RESULT_NUMBER,
                    PAPER_TYPE
                FROM 
                    ####GET_FIS
                WHERE
                    PAPER_TYPE = 110 OR  PAPER_TYPE = 119    
            ) AS XXX ON XXX.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND XXX.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
             LEFT JOIN
            (
                SELECT 
                    PAPER_ID AS PAPER_ID_111, 
                    PAPER_NUMBER AS PAPER_NUMBER_111,
                    PROD_ORDER_NUMBER,
                    PROD_ORDER_RESULT_NUMBER,
                    PAPER_TYPE
                FROM 
                    ####GET_FIS
                WHERE
                    PAPER_TYPE = 111   
            ) AS YYY ON YYY.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND YYY.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
            LEFT JOIN
            (
                SELECT 
                    PAPER_ID AS PAPER_ID_112, 
                    PAPER_NUMBER AS PAPER_NUMBER_112,
                    PROD_ORDER_NUMBER,
                    PROD_ORDER_RESULT_NUMBER,
                    PAPER_TYPE
                FROM 
                    ####GET_FIS
                WHERE
                    PAPER_TYPE = 112   
            ) AS ZZZ ON ZZZ.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND ZZZ.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
             LEFT JOIN
            (
                SELECT 
                    PAPER_ID AS PAPER_ID_113, 
                    PAPER_NUMBER AS PAPER_NUMBER_113,
                    PROD_ORDER_NUMBER,
                    PROD_ORDER_RESULT_NUMBER,
                    PAPER_TYPE
                FROM 
                    ####GET_FIS
                WHERE
                    PAPER_TYPE = 113   
            ) AS MMM ON MMM.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND MMM.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
            
              LEFT JOIN
            (
                SELECT 
                    PAPER_ID AS PAPER_ID_81, 
                    PAPER_NUMBER AS PAPER_NUMBER_81,
                    PROD_ORDER_NUMBER,
                    PROD_ORDER_RESULT_NUMBER,
                    PAPER_TYPE
                FROM 
                    ####GET_FIS
                WHERE
                    PAPER_TYPE = 81   
            ) AS NNN ON NNN.PROD_ORDER_NUMBER = PO.P_ORDER_ID AND NNN.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
        </cfif>
        ,PRODUCTION_ORDER_RESULTS_ROW PORR,
        SPECTS SM
    WHERE
        S.PRODUCT_ID=PORR.PRODUCT_ID
        AND S.STOCK_ID=PORR.STOCK_ID
        AND POR.PR_ORDER_ID=PORR.PR_ORDER_ID
        AND SM.SPECT_VAR_ID=PORR.SPECT_ID
        AND PORR.SPECT_ID IS NOT NULL
        <cfif listfind(attributes.is_view,0,',') and not listfind(attributes.is_view,1,',') and not listfind(attributes.is_view,3,',')>
            AND PORR.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            <cfif len(attributes.product_id) and len(attributes.product_name)>
                AND PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
                <cfif len(attributes.spec_id) and len(attributes.spec_name)>
                    AND PORR.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spec_id#">
                </cfif>
            </cfif>	
        <cfelseif listfind(attributes.is_view,1,',') and not listfind(attributes.is_view,0,',') and not listfind(attributes.is_view,3,',')>
            AND PORR.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
            <cfif len(attributes.sarf_product_id) and len(attributes.sarf_product_name)>
                AND PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_product_id#">
                <cfif len(attributes.sarf_spec_id) and len(attributes.sarf_spec_name)>
                    AND PORR.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_spec_id#">
                </cfif>
            </cfif>	
        <cfelseif listfind(attributes.is_view,3,',') and not listfind(attributes.is_view,0,',') and not listfind(attributes.is_view,1,',')>
            AND PORR.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="3">
            <cfif len(attributes.fire_product_id) and len(attributes.fire_product_name)>
                AND PORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_product_id#">
                <cfif len(attributes.fire_spec_id) and len(attributes.fire_spec_name)>
                    AND PORR.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_spec_id#">
                </cfif>
            </cfif>	
        </cfif>
        <cfif len(attributes.product_id) and len(attributes.product_name)>
            AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">)
            <cfif len(attributes.spec_id) and len(attributes.spec_name)>
                AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spec_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">)
            </cfif>
        </cfif>	
        <cfif len(attributes.sarf_product_id) and len(attributes.sarf_product_name)>
            AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_product_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2">)
            <cfif len(attributes.sarf_spec_id) and len(attributes.sarf_spec_name)>
                AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sarf_spec_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2">)
            </cfif>
        </cfif>	
        <cfif len(attributes.fire_product_id) and len(attributes.fire_product_name)>
            AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_product_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="3">)
            <cfif len(attributes.fire_spec_id) and len(attributes.fire_spec_name)>
                AND POR.PR_ORDER_ID IN(SELECT PORR_.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR_ WHERE PORR_.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fire_spec_id#"> AND PORR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="3">)
            </cfif>
        </cfif>	
        <cfif len(attributes.project_id) and len(attributes.project_head)>
            AND PO.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
        </cfif>
      <cfif len(attributes.product_cat_code) and len(attributes.product_cat)>
           AND PORR.PR_ORDER_ID IN 
                     (
                     SELECT PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW JOIN STOCKS ON STOCKS.STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND PRODUCTION_ORDER_RESULTS_ROW.TYPE = 1 AND STOCKS.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_cat_code#.%"> AND PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID = PORR.PR_ORDER_ID
                     )
		
        </cfif>
        <cfif isdefined('attributes.process') and len(attributes.process)>
            AND POR.PROD_ORD_RESULT_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process#" list="yes">)
        </cfif>
        <cfif len(attributes.start_date1)>
            AND POR.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date1#">
        </cfif>
        <cfif len(attributes.start_date2)>
            AND POR.START_DATE < #DATE_ADD('d',1,attributes.start_date2)#
        </cfif>
        <cfif len(attributes.finish_date1)>
            AND POR.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date1#">
        </cfif>
        <cfif len(attributes.finish_date2)>
            AND POR.FINISH_DATE < #DATE_ADD('d',1,attributes.finish_date2)#
        </cfif>
        <cfif attributes.member_type eq 'partner' and len(attributes.member_name)>
            AND 
            PO.P_ORDER_ID IN (SELECT 
                                    PRODUCTION_ORDER_ID
                                FROM 
                                    ORDERS, 
                                    PRODUCTION_ORDERS_ROW 
                                WHERE 
                                    ORDERS.ORDER_ID=PRODUCTION_ORDERS_ROW.ORDER_ID
                                    AND ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                                )
        <cfelseif attributes.member_type eq 'consumer' and len(attributes.member_name)>
            AND 
            PO.P_ORDER_ID IN (SELECT 
                                    PRODUCTION_ORDER_ID
                                FROM 
                                    ORDERS, 
                                    PRODUCTION_ORDERS_ROW 
                                WHERE 
                                    ORDERS.ORDER_ID=PRODUCTION_ORDERS_ROW.ORDER_ID
                                    AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                                )
        </cfif>
        <cfif isdefined("attributes.station_id_") and len(attributes.station_id_)>
            AND POR.STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.station_id_#" list="yes">)
        </cfif>
        <cfif len(attributes.brand_id) and len(attributes.brand_name)>
            AND S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
        </cfif>
        <cfif attributes.report_type eq 6 or attributes.report_type eq 11>
            AND POR.STATION_ID IS NOT NULL
        <cfelseif attributes.report_type eq 9>
            AND PO.IS_DEMONTAJ = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
        </cfif>
        <cfif len(attributes.stock_fis_status)>
            <cfif attributes.stock_fis_status eq 1>
                AND POR.IS_STOCK_FIS = 1
            <cfelse>
                AND POR.IS_STOCK_FIS = 0
            </cfif>
        </cfif>
    ) AS GET_PRODUCTION    
        
    <!---<cfif isdefined('attributes.order_type')>
    ORDER BY
        <cfif attributes.order_type eq 1>
        PO.QUANTITY,
        AMOUNT
        <cfelseif attributes.order_type eq 2>
        PURCHASE_NET_SYSTEM
        <cfelse>
        POR.FINISH_DATE
        </cfif>
    </cfif>--->
</cfquery>
<cfif not listfind(attributes.is_view,2,',')>
<cfquery name="GET_PRODUCTION_1" datasource="#dsn3#">
SELECT 
	ROW_NUMBER() OVER(
    
    ORDER BY 
    <cfif attributes.report_type eq 1>
    	PRODUCT_NAME
    <cfelseif attributes.report_type eq 2>
    	PRODUCT_NAME+'-'+PROPERTY 
    <cfelseif attributes.report_type eq 3>
        PC.PRODUCT_CAT 
    <cfelseif attributes.report_type eq 4>
        SPECT_VAR_NAME,
        UNIT
    <cfelseif attributes.report_type eq 6 or attributes.report_type eq 11>
      	STATION_NAME
	<cfelseif attributes.report_type eq 7>
        PRODUCT_NAME
    <cfelseif attributes.report_type eq 8>
        RESULT_NO
	<cfelseif attributes.report_type eq 9>
        PRODUCT_NAME
    <cfelseif attributes.report_type eq 11>
      	STATION_NAME,PRODUCT_NAME
    <cfelseif attributes.report_type eq 12>
      	EMPLOYEE_NAME,PRODUCT_NAME
    </cfif>
    ) AS NO
    <cfif attributes.report_type eq 1>
        ,PRODUCT_NAME as "Ürün",
        STOCK_CODE as "Stok Kodu",
        <cfif xml_show_manufact_code>
            MANUFACT_CODE as "Üretici Kodu",
        </cfif>
        UNIT_NAME as "Birim"
    <cfelseif attributes.report_type eq 2>
       ,PRODUCT_NAME+'-'+PROPERTY as "Stok"
    <cfelseif attributes.report_type eq 3>
        ,PC.PRODUCT_CAT as "Ürün Kategorisi"
    <cfelseif attributes.report_type eq 4>
        ,SPECT_VAR_NAME as "Spect"
    <cfelseif attributes.report_type eq 6>
      	,STATION_NAME as "İstasyon"
    <cfelseif attributes.report_type eq 7>
    	,PRODUCT_NAME as "Ürün",
        STOCK_CODE as "Stok Kodu",
        <cfif xml_show_manufact_code>
            MANUFACT_CODE as "Üretici Kodu",
        </cfif>
        UNIT_NAME as "Birim"
    <cfelseif attributes.report_type eq 8>
        ,RESULT_NO as "Sonuç"
    <cfelseif attributes.report_type eq 9>
    	,PRODUCT_NAME as "Ürün",
        STOCK_CODE as "Stok Kodu",
        <cfif xml_show_manufact_code>
            MANUFACT_CODE as "Üretici Kodu",
        </cfif>
        UNIT_NAME as "Birim"
    <cfelseif attributes.report_type eq 11>
        ,PRODUCT_NAME as "Ürün"
        ,STOCK_CODE as "Stok Kodu"
        <cfif xml_show_manufact_code>
            ,MANUFACT_CODE as "Üretici Kodu"
        </cfif>
        ,UNIT_NAME as "Birim"
      	,STATION_NAME as "İstasyon"
    <cfelseif attributes.report_type eq 12>
        ,PRODUCT_NAME as "Ürün"
        ,STOCK_CODE as "Stok Kodu"
        <cfif xml_show_manufact_code>
            ,MANUFACT_CODE as "Üretici Kodu"
        </cfif>
        ,UNIT_NAME as "Birim"
      	,EMPLOYEE_NAME as "İşlemi Yapan"
    </cfif>
   	
    <cfif listfind(attributes.is_view,0,',')>
    	,SUM(CASE WHEN TYPE= 1 THEN SONUC ELSE 0 END) AS "Sonuç"
       	<cfif isdefined("attributes.is_order_amount")> ,MAX(GET_PRODUCTION_AMOUNTS.QUANTITY) AS  "Emir" </cfif>
        ,SUM(CASE WHEN TYPE= 1 THEN PR_MINUTE ELSE 0 END) AS "Dakika"
        ,SUM(CASE WHEN TYPE= 1 THEN AMOUNT ELSE 0 END)  as "Miktar"
        ,SUM(CASE WHEN TYPE= 1 THEN PURCHASE_NET_SYSTEM*AMOUNT ELSE 0 END) "Alış Maliyet"
        ,SUM(CASE WHEN TYPE= 1 THEN PURCHASE_EXTRA_COST_SYSTEM*AMOUNT ELSE 0 END) "Alış Ek Maliyet"
        ,SUM(CASE WHEN TYPE= 1 THEN STATION_COST_VALUE*AMOUNT ELSE 0 END) "İstasyon Maliyet"
        ,SUM(CASE WHEN TYPE= 1 THEN STATION_REFLECTION_COST_SYSTEM*AMOUNT ELSE 0 END) "Yansıyan Maliyet"
        ,SUM(CASE WHEN TYPE= 1 THEN PA.QUANTITY ELSE 0 END) TOTAL_QUANTITY
	</cfif>
    <cfif listfind(attributes.is_view,1,',')>
    	,SUM(CASE WHEN TYPE=2 AND IS_SEVKIYAT=0  THEN AMOUNT ELSE 0 END) "Üretim Sarf Miktar"
        ,SUM(CASE WHEN TYPE=2 AND IS_SEVKIYAT=0  THEN PURCHASE_NET_SYSTEM*AMOUNT ELSE 0 END) "Üretim Sarf Maşiyet"
        ,SUM(CASE WHEN TYPE=2 AND IS_SEVKIYAT=0  THEN PURCHASE_EXTRA_COST_SYSTEM*AMOUNT ELSE 0 END) "Üretim Sarf Ek Maliyet"
        ,SUM(CASE WHEN TYPE=2 AND IS_SEVKIYAT=1  THEN AMOUNT ELSE 0 END) "Seviyat Brş. Mik."
        ,SUM(CASE WHEN TYPE=2 AND IS_SEVKIYAT=1  THEN PURCHASE_NET_SYSTEM *AMOUNT ELSE 0 END) as  "Svkt Brls. Malyt"
        ,SUM(CASE WHEN TYPE=2 AND IS_SEVKIYAT=1  THEN PURCHASE_EXTRA_COST_SYSTEM *AMOUNT ELSE 0 END)  as "Sevk.Birl. Ek Maliyet	"
    </cfif>
    <cfif listfind(attributes.is_view,3,',')>
        ,SUM(CASE WHEN TYPE=3 AND IS_SEVKIYAT=0  THEN AMOUNT ELSE 0 END) as    "Üretim Fire Miktar"
        ,SUM(CASE WHEN TYPE=3 AND IS_SEVKIYAT=0  THEN PURCHASE_NET_SYSTEM * AMOUNT  ELSE 0 END) "Üretim Fire Maliyet"
        ,SUM(CASE WHEN TYPE=3 AND IS_SEVKIYAT=0  THEN PURCHASE_EXTRA_COST_SYSTEM * AMOUNT ELSE 0 END)  "Üretim Fire Ek Maliyet"
        ,SUM(CASE WHEN TYPE=3 AND IS_SEVKIYAT=1  THEN AMOUNT ELSE 0 END)  "Fire Svkt Brlş. Mik."
        ,SUM(CASE WHEN TYPE=3 AND IS_SEVKIYAT=1  THEN PURCHASE_NET_SYSTEM * AMOUNT ELSE 0 END) "Fire Svkt Brls. Malyt"
        ,SUM(CASE WHEN TYPE=3 AND IS_SEVKIYAT=1  THEN PURCHASE_EXTRA_COST_SYSTEM * AMOUNT ELSE 0 END) "Fire Sevk.Birl. Ek Maliyet"
    </cfif> 
FROM 
	####GET_PRODUCTION_ANALYSE_#session.ep.userid# AS PA
<cfif attributes.report_type eq 3>
	LEFT JOIN PRODUCT_CAT PC ON PA.PRODUCT_CATID = PC.PRODUCT_CATID
<cfelseif attributes.report_type eq 6 or attributes.report_type eq 11>
	LEFT JOIN WORKSTATIONS ON  PA.STATION_ID = WORKSTATIONS.STATION_ID
</cfif>
<cfif listfind(attributes.is_view,0,',')>
    LEFT JOIN 
        (
            SELECT SUM(QUANTITY) QUANTITY,
                   <cfif (attributes.report_type eq 1)>
                        S.PRODUCT_ID
                   <cfelseif (attributes.report_type eq 2)>
                        PO.STOCK_ID
                   <cfelseif (attributes.report_type eq 3) >
                        S.PRODUCT_CATID
                   <cfelseif (attributes.report_type eq 4) >
                        SM.SPECT_MAIN_ID
                   <cfelseif (attributes.report_type eq 6)>
                        PO.STATION_ID
                   <cfelseif (attributes.report_type eq 7)>
                        S.PRODUCT_ID
                   <cfelseif (attributes.report_type eq 8) >
                        POR.PR_ORDER_ID
                   <cfelseif (attributes.report_type eq 9)>
                        S.PRODUCT_ID
                   <cfelseif (attributes.report_type eq 11) >
                        PO.STATION_ID,S.PRODUCT_ID
                   <cfelseif (attributes.report_type eq 12) >
                        POR.POSITION_ID,S.PRODUCT_ID
                   </cfif>     
            FROM   PRODUCTION_ORDERS PO
                   <cfif listfind('1,3,7,9,11,12',attributes.report_type)>
                        JOIN STOCKS S ON S.STOCK_ID = PO.STOCK_ID 
                        <cfif attributes.report_type eq 12>
                        	JOIN PRODUCTION_ORDER_RESULTS POR ON PO.P_ORDER_ID =POR.P_ORDER_ID
                        </cfif>
                   <cfelseif (attributes.report_type eq 4) >
                        JOIN SPECT_MAIN SM  ON SM.STOCK_ID = PO.STOCK_ID AND SM.SPECT_MAIN_ID = PO.SPEC_MAIN_ID
                   <cfelseif (attributes.report_type eq 8)>
                        JOIN PRODUCTION_ORDER_RESULTS POR ON PO.P_ORDER_ID =POR.P_ORDER_ID
                   </cfif>
            WHERE  IS_STAGE <> -1
            GROUP BY
                <cfif (attributes.report_type eq 1)>
                    S.PRODUCT_ID
                <cfelseif (attributes.report_type eq 2)>
                    PO.STOCK_ID
                <cfelseif (attributes.report_type eq 3) >
                    S.PRODUCT_CATID
                <cfelseif (attributes.report_type eq 4) >
                    SM.SPECT_MAIN_ID
                <cfelseif (attributes.report_type eq 6) >
                    PO.STATION_ID
				<cfelseif (attributes.report_type eq 7)>
                    S.PRODUCT_ID
                <cfelseif (attributes.report_type eq 8) >
                    POR.PR_ORDER_ID
				<cfelseif (attributes.report_type eq 9)>
                    S.PRODUCT_ID
                <cfelseif (attributes.report_type eq 11) >
                    PO.STATION_ID,
                    S.PRODUCT_ID
                <cfelseif (attributes.report_type eq 12) >
                    POR.POSITION_ID,
                    S.PRODUCT_ID
                </cfif>
        ) AS GET_PRODUCTION_AMOUNTS
        ON  
            <cfif (attributes.report_type eq 1)>
                GET_PRODUCTION_AMOUNTS.PRODUCT_ID  = PA.PRODUCT_ID
            <cfelseif (attributes.report_type eq 2)>
                GET_PRODUCTION_AMOUNTS.STOCK_ID = PA.STOCK_ID
            <cfelseif (attributes.report_type eq 3) >
                GET_PRODUCTION_AMOUNTS.PRODUCT_CATID = PA.PRODUCT_CATID
            <cfelseif (attributes.report_type eq 4) >
                GET_PRODUCTION_AMOUNTS.SPECT_MAIN_ID = PA.SPECT_MAIN_ID
            <cfelseif (attributes.report_type eq 6) >
                GET_PRODUCTION_AMOUNTS.STATION_ID = PA.STATION_ID
            <cfelseif attributes.report_type eq 7>
                GET_PRODUCTION_AMOUNTS.PRODUCT_ID  = PA.PRODUCT_ID
            <cfelseif (attributes.report_type eq 8) >
                GET_PRODUCTION_AMOUNTS.PR_ORDER_ID = PA.PR_ORDER_ID
            <cfelseif (attributes.report_type eq 9)>
                GET_PRODUCTION_AMOUNTS.PRODUCT_ID  = PA.PRODUCT_ID
            <cfelseif (attributes.report_type eq 11) >
                GET_PRODUCTION_AMOUNTS.STATION_ID = PA.STATION_ID AND
                GET_PRODUCTION_AMOUNTS.PRODUCT_ID  = PA.PRODUCT_ID
            <cfelseif (attributes.report_type eq 12) >
                GET_PRODUCTION_AMOUNTS.POSITION_ID = PA.POSITION_ID AND
                GET_PRODUCTION_AMOUNTS.PRODUCT_ID  = PA.PRODUCT_ID
            </cfif>
</cfif>        
	GROUP BY 
		<cfif (attributes.report_type eq 1)>
       		PA.PRODUCT_ID,
            PA.PRODUCT_NAME,            
            STOCK_CODE,
            <cfif xml_show_manufact_code>
                MANUFACT_CODE,
            </cfif>
            UNIT_NAME,
            UNIT
        <cfelseif (attributes.report_type eq 2)>
        	PA.STOCK_ID,
            PRODUCT_NAME+'-'+PROPERTY,
            STOCK_CODE,
            UNIT
        <cfelseif (attributes.report_type eq 3) >
            PA.PRODUCT_CATID,
            PC.PRODUCT_CAT
        <cfelseif (attributes.report_type eq 4) >
        	PA.PRODUCT_ID,
        	PA.SPECT_MAIN_ID,
            SPECT_VAR_NAME ,            
            STOCK_CODE,
            UNIT           
        <cfelseif (attributes.report_type eq 6) >
         	PA.STATION_ID,
            STATION_NAME
       	<cfelseif (attributes.report_type eq 7)>
        	PA.PRODUCT_ID,
            PA.PRODUCT_NAME,           
            STOCK_CODE,
            <cfif xml_show_manufact_code>
                MANUFACT_CODE,
            </cfif>
            UNIT_NAME,
            UNIT
        <cfelseif (attributes.report_type eq 8) >
        	PA.P_ORDER_ID,
        	PA.PR_ORDER_ID,
            RESULT_NO  ,
            FINISH_DATE          
       	<cfelseif (attributes.report_type eq 9)> 
        	PA.PRODUCT_ID,
            PA.PRODUCT_NAME,           
            STOCK_CODE,
            <cfif xml_show_manufact_code>
                MANUFACT_CODE,
            </cfif>
            UNIT_NAME,
            UNIT
        <cfelseif (attributes.report_type eq 10) >
        	POR.POSITION_ID,
            EMPLOYEE_NAME
        <cfelseif (attributes.report_type eq 11) >
            STATION_NAME,
            PA.STATION_ID,
            PA.PRODUCT_NAME,
            PA.PRODUCT_ID,
            STOCK_CODE,
            <cfif xml_show_manufact_code>
                MANUFACT_CODE,
            </cfif>
            UNIT_NAME
        <cfelseif (attributes.report_type eq 12) >
            PA.POSITION_ID,
            EMPLOYEE_NAME,
            PA.PRODUCT_NAME,
            PA.PRODUCT_ID,
            STOCK_CODE,
            <cfif xml_show_manufact_code>
                MANUFACT_CODE,
            </cfif>
            UNIT_NAME
        </cfif>   
</cfquery>

<cfspreadsheet action="write"  filename="#upload_folder#reserve_files#dir_seperator##session.ep.userid#_production#dir_seperator#production_#session.ep.userid#_1.xls" QUERY="GET_PRODUCTION_1"  
        sheet=1 sheetname="employee" overwrite=true>
<cfset file_name_list = listappend(file_name_list,'production_#session.ep.userid#_1.xls')>
</cfif>
<cfif listfind(attributes.is_view,2,',')>
	<cfquery name="GET_PRODUCTION_2" datasource="#dsn3#">
    	SELECT 
        	GET_ORDER.ORDER_NUMBER as "Sipariş No",
            P_ORDER_NO as "Emir No",
            RESULT_NO as "Sonuç No",
            GET_ORDER.MEMBER_NAME as "Müşteri",
            STOCK_CODE as "Stok Kod",
            PRODUCT_NAME+'-'+PROPERTY as "Stok",
            CASE WHEN TYPE = 1 THEN SPECT_MAIN_ID ELSE NULL END AS "Spec",
            PROCESS_STAGE.STAGE as "İşlem Kategorisi",
            PAPER_NUMBER_110 as "Üretim Çıkış Fişi",
            PAPER_NUMBER_111 as "Sarf Fişi",
            PAPER_NUMBER_112 as "Fire Fişi",
            PAPER_NUMBER_81 as "Depolararası Sevk"
            <cfif listfind(attributes.is_view,0,',')>
                ,(CASE WHEN TYPE= 1 THEN AMOUNT ELSE 0 END)  as "Sonuç Miktar" 
                ,(CASE WHEN TYPE= 1 THEN round(PURCHASE_NET_SYSTEM,2) ELSE 0 END)  as "Birim Maliyet" 
                ,(CASE WHEN TYPE= 1 THEN round(PURCHASE_EXTRA_COST_SYSTEM*AMOUNT,2) ELSE 0 END) "Ek Maliyet"
                ,(CASE WHEN TYPE= 1 THEN round(PURCHASE_NET_SYSTEM*AMOUNT,2)+round(PURCHASE_EXTRA_COST_SYSTEM*AMOUNT,2) ELSE 0 END) "Toplam Maliyet"               
            </cfif>
            <cfif listfind(attributes.is_view,1,',')>
                ,(CASE WHEN TYPE=2 AND IS_SEVKIYAT=0  THEN AMOUNT ELSE 0 END) "Üretim Sarf Miktar"
                ,(CASE WHEN TYPE=2 AND IS_SEVKIYAT=0  THEN PURCHASE_NET_SYSTEM*AMOUNT ELSE 0 END) "Üretim Sarf Maliyet" 
                ,(CASE WHEN TYPE=2 AND IS_SEVKIYAT=0  THEN PURCHASE_EXTRA_COST_SYSTEM*AMOUNT ELSE 0 END) "Üretim Sarf Ek Maliyet"
                ,(CASE WHEN TYPE=2 AND IS_SEVKIYAT=1  THEN AMOUNT ELSE 0 END) "Seviyat Brş. Mik."
                ,(CASE WHEN TYPE=2 AND IS_SEVKIYAT=1  THEN PURCHASE_NET_SYSTEM *AMOUNT ELSE 0 END) as  "Svkt Brls. Malyt" 
                ,(CASE WHEN TYPE=2 AND IS_SEVKIYAT=1  THEN PURCHASE_EXTRA_COST_SYSTEM *AMOUNT ELSE 0 END)  as "Sevk.Birl. Ek Maliyet	"
            </cfif>
            <cfif listfind(attributes.is_view,3,',')>
                ,(CASE WHEN TYPE=3 AND IS_SEVKIYAT=0  THEN AMOUNT ELSE 0 END) as    "Üretim Fire Miktar"
                ,(CASE WHEN TYPE=3 AND IS_SEVKIYAT=0  THEN PURCHASE_NET_SYSTEM * AMOUNT  ELSE 0 END) "Üretim Fire Maliyet"
                ,(CASE WHEN TYPE=3 AND IS_SEVKIYAT=0  THEN PURCHASE_EXTRA_COST_SYSTEM * AMOUNT ELSE 0 END)  "Üretim Fire Ek Maliyet"
                ,(CASE WHEN TYPE=3 AND IS_SEVKIYAT=1  THEN AMOUNT ELSE 0 END)  "Fire Svkt Brlş. Mik."
                ,(CASE WHEN TYPE=3 AND IS_SEVKIYAT=1  THEN PURCHASE_NET_SYSTEM * AMOUNT ELSE 0 END) "Fire Svkt Brls. Malyt"
                ,(CASE WHEN TYPE=3 AND IS_SEVKIYAT=1  THEN PURCHASE_EXTRA_COST_SYSTEM * AMOUNT ELSE 0 END) "Fire Sevk.Birl. Ek Maliyet"
            </cfif>
        FROM 
			####GET_PRODUCTION_ANALYSE_#session.ep.userid# AS PA
    	LEFT JOIN 
        	(
            	SELECT 
                            ORDERS.ORDER_ID,
                            ORDER_NUMBER,
                            COMPANY.NICKNAME MEMBER_NAME,
                            PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
                        FROM 
                            ORDERS,
                            #dsn_alias#.COMPANY COMPANY,
                            PRODUCTION_ORDERS_ROW
                        WHERE 
                            ORDERS.COMPANY_ID=COMPANY.COMPANY_ID
                            <!-----AND PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID IN (#list_p_order_id#)--->
                            AND ORDERS.ORDER_ID=PRODUCTION_ORDERS_ROW.ORDER_ID
                            AND ORDERS.COMPANY_ID IS NOT NULL
                    UNION
                        SELECT 
                            ORDERS.ORDER_ID,
                            ORDER_NUMBER,
                            CONSUMER.CONSUMER_NAME+' '+CONSUMER.CONSUMER_SURNAME MEMBER_NAME,
                            PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
                        FROM 
                            ORDERS,
                            #dsn_alias#.CONSUMER CONSUMER,
                            PRODUCTION_ORDERS_ROW
                        WHERE 
                            ORDERS.CONSUMER_ID=CONSUMER.CONSUMER_ID
                            <!-----AND PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID IN (#list_p_order_id#)--->
                            AND ORDERS.ORDER_ID=PRODUCTION_ORDERS_ROW.ORDER_ID
                            AND ORDERS.CONSUMER_ID IS NOT NULL
            ) AS GET_ORDER
            
          ON  PA.P_ORDER_ID = GET_ORDER.PRODUCTION_ORDER_ID
          LEFT JOIN 
          	(
                SELECT
                    PTR.STAGE,
                    PTR.PROCESS_ROW_ID 
                FROM
                    #dsn_alias#.PROCESS_TYPE_ROWS PTR,
                    #dsn_alias#.PROCESS_TYPE_OUR_COMPANY PTO,
                    #dsn_alias#.PROCESS_TYPE PT
                WHERE
                    PT.IS_ACTIVE = 1 AND
                    PT.PROCESS_ID = PTR.PROCESS_ID AND
                    PT.PROCESS_ID = PTO.PROCESS_ID AND
                    PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                    PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%prod.upd_prod_order_result%">
            )     AS PROCESS_STAGE 
            ON  PROCESS_STAGE.PROCESS_ROW_ID = PA.PROD_ORD_RESULT_STAGE
     <cfif isdefined('attributes.order_type')>
    ORDER BY
        <cfif attributes.order_type eq 1>
            PA.QUANTITY,
            AMOUNT
        <cfelseif attributes.order_type eq 2>
        	PURCHASE_NET_SYSTEM
        <cfelse>
       	 POR.FINISH_DATE
        </cfif>
     <CFELSE>
            ORDER BY GET_ORDER.ORDER_NUMBER,
           	P_ORDER_NO
    </cfif>
    
    </cfquery>
	<cfspreadsheet action="write"  filename="#upload_folder#reserve_files#dir_seperator##session.ep.userid#_production#dir_seperator#production_#session.ep.userid#_2.xls" QUERY="GET_PRODUCTION_2"  
        sheet=1 sheetname="employee" overwrite=true>
        <cfset file_name_list = listappend(file_name_list,'production_#session.ep.userid#_2.xls')>
</cfif>

<cfset zip_filename = "#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')#_#createuuid()#.zip">

<cfset directory_name = "#upload_folder#reserve_files#dir_seperator##session.ep.userid#_production">
<cfzip file="#upload_folder#reserve_files/#session.ep.userid#_production_zip/#zip_filename#" source="#directory_name#">
<cfloop list="#file_name_list#" index="mmm">
	<cffile action="delete" file="#upload_folder#reserve_files#dir_seperator##session.ep.userid#_production#dir_seperator##mmm#">
</cfloop>

<script type="text/javascript">
	<cfoutput>
		get_wrk_message_div("Excel","Excel","/documents/reserve_files/#session.ep.userid#_production_zip/#zip_filename#") ;
	</cfoutput>
</script>
<cfif len(attributes.start_date2)><cfset attributes.start_date2 =dateformat(attributes.start_date2,dateformat_style)></cfif>
