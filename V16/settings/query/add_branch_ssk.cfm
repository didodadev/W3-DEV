<cfif isdefined("attributes.foundation_date")>
<cf_date tarih = "attributes.foundation_date">
</cfif>
<cfif isdefined("attributes.open_date")>
<cf_date tarih = "attributes.open_date">
</cfif>
<cfif len(attributes.SSK_OFFICE) and len(attributes.SSK_NO)>
	<cfquery name="control" datasource="#dsn#">
		SELECT BRANCH_ID FROM BRANCH WHERE SSK_OFFICE = '#attributes.SSK_OFFICE#' AND SSK_NO = '#attributes.SSK_NO#'
	</cfquery>
	<cfif attributes.upd_control eq 0 and control.RECORDCOUNT>
	<cfoutput>
			<script type="text/javascript">
				alert("Aynı SSK Şube ve SSK İşyeri No ya Sahip Şube Var !  ");
				history.back();
			</script>
			<cfabort>
	</cfoutput>
	</cfif>
<cfelse>
	<script type="text/javascript">
		alert("Lütfen SSK Bilgileriniz Giriniz!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_old_ssk_info" datasource="#dsn#">
	SELECT SSK_OFFICE,SSK_NO FROM BRANCH WHERE BRANCH_ID = #attributes.BRANCH_ID#
</cfquery>

<cfquery name="upd_ssk" datasource="#dsn#">
UPDATE 
	BRANCH SET 
		SSK_OFFICE = '#attributes.SSK_OFFICE#',
		SSK_NO =  '#attributes.SSK_NO#',
		SSK_M =  <cfif isdefined("SSK_M") and len(SSK_M)>'#attributes.SSK_M#',<cfelse>NULL,</cfif>
		SSK_JOB = <cfif isdefined("SSK_JOB") and len(SSK_JOB)>'#attributes.SSK_JOB#',<cfelse>NULL,</cfif>
		SSK_BRANCH = <cfif isdefined("SSK_BRANCH") and len(SSK_BRANCH)>'#attributes.SSK_BRANCH#',<cfelse>NULL,</cfif>
		SSK_BRANCH_OLD = <cfif isdefined("SSK_BRANCH_OLD") and len(SSK_BRANCH_OLD)>'#attributes.SSK_BRANCH_OLD#',<cfelse>NULL,</cfif>
		SSK_CITY =  <cfif isdefined("SSK_CITY") and len(SSK_CITY)>'#attributes.SSK_CITY#',<cfelse>NULL,</cfif>
		SSK_CD =  <cfif isdefined("SSK_CD") and len(SSK_CD)>'#attributes.SSK_CD#',<cfelse>NULL,</cfif>
		SSK_AGENT = '#attributes.SSK_AGENT#',
		SSK_COUNTRY = <cfif isdefined("SSK_COUNTRY") and len(SSK_COUNTRY)>'#attributes.SSK_COUNTRY#',<cfelse>NULL,</cfif>
		WORK_ZONE_M = <cfif isdefined("WORK_ZONE_M") and len(WORK_ZONE_M)>'#attributes.WORK_ZONE_M#',<cfelse>NULL,</cfif>
		WORK_ZONE_JOB = <cfif isdefined("WORK_ZONE_JOB") and len(WORK_ZONE_JOB)>'#attributes.WORK_ZONE_JOB#',<cfelse>NULL,</cfif>
		WORK_ZONE_FILE = <cfif isdefined("WORK_ZONE_FILE") and len(WORK_ZONE_FILE)>'#attributes.WORK_ZONE_FILE#',<cfelse>NULL,</cfif>
		WORK_ZONE_CITY  = <cfif isdefined("WORK_ZONE_CITY") and len(WORK_ZONE_CITY)>'#attributes.WORK_ZONE_CITY#',<cfelse>NULL,</cfif>
		DANGER_DEGREE = <cfif isdefined("DANGER_DEGREE") and len(DANGER_DEGREE)>#attributes.DANGER_DEGREE#,<cfelse>NULL,</cfif>
		DANGER_DEGREE_NO = <cfif isdefined("DANGER_DEGREE_NO") and len(DANGER_DEGREE_NO)>#attributes.DANGER_DEGREE_NO#,<cfelse>NULL,</cfif>
		FOUNDATION_DATE = <cfif isdefined("attributes.foundation_date") and len(attributes.foundation_date)>#attributes.foundation_date#,<cfelse>NULL,</cfif>
		ISKUR_BRANCH_NAME = <cfif isDefined("ISKUR_BRANCH_NAME") and len(ISKUR_BRANCH_NAME)>'#ISKUR_BRANCH_NAME#',<cfelse>NULL,</cfif>
		ISKUR_BRANCH_NO = <cfif isDefined("ISKUR_BRANCH_NO") and len(ISKUR_BRANCH_NO)>'#ISKUR_BRANCH_NO#',<cfelse>NULL,</cfif>
		ISKUR_PASSWORD = <cfif isDefined("ISKUR_PASSWORD") and len(ISKUR_PASSWORD)>'#ISKUR_PASSWORD#',<cfelse>NULL,</cfif>
		ISKUR_TCKIMLIK_NO = <cfif isDefined("ISKUR_TCKIMLIK_NO") and len(ISKUR_TCKIMLIK_NO)>'#ISKUR_TCKIMLIK_NO#',<cfelse>NULL,</cfif>
		CAL_BOL_MUD_NAME = <cfif isDefined("CAL_BOL_MUD_NAME") and len(CAL_BOL_MUD_NAME)>'#CAL_BOL_MUD_NAME#',<cfelse>NULL,</cfif>
		IS_PDKS_WORK = <cfif isDefined("attributes.IS_PDKS_WORK") and len(attributes.IS_PDKS_WORK)>1,<cfelse>0,</cfif>
		IS_SAKAT_KONTROL = <cfif isDefined("attributes.IS_SAKAT_KONTROL") and len(attributes.IS_SAKAT_KONTROL)>1,<cfelse>0,</cfif>
		IS_5615 = <cfif isDefined("attributes.is_5615")>1,<cfelse>0,</cfif>
		IS_5510 = <cfif isDefined("attributes.is_5510")>1,<cfelse>0,</cfif>
		IS_5615_TAX_OFF = <cfif isDefined("attributes.IS_5615_TAX_OFF")>1,<cfelse>0,</cfif>
		REAL_WORK = <cfif isDefined("REAL_WORK") and len(REAL_WORK)>'#REAL_WORK#',<cfelse>NULL,</cfif> 
		KANUN_5084_ORAN =  #attributes.KANUN_5084_ORAN#,
		BRANCH_WORK =  '#attributes.BRANCH_WORK#',
		OPEN_DATE = <cfif isdefined("attributes.open_date") and len(attributes.open_date)>#attributes.open_date#,<cfelse>NULL,</cfif>
		TCKIMLIK_NO = <cfif isdefined("attributes.tckimlik_no") and len(attributes.tckimlik_no)>'#attributes.tckimlik_no#',<cfelse>NULL,</cfif>
		USER_NAME = <cfif isdefined("attributes.user_name") and len(attributes.user_name)>'#attributes.user_name#',<cfelse>NULL,</cfif>	
		SYSTEM_PASSWORD = <cfif isdefined("attributes.system_password") and len(attributes.system_password)>'#system_password#',<cfelse>NULL,</cfif>
		COMPANY_PASSWORD = <cfif isdefined("attributes.company_password") and len(attributes.company_password)>'#company_password#',<cfelse>NULL,</cfif>
		SSK_EMPLOYEE_ID = <cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>#attributes.employee_id#,<cfelse>NULL,</cfif>
		SSK_POSITION_CODE = <cfif isdefined("attributes.to_position_code") and len(attributes.to_position_code)>#attributes.to_position_code#,<cfelse>NULL,</cfif>
		EMPLOYEE_SYSTEM_NAME = 	<cfif isdefined("attributes.employee_name") and len(attributes.employee_name)>'#attributes.employee_name#',<cfelse>NULL,</cfif>
		POSITION_NAME = 	<cfif isdefined("attributes.position_name") and len(attributes.position_name)>'#attributes.position_name#',<cfelse>NULL,</cfif>
		BRANCH_PDKS_CODE = <cfif isdefined("attributes.pdks_no") and len(attributes.pdks_no)>'#attributes.pdks_no#',<cfelse>NULL,</cfif>
		BRANCH_PDKS_IP_NUMBERS = <cfif isdefined("attributes.BRANCH_PDKS_IP_NUMBERS") and len(attributes.BRANCH_PDKS_IP_NUMBERS)>'#attributes.BRANCH_PDKS_IP_NUMBERS#',<cfelse>NULL,</cfif>
		KANUN_6486 = <cfif len(attributes.kanun_6486)>#attributes.kanun_6486#<cfelse>NULL</cfif>,
		KANUN_6322 = <cfif len(attributes.kanun_6322)>#attributes.kanun_6322#<cfelse>NULL</cfif>,
		DETAIL = <cfif isdefined("attributes.detail") and len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
		FILE_NO = <cfif isdefined("attributes.file_no") and len(attributes.file_no)>'#attributes.file_no#',<cfelse>NULL,</cfif>
		WEX_ADDRESS = <cfif isdefined("attributes.wex_address") and len(attributes.wex_address)>'#attributes.wex_address#',<cfelse>NULL,</cfif>
		ACC_UNIT_CODE = <cfif isdefined("attributes.acc_unit_code") and len(attributes.acc_unit_code)>'#attributes.acc_unit_code#',<cfelse>NULL,</cfif>
		ACC_COMP_NAME = <cfif isdefined("attributes.acc_company_name") and len(attributes.acc_company_name)>'#attributes.acc_company_name#',<cfelse>NULL,</cfif>
		EXPENSE_UNIT_CODE1 = <cfif isdefined("attributes.exp_unit_code1") and len(attributes.exp_unit_code1)>'#attributes.exp_unit_code1#',<cfelse>NULL,</cfif>
		EXPENSE_UNIT_CODE2 = <cfif isdefined("attributes.exp_unit_code2") and len(attributes.exp_unit_code2)>'#attributes.exp_unit_code2#',<cfelse>NULL,</cfif>
		EXPENSE_UNIT_CODE3 = <cfif isdefined("attributes.exp_unit_code3") and len(attributes.exp_unit_code3)>'#attributes.exp_unit_code3#',<cfelse>NULL,</cfif>
		EXPENSE_UNIT_CODE4 = <cfif isdefined("attributes.exp_unit_code4") and len(attributes.exp_unit_code4)>'#attributes.exp_unit_code4#',<cfelse>NULL,</cfif>
		EXPENSE_UNIT_CODE5 = <cfif isdefined("attributes.exp_unit_code5") and len(attributes.exp_unit_code5)>'#attributes.exp_unit_code5#',<cfelse>NULL,</cfif>
		EXPENSE_ALPHA = <cfif isdefined("attributes.alpha") and len(attributes.alpha)>'#attributes.alpha#',<cfelse>NULL,</cfif>
		EXPENSE_TC = <cfif isdefined("attributes.expense_tc") and len(attributes.expense_tc)>'#attributes.expense_tc#',<cfelse>NULL,</cfif>
		EXPENSE_USER_NAME = <cfif isdefined("attributes.expense_user") and len(attributes.expense_user)>'#attributes.expense_user#',<cfelse>NULL,</cfif>
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = '#cgi.remote_addr#',
		EXPENSE_USER_POS_ID = <cfif isdefined("attributes.expense_user_pos_id") and len(attributes.expense_user_pos_id)  and len(attributes.expense_user)><cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.expense_user_pos_id#"><cfelse>NULL</cfif>,
		FULFILLMENT_OFFICER_POS_ID = <cfif isdefined("attributes.fulfillment_officer_pos_id") and len(attributes.fulfillment_officer_pos_id) and len(attributes.fulfillment_officer)><cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.fulfillment_officer_pos_id#"><cfelse>NULL</cfif>,
		SALARY_SYNDIC_POS_ID = <cfif isdefined("attributes.salary_syndic_pos_id") and len(attributes.salary_syndic_pos_id) and len(attributes.salary_syndic)><cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.salary_syndic_pos_id#"><cfelse>NULL</cfif>
	WHERE 
		BRANCH_ID = #attributes.BRANCH_ID#
</cfquery>
<!--- history icin --->
<cfquery name="add_branch_history" datasource="#dsn#">
	INSERT 
		INTO BRANCH_HISTORY 
		(BRANCH_STATUS,ZONE_ID,COMPANY_ID,BRANCH_ID,ADMIN1_POSITION_CODE,ADMIN2_POSITION_CODE,BRANCH_NAME,BRANCH_FULLNAME,BRANCH_EMAIL,BRANCH_TELCODE,BRANCH_TEL1,BRANCH_TEL2,BRANCH_TEL3,BRANCH_FAX,BRANCH_ADDRESS,BRANCH_POSTCODE,BRANCH_COUNTY,BRANCH_CITY,BRANCH_COUNTRY,BRANCH_WORK,SSK_OFFICE,SSK_NO,SSK_M,SSK_JOB,SSK_BRANCH,SSK_BRANCH_OLD,SSK_CITY,SSK_COUNTRY,
		SSK_CD,SSK_AGENT,WORK_ZONE_M,WORK_ZONE_JOB,WORK_ZONE_FILE,WORK_ZONE_CITY,DANGER_DEGREE,DANGER_DEGREE_NO,ASSET_FILE_NAME1,ASSET_FILE_NAME1_SERVER_ID,ASSET_FILE_NAME2,ASSET_FILE_NAME2_SERVER_ID,FOUNDATION_DATE,ISKUR_BRANCH_NAME,ISKUR_BRANCH_NO,CAL_BOL_MUD_NAME,REAL_WORK,CAL_BOL_MUD_NO,IS_INTERNET,HIERARCHY,HIERARCHY2,KANUN_5084_ORAN,RECORD_DATE,RECORD_EMP,RECORD_IP,UPDATE_DATE,UPDATE_EMP,UPDATE_IP,IS_SAKAT_KONTROL,RELATED_COMPANY,OZEL_KOD,IS_ORGANIZATION,
		OPEN_DATE,TCKIMLIK_NO,USER_NAME,SYSTEM_PASSWORD,COMPANY_PASSWORD,SSK_EMPLOYEE_ID,SSK_POSITION_CODE,EMPLOYEE_SYSTEM_NAME,POSITION_NAME,IS_5615,BRANCH_PDKS_CODE,BRANCH_PDKS_IP_NUMBERS,IS_PDKS_WORK
		) 
	SELECT BRANCH_STATUS,ZONE_ID,COMPANY_ID,BRANCH_ID,ADMIN1_POSITION_CODE,ADMIN2_POSITION_CODE,BRANCH_NAME,BRANCH_FULLNAME,BRANCH_EMAIL,BRANCH_TELCODE,BRANCH_TEL1,BRANCH_TEL2,BRANCH_TEL3,BRANCH_FAX,BRANCH_ADDRESS,BRANCH_POSTCODE,BRANCH_COUNTY,BRANCH_CITY,BRANCH_COUNTRY,BRANCH_WORK,SSK_OFFICE,SSK_NO,SSK_M,SSK_JOB,SSK_BRANCH,SSK_BRANCH_OLD,SSK_CITY,SSK_COUNTRY,SSK_CD,SSK_AGENT,WORK_ZONE_M,WORK_ZONE_JOB,WORK_ZONE_FILE,WORK_ZONE_CITY,DANGER_DEGREE,
	DANGER_DEGREE_NO,ASSET_FILE_NAME1,ASSET_FILE_NAME1_SERVER_ID,ASSET_FILE_NAME2,ASSET_FILE_NAME2_SERVER_ID,FOUNDATION_DATE,ISKUR_BRANCH_NAME,ISKUR_BRANCH_NO,CAL_BOL_MUD_NAME,REAL_WORK,CAL_BOL_MUD_NO,IS_INTERNET,HIERARCHY,HIERARCHY2,KANUN_5084_ORAN,RECORD_DATE,RECORD_EMP,RECORD_IP,UPDATE_DATE,UPDATE_EMP,UPDATE_IP,IS_SAKAT_KONTROL,RELATED_COMPANY,OZEL_KOD,IS_ORGANIZATION,OPEN_DATE,TCKIMLIK_NO,USER_NAME,SYSTEM_PASSWORD,COMPANY_PASSWORD,SSK_EMPLOYEE_ID,SSK_POSITION_CODE,EMPLOYEE_SYSTEM_NAME,POSITION_NAME,IS_5615,BRANCH_PDKS_CODE,BRANCH_PDKS_IP_NUMBERS,IS_PDKS_WORK FROM BRANCH WHERE BRANCH_ID = #attributes.BRANCH_ID#
</cfquery>
<!--- history icin --->
<cfquery name="upd_puantaj_ssk" datasource="#dsn#">
	UPDATE
		EMPLOYEES_PUANTAJ
	SET
		SSK_OFFICE = '#attributes.SSK_OFFICE#',
		SSK_OFFICE_NO = '#attributes.SSK_NO#'
	WHERE
		SSK_OFFICE = '#get_old_ssk_info.SSK_OFFICE#'
		AND SSK_OFFICE_NO = '#get_old_ssk_info.SSK_NO#'
</cfquery>

<cfquery name="upd_ebildirge_ssk" datasource="#dsn#">
	UPDATE
		EMPLOYEES_SSK_EXPORTS
	SET
		SSK_OFFICE = '#attributes.SSK_OFFICE#',
		SSK_OFFICE_NO = '#attributes.SSK_NO#'
	WHERE
		SSK_OFFICE = '#get_old_ssk_info.SSK_OFFICE#'
		AND SSK_OFFICE_NO = '#get_old_ssk_info.SSK_NO#'
</cfquery>

<script type="text/javascript">
	location.href = document.referrer;
</script>

