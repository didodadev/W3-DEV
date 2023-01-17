<div id="list_top_purchased">
    <cf_xml_page_edit fuseact="purchase.purchase_dashboard">
    <cfparam name="attributes.list_type" default="1">
    <cfparam name="attributes.selected_year" default="#year(now())#">
    <cfset dashboard_cmp = createObject("component","V16.purchase.cfc.purchase_dashboard") />
    <cfset get_top_purchased_by_group = dashboard_cmp.GET_TOP_PURCHASED_BY_GROUP(
        list_type : attributes.list_type,
        selected_year : attributes.selected_year,
        order_show_ids : iIf(len(x_order_show_ids),"x_order_show_ids",DE("")),
        order_hide_ids : iIf(len(x_order_hide_ids),"x_order_hide_ids",DE(""))
    )/>
    <cfset get_period_years = dashboard_cmp.GET_PERIOD_YEARS(
        company_id : session.ep.company_id
    )/>
    <div class="form-group">
        <div class="col col-6 col-xs-12">
            <select name="list_type" id="list_type" onChange="change_list_type();">
                <option value="1" <cfif attributes.list_type eq 1>selected</cfif>><cf_get_lang dictionary_id="34761.Kategori Bazında"></option>
                <option value="2" <cfif attributes.list_type eq 2>selected</cfif>><cf_get_lang dictionary_id="34762.Ürün Bazında"></option>
            </select>
        </div>
        <div class="col col-6 col-xs-12">
            <select name="selected_year" id="selected_year" onChange="change_list_type();">
                <cfoutput query="get_period_years">
                    <option value="#PERIOD_YEAR#" <cfif attributes.selected_year eq PERIOD_YEAR>selected</cfif>>#PERIOD_YEAR#</option>
                </cfoutput>
            </select>
        </div>
    </div>
    <cf_grid_list sort="1">
        <thead>
            <tr>
                <cfif attributes.list_type eq 1>
                    <th><cf_get_lang dictionary_id="57486.Kategori"></th>
                    <th><cf_get_lang dictionary_id="29534.Toplam Tutar"></th>
                    <th><cf_get_lang dictionary_id="34434.Para Br"></th>
                <cfelse>
                    <th><cf_get_lang dictionary_id="44019.Ürün"></th>
                    <th><cf_get_lang dictionary_id="57635.Miktar"></th>
                    <th><cf_get_lang dictionary_id="29534.Toplam Tutar"></th>
                    <th><cf_get_lang dictionary_id="34434.Para Br"></th>
                </cfif>
            </tr>
        </thead>
        <tbody>
            <cfif get_top_purchased_by_group.recordcount>
                <cfoutput query="get_top_purchased_by_group">
                    <tr>
                        <cfif attributes.list_type eq 1>
                            <td>#PRODUCT_CAT#</td>
                            <td style="text-align:right;">#TLFormat(PRICE)#</td>
                            <td>#session.ep.money#</td>
                        <cfelse>
                            <td><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#PRODUCT_ID#" target="_blank">#PRODUCT_NAME#</a></td>
                            <td>#TOTAL_QUANTITY#</td>
                            <td style="text-align:right;">#TLFormat(PRICE)#</td>
                            <td>#session.ep.money#</td>
                        </cfif>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="<cfif attributes.list_type eq 1>3<cfelse>4</cfif>"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"></td>
                </tr>
            </cfif>
        </tbody>
    </cf_grid_list>
</div>
<script type="text/javascript">
	function change_list_type()
	{
        list_type = $("#list_type").val();
        selected_year = $("#selected_year").val();
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=purchase.emptypopup_top_purchased_products&list_type='+list_type+'&selected_year='+selected_year,'list_top_purchased',1);
		return true;
	}
</script>