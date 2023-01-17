<cfif CAMP_CAT_ID GT 0>
	<cfquery name="DEL_CAMP_CAT" datasource="#dsn3#">
		DELETE FROM CAMPAIGN_CATS WHERE CAMP_CAT_ID=#CAMP_CAT_ID#
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.form_add_camp_cat" addtoken="no">
