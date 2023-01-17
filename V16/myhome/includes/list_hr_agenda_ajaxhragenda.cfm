<cfsetting showdebugoutput="no">
<cfparam name="attributes.hr_selection" default="1">
<cfinclude template="../query/get_list_hr_agenda.cfm">
<div id="div_hr_agenda"> 
<cfform name="hr_agenda" method="post" action="">
	<div class="ui-form-list flex-end">
		<div class="form-group">
			<select name="hr_selection" id="hr_selection" onChange="change_hr_det(this.value)">
				<cfif isdefined('x_hr_agenda') and len(x_hr_agenda)>
				<option value="1" <cfif attributes.hr_selection eq 1>selected</cfif>>Mülakat</option>
				</cfif>
				<option value="2" <cfif attributes.hr_selection eq 2>selected</cfif>>Eğitim</option>
				<option value="3" <cfif attributes.hr_selection eq 3>selected</cfif>>Belirli Süreli Çalışanlar</option>
				<option value="4" <cfif attributes.hr_selection eq 4>selected</cfif>>Deneme Süresinde Olanlar</option>
				<option value="5" <cfif attributes.hr_selection eq 5>selected</cfif>>Gözlem Süresi Bitenler</option>
				<option value="6" <cfif attributes.hr_selection eq 6>selected</cfif>>Vekalet Süresi Bitenler</option>
			</select> 
		</div>
	</div>
    <cf_flat_list>
		<tbody>
			<cfif isdefined("get_event_det") and get_event_det.recordcount>
				<cfoutput query="get_event_det">
					<tr id="hr_selection_1" <cfif attributes.hr_selection neq 1>style="display:none;"</cfif>>
						<td>#dateformat(date_add('h',session.ep.time_zone,startdate),'dd.mm.yyyy')#<br/>
							<a href="#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#event_id#" class="tableyazi">#event_head#</a>
						</td>
						<td style="text-align:right;" valign="top">#timeformat(date_add('h', session.ep.time_zone,startdate),timeformat_style)#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr id="hr_selection_1" <cfif attributes.hr_selection neq 1>style="display:none;"</cfif>>
					<td><cf_get_lang_main no='72.Kayıt Yok'> !</td>
				</tr>
			</cfif>
			<cfif isDefined("get_training_class") and get_training_class.recordcount>
				<cfoutput query="get_training_class">
				<tr id="hr_selection_2" <cfif attributes.hr_selection neq 2>style="display:none;"</cfif>>
					<td>#dateformat(date_add('h',session.ep.time_zone,start_date),'dd.mm.yyyy')#<br/>
						 <a href="#request.self#?fuseaction=training_management.form_upd_class&class_id=#class_id#" class="tableyazi">#class_name#</a>
					</td>
					<td style="text-align:right;" valign="top">
						#timeformat(date_add('h', session.ep.time_zone,start_date),timeformat_style)#
					</td>
				</tr>
				</cfoutput>
			<cfelse>
				<tr id="hr_selection_2" <cfif attributes.hr_selection neq 2>style="display:none;"</cfif>>
					<td><cf_get_lang_main no='72.Kayıt Yok'> !</td>
				</tr>
			</cfif>
			<cfif isDefined("get_sureli_finishdate_det") and get_sureli_finishdate_det.recordcount>
				<cfoutput query="get_sureli_finishdate_det">
					<tr id="hr_selection_3" <cfif attributes.hr_selection neq 3>style="display:none;"</cfif>>
						<td><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi">#emp_name# - #branch_name#</a></td>
						<td style="text-align:right;">#dateformat(date_add('h',session.ep.time_zone,sureli_is_finishdate),'dd.mm.yyyy')#<br/></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr id="hr_selection_3" <cfif attributes.hr_selection neq 3>style="display:none;"</cfif>>
					<td><cf_get_lang_main no='72.Kayıt Yok'> !</td>
				</tr>
			</cfif>
			<cfif isDefined("get_trial_date_det") and get_trial_date_det.recordcount>
				<cfoutput query="get_trial_date_det">
					<tr id="hr_selection_4" <cfif attributes.hr_selection neq 4>style="display:none;"</cfif>>
						<td><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi">#emp_name# - #branch_name#</a></td>
						<td style="text-align:right;">#dateformat(date_add('h',session.ep.time_zone,trial_date),'dd.mm.yyyy')#<br/></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr id="hr_selection_4" <cfif attributes.hr_selection neq 4>style="display:none;"</cfif>>
					<td><cf_get_lang_main no='72.Kayıt Yok'> !</td>
				</tr>
			</cfif>
			<cfif isDefined("get_observation_vekaleten_date") and get_observation_vekaleten_date.recordcount>
				<cfoutput query="get_observation_vekaleten_date">
					<tr id="hr_selection_5" <cfif attributes.hr_selection neq 5>style="display:none;"</cfif>>
						<td><a href="#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#position_id#" class="tableyazi">#emp_name# - #branch_name#</a></td>
						<td style="text-align:right;">#dateformat(observation_date,'dd.mm.yyyy')#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr id="hr_selection_5" <cfif attributes.hr_selection neq 5>style="display:none;"</cfif>>
					<td><cf_get_lang_main no='72.Kayıt Yok'> !</td>
				</tr>
			</cfif> 
			<cfif isDefined("get_observation_vekaleten_date") and get_observation_vekaleten_date.recordcount>
				<cfoutput query="get_observation_vekaleten_date">
					<tr id="hr_selection_6" <cfif attributes.hr_selection neq 6>style="display:none;"</cfif>>
						<td><a href="#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#position_id#" class="tableyazi">#emp_name# - #branch_name#</a></td>
						<td style="text-align:right;">#dateformat(vekaleten_date,'dd.mm.yyyy')#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr id="hr_selection_6" <cfif attributes.hr_selection neq 6>style="display:none;"</cfif>>
					<td><cf_get_lang_main no='72.Kayıt Yok'> !</td>
				</tr>
			</cfif>
		</tbody>
	</cf_flat_list>
</cfform>
</div> 
 <script language="javascript">
	function change_hr_det(hr_selection)
	{
		if(document.hr_agenda.hr_selection.value == 1)
		{
			document.getElementById("hr_selection_1").style.display = '';
		}
		else
		{
			document.getElementById("hr_selection_1").style.display = 'none';
		}
		if(document.hr_agenda.hr_selection.value == 2)
		{
			document.getElementById("hr_selection_2").style.display = '';
		}
		else
		{
			document.getElementById("hr_selection_2").style.display = 'none';
		}
		if(document.hr_agenda.hr_selection.value == 3)
		{
			document.getElementById("hr_selection_3").style.display = '';
		}
		else
		{
			document.getElementById("hr_selection_3").style.display = 'none';
		}
		if(document.hr_agenda.hr_selection.value == 4)
		{
			document.getElementById("hr_selection_4").style.display = '';
		}
		else
		{
			document.getElementById("hr_selection_4").style.display = 'none';
		}
		if(document.hr_agenda.hr_selection.value == 5)
		{
			document.getElementById("hr_selection_5").style.display = '';
		}
		else
		{
			document.getElementById("hr_selection_5").style.display = 'none';
		}
		if(document.hr_agenda.hr_selection.value == 6)
		{
			document.getElementById("hr_selection_6").style.display = '';
		}
		else
		{
			document.getElementById("hr_selection_6").style.display = 'none';
		}
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_list_hr_agenda_ajaxhragenda&hr_selection='+hr_selection+'&x_hr_agenda=#x_hr_agenda#'</cfoutput>,'div_hr_agenda',1);
		return true;
	}
</script> 
