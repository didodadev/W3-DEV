<cf_grid_list>
    <thead>
        <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
        <th><cf_get_lang dictionary_id='49778.Kasa Kodu'></th>
        <th class="text-right"><cf_get_lang dictionary_id='57448.Satış'></th>
        <th class="text-right"><cf_get_lang dictionary_id='58645.Nakit'>%</th>
        <th class="text-right"><cf_get_lang dictionary_id='38687.Kredi'>%</th>
        <th class="text-right"><cf_get_lang dictionary_id='63123.Sepet'></th>
        <th class="text-right"><cf_get_lang dictionary_id='61551.Sepet Ortalama'></th>
        <th class="text-right"><cf_get_lang dictionary_id='63077.Sepet Ürün'></th>
        <th class="text-right">%</th>
    </thead>
    <cfif get_invoice.recordcount>
        <cfoutput query="get_invoice">
            <tbody>
                <td>#currentrow#</td>
                <td>#equipment#</td>
                <td class="moneybox">#TLformat(NETTOTAL_)#</td>
                <td class="moneybox"><cfif NETTOTAL_ neq 0>#TLformat(cash_action_value_*100/NETTOTAL_)#</cfif></td>
                <td class="moneybox"><cfif NETTOTAL_ neq 0>#TLformat(amount_*100/NETTOTAL_)#</cfif></td>
                <td class="moneybox">#sepet#</td>
                <td class="moneybox"><cfif sepet neq 0>#TLformat(NETTOTAL_/sepet)#</cfif></td>
                <td class="moneybox"><cfif sepet neq 0>#SEPET_URUN/sepet#</cfif></td>
                <td class="moneybox"><cfif total_amount.total neq 0>#TLformat(NETTOTAL_*100/total_amount.total)#</cfif></td>
            </tbody>
            
        </cfoutput>
        <tfoot>
            <cfoutput>
            <tr class="bold">
                <td></td>
                <td class="moneybox"><cf_get_lang_main no='80.Toplam'></td>
                <td  class="moneybox">#TLFormat(total_amount.total)#</td>
                <td class="moneybox"><cfif total_amount.total neq 0>#TLformat(total_amount.total_cash*100/total_amount.total)#</cfif></td>
                <td class="moneybox"><cfif total_amount.total neq 0>#TLformat(total_amount.TOTAL_CREDI*100/total_amount.total)#</cfif></td>
                <td class="moneybox">#total_amount.TOTAL_sepet#</td>
                <td class="moneybox"><cfif total_amount.TOTAL_sepet neq 0>#TLformat(total_amount.total/total_amount.TOTAL_sepet)#</cfif></td>
                <td class="moneybox"><cfif total_amount.TOTAL_sepet neq 0>#total_amount.TOTAL_SEPET_URUN/total_amount.TOTAL_sepet#</cfif></td>
                <td class="moneybox"><cfif total_amount.TOTAL neq 0>#TLformat(total_amount.TOTAL*100/total_amount.TOTAL)#</cfif></td>
            </tr>
        </cfoutput>
        </tfoot>
    <cfelse>
        <tr>
            <td colspan="30"> <cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
   
</cf_grid_list>