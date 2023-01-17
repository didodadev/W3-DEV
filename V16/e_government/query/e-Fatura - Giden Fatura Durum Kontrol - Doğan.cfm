<cfscript>
	get_einv_comp_tmp= createObject("component","v16.e_government.cfc.einvoice");
	get_einv_comp_tmp.dsn = dsn;
	get_einv_comp = get_einv_comp_tmp.get_our_company_fnc(einvoice_type:4);
</cfscript>

<cfloop query="GET_EINV_COMP">
    <cfset temp_dsn2 = '#dsn#_#year(now())#_#get_einv_comp.comp_id#'>

    <cfquery name="GET_INVOICE_DET" datasource="#temp_dsn2#">
        SELECT
            ER.UUID,
            ER.STATUS,
            ER.PROFILE_ID,
            ER.INTEGRATION_ID,
            I.INVOICE_NUMBER
        FROM 
            EINVOICE_RELATION ER,
            INVOICE I
        WHERE 
            --ER.STATUS IS NULL AND
            ER.ACTION_ID = I.INVOICE_ID AND
            ER.SENDER_TYPE = 4 AND
            <cfif isdefined("attributes.all")><!--- Son bir ay icinde gonderilen faturalar --->
	            ER.RECORD_DATE > DATEADD(MM, -1, GETDATE()) 
            <cfelse>
	            ER.RECORD_DATE > DATEADD(DD, -7, GETDATE()) 
            </cfif>
    </cfquery>

    <cfif get_invoice_det.recordcount>
        <cfxml variable="ticket_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://schemas.i2i.com/ei/wsdl">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <wsdl:LoginRequest>
                            <REQUEST_HEADER>
                                <SESSION_ID>-1</SESSION_ID>
                            </REQUEST_HEADER>REQUEST_HEADER>
                            <USER_NAME>#einvoice_user_name#</USER_NAME>
                            <PASSWORD>#einvoice_password#</PASSWORD>
                        </wsdl:LoginRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cfhttp url="https://connector.doganedonusum.com/AuthenticationWS" method="post" result="httpresult">
            <cfhttpparam type="header" name="content-type" value="text/xml">
            <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/AuthenticationWS">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="header" name="content-legth" value="#len(ticket_data)#">
            <cfhttpparam type="xml" name="message" value="#trim(ticket_data)#">
        </cfhttp>

        <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
        <cfset ticket = xmlresult.Envelope.Body.LoginResponse.SESSION_ID.XmlText>

        <table>

        <cfloop query="GET_INVOICE_DET">


            <cfxml variable="einvoice_data">
                <cfoutput>
                    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://schemas.i2i.com/ei/wsdl" xmlns:xmime="http://www.w3.org/2005/05/xmlmime">
                        <soapenv:Header/>
                        <soapenv:Body>
                            <wsdl:GetInvoiceRequest>
                                <REQUEST_HEADER>
                                    <SESSION_ID>#ticket#</SESSION_ID>
                                    <COMPRESSED>N</COMPRESSED>
                                </REQUEST_HEADER>
                                <INVOICE_SEARCH_KEY>
                                    <ID>#trim(get_invoice_det.invoice_number)#</ID>
                                    <DIRECTION>OUT</DIRECTION>
                                </INVOICE_SEARCH_KEY>
                                <HEADER_ONLY>Y</HEADER_ONLY>
                            </wsdl:GetInvoiceRequest>
                        </soapenv:Body>
                    </soapenv:Envelope>
                </cfoutput>
            </cfxml>

            <cfhttp url="https://connector.doganedonusum.com/EFaturaOIB" method="post" result="httpresult">
                <cfhttpparam type="header" name="content-type" value="text/xml">
                <cfhttpparam type="header" name="SOAPAction" value="http://tempuri.org/GetInvoice">
                <cfhttpparam type="header" name="charset" value="utf-8">
                <cfhttpparam type="header" name="content-legth" value="#len(einvoice_data)#">
                <cfhttpparam type="xml" name="message" value="#trim(einvoice_data)#">
            </cfhttp>

            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cftry>
				<cfset Status_desc = xmlresult.Envelope.Body.GetInvoiceResponse.INVOICE.HEADER.STATUS.XmlText>
                <cfset status_code = xmlresult.Envelope.Body.GetInvoiceResponse.INVOICE.HEADER.status_code.XmlText>

                <cfscript>
                    upd_einvoice_relation_tmp= createObject("component","v16.e_government.cfc.einvoice");
                    upd_einvoice_relation_tmp.dsn2 = temp_dsn2;
                    upd_einvoice_relation = upd_einvoice_relation_tmp.upd_einvoice_relation_fnc(uuid:GET_INVOICE_DET.uuid,profile_id:GET_INVOICE_DET.profile_id,StatusCode:status_code,CheckInvoiceStateResult:Status_desc,einvoice_type:get_einv_comp.einvoice_type);
                </cfscript>
                
                <tr>
                    <cfoutput>
                    <td>#get_invoice_det.invoice_number#</td>
                    <td><b>#Status_desc#</b></td>
                    </cfoutput>
                </tr> 
            <cfcatch>
                <tr>
                    <cfoutput>
                    <td>#get_invoice_det.invoice_number#</td>
                    <td><b>Fatura Bulunamadı!</b></td>
                    </cfoutput>
                </tr>
            </cfcatch>
            </cftry>
        </cfloop>
        </table>
    <cfelse>
        (<cfoutput>#COMPANY_NAME#</cfoutput>) şirketinde gönderim detayı sorgulanacak fatura bulunamadı!<br />
    </cfif>
    

</cfloop>