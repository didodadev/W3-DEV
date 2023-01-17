<cf_catalystHeader>
<cf_box>
	<cfform name="add_note" id="add_note" method="post" action="#request.self#?fuseaction=finance.emptypopup_add_scenario">
		<cf_box_elements>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-scenario_head">
					<label class="col col-3 col-xs-12"><cfoutput>#getLang('main',68)#</cfoutput> *</label>
					<div class="col col-9 col-xs-12">
						<cfinput type="text" name="scenario_head" required="yes">
					</div>
				</div>
				<div class="form-group" id="item-detail">
					<label class="col col-3 col-xs-12"><cfoutput>#getLang('main',217)#</cfoutput></label>
					<div class="col col-9 col-xs-12">
						<textarea name="detail" id="detail" rows="5"></textarea>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
function kontrol(){
	if(!$("#scenario_head").val().length)
	{
		alertObject({message: '<cfoutput>#getLang('hr',1196)#</cfoutput>'})    
		return false;
	}
}
</script>
