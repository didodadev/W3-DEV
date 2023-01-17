<cfquery name="get_detail" datasource="#dsn#">
	SELECT
    	START_DATE,
        FINISH_DATE,
        EMPLOYEE_ID,
        ROW_ID
    FROM
    	EMPLOYEE_DAILY_IN_OUT
    WHERE
    	ROW_ID = #attributes.row_id#
</cfquery>
<cfquery name="upd_emp_daily_in_out" datasource="#dsn#">
	DELETE FROM EMPLOYEE_DAILY_IN_OUT WHERE ROW_ID = #attributes.row_id#
</cfquery>
<cfset action_ = 'Pdks Kaydı Silindi(EMP_ID:#get_detail.EMPLOYEE_ID# #dateformat(get_detail.start_date,dateformat_style)# #timeformat(get_detail.start_date,timeformat_style)# - #dateformat(get_detail.finish_date,dateformat_style)# #timeformat(get_detail.finish_date,timeformat_style)# ROW_ID:#attributes.row_id#)'>
<cf_add_log  log_type="-1" action_id="#attributes.row_id#" action_name="#action_#">
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
