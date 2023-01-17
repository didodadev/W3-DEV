<cf_xml_page_edit fuseact="settings.popup_form_add_county">
<cfquery name="GET_COUNTY" datasource="#DSN#"> 
	SELECT 
    	COUNTY_ID, 
        COUNTY_NAME, 
        CITY, 
        SPECIAL_STATE_CAT_ID, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_COUNTY 
    WHERE 
    	COUNTY_ID = #attributes.county_id#
</cfquery>
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID,CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="GET_SPECIAL_STATE" datasource="#DSN#">
	SELECT
		SPECIAL_STATE_CAT_ID,
		SPECIAL_STATE_CAT 
	FROM 
		SETUP_SPECIAL_STATE_CAT 
	ORDER BY 
		SPECIAL_STATE_CAT
</cfquery>
<div class="col col-12 col-md-12 col-xs-12 col-sm-12">
    <cf_box title="#getLang('','İlçe Ekle','43480')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_county" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_county">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<input type="hidden" name="county_id" id="county_id" value="<cfoutput>#attributes.county_id#</cfoutput>">
					<div class="form-group">
						<label class="col col-6"><cf_get_lang dictionary_id='43364.İl Adı'></label>
						<div class="col col-6">
							<select name="city_id" id="city_id" >
								<cfoutput query="get_city">
									<option value="#city_id#" <cfif city_id eq attributes.cit_id> selected</cfif>>#city_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-6"><cf_get_lang dictionary_id='43481.İlçe Adı'>*</label>
						<div class="col col-6">
							<cfsavecontent variable="message"><cf_get_lang no ='1499.İlçe Adı Girmelisiniz'> !</cfsavecontent>
							<cfinput type="text" name="county_name"  value="#trim(get_county.county_name)#" maxlength="50" required="Yes" message="#message#">
							<cf_language_info 
								table_name="SETUP_COUNTY" 
								column_name="COUNTY_NAME" 
								column_id_value="#attributes.county_id#" 
								maxlength="500" 
								datasource="#dsn#" 
								column_id="COUNTY_ID" 
								control_type="0">
						</div>
					</div>
					<cfif xml_dsp_special_state>
						<div class="form-group">
							<label class="col col-6"><cf_get_lang dictionary_id='34141.Özel Durum'></label>
							<div class="col col-6">
								<select name="special_state" id="special_state" >
								<option value=""><cf_get_lang_main no='322.Seciniz'></option>
								<cfoutput query="get_special_state">
									<option value="#special_state_cat_id#" <cfif get_county.special_state_cat_id eq special_state_cat_id> selected</cfif>>#special_state_cat#</option>
								</cfoutput>
								</select>
							</div>
						</div>
					</cfif>	
				</div>
            </cf_box_elements>		
			<cf_box_footer>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12 text-left">
					<cf_record_info query_name='get_county'>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12 text-left">
					<cf_workcube_buttons is_upd='1' is_delete='0'>
				</div>
			</cf_box_footer>
		</cfform>
    </cf_box>
</div>
		
