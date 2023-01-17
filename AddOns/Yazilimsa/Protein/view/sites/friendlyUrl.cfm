<cfset getUserfriendlyData = createObject('component','AddOns.Yazilimsa.Protein.cfc.friendlyUrl')>

<cfparam name="attributes.form_submitted" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.site" default="">
<cfparam name="attributes.is_legacy" default="">
<cfparam name="attributes.is_internet" default="">
<cfparam name="attributes.status" default="1">

<cfif isdefined("attributes.form_submitted")>
    <cfset GET_PROTEIN_SITES = getUserfriendlyData.GET_PROTEIN_SITES(
        site : attributes.site,
        keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#',        
        status : '#iif(isdefined("attributes.status"),"attributes.status",DE(""))#',
        index : '#iif(isdefined("attributes.index"),"attributes.index",DE(""))#',
        page_id : '#iif(isdefined("attributes.page_id"),"attributes.page_id",DE(""))#',
        no_follow : '#iif(isdefined("attributes.no_follow"),"attributes.no_follow",DE(""))#',
        no_archive : '#iif(isdefined("attributes.no_archive"),"attributes.no_archive",DE(""))#',
        no_image_index : '#iif(isdefined("attributes.no_image_index"),"attributes.no_image_index",DE(""))#',
        no_snipped : '#iif(isdefined("attributes.no_snipped"),"attributes.no_snipped",DE(""))#',
        no_follow_external_links : '#iif(isdefined("attributes.no_follow_external_links"),"attributes.no_follow_external_links",DE(""))#',
        related_wo : '#iif(isdefined("attributes.related_wo"),"attributes.related_wo",DE(""))#',
        is_legacy : '#iif(isdefined("attributes.is_legacy"),"attributes.is_legacy",DE(""))#',
        is_internet : '#iif(isdefined("attributes.is_internet"),"attributes.is_internet",DE(""))#'
    )>
    <cfset PROTEIN_PAGES = getUserfriendlyData.PROTEIN_PAGES(
    site : attributes.site,
    page_id : '#iif(isdefined("attributes.page_id"),"attributes.page_id",DE(""))#'
    )>
    <cfset PROTEIN_SITES = getUserfriendlyData.PROTEIN_SITES()>
<cfelse>
	<cfset GET_PROTEIN_SITES.recordcount = 0>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_PROTEIN_SITES.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box>
    <cfform name="form" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.friendly_url">   
        <cf_box_search>
            <div class="form-group" id="item-keyword">
                <cfinput type="text" name="keyword" id="keyword" placeholder="  Filtre" value="#decodeForHTML(attributes.keyword)#" maxlength="50">
                <input type="hidden" name="form_submitted" id="form_submitted" value="1" />
            </div>               
            <div class="form-group" id="item-page_id">                    
                <select name="page_id" id="page_id">
                    <option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>                                    
                    <cfoutput query="PROTEIN_PAGES"> 
                        <option value="#page_id#" <cfif isdefined("attributes.page_id") and len(attributes.page_id) and (attributes.page_id eq page_id)>selected</cfif>>#title#</option>
                    </cfoutput>
                </select>
            </div>
            <div class="form-group" id="item-record_member">
                <div class="input-group">                        
                    <input type="text" name="related_wo" placeholder="Related WO" id="related_wo" value="">	
                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_dsp_faction_list&field_name=form.related_wo&function=proteinApp.woSelected&is_upd=1&only_choice=1&draggable=1&choice=1');" ></span>
                </div>
            </div>
            <div class="form-group" id="item-status">
                <select name="status" id="status">                        
                    <option value="1" <cfif attributes.status eq 1> selected</cfif>><cf_get_lang dictionary_id='29479.Yayın'></option>
                    <option value="2" <cfif attributes.status eq 2> selected</cfif>><cf_get_lang dictionary_id='58506.İptal'></option>
                    <option value="3" <cfif attributes.status eq 3> selected</cfif>><cf_get_lang dictionary_id='63169.Geçici Durdurma'></option>
                    <option value="4" <cfif attributes.status eq 4> selected</cfif>><cf_get_lang dictionary_id='63170.Yönlendirme'></option>
                    <option value="0"><cf_get_lang dictionary_id='57708.Tümü'></option>
                </select>
            </div>               
            <div class="form-group small">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" id="maxrows" value="#decodeForHTML(attributes.maxrows)#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
            </div>
        </cf_box_search>               
        <cf_box_search_detail>
            <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-index">
                    <div class="col col-12">
                        <label><input type="checkbox" name="index" id="index" <cfif isdefined("attributes.index")> checked</cfif>>Index</label>
                        <label><input type="checkbox" name="no_follow" id="no_follow" <cfif isdefined("attributes.no_follow")> checked</cfif>>No Follow</label>
                        <label><input type="checkbox" name="no_archive" id="no_archive" <cfif isdefined("attributes.no_archive")> checked</cfif>>No Archive</label>
                        <label><input type="checkbox" name="no_image_index" id="no_image_index" <cfif isdefined("attributes.no_image_index")> checked</cfif>>No Image Index</label>
                        <label><input type="checkbox" name="no_snipped" id="no_snipped" <cfif isdefined("attributes.no_snipped")> checked</cfif>>No Snipped</label>
                        <label><input type="checkbox" name="no_follow_external_links" id="no_follow_external_links" <cfif isdefined("attributes.no_follow_external_links")> checked</cfif>> No Follow External Links</label>    
                    </div>
                </div>
            </div>
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-site">
                    <label class="col col-12">Site</label>
                    <div class="col col-12">
                        <select name="site" id="site" multiple>
                            <option value="" <cfif len(attributes.site) eq 0>selected</cfif> ><cf_get_lang dictionary_id='57708.Tümü'></option> 
                            <cfoutput query="PROTEIN_SITES">
                                <option value="#SITE_ID#" <cfif SITE_ID EQ attributes.site>selected</cfif>>#DOMAIN#</option>
                            </cfoutput>                    
                        </select>
                    </div>
                </div>                
            </div>
            <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-index">
                    <div class="col col-12">
                        <label class="font-red"><input type="checkbox" name="is_legacy" id="is_legacy" value="1" <cfif isdefined("attributes.is_legacy") and attributes.is_legacy eq 1> checked</cfif>>Legacy</label>
                        <label class="font-blue"><input type="checkbox" name="is_internet" id="is_internet" value="1" <cfif isdefined("attributes.is_internet") and attributes.is_internet eq 1> checked</cfif>>Sadece İnternette Yayınlana İçeriklere Bak</label>
                    </div>
                </div>
            </div>
        </cf_box_search_detail>        
    </cfform>
</cf_box>

<cfsavecontent  variable="head"><cf_get_lang dictionary_id='33495.Protein'> <cf_get_lang dictionary_id='63171.Friendly Url'></cfsavecontent>
<cf_box title="#head#" uidrop="1" hide_table_column="1">  
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="35"><cf_get_lang dictionary_id='57487.No'></th> 
                    <th><cf_get_lang dictionary_id='63171.Friendly Url'></th>
                    <th><cf_get_lang dictionary_id='47869.Site'></th>
                    <th><cf_get_lang dictionary_id='57581.Sayfa'></th>
                    <th><cf_get_lang dictionary_id='63173.Related WO'></th>               
                    <th><cf_get_lang dictionary_id='63174.Action ID'></th>
                    <th><cf_get_lang dictionary_id='57756.Durum'></th>                  
                    <th><cf_get_lang dictionary_id='63175.SEO'></th>
                    <th></th>                    
                </tr>
            </thead>           
            <tbody>  
                <cfif GET_PROTEIN_SITES.recordCount>             
                    <cfoutput query="GET_PROTEIN_SITES" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">  
                        <tr>
                            <td>#currentrow#</td>
                            <td>#USER_FRIENDLY_URL#</td>
                            <td><a href="#request.self#?fuseaction=protein.site&event=upd&site=#SITE_ID#">#DOMAIN#</a></td>
                            <td><a href="#request.self#?fuseaction=protein.pages&event=upd&page=#PAGE_ID#&site=#SITE_ID#">#TITLE#</a></td>                        
                            <td><cfif len(GET_PROTEIN_SITES.PAGE_DATA)>
                                    <cfset related_wo_data = deserializeJSON(GET_PROTEIN_SITES.PAGE_DATA)>
                                    #related_wo_data.RELATED_WO#
                                </cfif>
                            </td>
                            <td><cfif isdefined("related_wo_data.RELATED_WO") and len(related_wo_data.RELATED_WO)><a href="#request.self#?fuseaction=#related_wo_data.RELATED_WO#&event=#PROTEIN_EVENT#&#ACTION_TYPE#=#ACTION_ID#">#ACTION_ID#</a><cfelse>#ACTION_TYPE# : #ACTION_ID#</cfif></td>
                            <td><cfif isDefined("STATUS") and len(STATUS)>
                                    <cfif STATUS eq -1></cfif>
                                    <cfif STATUS eq 1><cf_get_lang dictionary_id='29479.Yayın'></cfif>
                                    <cfif STATUS eq 2><cf_get_lang dictionary_id='58506.İptal'></cfif>
                                    <cfif STATUS eq 3><cf_get_lang dictionary_id='63169.Geçici Durdurma'></cfif>
                                    <cfif STATUS eq 4><cf_get_lang dictionary_id='63170.Yönlendirme'></cfif>
                                </cfif>  
                            </td>
                            <td><cfif len(GET_PROTEIN_SITES.OPTIONS_DATA)>
                                <cfset seo_data = deserializeJSON(GET_PROTEIN_SITES.OPTIONS_DATA)>
                                <cfif seo_data.index eq 1>
                                    <i class="wrk-uF0041" title="index" style="color:##008000"></i>                           
                                </cfif>
                                <cfif seo_data.no_follow eq 1>
                                    <i class="wrk-uF0227" title="No Follow" style="color:##FF0000"></i>
                                </cfif>
                                <cfif seo_data.no_archive eq 1>
                                    <i class="wrk-uF0207" title="No Archive" style="color:##FF0000"></i>
                                </cfif>
                                <cfif seo_data.no_image_index eq 1>
                                    <i class="wrk-uF0203" title="No Image Index" style="color:##FF0000"></i>
                                </cfif>
                                <cfif seo_data.no_snipped eq 1>
                                    <i class="wrk-uF0054" title="No Snipped" style="color:##FF0000"></i>
                                </cfif>
                                <cfif seo_data.no_follow_external_links eq 1>
                                    <i class="wrk-uF0003" title="No Follow External Links" style="color:##FF0000"></i>
                                </cfif>                            
                            </cfif></td>
                            <td><cf_publishing_settings fuseaction="#iif(isdefined("related_wo_data.RELATED_WO") and len(related_wo_data.RELATED_WO),DE('##related_wo_data.RELATED_WO##'),DE(''))#" event="#PROTEIN_EVENT#" action_type="#ACTION_TYPE#" action_id="#ACTION_ID#" icon="true"></td>                                
                        </tr>
                    </cfoutput>
                <cfelse>
					<tr>
						<td colspan="9">
							<cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif>
						</td>
					</tr>
				</cfif>
            </tbody>
        </cf_grid_list>

    	<cfset url_str = "protein.friendly_url">	
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfif isdefined("attributes.form_submitted")>
                <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
            </cfif>
            <cfif isdefined("attributes.site")>
                <cfset url_str = "#url_str#&site=#attributes.site#">
            </cfif>
            <cfif isdefined("attributes.is_legacy")>
                <cfset url_str = "#url_str#&is_legacy=#attributes.is_legacy#">
            </cfif>
            <cfif isdefined("attributes.is_internet")>
                <cfset url_str = "#url_str#&is_internet=#attributes.is_internet#">
            </cfif>            
            <cfif len(attributes.keyword)>
                <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>
            <cfif isdefined("attributes.page_id")>
                <cfset url_str = "#url_str#&page_id=#attributes.page_id#">
            </cfif>
            <cfif len(attributes.status)>
                <cfset url_str = "#url_str#&status=#attributes.status#">
            </cfif>
            <cfif isdefined("attributes.related_wo")>
                <cfset url_str = "#url_str#&related_wo=#attributes.related_wo#">
            </cfif>

            <cfif isdefined("attributes.index")>
                <cfset url_str = "#url_str#&index=#attributes.index#">
            </cfif>
            <cfif isdefined("attributes.no_follow")>
                <cfset url_str = "#url_str#&no_follow=#attributes.no_follow#">
            </cfif>
            <cfif isdefined("attributes.no_archive")>
                <cfset url_str = "#url_str#&no_archive=#attributes.no_archive#">
            </cfif>
            <cfif isdefined("attributes.no_image_index")>
                <cfset url_str = "#url_str#&no_image_index=#attributes.no_image_index#">
            </cfif>
            <cfif isdefined("attributes.no_snipped")>
                <cfset url_str = "#url_str#&no_snipped=#attributes.no_snipped#">
            </cfif>
            <cfif isdefined("attributes.ch_yan")>
                <cfset url_str = "#url_str#&no_follow_external_links=#attributes.no_follow_external_links#">
            </cfif>       
        </cfif>
		
        <cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url_str#"> 
    </cf_box>
</div>