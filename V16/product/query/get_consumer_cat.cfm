<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT 
		CONSCAT_ID,
		CONSCAT
	FROM 
		CONSUMER_CAT
<!--- Ekleme sayfasından geliyorsa kategorinin aktiflik durumuna bakıyor --->		
	<cfif isdefined("attributes.is_active_consumer_cat")>
	WHERE 
		IS_ACTIVE = 1
	</cfif>
	ORDER BY
		CONSCAT
</cfquery>
