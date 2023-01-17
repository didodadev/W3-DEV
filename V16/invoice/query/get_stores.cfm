<cfquery name="STORES" datasource="#DSN#">
	SELECT
		DEPARTMENT_ID,
		#dsn#.Get_Dynamic_Language(DEPARTMENT_ID,'#session.ep.language#','DEPARTMENT','DEPARTMENT_HEAD',NULL,NULL,DEPARTMENT_HEAD) AS DEPARTMENT_HEAD,
		BRANCH_ID
	FROM
		DEPARTMENT
	WHERE 
		IS_STORE <> 2 AND
		DEPARTMENT_STATUS = 1 AND
		BRANCH_ID IN (SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id#)
		<cfif session.ep.isBranchAuthorization>
			AND BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
		</cfif>
	ORDER BY
		DEPARTMENT_HEAD
</cfquery>
