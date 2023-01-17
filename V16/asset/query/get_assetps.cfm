<cfquery name="GET_BRANCH_POSITIONS" datasource="#DSN#">
	SELECT
		BRANCH_ID
	FROM
		EMPLOYEE_POSITION_BRANCHES
	WHERE
		POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfset yetkili_subeler = ValueList(get_branch_positions.branch_id,',')>
<cfquery name="GET_ASSETPS" datasource="#dsn#"> 
	SELECT 
		ASSET_P.ASSETP_ID,
		ASSET_P.ASSETP,
		ASSET_P.ASSETP_STATUS,
		ASSET_P.UPDATE_DATE,
		ASSET_P_CAT.ASSETP_CAT,
		ZONE.ZONE_NAME,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
	FROM 
		ASSET_P,
		ASSET_P_CAT,
		ZONE,
		BRANCH,
		DEPARTMENT
	WHERE
		<!--- Sadece yetkili olunan şubeler gözüksün. ---> 
		BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
		ASSET_P.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		BRANCH.ZONE_ID = ZONE.ZONE_ID AND
		ASSET_P.IS_COLLECTIVE_USAGE = 1
	<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
		AND ASSET_P.DEPARTMENT_ID = #attributes.department_id#
	<cfelse>
		<cfif len(yetkili_subeler)>
			AND BRANCH.BRANCH_ID IN (#yetkili_subeler#)<!--- Yetkili olduğu tüm şubelerin kayıtları gelsin. --->
		<cfelse><!--- yetkili olduğu yoksa bağlı olduğu şubenin kayıtları gelsin. --->
			AND BRANCH.BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
		</cfif>
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND ASSET_P.ASSETP LIKE '%#attributes.keyword#%'
	</cfif>
	<cfif isDefined("ASSET_CAT") and (ASSET_CAT NEQ 0) and len(ASSET_CAT)>
		AND ASSET_P.ASSETP_CATID = #ASSET_CAT# 
	</cfif>
	<cfif isDefined("attributes.asset_physical_status") and len(attributes.asset_physical_status)>
		AND STATUS = #attributes.asset_physical_status#	
	<cfelse>
		AND STATUS = 1
	</cfif>	
	<cfif isdefined("attributes.assetp_state") and len(attributes.assetp_state)>
		AND ASSETP_STATUS = #attributes.assetp_state# 
	</cfif>
	<cfif not isdefined("attributes.order_assetp_name")>
	ORDER 
		BY ASSETP
	</cfif>
	<cfif isdefined("attributes.order_assetp_name")>
	ORDER 
		BY ASSETP
	<cfif isdefined("attributes.click_count") and (click_count eq 0)>
		DESC
	</cfif>	
	</cfif>
</cfquery> 
<cfquery name="GET_ASSETPSS" dbtype="QUERY">
	SELECT
		*
	FROM
		GET_ASSETPS
		<cfif not isdefined("attributes.order_assetp_name")>
	ORDER 
		BY ASSETP
		</cfif>
		<cfif isdefined("attributes.order_assetp_name")>
	ORDER 
		BY ASSETP
		<cfif isdefined("attributes.click_count") and (click_count eq 0)>
	DESC
		</cfif>	
		</cfif>
</cfquery>
<cfquery name="DEP" datasource="#DSN#">
	SELECT 
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.DEPARTMENT_HEAD, 
		DEPARTMENT.ADMIN1_POSITION_CODE,
		DEPARTMENT.ADMIN2_POSITION_CODE,
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID
	FROM 
		DEPARTMENT,
		BRANCH
	WHERE 
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
	ORDER BY
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>

