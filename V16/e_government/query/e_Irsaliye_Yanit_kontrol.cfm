<!--- 
    Yanıt belgesi oluşan irsaliyelerin UUID VE ID değerleri sisteme kayıt alınır.
    çalıştırıldığı yerden ya da çalıştırıldıktan sonra irsaliye detayından yanıt belgesi indirilebilir.
--->
<cfset soap = createObject("Component","V16.e_government.cfc.eirsaliye.soap")>
<cfset soap.init()>

<cfset common = createObject("Component","V16.e_government.cfc.eirsaliye.common")>
<cfset getCompInfo = common.get_our_company_fnc()>

<cfset dsn2 = '#dsn#_#year(now())#_#getCompInfo.comp_id#'>

<cfif getCompInfo.recordcount gt 0 >
    
    <cfset getAuthorization = soap.GetFormsAuthentication()> <!--- izinler kontrol ediliyor --->
    <cfif not len(getAuthorization)>
            Servis Doğrulama Sırasında Bir Sorun Oluştu!
        <cfabort>
    </cfif>
        <cfset ShipmentReceipt = soap.GetAvailableReceipts(startdate : date_add('d',-29,now()) , enddate : now() )> 

            <cfloop from="1" to="#arrayLen(ShipmentReceipt.RECEIPMENTS)#" index="i">
                <cfquery name="getship" datasource="#dsn2#">
                    SELECT ACTION_ID, ACTION_TYPE FROM ESHIPMENT_RELATION WHERE INTEGRATION_ID = '#ShipmentReceipt.RECEIPMENTS[i]["DESPATCHID"]#'
                </cfquery>
                <tr>
                    <td><cfoutput>#ShipmentReceipt.RECEIPMENTS[i]["DESPATCHID"]#</cfoutput></td>
                    <td><cfoutput>#ShipmentReceipt.RECEIPMENTS[i]["SERVICERESULT"]#</cfoutput></td>
                    <td><cfoutput>#ShipmentReceipt.RECEIPMENTS[i]["RECEIPMENTID"]#</cfoutput> id si ile yanıt belgesi oluşturulmuş. İrsaliye detayından erişebilirsiniz</td>
                    <td>
                        <cfset ship_url = ( getship.ACTION_TYPE eq 'SHIP' ) ? 'stock.form_add_sale&event=upd&ship_id=' : 'stock.add_ship_dispatch&event=upd&ship_id=' >
                        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=<cfoutput>#ship_url##getship.ACTION_ID#</cfoutput>" target="_blank">Belgeye Gitmek İçin Tıklayın</a>
                    </td>
                    <td>
                        <a href='<cfoutput>#request.self#?fuseaction=objects.popup_ajax_list_eshipment_receipment_detail&uuid=#ShipmentReceipt.RECEIPMENTS[i]["UUID"]#&integration_id=#ShipmentReceipt.RECEIPMENTS[i]["RECEIPMENTID"]#</cfoutput>' >Yanıt Belgesini İndirmek İçin Tıklayın.</a>
                    </td>
                </tr>
                <cfset updShipment = common.updShipmentRelationReceipment(
                                                                            receipment_uuid : ShipmentReceipt.RECEIPMENTS[i]["UUID"],
                                                                            receipment_id : ShipmentReceipt.RECEIPMENTS[i]["RECEIPMENTID"],
                                                                            uuid: ShipmentReceipt.RECEIPMENTS[i]["DESPATCHUUID"]
                                                                        )> 
            </cfloop>
<cfelse>
    Tanım Bilgilerini Kontrol Edin!
</cfif>