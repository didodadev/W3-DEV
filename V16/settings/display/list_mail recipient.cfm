<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="0">

<cfif isDefined('attributes.is_form_submitted')>
    <cfset mail_recipient_list = createObject("component", "V16.settings.cfc.mail_company_settings")>
    <cfset get_mail_recipient_list = mail_recipient_list.SelectRecipientList()/>
</cfif>

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='38340.Mail Gönderim Listesi'></cfsavecontent>
<cfform name="mailRecipientList">
    <cfinput type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
    <cf_big_list_search title="#head#">
        <cf_big_list_search_area>
            <div class="row">
                <div class="col col-3 col-md-6 col-xs-12">
                    <div class="form-group" id="item-mail_account">
                         <input type="text" name="LIST_NAME" id="LIST_NAME" value="" placeholder="<cf_get_lang_main no='48.Filtre'>">
                    </div>
                </div>
                <div class="col col-3 col-md-6 col-xs-12">
                    <div class="col col-6">
                        <div class="form-group">
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <div class="col col-4">
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
                            </div>
                            <div class="col col-2">
                                <cf_wrk_search_button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cf_big_list>
    <thead>
        <th style="width:25px; text-align:center"><cf_get_lang_main no='75.no'></th>
        <th><cf_get_lang_main dictionary_id='58733.Alıcı'><cf_get_lang_main dictionary_id='30467.Listesi'><cf_get_lang_main dictionary_id='57897.Adı'></th>	
        <!-- sil --><th class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_mail_companies&event=addMailRecipient"><img src="/images/plus_list.gif" title="<cf_get_lang_main no ='170.Ekle'>" border="0"></a></th><!-- sil -->
    </thead>
    <tbody>
        <cfif isDefined('attributes.is_form_submitted')>
            <cfif get_mail_recipient_list.recordCount>
                <cfset attributes.totalrecords = get_mail_recipient_list.recordcount>
                <cfoutput query="get_mail_recipient_list" maxrows=#attributes.maxrows# startrow=#attributes.startrow#>
                    <tr>
                        <td style="text-align:center">#currentrow#</td>
                        <td>#LIST_NAME#</td>
                        <!-- sil --><td style="text-align:center;"><a href="<!--- #request.self#?fuseaction=settings.list_mail_companies&event=updMailTemplate&tid=#TEMPLATE_ID# --->" class="tableyazi"><img src="/images/update_list.gif" title="<cf_get_lang_main no ='52.Güncelle'>" border="0"></a></td><!-- sil -->
                    </tr>
                </cfoutput>
            <cfelse>
                <tr><td colspan="3"><cf_get_lang_main dictionary_id='57484.Kayıt Yok'>!</td></tr>
            </cfif>
        <cfelse>
            <tr><td colspan="3"><cf_get_lang_main dictionary_id='57701.Filtre Ediniz'></td></tr>
        </cfif>
    </tbody>
</cf_big_list>
<cfif attributes.totalrecords gt attributes.maxrows>
    <cfset url_str = "">
    <cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
		<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
	</cfif>
    <cfif isdefined("attributes.LIST_NAME") and len(attributes.LIST_NAME)>
        <cfset url_str = "#url_str#&LIST_NAME=#attributes.LIST_NAME#">
    </cfif>
        <cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#attributes.fuseaction#&event=listTemplates#url_str#"> 
</cfif>