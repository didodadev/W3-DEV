<cfset getParameter = parameter.getParameter() />

<cfhttp url="https://dev.workcube.com/web_services/best_practice_service.cfc?method=getBestPractice" result="response" charset="utf-8">
    <cfhttpparam name="bestpractice_product_code_not" type="formfield" value="FS023">
</cfhttp>

<cfif response.Statuscode eq '200 OK'>

    <cfset responseData =  DeserializeJSON(response.filecontent) />
    <cfset install_wbp = createObject("component", "workcloud/cfc/install_wbp") />

    <cfset workcube_license = createObject("component", "V16/settings/cfc/workcube_license") />
    <cfset get_license_information =  workcube_license.get_license_information() />
    <cfif get_license_information.recordcount and len(get_license_information.WORKCUBE_ID)>
        <cfhttp url="https://networg.workcube.com/web_services/subscription.cfc?method=get_subscription_contract_row" result="response_subscription_contract_row" charset="utf-8">
            <cfhttpparam name="domain_address" type="formfield" value="#getParameter.employee_url#">
            <cfhttpparam name="license_code" type="formfield" value="#get_license_information.WORKCUBE_ID#">
        </cfhttp>

        <cfif response_subscription_contract_row.Statuscode eq '200 OK' and len( response_subscription_contract_row.Filecontent )>
            <cfset workcube_license.set_license_prod( license_id: get_license_information.LICENSE_ID, prod: response_subscription_contract_row.Filecontent ) />
        </cfif>
    </cfif>

    <style>
        .panel-green{ background-color: rgba(199, 230, 199, 0.3); height:350px !important; }
        .panel-green .panel-heading{ background-color: #5cb85c !important; color: #fff !important; }

        .panel-orange{ background-color: rgba(251, 230, 199, 0.3); height:350px !important; }
        .panel-orange .panel-heading{ background-color: #f0ad4e !important; color: #fff !important; }

        .panel-blue{ background-color: rgba(197, 243, 255, 0.3); height:350px !important; }
        .panel-blue .panel-heading{ background-color: #5bc0de !important; color: #fff !important; }

    </style>
    <div class="ui-info-text">
        <h1 style="color:#5cb85c;">Installation Completed Successfuly</h1>
    </div>
    <div class="col-md-12 paddingLess">
        <div class="panel panel-default">
            <div class="panel-heading">Implementasyon Stratejinizi Belirleyin</div>
            <div class="panel-body">
                <div class="col-md-12">Dijitalle??mek i??in implementasyon stratejiniz ne olmal???</div>
                <div class="col-md-12">Haz??r Best Practice ve eklentilerle dijitalle??me s??recinizi nas??l h??zland??rabilirsiniz?</div>
                <div class="col-md-12">Do??ru karar vermek i??in faydal?? bilgileri derledik. Okuman??z?? veya dinlemenizi tavsiye ederiz.</div>
            </div>
        </div>
        <div class="row" id="instruction-panel">
            <div class="col-md-4">
                <div class="panel panel-default panel-green">
                    <div class="panel-heading">Ad??m ad??m Self Implementasyon ile ilerle</div>
                    <div class="panel-body">
                        <div class="col-md-12" style="height:230px;">
                            <p>Sat??n ald??????n??z i?? ????z??mleri ve mod??llere uygun olarak uygulaman??z?? ad??m ad??m implemente edebilirsiniz.</p>
                            <p>Self implementasyon ile hem projenizi implemente eder hem de projenizin durumunu takip edebilirsiniz</p>
                            <p>Wiki: <a href="https://wiki.workcube.com/help/10877" target="_blank">Self ??mplementasyon</a></p>
                        </div>
                        <div class="col-md-12 text-center">
                            <a href="<cfoutput>#installUrl#?installation_type=9&wbp_p_code=FS023&stepimp=1</cfoutput>" class="btn btn-success">> Ad??m Ad??m Implementasyon</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="panel panel-default panel-orange">
                    <div class="panel-heading">Genel Ama??l?? Fabrika Ayarlar?? Best Practice Y??kle</div>
                    <div class="panel-body">
                        <div class="col-md-12" style="height:230px;">
                            <p>Fabrika ayarlar?? Workcube uzmanlar?? taraf??ndan geli??tirilen sekt??r ve co??rafya ba????ms??z h??zl?? uygulama prati??idir.</p>
                            <p>Haz??r parametreler, s??re??ler, i??lem kategorileri, yetki gruplar?? ve roller i??erir. Workcube'?? hemen kullanman??za yard??mc?? olur</p>
                        </div>
                        <div class="col-md-12 text-center">
                            <a href="<cfoutput>#installUrl#?installation_type=9&wbp_p_code=FS023</cfoutput>" class="btn btn-warning">> Fabrika Ayarlar??n?? Y??kle</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="panel panel-default panel-blue">
                    <div class="panel-heading">WBP ve Addonlar?? ??ncele</div>
                    <div class="panel-body">
                        <div class="col-md-12" style="height:230px;">
                            <p>???? s??recinizi an??nda dijitalle??tirecek WBP - Workcube Best Practiceleri inceleyin.</p>
                            <p>Uzun ve zahmetli implementasyon s??resini k??saltarak sekt??r??n??ze ??zel geli??tirilmi?? paketleri inceleyin.</p>
                        </div>
                        <div class="col-md-12 text-center">
                            <a href="#" class="btn btn-info">> WBP ve Addonlar?? ??ncele</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row" id="mywbp-panel" style="margin-bottom:20px;">
            <div class="col-md-12">
                <table class="ui-table-list">
                    <thead>
                        <tr><th colspan = "3" style="color:#E08283;">WBP</th></tr>
                        <tr>
                            <th>Best Practice Code</th>
                            <th>Best Practice Name</th>
                            <th>Publish Date</th>
                            <th style="width:25px">Upload</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfif arrayLen(responseData)>
                            <cfloop array="#responseData#" item="item" index="i">
                                <cfoutput>
                                    <tr>
                                        <td>#item.BESTPRACTICE_PRODUCT_CODE#</td>
                                        <td>#item.BESTPRACTICE_NAME#</td>
                                        <td>#dateformat(item.BESTPRACTICE_PUBLISH_DATE,'dd/mm/yyyy')#</td>
                                        <td class="text-center">
                                            <cfif len(item.BESTPRACTICE_FILE_PATH) and directoryExists("#index_folder##item.BESTPRACTICE_FILE_PATH#")>
                                                <cfset get_wbp_status = install_wbp.controlWBPLicense( company_id: 1, wbp_p_code: item.BESTPRACTICE_PRODUCT_CODE ) />
                                                <cfif get_wbp_status.subscription_status>
                                                    <i class="fa fa-1-5x fa-upload" title="Upload" style="cursor:pointer;" onclick = "document.location.href = '#installUrl#?installation_type=9&wbp_p_code=#item.BESTPRACTICE_PRODUCT_CODE#'"></i>
                                                <cfelse>
                                                    <i class="fa fa-1-5x fa-money" title="Buy">    
                                                </cfif>
                                            <cfelse>
                                                <i class="fa fa-1-5x fa-ban" title="Coming Soon">
                                            </cfif>
                                        </td>
                                    </tr>
                                </cfoutput>
                            </cfloop>
                        <cfelse>
                            <tr><td colspan = "3">You don't have a WBP purchased yet!</td></tr>
                        </cfif>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</cfif>