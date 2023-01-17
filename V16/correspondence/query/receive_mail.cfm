<!--mail alma işlemi-->
<cfsetting showdebugoutput="no">
<cfset wrk_id = 'mail' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
<cfset attributes.death = 0>
<cfset error_ = 0>
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
<cfif not MAIL_SETTINGS.recordcount>
	<script type="text/javascript">
		alert('Aktif Mail Hesabınız Yoktur!');
	</script>
</cfif>
<!--- ileti kurallari ataniyor --->
<cfset rule_list = ''>
	<cfquery name="get_rules" datasource="#DSN#">
		SELECT * FROM CUBE_MAIL_RULES WHERE EMPLOYEE_ID = #session.ep.userid# ORDER BY PRIORITY ASC
	</cfquery>
	<cfif get_rules.recordcount>
		<cfoutput query="get_rules">
			<cfset word1_ = RULE_CASE>
			<cfset folder_id_ = FOLDER_ID>
			<cfset rule_type_ = RULE_TYPE>
			<cfset rule_list = listappend(rule_list,'#word1_#█#folder_id_#█#rule_type_#','╗')>
		</cfoutput>
	</cfif>
<!--- ileti kurallari ataniyor --->
	<cfset turkish_list = chr(252)&","&chr(287)&","&chr(305)&","&chr(351)&","&chr(231)&","&chr(246)&","&chr(220)&","&chr(286)&","&chr(304)&","&chr(350)&","&chr(199)&","&chr(214)>
	<cfset ascii_list = "u,g,i,s,c,o,U,G,I,S,C,O">
	<cfset attributes.all_to = "">
	<cfset attributes.all_cc = "">
<cfloop query="MAIL_SETTINGS">
	<cfset this_present_isactive = 0>
	<cfif MAIL_SETTINGS.present_isactive eq 1>
		<cfset this_present_isactive = 1><!--- Sunucuda bırak--->
	</cfif>
    	<!--- sunucuda bıraktıysa deneme--->
			<cfif len(POP_PORT)>
                <cfset this_port_ = POP_PORT>
            <cfelse>
                <cfset this_port_ = 110>
            </cfif>
            <cfif POP is 'pop.gmail.com'>
				<cfset javaSystem = createObject("java", "java.lang.System") />
                <cfset jProps = javaSystem.getProperties() />
                <cfset jProps.setProperty("mail.pop3.socketFactory.class", "javax.net.ssl.SSLSocketFactory") />
                <cfset jProps.setproperty("mail.pop3.port",995) />
                <cfset jProps.setProperty("mail.pop3.socketFactory.port", 995) />
            </cfif>
            <cfset error_ = 0>
                        <cfset ind = 1>
                        <cfset Message_Number = 0>
                        <cfset pop3 = POP>
                        <cfset account = ACCOUNT>
                        <cfset password_ = Decrypt(PASSWORD,session.ep.userid)>
                            <cftry>
								<!--- mailler cekiliyor --->
                             <!---   <script>
                                    window.top.get_wrk_message_div('CubeMail','Mail Servera Bağlantı Kuruluyor! Hesap Adı : <cfoutput>#MAIL_SETTINGS.ACCOUNT#</cfoutput>');
                                </script>--->
                                <cfset attch_path_ = "#emp_mail_path##session.ep.userid##dir_seperator#inbox#dir_seperator#attachments\">
                                <cfpop name="inbox"
                                       startrow="#ind#" 
                                       action="getHeaderOnly"
                                       server="#POP#" 
                                       username="#ACCOUNT#" 
                                       password="#password_#"
                                       port="#this_port_#">
<!---                                <script>
                                    window.top.get_wrk_message_div('CubeMail','<cfoutput>Mailler Alınıyor. Toplam Mail : #inbox.recordcount#</cfoutput>!');
                                </script>
--->                            <cfcatch type="any">
                                <script type="text/javascript">
								   alert('Mail Hesabı : <cfoutput>#ACCOUNT#\nMail Alma İşleminde Bir Sorun Oluştu!\nMail Servera Ulaşılamıyor veya Kullanıcı Adı Parola Hatalı!</cfoutput>');
								</script>
                                <cfset error_ = 1>
                            </cfcatch>
                            </cftry>
                            <!--- mailler cekiliyor --->
                            <cfif error_ eq 0>
                                <cfoutput query="inbox">
                                 <!--- tek tek mail deneme yapiyorum --->
									<cfset attributes.uid = inbox.uid>
                                    <cfquery name="get_mail_uid" datasource="#DSN#">
                                        SELECT TOP 1 FAKE_MAIL_ID FROM MAILS_FAKE WHERE UID='#attributes.uid#' AND MAILBOX_ID = #MAIL_SETTINGS.mailbox_id#
                                    </cfquery>
                                    <cfif not get_mail_uid.recordcount>
                                            <cfset attributes.to = trim(inbox.to)>
                                            <cfset attributes.cc = trim(inbox.cc)>
                                            <cfset attributes.to_list ="">
                                            <cfset attributes.cc_list ="">
                                            <cfloop from="1" to="#listlen(attributes.to)#" index="sayac">
                                                <cfset attributes.to_list = ListAppend(attributes.to_list,trim(ListGetAt(attributes.to,sayac,',')),',')>
                                            </cfloop>
                                            <cfloop from="1" to="#listlen(attributes.cc)#" index="sayac_cc">
                                                <cfset attributes.cc_list = ListAppend(attributes.cc_list,trim(ListGetAt(attributes.cc,sayac_cc,',')),',')>
                                            </cfloop>
                                              <cfscript>
                                                attributes.module="correspondence";
                                                if (ListLen(inbox.From,'<') GT 1){
                                                    attributes.from=ListGetAt(inbox.From,2,'<');
                                                    attributes.from=ReplaceList(attributes.from,'>','');
                                                }	
                                                else{
                                                    attributes.from=inbox.From;
                                                }
                                                if(isdate(inbox.date))
                                                    attributes.date = createodbcdatetime(createdatetime(year(inbox.date),month(inbox.date),day(inbox.date),hour(inbox.date),minute(inbox.date),0));
                                                else
                                                    attributes.date = now();
                                                attributes.subject = ReplaceList(ReplaceList(inbox.Subject,'#chr(13)#',''),'#chr(10)#','');		
                                                att = '';
                                                temp = '';										
                                              </cfscript>
                                             <cfset attributes.mailbox_id = MAIL_SETTINGS.mailbox_id>
                                             <cfset attributes.type = 1>
                                             <cfinclude template="../../objects/query/add_mail.cfm">
                                            <!--- ileti kurallarina gore uygun yere tasinir --->
                                            <cfif listlen(rule_list,'╗')>
                                                 <cfloop list="#rule_list#" delimiters="╗" index="rule_">
                                                    <cfset word_ = listgetat(rule_,1,'█')>
                                                    <cfset folder_id_ = listgetat(rule_,2,'█')>
                                                    <cfset rule_type_ = listgetat(rule_,3,'█')>
                                                    <cfset rule_true_ = "">
                                                        <cfif rule_type_ eq 1>
                                                            <cfset rule_true_ = 1>
                                                            <cfloop list="#word_#" index="aa" delimiters="+">
                                                                <cfif not attributes.from contains aa>
                                                                    <cfset rule_true_ = 0>
                                                                </cfif>
                                                            </cfloop>
                                                        <cfelseif rule_type_ eq 2>
                                                            <cfset rule_true_ = 1>
                                                            <cfloop list="#word_#" index="aa" delimiters="+">
                                                                <cfif not attributes.body contains aa>
                                                                    <cfset rule_true_ = 0>
                                                                </cfif>
                                                            </cfloop>
                                                        <cfelseif rule_type_ eq 3>
                                                            <cfset rule_true_ = 1>
                                                            <cfloop list="#word_#" index="aa" delimiters="+">
                                                                <cfif not attributes.subject contains aa>
                                                                    <cfset rule_true_ = 0>
                                                                </cfif>
                                                            </cfloop>
                                                        <cfelseif rule_type_ eq 4>
                                                            <cfset rule_true_ = 1>
                                                            <cfloop list="#word_#" index="aa" delimiters="+">
                                                                <cfif not attributes.to contains aa>
                                                                    <cfset rule_true_ = 0>
                                                                </cfif>
                                                            </cfloop>
                                                        <cfelseif rule_type_ eq 4>
                                                            <cfset rule_true_ = 1>
                                                            <cfloop list="#word_#" index="aa" delimiters="+">
                                                                <cfif not attributes.cc contains aa>
                                                                    <cfset rule_true_ = 0>
                                                                </cfif>
                                                            </cfloop>
                                                        </cfif>
                                                        <cfif rule_true_ eq 1 and rule_type_ eq 1>
                                                            <cfquery name="upd_for_rule" datasource="#dsn#">
                                                                UPDATE MAILS SET FOLDER_ID = #folder_id_# WHERE MAIL_ID = #max_mail_id#
                                                            </cfquery>
                                                            <cfbreak>
                                                        <cfelseif rule_true_ eq 1 and rule_type_ eq 2>
                                                            <cfquery name="upd_for_rule" datasource="#dsn#">
                                                                UPDATE MAILS SET FOLDER_ID = #folder_id_# WHERE MAIL_ID = #max_mail_id#
                                                            </cfquery>
                                                            <cfbreak>
                                                        <cfelseif rule_true_ eq 1 and rule_type_ eq 3>
                                                            <cfquery name="upd_for_rule" datasource="#dsn#">
                                                                UPDATE MAILS SET FOLDER_ID = #folder_id_# WHERE MAIL_ID = #max_mail_id#
                                                            </cfquery>
                                                            <cfbreak>
                                                        <cfelseif rule_true_ eq 1 and rule_type_ eq 4>
                                                            <cfquery name="upd_for_rule" datasource="#dsn#">
                                                                UPDATE MAILS SET FOLDER_ID = #folder_id_# WHERE MAIL_ID = #max_mail_id#
                                                            </cfquery>
                                                            <cfbreak>
                                                        <cfelseif rule_true_ eq 1 and rule_type_ eq 4>
                                                            <cfquery name="upd_for_rule" datasource="#dsn#">
                                                                UPDATE MAILS SET FOLDER_ID = #folder_id_# WHERE MAIL_ID = #max_mail_id#
                                                            </cfquery>
                                                            <cfbreak>
                                                        </cfif>							
                                                 </cfloop>
                                            </cfif>
                                            <!--- ileti kurallarina gore uygun yere tasinir --->
                                          <!---  <cfif not len(this_present_isactive) or this_present_isactive eq 0>
                                                 <cfset Message_Number = MessageNumber>
                                                 <cfpop name="inbox_2" 
                                                   action="delete"
                                                   server="#pop3#" 
                                                   username="#account#" 
                                                   password="#password_#"
                                                   port="#this_port_#"
                                                   uid="#attributes.uid#">
                                            </cfif>
                                    <cfelse>
                                        <cfif not len(this_present_isactive) or this_present_isactive eq 0>
                                          <cfset Message_Number = MessageNumber>
                                            <cfpop name="inbox_2" 
                                               action="delete"
                                               server="#pop3#" 
                                               username="#account#" 
                                               password="#password_#"
                                               port="#this_port_#"
                                               uid ="#attributes.uid#">
                                        </cfif>							 --->
                                    </cfif>
                                </cfoutput><!--- inbox outputu --->
                        	</cfif><!--- error bitti --->
                    <cfset ind = ind + 1>
</cfloop> 
	

<!--- ozel mail forward basliyor --->
<cftry>
	<cfif MAIL_SETTINGS.recordcount>
		<cfquery name="get_main_rules" datasource="#DSN#">
			SELECT * FROM CUBE_MAIL_MAIN_RULES WHERE TYPE = 0 AND RULE_NAME IN ('#replace(valuelist(MAIL_SETTINGS.EMAIL),",","','","all")#') AND ACTION IS NOT NULL
		</cfquery>	
		<cfif get_main_rules.recordcount>
			<cfquery name="get_mails_" datasource="#dsn#">
				SELECT * FROM MAILS WHERE WRK_ID = '#wrk_id#'
			</cfquery>
			<cfif get_mails_.recordcount>
				<cfset aktarilacak_list = listdeleteduplicates(valuelist(get_main_rules.action))>
				<cfloop list="#aktarilacak_list#" index="ccm">
					<cfquery name="get_aktarim_settings" datasource="#DSN#">
						SELECT MAILBOX_ID,EMPLOYEE_ID FROM CUBE_MAIL WHERE EMAIL = '#ccm#'
					</cfquery>
					<cfif get_aktarim_settings.recordcount>
						<cfoutput query="get_mails_">
							<cfquery name="add_" datasource="#dsn#" result="MAX_ID">
								INSERT INTO 
									MAILS
								(
									WRK_ID,
									MAILBOX_ID,
									FOLDER_ID,
									SUBJECT,
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
									#get_aktarim_settings.mailbox_id#,
									-4,
									'#get_mails_.subject#',
									<cfif len(get_mails_.SENDER)>#get_mails_.SENDER#<cfelse>NULL</cfif>,
									<cfif len(get_mails_.CONTENT_FILE)>'#get_mails_.CONTENT_FILE#'<cfelse>NULL</cfif>,
									<cfif len(get_mails_.CONTENT_FILE_SERVER_ID)>#get_mails_.CONTENT_FILE_SERVER_ID#<cfelse>NULL</cfif>,
									<cfif len(get_mails_.MAIL_MODULE)>'#get_mails_.MAIL_MODULE#'<cfelse>NULL</cfif>,
									<cfif len(get_mails_.MAIL_FROM)>'#get_mails_.MAIL_FROM#'<cfelse>NULL</cfif>,
									<cfif len(get_mails_.MAIL_TO)>'#get_mails_.MAIL_TO#'<cfelse>NULL</cfif>,
									<cfif len(get_mails_.MAIL_CC)>'#get_mails_.MAIL_CC#'<cfelse>NULL</cfif>,
									#now()#,
									#date_add('h',session.ep.time_zone,now())#,
									0,
									<cfif len(get_mails_.uid)>'#get_mails_.uid#'<cfelse>NULL</cfif>
								)
							</cfquery>
							<cfquery name="GET_MAIL_ATTACHMENTS" datasource="#dsn#">
								SELECT * FROM MAILS_ATTACHMENT WHERE MAIL_ID = #get_mails_.mail_id#
							</cfquery>
							<cfscript>
								if(Len(MAX_ID.IDENTITYCOL))
									max_mail_id = MAX_ID.IDENTITYCOL + 1;
								else
									max_mail_id = 1;	
							</cfscript>
                            <cfif len(get_mails_.CONTENT_FILE)><cffile action="copy" source="#emp_mail_path##session.ep.userid##dir_seperator#inbox#dir_seperator##get_mails_.CONTENT_FILE#" destination="#emp_mail_path##get_aktarim_settings.employee_id##dir_seperator#inbox"></cfif>
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
                                        1,
                                        '#GET_MAIL_ATTACHMENTS.WRK_ID#',
                                        <cfif len(GET_MAIL_ATTACHMENTS.SPECIAL_CODE)>'#GET_MAIL_ATTACHMENTS.SPECIAL_CODE#'<cfelse>NULL</cfif>
                                    )
                                </cfquery>
                                <cffile action="copy" source="#emp_mail_path##session.ep.userid##dir_seperator#inbox#dir_seperator#attachments#dir_seperator##GET_MAIL_ATTACHMENTS.ATTACHMENT_FILE#" destination="#emp_mail_path##get_aktarim_settings.employee_id##dir_seperator#inbox#dir_seperator#attachments">
                                </cfloop>
                            </cfif>
						</cfoutput>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
	</cfif>
<cfcatch type="any">
	<script type="text/javascript">
		alert('Genel Mail Kuralları Çalıştırılırken Bir Sorun Oluştu!');
	</script>
</cfcatch>
</cftry>
<!--- ozel mail forward --->
<script type="text/javascript">
	window.top.document.getElementById('message_div').innerHTML = '';
	//window.top.document.getElementById('message_div_main').style.display = 'none';
	window.top.get_left_menu();
	if(window.top.document.getElementById('last_page').value!='correspondence.popup_create_cubemail')
	window.top.list_mail(-4);
</script>

