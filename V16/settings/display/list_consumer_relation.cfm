<cfquery name="get_CONSUMER_RELATION" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_CONSUMER_RELATION 
	ORDER BY 
		CONSUMER_RELATION
</cfquery>
<table width="200" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='145.Bireysel Üye İlişkileri'></td>
  </tr>
  <cfif get_CONSUMER_RELATION.RecordCount>
    <cfoutput query="get_CONSUMER_RELATION">
      <tr>
        <td width="20" align="right" style="text-align:right;"><img src="/images/tree_1.gif" width="13" align="middle"> </td>
      <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_consumer_relation&consumer_relation_id=#consumer_relation_id#" class="tableyazi">#consumer_relation#</a> </td>
	  </tr>
    </cfoutput>
    <cfelse>
    <tr>
      <td width="20" align="right" style="text-align:right;"><img src="/images/tree_1.gif" width="13" align="middle"></td>
      <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>

