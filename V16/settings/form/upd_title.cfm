<cf_get_lang_set module_name="settings">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='665.Ünvan Kategorisi Güncelle'></td>
    <td align="right" style="text-align:right;">
	<cfif not (listfirst(url.fuseaction,".") is "hr")>
		<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_title"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang no='666.Ünvan Kategorisi Ekle'>"></a>
	<cfelse>
		<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.add_title"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang no='666.Ünvan Kategorisi Ekle'>"></a>
	</cfif>
	</td>
  </tr>
</table>
      <table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
        <tr class="color-row">
          <td valign="top">
            <table>
              <cfform action="#request.self#?fuseaction=settings.emptypopup_title_upd" method="post" name="title">
                <input type="hidden" value="<cfoutput>#fusebox.thiscircuit#</cfoutput>" name="fuse" id="fuse">
                <input type="hidden" name="clicked" id="clicked" value="">
                <cfquery name="CATEGORIES" datasource="#dsn#">
					SELECT 
    	                TITLE_ID, 
                        TITLE, 
                        TITLE_DETAIL, 
                        RECORD_DATE, 
                        RECORD_IP, 
                        RECORD_EMP, 
                        HIERARCHY, 
                        UPDATE_EMP, 
                        UPDATE_IP, 
                        UPDATE_DATE 
                    FROM 
	                    SETUP_TITLE 
                    WHERE 
	                    TITLE_ID=#url.title_id#
                </cfquery>
                <input type="hidden" name="TITLE_ID" id="TITLE_ID" value="<cfoutput>#url.title_id#</cfoutput>">
                <tr>
                  <td width="75"><cf_get_lang_main no='68.Başlık'>*</td>
                  <td><cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="title" size="40" value="#categories.TITLE#" maxlength="50" required="Yes" message="#message#" style="width:200px;"></td>
                </tr>
                <tr>
                  <td><cf_get_lang_main no='217.Açıklama'></td>
                  <td><textarea name="title_detail" id="title_detail" cols="75" style="width:200px;" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 100"><cfoutput>#categories.TITLE_DETAIL#</cfoutput></textarea></td>
                </tr>
				<tr>
				  <td><cf_get_lang_main no='349.Hiyerarşi'></td>
				  <td><cfinput type="text" name="hierarchy" value="#categories.hierarchy#" maxlength="50" style="width:200px;"></td>
				</tr>
                <cfinclude template="../query/get_title_used.cfm">
                <tr>
                  <td align="right" colspan="2" height="35" >
                    <cfif title_used.recordcount>
					 <cf_workcube_buttons is_upd='1' is_delete='0'>
                    <cfelse>
					 <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_title_del&title_id=#url.title_id#'>
					</cfif>
                  </td>
                </tr>
				<tr>
					<td colspan="2"><p><cf_get_lang_main no='71.Kayıt'> :
					<cfoutput>
					<cfif len(categories.record_emp)>#get_emp_info(categories.record_emp,0,0)#</cfif>
					<cfif len(categories.record_date)>#dateformat(categories.record_date,dateformat_style)#</cfif>
					</cfoutput>
					</td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
<cf_get_lang_set module_name="#fusebox.circuit#">







