<cfinclude template="../query/get_branch_partner.cfm">
<cf_ajax_list>
    <thead>
        <tr>
            <th width="21">&nbsp;</th>
            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th width="75"><cf_get_lang dictionary_id='57571.Ünvan'></th>
            <th width="125"><cf_get_lang dictionary_id='58143.İletişim'></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_branch_partner.recordcount>
            <cfoutput query="get_branch_partner">
            <tr>
                <td width="25"><cf_online id="#partner_id#" zone="pp"></td>
                <td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company&event=updPartner&pid=#partner_id#" class="tableyazi">#company_partner_name# #company_partner_surname#</a></td>
                <td>#title#</td>
                <td><cfif len(company_partner_email)><a href="mailto:#company_partner_email#"><img src="/images/mail.gif" title="E-mail:#company_partner_email#" border="0"></a></cfif>
                    <cfif len(company_partner_tel)>&nbsp;<img src="/images/tel.gif" title="Tel:#company_partner_tel#" border="0"></cfif>
                    <cfif len(company_partner_fax)>&nbsp;<img src="/images/fax.gif" title="Fax:#company_partner_fax#" border="0"></cfif>
                    <cfif len(mobiltel) and (session.ep.our_company_info.sms eq 1)>&nbsp;<img src="/images/mobil.gif" title="Mobil:#mobiltel#" border="0"></cfif>
                </td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_ajax_list>
