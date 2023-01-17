<cftransaction>
	<cfquery name="ADD_ANALYSIS_RESULT" datasource="#DSN#">
		INSERT INTO
			MEMBER_ANALYSIS_RESULTS
			(
                COMPANY_ID,
                ANALYSIS_ID,
                PARTNER_ID,
                CONSUMER_ID,
                USER_POINT
			)
			VALUES
			(
                #session.pp.company_id#,
                #session.analysis_id#,
                <cfif isdefined("session.pp.userid")>
                    #session.pp.userid#, 
                    NULL,
                <cfelse>
                    NULL, 
                    #session.ww.userid#,
                </cfif>
                0
			)
	</cfquery>	
	<cfquery name="GET_RESULT_ID" datasource="#DSN#">
		SELECT
			MAX(RESULT_ID) AS MAX_ID
		FROM
			MEMBER_ANALYSIS_RESULTS
		WHERE
			<cfif isdefined("session.pp.userid")>
				PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
			<cfelse>
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			</cfif>
			AND ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.analysis_id#">
	</cfquery>
</cftransaction>
<cfset session.result_id = get_result_id.max_id>
