<!---
File: assurance_type.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date: 22.11.2019
Controller: AssuranceTypesController.cfm
Description: Sağlık Teminatı Tipi listele sayfasıdır.
--->
<cfset components = createObject('component','V16.hr.cfc.assurance_type')>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset adres = url.fuseaction>
<cfif len(attributes.keyword)><cfset adres = "#adres#&keyword=#attributes.keyword#"></cfif>
<cfif len(attributes.is_active)><cfset adres = "#adres#&is_active=#attributes.is_active#"></cfif>
<cfset get_assurance = components.GET_HEALTH_ASSURANCE_TYPE(keyword : attributes.keyword, is_active : attributes.is_active, startrow:attributes.startrow, maxrows:attributes.maxrows)>
<cfparam name="attributes.totalrecords" default='#get_assurance.QUERY_COUNT#'>
<cfset address = "">
<cfsavecontent variable="title"><cf_get_lang dictionary_id="34119.Sağlık güvence tipler"></cfsavecontent>
<cf_box id="assurance_type_box" closable="0" collapsable="0">
    <cfform name="assurance_type" method="post" action="">
        <cf_box_search plus="0">
            <div class="form-group">
                <input type="text" name="keyword" id="keyword"  placeholder="<cf_get_lang dictionary_id='57460.Filtre'>" value="<cfoutput>#attributes.keyword#</cfoutput>">
            </div>
            <div class="form-group">
                <select id = "is_active" name = "is_active">
                    <option value = "1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id = "57493.Aktif"></option>
                    <option value = "2" <cfif attributes.is_active eq 2>selected</cfif>><cf_get_lang dictionary_id = "57494.Pasif"></option>
                    <option value = "3" <cfif attributes.is_active eq 3>selected</cfif>><cf_get_lang dictionary_id = "57708.Tümü"></option>
                </select>
            </div>
            <div class="form-group small">
                <input type="text" name="maxrows" id="maxrows" value="<cfoutput>#attributes.maxrows#</cfoutput>">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
            </div>        
        </cf_box_search>
    </cfform>
</cf_box>
<cf_box id="list_assurance_type_box" closable="0" collapsable="1" title="#title#"  add_href="#request.self#?fuseaction=health.assurance_types&event=add"> 
    <cf_grid_list>
        <thead>
            <tr>
                <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                <th><cf_get_lang dictionary_id='35333.Teminat Adı'></th>
                <th><cf_get_lang dictionary_id='43121.Kayıt Eden'></th>
                <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
            </tr>
        </thead>
        <cfif get_assurance.recordcount>
            <cfoutput query="get_assurance">
                <tbody>
                    <tr>
                        <td>#attributes.startrow + currentRow - 1#</td>
                        <td><a href="#request.self#?fuseaction=health.assurance_types&event=upd&assurance_id=#assurance_id#" target = "_blank" style="color:blue">#ASSURANCE_NEW#</a></td> 
                        <td>#get_emp_info(RECORD_EMP,0,1)#</td>
                        <td>#dateFormat(record_date,dateformat_style)#</td>
                    </tr>
                </tbody>
            </cfoutput>
        <cfelse>
            <tbody>
                <tr>
                    <td colspan="3"><cf_get_lang dictionary_id ="57484. kayıt yok"></td>
                </tr>
            </tbody>
        </cfif>
    </cf_grid_list>
    <cfif attributes.totalrecords gt attributes.maxrows>
        <cf_paging 
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#&is_form_submitted=1">
    </cfif>
</cf_box>