<cfquery name="upd_quiz_stage" datasource="#caller.dsn#">
	UPDATE QUIZ SET STAGE_ID = -2 WHERE QUIZ_ID = #attributes.action_id#
</cfquery>

