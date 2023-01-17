<!--- emp_id si tanimlar sayfasindan categoriler listelenirken cagiriliyor. --->
<cfquery name="GET_EMPLOYEE" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		EMPLOYEES
	WHERE 
		EMPLOYEE_STATUS = 1
	<cfif isDefined('attributes.EMP_ID')>
		AND EMPLOYEE_ID=#attributes.EMP_ID#
	</cfif>
</cfquery>
