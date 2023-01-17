<cfsetting showdebugoutput="no">
<!---<cfinclude template="../query/get_class.cfm">
<cfquery name="GET_EMP_ADD" datasource="#dsn#">
	SELECT COUNT(EMP_ID) AS TOTAL,COUNT(CON_ID) AS TOTAL_CON,COUNT(PAR_ID) AS TOTAL_PAR FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#attributes.CLASS_ID# 
</cfquery>
<cfquery name="GET_EMP_REQ" datasource="#DSN#">
	SELECT
		COUNT(TRR.EMPLOYEE_ID) AS TOTAL
	FROM
		TRAINING_REQUEST TR,
		TRAINING_REQUEST_ROWS TRR
	WHERE
		TRR.EMPLOYEE_ID NOT IN (SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#attributes.class_id# AND EMP_ID IS NOT NULL )
		AND TRR.TRAINING_ID IN (SELECT TRAIN_ID FROM TRAINING_CLASS_SECTIONS WHERE CLASS_ID=#attributes.class_id#)
		AND TR.TRAIN_REQUEST_ID = TRR.TRAIN_REQUEST_ID
		AND TR.FORM_VALID=1
		AND (
				(TR.SECOND_BOSS_CODE IS NULL AND TRR.FIRST_BOSS_VALID_ROW=1)
				OR (TR.THIRD_BOSS_CODE IS NULL AND TRR.SECOND_BOSS_VALID_ROW=1)
				OR (TR.FOURTH_BOSS_CODE IS NULL AND TRR.THIRD_BOSS_VALID_ROW=1)
				OR (TR.FIFTH_BOSS_CODE IS NULL AND TRR.FOURTH_BOSS_VALID_ROW=1)
				OR TRR.FIFTH_BOSS_VALID_ROW =1
			)
		<cfif len(GET_CLASS.START_DATE)>AND TR.REQUEST_YEAR = #dateformat(GET_CLASS.START_DATE,'yyyy')#</cfif>
</cfquery>
<cfquery name="GET_EMP_REQ_1" datasource="#DSN#">
	SELECT
		COUNT(TRR.EMPLOYEE_ID) AS TOTAL
	FROM
		TRAINING_REQUEST_ROWS TRR
	WHERE
		TRR.EMPLOYEE_ID NOT IN (SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#attributes.class_id# AND EMP_ID IS NOT NULL )
		AND	CLASS_ID=#attributes.class_id#
		AND TRAIN_REQUEST_ID IS NULL
		AND ANNOUNCE_ID IS NULL
</cfquery>
<cfquery name="GET_EMP_REQ_2" datasource="#DSN#">
	SELECT
		COUNT(TRR.EMPLOYEE_ID) AS TOTAL
	FROM
		TRAINING_REQUEST_ROWS  TRR
	WHERE
		TRR.EMPLOYEE_ID NOT IN (SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#attributes.class_id# AND EMP_ID IS NOT NULL )
		AND ANNOUNCE_ID IN (SELECT ANNOUNCE_ID FROM TRAINING_CLASS_ANNOUNCE_CLASSES WHERE CLASS_ID=#attributes.class_id#)
		AND TRAIN_REQUEST_ID IS NULL
</cfquery>
<cf_ajax_list>
	<tr>
		<td><cf_get_lang_main no='1983.Katılımcı'>(<cf_get_lang_main no='164.Çalışan'>)</td>
		<td>: <cfoutput>#get_emp_add.total#</cfoutput></td>
	</tr>
	<tr>
		<td><cf_get_lang_main no='1983.Katılımcı'>(<cf_get_lang no='152.Bireysel'>)</td>
		<td>: <cfoutput>#get_emp_add.total_con#</cfoutput></td>
	</tr>
	<tr>
		<td><cf_get_lang_main no='1983.Katılımcı'>(<cf_get_lang no='151.Kurumsal'>)</td>
		<td>: <cfoutput>#get_emp_add.total_par#</cfoutput></td>
	</tr>
	<tr>
		<td><cf_get_lang no='448.Yıllık Talep'></td>
		<td>: <cfoutput>#GET_EMP_REQ.total#</cfoutput></td>
	</tr>
	<tr>
		<td><cf_get_lang no='449.Ders Talep'></td>
		<td>: <cfoutput>#GET_EMP_REQ_1.total#</cfoutput></td>
	</tr>
	<tr>
		<td><cf_get_lang no='450.Duyuru Talep'></td>
		<td>: <cfoutput>#GET_EMP_REQ_2.total#</cfoutput></td>
	</tr>
</cf_ajax_list> --->

