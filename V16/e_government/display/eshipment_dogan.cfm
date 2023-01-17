<cfinclude template="create_ubltr_eshipment.cfm" />

<!--- XML dosya dolduruluyor --->
<cffile action="write" file="#directory_name##dir_seperator##shipment_number#.xml" output="#trim(eshipment_data)#" charset="utf-8" />


<cfif attributes.fuseaction neq 'stock.popup_preview_shipment'>

    <cftry>
        <cfset getAuthorization = soap.GetFormsAuthentication()> <!--- izinler kontrol ediliyor --->
        <cfif not len(getAuthorization)>
            <div class="tour_box_content">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<div style="background-color: #f28b82;" class="tour_box tour_box-type2">
						<div class="tour_box_title">
							<h1>Hata Bildirimi !</h1>
						</div>
						<div class="tour_box_text" >
							Ticket Doğrulama Sırasında Bir Sorun Oluştu!<cfabort>
						</div>
					</div>
				</div>
			</div>
        <cfabort>
        </cfif>
		<cfcatch type="Any">
			<div class="tour_box_content">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<div style="background-color: #f28b82;" class="tour_box tour_box-type2">
						<div class="tour_box_title">
							<h1>Hata Bildirimi !</h1>
						</div>
						<div class="tour_box_text" >
							Ticket Doğrulama Sırasında Bir Sorun Oluştu!<cfabort>
						</div>
					</div>
				</div>
			</div>
		</cfcatch>
	</cftry>
	<!--- Çoklu Seri kullanımı varsa kontrol edilip ilgili fonksiyona yonlendiriliyor. çoklu seri fonksiyonuna ship_number 
		değerinin ilk 3 hanesini alıp gönderiyoruz. ilk 3 hane getCompInfo.ESHIPMENT_PREFIX listesinde varsa gönderir 
		yoksa bilgi mesajı verip gönderimi iptal eder.
		soap.cfc dosyasına  SendDespatchDataWithTemplateCode fonksiyonu eklenmelidir.
		
		Çoklu seri fonksiyonu : soap.SendDespatchDataWithTemplateCode(ubl : eshipment_data, pref : get_ship_no)
		tek seri fonksiyonu : soap.SendDespatchData(eshipment_data)
		
		ilhan arslan 12/07/2020
		--->
    <Cfif getCompInfo.IS_MULTIPLE_PREFIX eq 1>
		<cfset get_ship_no = "#left(get_ship.ship_number,3)#">
		<cfif listfind(getCompInfo.ESHIPMENT_PREFIX,get_ship_no,',')>
			<cfset sendShipment = soap.SendDespatchDataWithTemplateCode(ubl : eshipment_data, pref : get_ship_no)> <!--- Ä°rsaliye gÃ¶nderme iÅŸlemi yapÄ±lÄ±yor --->
		<cfelse>
				<cfset ArrayAppend(errorCode,"Lütfen geçerli bir e-irsaliye ön eki giriniz! Geçerli ön ekler:(#getCompInfo.ESHIPMENT_PREFIX#)")>
				<div style="border-left:solid 1px;border-right:solid 1px;border-bottom:solid 1px;border-radius:5px;">
					<h3 style="border-top-left-radius:5px;border-top-right-radius:5px;background-color:#BF0500;color:#FFF;padding:3px 15px;">e-Fatura Gönderilirken <cfif ArrayLen(errorCode) eq 1>Hata<cfelseif ArrayLen(errorCode) gt 1>Hatalar</cfif> Oluştu!</h3>
					<ul>
					<cfloop array="#errorCode#" index="error_code">
						<cfoutput>
							<li style="list-style-image:url(/images/caution_small.gif);margin-top:5px;">#error_code#</li>
						</cfoutput>
					</cfloop>
					</ul> 
				</div>	
				<cfabort>
		</cfif>
	<cfelse>
		<cfset sendShipment = soap.SendDespatchData(eshipment_data)> <!--- Ä°rsaliye gÃ¶nderme iÅŸlemi yapÄ±lÄ±yor --->
	</cfif>

    <cftry>
        <!--- Servis tarafÄ±ndan bir hata aÃ§Ä±klamasÄ± dÃ¶ndÃ¼ ise --->
        <cfset service_result_description = ( isdefined("sendShipment.ServiceResultDescription") ) ? sendShipment.ServiceResultDescription : ''>
        <cfset status_description = ( isdefined("sendShipment.ServiceStatusDescription") ) ? sendShipment.ServiceStatusDescription : ''>
        <cfset error_code = ( isdefined("sendShipment.errorcode") ) ? sendShipment.errorcode : ''>
        <cfset uuid =  ( isdefined("sendShipment.uuid") ) ? sendShipment.uuid : ''>
        <cfset statusCode = ( isdefined("sendShipment.statuscode") ) ? sendShipment.statuscode : ''>
        <cfif structKeyExists( sendShipment, "DESPATCHES" ) and ArrayLen( sendShipment.despatches )>
            <cfset statusCode = sendShipment["DESPATCHES"][1]["STATUSCODE"]>
            <cfset despatchid = sendShipment["DESPATCHES"][1]["DESPATCHID"]>
            <cfset uuid = sendShipment["DESPATCHES"][1]["UUID"]>
            <cfset service_result_description = sendShipment["DESPATCHES"][1]["SERVICERESULTDESCRIPTION"]>
            <cfset status_description = sendShipment["DESPATCHES"][1]["SERVICESTATUSDESCRIPTION"]>
            <cfset error_code = sendShipment["DESPATCHES"][1]["ERRORCODE"]>
        </cfif>
        <cfset shipTypeCode = ""> <!--- iÅŸlem kategorisinden tipi getiriliecek --->

        <!--- irsaliye gÃ¶nderim detaylarÄ± kayÄ±t ediliyor --->
        <cfset sending_detail = common.eShipmentSendingDetail(
                                                                service_result: sendShipment.serviceresult,
                                                                uuid: uuid,
                                                                eshipment_id: shipment_number,
                                                                status_description: status_description,
                                                                service_result_description: service_result_description,
                                                                status_code: statusCode,
                                                                error_code:error_code,
                                                                action_id: attributes.action_id,
                                                                action_type: attributes.action_type,
                                                                shipment_type_code: shipTypeCode
                                                            )>
        
        <cfif statusCode eq 1>
            <cfset shiment_relation = common.eShipmentRelation(
                                                                uuid: uuid,
                                                                integration_id:despatchid,
                                                                eshipment_id:shipment_number,
                                                                profile_id: 'TEMELIRSALIYE',
                                                                action_id: attributes.action_id,
                                                                action_type: attributes.action_type,
                                                                path: temp_path
                                                            )>
            <cfset new_shipment_number = despatchid>
        </cfif>
    <cfcatch type="Any">
        <div class="tour_box_content">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <div style="background-color: #f28b82;" class="tour_box tour_box-type2">
                    <div class="tour_box_title">
                        <h1>Hata Bildirimi !</h1>
                    </div>
                    <div class="tour_box_text" >
                        <p>İrsaliye gönderimi sırasında bir hata meydana geldi, kısa bir süre sonra tekrar deneyin!<br /></p>
                    </div>
                </div>
            </div>
        </div>
        <cfabort>
    </cfcatch>
    </cftry>
   
</cfif>

