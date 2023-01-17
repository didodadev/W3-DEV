<cfquery name="del_camp_role" datasource="#dsn3#">
	DELETE FROM SETUP_CAMPAIGN_ROLES WHERE CAMPAIGN_ROLE_ID=#CAMPAIGN_ROLE_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_camp_rol" addtoken="no">

