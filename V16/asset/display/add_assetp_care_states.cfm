<cfquery name="GET_CARE_TYPE" datasource="#DSN#">
	SELECT 
		ASSET_CARE_CAT.*
	FROM 
		ASSET_CARE_CAT,
		ASSET_P,
		ASSET_P_CAT
	WHERE
		ASSET_P.ASSETP_ID = #attributes.assetp_id# AND
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
		ASSET_P_CAT.ASSETP_CATID = ASSET_CARE_CAT.ASSETP_CAT
</cfquery>
<table width="98%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td valign="top">
      <table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" height="100%">
        <tr class="color-border">
          <td>
            <table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%">
              <tr class="color-list" valign="middle">
                <td height="25" class="txtboldblue" colspan="5">&nbsp;
			  <a href="javascript://" onclick="gizle_goster_img(list_correspondence1_img12,list_correspondence1_img22,list_correspondence1_menu2);"><img src="/images/listele_down.gif" alt="Ayrıntıları Gizle" title="Ayrıntıları Gizle" border="0" align="absmiddle" id="list_correspondence1_img12" style="display:;cursor:pointer;"></a>
			  <a href="javascript://" onclick="gizle_goster_img(list_correspondence1_img12,list_correspondence1_img22,list_correspondence1_menu2);"><img src="/images/listele.gif" alt="Ayrıntıları Göster" title="Ayrıntıları Göster" border="0" align="absmiddle"  id="list_correspondence1_img22" style="display:none;cursor:pointer;"></a>
		      Bakım Bilgisi</td>
              </tr>
              <tr id="list_correspondence1_menu2">
                <td class="color-row" valign="top">
                  <cfform name="assetp_care_states" enctype="multipart/form-data" action="#request.self#?fuseaction=assetcare.emptypopup_add_assetp_care_states&asset_id=#attributes.asset_id#" method="post">
				  <input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>">
                    <table width="100%">
                      <tr>
                        <td colspan="4" height="100%">
                          <table name="table1" id="table1">
                            <tr class="txtboldblue">
                              <td width="100">Bakım Tipi</td>
							  <td width="150">Açıklama</td>
                              <td width="130">Periyot / Tarih</td>
							   <td width="80">Görevli</td>
                              <td width="100">Süre</td>
							  <td><input name="record_num" id="record_num" type="hidden" value="0">
							    <input type="button" class="eklebuton" title="" onClick="add_Row();">
							  </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr>
                        <td colspan="3">&nbsp;</td>
                        <td colspan="2"><cf_workcube_buttons is_upd='0'></td>
                      </tr>
                    </table>
                  </cfform>
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
	row_count=0;
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
			newCell.innerHTML = '<select name="care_type_period' + row_count +'"><option value="">Periyot</option><option value="1">Haftada Bir</option><option value="2">15 Günde Bir</option><option value="3">Ayda Bir</option><option value="4">2 Ayda Bir</option><option value="5">3 Ayda Bir</option><option value="6">4 Ayda Bir</option><option value="7">6 Ayda Bir</option><option value="8">Yılda Bir</option></select><input  type="text"  name="care_date' + row_count +'" style="width:65" class="text" maxlength="10" value="">';
			wrk_date_image('care_date' + row_count);
						
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="official_emp_id' + row_count +'"><input type="text" name="official_emp' + row_count +'"><a href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=assetp_care_states.official_emp_id' + row_count +'&field_name=assetp_care_states.official_emp' + row_count +'\',\'list\');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="gun' + row_count +'"><cfoutput><option value="">Gün</option><cfloop from="1" to="30" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select><select name="saat' + row_count +'"><option value="">Saat</option><cfoutput><cfloop from="0" to="24" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select><select name="dakika'+ row_count +'"><option value="">Dakika</option><cfoutput><cfloop from="0" to="60" index="i" step="5"><option value="#i#">#i#</option></cfloop></cfoutput></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0" align="absmiddle"></a>';		
							
	}		

	function pencere_ac(no)
	{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=assetp_care_states.care_date' + no ,'date');
	}
</script>