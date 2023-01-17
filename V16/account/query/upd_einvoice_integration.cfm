<cfsetting showdebugoutput="yes">
<cfif isDefined('attributes.form1_submitted')>
	<cfscript>
		einvoice = createObject("Component","V16.e_government.cfc.einvoice");
		einvoice.dsn = dsn;
		einvoice.dsn2 = dsn2;
		if(isdefined('attributes.einvoice_test_system')) einvoice_test_system = 1; else einvoice_test_system = 0;
		if(isdefined('attributes.is_receiving_process')) is_receiving_process = 1; else is_receiving_process = 0;
		if(isdefined('attributes.special_period')) special_period = 1; else special_period = 0;
		if(isdefined('attributes.multiple_prefix')) multiple_prefix = 1; else multiple_prefix = 0;
		einvoice.upd_our_company_info(
								einvoice_test_system:einvoice_test_system,
								einvoice_signature_url:attributes.einvoice_signature_url,
								einvoice_company_code:attributes.einvoice_company_code,
								einvoice_user_name:attributes.einvoice_user_name,
								einvoice_password:attributes.einvoice_password,
								einvoice_sender_alias:attributes.einvoice_sender_alias,
								einvoice_receiver_alias:attributes.einvoice_receiver_alias,
								einvoice_prefix:attributes.einvoice_prefix,
								einvoice_number:attributes.einvoice_number,
								einvoice_ublversion:attributes.einvoice_ublversion,
								is_receiving_process:is_receiving_process,
								einvoice_template:'#iif(isdefined("attributes.einvoice_template"),"attributes.einvoice_template",DE(""))#',
								save_folder:'#iif(isdefined("attributes.save_folder"),"attributes.save_folder",DE(""))#',
								del_template:'#iif(isdefined("attributes.del_template"),"attributes.del_template",DE(""))#',
								special_period:special_period,
								multiple_prefix:'#multiple_prefix#',
								einvoice_type_alias : '#attributes.einvoice_type_alias#');
	</cfscript>
	<!--- Digital Planet icin Dosya olusuyor--->
	<cfif attributes.einvoice_type eq 3 and attributes.einvoice_type_alias eq 'dp'>
		<!--- Ticket almak icin gerekli XML formati hazirlaniyor --->
		<cfxml variable="ticket_data"><cfoutput>
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
		<soapenv:Header/>
		<soapenv:Body>
			<tem:GetFormsAuthenticationTicket>
				<tem:CorporateCode>#attributes.EINVOICE_COMPANY_CODE#</tem:CorporateCode>
				<tem:LoginName>#attributes.EINVOICE_USER_NAME#</tem:LoginName>
				<tem:Password><![CDATA[#attributes.EINVOICE_PASSWORD#]]></tem:Password>
			</tem:GetFormsAuthenticationTicket>
		</soapenv:Body>
		</soapenv:Envelope></cfoutput>
		</cfxml>
		<cfif einvoice_test_system eq 1>
			<cfset dp_url = 'https://IntegrationServiceWithoutMtomtest.eveelektronik.com.tr/integrationservice.asmx'>
		<cfelse>
			<cfset dp_url = 'https://integrationservicewithoutmtom.digitalplanet.com.tr/IntegrationService.asmx'>
		</cfif>
		<!--- Mükellef listesi icin gerekli tek seferlik ticket alınıyor ---> 
		<cfhttp url="#dp_url#" method="post" result="httpResponse">
			<cfhttpparam type="header" name="content-type" value="text/xml">
			<cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetFormsAuthenticationTicket">
			<cfhttpparam type="header" name="content-length" value="#len(ticket_data)#">
			<cfhttpparam type="header" name="charset" value="utf-8">
			<cfhttpparam type="xml" name="message" value="#trim(ticket_data)#">
		</cfhttp>
		<cfset Ticket = xmlParse(httpResponse.filecontent)>
		<cfset Ticket = Ticket.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText>
		<cfif not len(Ticket)>
			<script type="text/javascript">
				alert("Dijital Planet Kullanıcı Bilgilerinizi Kontrol Ediniz. Ticket Alınamadı! ");
				history.back();
			</script>
		</cfif>
	</cfif>
</cfif>

<!--- Üye şablonları --->
<cfif isDefined('attributes.form2_submitted')>
	<cfif isDefined("attributes.record_num") and len(attributes.record_num)>
		<cfset template_folder	= "#upload_folder#e_government#dir_seperator#xslt" />
		<cfif not directoryExists(template_folder)>
			<cfdirectory action = "create" directory="#template_folder#" />
		</cfif>
		<cffile action="uploadall" destination="#template_folder#" nameconflict="MakeUnique" strict="true" allowedextensions=".xslt" result="fileUploaded" />
		<cfset file_index = 1 />
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfscript>
				ref_template_id	= evaluate("attributes.template_id#i#");
				ref_company_id	= evaluate("attributes.company_id#i#");
				ref_consumer_id = evaluate("attributes.consumer_id#i#");
			</cfscript>
			<!--- Ekleme işlemi --->
			<cfif evaluate("attributes.row_control#i#") Eq 1>
				<cfquery name="get_member" datasource="#dsn3#">
					SELECT
						1
					FROM
						EINVOICE_TEMPLATES
					WHERE
						1=1 AND
						<cfif Len(ref_company_id)>COMPANY_ID = #ref_company_id#</cfif>
						<cfif Len(ref_consumer_id)>CONSUMER_ID = #ref_consumer_id#</cfif>
				</cfquery>
				<cfif get_member.recordCount>
					<script>
						alert("<cfoutput>#evaluate("attributes.ch_company#i#")#</cfoutput> için sistemde kayıt mevcut, aynı üye için yalnızca 1 adet şablon yükleyebilirsiniz!");
					</script>
				<cfelse>
					<cfset ref_template	= evaluate("attributes.template#i#") />
					<cftry>
						<cfset file_name = lCase(createUUID()) />
						<cffile action="read" file="#ref_template#" variable="xslt_output" charset="utf-8" />
						<cffile action="write" file="#template_folder##dir_seperator##file_name#.xslt" output="#trim(xslt_output)#" charset="utf-8" />
						<cfset xslt64_output = ToBase64(xslt_output) />
						<cffile action="write" file="#template_folder##dir_seperator##file_name#_base64.xslt" output="#trim(xslt64_output)#" charset="utf-8" />
						<cffile action="delete" file="#fileUploaded[file_index].serverdirectory##dir_seperator##fileUploaded[file_index].serverfile#" />
						<cfset file_index = file_index + 1 />
						<cfcatch type="Any">
						<script>
							alert("<cf_get_lang dictionary_id='59966.Dosya Yükleme İle İlgili Bir Sorun Oluştu'>!");
							history.back();
						</script>
						<cfexit method="exittemplate" />
						</cfcatch>
					</cftry>
					<cfquery datasource="#dsn3#">
						INSERT INTO
							EINVOICE_TEMPLATES
						(
							COMPANY_ID,
							CONSUMER_ID,
							TEMPLATE_PATH,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE
						)
							VALUES
						(
							<cfif Len(ref_company_id)>#ref_company_id#<cfelse>NULL</cfif>,
							<cfif Len(ref_consumer_id)>#ref_consumer_id#<cfelse>NULL</cfif>,
							'#file_name#',
							<cfif isDefined('session.ep.userid')>#session.ep.userid#<cfelse>1</cfif>,
							'#CGI.REMOTE_ADDR#',
							#Now()#
						)
					</cfquery>
				</cfif>
			</cfif>

			<!--- Silme işlemi --->
			<cfif evaluate("attributes.row_control#i#") Eq 0 And Len(ref_template_id)>
				<cfquery name="get_template" datasource="#dsn3#">
					SELECT TEMPLATE_PATH FROM EINVOICE_TEMPLATES WHERE TEMPLATE_ID = #ref_template_id#
				</cfquery>
				<cfquery datasource="#dsn3#">
					DELETE EINVOICE_TEMPLATES WHERE TEMPLATE_ID = #ref_template_id#
				</cfquery>
				<cftry>
					<cffile action="delete" file="#template_folder##dir_seperator##get_template.TEMPLATE_PATH#.xslt" />
					<cffile action="delete" file="#template_folder##dir_seperator##get_template.TEMPLATE_PATH#_base64.xslt" />
					<cfcatch type="Any"></cfcatch>  
				</cftry>
			</cfif>
		</cfloop>
	</cfif>
</cfif>

<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=account.einvoice_integration_definitions</cfoutput>';
</script>