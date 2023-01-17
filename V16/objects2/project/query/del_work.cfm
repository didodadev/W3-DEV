<cfif isDefined ("attributes.id")>
	<CFLOCK name="#CREATEUUID()#" timeout="20">
		<CFTRANSACTION>
			<cfquery name="WORK_SIL" datasource="#dsn#">
				DELETE 
				FROM 
					PRO_WORKS 
				WHERE 
					WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
			</cfquery>
			<cfquery name="WORK_HIST_SIL" datasource="#dsn#">
				DELETE
				FROM 
					PRO_WORKS_HISTORY 
				WHERE 
					WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
			</cfquery>
			<cfquery name="REL_WORK_SIL" datasource="#dsn#">
				UPDATE
					PRO_WORKS 
				SET
					RELATED_WORK_ID=0
				WHERE 
					RELATED_WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
			</cfquery>
			<cfquery name="delete_relations" datasource="#dsn#">
				DELETE FROM
					PRO_WORK_RELATIONS
				WHERE
					WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
					OR
					PRE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
			</cfquery>
		</CFTRANSACTION>
	</CFLOCK>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

