<cfquery name="GET_EMP_DETAIL" datasource="#DSN#" maxrows="1">
	SELECT LANG1_LEVEL, LANG2_LEVEL FROM EMPLOYEES_DETAIL WHERE LANG1_LEVEL=#URL.ID# OR LANG1_LEVEL=#URL.ID#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
  <tr>
    <td  class="headbold"><cf_get_lang no='622.Bilgi Seviyesi Kategorisi
      Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_know_level"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
      <table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
        <tr class="color-row">
          <tD width="200">
            <cfinclude template="../display/list_know_level.cfm">
          </td>
          <td>
            <table>
              <cfform action="#request.self#?fuseaction=settings.emptypopup_know_level_upd" method="post" name="know_level">
                <cfquery name="CATEGORY" datasource="#dsn#">
					SELECT 
						* 
					FROM 
						SETUP_KNOWLEVEL 
					WHERE 
						KNOWLEVEL_ID=#URL.ID#
                </cfquery>
                <input type="Hidden" name="knowLevel_ID" id="knowLevel_ID" value="<cfoutput>#URL.ID#</cfoutput>">
                <tr>
                  <td width="100"><cf_get_lang_main no='68.Başlık'>*</td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
				  <cfinput type="Text" name="knowLevel" size="30" value="#category.knowLevel#" maxlength="20" required="Yes" message="#message#" style="width:150px;">
                  </td>
                </tr>
				<tr>
				<td></td>
                  <td height="35"> 
				  <cfif get_emp_detail.recordcount>
				  <cf_workcube_buttons is_upd='1' is_delete='0'>                  
				  <cfelse>
				  <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_know_level_del&knowlevel_id=#URL.ID#'>
				  </cfif>
				  </td>
                </tr>
				<tr>
				<td colspan="2"><cf_get_lang_main no='71.Kayıt'> :
				<cfoutput>
					<cfif len(category.record_emp)>#get_emp_info(category.record_emp,0,0)#</cfif>
					<cfif len(category.record_date)>#dateformat(category.record_date,'dd/mm/yyyyy')#</cfif>
					<br/><cf_get_lang_main no='479.Guncelleyen'> :
					<cfif len(category.update_emp)>	#get_emp_info(category.update_emp,0,0)#
						#dateformat(category.update_date,'dd/mm/yyyyy')#
					</cfif>
				</cfoutput>
				</td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>

