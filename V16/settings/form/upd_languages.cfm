<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='1491.Dil Bilgisi Güncelle'></td>
    <td align="right" style="text-align:right;">
		<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_languages"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a>
	</td>
  </tr>
</table>

      <table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
        <tr class="color-row">
          <td width="200" valign="top"><cfinclude template="../display/list_languages.cfm">
          </td>
          <td valign="top">
            <table>
              <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_languages" method="post" name="title">
                <cfquery name="CATEGORIES" datasource="#dsn#">
					SELECT 
						* 
					FROM 
						SETUP_LANGUAGES
					WHERE 
						LANGUAGE_ID=#URL.ID#
                </cfquery>
                <input type="Hidden" name="LANGUAGE_ID" id="LANGUAGE_ID" value="<cfoutput>#URL.ID#</cfoutput>">
                <tr>
                  <td width="100"><cf_get_lang_main no='68.Başlık'> *</td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="title" size="40" value="#categories.language_set#" maxlength="30" required="Yes" message="#message#" style="width:200px;">
                  </td>
                </tr>
                <tr>
                  <td><cf_get_lang_main no='217.Açıklama'></td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="title_short" size="40" value="#categories.language_short#" maxlength="5" required="Yes" message="#message#" style="width:200px;">
                  </td>
                </tr>
				<tr>
				<td></td>
                  <td height="35">
						<cf_workcube_buttons is_upd='1' is_delete='0'> 
                  </td>
                </tr>
				<tr>
				<td colspan="2">
				<cfif len(categories.record_emp)>
					<cf_get_lang_main no='71.Kayıt'> :
					<cfoutput>
						#get_emp_info(categories.record_emp,0,0)#
						#dateformat(categories.record_date,dateformat_style)#
					</cfoutput>
				</cfif>
				</td>
				</tr>
				<tr>
				<td colspan="2">
				<cfif len(categories.update_emp)>
					<cf_get_lang_main no='479.Güncelleyen'> :
					<cfoutput>
						#get_emp_info(categories.update_emp,0,0)#
						#dateformat(categories.update_date,dateformat_style)#
					</cfoutput>
				</cfif>	
				</td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
