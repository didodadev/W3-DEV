<cfif len(attributes.refinery_lab_test_id)>
    <cfquery name="get_q_types" datasource="#dsn#">
        SELECT
            QT.QUALITY_CONTROL_TYPE,
            QT.TYPE_ID,
            RT.GROUP_ID
        FROM
            REFINERY_LAB_TESTS_ROW RT
            LEFT JOIN #dsn3_alias#.QUALITY_CONTROL_TYPE QT ON QT.TYPE_ID= RT.GROUP_ID
        WHERE
            RT.REFINERY_LAB_TEST_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.refinery_lab_test_id#">
        GROUP BY
            RT.GROUP_ID,
            QT.TYPE_ID,
            QT.QUALITY_CONTROL_TYPE
    </cfquery>
<cfelse>
    <cfset get_q_types.recordCount = ''> 
</cfif>

<cfif len(attributes.refinery_lab_test_id)>
    <cfquery name="get_report_content" datasource="#dsn#">
        SELECT REPORT_CONTENT FROM REFINERY_LAB_TESTS WHERE REFINERY_LAB_TEST_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.refinery_lab_test_id#">
    </cfquery>
</cfif>
<cfset upd_id_list = ''>
<cfset upd_big_id_list = ''>
<cfif get_q_types.recordCount neq ''>
        <cfset upd_current_row = 0>
        <cfset upd_rowcount_ = 0>
        <cfset list_row_2 = 0>
    <cfloop query="get_q_types">
        <cfif len(attributes.refinery_lab_test_id)>
            <cfquery name="get_q_sub_types" datasource="#dsn#">
                SELECT 
                    RT.IS_ACCEPT,
                    RT.UNIT_ID,
                    RT.AMOUNT,
                    RT.REFINERY_LAB_TEST_ROW_ID,
                    RT.IS_ACCEPT_TEST,
                    RT.GROUP_ID,
                    RT.OPTIONS,
                    RT.DESCRIPTION,
                    RT.RESULT,
                    RT.MIN_LIMIT,
                    RT.STANDART_VALUE,
                    RT.REFINERY_LAB_TEST_ID,
                    RT.PARAMETER_ID,
                    RT.SAMPLE_METHOD,
                    RT.SAMPLE_NUMBER,
                    RT.MAX_LIMIT,
                    QR.QUALITY_CONTROL_ROW	QUALITY_CONTROL_TYPE
                FROM
                    REFINERY_LAB_TESTS_ROW RT
                LEFT JOIN #dsn3_alias#.QUALITY_CONTROL_ROW AS QR ON QR.QUALITY_CONTROL_ROW_ID= RT.PARAMETER_ID
                WHERE
                    RT.GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GROUP_ID#">
                    AND RT.REFINERY_LAB_TEST_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.refinery_lab_test_id#">
                GROUP BY
                    RT.REFINERY_LAB_TEST_ID,
                    RT.REFINERY_LAB_TEST_ROW_ID,
                    QR.QUALITY_CONTROL_ROW,
                    RT.IS_ACCEPT,
                    RT.UNIT_ID,
                    RT.AMOUNT,
                    RT.IS_ACCEPT_TEST,
                    RT.GROUP_ID,
                    RT.OPTIONS,
                    RT.DESCRIPTION,
                    RT.RESULT,
                    RT.MIN_LIMIT,
                    RT.STANDART_VALUE,
                    RT.PARAMETER_ID,
                    RT.SAMPLE_METHOD,
                    RT.SAMPLE_NUMBER,
                    RT.MAX_LIMIT
            </cfquery>
        </cfif>
        <cfif get_q_sub_types.recordcount>
            <div class="ui-info-bottom">
                <cfif isDefined('content_id') and len(content_id)>
                    <a  target="_blank" href="<cfoutput>#request.self#?fuseaction=content.list_content&event=det&cntid=#get_q_types.content_id#</cfoutput>"><i class="fa fa-file-text" style="color:#DAA520" ></i></a>
                <cfelse>
                    <a href="javascript://"><i class="fa fa-file-text" style="color:#C2B280"></i></a>
                </cfif>
                <cfoutput>
                   &nbsp<font color="red">#get_q_types.quality_control_type#</font>
                </cfoutput>
            </div>
            <div class="form-group">
                <div class="checkbox checbox-switch">
                    <label class="checking">
                        <cfoutput>
                            <input type="checkbox" name="upd_accepted_#currentrow#" id="upd_accepted_#currentrow#" value="1" <cfif get_q_sub_types.is_accept eq 1>checked</cfif>/>
                        </cfoutput>
                        <span></span>
                    </label>
                </div>
            </div>
            <cf_grid_list id="list_#list_row_2#">
                <thead>
                    <tr>
                        <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
                        <th width="150"><cf_get_lang dictionary_id='64052.Parametre'></th>
                        <th width="100" class="text-center"><cf_get_lang dictionary_id='63477.Örneklem'></th>
                        <th width="100"><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th width="100" class="text-right"><cf_get_lang dictionary_id='52248.Alt Limit'></th>
                        <th width="100" class="text-right"><cf_get_lang dictionary_id='52249.Üst Limit'></th>
                        <th  width="100" class="text-right"><cf_get_lang dictionary_id='33137.Standart'><cf_get_lang dictionary_id='33616.Değer'></th>
                        <th width="25" class="text-center"><=></th>
                        <th><cf_get_lang dictionary_id='59085.Sonuç'></th>
                        <th>&nbsp</th>
                        <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfset upd_rowcount_ = upd_rowcount_+ get_q_sub_types.recordcount>
                    <cfif get_q_sub_types.recordcount>
                        <cfoutput query="get_q_sub_types"> 
                            <cfset upd_id_list = get_q_sub_types.GROUP_ID&';'&get_q_sub_types.PARAMETER_ID>
                            <cfset upd_big_id_list = listappend(upd_big_id_list,upd_id_list,",")>
                            <cfset upd_current_row = upd_current_row + 1>
                            <tr   class="test_rows_">
                                <td>
                                    <input type="hidden" class="q_row" name="upd_q_row_accept_#upd_current_row#" id="upd_q_row_accept_#upd_current_row#" value="">
                                    <input type="hidden" name="upd_parameterId#upd_current_row#" id="upd_parameterId#upd_current_row#" value="#PARAMETER_ID#">
                                    <input type="hidden" name="upd_groupId#upd_current_row#" id="upd_groupId#upd_current_row#" value="#GROUP_ID#">
                                    <input type="hidden" name="ref_lab_test_id#upd_current_row#" id="ref_lab_test_id#upd_current_row#" value="<cfif isDefined('REFINERY_LAB_TEST_ROW_ID')>#REFINERY_LAB_TEST_ROW_ID#</cfif>">
                                    #currentrow#
                                </td>
                                <td>#QUALITY_CONTROL_TYPE#</td>
                                <td>
                                    <div class="form-group">
                                        <div class="col col-8">
                                            <cfif isDefined('samp_number')><input type="text" name="upd_sample_number_#upd_current_row#" id="upd_sample_number_#upd_current_row#" value="#TLFormat(samp_number)#" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"/></cfif>
                                        </div>
                                        <div class="col col-4">
                                            <cfif isDefined('sample_method')>
                                                <input type="text" name="upd_samp" id="upd_samp" readonly value="<cfif sample_method eq 1>R<cfelseif sample_method eq 2>%<cfelseif sample_method eq 3>K</cfif>" title="<cfif sample_method eq 1><cf_get_lang dictionary_id='63293.Rastgele'><cfelseif sample_method eq 2><cf_get_lang dictionary_id='52250.Yüzde'><cfelseif sample_method eq 3><cf_get_lang dictionary_id='64043.Katlanarak'></cfif>">
                                                <input type="hidden" name="upd_sample_method_#upd_current_row#" id="upd_sample_method_#upd_current_row#" value="#sample_method#">
                                            </cfif>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <div class="col col-8">
                                            <input type="text" name="upd_amount_#upd_current_row#" id="upd_amount_#upd_current_row#" value="#TLFormat(AMOUNT)#" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"/>
                                        </div>
                                        <div class="col col-4">
                                            <cfif isDefined('unit')>
                                                <input type="text" name="upd_units" id="upd_units" readonly value="<cfif unit eq 1>mg<cfelseif unit eq 2>gr <cfelseif unit eq 3>kg <cfelseif unit eq 4>mm³ <cfelseif unit eq 5>cm³ <cfelseif unit eq 6>m³ <cfelseif unit eq 7>ml <cfelseif unit eq 8>cl <cfelseif unit eq 9>lt </cfif>">
                                                <input type="hidden" name="upd_unit_#upd_current_row#" id="upd_unit_#upd_current_row#" value="#unit#">
                                            </cfif>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-right"><input type="text" name="upd_minLimit#upd_current_row#" id="upd_minLimit#upd_current_row#" value="#TLFormat(MIN_LIMIT)#" class="moneybox"/></td>
                                <td class="text-right"><input type="text" name="upd_maxLimit#upd_current_row#" id="upd_maxLimit#upd_current_row#" value="#TLFormat(MAX_LIMIT)#" class="moneybox"/></td>
                                <td class="text-right"><input type="text" name="upd_standart_value_#upd_current_row#" id="upd_standart_value_#upd_current_row#" value="#TLFormat(STANDART_VALUE)#" class="moneybox"/></td>
                                <td>
                                    <select name="upd_options#upd_current_row#" id="upd_options#upd_current_row#" class="text-center"> 
                                        <cfset control_operator = OPTIONS>
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="1" <cfif isDefined('control_operator') and control_operator eq 1>selected</cfif>>=</option>
                                        <option value="2" <cfif isDefined('control_operator') and control_operator eq 2>selected</cfif>>></option>
                                        <option value="3" <cfif isDefined('control_operator') and control_operator eq 3>selected</cfif>><</option>
                                        <option value="4" <cfif isDefined('control_operator') and control_operator eq 4>selected</cfif>>=></option>
                                        <option value="5" <cfif isDefined('control_operator') and control_operator eq 5>selected</cfif>>=<</option>
                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="upd_result_#upd_current_row#" id="upd_result_#upd_current_row#" value="#TLFormat(RESULT)#" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox">
                                </td>
                                <td>
                                    <div class="checkbox checbox-switch">
                                        <label>
                                            <input type="checkbox" name="upd_accept_#upd_current_row#" id="upd_accept_#upd_current_row#" value="1" <cfif IS_ACCEPT eq 1>checked</cfif>/>
                                            <span></span>
                                        </label>
                                    </div>
                                </td>
                                <td><input type="text" name="upd_type_description_#upd_current_row#" id="upd_type_description_#upd_current_row#" value="#DESCRIPTION#" /></td>
                            </tr>
                        </cfoutput>
                    </cfif>
                </tbody>
            </cf_grid_list>
            <cfif get_q_sub_types.recordcount eq 0>
                <div class="ui-info-bottom">
                    <p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</p>
                </div>
            </cfif>
        </cfif>
    </cfloop>
</cfif>
<input type="hidden" name="is_sample" id="is_sample" value="<cfif isDefined('attributes.is_sample')><cfoutput>#attributes.is_sample#</cfoutput></cfif>">
<input type="hidden" name="refinery_lab_test_id" id="refinery_lab_test_id" value="<cfif isDefined("attributes.refinery_lab_test_id")><cfoutput>#attributes.refinery_lab_test_id#</cfoutput></cfif>">
<cfif attributes.is_sample eq 1 and attributes.is_upd neq 1>
    <cfinclude template="../../sample_analysis/display/upd_sub_parameters.cfm">
</cfif>
    <cfif not isDefined("parameter_id_list")><cfset parameter_id_list= ''></cfif>
    <cfset parameter_id_list = listappend(parameter_id_list,upd_big_id_list,",")>
    <input type="hidden" name="parameter_id_list" id="parameter_id_list" value="<cfoutput>#listDeleteDuplicates(parameter_id_list)#</cfoutput>">
    <cfif isDefined("upd_rowcount_")>
        <cfset upd_rowcount = upd_rowcount_>
    <cfelse>
        <cfset upd_rowcount = 0>
    </cfif>
<input type="hidden" name="rowcount_new" id="rowcount_new" value="<cfoutput>#upd_rowcount#</cfoutput>">

<script>
    $('.checking').css('float','left');

<cfif attributes.is_sample eq 1 and not len(attributes.refinery_lab_test_id)>
    $("input[name^='upd_']").each(function(index) {
        var x=this.name;
        $(this).attr('name', function () {
        return this.name.replace("upd_","");
        }); 
    });
</cfif>
</script>