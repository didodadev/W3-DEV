<cfinclude template="../query/get_pro_work_cat.cfm">
<cfinclude template="../query/get_procurrency.cfm">
<cfinclude template="../query/get_priority.cfm">
<cfform method="POST" name="add_work" action="#request.self#?fuseaction=project.addwork_act">
  <table border="0" width="98%" cellpadding="0" cellspacing="0" align="center">
    <tr>
      <td height="35" class="headbold"><cf_get_lang_main no='521.İş Ekle'></td>
    </tr>
  </table>
  <table border="0" width="98%" cellpadding="0" cellspacing="0" align="center">
    <tr class="color-border">
      <td>
        <table border="0" width="100%" cellpadding="2" cellspacing="1" align="center">
          <tr>
            <td class="color-row">
              <table border="0" width="100%" align="center">
                <tr>
                  <td>
                    <table>
                      <tr>
                        <td><cf_get_lang_main no='70.Aşama'></td>
                        <td><cf_get_lang_main no='73.Öncelik'></td>
                        <td><cf_get_lang no='720.İş Kategorisi'> *</td>
                      </tr>
                      <tr>
                        <td>
                          <select name="WORK_CURRENCY" id="WORK_CURRENCY" style="width:101px;">
                            <cfoutput query="get_procurrency">
                              <option value="#get_procurrency.CURRENCY_ID#">#get_procurrency.currency#</option>
                            </cfoutput>
                          </select>
                        </td>
                        <td>
                          <select name="PRIORITY_CAT" id="PRIORITY_CAT" style="width:101px;">
                            <cfoutput query="get_cats">
                              <option value="#get_cats.PRIORITY_ID#">#get_cats.priority#</option>
                            </cfoutput>
                          </select>
                        </td>
                        <td>
                          <select name="PRO_WORK_CAT" id="PRO_WORK_CAT" style="width:125px;">
                            <option value=""><cf_get_lang_main no='322.Seçiniz '>
                            <cfoutput query="get_work_cat">
                              <option value="#get_work_cat.WORK_CAT_ID#">#get_work_cat.work_cat#</option>
                            </cfoutput>
                          </select>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td>
                    <table>
                      <tr>
                        <td>
                          <input type="Hidden" name="project_id" id="project_id" value="0">
                          <input type="text" name="project_head" id="project_head" style="width:190;" value="<cf_get_lang_main no='1385.Proje Seçiniz'>" readonly>
                          <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=add_work.project_head&project_id=add_work.project_id</cfoutput>');"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='1385.Proje Seçiniz'>" align="absmiddle" border="0"></a>
						&nbsp;&nbsp; </td>
						<td>
							<input type="Hidden" name="COMPANY_PARTNER_ID" id="COMPANY_PARTNER_ID">
							<input type="Hidden" name="COMPANY_ID" id="COMPANY_ID">
							<input type="text" name="about_company" id="about_company" style="width:165;"  value="" readonly>						
							<input type="text" name="about_par_name" id="about_par_name" style="width:150px;"  value="" readonly>
                          <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=add_work.COMPANY_ID&field_comp_name=add_work.about_company&field_id=add_work.COMPANY_PARTNER_ID&field_name=add_work.about_par_name&par_con=1&select_list=2</cfoutput>','list')"><!--- ,3 ---><img src="/images/plus_list.gif" align="absmiddle" border="0"></a>
						</td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td>
                    <table>
                      <tr>
                        <td><cf_get_lang_main no='68.Başlık'> *</td>
                      </tr>
                      <tr>
                        <td height="22">
						  <cfsavecontent variable="message"><cf_get_lang no='721.Lütfen İşin Adını Giriniz'></cfsavecontent>
                          <cfinput type="Text" name="WORK_HEAD" required="Yes" message="#message#!" style="width:570px;" maxlength="100">
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang_main no='359.Ayrıntı'></td>
                      </tr>
                      <tr>
                        <td>
                          <textarea name="WORK_DETAIL" id="WORK_DETAIL" style="width:570px;" rows="10"></textarea>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td>
                    <table>
                      <tr>
                        <td><cf_get_lang_main no='243.Başlama Tarihi'> *</td>
                        <td><cf_get_lang_main no='79.Saat'> </td>
                        <td><cf_get_lang_main no='288.Bitiş Tarihi'> *</td>
                        <td><cf_get_lang_main no='79.Saat'> </td>
                        <td><cf_get_lang_main no='157.Görevli'> *</td>
                      </tr>
                      <tr>
                        <td>
						  <cfsavecontent variable="message"><cf_get_lang_main no='326.Lütfen İşin Hedef Başlangıç Tarihi Giriniz'></cfsavecontent>
                          <cfinput required="Yes" message="#message#" type="text" name="WORK_H_START" value="" style="width:90px;" validate="eurodate">
                          <cf_wrk_date_image date_field="WORK_H_START"> </td>
                        <td>
						  <cfoutput>
                            <select name="START_HOUR" id="START_HOUR">
                              <cfloop from="0" to="23" index="i">
                                <option value="#i#" <cfif i eq 8>selected</cfif>>#i#:00</option>
                              </cfloop>
                            </select>
                          </cfoutput> </td>
                        <td>
							<cfsavecontent variable="message"><cf_get_lang_main no='327.Lütfen İşin Hedef Bitiş Tarihi Giriniz'></cfsavecontent>
							<cfinput required="Yes" message="#message#" type="text" name="WORK_H_FINISH" value="" style="width:90px;" validate="eurodate">
                          <cf_wrk_date_image date_field="WORK_H_FINISH"></td>
                        <td>
						  <cfoutput>
                            <select name="FINISH_HOUR" id="FINISH_HOUR">
                              <cfloop from="0" to="23" index="i">
                                <option value="#i#" <cfif i eq 18>selected</cfif>>#i#:00</option>
                              </cfloop>
                            </select>
                          </cfoutput> </td>
                        <td>
                          <input type="hidden" name="TASK_COMPANY_ID" id="TASK_COMPANY_ID" value="">
                          <input type="hidden" name="TASK_PARTNER_ID" id="TASK_PARTNER_ID" value="">
                          <input type="hidden" name="POSITION_CODE" id="POSITION_CODE" value="">
                          <input type="text" name="responsable_name" id="responsable_name" style="width:190px;" value="" readonly>
                          <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_partner=add_work.TASK_PARTNER_ID&field_comp_id=add_work.TASK_COMPANY_ID&field_code=add_work.POSITION_CODE&field_name=add_work.responsable_name&select_list=1,2</cfoutput>','list');"><img src="/images/partner_plus.gif" title="<cf_get_lang no ='1391.Lider Seç'>" align="absmiddle" border="0"></a> </td>
                      </tr>
                      <tr>
                        <td colspan="6" align="right" style="text-align:right;">
                          <cf_workcube_buttons is_upd='0' add_function='kontrol()'> </td>
                      </tr>
                    </table>
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
<script type="text/javascript">
	function kontrol()
	{
		x = document.add_work.PRO_WORK_CAT.selectedIndex;
		if (document.add_work.PRO_WORK_CAT[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='723.İş Kategorisi Seçmelisiniz'> !");
			return false;
		}
		return chk_field();
	}
	function chk_field()
	{
		if(document.add_work.responsable_name.value=="")
		{
			alert("<cf_get_lang_main no='724.Lütfen görevli seçiniz'>!");
			return false;
		}
		return true;
	}
</script>
