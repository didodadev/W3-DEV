<cfquery name="UPDPRO_STAGE" datasource="#dsn3#">
	UPDATE 
		PRODUCT_STAGE 
	SET 
		PRODUCT_STAGE='#product_stage#',
		PRODUCT_STAGE_DETAIL = '#DETAIL#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		PRODUCT_STAGE_ID=#PRODUCT_STAGE_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_pro_stage" addtoken="no">
