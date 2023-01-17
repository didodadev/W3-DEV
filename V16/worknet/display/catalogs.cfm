<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Kataloglar',46930)#" popup_box="1">
        <cfparam name="attributes.catalog_status" default="1">
        <cfparam name="attributes.is_submitted" default="">
        <cfparam name="attributes.keyword" default="">
        <cfparam name="attributes.field_id" default="">
        <cfparam name="attributes.field_name" default="">
        <cfset cmp = createObject("component","V16.worknet.cfc.worknet")>
        <cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
            <cfset get_catalogs = cmp.get_catalogs( keyword : attributes.keyword, catalog_status : attributes.catalog_status)>
        <cfelse>
            <cfset get_catalogs.recordcount = 0>
        </cfif>
        <cfparam name="attributes.page" default=1>
        <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
        <cfparam name="attributes.totalrecords" default='#get_catalogs.recordcount#'>
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
        <cfform name="catalogs" id="catalogs" action="">
			<input name="is_submitted" id="is_submitted" type="hidden" value="1">
            <cf_box_search>
                <div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" id="keyword" value="#attributes.keyword#" maxlength="50">
				</div>
                <div class="form-group" id="item-catalog_status">
					<select name="catalog_status" id="catalog_status">
						<option value="1" <cfif attributes.catalog_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.catalog_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="" <cfif attributes.catalog_status eq "">selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
				</div>
                <div class="form-group small" id="item-maxrow">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
				</div> 
                <div class="form-group" id="item-button">
                    <cf_wrk_search_button button_type="4" search_function="loadPopupBox('catalogs',#attributes.modal_id#)">
                </div>
            </cf_box_search>
        </cfform>
        <cf_flat_list>
            <thead>
                <th><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='46976.Katalog Adı'></th>
                <th><cf_get_lang dictionary_id='42408.Katalog No'></th>
                <th><cf_get_lang dictionary_id='63171.Friendly'></th>  
            </thead>
            <tbody>
                <cfif get_catalogs.recordcount>
                    <cfoutput query="get_catalogs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <td>#currentrow#</td>
                        <td><a href="javascript://" onclick="send_catalog(#catalog_id#,'#catalog_head#')">#CATALOG_HEAD#</a></td>
                        <td>#CATALOG_NO#</td>
                        <td>#FRIENDLY_URL#</td>  
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="4"><cfif len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfset adres='objects.widget_loader&widget_load=catalogList&isbox=1&'>
		<cfif len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>       
        <cfif len(attributes.catalog_status)>
			<cfset adres = "#adres#&catalog_status=#attributes.catalog_status#">
		</cfif>
        <cfif len(attributes.field_id)>
			<cfset adres = "#adres#&field_id=#attributes.field_id#">
		</cfif>
        <cfif len(attributes.field_name)>
			<cfset adres = "#adres#&field_name=#attributes.field_name#">
		</cfif>
        <cfif len(attributes.maxrows)>
			<cfset adres = "#adres#&maxrows=#attributes.maxrows#">
		</cfif>
        <cfif len(attributes.is_submitted)>
			<cfset adres = "#adres#&is_submitted=#attributes.is_submitted#">
		</cfif>
        <cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#"
            isAjax="1">
    </cf_box>
</div>
<script>
    function send_catalog(id, head){
        <cfoutput>#attributes.field_id#</cfoutput>.value = id;
        <cfoutput>#attributes.field_name#</cfoutput>.value = head;
        closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
    }
</script>
