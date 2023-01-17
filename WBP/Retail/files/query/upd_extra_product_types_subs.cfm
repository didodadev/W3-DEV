<cfquery name="get_sub_type" datasource="#dsn_dev#">
	SELECT * FROM EXTRA_PRODUCT_TYPES_SUBS WHERE TYPE_ID = #attributes.type_id# AND SUB_TYPE_NAME = '#attributes.sub_type_name#' AND SUB_TYPE_ID <> #attributes.sub_type_id#
</cfquery>
<cfif get_sub_type.recordcount>
	<script>
		alert('Sistemde Bu Tanım Bulunmaktadır! Lütfen Kontrol Ediniz!');
		history.back();
	</script>
    <cfabort>
</cfif>
<cfquery name="add_" datasource="#dsn_dev#">
	UPDATE
    	EXTRA_PRODUCT_TYPES_SUBS
    SET
        TYPE_ID = #attributes.type_id#,
        SUB_TYPE_NAME = '#attributes.sub_type_name#',
        UPDATE_IP = '#cgi.remote_addr#',
        UPDATE_EMP = #session.ep.userid#,
        UPDATE_DATE = #now()#
    WHERE
    	SUB_TYPE_ID = #attributes.sub_type_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>