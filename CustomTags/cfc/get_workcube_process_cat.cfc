<!--- FBS 20120615 workcube_process ve workcube_process_info tagleri icin olusturulmustur --->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	
	<cffunction name="get_Process_Cat_Emp_Cau" access="public" returntype="query">
		<cfargument name="process_cat" type="numeric" required="no" default="0">
	  <cfquery name="get_Process_Cat_Emp_Cau" datasource="#this.action_db_type#">
            SELECT
            	DISTINCT
                EP.POSITION_CODE,
                EP.EMPLOYEE_NAME,
                EP.EMPLOYEE_SURNAME,
                EP.POSITION_NAME
            FROM 
                #this.process_db3#SETUP_PROCESS_CAT_ROWS_CAUID SPCR,
                #this.process_db#EMPLOYEE_POSITIONS EP
            WHERE
                EP.POSITION_ID = SPCR.CAU_POSITION_CODE
                AND SPCR.PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#">
        </cfquery>
		<cfreturn get_Process_Cat_Emp_Cau>
	</cffunction>
	
	<cffunction name="get_Process_Cat_Name" access="public" returntype="query">
		<cfargument name="process_cat" type="numeric" required="no" default="0">
		 <cfquery name="get_Process_Cat_Name" datasource="#this.action_db_type#">
			SELECT PROCESS_CAT FROM #this.process_db3#SETUP_PROCESS_CAT SPC WHERE SPC.PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#">
		</cfquery>
		<cfreturn get_Process_Cat_Name>
	</cffunction>
		
	<cffunction name="get_User_Process_Cat" access="public" returntype="query">
		<cfargument name="position_code" type="numeric" required="no" default="0">
		<cfargument name="module_id" type="string" required="no" default="">
		<cfargument name="process_type_info" type="string" required="no" default="">
		<cfargument name="fuseaction" type="string" required="no" default="">
		<cfargument name="is_check_all_control" type="numeric" required="no" default="0">
		<cfargument name="wrkflow" type="numeric" required="no" default="0">
		<cfargument name="pathinfo" type="string" required="yes">
		<cfset get_process_sender = createObject("component", "WMO.process_authority")
										.init( data_source : this.action_db_type, process_db : this.process_db)
										.get_process_sender(
											fuseaction : arguments.fuseaction,
											wrkflow : arguments.wrkflow,
											pathinfo : arguments.pathinfo
										) />
        <cfset sender_position_codes = get_process_sender.recordcount ? ValueList(get_process_sender.SENDER_POSITION_CODE) : "" />
		<cfif isdefined('session.ep.userid') and len(session.ep.userid)>
		<cfquery name="gets_my_position" datasource="#this.action_db_type#">
		select POSITION_CAT_ID from #this.process_db#EMPLOYEE_POSITIONS where EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		</cfquery>
		</cfif>
		<cfquery name="get_User_Process_Cat" datasource="#this.action_db_type#">
			SELECT
				DISTINCT
				SPC.PROCESS_CAT_ID,
				ISNULL((SELECT SLI.ITEM FROM #dsn#.SETUP_LANGUAGE_INFO AS SLI WHERE SLI.UNIQUE_COLUMN_ID = SPC.PROCESS_CAT_ID AND SLI.LANGUAGE = '#session.ep.language#' AND SLI.COLUMN_NAME = 'PROCESS_CAT' AND SLI.TABLE_NAME = 'SETUP_PROCESS_CAT'), SPC.PROCESS_CAT) AS PROCESS_CAT,
				SPC.PROCESS_TYPE,
				SPC.IS_ACCOUNT,
				SPC.IS_ZERO_STOCK_CONTROL,
				SPC.IS_DEFAULT,
				SPC.IS_PROJECT_BASED_ACC,
				SPC.IS_DEPT_BASED_ACC,
				SPC.DISPLAY_FILE_NAME,
				SPC.DISPLAY_FILE_FROM_TEMPLATE,
				SPC.IS_ADD_INVENTORY,
                SPC.IS_LOT_NO,
                SPC.MULTI_TYPE
			FROM
				#this.process_db3#SETUP_PROCESS_CAT SPC
				INNER JOIN #this.process_db3#SETUP_PROCESS_CAT_FUSENAME AS SPCF ON SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID
				LEFT OUTER JOIN #this.process_db3#SETUP_PROCESS_CAT_ROWS AS SPCR ON SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID
			WHERE
				1 = 1
				AND
				(
					( SPC.IS_ALL_USERS = 1 )
					OR
					(
						SPCR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
						<cfif len(sender_position_codes)>
						OR SPCR.POSITION_CODE IN(#sender_position_codes#)
						</cfif>
						<cfif isdefined('gets_my_position.POSITION_CAT_ID') and len(gets_my_position.POSITION_CAT_ID)>
						OR SPCR.POSITION_CAT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#gets_my_position.POSITION_CAT_ID#">
						</cfif>
					)
				) AND
				<cfif arguments.is_check_all_control eq 1>
					SPC.PROCESS_TYPE IN (#arguments.process_type_info#) AND
					','+SPCF.FUSE_NAME+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#arguments.fuseaction#,%">
				<cfelseif Len(arguments.process_type_info)>
					SPC.PROCESS_TYPE IN (#arguments.process_type_info#) 
				<cfelse>
					','+SPCF.FUSE_NAME+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#arguments.fuseaction#,%">
				</cfif>
		</cfquery>
		<cfreturn get_User_Process_Cat>
	</cffunction>
	
	<cffunction name="get_Old_Process_Cat" access="public" returntype="query">
		<cfargument name="process_cat" type="numeric" required="no" default="0">
		 <cfquery name="get_Old_Process_Cat" dbtype="query">
			SELECT PROCESS_CAT_ID, PROCESS_TYPE, MULTI_TYPE FROM get_User_Process_Cat WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#">
		</cfquery>
		<cfreturn get_Old_Process_Cat>
	</cffunction>
	
	<cffunction name="get_Check_Process_Cat_Id" access="public" returntype="query">
		<cfargument name="process_cat" type="numeric" required="no" default="0">
		<cfargument name="module_id" type="string" required="no" default="">
		<cfquery name="get_Check_Process_Cat_Id" datasource="#this.action_db_type#">
			SELECT PROCESS_CAT_ID FROM #this.process_db3#SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#">  AND PROCESS_MODULE IN (#arguments.module_id#)
		</cfquery>
		<cfreturn get_Check_Process_Cat_Id>
	</cffunction>
	
</cfcomponent>
