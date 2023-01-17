<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.kind" default="1">
<cfparam name="attributes.status" default="">

<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfif isDefined("attributes.is_form_submitted")>
    <cfobject name="inst_expression_categories" type="component" component="#addonns#.domains.expression_categories">
    <cfset query_exp_cats = inst_expression_categories.get_expression_categories(title: attributes.keyword, status: attributes.status, expression_kind: attributes.kind)>
<cfelse>
    <cfset query_exp_cats = { recordcount: 0 }>
</cfif>
<cfparam name="attributes.totalrecords" default="#query_exp_cats.recordcount#">
<div class="col col-12">
    <cfoutput>
    <cf_box>
        <cfform name="search" id="search" method="post">
            <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
            <cf_box_search>
                <div class="form-group" id="item-keyword">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <input type="text" placeholder="#message#" name="keyword" value="#attributes.keyword#">
                </div>
                <div class="form-group" id="item-kind">
                    <select name="kind" id="kind">
                        <option value="#plevne_kinds.REQUEST_FILTER#" <cfif attributes.kind eq plevne_kinds.REQUEST_FILTER>selected</cfif>>Request Filter</option>
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
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='63532.Expression Kategorisi'></cfsavecontent>
    <cf_box title="#title#" uidrop="1">
        <cf_flat_list>
            <thead>
                <th style="text-align: center; width: 20px;"><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='58233.Tanım'></th>
                <th style="width: 60px;"><cf_get_lang dictionary_id='57756.Durum'></th>
                <th style="width: 60px;"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=plevne.expressioncategory&event=add');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a></th>
            </thead>
            <tbody>
                <cfif attributes.totalrecords gt 0>
                    <cfoutput query="query_exp_cats">
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=plevne.expressioncategory&event=det&id=#expression_category_id#" class="tbl-yazi">#title#</a></td>
                            <td><cfif status eq "1"><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                            <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=plevne.expressioncategory&event=upd&id=#expression_category_id#');"> <i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        </tr> 
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="4">
                            <cfif isDefined("attributes.is_form_submitted")>
                                <cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>
                            <cfelse>
                                <cf_get_lang dictionary_id='57701.Filtre Ediniz'>
                            </cfif>
                        </td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>