<cfquery name="GET_ORGANIZATION_STEPS" datasource="#dsn#" maxrows="1">
	SELECT
		ORGANIZATION_STEP_ID
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		ORGANIZATION_STEP_ID=#attributes.organization_step_id#
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='1350.Kademe Güncelle'></td>
    <td align="right" style="text-align:right;">
		<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_organization_step"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a>
	</td>
  </tr>
</table>
      <table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
        <tr class="color-row">
          <td width="200" valign="top"><cfinclude template="../display/list_organization_steps.cfm">
          </td>
          <td valign="top">
            <table>
              <cfform name="title" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_organization_step">
			  <input type="hidden" value="" name="edit_no" id="edit_no">
                <cfquery name="CATEGORIES" datasource="#dsn#">
					SELECT 
						* 
					FROM 
						SETUP_ORGANIZATION_STEPS
					WHERE 
						ORGANIZATION_STEP_ID=#attributes.organization_step_id#
                </cfquery>
                <input type="Hidden" name="organization_step_id" id="organization_step_id" value="<cfoutput>#attributes.organization_step_id#</cfoutput>">
				<tr>
					<td width="125"><cf_get_lang no='1107.Şemada Yandan Bağlı'></td>
					<td><input type="Checkbox" name="organisation_disp" id="organisation_disp" value="1" <cfif CATEGORIES.ORG_DSP eq 1>checked</cfif>></td>
				</tr>
                <tr>
                  <td width="100"><cf_get_lang_main no='68.Başlık'>*</td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="organization_step_name" size="40" value="#CATEGORIES.ORGANIZATION_STEP_NAME#" maxlength="150" required="Yes" message="#message#" style="width:200px;">
                  </td>
                </tr>
                <tr>
				<td><cf_get_lang no='1108.Kademe Numarası'><font color=red></font></td>
				<td>
				<cfsavecontent variable="message"><cf_get_lang no ='1823.Kademe numarası girmelisiniz'></cfsavecontent>
                    <cfinput name="organization_step_no" size="40" value="#categories.ORGANIZATION_STEP_NO#" validate="integer" required="no" message="#message#"style="width:200px;">
                </td>
				</tr>
				<tr>
                  <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                  <td>
				  	<cfsavecontent variable="textmessage"><cf_get_lang_main no='1687.Fazla karakter sayısı'></cfsavecontent>
                    <textarea name="detail" id="detail" cols="75" style="width:200px;height:100px" message="<cfoutput>#textmessage#</cfoutput>" maxlength="500" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"><cfoutput>#categories.DETAIL#</cfoutput></textarea>
                  </td>
                </tr>
                <tr>
                  <td align="right" colspan="2" height="35">
					<cfif GET_ORGANIZATION_STEPS.recordcount>
						<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'> 
					<cfelse>
						<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_organization_step&ORGANIZATION_STEP_ID=#url.ORGANIZATION_STEP_ID#' add_function='kontrol()'>
					</cfif>
                  </td>
                </tr>
				<tr>
				  <td colspan="3"><p><br/>
					<cfoutput>
					<cfif len(categories.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(categories.record_emp,0,0)# - #dateformat(categories.record_date,dateformat_style)#
					</cfif><br/>
					<cfif len(categories.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(categories.update_emp,0,0)# - #dateformat(categories.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
				  </td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
<script type="text/javascript">
function kontrol()
{
	if(confirm("<cf_get_lang no='1444.Mevcut Kayıtların Kademe Numaralarını Düzenlemek İster misiniz'>"))
	{
		document.title.edit_no.value=1;
	}else
	{
		document.title.edit_no.value=0;
	}
}
</script>
