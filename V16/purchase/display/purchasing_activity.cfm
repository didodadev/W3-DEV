<div id="list_purchasing_activity">
    <cf_xml_page_edit fuseact="purchase.purchase_dashboard">
    <cfparam name="attributes.active_year" default="#year(now())#">
    <cfparam name="attributes.order_stage" default="">
    <cfparam name="attributes.offer_stage" default="">
    <cfparam name="attributes.demand_stage" default="">
    <cfset months_list = "Ocak, Şubat, Mart, Nisan, Mayıs, Haziran, Temmuz, Ağustos, Eylül, Ekim, Kasım, Aralık">
    <cfset dashboard_cmp = createObject("component","V16.purchase.cfc.purchase_dashboard") />
    <cfset get_purchasing_activity = dashboard_cmp.GET_PURCHASE_ACTIVITY(
        offer_show_ids : iIf(len(x_offer_show_ids),"x_offer_show_ids",DE("")),
        offer_hide_ids : iIf(len(x_offer_hide_ids),"x_offer_hide_ids",DE("")),
        order_show_ids : iIf(len(x_order_show_ids),"x_order_show_ids",DE("")),
        order_hide_ids : iIf(len(x_order_hide_ids),"x_order_hide_ids",DE("")),
        demand_show_ids : iIf(len(x_demand_show_ids),"x_demand_show_ids",DE("")),
        demand_hide_ids : iIf(len(x_demand_hide_ids),"x_demand_hide_ids",DE("")),
        active_year : attributes.active_year,
        order_stage : iIf(len(attributes.order_stage),"attributes.order_stage",DE("")),
        offer_stage : iIf(len(attributes.offer_stage),"attributes.offer_stage",DE("")),
        demand_stage : iIf(len(attributes.demand_stage),"attributes.demand_stage",DE(""))
    )/>
    <cfset get_period_years = dashboard_cmp.GET_PERIOD_YEARS(
        company_id : session.ep.company_id
    )/>
    <cfquery name="total_amounts" dbtype="query">
        SELECT
            SUM(TALEP) AS TOTAL_TALEP,
            SUM(TEKLIF) AS TOTAL_TEKLIF,
            SUM(SIPARIS) AS TOTAL_SIPARIS
        FROM
            get_purchasing_activity
    </cfquery>

    <cfquery name="GET_ORDER_STAGE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%purchase.list_order%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfquery name="GET_OFFER_STAGE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%purchase.list_offer%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfquery name="GET_DEMAND_STAGE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%purchase.list_purchasedemand%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>

    <div class="col col-6 col-xs-12">
        <div class="form-group" id="sel_active_year">
            <label class="col col-12"><cf_get_lang dictionary_id="57493.Aktif"><cf_get_lang dictionary_id="58455.Yıl"></label>
            <div class="col col-12">
                <select name="active_year" id="active_year" onChange="change_active_year();">
                    <cfoutput query="get_period_years">
                        <option value="#PERIOD_YEAR#" <cfif attributes.active_year eq PERIOD_YEAR>selected</cfif>>#PERIOD_YEAR#</option>
                    </cfoutput>
                </select>
            </div>
        </div>
    </div>
    <div class="col col-6 col-xs-12">
        <div class="form-group">
            <label class="col col-12"><cf_get_lang dictionary_id="38546.Sipariş Süreci"></label>
            <div class="col col-12">
                <select name="order_stage" id="order_stage" onChange="change_active_year();">
                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                    <cfoutput query="GET_ORDER_STAGE">
                        <option value="#PROCESS_ROW_ID#" <cfif attributes.order_stage eq PROCESS_ROW_ID>selected</cfif>>#STAGE#</option>
                    </cfoutput>
                </select>
            </div>
        </div>
    </div>
    <div class="col col-6 col-xs-12">
        <div class="form-group">
            <label class="col col-12"><cf_get_lang dictionary_id="32842.Teklif Süreci"></label>
            <div class="col col-12">
                <select name="offer_stage" id="offer_stage" onChange="change_active_year();">
                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                    <cfoutput query="GET_OFFER_STAGE">
                        <option value="#PROCESS_ROW_ID#" <cfif attributes.offer_stage eq PROCESS_ROW_ID>selected</cfif>>#STAGE#</option>
                    </cfoutput>
                </select>
            </div>
        </div>
    </div>
    <div class="col col-6 col-xs-12">
        <div class="form-group">
            <label class="col col-12"><cf_get_lang dictionary_id="61013.Talep Süreci"></label>
            <div class="col col-12">
                <select name="demand_stage" id="demand_stage" onChange="change_active_year();">
                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                    <cfoutput query="GET_DEMAND_STAGE">
                        <option value="#PROCESS_ROW_ID#" <cfif attributes.demand_stage eq PROCESS_ROW_ID>selected</cfif>>#STAGE#</option>
                    </cfoutput>
                </select>
            </div>
        </div>
    </div>
    <div class="col col-12 col-xs-12">
        <cf_grid_list sort="1">
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id="58724.Ay"></th>
                    <th><cf_get_lang dictionary_id="33263.Satınalma Talepleri"></th>
                    <th><cf_get_lang dictionary_id="30048.Satınalma Teklifleri"></th>
                    <th><cf_get_lang dictionary_id="30008.Satınalma Siparişleri"></th>
                    <th><cf_get_lang dictionary_id="34434.Para Br"></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_purchasing_activity.recordcount>
                    <cfoutput query="get_purchasing_activity">
                        <cfset start_date = '1/#PURCHASE_MONTH#/#attributes.active_year#'>
                        <cfset finish_date = '#daysInMonth(createDate(attributes.active_year,PURCHASE_MONTH,1))#/#PURCHASE_MONTH#/#attributes.active_year#'>
                        <tr>
                            <td>#listGetAt(months_list,PURCHASE_MONTH)#</td>
                            <td style="text-align:right;">
                                <a href="#request.self#?fuseaction=purchase.list_purchasedemand&is_submit=1&is_active=1&startdate=#start_date#&finishdate=#finish_date#<cfif len(attributes.demand_stage)>&internaldemand_stage=#attributes.demand_stage#</cfif>" target="_blank">
                                    #TLFormat(TALEP)#
                                </a>
                            </td>
                            <td style="text-align:right;">
                                <a href="#request.self#?fuseaction=purchase.list_offer&is_form_submit=1&offer_status=1&start_date=#start_date#&finish_date=#finish_date#<cfif len(attributes.offer_stage)>&offer_stage=#attributes.offer_stage#</cfif>" target="_blank">
                                    #TLFormat(TEKLIF)#
                                </a>
                            </td>
                            <td style="text-align:right;">
                                <a href="#request.self#?fuseaction=purchase.list_order&form_varmi=1&order_status=1&start_date=#start_date#&finish_date=#finish_date#<cfif len(attributes.order_stage)>&order_stage=#attributes.order_stage#</cfif>" target="_blank">
                                    #TLFormat(SIPARIS)#
                                </a>
                            </td>
                            <td>#session.ep.money#</td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="5"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </div>
    <cfif get_purchasing_activity.recordcount>
        <cfoutput query="get_purchasing_activity">
            <cfset 'item_#currentrow#' = "#listGetAt(months_list,PURCHASE_MONTH)#">
            <cfset 'value_demand_#currentrow#' = "#TALEP#">
            <cfset 'value_offer_#currentrow#' = "#TEKLIF#">
            <cfset 'value_order_#currentrow#' = "#SIPARIS#">
        </cfoutput>
        <canvas id="purchasing_activity" style="height:100%;"></canvas>
        <script>
            var purchasing_activity = document.getElementById('purchasing_activity');
            var purchasing_activity_pie = new Chart(purchasing_activity, {
                type: 'line',
                data:   {
                            labels: [<cfloop from="1" to="#get_purchasing_activity.recordcount#" index="i">
                                <cfoutput>"#evaluate("item_#i#")#(%)"</cfoutput>,</cfloop>],
                            datasets: [{
                                label: "<cf_get_lang dictionary_id='33263.Satınalma Talepleri'>%",
                                fill: false,
                                borderColor: [<cfloop from="1" to="#get_purchasing_activity.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_purchasing_activity.recordcount#" index="x"><cfoutput><cfif total_amounts.TOTAL_TALEP neq 0>"#wrk_round(evaluate("value_demand_#x#")*100/total_amounts.TOTAL_TALEP)#"<cfelse>"#wrk_round(0)#"</cfif></cfoutput>,</cfloop>],
                            },
                            {
                                label: "<cf_get_lang dictionary_id='30048.Satınalma Teklifleri'>%",
                                fill: false,
                                borderColor: [<cfloop from="1" to="#get_purchasing_activity.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_purchasing_activity.recordcount#" index="x"><cfoutput><cfif total_amounts.TOTAL_TEKLIF neq 0>"#wrk_round(evaluate("value_offer_#x#")*100/total_amounts.TOTAL_TEKLIF)#"<cfelse>"#wrk_round(0)#"</cfif></cfoutput>,</cfloop>],
                            },
                            {
                                label: "<cf_get_lang dictionary_id='30008.Satınalma Siparişleri'>%",
                                fill: false,
                                borderColor: [<cfloop from="1" to="#get_purchasing_activity.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_purchasing_activity.recordcount#" index="x"><cfoutput><cfif total_amounts.TOTAL_SIPARIS neq 0>"#wrk_round(evaluate("value_order_#x#")*100/total_amounts.TOTAL_SIPARIS)#"<cfelse>"#wrk_round(0)#"</cfif></cfoutput>,</cfloop>],
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
<script type="text/javascript">
	function change_active_year()
	{
        active_year = $("#active_year").val();
        order_stage = $("#order_stage").val();
        offer_stage = $("#offer_stage").val();
        demand_stage = $("#demand_stage").val();
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=purchase.emptypopup_purchasing_activity&active_year='+active_year+'&order_stage='+order_stage+'&offer_stage='+offer_stage+'&demand_stage='+demand_stage,'list_purchasing_activity',1);
		return true;
	}
</script>