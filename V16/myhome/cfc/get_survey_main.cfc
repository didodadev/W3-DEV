<cfcomponent>
	<cffunction name="survey_records" access="public" returntype="query">
		<cfargument name="survey_type" type="numeric" required="no">
       	<cfargument name="keyword" type="string" required="no">
        <cfargument name="is_show_myhome" type="boolean">
        <cfargument name="result_control" type="numeric">
        <cfargument name="action_type_id" type="numeric">
		<cfquery name="get_survey" datasource="#this.dsn#"> 
            SELECT
                SM.SURVEY_MAIN_HEAD,
                SM.SURVEY_MAIN_ID,
                SM.TYPE,
                SM.RECORD_DATE
            FROM
                SURVEY_MAIN SM
            WHERE
            	IS_ACTIVE = 1
                <cfif isdefined('arguments.is_show_myhome') and len(arguments.is_show_myhome)>
                	AND SM.IS_SHOW_MYHOME = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_show_myhome#">
                </cfif>
                <cfif isdefined('arguments.survey_type') and len(arguments.survey_type)>
					AND SM.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_type#">
                </cfif>
                <cfif isdefined('arguments.keyword') and len(arguments.keyword)>
                    AND SM.SURVEY_MAIN_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                </cfif>
                <cfif isdefined('arguments.result_control') and arguments.result_control eq 1 and isdefined('arguments.action_type_id') and len(arguments.action_type_id)>
                    AND SM.SURVEY_MAIN_ID NOT IN(SELECT SURVEY_MAIN_ID FROM SURVEY_MAIN_RESULT WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_type_id#">)
                </cfif>
            ORDER BY
                SM.RECORD_DATE DESC
        </cfquery>
        <cfreturn get_survey>
	</cffunction>
</cfcomponent>
