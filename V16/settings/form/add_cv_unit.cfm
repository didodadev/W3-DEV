<!---
<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
  <tr>
    <td class="headbold"><cf_get_lang no='964.Fonksiyonlar Birimler'></td>
  </tr>
</table>	
      <table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
        <tr class="color-row">
          <td width="200" valign="top"><cfinclude template="../display/list_cv_unit.cfm">
          </td>
          <td valign="top">
            <table border="0">
              <cfform action="#request.self#?fuseaction=settings.emptypopup_add_cv_unit" method="post" name="title_form">
               <!---<input type="hidden" value="<cfoutput>#fusebox.thiscircuit#</cfoutput>" name="fuse">--->
				<tr>
					<td width="75"></td>
					<td width="200"><input type="checkbox" name="is_view" value="1" checked> <cf_get_lang no='1025.Internette Göster'>
					<input type="Checkbox" name="is_active" value="1" checked><cf_get_lang_main no='81.Aktif'>
					</td>
				</tr>
				<tr>
					<td width="75"><cf_get_lang_main no='68.Başlık'>*</td>
					<td width="200">				
					<cfsavecontent variable="message"><cf_get_lang_main no='324.Başlık girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="title_" style="width:200px;" value="" maxlength="50" required="Yes" message="#message#">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='217.Açıklama'></td>
					<td><textarea name="title_detail" style="width:200px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 250"></textarea></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='349.Hiyerarşi'></td>
					<td><cfinput type="text" name="hierarchy" style="width:200px;" value="" maxlength="50"></td>
				</tr>
				<tr>
					<td height="35" colspan="2" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
--->

<cf_wrk_grid search_header = "#getLang('settings',964)#" table_name="SETUP_CV_UNIT" sort_column="UNIT_NAME" u_id="UNIT_ID" datasource="#dsn#" search_areas = "UNIT_NAME,UNIT_DETAIL"><!---<cf_get_lang no='964.Fonksiyonlar Birimler'>--->
    <cf_wrk_grid_column name="UNIT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="UNIT_NAME" width="200" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="UNIT_DETAIL" header="#getLang('main',217)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="HIERARCHY" header="#getLang('main',349)#" width="100" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_VIEW" header="#getLang('main',1025)#" type="boolean" width="100" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_ACTIVE" header="#getLang('main',81)#" type="boolean" width="100" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('main',214)#" type="date" mask="date" width="100" select="no" display="yes"/>
</cf_wrk_grid>
