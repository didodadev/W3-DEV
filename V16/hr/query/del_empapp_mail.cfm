<cfquery name="del_empapp_mail" datasource="#dsn#">
  DELETE FROM EMPLOYEES_APP_MAILS WHERE EMP_APP_MAIL_ID = #URL.EMP_APP_MAIL_ID#
</cfquery>

<script type="text/javascript">
 location.href= document.referrer;
</script>
