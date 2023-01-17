<cfsetting showdebugoutput="no">
<cfquery name="EMP_MAIL_LIST" datasource="#DSN#" maxrows="10">
	SELECT 
		* 
	FROM 
		CUBE_MAIL 
	WHERE 
		EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfif isdefined("attributes.relation_type")>
	<cfquery name="del_mail" datasource="#dsn#">
    	DELETE FROM MAILS_RELATION WHERE MAIL_ID = #attributes.mail_id# AND RELATION_TYPE = '#attributes.relation_type#' AND RELATION_TYPE_ID = #attributes.relation_type_id#
    </cfquery>
</cfif>
<cfif not isdefined("attributes.mail_ids_list") and isdefined("attributes.is_all_delete")>
	<cfquery name="get_all" datasource="#dsn#">
		SELECT MAIL_ID FROM MAILS WHERE MAILBOX_ID IN (#valuelist(EMP_MAIL_LIST.MAILBOX_ID)#) AND FOLDER_ID = #attributes.FOLDER_ID#
	</cfquery>
	<cfset attributes.mail_ids_list = valuelist(get_all.MAIL_ID)>
</cfif>

<cfif isdefined("attributes.mail_ids_list") and listlen(attributes.mail_ids_list)>
	<cfset attributes.mail_ids_list = listsort(attributes.mail_ids_list,"numeric")>
	<cfif attributes.folder_id eq -2><!--- silinmiş ogelerden mail silinir --->
			<cfquery name="get_mails" datasource="#dsn#">
				SELECT * FROM MAILS WHERE MAIL_ID IN (#attributes.mail_ids_list#)
			</cfquery>
			<cfoutput query="get_mails">
            	<!---<cfif EMP_MAIL_LIST.present_isactive eq 0 or not len(EMP_MAIL_LIST.present_isactive)><!---Sunucudan sil --->--->
                	<cfloop query="EMP_MAIL_LIST">
						<cfset password_ = Decrypt(EMP_MAIL_LIST.PASSWORD,session.ep.userid)>
                        <cfif len(EMP_MAIL_LIST.POP_PORT)>
							<cfset this_port_ = EMP_MAIL_LIST.POP_PORT>
                        <cfelse>
                            <cfset this_port_ = 110>
                        </cfif>
                        <cfset pop3 = EMP_MAIL_LIST.POP>
                        <cftry>
                            <cfpop name="inbox_3" 
                               action="delete"
                               server="#pop3#" 
                               username="#EMP_MAIL_LIST.account#" 
                               password="#password_#"
                               port="#this_port_#"
                               uid="#get_mails.uid#"> 
                           <cfcatch>
                           </cfcatch>
                        </cftry>
                       </cfloop>  	
   				<!---</cfif>--->
				<cfif FileExists("#emp_mail_path##session.ep.userid##dir_seperator#deleted#dir_seperator##CONTENT_FILE#")>
					<cffile action="delete" file="#emp_mail_path##session.ep.userid##dir_seperator#deleted#dir_seperator##CONTENT_FILE#">
				</cfif>
			</cfoutput>
			
			<cfquery name="get_attaches" datasource="#dsn#">
				SELECT * FROM MAILS_ATTACHMENT WHERE MAIL_ID IN (#attributes.mail_ids_list#)
			</cfquery>
			
			<cfoutput query="get_attaches">
				<cfif FileExists("#emp_mail_path##session.ep.userid##dir_seperator#deleted#dir_seperator#attachments#dir_seperator##ATTACHMENT_FILE#")>
					<cffile action="delete" file="#emp_mail_path##session.ep.userid##dir_seperator#deleted#dir_seperator#attachments#dir_seperator##ATTACHMENT_FILE#">
				</cfif>
			</cfoutput>
			
			<cfquery name="add_" datasource="#dsn#">
				DELETE FROM MAILS WHERE MAIL_ID IN (#attributes.mail_ids_list#)
			</cfquery>
			<cfquery name="add_" datasource="#dsn#">
				DELETE FROM MAILS_ATTACHMENT WHERE MAIL_ID IN (#attributes.mail_ids_list#)
			</cfquery>
	<cfelse>
			<cfquery name="get_mails" datasource="#dsn#">
				SELECT * FROM MAILS WHERE MAIL_ID IN (#attributes.mail_ids_list#)
			</cfquery>
	
			<cfif attributes.folder_id eq -1>
				<cfset folder_name_ = "draft">
			<cfelseif attributes.folder_id eq -3>
				<cfset folder_name_ = "sendbox">
			<cfelse>
				<cfset folder_name_ = "inbox">
			</cfif>
	
			<cfoutput query="get_mails">
				<cfif FileExists("#emp_mail_path##session.ep.userid##dir_seperator##folder_name_##dir_seperator##CONTENT_FILE#")>
					<cffile action="move" source="#emp_mail_path##session.ep.userid##dir_seperator##folder_name_##dir_seperator##CONTENT_FILE#" destination="#emp_mail_path##session.ep.userid##dir_seperator#deleted#dir_seperator#">
				</cfif>
			</cfoutput>
			
			<cfquery name="get_attaches" datasource="#dsn#">
				SELECT * FROM MAILS_ATTACHMENT WHERE MAIL_ID IN (#attributes.mail_ids_list#)
			</cfquery>
			
			<cfoutput query="get_attaches">
				<cfif FileExists("#emp_mail_path##session.ep.userid##dir_seperator##folder_name_##dir_seperator#attachments#dir_seperator##ATTACHMENT_FILE#")>
					<cffile action="move" source="#emp_mail_path##session.ep.userid##dir_seperator##folder_name_##dir_seperator#attachments#dir_seperator##ATTACHMENT_FILE#" destination="#emp_mail_path##session.ep.userid##dir_seperator#deleted#dir_seperator#attachments#dir_seperator#">
				</cfif>
			</cfoutput>
			
			<cfquery name="add_" datasource="#dsn#">
				UPDATE MAILS SET FOLDER_ID = -2 WHERE MAIL_ID IN (#attributes.mail_ids_list#)
			</cfquery>
	</cfif>
</cfif>
<cfif not isdefined("attributes.relation_type")>
	<script type="text/javascript">
	<cfif isdefined("attributes.is_single") and isdefined("attributes.next_mail_id") and attributes.next_mail_id neq 0>
		get_mail(<cfoutput>#attributes.next_mail_id#</cfoutput>,<cfoutput>#attributes.folder_id#</cfoutput>);
	<cfelse>
		list_mail(<cfoutput>#attributes.folder_id#</cfoutput>);
	</cfif>
      
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
    
    <cfquery name="get_mail_new_count" dbtype="query">
        SELECT MAIL_ID FROM get_mail_counts WHERE FOLDER_ID = -2
    </cfquery>
    <cfquery name="get_mail_new_count_read" dbtype="query">
        SELECT MAIL_ID FROM get_mail_counts WHERE FOLDER_ID = -2 AND (IS_READ = 0 OR IS_READ IS NULL)
    </cfquery>
</cfif>
<cfoutput>
	<script type="text/javascript">
		<cfif not isdefined("attributes.relation_type")>
			<cfif attributes.FOLDER_ID lt 0>
				document.getElementById("static_#-1*attributes.folder_id#").innerHTML = '(#get_mail_old_count_read.recordcount#/#get_mail_old_count.recordcount#)';
			<cfelse>
				document.getElementById("dynamic_#attributes.folder_id#").innerHTML = '(#get_mail_old_count_read.recordcount#/#get_mail_old_count.recordcount#)';
			</cfif>
				document.getElementById("static_2").innerHTML = '(#get_mail_new_count_read.recordcount#/#get_mail_new_count.recordcount#)';
			//	list_mail();
		</cfif>
	</script>
</cfoutput>
