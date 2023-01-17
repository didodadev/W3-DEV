<cfif isdefined("attributes.start_date") and len(attributes.start_date) and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
</cfif>

<cfif isdefined("attributes.finish_date") and len(attributes.finish_date) and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfset attributes.finish_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
</cfif>

<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>

<cfif datediff("d",bugun_,attributes.finish_date) gte 1>
	<cfset attributes.start_date = attributes.finish_date>
</cfif>

<cfset onceki_fiyat_finish = dateadd("d",-1,attributes.finish_date)>


<cfparam name="price_table_product_list" default="">
<cfparam name="attributes.barcode_list_id" default="">
<cfparam name="attributes.department_id" default="#listfirst(session.ep.user_location,'-')#">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.table_code" default="">
<cfparam name="attributes.price_type_search" default="">
<cfparam name="attributes.label_type_search" default="">
<cffunction name="GetPrinters" returntype="array" output="no">
   <!--- Define local vars --->    
   <cfset var piObj="">
   <!--- Get PrinterInfo object --->
   <cfobject type="java"
        action="create"
        name="piObj"            
        class="coldfusion.print.PrinterInfo">
   <!--- Return printer list --->
   <cfreturn piObj.getPrinters()>
</cffunction>
<cfquery name="get_price_types_all" datasource="#dsn_dev#">
    SELECT
        *
    FROM
        PRICE_TYPES
    ORDER BY
    	IS_STANDART DESC,
    	TYPE_ID ASC
</cfquery>

<cfquery name="get_label_types_all" datasource="#dsn_dev#">
    SELECT
        *
    FROM
        LABEL_TYPES
    ORDER BY
    	TYPE_NAME
</cfquery>

<cfoutput query="get_label_types_all">
	<cfset 'var_list_#type_id#' = type_code>
    <cfset 'yok_list_#type_id#' = type_code_out>
    
    <cfquery name="get_label_price_types" dbtype="query">
    	SELECT TYPE_ID FROM get_price_types_all WHERE LABEL_TYPE_ID = #type_id#
    </cfquery>
    <cfif get_label_price_types.recordcount>
    	<cfset 'price_list_#type_id#' = valuelist(get_label_price_types.TYPE_ID)>
    <cfelse>
    	<cfset 'price_list_#type_id#' = ''>
    </cfif>
</cfoutput>

<cfquery name="get_standart_label_types" dbtype="query">
	SELECT TYPE_ID FROM get_label_types_all WHERE IS_STANDART = 1
</cfquery>
<cfif get_standart_label_types.recordcount>
	<cfset standart_label_types = valuelist(get_standart_label_types.TYPE_ID)>
<cfelse>
	<cfset standart_label_types = ''>
</cfif>

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
        D.DEPARTMENT_ID NOT IN (#merkez_depo_id#,#iade_depo_id#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="get_barcode_lists" datasource="#dsn_dev#">
	SELECT * FROM BARCODE_PRINT_NO
</cfquery>

<cfif isdefined("attributes.form_submitted")>
	<cfif len(attributes.start_clock) and attributes.start_clock neq 0>
    	<cfset saat_ = listfirst(attributes.start_clock,':')>
        <cfset dakika_ = listlast(attributes.start_clock,':')>
		<cfset attributes.rec_date = attributes.start_date>
		<cfset attributes.rec_date = dateadd('h',saat_,attributes.rec_date)>
        <cfset attributes.rec_date = dateadd('n',dakika_,attributes.rec_date)>
        <cfset attributes.rec_date = dateadd('h',-2,attributes.rec_date)>
    </cfif>
    
    <cfquery name="get_price_table_list" datasource="#dsn_dev#" result="aaa">
    SELECT 
        PRODUCT_ID
    FROM
        #DSN_DEV#.PRICE_TABLE
    WHERE
        IS_ACTIVE_S = 1 AND
        (
        STARTDATE BETWEEN #attributes.start_date# AND #attributes.finish_date# OR
        FINISHDATE BETWEEN #attributes.start_date# AND #attributes.finish_date# OR
        FINISHDATE = #attributes.finish_date#
        )
        <cfif isdefined("attributes.rec_date")>
            AND 
            (
            RECORD_DATE >= #attributes.rec_date#
            OR
            STARTDATE >= #attributes.rec_date#
            )
        </cfif>
        	AND
            	ROW_ID NOT IN (SELECT ROW_ID FROM PRICE_TABLE_DEPARTMENTS)
    </cfquery>
    
    <cfif get_price_table_list.recordcount>
    	<cfset price_table_product_list = valuelist(get_price_table_list.PRODUCT_ID)>
    </cfif>
    
    <cfquery name="get_price_std_table_list" datasource="#dsn_dev#">
    SELECT 
        PRODUCT_ID
    FROM
        #DSN_DEV#.PRICE_TABLE_STANDART
    WHERE
        IS_ACTIVE_S = 1 AND
        (
        STANDART_S_STARTDATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
        )
        <cfif isdefined("attributes.rec_date")>
            AND 
            (
            RECORD_DATE >= #attributes.rec_date#
            OR
            STANDART_S_STARTDATE >= #attributes.rec_date#
            )
        </cfif>
    </cfquery>
    <cfif get_price_std_table_list.recordcount>
		<cfset price_table_product_list = listappend(price_table_product_list,valuelist(get_price_std_table_list.PRODUCT_ID))>
    </cfif>
    
    <cfif len(attributes.department_id)>
        <cfquery name="get_price_table_list_dept" datasource="#dsn_dev#">
        SELECT 
            PRODUCT_ID
        FROM
            #DSN_DEV#.PRICE_TABLE PT,
            PRICE_TABLE_DEPARTMENTS PTD
        WHERE
            PT.ROW_ID = PTD.ROW_ID AND
            PTD.DEPARTMENT_ID = #attributes.department_id# AND 
            PT.IS_ACTIVE_S = 1 AND
            (
            PT.STARTDATE BETWEEN #attributes.start_date# AND #attributes.finish_date# OR
            PT.FINISHDATE BETWEEN #attributes.start_date# AND #attributes.finish_date# OR
            PT.FINISHDATE = #attributes.finish_date#
            )
            <cfif isdefined("attributes.rec_date")>
                AND 
                (
                PT.RECORD_DATE >= #attributes.rec_date#
                OR
                PT.STARTDATE >= #attributes.rec_date#
                )
            </cfif>
        </cfquery>
        <cfif get_price_table_list_dept.recordcount>
			<cfset price_table_product_list = listappend(price_table_product_list,valuelist(get_price_table_list_dept.PRODUCT_ID))>
        </cfif>
    </cfif>
    
	<cfquery name="get_etikets1" datasource="#DSN1#" result="my_result">
    SELECT DISTINCT
    	*
    FROM
    	(
        SELECT
        	 <cfif len(attributes.barcode_list_id)>
            	ISNULL((SELECT TOP 1 BPL.AMOUNT FROM #DSN_DEV#.BARCODE_PRINT_LIST BPL WHERE BPL.PRINT_NO = '#attributes.barcode_list_id#' AND SB.BARCODE = BPL.BARCODE),1) AS PRINT_COUNT,
                ISNULL((SELECT TOP 1 BPL.TABLE_ID FROM #DSN_DEV#.BARCODE_PRINT_LIST BPL WHERE BPL.PRINT_NO = '#attributes.barcode_list_id#' AND SB.BARCODE = BPL.BARCODE),0) AS ROW_NUMBER,
            <cfelse>
            	NULL AS PRINT_COUNT,
                0 AS ROW_NUMBER,
            </cfif>
            ISNULL(( 
                SELECT TOP 1 
                    PT1.READ_FIRST_SATIS_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE_STANDART PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STANDART_S_STARTDATE < #attributes.finish_date# AND
                    PT1.PRODUCT_ID = P.PRODUCT_ID
                ORDER BY
                    PT1.STANDART_S_STARTDATE DESC,
					PT1.ROW_ID DESC
            ),PRICE_KDV) AS ONCEKI_STANDART_FIYAT,
            ( 
                SELECT TOP 1 
                    PT1.STANDART_S_STARTDATE
                FROM
                    #DSN_DEV#.PRICE_TABLE_STANDART PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STANDART_S_STARTDATE <= #attributes.finish_date# AND
                    PT1.PRODUCT_ID = P.PRODUCT_ID
                ORDER BY
                    PT1.STANDART_S_STARTDATE DESC,
					PT1.ROW_ID DESC
            ) AS BASLANGIC_TARIH_STANDART_FIYAT,
            ISNULL(( 
                SELECT TOP 1 
                    PT1.READ_FIRST_SATIS_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE_STANDART PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STANDART_S_STARTDATE <= #attributes.finish_date# AND
                    PT1.PRODUCT_ID = P.PRODUCT_ID
                ORDER BY
                    PT1.STANDART_S_STARTDATE DESC,
					PT1.ROW_ID DESC
            ),PRICE_KDV) AS TARIH_STANDART_FIYAT,
             ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STARTDATE <= #onceki_fiyat_finish# AND
                    PT1.FINISHDATE >= #onceki_fiyat_finish#
                    AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                ORDER BY
                    PT1.STARTDATE DESC,<!--- DESC --->
                	PT1.FINISHDATE DESC,
					PT1.ROW_ID DESC
            ),PRICE_KDV) AS ONCEKI_FIYAT,
            ISNULL(( 
                SELECT TOP 1 
                    PT1.ROW_ID
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STARTDATE <= #onceki_fiyat_finish# AND
                    PT1.FINISHDATE >= #onceki_fiyat_finish#
                    AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                ORDER BY
                    PT1.STARTDATE DESC,<!--- DESC --->
                	PT1.FINISHDATE DESC,
					PT1.ROW_ID DESC
            ),PRICE_KDV) AS ONCEKI_FIYAT_ROW_ID,
            <!--- liste fiyati duzenlenecek --->
            ISNULL(( 
                  SELECT TOP 1 NEW_PRICE_KDV FROM
                  (
                        SELECT TOP 1 
                            PT1.NEW_PRICE_KDV,
                            PT1.STARTDATE,
                            PT1.ROW_ID,
                            0 AS TYPE
                        FROM
                            #DSN_DEV#.PRICE_TABLE PT1
                        WHERE
                            PT1.IS_ACTIVE_S = 1 AND
                            PT1.STARTDATE <= #attributes.finish_date# AND 
                            DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                            (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID)) AND
                            PT1.ROW_ID NOT IN (SELECT ROW_ID FROM #DSN_DEV#.PRICE_TABLE_DEPARTMENTS)
                        ORDER BY
                              PT1.STARTDATE DESC,
                              PT1.ROW_ID DESC
                        <cfif len(attributes.department_id)>
                        UNION ALL
                            SELECT TOP 1 
                                PT1.NEW_PRICE_KDV,
                                PT1.STARTDATE,
                            	PT1.ROW_ID,
                                1 AS TYPE
                            FROM
                                #DSN_DEV#.PRICE_TABLE PT1,
                                #DSN_DEV#.PRICE_TABLE_DEPARTMENTS PTD1
                            WHERE
                                PT1.ROW_ID = PTD1.ROW_ID AND 
                                PTD1.DEPARTMENT_ID = #attributes.department_id# AND
                                PT1.IS_ACTIVE_S = 1 AND
                                PT1.STARTDATE <= #attributes.finish_date# AND 
                                DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                                (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                           	ORDER BY
                              PT1.STARTDATE DESC,
                              PT1.ROW_ID DESC
                        </cfif>
                  ) T1
                  ORDER BY
                  	  T1.TYPE DESC,
                      T1.STARTDATE DESC,
                      T1.ROW_ID DESC
            ),'-1') AS LISTE_FIYATI,
            ISNULL(( 
                SELECT TOP 1 ROW_ID FROM
                  (
                        SELECT TOP 1 
                            PT1.ROW_ID,
                            PT1.STARTDATE,
                            0 AS TYPE
                        FROM
                            #DSN_DEV#.PRICE_TABLE PT1
                        WHERE
                            PT1.IS_ACTIVE_S = 1 AND
                            PT1.STARTDATE <= #attributes.finish_date# AND 
                            DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                            (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID)) AND
                            PT1.ROW_ID NOT IN (SELECT ROW_ID FROM #DSN_DEV#.PRICE_TABLE_DEPARTMENTS)
                        ORDER BY
                              PT1.STARTDATE DESC,
                              PT1.ROW_ID DESC
                        <cfif len(attributes.department_id)>
                        UNION ALL
                            SELECT TOP 1 
                                PT1.ROW_ID,
                                PT1.STARTDATE,
                                1 AS TYPE
                            FROM
                                #DSN_DEV#.PRICE_TABLE PT1,
                                #DSN_DEV#.PRICE_TABLE_DEPARTMENTS PTD1
                            WHERE
                                PT1.ROW_ID = PTD1.ROW_ID AND 
                                PTD1.DEPARTMENT_ID = #attributes.department_id# AND
                                PT1.IS_ACTIVE_S = 1 AND
                                PT1.STARTDATE <= #attributes.finish_date# AND 
                                DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                                (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                            ORDER BY
                              PT1.STARTDATE DESC,
                              PT1.ROW_ID DESC
                        </cfif>
                  ) T1
                  ORDER BY
                  	T1.TYPE DESC,
                      T1.STARTDATE DESC,
                      T1.ROW_ID DESC
            ),'-1') AS LISTE_FIYATI_ROW_ID,
            ( 
                SELECT TOP 1 STARTDATE FROM
                  (
                        SELECT TOP 1 
                            PT1.STARTDATE,
                            	PT1.ROW_ID,
                            0 AS TYPE
                        FROM
                            #DSN_DEV#.PRICE_TABLE PT1
                        WHERE
                            PT1.IS_ACTIVE_S = 1 AND
                            PT1.STARTDATE <= #attributes.finish_date# AND 
                            DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                            (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID)) AND
                            PT1.ROW_ID NOT IN (SELECT ROW_ID FROM #DSN_DEV#.PRICE_TABLE_DEPARTMENTS)
                        ORDER BY
                              PT1.STARTDATE DESC,
                              PT1.ROW_ID DESC
                        <cfif len(attributes.department_id)>
                        UNION ALL
                            SELECT TOP 1 
                                PT1.STARTDATE,
                            	PT1.ROW_ID,
                                1 AS TYPE
                            FROM
                                #DSN_DEV#.PRICE_TABLE PT1,
                                #DSN_DEV#.PRICE_TABLE_DEPARTMENTS PTD1
                            WHERE
                                PT1.ROW_ID = PTD1.ROW_ID AND 
                                PTD1.DEPARTMENT_ID = #attributes.department_id# AND
                                PT1.IS_ACTIVE_S = 1 AND
                                PT1.STARTDATE <= #attributes.finish_date# AND 
                                DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                                (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                            ORDER BY
                              PT1.STARTDATE DESC,
                              PT1.ROW_ID DESC
                        </cfif>
                  ) T1
                  ORDER BY
                  		T1.TYPE DESC,
                      T1.STARTDATE DESC,
                      T1.ROW_ID DESC
            ) AS LISTE_FIYATI_START,
            ( 
                SELECT TOP 1 FINISHDATE FROM
                  (
                        SELECT TOP 1 
                            PT1.FINISHDATE,
                            PT1.STARTDATE,
                            	PT1.ROW_ID,
                            0 AS TYPE
                        FROM
                            #DSN_DEV#.PRICE_TABLE PT1
                        WHERE
                            PT1.IS_ACTIVE_S = 1 AND
                            PT1.STARTDATE <= #attributes.finish_date# AND 
                            DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                            (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID)) AND
                            PT1.ROW_ID NOT IN (SELECT ROW_ID FROM #DSN_DEV#.PRICE_TABLE_DEPARTMENTS)
                        ORDER BY
                              PT1.STARTDATE DESC,
                              PT1.ROW_ID DESC
                        <cfif len(attributes.department_id)>
                        UNION ALL
                            SELECT TOP 1 
                                PT1.FINISHDATE,
                                PT1.STARTDATE,
                            	PT1.ROW_ID,
                                1 AS TYPE
                            FROM
                                #DSN_DEV#.PRICE_TABLE PT1,
                                #DSN_DEV#.PRICE_TABLE_DEPARTMENTS PTD1
                            WHERE
                                PT1.ROW_ID = PTD1.ROW_ID AND 
                                PTD1.DEPARTMENT_ID = #attributes.department_id# AND
                                PT1.IS_ACTIVE_S = 1 AND
                                PT1.STARTDATE <= #attributes.finish_date# AND 
                                DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                                (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                           ORDER BY
                              PT1.STARTDATE DESC,
                              PT1.ROW_ID DESC
                        </cfif>
                  ) T1
                  ORDER BY
                      T1.TYPE DESC,
                      T1.STARTDATE DESC,
                      T1.ROW_ID DESC
            ) AS LISTE_FIYATI_FINISH,
            ( 
                SELECT TOP 1 TYPE_NAME FROM
                  (
                        SELECT TOP 1 
                            PT.TYPE_NAME,
                            PT1.STARTDATE,
                            	PT1.ROW_ID,
                            0 AS TYPE
                        FROM
                            #DSN_DEV#.PRICE_TABLE PT1,
                    		#DSN_DEV#.PRICE_TYPES PT
                        WHERE
                            PT1.PRICE_TYPE = PT.TYPE_ID AND
                            PT1.IS_ACTIVE_S = 1 AND
                            PT1.STARTDATE <= #attributes.finish_date# AND 
                            DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                            (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID)) AND
                            PT1.ROW_ID NOT IN (SELECT ROW_ID FROM #DSN_DEV#.PRICE_TABLE_DEPARTMENTS)
                        ORDER BY
                              PT1.STARTDATE DESC,
                              PT1.ROW_ID DESC
                        <cfif len(attributes.department_id)>
                        UNION ALL
                            SELECT TOP 1 
                                PT.TYPE_NAME,
                                PT1.STARTDATE,
                            	PT1.ROW_ID,
                                1 AS TYPE
                            FROM
                                #DSN_DEV#.PRICE_TABLE PT1,
                                #DSN_DEV#.PRICE_TABLE_DEPARTMENTS PTD1,
                    			#DSN_DEV#.PRICE_TYPES PT
                            WHERE
                                PT1.PRICE_TYPE = PT.TYPE_ID AND
                                PT1.ROW_ID = PTD1.ROW_ID AND 
                                PTD1.DEPARTMENT_ID = #attributes.department_id# AND
                                PT1.IS_ACTIVE_S = 1 AND
                                PT1.STARTDATE <= #attributes.finish_date# AND 
                                DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                                (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                            ORDER BY
                              PT1.STARTDATE DESC,
                              PT1.ROW_ID DESC
                        </cfif>
                  ) T1
                  ORDER BY
                  	T1.TYPE DESC,
                      T1.STARTDATE DESC,
                      T1.ROW_ID DESC
            ) AS LISTE_FIYATI_TIPI,
            ISNULL(( 
               SELECT TOP 1 TYPE_ID FROM
                  (
                        SELECT TOP 1 
                            PT.TYPE_ID,
                            PT1.STARTDATE,
                            	PT1.ROW_ID,
                            0 AS TYPE
                        FROM
                            #DSN_DEV#.PRICE_TABLE PT1,
                    		#DSN_DEV#.PRICE_TYPES PT
                        WHERE
                            PT1.PRICE_TYPE = PT.TYPE_ID AND
                            PT1.IS_ACTIVE_S = 1 AND
                            PT1.STARTDATE <= #attributes.finish_date# AND 
                            DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                            (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID)) AND
                            PT1.ROW_ID NOT IN (SELECT ROW_ID FROM #DSN_DEV#.PRICE_TABLE_DEPARTMENTS)
                        ORDER BY
                              PT1.STARTDATE DESC,
                              PT1.ROW_ID DESC
                        <cfif len(attributes.department_id)>
                        UNION ALL
                            SELECT TOP 1 
                                PT.TYPE_ID,
                                PT1.STARTDATE,
                            	PT1.ROW_ID,
                                1 AS TYPE
                            FROM
                                #DSN_DEV#.PRICE_TABLE PT1,
                                #DSN_DEV#.PRICE_TABLE_DEPARTMENTS PTD1,
                    			#DSN_DEV#.PRICE_TYPES PT
                            WHERE
                                PT1.PRICE_TYPE = PT.TYPE_ID AND
                                PT1.ROW_ID = PTD1.ROW_ID AND 
                                PTD1.DEPARTMENT_ID = #attributes.department_id# AND
                                PT1.IS_ACTIVE_S = 1 AND
                                PT1.STARTDATE <= #attributes.finish_date# AND 
                                DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                                (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                            ORDER BY
                              PT1.STARTDATE DESC,
                              PT1.ROW_ID DESC
                        </cfif>
                  ) T1
                  ORDER BY
                  	T1.TYPE DESC,
                      T1.STARTDATE DESC,
                      T1.ROW_ID DESC
            ),-1) AS LISTE_FIYATI_TIP,
             ( 
                SELECT TOP 1 TABLE_CODE FROM
                  (
                        SELECT TOP 1 
                            PT1.TABLE_CODE,
                            PT1.STARTDATE,
                            	PT1.ROW_ID,
                            0 AS TYPE
                        FROM
                            #DSN_DEV#.PRICE_TABLE PT1
                        WHERE
                            PT1.IS_ACTIVE_S = 1 AND
                            PT1.STARTDATE <= #attributes.finish_date# AND 
                            DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                            (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID)) AND
                            PT1.ROW_ID NOT IN (SELECT ROW_ID FROM #DSN_DEV#.PRICE_TABLE_DEPARTMENTS)
                        ORDER BY
                              PT1.STARTDATE DESC,
                              PT1.ROW_ID DESC
                        <cfif len(attributes.department_id)>
                        UNION ALL
                            SELECT TOP 1 
                                PT1.TABLE_CODE,
                                PT1.STARTDATE,
                            	PT1.ROW_ID,
                                1 AS TYPE
                            FROM
                                #DSN_DEV#.PRICE_TABLE PT1,
                                #DSN_DEV#.PRICE_TABLE_DEPARTMENTS PTD1
                            WHERE
                                PT1.ROW_ID = PTD1.ROW_ID AND 
                                PTD1.DEPARTMENT_ID = #attributes.department_id# AND
                                PT1.IS_ACTIVE_S = 1 AND
                                PT1.STARTDATE <= #attributes.finish_date# AND 
                                DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                                (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                            ORDER BY
                              PT1.STARTDATE DESC,
                              PT1.ROW_ID DESC
                        </cfif>
                  ) T1
                  ORDER BY
                  	T1.TYPE DESC,
                      T1.STARTDATE DESC,
                      T1.ROW_ID DESC
            ) AS TABLO_KODU,            
            <!--- liste fiyati duzenlenecek --->
            (SELECT PB.BRAND_NAME FROM PRODUCT_BRANDS PB WHERE PB.BRAND_ID = P.BRAND_ID) AS BRAND_NAME,
            P.PRODUCT_NAME,
            P.PRODUCT_ID,
            P.PRODUCT_CODE,	
            P.BRAND_ID,		
            P.IS_TERAZI,
            P.RECORD_DATE,
            P.PRODUCT_CATID,
            P.COMPANY_ID,
            P.PRODUCT_CODE_2,
            P.PRODUCT_DETAIL2,
            S.STOCK_ID,
            S.STOCK_CODE_2,
            S.PROPERTY,
            PU.ADD_UNIT,
            PU.UNIT_ID,
            PU.IS_MAIN,
            PU.MULTIPLIER,
            SB.UNIT_ID PRODUCT_UNIT_ID,
            SB.BARCODE BARCOD,
            PS.PRICE_KDV,
            PS.PRICE,
            PS.IS_KDV,
            PS.MONEY
        FROM 
            PRODUCT P, 
            STOCKS S, 
            PRODUCT_UNIT PU,
            STOCKS_BARCODES SB,
            PRICE_STANDART PS
        WHERE
			--S.STOCK_ID = 2390 AND
            P.PRODUCT_ID = S.PRODUCT_ID AND
            P.PRODUCT_ID = PS.PRODUCT_ID AND
            P.PRODUCT_ID = PU.PRODUCT_ID AND
            SB.UNIT_ID = PU.PRODUCT_UNIT_ID AND
            SB.STOCK_ID = S.STOCK_ID AND
            P.PRODUCT_STATUS = 1 AND
            PS.PURCHASESALES = 1 AND
            PS.PRICESTANDART_STATUS = 1 AND
            LEN(SB.BARCODE) > 3 AND
            LEN(SB.BARCODE) < 14 AND
            PS.PRICE < 10000000 AND
            <cfif not len(attributes.barcode_list_id)>
                P.IS_INVENTORY = 1 AND
                P.IS_SALES = 1 AND
            </cfif>
			<cfif len(attributes.barcode_list_id)>
            SB.BARCODE = (SELECT TOP 1 BPL2.BARCODE FROM #DSN_DEV#.BARCODE_PRINT_LIST BPL2 WHERE BPL2.PRINT_NO = '#attributes.barcode_list_id#' AND S.STOCK_ID = BPL2.STOCK_ID) AND
            <cfelse>
            SB.BARCODE = (SELECT TOP 1 SB2.BARCODE FROM STOCKS_BARCODES SB2 WHERE SB2.STOCK_ID = SB.STOCK_ID) AND
            </cfif>
            <cfif not len(attributes.barcode_list_id) and not isdefined("attributes.search_stock_id")>
            (
                <cfif len(price_table_product_list)>
                S.PRODUCT_ID IN (#price_table_product_list#)
                OR
                </cfif>
                	(
                    P.RECORD_DATE BETWEEN #attributes.start_date# AND #dateadd('d',1,attributes.finish_date)#
                    <cfif isdefined("attributes.rec_date")>
                    AND 
                    	P.RECORD_DATE >= #attributes.rec_date#
                    </cfif>
                    )
                OR
                (
                PS.START_DATE >= #attributes.start_date# AND
                PS.START_DATE < #dateadd('d',1,attributes.finish_date)#
                <cfif isdefined("attributes.rec_date")>
                	AND 
                    (
                    PS.RECORD_DATE >= #attributes.rec_date#
                    OR
                    PS.START_DATE >= #attributes.rec_date#
                    )
                </cfif>
                )
            )
            AND
            </cfif>
            (PS.PRICE <> 0 OR PS.PRICE_KDV <> 0)
            <cfif len(attributes.table_code)>
            	AND S.PRODUCT_ID IN (SELECT STP.PRODUCT_ID FROM #DSN_DEV#.SEARCH_TABLES_PRODUCTS STP WHERE STP.TABLE_CODE = '#attributes.table_code#')
            </cfif>
            <cfif len(attributes.barcode_list_id)>
            	AND S.STOCK_ID IN (SELECT BPL.STOCK_ID FROM #DSN_DEV#.BARCODE_PRINT_LIST BPL WHERE BPL.PRINT_NO = '#attributes.barcode_list_id#')
            </cfif>
            <cfif isdefined("attributes.search_stock_id") and len(attributes.search_stock_id)>
            	AND S.STOCK_ID IN (#attributes.search_stock_id#)
            </cfif>
            <cfif len(attributes.keyword)>
            	AND
                (
                P.PRODUCT_NAME + ' ' + S.PROPERTY LIKE '%#attributes.keyword#%'
                    OR
                    (
                        P.PRODUCT_NAME IS NOT NULL
                        <cfloop from="1" to="#listlen(attributes.keyword,' ')#" index="ccc">
                            <cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                                AND
                                (
                                P.PRODUCT_NAME + ' ' + S.PROPERTY LIKE '%#kelime_#%' OR
                                P.PRODUCT_CODE_2 = '#kelime_#' OR
                                S.BARCOD = '#kelime_#' OR    
                                S.STOCK_CODE = '#kelime_#' OR
                                S.STOCK_CODE_2 = '#kelime_#'                                
                                )
                        </cfloop>
                    )
               )
            <cfelse>
                AND P.PRODUCT_NAME LIKE '%#attributes.keyword#%'
            </cfif>
        ) T1
    WHERE
        PRODUCT_NAME IS NOT NULL
        <cfif len(attributes.label_type_search)>
			<cfif not listfind(standart_label_types,attributes.label_type_search)><!--- standart degil fiyat tipinin etiket tanimi var --->
            	<cfset var_list =  evaluate('var_list_#attributes.label_type_search#')>
                <cfset yok_list = evaluate('yok_list_#attributes.label_type_search#')>
                <cfset p_list = evaluate('price_list_#attributes.label_type_search#')>
                <cfif listlen(var_list)>
                    AND
                        (
                            <cfset count_ = 0>
                            <cfloop list="#var_list#" index="deger_">
                                <cfset count_ = count_ + 1>
                                <cfif deger_ is '_'>
                                    <cfset deger_ = '[_]'>
                                </cfif>
                                PRODUCT_NAME LIKE '%#deger_#%'
                                <cfif count_ neq listlen(var_list)>OR</cfif>
                            </cfloop>
                        )
                </cfif>
                <cfif listlen(yok_list)>
                    AND
                        (
                            <cfset count_ = 0>
                            <cfloop list="#yok_list#" index="deger_">
                                <cfif deger_ is '_'>
                                    <cfset deger_ = '[_]'>
                                </cfif>
                                <cfset count_ = count_ + 1>
                                PRODUCT_NAME NOT LIKE '%#deger_#%'
                                <cfif count_ neq listlen(yok_list)>AND</cfif>
                            </cfloop>
                        )
                </cfif> 
                <cfif listlen(p_list)>
                    AND
                        LISTE_FIYATI_TIP IN (#p_list#)
                </cfif>
           <cfelse>
           AND
           (
           		(LISTE_FIYATI_TIP IS NULL OR LISTE_FIYATI_TIP = -1)
                OR
                	(
					<cfset var_list =  evaluate('var_list_#attributes.label_type_search#')>
                    <cfset yok_list = evaluate('yok_list_#attributes.label_type_search#')>
                    <cfset p_list = evaluate('price_list_#attributes.label_type_search#')>
                    <cfif listlen(var_list)>
                            (
                                <cfset count_ = 0>
                                <cfloop list="#var_list#" index="deger_">
                                    <cfset count_ = count_ + 1>
                                    <cfif deger_ is '_'>
                                        <cfset deger_ = '[_]'>
                                    </cfif>
                                    PRODUCT_NAME LIKE '%#deger_#%'
                                    <cfif count_ neq listlen(var_list)>OR</cfif>
                                </cfloop>
                            )
                    </cfif>
                    <cfif listlen(yok_list)>
                        <cfif listlen(var_list)>AND</cfif>
                            (
                                <cfset count_ = 0>
                                <cfloop list="#yok_list#" index="deger_">
                                    <cfif deger_ is '_'>
                                        <cfset deger_ = '[_]'>
                                    </cfif>
                                    <cfset count_ = count_ + 1>
                                    PRODUCT_NAME NOT LIKE '%#deger_#%'
                                    <cfif count_ neq listlen(yok_list)>AND</cfif>
                                </cfloop>
                            )
                    </cfif> 
                    <cfif listlen(p_list)>
                        <cfif listlen(var_list) or listlen(yok_list)>AND</cfif>
                            LISTE_FIYATI_TIP IN (#p_list#)
                    </cfif>
                    )
           )
           </cfif>                     
        </cfif>
        <cfif isdefined("attributes.price_type_search") and len(attributes.price_type_search)>
        	AND LISTE_FIYATI_TIP IN (#attributes.price_type_search#)
        </cfif>
		<cfif not len(attributes.barcode_list_id) and not isdefined("attributes.search_stock_id") and not len(attributes.table_code)>
           AND
            (
            (T1.ONCEKI_FIYAT <> T1.LISTE_FIYATI AND T1.ONCEKI_FIYAT > -1)
            OR
            (T1.ONCEKI_FIYAT = T1.LISTE_FIYATI AND T1.PRICE_KDV = T1.LISTE_FIYATI AND T1.PRICE_KDV <> ONCEKI_STANDART_FIYAT)
            OR
            T1.PRODUCT_CODE LIKE '58.%'
            OR
            (T1.ONCEKI_FIYAT = T1.LISTE_FIYATI AND T1.LISTE_FIYATI_ROW_ID = T1.ONCEKI_FIYAT_ROW_ID)
            )
        </cfif>
    ORDER BY
	<cfif len(attributes.barcode_list_id)>
        ROW_NUMBER ASC
    <cfelse>
    	PRODUCT_NAME ASC
    </cfif>
    </cfquery>
<cfelse>
	<cfset get_etikets1.recordcount = 0>
</cfif>

<cfif get_etikets1.recordcount>
	<cfset list_tipleri = listdeleteduplicates(valuelist(get_etikets1.LISTE_FIYATI_TIP))>
    <cfif list_tipleri eq -1>
    	<cfset list_tipleri = "">
    </cfif>
    
<cfelse>
	<cfset list_tipleri = "">
</cfif>


<cfquery name="get_price_types" dbtype="query">
    SELECT
        *
    FROM
        get_price_types_all
    <cfif listlen(list_tipleri)>
    	WHERE TYPE_ID IN (#list_tipleri#)
    </cfif>
    ORDER BY
    	IS_STANDART DESC,
    	TYPE_ID ASC
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_etikets1.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.branch_id" default="">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form" method="post" action="#request.self#?fuseaction=retail.list_etiket">
            <input type="hidden" name="form_submitted" id="form_submitted" value="">
            <cf_box_search>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                        <cfinput type="text" name="keyword" id="keyword" style="width:90px;" value="#attributes.keyword#" maxlength="500" placeholder="#message#">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='61478.Tablo Kodu'></cfsavecontent>
                        <cfinput type="text" name="table_code" id="table_code" style="width:90px;" value="#attributes.table_code#" maxlength="500" placeholder="#message#">
                    </div>
                </div>
                <div class="form-group">
                    <select name="label_type_search" id="label_type_search">
                        <option value=""><cf_get_lang dictionary_id='61479.Etiket Tipi'></option>
                        <cfoutput query="get_label_types_all">
                            <option value="#type_id#" <cfif attributes.label_type_search eq type_id> selected</cfif>>#type_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group medium">
                    <cf_multiselect_check 
                        query_name="get_price_types"  
                        name="price_type_search"
                        option_text="#getLang('','',61480)#" 
                        width="180"
                        option_name="TYPE_NAME" 
                        option_value="TYPE_ID"
                        value="#attributes.price_type_search#">
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='57509.Liste'></cfsavecontent>
                        <cfinput type="text" name="barcode_list_id" id="barcode_list_id" style="width:90px;" value="" maxlength="8" placeholder="#message#">
                        <span class="input-group-addon icon-ellipsis"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_select_tickets','list');"><img src="/images/plus_thin.gif" /></a></span>
                    </div>
                </div>
                <div class="form-group">
                    <select name="department_id" id="department_id">
                        <option value=""><cf_get_lang dictionary_id='45348.Tüm Depolar'></option>
                        <cfoutput query="get_departments_search">
                            <option value="#department_id#" <cfif attributes.department_id eq department_id> selected</cfif>>#department_head#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"> <cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <select name="start_clock" id="start_clock" style="width:60px;">
                        <option value="0"><cf_get_lang dictionary_id='57491.Saat'></option>
                        <cfloop from="1" to="23" index="i">
                            <cfset saat = '#NumberFormat(i,00)#:00'>
                            <option value="<cfoutput>#saat#</cfoutput>" <cfif isDefined("attributes.start_clock") and attributes.start_clock eq saat>selected</cfif>><cfoutput>#saat#</cfoutput></option>
                            
                            <cfset saat = '#NumberFormat(i,00)#:15'>
                            <option value="<cfoutput>#saat#</cfoutput>" <cfif isDefined("attributes.start_clock") and attributes.start_clock eq saat>selected</cfif>><cfoutput>#saat#</cfoutput></option>
                            
                            <cfset saat = '#NumberFormat(i,00)#:30'>
                            <option value="<cfoutput>#saat#</cfoutput>" <cfif isDefined("attributes.start_clock") and attributes.start_clock eq saat>selected</cfif>><cfoutput>#saat#</cfoutput></option>
                            
                            <cfset saat = '#NumberFormat(i,00)#:45'>
                            <option value="<cfoutput>#saat#</cfoutput>" <cfif isDefined("attributes.start_clock") and attributes.start_clock eq saat>selected</cfif>><cfoutput>#saat#</cfoutput></option>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <select name="price_type">
                        <option value="0" <cfif isdefined("attributes.price_type") and attributes.price_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'></option>
                        <option value="1" <cfif isdefined("attributes.price_type") and attributes.price_type eq 1>selected</cfif>><cf_get_lang dictionary_id='33086.Özel Fiyat'></option>
                        <option value="2" <cfif isdefined("attributes.price_type") and attributes.price_type eq 2>selected</cfif>><cf_get_lang dictionary_id='61481.Genel Fiyat'></option>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" maxlength="3" onKeyUp="isNumber(this)" range="1,250" required="yes" message="#message#" style="width:25px;">
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="kontrol()">
                    
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='30105.Etiketler'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr class="color-header">
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                    <th><cf_get_lang dictionary_id='57633.Barkod'></th>
                    <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                    <th><cf_get_lang dictionary_id='58721.Standart Satış'></th>
                    <th><cf_get_lang dictionary_id='61480.Fiyat Tipi'></th>
                    <th><cf_get_lang dictionary_id='61482.Önceki Fiyat'></th>
                    <th><cf_get_lang dictionary_id='58084.Fiyat'></th>
                    <th><cf_get_lang dictionary_id='58456.Oran'></th>
                    <cfif len(attributes.barcode_list_id) or isdefined("attributes.search_stock_id")>
                        <th class="form-title"><cf_get_lang dictionary_id='51885.Sayı'></th>
                    </cfif>
                    <th><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></th>
                    <cfif get_etikets1.recordcount><th class="form-title"><input type="checkbox" name="is_all_tickets" id="is_all_tickets" value="1" checked="checked" onclick="check_all_special();"/></th></cfif>
                    <th width="20"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.list_etiket&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_etikets1.recordcount>
                    <!-- sil -->
                    <tr class="color-list">
                        <th colspan="12">
                            <table>
                                <tr>
                                    <td>
                                        <cfquery name="GET_DET_FORM" datasource="#DSN#">
                                            SELECT 
                                                SPF.TEMPLATE_FILE,
                                                SPF.FORM_ID,
                                                SPF.IS_DEFAULT,
                                                SPF.NAME,
                                                SPF.PROCESS_TYPE,
                                                SPF.MODULE_ID,
                                                SPFC.PRINT_NAME
                                            FROM 
                                                #dsn3_alias#.SETUP_PRINT_FILES SPF,
                                                SETUP_PRINT_FILES_CATS SPFC,
                                                MODULES MOD
                                            WHERE
                                                SPF.ACTIVE = 1 AND
                                                SPF.MODULE_ID = MOD.MODULE_ID AND
                                                SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND 
                                                SPFC.PRINT_TYPE = 193
                                            ORDER BY
                                                SPF.NAME
                                        </cfquery>
                                        <select name="form_type" id="form_type" style="width:200px">
                                            <option value=""><cf_get_lang dictionary_id='57792.Modül İçi Yazıcı Belgeleri'></option>
                                            <cfoutput query="GET_DET_FORM">
                                                <option value="#form_id#" <cfif (isdefined("attributes.form_type") and attributes.form_type eq form_id) or (not isdefined("attributes.form_type") and IS_DEFAULT eq 1)>selected</cfif>>#name#</option>
                                            </cfoutput>
                                        </select>                            
                                        <select name="print_count" id="print_count">
                                            <cfloop from="1" to="15" index="ccc">
                                            <cfoutput>
                                                <option value="#ccc#">#ccc#</option>
                                            </cfoutput>
                                            </cfloop>
                                        </select>
                                        <cfset printer_names = GetPrinters()>
                                        <cfif session.ep.admin or session.ep.userid eq 173>
                                            <select name="printer_name" id="printer_name">
                                                <cfloop array="#GetPrinters()#" index="printer_name">
                                                    <cfif not printer_name contains 'Microsoft XPS'>
                                                        <cfoutput>
                                                            <option value="#printer_name#">#printer_name#</option>
                                                        </cfoutput>
                                                    </cfif>
                                                </cfloop>
                                            </select>
                                        <cfelse>
                                            <cfset printer_name_ = "">
                                            <cfloop array="#GetPrinters()#" index="printer_name">
                                                <cfif not printer_name contains 'Microsoft XPS' and printer_name contains '#cgi.REMOTE_ADDR#'>
                                                    <cfset printer_name_ = listappend(printer_name_,printer_name)>
                                                </cfif>
                                            </cfloop>
                                            <input type="hidden" name="printer_name" value="<cfoutput>#listfirst(printer_name_)#</cfoutput>"/>
                                        </cfif>
                                   </td>
                                   <td>
                                           <a href="javascript://" onClick="return gonder_print();"><img src="/images/print.gif" title="Yazdır" align="absbottom" border="0"></a>
                                   </td>
                                </tr>
                            </table>
                        </th>
                    </tr>
                    <!-- sil -->
                    </cfif>
                    <cfif get_etikets1.recordcount>
                        <cfset count_ = 0>
                        <cfoutput query="get_etikets1">            
                            <cfif attributes.price_type eq 0 or (attributes.price_type eq 1 and len(LISTE_FIYATI_START)) or (attributes.price_type eq 2 and not len(LISTE_FIYATI_START))>
                            <cfif len(ONCEKI_FIYAT)>
                                <cfif ONCEKI_FIYAT eq PRICE_KDV and ONCEKI_STANDART_FIYAT neq PRICE_KDV>
                                   <cfset onceki_ = ONCEKI_STANDART_FIYAT>
                                <cfelse>
                                   <cfset onceki_ = ONCEKI_FIYAT>
                                </cfif>
                            <cfelse>
                                <cfset onceki_ = PRICE_KDV>
                            </cfif>
                            
                            <cfif len(LISTE_FIYATI) and LISTE_FIYATI gt 0>
                                <cfset new_price = LISTE_FIYATI>
                            <cfelseif TARIH_STANDART_FIYAT neq PRICE_KDV>
                                <cfset new_price = TARIH_STANDART_FIYAT>
                            <cfelse>
                                <cfset new_price = PRICE_KDV>
                            </cfif>
                              
                            <!---<cfif 1 eq 1>  len(attributes.barcode_list_id) or onceki_ neq new_price --->
                            <cfif len(attributes.barcode_list_id) or onceki_ neq new_price or (isdefined("attributes.search_stock_id") and len(attributes.search_stock_id))>
                            <cfset count_ = count_ + 1>                     
                            <tr id="row_#count_#" class="color-row" rel_name="satir_#stock_id#">
                                <td>#count_#</td>
                                <td>#STOCK_CODE_2#</td>
                                <td style="text-align:right;">
                                <cfif fusebox.fuseaction contains 'autoexcelpopuppage_'>
                                    #barcod#
                                <cfelse>
                                       <input type="text" value="#barcod#" name="barcode_#stock_id#" id="barcode_#stock_id#" style="width:100px; text-align:right;" readonly/>
                                </cfif>
                                </td>
                                <td><a href="#request.self#?fuseaction=product.form_upd_product&pid=#product_id#" class="tableyazi" target="_blank"><cfif len(PROPERTY)>#PROPERTY#<cfelse>#product_name#</cfif></a></td>
                                <td style="text-align:right;">
                                <cfif fusebox.fuseaction contains 'autoexcelpopuppage_'>
                                    #tlformat(PRICE_KDV)#
                                <cfelse>
                                    <input type="text" value="#tlformat(PRICE_KDV)#" name="ss_price_#stock_id#" id="ss_price_#stock_id#" style="width:75px; text-align:right;"  onkeyup="FormatCurrency(this,event,4);" onblur="hesapla_oran('#stock_id#');"/>
                                </cfif>
                                </td>
                                <td><cfif len(tablo_kodu)><a href="#request.self#?fuseaction=retail.speed_manage_product_new&table_code=#tablo_kodu#&is_form_submitted=1" class="tableyazi" target="_blank">#LISTE_FIYATI_TIPI#</a></cfif></td>
                                <td style="text-align:right;">
                                    #tlformat(onceki_)#
                                </td>
                                <td style="text-align:right;">
                                    
                                    <cfif fusebox.fuseaction contains 'autoexcelpopuppage_'>
                                        #tlformat(new_price)#
                                    <cfelse>
                                        <input type="text" value="#tlformat(new_price)#" name="new_price_#stock_id#" id="new_price_#stock_id#" style="width:50px; text-align:right;" readonly/>
                                    </cfif>
                                </td>
                                <td style="text-align:right;">
                                <cfif fusebox.fuseaction contains 'autoexcelpopuppage_'>
                                    #wrk_round(100 - (new_price * 100 / PRICE_KDV))#
                                <cfelse>
                                    <input type="text" value="#wrk_round(100 - (new_price * 100 / PRICE_KDV))#" name="change_rate_#stock_id#" id="change_rate_#stock_id#" style="width:50px; text-align:right;" readonly/>
                                </cfif>
                                </td>
                                <cfif len(attributes.barcode_list_id) or isdefined("attributes.search_stock_id")>
                                    <td style="text-align:right;"><input type="text" name="print_count_#stock_id#" id="print_count_#stock_id#" value="#PRINT_COUNT#" style="width:35px;"/></td>
                                </cfif>
                                <td>
                                    <cfif len(LISTE_FIYATI_START)>
                                        #dateformat(LISTE_FIYATI_START,'dd/mm/yyyy')#
                                    </cfif>
                                    -
                                    <cfif len(LISTE_FIYATI_FINISH)>
                                        #dateformat(LISTE_FIYATI_FINISH,'dd/mm/yyyy')#
                                    </cfif>
                                    <textarea name="date_info_#stock_id#" style="display:none;">
                                        <cfif len(LISTE_FIYATI_START)>
                                            #dateformat(LISTE_FIYATI_START,'dd/mm/yyyy')#
                                        </cfif>
                                        -
                                        <cfif len(LISTE_FIYATI_FINISH)>
                                            #dateformat(LISTE_FIYATI_FINISH,'dd/mm/yyyy')#
                                        </cfif>
                                    </textarea>
                                </td>
                                <td>
                                <cfset s_date_info = dateformat(now(),'dd/mm/yyyy')>
                                <cfif len(BASLANGIC_TARIH_STANDART_FIYAT)>
                                    <cfset s_date_info = dateformat(BASLANGIC_TARIH_STANDART_FIYAT,'dd/mm/yyyy')>
                                </cfif>
                                <cfif len(LISTE_FIYATI_START)>
                                    <cfset s_date_info = dateformat(LISTE_FIYATI_START,'dd/mm/yyyy')>
                                </cfif>
                                    <input type="hidden" value="#s_date_info#" name="s_date_info_#stock_id#" id="s_date_info_#stock_id#" style="width:50px; text-align:right;" readonly/>
                                    <input type="checkbox" name="select_stock" id="select_stock" value="#stock_id#" checked="checked"/>
                                </td>
                            </tr>
                            </cfif>
                            </cfif>
                        </cfoutput>
                    <cfelse>
                        <tr class="color-row">
                            <td colspan="12"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                        </tr>
                    </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>

    


<script type="text/javascript">
$("input:text").focus(function() 
	{
		input_ = $(this);
		setTimeout(function ()
		  {
			input_.select();
		  },30);
	}
	);

$("input:text").keydown(function(e)
{
  kod_ = e.keyCode;
	if(kod_ == 40)
	{
	   input_ = $(this);
	   td_ = input_.closest('td');
	   tr_ = td_.closest('tr');
	   myRow = tr_.index();
	   myCol = td_.index();
	   myall = $('#manage_table tr').length;
	   
	   
	   myRow_real = myRow + 1;
	   next_row = myRow + 1;
	   
		if(myRow_real == myall)
		{
			//alert('Zaten En Alttasınız!');
			return false;
		}
		else
		{
			$('#manage_table tr:eq(' + (next_row+1) + ') td:eq(' + myCol + ')').children().focus();
		}
	   
	}
	else if(kod_ == 38)
	{
		input_ = $(this);
	   td_ = input_.closest('td');
	   tr_ = td_.closest('tr');
	   myRow = tr_.index();
	   myCol = td_.index();
	   myall = 0;
	   
	   myRow_real = myRow;
	   
	   next_row = myRow - 1;
	   
		if(myRow_real == myall)
		{
			//alert('Zaten En Üsttesiniz!');
			return false;
		}
		else
		{
			$('#manage_table tr:eq(' + (next_row+1) + ') td:eq(' + myCol + ')').children().focus();
		}
	}
});	

function add_row(sid_,pname_,psales_)
{
	icerik_ = '<div id="selected_product_' + sid_ + '">';
	icerik_ += '<a href="javascript://" onclick="del_row_p(' + sid_ +')">';
	icerik_ += '<img src="/images/delete_list.gif">';
	icerik_ += '</a>';
	icerik_ += '<input type="hidden" name="search_stock_id" value="' + sid_ + '">';
	icerik_ += pname_;
	icerik_ += '</div>';
	
	$('#product_div').append(icerik_);
}

function del_row_p(sid_)
{
	$("#selected_product_" + sid_).remove();	
}

function check_all_special()
{
	<cfif get_etikets1.recordcount>
	if(document.getElementById('is_all_tickets').checked == true)
	{
		<cfif get_etikets1.recordcount eq 1>
			document.add_.select_stock.checked = true;
		<cfelse>
			sayi_ = <cfoutput>#get_etikets1.recordcount#</cfoutput>;
			for (var m=1; m <= sayi_; m++)
			{
				document.add_.select_stock[m-1].checked = true;
			}
		</cfif>
	}
	else
	{
		<cfif get_etikets1.recordcount eq 1>
			document.add_.select_stock.checked = false;
		<cfelse>
			sayi_ = <cfoutput>#get_etikets1.recordcount#</cfoutput>;
			for (var m=1; m <= sayi_; m++)
			{
				document.add_.select_stock[m-1].checked = false;
			}
		</cfif>
	}
	</cfif>
}

function gonder_print()
{
	if(document.add_.form_type.value == '')
	{
		alert('Yazdırma Şekli Seçiniz!');
		return false;	
	}
	windowopen('','page','print_popup_etiket');
	document.add_.target = 'print_popup_etiket';
	add_.submit();
	
	<cfif get_etikets1.recordcount eq 1>
		if(document.add_.select_stock.checked == true)
		{
			rel_ = "rel_name='satir_" + document.add_.select_stock.value + "'";
			col1 = $("#manage_table tr[" + rel_ + "]");
			col1.hide();
			document.add_.select_stock.checked = false;	
		}
	<cfelse>
		sayi_ = <cfoutput>#get_etikets1.recordcount#</cfoutput>;
		for (var m=1; m <= sayi_; m++)
		{
			if(document.add_.select_stock[m-1].checked == true)
			{
				rel_ = "rel_name='satir_" + document.add_.select_stock[m-1].value + "'";
				col1 = $("#manage_table tr[" + rel_ + "]");
				col1.hide();	
				document.add_.select_stock[m-1].checked = false;
			}
		}
	</cfif>
}

function hesapla_oran(stock_id)
{
	np_ = filterNum(document.getElementById('new_price_' + stock_id).value);
	price_kdv_ = document.getElementById('ss_price_' + stock_id).value;	
	
	if(price_kdv_ != '')
		price_kdv_ = filterNum(price_kdv_);
		
	rate_ = wrk_round(100 - (np_ * 100 / price_kdv_));
	
	document.getElementById('change_rate_' + stock_id).value = rate_;
}
function kontrol()
{
	return date_check(document.search_form.start_date,document.search_form.finish_date,"Bitiş Tarihi Başlangıç Tarihinden Küçük!");
}
</script>
<script>
	$('#manage_table tr').click(function() 
	{
	  $( this ).children('td').toggleClass( "highlightrow" );
	});
</script>
