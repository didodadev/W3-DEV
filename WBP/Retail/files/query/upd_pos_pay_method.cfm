<cfif not isdefined("attributes.pay_selects")>
	<script>
		alert('Ödeme Seçenekleri Seçiniz!');
		history.back();
	</script>
    <cfabort>
</cfif>

<cfquery name="add_" datasource="#dsn_dev#">
	UPDATE
    	SETUP_POS_PAYMETHODS
    SET
        WRK_POS_ID = <cfif len(attributes.WRK_POS_ID)>#attributes.WRK_POS_ID#<cfelse>NULL</cfif>,
        CODE = '#attributes.code#',
        HEADER = '#attributes.HEADER#',
        SYMBOL = '#attributes.SYMBOL#',
        PAY_LIMIT = '#attributes.PAY_LIMIT#',
        DECIMAL_COUNT = '#attributes.DECIMAL_COUNT#',
        DAILY_RATE = '#attributes.DAILY_RATE#',
        PROVISITION = <cfif len(attributes.PROVISITION)>#attributes.PROVISITION#<cfelse>NULL</cfif>,
        PAY_SELECTS = '#attributes.PAY_SELECTS#',
        UPDATE_IP = '#cgi.remote_addr#',
        UPDATE_EMP = #session.ep.userid#,
        UPDATE_DATE = #now()#
    WHERE
    	ROW_ID = #attributes.row_id#
</cfquery>
<script>
	window.opener.location.reload();
	window.close();
</script>
<cfabort>