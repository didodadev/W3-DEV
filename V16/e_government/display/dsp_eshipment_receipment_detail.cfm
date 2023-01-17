<!---
    İlker Altındal 12102020
    İrsaliye Yanıtı PDF formatında çağrılıp indirilme işlemi yapılır.
--->

<cfset soap = createObject("Component","V16.e_government.cfc.eirsaliye.soap")>
<cfset soap.init()>

<cfset common = createObject("Component","V16.e_government.cfc.eirsaliye.common")>
<cfset getCompInfo = common.get_our_company_fnc(company_id:session.ep.company_id)>

    <cfset getAuthorization = soap.GetFormsAuthentication()> <!--- izinler kontrol ediliyor --->
    <cfif not len(getAuthorization)>
            Servis Doğrulama Sırasında Bir Sorun Oluştu!
        <cfabort>
    </cfif>
        
    <!--- e-irsaliye yanıtı PDF formatında çağrılıyor --->
    <cfset GetShipment = soap.GetReceiptAdvice( 
                                            direction : "Outgoing",
                                            value : "#attributes.integration_id#",
                                            valuetype : "RECEIPTADVICEID",
                                            filetype : "PDF" 
                                        )>
    <cfif StructKeyExists(GetShipment, "RECEIPMENTS") and ArrayLen( GetShipment.RECEIPMENTS )>

        <cfset getData = tobinary(GetShipment["RECEIPMENTS"][1]["RETURNVALUE"])>
        <cfheader name="Content-Disposition" value="attachment; filename=#attributes.integration_id#.pdf" charset="utf-8" />
        <cfcontent type="application/pdf; charset=utf-8" reset="true" variable="#getData#" />

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