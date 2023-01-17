<cfquery name="GET_EVENT_CATS" datasource="#DSN#">
	SELECT 
		<cfif isdefined("session.ep.userid")>
            IS_STANDART = 
            CASE
              WHEN (SELECT M.EVENTCAT_ID FROM MY_SETTINGS M WHERE M.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID AND M.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">) IS NULL THEN '0'
                  ELSE '1'
             END,
		<cfelse>
			'0' AS IS_STANDART,
		</cfif>
		EVENTCAT,
		EVENTCAT_ID		
	FROM 
		EVENT_CAT
	ORDER BY
		EVENTCAT
</cfquery>
