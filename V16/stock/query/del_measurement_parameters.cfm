<cfquery name="DEL_PARAMETER" datasource="#DSN#" >  
    DELETE FROM MEASUREMENT_PARAMETERS_ROWS WHERE MEASUREMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.measurement_id#">
</cfquery>
<cfquery name="DEL_PARAMETER" datasource="#DSN#" >  
    DELETE FROM MEASUREMENT_PARAMETERS WHERE MEASUREMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.measurement_id#">
</cfquery>
<script type="text/javascript">
    window.location.href="/<cfoutput>#request.self#?fuseaction=stock.measurement_parameters</cfoutput>";
</script>