<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="1">
<cfif isdefined("attributes.form_submitted")>
	<cfset wrk = createObject("component","V16.worknet.cfc.worknet")>
    <cfset get_all_worknet = wrk.select(
        keyword             :   attributes.keyword,
        status     :   attributes.status
    )>
<cfelse> 
	<cfset get_all_worknet.recordcount = 0>
</cfif> 
<cfparam name="attributes.totalrecords" default='#get_all_worknet.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfform name="list_worknet" id="list_worknet" method="post" action="">
    <input type="hidden" name="form_submitted" id="form_submitted" value="1">
    <cfsavecontent  variable="title"><cf_get_lang dictionary_id='61344.Pazaryerleri'></cfsavecontent>
    <cf_box id="list_worknet_search" closable="0" collapsable="0">
        <cf_box_search plus="0">
            <div class="form-group" id="form_ul_keyword">
                <div class="input-group x-12">
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" style="width:100px;" placeholder="#getLang('main',48)#">
                </div>
            </div>
            <div class="form-group" id="form_ul_status">
                <div class="input-group">
                    <select name="status" id="status">
                        <option value="1" <cfif isdefined("attributes.status") and attributes.status eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                        <option value="2" <cfif isdefined("attributes.status") and attributes.status eq 2>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                        <option value="3" <cfif isdefined("attributes.status") and attributes.status eq 3>selected</cfif>><cf_get_lang_main no ='296.Tümü'></option>
                    </select>                  
                </div>
            </div>
            <div class="form-group" id="form_ul_maxrows">
                <div class="input-group x-3_5">
                <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
                </div>
            </div>
            <div class="form-group" id="form_ul_search">
                <div class="input-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </div>
            <div class="form-group" id="form_ul_add">
                <a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.list_worknet&event=add"><i class="fa fa-plus" title = "<cf_get_lang dictionary_id ='44630.Ekle'>" alt="<cf_get_lang dictionary_id ='44630.Ekle'>"></i></a>						
            </div>
        </cf_box_search>
    </cf_box>
</cfform>

<cf_box id="list_worknet_list" closable="0" collapsable="0" title="#title#" add_href="#request.self#?fuseaction=worknet.list_worknet&event=add"> 
    <cf_grid_list>
        <thead>
            <tr>
                <th style="width:15px;"></th>
                <th><cf_get_lang dictionary_id='58158.Pazaryeri'></th>
                <th><cf_get_lang dictionary_id='58637.Logo'></th>
                <th><cf_get_lang dictionary_id='57574.Şirket'></th>
                <th><cf_get_lang dictionary_id='29761.URL'></th>
                <th><cf_get_lang dictionary_id='52748.Status'></th>
                <th width="20"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.list_worknet&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a></th>
            </tr>       
        </thead>
        <tbody>
            <cfif attributes.totalrecords>
                <cfoutput query="get_all_worknet" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#WORKNET#</td>
                        <td style="width:52px;" align="center">
                            <cfif len(get_all_worknet.IMAGE_PATH)>
                                <cf_get_server_file output_file="asset/watalogyImages/#IMAGE_PATH#" output_server="#SERVER_IMAGE_PATH_ID#" output_type="0" image_width="30" image_height="30">
                            <cfelse>
                                <img src="/images/no_photo.gif" width="30" height="30">
                            </cfif>
                        </td>
                        <td><a href="#request.self#?fuseaction=worknet.form_list_company&event=upd&cpid=#company_id#">#FULLNAME#</a></td>
                        <td><a class="fa fa-link" href="#WEBSITE#" title="#WEBSITE#"></a></td>
                        <td <cfif #WORKNET_STATUS# eq 1>style="color:green;" title="<cf_get_lang_main no='81.Aktif'>"<cfelseif #WORKNET_STATUS# eq 0>style="color:red;" title="<cf_get_lang_main no='82.Pasif'>"</cfif>>
                            <cfif #WORKNET_STATUS# eq 1>
                                <cf_get_lang_main no='81.Aktif'>
                            <cfelseif #WORKNET_STATUS# eq 0>
                                <cf_get_lang_main no='82.Pasif'>
                            </cfif>
                        </td>
                        <td>
                            <a href="#request.self#?fuseaction=worknet.list_worknet&event=upd&wid=#WORKNET_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                        </td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '>!</cfif></td>
                </tr>
            </cfif>
        </tbody>
    </cf_grid_list>
</cf_box>

<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif isdefined("attributes.form_submitted")>
		<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
	</cfif>
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif> 
	<cfif len(attributes.status)>
		<cfset url_str = "#url_str#&status=#attributes.status#">
	</cfif> 
    <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="worknet.list_worknet#url_str#&form_submitted=#attributes.form_submitted#">
		
</cfif>
<script type="text/javascript">
    document.getElementById('keyword').focus();
</script>