<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
  <tr>
    <td  class="headbold"><cf_get_lang no='619.Mobil Telefon Kodu Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_mobil_cat"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
      <table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
        <tr class="color-row">
          <td width="200" valign="top">
            <cfinclude template="../display/list_mobil_cat.cfm">
          </td>
          <td valign="top" >
            <table>
              <cfform name="mobil_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_mobil_cat_upd">
                <cfquery name="CATEGORY" datasource="#dsn#">
					SELECT 
						* 
					FROM 
						SETUP_MOBILCAT 
					WHERE 
						MOBILCAT_ID=#URL.ID#
                </cfquery>
                <input type="Hidden" name="mobilCat_ID" id="mobilCat_ID" value="<cfoutput>#URL.ID#</cfoutput>">
                <tr>
                  <td width="100"><cf_get_lang no='386.Kod Numarası'> *</td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang no='659.Kod Numarası girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="mobilCat" size="20" value="#category.mobilCat#" maxlength="10" required="Yes" message="#message#" style="width:150px;">
                  </td>
                </tr>
                <tr>
				  <td></td>
                  <td><cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_mobil_cat_del&mobilcat_id=#URL.ID#'></td>
                </tr>
				<tr>
				  <td colspan="2" align="left"><p><br/>
				<cfoutput>
				<cfif len(category.record_emp)>
					<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(category.record_emp,0,0)# - #dateformat(category.record_date,dateformat_style)#
				</cfif><br/>
				<cfif len(category.update_emp)>
					<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(category.update_emp,0,0)# - #dateformat(category.update_date,dateformat_style)#
				</cfif>
				</cfoutput>
				  </td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
