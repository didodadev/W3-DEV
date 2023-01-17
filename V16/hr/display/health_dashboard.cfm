<cf_xml_page_edit fuseact="hr.health_expense_approve">
<cfif (not isDefined("x_rnd_nmbr")) or (isDefined("x_rnd_nmbr") and not len(x_rnd_nmbr))>
    <cfset x_rnd_nmbr = 2>
</cfif>

<cfset dashboard_cmp = createObject("component","V16.hr.cfc.health_dashboard") />
<cfset get_period_years = dashboard_cmp.GET_PERIOD_YEARS() />

<cfparam name="attributes.period_year" default="#year(now())#">
<cfparam name="attributes.date_field" default="EXPENSE_DATE">
<script src="JS/Chart.min.js"></script>

<cfset dashboard_dsn = "#dsn#_#attributes.period_year#_#session.ep.company_id#">

<cfset get_health_expense_by_assurance = dashboard_cmp.GET_HEALTH_EXPENSE_BY_ASSURANCE(dashboard_dsn : dashboard_dsn, date_field: attributes.date_field, period_year : attributes.period_year) />
<cfset get_health_expense_sum = dashboard_cmp.GET_HEALTH_EXPENSE_SUM(dashboard_dsn : dashboard_dsn, date_field: attributes.date_field, period_year : attributes.period_year) />
<cfset get_health_expense_contracted = dashboard_cmp.GET_HEALTH_EXPENSE_CONTRACTED(dashboard_dsn : dashboard_dsn, date_field: attributes.date_field, period_year : attributes.period_year) />
<cfset get_health_expense_uncontracted = dashboard_cmp.GET_HEALTH_EXPENSE_UNCONTRACTED(dashboard_dsn : dashboard_dsn, date_field: attributes.date_field, period_year : attributes.period_year) />
<cfset get_health_expense_months = dashboard_cmp.GET_HEALTH_EXPENSE_MONTHS(dashboard_dsn : dashboard_dsn, date_field: attributes.date_field, period_year : attributes.period_year) />
<cfset get_health_expense_companies = dashboard_cmp.GET_HEALTH_EXPENSE_COMPANIES(dashboard_dsn : dashboard_dsn, date_field: attributes.date_field, period_year : attributes.period_year) />
<cfset get_health_expense_relatives = dashboard_cmp.GET_HEALTH_EXPENSE_RELATIVES(dashboard_dsn : dashboard_dsn, date_field: attributes.date_field, period_year : attributes.period_year) />
<cfset get_health_expense_sum_by_months = dashboard_cmp.GET_HEALTH_EXPENSE_SUM_BY_MONTHS(dashboard_dsn : dashboard_dsn, date_field: attributes.date_field, period_year : attributes.period_year) />
<cfset months_list = "Ocak, Şubat, Mart, Nisan, Mayıs, Haziran, Temmuz, Ağustos, Eylül, Ekim, Kasım, Aralık">
<cfset relative_level_name_list = "Baba,Anne,Eş,Çoçuk,Çalışan,Kardeş">

<cf_catalystHeader>

<div class="col col-12 col-xs-12">
    <cfform name="search_health_expense" id="search_health_expense" method="post" action="">
        <cf_box id="search_box" uidrop="0">
            <cf_box_search>
                <div class="form-group">
                    <select name="period_year" id="period_year">
                        <option value=""><cf_get_lang dictionary_id="58455.Yıl"></option>
                        <cfoutput query="get_period_years">
                            <option value="#PERIOD_YEAR#" <cfif PERIOD_YEAR eq attributes.period_year>selected</cfif>>#PERIOD_YEAR#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <select name="date_field" id="date_field">
                        <option value=""><cf_get_lang dictionary_id="48615.Tarih Alanı"></option>
                        <option value="EXPENSE_DATE" <cfif "EXPENSE_DATE" eq attributes.date_field>selected</cfif>><cf_get_lang dictionary_id="57073.Belge Tarihi"></option>
                        <option value="PROCESS_DATE" <cfif "PROCESS_DATE" eq attributes.date_field>selected</cfif>><cf_get_lang dictionary_id="57879.İşlem Tarihi"></option>
                        <option value="PAYMENT_DATE" <cfif "PAYMENT_DATE" eq attributes.date_field>selected</cfif>><cf_get_lang dictionary_id="58851.Ödeme Tarihi"></option>
                    </select>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="kontrol()">
                </div>
            </cf_box_search>
        </cf_box>
    </cfform>
</div>

<!--- Sol Kısım --->
<div class="col col-6 col-xs-12">
    <!--- Toplam Sağlık Giderleri --->
    <cfsavecontent variable="sum_details"><cf_get_lang dictionary_id="60604.Toplam Sağlık Giderleri"></cfsavecontent>
    <cf_box id="dashboard_assurance_type" closable="0" collapsable="0" title="#sum_details#" uidrop="1">
        <cf_grid_list sort="1">
            <thead>
                <tr>
                    <th colspan="7" style="text-align:center;"><cf_get_lang dictionary_id="60604.Toplam Sağlık Giderleri">(TL)</th>
                </tr>
                <tr>
                    <th><cf_get_lang dictionary_id="44609.Ay/Yıl"></th>
                    <th style="text-align:center;"><cf_get_lang dictionary_id="60605.Anlaşmalı Ödenen Tutar"></th>
                    <th style="text-align:center;"><cf_get_lang dictionary_id="60606.Anlaşmasız Ödenen Tutar"></th>
                    <th style="text-align:center;"><cf_get_lang dictionary_id="38977.Kesintiler"></th>
                    <th style="text-align:center;"><cf_get_lang dictionary_id="60607.Toplam Net Ödenen Tutar"></th>
                    <th style="text-align:center;"><cf_get_lang dictionary_id="60608.Anlaşmalı Ödeme">(%)</th>
                    <th style="text-align:center;"><cf_get_lang dictionary_id="57492.Toplam"><cf_get_lang dictionary_id="33304.Tax"></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="get_health_expense_sum_by_months">
                    <tr>
                        <td>#listGetAt(months_list,EXP_MONTH)# / #attributes.period_year#</td>
                        <td style="text-align:right;">#TLFormat(ANLASMALI,x_rnd_nmbr)#</td>
                        <td style="text-align:right;">#TLFormat(ANLASMASIZ,x_rnd_nmbr)#</td>
                        <td style="text-align:right;">#TLFormat(KESINTI,x_rnd_nmbr)#</td>
                        <td style="text-align:right;">#TLFormat(TOPLAM,x_rnd_nmbr)#</td>
                        <td style="text-align:center;">
                            <cfif ANLASMALI neq 0 and TOPLAM neq 0>
                                #wrk_round(ANLASMALI*100/TOPLAM,x_rnd_nmbr)#
                            <cfelse>
                                -
                            </cfif>
                        </td>
                        <td style="text-align:right;">#TLFormat(VERGI,x_rnd_nmbr)#</td>
                    </tr>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>

    <!--- Teminat Tiplerine Göre Sağlık Harcamaları --->
    <cfsavecontent variable="by_assurance"><cf_get_lang dictionary_id="60499.Teminat Tiplerine Göre Sağlık Harcamaları"></cfsavecontent>
    <cf_box id="dashboard_assurance_type" closable="0" collapsable="0" title="#by_assurance#" uidrop="1">
        <div class="col col-4 col-xs-12">
            <cf_grid_list sort="1">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id="35333.Teminat Adı"></th>
                        <th><cf_get_lang dictionary_id="57673.Tutar"></th>
                        <th><cf_get_lang dictionary_id="34434.Para Br"></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="get_health_expense_by_assurance">
                        <tr>
                            <td>
                                <cfset asurance_control = dashboard_cmp.ASSURANCE_TYPE_CONTROL(assurance_id : ASSURANCE_ID)>
                                <cfif year(now()) eq attributes.period_year>
                                    <a href="#request.self#?fuseaction=hr.health_expense_approve&assurance_id=#valueList(asurance_control.ASSURANCE_ID)#" target="_blank">#ASSURANCE#</a>
                                <cfelse>
                                    #ASSURANCE#
                                </cfif>
                            </td>
                            <td style="text-align:right;">#TLFormat(OUR_COMPANY_HEALTH_AMOUNT,x_rnd_nmbr)#</td>
                            <td>TL</td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
        </div>
        <div class="col col-8 col-xs-12">
            <cfoutput query="get_health_expense_by_assurance">
                <cfset 'item_#currentrow#' = "#ASSURANCE#">
                <cfset 'value_#currentrow#' = "#OUR_COMPANY_HEALTH_AMOUNT#">
            </cfoutput>
            <canvas id="assurance_type" style="height:100%;"></canvas>
            <script>
                var assurance_type = document.getElementById('assurance_type');
                var assurance_type_pie = new Chart(assurance_type, {
                    type: 'bar',
                    data: {
                            labels: [<cfloop from="1" to="#get_health_expense_by_assurance.recordcount#" index="i">
                                <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                            datasets: [{
                            label: "<cf_get_lang dictionary_id='60499.Teminat Tiplerine Göre Sağlık Harcamaları'>%",
                            backgroundColor: [<cfloop from="1" to="#get_health_expense_by_assurance.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                            data: [<cfloop from="1" to="#get_health_expense_by_assurance.recordcount#" index="x"><cfoutput><cfif get_health_expense_sum.OUR_COMPANY_HEALTH_AMOUNT neq 0>"#wrk_round((evaluate("value_#x#")*100)/get_health_expense_sum.OUR_COMPANY_HEALTH_AMOUNT,x_rnd_nmbr)#"<cfelse>"#wrk_round(0,x_rnd_nmbr)#"</cfif></cfoutput>,</cfloop>],
                                }]
                            },
                    options: {
                        scales: {
                            xAxes: [{
                                barPercentage: 0.3
                            }]
                        },
                        legend: {
                            display: false
                        }
                    }
                });
            </script>
        </div>
    </cf_box>

    <!--- Anlaşmalı/Anlaşmasız Kurum Sağlık Harcamaları --->
    <cfsavecontent variable="by_contracted_uncontracted"><cf_get_lang dictionary_id="60503.Anlaşmalı/Anlaşmasız Kurum Sağlık Harcamaları"></cfsavecontent>
    <cf_box id="dashboard_contracted_uncontracted" closable="0" collapsable="0" title="#by_contracted_uncontracted#" uidrop="1">
        <div class="col col-4 col-xs-12">
            <cf_grid_list sort="1">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id="60504.Kurum Tipi"></th>
                        <th><cf_get_lang dictionary_id="57673.Tutar"></th>
                        <th><cf_get_lang dictionary_id="34434.Para Br"></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <cfoutput>
                            <td><cf_get_lang dictionary_id="39885.Toplam Harcama"></td>
                            <td style="text-align:right;">#TLFormat(get_health_expense_sum.OUR_COMPANY_HEALTH_AMOUNT,x_rnd_nmbr)#</td>
                            <td>TL</td>
                        </cfoutput>
                    </tr>
                    <tr>
                        <cfoutput>
                            <td><cf_get_lang dictionary_id="34758.Anlaşmalı Kurumlar"></td>
                            <td style="text-align:right;">#TLFormat(get_health_expense_contracted.OUR_COMPANY_HEALTH_AMOUNT,x_rnd_nmbr)#</td>
                            <td>TL</td>
                        </cfoutput>
                    </tr>
                    <tr>
                        <cfoutput>
                            <td><cf_get_lang dictionary_id="60505.Anlaşmasız Kurumlar"></td>
                            <td style="text-align:right;">#TLFormat(get_health_expense_uncontracted.OUR_COMPANY_HEALTH_AMOUNT,x_rnd_nmbr)#</td>
                            <td>TL</td>
                        </cfoutput>
                    </tr>
                </tbody>
            </cf_grid_list>
        </div>
        <div class="col col-8 col-xs-12">
            <cfsavecontent variable="item_contracted"><cf_get_lang dictionary_id="34758.Anlaşmalı Kurumlar"></cfsavecontent>
            <cfsavecontent variable="item_uncontracted"><cf_get_lang dictionary_id="60505.Anlaşmasız Kurumlar"></cfsavecontent>
            <cfset 'item_1' = "#item_contracted#">
            <cfset 'value_1' = "#get_health_expense_contracted.OUR_COMPANY_HEALTH_AMOUNT#">
            <cfset 'item_2' = "#item_uncontracted#">
            <cfset 'value_2' = "#get_health_expense_uncontracted.OUR_COMPANY_HEALTH_AMOUNT#">
            <canvas id="contracted_cmp" style="height:100%;"></canvas>
            <script>
                var contracted_cmp = document.getElementById('contracted_cmp');
                var contracted_cmp_pie = new Chart(contracted_cmp, {
                    type: 'pie',
                    data: {
                            labels: [<cfloop from="1" to="2" index="i">
                                <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                            datasets: [{
                            label: "<cf_get_lang dictionary_id='60503.Anlaşmalı/Anlaşmasız Kurum Sağlık Harcamaları'>%",
                            borderWidth: 1,
                            backgroundColor: [<cfloop from="1" to="2" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                            data: [<cfloop from="1" to="2" index="x"><cfoutput><cfif get_health_expense_sum.OUR_COMPANY_HEALTH_AMOUNT neq 0>"#wrk_round((evaluate("value_#x#")*100)/get_health_expense_sum.OUR_COMPANY_HEALTH_AMOUNT,x_rnd_nmbr)#"<cfelse>"#wrk_round(0,x_rnd_nmbr)#"</cfif></cfoutput>,</cfloop>],
                                }]
                            },
                    options: {
                        legend: {
                            display: false
                        }
                    }
                });
            </script>
        </div>
    </cf_box>
</div>

<!--- Sağ Kısım --->
<div class="col col-6 col-xs-12">
    <!--- Aylara Göre Sağlık Harcamaları --->
    <cfsavecontent variable="by_months"><cf_get_lang dictionary_id="60506.Aylara Göre Sağlık Harcamaları"></cfsavecontent>
    <cf_box id="dashboard_months" closable="0" collapsable="0" title="#by_months#" uidrop="1">
        <div class="col col-4 col-xs-12">
            <cf_grid_list sort="1">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id="58724.Ay"></th>
                        <th><cf_get_lang dictionary_id="57673.Tutar"></th>
                        <th><cf_get_lang dictionary_id="34434.Para Br"></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="get_health_expense_months">
                        <tr>
                            <cfset start_date = '1/#currentrow#/#year(now())#'>
                            <cfset finish_date = '#daysInMonth(createDate(year(now()),currentrow,1))#/#currentrow#/#year(now())#'>
                            <td>
                                <cfif year(now()) eq attributes.period_year>
                                    <a href="#request.self#?fuseaction=hr.health_expense_approve&search_date1=#start_date#&search_date2=#finish_date#" target="_blank">#listGetAt(months_list,currentrow)#</a>
                                <cfelse>
                                    #listGetAt(months_list,currentrow)#
                                </cfif>
                            </td>
                            <td style="text-align:right;">#TLFormat(OUR_COMPANY_HEALTH_AMOUNT,x_rnd_nmbr)#</td>
                            <td>TL</td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
        </div>
        <div class="col col-8 col-xs-12">
            <cfoutput query="get_health_expense_months">
                <cfset 'item_#currentrow#' = "#listGetAt(months_list,currentrow)#">
                <cfset 'value_#currentrow#' = "#OUR_COMPANY_HEALTH_AMOUNT#">
            </cfoutput>
            <canvas id="d_months" style="height:100%;"></canvas>
            <script>
                var d_months = document.getElementById('d_months');
                var d_months_pie = new Chart(d_months, {
                    type: 'line',
                    data: {
                            labels: [<cfloop from="1" to="#get_health_expense_months.recordcount#" index="i">
                                <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                            datasets: [{
                            label: "<cf_get_lang dictionary_id='60506.Aylara Göre Sağlık Harcamaları'>%",
                            backgroundColor: [<cfloop from="1" to="#get_health_expense_months.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                            data: [<cfloop from="1" to="#get_health_expense_months.recordcount#" index="x"><cfoutput><cfif get_health_expense_sum.OUR_COMPANY_HEALTH_AMOUNT neq 0>"#wrk_round((evaluate("value_#x#")*100)/get_health_expense_sum.OUR_COMPANY_HEALTH_AMOUNT,x_rnd_nmbr)#"<cfelse>"#wrk_round(0,x_rnd_nmbr)#"</cfif></cfoutput>,</cfloop>],
                                }]
                            },
                    options: {
                        legend: {
                            display: false
                        }
                    }
                });
            </script>
        </div>
    </cf_box>

    <!--- Kurumlara Göre Sağlık Harcamaları --->
    <cfsavecontent variable="by_companies"><cf_get_lang dictionary_id="60574.Kurumlara Göre Sağlık Harcamaları"></cfsavecontent>
    <cf_box id="dashboard_companies" closable="0" collapsable="0" title="#by_companies#" uidrop="1">
        <div class="col col-4 col-xs-12">
            <cf_grid_list sort="1">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id="59977.Sağlık Kurumu"></th>
                        <th><cf_get_lang dictionary_id="57673.Tutar"></th>
                        <th><cf_get_lang dictionary_id="34434.Para Br"></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="get_health_expense_companies">
                        <tr>
                            <td>
                                <cfif year(now()) eq attributes.period_year>
                                    <a href="#request.self#?fuseaction=hr.health_expense_approve&company_id=#COMPANY_ID#&is_link=1" target="_blank">#NICKNAME#</a>
                                <cfelse>
                                    #NICKNAME#
                                </cfif>
                            </td>
                            <td style="text-align:right;">#TLFormat(OUR_COMPANY_HEALTH_AMOUNT,x_rnd_nmbr)#</td>
                            <td>TL</td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
        </div>
        <div class="col col-8 col-xs-12">
            <cfoutput query="get_health_expense_companies">
                <cfset 'item_#currentrow#' = "#NICKNAME#">
                <cfset 'value_#currentrow#' = "#OUR_COMPANY_HEALTH_AMOUNT#">
            </cfoutput>
            <canvas id="d_companies" style="height:100%;"></canvas>
            <script>
                var d_companies = document.getElementById('d_companies');
                var d_companies_pie = new Chart(d_companies, {
                    type: 'bar',
                    data: {
                            labels: [<cfloop from="1" to="#get_health_expense_companies.recordcount#" index="i">
                                <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                            datasets: [{
                            label: "<cf_get_lang dictionary_id='60574.Kurumlara Göre Sağlık Harcamaları'>%",
                            backgroundColor: [<cfloop from="1" to="#get_health_expense_companies.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                            data: [<cfloop from="1" to="#get_health_expense_companies.recordcount#" index="x"><cfoutput><cfif get_health_expense_contracted.OUR_COMPANY_HEALTH_AMOUNT neq 0>"#wrk_round((evaluate("value_#x#")*100)/get_health_expense_contracted.OUR_COMPANY_HEALTH_AMOUNT,x_rnd_nmbr)#"<cfelse>"#wrk_round(0,x_rnd_nmbr)#"</cfif></cfoutput>,</cfloop>],
                                }]
                            },
                    options: {
                        scales: {
                            xAxes: [{
                                barPercentage: 0.3
                            }]
                        },
                        legend: {
                            display: false
                        }
                    }
                });
            </script>
        </div>
    </cf_box>

    <!--- Çalışan ve Çalışan Yakınlarına Göre Sağlık Harcamaları --->
    <cfsavecontent variable="by_employee_relatives"><cf_get_lang dictionary_id="60502.Çalışan ve Çalışan Yakınlarına Göre Sağlık Harcamaları"></cfsavecontent>
    <cf_box id="dashboard_employee_relatives" closable="0" collapsable="0" title="#by_employee_relatives#" uidrop="1">
        <div class="col col-12 col-xs-12">
            <cf_grid_list sort="1">
                <thead>
                    <tr>
                        <th colspan="7" class="text-center"><cf_get_lang dictionary_id="60589.Sağlık Yardımından Yararlananlar"></th>
                    </tr>
                    <tr>
                        <th><cf_get_lang dictionary_id="58724.Ay"></th>
                        <th><cf_get_lang dictionary_id="31327.Baba"></th>
                        <th><cf_get_lang dictionary_id="31328.Anne"></th>
                        <th><cf_get_lang dictionary_id="44696.Eş"></th>
                        <th><cf_get_lang dictionary_id="35917.Çocuk"></th>
                        <th><cf_get_lang dictionary_id="44699.Kardeş"></th>
                        <th><cf_get_lang dictionary_id="57576.Çalışan"></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="get_health_expense_relatives">
                        <tr>
                            <td>#listGetAt(months_list,EXP_MONTH)#</td>
                            <td style="text-align:right;">#TLFormat(BABA,x_rnd_nmbr)#</td>
                            <td style="text-align:right;">#TLFormat(ANNE,x_rnd_nmbr)#</td>
                            <td style="text-align:right;">#TLFormat(ES,x_rnd_nmbr)#</td>
                            <td style="text-align:right;">#TLFormat(COCUK,x_rnd_nmbr)#</td>
                            <td style="text-align:right;">#TLFormat(KARDES,x_rnd_nmbr)#</td>
                            <td style="text-align:right;">#TLFormat(CALISAN,x_rnd_nmbr)#</td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
        </div>
        <div class="col col-12 col-xs-12">
            <cfoutput query="get_health_expense_relatives">
                <cfset 'item_#currentrow#' = "#listGetAt(months_list,EXP_MONTH)#">
                <cfset 'value_1_#currentrow#' = "#BABA#">
                <cfset 'value_2_#currentrow#' = "#ANNE#">
                <cfset 'value_3_#currentrow#' = "#ES#">
                <cfset 'value_4_#currentrow#' = "#COCUK#">
                <cfset 'value_5_#currentrow#' = "#KARDES#">
                <cfset 'value_6_#currentrow#' = "#CALISAN#">
            </cfoutput>
            <canvas id="d_relatives" style="height:100%;"></canvas>
            <script>
                var d_relatives = document.getElementById('d_relatives');
                var d_relatives_pie = new Chart(d_relatives, {
                    type: 'line',
                    data:   {
                                labels: [<cfloop from="1" to="#get_health_expense_relatives.recordcount#" index="i">
                                    <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                                datasets: [{
                                    label: "<cf_get_lang dictionary_id="31327.Baba">%",
                                    fill: false,
                                    borderColor: [<cfloop from="1" to="#get_health_expense_relatives.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_health_expense_relatives.recordcount#" index="x"><cfoutput><cfif get_health_expense_months.OUR_COMPANY_HEALTH_AMOUNT[x] neq 0>"#wrk_round((evaluate("value_1_#x#")*100)/get_health_expense_months.OUR_COMPANY_HEALTH_AMOUNT[x],x_rnd_nmbr)#"<cfelse>"#wrk_round(0,x_rnd_nmbr)#"</cfif></cfoutput>,</cfloop>],
                                },
                                {
                                    label: "<cf_get_lang dictionary_id="31328.Anne">%",
                                    fill: false,
                                    borderColor: [<cfloop from="1" to="#get_health_expense_relatives.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_health_expense_relatives.recordcount#" index="x"><cfoutput><cfif get_health_expense_months.OUR_COMPANY_HEALTH_AMOUNT[x] neq 0>"#wrk_round((evaluate("value_2_#x#")*100)/get_health_expense_months.OUR_COMPANY_HEALTH_AMOUNT[x],x_rnd_nmbr)#"<cfelse>"#wrk_round(0,x_rnd_nmbr)#"</cfif></cfoutput>,</cfloop>],
                                },
                                {
                                    label: "<cf_get_lang dictionary_id="44696.Eş">%",
                                    fill: false,
                                    borderColor: [<cfloop from="1" to="#get_health_expense_relatives.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_health_expense_relatives.recordcount#" index="x"><cfoutput><cfif get_health_expense_months.OUR_COMPANY_HEALTH_AMOUNT[x] neq 0>"#wrk_round((evaluate("value_3_#x#")*100)/get_health_expense_months.OUR_COMPANY_HEALTH_AMOUNT[x],x_rnd_nmbr)#"<cfelse>"#wrk_round(0,x_rnd_nmbr)#"</cfif></cfoutput>,</cfloop>],
                                },
                                {
                                    label: "<cf_get_lang dictionary_id="35917.Çocuk">%",
                                    fill: false,
                                    borderColor: [<cfloop from="1" to="#get_health_expense_relatives.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_health_expense_relatives.recordcount#" index="x"><cfoutput><cfif get_health_expense_months.OUR_COMPANY_HEALTH_AMOUNT[x] neq 0>"#wrk_round((evaluate("value_4_#x#")*100)/get_health_expense_months.OUR_COMPANY_HEALTH_AMOUNT[x],x_rnd_nmbr)#"<cfelse>"#wrk_round(0,x_rnd_nmbr)#"</cfif></cfoutput>,</cfloop>],
                                },
                                {
                                    label: "<cf_get_lang dictionary_id="44699.Kardeş">%",
                                    fill: false,
                                    borderColor: [<cfloop from="1" to="#get_health_expense_relatives.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_health_expense_relatives.recordcount#" index="x"><cfoutput><cfif get_health_expense_months.OUR_COMPANY_HEALTH_AMOUNT[x] neq 0>"#wrk_round((evaluate("value_5_#x#")*100)/get_health_expense_months.OUR_COMPANY_HEALTH_AMOUNT[x],x_rnd_nmbr)#"<cfelse>"#wrk_round(0,x_rnd_nmbr)#"</cfif></cfoutput>,</cfloop>],
                                },
                                {
                                    label: "<cf_get_lang dictionary_id="57576.Çalışan">%",
                                    fill: false,
                                    borderColor: [<cfloop from="1" to="#get_health_expense_relatives.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_health_expense_relatives.recordcount#" index="x"><cfoutput><cfif get_health_expense_months.OUR_COMPANY_HEALTH_AMOUNT[x] neq 0>"#wrk_round((evaluate("value_6_#x#")*100)/get_health_expense_months.OUR_COMPANY_HEALTH_AMOUNT[x],x_rnd_nmbr)#"<cfelse>"#wrk_round(0,x_rnd_nmbr)#"</cfif></cfoutput>,</cfloop>],
                                }]
                            },
                    options: {
                        legend: {
                            display: false
                        }
                    }
                });
            </script>
        </div>
    </cf_box>
</div>

<script type="text/javascript">
    function kontrol() {
        if($('#period_year').val() == ''){
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='58455.Yıl'>");
            $('#period_year').focus();
            return false;
        }
        if($('#date_field').val() == ''){
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='48615.Tarih Alanı'>");
            $('#date_field').focus();
            return false;
        }
        return true;
    }
</script>