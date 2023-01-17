
<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('','settings',44755)#" add_href="#request.self#?fuseaction=settings.form_add_reservation"><!--- Rezervasyon Durumları --->
    <cfform name="reservationform" method="post" action="#request.self#?fuseaction=settings.emptypopup_reservation_add">
			<cf_box_elements>	
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
					<cfinclude template="../display/list_reservation.cfm">
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="form-group" id="item-time_cost_cat">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='44754.Rezervasyon Durumu'> *</label>
							<div class="col col-8 col-md-6 col-xs-12">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='44758.Rezervasyon girmelisiniz'></cfsavecontent>
                  <cfinput type="text" name="reservation" value="" maxlength="20" required="Yes" message="#message#">
               </div>
						</div>
						<div class="form-group" id="item-colour">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='341.Kategori Rengi'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<cf_workcube_color_picker name="colourp" id="colourp" value="" width="200">
							</div>
						</div>
					</div>
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
		if(document.getElementById("reservation").value == '')
		{
			alert('<cf_get_lang dictionary_id='44758.Rezervasyon Girmelisiniz'>!')
			return false;
		}
	}

</script>