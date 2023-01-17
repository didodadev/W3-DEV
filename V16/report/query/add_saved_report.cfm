 <cfsavecontent variable = "content">
	 <cfoutput>#attributes.count#</cfoutput>
 </cfsavecontent>
 <cfset file_name = "#createuuid()#.cfm">
 <cfset upload_folder = "#upload_folder#report#dir_seperator#saved#dir_seperator#">
 <cffile action = "write"  file="#upload_folder##file_name#" output="#trim(content)#" charset="utf-8" mode="777">
<cfquery name="add_saved_report" datasource="#dsn#">
	INSERT INTO SAVED_REPORTS
		(
		REPORT_ID,
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
		#FORM.REPORT_ID#,
		'#FORM.REPORT_NAME#',
		'#FORM.REPORT_DETAIL#',
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
<script type="text/javascript">
	alert("<cf_get_lang no ='1807.Raporunuz Kaydedildi'>");
	closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	location.reload();
</script>