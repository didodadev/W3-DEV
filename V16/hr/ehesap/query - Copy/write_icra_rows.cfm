<cfset nafaka_type_id = 0>
<cfset nafaka_id = 0>
<cfset nafaka_tutar = 0>

<cfset icra_type_id = StructNew()>
<cfset icra_id = StructNew()>

<cfquery name="clear_icra" datasource="#dsn#">
	DELETE 
		COMMANDMENT_ROWS 
	WHERE 
		EMPLOYEE_PUANTAJ_ID NOT IN (SELECT EMPLOYEE_PUANTAJ_ID FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE RELATED_TABLE = 'COMMANDMENT')
</cfquery>

<cfquery name="upd_" datasource="#dsn#">
	UPDATE
		COMMANDMENT
	SET
		ODENEN = ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM COMMANDMENT_ROWS WHERE COMMANDMENT_ID = COMMANDMENT.COMMANDMENT_ID),0)
	WHERE
		COMMANDMENT_TYPE = 1
</cfquery>
<cfquery name="del_" datasource="#dsn#">
	DELETE FROM 
		SALARYPARAM_GET 
	WHERE 
		IN_OUT_ID = #attributes.in_out_id# AND 
		START_SAL_MON = #attributes.sal_mon# AND 
		END_SAL_MON = #attributes.sal_mon# AND 
		TERM = #attributes.sal_year# AND 
		RELATED_TABLE = 'COMMANDMENT'
</cfquery>

<cfquery name="get_nafaka" datasource="#dsn#">
	SELECT TOP 1
		COMMANDMENT_VALUE,
		TYPE_ID,
		RATE_VALUE,
		COMMANDMENT_ID,
		ACCOUNT_CODE,
		ACCOUNT_NAME,
		ACC_TYPE_ID
	FROM 
		COMMANDMENT 
	WHERE 
		EMPLOYEE_ID = #attributes.employee_id# AND
		COMMANDMENT_TYPE = 2 AND
		IS_APPLY = 1 AND
		ISNULL(IS_MANUEL_CLOSED,0) = 0
	ORDER BY
		PRIORITY ASC
</cfquery>

<cfif get_nafaka.recordcount>	
	<cfquery name="get_type" datasource="#dsn#">
		SELECT * FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = #get_nafaka.TYPE_ID#
	</cfquery>
	
	<cfset nafaka_type_id = get_nafaka.TYPE_ID>
	<cfset nafaka_id = get_nafaka.COMMANDMENT_ID>
	
	<cfquery name="add_" datasource="#dsn#" result="add_r">
		INSERT INTO
			SALARYPARAM_GET
			(
			COMMENT_GET,
			PERIOD_GET,
			METHOD_GET,
			AMOUNT_GET,
			SHOW,
			TERM,
			START_SAL_MON,
			END_SAL_MON,
			EMPLOYEE_ID,
			IN_OUT_ID,
			CALC_DAYS,
			FROM_SALARY,
			IS_INST_AVANS,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP,
			COMMENT_GET_ID,
			ACCOUNT_CODE,
			ACCOUNT_NAME,
			ACC_TYPE_ID,
			TAX,
			TOTAL_GET,
			RELATED_TABLE,
			RELATED_TABLE_ID,
			DETAIL
			)
			VALUES
			(
			'#get_type.comment_pay#',
			1,
			1,
			#get_nafaka.COMMANDMENT_VALUE#,
			1,
			#attributes.sal_year#,
			#attributes.sal_mon#,
			#attributes.sal_mon#,
			#attributes.EMPLOYEE_ID#,
			#attributes.in_out_id#,
			0,
			0,
			0,
			#now()#,
			'#cgi.REMOTE_ADDR#',
			#session.ep.userid#,
			#get_nafaka.TYPE_ID#,
			'#get_nafaka.ACCOUNT_CODE#',
			'#get_nafaka.ACCOUNT_NAME#',
			<cfif len(get_nafaka.ACC_TYPE_ID)>#get_nafaka.ACC_TYPE_ID#<cfelse>NULL</cfif>,
			<cfif len(get_type.TAX)>#get_type.TAX#<cfelse>NULL</cfif>,
			#get_nafaka.COMMANDMENT_VALUE#,
			'COMMANDMENT',
			#get_nafaka.COMMANDMENT_ID#,
			'#nafaka_type_id#-#nafaka_id#'
			)
	</cfquery>
	<cfset nafaka_tutar = get_nafaka.COMMANDMENT_VALUE>
</cfif>


<cfset maksimum_icra_tutar = 0>	
<cfset maksimum_icra_yuzdesi = 0>	
<cfquery name="get_icra" datasource="#dsn#">
	SELECT 
		(COMMANDMENT_VALUE - PRE_COMMANDMENT_VALUE - ODENEN) AS TOTAL_ICRA,
		TYPE_ID,
		RATE_VALUE,
		COMMANDMENT_ID,
		ACCOUNT_CODE,
		ACCOUNT_NAME,
		ACC_TYPE_ID,
		ADD_PAYMENT_TYPE,
		ISNULL(EMP_APPROVE,0) EMP_APPROVE,
        RATE_VALUE_STATIC,
        (PRE_COMMANDMENT_VALUE + ODENEN) ODENEN,
		PAY_COMMANDMENT_VALUE
	FROM 
		COMMANDMENT 
	WHERE 
		EMPLOYEE_ID = #attributes.employee_id# AND 
		(COMMANDMENT_VALUE - PRE_COMMANDMENT_VALUE - ODENEN) > 0 AND 
		COMMANDMENT_TYPE = 1 AND
		IS_APPLY = 1 AND
		ISNULL(IS_MANUEL_CLOSED,0) = 0
		AND COMMANDMENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_30#">
	ORDER BY
		PRIORITY ASC,
		COMMANDMENT_DATE ASC

</cfquery>
<cfif get_icra.recordcount>
	<cfset list_icra_ids = ''>
	<cfset list_IDENTITYCOL = ''>
	<cfset maksimum_icra_yuzdesi = StructNew()>
	<cfset maksimum_icra_tutar = StructNew()>
	<cfset icra_add_payment_type = StructNew()>
	<cfset is_emp_approve = StructNew()>
	<cfset icra_type_id = StructNew()>
	<cfset icra_id = StructNew()>
	<cfloop query="get_icra" >
		<cfset list_icra_ids = listAppend(list_icra_ids,COMMANDMENT_ID,',')>
		<cfset icra_add_payment_type["#COMMANDMENT_ID#"] = get_icra.ADD_PAYMENT_TYPE>
		<cfif len(get_hr_ssk.finish_date) and len(get_icra.PAY_COMMANDMENT_VALUE) and get_icra.PAY_COMMANDMENT_VALUE gt 0 and not isdefined("is_execution")>
			<cfset maksimum_icra_yuzdesi["#COMMANDMENT_ID#"] = 100>
            <cfif get_icra.PAY_COMMANDMENT_VALUE lt get_icra.TOTAL_ICRA>
                <cfset maksimum_icra_tutar["#COMMANDMENT_ID#"] = get_icra.PAY_COMMANDMENT_VALUE>
            <cfelse>
                <cfset maksimum_icra_tutar["#COMMANDMENT_ID#"] = get_icra.TOTAL_ICRA>
            </cfif>
		<cfelseif get_icra.RATE_VALUE eq 1>
            <cfset maksimum_icra_yuzdesi["#COMMANDMENT_ID#"] = 100>
            <cfif get_icra.rate_value_static lt get_icra.TOTAL_ICRA>
                <cfset maksimum_icra_tutar["#COMMANDMENT_ID#"] = get_icra.rate_value_static>
            <cfelse>
                <cfset maksimum_icra_tutar["#COMMANDMENT_ID#"] = get_icra.TOTAL_ICRA>
            </cfif>
        <cfelse>
		    <cfset maksimum_icra_yuzdesi["#COMMANDMENT_ID#"] = get_icra.RATE_VALUE>
            <cfset maksimum_icra_tutar["#COMMANDMENT_ID#"] = get_icra.TOTAL_ICRA>
        </cfif>	
		<cfset is_emp_approve["#COMMANDMENT_ID#"] = get_icra.EMP_APPROVE>	
		
		<cfquery name="get_type" datasource="#dsn#">
			SELECT * FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = #get_icra.TYPE_ID#
		</cfquery>
		
		<cfset icra_type_id["#COMMANDMENT_ID#"] = get_icra.TYPE_ID>
		<cfset icra_id["#COMMANDMENT_ID#"] = get_icra.COMMANDMENT_ID>
		
		<cfquery name="add_" datasource="#dsn#" result="add_r">
			INSERT INTO
				SALARYPARAM_GET
				(
				COMMENT_GET,
				PERIOD_GET,
				METHOD_GET,
				AMOUNT_GET,
				SHOW,
				TERM,
				START_SAL_MON,
				END_SAL_MON,
				EMPLOYEE_ID,
				IN_OUT_ID,
				CALC_DAYS,
				FROM_SALARY,
				IS_INST_AVANS,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP,
				COMMENT_GET_ID,
				ACCOUNT_CODE,
				ACCOUNT_NAME,
				ACC_TYPE_ID,
				TAX,
				TOTAL_GET,
				RELATED_TABLE,
				RELATED_TABLE_ID,
				DETAIL
				)
				VALUES
				(
				'#get_type.comment_pay#',
				1,
				5,
				#get_icra.RATE_VALUE#,
				1,
				#attributes.sal_year#,
				#attributes.sal_mon#,
				#attributes.sal_mon#,
				#attributes.EMPLOYEE_ID#,
				#attributes.in_out_id#,
				0,
				0,
				0,
				#now()#,
				'#cgi.REMOTE_ADDR#',
				#session.ep.userid#,
				#get_icra.TYPE_ID#,
				'#get_icra.ACCOUNT_CODE#',
				'#get_icra.ACCOUNT_NAME#',
				<cfif len(get_icra.ACC_TYPE_ID)>#get_icra.ACC_TYPE_ID#<cfelse>NULL</cfif>,
				<cfif len(get_type.TAX)>#get_type.TAX#<cfelse>NULL</cfif>,
				#get_icra.RATE_VALUE#,
				'COMMANDMENT',
				#get_icra.COMMANDMENT_ID#,
				'#icra_type_id["#COMMANDMENT_ID#"]#-#icra_id["#COMMANDMENT_ID#"]#'
				)
		</cfquery>
		<cfset list_IDENTITYCOL= listAppend(list_IDENTITYCOL,add_r.IDENTITYCOL,',')>
	</cfloop>
	<cfset add_r.IDENTITYCOL = list_IDENTITYCOL>
	<!--- <cfset icra_id = list_icra_ids> --->
</cfif>