<cfif isdefined("attributes.start_date") and len(attributes.start_date) ><cf_date tarih='attributes.start_date'></cfif>
	<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
	<cfquery name="GET_KM_SEARCH" datasource="#dsn#">
		SELECT 
			ASSET_P_KM_CONTROL.KM_CONTROL_ID,
			ASSET_P_KM_CONTROL.KM_START,
			ASSET_P_KM_CONTROL.KM_FINISH,
			ASSET_P_KM_CONTROL.START_DATE,
			ASSET_P_KM_CONTROL.FINISH_DATE,
			ASSET_P_KM_CONTROL.DETAIL,
			ASSET_P_KM_CONTROL.EMPLOYEE_ID,
			ASSET_P_KM_CONTROL.IS_OFFTIME,
			ASSET_P_KM_CONTROL.IS_ALLOCATE,
			ASSET_P_KM_CONTROL.IS_RESIDUAL,
			ASSET_P_KM_CONTROL.ASSETP_ID,
			--ASSET_P_KM_CONTROL.GROUP_ID,
			ASSET_P.USAGE_PURPOSE_ID,
			ASSET_P.ASSETP_GROUP,
			GRP.GROUP_NAME,
			ASSET_P.ASSETP,
			ZONE.ZONE_NAME,
			EMP.EMPLOYEE_NAME +' '+ EMP.EMPLOYEE_SURNAME EMP_NAME,
			USAGE.USAGE_PURPOSE,
			BRANCH.BRANCH_NAME,
			DEPARTMENT.DEPARTMENT_HEAD,
			(SELECT MAX(KM_FINISH) FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = ASSET_P.ASSETP_ID) AS KM_LAST,
			(SELECT MAX(KM_CONTROL_ID) FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = ASSET_P.ASSETP_ID) AS KM_CONTROL_ID_LAST
		FROM 
			ASSET_P_KM_CONTROL
				LEFT JOIN ASSET_P ON ASSET_P.ASSETP_ID=ASSET_P_KM_CONTROL.ASSETP_ID
				LEFT JOIN SETUP_USAGE_PURPOSE USAGE ON ASSET_P.USAGE_PURPOSE_ID = USAGE.USAGE_PURPOSE_ID
				LEFT JOIN SETUP_ASSETP_GROUP GRP ON ASSET_P.ASSETP_GROUP = GRP.GROUP_ID
				LEFT JOIN DEPARTMENT ON ISNULL(ASSET_P.DEPARTMENT_ID2,ASSET_P.DEPARTMENT_ID) = DEPARTMENT.DEPARTMENT_ID
				LEFT JOIN BRANCH ON DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
				LEFT JOIN ZONE ON ZONE.ZONE_ID=BRANCH.ZONE_ID
				LEFT JOIN EMPLOYEE_POSITIONS EMP ON EMP.EMPLOYEE_ID=ASSET_P_KM_CONTROL.EMPLOYEE_ID  AND EMP.IS_MASTER = 1
		WHERE 
			<!--- Yakıt-KM baglantisinin haricindekilerin gelmesi icin FB 20071024 --->
			ASSET_P_KM_CONTROL.FUEL_ID IS NULL AND
			<!--- İlk kayıtların gelmemesi için --->
			ASSET_P_KM_CONTROL.EMPLOYEE_ID IS NOT NULL AND
			<!--- Tahsiste olan araçların gelmemesi için --->
			ASSET_P_KM_CONTROL.KM_FINISH IS NOT NULL AND
			<!--- Misir ATS icin yapilan KM Sayac Degeri degistirmek icin onlar gelmesin BK 20080813 --->
		<cfif database_type is 'MSSQL'>
			ISNULL(ASSET_P_KM_CONTROL.IS_COUNTER_CHANGE,0) <> 1 AND
		<cfelseif database_type is 'DB2'>
			COALESCE(ASSET_P_KM_CONTROL.IS_COUNTER_CHANGE,0) <> 1 AND
		</cfif>		
			<!--- Sadece yetkili olunan şubeler gözüksün. --->		
			BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
			ISNULL(ASSET_P.DEPARTMENT_ID2,ASSET_P.DEPARTMENT_ID)<!--- ASSET_P.DEPARTMENT_ID2 ---> = DEPARTMENT.DEPARTMENT_ID 
			<cfif len(attributes.assetp_id) and len(attributes.assetp_name)> AND ASSET_P_KM_CONTROL.ASSETP_ID = #attributes.assetp_id#</cfif>
			<cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>AND DEPARTMENT.BRANCH_ID = #attributes.branch_id#</cfif>
			<cfif isdefined('attributes.usage_purpose_id') and len(attributes.usage_purpose_id)>AND ASSET_P.USAGE_PURPOSE_ID = #attributes.usage_purpose_id#</cfif>
			<cfif isdefined('attributes.assetp_group') and len(attributes.assetp_group)>AND ASSET_P.ASSETP_GROUP = #attributes.assetp_group#</cfif>
			<cfif isdefined('attributes.department') and len(attributes.department) and len(attributes.department_id)>AND ASSET_P.DEPARTMENT_ID = #attributes.department_id#</cfif>
			<cfif isdefined('attributes.position_cat_id') and len(attributes.position_cat_id)>AND EMP.POSITION_CAT_ID = #attributes.position_cat_id#</cfif>
			<cfif isDefined("attributes.is_offtime") and (attributes.is_offtime eq 2)>AND ASSET_P_KM_CONTROL.IS_OFFTIME <> 1
			<cfelseif isDefined("attributes.is_offtime") and (attributes.is_offtime eq 3)>AND ASSET_P_KM_CONTROL.IS_OFFTIME = 1
			</cfif>
			<cfif isdefined("attributes.is_allocated")>AND ASSET_P_KM_CONTROL.IS_ALLOCATE = 1 AND ASSET_P_KM_CONTROL.IS_RESIDUAL = 0</cfif>
			<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee_name)>AND ASSET_P_KM_CONTROL.EMPLOYEE_ID = #attributes.employee_id#</cfif>
			<!--- <cfif len(attributes.start_date)>AND ASSET_P_KM_CONTROL.START_DATE >= #attributes.start_date#</cfif> --->
			<cfif isdefined("attributes.start_date") and len(attributes.start_date)>AND ASSET_P_KM_CONTROL.START_DATE >= #attributes.start_date#</cfif>
			<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>AND ASSET_P_KM_CONTROL.FINISH_DATE <= #attributes.finish_date#</cfif>
		ORDER BY
			<!--- ASSET_P_KM_CONTROL.FINISH_DATE, --->
			ASSET_P.ASSETP,
			ASSET_P_KM_CONTROL.KM_CONTROL_ID DESC
	</cfquery>
	