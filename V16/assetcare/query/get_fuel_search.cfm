<cfif isdefined("attributes.is_submitted")>
<cfif isdefined("attributes.start_date") and len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>

<cfquery name="GET_FUEL_SEARCH" datasource="#DSN#">
	SELECT 
		ASSET_P_FUEL.*,
		ASSET_P.ASSETP,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
	FROM 
		ASSET_P_FUEL, 
		ASSET_P,
		BRANCH,
		DEPARTMENT
 	WHERE
		<!--- Yakit- km ekranindan yapilan kayitlarin gelmemesi icin eklendi FB 20071025 --->
		ASSET_P_FUEL.FUEL_ID NOT IN (SELECT FUEL_ID FROM ASSET_P_KM_CONTROL WHERE FUEL_ID IS NOT NULL) AND
		ASSET_P_FUEL.FUEL_ID IS NOT NULL
		<!--- Sadece yetkili olunan şubeler gözüksün. --->
		AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		<cfif len(attributes.branch_id)>AND BRANCH.BRANCH_ID = #attributes.branch_id#</cfif>
		<cfif len(attributes.document_type_id)>AND ASSET_P_FUEL.DOCUMENT_TYPE_ID =#attributes.document_type_id#</cfif>
		<cfif len(attributes.document_num)>AND ASSET_P_FUEL.DOCUMENT_NUM LIKE '%#attributes.document_num#%'</cfif>
		<cfif len(attributes.assetp_id) and len(attributes.assetp_name)>AND ASSET_P.ASSETP_ID = #attributes.assetp_id#</cfif>
		<cfif len(attributes.employee_id) and len(attributes.employee_name)>AND ASSET_P_FUEL.EMPLOYEE_ID = #attributes.employee_id#</cfif>
		<cfif len(attributes.fuel_comp_id) and len(attributes.fuel_comp_name)>AND ASSET_P_FUEL.FUEL_COMPANY_ID = #attributes.fuel_comp_id#</cfif>
		<cfif len(attributes.fuel_type_id)>AND ASSET_P_FUEL.FUEL_TYPE_ID = #attributes.fuel_type_id#</cfif>
 	    <cfif len(attributes.start_date)>AND ASSET_P_FUEL.FUEL_DATE >= #attributes.start_date#</cfif>
		<cfif len(attributes.finish_date)>AND ASSET_P_FUEL.FUEL_DATE <= #attributes.finish_date#</cfif>
		<cfif len(attributes.record_num)>AND ASSET_P_FUEL.FUEL_ID = #attributes.record_num#</cfif>
		AND ASSET_P.ASSETP_ID = ASSET_P_FUEL.ASSETP_ID
		AND ISNULL(ASSET_P.DEPARTMENT_ID2,ASSET_P.DEPARTMENT_ID)<!--- ASSET_P.DEPARTMENT_ID2 ---> = DEPARTMENT.DEPARTMENT_ID
		AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
	ORDER BY
		 ASSET_P.ASSETP_ID,
		 ASSET_P_FUEL.FUEL_ID DESC
</cfquery>
</cfif>
