<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="DEL_SALES_QUOTA_ROW" datasource="#dsn3#">
			DELETE FROM SALES_QUOTAS_ROW_RELATION WHERE SALES_QUOTAS_ROW_ID IN(SELECT SW.SALES_QUOTA_ID FROM SALES_QUOTAS_ROW SW WHERE SW.SALES_QUOTA_ID = #attributes.quota_id#)
		</cfquery>
		<cfquery name="DEL_SALES_QUOTAS_MONEY" datasource="#dsn3#">
			DELETE FROM SALES_QUOTAS_MONEY WHERE ACTION_ID = #attributes.quota_id#
		</cfquery>
		<cfquery name="DEL_SALES_QUOTA_ROW" datasource="#dsn3#">
			DELETE FROM SALES_QUOTAS_ROW WHERE SALES_QUOTA_ID = #attributes.quota_id#
		</cfquery>
		<cfquery name="DEL_SALES_QUOTA" datasource="#dsn3#">
			DELETE FROM SALES_QUOTAS WHERE SALES_QUOTA_ID = #attributes.quota_id#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=salesplan.list_sales_quotas</cfoutput>";
</script>
