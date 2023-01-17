<cfquery name="GET_CUSTOMER_CAT" datasource="#DSN#">
	SELECT 
		CONSCAT_ID, 
		CONSCAT 
	FROM 
		CONSUMER_CAT
		<!--- Ekleme sayfasından geliyorsa kategorinin aktiflik durumuna bakıyor --->		
		<cfif isdefined("form_add")>
			WHERE
				IS_ACTIVE = 1
		</cfif>
	ORDER BY
	    HIERARCHY	
</cfquery>
