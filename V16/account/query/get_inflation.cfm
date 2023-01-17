<cfquery name="GET_INFLATION" datasource="#DSN#">
   SELECT 
   		* 
   FROM 
   		INFLATION 
	<cfif isdefined("attributes.wanted_year") and IsNumeric(attributes.wanted_year)>
	WHERE
		INF_YEAR = #attributes.wanted_year#
	</cfif>
   ORDER BY 
   		INF_MONTH
</cfquery>
