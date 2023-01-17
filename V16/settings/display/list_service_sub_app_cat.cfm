<cfquery name="SERVICE_SUB_CATS" datasource="#dsn3#">
	SELECT
		SERVICE_APPCAT_SUB.SERVICE_SUB_CAT_ID, 
		SERVICE_APPCAT_SUB.SERVICE_SUB_CAT,
		SERVICE_APPCAT_SUB.SERVICECAT_ID, 
		SERVICE_APPCAT.SERVICECAT 
	FROM 
		SERVICE_APPCAT_SUB,
		SERVICE_APPCAT 
	WHERE 
		SERVICE_APPCAT.SERVICECAT_ID = SERVICE_APPCAT_SUB.SERVICECAT_ID
	ORDER BY	
		SERVICE_APPCAT.SERVICECAT,
		SERVICE_APPCAT_SUB.SERVICE_SUB_CAT		
</cfquery>

<table width="200" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='3090.Servis Alt Başvuru Kategorileri'></td>
  </tr>
  <cfif service_sub_cats.recordcount>
    <cfoutput query="service_sub_cats">
      <tr>
        <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
        <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_service_sub_app_cat&service_sub_cat_id=#service_sub_cat_id#" class="tableyazi">#servicecat# - #service_sub_cat#</a></td>
      </tr>
    </cfoutput>
    <cfelse>
    <tr>
      <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>
