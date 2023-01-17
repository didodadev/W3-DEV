<!---
    Author :        İlker Altındal
    Date :          15.02.2021
    Description :   Gönderilen EMustahsil Makbuzunun PDF formatında indirilmesi   
--->
<cfset soap = createObject("Component","V16.e_government.cfc.emustahsil.soap")>
<cfset common_voucher = createObject("Component","V16.e_government.cfc.emeslekmakbuzu.soap")>
<cfset soap.init()>
<cfset common_voucher.init()>

<cfset common = createObject("Component","V16.e_government.cfc.emustahsil.common")>
<cfset getCompInfo = common.get_our_company_fnc(company_id:session.ep.company_id)>

    <cfset getAuthorization = soap.GetFormsAuthentication()> <!--- izinler kontrol ediliyor --->
    <cfif not len(getAuthorization)>
            Servis Doğrulama Sırasında Bir Sorun Oluştu!
        <cfabort>
    </cfif>
        
    <!--- Gönderilen Makbuz PDF formatında çağrılıyor --->
    <cfif attributes.action_type eq 'MM'>
        <cfset GetReceipt = soap.GetReceipt( 
                                            value : "#attributes.uuid#",
                                            valuetype : "UUID",
                                            filetype : "PDF" 
                                        )>
    <cfelse>
        <cfset GetReceipt = common_voucher.GetSeVoucher( 
                                            value : "#attributes.uuid#",
                                            valuetype : "UUID",
                                            filetype : "PDF" 
                                        )>
    </cfif>

    <cfif StructKeyExists(GetReceipt, "RECEIPTS") and ArrayLen( GetReceipt.RECEIPTS )>
        <cfset getData = tobinary(GetReceipt["RECEIPTS"][1]["RETURNVALUE"])>
        <cfheader name="Content-Disposition" value="attachment; filename=#attributes.integration_id#.pdf" charset="utf-8" />
        <cfcontent type="application/pdf; charset=utf-8" reset="true" variable="#getData#" />
    <cfelse>
        <cfset error_code = '#GetReceipt.SERVICERESULTDESCRIPTION#'>
    </cfif>
   

<cfif isdefined("error_code")> 
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='62189.E-Makbuz Görsel'></cfsavecontent>
    <cf_box title="#title#">
        <table width="%100" height="10">
            <tr>
                <td style="color:#F00;font-weight:700"><cfoutput><span><cf_get_lang dictionary_id='40568.Hata Kodu'> : #error_code#!</span></cfoutput></td>
            </tr>
        </table>
    </cf_box>
</cfif>