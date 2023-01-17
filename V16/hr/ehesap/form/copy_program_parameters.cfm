<cfset attributes.base_parameter_id="">
<cfset attributes.parameter_name="">
<cfset attributes.startdate="">
<cfset attributes.finishdate="">
<cfif isdefined("attributes.parameter_id")>
	<cfquery name="get_program_parameters" datasource="#dsn#">
		SELECT 
            SSK_DAYS_WORK_DAYS, 
            FULL_DAY, 
            SSK_31_DAYS,
            STAMP_TAX_BINDE, 
            DENUNCIATION_1_LOW,
            DENUNCIATION_1_HIGH, 
            DENUNCIATION_2_LOW,
            DENUNCIATION_2_HIGH,
            DENUNCIATION_3_LOW,
            DENUNCIATION_3_HIGH,
            DENUNCIATION_4_LOW,
            DENUNCIATION_4_HIGH,
            DENUNCIATION_1,
            DENUNCIATION_2,
            DENUNCIATION_3, 
            DENUNCIATION_4,
            OVERTIME_YEARLY_HOURS,
            OVERTIME_HOURS, 
            EX_TIME_PERCENT,
            EX_TIME_LIMIT,
            EX_TIME_PERCENT_HIGH,
            USE_WORKTIMES,
            SAKAT_ALT, 
            SAKAT_PERCENT,
            ESKI_HUKUMLU_PERCENT, 
            TEROR_MAGDURU_PERCENT, 
            PARAMETER_ID,
            YEARLY_PAYMENT_REQ_LIMIT,
            YEARLY_PAYMENT_REQ_COUNT,
            STARTDATE,
            FINISHDATE,
            CAST_STYLE, 
            WEEKEND_MULTIPLIER,
            OFFICIAL_MULTIPLIER, 
            EXTRA_TIME_STYLE, 
            IS_AVANS_OFF,
            UNPAID_PERMISSION_TODROP_THIRTY,
            EMPLOYMENT_CONTINUE_TIME,
            EMPLOYMENT_START_DATE, 
             UPDATE_DATE,
            UPDATE_IP,
            UPDATE_EMP,
            RECORD_DATE,
            RECORD_IP,
            RECORD_EMP,
            IS_AGI_PAY,
            PARAMETER_NAME,
            GROSS_COUNT_TYPE,
            IS_SURELI_IS_AKDI_OFF,
            FINISH_DATE_COUNT_TYPE,
            IS_ADD_VIRTUAL_ALL, 
            COMPANY_ID,
            ACCOUNT_CODE, 
            ACCOUNT_NAME,
            CONSUMER_ID,
            ACC_TYPE_ID, 
            LIMIT_PAYMENT_REQUEST,
            NIGHT_MULTIPLIER, 
            TAX_ACCOUNT_STYLE,
            OFFTIME_COUNT_TYPE,
            DENUNCIATION_5_LOW,
            DENUNCIATION_5_HIGH,
            DENUNCIATION_6_LOW,
            DENUNCIATION_6_HIGH, 
            DENUNCIATION_5, 
            DENUNCIATION_6,
            <!---Muzaffer Bas İmbat Fazla Mesai Tipleri--->
			WEEKEND_DAY_MULTIPLIER,
			AKDI_DAY_MULTIPLIER,
			OFFICIAL_DAY_MULTIPLIER,
			ARAFE_DAY_MULTIPLIER,
			DINI_DAY_MULTIPLIER
			<!---Muzaffer Bas İmbat Fazla Mesai Tipleri---> 
        FROM 
	        SETUP_PROGRAM_PARAMETERS 
        WHERE 
        	PARAMETER_ID = #attributes.parameter_id#
	</cfquery>
	<cfset attributes.parameter_name="#get_program_parameters.parameter_name#">
		<cfset attributes.startdate="#dateformat(get_program_parameters.startdate,dateformat_style)#">
		<cfset attributes.finishdate="#dateformat(get_program_parameters.finishdate,dateformat_style)#">
<cfelse>
	<cfset attributes.parameter_id="">
</cfif>
<cf_catalystHeader>
	<cfform name="form_add" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_copy_program_parameters">
    	<input type="hidden" name="parameter_id" id="parameter_id" value="<cfoutput>#attributes.parameter_id#</cfoutput>"/>
        <div class="row">
        	<div class="col col-12 uniqueRow">
            	<div class="row formContent">
                	<div class="row" type="row">
                    	<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                        	<div class="form-group" id="item-parameter_name">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="58233.Tanım"></label>
                                <div class="col col-9 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="54327.Tanım Girmelisiniz">!</cfsavecontent>
                                	<cfinput type="text" name="parameter_name" value="#attributes.parameter_name#" required="yes" message="#message#" maxlength="100" style="width:175px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-date">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="58690.Tarih Aralığı"></label>
                                <div class="col col-9 col-xs-12">
                                	<div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlama Tarihi girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="startdate" style="width:65px;" validate="#validate_style#" required="yes" message="#message#" value="#attributes.startdate#"> 
                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                                		<span class="input-group-addon no-bg"></span>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'></cfsavecontent>
										<cfinput type="text" name="finishdate" style="width:65px;" validate="#validate_style#" required="yes" message="#message#" value="#attributes.finishdate#"> 
                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                                	</div>
                                </div>
							</div>
                        </div>
                    </div>
                    <div class="row formContentFooter">
                    	<div class="col col-12">
                        	<cf_workcube_buttons is_upd='0'>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</cfform>