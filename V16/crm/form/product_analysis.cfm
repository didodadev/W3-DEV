<cfinclude template="../query/get_company_assistance_info_list.cfm">
<table cellspacing="0" cellpadding="0" width="100%" border="0" align="center">
  <tr>
    <td class="headbold" height="35" class="color-list"><cf_get_lang no='160.Yardımcı Personel Bilgileri'></td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="100%" border="0" align="center">
  <tr class="color-list">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header" height="22">
          <td width="35"class="form-title"><cf_get_lang_main no='75.No'></td>
          <td class="form-title"><cf_get_lang_main no='158.Ad Soyad'></td>
          <td class="form-title"><cf_get_lang_main no='1085.Pozisyon'></td>
          <td class="form-title"><cf_get_lang no='281.Mal Alımındaki Etkinliği'></td>
          <td class="form-title"><cf_get_lang no='282.Depo İle İlişkileri'></td>
          <td width="15" align="center"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_add_company_assistance_info&cpid=#attributes.cpid#</cfoutput>','list');"><img src="/images/plus_square.gif" border="0" title="<cf_get_lang_main no='170.Ekle'>" ></a> </td>
        </tr>
        <cfif get_company_assistance_info_list.recordcount>
          <cfoutput query="get_company_assistance_info_list">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td>#currentrow#</td>
              <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_company_assistance_info&partner_id=#partner_id#','list')" class="tableyazi">#company_partner_name# #company_partner_surname#</a></td>
              <td>#partner_position#</td>
              <td><cfif len(get_company_assistance_info_list.purchase_authority)>
				  <cfset attributes.purchase_authority_id = get_company_assistance_info_list.purchase_authority>
				  <cfinclude template="../query/get_authority.cfm">#get_authority.authority_name#</cfif></td>

              <td><cfif len(get_company_assistance_info_list.depot_relation)>
   				  <cfset attributes.depot_relation_id = get_company_assistance_info_list.depot_relation>
				  <cfinclude template="../query/get_relation.cfm">#get_relation.partner_relation#</cfif></td>
              <td width="15" align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_company_assistance_info&partner_id=#partner_id#','list')"><img src="/images/update_list.gif" border="0" title="<cf_get_lang_main no='52.Güncelle'>"></a></td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row" height="20">
            <td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
