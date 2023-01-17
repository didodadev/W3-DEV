<cfif isnumeric(attributes.sampling_id)>
    <cfset sampling_points = createObject("component","WBP/Recycle/files/sample_analysis/cfc/sampling_points") />
			
	<cfset getSamplingPoints = sampling_points.getSamplingPoints(
		sampling_id: attributes.sampling_id
    ) />
</cfif>

<cfinclude template="../../header.cfm">
<cf_catalystHeader>
<cfoutput query="getSamplingPoints">
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cfform name="samplingpointsForm" id="samplingpointsForm">
                <cfinput type="hidden" name="sampling_id" id="sampling_id" value="#attributes.sampling_id#">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62132.Numune Alım Noktası'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" value="#SAMPLING_POINTS_NAME#" name="sampling_points_name" id="sampling_points_name"></div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-6">
                        <cf_record_info query_name="getSamplingPoints" margintop="1">
                    </div>
                    <div class="col col-6">
                        <cf_workcube_buttons is_upd="1" delete_page_url='#request.self#?fuseaction=recycle.sampling_points&event=del&id=#attributes.sampling_id#' add_function="kontrol()">
                    </div>
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
</cfoutput>

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