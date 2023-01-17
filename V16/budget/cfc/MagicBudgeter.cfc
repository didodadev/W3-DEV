<cfcomponent extends="cfc.queryJSONConverter">

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>

    <cffunction name="add_wizard" returntype="any">
        <cfquery name="add_wizard" datasource="#dsn2#">
            INSERT INTO 
                #dsn#.BUDGET_WIZARD
                (
                    WIZARD_NAME,
                    WIZARD_DESIGNER,
                    WIZARD_STAGE,
                    WIZARD_DATE,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.wizard_name#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_designer#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_stage#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.wizard_date#">,
                    #now()#,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                )
                SELECT SCOPE_IDENTITY() AS MAX_ID
        </cfquery>
        <cfreturn add_wizard.max_id>
    </cffunction>

    <cffunction name="add_wizard_block" returntype="any">
        <cfquery name="add_wizard_block" datasource="#dsn2#">
            INSERT INTO
                #dsn#.BUDGET_WIZARD_BLOCK
                (
                    WIZARD_ID,
                    BLOCK_NAME,
                    BLOCK_INCOME
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_id#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.block_name_left#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.block_income#">
                )
                SELECT SCOPE_IDENTITY() AS MAX_BLOCK_ID
        </cfquery>
        <cfreturn add_wizard_block.MAX_BLOCK_ID>
    </cffunction>

    <cffunction name="add_wizard_block_row" returntype="any">
        <cfquery name="add_wizard_block_row" datasource="#dsn2#">
            INSERT INTO
                #dsn#.BUDGET_WIZARD_BLOCK_ROW
                (
                    WIZARD_BLOCK_ID,
                    BLOCK_COLUMN,
                    EXP_CENTER,
                    EXP_ITEM,
                    ACTIVITY_TYPE,
                    RATE,
                    DESCRIPTION
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_block_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.block_column#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_center#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_item#">,
                    <cfif len(arguments.activity_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activity_type#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.description#">
                )
        </cfquery>
    </cffunction>

    <cffunction name="get_wizard" returntype="any">
        <cfquery name="get_wizard" datasource="#dsn#">
            SELECT 
            BW.*,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS DESIGNER_EMPLOYEE_FULLNAME,
                PTR.STAGE
            FROM
                BUDGET_WIZARD BW
                LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = BW.WIZARD_DESIGNER
                LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = BW.WIZARD_STAGE
            WHERE
                1 = 1
                <cfif len(arguments.keyword)>
                    AND BW.WIZARD_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                </cfif>
        </cfquery>
        <cfreturn get_wizard>
    </cffunction>

    <cffunction name="det_wizard" returntype="any" returnFormat="json">
        <cfquery name="det_wizard" datasource = "#dsn#">
            SELECT
                BW.WIZARD_ID,
                BW.WIZARD_NAME,
                BW.WIZARD_DESIGNER,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE_FULLNAME,
                BW.WIZARD_STAGE,
                CONVERT(nvarchar(10),BW.WIZARD_DATE,103) AS WIZARD_DATE,
                BWB.WIZARD_BLOCK_ID,
                BWB.BLOCK_NAME,
                BWB.BLOCK_INCOME,
                BWBR.WIZARD_BLOCK_ROW_ID,
                BWBR.BLOCK_COLUMN,
                BWBR.EXP_CENTER,
                BWBR.EXP_ITEM,
                BWBR.ACTIVITY_TYPE,
                BWBR.RATE,
                BWBR.DESCRIPTION,
                BW.RECORD_EMP,
                BW.RECORD_DATE,
                BW.RECORD_IP,
                BW.UPDATE_EMP,
                BW.UPDATE_DATE,
                BW.UPDATE_IP,
                EC.EXPENSE,
                EI.EXPENSE_ITEM_NAME
            FROM
                BUDGET_WIZARD BW
                    LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = BW.WIZARD_DESIGNER
                    LEFT JOIN BUDGET_WIZARD_BLOCK BWB ON BWB.WIZARD_ID = BW.WIZARD_ID
                    LEFT JOIN BUDGET_WIZARD_BLOCK_ROW BWBR ON BWBR.WIZARD_BLOCK_ID = BWB.WIZARD_BLOCK_ID
                    LEFT JOIN #dsn2#.EXPENSE_CENTER EC ON EC.EXPENSE_ID = BWBR.EXP_CENTER
                    LEFT JOIN #dsn2#.EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = BWBR.EXP_ITEM 
            WHERE
                BW.WIZARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_id#">
            ORDER BY
                BW.WIZARD_ID,
                BWB.WIZARD_BLOCK_ID,
                BWBR.WIZARD_BLOCK_ROW_ID
        </cfquery>
        	<cfset getJSON = returnData(serializeJSON(det_wizard))>
        <cfreturn Replace(serializeJSON(getJSON),'//','') />
    </cffunction>

    <cffunction name="det_wizard2" returntype="any">
        <cfquery name="det_wizard2" datasource = "#dsn#">
            SELECT
                BW.WIZARD_ID,
                BW.WIZARD_NAME,
                BW.WIZARD_DESIGNER,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE_FULLNAME,
                BW.WIZARD_STAGE,
                CONVERT(nvarchar(10),BW.WIZARD_DATE,103) AS WIZARD_DATE,
                BWB.WIZARD_BLOCK_ID,
                BWB.BLOCK_NAME,
                BWB.BLOCK_INCOME,
                BWBR.WIZARD_BLOCK_ROW_ID,
                BWBR.BLOCK_COLUMN,
                BWBR.EXP_CENTER,
                BWBR.EXP_ITEM,
                BWBR.ACTIVITY_TYPE,
                BWBR.RATE,
                BWBR.DESCRIPTION,
                BW.RECORD_EMP,
                BW.RECORD_DATE,
                BW.RECORD_IP,
                BW.UPDATE_EMP,
                BW.UPDATE_DATE,
                BW.UPDATE_IP
            FROM
                BUDGET_WIZARD BW
                    LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = BW.WIZARD_DESIGNER
                    LEFT JOIN BUDGET_WIZARD_BLOCK BWB ON BWB.WIZARD_ID = BW.WIZARD_ID
                    LEFT JOIN BUDGET_WIZARD_BLOCK_ROW BWBR ON BWBR.WIZARD_BLOCK_ID = BWB.WIZARD_BLOCK_ID
            WHERE
                BW.WIZARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_id#">
            ORDER BY
                BW.WIZARD_ID,
                BWB.WIZARD_BLOCK_ID,
                BWBR.WIZARD_BLOCK_ROW_ID
        </cfquery>
        <cfreturn det_wizard2 >
    </cffunction>

    <cffunction name="get_prev_cards" returntype="any"> 
        <cfquery name="get_prev_cards" datasource = "#dsn2#">
            SELECT
                BWR.EXP_ITEM_ROWS_ID,
                BWR.IS_INCOME,
                BWR.WIZARD_ID,
                EIR.DETAIL,
                EIR.EXPENSE_DATE
            FROM
                #dsn#.BUDGET_WIZARD_RELATION BWR
                LEFT JOIN EXPENSE_ITEMS_ROWS EIR ON EIR.EXP_ITEM_ROWS_ID = BWR.EXP_ITEM_ROWS_ID    
            WHERE
                BWR.WIZARD_ID = #arguments.wizard_id#
                AND BWR.PERIOD_ID = #session.ep.period_id#
        </cfquery>
        <cfreturn get_prev_cards>	
    </cffunction>

    <cffunction name="del_empty_relations" returntype="any">
        <cfquery name = "del_empty_relations" datasource = "#dsn#">
            WITH CTE1 AS (
                SELECT
                    BWR.WIZARD_RELATION_ID,
                    BW.WIZARD_ID,
                    EIR.EXP_ITEM_ROWS_ID
                FROM
                    BUDGET_WIZARD_RELATION BWR
                        LEFT JOIN BUDGET_WIZARD BW ON BW.WIZARD_ID = BWR.WIZARD_ID
                        LEFT JOIN #dsn2#.EXPENSE_ITEMS_ROWS EIR ON EIR.EXP_ITEM_ROWS_ID = BWR.EXP_ITEM_ROWS_ID
                WHERE
                    BWR.PERIOD_ID = #session.ep.period_id#
                    AND (
                            BW.WIZARD_ID IS NULL
                        )
            )
            DELETE FROM BUDGET_WIZARD_RELATION WHERE WIZARD_RELATION_ID IN (SELECT WIZARD_RELATION_ID FROM CTE1)
        </cfquery>
    </cffunction>
    
    <cffunction name="upd_wizard" returntype="any">
        <cfquery name="upd_wizard" datasource="#dsn2#">
            UPDATE
                #dsn#.BUDGET_WIZARD
            SET
                WIZARD_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.wizard_name#">,
                WIZARD_DESIGNER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_designer#">,
                WIZARD_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_stage#">,
                WIZARD_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.wizard_date#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = #now()#
            WHERE
                WIZARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="get_wizard_block" returntype="any">
        <cfquery name = "get_wizard_block" datasource = "#dsn2#">
            SELECT WIZARD_BLOCK_ID FROM #dsn#.BUDGET_WIZARD_BLOCK WHERE WIZARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_id#">
        </cfquery>
        <cfreturn get_wizard_block>
    </cffunction>

    <cffunction name="del_wizard" returntype="any">
        <cfquery name = "del_wizard" datasource = "#dsn2#">
            DELETE FROM #dsn#.BUDGET_WIZARD WHERE WIZARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="del_wizard_block" returntype="any">
        <cfquery name = "del_wizard_block" datasource = "#dsn2#">
            DELETE FROM #dsn#.BUDGET_WIZARD_BLOCK WHERE WIZARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wizard_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="del_wizard_block_row" returntype="any">
        <cfquery name = "del_wizard_block_row" datasource = "#dsn2#">
            DELETE FROM #dsn#.BUDGET_WIZARD_BLOCK_ROW WHERE WIZARD_BLOCK_ID IN (#arguments.block_id#)
        </cfquery>
        <cfreturn 1>
    </cffunction>

    <cffunction name="GET_ACTIVITY" returntype="any">
        <cfquery name="GET_ACTIVITY" datasource="#DSN#">
            SELECT
                #dsn#.Get_Dynamic_Language(ACTIVITY_ID,'#session.ep.language#','SETUP_ACTIVITY','ACTIVITY_NAME',NULL,NULL,ACTIVITY_NAME) AS activity_name,
                ACTIVITY_ID,
                ACTIVITY_NAME
            FROM 
                SETUP_ACTIVITY
            WHERE
                ACTIVITY_STATUS = 1 
            ORDER BY 
                ACTIVITY_NAME
        </cfquery>
        <cfreturn GET_ACTIVITY>
    </cffunction>

    <cffunction name="del_budget_transfer" returntype="string" returnformat="JSON" access="remote">
        <cfargument name="action_id" required="yes">
        <cfargument name="exp_item_rows_id" required="yes">
        <cftry>
            <cfquery name="DEL_GERCEKLESEN" datasource="#dsn2#">
                DELETE FROM EXPENSE_ITEMS_ROWS WHERE 
                     ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                     AND EXPENSE_COST_TYPE = 162 
                     AND ACTION_TABLE = 'BUDGET_WIZARD_RELATION' 
                     AND EXP_ITEM_ROWS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.exp_item_rows_id#"> 
            </cfquery>
            <cfquery name="DEL_RELATION" datasource="#dsn#">
                DELETE FROM BUDGET_WIZARD_RELATION WHERE EXP_ITEM_ROWS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.exp_item_rows_id#">  
            </cfquery>
        <cfset status = true>
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfset status = false>
            </cfcatch>
        </cftry>    
        <cfreturn status>
    </cffunction>
</cfcomponent>