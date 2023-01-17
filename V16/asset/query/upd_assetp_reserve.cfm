<cfinclude template="upd_date_values.cfm">
<cfinclude template="get_check.cfm">
<cfif not check.recordcount>
	<cfquery name="UPD_ASSETP_RESERVE" datasource="#DSN#">
		UPDATE 
			ASSET_P_RESERVE
		SET
			STARTDATE = #FORM.STARTDATE#,
			FINISHDATE = #FORM.FINISHDATE#,
			UPDATE_DATE = #NOW()#,
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#'
		WHERE
			ASSETP_RESID = #attributes.ASSETP_RESID#
	</cfquery>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no='30.Bu Aralıkta Kaynak Rezervasyon Çakışması Var !'>");
		history.back();
	</script>	
	<CFABORT>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
