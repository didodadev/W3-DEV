<cf_box_elements>
    <div class="col col-4 col-xs-12">
        <div class="form-group">
            <cfsavecontent variable="head"><cf_get_lang dictionary_id='58137.Kategoriler'></cfsavecontent>
            <label class="padding-top-10 bold" style="font-size:14px!important"><cfoutput>#Ucase(head)#</cfoutput></label>
        </div>
    </div>
</cf_box_elements>
<cf_grid_list>
    <thead>
        <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
        <th><cf_get_lang dictionary_id='57486.Kategori'></th>
        <th class="text-right"><cf_get_lang dictionary_id='57448.Satış'></th>
        <th class="text-right">%</th>
    </thead>
    <cfif get_product_cat.recordcount>
        <cfoutput query="get_product_cat">
            <tbody>
                <td>#currentrow#</td>
                <td>#product_cat#</td>
                <td class="moneybox">#TLformat(nettotal_row)#</td>
                <td class="moneybox"><cfif total_cat.TOTAL_ROW neq 0>#TLformat(nettotal_row*100/total_cat.TOTAL_ROW)#</cfif></td>
            </tbody>
        </cfoutput>
    <cfelse>
        <tr>
            <td colspan="30"> <cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</cf_grid_list>