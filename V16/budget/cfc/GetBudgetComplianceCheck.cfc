<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
	<cffunction name="GetBudgetControl" returntype="any" access="remote">
        <cfargument name="internaldemand_id" type="any" required="No" default="">
        <cfargument name="offer_id" type="any" required="No" default="">
        <cfargument name="order_id" type="any" required="No" default="">
        <cfargument name="expense_id" type="any" required="No" default="">
        <cfargument name="invoice_id" type="any" required="No" default="">
        <cfargument name="control_type" type="any" required="No" default="20">
        <cfargument name="expense_item_id" type="any" required="No" default="">
        <cfargument name="expense_cat" type="any" required="No" default="">
        <cfargument name="expense_center_id" type="any" required="No" default="">
        <cfargument name="activity_id" type="any" required="No" default="">
        <cfargument name="project_id" type="any" required="No" default="">
        <cfargument name="general_budget_id" type="any" required="No" default="">
        <cfargument name="budget_name" type="any" required="No" default="">
        <cfargument name="project_head" type="any" required="No" default="">
        <cfargument name="new_datasource" type="any" required="No" default="">
        <cfif IsDefined("arguments.new_datasource") and len(arguments.new_datasource)>
            <cfset dsn3 = arguments.new_datasource>
        <cfelse>
            <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
        </cfif>
        <cfquery name="GetBudgetControl" datasource="#dsn3#">
            SELECT 
                GEC.EXPENSE_ID,
                GEC.EXPENSE,
                GEC.EXPENSE_DEPARTMENT_ID,
                ISNULL(RESPONSIBLE1,0) AS RESPONSIBLE1,
                ISNULL(RESPONSIBLE2,0) AS RESPONSIBLE2,
                ISNULL(RESPONSIBLE3,0) AS RESPONSIBLE3,
                <cfif arguments.control_type eq 20>
                    GEC.EXPENSE_CAT_ID,
                    GEC.EXPENSE_CAT_NAME,
                <cfelseif arguments.control_type eq 21>
                    GEC.PROJECT_ID,
                <cfelseif arguments.control_type eq 22>
                    GEC.ACTIVITY_NAME,
                    GEC.ACTIVITY_ID,
                <cfelse>
                    GEC.EXPENSE_ITEM_ID,
                    GEC.EXPENSE_ITEM_NAME,
                </cfif>
                GEC.NETTOTAL,
                <cfif isdefined("arguments.internaldemand_id") and len(arguments.internaldemand_id)>
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
                ISNULL(TOTAL_AMOUNT_ALACAK, 0) AS TOTAL_AMOUNT_ALACAK
	            ,ISNULL(TOTAL_AMOUNT_2_ALACAK, 0) AS TOTAL_AMOUNT_2_ALACAK
            FROM
                (
                    SELECT 
                        <cfif isdefined("arguments.internaldemand_id") and len(arguments.internaldemand_id)> <!--- Satınalma Talebinden Geliyorsa --->
                            SUM(RW.OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE,
                            SUM(RW.NETTOTAL) AS NETTOTAL,
                            MT.INTERNAL_NUMBER AS INTERNAL_NUMBER,
                        <cfelseif isdefined("arguments.offer_id") and len(arguments.offer_id)> <!--- Satınalma Teklifinden Geliyorsa --->
                            SUM(RW.PRICE_OTHER) AS OTHER_MONEY_VALUE,
                            SUM((RW.PRICE * RW.QUANTITY)) AS NETTOTAL,
                        <cfelseif isdefined("arguments.order_id") and len(arguments.order_id)> <!--- Satınalma Siparişinden Geliyorsa --->
                            SUM(RW.OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE,
                            SUM(RW.NETTOTAL) AS NETTOTAL,
                        <cfelseif isdefined("arguments.expense_id") and len(arguments.expense_id)> <!--- MAsraf fişinden Geliyorsa --->
                            SUM(RW.OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE,
                            SUM(RW.TOTAL_AMOUNT) AS NETTOTAL,
                        <cfelseif isdefined("arguments.invoice_id") and len(arguments.invoice_id)> <!--- Faturadan Geliyorsa --->
                            SUM(RW.OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE,
                            SUM(RW.NETTOTAL) AS NETTOTAL,
                        </cfif>
                            ECEN.EXPENSE_ID,
                            ECEN.EXPENSE,
                            ISNULL(ECEN.RESPONSIBLE1,0) AS RESPONSIBLE1,
                            ISNULL(ECEN.RESPONSIBLE2,0) AS RESPONSIBLE2,
                            ISNULL(ECEN.RESPONSIBLE3,0) AS RESPONSIBLE3,
                            ECEN.EXPENSE_DEPARTMENT_ID
                            <cfif arguments.control_type eq 20>
                                ,EC.EXPENSE_CAT_ID
                                ,EC.EXPENSE_CAT_NAME
                            <cfelseif arguments.control_type eq 21>
                                ,PP.PROJECT_ID
                            <cfelseif arguments.control_type eq 22>
                                ,STAC.ACTIVITY_NAME
                                ,STAC.ACTIVITY_ID
                            <cfelse>
                                ,EI.EXPENSE_ITEM_ID
                                ,EI.EXPENSE_ITEM_NAME
                            </cfif>
                    FROM 
                        <cfif isdefined("arguments.internaldemand_id") and len(arguments.internaldemand_id)> <!--- Satınalma Talebinden Geliyorsa --->
                            INTERNALDEMAND_ROW AS RW,
                            INTERNALDEMAND AS MT,
                        <cfelseif isdefined("arguments.offer_id") and len(arguments.offer_id)> <!--- Satınalma Teklifinden Geliyorsa --->
                            OFFER_ROW AS RW,
                            OFFER AS MT,
                        <cfelseif isdefined("arguments.order_id") and len(arguments.order_id)> <!--- Satınalma Siparişinden Geliyorsa --->
                            <cfif IsDefined("arguments.new_datasource") and len(arguments.new_datasource)>#dsn#_#session.ep.company_id#.</cfif>ORDER_ROW AS RW,
                            <cfif IsDefined("arguments.new_datasource") and len(arguments.new_datasource)>#dsn#_#session.ep.company_id#.</cfif>ORDERS AS MT,
                        <cfelseif isdefined("arguments.expense_id") and len(arguments.expense_id)> <!--- Masraf Fişinden Geliyorsa --->
                            #dsn2#.EXPENSE_ITEMS_ROWS AS RW,
                            #dsn2#.EXPENSE_ITEM_PLANS AS MT,
                        <cfelseif isdefined("arguments.invoice_id") and len(arguments.invoice_id)> <!--- Faturadan Geliyorsa --->
                            #dsn2#.INVOICE_ROW AS RW,
                            #dsn2#.INVOICE AS MT,
                        </cfif>
                        #dsn2#.EXPENSE_ITEMS AS EI,
                        #dsn2#.EXPENSE_CATEGORY AS EC,
                        #dsn2#.EXPENSE_CENTER AS ECEN
                        <cfif arguments.control_type eq 22>
                            ,#dsn#.SETUP_ACTIVITY AS STAC
                        <cfelseif arguments.control_type eq 21>
                            ,#dsn#.PRO_PROJECTS AS PP
                        </cfif>
                    WHERE 
                        <cfif isdefined("arguments.internaldemand_id") and len(arguments.internaldemand_id)> <!--- Satınalma Talebinden Geliyorsa --->
                            MT.INTERNAL_ID = RW.I_ID
                            AND RW.I_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.internaldemand_id#">
                        <cfelseif isdefined("arguments.offer_id") and len(arguments.offer_id)> <!--- Satınalma Teklifinden Geliyorsa --->
                            RW.OFFER_ID =  MT.OFFER_ID AND
                            RW.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.offer_id#">
                        <cfelseif isdefined("arguments.order_id") and len(arguments.order_id)> <!--- Satınalma Siparişinden Geliyorsa --->
                            RW.ORDER_ID =  MT.ORDER_ID AND
                            RW.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
                        <cfelseif isdefined("arguments.expense_id") and len(arguments.expense_id)> <!--- Masraf Fişinden Geliyorsa --->
                            RW.EXPENSE_ID = MT.EXPENSE_ID AND
                            RW.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#">
                        <cfelseif isdefined("arguments.invoice_id") and len(arguments.invoice_id)> <!---Faturadan Geliyorsa --->
                            RW.INVOICE_ID = MT.INVOICE_ID AND
                            RW.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_id#">
                        </cfif>
                        <cfif isdefined("arguments.invoice_id") and len(arguments.invoice_id)> <!---Faturadan Geliyorsa --->
                            AND RW.ROW_EXP_CENTER_ID = ECEN.EXPENSE_ID
                            AND RW.ROW_EXP_ITEM_ID = EI.EXPENSE_ITEM_ID
						<cfelse>
                            AND RW.EXPENSE_CENTER_ID = ECEN.EXPENSE_ID
                            AND RW.EXPENSE_ITEM_ID = EI.EXPENSE_ITEM_ID
						</cfif>
                            AND EI.EXPENSE_CATEGORY_ID = EC.EXPENSE_CAT_ID
                            <cfif arguments.control_type eq 22>
                                <cfif isdefined("arguments.expense_id") and len(arguments.expense_id)> <!--- Masraf Fişinden Geliyorsa --->
                                    AND RW.ACTIVITY_TYPE = STAC.ACTIVITY_ID
                                <cfelse>
                                    AND RW.ACTIVITY_TYPE_ID = STAC.ACTIVITY_ID
                                </cfif>
                            <cfelseif arguments.control_type eq 21>
                                AND MT.PROJECT_ID = PP.PROJECT_ID
                            </cfif>
                        <cfif len(arguments.expense_item_id)>
                            AND EI.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_item_id#">
                        </cfif>
                        <cfif len(arguments.expense_cat)>
                            AND EC.EXPENSE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_cat#">
                        </cfif>
                        <cfif len(arguments.expense_center_id)>
                            AND ECEN.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_center_id#">
                        </cfif>
                        <cfif len( arguments.activity_id )>
                            AND RW.ACTIVITY_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activity_id#">
                        </cfif>
                        <cfif len( arguments.project_id ) and len( arguments.project_head )>
                            AND MT.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                        </cfif>
                    GROUP BY 
                        ECEN.EXPENSE_ID,
                        ECEN.EXPENSE,
                        ECEN.RESPONSIBLE1,
                        ECEN.RESPONSIBLE2,
                        ECEN.RESPONSIBLE3,
                        ECEN.EXPENSE_DEPARTMENT_ID
                        <cfif arguments.control_type eq 20>
                            ,EC.EXPENSE_CAT_ID
                            ,EC.EXPENSE_CAT_NAME
                        <cfelseif arguments.control_type eq 21>
                            ,PP.PROJECT_ID
                        <cfelseif arguments.control_type eq 22>
                            ,STAC.ACTIVITY_NAME
                            ,STAC.ACTIVITY_ID
                        <cfelse>
                            ,EI.EXPENSE_ITEM_ID
                            ,EI.EXPENSE_ITEM_NAME
                        </cfif> 
                        <cfif isdefined("arguments.internaldemand_id") and len(arguments.internaldemand_id)>
                            ,INTERNAL_NUMBER
                        </cfif>
                ) AS GEC
            <cfif isdefined("arguments.internaldemand_id") and len(arguments.internaldemand_id) and len( arguments.general_budget_id ) and len( arguments.budget_name )>
            JOIN
            <cfelse>
            LEFT JOIN
            </cfif>    
                (
                    SELECT 
                        ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE),0) ROW_TOTAL_EXPENSE,
                        ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE_2),0) ROW_TOTAL_EXPENSE_2,
                        BUDGET_PLAN_ROW.EXP_INC_CENTER_ID,
                        <cfif arguments.control_type eq 20>
                            EXPENSE_CATEGORY.EXPENSE_CAT_ID
                        <cfelseif arguments.control_type eq 21>
                            BUDGET_PLAN_ROW.PROJECT_ID
                        <cfelse>
                            BUDGET_PLAN_ROW.BUDGET_ITEM_ID
                        </cfif>
                    FROM
                        #dsn#.BUDGET_PLAN,
                        #dsn#.BUDGET_PLAN_ROW,
                        #dsn#.BUDGET 
                        <cfif arguments.control_type eq 20>
                        ,#dsn2#.EXPENSE_CATEGORY EXPENSE_CATEGORY
                        </cfif>
                    WHERE 
                        BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
                        BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID AND
                        BUDGET_PLAN.BUDGET_ID = BUDGET.BUDGET_ID 
                        <cfif arguments.control_type eq 20>
                            AND BUDGET_PLAN_ROW.BUDGET_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM #dsn2#.EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID = EXPENSE_CATEGORY.EXPENSE_CAT_ID)
                        </cfif>
                        AND BUDGET.PERIOD_YEAR = #session.ep.period_year#
                        <cfif len( arguments.general_budget_id ) and len( arguments.budget_name )>
                            AND BUDGET_PLAN.BUDGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.general_budget_id#">
                        </cfif>
                    GROUP BY
                        BUDGET_PLAN_ROW.EXP_INC_CENTER_ID,
                        <cfif arguments.control_type eq 20>
                            EXPENSE_CATEGORY.EXPENSE_CAT_ID
                        <cfelseif arguments.control_type eq 21>
                            BUDGET_PLAN_ROW.PROJECT_ID
                        <cfelse>
                            BUDGET_PLAN_ROW.BUDGET_ITEM_ID
                        </cfif>
                ) AS PLANLANAN
            ON PLANLANAN.EXP_INC_CENTER_ID = GEC.EXPENSE_ID AND <cfif arguments.control_type eq 20> PLANLANAN.EXPENSE_CAT_ID = GEC.EXPENSE_CAT_ID <cfelseif arguments.control_type eq 21> PLANLANAN.PROJECT_ID = GEC.PROJECT_ID <cfelse> PLANLANAN.BUDGET_ITEM_ID = GEC.EXPENSE_ITEM_ID</cfif>
            LEFT JOIN
                (
                    SELECT
                        SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT ELSE 0 END) AS TOTAL_AMOUNT_BORC,
                        SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT_2 ELSE 0 END) AS TOTAL_AMOUNT_2_BORC,
                        SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT ELSE 0 END) AS TOTAL_AMOUNT_ALACAK,
                        SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT_2 ELSE 0 END) TOTAL_AMOUNT_2_ALACAK,
                        EXPENSE_CENTER_ID,
                        <cfif arguments.control_type eq 20>
                            EXPENSE_CAT_ID
                        <cfelseif arguments.control_type eq 21>
                            PROJECT_ID
                        <cfelse>
                            EXPENSE_ITEM_ID
                        </cfif>
                    FROM
                    (
                        SELECT 
                            (EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT - EXPENSE_ITEMS_ROWS.AMOUNT_KDV) TOTAL_AMOUNT,
                            EXPENSE_ITEMS_ROWS.OTHER_MONEY_VALUE_2 TOTAL_AMOUNT_2,
                            EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID,
                            EXPENSE_ITEMS_ROWS.IS_INCOME,
                            <cfif arguments.control_type eq 20>
                                EXPENSE_CATEGORY.EXPENSE_CAT_ID
                            <cfelseif arguments.control_type eq 21>
                                EXPENSE_ITEMS_ROWS.PROJECT_ID
                            <cfelse>
                            EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID
                            </cfif>
                        FROM
                            #dsn2#.EXPENSE_ITEMS_ROWS
                            <cfif arguments.control_type eq 20>
                                ,#dsn2#.EXPENSE_CATEGORY EXPENSE_CATEGORY
                            </cfif>
                        WHERE
                            TOTAL_AMOUNT > 0
                        <cfif arguments.control_type eq 20> AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM #dsn2#.EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID = EXPENSE_CATEGORY.EXPENSE_CAT_ID)</cfif>		
                    )T1
                    GROUP BY
                        EXPENSE_CENTER_ID,
                        <cfif arguments.control_type eq 20>
                            EXPENSE_CAT_ID
                        <cfelseif arguments.control_type eq 21>
                            PROJECT_ID
                        <cfelse>
                            EXPENSE_ITEM_ID
                        </cfif>

                ) AS GERCEKLESEN  
                    ON GERCEKLESEN.EXPENSE_CENTER_ID = GEC.EXPENSE_ID AND <cfif arguments.control_type eq 20> GEC.EXPENSE_CAT_ID = GERCEKLESEN.EXPENSE_CAT_ID <cfelseif arguments.control_type eq 21> GERCEKLESEN.PROJECT_ID =  GEC.PROJECT_ID <cfelse> GEC.EXPENSE_ITEM_ID = GERCEKLESEN.EXPENSE_ITEM_ID </cfif>
            LEFT JOIN
                (
                    SELECT
                        SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT ELSE 0 END) AS REZ_TOTAL_AMOUNT_BORC,
                        SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT_2 ELSE 0 END) AS REZ_TOTAL_AMOUNT_2_BORC,
                        SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT ELSE 0 END) AS REZ_TOTAL_AMOUNT_ALACAK,
                        SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT_2 ELSE 0 END) REZ_TOTAL_AMOUNT_2_ALACAK,
                        EXPENSE_CENTER_ID,
                        <cfif arguments.control_type eq 20>
                            EXPENSE_CAT_ID
                        <cfelseif arguments.control_type eq 21>
                            PROJECT_ID
                        <cfelse>
                            EXPENSE_ITEM_ID
                        </cfif>
                    FROM
                    (
                        SELECT 
                            (ERR.TOTAL_AMOUNT - ERR.AMOUNT_KDV) TOTAL_AMOUNT,
                            ERR.OTHER_MONEY_VALUE_2 TOTAL_AMOUNT_2,
                            ERR.EXPENSE_CENTER_ID,
                            ERR.IS_INCOME,
                            <cfif arguments.control_type eq 20>
                                EXPENSE_CATEGORY.EXPENSE_CAT_ID
                            <cfelseif arguments.control_type eq 21>
                                ERR.PROJECT_ID
                            <cfelse>
                                ERR.EXPENSE_ITEM_ID   
                            </cfif>
                        FROM
                            #dsn2#.EXPENSE_RESERVED_ROWS AS ERR
                            <cfif arguments.control_type eq 20>
                                ,#dsn2#.EXPENSE_CATEGORY EXPENSE_CATEGORY
                            </cfif>
                        WHERE
                            TOTAL_AMOUNT > 0	
                            <cfif arguments.control_type eq 20>AND ERR.EXPENSE_ITEM_ID IN(SELECT EXPENSE_ITEM_ID FROM #dsn2#.EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID = EXPENSE_CATEGORY.EXPENSE_CAT_ID)</cfif>			
                    )T1
                    GROUP BY
                        EXPENSE_CENTER_ID,
                        <cfif arguments.control_type eq 20>
                            EXPENSE_CAT_ID
                        <cfelseif arguments.control_type eq 21>
                            PROJECT_ID
                        <cfelse>
                            EXPENSE_ITEM_ID
                        </cfif>
                ) AS RESERVED  
                    ON RESERVED.EXPENSE_CENTER_ID = GEC.EXPENSE_ID AND <cfif arguments.control_type eq 20> GEC.EXPENSE_CAT_ID = RESERVED.EXPENSE_CAT_ID <cfelseif arguments.control_type eq 21> RESERVED.PROJECT_ID =  GEC.PROJECT_ID <cfelse> GEC.EXPENSE_ITEM_ID = RESERVED.EXPENSE_ITEM_ID </cfif>
        </cfquery>        
    <cfreturn GetBudgetControl>
    </cffunction>
    <cffunction name="UPD_ORDER_STAGE" access="remote" returntype="any">
        <cfquery name="UPD_ORDER_STAGE" datasource="#dsn3#">
            UPDATE
                ORDERS
            SET
                ORDER_STAGE  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stage_id#">
            WHERE
                ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        </cfquery>
    </cffunction>
    <cffunction name="get_internaldemandEmp" access="remote" returntype="any">
       <cfquery name="get_internaldemandEmp" datasource="#dsn3#">
            SELECT 
                IRR.INTERNALDEMAND_ID,
                I.FROM_POSITION_CODE,
                I.TO_POSITION_CODE 
            FROM 
                ORDERS AS O,
                INTERNALDEMAND_RELATION  AS IRR,
                INTERNALDEMAND AS I 
            WHERE 
                IRR.TO_OFFER_ID = O.OFFER_ID AND 
                I.INTERNAL_ID = IRR.INTERNALDEMAND_ID AND 
                ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        </cfquery>
        <cfreturn get_internaldemandEmp>
    </cffunction>
    <cffunction name="GetOrderProject" access="remote" returntype="any">
       <cfquery name="GetOrderProject" datasource="#dsn3#">
            SELECT 
               ORS.PROJECT_ID,
               P.PROJECT_HEAD
            FROM 
                ORDERS AS ORS
                LEFT JOIN #dsn#.PRO_PROJECTS P ON P.PROJECT_ID = ORS.PROJECT_ID
            WHERE 
                 ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
        </cfquery>
        <cfreturn GetOrderProject>
    </cffunction>
    <cffunction name="UPD_INTERNAL_STAGE" access="remote" returntype="any">
        <cfquery name="UPD_INTERNAL_STAGE" datasource="#dsn2#">
            UPDATE
                INTERNALDEMAND
            SET
                INTERNALDEMAND_STAGE  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stage_id#">
            WHERE
                INTERNAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        </cfquery>
    </cffunction>
</cfcomponent>