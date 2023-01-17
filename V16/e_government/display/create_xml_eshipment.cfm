<cfset common = createObject("Component","V16.e_government.cfc.eirsaliye.common")>
<cfset getCompInfo = common.get_our_company_fnc(company_id:session.ep.company_id)>
<cfswitch expression="#getCompInfo.eshipment_type_alias#">
    <cfcase value = "dp">
        <cfset soap = createObject("Component","V16.e_government.cfc.eirsaliye.soap")>
        <cfset soap.init()>
    </cfcase>
    <cfcase value = "dgn">
        <cfset common = createObject("Component","V16.e_government.cfc.dogan.eirsaliye.common")>
        <cfset getCompInfo = common.get_our_company_fnc(company_id:session.ep.company_id)>
        <cfset soap = createObject("Component","V16.e_government.cfc.dogan.eirsaliye.soap")>
        <cfset soap.init()>
    </cfcase>
    <cfcase value = "spr">
        <cfset common = createObject("Component","V16.e_government.cfc.super.eshipment.common")>
        <cfset getCompInfo = common.get_our_company_fnc(company_id:session.ep.company_id)>
        <cfset soap = createObject("Component","V16.e_government.cfc.super.eshipment.soap")>
        <cfset soap.init()>
    </cfcase>
    <cfdefaultcase>
        Lütfen entegrasyon yöntemi seçiniz!
        <cfabort>
    </cfdefaultcase>
</cfswitch>

<cfset getCompAddress = common.getCompanyAdrress(company_id:session.ep.company_id)>
<cfset uuidLibObj = createobject("java", "java.util.UUID")>
<cfset GUIDStr = uuidLibObj.randomUUID().toString()>

<cfset errorCode = ArrayNew(1)>

<cfset cancelControl = common.ShipmentCancelControl(action_id : attributes.action_id)> <!--- İrsaliye İptal Kontrolü --->
<cfif cancelControl.IS_SHIP_IPTAL eq 1>
    <cfset ArrayAppend(errorCode, "İptal edilen irsaliye, E-İrsaliye olarak gönderilemez") >
</cfif>

<cfset moneyControl = common.ShipmentMoneyControl(action_id : attributes.action_id)> <!--- İrsaliye Kur Kontrolü --->
<cfif moneyControl.recordcount>
    <cfset temp_currency_code = 1>
<cfelse>
    <cfset temp_currency_code = 0>
</cfif>

<cfif len(cancelControl.COMPANY_ID)> <!--- Satış irsaliyesi / İrsaliye Bilgileri --->
    <cfset get_ship = common.getShipment(action_id : attributes.action_id, company_id : cancelControl.COMPANY_ID, temp_currency_code : temp_currency_code)>
<cfelseif len(cancelControl.CONSUMER_ID)>
    <cfset get_ship = common.getShipment(action_id : attributes.action_id, consumer_id : cancelControl.CONSUMER_ID, temp_currency_code : temp_currency_code)>
<cfelse> <!--- sevk irsaliyesi --->
    <cfset get_ship = common.getShipment(action_id : attributes.action_id, temp_currency_code : temp_currency_code )>
</cfif>


<cfset get_ship_row = common.getShipmentRow(ship_id : attributes.action_id, temp_currency_code : temp_currency_code)> <!--- İrsaliye Satırları --->

<cfset get_ship_orders = common.getRelatedOrder(ship_id : attributes.action_id)> <!--- İlişkili Sipariş --->

<cfset get_ship_result = common.getShipResult( ship_id : attributes.action_id )>

<cfif attributes.action_type is "SHIP_SEVK">
    <cfset location_in = common.getBranch(department_id : get_ship.department_in)> 
    <cfset location_out = common.getBranch(department_id : get_ship.deliver_store_id)>
</cfif>

<cfif not ( len(get_ship_result.SENDING_ADDRESS) and len(get_ship_result.DELIVERY_COUNTY) and len(get_ship_result.DELIVERY_CITY) and len(get_ship_result.DELIVERY_COUNTRY) and len(get_ship_result.SENDING_POSTCODE) )>
    <cfset ArrayAppend(errorCode, 'Paketleme ve Sevkiyat Ekranından Teslimat Bilgilerini Doldurunuz.')>
</cfif>

<cfif datediff('d',createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'),get_ship.SHIP_DATE) lt 0>
	<cfset ArrayAppend(errorCode, 'İrsaliye Tarihi Bugünden Önce Olamaz. Lütfen İrsaliye Tarihinizi Kontrol ediniz.')>
</cfif>

<cfset get_ship_number = common.GetShipNumber()>
<cfset type_info = 0>

<cfif not len(trim(get_ship_number.eshipment_number))>
   <cfset ArrayAppend(errorCode,'e-İrsaliye Admin Panelinden e-İrsaliye Numarası tanımı yapınız!')>
<cfelse>
    <cfset shipment_number = "#get_ship_number.eshipment_prefix##session.ep.period_year##type_info##left('00000000',8-len(get_ship.ship_id))##get_ship.ship_id#">
</cfif>


<cfif ArrayLen(errorCode)>

    <div style="border-left:solid 1px;border-right:solid 1px;border-bottom:solid 1px;border-radius:5px;">
    	<h3 style="border-top-left-radius:5px;border-top-right-radius:5px;background-color:#BF0500;color:#FFF;padding:3px 15px;">e-İrsaliye Gönderilirken <cfif ArrayLen(errorCode) eq 1>Hata<cfelseif ArrayLen(errorCode) gt 1>Hatalar</cfif> Oluştu!</h3>
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
    <cfset temp_eshipment_folder = 'eshipment_send'>
    <cfset temp_path = '#temp_eshipment_folder#/#session.ep.company_id#/#year(now())#/#numberformat(month(now()),00)#/#shipment_number#.xml'>
    <cfset preview_shipment_xml  = 'documents/eshipment_send/#session.ep.company_id#/#year(now())#/#numberformat(month(now()),00)#/#shipment_number#.xml'>
    <cfset directory_name = "#upload_folder##temp_eshipment_folder##dir_seperator##session.ep.company_id##dir_seperator##year(now())##dir_seperator##numberformat(month(now()),00)#">

    <cfif Not DirectoryExists("#directory_name#")>
        <cfdirectory action="create" directory="#directory_name#" />
    </cfif>

    <cfswitch expression="#getCompInfo.eshipment_type_alias#">
        <cfcase value = "dp">
            <cfinclude template="eshipment_digitalplanet.cfm" />
        </cfcase>
        <cfcase value = "dgn">
            <cfinclude template="eshipment_dogan.cfm" />
        </cfcase>
        <cfcase value = "spr">
            <cfinclude template="eshipment_super.cfm" />
        </cfcase>
        <cfdefaultcase>
            Lütfen entegrasyon yöntemi seçiniz!
            <cfabort>
        </cfdefaultcase>
    </cfswitch>

    

    <cfif attributes.fuseaction neq 'stock.popup_preview_shipment'> <!--- İrsaliye gönderilmiş ise dönen no ile belge ve ilişkili tablo güncelleniyor --->
        <cfif isdefined("new_shipment_number") and len(new_shipment_number)>
            <cfset updPaper = common.updPaperNoSendShipment( ship_number : new_shipment_number, action_id : get_ship.ship_id  )>

            <!--- wex counter kaydı atılıyor --->
            <!--- <cftry>
                <cfset get_license = createObject("component","V16.settings.cfc.workcube_license").get_license_information()>
                <cfhttp url="http://wex.workcube.com/wex.cfm/e-government_paper/addCounter" charset="utf-8" result="result">
                    <cfhttpparam name="subscription_no" type="formfield" value="#get_license.WORKCUBE_ID#" />
                    <cfhttpparam name="domain" type="formfield" value="#cgi.http_host#" />
                    <cfhttpparam name="domain_ip" type="formfield" value="#cgi.local_addr#" />
                    <cfhttpparam name="product_id" type="formfield" value="8780" />
                    <cfhttpparam name="amount" type="formfield" value="1" />
                    <cfhttpparam name="process_type" type="formfield" value="#get_ship.PROCESS_CAT#" />
                    <cfhttpparam name="process_doc_no" type="formfield" value="#new_shipment_number#" />
                    <cfhttpparam name="process_date" type="formfield" value="#dateFormat(get_ship.SHIP_DATE,dateformat_style)#" />
                    <cfhttpparam name="wex_type" type="formfield" value="E-Irsaliye" />
                    <cfhttpparam name="tax_no" type="formfield" value="#getCompInfo.tax_no#">
                    <cfhttpparam name="wex_integrator" type="formfield" value="#getCompInfo.eshipment_type_alias#" />
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

<cfif attributes.fuseaction neq 'stock.popup_preview_shipment'>
    <script type="text/javascript">
        window.opener.location.reload();
        window.location.href="<cfoutput>#request.self#?fuseaction=stock.popup_send_detail_eshipment&action_id=#attributes.action_id#&action_type=#attributes.action_type#</cfoutput>";
    </script>
</cfif>