<cfset attributes.to_day = CreateDate(year(now()),month(now()), day(now()))>
<cfif isDefined("attributes.date1") and len(attributes.date1) and not isdefined("datekontrol")>
	<cfset datekontrol = 1>
	<cf_date tarih='attributes.date1'>
</cfif>
<cfquery name="get_union_class_finish" datasource="#dsn#">
	SELECT
		'employee' AS TYPE,
		<cfif database_type is "MSSQL">
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME + ' ' +	EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS ATTENDER_NAME,
		<cfelseif database_type is "DB2">
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME || ' ' ||	EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS ATTENDER_NAME,
		</cfif>
		EMPLOYEE_POSITIONS.POSITION_NAME  AS POSITION,
		DEPARTMENT.DEPARTMENT_HEAD AS DEPARTMAN,
		C.NICK_NAME AS NICK_NAME,
		BRANCH.BRANCH_NAME AS BRANCH_NAME,
		TRAINING_CLASS.CLASS_NAME AS CLASS_NAME,
		TRAINING_CLASS_ATTENDER.CLASS_ID,
		TRAINING_CLASS_ATTENDER.PAR_ID,
		TRAINING_CLASS_ATTENDER.EMP_ID,
		TRAINING_CLASS_ATTENDER.CON_ID,
		<!--- TRAINING_CLASS.TRAINER_EMP,
		TRAINING_CLASS.TRAINER_PAR,
		TRAINING_CLASS.TRAINER_CONS, --->
		TRAINING_CLASS.START_DATE,
		TRAINING_CLASS.FINISH_DATE,
		TRAINING_CLASS.DATE_NO,
		TRAINING_CLASS.HOUR_NO,
		TRAINING_CLASS.INT_OR_EXT,
		Z.ZONE_NAME AS ZONE_NAME
	FROM
		TRAINING_CLASS_ATTENDER,
		TRAINING_CLASS,
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,
		ZONE Z,
		OUR_COMPANY C
	WHERE
		TRAINING_CLASS_ATTENDER.CLASS_ID=TRAINING_CLASS.CLASS_ID
		AND TRAINING_CLASS.FINISH_DATE < #attributes.TO_DAY#
		AND TRAINING_CLASS_ATTENDER.EMP_ID IS NOT NULL
		AND EMPLOYEE_POSITIONS.EMPLOYEE_ID = TRAINING_CLASS_ATTENDER.EMP_ID
		AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
		AND DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
		AND Z.ZONE_ID=BRANCH.ZONE_ID
		AND C.COMP_ID=BRANCH.COMPANY_ID
		AND EMPLOYEE_POSITIONS.IS_MASTER = 1
		AND BRANCH.BRANCH_ID IN (
                                    SELECT
                                        BRANCH_ID
                                    FROM
                                        EMPLOYEE_POSITION_BRANCHES
                                    WHERE
                                        POSITION_CODE = #SESSION.EP.POSITION_CODE#	
                                )
		<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
				AND
				(
					TRAINING_CLASS.CLASS_NAME LIKE '%#attributes.KEYWORD#%'
					OR
					TRAINING_CLASS.CLASS_OBJECTIVE LIKE '%#attributes.KEYWORD#%'
					OR
					EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE '%#attributes.KEYWORD#%'
					OR
					EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '%#attributes.KEYWORD#%'
				)
		</cfif>
		<cfif isDefined("attributes.date1") and len(attributes.date1)>
			AND TRAINING_CLASS.FINISH_DATE >= #attributes.date1#
			<!--- <cfif database_type is "MSSQL">
				AND (#DATEADD("D",1,attributes.date1)# BETWEEN TRAINING_CLASS.START_DATE AND DATEADD("D",1,TRAINING_CLASS.FINISH_DATE))
			<cfelseif database_type is "DB2">
				AND (#DATEADD("D",1,attributes.date1)# BETWEEN TRAINING_CLASS.START_DATE AND (TRAINING_CLASS.FINISH_DATE + 1 DAYS))
			</cfif> --->
		</cfif>
		<cfif isdefined("attributes.ic_dis") and len(attributes.ic_dis)>AND INT_OR_EXT = #attributes.ic_dis#</cfif>
UNION
	SELECT 
		'partner' AS TYPE,
		<cfif database_type is "MSSQL">
			COMPANY_PARTNER.COMPANY_PARTNER_NAME + ' ' +	COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS ATTENDER_NAME,
		<cfelseif database_type is "DB2">
			COMPANY_PARTNER.COMPANY_PARTNER_NAME || ' ' ||	COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS ATTENDER_NAME,
		</cfif>
		COMPANY_PARTNER.TITLE AS POSITION,
		' ' AS DEPARTMAN, 
		COMPANY.NICKNAME AS NICK_NAME,
		' ' AS BRANCH_NAME,
		TRAINING_CLASS.CLASS_NAME AS CLASS_NAME,
		TRAINING_CLASS_ATTENDER.CLASS_ID,
		TRAINING_CLASS_ATTENDER.PAR_ID,
		TRAINING_CLASS_ATTENDER.EMP_ID,
		TRAINING_CLASS_ATTENDER.CON_ID,
		<!--- TRAINING_CLASS.TRAINER_EMP,
		TRAINING_CLASS.TRAINER_PAR,
		TRAINING_CLASS.TRAINER_CONS, --->
		TRAINING_CLASS.START_DATE,
		TRAINING_CLASS.FINISH_DATE,
		TRAINING_CLASS.DATE_NO,
		TRAINING_CLASS.HOUR_NO,
		TRAINING_CLASS.INT_OR_EXT,
		' ' AS ZONE_NAME
	FROM
		TRAINING_CLASS_ATTENDER,
		TRAINING_CLASS,
		COMPANY_PARTNER,
		COMPANY
	WHERE
		TRAINING_CLASS_ATTENDER.CLASS_ID = TRAINING_CLASS.CLASS_ID
		AND TRAINING_CLASS_ATTENDER.PAR_ID IS NOT NULL
		AND COMPANY_PARTNER.PARTNER_ID = TRAINING_CLASS_ATTENDER.PAR_ID
		AND COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
		AND TRAINING_CLASS.FINISH_DATE < #attributes.TO_DAY#
		<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
				AND
				(
					TRAINING_CLASS.CLASS_NAME LIKE '%#attributes.KEYWORD#%'
					OR
					TRAINING_CLASS.CLASS_OBJECTIVE LIKE '%#attributes.KEYWORD#%'
					OR
					COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE '%#attributes.KEYWORD#%'
					OR
					COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE '%#attributes.KEYWORD#%'
				)
		</cfif>
		<cfif isDefined("attributes.date1") and len(attributes.date1)>
			AND TRAINING_CLASS.FINISH_DATE >= #attributes.date1#
			<!--- <cfif database_type is "MSSQL">
				AND (#DATEADD("D",1,attributes.date1)# BETWEEN TRAINING_CLASS.START_DATE AND DATEADD("D",1,TRAINING_CLASS.FINISH_DATE))
			<cfelseif database_type is "DB2">
				AND (#DATEADD("D",1,attributes.date1)# BETWEEN TRAINING_CLASS.START_DATE AND (TRAINING_CLASS.FINISH_DATE + 1 DAYS))
			</cfif> --->
		</cfif>
		<cfif isdefined("attributes.ic_dis") and len(attributes.ic_dis)>AND INT_OR_EXT = #attributes.ic_dis#</cfif>
UNION
	SELECT
		'consumer' AS TYPE,
		<cfif database_type is "MSSQL">
			CONSUMER.CONSUMER_NAME + ' ' +	CONSUMER.CONSUMER_SURNAME AS ATTENDER_NAME,
		<cfelseif database_type is "DB2">
			CONSUMER.CONSUMER_NAME || ' ' ||	CONSUMER.CONSUMER_SURNAME AS ATTENDER_NAME,
		</cfif>
		CONSUMER.TITLE AS POSITION,
		' ' AS DEPARTMAN,
		CONSUMER.COMPANY AS NICK_NAME,
		' ' AS BRANCH_NAME,
		TRAINING_CLASS.CLASS_NAME AS CLASS_NAME,
		TRAINING_CLASS_ATTENDER.CLASS_ID,
		TRAINING_CLASS_ATTENDER.PAR_ID,
		TRAINING_CLASS_ATTENDER.EMP_ID,
		TRAINING_CLASS_ATTENDER.CON_ID,
		<!--- TRAINING_CLASS.TRAINER_EMP,
		TRAINING_CLASS.TRAINER_PAR,
		TRAINING_CLASS.TRAINER_CONS, --->
		TRAINING_CLASS.START_DATE,
		TRAINING_CLASS.FINISH_DATE,
		TRAINING_CLASS.DATE_NO,
		TRAINING_CLASS.HOUR_NO,
		TRAINING_CLASS.INT_OR_EXT,
		' ' AS ZONE_NAME
	FROM
		TRAINING_CLASS_ATTENDER,
		TRAINING_CLASS,
		CONSUMER
	WHERE
		TRAINING_CLASS_ATTENDER.CLASS_ID = TRAINING_CLASS.CLASS_ID
		AND TRAINING_CLASS_ATTENDER.CON_ID IS NOT NULL
		AND CONSUMER.CONSUMER_ID = TRAINING_CLASS_ATTENDER.CON_ID
		AND TRAINING_CLASS.FINISH_DATE < #attributes.TO_DAY# 
		<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
				AND
				(
					TRAINING_CLASS.CLASS_NAME LIKE '%#attributes.KEYWORD#%'
					OR
					TRAINING_CLASS.CLASS_OBJECTIVE LIKE '%#attributes.KEYWORD#%'
					OR
					CONSUMER.CONSUMER_NAME LIKE '%#attributes.KEYWORD#%'
					OR
					CONSUMER.CONSUMER_SURNAME LIKE '%#attributes.KEYWORD#%'
				)
		</cfif>
		<cfif isDefined("attributes.date1") and len(attributes.date1)>
			AND TRAINING_CLASS.FINISH_DATE >= #attributes.date1#
			<!--- <cfif database_type is "MSSQL">
				AND (#DATEADD("D",1,attributes.date1)# BETWEEN TRAINING_CLASS.START_DATE AND DATEADD("D",1,TRAINING_CLASS.FINISH_DATE))
			<cfelseif database_type is "DB2">
				AND (#DATEADD("D",1,attributes.date1)# BETWEEN TRAINING_CLASS.START_DATE AND (TRAINING_CLASS.FINISH_DATE + 1 DAYS))
			</cfif> --->
		</cfif>
		<cfif isdefined("attributes.ic_dis") and len(attributes.ic_dis)>AND INT_OR_EXT = #attributes.ic_dis#</cfif>
ORDER BY
	<cfif len(attributes.sirala_1) and attributes.sirala_1 eq 1>
		ZONE_NAME,
	<cfelseif len(attributes.sirala_1) and attributes.sirala_1 eq 2>
		BRANCH_NAME,
	<cfelseif len(attributes.sirala_1) and attributes.sirala_1 eq 3>
		DEPARTMENT_HEAD,
	<cfelseif len(attributes.sirala_1) and attributes.sirala_1 eq 4>
		ATTENDER_NAME,
	<cfelseif len(attributes.sirala_1) and attributes.sirala_1 eq 5>
		CLASS_NAME,
	</cfif>
	<cfif len(attributes.sirala_2) and attributes.sirala_2 eq 1>
		ZONE_NAME,
	<cfelseif len(attributes.sirala_2) and attributes.sirala_2 eq 2>
		BRANCH_NAME,
	<cfelseif len(attributes.sirala_2) and attributes.sirala_2 eq 3>
		DEPARTMENT_HEAD,
	<cfelseif len(attributes.sirala_2) and attributes.sirala_2 eq 4>
		ATTENDER_NAME,
	<cfelseif len(attributes.sirala_2) and attributes.sirala_2 eq 5>
		CLASS_NAME,
	</cfif>
	<cfif len(attributes.sirala_3) and attributes.sirala_3 eq 1>
		ZONE_NAME,
	<cfelseif len(attributes.sirala_3) and attributes.sirala_3 eq 2>
		BRANCH_NAME,
	<cfelseif len(attributes.sirala_3) and attributes.sirala_3 eq 3>
		DEPARTMENT_HEAD,
	<cfelseif len(attributes.sirala_3) and attributes.sirala_3 eq 4>
		ATTENDER_NAME,
	<cfelseif len(attributes.sirala_3) and attributes.sirala_3 eq 5>
		CLASS_NAME,
	</cfif>
	START_DATE
		DESC
</cfquery>
