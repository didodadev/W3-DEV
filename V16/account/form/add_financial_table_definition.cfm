<cfsavecontent  variable="header"><cf_get_lang dictionary_id="60077.Mali tablo tanımlama"></cfsavecontent>
<cfsavecontent  variable="message"><cf_get_lang dictionary_id="58194.Zorunlu alan"> <cf_get_lang dictionary_id='36201.Tablo Adı'></cfsavecontent>
<cfsavecontent  variable="message2"><cf_get_lang dictionary_id="58194.Zorunlu alan"> <cf_get_lang dictionary_id='30368.ÇAlışan'></cfsavecontent>
<cfsavecontent  variable="alan1"><cf_get_lang dictionary_id='36201.Tablo Adı'></cfsavecontent>
<cfsavecontent  variable="alert_control"><cf_get_lang dictionary_id='61190.Bu tanımdan oluşturulmuş mali tablo var, silemezsiniz.'></cfsavecontent>
<cfscript>
    if(isdefined("attributes.audit_id") and len(attributes.audit_id)){
        get_audit_det = createObject("component", "V16.account.cfc.get_financial_audits");
        get_audit_det.dsn2 = dsn2;
        get_audit_det.dsn_alias = dsn_alias;
        get_audit = get_audit_det.get_table_audit_fnc(audit_id:attributes.audit_id);
        get_audit_row = get_audit_det.get_table_audit_row_fnc(audit_id:attributes.audit_id);
    }
    else{
        get_audit.recordcount = 0;
        get_audit_row.recordcount = 0;
    }
       
    if(get_audit.recordcount){
        table_name = get_audit.table_name;
        table_type = get_audit.table_type;
        record_date = dateformat(get_audit.record_date,dateformat_style);
        record_emp = get_audit.record_emp;
        process_stage = get_audit.process_stage;
        detail = get_audit.detail;
    }
    else{
        table_name = "";
        table_type = "";
        record_date = "";
        record_emp = "";
        process_stage = "";
        detail = "";
    }
</cfscript>
<cf_catalystheader>
<cfform name="add_financial_def">
<cf_box>
<div class="ui-form-list ui-form-block">
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
        <cfif isdefined("attributes.audit_id") and len(attributes.audit_id)>
            <cfinput type="hidden" name="audit_id" value="#attributes.audit_id#">
            <cfinput type="hidden" name="is_del" value="0">
        </cfif>
        <div class="form-group" id="item-table_name">
            <label><cf_get_lang dictionary_id='36201.Tablo'> *</label>
            <cfif isdefined("attributes.audit_id") and len(attributes.audit_id)>
                <div class="input-group">
                    <cfinput type="text" name="table_name" id="table_name" value="#table_name#">
                    <cfif isdefined("attributes.audit_id") and len(attributes.audit_id)>
                        <span class="input-group-addon">
                                <cf_language_info 
                                table_name="FINANCIAL_AUDIT" 
                                column_name="TABLE_NAME" 
                                maxlength="500" 
                                datasource="#dsn2#" 
                                column_id_value="#attributes.audit_id#"
                                column_id="FINANCIAL_AUDIT_ID" 
                                control_type="0">
                        </span>
                    </cfif>
                </div>
            <cfelse>
                <cfinput type="text" name="table_name" id="table_name" value="#table_name#">
            </cfif>
        </div>
        <div class="form-group " id="item-table_type">
            <label><cf_get_lang dictionary_id='59088.Tip'></label>
            <select name="table_type" id="table_type">
                <option value="7" <cfif table_type eq 7>selected="selected"</cfif>>GELIR TABLOSU TANIMLARI</option>
                <option value="8" <cfif table_type eq 8>selected="selected"</cfif>>BILANÇO TABLOSU TANIMLARI</option>
                <option value="9" <cfif table_type eq 9>selected="selected"</cfif>>SATIŞLARIN MALİYETİ TABLOSU TANIMLARI</option>
                <option value="10" <cfif table_type eq 10>selected="selected"</cfif>>NAKİT AKIM TABLOSU TANIMLARI</option>
                <option value="11" <cfif table_type eq 11>selected="selected"</cfif>>FON AKIM TABLOSU TANIMLARI</option>
            </select>
            <cfswitch expression="#TABLE_TYPE#">
                <cfcase value="7">
                    <cfset fintab_type = "INCOME_TABLE">
                </cfcase>
                <cfcase value="8">
                    <cfset fintab_type = "BALANCE_TABLE">
                </cfcase>
                <cfcase value="9">
                    <cfset fintab_type = "COST_TABLE">
                </cfcase>
                <cfcase value="10">
                    <cfset fintab_type = "CASH_FLOW_TABLE">
                </cfcase>
                <cfcase value="11">
                    <cfset fintab_type = "FUND_FLOW_TABLE">
                </cfcase>
                <cfdefaultcase>
                    <cfset fintab_type = "INCOME_TABLE">
                </cfdefaultcase>
            </cfswitch>
            <cfinput type="hidden" name="fintab_type" id="fintab_type" value="#fintab_type#">
        </div>
    </div>
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
        <div class="form-group" id="item-record_id">
            <label><cf_get_lang dictionary_id='54606.Düzenleyen'> *</label>
            <div class="input-group">
                <cfinput type="hidden" name="record_id" id="record_id" value="#record_emp#">					
                <input type="text" name="record_name" id="record_name" value="<cfif len(record_emp)><cfoutput>#get_emp_info(record_emp,0,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('record_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','MEMBER_ID','record_id','','3','125');"  autocomplete="off" >                    
                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=add_financial_def.record_name&field_emp_id=add_financial_def.record_id&select_list=1','list');return false"></span>
            </div>
        </div>
        <div class="form-group" id="item-record_date">
            <label><cf_get_lang dictionary_id='48068.Tarih'> *</label>
            <div class="input-group">
                <cfsavecontent variable="message_"><cf_get_lang dictionary_id='58503.Lütfen Tarih giriniz'></cfsavecontent>
                <cfinput type="text" name="record_date" value="#record_date#" required="yes" validate="#validate_style#" message="#message_#">
                <span class="input-group-addon"><cf_wrk_date_image date_field="record_date"></span>
            </div>
        </div>
    </div>
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
        <div class="form-group" id="item-process_stage">
            <label><cf_get_lang dictionary_id='58859.Süreç'></label>
            <cfif not len(process_stage)>
                <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
            <cfelse>
                <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='1' select_value='#process_stage#' >
            </cfif>
        </div>
        <div class="form-group" id="item-detail">
            <label><cf_get_lang dictionary_id='36199.Açıklama'></label>
            <textarea name="detail" id="detail"><cfoutput>#detail#</cfoutput></textarea>
        </div>
    </div>
</div>
<div class="ui-scroll">
    <table class="ui-table-list ui-form">
        <thead>
            <tr>
                <cfinput type="hidden" name="record_num" value="#get_audit_row.recordcount#" id="record_num">
                <th style="width:40px;"><a onclick="add_row()" href="javascript://"><i class="fa fa-plus"></i></a></th>
                <th><cf_get_lang dictionary_id="38752.tablo"> <cf_get_lang dictionary_id="32646.Kodu">
                 <th><cf_get_lang dictionary_id="33354.Hesaplama Yöntemi"></th>
                  <th><cf_get_lang dictionary_id="38890.hesap adı">/<cf_get_lang dictionary_id="58233.tanım"></th>
                <th><cf_get_lang no ='37.Hesap Kodu'></th>
                <cfif session.ep.our_company_info.is_ifrs eq 1>
                    <th><cf_get_lang_main no='896.UFRS'></th>
                </cfif>
                <th><cf_get_lang dictionary_id="58596.Göster"></th>
                <th style="width:20px"></th>
            </tr>
        </thead>
         <tbody id="table_info">
        <cfif get_audit_row.recordcount>
        <cfoutput query="get_audit_row">
                <tr id="row#currentrow#">
                    <td>
                        <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                        <ul class="ui-icon-list">
                            <li><a href="javascript:delRow('#currentrow#')"><i class="fa fa-minus"></i></a></li>
                        </ul>
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="text" name="code#currentrow#" id="code#currentrow#" value="#code#">
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <select name="is_cumulative#currentrow#" id="is_cumulative#currentrow#" onchange="closeDiv(this.value,'#currentrow#')">
                                <option value="1" <cfif is_cumulative eq 1>selected="selected"</cfif>>Kümülatif</option>
                                <option value="0" <cfif is_cumulative eq 0>selected="selected"</cfif>>Hesap Kodu</option>
                            </select>
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                        <div class="input-group">
                                <input type="text" name="account_name#currentrow#" value="#name#" id="account_name#currentrow#">
                                 <span class="input-group-addon">
                                        <cf_language_info 
                                        table_name="FINANCIAL_AUDIT_ROW" 
                                        column_name="NAME" 
                                        maxlength="500" 
                                        datasource="#dsn2#" 
                                        column_id_value="#FINANCIAL_AUDIT_ROW_ID#"
                                        column_id="FINANCIAL_AUDIT_ROW_ID" 
                                        control_type="0">
                                </span>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <div class="input-group">
                           <!--- <cfif is_cumulative eq 0>--->
                                <cf_wrk_account_codes form_name='add_financial_def' account_code="account_name#currentrow#" is_multi_no='#currentrow#'>
                                <input type="text" name="account_code#currentrow#" id="account_code#currentrow#"  value="#account_code#" onkeyup="get_wrk_acc_code_#currentrow#();">
                                <span class="input-group-addon icon-ellipsis" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_id=add_financial_def.account_code#currentrow#&field_name=add_financial_def.account_name#currentrow#','list');"></span>
                         <!---   <cfelse>
                                <input type="hidden" name="account_code#currentrow#"  id="account_code#currentrow#" value="">
                            </cfif>--->
                            </div>
                        </div>
                    </td>
                    <cfif session.ep.our_company_info.is_ifrs eq 1>
                        <td>
                        <div class="form-group">
                            <div class="input-group">
                            <cfif is_cumulative eq 0>
                                <input type="text" name="ifrs_code#currentrow#" id="ifrs_code#currentrow#" value="#ifrs_code#">
                                 <span class="input-group-addon icon-ellipsis" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=add_financial_def.ifrs_code#currentrow#&field_name=add_financial_def.ifrs_code#currentrow#','list');"></span>
                           <cfelse>
                                <input type="hidden" name="ifrs_code#currentrow#" id="ifrs_code#currentrow#" value="">
                            </cfif>
                            </div>
                            </div>
                        </td>
                    </cfif>
                    <td>
                    <div  id="calculation#currentrow#" style="<cfif is_cumulative eq 0>display:block;<cfelse>display:none;</cfif>">
                        <div class="form-group col col-4 col-sm-4 col-xs-12">
                            <select name="sign#currentrow#" id="sign#currentrow#">
                                <option value="-" <cfif sign eq '-'>selected="selected"</cfif>>-</option>
                                <option value="+"  <cfif sign eq '+'>selected="selected"</cfif>>+</option>
                            </select>
                        </div>
                        <div class="form-group col col-4 col-sm-4 col-xs-12">
                            <select name="bakiye#currentrow#" id="bakiye#currentrow#">
                                <option value="1"  <cfif ba eq 1>selected="selected"</cfif>><cf_get_lang no ='110.Alacaklı'></option>
                                <option value="0"  <cfif ba eq 0>selected="selected"</cfif>><cf_get_lang_main no='768.Borçlu'></option>
                            </select>
                        </div>
                        <div class="form-group col col-4 col-sm-4 col-xs-12">
                            <select name="view_amount_type#currentrow#" id="view_amount_type#currentrow#">
                                <option value="0"  <cfif view_amount_type eq 0>selected="selected"</cfif>><cf_get_lang no ='118.Borç Göster'></option>
                                <option value="1"  <cfif view_amount_type eq 1>selected="selected"</cfif>><cf_get_lang no ='119.Alacak Göster'></option>
                                <option value="2"  <cfif view_amount_type eq 2>selected="selected"</cfif>><cf_get_lang no='58.Bakiye Göster'></option>
                            </select>
                        </div>
                    </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <div class="checkbox checbox-switch">
                                <label>
                                    <input type="checkbox" name="is_show#currentrow#" id="is_show#currentrow#" value="1" <cfif is_show eq 1>checked</cfif>>
                                    <span></span>
                                </label>
                            </div>
                        </div>
                    </td>
                   <!---  <td><a href="javascript:void(0)"><i class="fa fa-pencil"></i></a></td>--->
                </tr>
           
        </cfoutput>
        </cfif>
         </tbody>
    </table>
</div>
<cf_box_footer>
<div class="col col-6">
    <cfif get_audit.recordcount>
    <cf_record_info query_name="get_audit">
     </cfif>
</div>
<div class="col col-6">
    <cfif get_audit.recordcount>
        <cf_workcube_buttons add_function="control()" is_upd='1' is_delete='1' del_function="control2()">
    <cfelse>
        <cf_workcube_buttons add_function="control()">
    </cfif>
</div>
</cf_box_footer>
</cf_box>
</cfform>
<script type="text/javascript">
$( document ).ready(function() {
   
    row_count = '<cfoutput>#get_audit_row.recordcount#</cfoutput>';
});

    function control2(){
        
        fintab_type_ = $("#fintab_type").val();
        get_table = wrk_safe_query("get_financial_table",'dsn3',0,fintab_type_);
       if(get_table.recordcount){
               alert('<cfoutput>#alert_control#</cfoutput>');
            return false;
        } 
        <cfif isdefined("attributes.audit_id")>
            <cfoutput>
                add_financial_def.action='#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_stock_exchange&audit_id=#attributes.audit_id#';
            </cfoutput>
        </cfif>
        return true;
    }
    function closeDiv(val,rowCount){
        if(val == 1)
        $("#calculation"+rowCount).hide();
        else
        $("#calculation"+rowCount).show();
    }
    function control(){
        if($("#table_name").val()== ''){
             alert('<cfoutput>#message#</cfoutput>');
             return false;
        }
        if($("#record_id").val()== '' && $("#record_name").val()== ''){
             alert('<cfoutput>#message2#</cfoutput>');
             return false;
        }
        
        return true;
    }
    
    function delRow(rowCount)
	{
        $("#row_kontrol"+rowCount).val('0');
        $("#row"+rowCount).hide();
	}
    function OpenIfrs(rowCount){
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=add_financial_def.ifrs_code'+rowCount+'&field_name=add_financial_def.ifrs_code'+rowCount+'','list');
    }
    function OpenAccountCode(rowCount){
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_financial_def.account_code'+rowCount+'&field_name=add_financial_def.account_name'+rowCount+'','list');
    }
    function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table_info").insertRow(document.getElementById("table_info").rows.length);
		newRow.setAttribute("name","row"+row_count);
		newRow.setAttribute("id","row"+row_count);	
		document.getElementById('record_num').value = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count+'" id="row_kontrol'+row_count+'" value="1"> <ul class="ui-icon-list"><li><a href="javascript:delRow('+row_count+')"><i class="fa fa-minus"></i></a></li></ul>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="code'+row_count+'" id="code'+row_count+'"></div>';
        newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="is_cumulative'+row_count+'" id="is_cumulative'+row_count+'"  onchange="closeDiv(this.value,'+row_count+')"><option value="1">Kümülatif</option><option value="0">Hesap Kodu</option></select></div>';
        newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="account_name'+row_count+'" id="account_name'+row_count+'"></div>';
        newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="account_code'+row_count+'" id="account_code'+row_count+'" ><span class="input-group-addon icon-ellipsis" onclick="javascript:OpenAccountCode('+row_count+')"></span></div></div>';
        <cfif session.ep.our_company_info.is_ifrs eq 1>
            newCell = newRow.insertCell(newRow.cells.length);
		    newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="ifrs_code'+row_count+'" id="ifrs_code'+row_count+'" value=""><span class="input-group-addon icon-ellipsis" onclick="javascript:OpenIfrs('+row_count+')"></span></div></div>';
        </cfif>
        newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div style="display:none;" id="calculation'+row_count+'"><div class="form-group col col-4 col-sm-4 col-xs-12"><select name="sign'+row_count+'" id="sign'+row_count+'"><option value=""><option value="-" >-</option><option value="+" >+</option></select></div><div class="form-group col col-4 col-sm-4 col-xs-12"><select name="bakiye'+row_count+'" id="bakiye'+row_count+'"><option value="1" ><cf_get_lang no ='110.Alacaklı'></option><option value="0" ><cf_get_lang_main no='768.Borçlu'></option></select></div><div class="form-group col col-4 col-sm-4 col-xs-12"><select name="view_amount_type'+row_count+'" id="view_amount_type'+row_count+'"><option value="0" ><cf_get_lang no ='118.Borç Göster'></option><option value="1" ><cf_get_lang no ='119.Alacak Göster'></option><option value="2" ><cf_get_lang no='58.Bakiye Göster'></option></select></div></div>';
        newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="checkbox checbox-switch"><label><input type="checkbox" name="is_show'+row_count+'" id="is_show'+row_count+'" value="1"><span></span></label></div></div>';
	
    }

     
</script>