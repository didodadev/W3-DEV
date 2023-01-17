
<cfcomponent>
    <cfset dsn = application.SystemParam.SystemParam().dsn>
    <cfset dsn_dev = '#dsn#_retail'>
    <cffunction name = "select" access="remote" returntype="any">
        <cfquery name="get_users" datasource="#dsn_dev#">
            select 
                PU.ROW_ID,
            	PU.EMPLOYEE_ID,
                B.BRANCH_NAME,
                B.BRANCH_ID,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                PU.RECORD_DATE,
            	PU.RECORD_EMP,	
                PU.RECORD_IP,	
                PU.USERNAME,	
                PU.PASSWORD,	
                PU.POS_TYPE,	
                PU.UPDATE_DATE,	
                PU.UPDATE_EMP,	
                PU.UPDATE_IP,	
                PU.EMPLOYEE_STATUS 
            from 
                POS_USERS PU
                LEFT JOIN #dsn#.BRANCH  B ON B.BRANCH_ID = PU.BRANCH_ID
                LEFT JOIN #dsn#.EMPLOYEES  E ON E.EMPLOYEE_ID = PU.EMPLOYEE_ID
            where 1=1
                <cfif isdefined("arguments.row_id")>AND ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.row_id#"></cfif>
                <cfif isdefined("arguments.pos_type") and arguments.pos_type eq 1>AND PU.POS_TYPE = 1</cfif>
                <cfif isdefined("arguments.pos_type") and arguments.pos_type eq 2>AND PU.POS_TYPE = 2</cfif>
                <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                    AND USERNAME LIKE '%#arguments.keyword#%'
                </cfif>
                <cfif isdefined("arguments.employee_id") and len(arguments.employee_id) and len(arguments.employee_name)>
					AND PU.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.employee_id#">
				</cfif>
                <cfif isdefined("arguments.branch") and len(arguments.branch)>AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch#"></cfif>
                ORDER BY ROW_ID DESC
        </cfquery>
        <cfreturn get_users>
    </cffunction>
    <cffunction name="DEL" access="public" returntype="any">
        <cftry>
            <cfset responseStruct = structNew()> 
            <cfquery name="DEL" datasource="#dsn_dev#">
                DELETE FROM POS_USERS WHERE ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.row_id#">
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
</cfcomponent>