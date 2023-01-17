<!--HAKAN-->
<cfquery name="GET_REQ" datasource="#dsn#">
	SELECT 
		* 
	FROM 
			SETUP_REQ_TYPE
</cfquery>

<table cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang dictionary_id='58709.Yetkinlikler'></td>
  </tr>
  <cfif GET_REQ.recordcount>
    <cfoutput query="GET_REQ">
      <tr>
        <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
        <td><a href="#request.self#?fuseaction=settings.form_upd_req_type&req_id=#REQ_ID#" class="tableyazi">#REQ_NAME#</a></td>
      </tr>
    </cfoutput>
    <cfelse>
    <tr>
      <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>

