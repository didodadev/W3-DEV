<cfparam name="attributes.emp_id" default="">
<cfquery name="GET_BRANCH_POSITIONS" datasource="#DSN#">
	SELECT
		BRANCH_ID
	FROM
		EMPLOYEE_POSITION_BRANCHES
	WHERE
		POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfset yetkili_subeler = ValueList(get_branch_positions.branch_id,',')>
<cfquery name="GET_ASSETPS_RESERVE" datasource="#DSN#">
	SELECT
		1 TYPE,
		ASSET_P.ASSETP_ID,
		ASSET_P.ASSETP ASSETP,
		ASSET_P.POSITION_CODE,
		ASSET_P.POSITION_CODE2,
		ASSET_P.ASSETP_STATUS,
		ASSET_P.PROPERTY,
		ASSET_P.STATUS,
		ASSET_P.POSITION_CODE,		
		ASSET_P.ASSETP_STATUS,
		ASSET_P.BRAND_TYPE_CAT_ID,
		ASSET_P.BRAND_TYPE_ID,
		ASSET_P.IS_COLLECTIVE_USAGE IS_COLLECTIVE_USAGE,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME,
        EP.POSITION_NAME,
        EP.EMPLOYEE_NAME,
        EP.EMPLOYEE_SURNAME,
        EP.EMPLOYEE_ID,
        EP.POSITION_CODE,
		ASSET_P_CAT.ASSETP_CAT,
		(SELECT ZONE_NAME FROM ZONE WHERE ZONE_ID = BRANCH.ZONE_ID)ZONE_NAME
	FROM 
    	EMPLOYEE_POSITIONS EP,
		ASSET_P,
		ASSET_P_CAT,
		DEPARTMENT,
		BRANCH
		<cfif isdefined("x_reserve_relation") and  len(x_reserve_relation)>
        	,ASSET_P_RESERVE
		</cfif>     
	WHERE
    	ASSET_P.POSITION_CODE = EP.POSITION_CODE AND
	    <cfif isdefined("x_reserve_relation") and  len(x_reserve_relation)>
            ASSET_P_RESERVE.ASSETP_ID = ASSET_P.ASSETP_ID AND
            ASSET_P_RESERVE.STAGE_ID IN(#x_reserve_relation#) AND
        </cfif>
		<!--- Sadece yetkili olunan şubeler gözüksün. ---> 
		BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) AND
		ASSET_P.DEPARTMENT_ID2 = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
		ASSET_P.STATUS = 1 AND
		ASSET_P.IS_COLLECTIVE_USAGE = 1
		<cfif isdefined("attributes.asset_cat") and len(attributes.asset_cat)>
        	AND ASSET_P.ASSETP_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_cat#">
        </cfif>
        <cfif isdefined("event_id") and  (event_id is 0)>
        	AND (ASSET_P_CAT.ASSETP_RESERVE  = 1 OR ASSET_P_CAT.ASSETP_RESERVE  = 0 OR ASSET_P_CAT.ASSETP_RESERVE  IS NULL)
        <cfelse>
        	AND ASSET_P_CAT.ASSETP_RESERVE = 1
        </cfif>
        <cfif isdefined("attributes.department_id") and len(attributes.department_id)>
	        AND ASSET_P.DEPARTMENT_ID2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
        <cfelse>
			<cfif len(yetkili_subeler)>
                AND BRANCH.BRANCH_ID IN (#yetkili_subeler#)<!--- Yetkili olduğu tüm şubelerin kayıtları gelsin. --->
            <cfelse><!--- yetkili olduğu yoksa bağlı olduğu şubenin kayıtları gelsin. --->
                AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">	
            </cfif>
        </cfif>
        <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
        	AND ASSET_P.ASSETP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
        </cfif>
        <cfif isDefined("attributes.asset_catid") and len(attributes.asset_catid)>
        	AND ASSET_P.ASSETP_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_catid#"> 
        </cfif>
        <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
        	AND PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
        </cfif>
        <cfif len(attributes.emp_id) and len(attributes.employee_name)>AND ASSET_P.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"></cfif>
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
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
		DEPARTMENT.DEPARTMENT_STATUS = 1
	ORDER BY
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>
