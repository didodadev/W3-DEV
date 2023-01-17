<!---
    File: 
    Author: 
    Date: 
    Description:
		
--->
<cfcomponent displayname="" output="false" accessors="true">

    <cfproperty name="data_officer_id" type="numeric" required="true" setter="true"/>
    <cfscript>
        dsn = application.SystemParam.SystemParam().dsn;
    </cfscript>
    <cffunction name="add_data_officer_commitee" access="remote" returntype="boolean">
        <cfargument name="record" default="">
        <cfargument name="member_name" default="">
        <cfargument name="row_kontrol" default="">
        <cfargument name="role" default="">
        <cfargument name="data_officer_id" default="">
        <cfargument name="consumer_id" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="partner_id" default="">
        <cfargument name="company_id" default="">
        <cfargument name="role_id" default="">
       <cftry> 
        <cfif len(arguments.record) and arguments.record neq ''>
            <cfquery name="GDPR_DATA_OFFICER_COMMITTEE" datasource="#DSN#">
                SELECT * FROM GDPR_DATA_OFFICER_COMMITTEE WHERE DATA_OFFICER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data_officer_id#">
            </cfquery>
            <cfquery name="GET_ROLES" datasource="#dsn#">
                SELECT * FROM SETUP_PROJECT_ROLES ORDER BY PROJECT_ROLES_ID
            </cfquery>
            <cfset role_list = listsort(valuelist(GET_ROLES.PROJECT_ROLES_ID,','),'numeric','ASC',',')>
            <cfif GDPR_DATA_OFFICER_COMMITTEE.recordcount>
                <cfquery name="DEL_GDPR_DATA_OFFICER_COMMITTEE" datasource="#DSN#">
                    DELETE FROM GDPR_DATA_OFFICER_COMMITTEE WHERE DATA_OFFICER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data_officer_id#">
                </cfquery>
            </cfif>
            <cfloop from="1" to="#arguments.record#" index="i">
                <cfif isdefined("arguments.row_kontrol#i#") and evaluate("arguments.row_kontrol#i#") eq 1>
                    <cfset this_role_id_ = evaluate("arguments.role_id#i#")>
                    <cfset this_role_name_ = GET_ROLES.PROJECT_ROLES[listfind(role_list,this_role_id_,',')]>
                    <cfquery name="add_query" datasource="#dsn#">
                        INSERT INTO GDPR_DATA_OFFICER_COMMITTEE
                            (
                                DATA_OFFICER_ID,
                                COMMITTEE_MEMBER_NAME,
                                COMMITTEE_MEMBER_ROLE,
                                ROLE_ID,
                                CONSUMER_ID,
                                COMPANY_ID,
                                PARTNER_ID,
                                EMPLOYEE_ID,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP
                            )
                        VALUES
                            (
                                <cfqueryparam value="#arguments.data_officer_id#" cfsqltype="cf_sql_numeric">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("arguments.member_name#i#")#">,
                                '#this_role_name_#',
			                    <cfif len(this_role_id_)>#this_role_id_#<cfelse>NULL</cfif>,
                                <cfif isdefined('arguments.consumer_id#i#') and len(evaluate("arguments.consumer_id#i#"))>#evaluate("arguments.consumer_id#i#")#<cfelse>NULL</cfif>,
			                    <cfif isdefined('arguments.company_id#i#') and len(evaluate("arguments.company_id#i#"))>#evaluate("arguments.company_id#i#")#<cfelse>NULL</cfif>,
			                    <cfif isdefined('arguments.partner_id#i#') and len(evaluate("arguments.partner_id#i#"))>#evaluate("arguments.partner_id#i#")#<cfelse>NULL</cfif>,
                                <cfif isdefined("arguments.employee_id#i#") and len(evaluate("arguments.employee_id#i#"))>#evaluate("arguments.employee_id#i#")#<cfelse>NULL</cfif>,
                                <cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">,
                                <cfqueryparam value="#SESSION.EP.USERID#" cfsqltype="cf_sql_numeric">,
                                <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_nvarchar">
                            )
                    </cfquery>
                </cfif>
            </cfloop>
        </cfif>
      
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <script type="text/javascript">
            window.location.href = "<cfoutput>/index.cfm?fuseaction=gdpr.data_officer&event=det&id=#arguments.data_officer_id#</cfoutput>";
        </script>
        <cfreturn true />
    </cffunction>
    <cffunction name="upd_data_officer_commitee" access="remote" returntype="boolean">
        <cfargument name="data_officer_committee_id" type="numeric" required="true">
        <cfargument name="committee_member_name" type="string" required="true">
        <cfargument name="committee_member_role" type="string" required="true">
        <cftry>
            <cfquery name="upd_query" datasource="#dsn#">
                UPDATE GDPR_DATA_OFFICER_COMMITTEE
                SET  
                    COMMITTEE_MEMBER_NAME = <cfqueryparam value="#committee_member_name#" cfsqltype="cf_sql_nvarchar">,
                    COMMITTEE_MEMBER_ROLE = <cfqueryparam value="#committee_member_role#" cfsqltype="cf_sql_nvarchar">,
                    UPDATE_DATE = <cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">,
                    UPDATE_EMP = <cfqueryparam value="#SESSION.EP.USERID#" cfsqltype="cf_sql_numeric">,
                    UPDATE_IP =  <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_nvarchar">
                WHERE
                    DATA_OFFICER_ID = <cfqueryparam value="#this.getData_officer_id()#" cfsqltype="cf_sql_numeric">
                    AND DATA_OFFICER_COMMITTEE_ID = <cfqueryparam value="#data_officer_committee_id#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn true />
    </cffunction>
    <cffunction name="get_data_officer_commitee" access="remote" returntype="query">  
            <cfquery name="get_data_officer_commitee" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                GDPR_DATA_OFFICER_COMMITTEE
            WHERE
                DATA_OFFICER_ID = <cfqueryparam value="#this.getData_officer_id()#" cfsqltype="cf_sql_numeric">
           
            </cfquery>
       
        <cfreturn get_data_officer_commitee />
    </cffunction>
    <cffunction name="del_data_officer_commitee_byId" access="public" returntype="boolean">
        <cfargument name="data_officer_committee_id" type="numeric" required="true">
            <cfquery name="del_data_officer_commitee_byId" datasource="#dsn#">
            DELETE
            FROM 
                GDPR_DATA_OFFICER_COMMITTEE
            WHERE
                DATA_OFFICER_ID = <cfqueryparam value="#this.getData_officer_id()#" cfsqltype="cf_sql_numeric">
                AND DATA_OFFICER_COMMITTEE_ID = <cfqueryparam value="#data_officer_committee_id#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfreturn true />
    </cffunction>
</cfcomponent>
