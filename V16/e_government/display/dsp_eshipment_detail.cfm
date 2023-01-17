<!---
    İlker Altındal 03062020
    Gönderilen İrsaliye PDF formatında çağrılıp indirilme işlemi yapılır.
--->
<cfset common = createObject("Component","V16.e_government.cfc.eirsaliye.common")>
<cfset getCompInfo = common.get_our_company_fnc(company_id:session.ep.company_id)>

<cfif getCompInfo.eshipment_type_alias eq 'dp'>
    <cfset soap = createObject("Component","V16.e_government.cfc.eirsaliye.soap")>
    <cfset soap.init()>
    
    <cfset getAuthorization = soap.GetFormsAuthentication()> <!--- izinler kontrol ediliyor --->
    <cfif not len(getAuthorization)>
            Servis Doğrulama Sırasında Bir Sorun Oluştu!
        <cfabort>
    </cfif>
    <!--- Gönderilen İrsaliye PDF formatında çağrılıyor --->
    <cfset GetShipment = soap.GetDespatch( 
                                            direction : "Outgoing",
                                            value : "#attributes.uuid#",
                                            valuetype : "UUID",
                                            filetype : "PDF" 
                                        )>

    <cfif StructKeyExists(GetShipment, "DESPATCHES") and ArrayLen( GetShipment.DESPATCHES )>
        <cfset getData = tobinary(GetShipment["DESPATCHES"][1]["RETURNVALUE"])>
        <cfheader name="Content-Disposition" value="attachment; filename=#attributes.integration_id#.pdf" charset="utf-8" />
        <cfcontent type="application/pdf; charset=utf-8" reset="true" variable="#getData#" />
    <cfelseif GetShipment.ERRORCODE eq '34' and GetShipment.SERVICERESULT is 'Error' and GetShipment.SERVICERESULTDESCRIPTION eq 'İrsaliye Bulunamadı !'>
        <cfset user_domain = (( cgi.server_port eq 443 ) ? 'https://' : 'http://') & cgi.server_name >
        <cfhtmltopdf
            destination="#upload_folder##dir_seperator##attributes.integration_id#.pdf" overwrite="yes"
            source="#user_domain#/V16/e_government/cfc/super/eshipment/soap.cfc?method=get_pdf&uuid=#attributes.uuid#&dsn2_name=#dsn2#">
        </cfhtmltopdf>
        <cfheader name="Content-Disposition" value="attachment; filename=#attributes.integration_id#.pdf" charset="utf-8" />
        <cfcontent type="application/pdf; charset=utf-16" reset="true" file="#user_domain#/documents/#attributes.integration_id#.pdf" />
        <cffile action="delete" file="#replace("#upload_folder##attributes.integration_id#.pdf","\","/","all")#" mode="777">
    <cfelse>
        <cfset error_code = '#GetShipment.SERVICERESULTDESCRIPTION#'>
    </cfif>

    <cfif isdefined("error_code")> 
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='60920.E-İrsaliye Görsel'></cfsavecontent>
        <cf_box title="#title#">
            <table width="%100" height="10">
                <tr>
                    <td style="color:#F00;font-weight:700"><cfoutput><span><cf_get_lang dictionary_id='40568.Hata Kodu'> : #error_code#!</span></cfoutput></td>
                </tr>
            </table>
        </cf_box>
    </cfif>
<cfelseif getCompInfo.eshipment_type_alias eq 'spr'>
    <cfset soap = createObject("Component","V16.e_government.cfc.super.eshipment.soap")>
    <cfset soap.init()>
    <cfset GetInvoice = soap.GetDespatch(uuid: attributes.uuid)>

    <cfif GetInvoice.service_result eq 'Success'>
        <cfset getData = tobinary(GetInvoice.pdf_data)>
        <cfheader name="Content-Disposition" value="attachment; filename=#attributes.integration_id#.pdf" charset="utf-8" />
        <cfcontent type="application/pdf; charset=utf-8" reset="true" variable="#getData#" />
    <cfelseif GetInvoice.service_result eq 'DespatchAdviceNotExists'>

        <cfset user_domain = (( cgi.server_port eq 443 ) ? 'https://' : 'http://') & cgi.server_name >
        <cfhtmltopdf
            destination="#upload_folder##dir_seperator##attributes.integration_id#.pdf" overwrite="yes"
            source="#user_domain#/V16/e_government/cfc/super/eshipment/soap.cfc?method=get_pdf&uuid=#attributes.uuid#&integration_id=#attributes.integration_id#&dsn2_name=#dsn2#">
        </cfhtmltopdf>
        <cfheader name="Content-Disposition" value="attachment; filename=#attributes.integration_id#.pdf" charset="utf-8" />
        <cfcontent type="application/pdf; charset=utf-16" reset="true" file="#user_domain#/documents/#attributes.integration_id#.pdf" />

        <cffile action="delete" file="#replace("#upload_folder##arguments.integration_id#.pdf","\","/","all")#" mode="777">

    <cfelse>

        <cfset error_code = 'Problem oluştu, tekrar deneyin.'>
    </cfif>
<cfelseif getCompInfo.eshipment_type_alias eq 'dgn'>
    <cfset soap = createObject("Component","V16.e_government.cfc.dogan.eirsaliye.soap")>
    <cfset soap.init()>
    <cfset GetInvoice = soap.GetDespatch(value: attributes.uuid, filetype: 'PDF', direction: 'OUT')>

    <cfif GetInvoice.serviceresult eq 'Successful'>
        <cfset getData = tobinary(GetInvoice.DESPATCHES[1].RETURNVALUE)>
        <cfheader name="Content-Disposition" value="attachment; filename=#attributes.integration_id#.pdf" charset="utf-8" />
        <cfcontent type="application/pdf; charset=utf-8" reset="true" variable="#getData#" />
    <cfelse>
        <cfset error_code = 'Problem oluştu, tekrar deneyin.'>
    </cfif>
</cfif>