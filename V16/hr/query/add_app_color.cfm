<!--- basvuru ara veya secim listesinden secilen cv lerin renklerini guncelleme--->
<cfif isdefined("attributes.status_id") and len(attributes.status_id) and len(attributes.list_empapp_id)>
	<cfloop list="#attributes.list_empapp_id#" index="i" delimiters=",">
		<cfquery name="upd_emp_app" datasource="#dsn#">
			UPDATE EMPLOYEES_APP SET APP_COLOR_STATUS = #attributes.status_id# WHERE EMPAPP_ID = #i# AND ( WORK_STARTED = 0 OR WORK_FINISHED = 1)
 		</cfquery>
	</cfloop>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>


