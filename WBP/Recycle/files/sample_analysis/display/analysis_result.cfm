<cfset sample_analysis = createObject("component","WBP/Recycle/files/sample_analysis/cfc/sample_analysis") />
<cfset sampling = createObject("component","WBP/Recycle/files/sample_analysis/cfc/sampling") />
<cfset analysis_result = createObject("component","WBP/Recycle/files/sample_analysis/cfc/analysis_result") />

<cfset get_sample_analysis_row = sample_analysis.getLabTestRow(attributes.sample_analysis_id)>
<cfset get_sampling_row = sampling.getSamplingRow(attributes.sampling_id)>
<cfset get_analysis_result = analysis_result.getAnalysisResult(attributes.sample_analysis_id,attributes.sampling_id)>

<cfoutput>
    <cf_grid_list sort="0">
        <thead>
            <tr>
                <th rowspan = "2" width="20">##</th>
                <th rowspan = "2" width="200">Ürün</th>
                <cfloop query = "get_sample_analysis_row">
                    <th colspan = "3">#parameter_name# (#unit_name#)</th>
                </cfloop>
            </tr>
            <tr>
                <cfloop query = "get_sample_analysis_row">
                    <th colspan = "3">
                        <cfif len(min_limit) and len(max_limit)>
                            #min_limit#-#max_limit#
                        <cfelseif len(max_limit)>
                            &lt; #max_limit#
                        <cfelseif len(min_limit)>
                            &gt; #min_limit#
                        </cfif>
                    </th>
                </cfloop>
            </tr>
        </thead>
        <tbody>
            <cfloop query="get_sampling_row">
                <tr id = "analysis_result_#sampling_row_id#" title = "Ürün: #product_name# - Stok Kodu: #stock_code# <cfif len(serial_no)>- Seri: #serial_no# </cfif> <cfif len(lot_no)>- Lot: #lot_no# </cfif>">
                    <td>#currentrow#</td>
                    <td>#product_name# <i class="icon-check" id = "check_icon_#sampling_row_id#" style="display:none;"></i></td>
                    <cfloop query = "get_sample_analysis_row">
                        <cfquery name = "get_cell_result" dbtype="query">
                            SELECT
                                RESULT_OPTION, RESULT_VALUE
                            FROM
                                get_analysis_result
                            WHERE
                                SAMPLING_ROW_ID = '#get_sampling_row.sampling_row_id#'
                                AND SAMPLE_ANALYSIS_ROW_ID = '#get_sample_analysis_row.refinery_lab_test_row_id#'
                        </cfquery>
                        <td>
                            <select name='options_#get_sampling_row.currentrow#_#get_sample_analysis_row.currentrow#' id="options#get_sampling_row.currentrow#_#get_sample_analysis_row.currentrow#" style="width:40px;" onchange="change_result_color(#get_sampling_row.currentrow#,#get_sample_analysis_row.currentrow#);">
                                <option value="=" <cfif get_cell_result.result_option eq '='>selected</cfif>>=</option>
                                <option value="<" <cfif get_cell_result.result_option eq '<'>selected</cfif>><</option>
                                <option value=">" <cfif get_cell_result.result_option eq '>'>selected</cfif>>></option>
                                <option value="?" <cfif get_cell_result.result_option eq '?'>selected</cfif>>?</option>
                            </select>
                        </td>
                        <td>
                            <input type='text' data-data_min = '#min_limit#' data-data_max = '#max_limit#' name='resultLimit_#get_sampling_row.currentrow#_#get_sample_analysis_row.currentrow#' id='resultLimit_#get_sampling_row.currentrow#_#get_sample_analysis_row.currentrow#' onkeyup="return(FormatCurrency(this,event));" value = "#get_cell_result.result_value#"  style="width:80px;"  onchange="change_result_color(#get_sampling_row.currentrow#,#get_sample_analysis_row.currentrow#);" autocomplete="off">
                        </td>
                        <td id = "result_td_#get_sampling_row.currentrow#_#get_sample_analysis_row.currentrow#">
                            Sonuç
                        </td>
                    </cfloop>
                </tr>
            </cfloop>
        </tbody>
    </cf_grid_list>
</cfoutput>

<script type = "text/javascript">
    function change_result_color(sampling_current, analysis_current) {
        var result_input = document.getElementById('resultLimit_' + sampling_current + '_' + analysis_current);
        var result_value = filterNum(result_input.value);
        var option_input = document.getElementById('options' + sampling_current + '_' + analysis_current);
        var option_value = option_input.value;
        var result_dataset = result_input.dataset;
        var data_min = result_dataset.data_min;
        var data_max = result_dataset.data_max;

        var cell_color = 'black';
        var cell_text = 'Sonuç';

        if(option_value == '?') {
            var cell_color = 'yellow';
            var cell_text = 'Belirsiz';
        } else {
            if(result_value != '') {
                if(data_min.length && data_max.length) {
                    if(data_min <= result_value && result_value <= data_max) {
                        var cell_color = 'green';
                        var cell_text = 'Geçti';
                        
                    } else {
                        var cell_color = 'red';
                        var cell_text = 'Kaldı';
                    }
                }
                else if(data_min.length) {
                    if(data_min <= result_value) {
                        var cell_color = 'green';
                        var cell_text = 'Geçti';
                    } else {
                        var cell_color = 'red';
                        var cell_text = 'Kaldı';
                    }
                }
                else if(data_max.length) {
                    if(result_value <= data_max) {
                        var cell_color = 'green';
                        var cell_text = 'Geçti';
                    } else {
                        var cell_color = 'red';
                        var cell_text = 'Kaldı';
                    }
                }
            }
        }

        result_td = $("#result_td_" + sampling_current + '_' + analysis_current);
        result_td.empty();
        result_td.html('<font color = "' + cell_color + '">' + cell_text + '</p>');

        var failed = 0;
        for( k = 1; k <= $("#parameterCountSave").val(); k++) {
            cell_color = $("#result_td_" + sampling_current + "_" + k + " > font").attr('color');

            if(cell_color != 'green') {
                failed = 1;
            }
        }

        if(failed == 0) {
            $("#check_icon_" + $("#samplingRowId" + sampling_current).val()).show();
        } else {
            $("#check_icon_" + $("#samplingRowId" + sampling_current).val()).hide();
        }

        return true;
    }

    $( document ).ready(function() {
       for( i = 1; i <= $("#samplingRowCount").val(); i++) {
           for(j = 1; j <= $("#parameterCountSave").val(); j++) {
               change_result_color(i,j);
           }
       }
    });
</script>