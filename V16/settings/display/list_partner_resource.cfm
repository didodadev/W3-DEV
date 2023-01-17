<cfquery name="get_PARTNER_RESORCE" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		COMPANY_PARTNER_RESOURCE 
	ORDER BY 
		RESOURCE
</cfquery>
<table width="200" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='683.Kurumsal Üye Kaynakları'></td>
  </tr>
  <cfif get_PARTNER_RESORCE.RecordCount>
    <cfoutput query="get_PARTNER_RESORCE">
      <tr>
        <td width="20" align="right" style="text-align:right;"><img src="/images/tree_1.gif" width="13" align="absmiddle">       </td>
      <td width="180">
       <a href="#request.self#?fuseaction=settings.form_upd_partner_resource&resource_id=#resource_id#" class="tableyazi">#resource#</a></td>
	  </tr>
    </cfoutput>
    <cfelse>
    <tr>
      <td width="20" align="right" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>
