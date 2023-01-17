<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/add_warehouse_rate.cfm">
<cfelse>
	<cf_catalystHeader>
	<cf_box>
		<cfform name="add_packet_ship" method="post" action="#request.self#?fuseaction=settings.list_warehouse_rates&event=add">
			<cfinput type="hidden" value="1" name="is_submit">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-company">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</label>
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
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57742.Tarih"></label>
						<div class="col col-6 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="57742.Tarih">!</cfsavecontent>
								<cfinput type="text" name="action_date" id="action_date" validate="#validate_style#" required="Yes" message="#message#" style="width:65px;" value="#dateformat(now(),dateformat_style)#">
								<cfoutput>
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="action_date"></span>
								</cfoutput>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-branch">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63988.Hizmet Verilen Şube"></label>
						<div class="col col-6 col-xs-12">
							<div class="form-group medium">
								<select id="branch_id" name="branch_id">
									<option value="0"><cf_get_lang dictionary_id="63989.Tüm Şubelerde Hizmet Veriliyor"></option>
									<cfquery name="get_branch" datasource="#dsn#">
									Select 
									  BRANCH_NAME,
									  BRANCH_ID 
									FROM 
									  BRANCH
									</cfquery>
									<cfoutput query="get_branch">
									<option value="#get_branch.BRANCH_ID#">#get_branch.BRANCH_NAME#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
				</div>				
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons id="ss" is_upd='0' add_function='control()'>
			</cf_box_footer> 
		</cfform>
	</cf_box>
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
	add_packet_ship.wrk_submit_button.click();
}
</script>