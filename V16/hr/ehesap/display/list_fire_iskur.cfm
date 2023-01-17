<cfif not isdefined("attributes.in_out_ids")>
	<script>
		alert("<cf_get_lang dictionary_id='45506.Giriş Çıkış Kaydı Seçmelisiniz'>!");
		window.history.go(-2);
	</script>
	<cfabort>
</cfif>

<cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
<cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
	<cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
</cfif>


<cfquery name="GET_IN_OUTS" datasource="#dsn#">
	SELECT 
		(SELECT SBC.BUSINESS_CODE FROM SETUP_BUSINESS_CODES SBC WHERE SBC.BUSINESS_CODE_ID = EMPLOYEES_IN_OUT.BUSINESS_CODE_ID) AS BUSINESS_CODE,
		EMPLOYEES_IN_OUT.VALID,		
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		EMPLOYEES_IN_OUT.IS_5084,
		EMPLOYEES_IN_OUT.START_DATE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_IN_OUT.KIDEM_AMOUNT,
		EMPLOYEES_IN_OUT.IHBAR_AMOUNT,
		EMPLOYEES_IN_OUT.RECORD_DATE,
		EMPLOYEES_IN_OUT.UPDATE_DATE,
		EMPLOYEES_IN_OUT.EXPLANATION_ID,
		EMPLOYEES_IN_OUT.EX_IN_OUT_ID,
		CASE 
			WHEN EMPLOYEES_IN_OUT.SSK_STATUTE = 1 THEN 0
			WHEN EMPLOYEES_IN_OUT.SSK_STATUTE = 2 THEN 8
			WHEN EMPLOYEES_IN_OUT.SSK_STATUTE = 3 THEN 19
			WHEN EMPLOYEES_IN_OUT.SSK_STATUTE = 4 THEN 7
		ELSE 1 END AS SIGORTAKOLU,
		CASE 
			WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 0 THEN 1
			WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 1 THEN 1
			WHEN (EMPLOYEES_IN_OUT.SSK_STATUTE = 3 OR EMPLOYEES_IN_OUT.SSK_STATUTE = 4) THEN 5
		ELSE 2 END AS GOREVKODU,		
		BRANCH.BRANCH_WORK,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		EMPLOYEES.KIDEM_DATE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.EMPLOYEE_ID,
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_FULLNAME,
		BRANCH.BRANCH_ID,
		BRANCH.SSK_OFFICE,
		BRANCH.SSK_NO,
		BRANCH.BRANCH_ADDRESS,
		BRANCH.SSK_AGENT,
		CASE 
			WHEN EGITIM.EDU_TYPE = 1 THEN 2
			WHEN EGITIM.EDU_TYPE = 2 THEN 3
			WHEN EGITIM.EDU_TYPE = 3 THEN 4
			WHEN EGITIM.EDU_TYPE = 4 THEN 4
			WHEN EGITIM.EDU_TYPE = 5 THEN 5
			WHEN EGITIM.EDU_TYPE = 6 THEN 5
			WHEN EGITIM.EDU_TYPE = 7 THEN 6
			WHEN EGITIM.EDU_TYPE = 8 THEN 7
		ELSE 0 END AS OGRENIMKODU,
		EGITIM.EDU_FINISH,
		EGITIM.EDU_PART_NAME,
		EMPLOYEES_DETAIL.DEFECTED AS OZURLUKODU,
		EMPLOYEES_DETAIL.SENTENCED AS ESKIHUKUMLU,
		BRANCH.SSK_M + '' + BRANCH.SSK_JOB + '' + BRANCH.SSK_BRANCH + '' + BRANCH.SSK_BRANCH_OLD + '' + BRANCH.SSK_NO + '' + BRANCH.SSK_CITY + '' + BRANCH.SSK_COUNTRY AS SSK_ISYERI,
		D.DEPARTMENT_HEAD,
		EMPLOYEE_POSITIONS.POSITION_NAME
	FROM 
		
		EMPLOYEES_IN_OUT,
		EMPLOYEES
			LEFT JOIN EMPLOYEE_POSITIONS ON (EMPLOYEE_POSITIONS.IS_MASTER = 1 AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID)
			OUTER APPLY
				(SELECT TOP 1 EDU_TYPE,EDU_PART_NAME,EDU_FINISH FROM EMPLOYEES_APP_EDU_INFO WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID ORDER BY EDU_FINISH DESC) EGITIM
		,
		EMPLOYEES_DETAIL,
		EMPLOYEES_IDENTY,
		BRANCH,
		DEPARTMENT D
	WHERE
		EMPLOYEES_IN_OUT.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
		EMPLOYEES_IN_OUT.IN_OUT_ID in (#attributes.in_out_ids#)
	ORDER BY
		BRANCH.BRANCH_NAME,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IN_OUT.START_DATE
</cfquery>

<cfsavecontent variable="message"><cf_get_lang dictionary_id="45507.İşkur İşgücü Belgesi"></cfsavecontent>
<cf_box title="#message#">
<CFOUTPUT QUERY="GET_IN_OUTS" GROUP="BRANCH_NAME">
<cfsavecontent variable="xml_icerik_#BRANCH_ID#">
	<?xml version="1.0" encoding="iSO-8859-9"?>
	<ISGUCUCIZELGE XMLVERSION="1" > <!---Suan sadece ise giris icin yapildi --->
	<KISILER>
		<cfset sira=0>
		<CFOUTPUT>
			<KISI
				<cfset sira=sira+1>
				SIRA="#sira#"
				TCKNO="#TC_IDENTY_NO#"
				AD="#EMPLOYEE_NAME#" 
				SOYAD="#EMPLOYEE_SURNAME#"				
				<cfif OZURLUKODU eq 1>
					SOSYALDURUM="10" <!--- normal 9, engelli 10, eskihukumlu 13, terormagduru 14, tmy 15 --->
				<cfelseif ESKIHUKUMLU eq 1>
					SOSYALDURUM="13"
				<cfelse>
					SOSYALDURUM="9"
				</cfif>
				ISTIHDAMDURUMU="0"  <!---işe yeni alinan 0 , isten cikarilan 1 --->
				MESLEKKODU="#BUSINESS_CODE#"
				ALINMAAYRILMATAR="#dateformat(START_DATE,'yyyy-mm-dd')#" <!---format yanlis  (2008-04-25T00:00:00.000) seklinde olacak--->
				ALINMAAYRILMADUR="" 
				ISTENCIKARMADUR="" <!---topluistencikarma 0, bireyselistencikarma 1, --->
			/>
		</CFOUTPUT>
	</KISILER>
	</ISGUCUCIZELGE>
</cfsavecontent>
<cffile action="write" file="#upload_folder#reserve_files\#drc_name_#\user_id_#session.ep.userid#_sube_id_#BRANCH_ID#_iskur_isgucu.xml" nameconflict="overwrite" output="#trim(evaluate('xml_icerik_#BRANCH_ID#'))#">

#BRANCH_NAME# <cf_get_lang dictionary_id="45479.için ürettiğiniz xml file"> : <a href="/documents/reserve_files/#drc_name_#/user_id_#session.ep.userid#_sube_id_#BRANCH_ID#_iskur_isgucu.xml" class="tableyazi">user_id_#session.ep.userid#_sube_id_#BRANCH_ID#_iskur_isgucu.xml</a> (<cf_get_lang dictionary_id="45509.Farklı Kaydet Diyebilirsiniz">!) <br><br>
</CFOUTPUT>

</cf_box>
