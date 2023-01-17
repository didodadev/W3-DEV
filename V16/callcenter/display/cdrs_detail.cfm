<cfset getComponent = createObject('component', 'WEX.cti.cfc.verimor')>
<cfset getCallInformations = getComponent.getCallInformations()>
<cfparam name="attributes.tels" default="">
<cfparam name="attributes.fuseact" default="call.phone">
<cf_grid_list>
    <thead>
        <tr>
            <th>GG</th>
            <th><cf_get_lang dictionary_id='62653.Arayan Telefon'></th>
            <th><cf_get_lang dictionary_id='62654.Aranan Telefon'></th>
            <th><cf_get_lang dictionary_id='30259.Dahili'></th>
            <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
            <th><cf_get_lang dictionary_id='58463.Tarih ve Saat'></th>
            <th><cf_get_lang dictionary_id='29513.Süre'></th>
            <th><cf_get_lang dictionary_id='41580.Sonuç'></th>
            <th><a href="<cfoutput>#request.self#?fuseaction=call.phone</cfoutput>"><i class="fa fa-phone"></i></a></th>
        </tr>
    </thead>
    <tbody id="cdrs_list"></tbody>
</cf_grid_list>
<script>
    var telstring = "<cfoutput>#attributes.tels#</cfoutput>";
    var fuseact = "<cfoutput>#attributes.fuseact#</cfoutput>";
    var formObjects = {};
    formObjects.api_key="<cfoutput>#getCallInformations.api_key#</cfoutput>";
    $.ajax({
        url :'/wex.cfm/cti/cdrs',
        method: 'post',
        contentType: 'application/json; charset=utf-8',
        dataType: "json",
        data : JSON.stringify(formObjects),
        success : function(response){
            var newRow, newCell;
            for (var i = 0; i < response.cdrs.length; i++) {
                if(telstring.includes( response.cdrs[i].caller_id_number) || telstring.includes( response.cdrs[i].caller_id_number.substring(1)) || telstring.includes( response.cdrs[i].destination_number) || telstring.includes( response.cdrs[i].destination_number.substring(1)) || fuseact == 'call.phone'){
                    var icon = '<i class="catalyst-call-in margin-right-5"></i>';
                    newRow = document.getElementById("cdrs_list").insertRow();	
                    newCell = newRow.insertCell(newRow.cells.length);
                    if( response.cdrs[i].direction == 'Giden')
                        icon = '<i class="catalyst-call-out"></i>';
                    newCell.innerHTML = icon + response.cdrs[i].direction;
                    // newCell = newRow.insertCell(newRow.cells.length);
                    // newCell.innerHTML =  'unknown';
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.innerHTML =  response.cdrs[i].caller_id_number;
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.innerHTML =  response.cdrs[i].destination_number.split(" ")[0];
                    newCell = newRow.insertCell(newRow.cells.length);
                    if(response.cdrs[i].destination_number.split(" ")[1])newCell.innerHTML =  response.cdrs[i].destination_number.split(" ")[1];
                    newCell = newRow.insertCell(newRow.cells.length);
                    if( response.cdrs[i].direction == 'giden')
                        newCell.innerHTML =  response.cdrs[i].destination_name;
                    else
                        newCell.innerHTML =  response.cdrs[i].caller_id_name;
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.innerHTML =  response.cdrs[i].answer_stamp;
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.innerHTML =  response.cdrs[i].duration;
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.innerHTML =  response.cdrs[i].result;
                    newCell = newRow.insertCell(newRow.cells.length);
                    if(response.cdrs[i].recording_present == "true"){
                        newCell.innerHTML =  '<a id ="row'+i+'" href="javascript://" target="_blank"></a>';
                        get_recording(response.cdrs[i].call_uuid,i);
                    }
                    else
                        newCell.innerHTML =  '<a id ="row'+i+'" href="javascript://"><i class="fa fa-volume-off"></i></a>';
                }
            }
            if($('#cdrs_list tr').length == 0){
                newRow = document.getElementById("cdrs_list").insertRow();	
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.setAttribute('colspan','9');
                newCell.innerHTML =  "<cf_get_lang dictionary_id='57484.No record'>!";
            }
        }

    });
    function get_recording(call_uuid,id){
        var records = {};
        records.api_key="<cfoutput>#getCallInformations.api_key#</cfoutput>";
        records.call_uuid = call_uuid;
        $.ajax({
            url :'/wex.cfm/cti/recording',
            method: 'post',
            contentType: 'application/json; charset=utf-8',
            dataType: "json",
            data : JSON.stringify(records),
            error :  function(response){
                if(response.responseText != "")
                    $('#row'+id).attr("href",response.responseText).append('<i class="fa fa-volume-up"></i>');
            }
        });
    }
</script>