<cfparam name="attributes.keyword" default="">
<cfform action="#request.self#?fuseaction=member.form_list_company&mem_pg=list" method="post" name="dene">
  <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td height="30" class="headbold" colspan="2"><cf_get_lang dictionary_id='30406.Şirket Ara'></td>
    </tr>
    <tr>
	<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
      <td>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57565.Ara'></cfsavecontent>
        <cf_workcube_buttons is_upd='0' insert_info='#message#'></td>
    </tr>
  </table>
</cfform>

