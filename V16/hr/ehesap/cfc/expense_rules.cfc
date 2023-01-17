<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2= "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name="ADD_EXPENSE_RULES" access="remote" returnFormat="json" returntype="any">       
        <cfargument name="EXPENSE_HR_RULES_TYPE" default="">
        <cfargument name="EXPENSE_HR_RULES_DESCRIPTION" default="">
        <cfargument name="EXPENSE_HR_RULES_DETAIL" default="">
        <cfargument name="DAILY_PAY_MAX" default="">
        <cfargument name="MONEY_TYPE" default="">
        <cfargument name="FIRST_LEVEL_DAY_MAX" default="">
        <cfargument name="FIRST_LEVEL_PAY_RATE" default="">
        <cfargument name="SECOND_LEVEL_DAY_MAX" default="">
        <cfargument name="SECOND_LEVEL_PAY_RATE" default="">
        <cfargument name="RULE_START_DATE" default="">
        <cfargument name="TAX_EXCEPTION_AMOUNT" default="">
        <cfargument name="TAX_EXCEPTION_MONEY_TYPE" default="">
        <cfargument name="IS_INCOME_TAX_INCLUDE" default="">
        <cfargument name="IS_STAMP_TAX" default="">
        <cfargument name="TAX_RANK_FACTOR" default="">
        <cfargument name="EXPENSE_CENTER" default="">
        <cfargument name="EXPENSE_ITEM_ID" default="">
        <cfargument name="IS_COUNTRY_OUT" default="">
        <cfargument name="IS_ACTIVE" default="">
        <cfargument name="TITLE_ID" default="">
        <cfquery datasource="#dsn#" result="MAX_ID">       
            INSERT INTO
                EXPENSE_HR_RULES
            (
                EXPENSE_HR_RULES_TYPE,
                EXPENSE_HR_RULES_DESCRIPTION,
                EXPENSE_HR_RULES_DETAIL,
                DAILY_PAY_MAX,
                MONEY_TYPE,
                FIRST_LEVEL_DAY_MAX,
                FIRST_LEVEL_PAY_RATE,
                SECOND_LEVEL_DAY_MAX,
                SECOND_LEVEL_PAY_RATE,
                RULE_START_DATE,
                TAX_EXCEPTION_AMOUNT,
                TAX_EXCEPTION_MONEY_TYPE,
                IS_INCOME_TAX_INCLUDE,
                IS_STAMP_TAX,
                TAX_RANK_FACTOR,
                EXPENSE_CENTER,
                EXPENSE_ITEM_ID,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP,               
                IS_COUNTRY_OUT,
                IS_ACTIVE
            )
            VALUES
            (
                <cfif isdefined("arguments.EXPENSE_HR_RULES_TYPE") and len(arguments.EXPENSE_HR_RULES_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EXPENSE_HR_RULES_TYPE#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.EXPENSE_HR_RULES_DESCRIPTION") and len(arguments.EXPENSE_HR_RULES_DESCRIPTION)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EXPENSE_HR_RULES_DESCRIPTION#"><cfelse>NULL</cfif>,  
                <cfif isdefined("arguments.EXPENSE_HR_RULES_DETAIL") and len(arguments.EXPENSE_HR_RULES_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EXPENSE_HR_RULES_DETAIL#"><cfelse>NULL</cfif>,  
                <cfif isdefined("arguments.DAILY_PAY_MAX") and len(arguments.DAILY_PAY_MAX)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.DAILY_PAY_MAX#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.MONEY_TYPE") and len(arguments.MONEY_TYPE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MONEY_TYPE#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.FIRST_LEVEL_DAY_MAX") and len(arguments.FIRST_LEVEL_DAY_MAX)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.FIRST_LEVEL_DAY_MAX#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.FIRST_LEVEL_PAY_RATE") and len(arguments.FIRST_LEVEL_PAY_RATE)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.FIRST_LEVEL_PAY_RATE#"><cfelse>NULL</cfif>,  
                <cfif isdefined("arguments.SECOND_LEVEL_DAY_MAX") and len(arguments.SECOND_LEVEL_DAY_MAX)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SECOND_LEVEL_DAY_MAX#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.SECOND_LEVEL_PAY_RATE") and len(arguments.SECOND_LEVEL_PAY_RATE)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.SECOND_LEVEL_PAY_RATE#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.RULE_START_DATE") and len(arguments.RULE_START_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateTimeFormat(arguments.RULE_START_DATE)#"><cfelse>NULL</cfif>,                
                <cfif isdefined("arguments.TAX_EXCEPTION_AMOUNT") and len(arguments.TAX_EXCEPTION_AMOUNT)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX_EXCEPTION_AMOUNT#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.TAX_EXCEPTION_MONEY_TYPE") and len(arguments.TAX_EXCEPTION_MONEY_TYPE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TAX_EXCEPTION_MONEY_TYPE#"><cfelse>NULL</cfif>,  
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_INCOME_TAX_INCLUDE#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_STAMP_TAX#">,
                <cfif isdefined("arguments.TAX_RANK_FACTOR") and len(arguments.TAX_RANK_FACTOR)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX_RANK_FACTOR#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.EXPENSE_CENTER") and len(arguments.EXPENSE_CENTER)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EXPENSE_CENTER#"><cfelse>NULL</cfif>,  
                <cfif isdefined("arguments.EXPENSE_ITEM_ID") and len(arguments.EXPENSE_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EXPENSE_ITEM_ID#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateTimeFormat(now())#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_COUNTRY_OUT#">,   
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_ACTIVE#">
            )           
        </cfquery>          
        <cfset expense_hr_rules_id = MAX_ID.IDENTITYCOL>
        <cfloop list="#arguments.title_id#" index="title_id">
            <cfquery name="add_position_cat" datasource="#dsn#">
                INSERT INTO
                    MARCHING_MONEY_POSITION_CATS
                (
                    MARCH_MONEY_ID,
                    POSITION_CAT_ID,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    EXPENSE_HR_RULES_ID
                )
                VALUES                
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EXPENSE_HR_RULES_TYPE#">,
                        '#title_id#',
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateTimeFormat(now())#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                        #expense_hr_rules_id#
                    )               
            </cfquery>
        </cfloop>
        <cfreturn Replace( serializeJSON(MAX_ID.IDENTITYCOL), "//", "" ) />
    </cffunction>

    <cffunction name="UPDATE_EXPENSE_RULES" access="remote" returnformat="JSON" returntype="any">
        <cfargument name="EXPENSE_HR_RULES_ID" default="">
        <cfargument name="EXPENSE_HR_RULES_TYPE" default="">
        <cfargument name="EXPENSE_HR_RULES_DESCRIPTION" default="">
        <cfargument name="EXPENSE_HR_RULES_DETAIL" default="">
        <cfargument name="DAILY_PAY_MAX" default="">
        <cfargument name="MONEY_TYPE" default="">
        <cfargument name="FIRST_LEVEL_DAY_MAX" default="">
        <cfargument name="FIRST_LEVEL_PAY_RATE" default="">
        <cfargument name="SECOND_LEVEL_DAY_MAX" default="">
        <cfargument name="SECOND_LEVEL_PAY_RATE" default="">
        <cfargument name="RULE_START_DATE" default="">
        <cfargument name="TAX_EXCEPTION_AMOUNT" default="">
        <cfargument name="TAX_EXCEPTION_MONEY_TYPE" default="">
        <cfargument name="IS_INCOME_TAX_INCLUDE" default="">
        <cfargument name="IS_STAMP_TAX" default="">
        <cfargument name="TAX_RANK_FACTOR" default="">
        <cfargument name="EXPENSE_CENTER" default="">
        <cfargument name="EXPENSE_ITEM_ID" default="">
        <cfargument name="IS_COUNTRY_OUT" default="">
        <cfargument name="IS_ACTIVE" default="">
        <cfargument name="TITLE_ID" default="">    
        <cfquery name="UPDATE_EXPENSE_RULES" datasource="#dsn#">
            UPDATE
            EXPENSE_HR_RULES
            SET
            EXPENSE_HR_RULES_TYPE=<cfif isdefined("arguments.EXPENSE_HR_RULES_TYPE") and len(arguments.EXPENSE_HR_RULES_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EXPENSE_HR_RULES_TYPE#"><cfelse>NULL</cfif>,
            EXPENSE_HR_RULES_DESCRIPTION=<cfif isdefined("arguments.EXPENSE_HR_RULES_DESCRIPTION") and len(arguments.EXPENSE_HR_RULES_DESCRIPTION)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EXPENSE_HR_RULES_DESCRIPTION#"><cfelse>NULL</cfif>,  
            EXPENSE_HR_RULES_DETAIL=<cfif isdefined("arguments.EXPENSE_HR_RULES_DETAIL") and len(arguments.EXPENSE_HR_RULES_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EXPENSE_HR_RULES_DETAIL#"><cfelse>NULL</cfif>,                 
            DAILY_PAY_MAX=<cfif isdefined("arguments.DAILY_PAY_MAX") and len(arguments.DAILY_PAY_MAX)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.DAILY_PAY_MAX#"><cfelse>NULL</cfif>,
            MONEY_TYPE=<cfif isdefined("arguments.MONEY_TYPE") and len(arguments.MONEY_TYPE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MONEY_TYPE#"><cfelse>NULL</cfif>,
            FIRST_LEVEL_DAY_MAX=<cfif isdefined("arguments.FIRST_LEVEL_DAY_MAX") and len(arguments.FIRST_LEVEL_DAY_MAX)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.FIRST_LEVEL_DAY_MAX#"><cfelse>NULL</cfif>,
            FIRST_LEVEL_PAY_RATE=<cfif isdefined("arguments.FIRST_LEVEL_PAY_RATE") and len(arguments.FIRST_LEVEL_PAY_RATE)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.FIRST_LEVEL_PAY_RATE#"><cfelse>NULL</cfif>,  
            SECOND_LEVEL_DAY_MAX=<cfif isdefined("arguments.SECOND_LEVEL_DAY_MAX") and len(arguments.SECOND_LEVEL_DAY_MAX)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SECOND_LEVEL_DAY_MAX#"><cfelse>NULL</cfif>,
            SECOND_LEVEL_PAY_RATE=<cfif isdefined("arguments.SECOND_LEVEL_PAY_RATE") and len(arguments.SECOND_LEVEL_PAY_RATE)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.SECOND_LEVEL_PAY_RATE#"><cfelse>NULL</cfif>,
            RULE_START_DATE=<cfif isdefined("arguments.RULE_START_DATE") and len(arguments.RULE_START_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateTimeFormat(arguments.RULE_START_DATE)#"><cfelse>NULL</cfif>,                
            TAX_EXCEPTION_AMOUNT=<cfif isdefined("arguments.TAX_EXCEPTION_AMOUNT") and len(arguments.TAX_EXCEPTION_AMOUNT)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX_EXCEPTION_AMOUNT#"><cfelse>NULL</cfif>,
            TAX_EXCEPTION_MONEY_TYPE=<cfif isdefined("arguments.TAX_EXCEPTION_MONEY_TYPE") and len(arguments.TAX_EXCEPTION_MONEY_TYPE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TAX_EXCEPTION_MONEY_TYPE#"><cfelse>NULL</cfif>,  
            IS_INCOME_TAX_INCLUDE=<cfif isdefined("arguments.IS_INCOME_TAX_INCLUDE") and len(arguments.IS_INCOME_TAX_INCLUDE)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_INCOME_TAX_INCLUDE#"><cfelse>NULL</cfif>,
            IS_STAMP_TAX=<cfif isdefined("arguments.IS_STAMP_TAX") and len(arguments.IS_STAMP_TAX)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_STAMP_TAX#"><cfelse>NULL</cfif>,
            TAX_RANK_FACTOR=<cfif isdefined("arguments.TAX_RANK_FACTOR") and len(arguments.TAX_RANK_FACTOR)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX_RANK_FACTOR#"><cfelse>NULL</cfif>,
            EXPENSE_CENTER=<cfif isdefined("arguments.EXPENSE_CENTER") and len(arguments.EXPENSE_CENTER)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EXPENSE_CENTER#"><cfelse>NULL</cfif>,  
            EXPENSE_ITEM_ID=<cfif isdefined("arguments.EXPENSE_ITEM_ID") and len(arguments.EXPENSE_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EXPENSE_ITEM_ID#"><cfelse>NULL</cfif>,           
            UPDATE_DATE='#DateTimeFormat(now())#',
            UPDATE_EMP=#session.ep.userid#,
            UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">, 
            IS_COUNTRY_OUT=<cfif isdefined("arguments.IS_COUNTRY_OUT") and len(arguments.IS_COUNTRY_OUT)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_COUNTRY_OUT#"><cfelse>NULL</cfif>,
            IS_ACTIVE=<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.IS_ACTIVE#">
            WHERE 
            EXPENSE_HR_RULES_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_hr_rules_id#"> 
        </cfquery>
        <cfquery name="upd_position_cat" datasource="#dsn#">
           DELETE FROM MARCHING_MONEY_POSITION_CATS WHERE EXPENSE_HR_RULES_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_hr_rules_id#" list="yes">)         
        </cfquery>   
        <cfloop list="#arguments.title_id#" index="title_id">
            <cfquery name="add_position_cat" datasource="#dsn#">
                INSERT INTO
                    MARCHING_MONEY_POSITION_CATS
                (
                    MARCH_MONEY_ID,
                    POSITION_CAT_ID,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    EXPENSE_HR_RULES_ID
                )
                VALUES                
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EXPENSE_HR_RULES_TYPE#">,
                        '#title_id#',
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateTimeFormat(now())#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_hr_rules_id#">
                    )               
            </cfquery>
        </cfloop>    
        <cfreturn UPDATE_EXPENSE_RULES>
    </cffunction>
    
    <cffunction name="GET_EXPENSE_RULES" access="remote"  returntype="any">
        <cfargument name="expense_hr_rules_id" default="">
        <cfargument name="keyword" default="">
        <cfargument name="is_active" default="">
        <cfargument name="startrow" default="1">
        <cfargument name="maxrows" default="20">
        <cfquery name="GET_EXPENSE_RULES" datasource="#dsn#" result="MAX_ID">
            SELECT 
                EHR.EXPENSE_HR_RULES_ID,
                EHR.EXPENSE_HR_RULES_TYPE,
                #dsn#.Get_Dynamic_Language(EXPENSE_HR_RULES_ID,'#session.ep.language#','EXPENSE_HR_RULES','EXPENSE_HR_RULES_DESCRIPTION',NULL,NULL,EXPENSE_HR_RULES_DESCRIPTION) AS EXPENSE_HR_RULES_DESCRIPTION,
                #dsn#.Get_Dynamic_Language(EXPENSE_HR_RULES_ID,'#session.ep.language#','EXPENSE_HR_RULES','EXPENSE_HR_RULES_DETAIL',NULL,NULL,EXPENSE_HR_RULES_DETAIL) AS EXPENSE_HR_RULES_DETAIL,
                EHR.DAILY_PAY_MAX,
                EHR.MONEY_TYPE,
                EHR.FIRST_LEVEL_DAY_MAX,
                EHR.FIRST_LEVEL_PAY_RATE,
                EHR.SECOND_LEVEL_DAY_MAX,
                EHR.SECOND_LEVEL_PAY_RATE,
                EHR.RULE_START_DATE,
                EHR.TAX_EXCEPTION_AMOUNT,
                EHR.TAX_EXCEPTION_MONEY_TYPE,
                EHR.IS_INCOME_TAX_INCLUDE,
                EHR.IS_STAMP_TAX,
                EHR.TAX_RANK_FACTOR,
                EHR.EXPENSE_CENTER,
                EHR.EXPENSE_ITEM_ID,
                EC.EXPENSE,
                EI.EXPENSE_ITEM_NAME,
                EHR.UPDATE_DATE,
                EHR.UPDATE_EMP,
                EHR.UPDATE_IP,
                EHR.RECORD_DATE,
                EHR.RECORD_EMP,
                EHR.RECORD_IP,               
                EHR.IS_COUNTRY_OUT,
                EHR.IS_ACTIVE
            FROM 
              EXPENSE_HR_RULES EHR
              LEFT JOIN #dsn2#.EXPENSE_CENTER EC ON EHR.EXPENSE_CENTER=EC.EXPENSE_ID
              LEFT JOIN #dsn2#.EXPENSE_ITEMS EI ON EHR.EXPENSE_ITEM_ID=EI.EXPENSE_ITEM_ID
            WHERE 
                    1=1
                <cfif isdefined("arguments.expense_hr_rules_id") and len(arguments.expense_hr_rules_id)>
                  AND EHR.EXPENSE_HR_RULES_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_hr_rules_id#">
                </cfif>
                <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                    AND EHR.EXPENSE_HR_RULES_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                </cfif>
                <cfif isdefined("arguments.is_active") and arguments.is_active eq 1>
                    AND EHR.IS_ACTIVE = 1
                <cfelseif isdefined("arguments.is_active") and arguments.is_active eq 2>
                    AND EHR.IS_ACTIVE = 0
                </cfif>
        </cfquery>
        <cfreturn GET_EXPENSE_RULES>
    </cffunction>
    <cffunction  name="GET_EXPENSE_RULES_LIST">
        <cfargument name="is_active" default="">
        <cfquery name="GET_EXPENSE_RULES_LIST" datasource="#dsn#">
            SELECT 
                EXPENSE_HR_RULES_ID,
                EXPENSE_HR_RULES_TYPE,
                EXPENSE_HR_RULES_DESCRIPTION,
                #dsn#.Get_Dynamic_Language(EXPENSE_HR_RULES_ID,'#session.ep.language#','EXPENSE_HR_RULES','EXPENSE_HR_RULES_DETAIL',NULL,NULL,EXPENSE_HR_RULES_DETAIL) AS EXPENSE_HR_RULES_DETAIL,
                DAILY_PAY_MAX,
                MONEY_TYPE,
                FIRST_LEVEL_DAY_MAX,
                FIRST_LEVEL_PAY_RATE,
                SECOND_LEVEL_DAY_MAX,
                SECOND_LEVEL_PAY_RATE,
                RULE_START_DATE,
                TAX_EXCEPTION_AMOUNT,
                TAX_EXCEPTION_MONEY_TYPE,
                IS_INCOME_TAX_INCLUDE,
                IS_STAMP_TAX,
                TAX_RANK_FACTOR,
                EXPENSE_CENTER,
                EXPENSE_ITEM_ID,
                UPDATE_DATE,
                UPDATE_EMP,
                UPDATE_IP,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP,               
                IS_COUNTRY_OUT,
                IS_ACTIVE
            FROM 
              EXPENSE_HR_RULES 
            <cfif len(is_active)>
                WHERE
                    IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#">
            </cfif>
        </cfquery>
        <cfreturn GET_EXPENSE_RULES_LIST>
    </cffunction>
    <cffunction name="GET_MONEY" returntype="query">
        <cfquery name="GET_MONEY" datasource="#DSN#">
            SELECT MONEY_ID, RATE1, RATE2, MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = 1
        </cfquery> 
        <cfreturn GET_MONEY>
    </cffunction>  
</cfcomponent>