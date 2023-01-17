<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/add_warehouse_rate.cfm">
<cfelse>
	<cf_catalystHeader>
	<cf_form_box>
	<cfform name="add_packet_ship" method="post" action="#request.self#?fuseaction=settings.list_warehouse_rates&event=add">
		<cfinput type="hidden" value="1" name="is_submit">
		<div class="row"> 
        <div class="col col-12 col-xs-12 uniqueRow"> 
            <div class="row formContent">
                <div class="row" type="row">
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-company">
							<label class="col col-3 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'> *</label>
							<div class="col col-6 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
									<input type="text" name="company" id="company" value="<cfif isdefined("attributes.company")><cfoutput>#attributes.company#</cfoutput></cfif>" readonly style="width:170px;">
									<cfset str_linke_ait="&field_comp_id=add_packet_ship.company_id&field_comp_name=add_packet_ship.company">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput><cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=7','list');"></span>
								</div>							
							</div>
						</div>
						<div class="form-group" id="item-action_date">
							<label class="col col-3 col-xs-12">Start Date</label>
							<div class="col col-6 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message">Start Date!</cfsavecontent>
									<cfinput type="text" name="action_date" id="action_date" validate="#validate_style#" required="Yes" message="#message#" style="width:65px;" value="#dateformat(now(),dateformat_style)#">
									<cfoutput>
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="action_date"></span>
									</cfoutput>
								</div>
							</div>
						</div>
					</div>					
				</div>
			</div>
		</div>
		</div>
		<div class="row formContentFooter">
			<div class="col col-12">
				<cf_workcube_buttons is_upd='0' add_function='control()'>
			</div>
		</div> 
	</cfform>
	</cf_form_box>
</cfif>
<script>
function control()
{
	if(document.getElementById('company_id').value == '' || document.getElementById('company_name').value == '')
	{
		alert('Choose Customer!');
		return false;
	}
	return true;
}

function buttonClickFunction()
{

}
</script>