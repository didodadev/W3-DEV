<cfquery name="del_print_position_cat" datasource="#dsn#">
    DELETE FROM 
    	SETUP_PRINT_FILES_POSITION 
    WHERE 
    	FORM_ID = #attributes.document_id#
    AND
    	POS_CAT_ID = #attributes.pos_cat_id#
    AND 
    	OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
