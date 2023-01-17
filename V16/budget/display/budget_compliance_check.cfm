<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_cat" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.budget_name" default="">
<cfparam name="attributes.general_budget_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.activity_id" default="">
<cfparam name="attributes.budget_info" type="string" default="">
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset GET_XmlControlType = get_fuseaction_property.get_fuseaction_property(
company_id : session.ep.company_id,
fuseaction_name : 'budget.budget_transfer_demand',
property_name : 'is_control_type'
)>
<cfif GET_XmlControlType.PROPERTY_VALUE eq 1>
    <cfparam name="attributes.control_type" default="20">
<cfelseif GET_XmlControlType.PROPERTY_VALUE eq 2>
    <cfparam name="attributes.control_type" default="21">
<cfelse>
    <cfparam name="attributes.control_type" default="16">
</cfif>
<cfset queryJsonConverter = createObject("component","cfc.queryJSONConverter") />
<cfscript>
    get_currency_rate = cfquery(datasource : "#dsn2#", sqlstring : "SELECT (RATE2/RATE1) RATE FROM SETUP_MONEY WHERE MONEY ='#session_base.money2#'");
    currency_multiplier = get_currency_rate.RATE;
</cfscript>
<cfquery name="GET_ACTIVITY" datasource="#DSN#">
	SELECT
		#dsn#.Get_Dynamic_Language(ACTIVITY_ID,'#session.ep.language#','SETUP_ACTIVITY','ACTIVITY_NAME',NULL,NULL,ACTIVITY_NAME) AS ACTIVITY_NAME,
		ACTIVITY_ID		
	FROM 
		SETUP_ACTIVITY
	WHERE
		ACTIVITY_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
	ORDER BY 
		ACTIVITY_NAME
</cfquery>
<cfset GET_XMLBLOCK = get_fuseaction_property.get_fuseaction_property(
company_id : session.ep.company_id,
fuseaction_name : 'budget.budget_transfer_demand',
property_name : 'is_budget_compliance_check'
)>
<cfset order_id_list = ''>
<cfset project_list =''>
<cfset GET_XMLPRO_CAT = get_fuseaction_property.get_fuseaction_property(
        company_id : session.ep.company_id,
        fuseaction_name : 'budget.budget_transfer_demand',
        property_name : 'xml_proje_cat_id'
        )>
<cfif isdefined("attributes.internaldemand_id") and len(attributes.internaldemand_id)> <!--- Satınalma Talebinden Geliyorsa --->
    <cfquery name="GET_INTERNAL_PROJECT" datasource="#dsn3#">
        SELECT PROJECT_ID FROM INTERNALDEMAND  WHERE INTERNAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.internaldemand_id#">
    </cfquery>
    <cfif GET_INTERNAL_PROJECT.recordCount and len( GET_INTERNAL_PROJECT.PROJECT_ID )>
        <cfset attributes.project_id = GET_INTERNAL_PROJECT.PROJECT_ID>
        <cfset attributes.project_head = get_project_name(GET_INTERNAL_PROJECT.PROJECT_ID)>
        <cfif GET_XMLPRO_CAT.recordCount and len( GET_XMLPRO_CAT.PROPERTY_VALUE )>
            <cfquery name="GET_PROJECT" datasource="#dsn#">
                SELECT PROJECT_ID FROM PRO_PROJECTS  WHERE PROCESS_CAT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#valueList(GET_XMLPRO_CAT.PROPERTY_VALUE)#" list="yes">)
            </cfquery>
            <cfset project_list = valueList(GET_PROJECT.PROJECT_ID)>
        </cfif>
        <cfif listfind(project_list,attributes.project_id,',')>
            <cfset attributes.control_type = "21">
        </cfif>
    </cfif>
    <cfquery name="get_internald_info" datasource="#dsn3#">
        SELECT
            SUM(IR.QUANTITY) AS QUANTITY,
            IR.PRODUCT_NAME,
            IR.STOCK_ID,
            IR.UNIT,
            ISNULL(IR.SPECT_VAR_ID,0) AS SPECT_VAR_ID, 
            I.SUBJECT,
            I.INTERNAL_NUMBER,
            I.INTERNAL_ID,
            IR.DELIVER_DATE,
            IR.WRK_ROW_ID
        FROM
            INTERNALDEMAND I,
            INTERNALDEMAND_ROW IR
        WHERE
            I.INTERNAL_ID = IR.I_ID
            AND I.INTERNAL_ID = #attributes.internaldemand_id#
            <cfif isdefined('attributes.stock_id') and len(attributes.stock_id)>
                AND IR.STOCK_ID = #attributes.stock_id#
            </cfif>
        GROUP BY
            IR.PRODUCT_NAME,
            IR.STOCK_ID,
            IR.UNIT,
            ISNULL(IR.SPECT_VAR_ID,0), 
            I.SUBJECT,
            I.INTERNAL_NUMBER,
            I.INTERNAL_ID,
            IR.DELIVER_DATE,
            IR.WRK_ROW_ID
    </cfquery>
    <cfoutput query="get_internald_info">
        <!--- Bağlantılı Sipariş --->
        <cfquery name="get_order_relation" datasource="#dsn3#">
            SELECT
                O.ORDER_ID,
                ORR.STOCK_ID,
                ORR.WRK_ROW_RELATION_ID,
                SUM(ORR.OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE,
                SUM(ORR.NETTOTAL) AS NETTOTAL
            FROM 
                ORDERS O,
                ORDER_ROW ORR
            WHERE 
                O.ORDER_ID = ORR.ORDER_ID AND
                ORR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
            GROUP BY
                O.ORDER_ID,
                O.ORDER_NUMBER,
                O.DELIVERDATE,
                ORR.WRK_ROW_RELATION_ID,
                ORR.STOCK_ID,
                ORR.DELIVER_DATE
            UNION ALL
            SELECT
                O.ORDER_ID,
                ORR.STOCK_ID,
                ORR.WRK_ROW_RELATION_ID,
                SUM(ORR.OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE,
                SUM(ORR.NETTOTAL) AS NETTOTAL
            FROM 
                ORDERS O,
                ORDER_ROW ORR,
                OFFER_ROW OFR
            WHERE 
                O.OFFER_ID = OFR.OFFER_ID AND
                ORR.WRK_ROW_RELATION_ID = OFR.WRK_ROW_ID AND
                OFR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
            GROUP BY
                O.ORDER_ID,
                O.ORDER_NUMBER,
                O.DELIVERDATE,
                ORR.WRK_ROW_RELATION_ID,
                ORR.STOCK_ID,
                ORR.DELIVER_DATE
            UNION ALL
            SELECT
                O.ORDER_ID,
                ORR.STOCK_ID,
                ORR.WRK_ROW_RELATION_ID,
                SUM(ORR.OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE,
                SUM(ORR.NETTOTAL) AS NETTOTAL
            FROM 
                INTERNALDEMAND I,
                INTERNALDEMAND_ROW IR,
                OFFER OO,
                OFFER_ROW OFR,
                ORDERS O,
                ORDER_ROW ORR
            WHERE 
                OO.OFFER_ID = OFR.OFFER_ID AND
                I.INTERNAL_ID = IR.I_ID AND
                O.ORDER_ID = ORR.ORDER_ID AND
                IR.WRK_ROW_ID = OFR.WRK_ROW_RELATION_ID AND
                OFR.WRK_ROW_ID = ORR.WRK_ROW_RELATION_ID AND
                IR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
            GROUP BY
                O.ORDER_ID,
                O.ORDER_NUMBER,
                O.DELIVERDATE,
                ORR.WRK_ROW_RELATION_ID,
                ORR.STOCK_ID,
                ORR.DELIVER_DATE
            UNION ALL
            SELECT
                O.ORDER_ID,
                ORR.STOCK_ID,
                ORR.WRK_ROW_RELATION_ID,
                SUM(ORR.OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE,
                SUM(ORR.NETTOTAL) AS NETTOTAL
            FROM 
                INTERNALDEMAND I,
                INTERNALDEMAND_ROW IR,
                OFFER OO,
                OFFER_ROW OFR,
                OFFER OO2,
                OFFER_ROW OFR2,
                ORDERS O,
                ORDER_ROW ORR
            WHERE 
                OO.OFFER_ID = OFR.OFFER_ID AND
                OO2.OFFER_ID = OFR2.OFFER_ID AND
                I.INTERNAL_ID = IR.I_ID AND
                O.ORDER_ID = ORR.ORDER_ID AND
                IR.WRK_ROW_ID = OFR.WRK_ROW_RELATION_ID AND
                OFR.WRK_ROW_ID = OFR2.WRK_ROW_RELATION_ID AND
                OFR2.WRK_ROW_ID = ORR.WRK_ROW_RELATION_ID AND
                IR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
            GROUP BY
                O.ORDER_ID,
                O.ORDER_NUMBER,
                O.DELIVERDATE,
                ORR.WRK_ROW_RELATION_ID,
                ORR.STOCK_ID,
                ORR.DELIVER_DATE
            UNION ALL
            SELECT
                O.ORDER_ID,
                ORR.STOCK_ID,
                ORR.WRK_ROW_RELATION_ID,
                SUM(ORR.OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE,
                SUM(ORR.NETTOTAL) AS NETTOTAL
            FROM 
                OFFER OO,
                OFFER_ROW OFR,
                OFFER OO2,
                OFFER_ROW OFR2,
                ORDERS O,
                ORDER_ROW ORR
            WHERE 
                OO.OFFER_ID = OFR.OFFER_ID AND
                OO2.OFFER_ID = OFR2.OFFER_ID AND
                O.ORDER_ID = ORR.ORDER_ID AND
                OFR.WRK_ROW_ID = OFR2.WRK_ROW_RELATION_ID AND
                OFR2.WRK_ROW_ID = ORR.WRK_ROW_RELATION_ID AND
                OFR.WRK_ROW_RELATION_ID = '#WRK_ROW_ID#'
            GROUP BY
                O.ORDER_ID,
                O.ORDER_NUMBER,
                O.DELIVERDATE,
                ORR.WRK_ROW_RELATION_ID,
                ORR.STOCK_ID,
                ORR.DELIVER_DATE
        </cfquery>
        <cfloop query="get_order_relation">
		<cfset order_id_list=listappend(order_id_list,'#ORDER_ID#;#STOCK_ID#;#NETTOTAL#;#WRK_ROW_RELATION_ID#')>
        </cfloop>
    </cfoutput>
<cfelseif isdefined("attributes.order_id") and len(attributes.order_id)>
    <cfquery name="GET_INTERNAL_PROJECT" datasource="#dsn3#">
        SELECT PROJECT_ID FROM ORDERS  WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
    </cfquery>
    <cfif GET_INTERNAL_PROJECT.recordCount and len( GET_INTERNAL_PROJECT.PROJECT_ID )>
        <cfset attributes.project_id = GET_INTERNAL_PROJECT.PROJECT_ID>
        <cfset attributes.project_head = get_project_name(GET_INTERNAL_PROJECT.PROJECT_ID)>
        <cfif GET_XMLPRO_CAT.recordCount and len( GET_XMLPRO_CAT.PROPERTY_VALUE )>
            <cfquery name="GET_PROJECT" datasource="#dsn#">
                SELECT PROJECT_ID FROM PRO_PROJECTS  WHERE PROCESS_CAT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#valueList(GET_XMLPRO_CAT.PROPERTY_VALUE)#" list="yes">)
            </cfquery>
            <cfset project_list = valueList(GET_PROJECT.PROJECT_ID)>
        </cfif>
        <cfif listfind(project_list,attributes.project_id,',')>
            <cfset attributes.control_type = "21">
        </cfif>
    </cfif>
</cfif>

<cfquery name="GET_EXPENSE_BUDGET" datasource="#dsn2#">
    SELECT 
        GEC.EXPENSE_ID,
        GEC.EXPENSE,
        <cfif attributes.control_type eq 20>
            GEC.EXPENSE_CAT_ID,
            GEC.EXPENSE_CAT_NAME,
        <cfelseif attributes.control_type eq 21>
            GEC.PROJECT_ID,
        <cfelseif attributes.control_type eq 22>
            GEC.ACTIVITY_NAME,
            GEC.ACTIVITY_ID,
        <cfelse>
            GEC.EXPENSE_ITEM_ID,
            GEC.EXPENSE_ITEM_NAME,
        </cfif>
        GEC.NETTOTAL,
        <cfif isdefined("attributes.internaldemand_id") and len(attributes.internaldemand_id)>
        GEC.INTERNAL_NUMBER,
        </cfif>
        GEC.OTHER_MONEY_VALUE,
        ISNULL(ROW_TOTAL_EXPENSE,0) ROW_TOTAL_EXPENSE,
        ISNULL(ROW_TOTAL_EXPENSE_2,0) ROW_TOTAL_EXPENSE_2,
        ISNULL(TOTAL_AMOUNT_BORC,0) AS TOTAL_AMOUNT_BORC,
        ISNULL(TOTAL_AMOUNT_2_BORC,0) AS TOTAL_AMOUNT_BORC_2,
        ISNULL(REZ_TOTAL_AMOUNT_BORC,0) AS REZ_TOTAL_AMOUNT_BORC,
        ISNULL(REZ_TOTAL_AMOUNT_2_BORC,0) AS REZ_TOTAL_AMOUNT_2_BORC,
        ISNULL(REZ_TOTAL_AMOUNT_ALACAK,0) AS REZ_TOTAL_AMOUNT_ALACAK,
        ISNULL(REZ_TOTAL_AMOUNT_2_ALACAK,0) AS REZ_TOTAL_AMOUNT_2_ALACAK,
        ISNULL(TOTAL_AMOUNT_ALACAK,0) AS TOTAL_AMOUNT_ALACAK,
        ISNULL(TOTAL_AMOUNT_2_ALACAK,0) AS TOTAL_AMOUNT_2_ALACAK
    FROM
        (
            SELECT 
                <cfif isdefined("attributes.internaldemand_id") and len(attributes.internaldemand_id)> <!--- Satınalma Talebinden Geliyorsa --->
                    SUM(RW.OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE,
                    SUM(RW.NETTOTAL) AS NETTOTAL,
                    MT.INTERNAL_NUMBER AS INTERNAL_NUMBER,
                <cfelseif isdefined("attributes.offer_id") and len(attributes.offer_id)> <!--- Satınalma Teklifinden Geliyorsa --->
                    SUM(RW.PRICE_OTHER) AS OTHER_MONEY_VALUE,
                    SUM((RW.PRICE * RW.QUANTITY)) AS NETTOTAL,
                <cfelseif isdefined("attributes.order_id") and len(attributes.order_id)> <!--- Satınalma Siparişinden Geliyorsa --->
                    SUM(RW.OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE,
                    SUM(RW.NETTOTAL ) AS NETTOTAL,
                <cfelseif isdefined("attributes.expense_id") and len(attributes.expense_id)> <!--- MAsraf fişinden Geliyorsa --->
                    SUM(RW.OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE,
                    SUM(RW.TOTAL_AMOUNT) AS NETTOTAL,
                </cfif>
                    ECEN.EXPENSE_ID,
                    ECEN.EXPENSE
                    <cfif attributes.control_type eq 20>
                        ,EC.EXPENSE_CAT_ID
                        ,EC.EXPENSE_CAT_NAME
                    <cfelseif attributes.control_type eq 21>
                        ,PP.PROJECT_ID
                    <cfelseif attributes.control_type eq 22>
                        ,STAC.ACTIVITY_NAME
                        ,STAC.ACTIVITY_ID
                    <cfelse>
                        ,EI.EXPENSE_ITEM_ID
                        ,EI.EXPENSE_ITEM_NAME
                    </cfif>
            FROM 
                <cfif isdefined("attributes.internaldemand_id") and len(attributes.internaldemand_id)> <!--- Satınalma Talebinden Geliyorsa --->
                    #dsn3#.INTERNALDEMAND_ROW AS RW
		            JOIN #dsn3#.INTERNALDEMAND AS MT ON MT.INTERNAL_ID = RW.I_ID
                <cfelseif isdefined("attributes.offer_id") and len(attributes.offer_id)> <!--- Satınalma Teklifinden Geliyorsa --->
                    #dsn3#.OFFER_ROW AS RW
                    JOIN #dsn3#.OFFER AS MT ON RW.OFFER_ID =  MT.OFFER_ID
                <cfelseif isdefined("attributes.order_id") and len(attributes.order_id)> <!--- Satınalma Siparişinden Geliyorsa --->
                    #dsn3#.ORDER_ROW AS RW
                    JOIN #dsn3#.ORDERS AS MT ON RW.ORDER_ID =  MT.ORDER_ID
                <cfelseif isdefined("attributes.expense_id") and len(attributes.expense_id)> <!--- Masraf Fişinden Geliyorsa --->
                    EXPENSE_ITEMS_ROWS AS RW
                    JOIN EXPENSE_ITEM_PLANS AS MT ON RW.EXPENSE_ID = MT.EXPENSE_ID
                </cfif>
                LEFT JOIN EXPENSE_ITEMS AS EI ON ISNULL(RW.EXPENSE_ITEM_ID, (SELECT INCOME_ITEM_ID FROM #dsn3#.PRODUCT_PERIOD PP WHERE PP.PRODUCT_ID = RW.PRODUCT_ID AND PP.PERIOD_ID = #session.ep.period_id#)) = EI.EXPENSE_ITEM_ID
                LEFT JOIN EXPENSE_CENTER AS ECEN ON  ISNULL(RW.EXPENSE_CENTER_ID, (SELECT EXPENSE_CENTER_ID FROM #dsn3#.PRODUCT_PERIOD PP WHERE PP.PRODUCT_ID = RW.PRODUCT_ID AND PP.PERIOD_ID = #session.ep.period_id#)) = ECEN.EXPENSE_ID
                LEFT JOIN EXPENSE_CATEGORY AS EC ON  EI.EXPENSE_CATEGORY_ID = EC.EXPENSE_CAT_ID
                <cfif attributes.control_type eq 22>
                    <cfif isdefined("attributes.expense_id") and len(attributes.expense_id)> <!--- Masraf Fişinden Geliyorsa --->
                        LEFT JOIN #dsn#.SETUP_ACTIVITY AS STAC ON ISNULL(RW.ACTIVITY_TYPE,(SELECT ACTIVITY_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID = ECEN.EXPENSE_ID)) = STAC.ACTIVITY_ID
                    <cfelse>
                        LEFT JOIN #dsn#.SETUP_ACTIVITY AS STAC ON  ISNULL(RW.ACTIVITY_TYPE_ID,(SELECT ACTIVITY_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID = ECEN.EXPENSE_ID)) = STAC.ACTIVITY_ID
                    </cfif> 
                <cfelseif attributes.control_type eq 21>
                    LEFT JOIN #dsn#.PRO_PROJECTS AS PP ON MT.PROJECT_ID = PP.PROJECT_ID
                </cfif>
            WHERE 
                <cfif isdefined("attributes.internaldemand_id") and len(attributes.internaldemand_id)> <!--- Satınalma Talebinden Geliyorsa --->
                    RW.I_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.internaldemand_id#">
                <cfelseif isdefined("attributes.offer_id") and len(attributes.offer_id)> <!--- Satınalma Teklifinden Geliyorsa --->
                    RW.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
                <cfelseif isdefined("attributes.order_id") and len(attributes.order_id)> <!--- Satınalma Siparişinden Geliyorsa --->
                    RW.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
                <cfelseif isdefined("attributes.expense_id") and len(attributes.expense_id)> <!--- Masraf Fişinden Geliyorsa --->
                    RW.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
                </cfif>
                <cfif attributes.control_type eq 22>
                    <cfif isdefined("attributes.expense_id") and len(attributes.expense_id)> <!--- Masraf Fişinden Geliyorsa --->
                        AND ISNULL(RW.ACTIVITY_TYPE,(SELECT ACTIVITY_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID = ECEN.EXPENSE_ID)) IS NOT NULL
                    <cfelse>
                        AND ISNULL(RW.ACTIVITY_TYPE_ID,(SELECT ACTIVITY_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID = ECEN.EXPENSE_ID)) IS NOT NULL
                    </cfif> 
                <cfelseif attributes.control_type eq 21>
                    AND MT.PROJECT_ID IS NOT NULL
                </cfif>
                <cfif len(attributes.expense_item_id)>
                    AND EI.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
                </cfif>
                <cfif len(attributes.expense_cat)>
                    AND EC.EXPENSE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_cat#">
                </cfif>
                <cfif len(attributes.expense_center_id)>
                    AND ECEN.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
                </cfif>
                <cfif len( attributes.activity_id )>
                    AND RW.ACTIVITY_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.activity_id#">
                </cfif>
                <cfif len( attributes.project_id ) and len( attributes.project_head )>
                    AND MT.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                </cfif>
            GROUP BY 
                    ECEN.EXPENSE_ID,
                    ECEN.EXPENSE
                <cfif attributes.control_type eq 20>
                    ,EC.EXPENSE_CAT_ID
                    ,EC.EXPENSE_CAT_NAME
                <cfelseif attributes.control_type eq 21>
                    ,PP.PROJECT_ID
                <cfelseif attributes.control_type eq 22>
                    ,STAC.ACTIVITY_NAME
                    ,STAC.ACTIVITY_ID
                <cfelse>
                    ,EI.EXPENSE_ITEM_ID
                    ,EI.EXPENSE_ITEM_NAME
                </cfif>                
                <cfif isdefined("attributes.internaldemand_id") and len(attributes.internaldemand_id)>
                    ,INTERNAL_NUMBER
                </cfif>
        ) AS GEC
    <cfif isdefined("attributes.internaldemand_id") and len(attributes.internaldemand_id) and len( attributes.general_budget_id ) and len( attributes.budget_name )>
    JOIN
    <cfelse>
    LEFT JOIN
    </cfif>    
        (
            SELECT 
                ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE),0) ROW_TOTAL_EXPENSE,
                ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE_2),0) ROW_TOTAL_EXPENSE_2,
                BUDGET_PLAN_ROW.EXP_INC_CENTER_ID,
                <cfif attributes.control_type eq 20>
                    EXPENSE_CATEGORY.EXPENSE_CAT_ID
                <cfelseif attributes.control_type eq 21>
                    BUDGET_PLAN_ROW.PROJECT_ID
                <cfelseif attributes.control_type eq 22>
                    BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID
                <cfelse>
                    BUDGET_PLAN_ROW.BUDGET_ITEM_ID
                </cfif>
            FROM
                #DSN_ALIAS#.BUDGET_PLAN,
                #DSN_ALIAS#.BUDGET_PLAN_ROW,
                #DSN_ALIAS#.BUDGET 
                <cfif attributes.control_type eq 20>
                ,EXPENSE_CATEGORY EXPENSE_CATEGORY
                </cfif>
            WHERE 
                BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
                BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID AND
                BUDGET_PLAN.BUDGET_ID = BUDGET.BUDGET_ID 
                <cfif attributes.control_type eq 20>
                    AND BUDGET_PLAN_ROW.BUDGET_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID = EXPENSE_CATEGORY.EXPENSE_CAT_ID)
                </cfif>
                AND BUDGET.PERIOD_YEAR = #session.ep.period_year#
                <cfif len( attributes.general_budget_id ) and len( attributes.budget_name )>
                    AND BUDGET_PLAN.BUDGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#">
                </cfif>
            GROUP BY
                BUDGET_PLAN_ROW.EXP_INC_CENTER_ID,
                <cfif attributes.control_type eq 20>
                    EXPENSE_CATEGORY.EXPENSE_CAT_ID
                <cfelseif attributes.control_type eq 21>
                    BUDGET_PLAN_ROW.PROJECT_ID
                <cfelseif attributes.control_type eq 22>
                    BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID
                <cfelse>
                    BUDGET_PLAN_ROW.BUDGET_ITEM_ID
                </cfif>
        ) AS PLANLANAN
    ON PLANLANAN.EXP_INC_CENTER_ID = GEC.EXPENSE_ID AND <cfif attributes.control_type eq 20> PLANLANAN.EXPENSE_CAT_ID = GEC.EXPENSE_CAT_ID <cfelseif attributes.control_type eq 21> PLANLANAN.PROJECT_ID = GEC.PROJECT_ID <cfelseif attributes.control_type eq 22> PLANLANAN.ACTIVITY_TYPE_ID = GEC.ACTIVITY_ID <cfelse> PLANLANAN.BUDGET_ITEM_ID = GEC.EXPENSE_ITEM_ID</cfif>
    LEFT JOIN
        (
            SELECT
                SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT ELSE 0 END) AS TOTAL_AMOUNT_BORC,
                SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT_2 ELSE 0 END) AS TOTAL_AMOUNT_2_BORC,
                SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT ELSE 0 END) AS TOTAL_AMOUNT_ALACAK,
                SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT_2 ELSE 0 END) TOTAL_AMOUNT_2_ALACAK,
                EXPENSE_CENTER_ID,
                <cfif attributes.control_type eq 20>
                    EXPENSE_CAT_ID
                <cfelseif attributes.control_type eq 21>
                    PROJECT_ID
                <cfelseif attributes.control_type eq 22>
                    ACTIVITY_TYPE
                <cfelse>
                    EXPENSE_ITEM_ID
                </cfif>
            FROM
            (
                SELECT 
                    (EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT- EXPENSE_ITEMS_ROWS.AMOUNT_KDV) TOTAL_AMOUNT,
                    EXPENSE_ITEMS_ROWS.OTHER_MONEY_VALUE_2 TOTAL_AMOUNT_2,
                    EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID,
                    EXPENSE_ITEMS_ROWS.IS_INCOME,
                    <cfif attributes.control_type eq 20>
                        EXPENSE_CATEGORY.EXPENSE_CAT_ID
                    <cfelseif attributes.control_type eq 21>
                        EXPENSE_ITEMS_ROWS.PROJECT_ID
                    <cfelseif attributes.control_type eq 22>
                        EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE
                    <cfelse>
                       EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID
                    </cfif>
                FROM
                    EXPENSE_ITEMS_ROWS
                    <cfif attributes.control_type eq 20>
                        ,EXPENSE_CATEGORY EXPENSE_CATEGORY
                    </cfif>
                WHERE
                    TOTAL_AMOUNT > 0
                   <cfif attributes.control_type eq 20> AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID = EXPENSE_CATEGORY.EXPENSE_CAT_ID)</cfif>		
            )T1
            GROUP BY
                EXPENSE_CENTER_ID,
                <cfif attributes.control_type eq 20>
                    EXPENSE_CAT_ID
                <cfelseif attributes.control_type eq 21>
                    PROJECT_ID
                <cfelseif attributes.control_type eq 22>
                    ACTIVITY_TYPE
                <cfelse>
                    EXPENSE_ITEM_ID
                </cfif>

        ) AS GERCEKLESEN  
            ON GERCEKLESEN.EXPENSE_CENTER_ID = GEC.EXPENSE_ID AND <cfif attributes.control_type eq 20> GEC.EXPENSE_CAT_ID = GERCEKLESEN.EXPENSE_CAT_ID <cfelseif attributes.control_type eq 21> GERCEKLESEN.PROJECT_ID =  GEC.PROJECT_ID <cfelseif attributes.control_type eq 22> GEC.ACTIVITY_ID = GERCEKLESEN.ACTIVITY_TYPE <cfelse> GEC.EXPENSE_ITEM_ID = GERCEKLESEN.EXPENSE_ITEM_ID </cfif>
    LEFT JOIN
        (
            SELECT
                SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT ELSE 0 END) AS REZ_TOTAL_AMOUNT_BORC,
                SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT_2 ELSE 0 END) AS REZ_TOTAL_AMOUNT_2_BORC,
                SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT ELSE 0 END) AS REZ_TOTAL_AMOUNT_ALACAK,
                SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT_2 ELSE 0 END) REZ_TOTAL_AMOUNT_2_ALACAK,
                EXPENSE_CENTER_ID,
                <cfif attributes.control_type eq 20>
                    EXPENSE_CAT_ID
                <cfelseif attributes.control_type eq 21>
                    PROJECT_ID
                <cfelseif attributes.control_type eq 22>
                    ACTIVITY_TYPE
                <cfelse>
                    EXPENSE_ITEM_ID
                </cfif>
            FROM
            (
                SELECT 
                    (ERR.TOTAL_AMOUNT-ERR.AMOUNT_KDV) TOTAL_AMOUNT,
                    ERR.OTHER_MONEY_VALUE_2 TOTAL_AMOUNT_2,
                    ERR.EXPENSE_CENTER_ID,
                    ERR.IS_INCOME,
                    <cfif attributes.control_type eq 20>
                        EXPENSE_CATEGORY.EXPENSE_CAT_ID
                    <cfelseif attributes.control_type eq 21>
                        ERR.PROJECT_ID
                    <cfelseif attributes.control_type eq 22>
                        ERR.ACTIVITY_TYPE
                    <cfelse>
                        ERR.EXPENSE_ITEM_ID   
                    </cfif>
                FROM
                    EXPENSE_RESERVED_ROWS AS ERR
                    <cfif attributes.control_type eq 20>
                        ,EXPENSE_CATEGORY EXPENSE_CATEGORY
                    </cfif>
                WHERE
                    TOTAL_AMOUNT > 0	
                    <cfif attributes.control_type eq 20>AND ERR.EXPENSE_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID = EXPENSE_CATEGORY.EXPENSE_CAT_ID)</cfif>			
            )T1
            GROUP BY
                EXPENSE_CENTER_ID,
                <cfif attributes.control_type eq 20>
                    EXPENSE_CAT_ID
                <cfelseif attributes.control_type eq 21>
                    PROJECT_ID
                <cfelseif attributes.control_type eq 22>
                    ACTIVITY_TYPE
                <cfelse>
                    EXPENSE_ITEM_ID
                </cfif>
        ) AS RESERVED  
            ON RESERVED.EXPENSE_CENTER_ID = GEC.EXPENSE_ID AND <cfif attributes.control_type eq 20> GEC.EXPENSE_CAT_ID = RESERVED.EXPENSE_CAT_ID <cfelseif attributes.control_type eq 21> RESERVED.PROJECT_ID =  GEC.PROJECT_ID <cfelseif attributes.control_type eq 22> GEC.ACTIVITY_ID = RESERVED.ACTIVITY_TYPE <cfelse> GEC.EXPENSE_ITEM_ID = RESERVED.EXPENSE_ITEM_ID </cfif>
</cfquery>
<div id="div_rows">
    <cfform name="rows" method="post" action="">
        <cf_box_search id="aa">							
            <div class="form-group">
                <cf_wrkExpenseCenter fieldId="expense_center_id" fieldName="expense_center_name" form_name="rows" expense_center_id="#attributes.expense_center_id#" img_info="plus_thin">
            </div>
            <div class="form-group large">
                <cf_wrk_budgetcat name="expense_cat" option_text="#getLang('','Bütçe Kategorisi',32999)#" value="#attributes.expense_cat#">
            </div>
            <div class="form-group large">
                <cf_wrk_budgetitem name="expense_item_id" class="txt" value="#attributes.expense_item_id#" income_expense="0" option_text="#getLang('main','Gider Kalemi',58551)#">
            </div>
            <div class="form-group large">
                <div class="input-group">
                    <input type="hidden" name="general_budget_id" id="general_budget_id" value="<cfif isdefined("attributes.general_budget_id")><cfoutput>#attributes.general_budget_id#</cfoutput></cfif>">
                    <input type="text" name="budget_name" id="budget_name" readonly value="<cfif isdefined("attributes.budget_name")><cfoutput>#attributes.budget_name#</cfoutput></cfif>" placeholder="<cf_get_lang_main no='147.Bütçe'>">
                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_budget&field_id=rows.general_budget_id&field_name=rows.budget_name&select_list=2');"></span>
                </div>
            </div>
            <div class="form-group large">
                <div class="input-group">
                    <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
                    <input name="project_head" type="text" id="project_head" value="<cfif Len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" placeholder="<cf_get_lang dictionary_id='57416.Proje'>"  onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','rows','3','250');" autocomplete="off">
                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=rows.project_head&project_id=rows.project_id</cfoutput>');"></span>
                </div>
            </div>
            <div class="form-group large">
                <select name="activity_id" id="activity_id" >
                    <option value=""><cf_get_lang dictionary_id='38378.Aktivite Tipi'></option>
                    <cfoutput query="get_activity">
                        <option value="#activity_id#" <cfif attributes.activity_id eq activity_id>selected</cfif> >#activity_name#</option>
                    </cfoutput>
                </select>      
            </div>
            <div class="form-group large">
                <select name="control_type" id="control_type" onChange="change_month();change_exp();">
                    <option value=""><cf_get_lang dictionary_id='36651.Kontrol Tipi'></option>
                    <option value="16" <cfif attributes.control_type eq 16>selected</cfif>><cf_get_lang dictionary_id='49107.Bütçe Kalemi ve Masraf Merkezi Bazında'></option>
                    <option value="20" <cfif attributes.control_type eq 20>selected</cfif>><cf_get_lang dictionary_id='59206.Masraf Merkezi ve Bütçe Kategorisi Bazında'></option>
                    <option value="21" <cfif attributes.control_type eq 21>selected</cfif>><cf_get_lang dictionary_id='60657.Masraf Merkezi ve Proje Bazında'></option>
                    <option value="22" <cfif attributes.control_type eq 22>selected</cfif>><cf_get_lang dictionary_id='60653.Aktivite Tipi ve Masraf Merkezi Bazında'></option>
                </select>
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4" search_function="loader_page()">
            </div>
        </cf_box_search>
    </cfform>
    <cf_grid_list>
        <thead>
            <tr>
                <cfif attributes.control_type eq 16><th rowspan="2"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></th></cfif>
                <cfif attributes.control_type eq 20><th rowspan="2"><cf_get_lang dictionary_id='32999.Bütçe Kategorisi'></th></cfif>
                <cfif attributes.control_type eq 22><th rowspan="2"><cf_get_lang dictionary_id='38378.Aktivite Tipi'></th></cfif>
                <cfif attributes.control_type eq 21><th rowspan="2"><cf_get_lang dictionary_id='31027.Proje'></th></cfif>
                <th rowspan="2"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
                <th colspan="2" class="text-center"><cf_get_lang dictionary_id='58869.Planlanan'></th>
                <th colspan="2" class="text-center"><cf_get_lang dictionary_id='58048.Rezerve Edilen'></th>
                <th colspan="2" class="text-center"><cf_get_lang dictionary_id='29750.Rezerve'><cf_get_lang dictionary_id='59563.Kullanılan'></th>
                <th colspan="2" class="text-center"><cf_get_lang dictionary_id='31491.Gerçekleşen'></th>
                <th colspan="2" class="text-center"><cf_get_lang dictionary_id='60705.Serbest Bütçe'></th>
                <th colspan="2" class="text-center"><cf_get_lang dictionary_id='31181.Talep Edilen'></th>
                <cfif isdefined("attributes.internaldemand_id") and len(attributes.internaldemand_id)><th colspan="2" class="text-center"><cf_get_lang dictionary_id='31181.Talep Edilen'>(Sipariş)</th><c/></cfif>
                <th rowspan="2" class="text-center" width="15" title="<cf_get_lang dictionary_id='57756.Durum'>"><cf_get_lang dictionary_id='33873.D'></th>
                <th rowspan="2" class="text-center" width="15"><cf_get_lang dictionary_id='64691.Transfer/Talep'></th>
                <cfif GET_XMLBLOCK.PROPERTY_VALUE eq 0><th rowspan="2" class="text-center" class="header_icn_none"><input type="radio" class="radioControl" name="allSelectRequest" id="allSelectRequest"></th></cfif>
            </tr>
            <tr>
                <cfset row_ = 6>
                <cfif isdefined("attributes.internaldemand_id") and len(attributes.internaldemand_id)><cfset row_ = 7></cfif>
                <cfloop from="1" to="#row_#" index="i">
                    <th class="text-right"><cfoutput>#session.ep.money#</cfoutput></th>
                    <th class="text-right"><cfoutput>#session.ep.money2#</cfoutput></th>
                </cfloop>
            </tr>
        </thead>
            <cfif GET_EXPENSE_BUDGET.recordcount gt 0>
                <tbody>
                    <cfoutput query="GET_EXPENSE_BUDGET">
                        <tr>
                            <cfif attributes.control_type eq 16><td>#EXPENSE_ITEM_NAME#</td></cfif>
                            <cfif attributes.control_type eq 20><td>#EXPENSE_CAT_NAME#</td></cfif>
                            <cfif attributes.control_type eq 22><td>#ACTIVITY_NAME#</td></cfif>
                            <cfif attributes.control_type eq 21><td>#get_project_name(GET_EXPENSE_BUDGET.PROJECT_ID)#</td></cfif>
                            <td>#EXPENSE#</td>
                            <td class="text-right">#TLFormat(ROW_TOTAL_EXPENSE)#</td>
                            <td class="text-right">#TLFormat(ROW_TOTAL_EXPENSE_2)#</td>
                            <td class="text-right">#TLFormat(REZ_TOTAL_AMOUNT_ALACAK)#</td>
                            <td class="text-right">#TLFormat(REZ_TOTAL_AMOUNT_2_ALACAK)#</td>
                            <td class="text-right">#TLFormat(REZ_TOTAL_AMOUNT_BORC)#</td>
                            <td class="text-right">#TLFormat(REZ_TOTAL_AMOUNT_2_BORC)#</td>
                            <td class="text-right">#TLFormat(TOTAL_AMOUNT_BORC - TOTAL_AMOUNT_ALACAK)#</td>
                            <td class="text-right">#TLFormat(TOTAL_AMOUNT_BORC_2 - TOTAL_AMOUNT_2_ALACAK)#</td>
                            <td class="text-right">#TLFormat(ROW_TOTAL_EXPENSE - (TOTAL_AMOUNT_BORC - TOTAL_AMOUNT_ALACAK) - (REZ_TOTAL_AMOUNT_ALACAK - REZ_TOTAL_AMOUNT_BORC))#</td>
                            <td class="text-right">#TLFormat(ROW_TOTAL_EXPENSE_2 - (TOTAL_AMOUNT_BORC_2 - TOTAL_AMOUNT_2_ALACAK) - (REZ_TOTAL_AMOUNT_2_ALACAK - REZ_TOTAL_AMOUNT_2_BORC))#</td>
                            <td class="text-right">#TLFormat(NETTOTAL)#</td>
                            <td class="text-right">#TLFormat(wrk_round(NETTOTAL/currency_multiplier))#</td>
                            <cfif isdefined("attributes.internaldemand_id") and len(attributes.internaldemand_id)>
                                <td class="text-right">
                                    <cfset currency = TLFormat(wrk_round(0/currency_multiplier))>
                                    <cfif len(order_id_list)>
                                        <cfloop list="#order_id_list#" index="j">
                                            <cfset order_id = listgetat(j,1,';')>
                                            <cfquery name="GET_ORDER_TOTAL" datasource="#dsn2#">
                                                SELECT 
                                                    SUM(RW.OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE
                                                    ,SUM(RW.NETTOTAL) AS NETTOTAL
                                                    ,ECEN.EXPENSE_ID
                                                    ,ECEN.EXPENSE
                                                    ,EC.EXPENSE_CAT_ID
                                                    ,EC.EXPENSE_CAT_NAME
                                                FROM 
                                                    #dsn3#.ORDER_ROW AS RW
                                                    ,#dsn3#.ORDERS AS MT
                                                    ,EXPENSE_ITEMS AS EI
                                                    ,EXPENSE_CATEGORY AS EC
                                                    ,EXPENSE_CENTER AS ECEN
                                                WHERE RW.ORDER_ID = MT.ORDER_ID
                                                    AND RW.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_id#">
                                                    AND RW.EXPENSE_CENTER_ID = ECEN.EXPENSE_ID
                                                    AND RW.EXPENSE_ITEM_ID = EI.EXPENSE_ITEM_ID
                                                    AND EI.EXPENSE_CATEGORY_ID = EC.EXPENSE_CAT_ID
                                                    <cfif isDefined("EXPENSE_CAT_ID")>
                                                        AND EC.EXPENSE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EXPENSE_CAT_ID#">
                                                    </cfif>
                                                    <cfif isDefined("GET_EXPENSE_BUDGET.EXPENSE_ITEM_ID") and len(GET_EXPENSE_BUDGET.EXPENSE_ITEM_ID)>
                                                        AND EI.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EXPENSE_ITEM_ID#">
                                                    </cfif>
                                                GROUP BY ECEN.EXPENSE_ID
                                                    ,ECEN.EXPENSE
                                                    ,EC.EXPENSE_CAT_NAME
                                                    ,EC.EXPENSE_CAT_ID
                                            </cfquery>
                                            <cfset amount_new = GET_ORDER_TOTAL.NETTOTAL>
                                            <cfif len(GET_ORDER_TOTAL.NETTOTAL)>
                                            <cfset currency = TLFormat(wrk_round(GET_ORDER_TOTAL.NETTOTAL/currency_multiplier))>
                                            <cfelse>
                                            <cfset currency = TLFormat(wrk_round(0))>
                                            </cfif>
                                        </cfloop> 
                                        #TLFormat(amount_new)# 
                                    <cfelse>
                                        #TLFormat(0)#
                                    </cfif>                                  
                                </td>
                                <td class="text-right">#currency#</td>
                            </cfif>
                            <td class="text-center">
                                <cfif len(order_id_list)>
                                    <cfif (amount_new) lte (ROW_TOTAL_EXPENSE-TOTAL_AMOUNT_BORC)>
                                        <span class="fa fa-smile-o" style="font-size:17px;color:green;"></span> 
                                    <cfelse>
                                        <span class="fa fa-frown-o" style="font-size:17px;color:red;"></span>
                                    </cfif>
                                <cfelse>
                                    <cfif (NETTOTAL) lte (ROW_TOTAL_EXPENSE-TOTAL_AMOUNT_BORC)>
                                        <span class="fa fa-smile-o" style="font-size:17px;color:green;"></span> 
                                    <cfelse>
                                        <span class="fa fa-frown-o" style="font-size:17px;color:red;"></span>
                                    </cfif>
                                </cfif>
                            </td>
                            <td class="text-center">
                                <cfset comp = createObject("component", "V16.budget.cfc.BudgetTransferDemand")>
                                 <cfset get_status_budget = comp.GetBudgetStatus(
                                    expense_id: '#expense_id#',
                                    expense_item_id : '#(isdefined("attributes.expense_item_id") ? attributes.expense_item_id : '')#', 
                                    internaldemand_id : '#(isdefined("attributes.internaldemand_id") ? attributes.internaldemand_id : '')#',
                                    offer_id : '#(isdefined("attributes.offer_id") ? attributes.offer_id : '')#',
                                    order_id : '#(isdefined("attributes.order_id") ? attributes.order_id : '')#',
                                    expense_ : '#(isdefined("attributes.expense_id") ? attributes.expense_id : '')#'
                                    )>
                                <cfif len(order_id_list)>
                                    <cfset amount_dgr = amount_new>
                                <cfelse>
                                    <cfset amount_dgr = NETTOTAL>
                                </cfif>
                                <cfif (amount_dgr) lte (ROW_TOTAL_EXPENSE-TOTAL_AMOUNT_BORC) and len(get_status_budget.TRANSFER_STATUS) and get_status_budget.TRANSFER_STATUS eq 1>
                                    <span class="fa fa-2x fa-bookmark" title="Yeterli Bakiye Mevcut ve Daha önce Bütçe transfer işlemi gerçekleşmiştir" style="font-size:17px;color:blue;"></span>
                                <cfelseif (amount_dgr) lte (ROW_TOTAL_EXPENSE-TOTAL_AMOUNT_BORC)>
                                    <span class="fa fa-2x fa-bookmark" title="Yeterli Bakiye Mevcuttur" style="font-size:17px;color:green;"></span> 
                                <cfelseif len(get_status_budget.TRANSFER_STATUS) and get_status_budget.TRANSFER_STATUS eq 0>
                                    <span class="fa fa-2x fa-bookmark" title="Bütçe Aktarım Talebi Gerçekleşmiş" style="font-size:17px;color:pink;"></span>
                                <cfelseif not len(get_status_budget.TRANSFER_STATUS)>
                                    <span class="fa fa-2x fa-bookmark" title="Bütçe Aktarım Talebi Gerçekleşmemiş" style="font-size:17px;color:orange;"></span>
                                <cfelseif len(get_status_budget.TRANSFER_STATUS) and get_status_budget.TRANSFER_STATUS eq 1>
                                    <span class="fa fa-2x fa-bookmark" title="Bütçe Transfer Gerçekleşmiş" style="font-size:17px;color:purple;"></span>
                                </cfif>
                            </td>
                            <cfif GET_XMLBLOCK.PROPERTY_VALUE eq 0>
                                <td class="text-center">
                                     <cfif attributes.control_type eq 20 or (attributes.control_type eq 21)>
                                        <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
                                            SELECT 
                                                 DISTINCT EI.EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME
                                            FROM 
                                                <cfif isdefined("attributes.internaldemand_id") and len(attributes.internaldemand_id)> <!--- Satınalma Talebinden Geliyorsa --->
                                                    #dsn3#.INTERNALDEMAND_ROW AS RW,
                                                    #dsn3#.INTERNALDEMAND AS MT,
                                                <cfelseif isdefined("attributes.offer_id") and len(attributes.offer_id)> <!--- Satınalma Teklifinden Geliyorsa --->
                                                    #dsn3#.OFFER_ROW AS RW,
                                                    #dsn3#.OFFER AS MT,
                                                <cfelseif isdefined("attributes.order_id") and len(attributes.order_id)> <!--- Satınalma Siparişinden Geliyorsa --->
                                                    #dsn3#.ORDER_ROW AS RW,
                                                    #dsn3#.ORDERS AS MT,
                                                <cfelseif isdefined("attributes.expense_id") and len(attributes.expense_id)> <!--- Masraf Fişinden Geliyorsa --->
                                                    EXPENSE_ITEMS_ROWS AS RW,
                                                EXPENSE_ITEM_PLANS AS MT,
                                                </cfif>
                                                EXPENSE_ITEMS AS EI,
                                                EXPENSE_CATEGORY AS EC,
                                                EXPENSE_CENTER AS ECEN
                                                <cfif attributes.control_type eq 22>
                                                ,#dsn#.SETUP_ACTIVITY AS STAC
                                                </cfif>
                                            WHERE 
                                                <cfif isdefined("attributes.internaldemand_id") and len(attributes.internaldemand_id)> <!--- Satınalma Talebinden Geliyorsa --->
                                                    MT.INTERNAL_ID = RW.I_ID
                                                    AND RW.I_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.internaldemand_id#">
                                                <cfelseif isdefined("attributes.offer_id") and len(attributes.offer_id)> <!--- Satınalma Teklifinden Geliyorsa --->
                                                    RW.OFFER_ID =  MT.OFFER_ID AND
                                                    RW.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
                                                <cfelseif isdefined("attributes.order_id") and len(attributes.order_id)> <!--- Satınalma Siparişinden Geliyorsa --->
                                                    RW.ORDER_ID =  MT.ORDER_ID AND
                                                    RW.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
                                                <cfelseif isdefined("attributes.expense_id") and len(attributes.expense_id)> <!--- Masraf Fişinden Geliyorsa --->
                                                    RW.EXPENSE_ID = MT.EXPENSE_ID AND
                                                    RW.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
                                                </cfif>
                                                    AND RW.EXPENSE_CENTER_ID = ECEN.EXPENSE_ID
                                                    AND RW.EXPENSE_ITEM_ID = EI.EXPENSE_ITEM_ID
                                                    AND EI.EXPENSE_CATEGORY_ID = EC.EXPENSE_CAT_ID
                                                    <cfif attributes.control_type eq 22>
                                                        <cfif isdefined("attributes.expense_id") and len(attributes.expense_id)> <!--- Masraf Fişinden Geliyorsa --->
                                                            AND RW.ACTIVITY_TYPE = STAC.ACTIVITY_ID
                                                        <cfelse>
                                                            AND RW.ACTIVITY_TYPE_ID = STAC.ACTIVITY_ID
                                                        </cfif>
                                                    </cfif>
                                                <cfif len(attributes.expense_item_id)>
                                                    AND EI.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
                                                </cfif>
                                                <cfif len(attributes.expense_cat)>
                                                    AND EC.EXPENSE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_cat#">
                                                </cfif>
                                                <cfif len(attributes.expense_center_id)>
                                                    AND ECEN.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
                                                </cfif>
                                                <cfif len( attributes.activity_id )>
                                                    AND RW.ACTIVITY_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.activity_id#">
                                                </cfif>
                                                <cfif len( attributes.project_id ) and len( attributes.project_head )>
                                                    AND MT.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                                                </cfif>
                                                <cfif isDefined("EXPENSE_CAT_ID")>
                                                    AND EC.EXPENSE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EXPENSE_CAT_ID#">
                                                </cfif>
                                        </cfquery>
                                        <cfif GET_EXPENSE_ITEM.recordcount eq 1>
                                            <cfset expense_item_id = GET_EXPENSE_ITEM.expense_item_id>
                                            <cfset expense_item_name = GET_EXPENSE_ITEM.expense_item_name>
                                        </cfif>
                                    </cfif>
                                    <cfset result=arrayNew(1)>                                       
                                        <cfif (amount_dgr) gt (ROW_TOTAL_EXPENSE-TOTAL_AMOUNT_BORC) and (not len(get_status_budget.TRANSFER_STATUS))>
                                            <cfset Budgetinformations = StructNew() />
                                            <cfset Budgetinformations.expense_item_id = isdefined("expense_item_id") ? expense_item_id : ''>
                                            <cfset expense_item_id = ''>
                                            <cfset Budgetinformations.expense_item_name = isdefined("expense_item_name") ? expense_item_name : ''>
                                            <cfset expense_item_name = ''>
                                            <cfset Budgetinformations.expense_id = #expense_id#>
                                            <cfset Budgetinformations.expense_name = #EXPENSE#>
                                            <cfset Budgetinformations.project_id = isdefined("project_id") ? project_id : ''>
                                            <cfif isdefined("activity_id") and len(activity_id)> <cfset Budgetinformations.activity_type = activity_id> </cfif>
                                            <!--- <cfset Budgetinformations.AMOUNT = #TLFormat(NETTOTAL)#> --->
                                            <cfset Budgetinformations.AMOUNT = #TLFormat(amount_dgr-(ROW_TOTAL_EXPENSE - TOTAL_AMOUNT_BORC - (REZ_TOTAL_AMOUNT_ALACAK - REZ_TOTAL_AMOUNT_BORC)))#>
                                            <cfset Budgetinformations.MONEY_CURRENCY = session.ep.money>
                                            <cfset Budgetinformations.reference_no = isdefined("internal_number") ? internal_number : ''>
                                            <cfset Budgetinformations.USABLE_MONEY = #TLFormat(ROW_TOTAL_EXPENSE - TOTAL_AMOUNT_BORC - (REZ_TOTAL_AMOUNT_ALACAK - REZ_TOTAL_AMOUNT_BORC))#>
                                            <cfset ArrayAppend(result, Budgetinformations)>
                                            <cfset attributes.budget_info = LCase(Replace(SerializeJson(result),"//","")) />
                                            <input type="radio" name="row_expense_requests" id="row_expense_requests#currentrow#" value='#attributes.budget_info#'>
                                        <cfelse>
                                            <input type="radio" name="row_expense_requests" id="row_expense_requests#currentrow#" value="" title="Bakiyesi Yeterli Talep veya Daha Önce Talep Edilmiş Bütçe Aktarılamaz" disabled>
                                        </cfif>                                  
                                </td>
                            </cfif>	
                        </tr>
                    </cfoutput>
                </tbody>                
            <cfelse>
                <tbody>
                    <tr>
                        <td colspan="40"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </tbody>
            </cfif>
    </cf_grid_list>
    <form name="form_approveBudget" id="form_approveBudget" method="post" action="">
        <input type="hidden" name="xmlBlock" id="xmlBlock" value="<cfoutput>#GET_XMLBLOCK.PROPERTY_VALUE#</cfoutput>">
        <cfif isdefined("attributes.internaldemand_id") and len(attributes.internaldemand_id)>
            <input type="hidden" name="internaldemand_id" id="internaldemand_id" value="<cfoutput>#attributes.internaldemand_id#</cfoutput>">
        <cfelseif isdefined("attributes.offer_id") and len(attributes.offer_id)>
            <input type="hidden" name="offer_id" id="offer_id" value="<cfoutput>#attributes.offer_id#</cfoutput>">
        <cfelseif isdefined("attributes.order_id") and len(attributes.order_id)>
            <input type="hidden" name="order_id" id="order_id" value="<cfoutput>#attributes.order_id#</cfoutput>">
        <cfelseif isdefined("attributes.expense_id") and len(attributes.expense_id)>
            <input type="hidden" name="expense_" id="expense_" value="<cfoutput>#attributes.expense_id#</cfoutput>">
        </cfif>
        <cfif GET_EXPENSE_BUDGET.recordcount gt 0 and GET_XMLBLOCK.PROPERTY_VALUE eq 1>
            <cfset result=arrayNew(1)>
            <cfset sayac = 0>
            <cfloop query="GET_EXPENSE_BUDGET">
                <cfset get_status_budget = comp.GetBudgetStatus(
                        expense_id: '#expense_id#',
                        expense_item_id : '#(isdefined("expense_item_id") ? expense_item_id : '')#',
                        internaldemand_id : '#(isdefined("attributes.internaldemand_id") ? attributes.internaldemand_id : '')#',
                        offer_id : '#(isdefined("attributes.offer_id") ? attributes.offer_id : '')#',
                        order_id : '#(isdefined("attributes.order_id") ? attributes.order_id : '')#',
                        expense_ : '#(isdefined("attributes.expense_id") ? attributes.expense_id : '')#'
                        )>
                <cfif (NETTOTAL) gt (ROW_TOTAL_EXPENSE-TOTAL_AMOUNT_BORC) and (not len(get_status_budget.TRANSFER_STATUS))>
                    <cfset sayac = sayac + 1>
                    <cfset Budgetinformations = StructNew() />
                    <cfset Budgetinformations.expense_item_id = isdefined("expense_item_id") ? expense_item_id : ''>
                    <cfset Budgetinformations.expense_item_name = isdefined("expense_item_name") ? expense_item_name : ''>
                    <cfset Budgetinformations.expense_id = #expense_id#>
                    <cfset Budgetinformations.expense_name = #EXPENSE#>
                    <cfset Budgetinformations.project_id = isdefined("project_id") ? project_id : ''>
                    <cfset Budgetinformations.reference_no = isdefined("internal_number") ? internal_number : ''>
                    <cfset Budgetinformations.sayac = sayac>
                    <cfif isdefined("activity_id") and len(activity_id)> <cfset Budgetinformations.activity_type = activity_id> </cfif>
                    <!---  <cfset Budgetinformations.AMOUNT = #TLFormat(NETTOTAL)#> --->                     
                    <cfset Budgetinformations.AMOUNT = #TLFormat(NETTOTAL-(ROW_TOTAL_EXPENSE - TOTAL_AMOUNT_BORC - (REZ_TOTAL_AMOUNT_ALACAK - REZ_TOTAL_AMOUNT_BORC)))#>
                    <cfset Budgetinformations.MONEY_CURRENCY = session.ep.money>
                    <cfset Budgetinformations.USABLE_MONEY = #TLFormat(ROW_TOTAL_EXPENSE - TOTAL_AMOUNT_BORC - (REZ_TOTAL_AMOUNT_ALACAK - REZ_TOTAL_AMOUNT_BORC))#>
                    <cfset ArrayAppend(result, Budgetinformations)>
                </cfif>
            </cfloop>  
            <cfset attributes.budget_info = LCase(Replace(SerializeJson(result),"//","")) />
            <textarea name="budget_info" id="budget_info" style = "display:none;"><cfoutput>#attributes.budget_info#</cfoutput></textarea>
            <cfif sayac gt 0>
                <div class="ui-form-list-btn">
                    <button type="submit" name="submit" value=""  class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left" title="<cf_get_lang dictionary_id='61359.Bütçe Aktarım Gerçekleştir'>"><i class="fa fa-exchange"></i> <cf_get_lang dictionary_id='61358.Bütçe Aktarım Gerçekleştir'></button>
                </div>      
            </cfif>         
        <cfelseif GET_EXPENSE_BUDGET.recordcount gt 0>
            <textarea name="budget_info" id="budget_info" style = "display:none;"></textarea>
            <div class="ui-form-list-btn">
                <button type="submit" name="submit" value=""  class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left" title="<cf_get_lang dictionary_id='61359.Bütçe Aktarım Gerçekleştir'>"><i class="fa fa-exchange"></i> <cf_get_lang dictionary_id='61358.Bütçe Aktarım Gerçekleştir'></button>
            </div>
        </cfif>
    </form>
</div>
<script>   
    function loader_page()
		{  
            exp_id = $("#expense_item_id").val();
            exp_cat_id = $("#expense_cat").val();
            exp_center_id = $("#expense_center_id").val();
            general_budget_id = ( $.trim($("#budget_name").val()) != '' ) ? $("#general_budget_id").val() : '';
            budget_name = $.trim($("#budget_name").val());
            project_id = ( $.trim($("#project_head").val()) != '' ) ? $("#project_id").val() : '';
            project_head = $.trim($("#project_head").val());
            activity_id = $("#activity_id").val();
            control_type = $("#control_type").val();
            
            url = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.budget_compliance_check&expense_item_id='+exp_id+'&expense_cat='+exp_cat_id+'&expense_center_id='+exp_center_id+'&general_budget_id='+general_budget_id+'&budget_name='+budget_name+'&project_id='+project_id+'&project_head='+project_head+'&activity_id='+activity_id+'&control_type='+control_type+'&internaldemand_id=<cfif isdefined("attributes.internaldemand_id")><cfoutput>#attributes.internaldemand_id#</cfoutput></cfif>&offer_id=<cfif isdefined("attributes.offer_id")><cfoutput>#attributes.offer_id#</cfoutput></cfif>&order_id=<cfif isdefined("attributes.order_id")><cfoutput>#attributes.order_id#</cfoutput></cfif>&expense_id=<cfif isdefined("attributes.expense_id")><cfoutput>#attributes.expense_id#</cfoutput></cfif>';
			AjaxPageLoad(url,'div_rows',1);
			return false;
        }
    $("form[name = form_approveBudget]").submit(function(){
        var xml_case = document.getElementById('xmlBlock').value;
        if(xml_case == 0)
        {
            radio_selected = '';
            is_secili = 0;
            if(document.getElementsByName("row_expense_requests").length != undefined) /*n tane*/
            {	
                for (var i=0; i < document.getElementsByName("row_expense_requests").length; i++)
                {
                    if((document.getElementsByName("row_expense_requests")[i].checked==true)){
                        radio_selected = document.getElementsByName("row_expense_requests")[i].value;
                        is_secili = 1;
                    }
                }
            }		
            if(is_secili==0)
            {
                alert("<cf_get_lang dictionary_id='38840.Lütfen İşlem Seçiniz!'>");
                return false;
            }
            else
            {
                document.getElementById('budget_info').value = radio_selected;
                form_approveBudget.action='<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.budget_transfer_demand&event=add';
                form_approveBudget.submit();
                return false;
            }
        }
        else
        {
            form_approveBudget.action='<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.budget_transfer_demand&event=add';
            form_approveBudget.submit();
        }
        
    });
</script>