
<cfset cfc= createObject("component","V16.objects.cfc.get_meta_desc")>
<cfset get_meta_desc=cfc.GetMetaDescList(action_id:attributes.action_id,action_type:attributes.action_type)>
<cf_flat_list>
    <tbody>
        <cfoutput query="get_meta_desc">
            <tr>
                <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_upd_meta_desc&meta_desc_id=#meta_desc_id#','','ui-draggable-box-small')">#DecodeForHTML(meta_title)# - (#DecodeForHTML(language_set)#)</a></td>
                <td class="text-right">#dateformat(record_date,dateformat_style)#</td>
            </tr>
        </cfoutput>
        <cfif not get_meta_desc.recordcount>
            <cfoutput>
            <tr>
                <td><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
            </tr>
            </cfoutput>
        </cfif>
    </tbody>
</cf_flat_list>
