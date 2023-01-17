<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="0">

<cfif isDefined('attributes.is_form_submitted')>
    <cfset mail_content = createObject("component", "V16.settings.cfc.mail_company_settings")>
    <cfset get_mail_content = mail_content.SelectMailContent()/>
</cfif>

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='30837.Mailler'></cfsavecontent>
<cfform name="mailContentSearch">
    <cfinput type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
    <cf_big_list_search title="#head#">
        <cf_big_list_search_area>
            <div class="row">
                <div class="col col-3 col-md-6 col-xs-12">
                    <div class="form-group" id="item-DELIVERY_NAME">
                         <input type="text" name="DELIVERY_NAME" id="DELIVERY_NAME" value="" placeholder="<cf_get_lang_main no='48.Filtre'>">
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
        <th><cf_get_lang_main dictionary_id='58640.Şablon'><cf_get_lang_main dictionary_id='57897.Adı'></th>	
        <th><cf_get_lang_main dictionary_id='57480.Konu'></th>
        <th><cf_get_lang_main dictionary_id='57653.İçerik'></th>
        <!-- sil --><th class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_mail_companies&event=addMailContent"><img src="/images/plus_list.gif" title="<cf_get_lang_main no ='170.Ekle'>" border="0"></a></th><!-- sil -->
    </thead>
    <tbody>
        <cfif isDefined('attributes.is_form_submitted')>
            <cfif get_mail_content.recordCount>
                <cfset attributes.totalrecords = get_mail_content.recordcount>
                    <cfoutput query="get_mail_content" maxrows=#attributes.maxrows# startrow=#attributes.startrow#>
                        <tr>
                            <td style="text-align:center">#currentrow#</td>
                            <td>#DELIVERY_NAME#</td>
                            <td>#SUBJECT#</td>
                            <td>#MAIL_LIST#</td>
                            <!-- sil --><td style="text-align:center;"><a href="?fuseaction=settings.list_mail_companies&event=addMailContent&maid=#DELIVERY_ID#"><img src="/images/copy.gif" title="<cf_get_lang_main dictionary_id ='57476.Kopyala'>" border="0"></a></td><!-- sil -->
                        </tr>
                    </cfoutput>    
            <cfelse>
                <tr><td colspan="5"><cf_get_lang_main dictionary_id='57484.Kayıt Yok'></td></tr>
            </cfif>
        <cfelse>
            <tr><td colspan="5"><cf_get_lang_main dictionary_id='57701.Filtre Ediniz'></td></tr>
        </cfif>
    </tbody>
</cf_big_list>
<cfif attributes.totalrecords gt attributes.maxrows>
    <cfset url_str = "">
    <cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
		<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
	</cfif>
    <cfif isdefined("attributes.DELIVERY_NAME") and len(attributes.DELIVERY_NAME)>
        <cfset url_str = "#url_str#&DELIVERY_NAME=#attributes.DELIVERY_NAME#">
    </cfif>
        <cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#attributes.fuseaction#&#url_str#"> 
</cfif>