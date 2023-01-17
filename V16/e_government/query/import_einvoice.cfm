<!---
    File: import_einvoice.cfm
    Folder: V16\e_government\query\
	Controller: 
    Author: Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com
    Date: 2020-03-31 00:13:27 
    Description:
		Entegratör portalına Workcube haricinde kayıt edilmiş bir fatura ile Workcubede kayıtlı faturayı ilişkilendirmek için kullanılır.
    History:
        
    To Do:

--->

<cfif Not reFindNoCase("([0-9A-Z]{8})+\-([0-9A-Z]{4})+\-([0-9A-Z]{4})+\-([0-9A-Z]{4})+\-([0-9A-Z]{12})", attributes.invoice_uuid)>
	<script type="text/javascript">
		alert("Geçerli bir UUID değeri girmelisiniz!");
		history.back();
	</script>
	<cfabort />
</cfif>

<cfscript>
	einvoice			= createObject("component","V16.e_government.cfc.einvoice");
	einvoice.dsn		= dsn;
	einvoice.dsn2		= dsn2;
	einvoice_company	= einvoice.get_our_company_fnc(company_id:session.ep.company_id);
	einvoice_relation	= einvoice.get_invoice_relation_uuid(uuid:attributes.invoice_uuid, invoice_type:attributes.invoice_type);
</cfscript>

<cfif einvoice_relation.recordcount>
	<script type="text/javascript">
		alert("Girilen UUID ile sistemde başka bir fatura için ilişki kaydı mevcut!");
		history.back();
	</script>
	<cfabort />
</cfif>

<cfset error_detail = '' />

<cfif einvoice_company.einvoice_type eq 3><!--- DP--->
	<cfif einvoice_company.einvoice_test_system eq 1>
		<cfset web_service_url = 'https://IntegrationServiceWithoutMtomtest.eveelektronik.com.tr/IntegrationService.asmx'>
	<cfelse>
		<cfset web_service_url = 'https://integrationservicewithoutmtom.digitalplanet.com.tr/IntegrationService.asmx'>
	</cfif>

	<!--- Ticket --->
	<cfxml variable="ticket_data"><cfoutput>
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
	<soapenv:Header/>
	<soapenv:Body>
		<tem:GetFormsAuthenticationTicket>
			<tem:CorporateCode>#einvoice_company.EINVOICE_COMPANY_CODE#</tem:CorporateCode>
			<tem:LoginName>#einvoice_company.EINVOICE_USER_NAME#</tem:LoginName>
			<tem:Password><![CDATA[#einvoice_company.EINVOICE_PASSWORD#]]></tem:Password>
		</tem:GetFormsAuthenticationTicket>
	</soapenv:Body>
	</soapenv:Envelope></cfoutput>
	</cfxml>

	<cfhttp url="#web_service_url#" method="post" result="ticket_response">
		<cfhttpparam type="header" name="content-type" value="text/xml">
		<cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetFormsAuthenticationTicket">
		<cfhttpparam type="header" name="content-length" value="#len(ticket_data)#">
		<cfhttpparam type="header" name="charset" value="utf-8">
		<cfhttpparam type="xml" name="message" value="#trim(ticket_data)#">
	</cfhttp>

	<cfset Ticket = xmlParse(ticket_response.filecontent).Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText />

	<cfif attributes.invoice_type is 'einvoice'>
		<cfsavecontent variable="invoice_data"><cfoutput>
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
		<soapenv:Header/>
		<soapenv:Body>
			<tem:GetInvoice>
				<tem:Ticket>#Ticket#</tem:Ticket>
				<tem:UUID>#attributes.invoice_uuid#</tem:UUID>
			</tem:GetInvoice>
		</soapenv:Body>
		</soapenv:Envelope></cfoutput>
		</cfsavecontent>

		<cfhttp url="#web_service_url#" method="post" result="invoice_response">
			<cfhttpparam type="header" name="content-type" value="text/xml">
			<cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetInvoice">
			<cfhttpparam type="header" name="content-length" value="#len(invoice_data)#">
			<cfhttpparam type="header" name="charset" value="utf-8">
			<cfhttpparam type="xml" name="message" value="#trim(invoice_data)#">
		</cfhttp>
	<cfelseif attributes.invoice_type is 'earchive'>
		<cfsavecontent variable="invoice_data"><cfoutput>
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
		<soapenv:Header/>
		<soapenv:Body>
			<tem:GetEArchiveInvoice>
				<tem:Ticket>#Ticket#</tem:Ticket>
				<tem:Value>#attributes.invoice_uuid#</tem:Value>
				<tem:ValueType>UUID</tem:ValueType>
				<tem:FileType>XML</tem:FileType>
			</tem:GetEArchiveInvoice>
		</soapenv:Body>
		</soapenv:Envelope></cfoutput>
		</cfsavecontent>

		<cfhttp url="#web_service_url#" method="post" result="invoice_response">
			<cfhttpparam type="header" name="content-type" value="text/xml">
			<cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetEArchiveInvoice">
			<cfhttpparam type="header" name="content-length" value="#len(invoice_data)#">
			<cfhttpparam type="header" name="charset" value="utf-8">
			<cfhttpparam type="xml" name="message" value="#trim(invoice_data)#">
		</cfhttp>
	</cfif>

	<cfif isXML(invoice_response.filecontent)>
		<cfscript>
			if (attributes.invoice_type is 'einvoice') {
				invoice_result	= xmlParse(invoice_response.filecontent).Envelope.Body.GetInvoiceResponse.GetInvoiceResult;
			}
			else if (attributes.invoice_type is 'earchive') {
				invoice_result	= xmlParse(invoice_response.filecontent).Envelope.Body.GetEArchiveInvoiceResponse.GetEArchiveInvoiceResult;
			}

			ErrorCode					= invoice_result.ErrorCode.XmlText;
			ServiceResultDescription	= invoice_result.ServiceResultDescription.XmlText;
			ServiceResult				= invoice_result.ServiceResult.XmlText;
			Direction					= invoice_result.Direction.XmlText;

			if (ErrorCode is '34') {//Fatura bulunamadı
				error_detail = '#ServiceResultDescription# ';
			}
			else if (ErrorCode is '99') {//Erişim engellendi
				error_detail = '#ServiceResultDescription# ';
			}
			else if (ErrorCode is '0' And ServiceResult is 'Successful' And Direction Neq 'Outgoing') {
				//error_detail = 'Girilen UUID değeri gönderilen bir faturaya ait değil ';
			}

			if (Not Len(error_detail)) {
				InvoiceId					= invoice_result.InvoiceId.XmlText;
				ReturnValue					= invoice_result.ReturnValue.XmlText;
				StatusDescription			= invoice_result.StatusDescription.XmlText;
				StatusCode					= 1;
				Sendertaxid					= invoice_result.Sendertaxid.XmlText;
				Receivertaxid				= invoice_result.Receivertaxid.XmlText;
				Issuedate					= invoice_result.Issuedate.XmlText;
			}
		</cfscript>
	<cfelse>
		<cfset error_detail = 'Entegratör sisteminden beklenen yanıt alınamadı ' />
	</cfif>
<cfelse>
	<cfset error_detail = 'Entegrasyon Firma Tanımlarını Kontrol Ediniz ' />
</cfif>

<cfif Len(error_detail)>
	<table>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td style="color:#F00;font-weight:700"><cfoutput><span>#error_detail#!</span></cfoutput></td>
		</tr>
	</table>
<cfelse><!--- Her şey yolunda gidiyor --->
	<cfif attributes.action_type is 'INVOICE'>
		<cfquery name="get_invoice" datasource="#dsn2#">
			SELECT PROFILE_ID FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#" />
		</cfquery>
	<cfelse>
		<cfquery name="get_invoice" datasource="#dsn2#">
			SELECT PROFILE_ID FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#" />
		</cfquery>
	</cfif>
	<cfif attributes.invoice_type is 'einvoice'>
		<cfset invoice_folder	= '#upload_folder#einvoice_send#dir_seperator##session.ep.company_id##dir_seperator##Year(Issuedate)##dir_seperator##numberformat(month(Issuedate),00)##dir_seperator#' />
		<cfset invoice_path		= 'einvoice_send/#session.ep.company_id#/#year(Issuedate)#/#numberformat(month(Issuedate),00)#/#InvoiceId#.xml' />
		<cfquery datasource="#dsn2#">
			INSERT INTO
				EINVOICE_SENDING_DETAIL
			(
				SERVICE_RESULT,
				UUID,
				EINVOICE_ID,
				STATUS_DESCRIPTION,
				SERVICE_RESULT_DESCRIPTION,
				STATUS_CODE,
				ERROR_CODE,
				ACTION_ID,
				ACTION_TYPE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ServiceResult#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.invoice_uuid#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#InvoiceId#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ServiceResultDescription#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#StatusDescription#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#StatusCode#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ErrorCode#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#" />,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#" />
			)
	   </cfquery>
	   
	   <cfquery datasource="#dsn2#">
			INSERT INTO
				EINVOICE_RELATION
			(
				UUID,
				INTEGRATION_ID,
				EINVOICE_ID,
				PROFILE_ID,
				ACTION_ID,
				ACTION_TYPE,
				PATH,
				SENDER_TYPE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.invoice_uuid#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#InvoiceId#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#InvoiceId#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_invoice.profile_id#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#invoice_path#" />,
				#einvoice_company.einvoice_type#,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#" />
			)
		</cfquery>
	<cfelseif attributes.invoice_type is 'earchive'>
		<cfset invoice_folder	= '#upload_folder#earchive_send#dir_seperator##session.ep.company_id##dir_seperator##Year(Issuedate)##dir_seperator##numberformat(month(Issuedate),00)##dir_seperator#xml#dir_seperator#' />
		<cfset invoice_path		= 'earchive_send/#session.ep.company_id#/#year(Issuedate)#/#numberformat(month(Issuedate),00)#/xml/#InvoiceId#.xml' />
		<cfquery name="INS_EARCHIVE" datasource="#DSN2#">
			INSERT INTO
				EARCHIVE_SENDING_DETAIL
			(
				SERVICE_RESULT,
				UUID,
				EARCHIVE_ID,
				STATUS_DESCRIPTION,
				SERVICE_RESULT_DESCRIPTION,
				STATUS_CODE,
				ERROR_CODE,
				ACTION_ID,
				ACTION_TYPE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				ZIP_FILE_NAME
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ServiceResult#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.invoice_uuid#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#InvoiceId#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#StatusDescription#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ServiceResultDescription#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#StatusCode#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ErrorCode#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#" />,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#invoice_path#" />
			)
	   </cfquery>
	   
	   <cfif StatusCode eq 1>
			<cfquery name="GET_INVOICE_INTERNET" datasource="#DSN2#">
			SELECT 
				SPC.IS_PUBLIC,
				SPC.IS_PARTNER 
			 FROM 
				 INVOICE I,#dsn3_alias#.SETUP_PROCESS_CAT SPC 
			 WHERE 
				 I.INVOICE_ID = #attributes.action_id# AND 
				I.INVOICE_CAT = SPC.PROCESS_CAT_ID
		   </cfquery>
		   <cfquery name="INS_EARCHIVE" datasource="#DSN2#">
				INSERT INTO
					EARCHIVE_RELATION
				(
					STATUS_DESCRIPTION,
					UUID,
					INTEGRATION_ID,
					EARCHIVE_ID,
					ACTION_ID,
					ACTION_TYPE,
					PATH,
					SENDER_TYPE,
					STATUS,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					STATUS_CODE,
					IS_INTERNET
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#StatusDescription#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.invoice_uuid#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#InvoiceId#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#InvoiceId#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#invoice_path#" />,
					2,
					1,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#" />,
					60,
					<cfif get_invoice_internet.is_public eq 1 or get_invoice_internet.is_partner eq 1>1<cfelse>0</cfif>
				)
			</cfquery>
		</cfif>
	</cfif>

	<cfif attributes.action_type eq 'INVOICE'>
        <cfquery datasource="#DSN2#">
            UPDATE
				INVOICE
			SET
				INVOICE_NUMBER	= '#InvoiceId#',
				SERIAL_NO		= '#InvoiceId#',
				SERIAL_NUMBER	= NULL
			WHERE
				INVOICE_ID		= #attributes.action_id#
        </cfquery>
    <cfelse>
        <cfquery datasource="#DSN2#">
            UPDATE
				EXPENSE_ITEM_PLANS
			SET
				PAPER_NO	= '#InvoiceId#',
				SERIAL_NO	= '#InvoiceId#',
				SERIAL_NUMBER= NULL
			WHERE
				EXPENSE_ID	= #attributes.action_id#
        </cfquery>
    </cfif>

	<script type="text/javascript">
		alert("İşlem Tamamlandı!");
		wrk_opener_reload();
		window.close();
	</script>
	<cfif Not directoryExists(invoice_folder)>
		<cfset directoryCreate(invoice_folder) />
	</cfif>
	<cffile action="write" file="#invoice_folder##InvoiceId#.xml" output="#toString(tobinary(ReturnValue))#" charset="utf-8" />
</cfif>