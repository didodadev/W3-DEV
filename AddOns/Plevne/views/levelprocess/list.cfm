<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">
<cfinclude template="../../infrastructure/helpers.cfm" runonce="true">

<cfparam name="attributes.kind" default="">

<cfif isDefined("attributes.is_form_submitted")>
    <cfset level_process = createObject("component", "#addonns#.models.level_process")>
    <cfset query_level_process = level_process.list_process(process_kind: attributes.kind)>
<cfelse>
    <cfset query_level_process = arrayNew(1)>
</cfif>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='63530.Plevne İşlem Sınıflandırma'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search" id="search" method="post">
            <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
            <cf_box_search>
                <div class="form-group" id="item-kind">
                    <select name="kind" id="kind">
                        <option value=""><cf_get_lang dictionary_id='46850.Tümünü Göster'></option>
                        <option value="<cfset writeOutput(plevne_kinds.REQUEST_FILTER)>">Request Filter</option>
                        <option value="<cfset writeOutput(plevne_kinds.UPLOAD_CONTROL)>">Upload Control</option>
                    </select>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button search_function='' button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#title#" uidrop="1">
        <cf_grid_list>
            <thead>
                <tr>
                <th style="text-align: center; width: 20px;"><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='50161.İşlem Türü'></th>
                <th><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
                <th><cf_get_lang dictionary_id='35377.İşlem Adı'></th>
                <th class="header_icn_none text-center" style="width: 60px;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=plevne.levelprocess&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>" alt="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif arrayLen(query_level_process) gt 0>
                    <cfoutput>
                    <cfloop array="#query_level_process#" item="e" index="i">
                    <tr>
                        <td>#i#</td>
                        <td>#structKeyByValue(plevne_kinds, e.PROCESS_KIND)#</td>
                        <td>#structKeyByValue(plevne_process_types, e.PROCESS_TYPE)#</td>
                        <td>#e.TITLE#</td>
                        <td><a href="#request.self#?fuseaction=plevne.levelprocess&event=upd&id=#e.LEVEL_PROCESS_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></td>
                    </tr>
                    </cfloop>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="5">
                            <cfif isDefined("attributes.is_form_submitted")>
                                <cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>
                            <cfelse>
                                <cf_get_lang dictionary_id='57701.Filtre Ediniz'>
                            </cfif>
                        </td>
                    </tr>
                </cfif>
            </tbod>
        </cf_grid_list>
    </cf_box>
</div>
