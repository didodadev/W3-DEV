<!--- 
	amac            : NICKNAME,FULLNAME,MEMBER_CODE göre ilgili kurumsal,bireysel bilgilerine ulasmak
	parametre adi   : nickname
	ayirma isareti  : YOK
	kullanim        : get_member('Asu') 
	Yazan           : A.Selam Karatas
	Tarih           : 22.5.2007
	Guncelleme      : 22.5.2007
 --->
<cffunction name="get_member" access="public" returnType="query" output="no">
	<cfargument name="member_name" required="yes" type="string" default="">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfargument name="extra_deger" required="yes" type="string" default="">

	<cfif len(arguments.maxrows)>
		<cfquery name="GET_MEMBER" datasource="#DSN#" maxrows="#arguments.maxrows#">
			<cfif listfind(arguments.extra_deger,1,',')>
            SELECT
                1 TYPE,
                '[C]' TYPE_DESC,
                EP.EMPLOYEE_ID MEMBER_ID,
                EP.IS_MASTER MASTER_ID,
                <cfif database_type is "MSSQL">
                    (EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME) MEMBER_NAME,
                    (EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME) LONG_MEMBER_NAME,
                <cfelseif database_type is "DB2">
                    (EP.EMPLOYEE_NAME || ' ' || EP.EMPLOYEE_SURNAME) MEMBER_NAME,
                    (EP.EMPLOYEE_NAME || ' ' || EP.EMPLOYEE_SURNAME) LONG_MEMBER_NAME,
                </cfif>
                ' ' MEMBER_CODE
            FROM
                EMPLOYEES E,
                EMPLOYEE_POSITIONS EP
            WHERE
                E.EMPLOYEE_STATUS = 1 AND
                EP.POSITION_STATUS = 1 AND
                EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                (
                    EP.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#%"> OR
                    EP.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#%">
                )
            <cfif listfind(arguments.extra_deger,2,',') or listfind(arguments.extra_deger,3,',')>
          		UNION ALL
            </cfif>
		</cfif>
		 
		<cfif listfind(arguments.extra_deger,2,',')>
            SELECT
                2 TYPE,
                '[K]' as TYPE_DESC,
                COMPANY_ID MEMBER_ID,
                0 MASTER_ID,
                NICKNAME MEMBER_NAME,
                FULLNAME LONG_MEMBER_NAME,
                MEMBER_CODE
            FROM 
                COMPANY
            WHERE
                ISPOTANTIAL = 0 AND
                (
                FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#%"> OR
                NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#%"> OR
                MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#%">
                )
            <cfif listfind(arguments.extra_deger,3,',')>
                UNION ALL
            </cfif>
        </cfif>
        
		<cfif listfind(arguments.extra_deger,3,',')>
			SELECT
				3 TYPE,
                '[B]' as TYPE_DESC,
				CONSUMER_ID MEMBER_ID,
				0 MASTER_ID,
			<cfif database_type is "MSSQL">
				(CONSUMER_NAME + ' ' + CONSUMER_SURNAME) MEMBER_NAME,
				(CONSUMER_NAME + ' ' + CONSUMER_SURNAME) LONG_MEMBER_NAME,
			<cfelseif database_type is "DB2">
				(CONSUMER_NAME || ' ' || CONSUMER_SURNAME) MEMBER_NAME,
				(CONSUMER_NAME || ' ' || CONSUMER_SURNAME) LONG_MEMBER_NAME,
			</cfif>
				MEMBER_CODE
			FROM 
				CONSUMER
			WHERE
				ISPOTANTIAL = 0 AND
				(
				CONSUMER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#%"> OR
				CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#%"> OR
				MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#%">
				)
			ORDER BY
				MEMBER_NAME
		</cfif>
	  </cfquery>
	<cfelse>
		<cfquery name="GET_MEMBER" datasource="#DSN#">
		  
		 <cfif listfind(arguments.extra_deger,1,',')>
			SELECT
				1 TYPE,
                '[C]' TYPE_DESC,
				EP.EMPLOYEE_ID MEMBER_ID,
				EP.IS_MASTER MASTER_ID,
				<cfif database_type is "MSSQL">
					(EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME) MEMBER_NAME,
					(EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME) LONG_MEMBER_NAME,
				<cfelseif database_type is "DB2">
					(EP.EMPLOYEE_NAME || ' ' || EP.EMPLOYEE_SURNAME) MEMBER_NAME,
					(EP.EMPLOYEE_NAME || ' ' || EP.EMPLOYEE_SURNAME) LONG_MEMBER_NAME,
				</cfif>
				'' MEMBER_CODE
			FROM
				EMPLOYEES E,
				EMPLOYEE_POSITIONS EP
			WHERE
				E.EMPLOYEE_STATUS = 1 AND
				EP.POSITION_STATUS = 1 AND
				EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				(
				EP.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#%"> OR
				EP.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#%">
				)
		<cfif listfind(arguments.extra_deger,2,',') or listfind(arguments.extra_deger,3,',')>
			UNION ALL
		</cfif>
		</cfif>
		  
		  <cfif listfind(arguments.extra_deger,2,',')>
			SELECT
				2 TYPE,
                '[K]' as TYPE_DESC,
				COMPANY_ID MEMBER_ID,
				0 MASTER_ID,
				NICKNAME MEMBER_NAME,
				FULLNAME LONG_MEMBER_NAME,
				MEMBER_CODE
			FROM 
				COMPANY
			WHERE
				ISPOTANTIAL = 0 AND
				(
				FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#%"> OR
				NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#%"> OR
				MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#%">
				)
		 <cfif listfind(arguments.extra_deger,3,',')>
			UNION ALL
		 </cfif>
		 </cfif>
		 <cfif listfind(arguments.extra_deger,3,',')>
			SELECT
				3 TYPE,
                '[B]' as TYPE_DESC,
				CONSUMER_ID MEMBER_ID,
				0 MASTER_ID,
			<cfif database_type is "MSSQL">
				(CONSUMER_NAME + ' ' + CONSUMER_SURNAME) MEMBER_NAME,
				(CONSUMER_NAME + ' ' + CONSUMER_SURNAME) LONG_MEMBER_NAME,
			<cfelseif database_type is "DB2">
				(CONSUMER_NAME || ' ' || CONSUMER_SURNAME) MEMBER_NAME,
				(CONSUMER_NAME || ' ' || CONSUMER_SURNAME) LONG_MEMBER_NAME,
			</cfif>
				MEMBER_CODE
			FROM 
				CONSUMER
			WHERE
				ISPOTANTIAL = 0 AND
				(
				CONSUMER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#%"> OR
				CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#%"> OR
				MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#%">
				)
			ORDER BY
				MEMBER_NAME
			</cfif>
	  </cfquery>	
	</cfif>
	<cfreturn get_member>
</cffunction>
