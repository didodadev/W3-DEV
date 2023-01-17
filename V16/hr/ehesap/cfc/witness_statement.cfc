<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2= "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name="ADD_WITNESS_STATEMENT" access="remote" returntype="any">       
        <cfargument name="event_id" default="">
        <cfargument name="sign_date" default="">
        <cfargument name="witness_1" default="">
        <cfargument name="witness1_detail" default="">
        <cfargument name="witness_2" default="">
        <cfargument name="witness2_detail" default="">
        <cfargument name="witness_3" default="">
        <cfargument name="witness3_detail" default="">
        <cfquery name="ADD_WITNESS_STATEMENT" datasource="#DSN#">
            INSERT INTO EVENT_WITNESS_STATEMENT
                (
                    EVENT_ID
                    ,SIGN_DATE
                    ,WITNESS_1
                    ,WITNESS1_DETAIL
                    ,WITNESS_2
                    ,WITNESS2_DETAIL
                    ,WITNESS_3
                    ,WITNESS3_DETAIL
                    ,RECORD_DATE
                    ,RECORD_EMP
                    ,RECORD_IP
                )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.event_id#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sign_date#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.witness_1#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.witness1_detail#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.witness_2#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.witness2_detail#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.witness_3#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.witness3_detail#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">

            )
        </cfquery>
    </cffunction> 
    <cffunction name="UPD_WITNESS_STATEMENT" access="remote" returntype="any"> 
        <cfargument name="witness_statement_id" default="">
        <cfargument name="event_id" default="">
        <cfargument name="sign_date" default="">
        <cfargument name="witness_1" default="">
        <cfargument name="witness1_detail" default="">
        <cfargument name="witness_2" default="">
        <cfargument name="witness2_detail" default="">
        <cfargument name="witness_3" default="">
        <cfargument name="witness3_detail" default="">
     
        <cfquery name="UPD_WITNESS_STATEMENT" datasource="#DSN#">
           UPDATE 
                EVENT_WITNESS_STATEMENT
            SET 
                EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.event_id#">,
                SIGN_DATE = <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#arguments.sign_date#">,
                WITNESS_1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.witness_1#">,
                WITNESS1_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.witness1_detail#">,
                WITNESS_2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.witness_2#">,
                WITNESS2_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.witness2_detail#">,
                WITNESS_3 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.witness_3#">,
                WITNESS3_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.witness3_detail#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
            WHERE 
                WITNESS_STATEMENT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.witness_statement_id#">
        </cfquery>
    </cffunction> 
    <cffunction name="GET_WITNESS_STATEMENT" access="remote" returntype="any"> 
        <cfargument name="witness_statement_id" default="">
        <cfargument name="event_id" default="">
        <cfquery name="GET_WITNESS_STATEMENT" datasource="#DSN#" result="MAX_ID">
           SELECT  
                EWS.WITNESS_STATEMENT_ID
                ,EWS.EVENT_ID
                ,EWS.SIGN_DATE
                ,EWS.WITNESS_1
                ,EWS.WITNESS1_DETAIL
                ,EWS.WITNESS_2
                ,EWS.WITNESS2_DETAIL
                ,EWS.WITNESS_3
                ,EWS.WITNESS3_DETAIL
                ,EWS.RECORD_DATE
                ,EWS.RECORD_EMP
                ,EWS.RECORD_IP
            FROM  
                EVENT_WITNESS_STATEMENT EWS,
                EMPLOYEES_EVENT_REPORT EVR
            WHERE 
            <cfif isdefined("arguments.event_id")>
                EWS.EVENT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.event_id#">
            <cfelse>
                EWS.WITNESS_STATEMENT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.witness_statement_id#">
            </cfif>
            AND
		        EWS.EVENT_ID=EVR.EVENT_ID
        </cfquery>
         <cfreturn GET_WITNESS_STATEMENT>
    </cffunction>   
</cfcomponent>