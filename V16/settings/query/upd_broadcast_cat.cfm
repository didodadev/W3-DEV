<cfquery name="upd_broadcast_cat" datasource="#dsn#">
	UPDATE 
		BROADCAST_CAT
	SET 
		BROADCAST_CAT_NAME = '#attributes.broadcast_cat#',	
		BROADCAST_CAT_DETAIL = <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE 
		CAT_ID = #attributes.cat_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_broadcast_cat" addtoken="no">
