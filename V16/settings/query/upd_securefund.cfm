<cfquery name="UPD_GUARANTY_CAT" datasource="#DSN#">
	UPDATE 
		SETUP_SECUREFUND
	SET
		 SECUREFUND_CAT = '#attributes.SECUREFUND_CAT#',
		 SECUREFUND_CAT_DETAIL = '#attributes.SECUREFUND_CAT_DETAIL#',
		 UPDATE_DATE = #now()#,
		 UPDATE_EMP = #session.ep.userid#,
		 UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
		SECUREFUND_CAT_ID = #attributes.SECUREFUND_CAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_securefund" addtoken="no">
