<cfform name="add_orientation" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_orientation">
<input type="hidden" name="counter" id="counter">
  <table width="100%" align="center" cellpadding="0" cellspacing="0" border="0" height="100%">
    <tr class="color-border">
      <td>
        <table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%">
        <tr height="35" class="color-list">
      <td class="headbold">&nbsp;<cf_get_lang no='256.Oryantasyon Ekle'></td>
    </tr>
		  <tr class="color-row">
            <td valign="top">
              <table>
                <tr>
                  <td width="3">&nbsp;</td>
                  <td width="75"><cf_get_lang_main no='68.Başlık'></td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.başlık'></cfsavecontent>
					<cfinput type="text" name="ORIENTATION_HEAD" style="width:200px;" required="Yes" message="#message#" value="">
                  </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td><cf_get_lang_main no='89.Başlama'></td>
                  <td>
					<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent>
				    <cfinput  validate="#validate_style#" message="#message#" type="text" name="start_date" style="width:200" maxlength="10" required="yes">
                  	<cf_wrk_date_image date_field="start_date"></td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td><cf_get_lang_main no='90.Bitiş'></td>
                  <td>
					<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.bitis tarihi'></cfsavecontent>
				    <cfinput  validate="#validate_style#" message="#message#" type="text" name="finish_date" style="width:200px;" maxlength="10" required="yes">
                  	<cf_wrk_date_image date_field="finish_date"></td>
                </tr>
				
				<tr>
				  <td>&nbsp;</td>
				  <td><cf_get_lang_main no='1983.Katılımcı'></td>
				  <td>
				    <input type="hidden" name="emp_id" id="emp_id" value="">
					<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1983.katılımcı'></cfsavecontent>
					<cfinput type="text" name="emp_name" value="" required="yes" message="#message#" style="width:200px;">
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_orientation.emp_id&field_name=add_orientation.emp_name&select_list=1</cfoutput>','list');">
					 <img src="/images/plus_thin.gif" border="0" align="absmiddle">
					</a> 
				  </td>
				</tr>
				<tr>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>
				    <input type="checkbox" name="IS_ABSENT" id="IS_ABSENT" value="">Mazeretli / Katılmadı					
				  </td>
				</tr>
				<tr>
				  <td>&nbsp;</td>
				  <td><cf_get_lang_main no='132.Sorumlu'></td>
				  <td>
				    <input type="hidden" name="trainer_emp_id" id="trainer_emp_id" value="">
					<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.sorumlu'></cfsavecontent>
					<cfinput type="text" name="trainer_emp_name" value="" required="yes" message="#message#" style="width:200px;">
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_orientation.trainer_emp_id&field_name=add_orientation.trainer_emp_name&select_list=1</cfoutput>','list');">
					 <img src="/images/plus_thin.gif"  border="0" align="absmiddle">
					</a> 
				  </td>
				</tr>
				<tr>
				  <td valign="top">&nbsp;</td>
                  <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                  <td><cfsavecontent variable="message"><cf_get_lang_main no='1687.Fazla karakter sayısı'></cfsavecontent>
                    <textarea name="detail" id="detail" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" style="width:200px;height:70"></textarea>
                  </td>
                </tr>
                
                <tr>
                  <td style="text-align:right;">&nbsp;</td>
                  <td style="text-align:right;">&nbsp;</td>
                  <td height="35" style="text-align:right;">
				  <cf_workcube_buttons is_upd='0'>&nbsp;&nbsp;&nbsp;&nbsp;
				  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</cfform>
