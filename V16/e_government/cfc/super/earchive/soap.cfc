<cfcomponent>
    <cfproperty type="any" name="CommonObject">
    <cfproperty type="any" name="Cache_ticket">
    <cfproperty type="string" name="urlPrefix">

    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
    <cfelseif isdefined("session.wp")>
        <cfset session_base = evaluate('session.wp')>
    </cfif>

    <cfset useTicketCache = 0>

    <cffunction name="init">
        <cfset this.CommonObject = createObject("component", "V16.e_government.cfc.super.earchive.common")>
        <cfset integrationinfo = this.CommonObject.GetEArchiveIntegrationInfo()>
        <cfif integrationinfo.recordcount gt 0>
            <cfif integrationinfo.EARSIV_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = trim(integrationinfo.EARSIV_TEST_URL)>
            <cfelse>
                <cfset this.urlPrefix = trim(integrationinfo.EARSIV_LIVE_URL)>
            </cfif>
            <cfif right(this.urlPrefix, 1) neq "/">
                <cfset this.urlPrefix = this.urlPrefix & "/">
            </cfif>
        </cfif>
    </cffunction>

    <cffunction name="SendHttp" access="public">
        <cfargument name="UrlPostfix">
        <cfargument name="SOAPAction">
        <cfargument name="body">
        <cfargument name="contentType" default="text/xml">

        <cfhttp url="#this.urlPrefix##arguments.UrlPostfix#" method="post" result="requestResult">
            <cfhttpparam type="header" name="content-type" value="#arguments.contentType#">
            <cfhttpparam type="header" name="SOAPAction" value="#arguments.SOAPAction#">
            <cfhttpparam type="header" name="charset" value="utf-8">
            <cfhttpparam type="header" name="content-legth" value="#len(arguments.body)#">
            <cfhttpparam type="xml" name="message" value="#trim(arguments.body)#">
        </cfhttp>

        <cfreturn requestResult>
    </cffunction>

    <cffunction name="GetFormsAuthentication" access="public">
        <cfargument type="numeric" name="company_id" default = "#session_base.company_id#">
        <cfif useTicketCache and isDefined("this.Cache_ticket")>
            <cfreturn this.Cache_ticket>
        </cfif>

        <cfset authvars = this.CommonObject.GetAuthorizationVars()>

        <cfxml variable="ticket_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:auth="http://wsdl.superentegrator.com/auth">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <auth:loginRequest>
                            <CustomerIdentity>#authvars.tax_no#</CustomerIdentity>
                            <EMail>#authvars.loginName#</EMail>
                            <Password>#HTMLEditFormat(authvars.password)#</Password>
                        </auth:loginRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("AuthService.svc", "Login", ticket_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfif useTicketCache>
                <cfset this.Cache_ticket = xmlresult.Envelope.Body.LoginResponse.accessToken.XmlText>
            </cfif>
            <cfif structKeyExists(xmlresult.Envelope.Body,'Fault')>
                <cfreturn xmlresult.Envelope.Body.Fault.faultstring.XmlText>
            <cfelse>
                <cfreturn xmlresult.Envelope.Body.LoginResponse.accessToken.XmlText>
            </cfif>
            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="SendInvoiceData" access="public">
        <cfargument name="ubl">
        <cfargument name="invoice_number">
        <cfargument name="directory_name">
        <cfargument name="zip_filename">
        <cfargument name="invoice_prefix">
        <cfargument name="email">
        <cfargument name="sending_type">

        <cfset authvars = this.CommonObject.GetAuthorizationVars()>
        <cfset ticket = GetFormsAuthentication()>
        
        <cffile action="write" file="#directory_name#/#invoice_number#.xml" output="#trim(ubl)#" charset="utf-8" />
        <cffile action="readbinary" file="#directory_name#/#invoice_number#.xml" variable="ubl_binary">
        <cfxml variable="earchive_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ear="http://wsdl.superentegrator.com/earchiveinvoice">
                    <soapenv:Header>
                        <ear:Authorization>#ticket#</ear:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                        <ear:SendEArchiveInvoiceRequest>
                            <!--Optional:-->
                            <SendingType><cfif arguments.sending_type eq 0>KAGIT<cfelse>ELEKTRONIK</cfif></SendingType>
                            <!--Optional:-->
                            <ErpReferenceId>#arguments.invoice_number#</ErpReferenceId>
                            <!--Optional:-->
                            <InvoiceIdPrefix>#arguments.invoice_prefix#</InvoiceIdPrefix>
                            <!--Optional:-->
                            <InvoiceData>#tobase64(ubl_binary)#</InvoiceData>
                            <!--Optional:-->
                            <IsOnlineSale>false</IsOnlineSale>
                        </ear:SendEArchiveInvoiceRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>
        <cftry>
            <cfif integrationinfo.EARSIV_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://earchiveinvoicesoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://earchiveinvoicesoapapi.superentegrator.com/'>
            </cfif>

            <cfset httpresult = SendHttp("EArchiveInvoice.svc", "SendDocument", earchive_data)>
            <cfset xml_filecontent = XMLParse(httpresult.filecontent).Envelope.Body.SendInvoiceResponse>
            <cfset resultdata = structNew()>
            <cfset resultdata.invoices = arrayNew(1)>

            <cfset get_sending_type = this.CommonObject.getEarchiveSendingType(url.action_id, url.action_type)>

            <cfif listFind('30,50,80,90,110', xml_filecontent.StatusEnumValue.xmlText)>

                <cfif structKeyExists(xml_filecontent,'StatusDetails')>
                    <cfset resultdata.SERVICE_RESULT = xml_filecontent.StatusDetails.xmlText>
                <cfelseif structKeyExists(xml_filecontent,'Status')>
                    <cfset resultdata.SERVICE_RESULT = xml_filecontent.Status.xmlText>
                </cfif>

                <cfset resultdata.UUID = xmlParse(ubl).Invoice.UUID.XmlText>
                <cfset resultdata.E_INVOICE_ID = xmlParse(ubl).Invoice.ID.XmlText>
                <cfset resultdata.STATUS_DESCRIPTION = left(xml_filecontent.StatusDescription.xmlText,150)>
                <cfset resultdata.STATUSCODE = 0>
                <cfset resultdata.serviceResult = 'Error'>

                <cfset this.CommonObject.addEarchiveSendingDetail(
                        zip_file_name: arguments.zip_filename,
                        service_result: 'Error',
                        uuid: xmlParse(arguments.ubl).Invoice.UUID.XmlText,
                        earchive_id:xmlParse(arguments.ubl).Invoice.ID.XmlText,
                        status_description:'HATA',
                        service_result_description: resultdata.SERVICE_RESULT,
                        status_code:0,
                        error_code:xml_filecontent.StatusEnumValue.xmlText,
                        action_id:url.action_id,
                        action_type:url.action_type,
                        output_type:'',
                        earchive_sending_type: arguments.sending_type,
                        invoice_type_code:xmlParse(arguments.ubl).Invoice.InvoiceTypeCode.XmlText
                )>
            <cfelse>
                <cfif listFind('0,1', xml_filecontent.StatusEnumValue.xmlText)>
                    <cfset resultdata.STATUSCODE = 1>
                </cfif>

                <cfset resultdata.SERVICE_RESULT = 'GÖNDERİM ONAYI BEKLENİYOR'>
                <cfset resultdata.UUID = xml_filecontent.InvoiceUUID.XmlText>
                <cfset resultdata.E_INVOICE_ID = xml_filecontent.InvoiceId.XmlText>
                <cfset resultdata.STATUS_DESCRIPTION = left(xml_filecontent.StatusDescription.xmlText,150)>
                <cfset resultdata.STATUSCODE = 1>
                <cfset resultdata.serviceResult = xml_filecontent.Status.XmlText>

                <cfset this.CommonObject.addEarchiveSendingDetail(
                    zip_file_name: arguments.zip_filename,
                    service_result: 'Successful',
                    uuid: xmlParse(arguments.ubl).Invoice.UUID.XmlText,
                    earchive_id:xmlParse(arguments.ubl).Invoice.ID.XmlText,
                    status_description:'RAPORLAMAYA HAZIR',
                    service_result_description:'',
                    status_code:1,
                    error_code:0,
                    action_id:url.action_id,
                    action_type:url.action_type,
                    output_type:'',
                    earchive_sending_type:get_sending_type.earchive_sending_type,
                    invoice_type_code:xmlParse(arguments.ubl).Invoice.InvoiceTypeCode.XmlText
                )>

                <cfset invoice_path ="earchive_send/#session_base.company_id#/#year(now())#/#numberformat(month(now()),00)#/xml/#invoice_number#.xml">
                
                <cfset this.CommonObject.addEarchiveRelation(
                    status_description: 'RAPORLAMAYA HAZIR',
                    uuid:xmlParse(arguments.ubl).Invoice.UUID.XmlText,
                    integration_id:xmlParse(arguments.ubl).Invoice.ID.XmlText,
                    earchive_id:xmlParse(arguments.ubl).Invoice.ID.XmlText,
                    action_id:url.action_id,
                    action_type:url.action_type,
                    path: invoice_path,
                    sender_type:5,
                    earchive_sending_type: get_sending_type.earchive_sending_type,
                    is_internet:get_sending_type.is_internet
                )>

                <cfset invoice.uuid = xmlParse(ubl).Invoice.UUID.XmlText>
                <cfset invoice.invoiceid = xmlParse(ubl).Invoice.ID.XmlText>
                <cfset invoice.status_code = 1>
                <cfset invoice.earchiveid = xmlParse(arguments.ubl).Invoice.ID.XmlText>
                <cfset arrayAppend( resultdata.invoices, invoice )>

                <cfset resultdata.statuscode = 1>
                <cfset resultdata.uuid = ''>

            </cfif>

            <cfreturn resultdata>

            <cfcatch>
                <cfdump  var="#cfcatch#">
                <cfdump  var="#xmlresult#">
                <cfabort>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="CheckInvoiceState" access="public" hint="Faturanın durumunu sorgular">
        <cfargument name="uuid">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ear="http://wsdl.superentegrator.com/earchiveinvoice">
                    <soapenv:Header>
                        <ear:Authorization>#ticket#</ear:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                        <ear:GetInvoiceStatusRequest>
                            <UUID>#arguments.uuid#</UUID>
                        </ear:GetInvoiceStatusRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.EARSIV_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://earchiveinvoicesoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://earchiveinvoicesoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("EArchiveInvoice.svc", "GetInvoiceStatus", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.uuid = xmlresult.Envelope.Body.GetInvoiceStatusResponse.InvoiceStatus.InvoiceUUID.XmlText>
            <cfset resultdata.statusdescription = xmlresult.Envelope.Body.GetInvoiceStatusResponse.InvoiceStatus.StatusDescription.XmlText>
            <cfset resultdata.statuscode = xmlresult.Envelope.Body.GetInvoiceStatusResponse.InvoiceStatus.StatusEnumValue.XmlText>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="getInvoicePDF" access="public" hint="Faturanın durumunu sorgular">
        <cfargument name="uuid">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ear="http://wsdl.superentegrator.com/earchiveinvoice">
                    <soapenv:Header>
                        <ear:Authorization>#ticket#</ear:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                        <ear:GetDocumentRequest>
                            <InvoiceUUID>#arguments.uuid#</InvoiceUUID>
                            <OutputType>Pdf</OutputType>
                        </ear:GetDocumentRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.EARSIV_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://earchiveinvoicesoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://earchiveinvoicesoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("EArchiveInvoice.svc", "GetDocument", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata = structNew()>
            <cfset resultdata.service_result = xmlresult.Envelope.Body.GetDocumentResponse.Status.XmlText>
            <cfif resultdata.service_result eq 'Success'>
                <cfset resultdata.pdf_data = xmlresult.Envelope.Body.GetDocumentResponse.Data.XmlText>
            </cfif>
            
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="CancelInvoice" access="public" hint="Fatura İptal">
        <cfargument name="uuid">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ear="http://wsdl.superentegrator.com/earchiveinvoice">
                    <soapenv:Header>
                        <ear:Authorization>#ticket#</ear:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                        <ear:CancelInvoiceRequest>
                            <EarchiveInvoiceUUID>#arguments.uuid#</EarchiveInvoiceUUID>
                        </ear:CancelInvoiceRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.EARSIV_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://earchiveinvoicesoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://earchiveinvoicesoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("EArchiveInvoice.svc", "CancelInvoice", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.status = xmlresult.Envelope.Body.CancelInvoiceResponse.Status.XmlText>
            <cfset resultdata.status_description = xmlresult.Envelope.Body.CancelInvoiceResponse.StatusDescription.XmlText>
            
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>
