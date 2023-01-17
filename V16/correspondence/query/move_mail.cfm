<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.mail_ids_list")>
<cfset attributes.mail_ids_list = listsort(attributes.mail_ids_list,"numeric")>
	<cfquery name="add_" datasource="#dsn#">
		UPDATE MAILS SET FOLDER_ID = #attributes.new_folder_id# WHERE MAIL_ID IN (#attributes.mail_ids_list#)
	</cfquery>
</cfif>
<cfquery name="get_mails" datasource="#dsn#">
    SELECT * FROM MAILS WHERE MAIL_ID IN (#attributes.mail_ids_list#)
</cfquery>
<cfif attributes.folder_id lt 0 or attributes.new_folder_id lt 0>
	<cfset is_file_move = 0>
	<cfif attributes.new_folder_id eq -2>
		<cfset new_folder = "deleted">
	<cfelseif attributes.new_folder_id eq -1>
		<cfset new_folder = "draft">
	<cfelseif attributes.new_folder_id eq -3>
		<cfset new_folder = "sendbox">
	<cfelse>
		<cfset new_folder = "inbox">
	</cfif>
	<cfif attributes.folder_id eq -4 and attributes.new_folder_id lt 0>
		<cfset is_file_move = 1>
		<cfset old_folder = "inbox">
	<cfelseif attributes.folder_id lt 0>
		<cfset is_file_move = 1>
			<cfif attributes.folder_id eq -2>
				<cfset old_folder = "deleted">
			<cfelseif attributes.folder_id eq -1>
				<cfset old_folder = "draft">
			<cfelseif attributes.folder_id eq -3>
				<cfset old_folder = "sendbox">
			<cfelse>
				<cfset old_folder = "inbox">
			</cfif>
	<cfelseif attributes.folder_id gt 0 and attributes.new_folder_id lt 0 and attributes.new_folder_id neq -4>
		<cfset is_file_move = 1>
		<cfset old_folder = "inbox">	
	</cfif>
	
	<cfif is_file_move eq 1>
    	<cftry>
			<cfoutput query="get_mails">
                <cfif FileExists("#emp_mail_path##session.ep.userid##dir_seperator##old_folder##dir_seperator##CONTENT_FILE#")>
                    <cffile action="move" source="#emp_mail_path##session.ep.userid##dir_seperator##old_folder##dir_seperator##CONTENT_FILE#" destination="#emp_mail_path##session.ep.userid##dir_seperator##new_folder##dir_seperator#">
                </cfif>
            </cfoutput>
            <cfquery name="get_attaches" datasource="#dsn#">
                SELECT * FROM MAILS_ATTACHMENT WHERE MAIL_ID IN (#attributes.mail_ids_list#)
            </cfquery>
            <cfif old_folder is 'sendbox'>
				<cfoutput query="get_attaches">
                    <cfif FileExists("#emp_mail_path##session.ep.userid##dir_seperator##old_folder##dir_seperator#attachments#dir_seperator##get_mails.wrk_id##dir_seperator##ATTACHMENT_FILE#")>
                        <cffile action="move" source="#emp_mail_path##session.ep.userid##dir_seperator##old_folder##dir_seperator#attachments#dir_seperator##get_mails.wrk_id##dir_seperator##ATTACHMENT_FILE#" destination="#emp_mail_path##session.ep.userid##dir_seperator##new_folder##dir_seperator#attachments#dir_seperator#">
                    </cfif>
                </cfoutput>
			<cfelse>
				<cfoutput query="get_attaches">
                    <cfif FileExists("#emp_mail_path##session.ep.userid##dir_seperator##old_folder##dir_seperator#attachments#dir_seperator##ATTACHMENT_FILE#")>
                        <cffile action="move" source="#emp_mail_path##session.ep.userid##dir_seperator##old_folder##dir_seperator#attachments#dir_seperator##ATTACHMENT_FILE#" destination="#emp_mail_path##session.ep.userid##dir_seperator##new_folder##dir_seperator#attachments#dir_seperator#">
                    </cfif>
                </cfoutput>
            </cfif>
        <cfcatch>
        </cfcatch>
        </cftry>
	</cfif>	
</cfif>

<cfquery name="EMP_MAIL_LIST" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		CUBE_MAIL 
	WHERE 
		EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfquery name="get_mail_counts" datasource="#dsn#">
	SELECT MAIL_ID,FOLDER_ID,IS_READ FROM MAILS WHERE MAILBOX_ID IN (#valuelist(EMP_MAIL_LIST.MAILBOX_ID)#)
</cfquery>
<cfquery name="get_mail_old_count" dbtype="query">
	SELECT MAIL_ID FROM get_mail_counts WHERE FOLDER_ID = #attributes.FOLDER_ID#
</cfquery>
<cfquery name="get_mail_old_count_read" dbtype="query">
	SELECT MAIL_ID FROM get_mail_counts WHERE FOLDER_ID = #attributes.FOLDER_ID# AND (IS_READ = 0 OR IS_READ IS NULL)
</cfquery>
<cfquery name="get_mail_new_count" dbtype="query">
	SELECT MAIL_ID FROM get_mail_counts WHERE FOLDER_ID = #attributes.new_folder_id#
</cfquery>
<cfquery name="get_mail_new_count_read" dbtype="query">
	SELECT MAIL_ID FROM get_mail_counts WHERE FOLDER_ID = #attributes.new_folder_id# AND (IS_READ = 0 OR IS_READ IS NULL)
</cfquery>

<cfoutput>
	<script type="text/javascript">
		list_mail(#attributes.folder_id#);
		<cfif attributes.FOLDER_ID lt 0>
			document.getElementById("static_#-1*attributes.folder_id#").innerHTML = '(#get_mail_old_count_read.recordcount#/#get_mail_old_count.recordcount#)';
		<cfelse>
			document.getElementById("dynamic_#attributes.folder_id#").innerHTML = '(#get_mail_old_count_read.recordcount#/#get_mail_old_count.recordcount#)';
		</cfif>
		<cfif attributes.new_folder_id lt 0>
			document.getElementById("static_#-1*attributes.new_folder_id#").innerHTML = '(#get_mail_new_count_read.recordcount#/#get_mail_new_count.recordcount#)';
		<cfelse>
			document.getElementById("dynamic_#attributes.new_folder_id#").innerHTML = '(#get_mail_new_count_read.recordcount#/#get_mail_new_count.recordcount#)';
		</cfif>
	</script>
</cfoutput>
