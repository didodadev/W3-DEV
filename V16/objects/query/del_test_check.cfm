<cfset dsn = "workcube_worknet"><!--- DSN Tanimi Yapildi, fonksiyona gonderilmesi gerekiyor. --->
<cfif isdefined("attributes.check_id") and len(attributes.check_id)>
	<cfquery  name="delTest" datasource="#dsn#">
		DELETE FROM TEST_CHECK_ROW WHERE CHECK_ID=#attributes.check_id#
	</cfquery>
	<cfquery name="delTestMain" datasource="#dsn#">
		DELETE FROM TEST_CHECK_MAIN WHERE CHECK_ID=#attributes.check_id#
	</cfquery>
	<script type="text/javascript">
		wrk_opener_reload();
	</script>
</cfif>
<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>
