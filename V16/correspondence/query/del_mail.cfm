<cfif attributes.mail_id neq 'all'>
	<cfquery name="GET_MAIL_FILE" datasource="#DSN#">
		SELECT 
			*
		FROM
			MAILS   
		WHERE
			MAIL_ID	= #attributes.mail_id#
	</cfquery>
	<cfif get_mail_file.is_death eq 1> 
		<!--- Erase mail content file--->
		<cfif (attributes.type eq 2) and FileExists("#upload_folder#mails#dir_seperator#in#dir_seperator##get_mail_file.content_file#")>
			<cf_del_server_file output_file="mails/in/#get_mail_file.content_file#" output_server="#get_mail_file.content_file_server_id#">
		<cfelseif (attributes.type eq 2) and FileExists("#upload_folder#mails#dir_seperator#out#dir_seperator##get_mail_file.content_fil#")>   
		   	<cf_del_server_file output_file="mails/out/#get_mail_file.content_file#" output_server="#get_mail_file.content_file_server_id#">
		<cfelseif (attributes.type eq 2) and FileExists("#upload_folder#mails#dir_seperator#draft#dir_seperator##get_mail_file.content_fil#")>   
		   	<cf_del_server_file output_file="mails/draft/#get_mail_file.content_file#" output_server="#get_mail_file.content_file_server_id#">		   
		</cfif>
		<!--- Erase attachment files--->
		<cfquery name="GET_MAIL_ATTACHMENT" datasource="#DSN#">
		SELECT     
			ATTACHMENT_FILE,
			ATTACH_SERVER_ID
		FROM
			MAILS_ATTACHMENT
		WHERE
		    (MAIL_ID = #attributes.mail_id#) AND 
			ATTACHMENT_FILE NOT IN(SELECT ATTACHMENT_FILE FROM MAILS_ATTACHMENT WHERE MAIL_ID NOT IN (#attributes.mail_id#))
		</cfquery>
		<cfif get_mail_attachment.recordcount>
		<cfloop query="GET_MAIL_ATTACHMENT" startrow="1">
			<cfif (attributes.type eq 2) and FileExists("#upload_folder#mails#dir_seperator#in#dir_seperator#attachments#dir_seperator##get_mail_attachment.attachment_file#")>
			   <cf_del_server_file output_file="mails/in/attachments/#get_mail_attachment.attachment_file#" output_server="#get_mail_attachment.attach_server_id#">
			<cfelseif (attributes.type eq 2) and FileExists("#upload_folder#mails#dir_seperator#out#dir_seperator#attachments#dir_seperator##get_mail_attachment.attachment_file#")>   
			   <cf_del_server_file output_file="mails/out/attachments/#get_mail_attachment.attachment_file#" output_server="#get_mail_attachment.attach_server_id#">
			<cfelseif (attributes.type eq 2) and FileExists("#upload_folder#mails#dir_seperator#draft#dir_seperator#attachments#dir_seperator##get_mail_attachment.attachment_file#")>   
			   <cf_del_server_file output_file="mails/draft/attachments/#get_mail_attachment.attachment_file#" output_server="#get_mail_attachment.attach_server_id#">
			</cfif>
		</cfloop>
		</cfif>
	</cfif>
	<cfquery name="DEL_MAIL" datasource="#DSN#">
		<cfif get_mail_file.is_death eq 1>
			DELETE FROM
				MAILS
			WHERE
				MAIL_ID	= #attributes.mail_id#
		<cfelse>
			UPDATE
				MAILS
			SET
				IS_DEATH = 1
			WHERE 
				MAIL_ID	= #attributes.mail_id#  			
		</cfif>		  
	</cfquery>
	<cfif get_mail_file.is_death eq 1>
		<cfquery name="DEL_MAIL_ATTACHMENT" datasource="#DSN#">
			DELETE FROM
				MAILS_ATTACHMENT
			WHERE
				MAIL_ID	= #attributes.mail_id#
		</cfquery>
	</cfif>		  
    <cfquery name="DEL_RELATION" datasource="#DSN#">
    	DELETE FROM MAILS_RELATION WHERE MAIL_ID = #attributes.mail_id#
    </cfquery>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<cfquery name="GET_MAIL_FILE" datasource="#DSN#">
		SELECT 
			*
		FROM
			MAILS   
		WHERE
			MAIL_ID	IN (#attributes.ids#)
	</cfquery>
	<cfoutput query="GET_MAIL_FILE">
		<cfif is_death eq 1> 
			<!--- Erase mail content file--->
			<cfif (attributes.type eq 2) and FileExists("#upload_folder#mails#dir_seperator#in#dir_seperator##content_file#")>
			   <cf_del_server_file output_file="mails/in/#content_file#" output_server="#content_file_server_id#">
			<cfelseif (attributes.type eq 2) and FileExists("#upload_folder#mails#dir_seperator#out#dir_seperator##content_file#")>   
			   <cf_del_server_file output_file="mails/out/#content_file#" output_server="#content_file_server_id#">
			<cfelseif (attributes.type eq 2) and FileExists("#upload_folder#mails#dir_seperator#draft#dir_seperator##content_file#")>   
			   <cf_del_server_file output_file="mails/draft/#content_file#" output_server="#content_file_server_id#">			   
			</cfif>
			<!--- Erase attachment files--->
			<cfquery name="GET_MAIL_ATTACHMENT" datasource="#DSN#">
		 	SELECT
				ATTACHMENT_FILE,
				ATTACH_SERVER_ID
			FROM
				MAILS_ATTACHMENT
			WHERE
				MAIL_ID	IN (#attributes.ids#) AND 
				ATTACHMENT_FILE NOT IN(SELECT ATTACHMENT_FILE FROM MAILS_ATTACHMENT WHERE MAIL_ID NOT IN (#attributes.ids#))
			</cfquery>
			<cfif get_mail_attachment.recordcount gt 0>
			<cfloop query="GET_MAIL_ATTACHMENT" startrow="1">
				<cfif (attributes.type eq 2) and FileExists("#upload_folder#mails#dir_seperator#in#dir_seperator#attachments#dir_seperator##get_mail_attachment.attachment_file#")>
				   <cf_del_server_file output_file="mails/in/attachments/#get_mail_attachment.attachment_file#" output_server="#get_mail_attachment.attach_server_id#">
				<cfelseif (attributes.type eq 2) and FileExists("#upload_folder#mails#dir_seperator#out#dir_seperator#attachments#dir_seperator##get_mail_attachment.attachment_file#")>   
				   <cf_del_server_file output_file="mails/out/attachments/#get_mail_attachment.attachment_file#" output_server="#get_mail_attachment.attach_server_id#">
				<cfelseif (attributes.type eq 2) and FileExists("#upload_folder#mails#dir_seperator#draft#dir_seperator#attachments#dir_seperator##get_mail_attachment.attachment_file#")>   
				   <cf_del_server_file output_file="mails/draft/attachments/#get_mail_attachment.attachment_file#" output_server="#get_mail_attachment.attach_server_id#">				   
				</cfif>
			</cfloop>
			</cfif>
		</cfif>
		<cfquery name="DEL_MAIL" datasource="#DSN#">
			<cfif is_death eq 1>
				DELETE FROM
					MAILS
				WHERE
					MAIL_ID	= #MAIL_ID#
			<cfelse>
				UPDATE
					MAILS
				SET
					IS_DEATH = 1
				WHERE 
					MAIL_ID	= #MAIL_ID#  			
			</cfif>		  
		</cfquery>
		
		<cfif get_mail_file.is_death eq 1>
			<cfquery name="DEL_MAIL_ATTACHMENT" datasource="#DSN#">
				DELETE FROM
					MAILS_ATTACHMENT
				WHERE
					MAIL_ID	= #MAIL_ID#
			</cfquery>
		</cfif>		  
	</cfoutput>
    <cfquery name="DEL_RELATION" datasource="#DSN#">
    	DELETE FROM MAILS_RELATION WHERE MAIL_ID IN (#attributes.ids#)
    </cfquery>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>	
</cfif>
