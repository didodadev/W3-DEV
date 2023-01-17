<cfset list_stock = ''>
<cfquery name="get_order" datasource="#dsn_dev#">
	SELECT * FROM STOCK_COUNT_ORDERS WHERE ORDER_ID = #attributes.order_id#
</cfquery>
<cfset order_id_ = attributes.order_id>

<!--- RECETE UYGULAMALAR --->
<cfquery name="upd_" datasource="#dsn_dev#">
	UPDATE
    	STOCK_COUNT_ORDERS_ROWS
    SET
        STOCK_ID = (SELECT TOP 1 SU2.UPPER_STOCK_ID FROM #DSN1_ALIAS#.STOCK_UPPERS SU2 WHERE SU2.STOCK_ID = STOCK_COUNT_ORDERS_ROWS.STOCK_ID),
        AMOUNT = AMOUNT / (SELECT TOP 1 SU3.MULTIPLIER FROM #DSN1_ALIAS#.STOCK_UPPERS SU3 WHERE SU3.STOCK_ID = STOCK_COUNT_ORDERS_ROWS.STOCK_ID),
        REAL_STOCK_ID = STOCK_ID,
        REAL_STOCK_AMOUNT = AMOUNT
    WHERE
    	ORDER_ID = #ORDER_ID_# AND
        STOCK_ID IN 
        	(
            	SELECT SU.STOCK_ID FROM #DSN1_ALIAS#.STOCK_UPPERS SU
            )
</cfquery>

<cfquery name="upd_2" datasource="#dsn_dev#">
	UPDATE
    	STOCK_COUNT_ORDERS_ROWS
    SET
    	STOCK_NAME = (SELECT S.PROPERTY FROM #DSN1_ALIAS#.STOCKS S WHERE S.STOCK_ID = STOCK_COUNT_ORDERS_ROWS.STOCK_ID)
    WHERE
    	ORDER_ID = #ORDER_ID_#
</cfquery>
<!--- RECETE UYGULAMALAR --->

<!--- duzeltme kayitlarina bakilir --->
<cfquery name="upd_" datasource="#dsn_dev#">
	UPDATE
    	STOCK_COUNT_ORDERS_ROWS
    SET
    	AMOUNT = AMOUNT - ADD_ROW,
        ADD_ROW = NULL        
    WHERE 
        ORDER_ID = #attributes.order_id# AND
        (ADD_ROW IS NOT NULL AND ADD_ROW <> 0)
</cfquery>
<cfquery name="control_" datasource="#dsn_dev#">
	SELECT TOP 1 * FROM STOCK_COUNT_ORDERS_ROWS WHERE ORDER_ID = #ORDER_ID_# AND (ADD_ROW IS NOT NULL AND ADD_ROW <> 0)
</cfquery>
<cfif not control_.recordcount>
    <cfquery name="get_caunt_order" datasource="#dsn_dev#">
    SELECT
        *
    FROM
         (
          SELECT
                SUM(AMOUNT) AS AMOUNT,
                STOCK_ID,
                STOCK_NAME,
                TARIH,
                ISNULL((
                        SELECT
                        	SUM(HAREKET_ALIS-HAREKET_SATIS)
                        FROM
                        	(
                                SELECT
                                    0 AS HAREKET_ALIS,
                                    SUM(SR.STOCK_OUT) AS HAREKET_SATIS
                                FROM
                                    #dsn2_alias#.STOCKS_ROW SR
                                WHERE
                                    SR.PROCESS_TYPE IN (-1003,-1004,-1005) AND
                                    SR.STOCK_ID = T1.STOCK_ID AND
                                    SR.PROCESS_DATE >= #dateadd('d',1,Createodbcdatetime(get_order.order_date))# AND
                                    DATEADD(hh,-2,SR.PROCESS_DATE) <= T1.TARIH AND
                                    SR.STORE = #get_order.DEPARTMENT_ID# AND
                                    SR.STOCK_OUT > 0
                            UNION ALL
                            	SELECT
                                    0 AS HAREKET_ALIS,
                                    SUM(SR.STOCK_OUT) AS HAREKET_SATIS
                                FROM
                                    #dsn2_alias#.STOCKS_ROW SR
                                WHERE
                                    SR.PROCESS_TYPE NOT IN (-1003,-1004,-1005) AND
                                    SR.STOCK_ID = T1.STOCK_ID AND
                                    SR.PROCESS_DATE >= #dateadd('d',1,Createodbcdatetime(get_order.order_date))# AND
                                    SR.PROCESS_DATE <= T1.TARIH AND
                                    SR.STORE = #get_order.DEPARTMENT_ID# AND
                                    SR.STOCK_OUT > 0
                       		UNION ALL
                                SELECT
                                    SUM(SR.STOCK_IN) AS HAREKET_ALIS,
                                    0 AS HAREKET_SATIS
                                FROM
                                    #dsn2_alias#.STOCKS_ROW SR,
                                    #dsn2_alias#.SHIP S
                                WHERE
                                    S.SHIP_ID = SR.UPD_ID AND
                                    SR.PROCESS_TYPE IN (76,81,78) AND
                                    SR.STOCK_ID = T1.STOCK_ID AND
                                    SR.PROCESS_DATE >= #dateadd('d',1,Createodbcdatetime(get_order.order_date))# AND
                                    S.RECORD_DATE <= T1.TARIH AND
                                    SR.STORE = #get_order.DEPARTMENT_ID# AND
                                    SR.STOCK_IN > 0
                           ) C2
                    ),0) AS DEVAM_EDEN_HAREKET
         FROM
                (
                SELECT 
                    SCOR.STOCK_ID, 
                    SCOR.STOCK_NAME,
                    SCOR.RECORD_DATE AS TARIH,
                    SCOR.AMOUNT
                FROM 
                    STOCK_COUNT_ORDERS_ROWS AS SCOR,
                    STOCK_COUNT_ORDERS SCO
                WHERE 
                    SCOR.ORDER_ID = SCO.ORDER_ID AND
                    SCOR.ORDER_ID = #ORDER_ID_# AND 
                    SCOR.IS_UPDATE = 1 AND 
                    SCOR.STOCK_ID IS NOT NULL
                ) T1
         GROUP BY
            STOCK_ID,
            STOCK_NAME,
            TARIH
        ) AS T2
    WHERE
        DEVAM_EDEN_HAREKET <> 0
    ORDER BY   
        AMOUNT DESC
    </cfquery>
        <cfset current_row = 0>        
        <cfoutput query="get_caunt_order">
        <cfset current_row = current_row +1>
            <cfquery name="get_row_id" datasource="#dsn_dev#">
                SELECT TOP 1 ROW_ID FROM STOCK_COUNT_ORDERS_ROWS WHERE STOCK_ID = #STOCK_ID# AND ORDER_ID = #ORDER_ID_# ORDER BY ROW_ID DESC
            </cfquery>
            <CFQUERY name="UPD_" datasource="#dsn_dev#">
                UPDATE
                    STOCK_COUNT_ORDERS_ROWS
                SET
                	AMOUNT_FIRST = AMOUNT,
                    ADD_ROW = #-1 * DEVAM_EDEN_HAREKET#,
                    AMOUNT = AMOUNT - #DEVAM_EDEN_HAREKET#
                WHERE
                    ROW_ID = #get_row_id.ROW_ID#
            </CFQUERY>     
        </cfoutput>
</cfif>
<!--- duzeltme kayitlarina bakilir --->

<cfquery name="get_order_p_cats" datasource="#dsn_dev#">
	SELECT * FROM STOCK_COUNT_ORDERS_PRODUCT_CATS WHERE ORDER_ID = #attributes.order_id#
</cfquery>
<cfquery name="get_row" datasource="#dsn_dev#">
	SELECT STOCK_ID FROM #DSN_DEV_ALIAS#.STOCK_COUNT_ORDERS_STOCKS AS SCOS WHERE SCOS.ORDER_ID = #attributes.order_id#
</cfquery>
<cfif get_row.recordcount gt 0>
	<cfset list_stock = valuelist(get_row.stock_id)>
</cfif>


<cfset p_cat_list = "">

<cfif get_order_p_cats.recordcount>

<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
    SELECT 
        PRODUCT_CAT.PRODUCT_CATID, 
        PRODUCT_CAT.HIERARCHY, 
        PRODUCT_CAT.PRODUCT_CAT,
        PRODUCT_CAT.HIERARCHY + ' - ' + PRODUCT_CAT.PRODUCT_CAT AS PRODUCT_CAT_NEW
    FROM 
        PRODUCT_CAT
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<cfset attributes.HIERARCHY1 = "">
<cfset attributes.HIERARCHY2 = "">
<cfset attributes.HIERARCHY3 = "">

<cfoutput query="get_order_p_cats">
	<cfif listlen(product_cat,'.') eq 1>
    	<cfset attributes.HIERARCHY1 = listappend(attributes.HIERARCHY1,product_cat)>
    </cfif>
    <cfif listlen(product_cat,'.') eq 2>
    	<cfset attributes.HIERARCHY2 = listappend(attributes.HIERARCHY2,product_cat)>
    </cfif>
    <cfif listlen(product_cat,'.') eq 3>
    	<cfset attributes.HIERARCHY3 = listappend(attributes.HIERARCHY3,product_cat)>
    </cfif>
</cfoutput>

    <cfquery name="get_alt_groups" dbtype="query">
        SELECT
            *
        FROM
            GET_PRODUCT_CAT
        WHERE
        <cfif isdefined("attributes.HIERARCHY1") and len(attributes.HIERARCHY1)>
            (
                <cfset count_ = 0>
                <cfloop list="#attributes.HIERARCHY1#" index="ccc">
                    <cfset count_ = count_ + 1>
                    HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                    <cfif count_ Neq listlen(attributes.HIERARCHY1)>
                        OR
                    </cfif>
                </cfloop>
            )
            AND
        </cfif>
        
        <cfif isdefined("attributes.HIERARCHY2") and len(attributes.HIERARCHY2)>
            (
                <cfset count_ = 0>
                <cfloop list="#attributes.HIERARCHY2#" index="ccc">
                    <cfset count_ = count_ + 1>
                    HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                    <cfif count_ Neq listlen(attributes.HIERARCHY2)>
                        OR
                    </cfif>
                </cfloop>
            )
            AND
        </cfif>
        
        <cfif isdefined("attributes.HIERARCHY3") and len(attributes.HIERARCHY3)>
            (
                <cfset count_ = 0>
                <cfloop list="#attributes.HIERARCHY3#" index="ccc">
                    <cfset count_ = count_ + 1>
                    HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#">
                    <cfif count_ Neq listlen(attributes.HIERARCHY3)>
                        OR
                    </cfif>
                </cfloop>
            )
            AND
        </cfif>
        PRODUCT_CATID IS NOT NULL AND
        HIERARCHY LIKE '%.%.%'
    </cfquery>
    <cfif get_alt_groups.recordcount>
        <cfset p_cat_list = valuelist(get_alt_groups.PRODUCT_CATID)>
        <cfquery name="get_stocks" datasource="#DSN2#">
            SELECT
                S.STOCK_ID
            FROM 
                #dsn3_alias#.STOCKS S,
                #dsn1_alias#.PRODUCT_CAT PC
            WHERE	
                S.PRODUCT_STATUS = 1 AND
                S.STOCK_STATUS = 1 AND
                S.PRODUCT_CATID = PC.PRODUCT_CATID AND
                PC.PRODUCT_CATID IN (#p_cat_list#)
        </cfquery>
        <cfif get_stocks.recordcount>
        	<cfset list_stock = listappend(list_stock,valuelist(get_stocks.stock_id))>
        </cfif>
    </cfif>
</cfif>


<cfquery name="get_counts1" datasource="#DSN2#">
    SELECT
        STOCK_ID,
        PRODUCT_ID,
        <cfif get_order.order_type eq 1> 
        	CASE WHEN TOTAL_COUNT_AMOUNT_SON > -1 THEN TOTAL_COUNT_AMOUNT_SON ELSE TOTAL_COUNT_AMOUNT1 END AS TOTAL_COUNT_AMOUNT,
        <cfelse>
        	TOTAL_COUNT_AMOUNT1 AS TOTAL_COUNT_AMOUNT,
        </cfif>
        ISNULL((SELECT SUM(STOCK_IN - STOCK_OUT) AS REAL_STOCK FROM STOCKS_ROW AS SR WHERE SR.STOCK_ID = T1.STOCK_ID AND SR.STORE = #attributes.department_id# AND SR.PROCESS_DATE < #dateadd('d',1,createodbcdatetime(get_order.order_date))#),0)  AS TOPLAM_STOCK
    FROM
        (    
            SELECT
                S.STOCK_ID,
                S.PRODUCT_ID,
                <cfif get_order.order_type eq 1>
                	ISNULL(
                	(
                    	SELECT 
                        	SUM(AMOUNT) 
                        FROM
                        	#dsn_dev_alias#.STOCK_COUNT_ORDERS_ROWS SCOR2,
                			#dsn_dev_alias#.STOCK_COUNT_ORDERS SCO2
                        WHERE
                        	SCO2.ORDER_ID = SCOR2.ORDER_ID AND
                            SCO2.MAIN_ORDER_ID = #attributes.order_id# AND
                            SCO2.COUNT_TYPE = 3 AND
                            SCOR2.STOCK_ID = S.STOCK_ID
                   ),-1) AS TOTAL_COUNT_AMOUNT_SON,
                </cfif>
                SUM(AMOUNT) TOTAL_COUNT_AMOUNT1
            FROM
                #dsn1_alias#.STOCKS S,
                #dsn_dev_alias#.STOCK_COUNT_ORDERS_ROWS SCOR,
                #dsn_dev_alias#.STOCK_COUNT_ORDERS SCO
            WHERE
                SCO.ORDER_ID = #attributes.order_id# AND 
                SCO.COUNT_TYPE = 1 AND
                SCO.ORDER_ID = SCOR.ORDER_ID AND
                S.STOCK_ID = SCOR.STOCK_ID
                <cfif listlen(list_stock)>
                    AND S.STOCK_ID IN (#list_stock#)
                </cfif>
            GROUP BY
                S.STOCK_ID,
                S.PRODUCT_ID
        ) T1
</cfquery>

<cfif attributes.type eq 1>
	<cfquery name="get_counts2" datasource="#DSN2#">
    	SELECT
        	S.STOCK_ID,
            S.PRODUCT_ID,
            0 AS TOTAL_COUNT_AMOUNT,
        	ISNULL((SELECT SUM(STOCK_IN - STOCK_OUT) AS REAL_STOCK FROM STOCKS_ROW AS SR WHERE SR.STOCK_ID = S.STOCK_ID AND SR.STORE = #attributes.department_id# AND SR.PROCESS_DATE  < #dateadd('d',1,createodbcdatetime(get_order.order_date))#),0)  AS TOPLAM_STOCK
        FROM
        	#DSN1_ALIAS#.STOCKS S
        WHERE
        	S.STOCK_ID IS NOT NULL AND
            S.STOCK_ID NOT IN (SELECT SCOR.STOCK_ID FROM #dsn_dev_alias#.STOCK_COUNT_ORDERS_ROWS SCOR WHERE SCOR.ORDER_ID = #attributes.order_id# AND SCOR.STOCK_ID IS NOT NULL) AND
            S.STOCK_ID IN (SELECT SR.STOCK_ID FROM STOCKS_ROW SR WHERE SR.STORE = #attributes.department_id#)
            <cfif listlen(list_stock)>
            	AND S.STOCK_ID IN (#list_stock#)
            </cfif>
    </cfquery>
</cfif>

<cfquery name="get_counts" dbtype="query">
	SELECT * FROM get_counts1
    <cfif attributes.type eq 1>
    UNION
    SELECT * FROM get_counts2
    </cfif>
</cfquery>

<cftransaction>
    <cflock timeout="20">
        <cfquery name="get_table_no" datasource="#dsn2#">
            SELECT STOCK_NUMBER FROM #dsn_dev_alias#.SEARCH_TABLE_NO
        </cfquery>
        <cfset new_number = get_table_no.STOCK_NUMBER + 1>
        <cfquery name="upd_table_no" datasource="#dsn2#">
            UPDATE #dsn_dev_alias#.SEARCH_TABLE_NO SET STOCK_NUMBER = #new_number#
        </cfquery>
    </cflock>
    <cfset attributes.table_code = new_number>
    <cfloop from="1" to="#8-len(new_number)#" index="ccc">
        <cfset attributes.table_code = "0" & attributes.table_code>
    </cfloop>    
    <cfquery name="add_" datasource="#dsn2#" result="max_id">
        INSERT INTO 
            #dsn_dev_alias#.STOCK_MANAGE_TABLES
            (
                TABLE_CODE,
                TABLE_INFO,
                PROCESS_DATE,
                DEPARTMENT_ID,
                LOCATION_ID,
                RECORD_DATE,
                RECORD_EMP,
                ORDER_ID
            )
        VALUES
            (
                '#attributes.table_code#',
                '#dateformat(attributes.order_date,'dd/mm/yyyy')# tarihli #attributes.department_head# Sayım Düzeltme İşlemi',
                '#attributes.order_date#',
                #attributes.department_id#,
                1,
                #now()#,
                #session.ep.userid#,
                #attributes.order_id#
            )
    </cfquery>
    <cfset attributes.table_id = max_id.IDENTITYCOL>
    
    <cfif get_counts.recordcount>
    <cfoutput query="get_counts">
    	<cfset stock_id_ = get_counts.STOCK_ID>
        <cfset product_id_ = get_counts.PRODUCT_ID>
        <cfset stock_count_ = get_counts.TOTAL_COUNT_AMOUNT-get_counts.TOPLAM_STOCK>        
             <cfset tarih_ = attributes.order_date>
             <cfset tarih_ = dateadd('h',23,tarih_)>
             <cfset tarih_ = dateadd('n',59,tarih_)>
             <cfquery name="add_" datasource="#dsn2#">
            	INSERT INTO
                	STOCKS_ROW
                    (
                        STOCK_ID,
                        PRODUCT_ID,
                        UPD_ID,
                        PROCESS_TYPE,
                        STOCK_IN,
                        STOCK_OUT,
                        STORE,
                        STORE_LOCATION,
                        PROCESS_DATE,
                        DELIVER_DATE,
                        WRK_ROW_ID
                    )
                    VALUES
                    (
                        #stock_id_#,
                        #product_id_#,
                        -2,
                        -1002,
                        <cfif stock_count_ gte 0>#stock_count_#<cfelse>0</cfif>,
                        <cfif stock_count_ lt 0>#-1 * stock_count_#<cfelse>0</cfif>,
                        #attributes.department_id#,
                        1,
                        #tarih_#,
                        #tarih_#,
                        '#attributes.table_code#'
                    )   
             </cfquery>
    </cfoutput>
    </cfif>
</cftransaction>

<cfquery name="update_order" datasource="#dsn_dev#">
	UPDATE STOCK_COUNT_ORDERS SET IS_CLOSED = 1,IS_UPDATE = 0 WHERE ORDER_ID = #order_id_#
</cfquery>
<script>
	alert('Sayım Fişi Oluşturuldu!');
	window.opener.location.reload();
	window.close();
</script>
