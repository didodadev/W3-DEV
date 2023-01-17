<cfcomponent>
    <!--- Bakım planı Ekleme   --->
    <cffunction name="addAssetpPeriodFnc" access="public" returntype="any">    		
					<cfargument name="process_stage" default="">
                    <cfargument name="assetp_id" default="">
        			<cfargument name="station_company_id" default="">
        			<cfargument name="care_type_id" default=""> 
					<cfargument name="place" default="">
                     <cfargument name="detail"  default="">
                     <cfargument name="care_type_period"  default="">
                     <cfargument name="care_date" default="">
        			<cfargument name="official_emp" default=""> 
                    <cfargument name="official_emp_id" default="">
        			<cfargument name="gun" default="">  
       				 <cfargument name="saat" default="">
        			<cfargument name="dakika" default="">
                    <cfargument name="care_km_period" default=""> 
                    <cfargument name="station_id" default="">
        			<cfargument name="failure_id" default=""> 
        	<cfquery name="ADD_CARE_PERIOD" datasource="#this.DSN#">
		INSERT INTO
			CARE_STATES
		(
			CARE_TYPE_ID,
			PROCESS_STAGE,
			ASSET_ID,
			OUR_COMPANY_ID,
			CARE_STATE_ID,
			DETAIL,
			PERIOD_ID,
			PERIOD_TIME,
			OFFICIAL_EMP_ID,
			CARE_DAY,
			CARE_HOUR,
			CARE_MINUTE,
			CARE_KM,
			STATION_ID,
            IS_ACTIVE,
            FAILURE_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			PLACE
		)
		VALUES
		(
			2,
			#arguments.process_stage#,
			#arguments.assetp_id#,
			<cfif isdefined("arguments.station_company_id") and len(arguments.station_company_id)>#arguments.station_company_id#<cfelse>NULL</cfif>,
			#arguments.care_type_id#,
			<cfif len(arguments.detail)>'#arguments.detail#'<cfelse>NULL</cfif>,
			<cfif len(arguments.care_type_period)>#arguments.care_type_period#<cfelse>NULL</cfif>,
			<cfif len(arguments.care_date)>#arguments.care_date#<cfelse>NULL</cfif>,
			<cfif len(arguments.official_emp) and len(arguments.official_emp_id)>#arguments.official_emp_id#<cfelse>NULL</cfif>,
			<cfif len(arguments.gun)>#arguments.gun#<cfelse>NULL</cfif>,
			<cfif len(arguments.saat)>#arguments.saat#<cfelse>NULL</cfif>,
			<cfif len(arguments.dakika)>#arguments.dakika#<cfelse>NULL</cfif>,
			<cfif isDefined("arguments.care_km_period") and len(arguments.care_km_period)>#arguments.care_km_period#<cfelse>0</cfif>,
			<cfif isdefined("arguments.station_id") and len(arguments.station_id)>#arguments.station_id#<cfelse>NULL</cfif>,
			1,
            <cfif isdefined("arguments.failure_id") and len(arguments.failure_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.failure_id#"><cfelse>NULL</cfif>,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,			
			<cfif isdefined("arguments.place") and len(arguments.place)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.place#"><cfelse>NULL</cfif>
		)
	</cfquery>   
            <cfreturn true>      
     </cffunction>   
      <!---  Bakım Planı Güncelleme  --->
     <cffunction name="updAssetpPeriodFnc" access="public" returntype="any">       			
					<cfargument name="process_stage" default="">
                    <cfargument name="assetp_id" default="">
        			<cfargument name="station_company_id" default="">
        			<cfargument name="care_type_id" default=""> 
                     <cfargument name="detail"  default="">
                     <cfargument name="care_type_period"  default="">
                     <cfargument name="care_date" default="">
        			<cfargument name="official_emp" default=""> 
                    <cfargument name="official_emp_id" default="">
        			<cfargument name="gun" default="">  
       				 <cfargument name="saat" default="">
        			<cfargument name="dakika" default="">
                    <cfargument name="care_km_period" default=""> 
                    <cfargument name="station_id" default="">
                    <cfargument name="station_name" default="">
        			<cfargument name="failure_id" default="">
                    <cfargument name="care_id" default="">					
					<cfargument name="place" default="">		
        <cfquery name="upd_care_period" datasource="#this.dsn#">
		UPDATE 
			CARE_STATES
		SET
			CARE_TYPE_ID = 2,
			PROCESS_STAGE = #arguments.process_stage#,
			ASSET_ID = <cfif isdefined('arguments.assetp_id') and len(arguments.assetp_id)>#arguments.assetp_id#<cfelse>NULL</cfif>,
			OUR_COMPANY_ID =<cfif isdefined("arguments.station_company_id") and len(arguments.station_company_id)>#arguments.station_company_id#<cfelse>NULL</cfif> ,
			CARE_STATE_ID = #arguments.care_type_id#,
			DETAIL = <cfif len(arguments.detail)>'#arguments.detail#'<cfelse>NULL</cfif>,
			PERIOD_ID = <cfif len(arguments.care_type_period)>#arguments.care_type_period#<cfelse>NULL</cfif>,
			PERIOD_TIME = <cfif len(arguments.care_date)>#arguments.care_date#<cfelse>NULL</cfif>,
			OFFICIAL_EMP_ID = <cfif len(arguments.official_emp) and len(arguments.official_emp_id)>#arguments.official_emp_id#<cfelse>NULL</cfif>,
			CARE_DAY = <cfif len(arguments.gun)>#arguments.gun#<cfelse>NULL</cfif>,
			CARE_HOUR = <cfif len(arguments.saat)>#arguments.saat#<cfelse>NULL</cfif>,
			CARE_MINUTE = <cfif len(arguments.dakika)>#arguments.dakika#<cfelse>NULL</cfif>,
			CARE_KM = <cfif isDefined("arguments.care_km_period") and len(arguments.care_km_period)>#arguments.care_km_period#<cfelse>0</cfif>,
			STATION_ID=<cfif isdefined("arguments.station_id") and len(arguments.station_id) and len(station_name)>#arguments.station_id#<cfelse>NULL</cfif>,
			IS_ACTIVE = 1,
			FAILURE_ID=<cfif isdefined("arguments.failure_id") and len(arguments.failure_id)>#arguments.failure_id#<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,		
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.remote_addr#',		
			PLACE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.place#">

		WHERE
			CARE_ID = #arguments.care_id#
	</cfquery>
              <cfreturn true>
      </cffunction> 
       <!---  Bakım Planı Listeleme --->
      <cffunction name="GET_ASSETP_PERIOD_FNC" returntype="query"> 
            <cfargument name="assetp_id" default="">
            <cfargument name="keyword" default="">
            <cfargument name="asset_cat" default="">
            <cfargument name="branch_id" default="">
            <cfargument name="branch" default="">
            <cfargument name="asset_id" default="">
            <cfargument name="station_id" default="">
            <cfargument name="department" default="">
			<cfargument name="place" default="">
            <cfargument name="department_id" default="">
            <cfargument name="official_emp_id" default="">
            <cfargument name="official_emp" default="">
            <cfargument name="start_date" default="">
            <cfargument name="finish_date" default="">
            <cfargument name="period" default="">
            <cfargument name="ord_by" default="">  
            <cfargument name="asset_name" default="">  
           <cfargument name="station_name" default="">                    
            <cfquery name="GET_WORK_ASSET_CARE" datasource="#this.DSN#">
	SELECT
		CARE_STATES.CARE_ID,
		CARE_STATES.CARE_TYPE_ID,
		CARE_STATES.STATION_ID,
		CARE_STATES.ASSET_ID,
		CARE_STATES.CARE_STATE_ID,
		CARE_STATES.PERIOD_ID,
		CARE_STATES.CARE_DAY,
		CARE_STATES.CARE_HOUR,
		CARE_STATES.PERIOD_TIME,
		CARE_STATES.OFFICIAL_EMP_ID,
		CARE_STATES.CARE_MINUTE,
		CARE_STATES.STATION_ID,
		CARE_STATES.OUR_COMPANY_ID,
		CARE_STATES.RECORD_DATE,
		ASSET_P.ASSETP_ID,
		ASSET_P.ASSETP,
		ASSET_P.DEPARTMENT_ID,
		ASSET_P.ASSETP_CATID,
		ASSET_P.POSITION_CODE,
		DEPARTMENT.DEPARTMENT_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		ASSET_CARE_CAT.ASSET_CARE,
        ASSET_P.INVENTORY_NUMBER,
		CARE_STATES.PLACE
	FROM
		CARE_STATES,
		ASSET_P,
		DEPARTMENT,
		BRANCH,
		ASSET_CARE_CAT
	WHERE
		ASSET_P.STATUS IS NOT NULL
		<cfif isDefined("arguments.assetp_id") and len(arguments.assetp_id)>AND ASSET_P.ASSETP_ID = #arguments.assetp_id#</cfif>
		<cfif len(arguments.keyword)>AND ASSET_P.ASSETP LIKE '%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
		<cfif len(arguments.asset_cat)>AND CARE_STATES.CARE_STATE_ID = #arguments.asset_cat#</cfif>
		<cfif len(arguments.branch_id)and len(arguments.branch)>AND BRANCH.BRANCH_ID =#arguments.branch_id#</cfif>
		<cfif len(arguments.asset_id)and len(arguments.asset_name)>AND CARE_STATES.ASSET_ID =#arguments.asset_id#</cfif>
		<cfif len(arguments.station_id) and len(arguments.station_name)>AND CARE_STATES.STATION_ID=#arguments.station_id#</cfif>
		<cfif len(arguments.department) and len(arguments.department_id)>AND ASSET_P.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"> </cfif>
		<cfif len(arguments.official_emp_id) and len(arguments.official_emp)>AND CARE_STATES.OFFICIAL_EMP_ID =#arguments.official_emp_id#</cfif>
		AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		AND ASSET_CARE_CAT.ASSET_CARE_ID = CARE_STATES.CARE_STATE_ID
		AND DEPARTMENT.DEPARTMENT_ID = ASSET_P.DEPARTMENT_ID2
		AND BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
		AND ASSET_P.ASSETP_ID = CARE_STATES.ASSET_ID		
		<cfif len(arguments.start_date)>AND CARE_STATES.PERIOD_TIME >= #arguments.start_date#</cfif>
		<cfif len(arguments.finish_date)>AND CARE_STATES.PERIOD_TIME <= #arguments.finish_date#</cfif>
        <cfif len(arguments.period)>AND CARE_STATES.PERIOD_ID IN (#arguments.period#)</cfif>
		<cfif isDefined('arguments.ord_by') and arguments.ord_by eq 2>
		ORDER BY CARE_STATES.RECORD_DATE
		<cfelseif isDefined('arguments.ord_by') and arguments.ord_by eq 1>
		ORDER BY CARE_STATES.RECORD_DATE DESC
        <cfelseif isDefined('arguments.ord_by') and arguments.ord_by eq 4>
		ORDER BY CARE_STATES.PERIOD_ID
		<cfelse>
		ORDER BY CARE_STATES.PERIOD_ID DESC
		</cfif>
</cfquery>
            <cfreturn GET_WORK_ASSET_CARE>
          </cffunction> 
</cfcomponent> 
