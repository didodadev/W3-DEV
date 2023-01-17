<cfquery name="get_titles" datasource="#dsn#">
	SELECT TITLE, TITLE_ID FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
</cfquery>
<cfquery name="get_units" datasource="#dsn#">
	SELECT UNIT_NAME, UNIT_ID FROM SETUP_CV_UNIT ORDER BY UNIT_NAME
</cfquery>
<cf_catalystHeader>
    <cfsavecontent variable="warning"><cf_get_lang dictionary_id="41023.Ağırlık değerleri 0-100 arasında olmalıdır!"></cfsavecontent>

<cfsavecontent variable="message"><cf_get_lang dictionary_id="38679.Değerlendirme Ağırlığı Ekle"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_emp_perf" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_emp_perf_weight">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-is_active">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</div>
						<label class="col col-6 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id ='57493.Aktif'><input type="checkbox" name="is_active" id="is_active" value="1"></label>
					</div>
					<div class="form-group" id="item-emp_perf_weight">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="33726.Bireysel Hedef Ağırlığı"> *</label>
						<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="text" message="#warning#" name="emp_perf_weight"  value="" onkeyup="return(FormatCurrency(this,event));" required="yes"  maxlength="5" validate="float" range="0,100">					
						</div>   
					</div>
					<div class="form-group" id="item-comp_targ_weight">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="33725.Şirket Performans Sonucu Ağırlığı"> *</label>
						<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
							<cfinput required="Yes" message="#warning#"  onkeyup="return(FormatCurrency(this,event));" maxlength="5" validate="float" range="0,100" type="text" name="comp_targ_weight" value="">
						</div>
					</div>
					<div class="form-group" id="item-comp_perf_result">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="33724.Şirket Performans Sonucu"></label>
						<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="text"  onKeyUp="return(FormatCurrency(this,event));" name="comp_perf_result" id="comp_perf_result" value="" maxlength="5" validate="float" range="0,100">
						</div>
					</div>
					<div class="form-group" id="item-title_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
						<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="57734.Seçiniz"></cfsavecontent>
							<cf_multiselect_check
								name="title_id"
								query_name="get_titles"
								width="140"
								option_text="#message#"
								option_value="TITLE_ID"
								option_name="TITLE"
								value="">
						</div>
					</div>
					<div class="form-group" id="item-unit_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58701.Fonksiyon'></label>
						<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="57734.Seçiniz"></cfsavecontent>
							<cf_multiselect_check
							name="unit_id"
							query_name="get_units"
							width="140"
							option_text="#message#"
							option_value="UNIT_ID"
							option_name="UNIT_NAME"
							value="">
						</div>
					</div>
					<div class="form-group" id="item-emp_perf_year">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58455.Yıl'> *</label>
						<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
							<select name="emp_perf_year" id="emp_perf_year">
								<cfloop from="#year(now())+2#" to="#year(now())-4#" index="i" step="-1">
									<cfoutput>
										<option value="#i#" <cfif year(now()) eq i> selected</cfif>>#i#</option>
									</cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-10 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id="38678.Süreçten mi çalışsın?"> <input type="checkbox" name="is_stage" id="is_stage" value="1" onchange="degerlendirici_gizle_goster()"></div> 
					<cf_flat_list id="agirlik_hdr" style="display:none;">
						<thead>
							<th width="100"><cf_get_lang dictionary_id ='29907.Değerlendiriciler'></th>
							<th width="30"><cf_get_lang dictionary_id ='29784.Ağırlık'></th>
						</thead>
						<tbody>
							<tr style="border-bottom:none">
								<td><div class="form-group" id="item-is_employee"><label><input type="checkbox" name="is_employee" id="is_employee" value="1"><cf_get_lang dictionary_id ='57576.Çalışan'></label></div></td>
								<td width="30"><div class="form-group" id="item-employee_weight"><cfinput type="text" message="#warning#" name="employee_weight" value="" onkeyup="return(FormatCurrency(this,event));" required="no"  maxlength="5" validate="float" range="0,100"></div></td>
							</tr>
							<tr style="border-bottom:none">
								<td><div class="form-group" id="item-is_consultant"><label><input type="checkbox" name="is_consultant" id="is_consultant" value="1"><cf_get_lang dictionary_id ='29908.Görüş Bildiren'></div></label></td>
								<td><div class="form-group" id="item-consultant_weight"><cfinput type="text" message="#warning#" name="consultant_weight" value="" onkeyup="return(FormatCurrency(this,event));" required="no"  maxlength="5" validate="float" range="0,100"></div></td>
							</tr>
							<tr style="border-bottom:none">
								<td><div class="form-group" id="item-is_upper_position"><label><input type="checkbox" name="is_upper_position" id="is_upper_position" value="1"> 1.<cf_get_lang dictionary_id ='29666.Amir'></div></label></td>
								<td><div class="form-group" id="item-upper_position_weight"><cfinput type="text" message="#warning#" name="upper_position_weight" value="" onkeyup="return(FormatCurrency(this,event));" required="no"  maxlength="5" validate="float" range="0,100"></div></td>
							</tr>
							<tr style="border-bottom:none">
								<td><div class="form-group" id="item-is_upper_position2"><label><input type="checkbox" name="is_upper_position2" id="is_upper_position2" value="1"> 2.<cf_get_lang dictionary_id ='29666.Amir'></div></label></td>
								<td><div class="form-group" id="item-upper_position2_weight"><cfinput type="text" message="#warning#" name="upper_position2_weight" value="" onkeyup="return(FormatCurrency(this,event));" required="no"  maxlength="5" validate="float" range="0,100"></div></td>
							</tr>
							<tr style="border-bottom:none">
								<td><div class="form-group" id="item-is_mutual_assessment"><label><input type="checkbox" name="is_mutual_assessment" id="is_mutual_assessment" value="1"><cf_get_lang dictionary_id ='29909.Ortak Değerlendirme'></div></label></td>
								<td><div class="form-group" id="item-mutual_assessment_weight"><cfinput type="text" message="#warning#" name="mutual_assessment_weight" value="" onkeyup="return(FormatCurrency(this,event));" required="no"  maxlength="5" validate="float" range="0,100"></div></td>
							</tr>
						</tbody>
					</cf_flat_list>
				</div>
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
		if(document.add_emp_perf.emp_perf_weight.value.length==0 || document.add_emp_perf.comp_targ_weight.value.length==0 || document.add_emp_perf.emp_perf_year.value.length==0 ||
			(document.add_emp_perf.is_employee.checked && document.add_emp_perf.employee_weight.value.length==0) || (document.add_emp_perf.is_consultant.checked && document.add_emp_perf.consultant_weight.value.length==0) ||
			(document.add_emp_perf.is_upper_position.checked && document.add_emp_perf.upper_position_weight.value.length==0) ||
			(document.add_emp_perf.is_mutual_assessment.checked && document.add_emp_perf.mutual_assessment_weight.value.length==0) ||
			(document.add_emp_perf.is_upper_position2.checked && document.add_emp_perf.upper_position2_weight.value.length==0))
		{
			alert("<cf_get_lang dictionary_id='35365.Alanları eksiksiz doldurduğunuzdan emin olunuz'>!");
			return false;
		}
		if (document.getElementByName('comp_perf_result').value)
			document.getElementByName('comp_perf_result').value=filterNum(document.getElementByName('comp_perf_result').value);
		if (document.getElementByName('emp_perf_weight').value)
			document.getElementByName('emp_perf_weight').value=filterNum(document.getElementByName('emp_perf_weight').value);
		if (document.getElementByName('comp_targ_weight').value)
			document.getElementByName('comp_targ_weight').value=filterNum(document.getElementByName('comp_targ_weight').value);
		if (document.getElementByName('employee_weight').value)
			document.getElementByName('employee_weight').value=filterNum(document.getElementByName('employee_weight').value);
		if (document.getElementByName('consultant_weight').value)
			document.getElementByName('consultant_weight').value=filterNum(document.getElementByName('consultant_weight').value);
		if (document.getElementByName('upper_position_weight').value)
			document.getElementByName('upper_position_weight').value=filterNum(document.getElementByName('upper_position_weight').value);
		if (document.getElementByName('mutual_assessment_weight').value)
			document.getElementByName('mutual_assessment_weight').value=filterNum(document.getElementByName('mutual_assessment_weight').value);
		if (document.getElementByName('upper_position2_weight').value)
			document.getElementByName('upper_position2_weight').value=filterNum(document.getElementByName('upper_position2_weight').value);
		return true;
	}
	function degerlendirici_gizle_goster(){
		if (document.getElementById('is_stage').checked)
		{
			document.getElementById('agirlik_hdr').style.display = '';
			
		} else {
			document.getElementById('agirlik_hdr').style.display = 'none';
		}
	}
</script>
