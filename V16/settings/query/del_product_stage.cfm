<cfquery name="DELPRO_STAGE" datasource="#dsn3#">
	DELETE FROM PRODUCT_STAGE WHERE PRODUCT_STAGE_ID=#URL.PRODUCT_STAGE_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_pro_stage" addtoken="no">
