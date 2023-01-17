<cfquery name="get_property" datasource="#dsn1#">
	SELECT 
		PDP.VARIATION_ID,
		PDP.DETAIL,
		PDP.TOTAL_MIN,
		PDP.TOTAL_MAX,
		PDP.AMOUNT,
		PDP.IS_OPTIONAL,
		PDP.IS_EXIT,
		PDP.IS_INTERNET,
		PP.PROPERTY,
		PP.PROPERTY_ID
	FROM 
		PRODUCT_DT_PROPERTIES PDP,
		PRODUCT_PROPERTY PP
	WHERE 
		PDP.PRODUCT_ID = #attributes.pid# AND
		PDP.PROPERTY_ID = PP.PROPERTY_ID
	ORDER BY
		PDP.LINE_VALUE
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Ürün Özellikleri',33614)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cf_grid_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='57632.Özellik'></th>
                <th width="120"><cf_get_lang dictionary_id='33615.Varyasyon'></th>
                <th width="180"><cf_get_lang dictionary_id='57629.Açıklama'></th>
                <th width="80"><cf_get_lang dictionary_id='33616.Değer'></th>
                <th width="40"><cf_get_lang dictionary_id='57635.Miktar'></th>
                <th width="30"><cf_get_lang dictionary_id="32732.Input"></th>
                <th width="30"><cf_get_lang dictionary_id="32734.Output"></th>
                <th width="30"><cf_get_lang dictionary_id="32864.Web"></th>
            </tr>
        </thead>
        <tbody>
        <cfoutput query="get_property">
            <cfquery name="get_variation" datasource="#dsn1#">
                SELECT PROPERTY_DETAIL_ID, PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = #get_property.property_id#
            </cfquery>
            <tr>
                <td>#property#</td>
                <td>
                    <cfset var_value = get_property.variation_id>
                    <cfloop query="get_variation">	
                        <cfif var_value eq property_detail_id>#property_detail#</cfif>
                    </cfloop>
                </td>
                <td>#detail#</td>
                <td>#tlformat(total_min,2)#<cfif len(total_max) and len(total_min)> / </cfif>#tlformat(total_max,2)#</td>
                <td class="text-right">#tlformat(amount,2)#</td>
                <td class="text-center"><input type="checkbox" name="is_optional#currentrow#" id="is_optional#currentrow#" <cfif is_optional eq 1>checked</cfif> disabled></td>
                <td class="text-center"><input type="checkbox" name="is_exit#currentrow#" id="is_exit#currentrow#" <cfif is_exit eq 1>checked</cfif> disabled></td>
                <td class="text-center"><input type="checkbox" name="is_internet#currentrow#" id="is_internet#currentrow#" <cfif is_internet eq 1>checked</cfif> disabled></td>
            </tr>
        </cfoutput>
        </tbody>
    </cf_grid_list>
</cf_box>
