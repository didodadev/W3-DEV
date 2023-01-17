<cfquery name="GET_SUPPORT_CAT" datasource="#DSN#" maxrows="1">
	SELECT
		SUPPORT_CAT_ID,
		RECORD_DATE,
		RECORD_EMP,
		UPDATE_DATE,
		UPDATE_EMP
	FROM
		ASSET_CARE_CONTRACT
	WHERE
		SUPPORT_CAT_ID=#URL.ID#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='1667.Rakip Tercih Nedeni Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_rival_prefer_type"><img src="/images/plus1.gif" border="0" align="absmiddle" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
  </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center">
  <tr>
    <td class="color-border">
      <table border="0" cellspacing="1" cellpadding="2" width="100%">
        <tr class="color-row" valign="top">
          <td width="200"><cfinclude template="../display/list_rival_prefer_type.cfm">
          </td>
          <td>
            <table border="0">
              <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_rival_prefer_type&preference_reason_id=#url.id#" method="post" name="upd_rival_preference">
               <cfquery name="UPD_RIVAL" datasource="#dsn#">
					SELECT 
						*
					FROM 
						SETUP_RIVAL_PREFERENCE_REASONS 
					WHERE 
						PREFERENCE_REASON_ID=#URL.ID#
                </cfquery>
                <input type="Hidden" name="preference_reason_id" id="preference_reason_id" value="<cfoutput>#URL.ID#</cfoutput>">
                <tr>
                  <td width="100"><cf_get_lang no='1130.Tercih Nedeni'>*</td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='1129.Tercih Nedeni girmelisiniz'></cfsavecontent>
				  <cfinput type="Text" name="preference_reason" style="width:150px;" value="#UPD_RIVAL.preference_reason#" maxlength="50" required="Yes" message="#message#">
                  </td>
                </tr>
                <tr>
                  <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                  <td><textarea name="detail" id="detail" style="width:150px;height:60px;"><cfoutput>#UPD_RIVAL.detail#</cfoutput></textarea>
                  </td>
                </tr>
                <tr height="35">
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
					<cfif len(upd_rival.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(upd_rival.record_emp,0,0)# - #dateformat(upd_rival.record_date,dateformat_style)#
					</cfif><br/>
					<cfif len(upd_rival.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(upd_rival.update_emp,0,0)# - #dateformat(upd_rival.update_date,dateformat_style)#
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

