<cfquery name="CARE_STATES" datasource="#DSN#">
  SELECT 
	  CARE_ID, 
	  CARE_STATE_ID, 
	  PERIOD_ID, 
	  CARE_DAY,
	  CARE_HOUR, 
	  CARE_MINUTE, 
	  ASSET_ID,
	  DETAIL,
	  CARE_TYPE_ID,
	  PERIOD_TIME,
	  OFFICIAL_EMP_ID
  FROM 
	  CARE_STATES 
  WHERE
	  CARE_TYPE_ID = 2 AND 
	  ASSET_ID = #attributes.ASSET_ID# AND 
	  IS_ACTIVE = 1
</cfquery>
<cfquery name="GET_CARE_TYPE" datasource="#DSN#">
	SELECT 
		ASSET_CARE_CAT.*
	FROM 
		ASSET_CARE_CAT,
		ASSET_P,
		ASSET_P_CAT
	WHERE
		ASSET_P.ASSETP_ID = #attributes.asset_id# AND
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
		ASSET_P_CAT.ASSETP_CATID = ASSET_CARE_CAT.ASSETP_CAT
</cfquery>
<cfset row = care_states.recordcount>
<table width="98%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td valign="top">
      <table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" height="100%">
        <tr class="color-border">
          <td>
            <table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%">
              <tr class="color-list" valign="middle">
                <td height="25" class="txtboldblue" colspan="5">&nbsp;
			  <a href="javascript://" onclick="gizle_goster_img('list_correspondence1_img12','list_correspondence1_img22','list_correspondence1_menu2');"><img src="/images/listele_down.gif" alt="<cf_get_lang dictionary_id='48612.Ayrıntıları Gizle'>" title="<cf_get_lang dictionary_id='48612.Ayrıntıları Gizle'>" border="0" align="absmiddle" id="list_correspondence1_img12" style="display:;cursor:pointer;"></a>
			  <a href="javascript://" onclick="gizle_goster_img('list_correspondence1_img12','list_correspondence1_img22','list_correspondence1_menu2');"><img src="/images/listele.gif" alt="<cf_get_lang dictionary_id='48613.Ayrıntıları Göster'>" title="<cf_get_lang dictionary_id='48613.Ayrıntıları Göster'>" border="0" align="absmiddle"  id="list_correspondence1_img22" style="display:none;cursor:pointer;"></a>
		     <cf_get_lang dictionary_id="47885.Bakım Bilgisi"></td>
              </tr>
              <tr id="list_correspondence1_menu2">
                <td class="color-row" valign="top">
                  <cfform name="assetp_care_states" enctype="multipart/form-data" action="#request.self#?fuseaction=assetcare.emptypopup_upd_assetp_care_states" method="post">
				  <input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>">
                    <table width="100%">
                      <tr>
                        <td colspan="4" height="100%">
                          <table name="table1" id="table1">
                            <tr class="txtboldblue">
                              <td width="100"><cf_get_lang dictionary_id="47778.Bakım Tipi"></td>
							  <td width="100"><cf_get_lang dictionary_id="57629.Açıklama"></td>
                              <td width="190"><cf_get_lang dictionary_id="47952.Periyot">/<cf_get_lang dictionary_id="57742.Tarih"></td>
							   <td width="100"><cf_get_lang dictionary_id="57569.Görevli"></td>
                              <td width="190"><cf_get_lang dictionary_id="29513.Süre"></td>
							  <td><input name="record_num" id="record_num" type="hidden" value="<cfoutput>#row#</cfoutput>">
							  	  <input type="button" class="eklebuton" title="" onClick="add_row();"></td>
                            </tr>
							<cfoutput query="care_states">
							<tr id="frm_row#currentrow#">
							<td nowrap><input  type="hidden"  value="1"  name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
							<select name="care_type#currentrow#" id="care_type#currentrow#" style="width:100">
								<cfset care_state_id_ = care_states.care_state_id>
                                <cfloop query="get_care_type">
                                	<option value="#asset_care_id#" <cfif len(care_state_id_) and (care_state_id_ eq asset_care_id)>selected</cfif>>#asset_care#</option>
                                </cfloop>
							</select></td>
							<td nowrap><input  type="text"  value="<cfif len(detail)><cfoutput>#detail#</cfoutput></cfif>"  name="aciklama#currentrow#" id="aciklama#currentrow#" style="width:100"></td>
							<td nowrap>
                            <select name="care_type_period#currentrow#" id="care_type_period#currentrow#">
                                <option value=""><cf_get_lang dictionary_id="47952.Periyot"></option>
                                <option value="1" <cfif len(period_id) and (period_id eq 1)>selected</cfif>><cf_get_lang dictionary_id="47620.Haftada Bir"></option>
                                <option value="2" <cfif len(period_id) and (period_id eq 2)>selected</cfif>><cf_get_lang dictionary_id="48518.15 Günde Bir"></option>
                                <option value="3" <cfif len(period_id) and (period_id eq 3)>selected</cfif>><cf_get_lang dictionary_id="47623.Ayda Bir"></option>
                                <option value="4" <cfif len(period_id) and (period_id eq 4)>selected</cfif>><cf_get_lang dictionary_id="48519.2 Ayda Bir"></option>
                                <option value="5" <cfif len(period_id) and (period_id eq 5)>selected</cfif>><cf_get_lang dictionary_id="48520.3 Ayda Bir"></option>
                                <option value="6" <cfif len(period_id) and (period_id eq 6)>selected</cfif>><cf_get_lang dictionary_id="48521.4 Ayda Bir"></option>
                                <option value="7" <cfif len(period_id) and (period_id eq 7)>selected</cfif>><cf_get_lang dictionary_id="48522.6 Ayda Bir"></option>
                                <option value="8" <cfif len(period_id) and (period_id eq 8)>selected</cfif>><cf_get_lang dictionary_id="47950.Yılda Bir"></option>
							</select>
							<input  type="text" name="care_date#currentrow#" id="care_date#currentrow#" style="width:65" value="<cfif len(period_time)><cfoutput>#dateformat(period_time,dateformat_style)#</cfoutput></cfif>">
                            <cf_wrk_date_image date_field="care_date#currentrow#"></td>
						<td nowrap><input type="hidden" name="official_emp_id#currentrow#" id="official_emp_id#currentrow#" value="<cfif len(official_emp_id)><cfoutput>#official_emp_id#</cfoutput></cfif>">
						<input type="text" name="official_emp#currentrow#" id="official_emp#currentrow#" value="<cfif len(official_emp_id)><cfoutput>#get_emp_info(official_emp_id,1,0)#</cfoutput></cfif>">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=assetp_care_states.official_emp_id#currentrow#&field_name=assetp_care_states.official_emp#currentrow#','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
						<td>
                        <select name="gun#currentrow#" id="gun#currentrow#">
							<cfoutput>
                            <option value=""><cf_get_lang dictionary_id="57490.Gün"></option>
                            <cfloop from="1" to="30" index="i">
                            	<option value="#i#" <cfif len(care_day) and (care_day eq i)>selected</cfif>>#i#</option>
                            </cfloop>
						</cfoutput>
						</select>
						<select name="saat#currentrow#" id="saat#currentrow#">
                            <option value=""><cf_get_lang dictionary_id="57491.Saat"></option>
                            <cfoutput>
                                <cfloop from="0" to="24" index="i">
                                    <option value="#i#" <cfif len(care_hour) and (care_hour eq i)>selected</cfif>>#i#</option>
                                </cfloop>
                            </cfoutput>
						</select>
						<select name="dakika#currentrow#" id="dakika#currentrow#">
                            <option value=""><cf_get_lang dictionary_id="58127.Dakika"></option>
                            <cfoutput>
                                <cfloop from="0" to="60" index="i" step="5">
                                <option value="#i#" <cfif len(care_minute) and (care_minute eq i)>selected</cfif>>#i#</option>
                                </cfloop>
                            </cfoutput>
                        </select>
						</td>
						<td><a style="cursor:pointer" onclick="sil(#currentrow#);"><img  src="images/delete_list.gif" alt="Sil" border="0" align="absmiddle"></a></td>
							</tr>
							</cfoutput>
                          </table>
                        </td>
                      </tr>
                      <tr>
                        <td colspan="3">&nbsp;</td>
                        <td colspan="2"><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                      </tr></cfform>
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
<script type="text/javascript">
	row_count=<cfoutput>#row#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("assetp_care_states.row_kontrol"+sy);
		my_element.value=0;

		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function kontrol_et()
	{
		if(row_count ==0)
			return false;
		else
			return true;
	}

	function add_row()
	{
			row_count++;
			var newRow;
			var newCell;
			
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
						
			document.assetp_care_states.record_num.value=row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><select name="care_type' + row_count +'" style="width:100"><cfoutput query="get_care_type"><option value="#asset_care_id#">#asset_care#</option></cfoutput></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="text"  value=""  name="aciklama' + row_count +'" style="width:100">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			
			newCell.setAttribute("id","care_date" + row_count + "_td");
			newCell.innerHTML = '<select name="care_type_period' + row_count +'"><option value="">Periyot</option><option value="1">Haftada Bir</option><option value="2">15 Günde Bir</option><option value="3">Ayda Bir</option><option value="4">2 Ayda Bir</option><option value="5">3 Ayda Bir</option><option value="6">4 Ayda Bir</option><option value="7">6 Ayda Bir</option><option value="8">Yılda Bir</option></select><input type="text" name="care_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="">';
			wrk_date_image('care_date' + row_count);
						
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="official_emp_id' + row_count +'"><input type="text" name="official_emp' + row_count +'"><a href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=assetp_care_states.official_emp_id' + row_count +'&field_name=assetp_care_states.official_emp' + row_count +'\',\'list\');"><img src="/images/plus_thin.gif" border="0" alt="" align="absmiddle"></a>';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="gun' + row_count +'"><cfoutput><option value="">Gün</option><cfloop from="1" to="30" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select><select name="saat' + row_count +'"><option value="">Saat</option><cfoutput><cfloop from="0" to="24" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select><select name="dakika'+ row_count +'"><option value="">Dk</option><cfoutput><cfloop from="0" to="60" index="i" step="5"><option value="#i#">#i#</option></cfloop></cfoutput></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0" alt="Sil" align="absmiddle"></a>';		
							
	}		

	function pencere_ac(no)
	{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=assetp_care_states.care_date' + no ,'date');
	}
</script>
