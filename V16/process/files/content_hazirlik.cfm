<cfquery name="upd_cont_stage" datasource="#attributes.data_source#">
	UPDATE #caller.dsn_alias#.CONTENT SET STAGE_ID = 0 WHERE CONTENT_ID = #attributes.action_id# 
</cfquery>

