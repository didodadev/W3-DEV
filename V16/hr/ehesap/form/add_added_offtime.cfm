<cf_get_lang_set module_name="ehesap">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfinclude template="../query/get_offtime_cats.cfm">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12"> 
	<cf_box>
		<cfform name="form_select_employee" method="post" action="">
			<cf_box_search more="0">
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="employee_id" id="employee_id" value="">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57576.Çalışan'></cfsavecontent>
						<cfsavecontent variable="message1"><cf_get_lang dictionary_id="57576.Çalışan"></cfsavecontent>
						<cfinput type="text" name="employee" value="" required="Yes" message="#message#" readonly="yes" placeholder="#message1#">
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_emp_id=form_select_employee.employee_id&field_emp_name=form_select_employee.employee');"></span>
					</div>
				</div>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='54107.İzinleri Getir'></cfsavecontent>
					<cfinput type="submit" class="ui-wrk-btn ui-wrk-btn-success" value="#message#" name="izin"> 
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<cfif len(attributes.employee_id)>
				<cfquery name="get_izins" datasource="#dsn#">
						SELECT DISTINCT
							OFFTIME.VALIDDATE, 
							OFFTIME.EMPLOYEE_ID, 
							OFFTIME.OFFTIME_ID, 
							OFFTIME.VALID_EMPLOYEE_ID, 
							OFFTIME.STARTDATE, 
							OFFTIME.FINISHDATE, 
							OFFTIME.TOTAL_HOURS, 
							SETUP_OFFTIME.OFFTIMECAT,
							EMPLOYEES.EMPLOYEE_NAME,
							EMPLOYEES.EMPLOYEE_SURNAME
						FROM 
							OFFTIME,
							SETUP_OFFTIME,
							EMPLOYEES
						WHERE
							OFFTIME.EMPLOYEE_ID = #attributes.employee_id# AND
							OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
							OFFTIME.IS_PUANTAJ_OFF = 1 AND
							OFFTIME.ADDED_OFFTIME_ID IS NULL AND
							OFFTIME.VALID_EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
				</cfquery>
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id ='54108.İzin Tipi'></th>
						<th><cf_get_lang dictionary_id ='57501.Başlangıç'></th>
						<th><cf_get_lang dictionary_id ='57502.Bitiş'></th>
						<th><cf_get_lang dictionary_id ='53004.Onaylayan'></th>
						<th><cf_get_lang dictionary_id ='53476.Onay Tarihi'></th>
						<th width="20"></th>
					</tr>
				</thead>
				<tbody>
					<cfif get_izins.recordcount>
						<cfform name="offtime_request" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_added_offtime"  method="post">
							<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
							<cfoutput query="get_izins">
								<tr>
									<td>#OFFTIMECAT#</td>
									<td>#dateformat(STARTDATE,dateformat_style)#</td>
									<td>#dateformat(FINISHDATE,dateformat_style)#</td>
									<td>#employee_name# #employee_surname#</td>
									<td>#dateformat(VALIDDATE,dateformat_style)#</td>
									<td><input type="checkbox" name="izin_ids" id="izin_ids" value="#OFFTIME_ID#"></td>
								</tr>
							</cfoutput>
							<tr><td colspan="6"></td></tr>
							<tr>
								<td colspan="2"  style="text-align:right;"><cf_get_lang dictionary_id ='54109.İzin Kategorisi'></td>
								<td colspan="4">
									<div class="form-group">
										<select name="offtimecat_id" id="offtimecat_id">
											<cfoutput query="get_offtime_cats">
												<option value="#offtimecat_id#">#offtimecat#</option>
											</cfoutput>
										</select>
									</div>
								</td>
							</tr>
							<tr>
								<td colspan="2"  style="text-align:right;"><cf_get_lang dictionary_id ='57501.Başlangıç'></td>
								<td colspan="4">
									<div class="form-group">
										<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
												<cfinput type="text" name="startdate" style="width:65;" value="" validate="#validate_style#" message="#message#" required="yes" maxlength="10">
												<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
											</div>
										</div>
										<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
											<div class="input-group">
												<cf_get_lang dictionary_id='57502.Bitiş'>
												<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
												<cfinput type="text" name="finishdate" style="width:65;" value="" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
												<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
											</div>
										</div>
									</div>					
								</td>
							</tr>
							<tr>
								<td colspan="2"  style="text-align:right;"><cf_get_lang dictionary_id ='57500.Onay'></td>
								<td colspan="4">
									<div class="form-group">
										<div class="input-group">
											<input type="Hidden" name="validator_position_code" id="validator_position_code" value="">
											<input type="text" name="validator_position" id="validator_position" value="" readonly>
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=offtime_request.validator_position_code&field_emp_name=offtime_request.validator_position');return false"></span>
										</div>
									</div>
								</td>
							</tr>
							<tr><td height="35" colspan="6" style="text-align:right;"></td></tr>
						</cfform>
					</cfif>
				</tbody>
			</cfif>	
		</cf_grid_list>	
		<!--- <cfif get_izins.recordcount>
			<div class="ui-info-bottom">
				<tr><td colspan="6"><cf_get_lang dictionary_id ='58486.Kayıt Bulunamadı'>!</td></tr>
			</div>	
		</cfif> --->
	</cf_box>
</div>									
<script type="text/javascript">
function check()
{
error_ = 1;
	if(offtime_request.izin_ids.length != undefined)
		{
			for (i=0; i < offtime_request.izin_ids.length; i++)
				{
					if(offtime_request.izin_ids[i].checked==true)
						{
						error_ = 0;
						}						
				}
			if(error_==1)
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='54336.İlişkilendirilecek İzin'>");
					return false;
				}
		}
	else
		{
		if(!(offtime_request.izin_ids.checked==true))
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='54336.İlişkilendirilecek İzin'>");
				return false;
			}
		}
		

	if (offtime_request.employee_id.value.length == 0)
		{
		alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57576.Çalışan'>");
		return false;
		}
	
	if (offtime_request.validator_position_code.value.length == 0)
		{
		alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='53995.Onaylayacak'>");
		return false;
		}
	
	return true;	
}
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
