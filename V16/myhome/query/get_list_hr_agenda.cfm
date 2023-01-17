<cfif attributes.hr_selection eq 1 and isdefined('x_hr_agenda') and len(x_hr_agenda)>
	<!--- x_hr_agenda, hr gundem sayfasinada tasinmalidir --->
	<cfquery name="get_event_det" datasource="#dsn#" maxrows="10">
		SELECT  
			EVENT_HEAD,
			EVENTCAT_ID,
			STARTDATE,
			EVENT_ID
		FROM 
			EVENT
		WHERE 
			STARTDATE >= #createdatetime(year(now()),month(now()),day(now()),0,0,0)# AND
			EVENTCAT_ID = #x_hr_agenda# <!--- mulakat - 19--->
		ORDER BY
			STARTDATE
	</cfquery>
<cfelseif attributes.hr_selection eq 2><!--- egitim --->
	<cfquery name="get_training_class" datasource="#dsn#" maxrows="10">
		SELECT  
			CLASS_NAME,
			TRAINING_CAT_ID,
			START_DATE,
			CLASS_ID
		FROM 
			TRAINING_CLASS
		WHERE 
			START_DATE >= #createdatetime(year(now()),month(now()),day(now()),0,0,0)#
		ORDER BY
			START_DATE
	</cfquery>
<cfelseif attributes.hr_selection eq 3>
	<cfquery name="get_sureli_finishdate_det" datasource="#dsn#" maxrows="10">
		SELECT  
			E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMP_NAME,
			EIO.SURELI_IS_FINISHDATE,
			B.BRANCH_NAME,
			B.BRANCH_ID,
			E.EMPLOYEE_ID
		FROM 
			EMPLOYEES E,
			EMPLOYEE_POSITIONS EP,
			EMPLOYEES_IN_OUT EIO,
			DEPARTMENT D,
			BRANCH B
		WHERE 
			E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
			E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
			D.BRANCH_ID = B.BRANCH_ID AND
			D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND
			EIO.SURELI_IS_FINISHDATE >= #createdatetime(year(now()),month(now()),day(now()),0,0,0)#
		ORDER BY
			SURELI_IS_FINISHDATE
	</cfquery>
<cfelseif attributes.hr_selection eq 4>
	<cfquery name="get_trial_date_det" datasource="#dsn#" maxrows="10">
		SELECT  
			EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS EMP_NAME,
			(dateadd(d,ED.TEST_TIME,EIO.START_DATE)) TRIAL_DATE,
			B.BRANCH_NAME,
			EP.EMPLOYEE_ID
		FROM 
			EMPLOYEE_POSITIONS EP,
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEES_DETAIL ED,
			DEPARTMENT D,
			BRANCH B
		WHERE 
			EP.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
			EP.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
			D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND
			D.BRANCH_ID = B.BRANCH_ID AND
			(dateadd(d,ED.TEST_TIME,EIO.START_DATE)) >= #createdatetime(year(now()),month(now()),day(now()),0,0,0)#
		ORDER BY
			START_DATE DESC
	</cfquery>
	<!--- pozisyon detayindan cekildi --->
	<!--- <cfquery name="get_trial_date_det" datasource="#dsn#" maxrows="10">
		SELECT  
			EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS EMP_NAME,
			EP.TRIAL_DATE,
			B.BRANCH_NAME,
			EP.EMPLOYEE_ID
		FROM 
			EMPLOYEE_POSITIONS EP,
			DEPARTMENT D,
			BRANCH B
		WHERE 
			D.BRANCH_ID = B.BRANCH_ID AND
			D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND
			EP.TRIAL_DATE >= #now()#
		ORDER BY
			TRIAL_DATE
	</cfquery> --->
<cfelseif attributes.hr_selection eq 5 or attributes.hr_selection eq 6>
	<cfquery name="get_observation_vekaleten_date" datasource="#dsn#" maxrows="10">
		SELECT  
			EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS EMP_NAME,
			EP.OBSERVATION_DATE,
			EP.VEKALETEN_DATE,
			B.BRANCH_NAME,
			EP.EMPLOYEE_ID,
			EP.POSITION_ID
		FROM 
			EMPLOYEE_POSITIONS EP,
			DEPARTMENT D,
			BRANCH B
		WHERE 
			D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND
			D.BRANCH_ID = B.BRANCH_ID AND
			<cfif attributes.hr_selection eq 5>
				EP.OBSERVATION_DATE >= #createdatetime(year(now()),month(now()),day(now()),0,0,0)#
			<cfelseif attributes.hr_selection eq 6>
				EP.VEKALETEN_DATE >= #createdatetime(year(now()),month(now()),day(now()),0,0,0)#
			</cfif>
	</cfquery>

</cfif>

