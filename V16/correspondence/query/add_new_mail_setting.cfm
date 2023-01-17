<cfif Len(attributes.PASSWORD)>
	<cfset pass = Encrypt(attributes.PASSWORD,attributes.employee_id)>
<cfelse>	
	<cfset pass = "">
</cfif>
<cfset mail_path = '#emp_mail_path##attributes.employee_id#'>
<cfquery name="ADD_EMP_MAIL" datasource="#DSN#">  
  INSERT INTO
	CUBE_MAIL
	  (
	  EMPLOYEE_ID,
	  EMAIL,
	  ACCOUNT,
	  PASSWORD,
	  POP,
	  ISACTIVE,
	  PRESENT_ISACTIVE,
	  SMTP,
	  MAIL_PATH,
	  SMTP_PORT,
	  POP_PORT,
	  PRIORITY,
      TEMP_PRESENT_ISACTIVE
	  )
	 VALUES
	  (
	  #attributes.employee_id#,
	  '#attributes.EMAIL#',
	  '#attributes.ACCOUNT#',
	  '#pass#',
	  '#attributes.POP#',
	  <cfif isDefined("attributes.isactive")>1,<cfelse>0,</cfif>
	  <cfif isDefined("attributes.present_isactive")>1,<cfelse>0,</cfif>
	  '#attributes.SMTP#',
	   '#mail_path#',
	   <cfif len(attributes.smtp_port)>#attributes.smtp_port#,<cfelse>NULL,</cfif>
	   <cfif len(attributes.pop_port)>#attributes.pop_port#<cfelse>NULL</cfif>,
	  #attributes.priority#,
      <cfif isDefined("attributes.temp_present_isactive")>1<cfelse>0</cfif>
	  )
</cfquery>
<cfif not DirectoryExists("#emp_mail_path##SESSION.EP.USERID#")>
	<cfdirectory action="create" name="as" directory="#emp_mail_path##SESSION.EP.USERID#" recurse="yes">
	<cfdirectory action="create" name="as_in" directory="#emp_mail_path##SESSION.EP.USERID#\inbox" recurse="yes">
	<cfdirectory action="create" name="as_out" directory="#emp_mail_path##SESSION.EP.USERID#\sendbox" recurse="yes">
	<cfdirectory action="create" name="as_draft" directory="#emp_mail_path##SESSION.EP.USERID#\draft" recurse="yes">
	<cfdirectory action="create" name="as_delete" directory="#emp_mail_path##SESSION.EP.USERID#\deleted" recurse="yes">
	<cfdirectory action="create" name="as_ina" directory="#emp_mail_path##SESSION.EP.USERID#\inbox\attachments" recurse="yes">
	<cfdirectory action="create" name="as_outa" directory="#emp_mail_path##SESSION.EP.USERID#\sendbox\attachments" recurse="yes">
	<cfdirectory action="create" name="as_drafta" directory="#emp_mail_path##SESSION.EP.USERID#\draft\attachments" recurse="yes">
	<cfdirectory action="create" name="as_deletea" directory="#emp_mail_path##SESSION.EP.USERID#\deleted\attachments" recurse="yes">
</cfif>
<cflocation url="#request.self#?fuseaction=correspondence.list_mymails&employee_id=#attributes.employee_id#" addtoken="no">
