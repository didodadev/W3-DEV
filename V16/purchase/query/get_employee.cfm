<cfquery name="GET_EMPLOYEE" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		EMPLOYEES
	WHERE 
		EMPLOYEE_STATUS = 1
		<!---PK 14032006 30güne silinsin  <cfif isDefined("GET_OFFER_DETAIL.VALID_EMP")>
	AND 
		EMPLOYEE_ID = #GET_OFFER_DETAIL.VALID_EMP#
		</cfif> --->
</cfquery>
