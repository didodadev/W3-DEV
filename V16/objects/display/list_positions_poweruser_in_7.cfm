<cfquery name="GET_NUMBERS" datasource="#DSN3#">
	SELECT
		*
	FROM
		PAPERS_NO
	WHERE
		<cfif isDefined("attributes.employee_id")>
		   EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		<cfelse>
		   EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		</cfif>	
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cfform name="positions_poweruser_in7" method="post" action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=center_down">
	<input type="hidden" name="page_type" id="page_type" value="<cfif isdefined('attributes.type') and len(attributes.type)><cfoutput>#attributes.type#</cfoutput></cfif>">
	<input type="hidden" name="position_id" id="position_id" value="<cfif isdefined('attributes.position_id') and len(attributes.position_id)><cfoutput>#attributes.position_id#</cfoutput></cfif>">
	<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
	<input type="hidden" name="auth_emps_id" id="auth_emps_id" value="">
	<input type="hidden" name="from_sec" id="from_sec" value="">
	<cfoutput>
		<cf_box_elements>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33449.Tah Makbuzu No'></label>
					<div class="col col-4 col-xs-12"><input type="text" name="revenue_receipt_no" id="revenue_receipt_no" value="#get_numbers.revenue_receipt_no#"></div>
					<div class="col col-4 col-xs-12"><input type="text" name="revenue_receipt_number" id="revenue_receipt_number" value="#get_numbers.revenue_receipt_number#" size="4"></div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58133.Fatura No'></label>
					<div class="col col-4 col-xs-12"><input type="text" name="invoice_no" id="invoice_no" value="#get_numbers.invoice_no#"></div>
					<div class="col col-4 col-xs-12"><input type="text" name="invoice_number" id="invoice_number" value="#get_numbers.invoice_number#" size="4"></div>
				</div>
				<cfif session.ep.our_company_info.is_efatura>
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29872.E-Fatura No'></label>
						<div class="col col-4 col-xs-12"><input type="text" name="e_invoice_no" id="e_invoice_no" value="#get_numbers.e_invoice_no#"></div>
						<div class="col col-4 col-xs-12"><input type="text" name="e_invoice_number" id="e_invoice_number" value="#get_numbers.e_invoice_number#" size="4"></div>
					</div>
				</cfif>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58138.İrsaliye No'></label>
					<div class="col col-4 col-xs-12"><input type="text" name="ship_no" id="ship_no" value="#get_numbers.ship_no#"></div>
					<div class="col col-4 col-xs-12"><input type="text" name="ship_number" id="ship_number" value="#get_numbers.ship_number#" size="4"></div>
				</div>
			</div>
		</cf_box_elements>
	</cfoutput>
	<cf_box_footer>
		<cf_record_info query_name="GET_NUMBERS">
		<cf_workcube_buttons is_upd="0" add_function="control()">
	</cf_box_footer>
</cfform>
<script>
	function control() {
		get_auth_emps(1,0,0,1);
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('positions_poweruser_in7' , <cfoutput>#attributes.modal_id#</cfoutput>)
		</cfif>
	}
</script>

