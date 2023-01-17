<cfset analysis_template = createObject("component","WBP/Recycle/files/sample_analysis/cfc/analysis_template") />

<cfparam name = "attributes.refinery_test_id" default="">
<cfparam name = "attributes.getResultLimit" default="0">

<cfquery name="TEST_GROUPS" datasource="#DSN#">
    SELECT
        REFINERY_GROUP_ID,
        GROUP_NAME
    FROM
        REFINERY_GROUPS
    WHERE
        GROUP_STATUS = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    ORDER BY
        GROUP_NAME
</cfquery>
<cfquery name="TEST_UNITS" datasource="#DSN#">
    SELECT
        REFINERY_UNIT_ID,
        UNIT_NAME
    FROM
        REFINERY_TEST_UNITS
    WHERE
        UNIT_STATUS = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    ORDER BY
        UNIT_NAME
</cfquery>

<cfif len(attributes.refinery_test_id)><cfset getAnalysisTemplateRows = analysis_template.getAnalysisTemplateRows(refinery_test_id: attributes.refinery_test_id) /></cfif>

<input type="hidden" name="parameterCountSave" id="parameterCountSave" value="<cfoutput>#isDefined("getAnalysisTemplateRows") ? getAnalysisTemplateRows.recordCount : '0'#</cfoutput>" />
<cf_grid_list sort="0">
    <thead>
        <tr>
            <th width="20"><a href="javascript://" onclick="addRow()"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
            <th width="300"><cf_get_lang dictionary_id='32716.Gruplar'></th>
            <th width="300"><cf_get_lang dictionary_id='62145.Parametre Adı'></th>
            <th width="100"><cf_get_lang dictionary_id='52248.Alt Limit'></th>
            <th width="100"><cf_get_lang dictionary_id='52249.Üst Limit'></th>
            <!---
            <th width="150"><cf_get_lang dictionary_id='29798.Seçenekler'></th>
            <cfif attributes.getResultLimit eq 1><th width="300"><cf_get_lang dictionary_id='41580.Sonuç'></th></cfif>
            --->
            <th width="300"><cf_get_lang dictionary_id='62143.Test Metodları'></th>
            <th width="300"><cf_get_lang dictionary_id='55217.Birimler'></th>
        </tr>
    </thead>
    <tbody id="analyze_parameter_row">
        <cfif len(attributes.refinery_test_id)>
            <cfoutput query="getAnalysisTemplateRows">
                <tr id="row_#currentrow#">
                    <td>
                        <a style="cursor:pointer;" onclick="removeItem('row_#currentrow#')"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                        <input type='hidden' name='rowDeleted#currentrow#' id='rowDeleted#currentrow#' class='deleted' value='0'>
                        <input type='hidden' name='parameterTestRowId#currentrow#' id='parameterTestRowId#currentrow#' value='#PARAMETER_TEST_ROW_ID#'>
                        <input type='hidden' name='sampleAnalysisRowId#currentrow#' id='sampleAnalysisRowId#currentrow#' value=''>
                    </td>
                    <td>
                        <div class="form-group">
                            <select name="groupId#currentrow#" id="groupId#currentrow#" onchange="getItem('group',#currentrow#,this)">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <cfif TEST_GROUPS.recordCount>
                                    <cfloop query="#TEST_GROUPS#">
                                        <option value='#REFINERY_GROUP_ID#' #REFINERY_GROUP_ID eq getAnalysisTemplateRows.GROUP_ID ? 'selected' : ''#>#GROUP_NAME#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>
                    </td>
                    <td>
                        <cfquery name="TEST_PARAMETERS" datasource="#DSN#">
                            SELECT * FROM REFINERY_TEST_PARAMETERS WHERE GROUP_ID = #getAnalysisTemplateRows.GROUP_ID# AND PARAMETER_STATUS = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY PARAMETER_NAME
                        </cfquery>
                        <div class="form-group">
                            <select name="parameterId#currentrow#" id="parameterId#currentrow#" onchange="getItem('parameter',#currentrow#,this)">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <cfif TEST_PARAMETERS.recordCount>
                                    <cfloop query='#TEST_PARAMETERS#'>
                                        <option value="#REFINERY_TEST_PARAMETER_ID#" #REFINERY_TEST_PARAMETER_ID eq getAnalysisTemplateRows.PARAMETER_ID ? 'selected' : ''#>#PARAMETER_NAME#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>
                    </td>
                    <td>
                        <div class='form-group'>
                            <input type='text' name='minLimit#currentrow#' id='minLimit#currentrow#' onkeyup="return(FormatCurrency(this,event));" value="#TLFormat(MIN_LIMIT)#">
                        </div>
                    </td>
                    <td>
                        <div class='form-group'>
                            <input type='text' name='maxLimit#currentrow#' id='maxLimit#currentrow#' onkeyup="return(FormatCurrency(this,event));" value="#TLFormat(MAX_LIMIT)#">
                        </div>
                    </td>
                    <!---
                    <td>
                        <div class="form-group">
                            <select name='options#currentrow#' id="options#currentrow#">
                                <option value=''><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="=" <cfif options eq '='>selected</cfif>>=</option>
                                    <option value="<" <cfif options eq '<'>selected</cfif>><</option>
                                    <option value=">" <cfif options eq '>'>selected</cfif>>></option>
                                    <option value="Tespit Edilemedi" <cfif options eq 'Tespit Edilemedi'>selected</cfif>><cf_get_lang dictionary_id='62178.Tespit Edilemedi'></option>
                            </select>
                        </div>
                    </td>
                    <cfif attributes.getResultLimit eq 1>
                        <td>
                            <div class='form-group'>
                                <input type='text' name='resultLimit#currentrow#' id='resultLimit#currentrow#' onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </td>
                    </cfif>
                    --->
                    <td>
                        <cfquery name="TEST_METHODS" datasource="#DSN#">
                            SELECT * FROM REFINERY_TEST_METHODS WHERE REFINERY_TEST_PARAMETER_ID = #getAnalysisTemplateRows.PARAMETER_ID# AND TEST_METHOD_STATUS = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY TEST_METHOD_NAME
                        </cfquery>
                        <div class="form-group">
                            <select name='methodId#currentrow#' id="methodId#currentrow#">
                                <option value=''><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif TEST_METHODS.recordCount>
                                    <cfloop query="#TEST_METHODS#">
                                        <option value="#REFINERY_TEST_METHOD_ID#" #REFINERY_TEST_METHOD_ID eq getAnalysisTemplateRows.TEST_METHOD_ID ? 'selected' : ''#>#TEST_METHOD_NAME#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <select name="unitId#currentrow#" id="unitId#currentrow#">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <cfif TEST_UNITS.recordCount>
                                    <cfloop query="#TEST_UNITS#">
                                        <option value='#REFINERY_UNIT_ID#' #REFINERY_UNIT_ID eq getAnalysisTemplateRows.UNIT_ID ? 'selected' : ''#>#UNIT_NAME#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>
                    </td>
                </tr>
            </cfoutput>
        </cfif>
    </tbody>
</cf_grid_list>

<script>

    var jsonArray = [{
        "remove" : "<a style='cursor:pointer' onclick=\"removeItem('row_###id###')\"><i class='fa fa-minus' title='<cf_get_lang dictionary_id='57463.Sil'>'></i></a><input type='hidden' name='rowDeleted###id###' id='rowDeleted###id###' class='deleted' value='0'><input type='hidden' name='parameterTestRowId###id###' id='parameterTestRowId###id###' value=''>",
        "group" : "<div class='form-group'><select name='groupId###id###' id='groupId###id###' onchange=\"getItem('group',###id###,this)\"><option value=''><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfif TEST_GROUPS.recordCount><cfoutput query="TEST_GROUPS"><option value='#REFINERY_GROUP_ID#'>#GROUP_NAME#</option></cfoutput></cfif></select></div>",
        "parameter" : "<div class='form-group'><select name='parameterId###id###' id='parameterId###id###' onchange=\"getItem('parameter',###id###,this)\"><option value=''><cf_get_lang dictionary_id='57734.Seçiniz'></option></select></div>",
        "minLimit" : "<div class='form-group'><input type='text' name='minLimit###id###' id='minLimit###id###' onkeyup='return(FormatCurrency(this,event));'></div>",
        "maxLimit" : "<div class='form-group'><input type='text' name='maxLimit###id###' id='maxLimit###id###' onkeyup='return(FormatCurrency(this,event));'></div>",
        "method" : "<div class='form-group'><select name='methodId###id###' id='methodId###id###'><option value=''><cf_get_lang dictionary_id='57734.Seçiniz'></option></select></div>",
        "unit" : "<div class='form-group'><select name='unitId###id###' id='unitId###id###'><option value=''><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfif TEST_UNITS.recordCount><cfoutput query="TEST_UNITS"><option value='#REFINERY_UNIT_ID#'>#UNIT_NAME#</option></cfoutput></cfif></select></div>"
    }];

    function addRow(){
        var row_count = parseInt($("#parameterCountSave").val());
        row_count +=1;
        jsonArray.filter((a) => {
            var template="<tr id='row_"+row_count+"'><td>{remove}</td><td>{group}</td><td>{parameter}</td><td>{minLimit}</td><td>{maxLimit}</td><td>{method}</td><td>{unit}</td></tr>";
            $("#analyze_parameter_row").append(nano( template, a ).replace(/###id###/g,row_count));
        });
        $("#parameterCountSave").val( parseInt($("#parameterCountSave").val()) + 1 );
    }
    function removeItem(row_id) {
        if(confirm( "<cf_get_lang dictionary_id='62142.Silmek istediğinize emin misiniz?'>" )) $("tr#"+row_id+"").hide().find(".deleted").val(1);
    }
    function getItem(item, row_id, element) {    
        if( item == 'group' ){

            $( "#parameterId"+ row_id +"" ).html($("<option>").attr({"value":""}).text("<cf_get_lang dictionary_id='57734.Seçiniz'>"));
            $( "#methodId"+ row_id +"" ).html($("<option>").attr({"value":""}).text("<cf_get_lang dictionary_id='57734.Seçiniz'>"));
            $( "#minLimit"+ row_id +", #maxLimit"+ row_id +"" ).val('');
            <cfif attributes.getResultLimit eq 1>$( "#resultLimit"+ row_id +"" ).val('');</cfif>

            if( element.value != "" ){

                var data = new FormData();
                data.append("group_id", element.value);
                AjaxControlPostDataJson( 'WBP/Recycle/files/sample_analysis/cfc/analysis_parameters.cfc?method=getParameter', data, function(response) {
                    if( response.length > 0 ){
                        response.forEach((e) => {
                            $("<option>").attr({"value":e.REFINERY_TEST_PARAMETER_ID}).text(e.PARAMETER_NAME).appendTo( $( "#parameterId"+ row_id +"" ) );
                        });
                    }
                } );
            }
        }else if( item == 'parameter' ){

            $( "#methodId"+ row_id +"" ).html($("<option>").attr({"value":""}).text("<cf_get_lang dictionary_id='57734.Seçiniz'>"));
            $( "#minLimit"+ row_id +", #maxLimit"+ row_id +"" ).val('');

            if( element.value != "" ){

                var data = new FormData();
                data.append("parameter_id", element.value);
                AjaxControlPostDataJson( 'WBP/Recycle/files/sample_analysis/cfc/analysis_parameters.cfc?method=getParameter', data, function(response) {
                    if( response.length > 0 ){
                        $( "#minLimit"+ row_id +"" ).val(response[0].MIN_LIMIT);
                        $( "#maxLimit"+ row_id +"" ).val(response[0].MAX_LIMIT);
                    }
                } );

                AjaxControlPostDataJson( 'WBP/Recycle/files/sample_analysis/cfc/analysis_parameters.cfc?method=getMethod', data, function(response) {
                    if( response.length > 0 ){
                        response.forEach((e) => {
                            $("<option>").attr({"value":e.REFINERY_TEST_METHOD_ID}).text(e.TEST_METHOD_NAME).appendTo( $( "#methodId"+ row_id +"" ) );
                        });
                    }
                } );
            }
        }
    }

</script>