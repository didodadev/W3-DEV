<cfcomponent>
    <cfproperty type="any" name="CommonObject">
    <cfproperty type="any" name="Cache_ticket">
    <cfproperty type="string" name="urlPrefix">

    <cfset useTicketCache = 0>

    <cffunction name="init">
        <cfset this.CommonObject = createObject("component", "V16.e_government.cfc.dogan.efatura.common")>
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
            <cfhttpparam type="header" name="content-legth" value="#len(arguments.body)#">
            <cfhttpparam type="xml" name="message" value="#trim(arguments.body)#">
        </cfhttp>
        <cfreturn requestResult>
    </cffunction>

    <cffunction name="GetFormsAuthentication" access="public">
        <cfargument type="numeric" name="company_id" default = "#session.ep.company_id#">
        <cfif useTicketCache and isDefined("this.Cache_ticket")>
            <cfreturn this.Cache_ticket>
        </cfif>

        <cfset authvars = this.CommonObject.GetAuthorizationVars(company_id : arguments.company_id)>

        <cfxml variable="ticket_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://schemas.i2i.com/ei/wsdl">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <wsdl:LoginRequest>
                            <REQUEST_HEADER>
                                <SESSION_ID>-1</SESSION_ID>
                            </REQUEST_HEADER>
                            <USER_NAME>#authvars.loginName#</USER_NAME>
                            <PASSWORD><![CDATA[#authvars.password#]]></PASSWORD>
                        </wsdl:LoginRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("AuthenticationWS", "http://tempuri.org/LoginRequest", ticket_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfif useTicketCache>
                <cfset this.Cache_ticket = xmlresult.Envelope.Body.LoginResponse.SESSION_ID.XmlText>
            </cfif>
            <!--- 10013 : Geçersiz Kullanıcı --->
            <cfif structKeyExists(xmlresult.Envelope.Body.LoginResponse,'ERROR_TYPE')>
                <cfreturn xmlresult.Envelope.Body.LoginResponse.ERROR_TYPE.ERROR_SHORT_DES.XmlText>
            <cfelse>
                <cfreturn xmlresult.Envelope.Body.LoginResponse.SESSION_ID.XmlText>
            </cfif>
            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="GetEFaturaCustomerFullList" access="public" hint="E-Fatura müşteri listesini döndürür">
        <cfargument name="startdate" default="">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="invoicecustomerlist_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://schemas.i2i.com/ei/wsdl">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <wsdl:GetGibUserListRequest>
                            <REQUEST_HEADER>
                                <SESSION_ID>#ticket#</SESSION_ID>
                            </REQUEST_HEADER>
                            <DOCUMENT_TYPE>INVOICE</DOCUMENT_TYPE>
                            <ALIAS_MODIFY_DATE>#arguments.startdate#</ALIAS_MODIFY_DATE>
                        </wsdl:GetGibUserListRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("AuthenticationWS", "http://tempuri.org/GetGibUserListRequest", invoicecustomerlist_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.GetGibUserListResponse.CONTENT.XmlText>

            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="SendInvoiceData" access="public">
        <cfargument name="ubl">
        <cfargument name="invoice_number">
        <cfargument name="directory_name">
        <cfargument name="invoice_prefix">

        <cfset authvars = this.CommonObject.GetAuthorizationVars()>
        
        <cfset ticket = GetFormsAuthentication()>

        <cffile action="write" file="#directory_name#/#invoice_number#.xml" output="#trim(ubl)#" charset="utf-8" />
        
        <cffile action="readbinary" file="#directory_name#/#invoice_number#.xml" variable="ubl_binary">
        <cfxml variable="einvoice_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://schemas.i2i.com/ei/wsdl" xmlns:xmime="http://www.w3.org/2005/05/xmlmime">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <wsdl:SendInvoiceRequest>
                            <REQUEST_HEADER>
                                <SESSION_ID>#ticket#</SESSION_ID>
                                <COMPRESSED>N</COMPRESSED>
                            </REQUEST_HEADER>
                            <cfif isDefined('arguments.invoice_prefix') and len(arguments.invoice_prefix)>
                                <SERI_PREFIX>#arguments.invoice_prefix#</SERI_PREFIX>
                            </cfif>
                            <INVOICE>
                                <CONTENT xmime:contentType="application/?">#toBase64(ubl)#</CONTENT>
                            </INVOICE>
                        </wsdl:SendInvoiceRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("EFaturaOIB", "http://tempuri.org/SendInvoiceRequest", einvoice_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata = structNew()>
            <cfset resultdata.invoices = arrayNew(1)>

            <cfif structKeyExists(xmlresult.Envelope.Body,'Fault')> <!--- hata varsa --->
                <cfset error_code = xmlresult.Envelope.Body.Fault.detail.RequestFault.error_code.XmlText>

                <cfset resultdata.ServiceResultDescription = xmlresult.Envelope.Body.Fault.detail.RequestFault.error_short_des.XmlText>
                <cfset resultdata.ErrorCode = error_code>
                <cfset resultdata.statuscode = '0'>
                <cfset resultdata.uuid = ''>

                <cfif error_code eq 2005 and listLen(xmlresult.Envelope.Body.Fault.detail.RequestFault.error_short_des.XmlText,':') eq 3>
                    <cfset current_uuid = listFirst(listGetAt(xmlresult.Envelope.Body.Fault.detail.RequestFault.error_short_des.XmlText,2,':'),',')>
                    <cfset current_invoice_id = listGetAt(xmlresult.Envelope.Body.Fault.detail.RequestFault.error_short_des.XmlText,3,':')>

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
                                            <UUID>#current_uuid#</UUID>
                                            <DIRECTION>OUT</DIRECTION>
                                        </INVOICE_SEARCH_KEY>
                                    </wsdl:GetInvoiceRequest>
                                </soapenv:Body>
                            </soapenv:Envelope>
                        </cfoutput>
                    </cfxml>

                    <cfset httpresult = SendHttp("EFaturaOIB", "http://tempuri.org/GetInvoice", einvoice_data)>
                    <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

                    <cfset invoice = structNew()>

                    <cfset invoice_number = current_invoice_id>

                    <cfset this.CommonObject.addEinvoiceSendingDetail(
                        service_result: 'Successful',
                        uuid : xmlParse(ubl).Invoice.UUID.XmlText,
                        einvoice_id : xmlParse(ubl).Invoice.ID.XmlText,
                        status_description : 'GÖNDERİM ONAYI BEKLENİYOR',
                        service_result_description : '',
                        status_code : 1,
                        error_code : 0,
                        action_id : url.action_id,
                        action_type : url.action_type,
                        belgeOid : '',
                        invoice_type_code : xmlParse(ubl).Invoice.InvoiceTypeCode.XmlText
                    )>

                    <cfset this.CommonObject.addEinvoiceRelation(
                        uuid : xmlParse(ubl).Invoice.UUID.XmlText,
                        integration_id : invoice_number,
                        einvoice_id : xmlParse(ubl).Invoice.ID.XmlText,
                        profile_id : xmlParse(ubl).Invoice.ProfileID.XmlText,
                        action_id : url.action_id,
                        action_type : url.action_type,
                        path : '#directory_name#/#invoice_number#.xml',
                        sender_type : 4
                    )>  

                    <cfset invoice.uuid = xmlParse(ubl).Invoice.UUID.XmlText>
                    <cfset invoice.invoiceid = xmlParse(ubl).Invoice.ID.XmlText>
                    <cfset invoice.einvoiceid = invoice_number>
                    <cfset invoice.status_code = 1>

                    <cfset arrayAppend( resultdata.invoices, invoice )>

                    <cfset resultdata.serviceResult = 'Successful'>
                    <cfset resultdata.statusCode = 1>
                <cfelse>
                    <cfset this.CommonObject.addEinvoiceSendingDetail(
                        service_result: 'Error',
                        uuid : xmlParse(ubl).Invoice.UUID.XmlText,
                        einvoice_id : xmlParse(ubl).Invoice.ID.XmlText,
                        status_description : left(xmlresult.Envelope.Body.Fault.detail.RequestFault.ERROR_SHORT_DES.XmlText,50),
                        service_result_description : xmlresult.Envelope.Body.Fault.detail.RequestFault.ERROR_LONG_DES.XmlText,
                        status_code : 0,
                        error_code : xmlresult.Envelope.Body.Fault.detail.RequestFault.ERROR_CODE.XmlText,
                        action_id : url.action_id,
                        action_type : url.action_type,
                        belgeOid : '',
                        invoice_type_code : xmlParse(ubl).Invoice.InvoiceTypeCode.XmlText
                    )>

                    <cfset resultdata.serviceResult = 'Error'>
                </cfif>
            <cfelse>
                <cfset invoice = structNew()>

                <cfset current_uuid = xmlParse(ubl).Invoice.UUID.XmlText>

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
                                        <UUID>#current_uuid#</UUID>
                                        <DIRECTION>OUT</DIRECTION>
                                    </INVOICE_SEARCH_KEY>
                                </wsdl:GetInvoiceRequest>
                            </soapenv:Body>
                        </soapenv:Envelope>
                    </cfoutput>
                </cfxml>

                <cfset httpresult = SendHttp("EFaturaOIB", "http://tempuri.org/GetInvoice", einvoice_data)>
                <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

                <cfset this.CommonObject.addEinvoiceSendingDetail(
                    service_result: 'Successful',
                    uuid : xmlParse(ubl).Invoice.UUID.XmlText,
                    einvoice_id : xmlParse(ubl).Invoice.ID.XmlText,
                    status_description : 'GÖNDERİM ONAYI BEKLENİYOR',
                    service_result_description : '',
                    status_code : 1,
                    error_code : 0,
                    action_id : url.action_id,
                    action_type : url.action_type,
                    belgeOid : '',
                    invoice_type_code : xmlParse(ubl).Invoice.InvoiceTypeCode.XmlText
                )>

                <cfset this.CommonObject.addEinvoiceRelation(
                    uuid : xmlParse(ubl).Invoice.UUID.XmlText,
                    integration_id : invoice_number,
                    einvoice_id : xmlParse(ubl).Invoice.ID.XmlText,
                    profile_id : xmlParse(ubl).Invoice.ProfileID.XmlText,
                    action_id : url.action_id,
                    action_type : url.action_type,
                    path : '#directory_name#/#invoice_number#.xml',
                    sender_type : 4
                )>

                <cfset invoice.uuid = xmlParse(ubl).Invoice.UUID.XmlText>
                <cfset invoice.invoiceid = xmlParse(ubl).Invoice.ID.XmlText>
                <cfset invoice.einvoiceid = invoice_number>
                <cfset invoice.status_code = 1>
                <cfset arrayAppend( resultdata.invoices, invoice )>

                <cfset resultdata.serviceResult = 'Successful'>
                <cfset resultdata.statusCode = 1>
            </cfif>

            <cftry>
                <cfxml variable="get_invoice_number">
                    <cfoutput>
                        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://schemas.i2i.com/ei/wsdl">
                        <soapenv:Header/>
                        <soapenv:Body>
                            <wsdl:GetInvoiceRequest>
                                <REQUEST_HEADER>
                                    <SESSION_ID>#ticket#</SESSION_ID>
                                    <APPLICATION_NAME>W3C</APPLICATION_NAME>
                                    <COMPRESSED>N</COMPRESSED>
                                </REQUEST_HEADER>
                                <INVOICE_SEARCH_KEY>
                                    <UUID>#trim(xmlParse(ubl).Invoice.UUID.XmlText)#</UUID>
                                    <READ_INCLUDED>true</READ_INCLUDED>
                                    <DIRECTION>OUT</DIRECTION>
                                </INVOICE_SEARCH_KEY>
                                <HEADER_ONLY>Y</HEADER_ONLY>
                            </wsdl:GetInvoiceRequest>
                        </soapenv:Body>
                        </soapenv:Envelope>
                    </cfoutput>
                </cfxml>
                <cfset httpresult = SendHttp("EFaturaOIB", "http://tempuri.org/GetInvoiceRequest", get_invoice_number)>
                <cfset xmlresult = xmlParse(httpresult.Filecontent)>
                <cfset resultdata.invoices[1].invoiceid = xmlresult.Envelope.Body.GetInvoiceResponse.INVOICE.XmlAttributes.ID>
                <cfcatch>
                    <cfsavecontent  variable="cc">
                        <cfdump  var="#cfcatch#">
                    </cfsavecontent>
                </cfcatch>
            </cftry>

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
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://schemas.i2i.com/ei/wsdl" xmlns:xmime="http://www.w3.org/2005/05/xmlmime">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <wsdl:GetInvoiceStatusRequest>
                            <REQUEST_HEADER>
                                <SESSION_ID>#ticket#</SESSION_ID>
                                <APPLICATION_NAME>W3C</APPLICATION_NAME>
                            </REQUEST_HEADER>
                            <INVOICE UUID = "#arguments.uuid#">
                            </INVOICE>
                        </wsdl:GetInvoiceStatusRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("EFaturaOIB", "http://tempuri.org/GetInvoiceStatusRequest", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>

            <cfif structKeyExists(xmlresult.Envelope.Body,'Fault')>
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.Fault.detail.RequestFault.ERROR_CODE.XmlText>
                <cfset resultdata.serviceresultdescription = xmlresult.Envelope.Body.Fault.detail.RequestFault.ERROR_CODE.XmlText>
                <cfset resultdata.statuscode = 0>
            <cfelse>
                <cfset resultdata.uuid = xmlresult.Envelope.Body.GetInvoiceStatusResponse.INVOICE_STATUS.ENVELOPE_IDENTIFIER.XmlText>
                <cfset resultdata.statusdescription = xmlresult.Envelope.Body.GetInvoiceStatusResponse.INVOICE_STATUS.GIB_STATUS_DESCRIPTION.XmlText>
                <cfset resultdata.statuscode = xmlresult.Envelope.Body.GetInvoiceStatusResponse.INVOICE_STATUS.GIB_STATUS_CODE.XmlText>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="getInvoicePDF" access="public" hint="Faturanın görselini getirir">
        <cfargument name="uuid">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://schemas.i2i.com/ei/wsdl" xmlns:xmime="http://www.w3.org/2005/05/xmlmime">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <wsdl:GetInvoiceWithTypeRequest>
                            <REQUEST_HEADER>
                                <SESSION_ID>#ticket#</SESSION_ID>
                                <APPLICATION_NAME>W3C</APPLICATION_NAME>
                            </REQUEST_HEADER>
                            <INVOICE_SEARCH_KEY>
                                <UUID>#arguments.uuid#</UUID>
                                <TYPE>PDF</TYPE>
                                <DIRECTION>OUT</DIRECTION>
                            </INVOICE_SEARCH_KEY>
                        </wsdl:GetInvoiceWithTypeRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("EFaturaOIB", "http://tempuri.org/GetInvoiceWithTypeRequest", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.pdf_data = xmlresult.Envelope.Body.GetInvoiceWithTypeResponse.INVOICE.CONTENT.XmlText>
            

            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="InvoiceApproval" access="public" hint="">
        <cfargument name="uuid">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://schemas.i2i.com/ei/wsdl" xmlns:xmime="http://www.w3.org/2005/05/xmlmime">
                    <soapenv:Header/>
                    <soapenv:Body>
                        <wsdl:SendInvoiceResponseWithServerSignRequest>
                            <REQUEST_HEADER>
                                <SESSION_ID>#ticket#</SESSION_ID>
                                <APPLICATION_NAME>W3C</APPLICATION_NAME>
                            </REQUEST_HEADER>
                            <STATUS>KABUL</STATUS>
                            <INVOICE UUID = "#trim(arguments.uuid)#">
                            </INVOICE>
                        </wsdl:SendInvoiceResponseWithServerSignRequest>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("EFaturaOIB", "http://tempuri.org/SendInvoiceResponseWithServerSignRequest", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfif structKeyExists(xmlresult.Envelope.Body, 'Fault')>
                <cfset return_code = xmlresult.Envelope.Body.Fault.detail.RequestFault.ERROR_CODE.XmlText>

                <cfif return_code eq 2005>
                    <cfset resultdata.return_code = 0>
                </cfif>
            <cfelse>
                <cfset request_return = xmlresult.Envelope.Body.SendInvoiceResponseWithServerSignResponse.REQUEST_RETURN>
                <cfset resultdata.return_code = request_return.RETURN_CODE.XmlText>
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

        <cfxml variable="availableinvoices_data"><cfoutput>
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://schemas.i2i.com/ei/wsdl">
            <soapenv:Header/>
            <soapenv:Body>
                <wsdl:GetInvoiceRequest>
                    <REQUEST_HEADER>
                        <SESSION_ID>#ticket#</SESSION_ID>
                        <APPLICATION_NAME>W3C</APPLICATION_NAME>
                        <COMPRESSED>N</COMPRESSED>
                    </REQUEST_HEADER>
                    <INVOICE_SEARCH_KEY>
                        <LIMIT>100</LIMIT>
                        <START_DATE>#dateFormat(dateAdd('d',-30,now()),'yyyy-mm-dd')#</START_DATE>
                        <END_DATE>#dateFormat(dateAdd('d',1,now()),'yyyy-mm-dd')#</END_DATE>
                        <DIRECTION>IN</DIRECTION>
                    </INVOICE_SEARCH_KEY>
                    <HEADER_ONLY>N</HEADER_ONLY>
                </wsdl:GetInvoiceRequest>
            </soapenv:Body>
            </soapenv:Envelope></cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("EFaturaOIB", "http://tempuri.org/GetInvoiceRequest", availableinvoices_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>

            <cfset resultdata = structNew()>
            <cfset resultdata.invoices = arrayNew(1)>

            <cfloop array="#xmlresult.Envelope.Body.GetInvoiceResponse.xmlchildren#" index="child">
                <cfset invoice = structNew()>
                <cfset invoice.uuid = child.XmlAttributes.UUID>
                <cfset invoice.invoiceid = child.XmlAttributes.ID>
                <cfset invoice.statuscode = child.header.STATUS_CODE.XmlText>
                <cfset invoice.statusdescription = child.header.STATUS_DESCRIPTION.XmlText>
                <cfset invoice.invoicetypecode = child.header.INVOICE_TYPE_CODE.XmlText>
                <cfset invoice.sendertaxid = child.header.SENDER.XmlText>
                <cfset invoice.receivertaxid = child.header.RECEIVER.XmlText>
                <cfset invoice.profileid = child.header.PROFILEID.XmlText>
                <cfset invoice.partyname = child.header.supplier.XmlText>
                <cfset invoice.issuedate = child.header.ISSUE_DATE.XmlText>
                <cfset invoice.issuetime = child.header.ISSUE_DATE.XmlText>
                <cfset invoice.receiverpostboxname = child.header.TO.XmlText>
                <cfset invoice.senderpostboxname = child.header.FROM.XmlText>
                <cfset invoice.totalamount = child.header.PAYABLE_AMOUNT.XmlText>
                <cfset invoice.currency = child.header.PAYABLE_AMOUNT.XmlAttributes.currencyID>
                <cfset invoice.createdate = child.header.ISSUE_DATE.XmlText>
                <cfset invoice.content = child.content.XmlText>
                <cfset arrayAppend( resultdata.invoices, invoice )>
            </cfloop>

            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>
