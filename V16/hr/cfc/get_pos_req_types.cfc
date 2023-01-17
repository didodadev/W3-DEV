<cfcomponent>
	<cffunction name="get_pos_req_type" access="public" returntype="query">
		<cfargument name="keyword" default="">
		<cfargument name="startrow" default="">
		<cfargument name="maxrows" default="">
        <cfquery name="get_pos_req_type_" datasource="#this.dsn#">
        	WITH CTE1 AS (
        		SELECT
					TBL.*,
					STUFF(
						(SELECT ', ' + A.TITLE FROM 
							(SELECT DISTINCT ST.TITLE,RS.RELATION_FIELD_ID FROM RELATION_SEGMENT RS INNER JOIN SETUP_TITLE ST ON ST.TITLE_ID = RS.RELATION_ACTION_ID WHERE RS.RELATION_ACTION = 10) A
						WHERE A.RELATION_FIELD_ID=TBL.REQ_TYPE_ID FOR XML PATH('')
					),1,1,'') AS TITLES
        		FROM
		            (SELECT
		            	POSITION_REQ_TYPE.REQ_TYPE_ID,
						#this.dsn#.Get_Dynamic_Language(POSITION_REQ_TYPE.REQ_TYPE_ID,'#session.ep.language#','POSITION_REQ_TYPE','REQ_TYPE',NULL,NULL,POSITION_REQ_TYPE.REQ_TYPE) AS REQ_TYPE,
						POSITION_REQ_TYPE.RECORD_DATE,
						EMPLOYEES.EMPLOYEE_NAME,
						EMPLOYEES.EMPLOYEE_SURNAME
					FROM
						POSITION_REQ_TYPE
						INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = POSITION_REQ_TYPE.RECORD_EMP
					<cfif len(arguments.keyword)>
						WHERE
							REQ_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
					</cfif>) AS TBL
			),
			CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY REQ_TYPE_ID
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
  		<cfreturn get_pos_req_type_>
	</cffunction>
</cfcomponent>
