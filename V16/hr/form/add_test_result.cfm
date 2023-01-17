<cfset xfa.upd= "hr.emptypopup_add_test_result">
<cfinclude template="../query/get_app.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfsavecontent variable="txt"><cf_get_lang dictionary_id="38588.Sınav Sonucu">: <cfoutput>#get_app.name# #get_app.surname#</cfoutput></cfsavecontent>
	<cf_box title="#txt#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform action="#request.self#?fuseaction=#xfa.upd#" name="add_test_result" method="post" enctype="multipart/form-data">
			<input type="hidden" value="<cfoutput>#attributes.empapp_id#</cfoutput>" name="empapp_id" id="empapp_id">
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
									<option value="#id#">#test_type#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-test_final_point">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="57684.Sonuç"></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<cfinput type="text" name="test_final_point" validate="float" required="yes" placeholder="#getLang('','Alınan Puan','62725')#">  
							</div>
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
								<cfinput type="text" name="point_base_type" validate="integer" value="100" placeholder="#getLang('','Toplam Puan','58985')#">
							</div>
						</div>
					</div>
					<div class="form-group" id="item-test_date">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='56283.Tarih girmelisiniz'></cfsavecontent>
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="38584.Sınav Tarihi !"></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="test_date" id="test_date" value="" validate="#validate_style#" maxlength="10" message="#message#">
								<span class="input-group-addon">
									<cf_wrk_date_image date_field="test_date">
								</span>
							</div>
						</div>
					</div>
				</div>
			<!---	<table>
					<tr>
						<td width="100"><cf_get_lang dictionary_id="38585.Sınav Tipi">*</td>
						<td>
							<cfquery name="get_test_type" datasource="#dsn#">
								SELECT ID,TEST_TYPE FROM SETUP_TEST_TYPE ORDER BY TEST_TYPE
							</cfquery>
							<select name="test_type" id="test_type" style="width:100px;">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfoutput query="get_test_type">
									<option value="#id#">#test_type#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="57684.Sonuç"></td>
						<td><cfinput type="text" name="test_final_point" validate="float" style="width:40px;" required="yes"> / 
						<cfinput type="text" name="point_base_type" validate="integer" style="width:40px;" value="100"></td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="38584.Sınav Tarihi"></td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="38584.Sınav Tarihi !"></cfsavecontent>
							<cfinput type="text" style="width:75px;" name="test_date" id="test_date" value="" validate="#validate_style#" maxlength="10" message="#message#">
							<cf_wrk_date_image date_field="test_date">
						</td>
					</tr>
				</table> --->
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	if(document.getElementById('test_type').value == '')
	{
		alert("<cf_get_lang dictionary_id='38583.Sınav tipi seçiniz'>");
		return false;
	}
	return true;
}
</script>

