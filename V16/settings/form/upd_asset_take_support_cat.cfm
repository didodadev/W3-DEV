<cfquery name="GET_SUPPORT_CAT" datasource="#DSN#" maxrows="1">
	SELECT
		*
	FROM
		ASSET_TAKE_SUPPORT_CAT
	WHERE
		TAKE_SUP_CATID=#URL.TAKE_SUP_CATID#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='1672.Alınan Destek Kategorisini Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_asset_take_support_cat"><img src="/images/plus1.gif" border="0" align="absmiddle" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
  </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center">
  <tr>
    <td class="color-border">
      <table border="0" cellspacing="1" cellpadding="2" width="100%">
        <tr class="color-row" valign="top">
          <td width="200"><cfinclude template="../display/list_asset_take_support_cat.cfm">
          </td>
          <td>
            <table border="0">
              <cfform name="care_form" method="post" action="#request.self#?fuseaction=settings.emptypopup_asset_take_support_cat&TAKE_SUP_CATID=#URL.TAKE_SUP_CATID#">
                <tr>
                  <td width="100"><cf_get_lang_main no='74.Kategori'>*</td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='1187.Kategori girmelisiniz'></cfsavecontent>
				  <cfinput type="text" name="take_sup_cat"  value="#GET_SUPPORT_CAT.TAKE_SUP_CAT#" maxlength="50" required="Yes" message="#message#" style="width:150px;">
                  </td>
                </tr>
                <tr>
                  <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                  <td><textarea name="detail" id="detail" style="width:150px;height:60px;" maxlength="150" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı :150"><cfoutput>#GET_SUPPORT_CAT.detail#</cfoutput></textarea>
                  </td>
                </tr>
                <tr height="35">
				<td></td>
                  <td colspan="2">
				  <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_asset_take_support_cat&TAKE_SUP_CATID=#URL.TAKE_SUP_CATID#'>
				  </td>
                </tr>
				<tr>
                  <td colspan="3"><p><br/>
				  	<cfoutput>
				 	<cfif len(get_support_cat.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_support_cat.record_emp,0,0)# - #dateformat(get_support_cat.record_date,dateformat_style)#
					</cfif><br/>
				 	<cfif len(get_support_cat.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_support_cat.update_emp,0,0)# - #dateformat(get_support_cat.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
			      </td>
				</tr>
             </cfform>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

