<cfquery datasource="#DSN#" name="SILME">
    DELETE FROM PASSWORD_CONTROL WHERE PASSWORD_ID=	<cfoutput>#attributes.sil#</cfoutput>
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_password_inf" addtoken="no">



