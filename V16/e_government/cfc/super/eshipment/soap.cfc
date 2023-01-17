<!---
    Date :          03.04.2022
    Description :   SuperEntegrator EIrsaliye Soap Katmanı
    Notes :         
--->
<cfcomponent>
    <cfproperty type="any" name="CommonObject">
    <cfproperty type="any" name="Cache_ticket">
    <cfproperty type="string" name="urlPrefix">

    <cffunction name="init">
        <cfset this.CommonObject = createObject("component", "V16.e_government.cfc.super.eshipment.common")>
        <cfset integrationinfo = this.CommonObject.GetEShipmentIntegrationInfo()>

        <cfif integrationinfo.recordcount gt 0>
            <cfif integrationinfo.ESHIPMENT_TEST_URL eq 1>
                <cfset this.urlPrefix = trim(integrationinfo.ESHIPMENT_TEST_URL)>
            <cfelse>
                <cfset this.urlPrefix = trim(integrationinfo.ESHIPMENT_TEST_URL)>
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
            <cfhttpparam type="header" name="content-length" value="#len(arguments.body)#">
            <cfhttpparam type="xml" name="message" value="#trim(arguments.body)#">
        </cfhttp>
        <cfreturn requestResult>
    </cffunction>

    <cffunction name="GetFormsAuthentication" access="public">
        <cfargument type="numeric" name="company_id" default = "#session.ep.company_id#">
        <cfset authvars = this.CommonObject.GetAuthorizationVars(company_id : arguments.company_id)>
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

    <cffunction name="SendDespatchData" access="public" hint="İrsaliye Verisi Gönder">
        <cfargument name="ubl">

        <cfset authvars = this.CommonObject.GetAuthorizationVars()>
        <cfset ticket = GetFormsAuthentication()>
        
        <cfxml variable="despatch_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:edes="http://wsdl.superentegrator.com/edespatch">
                    <soapenv:Header>
                        <edes:Authorization>#ticket#</edes:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                        <edes:SendDespatchAdviceRequest>
                            <SenderGbAlias></SenderGbAlias>
                            <ReceiverPkAlias></ReceiverPkAlias>
                            <ErpReferenceId>#arguments.shipment_number#</ErpReferenceId>
                            <CustomerBranchCode></CustomerBranchCode>
                            <MappingCode></MappingCode>
                            <DespatchAdviceIdPrefix>#arguments.shipment_prefix#</DespatchAdviceIdPrefix>
                            <XsltCode></XsltCode>
                            <DespatchAdviceData>#trim(toBase64(arguments.ubl))#</DespatchAdviceData>
                        </edes:SendDespatchAdviceRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.ESHIPMENT_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://edespatchinvoicesoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://edespatchinvoicesoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("EDespatch.svc", "SendDespatchAdvice", despatch_data)>

            <cfset xml_filecontent = XMLParse(httpresult.filecontent).Envelope.Body.SendDespatchAdviceResponse>
            <cfset resultdata = structNew()>
            <cfset resultdata.despatches = arrayNew(1)>
            
            <cfif listFind('60,80,100', xml_filecontent.StatusEnumValue.xmlText)>
                <cfif structKeyExists(xml_filecontent, "StatusDetails")>
                    <cfset resultdata.ServiceResultDescription = left(xml_filecontent.StatusDetails.xmlText,500)>
                <cfelse>
                    <cfset resultdata.ServiceResultDescription = "">
                </cfif>
                <cfset resultdata.ServiceStatusDescription = left(xml_filecontent.StatusDescription.xmlText,150)>
                <cfset resultdata.ErrorCode = xml_filecontent.StatusEnumValue.xmlText>
                <cfset resultdata.statuscode = 0>
                <cfset resultdata.uuid = xmlParse(ubl).DespatchAdvice.UUID.XmlText>

                <cfset this.CommonObject.eShipmentSendingDetail(
                                                    service_result: 'Error',
                                                    uuid: resultdata.uuid,
                                                    eshipment_id: xmlParse(ubl).DespatchAdvice.ID.XmlText,
                                                    status_description: resultdata.ServiceStatusDescription,
                                                    service_result_description: resultdata.ServiceResultDescription,
                                                    status_code: resultdata.statuscode,
                                                    error_code: resultdata.ErrorCode,
                                                    action_id: url.action_id,
                                                    action_type: url.action_type
                                                )>

            <cfelse>
                <cfset resultdata = structNew()>
                <cfset resultdata.ServiceStatusDescription = xml_filecontent.StatusDescription.XmlText>
                <cfset resultdata.errorcode = xml_filecontent.StatusEnumValue.XmlText>
                <cfset resultdata.uuid = xml_filecontent.DespatchAdviceUUID.XmlText>
                <cfset resultdata.despatchid = xml_filecontent.DespatchAdviceId.XmlText>
                <cfset resultdata.statuscode = 1>
                <cfset this.CommonObject.eShipmentSendingDetail(
                                                    service_result: 'Success',
                                                    uuid: resultdata.uuid,
                                                    eshipment_id: arguments.shipment_number,
                                                    status_description: left(resultdata.ServiceStatusDescription,50),
                                                    status_code: resultdata.statuscode,
                                                    error_code: resultdata.ErrorCode,
                                                    action_id: url.action_id,
                                                    action_type: url.action_type
                                                )>

                <cfset this.CommonObject.eShipmentRelation(
                                                    uuid: resultdata.uuid,
                                                    integration_id: resultdata.despatchid,
                                                    eshipment_id: arguments.shipment_number,
                                                    profile_id: 'TEMELIRSALIYE',
                                                    action_id: url.action_id,
                                                    action_type: url.action_type,
                                                    path: arguments.path,
                                                    sender_type: 5
                                                )>

            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="GetDespatch" access="public" hint="Sistemde ki irsaliyeyi indirir">
        <cfargument name="uuid">
        <cfargument name="outputType" default="Pdf">
        <cfargument name="direction" default="Outgoing">
        <cfargument name="ticket_req" default="1">

        <cfif arguments.ticket_req eq 1>
            <cfset ticket = GetFormsAuthentication()>
        </cfif>

        <cfxml variable="despatch_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:edes="http://wsdl.superentegrator.com/edespatch">
                    <soapenv:Header>
                        <edes:Authorization>#ticket#</edes:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                        <edes:GetDespatchAdviceRequest>
                            <OutputType>#arguments.outputType#</OutputType>
                            <UUIDType>DocumentUUID</UUIDType>
                            <UUID>#arguments.uuid#</UUID>
                            <DocumentDirection>#arguments.direction#</DocumentDirection>
                            <IncludeDespatchAdviceBinaryData>true</IncludeDespatchAdviceBinaryData>
                            <CompressedBinaryData>false</CompressedBinaryData>
                        </edes:GetDespatchAdviceRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.ESHIPMENT_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://edespatchinvoicesoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://edespatchinvoicesoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("EDespatch.svc", "GetDespatchAdvice", despatch_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata = structNew()>
            <cfset resultdata.service_result = xmlresult.Envelope.Body.GetDespatchAdviceResponse.Status.XmlText>
            <cfif resultdata.service_result eq 'Success'>
            <cfset resultdata.pdf_data = xmlresult.Envelope.Body.GetDespatchAdviceResponse.OutputDatas.XmlText>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="CheckDespatchState" access="public" hint="İrsaliye durumunu sorgular">
        <cfargument name="uuid">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:edes="http://wsdl.superentegrator.com/edespatch">
                    <soapenv:Header>
                        <edes:Authorization>#ticket#</edes:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                        <edes:GetDespatchAdviceStatusRequest>
                            <UUIDType>DocumentUUID</UUIDType>
                            <UUID>#arguments.uuid#</UUID>
                            <DocumentDirection>Outgoing</DocumentDirection>
                        </edes:GetDespatchAdviceStatusRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.ESHIPMENT_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://edespatchinvoicesoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://edespatchinvoicesoapapi.superentegrator.com/'>
            </cfif>

            <cfset httpresult = SendHttp("EDespatch.svc", "GetDespatchAdviceStatus", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <!--- <cfdump var="#xmlresult#" abort> --->
            <cfset resultdata = structNew()>

            <cfif xmlresult.Envelope.Body.GetDespatchAdviceStatusResponse.Status.XmlText neq 'Success'>
                <cfset resultdata.statuscode = 0>
            <cfelse>
                <cfset resultdata.uuid = xmlresult.Envelope.Body.GetDespatchAdviceStatusResponse.DespatchAdviceStatuses.DespatchAdviceUUID.XmlText>
                <cfset resultdata.statusdescription = xmlresult.Envelope.Body.GetDespatchAdviceStatusResponse.DespatchAdviceStatuses.StatusDescription.XmlText>
                <cfset resultdata.statuscode = xmlresult.Envelope.Body.GetDespatchAdviceStatusResponse.DespatchAdviceStatuses.GibStatus.XmlText>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="GetAvailableDespatch" access="public" hint="Gelen e-fatura listesini verir">
        <cfargument name="startdate" default="">
        <cfargument name="enddate" default="">
        <cfargument name="company_id" required = "yes">

        <cfset authvars = this.CommonObject.GetAuthorizationVars(company_id : arguments.company_id)>
        <cfset ticket = GetFormsAuthentication(company_id : arguments.company_id)>

        <cfxml variable="availableinvoices_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:edes="http://wsdl.superentegrator.com/edespatch">
                    <soapenv:Header>
                        <edes:Authorization>#ticket#</edes:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                        <edes:GetDespatchAdviceListRequest>
                            <FilterDateType>CreateDate</FilterDateType>
                            <StartDate>#dateFormat(dateAdd('d',-30,now()),'yyyy-mm-dd')#</StartDate>
                            <EndDate>#dateFormat(dateAdd('d',1,now()),'yyyy-mm-dd')#</EndDate>
                            <DocumentDirection>Incoming</DocumentDirection>
                        </edes:GetDespatchAdviceListRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.ESHIPMENT_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://edespatchinvoicesoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://edespatchinvoicesoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("EDespatch.svc", "GetDespatchAdviceList", availableinvoices_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata = structNew()>
            <cfset resultdata.invoices = arrayNew(1)>
            <cfif structKeyExists(xmlresult.Envelope.Body.GetInvoiceListResponse,'DespatchAdviceList')>
                <cfloop array="#xmlresult.Envelope.Body.GetInvoiceListResponse.DespatchAdviceList#" index="child">
                    <cfset invoice = structNew()>
                    <cfset invoice.uuid = child.DespatchAdviceUUID.XmlText>
                    <cfset invoice.invoiceid = child.DocumentId.XmlText>
                    <cfset invoice.statuscode = child.GibStatus.XmlText>
                    <cfset invoice.statusdescription = child.GibStatusMessage.XmlText>
                    <cfset invoice.invoicetypecode = child.DocumentType.XmlText>
                    <cfset invoice.sendertaxid = child.SupplierId.XmlText>
                    <cfset invoice.receivertaxid = child.CustomerId.XmlText>
                    <cfset invoice.profileid = child.ProfileId.XmlText>
                    <cfset invoice.partyname = child.SupplierTitle.XmlText>
                    <cfset invoice.issuedate = child.IssueDate.XmlText>
                    <cfset invoice.issuetime = child.IssueTime.XmlText>
                    <cfset invoice.receiverpostboxname = child.CustomerAlias.XmlText>
                    <cfset invoice.senderpostboxname = child.SupplierAlias.XmlText>
                    <!--- <cfset invoice.totalamount = child.PayableAmount.XmlText> --->
                    <!--- <cfset invoice.currency = child.DocumentCurrencyCode.XmlText> --->
                    <cfset invoice.createdate = child.IssueDate.XmlText>
                    <!--- <cfset invoice.content = child.EnvelopeUUID.XmlText> --->
                    <cfset arrayAppend( resultdata.invoices, invoice )>
                </cfloop>
            </cfif>

            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="RejectDespatch" access="public" hint="İrsaliye Red">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:edes="http://wsdl.superentegrator.com/edespatch">
                    <soapenv:Header>
                    <edes:Authorization>#ticket#</edes:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                    <edes:RejectDespatchAdviceRequest>
                        <RefDespatchAdviceUUID>#arguments.uuid#</RefDespatchAdviceUUID>
                        <RejectReason></RejectReason>
                        <RejectCode></RejectCode>
                    </edes:RejectDespatchAdviceRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.ESHIPMENT_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://edespatchinvoicesoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://edespatchinvoicesoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("EDespatch.svc", "RejectDespatchAdvice", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata = structNew()>
            
            <cfif xmlresult.Envelope.Body.SendReceiptAdviceResponse.Status.XmlText eq 'Success'>
                <cfset return_code = xmlresult.Envelope.Body.SendReceiptAdviceResponse.StatusEnumValue.XmlText>
                <cfif return_code eq 1>
                    <cfset resultdata.return_code = 0>
                </cfif>
            <cfelse>
                <cfset resultdata.return_code = xmlresult.Envelope.Body.SendReceiptAdviceResponse.StatusEnumValue.XmlText>
            </cfif>

            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="AcceptDespatch" access="public" hint="İrsaliye Kabul">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:edes="http://wsdl.superentegrator.com/edespatch">
                    <soapenv:Header>
                        <edes:Authorization>#ticket#</edes:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                        <edes:AcceptDespatchAdviceRequest>
                            <RefDespatchAdviceUUID>#arguments.uuid#</RefDespatchAdviceUUID>
                        </edes:AcceptDespatchAdviceRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>
        <cfset resultdata = structNew()>

        <cftry>
            <cfif integrationinfo.ESHIPMENT_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://edespatchinvoicesoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://edespatchinvoicesoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("EDespatch.svc", "AcceptDespatchAdvice", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfif xmlresult.Envelope.Body.SendReceiptAdviceResponse.Status.XmlText eq 'Success'>
                <cfset return_code = xmlresult.Envelope.Body.SendReceiptAdviceResponse.StatusEnumValue.XmlText>
                <cfif return_code eq 1>
                    <cfset resultdata.serviceresult = xmlresult.Envelope.Body.SendReceiptAdviceResponse.Status.XmlText>
                    <cfset resultdata.return_code = 0>
                </cfif>
            <cfelse>
                <cfset resultdata.serviceresult = "Hata">
                <cfset resultdata.return_code = xmlresult.Envelope.Body.SendReceiptAdviceResponse.StatusEnumValue.XmlText>
            </cfif>

            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

        
    </cffunction>

    <cffunction name="get_pdf" access="remote">
        <cfset upload_folder = application.systemParam.systemParam().upload_folder>   
        <cfset dir_seperator = application.systemParam.systemParam().dir_seperator />

        <cfquery name="GET_INV_DET" datasource="#arguments.dsn2_name#">
            SELECT PATH FROM ESHIPMENT_RELATION WHERE UUID = '#arguments.uuid#'
        </cfquery>
        <cffile action="read" file="#replace("#upload_folder##get_inv_det.path#","\","/","all")#" variable="inv_xml_data" charset="utf-8">
        <cfset xml_doc = XmlParse(inv_xml_data)>
        
        <cfset xslt = toString(tobinary(xml_doc.DespatchAdvice.AdditionalDocumentReference[1].Attachment.EmbeddedDocumentBinaryObject.XmlText))>

        <cfoutput>#XmlTransform(xml_doc, xslt)#</cfoutput>

    </cffunction>

</cfcomponent>