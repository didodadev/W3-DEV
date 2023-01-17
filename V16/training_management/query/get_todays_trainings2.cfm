<cfif isdefined("attributes.tarih_egitim_for_query")>
	<cf_date tarih="attributes.tarih_egitim_for_query">
</cfif>
<cfquery name="get_tr" datasource="#DSN#">
	SELECT
		*
	FROM
		TRAINING_CLASS
	WHERE
	(
		CLASS_ID IS NOT NULL
		AND 
		(
		 <cfif DATABASE_TYPE IS "MSSQL">
			DATEPART(MM,START_DATE) <=#ay#
			AND DATEPART(yyyy,START_DATE) <=#yil#
			AND DATEPART(dd,START_DATE) <= #gun#
			AND DATEPART(MM,FINISH_DATE) >=#ay#
			AND DATEPART(yyyy,FINISH_DATE) >=#yil#
			AND DATEPART(dd,FINISH_DATE) >= #gun#
		 <cfelseif DATABASE_TYPE IS "DB2">
			MONTH(START_DATE) <=#ay#
			AND YEAR(START_DATE) <=#yil#
			AND DAY(START_DATE) <= #gun#		
			AND MONTH(FINISH_DATE) >=#ay#
			AND YEAR(FINISH_DATE) >=#yil#
			AND DAY(FINISH_DATE) >= #gun#		
		 </cfif>
		 )
		 <cfif isdefined("attributes.tarih_egitim_for_query") >
		 OR (FINISH_DATE >=#attributes.tarih_egitim_for_query# AND START_DATE <= #attributes.tarih_egitim_for_query#)
		 </cfif>
	 )
     <!--- <cfif IsDefined("attributes.train_departments") AND attributes.train_departments>
	 AND
	 (
	 	CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING WHERE TRAIN_DEPARTMENTS LIKE '%,#attributes.train_departments#,%'))
	 )
	 </cfif> --->
	 <!--- <cfif IsDefined("attributes.train_position_cats") AND attributes.train_position_cats>
	 AND
	 (
	 	CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING WHERE TRAIN_POSITION_CATS LIKE '%,#attributes.train_position_cats#,%'))
	 )
	 </cfif> --->
	 <cfif isdefined("attributes.training_sec_id") AND attributes.training_sec_id>AND TRAINING_SEC_ID = #attributes.training_sec_id#</cfif>
	  	<cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and len(attributes.member_name) and member_type eq 'employee'>
			AND TRAINER_EMP = #attributes.emp_id#
		 <cfelseif isdefined("attributes.par_id") and len(attributes.par_id) and len(attributes.member_name) and member_type eq 'partner'>
			AND TRAINER_PAR = #attributes.par_id#
		 <cfelseif isdefined("attributes.cons_id") and len(attributes.cons_id) and len(attributes.member_name) and member_type eq 'consumer'>
			AND TRAINER_CONS = #attributes.cons_id#
		 </cfif>
</cfquery>

