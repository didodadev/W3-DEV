<cfset contract_cmp = createObject("component","V16.sales.cfc.subscription_contract")>
<cfset GET_SUBSCRIPTION_ROW = contract_cmp.GET_SUBSCRIPTION_ROW(subscription_id : attributes.subscription_id)>
<cfset contract_cmp = createObject("component","V16.sales.cfc.subscription_contract")>
<cfset GET_SUBSCRIPTION = contract_cmp.GET_SUBSCRIPTION(subscription_id : attributes.subscription_id)>
<div class="table-responsive">
  <table class="table table-bordered">
    <thead>
      <tr class="header-color">
        <th class="border-top-0 border-left-0" scope="col"><cf_get_lang dictionary_id='57629.Açıklama'></th>
        <th class="border-top-0 text-right" scope="col"><cf_get_lang dictionary_id='57635.Quantity'></th>
        <th class="border-top-0 text-left" scope="col"><cf_get_lang dictionary_id='57636.Unit'></th>
        <th class="border-top-0" scope="col" colspan="2"><cf_get_lang dictionary_id='61696.?'></th>
        <th class="border-top-0 text-right" scope="col"><cf_get_lang dictionary_id='57639.KDV'></th>
        <th class="border-top-0 text-right" scope="col"><cf_get_lang dictionary_id='37427.KDV li Fiyat'></th>
        <th class="border-top-0 text-right" scope="col"><cf_get_lang dictionary_id='57212.Total Excluding VAT'></th>
        <th class="border-top-0 border-right-0 text-right" scope="col"><cf_get_lang dictionary_id='51316.Total Including VAT'></th>
      </tr>
    </thead>
    <tbody>
      <cfif GET_SUBSCRIPTION_ROW.recordcount>
        <cfoutput query="GET_SUBSCRIPTION_ROW">
        <tr>
          <td class="border-left-0">#product_name#</td>
          <td class="text-right">#Tlformat(amount)#</td>
          <td>#Unit#</td>
          <td class="text-right">#TLformat(price_other)#</td>
          <td class="text-right">#other_money#</td>
          <td class="text-right">#tax#%</td>
          <td class="text-right">#Tlformat( price_other + (price_other * tax / 100))#</td>
          <td class="text-right">#Tlformat(other_money_value)#</td>
          <td class="border-right-0 text-right">#TLformat(other_money_gross_total)#</td>
        </tr>
      </cfoutput>
      </cfif>
    </tbody>
  </table>
</div>