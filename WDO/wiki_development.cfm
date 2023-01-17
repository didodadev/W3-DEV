<cf_xml_page_edit>
<cf_catalystHeader>
    <cfset getComponent = createObject('component','WDO.development.cfc.wiki_development')>
    <cfset GET_CONTENT_CHAPTER = getComponent.get_chapter(content_cat:'#iif((isDefined("content_cat_id") and len(content_cat_id)),"content_cat_id",DE(""))#')>
    <cfset GET_CONTENT_STAGE = getComponent.get_stage(content_cat:'#iif((isDefined("content_cat_id") and len(content_cat_id)),"content_cat_id",DE(""))#')>
    <cfset GET_CONTENT_LANG = getComponent.get_language(content_cat:'#iif((isDefined("content_cat_id") and len(content_cat_id)),"content_cat_id",DE(""))#')>
    
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('dictionary_id','Wiki İçerikleri',65339)#" uidrop="1">
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
            <cf_grid_list sort="1">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='57995.Bölüm'></th>
                        <th width="50"><cf_get_lang dictionary_id='57493.Aktif'></th>
                        <th width="50"><cf_get_lang dictionary_id='57494.Pasif'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="GET_CONTENT_CHAPTER">
                        <tr>
                            <td>#CHAPTER#</td>
                            <td class="text-right">#ACTIVE_TOTAL#</td>
                            <td class="text-right">#PASSIVE_TOTAL#</td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
            <cfif GET_CONTENT_CHAPTER.recordcount eq 0>
                <div class="ui-info-bottom">
                    <p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</p>
                </div>
            </cfif>
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
            <cf_grid_list sort="1">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                        <th width="50"><cf_get_lang dictionary_id='57493.Aktif'></th>
                        <th width="50"><cf_get_lang dictionary_id='57494.Pasif'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="GET_CONTENT_STAGE">
                        <tr>
                            <td>#STAGE#</td>
                            <td class="text-right">#ACTIVE_TOTAL#</td>
                            <td class="text-right">#PASSIVE_TOTAL#</td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
            <cfif GET_CONTENT_STAGE.recordcount eq 0>
                <div class="ui-info-bottom">
                    <p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</p>
                </div>
            </cfif>
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
            <cf_grid_list sort="1">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58996.Dil'></th>
                        <th width="50"><cf_get_lang dictionary_id='57493.Aktif'></th>
                        <th width="50"><cf_get_lang dictionary_id='57494.Pasif'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="GET_CONTENT_LANG">
                        <tr>
                            <td>#language_set#</td>
                            <td>#ACTIVE_TOTAL#</td>
                            <td>#PASSIVE_TOTAL#</td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
            <cfif GET_CONTENT_LANG.recordcount eq 0>
                <div class="ui-info-bottom">
                    <p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</p>
                </div>
            </cfif>
        </div>
    </cf_box>
    <cf_box title="#getLang('dictionary_id','WO Linked Wiki',65340)#" uidrop="1" box_page="#request.self#?fuseaction=dev.dsp_linked_wiki" id="div1"></cf_box>
</div>
    
    