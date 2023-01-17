<cfset bu_ay_basi = createdate(attributes.sal_year,attributes.sal_mon, 1)>
<cfset bu_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi))>
<cfset aydaki_gun_sayisi = daysinmonth(bu_ay_basi)>

<cfquery name="get_insurance" datasource="#dsn#">
	SELECT MAX_PAYMENT FROM INSURANCE_PAYMENT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#">
</cfquery>
<cfset tavan_matrah = get_insurance.MAX_PAYMENT>
	
<cfquery name="get_ssk_isyeri" datasource="#dsn#">
	SELECT
		BRANCH.BRANCH_ID, BRANCH.BRANCH_FULLNAME, BRANCH.BRANCH_ADDRESS, BRANCH.SSK_CD, BRANCH.KANUN_5084_ORAN,BRANCH.IS_5615,
		BRANCH.SSK_OFFICE,
		BRANCH.SSK_NO ,
	<cfif database_type is "MSSQL">
		BRANCH.SSK_OFFICE + '-' + BRANCH.SSK_NO AS SSK_OFFICE,
	<cfelseif database_type is "DB2">
		BRANCH.SSK_OFFICE || '-' || BRANCH.SSK_NO AS SSK_OFFICE,
	</cfif>
	<cfif database_type is "MSSQL">
		BRANCH.SSK_M + '' + BRANCH.SSK_JOB + '' + BRANCH.SSK_BRANCH + '' + BRANCH.SSK_BRANCH_OLD + '' + BRANCH.SSK_NO + '' + BRANCH.SSK_CITY + '' + BRANCH.SSK_COUNTRY
	<cfelseif database_type is "DB2">
		BRANCH.SSK_M || '' || BRANCH.SSK_JOB || '' || BRANCH.SSK_BRANCH || '' || BRANCH.SSK_BRANCH_OLD || '' || BRANCH.SSK_NO || '' || BRANCH.SSK_CITY || '' || BRANCH.SSK_COUNTRY
	</cfif>
		AS SSK_ISYERI_NO,
		BRANCH.SSK_AGENT,
		OUR_COMPANY.TAX_NO
	FROM 
    	BRANCH, 
        OUR_COMPANY
	WHERE 
    	OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND 
		<cfif is_sgk_office_no eq 1> 
            BRANCH.SSK_M+''+BRANCH.SSK_JOB+''+BRANCH.SSK_BRANCH+''+BRANCH.SSK_BRANCH_OLD+''+BRANCH.SSK_NO+''+BRANCH.SSK_CITY+''+BRANCH.SSK_COUNTRY+''+BRANCH.SSK_CD+''+BRANCH.SSK_AGENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ssk_office#">
        <cfelse>
            BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_office#">
        </cfif>
</cfquery>
<cfif len(get_ssk_isyeri.ssk_isyeri_no) neq 21>
	<script type="text/javascript">
		alert('<cf_get_lang dictionary_id='933.SSK İşyeri No Hatalı! İşyeri SSK Bilgilerinizi Düzeltiniz'>!');
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="get_puantajs_ilk" datasource="#dsn#">
SELECT * FROM
(
	SELECT DISTINCT
		(SELECT SBC.BUSINESS_CODE FROM SETUP_BUSINESS_CODES SBC WHERE SBC.BUSINESS_CODE_ID = EMPLOYEES_IN_OUT.BUSINESS_CODE_ID) AS BUSINESS_CODE,
		EMPLOYEES_PUANTAJ.SSK_OFFICE,
		EMPLOYEES_PUANTAJ.SSK_OFFICE_NO,
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID,
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IN_OUT.RETIRED_SGDP_NUMBER,
		EMPLOYEES_IN_OUT.USE_SSK,
		EMPLOYEES_IN_OUT.DUTY_TYPE,
		EMPLOYEES_IN_OUT.IS_USE_506,
		EMPLOYEES_IN_OUT.DAYS_506,
		EMPLOYEES_IN_OUT.USE_TAX,
		EMPLOYEES_IN_OUT.TRADE_UNION_DEDUCTION,
		EMPLOYEES_IN_OUT.SSK_STATUTE,
		EMPLOYEES_IN_OUT.DEFECTION_LEVEL,
		EMPLOYEES_IN_OUT.EXPLANATION_ID,
		EMPLOYEES_IN_OUT.START_DATE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_IN_OUT.VALID,
		EMPLOYEES_IN_OUT.IS_5510,
        EMPLOYEES_IN_OUT.IS_14857,
        EMPLOYEES_IN_OUT.IS_6645,
		EMPLOYEES_IN_OUT.LAW_NUMBERS,
		EMPLOYEES_IN_OUT.IS_6486,
		EMPLOYEES_IN_OUT.IS_6322,
		EMPLOYEES_IN_OUT.IS_25510,
        EMPLOYEES_IN_OUT.IS_46486,
        EMPLOYEES_IN_OUT.IS_56486,
        EMPLOYEES_IN_OUT.IS_66486,
		BRANCH.IS_5510 AS SUBE_IS_5510,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		EMPLOYEES_IDENTY.LAST_SURNAME,
		EMPLOYEES_IN_OUT.SOCIALSECURITY_NO AS SSK_NO,
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID,
		EMPLOYEES_PUANTAJ_ROWS.IS_KISMI_ISTIHDAM,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_6111,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_6486,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_6322,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_25510,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5746,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_4691,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY,
        EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_46486,
        EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_56486,
        EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_66486,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_100,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_80,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_60,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_40,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_20,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_100_DAY,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_80_DAY,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_60_DAY,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_40_DAY,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_20_DAY,
		EMPLOYEES_PUANTAJ_ROWS.SSK_MATRAH_EXEMPTION,
		EMPLOYEES_PUANTAJ_ROWS.SSK_DAYS_5746,
		(EMPLOYEES_PUANTAJ_ROWS.SSK_MATRAH_5746 / 15.5 * 100) AS SSK_MATRAH_5746,
		EMPLOYEES_PUANTAJ_ROWS.SSK_DAYS AS TOTAL_DAYS,
		EMPLOYEES_PUANTAJ_ROWS.SSK_MATRAH,
		EMPLOYEES_PUANTAJ_ROWS.IZIN,
		EMPLOYEES_PUANTAJ_ROWS.IZIN_COUNT,
		EMPLOYEES_PUANTAJ_ROWS.IZIN_PAID,
		EMPLOYEES_PUANTAJ_ROWS.IZIN_PAID_COUNT,
		EMPLOYEES_PUANTAJ_ROWS.PAID_IZINLI_SUNDAY_COUNT,
		EMPLOYEES_PUANTAJ_ROWS.TOTAL_SALARY,
		EMPLOYEES_PUANTAJ_ROWS.EXT_SALARY,
		EMPLOYEES_PUANTAJ_ROWS.TOTAL_PAY_SSK_TAX,
		EMPLOYEES_PUANTAJ_ROWS.TOTAL_PAY_SSK,
		EMPLOYEES_PUANTAJ_ROWS.TOTAL_PAY_TAX,
		EMPLOYEES_PUANTAJ_ROWS.TOTAL_PAY,
		EMPLOYEES_PUANTAJ_ROWS.ABSENT_DAYS,
		ISNULL(EMPLOYEES_PUANTAJ_ROWS.SSK_DEVIR, 0) AS SSK_DEVIR,
		ISNULL(EMPLOYEES_PUANTAJ_ROWS.SSK_DEVIR_LAST, 0) AS SSK_DEVIR_LAST,
		EMPLOYEES_PUANTAJ_ROWS.KIDEM_AMOUNT,
		EMPLOYEES_PUANTAJ_ROWS.IHBAR_AMOUNT,
		EMPLOYEES_PUANTAJ_ROWS.SALARY_TYPE,
		BRANCH.KANUN_6486,
		BRANCH.KANUN_6322,
        EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_687,
        EMPLOYEES_PUANTAJ_ROWS.SSK_ISCI_HISSESI_687,
        EMPLOYEES_PUANTAJ_ROWS.LAW_NUMBER_7103,
		EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_6645,
		EMPLOYEES_PUANTAJ_ROWS.SALARY AS SSK_MATRAH_SALARY,
		DATEADD(MONTH, DATE_6111_SELECT, DATE_6111) AS USE_DATE_6111
	FROM
		EMPLOYEES,
		EMPLOYEES_IN_OUT,
		EMPLOYEES_IDENTY,
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS,
		BRANCH
	WHERE
		<!--- EMPLOYEES.EMPLOYEE_ID IN (361,354,326) AND --->
		(
		(EMPLOYEES_IN_OUT.SSK_STATUTE <> 2 <!--- emekli olmayanlar ---> AND SSK_ISVEREN_HISSESI > 0 AND TOTAL_DAYS > 0)
		OR
		(EMPLOYEES_IN_OUT.SSK_STATUTE = 2 <!--- emekliler ---> AND SSK_ISVEREN_HISSESI = 0 AND TOTAL_DAYS > 0)
		OR
		TOTAL_DAYS = 0
		) 
		AND
		EMPLOYEES_IN_OUT.USE_SSK = 1 
        AND EMPLOYEES_PUANTAJ.PUANTAJ_TYPE = -1 ---- gerçek puantajdan çekecek
		AND EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID
		AND EMPLOYEES_IN_OUT.IS_5084 <> 1
		AND EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
		AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
		AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
		AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID
		AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID
		AND EMPLOYEES_PUANTAJ.SAL_YEAR = #ATTRIBUTES.SAL_YEAR#
		AND EMPLOYEES_PUANTAJ.SAL_MON = #ATTRIBUTES.SAL_MON#
		AND EMPLOYEES_PUANTAJ.SSK_BRANCH_ID = BRANCH.BRANCH_ID
		<!---AND EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID--->
	<!--- BU AY İÇİNDE ÇALIŞMIŞ --->
		AND EMPLOYEES_IN_OUT.START_DATE <= #bu_ay_sonu#
		AND ( EMPLOYEES_IN_OUT.FINISH_DATE >= #bu_ay_basi# OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL )
	<!--- // BU AY İÇİNDE ÇALIŞMIŞ --->
		AND EMPLOYEES_PUANTAJ.SSK_BRANCH_ID IN(#valuelist(get_ssk_isyeri.BRANCH_ID,',')#)
) ALL_PUANTAJS
	ORDER BY
		IS_USE_506,
		SSK_STATUTE,
		DEFECTION_LEVEL,
		TRADE_UNION_DEDUCTION,
		USE_SSK,
		USE_TAX
</cfquery>
<cfquery dbtype="query" name="check_tck">
	SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM get_puantajs_ilk WHERE (TC_IDENTY_NO IS NULL OR TC_IDENTY_NO LIKE '% %' OR TC_IDENTY_NO = '') AND SSK_STATUTE NOT IN (5,6,12,71,13)
</cfquery>
<cfif check_tck.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='29831.Kişi'>:<cfoutput query="check_tck">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#\n</cfoutput>  <cf_get_lang dictionary_id='936.Bu kişi için TC Kimlik No Bilgisi Eksik veya Hatalı olduğundan Belge Oluşturulamadı'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfset puantaj_id_list = "">
<cfquery name="get_puantajs_n_tesvik_100" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE SSK_ISVEREN_HISSESI_GOV_100 > 0 AND DEFECTION_LEVEL = 0 AND IS_5510 = 1
</cfquery>
<cfif get_puantajs_n_tesvik_100.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_n_tesvik_100.employee_puantaj_id,','),',')>
</cfif>
<cfquery name="get_puantajs_n_tesvik_80" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE SSK_ISVEREN_HISSESI_GOV_80 > 0 AND DEFECTION_LEVEL = 0 AND IS_5510 = 1
</cfquery>
<cfif get_puantajs_n_tesvik_80.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_n_tesvik_80.employee_puantaj_id,','),',')>
</cfif>
<cfquery name="get_puantajs_n_tesvik_60" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE SSK_ISVEREN_HISSESI_GOV_60 > 0 AND DEFECTION_LEVEL = 0 AND IS_5510 = 1
</cfquery>
<cfif get_puantajs_n_tesvik_60.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_n_tesvik_60.employee_puantaj_id,','),',')>
</cfif>
<cfquery name="get_puantajs_n_tesvik_40" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE SSK_ISVEREN_HISSESI_GOV_40 > 0 AND DEFECTION_LEVEL = 0 AND IS_5510 = 1
</cfquery>
<cfif get_puantajs_n_tesvik_40.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_n_tesvik_40.employee_puantaj_id,','),',')>
</cfif>
<cfquery name="get_puantajs_n_tesvik_20" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE SSK_ISVEREN_HISSESI_GOV_20 > 0 AND DEFECTION_LEVEL = 0 AND IS_5510 = 1
</cfquery>
<cfif get_puantajs_n_tesvik_20.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_n_tesvik_20.employee_puantaj_id,','),',')>
</cfif>
<!--- get_puantajs_sy_tesvik kapatıldı --->
<cfquery name="get_puantajs_sf_tesvik" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE IS_14857 = 1 AND SSK_STATUTE IN (1,3,32)
</cfquery>
<cfif get_puantajs_sf_tesvik.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_sf_tesvik.employee_puantaj_id,','),',')>
</cfif>
<cfquery name="get_puantaj_egtm_tesvik" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE SSK_ISVEREN_HISSESI_6645 > 0 AND SSK_STATUTE IN (1,8,9,10,32) 
</cfquery>
<cfif get_puantaj_egtm_tesvik.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantaj_egtm_tesvik.employee_puantaj_id,','),',')>
</cfif>
<!---<cfquery name="get_puantajs_sy_tesvik" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE SSK_ISVEREN_HISSESI_GOV > 0 AND DEFECTION_LEVEL > 0 AND IS_SAKAT_KONTROL = 1 AND IS_5510 = 1
</cfquery>
<cfif get_puantajs_sy_tesvik.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_sy_tesvik.employee_puantaj_id,','),',')>
</cfif>--->
<cfquery name="get_puantajs_5921" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE SSK_ISVEREN_HISSESI_5921 > 0
</cfquery>
<cfif get_puantajs_5921.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_5921.employee_puantaj_id,','),',')>
</cfif>
<cfquery name="get_puantajs_5746" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE SSK_ISVEREN_HISSESI_5746 > 0
</cfquery>
<!---
<cfif get_puantajs_5746.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_5746.employee_puantaj_id,','),',')>
</cfif>
--->
<cfquery name="get_puantajs_4691" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE SSK_ISVEREN_HISSESI_4691 > 0
</cfquery>
<cfif get_puantajs_4691.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_4691.employee_puantaj_id,','),',')>
</cfif>
<cfset control_date = createdatetime(sal_year,sal_mon,1,0,0,0)><!---Puantajı oluşturulacak ay ve yıl ERU--->
<cfquery name="get_puantajs_6111" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE (SSK_ISVEREN_HISSESI_6111 > 0 OR (LAW_NUMBERS IS NOT NULL AND LAW_NUMBERS LIKE '%6111%' AND SSK_ISVEREN_HISSESI_6111 = 0 AND USE_DATE_6111 > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#control_date#">))<!--- OR LAW_NUMBERS LIKE '%6111%'--->
</cfquery>
<cfif get_puantajs_6111.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_6111.employee_puantaj_id,','),',')>
</cfif>
<cfquery name="get_puantajs_6486" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE 
	(SSK_ISVEREN_HISSESI_6486 > 0 OR IS_6486 = 1 OR (KANUN_6486 >0 AND SSK_STATUTE = 2)) <cfif len(puantaj_id_list)>AND EMPLOYEE_PUANTAJ_ID NOT IN(#puantaj_id_list#)</cfif>
</cfquery>
<cfif get_puantajs_6486.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_6486.employee_puantaj_id,','),',')>
</cfif>
<cfquery name="get_puantajs_6322" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE (SSK_ISVEREN_HISSESI_6322 > 0 OR IS_6322 = 1 OR (KANUN_6322 > 0 AND SSK_STATUTE = 2)) <cfif len(puantaj_id_list)>AND EMPLOYEE_PUANTAJ_ID NOT IN(#puantaj_id_list#)</cfif>
</cfquery>
<cfif get_puantajs_6322.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_6322.employee_puantaj_id,','),',')>
</cfif>
<cfquery name="get_puantajs_25510" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE SSK_ISVEREN_HISSESI_25510 > 0 AND IS_25510 = 1 <cfif len(puantaj_id_list)>AND EMPLOYEE_PUANTAJ_ID NOT IN(#puantaj_id_list#)</cfif>
</cfquery>
<cfif get_puantajs_25510.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_25510.employee_puantaj_id,','),',')>
</cfif>

<cfquery name="get_puantajs_46486" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE IS_46486 = 1 AND SSK_STATUTE IN (1,2)
</cfquery>
<cfif get_puantajs_46486.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_46486.employee_puantaj_id,','),',')>
</cfif>
<cfquery name="get_puantajs_56486" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE IS_56486 = 1 AND SSK_STATUTE IN (1,2)
</cfquery>
<cfif get_puantajs_56486.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_56486.employee_puantaj_id,','),',')>
</cfif>
<cfquery name="get_puantajs_66486" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE IS_66486 = 1 AND SSK_STATUTE IN (1,2)
</cfquery>
<cfif get_puantajs_66486.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_66486.employee_puantaj_id,','),',')>
</cfif>
<cfquery name="get_puantajs_687" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE (SSK_ISVEREN_HISSESI_687 > 0 OR SSK_ISCI_HISSESI_687 > 0) <!---OR LAW_NUMBERS LIKE '%6111%'--->
</cfquery>
<cfif get_puantajs_687.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_687.employee_puantaj_id,','),',')>
</cfif>

<cfquery name="get_puantajs_17103" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE LAW_NUMBER_7103 = 17103
</cfquery>
<cfif get_puantajs_17103.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_17103.employee_puantaj_id,','),',')>
</cfif>
<cfquery name="get_puantajs_27103" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE LAW_NUMBER_7103 = 27103
</cfquery>
<cfif get_puantajs_27103.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_27103.employee_puantaj_id,','),',')>
</cfif>
<cfquery name="get_puantajs_37103" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE LAW_NUMBER_7103 = 37103
</cfquery>
<cfif get_puantajs_37103.recordcount>
	<cfset puantaj_id_list =listappend(puantaj_id_list,valuelist(get_puantajs_37103.employee_puantaj_id,','),',')>
</cfif>



<cfquery name="get_puantajs" dbtype="query">
	SELECT * FROM get_puantajs_ilk WHERE 
	SSK_ISVEREN_HISSESI_GOV = 0 AND 
	(((TOTAL_DAYS + IZIN) > SSK_ISVEREN_HISSESI_5921_DAY OR SSK_ISVEREN_HISSESI_5921_DAY = 0) AND 
	SSK_ISVEREN_HISSESI_5921_DAY < #aydaki_gun_sayisi#  AND 
	(SSK_ISVEREN_HISSESI_5746 = 0 OR SSK_DAYS_5746 < TOTAL_DAYS) AND 
	SSK_ISVEREN_HISSESI_4691 = 0 AND 
	 SSK_ISVEREN_HISSESI_6111 = 0 AND
	IS_6486 <> 1 AND
	IS_6322 <> 1 AND 
	(IS_25510 <> 1 OR IS_25510 IS NULL)
	)
	<cfif len(puantaj_id_list)><!--- SG 20130726 yukarıdaki kanun kosullarina girenler tum listede goruntulenmemesi icin kontrol eklendi--->
		AND EMPLOYEE_PUANTAJ_ID NOT IN (#puantaj_id_list#)
	</cfif>
</cfquery>
<cfif attributes.sal_year is 2004 and attributes.sal_mon gte 1 and attributes.sal_mon lte 6>
	<cfquery name="get_5073" datasource="#dsn#">
	SELECT * FROM 
		(
		SELECT 
			(SELECT SBC.BUSINESS_CODE FROM SETUP_BUSINESS_CODES SBC WHERE SBC.BUSINESS_CODE_ID = EMPLOYEES_IN_OUT.BUSINESS_CODE_ID) AS BUSINESS_CODE,
			EMPLOYEES.EMPLOYEE_ID,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			EMPLOYEES_IN_OUT.RETIRED_SGDP_NUMBER,
			EMPLOYEES_IN_OUT.USE_SSK,
			EMPLOYEES_IN_OUT.USE_TAX,
			EMPLOYEES_IN_OUT.TRADE_UNION_DEDUCTION,
			EMPLOYEES_IN_OUT.SSK_STATUTE,
			EMPLOYEES_IN_OUT.IS_USE_506,
			EMPLOYEES_IN_OUT.DAYS_506,
			EMPLOYEES_IN_OUT.DEFECTION_LEVEL,
			EMPLOYEES_IN_OUT.SSK_OFFICE,
			EMPLOYEES_IN_OUT.SSK_OFFICE_NO,
			EMPLOYEES_IN_OUT.EXPLANATION_ID,
			EMPLOYEES_IN_OUT.START_DATE,
			EMPLOYEES_IN_OUT.FINISH_DATE,
			EMPLOYEES_IN_OUT.VALID,
			EMPLOYEES_IDENTY.TC_IDENTY_NO,
			EMPLOYEES_IDENTY.LAST_SURNAME,
			EMPLOYEES_IN_OUT.SOCIALSECURITY_NO AS SSK_NO,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_100,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_80,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_60,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_40,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_20,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_100_DAY,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_80_DAY,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_60_DAY,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_40_DAY,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_20_DAY,
			EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS,
			EMPLOYEES_PUANTAJ_ROWS.SSK_MATRAH,
			EMPLOYEES_PUANTAJ_ROWS.IZIN,
			EMPLOYEES_PUANTAJ_ROWS.IZIN_COUNT,
			EMPLOYEES_PUANTAJ_ROWS.IZIN_PAID,
			EMPLOYEES_PUANTAJ_ROWS.IZIN_PAID_COUNT,
			EMPLOYEES_PUANTAJ_ROWS.PAID_IZINLI_SUNDAY_COUNT,
			EMPLOYEES_PUANTAJ_ROWS.TOTAL_SALARY,
			EMPLOYEES_PUANTAJ_ROWS.EXT_SALARY,
			EMPLOYEES_PUANTAJ_ROWS.TOTAL_PAY_SSK_TAX,
			EMPLOYEES_PUANTAJ_ROWS.TOTAL_PAY_SSK,
			EMPLOYEES_PUANTAJ_ROWS.TOTAL_PAY_TAX,
			ISNULL(EMPLOYEES_PUANTAJ_ROWS.SSK_DEVIR, 0) AS SSK_DEVIR,
			ISNULL(EMPLOYEES_PUANTAJ_ROWS.SSK_DEVIR_LAST, 0) AS SSK_DEVIR_LAST,
			EMPLOYEES_PUANTAJ_ROWS.KIDEM_AMOUNT,
			EMPLOYEES_PUANTAJ_ROWS.IHBAR_AMOUNT,
			EMPLOYEES_PUANTAJ_ROWS.TOTAL_PAY
		FROM 
			EMPLOYEES,
			EMPLOYEES_IN_OUT,
			EMPLOYEES_IDENTY,
			EMPLOYEES_PUANTAJ,
			EMPLOYEES_PUANTAJ_ROWS
		WHERE
			EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS + EMPLOYEES_PUANTAJ_ROWS.IZIN_PAID > 0
			AND EMPLOYEES_IN_OUT.USE_SSK = 1 
			AND EMPLOYEES_IN_OUT.IS_5084 <> 1 
			AND EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
			AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
			AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
			AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID
			AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID
			AND EMPLOYEES_PUANTAJ.SAL_YEAR = #ATTRIBUTES.SAL_YEAR#
			AND EMPLOYEES_PUANTAJ.SAL_MON = #ATTRIBUTES.SAL_MON#
			AND EMPLOYEES_IN_OUT.BRANCH_ID IN(#valuelist(get_ssk_isyeri.BRANCH_ID,',')#)
		<!--- BU AY İÇİNDE ÇALIŞMIŞ --->
			AND EMPLOYEES_IN_OUT.START_DATE <= #bu_ay_sonu#
			AND ( EMPLOYEES_IN_OUT.FINISH_DATE >= #bu_ay_basi# OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL )
		<!--- // BU AY İÇİNDE ÇALIŞMIŞ --->
			AND EMPLOYEES_PUANTAJ.SSK_BRANCH_ID = #attributes.SSK_OFFICE#
		) ALL_PUANTAJS
		WHERE
			( ((SSK_MATRAH*30)/TOTAL_DAYS) < 549630000 )
		ORDER BY
			IS_USE_506,
			SSK_STATUTE,
			DEFECTION_LEVEL,
			TRADE_UNION_DEDUCTION,
			USE_SSK,
			USE_TAX
	</cfquery>
	<cfquery dbtype="query" name="check_tck">
		SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM get_5073 WHERE (TC_IDENTY_NO IS NULL OR TC_IDENTY_NO LIKE '% %' OR TC_IDENTY_NO = '') AND SSK_STATUTE NOT IN (5,6,12)
	</cfquery>
	<cfif check_tck.recordcount>
		<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='29831.Kişi'>:<cfoutput query="check_tck">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#\n</cfoutput>  <cf_get_lang dictionary_id='936.Bu kişi için TC Kimlik No Bilgisi Eksik veya Hatalı olduğundan Belge Oluşturulamadı'>!");
		window.close();
		</script>
		<CFABORT>
	</cfif>
<cfelse>
	<cfset get_5073.recordcount = 0>
</cfif>

<cfif get_ssk_isyeri.KANUN_5084_ORAN gt 0>
	<cfquery name="get_5084" datasource="#dsn#">
	SELECT * FROM 
		(
		SELECT
			(SELECT SBC.BUSINESS_CODE FROM SETUP_BUSINESS_CODES SBC WHERE SBC.BUSINESS_CODE_ID = EMPLOYEES_IN_OUT.BUSINESS_CODE_ID) AS BUSINESS_CODE,
			EMPLOYEES.EMPLOYEE_ID,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			EMPLOYEES_IN_OUT.RETIRED_SGDP_NUMBER,
			EMPLOYEES_IN_OUT.USE_SSK,
			EMPLOYEES_IN_OUT.IS_USE_506,
			EMPLOYEES_IN_OUT.DAYS_506,
			EMPLOYEES_IN_OUT.USE_TAX,
			EMPLOYEES_IN_OUT.TRADE_UNION_DEDUCTION,
			EMPLOYEES_IN_OUT.SSK_STATUTE,
			EMPLOYEES_IN_OUT.DEFECTION_LEVEL,
			EMPLOYEES_IN_OUT.EXPLANATION_ID,
			EMPLOYEES_IN_OUT.START_DATE,
			EMPLOYEES_IN_OUT.FINISH_DATE,
			EMPLOYEES_IN_OUT.VALID,
			EMPLOYEES_IDENTY.TC_IDENTY_NO,
			EMPLOYEES_IDENTY.LAST_SURNAME,
			EMPLOYEES_IN_OUT.SOCIALSECURITY_NO AS SSK_NO,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_100,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_80,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_60,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_40,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_20,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_100_DAY,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_80_DAY,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_60_DAY,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_40_DAY,
			EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_GOV_20_DAY,
			EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS,
			EMPLOYEES_PUANTAJ_ROWS.SSK_MATRAH,
			EMPLOYEES_PUANTAJ_ROWS.IZIN,
			EMPLOYEES_PUANTAJ_ROWS.IZIN_COUNT,
			EMPLOYEES_PUANTAJ_ROWS.IZIN_PAID,
			EMPLOYEES_PUANTAJ_ROWS.IZIN_PAID_COUNT,
			EMPLOYEES_PUANTAJ_ROWS.PAID_IZINLI_SUNDAY_COUNT,
			EMPLOYEES_PUANTAJ_ROWS.TOTAL_SALARY,
			EMPLOYEES_PUANTAJ_ROWS.EXT_SALARY,
			ISNULL(EMPLOYEES_PUANTAJ_ROWS.SSK_DEVIR, 0) AS SSK_DEVIR,
			ISNULL(EMPLOYEES_PUANTAJ_ROWS.SSK_DEVIR_LAST, 0) AS SSK_DEVIR_LAST,
			EMPLOYEES_PUANTAJ_ROWS.TOTAL_PAY_SSK_TAX,
			EMPLOYEES_PUANTAJ_ROWS.TOTAL_PAY_SSK,
			EMPLOYEES_PUANTAJ_ROWS.TOTAL_PAY_TAX,
			EMPLOYEES_PUANTAJ_ROWS.TOTAL_PAY,
			EMPLOYEES_PUANTAJ_ROWS.KIDEM_AMOUNT,
			EMPLOYEES_PUANTAJ_ROWS.IHBAR_AMOUNT,
			EMPLOYEES_PUANTAJ_ROWS.SALARY_TYPE
		FROM 
			EMPLOYEES,
			EMPLOYEES_IN_OUT,
			EMPLOYEES_IDENTY,
			EMPLOYEES_PUANTAJ,
			EMPLOYEES_PUANTAJ_ROWS,
			BRANCH
		WHERE
			EMPLOYEES_IN_OUT.USE_SSK = 1
			AND SSK_ISVEREN_HISSESI_5746 = 0
			AND SSK_ISVEREN_HISSESI_4691 = 0
			-- AND ((EMPLOYEES_IN_OUT.IS_5084 = 1 AND EMPLOYEES_IN_OUT.SSK_STATUTE = 1) OR (EMPLOYEES_IN_OUT.IS_5084 <> 1 AND EMPLOYEES_IN_OUT.SSK_STATUTE <> 1)) 
			AND EMPLOYEES_IN_OUT.IS_5084 = 1
			AND EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
			AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
			AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
			AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID
			AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID
			AND EMPLOYEES_PUANTAJ.SAL_YEAR = #ATTRIBUTES.SAL_YEAR#
			AND EMPLOYEES_PUANTAJ.SAL_MON = #ATTRIBUTES.SAL_MON#
			AND EMPLOYEES_PUANTAJ.SSK_OFFICE = BRANCH.SSK_OFFICE
			AND EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = BRANCH.SSK_NO
			AND EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
			<!--- BU AY İÇİNDE ÇALIŞMIŞ --->
			AND EMPLOYEES_IN_OUT.START_DATE <= #bu_ay_sonu#
			AND ( EMPLOYEES_IN_OUT.FINISH_DATE >= #bu_ay_basi# OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL )
			<!--- // BU AY İÇİNDE ÇALIŞMIŞ --->
			AND EMPLOYEES_PUANTAJ.SSK_BRANCH_ID IN(#valuelist(get_ssk_isyeri.BRANCH_ID,',')#)
		) ALL_PUANTAJS
		ORDER BY
			IS_USE_506,
			SSK_STATUTE,
			DEFECTION_LEVEL,
			TRADE_UNION_DEDUCTION,
			USE_SSK,
			USE_TAX
	</cfquery>
	<cfif (not get_puantajs_ilk.recordcount) AND (not get_5073.recordcount) AND (not get_5084.recordcount)>
		<script type="text/javascript">
			alert('<cf_get_lang dictionary_id='934.Önce Puantaj Oluşturunuz 1'>!');
			history.back();
		</script>
		<cfabort>
	</cfif>

	<cfquery dbtype="query" name="check_tck">
		SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM get_5084 WHERE (TC_IDENTY_NO IS NULL OR TC_IDENTY_NO LIKE '% %' OR TC_IDENTY_NO = '') AND SSK_STATUTE NOT IN (5,6,12)
	</cfquery>
	<cfif check_tck.recordcount>
		<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='29831.Kişi'>:<cfoutput query="check_tck">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#\n</cfoutput>  <cf_get_lang dictionary_id='936.Bu kişi için TC Kimlik No Bilgisi Eksik veya Hatalı olduğundan Belge Oluşturulamadı'>!");
		window.close();
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<cfif (not get_puantajs_ilk.recordcount) and (not get_5073.recordcount)>
		<script type="text/javascript">
			alert('<cf_get_lang dictionary_id='935.Önce Puantaj Oluşturunuz...Puantaj Kayıt Sayısı : 0'>!');
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>

<cfquery name="get_izins" datasource="#dsn#">
	SELECT
		OFFTIME.EMPLOYEE_ID,
		SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
		SETUP_OFFTIME.SIRKET_GUN,
		OFFTIME.STARTDATE
	FROM
		OFFTIME, SETUP_OFFTIME
	WHERE
		SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
		AND SETUP_OFFTIME.IS_PAID = 0 
		AND OFFTIME.IS_PUANTAJ_OFF = 0
		AND OFFTIME.VALID = 1
		AND OFFTIME.STARTDATE <= #bu_ay_sonu#
		AND OFFTIME.FINISHDATE >= #bu_ay_basi#
	ORDER BY
		OFFTIME.EMPLOYEE_ID
</cfquery><!--- <script>alert("<cfoutput>#get_puantajs.IZIN#</cfoutput>");</script><cfabort> --->
<cfscript>
	upload_folder = "#upload_folder#hr#dir_seperator#ebildirge#dir_seperator#";
	file_name = "#attributes.sal_year#_#attributes.sal_mon#_#get_ssk_isyeri.SSK_ISYERI_NO##get_ssk_isyeri.ssk_cd#_#dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHMMSS')#.xml";
	
	my_doc = XmlNew();
	my_doc.xmlRoot = XmlElemNew(my_doc,"AYLIKBILDIRGELER");
	my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
	my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
	my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
	my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
	my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
	my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
	my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
	my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
	my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
	my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
	my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
	belge_ve_kanun = "0000000";
	bordro_index = 2;
</cfscript>
<cfquery name="get_rows_ext" datasource="#dsn#">
	SELECT AMOUNT,EMPLOYEE_PUANTAJ_ID FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE SSK = 2 AND ISNULL(COMMENT_TYPE,1) = 2
</cfquery>
<cfif get_puantajs.recordcount>
	<cfoutput query="get_puantajs">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			//writeoutput('EMPLOYEE_NAME:#EMPLOYEE_NAME#_EMPLOYEE_SURNAME:#EMPLOYEE_SURNAME#_izin_paid:#izin_paid#_izin:#izin#<br/>');
			// bu eleman gruplara göre oluşturulacak halloldu sıralama yapınca zaten gruplamaya gerek kalmadı erk 20040527
			is_eksik_gun = 0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			
			if(month(start_date) eq month(bu_ay_basi) and year(start_date) eq year(bu_ay_basi))
				s_date_ = start_date;
			else	
				s_date_ = bu_ay_basi;
				
			if(len(finish_date) and month(finish_date) eq month(bu_ay_sonu) and year(finish_date) eq year(bu_ay_sonu))
				f_date_ = finish_date;
			else	
				f_date_ = bu_ay_sonu;
			
			kisi_aydaki_gun_sayisi = datediff('d',s_date_,f_date_) + 1;
			
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else if (SSK_STATUTE eq 21) belge_turu = "21";
			else belge_turu = "01";

			if (len(TRADE_UNION_DEDUCTION) and (TRADE_UNION_DEDUCTION gt 0)) kanun = "04369";
			//else if ((DEFECTION_LEVEL gt 0) and (belge_turu neq "02") and IS_SAKAT_KONTROL eq 0 and (SUBE_IS_5510 neq 1 or IS_5510 neq 1)) kanun = "04857";
			//else if ((DEFECTION_LEVEL gt 0) and (belge_turu neq "02") and IS_SAKAT_KONTROL and (SUBE_IS_5510 neq 1 or IS_5510 neq 1)) kanun = "04857";
			else if((SSK_STATUTE eq 1 or SSK_STATUTE eq 6 or SSK_STATUTE eq 32) and SUBE_IS_5510 eq 1 and SSK_ISVEREN_HISSESI_GOV eq 0) kanun = "05510";
			else kanun = "00000";

			if (belge_ve_kanun is not "#belge_turu##kanun#")
			{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
			}

			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999

			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane

			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
			{
				//SSK_MATRAH_EXEMPTION
				
				onceki_aylardan_devir = SSK_DEVIR + SSK_DEVIR_LAST;
				
				total_kazanc = TOTAL_SALARY - (TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT + TOTAL_PAY) + onceki_aylardan_devir;
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + onceki_aylardan_devir;
				total_ucret = total_kazanc - total_ikramiye;
				
				if(total_ucret gte SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
				}
				else if(total_kazanc gte SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
				}
				else if(total_kazanc lt SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
				}
								
				if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				
				
					
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
				if((SSK_ISVEREN_HISSESI_5921) gt 0 and (TOTAL_DAYS + IZIN) gt SSK_ISVEREN_HISSESI_5921_DAY)
				{
					//writeoutput("<script>alert('1.1');</script>");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz / TOTAL_DAYS * (TOTAL_DAYS - SSK_ISVEREN_HISSESI_5921_DAY),2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz / TOTAL_DAYS * (TOTAL_DAYS - SSK_ISVEREN_HISSESI_5921_DAY),2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS - SSK_ISVEREN_HISSESI_5921_DAY;	// max : 30
					if(izin gt 0)
					{
						if(aydaki_gun_sayisi eq 31 and (TOTAL_DAYS - SSK_ISVEREN_HISSESI_5921_DAY) eq 30) // 20130816 SG
						{
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;	// max : 30
							is_eksik_gun = 0;
						}
						else
							{
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = SSK_ISVEREN_HISSESI_5921_DAY + IZIN;// max : 30
							is_eksik_gun = SSK_ISVEREN_HISSESI_5921_DAY + IZIN;
							}
						//writeoutput("<script>alert('0- #SSK_ISVEREN_HISSESI_5921_DAY#');</script>");
					}
					else
					{
						//writeoutput("<script>alert('2- #get_puantajs.EMPLOYEE_NAME# - #get_puantajs.EMPLOYEE_SURNAME#');</script>");
						if(aydaki_gun_sayisi eq 31 and (TOTAL_DAYS - SSK_ISVEREN_HISSESI_5921_DAY) eq 30) // 20130816 SG
							{	
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
								is_eksik_gun = 0;
							}
						else
						{	
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = SSK_ISVEREN_HISSESI_5921_DAY;	// max : 30
							is_eksik_gun = SSK_ISVEREN_HISSESI_5921_DAY;
						}
					}
				}
				else if((SSK_DAYS_5746) gt 0 and (TOTAL_DAYS + IZIN) gt SSK_DAYS_5746)
				{
					pek_tutar_ = wrk_round(total_matrah_yaz - SSK_MATRAH_5746,2);
					gun_ = TOTAL_DAYS - SSK_DAYS_5746;
					ek_gun = 0;
					SSK_DAYS_5746_ = SSK_DAYS_5746;
					
					maas_max_tutar = wrk_round(ssk_matrah_salary / 30 * gun_);
					ssk_max_tutar = wrk_round(tavan_matrah / 30 * gun_);
					if(pek_tutar_ gt ssk_max_tutar)
					{
						pek_tutar_ = maas_max_tutar;
						total_ikramiye_yaz = wrk_round(total_matrah_yaz - SSK_MATRAH_5746 - pek_tutar_);
						pek_tutar_ = pek_tutar_ + total_ikramiye_yaz;
						gun_ = total_days;
						ek_gun = SSK_DAYS_5746;
						SSK_DAYS_5746_ = 0;
					}
					
					
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = pek_tutar_;// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = gun_;	// max : 30
					if(izin gt 0)
					{
						if(kisi_aydaki_gun_sayisi eq 31 and (TOTAL_DAYS - SSK_DAYS_5746_) eq 30) // 20130816 SG
						{
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;	// max : 30
							is_eksik_gun = 0;
						}
						else
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN + SSK_DAYS_5746_;// max : 30
								is_eksik_gun = IZIN + SSK_DAYS_5746_;
								
								if(kisi_aydaki_gun_sayisi eq 31 and (SSK_DAYS_5746_ + IZIN + TOTAL_DAYS) eq 30)
								{
									e_gun = kisi_aydaki_gun_sayisi - (SSK_DAYS_5746_ + IZIN);
									my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = e_gun;// max : 30
									is_eksik_gun = e_gun;
								}
								else
								{
									my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = SSK_DAYS_5746_;	// max : 30
									is_eksik_gun = SSK_DAYS_5746_;
								}
							}
						//writeoutput("<script>alert('0- #SSK_ISVEREN_HISSESI_5921_DAY#');</script>");
					}
					else
					{
						if(kisi_aydaki_gun_sayisi eq 31 and (TOTAL_DAYS - SSK_DAYS_5746_) eq 30) // 20130816 SG
							{	
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
								is_eksik_gun = 0;
							}
						else
						{	
							if(kisi_aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
							{
								e_gun = kisi_aydaki_gun_sayisi - (TOTAL_DAYS - SSK_DAYS_5746_);
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = e_gun;// max : 30
								is_eksik_gun = e_gun;
							}
							else
							{
								e_gun = SSK_DAYS_5746_;
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = SSK_DAYS_5746_;	// max : 30
								is_eksik_gun = SSK_DAYS_5746_;
							}
							//abort('kisi_aydaki_gun_sayisi:#kisi_aydaki_gun_sayisi# TOTAL_DAYS:#TOTAL_DAYS# iin:#izin# #izin_paid# e_gun:#e_gun#');
						}
					}
				}
				else
				{
					//writeoutput("<script>alert('2.1');</script>");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)
					{
						//writeoutput("<script>alert('2.1');</script>");
						//writeoutput("<script>alert('3- #get_puantajs.EMPLOYEE_NAME# - #get_puantajs.EMPLOYEE_SURNAME#');</script>");
						if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
								is_eksik_gun = 0;
							}
						else
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
								is_eksik_gun = 31;
							}
					}
					else
					{
						//writeoutput("<script>alert('2.2 - #IZIN#');</script>");
						//writeoutput("<script>alert('4- #get_puantajs.EMPLOYEE_NAME# - #get_puantajs.EMPLOYEE_SURNAME#');</script>");
						if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
						{
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;	// max : 30
							is_eksik_gun = 0;
						}
						else
						{
							if(aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								if(TOTAL_DAYS+IZIN lt 30)
								{
									my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	
									is_eksik_gun = IZIN;
								}
								else
								{
									my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31-TOTAL_DAYS;	// max : 30
									is_eksik_gun = 31-TOTAL_DAYS;
								}								
							}
							else
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun = IZIN;
							}
						}
					}
				}	

				if(salary_type eq 1 and aydaki_gun_sayisi eq 31 and total_days eq 30)
				{
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
					is_eksik_gun =0;
				}	
				
				
				
			}
			else
			{	
				ay_matrah_ozel = SSK_MATRAH * SSK_ISVEREN_HISSESI_5921_DAY / TOTAL_DAYS;
				if(SSK_ISVEREN_HISSESI_5921 gt 0 and (TOTAL_DAYS + IZIN) gt SSK_ISVEREN_HISSESI_5921_DAY)
				{
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel / TOTAL_DAYS * (TOTAL_DAYS - SSK_ISVEREN_HISSESI_5921_DAY),2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS - SSK_ISVEREN_HISSESI_5921_DAY;	// max : 30
				}
				else
				{
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
				}
			}
			//abort("bitti");
			// bu ay içinde giriş ve/veya çıkışı varsa
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)))
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if(izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN,STARTDATE FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount)
					{
					gun = 0;
					for(k=1; k lte get_emp_izins_2.recordcount; k=k+1)
						{
						gun_farki = datediff('d',bu_ay_basi,get_emp_izins_2.STARTDATE[k]);
						if(gun_farki eq 1)
							gun = gun + 1;
						else if(gun_farki lte 0)
							gun = gun + 2;
						}
					izin_paid_yaz = izin_paid;
					}
				else 
					izin_paid_yaz = izin_paid;
					
				if(paid_izinli_sunday_count gt 0 and paid_izinli_sunday_count lt izin_paid_yaz)
					izin_paid_yaz = izin_paid_yaz - paid_izinli_sunday_count;
					
				if(len(izin_paid_yaz) and izin_paid_yaz gt 0 and len(total_days) and total_days gt 0)
					izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				else
					izin_paid_amount = 0;
				
				if (SSK_STATUTE neq 2)
				{
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UCRETLIIZINGUN"] = izin_paid_yaz;//ücretli izin gün  {max : 30} (optional)
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UIPEK"] = wrk_round(izin_paid_amount,2);//ücretli izin gün matrahı {max : 99999999999} (optional)
				}
				
				}
			
			if(salary_type eq 1 and aydaki_gun_sayisi eq 31 and total_days eq 30)
				{
				writeoutput(' ');
				}
			else
				{
					if (izin gt 0)
						{
						get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
						eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
						if (not len(eksik_neden_id)) eksik_neden_id = 13;
						if (get_emp_izins_2.recordcount gte 2)
							for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
							{
								eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
								if(listlen(eksikGunler,',') gte 2)
								{
									if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
										eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
									}else if(ListFindNoCase(eksikGunler,28)){
										eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
									}else if(ListFindNoCase(eksikGunler,27)){
										eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
									}else{
										eksik_neden_id = 12; // birden fazla
									}
								}
							}
							if(is_eksik_gun gt 0)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
							}
						}
				}
			if(is_eksik_gun gt 0)
			{	
			if(SSK_ISVEREN_HISSESI_5921_DAY gt 0)
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = 12;
			
			if(SSK_DAYS_5746 gt 0)
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = 13;
			
			if(duty_type eq 6 and (not isdefined("get_emp_izins_2.recordcount") or not get_emp_izins_2.recordcount))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = 6;
			else if(duty_type eq 6)
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = 12;
			}	
			if(SSK_ISVEREN_HISSESI_GOV gt 0 and izin_paid_yaz gt 0)
				{
				if(is_eksik_gun gt 0)
				{
				if(izin gt 0)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = 12;	//aralık : 0-99 (optional)	
				else
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = 13;	//aralık : 0-99 (optional)
				}
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS - (TOTAL_DAYS - (izin_paid_yaz + paid_izinli_sunday_count));
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel-izin_paid_amount,2);	// max : 999999999999999999
				}
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cfif not directoryexists("#upload_folder#")>
		<cfdirectory action="create" directory="#upload_folder#">
	</cfif>
	<cffile action="write" file="#upload_folder##file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_5073,
				IS_5084,
				IS_5615,
				IS_4691,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#FILE_NAME#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				0,
				0,
				0,
				0,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>

<cfif get_puantajs_5921.recordcount>
	<cfscript>
		n_file_name = "#ListGetAt(file_name,1,'.')#_5921.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0014447";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_5921">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_5921.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun = 0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			kanun = "05921";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			ay_matrah_ozel = SSK_MATRAH * SSK_ISVEREN_HISSESI_5921_DAY / TOTAL_DAYS;
			
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
			{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
					}
				else if(total_kazanc lt SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
					}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
						if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
						{
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
							is_eksik_gun = 0;
						}
						else
						{
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun = 31;
						}
					else
					{
						//writeoutput("<script>alert('3.1 - #IZIN#');</script>");
						if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
						{
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;	// max : 30
							is_eksik_gun = 0;
						}
						else
						{
							if (aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - TOTAL_DAYS;	// max : 30
								is_eksik_gun = 31 - TOTAL_DAYS;
							}
							else
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun = IZIN;
							}
						}
					}
			}
			else
				{
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = SSK_ISVEREN_HISSESI_5921_DAY;	// max : 30
				}
			
			// bu ay içinde giriş ve/veya çıkışı varsa
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;
				if(paid_izinli_sunday_count gt 0 and paid_izinli_sunday_count lt izin_paid_yaz)
					izin_paid_yaz = izin_paid_yaz - paid_izinli_sunday_count;
									
				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				
				if (SSK_STATUTE neq 2)
				{
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UCRETLIIZINGUN"] = izin_paid_yaz;//ücretli izin gün  {max : 30} (optional)
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UIPEK"] = wrk_round(izin_paid_amount,2);//ücretli izin gün matrahı {max : 99999999999} (optional)
				}
				
				}
			if (izin gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
					if(is_eksik_gun gt 0)
					{
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
					}
				}
			if(is_eksik_gun gt 0)
			{	
				if(total_days gt SSK_ISVEREN_HISSESI_5921_DAY)
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = 13;	//aralık : 0-99 (optional)
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##n_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_5921,
				IS_5510,
				IS_5073,
				IS_5084,
				IS_5615,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#n_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				0,
				0,
				0,
				0,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>


<cfif get_puantajs_5746.recordcount>
	<cfscript>
		n_file_name = "#ListGetAt(file_name,1,'.')#_5746.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0005746";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_5746">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_5746.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			if (len(TRADE_UNION_DEDUCTION) and (TRADE_UNION_DEDUCTION gt 0)) kanun = "05746";
			// 20041012 bu satir alttaki hale geldi else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") ) kanun = "04857";
			//else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") and IS_SAKAT_KONTROL) kanun = "05746";
			else kanun = "05746";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if(len(SSK_DAYS_5746) and SSK_DAYS_5746 gt 0)
				ay_matrah_ozel = SSK_MATRAH_5746;
	
			is_eksik_gun = 0;
			
			if(month(start_date) eq month(bu_ay_basi) and year(start_date) eq year(bu_ay_basi))
				s_date_ = start_date;
			else	
				s_date_ = bu_ay_basi;
				
			if(len(finish_date) and month(finish_date) eq month(bu_ay_sonu) and year(finish_date) eq year(bu_ay_sonu))
				f_date_ = finish_date;
			else	
				f_date_ = bu_ay_sonu;
			
			kisi_aydaki_gun_sayisi = datediff('d',s_date_,f_date_) + 1;
	
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
				{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT + TOTAL_PAY - SSK_MATRAH_EXEMPTION);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST - SSK_MATRAH_EXEMPTION;
				total_ucret = total_kazanc - total_ikramiye;
				
				if(total_ucret gte SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
				}
				else if(total_kazanc gte SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
				}
				else if(total_kazanc lt SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
				}
				
				pek_tutar_ = wrk_round((total_matrah_yaz - ay_matrah_ozel),2);
				gun_ = TOTAL_DAYS - SSK_DAYS_5746;
				ek_gun = 0;
				SSK_DAYS_5746_ = SSK_DAYS_5746;
				
				maas_max_tutar = wrk_round(ssk_matrah_salary / 30 * gun_);
				ssk_max_tutar = wrk_round(tavan_matrah / 30 * gun_);
				if(pek_tutar_ gt ssk_max_tutar)
				{
					pek_tutar_ = maas_max_tutar;
					total_ikramiye_yaz = wrk_round(total_matrah_yaz - ay_matrah_ozel - pek_tutar_);
					pek_tutar_ = pek_tutar_ + total_ikramiye_yaz;
					gun_ = total_days;
					ek_gun = SSK_DAYS_5746;
					SSK_DAYS_5746_ = 0;
				}
				
				
				total_kazanc = ay_matrah_ozel;
				total_ikramiye = 0;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte ay_matrah_ozel)
					{
					total_matrah_yaz = ay_matrah_ozel;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte ay_matrah_ozel)
					{
					total_matrah_yaz = ay_matrah_ozel;
					total_ikramiye_yaz = ay_matrah_ozel - total_ucret;
					}
				else if(total_kazanc lt ay_matrah_ozel)
					{
					total_matrah_yaz = ay_matrah_ozel;
					total_ikramiye_yaz = total_ikramiye;
					}
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = SSK_DAYS_5746_;	// max : 30
					if(aydaki_gun_sayisi eq 31 and SSK_DAYS_5746_ eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun = 0;
					}
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
							{
							is_eksik_gun = 31;
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							}
						else
						{
							if (aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - SSK_DAYS_5746_;
								if((31 - total_days) gt 0)
								{is_eksik_gun = 31 - SSK_DAYS_5746_;}
							}
							else
							{
								if(kisi_aydaki_gun_sayisi eq 31 and (SSK_DAYS_5746_ + IZIN + TOTAL_DAYS) eq 31)
								{
									e_gun = kisi_aydaki_gun_sayisi - SSK_DAYS_5746_;
									my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = e_gun;// max : 30
									is_eksik_gun = e_gun;
								}
								else
								{
									e_gun = (TOTAL_DAYS - IZIN);
									if(kisi_aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30 and IZIN eq 0 and SSK_DAYS_5746_ eq 0)
										e_gun = 31;
									my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = e_gun;	// max : 30
									is_eksik_gun = e_gun;
								}
							}
						}
					}
				}
			else
				{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
				}
	
			// bu ay içinde giriş ve/veya çıkışı varsa
			
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;
												
				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				}
			if(is_eksik_gun gt 0)
			{		
			if(izin gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
			
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = 13;	//aralık : 0-99 (optional)
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##n_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_5746,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#n_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>

<cfif get_puantajs_4691.recordcount>
	<cfscript>
		n_file_name = "#ListGetAt(file_name,1,'.')#_4691.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0004691";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_4691">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_4691.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			if (len(TRADE_UNION_DEDUCTION) and (TRADE_UNION_DEDUCTION gt 0)) kanun = "04691";
			// 20041012 bu satir alttaki hale geldi else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") ) kanun = "04857";
			//else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") and IS_SAKAT_KONTROL) kanun = "04691";
			else kanun = "04691";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
				ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
				if(TOTAL_DAYS gt 0)
				ay_matrah_ozel = SSK_MATRAH / TOTAL_DAYS * SSK_ISVEREN_HISSESI_GOV_100_DAY;
	
			is_eksik_gun = 0;
	
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
				{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
					}
				else if(total_kazanc lt SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
					}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun = 0;
					}
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
							{
							is_eksik_gun = 31;
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							}
						else if(len(absent_days) and absent_days gt 0)
						{
							{
							is_eksik_gun = absent_days;
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = absent_days;
							}
						}
						else
						{
							if (aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;
								if((31 - total_days) gt 0)
								{is_eksik_gun = 31 - total_days;}
							}
							else
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;
								if(izin gt 0)
								{is_eksik_gun = IZIN;}
							}
						}
					}
				}
			else
				{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
				}
	
			// bu ay içinde giriş ve/veya çıkışı varsa
			
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;
												
				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				}
			if(is_eksik_gun gt 0)
			{		
			if(izin gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
			
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = 13;	//aralık : 0-99 (optional)
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##n_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_4691,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#n_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>

<cfif get_puantajs_6111.recordcount>
	<cfscript>
		n_file_name = "#ListGetAt(file_name,1,'.')#_6111.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0006111";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_6111">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_6111.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun = 0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			if (len(TRADE_UNION_DEDUCTION) and (TRADE_UNION_DEDUCTION gt 0)) kanun = "06111";
			// 20041012 bu satir alttaki hale geldi else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") ) kanun = "04857";
			//else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") and IS_SAKAT_KONTROL) kanun = "06111";
			else kanun = "06111";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
				ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
				if(TOTAL_DAYS gt 0)
				ay_matrah_ozel = SSK_MATRAH / TOTAL_DAYS * SSK_ISVEREN_HISSESI_GOV_100_DAY;
	
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
			{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
					}
				else if(total_kazanc lt SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
					}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun = 0;
					}
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
						{
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun = 31;
						}
						else
						{
							if (aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('5.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun = IZIN;
							}
						}
					}
			}
			else
			{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
			}
	
			// bu ay içinde giriş ve/veya çıkışı varsa
			
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;

				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				}
					
			if(izin gt 0)
			{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");

				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				if(is_eksik_gun gt 0)
				{
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##n_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_6111,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#n_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>
<!-- 6486 kanun duzenlemesi-->
<cfif get_puantajs_6486.recordcount>
	<cfscript>
		n_file_name = "#ListGetAt(file_name,1,'.')#_6486.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0006486";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_6486">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_6486.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun = 0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else if (SSK_STATUTE eq 21) belge_turu = "21";
			else belge_turu = "01";
			
			//if (len(TRADE_UNION_DEDUCTION) and (TRADE_UNION_DEDUCTION gt 0)) kanun = "6486";
			// 20041012 bu satir alttaki hale geldi else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") ) kanun = "04857";
			//else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") and IS_SAKAT_KONTROL) kanun = "06486";
			//else kanun = "6486";
			if(belge_turu eq '02')
			{kanun = "00000";}
			else if(listfind("21,4,5,6,13,29,30,32,33,35,36,1",SSK_STATUTE,',') and not len(get_puantajs_6486.kanun_6486))
			{kanun = "06486";}
			else
			{kanun = "#kanun_6486#6486";}
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
				ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
				if(TOTAL_DAYS gt 0)
				ay_matrah_ozel = SSK_MATRAH / TOTAL_DAYS * SSK_ISVEREN_HISSESI_GOV_100_DAY;
	
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
			{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
					}
				else if(total_kazanc lt SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
					}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun = 0;
					}
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
						{	
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun = 31;
						}
						else if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi lt 30)	// 29 ve 28 çeken şubat ayı için bu eklenmiştir.
						{	
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = aydaki_gun_sayisi;
							is_eksik_gun = aydaki_gun_sayisi;
						}
						else
						{
							if (aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('5.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun = IZIN;
							}
						}
					 }
			}
			else
			{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
			}
	
			// bu ay içinde giriş ve/veya çıkışı varsa
			
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;

				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				}
					
			if(izin gt 0)
			{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
			if(is_eksik_gun gt 0)
			{
				if(duty_type eq 6 and (not isdefined("get_emp_izins_2.recordcount") or not get_emp_izins_2.recordcount))
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = 6;
				else
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##n_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_6486,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#n_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>
<!-- //6486 -->
<!-- 6322 kanun duzenlemesi-->
<cfif get_puantajs_6322.recordcount>
	<cfscript>
		n_file_name = "#ListGetAt(file_name,1,'.')#_6322.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0006322";

		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_6322">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_6322.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun =0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			if(belge_turu eq '02')
			kanun = "00000";
			else
			kanun = "#KANUN_6322#6322";
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
				ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
				if(TOTAL_DAYS gt 0)
				ay_matrah_ozel = SSK_MATRAH / TOTAL_DAYS * SSK_ISVEREN_HISSESI_GOV_100_DAY;
	
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
			{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
					}
				else if(total_kazanc lt SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
					}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun =0;
					}
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
							{my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun =31;
							}
						else
						{
							if (aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun =31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('5.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun =IZIN;
							}
						}
					 }
			}
			else
			{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
			}
	
			// bu ay içinde giriş ve/veya çıkışı varsa
			
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;

				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				}
					
			if(izin gt 0)
			{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
			if(is_eksik_gun gt 0)
			{
				if(duty_type eq 6 and (not isdefined("get_emp_izins_2.recordcount") or not get_emp_izins_2.recordcount))
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = 6;
				else				
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##n_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,

				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_6322,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#n_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>
<!-- //6322 -->

<!-- 25510 kanun duzenlemesi-->
<cfif get_puantajs_25510.recordcount>
	<cfscript>
		n_file_name = "#ListGetAt(file_name,1,'.')#_25510.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0025510";

		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_25510">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_25510.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun =0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			if(belge_turu eq '02')
			kanun = "00000";
			else
			kanun = "25510";
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
				ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
				if(TOTAL_DAYS gt 0)
				ay_matrah_ozel = SSK_MATRAH / TOTAL_DAYS * SSK_ISVEREN_HISSESI_GOV_100_DAY;
	
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
			{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
					}
				else if(total_kazanc lt SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
					}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun =0;
					}
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
							{my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun =31;
							}
						else
						{
							if (aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('5.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun =IZIN;
							}
						}
					 }
			}
			else
			{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
			}
	
			// bu ay içinde giriş ve/veya çıkışı varsa
			
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;

				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				}
					
			if(izin gt 0)
			{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
			if(is_eksik_gun gt 0)
			{
				if(duty_type eq 6 and (not isdefined("get_emp_izins_2.recordcount") or not get_emp_izins_2.recordcount))
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = 6;
				else				
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##n_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_25510,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#n_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',

				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>
<!-- //25510 -->

<cfif get_puantajs_n_tesvik_100.recordcount>
	<cfscript>
		n_file_name = "#ListGetAt(file_name,1,'.')#_5673n_100.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0014447";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_n_tesvik_100">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_n_tesvik_100.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun =0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			if (len(TRADE_UNION_DEDUCTION) and (TRADE_UNION_DEDUCTION gt 0)) kanun = "04369";
			// 20041012 bu satir alttaki hale geldi else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") ) kanun = "04857";
			//else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") and IS_SAKAT_KONTROL) kanun = "04857";
			else kanun = "14447";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
				ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
				if(TOTAL_DAYS gt 0)
				ay_matrah_ozel = SSK_MATRAH / TOTAL_DAYS * SSK_ISVEREN_HISSESI_GOV_100_DAY;
	
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
				{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
					}
				else if(total_kazanc lt SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
					}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = SSK_ISVEREN_HISSESI_GOV_100_DAY;	// max : 30
					if(aydaki_gun_sayisi eq 31 and SSK_ISVEREN_HISSESI_GOV_100_DAY eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun =0;
					}
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
							{my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun =31;}
						else
						{
							if (aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('6.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun =IZIN;
							}
						}
					}
				}
			else
				{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = SSK_ISVEREN_HISSESI_GOV_100_DAY;	// max : 30
				}
	
			// bu ay içinde giriş ve/veya çıkışı varsa
			
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;
												
				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				}
					
			if(izin gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				if(is_eksik_gun gt 0){
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
				}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##n_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_5510,
				IS_5073,
				IS_5084,
				IS_5615,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#n_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				0,
				0,
				0,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>

<cfif get_puantajs_n_tesvik_80.recordcount>
	<cfscript>
			n_file_name = "#ListGetAt(file_name,1,'.')#_5673n_80.xml";
			my_doc = XmlNew();
			my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
			my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
			my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
			my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
			my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
			my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
			my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
			my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
			my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
			my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
			my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
			belge_ve_kanun = "0084447";
			bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_n_tesvik_80">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_n_tesvik_80.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun =0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			if (len(TRADE_UNION_DEDUCTION) and (TRADE_UNION_DEDUCTION gt 0)) kanun = "04369";
			// 20041012 bu satir alttaki hale geldi else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") ) kanun = "04857";
			//else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") and IS_SAKAT_KONTROL) kanun = "04857";
			else kanun = "84447";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
			{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
			}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
				ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
				if(TOTAL_DAYS gt 0)
				ay_matrah_ozel = SSK_MATRAH / TOTAL_DAYS * SSK_ISVEREN_HISSESI_GOV_80_DAY;
	
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
			{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
	
				if(total_ucret gte SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
				}
				else if(total_kazanc gte SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
				}
				else if(total_kazanc lt SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
				}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = SSK_ISVEREN_HISSESI_GOV_80_DAY;	// max : 30
				if(aydaki_gun_sayisi eq 31 and SSK_ISVEREN_HISSESI_GOV_80_DAY eq 30)
				{
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
					is_eksik_gun =0;
				}
				else
				{
					if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
						{my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
						is_eksik_gun =31;}
					else
					{
						if(aydaki_gun_sayisi eq 31 and duty_type eq 6)
						{
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
							is_eksik_gun = 31 - total_days;
						}
						else
						{
							//writeoutput("<script>alert('7.1 - #IZIN#');</script>");
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
							is_eksik_gun =IZIN;
						}
					}
				}
			}
			else
			{	
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = SSK_ISVEREN_HISSESI_GOV_80_DAY;	// max : 30
			}
	
			// bu ay içinde giriş ve/veya çıkışı varsa
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
			{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
				{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
				}
			}
			if (izin_paid gt 0)
			{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;
	
				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
			}
	
			if(izin gt 0)
			{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				if(is_eksik_gun gt 0){
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##n_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_5510,
				IS_5073,
				IS_5084,
				IS_5615,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#n_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				0,
				0,
				0,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>

<cfif get_puantajs_n_tesvik_60.recordcount>
	<cfscript>
		n_file_name = "#ListGetAt(file_name,1,'.')#_5673n_60.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0064447";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_n_tesvik_60">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_n_tesvik_60.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun =0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			if (len(TRADE_UNION_DEDUCTION) and (TRADE_UNION_DEDUCTION gt 0)) kanun = "04369";
			// 20041012 bu satir alttaki hale geldi else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") ) kanun = "04857";
			//else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") and IS_SAKAT_KONTROL) kanun = "04857";
			else kanun = "64447";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
			ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
			if(TOTAL_DAYS gt 0)
			ay_matrah_ozel = SSK_MATRAH / TOTAL_DAYS * SSK_ISVEREN_HISSESI_GOV_80_DAY;
	
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
				{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
					}
				else if(total_kazanc lt SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
					}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = SSK_ISVEREN_HISSESI_GOV_60_DAY;	// max : 30
					if(aydaki_gun_sayisi eq 31 and SSK_ISVEREN_HISSESI_GOV_60_DAY eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun =0;
					}
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
							{my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun =31;}
						else
						{
							if (aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('8.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun =IZIN;
							}
						}
					}
				}
			else
				{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = SSK_ISVEREN_HISSESI_GOV_60_DAY;	// max : 30
				}
	
			// bu ay içinde giriş ve/veya çıkışı varsa
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;
												
				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				}
					
			if(izin gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				if(is_eksik_gun gt 0)
				{my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##n_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_5510,
				IS_5073,
				IS_5084,
				IS_5615,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#n_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				0,
				0,
				0,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>

<cfif get_puantajs_n_tesvik_40.recordcount>
	<cfscript>
		n_file_name = "#ListGetAt(file_name,1,'.')#_5673n_40.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0044447";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_n_tesvik_40">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_n_tesvik_40.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun =0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			if (len(TRADE_UNION_DEDUCTION) and (TRADE_UNION_DEDUCTION gt 0)) kanun = "04369";
			// 20041012 bu satir alttaki hale geldi else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") ) kanun = "04857";
			//else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") and IS_SAKAT_KONTROL) kanun = "04857";
			else kanun = "44447";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
			ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
			if(TOTAL_DAYS gt 0)
			ay_matrah_ozel = SSK_MATRAH / TOTAL_DAYS * SSK_ISVEREN_HISSESI_GOV_80_DAY;
	
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
				{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
					}
				else if(total_kazanc lt SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
					}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = SSK_ISVEREN_HISSESI_GOV_40_DAY;	// max : 30
					if(aydaki_gun_sayisi eq 31 and SSK_ISVEREN_HISSESI_GOV_40_DAY eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun =0;
					}
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
							{my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun =31;}
						else
						{
							if(aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('9.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun =IZIN;
							}
						}
					}
				}
			else
				{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = SSK_ISVEREN_HISSESI_GOV_40_DAY;	// max : 30
				}
	
			// bu ay içinde giriş ve/veya çıkışı varsa
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;
												
				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				}
					
			if(izin gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				if(is_eksik_gun gt 0){
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##n_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_5510,
				IS_5073,
				IS_5084,
				IS_5615,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#n_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				0,
				0,
				0,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>

<cfif get_puantajs_n_tesvik_20.recordcount>
	<cfscript>
		n_file_name = "#ListGetAt(file_name,1,'.')#_5673n_20.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0024447";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_n_tesvik_20">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_n_tesvik_20.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun =0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			if (len(TRADE_UNION_DEDUCTION) and (TRADE_UNION_DEDUCTION gt 0)) kanun = "04369";
			// 20041012 bu satir alttaki hale geldi else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") ) kanun = "04857";
			//else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") and IS_SAKAT_KONTROL) kanun = "04857";
			else kanun = "24447";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
			ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
			if(TOTAL_DAYS gt 0)
			ay_matrah_ozel = SSK_MATRAH / TOTAL_DAYS * SSK_ISVEREN_HISSESI_GOV_80_DAY;
	
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
				{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
					}
				else if(total_kazanc lt SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
					}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = SSK_ISVEREN_HISSESI_GOV_20_DAY;	// max : 30
					if(aydaki_gun_sayisi eq 31 and SSK_ISVEREN_HISSESI_GOV_20_DAY eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun =0;
					}
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
							{my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun =31;}
						else
						{
							if(aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('10.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun =IZIN;
							}
						}
					}
				}
			else
				{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = SSK_ISVEREN_HISSESI_GOV_20_DAY;	// max : 30
				}
	
			// bu ay içinde giriş ve/veya çıkışı varsa
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;
												
				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				}
					
			if(izin gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				if(is_eksik_gun gt 0){
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##n_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_5510,
				IS_5073,
				IS_5084,
				IS_5615,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#n_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				0,
				0,
				0,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>

<cfif get_puantajs_sf_tesvik.recordcount>
	<cfscript>
		sf_file_name = "#ListGetAt(file_name,1,'.')#_5673sf.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0014857";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_sf_tesvik">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_sf_tesvik.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun =0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			kanun = "14857";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
			ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
			ay_matrah_ozel = SSK_MATRAH;
			
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
				{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
					}
				else if(total_kazanc lt SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
					}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun =0;
					}					
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
							{my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun =31;}
						else
						{
							if(aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('11.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun =IZIN;
							}
						}
					}
				}
			else
				{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
				}
			
			
			
			// bu ay içinde giriş ve/veya çıkışı varsa
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;
					
				if(paid_izinli_sunday_count gt 0 and paid_izinli_sunday_count lt izin_paid_yaz)
					izin_paid_yaz = izin_paid_yaz - paid_izinli_sunday_count;
					
					
				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				
				if (SSK_STATUTE neq 2)
				{
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UCRETLIIZINGUN"] = izin_paid_yaz;//ücretli izin gün  {max : 30} (optional)
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UIPEK"] = wrk_round(izin_paid_amount,2);//ücretli izin gün matrahı {max : 99999999999} (optional)
				}
				
				}
			if (izin gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				if(is_eksik_gun gt 0){
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
				}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##sf_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_5510,
				IS_5073,
				IS_5084,
				IS_5615,
                IS_14857,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#sf_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				0,
				0,
				0,
				0,
                1,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>

<!---46486--->
<cfif get_puantajs_46486.recordcount>
	<cfscript>
		sf_file_name = "#ListGetAt(file_name,1,'.')#_46486sf.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0046486";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_46486">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_46486.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun =0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 8) belge_turu = "08";
			else if (SSK_STATUTE eq 9) belge_turu = "09";
			else if (SSK_STATUTE eq 10) belge_turu = "10";
			else belge_turu = "01";
			
			kanun = "046486";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
			ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
			ay_matrah_ozel = SSK_MATRAH;
			
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
				{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
				}
				else if(total_kazanc gte SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
				}
				else if(total_kazanc lt SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
				}
				if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun =0;
					}					
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
							{my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun =31;}
						else
						{
							if(aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('11.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun =IZIN;
							}
						}
					}
				}
			else
				{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
				}

			// bu ay içinde giriş ve/veya çıkışı varsa
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;
					
				if(paid_izinli_sunday_count gt 0 and paid_izinli_sunday_count lt izin_paid_yaz)
					izin_paid_yaz = izin_paid_yaz - paid_izinli_sunday_count;
					
					
				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				
				if (SSK_STATUTE neq 2)
				{
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UCRETLIIZINGUN"] = izin_paid_yaz;//ücretli izin gün  {max : 30} (optional)
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UIPEK"] = wrk_round(izin_paid_amount,2);//ücretli izin gün matrahı {max : 99999999999} (optional)
				}
				
				}
			if (izin gt 0)
			{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				if(is_eksik_gun gt 0){
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
			}
		}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##sf_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_5510,
				IS_5073,
				IS_5084,
				IS_5615,
                IS_6645,
                IS_46486,
                IS_56486,
                IS_66486,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#sf_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				0,
				0,
				0,
				0,
                0,
                1,
                0,
                0,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>
<!---56486--->
<cfif get_puantajs_56486.recordcount>
	<cfscript>
		sf_file_name = "#ListGetAt(file_name,1,'.')#_56486sf.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0056486";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_56486">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_56486.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun =0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 8) belge_turu = "08";
			else if (SSK_STATUTE eq 9) belge_turu = "09";
			else if (SSK_STATUTE eq 10) belge_turu = "10";
			else belge_turu = "01";
			
			kanun = "056486";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
			ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
			ay_matrah_ozel = SSK_MATRAH;
			
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
				{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
				}
				else if(total_kazanc gte SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
				}
				else if(total_kazanc lt SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
				}
				if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun =0;
					}					
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
							{my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun =31;}
						else
						{
							if(aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('11.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun =IZIN;
							}
						}
					}
				}
			else
				{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
				}

			// bu ay içinde giriş ve/veya çıkışı varsa
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;
					
				if(paid_izinli_sunday_count gt 0 and paid_izinli_sunday_count lt izin_paid_yaz)
					izin_paid_yaz = izin_paid_yaz - paid_izinli_sunday_count;
					
					
				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				
				if (SSK_STATUTE neq 2)
				{
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UCRETLIIZINGUN"] = izin_paid_yaz;//ücretli izin gün  {max : 30} (optional)
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UIPEK"] = wrk_round(izin_paid_amount,2);//ücretli izin gün matrahı {max : 99999999999} (optional)
				}
				
				}
			if (izin gt 0)
			{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				if(is_eksik_gun gt 0){
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
			}
		}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##sf_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_5510,
				IS_5073,
				IS_5084,
				IS_5615,
                IS_6645,
                IS_46486,
                IS_56486,
                IS_66486,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#sf_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				0,
				0,
				0,
				0,
                0,
                0,
                1,
                0,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>
<!---66486--->
<cfif get_puantajs_66486.recordcount>
	<cfscript>
		sf_file_name = "#ListGetAt(file_name,1,'.')#_66486sf.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0066486";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_66486">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_66486.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun =0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 8) belge_turu = "08";
			else if (SSK_STATUTE eq 9) belge_turu = "09";
			else if (SSK_STATUTE eq 10) belge_turu = "10";
			else belge_turu = "01";
			
			kanun = "066486";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
			ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
			ay_matrah_ozel = SSK_MATRAH;
			
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
				{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
				}
				else if(total_kazanc gte SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
				}
				else if(total_kazanc lt SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
				}
				if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun =0;
					}					
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
							{my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun =31;}
						else
						{
							if(aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('11.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun =IZIN;
							}
						}
					}
				}
			else
				{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
				}

			// bu ay içinde giriş ve/veya çıkışı varsa
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;
					
				if(paid_izinli_sunday_count gt 0 and paid_izinli_sunday_count lt izin_paid_yaz)
					izin_paid_yaz = izin_paid_yaz - paid_izinli_sunday_count;
					
					
				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				
				if (SSK_STATUTE neq 2)
				{
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UCRETLIIZINGUN"] = izin_paid_yaz;//ücretli izin gün  {max : 30} (optional)
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UIPEK"] = wrk_round(izin_paid_amount,2);//ücretli izin gün matrahı {max : 99999999999} (optional)
				}
				
				}
			if (izin gt 0)
			{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				if(is_eksik_gun gt 0){
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
			}
		}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##sf_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_5510,
				IS_5073,
				IS_5084,
				IS_5615,
                IS_6645,
                IS_46486,
                IS_56486,
                IS_66486,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#sf_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				0,
				0,
				0,
				0,
                0,
                0,
                0,
                1,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>
<cfif get_puantaj_egtm_tesvik.recordcount>
	<cfscript>
		sf_file_name = "#ListGetAt(file_name,1,'.')#_6645sf.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0006645";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantaj_egtm_tesvik">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantaj_egtm_tesvik.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun =0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 8) belge_turu = "08";
			else if (SSK_STATUTE eq 9) belge_turu = "09";
			else if (SSK_STATUTE eq 10) belge_turu = "10";
			else belge_turu = "01";
			
			kanun = "06645";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
			ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
			ay_matrah_ozel = SSK_MATRAH;
			
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
				{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
				}
				else if(total_kazanc gte SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
				}
				else if(total_kazanc lt SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
				}
				if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun =0;
					}					
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
							{my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun =31;}
						else
						{
							if(aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('11.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun =IZIN;
							}
						}
					}
				}
			else
				{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
				}

			// bu ay içinde giriş ve/veya çıkışı varsa
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;
					
				if(paid_izinli_sunday_count gt 0 and paid_izinli_sunday_count lt izin_paid_yaz)
					izin_paid_yaz = izin_paid_yaz - paid_izinli_sunday_count;
					
					
				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				
				if (SSK_STATUTE neq 2)
				{
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UCRETLIIZINGUN"] = izin_paid_yaz;//ücretli izin gün  {max : 30} (optional)
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UIPEK"] = wrk_round(izin_paid_amount,2);//ücretli izin gün matrahı {max : 99999999999} (optional)
				}
				
				}
			if (izin gt 0)
			{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				if(is_eksik_gun gt 0){
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
			}
		}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##sf_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_5510,
				IS_5073,
				IS_5084,
				IS_5615,
                IS_6645,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#sf_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				0,
				0,
				0,
				0,
                1,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>
<!---
<cfif get_puantajs_sy_tesvik.recordcount>
	<cfscript>
		sy_file_name = "#ListGetAt(file_name,1,'.')#_5673sy.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		belge_ve_kanun = "0054857";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_sy_tesvik">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_sy_tesvik.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun =0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			kanun = "54857";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
			ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
			ay_matrah_ozel = SSK_MATRAH;
	
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
				{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
					}
				else if(total_kazanc lt SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
					}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				 if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
					{

						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun =0;
					}
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
							{my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun =31;}
						else
						{
							if (aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('12.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun =IZIN;
							}
						}
					}
				}
			else
				{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
				}
			
			// bu ay içinde giriş ve/veya çıkışı varsa
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;
					
				if(paid_izinli_sunday_count gt 0 and paid_izinli_sunday_count lt izin_paid_yaz)
					izin_paid_yaz = izin_paid_yaz - paid_izinli_sunday_count;
					
					
				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				
				if (SSK_STATUTE neq 2)
				{
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UCRETLIIZINGUN"] = izin_paid_yaz;//ücretli izin gün  {max : 30} (optional)
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UIPEK"] = wrk_round(izin_paid_amount,2);//ücretli izin gün matrahı {max : 99999999999} (optional)
				}
				
				}
			if (izin gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
						if (get_emp_izins_2.EBILDIRGE_TYPE_ID[geii-1] neq get_emp_izins_2.EBILDIRGE_TYPE_ID[geii])
							eksik_neden_id = 12; // birden fazla
				if(is_eksik_gun gt 0){
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
			}	
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##sy_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_5510,
				IS_5073,
				IS_5084,
				IS_5615,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#sy_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				0,
				0,
				0,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>
--->
<cfif get_5073.recordcount>
	<cfscript>
		file_name = "#ListGetAt(file_name,1,'.')#_5073.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50);; //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0000000";
		bordro_index = 2;	
	</cfscript>
	
	<cfoutput query="get_5073">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_5073.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			//writeoutput('EMPLOYEE_NAME:#EMPLOYEE_NAME#_EMPLOYEE_SURNAME:#EMPLOYEE_SURNAME#_izin_paid:#izin_paid#_izin:#izin#<br/>');
			// bu eleman gruplara göre oluşturulacak halloldu sıralama yapınca zaten gruplamaya gerek kalmadı erk 20040527
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			if (len(TRADE_UNION_DEDUCTION) and (TRADE_UNION_DEDUCTION gt 0)) kanun = "04369";
			// 20041012 bu satir alttaki hale geldi else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") ) kanun = "04857";
			//else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") and IS_SAKAT_KONTROL) kanun = "04857";
			else kanun = "00000";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
			ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
			ay_matrah_ozel = SSK_MATRAH;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
	
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
			// bu ay içinde giriş ve/veya çıkışı varsa
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d", FINISH_DATE, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount)) izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else izin_paid_yaz = izin_paid ;
				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				
				if(paid_izinli_sunday_count gt 0 and paid_izinli_sunday_count lt izin_paid_yaz)
					izin_paid_yaz = izin_paid_yaz - paid_izinli_sunday_count;
				
				if (SSK_STATUTE neq 2)
				{
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UCRETLIIZINGUN"] = izin_paid_yaz;//ücretli izin gün  {max : 30} (optional)
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UIPEK"] = wrk_round(izin_paid_amount,2);//ücretli izin gün matrahı {max : 99999999999} (optional)
				}
				}
			if (izin gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_5073,
				IS_5084,
				IS_5615,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#FILE_NAME#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_5073.recordcount#,
				1,
				0,
				1,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>

<cfif (get_ssk_isyeri.KANUN_5084_ORAN gt 0) and (get_5084.recordcount)>
	<cfscript>
		file_name = "#ListGetAt(file_name,1,'.')#_5084.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000");//aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50);; //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0000000";
		bordro_index = 2;	
	</cfscript>
	
	<cfoutput query="get_5084">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_5084.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			//writeoutput('EMPLOYEE_NAME:#EMPLOYEE_NAME#_EMPLOYEE_SURNAME:#EMPLOYEE_SURNAME#_izin_paid:#izin_paid#_izin:#izin#<br/>');
			// bu eleman gruplara göre oluşturulacak halloldu sıralama yapınca zaten gruplamaya gerek kalmadı erk 20040527
			is_eksik_gun =0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			if(get_ssk_isyeri.is_5615 eq 1 and get_ssk_isyeri.KANUN_5084_ORAN eq 80 and SSK_STATUTE eq 1) kanun = "85615";
			else if(get_ssk_isyeri.is_5615 eq 1 and get_ssk_isyeri.KANUN_5084_ORAN eq 100 and SSK_STATUTE eq 1) kanun = "05615";
			else if (get_ssk_isyeri.KANUN_5084_ORAN eq 80) kanun = "85084";
			else if (get_ssk_isyeri.KANUN_5084_ORAN eq 100) kanun = "05084";
			else if (len(TRADE_UNION_DEDUCTION) and (TRADE_UNION_DEDUCTION gt 0)) kanun = "04369";
			// 20041012 bu satir alttaki hale geldi else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") ) kanun = "04857";
			//else if ( (DEFECTION_LEVEL neq 0) and (belge_turu neq "02") and IS_SAKAT_KONTROL) kanun = "04857";
			else kanun = "00000";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
			{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
			}

			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
				//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
			{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
				}
				else if(total_kazanc gte SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
				}
				else if(total_kazanc lt SSK_MATRAH)
				{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
				}
				if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
				if(SSK_ISVEREN_HISSESI_5921 gt 0 and (TOTAL_DAYS + IZIN) gt SSK_ISVEREN_HISSESI_5921_DAY)
				{
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz / TOTAL_DAYS * (TOTAL_DAYS - SSK_ISVEREN_HISSESI_5921_DAY),2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz / TOTAL_DAYS * (TOTAL_DAYS - SSK_ISVEREN_HISSESI_5921_DAY),2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS - SSK_ISVEREN_HISSESI_5921_DAY;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS - SSK_ISVEREN_HISSESI_5921_DAY eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun =0;
					}
					else
					{
						if(izin gt 0)
						{is_eksik_gun =SSK_ISVEREN_HISSESI_5921_DAY + IZIN;
							//writeoutput("<script>alert('13.1 - #IZIN#');</script>");
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = SSK_ISVEREN_HISSESI_5921_DAY + IZIN;	// max : 30
						}
						else{
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = SSK_ISVEREN_HISSESI_5921_DAY;	// max : 30
							is_eksik_gun =SSK_ISVEREN_HISSESI_5921_DAY;}
					}
				}
				else
				{
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun =0;
					}
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
							{my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun =31;}
						else
						{
							if (aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('14.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun =IZIN;
							}
						}	
						
						if(salary_type eq 1 and aydaki_gun_sayisi eq 31 and total_days eq 30)
						{
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
							is_eksik_gun =0;
						}		
					}
				}
			}
			else
			{	
				ay_matrah_ozel = SSK_MATRAH * SSK_ISVEREN_HISSESI_5921_DAY / TOTAL_DAYS;
				if(SSK_ISVEREN_HISSESI_5921 gt 0 and (TOTAL_DAYS + IZIN) gt SSK_ISVEREN_HISSESI_5921_DAY)
				{
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel / TOTAL_DAYS * (TOTAL_DAYS - SSK_ISVEREN_HISSESI_5921_DAY),2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS - SSK_ISVEREN_HISSESI_5921_DAY;	// max : 30
				}
				else
				{
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
				}
			}
				
			// bu ay içinde giriş ve/veya çıkışı varsa
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
			{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0) ) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d", FINISH_DATE, BU_AY_SONU) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
				{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
				}
			}
			if (izin_paid gt 0)
			{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount)) izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else izin_paid_yaz = izin_paid ;
				
				if(paid_izinli_sunday_count gt 0 and paid_izinli_sunday_count lt izin_paid_yaz)
					izin_paid_yaz = izin_paid_yaz - paid_izinli_sunday_count;
					
				if(total_days gt 0)
					izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				else
					izin_paid_amount = 0;

				if (SSK_STATUTE neq 2)
				{
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UCRETLIIZINGUN"] = izin_paid_yaz;//ücretli izin gün  {max : 30} (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["UIPEK"] = wrk_round(izin_paid_amount,2);//ücretli izin gün matrahı {max : 99999999999} (optional)
				}
			}
			
			if(salary_type eq 1 and aydaki_gun_sayisi eq 31 and total_days eq 30)
			{
				writeoutput(' ');
			}
			else
			{
				if (izin gt 0)
				{
					get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
					eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
					if (not len(eksik_neden_id)) eksik_neden_id = 13;
					if (get_emp_izins_2.recordcount gte 2)
						for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
						{
							eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
							if(listlen(eksikGunler,',') gte 2)
							{
								if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
									eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
								}else if(ListFindNoCase(eksikGunler,28)){
									eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
								}else if(ListFindNoCase(eksikGunler,27)){
									eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
								}else{
									eksik_neden_id = 12; // birden fazla
								}
							}
						}
					if(is_eksik_gun gt 0){
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
				}
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_5073,
				IS_5084,
				IS_5615,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#FILE_NAME#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_5084.recordcount#,
				0,
				1,
				<cfif get_5084.recordcount and get_ssk_isyeri.is_5615 eq 1>1,<cfelse>0,</cfif>
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>

<cfif get_puantajs_687.recordcount>
	<cfscript>
		n_file_name = "#ListGetAt(file_name,1,'.')#_687.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0000687";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_687">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_687.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun = 0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			kanun = "00687";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
				ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
				if(TOTAL_DAYS gt 0)
				ay_matrah_ozel = SSK_MATRAH / TOTAL_DAYS * SSK_ISVEREN_HISSESI_GOV_100_DAY;
	
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
			{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
					}
				else if(total_kazanc lt SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
					}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun = 0;
					}
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
						{
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun = 31;
						}
						else
						{
							if (aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('5.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun = IZIN;
							}
						}
					}
			}
			else
			{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
			}
	
			// bu ay içinde giriş ve/veya çıkışı varsa
			
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;

				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				}
					
			if(izin gt 0)
			{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				if(is_eksik_gun gt 0)
				{
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##n_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_687,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#n_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>

<!---17103 --->
<cfif get_puantajs_17103.recordcount>
	<cfscript>
		n_file_name = "#ListGetAt(file_name,1,'.')#_17103.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0017103";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_17103">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_17103.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun = 0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			kanun = "17103";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
				ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
				if(TOTAL_DAYS gt 0)
				ay_matrah_ozel = SSK_MATRAH / TOTAL_DAYS * SSK_ISVEREN_HISSESI_GOV_100_DAY;
	
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
			{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
					}
				else if(total_kazanc lt SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
					}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun = 0;
					}
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
						{
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun = 31;
						}
						else
						{
							if (aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('5.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun = IZIN;
							}
						}
					}
			}
			else
			{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
			}
	
			// bu ay içinde giriş ve/veya çıkışı varsa
			
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;

				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				}
					
			if(izin gt 0)
			{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				if(is_eksik_gun gt 0)
				{
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##n_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_17103,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#n_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>

<!---27103 --->
<cfif get_puantajs_27103.recordcount>
	<cfscript>
		n_file_name = "#ListGetAt(file_name,1,'.')#_27103.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0027103";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_27103">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_27103.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun = 0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			kanun = "27103";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
				ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
				if(TOTAL_DAYS gt 0)
				ay_matrah_ozel = SSK_MATRAH / TOTAL_DAYS * SSK_ISVEREN_HISSESI_GOV_100_DAY;
	
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
			{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
					}
				else if(total_kazanc lt SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
					}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun = 0;
					}
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
						{
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun = 31;
						}
						else
						{
							if (aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('5.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun = IZIN;
							}
						}
					}
			}
			else
			{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
			}
	
			// bu ay içinde giriş ve/veya çıkışı varsa
			
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;

				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				}
					
			if(izin gt 0)
			{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				if(is_eksik_gun gt 0)
				{
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##n_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_27103,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#n_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>

<!---37103 --->
<cfif get_puantajs_37103.recordcount>
	<cfscript>
		n_file_name = "#ListGetAt(file_name,1,'.')#_37103.xml";
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc, "AYLIKBILDIRGELER");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1] = XmlElemNew(my_doc, "ISYERI");
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERISICIL"] = get_ssk_isyeri.SSK_ISYERI_NO; //21 karakter olmalı
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["KONTROLNO"] = get_ssk_isyeri.ssk_cd; //aralık : 1-97
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIARACINO"] = iif(len(left(get_ssk_isyeri.SSK_AGENT,3)) eq 3,"#left(get_ssk_isyeri.SSK_AGENT,3)#","000"); //aralık : 0-999
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIUNVAN"] = left(get_ssk_isyeri.BRANCH_FULLNAME,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIADRES"] = left(get_ssk_isyeri.BRANCH_ADDRESS,50); //max 50 karakter
		my_doc.AYLIKBILDIRGELER.XmlChildren[1].XmlAttributes["ISYERIVERGINO"] = get_ssk_isyeri.TAX_NO; //double tipinde
		my_doc.AYLIKBILDIRGELER.XmlChildren[2] = XmlElemNew(my_doc, "BORDRO");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMAY"] = iif(len(attributes.sal_mon) eq 1,"0#attributes.sal_mon#","#attributes.sal_mon#");
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["DONEMYIL"] = attributes.sal_year; // max : 2050
		my_doc.AYLIKBILDIRGELER.XmlChildren[2].XmlAttributes["BELGEMAHIYET"] = attributes.doc_nat;
		belge_ve_kanun = "0037103";
		bordro_index = 2;
	</cfscript>
	
	<cfoutput query="get_puantajs_37103">
		<cfquery name="get_odeneks" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_rows_ext WHERE EMPLOYEE_PUANTAJ_ID = #get_puantajs_17103.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		<cfscript>
			is_eksik_gun = 0;
			satir = currentrow;
			ay_matrah_ozel = 0;
			if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 60) belge_turu = "29";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 90) belge_turu = "32";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1 and DAYS_506 eq 180) belge_turu = "35";
			else if(SSK_STATUTE eq 1 and len(IS_USE_506) and IS_USE_506 eq 1) belge_turu = "03";
			else if(SSK_STATUTE eq 32) belge_turu = "32";
			else if (SSK_STATUTE eq 1) belge_turu = "01";
			else if (SSK_STATUTE eq 2) belge_turu = "02";
			else if (SSK_STATUTE eq 3) belge_turu = "22";
			else if (SSK_STATUTE eq 75) belge_turu = "07";
			else if (SSK_STATUTE eq 4) belge_turu = "07";
			else if (SSK_STATUTE eq 5) belge_turu = "10";
			else if (SSK_STATUTE eq 6) belge_turu = "15";
			else if (SSK_STATUTE eq 71) belge_turu = "15";
			else if (SSK_STATUTE eq 12) belge_turu = "13";
			else belge_turu = "01";
			
			kanun = "37103";
			
			if (belge_ve_kanun is not "#belge_turu##kanun#")
				{
				belge_ve_kanun = "#belge_turu##kanun#";
				bordro_index = bordro_index+1;
				sigortali_index = 0;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index] = XmlElemNew(my_doc, "BILDIRGELER");
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["BELGETURU"] = belge_turu;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlAttributes["KANUN"] = kanun;
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1] = XmlElemNew(my_doc, "SIGORTALILAR");
				}
			sigortali_index = sigortali_index+1;
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index] = XmlElemNew(my_doc, "SIGORTALI");
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIRA"] = sigortali_index; // aralık : 1 - 99999
			//my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SIGORTALISICIL"] = SSK_NO; // aralık : 1-9999999999999
			if (len(TC_IDENTY_NO))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["TCKNO"] = left(TC_IDENTY_NO,11); // aralık : 10000000000-99999999999
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["AD"] = Left(EMPLOYEE_NAME,18); // max 18 hane
			my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["SOYAD"] = Left(EMPLOYEE_SURNAME,18); // max 18 hane
			if (len(Left(LAST_SURNAME,18)))
				my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ILKSOYAD"] = Left(LAST_SURNAME,18); // max 18 hane (optional)
			
			if((attributes.sal_mon eq 12) and (attributes.sal_year eq 2004))
				ay_matrah_ozel = (round(SSK_MATRAH/10000)/100);
			else
				if(TOTAL_DAYS gt 0)
				ay_matrah_ozel = SSK_MATRAH / TOTAL_DAYS * SSK_ISVEREN_HISSESI_GOV_100_DAY;
	
			if(attributes.sal_year gt 2010 or (attributes.sal_year eq 2010 and attributes.sal_mon gt 6))
			{
				total_kazanc = TOTAL_SALARY - (SSK_DEVIR + SSK_DEVIR_LAST + TOTAL_PAY_TAX + KIDEM_AMOUNT + IHBAR_AMOUNT);
				total_ikramiye = TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + SSK_DEVIR + SSK_DEVIR_LAST;
				total_ucret = total_kazanc - total_ikramiye;
				if(total_ucret gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = 0;
					}
				else if(total_kazanc gte SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = SSK_MATRAH - total_ucret;
					}
				else if(total_kazanc lt SSK_MATRAH)
					{
					total_matrah_yaz = SSK_MATRAH;
					total_ikramiye_yaz = total_ikramiye;
					}
				 if(total_ikramiye_yaz gt 0 and get_odeneks.recordcount and len(get_odeneks.amount))
					total_ikramiye_yaz = total_ikramiye_yaz - get_odeneks.amount;
				if(total_ikramiye_yaz lt 0) total_ikramiye_yaz = 0; else total_ikramiye_yaz = wrk_round(total_ikramiye_yaz);
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(total_matrah_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PRIM_IKRAMIYE"] = wrk_round(total_ikramiye_yaz,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
					if(aydaki_gun_sayisi eq 31 and TOTAL_DAYS eq 30)
					{
						my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 0;
						is_eksik_gun = 0;
					}
					else
					{
						if(total_days eq 0 and izin eq 30 and aydaki_gun_sayisi eq 31)	
						{
							my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31;
							is_eksik_gun = 31;
						}
						else
						{
							if (aydaki_gun_sayisi eq 31 and duty_type eq 6)
							{
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = 31 - total_days;	// max : 30
								is_eksik_gun = 31 - total_days;
							}
							else
							{
								//writeoutput("<script>alert('5.1 - #IZIN#');</script>");
								my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNSAYISI"] = IZIN;	// max : 30
								is_eksik_gun = IZIN;
							}
						}
					}
			}
			else
			{	
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["PEK"] = wrk_round(ay_matrah_ozel,2);	// max : 999999999999999999
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GUN"] = TOTAL_DAYS;	// max : 30
			}
	
			// bu ay içinde giriş ve/veya çıkışı varsa
			
			if ( (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) or (len(finish_date) and (datediff("d", finish_date, bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) )
				{
				if (len(start_date) and (datediff("d", bu_ay_basi, start_date) gte 0)) // girişi var
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["GIRISGUN"] = dateformat(start_date,"ddmm");// (optional)
				if (len(FINISH_DATE) and (datediff("d",FINISH_DATE,bu_ay_sonu) gte 0) and month(finish_date) eq month(bu_ay_sonu)) // çıkışı var
					{
					fire_reason = ListGetAt(law_list(),explanation_id,",");
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["CIKISGUN"] = dateformat(finish_date,"ddmm");// (optional)
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["ISTENCIKISNEDENI"] = fire_reason;//aralık : 0-99 (optional)
					}
				}
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT SIRKET_GUN FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0");
				if(get_emp_izins_2.recordcount and izin_paid gte (2*get_emp_izins_2.recordcount))
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid;

				izin_paid_amount = (ay_matrah_ozel * (izin_paid_yaz / total_days));
				}
					
			if(izin gt 0)
			{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID#");
				eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
				if (not len(eksik_neden_id)) eksik_neden_id = 13;
				if (get_emp_izins_2.recordcount gte 2)
					for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					{
						eksikGunler = listRemoveDuplicates(valuelist(get_emp_izins_2.EBILDIRGE_TYPE_ID));
						if(listlen(eksikGunler,',') gte 2)
						{
							if(ListFindNoCase(eksikGunler,18) and not ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 27;//Kısa Çalışma Ödeneği ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,28)){
								eksik_neden_id = 29;//Pandemi Ücretsiz İzin ve başka kategoride
							}else if(ListFindNoCase(eksikGunler,27)){
								eksik_neden_id = 28;//Pandemi Ücretsiz İzin ve başka kategoride
							}else{
								eksik_neden_id = 12; // birden fazla
							}
						}
					}
				if(is_eksik_gun gt 0)
				{
					my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["EKSIKGUNNEDENI"] = eksik_neden_id;	//aralık : 0-99 (optional)
				}
			}
		my_doc.AYLIKBILDIRGELER.XmlChildren[bordro_index].XmlChildren[1].XmlChildren[sigortali_index].XmlAttributes["MESLEKKOD"] = BUSINESS_CODE;
		</cfscript>
	</cfoutput>
	<cffile action="write" file="#upload_folder##n_file_name#" output="#toString(my_doc)#" charset="utf-8">
	<cfquery name="add_to_db" datasource="#dsn#">
		INSERT INTO EMPLOYEES_SSK_EXPORTS
			(
				FILE_NAME,
				FILE_SERVER_ID,
				SAL_MON,
				SAL_YEAR,
				SSK_OFFICE,
				SSK_OFFICE_NO,
				SSK_BRANCH_ID,
				ROW_COUNT,
				IS_37103,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#n_file_name#',
				#fusebox.server_machine#,
				#attributes.SAL_MON#,
				#attributes.SAL_YEAR#,
				'#get_ssk_isyeri.SSK_OFFICE#',
				'#get_ssk_isyeri.SSK_NO#',
				#get_ssk_isyeri.BRANCH_ID#,
				#get_puantajs.recordcount#,
				1,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>
<script type="text/javascript">
	alert("<cf_get_lang dictionary_id='44509.Dosya Oluşturuldu'>!");
	wrk_opener_reload();
	window.close();
</script>
