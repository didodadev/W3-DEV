<cfquery name="GET_SUPPORT_CAT" datasource="#DSN#" maxrows="1">
	SELECT
		SUPPORT_CAT_ID
	FROM
		ASSET_CARE_CONTRACT
	WHERE
		SUPPORT_CAT_ID=#URL.ID#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='576.Varlık Durum Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_asset_state"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center">
  <tr>
    <td class="color-border">
      <table border="0" cellspacing="1" cellpadding="2" width="100%">
        <tr class="color-row" valign="top">
          <td width="200"><cfinclude template="../display/list_asset_state.cfm">
          </td>
          <td>
            <table border="0">
              <cfform action="#request.self#?fuseaction=settings.emptypopup_asset_state_upd&ASSET_STATE_ID=#URL.ID#" method="post" name="care_form">
                <cfquery name="CATEGORY" datasource="#dsn#">
					SELECT 
						* 
					FROM 
						ASSET_STATE 
					WHERE 
						ASSET_STATE_ID=#URL.ID#
                </cfquery>
                <input type="hidden" name="asset_state_id" id="asset_state_id" value="<cfoutput>#URL.ID#</cfoutput>">
                <tr>
                  <td width="60"><cf_get_lang_main no='344.Durum'>*</td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='726.Durum girmelisiniz'></cfsavecontent>
				  <cfinput type="text" name="asset_state" style="width:150px;" value="#category.asset_state#" maxlength="50" required="Yes" message="#message#">
                  </td>
                </tr>
                <tr>
                  <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                  <td><Textarea name="detail" id="detail" style="width:150px;height:60px;" maxlength="150" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 150"><cfoutput>#category.detail#</cfoutput></TEXTAREA>
                  </td>
                </tr>
                <tr>
				  <td></td>
                  <td>
				  <cfif get_support_cat.recordcount>
				  <cf_workcube_buttons is_upd='1' is_delete='0'>
				  <cfelse>
				  <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_asset_state&asset_state_id=#URL.ID#'>
                  </cfif>
				  </td>
                </tr>
				<tr>
                  <td colspan="3"><p><br/>
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
    </td>
  </tr>
</table>

