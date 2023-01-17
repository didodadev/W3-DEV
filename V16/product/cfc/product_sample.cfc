<cfcomponent extends="cfc.faFunctions">
    <cfscript>
		functions = CreateObject("component","WMO.functions");
		filterNum = functions.filterNum;
        wrk_round = functions.wrk_round;
        getlang = functions.getlang;
	</cfscript>
    <cfset dsn = dsn_alias = application.systemParam.systemParam().dsn />
    <cfset dsn1 = dsn_product = dsn1_alias = '#dsn#_product' />
    <cfset dsn2 = dsn2_alias = '#dsn#_#session.ep.period_year#_#session.ep.company_id#' />
	<cfset dsn3 = dsn3_alias = '#dsn#_#session.ep.company_id#' />
    <cfset request.self = application.systemParam.systemParam().request.self />
    <cfset fusebox.process_tree_control = application.systemParam.systemParam().fusebox.process_tree_control>
    <cfset index_folder = application.systemParam.systemParam().index_folder >
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset database_type = application.systemParam.systemParam().database_type />
    <cfset dateformat_style = ( isdefined("session.ep.dateformat_style") and len(session.ep.dateformat_style) ) ? session.ep.dateformat_style : 'dd/mm/yyyy'>
    <cffunction  name="get_product_sample_cat"  returntype="any">
        <cfquery name="get_product_sample_cat" datasource="#DSN3#">
            SELECT
            PRODUCT_SAMPLE_CAT_ID,
            PRODUCT_SAMPLE_CAT
            FROM
                PRODUCT_SAMPLE_CAT
        </cfquery>
        <cfreturn get_product_sample_cat>
    </cffunction>
    <cffunction  name="GET_PRODUCT_CAT"  returntype="any">
        <cfargument name="product_catid" default="">
        <cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
            SELECT 
                PRODUCT_CATID,
                HIERARCHY,
                PRODUCT_CAT 
            FROM 
                PRODUCT_CAT
            
            <cfif isDefined("URL.ID")>
               WHERE PRODUCT_CATID = #URL.ID#
            </cfif>
            <cfif isDefined("arguments.product_catid") and len(arguments.product_catid)>
               WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_catid#">
            </cfif>
            ORDER BY 
                HIERARCHY
        </cfquery>
        <cfreturn GET_PRODUCT_CAT>
    </cffunction>
    <cffunction  name="GET_MONEYS"  returntype="any">
        <cfquery name="GET_MONEYS" datasource="#dsn#">
            SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#
        </cfquery>
        <cfreturn GET_MONEYS>
    </cffunction>    
    <cffunction  name="GET_PRODUCT_UNIT"  returntype="any">
        <cfquery name="GET_PRODUCT_UNIT" datasource="#dsn#">
          SELECT 
		CASE
			WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
			ELSE UNIT
                END AS UNIT,
                UNIT_ID 
            FROM 
                SETUP_UNIT
                LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_UNIT.UNIT_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="UNIT">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_UNIT">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
            ORDER BY UNIT  
        </cfquery>
        <cfreturn GET_PRODUCT_UNIT>
    </cffunction>
    <cffunction name="GET_PRODUCT_SAMPLE"  access="remote" returntype="any">
        <cfargument  name="PRODUCT_SAMPLE_ID" default="">
        <cfargument  name="opp_id" default="">
        <cfquery name="GET_PRODUCT_SAMPLE" datasource="#dsn3#">
            SELECT  
                PS.PRODUCT_SAMPLE_ID 
                , PS.PRODUCT_SAMPLE_NAME 
                , PS.PRODUCT_SAMPLE_CAT_ID 
                , PS.PRODUCT_CAT_ID 
                , PS.BRAND_ID 
                , PS.DESIGNER_EMP_ID 
                , PS.PROCESS_STAGE_ID 
                ,PS.COMPANY_ID
                , PS.PARTNER_ID
                , PS.CONSUMER_ID
                , PS.OPPORTUNITY_ID 
                , PS.OFFER_ID 
                , PS.ORDER_ID 
                , PS.SALES_PRICE
                , PS.SALES_PRICE_CURRENCY
                , PS.TARGET_PRICE 
                , PS.TARGET_PRICE_CURRENCY 
                , PS.TARGET_AMOUNT 
                , PS.TARGET_AMOUNT_UNITY 
                , PS.TARGET_DELIVERY_DATE 
                , PS.PRODUCT_SAMPLE_DETAIL 
                , PS.RECORD_DATE 
                ,CMP.FULLNAME
               ,CMP.COMPANY_ID as cmp_company_id
                ,CS.CONSUMER_ID
                ,CS.CONSUMER_NAME
                ,CS.CONSUMER_SURNAME
                , PS.RECORD_EMP 
                , PS.RECORD_IP 
                , PS.UPDATE_DATE 
                , PS.UPDATE_EMP 
                , PS.UPDATE_IP 
                , PS.REFERENCE_PRODUCT_ID 
                , PS.CUSTOMER_MODEL_NO
                ,P.PRODUCT_NAME
                ,P.PRODUCT_ID
                ,P.P_SAMPLE_ID
                ,O.OPP_ID
                ,O.OPP_HEAD
                ,O.OPP_NO
                ,O.SALES_EMP_ID
                ,O.SALES_PARTNER_ID
                ,O.SALES_CONSUMER_ID
                
            FROM 
                PRODUCT_SAMPLE AS PS
                LEFT JOIN #DSN1#.PRODUCT AS P ON P.PRODUCT_ID = PS.REFERENCE_PRODUCT_ID
                LEFT JOIN OPPORTUNITIES AS O ON O.OPP_ID = PS.OPPORTUNITY_ID
                LEFT JOIN #DSN#.COMPANY AS CMP ON CMP.COMPANY_ID = O.COMPANY_ID
                LEFT JOIN #DSN#.CONSUMER AS CS ON CS.CONSUMER_ID = O.CONSUMER_ID
               
            WHERE
            PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_SAMPLE_ID#"> 
            <cfif isdefined("arguments.opp_id") and len(arguments.opp_id) >
                    AND  PS.OPPORTUNITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.opp_id#">
                </cfif>
        </cfquery>
        <cfreturn GET_PRODUCT_SAMPLE>
    </cffunction> 
    <cffunction name="GET_OPPORTUNITY_SAMPLE"  access="remote" returntype="any">
        <cfargument  name="PRODUCT_SAMPLE_ID" default="">
        <cfargument  name="opp_id" default="">
        <cfquery name="GET_OPPORTUNITY_SAMPLE" datasource="#dsn3#">
            SELECT  
                PS.PRODUCT_SAMPLE_ID 
                , PS.PRODUCT_SAMPLE_NAME 
                , PS.PRODUCT_SAMPLE_CAT_ID 
                , PS.PRODUCT_CAT_ID 
                , PS.BRAND_ID 
                , PS.DESIGNER_EMP_ID 
                , PS.PROCESS_STAGE_ID 
                ,O.COMPANY_ID
                , O.PARTNER_ID
                , O.CONSUMER_ID
                ,O.SALES_CONSUMER_ID
                ,O.SALES_PARTNER_ID
                , PS.OPPORTUNITY_ID 
                , PS.OFFER_ID 
                , PS.ORDER_ID 
                , PS.SALES_PRICE
                , PS.SALES_PRICE_CURRENCY
                , PS.TARGET_PRICE 
                , PS.TARGET_PRICE_CURRENCY 
                , PS.TARGET_AMOUNT 
                , PS.TARGET_AMOUNT_UNITY 
                , PS.TARGET_DELIVERY_DATE 
                , PS.PRODUCT_SAMPLE_DETAIL 
                , PS.RECORD_DATE 
                ,CMP.FULLNAME
               ,CMP.COMPANY_ID as cmp_company_id
                ,CS.CONSUMER_ID
                ,CS.CONSUMER_NAME
                ,CS.CONSUMER_SURNAME
                , PS.RECORD_EMP 
                , PS.RECORD_IP 
                , PS.UPDATE_DATE 
                , PS.UPDATE_EMP 
                , PS.UPDATE_IP 
                , PS.REFERENCE_PRODUCT_ID 
                , PS.CUSTOMER_MODEL_NO
                ,P.PRODUCT_NAME
                ,P.PRODUCT_ID
                ,P.P_SAMPLE_ID
                ,O.OPP_ID
                ,O.OPP_HEAD
                ,O.OPP_NO
                ,O.SALES_EMP_ID
                ,O.SALES_PARTNER_ID
            FROM 
                PRODUCT_SAMPLE AS PS
                LEFT JOIN #DSN1#.PRODUCT AS P ON P.PRODUCT_ID = PS.REFERENCE_PRODUCT_ID
                LEFT JOIN OPPORTUNITIES AS O ON O.OPP_ID = PS.OPPORTUNITY_ID
                LEFT JOIN #DSN#.COMPANY AS CMP ON CMP.COMPANY_ID = O.COMPANY_ID
                LEFT JOIN #DSN#.CONSUMER AS CS ON CS.CONSUMER_ID = O.CONSUMER_ID
               
            WHERE
            PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_SAMPLE_ID#"> 
            <cfif isdefined("arguments.opp_id") and len(arguments.opp_id) >
                    AND  PS.OPPORTUNITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.opp_id#">
                </cfif>
        </cfquery>
        <cfreturn GET_OPPORTUNITY_SAMPLE>
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
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%product.product_sample%">
            ORDER BY 
                PTR.LINE_NUMBER
        </cfquery>
        <cfreturn GET_PROCESS_STAGE>
    </cffunction> 
    <cffunction name="LIST_PRODUCT_SAMPLE"  access="remote" returntype="any">
        <cfargument  name="keyword" default="">
        <cfargument  name="PRODUCT_SAMPLE_ID" default="">
        <cfargument  name="customer_model_no" default="">
        <cfargument  name="consumer_id" default="">
        <cfargument  name="company_id" default="">
        <cfargument  name="company_name" default="">
        <cfargument  name="process_stage" default="">
        <cfargument  name="product_sample_cat_id" default="">
        <cfargument  name="product_cat_id" default="">
        <cfargument  name="brand_id" default="">
        <cfargument  name="brand_name" default="">
        <cfargument  name="designer_emp_id" default="">
        <cfargument  name="designer_emp" default="">
        <cfargument  name="reference_product_id" default="">
        <cfargument  name="opp_id" default="">
        <cfargument  name="opp_head" default="">
        <cfquery name="LIST_PRODUCT_SAMPLE" datasource="#dsn3#">
            SELECT  
                 PS.PRODUCT_SAMPLE_ID 
                , PS.PRODUCT_SAMPLE_NAME 
                , PS.PRODUCT_SAMPLE_CAT_ID 
                , PS.PRODUCT_CAT_ID 
                , PS.BRAND_ID 
                , PS.DESIGNER_EMP_ID 
                , PS.PROCESS_STAGE_ID 
                , O.COMPANY_ID 
                , O.CONSUMER_ID
                ,O.PARTNER_ID
                , PS.OPPORTUNITY_ID 
                , PS.OFFER_ID 
                , PS.ORDER_ID 
                , PS.TARGET_PRICE 
                , PS.TARGET_PRICE_CURRENCY 
                , PS.TARGET_AMOUNT 
                , PS.TARGET_AMOUNT_UNITY 
                , PS.TARGET_DELIVERY_DATE 
                , PS.PRODUCT_SAMPLE_DETAIL 
                , PS.RECORD_DATE 
                ,CMP.FULLNAME
                ,CMP.COMPANY_ID as cmp_company_id
                ,CS.CONSUMER_ID
                ,CS.CONSUMER_NAME
                ,CS.CONSUMER_SURNAME
                , PS.RECORD_EMP 
                , PS.RECORD_IP 
                , PS.UPDATE_DATE 
                , PS.UPDATE_EMP 
                , PS.UPDATE_IP 
                , PS.REFERENCE_PRODUCT_ID 
                , PS.CUSTOMER_MODEL_NO
                ,P.PRODUCT_NAME
                ,P.PRODUCT_ID
                ,O.OPP_ID
                ,O.OPP_HEAD
                ,PSC.PRODUCT_SAMPLE_CAT_ID
                ,PSC.PRODUCT_SAMPLE_CAT
                ,PC.PRODUCT_CATID
                ,PC.PRODUCT_CAT 
                ,PB.BRAND_ID
                ,PB.BRAND_NAME
                ,UNIT
                ,UNIT_ID 
                ,PTR.STAGE
                ,PTR.PROCESS_ROW_ID 
                ,O.OPP_NO
                ,O.SALES_EMP_ID
                ,PS.SALES_PRICE_CURRENCY 
                ,PS.SALES_PRICE, P.P_SAMPLE_ID
               
            FROM 
                PRODUCT_SAMPLE AS PS
                LEFT JOIN #DSN1#.PRODUCT AS P ON P.P_SAMPLE_ID = PS.PRODUCT_SAMPLE_ID
                LEFT JOIN OPPORTUNITIES AS O ON O.OPP_ID= PS.OPPORTUNITY_ID
                LEFT JOIN #DSN#.COMPANY AS CMP ON CMP.COMPANY_ID = O.COMPANY_ID
                LEFT JOIN #DSN#.CONSUMER AS CS ON CS.CONSUMER_ID = O.CONSUMER_ID
                LEFT JOIN PRODUCT_SAMPLE_CAT PSC ON PS.PRODUCT_SAMPLE_CAT_ID = PSC.PRODUCT_SAMPLE_CAT_ID
                LEFT JOIN PRODUCT_CAT AS PC ON PC.PRODUCT_CATID = PS.PRODUCT_CAT_ID
                LEFT JOIN PRODUCT_BRANDS AS PB ON PB.BRAND_ID = PS.BRAND_ID
                LEFT JOIN #dsn#.SETUP_UNIT AS  SU ON SU.UNIT_ID = PS.TARGET_AMOUNT_UNITY
                LEFT JOIN #dsn#.PROCESS_TYPE_ROWS AS  PTR ON PTR.PROCESS_ROW_ID = PS.PROCESS_STAGE_ID
                
               
            WHERE 1=1
            <cfif isdefined("arguments.PRODUCT_SAMPLE_ID") and len(arguments.PRODUCT_SAMPLE_ID)>
                AND  PS.PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_SAMPLE_ID#"> 
           </cfif>
                <cfif isdefined("arguments.PRODUCT_SAMPLE_ID") and len(arguments.keyword)>
                    AND  PS.PRODUCT_SAMPLE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                </cfif>
                <cfif isdefined("arguments.company_id") and len(arguments.company_id) and len(arguments.company_name)>
                    AND  O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                    <cfelseif isdefined("arguments.consumer_id") and len(arguments.consumer_id) and len(arguments.company_name)>
                    AND  O.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                </cfif>
                <cfif isdefined("arguments.customer_model_no") and len(arguments.customer_model_no) >
                    AND  PS.customer_model_no = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.customer_model_no#">
                </cfif>
                <cfif isdefined("arguments.opp_id") and len(arguments.opp_id) >
                    AND  PS.OPPORTUNITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.opp_id#">
                </cfif>
                <cfif listlen(arguments.process_stage)>
                    AND PS.PROCESS_STAGE_ID IN (#arguments.process_stage#)
                </cfif>
                <cfif  listlen(arguments.product_sample_cat_id)>
                    AND PS.PRODUCT_SAMPLE_CAT_ID IN (#arguments.product_sample_cat_id#)
                </cfif>
                <cfif isdefined("arguments.product_cat_id") and len(arguments.product_cat_id)>
                    AND PS.PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id#">
                </cfif>
                <cfif isdefined("arguments.brand_id") and len(arguments.brand_id) and len(arguments.brand_name)>
                    AND PS.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#">
                </cfif>
                <cfif isdefined("arguments.designer_emp_id") and len(arguments.designer_emp_id) and len(arguments.designer_emp)>
                    AND PS.DESIGNER_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.designer_emp_id#">
                </cfif>
                <cfif isdefined("arguments.reference_product_id") and len(arguments.reference_product_id)>
                    AND PS.REFERENCE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reference_product_id#">
                </cfif>
        </cfquery>
        <cfreturn LIST_PRODUCT_SAMPLE>
    </cffunction>
    <cffunction  name="GET_OPPORTUNITY" access="remote" returntype="any">
        <cfargument  name="opp_id" default="">
        <cfquery name="GET_OPPORTUNITY" datasource="#DSN3#">
            SELECT 
               OP.*,
               PS.OPPORTUNITY_ID
            FROM 
                
                OPPORTUNITIES AS OP
                LEFT JOIN PRODUCT_SAMPLE AS PS ON OP.OPP_ID= PS.OPPORTUNITY_ID
            WHERE 
               1=1
        </cfquery>
        <cfreturn GET_OPPORTUNITY>
    </cffunction> 
    <cffunction name="GET_PRODUCT_SAMPLE_IMAGE" access="remote" returntype="query">
        <cfargument  name="PRODUCT_SAMPLE_ID" default="">
        <cfquery name="GET_PRODUCT_SAMPLE_IMAGE" datasource="#dsn3#">
                SELECT 
                PRODUCT_SAMPLE_IMAGE_ID 
                ,PRODUCT_SAMPLE_ID
                , PRODUCT_SAMPLE_PATH 
                , IS_EXTERNAL_LINK 
                , PRODUCT_SAMPLE_IMG_NAME AS NAME
                , PRODUCT_SAMPLE_IMG_DETAIL  AS DETAIL
                , IMAGE_SIZE 
                , VIDEO_PATH 
                , VIDEO_LINK 
                , LANGUAGE_ID 
                , RECORD_EMP 
                , RECORD_DATE 
                , RECORD_IP 
                , UPDATE_EMP 
                , UPDATE_DATE 
                , UPDATE_IP 
                FROM 
                    PRODUCT_SAMPLE_IMAGE 
                WHERE 
                 PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_SAMPLE_ID#">
        </cfquery>
        <cfreturn GET_PRODUCT_SAMPLE_IMAGE>
    </cffunction> 
    <cffunction name="GET_STOCK_DETAIL" access="remote" >
        <cfargument  name="PRODUCT_SAMPLE_ID" default="">
        <cfquery name="GET_STOCK_DETAIL" datasource="#dsn1#">
            SELECT
                S.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.STOCK_CODE_2,
                S.PROPERTY,
                S.STOCK_STATUS,
                S.BARCOD,
                S.ASSORTMENT_DEFAULT_AMOUNT,
                P.PRODUCT_ID,
                P.P_SAMPLE_ID
            FROM
                STOCKS S INNER JOIN PRODUCT_UNIT AS PU ON PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID
                LEFT JOIN #dsn1#.PRODUCT AS P on  S.PRODUCT_ID = P.PRODUCT_ID 
                LEFT JOIN #dsn3#.PRODUCT_SAMPLE PS ON PS.PRODUCT_SAMPLE_ID=P.P_SAMPLE_ID
            WHERE
            PS.PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_SAMPLE_ID#">
        </cfquery>
        <cfreturn GET_STOCK_DETAIL>
    </cffunction> 
    <cffunction name="get_price_exceptions_pid" access="remote" returntype="query">
        <cfquery name="get_price_exceptions_pid" dbtype="query">
            SELECT  SUM(ASSORTMENT_DEFAULT_AMOUNT) AS ASSORTMENT FROM GET_STOCK_DETAIL
        </cfquery>
        <cfreturn get_price_exceptions_pid>
    </cffunction> 
    <cffunction  name="get" access="public">
        <cfargument  name="PRODUCT_SAMPLE_ID" default="">
         <cfreturn GET_PRODUCT_SAMPLE(PRODUCT_SAMPLE_ID=arguments.PRODUCT_SAMPLE_ID)> 
    </cffunction> 
    <cffunction  name="DET_PRODUCT_SAMPLE"  access="public" returntype="any">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
        <cf_get_lang_set module_name="product">
        <cftry>
        <cfquery name="DET_PRODUCT_SAMPLE" datasource="#dsn3#" >
            UPDATE PRODUCT_SAMPLE
            SET 
                PRODUCT_SAMPLE_NAME=<cfif isdefined("arguments.PRODUCT_SAMPLE_NAME") and len(arguments.PRODUCT_SAMPLE_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_SAMPLE_NAME#"><cfelse>NULL</cfif>,
                PRODUCT_SAMPLE_CAT_ID=<cfif isdefined("arguments.PRODUCT_SAMPLE_CAT_ID") and len(arguments.PRODUCT_SAMPLE_CAT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_SAMPLE_CAT_ID#"><cfelse>NULL</cfif>,
                PRODUCT_CAT_ID =<cfif isdefined("arguments.PRODUCT_CAT_ID") and len(arguments.PRODUCT_CAT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_CAT_ID#"><cfelse>NULL</cfif>,  
                BRAND_ID=<cfif isdefined("arguments.BRAND_ID") and len(arguments.BRAND_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.BRAND_ID#"><cfelse>NULL</cfif>,
                DESIGNER_EMP_ID=<cfif isdefined("arguments.DESIGNER_EMP_ID") and len(arguments.DESIGNER_EMP_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.DESIGNER_EMP_ID#"><cfelse>NULL</cfif>,
                PROCESS_STAGE_ID=<cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam value = "#arguments.process_stage#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                COMPANY_ID =<cfif isdefined("arguments.COMPANY_ID") and len(arguments.COMPANY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMPANY_ID#"><cfelse>NULL</cfif>,
                CONSUMER_ID =<cfif isdefined("arguments.CONSUMER_ID") and len(arguments.CONSUMER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CONSUMER_ID#"><cfelse>NULL</cfif>,
                REFERENCE_PRODUCT_ID=<cfif isdefined("arguments.REFERENCE_PRODUCT_ID") and len(arguments.REFERENCE_PRODUCT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.REFERENCE_PRODUCT_ID#"><cfelse>NULL</cfif>,
                CUSTOMER_MODEL_NO=<cfif isdefined("arguments.CUSTOMER_MODEL_NO") and len(arguments.CUSTOMER_MODEL_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CUSTOMER_MODEL_NO#"><cfelse>NULL</cfif>,
                OPPORTUNITY_ID=<cfif isdefined("arguments.OPPORTUNITY_ID") and len(arguments.OPPORTUNITY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.OPPORTUNITY_ID#"><cfelse>NULL</cfif>,
                OFFER_ID=<cfif isdefined("arguments.OFFER_ID") and len(arguments.OFFER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.OFFER_ID#"><cfelse>NULL</cfif>,
                ORDER_ID=<cfif isdefined("arguments.ORDER_ID") and len(arguments.ORDER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ORDER_ID#"><cfelse>NULL</cfif>,
                TARGET_PRICE=<cfif isdefined("arguments.TARGET_PRICE") and len(arguments.TARGET_PRICE)><cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.TARGET_PRICE,4)#"><cfelse>NULL</cfif>,
                SALES_PRICE=<cfif isdefined("arguments.SALES_PRICE") and len(arguments.SALES_PRICE)><cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.SALES_PRICE,4)#"><cfelse>NULL</cfif>,
                SALES_PRICE_CURRENCY=<cfif isdefined("arguments.SALES_PRICE_CURRENCY") and len(arguments.SALES_PRICE_CURRENCY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SALES_PRICE_CURRENCY#"><cfelse>NULL</cfif>, 
                TARGET_PRICE_CURRENCY=<cfif isdefined("arguments.TARGET_PRICE_CURRENCY") and len(arguments.TARGET_PRICE_CURRENCY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TARGET_PRICE_CURRENCY#"><cfelse>NULL</cfif>, 
                TARGET_AMOUNT=<cfif isdefined("arguments.TARGET_AMOUNT") and len(arguments.TARGET_AMOUNT)><cfqueryparam cfsqltype="CF_SQL_BIGINT" value="#arguments.TARGET_AMOUNT#"><cfelse>NULL</cfif>,
                TARGET_AMOUNT_UNITY=<cfif isdefined("arguments.TARGET_AMOUNT_UNITY") and len(arguments.TARGET_AMOUNT_UNITY)><cfqueryparam cfsqltype="CF_SQL_BIGINT" value="#arguments.TARGET_AMOUNT_UNITY#"><cfelse>NULL</cfif>,
                TARGET_DELIVERY_DATE=<cfif isdefined("arguments.TARGET_DELIVERY_DATE") and len(arguments.TARGET_DELIVERY_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.TARGET_DELIVERY_DATE#"><cfelse>NULL</cfif>,
                PRODUCT_SAMPLE_DETAIL=<cfif isdefined("arguments.PRODUCT_SAMPLE_DETAIL") and len(arguments.PRODUCT_SAMPLE_DETAIL) ><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_SAMPLE_DETAIL#"><cfelse>NULL</cfif>,
                UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,    
                UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                PARTNER_ID= <cfif isdefined("arguments.PARTNER_ID") and len(arguments.PARTNER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PARTNER_ID#"><cfelse>NULL</cfif>
            WHERE 
                PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_SAMPLE_ID#">
        </cfquery>
      <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)>
			<cf_workcube_process 
			is_upd='1' 
            old_process_line='#arguments.old_process_line#'
			process_stage='#arguments.process_stage#' 
			record_member='#session.ep.userid#'
			record_date='#now()#' 
			action_table='PRODUCT_SAMPLE'
			action_column='PRODUCT_SAMPLE_ID'
			action_id='#arguments.PRODUCT_SAMPLE_ID#' 
			action_page='#request.self#?fuseaction=product.product_sample&event=upd&product_sample_id=#arguments.PRODUCT_SAMPLE_ID#' 
			<!--- warning_description='<strong>#get_service1.service_head#</strong><br/><br/>#get_service1.service_detail#' --->>
        </cfif>
                <cfset responseStruct.message = "İşlem Başarılı">
                <cfset responseStruct.status = true>
                <cfset responseStruct.error = {}>
                <cfset responseStruct.identity = ''>
                <cfcatch>
                    <cftransaction action="rollback">
                    <cfset responseStruct.message = "İşlem Hatalı">
                    <cfset responseStruct.status = false>
                    <cfset responseStruct.error = cfcatch>
                </cfcatch>
            </cftry>
        <cfreturn responseStruct>
    </cffunction>
    <cffunction  name="DET_PRODUCT_SAMPLE_PROCESS"  access="remote" returntype="any">
             <cfset attributes = arguments>
             <cfset responseStruct = structNew()>
             <cf_get_lang_set module_name="product">
             <cftry>
                 <cfif isDefined("arguments.TARGET_DELIVERY_DATE") and len(arguments.TARGET_DELIVERY_DATE)> 
                     <cf_date tarih="arguments.TARGET_DELIVERY_DATE">
                </cfif>
                 <cfloop list="#arguments.PRODUCT_SAMPLE_ID#" index="i">
                         <cfquery name="DET_PRODUCT_SAMPLE_PROCESS" datasource="#dsn3#" >
                             UPDATE PRODUCT_SAMPLE
                             SET 
                                 PROCESS_STAGE_ID=<cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam value = "#arguments.process_stage#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                                 TARGET_DELIVERY_DATE=<cfif isdefined("arguments.TARGET_DELIVERY_DATE") and len(arguments.TARGET_DELIVERY_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.TARGET_DELIVERY_DATE#"><cfelse>NULL</cfif>,
                                 UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,    
                                 UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_emp_id#">,
                                 UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                             WHERE 
                                 PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                         </cfquery>
                         <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)>
                             <cf_workcube_process 
                             is_upd='1' 
                             old_process_line='#arguments.old_process_line#'
                             process_stage='#arguments.process_stage#' 
                             record_member='#session.ep.userid#'
                             record_date='#now()#' 
                             action_table='PRODUCT_SAMPLE'
                             action_column='PRODUCT_SAMPLE_ID'
                             action_id='#i#' 
                             action_page='#request.self#?fuseaction=product.product_sample&event=upd&product_sample_id=#i#' 
                             <!--- warning_description='<strong>#get_service1.service_head#</strong><br/><br/>#get_service1.service_detail#' --->>
                         </cfif>
                     </cfloop>
                     <cfset responseStruct.message = "İşlem Başarılı">
                     <cfset responseStruct.status = true>
                     <cfset responseStruct.error = {}>
                     <cfset responseStruct.identity = ''>
                     <script>
                         history.back();
                     </script>
                     <cfcatch>
                         <cftransaction action="rollback">
                         <cfset responseStruct.message = "İşlem Hatalı">
                         <cfset responseStruct.status = false>
                         <cfset responseStruct.error = cfcatch>
                     </cfcatch>
                 </cftry>
             <cfreturn responseStruct>
           
         </cffunction>
    <cffunction  name="ADD_PRODUCT_SAMPLE"  access="public" returntype="any" hint="Numune Ekleme">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
        <cf_get_lang_set module_name="product">
        <cftry>
            <cfquery name="ADD_PRODUCT_SAMPLE" datasource="#dsn3#"  result="my_result">
                INSERT INTO PRODUCT_SAMPLE
                (
                PRODUCT_SAMPLE_NAME
                    ,PRODUCT_SAMPLE_CAT_ID
                    ,PRODUCT_CAT_ID
                    ,BRAND_ID
                    ,DESIGNER_EMP_ID
                    ,PROCESS_STAGE_ID
                    ,COMPANY_ID
                    ,CONSUMER_ID
                    ,REFERENCE_PRODUCT_ID
                    ,CUSTOMER_MODEL_NO
                    ,OPPORTUNITY_ID
                    ,OFFER_ID
                    ,ORDER_ID
                    ,TARGET_PRICE
                    ,SALES_PRICE
                    ,SALES_PRICE_CURRENCY
                    ,TARGET_PRICE_CURRENCY
                    ,TARGET_AMOUNT
                    ,TARGET_AMOUNT_UNITY
                    ,TARGET_DELIVERY_DATE
                    ,PRODUCT_SAMPLE_DETAIL
                    ,RECORD_EMP
                    ,RECORD_DATE
                    ,RECORD_IP
                    ,PARTNER_ID
                    )
                VALUES(
                
                    <cfif isdefined("arguments.PRODUCT_SAMPLE_NAME") and len(arguments.PRODUCT_SAMPLE_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_SAMPLE_NAME#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.PRODUCT_SAMPLE_CAT_ID") and len(arguments.PRODUCT_SAMPLE_CAT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_SAMPLE_CAT_ID#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.PRODUCT_CAT_ID") and len(arguments.PRODUCT_CAT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_CAT_ID#"><cfelse>NULL</cfif>,  
                    <cfif isdefined("arguments.BRAND_ID") and len(arguments.BRAND_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.BRAND_ID#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.DESIGNER_EMP_ID") and len(arguments.DESIGNER_EMP_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.DESIGNER_EMP_ID#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam value = "#arguments.process_stage#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.COMPANY_ID") and len(arguments.COMPANY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMPANY_ID#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.CONSUMER_ID") and len(arguments.CONSUMER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CONSUMER_ID#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.REFERENCE_PRODUCT_ID") and len(arguments.REFERENCE_PRODUCT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.REFERENCE_PRODUCT_ID#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.CUSTOMER_MODEL_NO") and len(arguments.CUSTOMER_MODEL_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CUSTOMER_MODEL_NO#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.OPPORTUNITY_ID") and len(arguments.OPPORTUNITY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.OPPORTUNITY_ID#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.OFFER_ID") and len(arguments.OFFER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.OFFER_ID#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.ORDER_ID") and len(arguments.ORDER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ORDER_ID#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.TARGET_PRICE") and len(arguments.TARGET_PRICE)><cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.TARGET_PRICE,4)#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.SALES_PRICE") and len(arguments.SALES_PRICE)><cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.SALES_PRICE,4)#"><cfelse>NULL</cfif>, 
                    <cfif isdefined("arguments.SALES_PRICE_CURRENCY") and len(arguments.SALES_PRICE_CURRENCY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SALES_PRICE_CURRENCY#"><cfelse>NULL</cfif>, 
                    <cfif isdefined("arguments.TARGET_PRICE_CURRENCY") and len(arguments.TARGET_PRICE_CURRENCY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TARGET_PRICE_CURRENCY#"><cfelse>NULL</cfif>, 
                    <cfif isdefined("arguments.TARGET_AMOUNT") and len(arguments.TARGET_AMOUNT)><cfqueryparam cfsqltype="CF_SQL_BIGINT" value="#arguments.TARGET_AMOUNT#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.TARGET_AMOUNT_UNITY") and len(arguments.TARGET_AMOUNT_UNITY)><cfqueryparam cfsqltype="CF_SQL_BIGINT" value="#arguments.TARGET_AMOUNT_UNITY#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.TARGET_DELIVERY_DATE") and len(arguments.TARGET_DELIVERY_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.TARGET_DELIVERY_DATE#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.PRODUCT_SAMPLE_DETAIL") and len(arguments.PRODUCT_SAMPLE_DETAIL) ><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_SAMPLE_DETAIL#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfif isdefined("arguments.PARTNER_ID") and len(arguments.PARTNER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PARTNER_ID#"><cfelse>NULL</cfif>
                )
            </cfquery>
             <cfquery name="GET_MAX_ORDER" datasource="#dsn3#" maxrows="1">
                SELECT * FROM PRODUCT_SAMPLE   
                ORDER BY 
                    PRODUCT_SAMPLE_ID DESC
            </cfquery>
            <cfset attributes.is_upd = 0>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = GET_MAX_ORDER.PRODUCT_SAMPLE_ID>
            <cfcatch>
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>
    <cffunction name="DEL_PRODUCT_SAMPLE"  access="remote" returntype="any">
        <cftry>
            <cfquery name="DEL_PRODUCT_SAMPLE" datasource="#dsn3#">
                DELETE FROM PRODUCT_SAMPLE WHERE PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_SAMPLE_ID#">
            </cfquery>
           <cfset responseStruct.message = "İşlem Başarılı">
           <cfset responseStruct.status = true>
           <cfset responseStruct.error = {}>
           <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>
    <cffunction name="create_sample_product" access="remote" returntype="any" returnformat="JSON">
        <cfset response = structNew()>
        <cfset list="',""">
        <cfset list2=" , ">
        <cfset max_product_id="">
        <cfset arguments.product_name = replacelist(arguments.PRODUCT_NAME,list,list2)><!--- ürün adına tek ve cift tirnak yazilmamali --->
        <cfset arguments.product_name = trim(arguments.PRODUCT_NAME)>
            <cfquery name="CHECK_SAME" datasource="#DSN1#">
                SELECT PRODUCT_ID FROM PRODUCT WHERE PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_name#">
            </cfquery>
            <cfif check_same.recordcount>
                <cfset response.message = "#getLang('', 'Aynı isimli ürün mevcut.', 37704)#">
                <cfset response.status = 0>
            <cfelse>
                <cfquery name="CHECK_BARCODE" datasource="#DSN1#">
                    SELECT STOCK_ID FROM GET_STOCK_BARCODES_ALL WHERE BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#">
                </cfquery>
                <cfif check_barcode.recordcount>
                    <cfset response.message = "#getLang('', 'Aynı barkod mevcut.', 37893)#">
                    <cfset response.status = 0>
                <cfelse>
                    <cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
                        SELECT IS_BRAND_TO_CODE,IS_PRODUCT_COMPANY FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                    </cfquery>
                    <cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
                        SELECT HIERARCHY,STOCK_CODE_COUNTER FROM PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_catid#">
                    </cfquery>

                    <cfif not (len(get_product_cat.stock_code_counter) And get_product_cat.stock_code_counter neq 0) >
                        <cfset arguments.product_code = "#trim(arguments.product_code)#">
                    <cfelse>
                        <cfset arguments.product_code=get_product_cat.stock_code_counter>
                        <cfquery name="upd_stock_code_counter" datasource="#DSN1#">
                            UPDATE PRODUCT_CAT SET STOCK_CODE_COUNTER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_code + 1#"> WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
                        </cfquery>
                    </cfif>
                    <cfset arguments.product_code = "#get_product_cat.hierarchy#.#arguments.product_code#">
                    <!--- ürün kodu oluştu --->
                    <cfquery name="CHECK_SAME" datasource="#DSN1#">
                        SELECT PRODUCT_CODE FROM PRODUCT WHERE PRODUCT.PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.product_code#">
                    </cfquery>
                    <cfif check_same.recordcount>
                        <cfset response.message = "#getLang('', 'Girdiğiniz ürün kodu mevcut.', 37895)#">
                        <cfset response.status = 0>
                    <cfelse>
                        <cfset get_codes.recordcount = 0>
                        <cfset bugun_00 = DateFormat(now(),dateformat_style)>
                        <cf_date tarih='bugun_00'>
                        <cftransaction>
                            <cftry> 
                                <cfquery name="ADD_PRODUCT" datasource="#DSN3#">
                                    INSERT INTO 
                                        #dsn1_alias#.PRODUCT
                                    (
                                        PRODUCT_STATUS,
                                        P_SAMPLE_ID,
                                        BRAND_ID,
                                        IS_SAMPLE,
                                        IS_QUALITY,
                                        IS_COST,
                                        IS_INVENTORY,
                                        IS_PRODUCTION,
                                        IS_SALES,
                                        IS_PURCHASE,
                                        IS_PROTOTYPE,
                                        IS_TERAZI,
                                        IS_SERIAL_NO,
                                        IS_ZERO_STOCK,
                                        IS_KARMA,
                                        IS_LIMITED_STOCK,
                                        IS_LOT_NO,
                                        PRODUCT_CATID,
                                        PRODUCT_NAME,
                                        TAX,
                                        TAX_PURCHASE,
                                        BARCOD,
                                        RECORD_DATE,
                                        RECORD_MEMBER,
                                        MEMBER_TYPE,
                                        PRODUCT_CODE,
                                        IS_INTERNET,
                                        IS_EXTRANET,
                                        MIN_MARGIN,
                                        MAX_MARGIN,
                                        OTV,
                                        RECORD_BRANCH_ID,
                                        IS_COMMISSION,
                                        IS_GIFT_CARD,
                                        IS_WATALOGY_INTEGRATED
                                    )
                                    VALUES 
                                    (
                                        0,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_sample_id#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#">,
                                        1,
                                        0,
                                        0,
                                        0,
                                        1,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_CATID#">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_NAME#">,
                                        0,
                                        0,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#">,
                                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.USERKEY#">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_CODE#">,
                                        0,
                                        0,             
                                        0,
                                        0,
                                        0,
                                        <cfif session.ep.isBranchAuthorization><cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                                        0,
                                        0,
                                        0
                                    )
                                    SELECT @@IDENTITY AS MAX_PRODUCT_ID
                                </cfquery>
                                <cfquery name="GET_PID" datasource="#DSN3#">
                                    SELECT MAX(PRODUCT_ID) AS PRODUCT_ID FROM #dsn1_alias#.PRODUCT
                                </cfquery>
                                <cfset unit_id = "1,Adet"> <!--- Dinamik hale getirilecek. --->
                                <cfset pid = GET_PID.PRODUCT_ID>
                                <cfquery name="ADD_MAIN_UNIT" datasource="#DSN3#">
                                    INSERT INTO
                                        #dsn1_alias#.PRODUCT_UNIT 
                                    (
                                        PRODUCT_ID, 
                                        PRODUCT_UNIT_STATUS, 
                                        MAIN_UNIT_ID, 
                                        MAIN_UNIT, 
                                        UNIT_ID, 
                                        ADD_UNIT,
                                        IS_MAIN,
                                        IS_SHIP_UNIT,
                                        RECORD_EMP,
                                        RECORD_DATE
                        
                                    )
                                    VALUES 
                                    (
                                        #GET_PID.PRODUCT_ID#,
                                        1,
                                        #LISTGETAT(UNIT_ID,1)#,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#LISTGETAT(UNIT_ID,2)#">,
                                        #LISTGETAT(UNIT_ID,1)#,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#LISTGETAT(UNIT_ID,2)#">,
                                        1,
                                        <cfif isdefined('is_ship_unit')>1<cfelse>0</cfif>,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                                    )					
                                </cfquery>
                                <cfquery name="GET_MAX_UNIT" datasource="#DSN3#">
                                    SELECT MAX(PRODUCT_UNIT_ID) AS MAX_UNIT FROM #dsn1_alias#.PRODUCT_UNIT
                                </cfquery>
                                  
                                <cfset purchase_kdvsiz = 0>
                                <cfset purchase_kdvli = 0>
                                <cfset purchase_is_tax_included = 0>
                                <cfset price_kdvsiz = 0>
                                <cfset price_kdvli = 0>
                                <cfset price_is_tax_included = 0>
                                
                                <!--- purchasesales is 0 / alış fiyatı --->
                                <cfquery name="ADD_STD_PRICE" datasource="#DSN3#">
                                    INSERT INTO
                                        #dsn1_alias#.PRICE_STANDART
                                    (
                                        PRODUCT_ID, 
                                        PURCHASESALES, 
                                        PRICE, 
                                        PRICE_KDV,
                                        IS_KDV,
                                        ROUNDING,
                                        MONEY,
                                        START_DATE,
                                        RECORD_DATE,
                                        PRICESTANDART_STATUS,
                                        UNIT_ID,
                                        RECORD_EMP
                                    )
                                    VALUES
                                    (
                                        #GET_PID.PRODUCT_ID#,
                                        0,
                                        #purchase_kdvsiz#,
                                        #purchase_kdvli#,
                                        #purchase_is_tax_included#,
                                        0,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="TL">,
                                        #bugun_00#,
                                        #NOW()#,
                                        1,
                                        #GET_MAX_UNIT.MAX_UNIT#,
                                        #SESSION.EP.USERID#
                                    )
                                </cfquery>
                                <!--- purchasesales is 1 / satış fiyatı --->
                                <cfquery name="ADD_STD_PRICE" datasource="#DSN3#">
                                    INSERT INTO 
                                        #dsn1_alias#.PRICE_STANDART
                                    (
                                        PRODUCT_ID, 
                                        PURCHASESALES, 
                                        PRICE, 
                                        PRICE_KDV,
                                        IS_KDV,
                                        ROUNDING,
                                        MONEY,
                                        START_DATE,
                                        RECORD_DATE,
                                        PRICESTANDART_STATUS,
                                        UNIT_ID,
                                        RECORD_EMP
                                    )
                                    VALUES
                                    (
                                        #GET_PID.PRODUCT_ID#,
                                        1,
                                        #price_kdvsiz#,
                                        #price_kdvli#,
                                        #price_is_tax_included#,
                                        0,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="TL">,
                                        #bugun_00#,
                                        #NOW()#,
                                        1,
                                        #GET_MAX_UNIT.MAX_UNIT#,
                                        #SESSION.EP.USERID#
                                    )
                                </cfquery>

                                <cfquery name="ADD_STOCKS" datasource="#DSN3#">
                                    INSERT INTO
                                        #dsn1_alias#.STOCKS
                                    (
                                        STOCK_CODE,
                                        PRODUCT_ID,
                                        PROPERTY,
                                        BARCOD,					
                                        PRODUCT_UNIT_ID,
                                        STOCK_STATUS,
                                        RECORD_EMP, 
                                        RECORD_IP,
                                        RECORD_DATE
                                    )
                                    VALUES
                                    (
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_CODE#">,
                                        #GET_PID.PRODUCT_ID#,
                                        '',
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#">,
                                        #GET_MAX_UNIT.MAX_UNIT#,
                                        0,
                                        #session.ep.userid#,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">,
                                        #now()#
                                    )
                                </cfquery>

                                <cfquery name="GET_MAX_STCK" datasource="#DSN3#">
                                    SELECT MAX(STOCK_ID) AS MAX_STCK FROM #dsn1_alias#.STOCKS
                                </cfquery>
                                <cfquery name="ADD_STOCK_BARCODE" datasource="#DSN3#">
                                    INSERT INTO 
                                        #dsn1_alias#.STOCKS_BARCODES
                                    (
                                        STOCK_ID,
                                        BARCODE,
                                        UNIT_ID
                                    )
                                    VALUES 
                                    (
                                        #GET_MAX_STCK.MAX_STCK#,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#">,
                                        #GET_MAX_UNIT.MAX_UNIT#
                                    )
                                </cfquery>

                                <cfquery name="ADD_PRODUCT_OUR_COMPANY_ID" datasource="#DSN3#">
                                    INSERT INTO 
                                        #dsn1_alias#.PRODUCT_OUR_COMPANY
                                        (
                                            PRODUCT_ID,
                                            OUR_COMPANY_ID
                                        )
                                        VALUES
                                        (
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pid.product_id#">,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                                        )
                                </cfquery>

                                <cfquery name="add_product_branch_id" datasource="#DSN3#">
                                    INSERT INTO
                                        #dsn1_alias#.PRODUCT_BRANCH
                                    (
                                        PRODUCT_ID,
                                        BRANCH_ID,
                                        RECORD_EMP, 
                                        RECORD_IP,
                                        RECORD_DATE
                                    )
                                    VALUES
                                    (
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pid.product_id#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">,
                                        #session.ep.userid#,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">,
                                        #now()#				
                                    )
                                </cfquery>
                                <cfquery name="get_my_periods" datasource="#DSN3#">
                                    SELECT * FROM #dsn_alias#.SETUP_PERIOD WHERE OUR_COMPANY_ID = #SESSION.EP.COMPANY_ID#
                                </cfquery>
                                
                                <cfloop query="get_my_periods">
                                    <cfif database_type is "MSSQL">
                                        <cfset temp_dsn = "#DSN#_#PERIOD_YEAR#_#SESSION.EP.COMPANY_ID#">
                                    <cfelseif database_type is "DB2">
                                        <cfset temp_dsn = "#dsn#_#SESSION.EP.COMPANY_ID#_#right(period_year,2)#">
                                    </cfif>
                                    <cfquery name="INSRT_STK_ROW" datasource="#DSN3#">
                                        INSERT INTO #temp_dsn#.STOCKS_ROW 
                                            (
                                                STOCK_ID,
                                                PRODUCT_ID
                                            )
                                        VALUES 
                                            (
                                                #GET_MAX_STCK.MAX_STCK#,
                                                #GET_PID.PRODUCT_ID#
                                            )
                                    </cfquery>
                                </cfloop>
                                <!--- Stok Stratejisi Ekliyor! --->
                                <cfquery name="ADD_STK_STRATEGY" datasource="#DSN3#">
                                    INSERT INTO
                                        STOCK_STRATEGY 
                                    (
                                        PRODUCT_ID,
                                        STOCK_ID,
                                        MINIMUM_ORDER_UNIT_ID,
                                        STRATEGY_TYPE,
                                        IS_LIVE_ORDER
                                        
                                    )
                                    VALUES
                                    (
                                        #pid#,
                                        #GET_MAX_STCK.MAX_STCK#,
                                        #GET_MAX_UNIT.MAX_UNIT#,
                                        1,
                                        0
                                    )
                                </cfquery>

                                <cfset response.status = 1>
                                <cfset response.message = "#getLang('','Ürün başarılı bir şekilde tasarlandı.', 63595)#">
                                <cfcatch>   
                                    <cfset response.status = 0>
                                    <cfset response.message = "#getLang('','Kayıt sırasında bir sorun oluştu', 63437)#">
                                </cfcatch>
                            </cftry>
                        </cftransaction>
                    </cfif>
                </cfif>
            </cfif>
        <cfreturn replace( serializeJSON(response), "//", "" )>
    </cffunction>
    <cffunction name="get_relation_sample" access="public" returntype="any">
        <cfargument name="product_sample_id" required="true">
        <cfquery name="get_relation_sample" datasource="#dsn3#">
            SELECT P.P_SAMPLE_ID, P.PRODUCT_ID, P.BARCOD FROM #dsn1#.PRODUCT AS P WHERE P.P_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_sample_id#">
        </cfquery>
        <cfreturn get_relation_sample>
    </cffunction>
    <cffunction name="GET_STOCK" access="public" returntype="any">
        <cfquery name="GET_STOCK" datasource="#DSN3#">
            SELECT
                STOCK_ID
            FROM
                STOCKS
            WHERE
                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"> AND
                BARCOD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.barcod#">
        </cfquery>
        <cfreturn GET_STOCK>
    </cffunction>

    <cffunction name="get_product" returntype="any">
        <cfquery name="get_product" datasource="#dsn3#">
            SELECT
                S.PRODUCT_ID,
                S.PRODUCT_NAME,
                P.PRODUCT_CODE,
                P.P_SAMPLE_ID,
                P.PRODUCT_CATID,
                S.STOCK_ID,
                S.BARCOD,
                S.PROPERTY,
                S.IS_INVENTORY,
                S.STOCK_CODE,
                S.STOCK_CODE_2,
                S.PRODUCT_UNIT_ID,
                PU.MAIN_UNIT,
                PS.PRODUCT_SAMPLE_ID,
                P.PRODUCT_ID 
            FROM
                STOCKS AS S
                LEFT JOIN PRODUCT_UNIT AS PU on PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID 
                LEFT JOIN #dsn1#.PRODUCT AS P on  S.PRODUCT_ID = P.PRODUCT_ID 
                LEFT JOIN #dsn3#.PRODUCT_SAMPLE AS PS on PS.PRODUCT_SAMPLE_ID=P.P_SAMPLE_ID 
            WHERE
                PU.IS_MAIN = 1 AND
                S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.STOCK_ID#"> 
        </cfquery>
        <cfreturn get_product>
    </cffunction>

    <cffunction name="upd_sample_asorti" access="remote" returntype="any" returnformat="JSON">
        <cfset responseStruct = structNew()>
        <cftry>
            <cfquery name="upd_sample_asorti" datasource="#dsn3#">
                UPDATE 
                    PRODUCT_SAMPLE 
                SET 
                    SAMPLE_ASORTI_JSON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#asorti_json#"> 
                WHERE 
                    PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_sample_id#">
            </cfquery>
                <cfset responseStruct.message = "#getlang('','İşlem Başarılı',61210)#">
                <cfset responseStruct.status = true>
            <cfcatch>
                <cfset responseStruct.message = "#getlang('','İşlem Başarılı',63437)#">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfreturn replace( serializeJSON(responseStruct), "//", "" )>
    </cffunction>
    <cffunction name="getCollarProperty" access="remote" returntype="string" returnFormat="plain">
        <cfargument name="prop_id" required="yes">
        <cfquery name="get_collar_property_det" datasource="#dsn1#"> 
            SELECT 
                PROPERTY_DETAIL_ID,
                PROPERTY_DETAIL 
            FROM 
                PRODUCT_PROPERTY_DETAIL  
                <cfif isdefined('arguments.prop_id') and len(arguments.prop_id)> 
                    WHERE PRPT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prop_id#">
                </cfif> 
            ORDER BY 
                PROPERTY_DETAIL ASC
        </cfquery> 
        <cfreturn Replace(serializeJSON(get_collar_property_det),'//','')>
    </cffunction>    
</cfcomponent>