<cfquery name="upd_retun_date" datasource="#dsn#">
	UPDATE ASSET_P_RESERVE
	SET
		RETURN_DATE = #NOW()#,
		STATUS = 2
	WHERE
		ASSETP_RESID = #ATTRIBUTES.ASSETP_RESID# AND
		ASSETP_ID = #ATTRIBUTES.asset_id#
</cfquery>

<script type="text/javascript">
	 wrk_opener_reload();
	 window.close();
</script>
