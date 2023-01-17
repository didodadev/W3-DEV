<cfquery name="DEL_VISION_TYPE" datasource="#DSN#">
	DELETE
	FROM
    	SETUP_VISION_TYPE
	WHERE 
		VISION_TYPE_ID=#attributes.vision_type_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_vision_type" addtoken="no">
