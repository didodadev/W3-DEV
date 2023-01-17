<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name="list_productplan" access="public" returntype="query">
        <cfargument name="plan_id" type="any">
		<cfargument name="plan_type_id" type="any">
        <cfargument name="req_id" type="any">
        <cfargument name="project_id" type="any">
		<cfargument name="date_start" type="any">
        <cfargument name="date_end" type="any">
		<cfargument name="req_no" type="any">
		<cfargument name="project_emp_id" type="any">
		<cfargument name="task_emp_name" type="any">
		<cfargument name="process_stage" type="any">
        <cfargument name="access" type="any">
		<cfargument name="is_task" type="any">
		<cfargument name="active" type="any">
		<cfargument name="company_order_no" type="any" default="">
		<cfargument name="is_revision" type="any" default="">
		
        <cfquery name="query_list_productplan" datasource="#dsn3#">
            SELECT 
					P.*,
					SR.*,
					C.*,
					PROCESS_TYPE_ROWS.STAGE,
					PRO_PROJECTS.PROJECT_HEAD,
					ASSET.ASSET_ID,
					ASSET.ASSETCAT_ID,
					ASSET.ASSET_FILE_NAME
			FROM 
				TEXTILE_PRODUCT_PLAN P
				left JOIN #dsn#.PROCESS_TYPE_ROWS ON PROCESS_TYPE_ROWS.PROCESS_ROW_ID=P.STAGE_ID,
				TEXTILE_SAMPLE_REQUEST SR
				OUTER APPLY(
						select
							TOP 1 
							ASSET_ID,
							ASSETCAT_ID,
							ASSET_FILE_NAME
						FROM
							#DSN#.ASSET
							where
								ACTION_SECTION='REQ_ID' AND 
								ACTION_ID=SR.REQ_ID AND
								IS_IMAGE=1 AND
								MODULE_NAME='textile'
								ORDER BY ASSET_ID
					) ASSET
				LEFT JOIN #dsn#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID=SR.PROJECT_ID
				left JOIN #dsn#.COMPANY C on SR.COMPANY_ID=C.COMPANY_ID
				
            WHERE
			P.REQUEST_ID=SR.REQ_ID 
			<cfif isDefined("arguments.active") and len(arguments.active)>
				AND	P.ACTIVE=#arguments.active#>
			</cfif>       
            <cfif isDefined("arguments.plan_id") and len(arguments.plan_id) and arguments.plan_id gt 0>
            AND P.PLAN_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.plan_id#'>
            </cfif>

            <cfif isDefined("arguments.req_id") and len(arguments.req_id) and arguments.req_id gt 0>
            AND P.REQUEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
            </cfif>
  <cfif isDefined("arguments.req_no") and len(arguments.req_no)>
            AND SR.REQ_NO LIKE '%#arguments.req_no#%'
            </cfif>
            <cfif isDefined("arguments.project_id") and len(arguments.project_id) and arguments.project_id gt 0>
            AND PRO_PROJECTS.PROJECT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.project_id#'>
            </cfif>
			<cfif isDefined("arguments.plan_type_id") and len(arguments.plan_type_id)>
				AND P.PLAN_TYPE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.plan_type_id#'>
            </cfif>
			<cfif isDefined("arguments.process_stage") and len(arguments.process_stage)>
				AND P.STAGE_ID IN(#arguments.process_stage#)
			</cfif>
			<cfif isdefined("arguments.project_emp_id") and isdefined("arguments.task_emp_name") and len(arguments.project_emp_id) and len(arguments.task_emp_name)>
			 AND P.TASK_EMP=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.project_emp_id#'>
			</cfif>
			<cfif isDefined("arguments.is_task") and arguments.is_task eq 0>
				AND P.TASK_EMP IS NULL
			</cfif>
            <cfif isDefined("arguments.access") and arguments.access eq 1> 
						AND SR.REQ_ID IN(
                            SELECT TS.REQ_ID FROM 
                            #dsn#_product.PRODUCT_CAT_POSITIONS PCP,
                            #dsn3#.TEXTILE_SR_SUPLIERS TS
							where
                            PCP.PRODUCT_CAT_ID=TS.PRODUCT_CATID AND
                            PCP.POSITION_CODE=#session.ep.position_code#
						)
			<cfelseif isDefined("arguments.access") and arguments.access eq 2> 
						AND SR.REQ_ID IN(
                            SELECT TS.REQUEST_ID FROM 
                            #dsn#_product.PRODUCT PCP,
                            #dsn3#.TEXTILE_SR_PROCESS TS
							where
                            PCP.PRODUCT_ID=TS.PRODUCT_ID AND
                            PCP.PRODUCT_MANAGER=#session.ep.position_code#
						)
				</cfif>
			<cfif isDefined("arguments.company_order_no") and len(arguments.company_order_no)>
					AND SR.COMPANY_ORDER_NO='#arguments.company_order_no#'
			</cfif>
			<cfif isDefined("arguments.is_revision") and len(arguments.is_revision)>
					AND ISNULL(P.IS_REVISION,0)=#arguments.is_revision#
			</cfif>
            ORDER BY SR.REQ_ID DESC,ISNULL(P.IS_REVISION,0) DESC

        </cfquery>
        <cfreturn query_list_productplan>
    </cffunction>

    <cffunction name="add_productplan" access="public" returntype="any">
		<cfargument name="plan_type_id" type="any">
		<cfargument name="plan_type" type="any">
        <cfargument name="project_id" type="any">
        <cfargument name="req_id" type="any">
		 <cfargument name="plan_date" type="date">
        <cfargument name="start_date" type="any">
        <cfargument name="finish_date" type="any">
		 <cfargument name="is_revision" type="any" default="">
		
		 <cfset stage="">
		 
		  <cfif isDefined("arguments.finish_date") and len(arguments.finish_date)> 
                 <cf_date tarih="arguments.finish_date">
            </cfif>
            <cfif isDefined("arguments.start_date") and len(arguments.start_date)> 
                <cf_date tarih="arguments.start_date">
           </cfif>
		 
		 
		<cfif isDefined("arguments.plan_type") and len(arguments.plan_type)>
				<cfset fuse="">
				<cfif arguments.plan_type_id eq 1>
					<cfset fuse="textile.product_plan">
				<cfelseif arguments.plan_type_id eq 2>
					<cfset fuse="textile.fabric_price">
				<cfelseif arguments.plan_type_id eq 3>
					<cfset fuse="textile.accessory_price">
				<cfelseif arguments.plan_type_id eq 4>
					<cfset fuse="textile.pattern_plan">
				<cfelseif arguments.plan_type_id eq 5>
					<cfset fuse="textile.workmanship_plan">
				<cfelseif arguments.plan_type_id eq 6>
					<cfset fuse="textile.list_product_models">
				<cfelseif arguments.plan_type_id eq 7>
					<cfset fuse="textile.wash_plan">
				<cfelseif arguments.plan_type_id eq 8>
					<cfset fuse="textile.mold_plan">
				<cfelseif arguments.plan_type_id eq 9>
					<cfset fuse="textile.marker_plan">
				</cfif>
					<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
							SELECT
							TOP 1
								PTR.STAGE,
								PTR.PROCESS_ROW_ID
							FROM
								PROCESS_TYPE_ROWS PTR,
								PROCESS_TYPE PT
							WHERE
								PTR.PROCESS_ID = PT.PROCESS_ID AND
								PT.FACTION LIKE '%#fuse#%'
								ORDER BY PROCESS_ROW_ID 
						</cfquery>
				<cfif len(GET_PROCESS_TYPE.PROCESS_ROW_ID)>
				 <cfset stage=GET_PROCESS_TYPE.PROCESS_ROW_ID>
				 </cfif>
		</cfif>

        <cflock name="#createUUID()#" timeout="20">
        <cftransaction>
				<cfquery name="query_add_productplan" datasource="#dsn3#" result="add_productplan">
						INSERT INTO [TEXTILE_PRODUCT_PLAN]
						   (
							[REQUEST_ID]
						   ,[PLAN_DATE]
						 <cfif isDefined("arguments.start_date") and len(arguments.start_date)> 
						   ,[START_DATE]
						 </cfif>
						  <cfif isDefined("arguments.finish_date") and len(arguments.finish_date)> 
						   ,[FINISH_DATE]
						  </cfif>
						   ,PLAN_TYPE_ID<!---kumaş plan,aksesuar plan vs.. --->
						   ,PLAN_TYPE
						   ,[ACTIVE]
						   ,RECORD_EMP
						   ,RECORD_DATE
						   ,STAGE_ID
						   ,IS_REVISION
						   )
					 VALUES
						   (
							<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
						   ,<cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.plan_date#'>
						<cfif isDefined("arguments.start_date") and len(arguments.start_date)> 
							,<cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.start_date#'>
						</cfif>
						 <cfif isDefined("arguments.finish_date") and len(arguments.finish_date)> 
						   ,<cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.finish_date#'>
						 </cfif>
						  , <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.plan_type_id#'>
							, <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.plan_type#'>
						   ,<cfqueryparam cfsqltype='CF_SQL_SMALLINT' value='1'>
						   ,#session.ep.userid#
						   ,#now()#
						   ,<cfif len(stage)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#stage#'><cfelse>NULL</cfif>
						   ,<cfif arguments.is_revision eq 1>1<cfelse>0</cfif>
						   )
			   
				   </cfquery>
						<cfif ListFind('2,3',arguments.plan_type_id)><!---kumas veya aksesuar talep--->	   
							<cfquery name="update_suplier" datasource="#dsn3#">
									UPDATE TEXTILE_SR_SUPLIERS
									SET PLAN_ID=#add_productplan.IDENTITYCOL#
									WHERE 
										REQ_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
										AND PLAN_ID IS NULL
										<cfif arguments.plan_type_id eq 2><!---kumaş talebi plan--->
										AND	ISNULL(REQUEST_TYPE,0)=0
										<cfelseif arguments.plan_type_id eq 3><!---aksesuar talebi plan--->
										AND	ISNULL(REQUEST_TYPE,0)=1
										</cfif>
										<cfif arguments.is_revision eq 1>
											AND IS_REVISION=1
										</cfif>
							</cfquery> 
						<cfelseif arguments.plan_type_id eq 5><!---iscilik fiyat talebi--->
								<cfquery name="update_suplier" datasource="#dsn3#">
									UPDATE TEXTILE_SR_PROCESS
									SET PLAN_ID=#add_productplan.IDENTITYCOL#
									WHERE 
										REQUEST_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
										AND PLAN_ID IS NULL
										<cfif arguments.is_revision eq 1>
											AND IS_REVISION=1
										</cfif>
								</cfquery> 	
						</cfif> 
        </cftransaction>
        </cflock>
        <cfreturn add_productplan>
    </cffunction>
	    <cffunction name="revision_demand" access="public" returntype="any"><!---iş açılmamış revizyon talebi stok varmı--->
			<cfargument name="plan_type_id" type="any">
			<cfargument name="req_id" type="any">
			<cfargument name="is_revision" type="any" default="">
				<cfquery name="get_revision" datasource="#dsn3#">
					select *from 
						TEXTILE_SR_SUPLIERS
					WHERE
						REQ_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
						AND IS_REVISION=1 
						<cfif arguments.plan_type_id eq 2><!---kumaş talebi plan--->
						AND	ISNULL(REQUEST_TYPE,0)=0
						<cfelseif arguments.plan_type_id eq 3><!---aksesuar talebi plan--->
						AND	ISNULL(REQUEST_TYPE,0)=1
						</cfif>
						AND PLAN_ID IS NULL
				</cfquery> 
				<cfreturn get_revision>
		</cffunction>
		 <cffunction name="revision_workmanship" access="public" returntype="any"><!---iş açılmamış revizyon talebi stok varmı--->
			<cfargument name="plan_type_id" type="any">
			<cfargument name="req_id" type="any">
			<cfargument name="is_revision" type="any" default="">
			<cfargument name="pcatid" type="any" default="">
				<cfquery name="get_revision" datasource="#dsn3#">
					select *from 
						TEXTILE_SR_PROCESS
					WHERE
						REQUEST_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
						AND IS_REVISION=1 
						<cfif arguments.plan_type_id eq 5>
						AND	PRODUCT_CATID=#arguments.pcatid#
						</cfif>
						AND PLAN_ID IS NULL
				</cfquery> 
				<cfreturn get_revision>
		</cffunction>
			
    <cffunction name="update_productplan" access="public" returntype="any">
		<cfargument name="plan_id" type="any">
		<cfargument name="req_id" type="any">
        <cfargument name="project_id" type="any">
		<cfargument name="plan_date" type="date">
        <cfargument name="start_date" type="any">
        <cfargument name="finish_date" type="any">
        <cfargument name="stage" type="any">
		<cfargument name="task_emp" type="any">
		<cfargument name="active" type="any">
		<cfargument name="work_id" type="any">
        <cflock name="#createUUID()#" timeout="20">
        <cftransaction>
        
            
           <cfif isDefined("arguments.plan_date") and len(arguments.plan_date)> 
            <cf_date tarih="arguments.plan_date">
       </cfif>

        <cfquery name="query_update_productplan" datasource="#dsn3#" result="update_productplan">
            UPDATE TEXTILE_PRODUCT_PLAN
            SET 
                [REQUEST_ID]=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
            <cfif isDefined("arguments.plan_date") and len(arguments.plan_date)>
               ,[PLAN_DATE]=<cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.plan_date#'>
            </cfif>
            <cfif isDefined("arguments.start_date") and len(arguments.start_date)> 
               ,[START_DATE]=#arguments.start_date#
			<cfelse>
				,[START_DATE]=NULL
            </cfif>
            <cfif isDefined("arguments.finish_date") and len(arguments.finish_date)> 
               ,[FINISH_DATE]=#arguments.finish_date#
			  <cfelse>
				,[FINISH_DATE]=NULL
            </cfif>
            <cfif isDefined("arguments.status") and len(arguments.status)> 
               ,[ACTIVE]=<cfqueryparam cfsqltype='CF_SQL_SMALLINT' value='#arguments.status#'>
            </cfif>
            <cfif isDefined("arguments.stage") and len(arguments.stage)> 
                ,STAGE_ID=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stage#'>
            </cfif>
			,TASK_EMP=<cfif isDefined("arguments.task_emp") and len(arguments.task_emp)><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.task_emp#'><cfelse>NULL</cfif>
			,ACTIVE=<cfif isDefined("arguments.active") and len(arguments.active)>1<cfelse>0</cfif>
            ,UPDATE_DATE=#now()#
			,UPDATE_EMP=#session.ep.userid#
			,WORK_ID=<cfif isdefined("arguments.work_id") and len(arguments.work_id)>#arguments.work_id#<cfelse>NULL</cfif>
            WHERE 
				PLAN_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.plan_id#'> 
        </cfquery>
        </cftransaction>
        </cflock>
        <cfreturn update_productplan>
    </cffunction>
	 <cffunction name="getProcessType" access="public" returntype="any">
			<cfquery name="get_process_type" datasource="#dsn#">
				SELECT *from TEXTILE_PROCESS_TYPE
				where PROCESS_STATUS=1
			</cfquery>
	  <cfreturn get_process_type>
    </cffunction>
</cfcomponent>