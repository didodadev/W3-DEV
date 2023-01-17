<cfset xfa.upd= "hr.emptypopup_upd_test_result">
<cfset xfa.del= "hr.emptypopup_del_test_result">
<cfinclude template="../query/get_app.cfm">
<cfquery name="get_test_result" datasource="#dsn#">
	SELECT
		ID,
		TEST_ID,
		TEST_FINAL_POINT,
		POINT_BASE_TYPE,
        TEST_DATE,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE
	FROM
		EMPLOYEES_APP_TEST_RESULTS
	WHERE
		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.test_result_id#">
</cfquery>
<cfsavecontent variable="txt"><cf_get_lang dictionary_id="38588.Sınav Sonucu">: <cfoutput>#get_app.name# #get_app.surname#</cfoutput></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">   
	<cf_box title="#txt#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" add_href="javascript:openBoxDraggable('#request.self#?fuseaction=hr.popup_add_test_result&empapp_id=#attributes.empapp_id#&draggable=1');">
		<cfform action="#request.self#?fuseaction=#xfa.upd#" name="add_test_result" method="post" enctype="multipart/form-data">
			<input type="hidden" value="<cfoutput>#attributes.empapp_id#</cfoutput>" name="empapp_id" id="empapp_id">
			<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.test_result_id#</cfoutput>">   
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="form-group" id="item-test_type">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="38585.Sınav Tipi">*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfquery name="get_test_type" datasource="#dsn#">
								SELECT ID,TEST_TYPE FROM SETUP_TEST_TYPE ORDER BY TEST_TYPE
							</cfquery>
							<select name="test_type" id="test_type">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfoutput query="get_test_type">
									<option value="#id#"<cfif get_test_result.test_id eq id>selected</cfif>>#test_type#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-test_final_point">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="57684.Sonuç"></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<cfinput type="text" name="test_final_point" validate="float" required="yes" value="#get_test_result.test_final_point#" placeholder="#getLang('','Alınan Puan','62725')#">  
							</div>
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<cfinput type="text" name="point_base_type" validate="integer"  value="#get_test_result.point_base_type#" placeholder="#getLang('','Toplam Puan','58985')#">
							</div>
						</div>
					</div>
					<div class="form-group" id="item-test_date">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='56283.Tarih girmelisiniz'></cfsavecontent>
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="38584.Sınav Tarihi !"></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="test_date" id="test_date" value="#DateFormat(get_test_result.test_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
								<span class="input-group-addon">
									<cf_wrk_date_image date_field="test_date">
								</span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_test_result">
				<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=#xfa.del#&id=#get_test_result.id#'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	if(document.getElementById('test_type').value == '')
	{
		alert("<cf_get_lang dictionary_id='38583.Sınav tipi seçiniz'>!");
		return false;
	}
	if(document.getElementById('test_date').value == '')
	{
		alert("<cf_get_lang dictionary_id='56283.Tarih girmelisiniz'>!");
		return false;
	}
	return true;
}
</script>

