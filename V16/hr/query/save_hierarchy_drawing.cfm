<script type="text/javascript">
  window.close();
</script>
<cfsetting showdebugoutput="no">
<cfsetting enablecfoutputonly="Yes">
<cfset file_name = "#createuuid()#.cfm">
<cfset upload_folder = "#upload_folder#report#dir_seperator#saved#dir_seperator#">
<cffile action = "write"  file="#upload_folder##file_name#" output="#trim(replace(ToString( ToBinary( ToBase64(form.draw_icerik) ) ),'<InvalidTag','<script','all'))#" charset="utf-8" mode="777">
<cfquery name="add_saved_report" datasource="#dsn#">
	INSERT INTO SAVED_REPORTS
		(
		REPORT_NAME,
		REPORT_DETAIL,
		FILE_NAME,
		FILE_SERVER_ID,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP,
		UPDATE_EMP,
		UPDATE_DATE,
		UPDATE_IP
		)
	VALUES
		(
		'#FORM.draw_name#',
		'#FORM.draw_detail#',
		'#file_name#',
		#fusebox.server_machine#,
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#',
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#'
		)
</cfquery>