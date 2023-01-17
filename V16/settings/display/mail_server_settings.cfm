<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="0">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isDefined('attributes.is_form_submitted')>
    <cfset gms = createObject("component","V16.settings.cfc.mail_server_settings")/>
    <cfset get_mail_server= gms.Select(keyword:attributes.keyword)/>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="mailServerSearch">
            <cfinput type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" autocomplete="off" value="#attributes.keyword#" maxlength="50" style="width:50px;" placeholder="#getLang(48,'Filtre',57460)#">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray"  onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_mail_server_settings&event=add')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a>
                </div>
            </cf_box_search> 
        </cfform>
    </cf_box>

    <cf_box title="#getLang('','Mail Sunucu Ayarları','44098')#" uidrop="1" hide_table_column="1" > 
        <cf_CatalystHeader>
        <cf_flat_list>
            <thead>
                <tr>
                    <th class="text-center" width="30"><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='51238.Sunucu'><cf_get_lang dictionary_id='57897.Adı'></th>
                    <!-- sil --><th width="30"><a onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_mail_server_settings&event=add')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>" ></i></a></th><!-- sil -->
                </tr>
            </thead>  
            <tbody>
                <cfif isDefined('attributes.is_form_submitted')>
                    <cfif get_mail_server.recordCount>
                        <cfset attributes.totalrecords = get_mail_server.recordcount>
                        <cfoutput query="get_mail_server" maxrows=#attributes.maxrows# startrow=#attributes.startrow#>
                            <tr>
                                <td class="text-center">#currentrow#</td>
                                <td>#SERVER_NAME#</td>
                                <!-- sil --><td width="30"><a href="javascript:openBoxDraggable('#request.self#?fuseaction=settings.list_mail_server_settings&event=upd&cpid=#SERVER_NAME_ID#')" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></td><!-- sil -->
                            </tr>          
                        </cfoutput>    
                        <cfelse>
                            <tr><td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td></tr>
                    </cfif>
                <cfelse>
                    <tr><td colspan="4"><cf_get_lang dictionary_id='57701.Filtre Ediniz'></td></tr>
                </cfif>
            </tbody>
        </cf_flat_list> 
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfset url_str = "">
            <cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
                <cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
            </cfif>
            <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>
                <cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#attributes.fuseaction#&#url_str#"> 
        </cfif>
    </cf_box> 
</div>

