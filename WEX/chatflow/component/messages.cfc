<cfcomponent extends = "cfc/queryJSONConverter">

    <cfset dsn = application.systemParam.systemParam().dsn />

    <cffunction name="set_visitor" returntype="any" access="public">
        <cfargument name="employee_id" type="numeric" required="true" />
        <cfargument name="visitor_id" type="numeric" required="false" />
        <cfargument name="visitor_type" type="string" required="true" />
        <cfargument name="visitor_key" type="string" required="true" />
        <cfargument name="visitor_name" type="string" required="true" />
        <cfargument name="visitor_surname" type="string" required="true" />
        <cfargument name="visitor_email" type="string" required="true" />
        <cfargument name="enc_key" type="string" required="true" />
        <cfif not this.get_visitor( arguments.enc_key ).recordcount>
            <cfquery name="set_visitor" datasource="#DSN#">
                INSERT INTO WRK_MESSAGE_VISITOR(
                    EMPLOYEE_ID,
                    VISITOR_ID,
                    VISITOR_TYPE,
                    VISITOR_KEY,
                    VISITOR_NAME,
                    VISITOR_SURNAME,
                    VISITOR_EMAIL,
                    ENC_KEY,
                    RECORD_DATE
                )VALUES(
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.visitor_id#" null="#not len(arguments.visitor_id) ? 'yes' : 'no'#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.visitor_type#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.visitor_key#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.visitor_name#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.visitor_surname#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.visitor_email#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.enc_key#">,
                    #now()#
                )
            </cfquery>
        <cfelse>
            <cfquery name="set_visitor" datasource="#DSN#">
                UPDATE WRK_MESSAGE_VISITOR SET UPDATE_DATE = #now#
            </cfquery>
        </cfif>
    </cffunction>

    <cffunction name="get_visitor" returntype="any" access="public">
        <cfargument name="enc_key" type="string" required="true" />

        <cfquery name="get_visitor" datasource="#DSN#">
            SELECT * FROM WRK_MESSAGE_VISITOR WHERE ENC_KEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.enc_key#">
        </cfquery>
        <cfreturn get_visitor>
    </cffunction>

    <cffunction name="get_wrk_messages" returntype="any" access="public">
        <cfargument name="enc_key" type="string" required="true" />

        <cfquery name="get_wrk_messages" datasource="#DSN#">
            SELECT
                *
            FROM
                WRK_MESSAGE
                LEFT JOIN WRK_MESSAGE_FILES ON WRK_MESSAGE.WRK_MESSAGE_ID = WRK_MESSAGE_FILES.MESSAGE_ID
            WHERE ENC_KEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.enc_key#">
            ORDER BY SEND_DATE ASC
        </cfquery>     
        <cfreturn get_wrk_messages>   
    </cffunction>

    <cffunction name="get_last_messages" returntype="any" access="remote" returnFormat="JSON">
        <cfargument name="enc_key" type="string" required="true" />

        <cfquery name="get_last_messages" datasource="#DSN#">
            SELECT TOP 1 * FROM WRK_MESSAGE WHERE ENC_KEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.enc_key#"> ORDER BY WRK_MESSAGE_ID DESC
        </cfquery>
        <cfreturn replace(serializeJSON( this.returnData( replace(serializeJSON( get_last_messages ), "//", "") ) ), "//", "") /> 
    </cffunction>

    <cffunction name="isalerted" returntype="any" access="remote">
        <cfargument name="enc_key" type="any" default="" />
        
        <cfquery name="ISALERTED" datasource="#DSN#">  <!--- OKUNDU --->
            UPDATE WRK_MESSAGE SET IS_ALERTED = 1 
            WHERE RECEIVER_ID IS NULL
            AND ENC_KEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.enc_key#">
        </cfquery>
    </cffunction>

    <cffunction name="get_agent_user" returntype="any" access="public">
        <cfargument name="employee_id" type="any" required="false" />
        <cfargument name="department_id" type="string" required="true" />

        <cfquery name="get_agent_user" datasource="#DSN#">
            SELECT TOP 1
                EP.EMPLOYEE_ID, 
                EP.EMPLOYEE_NAME, 
                EP.EMPLOYEE_SURNAME,
                ED.SEX,
                E.PHOTO
            FROM EMPLOYEE_POSITIONS AS EP
            JOIN EMPLOYEES AS E ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
            LEFT JOIN EMPLOYEES_DETAIL AS ED ON EP.EMPLOYEE_ID = ED.EMPLOYEE_ID
            LEFT JOIN WRK_SESSION AS WS ON EP.EMPLOYEE_ID = WS.USERID
            WHERE 
                1 = 1
                <cfif isDefined("arguments.employee_id") and len(arguments.employee_id)>
                    AND EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                </cfif>
                AND EP.DEPARTMENT_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#" list="yes">)
                AND WS.CFTOKEN IS NOT NULL
        </cfquery>
        
        <cfif isDefined("arguments.employee_id") and len(arguments.employee_id) and not get_agent_user.recordcount>
            <cfset this.get_agent_user( department_id: arguments.department_id ) />
        </cfif>

        <cfreturn get_agent_user>   
    </cffunction>

</cfcomponent>