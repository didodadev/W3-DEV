<cfquery name="DEL_COST_TYPE" datasource="#DSN#">
	DELETE
	FROM
    	SETUP_COST_TYPE
	WHERE 
		COST_TYPE_ID=#attributes.cost_type_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_cost_type" addtoken="no">
