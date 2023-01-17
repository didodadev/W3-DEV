<cfsetting showdebugoutput="no">
<cfquery name="get_payment" datasource="#dsn#">
	SELECT XML_FILE_NAME,XML_FILE_SERVER_ID,PAY_YEAR,PAY_MON,RELATED_COMPANY FROM EMPLOYEES_BANK_PAYMENTS WHERE BANK_PAYMENT_ID = #attributes.payment_id#
</cfquery>
<cfif get_payment.RECORDCOUNT>
	<cf_del_server_file output_file="hr/eislem/#get_payment.xml_file_name#" output_server="#get_payment.xml_file_server_id#">
<cfelse>
	<script type="text/javascript">
		alert("Eski Dosya Bulunamadı ama Veritabanından Silindi !");
	</script>
</cfif>
<cfquery name="del_payment" datasource="#dsn#">
	DELETE 
		FROM
	EMPLOYEES_BANK_PAYMENTS 
		WHERE 
	BANK_PAYMENT_ID = #attributes.payment_id#
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.payment_id# " action_name="E-Hesap Banka Ödeme Emri - #get_payment.pay_year# - #get_payment.pay_mon# -  #get_payment.RELATED_COMPANY#">
<script type="text/javascript">
	document.getElementById('bank_info_td_<cfoutput>#attributes.payment_id#</cfoutput>').innerHTML = '<font color="red">Silindi!</font>';
</script>
