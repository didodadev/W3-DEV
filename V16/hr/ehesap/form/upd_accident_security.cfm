<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang dictionary_id='53091.İş Kazası Güvenlik Maddeleri'></td>
	<td  style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.form_add_accident_security"><img src="/images/plus_list.gif" border="0" title="<cf_get_lang dictionary_id='459.İş Kazası Güvenlik Maddesi Ekle'>"></a></td>
  </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center">
  <tr>
    <td class="color-border">
      <table border="0" cellspacing="1" cellpadding="2" width="100%">
        <tr>
          <td width="200" valign="top" class="color-row">
            <cfinclude template="../display/list_accident_security.cfm">
          </td>
          <td valign="top" class="color-row">
            <table>
              <cfform action="#request.self#?fuseaction=ehesap.emptypopup_upd_accident_security" method="post" name="accident">
                <cfquery name="ACCIDENT_SECURITY" datasource="#dsn#">
					SELECT 
						* 
					FROM 
						EMPLOYEE_ACCIDENT_SECURITY 
					WHERE 
						ACCIDENT_SECURITY_ID = #attributes.ACCIDENT_SECURITY_ID#
                </cfquery>
				<input type="hidden" value="<cfoutput>#ACCIDENT_SECURITY.ACCIDENT_SECURITY_ID#</cfoutput>" name="accident_security_id" id="accident_security_id">
				<tr>
                  <td width="100"><cf_get_lang dictionary_id='57630.Tip'>*</td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='53158.Kategori Adı girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="ACCIDENT_SECURITY" size="40" value="#ACCIDENT_SECURITY.ACCIDENT_SECURITY#" maxlength="100" required="Yes" message="#message#" style="width:150px;">
                  </td>
                </tr>
                <tr>
                  <td valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
                  <td>
                    <textarea name="ACCIDENT_DETAIL" id="ACCIDENT_DETAIL" cols="40" rows="6" style="width:150px;height:40px;"><cfoutput>#ACCIDENT_SECURITY.ACCIDENT_DETAIL#</cfoutput></textarea>
                  </td>
                </tr>
                <tr>
                  <td style="text-align:right;" colspan="2" height="35">
				   <cfquery name="GET_ACCIDENT_SEC" datasource="#dsn#">
					SELECT 
						ACCIDENT_SECURITY_ID
					FROM 
						EMPLOYEES_SSK_FEE
					WHERE 
						ACCIDENT_SECURITY_ID = #attributes.ACCIDENT_SECURITY_ID#
                   </cfquery>						
						<cfif GET_ACCIDENT_SEC.RECORDCOUNT>
						 	<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete="0">
						<cfelse>
							<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete="1" delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_accident_security&ACCIDENT_SECURITY_ID=#attributes.ACCIDENT_SECURITY_ID#'>
						</cfif>
                  </td>
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
function kontrol() 
{
	x = (200 - document.accident.ACCIDENT_DETAIL.value.length);
	if ( x < 0 )
	{ 
		alert ("Açıklama "+ ((-1) * x) +" Karakter Uzun !");
		return false;
	}
	return true;
}
</script>
