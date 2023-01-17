<cfquery name="get_sub_type" datasource="#dsn_dev#">
	SELECT 
    	* 
    FROM 
    	EXTRA_PRODUCT_TYPES_ROWS 
    WHERE 
    	SUB_TYPE_ID = #attributes.sub_type_id#
</cfquery>
<cfif get_sub_type.recordcount>
	<script>
		alert('Ürünlerde Tanımlı Olan Bir Kriteri Silemezsiniz!');
		history.back();
	</script>
    <cfabort>
</cfif>
<cfquery name="add_" datasource="#dsn_dev#">
	DELETE FROM
    	EXTRA_PRODUCT_TYPES_SUBS
    WHERE
    	SUB_TYPE_ID = #attributes.sub_type_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>