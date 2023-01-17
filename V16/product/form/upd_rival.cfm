<cfquery name="get_rivals" datasource="#dsn#">
	SELECT
		R_ID,
		RIVAL_NAME,
		STATUS,
		RIVAL_DETAIL,
		IS_GROUP,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE
	FROM
		SETUP_RIVALS
	WHERE
		R_ID = #attributes.r_id#
</cfquery>
<cfquery name="get_branch_zone" datasource="#dsn#">
	SELECT 
		SRB.R_ID, 
		SRB.BRANCH_ID,
		B.BRANCH_NAME
	FROM 
		SETUP_RIVALS_BRANCH SRB,
		BRANCH B
	WHERE 
		SRB.BRANCH_ID = B.BRANCH_ID AND
		SRB.R_ID = #attributes.r_id#  
</cfquery>
<cfset row = get_branch_zone.recordcount>
<cfparam name="attributes.is_analysis" default="0">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='30193.Rakipler'></cfsavecontent>
		<cfif attributes.is_analysis eq 0>
			<cf_box scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" title="#head#">
				<cfform name="upd_rival" action="#request.self#?fuseaction=product.emptypopup_upd_rival" method="post">
					<input type="hidden" name="rival_id" id="rival_id" value="<cfoutput>#attributes.r_id#</cfoutput>">
					<input type="hidden" name="r_id" id="r_id" value="<cfoutput>#attributes.r_id#</cfoutput>">
					<input type="hidden" name="counter" id="counter" value="">
						<cf_box_elements vertical="1">
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
								<div class="form-group" id="item-status">
									<label class="col col-4 col- xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
									<label class="col col-8 col-xs-12">
										<input type="Checkbox" name="status" id="status" value="1" <cfif get_rivals.status eq 1>checked</cfif>>
									</label>
								</div>
								<div class="form-group" id="item-rival_name">
									<label class="col col-4 col- xs-12"><cf_get_lang dictionary_id='37327.Rakip Adı'>*</label>
									<div class="col col-8 col-xs-12">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='37417.Rakip Adı girmelisiniz'></cfsavecontent>
										<cfinput type="Text" name="rival_name" value="#get_rivals.rival_name#" maxlength="100" required="Yes" message="#message#">
									</div>
								</div>
								<div class="form-group" id="item-rival_detail">
									<label class="col col-4 col- xs-12"><cf_get_lang dictionary_id='57629.açıklama'></label>
									<div class="col col-8 col-xs-12">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
										<textarea name="rival_detail" id="rival_detail" cols="60" rows="3" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_rivals.rival_detail#</cfoutput></textarea> 
									</div>
								</div>
							</div>
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="2" sort="true">
								<cf_ajax_list>
									<thead>
										<tr>
											<th width="20"><a href="javascrript://" onclick="add_row();"  title="<cf_get_lang_main no ='170.Ekle'>"><i class="fa fa-plus"></i></a></th>
											<th><cf_get_lang dictionary_id='37593.Rekabet İçerisinde Olduğu Şubeler'><input name="record_num" id="record_num" type="hidden" value="0"></th>
										</tr>
									</thead>
									<tbody name="table1" id="table1">
									<cfoutput query="get_branch_zone">
										<tr id="frm_row#currentrow#">
											<td><input  type="hidden"  value="1"  name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a onclick="sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang_main no ='51.sil'>"></i></a></td>
											<td>
												<div class="form-group">
													<div class="input-group">
														<input type="text" name="branch_name#currentrow#" id="branch_name#currentrow#" value="#branch_name#"  readonly="yes">
														<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_branches&is_form_submitted=1&field_branch_name=upd_rival.branch_name#currentrow#&field_branch_id=upd_rival.branch_id#currentrow#');"></span>
														<input type="hidden" name="branch_id#currentrow#" id="branch_id#currentrow#" value="#branch_id#">
													</div>
												</div>
											</td>
										</tr>
									</cfoutput>
									</tbody>
								</cf_ajax_list>
							</div>
						</cf_box_elements>
					
						<cf_box_footer>
								<cf_record_info query_name="get_rivals">
								<cf_workcube_buttons is_upd='1'  is_delete='0'>
								</cf_box_footer>
				</cfform>
			</cf_box>
		<cfelse>
			<cf_get_member_analysis action_type='RIVAL' action_type_id="#attributes.r_id#" rival_id='#attributes.r_id#' is_analysis_link="0" closable="1" > 
		</cfif>
		<!--- Analizler --->
		
</div>
<script type="text/javascript">
	row_count=<cfoutput>#row#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("upd_rival.row_kontrol"+sy);
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
			document.upd_rival.record_num.value = row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang_main no ='51.sil'>"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="col col-12"><div class="input-group"><input type="hidden"  value="1"  name="row_kontrol' +row_count+'"><input type="text" name="branch_name' + row_count +'" readonly="yes"><input type="hidden" name="branch_id' +row_count+'"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac(' + row_count + ');"></span></div></div></div>';
	}
	
	function pencere_ac2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_sales_zone&field_name=upd_rival.sales_zone'+no+'&field_id=upd_rival.sales_zone_id'+no,'medium');
	}
	
	function pencere_ac(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=upd_rival.branch_name'+no+'&is_Form_submitted=1&field_branch_id=upd_rival.branch_id'+no);
	}

</script>
