<cf_xml_page_edit fuseact="product.popup_form_upd_product_dt_property">
<cflock name="#createuuid()#" timeout="20">
    <cftransaction>
        <cfquery name="GET_PRODUCT_CAT_RELATED_PROPERTY" datasource="#DSN1#">
            SELECT PRODUCT_DT_PROPERTY_ID FROM PRODUCT_DT_PROPERTIES WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
        </cfquery>
        <cfquery name="DEL_PRODUCT_CAT_RELATED_PROPERTY" datasource="#DSN1#">
            DELETE FROM PRODUCT_DT_PROPERTIES WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
        </cfquery>
        <cfquery name="GET_STOCK" datasource="#DSN1#" maxrows="1">
            SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = #attributes.product_id# ORDER BY RECORD_DATE DESC
        </cfquery>
        <cfif len(get_stock.stock_id)>
            <cfquery name="DEL_STOCK_PROPERTY" datasource="#DSN1#">
                DELETE FROM STOCKS_PROPERTY WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock.stock_id#">
            </cfquery>
        </cfif>
        <cfif isdefined("attributes.is_formajax")>
            <!--- MPC Kod Popuptan Buraya Gelir --->
            <cfif isdefined("attributes.record_num") and len(attributes.record_num)>
                <cfloop from="1" to="#attributes.record_num#" index="z">
                    <cfif len(evaluate("attributes.variation_id#z#"))>
                        <cfquery name="ADD_PROPERTY" datasource="#DSN1#">
                            INSERT INTO
                                PRODUCT_DT_PROPERTIES
                            (
                                PRODUCT_ID,
                                PROPERTY_ID,
                                VARIATION_ID,
                                RECORD_EMP,
                                RECORD_DATE,
                                RECORD_IP
                            )
                            VALUES
                            (
                                #attributes.product_id#,
                                #evaluate("attributes.property#z#")#,
                                #listfirst(evaluate("attributes.variation_id#z#"),';')#,
                                #session.ep.userid#,
                                #now()#,
                                '#cgi.remote_addr#'
                            )
                        </cfquery>
                    </cfif>
                </cfloop>
            </cfif>
        <cfelse>
            <!--- Ozellik Popuptan Buraya Gelir --->
            <cfloop from="1" to="#attributes.record_num#" index="i">
                <cfif evaluate("attributes.row_kontrol#i#") neq 0 and len(evaluate("attributes.property_id#i#")) and len(evaluate("attributes.property#i#"))>
                    <cfscript>
                        form_property_id = evaluate("attributes.property_id#i#");
                        if(xml_product_connect != 'undefined' && xml_product_connect == 1){
                        form_product_id = evaluate("attributes.product_property_id#i#");
                        form_product = evaluate("attributes.product_property#i#");
                        }
                        form_variation_id = evaluate("attributes.variation_id#i#");
                        form_detail = evaluate("attributes.detail#i#");
                        form_line_row = evaluate("attributes.line_row#i#");
                        form_amount = evaluate("attributes.amount#i#");
                        form_total_max = evaluate("attributes.total_max#i#");
                        form_total_min = evaluate("attributes.total_min#i#");
                    </cfscript>
                    <cfquery name="ADD_PROPERTY" datasource="#DSN1#" result="MAX_ID">
                        INSERT INTO
                            PRODUCT_DT_PROPERTIES
                        (
                            PRODUCT_ID,
                            PROPERTY_ID,
                            VARIATION_ID,
                            <cfif isdefined("xml_product_connect") and xml_product_connect eq 1>
                            PRODUCT_PROPERTY_ID,
                            </cfif>
                            DETAIL,
                            LINE_VALUE,
                            AMOUNT,
                            TOTAL_MIN,
                            TOTAL_MAX,
                            IS_OPTIONAL,
                            IS_EXIT,
                            IS_INTERNET,
                            RECORD_EMP,
                            RECORD_DATE,
                            RECORD_IP
                        )
                        VALUES
                        (
                            #attributes.product_id#,
                            <cfif len(form_property_id)>#form_property_id#<cfelse>NULL</cfif>,
                            <cfif len(form_variation_id)>#form_variation_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("xml_product_connect") and xml_product_connect eq 1>
                                <cfif len(form_product_id) and len(form_product)>#form_product_id#<cfelse>NULL</cfif>,
                            </cfif>
                            <cfif len(form_detail)>'#form_detail#'<cfelse>NULL</cfif>,
                            <cfif len(form_line_row)>#form_line_row#<cfelse>NULL</cfif>,
                            <cfif len(form_amount)>#form_amount#<cfelse>0</cfif>,
                            <cfif len(form_total_min)>#form_total_min#<cfelse>NULL</cfif>,
                            <cfif len(form_total_max)>#form_total_max#<cfelse>NULL</cfif>,
                            <cfif isDefined("attributes.is_optional#i#")>1<cfelse>0</cfif>,
                            <cfif isDefined("attributes.is_exit#i#")>1<cfelse>0</cfif>,
                            <cfif isDefined("attributes.is_internet#i#")>1<cfelse>0</cfif>,
                            #session.ep.userid#,
                            #now()#,
                            '#cgi.remote_addr#'
                        )
                    </cfquery>
                    <cfif len(get_stock.stock_id)>
                        <cfquery name="ADD_PROPERTY" datasource="#DSN1#">
                            INSERT INTO
                                STOCKS_PROPERTY
                            (
                                STOCK_ID,
                                PROPERTY_ID,
                                PROPERTY_DETAIL_ID,
                                PROPERTY_DETAIL,
                                TOTAL_MIN,
                                TOTAL_MAX
                            )
                            VALUES
                            (
                                #get_stock.stock_id#,
                                <cfif len(form_property_id)>#form_property_id#<cfelse>NULL</cfif>,
                                <cfif len(form_variation_id)>#form_variation_id#<cfelse>NULL</cfif>,
                                <cfif len(form_detail)>'#form_detail#'<cfelse>NULL</cfif>,
                                <cfif len(form_total_min)>#form_total_min#<cfelse>NULL</cfif>,
                                <cfif len(form_total_max)>#form_total_max#<cfelse>NULL</cfif>
                            )
                        </cfquery>
                    </cfif>
                    <cfif i LTE GET_PRODUCT_CAT_RELATED_PROPERTY.recordCount>
                    <cfset get_row=QueryGetRow(GET_PRODUCT_CAT_RELATED_PROPERTY, i)>
                    <cfquery name="UPD_LANGUAGE" datasource="#DSN1#">
                        UPDATE  
                        #dsn#.SETUP_LANGUAGE_INFO 
                        SET  
                        UNIQUE_COLUMN_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#max_id.IDENTITYCOL#">
                        where 
                        UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row.PRODUCT_DT_PROPERTY_ID#"> 
                    </cfquery>
                    <cfquery name="upd_language_det" datasource="#DSN1#">
                        UPDATE 
                            #dsn#.SETUP_LANGUAGE_INFO 
                        SET 
                            ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form_detail#">
                        WHERE   
                            UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#max_id.IDENTITYCOL#"> AND
                            COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="DETAIL"> AND
                            TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_DT_PROPERTIES"> AND
                            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
                    </cfquery>
                    </cfif>
                </cfif>
            </cfloop>
        </cfif>
        <cfif isdefined("attributes.auto_product_code_2") and attributes.auto_product_code_2 eq 1>
            <!--- Hem Ozellik Hem MPC Kod Taniminda Burasi Kullaniliyor --->
            <cfquery name="GET_PROPERTY_CODE" datasource="#DSN1#">
                SELECT
                    PROPERTY_DETAIL_CODE
                FROM
                    PRODUCT_DT_PROPERTIES,
                    PRODUCT_PROPERTY_DETAIL
                WHERE
                    PRODUCT_DT_PROPERTIES.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
                    PRODUCT_PROPERTY_DETAIL.PRPT_ID = PRODUCT_DT_PROPERTIES.PROPERTY_ID AND
                    PRODUCT_DT_PROPERTIES.VARIATION_ID = PROPERTY_DETAIL_ID
            </cfquery>
            <cfset product_code = "">
            <cfoutput query="get_property_code">
                <cfif currentrow eq 1>
                    <cfset product_code = "#get_property_code.property_detail_code#">
                <cfelse>
                    <cfset product_code = "#product_code#.#get_property_code.property_detail_code#">
                </cfif>
            </cfoutput>
            <cfquery name="UPD_PRODUCT_CODE" datasource="#DSN1#">
                UPDATE PRODUCT SET PRODUCT_CODE_2 = '#product_code#' WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
            </cfquery>
        </cfif>
    </cftransaction>
</cflock>
<cfif not isdefined("attributes.draggable")>
    <cfif isdefined("attributes.is_formajax") and attributes.is_formajax eq 2>
        <cflocation url="#request.self#?fuseaction=product.list_product&event=det&pid=#attributes.product_id#">
    <cfelse>
        <script type="text/javascript">
            window.close();
        </script>
    </cfif>
<cfelse>
    <script type="text/javascript">
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique__dsp_product_mpc_code_' );
    </script>
</cfif>

