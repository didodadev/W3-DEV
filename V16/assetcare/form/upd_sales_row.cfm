<cf_grid_list table_width="1246">
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='29453.Plaka'> *</th>
			<th><cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'> *</th>
			<th><cf_get_lang dictionary_id='58225.Model'> *</th>
		</tr>
	</thead>
	<tbody name="table1" id="table1">
		<cfoutput query="get_request_rows">
			<tr>
				<td>
					<div class="form-group">
						<div class="input-group">
							<input type="hidden" name="assetp_id" id="assetp_id" value="#assetp_id#">
							<input type="text" name="assetp" id="assetp" value="#assetp#" readonly="yes">
							<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="plaka_ac();"></span>
						</div>
					</div>
				</td>
				<td>
					<div class="form-group">
						<input type="hidden" name="brand_type_id" id="brand_type_id" value="#brand_type_id#">
						<input type="text" name="brand_name" id="brand_name" value="#get_request_rows.brand_name# - #get_request_rows.brand_type_name#" readonly="yes">
					</div>
				</td>
				<td>
					<div class="form-group">
						<select name="make_year" id="make_year">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfset bugun = dateformat(date_add("yyyy",1,now()),"yyyy")>
							<cfset yil = make_year>
							<cfloop from="#bugun#" to="1970" index="i" step="-1">
							<option value="#i#" <cfif i eq yil>selected</cfif>>#i#</option>
							</cfloop>
						</select>
					</div>
				</td>
			</tr>
		</cfoutput>
	</tbody>
</cf_grid_list>
<cfsavecontent variable="satir_process">
	<cf_workcube_process process_action_dsn="#dsn#" is_upd="0" process_cat_width="150" is_detail="0" is_reset='0' is_cancel='0'>
</cfsavecontent>
