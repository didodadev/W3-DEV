<!--- 25072019ERU Maliyet tarihçesi sayfasında Ek Maliet kolonuna tıklandığında bu sayfa yüklenmektedir---->
<cfset getComponent = createObject('component','V16.product.cfc.get_product_cost')>
<cfset get_product = getComponent.PRODUCT_EXT_COST_DET(prod_id : attributes.pid,pr_id : attributes.pr_order_id)>
<cf_grid_list>
    <thead>
        <tr>	
            <th><cf_get_lang dictionary_id = "57657.Ürün"></th>
            <th><cf_get_lang dictionary_id = "58460.Masraf Merkezi"></th>
            <th><cf_get_lang dictionary_id = "50296.Muhasebe Hesabı"></th>
            <th><cf_get_lang dictionary_id = "47545.Yansıtma Oranı"></th>
            <th><cf_get_lang dictionary_id = "57673.Tutar"></th>
            <th><cf_get_lang dictionary_id = "57489.Para Birimi"></th>           
        </tr>
    </thead>
    <tbody>
        <cfif get_product.recordcount>
            <cfoutput query="get_product">
                <tr>	
                    <td width="15">#PRODUCT_NAME#</td>
                    <td width="15">#EXPENSE#</td>
                    <td width="15">#ACCOUNT_NAME#</td>
                    <td width="15">%#EXPENSE_SHIFT#</td>
                    <td width="15">#TLFormat(AMOUNT)#</td>
                    <td width="15">#MONEY#</td>           
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="6"><cf_get_lang dictionary_id = '57484.kayıt yok'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_grid_list>