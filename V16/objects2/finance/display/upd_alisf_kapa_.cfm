<cfset attributes.var_type = '1,2,3'>
<cfinclude template="decrypt_finance.cfm">

<cfinclude template="../query/get_action_detail.cfm">

<cfoutput>
<hgroup class="finance_display">
    <h3><cf_get_lang dictionary_id ='35569.Alış Faturası Kapama'></h3>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id ='57742.Tarih'></label>
        <cfset adate=dateformat(get_action_detail.action_date,'dd/mm/yyyy')>
        <span>: #adate#</span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id ='49794.Kasadan'></label>
        <span>: 
			<cfset cash_id=get_action_detail.cash_action_from_cash_id>
            <cfinclude template="../query/get_action_cash.cfm">
            #get_action_cash.cash_name#
            <cf_get_lang dictionary_id ='50200.kasasından'>
        </span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id='57441.Fatura'></label>
        <span>: 
        	<cfset bill_id=#get_action_detail.bill_id#>
            <cfinclude template="../query/get_action_bill.cfm">
            #get_action_bill.invoice_number# no'lu fatura
        </span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id ='57673.Tutar'></label>
        <span>: #TLFormat(get_action_detail.cash_action_value)#&nbsp;#session_base.money#</span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id ='58056.Dövizli Tutar'></label>
        <span>: #TLFormat(get_action_detail.other_cash_act_value)#&nbsp;#get_action_detail.other_money#</span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id ='57629.Açıklama'></label>
        <span>: #get_action_detail.action_detail#</span>
    </div>
    <cfif len(get_action_detail.record_emp)>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57483.Kayıt'></label>
            <span>: #get_emp_info(get_action_detail.record_emp,0,0)#&nbsp;#dateformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'dd/mm/yyyy')##timeformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'HH:MM')#</span>
        </div>
    </cfif>
<!---     <div class="area_colmn">
        <input type="button"  onClick="self.close();" value="<cf_get_lang_main no='141.Kapat'>">
    </div> --->
</hgroup>
</cfoutput>


