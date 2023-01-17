<cfloop list="#attributes.emp_ids#" index="i">
	<cfquery name="get_emps" datasource="#dsn#">
		SELECT
			EMPLOYEE_ID
		FROM
			TRAINING_CLASS_ANNOUNCE_ATTS
		WHERE
			EMPLOYEE_ID=#i#
			AND ANNOUNCE_ID=#attributes.announce_id#
	</cfquery>
	<cfif not get_emps.recordcount>
		<cfquery name="add_emp_announce" datasource="#dsn#">
			INSERT INTO
				TRAINING_CLASS_ANNOUNCE_ATTS
				(
					EMPLOYEE_ID,
					ANNOUNCE_ID
				)
			VALUES
				(
					#i#,
					#attributes.announce_id#
				)
		</cfquery>
	</cfif>
</cfloop>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
