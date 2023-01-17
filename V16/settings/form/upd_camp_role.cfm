<cfquery name="GET_CAMPAIGN_TEAM_ROLE" datasource="#DSN3#">
	SELECT
		ROLE_ID
	FROM
		CAMPAIGN_TEAM
	WHERE
		ROLE_ID=#URL.ID#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td  class="headbold"><cf_get_lang no='647.Rol Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_camp_rol"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
<tr class="color-row">
  <td width="200" valign="top">
    <cfinclude template="../display/list_camp_roles.cfm">
  </td>
  <td valign="top" >
    <table border="0">
      <cfform action="#request.self#?fuseaction=settings.emptypopup_camp_rol_upd" method="post" name="pro_currency">
        <cfquery name="ROLLES" datasource="#dsn3#">
            SELECT 
                * 
            FROM 
                SETUP_CAMPAIGN_ROLES 
            WHERE 
                CAMPAIGN_ROLE_ID=#URL.ID#
        </cfquery>
        <input type="Hidden" name="CAMPAIGN_ROLE_ID" id="CAMPAIGN_ROLE_ID" value="<cfoutput>#URL.ID#</cfoutput>">
        <tr>
          <td width="100"><cf_get_lang no='31.Rol'> *</td>
          <td>
          <cfsavecontent variable="message"><cf_get_lang no='723.Rol girmelisiniz'></cfsavecontent>
          <cfinput type="Text" name="CAMPAIGN_ROLE" style="width:200px;" value="#ROLLES.CAMPAIGN_ROLE#" maxlength="20" required="Yes" message="#message#">
          </td>
        </tr>
        <tr>
          <td><cf_get_lang_main no='217.Açıklama'></td>
          <td>
            <textarea name="DETAIL" id="DETAIL" style="width:200px;" cols="75" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 100"><cfif len(ROLLES.DETAIL)><cfoutput>#ROLLES.DETAIL#</cfoutput></cfif></textarea>
          </td>
        </tr>
        <tr height="35">
          <td colspan="2" align="right" style="text-align:right;">
            <cfif get_campaign_team_role.recordcount>
                <cf_workcube_buttons is_upd='1' is_delete='0'>
            <cfelse>
                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_camp_rol_del&CAMPAIGN_ROLE_ID=#url.id#'>
            </cfif>
          </td>
        </tr>
        <tr>
        <td colspan="2">
        <cf_get_lang_main no='71.Kayıt'> :
        <cfoutput>
            <cfif len(rolles.record_emp)>#get_emp_info(rolles.record_emp,0,0)#</cfif>
            <cfif len(rolles.record_date)>#dateformat(rolles.record_date,dateformat_style)#</cfif>
            <cfif len(rolles.update_emp)>
            <br/>
            <cf_get_lang_main no='291.Son Güncelleme'> :
            #get_emp_info(rolles.update_emp,0,0)#
            #dateformat(rolles.update_date,dateformat_style)#
            </cfif>
        </cfoutput>
        </td>
        </tr>
      </cfform>
    </table>
  </td>
</tr>
</table>	
