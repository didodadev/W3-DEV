<!-- n tane '.' olduğunda çalışmaz. A.Selam Bey'le konuşuldu,geri dönülecek... Onur P. 04012005-->
<cfif isdefined("attributes.is_submitted")>
	<cfif len(attributes.branch_id)>
		<cfquery name="GET_HIERARCHY" datasource="#DSN#">
			SELECT HIERARCHY FROM BRANCH WHERE BRANCH_ID = #attributes.branch_id#
		</cfquery>
	<cfset hier = get_hierarchy.hierarchy>
	</cfif>
	<cfquery name="GET_DEPOT_SEARCH" datasource="#DSN#">
		SELECT
			BRANCH.BRANCH_NAME,
			BRANCH.BRANCH_ID,
			BRANCH.FOUNDATION_DATE,
			BRANCH.HIERARCHY,
			BRANCH.BRANCH_TEL1,
			BRANCH.BRANCH_TEL2,
			BRANCH.BRANCH_FAX, 
			BRANCH.BRANCH_TELCODE,
			OUR_COMPANY.COMPANY_NAME,
			ZONE.ZONE_NAME
		FROM
			BRANCH,
			OUR_COMPANY,
			ZONE
		WHERE
			OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID	AND
			ZONE.ZONE_ID = BRANCH.ZONE_ID AND
			<!--- Sadece yetkili olunan şubeler gözüksün. Onur P. --->
 			BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
 			<cfif len(attributes.company_id)>AND OUR_COMPANY.COMP_ID = #attributes.company_id#</cfif>
			<cfif len(attributes.zone_id)>AND ZONE.ZONE_ID = #attributes.zone_id#</cfif>
			<cfif len(attributes.branch_id)><!--- AND BRANCH.BRANCH_ID LIKE '%#attributes.branch_id#%' --->
				<cfif hier contains '.'>
					AND BRANCH.HIERARCHY = '#hier#' 
				<cfelse>
					AND (BRANCH.HIERARCHY = '#hier#' OR BRANCH.HIERARCHY LIKE '%#hier#.%')
				</cfif>
			</cfif>
			<!--- Merkez Branch --->
			<cfif isDefined("attributes.depot_type") and depot_type eq 1>AND BRANCH.HIERARCHY NOT LIKE '%.%'</cfif>
			<!--- Cep Branch --->
			<cfif isDefined("attributes.depot_type") and depot_type eq 2>AND BRANCH.HIERARCHY LIKE '%.%'</cfif>
		ORDER BY
			 OUR_COMPANY.COMPANY_NAME,
			 BRANCH.HIERARCHY
	</cfquery>
	<cfset branchs = ValueList(get_depot_search.branch_id)>
	<cfif len(branchs)>
		<cfquery name="COUNT_MERKEZ" datasource="#DSN#">
			SELECT 
				COUNT(BRANCH_ID) AS BRANCH_COUNTED 
			FROM 
				BRANCH
			WHERE 
				BRANCH_ID IN (#branchs#)
				AND BRANCH.HIERARCHY NOT LIKE '%.%'
		</cfquery>
		<cfquery name="COUNT_CEP" datasource="#DSN#">
				SELECT 
				COUNT(BRANCH_ID) AS BRANCH_COUNTED 
			FROM 
				BRANCH
			WHERE
				BRANCH_ID IN (#branchs#)
				AND BRANCH.HIERARCHY LIKE '%.%'
		</cfquery>
	</cfif>
</cfif>
