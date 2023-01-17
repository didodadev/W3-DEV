<cfquery name="get_upper_pos_code" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEES E, EMPLOYEE_POSITIONS EP WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND UPPER_POSITION_CODE =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND EMPLOYEE_STATUS = 1
</cfquery>
<cfquery name="get_upper_pos_code2" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEES E, EMPLOYEE_POSITIONS EP WHERE E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND UPPER_POSITION_CODE2 =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND EMPLOYEE_STATUS = 1
</cfquery>
<cfquery name="get_control_val" datasource="#dsn#">
    SELECT 
         PROPERTY_VALUE,
         PROPERTY_NAME
   FROM
         FUSEACTION_PROPERTY
    WHERE
         OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
         FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="myhome.welcome"> AND
         PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="xml_rel_pos">
</cfquery>
<cfif isdefined('get_control_val') and get_control_val.property_value eq 1>
	<cfquery name="get_rel_emps" datasource="#dsn#">
        SELECT MAIN_EMPLOYEE_ID FROM WORKGROUP_EMP_PAR WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND MAIN_EMPLOYEE_ID IS NOT NULL
    </cfquery>
</cfif>
<cfset list_upper_pos_code = session.ep.position_code>
<cfset list_upper_pos_code = listappend(valuelist(get_upper_pos_code.position_code),list_upper_pos_code)>
<cfset list_upper_pos_code = listappend(valuelist(get_upper_pos_code2.position_code),list_upper_pos_code)>

<cfquery name="get_upper_emps" datasource="#dsn#">
    SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (#list_upper_pos_code#)
</cfquery>
<cfset list_upper_emp_ids = session.ep.userid>
<cfset list_upper_emp_ids = listappend(valuelist(get_upper_emps.employee_id),list_upper_emp_ids)>
<cfif isdefined('get_rel_emps')>
	<cfset list_upper_emp_ids = listappend(valuelist(get_rel_emps.main_employee_id),list_upper_emp_ids)>
</cfif>
<cfquery name="GET_OFFTIMES_" datasource="#DSN#">
	SELECT 
		OFFTIME.*,
		SETUP_OFFTIME.OFFTIMECAT,
		SETUP_OFFTIME.IS_PAID,
		SETUP_OFFTIME.IS_YEARLY,
        SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
		SETUP_OFFTIME.CALC_CALENDAR_DAY,
		CASE 
            WHEN ISNULL(OFFTIME.SUB_OFFTIMECAT_ID,0) <> 0 THEN (SELECT top 1 OFFTIMECAT FROM SETUP_OFFTIME A WHERE A.OFFTIMECAT_ID = OFFTIME.SUB_OFFTIMECAT_ID)
            WHEN ISNULL(OFFTIME.SUB_OFFTIMECAT_ID,0) = 0 THEN (SELECT top 1  OFFTIMECAT FROM OFFTIME B WHERE B.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID)
        END AS NEW_CAT_NAME
	FROM 
		OFFTIME,
		EMPLOYEES,
		SETUP_OFFTIME
	WHERE
		OFFTIME.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
		OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
		<cfif len(attributes.employee_id) and len(attributes.emp_name)>
			OFFTIME.EMPLOYEE_ID = #attributes.employee_id# AND
		<cfelse>
			EMPLOYEES.EMPLOYEE_ID IN (#list_upper_emp_ids#) AND
		</cfif>
		<cfif isDefined("attributes.offtimecat_id") and len(attributes.offtimecat_id)>
			SETUP_OFFTIME.OFFTIMECAT_ID = #attributes.offtimecat_id# AND
		</cfif>
		(
			OFFTIME.IS_PLAN <> 1 OR OFFTIME.IS_PLAN IS NULL
		)
	ORDER BY
		OFFTIME.STARTDATE DESC
</cfquery>
<cfquery name="GET_OFFTIMES" dbtype="query">
	SELECT 
		*
	FROM 
		GET_OFFTIMES_
	WHERE
		1=1  
		<cfif len(attributes.startdate)>
			AND STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp"  value="#attributes.startdate#">  
		</cfif>
		<cfif len(attributes.finishdate)>
			AND FINISHDATE < #dateadd('d',1,attributes.finishdate)#  
		</cfif>
</cfquery>
<!---genel toplam icin kullanildi--->
<cfquery name="GET_OFFTIME" dbtype="query">
	SELECT 
		*
	FROM 
		GET_OFFTIMES_
	WHERE
		<cfif len(get_emp.IZIN_DATE)>
			STARTDATE > <cfqueryparam cfsqltype="cf_sql_date" value="#get_emp.IZIN_DATE#"> AND
		</cfif>
		IS_PUANTAJ_OFF = 0 AND
		VALID = 1 AND
		IS_PAID = 1 AND
		IS_YEARLY = 1		
</cfquery>

