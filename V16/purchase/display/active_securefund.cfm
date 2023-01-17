<cfset dashboard_cmp = createObject("component","V16.purchase.cfc.purchase_dashboard") />
<cfset get_active_securefund = dashboard_cmp.GET_ACTIVE_SECUREFUND()/>
<cfquery name="active_securefund_total" dbtype="query">
    SELECT COUNT(SECUREFUND_ID) AS TOTAL_RECORD, SUM(ACTION_VALUE) AS TOTAL1, SUM(ACTION_VALUE2) AS TOTAL2 FROM get_active_securefund
</cfquery>
<cfquery name="active_securefund_alinan" dbtype="query">
    SELECT COUNT(SECUREFUND_ID) AS TOTAL_RECORD, SUM(ACTION_VALUE) AS TOTAL1, SUM(ACTION_VALUE2) AS TOTAL2 FROM get_active_securefund WHERE GIVE_TAKE = 0
</cfquery>
<cfquery name="active_securefund_verilen" dbtype="query">
    SELECT COUNT(SECUREFUND_ID) AS TOTAL_RECORD, SUM(ACTION_VALUE) AS TOTAL1, SUM(ACTION_VALUE2) AS TOTAL2 FROM get_active_securefund WHERE GIVE_TAKE = 1
</cfquery>

<div class="col col-6 col-xs-12 text-center" style="border-right:1px solid black;">
    <div class="form-group">
        <label class="control-label" style="font-size:20px;"><cfoutput>#active_securefund_total.TOTAL_RECORD#</cfoutput></label>
    </div>
    <div class="form-group">
        <label class="control-label"><cf_get_lang dictionary_id="61198.Aktif Teminat"></label>
    </div>
</div>
<div class="col col-6 col-xs-12 text-center">
    <div class="form-group">
        <label class="control-label" style="font-size:16px;"><cfoutput>#TLFormat(active_securefund_total.TOTAL1)# #session.ep.money#</cfoutput></label>
    </div>
    <div class="form-group">
        <label class="control-label" style="font-size:16px;"><cfoutput>#TLFormat(active_securefund_total.TOTAL2)# #session.ep.money2#</cfoutput></label>
    </div>
</div>
<hr/>
<div class="col col-6 col-xs-12 text-center" style="border-right:1px solid black;">
    <div class="form-group">
        <label class="control-label" style="font-size:20px;"><cfoutput>#active_securefund_alinan.TOTAL_RECORD#</cfoutput></label>
    </div>
    <div class="form-group">
        <label class="control-label"><cf_get_lang dictionary_id="40316.Alınan Teminat"></label>
    </div>
</div>
<div class="col col-6 col-xs-12 text-center">
    <div class="form-group">
        <label class="control-label" style="font-size:16px;"><cfoutput>#TLFormat(active_securefund_alinan.TOTAL1)# #session.ep.money#</cfoutput></label>
    </div>
    <div class="form-group">
        <label class="control-label" style="font-size:16px;"><cfoutput>#TLFormat(active_securefund_alinan.TOTAL2)# #session.ep.money2#</cfoutput></label>
    </div>
</div>
<hr/>
<div class="col col-6 col-xs-12 text-center" style="border-right:1px solid black;">
    <div class="form-group">
        <label class="control-label" style="font-size:20px;"><cfoutput>#active_securefund_verilen.TOTAL_RECORD#</cfoutput></label>
    </div>
    <div class="form-group">
        <label class="control-label"><cf_get_lang dictionary_id="40315.Verilen Teminat"></label>
    </div>
</div>
<div class="col col-6 col-xs-12 text-center">
    <div class="form-group">
        <label class="control-label" style="font-size:16px;"><cfoutput>#TLFormat(active_securefund_verilen.TOTAL1)# #session.ep.money#</cfoutput></label>
    </div>
    <div class="form-group">
        <label class="control-label" style="font-size:16px;"><cfoutput>#TLFormat(active_securefund_verilen.TOTAL2)# #session.ep.money2#</cfoutput></label>
    </div>
</div>