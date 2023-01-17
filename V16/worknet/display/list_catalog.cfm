<cfparam name="attributes.catalog_status" default="1">
<cfparam name="attributes.process_stage" default="1">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.campaign_id" default="">
<cfparam name="attributes.camp_name" default="">
<cfparam name="attributes.target" default="">
<cfparam name="attributes.target_company" default="">
<cfparam name="attributes.catalog_no" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.friendly_url" default="">
<cfset cmp = createObject("component","V16.worknet.cfc.worknet")>
<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
    <cfset get_catalogs = cmp.get_catalogs( keyword : attributes.keyword, process_stage : attributes.process_stage, maxrows : attributes.maxrows,catalog_status : attributes.catalog_status, friendly_url : attributes.friendly_url, catalog_no : attributes.catalog_no, campaign_id : attributes.campaign_id, target_company : attributes.target_company, target : attributes.target, camp_name : attributes.camp_name)>
<cfelse>
    <cfset get_catalogs.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_catalogs.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="catalogs" id="catalogs" action="">
			<input name="is_submitted" id="is_submitted" type="hidden" value="1">
            <cf_box_search>
                <div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" id="keyword" value="#attributes.keyword#" maxlength="50">
				</div>
                <div class="form-group" id="item-friendly">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='63171.Friendly'></cfsavecontent>
					<cfinput type="text" name="friendly_url" placeholder="#message#" id="friendly_url" value="#attributes.friendly_url#" maxlength="50">
				</div>
                <div class="form-group" id="item-catalog_no">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='42408.Katalog no'></cfsavecontent>
					<cfinput type="text" name="catalog_no" placeholder="#message#" id="catalog_no" value="#attributes.catalog_no#" maxlength="50">
				</div>
                <div class="form-group" id="item-process">
                    <cf_workcube_process is_upd='0' is_detail='0'  select_value='#attributes.process_stage#' is_select_text='1'>
				</div>
                <div class="form-group" id="item-campaign">
                    <div class="input-group">
                        <input type="hidden" name="campaign_id" id="campaign_id" value="<cfif len(attributes.campaign_id) and len(attributes.camp_name)><cfoutput>#campaign_id#</cfoutput></cfif>">
                        <input type="text" name="camp_name" id="camp_name" value="<cfif len(attributes.camp_name)><cfoutput>#attributes.camp_name#</cfoutput></cfif>" placeholder="<cf_get_lang dictionary_id='57446.Kampanya'>">
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_campaigns</cfoutput>&draggable=1&field_id=catalogs.campaign_id&field_name=catalogs.camp_name');"></span>
                    </div>
                </div>
                <div class="form-group" id="item-target">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='29533.Tedarikçi'></cfsavecontent>
                        <input type="hidden" name="target_company" id="target_company" value="<cfif len(attributes.target_company)and len(attributes.target)><cfoutput>#attributes.target_company#</cfoutput></cfif>">
                        <input type="text" name="target" id="target" placeholder="<cfoutput>#message#</cfoutput>" value="<cfif len(attributes.target)><cfoutput>#attributes.target#</cfoutput></cfif>" >
                        <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&draggable=1&field_comp_id=catalogs.target_company&field_comp_name=catalogs.target&select_list=2</cfoutput>);"></span>
                    </div>
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
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Katalog',32080)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <th><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='46976.Katalog Adı'></th>
                <th><cf_get_lang dictionary_id='42408.Katalog No'></th>
                <th><cf_get_lang dictionary_id='63171.Friendly'></th>
                <th><cf_get_lang dictionary_id='57446.Kampanya'></th>
                <th><cf_get_lang dictionary_id='29533.Tedarikçi'></th>
                <th><cf_get_lang dictionary_id='29775.Hazırlayan'></th>
                <th width="20"><a href="<cfoutput>#request.self#?fuseaction=watalogy.catalog&event=add</cfoutput>"><i class="fa fa-plus"></i></a></th>     
            </thead>
            <tbody>
                <cfif get_catalogs.recordcount>
                    <cfoutput query="get_catalogs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <td>#currentrow#</td>
                        <td>#CATALOG_HEAD#</td>
                        <td>#CATALOG_NO#</td>
                        <td>#FRIENDLY_URL#</td>
                        <td>#CAMP_HEAD#</td>
                        <td>#FULLNAME#</td>
                        <td>#NAME#</td>
                        <td width="20"><a href="<cfoutput>#request.self#?fuseaction=watalogy.catalog&event=det&id=#CATALOG_ID#</cfoutput>"><i class="fa fa-pencil"></i></a></td>   
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="10"><cfif len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfset adres='watalogy.catalog'>
		<cfif len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
        <cfif len(attributes.friendly_url)>
			<cfset adres = "#adres#&friendly_url=#attributes.friendly_url#">
		</cfif>
        <cfif len(attributes.catalog_no)>
			<cfset adres = "#adres#&catalog_no=#attributes.catalog_no#">
		</cfif>
        <cfif len(attributes.target_company)>
			<cfset adres = "#adres#&target_company=#attributes.target_company#">
		</cfif>
        <cfif len(attributes.catalog_status)>
			<cfset adres = "#adres#&catalog_status=#attributes.catalog_status#">
		</cfif>
        <cfif len(attributes.campaign_id)>
			<cfset adres = "#adres#&campaign_id=#attributes.campaign_id#">
		</cfif>
        <cfif len(attributes.camp_name)>
			<cfset adres = "#adres#&camp_name=#attributes.camp_name#">
		</cfif>
        <cfif len(attributes.target)>
			<cfset adres = "#adres#&target=#attributes.target#">
		</cfif>
        <cfif len(attributes.process_stage)>
			<cfset adres = "#adres#&process_stage=#attributes.process_stage#">
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
			adres="#adres#">
    </cf_box>
</div>