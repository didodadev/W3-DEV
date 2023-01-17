<cfinclude template="../../header.cfm">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="samplingpointsForm" id="samplingpointsForm">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62132.Numune Alım Noktası'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" name="sampling_points_name" id="sampling_points_name"></div>
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
        if(samplingpointsForm.sampling_points_name.value == "")
        {
            alert("<cf_get_lang dictionary_id='62132.Numune Alım Noktası'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        return true;
    }
</script>