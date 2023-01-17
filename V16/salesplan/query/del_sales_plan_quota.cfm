<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="del_plan" datasource="#dsn#">
			DELETE FROM SALES_QUOTES_GROUP WHERE SALES_QUOTE_ID = #attributes.plan_id#
		</cfquery>
		<cfquery name="del_rows" datasource="#dsn#">
			DELETE FROM SALES_QUOTES_GROUP_ROWS WHERE SALES_QUOTE_ID = #attributes.plan_id#
		</cfquery>
		<cfquery name="del_money" datasource="#dsn#">
			DELETE FROM SALES_QUOTES_GROUP_MONEY WHERE ACTION_ID = #attributes.plan_id#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=salesplan.list_sales_plan_quotas" addtoken="no">
