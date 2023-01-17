<cfset cmp = createObject("component","V16.worknet.cfc.worknet")>
<cfset get_pro = cmp.related_promotions(catalog_id : attributes.catalog_id)>
<cf_flat_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='58820.Başlık'></th>
            <th width="20"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_promotions&event=add"><i class="fa fa-plus"></i></a></th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_pro">
            <tr>
                <td>#PROM_HEAD#</td>
                <td><a href="#request.self#?fuseaction=product.list_promotions&event=upd&prom_id=#prom_id#"><i class="fa fa-pencil"></i></a></td>
            </tr>
        </cfoutput>
    </tbody>
</cf_flat_list>