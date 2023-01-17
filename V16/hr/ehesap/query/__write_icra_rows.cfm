<cfset nafaka_type_id = 0>
<cfset nafaka_id = 0>

<cfset icra_type_id = 0>
<cfset icra_id = 0>

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
		COMMANDMENT_ID
	FROM 
		COMMANDMENT 
	WHERE 
		EMPLOYEE_ID = #attributes.employee_id# AND
		COMMANDMENT_TYPE = 2 AND
		COMMANDMENT_DATE <= #parameter_last_month_30#
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
			'#get_type.ACCOUNT_CODE#',
			'#get_type.ACCOUNT_NAME#',
			<cfif len(get_type.ACC_TYPE_ID)>#get_type.ACC_TYPE_ID#<cfelse>NULL</cfif>,
			<cfif len(get_type.TAX)>#get_type.TAX#<cfelse>NULL</cfif>,
			#get_nafaka.COMMANDMENT_VALUE#,
			'COMMANDMENT',
			#get_nafaka.COMMANDMENT_ID#,
			'#nafaka_type_id#-#nafaka_id#'
			)
	</cfquery>
</cfif>


<cfset maksimum_icra_tutar = 0>	
<cfquery name="get_icra" datasource="#dsn#">
	SELECT TOP 1
		(COMMANDMENT_VALUE - PRE_COMMANDMENT_VALUE - ODENEN) AS TOTAL_ICRA,
		TYPE_ID,
		RATE_VALUE,
		COMMANDMENT_ID
	FROM 
		COMMANDMENT 
	WHERE 
		EMPLOYEE_ID = #attributes.employee_id# AND 
		(COMMANDMENT_VALUE - PRE_COMMANDMENT_VALUE - ODENEN) > 0 AND 
		COMMANDMENT_TYPE = 1 AND
		COMMANDMENT_DATE <= #parameter_last_month_30#
	ORDER BY
		PRIORITY ASC
</cfquery>

<cfif get_icra.recordcount>
	<cfset maksimum_icra_tutar = get_icra.TOTAL_ICRA>		
		<cfquery name="get_type" datasource="#dsn#">
			SELECT * FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = #get_icra.TYPE_ID#
		</cfquery>
		
		<cfset icra_type_id = get_icra.TYPE_ID>
		<cfset icra_id = get_icra.COMMANDMENT_ID>
		
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
				'#get_type.ACCOUNT_CODE#',
				'#get_type.ACCOUNT_NAME#',
				<cfif len(get_type.ACC_TYPE_ID)>#get_type.ACC_TYPE_ID#<cfelse>NULL</cfif>,
				<cfif len(get_type.TAX)>#get_type.TAX#<cfelse>NULL</cfif>,
				#get_icra.RATE_VALUE#,
				'COMMANDMENT',
				#get_icra.COMMANDMENT_ID#,
				'#icra_type_id#-#icra_id#'
				)
		</cfquery>
</cfif>