<cfquery name="NOTICE_CONTROL" datasource="#DSN#"><!--- İlan grubun başvurularda kullanılıp kullanılmadığını kontrol ediyor. --->
SELECT NOTICE_CAT_ID FROM NOTICES WHERE NOTICE_CAT_ID = #attributes.notice_cat_id#
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='1654.İlan Grubu Güncelle'></td>
    <td align="right" style="text-align:right;">
		<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_notice_type"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'></a>
	</td>
  </tr>
</table>
      <table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
        <tr class="color-row">
          <td width="200" valign="top">
		  <cfinclude template="../display/list_notice_groups.cfm">
          </td>
          <td valign="top">
            <table>
              <cfform name="title" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_notice_type">
                <cfquery name="CATEGORIES" datasource="#dsn#">
					SELECT 
						* 
					FROM 
						SETUP_NOTICE_GROUP
					WHERE 
						NOTICE_CAT_ID=#attributes.notice_cat_id#
                </cfquery>
                <input type="hidden" name="notice_cat_id" id="notice_cat_id" value="<cfoutput>#attributes.notice_cat_id#</cfoutput>">
				<tr>
					<td width="100"><cf_get_lang no='1493.İlan Grubu'>*</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang no='1734.İlan Grubu Adı Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="notice" size="40" value="#categories.notice#" maxlength="50" required="Yes" message="#message#" style="width:200px;">
					</td>
				</tr>
				<tr>
					<td width="75"><cf_get_lang_main no='217.Açıklama'></td>
					<td>
					<textarea name="detail" id="detail" style="width:200px;" maxlength="200" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 200"><cfoutput>#categories.detail#</cfoutput></textarea></td>
				</tr>
				<tr>
					<td align="right" colspan="2" height="35">
						<cfif NOTICE_CONTROL.recordcount>
							<cf_workcube_buttons is_upd='1' is_delete='0'> 
						<cfelse>
							<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_notice_type&notice_cat_id=#attributes.notice_cat_id#'>
						</cfif>
					</td>
				</tr>
				<tr>
					<td colspan="3"><p><br/>
					<cfoutput>
						<cfif len(categories.record_emp)>
							<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(categories.record_emp,0,0)# - #dateformat(categories.record_date,dateformat_style)#
						</cfif><br/>
						<cfif len(categories.update_emp)>
							<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(categories.update_emp,0,0)# - #dateformat(categories.update_date,dateformat_style)#
						</cfif>
					</cfoutput>
					</td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
