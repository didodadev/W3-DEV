<cfquery name="GET_CONSUMER_CATS" datasource="#DSN#">
	SELECT 
		CONSCAT_ID,
		CONSCAT,
		HIERARCHY
	FROM 
		CONSUMER_CAT
	<cfif isdefined("attributes.is_active_consumer_cat")>
	WHERE
		IS_ACTIVE = 1
	</cfif>
	ORDER BY 
		CONSCAT
</cfquery>		

