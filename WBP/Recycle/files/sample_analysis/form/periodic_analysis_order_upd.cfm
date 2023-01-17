<cfif isnumeric(attributes.sample_points_id)>
    <cfset sampling_points = createObject("component","WBP/Recycle/files/sample_analysis/cfc/sampling_points") />
    <cfset periodic_analysis_order = createObject("component","WBP/Recycle/files/sample_analysis/cfc/periodic_analysis_order") />
			
	<cfset getPeriodicAnalysisOrder = periodic_analysis_order.getPeriodicAnalysisOrder(sample_points_id: attributes.sample_points_id) />
    <cfset getSamplingPoints = sampling_points.getSamplingPoints() />
</cfif>

<cfinclude template="../../header.cfm">
<cf_catalystHeader>
<cfoutput query="getPeriodicAnalysisOrder">
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cfform name="AnalysisOperationsForm" id="AnalysisOperationsForm">
                <cf_box_elements>
                    <cfinput type="hidden" name="sample_points_id" id="sample_points_id" value="#attributes.sample_points_id#">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-sampling_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62132.Numune Alım Noktası'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="sampling_id" id="sampling_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="#getSamplingPoints#">
                                        <cfoutput><option value="#getSamplingPoints.SAMPLING_ID#" #getPeriodicAnalysisOrder.SAMPLING_ID eq getSamplingPoints.SAMPLING_ID ? 'selected' : ''#>#getSamplingPoints.SAMPLING_POINTS_NAME#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-sample_points_date_entry">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62098.İlk Numune Alma Zamanı'>*</label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="sample_points_date_entry" id="sample_points_date_entry" value="#len(getPeriodicAnalysisOrder.SAMPLE_POINTS_DATE_ENTRY) ? dateformat(getPeriodicAnalysisOrder.SAMPLE_POINTS_DATE_ENTRY,dateformat_style) : ''#" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="sample_points_date_entry"></span>
                                </div>
                            </div>
                            <div class="col col-2 col-md-4 col-sm-4 col-xs-12">
                                <cf_wrkTimeFormat name="sample_points_date_entry_hour" value="#len(getPeriodicAnalysisOrder.SAMPLE_POINTS_DATE_ENTRY) ? hour(getPeriodicAnalysisOrder.SAMPLE_POINTS_DATE_ENTRY) : ''#">
                            </div>
                            <div class="col col-2 col-md-4 col-sm-4 col-xs-12">
                                <select name="sample_points_date_entry_minute" id="sample_points_date_entry_minute">
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#" #(len(getPeriodicAnalysisOrder.SAMPLE_POINTS_DATE_ENTRY) and Numberformat(a,00) eq minute(getPeriodicAnalysisOrder.SAMPLE_POINTS_DATE_ENTRY)) ? 'selected' : ''#>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-period">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32691.Periyot'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="number" name="period" id="period" value="#getPeriodicAnalysisOrder.PERIOD#"></div>
                        </div>
                        <div class="form-group" id="item-sample_points_reason">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62097.Numune Analiz Nedeni'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="sample_points_reason" id="sample_points_reason">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="Atık Numunesi" #getPeriodicAnalysisOrder.SAMPLE_POINTS_REASON eq 'Atık Numunesi' ? 'selected' : ''#>Atık Numunesi</option>
                                    <option value="Process Numunesi" #getPeriodicAnalysisOrder.SAMPLE_POINTS_REASON eq 'Process Numunesi' ? 'selected' : ''#>Process Numunesi</option>
                                    <option value="Mamül Numunesi" #getPeriodicAnalysisOrder.SAMPLE_POINTS_REASON eq 'Mamül Numunesi' ? 'selected' : ''#>Mamül Numunesi</option>
                                    <option value="Diğer" #getPeriodicAnalysisOrder.SAMPLE_POINTS_REASON eq 'Diğer' ? 'selected' : ''#>Diğer</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-6">
                        <cf_record_info query_name="getPeriodicAnalysisOrder" margintop="1">
                    </div>
                    <div class="col col-6">
                        <cf_workcube_buttons is_upd="1" delete_page_url='#request.self#?fuseaction=recycle.periodic_analysis_order&event=del&id=#attributes.sample_points_id#' add_function="kontrol()">
                    </div>
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
</cfoutput>

<script>
    function kontrol() 
    {
        if(AnalysisOperationsForm.sampling_id.value == "")
        {
            alert("<cf_get_lang dictionary_id='62132.Numune Alım Noktası'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(AnalysisOperationsForm.sample_points_date_entry.value == "" || AnalysisOperationsForm.sample_points_date_entry_hour.value == "" || AnalysisOperationsForm.sample_points_date_entry_minute.value == "")
        {
            alert("<cf_get_lang dictionary_id='62098.İlk Numune Alma Zamanı'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(AnalysisOperationsForm.period.value == "")
        {
            alert("<cf_get_lang dictionary_id='32691.Periyot'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(AnalysisOperationsForm.sample_points_reason.value == "")
        {
            alert("<cf_get_lang dictionary_id='62097.Numune Analiz Nedeni'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        return true;
    }
</script>