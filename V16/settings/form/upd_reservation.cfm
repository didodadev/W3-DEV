<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('','settings',44755)#" add_href="#request.self#?fuseaction=settings.form_add_reservation" is_blank="0"><!--- Rezervasyon Durumları --->
		<cfform name="reservationform" method="post" action="#request.self#?fuseaction=settings.emptypopup_reservation_upd">
			<cfquery name="CATEGORY" datasource="#dsn#">
				SELECT
				RESERVATION_ID,
				#dsn#.Get_Dynamic_Language(RESERVATION_ID,'#session.ep.language#','SETUP_RESERVATION','RESERVATION',NULL,NULL,RESERVATION) AS RESERVATION,
				COLOR,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				UPDATE_DATE,
				UPDATE_EMP,
				UPDATE_IP
				FROM 
					SETUP_RESERVATION 
				WHERE 
					RESERVATION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
			</cfquery>
			<input type="hidden" name="reservation_ID" id="reservation_ID" value="<cfoutput>#URL.ID#</cfoutput>">
			<cf_box_elements>	
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
					<cfinclude template="../display/list_reservation.cfm">
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="form-group" id="item-time_cost_cat">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='44754.Rezervasyon Durumu'> *</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<div class="input-group">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='44758.Rezervasyon girmelisiniz'></cfsavecontent>
				<cfinput type="text" name="reservation" value="#category.reservation#" maxlength="20" required="Yes" message="#message#">
				<span class="input-group-addon">
					<cf_language_info
					table_name="SETUP_RESERVATION"
					column_name="RESERVATION" 
					column_id_value="#URL.ID#" 
					maxlength="500" 
					datasource="#dsn#" 
					column_id="RESERVATION_ID" 
					control_type="0">
					</span>
						</div>
			                </div>
						</div>
						<div class="form-group" id="item-colour">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='341.Kategori Rengi'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<cf_workcube_color_picker name="colourp" id="colourp" value="#category.color#" width="200">
							</div>
						</div>
					</div>
			    </div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="category">
				<cfif not listfindnocase("1,2,3",attributes.id)>
					<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_reservation_del&reservation_id=#url.id#'>
					<cfelse>
					<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0'>
					</cfif>
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