
<cfset soap = createObject("Component","V16.e_government.cfc.emeslekmakbuzu.soap")>
<cfset soap.init()>

<!--- fatura bilgileri ortak olduğu için müstahsil makbuzu altındaki componentten çekiyorum --->
<!--- Gönderilen makbuz ilişki tablolarını da ortak kullanıyorum, Action type üzerinden SMM ya da MM olduğunu yakalayabiliriz --->

<cfset common = createObject("Component","V16.e_government.cfc.emustahsil.common")>
<cfset getCompAddress = common.getCompanyAdrress(company_id:session.ep.company_id)>

<!--- Fatura dışındakibilgileri kendi klasörü altından çekiyorum--->
<cfset getVoucher = createObject("Component","V16.e_government.cfc.emeslekmakbuzu.common")>
<cfset getCompInfo = getVoucher.get_our_company_fnc(company_id:session.ep.company_id)>



<cfset uuidLibObj = createobject("java", "java.util.UUID")>
<cfset GUIDStr = uuidLibObj.randomUUID().toString()>

<cfset errorCode = ArrayNew(1)>

<cfset cancelControl = common.ProducerCancelControl(action_id : attributes.action_id)> <!--- Makbuz İptal Kontrolü --->
<cfif cancelControl.IS_IPTAL eq 1>
    <cfset ArrayAppend(errorCode, "İptal edilen Makbuz, E-Makbuz olarak gönderilemez") >
</cfif>

<cfset moneyControl = common.ProducerMoneyControl(action_id : attributes.action_id)> <!--- Makbuz Kur Kontrolü --->
<cfif moneyControl.recordcount>
    <cfset temp_currency_code = 1>
<cfelse>
    <cfset temp_currency_code = 0>
</cfif>

<cfif len(cancelControl.COMPANY_ID)>
    <cfset get_producer = common.getProducer(action_id : attributes.action_id, company_id : cancelControl.COMPANY_ID, temp_currency_code : temp_currency_code)>
<cfelseif len(cancelControl.CONSUMER_ID)>
    <cfset get_producer = common.getProducer(action_id : attributes.action_id, consumer_id : cancelControl.CONSUMER_ID, temp_currency_code : temp_currency_code)>
</cfif>

<cfif not len(get_producer.TC_IDENTITY)>
    <cfset arrayAppend(errorCode, "Yetkili kişinin kişinin TCKN tanımlamasını yapın")>
</cfif>

<cfset get_producer_kdv = common.getProducerKDV(action_id : attributes.action_id, temp_currency_code : temp_currency_code)>
<cfset get_producer_row = common.getProducerRow(action_id : attributes.action_id, temp_currency_code : temp_currency_code)>
<cfset get_producer_tax_row = common.getProducerTaxRow(action_id : attributes.action_id, temp_currency_code : temp_currency_code)>

<cfif ArrayLen(errorCode)>
    <div style="border-left:solid 1px;border-right:solid 1px;border-bottom:solid 1px;border-radius:5px;">
    	<h3 style="border-top-left-radius:5px;border-top-right-radius:5px;background-color:#BF0500;color:#FFF;padding:3px 15px;">e-Makbuz Gönderilirken <cfif ArrayLen(errorCode) eq 1>Hata<cfelseif ArrayLen(errorCode) gt 1>Hatalar</cfif> Oluştu!</h3>
        <ul>
        <cfloop array="#errorCode#" index="error_code">
            <cfoutput>
                <li style="list-style-image:url(/images/caution_small.gif);margin-top:5px;">#error_code#</li>
            </cfoutput>
        </cfloop>
        </ul> 
    </div>
    <cfabort>
<cfelse>
  
    <cfquery name="get_row_tax" dbtype="query">
        SELECT SUM(TAX_AMOUNT) TAX_AMOUNT FROM get_producer_kdv WHERE TYPE = 2
    </cfquery>
    <cfquery name="get_stopaj_kdv" dbtype="query">
    	SELECT SUM(TAX_AMOUNT) AS TAX_AMOUNT FROM get_producer_kdv WHERE TYPE = 5
    </cfquery>
     <cfquery name="get_tevkifat" dbtype="query">
    	SELECT SUM(TAX_AMOUNT) AS TAX_AMOUNT FROM get_producer_kdv WHERE TYPE = 3
    </cfquery>

    <cfset temp_tax_amount = row_tax_amount_ = tevkifat_amount = 0>
    <cfif isdefined('get_stopaj_kdv') and get_stopaj_kdv.recordcount>
        <cfset temp_tax_amount = get_stopaj_kdv.tax_amount>
    </cfif>
    <cfif isdefined('get_row_tax') and get_row_tax.recordcount>
        <cfset row_tax_amount_ = get_row_tax.tax_amount>
    </cfif>
    <cfif isdefined('get_tevkifat') and get_tevkifat.recordcount>
        <cfset tevkifat_amount = get_tevkifat.tax_amount>
    </cfif>

    <cfset LegalMonetaryTotal = structNew()>
    <cfset LegalMonetaryTotal.LineExtensionAmount = get_producer.grosstotal - row_tax_amount_>
    <cfset LegalMonetaryTotal.TaxExclusiveAmount = get_producer.grosstotal - row_tax_amount_ - ( get_producer.sa_discount + get_producer.row_discount )>
    <cfset LegalMonetaryTotal.TaxInclusiveAmount   = get_producer.nettotal + temp_tax_amount>
    <cfset LegalMonetaryTotal.PayableAmount = get_producer.nettotal>

    <cfset producer_receipt_number = "#session.ep.period_year##left('00000000',8-len(get_producer.invoice_id))##get_producer.invoice_id#">
    <cfset temp_eproducer_folder = 'evoucher_send'>
    <cfset temp_path = '#temp_eproducer_folder#/#session.ep.company_id#/#year(now())#/#numberformat(month(now()),00)#/#producer_receipt_number#.xml'>
    <cfset preview_receipt_xml  = 'documents/evoucher_send/#session.ep.company_id#/#year(now())#/#numberformat(month(now()),00)#/#producer_receipt_number#.xml'>
    <cfset directory_name = "#upload_folder##temp_eproducer_folder##dir_seperator##session.ep.company_id##dir_seperator##year(now())##dir_seperator##numberformat(month(now()),00)#">

    <cfif Not DirectoryExists("#directory_name#")>
        <cfdirectory action="create" directory="#directory_name#" />
    </cfif>

    <!--- DTP tarafına makbuzun gönderilmesi --->
    <cfinclude template="evoucher_digitalplanet.cfm" />

    <cfif attributes.fuseaction neq 'invoice.popup_preview_producer'> <!--- Makbuz gönderilmiş ise dönen no ile belge ve ilişkili tablo güncelleniyor --->
        <cfif isdefined("new_producer_receipt_number") and len(new_producer_receipt_number)>
            <cfset updPaper = common.updPaperNoSendReceipt( receipt_number : new_producer_receipt_number, action_id : get_producer.invoice_id  )>

            <!--- wex counter kaydı atılıyor --->
            <!--- <cftry>
                <cfset get_license = createObject("component","V16.settings.cfc.workcube_license").get_license_information()>
                <cfhttp url="http://wex.workcube.com/wex.cfm/e-government_paper/addCounter" charset="utf-8" result="result">
                    <cfhttpparam name="subscription_no" type="formfield" value="#get_license.WORKCUBE_ID#" />
                    <cfhttpparam name="domain" type="formfield" value="#cgi.http_host#" />
                    <cfhttpparam name="domain_ip" type="formfield" value="#cgi.local_addr#" />
                    <cfhttpparam name="product_id" type="formfield" value="8782" />
                    <cfhttpparam name="amount" type="formfield" value="1" />
                    <cfhttpparam name="process_type" type="formfield" value="#get_producer.PROCESS_CAT#" />
                    <cfhttpparam name="process_doc_no" type="formfield" value="#new_producer_receipt_number#" />
                    <cfhttpparam name="process_date" type="formfield" value="#dateFormat(get_producer.INVOICE_DATE,dateformat_style)#" />
                    <cfhttpparam name="wex_type" type="formfield" value="E-Makbuz" />
                    <cfhttpparam name="wex_integrator" type="formfield" value="dp" />
                    <cfhttpparam name="counter_outgoing" type="formfield" value="1" />
                </cfhttp>
                <cfset responseService = result.FileContent>
                <cfset responseWex = deserializeJson(responseService) />
                <cfif responseWex.status neq 1>
                    <script type = "text/javascript">
                        alert('İşlem başarılı, ancak wex kaydı yapılamadı! Lütfen sistem yöneticinize bilgi veriniz!');
                    </script>
                </cfif>
                <cfcatch>
                    <cfdump var="#cfcatch#">
                </cfcatch>
            </cftry> --->
            <!--- //wex counter kaydı atılıyor --->
        </cfif>
    </cfif>

</cfif>

<cfif attributes.fuseaction neq 'invoice.popup_preview_producer'>
    <script type="text/javascript">
        window.opener.location.reload();
        window.location.href="<cfoutput>#request.self#?fuseaction=invoice.popup_send_detail_ereceipt&action_id=#attributes.action_id#&action_type=#attributes.action_type#</cfoutput>";
    </script>
</cfif>