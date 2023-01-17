<cfsetting showdebugoutput="no">
<cfquery name="upd_pro" datasource="#dsn3#">
	UPDATE 
		PRODUCT_COMMENT
	SET 
		STAGE_ID=-2
	WHERE 
		PRODUCT_COMMENT_ID = #attributes.comment_id#
</cfquery>

