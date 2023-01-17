<cf_xml_page_edit fuseact="purchase.purchase_dashboard">
<cfif len(x_expense_budget_id)>
    <cfset dashboard_cmp = createObject("component","V16.purchase.cfc.purchase_dashboard") />
    <cfset get_budget_total = dashboard_cmp.SUPER_SUMMARY_GET_BUDGET(budget_id : x_expense_budget_id)/>
    <cfset get_use_budget_total = dashboard_cmp.SUPER_SUMMARY_GET_USE_BUDGET(budget_id : x_expense_budget_id)/>
    <cfset get_active_demands = dashboard_cmp.GET_ACTIVE_DEMANDS(
        demand_show_ids : iIf(len(x_demand_show_ids),"x_demand_show_ids",DE("")),
        demand_hide_ids : iIf(len(x_demand_hide_ids),"x_demand_hide_ids",DE(""))
    )/>
    <cfset get_active_offers = dashboard_cmp.GET_ACTIVE_OFFERS(
        offer_show_ids : iIf(len(x_offer_show_ids),"x_offer_show_ids",DE("")),
        offer_hide_ids : iIf(len(x_offer_hide_ids),"x_offer_hide_ids",DE(""))
    )/>
    <cfset get_active_orders = dashboard_cmp.GET_ACTIVE_ORDERS(
        order_show_ids : iIf(len(x_order_show_ids),"x_order_show_ids",DE("")),
        order_hide_ids : iIf(len(x_order_hide_ids),"x_order_hide_ids",DE(""))
    )/>
    <cfset get_demands_currency_total = dashboard_cmp.GET_DEMANDS_CURRENCY_TOTAL(
        demand_show_ids : iIf(len(x_demand_show_ids),"x_demand_show_ids",DE("")),
        demand_hide_ids : iIf(len(x_demand_hide_ids),"x_demand_hide_ids",DE(""))
    )/>
    <cfset get_offers_currency_total = dashboard_cmp.GET_OFFERS_CURRENCY_TOTAL(
        offer_show_ids : iIf(len(x_offer_show_ids),"x_offer_show_ids",DE("")),
        offer_hide_ids : iIf(len(x_offer_hide_ids),"x_offer_hide_ids",DE(""))
    )/>
    <cfset get_orders_currency_total = dashboard_cmp.GET_ORDERS_CURRENCY_TOTAL(
        order_show_ids : iIf(len(x_order_show_ids),"x_order_show_ids",DE("")),
        order_hide_ids : iIf(len(x_order_hide_ids),"x_order_hide_ids",DE(""))
    )/>
    <cfquery name="sum_orders" dbtype="query">
        SELECT SUM(SUM_RECORD) AS TOTAL_VALUE FROM get_active_orders
    </cfquery>
    <cfquery name="sum_offers" dbtype="query">
        SELECT SUM(SUM_RECORD) AS TOTAL_VALUE FROM get_active_offers
    </cfquery>
    <cfquery name="sum_demands" dbtype="query">
        SELECT SUM(SUM_RECORD) AS TOTAL_VALUE FROM get_active_demands
    </cfquery>
    <div class="col col-12">
        <div class="col col-4 col-xs-12 text-center">
            <div class="form-group">
                <label class="control-label" style="font-size:14px;"><cf_get_lang dictionary_id="57559.Bütçe">: <cfoutput><a href="#request.self#?fuseaction=budget.list_budgets&event=det&budget_id=#get_budget_total.BUDGET_ID#" target="_blank">#get_budget_total.BUDGET_NAME#</a></cfoutput></label>
            </div>
            <hr/>
            <div class="form-group">
                <label class="control-label" style="font-size:12px;"><cfoutput>#TLFormat(get_budget_total.DIFF_TOTAL)# #session.ep.money#</cfoutput></label>
            </div>
            <div class="form-group">
                <label class="control-label" style="font-size:12px;"><cfoutput>#TLFormat(get_budget_total.DIFF_TOTAL_2)# #session.ep.money2#</cfoutput></label>
            </div>
        </div>
        <div class="col col-4 col-xs-12 text-center">
            <div class="form-group">
                <label class="control-label" style="font-size:14px;"><cf_get_lang dictionary_id="46465.Gerçekleşen"></label>
            </div>
            <hr/>
            <div class="form-group">
                <label class="control-label" style="font-size:12px;"><cfoutput>#TLFormat(get_use_budget_total.TOTAL_VALUE)# #session.ep.money#</cfoutput></label>
            </div>
            <div class="form-group">
                <label class="control-label" style="font-size:12px;"><cfoutput>#TLFormat(get_use_budget_total.TOTAL_VALUE_2)# #session.ep.money2#</cfoutput></label>
            </div>
        </div>
        <div class="col col-4 col-xs-12 text-center">
            <div class="form-group">
                <label class="control-label" style="font-size:14px;"><cf_get_lang dictionary_id="60899.Bütçe Kullanımı"></label>
            </div>
            <cfif get_use_budget_total.TOTAL_VALUE gte get_budget_total.DIFF_TOTAL>
                <cfset kullanim_yuzde = 100>
            <cfelse>
                <cfset kullanim_yuzde = wrk_round(get_use_budget_total.TOTAL_VALUE*100/get_budget_total.DIFF_TOTAL)/>
            </cfif>
            <div class="form-group" style="background:#93a6a28c;margin-bottom: 0px;">
                <div class="project-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="margin:0px;background-color:red;color:black;width:<cfoutput>#kullanim_yuzde#</cfoutput>%">
                    <cfoutput>%#kullanim_yuzde#</cfoutput>
                </div>
            </div>
        </div>
    </div>
    <hr/>
    <div class="col col-12">
        <div class="col col-4 col-xs-12 text-center">
            <div class="form-group">
                <a href="<cfoutput>#request.self#?fuseaction=purchase.list_purchasedemand</cfoutput>" target="_blank"><label class="control-label" style="font-size:14px;"><cf_get_lang dictionary_id="33263.Satınalma Talepleri"></label></a>
            </div>
            <hr/>
            <div class="form-group">
                <label class="control-label" style="font-size:12px;"><cfoutput>#TLFormat(sum_demands.TOTAL_VALUE)# #session.ep.money#</cfoutput></label>
            </div>
            <div class="form-group">
                <label class="control-label" style="font-size:12px;"><cfoutput>#TLFormat(get_demands_currency_total.TOTAL_USD)# #session.ep.money2#</cfoutput></label>
            </div>
        </div>
        <div class="col col-4 col-xs-12 text-center">
            <div class="form-group">
                <a href="<cfoutput>#request.self#?fuseaction=purchase.list_offer</cfoutput>" target="_blank"><label class="control-label" style="font-size:14px;"><cf_get_lang dictionary_id="30048.Satınalma Teklifleri"></label></a>
            </div>
            <hr/>
            <div class="form-group">
                <label class="control-label" style="font-size:12px;"><cfoutput>#TLFormat(sum_offers.TOTAL_VALUE)# #session.ep.money#</cfoutput></label>
            </div>
            <div class="form-group">
                <label class="control-label" style="font-size:12px;"><cfoutput>#TLFormat(get_offers_currency_total.TOTAL_USD)# #session.ep.money2#</cfoutput></label>
            </div>
        </div>
        <div class="col col-4 col-xs-12 text-center">
            <div class="form-group">
                <a href="<cfoutput>#request.self#?fuseaction=purchase.list_order</cfoutput>" target="_blank"><label class="control-label" style="font-size:14px;"><th><cf_get_lang dictionary_id="30008.Satınalma Siparişleri"></th></label></a>
            </div>
            <hr/>
            <div class="form-group">
                <label class="control-label" style="font-size:12px;"><cfoutput>#TLFormat(sum_orders.TOTAL_VALUE)# #session.ep.money#</cfoutput></label>
            </div>
            <div class="form-group">
                <label class="control-label" style="font-size:12px;"><cfoutput>#TLFormat(get_orders_currency_total.TOTAL_USD)# #session.ep.money2#</cfoutput></label>
            </div>
        </div>
    </div>
<cfelse>
    <cf_get_lang dictionary_id="60900.Lütfen XML Ayarlarından Bütçe tanımlarınızı yapınız">!
</cfif>