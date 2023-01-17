<cfsetting showdebugoutput="no">
<cfquery name="EMP_MAIL_LIST" datasource="#DSN#" maxrows="10">
	SELECT 
		* 
	FROM 
		CUBE_MAIL 
	WHERE 
		EMPLOYEE_ID = #session.ep.userid#
</cfquery>

<cfif isdefined("attributes.mail_ids_list") and listlen(attributes.mail_ids_list)>
	<cfset attributes.mail_ids_list = listsort(attributes.mail_ids_list,"numeric")>
	<cfquery name="add_" datasource="#dsn#">
		UPDATE MAILS SET IS_READ = #attributes.read_type# WHERE MAIL_ID IN (#attributes.mail_ids_list#)
	</cfquery>
</cfif>
<script type="text/javascript">
	list_mail(<cfoutput>#attributes.folder_id#</cfoutput>);
</script>

<cfquery name="get_mail_counts" datasource="#dsn#">
	SELECT MAIL_ID,FOLDER_ID,IS_READ FROM MAILS WHERE MAILBOX_ID IN (#valuelist(EMP_MAIL_LIST.MAILBOX_ID)#)
</cfquery>

<cfquery name="get_mail_old_count" dbtype="query">
	SELECT MAIL_ID FROM get_mail_counts WHERE FOLDER_ID = #attributes.FOLDER_ID#
</cfquery>
<cfquery name="get_mail_old_count_read" dbtype="query">
	SELECT MAIL_ID FROM get_mail_counts WHERE FOLDER_ID = #attributes.FOLDER_ID# AND (IS_READ = 0 OR IS_READ IS NULL)
</cfquery>
<cfoutput>
	<script type="text/javascript">
		<cfif attributes.FOLDER_ID lt 0>
			document.getElementById("static_#-1*attributes.folder_id#").innerHTML = '(#get_mail_old_count_read.recordcount#/#get_mail_old_count.recordcount#)';
		<cfelse>
			document.getElementById("dynamic_#attributes.folder_id#").innerHTML = '(#get_mail_old_count_read.recordcount#/#get_mail_old_count.recordcount#)';
		</cfif>
	</script>
</cfoutput>
