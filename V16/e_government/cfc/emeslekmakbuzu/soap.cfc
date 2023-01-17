<!---
    Author :        İlker Altındal
    Date :          15.02.2021
    Description :   Eserbest Meslek Makbuzu soap katmanı  
--->
<cfcomponent>

    <cfproperty type="any" name="CommonObject">
    <cfproperty type="string" name="urlPrefix">

    <cffunction name="init">
        <cfset this.CommonObject = createObject("component", "V16.e_government.cfc.emeslekmakbuzu.common")>
        
        <cfset integrationinfo = this.CommonObject.GetEVoucherIntegrationInfo()>
        
        <cfif integrationinfo.recordcount gt 0>
            <cfif integrationinfo.EVOUCHER_TEST_SYSTEM eq 1>
                <cfset this.urlPrefix = trim(integrationinfo.EVOUCHER_TEST_URL)>
            <cfelse>
                <cfset this.urlPrefix = trim(integrationinfo.EVOUCHER_LIVE_URL)>
            </cfif>
            <cfif right(this.urlPrefix, 1) neq "/">
                <cfset this.urlPrefix = this.urlPrefix & "/">
            </cfif>
        </cfif>
        
    </cffunction>

    <cffunction name="SendHttp" access="private">
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
        <cfset authvars = this.CommonObject.GetAuthorizationVars()>

        <cfxml variable="ticket_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                    <soapenv:Header/>
                    <soapenv:Body>
                    <tem:GetFormsAuthenticationToken>
                        <tem:CorporateCode>#authvars.corporateCode#</tem:CorporateCode>
                        <tem:LoginName>#authvars.loginName#</tem:LoginName>
                        <tem:Password>#authvars.password#</tem:Password>
                    </tem:GetFormsAuthenticationToken>
                    </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/GetFormsAuthenticationToken", ticket_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfreturn xmlresult.Envelope.Body.GetFormsAuthenticationTokenResponse.GetFormsAuthenticationTokenResult.XmlText>
            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="SendVoucherData" access="public" hint="Makbuz Verisi Gönder">
        <cfargument name="ubl">
        <cfset authvars = this.CommonObject.GetAuthorizationVars()>
        <cfset ticket = GetFormsAuthentication()>
        <cfxml variable="voucher_data">
            <cfoutput>
            <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:tem="http://tempuri.org/">
            <soap:Header/>
            <soap:Body>
                <tem:SendSeVoucherData>
                    <tem:Ticket>#ticket#</tem:Ticket>
                    <tem:FileType>Xml</tem:FileType>
                    <tem:SeVoucherRawData>#toBase64(trim(arguments.ubl))#</tem:SeVoucherRawData>
                    <tem:CorporateCode>#authvars.corporateCode#</tem:CorporateCode>
                    <tem:MapCode>-1</tem:MapCode>
                    <tem:ReceiverEmailAdress>?</tem:ReceiverEmailAdress>
                </tem:SendSeVoucherData>
            </soap:Body>
            </soap:Envelope>
            </cfoutput>
        </cfxml>
        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/SendSeVoucherData", voucher_data)>
            
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <cfset resultdata = structNew()>
            <cfset resultdata.receipts = arrayNew(1)>

            <cfset resultdata.serviceResult = xmlresult.Envelope.Body.SendSeVoucherDataResponse.SendSeVoucherDataResult.serviceResult.XmlText>
            <cfif resultdata.serviceResult eq "Error">
                <cfset resultdata.ServiceResultDescription = xmlresult.Envelope.Body.SendSeVoucherDataResponse.SendSeVoucherDataResult.ServiceResultDescription.XmlText>
                <cfset resultdata.ErrorCode = xmlresult.Envelope.Body.SendSeVoucherDataResponse.SendSeVoucherDataResult.ErrorCode.XmlText>
            <cfelse>
                <cfloop array="#xmlresult.Envelope.Body.SendSeVoucherDataResponse.SendSeVoucherDataResult.SeVouchers.xmlchildren#" index="child">
                    <cfset receipt = structNew()>
                    <cfset receipt.serviceresult = child.ServiceResult.XmlText>
                    <cfif receipt.serviceresult eq "Error">
                        <cfset receipt.errorcode = child.ErrorCode.XmlText>
                        <cfset receipt.ServiceResultDescription = child.ServiceResultDescription.XmlText>
                        <cfset receipt.statuscode = child.StatusCode.XmlText>
                    <cfelse>
                        <cfset receipt.ServiceResultDescription = child.ServiceResult.XmlText>
                        <cfset receipt.ServiceStatusDescription = child.StatusDescription.XmlText>
                        <cfset receipt.errorcode = child.ErrorCode.XmlText>
                        <cfset receipt.uuid = child.UUID.XmlText>
                        <cfset receipt.receipt_id = child.SeVoucherId.XmlText>
                        <cfset receipt.statuscode = child.StatusCode.XmlText>
                    </cfif>
                    <cfset arrayAppend( resultdata.receipts, receipt )>
                </cfloop>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="CheckVoucherState" access="public" hint="Makbuz durumunu sorgular">
        <cfargument name="uuid">
        <cfargument name="direction" default="Outgoing" hint="Giden için Outgoing gelen için Incoming">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="check_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:CheckESeVoucherState>
                        <tem:Ticket>#ticket#</tem:Ticket>
                        <tem:SevoucherNumber>#arguments.uuid#</tem:SevoucherNumber>
                        <tem:SevoucherNumberType>UUID</tem:SevoucherNumberType>
                    </tem:CheckESeVoucherState>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/CheckESeVoucherState", check_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <!--- <cfdump var="#xmlresult#" abort="true"> --->
            <cfset resultdata = structNew()>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.CheckESeVoucherStateResponse.CheckESeVoucherStateResult.ServiceResult.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.CheckESeVoucherStateResponse.CheckESeVoucherStateResult.ErrorCode.XmlText>
                <cfset resultdata.serviceresultdescription = xmlresult.Envelope.Body.CheckESeVoucherStateResponse.CheckESeVoucherStateResult.ServiceResultDescription.XmlText>
                <cfset resultdata.statuscode = xmlresult.Envelope.Body.CheckESeVoucherStateResponse.CheckESeVoucherStateResult.StatusCode.XmlText>
            <cfelse>
                <cfset resultdata.uuid = xmlresult.Envelope.Body.CheckESeVoucherStateResponse.CheckESeVoucherStateResult.UUID.XmlText>
                <cfset resultdata.despatchid = xmlresult.Envelope.Body.CheckESeVoucherStateResponse.CheckESeVoucherStateResult.SeVoucherId.XmlText>
                <cfset resultdata.statusdescription = xmlresult.Envelope.Body.CheckESeVoucherStateResponse.CheckESeVoucherStateResult.StatusDescription.XmlText>
                <cfset resultdata.statuscode = xmlresult.Envelope.Body.CheckESeVoucherStateResponse.CheckESeVoucherStateResult.StatusCode.XmlText>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="GetSeVoucher" access="public" hint="Sistemde ki makbuzu indirir">
        <cfargument name="direction">
        <cfargument name="value">
        <cfargument name="valuetype" default="UUID">
        <cfargument name="filetype" default="UBL">

        <cfset ticket = GetFormsAuthentication()>

        <cfxml variable="receipt_data">
            <cfoutput>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
                <soapenv:Header/>
                <soapenv:Body>
                    <tem:GetSeVoucher>
                        <tem:Ticket>#ticket#</tem:Ticket>
                        <tem:Value>#arguments.value#</tem:Value>
                        <tem:ValueType>#arguments.valuetype#</tem:ValueType>
                        <tem:FileType>#arguments.filetype#</tem:FileType>
                    </tem:GetSeVoucher>
                </soapenv:Body>
                </soapenv:Envelope>
            </cfoutput>
        </cfxml>

        <cftry>
            <cfset httpresult = SendHttp("IntegrationService.asmx", "http://tempuri.org/GetSeVoucher", receipt_data)>
            <cfxml variable="xmlresult"><cfoutput>#httpresult.Filecontent#</cfoutput></cfxml>
            <CFDUMP VAR="#xmlresult#">
            <cfset resultdata = structNew()>
            <cfset resultdata.receipts = arrayNew(1)>
            <cfset resultdata.serviceresult = xmlresult.Envelope.Body.GetSeVoucherResponse.GetSeVoucherResult.ServiceResult.XmlText>
            <cfif resultdata.serviceresult eq "Error">
                <cfset resultdata.errorcode = xmlresult.Envelope.Body.GetSeVoucherResponse.GetSeVoucherResult.ErrorCode.XmlText>
                <cfset resultdata.serviceresultdescription = xmlresult.Envelope.Body.GetSeVoucherResponse.GetSeVoucherResult.ServiceResultDescription.XmlText>
            <cfelse>
                <cfloop array="#xmlresult.Envelope.Body.GetSeVoucherResponse.GetSeVoucherResult#" index="child">
                    
                    <cfset receipt = structNew()>
                    <cfset receipt.serviceresult = child.ServiceResult.XmlText>
                    <cfset receipt.serviceresultdescription = child.ServiceResultDescription.XmlText>
                    <cfif receipt.serviceresult eq "Error">
                        <cfset receipt.errorcode = child.ErrorCode.XmlText>
                    <cfelse>
                        <cfset receipt.uuid = child.UUID.XmlText>
                        <cfset receipt.receiptid = child.SeVoucherId.XmlText>
                        <cfset receipt.returnvalue = child.ReturnValue.XmlText>
                        <cfset receipt.statuscode = child.StatusCode.XmlText>
                        <cfset receipt.sendertaxid = child.Sendertaxid.XmlText>
                        <cfset receipt.receivertaxid = child.Receivertaxid.XmlText>
                        <cfset receipt.profileid = child.Profileid.XmlText>
                        <cfset receipt.issuedate = child.Issuedate.XmlText>
                        <cfset receipt.issuetime = child.Issuetime.XmlText>
                        <cfset receipt.createdate = child.Createdate.XmlText>
                    </cfif>
                    <cfset arrayAppend( resultdata.receipts, receipt )>
                </cfloop>
            </cfif>
            <cfreturn resultdata>

            <cfcatch>
                <cfrethrow>
            </cfcatch>
        </cftry>

    </cffunction>

</cfcomponent>