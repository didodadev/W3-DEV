<cfparam name="attributes.mail_account" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="0">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isDefined('attributes.is_form_submitted')>
    <cfset gma = createObject("component","V16.settings.cfc.mail_accounts_settings")/>
    <cfset get_mail_account= gma.Select(mail_account:attributes.mail_account)/>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
        <cfform name="mailAccountSearch">
            <cfinput type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
            <cf_box_search>
                <div class="form-group" id="item-mail_account">
                    <input type="text" name="mail_account" id="mail_account" value="<cfoutput>#attributes.mail_account#</cfoutput>" style="height:25px;" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Mail Hesabı',51123)#" uidrop="1" hide_table_column="1">
        <cf_flat_list>
            <thead>
                <th width="30"><cf_get_lang dictionary_id='57487.no'></th>
                <th><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></th>
                <th><cf_get_lang dictionary_id='55686.E Mail Adresi'></th>
                <th><cf_get_lang dictionary_id='39718.Kota'></th>
                <th><cf_get_lang dictionary_id='44435.Aktiflik Durumu'></th>
                <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_mail_accounts&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>" alt="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th>
            </thead>
            <tbody>
                <cfif isDefined('attributes.is_form_submitted')>
                    <cfif get_mail_account.recordCount>
                        <cfset attributes.totalrecords = get_mail_account.recordcount>
                        <cfoutput query="get_mail_account" maxrows=#attributes.maxrows# startrow=#attributes.startrow#>
                            <tr>
                                <td style="text-align:center">#currentrow#</td>
                                <td>#MAIL_ACCOUNT#</td>
                                <td>#EMAIL_ADRESS#</td>
                                <td>#MAIL_ACCOUNT_QUOTA#</td>
                                <td><cfif get_mail_account.IS_ACTIVE eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                                <td style="text-align:center;"><a href="#request.self#?fuseaction=settings.list_mail_accounts&event=upd&maid=#MAIL_ACCOUNT_ID#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>" alt="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></td>
                            </tr>
                        </cfoutput>    
                    <cfelse>
                        <tr><td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td></tr>
                    </cfif>
                <cfelse>
                    <tr><td colspan="6"><cf_get_lang dictionary_id='57701.Filtre Ediniz'></td></tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfset url_str = "">
            <cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
                <cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
            </cfif>
            <cfif isdefined("attributes.mail_account") and len(attributes.mail_account)>
                <cfset url_str = "#url_str#&mail_account=#attributes.mail_account#">
            </cfif>
            <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#attributes.fuseaction#&#url_str#"> 
        </cfif>
    </cf_box>
</div>
