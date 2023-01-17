<cfquery name="GET_COST_TYPE" datasource="#DSN#">
	SELECT
		COST_TYPE_ID,
		COST_TYPE_NAME,
		COST_TYPE_DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE
	FROM
		SETUP_COST_TYPE
	WHERE
		COST_TYPE_ID=#attributes.cost_type_id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="97%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='1575.Maliyet Tipi Güncelle'></td>
    <td align="right" class="headbold" style="text-align:right;"><a href="<cfoutput>#request.self#?fuseaction=settings.form_add_cost_type</cfoutput>"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="97%" align="center">
  <tr>
    <td class="color-border">
      <table border="0" cellspacing="1" cellpadding="2" width="100%">
        <tr>
          <td width="200" valign="top" class="color-row">
            <cfinclude template="../display/list_cost_type.cfm">
          </td>
          <td valign="top" class="color-row">
            <table>
              <cfform name="frm_upd_cost_type" method="post" action="#request.self#?fuseaction=settings.upd_cost_type&cost_type_id=#attributes.cost_type_id#">
                <tr>
                  <td width="75"><cf_get_lang_main no='68.Başlık'></td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang no ='1574.Maliyet Tipi Girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="cost_type_name" value="#GET_COST_TYPE.COST_TYPE_NAME#" maxlength="50" required="Yes" message="#message#" style="width:150px;">
                  </td>
                </tr>
                <tr>
                  <td><cf_get_lang_main no='217.Açıklama'></td>
                  <td>
                    <textarea name="cost_type_detail" id="cost_type_detail" style="width:150px"><cfoutput>#GET_COST_TYPE.COST_TYPE_DETAIL#</cfoutput></textarea>
                  </td>
                </tr>
                <tr>
                  <td align="right" colspan="3" height="35">
				   <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.del_cost_type&cost_type_id=#attributes.cost_type_id#'>
				  </td>
                </tr>
				<tr>
					<td align="left" colspan="2"><p><br/>
					<cfoutput>
					<cfif len(GET_COST_TYPE.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(GET_COST_TYPE.record_emp,0,0)# - #dateformat(GET_COST_TYPE.record_date,dateformat_style)#
					</cfif><br/>
					<cfif len(GET_COST_TYPE.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(GET_COST_TYPE.update_emp,0,0)# - #dateformat(GET_COST_TYPE.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
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
