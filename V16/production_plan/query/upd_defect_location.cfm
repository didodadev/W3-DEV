<cfif not isdefined('status')>
	<cfset status = 0>
</cfif>
<cfquery name="add_DEFECT_LOCATION" datasource="#dsn_ts#">
	UPDATE
		SETUP_DEFECT_LOCATION
	SET
		DEFECT_LOCATION='#DEFECT_LOCATION#',
		DEFECT_LOCATION_DETAIL='#DEFECT_LOCATION_DETAIL#',
		STATUS = #STATUS#,
		UPDATE_EMP=#SESSION.EP.USERID#,
		UPDATE_IP='#CGI.REMOTE_ADDR#',
		UPDATE_DATE=#NOW()#
	WHERE
		DEFECT_LOCATION_ID='#DEFECT_LOCATION_ID#'
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
