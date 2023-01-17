<cfquery name="ADD_COMMENT" datasource="#dsn3#">
	UPDATE 
		PRODUCT_COMMENT 
	SET
		PRODUCT_COMMENT = '#attributes.PRODUCT_COMMENT#',
		PRODUCT_COMMENT_POINT = #attributes.PRODUCT_COMMENT_POINT#,
		NAME = '#attributes.NAME#',
		SURNAME = '#attributes.SURNAME#',
		STAGE_ID = #attributes.STAGE_ID#,	
		MAIL_ADDRESS = '#attributes.MAIL_ADDRESS#'
	WHERE
		PRODUCT_COMMENT_ID = #attributes.PRODUCT_COMMENT_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
