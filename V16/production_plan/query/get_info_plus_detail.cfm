<cfquery name="GET_VALUES" datasource="#DSN3#">
		SELECT
			*
		FROM
			PRODUCT_TREE_INFO_PLUS
		WHERE
			STOCK_ID =#attributes.ID#
</cfquery>
<cfquery datasource="#DSN3#" name="GET_LABELS">
	SELECT
		*
	FROM
		SETUP_PRO_INFO_PLUS_NAMES
	WHERE	
		OWNER_TYPE_ID =#attributes.TYPE_ID#
</cfquery>
