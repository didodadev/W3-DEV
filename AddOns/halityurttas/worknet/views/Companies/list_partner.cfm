<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
    <cfinclude template="../../config.cfm">
    <cfsetting showdebugoutput="no">
    <cfif isdefined("is_active") and is_active eq 1>
        <cfparam name="attributes.partner_status" default="1">
    <cfelseif isDefined("is_active") and len(is_active)>
        <cfparam name="attributes.partner_status" default="0"> 
    <cfelse>
        <cfparam name="attributes.partner_status" default="">
    </cfif>
    <cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.companies.member") />
    <cfset get_Partner = cmp.getPartner(company_id:attributes.cpid,partner_status:attributes.partner_status) />
    <table class="ajax_list">
        <cfform name="form_partner" method="post" action="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['list-partner']['fuseaction']#&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#&is_active=#attributes.partner_status#">
        <tr>
            <th colspan="8" align="right" style="text-align:right;">
                <select name="partner_status" id="partner_status" style="width:60px;">
                    <option value=""><cf_get_lang_main no='296.Tümü'></option>
                    <option value="1" <cfif attributes.partner_status eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                    <option value="0" <cfif attributes.partner_status eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                </select>
                <input type="button" value="<cf_get_lang_main no='153.Ara'>" onClick="connectAjax_partner();">
            </th>
        </tr>
        </cfform>
         <tr>
            <th width="21"></th>
            <th><cf_get_lang_main no='158.Ad Soyad'></th>
            <th><cf_get_lang_main no='41.Şube'></th>
            <th><cf_get_lang_main no='161.Gorev'></th>
            <th><cf_get_lang_main no='160.Departman'></th>
            <th><cf_get_lang_main no='159.Ünvan'></th>
            <th><cf_get_lang_main no='731.İletişim'></th>
            <th width="50"><cf_get_lang_main no='344.Durumu'></th>
        </tr>
        <cfif get_partner.recordcount>
          <cfoutput query="get_partner">
            <tr <cfif company_partner_status eq 0>style="color:999999;"</cfif>>
                <td width="21"><cf_online id="#partner_id#" zone="pp"></td>
                <td><a href="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['det-partner']['fuseaction']##partner_id#&cpid=#attributes.cpid#" <cfif company_partner_status eq 0>style="color:999999;"<cfelse>class="tableyazi"</cfif>>#company_partner_name# #company_partner_surname#</a></td>
                <td><cfif (compbranch_id eq 0) or not len(compbranch_id)>
                       <cf_get_lang no='181.Merkez Ofis'>
                    <cfelse>
                        #compbranch__name#
                    </cfif>
                </td>
                <td>#PARTNER_POSITION#</td>
                <td>#PARTNER_DEPARTMENT#</td>
                <td>#title#</td>
                <td><cfif len(company_partner_email)><a href="mailto:#company_partner_email#"><img src="/images/mail.gif" title="E-mail:#company_partner_email#" border="0"></a></cfif>
                    <cfif len(company_partner_tel)>&nbsp; <img src="/images/tel.gif" title="Tel:#company_partner_tel#" border="0"></cfif>
                    <cfif len(company_partner_fax)>&nbsp; <img src="/images/fax.gif" title="Fax:#company_partner_fax#" border="0"></cfif>
                    <cfif len(mobiltel) and (session.ep.our_company_info.sms eq 1)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=partner&member_id=#PARTNER_ID#&sms_action=#fuseaction#','small','popup_form_send_sms');"><img src="/images/mobil.gif" border="0" title="<cf_get_lang_main no ='1178 .SMS Gönder'>:#mobil_code#-#mobiltel#"></a></cfif>
                </td>
                <td><cfif get_partner.company_partner_status eq 1><cf_get_lang_main no='81.Aktif'><cfelse><font color="999999"><cf_get_lang_main no='82.Pasif'></font></cfif></td>
            </tr>
          </cfoutput>
        <cfelse>
            <tr>
                <td colspan="6"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
            </tr>
        </cfif>
        <div style="width:300px;display:none;" id="show_partner_message"></div>
    </table>
    <script type="text/javascript">
        function connectAjax_partner()
        {	
            AjaxFormSubmit(form_partner,'show_partner_message',0,' ',' ','<cfoutput>#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['list-partner']['fuseaction']#&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#&is_active=</cfoutput>' + $("#partner_status").val(),'body_list_company_partner');
        }
    </script>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
    