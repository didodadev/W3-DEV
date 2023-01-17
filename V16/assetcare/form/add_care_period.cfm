<!---BU SAYFA HEM POPUP HEM BASKET OLARAK ÇAĞRILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cf_xml_page_edit fuseact="assetcare.form_add_care_period">
<cfinclude template="../form/care_period_options.cfm">
<cfif isdefined("attributes.failure_id")>
    <cfquery name="GET_ASSET_FAILURE" datasource="#DSN#">
        SELECT 
            ASSET_FAILURE_NOTICE.STATION_ID,
            ASSET_FAILURE_NOTICE.ASSET_CARE_ID,
            ASSET_P.ASSETP_ID,
            ASSET_CARE_CAT.ASSET_CARE
        FROM
            ASSET_FAILURE_NOTICE,
            ASSET_P,
            ASSET_CARE_CAT
        WHERE
            FAILURE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.failure_id#"> AND
            ASSET_P.ASSETP_ID = ASSET_FAILURE_NOTICE.ASSETP_ID AND
            ASSET_FAILURE_NOTICE.ASSET_CARE_ID = ASSET_CARE_CAT.ASSET_CARE_ID
    </cfquery>
	<cfif len(get_asset_failure.assetp_id)>
        <cfquery name="GET_ASSETP" datasource="#DSN#">
            SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset_failure.assetp_id#"> 
        </cfquery>
    </cfif>
    <cfif len(get_asset_failure.asset_care_id)>
        <cfquery name="GET_CARE" datasource="#DSN#">
            SELECT 
                CS.OUR_COMPANY_ID,
                ACC.ASSET_CARE,
                CS.CARE_STATE_ID
            FROM
                CARE_STATES CS,
                ASSET_CARE_CAT ACC
            WHERE
                ACC.ASSET_CARE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset_failure.asset_care_id#"> AND
                CS.CARE_ID = ACC.ASSET_CARE_ID AND
                CS.CARE_STATE_ID = ACC.ASSET_CARE_ID
        </cfquery>
    </cfif>
</cfif>
<cf_catalystHeader>
<div class="col col-12">
<form name="add_care" id="add_care" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.emtypopup_add_care_period" onsubmit="return unformat_fields();">
	<cf_box>
		<cf_box_elements>
			<input name="is_detail" id="is_detail" type="hidden" value="1">
			<cfif isDefined("attributes.failure_id")>
				<input name="is_from_accident" id="is_from_accident" type="hidden" value="1">
				<input name="failure_id" id="failure_id" type="hidden" value="<cfif isdefined("attributes.failure_id")><cfoutput>#attributes.failure_id#</cfoutput></cfif>">
				<input name="accident_id" id="accident_id" type="hidden" value="<cfif isdefined("attributes.accident_id")><cfoutput>#attributes.accident_id#</cfoutput></cfif>">
			</cfif>
			<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-assetp_name">
					<label class="col col-4 col-xs-12">
						<cfif xml_add_care_asset eq 0>
							<cf_get_lang_main no='8.Varlıklar'>
							<cfelseif xml_add_care_asset eq 1>
							<cf_get_lang no='3.IT Varlıklar'>
							<cfelseif xml_add_care_asset eq 2>
							<cf_get_lang_main no='2207.Fiziki Varlıklar'>
							<cfelseif xml_add_care_asset eq 3>
							<cf_get_lang_main no='2.Araçlar'>
						</cfif>
					</label>
					<div class="col col-8 col-xs-12">
						<cfif isdefined("attributes.failure_id")>
								<cf_wrkAssetp asset_id="#get_asset_failure.assetp_id#" fieldId='assetp_id' fieldName='assetp_name' form_name='add_care' xmlvalue='#xml_add_care_asset#'>
						<cfelse>
							<cf_wrkAssetp fieldId='assetp_id' fieldName='assetp_name' form_name='add_care' xmlvalue='#xml_add_care_asset#' width='150'>
						</cfif>
					</div>
				</div>
				<div class="form-group" id="item-care_type">
					<label class="col col-6 col-xs-12"><cf_get_lang no='42.Bakım Tipi'></label>
					<div class="col col-12 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="care_type_id" id="care_type_id" value="<cfif isdefined("attributes.failure_id")><cfoutput>#get_asset_failure.asset_care_id#</cfoutput></cfif>">
							<input type="text" name="care_type" id="care_type" value="<cfif isdefined("attributes.failure_id")><cfoutput>#get_asset_failure.asset_care#</cfoutput></cfif>">
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang no='42.Bakım Tipi'>" onclick="pencere_ac();"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-care_date">
					<label class="col col-6 col-xs-12"><cf_get_lang_main no='330.Tarih'></label>
					<div class="col col-12 col-xs-12">
						<div class="input-group">
							<input  type="text" name="care_date" id="care_date" value="">
							<span class="input-group-addon"><cf_wrk_date_image date_field="care_date"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-official_emp">
					<label class="col col-6 col-xs-12"><cf_get_lang_main no='157.Görevli'></label>
					<div class="col col-12 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="official_emp_id" id="official_emp_id" value="">
							<input type="text" name="official_emp" id="official_emp" value="" onFocus="AutoComplete_Create('official_emp','MEMBER_NAME,MEMBER_ID','MEMBER_NAME,MEMBER_ID','get_member_autocomplete','3','EMPLOYEE_ID','official_emp_id','','3','125');" autocomplete="off">
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang_main no='157.Görevli'>" onClick="openBoxDraggable ('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=add_care.official_emp_id&field_name=add_care.official_emp');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-care_type_period">
					<label class="col col-6 col-xs-12"><cf_get_lang no='81.Periyot'><cf_get_lang_main no='1716.Süre'></label>
					<div class="col col-12 col-xs-12">
						<select name="care_type_period" id="care_type_period">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfloop array = "#period_list#" index="my_period_data">
								<cfoutput>
									<option value="#my_period_data[1]#">#my_period_data[2]#</option>
								</cfoutput>
							</cfloop>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-care_km_period">
					<label class="col col-6 col-xs-12"><cf_get_lang no='81.Periyot'> / <cf_get_lang no='286.KM'></label>
					<div class="col col-12 col-xs-12">
						<input name="care_km_period" type="text" id="care_km_period" value="" onKeyUp="FormatCurrency(this,event);" maxlength="50">
					</div>
				</div>
				<div class="form-group" id="item-gun_saat_dakika">
					<label class="col col-6 col-xs-12"><cf_get_lang_main no='1716.Süre'></label>
					<cfoutput>
						<div class="col col-3 col-xs-12">
							<select name="gun" id="gun">
								<option value=""><cf_get_lang_main no='78.Gün'></option>
								<cfloop from="1" to="31" index="i">
									<option value="#i#"><cfoutput>#NumberFormat(i,'00')#</cfoutput></option>
								</cfloop>
							</select>
						</div>
						<div class="col col-6 col-xs-12">
							<select name="saat" id="saat">
								<option value=""><cf_get_lang_main no='79.Saat'></option>
								<cfloop from="0" to="23" index="i">
									<option value="#i#"><cfoutput>#NumberFormat(i,'00')#</cfoutput></option>
								</cfloop>
							</select>
						</div>
						<div class="col col-3 col-xs-12">
							<select name="dakika" id="dakika" style="width:44px">
								<option value=""><cf_get_lang_main no='1415.Dk'></option>
								<cfloop from="0" to="55" index="i" step="5">
									<option value="#i#">#NumberFormat(i,'00')#</option>
								</cfloop>
							</select>
						</div>
					</cfoutput>
				</div>
			</div>
			<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<input type="hidden" name="station_id" id="station_id" value="<cfif isdefined("attributes.failure_id") and len(get_asset_failure.station_id)><cfoutput>#get_asset_failure.station_id#</cfoutput></cfif>">
				<input type="hidden" name="station_company_id" id="station_company_id" value="<cfoutput>#session.ep.company_id#</cfoutput>">
				<div class="form-group" id="item_place">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60371.Mekan'></label>
					<div class="col col-8 col-xs-12">
						<input name="place" id="place" type="text">
					</div>
				</div>
				<div class="form-group" id="item-station_name">
					<label class="col col-4 col-xs-12"><cf_get_lang_main no ='1422.İstasyon'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif isdefined('get_asset_failure.station_id') AND LEN(get_asset_failure.station_id) AND  isdefined("attributes.failure_id")>
								<cfset new_dsn3 = "#dsn#_#session.ep.company_id#">
								<cfquery name="GET_STATION" datasource="#new_dsn3#">
									SELECT STATION_ID, STATION_NAME FROM WORKSTATIONS WHERE STATION_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset_failure.station_id#">
								</cfquery>
								<input type="text" name="station_name" id="station_name" value="<cfoutput>#GET_STATION.STATION_NAME#</cfoutput>">
							<cfelse>
								<input type="text" name="station_name" id="station_name" value="">
							</cfif>
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang_main no ='1422.İstasyon'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=prod.popup_list_workstation&field_name=add_care.station_name&field_id=add_care.station_id</cfoutput>')"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-surec">
					<label class="col col-6 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
					<div class="col col-12 col-xs-12">
						<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
					</div>
				</div>
				<div class="form-group" id="item-">
					<label class="col col-6 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
					<div class="col col-12 col-xs-12">
						<textarea name="detail" id="detail"></textarea>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' type_format="1" add_function='kontrol()'>
		</cf_box_footer>
	</cf_box>
</form>
</div>
<script type="text/javascript">
	function unformat_fields()
	{
		if(document.add_care.care_km_period != undefined) document.add_care.care_km_period.value = filterNum(document.add_care.care_km_period.value);
		return process_cat_control();
	}
	function kontrol()
	{
		if(document.add_care.assetp_name.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1655.Varlık'>!");
			return false;
		}
		if(document.add_care.care_type_id.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='42.Bakım Tipi'>!");
			return false;
		}
		if(document.add_care.care_date.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='41.Bakım Tarihi'>!");
			return false;
		}
		if(!CheckEurodate(document.add_care.care_date.value,"<cf_get_lang no='41.Bakım Tarihi'>"))
		{
			return false;
		}
	}
	
	function pencere_ac()
	{
		if (document.add_care.assetp_id == undefined || document.add_care.assetp_id.value == "")
			alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no='73.öncelik'>-<cf_get_lang_main no='1068.Araç'>");
		else
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_care_type&field_id=add_care.care_type_id&field_name=add_care.care_type&asset_id=' + add_care.assetp_id.value);
	}
</script>
	