<!---
    File: return_detail_earchive.cfm
    Folder: V16\e_government\display\
	Controller: 
    Author: 
    Date: 
    Description:
        
    History:
        Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com 2020-03-13 02:26:54
        E-devlet standart modüle taşındı.
        DTP dışındaki diğer entegratörler kaldırıldı.
    To Do:

--->

<cfif session.ep.admin>
	<a href="javascript://" onclick="window.location.assign('<cfoutput>#request.self#?fuseaction=invoice.popup_return_detail_earchive&action_id=#attributes.action_id#&action_type=#attributes.action_type#&re_query=true','wide');</cfoutput>" style="float:right; margin:5px">	
		<img src="images/refresh.png" height="17" align="absmiddle" title="Tekrar Sorgula">
	</a>
</cfif>
<cf_popup_box title="Dönüş Değerleri">
<cfif isDefined("attributes.re_query")>
	<cfquery name="upd_earchive_rel" datasource="#dsn2#">
        UPDATE
            EARCHIVE_RELATION
        SET
            STATUS = NULL,
            STATUS_CODE = NULL,
            STATUS_DESCRIPTION = NULL                           
        WHERE
            ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
            ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#">
    </cfquery>
</cfif>
<cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
	SELECT
		EARCHIVE_INTEGRATION_TYPE,
		EARCHIVE_TEST_SYSTEM,
		EARCHIVE_COMPANY_CODE,
		EARCHIVE_USERNAME,
		EARCHIVE_PASSWORD
	FROM
		EARCHIVE_INTEGRATION_INFO
	WHERE
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="GET_INVOICE_RELATION" datasource="#DSN2#">
	SELECT UUID,EARCHIVE_ID,STATUS,STATUS_CODE,STATUS_DESCRIPTION,INTEGRATION_ID FROM EARCHIVE_RELATION WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#"> ORDER BY RECORD_DATE DESC
</cfquery>
<cfif (ListFind("126,130,150",get_invoice_relation.status_code) and get_our_company.earchive_integration_type eq 1) or (get_invoice_relation.status_code eq 60 and get_our_company.earchive_integration_type eq 2) or ListFind("60,100",get_invoice_relation.status_code) and get_our_company.earchive_integration_type eq 3> 
     <cf_medium_list>
    	<thead>
            <tr>
                <th style="width:180px"><cf_get_lang dictionary_id="59825.Workcube Referans"> <cf_get_lang dictionary_id="58527.ID"></th>
                <th style="width:120px"><cf_get_lang dictionary_id="59328.E-Arşiv"> <cf_get_lang dictionary_id="58527.ID"></th>                                
                <th style="width:40px"><cf_get_lang dictionary_id="32646.Kodu"></th>
                <th><cf_get_lang dictionary_id="57629.Açıklama"></th>
            </tr>
        </thead>
        <tbody>
			<cfoutput>
                <tr>
                    <td>#get_invoice_relation.earchive_id#</td>
                    <td>#get_invoice_relation.integration_id#</td>
                    <td>#get_invoice_relation.status_code#</td>
                    <td><cfif len(get_invoice_relation.status_description)>#get_invoice_relation.status_description#<cfelse>#get_invoice_relation.status#</cfif></td>
                </tr>
            </cfoutput>
        </tbody>
    </cf_medium_list>
<cfelse>
    <cfif get_our_company.earchive_integration_type eq 2><!--- DP --->
		<cfif get_our_company.earchive_test_system eq 1>
            <cfset web_service_url = 'https://IntegrationServiceWithoutMtomtest.eveelektronik.com.tr/IntegrationService.asmx'>
        <cfelse>
            <cfset web_service_url = 'https://integrationservicewithoutmtom.digitalplanet.com.tr/IntegrationService.asmx'>
        </cfif>
        
        <cfset save_folder	    = "#upload_folder#e_government#dir_seperator#xml" />

        <!--- Ticket almak icin gerekli XML formati hazirlaniyor --->
	    <cfxml variable="ticket_data"><cfoutput>
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
        <soapenv:Header/>
        <soapenv:Body>
            <tem:GetFormsAuthenticationTicket>
                <tem:CorporateCode>#get_our_company.EARCHIVE_COMPANY_CODE#</tem:CorporateCode>
                <tem:LoginName>#get_our_company.EARCHIVE_USERNAME#</tem:LoginName>
                <tem:Password><![CDATA[#get_our_company.EARCHIVE_PASSWORD#]]></tem:Password>
            </tem:GetFormsAuthenticationTicket>
        </soapenv:Body>
        </soapenv:Envelope></cfoutput>
        </cfxml>
        
        <!--- tek seferlik ticket alınıyor ---> 
        <cfhttp url="#web_service_url#" method="post" result="httpResponse">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetFormsAuthenticationTicket">
            <cfhttpparam type="header" name="content-length" value="#len(ticket_data)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(ticket_data)#">
        </cfhttp> 
        
        <cftry>
			<cfset Ticket = xmlParse(httpResponse.filecontent)>
            <cfset Ticket = Ticket.Envelope.Body.GetFormsAuthenticationTicketResponse.GetFormsAuthenticationTicketResult.XmlText>
        <cfcatch type="Any">
            <cf_get_lang dictionary_id="30628.Ticket Alma Sırasında Bir Hata Meydana Geldi"> !<br /><cfabort>
        </cfcatch>
    	</cftry>
        
        <cfxml variable="get_earchive_data_status" casesensitive="no"><cfoutput>
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
           <soapenv:Header/>
           <soapenv:Body>
              <tem:CheckEArchiveInvoiceState>
                 <tem:Ticket>#Ticket#</tem:Ticket>
                 <tem:InvoiceNumber>#get_invoice_relation.uuid#</tem:InvoiceNumber>
                 <tem:InvoiceNumberType>UUID</tem:InvoiceNumberType>
              </tem:CheckEArchiveInvoiceState>
           </soapenv:Body>
        </soapenv:Envelope>
		</cfoutput></cfxml>
        
        <cfhttp url="#web_service_url#" method="post" result="httpResponse">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/CheckEArchiveInvoiceState">
            <cfhttpparam type="header" name="content-length" value="#len(get_earchive_data_status)#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="xml" name="message" value="#trim(get_earchive_data_status)#">
        </cfhttp>

        <cftry>
			<cfset StatusCode = xmlParse(httpResponse.FileContent).Envelope.Body.CheckEArchiveInvoiceStateResponse.CheckEArchiveInvoiceStateResult.InvoiceStatusCode.XmlText>
            <cfset CheckInvoiceStateResult = xmlParse(httpResponse.FileContent).Envelope.Body.CheckEArchiveInvoiceStateResponse.CheckEArchiveInvoiceStateResult.InvoiceStatusDescription.XmlText>
            <cfquery name="UPD_EINVOICE_RELATION" datasource="#DSN2#">
                UPDATE
                    EARCHIVE_RELATION
                SET
                	STATUS = <cfif StatusCode eq 60>1<cfelse>NULL</cfif>,
                    STATUS_CODE = #StatusCode#,
                    STATUS_DESCRIPTION = '#CheckInvoiceStateResult#'
                WHERE
                    UUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_invoice_relation.uuid#">
            </cfquery>
        <cfcatch type="any">
        	<cftry>
				<cfset Error = xmlParse(httpResponse.FileContent)>
                <cfif isdefined("Error.Envelope.Body.CheckEArchiveInvoiceStateResponse.CheckEArchiveInvoiceStateResult.ErrorCode")>
                    <cfset Error_code = Error.Envelope.Body.CheckEArchiveInvoiceStateResponse.CheckEArchiveInvoiceStateResult.ServiceResultDescription.XmlText>
                </cfif>
            <cfcatch type="any">
            	<cfset Error_code = "E-Arşiv Fatura Durum Sorgulamasında bir Hata Meydana Geldi!">
            </cfcatch>
            </cftry>
        </cfcatch>
        </cftry>
   	</cfif>  
    <table>
        <tr>
            <td>
				<cfoutput>
					<cfif isdefined("CheckInvoiceStateResult")>#CheckInvoiceStateResult#</cfif><cfif isdefined("Error_code")>#Error_code#</cfif>
				</cfoutput>
          	</td>
        </tr>
    </table>
    <script type="text/javascript">
		window.opener.location.reload(true);
	</script>
</cfif>
</cf_popup_box>
<script type="text/javascript">
    $(document).keydown(function(e){
        // ESCAPE key pressed
        if (e.keyCode == 27) {
            window.close();
        }
    });
</script>