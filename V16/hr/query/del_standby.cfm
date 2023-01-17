<cfquery name="get_stnd" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS_STANDBY WHERE SB_ID = #attributes.SB_ID#
</cfquery>
<cfquery name="upd_position" datasource="#dsn#">
	UPDATE EMPLOYEE_POSITIONS SET UPPER_POSITION_CODE = NULL,UPPER_POSITION_CODE2 = NULL WHERE POSITION_CODE = #get_stnd.position_code#
</cfquery>
<cfquery name="del_standby" datasource="#dsn#">
	DELETE FROM
		EMPLOYEE_POSITIONS_STANDBY
	WHERE
		SB_ID = #attributes.SB_ID#
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.sb_id#" action_name="#attributes.head#" >
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_standby</cfoutput>";
</script>
