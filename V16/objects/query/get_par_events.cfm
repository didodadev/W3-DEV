<cf_date tarih="attributes.start_date_par">
<cf_date tarih="attributes.finishdate">

<cfquery name="PAR_EVENTS" datasource="#dsn#">
	SELECT
		'Ajanda' AS TYPE,
		EVENT_ID AS ID,
		EVENT_HEAD AS NAME,
		STARTDATE AS REAL_START,
		FINISHDATE AS REAL_FINISH,
		STARTDATE AS TARGET_START,
		FINISHDATE AS TARGET_FINISH
	FROM
		EVENT
	WHERE
		( 
			(RECORD_PAR = #attributes.par_id# OR EVENT_TO_PAR LIKE '%,#attributes.par_id#,%')
			AND
			( 
				(STARTDATE <= #attributes.start_date_par# AND FINISHDATE >= #attributes.start_date_par#) OR
				(STARTDATE >= #attributes.start_date_par# AND STARTDATE <= #attributes.finishdate#)
			)
		  )

	UNION

	SELECT
		'Servis' AS TYPE,
		SERVICE_ID AS ID,
		SERVICE_HEAD AS NAME,
		START_DATE AS REAL_START,
		FINISH_DATE AS REAL_FINISH,
		START_DATE AS TARGET_START,
		FINISH_DATE AS TARGET_FINISH
	FROM
		#dsn3_alias#.SERVICE AS SERVICE
	WHERE
		SERVICE_PARTNER_ID = #attributes.par_id#
		AND
		(
			(START_DATE <= #attributes.start_date_par# AND FINISH_DATE >= #attributes.start_date_par#) OR
			(START_DATE >= #attributes.start_date_par# AND START_DATE <= #attributes.finishdate#)
		)

	UNION

	SELECT
		'Proje' AS TYPE,
		WORK_ID AS ID,
		WORK_HEAD AS NAME,
		TARGET_START AS REAL_START,<!--- artık REAL_START alanı kullanılmıyor, ön sayfada sıkıntı olmasn diye diğer bailangıc tarihini çağırdık--->
		TARGET_FINISH AS REAL_FINISH,
		TARGET_START AS TARGET_START,
		TARGET_FINISH AS TARGET_FINISH
	FROM
		PRO_WORKS
	WHERE
		OUTSRC_PARTNER_ID = #attributes.par_id# AND
		( 
			(TARGET_START <= #attributes.start_date_par# AND TARGET_FINISH >= #attributes.start_date_par#) OR
			(TARGET_START >= #attributes.start_date_par# AND TARGET_FINISH <= #attributes.finishdate#)
		)
	ORDER BY TARGET_START DESC
</cfquery>
