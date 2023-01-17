<!---
    Date :          10.03.2022
    Description :   SuperEntegrator Efatura Soap Katmanı
    Notes :         
--->
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
        <cfset this.CommonObject = createObject("component", "V16.e_government.cfc.super.einvoice.common")>
        <cfset integrationinfo = this.CommonObject.GetEInvoiceIntegrationInfo()>

        <cfif integrationinfo.recordcount gt 0>
            <cfif integrationinfo.EINVOICE_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = trim(integrationinfo.EINVOICE_TEST_URL)>
            <cfelse>
                <cfset this.urlPrefix = trim(integrationinfo.EINVOICE_LIVE_URL)>
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
        <cfargument type="numeric" name="company_id" default = "#session_base.company_id#">
        <cfif useTicketCache and isDefined("this.Cache_ticket")>
            <cfreturn this.Cache_ticket>
        </cfif>

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

    <cffunction name="GetEFaturaCustomerFullList" access="public" hint="E-Fatura müşteri listesini döndürür">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="invoicecustomerlist_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:gib="http://wsdl.superentegrator.com/gibuserlist">
                    <soapenv:Header>
                        <gib:Authorization>#ticket#</gib:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                        <gib:UserListRequest>
                            <UserType>EInvoice</UserType>
                            <AliasType>Gb</AliasType>
                        </gib:UserListRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.EINVOICE_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://gibuserlistsoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://gibuserlistsoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("GibUserList.svc", "UserList", invoicecustomerlist_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.UserListResponse.UserListData.XmlText>

            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="EFaturaCustomerListWithDay" access="public">
        <cfset ticket = GetFormsAuthentication()>
        
        <cfxml variable="invoicecustomerlist_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:gib="http://wsdl.superentegrator.com/gibuserlist">
                <soapenv:Header>
                    <gib:Authorization>#ticket#</gib:Authorization>
                </soapenv:Header>
                <soapenv:Body>
                    <gib:AuthToken>#ticket#</gib:AuthToken>
                    <gib:LastChangedUserListRequest>
                        <FilterStartDate>#dateFormat(dateAdd('d', -7, now()),'yyy-mm-dd')#</FilterStartDate>
                        <UserListType>EInvoice</UserListType>
                        <AliasType>Gb</AliasType>
                    </gib:LastChangedUserListRequest>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.EINVOICE_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://gibuserlistsoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://gibuserlistsoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("GibUserList.svc", "LastChangedUserList", invoicecustomerlist_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.userList = arrayNew(1)>

            <cfloop array="#xmlresult.Envelope.Body.LastChangedUserListResponse.Aliases#" index="child">
               <!---  <cfdump var="#child#" abort="true"> --->
                <cfset list = structNew()>
                <cfset list.Identifier = child.Identifier.XmlText>
                <cfset list.alias = child.Alias.XmlText>
                <cfset list.name = child.Title.XmlText>
                <cfset list.type = child.Type.XmlText>
                <cfset list.firstcreationtime = child.FirstCreateDate.XmlText>
                <cfset list.aliascreationtime = child.AliasCreateDate.XmlText>
                <cfset arrayAppend( resultdata.userList, list )>
            </cfloop>

            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>
    
    <cffunction name="SendInvoiceData" access="public" hint="E-Fatura Gönderimi">
        <cfargument name="ubl">
        <cfargument name="invoice_number">
        <cfargument name="directory_name">
        <cfargument name="invoice_prefix">
        <cfargument name="alias">

        <cfset authvars = this.CommonObject.GetAuthorizationVars()>
        
        <cfset ticket = GetFormsAuthentication()>

        <cffile action="write" file="#directory_name#/#invoice_number#.xml" output="#trim(ubl)#" charset="utf-8" />
        
        <cffile action="readbinary" file="#directory_name#/#invoice_number#.xml" variable="ubl_binary">
        <cfxml variable="einvoice_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http://wsdl.superentegrator.com/einvoice">
                    <soapenv:Header>
                        <ein:Authorization>#ticket#</ein:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                        <!--- <ein:AuthToken>?</ein:AuthToken> --->
                        <ein:SendInvoiceRequest>
                            <!--Optional:-->
                            <SenderGbAlias></SenderGbAlias>
                            <!--Optional:-->
                            <ReceiverPkAlias>#arguments.receiver_alias#</ReceiverPkAlias>
                            <!--Optional:-->
                            <ErpReferenceId>#arguments.invoice_number#</ErpReferenceId>
                            <!--Optional:-->
                            <CustomerBranchCode></CustomerBranchCode>
                            <!--Optional:-->
                            <MappingCode></MappingCode>
                            <!--Optional:-->
                            <InvoiceIdPrefix>#arguments.invoice_prefix#</InvoiceIdPrefix>
                            <!--Optional:-->
                            <XsltCode></XsltCode>
                            <!--Optional:-->
                            <InvoiceData>#trim(toBase64(ubl))#</InvoiceData>
                        </ein:SendInvoiceRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.EINVOICE_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://einvoicesoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://einvoicesoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("EInvoice.svc", "SendInvoice", einvoice_data)>
            <cfset xml_filecontent = XMLParse(httpresult.filecontent).Envelope.Body.SendInvoiceResponse>

            <cfset resultdata = structNew()>
            <cfset resultdata.invoices = arrayNew(1)>

            <cfif listFind('60,80,110', xml_filecontent.StatusEnumValue.xmlText)>
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
                <cfset this.CommonObject.addEinvoiceSendingDetail(
                    service_result: 'Error',
                    uuid : xmlParse(ubl).Invoice.UUID.XmlText,
                    einvoice_id : xmlParse(ubl).Invoice.ID.XmlText,
                    status_description : resultdata.STATUS_DESCRIPTION,
                    service_result_description : resultdata.SERVICE_RESULT,
                    status_code : resultdata.STATUSCODE,
                    error_code : xml_filecontent.StatusEnumValue.xmlText,
                    action_id : url.action_id,
                    action_type : url.action_type,
                    belgeOid : '',
                    invoice_type_code : xmlParse(ubl).Invoice.InvoiceTypeCode.XmlText
                )>
            <cfelse>
                <cfif listFind('1', xml_filecontent.StatusEnumValue.xmlText)>
                    <cfset resultdata.STATUSCODE = 1>
                </cfif>

                <cfset resultdata.SERVICE_RESULT = 'GÖNDERİM ONAYI BEKLENİYOR'>
                <cfset resultdata.UUID = xml_filecontent.InvoiceUUID.XmlText>
                <cfset resultdata.E_INVOICE_ID = xml_filecontent.InvoiceId.XmlText>
                <cfset resultdata.STATUS_DESCRIPTION = left(xml_filecontent.StatusDescription.xmlText,150)>
                <cfset resultdata.STATUSCODE = 1>
                <cfset resultdata.serviceResult = xml_filecontent.Status.XmlText>

                <cfset this.CommonObject.addEinvoiceSendingDetail(
                    service_result: 'Success',
                    uuid : resultdata.UUID,
                    einvoice_id : resultdata.E_INVOICE_ID,
                    status_description : resultdata.STATUS_DESCRIPTION,
                    service_result_description : resultdata.SERVICE_RESULT,
                    status_code : resultdata.STATUSCODE,
                    error_code : 0,
                    action_id : url.action_id,
                    action_type : url.action_type,
                    belgeOid : '',
                    invoice_type_code : xmlParse(ubl).Invoice.InvoiceTypeCode.XmlText
                )>  
                
                <cfset this.CommonObject.addEinvoiceRelation(
                    uuid : resultdata.UUID,
                    integration_id : resultdata.E_INVOICE_ID,
                    einvoice_id : arguments.invoice_number,
                    profile_id : xmlParse(ubl).Invoice.ProfileID.XmlText,
                    action_id : url.action_id,
                    action_type : url.action_type,
                    path : arguments.path,
                    sender_type : 5
                )>
            </cfif>

            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="CheckInvoiceState" access="public" hint="Faturanın durumunu sorgular">
        <cfargument name="uuid">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http://wsdl.superentegrator.com/einvoice">
                    <soapenv:Header>
                        <ein:Authorization>#ticket#</ein:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                        <ein:GetInvoiceStatusRequest>
                            <UUIDType>DocumentUUID</UUIDType>
                            <!--Optional:-->
                            <UUID>#arguments.uuid#</UUID>
                            <DocumentDirection>Outgoing</DocumentDirection>
                        </ein:GetInvoiceStatusRequest>
                    </soapenv:Body>
                 </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.EINVOICE_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://einvoicesoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://einvoicesoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("EInvoice.svc", "GetInvoiceStatus", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <!--- <cfdump var="#xmlresult#" abort> --->
            <cfset resultdata = structNew()>

            <cfif xmlresult.Envelope.Body.GetInvoiceStatusResponse.Status neq 'Success'>
                <cfset resultdata.statuscode = 0>
            <cfelse>
                <cfset resultdata.uuid = xmlresult.Envelope.Body.GetInvoiceStatusResponse.InvoiceStatuses.InvoiceUUID.XmlText>
                <cfset resultdata.statusdescription = xmlresult.Envelope.Body.GetInvoiceStatusResponse.InvoiceStatuses.StatusDescription.XmlText>
                <cfset resultdata.statuscode = xmlresult.Envelope.Body.GetInvoiceStatusResponse.InvoiceStatuses.GibStatus.XmlText>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="getInvoicePDF" access="public" hint="Faturanın görselini getirir">
        <cfargument name="uuid">
        <cfargument name="outputType" default="Pdf">
        <cfargument name="direction" default="Outgoing">
        <cfargument name="ticket_req" default="1">

        <cfif arguments.ticket_req eq 1>
            <cfset ticket = GetFormsAuthentication()>
        </cfif>
            
        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http://wsdl.superentegrator.com/einvoice">
                    <soapenv:Header>
                        <ein:Authorization>#ticket#</ein:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>          
                        <ein:GetInvoiceRequest>
                            <OutputType>#arguments.outputType#</OutputType>
                            <UUIDType>DocumentUUID</UUIDType>
                            <UUID>#arguments.uuid#</UUID>
                            <DocumentDirection>#arguments.direction#</DocumentDirection>
                            <IncludeInvoiceBinaryData>true</IncludeInvoiceBinaryData>
                            <CompressedBinaryData>false</CompressedBinaryData>
                            <SetErpStatus>New</SetErpStatus>
                        </ein:GetInvoiceRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.EINVOICE_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://einvoicesoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://einvoicesoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("EInvoice.svc", "GetInvoice", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata = structNew()>
            <cfset resultdata.service_result = xmlresult.Envelope.Body.GetInvoiceResponse.Status.XmlText>
            <cfif resultdata.service_result eq 'Success'>
                <cfset resultdata.pdf_data = xmlresult.Envelope.Body.GetInvoiceResponse.OutputDatas.XmlText>
            </cfif>
            
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="InvoiceApproval" access="public" hint="">
        <cfargument name="uuid">
        <cfargument name="responseType" default="Accept">
        <cfargument name="message" default="">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http://wsdl.superentegrator.com/einvoice">
                    <soapenv:Header>
                        <ein:Authorization>#ticket#</ein:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                        <ein:SendInvoiceResponseRequest>
                            <SenderGbAlias></SenderGbAlias>
                            <ReceiverPkAlias></ReceiverPkAlias>
                            <InvoiceUUID>#trim(arguments.uuid)#</InvoiceUUID>
                            <ResponseType>#arguments.responseType#</ResponseType>
                            <cfif len(arguments.message) and arguments.responseType eq 'Reject'>
                            <ResponseMessage>#arguments.message#</ResponseMessage>
                            </cfif>
                        </ein:SendInvoiceResponseRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.EINVOICE_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://einvoicesoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://einvoicesoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("EInvoice.svc", "SendInvoiceResponse", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfif xmlresult.Envelope.Body.SendInvoiceResponseResponse.Status.XmlText eq 'Success' or xmlresult.Envelope.Body.SendInvoiceResponseResponse.Status.XmlText eq 'InvalidStatusForAnswer'>
                <cfset return_code = xmlresult.Envelope.Body.SendInvoiceResponseResponse.StatusEnumValue.XmlText>
                <cfif listFind('1,110', return_code)>
                    <cfset resultdata.return_code = 0>
                </cfif>
            <cfelse>
                <cfset resultdata.return_code = xmlresult.Envelope.Body.SendInvoiceResponseResponse.StatusEnumValue.XmlText>
            </cfif>

            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="GetAvailableInvoices" access="public" hint="Gelen e-fatura listesini verir">
        <cfargument name="startdate" default="">
        <cfargument name="enddate" default="">
        <cfargument name="company_id" required = "yes">

        <cfset authvars = this.CommonObject.GetAuthorizationVars(company_id : arguments.company_id)>
        <cfset ticket = GetFormsAuthentication(company_id : arguments.company_id)>

        <cfxml variable="availableinvoices_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http://wsdl.superentegrator.com/einvoice">
                    <soapenv:Header>
                        <ein:Authorization>#ticket#</ein:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                        <ein:GetInvoiceListRequest>
                            <FilterDateType>DocumentDate</FilterDateType>
                            <StartDate>#dateFormat(dateAdd('d',-30,now()),'yyyy-mm-dd')#</StartDate>
                            <EndDate>#dateFormat(dateAdd('d',1,now()),'yyyy-mm-dd')#</EndDate>
                            <DocumentDirection>Incoming</DocumentDirection>
                        </ein:GetInvoiceListRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.EINVOICE_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://einvoicesoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://einvoicesoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("EInvoice.svc", "GetInvoiceList", availableinvoices_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata = structNew()>
            <cfset resultdata.invoices = arrayNew(1)>
            <cfif structKeyExists(xmlresult.Envelope.Body.GetInvoiceListResponse,'InvoiceList')>
                <cfloop array="#xmlresult.Envelope.Body.GetInvoiceListResponse.InvoiceList#" index="child">
                    <cfset invoice = structNew()>
                    <cfset invoice.uuid = child.InvoiceUUID.XmlText>
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
                    <cfset invoice.totalamount = child.PayableAmount.XmlText>
                    <cfset invoice.currency = child.DocumentCurrencyCode.XmlText>
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
    
    <cffunction name="GetUserAliases" access="public" hint="Kullanıcı Alias Sorgulama">
        <cfargument name="vkn_tckn" required="true">
        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:gib="http://wsdl.superentegrator.com/gibUserAliases">
                    <soapenv:Header>
                        <gib:Authorization>#ticket#</gib:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                        <gib:UserAliasesRequest>
                            <Identifier>#arguments.vkn_tckn#</Identifier>
                            <UserListType>EInvoice</UserListType>
                            <AliasType>Gb</AliasType>
                        </gib:UserAliasesRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.EINVOICE_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://gibuserlistsoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://gibuserlistsoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("GibUserList.svc", "UserAliases", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfif xmlresult.Envelope.Body.UserAliasesResponse.Status.XmlText eq 'NotFound'>
                <cfset resultdata.status_description = xmlresult.Envelope.Body.UserAliasesResponse.StatusDescription.XmlText>
                <cfset resultdata.status = 0>
            <cfelse>
                <cfset resultdata.type = xmlresult.Envelope.Body.UserAliasesResponse.Aliases.Type.XmlText>
                <cfset resultdata.alias = xmlresult.Envelope.Body.UserAliasesResponse.Aliases.Alias.XmlText>
                <cfset resultdata.create_date = xmlresult.Envelope.Body.UserAliasesResponse.Aliases.FirstCreateDate.XmlText>
                <cfset resultdata.status = 1>
            </cfif>

            <cfreturn resultdata>
            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="IsEinvoiceUser" access="public" hint="Kullanıcı Mükellef Sorgulama">
        <cfargument name="vkn_tckn" required="true">
        <cfargument name="alias" required="true">

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:gib="http://wsdl.superentegrator.com/gibuserlist">
                    <soapenv:Header>
                        <gib:Authorization>#ticket#</gib:Authorization>
                    </soapenv:Header>
                    <soapenv:Body>
                        <gib:IsEInvoiceUserRequest>
                            <Identifier>#arguments.vkn_tckn#</Identifier>
                            <AliasType>Gb</AliasType>
                            <Alias>#arguments.alias#</Alias>
                        </gib:IsEInvoiceUserRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfif integrationinfo.EINVOICE_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = 'https://gibuserlistsoapapitest.superentegrator.com/'>
            <cfelse>
                <cfset this.urlPrefix = 'https://gibuserlistsoapapi.superentegrator.com/'>
            </cfif>
            <cfset httpresult = SendHttp("GibUserList.svc", "IsEInvoiceUser", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata.is_exist = xmlresult.Envelope.Body.IsEInvoiceUserResponse.IsEInvoiceUser.XmlText>
            <cfset resultdata.status = xmlresult.Envelope.Body.IsEInvoiceUserResponse.Status.XmlText>
            
            <cfreturn resultdata>
            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>
</cfcomponent>
