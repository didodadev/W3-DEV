<cfquery name="GET_CHEQUE_DETAIL" datasource="#DSN2#">
	SELECT 
		C.*
	FROM
		CHEQUE C
		<cfif session.ep.isBranchAuthorization>		
			,CHEQUE_HISTORY
			,PAYROLL
		</cfif>				
	WHERE
		C.CHEQUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
	<cfif session.ep.isBranchAuthorization>		
		AND CHEQUE_HISTORY.PAYROLL_ID = PAYROLL.ACTION_ID
		AND C.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID 
		AND CHEQUE_HISTORY.HISTORY_ID = (SELECT MAX(HISTORY_ID) HISTORY_ID FROM CHEQUE_HISTORY WHERE CHEQUE_HISTORY.CHEQUE_ID = C.CHEQUE_ID AND CHEQUE_HISTORY.PAYROLL_ID IS NOT NULL)
		AND CHEQUE_HISTORY.PAYROLL_ID = PAYROLL.ACTION_ID
		AND PAYROLL.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
	</cfif>			
</cfquery>
<cfquery name="GET_CHEQUE_HISTORY" datasource="#DSN2#">
	SELECT 
		* 
	FROM
		CHEQUE_HISTORY
	WHERE
		CHEQUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
	ORDER BY
    	HISTORY_ID
</cfquery>
