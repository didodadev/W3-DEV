<cfquery name="GET_SHELF" datasource="#DSN#">
	SELECT
		*
	FROM 
		SHELF		
	WHERE
		SHELF_MAIN_ID IS NOT NULL
	<cfif isdefined('attributes.se_id') and (not isdefined("form.old_code"))>
		AND SHELF_MAIN_ID = #attributes.se_id#
	</cfif>
	<cfif isdefined('attributes.control_id')>
		AND SHELF_ID = #attributes.control_id#
	</cfif>
</cfquery> 
