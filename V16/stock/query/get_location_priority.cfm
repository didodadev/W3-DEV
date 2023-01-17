<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT 
		LOCATION_ID
	FROM 
		STOCKS_LOCATION
	WHERE 
	  <cfif isdefined("attributes.id")>
		DEPARTMENT_ID = #listgetat(attributes.id,1,"-")#
	  <cfelse>
		DEPARTMENT_ID = #listgetat(attributes.department_id,1,"-")#
	  </cfif>
		AND PRIORITY = 1
</cfquery>

