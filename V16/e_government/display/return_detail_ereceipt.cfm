<cfset soap = createObject("Component","V16.e_government.cfc.emustahsil.soap")>
<cfset common_voucher = createObject("Component","V16.e_government.cfc.emeslekmakbuzu.soap")>
<cfset soap.init()>
<cfset common_voucher.init()>

<cfset common = createObject("Component","V16.e_government.cfc.emustahsil.common")>
<cfset getCompInfo = common.get_our_company_fnc(company_id:session.ep.company_id)>
<cfset getRelation = common.getReceiptRelation(action_id:attributes.action_id, action_type:attributes.action_type)>

<cfsavecontent variable="title"><cf_get_lang dictionary_id='62190.E-Makbuz Dönüş Değerleri'></cfsavecontent>
<cf_box title="#title#">
	<cfif len(getRelation.status_code)>
        <cf_grid_list>
            <thead>
                <tr>
                    <th style="width:180px"><cf_get_lang dictionary_id="59825.Workcube Referans"> <cf_get_lang dictionary_id="58527.ID"></th>
                    <th style="width:120px"><cf_get_lang dictionary_id="62184.E-Makbuz"> <cf_get_lang dictionary_id="58527.ID"></th>                                
                    <th style="width:40px"><cf_get_lang dictionary_id="32646.Kodu"></th>
                    <th><cf_get_lang dictionary_id="57629.Açıklama"></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput>
                    <tr>
                        <td>#getRelation.ereceipt_id#</td>
                        <td>#getRelation.integration_id#</td>
                        <td>#getRelation.status_code#</td>
                        <td><cfif len(getRelation.status_description)>#getRelation.status_description#<cfelse>#getRelation.status#</cfif></td>
                    </tr>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    <cfelse>
        <cfset getAuthorization = soap.GetFormsAuthentication()> <!--- izinler kontrol ediliyor --->
        <cfif not len(getAuthorization)>
                Servis Doğrulama Sırasında Bir Sorun Oluştu!
            <cfabort>
        </cfif>

        <!--- Gönderilen Makbuz durum sorgulanıyor --->
        <cfif attributes.action_type eq 'MM'>
            <cfset GetReceipt = soap.CheckReceiptState( 
                                                        direction : "Outgoing",
                                                        uuid : getRelation.UUID
                                                    )>
        <cfelse>
            <cfset GetReceipt = common_voucher.CheckVoucherState( 
                                                        direction : "Outgoing",
                                                        uuid : getRelation.UUID,
                                                        voucher_id : getRelation.ereceipt_id
                                                    )>
        </cfif>

        <cfif GetReceipt.STATUSCODE eq 0 and GetReceipt.SERVICERESULT is 'Error'>
            <cfset return_code = 'Makbuz Durumu Sorgulanamadı' />
            <!--- <cfquery datasource="#dsn2#">
                DELETE FROM ERECEIPT_RELATION WHERE ACTION_ID = '#attributes.action_id#' AND ACTION_TYPE = '#attributes.action_type#'
                DELETE FROM ERECEIPT_SENDING_DETAIL WHERE ACTION_ID = '#attributes.action_id#' AND ACTION_TYPE = '#attributes.action_type#'
            </cfquery> --->
        <cfelse>
            <cfif listfind('1,19,60',GetReceipt.STATUSCODE)>
                <cfset GetReceipt.statusCode = 1>
            </cfif>
            <cfset updReceipt = common.updReceiptRelation(
                                                                uuid : GetReceipt.uuid,
                                                                StatusCode : GetReceipt.StatusCode,
                                                                CheckInvoiceStateResult: GetReceipt.StatusDescription
                                                            )> 
                                                            
            <cfset return_code = GetReceipt.StatusDescription>
        </cfif>
        <table>
            <tr>
                <td style="color:#F00;font-weight:700"><cfoutput><span>#return_code#</span></cfoutput></td>
            </tr>
        </table>
    </cfif>
</cf_box>
<script type="text/javascript">
    $(document).keydown(function(e){
        // ESCAPE key pressed
        if (e.keyCode == 27) {
            window.close();
        }
    });
</script>