<cfset wizard = createObject("component", "V16.budget.cfc.MagicBudgeter" )>
<cfset get_activity = wizard.get_activity()>
<cfset det_wizard = wizard.det_wizard(
                                        wizard_id : attributes.wizard_id
                                     )>
<cfset record_val = deserializeJSON(det_wizard)>
<cfset record_query = queryNew("RECORD_DATE,RECORD_EMP,UPDATE_DATE,UPDATE_EMP","date,integer,date,integer",[{ RECORD_DATE = record_val[1]["RECORD_DATE"],
                                                                                                                RECORD_EMP = record_val[1]["RECORD_EMP"],
                                                                                                                UPDATE_DATE = record_val[1]["UPDATE_DATE"],
                                                                                                                UPDATE_EMP = record_val[1]["UPDATE_EMP"] }]
                                                                                                             )>
<cf_catalystHeader>
    <cf_box>
        <cfform name="add_wizard" id="add_wizard" method="post">
            <input type="hidden" name="wizard_id" id="wizard_id" value="" maxlength="25">
                <cf_box_elements>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-wizard_name">
                            <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='60726.Sihirbaz'><cf_get_lang dictionary_id='57897.Adı'>*</label>
                            <div class="col col-6 col-xs-12">
                                <input type="text" name="wizard_name" id="wizard_name" value="" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-wizard_designer">
                            <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='55065.Tasarlayan'>*</label>
                            <div class="col col-6 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="employee_id" id="employee_id" value="">
                                    <input type="text" name="employee_name" id="employee_name" value="" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" value="" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_wizard.employee_id&field_name=add_wizard.employee_name&select_list=1');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-wizard_stage">
                            <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                            <div class="col col-6 col-xs-12">
                                <cf_workcube_process slct_width="180px;" is_upd = "0" is_detail = "0">
                            </div>
                        </div>
                        <div class="form-group" id="item-process_date">
                            <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='29792.Tasarım'><cf_get_lang dictionary_id='58593.Tarihi'>*</label>
                            <div class="col col-6 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                                    <cfinput type="text" name="process_date" value="" maxlength="10" required="Yes" message="#message#" validate="#validate_style#" onblur="change_money_info('add_wizard','process_date');">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="process_date"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-12 ">
                        <div class="ui-card">
                            <input type="hidden" name="rowCount" id="rowCount" value="0">
                            <div class="ui-card-add-btn"><a href="javascript://" onClick="addRow();"><i class="icon-pluss" alt="<cf_get_lang dictionary_id='57707.Satır Ekle'>" title="<cf_get_lang dictionary_id='57707.Satır Ekle'>"></i></a></div>
                            <div id="table_list">

                            </div>
                        </div>
                    </div>
                </cf_box_elements>	
                <cf_box_footer>
                    <div class = "col col-4"><cf_record_info query_name="record_query"></div>
                    <div class = "col col-8"><cf_workcube_buttons is_upd='1' add_function="kontrol()" delete_page_url = "#request.self#?fuseaction=#attributes.fuseaction#&event=del&wizard_id=#attributes.wizard_id#"></div>
                </cf_box_footer>
        </cfform>
    </cf_box>
<script type="text/javascript">
    $( document ).ready(function() {
        getJSON = <cfoutput>#det_wizard#</cfoutput>;
        processedBlocks = [];
        processedRows = [];

        console.log(getJSON);
        
        $.each(getJSON, function( index, value ) {
            
            if(index == 0) {
                $("#wizard_id").val(value.WIZARD_ID);
                $("#wizard_name").val(value.WIZARD_NAME);
                $("#employee_id").val(value.WIZARD_DESIGNER);
                $("#employee_name").val(value.EMPLOYEE_FULLNAME);
                $("#process_stage").val(value.WIZARD_STAGE);
                $("#process_date").val(value.WIZARD_DATE);
            }
            
            if($.inArray(value.WIZARD_BLOCK_ID,processedBlocks) == -1) { // İlk gelenden blok alanlarını dolduruyoruz.
                processedBlocks.push(value.WIZARD_BLOCK_ID);

                addRow();
                $("#block_name_left_" + $("#rowCount").val()).val(value.BLOCK_NAME);
                $("#block_type_" + $("#rowCount").val()).val(value.BLOCK_INCOME);
            }
            if($.inArray(value.WIZARD_BLOCK_ROW_ID,processedRows) == -1) { // İlk gelenden row alanlarını dolduruyoruz.
                processedRows.push(value.WIZARD_BLOCK_ROW_ID);

                addAccount($("#rowCount").val(),value.BLOCK_COLUMN);
                acc_input_hidden = $("#acc_control_" + $("#rowCount").val() + '_' + value.BLOCK_COLUMN + '_' + $("#counter_" + $("#rowCount").val() + "_" + value.BLOCK_COLUMN).val());
                acc_input = $("#acc_" + $("#rowCount").val() + '_' + value.BLOCK_COLUMN + '_' + $("#counter_" + $("#rowCount").val() + "_" + value.BLOCK_COLUMN).val());
                exp_item_input_hidden = $("#bud_cat_control_" + $("#rowCount").val() + '_' + value.BLOCK_COLUMN + '_' + $("#counter_" + $("#rowCount").val() + "_" + value.BLOCK_COLUMN).val());
                exp_item_input = $("#bud_cat_" + $("#rowCount").val() + '_' + value.BLOCK_COLUMN + '_' + $("#counter_" + $("#rowCount").val() + "_" + value.BLOCK_COLUMN).val());
                activity_type_input = $("#exp_act_type_" + $("#rowCount").val() + '_' + value.BLOCK_COLUMN + '_' + $("#counter_" + $("#rowCount").val() + "_" + value.BLOCK_COLUMN).val());
                rate_input = $("#rate_" + $("#rowCount").val() + '_' + value.BLOCK_COLUMN + '_' + $("#counter_" + $("#rowCount").val() + "_" + value.BLOCK_COLUMN).val());
                desc_input = $("#desc_" + $("#rowCount").val() + '_' + value.BLOCK_COLUMN + '_' + $("#counter_" + $("#rowCount").val() + "_" + value.BLOCK_COLUMN).val());
				action_type_input_hidden = $("#action_type_hidden_" + $("#rowCount").val() + '_' + value.BLOCK_COLUMN + '_' + $("#counter_" + $("#rowCount").val() + "_" + value.BLOCK_COLUMN).val());
				action_type_input = $("#action_type_" + $("#rowCount").val() + '_' + value.BLOCK_COLUMN + '_' + $("#counter_" + $("#rowCount").val() + "_" + value.BLOCK_COLUMN).val());

                acc_input_hidden.val(value.EXP_CENTER);
                acc_input.val(value.EXPENSE);
                exp_item_input_hidden.val(value.EXP_ITEM);
                exp_item_input.val(value.EXPENSE_ITEM_NAME);
                activity_type_input.val(value.ACTIVITY_TYPE);
                rate_input.val(value.RATE);
                desc_input.val(value.DESCRIPTION);
			
            } 
        });
    });

        function kontrol()
		{
			if($("#wizard_name").val() == '') {
				alert('<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='60726.Sihirbaz'><cf_get_lang dictionary_id='57897.Adı'>!');
				return false;
			}
			if($("#employee_id").val() == '' || $("#employee_name").val() == '') {
				alert('<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='55065.Tasarlayan'>!');
				return false;
			}
			if($("#process_date").val() == '') {
				alert('<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='29792.Tasarım'><cf_get_lang dictionary_id='58593.Tarihi'>!');
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
        rowCount = 0;

		function addRow()
		{
			rowCount++;
			add_wizard.rowCount.value = rowCount;
			var newRow;
			var newCell;
			newRow = $('<div />');
			newRow.attr({"id":"block_row_" + rowCount,"class":"ui-card-item"});
			newCell = '<input type = "hidden" id = "row_kontrol_' + rowCount + '" name = "row_kontrol_' + rowCount + '" value = "1"><div class="ui-card-item-hide"><a href="javascript://" onClick="delRow(' + rowCount + ');"><i class="icon-minus" alt="<cf_get_lang dictionary_id='57698.Sıfırla'>"></i></a></div>';
			newRow.append(newCell);
			newCell = 
			'<div class="col col-12 col-xs-12 acc-top">'+
				'<div class="acc-count">'+rowCount+'</div>'+
				'<div class="acc-block-name form-group col col-6"><div class="input-group"><input type="text" name="block_name_left_' + rowCount + '" id="block_name_left_' + rowCount + '" placeholder="<cf_get_lang dictionary_id='64340.Blok Adı'>"><span class="input-group-addon no-bg"></span><select name="block_type_left_' + rowCount + '" id="block_type_' + rowCount + '"><option value = "0"><cf_get_lang dictionary_id='58678.Gider'></option><option value = "1"><cf_get_lang dictionary_id='58677.Gelir'></option></select></div></div>'+
				<!--- '<div class="acc-block-name form-group col col-6"><div class="input-group"><input type="text" name="block_name_right_' + rowCount + '" id="block_name_right_' + rowCount + '" placeholder="Blok Adı"><span class="input-group-addon no-bg"></span><select name="block_type_right' + rowCount + '" id="block_type_' + rowCount + '"><option value = "0">Gider</option><option value = "1">Gelir</option></select></div></div>'+ --->
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

		function pencere_ac(acc_input, acc_cont_input) {
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=add_wizard.' + acc_cont_input +'&field_name=add_wizard.' + acc_input, 'list');
        }

        function pencere_cat_ac(cat_input, cat_cont_input) {
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_wizard.' + cat_cont_input +'&field_name=add_wizard.' + cat_input, 'list');
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

			//1 sil

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

			//2 masraf merkezi 
			
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
            acc_input.attr('placeholder','<cf_get_lang dictionary_id='58460.Masraf Merkezi'>');
			acc_input.attr('readonly',true);
			acc_input.appendTo(acc_inpt_grp);

			acc_selector= $("<span />");
			acc_selector.attr('class','input-group-addon btnPointer icon-ellipsis');
			acc_selector.attr('onClick','pencere_ac("acc_' + rowNum + '_' + colNum + '_' + accNum + '","acc_control_' + rowNum + '_' + colNum + '_' + accNum + '");');
            acc_selector.appendTo(acc_inpt_grp);
            

            // 3 bütçe kategorisi
            /*
			select_block_type5 = $("<div />");
			select_block_type5.attr("class","form-group col col-3");
			select_block_type5.appendTo(acc_div);
            <cfsavecontent variable="Cstag"><cf_wrk_budgetcat name="expense_cat" option_text="Bütçe Kategorisi"></cfsavecontent>
            <cfset Cstag = replaceNoCase(Cstag,chr(13),' ','All')>
		    <cfset Cstag = replaceNoCase(Cstag,chr(10),' ','All')>
			block_group_type5 = $("<select />").attr('id','exp_cat_' + rowNum + '_' + colNum + '_' + accNum);
			block_group_type5.attr('name','exp_cat_' + rowNum + '_' + colNum + '_' + accNum);
			block_group_type5.html('<cfoutput>#Cstag#</cfoutput>');
            block_group_type5.appendTo(select_block_type5);*/
            
            // 4 bütçe kalemi 

            select_block_type4 = $("<div />");
			select_block_type4.attr('class','form-group col col-2');
			select_block_type4.appendTo(acc_div);

			select4_inpt_grp = $("<div />");
			select4_inpt_grp.attr('class','input-group');
			select4_inpt_grp.appendTo(select_block_type4);
			
			select4_inpt_grp.append('<input type = "hidden" id = "bud_cat_control_' + rowNum + '_' + colNum + '_' + accNum + '" name = "bud_cat_control_' + rowNum + '_' + colNum + '_' + accNum + '" value = "1">');

			budget_cat_input = $("<input />").attr('id','bud_cat_' + rowNum + '_' + colNum + '_' + accNum);
			budget_cat_input.attr('name','bud_cat_' + rowNum + '_' + colNum + '_' + accNum);
            budget_cat_input.attr('type','text');
            budget_cat_input.attr('placeholder','<cf_get_lang dictionary_id='58234.Bütçe Kalemi'>');
			budget_cat_input.attr('readonly',true);
			budget_cat_input.appendTo(select4_inpt_grp);

			bud_cat_selector= $("<span />");
			bud_cat_selector.attr('class','input-group-addon btnPointer icon-ellipsis');
			bud_cat_selector.attr('onClick','pencere_cat_ac("bud_cat_' + rowNum + '_' + colNum + '_' + accNum + '","bud_cat_control_' + rowNum + '_' + colNum + '_' + accNum + '");');
            bud_cat_selector.appendTo(select4_inpt_grp);

            
            // 5 aktivite tipi

            select_act_type = $("<div />");
			select_act_type.attr("class","form-group col col-2");
			select_act_type.appendTo(acc_div);
			act_group_type5 = $("<select />").attr('id','exp_act_type_' + rowNum + '_' + colNum + '_' + accNum);
			act_group_type5.attr('name','exp_act_type_' + rowNum + '_' + colNum + '_' + accNum);
			act_group_type5.html('<select name="activity_id" id="activity_id" ><option value=""><cf_get_lang dictionary_id='38378.Aktivite Tipi'></option><cfoutput query="get_activity"><option value="#activity_id#">#activity_name#</option></cfoutput></select>');
            act_group_type5.appendTo(select_act_type);


			//6

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

			//7

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

			acc_div.appendTo($("#detail_" + rowNum + "_" + colNum));

			$('#counter_' + rowNum + '_' + colNum).val(parseInt($('#counter_' + rowNum + '_' + colNum).val()) + 1);
		}

		function createBlock(row_number) {
			block = $("#block_detail_" + row_number);

			for( i = 1; i <= 2; i++) {
				blockDetailColumn = $("<div />");
				blockDetailColumn.attr('class','col col-12 col-md-12 col-sm-12 col-xs-12');
				blockDetailColumn.attr('id','detail_' + i + '_' + row_number);

				flag = $("<div />");
				flag.attr('class','acc-flex col col-6 col-md-6 col-xs-12');

				arrow = $("<div />");
				arrow.attr('class','col col-1 col-xs-12 flag-arrow');

				header = $("<div />").attr('class','acc-body-title');

				plus = $("<a href='javascript:void(0)'>");
				plus.append('<i class="icon-pluss"></i>');
				plus.attr('onClick','addAccount(' + row_number + ', ' + i + ')');
				blockDetailColumn.attr('id','detail_' + row_number + '_' + i);
				plus.appendTo(header);

				/* aradaki işaret  */
                header.append('<strong><cf_get_lang dictionary_id='57652.Hesap'></strong>');
                arrow.append('<i class="icon-chevron-right"></i>');
				
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