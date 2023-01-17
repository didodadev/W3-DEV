<cfcomponent extends="WMO.functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = "#dsn#_product">
    <cfset dsn3 = dsn3_alias = '#dsn#_#session.ep.company_id#' />
    <cfset dsn1 = dsn_product = dsn1_alias = '#dsn#_product' />
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfset dsn_alias = "#dsn#">
    <cfset fusebox.process_tree_control = application.systemParam.systemParam().fusebox.process_tree_control>
    <cfset queryJSONConverter = createObject('component','cfc.queryJSONConverter') />

    <cffunction name="get_tree_fnc" returntype="query" displayname="Ürün Ağaçları Listeleme Sayfası">
        <cfargument name="keyword" default="" displayname="Ürün Adına Göre Filtreleme Yapar">
        <cfargument name="cat" default="" displayname="Ürün Kategorisi">
        <cfargument name="record_employee_id" default="" displayname="Kaydeden Çalışan İd">
        <cfargument name="record_employee_name" default="" displayname="Kaydeden Çalışan İsim">
        <cfargument name="brand_id" default="" displayname="Marka İd">
        <cfargument name="brand_name" default="" displayname="Marka">
        <cfargument name="product_id" default="" displayname="Ürün İd">
        <cfargument name="product_name" default="" displayname="Ürün">
        <cfargument name="product_employee_id" default="" displayname="Sorumlu Kişi İd">
        <cfargument name="employee_name" default="" displayname="Sorumlu Kişi İsim">
        <cfargument name="stock_status" default="" displayname="Aktif Pasif Bilgisi">
        <cfargument name="is_main_spec" default="" displayname="Ürün Ağacı Var mı Yokmu bilgisi">
        <cfquery name="get_tree" datasource="#dsn3#">
            SELECT
                PRODUCT_NAME,
                STOCK_CODE,
                BARCOD,
                PROPERTY,
                STOCK_ID,
                PRODUCT_ID,
                STOCK_STATUS,
                PRODUCT_MANAGER,
                RECORD_EMP,
                BRAND_ID,
                MAIN_SPEC
            FROM
            (	
                SELECT 
                    S.PRODUCT_NAME,
                    S.STOCK_CODE,
                    S.BARCOD,
                    S.PROPERTY,
                    S.STOCK_ID,
                    S.PRODUCT_ID,
                    S.STOCK_STATUS,
                    S.PRODUCT_MANAGER,
                    S.RECORD_EMP,
                    S.BRAND_ID,
                    (SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC) MAIN_SPEC
                FROM
                    STOCKS S
                WHERE 
                    S.IS_PRODUCTION = 1
                <cfif len(arguments.keyword)>
                    AND ( S.PRODUCT_NAME LIKE '%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR S.STOCK_CODE LIKE '%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
                </cfif>
                <cfif isdefined('arguments.cat') and len(arguments.cat)>
                    AND S.PRODUCT_CODE LIKE '#arguments.cat#.%'
                </cfif>
                <cfif len(arguments.record_employee_id) and len(arguments.record_employee_name)>
                    AND S.RECORD_EMP = #arguments.record_employee_id#
                </cfif>
                <cfif len(arguments.brand_id) and len(arguments.brand_name)>
                    AND S.BRAND_ID = #arguments.brand_id#
                </cfif>
                <cfif len(arguments.product_id) and len(arguments.product_name)>
                    AND S.PRODUCT_ID = #arguments.product_id#
                </cfif>
                <cfif len(arguments.product_employee_id) and len(arguments.employee_name)>
                    AND S.PRODUCT_MANAGER = #arguments.product_employee_id#
                </cfif>
                <cfif len(arguments.stock_status)>
                    AND S.STOCK_STATUS = #arguments.stock_status#
                </cfif>
            )T1
            <cfif arguments.is_main_spec eq 2>
                WHERE
                    MAIN_SPEC IS NULL
            <cfelseif arguments.is_main_spec eq 1>
                WHERE
                    MAIN_SPEC IS NOT NULL
            </cfif>
            ORDER BY
                PRODUCT_NAME
        </cfquery>
        <cfreturn get_tree>
    </cffunction>
    <cffunction name="GET_PROCESS_STAGE"  access="remote" returntype="any">
        <cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
            SELECT
                PTR.STAGE,
                PTR.PROCESS_ROW_ID 
            FROM
                PROCESS_TYPE_ROWS PTR WITH (NOLOCK),
                PROCESS_TYPE_OUR_COMPANY PTO WITH (NOLOCK),
                PROCESS_TYPE PT WITH (NOLOCK)
            WHERE
                PT.IS_ACTIVE = 1 AND
                PT.PROCESS_ID = PTR.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%prod.tree_purchase_plan%">
            ORDER BY 
                PTR.LINE_NUMBER
        </cfquery>
        <cfreturn GET_PROCESS_STAGE>
    </cffunction>
    <cffunction name="GET_PRO_TREE_ID" access="public" returntype="query">
        <cfargument name="stock_id" type="any">
        <cfquery name="get_pro_tree_id" datasource="#DSN3#">
            SELECT 
                PT.PRODUCT_TREE_ID,
                PT.RECORD_DATE,
                PT.UPDATE_DATE,
                PT.RECORD_EMP,
                (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE  E.EMPLOYEE_ID=PT.UPDATE_EMP) AS UPDATE_NAME,
                (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE  E.EMPLOYEE_ID=PT.RECORD_EMP) AS RECORD_NAME,
                UPDATE_EMP ,
                PROCESS_STAGE
           FROM 
               PRODUCT_TREE  PT
           WHERE 
               STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
          </cfquery>
        <cfreturn get_pro_tree_id/>
    </cffunction>
    <cffunction name="GET_TREE_GROUP_TYPE" access="public" returntype="query">
        <cfargument name="stock_id" type="any">
        <cfquery name="get_tree_group_type" datasource="#DSN3#">
            SELECT 
                PT.PRODUCT_TREE_ID,
                PT.RECORD_DATE,
                PT.UPDATE_DATE,
                PT.RECORD_EMP,
                (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE E.EMPLOYEE_ID=PT.UPDATE_EMP) AS UPDATE_NAME,
                (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE E.EMPLOYEE_ID=PT.RECORD_EMP) AS RECORD_NAME,
                PT.UPDATE_EMP,
                PT.PROCESS_STAGE,
                PT.SPECT_MAIN_ID,
                PT.OPERATION_TYPE_ID,
                PT.AMOUNT,
                PT.STOCK_ID,
                PT.PRODUCT_ID,
                PT.TARGET_PRICE,
                PT.TARGET_PRICE_CURRENCY,
                PT.SUPPLIER_COMPANY_ID,
                PT.LAST_PRICE,
                PT.TECHNICAL_POINT,
                PT.PRODUCTION_CODE,
                ISNULL(PT.TREE_TYPE,-1) AS TREE_TYPE,
                CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE ISNULL(PTT.TYPE, STR.ITEM_#UCase(session.ep.language)# ) 
                END AS TYPE,
                P.P_SAMPLE_ID,
                P.IS_PRODUCTION,
                P.IS_PURCHASE,
                P.PRODUCT_NAME,
                P.PRODUCT_CODE,
                PTR.STAGE,
                PU.MAIN_UNIT,
                C.FULLNAME,
                OT.OPERATION_TYPE,
                PTR.PROCESS_ROW_ID
            FROM 
               PRODUCT_TREE AS PT
               LEFT JOIN #dsn#.PRODUCT_TREE_TYPE AS PTT ON PTT.TYPE_ID = PT.TREE_TYPE
               LEFT JOIN OPERATION_TYPES AS OT ON OT.OPERATION_TYPE_ID = PT.OPERATION_TYPE_ID
               LEFT JOIN #dsn#_product.PRODUCT AS P ON PT.PRODUCT_ID = P.PRODUCT_ID 
               LEFT JOIN #dsn#.PROCESS_TYPE_ROWS AS PTR ON PT.PROCESS_STAGE = PTR.PROCESS_ROW_ID
               LEFT JOIN #dsn3#.PRODUCT_UNIT AS PU ON PU.PRODUCT_UNIT_ID = PT.UNIT_ID
               LEFT JOIN #dsn#.COMPANY AS C ON C.COMPANY_ID = PT.SUPPLIER_COMPANY_ID
               LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PTT.TYPE_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="TYPE">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="PRODUCT_TREE_TYPE">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#session.ep.language#">
               LEFT JOIN #dsn#.SETUP_LANGUAGE_TR AS STR ON STR.DICTIONARY_ID = 64708
            WHERE 
               PT.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
            ORDER BY 
                PT.TREE_TYPE ASC
          </cfquery>
        <cfreturn get_tree_group_type />
    </cffunction>

    <cffunction name="upd_purchase_plan" access="remote" returntype="any" returnformat="JSON">
        <cfset response = structNew()>
        <cftransaction>
            <cftry>
                <cfif isDefined("arguments.variant_count") and len(arguments.variant_count)>
                    <cfloop from="1" to="#arguments.variant_count#" index="i">
                        <cfquery name="upd_purchase_plan" datasource="#dsn3#">
                            UPDATE
                                PRODUCT_TREE
                            SET
                                LAST_PRICE = <cfif len(evaluate("BUY_AMOUNT_#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(evaluate("BUY_AMOUNT_#i#"))#"><cfelse>NULL</cfif>,
                                TARGET_PRICE = <cfif len(evaluate("TARGET_PRICE_#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(evaluate("TARGET_PRICE_#i#"))#"><cfelse>NULL</cfif>,
                                TARGET_PRICE_CURRENCY = <cfif len(evaluate("TARGET_CURRENCY_#i#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("TARGET_CURRENCY_#i#")#"><cfelse>NULL</cfif>,
                                SUPPLIER_COMPANY_ID = <cfif len(evaluate("SUPPLIER_COMPANY_ID_#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("SUPPLIER_COMPANY_ID_#i#")#"><cfelse>NULL</cfif>,
                                TECHNICAL_POINT = <cfif len(evaluate("TECHINAL_POINT_#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("TECHINAL_POINT_#i#")#"><cfelse>NULL</cfif>,
                                PRODUCTION_CODE = <cfif len(evaluate("PRODUCTION_CODE_#i#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("PRODUCTION_CODE_#i#")#"><cfelse>NULL</cfif>
                            WHERE
                                PRODUCT_TREE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("PRODUCT_TREE_ID_#i#")#">
                        </cfquery>
                    </cfloop>
                    <cfset response.message = "Kayıt işlemi başarıyla gerçekleşti">
                    <cfset response.status = 1>
                <cfelse>
                    <cfset response.message = "Kayıt işlemi sırasında bir sorun oluştu">
                    <cfset response.status = 0>
                </cfif>
                <cfcatch>
                    <cfset response.message = "Kayıt işlemi sırasında bir sorun oluştu">
                    <cfset response.status = 0>   
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn replace(serializeJSON(response),"//","") >
    </cffunction>

    <cffunction name="upd_alternative" access="remote" returntype="any" returnformat="JSON">
        <cfset response = structNew()>
        <cftransaction>
            <cftry>
                <cfif isDefined("arguments.alternative_count") and len(arguments.alternative_count)>
                    <cfloop from="1" to="#arguments.alternative_count#" index="i">
                        <cfquery name="upd_purchase_plan" datasource="#dsn3#">
                            UPDATE
                                ALTERNATIVE_PRODUCTS
                            SET
                                LAST_PRICE = <cfif len(evaluate("alternative_buy_amount_#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(evaluate("alternative_buy_amount_#i#"))#"><cfelse>NULL</cfif>,
                                TARGET_PRICE = <cfif len(evaluate("alternative_target_price_#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(evaluate("alternative_target_price_#i#"))#"><cfelse>NULL</cfif>,
                                TARGET_PRICE_CURRENCY = <cfif len(evaluate("alternative_target_currency_#i#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("alternative_target_currency_#i#")#"><cfelse>NULL</cfif>,
                                COMPANY_ID = <cfif len(evaluate("alternative_supplier_company_id_#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("alternative_supplier_company_id_#i#")#"><cfelse>NULL</cfif>,
                                TECHNICAL_POINT = <cfif len(evaluate("alternative_techinal_point_#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("alternative_techinal_point_#i#")#"><cfelse>NULL</cfif>,
                                PRODUCTION_CODE = <cfif len(evaluate("alternative_production_code_#i#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("alternative_production_code_#i#")#"><cfelse>NULL</cfif>
                            WHERE
                            ALTERNATIVE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("alternative_id_#i#")#">
                        </cfquery>
                    </cfloop>
                    <cfset response.message = "Kayıt işlemi başarıyla gerçekleşti">
                    <cfset response.status = 1>
                <cfelse>
                    <cfset response.message = "Kayıt işlemi sırasında bir sorun oluştu">
                    <cfset response.status = 0>
                </cfif>
                <cfcatch>
                    <cfset response.message = "Kayıt işlemi sırasında bir sorun oluştu">
                    <cfset response.status = 0>   
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn replace(serializeJSON(response),"//","") >
    </cffunction>
    <cffunction name="upd_prod" access="remote" returntype="any" returnformat="JSON">
        <cfset response = structNew()>
        <cftransaction>
            <cftry>
                <cfif isDefined("arguments.alternative_count") and len(arguments.alternative_count)>
                    <cfloop from="1" to="#arguments.alternative_count#" index="i">
                        <cfif isDefined("alternative_id_#i#")>
                            <cfif len(evaluate("alternative_id_#i#"))> 
                                <cfquery name="upd_purchase_plan" datasource="#dsn3#">
                                    UPDATE
                                        ALTERNATIVE_PRODUCTS
                                    SET
                                        LAST_PRICE = <cfif len(evaluate("alternative_buy_amount_#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(evaluate("alternative_buy_amount_#i#"))#"><cfelse>NULL</cfif>,
                                        QUANTITY = <cfif len(evaluate("quantity#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(evaluate("quantity#i#"))#"><cfelse>NULL</cfif>,
                                        LAST_PRICE_CURRENCY = <cfif len(evaluate("last_price_currency_#i#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("last_price_currency_#i#")#"><cfelse>NULL</cfif>,
                                        TARGET_PRICE = <cfif len(evaluate("alternative_target_price_#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(evaluate("alternative_target_price_#i#"))#"><cfelse>NULL</cfif>,
                                        TARGET_PRICE_CURRENCY = <cfif len(evaluate("alternative_target_currency_#i#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("alternative_target_currency_#i#")#"><cfelse>NULL</cfif>,
                                        COMPANY_ID = <cfif len(evaluate("alternative_supplier_company_id_#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("alternative_supplier_company_id_#i#")#"><cfelse>NULL</cfif>,
                                        TECHNICAL_POINT = <cfif len(evaluate("alternative_techinal_point_#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("alternative_techinal_point_#i#")#"><cfelse>NULL</cfif>,
                                        PRODUCTION_CODE = <cfif len(evaluate("alternative_production_code_#i#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("alternative_production_code_#i#")#"><cfelse>NULL</cfif>
                                    WHERE
                                    ALTERNATIVE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("alternative_id_#i#")#">
                                </cfquery>
                            <cfelse>
                                <cfquery name="add_purchase_plan" datasource="#dsn3#">
                                    INSERT INTO ALTERNATIVE_PRODUCTS(
                                        PRODUCT_ID,
                                        STOCK_ID,
                                        ALTERNATIVE_PRODUCT_ID,
                                        LAST_PRICE,
                                        TARGET_PRICE,
                                        TARGET_PRICE_CURRENCY,
                                        COMPANY_ID,
                                        TECHNICAL_POINT, 
                                        PRODUCTION_CODE,
                                        QUANTITY,
                                        LAST_PRICE_CURRENCY

                                    )
                                    VALUES(
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("stock_id#i#")#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("product_id#i#")#">,
                                        <cfif len(evaluate("alternative_buy_amount_#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(evaluate("alternative_buy_amount_#i#"))#"><cfelse>NULL</cfif>,
                                        <cfif len(evaluate("alternative_target_price_#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(evaluate("alternative_target_price_#i#"))#"><cfelse>NULL</cfif>,
                                        <cfif len(evaluate("alternative_target_currency_#i#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("alternative_target_currency_#i#")#"><cfelse>NULL</cfif>,
                                        <cfif len(evaluate("alternative_supplier_company_id_#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("alternative_supplier_company_id_#i#")#"><cfelse>NULL</cfif>,
                                        <cfif len(evaluate("alternative_techinal_point_#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("alternative_techinal_point_#i#")#"><cfelse>NULL</cfif>,
                                        <cfif len(evaluate("alternative_production_code_#i#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("alternative_production_code_#i#")#"><cfelse>NULL</cfif>,
                                        <cfif len(evaluate("quantity#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(evaluate("quantity#i#"))#"><cfelse>NULL</cfif>,
                                        <cfif len(evaluate("last_price_currency_#i#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("last_price_currency_#i#")#"><cfelse>NULL</cfif>
                                    )
                                </cfquery>
                            </cfif>
                        </cfif>
                    </cfloop>
                    <cfset response.message = "Kayıt işlemi başarıyla gerçekleşti">
                    <cfset response.status = 1>
                <cfelse>
                    <cfset response.message = "Kayıt işlemi sırasında bir sorun oluştu">
                    <cfset response.status = 0>
                </cfif>
                <cfcatch>
                    <cfset response.message = "Kayıt işlemi sırasında bir sorun oluştu">
                    <cfset response.status = 0>   
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn replace(serializeJSON(response),"//","") >
    </cffunction>

    <cffunction name="del_alternative" access="remote" returntype="any" returnformat="JSON">
        <cfset response = structNew()>
        <cftry>
            <cfquery name="del_alternative" datasource="#dsn3#">
                DELETE FROM ALTERNATIVE_PRODUCTS WHERE ALTERNATIVE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.alternative_id#">
            </cfquery>
                <cfset response.message = "Silme işlemi başarıyla gerçekleşti">
                <cfset response.status = 1>
            <cfcatch>
                <cfset response.message = "Kayıt işlemi sırasında bir sorun oluştu">
                <cfset response.status = 0>   
            </cfcatch>
        </cftry>
        <cfreturn replace(serializeJSON(response),"//","") >
    </cffunction>
    
    <cffunction name="del_prod_tree" access="remote" returntype="any" returnformat="JSON">
        <cfset response = structNew()>
        <cftry>
            <cfloop list="#arguments.stock_list#" index="item">
                <cfquery name="del_prod_tree" datasource="#dsn3#">
                    DELETE FROM PRODUCT_TREE WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#item#">
                </cfquery>
            </cfloop>
                <cfset response.message = "Silme işlemi başarıyla gerçekleşti">
                <cfset response.status = 1>
            <cfcatch>
                <cfset response.message = "Silme işlemi sırasında bir sorun oluştu">
                <cfset response.status = 0>   
            </cfcatch>
        </cftry>
        <cfreturn replace(serializeJSON(response),"//","") >
    </cffunction>

    <cffunction name="LIST_PRODUCT_SAMPLE"  access="remote" returntype="any">
        <cfargument name="product_id" default="">
        <cfargument name="consumer_id" default="">
        <cfargument name="company_id" default="">
        <cfargument name="tree_types" default="">
        <cfargument name="designer_emp_id" default="">
        <cfargument name="ted_company_id" default="">
        <cfargument name="opportunity_id" default="">
        <cfargument  name="process_stage" default="">
        <cfquery name="LIST_PRODUCT_SAMPLE" datasource="#dsn3#">
        WITH CTE1 AS (
            SELECT
                P.IS_PRODUCTION,
                P.PRODUCT_ID,
                PT.PRODUCT_TREE_ID,
                PT.TREE_TYPE,
                PT.PRODUCT_ID AS T_PRODUCT_ID,
                PT.AMOUNT,
                PT.TARGET_PRICE,
                PT.TARGET_PRICE_CURRENCY,
                S.STOCK_ID,
                PS.PRODUCT_SAMPLE_ID,
                PS.PRODUCT_SAMPLE_NAME,
                PS.PROCESS_STAGE_ID,
                PS.CONSUMER_ID,
                PS.COMPANY_ID,
                CMP.FULLNAME,
                PS.DESIGNER_EMP_ID,
                PS.PRODUCT_SAMPLE_DETAIL,
                PS.TARGET_AMOUNT,
                PT.SUPPLIER_COMPANY_ID,
                PT.TECHNICAL_POINT,
                PU.MAIN_UNIT,
                PTT.TYPE AS TREE_TYPE_NAME,
                PTR.STAGE,
                O.OPP_ID,
                O.OPP_HEAD
            FROM 
                PRODUCT_TREE AS PT
                LEFT JOIN STOCKS AS S ON S.STOCK_ID = PT.STOCK_ID
                LEFT JOIN #dsn1#.PRODUCT AS P ON P.PRODUCT_ID = S.PRODUCT_ID 
                LEFT JOIN PRODUCT_SAMPLE AS PS ON P.P_SAMPLE_ID = PS.PRODUCT_SAMPLE_ID
                LEFT JOIN #DSN#.COMPANY AS CMP ON CMP.COMPANY_ID = PS.COMPANY_ID
                LEFT JOIN #DSN#.CONSUMER AS CS ON CS.CONSUMER_ID = PS.CONSUMER_ID
                LEFT JOIN OPPORTUNITIES AS O ON O.OPP_ID= PS.OPPORTUNITY_ID
                LEFT JOIN #dsn3#.PRODUCT_UNIT AS PU ON PU.PRODUCT_UNIT_ID = PT.UNIT_ID
                LEFT JOIN #dsn#.PROCESS_TYPE_ROWS AS PTR ON PTR.PROCESS_ROW_ID = PS.PROCESS_STAGE_ID 
                LEFT JOIN #dsn#.PRODUCT_TREE_TYPE AS PTT ON PT.TREE_TYPE = PTT.TYPE_ID
            WHERE PT.STOCK_ID IN ( 
                                    SELECT 
                                        S.STOCK_ID
                                    FROM PRODUCT_SAMPLE AS PS 
                                    LEFT JOIN #dsn1#.PRODUCT AS P ON P.P_SAMPLE_ID = PS.PRODUCT_SAMPLE_ID
                                    LEFT JOIN STOCKS AS S ON P.PRODUCT_ID = S.PRODUCT_ID
                                    WHERE P.P_SAMPLE_ID IS NOT NULL AND STOCK_CODE_2 IS NULL
                                )
            <cfif isdefined("arguments.product_id") and len(arguments.product_id)>
                AND P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
            </cfif>
            <cfif isdefined("arguments.company_id") and len(arguments.company_id)>
                AND  PS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
            <cfelseif isdefined("arguments.consumer_id") and len(arguments.consumer_id) and len(arguments.company_name)>
                AND  PS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
            </cfif>
            <cfif isdefined("arguments.opportunity_id") and len(arguments.opportunity_id) >
                AND  PS.OPPORTUNITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.opportunity_id#">
            </cfif>
            <cfif isdefined("arguments.process_stage") and listlen(arguments.process_stage)>
                AND PS.PROCESS_STAGE_ID IN (#arguments.process_stage#)
            </cfif>
            <cfif isdefined("arguments.designer_emp_id") and len(arguments.designer_emp_id)>
                AND PS.DESIGNER_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.designer_emp_id#">
            </cfif>
            <cfif isDefined("arguments.tree_types") and len(arguments.tree_types)>
                AND PT.TREE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tree_types#">
            </cfif>
            <cfif isDefined("arguments.ted_company_id") and len(arguments.ted_company_id)>
                AND PT.SUPPLIER_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ted_company_id#">
            </cfif>
            ),
            CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (	ORDER BY
                                                PRODUCT_SAMPLE_ID ASC) AS RowNum, (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                            FROM
                                CTE1
                        )
                        SELECT
                            CTE2.*
                        FROM
                            CTE2
                        WHERE
                            RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
        </cfquery>
        <cfreturn LIST_PRODUCT_SAMPLE>
    </cffunction>

    <cffunction name="sample_process_stage"  access="remote" returntype="any">
        <cfquery name="sample_process_stage" datasource="#DSN#">
            SELECT
                PTR.STAGE,
                PTR.PROCESS_ROW_ID 
            FROM
                PROCESS_TYPE_ROWS PTR WITH (NOLOCK),
                PROCESS_TYPE_OUR_COMPANY PTO WITH (NOLOCK),
                PROCESS_TYPE PT WITH (NOLOCK)
            WHERE
                PT.IS_ACTIVE = 1 AND
                PT.PROCESS_ID = PTR.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%product.product_sample%">
            ORDER BY 
                PTR.LINE_NUMBER
        </cfquery>
        <cfreturn sample_process_stage>
    </cffunction> 

    <cffunction name="get_components" access="public" returnformat="JSON">
        <cfargument name="stock_id" type="any">
        <cfquery name="get_amount_xml" datasource="#dsn#">
            SELECT 
                PROPERTY_VALUE,
                PROPERTY_NAME
            FROM
                FUSEACTION_PROPERTY
            WHERE
               
                FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="prod.tree_purchase_plan_pricing"> and
                PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="is_fire_amount">
        </cfquery>
        <cfquery name="get_components" datasource="#DSN3#">
            SELECT 
                PT.PRODUCT_TREE_ID,
                PT.RECORD_DATE,
                PT.UPDATE_DATE,
                PT.RECORD_EMP,
                (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE E.EMPLOYEE_ID=PT.UPDATE_EMP) AS UPDATE_NAME,
                (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE E.EMPLOYEE_ID=PT.RECORD_EMP) AS RECORD_NAME,
                PT.UPDATE_EMP,
                PT.PROCESS_STAGE,
                PT.SPECT_MAIN_ID,
                PT.AMOUNT,
                PT.STOCK_ID,
                PT.PRODUCT_ID,
                PT.TARGET_PRICE,
                PT.TARGET_PRICE_CURRENCY,
                PT.SUPPLIER_COMPANY_ID,
                PT.LAST_PRICE,
                PT.TECHNICAL_POINT,
                PT.PRODUCTION_CODE,
                PTT.WASTE_RATE,
                PT.FIRE_RATE,
               CASE 
                WHEN  #get_amount_xml.PROPERTY_VALUE# = 1  THEN PT.FIRE_RATE
                else PTT.WASTE_RATE
                END AS FIRE_RATE,
                ISNULL(PT.TREE_TYPE,-1) AS TREE_TYPE,
                CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE ISNULL(PTT.TYPE, STR.ITEM_#UCase(session.ep.language)# ) 
                END AS TYPE,
                P.P_SAMPLE_ID,
                P.IS_PRODUCTION,
                P.IS_PURCHASE,
                P.PRODUCT_NAME,
                P.PRODUCT_CODE,
                PT.FIRE_AMOUNT AS FIRE_AMOUNT_,
                PTR.STAGE,
                PU.MAIN_UNIT,
                C.FULLNAME,
                OT.OPERATION_TYPE
            FROM 
               PRODUCT_TREE AS PT
               LEFT JOIN #dsn#.PRODUCT_TREE_TYPE AS PTT ON PTT.TYPE_ID = PT.TREE_TYPE
               LEFT JOIN OPERATION_TYPES AS OT ON OT.OPERATION_TYPE_ID = PT.OPERATION_TYPE_ID
               LEFT JOIN #dsn#_product.PRODUCT AS P ON PT.PRODUCT_ID = P.PRODUCT_ID 
               LEFT JOIN #dsn#.PROCESS_TYPE_ROWS AS PTR ON PT.PROCESS_STAGE = PTR.PROCESS_ROW_ID
               LEFT JOIN #dsn3#.PRODUCT_UNIT AS PU ON PU.PRODUCT_UNIT_ID = PT.UNIT_ID
               LEFT JOIN #dsn#.COMPANY AS C ON C.COMPANY_ID = PT.SUPPLIER_COMPANY_ID
               LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PTT.TYPE_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="TYPE">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="PRODUCT_TREE_TYPE">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#session.ep.language#">
               LEFT JOIN #dsn#.SETUP_LANGUAGE_TR AS STR ON STR.DICTIONARY_ID = 64708
            WHERE 
               PT.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
            ORDER BY 
                PT.TREE_TYPE ASC
          </cfquery>
        <cfreturn replace( serializeJSON( queryJSONConverter.returnData( replace( serializeJSON( get_components ),'//','' ) ) ), '//', '' ) />
    </cffunction>
    

    <cffunction name="component_group_type" access="public" returnformat="JSON">
        <cfquery name="component_group_type" datasource="#dsn3#">
            SELECT DISTINCT
                CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE ISNULL(PTT.TYPE, STR.ITEM_#UCase(session.ep.language)# ) 
                END AS TYPE,
                PTT.TYPE_ID,
                PTT.WASTE_RATE,
                ISNULL(PTT.TYPE, STR.ITEM_#UCase(session.ep.language)# ) TYPE_2
            FROM 
                PRODUCT_TREE AS PT
                LEFT JOIN #dsn#.PRODUCT_TREE_TYPE AS PTT ON PTT.TYPE_ID = PT.TREE_TYPE
                LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PTT.TYPE_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="TYPE">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="PRODUCT_TREE_TYPE">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#session.ep.language#">
                LEFT JOIN #dsn#.SETUP_LANGUAGE_TR AS STR ON STR.DICTIONARY_ID = 64708
            WHERE 
               PT.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
        </cfquery>
        <cfreturn replace( serializeJSON( queryJSONConverter.returnData( replace( serializeJSON( component_group_type ),'//','' ) ) ), '//', '' ) />
    </cffunction>

    <cffunction name="GET_MONEY" returntype="any">
        <cfquery name="GET_MONEY" datasource="#DSN#">
            SELECT MONEY, RATE2, RATE1, 0 AS IS_SELECTED FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
        </cfquery>
        <cfreturn GET_MONEY>
    </cffunction>

    <cffunction name="GET_MONEY_CURRENCY" returntype="any" returnformat="JSON">
        <cfset currencies = structNew() />
        <cfquery name="GET_MONEY" datasource="#DSN#">
            SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID#
        </cfquery>
        <cfset currencies['TL'] = 1 />
        <cfif GET_MONEY.recordcount>
            <cfoutput query = "GET_MONEY">
                <cfset currencies[ MONEY ] = RATE2 />
            </cfoutput>
        </cfif>

        <cfreturn replace(serializeJSON(currencies),'//','')>
    </cffunction>

    <cffunction name="add_pricing" returntype="any" returnformat="JSON" access="remote">
        <cfset arrData = deserializeJSON(arguments.component_data)>
        <cfset response = structNew() />
        <cftransaction>
            <cftry>
                <!--- pricing tablosuna kayıtlar atılıyor --->
                <cfquery name="add_pricing" datasource="#dsn3#" result="MAX_ID">
                    INSERT INTO PRODUCT_SAMPLE_PRICING(
                        PRODUCT_SAMPLE_ID,
                        COMPONENT_DATA,
                        COMMISSION_RATE,
                        GENERAL_COST_RATE,
                        KAR_RATE,
                        DESCRIPTION,
                        PROCESS_STAGE,
                        RECORD_DATE,
                        RECORD_IP,
                        RECORD_EMP
                    ) VALUES(
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_sample_id#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.component_data#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.commission_rate#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.general_cost_rate#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.kar_rate#">,
                        <cfif len(arguments.DESCRIPTION)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.description#"><cfelse>NULL</cfif>,
                        <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
                        #now()#,
                        '#cgi.REMOTE_ADDR#',
                        #session.ep.userid#
                    )
                </cfquery>

                <cfif isDefined("arguments.process_stage") and len(arguments.process_stage) and arguments.process_stage eq arguments.is_update_price>
                    <cfquery name="upd_sample_prod" datasource="#dsn3#">
                        UPDATE 
                            PRODUCT_SAMPLE 
                        SET 
                            SALES_PRICE = <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.paper_last_total)#"> 
                        WHERE 
                            PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_sample_id#"> 
                    </cfquery>
                </cfif>

                <!--- Ağaçtaki ilgili satırlar güncelleniyor --->
                <cfloop from="1" to="#arrayLen(arrData)#" index="i">
                    <cfquery name="upd_tree" datasource="#dsn3#">
                        UPDATE PRODUCT_TREE
                        SET 
                            FIRE_RATE = <cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(arrData[i]["FIRE_RATE"])#">,
                            FIRE_AMOUNT = <cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(arrData[i]["FIRE_AMOUNT_"])#">,
                            LAST_PRICE = <cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(arrData[i]["LAST_PRICE"])#">
                        WHERE 
                            PRODUCT_TREE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arrData[i]["PRODUCT_TREE_ID"]#">
                    </cfquery>
                </cfloop>

                <!--- money kayıtları --->
                <cfloop from="1" to="#arguments.kur_say#" index="i">
                    <cfquery name="PRICING_MONEY_INFO" datasource="#dsn3#">
                        INSERT INTO
                            SAMPLE_PRICING_MONEY 
                        (
                            ACTION_ID,
                            MONEY_TYPE,
                            RATE2,
                            RATE1,
                            IS_SELECTED
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("arguments.hidden_rd_money_#i#")#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate("arguments.txt_rate2_#i#"))#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate("arguments.txt_rate1_#i#"))#">,
                            <cfif evaluate("arguments.hidden_rd_money_#i#") is arguments.currency_id>1<cfelse>0</cfif>
                        )
                    </cfquery>
                </cfloop>

                <cfif isDefined("arguments.process_stage") and len(arguments.process_stage)>
                    <cfset attributes.fuseaction = arguments.fuseaction>
                    <cf_workcube_process 
                        data_source = '#dsn3#'
                        is_upd='1' 
                        old_process_line='0'
                        process_stage='#arguments.process_stage#' 
                        record_member='#session.ep.userid#' 
                        record_date='#now()#'
                        action_table='PRODUCT_SAMPLE_PRICING'
                        action_column='PRODUCT_SAMPLE_ID'
                        action_id='#arguments.product_sample_id#'
                        action_page='index.cfm?fuseaction=prod.tree_purchase_plan_pricing&product_sample_id=#arguments.product_sample_id#'
                        warning_description='Numune - Fiyatlandırma'>
                </cfif>
                <cfset getPageContext().getCFOutput().clearAll()>
                <cfset getPageContext().getCFOutput().clearHeaderBuffers()>

                <cfset response = { status: true, pricing_id : MAX_ID.IDENTITYCOL } />
                <cfcatch type="any">
                    <cfset response = { status: false } />
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn replace( serializeJSON( response ), '//', '' ) />
    </cffunction>
    <cffunction name="UPD_Sales_Price" returntype="any" returnformat="JSON" access="remote">
        <cfset arrData = deserializeJSON(arguments.component_data)>
        <cfset response = structNew() />
        <cftransaction>
            <cftry>
                <cfquery name="upd_sample_prod" datasource="#dsn3#">
                    UPDATE 
                        PRODUCT_SAMPLE 
                    SET 
                        SALES_PRICE = <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.paper_last_total)#"> 
                    WHERE 
                        PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_sample_id#"> 
                </cfquery>
           
          
           <cfset getPageContext().getCFOutput().clearAll()>
                <cfset getPageContext().getCFOutput().clearHeaderBuffers()>
                <cfset response = { status: true, pricing_id : arguments.pricing_id } />
                <cfcatch type="any">
                    <cfset response = { status: false } />
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn replace( serializeJSON( response ), '//', '' ) />
    </cffunction>
    <cffunction name="upd_pricing" returntype="any" returnformat="JSON" access="remote">
        <cfset arrData = deserializeJSON(arguments.component_data)>
        <cfset response = structNew() />
        <cftransaction>
            <cftry>
                <!--- Pricing Güncelleme --->
                <cfquery name="upd_pricing" datasource="#dsn3#">
                    UPDATE PRODUCT_SAMPLE_PRICING
                    SET
                        COMPONENT_DATA = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.component_data#">,
                        COMMISSION_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.commission_rate#">,
                        GENERAL_COST_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.general_cost_rate#">,
                        KAR_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.kar_rate#">,
                        DESCRIPTION = <cfif len(arguments.DESCRIPTION)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.description#"><cfelse>NULL</cfif>,
                        PROCESS_STAGE = <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
                        UPDATE_DATE = #now()#,
                        UPDATE_IP = '#cgi.REMOTE_ADDR#',
                        UPDATE_EMP = #session.ep.userid#
                    WHERE
                        PRICING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pricing_id#">
                </cfquery>

                <!--- Aşama Id' ye Göre Numune Fiyat Güncelleme --->
                <cfif isDefined("arguments.process_stage") and len(arguments.process_stage) and arguments.process_stage eq arguments.is_update_price>
                    <cfquery name="upd_sample_prod" datasource="#dsn3#">
                        UPDATE 
                            PRODUCT_SAMPLE 
                        SET 
                            SALES_PRICE = <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.paper_last_total)#"> 
                        WHERE 
                            PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_sample_id#"> 
                    </cfquery>
                </cfif>
                
                <!--- Ağaçtaki ilgili satırlar güncelleniyor --->
                <cfloop from="1" to="#arrayLen(arrData)#" index="i">
                    <cfquery name="upd_tree" datasource="#dsn3#">
                        UPDATE PRODUCT_TREE
                        SET 
                            FIRE_RATE = <cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(arrData[i]["FIRE_RATE"])#">,
                            FIRE_AMOUNT = <cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(arrData[i]["FIRE_AMOUNT_"])#">,
                            LAST_PRICE = <cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(arrData[i]["LAST_PRICE"])#">
                        WHERE 
                            PRODUCT_TREE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arrData[i]["PRODUCT_TREE_ID"]#">
                    </cfquery>
                </cfloop>

                <!--- money kayıtları --->
                <cfquery name="del_pricing_money_info" datasource="#dsn3#">
                    DELETE FROM SAMPLE_PRICING_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pricing_id#">
                </cfquery>

                <cfloop from="1" to="#arguments.kur_say#" index="i">
                    <cfquery name="PRICING_MONEY_INFO" datasource="#dsn3#">
                        INSERT INTO
                            SAMPLE_PRICING_MONEY 
                        (
                            ACTION_ID,
                            MONEY_TYPE,
                            RATE2,
                            RATE1,
                            IS_SELECTED
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pricing_id#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("arguments.hidden_rd_money_#i#")#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate("arguments.txt_rate2_#i#"))#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate("arguments.txt_rate1_#i#"))#">,
                            <cfif evaluate("arguments.hidden_rd_money_#i#") is arguments.currency_id>1<cfelse>0</cfif>
                        )
                    </cfquery>
                </cfloop>

                <cfif isDefined("arguments.process_stage") and len(arguments.process_stage)>
                    <cfset attributes.fuseaction = arguments.fuseaction>
                    <cf_workcube_process 
                        data_source = '#dsn3#'
                        is_upd='1' 
                        old_process_line='0'
                        process_stage='#arguments.process_stage#' 
                        record_member='#session.ep.userid#' 
                        record_date='#now()#'
                        action_table='PRODUCT_SAMPLE_PRICING'
                        action_column='PRODUCT_SAMPLE_ID'
                        action_id='#arguments.product_sample_id#'
                        action_page='index.cfm?fuseaction=prod.tree_purchase_plan_pricing&product_sample_id=#arguments.product_sample_id#'
                        warning_description='Numune - Fiyatlandırma'>
                </cfif>
                <cfset getPageContext().getCFOutput().clearAll()>
                <cfset getPageContext().getCFOutput().clearHeaderBuffers()>
                <cfset response = { status: true, pricing_id : arguments.pricing_id } />
                <cfcatch type="any">
                    <cfset response = { status: false } />
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn replace( serializeJSON( response ), '//', '' ) />
    </cffunction>

    <cffunction name="get_pricing" returntype="any">
        <cfquery name="get_pricing" datasource="#dsn3#">
            SELECT * FROM PRODUCT_SAMPLE_PRICING WHERE PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_sample_id#">
        </cfquery>
        <cfreturn get_pricing>
    </cffunction>
    <cffunction name="GET_SALES_OPPORTUNITY"     returntype="any">
        <cfargument name="PRODUCT_SAMPLE_ID" default="" >
        <cfquery name="OPPORTUNITY" datasource="#dsn3#">
        select
        PS.PRODUCT_sAMPLE_ID,
        O.OPP_ID,
        PS.OPPORTUNITY_ID,
        o.SALES_PARTNER_ID
        FROM
            PRODUCT_SAMPLE AS PS
            LEFT JOIN OPPORTUNITIES AS O ON O.OPP_ID= PS.OPPORTUNITY_ID
        WHERE PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_sample_id#">
        </cfquery>
        <cfquery name="GET_SALES_OPPORTUNITY" datasource="#dsn3#">
            SELECT SQ.SALES_QUOTA_ID,
            SQR.SALES_QUOTA_ID,
            O.COMPANY_ID,
            O.COMPANY_ID,
            SQR.SUPPLIER_ID,
            ROW_PREMIUM_=( SQR.ROW_PREMIUM_PERCENT + ' ' + SQR.ROW_PREMIUM_PERCENT2+ ' ' + SQR.ROW_PREMIUM_PERCENT3  ),
            SQ.PARTNER_ID,
            O.SALES_PARTNER_ID,
            PS.PRODUCT_SAMPLE_ID
             FROM 
            SALES_QUOTAS_ROW AS SQR
            LEFT JOIN SALES_QUOTAS AS SQ ON SQ.SALES_QUOTA_ID = SQR.SALES_QUOTA_ID
            LEFT JOIN OPPORTUNITIES AS O ON O.COMPANY_ID = SQR.SUPPLIER_ID
            LEFT JOIN PRODUCT_SAMPLE AS PS ON PS.OPPORTUNITY_ID = O.OPP_ID
            WHERE
            <cfif  len(OPPORTUNITY.SALES_PARTNER_ID)>
                SQ.PARTNER_ID = O.SALES_PARTNER_ID<cfelse>O.SALES_CONSUMER_ID=SQ.CONSUMER_ID
            </cfif>
             
            AND PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_sample_id#">
           
        </cfquery>
          <cfreturn GET_SALES_OPPORTUNITY>
        </cffunction>
    <cffunction name="get_pricing_money" returntype="any">
        <cfquery name="get_pricing_money" datasource="#DSN3#">
            SELECT MONEY_TYPE AS MONEY, RATE2, RATE1, 0 AS IS_SELECTED FROM SAMPLE_PRICING_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pricing_id#">
        </cfquery>
        <cfreturn get_pricing_money>
    </cffunction>

    <cffunction name="create_product_sample" access="remote" returntype="any" returnformat="JSON">
        <cfset response = structNew()>
        <cfset list="',""">
        <cfset list2=" , ">
        <cfset max_product_id="">
        <cfset arguments.product_sample_name = replacelist(arguments.product_sample_name,list,list2)><!--- ürün adına tek ve cift tirnak yazilmamali --->
        <cfset arguments.product_sample_name = trim(arguments.product_sample_name)>
            <cfquery name="CHECK_SAME" datasource="#DSN3#">
                SELECT PRODUCT_SAMPLE_ID FROM PRODUCT_SAMPLE WHERE PRODUCT_SAMPLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_sample_name#">
            </cfquery>
            <cfif check_same.recordcount>
                <cfset response.message = "#getLang('', 'Aynı İsimli Numune Mevcut', 64588)#">
                <cfset response.status = 0>
            <cfelse>
               <cftransaction>
                    <cftry> 
                        <cfquery name="ADD_PRODUCT_SAMPLE" datasource="#DSN3#">
                            INSERT INTO 
                                
                            #dsn3_alias#.PRODUCT_SAMPLE
                            (
                                PRODUCT_SAMPLE_NAME
                                ,PRODUCT_SAMPLE_CAT_ID
                                ,PRODUCT_CAT_ID
                                ,BRAND_ID
                                ,DESIGNER_EMP_ID
                                ,PROCESS_STAGE_ID
                                ,REFERENCE_PRODUCT_ID
                                ,OFFER_ID
                                ,ORDER_ID
                                ,TARGET_PRICE
                                ,SALES_PRICE
                                ,SALES_PRICE_CURRENCY
                                ,TARGET_PRICE_CURRENCY
                                ,TARGET_AMOUNT
                                ,TARGET_AMOUNT_UNITY
                                ,RECORD_EMP
                                ,RECORD_DATE
                                ,RECORD_IP
                                ,PARTNER_ID
                                )

                            VALUES 
                            (
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_sample_name#">,
                                0,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_catid#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#">,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,             
                                0,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                                0
                            )
                            SELECT @@IDENTITY AS MAX_PRODUCT_ID
                        </cfquery>
                        <cfquery name="GET_PID" datasource="#DSN3#">
                            SELECT MAX(PRODUCT_SAMPLE_ID) AS PRODUCT_SAMPLE_ID FROM PRODUCT_SAMPLE
                        </cfquery>
            
                        <cfquery name="DET_PRODUCT_SAMPLE_PROCESS" datasource="#DSN3#">
                            UPDATE #dsn1_alias#.PRODUCT
                            SET 
                                P_SAMPLE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PID.PRODUCT_SAMPLE_ID#">                           
                            WHERE 
                                PRODUCT_ID= #arguments.PRODUCT_ID# 
                         </cfquery>
 
                        <cfset response.status = 1>
                        <cfset response.message = "#getLang('','Numune başarılı bir şekilde tasarlandı.', 65331)#">
                        <cfcatch>   
                            <cfset response.status = 0>
                            <cfset response.message = "#getLang('','Kayıt sırasında bir sorun oluştu', 63437)#">
                        </cfcatch>
                    </cftry>
                </cftransaction>
            </cfif>
        <cfreturn replace( serializeJSON(response), "//", "" )>
    </cffunction>

</cfcomponent>
