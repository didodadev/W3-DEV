<cfinclude template="../../header.cfm">

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
            <cf_box_elements id="testAddModal">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-title">
                        <label class="col col-4"><cf_get_lang dictionary_id='62147.Analiz Adı'>*</label>
                        <cfinput type="text" class="form-control" name="testName" id="testName"/>
                    </div>
                    <div class="form-group" id="item-title">
                        <label class="col col-4"><cf_get_lang dictionary_id='62146.Analiz Açıklama'></label>
                        <textarea name="testComment" id="testComment"></textarea>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons add_function="kontrol()">
            </cf_box_footer>
        </cf_box>
        <cf_box box_page="#request.self#?fuseaction=recycle.analysis_template_rows" id="row" title="#getLang('','',57693)#"></cf_box>
    </cfform>
</div>
<script>
    function kontrol() {
        if(SaveAnalyzeParams.testName.value == "")
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