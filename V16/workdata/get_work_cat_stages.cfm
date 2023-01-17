<cffunction name="get_work_cat_stages" access="public" returnType="query" output="no">
	<cfargument name="work_cat_id" required="yes" type="string">
        <cfquery name="GET_STAGES" datasource="#DSN#">
            SELECT PROCESS_ID FROM PRO_WORK_CAT WHERE WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_cat_id#">	
        </cfquery>
        <cfset process_id_list = ''>
		<cfif get_stages.recordcount and len(get_stages.process_id)>
            <cfset process_id_list = valuelist(get_stages.process_id,',')>
        </cfif>
        <cfquery name="GET_STAGE_NAMES" datasource="#DSN#">                  
            SELECT
                PTR.PROCESS_ROW_ID,
                PTR.STAGE
            FROM
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT,
                PROCESS_TYPE_ROWS PTR
            WHERE
				PT.IS_ACTIVE = 1 AND
				PTR.PROCESS_ID = PT.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.addwork%"> AND
                PTR.PROCESS_ROW_ID IN (#process_id_list#)
        </cfquery>
	<cfreturn get_stage_names>
</cffunction>
