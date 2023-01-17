<!---
    İlker Altındal 03062020
    Gönderilen İrsaliyenin durumu burada sorgulanır
--->
<cfset common = createObject("Component","V16.e_government.cfc.eirsaliye.common")>
<cfset getCompInfo = common.get_our_company_fnc(company_id:session.ep.company_id)>
<cfset getRelation = common.getShipmentRelation(action_id:attributes.action_id, action_type:attributes.action_type)>

<cfsavecontent variable="title"><cf_get_lang dictionary_id='60921.E-irsaliye Dönüş Değerleri'></cfsavecontent>
<cf_box title="#title#">
	<cfif len(getRelation.status_code)>
        <cf_grid_list>
            <thead>
                <tr>
                    <th style="width:180px"><cf_get_lang dictionary_id="59825.Workcube Referans"> <cf_get_lang dictionary_id="58527.ID"></th>
                    <th style="width:120px"><cf_get_lang dictionary_id="60911.E-irsaliye"> <cf_get_lang dictionary_id="58527.ID"></th>                                
                    <th style="width:40px"><cf_get_lang dictionary_id="32646.Kodu"></th>
                    <th><cf_get_lang dictionary_id="57629.Açıklama"></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput>
                    <tr>
                        <td>#getRelation.eshipment_id#</td>
                        <td>#getRelation.integration_id#</td>
                        <td>#getRelation.status_code#</td>
                        <td><cfif len(getRelation.status_description)>#getRelation.status_description#<cfelse>#getRelation.status#</cfif></td>
                    </tr>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    <cfelse>
        <cfif getCompInfo.eshipment_type_alias eq 'dp'>
            <cfset soap = createObject("Component","V16.e_government.cfc.eirsaliye.soap")>
            <cfset soap.init()>
            <cfset getAuthorization = soap.GetFormsAuthentication()> <!--- izinler kontrol ediliyor --->
            <cfif not len(getAuthorization)>
                    Servis Doğrulama Sırasında Bir Sorun Oluştu!
                <cfabort>
            </cfif>
            <!--- Gönderilen İrsaliye durum sorgulanıyor --->
            <cfset GetShipment = soap.CheckDespatchState( 
                                                            direction : "Outgoing",
                                                            uuid : getRelation.UUID
                                                        )>
            <cfif GetShipment.STATUSCODE eq 0 and GetShipment.SERVICERESULT is 'Error' and GetShipment.ERRORCODE eq 34>
                <cfset return_code = 'İrsaliye Entegratör Sisteminde Bulunamadı, İrsaliye Bağlantıları Silindi, Yeniden Gönderebilirsiniz' />
                <cfquery datasource="#dsn2#">
                    DELETE FROM ESHIPMENT_RELATION WHERE ACTION_ID = '#attributes.action_id#' AND ACTION_TYPE = '#attributes.action_type#'
                    DELETE FROM ESHIPMENT_SENDING_DETAIL WHERE ACTION_ID = '#attributes.action_id#' AND ACTION_TYPE = '#attributes.action_type#'
                </cfquery>
            <cfelse>
                <cfset updShipment = common.updShipmentRelation(
                                                                    uuid : GetShipment.uuid,
                                                                    StatusCode : GetShipment.StatusCode,
                                                                    CheckInvoiceStateResult: GetShipment.StatusDescription
                                                                )>                                         
                <cfset return_code = GetShipment.StatusDescription>
            </cfif>
            <table>
                <tr>
                    <td style="color:#F00;font-weight:700"><cfoutput><span>#return_code#</span></cfoutput></td>
                </tr>
            </table>
        <cfelseif getCompInfo.eshipment_type_alias eq 'spr'>
            <cfset soap = createObject("Component","V16.e_government.cfc.super.eshipment.soap")>
            <cfset soap.init()>
            <!--- Gönderilen İrsaliye durum sorgulanıyor --->
            <cfset GetShipment = soap.CheckDespatchState( 
                                                            direction : "Outgoing",
                                                            uuid : getRelation.UUID
                                                        )>
                                                    
            <cfset updShipment = common.updShipmentRelation(
                uuid : GetShipment.uuid,
                StatusCode : GetShipment.StatusCode,
                CheckInvoiceStateResult: GetShipment.StatusDescription
            )>                                         
            <cfset return_code = GetShipment.StatusDescription>
            <table>
                <tr>
                    <td style="color:#F00;font-weight:700"><cfoutput><span>#return_code#</span></cfoutput></td>
                </tr>
            </table>
        <cfelseif getCompInfo.eshipment_type_alias eq 'dgn'>
            <cfset soap = createObject("Component","V16.e_government.cfc.dogan.eirsaliye.soap")>
            <cfset soap.init()>
            <!--- Gönderilen İrsaliye durum sorgulanıyor --->
            <cfset GetShipment = soap.CheckDespatchState( 
                                                            uuid : getRelation.UUID
                                                        )>
                               
            <cfset updShipment = common.updShipmentRelation(
                uuid : GetShipment.uuid,
                StatusCode : GetShipment.StatusCode,
                CheckInvoiceStateResult: GetShipment.StatusDescription
            )>                                         
            <cfset return_code = GetShipment.StatusDescription>
            <table>
                <tr>
                    <td style="color:#F00;font-weight:700"><cfoutput><span>#return_code#</span></cfoutput></td>
                </tr>
            </table>
        </cfif>
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