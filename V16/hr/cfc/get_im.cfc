<cfcomponent>
<cffunction name="get_im" access="public" returntype="query">
        <cfargument name="empapp_id" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="imcat_id" default="">
        <cfquery name="get_ims" datasource="#this.dsn#">
            SELECT 
                EIM.IMCAT_ID, 
                EIM.IM_ADDRESS,
                SI.IMCAT_ICON
            FROM 
                EMPLOYEES_INSTANT_MESSAGE EIM
                LEFT JOIN SETUP_IM SI ON SI.IMCAT_ID = EIM.IMCAT_ID
            WHERE 
                <cfif isdefined('arguments.empapp_id') and len(arguments.empapp_id)>
                     EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empapp_id#">
                </cfif>    
                <cfif isdefined('arguments.employee_id') and len(arguments.employee_id)>
                     EMPLOYEE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                </cfif> 
        </cfquery>
  <cfreturn get_ims>
</cffunction>
</cfcomponent>
