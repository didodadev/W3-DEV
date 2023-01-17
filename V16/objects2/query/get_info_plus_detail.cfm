<cfquery name="GET_VALUES" datasource="#DSN3#">
		SELECT
			*
		FROM
			PRODUCT_INFO_PLUS
		WHERE
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfquery datasource="#DSN3#" name="GET_LABELS">
	SELECT
		*
	FROM
		SETUP_PRO_INFO_PLUS_NAMES
	WHERE	
		OWNER_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
</cfquery>
