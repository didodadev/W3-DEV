<cfquery name="GET_ASSETP_GROUP" datasource="#DSN#" maxrows="1">
	SELECT
		*
	FROM
		SETUP_ASSETP_GROUP
	WHERE
		GROUP_ID=#attributes.assetp_group_id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='876.Fiziki Varlık Grupları'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_assetp_group"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
      <table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
        <tr class="color-row" valign="top">
          <td width="200"><cfinclude template="../display/list_assetp_group.cfm"></td>
          <td>
            <table border="0">
              <cfform name="assetp_groups_form" method="post" action="#request.self#?fuseaction=settings.emptypopup_assetp_group_upd">
			  <input type="hidden" name="assetp_group_id" id="assetp_group_id" value="<cfoutput>#attributes.assetp_group_id#</cfoutput>">
                
				<tr>
                  <td width="100"><cf_get_lang no='880.Fiziki Varlık Grubu'>*</td>
                  <td><cfsavecontent variable="message"><cf_get_lang no='881.Fiziki Varlık Grubu Girmelisiniz'> !</cfsavecontent>
				  <cfinput type="Text" name="assetp_group" style="width:150px;" value="#get_assetp_group.group_name#" maxlength="50" required="Yes" message="#message#"></td>
                </tr>
                <tr>
                  <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                  <td><textarea name="detail" id="detail" style="width:150px;height:60px;"><cfoutput>#get_assetp_group.detail#</cfoutput></textarea>
                  </td>
                </tr>
				<tr>
                  <td><cf_get_lang no='326.Rezerve Edilir'></td>
                  <td><input type="checkbox" name="assetp_reserve" id="assetp_reserve" value="" <cfif get_assetp_group.assetp_reserve eq 1>checked</cfif>>
                  </td>
                </tr>
                <tr>
                  <td><cf_get_lang no='327.IT Varlıkları'></td>
                  <td><input type="checkbox" name="it_asset" id="it_asset" value="" <cfif get_assetp_group.it_asset eq 1>checked</cfif>>
                  </td>
                </tr>
                <tr>
                  <td><cf_get_lang no='328.Motorlu Taşıt'></td>
                  <td><input type="checkbox" name="motorized_vehicle" id="motorized_vehicle" value="" <cfif get_assetp_group.motorized_vehicle eq 1>checked</cfif>>
                  </td>
                </tr>
                <tr height="35">
				  <td></td>			
                  <td><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                </tr>
				<tr>
                  <td colspan="3"><p><br/>
				  	<cfoutput>
				 	<cfif len(get_assetp_group.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_assetp_group.record_emp,0,0)# - #dateformat(get_assetp_group.record_date,dateformat_style)#
					</cfif><br/>
				 	<cfif len(get_assetp_group.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_assetp_group.update_emp,0,0)# - #dateformat(get_assetp_group.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
			      </td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>

