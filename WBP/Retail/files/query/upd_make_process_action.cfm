<cf_date tarih="attributes.action_startdate">        
<cf_date tarih="attributes.action_finishdate">

<cf_date tarih="attributes.process_startdate">        
<cf_date tarih="attributes.process_finishdate">

<cf_date tarih="attributes.payment_date">

<cfquery name="upd_" datasource="#dsn_Dev#">
	UPDATE
    	PROCESS_ROWS
   	SET
    	ACTION_STARTDATE = #attributes.action_startdate#,
        ACTION_FINISHDATE = #attributes.action_finishdate#,
        PROCESS_STARTDATE = #attributes.process_startdate#,
        PROCESS_FINISHDATE = #attributes.process_finishdate#,
        PAYMENT_DATE = #attributes.payment_date#,
        UPDATE_DATE = #now()#,
        UPDATE_EMP = #session.ep.userid#
    WHERE
    	ROW_ID = #attributes.row_id#
</cfquery>

