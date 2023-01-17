<cfquery name="get_sub_type" datasource="#dsn_dev#">
	SELECT * FROM EXTRA_PRODUCT_TYPES_SUBS WHERE TYPE_ID = #attributes.type_id# AND SUB_TYPE_NAME = '#attributes.sub_type_name#'
</cfquery>
<cfif get_sub_type.recordcount>
	<script>
		alert('Sistemde Bu Tanım Bulunmaktadır! Lütfen Kontrol Ediniz!');
		history.back();
	</script>
    <cfabort>
</cfif>
<cfquery name="add_" datasource="#dsn_dev#">
	INSERT INTO
    	EXTRA_PRODUCT_TYPES_SUBS
        (
        TYPE_ID,
        SUB_TYPE_NAME,
        RECORD_IP,
        RECORD_EMP,
        RECORD_DATE
        )
        VALUES
        (
        #attributes.type_id#,
        '#attributes.sub_type_name#',
        '#cgi.remote_addr#',
        #session.ep.userid#,
        #now()#
        )
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>