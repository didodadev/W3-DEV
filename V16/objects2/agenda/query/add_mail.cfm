<cfset company_message = '<br/>
	Bu mesajda, yalnızca  muhatabını ilgilendiren, kişiye veya kuruma özel bilgiler yer alıyor olabilir.<br/>
	Mesajın muhatabı  degilseniz, içeriğini ve varsa ekindeki dosyaları kimseye aktarmayınız ya da kopyalamayınız.<br/>
	Böyle bir durumda lütfen göndereni uyarip, mesajı imha ediniz. Gostermiş olduğunuz hassasiyetten dolayı teşekkür ederiz.<br/><br/>

	This e-mail may contain confidential and/or privileged information.<br/>
	If you are not the intended recipient (or have received this e-mail in error) please notify the sender immediately and destroy this e-mail.<br/>
	Any unauthorised copying, disclosure or distribution of the material in this e-mail is strictly forbidden.<br/>
	Thank you for your co-operation.<br/>'>
<cfset file_name = "#createUUID()#.eml">

<cfif not isdefined("wrk_id")>
	<cfset wrk_id = 'mail' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session_base.userid#_'&round(rand()*100)>
</cfif>

<cfif not isdefined("attributes.mailbox_id")>
	<cfquery name="get_employee_" datasource="#dsn#">
		SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">
	</cfquery>
	<cfquery name="control_" datasource="#dsn#">
		SELECT MAILBOX_ID FROM CUBE_MAIL WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">
	</cfquery>
	<cfif control_.recordcount>
		<cfquery name="control2_" dbtype="query" maxrows="1">
			SELECT MAILBOX_ID FROM control_ WHERE EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_employee_.EMPLOYEE_EMAIL#">
		</cfquery>
		<cfif control2_.recordcount>
			<cfset attributes.mailbox_id = control2_.MAILBOX_ID>
		<cfelse>
			<cfset attributes.mailbox_id = control_.MAILBOX_ID>
		</cfif>
	<cfelse>
		<cfif DirectoryExists("#emp_mail_path##session_base.userid#")>
		<cfelse>
			<cfdirectory action="create" name="as" directory="#emp_mail_path##session_base.userid#" recurse="yes">
			<cfdirectory action="create" name="as_in" directory="#emp_mail_path##session_base.userid#\inbox" recurse="yes">
			<cfdirectory action="create" name="as_out" directory="#emp_mail_path##session_base.userid#\sendbox" recurse="yes">
			<cfdirectory action="create" name="as_draft" directory="#emp_mail_path##session_base.userid#\draft" recurse="yes">
			<cfdirectory action="create" name="as_delete" directory="#emp_mail_path##session_base.userid#\deleted" recurse="yes">
			<cfdirectory action="create" name="as_ina" directory="#emp_mail_path##session_base.userid#\inbox\attachments" recurse="yes">
			<cfdirectory action="create" name="as_outa" directory="#emp_mail_path##session_base.userid#\sendbox\attachments" recurse="yes">
			<cfdirectory action="create" name="as_drafta" directory="#emp_mail_path##session_base.userid#\draft\attachments" recurse="yes">
			<cfdirectory action="create" name="as_deletea" directory="#emp_mail_path##session_base.userid#\deleted\attachments" recurse="yes">
		</cfif>
		<cfset mail_path = '#emp_mail_path##session_base.userid#'>
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
					  SMTP,
					  MAIL_PATH
				)
				VALUES
				(
					  #session_base.userid#,
					  '#get_employee_.EMPLOYEE_EMAIL#',
					  '#get_employee_.EMPLOYEE_EMAIL#',
					  '',
					  '',
					  1,
					  '',
					   '#mail_path#'
				)
			</cfquery>
			<cfquery name="get_id" datasource="#dsn#" maxrows="1">
				SELECT MAILBOX_ID FROM CUBE_MAIL WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">
			</cfquery>
			<cfset attributes.mailbox_id = get_id.MAILBOX_ID>
	</cfif>
</cfif>


<cfif attributes.type eq 0>
	<cffile action="write" file="#emp_mail_path##session_base.userid##dir_seperator#sendbox#dir_seperator##file_name#" output="#attributes.body##CHR(13)##company_message#" charset ="UTF-8">
<cfelseif attributes.type eq 3>
	<cffile action="write" file="#emp_mail_path##session_base.userid##dir_seperator#draft#dir_seperator##file_name#" output="#attributes.body##CHR(13)##company_message#" charset ="UTF-8">	
<cfelseif attributes.type eq 1>
	<cffile action="write" file="#emp_mail_path##session_base.userid##dir_seperator#inbox#dir_seperator##file_name#" output="#attributes.body#" charset ="UTF-8">
</cfif>	
<cfquery name="get_max_id" datasource="#dsn#">
	SELECT 
		MAX(MAIL_ID) AS MAX_ID 
	FROM 
		MAILS  
</cfquery>
<cfscript>
    if(Len(get_max_id.max_id))
    	max_mail_id = get_max_id.max_id + 1;
	else
		max_mail_id = 1;	
</cfscript>

<cfset sayac=0>

<cfquery name="ADD_MAIL" datasource="#DSN#">
	INSERT INTO 
		MAILS
	(
		WRK_ID,
		MAILBOX_ID,
		FOLDER_ID,
		MAIL_ID,
		SUBJECT,
		SENDER,
		UNREACHABLE_MAILS,
		CONTENT_FILE,
		CONTENT_FILE_SERVER_ID,
		ATTACHMENT_FILE,
		MAIL_MODULE,
		<cfif isDefined("attributes.from")>MAIL_FROM,</cfif>
		<cfif isDefined("attributes.to_list") and len(attributes.to_list) lte 250>MAIL_TO,</cfif> 
		<cfif isDefined("attributes.cc_list") and len(attributes.cc_list) lte 250>MAIL_CC,</cfif>	
		RECORD_DATE,
		IS_READ,
		IS_DEATH 
	)
	VALUES
	(
		'#wrk_id#',
		<cfif isdefined("attributes.mailbox_id")>#attributes.mailbox_id#<cfelse>NULL</cfif>,
		<cfif attributes.type eq 0>-3,<cfelseif attributes.type eq 3>-1,<cfelse>-4,</cfif><!--- degistirilmeyecek --->
		#max_mail_id#,
		'#attributes.subject#',
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
			#session_base.userid#,
		<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
			#session.pp.userid#,     	
		<cfelse>
			NULL,
		</cfif>
		'',
		'#file_name#',
		#fusebox.server_machine#,
		<cfif isdefined('this_dosya_#sayac#') and len(Evaluate('this_dosya_#sayac#'))>
		'1',
		<cfelse>
		NULL,	
		</cfif>
		<cfif isDefined("attributes.module")>	
		'#attributes.module#',
		<cfelse>
		'',	 
		</cfif>
		<cfif isDefined("attributes.from")>'#attributes.from#',</cfif>
		<cfif isDefined("attributes.to_list") and len(attributes.to_list) lte 250>'#trim(attributes.to_list)#',</cfif>
		<cfif isDefined("attributes.cc_list") and len(attributes.cc_list) lte 250>'#trim(attributes.cc_list)#',</cfif>
		#now()#,
		0,
		0
	)
</cfquery>
<cfif isdefined("attributes.attachment_count")>
	<cfloop from="0" to="#attributes.attachment_count#" index="sayac">
		<cfif isdefined('this_dosya_#sayac#') and len(Evaluate('this_dosya_#sayac#'))>
			<cfset a=evaluate("this_dosya_#sayac#")>
			<cfset a_name=evaluate("attributes.file_name#sayac#")>
			<cfquery name="add_att1" datasource="#DSN#">
				INSERT INTO 
					MAILS_ATTACHMENT
				(
					WRK_ID,
					MAIL_ID,
					ATTACHMENT_FILE,
					ATTACHMENT_NAME,
					ATTACH_SERVER_ID
				)
				VALUES
				(
					'#wrk_id#',
					#max_mail_id#,
					'#a#',
					'#a_name#',
					#fusebox.server_machine#
				)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<!-- mail alnırken-->
<cfif IsDefined('attributes.attachment') and attributes.type eq 1>
	<cfset turkish_list = chr(252)&","&chr(287)&","&chr(305)&","&chr(351)&","&chr(231)&","&chr(246)&","&chr(220)&","&chr(286)&","&chr(304)&","&chr(350)&","&chr(199)&","&chr(214)>
	<cfset ascii_list = "u,g,i,s,c,o,U,G,I,S,C,O">
	<cfset attributes.attachment_file = replacelist(attributes.attachment,turkish_list,ascii_list)>
	<cfloop from="1" to="#ListLen(attributes.attachment,',')#" index="i">
		<cfquery name="get_attachment_name" datasource="#DSN#">
			SELECT 
				ATTACHMENT_NAME
			FROM
				MAILS_ATTACHMENT
			WHERE 
				ATTACHMENT_FILE= <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.attachment , i ,',')#">
		</cfquery>
		<cfquery name="add_att3" datasource="#DSN#">
			INSERT INTO 
				MAILS_ATTACHMENT
			(
				WRK_ID,
				MAIL_ID,
				ATTACHMENT_FILE,
				ATTACHMENT_NAME,
				ATTACH_SERVER_ID
			)
			VALUES
			(
				'#wrk_id#',
				#max_mail_id#,
				'#left(ListGetAt(attributes.attachment_file , i ,','),250)#',
			<cfif get_attachment_name.recordcount gt 0 and len(#get_attachment_name.attachment_name#)>
				'#left(get_attachment_name.attachment_name,100)#',
			<cfelse>
				'#left(ListGetAt(attributes.attachment , i,','),100)#',
			</cfif>
			    #fusebox.server_machine#
			)
		</cfquery>
	</cfloop>
<cfelse>
	<!-- old attachmentları ekliyor-->
	<cfparam name="attributes.old_attachment" default="">
	<cfparam name="attributes.old_attachment_name" default="">
	<cfloop from="1" to="#ListLen(attributes.old_attachment,',')#" index="i">
		<cfquery name="get_attachment_name" datasource="#DSN#">
			SELECT 
				ATTACHMENT_NAME
			FROM
				MAILS_ATTACHMENT
			WHERE 
				ATTACHMENT_FILE= <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.old_attachment , i ,',')#">
		</cfquery>
		<cfquery name="add_att2" datasource="#DSN#">
			INSERT INTO 
				MAILS_ATTACHMENT
			(
				WRK_ID,
				MAIL_ID,
				ATTACHMENT_FILE,
				ATTACHMENT_NAME,
				ATTACH_SERVER_ID
			)
			VALUES
			(
				'#wrk_id#',
				#max_mail_id#,
				'#ListGetAt(attributes.old_attachment , i ,',')#',
			<cfif get_attachment_name.recordcount gt 0 and len(#get_attachment_name.attachment_name#)>
				'#get_attachment_name.attachment_name#',
			<cfelseif len(attributes.old_attachment_name)>
				'#ListGetAt(attributes.old_attachment_name, i,',')#',
			<cfelse>
				NULL,
			</cfif>
			    #fusebox.server_machine#
			)
		</cfquery>
	</cfloop>
</cfif>
<cfscript>
	if(not isDefined("attributes.EMP_NAME"))
		attributes.EMP_NAME = '';
	if(not isDefined("attributes.EMP_NAME_CC"))
		attributes.EMP_NAME_CC = '';
	if(not isDefined("attributes.EMP_NAME_BCC"))
		attributes.EMP_NAME_BCC = '';				
</cfscript>
<cfset to_mails = "">
<cfset cc_mails = "">
<cfset bcc_mails = "">
<cfset all_to_mails = "">
<cfset all_cc_mails = "">
<cfset all_bcc_mails = "">
<!--- Insert mails to appropriate fields--->
<cfif len(attributes.EMP_NAME)><!--- To kısmı yani gönderilecek adresler kontrolden geçiyor. --->
	<cfloop from="1" to="#listlen(attributes.EMP_NAME)#" index="emp_sayac">
		<cfset to_mails = ListGetAt(attributes.EMP_NAME,emp_sayac,',')>
		<cfscript>
			if(FindNoCase("<",to_mails,1))
			{
				to_mails = RemoveChars(to_mails,1,FindNoCase("<",to_mails,1));
				if(FindNoCase(">",to_mails,1))
					to_mails = RemoveChars(to_mails,FindNoCase(">",to_mails,1),1);
			}
		</cfscript>
	</cfloop>
	<cfset all_to_mails = ListAppend(all_to_mails,to_mails,',')>
</cfif>

<cfif len(attributes.EMP_NAME_CC)><!--- CC kısmındaki gönderilecek adresler kontrolden geçiyor. --->
	<cfloop from="1" to="#listlen(attributes.EMP_NAME_CC)#" index="emp_sayac_cc">
	
		<cfset cc_mails = ListGetAt(attributes.EMP_NAME_CC,emp_sayac_cc,',')>
		<cfscript>
			if(FindNoCase("<",cc_mails,1))
			{
				cc_mails = RemoveChars(cc_mails,1,FindNoCase("<",cc_mails,1));
				if(FindNoCase(">",cc_mails,1))
				cc_mails = RemoveChars(cc_mails,FindNoCase(">",cc_mails,1),1);
			}
		</cfscript>
	</cfloop>
	<cfset all_cc_mails = ListAppend(all_cc_mails,cc_mails,',')>
</cfif>

<cfif len(attributes.EMP_NAME_BCC)><!--- BCC kısmındaki gönderilecek adresler kontrolden geçiyor. --->
	<cfloop from="1" to="#listlen(attributes.EMP_NAME_BCC)#" index="emp_sayac_bcc">
		<cfset bcc_mails = ListGetAt(attributes.EMP_NAME_BCC,emp_sayac_bcc,',')>
		<cfscript>
			if(FindNoCase("<",bcc_mails,1))
			{
				bcc_mails = RemoveChars(bcc_mails,1,FindNoCase("<",bcc_mails,1));
				if(FindNoCase(">",bcc_mails,1))
				bcc_mails = RemoveChars(bcc_mails,FindNoCase(">",bcc_mails,1),1);
			}
		</cfscript>
	</cfloop>
	<cfset all_bcc_mails = ListAppend(all_bcc_mails,bcc_mails,',')>
</cfif>
<!---<cfquery name="GET_MAX" datasource="#DSN#">
	INSERT INTO 
		MAILS_LIST
	(
		WRK_ID,
		MAILS_ID
		<cfif len(all_to_mails)>,TO_MAIL</cfif>
		<cfif len(all_cc_mails)>,CC_MAIL</cfif>
		<cfif len(all_bcc_mails)>,BCC_MAIL</cfif>
		<cfif isdefined('to_emps') and  len(to_emps)>,TO_EMP</cfif>
		<cfif isdefined('to_pars') and  len(to_pars)>,TO_PARS</cfif>
		<cfif isdefined('to_cons') and  len(to_cons)>,TO_CONS</cfif>
		<cfif isdefined('cc_emps') and  len(cc_emps)>,CC_EMP</cfif>
		<cfif isdefined('cc_pars') and  len(cc_pars)>,CC_PARS</cfif>
		<cfif isdefined('cc_cons') and  len(cc_cons)>,CC_CONS</cfif>
		<cfif isdefined('bcc_emps') and  len(bcc_emps)>,BCC_EMP</cfif>
		<cfif isdefined('bcc_pars') and  len(bcc_pars)>,BCC_PARS</cfif>
		<cfif isdefined('bcc_cons') and  len(bcc_cons)>,BCC_CONS</cfif>
	)
	VALUES
	(
		'#wrk_id#',
		#max_mail_id#
		<cfif len(all_to_mails)>,'#all_to_mails#'</cfif>
		<cfif len(all_cc_mails)>,'#all_cc_mails#'</cfif>
		<cfif len(all_bcc_mails)>,'#all_bcc_mails#'</cfif>
		<cfif isdefined('to_emps') and  len(to_emps)>,',#to_emps#,'</cfif>
		<cfif isdefined('to_pars') and  len(to_pars)>,',#to_pars#,'</cfif>
		<cfif isdefined('to_cons') and len(to_cons)>,',#to_cons#,'</cfif>
		<cfif isdefined('cc_emps') and  len(cc_emps)>,',#cc_emps#,'</cfif>
		<cfif isdefined('cc_pars') and  len(cc_pars)>,',#cc_pars#,'</cfif>
		<cfif isdefined('cc_cons') and  len(cc_cons)>,',#cc_cons#,'</cfif>
		<cfif isdefined('bcc_emps') and  len(bcc_emps)>,',#bcc_emps#,'</cfif>
		<cfif isdefined('bcc_pars') and  len(bcc_pars)>,',#bcc_pars#,'</cfif>
		<cfif isdefined('bcc_cons') and  len(bcc_cons)>,',#bcc_cons#,'</cfif>
	)	
</cfquery>--->
