<cfset save_folder      = "#upload_folder#e_government#dir_seperator#xslt#dir_seperator#" />
<cfset old_save_folder  = "#index_folder#objects#dir_seperator#xslt#dir_seperator#" />

<cfif len(getCompInfo.template_filename_base64)><!--- ozel sablon dosyasi--->
    <cfif fileExists('#save_folder##getCompInfo.template_filename_base64#')>
        <cfset preview_producer_template     = 'documents/e_government/xslt/#getCompInfo.template_filename#' />
        <cfset temp_eproducer_template_base64= FileRead("#save_folder##getCompInfo.template_filename_base64#","utf-8") />
    <cfelse>
        <cfthrow type="Application" errorcode="FileNotFound" message="Şablon Dosyası Bulunamadı" detail="Özel Şablon Dosyası Bulunamadı" />
    </cfif>
<cfelse>
    <cfset preview_producer_template = 'V16/objects/xslt/evoucher_template.xslt' />
    <cfset temp_eproducer_template_base64= FileRead("#old_save_folder#evoucher_template_base64.xslt","utf-8")>
</cfif>
<!--- xml giydirme işlemi --->
<cfsavecontent variable="evoucher_data">
<?xml version="1.0" encoding="UTF-8"?>
<cfoutput>
    <eArsivVeri <cfif attributes.fuseaction neq 'invoice.popup_preview_producer'> xmlns="http://earsiv.efatura.gov.tr" </cfif> xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://earsiv.efatura.gov.tr eArsivVeri.xsd">
        <baslik>
            <mukellef>
                <!--- <cfif not get_producer.is_person><tckn>#get_producer.taxno#</tckn><cfelse><tckn>#get_producer.tc_identity#</tckn></cfif> --->
                <tckn>#get_producer.TC_IDENTITY#</tckn>
            </mukellef>
            <hazirlayan>
                <vkn>#getCompInfo.tax_no#</vkn>
            </hazirlayan>
        </baslik>
        <serbestMeslekMakbuz>
            <makbuzNo>#producer_receipt_number#</makbuzNo>
            <ETTN>#GUIDStr#</ETTN>
            <gonderimSekli>ELEKTRONIK</gonderimSekli>
            <dosyaAdi></dosyaAdi>
            <belgeTarihi>#dateformat(now(),'yyyy-mm-dd')#</belgeTarihi>
            <belgeZamani>#timeformat(dateadd('h',session.ep.time_zone-2,now()),'HH:MM:SS')#</belgeZamani>
            <toplamTutar>#NumberFormat(get_producer_row.price - temp_tax_amount + row_tax_amount_ - tevkifat_amount,"_.00000")#</toplamTutar>
            <odenecekTutar>#NumberFormat(get_producer_row.price - temp_tax_amount + row_tax_amount_ - tevkifat_amount,"_.00000")#</odenecekTutar>
            <paraBirimi>#get_producer.currency_code#</paraBirimi>
            <cfloop query="get_producer_row">
                <vergiBilgisi>
                    <vergilerToplami>#NumberFormat(temp_tax_amount + row_tax_amount_ - tevkifat_amount,"_.00")#</vergilerToplami>
                    <cfloop query="get_producer_kdv">
                        <vergi>
                            <cfif get_producer_kdv.tax_code eq '0003' or get_producer_kdv.tax_code eq '0015' >
                                <matrah>#NumberFormat(get_producer_row.price,"_.0000")#</matrah>
                            <cfelse>
                                <matrah>#NumberFormat(row_tax_amount_,"_.0000")#</matrah>
                            </cfif>
                            <vergiKodu>#get_producer_kdv.tax_code#</vergiKodu>
                            <vergiTutari>#NumberFormat(get_producer_kdv.tax_amount,"_.00")#</vergiTutari>
                        </vergi>
                    </cfloop>
                </vergiBilgisi>
            </cfloop>
            <aliciBilgileri>
                <gercekKisi>
                    <!--- <cfif not get_producer.is_person><tckn>#get_producer.taxno#</tckn><cfelse><tckn>#get_producer.tc_identity#</tckn></cfif> --->
                    <tckn>#get_producer.TC_IDENTITY#</tckn>
                    <adiSoyadi>#HTMLEditFormat(get_producer.fullname)#</adiSoyadi>
                    <!--- <adiSoyadi>#HTMLEditFormat(get_producer.deliver_emp_name)# #HTMLEditFormat(get_producer.deliver_emp_surname)#</adiSoyadi> --->
                </gercekKisi>
                <adres>
                    <caddeSokak>#HTMLEditFormat(get_producer.address)#</caddeSokak>
                    <binaAd></binaAd>
                    <kapiNo></kapiNo>
                    <semt>#get_producer.county_name#</semt>
                    <sehir>#get_producer.city_name#</sehir>
                    <postaKod>#get_producer.company_postcode#</postaKod>
                    <ulke>TR</ulke>
                </adres>
            </aliciBilgileri>
            <gondericiBilgileri>
                <tuzelKisi>
                    <vkn>#getCompInfo.tax_no#</vkn>
                    <unvan>#HTMLEditFormat(trim(getCompAddress.COMPANY_NAME))#</unvan>
                </tuzelKisi>
                <adres>
                    <caddeSokak>#HTMLEditFormat(getCompAddress.DISTRICT_NAME)# #HTMLEditFormat(getCompAddress.STREET_NAME)#</caddeSokak>
                    <kapiNo>#getCompAddress.BUILDING_NUMBER#</kapiNo>
                    <semt>#getCompAddress.COUNTY_NAME#</semt>
                    <sehir>#getCompAddress.CITY_NAME#</sehir>
                    <postaKod>#getCompAddress.POSTAL_CODE#</postaKod>
                    <ulke>TR</ulke>
                    <vDaire>#getCompAddress.tax_office#</vDaire>
                </adres>
            </gondericiBilgileri>
            <malHizmetBilgisi>
                <cfloop query="get_producer_row">
                    <malHizmet>
                        <ad>#HTMLEditFormat(get_producer_row.name_product)#</ad>
                        <vergiBilgisi>
                            <vergilerToplami>#NumberFormat(temp_tax_amount + row_tax_amount_ - tevkifat_amount,"_.00")#</vergilerToplami>
                            <cfloop query="get_producer_kdv">
                                <vergi>
                                    <cfif get_producer_kdv.tax_code eq '0003' or get_producer_kdv.tax_code eq '0015' >
                                        <matrah>#NumberFormat(get_producer_row.price,"_.0000")#</matrah>
                                    <cfelse>
                                        <matrah>#NumberFormat(row_tax_amount_,"_.0000")#</matrah>
                                    </cfif>
                                    <vergiKodu>#get_producer_kdv.tax_code#</vergiKodu>
                                    <vergiTutari>#get_producer_kdv.tax_amount#</vergiTutari>
                                    <vergiorani>#get_producer_kdv.tax#</vergiorani>
                                </vergi>
                            </cfloop>
                        </vergiBilgisi>
                        <burutUcret>#NumberFormat(get_producer_row.price,"_.00000")#</burutUcret>
                    </malHizmet>
                </cfloop>
            </malHizmetBilgisi>
        </serbestMeslekMakbuz>
    </eArsivVeri>
</cfoutput>
</cfsavecontent>

<cffile action="write" file="#directory_name##dir_seperator##producer_receipt_number#.xml" output="#trim(evoucher_data)#" charset="utf-8" />

<cfif attributes.fuseaction neq 'invoice.popup_preview_producer'>

    <cfset getAuthorization = soap.GetFormsAuthentication()> <!--- izinler kontrol ediliyor --->
	
    <cfif not len(getAuthorization)>
            Servis Doğrulama Sırasında Bir Sorun Oluştu!
        <cfabort>
    </cfif>
    <cfset sendVoucher = soap.SendVoucherData(evoucher_data)>


    <cfset service_result_description = ( isdefined("sendVoucher.ServiceResultDescription") ) ? sendVoucher.ServiceResultDescription : ''>
     <cfset status_description = ( isdefined("sendVoucher.ServiceStatusDescription") ) ? sendVoucher.ServiceStatusDescription : ''>
     <cfset error_code = ( isdefined("sendVoucher.errorcode") ) ? sendVoucher.errorcode : ''>
     <cfset uuid =  ( isdefined("sendVoucher.uuid") ) ? sendVoucher.uuid : ''>
     <cfset statusCode = ( isdefined("sendVoucher.statuscode") ) ? sendVoucher.statuscode : ''>
     <cfif structKeyExists( sendVoucher, "RECEIPTS" ) and ArrayLen( sendVoucher.receipts )>
         <cfset statusCode = sendVoucher["RECEIPTS"][1]["STATUSCODE"]>
         <cfset receipt_id = sendVoucher["RECEIPTS"][1]["RECEIPT_ID"]>
         <cfset uuid = sendVoucher["RECEIPTS"][1]["UUID"]>
         <cfset service_result_description = sendVoucher["RECEIPTS"][1]["SERVICERESULTDESCRIPTION"]>
         <cfset status_description = sendVoucher["RECEIPTS"][1]["SERVICESTATUSDESCRIPTION"]>
         <cfset error_code = sendVoucher["RECEIPTS"][1]["ERRORCODE"]>
     </cfif>

    <cfif listfind('1,19,60',statusCode)>
        <cfset statusCode = 1>
    </cfif>
    <cfset sending_detail = common.eReceiptSendingDetail(
                                                            service_result: sendVoucher.serviceresult,
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

