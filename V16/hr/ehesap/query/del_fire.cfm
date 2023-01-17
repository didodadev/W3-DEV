<cfquery name="get_puantaj" datasource="#dsn#">
	SELECT TOP 1 IN_OUT_ID FROM EMPLOYEES_PUANTAJ_ROWS WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
</cfquery>
<cfif get_puantaj.recordcount>
	<script type="text/javascript">
		alert('Ücret Kartına Ait Puantaj Kayıtları Tespit Edildi!\nÜcret Kartını Silemezsiniz!');
		window.close();
	</script>
<cfelse>
	<cflock timeout="60">
		<cftransaction>
			<cfquery name="get_in_out" datasource="#DSN#">
				SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
			</cfquery>
			<cfquery name="del_emp_out" datasource="#dsn#">
				DELETE FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
			</cfquery>
			<cfquery name="del_in_out_period" datasource="#dsn#">
				DELETE FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
			</cfquery>
			<cfquery name="del_account" datasource="#dsn#">
				DELETE FROM EMPLOYEES_ACCOUNTS WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
			</cfquery>
			<cfquery name="del_rows" datasource="#dsn#">
				DELETE FROM EMPLOYEES_IN_OUT_PERIOD_ROW WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
			</cfquery>
			<cf_add_log log_type="-1" action_id="#get_in_out.employee_id# " action_name="Çıkış Sil : #attributes.head# (#attributes.in_out_id#)">
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		location.href= document.referrer;
	</script>
</cfif>
