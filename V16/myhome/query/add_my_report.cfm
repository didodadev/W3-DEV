<cfquery name="add_my_report" datasource="#dsn#">
	INSERT INTO
		REPORT_VIEW
			(
			POSITION_CODE,
			REPORT_ID
			)
		VALUES
			(
			#SESSION.EP.POSITION_CODE#,
			#URL.REPORT_ID#
			)
</cfquery>
<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>
