<cfinclude template="../query/get_maillist_cat.cfm">
<cfinclude template="../query/get_maillist_cats.cfm">
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
  <tr>
    <td  class="headbold"><cf_get_lang no='621.Mail-List Kategorisi Güncelle'></td>
    <td align="right" class="headbold" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_maillist_cat"><img src="/images/plus1.gif" alt="<cf_get_lang_main no='170.Ekle'>" border="0"></a></td>
  </tr>
</table>
      <table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
        <tr class="color-row">
          <td width="200" valign="top">
            <cfinclude template="../display/list_maillist_cats.cfm">
          </td>
          <td valign="top" >
            <table>
              <cfform action="#request.self#?fuseaction=settings.emptypopup_maillist_cat_upd" method="post">
                <input type="Hidden" name="maillist_cat_ID" id="maillist_cat_ID" value="<cfoutput>#url.maillist_cat_id#</cfoutput>">
                  <tr>
                  <td><cf_get_lang_main no='344.Durum'></td>
                  <td><input type="Checkbox" name="maillist_cat_status" id="maillist_cat_status" value="1" <cfif maillist_cat.maillist_cat_status eq 1>checked</cfif>>
                    <cf_get_lang_main no='81.Aktif'></td>
                </tr>
			    <tr>
                  <td width="100"><cf_get_lang no='20.Kategori Adı'>*</td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang_main no='1143.Kategori Adı girmelisiniz'></cfsavecontent>
				  <cfinput type="Text" name="maillist_cat" size="40" value="#maillist_cat.maillist_cat#" maxlength="75" required="Yes" message="#message#" style="width:150px;">
                  </td>
                </tr>
                <tr>
                  <td height="35" colspan="2" align="right" style="text-align:right;">
				  <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_maillist_cat_del&maillist_cat_id=#attributes.MAILLIST_CAT_ID#'>
                  </td>
                </tr>
				<tr>
				<td colspan="2" align="left"><p><br/>
					<cfoutput>
					<cfif len(maillist_cat.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(maillist_cat.record_emp,0,0)# - #dateformat(maillist_cat.record_date,dateformat_style)#
					</cfif><br/>
					<cfif len(maillist_cat.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(maillist_cat.update_emp,0,0)# - #dateformat(maillist_cat.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
				</td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>	

