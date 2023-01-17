<!--- 24092020 / İlker Altındal
      Bütçe Widget - gelir - giderlerin, planlanan / rezerve edilen / gerçekleşen / serbest bütçe şeklinde görüntülenmesini sağlar
--->
<cfset CrObj = createObject("component","V16.myhome.cfc.my_team")>
<cfset GET_EXPENSE_BUDGET = CrObj.get_my_budget()>
<cf_tab defaultOpen="sayfa_1" divId="sayfa_1,sayfa_2,sayfa_3" divLang="Gider;Gelir;Grafik Gösterim">
<cfif GET_EXPENSE_BUDGET.RecordCount>
    <div id="unique_sayfa_1" class="uniqueBox">
        <div class="ui-dashboard">
            <div class="ui-dashboard-item ui-dashboard-item__type2">
                <table class="ui-table-list ui-form">
                    <tbody>
                        <cfoutput>
                            <tr>
                                <td style="width:30px;"><a href="javascript://"><span class="ctl-books-1"></span></a></td>
                                <td><a href="javascript://"><cf_get_lang dictionary_id='58869.Planlanan'></a></td>
                                <td style="text-align:right">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE)# #session.ep.money#</td>
                                <td style="text-align:right">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE_2)# #session.ep.money2#</td>
                            </tr>
                            <tr>
                                <td><a href="javascript://"><span class="ctl-payment-method"></span></a></td>
                                <td><a href="javascript://"><cf_get_lang dictionary_id='58048.Rezerve Edilen'></a></td>
                                <td style="text-align:right">#TLFormat(GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_ALACAK)# #session.ep.money#</td>
                                <td style="text-align:right">#TLFormat(GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_2_ALACAK)# #session.ep.money2#</td>
                            </tr>
                            <tr>
                                <td><a href="javascript://"><span class="ctl-payment-method-1"></span></a></td>
                                <td><a href="javascript://"><cf_get_lang dictionary_id='29750.Rezerve'><cf_get_lang dictionary_id='59563.Kullanılan'></a></td>
                                <td style="text-align:right">#TLFormat(GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_BORC)# #session.ep.money#</td>
                                <td style="text-align:right">#TLFormat(GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_2_BORC)# #session.ep.money2#</td>
                            </tr>
                            <tr>
                                <td><a href="javascript://"><span class="ctl-finances"></span></a></td>
                                <td><a href="javascript://"><cf_get_lang dictionary_id='31491.Gerçekleşen'></a></td>
                                <td style="text-align:right">#TLFormat(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC)# #session.ep.money#</td>
                                <td style="text-align:right">#TLFormat(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC_2)# #session.ep.money2#</td>
                            </tr>
                            <tr>
                                <td><a href="javascript://"><span class="ctl-online-shop-6"></span></a></td>
                                <td><a href="javascript://"><cf_get_lang dictionary_id='60705.Serbest Bütçe'></a></td>
                                <td style="text-align:right"><cfif GET_EXPENSE_BUDGET.recordcount>#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE - GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC - (GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_ALACAK - GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_BORC))# #session.ep.money#</cfif></td>
                                <td style="text-align:right"><cfif GET_EXPENSE_BUDGET.recordcount>#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE_2 - GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC_2 - (GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_2_BORC - GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_2_ALACAK))# #session.ep.money2#</cfif></td>
                            </tr>
                        </cfoutput>
                    </tbody>    
                </table>
            </div>        
        </div>
    </div>
    <div id="unique_sayfa_2" class="uniqueBox">
        <div class="ui-dashboard">
            <div class="ui-dashboard-item ui-dashboard-item__type2">
                <table class="ui-table-list ui-form">
                    <tbody>
                        <cfoutput>
                            <tr>
                                <td style="width:30px;"><a href="javascript://"><span class="ctl-books-1"></span></a></td>
                                <td><a href="javascript://"><cf_get_lang dictionary_id='58869.Planlanan'></a></td>
                                <td style="text-align:right">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME)# #session.ep.money#</td>
                                <td style="text-align:right">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME_2)# #session.ep.money2#</td>
                            </tr>
                            <tr>
                                <td><a href="javascript://"><span class="ctl-finances"></span></a></td>
                                <td><a href="javascript://"><cf_get_lang dictionary_id='31491.Gerçekleşen'></a></td>
                                <td style="text-align:right">#TLFormat(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK)# #session.ep.money#</td>
                                <td style="text-align:right">#TLFormat(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK_2)# #session.ep.money2#</td>
                            </tr>
                            <tr>
                                <td><a href="javascript://"><span class="ctl-online-shop-6"></span></a></td>
                                <td><a href="javascript://"><cf_get_lang dictionary_id='60705.Serbest Bütçe'></a></td>
                                <td style="text-align:right"><cfif GET_EXPENSE_BUDGET.recordcount>#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME-GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK)# #session.ep.money#</cfif></td>
                                <td style="text-align:right"><cfif GET_EXPENSE_BUDGET.recordcount>#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME_2-GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK_2)# #session.ep.money2#</cfif></td>
                            </tr>
                        </cfoutput>
                    </tbody>    
                </table>
            </div>
        
        </div>
    </div>
    <div id="unique_sayfa_3" class="uniqueBox">
        <div class="ui-dashboard">
            <div class="ui-dashboard-item">
                <cfoutput>
                <cfset expense_total = (len(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC) and GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC neq 0) ? (GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC/GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE)*100:0>
                    <canvas style="width:100%!important;" id="myChart7"></canvas>
                    <script>
                        var ctx = document.getElementById('myChart7');
                        var myChart7 = new Chart(ctx, {
                            type: 'doughnut',
                            data: {
                                    labels: ["Gider %",""],
                                    datasets: [{
                                    label: "Gider",
                                    backgroundColor: ["red","##93a6a28c"],
                                    data: [<cfoutput>"#wrk_round(expense_total,2)#","#wrk_round(100-expense_total,2)#"</cfoutput>],
                                        }]
                                    },
                                    options: {
                                        title:
                                        {
                                        display: true,
                                        position: "top",
                                        text: "#getLang("","",58678)# : %#wrk_round(expense_total,2)#",
                                        fontSize: 18,
                                    },
                                    responsive: true,
                                    legend: {
                                    display: false
                                    }
                                }
                        });
                    </script>
                </cfoutput>
            </div>
            <div class="ui-dashboard-item ">
                <cfset income_total = (len(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK) and GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK neq 0) ? (GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK/GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME)*100 :0>
                <cfoutput>
                <canvas style="width:100%!important;" id="myChart88"></canvas>
                    <script>
                        var ctx = document.getElementById('myChart88');
                        var myChart88 = new Chart(ctx, {
                            type: 'doughnut',
                            data: {
                                    labels: ["Gelir %",""],
                                    datasets: [{
                                    label: "Gelir",
                                    backgroundColor: ["red","##93a6a28c"],
                                    data: [<cfoutput>"#wrk_round(income_total,2)#","#wrk_round(100-income_total,2)#"</cfoutput>],
                                        }]
                                    },
                                    options: {
                                        title:
                                        {
                                        display: true,
                                        position: "top",
                                        text: "#getLang("","",58677)# : %#wrk_round(income_total,2)#",
                                        fontSize: 18,
                                    },
                                    responsive: true,
                                    legend: {
                                    display: false
                                    }
                                }
                        });
                    </script>
                </cfoutput>
            </div>
        </div>
    </div>
<cfelse>
    <cf_get_lang dictionary_id='57484.No record'>!
</cfif>