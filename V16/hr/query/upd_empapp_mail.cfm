<cfquery name="UPD_EMPAPP_MAIL" datasource="#DSN#">
  UPDATE
     EMPLOYEES_APP_MAILS
  SET
   EMPAPP_ID = #attributes.empapp_id#,
   MAIL_HEAD = '#header#',
   EMPAPP_MAIL = '#EMPLOYEE_EMAIL#',
   CATEGORY = <cfif len(CORRCAT)>#CORRCAT#<cfelse>NULL</cfif>,
   MAIL_CONTENT = <cfif len(content)>'#content#'<cfelse>NULL</cfif>,
   UPDATE_DATE = #now()#,	
   UPDATE_IP = '#cgi.REMOTE_ADDR#',
   UPDATE_EMP = #session.ep.userid#
 WHERE
   EMP_APP_MAIL_ID = #attributes.EMP_APP_MAIL_ID#
</cfquery>

<script type="text/javascript">
 location.href= document.referrer;
</script>
