<cfquery name="GET_QUIZS" datasource="#dsn#">
	SELECT 
		EQ.QUIZ_ID,
		EQ.QUIZ_HEAD,
		EQ.QUIZ_OBJECTIVE,
		EQ.IS_ACTIVE,
		EQ.STAGE_ID,
		EQ.POSITION_CAT_ID,
		EQ.POSITION_ID,
		EQ.IS_APPLICATION,
		EQ.IS_EDUCATION,
		EQ.IS_TRAINER,
		EQ.IS_INTERVIEW,
		EQ.IS_TEST_TIME,
		EQ.RECORD_EMP,
		EQ.RECORD_PAR,
		EQ.RECORD_DATE
	FROM 
		EMPLOYEE_QUIZ EQ
	WHERE
		EQ.QUIZ_ID IS NOT NULL 
		AND EQ.IS_EDUCATION <> 1
		<cfif isdefined("attributes.POSITION_CAT_ID") and len(attributes.POSITION_CAT_ID) and isdefined("attributes.POSITION_ID") and len(attributes.POSITION_ID)>
			AND
			(
				EQ.QUIZ_ID IN(SELECT RELATION_FIELD_ID FROM RELATION_SEGMENT_QUIZ WHERE RELATION_ACTION_ID = #attributes.POSITION_CAT_ID#)<!--- Olcme degerlendirme performans formlari pozisyon tipine bagli (segmentasyon kullanildi) oldugundan dolayi baglandi--->
				OR 
				POSITION_ID LIKE '%,#attributes.POSITION_ID#,%'
			)
		<cfelseif isdefined("attributes.POSITION_CAT_ID") and len(attributes.POSITION_CAT_ID)>
			AND EQ.QUIZ_ID IN (SELECT RELATION_FIELD_ID FROM RELATION_SEGMENT_QUIZ WHERE RELATION_ACTION_ID = #attributes.POSITION_CAT_ID#)
		</cfif> 
		<cfif (isdefined("attributes.last30_all") and attributes.last30_all eq 1)>
			AND EQ.RECORD_DATE > #createodbcdatetime(dateadd('d',-30,now()))#
		<cfelseif (isdefined("attributes.last30_all") and attributes.last30_all neq 2)>
			AND YEAR(EQ.RECORD_DATE) = #attributes.last30_all#
		<cfelseif  not isdefined("attributes.last30_all")>
			AND YEAR(EQ.RECORD_DATE) = #session.ep.period_year#
		</cfif>
  		<cfif isdefined("attributes.form_stage") and attributes.form_stage eq -1>
			AND EQ.STAGE_ID = -1
		<cfelseif isdefined("attributes.form_stage") and attributes.form_stage eq -2>
			AND EQ.STAGE_ID = -2
		</cfif> 
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
			EQ.QUIZ_HEAD LIKE '%#attributes.KEYWORD#%'
			OR 
			EQ.QUIZ_OBJECTIVE LIKE '%#attributes.KEYWORD#%'
			)
		</cfif>
		<cfif isdefined("attributes.form_type") and len(attributes.form_type)>
			<cfif attributes.form_type IS 1>
				AND (EQ.IS_EDUCATION <> 1 OR EQ.IS_EDUCATION IS NULL) AND (EQ.IS_TRAINER <> 1 OR EQ.IS_TRAINER IS NULL) AND (EQ.IS_APPLICATION <> 1 OR EQ.IS_APPLICATION IS NULL) AND (EQ.IS_INTERVIEW <> 1 OR EQ.IS_INTERVIEW IS NULL) AND (EQ.IS_TEST_TIME <> 1 OR EQ.IS_TEST_TIME IS NULL)
			<cfelseif attributes.form_type IS 2>
				AND EQ.IS_APPLICATION = 1
			<cfelseif attributes.form_type IS 4>
				AND EQ.IS_TRAINER = 1
			<cfelseif attributes.form_type IS 5>
				AND EQ.IS_INTERVIEW = 1
			<cfelseif attributes.form_type IS 6>
				AND EQ.IS_TEST_TIME = 1
			</cfif>
		<cfelse>
			AND (EQ.IS_EDUCATION <> 1 OR EQ.IS_EDUCATION IS NULL)
			AND (EQ.IS_TRAINER <> 1 OR EQ.IS_TRAINER IS NULL)
		</cfif>
		<cfif isdefined('attributes.form_status') and  attributes.form_status eq 1>
			AND EQ.IS_ACTIVE=1
		<cfelseif isdefined('attributes.form_status') and  attributes.form_status eq 0>
			AND EQ.IS_ACTIVE=0
		</cfif>
</cfquery>
