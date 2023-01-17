<cfquery name="upd_sco_detail" datasource="#dsn#">
	UPDATE
		TRAINING_CLASS_SCO
	SET
		IS_FREE = <cfif isdefined("attributes.is_free")><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_free#"><cfelse>NULL</cfif>,
		WIDTH  = <cfif len(attributes.width)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.width#"><cfelse>NULL</cfif>,
		HEIGHT  = <cfif len(attributes.height)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.height#"><cfelse>NULL</cfif>,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#'
	WHERE
		SCO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sco_id#">		
</cfquery>
<script type="text/javascript">
	window.close();
</script>
