<!--- bu dosyanin benzeri ik calisan detayinda da var --->
<cfquery name="GET_GENERAL_OFFTIMES" datasource="#DSN#">
	SELECT START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM SETUP_GENERAL_OFFTIMES
</cfquery>
<cfset attributes.employee_id = #session.ep.userid#>
<cfif (isDefined('attributes.employee_id') and (not len(attributes.employee_id) or not isnumeric(attributes.employee_id)))>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='58943.Boyle Bir Kayit Bulunmamaktadir'>!");
		window.close(); 
	</script>
	<cfabort>
</cfif>
<cfquery name="get_emp" datasource="#dsn#">
	SELECT 
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.KIDEM_DATE,
		E.IZIN_DATE,
		E.IZIN_DAYS,
		E.OLD_SGK_DAYS,
		EI.BIRTH_DATE,
		E.GROUP_STARTDATE,
		(SELECT TOP 1 PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY FINISH_DATE ASC) AS PUANTAJ_GROUP_IDS,
        (SELECT TOP 1 FINISH_DATE FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY FINISH_DATE ASC) AS FINISH_DATE
	FROM
		EMPLOYEES E
		INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
	WHERE 
		E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>

<cfif len(get_emp.IZIN_DATE)>
	<!--- Izin baz tarihinden Onceki Izinler --->						
	<cfquery name="get_offtime_old" datasource="#dsn#">
		SELECT 
			OFFTIME.*,
			SETUP_OFFTIME.OFFTIMECAT_ID,
			SETUP_OFFTIME.OFFTIMECAT,
			SETUP_OFFTIME.IS_PAID
		FROM 
			OFFTIME,
			SETUP_OFFTIME
		WHERE
			SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID AND
			OFFTIME.IS_PUANTAJ_OFF = 0 AND
			OFFTIME.VALID = 1 AND
			SETUP_OFFTIME.IS_PAID = 1 AND
			SETUP_OFFTIME.IS_YEARLY = 1	AND
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
			OFFTIME.FINISHDATE < <cfqueryparam cfsqltype="cf_sql_date" value="#get_emp.izin_date#">
		ORDER BY
			STARTDATE DESC
	</cfquery>
	<!--- // İZİN BAZ TARİHİNDEN ÖNCEKİ İZİNLER --->
</cfif>

<cfquery name="get_offtime" datasource="#dsn#">
	SELECT 
		OFFTIME.*,
		SETUP_OFFTIME.OFFTIMECAT_ID,
		SETUP_OFFTIME.OFFTIMECAT,
		SETUP_OFFTIME.IS_PAID
	FROM 
		OFFTIME,
		SETUP_OFFTIME
	WHERE
		<cfif len(get_emp.IZIN_DATE)>
			OFFTIME.STARTDATE > <cfqueryparam cfsqltype="cf_sql_date" value="#get_emp.IZIN_DATE#"> AND
		</cfif>
		SETUP_OFFTIME.OFFTIMECAT_ID=OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.IS_PUANTAJ_OFF = 0 AND
		OFFTIME.VALID = 1 AND
		SETUP_OFFTIME.IS_PAID = 1 AND
		SETUP_OFFTIME.IS_YEARLY = 1 AND
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	ORDER BY
		STARTDATE DESC
</cfquery>
<cfinclude template="../../hr/display/list_offtime_emp_days.cfm">
<cfset is_control = 0>
<cfinclude template="/V16/hr/display/employee_offtime_contract_info.cfm">
<cfquery name="get_progress_payment_outs" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_PROGRESS_PAYMENT_OUT WHERE EMP_ID = #attributes.employee_id# AND START_DATE IS NOT NULL AND FINISH_DATE IS NOT NULL AND IS_YEARLY = 1
</cfquery>
<cfset genel_izin_toplam = 0> <!--- izinler toplanirken asagida lazim silmeyin yo20122005 --->
<cf_get_lang_set module_name="hr"><!--- sayfanin en altinda kapanisi var --->
<cfset attributes.employee_id = attributes.employee_id>


