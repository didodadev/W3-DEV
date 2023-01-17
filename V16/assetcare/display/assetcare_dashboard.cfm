<!---
    File:V16/assetcare/display/assetcare_dashboard.cfm
    Author: Workcube-Dilek Özdemir
    Date: 16.08.2021
    Controller: AssetcareDashboardController.cfm
    Description: -
--->
<cfset getComponent = createObject('component','V16.assetcare.cfc.assetcare_dashboard')>
<cfset GET_ASSET_CAT = getComponent.GET_ASSET_CAT()>
<cfset GET_ASSET_STATUS = getComponent.GET_ASSET_STATUS()>
<cfset GET_ASSET_PROPERTY = getComponent.GET_ASSET_PROPERTY()>
<cfset GET_ASSET_GROUP = getComponent.GET_ASSET_GROUP()>
<cfset get_failure_using_code = getComponent.get_failure_using_code()>
<cfset get_asset_failure = getComponent.get_asset_failure()>
<cfset GET_EXPENSE = getComponent.GET_EXPENSE()>
<cfset total_expense = getComponent.total_expense()>
<cfset GET_ASSET_BRAND = getComponent.GET_ASSET_BRAND()>
<cfset months_list = "Ocak, Şubat, Mart, Nisan, Mayıs, Haziran, Temmuz, Ağustos, Eylül, Ekim, Kasım, Aralık">
<cf_catalystHeader>
<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
    <cf_box title="#getLang('','Kategorilere Göre Varlıklar','63599')#">
        <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='63600.Varlık Sayısı'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_ASSET_CAT.recordcount>
                        <cfoutput query="GET_ASSET_CAT">
                            <tr>
                                <td>#ASSETP_CAT#</td>
                                <td class="text-right">#COUNT_CAT#</td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="4"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
        </div>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
            <div class="col-12" style="margin-left:auto;margin-right:auto;">
                <cfif GET_ASSET_CAT.recordcount>
                    <cfoutput query="GET_ASSET_CAT">
                        <cfset 'value_#currentrow#' = "#COUNT_CAT#">
                        <cfset 'item_#currentrow#' = "#ASSETP_CAT#">

                    </cfoutput>
                    <canvas id="active_orders" style="height:100%;"></canvas>
                    <script>
                        var active_orders = document.getElementById('active_orders');
                        var active_orders_pie = new Chart(active_orders, {
                            type: 'pie',
                            data: {
                                    labels: [<cfloop from="1" to="#GET_ASSET_CAT.recordcount#" index="i">
                                        <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                    datasets: [{
                                        label: "<cf_get_lang dictionary_id='63599.Kategorilere Göre Varlıklar'>%",
                                        backgroundColor: [<cfloop from="1" to="#GET_ASSET_CAT.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                        data: [<cfloop from="1" to="#GET_ASSET_CAT.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/GET_ASSET_CAT.total_count)#"</cfoutput>,</cfloop>],
                                    }]
                                },
                            options: {
                                legend: {
                                    display: false
                                }
                            }
                        });
                    </script>
                </cfif>
            </div>
        </div>
    </cf_box>
    <cf_box title="#getLang('','Mülkiyet Tipine Göre Varlıklar','63602')#">
        <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='48063.Mülkiyet Tipi'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='63600.Varlık Sayısı'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_ASSET_PROPERTY.recordcount>
                        <cfoutput query="GET_ASSET_PROPERTY">
                            <cfif GET_ASSET_PROPERTY.property eq 1>
                                <cfset property_type = getLang('','Satın Alma','57449')>
                            <cfelseif GET_ASSET_PROPERTY.property eq 2>
                                <cfset property_type = getLang('','Kiralama','38877')>
                            <cfelseif GET_ASSET_PROPERTY.property eq 3>
                                <cfset property_type = getLang('','Leasing','38888')>
                            <cfelseif GET_ASSET_PROPERTY.property eq 4>
                                <cfset property_type = getLang('','Sözleşme','29522')>
                            </cfif>
                            <tr>
                                <td>#property_type#</td>
                                <td class="text-right">#COUNT_PROPERTY#</td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="4"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
        </div>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
            <div class="col-12" style="margin-left:auto;margin-right:auto;">
                <cfif GET_ASSET_PROPERTY.recordcount>
                    <cfoutput query="GET_ASSET_PROPERTY">
                        <cfif GET_ASSET_PROPERTY.property eq 1>
                            <cfset property_type = getLang('','Satın Alma','57449')>
                        <cfelseif GET_ASSET_PROPERTY.property eq 2>
                            <cfset property_type = getLang('','Kiralama','38877')>
                        <cfelseif GET_ASSET_PROPERTY.property eq 3>
                            <cfset property_type = getLang('','Leasing','38888')>
                        <cfelseif GET_ASSET_PROPERTY.property eq 4>
                            <cfset property_type = getLang('','Sözleşme','29522')>
                        </cfif>
                        <cfset 'value_#currentrow#' = "#COUNT_PROPERTY#">
                        <cfset 'item_#currentrow#' = "#property_type#">

                    </cfoutput>
                    <canvas id="asset_property_type" style="height:100%;"></canvas>
                    <script>
                        var asset_property_type = document.getElementById('asset_property_type');
                        var asset_property_type_pie = new Chart(asset_property_type, {
                            type: 'pie',
                            data: {
                                    labels: [<cfloop from="1" to="#GET_ASSET_PROPERTY.recordcount#" index="i">
                                        <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                    datasets: [{
                                        label: "<cf_get_lang dictionary_id='63602.Mülkiyet Tipine Göre Varlıklar'>%",
                                        backgroundColor: [<cfloop from="1" to="#GET_ASSET_PROPERTY.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                        data: [<cfloop from="1" to="#GET_ASSET_PROPERTY.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/GET_ASSET_PROPERTY.TOTAL_PROPERTY)#"</cfoutput>,</cfloop>],
                                    }]
                                },
                            options: {
                                legend: {
                                    display: false
                                }
                            }
                        });
                    </script>
                </cfif>
            </div>
        </div>
    </cf_box>
    <cf_box title="#getLang('','Markalara Göre Varlıklar','63615')#">
        <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58847.Marka'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='63600.Varlık Sayısı'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_ASSET_BRAND.recordcount>
                        <cfoutput query="GET_ASSET_BRAND">
                            <tr>
                                <td>#BRAND_NAME#</td>
                                <td class="text-right">#COUNT_BRAND#</td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="4"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
        </div>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
            <div class="col-12" style="margin-left:auto;margin-right:auto;">
                <cfif GET_ASSET_BRAND.recordcount>
                    <cfoutput query="GET_ASSET_BRAND">
                        <cfset 'value_#currentrow#' = "#COUNT_BRAND#">
                        <cfset 'item_#currentrow#' = "#BRAND_NAME#">

                    </cfoutput>
                    <canvas id="asset_brand" style="height:100%;"></canvas>
                    <script>
                        var asset_brand = document.getElementById('asset_brand');
                        var asset_brand_pie = new Chart(asset_brand, {
                            type: 'pie',
                            data: {
                                    labels: [<cfloop from="1" to="#GET_ASSET_BRAND.recordcount#" index="i">
                                        <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                    datasets: [{
                                        label: "<cf_get_lang dictionary_id='63615.Markalara Göre Varlıklar'>%",
                                        backgroundColor: [<cfloop from="1" to="#GET_ASSET_BRAND.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                        data: [<cfloop from="1" to="#GET_ASSET_BRAND.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/GET_ASSET_BRAND.TOTAL_BRAND)#"</cfoutput>,</cfloop>],
                                    }]
                                },
                            options: {
                                legend: {
                                    display: false
                                }
                            }
                        });
                    </script>
                </cfif>
            </div>
        </div>
    </cf_box>
    <cf_box title="#getLang('','Tamir- Bakım Fişlerinde Aylara Göre Bakım Harcamaları','63613')#">
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cf_grid_list>
                <thead>
                    <tr> 
                        <th><cf_get_lang dictionary_id='58724.Ay'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='63614.Aylık Harcama Tutarları'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_EXPENSE.recordcount>
                        <cfoutput query="GET_EXPENSE">
                            <tr>
                                <td>#listGetAt(months_list,EXPENSE_MONTH)#</td>
                                <td class="text-right"> #TLFormat(TOPLAM)# #session.ep.money#</td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="4"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
        </div>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <div class="col-12" style="margin-left:auto;margin-right:auto;">
                <cfif GET_EXPENSE.recordcount>
                    <cfoutput query="GET_EXPENSE">
                        <cfset 'item_#currentrow#' = "#listGetAt(months_list,EXPENSE_MONTH)#">
                        <cfset 'value_#currentrow#' = "#TOPLAM#">

                    </cfoutput>
                    <canvas id="asset_expense" style="height:100%;"></canvas>
                    <script>
                        var asset_expense = document.getElementById('asset_expense');
                        var asset_expense_pie = new Chart(asset_expense, {
                            type: 'line',
                            data: {
                                    labels: [<cfloop from="1" to="#GET_EXPENSE.recordcount#" index="i">
                                        <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                    datasets: [{
                                        label: "<cf_get_lang dictionary_id='63613.Tamir- Bakım Fişlerinde Aylara Göre Bakım Harcamaları'>%",
                                        backgroundColor: [<cfloop from="1" to="#GET_EXPENSE.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                        data: [<cfloop from="1" to="#GET_EXPENSE.recordcount#" index="x"><cfoutput><cfif total_expense.TOTAL neq 0>"#wrk_round(evaluate("value_#x#")*100/total_expense.TOTAL)#"</cfif></cfoutput>,</cfloop>],
                                    }]
                                },
                            options: {
                                legend: {
                                    display: false
                                }
                            }
                        });
                    </script>
                </cfif>
            </div>
        </div>
    </cf_box>
</div>
<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
    <cf_box title="#getLang('','Durumlarına Göre Varlıklar','63601')#">
        <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='57756.Durum'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='63600.Varlık Sayısı'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_ASSET_STATUS.recordcount>
                        <cfoutput query="GET_ASSET_STATUS">
                            <tr>
                                <td>#ASSET_STATE#</td>
                                <td class="text-right">#COUNT_STATUS#</td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="4"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
        </div>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
            <div class="col-12" style="margin-left:auto;margin-right:auto;">
                <cfif GET_ASSET_STATUS.recordcount>
                    <cfoutput query="GET_ASSET_STATUS">
                        <cfset 'value_#currentrow#' = "#COUNT_STATUS#">
                        <cfset 'item_#currentrow#' = "#ASSET_STATE#">

                    </cfoutput>
                    <canvas id="asset_status" style="height:100%;"></canvas>
                    <script>
                        var asset_status = document.getElementById('asset_status');
                        var asset_status_pie = new Chart(asset_status, {
                            type: 'pie',
                            data: {
                                    labels: [<cfloop from="1" to="#GET_ASSET_STATUS.recordcount#" index="i">
                                        <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                    datasets: [{
                                        label: "<cf_get_lang dictionary_id='63601.Durumlarına Göre Varlıklar'>%",
                                        backgroundColor: [<cfloop from="1" to="#GET_ASSET_STATUS.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                        data: [<cfloop from="1" to="#GET_ASSET_STATUS.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/GET_ASSET_STATUS.TOTAL_STATUS)#"</cfoutput>,</cfloop>],
                                    }]
                                },
                            options: {
                                legend: {
                                    display: false
                                }
                            }
                        });
                    </script>
                </cfif>
            </div>
        </div>
    </cf_box>
    <cf_box title="#getLang('','İş Grubuna Göre Varlıklar','63603')#">
        <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58140.İş Grubu'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='63600.Varlık Sayısı'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_ASSET_GROUP.recordcount>
                        <cfoutput query="GET_ASSET_GROUP">
                            <tr>
                                <td>#GROUP_NAME#</td>
                                <td class="text-right">#COUNT_GROUP#</td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="4"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
        </div>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
            <div class="col-12" style="margin-left:auto;margin-right:auto;">
                <cfif GET_ASSET_GROUP.recordcount>
                    <cfoutput query="GET_ASSET_GROUP">
                        <cfset 'value_#currentrow#' = "#COUNT_GROUP#">
                        <cfset 'item_#currentrow#' = "#GROUP_NAME#">

                    </cfoutput>
                    <canvas id="asset_group" style="height:100%;"></canvas>
                    <script>
                        var asset_group = document.getElementById('asset_group');
                        var asset_group_pie = new Chart(asset_group, {
                            type: 'pie',
                            data: {
                                    labels: [<cfloop from="1" to="#GET_ASSET_GROUP.recordcount#" index="i">
                                        <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                    datasets: [{
                                        label: "<cf_get_lang dictionary_id='63603.İş Grubuna Göre Varlıklar'>%",
                                        backgroundColor: [<cfloop from="1" to="#GET_ASSET_GROUP.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                        data: [<cfloop from="1" to="#GET_ASSET_GROUP.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/GET_ASSET_GROUP.TOTAL_GROUP)#"</cfoutput>,</cfloop>],
                                    }]
                                },
                            options: {
                                legend: {
                                    display: false
                                }
                            }
                        });
                    </script>
                </cfif>
            </div>
        </div>
    </cf_box>
    <cf_box title="#getLang('','Arıza Tipine Göre Varlıklar','63609')#">
        <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='63610.Arıza Tipi'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='63600.Varlık Sayısı'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_failure_using_code.recordcount>
                        <cfoutput query="get_failure_using_code">
                            <tr>
                                <td>#SERVICE_CODE#</td>
                                <td class="text-right">#COUNT_SERVICE#</td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="4"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
        </div>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
            <div class="col-12" style="margin-left:auto;margin-right:auto;">
                <cfif get_failure_using_code.recordcount>
                    <cfoutput query="get_failure_using_code">
                        <cfset 'value_#currentrow#' = "#COUNT_SERVICE#">
                        <cfset 'item_#currentrow#' = "#SERVICE_CODE#">

                    </cfoutput>
                    <canvas id="asset_service" style="height:100%;"></canvas>
                    <script>
                        var asset_service = document.getElementById('asset_service');
                        var asset_service_pie = new Chart(asset_service, {
                            type: 'pie',
                            data: {
                                    labels: [<cfloop from="1" to="#get_failure_using_code.recordcount#" index="i">
                                        <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                    datasets: [{
                                        label: "<cf_get_lang dictionary_id='63601.Durumlarına Göre Varlıklar'>%",
                                        backgroundColor: [<cfloop from="1" to="#get_failure_using_code.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                        data: [<cfloop from="1" to="#get_failure_using_code.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_#x#")*100/get_failure_using_code.TOTAL_SERVICE)#"</cfoutput>,</cfloop>],
                                    }]
                                },
                            options: {
                                legend: {
                                    display: false
                                }
                            }
                        });
                    </script>
                </cfif>
            </div>
        </div>
    </cf_box>
    <cf_box title="#getLang('','Arıza Durumu Devam Eden Varlıklar','63612')#">
        <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='29452.Varlık'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_asset_failure.recordcount>
                        <cfoutput query="get_asset_failure">
                            <tr>
                                <td>#ASSETP#</td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="4"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
        </div>
    </cf_box>
</div>
