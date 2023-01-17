<cfquery name="SELECT_MAIL" datasource="#DSN#">
	SELECT
		MAILS.*,
		CUBE_MAIL.*
	FROM	   
		MAILS LEFT JOIN CUBE_MAIL
		ON
            CUBE_MAIL.MAILBOX_ID = MAILS.MAILBOX_ID
    WHERE
        CUBE_MAIL.EMPLOYEE_ID = #session.ep.USERID# AND
        CUBE_MAIL.ISACTIVE = 1 AND
		MAILS.MAIL_ID	= #attributes.mail_id#
</cfquery>
<cfquery name="MAIL_SETTINGS" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		CUBE_MAIL
	WHERE 
		EMPLOYEE_ID = #session.ep.USERID# AND
		ISACTIVE = 1
	ORDER BY
		PRIORITY ASC
</cfquery>
<cfset uid_ = SELECT_MAIL.uid>
<cfif isdefined("uid_") and len(uid_) and not len(SELECT_MAIL.content_file)>
    <cfoutput query="SELECT_MAIL">
        <cfset password_ = Decrypt(PASSWORD,session.ep.userid)>
    	<cfset attch_path_ = "#emp_mail_path##session.ep.userid##dir_seperator#inbox#dir_seperator#attachments\">
		<cfif len(POP_PORT)>
            <cfset this_port_ = POP_PORT>
        <cfelse>
            <cfset this_port_ = 110>
        </cfif>
        <cftry>
        <cfpop 
            name="inbox_2"
            action="getall"
            uid="#uid_#"
            port="#this_port_#"
            server="#POP#"
            username="#ACCOUNT#"
            maxrows="10"
            generateUniqueFilenames = "yes"
            attachmentpath="#attch_path_#"
            password="#password_#">
				<cfif len(inbox_2.AttachmentFiles)>
					<cfset attributes.attachment_files = listchangedelims(inbox_2.AttachmentFiles,'*','	')>
                <cfelse>
					<cfset attributes.attachment_files = "">
                </cfif>
                <cfif len(inbox_2.ATTACHMENTS)>
					<cfset attributes.attachment = listchangedelims(inbox_2.ATTACHMENTS,'*','	')>
                <cfelse>
					<cfset attributes.attachment = "">
                </cfif>
                <!---<cfif not len(attributes.attachment) and len(attributes.attachment_files)>
                	<cfset attributes.attachment = listlast(attributes.attachment_files,'\')>
                </cfif>--->
					<cfset attributes.uid = inbox_2.uid>
                    <cfset attributes.cids = inbox_2.cids>                        
					<cfscript>
						if(len(inbox_2.htmlBody))
							attributes.body = inbox_2.htmlBody;
						else
							attributes.body = inbox_2.Body;
						att = '';
						temp = '';
						attributes.type = 1;
						attributes.is_upd = 1;
						attributes.mail_id = attributes.mail_id;										
                    </cfscript>
                        <cftry>
							<cfset attributes.attachment_s_codes1 = structToList(attributes.cids)>
                            <cfset attributes.attachment_s_codes = ''>
                        <cfif len(attributes.attachment_s_codes1)>							
                            <cfloop list="#attributes.attachment#" index="name_" delimiters="*">
                                <cfloop list="#attributes.attachment_s_codes1#" index="ccm"  delimiters="&">
									<cfset deger_ = listfirst(ccm,'=')>
									<cfif deger_ is name_>
										<cfset attributes.attachment_s_codes = listappend(attributes.attachment_s_codes,ccm,'&')>
                                    </cfif>
                                </cfloop>
                            </cfloop>
                        </cfif>
                        <cfcatch>
                        	<cfset attributes.attachment_s_codes = ''>	
                        </cfcatch>
                        </cftry>
                        <cfinclude template="../../objects/query/add_mail.cfm">
                        <!--- Sunucudan sil--->
                        <cfif not len(present_isactive) or present_isactive eq 0>
                            <cfpop name="inbox_3" 
                                   action="delete"
                                   server="#POP#" 
                                   username="#account#" 
                                   password="#password_#"
                                   port="#this_port_#"
                                   uid="#attributes.uid#">
                        </cfif>
        <cfcatch type="any">
			<script type="text/javascript">
               alert('Mail Hesabı : <cfoutput>#ACCOUNT#</cfoutput>\nMail Alma İşleminde Bir Sorun Oluştu!');
            </script>
            <cfset error_ = 1>
        </cfcatch>
        </cftry>
    </cfoutput>
    </cfif>


<!---Genel Mail Kuralları --->
<cfif MAIL_SETTINGS.recordcount>
	<cfquery name="get_main_rules" datasource="#DSN#">
		SELECT * FROM CUBE_MAIL_MAIN_RULES WHERE TYPE = 0 AND RULE_NAME IN ('#replace(valuelist(MAIL_SETTINGS.EMAIL),",","','","all")#') AND ACTION IS NOT NULL
	</cfquery>	
	<cfif get_main_rules.recordcount>
		<cfquery name="get_mails_" datasource="#dsn#">
			SELECT * FROM MAILS WHERE MAIL_ID = #attributes.mail_id#
		</cfquery>
		<cfif get_mails_.recordcount and get_mails_.folder_id neq -3>
			<cfset aktarilacak_list = listdeleteduplicates(valuelist(get_main_rules.action))>
			<cfloop list="#aktarilacak_list#" index="ccm">
				<cfquery name="get_aktarim_settings" datasource="#DSN#">
					SELECT MAILBOX_ID,EMPLOYEE_ID FROM CUBE_MAIL WHERE EMAIL = '#ccm#'
				</cfquery>
				<cfif get_aktarim_settings.recordcount>
						<cfquery name="GET_MAIL_ATTACHMENTS" datasource="#dsn#">
							SELECT * FROM MAILS_ATTACHMENT WHERE MAIL_ID = #get_mails_.mail_id#
						</cfquery>
						<cfset max_mail_id = attributes.mail_id + 1>
						<cfif get_mails_.FOLDER_ID eq -3>
							<cfset folder = "sendbox">
						<cfelse>
							<cfset folder = "inbox">
						</cfif>
						<cfif len(get_mails_.CONTENT_FILE)><cffile action="copy" source="#emp_mail_path##session.ep.userid##dir_seperator##folder##dir_seperator##get_mails_.CONTENT_FILE#" destination="#emp_mail_path##get_aktarim_settings.employee_id##dir_seperator##folder#"></cfif>
						<cfif GET_MAIL_ATTACHMENTS.recordcount>
							<cfloop query="GET_MAIL_ATTACHMENTS">
							<cfquery name="add_attachments" datasource="#dsn#">
								INSERT INTO 
									MAILS_ATTACHMENT
								(
									MAIL_ID,
									ATTACHMENT_FILE,
									ATTACHMENT_NAME,
									ATTACH_SERVER_ID,
									WRK_ID,
									SPECIAL_CODE 
								)
								VALUES
								(
									#max_mail_id#,
									'#GET_MAIL_ATTACHMENTS.ATTACHMENT_FILE#',
									'#GET_MAIL_ATTACHMENTS.ATTACHMENT_NAME#',
									5,
									'#GET_MAIL_ATTACHMENTS.WRK_ID#',
									<cfif len(GET_MAIL_ATTACHMENTS.SPECIAL_CODE)>'#GET_MAIL_ATTACHMENTS.SPECIAL_CODE#'<cfelse>NULL</cfif>
								)
							</cfquery>
							<cffile action="copy" source="#emp_mail_path##session.ep.userid##dir_seperator##folder##dir_seperator#attachments#dir_seperator##GET_MAIL_ATTACHMENTS.ATTACHMENT_FILE#" destination="#emp_mail_path##get_aktarim_settings.employee_id##dir_seperator##folder##dir_seperator#attachments">
							</cfloop>
						</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
</cfif>

<cfset folder_ = "">
<cfif select_mail.folder_id eq -3>
	<cfset attributes.type = 0>
	<cfset attach_dir = "sendbox">
    <cfset folder_ = "#select_mail.wrk_id#/">
<cfelseif select_mail.folder_id eq -1>
	<cfset attributes.type = 3>
	<cfset attach_dir = "draft">
<cfelseif select_mail.folder_id eq -4>
	<cfset attributes.type = 1>
	<cfset attach_dir = "inbox">
<cfelseif select_mail.folder_id eq -2>
	<cfset attributes.type = 2>
	<cfset attach_dir = "deleted">
<cfelse>
	<cfset attributes.type = 1>
	<cfset attach_dir = "inbox">
</cfif>

<cfquery name="GET_MAIL_ATTACHMENT" datasource="#DSN#">
	SELECT
		*
	FROM	   
		MAILS_ATTACHMENT
	WHERE
		MAIL_ID	= #attributes.mail_id# AND (SPECIAL_CODE IS NULL OR SPECIAL_CODE = '' OR SPECIAL_CODE = 'null')
</cfquery>
<cfif GET_MAIL_ATTACHMENT.recordcount gt 0>
<cfparam name="attachments" default="">
<cfparam name="attachments_name" default="">
<cfoutput query="GET_MAIL_ATTACHMENT">
	<cfset attachments=listappend(attachments,GET_MAIL_ATTACHMENT.ATTACHMENT_FILE)>
	<cfset attachments_name=listappend(attachments_name,GET_MAIL_ATTACHMENT.ATTACHMENT_NAME)>
</cfoutput>
</cfif>
<cfscript>	
	 attach = '';
	 for(i = 1 ;i lte GET_MAIL_ATTACHMENT.recordcount; i = i +1)
	 {
		 if(len(ListGetAt(attachments_name , i ,',')) gt 15)
		 {
			 a=ListGetAt(attachments_name , i ,',');
			 isim=Left(a,10);
			 uzanti=Right(a,len(a)-(find('.',a)-1));
			 a=isim&'.'&uzanti;
		 }
		 else
		 {
			a=ListGetAt(attachments_name,i,',');
		 }
		
		file_ = ListGetAt(attachments,i,',');
		attach = "#attach#<a href=""javascript://"" class=""tableyazi"" onClick=""windowopen('/documents/emp_mails/#session.ep.userid#/#attach_dir#/attachments/#folder_##file_#','large')"">#a#</a>";
			if (i neq ListLen(attachments,',')){ attach = attach & ' - ';}
	 }	
</cfscript>
