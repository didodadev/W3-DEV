<cfif not isdefined("attributes.pay_selects")>
	<script>
		alert('Ödeme Seçenekleri Seçiniz!');
		history.back();
	</script>
    <cfabort>
</cfif>

<cfquery name="add_" datasource="#dsn_dev#">
	INSERT INTO
    	SETUP_POS_PAYMETHODS
        (
        WRK_POS_ID,
        CODE,
        HEADER,
        SYMBOL,
        PAY_LIMIT,
        DECIMAL_COUNT,
        DAILY_RATE,
        PROVISITION,
        PAY_SELECTS,
        RECORD_IP,
        RECORD_EMP,
        RECORD_DATE
        )
        VALUES
        (
        <cfif len(attributes.WRK_POS_ID)>#attributes.WRK_POS_ID#<cfelse>NULL</cfif>,
        '#attributes.code#',
        '#attributes.HEADER#',
        '#attributes.SYMBOL#',
        '#attributes.PAY_LIMIT#',
        '#attributes.DECIMAL_COUNT#',
        '#attributes.DAILY_RATE#',
        <cfif len(attributes.PROVISITION)>#attributes.PROVISITION#<cfelse>NULL</cfif>,
        '#attributes.PAY_SELECTS#',
        '#cgi.remote_addr#',
        #session.ep.userid#,
        #now()#
        )
</cfquery>
<script>
	window.opener.location.reload();
	window.close();
</script>
<cfabort>