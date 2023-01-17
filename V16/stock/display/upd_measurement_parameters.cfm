
<cfset getComponent = createObject('component','V16.stock.cfc.measurement_parameters')>
<cfset get_measure = getComponent.GET_MEASUREMENT_PARAMETERS(measurement_id: attributes.measurement_id)>
<cfset get_measure_row = getComponent.GET_MEASUREMENT_PARAMETERS_ROW(measurement_id: attributes.measurement_id)>

<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="offtime_request" method="post" enctype="multipart/form-data">
            <input type="hidden" name="total_record" id="total_record" value="<cfoutput>#get_measure_row.recordcount#</cfoutput>">
            <input type="hidden" name="measurement_id" id="measurement_id" value="<cfoutput>#attributes.measurement_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-12">
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-measurement_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62817.Ölçüm Adı'></label>
                            <div class="col col-8 col-xs-12"> 
                                <div class="input-group">
									<input type="text" name="measurement_name" id="measurement_name" value="<cfoutput>#get_measure.measurement_name#</cfoutput>">
									<span class="input-group-addon">
										<cf_language_info
											table_name="MEASUREMENT_PARAMETERS"
											column_name="MEASUREMENT_NAME" 
											column_id_value="#attributes.measurement_id#" 
											maxlength="500" 
											datasource="#dsn#" 
											column_id="MEASUREMENT_ID" 
											control_type="0">
									</span>
								</div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-12">
                        <cf_seperator id="measurement_unit_" header="#getLang('','Ölçüm Birimleri',62816)#">
                        <div id="measurement_unit_div">
                            <cf_grid_list>
                                <thead>
                                    <th class="text-center" width="30"><a onClick="addRow()"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                    <th width="250"><cf_get_lang dictionary_id='62818.Ölçüm Birimi'></th>
                                    <th><cf_get_lang dictionary_id='62819.Kısaltma'></th>
                                </thead>
                                <tbody id="measurement_unit">
                                    <cfoutput query="get_measure_row">
                                        <tr id='#currentrow#'>
                                            <td>
                                                <a style='cursor:pointer;' onclick='sil(#currentrow#);'><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                                                <input type='hidden' name='satir#currentrow#' id='satir#currentrow#' value='1'>
                                                <input name='measurement_row' value='#currentrow#' type='hidden'>
                                                <input name='measurement_row_id#currentrow#' value='#row_id#' type='hidden'>
                                            </td>
                                            <td><div class='form-group'><input type='text' name='measurement_row_name#currentrow#' value='#UNIT_NAME#'></div></td>
                                            <td><div class='form-group'><input type='text' name='short_measurement_name#currentrow#' value='#SHORT_UNIT_NAME#'></div></td>
                                        </tr>
                                    </cfoutput>
                                </tbody>
                            </cf_grid_list>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url="#request.self#?fuseaction=stock.measurement_parameters&event=del&measurement_id=#attributes.measurement_id#">
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

<script>
    $( document ).ready(function() {
            $('input[id = float_val').keypress(function(event) {
            if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57)) {
                
                if(event.which == 44)
                {
                    event.value = event.val().replace(/,/g, ".");
                }
                else
                {
                    event.preventDefault();
                }
            }
            });
        });
    var jsonArray = [
        {
        "sil" : "<a style='cursor:pointer;' onclick='sil(###id###);'><i class='fa fa-minus' title='<cf_get_lang dictionary_id='57463.Sil'>'></i></a><input name='measurement_row' value='###id###' type='hidden'>",
        "measurement_name" : "<div class='form-group'><input type='text' name='measurement_row_name###id###' value=''></div>",
        "short_measurement_name": "<div class='form-group'><input type='text' name='short_measurement_name###id###' value=''></div>",
        }
    ];

    var row_count_service = parseInt($("input[name=total_record]").val());
    function addRow(){
            row_count_service +=1;
            jsonArray.filter((a) => {
                var template="<tr id='"+row_count_service+"'><input type='hidden' name='satir###id###' id='satir###id###' value='1'><td width='30'>{sil}</td><td>{measurement_name}</td><td>{short_measurement_name}</td></tr>";
                $('#measurement_unit').append(nano( template, a ).replace(/###id###/g,row_count_service));
            });
    }
    function sil(no)
    {
        if(confirm("<cf_get_lang dictionary_id='62142.Silmek istediğinize emin misiniz?'>")){
            $("#measurement_unit tr#"+no).hide();
            $("#satir"+no).val("0");
        }
    }
</script>