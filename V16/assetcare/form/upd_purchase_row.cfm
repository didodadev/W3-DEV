<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
	SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE = 1 ORDER BY ASSETP_CAT
</cfquery>
<cf_grid_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='47973.araç Tipi'> *</th>
			<th><cf_get_lang dictionary_id='47901.Kullanım Amacı'> *</th>
			<th><cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'> *</th>
			<th><cf_get_lang dictionary_id='58225.Model'> *</th>
			<th><cf_get_lang dictionary_id='48013.Pert Plaka'></th>
			<th width="20"></th>
		</tr>
	</thead>
	<tbody name="table1" id="table1">
		<cfoutput query="get_request_rows">
			<tr>
				<td>
					<div class="form-group">
						<select name="assetp_catid" id="assetp_catid">
							<option value=""></option>
							<cfset assetp_cat_id_ = get_request_rows.assetp_catid>
							<cfloop query="get_assetp_cats">
								<option value="#assetp_catid#" <cfif assetp_catid eq assetp_cat_id_>selected</cfif>>#assetp_cat#</option>
							</cfloop>
						</select>
					</div>
				</td>
				<td>
					<div class="form-group">
						<select name="usage_purpose_id" id="usage_purpose_id">
							<option value=""></option>
							<cfset usage_purpose_id_ = usage_purpose_id>
							<cfloop query="get_usage_purpose">
								<option value="#usage_purpose_id#" <cfif usage_purpose_id eq usage_purpose_id_>selected</cfif>>#usage_purpose#</option>
							</cfloop>
						</select>
					</div>
				</td>
				<td>
					<div class="form-group">
						<div class="input-group">
							<input type="hidden" name="brand_type_id" id="brand_type_id" value="#brand_type_id#">
							<input type="text" name="brand_name" id="brand_name" value="#get_request_rows.brand_name# - #get_request_rows.brand_type_name#" readonly="yes">
							<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac(#currentrow#);"></span>
						</div>
					</div>
				</td>
				<td>
					<div class="form-group">
						<select name="make_year" id="make_year">
							<option value=""></option>
							<cfset bugun = dateformat(date_add("yyyy",1,now()),"yyyy")>
							<cfset yil = make_year>
							<cfloop from="#bugun#" to="1970" index="i" step="-1">
								<option value="#i#" <cfif i eq yil>selected</cfif>>#i#</option>
							</cfloop>
						</select>
					</div>
				</td>
				<td>
					<div class="form-group">
						<div class="input-group">
							<input type="hidden" name="assetp_id" id="assetp_id" value="#pert_id#">
							<input type="text" name="assetp" id="assetp" value="#assetp#">
							<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="plaka_ac();"></span>
						</div>
					</div>
				</td>
				<td></td>
			</tr> 
		</cfoutput>
	</tbody>
</cf_grid_list>
<cfsavecontent variable="satir_process">
	<cf_workcube_process process_action_dsn="#dsn#" is_upd="0" process_cat_width="150" is_detail="0">
</cfsavecontent>
