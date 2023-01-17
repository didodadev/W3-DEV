<cfquery name="GET_POS_CAT_REQ" datasource="#DSN#">
  SELECT 
    * 
  FROM 
    POSITION_REQUIREMENTS 
  WHERE 
	POSITION_CAT_ID = #attributes.POSITION_CAT_ID#
</cfquery>
<cfset old_requirements = valuelist(GET_POS_CAT_REQ.REQ_TYPE_ID)>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Pozisyon Gereklilikleri','55979')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform  name="add_position_cat_requirement" action="#request.self#?fuseaction=hr.emptypopup_add_position_cat_requirements&ilk=0&position_cat_id=#attributes.position_cat_id#" method="post">
        <input type="hidden" name="record_num" id="record_num" value="">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='55980.Gereklilik Tipi'></th>
                    <th><cf_get_lang dictionary_id='58984.Puan'></th>
                    <th width="15" class="text-center">
                        <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_pos_req_types&position_cat_id=#attributes.POSITION_CAT_ID#&OLD_REQS=#old_requirements#</cfoutput>');"> <i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a> 
                    </th> 
                </tr>
            </thead>
            <tbody id="table1">
            <cfif GET_POS_CAT_REQ.RECORDCOUNT>
                <cfoutput query="GET_POS_CAT_REQ">
                    <cfquery name="GET_REQ_TYPE" datasource="#DSN#">
                        SELECT REQ_TYPE FROM POSITION_REQ_TYPE WHERE REQ_TYPE_ID = #REQ_TYPE_ID#
                    </cfquery>
                    <tr>
                        <td>
                            <input type="hidden" name="req_type_id" id="req_type_id" value="#REQ_TYPE_ID#">
                            <input type="text" name="req_type" id="req_type" value="#GET_REQ_TYPE.REQ_TYPE#" style="width:170px;" readonly>
                        </td>
                        <td><input type="text" name="coefficient" id="coefficient" value="#GET_POS_CAT_REQ.COEFFICIENT#" style="width:50px;"></td>
                        <td class="text-center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.emptypopup_del_pos_req&req_id=#REQ_ID#','large');"> <i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                    </tr>
                </cfoutput>
            </cfif>
            </tbody> 
        </cf_grid_list>
        <cf_box_footer><cf_workcube_buttons is_upd='0'></cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	row_count=0;
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
			document.add_position_cat_requirement.record_num.value=row_count;			
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="req_type_id_' + row_count + '"><input type="text" name="req_type_' + row_count + '" id="req_type' + row_count + '" style="width:170px;"  class="formfieldright"><a onclick="javascript:opage(' + row_count +');"><img src="/images/plus_list.gif" border="0" align="absmiddle" style="cursor:pointer;"></a>';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="coefficient_' + row_count + '" id="coefficient' + row_count + '" style="width:50px;"   value="" class="formfieldright">';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '';
						
	}		

	function opage(deger)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_pos_req_types&field_id=add_pos_requirement.req_type_id_' + deger + '&field_name=add_pos_requirement.req_type_' + deger,'list');
	}	
	
</script>
