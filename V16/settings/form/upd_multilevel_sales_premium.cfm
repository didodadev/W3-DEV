<cfquery name="GET_MULTI_PREMIUM" datasource="#dsn3#">
	SELECT 
	    MULTILEVEL_PREMIUM_ID, 
        MULTILEVEL_PREMIUM_NAME, 
        START_DATE, 
        FINISH_DATE, 
        MULTILEVEL_PREMIUM_1_RATE, 
        MULTILEVEL_PREMIUM_2_RATE, 
        MULTILEVEL_PREMIUM_3_RATE, 
        MULTILEVEL_PREMIUM_4_RATE, 
        MULTILEVEL_PREMIUM_5_RATE, 
        MULTILEVEL_PREMIUM_6_RATE, 
        MULTILEVEL_PREMIUM_7_RATE, 
        MULTILEVEL_PREMIUM_8_RATE, 
        MULTILEVEL_PREMIUM_9_RATE, 
        MULTILEVEL_PREMIUM_10_RATE, 
        SALES_EMPLOYEE_PREMIUM_RATE, 
        SALES_TEAM_PREMIUM_RATE, 
        SALES_ZONE_PREMIUM_RATE, 
        RECORD_EMP,
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP 
    FROM 
    	MULTILEVEL_SALES_PREMIUM 
    WHERE 
	    MULTILEVEL_PREMIUM_ID = #attributes.premium_id#
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="upd_sales_premium" action="#request.self#?fuseaction=settings.emptypopup_upd_multilevel_sales_premium" method="post">
            <cfinput name="premium_id" value="#attributes.premium_id#" type="hidden">
            <cf_box_elements vertical="1">
				<div class="col col-3 col-md-3 col-sm-4 col-xs-12">
                    <div class="form-group">
						<label><cf_get_lang_main no='68.Başlık'>*</label>
						<cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık Giriniz'></cfsavecontent>
                        <cfinput name="multilevel_premium_name" message="#message#" class="boxtext" required="yes" value="#GET_MULTI_PREMIUM.MULTILEVEL_PREMIUM_NAME#">
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='243.Başlama'>*</label>
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='326.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" maxlength="10" name="start_date" value="#dateformat(GET_MULTI_PREMIUM.START_DATE,dateformat_style)#" class="box" required="yes" message="#message#" validate="#validate_style#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
						</div>
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='288.Bitiş'>*</label>
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" maxlength="10" name="finish_date" value="#dateformat(GET_MULTI_PREMIUM.FINISH_DATE,dateformat_style)#" class="box" required="yes" message="#message#" validate="#validate_style#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
					</div>
					<div class="form-group">
                        <label><cf_get_lang_main no='164.Çalışan'></label>
                        <cfinput name="sales_employee_multilevel_premium" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="#tlformat(GET_MULTI_PREMIUM.SALES_EMPLOYEE_PREMIUM_RATE,2)#">
                    </div>
					<div class="form-group">
                        <label><cf_get_lang_main no='1099.Takım'></label>
                        <cfinput name="sales_team_multilevel_premium" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="#tlformat(GET_MULTI_PREMIUM.SALES_TEAM_PREMIUM_RATE,2)#">
                    </div>
					<div class="form-group">
                        <label><cf_get_lang_main no='580.Bölge'></label>
                        <cfinput name="sales_zone_multilevel_premium" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="#tlformat(GET_MULTI_PREMIUM.SALES_ZONE_PREMIUM_RATE,2)#">
                    </div>		
				</div>
                <div class="col col-2 col-md-2 col-sm-4 col-xs-12">
					<div class="form-group">
                        <label><cf_get_lang dictionary_id='58710.Kademe'>1 %</label>
                        <cfinput name="multilevel_premium_1" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="#tlformat(GET_MULTI_PREMIUM.MULTILEVEL_PREMIUM_1_RATE)#">
                    </div>
					<div class="form-group">
                        <label><cf_get_lang dictionary_id='58710.Kademe'>2 %</label>
                        <cfinput name="multilevel_premium_2" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="#tlformat(GET_MULTI_PREMIUM.MULTILEVEL_PREMIUM_2_RATE)#">
                    </div>
					<div class="form-group">
                        <label><cf_get_lang dictionary_id='58710.Kademe'>3 %</label>
                        <cfinput name="multilevel_premium_3" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="#tlformat(GET_MULTI_PREMIUM.MULTILEVEL_PREMIUM_3_RATE)#">
                    </div>
					<div class="form-group">
                        <label><cf_get_lang dictionary_id='58710.Kademe'>4 %</label>
                        <cfinput name="multilevel_premium_4" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="#tlformat(GET_MULTI_PREMIUM.MULTILEVEL_PREMIUM_4_RATE)#">
                    </div>
					<div class="form-group">
                        <label><cf_get_lang dictionary_id='58710.Kademe'>5 %</label>
                        <cfinput name="multilevel_premium_5" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="#tlformat(GET_MULTI_PREMIUM.MULTILEVEL_PREMIUM_5_RATE)#">
                    </div>		
				</div>
				<div class="col col-2 col-md-2 col-sm-4 col-xs-12">
					<div class="form-group">
                        <label><cf_get_lang dictionary_id='58710.Kademe'>6 %</label>
                        <cfinput name="multilevel_premium_6" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="#tlformat(GET_MULTI_PREMIUM.MULTILEVEL_PREMIUM_6_RATE)#">
                    </div>
					<div class="form-group">
                        <label><cf_get_lang dictionary_id='58710.Kademe'>7 %</label>
                        <cfinput name="multilevel_premium_7" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="#tlformat(GET_MULTI_PREMIUM.MULTILEVEL_PREMIUM_7_RATE)#">
                    </div>
					<div class="form-group">
                        <label><cf_get_lang dictionary_id='58710.Kademe'>8 %</label>
                        <cfinput name="multilevel_premium_8" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="#tlformat(GET_MULTI_PREMIUM.MULTILEVEL_PREMIUM_8_RATE)#">
                    </div>
					<div class="form-group">
                        <label><cf_get_lang dictionary_id='58710.Kademe'>9 %</label>
                        <cfinput name="multilevel_premium_9" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="#tlformat(GET_MULTI_PREMIUM.MULTILEVEL_PREMIUM_9_RATE)#">
                    </div>
					<div class="form-group">
                        <label><cf_get_lang dictionary_id='58710.Kademe'>10 %</label>
                        <cfinput name="multilevel_premium_10" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="#tlformat(GET_MULTI_PREMIUM.MULTILEVEL_PREMIUM_10_RATE)#">
                    </div>
				</div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_record_info query_name="GET_MULTI_PREMIUM">
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_workcube_buttons is_upd='1' is_cancel='0' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_multilevel_sales_premium&premium_id=#attributes.premium_id#'  add_function="unformat_fields()">
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function unformat_fields()
	{
		upd_sales_premium.multilevel_premium_1.value = filterNum(upd_sales_premium.multilevel_premium_1.value,4);
		upd_sales_premium.multilevel_premium_2.value = filterNum(upd_sales_premium.multilevel_premium_2.value,4);
		upd_sales_premium.multilevel_premium_3.value = filterNum(upd_sales_premium.multilevel_premium_3.value,4);
		upd_sales_premium.multilevel_premium_4.value = filterNum(upd_sales_premium.multilevel_premium_4.value,4);
		upd_sales_premium.multilevel_premium_5.value = filterNum(upd_sales_premium.multilevel_premium_5.value,4);
		upd_sales_premium.multilevel_premium_6.value = filterNum(upd_sales_premium.multilevel_premium_6.value,4);
		upd_sales_premium.multilevel_premium_7.value = filterNum(upd_sales_premium.multilevel_premium_7.value,4);
		upd_sales_premium.multilevel_premium_8.value = filterNum(upd_sales_premium.multilevel_premium_8.value,4);
		upd_sales_premium.multilevel_premium_9.value = filterNum(upd_sales_premium.multilevel_premium_9.value,4);
		upd_sales_premium.multilevel_premium_10.value = filterNum(upd_sales_premium.multilevel_premium_10.value,4);
		upd_sales_premium.sales_employee_multilevel_premium.value = filterNum(upd_sales_premium.sales_employee_multilevel_premium.value,4);
		upd_sales_premium.sales_team_multilevel_premium.value = filterNum(upd_sales_premium.sales_team_multilevel_premium.value,4);
		upd_sales_premium.sales_zone_multilevel_premium.value = filterNum(upd_sales_premium.sales_zone_multilevel_premium.value,4);
	}
</script>

