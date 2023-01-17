<cfsetting showdebugoutput="no">
<cfquery name="upd_" datasource="#dsn#">
	UPDATE
		EMPLOYEE_DAILY_IN_OUT_SHIFT
	SET
		ROW_MINUTE = #(attributes.shift_hour * 60) + attributes.shift_minute#
	WHERE
		ROW_ID = #attributes.row_id#
</cfquery>
<script>
	<cfoutput>
		get_shift_info('#attributes.in_out_id#','#attributes.gun#','#attributes.ay#','#attributes.yil#','#attributes.tip#','1');
		document.getElementById('#attributes.tip#_#attributes.in_out_id#_#attributes.gun#').innerHTML = '#attributes.shift_hour#:<cfif len(attributes.shift_minute) eq 1>0</cfif>#attributes.shift_minute#';
	</cfoutput>
</script>
