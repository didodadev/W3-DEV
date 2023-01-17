<!---
File: health_expence.cfc
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date: 26.11.2019
Controller: -
Description: 
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cffunction name="GET_HEALTH_EXPENSE_ITEM_PLANS" access="remote"  returntype="any">
        <cfargument name="expense_id" default=""> 
        <cfquery name="GET_HEALTH_EXPENSE_ITEM_PLANS" datasource="#dsn2#">
            SELECT
                *
            FROM   
                EXPENSE_ITEM_PLANS 
            WHERE
                EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#">
        </cfquery>
        <cfreturn GET_HEALTH_EXPENSE_ITEM_PLANS>
    </cffunction>
    <cffunction name="GET_HEALTH_EXPENSE" access="remote"  returntype="any">
        <cfargument name="expense_id" default=""> 
        <cfargument name="type" default="">
        <cfargument name="health_id" default="">        
        <cfquery name="GET_HEALTH_EXPENSE" datasource="#dsn2#">
            SELECT
                EH.*,
                SC.COMPLAINT,
                SDM.DRUG_MEDICINE,
                SL.LIMB_NAME
            FROM   
                HEALTH_EXPENSE EH
                LEFT JOIN #dsn#.SETUP_COMPLAINTS SC ON SC.COMPLAINT_ID = EH.COMPLAINT_ID
                LEFT JOIN #dsn#.SETUP_DECISIONMEDICINE SDM ON SDM.DRUG_ID = EH.DRUG_ID
                LEFT JOIN #dsn#.SETUP_LIMB SL ON SL.LIMB_ID = EH.LIMB_ID
            WHERE
                <cfif isdefined("health_id") and len(health_id)>
                    EH.EXPENSE_ITEM_PLAN_REQUESTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#health_id#">
                <cfelse>
                    EH.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#">
                </cfif>
                <cfif len(arguments.type) and arguments.type eq 1>
                    AND EH.COMPLAINT_ID IS NOT NULL
                <cfelseif len(arguments.type) and arguments.type eq 2>
                    AND EH.DRUG_ID IS NOT NULL
                </cfif>
        </cfquery>
        <cfreturn GET_HEALTH_EXPENSE>
    </cffunction>
    <cffunction name="DEL_ALL_HEALTH_EXPENSE" access="remote"  returntype="any">
        <cfargument name="expense_id" default="">
        <cfargument name="health_id" default="">
        <cfargument name="drug_or_limb" default="">
        <cfquery name="DEL_HEALTH_EXPENSE" datasource="#dsn2#">
            DELETE FROM HEALTH_EXPENSE 
            WHERE 
                1=1
                <cfif isdefined("arguments.health_id") and len(arguments.health_id)>
                   AND EXPENSE_ITEM_PLAN_REQUESTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.health_id#">
                <cfelse>
                   AND EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#">
                </cfif>
        </cfquery>
    </cffunction>
    <cffunction name="ADD_HEALTH_EXPENSE" access="remote"  returntype="any">
        <cfargument name="complaint_id" default="">
        <cfargument name="limb_id" default=""> 
        <cfargument name="drug_id" default=""> 
        <cfargument name="health_expense_amount" default=""> 
        <cfargument name="health_expense_price" default=""> 
        <cfargument name="health_expense_total" default="">
        <cfargument name="health_expense_code" default="">
        <cfargument name="money" default="">
        <cfargument name="expense_id" default="">
        <cfargument name="health_id" default="">
        <cfargument name="list_price" default="">
        <cfargument name="purchase_price" default="">
        <cfargument name="discount_rate" default="">
        <cfquery name="ADD_HEALTH_EXPENSE" datasource="#dsn2#" result="MAX_ID">
            INSERT INTO
                HEALTH_EXPENSE
                (
                    EXPENSE_ID,
                    HEALTH_EXPENSE_CODE,
                    HEALTH_EXPENSE_AMOUNT,
                    HEALTH_EXPENSE_PRICE,
                    HEALTH_EXPENSE_TOTAL,
                    MONEY,
                    COMPLAINT_ID,
                    HEALTH_EXPENSE_LIMB,
                    DRUG_ID,
                    RECORD_IP,
                    RECORD_DATE,
                    RECORD_EMP,
                    EXPENSE_ITEM_PLAN_REQUESTS_ID,
                    LIST_PRICE,
                    PURCHASE_PRICE,
                    DISCOUNT_RATE
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.health_expense_code#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.health_expense_amount#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.health_expense_price#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.health_expense_total#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.money#">,
                    <cfif len(arguments.complaint_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.complaint_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.limb_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limb_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.drug_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.drug_id#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#health_id#">,
                    <cfif len(arguments.list_price)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.list_price#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.purchase_price)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.purchase_price#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.discount_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.discount_rate#"><cfelse>NULL</cfif>
                )
        </cfquery>
        <cfreturn MAX_ID>
    </cffunction>
    <cffunction name="UPD_HEALTH_EXPENSE" access="remote"  returntype="any">
        <cfargument name="complaint_id" default="">
        <cfargument name="limb_id" default="">  
        <cfargument name="health_expense_amount" default=""> 
        <cfargument name="health_expense_price" default=""> 
        <cfargument name="health_expense_total" default="">
        <cfargument name="health_expense_code" default="">
        <cfargument name="money" default="">
        <cfargument name="expense_id" default="">
        <cfargument name="drug_id" default="">
        <cfargument name="health_expense_id" default="">
        <cfargument name="health_id" default="">
        <cfquery name="UPD_HEALTH_EXPENSE" datasource="#dsn2#">
            UPDATE
                HEALTH_EXPENSE
            SET 
                EXPENSE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#">,
                HEALTH_EXPENSE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.health_expense_code#">,
                HEALTH_EXPENSE_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.health_expense_amount#">,
                HEALTH_EXPENSE_PRICE = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.health_expense_price#">,
                HEALTH_EXPENSE_TOTAL = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.health_expense_total#">,
                MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.money#">,
                COMPLAINT_ID = <cfif len(arguments.complaint_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.complaint_id#"><cfelse>NULL</cfif>,
                LIMB_ID =  <cfif len(arguments.limb_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limb_id#"><cfelse>NULL</cfif>,
                DRUG_ID = <cfif len(arguments.drug_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.drug_id#"><cfelse>NULL</cfif>,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
                EXPENSE_ITEM_PLAN_REQUESTS_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#health_id#">
            WHERE
                HEALTH_EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.health_expense_id#">
        </cfquery>
    </cffunction>
    <cffunction name="DEL_HEALTH_EXPENSE" access="remote"  returntype="any">
        <cfargument name="id" default=""> 
        <cfquery name="DEL_HEALTH_EXPENSE" datasource="#dsn2#">
            DELETE FROM HEALTH_EXPENSE WHERE HEALTH_EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
    </cffunction>
    <cffunction name="SAVE_LIMB" access="remote"  returntype="any">
        <cfargument name="limb_id" default=""> 
        <cfargument name="health_id" default="">
        <cfargument name="measurement" default="">
        <cfquery name="SAVE_LIMB" datasource="#dsn2#" result="MAX_ID">
            INSERT INTO
                HEALTH_EXPENSE
                (
                    EXPENSE_ID,
                    LIMB_ID,
                    RECORD_IP,
                    RECORD_DATE,
                    RECORD_EMP,
                    EXPENSE_ITEM_PLAN_REQUESTS_ID,
                    LIMB_MEASUREMENT
                )
            VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.health_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limb_id#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.health_id#">,
                    <cfif len(arguments.measurement)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.measurement#"><cfelse>NULL</cfif>
                )
        </cfquery>
        <cfreturn MAX_ID>
    </cffunction>
    <cffunction name="GET_HEALTH_EXPENSE_LIMB" access="remote" returntype="any">
        <cfargument name="health_id" default="">        
        <cfquery name="GET_HEALTH_EXPENSE_LIMB" datasource="#dsn2#">
            SELECT
                LIMB_ID
            FROM   
                HEALTH_EXPENSE
            WHERE
                (EXPENSE_ITEM_PLAN_REQUESTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.health_id#"> OR
                EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.health_id#">)
                AND LIMB_ID IS NOT NULL
        </cfquery>
        <cfreturn GET_HEALTH_EXPENSE_LIMB>
    </cffunction>
    <cffunction name="GET_USE_OF_TOTAL_LIMBS" access="remote" returntype="any">
        <cfargument name="emp_id" default="">
        <cfargument name="assurance_id" default="">
        <cfquery name="GET_USE_OF_TOTAL_LIMBS" datasource="#dsn2#">
            SELECT
                HE.LIMB_ID,
                SL.LIMB_NAME,
                COUNT(HE.LIMB_ID) AS COUNT,
                SHL.MAX
            FROM
                HEALTH_EXPENSE HE
                LEFT JOIN EXPENSE_ITEM_PLAN_REQUESTS EIPR ON HE.EXPENSE_ITEM_PLAN_REQUESTS_ID = EIPR.EXPENSE_ID
                LEFT JOIN #dsn#.SETUP_LIMB SL ON SL.LIMB_ID = HE.LIMB_ID
                LEFT JOIN #dsn#.SETUP_HEALTH_ASSURANCE_TYPE_LIMB SHL ON SHL.LIMB_ID = HE.LIMB_ID AND SHL.ASSURANCE_ID = EIPR.ASSURANCE_ID
            WHERE
                1 = 1
            <cfif len(arguments.emp_id)>
                AND EIPR.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#"> 
            </cfif>
            <cfif len(arguments.assurance_id)>
                AND EIPR.ASSURANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#">
                </cfif>
                AND HE.LIMB_ID IS NOT NULL
            GROUP BY
                HE.LIMB_ID, LIMB_NAME, MAX
        </cfquery>
        <cfreturn GET_USE_OF_TOTAL_LIMBS>
    </cffunction>
    <cffunction name="GET_USE_OF_TOTAL_COMPLAINTS" access="remote" returntype="any">
        <cfargument name="emp_id" default="">
        <cfargument name="assurance_id" default="">
        <cfquery name="GET_USE_OF_TOTAL_COMPLAINTS" datasource="#dsn2#">
            SELECT
                HE.COMPLAINT_ID,
                SC.COMPLAINT,
                SUM(HE.HEALTH_EXPENSE_TOTAL) AS TOTAL,
                SUM(HEALTH_EXPENSE_AMOUNT) AS COUNT,
                SHA.MAX
            FROM
                HEALTH_EXPENSE HE
                LEFT JOIN EXPENSE_ITEM_PLAN_REQUESTS EIPR ON HE.EXPENSE_ITEM_PLAN_REQUESTS_ID = EIPR.EXPENSE_ID
                LEFT JOIN #dsn#.SETUP_COMPLAINTS SC ON SC.COMPLAINT_ID = HE.COMPLAINT_ID
                LEFT JOIN #dsn#.SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS SHA ON SHA.SETUP_COMPLAINT_ID = SC.COMPLAINT_ID AND SHA.ASSURANCE_ID = EIPR.ASSURANCE_ID
            WHERE
                1 = 1
                <cfif len(arguments.emp_id)>
                    AND EIPR.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#"> 
                </cfif>
                <cfif len(arguments.assurance_id)>
                    AND EIPR.ASSURANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#">
                </cfif>
                AND HE.COMPLAINT_ID IS NOT NULL
            GROUP BY
                HE.COMPLAINT_ID, COMPLAINT, MAX
        </cfquery>
        <cfreturn GET_USE_OF_TOTAL_COMPLAINTS>
    </cffunction>
    <cffunction name="GET_USE_OF_TOTAL_MECIDIONS" access="remote" returntype="any">
        <cfargument name="emp_id" default="">
        <cfargument name="assurance_id" default="">
        <cfquery name="GET_USE_OF_TOTAL_MECIDIONS" datasource="#dsn2#">
            SELECT
                HE.DRUG_ID,
                SD.DRUG_MEDICINE,
                SUM(HE.HEALTH_EXPENSE_TOTAL) AS TOTAL,
                SUM(HEALTH_EXPENSE_AMOUNT) AS COUNT,
                SHM.MAX
            FROM
                HEALTH_EXPENSE HE
                LEFT JOIN EXPENSE_ITEM_PLAN_REQUESTS EIPR ON HE.EXPENSE_ITEM_PLAN_REQUESTS_ID = EIPR.EXPENSE_ID
                LEFT JOIN #dsn#.SETUP_DECISIONMEDICINE SD ON SD.DRUG_ID = HE.DRUG_ID
                LEFT JOIN #dsn#.SETUP_HEALTH_ASSURANCE_TYPE_MEDICATION SHM ON SHM.DRUG_ID = SD.DRUG_ID AND SHM.ASSURANCE_ID = EIPR.ASSURANCE_ID
            WHERE
                1 = 1
                <cfif len(arguments.emp_id)>
                    AND EIPR.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#"> 
                </cfif>
                <cfif len(arguments.assurance_id)>
                    AND EIPR.ASSURANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#">
                </cfif>
                AND HE.DRUG_ID IS NOT NULL
            GROUP BY
                HE.DRUG_ID, DRUG_MEDICINE, MAX
        </cfquery>
        <cfreturn GET_USE_OF_TOTAL_MECIDIONS>
    </cffunction>
    <cffunction name="GET_LIMBS_MEASUREMENT" access="remote" returntype="any">
        <cfargument name="health_id" default="">
        <cfargument name="limb_id" default="">
        <cfquery name="GET_LIMBS_MEASUREMENT" datasource="#dsn2#">
            SELECT
                LIMB_MEASUREMENT
            FROM
                HEALTH_EXPENSE
            WHERE
                (EXPENSE_ITEM_PLAN_REQUESTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.health_id#"> OR
                EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.health_id#">)
                AND LIMB_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limb_id#">
        </cfquery>
        <cfreturn GET_LIMBS_MEASUREMENT>
    </cffunction>
</cfcomponent>