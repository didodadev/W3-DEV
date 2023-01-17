<cfinclude template="../query/get_assetp_groups.cfm">
<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
	SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE = 1 ORDER BY ASSETP_CAT
</cfquery>

<cf_grid_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='48098.Eski Araç'> *</th>
			<th><cf_get_lang dictionary_id='58847.Marka'>/<cf_get_lang dictionary_id='30041.Marka Tipi'></th>
			<th><cf_get_lang dictionary_id='58225.Model'></th>
			<th><cf_get_lang dictionary_id='48099.Yeni Araç Tipi'> *</th>
			<th><cf_get_lang dictionary_id='47901.Kullanım Amacı'> *</th>
			<th><cf_get_lang dictionary_id='58847.Marka'>/<cf_get_lang dictionary_id='30041.Marka Tipi'> *</th>
			<th><cf_get_lang dictionary_id='58225.Model'> *</th>
		</tr>
	</thead>
	<tbody name="table1" id="table1">
		<cfoutput query="get_request_rows">
			<tr>
				<td>
					<div class="form-group">
						<div class="input-group">
							<input type="hidden" name="old_assetp_id" id="old_assetp_id" value="#assetp_id#">
							<input type="text" name="old_assetp" id="old_assetp" value="#assetp#" readonly="yes">
							<span class="input-group-addon icon-ellipsis" href="javascript://" style="cursor:pointer" onClick="plaka_ac();"></span>
						</div>
					</div>
				</td>
				<td>
					<div class="form-group">
						<input type="hidden" name="old_brand_type_id" id="old_brand_type_id" value="#old_brand_type_id#">
						<input type="text" name="old_brand_name" id="old_brand_name" value="#old_brand_name# - #old_brand_type_name#" readonly="yes">
					</div>
				</td>
				<td>
					<div class="form-group">
						<select name="old_make_year" id="old_make_year">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
							<cfloop from="#yil#" to="1970" index="i" step="-1">
								<option value="#i#" <cfif i eq old_make_year>selected</cfif>>#i#</option>
							</cfloop>
						</select>
					</div>
				</td>
				<cfset x = assetp_catid>
				<td>
					<div class="form-group">
						<select name="new_assetp_catid" id="new_assetp_catid">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfloop query="get_assetp_cats">
								<option value="#get_assetp_cats.assetp_catid#" <cfif get_assetp_cats.assetp_catid eq x>selected</cfif>>#get_assetp_cats.assetp_cat#</option>
							</cfloop>
						</select>
					</div>
				</td>
				<cfset y = usage_purpose_id>
				<td>
					<div class="form-group">
						<select name="new_usage_purpose_id" id="new_usage_purpose_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfloop query="get_usage_purpose">
								<option value="#get_usage_purpose.usage_purpose_id#" <cfif y eq get_usage_purpose.usage_purpose_id>selected</cfif>>#get_usage_purpose.usage_purpose#</option>
							</cfloop>
						</select>
					</div>
				</td>
				<td>
					<div class="form-group">
						<div class="input-group">
							<input type="hidden" name="new_brand_type_id" id="new_brand_type_id" value="#brand_type_id#">
							<input type="text" name="new_brand_name" id="new_brand_name" value="#brand_name# - #brand_type_name#" readonly="yes">
							<span class="input-group-addon icon-ellipsis" href="javaScript://" onClick="pencere_ac();"></span>
						</div>
					</div>
				</td>
				<td>
					<div class="form-group">
						<select name="new_make_year" id="new_make_year">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
							<cfloop from="#yil#" to="1970" index="i" step="-1">
								<option value="#i#" <cfif i eq make_year>selected</cfif>>#i#</option>
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
