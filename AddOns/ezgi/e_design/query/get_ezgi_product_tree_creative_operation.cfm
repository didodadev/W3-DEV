<cfquery name="get_operation" datasource="#dsn3#">
	SELECT
    	0 AS RELATED_ID,        
    	PIECE_ROW_ID, 
        OPERATION_TYPE_ID, 
        SIRA AS LINE_NUMBER, 
        AMOUNT
	FROM            
    	EZGI_DESIGN_PIECE_ROTA
	WHERE        
    	PIECE_ROW_ID = #attributes.design_piece_row_id#
  	ORDER BY
    	SIRA
</cfquery>