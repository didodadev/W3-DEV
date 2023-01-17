<cfparam name="attributes.type" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="">

<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfif isDefined("attributes.is_form_submitted")>
    <cfobject name="inst_responses" type="component" component="#addonns#.domains.responses">
    <cfset query_responses = inst_responses.get_responses(type: attributes.type, header: attributes.keyword, status: attributes.status)>
<cfelse>
    <cfset query_responses = { recordcount: 0 }>
</cfif>
<cfparam name="attributes.totalrecords" default="#query_responses.recordcount#">
<div class="col col-12">
    <cfoutput>
    <cf_box>
        <cfform name="search" id="search" method="post">
            <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
            <cf_box_search>
                <div class="form-group" id="item-keyword">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
                    <input type="text" placeholder="#message#" name="keyword" value="#attributes.keyword#">
                </div>
                <div class="form-group" id="item-type">
                    <select name="type" id="type">
                        <option value="# plevne_response_types.HEADER#" <cfif attributes.type eq  plevne_response_types.HEADER>selected</cfif>>Header</option>
                    </select>
                </div>
                <div class="form-group" id="item-status">
                    <select name="status" id="status">
                        <option value="1" <cfif attributes.status eq "1">selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif attributes.status eq "0">selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                    </select>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button search_function='' button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    </cfoutput>
    
    <cf_box title="Responses" uidrop="1">
        <cf_grid_list>
        <thead>
            <tr>
                <th style="text-align: center; width: 20px;"><cf_get_lang dictionary_id='57487.no'></th>
                <th>Response</th>
                <th style="width: 100px;"><cf_get_lang dictionary_id="57756.Durum"></th>
                    <th class="header_icn_none text-center" style="width: 60px;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=plevne.response&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>" alt="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th>
            </tr>
        </thead>
        <tbody>
            <cfif attributes.totalrecords gt 0>
            <cfoutput query="query_responses">
            <tr>
                <td>#currentrow#</td>
                <td>#HEADER#</td>
                <td><cfif status eq "1"><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                <td><a href="#request.self#?fuseaction=plevne.response&event=upd&id=#response_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></td>
            </tr>
            </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="4">
                        <cfif isDefined("attributes.is_form_submitted")>
                            <cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>
                        <cfelse>
                            <cf_get_lang dictionary_id='57701.Filtre Ediniz '>
                        </cfif>
                    </td>
                </tr>
            </cfif>
        </tbody>
        </cf_grid_list>
    </cf_box>

</div>
