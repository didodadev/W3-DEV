<cfquery name="get_comp" datasource="#dsn#">
	SELECT COMPANY_ID FROM BRANCH WHERE  BRANCH_ID = #attributes.branch_id#
</cfquery>
<CFSET attributes.our_company_id = get_comp.COMPANY_ID>

<cfinclude template="../ehesap/query/get_hours.cfm">
<cfset baslangic_saat_ = 7>
<cfset baslangic_dakika_ = 0>
<cfif listlen(get_hours.SSK_WORK_HOURS,'.') eq 2>
	<cfset bitis_saat_ = listgetat(get_hours.SSK_WORK_HOURS,1,'.')>
	<cfset bitis_dakika_ = listgetat(get_hours.SSK_WORK_HOURS,2,'.')>
<cfelse>
	<cfset bitis_saat_ = get_hours.SSK_WORK_HOURS>
	<cfset bitis_dakika_ = 0>
</cfif>
<cfset bitis_saat_ = bitis_saat_ + 7>
<cfquery name="del_" datasource="#dsn#">
	DELETE FROM EMPLOYEE_DAILY_IN_OUT WHERE BRANCH_ID = #attributes.branch_id# AND
		SPECIAL_CODE = '#attributes.special_code#'
		<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
			AND EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE FUNC_ID = #attributes.func_id#)
		</cfif>
</cfquery>
<cfquery name="del_" datasource="#dsn#">
	DELETE FROM OFFTIME WHERE SPECIAL_CODE = '#attributes.special_code#'
</cfquery>
<cfquery name="get_offtime_rapor_type" datasource="#dsn#" maxrows="1">
	SELECT 
    	OFFTIMECAT_ID, 
        OFFTIMECAT, 
        IS_PAID, 
        EBILDIRGE_TYPE_ID, 
        SIRKET_GUN, 
        IS_YEARLY, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        IS_ACTIVE 
    FROM 
	    SETUP_OFFTIME 
    WHERE 
    	SIRKET_GUN > 0
</cfquery>
<cfif not get_offtime_rapor_type.recordcount>
	<script type="text/javascript">
		alert('Raporlu İzin Tipi Tanımlı Olmadığından Rapor İzinleri Girilemeyecek!');
	</script>
</cfif>

<cfquery name="get_offtime_absenteeism" datasource="#dsn#">
	SELECT EBILDIRGE_TYPE_ID,OFFTIMECAT_ID FROM SETUP_OFFTIME WHERE EBILDIRGE_TYPE_ID = 15
</cfquery>
<cfif not get_offtime_absenteeism.recordcount>
	<script type="text/javascript">
		alert('Devamsızlık İzin Tipi Tanımlı Olmadığından Devamsızlık İzinleri Girilemeyecek!');
	</script>
</cfif>

<cfquery name="get_offtime_puantaj" datasource="#dsn#">
	SELECT EBILDIRGE_TYPE_ID,OFFTIMECAT_ID FROM SETUP_OFFTIME WHERE EBILDIRGE_TYPE_ID = 7
</cfquery>
<cfif not get_offtime_puantaj.recordcount>
	<script type="text/javascript">
		alert('Puantaj Kayıtları Tipi Tanımlı Olmadığından Puantaj Kayıtları İzinleri Girilemeyecek!');
	</script>
</cfif>

<cfquery name="get_offtime_rapor" datasource="#dsn#">
	SELECT EBILDIRGE_TYPE_ID,OFFTIMECAT_ID FROM SETUP_OFFTIME WHERE EBILDIRGE_TYPE_ID = 1 AND (SIRKET_GUN = 0 OR SIRKET_GUN = NULL ) 
</cfquery>
<cfif not get_offtime_rapor.recordcount>
	<script type="text/javascript">
		alert('Rapor İzin Tipi Tanımlı Olmadığından Rapor İzinleri Girilemeyecek!');
	</script>
</cfif>

<cfquery name="get_offtime_ucretsiz_type" datasource="#dsn#" maxrows="1">
	SELECT 
    	OFFTIMECAT_ID, 
        OFFTIMECAT, 
        IS_PAID, 
        EBILDIRGE_TYPE_ID, 
        SIRKET_GUN, 
        IS_YEARLY, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        IS_ACTIVE 
    FROM 
    	SETUP_OFFTIME 
    WHERE 
    	(IS_PAID = 0 OR IS_PAID IS NULL) 
    AND 
	    (IS_YEARLY = 0 OR IS_YEARLY IS NULL)  
    AND 
    	(SIRKET_GUN = 0 OR SIRKET_GUN IS NULL)
</cfquery>
<cfif get_offtime_ucretsiz_type.recordcount eq 0>
	<script type="text/javascript">
		alert('Ücretsiz İzin Tipi Tanımlı Olmadığından Ücretsiz İzinler Girilemeyecek!');
	</script>
</cfif>
<cfquery name="get_offtime_ucretli_type" datasource="#dsn#" maxrows="1">
	SELECT 
    	OFFTIMECAT_ID, 
        OFFTIMECAT, 
        IS_PAID, 
        EBILDIRGE_TYPE_ID, 
        SIRKET_GUN, 
        IS_YEARLY, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        IS_ACTIVE 
    FROM 
    	SETUP_OFFTIME 
    WHERE 
    	IS_PAID = 1 
    AND 
    	(IS_YEARLY = 0 OR IS_YEARLY IS NULL) 
    AND 
	    (SIRKET_GUN = 0 OR SIRKET_GUN IS NULL)
</cfquery>
<cfif get_offtime_ucretli_type.recordcount eq 0>
	<script type="text/javascript">
		alert('Ücretli İzin Tipi Tanımlı Olmadığından Ücretli İzinler Girilemeyecek!');
	</script>
</cfif>

<cfquery name="get_offtime_yillik_type" datasource="#dsn#" maxrows="1">
	SELECT 
    	OFFTIMECAT_ID, 
        OFFTIMECAT, 
        IS_PAID, 
        EBILDIRGE_TYPE_ID, 
        SIRKET_GUN, 
        IS_YEARLY, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        IS_ACTIVE 
    FROM 
	    SETUP_OFFTIME 
    WHERE 
    	IS_YEARLY = 1
</cfquery>
<cfif get_offtime_yillik_type.recordcount eq 0>
	<script type="text/javascript">
		alert('Yıllık İzin Tipi Tanımlı Olmadığından Yıllık İzinler Girilemeyecek!');
	</script>
</cfif>

<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#" maxrows="1">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ehesap.form_add_offtime_popup%">
</cfquery>
<cfif GET_PROCESS_STAGE.recordcount eq 0>
	<script type="text/javascript">
		alert('İzin Süreci Tanımlı Olmadığından İzin Kaydı Girilemeyecek!');
	</script>
</cfif>

<cfloop from="1" to="#attributes.kayit_sayisi#" index="kayit_no">
	<cfset in_out_id_ = evaluate("attributes.in_out_id_#kayit_no#")>
	<cfset employee_id = evaluate("attributes.employee_id_#kayit_no#")>
	<cfloop from="1" to="#attributes.gun_sayisi#" index="gun_">
		<cfif evaluate("attributes.day_#in_out_id_#_#gun_#") neq 0>
			<cfif evaluate("attributes.day_#in_out_id_#_#gun_#") eq 1>
				<cfquery name="add_emp_daily_in_out" datasource="#dsn#">
					INSERT INTO
						EMPLOYEE_DAILY_IN_OUT
						(
							EMPLOYEE_ID,
							IN_OUT_ID,
							BRANCH_ID,
							START_DATE,
							FINISH_DATE,
							SPECIAL_CODE,
							IS_WEEK_REST_DAY,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
					VALUES
						(
							#employee_id#,
							#in_out_id_#,
							#attributes.branch_id#,
							#createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,gun_,baslangic_saat_,baslangic_dakika_,0))#,
							#createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,gun_,bitis_saat_,bitis_dakika_,0))#,
							'#attributes.special_code#',
							NULL,
							#now()#,
							#session.ep.userid#,
							'#cgi.remote_addr#'
						)
				</cfquery>
			<cfelseif evaluate("attributes.day_#in_out_id_#_#gun_#") is 'yg'>
				<cfquery name="add_emp_daily_in_out" datasource="#dsn#">
					INSERT INTO
						EMPLOYEE_DAILY_IN_OUT
						(
							EMPLOYEE_ID,
							IN_OUT_ID,
							BRANCH_ID,
							START_DATE,
							FINISH_DATE,
							SPECIAL_CODE,
							IS_WEEK_REST_DAY,
							IS_PUANTAJ_OFF,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
					VALUES
						(
							#employee_id#,
							#in_out_id_#,
							#attributes.branch_id#,
							#createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,gun_,baslangic_saat_,baslangic_dakika_,0))#,
							#createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,gun_,11,0,0))#,
							'#attributes.special_code#',
							NULL,
							1,
							#now()#,
							#session.ep.userid#,
							'#cgi.remote_addr#'
						)
				</cfquery>
			<cfelseif evaluate("attributes.day_#in_out_id_#_#gun_#") eq 2>
				<cfquery name="add_emp_daily_in_out" datasource="#dsn#">
					INSERT INTO
						EMPLOYEE_DAILY_IN_OUT
						(
							EMPLOYEE_ID,
							IN_OUT_ID,
							BRANCH_ID,
							START_DATE,
							FINISH_DATE,
							SPECIAL_CODE,
							IS_WEEK_REST_DAY,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
					VALUES
						(
							#employee_id#,
							#in_out_id_#,
							#attributes.branch_id#,
							#createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,gun_,baslangic_saat_,baslangic_dakika_,0))#,
							#createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,gun_,bitis_saat_,bitis_dakika_,0))#,
							'#attributes.special_code#',
							0,
							#now()#,
							#session.ep.userid#,
							'#cgi.remote_addr#'
						)
				</cfquery>
             <cfelseif evaluate("attributes.day_#in_out_id_#_#gun_#") eq 3>
				<cfquery name="add_emp_daily_in_out" datasource="#dsn#">
					INSERT INTO
						EMPLOYEE_DAILY_IN_OUT
						(
							EMPLOYEE_ID,
							IN_OUT_ID,
							BRANCH_ID,
							START_DATE,
							FINISH_DATE,
							SPECIAL_CODE,
							IS_WEEK_REST_DAY,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
					VALUES
						(
							#employee_id#,
							#in_out_id_#,
							#attributes.branch_id#,
							#createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,gun_,baslangic_saat_,baslangic_dakika_,0))#,
							#createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,gun_,bitis_saat_,bitis_dakika_,0))#,
							'#attributes.special_code#',
							1,
							#now()#,
							#session.ep.userid#,
							'#cgi.remote_addr#'
						)
				</cfquery>
			<cfelse>
				<cfset type_ = evaluate("attributes.day_#in_out_id_#_#gun_#")>
				<cfset izin_yaz_ = 0>
				<cfif type_ is 'r2' and get_offtime_rapor_type.recordcount>
					<cfset izin_yaz_ = 1>
					<cfset izin_cat = get_offtime_rapor_type.OFFTIMECAT_ID>
				<cfelseif type_ is 'r' and get_offtime_rapor.recordcount>
					<cfset izin_yaz_ = 1>
					<cfset izin_cat = get_offtime_rapor.OFFTIMECAT_ID>
				<cfelseif type_ is 'i' and get_offtime_ucretli_type.recordcount>
					<cfset izin_yaz_ = 1>
					<cfset izin_cat = get_offtime_ucretli_type.OFFTIMECAT_ID>
				<cfelseif type_ is 'd' and get_offtime_absenteeism.recordcount>
					<cfset izin_yaz_ = 1>
					<cfset izin_cat = get_offtime_absenteeism.OFFTIMECAT_ID>
				<cfelseif type_ is 'u' and get_offtime_ucretsiz_type.recordcount>
					<cfset izin_yaz_ = 1>
					<cfset izin_cat = get_offtime_ucretsiz_type.OFFTIMECAT_ID>
				<cfelseif type_ is 'y' and get_offtime_yillik_type.recordcount>
					<cfset izin_yaz_ = 1>
					<cfset izin_cat = get_offtime_yillik_type.OFFTIMECAT_ID>
				<cfelseif type_ is 'p' and get_offtime_puantaj.recordcount>
					<cfset izin_yaz_ = 1>
					<cfset izin_cat = get_offtime_puantaj.OFFTIMECAT_ID>
				</cfif>
				<cfif GET_PROCESS_STAGE.recordcount eq 0>
					<cfset izin_yaz_ = 0>
				</cfif>
					<cfif izin_yaz_ eq 1>
						<cfquery name="add_offtime" datasource="#dsn#">
							INSERT INTO
								OFFTIME
								(
								IN_OUT_ID,
								RECORD_IP,
								RECORD_EMP,
								RECORD_DATE,
								IS_PUANTAJ_OFF,
								EMPLOYEE_ID,
								OFFTIMECAT_ID,
								STARTDATE,
								FINISHDATE,
								WORK_STARTDATE,
								TOTAL_HOURS,
								VALIDATOR_POSITION_CODE,
								VALID,
								VALID_EMPLOYEE_ID,
								VALIDDATE,
								OFFTIME_STAGE,
								SPECIAL_CODE
								)
							VALUES
								(
								#in_out_id_#,
								'#CGI.REMOTE_ADDR#',
								#SESSION.EP.USERID#,
								#NOW()#,
								0,
								#employee_id#,
								#izin_cat#,
								#createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,gun_,baslangic_saat_,baslangic_dakika_,0))#,
								#createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,gun_,bitis_saat_,bitis_dakika_,0))#,
								#createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,gun_,bitis_saat_,bitis_dakika_,0))#,
								0,
								#session.ep.position_code#,
								1,
								#SESSION.EP.USERID#,
								#NOW()#,
								#GET_PROCESS_STAGE.PROCESS_ROW_ID#,
								'#attributes.special_code#'
								)
						</cfquery>
					</cfif>
			</cfif>
		</cfif>
	</cfloop>
</cfloop>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=hr.branch_pdks_table';
</script>

