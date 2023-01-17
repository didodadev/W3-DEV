<cfquery name="get_mail" datasource="#dsn#">
	SELECT TOP 1 MAIL_ID FROM MAILS WHERE MAILBOX_ID = #attributes.MAILBOX_ID#
</cfquery>
<cfif get_mail.recordcount>
	<script type="text/javascript">
		alert('Bu Mail Kutusunda Mail Bulunmaktadır\nMail Kutusunu Silemezsiniz!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfquery name="del_mail" datasource="#dsn#">
		DELETE FROM CUBE_MAIL WHERE MAILBOX_ID = #attributes.MAILBOX_ID#
	</cfquery>
	<cf_add_log  log_type="-1" action_id="#attributes.MAILBOX_ID#" action_name="Email Tanımı Silindi">
</cfif>
<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
