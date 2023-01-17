<cfquery name="GET_POS_REQ" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		POSITION_REQUIREMENTS 
	WHERE 
		<!---REQ_ID = #attributes.REQ_ID#--->
		POSITION_ID = #attributes.POSITION_ID#
</cfquery>
<cfset OLD_REQS = VALUELIST(GET_POS_REQ.REQ_TYPE_ID)>
<cfquery name="GET_POS_CAT_REQ" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		POSITION_REQUIREMENTS 
	WHERE 
		<!---REQ_ID = #attributes.REQ_ID#--->
		POSITION_CAT_ID = #attributes.position_cat_id#
</cfquery>
<cfloop query="GET_POS_CAT_REQ">
	<cfset OLD_REQS = ListAppend(OLD_REQS,#GET_POS_CAT_REQ.REQ_TYPE_ID#,',')>
</cfloop>

<cfquery name="get_pos" datasource="#dsn#">
	SELECT
		POSITION_NAME,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_ID = #attributes.POSITION_ID#
</cfquery>
<cfsavecontent variable="right">
	<cfif GET_POS_CAT_REQ.recordcount or GET_POS_REQ.recordcount>
		<cfif not listfindnocase(denied_pages,'hr.popup_pos_fit_employees')>
		<cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_pos_fit_employees&position_id=#attributes.position_id#','medium');"><i class="fa fa-male" style="color:red;" class="text-center" title="<cf_get_lang dictionary_id='32238.Yeterliliklere Uygun Çalışanlar'>" alt="<cf_get_lang dictionary_id='32238.Yeterliliklere Uygun Çalışanlar'>"></i></a></cfoutput>
		</cfif>
	</cfif>
</cfsavecontent>
<cfparam name="attributes.modal_id" default="">
<cf_box id="box_add_pos_requirement" right_images="#right#" title="#getLang('','Yeterlilik Formu',55448)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_pos_requirement" action="#request.self#?fuseaction=hr.emptypopup_add_pos_requirement&ilk=0" method="post">
		<input type="hidden" name="record_num" id="record_num" value="">
		<!--- action="#request.self#?fuseaction=hr.emptypopup_add_negligence" --->
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-group_name">
					<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57570.Ad Soyadı'> :</label>
					<div class="col col-8 col-xs-12">
						<input type="hidden" name="position_id" id="position_id" value="<cfoutput>#URL.POSITION_ID#</cfoutput>">
						<cfoutput>#get_pos.employee_name# #get_pos.employee_surname#</cfoutput>
					</div>
				</div>
				<div class="form-group" id="item-group_name">
					<label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='58497.Pozisyon'> :</label>
					<div class="col col-8 col-xs-12">
						<cfoutput>#get_pos.position_name#</cfoutput>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_grid_list table_width="450"> 
			<thead>
				<tr>
					<th class="text-center" width="20">
						<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_pos_req_types&position_id=#attributes.POSITION_ID#&OLD_REQS=#OLD_REQS#</cfoutput>','','ui-draggable-box-small');"><i class="fa fa-plus" title="<cf_get_lang no='118.Yeterlilik Ekle'>"></i></a> 
					</th> 
					<th width="100"><cf_get_lang dictionary_id='55306.Yeterlilik Tipi'></th>
					<th><cf_get_lang dictionary_id='58456.Oran'></td>
				</tr>
				<cfif GET_POS_CAT_REQ.RECORDCOUNT>
					<cfoutput query="GET_POS_CAT_REQ">
						<cfquery name="GET_REQ_TYPE" datasource="#DSN#">
							SELECT REQ_TYPE FROM POSITION_REQ_TYPE WHERE REQ_TYPE_ID = #REQ_TYPE_ID#
						</cfquery>
						<tr>
							<th></th>
							<th><input type="text" name="req_type_cat" id="req_type_cat" value="#GET_REQ_TYPE.REQ_TYPE#" readonly></th>
							<th><input type="text" name="coefficient_cat" id="coefficient_cat" value="#GET_POS_CAT_REQ.COEFFICIENT#" ></th>
						</tr>
					</cfoutput>
				</cfif>
			</thead>
			<cfif GET_POS_REQ.RECORDCOUNT>
				<tbody id="table1">
					<cfoutput query="GET_POS_REQ">
						<cfquery name="GET_REQ_TYPE" datasource="#DSN#">
							SELECT REQ_TYPE FROM POSITION_REQ_TYPE WHERE REQ_TYPE_ID = #REQ_TYPE_ID#
						</cfquery>
						<tr>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.emptypopup_del_pos_req&req_id=#REQ_ID#','large');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
							<td>
								<div class="form-group">
									<input type="hidden" name="req_type_id" id="req_type_id" value="#REQ_TYPE_ID#">
									<input type="text" name="req_type" id="req_type" value="#GET_REQ_TYPE.REQ_TYPE#" readonly>
								</div>
							</td>
							<td>
								<div class="form-group">
									<input type="text" name="coefficient" id="coefficient" value="#COEFFICIENT#" onkeyup="isNumber(this);" onblur="isNumber(this);" maxlength="3">
								</div>
							</td>
						</tr>
					</cfoutput>
				</tbody>
			</cfif> 
		</cf_grid_list>			
		<cf_box_footer>
			<cf_workcube_buttons type_format="1" is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_pos_requirement' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
	</cfform>
</cf_box>
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
			document.add_pos_requirement.record_num.value=row_count;			
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="req_type_id_' + row_count + '"><input type="text" name="req_type_' + row_count + '" id="req_type' + row_count + '" class="formfieldright"><a onclick="javascript:opage(' + row_count +');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="coefficient_' + row_count + '" id="coefficient' + row_count + '" onkeyup="isNumber(this);" maxlength="3" onblur="isNumber(this);"  value="" class="formfieldright">';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '';
						
	}		

	function opage(deger)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_pos_req_types&field_id=add_pos_requirement.req_type_id_' + deger + '&field_name=add_pos_requirement.req_type_' + deger,'list');
	}	
	
</script>
