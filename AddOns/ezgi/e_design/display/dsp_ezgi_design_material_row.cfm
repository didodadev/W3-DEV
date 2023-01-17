<cfsetting showdebugoutput="yes">
<cfinclude template="../query/get_ezgi_product_tree_creative_material.cfm">
<cf_seperator title="#getLang('product',319)#" id="material_" is_closed="0">
<div id="material_">
	<cf_form_list id="material_">
        <thead>
            <tr style="height:30px">
                <th style="text-align:right;width:30px"><cf_get_lang_main no='1165.Sıra'></th>
                <th style="text-align:left;width:100%"><cf_get_lang_main no='245.Ürün'></th>
                <th style="text-align:right;width:50px"><cf_get_lang_main no='223.Miktar'></th>  
                <th style="text-align:left;width:30px"><cf_get_lang_main no='224.Birim'></th>             
            </tr>
        </thead>
        <tbody>
        <cfoutput query="get_material">
            <tr id="frm_row_exit#currentrow#">
                <td style="text-align:right">#currentrow#&nbsp;</td>
                <td title="#PRODUCT_NAME#" style="width:100%; height:15px">
                	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#&sid=#stock_id#','list');">
                    	<input name="materialproductname#currentrow#" type="text" readonly="readonly" value="#PRODUCT_NAME#" style="width:100%; border:none;cursor:pointer;">
                    </a>
                </td>
                <td style="text-align:right;">#AmountFormat(AMOUNT)#&nbsp;</td>
                <td style="text-align:left;" <cfif len(MAIN_UNIT) gte 2>title="#MAIN_UNIT#"</cfif>>&nbsp;#Left(MAIN_UNIT,2)#<cfif len(MAIN_UNIT) gt 2>.</cfif></td>
            </tr>
        </cfoutput>
       </tbody>
    </cf_form_list>
</div>
