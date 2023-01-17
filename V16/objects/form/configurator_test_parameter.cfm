<cfquery name="get_conf_test_parameters" datasource="#dsn3#">
	SELECT
        SPCP.*,
        QCT.QUALITY_CONTROL_TYPE
    FROM SETUP_PRODUCT_CONFIGURATOR_PARAMETER AS SPCP
    JOIN QUALITY_CONTROL_TYPE AS QCT ON SPCP.TYPE_ID = QCT.TYPE_ID
    WHERE SPCP.PRODUCT_CONFIGURATOR_ID = <cfqueryparam value = "#get_conf.PRODUCT_CONFIGURATOR_ID#" CFSQLType = "cf_sql_integer">
</cfquery>

<input type="hidden" name="testParameterCount" id="testParameterCount" value="<cfoutput>#get_conf_test_parameters.recordcount#</cfoutput>">
<cf_grid_list id="testParameters">
    <thead>
        <tr>
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
                <cfset standartValue = STANDART_VALUE />
                <cfset qualityMeasure = QUALITY_MEASURE />
                <cfset qualityTolerance = TOLERANCE />
                <cfif isdefined("is_upd_") and is_upd_ eq 1>
                    <cfquery name="get_test_parameter" dbtype="query">
                        SELECT * FROM GET_SPECT_ROW WHERE IS_QUALITY_TYPE = 1 AND QUALITY_TYPE_ID = #get_conf_test_parameters.type_id#
                    </cfquery>
                    <cfif get_test_parameter.recordcount>
                        <cfset standartValue = get_test_parameter.QUALITY_STANDART_VALUE />
                        <cfset qualityMeasure = get_test_parameter.QUALITY_MEASURE />
                        <cfset qualityTolerance = get_test_parameter.QUALITY_TOLERANCE />
                    </cfif>
                </cfif>
                <tr id="testparam#currentrow#" valign="top">
                    <td>#currentrow#</td>
                    <td>
                        <input type='hidden' name="type_id#PRODUCT_CONFIGURATOR_PARAMETER_ID#" id="type_id#PRODUCT_CONFIGURATOR_PARAMETER_ID#" value="#TYPE_ID#">
                        #QUALITY_CONTROL_TYPE#
                    </td>
                    <td>#TYPE_DESCRIPTION#</td>
                    <td>
                        <div class="form-group">
                            <input type="text" name="standart_value#PRODUCT_CONFIGURATOR_PARAMETER_ID#" id="standart_value#PRODUCT_CONFIGURATOR_PARAMETER_ID#" onkeyup="return(FormatCurrency(this,event,4,'float'));" value="#TLFormat(standartValue)#">
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="text" name="quality_measure#PRODUCT_CONFIGURATOR_PARAMETER_ID#" id="quality_measure#PRODUCT_CONFIGURATOR_PARAMETER_ID#" onkeyup="return(FormatCurrency(this,event,4,'float'));" value="#TLFormat(qualityMeasure)#">
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="text" name="quality_tolerance#PRODUCT_CONFIGURATOR_PARAMETER_ID#" id="quality_tolerance#PRODUCT_CONFIGURATOR_PARAMETER_ID#" onkeyup="return(FormatCurrency(this,event,4,'float'));" value="#TLFormat(qualityTolerance)#">
                        </div>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr><td colspan = "6"><cf_get_lang dictionary_id='62662.Konfigürasyon detayında kalite-test parametresi tanımlanmamış'>!</td></tr>
        </cfif>
    </tbody>
</cf_grid_list>