<cfquery name="MONTHLY_WORKS" datasource="#DSN#">
	SELECT 
		WORK_ID,
		TARGET_START,
		TARGET_FINISH,
		WORK_HEAD,
		PROJECT_ID
	FROM 
		PRO_WORKS
	WHERE
		WORK_CURRENCY_ID <> 3 AND
		WORK_STATUS = 1 AND
		(
			<cfif isDefined("session.pda.userid")>
				PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#">
			<cfelse>
				PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#">
			</cfif>
			OR
			<cfif isDefined("session.pda.userid")>
				RECORD_AUTHOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#"> OR
				UPDATE_AUTHOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#">
			<cfelse>
				RECORD_AUTHOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#"> OR
				UPDATE_AUTHOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#">
			</cfif>
		)
		AND
		(
		 	(
		 		TARGET_START >= #attributes.to_day# AND
		 		TARGET_START < #DATEADD("M",1,attributes.to_day)#
		 	) 
		 	OR
		 	(
		 		TARGET_FINISH >= #attributes.to_day# AND
				TARGET_FINISH < #DATEADD("M",1,attributes.to_day)#
		 	)
		)
	    ORDER BY 
			TARGET_START
</cfquery>
