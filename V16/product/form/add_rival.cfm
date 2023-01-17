<cfquery name="BRANCHES" datasource="#DSN#">
	SELECT BRANCH_ID, BRANCH_NAME FROM	BRANCH ORDER BY BRANCH_NAME
	</cfquery>
	
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cfsavecontent variable="head"><cf_get_lang dictionary_id='45917.Rakip ekle'></cfsavecontent>
			<cf_box  title="#head#" popup_box="1" >
				<cfform name="add_rival" action="#request.self#?fuseaction=product.emptypopup_add_rival" >
					<input type="hidden" name="counter" id="counter" value="">
					<cf_box_elements vertical="1">
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-status">
								<label class="col col-4  xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
								<label class="col col-8 col-xs-12">
									<input type="checkbox" name="status" id="status" checked>
								</label>
							</div>
							<div class="form-group" id="item-rival_name">
								<label class="col col-4 xs-12"><cf_get_lang dictionary_id='37327.Rakip Adı'>*</label>
								<div class="col col-8 col-xs-12">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='37417.Rakip Adı girmelisiniz'></cfsavecontent>
									<cfinput type="Text" name="rival_name" value="" maxlength="100" required="Yes" message="#message#">                               
								</div>
							</div>
							<div class="form-group" id="item-rival_detail">
								<label class="col col-4 xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
								<div class="col col-8 col-xs-12">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
									<textarea name="rival_detail" id="rival_detail" cols="60" rows="2" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>                                   
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
								<tbody name="table1" id="table1"></tbody>
							</cf_ajax_list>
						</div>
					</cf_box_elements>
					<cf_box_footer>								
						<cf_workcube_buttons type_format='1' is_upd='0'>
					</cf_box_footer>
				</cfform>
			</cf_box>
		</div>
	<script type="text/javascript">
		row_count=0;
		function sil(sy)
		{
			var my_element=eval("add_rival.row_kontrol"+sy);
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
				document.add_rival.record_num.value = row_count;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang_main no ='51.sil'>"></i></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<div class="form-group"><div class="col col-12"><div class="input-group"><input type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><input type="hidden" name="branch_id' +row_count+'"><input type="text" name="branch_name' + row_count +'" readonly="yes"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac(' + row_count + ');"></span></div></div></div>';
		}
		function pencere_ac2(no)
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_sales_zone&field_name=add_rival.sales_zone'+no+'&field_id=add_rival.sales_zone_id'+no,'medium');
			}
			
		function pencere_ac(no)
			{
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&is_form_submitted=1&field_branch_name=add_rival.branch_name'+no+'&field_branch_id=add_rival.branch_id'+no);
			}
	</script>