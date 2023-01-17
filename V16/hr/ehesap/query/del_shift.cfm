<cfquery name="get_shift" datasource="#dsn#" maxrows="1">
	SELECT SHIFT_ID FROM EMPLOYEES_IN_OUT WHERE SHIFT_ID = #attributes.SHIFT_ID#
</cfquery>
<cfif get_shift.recordcount>
	<script type="text/javascript">
		alert('Kullanımda Olan Bir Vardiyayı Silemezsiniz!');
		history.back();
	</script>	
<cfabort>
</cfif>

<cfquery name="del_shift" datasource="#dsn#">
	DELETE FROM
		SETUP_SHIFTS
	WHERE
		SHIFT_ID = #attributes.SHIFT_ID#
</cfquery>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.shift</cfoutput>";
	wrk_opener_reload();
	window.close();
</script>

