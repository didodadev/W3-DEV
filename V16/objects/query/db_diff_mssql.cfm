<cfquery datasource="#attributes.upgrade_dsn#" name="upgradedsn">
#attributes.sql_kod#
</cfquery>

<cfform name="db_diff" action="#request.self#?fuseaction=objects.popup_dsp_db_diff" method="post">
	<cfoutput>
		<input type="hidden" name="dsn_1" id="dsn_1" value="#attributes.dsn_1#">
		<input type="hidden" name="dsn_2" id="dsn_2" value="#attributes.dsn_2#">
		<input type="hidden" name="db_1" id="db_1" value="#attributes.db_1#">
		<input type="hidden" name="db_2" id="db_2" value="#attributes.db_2#">
		<input type="hidden" name="db_type_1" id="db_type_1" value="#attributes.db_type_1#">
		<input type="hidden" name="db_type_2" id="db_type_2" value="#attributes.db_type_2#">
		<input type="hidden" name="db_chartype_1" id="db_chartype_1" value="#attributes.db_chartype_1#">
		<input type="hidden" name="db_chartype_2" id="db_chartype_2" value="#attributes.db_chartype_2#">
		<input type="hidden" name="db_type_1_1" id="db_type_1_1" value="#attributes.db_type_1_1#">
		<input type="hidden" name="db_type_2_1" id="db_type_2_1" value="#attributes.db_type_2_1#">
	</cfoutput>
</cfform>

<script type="text/javascript">
	alert('SQL kodunuz başarıyla çalıştırılmıştır !');
	db_diff.submit();
</script>
