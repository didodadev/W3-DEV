<cfif not isdefined("session.cp.userid")>
	<cflocation url="#request.self#?fuseaction=objects2.kariyer_login" addtoken="no">
</cfif>
<cfquery name="del_relative" datasource="#dsn#">
	DELETE FROM EMPLOYEES_RELATIVES WHERE RELATIVE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.relative_id#">
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

