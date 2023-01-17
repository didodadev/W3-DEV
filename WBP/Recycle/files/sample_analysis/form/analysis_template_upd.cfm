<cfinclude template="../../header.cfm">
<cfif isnumeric(attributes.refinery_test_id)>
    <cfset analysis_template = createObject("component","WBP/Recycle/files/sample_analysis/cfc/analysis_template") />
			
	<cfset getAnalysisTemplate = analysis_template.getAnalysisTemplate(
		refinery_test_id: attributes.refinery_test_id
    ) />

</cfif>

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

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="SaveAnalyzeParams" id="SaveAnalyzeParams">
        <cf_box>
            <input type="hidden" name="refinery_test_id" id="refinery_test_id" value="<cfoutput>#attributes.refinery_test_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-title">
                        <label class="col col-4"><cf_get_lang dictionary_id='62147.Analiz Adı'>*</label>
                        <div class="col col-8">
                            <div class="input-group">
                                <input type="text" value="<cfoutput>#getAnalysisTemplate.TEST_NAME_#</cfoutput>" name="testName" id="testName" />
                                <span class="input-group-addon">
                                    <cf_language_info 
                                        table_name="REFINERY_TEST" 
                                        column_name="TEST_NAME" 
                                        column_id_value="#attributes.refinery_test_id#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="REFINERY_TEST_ID" 
                                        control_type="0">
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-title">
                        <label class="col col-4"><cf_get_lang dictionary_id='62146.Analiz Açıklama'></label>
                        <div class="col col-8"><textarea name="testComment" id="testComment"><cfoutput>#getAnalysisTemplate.TEST_COMMENT#</cfoutput></textarea></div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6">
					<cf_record_info query_name="getAnalysisTemplate" margintop="1">
                </div>
                <div class="col col-6">
					<cf_workcube_buttons is_upd="1" delete_page_url='#request.self#?fuseaction=recycle.analyzes&event=del&id=#attributes.refinery_test_id#' add_function="kontrol()">
                </div>
            </cf_box_footer>
        </cf_box>
        <cf_box box_page="#request.self#?fuseaction=recycle.analysis_template_rows&refinery_test_id=#attributes.refinery_test_id#" id="row" title="#getLang('','',57693)#"></cf_box>
    </cfform>
</div>
<script>
    function kontrol() {
        if(SaveAnalyzeParams.testName.value.length == 0)
        {
            alert("<cf_get_lang dictionary_id='62131.Analiz Adı Girmelisiniz!'>");
            return false;
        }
        unformat_fields();
        return true;
    }
    function unformat_fields()
    {
        if( SaveAnalyzeParams.parameterCountSave.value != '' && parseInt(SaveAnalyzeParams.parameterCountSave.value) > 0 ){
            for (i = 1; i <= parseInt(SaveAnalyzeParams.parameterCountSave.value); i++) {
                if( $("#minLimit"+i+"") != 'undefined' && $("#minLimit"+i+"").val() != '' ) $("#minLimit"+i+"").val( filterNum( $("#minLimit"+i+"").val() ) );
                if( $("#maxLimit"+i+"") != 'undefined' && $("#maxLimit"+i+"").val() != '' ) $("#maxLimit"+i+"").val( filterNum( $("#maxLimit"+i+"").val() ) );
            }
        }
    }
</script>