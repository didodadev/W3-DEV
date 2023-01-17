<cfcomponent>
	<cffunction name="getTypePos" access="public" returntype="query">
		<cfargument name="acc_type_id" type="numeric" required="yes" default="0">

		<cfquery name="Get_Type_Pos" datasource="#this.dsn#">
			SELECT 
				E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS NAMESURNAME
			FROM 
				SETUP_ACC_TYPE_POSID SETUP_POS INNER JOIN EMPLOYEE_POSITIONS EP 
                ON SETUP_POS.POSITION_ID = EP.POSITION_ID 
                INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
            WHERE
            	SETUP_POS.ACC_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.acc_type_id#">
			ORDER BY 
				E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME
		</cfquery>
		<cfreturn Get_Type_Pos>
	</cffunction>
</cfcomponent>
