<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='807.Uyarı Onay Kategorisi Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_warnings_approval_types"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
      <table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
        <tr class="color-row">
          <td width="200" valign="top"><cfinclude template="../display/list_warnings_types.cfm">
          </td>
          <td valign="top">
<cfquery name="GET_SETUP_WARNING" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_WARNINGS 
	WHERE
		SETUP_WARNING_ID = #url.setup_warning_id#
	ORDER BY SETUP_WARNING
</cfquery>
			<table border="0">
              <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_setup_warnings_types" method="post" name="position">
                <input type="hidden" name="SETUP_WARNING_ID" id="SETUP_WARNING_ID" value="<cfoutput>#url.SETUP_WARNING_ID#</cfoutput>">
				<tr>
                  <td width="100"><cf_get_lang_main no='74.Uyarı Onay Tipi'>* </td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="setup_warning" style="width:200px;" value="#get_setup_warning.setup_warning#" maxlength="50" required="Yes" message="#message#">
                  </td>
                </tr>
                <tr>
                  <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                  <td><textarea name="detail" id="detail" style="width:200px;height:60px;"><cfif len(get_setup_warning.detail)><cfoutput>#get_setup_warning.detail#</cfoutput></cfif></textarea>
                  </td>
                </tr>
                <tr>
                  <td height="35" colspan="2" align="right" style="text-align:right;">
				  <cf_workcube_buttons is_upd='1' 
				  delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_setup_warnings_types&setup_warning_id=#url.setup_warning_id#'>
                  </td>
                </tr>
				<tr>
				<td colspan="2" align="left"><p><br/>
					<cfoutput>
					<cfif len(get_setup_warning.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_setup_warning.record_emp,0,0)# - #dateformat(get_setup_warning.record_date,dateformat_style)#
					</cfif><br/>
					<cfif len(get_setup_warning.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_setup_warning.update_emp,0,0)# - #dateformat(get_setup_warning.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
				</td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>

