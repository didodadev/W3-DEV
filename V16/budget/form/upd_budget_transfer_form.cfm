<!---
File: upd_budget_transfer_form.cfm
query:upd_budget_transfer_form.cfm
Author: Workcube - Melek KOCABEY <melekkocabey@workcube.com>
Date: 13.10.2020
Controller: WBO/controller/BudgetTransferDemandController.cfm
Description: Bütçe Aktarım Talepleri upd sayfası.
---->
<cf_xml_page_edit fuseact="budget.budget_transfer_demand">
<cfset demand = createObject("component", "V16.budget.cfc.BudgetTransferDemand" )>
<cfset get_money = demand.get_money()>
<cfset get_activity = demand.get_activity()>
<cfif fusebox.circuit eq 'myhome'>
    <cfset attributes.demand_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.demand_id,accountKey:'wrk')>
    <cfsavecontent variable="pagehead"><cf_get_lang dictionary_id="61325.Bütçe Aktarım Talebi"></cfsavecontent>
    <cfset pageHead = #pagehead#>
</cfif>
<cfset get_kontrol = demand.get_demand_kontrol(demand_id : attributes.demand_id)>
<cfset det_demand = demand.det_demand(
                                        demand_id : attributes.demand_id
                                     )>
<cfset record_val = deserializeJSON(det_demand)>
<cfset record_query = queryNew("RECORD_DATE,RECORD_EMP,UPDATE_DATE,UPDATE_EMP","date,integer,date,integer",[{ RECORD_DATE = record_val[1]["RECORD_DATE"],
                                                                                                                RECORD_EMP = record_val[1]["RECORD_EMP"],
                                                                                                                UPDATE_DATE = record_val[1]["UPDATE_DATE"],
                                                                                                                UPDATE_EMP = record_val[1]["UPDATE_EMP"] }]
                                                                                                             )>
<cfset attributes.responsible_emp = len(record_val[1]["RESPONSIBLE_EMP"])  ? get_emp_info(record_val[1]["RESPONSIBLE_EMP"],1,0): "">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="upd_budget_transfer" id="upd_budget_transfer" method="post">
            <cfif len(record_val[1]["INTERNAL_ID"])>
                <input type="hidden" name="internaldemand_id" id="internaldemand_id" value='<cfoutput>#record_val[1]["INTERNAL_ID"]#</cfoutput>'>
            <cfelseif len(record_val[1]["OFFER_ID"])>
                <input type="hidden" name="offer_id" id="offer_id" value='<cfoutput>#record_val[1]["OFFER_ID"]#</cfoutput>'>
            <cfelseif len(record_val[1]["ORDER_ID"])>
                <input type="hidden" name="order_id" id="order_id" value='<cfoutput>#record_val[1]["ORDER_ID"]#</cfoutput>'>
            <cfelseif len(record_val[1]["EXPENSE_ID"])>
                <input type="hidden" name="expense_" id="expense_" value='<cfoutput>#record_val[1]["EXPENSE_ID"]#</cfoutput>'>
            </cfif>
            <cfif len(record_val[1]["TRANSFER_STATUS"]) and record_val[1]["TRANSFER_STATUS"] eq 'NO'>
                <input type="hidden" name="transfer_status" id="transfer_status" value='0'>
            <cfelseif len(record_val[1]["TRANSFER_STATUS"]) and record_val[1]["TRANSFER_STATUS"] eq 'YES'>
                <input type="hidden" name="transfer_status" id="transfer_status" value='1'>
            </cfif>
            <input type="hidden" name="demand_id" id="demand_id" value="" maxlength="25">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">                
                    <div class="form-group" id="item-demand_stage">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process slct_width="180px;" is_upd = "0" is_detail = "1">
                        </div>
                    </div>
                    <div class="form-group" id="item-budget">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="49179.İlişkili Bütçe"></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="budget_id" id="budget_id" value="">
                                <input type="text" name="budget_name" id="budget_name" readonly="yes" value="">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_budget&field_id=upd_budget_transfer.budget_id&field_name=upd_budget_transfer.budget_name&select_list=2');return false" title="<cfoutput>#getLang('budget','İlişkili Bütçe',49179)#</cfoutput>"></span>
                            </div>
                        </div>
                    </div>  
                    <div class="form-group" id="item-reference">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58784.Referans"></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="reference_no" id="reference_no" value="" maxlength="40">
                        </div>
                    </div>                
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-demand_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30770.Talep No'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="demand_no" id="demand_no" value="" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-demand_emp">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30829.Talep Eden'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="employee_id" id="employee_id" value="">
                                <input type="text" name="employee_name" id="employee_name" value="" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" value="" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_budget_transfer.employee_id&field_name=upd_budget_transfer.employee_name&select_list=1');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-responsible_emp">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
                        <div class="col col-8 col-xs-12"> 
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="responsible_emp_id" id="responsible_emp_id" value="">
                                    <input type="text" name="responsible_emp" id="responsible_emp" onfocus="AutoComplete_Create('responsible_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','responsible_emp_id','','3','150');" autocomplete="off" value="<cfif isdefined("attributes.responsible_emp") and len(attributes.responsible_emp)>#attributes.responsible_emp#</cfif>">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_code=upd_budget_transfer.responsible_emp_id&field_name=upd_budget_transfer.responsible_emp&select_list=1');" title="<cf_get_lang dictionary_id='57924.Kime'>"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>             
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-demand_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="31023.Talep Tarihi"></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                                <cfinput type="text" name="demand_date" value="" maxlength="10" required="Yes" message="#message#" validate="#validate_style#" onblur="change_money_info('upd_budget_transfer','demand_date');">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="demand_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="detail" id="detail"></textarea>
                        </div>
                    </div>                
                </div>
                <div class="col col-12 ">
                    <div class="ui-card">
                        <input type="hidden" name="rowCount" id="rowCount" value="0">
                        <div class="ui-card-add-btn"><a href="javascript://" onClick="addRow();" id="plus_"><i class="icon-pluss" alt="<cf_get_lang dictionary_id='57707.Satır Ekle'>" title="<cf_get_lang dictionary_id='57707.Satır Ekle'>"></i></a></div>
                        <div id="table_list">

                        </div>
                    </div>
                </div          
            </cf_box_elements>	
            <cf_box_footer>
                <div class = "col col-4">
                    <cf_record_info query_name="record_query">
                </div>
                <div class = "col col-8">
                    <cf_workcube_buttons is_upd='1' add_function="kontrol()" delete_page_url = "#request.self#?fuseaction=#attributes.fuseaction#&event=del&demand_id=#attributes.demand_id#">
                    <cfif not get_kontrol.recordcount>
                        <input type="button" class="pull-right" value="<cf_get_lang dictionary_id='61341.Bütçe Planına Aktar'>" onClick="window.location.href='<cfoutput>#request.self#?fuseaction=budget.list_plan_rows&event=add&demand_id=#attributes.demand_id#</cfoutput>';">
                    <cfelse>
                        <input type="button" class="pull-right" value="<cf_get_lang dictionary_id='61342.Bütçe Planına Git'>" onClick="window.location.href='<cfoutput>#request.self#?fuseaction=budget.list_plan_rows&event=upd&budget_plan_id=#get_kontrol.budget_plan_id#</cfoutput>';">
                    </cfif>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    $( document ).ready(function() {
        getJSON = <cfoutput>#det_demand#</cfoutput>;
        processedBlocks = [];
        processedRows = [];

        console.log(getJSON);
        
        $.each(getJSON, function( index, value ) {
            
            if(index == 0) {
                $("#demand_id").val(value.DEMAND_ID);
                $("#demand_no").val(value.DEMAND_NO);
                $("#detail").val(value.DETAIL);
                $("#employee_id").val(value.DEMAND_EMP_ID);
                $("#employee_name").val(value.EMPLOYEE_FULLNAME);
                $("#process_stage").val(value.DEMAND_STAGE);
                $("#demand_date").val(value.DEMAND_DATE);
                $("#budget_id").val(value.BUDGET_ID);
                $("#budget_name").val(value.BUDGET_NAME);
                $("#reference_no").val(value.REFERENCE);
                $("#responsible_emp_id").val(value.RESPONSIBLE_EMP);
            }
            
            if($.inArray(value.DEMAND_ROWS_ID,processedRows) == -1) { // İlk gelenden row alanlarını dolduruyoruz.
                processedRows.push(value.DEMAND_ROWS_ID);
                
                addRow();
                acc_input_hidden = $("#acc_control_" + $("#rowCount").val() + '_' + 1 );
                acc_input = $("#acc_" + $("#rowCount").val() + '_' + 1 );
                exp_item_input_hidden = $("#bud_cat_control_" + $("#rowCount").val() + '_' + 1 );
                exp_item_input = $("#bud_cat_" + $("#rowCount").val() + '_' + 1 );
                project_id_input = $("#proje_id_" + $("#rowCount").val() + '_' + 1 );
                project_id_input_hidden = $("#proje_control_" + $("#rowCount").val() + '_' + 1 );
                activity_type_input = $("#exp_act_type_" + $("#rowCount").val() + '_' + 1);

                acc_input_hidden1 = $("#acc_control_" + $("#rowCount").val() + '_' + 2 );
                acc_input1 = $("#acc_" + $("#rowCount").val() + '_' + 2 );
                exp_item_input_hidden1 = $("#bud_cat_control_" + $("#rowCount").val() + '_' + 2 );
                exp_item_input1 = $("#bud_cat_" + $("#rowCount").val() + '_' + 2 );
                project_id_input1 = $("#proje_id_" + $("#rowCount").val() + '_' + 2 );
                project_id_input_hidden1 = $("#proje_control_" + $("#rowCount").val() + '_' + 2 );
                activity_type_input1 = $("#exp_act_type_" + $("#rowCount").val() + '_' + 2);
                serbest_input1 = $("#serbest_" + $("#rowCount").val() + '_' + 2 );
                block_type_input1 = $("#budget_plan_type_" + $("#rowCount").val() + '_' + 2);

                rate_input = $("#rate_" + $("#rowCount").val() + '_' + 1 );
                serbest_input = $("#serbest_" + $("#rowCount").val() + '_' + 1 );
                money_type = $("#money_type_" + $("#rowCount").val() + '_' + 1);
				action_type_input_hidden = $("#action_type_hidden_" + $("#rowCount").val() + '_' + 1 );
				action_type_input = $("#action_type_" + $("#rowCount").val() + '_' + 1 );

                acc_input_hidden.val(value.DEMAND_EXP_CENTER);
                acc_input.val(value.EXPENSE);
                exp_item_input_hidden.val(value.DEMAND_EXP_ITEM);
                exp_item_input.val(value.EXPENSE_ITEM_NAME);
                project_id_input_hidden.val(value.DEMAND_PROJECT_ID);
                project_id_input.val(value.PROJECT_HEAD);
                activity_type_input.val(value.DEMAND_ACTIVITY_TYPE);

                acc_input_hidden1.val(value.TRANSFER_EXP_CENTER);
                acc_input1.val(value.TRA_EXPENSE);
                exp_item_input_hidden1.val(value.TRANSFER_EXP_ITEM);
                exp_item_input1.val(value.TRA_EXPENSE_ITEM_NAME);
                project_id_input_hidden1.val(value.TRANSFER_PROJECT_ID);
                project_id_input1.val(value.TRA_PROJECT_HEAD);
                activity_type_input1.val(value.TRANSFER_ACTIVITY_TYPE);
                serbest_input1.val(commaSplit(value.USABLE_TRANSFER_MONEY));
                block_type_input1.val( ( value.BLOCK_TYPE == false || value.BLOCK_TYPE == 0 ? 0 : 1 ) );
               
                rate_input.val(commaSplit(value.AMOUNT));
                serbest_input.val(commaSplit(value.USABLE_MONEY));
                money_type.val(value.MONEY_CURRENCY);
			
            } 
        });
    });
    function kontrol()
		{
			if($("#demand_no").val() == '') {
				alert('Talep No giriniz!');
				return false;
			}
			if($("#demand_date").val() == '') {
				alert('Tarih giriniz!');
				return false;
			}
			if(parseInt($("#rowCount").val()) == 0) {
				alert('Lütfen Blok Ekleyiniz!');
				return false;			
            }
            for( i = 1; i <= parseInt($("#rowCount").val()); i++ ) 
                {	
                    if(parseFloat(filterNum($("#serbest_" + i + '_' + 1 ).val())) < parseFloat(filterNum($("#rate_" + i + '_' + 1 ).val())))
                    {
                        alert('<cf_get_lang dictionary_id="61468.Girdiğiniz Tutar Kullanılabilir Bütçe Limitinden Fazla Olamaz!">');
                        return false;
                    }
                }
            process_cat_dsp_function();
			return true;
        }
        rowCount = 0;
    function addRow()
		{
			rowCount++;
			upd_budget_transfer.rowCount.value = rowCount;
			var newRow;
			var newCell;
			newRow = $('<div />');
			newRow.attr({"id":"block_row_" + rowCount,"class":"ui-card-item"});
			newCell = '<input type = "hidden" id = "row_kontrol_' + rowCount + '" name = "row_kontrol_' + rowCount + '" value = "1"><div class="ui-card-item-hide"><a href="javascript://" onClick="delRow(' + rowCount + ');"><i class="icon-minus" alt="<cf_get_lang dictionary_id ='57698.Sıfırla'>"></i></a></div>';
			newRow.append(newCell);
			
			newCell = '<div class="acc-body" id = "block_detail_' + rowCount + '"></div>';
			newRow.append(newCell);
            $('#table_list').append(newRow);
            console.log(rowCount);
            createBlock(rowCount);
            <cfif is_budget_transfer_demand eq 0>
                $("#plus_").prop('onclick', null).off('click'); // Removes 'onclick' property if found
            </cfif>
		}
    function delRow(block_id) {
			$("#row_kontrol_" + block_id).val(0);
			$("#block_row_" + block_id).hide();
            <cfif is_budget_transfer_demand eq 0>
                $("#plus_").attr({'onclick': "addRow();"}); // Removes 'onclick' property if found
            </cfif>
        }

    function pencere_ac(acc_input, acc_cont_input) {
        var row_ =acc_cont_input.split('_');
        rowNum = row_[2];
        i = row_[3];
        var cat_cont_input = 'bud_cat_control_' + rowNum + '_' + i; 
        var proje_cont_input = 'proje_control_' + rowNum + '_' + i;
        openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=upd_budget_transfer.' + acc_cont_input +'&field_name=upd_budget_transfer.' + acc_input + '&call_function=hesapla&call_function_parameter="'+acc_cont_input+'","'+ cat_cont_input +'","'+proje_cont_input+'",'+rowNum+','+i+'');
    }
    function pencere_item_ac(cat_input, cat_cont_input) {
        var row_ =cat_cont_input.split('_');
        rowNum = row_[3];
        i = row_[4];
        var acc_cont_input = 'acc_control_' + rowNum + '_' + i; 
        var proje_cont_input = 'proje_control_' + rowNum + '_' + i;
        openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_budget_transfer.' + cat_cont_input +'&field_name=upd_budget_transfer.' + cat_input+'&function_name=hesapla&function_name_parameter="'+acc_cont_input+'","'+ cat_cont_input +'","'+proje_cont_input+'",'+rowNum+','+i+'');
        }
    function pencere_proje_ac(proje_input, proje_cont_input) {
            var row_ =proje_cont_input.split('_');
            rowNum = row_[2];
            i = row_[3];
            var cat_cont_input = 'bud_cat_control_' + rowNum + '_' + i; 
            var acc_cont_input = 'acc_control_' + rowNum + '_' + i;
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=upd_budget_transfer.' + proje_cont_input +'&project_cat_gln=1&project_head=upd_budget_transfer.' + proje_input+'&function_name=hesapla&function_param="'+acc_cont_input+'","'+ cat_cont_input +'","'+proje_cont_input+'",'+rowNum+','+i+'');
        }
    function hesapla(acc_cont_input,cat_cont_input,proje_cont_input,rowNum,i) {
        var proje = "";
        var cat = "";
        var acc = "";
        if (document.getElementById(acc_cont_input).value != '')
        {
            var acc = document.getElementById(acc_cont_input).value; 
        }
        if(document.getElementById(cat_cont_input).value !='')
        {
            var cat = document.getElementById(cat_cont_input).value; 
        }
        if(document.getElementById(proje_cont_input).value !='')
        {
            var proje = document.getElementById(proje_cont_input).value;
        }
        var send_address = 'V16/budget/display/budget_usabled.cfm?i='+i+'&rowNum='+rowNum+'&expense_id='+acc+'&expense_item_id='+cat+'&project_id='+proje+'';
        AjaxPageLoad(send_address,'send_message',1,'Getir Serbest Bütçe');
        
    }
    function getTotalAmount(deger){  
        console.log(deger);      
        document.getElementById(deger).value = commaSplit(filterNum(document.getElementById(deger).value));  
    }
    function createBlock(row_number) {
			block = $("#block_detail_" + row_number);
                i = 1;
				blockDetailColumn = $("<div />");
				/* blockDetailColumn.attr('class','col col-6 col-md-6 col-sm-6 col-xs-12'); */
				blockDetailColumn.attr('id','detail_' + i + '_' + row_number);

				flag = $("<div />");
				flag.attr('class','acc-flex col col-6 col-md-6 col-xs-12');

				arrow = $("<div />");
				arrow.attr('class','col col-1 col-xs-12 flag-arrow');

				header = $("<div />").attr('class','acc-body-title');

				
				blockDetailColumn.attr('id','detail_' + row_number + '_' + i);
				

				/* aradaki işaret  */
                
                arrow.append('<i class="icon-chevron-right"></i>');
				
				blockCount = $("<input />").attr('id','counter_' + row_number + '_' + i);
				blockCount.attr('name','counter_' + row_number + '_' + i);
				blockCount.attr('type','hidden');
				blockCount.attr('value', 0);
                blockCount.appendTo(header);
                
                accNum = parseInt($('#counter_' + row_number + '_' + i).val()) + 1;

                acc_div = $("<div />");
                acc_div.attr('class','ui-form-list');
                acc_div.attr('id','div_' + row_number + '_' + i );
                acc_div.append('<strong class="col col-12"><cf_get_lang dictionary_id='64451.Talep Edilen Bütçe'></strong>');
                acc_div.appendTo(header);

                //1 masraf merkezi 			
                acc_form_grp = $("<div />");
                acc_form_grp.attr('class','form-group col col-12 col-md-12 col-sm-12 col-xs-12');
                acc_form_grp.appendTo(acc_div);
                
                acc_label = $("<label />");
                acc_label.attr('class','col col-4 col-md-4 col-sm-4 col-xs-12');
                acc_label.appendTo(acc_form_grp);

                acc_label.append('<cf_get_lang dictionary_id='58460.Masraf Merkezi'>');

                acc_inpt_grp1= $("<div />");
                acc_inpt_grp1.attr('class','col col-8 col-md-8 col-sm-8 col-xs-12');
                acc_inpt_grp1.appendTo(acc_form_grp);
                
                acc_inpt_grp = $("<div />");
                acc_inpt_grp.attr('class','input-group');
                acc_inpt_grp.appendTo(acc_inpt_grp1);
                
                acc_inpt_grp.append('<input type = "hidden" id = "acc_control_' + row_number + '_' + i  + '" name = "acc_control_' + row_number + '_' + i  + '" value = "">');

                acc_input = $("<input />").attr('id','acc_' + row_number + '_' + i );
                acc_input.attr('name','acc_' + row_number + '_' + i );
                acc_input.attr('type','text');
                acc_input.attr('readonly',true);
                acc_input.appendTo(acc_inpt_grp);

                acc_selector= $("<span />");
                acc_selector.attr('class','input-group-addon btnPointer icon-ellipsis');
                acc_selector.attr('onClick','pencere_ac("acc_' + row_number + '_' + i  + '","acc_control_' + row_number + '_' + i  + '");');
                acc_selector.appendTo(acc_inpt_grp);

                // 2 bütçe kalemi 
                select_block_type4 = $("<div />");
                select_block_type4.attr('class','form-group col col-12 col-md-12 col-sm-12 col-xs-12');
                select_block_type4.appendTo(acc_div);

                select_label = $("<label />");
                select_label.attr('class','col col-4 col-md-4 col-sm-4 col-xs-12');
                select_label.appendTo(select_block_type4);

                select_label.append('<cf_get_lang dictionary_id='58234.Bütçe Kalemi'>');

                select4_inpt_grp1= $("<div />");
                select4_inpt_grp1.attr('class','col col-8 col-md-8 col-sm-8 col-xs-12');
                select4_inpt_grp1.appendTo(select_block_type4);

                select4_inpt_grp = $("<div />");
                select4_inpt_grp.attr('class','input-group');
                select4_inpt_grp.appendTo(select4_inpt_grp1);
                
                select4_inpt_grp.append('<input type = "hidden" id = "bud_cat_control_' + row_number + '_' + i  + '" name = "bud_cat_control_' + row_number + '_' + i  + '" value = "">');

                budget_cat_input = $("<input />").attr('id','bud_cat_' + row_number + '_' + i );
                budget_cat_input.attr('name','bud_cat_' + row_number + '_' + i );
                budget_cat_input.attr('type','text');
                budget_cat_input.attr('readonly',true);
                budget_cat_input.appendTo(select4_inpt_grp);

                bud_cat_selector= $("<span />");
                bud_cat_selector.attr('class','input-group-addon btnPointer icon-ellipsis');
                bud_cat_selector.attr('onClick','pencere_item_ac("bud_cat_' + row_number + '_' + i  + '","bud_cat_control_' + row_number + '_' + i  + '");');
                bud_cat_selector.appendTo(select4_inpt_grp);

                //3 proje
                select_block_type5 = $("<div />");
                select_block_type5.attr('class','form-group col col-12 col-md-12 col-sm-12 col-xs-12');
                select_block_type5.appendTo(acc_div);

                select_label_type = $("<label />");
                select_label_type.attr('class','col col-4 col-md-4 col-sm-4 col-xs-12');
                select_label_type.appendTo(select_block_type5);

                select_label_type.append('<cf_get_lang dictionary_id='57416.Proje'>');

                select5_inpt_grp1= $("<div />");
                select5_inpt_grp1.attr('class','col col-8 col-md-8 col-sm-8 col-xs-12');
                select5_inpt_grp1.appendTo(select_block_type5);

                select5_inpt_grp = $("<div />");
                select5_inpt_grp.attr('class','input-group');
                select5_inpt_grp.appendTo(select5_inpt_grp1);
                
                select5_inpt_grp.append('<input type = "hidden" id = "proje_control_' + row_number + '_' + i  + '" name = "proje_control_' + row_number + '_' + i  + '" value = "">');

                proje_input = $("<input />").attr('id','proje_id_' + row_number + '_' + i );
                proje_input.attr('name','proje_id_' + row_number + '_' + i );
                proje_input.attr('type','text');
                proje_input.attr('readonly',true);
                proje_input.appendTo(select5_inpt_grp);

                proje_selector= $("<span />");
                proje_selector.attr('class','input-group-addon btnPointer icon-ellipsis');
                proje_selector.attr('onClick','pencere_proje_ac("proje_id_' + row_number + '_' + i  + '","proje_control_' + row_number + '_' + i  + '");');
                proje_selector.appendTo(select5_inpt_grp);

                // 4 aktivite tipi
                act_type = $("<div />");
                act_type.attr('class','form-group col col-12 col-md-12 col-sm-12 col-xs-12');
                act_type.appendTo(acc_div);

                act_type_label = $("<label />");
                act_type_label.attr('class','col col-4 col-md-4 col-sm-4 col-xs-12');
                act_type_label.appendTo(act_type);

                act_type_label.append('<cf_get_lang dictionary_id='38378.Aktivite Tipi'>');

                act_type_input= $("<div />");
                act_type_input.attr('class','col col-8 col-md-8 col-sm-8 col-xs-12');
                act_type_input.appendTo(act_type);

                act_group_type6 = $("<select />").attr('id','exp_act_type_' + row_number + '_' + i);
                act_group_type6.attr('name','exp_act_type_' + row_number + '_' + i);
                act_group_type6.html('<select name="activity_id" id="activity_id" ><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_activity"><option value="#activity_id#">#activity_name#</option></cfoutput></select>');
                act_group_type6.appendTo(act_type_input);

                // 5 Serbest Bütçe
                acc_form_grp3 = $("<div />");
                acc_form_grp3.attr('class','form-group col col-12 col-md-12 col-sm-12 col-xs-12');
                acc_form_grp3.attr('style','display:none');
                acc_form_grp3.appendTo(acc_div);

                input_label_type1 = $("<label />");
                input_label_type1.attr('class','col col-4 col-md-4 col-sm-4 col-xs-12');
                input_label_type1.appendTo(acc_form_grp3);

                input_label_type1.append('<cf_get_lang dictionary_id='36567.Kullanılabilir'>');

                acc_inpt_grp4= $("<div />");
                acc_inpt_grp4.attr('class','col col-8 col-md-8 col-sm-8 col-xs-12');
                acc_inpt_grp4.appendTo(acc_form_grp3);

                acc_inpt_grp5 = $("<div />");
                acc_inpt_grp5.attr('class','input-group');
                acc_inpt_grp5.appendTo(acc_inpt_grp4);

                serbest_box = $("<input />").attr('id','serbest_' + row_number + '_' + i );
                serbest_box.attr('name','serbest_' + row_number + '_' + i );
                serbest_box.attr('type','text');
                serbest_box.attr('onkeyup','return(FormatCurrency(this,event));');
                serbest_box.attr('class','moneybox');
                serbest_box.attr('value','0');
                serbest_box.attr('readonly',true);
                serbest_box.attr('onChange','getTotalAmount("serbest_' + row_number + '_' + i  + '")');
                serbest_box.appendTo(acc_inpt_grp5);

                acc_selector3= $("<span />");
                acc_selector3.attr('class','input-group-addon btnPointer');
                acc_selector3.attr('title','<cf_get_lang dictionary_id='58998.Hesapla'>');
                acc_selector3.attr('onClick','hesapla("acc_control_' + row_number + '_' + i  + '","bud_cat_control_' + row_number + '_' + i  + '","proje_control_' + row_number + '_' + i  + '","' + row_number + '","' + i  + '");');
                acc_selector3.appendTo(acc_inpt_grp5);
                icon_ = $("<i />");
                icon_.attr('class','fa fa-calculator');
                icon_.appendTo(acc_selector3);

                //6 tutar
                acc_form_grp2 = $("<div />");
                acc_form_grp2.attr('class','form-group col col-12 col-md-12 col-sm-12 col-xs-12');
                acc_form_grp2.appendTo(acc_div);

                input_label_type = $("<label />");
                input_label_type.attr('class','col col-4 col-md-4 col-sm-4 col-xs-12');
                input_label_type.appendTo(acc_form_grp2);

                input_label_type.append('<cf_get_lang dictionary_id='57673.Tutar'>');

                acc_inpt_grp3= $("<div />");
                acc_inpt_grp3.attr('class','col col-8 col-md-8 col-sm-8 col-xs-12');
                acc_inpt_grp3.appendTo(acc_form_grp2);

                acc_inpt_grp2 = $("<div />");
                acc_inpt_grp2.attr('class','input-group');
                acc_inpt_grp2.appendTo(acc_inpt_grp3);

                rate_box = $("<input />").attr('id','rate_' + row_number + '_' + i );
                rate_box.attr('name','rate_' + row_number + '_' + i );
                rate_box.attr('type','text');
                rate_box.attr('onkeyup','return(FormatCurrency(this,event));');
                rate_box.attr('class','moneybox');
                rate_box.attr('value','0');
                rate_box.attr('onChange','getTotalAmount("rate_' + row_number + '_' + i  + '")');
                rate_box.appendTo(acc_inpt_grp2);

                acc_selector2= $("<span />");
                acc_selector2.attr('class','input-group-addon width');
                acc_selector2.appendTo(acc_inpt_grp2);
                act_group_type5 = $("<select />").attr('id','money_type_' + row_number + '_' + i );
                act_group_type5.attr('name','money_type_' + row_number + '_' + i );
                act_group_type5.html('<select name="money_type" id="money_type" ><cfoutput query="get_money"><option value="#money#">#money#</option></cfoutput></select>');
                act_group_type5.appendTo(acc_selector2);

                acc_div.appendTo($("#detail_" + row_number + "_" + i));

                $('#counter_' + row_number + '_' + i).val(parseInt($('#counter_' + row_number + '_' + i).val()) + 1);

				flag.appendTo(block);
				header.appendTo(blockDetailColumn);

				blockDetailColumn.appendTo(flag);
				
                arrow.appendTo(flag);
                i = 2;
                blockDetailColumn = $("<div />");
				/* blockDetailColumn.attr('class','col col-6 col-md-6 col-sm-6 col-xs-12'); */
				blockDetailColumn.attr('id','detail_' + i + '_' + row_number);

				flag = $("<div />");
				flag.attr('class','acc-flex col col-6 col-md-6 col-xs-12');

				arrow = $("<div />");
				arrow.attr('class','col col-1 col-xs-12 flag-arrow');

				header = $("<div />").attr('class','acc-body-title');

				
				blockDetailColumn.attr('id','detail_' + row_number + '_' + i);
				

				/* aradaki işaret  */
                arrow.append('<i class="icon-chevron-right"></i>');
				
				blockCount = $("<input />").attr('id','counter_' + row_number + '_' + i);
				blockCount.attr('name','counter_' + row_number + '_' + i);
				blockCount.attr('type','hidden');
				blockCount.attr('value', 0);
				blockCount.appendTo(header);

                accNum = parseInt($('#counter_' + row_number + '_' + i).val()) + 1;

                acc_div = $("<div />");
                acc_div.attr('class','ui-form-list');
                acc_div.attr('id','div_' + row_number + '_' + i );
                acc_div.append('<strong class="col col-12"><cf_get_lang dictionary_id='64459.Aktarılan Bütçe'></strong>');
                acc_div.appendTo(header);

                //1 masraf merkezi 			
                acc_form_grp = $("<div />");
                acc_form_grp.attr('class','form-group col col-12 col-md-12 col-sm-12 col-xs-12');
                acc_form_grp.appendTo(acc_div);
                
                acc_label = $("<label />");
                acc_label.attr('class','col col-4 col-md-4 col-sm-4 col-xs-12');
                acc_label.appendTo(acc_form_grp);

                acc_label.append('<cf_get_lang dictionary_id='58460.Masraf Merkezi'>');

                acc_inpt_grp1= $("<div />");
                acc_inpt_grp1.attr('class','col col-8 col-md-8 col-sm-8 col-xs-12');
                acc_inpt_grp1.appendTo(acc_form_grp);
                
                acc_inpt_grp = $("<div />");
                acc_inpt_grp.attr('class','input-group');
                acc_inpt_grp.appendTo(acc_inpt_grp1);
                
                acc_inpt_grp.append('<input type = "hidden" id = "acc_control_' + row_number + '_' + i  + '" name = "acc_control_' + row_number + '_' + i  + '" value = "">');

                acc_input = $("<input />").attr('id','acc_' + row_number + '_' + i );
                acc_input.attr('name','acc_' + row_number + '_' + i );
                acc_input.attr('type','text');
                acc_input.attr('readonly',true);
                acc_input.appendTo(acc_inpt_grp);

                acc_selector= $("<span />");
                acc_selector.attr('class','input-group-addon btnPointer icon-ellipsis');
                acc_selector.attr('onClick','pencere_ac("acc_' + row_number + '_' + i  + '","acc_control_' + row_number + '_' + i  + '");');
                acc_selector.appendTo(acc_inpt_grp);

                // 2 bütçe kalemi 
                select_block_type4 = $("<div />");
                select_block_type4.attr('class','form-group col col-12 col-md-12 col-sm-12 col-xs-12');
                select_block_type4.appendTo(acc_div);

                select_label = $("<label />");
                select_label.attr('class','col col-4 col-md-4 col-sm-4 col-xs-12');
                select_label.appendTo(select_block_type4);

                select_label.append('<cf_get_lang dictionary_id='58234.Bütçe Kalemi'>');

                select4_inpt_grp1= $("<div />");
                select4_inpt_grp1.attr('class','col col-8 col-md-8 col-sm-8 col-xs-12');
                select4_inpt_grp1.appendTo(select_block_type4);

                select4_inpt_grp = $("<div />");
                select4_inpt_grp.attr('class','input-group');
                select4_inpt_grp.appendTo(select4_inpt_grp1);
                
                select4_inpt_grp.append('<input type = "hidden" id = "bud_cat_control_' + row_number + '_' + i  + '" name = "bud_cat_control_' + row_number + '_' + i  + '" value = "">');

                budget_cat_input = $("<input />").attr('id','bud_cat_' + row_number + '_' + i );
                budget_cat_input.attr('name','bud_cat_' + row_number + '_' + i );
                budget_cat_input.attr('type','text');
                budget_cat_input.attr('readonly',true);
                budget_cat_input.appendTo(select4_inpt_grp);

                bud_cat_selector= $("<span />");
                bud_cat_selector.attr('class','input-group-addon btnPointer icon-ellipsis');
                bud_cat_selector.attr('onClick','pencere_item_ac("bud_cat_' + row_number + '_' + i  + '","bud_cat_control_' + row_number + '_' + i  + '");');
                bud_cat_selector.appendTo(select4_inpt_grp);

                // 3 proje
                select_block_type5 = $("<div />");
                select_block_type5.attr('class','form-group col col-12 col-md-12 col-sm-12 col-xs-12');
                select_block_type5.appendTo(acc_div);

                select_label_type = $("<label />");
                select_label_type.attr('class','col col-4 col-md-4 col-sm-4 col-xs-12');
                select_label_type.appendTo(select_block_type5);

                select_label_type.append('<cf_get_lang dictionary_id='57416.Proje'>');

                select5_inpt_grp1= $("<div />");
                select5_inpt_grp1.attr('class','col col-8 col-md-8 col-sm-8 col-xs-12');
                select5_inpt_grp1.appendTo(select_block_type5);

                select5_inpt_grp = $("<div />");
                select5_inpt_grp.attr('class','input-group');
                select5_inpt_grp.appendTo(select5_inpt_grp1);
                
                select5_inpt_grp.append('<input type = "hidden" id = "proje_control_' + row_number + '_' + i  + '" name = "proje_control_' + row_number + '_' + i  + '" value = "">');

                proje_input = $("<input />").attr('id','proje_id_' + row_number + '_' + i );
                proje_input.attr('name','proje_id_' + row_number + '_' + i );
                proje_input.attr('type','text');
                proje_input.attr('readonly',true);
                proje_input.appendTo(select5_inpt_grp);

                proje_selector= $("<span />");
                proje_selector.attr('class','input-group-addon btnPointer icon-ellipsis');
                proje_selector.attr('onClick','pencere_proje_ac("proje_id_' + row_number + '_' + i  + '","proje_control_' + row_number + '_' + i  + '");');
                proje_selector.appendTo(select5_inpt_grp);
                
                // 4 aktivite tipi
                act_type = $("<div />");
                act_type.attr('class','form-group col col-12 col-md-12 col-sm-12 col-xs-12');
                act_type.appendTo(acc_div);

                act_type_label = $("<label />");
                act_type_label.attr('class','col col-4 col-md-4 col-sm-4 col-xs-12');
                act_type_label.appendTo(act_type);

                act_type_label.append('<cf_get_lang dictionary_id='38378.Aktivite Tipi'>');

                act_type_input= $("<div />");
                act_type_input.attr('class','col col-8 col-md-8 col-sm-8 col-xs-12');
                act_type_input.appendTo(act_type);

                act_group_type6 = $("<select />").attr('id','exp_act_type_' + row_number + '_' + i);
                act_group_type6.attr('name','exp_act_type_' + row_number + '_' + i);
                act_group_type6.html('<select name="activity_id" id="activity_id" ><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_activity"><option value="#activity_id#">#activity_name#</option></cfoutput></select>');
                act_group_type6.appendTo(act_type_input);

                // 5 Serbest Bütçe
                acc_form_grp3 = $("<div />");
                acc_form_grp3.attr('class','form-group col col-12 col-md-12 col-sm-12 col-xs-12');
                acc_form_grp3.appendTo(acc_div);

                input_label_type1 = $("<label />");
                input_label_type1.attr('class','col col-4 col-md-4 col-sm-4 col-xs-12');
                input_label_type1.appendTo(acc_form_grp3);

                input_label_type1.append('<cf_get_lang dictionary_id='36567.Kullanılabilir'>');

                acc_inpt_grp4= $("<div />");
                acc_inpt_grp4.attr('class','col col-8 col-md-8 col-sm-8 col-xs-12');
                acc_inpt_grp4.appendTo(acc_form_grp3);

                acc_inpt_grp5 = $("<div />");
                acc_inpt_grp5.attr('class','input-group');
                acc_inpt_grp5.appendTo(acc_inpt_grp4);

                serbest_box = $("<input />").attr('id','serbest_' + row_number + '_' + i );
                serbest_box.attr('name','serbest_' + row_number + '_' + i );
                serbest_box.attr('type','text');
                serbest_box.attr('onkeyup','return(FormatCurrency(this,event));');
                serbest_box.attr('class','moneybox');
                serbest_box.attr('value','0');
                serbest_box.attr('readonly',true);
                serbest_box.attr('onChange','getTotalAmount("serbest_' + row_number + '_' + i  + '")');
                serbest_box.appendTo(acc_inpt_grp5);

                acc_selector3= $("<span />");
                acc_selector3.attr('class','input-group-addon btnPointer');
                acc_selector3.attr('title','<cf_get_lang dictionary_id='58998.Hesapla'>');
                acc_selector3.attr('onClick','hesapla("acc_control_' + row_number + '_' + i  + '","bud_cat_control_' + row_number + '_' + i  + '","proje_control_' + row_number + '_' + i  + '","' + row_number + '","' + i  + '");');
                acc_selector3.appendTo(acc_inpt_grp5);
                icon_ = $("<i />");
                icon_.attr('class','fa fa-calculator');
                icon_.appendTo(acc_selector3);

                // 8 aktarım tipi
                budget_plan_type = $("<div />");
                budget_plan_type.attr('class','form-group col col-12 col-md-12 col-sm-12 col-xs-12');
                budget_plan_type.appendTo(acc_div);

                budget_type_label = $("<label />");
                budget_type_label.attr('class','col col-4 col-md-4 col-sm-4 col-xs-12');
                budget_type_label.appendTo(budget_plan_type);
                budget_type_label.append('<cf_get_lang dictionary_id='36085.Aktarım Tipi'>');

                budget_type_input= $("<div />");
                budget_type_input.attr('class','col col-4 col-md-8 col-sm-8 col-xs-12');
                budget_type_input.appendTo(budget_plan_type);

                budget_group_type6 = $("<select />").attr('id','budget_plan_type_' + row_number + '_' + i);
                budget_group_type6.attr('name','budget_plan_type_' + row_number + '_' + i);
                budget_group_type6.html('<select name="plan_type" id="plan_type" ><option value="0"><cf_get_lang dictionary_id='58678.Gider'></option><option value="1"><cf_get_lang dictionary_id='58677.Gider'></option></select>');
                budget_group_type6.appendTo(budget_type_input);


				flag.appendTo(block);
				header.appendTo(blockDetailColumn);

				blockDetailColumn.appendTo(flag);
				
				arrow.appendTo(flag);
			
		}
</script>