<cfset company_message = '<br/>
	Bu mesajda, yalnızca  muhatabını ilgilendiren, kişiye veya kuruma özel bilgiler yer alıyor olabilir.<br/>
	Mesajın muhatabı  degilseniz, içeriğini ve varsa ekindeki dosyaları kimseye aktarmayınız ya da kopyalamayınız.<br/>
	Böyle bir durumda lütfen göndereni uyarip, mesajı imha ediniz. Gostermiş olduğunuz hassasiyetten dolayı teşekkür ederiz.<br/><br/>

	This e-mail may contain confidential and/or privileged information.<br/>
	If you are not the intended recipient (or have received this e-mail in error) please notify the sender immediately and destroy this e-mail.<br/>
	Any unauthorised copying, disclosure or distribution of the material in this e-mail is strictly forbidden.<br/>
	Thank you for your co-operation.<br/>'>
<!--- 
	attributes.type :1 gelen mail
	attributes.type :0 giden mail
	attributes.type :3 taslak 
--->
<cfparam name="attributes.attachment_s_codes" default="">
<cfset file_name = "#createUUID()#.eml">
<cfif not isdefined("wrk_id")>
	<cfif isdefined('session.ep.userid')>
		<cfset wrk_id = 'mail' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
	<cfelseif isdefined('session.pp.userid')>
		<cfset wrk_id = 'mail' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.pp.userid#_'&round(rand()*100)>
	</cfif>
</cfif>
<cfif not isdefined("attributes.mailbox_id")>
	<cfquery name="GET_EMPLOYEE_" datasource="#DSN#">
		SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	</cfquery>
	<cfquery name="control_" datasource="#dsn#">
		SELECT * FROM CUBE_MAIL WHERE EMPLOYEE_ID = #session.ep.userid#
	</cfquery>
	<cfif control_.recordcount>
		<cfquery name="control2_" dbtype="query" maxrows="1">
			SELECT MAILBOX_ID FROM control_ WHERE EMAIL = '#get_employee_.EMPLOYEE_EMAIL#'
		</cfquery>
		<cfif control2_.recordcount>
			<cfset attributes.mailbox_id = control2_.MAILBOX_ID>
		<cfelse>
			<cfset attributes.mailbox_id = control_.MAILBOX_ID>
		</cfif>
	<cfelse>
		<cfif DirectoryExists("#emp_mail_path##session.ep.userid#")>
		<cfelse>
			<cfdirectory action="create" name="as" directory="#emp_mail_path##session.ep.userid#">
			<cfdirectory action="create" name="as_in" directory="#emp_mail_path##session.ep.userid#\inbox">
			<cfdirectory action="create" name="as_out" directory="#emp_mail_path##session.ep.userid#\sendbox">
			<cfdirectory action="create" name="as_draft" directory="#emp_mail_path##session.ep.userid#\draft">
			<cfdirectory action="create" name="as_delete" directory="#emp_mail_path##session.ep.userid#\deleted">
			<cfdirectory action="create" name="as_ina" directory="#emp_mail_path##session.ep.userid#\inbox\attachments">
			<cfdirectory action="create" name="as_outa" directory="#emp_mail_path##session.ep.userid#\sendbox\attachments">
			<cfdirectory action="create" name="as_drafta" directory="#emp_mail_path##session.ep.userid#\draft\attachments">
			<cfdirectory action="create" name="as_deletea" directory="#emp_mail_path##session.ep.userid#\deleted\attachments">
		</cfif>
		<cfset mail_path = '#emp_mail_path##session.ep.userid#'>
			<cfquery name="ADD_EMP_MAIL" datasource="#DSN#" result="result">  
			  INSERT INTO
				CUBE_MAIL
				  (
				  EMPLOYEE_ID,
				  EMAIL,
				  ACCOUNT,
				  PASSWORD,
				  POP,
				  ISACTIVE,
				  SMTP,
				  MAIL_PATH
				  )
				 VALUES
				  (
				  #session.ep.userid#,
				  '#get_employee_.EMPLOYEE_EMAIL#',
				  '#get_employee_.EMPLOYEE_EMAIL#',
				  '',
				  '',
				  1,
				  '',
				   '#mail_path#'
				  )
			</cfquery>
			<cfset attributes.mailbox_id = result.IDENTITYCOL>
	</cfif>
</cfif>
<cfif (isdefined("attributes.body") and (isdefined("SELECT_MAIL.CONTENT_FILE") and not len(SELECT_MAIL.CONTENT_FILE))) or (isdefined("attributes.body") and not isdefined("SELECT_MAIL"))>
	<cfif not DirectoryExists("#emp_mail_path##session.ep.userid##dir_seperator#sendbox")><cfdirectory action="create" directory="#emp_mail_path##session.ep.userid#\sendbox"></cfif>
	<cfif not DirectoryExists("#emp_mail_path##session.ep.userid##dir_seperator#draft")><cfdirectory action="create" directory="#emp_mail_path##session.ep.userid#\draft"></cfif>
	<cfif not DirectoryExists("#emp_mail_path##session.ep.userid##dir_seperator#inbox")><cfdirectory action="create" directory="#emp_mail_path##session.ep.userid#\inbox"></cfif>
	<cfif attributes.type eq 0>
        <cffile action="write" file="#emp_mail_path##session.ep.userid##dir_seperator#sendbox#dir_seperator##file_name#" output="#attributes.body##CHR(13)##company_message#" charset ="UTF-8">
    <cfelseif attributes.type eq 3>
        <cffile action="write" file="#emp_mail_path##session.ep.userid##dir_seperator#draft#dir_seperator##file_name#" output="#attributes.body##CHR(13)##company_message#" charset ="UTF-8">	
    <cfelseif attributes.type eq 1> 
        <cffile action="write" file="#emp_mail_path##session.ep.userid##dir_seperator#inbox#dir_seperator##file_name#" output="#attributes.body#" charset="UTF-8">
    </cfif>
</cfif>
<cfset sayac=0>

<cfif isdefined("attributes.is_upd")>
	<cfif isdefined("SELECT_MAIL.CONTENT_FILE") and not len(SELECT_MAIL.CONTENT_FILE)>
        <cfquery name="UPD_MAIL" datasource="#DSN#">
            UPDATE MAILS 
            SET
                CONTENT_FILE = '#file_name#',
                CONTENT_FILE_SERVER_ID = #fusebox.server_machine#
            WHERE 
                UID = '#attributes.uid#'   
        </cfquery>
    </cfif>
    <cfset max_mail_id =attributes.mail_id>
<cfelse>
    <cfquery name="ADD_MAIL" datasource="#DSN#" result="myresult">
        INSERT INTO 
            MAILS
        (
            WRK_ID,
            MAILBOX_ID,
            FOLDER_ID,
            SUBJECT,
            DETAIL,
            SENDER,
            CONTENT_FILE,
            CONTENT_FILE_SERVER_ID,
            MAIL_MODULE,
            MAIL_FROM,
            MAIL_TO,
            MAIL_CC,	
            RECORD_DATE,
            REAL_DATE,
            IS_READ,
            UID
        )
        VALUES
        (
            '#wrk_id#',
            <cfif isdefined("attributes.mailbox_id")>#attributes.mailbox_id#<cfelse>NULL</cfif>,
            <cfif attributes.type eq 0>-3,<cfelseif attributes.type eq 3>-1,<cfelse>-4,</cfif><!--- degistirilmeyecek --->
            '#attributes.subject#',
            <cfif isdefined("attributes.mail_detail") and len(attributes.mail_detail)>'#attributes.mail_detail#'<cfelse>NULL</cfif>,
            <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
                #session.ep.userid#,
            <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
                #session.pp.userid#,     	
            <cfelse>
                NULL,
            </cfif>
            <cfif isdefined("attributes.body")>'#file_name#'<cfelse>NULL</cfif>,
            #fusebox.server_machine#,
            <cfif isDefined("attributes.module")>	
            '#attributes.module#',
            <cfelse>
            '',	 
            </cfif>
            <cfif isDefined("attributes.from")>'#attributes.from#',<cfelseif isdefined("sender")>'#sender#',<cfelseif isdefined("session.ep.company_email")>'#session.ep.company_email#',<cfelse>NULL,</cfif>
            <cfif isDefined("attributes.to_list") and len(attributes.to_list) lte 500>'#trim(attributes.to_list)#',<cfelseif isdefined("attributes.emp_name")>'#attributes.emp_name#',<cfelseif isdefined("attributes.to")>'#attributes.to#',<cfelseif isdefined("attributes.to_id")>'#attributes.to_id#',<cfelseif isdefined("attributes.to_")>'#attributes.to_#',<cfelse>NULL,</cfif>
            <cfif isDefined("attributes.cc_list") and len(attributes.cc_list) lte 500>'#trim(attributes.cc_list)#',<cfelseif isdefined("attributes.emp_name_cc")>'#attributes.emp_name_cc#',<cfelse>NULL,</cfif>
            #now()#,
            <cfif isdefined("attributes.date")>#attributes.date#,<cfelse>#now()#,</cfif>
            <cfif attributes.type eq 0 or attributes.type eq 3>1<cfelse>0</cfif>,
            <cfif isdefined("attributes.uid") and len(attributes.uid)>'#attributes.uid#'<cfelse>NULL</cfif>
        )
    </cfquery>
    <cfset max_mail_id = myresult.identitycol>
</cfif>


<cfif isdefined("attributes.uid") and len(attributes.uid)>
<cfquery name="ADD_MAIL_FAKE" datasource="#DSN#">
	INSERT INTO 
		MAILS_FAKE
	(
		MAILBOX_ID,
		UID
	)
	VALUES
	(
		<cfif isdefined("attributes.mailbox_id")>#attributes.mailbox_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.uid") and len(attributes.uid)>'#attributes.uid#'<cfelse>NULL</cfif>
	)
</cfquery>
</cfif>

<!--Mail gönderirken-->
<cfif isdefined("attributes.attachment_count") and attributes.attachment_count gt 0>
	<cfloop from="0" to="#attributes.attachment_count#" index="sayac">
		<cfif isdefined('this_dosya_#sayac#') and len(Evaluate('this_dosya_#sayac#'))>
			<cfset a = evaluate("this_dosya_#sayac#")>
			<cfset a_name=evaluate("attributes.file_name#sayac#")>
			<cfquery name="add_att1" datasource="#DSN#">
				INSERT INTO 
					MAILS_ATTACHMENT
				(
					WRK_ID,
					MAIL_ID,
					ATTACHMENT_FILE,
					ATTACHMENT_NAME,
					ATTACH_SERVER_ID,
					SPECIAL_CODE
				)
				VALUES
				(
					'#wrk_id#',
					#max_mail_id#,
					'#a_name#',
					'#a_name#',
					2,
					<cfif len(attributes.attachment_s_codes) and listlen(attributes.attachment_s_codes,'&')>
						<cfif listlen(attributes.attachment_s_codes,'&') gte sayac>
							<cfif listlast(listgetat(attributes.attachment_s_codes,sayac,"&"),"=") is 'null'>NULL<cfelse>'#listlast(listgetat(attributes.attachment_s_codes,sayac,"&"),"=")#'</cfif> 
						<cfelse>
							NULL
						</cfif>
					<cfelse>
						NULL
					</cfif>
				)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<!--
	ATTACH_SERVER_ID
    gönderirken 2
    alırken 3
    ilet 4
    genel mail kuralları receive 1
    genel mail kuralları mail_control 5
    genel mail kuralları send mail 6


-->
<!-- mail alınırken-->
<cfif IsDefined('attributes.attachment_files') and len(attributes.attachment_files) and attributes.type eq 1>
	<cfset count_ = 0>
    <cfquery name="control_attc" datasource="#dsn#">
        SELECT ATTACHMENT_ID FROM MAILS_ATTACHMENT WHERE MAIL_ID = #max_mail_id# AND WRK_ID = '#wrk_id#'
    </cfquery>
    <cfif not control_attc.recordcount>
	<cfloop list="#attributes.attachment_files#" index="i" delimiters="*">
	<cfset count_ = count_ + 1>
        <cfset file_ = listlast(i,'\')>
        <cfif isdefined("attributes.attachment") and len(attributes.attachment) and (count_ lte listlen(attributes.attachment,'*'))>
        	<cfset attachment_ = listgetat(attributes.attachment,count_,'*')>
        <cfelse>
        	<cfset attachment_ = file_>
        </cfif>
      <!---  <cfquery name="control_attc" datasource="#dsn#">
            SELECT ATTACHMENT_ID FROM MAILS_ATTACHMENT WHERE MAIL_ID = #max_mail_id# AND ATTACHMENT_FILE = '#file_#'
        </cfquery>--->
<!---        <cfif not control_attc.recordcount>
--->            <cfquery name="add_att3" datasource="#DSN#">
                INSERT INTO 
                    MAILS_ATTACHMENT
                (
                    WRK_ID,
                    MAIL_ID,
                    ATTACHMENT_FILE,
                    ATTACHMENT_NAME,
                    ATTACH_SERVER_ID,
                    SPECIAL_CODE
                )
                VALUES
                (
                    '#wrk_id#',
                    #max_mail_id#,
                    '#file_#',
                    '#attachment_#',
                   3,
                    <cfif len(attributes.attachment_s_codes) and listlen(attributes.attachment_s_codes,'&')>
                        <cfif listlen(attributes.attachment_s_codes,'&') gte count_>
                            <cfif listlast(listgetat(attributes.attachment_s_codes,count_,"&"),"=") is 'null'>NULL<cfelse>'#listlast(listgetat(attributes.attachment_s_codes,count_,"&"),"=")#'</cfif> 
                        <cfelse>
                            NULL
                        </cfif>
                    <cfelse>
                        NULL
                    </cfif>
                )
            </cfquery>
       <!--- </cfif>--->
	</cfloop>
    </cfif>
<cfelse>
	<!-- old attachmentları ekliyor iletmeler gönderirken !!-->
	<cfparam name="attributes.old_attachment" default="">
	<cfparam name="attributes.old_attachment_name" default="">
	<cfloop from="1" to="#ListLen(attributes.old_attachment,',')#" index="i">
		<cfquery name="get_attachment_name" datasource="#DSN#">
			SELECT 
				ATTACHMENT_NAME
			FROM
				MAILS_ATTACHMENT
			WHERE 
				ATTACHMENT_FILE = '#ListGetAt(attributes.old_attachment , i ,',')#'
		</cfquery>
		<cfquery name="add_att2" datasource="#DSN#">
			INSERT INTO 
				MAILS_ATTACHMENT
			(
				WRK_ID,
				MAIL_ID,
				ATTACHMENT_FILE,
				ATTACHMENT_NAME,
				ATTACH_SERVER_ID,
				SPECIAL_CODE
			)
			VALUES
			(
				'#wrk_id#',
				#max_mail_id#,
				'#left(ListGetAt(attributes.old_attachment,i,','),250)#',
			<cfif get_attachment_name.recordcount gt 0 and len(#get_attachment_name.attachment_name#)>
				'#get_attachment_name.attachment_name#',
			<cfelseif len(attributes.old_attachment_name)>
				'#ListGetAt(attributes.old_attachment_name, i,',')#',
			<cfelse>
				NULL,
			</cfif>
			   4,
				<cfif len(attributes.attachment_s_codes) and listlen(attributes.attachment_s_codes,'&')>
					<cfif listlen(attributes.attachment_s_codes,'&') gte i>
						<cfif listlast(listgetat(attributes.attachment_s_codes,i,"&"),"=") is 'null'>NULL<cfelse>'#listlast(listgetat(attributes.attachment_s_codes,i,"&"),"=")#'</cfif>
					<cfelse>
						NULL
					</cfif>
				<cfelse>
					NULL
				</cfif>
			)
		</cfquery>
	</cfloop>
</cfif>
<!--- TYPE 0:EMP,1:CC,2:BCC  --->
<cfif isdefined("attributes.relation_list_emp") and len(attributes.relation_list_emp)>
	<cfloop list="#attributes.relation_list_emp#" index="cc">
		<cfstoredproc procedure="EMAIL_TYPE_CONTROL" datasource="#dsn#">
			<cfprocparam value="#cc#" cfsqltype="cf_sql_varchar">
			<cfprocresult name="result">
		</cfstoredproc>
		<cfif len(result.relation_type)>
			<cfquery name="ADD_RELATION" datasource="#dsn#">
				INSERT INTO 
					MAILS_RELATION
				(
					MAIL_ID,
					RELATION_TYPE,
					RELATION_TYPE_ID,
					TYPE
				)
				VALUES
				(
					#max_mail_id#,
					'#result.relation_type#',
					#result.relation_type_id#,
					0
				)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>

<cfif isdefined("attributes.relation_list_cc") and len(attributes.relation_list_cc)>
	<cfloop list="#attributes.relation_list_cc#" index="cc">
		<cfstoredproc procedure="EMAIL_TYPE_CONTROL" datasource="#dsn#">
			<cfprocparam value="#cc#" cfsqltype="cf_sql_varchar">
			<cfprocresult name="result">
		</cfstoredproc>
        <cfif result.recordcount>
            <cfquery name="ADD_RELATION" datasource="#dsn#">
                INSERT INTO 
                    MAILS_RELATION
                (
                    MAIL_ID,
                    RELATION_TYPE,
                    RELATION_TYPE_ID,
                    TYPE
                )
                VALUES
                (
                    #max_mail_id#,
                    '#result.relation_type#',
                    #result.relation_type_id#,
                    1
                )
            </cfquery>
        </cfif>
	</cfloop>
</cfif>

<cfif isdefined("attributes.relation_list_bcc") and len(attributes.relation_list_bcc)>
	<cfloop list="#attributes.relation_list_bcc#" index="cc">
		<cfstoredproc procedure="EMAIL_TYPE_CONTROL" datasource="#dsn#">
			<cfprocparam value="#cc#" cfsqltype="cf_sql_varchar">
			<cfprocresult name="result">
		</cfstoredproc>
        <cfif result.recordcount>
            <cfquery name="ADD_RELATION" datasource="#dsn#">
                INSERT INTO 
                    MAILS_RELATION
                (
                    MAIL_ID,
                    RELATION_TYPE,
                    RELATION_TYPE_ID,
                    TYPE
                )
                VALUES
                (
                    #max_mail_id#,
                    '#result.relation_type#',
                    #result.relation_type_id#,
                    2
                )
            </cfquery>
        </cfif>
	</cfloop>
</cfif>

<cfif isdefined("attributes.relation_type")>
    <cfquery name="control_relation" datasource="#dsn#">
        SELECT MAIL_ID FROM MAILS_RELATION WHERE RELATION_TYPE_ID = #attributes.relation_type_id# AND RELATION_TYPE = '#attributes.relation_type#'
    </cfquery>
    <cfif not control_relation.recordcount>
        <cfquery name="ADD_RELATION" datasource="#dsn#">
            INSERT INTO 
                MAILS_RELATION
            (
                MAIL_ID,
                RELATION_TYPE,
                RELATION_TYPE_ID
            )
            VALUES
            (
                #max_mail_id#,
                '#attributes.relation_type#',
                #attributes.relation_type_id#
            )
        </cfquery>
    </cfif>
</cfif>

