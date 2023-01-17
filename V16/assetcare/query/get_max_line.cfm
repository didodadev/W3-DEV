<cfquery name="GET_MAX_LINE" datasource="#DSN#">
	SELECT T1.MAX_LINE AS MAX_LINE
	FROM (
		SELECT 
			MAX(PTR.LINE_NUMBER) AS MAX_LINE
		FROM
			PROCESS_TYPE PT,
			PROCESS_TYPE_ROWS PTR,
			PROCESS_TYPE_OUR_COMPANY PTO,
			PROCESS_TYPE_ROWS_POSID PTRP,
			EMPLOYEE_POSITIONS EP
		WHERE
			PT.IS_ACTIVE = 1 AND
			PT.PROCESS_ID = PTR.PROCESS_ID AND
			PT.PROCESS_ID = PTO.PROCESS_ID AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			<cfif database_type is 'MSSQL'><!--- FB 20070612 --->
				CAST(PT.FACTION AS NVARCHAR(2500))+',' LIKE '%assetcare.upd_vehicle_purchase_request,%' AND
			<cfelseif database_type is 'DB2'>
				CAST(PT.FACTION AS VARGRAPHIC(2500))||',' LIKE '%assetcare.upd_vehicle_purchase_request,%' AND
			</cfif>
			PTRP.PROCESS_ROW_ID = PTR.PROCESS_ROW_ID AND
			PTRP.PRO_POSITION_ID = EP.POSITION_ID AND
			EP.POSITION_CODE =  #session.ep.position_code#
	UNION
		SELECT
			MAX(PTR.LINE_NUMBER) AS MAX_LINE
		FROM 	
			PROCESS_TYPE  AS PT,
			PROCESS_TYPE_OUR_COMPANY PTO,
			PROCESS_TYPE_ROWS AS PTR,
			PROCESS_TYPE_ROWS_WORKGRUOP AS PTRW,
			PROCESS_TYPE_ROWS_POSID AS PTRP
		WHERE 
			PT.IS_ACTIVE = 1 AND
			PTR.PROCESS_ID = PT.PROCESS_ID AND
			PT.PROCESS_ID = PTO.PROCESS_ID AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			<cfif database_type is 'MSSQL'>
				CAST(PT.FACTION AS NVARCHAR(2500))+',' LIKE '%assetcare.upd_vehicle_purchase_request,%' AND
			<cfelseif database_type is 'DB2'>
				CAST(PT.FACTION AS VARGRAPHIC(2500))||',' LIKE '%assetcare.upd_vehicle_purchase_request,%' AND
			</cfif>
			 PTRW.PROCESS_ROW_ID = PTR.PROCESS_ROW_ID  AND 
			 PTRW.MAINWORKGROUP_ID IS NOT NULL AND 
			 PTRW.MAINWORKGROUP_ID = PTRP.WORKGROUP_ID AND 
			 PTRP.PRO_POSITION_ID IN (#session.ep.position_code#) AND
			 PTR.LINE_NUMBER IS NOT NULL
	) AS T1
	ORDER BY
		T1.MAX_LINE DESC
</cfquery>
