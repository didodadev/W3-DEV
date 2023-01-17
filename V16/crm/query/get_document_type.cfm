<cfquery name="GET_DOCUMENT_TYPE" datasource="#dsn#">
	SELECT 
		SECUREFUND_CAT_ID, 
		SECUREFUND_CAT 
	FROM
		SETUP_SECUREFUND
	<cfif isdefined("attributes.document_type_id")>
	WHERE
		SECUREFUND_CAT_ID = #attributes.document_type_id#
	</cfif>	
	ORDER BY 
		SECUREFUND_CAT_ID 
</cfquery>

