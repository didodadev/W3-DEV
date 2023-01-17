<!--- copy_program_parameters.cfm --->
<!--- Parametre kopyalama işlemleri --->
<!--- Kopyalama formundan ad ve tarih değerlerini, --->
<!--- kaynak satırdan da diğer verileri alıp yeni bir kayıt oluşturuyor. --->
<cf_date tarih=attributes.startdate>
<cf_date tarih=attributes.finishdate>
<!--- <cfquery name="get_olds" datasource="#dsn#">
	SELECT 
		PARAMETER_ID 
	FROM 
		SETUP_PROGRAM_PARAMETERS 
	WHERE 
		STARTDATE <= #attributes.startdate# AND 
		FINISHDATE >= #attributes.startdate# 
</cfquery>
<cfif get_olds.recordcount>
	<script type="text/javascript">
		alert('Aynı Tarihler Arasında ve Aynı Şube/Grup Yetkisi ile 2 Akış Paratmetresi Giremezsiniz!');
		history.back();
	</script>
	<cfabort>
</cfif> --->
<CFTRANSACTION>
	<cfquery name="BASE_RECORD" datasource="#DSN#">
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
            IS_SGK_KONTROL, 
            COMPANY_ID, 
            ACCOUNT_CODE, 
            ACCOUNT_NAME, 
            CONSUMER_ID, 
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
			BRANCH_IDS,
			GROUP_IDS
        FROM 
    	    SETUP_PROGRAM_PARAMETERS 
        WHERE 
	        PARAMETER_ID = #attributes.parameter_id#
	</cfquery>
	<cfquery name="add_query" datasource="#dsn#">
		INSERT INTO SETUP_PROGRAM_PARAMETERS
		(
			PARAMETER_NAME,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP,
			STARTDATE,
			FINISHDATE,
			GROSS_COUNT_TYPE,
			CAST_STYLE,
			EXTRA_TIME_STYLE,
			SSK_DAYS_WORK_DAYS,
			FULL_DAY,
			SSK_31_DAYS,
			STAMP_TAX_BINDE,
			WEEKEND_MULTIPLIER,
			OFFICIAL_MULTIPLIER,
			DENUNCIATION_1_LOW,
			DENUNCIATION_1_HIGH,
			DENUNCIATION_2_LOW,
			DENUNCIATION_2_HIGH,
			DENUNCIATION_3_LOW,
			DENUNCIATION_3_HIGH,
			DENUNCIATION_4_LOW,
			DENUNCIATION_4_HIGH,
			DENUNCIATION_5_LOW,
			DENUNCIATION_5_HIGH,
			DENUNCIATION_6_LOW,
			DENUNCIATION_6_HIGH,
			DENUNCIATION_1,
			DENUNCIATION_2,
			DENUNCIATION_3,
			DENUNCIATION_4,
			DENUNCIATION_5,
			DENUNCIATION_6,
			OVERTIME_YEARLY_HOURS,
			OVERTIME_HOURS,
			EX_TIME_PERCENT,
			EX_TIME_LIMIT,
			EX_TIME_PERCENT_HIGH,
			SAKAT_ALT,
			SAKAT_PERCENT,
			ESKI_HUKUMLU_PERCENT,
			TEROR_MAGDURU_PERCENT,
			YEARLY_PAYMENT_REQ_LIMIT,
			YEARLY_PAYMENT_REQ_COUNT,
			IS_AVANS_OFF,
			UNPAID_PERMISSION_TODROP_THIRTY,
			EMPLOYMENT_START_DATE,
			EMPLOYMENT_CONTINUE_TIME,
			IS_AGI_PAY,
			IS_SURELI_IS_AKDI_OFF,
			NIGHT_MULTIPLIER,
			FINISH_DATE_COUNT_TYPE,
            OFFTIME_COUNT_TYPE,
            LIMIT_PAYMENT_REQUEST,
            IS_ADD_VIRTUAL_ALL,
			IS_SGK_KONTROL,
			IS_ADD_5746_CONTROL,
			IS_ADD_4691_CONTROL,
			BRANCH_IDS,
			GROUP_IDS
		)
		SELECT
			'#attributes.parameter_name#',
			#now()#,
			'#cgi.REMOTE_ADDR#',
			'#session.ep.userid#',
			#attributes.startdate#,
			#attributes.finishdate#,
			GROSS_COUNT_TYPE,
			CAST_STYLE,
			EXTRA_TIME_STYLE,
			SSK_DAYS_WORK_DAYS,
			FULL_DAY,
			SSK_31_DAYS,
			STAMP_TAX_BINDE,
			WEEKEND_MULTIPLIER,
			OFFICIAL_MULTIPLIER,
			DENUNCIATION_1_LOW,
			DENUNCIATION_1_HIGH,
			DENUNCIATION_2_LOW,
			DENUNCIATION_2_HIGH,
			DENUNCIATION_3_LOW,
			DENUNCIATION_3_HIGH,
			DENUNCIATION_4_LOW,
			DENUNCIATION_4_HIGH,
			DENUNCIATION_5_LOW,
			DENUNCIATION_5_HIGH,
			DENUNCIATION_6_LOW,
			DENUNCIATION_6_HIGH,
			DENUNCIATION_1,
			DENUNCIATION_2,
			DENUNCIATION_3,
			DENUNCIATION_4,
			DENUNCIATION_5,
			DENUNCIATION_6,
			OVERTIME_YEARLY_HOURS,
			OVERTIME_HOURS,
			EX_TIME_PERCENT,
			EX_TIME_LIMIT,
			EX_TIME_PERCENT_HIGH,
			SAKAT_ALT,
			SAKAT_PERCENT,
			ESKI_HUKUMLU_PERCENT,
			TEROR_MAGDURU_PERCENT,
			YEARLY_PAYMENT_REQ_LIMIT,
			YEARLY_PAYMENT_REQ_COUNT,
			IS_AVANS_OFF,
			UNPAID_PERMISSION_TODROP_THIRTY,
			EMPLOYMENT_START_DATE,
			EMPLOYMENT_CONTINUE_TIME,
			IS_AGI_PAY,
			IS_SURELI_IS_AKDI_OFF,
			NIGHT_MULTIPLIER,
			FINISH_DATE_COUNT_TYPE,
            OFFTIME_COUNT_TYPE,
            LIMIT_PAYMENT_REQUEST,
            IS_ADD_VIRTUAL_ALL,
			IS_SGK_KONTROL,
			IS_ADD_5746_CONTROL,
			IS_ADD_4691_CONTROL,
			BRANCH_IDS,
			GROUP_IDS
		FROM
			SETUP_PROGRAM_PARAMETERS 
		WHERE
			PARAMETER_ID = #attributes.parameter_id#
	</cfquery>

	<cfquery name="LATEST_PARAM_ID" datasource="#DSN#">
		SELECT MAX(PARAMETER_ID) AS LAST_PARAM_ID FROM SETUP_PROGRAM_PARAMETERS
	</cfquery>
</CFTRANSACTION>
<cfset attributes.param_id = LATEST_PARAM_ID.LAST_PARAM_ID>
<cfinclude template="add_parameters_history.cfm">
<cfset attributes.actionId = LATEST_PARAM_ID.LAST_PARAM_ID>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=ehesap.list_program_parameters&event=upd&parameter_id=#LATEST_PARAM_ID.LAST_PARAM_ID#</cfoutput>"
</script>
