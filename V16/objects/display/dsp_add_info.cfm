<cfsetting showdebugoutput="no">
<cfquery name="get_info" datasource="#dsn3#">
	SELECT * FROM SUBSCRIPTION_INFO WHERE SUBSCRIPTION_ID = #attributes.subscription_id#
</cfquery>
<cfform name="my_form_1" method="post" action="#request.self#?fuseaction=objects.emptypopup_subscription_add_info">
    <cfoutput>
        <input type="hidden" name="record_num1" id="record_num1" value="#get_info.RECORDCOUNT#">
        <input type="hidden" name="subscription_id" id="subscription_id" value="#attributes.subscription_id#">
    </cfoutput>
    <cf_flat_list>
        <thead>
            <tr>
                <th width="20"><a onClick="add_rows();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                <th width="200"><cf_get_lang dictionary_id='57629.Açıklama'></th>
            </tr>
        </thead>
        <tbody id="table_info">
        <cfoutput query="get_info">
            <tr id="row#currentrow#">
                <td width="20">
                    <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                    <a onclick="del_row(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                </td>
                <td width="200"><div class="form-group"><input type="text" name="detail#currentrow#" id="detail#currentrow#" value="#detail#" maxlength="250"></div></td>
            </tr>	
        </cfoutput>
        </tbody>
    </cf_flat_list>
    <cf_box_footer>
        <div id="show_add_info" style="float:left;"></div>
        <input type="button" class="ui-wrk-btn ui-wrk-btn-success" name="gonder" value="<cf_get_lang dictionary_id='59031.Kaydet'>" onclick="gelen();" />
    </cf_box_footer>
</cfform>

<script type="text/javascript">
	row_count=<cfoutput>#get_info.RECORDCOUNT#</cfoutput>;
	function del_row(sy)
	{
		document.getElementById('row_kontrol'+sy).value = 0;
		document.getElementById('row'+sy).style.display="none";
	}
	function add_rows()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table_info").insertRow(document.getElementById("table_info").rows.length);
		newRow.setAttribute("name","row"+row_count);
		newRow.setAttribute("id","row"+row_count);	
		document.getElementById('record_num1').value = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count+'" id="row_kontrol'+row_count+'" value="1"><a onclick="del_row(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('align','center');
		newCell.innerHTML = '<div class="form-group"><input type="text" name="detail'+row_count+'" value="" maxlength="250"></div>';
	}
	
	function gelen()
	{
			//my_form_1.submit();
			AjaxFormSubmit('my_form_1','show_add_info',1,'<cf_get_lang dictionary_id="58889.Kaydediliyor">','<cf_get_lang dictionary_id="58890.Kaydedildi">',"","",1);
		}
</script>

