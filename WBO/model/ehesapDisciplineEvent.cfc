<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Meltem Aşkın		
Analys Date : 01/04/2016			Dev Date	: 13/05/2016		
Description :
	Bu component E-Hesap Olay Tutanağı objesine ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- get --->
    <cffunction name="get" access="public" returntype="query">
		<cfargument name="event_id" type="numeric" default="0" required="yes">
        
		<cfquery name="get" datasource="#DSN#">
            SELECT
                *
            FROM
                EMPLOYEES_EVENT_REPORT
            WHERE
                EVENT_ID = #arguments.event_id#
        </cfquery>
        
		<cfreturn get>
	</cffunction>
    <!--- add --->
    <cffunction name="add" access="public" returntype="string">
		<cfargument name="caution_to_id" type="numeric" default="0" required="yes">
        <cfargument name="sign_date" type="string" required="yes">
        <cfargument name="witness1_id" type="numeric" default="0" required="no">
		<cfargument name="witness2_id" type="numeric" default="0" required="no">
        <cfargument name="witness3_id" type="numeric" default="" required="no">
        <cfargument name="detail" type="string" default="" required="no">
		<cfargument name="event_type" type="string" required="no">
        <cfargument name="branch_id" type="numeric" default="0" required="no">
        
		<cfquery name="add_event" datasource="#DSN#" result="MAX_ID">
            INSERT INTO EMPLOYEES_EVENT_REPORT
            (
                TO_CAUTION,  
                SIGN_DATE,
                WITNESS_1,
                WITNESS_2,
                WITNESS_3,
                DETAIL,
                EVENT_TYPE, 
                BRANCH_ID,
                RECORD_EMP,
                RECORD_IP,
                RECORD_DATE
            )
            VALUES
        
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.caution_to_id#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sign_date#">,
                <cfif len(arguments.witness1_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.witness1_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.witness2_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.witness2_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.witness3_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.witness3_id#"><cfelse>NULL</cfif>,
                '#arguments.detail#',
                <cfif len(arguments.event_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.event_type#"><cfelse>NULL</cfif>,
                <cfif len(arguments.branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>NULL</cfif>,
                #session.ep.userid#,
                '#cgi.REMOTE_ADDR#',
                #now()#
            )
        </cfquery>
        
		<cfreturn MAX_ID.IDENTITYCOL>
	</cffunction>
    <!--- upd --->
    <cffunction name="upd" access="public" returntype="string">
		<cfargument name="event_id" type="numeric" default="0" required="yes">
        <cfargument name="caution_to_id" type="numeric" default="0" required="yes">
        <cfargument name="sign_date" type="string" required="yes">
        <cfargument name="witness1_id" type="numeric" default="0" required="no">
		<cfargument name="witness2_id" type="numeric" default="0" required="no">
        <cfargument name="witness3_id" type="numeric" default="" required="no">
        <cfargument name="detail" type="string" default="" required="no">
		<cfargument name="event_type" type="string" required="no">
        <cfargument name="branch_id" type="numeric" default="0" required="no">
        
		<cfquery name="upd" datasource="#DSN#">
            UPDATE 
                EMPLOYEES_EVENT_REPORT
            SET
                TO_CAUTION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.caution_to_id#">,
                SIGN_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sign_date#">,
                WITNESS_1 = <cfif len(arguments.witness1_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.witness1_id#"><cfelse>NULL</cfif>,
                WITNESS_2 = <cfif len(arguments.witness2_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.witness2_id#"><cfelse>NULL</cfif>,
                WITNESS_3 = <cfif len(arguments.witness3_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.witness3_id#"><cfelse>NULL</cfif>,
                DETAIL = '#arguments.detail#',
                EVENT_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.event_type#">,
                BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">,
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_IP = '#cgi.REMOTE_ADDR#',
                UPDATE_DATE = #now()#
            WHERE 
                EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.event_id#">
        </cfquery>
        
		<cfreturn arguments.event_id>
	</cffunction>
    <!--- del --->
    <cffunction name="del" access="public" returntype="boolean">
		<cfargument name="event_id" type="numeric" default="0" required="yes">
        
		<cfquery name="del_decision" datasource="#DSN#">
            DELETE FROM EMPLOYEE_DISCIPLINE_DECISION WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.event_id#">

            DELETE FROM EMPLOYEE_ABOLITION WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.event_id#">

            DELETE FROM EMPLOYEE_DEFENCE_DEMAND_PAPER WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.event_id#">

            DELETE FROM EMPLOYEE_PUNISHMENT_PAPER WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.event_id#">

            DELETE FROM EMPLOYEES_EVENT_REPORT WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.event_id#">
        </cfquery>
        
		<cfreturn true>
	</cffunction>
</cfcomponent>