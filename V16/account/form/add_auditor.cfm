<cfparam name="attributes.employee_id" default="#session.ep.userid#">
<cfparam name="attributes.employee_name" default="#session.ep.name# #session.ep.surname#">
<cfparam name="attributes.wizard_date" default="#now()#">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_wizard" id="add_wizard" method="post">
			<cf_box_elements>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-wizard_name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="wizard_name" id="wizard_name" value="" maxlength="50" placeholder="<cf_get_lang dictionary_id='63109.Sihirbaz ismi giriniz'>" required>
						</div>
					</div>
					<div class="form-group" id="item-wizard_designer">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36183.Tasarlayan'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
								<input type="text" name="employee_name" id="employee_name" value="<cfoutput>#attributes.employee_name#</cfoutput>" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" value="" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_wizard.employee_id&field_name=add_wizard.employee_name&select_list=1');"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-wizard_stage">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cf_workcube_process slct_width="180px;" is_upd = "0" is_detail = "0">
						</div>
					</div>
					<div class="form-group" id="item-process_date">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang_main no='330.Tarih'>!</cfsavecontent>
								<cfinput type="text" name="process_date" value="#dateformat(attributes.wizard_date,dateformat_style)#" maxlength="10" required="Yes" message="#message#" validate="#validate_style#" onblur="change_money_info('add_wizard','process_date');">
								<span class="input-group-addon"><cf_wrk_date_image date_field="process_date"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-run_period">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64429.Denetim Periyodu'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name = "run_period" id = "run_period">
								<option value = "0"><cf_get_lang dictionary_id='58500.Manuel'></option>
								<option value = "1"><cf_get_lang dictionary_id='58724.Ay'></option>
								<option value = "3">3 <cf_get_lang dictionary_id='58724.Ay'></option>
								<option value = "6">6 <cf_get_lang dictionary_id='58724.Ay'></option>
								<option value = "12">12 <cf_get_lang dictionary_id='58724.Ay'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-period_day">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57490.Gün'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="number" name="period_day" id="period_day">
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<!--- <cfquery name = "getProcessCat" datasource = "#dsn3#">
						SELECT PROCESS_CAT_ID, PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 13
					</cfquery>
					<div class="form-group" id="item-card_process_cat">
						<label class="col col-4 col-xs-12">İşlem Tipi</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group col-12">
								<select name = "card_process_cat" id = "card_process_cat">
									<option value = "">Seçiniz</option>
									<cfoutput query = "getProcessCat">
										<option value = "#process_cat_id#">#process_cat#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div> --->
					<div class="form-group" id="item-target_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64430.Çalışma Defteri'></label>
						<div class="col col-8 col-xs-12">
							<select name = "target_type" id = "target_type">
								<option value = ""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value = "0"><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
								<option value = "1"><cf_get_lang dictionary_id='64431.IFRS'></option>
								<option value = "2"><cf_get_lang dictionary_id='63097.Birleşik'></option>
							</select>
						</div>
					</div>
				</div>						
			</cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<div class="ui-card">
					<input type="hidden" name="rowCount" id="rowCount" value="0">
					<div class="ui-card-add-btn"><a href="javascript://" onClick="addRow();"><i class="icon-pluss" alt="<cf_get_lang dictionary_id='57707.Satır Ekle'>" title="<cf_get_lang dictionary_id='57707.Satır Ekle'>"></i></a></div>
					<div id="table_list" class="ui-form-list">

					</div>			
				</div>
			</div>		
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function="kontrol()">
				</cf_box_footer>
			</div>
		</cfform>
	</cf_box>
</div>


<script type="text/javascript">
	rowCount = 0;

	function kontrol()
	{
		if($("#wizard_name").val() == '') {
			alert('<cf_get_lang dictionary_id='63109.Sihirbaz ismi giriniz'>!');
			return false;
		}
		if($("#employee_id").val() == '' || $("#employee_name").val() == '') {
			alert('<cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='36183.Tasarlayan'>!');
			return false;
		}
		if($("#process_date").val() == '') {
			alert('<cf_get_lang dictionary_id='61893.Tarih Giriniz'>!');
			return false;
		}
		if(parseInt($("#rowCount").val()) == 0) {
			alert('<cf_get_lang dictionary_id='63110.Lütfen Blok Ekleyiniz'>!');
			return false;
		} else {
			for( i = 1; i <= parseInt($("#rowCount").val()); i++ ) {
				if($("#row_kontrol_" + i).val() == 1) {
					rowNum = i;

					accNum1 = parseInt($('#counter_' + rowNum + '_1').val());
					accNum2 = parseInt($('#counter_' + rowNum + '_2').val());

					for( j = 1; j <= 2; j++ ) {
						for(k = 1; k <= eval('accNum' + j); k++ ) {
							if($('#acc_control_' + rowNum + '_' + j + '_' + k).val() == 0) {
								$('#counter_' + rowNum + '_' + j).val(parseInt($('#counter_' + rowNum + '_' + j).val()) - 1);
							}
						}
					}

					if(accNum1 == 0 || accNum2 == 0) {
						alert('<cf_get_lang dictionary_id='63105.1. ve 2. blokları boş bırakmayınız'>!');
						return false;
					}

					for( j = 1; j <= 2; j++ ) {
						colNum = j;

						columnTotal = 0;
						for(k = 1; k <= eval('accNum' + j); k++ ) {
							if($('#acc_control_' + rowNum + '_' + j + '_' + k).val() == 1) {
								if($('#acc_' + rowNum + '_' + colNum + '_' + k).val() == '') {
									alert('<cf_get_lang dictionary_id='63106.Muhasebe Kodu alanlarını boş bırakmayınız'>!');
									return false;
								}
								columnTotal = columnTotal + toFloat($('#rate_' + rowNum + '_' + colNum + '_' + k).val());
							}
						}
					}
				}
			}
		}
		return true;
	}
	function addRow()
	{
		rowCount++;
		add_wizard.rowCount.value = rowCount;
		var newRow;
		var newCell;
		newRow = $('<div />');
		newRow.attr({"id":"block_row_" + rowCount,"class":"ui-card-item"});
		newCell = '<input type = "hidden" id = "row_kontrol_' + rowCount + '" name = "row_kontrol_' + rowCount + '" value = "1"><div class="ui-card-item-hide"><a href="javascript://" onClick="delRow(' + rowCount + ');"><i class="icon-minus" alt="<cf_get_lang_main no ='286.Sıfırla'>"></i></a></div>';
		newRow.append(newCell);
		newCell = 
		'<div class="col col-12 col-xs-12 acc-top">'+
			'<div class="acc-block-name col col-6"><div class="form-group col col-3"><div class="input-group"><span class="input-group-addon">'+rowCount+'</span><input type="text" name="block_name_left_' + rowCount + '" id="block_name_left_' + rowCount + '" placeholder="<cf_get_lang dictionary_id='64340.Blok Adı'>"></div></div></div>'+
			'<div class="acc-block-name col col-6"><div class="form-group col col-3"><input type="text" name="block_name_right_' + rowCount + '" id="block_name_right_' + rowCount + '" placeholder="<cf_get_lang dictionary_id='64340.Blok Adı'>"></div></div>'+
		'</div>';
		newRow.append(newCell);
		newCell = '<div class="acc-body" id = "block_detail_' + rowCount + '"></div>';
		newRow.append(newCell);
		$('#table_list').append(newRow);
		createBlock(rowCount);
	}

	function delRow(block_id) {
		$("#row_kontrol_" + block_id).val(0);
		$("#block_row_" + block_id).hide();
	}

	function pencere_ac(acc_input) {
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=add_wizard.' + acc_input, 'list');
	}

	function open_modal(rowNum, colNum, accNum) {
		account_code = $("#acc_"+ rowNum + '_' + colNum + '_' + accNum).val();
		if(account_code != '') cfmodal('<cfoutput>#request.self#</cfoutput>?fuseaction=account.wizardActionType&type_id='+rowNum+'_'+colNum+'_'+accNum+'&account_id='+account_code,'warning_modal');
		else alert("<cf_get_lang dictionary_id='47351.Hesap Kodu Seçin'>"); return false;
	}

	function delAcc(row,col,acc) {
		$('#acc_control_' + row + '_' + col + '_' + acc).val(0);
		$('#div_' + row + '_' + col + '_' + acc).hide();
	}

	function addAccount(rowNum, colNum) {
		accNum = parseInt($('#counter_' + rowNum + '_' + colNum).val()) + 1;

		acc_div = $("<div />");
		acc_div.attr('class','acc-body-item');
		acc_div.attr('id','div_' + rowNum + '_' + colNum + '_' + accNum);

		//1

		acc_form_grp4 = $("<div />");
		acc_form_grp4.attr('class','form-group pa col col-1');
		acc_form_grp4.appendTo(acc_div);

		acc_inpt_grp4 = $("<div />");
		acc_inpt_grp4.attr('class','input-group');
		acc_inpt_grp4.appendTo(acc_form_grp4);

		acc_del = $("<a />");
		acc_del.attr("onClick","delAcc(" + rowNum + "," + colNum + "," + accNum + ")");
		acc_del.append('<i class="icon-minus"></i>');
		acc_del.appendTo(acc_inpt_grp4);

		//2
		
		acc_form_grp = $("<div />");
		acc_form_grp.attr('class','form-group col col-3');
		acc_form_grp.appendTo(acc_div);

		acc_inpt_grp = $("<div />");
		acc_inpt_grp.attr('class','input-group');
		acc_inpt_grp.appendTo(acc_form_grp);
		
		acc_inpt_grp.append('<input type = "hidden" id = "acc_control_' + rowNum + '_' + colNum + '_' + accNum + '" name = "acc_control_' + rowNum + '_' + colNum + '_' + accNum + '" value = "1">');

		acc_input = $("<input />").attr('id','acc_' + rowNum + '_' + colNum + '_' + accNum);
		acc_input.attr('name','acc_' + rowNum + '_' + colNum + '_' + accNum);
		acc_input.attr('type','text');
		acc_input.attr('readonly',true);
		acc_input.appendTo(acc_inpt_grp);

		acc_selector= $("<span />");
		acc_selector.attr('class','input-group-addon btnPointer icon-ellipsis');
		acc_selector.attr('onClick','pencere_ac("acc_' + rowNum + '_' + colNum + '_' + accNum + '");');
		acc_selector.appendTo(acc_inpt_grp);

		// 5

		acc_action_grp = $("<div />");
		acc_action_grp.attr('class','form-group col col-2');
		acc_action_grp.appendTo(acc_div);

		action_inpt_grp = $("<div />");
		action_inpt_grp.attr('class','input-group');
		action_inpt_grp.appendTo(acc_action_grp);

		action_box = $("<input />").attr('id','action_type_' + rowNum + '_' + colNum + '_' + accNum);
		action_box.attr('name','action_type_' + rowNum + '_' + colNum + '_' + accNum);
		action_box.attr('type','text');
		action_box.attr('title','<cf_get_lang dictionary_id='58770.İşlem Tipi Seçiniz'>');
		action_box.attr('readonly',true);

		action_box_hidden = $("<input />").attr('id','action_type_hidden_' + rowNum + '_' + colNum + '_' + accNum);
		action_box_hidden.attr('name','action_type_hidden_' + rowNum + '_' + colNum + '_' + accNum);
		action_box_hidden.attr('type','hidden');
		action_box_hidden.attr('readonly',true);

		action_box_hidden.appendTo(action_inpt_grp);
		action_box.appendTo(action_inpt_grp);
		
		action_box_selector2= $("<span />");
		action_box_selector2.attr('class','input-group-addon btnPointer');
		action_box_selector2.attr('onclick','open_modal('+rowNum+', '+colNum+', '+accNum+');');
		action_box_selector2.append('<i class="fa fa-plug" title="<cf_get_lang dictionary_id='58770.İşlem Tipi Seçiniz'>"></i>');
		action_box_selector2.appendTo(action_inpt_grp);


		//3

		acc_form_grp2 = $("<div />");
		acc_form_grp2.attr('class','form-group col col-2');
		acc_form_grp2.appendTo(acc_div);

		acc_inpt_grp2 = $("<div />");
		acc_inpt_grp2.attr('class','input-group');
		acc_inpt_grp2.appendTo(acc_form_grp2);

		rate_box = $("<input />").attr('id','rate_' + rowNum + '_' + colNum + '_' + accNum);
		rate_box.attr('name','rate_' + rowNum + '_' + colNum + '_' + accNum);
		rate_box.attr('type','number');
		rate_box.attr('value','0');
		rate_box.appendTo(acc_inpt_grp2);

		acc_selector2= $("<span />");
		acc_selector2.attr('class','input-group-addon');
		acc_selector2.append('<strong>%</strong>');
		acc_selector2.appendTo(acc_inpt_grp2);

		//4

		acc_form_grp3 = $("<div />");
		acc_form_grp3.attr('class','form-group col col-2');
		acc_form_grp3.appendTo(acc_div);

		acc_inpt_grp3 = $("<div />");
		acc_inpt_grp3.attr('class','input-group');
		acc_inpt_grp3.appendTo(acc_form_grp3);

		desc_box = $("<input />").attr('id','desc_' + rowNum + '_' + colNum + '_' + accNum);
		desc_box.attr('name','desc_' + rowNum + '_' + colNum + '_' + accNum);
		desc_box.attr('type','text');
		desc_box.appendTo(acc_form_grp3);

		// 5

		select_block_type5 = $("<div />");
		select_block_type5.attr("class","form-group col col-2");
		select_block_type5.appendTo(acc_div);

		block_group_type5 = $("<select />").attr('id','ba_' + rowNum + '_' + colNum + '_' + accNum);
		block_group_type5.attr('name','ba_' + rowNum + '_' + colNum + '_' + accNum);
		block_group_type5.html('<option value = "0">Borç</option><option value = "1">Alacak</option></select>');
		block_group_type5.appendTo(select_block_type5);


		acc_div.appendTo($("#detail_" + rowNum + "_" + colNum));

		$('#counter_' + rowNum + '_' + colNum).val(parseInt($('#counter_' + rowNum + '_' + colNum).val()) + 1);
	}

	function createBlock(row_number) {
		block = $("#block_detail_" + row_number);

		for( i = 1; i <= 2; i++) {
			blockDetailColumn = $("<div />");
			blockDetailColumn.attr('class','col col-11 col-md-11 col-sm-11 col-xs-12');
			blockDetailColumn.attr('id','detail_' + i + '_' + row_number);

			flag = $("<div />");
			flag.attr('class','acc-flex col col-6 col-md-6 col-xs-12');

			arrow = $("<div />");
			arrow.attr('class','col col-2 col-xs-12 flag-arrow');

			header = $("<div />").attr('class','acc-body-title');

			plus = $("<a href='javascript:void(0)'>");
			plus.append('<i class="icon-pluss"></i>');
			plus.attr('onClick','addAccount(' + row_number + ', ' + i + ')');
			blockDetailColumn.attr('id','detail_' + row_number + '_' + i);
			plus.appendTo(header);

			switch(i) {
				case 1:
					header.append('<strong><cf_get_lang dictionary_id='57652.Hesap'></strong>');
					arrow.append('<span><div class="form-group col col-12"> <select name="detail_counter_block_type_' + row_number + '" id="detail_counter_block_type_' + row_number + '"><option value = "0">=</option><option value = "1">>=</option><option value = "2"><=</option><option value = "3">></option><option value = "4"><</option></select> </div> <div class="form-group col col-12"><div class="input-group"><input type="number" name="detail_counter_rate_type_' + row_number + '" id="detail_counter_rate_type_' + row_number + '"> <span class="input-group-addon"><strong>%</strong></span> </div></div></span>');
				break;
				case 2:
					header.append('<strong><cf_get_lang dictionary_id='57652.Hesap'></strong>');
					arrow.append('<i class="icon-chevron-right"></i>');
				break;
			}

			blockCount = $("<input />").attr('id','counter_' + row_number + '_' + i);
			blockCount.attr('name','counter_' + row_number + '_' + i);
			blockCount.attr('type','hidden');
			blockCount.attr('value', 0);
			blockCount.appendTo(header);

			flag.appendTo(block);
			header.appendTo(blockDetailColumn);

			blockDetailColumn.appendTo(flag);
			
			arrow.appendTo(flag);
		}
	}

	function toFloat(num) {
		dotPos = num.indexOf('.');
		commaPos = num.indexOf(',');

		if (dotPos < 0)
			dotPos = 0;

		if (commaPos < 0)
			commaPos = 0;

		if ((dotPos > commaPos) && dotPos)
			sep = dotPos;
		else {
			if ((commaPos > dotPos) && commaPos)
				sep = commaPos;
			else
				sep = false;
		}

		if (sep == false)
			return parseFloat(num.replace(/[^\d]/g, ""));

		return parseFloat(
			num.substr(0, sep).replace(/[^\d]/g, "") + '.' + 
			num.substr(sep+1, num.length).replace(/[^0-9]/, "")
		);

	}
</script>
