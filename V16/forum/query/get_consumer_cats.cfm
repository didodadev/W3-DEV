<cfquery name="CONSUMER_CATS" datasource="#DSN#">
	SELECT 
		CONSCAT_ID,
		#dsn#.Get_Dynamic_Language(CONSCAT_ID,'#session.ep.language#','CONSUMER_CAT','CONSCAT',NULL,NULL,CONSCAT) AS CONSCAT
	FROM 
		CONSUMER_CAT
	<cfif isDefined("attributes.cons_cats_ids") and len(Listsort(attributes.cons_cats_ids,'numeric'))>
	WHERE
		CONSCAT_ID IN (#Listsort(attributes.cons_cats_ids,'numeric')#)
		<!--- Ekleme sayfasından geliyorsa kategorinin aktiflik durumuna bakıyor --->		
		<cfif isdefined("attributes.is_active_consumer_cat")>
			AND IS_ACTIVE = 1
		</cfif>		
		<cfelse>
			<cfif isdefined("attributes.is_active_consumer_cat")>
			WHERE
				IS_ACTIVE = 1
			</cfif>	
		</cfif>
	ORDER BY 
		CONSCAT	
</cfquery>
