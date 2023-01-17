<cfquery name="CHECK_USER_VOTE" datasource="#dsn#">
	SELECT
		EMP_ID
	FROM
		SURVEY_VOTES
	WHERE
		<cfif isdefined("session.pp")>
			PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.PP.USERID#"> AND
		<cfelseif isdefined("session.ww.userid")>
			CONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.WW.USERID#"> AND
		</cfif>
		SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SURVEY_ID#">
</cfquery>
