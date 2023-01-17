<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.url_str" default="">
<cfquery name="get_brands" datasource="#dsn#">
	SELECT
		BRAND_ID,
		BRAND_NAME,
        IT_ASSET,
        MOTORIZED_VEHICLE,
        PHYSICAL_ASSET
	FROM
		SETUP_BRAND
	<cfif len(attributes.keyword)>
	WHERE
		BRAND_NAME LIKE '%#attributes.keyword#%'
	</cfif>
	ORDER BY
		BRAND_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_brands.recordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='41606.Markalar'></cfsavecontent>
<div class="col col-12">
    <cf_box title="#message#" scroll="1" collapsable="0" resize="0">
        <cfform name="list_brand" method="post" action="#request.self#?fuseaction=objects.popup_list_brand">            
            <cf_box_search more="0">
                <input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
                <input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
                <div class="form-group" id="item-keyword">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group small" id="item-maxrows">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
        <cf_flat_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='33160.Rezervasyon'></th>
                    <th><cf_get_lang dictionary_id='57630.Tip'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_brands.recordcount>
                    <cfoutput query="get_brands" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                            <td><a href="javascript://" onClick="gonder('#brand_name#','#brand_id#')" class="tableyazi">#brand_name#</a></td>
                            <td><cfif It_Asset eq 1><cf_get_lang dictionary_id="32654.IT Varlıklar"><cfelseif Motorized_Vehicle eq 1><cf_get_lang dictionary_id="47158.Motorlu Taşıt"><cfelseif PHYSICAL_ASSET eq 1><cf_get_lang dictionary_id="58833.Fiziki Varlık"></cfif></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr class="color-row">
                        <td height="20"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfset url_str = "">
            <cfif len(attributes.keyword)>
                <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>
            <cfif len(attributes.field_name)>
                <cfset url_str = "#url_str#&field_name=#attributes.field_name#">
            </cfif>
            <cfif len(attributes.field_id)>
                <cfset url_str = "#url_str#&field_id=#attributes.field_id#">
            </cfif>
            <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="objects.popup_list_brand&#url_str#">
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
function gonder(brand_name,brand_id)
{
	opener.document.<cfoutput>#attributes.field_name#</cfoutput>.value = brand_name;
	opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value = brand_id;
	window.close();
}
</script>
