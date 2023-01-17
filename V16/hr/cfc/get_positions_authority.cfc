<cfcomponent>
	<cffunction name="get_pos_auth" access="public" returntype="query">
		<cfargument name="keyword" default="">
		<cfargument name="status" default="">
		<cfargument name="maxrows" default="">
		<cfargument name="startrow" default="">
        <cfquery name="get_pos_auth_" datasource="#this.dsn#">
        	WITH CTE1 AS (
        		SELECT
        			TBL.*,
        			STUFF(
						(SELECT ', ' + A.[POSITION_CAT] FROM 
							(SELECT
								#this.dsn#.Get_Dynamic_Language(SETUP_POSITION_CAT.POSITION_CAT_ID,'#session.ep.language#','SETUP_POSITION_CAT','POSITION_CAT',NULL,NULL,SETUP_POSITION_CAT.POSITION_CAT) AS POSITION_CAT,
								EMPLOYEE_POSITIONS_AUTHORITY.AUTHORITY_ID
							FROM
								EMPLOYEE_POSITIONS_AUTHORITY
								INNER JOIN SETUP_POSITION_CAT ON SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS_AUTHORITY.POSITION_CAT_ID) A
						Where A.[AUTHORITY_ID]=TBL.[AUTHORITY_ID] FOR XML PATH('')
						),1,1,'') As POSITION_CATS,
						(SELECT TOP 1 B.[POSITION_NAME] FROM 
							(SELECT
								EMPLOYEE_POSITION_NAMES.POSITION_NAME,
								EMPLOYEE_POSITIONS_AUTHORITY.AUTHORITY_ID
							FROM
								EMPLOYEE_POSITIONS_AUTHORITY
								INNER JOIN EMPLOYEE_POSITION_NAMES ON EMPLOYEE_POSITION_NAMES.POS_NAME_ID = EMPLOYEE_POSITIONS_AUTHORITY.POSITION_ID) B
						WHERE B.[AUTHORITY_ID]=TBL.[AUTHORITY_ID]
						) As POSITION_NAMES
        		FROM
					(SELECT
			            EA.AUTHORITY_ID,
			            EA.AUTHORITY_HEAD,
			            EA.RECORD_DATE,
			            E.EMPLOYEE_NAME,
			            E.EMPLOYEE_SURNAME,
						EA.DEPARTMENT_ID
			        FROM
			            EMPLOYEE_AUTHORITY EA
						INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EA.RECORD_MEMBER
			        WHERE
			        	1 = 1
						<cfif len(arguments.keyword)>
							AND EA.AUTHORITY_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
						</cfif>
						<cfif len(arguments.status)>
							AND EA.STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.status#">	  
						</cfif>) AS TBL
			),
			CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY AUTHORITY_ID
			) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			<cfif len(arguments.startrow) and len(arguments.maxrows)>
				WHERE
					RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
			</cfif>
        </cfquery>
  		<cfreturn get_pos_auth_>
	</cffunction>
</cfcomponent>
