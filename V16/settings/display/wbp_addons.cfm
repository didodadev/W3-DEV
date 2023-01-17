<cfhttp url="https://dev.workcube.com/web_services/best_practice_service.cfc?method=getBestPractice" result="response" charset="utf-8"></cfhttp>

<cf_box title="WBP & Addons">
    
    <cfif response.Statuscode eq '200 OK'>

        <cfset responseData =  DeserializeJSON(response.filecontent) />
        <cfset install_wbp = createObject("component", "V16/settings/cfc/install_wbp") />

        <cfset get_license_information =  install_wbp.get_license_information() />
        <cfif get_license_information.recordcount and len(get_license_information.WORKCUBE_ID)>
            <cfhttp url="https://networg.workcube.com/web_services/subscription.cfc?method=get_subscription_contract_row" result="response_subscription_contract_row" charset="utf-8">
                <cfhttpparam name="domain_address" type="formfield" value="#application.systemParam.systemParam().employee_url#">
                <cfhttpparam name="license_code" type="formfield" value="#get_license_information.WORKCUBE_ID#">
            </cfhttp>

            <cfif response_subscription_contract_row.Statuscode eq '200 OK' and len( response_subscription_contract_row.Filecontent )>
                <cfset install_wbp.set_license_prod( license_id: get_license_information.LICENSE_ID, prod: response_subscription_contract_row.Filecontent ) />
            </cfif>
        </cfif>

        <style>
            .panel-green{ background-color: rgba(199, 230, 199, 0.3); height:350px !important; }
            .panel-green .panel-heading{ background-color: #5cb85c !important; color: #fff !important; }
        </style>

        <cf_seperator title="#getLang('','Hazır Implementasyonlar',62860)# / #getLang('','Best Practise Uygulamalar',62861)#" id="wbp">
        <div class="col col-12" id="wbp">
            <cfif arrayLen(responseData)>
                <cfoutput>
                    <cfloop array="#responseData#" item="item" index="i">
                        <div class="col col-3 col-md-3 col-xs-12" style="height:180px;">
                            <div class="ui-cards ui-cards-vertical">
                                <div class="ui-cards-text">
                                    <ul class="ui-info-list">
                                        <li><b>#item.BESTPRACTICE_NAME#</b></li>
                                        <li style="max-height:50px; overflow:auto;" class="scrollbar">#item.BESTPRACTICE_DETAIL#</li>
                                        <li><cf_get_lang dictionary_id='46544.Geliştirici'> : <i>#item.BESTPRACTICE_AUTHOR#</i></li>
                                    </ul>
                                    <div>
                                        <cfset get_wbp_status = install_wbp.controlWBPLicense( company_id: session.ep.company_id, wbp_p_code: item.BESTPRACTICE_PRODUCT_CODE ) />
                                        <cfif get_wbp_status.subscription_status>
                                            <cfif not get_wbp_status.company_status>
                                                <a href="#request.self#?fuseaction=settings.wbp_addons&event=det&wbp_p_code=#item.BESTPRACTICE_PRODUCT_CODE#" class="ui-ripple-btn ml-0"><cf_get_lang dictionary_id='48868.Yükle'></a>
                                            <cfelse>
                                                <a href="##" class="ui-ripple-btn ml-0" style="background-color:red;"><cf_get_lang dictionary_id='62866.Yüklü'></a>
                                            </cfif>
                                        <cfelse>
                                            <a href="##" class="ui-ripple-btn ml-0"><cf_get_lang dictionary_id='34589.Satın Al'></a>
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cfloop>
                </cfoutput>
            </cfif>
        </div>

    </cfif>

</cf_box>