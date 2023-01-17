<cfset getComponent = createObject('component','WDO.development.cfc.extensions')>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.bp_code" default="">
<cfparam name="attributes.related_sectors" default="">
<cfparam name="attributes.related_wo" default="">
<cfparam name="attributes.licence" default="">
<cfparam name="attributes.active" default="">
<cfparam name="attributes.wo" default="0">
<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
    <cfset get_extensions = getComponent.get_extensions(keyword : attributes.keyword,
                                                        bp_code : attributes.bp_code,
                                                        related_sectors : attributes.related_sectors,
                                                        related_wo : attributes.related_wo,
                                                        licence : attributes.licence,
                                                        active : attributes.active)>
<cfelse>
    <cfset get_extensions.recordcount=0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="20">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfparam name="attributes.totalrecords" default="#get_extensions.recordcount#">
<cfsavecontent  variable="icons"><li><a href="<cfoutput>#request.self#?fuseaction=dev.tools</cfoutput>"><i class="catalyst-briefcase"></i></a></li></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfif attributes.wo eq 0>
        <cf_box>
            <cfform name="list_extensions" action="#request.self#?fuseaction=dev.extensions" method="post">
                <cf_box_search more="0">
                    <input type="hidden" name="is_submitted" id="is_submitted" value="1" />
                    <div class="form-group">
                        <cfinput type="text" name="keyword" id="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#getlang('main',48)#">
                    </div>
                    <div class="form-group">
                        <cfinput type="text" name="bp_code" id="bp_code" maxlength="50" value="#attributes.bp_code#" placeholder="WBP">
                    </div>
                    <div class="form-group">
                        <cfinput type="text" name="related_sectors" id="related_sectors" value="#attributes.related_sectors#" placeholder="Sectors">
                    </div>
                    <div class="form-group">
                        <cfinput type="text" name="related_wo" id="related_wo" value="#attributes.related_wo#" placeholder="Related WO">
                    </div>
                    <div class="form-group">
                        <select id="licence" name="licence">
                            <option value="">Licence</option>
                            <option value="1" <cfif attributes.licence eq 1>selected</cfif>>Standard</option>
                            <option value="2" <cfif attributes.licence eq 2>selected</cfif>>Add-On</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <select id="active" name="active">
                            <option value=""><cf_get_lang dictionary_id='57708.All'></option>
                            <option value="1" <cfif attributes.active eq 1>selected</cfif>>Aktif</option>
                            <option value="0" <cfif attributes.active eq 0>selected</cfif>>Pasif</option>
                        </select>
                    </div>
                    <div class="form-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#message#">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4">
                    </div>
                    <div class="form-group">
                        <a href="<cfoutput>#request.self#?fuseaction=dev.extensions&event=add</cfoutput>" class="ui-btn ui-btn-gray"><i class="fa fa-plus"></i></a>
                    </div>
                </cf_box_search>
            </cfform>
        </cf_box>
    </cfif>
    <cfif attributes.wo eq 0>
        <cf_box title="Extensions" uidrop="1" hide_table_column="1" right_images="#icons#">
            <cf_flat_list>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Extensions</th>
                        <th>WBP</th>
                        <th>Licence</th>
                        <th>WO</th>
                        <th>Author</th>
                        <th width="20"><a href="<cfoutput>#request.self#?fuseaction=dev.extensions&event=add</cfoutput>"><i class="fa fa-plus"></i></a></th>
                    </tr>
                </thead>
                
                <tbody>
                    <cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted) and get_extensions.recordcount neq 0>
                        <cfoutput query="get_extensions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" >
                            <tr>
                                <td width="20">#currentrow#</td>
                                <td>#WRK_EXTENSION_NAME#</td>
                                <td>#BEST_PRACTISE_CODE#</td>
                                <td><cfif licence_type eq 1>Standart<cfelse>Add-on</cfif></td>
                                <td>#RELATED_WO#</td>
                                <td>#AUTHOR_NAME#</td>
                                <td width="20"><a href="#request.self#?fuseaction=dev.extensions&event=upd&id=#WRK_EXTENSION_ID#"><i class="fa fa-pencil"></i></a></td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="7">
                                <cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>
                            </td>
                        </tr>
                    </cfif>
                    </tbody>
        
            </cf_flat_list>
            <cfif attributes.totalrecords gt attributes.maxrows>    
                <cfset adres="dev.extensions">
                <cfif len(attributes.is_submitted)> 
                    <cfset adres = "#adres#&is_submitted=#attributes.is_submitted#">
                </cfif>
                <cfif len(attributes.keyword)>
                    <cfset adres = "#adres#&keyword=#attributes.keyword#">
                </cfif>
                <cfif len(attributes.bp_code)>
                    <cfset adres = "#adres#&bp_code=#attributes.bp_code#">
                </cfif>
                <cfif len(attributes.active)>
                    <cfset adres = "#adres#&active=#attributes.active#">
                </cfif>
                <cfif len(attributes.licence)>
                    <cfset adres = "#adres#&licence=#attributes.licence#">
                </cfif>
                <cfif len(attributes.related_sectors)>
                    <cfset adres = "#adres#&related_sectors=#attributes.related_sectors#">
                </cfif>
                <cfif len(attributes.related_wo)>
                    <cfset adres = "#adres#&related_wo=#attributes.related_wo#">
                </cfif>
                <cf_paging 
                    page="#attributes.page#" 
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="#adres#">
            </cfif>
        </cf_box>
    <cfelse>
        <cf_flat_list>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Extensions</th>
                    <th>WBP</th>
                    <th>Licence</th>
                    <th>WO</th>
                    <th>Author</th>
                    <th width="20"><a href="<cfoutput>#request.self#?fuseaction=dev.extensions&event=add<cfif isdefined("attributes.fuseact") and len(attributes.fuseact)>&fuseact=#attributes.fuseact#</cfif></cfoutput>" target="_blank"><i class="fa fa-plus"></i></a></th>
                </tr>
            </thead>
            
            <tbody>
                <cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted) and get_extensions.recordcount neq 0>
                    <cfoutput query="get_extensions" >
                        <tr>
                            <td width="20">#currentrow#</td>
                            <td>#WRK_EXTENSION_NAME#</td>
                            <td>#BEST_PRACTISE_CODE#</td>
                            <td><cfif licence_type eq 1>Standart<cfelse>Add-on</cfif></td>
                            <td>#RELATED_WO#</td>
                            <td>#AUTHOR_NAME#</td>
                            <td width="20"><a href="#request.self#?fuseaction=dev.extensions&event=upd&id=#WRK_EXTENSION_ID#"><i class="fa fa-pencil" target="_blank"></i></a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="7">
                            <cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>
                        </td>
                    </tr>
                </cfif>
                </tbody>
    
        </cf_flat_list>
    </cfif>
</div>