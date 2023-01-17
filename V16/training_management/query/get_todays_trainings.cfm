<!---<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME 
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN (
                        SELECT
                            BRANCH_ID
                        FROM
                            EMPLOYEE_POSITION_BRANCHES
                        WHERE
                            POSITION_CODE = #session.ep.position_code#	
					)
	ORDER BY 
		BRANCH_ID
</cfquery>
<cfif get_branchs.recordcount>
	<cfset branch_id_list = listsort(valuelist(get_branchs.branch_id,','),"Numeric","Desc")>
<cfelse>
	<cfset branch_id_list = 0>
</cfif>--->
<cfif isdefined("attributes.tarih_egitim_for_query")>
	<cf_date tarih="attributes.tarih_egitim_for_query">
</cfif>
<cfquery name="get_tr" datasource="#DSN#">
	SELECT DISTINCT
		CLASS_ID,
		FINISH_DATE,
		START_DATE,
		CLASS_NAME,
        IS_ACTIVE
	FROM
		TRAINING_CLASS
	WHERE
   	(
    	CLASS_ID IS NOT NULL AND 
		(
		 <cfif DATABASE_TYPE IS "MSSQL">
				DATEPART(MM,START_DATE) <=#ay# AND 
				DATEPART(yyyy,START_DATE) <=#yil# AND 
				DATEPART(dd,START_DATE) <= #gun# AND 
				DATEPART(MM,FINISH_DATE) >=#ay# AND 
				DATEPART(yyyy,FINISH_DATE) >=#yil# AND 
				DATEPART(dd,FINISH_DATE) >= #gun#
		 <cfelseif DATABASE_TYPE IS "DB2">
				MONTH(START_DATE) <=#ay# AND 
				YEAR(START_DATE) <=#yil# AND 
				DAY(START_DATE) <= #gun# AND 
				MONTH(FINISH_DATE) >=#ay# AND 
				YEAR(FINISH_DATE) >=#yil# AND 
				DAY(FINISH_DATE) >= #gun#
		 </cfif>
		 )
		 <cfif isdefined("attributes.tarih_egitim_for_query") >
		 OR ( FINISH_DATE>=#attributes.tarih_egitim_for_query# AND FINISH_DATE < #DATEADD('d',1,attributes.tarih_egitim_for_query)# OR START_DATE>=#attributes.tarih_egitim_for_query# AND START_DATE < #DATEADD('d',1,attributes.tarih_egitim_for_query)# )
		 </cfif>
	 )
	 
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			AND CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE DEPARTMENT_ID IN(SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID IN (#attributes.branch_id#))))
		</cfif>
	
	<!---(
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE DEPARTMENT_ID IN(SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID IN (#attributes.branch_id#))))
		</cfif>
		 <cfelse>
			CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE DEPARTMENT_ID IN(SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID IN (#branch_id_list#))))
			OR
			<!--- CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS WHERE TRAINER_EMP = #session.ep.userid#) --->
			CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE EMP_ID = #session.ep.userid#)
			OR 
			CLASS_ID NOT IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID IS NOT NULL)
			OR 
			CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_INFORM WHERE EMP_ID = #session.ep.userid#)
			OR
			CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID = #session.ep.userid#)
		
	) --->
	<cfif isdefined("attributes.training_cat_id") AND len(attributes.training_cat_id)>AND TRAINING_CAT_ID = #attributes.training_cat_id#</cfif>
	<cfif isdefined("attributes.training_sec_id") AND len(attributes.training_sec_id)>AND TRAINING_SEC_ID = #attributes.training_sec_id#</cfif>
	<cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and len(attributes.member_name) and member_type eq 'employee'>
		AND CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE EMP_ID = #attributes.emp_id#)
	<cfelseif isdefined("attributes.par_id") and len(attributes.par_id) and len(attributes.member_name) and member_type eq 'partner'>
		AND CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE PAR_ID = #attributes.par_id#)
	<cfelseif isdefined("attributes.cons_id") and len(attributes.cons_id) and len(attributes.member_name) and member_type eq 'consumer'>
		AND CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE CONS_ID = #attributes.cons_id#)
	</cfif>
</cfquery>
