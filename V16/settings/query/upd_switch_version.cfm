<cfquery name="UPD_SWITCH_VER" datasource="#DSN#">
	UPDATE WRK_OBJECTS SET VERSION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#workcube_version#"> WHERE IS_ACTIVE = 1
</cfquery>

<script type="text/javascript">
	alert("<cfoutput>Versiyon Bilgisi #workcube_version# olarak değiştirildi.</cfoutput> !");
	history.back();
</script>
