

<cfinclude template="create_ubltr_eproducer_receipt.cfm" />

<!--- XML dosya dolduruluyor --->
<cffile action="write" file="#directory_name##dir_seperator##producer_receipt_number#.xml" output="#trim(eproducer_data)#" charset="utf-8" />

<cfif attributes.fuseaction neq 'invoice.popup_preview_producer'>

    <cfset getAuthorization = soap.GetFormsAuthentication()> <!--- izinler kontrol ediliyor --->
	
    <cfif not len(getAuthorization)>
            Servis Doğrulama Sırasında Bir Sorun Oluştu!
        <cfabort>
    </cfif>

    <cfset sendReceipt = soap.SendRecieptData(eproducer_data)> <!--- Makbuz gönderme işlemi yapılıyor --->

     <cfset service_result_description = ( isdefined("sendReceipt.ServiceResultDescription") ) ? sendReceipt.ServiceResultDescription : ''>
     <cfset status_description = ( isdefined("sendReceipt.ServiceStatusDescription") ) ? sendReceipt.ServiceStatusDescription : ''>
     <cfset error_code = ( isdefined("sendReceipt.errorcode") ) ? sendReceipt.errorcode : ''>
     <cfset uuid =  ( isdefined("sendReceipt.uuid") ) ? sendReceipt.uuid : ''>
     <cfset statusCode = ( isdefined("sendReceipt.statuscode") ) ? sendReceipt.statuscode : ''>
     <cfif structKeyExists( sendReceipt, "RECEIPTS" ) and ArrayLen( sendReceipt.receipts )>
         <cfset statusCode = sendReceipt["RECEIPTS"][1]["STATUSCODE"]>
         <cfset receipt_id = sendReceipt["RECEIPTS"][1]["RECEIPT_ID"]>
         <cfset uuid = sendReceipt["RECEIPTS"][1]["UUID"]>
         <cfset service_result_description = sendReceipt["RECEIPTS"][1]["SERVICERESULTDESCRIPTION"]>
         <cfset status_description = sendReceipt["RECEIPTS"][1]["SERVICESTATUSDESCRIPTION"]>
         <cfset error_code = sendReceipt["RECEIPTS"][1]["ERRORCODE"]>
     </cfif>

    <cfif listfind('1,60',statusCode)>
        <cfset statusCode = 1>
    </cfif>
    <cfset sending_detail = common.eReceiptSendingDetail(
                                                            service_result: sendReceipt.serviceresult,
                                                            uuid: uuid,
                                                            ereceipt_id: producer_receipt_number,
                                                            status_description: status_description,
                                                            service_result_description: service_result_description,
                                                            status_code: statusCode,
                                                            error_code:error_code,
                                                            action_id: attributes.action_id,
                                                            action_type: attributes.action_type
                                                        )>
        
    <cfif statusCode eq 1>
        <cfset shiment_relation = common.eReceiptRelation(
                                                            uuid: uuid,
                                                            integration_id:receipt_id,
                                                            ereceipt_id:producer_receipt_number,
                                                            profile_id: 'EARSIVBELGE',
                                                            action_id: attributes.action_id,
                                                            action_type: attributes.action_type,
                                                            path: temp_path
                                                        )>
        <cfset new_producer_receipt_number = receipt_id>
    </cfif>

</cfif>
