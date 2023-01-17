<cfquery name="GET_ASSETPS" datasource="#dsn#">
		SELECT 
			ASSET_P.ASSETP_ID,
			ASSET_P.ASSETP,
			ASSET_P.UPDATE_DATE,
			ASSET_P.POSITION_CODE,
			ASSET_P.POSITION_CODE2,
			ASSET_P.ASSETP_STATUS,
			ASSET_P_CAT.ASSETP_CAT,
			ZONE.ZONE_NAME,
			BRANCH.BRANCH_NAME,
			DEPARTMENT.DEPARTMENT_HEAD,
			EMPLOYEE_POSITIONS.EMPLOYEE_ID,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			EMPLOYEE_POSITIONS.POSITION_NAME
		FROM 
			ASSET_P,
			ASSET_P_CAT,
			ZONE,
			BRANCH,
			DEPARTMENT,
			EMPLOYEE_POSITIONS
		WHERE
		
				ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
				ASSET_P.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
				DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
				BRANCH.ZONE_ID = ZONE.ZONE_ID AND
				ASSET_P.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE
				<cfif len(attributes.keyword)>
				AND 
				(
					ASSET_P.ASSETP LIKE '%#attributes.keyword#%' OR 
					ASSET_P.INVENTORY_NUMBER = '#attributes.keyword#'
				)
				</cfif>
				<cfif len(attributes.asset_cat)>AND ASSET_P.ASSETP_CATID = #attributes.asset_cat#</cfif>
				<cfif len(attributes.branch_id)>AND BRANCH.BRANCH_ID = #attributes.branch_id#</cfif>
				<cfif len(attributes.department_id)>AND ASSET_P.DEPARTMENT_ID = #attributes.department_id#</cfif>
				<cfif len(attributes.is_active) and (attributes.is_active neq 2)>
					AND ASSET_P.STATUS = #attributes.is_active#
	            </cfif>				
		ORDER BY 
			ASSET_P.ASSETP 
</cfquery>
