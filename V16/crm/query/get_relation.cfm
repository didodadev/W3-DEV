<cfquery name="GET_RELATION" datasource="#dsn#">
	SELECT
		PARTNER_RELATION_ID,
		PARTNER_RELATION 
	FROM 
		SETUP_PARTNER_RELATION
	<cfif isdefined("attributes.depot_relation_id")>
	WHERE
		PARTNER_RELATION_ID = #attributes.depot_relation_id#
	</cfif>	
	ORDER BY
		PARTNER_RELATION_ID
</cfquery>


