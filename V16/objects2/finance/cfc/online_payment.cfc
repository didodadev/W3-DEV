<cfcomponent extends="V16/objects2/finance/cfc/online_payment_basket_operation">

    <cfset functions = createObject("component","WMO.functions") />
    <cfset upload_folder = application.systemParam.systemParam().upload_folder />
    <cfset fileUploadFolder = "#upload_folder#/member/" />
    <cfset BasketAct = createObject("component", "V16.objects2.sale.cfc.basketAction")>
    <cfset partner_id = consumer_id = cookie_name = private_code = "" />
    <cfif isdefined("session.ww.userid")>
        <cfset session_base = session.ww />
        <cfset consumer_id = session.ww.userid>
        <cfset private_code = hash(consumer_id, "SHA-256", "UTF-8") />
    <cfelseif isdefined("session.pp.userid")>
        <cfset session_base = session.pp />
        <cfset partner_id = session.pp.userid>
        <cfset private_code = hash(partner_id, "SHA-256", "UTF-8") />
    <cfelse>
        <cfset session_base = session.qq />
        <cfset cookie_name = "#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#" />
        <cfset private_code = cookie_name />
    </cfif>

    <cffunction name = "get_widget_property" returntype="struct" access="public">
        <cfargument name="widget_id" type="integer">

        <cfset siteMethods = createObject("component","catalyst/AddOns/Yazilimsa/Protein/cfc/siteMethods") />
        <cfset getWidget = deserializeJSON(siteMethods.get_widget(id: arguments.widget_id)) />
        <cfset xml_settings = deserializeJSON(getWidget.DATA[1].WIDGET_DATA) >

        <cfreturn xml_settings />
    </cffunction>

    <cffunction name = "get_payment_installment" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="widget_id" type="integer">
        <cfargument name="creditCardNo" type="string">
        <cfargument name="amountTotal" type="any" required="false">

        <cfset response = structNew() />
        <cfset totalPrice = 0.0 />

        <cfset xml_settings = this.get_widget_property( arguments.widget_id ) />
        <cfif xml_settings.is_amount eq 1>
            <cfset totalPrice = functions.filterNum(arguments.amountTotal,2)>
        <cfelse>
            <cfset getBasketTotal = this.get_total_pre_order_products( consumer_id: consumer_id, partner_id: partner_id, cookie_name: cookie_name ) />
            <cfoutput query = "getBasketTotal">
                <cfset totalPrice += getBasketTotal.TOTAL_PRICE_KDV_TL />
            </cfoutput>
        </cfif>
        <cfif totalPrice gt 0>

            <cfhttp url="https://pay.workcube.com/wex.cfm/nkolay/PaymentInstallments" result="responseWex" charset="utf-8">
                <cfhttpparam name="sx" type="formfield" value="#xml_settings.sx_code#">
                <cfhttpparam name="amount" type="formfield" value="#functions.filterNum(functions.TLFormat(totalPrice))#">
                <cfhttpparam name="cardNumber" type="formfield" value="#arguments.creditCardNo#">
                <cfhttpparam name="hosturl" type="formfield" value="#cgi.server_name#">
                <cfhttpparam name="iscardvalid" type="formfield" value="true">
                <cfhttpparam name="platform" type="formfield" value="#xml_settings.api_platform#">
            </cfhttp>
            

            <cfif responseWex.Statuscode eq '200 OK'>
                <cfset response = { status: true, data: deserializeJson( responseWex.filecontent ) } />
            <cfelse>
                <cfset response = { status: false, message: 'Taksit seçenekleri alınırken bir hata oluştu!' } />
            </cfif>

        <cfelse>
            <cfset response = { status: false, message: "Tutar 0'dan büyük olmalıdır!" } />
        </cfif>

        <cfreturn replace( serializeJson( response ), "//", "" ) />
    </cffunction>

    <cffunction name = "get_payment_installment_encoded_val" access="public" returntype="struct">
        <cfargument name="widget_id" type="integer">
        <cfargument name="installmentNo" type="integer">
        <cfargument name="creditCardNo" type="any">
        <cfargument name="amountTotal" type="any" required="false">
 
        <cfset response = structNew() />
        <cfset ArgInstallmentNo = arguments.installmentNo />

        <cfset payment_installment = deserializeJson(this.get_payment_installment( widget_id: arguments.widget_id, creditCardNo: arguments.creditCardNo, amountTotal: arguments.amountTotal?:'' )) />
        <cfif payment_installment.status and payment_installment.data.success>
            <cfscript>paymentBankInfo = arrayFilter(payment_installment.data.content.payment_bank_list, function( elm ){ return elm.installment eq ArgInstallmentNo; })[1];</cfscript>
            <cfset response = { status: true, data: paymentBankInfo } />
        <cfelse>
            <cfset response = { status: false } />
        </cfif>
        
        <cfreturn response />
    </cffunction>

    <cffunction name = "payment" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="widget_id" type="integer">
        <cfargument name="installmentNo" type="integer">
        <cfargument name="cardHolderName" type="string">
        <cfargument name="cardExpDate" type="string">
        <cfargument name="cardCvc" type="string">
        <cfargument name="cardNumber" type="string">
        <cfargument name="amountTotal" type="any" required="false">

        <cfset response = structNew() />
        <cfset storage = deserializeJSON(session.storage) />
        <cfset totalPrice = 0.0 />

        <cfset xml_settings = this.get_widget_property( arguments.widget_id ) />
        
        <cfset paymentBankInfo = this.get_payment_installment_encoded_val(widget_id: arguments.widget_id, installmentNo: arguments.installmentNo, creditCardNo: replace(arguments.cardNumber,' ', '','all'), amountTotal: arguments.amountTotal?:'') />
        <cfif paymentBankInfo.status>

            <cfset structAppend(storage, {widget_id: arguments.widget_id}) />
            <cfhttp url="https://pay.workcube.com/wex.cfm/nkolay/Payment" result="responseWex" charset="utf-8">
                <cfhttpparam name="sx" type="formfield" value="#xml_settings.sx_code#">
                <cfhttpparam name="merchantSecretKey" type="formfield" value="#xml_settings.merchantSecretKey#">
                <cfhttpparam name="clientRefCode" type="formfield" value="159951">
                <cfhttpparam name="successUrl" type="formfield" value="#xml_settings.success_url#?pc=#private_code#&payType=1">
                <cfhttpparam name="failUrl" type="formfield" value="#xml_settings.fail_url#?pc=#private_code#&payType=1">
                <cfhttpparam name="amount" type="formfield" value="#functions.filterNum(functions.TLFormat(paymentBankInfo.Data.AUTHORIZATION_AMOUNT))#">
                <cfhttpparam name="installmentNo" type="formfield" value="#arguments.installmentNo#">
                <cfhttpparam name="cardHolderName" type="formfield" value="#arguments.cardHolderName#">
                <cfhttpparam name="month" type="formfield" value="#listFirst(replace(arguments.cardExpDate,' ', '','all'),'/')#">
                <cfhttpparam name="year" type="formfield" value="20#listLast(replace(arguments.cardExpDate,' ', '','all'),'/')#">
                <cfhttpparam name="cvv" type="formfield" value="#arguments.cardCvc#">
                <cfhttpparam name="cardNumber" type="formfield" value="#replace(arguments.cardNumber,' ', '','all')#">
                <cfhttpparam name="EncodedValue" type="formfield" value="#paymentBankInfo.Data.EncodedValue#">
                <cfhttpparam name="use3D" type="formfield" value="true">
                <cfhttpparam name="hosturl" type="formfield" value="#cgi.server_name#">
                <cfhttpparam name="rnd" type="formfield" value="#dateTimeFormat(now(),'dd.mm.yyyy H:nn:ss')#">
                <cfhttpparam name="currency_code" type="formfield" value="TRY">
                <cfhttpparam name="platform" type="formfield" value="#xml_settings.api_platform#">
            </cfhttp>

            <!--- <cfoutput>
                #responseWex.filecontent#
            </cfoutput>
            <cfabort> --->

            <cfif responseWex.Statuscode eq '200 OK'>
                <cfif not directoryExists("#upload_folder#session_storage")><cfdirectory action="create" directory="#upload_folder#session_storage" mode="777"></cfif>
                <cfset session.storage = replace( serializeJSON(storage), '//', '' ) />
                <cffile action="write" file="#upload_folder#session_storage/#private_code#.json" output="#replace( serializeJSON(session), '//', '')#" charset="utf-8" /><!--- Ödeme işlemi sonrası session değerleri kaybolduğundan json dosyasına yazılıyor --->
                <cfset response = { status: true, data: deserializeJson( responseWex.filecontent ) } />
            <cfelse>
                <cfset response = { status: false, message: 'Ödeme işlemi sırasında bir hata oluştu! Lütfen daha sonra tekrar deneyiniz!' } />
            </cfif>

        <cfelse>
            <cfset response = { status: false, message: 'Taksit seçenekleri alınırken bir hata oluştu!' } />
        </cfif>

        <cfreturn replace( serializeJson( response ), "//", "" ) />
    </cffunction>

    <cffunction name = "completePayment" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="widget_id" type="integer">
        <cfargument name="referenceCode" type="string">

        <cfset xml_settings = this.get_widget_property( arguments.widget_id ) />

        <cfhttp url="https://pay.workcube.com/wex.cfm/nkolay/CompletePayment" result="responseWex" charset="utf-8">
            <cfhttpparam name="sx" type="formfield" value="#xml_settings.sx_code#">
            <cfhttpparam name="referenceCode" type="formfield" value="#arguments.referenceCode#">
            <cfhttpparam name="platform" type="formfield" value="#xml_settings.api_platform#">
        </cfhttp>

        <cfif responseWex.Statuscode eq '200 OK'>
            <cfset response = { status: true, data: deserializeJson( responseWex.filecontent ) } />
        <cfelse>
            <cfset response = { status: false, message: 'Ödeme işlemi tamamlanamadı! Lütfen daha sonra tekrar deneyiniz!' } />
        </cfif>
        
        <cfreturn replace( serializeJson( response ), "//", "" ) />
    </cffunction>

    <cffunction name = "cancelRefundPayment" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="widget_id" type="integer">
        <cfargument name="referenceCode" type="string">
        <cfargument name="amount" type="string">
        <cfargument name="type" type="string">

        <cfset response = structNew() />
        <cfset storage = deserializeJSON(session.storage) />
        <cfset totalPrice = 0.0 />

        <cfset xml_settings = this.get_widget_property( arguments.widget_id ) />

        <cfhttp url="https://pay.workcube.com/wex.cfm/nkolay/CancelRefundPayment" result="responseWex" charset="utf-8">
            <cfhttpparam name="sx" type="formfield" value="#xml_settings.sx_code#">
            <cfhttpparam name="referenceCode" type="formfield" value="#arguments.referenceCode#">
            <cfhttpparam name="type" type="formfield" value="#arguments.type#">
            <cfhttpparam name="amount" type="formfield" value="#arguments.amount#">
            <cfhttpparam name="platform" type="formfield" value="#xml_settings.api_platform#">
        </cfhttp>

        <cfif responseWex.Statuscode eq '200 OK'>
            <cfset response = { status: true, data: deserializeJson( responseWex.filecontent ) } />
        <cfelse>
            <cfset response = { status: false, message: 'İptal işlemi gerçekleştirilemedi! Müşteri hizmetleriyle iletişime geçiniz!' } />
        </cfif>
        
        <cfreturn replace( serializeJson( response ), "//", "" ) />
    </cffunction>

    <cffunction name="payment_eft" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="ibanNumber" type="string">
        <cfargument name="remittanceDate" type="string">

        <cfset response = structNew() />
        <cfset storage = deserializeJSON(session.storage) />

        <cftry>
            <cffile action = "upload" filefield = "receiptDocument" destination = "#fileUploadFolder#" nameconflict = "Overwrite" mode="777">

            <cfset assetInfo = structNew() />
            <cfset assetInfo.fileName = createUUID() />
            <cfset assetInfo.fileExtension = ucase(cffile.serverfileext) />
            <cfset assetInfo.asset_file_name = "#assetInfo.fileName#.#assetInfo.fileExtension#" />
            <cfset assetInfo.asset_file_size = cffile.filesize/>
            <cfset assetInfo.asset_file_real_name = cffile.serverfile />

            <cfif assetInfo.asset_file_size gt 0>
                <!--- Dosyayı yeniden adlandırır. --->
                <cffile action="rename" source="#fileUploadFolder##file.serverfile#" destination="#fileUploadFolder##assetInfo.fileName#.#assetInfo.fileExtension#">

                <cfquery name="GET_MAIN_PAPER" datasource="#DSN#">
                    SELECT * FROM GENERAL_PAPERS_MAIN WHERE EMPLOYEE_NUMBER IS NOT NULL
                </cfquery>
                <cfset paper_code = evaluate('get_main_paper.ASSET_no')>
                <cfset paper_number = evaluate('get_main_paper.ASSET_number') +1>
                <cfset system_paper_no2=paper_code & '-' & paper_number>
                <cfset moduleName="member">
                <cfset moduleId=4>
                <cfset actionSection="COMPANY_ID">

                <cfquery name="ADD_ASSET" datasource="#DSN#" result="GET_MAX_ASSET">
                    INSERT INTO 
                    ASSET
                    (
                        ASSETCAT_ID,
                        IS_ACTIVE,	
                        IS_SPECIAL,
                        IS_INTERNET,
                        ASSET_NO,
                        MODULE_NAME,
                        MODULE_ID,
                        ACTION_SECTION,
                        ACTION_ID,
                        COMPANY_ID,
                        ASSET_NAME,
                        ASSET_FILE_NAME,
                        ASSET_FILE_REAL_NAME,
                        SERVER_NAME,
                        ASSET_FILE_SIZE,
                        ASSET_FILE_SERVER_ID,
                        PROPERTY_ID,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP
                    )
                    VALUES
                    (
                        -9,
                        1,	
                        0,
                        1,
                        '#system_paper_no2#',
                        '#moduleName#',
                        #moduleId#,
                        '#actionSection#',
                        #storage.company_id#,
                        #session_base.our_company_id#,
                        'Havale - Eft: #arguments.ibanNumber#',
                        '#assetInfo.asset_file_name#',
                        '#assetInfo.asset_file_real_name#',
                        '#cgi.http_host#',
                        #assetInfo.asset_file_size#,
                        1,
                        9,
                        0,
                        <cfqueryparam cfsqltype = "cf_sql_date" value = "#arguments.remittanceDate#">,
                        '#cgi.remote_addr#'
                    )
                </cfquery>
            
                <cfset system_paper_no_add2=paper_number>
                <cfif len(system_paper_no_add2)>
                    <cfquery name="UPD_GEN_PAP" datasource="#DSN#">
                        UPDATE 
                            GENERAL_PAPERS_MAIN
                        SET
                            ASSET_NUMBER = #system_paper_no_add2#
                        WHERE
                            ASSET_NUMBER IS NOT NULL
                    </cfquery>
                </cfif>
                <!--- Sipariş için havale-eft ise --->
                <cfif storage.is_amount neq 1> 
                <!--- EFT doğrulanana kadar geçici tabloya kayıt atılıyor --->
                <cfset add_order_pre = BasketAct.add_pre_order_func(ibanNumber: arguments.ibanNumber, asset_id: GET_MAX_ASSET.IDENTITYCOL )>
                </cfif>

                <cfset response = { status: true } />
            <cfelse>
                <cfset response = { status: false, message: 'Dosya içeriğinizin dolu olduğundan emin olunuz!' } />
            </cfif>
        <cfcatch type="any">
            <cfset response = { status: false, message: 'Havale - Eft belgeniz yüklenirken bir sorun oluşturuldu!' } />
        </cfcatch>
        </cftry>
        
        <cfreturn replace( serializeJson( response ), "//", "" ) />
    </cffunction>

</cfcomponent>