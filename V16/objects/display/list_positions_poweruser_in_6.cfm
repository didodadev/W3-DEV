<cfparam name="attributes.modal_id" default="">
<cfform name="positions_poweruser_in6" method="post" action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=center_top">
	<input type="hidden" name="page_type" id="page_type" value="<cfif isdefined('attributes.type') and len(attributes.type)><cfoutput>#attributes.type#</cfoutput></cfif>">
	<input type="hidden" name="position_id" id="position_id" value="<cfif isdefined('attributes.position_id') and len(attributes.position_id)><cfoutput>#attributes.position_id#</cfoutput></cfif>">
	<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
	<input type="hidden" name="auth_emps_id" id="auth_emps_id" value="">
	<input type="hidden" name="from_sec" id="from_sec" value="">
	<cf_box_elements>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33446.Ajandamı herkes görsün'></label>
				<div class="col col-8 col-xs-12"><input type="checkbox" name="agenda" id="agenda" <cfif my_sett.agenda eq 1>checked</cfif>></div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33447.Saat Ayarı'></label>
				<div class="col col-8 col-xs-12"><cf_wrkTimeZone selected="#my_sett.TIME_ZONE#" width="300"></div>
			</div>
		</div>
	</cf_box_elements>
	<cf_box_footer>
		<cf_record_info query_name="my_sett">
		<cf_workcube_buttons is_upd="0" add_function="control()">
	</cf_box_footer>
</cfform>
<script>
	function control() {
		get_auth_emps(1,0,0,1);
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('positions_poweruser_in6' , <cfoutput>#attributes.modal_id#</cfoutput>)
		</cfif>
	}
</script>

