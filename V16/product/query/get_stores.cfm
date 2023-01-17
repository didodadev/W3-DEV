<cfquery name="GET_STORES" datasource="#DSN#">
	SELECT  
		DEPARTMENT_HEAD,
		DEPARTMENT_ID
	FROM 
		DEPARTMENT 
	WHERE
		IS_STORE <> 2
	  <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		AND BRANCH_ID = #attributes.branch_id#
	  </cfif>
</cfquery>
