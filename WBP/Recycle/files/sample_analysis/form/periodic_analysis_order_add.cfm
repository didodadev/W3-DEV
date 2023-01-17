<cfinclude template="../../header.cfm">

<cfset sampling_points = createObject("component","WBP/Recycle/files/sample_analysis/cfc/sampling_points") />
<cfset getSamplingPoints = sampling_points.getSamplingPoints() />

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="AnalysisOperationsForm" id="AnalysisOperationsForm">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-sampling_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62132.Numune Alım Noktası'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="sampling_id" id="sampling_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfloop query="#getSamplingPoints#">
                                    <cfoutput><option value="#getSamplingPoints.SAMPLING_ID#">#getSamplingPoints.SAMPLING_POINTS_NAME#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-sample_points_date_entry">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62098.İlk Numune Alma Zamanı'>*</label>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="sample_points_date_entry" id="sample_points_date_entry" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="sample_points_date_entry"></span>
                            </div>
                        </div>
                        <div class="col col-2 col-md-4 col-sm-4 col-xs-12">
                            <cf_wrkTimeFormat name="sample_points_date_entry_hour" value="">
                        </div>
                        <div class="col col-2 col-md-4 col-sm-4 col-xs-12">
                            <select name="sample_points_date_entry_minute" id="sample_points_date_entry_minute">
                                <cfloop from="0" to="59" index="a">
                                    <cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-period">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32691.Periyot'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="number" name="period" id="period"></div>
                    </div>
                    <div class="form-group" id="item-sample_points_reason">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62097.Numune Analiz Nedeni'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="sample_points_reason" id="sample_points_reason">
                                <!--- parametrik yapacağız - Durgan20210605 --->
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="Atık Numunesi">Atık Numunesi</option>
                                <option value="Process Numunesi">Process Numunesi</option>
                                <option value="Mamül Numunesi">Mamül Numunesi</option>
                                <option value="Diğer">Diğer</option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons add_function="kontrol()">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

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