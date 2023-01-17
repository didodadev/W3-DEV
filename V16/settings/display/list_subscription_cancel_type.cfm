<cfquery name="GET_SUBSCRIPTION_CANCEL_TYPES" datasource="#DSN3#">
	SELECT
		*
	FROM
		SETUP_SUBSCRIPTION_CANCEL_TYPE
	ORDER BY 
		SUBSCRIPTION_CANCEL_TYPE
</cfquery>

<table cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='1355.Iptal Kategorileri'></td>
  </tr>
  <cfif get_subscription_cancel_types.recordcount>
    <cfoutput query="get_subscription_cancel_types">
      <tr>
        <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
        <td><a href="#request.self#?fuseaction=settings.upd_subscription_cancel_type&subscription_cancel_type_id=#subscription_cancel_type_id#" class="tableyazi">#subscription_cancel_type#</a></td>
      </tr>
    </cfoutput>
    <cfelse>
    <tr>
      <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>
