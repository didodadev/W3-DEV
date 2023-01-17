<cfinclude template="../query/get_scheduled_report.cfm">
<cfif not get_scheduled_report.recordcount>
<cfinclude template="../query/get_schedules.cfm">
	<cfform action="#request.self#?fuseaction=report.emptypopup_add_schedules" name="add_schedule" method="post">
		<input  type="hidden" name="report_id" id="report_id" value="<cfoutput>#attributes.report_id#</cfoutput>">
		<cfscript>
			start = find('report_id',page_code,1);
			finish = find('&',page_code,start + 5);
			if(finish lt 1)
			{
				finish = Len(page_code);
				start = 2;
			}
			extra = removechars(page_code,start - 1,finish - start + 2);
		</cfscript>
		<input  type="hidden" name="extra" id="extra" value="<cfoutput>#extra#</cfoutput>">
		<cfsavecontent variable="title"><cf_get_lang dictionary_id='38818.Periyodik Rapor'></cfsavecontent>
		<cf_box title="#title#" closable="1"  popup_box="1">
			<cf_box_elements  vertical="1">	
					<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
						<label><cf_get_lang dictionary_id='57434.Rapor'>-<cf_get_lang dictionary_id='57480.Konu'></label>
						<textarea name="report_name" id="report_name"></textarea>
					</div>
					<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item">
						<label><cf_get_lang dictionary_id='51077.TO'>-<cf_get_lang dictionary_id='29463.Mail'></label>
						<div class="input-group">
							<input type="hidden" name="emp_id" id="emp_id"> 
							<input type="text" name="emp_mail" id="emp_mail">				
							<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_mail&mail_id=add_schedule.emp_id&names=add_schedule.emp_mail','list')"></span>
						</div>
					</div>
					<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
						<label title="<cf_get_lang dictionary_id='57434.Rapor'><cf_get_lang dictionary_id='57461.Kaydet'>"><cf_get_lang dictionary_id='57434.Rapor'><cf_get_lang dictionary_id='57461.Kaydet'></label>
						<input type="checkbox" name="record" id="record" checked>
					</div>
					<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">	
						<label title="<cf_get_lang dictionary_id='99.Ilgili Kisiler'><cf_get_lang dictionary_id='57475.Mail Gönder'>"><cf_get_lang dictionary_id='57475.Mail Gönder'></label>
						<input type="checkbox" name="email" id="email">
					</div>
					<cfset ind = 0>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<cf_ajax_list>
							<thead>
								<th>
									<cf_get_lang dictionary_id='30201.Görev'>									
								</th>
							</thead>									
							<cfoutput query="GET_SCHEDULES">
								<tbody>
									<td>
										<div class="form-group">			  
											<cfif (ind mod 2 eq 0)></cfif>
											<div class="col col-1 col-md-1 col-sm-1 col-xs-12"><input type="checkbox" name="schedule_id" id="schedule_id" value="#SCHEDULE_ID#"></div>
											<div class="col col-1 col-md-1 col-sm-1 col-xs-12"><label>#SCHEDULE_NAME#</label></div>																	
											<cfset ind = ind + 1>
											<cfif (ind mod 2 eq 0)></cfif>
										</div>
									</td>
								</tbody>
							</cfoutput>					
						</cf_ajax_list>
					</div>									
			</cf_box_elements>
			<cf_box_footer><cf_workcube_buttons is_upd='0' add_function="control()"></cf_box_footer>
		</cf_box>
	</cfform>
<cfelse>
	<cfinclude template="../query/get_schedules.cfm">
	<cfform action="#request.self#?fuseaction=report.emptypopup_upd_schedules" name="add_schedule" method="post">
		<input  type="hidden" name="report_id" id="report_id" value="<cfoutput>#attributes.report_id#</cfoutput>">
		<cfscript>
			start = find('report_id',page_code,1);
			finish = find('&',page_code,start + 5);
			if(finish lt 1)
			{
				finish = Len(page_code);
				start = 2;	
			}
			extra = removechars(page_code,start - 1,finish - start + 2);
		</cfscript>
		<input  type="hidden" name="extra" id="extra" value="<cfoutput>#extra#</cfoutput>">
		<cfsavecontent variable="title"><cf_get_lang dictionary_id='38808.Zaman Ayarlı Görev Ekle'></cfsavecontent>
		<cf_box title="#title#" closable="1"  popup_box="1">
			<cf_box_elements  vertical="1">	
					<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
						<label><cf_get_lang dictionary_id='57434.Rapor'>-<cf_get_lang dictionary_id='57480.Konu'></label>
						<textarea name="report_name"><cfoutput>#GET_SCHEDULED_REPORT.REPORT_NAME#</cfoutput></textarea>
					</div>
					<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" id="item">
						<label><cf_get_lang dictionary_id='51077.TO'>-<cf_get_lang dictionary_id='29463.Mail'></label>
						<div class="input-group">
							<input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#GET_SCHEDULED_REPORT.INFORMED_PEOPLE#</cfoutput>"> 
							<input type="text" name="emp_mail" id="emp_mail" value="<cfoutput>#GET_SCHEDULED_REPORT.INFORMED_PEOPLE_MAILS#</cfoutput>">					  				
							<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_mail&mail_id=add_schedule.emp_id&names=add_schedule.emp_mail','list')"></span>
						</div>
					</div>
					<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
						<label title="<cf_get_lang dictionary_id='57434.Rapor'><cf_get_lang dictionary_id='57461.Kaydet'>"><cf_get_lang dictionary_id='57434.Rapor'><cf_get_lang dictionary_id='57461.Kaydet'></label>
						<input type="checkbox" name="record" id="record"<cfif (GET_SCHEDULED_REPORT.SCHEDULE_STATUS eq 0) or (GET_SCHEDULED_REPORT.SCHEDULE_STATUS eq 2)> checked</cfif>>
					</div>
					<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
						<label title="<cf_get_lang dictionary_id='38820.Ilgili Kisiler'><cf_get_lang dictionary_id='57475.Mail Gönder'>"><cf_get_lang dictionary_id='57475.Mail Gönder'></label>
						<input type="checkbox" name="email" id="email"<cfif (GET_SCHEDULED_REPORT.SCHEDULE_STATUS eq 1) or (GET_SCHEDULED_REPORT.SCHEDULE_STATUS eq 2)> checked</cfif>>						
					</div>
					<cfset ind = 0>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<cf_ajax_list>
							<thead>
								<th>
									<cf_get_lang dictionary_id='30201.Görev'>									
								</th>
							</thead>									
							<cfoutput query="GET_SCHEDULES">
								<tbody>
									<td>
										<div class="form-group">			  
											<cfif (ind mod 2 eq 0)></cfif>
											<div class="col col-1 col-md-1 col-sm-1 col-xs-12"><input type="checkbox" name="schedule_id" id="schedule_id" value="#SCHEDULE_ID#"<cfif GET_SCHEDULED_REPORT.SCHEDULE_IDS contains ',#SCHEDULE_ID#,'> checked</cfif>></div>
											<div class="col col-1 col-md-1 col-sm-1 col-xs-12"><label>#SCHEDULE_NAME#</label></div>																	
											<cfset ind = ind + 1>
											<cfif (ind mod 2 eq 0)></cfif>
										</div>
									</td>
								</tbody>
							</cfoutput>					
						</cf_ajax_list>
					</div>
			</cf_box_elements>
			<cf_box_footer>
					<cf_record_info query_name="GET_SCHEDULED_REPORT" record_emp="record_emp" update_emp="update_emp">
					<cf_workcube_buttons is_upd='1' add_function="control()" delete_page_url='#request.self#?fuseaction=report.emptypopup_del_schedules&REPORT_ID=#attributes.report_id#'>
			</cf_box_footer>
		</cf_box>
	</cfform>
</cfif>
<script type="text/javascript">
	function control()
	{		
		if(document.add_schedule.record.checked && (document.add_schedule.report_name.value.length == 0)){
			alert("<cf_get_lang dictionary_id='57434.Rapor'>");
			return false;
		}
		if(document.add_schedule.email.checked && (document.add_schedule.emp_mail.value.length == 0)){
			alert("<cf_get_lang dictionary_id='38821.Kisi Ekle'>");
			return false;
		}		
		return true;
	}
</script>
