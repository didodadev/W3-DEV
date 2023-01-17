<cfquery name="GET_INCOME_LEVEL" datasource="#DSN#" maxrows="1">
	SELECT
		INCOME_LEVEL_ID
	FROM
		CONSUMER
	WHERE
		INCOME_LEVEL_ID=#attributes.ID#
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='1363.Gelir Düzey Bilgisi Güncelle'></td>
    <td align="right" style="text-align:right;">
		<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_income_level"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a>
	</td>
  </tr>
</table>
      <table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
        <tr class="color-row">
          <td width="200" valign="top"><cfinclude template="../display/list_income_level.cfm">
          </td>
          <td valign="top">
            <table>
              <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_income_level" method="post" name="upd_income_level">
                <cfquery name="GET_LEVEL" datasource="#dsn#">
					SELECT
						*
					FROM
						SETUP_INCOME_LEVEL
					WHERE
						INCOME_LEVEL_ID=#attributes.ID#
                </cfquery>
                <input type="hidden" name="level_id" id="level_id" value="<cfoutput>#url.id#</cfoutput>">
                <tr>
                  <td width="100"><cf_get_lang no='1088.Gelir Düzeyi'> *</td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang no='1089.Gelir Düzeyi girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="income_level" size="40" value="#GET_LEVEL.INCOME_LEVEL#" maxlength="100" required="Yes" message="#message#" style="width:200px;">
                  </td>
                </tr>
                <tr>
                  <td><cf_get_lang_main no='217.Açıklama'></td>
                  <td>
                    <cftextarea name="detail" cols="75" maxlength="200" style="width:200px;"><cfoutput>#GET_LEVEL.DETAIL#</cfoutput></cftextarea>
                  </td>
                </tr>
				<tr>
				<tr>
				<td></td>
                  <td>
					<cfif GET_INCOME_LEVEL.recordcount>
						<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'> 
					<cfelse>
						<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_income_level&level_id=#url.id#'>
					</cfif>
                  </td>
                </tr>
				<td colspan="2"><cf_get_lang_main no='71.Kayıt'> :
				<cfoutput>
					<cfif len(get_level.record_emp)>
						#get_emp_info(get_level.record_emp,0,0)#
						#dateformat(get_level.record_date,dateformat_style)#
					</cfif>
				</cfoutput>
				</td>
				</tr>
				<tr>
				<td colspan="2">
				<cfoutput>
					<cfif len(get_level.update_emp)>
						<cf_get_lang_main no='479.Güncelleyen'> : #get_emp_info(get_level.update_emp,0,0)#
						#dateformat(get_level.update_date,dateformat_style)#
					</cfif>
				</cfoutput>
				</td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
<br/>
<script type="text/javascript">
	function kontrol()
	{
		if(document.upd_income_level.detail.value.length>200)
			{
			alert("<cf_get_lang no='1086.Açıklama 200 karakterden uzun olamaz'>");
			return false;
			}
		return true;
	}
</script>

