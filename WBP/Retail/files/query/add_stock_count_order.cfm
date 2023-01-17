<cfif len(attributes.excel_file)>
	<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
    <cftry>
        <cffile action = "upload" 
                fileField = "excel_file" 
                destination = "#upload_folder#"
                nameConflict = "MakeUnique"  
                mode="777">
        <cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
        
        <cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">
        
        <cfspreadsheet  
            action="read" 
            src = "#upload_folder##file_name#" 
            query = "get_excel"/> 
        <cffile action="delete" file="#upload_folder##file_name#">
        
        <cfset file_size = cffile.filesize>
        <cfcatch type="Any">
            <script type="text/javascript">
                alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
                history.back();
            </script>
            <cfabort>
        </cfcatch>  
    </cftry>
</cfif>

<cfif not isdefined("attributes.department_id")>
	<cfset attributes.department_id = merkez_depo_id>
</cfif>

<cf_date tarih='attributes.order_date'>

<cftransaction>
    <cfloop list="#attributes.department_id#" index="dept_id_">
        <cfquery name="add_" datasource="#dsn_dev#" result="main_row_query">
            INSERT INTO
                STOCK_COUNT_ORDERS
                (
                ORDER_DETAIL,
                RECORD_EMP,
                RECORD_DATE,
                RECORD_IP,
                ORDER_TYPE,
                MAIN_ORDER_ID,
                COUNT_TYPE,
                DEPARTMENT_ID,
                ORDER_DATE,
                STATUS
                )
                VALUES
                (
                '#attributes.order_detail#',
                #session.ep.userid#,
                #now()#,
                '#cgi.REMOTE_ADDR#',
                #attributes.order_type#,
                NULL,
                1,
                #dept_id_#,
                #attributes.order_date#,
                1
                )
        </cfquery>
        <cfif attributes.order_type eq 0 and isdefined("attributes.hierarchy1") and listlen(attributes.hierarchy1)>
            <cfloop list="#attributes.hierarchy1#" index="p_cat_">
                <cfquery name="add_p_" datasource="#dsn_dev#">
                    INSERT INTO
                        STOCK_COUNT_ORDERS_PRODUCT_CATS
                        (
                        ORDER_ID,
                        PRODUCT_CAT
                        )
                        VALUES
                        (
                        #main_row_query.IDENTITYCOL#,
                        '#p_cat_#'
                        )
                </cfquery>
           </cfloop>
        </cfif>  
        <cfif attributes.order_type eq 0 and isdefined("attributes.hierarchy2") and listlen(attributes.hierarchy2)>
            <cfloop list="#attributes.hierarchy2#" index="p_cat_">
                <cfquery name="add_p_" datasource="#dsn_dev#">
                    INSERT INTO
                        STOCK_COUNT_ORDERS_PRODUCT_CATS
                        (
                        ORDER_ID,
                        PRODUCT_CAT
                        )
                        VALUES
                        (
                        #main_row_query.IDENTITYCOL#,
                        '#p_cat_#'
                        )
                </cfquery>
           </cfloop>
        </cfif>  
        <cfif attributes.order_type eq 0 and isdefined("attributes.hierarchy3") and listlen(attributes.hierarchy3)>
            <cfloop list="#attributes.hierarchy3#" index="p_cat_">
                <cfquery name="add_p_" datasource="#dsn_dev#">
                    INSERT INTO
                        STOCK_COUNT_ORDERS_PRODUCT_CATS
                        (
                        ORDER_ID,
                        PRODUCT_CAT
                        )
                        VALUES
                        (
                        #main_row_query.IDENTITYCOL#,
                        '#p_cat_#'
                        )
                </cfquery>
           </cfloop>
        </cfif>      
        <cfif attributes.order_type eq 0 and isdefined("attributes.search_product_id") and listlen(attributes.search_product_id)>
            <cfloop list="#attributes.search_product_id#" index="p_id_">
                <cfquery name="add_p_" datasource="#dsn_dev#">
                    INSERT INTO
                        STOCK_COUNT_ORDERS_STOCKS
                        (
                        ORDER_ID,
                        STOCK_ID
                        )
                        VALUES
                        (
                        #main_row_query.IDENTITYCOL#,
                        #p_id_#
                        )
                </cfquery>
           </cfloop>
        </cfif>
        <!--- excelden ekleme --->
        <cfif attributes.order_type eq 0 and isdefined("get_excel") and get_excel.recordcount>
            <cfoutput query="get_excel">
                <cfif isnumeric(col_1)>
                    <cfquery name="add_p_" datasource="#dsn_dev#">
                        INSERT INTO
                            STOCK_COUNT_ORDERS_STOCKS
                            (
                            ORDER_ID,
                            STOCK_ID
                            )
                            VALUES
                            (
                            #main_row_query.IDENTITYCOL#,
                            #col_1#
                            )
                    </cfquery>
                </cfif>
           </cfoutput>
        </cfif>
        <!--- excelden ekleme --->
        <cfif attributes.order_type eq 1>
        		<cfquery name="add2_" datasource="#dsn_dev#" result="second_row_query">
                    INSERT INTO
                        STOCK_COUNT_ORDERS
                        (
                        ORDER_DETAIL,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP,
                        ORDER_TYPE,
                        MAIN_ORDER_ID,
                        COUNT_TYPE,
                        DEPARTMENT_ID,
                        ORDER_DATE,
                        STATUS
                        )
                        VALUES
                        (
                        '#attributes.order_detail#',
                        #session.ep.userid#,
                        #now()#,
                        '#cgi.REMOTE_ADDR#',
                        #attributes.order_type#,
                        #main_row_query.IDENTITYCOL#,
                        2,
                        #dept_id_#,
                        #attributes.order_date#,
                        1
                        )
                </cfquery>
                <!---
                <cfif isdefined("attributes.hierarchy1") and listlen(attributes.hierarchy1)>
                    <cfloop list="#attributes.hierarchy1#" index="p_cat_">
                        <cfquery name="add_p_" datasource="#dsn_dev#">
                            INSERT INTO
                                STOCK_COUNT_ORDERS_PRODUCT_CATS
                                (
                                ORDER_ID,
                                PRODUCT_CAT
                                )
                                VALUES
                                (
                                #second_row_query.IDENTITYCOL#,
                                '#p_cat_#'
                                )
                        </cfquery>
                   </cfloop>
                </cfif>
                --->
                <cfquery name="add3_" datasource="#dsn_dev#" result="third_row_query">
                    INSERT INTO
                        STOCK_COUNT_ORDERS
                        (
                        ORDER_DETAIL,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP,
                        ORDER_TYPE,
                        MAIN_ORDER_ID,
                        COUNT_TYPE,
                        DEPARTMENT_ID,
                        ORDER_DATE,
                        STATUS
                        )
                        VALUES
                        (
                        '#attributes.order_detail#',
                        #session.ep.userid#,
                        #now()#,
                        '#cgi.REMOTE_ADDR#',
                        #attributes.order_type#,
                        #main_row_query.IDENTITYCOL#,
                        3,
                        #dept_id_#,
                        #attributes.order_date#,
                        1
                        )
                </cfquery>
                <!---
                <cfif isdefined("attributes.hierarchy1") and listlen(attributes.hierarchy1)>
                    <cfloop list="#attributes.hierarchy1#" index="p_cat_">
                        <cfquery name="add_p_" datasource="#dsn_dev#">
                            INSERT INTO
                                STOCK_COUNT_ORDERS_PRODUCT_CATS
                                (
                                ORDER_ID,
                                PRODUCT_CAT
                                )
                                VALUES
                                (
                                #third_row_query.IDENTITYCOL#,
                                '#p_cat_#'
                                )
                        </cfquery>
                   </cfloop>
                </cfif>
				--->
        </cfif>
    </cfloop>
</cftransaction>
<script>
	window.opener.location.reload();
	window.close();
</script>