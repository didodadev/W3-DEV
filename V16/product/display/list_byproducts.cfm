<cfquery name="get_byproducts" datasource="#dsn3#">
	SELECT 
        PTBP.*,
        S.STOCK_CODE
    FROM 
        PRODUCT_TREE_BY_PRODUCT PTBP,
        STOCKS S
    WHERE
        PTBP.RELATED_STOCK_ID=S.STOCK_ID AND
        PTBP.STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
</cfquery>
<cf_ajax_list>
	<thead>
        <tr>
            <th><cf_get_lang dictionary_id="58577.Sıra"></th>
            <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
			<th><cf_get_lang dictionary_id='36199.Açıklama'></th>
			<th><cf_get_lang dictionary_id='57647.Spekt'>/<cf_get_lang dictionary_id='45880.Etiket'></th>
			<th><cf_get_lang dictionary_id='63535.Bileşen'>-<cf_get_lang dictionary_id="58577.Sıra"></th>
            <th><cf_get_lang dictionary_id='58831.Boyutlar'></th>
            <th class="text-right">1.<cf_get_lang dictionary_id='57635.Miktar'></th>
            <th>1.<cf_get_lang dictionary_id='57636.Birim'></th>
            <th class="text-right">2.<cf_get_lang dictionary_id='57635.Miktar'></th>
            <th>2.<cf_get_lang dictionary_id='57636.Birim'></th>     
            <th width="20"></th>
            <th width="20"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.add_byproducts&event=add&stock_id=#attributes.stock_id#&product_id=#attributes.product_id#</cfoutput>')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>   
        </tr>
    </thead>
    <tbody>
	<cfoutput query="get_byproducts">
			<tr>
			<td>#currentrow#</td>
            <td>#STOCK_CODE#</td>
            <td>#DETAIL#</td>
            <td>#SPECT_ID#</td>
            <td>
            <cfif COMPONENT eq 1>
            <cf_get_lang dictionary_id="64083.Bekletme">
            <cfelseif COMPONENT eq 2>
            <cf_get_lang dictionary_id="63507.Ayrıştırma">    
            <cfelseif COMPONENT eq 3>
            <cf_get_lang dictionary_id="64084.Süzme">
            </cfif>
            </td>
            <cfif len(related_product_id)>
            <cfquery name="GET_UNIT" datasource="#dsn3#">
                SELECT 
                    MAIN_UNIT,
                    ADD_UNIT
                FROM 
                    PRODUCT_UNIT
                WHERE
                    PRODUCT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#related_product_id#"> AND
                    IS_MAIN != 0
            </cfquery>
            </cfif>
            <td>#WIDTH#*#HEIGHT#*#LENGTH#</td>
            <td align="right">#AMOUNT#</td>
            <td> <cfif len(related_product_id)>#GET_UNIT.MAIN_UNIT#</cfif></td>
            <td align="right">#AMOUNT2#</td>
            <td> <cfif len(related_product_id)>#GET_UNIT.ADD_UNIT#</cfif></td>
            <td><a href="javascript://" onclick="delete_row(#BY_PRODUCT_ID#)"><i style="color:red!important;" class="fa fa-remove " title="#getLang("prod",176)#"></i></a></td>
            <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=product.upd_byproducts&event=upd&id=#BY_PRODUCT_ID#&stock_id=#attributes.stock_id#&product_id=#attributes.product_id#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
			</tr>
    </cfoutput>
     </tbody>
</cf_ajax_list>
<script>
    function delete_row(value)
    {
        if (confirm('<cf_get_lang dictionary_id="57533.Silmek istediğinizden emin misiniz?">')) 
        {
            window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=product.emptypopup_del_byproducts&id='+value+'';
            
        }
    }
</script>
