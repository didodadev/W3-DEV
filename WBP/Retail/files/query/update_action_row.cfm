<cfquery name="upd_" datasource="#dsn_dev#">
	UPDATE
    	GENIUS_ACTIONS_ROWS
    SET
    	BARCODE = '#attributes.barcode#'
    WHERE
    	ACTION_ROW_ID = #attributes.action_row_id#
</cfquery>