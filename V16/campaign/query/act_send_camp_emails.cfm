<cf_xml_page_edit fuseact="campaign.popup_list_target_masses">
<cfinclude template="../query/get_cons.cfm">
<cfinclude template="../query/get_pars.cfm">
<cfset getComponent = createObject('component', 'WEX.emailservices.cfc.sendgrid')>
<cfset getSendgridInformations = getComponent.getSendgridInformations()>
<cfset total_no = get_cons.RECORDCOUNT + get_pars.RECORDCOUNT>
<cfif isdefined("attributes.email_sender") and len(attributes.email_sender) and attributes.email_sender neq 0>
	<cfset from_adress_ = "#listlast(attributes.email_sender)#<#listfirst(attributes.email_sender)#>">
<cfelse>
	<cfset from_adress_ = "#session.ep.company#<#session.ep.company_email#>">
</cfif>
<cfinclude template="get_email_cont.cfm"><!--- Gönderim Yapılan içerik bilgileri--->
<cfif email_cont.recordcount and ListLen(ValueList(email_cont.sended_target_mass,','))>
	<cfset list_ids = ListAppend(list_ids,ValueList(email_cont.sended_target_mass,','))>
</cfif>
<cfquery name="get_empleyee_email" datasource="#dsn#"><!--- Mail gönderen kişinin mail adresini getiriyor. --->
	SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<cfquery name="get_email_count" datasource="#dsn#">
	SELECT 
		MAX(COUNT)+1 COUNT
	FROM 
		SEND_CONTENTS 
	WHERE 
		CONT_ID = #attributes.email_cont_id# 
		AND CONT_TYPE = 1
		AND CAMP_ID = #attributes.camp_id#	
</cfquery>
<cfif len(get_email_count.count)>
	<cfset count = get_email_count.count>
<cfelse>
	<cfset count = 1>
</cfif>
<cfset consumer_error_list = "">
<cfset partner_error_list = "">
<cfquery NAME="GET_PARS" dbtype="query">
SELECT * FROM GET_PARS WHERE WANT_EMAIL = 1
</cfquery>
<cfquery NAME="GET_cons" dbtype="query">
SELECT * FROM GET_cons WHERE WANT_EMAIL = 1
</cfquery>
<cfset submission_type = isDefined("attributes.submission_type") ? "#attributes.submission_type#" : "0">
<cfif submission_type eq 1>
	<cfset mailList=valuelist(get_cons.CONSUMER_EMAIL)>
	<cfset mailList=valuelist(get_pars.COMPANY_PARTNER_EMAIL)>
	<cfif len(email_cont_id)>
		<cfset cfc= createObject("component","V16.content.cfc.get_content")>
		<cfset get_content =cfc.get_content_list_fnc(cntid : email_cont_id)> 
	</cfif>
</cfif>
<cfloop query = "get_cons">
	<cfif len(CONSUMER_EMAIL)>
		<cfset receiver = "#CONSUMER_NAME# #CONSUMER_SURNAME#">
		<cftry>
			<cfif submission_type eq 0>
				<cfmail
					from="#from_adress_#"
					to="#CONSUMER_EMAIL#" 
					failto="#get_empleyee_email.EMPLOYEE_EMAIL#"
					subject="#email_cont.email_subject#"
					type="HTML">
							<cfset attributes.email_address = CONSUMER_EMAIL>
							<cfset attributes.user_type = "user_id">
							<cfset attributes.consumer_id = CONSUMER_ID>
						<cfinclude template="get_send_camp_emails_content.cfm">
				</cfmail>
			</cfif>
			<cfquery name="ADD_SENT_CONT_CONSUMER" datasource="#dsn3#"><!--- CONT_TYPE: 1 EMAIL 2 FAX 3 DIRECT-MAIL 4 SMS 5 FACE2FACE --->
				INSERT INTO
					#dsn_alias#.SEND_CONTENTS
					(
						CONT_ID,
						CONT_TYPE,
						SEND_CON,
						SEND_DATE,
						RECORD_IP,
						SENDER_EMP,
						CAMP_ID,
						COUNT
					)
				VALUES
					(
						#EMAIL_CONT_ID#,
						1,
						#CONSUMER_ID#,
						#now()#,
						'#CGI.REMOTE_ADDR#',
						#SESSION.EP.USERID#,
						#attributes.camp_id#,
						#count#
					)
			</cfquery>
		<cfcatch type="any">
			<cfset consumer_error_list = ListAppend(consumer_error_list,CONSUMER_ID,',')>
		</cfcatch>
		</cftry>
	</cfif>
</cfloop>
<cfloop query="get_pars"><!--- GET_TMARKET_USERS'dan gelen PARTNER üyelerin gönderimi yapılıyor. --->
	<cfif len(COMPANY_PARTNER_EMAIL)>
		<cfset receiver = "#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#">
			<cftry>
			<cfif submission_type eq 0>
				<cfmail
					from="#from_adress_#"
					to="#COMPANY_PARTNER_EMAIL#"
					failto="#get_empleyee_email.EMPLOYEE_EMAIL#"
					subject="#email_cont.email_subject#"
					type="HTML">
							<cfset attributes.email_address = COMPANY_PARTNER_EMAIL>
							<cfset attributes.user_type = "user_id">
							<cfset attributes.partner_id = PARTNER_ID>
						<cfinclude template="get_send_camp_emails_content.cfm">
				</cfmail>
			</cfif>
			<cfquery name="ADD_SENT_CONT_PARTNER" datasource="#dsn3#"><!--- CONT_TYPE: 1 EMAIL 4 SMS  --->
				INSERT INTO
					#dsn_alias#.SEND_CONTENTS
					(
						CONT_ID,
						CONT_TYPE,
						SEND_PAR,
						SEND_DATE,
						RECORD_IP,
						SENDER_EMP,
						CAMP_ID,
						COUNT
					)
				VALUES
					(
						#EMAIL_CONT_ID#,
						1,
						#PARTNER_ID#,
						#now()#,
						'#CGI.REMOTE_ADDR#',
						#SESSION.EP.USERID#,
						#attributes.camp_id#,
						#count#
					)
			</cfquery>
		<cfcatch>	
			<cfset partner_error_list = ListAppend(partner_error_list,PARTNER_ID,',')>
		</cfcatch>
		</cftry>
	</cfif>
</cfloop>	
<script type="text/javascript">
	<cfif submission_type eq 1>
		<cfif isDefined("mailList") and len(mailList)>
			<cfif isdefined("attributes.is_temp") and attributes.is_temp eq 1>
				var data = {"name": "<cfoutput>#get_content.cont_head#</cfoutput>","generation": "dynamic"};
				$.ajax({
					url :'/wex.cfm/sendgrid/create_template',
					method: 'post',
					contentType: 'application/json; charset=utf-8',
					dataType: "json",
					data : JSON.stringify(data),
					success : function(response){
						template_id  = response.id;
						data = {
								"active": 1,
								"name": "<cfoutput>#get_content.cont_head#</cfoutput>",
								"html_content": <cfoutput>#replace(serializeJSON(get_content.cont_body), "//", "")#</cfoutput>,
								"subject": "<cfoutput>#get_content.cont_head#</cfoutput>"
							};
						var objects = {"template_id" : template_id, "data": data};
						$.ajax({ 
							url :'/wex.cfm/sendgrid/versions', 
							method: 'post', 
							contentType: 'application/json; charset=utf-8', 
							dataType: "json", 
							data : JSON.stringify(objects), 
							success : function(response){ 
								<cfoutput>
									var data = {
										"personalizations": [<cfloop list="#mailList#" index="i" item="j">{"to": [{"email": "#j#"}]}<cfif ListLen(mailList) neq i>,</cfif></cfloop>],
										"from": {
											"email": "#getSendgridInformations.sender_mail#",
											"name": "#session.ep.company#"
										},
										
										"subject": "#get_content.cont_head#",
										"template_id": template_id
										<cfif len(getSendgridInformations.sender_mail)>
											,
											"asm": {
												"group_id": #getSendgridInformations.SENDGRID_GROUP_ID#
											}		
										</cfif>
										
									};
								</cfoutput>
								$.ajax({
									url :'/wex.cfm/sendgrid/send_mail_content',
									method: 'post',
									contentType: 'application/json; charset=utf-8',
									dataType: "json",
									data : JSON.stringify(data),
									success : function(response){ alert("<cf_get_lang dictionary_id='49454.Email sent.'>!");}
								});
							} 
						});
					}
				});			
			<cfelse>
				<cfoutput>
					var data = {
						"personalizations": [<cfloop list="#mailList#" index="i" item="j">{"to": [{"email": "#j#"}]}<cfif ListLen(mailList) neq i>,</cfif></cfloop>],
						"from": {
							"email": "#getSendgridInformations.sender_mail#",
							"name": "#session.ep.company#"
						},
						
						"subject": "#get_content.cont_head#",
						"content": [
							{
							"type": "text/html",
							"value": #replace(serializeJSON(get_content.cont_body), "//", '')#
							}
						]
						<cfif len(getSendgridInformations.sender_mail)>
							,
							"asm": {
								"group_id": #getSendgridInformations.SENDGRID_GROUP_ID#
							}		
						</cfif>		
						
					};
				</cfoutput>
				$.ajax({
					url :'/wex.cfm/sendgrid/send_mail_content',
					method: 'post',
					contentType: 'application/json; charset=utf-8',
					dataType: "json",
					data : JSON.stringify(data),
					success : function(response){ alert("<cf_get_lang dictionary_id='49454.Email sent.'>!");}
				});
			</cfif>
		<cfelse>
			alert("<cf_get_lang dictionary_id='56664.No contacts to send email. Please check! Select the contacts you want to send email from the list.'>.");
			return false;
		</cfif>
	</cfif>
	function waitfor()
	{
		<cfif not isdefined("attributes.draggable")>
			wrk_opener_reload();
			window.close();
		<cfelse>
			closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		</cfif>
	}
	setTimeout("waitfor()",1000);
</script>
<!------<cf_xml_page_edit fuseact="campaign.popup_list_target_masses">
<cfinclude template="../query/get_outof_target_mass.cfm">
<cfif isdefined("attributes.email_sender") and len(attributes.email_sender) and attributes.email_sender neq 0>
	<cfset from_adress_ = "#listlast(attributes.email_sender)#<#listfirst(attributes.email_sender)#>">
<cfelse>
	<cfset from_adress_ = "#session.ep.company#<#session.ep.company_email#>">
</cfif>
<!--- Send_Content / Cont_Type => 1:Email, 2:Fax, 3:DirectMail, 4:Sms, 5:FaceToFace --->
<!---CAMPAIGN_EMAIL_LIST tablosu yerine kayıtlar SEND_CONTENTS 'e atılacak.CAMPAIGN_EMAIL_LIST tablosu içindeki kayıtlar SEND_CONTENTS e update edildikten sonra silinecek--->
<cfif isDefined("attributes.target_mass_other") or isDefined("attributes.target_mass")>
	<cfset cons_id_list="">
	<cfset pars_id_list="">
	<cfset consumer_error_list = "">
	<cfset partner_error_list = "">
	<cfset list_ids = "">
	<cfset consumer_id_list = "">
	<cfset partner_send_list = "">
	<cfset consumer_send_list = "">
	<cfset consumer_not_send_list = "">
	<cfset partner_not_send_list = "">
	<cfset partner_send_target_list ="">
	<cfset consumer_send_target_list ="">
	<cfset consumer_not_send_target_list="">
	<cfset partner_not_send_target_list ="">
	<cfquery name="get_empleyee_email" datasource="#dsn#"><!--- Mail gönderen kişinin mail adresini getiriyor. --->
		SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	</cfquery>
	<cfinclude template="get_email_cont.cfm"><!--- Gönderim Yapılan içerik bilgileri--->
	<cfif email_cont.recordcount and ListLen(ValueList(email_cont.sended_target_mass,','))>
		<cfset list_ids = ListAppend(list_ids,ValueList(email_cont.sended_target_mass,','))>
	</cfif>
	<!--- Hedef kitlelerden seçilmiş olanlar gonderiliyor ise --->
	<cfif isdefined('attributes.target_mass')>
		<cfloop from="1" to="#listlen(attributes.target_mass)#" index="gonderim">
			<cfset list_ids = ListAppend(list_ids,ListGetAt(attributes.target_mass,gonderim,',')) ><!--- Gönderim Yapılan içerikleri listeye atıyoruz. --->
			<cfset attributes.tmarket_id = ListGetAt(attributes.target_mass,gonderim,',')>
			
			<cfif isdefined("CONS_EMAIL_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#") and len(Evaluate('CONS_EMAIL_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#'))>
				<cfset cons_id_list =ListAppend(cons_id_list,Evaluate('CONS_EMAIL_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#'))>
			</cfif>
			<cfif isdefined("PARS_EMAIL_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#") and len(Evaluate('PARS_EMAIL_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#'))>
				<cfset pars_id_list = ListAppend(pars_id_list,Evaluate('PARS_EMAIL_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#'))>
			</cfif>
		</cfloop>
		<cfset cons_id_list=ListSort(ListDeleteDuplicates(cons_id_list),"numeric","asc",",")>
		<cfset pars_id_list=ListSort(ListDeleteDuplicates(pars_id_list),"numeric","asc",",")>
	</cfif>
	<cfif len(partner_list) and xml_check_send_list eq 0><!---Daha önce gönderilen kurumsal üyeler bulunuyor--->
		<cfquery name="get_partner_send_contents" datasource="#dsn#">
			SELECT 
				CONT_ID,
				SEND_PAR 
			FROM 
				SEND_CONTENTS
			WHERE 
				CONT_ID = #attributes.email_cont_id# AND
				SEND_PAR IN(#partner_list#)
		</cfquery>
		<cfset partner_send_list = ValueList(get_partner_send_contents.send_par)>
	
		<cfloop list="#partner_list#" index="i"><!---(Mail gönderilemeyen) yeni eklenen kurumsal üyeler bulundu--->
			<cfif not listfind(partner_send_list,i,',')>
				<cfset partner_not_send_list= ListAppend(partner_not_send_list,i)>
			</cfif>
		</cfloop>
	<cfelseif xml_check_send_list eq 1>
			<cfset partner_not_send_list = partner_list>
	</cfif>
	<cfif len(consumer_list) and xml_check_send_list eq 0><!---Daha önce gönderilen bireysel üyeler bulunuyor--->
		<cfquery name="get_consumer_send_contents" datasource="#dsn#">
			SELECT CONT_ID,SEND_CON FROM SEND_CONTENTS WHERE CONT_ID = #attributes.email_cont_id# AND SEND_CON IN(#consumer_list#)
		</cfquery>
		<cfset consumer_send_list = ValueList(get_consumer_send_contents.send_con)>
		<cfloop list="#consumer_list#" index="i">	<!---(Mail gönderilemeyen) yeni eklenen bireysel üyeler bulundu--->
			<cfif not listfind(consumer_send_list,i,',')>
				<cfset consumer_not_send_list= ListAppend(consumer_not_send_list,i)>
			</cfif>
		</cfloop>
	<cfelseif xml_check_send_list eq 1>
		<cfset consumer_not_send_list = consumer_list>
	</cfif>
	<cfif isdefined('attributes.target_mass')>
		<cfloop from="1" to="#listlen(attributes.target_mass)#" index="gonderim">
			<cfif len (Evaluate('PARS_EMAIL_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#')) and xml_check_send_list eq 0><!---Daha önce gönderilen hedef kitledeki kurumsal üyeler bulunuyor--->
				<cfquery name="get_partner_send_target_contents" datasource="#dsn#">
					SELECT 
						CONT_ID,
						SEND_PAR 
					FROM 
						SEND_CONTENTS 
					WHERE 
						CONT_ID = #attributes.email_cont_id# AND 
						SEND_PAR IN(#Evaluate('PARS_EMAIL_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#')#)
				</cfquery>
					<cfset partner_send_target_list=ValueList(get_partner_send_target_contents.send_par)>
				<cfloop list="#Evaluate('PARS_EMAIL_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#')#" index="i"><!---(Mail gönderilemeyen)hedef kitleye yeni eklenen kurumsal üyeler bulundu--->
					<cfif not listfind(partner_send_target_list,i,',')>
						<cfset partner_not_send_target_list= ListAppend(partner_not_send_target_list,i)>
					</cfif>
				</cfloop>
			<cfelseif xml_check_send_list eq 1>
				<cfset partner_not_send_target_list = pars_id_list> 
			</cfif>
			<cfif len (Evaluate('CONS_EMAIL_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#')) and xml_check_send_list eq 0><!---Daha önce gönderilen hedef kitledeki bireysel üyeler bulunuyor--->
				<cfquery name="get_consumer_send_target_contents" datasource="#dsn#">
					SELECT 
						CONT_ID,
						SEND_CON 
					FROM 
						SEND_CONTENTS 
					WHERE 
						CONT_ID = #attributes.email_cont_id# AND 
						SEND_CON IN(#Evaluate('CONS_EMAIL_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#')#)
				</cfquery>
				<cfset consumer_send_target_list=ValueList(get_consumer_send_target_contents.send_con)>
				<cfloop list="#Evaluate('CONS_EMAIL_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#')#" index="i"><!---(Mail gönderilemeyen)hedef kitleye yeni eklenen bireysel üyeler bulundu--->
					<cfif not listfind(consumer_send_target_list,i,',')>
						<cfset consumer_not_send_target_list= ListAppend(consumer_not_send_target_list,i)>
					</cfif>
				</cfloop>
			<cfelseif xml_check_send_list eq 1>
				<cfset consumer_not_send_target_list = cons_id_list> 
			</cfif>
		</cfloop>
	</cfif>
	<!--- Onceden yollanmis olan mail gonderim sayisi hesaplaniyor --->
	<cfquery name="get_email_count" datasource="#dsn#">
		SELECT 
			MAX(COUNT)+1 COUNT
		FROM 
			SEND_CONTENTS 
		WHERE 
			CONT_ID = #attributes.email_cont_id# 
			AND CONT_TYPE = 1
			AND CAMP_ID = #attributes.camp_id#	
	</cfquery>
	<cfif len(get_email_count.count)>
		<cfset count = get_email_count.count>
	<cfelse>
		<cfset count = 1>
	</cfif>
	<!---Hedef kitleden seçilmiş olanlar varsa--->
	<cfif isdefined('attributes.target_mass')><!--- Hedef kitlelerden seçilmiş olanlar gönderiliyor ise --->
		<cfloop from="1" to="#listlen(attributes.target_mass)#" index="gonderim"><!--- Seçili olan gönderim sayısı kadar dön --->
			<cfset list_ids = ListAppend(list_ids,ListGetAt(attributes.target_mass,gonderim,',')) ><!--- Gönderim Yapılan içerikleri listeye atıyoruz. --->
			<cfset attributes.tmarket_id = ListGetAt(attributes.target_mass,gonderim,',')>	
			<cfif len(consumer_not_send_target_list)>
				<cfquery name="GET_TMARKET_USERS" datasource="#DSN#">
					SELECT DISTINCT
						1 AS TYPE,
						CONSUMER_ID AS USER_ID,
						CONSUMER_NAME,
						CONSUMER_SURNAME,
						CONSUMER_EMAIL AS USER_EMAIL 
					FROM
						CONSUMER
					WHERE 
						CONSUMER_ID IN(#consumer_not_send_target_list#)	AND 
						WANT_EMAIL = 1
				</cfquery>
				<cfloop query="GET_TMARKET_USERS"><!--- s'dan gelen CONSUMER üyelerin gönderimi yapılıyor. --->
					<cfif len(USER_EMAIL)>
						<cfset receiver = "#CONSUMER_NAME# #CONSUMER_SURNAME#">
						<cftry>
							<cfmail
								from="#from_adress_#"
								to="#USER_EMAIL#" 
								failto="#get_empleyee_email.EMPLOYEE_EMAIL#"
								subject="#email_cont.email_subject#"
								type="HTML">
										<cfset attributes.email_address = USER_EMAIL>
										<cfset attributes.user_type = "user_id">
										<cfset attributes.consumer_id = user_id>
									<cfinclude template="get_send_camp_emails_content.cfm">
							</cfmail>
							<cfquery name="ADD_SENT_CONT_CONSUMER" datasource="#dsn3#"><!--- CONT_TYPE: 1 EMAIL 2 FAX 3 DIRECT-MAIL 4 SMS 5 FACE2FACE --->
								INSERT INTO
									#dsn_alias#.SEND_CONTENTS
									(
										CONT_ID,
										CONT_TYPE,
										SEND_CON,
										SEND_DATE,
										RECORD_IP,
										SENDER_EMP,
										CAMP_ID,
										COUNT
									)
								VALUES
									(
										#EMAIL_CONT_ID#,
										1,
										#USER_ID#,
										#now()#,
										'#CGI.REMOTE_ADDR#',
										#SESSION.EP.USERID#,
										#attributes.camp_id#,
										#count#
									)
							</cfquery>
						<cfcatch type="any">
							<cfset consumer_error_list = ListAppend(consumer_error_list,USER_ID,',')>
						</cfcatch>
						</cftry>
					</cfif>
				</cfloop>
			</cfif>
			<cfif len(partner_not_send_target_list)>
				<cfquery name="GET_TMARKET_USERS" datasource="#DSN#">
					SELECT DISTINCT
						2 AS TYPE,
						PARTNER_ID AS USER_ID,
						COMPANY_PARTNER_NAME,
						COMPANY_PARTNER_SURNAME,
						COMPANY_PARTNER_EMAIL AS USER_EMAIL 
					FROM
						COMPANY_PARTNER
					WHERE 
						PARTNER_ID IN(#partner_not_send_target_list#) AND 
						WANT_EMAIL = 1
				</cfquery>
				<cfloop query="GET_TMARKET_USERS"><!--- GET_TMARKET_USERS'dan gelen PARTNER üyelerin gönderimi yapılıyor. --->
					<cfif len(USER_EMAIL)>
						<cfset receiver = "#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#">
							<cftry>
							<cfmail
								from="#from_adress_#"
								to="#USER_EMAIL#"
								failto="#get_empleyee_email.EMPLOYEE_EMAIL#"
								subject="#email_cont.email_subject#"
								type="HTML">
										<cfset attributes.email_address = USER_EMAIL>
										<cfset attributes.user_type = "user_id">
										<cfset attributes.partner_id = user_id>
									<cfinclude template="get_send_camp_emails_content.cfm">
							</cfmail>
							<cfquery name="ADD_SENT_CONT_PARTNER" datasource="#dsn3#"><!--- CONT_TYPE: 1 EMAIL 4 SMS  --->
								INSERT INTO
									#dsn_alias#.SEND_CONTENTS
									(
										CONT_ID,
										CONT_TYPE,
										SEND_PAR,
										SEND_DATE,
										RECORD_IP,
										SENDER_EMP,
										CAMP_ID,
										COUNT
									)
								VALUES
									(
										#EMAIL_CONT_ID#,
										1,
										#USER_ID#,
										#now()#,
										'#CGI.REMOTE_ADDR#',
										#SESSION.EP.USERID#,
										#attributes.camp_id#,
										#count#
									)
							</cfquery>
						<cfcatch>	
							<cfset partner_error_list = ListAppend(partner_error_list,USER_ID,',')>
						</cfcatch>
						</cftry>
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
		<!--- Mail Gonderildi Bilgisi --->
		<style type="text/css">
			.color-border {background-color:##6699cc;}
			.color-row {background-color: ##f1f0ff;}
			.color-list {background-color: ##E6E6FF;}
		</style>
		<table height="100%" width="100%" cellspacing="0" cellpadding="0">
			<tr class="color-border">
				<td valign="top"> 
				<table height="100%" width="100%" cellspacing="1" cellpadding="2">
					<tr class="color-list">
						<td height="35" class="headbold">&nbsp;&nbsp;<cf_get_lang_main no='100.Workcube E-Mail'></td>
					</tr>
					<tr class="color-row" valign="top" style="height:30px;">
						<td align="center" class="headbold"><cf_get_lang_main no='101.Mail Başarıyla Gönderildi'></td>
					</tr>
					<tr id="error_list_tr" style="display:none" class="color-row">
						<td>
						<textarea id="send_error_list" name="send_error_list" style="width:380px;height:350px;" onclick="this.select();"></textarea>
						<input type="hidden" name="is_error" id="is_error" value="0" />
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
	</cfif>
	<cfif isdefined('attributes.target_mass_other')>
		<cfif len(consumer_not_send_list)>
		<cfquery name="Get_Consumer_Users" datasource="#dsn#">
		SELECT
			1 AS TYPE,
			CONSUMER_ID AS USER_ID,
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			CONSUMER_EMAIL AS USER_EMAIL 
		FROM
			CONSUMER
		WHERE
			WANT_EMAIL = 1 AND
			(
					CONSUMER_ID IN (#consumer_not_send_list#)
			)
		</cfquery>
		<cfif IsDefined("Get_Consumer_Users")>
			<cfloop query="Get_Consumer_Users">
				<cfif Len(user_email)>
					<cfset receiver = "#consumer_name# #consumer_surname#">
					<cftry>
							<cfmail from="#from_adress_#" to="#user_email#" failto="#get_empleyee_email.employee_email#" subject="#email_cont.email_subject#" type="html">
								<cfset attributes.email_address = user_email>
								<cfset attributes.user_type = "user_id">
								<cfset attributes.user_id = user_id>
								<cfset attributes.consumer_id = user_id>
								<cfset attributes.username_surname = consumer_name & ' ' & consumer_surname>
								<cfinclude template="get_send_camp_emails_content.cfm">
							</cfmail>
							<cfquery name="add_send_to_consumer" datasource="#dsn#">
								INSERT INTO
									SEND_CONTENTS
									(
										CONT_ID,
										CONT_TYPE,
										SEND_CON,
										SEND_DATE,
										RECORD_IP,
										SENDER_EMP,
										CAMP_ID,
										COUNT
									)
								VALUES
									(
										#attributes.email_cont_id#,
										1,
										#user_id#,
										#now()#,
										'#cgi.remote_addr#',
										#session.ep.userid#,
										#attributes.camp_id#,
										#count#
									)
							</cfquery>
						<cfcatch type="any">
							<cfset consumer_error_list = ListAppend(consumer_error_list,USER_ID,',')>
						</cfcatch>
						</cftry>
				</cfif>
			</cfloop>
		</cfif>
		</cfif>
		<cfif len(partner_not_send_list)>
			<cfquery name="Get_Partner_Users" datasource="#dsn#">
				SELECT
					2 AS TYPE,
					PARTNER_ID AS USER_ID,
					COMPANY_PARTNER_NAME,
					COMPANY_PARTNER_SURNAME,
					COMPANY_PARTNER_EMAIL AS USER_EMAIL 
				FROM
					COMPANY_PARTNER
				WHERE
					WANT_EMAIL = 1 AND
					(
							PARTNER_ID IN (#partner_not_send_list#)
					)
			</cfquery>
		<cfif IsDefined("Get_Partner_Users")>
			<cfloop query="Get_Partner_Users">
				<cfif len(Get_Partner_Users.user_email)>
					<cfset receiver = "#company_partner_name# #company_partner_surname#">
						<cftry> 
						<cfmail from="#from_adress_#" to="#user_email#" failto="#get_empleyee_email.employee_email#" subject="#email_cont.email_subject#" type="HTML">
							<cfset attributes.email_address = user_email>
							<cfset attributes.user_type = "user_id">
							<cfset attributes.user_id = user_id>
							<cfset attributes.partner_id = user_id>
							<cfset attributes.username_surname = company_partner_name & ' ' & company_partner_surname>
							<cfinclude template="get_send_camp_emails_content.cfm">
						</cfmail>
						<cfquery name="add_send_to_partner" datasource="#dsn#">
							INSERT INTO
								SEND_CONTENTS
								(
									CONT_ID,
									CONT_TYPE,
									SEND_PAR,
									SEND_DATE,
									RECORD_IP,
									SENDER_EMP,
									CAMP_ID,
									COUNT
								)
							VALUES
								(
									#attributes.email_cont_id#,
									1,
									#user_id#,
									#now()#,
									'#cgi.remote_addr#',
									#session.ep.userid#,
									#attributes.camp_id#,
									#count#
								)
						</cfquery>
						<cfcatch type="any">
							<cfset partner_error_list = ListAppend(partner_error_list,USER_ID,',')>
						</cfcatch>
						</cftry> 
				</cfif>
			</cfloop>
		</cfif>
		</cfif>
	</cfif>
	<!--- Mail Gonderildi Bilgisi --->
	<cf_popup_box title="#getLang('campaign',43)#">
	<table width="100%">
		<tr height="300">
			<td class="formbold" style="text-align:center"><cf_get_lang_main no='101.Mail Başarıyla Gönderildi'></td>
		</tr>
		<tr id="error_list_tr" style="display:none; vertical-align:top;" class="color-row">
			<td>
			<textarea id="send_error_list" name="send_error_list" style="width:380px;height:350px;" onclick="this.select();"></textarea>
			<input type="hidden" name="is_error" id="is_error" value="0" />
			</td>
		</tr>
	</table>
	</cf_popup_box>

	<cfif IsDefined("attributes.target_mass_other")>
	<!---Daha önce gönderilen bireysel üyelerde uyarı vermesi için--->
		<cfif len(consumer_send_list)>
			<cfquery name="get_consumer_send_list" datasource="#DSN#">
				SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_send_list#)
			</cfquery>
			<cfif get_consumer_send_list.recordcount>
				<script type="text/javascript">
					document.error_list_tr.style.display='';
					<cfoutput query="get_consumer_send_list">
						document.getElementById('send_error_list').value += '\n#currentrow# - #consumer_name# #consumer_surname#\n İsimli BİREYSEL Üyelere daha önce mail gönderildiğinden tekrar gönderim yapılmadı..';
					</cfoutput>
				</script>
			</cfif>
		</cfif>
		<!---Daha önce gönderilen kurumsal üyelerde uyarı vermesi için--->
		<cfif len(partner_send_list)>
			<cfquery name="get_consumer_send_list" datasource="#DSN#"><!--- Gönderim sırasında hata oluşuş olan kurumsal üyeleri gösteriyor. --->
				SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#partner_send_list#)
			</cfquery>
			<cfif get_consumer_send_list.recordcount>
				<script type="text/javascript">
					document.getElementById('error_list_tr').style.display='';
					<cfoutput query="get_consumer_send_list">
					document.getElementById('send_error_list').value += '\n#currentrow# - #company_partner_name# #company_partner_surname# / #company_partner_email#\n İsimli KURUMSAL Üyelere daha önce mail gönderildiğinden tekrar gönderim yapılmadı...';
					</cfoutput>
				</script>
			</cfif>
		</cfif>
	</cfif>
	<cfif isdefined('attributes.target_mass')>
			<!---Daha önce gönderilen hedef kitledeki bireysel üyelerde uyarı vermesi için--->
			<cfif len(consumer_send_target_list)>
				<cfquery name="get_consumer_send_target_list" datasource="#DSN#">
					SELECT CONSUMER_NAME, CONSUMER_SURNAME,CONSUMER_EMAIL FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_send_target_list#)
				</cfquery>
				<cfif get_consumer_send_target_list.recordcount>
					<script type="text/javascript">
						document.getElementById('error_list_tr').style.display='';
						<cfoutput query="get_consumer_send_target_list">
							document.getElementById('send_error_list').value += '\n#currentrow# - #consumer_name# #consumer_surname# / #consumer_email# \n İsimli Hedef Kitledeki BİREYSEL Üyelere daha önce mail gönderildiğinden tekrar gönderim yapılmadı..';
						</cfoutput>
					</script>
				</cfif>
			</cfif>
			<!---Daha önce gönderilen hedef kitledeki kurumsal üyelerde uyarı vermesi için--->
			<cfif len(partner_send_target_list)>
				<cfquery name="get_partner_send_target_list" datasource="#DSN#">
					SELECT C.NICKNAME,CP.COMPANY_PARTNER_NAME, CP.COMPANY_PARTNER_SURNAME,CP.COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER CP,COMPANY C WHERE C.COMPANY_ID = CP.COMPANY_ID AND CP.PARTNER_ID IN (#partner_send_target_list#)
				</cfquery>
				<cfif get_partner_send_target_list.recordcount>
					<script type="text/javascript">
						document.getElementById('error_list_tr').style.display='';
						<cfoutput query="get_partner_send_target_list">
							document.getElementById('send_error_list').value += '\n#currentrow# - #nickname# #company_partner_name# #company_partner_surname# / #company_partner_email#\n İsimli Hedef Kitledeki KURUMSAL Üyelere daha önce mail gönderildiğinden tekrar gönderim yapılmadı..';
						</cfoutput>
					</script>
				</cfif>
			</cfif>
	</cfif>
	<!--- Gonderimde Olusan Hatalar Gosteriliyor --->
	<cfif len(consumer_error_list)>
		<cfquery name="get_consumer_error_list" datasource="#DSN#">
			SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_EMAIL FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_error_list#)
		</cfquery>
		<cfif get_consumer_error_list.recordcount>
			<script type="text/javascript">
				document.getElementById('error_list_tr').style.display='';
				<cfoutput query="get_consumer_error_list">
					document.getElementById('send_error_list').value += '\n#currentrow# - #consumer_name# #consumer_surname# / #consumer_email#\n İsimli BİREYSEL Üyelere Mail Gönderimi Yapılamadı,Üye Bilgilerini Kontrol Ediniz..';
				</cfoutput>
			</script>
		</cfif>
	</cfif>
	<cfif len(partner_error_list)>
		<cfquery name="get_partner_error_list" datasource="#DSN#"><!--- Gönderim sırasında hata oluşmuş olan kurumsal üyeleri gösteriyor. --->
			SELECT C.NICKNAME,CP.COMPANY_PARTNER_NAME,CP.COMPANY_PARTNER_SURNAME,CP.COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER CP,COMPANY C WHERE C.COMPANY_ID = CP.COMPANY_ID AND CP.PARTNER_ID IN (#partner_error_list#)
		</cfquery>

		<cfif get_partner_error_list.recordcount>
			<script type="text/javascript">
				document.getElementById('error_list_tr').style.display='';
				document.getElementById('send_error_list').value += '\nAşağıdaki KURUMSAL Üyelere Mail Gönderimi Yapılamadı,Üye Bilgilerini Kontrol Ediniz..\n';
				<cfoutput query="get_partner_error_list">
					document.getElementById('send_error_list').value += '\n#currentrow# - #nickname# #company_partner_name# #company_partner_surname# / #company_partner_email# \n';
				</cfoutput>
				<!--- alert('<cfoutput query="get_partner_error_list">\n#currentrow# - #company_partner_name# #company_partner_surname#</cfoutput>\n İsimli KURUMSAL Üyelere Mail Gönderimi Yapılamadı,Üye Bilgilerini Kontrol Ediniz..'); --->
			</script>
		</cfif>
	</cfif>
	<script type="text/javascript">
		function waitfor()
		{
			if(document.getElementById('error_list_tr').style.display == 'none')
			{
				wrk_opener_reload();
				window.close();
			}
		}
		setTimeout("waitfor()",1000);
	</script>
<cfelse>
	<script type="text/javascript">
		wrk_opener_reload();
		alert("<cf_get_lang_main no='206.Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz'>");
		window.close();
		history.go(-1);
	</script>
</cfif>
----->