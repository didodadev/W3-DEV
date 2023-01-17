<cf_xml_page_edit fuseact="settings.popup_form_upd_district" is_multi_page="1">
<cfquery name="get_info" datasource="#dsn#">
	SELECT 
		SD.*,
		SC.CITY,
		(SELECT IMS_CODE FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = SD.IMS_CODE_ID) IMS_CODE
	FROM 
		SETUP_DISTRICT SD,
		SETUP_COUNTY SC
	WHERE
		SD.DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.district_id#">
		AND SC.COUNTY_ID = SD.COUNTY_ID
</cfquery>
<cfquery name="get_city" datasource="#dsn#">
	SELECT * FROM SETUP_CITY
</cfquery>
<cfquery name="get_county" datasource="#dsn#">
	SELECT * FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_info.city#">
</cfquery>
<div class="col col-12 col-md-12 col-xs-12 col-sm-12">
	<cf_box title="#getLang('','Mahalle Güncelle','43815')#" nofooter="1" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_quarter" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_district">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<input type="hidden" name="district_id" id="district_id" value="<cfoutput>#get_info.district_id#</cfoutput>">
					<div class="form-group">
						<label class="col col-6"><cf_get_lang dictionary_id='58608.İl'></label>
						<select name="city_id" id="city_id" onChange="LoadCounty(this.value,'county_id')">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_city">
								<option value="#city_id#" <cfif city_id eq get_info.city>selected</cfif>>#city_name#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<label class="col col-6"><cf_get_lang dictionary_id='58638.İlçe'>*</label>
						<cf_wrk_places form_name='add_quarter' place_name='work_county' place_id='county_id' is_type='3' id_name='city_id' is_requisite='1' requisite_text="#getLang('','İl Seciniz','31644')#">
						<select name="county_id" id="county_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_county">
								<option value="#county_id#" <cfif county_id eq get_info.county_id>selected</cfif>>#county_name#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<label class="col col-6"><cf_get_lang dictionary_id='43812.Mahalle Adı'>*</label>
						<cfinput type="text" name="district_name" required="Yes"message="#getLang('','.Mahalle Adı Girmelisiniz','43813')#" maxlength="50" value="#get_info.district_name#">
					</div>
					<div class="form-group">
						<label class="col col-6"><cf_get_lang dictionary_id='58132.Semt'></label>
						<input type="text" name="part_name" id="part_name" value="<cfoutput>#get_info.part_name#</cfoutput>" />
					</div>
					<div class="form-group">
						<label class="col col-6"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
						<input type="text" name="post_code" id="post_code" onkeyup="isNumber(this)" value="<cfoutput>#get_info.post_code#</cfoutput>">
					</div>
					<cfif xml_ims_code eq 1>
						<div class="form-group">
							<label class="col col-6"><cf_get_lang dictionary_id='30678.IMS Bölge Kodu'></label>
							<input type="hidden" name="old_ims_code" id="old_ims_code" value="<cfoutput>#get_info.ims_code#</cfoutput>" />
							<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#get_info.ims_code_id#</cfoutput>" />
							<cfinput type="Text" name="ims_code" maxlength="50" value="#get_info.ims_code#">
							<a href="javascript://"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.</cfoutput>popup_list_ims_codes&field_ims_code=ims_code&field_ims_code_id=ims_code_id&field_old_ims_code=old_ims_code');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a>
						</div>
					</cfif>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12 text-left">
					<cf_record_info query_name='get_info'>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12 text-left">
					<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if(document.add_quarter.county_id.value == "")
		{
			alert("<cf_get_lang dictionary_id='32303.İlçe Seçmelisiniz'>!");
			return false;
		}
		else
			return true;
	}
</script>
