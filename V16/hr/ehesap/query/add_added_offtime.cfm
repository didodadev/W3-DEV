<cf_get_lang_set module_name="ehesap">
<cf_date tarih="attributes.startdate">
<cfset attributes.startdate = date_add("h", 0-session.ep.time_zone, attributes.startdate)>
<cfset attributes.startdate = date_add("n", 0, attributes.startdate)>
<cf_date tarih="attributes.finishdate">
<cfset attributes.finishdate = date_add("h", 0-session.ep.time_zone, attributes.finishdate)>
<cfset attributes.finishdate = date_add("n", 0, attributes.finishdate)>

<CFTRANSACTION>
	<cfquery name="add_offtime" datasource="#dsn#">
		INSERT INTO
			OFFTIME
			(
			RECORD_IP,
			RECORD_EMP,
			RECORD_DATE,
			IS_PUANTAJ_OFF,
			EMPLOYEE_ID,
			OFFTIMECAT_ID,
			STARTDATE,
			FINISHDATE,
			TOTAL_HOURS,
			VALIDATOR_POSITION_CODE
			)
		VALUES
			(
			'#CGI.REMOTE_ADDR#',
			#SESSION.EP.USERID#,
			#NOW()#,
			0,
			#EMPLOYEE_ID#,
			#OFFTIMECAT_ID#,
			#attributes.startdate#,
			#attributes.finishdate#,
			0,
			#VALIDATOR_POSITION_CODE#
			)
	</cfquery>
	
	<cfquery name="LAST_ID" datasource="#DSN#">
		SELECT MAX(OFFTIME_ID) AS LATEST_RECORD_ID FROM OFFTIME
	</cfquery>
	
</CFTRANSACTION>

<cfquery name="upd_" datasource="#dsn#">
	UPDATE
		OFFTIME
	SET
		IS_ADDED_OFFTIME = 1,
		ADDED_OFFTIME_ID = #LAST_ID.LATEST_RECORD_ID#,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		OFFTIME_ID IN (#attributes.izin_ids#)
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
