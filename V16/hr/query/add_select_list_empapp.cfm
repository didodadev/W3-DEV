<cfloop from="1" to="#listlen(attributes.empapp_id,',')#" index="i">
<!---listede varmı--->
<cfquery name="same_cv" datasource="#dsn#">
SELECT
	EMPAPP_ID
FROM
	EMPLOYEES_APP_SEL_LIST_ROWS
WHERE
	EMPAPP_ID=#ListGetAt(attributes.empapp_id,i,',')# AND
	LIST_ID=#attributes.list_id#
</cfquery>
<!--- listede yoksa ekle--->
	<cfif same_cv.recordcount eq 0>
		<cfquery name="add_empapp" datasource="#dsn#">
		INSERT INTO
			EMPLOYEES_APP_SEL_LIST_ROWS
			(EMPAPP_ID,
			ROW_STATUS,
			LIST_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP)
		VALUES
			(#ListGetAt(attributes.empapp_id,i,',')#,
			1,
			#attributes.list_id#,
			#now()#,
			#session.ep.userid#,
			'#cgi.REMOTE_ADDR#')
		</cfquery>
	</cfif>
</cfloop>
<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
