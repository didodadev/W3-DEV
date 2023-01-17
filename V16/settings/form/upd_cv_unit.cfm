<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='964.Fonksiyonlar Birimler'></td>
    <td align="right" style="text-align:right;">
		<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_cv_unit"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a>
	</td>
  </tr>
</table>
      <table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
        <tr class="color-row">
          <td width="200" valign="top"><cfinclude template="../display/list_cv_unit.cfm">
          </td>
          <td valign="top">
            <table>
              <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_cv_unit" method="post" name="title">
                <cfquery name="CATEGORIES" datasource="#dsn#">
					SELECT 
						* 
					FROM 
						SETUP_CV_UNIT
					WHERE 
						UNIT_ID=#attributes.unit_id#
                </cfquery>
                <input type="Hidden" name="unit_ID" id="unit_ID" value="<cfoutput>#attributes.unit_id#</cfoutput>">
				<tr>
					<td width="100"></td>
					<td width="200">
					<input type="checkbox" name="is_view" id="is_view" value="1" <cfif len(categories.is_view) and categories.is_view>checked</cfif>> <cf_get_lang no='1025.Internette Göster'>
					<input type="Checkbox" name="is_active" id="is_active" value="1" <cfif len(categories.is_active) and categories.is_active>checked</cfif>><cf_get_lang_main no='81.Aktif'>
					</td>
				</tr>
				<tr>
					<td width="100"><cf_get_lang_main no='68.Başlık'> *</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
						<cfinput type="Text" name="title" size="40" value="#categories.unit_name#" maxlength="30" required="Yes" message="#message#" style="width:200px;">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='217.Açıklama'></td>
					<td><textarea name="title_detail" id="title_detail" style="width:200px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 250"><cfoutput>#categories.unit_detail#</cfoutput></textarea></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='349.Hiyerarşi'></td>
					<td><cfinput type="text" name="hierarchy" value="#categories.hierarchy#" maxlength="50" style="width:200px;"></td>
				</tr>
				<tr>
					<td align="right" colspan="2" height="35"><cf_workcube_buttons is_upd='1' is_delete='0'> </td>
				</tr>
				<tr>
					<td colspan="2">
						<cfif len(categories.record_emp)><cf_get_lang_main no='71.Kayıt'> :<cfoutput><cfif categories.record_emp eq 0><cf_get_lang_main no='290.Sistem Admin'><cfelse>#get_emp_info(categories.record_emp,0,0)#</cfif>&nbsp;#dateformat(categories.record_date,dateformat_style)#</cfoutput></cfif>
						<cfif len(categories.update_emp)><br/><cf_get_lang_main no='479.Güncelleyen'> :<cfoutput><cfif categories.update_emp eq 0><cf_get_lang_main no='290.Sistem Admin'><cfelse>#get_emp_info(categories.update_emp,0,0)#</cfif>&nbsp;#dateformat(categories.update_date,dateformat_style)#</cfoutput></cfif>	
					</td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
