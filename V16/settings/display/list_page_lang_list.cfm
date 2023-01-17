<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
        <cf_flat_list>
            <thead>
                <tr>
                    <th data-column-id="id" data-type="numeric">ID</th>
                    <th data-column-id="received" data-order="desc">Module</th>
                    <th data-column-id="sender">Data</th>
                    <th></th>
                </tr>
            </thead>
            <tbody id="grid-basic">
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>
<script>
function open_p(str){
    windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_upd_lang_item'+str,'wide');
}
    var data = window.opener.document.pagelanglist.langlist.value;
    data = jQuery.parseJSON(data);
    var accid = new Array();
    var accmodule = new Array();
    rowcount = 0;
 
    function writeRow(i){
        id_  = i.ID;
        deger_ = i.DEGER;
        module_ = i.MODULE;
        type_ = i.TYPE;
        if(type_ == 'module'){
            str="&strmodule="+module_+"&item_id="+id_+"&lang=TR";
        }
        else{
            str="&dictionary_id="+id_+"&lang=TR";
        }
        rowcount ++;
        newRow = document.getElementById("grid-basic").insertRow();
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = rowcount;
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = id_;
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = module_;
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<a href="javascript://" class="tableyazi" onclick="open_p(\''+str+'\')">'+deger_+'</a>';
    }

    data.filter((i)  =>   {
        if(i.TYPE == 'module'){
            if((accid.indexOf(i.ID) === -1) || (accid.indexOf(i.ID) > -1 && i.MODULE != accmodule[accid.indexOf(i.ID)])){
                accid.push(i.ID);
                accmodule.push(i.MODULE);
                writeRow(i);
            }
        }else{
            writeRow(i)
        }
    });
</script>