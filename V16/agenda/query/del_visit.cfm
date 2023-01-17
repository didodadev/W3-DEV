<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="DEL_EVENT_PLAN" datasource="#dsn#">
			DELETE FROM EVENT_PLAN WHERE EVENT_PLAN_ID = #attributes.visit_id#
		</cfquery>
		<cfquery name="DEL_EVENT_PLAN_ROW" datasource="#dsn#">
			DELETE FROM EVENT_PLAN_ROW WHERE EVENT_PLAN_ID = #attributes.visit_id#
		</cfquery>
		<cfquery name="DEL_EVENT_PLAN_ROW_POS" datasource="#dsn#">
			DELETE FROM EVENT_PLAN_ROW_POS WHERE EVENT_PLAN_ID = #attributes.visit_id#
		</cfquery>
		<cfquery name="DEL_EVENT_PLAN_ROW_CC" datasource="#dsn#">
			DELETE FROM EVENT_PLAN_ROW_CC WHERE EVENT_PLAN_ID = #attributes.visit_id#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=agenda.list_visit" addtoken="no">
