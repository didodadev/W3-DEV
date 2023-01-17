<cfquery name="control_invoice" datasource="#dsn2#">
	SELECT ISNULL(IS_PROCESS,0) IS_PROCESS FROM EINVOICE_RECEIVING_DETAIL WHERE RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#">
</cfquery>
<cfif control_invoice.is_process eq 1>
	<script type="text/javascript">
		alert("Fatura Kaydı Yapıldığı İçin Belgeyi Silemezsiniz !");
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="get_path" datasource="#dsn2#">
				SELECT PATH FROM EINVOICE_RECEIVING_DETAIL WHERE RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#">
			</cfquery>
			<cfquery name="delete_inv" datasource="#dsn2#">
				DELETE FROM EINVOICE_RECEIVING_DETAIL WHERE RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#">
			</cfquery>
			<cfquery name="Del_Relation_Warnings" datasource="#dsn2#">
				DELETE FROM #dsn_alias#.PAGE_WARNINGS WHERE ACTION_TABLE = 'EINVOICE_RECEIVING_DETAIL' AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
			</cfquery>
			<cfif FileExists("#upload_folder##dir_seperator##get_path.path#")>
				<cffile action="delete" file="#upload_folder##dir_seperator##get_path.path#">
			</cfif>	
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>

