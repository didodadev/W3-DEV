<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
		<cfquery name="ADD_CLASS_RESULTS" datasource="#dsn#">
			DELETE FROM
				TRAINING_CLASS_ATTENDANCE_DT
			WHERE
				CLASS_ATTENDANCE_ID = #attributes.class_id#
		</cfquery>	
		<cfquery name="UPD_CLASS_ATTENDANCE" datasource="#dsn#">
			DELETE FROM
				TRAINING_CLASS_ATTENDANCE
			WHERE
				CLASS_ATTENDANCE_ID = #attributes.class_attendance_id#
		</cfquery>	
	</CFTRANSACTION>
</CFLOCK>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
