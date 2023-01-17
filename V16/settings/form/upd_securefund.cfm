<cfquery name="SETUP_SECUREFUND" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_SECUREFUND
	WHERE
		SECUREFUND_CAT_ID = #ATTRIBUTES.SECUREFUND_CAT_ID#
</cfquery>	
<table border="0" cellspacing="0" cellpadding="2" width="98%" height="35" align="center">
  <tr>
    <td class="headbold"><cf_get_lang no='754.Teminat Kategorisi'></td>
	<TD align="right" style="text-align:right;">
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_securefund"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'></a>
	</TD>
  </tr>
</table>
      <table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
        <tr class="txtbold">
          <td valign="top" width="200" class="color-row">
            <cfinclude template="../display/list_securefund.cfm">
          <td valign="top" class="color-row">
            <table border="0">
              <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_securefund" method="post" name="care_form">
                <input type="hidden" name="SECUREFUND_CAT_ID" id="SECUREFUND_CAT_ID" value="<cfoutput>#ATTRIBUTES.SECUREFUND_CAT_ID#</cfoutput>">
				<tr>
                  <td><cf_get_lang_main no='74.Kategori Adı'> *</td>
                  <td>
				  <cfinput  type="Text" name="SECUREFUND_CAT" value="#SETUP_SECUREFUND.SECUREFUND_CAT#" maxlength="50"  style="width:150px;">
                  </td>
                </tr>
                <tr>
                  <td width="100" valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                  <td><TEXTAREA name="SECUREFUND_CAT_DETAIL" id="SECUREFUND_CAT_DETAIL" style="width:150px;height:60px;" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 100"><cfoutput>#SETUP_SECUREFUND.SECUREFUND_CAT_DETAIL#</cfoutput></TEXTAREA>
                  </td>
                </tr>
				<tr>
				<td></td>
                  <td height="35">
				  <cf_workcube_buttons is_upd='1' is_delete='0'>
				  </td>
                </tr>
				<tr>
				<td colspan="2">
				<cf_get_lang_main no='71.Kayıt'> :
				<cfoutput>
					<cfif len(SETUP_SECUREFUND.record_emp)>#get_emp_info(SETUP_SECUREFUND.record_emp,0,0)#</cfif>
					<cfif len(SETUP_SECUREFUND.record_date)>#dateformat(SETUP_SECUREFUND.record_date,dateformat_style)#</cfif>
					<cfif len(SETUP_SECUREFUND.update_date)>
					<br/><cf_get_lang_main no='479.Guncelleyen'> :
					#get_emp_info(SETUP_SECUREFUND.update_emp,0,0)#
					#dateformat(SETUP_SECUREFUND.update_date,dateformat_style)#
					</cfif>
				</cfoutput>
				</td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>

