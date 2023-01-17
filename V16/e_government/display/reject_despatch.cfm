

<cfset eshipment = createObject("Component","V16.e_government.cfc.eirsaliye.common")>
<cfset eshipment.dsn = dsn>
<cfset eshipment.dsn2 = dsn2>

<cfset getCompInfo = eshipment.get_our_company_fnc(company_id:session.ep.company_id)>
<cfset GET_ESHIPMENT_DET = eshipment.GET_ESHIPMENT_DETAIL(receiving_detail_id:attributes.receiving_detail_id)>

<cfif getCompInfo.eshipment_type_alias eq 'dp'>
    <cfset soap = createObject("Component","V16.e_government.cfc.eirsaliye.soap")>
    <cfset soap.init()>
    <cfset resultdata = soap.RejectDespatch(uuid : GET_ESHIPMENT_DET.UUID)>
    <cfif resultdata.serviceresult eq "Successful">
        <cfset UPD_STATUS = eshipment.UPD_ESHIPMENT_STATUS(receiving_detail_id:attributes.receiving_detail_id, status : 0)>
        <script type="text/javascript">
            alert("<cf_get_lang dictionary_id='60915.İrsaliye Red Edildi'>!");
            window.opener.location.reload(true);
            window.close();
        </script>
        <cfabort>
    <cfelse>
        <script type="text/javascript">
            alert("<cf_get_lang dictionary_id='60938.İrsaliye Red Edildirken Bir Hata Oluştu.'><cf_get_lang dictionary_id='40568.Hata Kodu'>:<cfoutput>#resultdata.serviceresultdescription#</cfoutput>");
            window.close();
        </script>
        <cfabort>
    </cfif>
<cfelseif getCompInfo.eshipment_type_alias eq 'spr'>
    <cfset soap = createObject("Component","V16.e_government.cfc.super.eshipment.soap")>
    <cfset soap.init()>

    <cfset resultdata = soap.RejectDespatch(uuid : GET_ESHIPMENT_DET.UUID)>
    <cfif resultdata.return_code eq 0>
        <cfset UPD_STATUS = eshipment.UPD_ESHIPMENT_STATUS(receiving_detail_id:attributes.receiving_detail_id, status : 0)>
        <script type="text/javascript">
            alert("<cf_get_lang dictionary_id='60915.İrsaliye Red Edildi'>!");
            window.opener.location.reload(true);
            window.close();
        </script>
        <cfabort>
    <cfelse>
        <script type="text/javascript">
            alert("<cf_get_lang dictionary_id='60938.İrsaliye Red Edildirken Bir Hata Oluştu.'><cf_get_lang dictionary_id='40568.Hata Kodu'>:<cfoutput>#resultdata.return_code#</cfoutput>");
            window.close();
        </script>
        <cfabort>
    </cfif>

</cfif>
