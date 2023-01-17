<cf_date tarih = 'attributes.startdate'>
<cf_date tarih = 'attributes.finishdate'>
<cf_date tarih = 'attributes.p_startdate'>
<cf_date tarih = 'attributes.p_finishdate'>

<cfquery name="upd_price" datasource="#dsn_Dev#">
	UPDATE
    	PRICE_TABLE
    SET
    	PRICE_TYPE = #attributes.price_type#,
        STARTDATE = #attributes.startdate#,
        FINISHDATE = #attributes.finishdate#,
        P_STARTDATE = #attributes.p_startdate#,
        P_FINISHDATE = #attributes.p_finishdate#,
    	FIRST_RECORD_DATE = RECORD_DATE,
    	RECORD_DATE = #now()#
    WHERE
    	ROW_ID = #attributes.row_id#
</cfquery>

<script>
	window.close();
	window.opener.location.reload();
</script>