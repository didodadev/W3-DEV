<cfparam name="attributes.type" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">

<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">

<cfset attributes.startrow = ((attributes.page - 1) * attributes.maxrows)>
<cfif isDefined("attributes.is_form_submitted")>
    <cfobject name="inst_logs" type="component" component="#addonns#.models.logs">
    <cfset result_logs = inst_logs.get_logs(type: attributes.type, top: attributes.maxrows, skip: attributes.startrow, group: "log_id")>
    <cfset query_logs = result_logs.data>
    <cfset record_count = result_logs.count.CNT>
<cfelse>
    <cfset record_count = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#record_count#">

<cfsavecontent variable="title"><cf_get_lang dictionary_id='63665.Plevne Logları'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search" id="search" method="post">
            <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
            <cf_box_search>
                <div class="form-group" id="item-type">
                    <select name="type" id="type">
                        <option value=""><cf_get_lang dictionary_id='46850.Tümünü Göster'></option>
                        <option value="1" <cfif attributes.type eq "1">selected</cfif>>Request Logs</option>
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
                    <th><cf_get_lang dictionary_id='35792.Kaynak'></th>
                    <th><cf_get_lang dictionary_id='34215.Hata Mesajı'></th>
                    <th style="width: 200px;"><cf_get_lang dictionary_id='30631.Tarih'></th>
                </tr>
            </thead>
            <tbody>
                <cfif record_count gt 0>
                <cfoutput query="query_logs">
                <tr>
                    <td>#LOG_ID#</td>
                    <td>#SOURCE#</td>
                    <td><a href="#request.self#?fuseaction=#attributes.fuseaction#&event=det&id=#LOG_ID#" target="_blank">#MESSAGE#</a></td>
                    <td>#LOGDATE#</td>
                </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="3">
                            <cfif isDefined("attributes.is_form_submitted")>
                                <cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>
                            <cfelse>
                                <cf_get_lang dictionary_id='57701.Filtre Ediniz'>
                            </cfif>
                        </td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfset url_string = "&is_form_submitted=1">
        <cfif len(attributes.type)>
            <cfset url_string = url_string & "&type=" & attributes.type>
        </cfif>
        <cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#attributes.fuseaction##url_string#" 
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
    </cf_box>
</div>