<cfquery name="DELIMCAT" datasource="#dsn#">
	DELETE FROM SETUP_IM WHERE IMCAT_ID=#IMCAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_im_cat" addtoken="no">
