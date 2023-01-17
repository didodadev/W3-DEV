<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfparam name="attributes.type" default="">
<cfparam name="attributes.kind" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfif not len(attributes.type) or not len(attributes.kind)>
    Hatalı bir ekrandan geliyorsunuz!
    <cfexit>
</cfif>

<cfif isDefined("attributes.is_form_submitted")>
    <cfif attributes.type eq plevne_process_types.EXPRESSION>
        <cfobject name="inst_expression_categories" type="component" component="#addonns#.domains.expression_categories">
        <cfset query_list = inst_expression_categories.get_expression_categories(expression_kind: attributes.kind, title: attributes.keyword)>
        <cfset id_column = "EXPRESSION_CATEGORY_ID">
    <cfelseif attributes.type eq plevne_process_types.INTERCEPTOR>
        <cfobject name="inst_interceptor_categories" type="component" component="#addonns#.domains.interceptor_categories">
        <cfset query_list = inst_interceptor_categories.get_interceptor_categories(interceptor_kind: attributes.kind, title: attributes.keyword)>
        <cfset id_column = "INTERCEPTOR_CATEGORY_ID">
    </cfif>
<cfelse>
    <cfset query_list = { recordcount: 0 }>
</cfif>

<cfparam name="attributes.totalrecords" default="#query_list.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset url_string = "&type=#attributes.type#">
<cfset url_string &= "&kind=#attributes.kind#">

<cf_box title="#getLang(dictionary_id: "63533")#" scroll="1" collapsable="1" resize="1" popup_box="1">
    <cfform name="search_form" id="search_form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction##url_string#">
    <cf_wrk_alphabet keyword="url_string" popup_box="1">
    <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1" />
    <cf_box_search>
        <div class="form-group" id="item-keyword">
            <input type="text" name="keyword" value="<cfset writeOutput(attributes.keyword)>">
        </div>
        <div class="form-group" id="item-search_button">
            <cf_wrk_search_button button_type="4" is_excel="0" search_function="loadPopupBox('search_form' , #attributes.modal_id#)">
        </div>
    </cf_box_search>
    </cfform>

    <cf_flat_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='58233.Tanım'></th>
                <th style="width: 100px;"><cf_get_lang dictionary_id="57756.Durum"></th>
            </tr>
        </thead>
        <tbody>
            <cfif attributes.totalrecords>
            <cfoutput query="query_list">
            <tr>
                <td><a href="javascript:void(0)" onclick="setRelation(#evaluate("#id_column#")#, '#TITLE#');closeBoxDraggable('#attributes.modal_id#')">#TITLE#</td>
                <td><cfif status eq "1"><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
            </tr>
            </cfoutput>
            <cfelse>
            <tr>
                <cfif isDefined("attributes.is_form_submitted")>
                <td colspan="2"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'></td>
                <cfelse>
                <td colspan="2"><cf_get_lang dictionary_id='57701.Filtre Ediniz'></td>
                </cfif>
            </tr>
            </cfif>
        </tbody>
    </cf_flat_list>
</cf_box>