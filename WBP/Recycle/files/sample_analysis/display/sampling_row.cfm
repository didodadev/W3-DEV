<cfset sampling = createObject("component","WBP/Recycle/files/sample_analysis/cfc/sampling") />

<cf_xml_page_edit fuseact = "lab.sampling">

<cfparam name = "attributes.sampling_id" default="0">
<cfset get_sampling_row = sampling.getSamplingRow(sampling_id : attributes.sampling_id)>
<script type = "text/javascript">
    function product_control(i){/*Ürün seçmeden spec seçemesin.*/  
        if($('#product_id'+i).val()== "" ){
            alert(i+'. satırda ürün seçmelisiniz!');
            return false;
         }
         else{
            var pid= $('#product_id'+i).val();
            openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=analyzeLabTest.spect_var_id'+i+'&field_name=analyzeLabTest.spect_name'+i+'&is_display=1&product_id='+pid);
        }
    } 
 
     function open_product_popup(row_id) {
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=analyzeLabTest.stock_id&product_id=analyzeLabTest.product_id&field_name=analyzeLabTest.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.analyzeLabTest.product_name.value) + '&row_number=' + row_id,'list');
     }
 </script>
<cf_grid_list sort="0">
    <thead>
        <tr>
            <th width="20"><a href="javascript://" onclick="addSamplingRow()"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
            <th width="300"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
            <th width="300"><cf_get_lang dictionary_id='57657.Ürün'></th>
            <th width="100"><cf_get_lang dictionary_id='36199.Açıklama'></th>
            <th width="100"><cf_get_lang dictionary_id='45498.Lot No'></th>
            <th width="100"><cf_get_lang dictionary_id='57647.Spekt'></th>
            <th width="100"><cf_get_lang dictionary_id='29412.Seri'></th>
            <th width="100"><cf_get_lang dictionary_id='51408.Stok Miktarı'></th>
            <th width="100"><cf_get_lang dictionary_id='57636.Birim'></th>
            <th width="100"><cf_get_lang dictionary_id='62092.Numune Miktarı'></th>
        </tr>
    </thead>
    <cfif get_sampling_row.recordCount>
        <tbody class="total_c">
            <cfoutput query="get_sampling_row">
                <tr name="frm_row#currentrow#" id="frm_row#currentrow#">  
                    <input type="hidden" name="samplingRowCount" id="samplingRowCount" value="#get_sampling_row.recordCount#">
                    <input type="hidden" name="sampling_id" id="sampling_id" value="#attributes.sampling_id#">
                    <td class="text-center">
                        <input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
                        <input type="hidden" value="0" name="samplingRowDeleted#currentrow#" id="samplingRowDeleted#currentrow#">
                        <input type="hidden" value="#SAMPLING_ROW_ID#" name="samplingRowId#currentrow#" id="samplingRowId#currentrow#">
                        <a href="javascript://" onclick="removeSamplingRow(#currentrow#);"><i class="fa fa-minus"></i></a> 
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="text" name="stock_code#currentrow#" id="stock_code#currentrow#" value="#STOCK_CODE#" readonly>
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <div class="input-group">
                                <input type="text" readonly name="product_name#currentrow#" id="product_name#currentrow#" class="boxtext" value="#PRODUCT_NAME# #PROPERTY#">
                                <input  type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#PRODUCT_ID#">
                                <input  type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#STOCK_ID#">
                                <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_product(#currentrow#);"></span>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="text" name="description#currentrow#" id="description#currentrow#"  class="boxtext" value="#DESCRIPTION#">
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="text" name="lot_no#currentrow#" id="lot_no#currentrow#" class="boxtext" value="#LOT_NO#">
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <div class="input-group">
                                <input type="hidden" name="spect_var_id#currentrow#" id="spect_var_id#currentrow#" class="boxtext" value="#SPECT_VAR_ID#">
                                <input type="text" id="spect_name#currentrow#" name="spect_name#currentrow#" class="boxtext" value="<cfif len(SPECT_NAME)>#SPECT_NAME#</cfif>" >
                                <span class="input-group-addon icon-ellipsis" onClick="product_control(#currentrow#);"></span>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="text" name="serial_no#currentrow#" id="serial_no#currentrow#"  class="boxtext" value="#SERIAL_NO#">
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="text" readonly name="stock_amount#currentrow#" id="stock_amount#currentrow#" class="box" value="#TLFormat(stock_amount,4)#">
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="hidden" name="stock_unit_id#currentrow#" id="stock_unit_id#currentrow#" value="#STOCK_UNIT_ID#">
                            <input type="text" name="stock_unit#currentrow#" id="stock_unit#currentrow#" value="#STOCK_UNIT#" class="boxtext" readonly>
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="text" name="sample_amount#currentrow#" id="sample_amount#currentrow#" class="box" value="#TLFormat(sample_amount,4)#" onkeyup="return(FormatCurrency(this,event,4));" onkeypress="return NumberControl(event);">
                        </div>
                    </td>
                </tr>
            </cfoutput>
        </tbody>
    </cfif>
    <tbody id="sampling_row_body" class="total_c">
    </tbody>
        <input type="hidden" name="total_count" id="total_count" value="">
</cf_grid_list>



<script type="text/javascript">
        
    $('#total_count').val($(".total_c tr").length);
    <cfif get_sampling_row.recordCount>
        row_count =document.getElementById("samplingRowCount").value ;
    <cfelse>
        row_count= 0;
    </cfif>

	function addSamplingRow(stock_id,stock_unit_id,stock_code,product_id,product_name,description,lot_no,spect_var_id,spect_name,serial_no,stock_amount,stock_unit,sample_amount,sampling_row_id)
	{  
        
        
		if (stock_id == undefined) stock_id ="";
		if (stock_unit_id == undefined) stock_unit_id ="";
        if (stock_code == undefined) stock_code ="";
		if (product_id == undefined) product_id ="";
		if (product_name == undefined) product_name ="";
		if (description == undefined) description ="";
		if (lot_no == undefined) lot_no ="";
		
		if (spect_var_id == undefined) spect_var_id ="";
		if (spect_name == undefined) spect_name ="";
		if (serial_no == undefined) serial_no ="";
		if (stock_amount == undefined) stock_amount ="";
		if (stock_unit == undefined) stock_unit ="";
		if (sample_amount == undefined) sample_amount ="";
        
		if (sampling_row_id == undefined) sampling_row_id ="";

		row_count++;
		var newRow;
		var newCell;

		newRow = document.getElementById("sampling_row_body").insertRow(document.getElementById("sampling_row_body").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
        
		newCell = newRow.insertCell(newRow.cells.length);        
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><input type="hidden" value="0" name="samplingRowDeleted' + row_count +'" id="samplingRowDeleted' + row_count +'"><input type="hidden" value="' + sampling_row_id + '" name="samplingRowId' + row_count +'" id="samplingRowId' + row_count +'"><a href="javascript://" onclick="removeSamplingRow(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Delete'>" alt="<cf_get_lang dictionary_id='57463.Delete'>"></i></a>';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<div class="form-group"><input type="text" name="stock_code' + row_count +'" id="stock_code' + row_count +'" value="'+ stock_code + '" readonly></div>';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" readonly name="product_name' + row_count +'" id="product_name' + row_count +'" class="boxtext"  onFocus="AutoComplete_Create(\'product_name' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME,STOCK_CODE\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID,PRODUCT_COST,MAIN_UNIT,PRODUCT_UNIT_ID\',\'product_id' + row_count +',stock_id' + row_count +',total' + row_count  +',stock_unit' + row_count  +',stock_unit_id' + row_count  +'\',\'add_costplan\',1,\'\',\'format_total_value(' + row_count + ');\');" value="'+product_name+'"><input  type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="'+product_id+'"><input  type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="'+stock_id+'"><span class="input-group-addon icon-ellipsis ellipsis-red" onClick="windowopen('+"'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+document.getElementById('product_id"+row_count+"').value+'&sid='+document.getElementById('stock_id"+row_count+"').value+'','list');"+'"></span> <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_product('+row_count+');"></span></div></div>';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<div class="form-group"><input type="text" name="description' + row_count +'" id="description' + row_count +'"  class="boxtext" value="'+description+'"></div>';

        newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="lot_no' + row_count +'" id="lot_no' + row_count +'"  class="boxtext" value="'+lot_no+'"></div>';

        newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="spect_var_id' + row_count +'" id="spect_var_id' + row_count +'" class="boxtext" value="'+spect_var_id+'"><input type="text" id="spect_name' + row_count +'" name="spect_name' + row_count +'" class="boxtext" value="'+spect_name+'" ><span class="input-group-addon icon-ellipsis" onClick="product_control('+ row_count +');"></span></div></div>';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<div class="form-group"><input type="text" name="serial_no' + row_count +'" id="serial_no' + row_count +'"  class="boxtext" value="'+serial_no+'"></div>';

        newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" readonly name="stock_amount' + row_count +'" id="stock_amount' + row_count +'" class="box" value="'+ commaSplit(stock_amount,4)+ '"></div>';

        newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="stock_unit_id' + row_count +'" id="stock_unit_id' + row_count +'" value="'+stock_unit_id+'"><input type="text" name="stock_unit' + row_count +'" id="stock_unit' + row_count +'"  value="'+stock_unit+'" class="boxtext" readonly></div>';

        newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="sample_amount' + row_count +'" id="sample_amount' + row_count +'" class="box" value="'+ commaSplit(sample_amount,4)+ '" onkeyup="return(FormatCurrency(this,event,4));" onkeypress="return NumberControl(event);"></div>';
        $('#total_count').val($(".total_c tr").length);
        
	}
    function pencere_ac_product(no) {
		unit_url_ = "";
		if(document.getElementById("stock_unit"+ no) != undefined)
			unit_url_ = '&field_unit_name= all.stock_unit' + no+'&field_main_unit=all.stock_unit_id' + no;
		satir_info='product_name';
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&run_function=get_product_stock&run_function_param='+no+'&field_code=all.stock_code' + no + '&product_id=all.product_id' + no + '&field_id=all.stock_id' + no + unit_url_ + '&field_name=all.product_name'+no);
    }

    function get_spect_name() {
            var row_id= <cfoutput>#get_sampling_row.recordcount#</cfoutput>;
                for (i = 0; i <= row_id; i++) {
                
                    s_id= $('#spect_var_id'+i).val();
                    get_spect_name = wrk_query('SELECT SPECT_MAIN_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID ='+s_id,'dsn3');
                    $('#spect_name'+i).val(String(get_spect_name.SPECT_MAIN_NAME)) ;
            }
    }

    function get_product_stock(no) {
        var new_sql = 'prdp_get_total_stock';
        stock_id_list = $("#stock_id" + no).val();
        var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + 0 + "*<cfoutput>#now()#</cfoutput>";
        var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
        if(get_total_stock.PRODUCT_TOTAL_STOCK != undefined){
            $("#stock_amount" + no).val(commaSplit(get_total_stock.PRODUCT_TOTAL_STOCK[0],4));
        }
    }

    function removeSamplingRow(row_id) {
        if(confirm( "<cf_get_lang dictionary_id='62142.Silmek istediğinize emin misiniz?'>" )) $("#frm_row"+row_id+"").hide().find("#samplingRowDeleted" + row_id).val(1);
    }

    <cfif get_sampling_row.recordcount>
        get_spect_name();
        <cfoutput query = "get_sampling_row">
           
            get_product_stock(document.getElementById("samplingRowCount").value);
        </cfoutput> 
    </cfif>
</script>

