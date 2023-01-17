<cfquery name="get_conf_test_parameters" datasource="#dsn3#">
	SELECT
        SPCP.*,
        QCT.QUALITY_CONTROL_TYPE
    FROM SETUP_PRODUCT_CONFIGURATOR_PARAMETER AS SPCP
    JOIN QUALITY_CONTROL_TYPE AS QCT ON SPCP.TYPE_ID = QCT.TYPE_ID
    WHERE PRODUCT_CONFIGURATOR_ID = <cfqueryparam value = "#attributes.product_configurator_id#" CFSQLType = "cf_sql_integer">
</cfquery>
<input type="hidden" name="testParameterCount" id="testParameterCount" value="<cfoutput>#get_conf_test_parameters.recordcount#</cfoutput>">
<cf_grid_list id="testParameters">
    <thead>
        <tr>
            <th width="20" class="header_icn_none"><a href="javascript://" onClick="addTestParameter()"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
            <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
            <th><cf_get_lang dictionary_id='57630.Tip'>*</th>
            <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
            <th><cf_get_lang dictionary_id='43699.Standart Değer'>*</th>
            <th><cf_get_lang dictionary_id='57686.Ölçü'>*</th>
            <th><cf_get_lang dictionary_id='29443.Tolerans'>*</th>
        </tr>
    </thead>
    <tbody>
        <cfif get_conf_test_parameters.recordcount>
            <cfoutput query="get_conf_test_parameters">
                <tr id="testparam#currentrow#" valign="top">
                    <td width='20' class='text-center'>
                        <a style='cursor:pointer;' onclick='delTestParameter(#currentrow#);'><i class='fa fa-minus'></i></a>
                    </td>
                    <td>#currentrow#</td>
                    <td>
                        <div class="form-group">
                            <div class="input-group">
                                <input type='hidden' name="type_id#currentrow#" id="type_id#currentrow#" value="#TYPE_ID#">
                                <input type="text" name="quality_control_type#currentrow#" id="quality_control_type#currentrow#" value="#QUALITY_CONTROL_TYPE#">
                                <span class="input-group-addon icon-ellipsis" onclick="setParam(#currentrow#)"></span>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="text" name="type_description#currentrow#" id="type_description#currentrow#" value="#TYPE_DESCRIPTION#">
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="text" name="standart_value#currentrow#" id="standart_value#currentrow#" onkeyup="return(FormatCurrency(this,event,4,'float'));" value="#TLFormat(STANDART_VALUE)#">
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="text" name="quality_measure#currentrow#" id="quality_measure#currentrow#" onkeyup="return(FormatCurrency(this,event,4,'float'));" value="#TLFormat(QUALITY_MEASURE)#">
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="text" name="tolerance#currentrow#" id="tolerance#currentrow#" onkeyup="return(FormatCurrency(this,event,4,'float'));" value="#TLFormat(TOLERANCE)#">
                        </div>
                    </td>
                </tr>
            </cfoutput>
        </cfif>
    </tbody>
</cf_grid_list>

<script>
    var jsonArray = [{
        "remove" : "<a style='cursor:pointer;' onclick='delTestParameter(###id###);'><i class='fa fa-minus'></i></a>",
        "rowCount" : "###id###",
        "quality_control_type": "<div class='form-group'><div class='input-group'><input type='hidden' name='type_id###id###' id='type_id###id###'><input type='text' name='quality_control_type###id###' id='quality_control_type###id###'><span class='input-group-addon icon-ellipsis' onclick=\"setParam(###id###)\"></span></div></div>",
        "type_description": "<div class='form-group'><input type='text' name='type_description###id###' id='type_description###id###'></div>",
        "standart_value": "<div class='form-group'><input type='text' name='standart_value###id###' id='standart_value###id###' onkeyup=\"return(FormatCurrency(this,event,4,'float'));\"></div>",
        "quality_measure": "<div class='form-group'><input type='text' name='quality_measure###id###' id='quality_measure###id###' onkeyup=\"return(FormatCurrency(this,event,4,'float'));\"></div>",
        "tolerance": "<div class='form-group'><input type='text' name='tolerance###id###' id='tolerance###id###' onkeyup=\"return(FormatCurrency(this,event,4,'float'));\"></div>"
	}];

    let row_count = parseInt($("#testParameterCount").val()),
        rowNum = 0;

    function addTestParameter(){
        row_count +=1;
		jsonArray.filter((a) => {
			var template="<tr id='testparam"+row_count+"'><td width='20' class='text-center'>{remove}</td><td>{rowCount}</td><td>{quality_control_type}</td><td>{type_description}</td><td>{standart_value}</td><td>{quality_measure}</td><td>{tolerance}</td></tr>";
			$('table#testParameters > tbody').append(nano( template, a ).replace(/###id###/g,row_count));
		});
        $("#testParameterCount").val(row_count);
    }

    function delTestParameter(row){ $("tr#testparam" + row + "").remove(); }
    
    function setParam(row){
        rowNum = row;
        openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_quality_control_types&call_function=setTestParameter');
    }

	function setTestParameter( args ){
        $("#type_id" + rowNum + "").val(args.type_id);
        $("#quality_control_type" + rowNum + "").val(args.quality_control_type);
        $("#type_description" + rowNum + "").val(args.type_description);
        $("#standart_value" + rowNum + "").val(args.standart_value);
        $("#quality_measure" + rowNum + "").val(args.quality_measure);
        $("#tolerance" + rowNum + "").val(args.tolerance);
	}
</script>