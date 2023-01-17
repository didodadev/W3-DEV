<table width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='194.Kullanıcı Kısıtları'></td>
    <td>&nbsp;</td>
  </tr>
</table>
      <table width="98%" height="100%" border="0" cellpadding="2" cellspacing="1" class="color-border" align="center">
	    <cfform name="add_faction" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_perm_faction">
        <tr class="color-row">
          <td width="280" valign="top">
            <table>
              <tr>
                <td><cf_get_lang no='195.Modül'></td>
                <td><cf_get_lang_main no='169.Sayfa'></td>
                <td></td>
              </tr>
              <tr>
                <td>
                  <input type="text" name="modul_name" id="modul_name" value="" style="width:100px;">
                </td>
                <td>
                  <input type="text" name="faction" id="faction" value="" style="width:160px;">
                  <input type="hidden" name="faction_id" id="faction_id" value="">
                </td>
                <td>
				  <cfif not listfindnocase(denied_pages,'settings.popup_faction_list')>
					<a href="#" onClick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_faction_list&field_faction_id=add_faction.faction_id&field_faction=add_faction.faction&field_modul=add_faction.modul_name</cfoutput>','medium');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='193.Fuseaction Ekle'>" border="0"></a>
				  </cfif>
				</td>
              </tr>
              <tr>
                <td colspan="3">
                  <input type="checkbox" name="is_view_" id="is_view_" value="">
                  Is_View: <cf_get_lang no='151.Göremez'></td>
              </tr>
              <tr>
                <td colspan="3">
                  <input type="checkbox" name="is_insert_" id="is_insert_" value="">
                  Is_Insert: <cf_get_lang no='152.Ekleyemez-Değiştiremez'></td>
              </tr>
              <tr>
                <td colspan="3">
                  <input type="checkbox" name="is_delete_" id="is_delete_" value="">
                  Is_Delete: <cf_get_lang no='153.Silemez'></td>
              </tr>
            </table>
          </td>
          <td valign="top">
            <table cellspacing="1" cellpadding="2" width="100%" border="0">
              <tr class="color-header">
                <td height="20" class="form-title"><cf_get_lang_main no='367.Pozisyon Tipleri'></td>
                 
                <td class="form-title" width="10"> <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_list_emps_cats&field_id1=add_faction.field_id1&field_td1=field_td1</cfoutput>','medium');"><img src="/images/plus_square.gif" alt="<cf_get_lang no='196.Pozisyon Kategorisi Ekle'>" border="0"></a></td>
              </tr>
              <tr>
                <input type="hidden" name="field_id1" id="field_id1" value="">
                <td colspan="2" id="field_td1">
                  <cfif isdefined("field_id1") and len(field_id1)>
                    <cfloop list="field_id1" index="i" delimiters=",">
                      <cfquery name="ps_name" datasource="#dsn#">
                      SELECT POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID
                      = #i#
                      </cfquery>
                      <cfoutput>#ps_name.POSITION_CAT#**</cfoutput>
                    </cfloop>
                  </cfif>
                </td>
              </tr>
            </table>
          </td>
          <td valign="top">
            <table cellspacing="1" cellpadding="2" width="100%" border="0">
              <tr class="color-header">
                <td height="20" class="form-title" ><cf_get_lang no='13.Pozisyonlar'></td>
                <td class="form-title" width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_list_emps&field_id=add_faction.field_id&field_td=field_td</cfoutput>','medium');"><img src="/images/plus_square.gif" alt="<cf_get_lang no='197.Pozisyon Ekle'>" border="0"></a></td>
              </tr>
              <tr>
                <input type="hidden" name="field_id" id="field_id" value="">
                <td colspan="2" id="field_td">
                  <cfif isdefined("field_id") and len(field_id)>
                    <cfloop list="#field_id#" index="i" delimiters=",">
                      <cfquery name="get_pos_name" datasource="#dsn#">
                      SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM
                      EMPLOYEE_POSITIONS WHERE POSITION_CODE = #i#
                      </cfquery>
                      <cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_pos_name.EMPLOYEE_ID#','medium')" class="tableyazi">#get_pos_name.EMPLOYEE_NAME# #get_pos_name.EMPLOYEE_SURNAME#</a></cfoutput>
                    </cfloop>
                  </cfif>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row">
          <td  colspan="3" align="center"> <cf_workcube_buttons is_upd='0'> </td>
        </tr>
      </table>
</cfform>

