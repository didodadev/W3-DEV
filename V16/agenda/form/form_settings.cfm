<cfif not isdefined("session.agenda_user_type")>
	<cfquery name="GET_AGENDA_STATUS" datasource="#DSN#">
		SELECT 
			AGENDA,
			EVENTCAT_ID
		FROM 
			MY_SETTINGS 
		WHERE 
			EMPLOYEE_ID = #session.ep.userid#			
	</cfquery>
	<cfinclude template="../query/get_event_cats.cfm">
</cfif>
<div class="col col-4 col-md-12 col-sm-12 col-xs-12">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='59270.Ajanda Tanımları'></cfsavecontent>
	<cf_box title="#head#">
		<cfform name="agenda_setup" method="post" action="#request.self#?fuseaction=agenda.emptypopup_upd_settings&id=center_top">
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<div class="form-group" id="item-user">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57930.Kullanıcı'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfif isdefined("session.agenda_userid")>
									<!--- baskasinin ajandasinda --->
									<cfif session.agenda_user_type is "e">
										<!--- employee ajandasinda --->
										<input type="hidden" name="member_type" id="member_type" value="employee">
										<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#session.agenda_userid#</cfoutput>">
										<cfset attributes.employee_id = session.agenda_userid>
										<cfinclude template="../query/get_hr_name.cfm">
										<input type="text" name="member" id="member" value="<cfoutput>#get_hr_name.employee_name# #get_hr_name.employee_surname#</cfoutput>" style="width:150px;" readonly>
									<cfelseif session.agenda_user_type is "p">
										<!--- partner ajandasinda --->
										<input type="hidden" name="member_type" id="member_type" value="partner">
										<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#session.agenda_userid#</cfoutput>">
										<cfset attributes.partner_id = session.agenda_userid>
										<cfinclude template="../query/get_partner_name.cfm">
										<input type="text" name="member" id="member" value="<cfoutput>#get_partner_name.company_partner_name# #get_partner_name.company_partner_surname#</cfoutput>" style="width:150px;" readonly>
									</cfif>
								<cfelse>
									<!--- kendi ajandasında --->
									<input type="hidden" name="member_type" id="member_type" value="employee">
									<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
									<input type="text" name="member" id="member" value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" style="width:150px;" readonly>
								</cfif>
								<cfif get_module_user(47)>
									<span class="input-group-addon"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=agenda_setup.member_id&field_name=agenda_setup.member&field_type=agenda_setup.member_type','list');"><i class="icon-ellipsis"></i></a></span>
								</cfif>
							</div>
						</div>
					</div>
					<cfif not isdefined("session.agenda_user_type")>
						<div class="form-group" id="item-event-cat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47575.Standart Olay Kategorisi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="eventcat_id" id="eventcat_id">
									<option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_event_cats">
										<option value="#eventcat_id#" <cfif eventcat_id eq get_agenda_status.eventcat_id>selected</cfif>>#eventcat#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-time-zone">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57497.Zaman Dilimi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_wrkTimeZone></div>
						</div>
						<div class="form-group">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="checkbox" name="is_agenda_open" id="is_agenda_open" value="1" <cfif get_agenda_status.agenda eq 1>checked</cfif>><cf_get_lang dictionary_id='31045.Ajandamı Herkes Görsün'>
							</div>
						</div>
					</cfif>
				</div>
			<cf_box_elements>
			<div class="col col-12 col-xs-12">
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0'>
				</cf_box_footer>
			</div>
		</cfform>
	</cf_box>
</div>
