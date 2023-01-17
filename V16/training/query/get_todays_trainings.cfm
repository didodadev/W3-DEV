<cfif isdefined("attributes.tarih_egitim_for_query")><cf_date tarih="attributes.tarih_egitim_for_query"></cfif>
<cfquery name="GET_TR" datasource="#DSN#">
	SELECT
		1 AS TYPE,
		TRAINING_CLASS.CLASS_NAME,
		TRAINING_CLASS.START_DATE,
		TRAINING_CLASS.CLASS_ID,
		TRAINING_CLASS.FINISH_DATE,
		TRAINING_CLASS_ATTENDER.EMP_ID
	FROM
		TRAINING_CLASS,
		TRAINING_CLASS_ATTENDER
	WHERE
		TRAINING_CLASS.CLASS_ID IS NOT NULL AND 
        TRAINING_CLASS.IS_ACTIVE = 1 AND
		TRAINING_CLASS.CLASS_ID = TRAINING_CLASS_ATTENDER.CLASS_ID AND
		TRAINING_CLASS_ATTENDER.EMP_ID = #SESSION.EP.USERID# AND
		(
			(
			<cfif DATABASE_TYPE is "MSSQL">
				DATEPART(MM,START_DATE) <=#ay# AND
				DATEPART(yyyy,START_DATE) <=#yil# AND
				DATEPART(dd,START_DATE) <= #gun# AND
				DATEPART(MM,FINISH_DATE) >=#ay# AND
				DATEPART(yyyy,FINISH_DATE) >=#yil# AND
				DATEPART(dd,FINISH_DATE) >= #gun#
			<cfelseif DATABASE_TYPE is "DB2">
				MONTH(START_DATE) <=#ay# AND
				YEAR(START_DATE) <=#yil# AND
				DAY(START_DATE) <= #gun# AND
				MONTH(FINISH_DATE) >=#ay# AND
				YEAR(FINISH_DATE) >=#yil# AND
				DAY(FINISH_DATE) >= #gun#		
			</cfif>
			)
			<cfif isdefined("attributes.tarih_egitim_for_query")>
				OR ( FINISH_DATE >= #attributes.tarih_egitim_for_query# AND START_DATE <= #attributes.tarih_egitim_for_query# )
			</cfif>
		
		<cfif isDefined("attributes.train_departments") and len(attributes.train_departments)>
			OR ( TRAINING_CLASS.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING WHERE TRAIN_DEPARTMENTS LIKE '%,#attributes.train_departments#,%')))
		</cfif>
		<cfif isDefined("attributes.train_position_cats") and len(attributes.train_position_cats)>
			OR ( TRAINING_CLASS.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING WHERE TRAIN_POSITION_CATS LIKE '%,#attributes.train_position_cats#,%')))
		</cfif>
		)
	UNION
	SELECT
		2 AS TYPE,
		TRAINING_CLASS.CLASS_NAME,
		TRAINING_CLASS.START_DATE,
		TRAINING_CLASS.CLASS_ID,
		TRAINING_CLASS.FINISH_DATE,
		0 AS EMP_ID
	FROM
		TRAINING_CLASS
	WHERE
		TRAINING_CLASS.CLASS_ID IS NOT NULL AND
        TRAINING_CLASS.IS_ACTIVE = 1 AND
		TRAINING_CLASS.CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE EMP_ID = #SESSION.EP.USERID#)
		AND
		(
			(
			<cfif DATABASE_TYPE is "MSSQL">
				DATEPART(MM,START_DATE) <=#ay# AND
				DATEPART(yyyy,START_DATE) <=#yil# AND
				DATEPART(dd,START_DATE) <= #gun# AND
				DATEPART(MM,FINISH_DATE) >=#ay# AND
				DATEPART(yyyy,FINISH_DATE) >=#yil# AND
				DATEPART(dd,FINISH_DATE) >= #gun#
			<cfelseif DATABASE_TYPE is "DB2">
				MONTH(START_DATE) <=#ay# AND
				YEAR(START_DATE) <=#yil# AND
				DAY(START_DATE) <= #gun# AND
				MONTH(FINISH_DATE) >=#ay# AND
				YEAR(FINISH_DATE) >=#yil# AND
				DAY(FINISH_DATE) >= #gun#		
			</cfif>
			)
			<cfif isdefined("attributes.tarih_egitim_for_query")>
				OR ( FINISH_DATE >= #attributes.tarih_egitim_for_query# AND START_DATE <= #attributes.tarih_egitim_for_query# )
			</cfif>
		)
	
	UNION
	
	SELECT
		3 AS TYPE,
		TRAINING_CLASS.CLASS_NAME,
		TRAINING_CLASS.START_DATE,
		TRAINING_CLASS.CLASS_ID,
		TRAINING_CLASS.FINISH_DATE,
		TRAINING_CLASS_INFORM.EMP_ID
	FROM
		TRAINING_CLASS,
		TRAINING_CLASS_INFORM
	WHERE
		TRAINING_CLASS.CLASS_ID IS NOT NULL AND 
        TRAINING_CLASS.IS_ACTIVE = 1 AND
		TRAINING_CLASS.CLASS_ID = TRAINING_CLASS_INFORM.CLASS_ID AND
		TRAINING_CLASS_INFORM.EMP_ID = #SESSION.EP.USERID# 
		AND
		(
			(
			<cfif DATABASE_TYPE is "MSSQL">
				DATEPART(MM,START_DATE) <=#ay# AND
				DATEPART(yyyy,START_DATE) <=#yil# AND
				DATEPART(dd,START_DATE) <= #gun# AND
				DATEPART(MM,FINISH_DATE) >=#ay# AND
				DATEPART(yyyy,FINISH_DATE) >=#yil# AND
				DATEPART(dd,FINISH_DATE) >= #gun#
			<cfelseif DATABASE_TYPE is "DB2">
				MONTH(START_DATE) <=#ay# AND
				YEAR(START_DATE) <=#yil# AND
				DAY(START_DATE) <= #gun# AND
				MONTH(FINISH_DATE) >=#ay# AND
				YEAR(FINISH_DATE) >=#yil# AND
				DAY(FINISH_DATE) >= #gun#		
			</cfif>
			)
			<cfif isdefined("attributes.tarih_egitim_for_query")>
				OR ( FINISH_DATE >= #attributes.tarih_egitim_for_query# AND START_DATE <= #attributes.tarih_egitim_for_query# )
			</cfif>
			<cfif isDefined("attributes.train_departments") and len(attributes.train_departments)>
				OR ( TRAINING_CLASS.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING WHERE TRAIN_DEPARTMENTS LIKE '%,#attributes.train_departments#,%')))
			</cfif>
			<cfif isDefined("attributes.train_position_cats") and len(attributes.train_position_cats)>
				OR ( TRAINING_CLASS.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING WHERE TRAIN_POSITION_CATS LIKE '%,#attributes.train_position_cats#,%')))
			</cfif>
		)
		
	UNION
	
	SELECT
		4 AS TYPE,
		TRAINING_CLASS.CLASS_NAME,
		TRAINING_CLASS.START_DATE,
		TRAINING_CLASS.CLASS_ID,
		TRAINING_CLASS.FINISH_DATE,
		0 AS EMP_ID
	FROM
		TRAINING_CLASS
	WHERE
		TRAINING_CLASS.CLASS_ID IS NOT NULL AND 
        TRAINING_CLASS.IS_ACTIVE = 1 AND
		TRAINING_CLASS.VIEW_TO_ALL = 1 AND <!--- olayı herkes gorsun isaretli olan eğitimler SG20121115--->
		(
			<!---TRAINING_CLASS.CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE EMP_ID NOT IN(#session.ep.userid#))--->
            TRAINING_CLASS.CLASS_ID NOT IN (SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE EMP_ID = #SESSION.EP.USERID#) 
			OR 
			TRAINING_CLASS.CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE EMP_ID IS NULL) 
		) AND
		TRAINING_CLASS.CLASS_ID NOT IN(SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID = #session.ep.userid#) AND
		TRAINING_CLASS.CLASS_ID NOT IN(SELECT CLASS_ID FROM TRAINING_CLASS_INFORM WHERE EMP_ID = #session.ep.userid#) AND
		(
			(
			<cfif DATABASE_TYPE is "MSSQL">
				DATEPART(MM,START_DATE) <=#ay# AND
				DATEPART(yyyy,START_DATE) <=#yil# AND
				DATEPART(dd,START_DATE) <= #gun# AND
				DATEPART(MM,FINISH_DATE) >=#ay# AND
				DATEPART(yyyy,FINISH_DATE) >=#yil# AND
				DATEPART(dd,FINISH_DATE) >= #gun#
			<cfelseif DATABASE_TYPE is "DB2">
				MONTH(START_DATE) <=#ay# AND
				YEAR(START_DATE) <=#yil# AND
				DAY(START_DATE) <= #gun# AND
				MONTH(FINISH_DATE) >=#ay# AND
				YEAR(FINISH_DATE) >=#yil# AND
				DAY(FINISH_DATE) >= #gun#		
			</cfif>
			)
			<cfif isdefined("attributes.tarih_egitim_for_query")>
				OR ( FINISH_DATE >= #attributes.tarih_egitim_for_query# AND START_DATE <= #attributes.tarih_egitim_for_query# )
			</cfif>
			<cfif isDefined("attributes.train_departments") and len(attributes.train_departments)>
				OR ( TRAINING_CLASS.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING WHERE TRAIN_DEPARTMENTS LIKE '%,#attributes.train_departments#,%')))
			</cfif>
			<cfif isDefined("attributes.train_position_cats") and len(attributes.train_position_cats)>
				OR ( TRAINING_CLASS.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING WHERE TRAIN_POSITION_CATS LIKE '%,#attributes.train_position_cats#,%')))
			</cfif>
		)
        
	<!---UNION
    SELECT DISTINCT
     	5 AS TYPE,
        TRAINING_CLASS.CLASS_NAME,
        TRAINING_CLASS.START_DATE,
        TRAINING_CLASS.CLASS_ID,
        TRAINING_CLASS.FINISH_DATE,
        0 AS EMP_ID
  	FROM
		TRAINING_CLASS
   	WHERE
    	TRAINING_CLASS.IS_ACTIVE = 1 AND
        TRAINING_CLASS.VIEW_TO_ALL = 1 AND
    	TRAINING_CLASS.CLASS_ID NOT IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID = #SESSION.EP.USERID#) AND
        TRAINING_CLASS.CLASS_ID NOT IN (SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE EMP_ID = #SESSION.EP.USERID#) AND
        TRAINING_CLASS.CLASS_ID NOT IN (SELECT CLASS_ID FROM TRAINING_CLASS_INFORM WHERE EMP_ID = #SESSION.EP.USERID#) AND
        TRAINING_CLASS.CLASS_ID IS NOT NULL AND
    (
    	
        (
        	<cfif DATABASE_TYPE is "MSSQL">
				DATEPART(MM,START_DATE) <=#ay# AND
				DATEPART(yyyy,START_DATE) <=#yil# AND
				DATEPART(dd,START_DATE) <= #gun# AND
				DATEPART(MM,FINISH_DATE) >=#ay# AND
				DATEPART(yyyy,FINISH_DATE) >=#yil# AND
				DATEPART(dd,FINISH_DATE) >= #gun#
			<cfelseif DATABASE_TYPE is "DB2">
				MONTH(START_DATE) <=#ay# AND
				YEAR(START_DATE) <=#yil# AND
				DAY(START_DATE) <= #gun# AND
				MONTH(FINISH_DATE) >=#ay# AND
				YEAR(FINISH_DATE) >=#yil# AND
				DAY(FINISH_DATE) >= #gun#		
			</cfif>
    	)
        	<cfif isdefined("attributes.tarih_egitim_for_query")>
				OR ( FINISH_DATE >= #attributes.tarih_egitim_for_query# AND START_DATE <= #attributes.tarih_egitim_for_query# )
			</cfif>
			<cfif isDefined("attributes.train_departments") and len(attributes.train_departments)>
				OR ( TRAINING_CLASS.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING WHERE TRAIN_DEPARTMENTS LIKE '%,#attributes.train_departments#,%')))
			</cfif>
			<cfif isDefined("attributes.train_position_cats") and len(attributes.train_position_cats)>
				OR ( TRAINING_CLASS.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING WHERE TRAIN_POSITION_CATS LIKE '%,#attributes.train_position_cats#,%')))
			</cfif>
  	)--->
</cfquery>
