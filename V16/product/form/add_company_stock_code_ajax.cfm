<cfsetting showdebugoutput="no">
<cfquery name="GET_COMPANY_STOCK_CODE" datasource="#DSN1#">
    SELECT
        SCSC.COMPANY_STOCK_ID,
        SCSC.COMPANY_ID,
        SCSC.COMPANY_PRODUCT_NAME,
        SCSC.COMPANY_STOCK_CODE,
        SCSC.DETAIL,
        SCSC.IS_ACTIVE,
        SCSC.PRIORITY,
        SCSC.STOCK_ID,
        SCSC.UNIT_ID,
        C.FULLNAME
    FROM
        SETUP_COMPANY_STOCK_CODE SCSC,
        #dsn_alias#.COMPANY C
    WHERE
       	SCSC.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#"> AND
    	SCSC.COMPANY_ID = C.COMPANY_ID
</cfquery>
<cfquery name="GET_PRODUCT_UNIT" datasource="#DSN3#">
    SELECT 
        PRODUCT_UNIT_ID,
        IS_MAIN,
        MAIN_UNIT_ID,
        ADD_UNIT,
        UNIT_ID,
        MULTIPLIER,
        QUANTITY,
        MAIN_UNIT,
        IS_ADD_UNIT
    FROM 
        PRODUCT_UNIT 
    WHERE 
        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND 
        PRODUCT_UNIT_STATUS = 1
</cfquery>
<cfset unit_options = "">
<cfloop query="get_product_unit">
    <cfset unit_options = unit_options & '<option value="#UNIT_ID#">#ADD_UNIT#</option>'>
</cfloop>
<cfsavecontent  variable="message"><cf_get_lang dictionary_id="37125.Üye Stok Kodu">
</cfsavecontent>
<cf_box title="#message#" popup_box="1">
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=product.emptypopup_add_company_stock_code&from_product_detail=1">
<cf_grid_list>
    <thead>
        <tr>
            <input type="hidden" name="form_upd_" id="form_upd_" value="1">
            <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.sid#</cfoutput>">
            <input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_company_stock_code.recordcount#</cfoutput>">
            <th style="text-align:center;"><input type="button" class="eklebuton" title="Ekle" onclick="add_row();"></th>
            <th width="170" align="left"><cf_get_lang dictionary_id='57658.Uye'> *</th>
            <th width="150" align="left"><cf_get_lang dictionary_id='57658.Üye'><cf_get_lang dictionary_id='57518.Stok Kodu'> *</th>
            <th width="150" align="left"><cf_get_lang dictionary_id='57658.Üye'><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
            <th width="50" align="left"><cf_get_lang dictionary_id='57636.Unit'></th>
            <th style="width:150px; text-align:left;"><cf_get_lang dictionary_id='57629.Aciklama'></th>
            <th style="width:70px; text-align:left;"><cf_get_lang dictionary_id='57485.Oncelik'></th>
            <th style="width:30px; text-align:left;"><cf_get_lang dictionary_id='57493.Aktif'></th>
        </tr>
    </thead>
    <tbody name="table1" id="table1">
		<cfoutput query="get_company_stock_code">
            <tr id="frm_row#currentrow#">
                <td width="20px" style="cursor:pointer;text-align:center;"><a style="cursor:pointer" onclick="sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                <td>
                    <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                    <input type="hidden" name="stock_id#get_company_stock_code.currentrow#" id="stock_id#get_company_stock_code.currentrow#" value="#stock_id#">
                    <input type="hidden" style="width:150px;" name="member_id#currentrow#" id="member_id#currentrow#" value="#get_company_stock_code.company_id#">
                    <input type="text" name="member_name#currentrow#" id="member_name#currentrow#" value="#get_company_stock_code.fullname#" style="width:160px;" onfocus="AutoComplete_Create('member_name#currentrow#','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','member_id#currentrow#','','3','150');" autocomplete="off">
                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=form_basket.member_name#currentrow#&field_comp_id=form_basket.member_id#currentrow#&select_list=2&keyword='+encodeURIComponent(document.form_basket.member_name#currentrow#.value),'list');"><img src="/images/plus_thin.gif" border="0" title="<cf_get_lang dictionary_id='57785.Üye Seçiniz'>" align="absmiddle"></a>
                    </td>
                <td><input type="text" name="company_stock_code#currentrow#" id="company_stock_code#currentrow#" value="#company_stock_code#" style="width:150px;" maxlength="150"></td>
                <td><input type="text" name="company_product_name#currentrow#" id="company_product_name#currentrow#" value="#company_product_name#" style="width:150px;" maxlength="500"></td>
                <td>
                    <select  name="company_stock_unit#currentrow#" id="company_stock_unit#currentrow#" style="width:50px;">
                        <option value=""></option>
                        <cfloop query="GET_PRODUCT_UNIT">
                            <option value="#UNIT_ID#" <cfif get_company_stock_code.UNIT_ID eq UNIT_ID>selected</cfif>>#ADD_UNIT#</option>
                        </cfloop>
                    </select>
                </td>
                <td><input type="text" name="company_product_detail#currentrow#" id="company_product_detail#currentrow#" value="#detail#" style="width:150px;" maxlength="250"></td>
                <td><input type="text" name="company_product_priority#currentrow#" id="company_product_priority#currentrow#" value="#priority#" maxlength="3" onkeyup="isNumber(this);" style="width:50px;text-align:right;"></td>
                <td><input type="checkbox" name="is_active#currentrow#" id="is_active#currentrow#" <cfif is_active eq 1>checked="checked"</cfif>/></td>
            </tr>
        </cfoutput>
    </tbody>
    <tfoot>
    	<tr>
        	<td colspan="8"><cf_workcube_buttons type_format="1" is_upd='0' is_cancel='0' add_function='satir_kontrol()'></td>
        </tr>
    </tfoot>
</cf_grid_list>
</cfform>
  </cf_box> 
<script type="text/javascript">
    row_count=<cfoutput>#get_company_stock_code.recordcount#</cfoutput>;
    function sil(sy)
    {
        var my_element=eval("form_basket.row_kontrol"+sy);
        my_element.value=0;
        var my_element=eval("frm_row"+sy);
        my_element.style.display="none";
    }
	
    function add_row()
    {
        row_count++;
        var newRow;
        var newCell;
        unit_options = '<option value=""></option>' + String('<cfoutput>#unit_options#</cfoutput>'); 
            
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
        newRow.setAttribute("name","frm_row" + row_count);
        newRow.setAttribute("id","frm_row" + row_count);		
        newRow.setAttribute("NAME","frm_row" + row_count);
        newRow.setAttribute("ID","frm_row" + row_count);		
                    
        document.form_basket.record_num.value=row_count;
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.setAttribute('nowrap','nowrap');
        newCell.innerHTML = '<a style="cursor:pointer;text-align:center;" onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';				
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"  value="1"><input type="hidden" name="member_id' + row_count +'" id="member_id' + row_count +'"><input type="text" style="width:160px;" name="member_name' + row_count + '" id="member_name' + row_count + '" style="width:100px;"> <a href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=form_basket.member_name' + row_count + '&field_comp_id=form_basket.member_id' + row_count + '&select_list=2&keyword=\'+document.form_basket.member_name' + row_count + '.value,\'list\');"><img src="/images/plus_thin.gif" border="0" alt="Üye Seçiniz" align="absmiddle"></a>';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="company_stock_code' + row_count + '" id="company_stock_code' + row_count + '" style="width:150px;" maxlength="100">';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="company_product_name' + row_count + '" id="company_product_name' + row_count + '" style="width:150px;" maxlength="500">';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="company_stock_unit' + row_count + '" id="company_stock_unit' + row_count + '" style="width:50px;">' + unit_options + '</select>';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="company_product_detail' + row_count + '" id="company_product_detail' + row_count + '" style="width:150px;" maxlength="250">';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="company_product_priority' + row_count + '" id="company_product_priority' + row_count + '" style="width:50px;text-align:right;" onkeyup="isNumber(this);" maxlength="3">';
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="checkbox" name="is_active' + row_count + '" id="is_active' + row_count + '">';
    }

    function satir_kontrol()
    {
        if(document.form_basket.record_num.value > 0)
        {	
            for(r=1;r<=form_basket.record_num.value;r++)
            {
                if(eval("document.form_basket.row_kontrol"+r).value == 1 && (eval("document.form_basket.member_id"+r).value == "" || eval("document.form_basket.member_name"+r).value == ""))
                {
                    alert("<cf_get_lang dictionary_id='57785.Üye Seçmelisiniz'> !");
                    return false;
                }
                if(eval("document.form_basket.row_kontrol"+r).value == 1)
                if(!form_warning('company_stock_code'+r,'Üye Stok Kodu Girmelisiniz!'))return false;
            }	
			form_basket.submit();
			return false;
        }
		else
		{
			alert('<cf_get_lang dictionary_id="37293.Üye Stok Kodu Ekleyiniz"> !');
			return false;
		}
    }
</script>

