<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT 
    	CITY_ID, 
        CITY_NAME, 
        PHONE_CODE, 
        PLATE_CODE, 
        COUNTRY_ID, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        PRIORITY
    FROM 
    	SETUP_CITY 
    WHERE 
	    CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">
</cfquery>
<div class="col col-12 col-md-12 col-xs-12 col-sm-12">
    <cf_box title="#getLang('','İl Güncelle	','43416')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
         <cfform name="upd_city" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_city">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <input name="city_id" id="city_id" type="hidden" value="<cfoutput>#get_city.city_id#</cfoutput>">
                    <div class="form-group">
                        <label class="col col-6"><cf_get_lang dictionary_id='58219.Ülke'>*</label>
                        <div class="col col-6 col-xs-12">
                            <select name="country" id="country">
                                <cfoutput query="get_country">
                                    <option value="#country_id#" <cfif get_city.country_id eq country_id> selected</cfif>>#country_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6"><cf_get_lang dictionary_id='43364.İl Adı'>*</label>
                        <div class="col col-6 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="city_name" value="#trim(get_city.city_name)#" required="yes" message="#getLang('','.İl Adı Girmelisiniz','43365')#" maxlength="30">
                                <span class="input-group-addon">
                                    <cf_language_info 
                                    table_name="SETUP_CITY" 
                                    column_name="CITY_NAME" 
                                    column_id_value="#attributes.city_id#" 
                                    maxlength="500" 
                                    datasource="#dsn#" 
                                    column_id="CITY_ID" 
                                    control_type="0">
                                </span> 
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6"><cf_get_lang dictionary_id='29429.Tel Kodu'></label>
                        <div class="col col-6 col-xs-12">
                            <cfinput type="text" name="phone_code" value="#trim(get_city.phone_code)#" maxlength="5" onkeyup="isNumber(this);" onblur='isNumber(this);'>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6"><cf_get_lang dictionary_id='43119.Plaka Kodu'></label>
                        <div class="col col-6 col-xs-12">
                            <cfinput type="text" name="plate_code" value="#trim(get_city.plate_code)#"  onKeyUp="isNumber(this);" maxlength="2">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-6"><cf_get_lang dictionary_id='57485.Öncelik'></label>
                        <div class="col col-6 col-xs-12">
                            <cfinput name="priority" value="#get_city.priority#" validate="integer" maxlength="2" onKeyUp="isNumber(this);">
                        </div>
                    </div>
                
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12 text-left">
                <cf_record_info query_name='get_city'>
            </div>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_workcube_buttons is_upd='1' is_delete='0'>
            </div>
        </cf_box_footer> 
    </cfform>
    </cf_box>
</div>

