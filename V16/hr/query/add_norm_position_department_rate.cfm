<cfquery name="get_departments" datasource="#dsn#">
	SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID = #attributes.branch_id#
</cfquery>

<cfoutput query="get_departments">
	<cfset dept_id_ = department_id>
	<cfset year_ = attributes.norm_year>
	<cfquery name="get_" datasource="#dsn#">
		SELECT 
            DEPARTMENT_ID, 
            AVERAGE_RATE_1, 
            AVERAGE_RATE_2, 
            AVERAGE_RATE_3, 
            AVERAGE_RATE_4, 
            AVERAGE_RATE_5, 
            AVERAGE_RATE_6,
            AVERAGE_RATE_7, 
            AVERAGE_RATE_8, 
            AVERAGE_RATE_9, 
            AVERAGE_RATE_10, 
            AVERAGE_RATE_11,
            AVERAGE_RATE_12, 
            AVERAGE_RATE_YEAR, 
            RECORD_EMP, 
            RECORD_DATE, 
            RECORD_IP, 
            UPDATE_EMP, 
            UPDATE_DATE, 
            UPDATE_IP 
        FROM 
    	    EMPLOYEE_NORM_POSITIONS_DEPT_RATE 
        WHERE 
	        DEPARTMENT_ID = #dept_id_#
        AND 
        	AVERAGE_RATE_YEAR = #year_#
	</cfquery>
	
	<cfif get_.recordcount>
		<cfquery name="upd_" datasource="#dsn#">
			UPDATE 
				EMPLOYEE_NORM_POSITIONS_DEPT_RATE
			SET
				AVERAGE_RATE_1 = <cfif len(evaluate("attributes.ongorulen_1_#dept_id_#"))>#evaluate("attributes.ongorulen_1_#dept_id_#")#<cfelse>NULL</cfif>,
				AVERAGE_RATE_2 = <cfif len(evaluate("attributes.ongorulen_2_#dept_id_#"))>#evaluate("attributes.ongorulen_2_#dept_id_#")#<cfelse>NULL</cfif>,
				AVERAGE_RATE_3 = <cfif len(evaluate("attributes.ongorulen_3_#dept_id_#"))>#evaluate("attributes.ongorulen_3_#dept_id_#")#<cfelse>NULL</cfif>,
				AVERAGE_RATE_4 = <cfif len(evaluate("attributes.ongorulen_4_#dept_id_#"))>#evaluate("attributes.ongorulen_4_#dept_id_#")#<cfelse>NULL</cfif>,
				AVERAGE_RATE_5 = <cfif len(evaluate("attributes.ongorulen_5_#dept_id_#"))>#evaluate("attributes.ongorulen_5_#dept_id_#")#<cfelse>NULL</cfif>,
				AVERAGE_RATE_6 = <cfif len(evaluate("attributes.ongorulen_6_#dept_id_#"))>#evaluate("attributes.ongorulen_6_#dept_id_#")#<cfelse>NULL</cfif>,
				AVERAGE_RATE_7 = <cfif len(evaluate("attributes.ongorulen_7_#dept_id_#"))>#evaluate("attributes.ongorulen_7_#dept_id_#")#<cfelse>NULL</cfif>,
				AVERAGE_RATE_8 = <cfif len(evaluate("attributes.ongorulen_8_#dept_id_#"))>#evaluate("attributes.ongorulen_8_#dept_id_#")#<cfelse>NULL</cfif>,
				AVERAGE_RATE_9 = <cfif len(evaluate("attributes.ongorulen_9_#dept_id_#"))>#evaluate("attributes.ongorulen_9_#dept_id_#")#<cfelse>NULL</cfif>,
				AVERAGE_RATE_10 = <cfif len(evaluate("attributes.ongorulen_10_#dept_id_#"))>#evaluate("attributes.ongorulen_10_#dept_id_#")#<cfelse>NULL</cfif>,
				AVERAGE_RATE_11 = <cfif len(evaluate("attributes.ongorulen_11_#dept_id_#"))>#evaluate("attributes.ongorulen_11_#dept_id_#")#<cfelse>NULL</cfif>,
				AVERAGE_RATE_12 = <cfif len(evaluate("attributes.ongorulen_12_#dept_id_#"))>#evaluate("attributes.ongorulen_12_#dept_id_#")#<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_EMP = #session.ep.userid#
			WHERE
				DEPARTMENT_ID = #dept_id_# AND 
				AVERAGE_RATE_YEAR = #year_#
		</cfquery>
	<cfelse>
		<cfquery name="add_" datasource="#dsn#">
			INSERT INTO
				EMPLOYEE_NORM_POSITIONS_DEPT_RATE
				(
				DEPARTMENT_ID,
				AVERAGE_RATE_YEAR,
				AVERAGE_RATE_1,
				AVERAGE_RATE_2,
				AVERAGE_RATE_3,
				AVERAGE_RATE_4,
				AVERAGE_RATE_5,
				AVERAGE_RATE_6,
				AVERAGE_RATE_7,
				AVERAGE_RATE_8,
				AVERAGE_RATE_9,
				AVERAGE_RATE_10,
				AVERAGE_RATE_11,
				AVERAGE_RATE_12,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
				)
				VALUES
				(
				#dept_id_#,
				#year_#,
				<cfif len(evaluate("attributes.ongorulen_1_#dept_id_#"))>#evaluate("attributes.ongorulen_1_#dept_id_#")#<cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.ongorulen_2_#dept_id_#"))>#evaluate("attributes.ongorulen_2_#dept_id_#")#<cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.ongorulen_3_#dept_id_#"))>#evaluate("attributes.ongorulen_3_#dept_id_#")#<cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.ongorulen_4_#dept_id_#"))>#evaluate("attributes.ongorulen_4_#dept_id_#")#<cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.ongorulen_5_#dept_id_#"))>#evaluate("attributes.ongorulen_5_#dept_id_#")#<cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.ongorulen_6_#dept_id_#"))>#evaluate("attributes.ongorulen_6_#dept_id_#")#<cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.ongorulen_7_#dept_id_#"))>#evaluate("attributes.ongorulen_7_#dept_id_#")#<cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.ongorulen_8_#dept_id_#"))>#evaluate("attributes.ongorulen_8_#dept_id_#")#<cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.ongorulen_9_#dept_id_#"))>#evaluate("attributes.ongorulen_9_#dept_id_#")#<cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.ongorulen_10_#dept_id_#"))>#evaluate("attributes.ongorulen_10_#dept_id_#")#<cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.ongorulen_11_#dept_id_#"))>#evaluate("attributes.ongorulen_11_#dept_id_#")#<cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.ongorulen_12_#dept_id_#"))>#evaluate("attributes.ongorulen_12_#dept_id_#")#<cfelse>NULL</cfif>,
				#now()#,
				'#CGI.REMOTE_ADDR#',
				#session.ep.userid#
				)
		</cfquery>
	</cfif>
</cfoutput>
