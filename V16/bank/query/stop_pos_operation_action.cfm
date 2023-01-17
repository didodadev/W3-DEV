<cfsetting showdebugoutput="no">
<!--- <cfset "session.ep.auto_pos_action_pause_#attributes.pos_operation_id#" = 1>
--->
<cfquery name="del_row" datasource="#dsn3#">
	DELETE FROM POS_OPERATION_STATUS WHERE POS_OPERATION_ID = #attributes.pos_operation_id#
</cfquery>
<cfquery name="add_row" datasource="#dsn3#">
	INSERT INTO POS_OPERATION_STATUS (POS_OPERATION_ID,POS_STATUS) VALUES (#attributes.pos_operation_id#,1)
</cfquery>
<cfquery name="upd_pos_stopped" datasource="#dsn3#">
	UPDATE POS_OPERATION SET STOPPED_EMP = #session.ep.userid#,STOPPED_DATE = #now()# WHERE POS_OPERATION_ID = #attributes.pos_operation_id#
</cfquery>
İşlem Durduruluyor. 
