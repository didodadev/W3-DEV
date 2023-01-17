<!---
    File: einvoice_receive_invoices_BIST.cfm
    Folder: V16\e_government\query\
	Controller: 
    Author: Gramoni-Mahmut
    Date: 14.01.2020 16:05
    Description:
		MKK için Dijital Planet gelen e-fatura aktarımı
		Göndere VKN den firma tipine göre süreç aşama ve departman dağıtım işlemi yapar.
    History:
        
    To Do:

--->

<cfscript>
	get_einv_comp_tmp= createObject("component","V16.e_government.cfc.einvoice");
	get_einv_comp_tmp.dsn = dsn;
	get_einv_comp = get_einv_comp_tmp.get_our_company_fnc(einvoice_type:3);
</cfscript>
<cfloop query="GET_EINV_COMP">
	<cfquery name="GET_ADMIN" datasource="#DSN#">
        SELECT ADMIN_MAIL,COMPANY_NAME FROM OUR_COMPANY WHERE ADMIN_MAIL IS NOT NULL AND COMP_ID = #get_einv_comp.comp_id#
    </cfquery>
    <cfquery name="get_process_row" datasource="#dsn#">
        SELECT 
            PTR.PROCESS_ROW_ID 
        FROM 
            PROCESS_TYPE PT, 
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO
        WHERE 
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_einv_comp.comp_id#">  AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects.popup_dsp_efatura_detail%"> AND 
            PTR.LINE_NUMBER = 1
    </cfquery>   
    
    <cfif get_process_row.recordcount eq 0>
		<br /><cfoutput>(#get_admin.company_name#)</cfoutput> Şirketinde Gelen E-Fatura Süreçlerini Kontrol Ediniz. <cfabort>
    </cfif>

	<!--- Ticket almak icin gerekli XML formati hazirlaniyor --->
	<cfxml variable="ticket_data"><cfoutput>
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
	<soapenv:Header/>
	<soapenv:Body>
		<tem:GetFormsAuthenticationTicket>
			<tem:CorporateCode>#get_einv_comp.EINVOICE_COMPANY_CODE#</tem:CorporateCode>
			<tem:LoginName>#get_einv_comp.EINVOICE_USER_NAME#</tem:LoginName>
			<tem:Password><![CDATA[#get_einv_comp.EINVOICE_PASSWORD#]]></tem:Password>
		</tem:GetFormsAuthenticationTicket>
	</soapenv:Body>
	</soapenv:Envelope></cfoutput>
	</cfxml>

    <cfif get_einv_comp.einvoice_test_system eq 1>
        <cfset dp_url = 'https://IntegrationServiceWithoutMtomtest.eveelektronik.com.tr/Integrationservice.asmx'>
    <cfelse>
        <cfset dp_url = 'https://integrationservicewithoutmtom.digitalplanet.com.tr/IntegrationService.asmx'>
    </cfif>

	<!--- Fatura kaydetmek icin gerekli tek seferlik ticket alınıyor ---> 
	<cfhttp url="#dp_url#" method="post" result="httpResponse">
		<cfhttpparam type="header" name="content-type" value="text/xml">
		<cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetFormsAuthenticationTicket">
		<cfhttpparam type="header" name="content-length" value="#len(ticket_data)#">
		<cfhttpparam type="header" name="charset" value="utf-8">
		<cfhttpparam type="xml" name="message" value="#trim(ticket_data)#">
	</cfhttp>

	<cfset Ticket = xmlParse(httpResponse.filecontent)>
	<cfset Ticket = Ticket.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText>
	
	<!--- GetAvailableInvoices fonksiyonu icin gerekli xml olusturuluyor --->
	<cfxml variable="invoice_data"><cfoutput>
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
	   <soapenv:Header/>
	   <soapenv:Body>
		  <tem:GetAvailableInvoices>
			 <tem:Ticket>#Ticket#</tem:Ticket>
			 <tem:CorporateCode>#get_einv_comp.einvoice_company_code#</tem:CorporateCode>
		  </tem:GetAvailableInvoices>
	   </soapenv:Body>
	</soapenv:Envelope></cfoutput>
	</cfxml>

	<!--- Gelen Faturalar Kontrol ediliyor --->
	<cfhttp url="#dp_url#" method="post" result="GetAvailableInvoices">
		<cfhttpparam type="header" name="content-type" value="text/xml">
		<cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetAvailableInvoices">
		<cfhttpparam type="header" name="content-length" value="#len(invoice_data)#">
		<cfhttpparam type="header" name="charset" value="utf-8">
		<cfhttpparam type="xml" name="message" value="#trim(invoice_data)#">
	</cfhttp>

	<cfset ServiceResultDescription = trim(XMLParse(GetAvailableInvoices.filecontent).Envelope.Body.GetAvailableInvoicesResponse.GetAvailableInvoicesResult.ServiceResultDescription.xmlText)>
	<cfif not len(ServiceResultDescription)>
		<cftry>
			<cfset invoice_count = arraylen(XMLParse(GetAvailableInvoices.filecontent).Envelope.Body.GetAvailableInvoicesResponse.GetAvailableInvoicesResult.Invoices.InvoiceInfoResult)>
        <cfcatch>
        	<cfoutput>#ServiceResultDescription#</cfoutput>
        </cfcatch>
		</cftry>
        
		<cfloop from="1" to="#invoice_count#" index="invoice_index">
	
			<cfset Invoices = XMLParse(GetAvailableInvoices.filecontent).Envelope.Body.GetAvailableInvoicesResponse.GetAvailableInvoicesResult.Invoices.InvoiceInfoResult[invoice_index]>
			<cfset directory_name = "#upload_folder#einvoice_received/#get_einv_comp.comp_id#/#year(now())#/#numberformat(month(now()),00)#">

		   <cfxml variable="SOAP_GetInvoice"><cfoutput>
			<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
			   <soapenv:Header/>
			   <soapenv:Body>
				  <tem:GetInvoice>
					 <tem:Ticket>#Ticket#</tem:Ticket>
					 <tem:UUID>#Invoices.UUID.xmltext#</tem:UUID>
				  </tem:GetInvoice>
			   </soapenv:Body>
			</soapenv:Envelope></cfoutput>
			</cfxml>
            
			<!--- Gelen faturaları sisteme kaydetme --->
			<cfhttp url="#dp_url#" method="post" result="GetInvoice">
				<cfhttpparam type="header" name="content-type" value="text/xml">
				<cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetInvoice">
				<cfhttpparam type="header" name="content-length" value="#len(SOAP_GetInvoice)#">
				<cfhttpparam type="header" name="charset" value="utf-8">
				<cfhttpparam type="xml" name="message" value="#trim(SOAP_GetInvoice)#">
			</cfhttp>

            <cftry>
				<cfset Invoice_ID = XMLParse(GetInvoice.filecontent).Envelope.Body.GetInvoiceResponse.GetInvoiceResult.InvoiceId.xmlText>
                <cfset temp_base64 = XMLParse(GetInvoice.filecontent).Envelope.Body.GetInvoiceResponse.GetInvoiceResult.ReturnValue.xmlText>
                <cfset temp_UUID = XMLParse(GetInvoice.filecontent).Envelope.Body.GetInvoiceResponse.GetInvoiceResult.UUID.xmlText>
                <cfset temp_IssueDate = XMLParse(GetInvoice.filecontent).Envelope.Body.GetInvoiceResponse.GetInvoiceResult.IssueDate.xmlText>
                <cfcatch>
                    <cfset Invoice_ID = ''>
                    <cfset temp_base64 = ''>
                    <cfset temp_UUID = ''>
                    <cfset temp_IssueDate = ''>
                </cfcatch>
            </cftry>
            <cftry>
				<!--- Fatura degerlerine ulasilamadigi durumlar icin eklendi BK 20130311 --->
                <cfif len(Invoice_ID)>
					<cfif not DirectoryExists(directory_name)>
                        <cfdirectory action="create" directory="#directory_name#">
                    </cfif>
					<cfquery name = "getPeriod" datasource = "#dsn#">
						SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #get_einv_comp.comp_id# AND '#temp_IssueDate#' BETWEEN START_DATE AND FINISH_DATE
					</cfquery>
					<cfset dsn2 = '#dsn#_#getPeriod.period_year#_#get_einv_comp.comp_id#'>
                    <cffile action="write" file="#directory_name#/#temp_UUID#.xml" output="#toString(tobinary(temp_base64))#" charset="utf-8" />
                    <cfquery name="INVOICE_CONTROL" datasource="#DSN2#">
                    	SELECT 1 FROM EINVOICE_RECEIVING_DETAIL WHERE UUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Invoices.UUID.xmltext#">
                    </cfquery>
                    <!--- IS_APPROVE alanı fatura Kaydet butonunun gelmesi icin düzenlendi--->
                    <cfif not invoice_control.recordcount>
                    	<cfscript>
							add_invoice_receive_temp = CreateObject("component","V16.e_government.cfc.einvoice");
							add_invoice_receive_temp.dsn	= dsn;
							add_invoice_receive_temp.dsn2	= dsn2;
							if(get_einv_comp.is_receiving_process eq 1) is_approve = 0; else is_approve = 1;
							received_invoice_id	= add_invoice_receive_temp.add_received_invoices(service_result:Invoices.ServiceResult.xmltext,
																			uuid:Invoices.UUID.xmltext,
																			einvoice_id:Invoices.InvoiceId.xmltext,
																			status_description:Invoices.StatusDescription.xmltext,
																			status_code:Invoices.StatusCode.xmltext,
																			error_code:Invoices.ErrorCode.xmltext,
																			invoice_type_code:Invoices.Invoicetypecode.xmltext,
																			sender_tax_id:Invoices.Sendertaxid.xmltext,
																			receiver_tax_id:Invoices.Receivertaxid.xmltext,
																			profile_id:Invoices.Profileid.xmltext,
																			payable_amount:Replace(Invoices.Payableamount.xmltext,",","."),
																			payable_amount_currency:Invoices.DocumentCurrency.xmltext,
																			issue_date:Replace(Invoices.Issuetime.xmltext,'T',' '),
																			party_name:Invoices.Partyname.xmltext,
																			process_stage:get_process_row.process_row_id,
																			einvoice_type:get_einv_comp.einvoice_type,
																			is_approve:is_approve,
																			company_id:get_einv_comp.comp_id);
						</cfscript>
						<cfquery name="get_received_invoice" datasource="#dsn2#">
							SELECT RECEIVING_DETAIL_ID, PATH FROM EINVOICE_RECEIVING_DETAIL WHERE RECEIVING_DETAIL_ID = #received_invoice_id.IDENTITYCOL#
						</cfquery>
						<cfscript>
							if(get_received_invoice.recordCount){
								invoice_stage	= get_process_row.process_row_id;
								department_id	= 0;
								position_ids	= '';//Faturayı görebilecek Pozisyon idler
								invoice_path	= expandPath('documents' & dir_seperator & get_received_invoice.PATH);
								if (fileExists(invoice_path)) {
									invoice_file	= fileRead(invoice_path);
									if (isXML(invoice_file)) {
										//VKN tespit
										invoice_vkn	= xmlParse(invoice_file).Invoice.AccountingSupplierParty.Party.PartyIdentification.ID.xmlText;
										if (Len(invoice_vkn)) {
											get_sender	= add_invoice_receive_temp.get_received_invoice_company(VKN:invoice_vkn);
											if (get_sender.RecordCount And Len(get_sender.FIRM_TYPE)) {
												company_firm_type	= listFirst(get_sender.FIRM_TYPE);
												if (company_firm_type Eq 1) {
													invoice_stage	= 84;
													department_id	= 26;
												}
												else if (company_firm_type Eq 2) {
													invoice_stage	= 85;
													position_id		= ',11,41,';
												}
												else if (company_firm_type Eq 3) {
													invoice_stage	= 86;
													department_id	= 24;
												}
												else if (company_firm_type Eq 4) {
													invoice_stage	= 87;
													department_id	= 24;
												}
												else {
													department_id	= 29;//Muhasebe
												}
											}
										}
										add_invoice_receive_temp.upd_received_invoice(dsn2_name:dsn2,receiving_id:get_received_invoice.RECEIVING_DETAIL_ID,process_stage:invoice_stage,department_id:department_id,position_ids:position_ids);
									}
								}
							}
						</cfscript>
						<cfquery name="get_received_invoice_info" datasource="#dsn2#">
							SELECT PROCESS_STAGE FROM EINVOICE_RECEIVING_DETAIL WHERE RECEIVING_DETAIL_ID = #get_received_invoice.RECEIVING_DETAIL_ID#
						</cfquery>
						<cf_workcube_process
							is_upd='1'
							data_source='#dsn2#'
							old_process_line='0'
							process_stage='#get_received_invoice_info.PROCESS_STAGE#'
							record_member='1'
							record_date='#now()#'
							action_table='EINVOICE_RECEIVING_DETAIL'
							action_column='RECEIVING_DETAIL_ID'
							action_id='#get_received_invoice.RECEIVING_DETAIL_ID#'
							action_page='#request.self#?fuseaction=objects.popup_dsp_efatura_detail&action_id=#get_received_invoice.RECEIVING_DETAIL_ID#'
							warning_description="#getLang('','Gelen E-Fatura',47112)# : #Invoice_ID#">
                    </cfif>
                </cfif>
            <cfcatch>
				<cfmail from="#get_admin.admin_mail#" to="e-entegrasyon@workcube.com" subject="Gelen e-Fatura Çoklu Hata" type="html">
					<cfoutput>(#get_admin.company_name#)</cfoutput> Fatura Kaydı Sırasında Bir Hata Meydana Geldi !<br />
					UUID      : '#Invoices.UUID.xmltext#'<br />
					Invoice Id: '#Invoices.InvoiceId.xmltext#'
                    <cfdump var="#cfcatch#">
				</cfmail>
                <cfdump var="#cfcatch#"><cfabort>
            </cfcatch>
            </cftry>
		</cfloop>
        <cfoutput>(#get_admin.company_name#)</cfoutput> Faturalar Başarılı Bir Şekilde Kayıt Edildi<br />
	<cfelse>    
		<cfoutput>(#get_admin.company_name#)</cfoutput> Şirketinde Fatura bulunamadı.<br />
	</cfif>
</cfloop>