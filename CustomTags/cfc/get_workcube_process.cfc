<!--- FBS 20120615 workcube_process ve workcube_process_info tagleri icin olusturulmustur --->
<!--- upd : 22/11/2019 Uğur Hamurpet Workflow üzerinden aksiyonların yönetimi için düzenlemeler yapıldı --->
<!--- upd : 28.12.2019 HY Dinamik Aksiyonlar için sorgulama eklendi --->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset database_type = application.systemParam.systemParam().database_type>
	<cfif isdefined('onesignal_appID') and len(onesignal_appID)>
		<cfset onesignal_appID = application.systemParam.systemParam().onesignal_appID>
		<cfset onesignal = application.systemParam.systemParam().onesignal>
	</cfif>
	<!--- Form --->
	<cffunction name="get_ProcessType" access="public" returntype="query">
		<cfargument name="process_db" type="string" required="no" default="#this.process_db#">
		<cfargument name="our_company_id" type="numeric" required="no" default="#this.my_our_company_id_#">
		<cfargument name="fuseaction" type="string" required="no" default="">
		<cfargument name="friendly_url" type="string" required="no" default="">
		<cfargument name="select_value" type="numeric" required="no" default="0">
		<cfargument name="extra_process_id" type="string" required="no" default="">
		<cfargument name="faction_list" type="string" required="no" default="">
		<!--- Sirketlere Bagli Surec Yetkileri --->
		<cfquery name="get_ProcessType" datasource="#this.data_source#">
			SELECT
				PT.PROCESS_ID,
				PT.PROCESS_NAME,
				PT.IS_STAGE_BACK,
				PT.MAIN_FILE,
				PT.IS_MAIN_FILE,
				PT.MAIN_ACTION_FILE,
				PT.IS_MAIN_ACTION_FILE
			FROM
				#process_db#PROCESS_TYPE PT,
				#process_db#PROCESS_TYPE_OUR_COMPANY PTOC
			WHERE
				<cfif Len(arguments.select_value) and arguments.select_value neq 0>
					PT.PROCESS_ID IN (SELECT PTR.PROCESS_ID FROM #process_db#PROCESS_TYPE_ROWS PTR WHERE PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.select_value#">) AND
				<cfelse>
					<cfif Len(faction_list)>
						PT.PROCESS_ID IN (SELECT PTR.PROCESS_ID FROM #process_db#PROCESS_TYPE_ROWS PTR WHERE PTR.PROCESS_ROW_ID IN (#faction_list#)) AND
					</cfif>
					PT.IS_ACTIVE = 1 AND
				</cfif>
				PT.PROCESS_ID = PTOC.PROCESS_ID AND
				PTOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#our_company_id#"> 
				<cfif len(arguments.extra_process_id)>
					AND PT.PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.extra_process_id#">
				<cfelse>
					AND 
						(CAST(PT.FACTION AS <cfif database_type is 'MSSQL'>NVARCHAR(2500))+<cfelse>VARGRAPHIC(2500))||</cfif>',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.fuseaction#,%">
					<cfif len(arguments.friendly_url)>
						OR CAST(PT.FRIENDLY_URL AS <cfif database_type is 'MSSQL'>NVARCHAR(2500))+<cfelse>VARGRAPHIC(2500))||</cfif>',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.friendly_url#,%">)
					<cfelse>
						)
					</cfif>
				</cfif>
			ORDER BY
				PTOC.OUR_COMPANY_ID,
				PT.PROCESS_ID
		</cfquery>
		<cfreturn get_ProcessType>
	</cffunction>

	<cffunction name="get_Faction" access="public" returntype="query">
		<cfargument name="process_db" type="string" required="no" default="#this.process_db#">
		<cfargument name="module_type" type="string" required="no" default="#this.module_type#">
		<cfargument name="extra_process_row_id" type="string" required="no" default="">
		<cfargument name="position_code" type="any" required="no" default="">
		<cfargument name="partner_id" type="any" required="no" default="">
		<cfargument name="fuseaction" type="string" required="yes">
		<cfargument name="wrkflow" type="numeric" required="no" default="0">
		<cfargument name="pathinfo" type="string" required="yes">
		
		<cfif get_ProcessType.RecordCount><cfset Process_Id_List = ValueList(get_ProcessType.Process_Id)><cfelse><cfset Process_Id_List = 0></cfif>
		
		<cfset get_process_sender = createObject("component", "WMO.process_authority")
										.init( data_source : this.data_source, process_db : process_db)
										.get_process_sender(
											fuseaction : arguments.fuseaction,
											wrkflow : arguments.wrkflow,
											pathinfo : arguments.pathinfo
										) />
        <cfset sender_position_codes = get_process_sender.recordcount ? ValueList(get_process_sender.SENDER_POSITION_CODE) : "" />

		<cfset today_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>

		<!--- Asama Yetkileri --->
		<cfquery name="get_Faction" datasource="#this.data_source#">
			<!--- Yetkili Pozisyonlar / Yetkili Partnerlar / Yetkili Consumerlar --->
			SELECT DISTINCT
				PTR.PROCESS_ROW_ID,
				PTR.STAGE_CODE,
				#dsn#.#dsn#.Get_Dynamic_Language(PTR.PROCESS_ROW_ID,'#this.lang#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
				PTR.LINE_NUMBER LINE_NUMBER,
				PTR.IS_DISPLAY,
				PTR.DISPLAY_FILE_NAME
			FROM
				#process_db#PROCESS_TYPE_ROWS PTR,
				#process_db#PROCESS_TYPE_ROWS_POSID PTRP
			WHERE
				PTR.PROCESS_ROW_ID = PTRP.PROCESS_ROW_ID AND
				PTR.PROCESS_ID IN (#Process_Id_List#) 
				<cfif Len(arguments.extra_process_row_id) and arguments.extra_process_row_id neq -1>
					AND PTR.PROCESS_ROW_ID IN (#arguments.extra_process_row_id#) 
				<cfelseif arguments.extra_process_row_id neq -1>
					AND 1 = 0 
				</cfif>
				<cfif arguments.module_type is "e">
					AND PTRP.PRO_POSITION_ID IN 
					(	SELECT
							POSITION_ID
						FROM
							#process_db#EMPLOYEE_POSITIONS EP
						WHERE
							(
								EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
								<cfif len(sender_position_codes)>
								OR EP.POSITION_CODE IN(#sender_position_codes#)
								</cfif>
							)
					) AND
					PTR.IS_EMPLOYEE = 0
				<cfelseif arguments.module_type is "p">
					AND PTRP.PRO_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#"> AND
					PTR.IS_PARTNER = 0
				<cfelseif arguments.module_type is "w">
					AND PTR.IS_CONSUMER = 0
				</cfif>
		UNION
			<!--- Tum Calisanlar/ Tum Kurumsal Uyeler / Tum Bireysel Uyeler --->
			SELECT DISTINCT
				PTR.PROCESS_ROW_ID,
				PTR.STAGE_CODE,
				#dsn#.#dsn#.Get_Dynamic_Language(PTR.PROCESS_ROW_ID,'#this.lang#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
				PTR.LINE_NUMBER LINE_NUMBER,
				PTR.IS_DISPLAY,
				PTR.DISPLAY_FILE_NAME
			FROM
				#process_db#PROCESS_TYPE_ROWS PTR
			WHERE
				PTR.PROCESS_ID IN (#Process_Id_List#) 
				<cfif Len(arguments.extra_process_row_id) and arguments.extra_process_row_id neq -1>
					AND PTR.PROCESS_ROW_ID IN (#arguments.extra_process_row_id#)
				<cfelseif arguments.extra_process_row_id neq -1>
					AND 1 = 0 
				 </cfif>
				<cfif arguments.module_type is "e">
	                AND PTR.IS_EMPLOYEE = 1
				<cfelseif arguments.module_type is "p">
					AND PTR.IS_PARTNER = 1
				<cfelseif arguments.module_type is "w">
					AND PTR.IS_CONSUMER = 1
				</cfif>
		UNION
			<!--- Tum Surec Gruplari --->
			SELECT DISTINCT
				PTR.PROCESS_ROW_ID,
				PTR.STAGE_CODE,
				#dsn#.#dsn#.Get_Dynamic_Language(PTR.PROCESS_ROW_ID,'#this.lang#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
				PTR.LINE_NUMBER LINE_NUMBER,
				PTR.IS_DISPLAY,
				PTR.DISPLAY_FILE_NAME
			FROM 	
				#process_db#PROCESS_TYPE_ROWS PTR,
				#process_db#PROCESS_TYPE_ROWS_POSID PTRP,
				#process_db#PROCESS_TYPE_ROWS_WORKGRUOP PTRW
			WHERE
				PTR.PROCESS_ID IN (#Process_Id_List#) AND
				PTRW.PROCESS_ROW_ID = PTR.PROCESS_ROW_ID  AND 
				PTRW.MAINWORKGROUP_ID IS NOT NULL AND 
				PTRW.MAINWORKGROUP_ID = PTRP.WORKGROUP_ID  
				<cfif Len(arguments.extra_process_row_id) and arguments.extra_process_row_id neq -1>
					AND PTR.PROCESS_ROW_ID IN (#arguments.extra_process_row_id#) 
				<cfelseif arguments.extra_process_row_id neq -1>
					AND 1 = 0
				</cfif>
				<cfif arguments.module_type is "e">
					AND PTRP.PRO_POSITION_ID IN 
					(	SELECT
							POSITION_ID
						FROM
							#process_db#EMPLOYEE_POSITIONS EP
						WHERE
							(
								EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
								<cfif len(sender_position_codes)>
								OR EP.POSITION_CODE IN(#sender_position_codes#)
								</cfif>
							)
					)
				<cfelseif arguments.module_type is "p">
					AND ( PTR.IS_PARTNER = 1 OR PTRP.PRO_PARTNER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">) )
				<cfelseif arguments.module_type is "w">
					AND PTR.IS_CONSUMER = 1
				</cfif>
			ORDER BY 
				LINE_NUMBER
		</cfquery>
		<cfreturn get_Faction>
	</cffunction>
	
	<cffunction name="get_File_Name" access="public" returntype="query">
		<cfargument name="process_db" type="string" required="no" default="#this.process_db#">
		<cfargument name="select_value" type="numeric" required="no" default="0">
		<cfif get_ProcessType.RecordCount><cfset Process_Id_List = ValueList(get_ProcessType.Process_Id)><cfelse><cfset Process_Id_List = 0></cfif>

		<!--- Asama Display File Kontrolu, Eklemede Ilk Asamaya, Guncellemede Bulundugu Asamaya Bakar --->
		<cfquery name="get_File_Name" datasource="#this.data_source#">
			SELECT
				PTR.IS_DISPLAY,
				PTR.DISPLAY_FILE_NAME,
				PTR.IS_DISPLAY_FILE_NAME 
			FROM 
				#process_db#PROCESS_TYPE_ROWS PTR
			WHERE 
				PTR.PROCESS_ID IN (#Process_Id_List#) AND
				<cfif Len(arguments.select_value) and arguments.select_value neq 0>
					PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.select_value#">
				<cfelse>
					<cfif get_Faction.RecordCount>
						PTR.PROCESS_ROW_ID IN (#ValueList(get_Faction.Process_Row_Id,',')#) AND
					</cfif>
					PTR.LINE_NUMBER = 1
				</cfif>
		</cfquery>
		<cfreturn get_File_Name>
	</cffunction>
	
	<cffunction name="get_Line_Number" access="public" returntype="query">
		<cfargument name="process_db" type="string" required="no" default="#this.process_db#">
		<cfargument name="select_value" type="numeric" required="yes" default="0">
		<cfif get_ProcessType.RecordCount><cfset Process_Id_List = ValueList(get_ProcessType.Process_Id)><cfelse><cfset Process_Id_List = 0></cfif>

		<cfquery name="get_Line_Number" datasource="#this.data_source#">
			SELECT
				PTR.PROCESS_ROW_ID,
				PTR.STAGE_CODE,
				#dsn#.#dsn#.Get_Dynamic_Language(PTR.PROCESS_ROW_ID,'#this.lang#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
				(SELECT IS_STAGE_BACK FROM #process_db#PROCESS_TYPE PT WHERE PT.PROCESS_ID = PTR.PROCESS_ID) IS_STAGE_BACK,
				PTR.IS_CONTINUE,
				PTR.IS_DISPLAY,
				PTR.PROCESS_ID,
				PTR.LINE_NUMBER
			FROM 
				#process_db#PROCESS_TYPE_ROWS PTR
			WHERE 
				PTR.PROCESS_ID IN (#Process_Id_List#) AND
				PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.select_value#">
		</cfquery>
		<cfreturn get_Line_Number>
	</cffunction>
	
	<cffunction name="get_Select_Line0" access="public" returntype="query">
		<cfargument name="process_db" type="string" required="no" default="#this.process_db#">
		<cfargument name="module_type" type="string" required="no" default="#this.module_type#">
		<cfargument name="extra_process_row_id" type="string" required="no" default="">
		<cfargument name="fuseaction" type="string" required="yes">
		<cfargument name="position_code" type="any" required="no" default="">
		<cfargument name="partner_id" type="any" required="no" default="">
		<cfargument name="select_value" type="numeric" required="no" default="0">
		<cfargument name="wrkflow" type="numeric" required="no" default="0">
		<cfargument name="pathinfo" type="string" required="yes">

		<cfif get_ProcessType.RecordCount><cfset Process_Id_List = ValueList(get_ProcessType.Process_Id)><cfelse><cfset Process_Id_List = 0></cfif>

		<cfset get_process_sender = createObject("component", "WMO.process_authority")
										.init( data_source : this.data_source, process_db : process_db)
										.get_process_sender(
											fuseaction : arguments.fuseaction,
											wrkflow : arguments.wrkflow,
											pathinfo : arguments.pathinfo
										) />

        <cfset sender_position_codes = get_process_sender.recordcount ? ValueList(get_process_sender.SENDER_POSITION_CODE) : "" />

		<cfquery name="get_Select_Line0" datasource="#this.data_source#">
			SELECT DISTINCT
				PTR.PROCESS_ROW_ID,
				PTR.STAGE_CODE,
				#dsn#.#dsn#.Get_Dynamic_Language(PTR.PROCESS_ROW_ID,'#this.lang#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
				PTR.LINE_NUMBER LINE_NUMBER,
				PTR.IS_CONTINUE,
				PTR.CONFIRM_REQUEST,
				PTR.IS_CONFIRM,
				PTR.IS_REFUSE,
				PTR.IS_AGAIN,
				PTR.IS_WARNING,
				PTR.IS_CANCEL
			FROM
				#process_db#PROCESS_TYPE_ROWS PTR,
				#process_db#PROCESS_TYPE_ROWS_POSID PTRP
			WHERE
				PTR.PROCESS_ID IN (#Process_Id_List#) AND
				<cfif get_Line_Number.Is_Stage_Back eq 0>
					PTR.LINE_NUMBER >= ( SELECT PTR2.LINE_NUMBER FROM PROCESS_TYPE_ROWS PTR2 WHERE PTR2.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.select_value#">) AND 
					PTR.PROCESS_ID = #get_Line_Number.Process_Id# AND 
				</cfif>
				<cfif Len(arguments.extra_process_row_id) and arguments.extra_process_row_id neq -1>
					PTR.PROCESS_ROW_ID IN (#arguments.extra_process_row_id#) AND
				<cfelseif arguments.extra_process_row_id neq -1>
					1 = 0 AND
				</cfif>
				<cfif arguments.module_type is "e">
					PTRP.PRO_POSITION_ID IN 
					(	SELECT
							POSITION_ID
						FROM
							#process_db#EMPLOYEE_POSITIONS EP
						WHERE
							(
								EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
								<cfif len(sender_position_codes)>
								OR EP.POSITION_CODE IN(#sender_position_codes#)
								</cfif>
							)
					) AND
					PTR.IS_EMPLOYEE = 0 AND
				<cfelseif arguments.module_type is "p">
					(PTR.IS_PARTNER = 1 OR PTRP.PRO_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">) AND
				</cfif>
				PTRP.PROCESS_ROW_ID = PTR.PROCESS_ROW_ID
		UNION
			SELECT DISTINCT
				PTR.PROCESS_ROW_ID,
				PTR.STAGE_CODE,
				#dsn#.#dsn#.Get_Dynamic_Language(PTR.PROCESS_ROW_ID,'#this.lang#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
				PTR.LINE_NUMBER LINE_NUMBER,
				PTR.IS_CONTINUE,
				PTR.CONFIRM_REQUEST,
				PTR.IS_CONFIRM,
				PTR.IS_REFUSE,
				PTR.IS_AGAIN,
				PTR.IS_WARNING,
				PTR.IS_CANCEL
			FROM
				#process_db#PROCESS_TYPE_ROWS PTR
			WHERE
				PTR.PROCESS_ID IN (#Process_Id_List#) AND
				<cfif get_Line_Number.Is_Stage_Back eq 0>
					PTR.LINE_NUMBER >= ( SELECT PTR2.LINE_NUMBER FROM PROCESS_TYPE_ROWS PTR2 WHERE PTR2.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.select_value#">) AND 
					PTR.PROCESS_ID = #get_Line_Number.Process_Id# AND 
				</cfif>
				<cfif Len(arguments.extra_process_row_id) and arguments.extra_process_row_id neq -1>
					PTR.PROCESS_ROW_ID IN (#arguments.extra_process_row_id#) AND
				<cfelseif arguments.extra_process_row_id neq -1>
					1 = 0 AND
				</cfif>
				<cfif arguments.module_type is "e">
					PTR.IS_EMPLOYEE  = 1
				<cfelseif arguments.module_type is "p">
					PTR.IS_PARTNER  = 1
				<cfelseif arguments.module_type is "w">
					PTR.IS_CONSUMER = 1
				<cfelse>
					1 = 0
				</cfif>
		<!--- Grupları çekiyor. --->
		UNION 
			SELECT DISTINCT
				PTR.PROCESS_ROW_ID,
				PTR.STAGE_CODE,
				#dsn#.#dsn#.Get_Dynamic_Language(PTR.PROCESS_ROW_ID,'#this.lang#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
				PTR.LINE_NUMBER LINE_NUMBER,
				PTR.IS_CONTINUE,
				PTR.CONFIRM_REQUEST,
				PTR.IS_CONFIRM,
				PTR.IS_REFUSE,
				PTR.IS_AGAIN,
				PTR.IS_WARNING,
				PTR.IS_CANCEL
			FROM 	
				#process_db#PROCESS_TYPE_ROWS PTR,
				#process_db#PROCESS_TYPE_ROWS_WORKGRUOP PTRW,
				#process_db#PROCESS_TYPE_ROWS_POSID PTRP
			WHERE 
				PTR.PROCESS_ID IN (#Process_Id_List#) AND
				<cfif get_Line_Number.Is_Stage_Back eq 0>
					PTR.LINE_NUMBER >= ( SELECT PTR2.LINE_NUMBER FROM PROCESS_TYPE_ROWS PTR2 WHERE PTR2.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.select_value#">) AND 
					PTR.PROCESS_ID = #get_Line_Number.Process_Id# AND 
				</cfif>
				<cfif arguments.module_type is "e">
					PTRP.PRO_POSITION_ID IN 
					(	SELECT
							POSITION_ID
						FROM
							#process_db#EMPLOYEE_POSITIONS EP
						WHERE
							(
								EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
								<cfif len(sender_position_codes)>
								OR EP.POSITION_CODE IN(#sender_position_codes#)
								</cfif>
							)
					) AND
				<cfelseif arguments.module_type is "p">
					( PTR.IS_PARTNER = 1 OR PTRP.PRO_PARTNER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">) ) AND
				</cfif>
				<cfif Len(arguments.extra_process_row_id) and arguments.extra_process_row_id neq -1>
					PTR.PROCESS_ROW_ID IN (#arguments.extra_process_row_id#) AND
				<cfelseif arguments.extra_process_row_id neq -1>
					1 = 0 AND
				</cfif>
				 PTRW.PROCESS_ROW_ID = PTR.PROCESS_ROW_ID  AND 
				 PTRW.MAINWORKGROUP_ID IS NOT NULL AND 
				 PTRW.MAINWORKGROUP_ID = PTRP.WORKGROUP_ID
			ORDER BY 
				LINE_NUMBER
		</cfquery>
		<cfreturn get_Select_Line0>
	</cffunction>
	
	<cffunction name="get_Select_Line1" access="public" returntype="query">
		<cfargument name="process_db" type="string" required="no" default="#this.process_db#">
		<cfargument name="select_value" type="numeric" required="yes" default="0">

		<cfquery name="get_Select_Line1" datasource="#this.data_source#">
			SELECT
				PTR.PROCESS_ROW_ID,
				PTR.STAGE_CODE,
				#dsn#.#dsn#.Get_Dynamic_Language(PTR.PROCESS_ROW_ID,'#this.lang#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
				PTR.LINE_NUMBER,
				PTR.IS_CONTINUE,
				PTR.CONFIRM_REQUEST,
				PTR.IS_CONFIRM,
				PTR.IS_REFUSE,
				PTR.IS_AGAIN,
				PTR.IS_WARNING,
				PTR.IS_CANCEL
			FROM 
				#process_db#PROCESS_TYPE_ROWS PTR
			WHERE 
				PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.select_value#">
		</cfquery>
		<cfreturn get_Select_Line1>
	</cffunction>
	
	<cffunction name="get_Select_Line" access="public" returntype="query">
		<cfquery name="get_Select_Line" dbtype="query">
			SELECT * FROM GET_SELECT_LINE0 UNION SELECT * FROM GET_SELECT_LINE1 ORDER BY LINE_NUMBER
		</cfquery>
		<cfreturn get_Select_Line>
	</cffunction>
	<!--- //Form --->
	
	<!--- Query --->
	<cffunction name="get_Process_Type_1" access="public" returntype="query">
		<cfargument name="process_db" type="string" required="no" default="">
		<cfargument name="process_id" type="numeric" required="no" default="-1">
		<cfargument name="process_stage" type="numeric" required="no" default="0">
		<cfargument name="data_source" type="string" required="no" default="">
		<cfargument name="lang" type="string" required="no" default="">

		<!--- Customtag dışından kullanımlarda this ile erişilmiyordu, arguments da yoksa this varlığı kontrol edilerek atanması sağlandı --->
		<cfif not len( arguments.process_db ) and isDefined("this.process_db")>
			<cfset arguments.process_db = this.process_db>
		</cfif>

		<cfif not len( arguments.data_source ) and isDefined("this.data_source")>
			<cfset arguments.data_source = this.data_source>
		</cfif>

		<cfif not len( arguments.lang ) and isDefined("this.lang")>
			<cfset arguments.lang = this.lang>
		</cfif>

		<cfquery name="get_Process_Type_1" datasource="#arguments.data_source#">
			SELECT
				(SELECT PT.PROCESS_NAME FROM #process_db#PROCESS_TYPE PT WHERE PT.PROCESS_ID = PTR.PROCESS_ID) PROCESS_NAME,
				PTR.PROCESS_ROW_ID,
				PTR.IS_WARNING,
				PTR.IS_SMS,
				PTR.IS_EMAIL,
				PTR.IS_KEP,
				PTR.IS_ONLINE,
				PTR.STAGE_CODE,
				#dsn#.#dsn#.Get_Dynamic_Language(PTR.PROCESS_ROW_ID,'#arguments.lang#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
				PTR.ANSWER_HOUR,
				PTR.ANSWER_MINUTE,
				PTR.IS_FILE_NAME,
				PTR.DETAIL,
				PTR.LINE_NUMBER,
				PTR.FILE_NAME,
				PTR.RECORD_EMP,
				PTR.UPDATE_EMP,
				PTR.RECORD_DATE,
				PTR.UPDATE_DATE,
				PTR.IS_CONSUMER,
				PTR.CONFIRM_REQUEST,
				PTR.IS_CONFIRM,
				PTR.IS_REFUSE,
				PTR.IS_AGAIN,
				PTR.IS_SUPPORT,
				PTR.IS_CANCEL,
				PTR.IS_APPROVE_ALL_CHECKERS,
				PTR.IS_CONFIRM_FIRST_CHIEF,
				PTR.IS_CONFIRM_SECOND_CHIEF,
				IS_CONFIRM_FIRST_CHIEF_RECORDING,
				IS_CONFIRM_SECOND_CHIEF_RECORDING,
				POSITION_CODE_ARGUMENT_NAME,
				PTR.IS_CONFIRM_STAGE_ID,
				PTR.IS_REFUSE_STAGE_ID,
				PTR.IS_AGAIN_STAGE_ID,
				PTR.IS_SUPPORT_STAGE_ID,
				PTR.IS_CANCEL_STAGE_ID,
				ISNULL(PTR.IS_SEND_NOTIFICATION_MAKER,0) AS IS_SEND_NOTIFICATION_MAKER,
				ISNULL(PTR.COMMENT_REQUEST,0) AS COMMENT_REQUEST,
				ISNULL(PTR.CHECKER_NUMBER,0) AS CHECKER_NUMBER,
				ISNULL(PTR.IS_CHECKER_UPDATE_AUTHORITY,0) AS IS_CHECKER_UPDATE_AUTHORITY,
				ISNULL(PTR.IS_ADD_ACCESS_CODE,0) AS IS_ADD_ACCESS_CODE,
				ISNULL(PTR.IS_CREATE_PASSWORD,0) AS IS_CREATE_PASSWORD,
				ISNULL(PTR.IS_CONFIRM_COMMENT_REQUIRED,0) AS IS_CONFIRM_COMMENT_REQUIRED,
				ISNULL(PTR.IS_REFUSE_COMMENT_REQUIRED,0) AS IS_REFUSE_COMMENT_REQUIRED,
				ISNULL(PTR.IS_AGAIN_COMMENT_REQUIRED,0) AS IS_AGAIN_COMMENT_REQUIRED,
				ISNULL(PTR.IS_SUPPORT_COMMENT_REQUIRED,0) AS IS_SUPPORT_COMMENT_REQUIRED,
				ISNULL(PTR.IS_CANCEL_COMMENT_REQUIRED,0) AS IS_CANCEL_COMMENT_REQUIRED,
				ISNULL(PTR.IS_STAGE_ACTION,0) AS IS_STAGE_ACTION
			FROM 
				#process_db#PROCESS_TYPE_ROWS PTR
			WHERE 
			<cfif arguments.process_id eq -1 and arguments.process_stage gt 0>
				PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
			<cfelse>
				PTR.PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_id#">
			</cfif>
		</cfquery>
		<cfreturn get_Process_Type_1>
	</cffunction>

	<cffunction name="get_Employee_WorkGroup" access="public" returntype="query">
		<cfargument name="process_db" type="string" required="no" default="#this.process_db#">
		<cfargument name="module_type" type="string" required="no" default="#this.module_type#">
		<cfargument name="process_stage" type="numeric" required="yes" default="0">
		<cfargument name="position_code" type="any" required="no" default="">
		<cfargument name="partner_id" type="any" required="no" default="">

		<cfquery name="get_Employee_WorkGroup" datasource="#this.data_source#">
			SELECT
				PTRW.WORKGROUP_ID,
				0 MAINWORKGROUP_ID
			FROM
				#process_db#PROCESS_TYPE_ROWS_WORKGRUOP PTRW,
				#process_db#PROCESS_TYPE_ROWS_POSID PTRP
			WHERE
				PTRW.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"> AND
				<cfif arguments.module_type is 'e'>
					PTRP.PRO_POSITION_ID IN 
					(	SELECT
							POSITION_ID
						FROM
							#process_db#EMPLOYEE_POSITIONS EP
						WHERE
							EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#"> 
					) AND
				<cfelseif arguments.module_type is 'p'>
					PTRP.PRO_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#"> AND
				</cfif>
				PTRW.WORKGROUP_ID = PTRP.WORKGROUP_ID
		UNION
			SELECT DISTINCT
				0 WORKGROUP_ID,
				PTRW.MAINWORKGROUP_ID MAINWORKGROUP_ID
			FROM
				#process_db#PROCESS_TYPE_ROWS_WORKGRUOP PTRW,
				#process_db#PROCESS_TYPE_ROWS PTR,
				#process_db#PROCESS_TYPE_ROWS_POSID PTRP
			WHERE
				PTRW.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"> AND 
				<cfif arguments.module_type is 'e'>
					PTRP.PRO_POSITION_ID IN 
					(	SELECT
							POSITION_ID
						FROM
							#process_db#EMPLOYEE_POSITIONS EP
						WHERE
							EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#"> 
					) AND
				<cfelseif arguments.module_type is 'p'>
					PTRP.PRO_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#"> AND
				</cfif>
				PTRW.MAINWORKGROUP_ID = PTRP.WORKGROUP_ID AND
				PTRW.PROCESS_ROW_ID = PTR.PROCESS_ROW_ID AND 
				PTRW.MAINWORKGROUP_ID IS NOT NULL
		</cfquery>
		<cfreturn get_Employee_WorkGroup>
	</cffunction>
	
	<cffunction name="get_Inf_Position_Type" access="public" returntype="query">
		<cfargument name="process_db" type="string" required="no" default="#this.process_db#">
        <cfargument name="module_type" type="string" required="no" default="#this.module_type#">
		<cfargument name="process_stage" type="numeric" required="yes" default="0">
		<cfargument name="value_workgroup_id" type="string" required="no" default="0">
		<cfargument name="value_mainworkgroup_id" type="string" required="no" default="0">

		<cfquery name="get_Inf_Position_Type" datasource="#this.data_source#">
			SELECT 
				PTRI.INF_POSITION_ID PRO_POSITION_ID,
				E.EMPLOYEE_NAME EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
				E.EMPLOYEE_EMAIL EMPLOYEE_EMAIL,
				EP.EMPLOYEE_ID EMPLOYEE_ID,
				E.MOBILCODE MOBILCODE,
				E.MOBILTEL MOBILTEL,
				EP.POSITION_CODE,
				E.EMPLOYEE_KEP_ADRESS,
				1 TYPE 
			FROM 
				#process_db#PROCESS_TYPE_ROWS_INFID PTRI,
				#process_db#EMPLOYEES E,
				#process_db#EMPLOYEE_POSITIONS EP
			WHERE 
				PTRI.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"> AND
				<cfif arguments.is_consumer eq 0 or (arguments.is_consumer eq 1 and module_type eq 'e')>
					PTRI.WORKGROUP_ID IN (#arguments.value_workgroup_id#) AND
				</cfif>
				E.EMPLOYEE_STATUS = 1 AND
				EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				EP.POSITION_ID = PTRI.INF_POSITION_ID
		<cfif arguments.is_consumer eq 0 or (arguments.is_consumer eq 1 and module_type eq 'e')>
			UNION 
				SELECT 
					PTRI.INF_POSITION_ID PRO_POSITION_ID,
					E.EMPLOYEE_NAME EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
					E.EMPLOYEE_EMAIL EMPLOYEE_EMAIL,
					EP.EMPLOYEE_ID EMPLOYEE_ID,
					E.MOBILCODE MOBILCODE,
					E.MOBILTEL MOBILTEL,
					EP.POSITION_CODE,
					EMPLOYEE_KEP_ADRESS,
					1 TYPE 
				FROM 					
					#process_db#PROCESS_TYPE_ROWS_WORKGRUOP PTRW,
					#process_db#PROCESS_TYPE_ROWS_INFID PTRI,
					#process_db#EMPLOYEE_POSITIONS EP,
					#process_db#EMPLOYEES E
				WHERE 
					PTRW.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"> AND 
					PTRW.MAINWORKGROUP_ID IN (#arguments.value_mainworkgroup_id#) AND
					PTRI.WORKGROUP_ID=PTRW.MAINWORKGROUP_ID AND
					E.EMPLOYEE_STATUS = 1 AND
					EP.POSITION_ID = PTRI.INF_POSITION_ID AND
					EP.EMPLOYEE_ID = E.EMPLOYEE_ID
		</cfif>
		</cfquery>
		<cfreturn get_Inf_Position_Type>
	</cffunction>
	
	<cffunction name="get_Cau_Position_Type" access="public" returntype="query">
		<cfargument name="process_db" type="string" required="no" default="">
		<cfargument name="module_type" type="string" required="no" default="">
		<cfargument name="data_source" type="string" required="no" default="">
		<cfargument name="process_stage" type="numeric" required="yes" default="0">
		<cfargument name="value_workgroup_id" type="string" required="no" default="0">
		<cfargument name="value_mainworkgroup_id" type="string" required="no" default="0">
		<cfargument name="is_approval_chief" type="numeric" required="no" default="0">
		<cfargument name="is_confirm_first_chief" type="numeric" required="no" default="0">
		<cfargument name="is_confirm_second_chief" type="numeric" required="no" default="0">
		<cfargument name="is_approval_recording_chief" type="boolean" required="no" default="0">
		<cfargument name="is_confirm_first_chief_recording" type="boolean" required="no" default="0">
		<cfargument name="is_confirm_second_chief_recording" type="boolean" required="no" default="0">
		<cfargument name="action_table" type="string" required="no" default="">
		<cfargument name="action_column" type="string" required="no" default="">
		<cfargument name="action_id" type="any" required="no" default="">
		<cfargument name="position_code" type="numeric" required="no" default="0">
		<cfargument name="mandate_position_code" type="numeric" required="no" default="0">
		<cfargument name="form_position_code" type="numeric" required="no" default="0"><!--- Formlarda başkasının adına kayıt atılırken gönderilen position_code değeri. Kaydı formdan seçilen kişi başlatır! --->

		<!--- Customtag dışından kullanımlarda this ile erişilmiyordu, arguments da yoksa this varlığı kontrol edilerek atanması sağlandı --->
		<cfif not len( arguments.process_db ) and isDefined("this.process_db")>
			<cfset arguments.process_db = this.process_db>
		</cfif>

		<cfif not len( arguments.module_type ) and isDefined("this.module_type")>
			<cfset arguments.module_type = this.module_type>
		</cfif>

		<cfif not len( arguments.data_source ) and isDefined("this.data_source")>
			<cfset arguments.data_source = this.data_source>
		</cfif>

		<!--- Süreç aşamasında ilk kaydı yapanın 1. amirine ve/veya 2. amirine gönder seçilmişse; ilk yapılan süreç kaydı ve süreci başlatan kişinin amirleri bulunur.--->
		<cfif arguments.is_approval_recording_chief eq 1 and IsDefined("arguments.action_table") and len(arguments.action_table) and IsDefined("arguments.action_column") and len(arguments.action_column) and IsDefined("arguments.action_id") and len(arguments.action_id)>
			<cfset get_first_sender = this.get_first_sender(
				action_table: arguments.action_table,
				action_column: arguments.action_column,
				action_id: arguments.action_id
			) />
		<cfelse><cfset get_first_sender = {recordcount: 0} /></cfif>

		<cfquery name="get_Cau_Position_Type" datasource="#arguments.data_source#">
			<!--- position_code gönderilmişse koşulsuz şartsız direkt ilgili kullanıcıyı getirir. --->
			<cfif arguments.position_code eq 0>
				<cfif arguments.is_approval_chief eq 0 and arguments.is_approval_recording_chief eq 0>
					SELECT 
						PTRC.CAU_POSITION_ID PRO_POSITION_ID,
						E.EMPLOYEE_NAME EMPLOYEE_NAME,
						E.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
						E.EMPLOYEE_EMAIL EMPLOYEE_EMAIL,
						EP.EMPLOYEE_ID EMPLOYEE_ID,
						E.MOBILCODE MOBILCODE,
						E.MOBILTEL MOBILTEL,
						EP.POSITION_CODE,
						EMPLOYEE_KEP_ADRESS,
						0 TYPE 
					FROM 
						#process_db#PROCESS_TYPE_ROWS_CAUID PTRC,
						#process_db#EMPLOYEES E,
						#process_db#EMPLOYEE_POSITIONS EP
					WHERE 
						PTRC.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"> AND
						<cfif arguments.value_workgroup_id neq 0 and arguments.is_consumer eq 0 or (arguments.is_consumer eq 1 and module_type eq 'e')>
							PTRC.WORKGROUP_ID IN (#arguments.value_workgroup_id#) AND
						</cfif>
						E.EMPLOYEE_STATUS = 1 AND
						EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
						EP.POSITION_ID = PTRC.CAU_POSITION_ID
					<cfif arguments.is_consumer eq 0 or (arguments.is_consumer eq 1 and module_type eq 'e')>
					UNION 
						SELECT 
							PTRC.CAU_POSITION_ID PRO_POSITION_ID,
							E.EMPLOYEE_NAME EMPLOYEE_NAME,
							E.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
							E.EMPLOYEE_EMAIL EMPLOYEE_EMAIL,
							EP.EMPLOYEE_ID EMPLOYEE_ID,
							E.MOBILCODE MOBILCODE,
							E.MOBILTEL MOBILTEL,
							EP.POSITION_CODE,
							EMPLOYEE_KEP_ADRESS,
							0 TYPE 
						FROM 					
							#process_db#PROCESS_TYPE_ROWS_WORKGRUOP PTRW,
							#process_db#PROCESS_TYPE_ROWS_CAUID PTRC,
							#process_db#EMPLOYEE_POSITIONS EP,
							#process_db#EMPLOYEES E
						WHERE 
							PTRW.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"> AND
							PTRW.MAINWORKGROUP_ID = PTRC.WORKGROUP_ID AND
							<cfif arguments.value_mainworkgroup_id neq 0>
							PTRW.MAINWORKGROUP_ID IN (#arguments.value_mainworkgroup_id#) AND
							</cfif>
							PTRC.WORKGROUP_ID=PTRW.MAINWORKGROUP_ID AND
							E.EMPLOYEE_STATUS = 1 AND
							EP.POSITION_ID = PTRC.CAU_POSITION_ID AND
							EP.EMPLOYEE_ID = E.EMPLOYEE_ID
					</cfif>
				<cfelse>
					SELECT
						EMPS.POSITION_ID PRO_POSITION_ID,
						EMPS.EMPLOYEE_NAME,
						EMPS.EMPLOYEE_SURNAME,
						EMPS.EMPLOYEE_EMAIL,
						EMPS.EMPLOYEE_ID EMPLOYEE_ID,
						EMP.MOBILCODE MOBILCODE,
						EMP.MOBILTEL MOBILTEL,
						EMPS.POSITION_CODE,
						EMPLOYEE_KEP_ADRESS,
						0 TYPE
					FROM #process_db#EMPLOYEE_POSITIONS AS EMPS
					JOIN #process_db#EMPLOYEES AS EMP ON EMPS.EMPLOYEE_ID = EMP.EMPLOYEE_ID
					JOIN #process_db#EMPLOYEE_POSITIONS_STANDBY AS EMPST
					<cfif ((arguments.is_confirm_first_chief eq 1) and (arguments.is_confirm_second_chief eq 1)) or ((arguments.is_confirm_first_chief_recording eq 1) and (arguments.is_confirm_second_chief_recording eq 1))>
						ON EMPST.CHIEF1_CODE = EMPS.POSITION_CODE OR EMPST.CHIEF2_CODE = EMPS.POSITION_CODE
					<cfelseif arguments.is_confirm_first_chief eq 1 or arguments.is_confirm_first_chief_recording eq 1>	
						ON EMPST.CHIEF1_CODE = EMPS.POSITION_CODE
					<cfelseif arguments.is_confirm_second_chief eq 1 or arguments.is_confirm_second_chief_recording eq 1>
						ON EMPST.CHIEF2_CODE = EMPS.POSITION_CODE
					</cfif>
					WHERE
					<cfif arguments.is_approval_chief eq 1><!--- İşlemi yapanın --->
						EMPST.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#(arguments.mandate_position_code neq 0) ? arguments.mandate_position_code : session.ep.position_code#">
					<cfelseif get_first_sender.recordcount><!--- İlk kaydı yapanın --->
						EMPST.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_first_sender.SENDER_POSITION_CODE#">
					<cfelseif isdefined("arguments.form_position_code") and len(arguments.form_position_code) and arguments.form_position_code neq 0><!--- Formdan gönderilenin --->
						EMPST.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_position_code#">
					<cfelse>
						1 = 2
					</cfif>
				</cfif>
			<cfelse>
				SELECT
					EMPS.POSITION_ID PRO_POSITION_ID,
					EMPS.EMPLOYEE_NAME,
					EMPS.EMPLOYEE_SURNAME,
					EMPS.EMPLOYEE_EMAIL,
					EMPS.EMPLOYEE_ID EMPLOYEE_ID,
					EMP.MOBILCODE MOBILCODE,
					EMP.MOBILTEL MOBILTEL,
					EMPS.POSITION_CODE,
					EMPLOYEE_KEP_ADRESS,
					0 TYPE
				FROM #process_db#EMPLOYEE_POSITIONS AS EMPS
				JOIN #process_db#EMPLOYEES AS EMP ON EMPS.EMPLOYEE_ID = EMP.EMPLOYEE_ID
				WHERE EMPS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
			</cfif>
		</cfquery>
		<cfreturn get_Cau_Position_Type>
	</cffunction>

	<cffunction name="get_first_sender" access="public" returntype="query">
		<cfargument name="process_db" type="string" required="no" default="">
		<cfargument name="data_source" type="string" required="no" default="">
		<cfargument name="action_table" type="string" required="yes" default="">
		<cfargument name="action_column" type="string" required="yes" default="">
		<cfargument name="action_id" type="string" required="yes" default="">

		<cfif not len( arguments.process_db ) and isDefined("this.process_db")>
			<cfset arguments.process_db = this.process_db>
		</cfif>

		<cfif not len( arguments.data_source ) and isDefined("this.data_source")>
			<cfset arguments.data_source = this.data_source>
		</cfif>

		<cfquery name="get_warnings_first_sender" datasource="#arguments.data_source#">
			SELECT TOP 1 SENDER_POSITION_CODE
			FROM #arguments.process_db#PAGE_WARNINGS
			WHERE 
				ACTION_TABLE = '#arguments.action_table#' 
				AND ACTION_COLUMN = '#arguments.action_column#' 
				AND ACTION_ID = '#arguments.action_id#'
				AND PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfreturn get_warnings_first_sender />
	</cffunction>

	<cffunction name="get_General_Positions" access="public" returntype="query">
		<cfquery name="get_General_Positions" dbtype="query">
			SELECT * FROM get_Inf_Position_Type UNION ALL SELECT * FROM get_Cau_Position_Type
		</cfquery>
		<cfreturn get_General_Positions>
	</cffunction>
	
	<cffunction name="get_Real_Izin" access="public" returntype="query">
		<cfargument name="process_db" type="string" required="no" default="#this.process_db#">
		<cfargument name="employee_id" type="numeric" required="no" default="0">
		<cfargument name="position_code" type="numeric" required="no" default="0">
		<cfargument name="record_date" type="date" required="no" default="">
		<cfquery name="get_Real_Izin" datasource="#this.data_source#">
			SELECT 
				EMPLOYEE_ID 
			FROM 
				#process_db#OFFTIME 
			WHERE 
				<cfif Len(arguments.employee_id) and arguments.employee_id neq 0>
					EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND
				<cfelse>
					EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM #process_db#EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">) AND
				</cfif>
				(
					( STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_date#"> AND STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_date#"> ) OR
					( STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_date#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_date#"> )
				) AND
				VALID = 1
		</cfquery>
		<cfreturn get_Real_Izin>
	</cffunction>
	
	<cffunction name="get_StandBys" access="public" returntype="query">
		<cfargument name="process_db" type="string" required="no" default="#this.process_db#">
		<cfargument name="position_code" type="numeric" required="yes" default="0">
		<cfquery name="get_StandBys" datasource="#this.data_source#">
			SELECT
				CANDIDATE_POS_1,
				CANDIDATE_POS_2,
				CANDIDATE_POS_3
			FROM
				#process_db#EMPLOYEE_POSITIONS_STANDBY
			WHERE
				POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
		</cfquery>
		<cfreturn get_StandBys>
	</cffunction>
	
	<cffunction name="get_Yedek" access="public" returntype="query">
		<cfargument name="process_db" type="string" required="no" default="#this.process_db#">
		<cfargument name="position_code" type="numeric" required="yes" default="0">
		<cfquery name="get_Yedek" datasource="#this.data_source#">
			SELECT
				EP.POSITION_ID PRO_POSITION_ID,
				E.EMPLOYEE_NAME EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
				E.EMPLOYEE_EMAIL EMPLOYEE_EMAIL,
				EP.EMPLOYEE_ID EMPLOYEE_ID,
				E.MOBILCODE MOBILCODE,
				E.MOBILTEL MOBILTEL,
				EP.POSITION_CODE
			FROM
				#process_db#EMPLOYEE_POSITIONS EP,
				#process_db#EMPLOYEES E
			WHERE
				E.EMPLOYEE_STATUS = 1 AND
				EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
		</cfquery>
		<cfreturn get_Yedek>
	</cffunction>
	
	<cffunction name="add_Wrk_Message" access="public" returntype="any">
		<cfargument name="process_db" type="string" required="no" default="#this.process_db#">
		<cfargument name="module_type" type="string" required="no" default="#this.module_type#">
		<cfargument name="employee_id" type="numeric" required="yes" default="0">
		<cfargument name="record_member" type="numeric" required="yes" default="0">
		<cfargument name="record_date" type="date" required="no" default="">
		<cfargument name="message" type="string" required="no" default="">
		<cfquery name="add_Wrk_Message" datasource="#this.data_source#">
			INSERT INTO 
				#process_db#WRK_MESSAGE
			(
				RECEIVER_ID,
				RECEIVER_TYPE,
				SENDER_ID,
				SENDER_TYPE,
				MESSAGE,
				SEND_DATE,
				ACTION_ID,
				ACTION_COLUMN,
				ACTION_PAGE,
				FUSEACTION,
				WARNING_HEAD
			)
			VALUES
			(
				#arguments.employee_id#,
				0,
				#arguments.record_member#,
				<cfif arguments.module_type eq 'e'>0<cfelseif arguments.module_type eq 'p'>1<cfelseif arguments.module_type eq 'w'>2</cfif>,
				'#arguments.message#',
				#arguments.record_date#,
				#arguments.action_id#,
				'#arguments.action_column#',
				'#arguments.action_page#',
				'#arguments.fuseaction#',
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.warning_head#">
			)
		</cfquery>
		<cfif isdefined('onesignal_appID') and len(onesignal_appID)>
			<script type="text/javascript">
				cont_message = "<cfoutput>#message#</cfoutput>";
				receiver_id = "<cfoutput>#arguments.employee_id#</cfoutput>";
				gonderen_isim =<cf_get_lang dictionary_id="52121.Workcube'de adınıza yapılmış bir Süreç Takip Kaydı bulunmaktadır!">;
				onesignal_appID = "<cfoutput>#onesignal_appID#</cfoutput>";	
				onesignal = "<cfoutput>#onesignal#</cfoutput>";
				var jsonBody = { 
						app_id: onesignal_appID,
						included_segments : "All",
						headings : {
							en: gonderen_isim
						},
						contents :{
							en: cont_message
						},
						data : {
							foo: "bar"
						},
						filters : [
							{"field": "tag", "key": "emp_id", "relation": "=", "value": receiver_id}
						]
				}; 
				var request = $.ajax({
					url: "https://onesignal.com/api/v1/notifications",
					headers: {
							'Authorization':onesignal,
							'Content-Type':'application/json'
							
						},
					type: "POST",
					data: JSON.stringify(jsonBody),
					dataType: "json",
					success: function (msg) {  
						console.log("success");
					},
					error: function (jqXHR, textStatus) 
					{
						console.log('CODE:8 please, try again..'+textStatus);
						return false; 
					}
				});
				console.log(request); 
			</script>
		</cfif>
	</cffunction>
	
	<cffunction name="get_page_warning" access="public" returntype="query">
		<cfargument name="warning_id" required="no" default="0">
		<cfargument name="action_id" required="no">
		<cfargument name="action_stage_id" required="no">
		<cfargument name="fuseact" required="no">
		<cfargument name="position_code" default="#session.ep.position_code#">

		<cfif arguments.warning_id eq 0>
			<cfset externalWoList = arguments.fuseact>
			<cfquery name="getExternalWo" datasource="#dsn#">
				SELECT EXTERNAL_FUSEACTION FROM WRK_OBJECTS WHERE FULL_FUSEACTION = <cfqueryparam value="#arguments.fuseact#" cfsqltype="cf_sql_nvarchar">
			</cfquery>
			<cfif getExternalWo.recordCount>
				<cfset externalWoList = listAppend(externalWoList,getExternalWo.EXTERNAL_FUSEACTION)>
			</cfif>
		</cfif>

		<cfquery name="get_page_warning" datasource="#this.data_source#">
			<cfif arguments.warning_id eq 0>
			SELECT
				PW.W_ID,
				PTR.CONFIRM_REQUEST,
				PW.IS_CONFIRM,
				PW.IS_CONFIRM,
				PW.IS_REFUSE,
				PW.IS_AGAIN,
				PW.IS_SUPPORT,
				PW.IS_CANCEL
			FROM 
				PAGE_WARNINGS AS PW
				LEFT JOIN PROCESS_TYPE_ROWS AS PTR ON PW.ACTION_STAGE_ID = PTR.PROCESS_ROW_ID
			WHERE	
				IS_PARENT = 1
				AND IS_ACTIVE = 1
				AND ACTION_ID = <cfqueryparam value = "#arguments.action_id#" CFSQLType = "cf_sql_integer">
				AND POSITION_CODE = <cfqueryparam value = "#arguments.position_code#" CFSQLType = "cf_sql_integer">
				AND (
					<cfif getExternalWo.recordCount>
						<cfset i = 1>
						<cfloop list="#externalWoList#" index="value">
							URL_LINK LIKE '%#value#%' <cfif listLen( externalWoList ) neq i> OR </cfif>
							<cfset i++>
						</cfloop>
					</cfif>
				)
			<cfelse>
				SELECT
					*
				FROM
					PAGE_WARNINGS AS PW
					LEFT JOIN GENERAL_PAPER AS GP ON PW.GENERAL_PAPER_ID = GP.GENERAL_PAPER_ID
				WHERE
					PW.W_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.warning_id#">
			</cfif>
		</cfquery>

		<cfreturn get_page_warning>

	</cffunction>

	<cffunction name="add_Page_Warnings" access="public" returntype="query">
		<cfargument name="process_db" type="string" required="no" default="">
		<cfargument name="module_type" type="string" required="no" default="">
		<cfargument name="data_source" type="string" required="no" default="">
		<cfargument name="action_page" type="string" required="no" default="">
		<cfargument name="warning_head" type="string" required="no" default="">
		<cfargument name="process_row_id" type="numeric" required="no" default="0">
		<cfargument name="warning_description" type="string" required="no" default="">
		<cfargument name="warning_date" type="date" required="no" default="">
		<cfargument name="record_date" type="date" required="no" default="">
		<cfargument name="record_member" type="numeric" required="no" default="0">
		<cfargument name="position_code" type="numeric" required="no" default="0">
		<cfargument name="sender_position_code" type="numeric" required="no" default="0">
		<cfargument name="position_code_cc" type="numeric" required="no" default="0">
		<cfargument name="our_company_id" type="numeric" required="no" default="0">
		<cfargument name="period_id" type="numeric" required="no" default="0">
		<cfargument name="action_table" type="string" required="no" default="">
		<cfargument name="action_column" type="string" required="no" default="">
		<cfargument name="action_id" type="numeric" required="no" default="0">
		<cfargument name="action_stage" type="numeric" required="no" default="0">
		<cfargument name="action_process_cat_id" type="numeric" required="no" default="0">
		<cfargument name="is_confirm" type="string" required="no" default="">
		<cfargument name="is_refuse" type="string" required="no" default="">
		<cfargument name="is_again" type="string" required="no" default="">
		<cfargument name="is_support" type="string" required="no" default="">
		<cfargument name="is_cancel" type="string" required="no" default="">
		<cfargument name="is_approve_all_checkers" type="string" required="no" default="">
		<cfargument name="is_confirm_first_chief" type="string" required="no" default="">
		<cfargument name="is_confirm_second_chief" type="string" required="no" default="">
		<cfargument name="is_confirm_first_chief_recording" type="string" required="no" default="">
		<cfargument name="is_confirm_second_chief_recording" type="string" required="no" default="">
		<cfargument name="is_mandate" type="numeric" required="no" default="0">
		<cfargument name="general_paper_id" type="numeric" required="no" default="0">
		<cfargument name="is_notification" type="numeric" required="no" default="0">
		<cfargument name="paper_no" type="string" required="no" default="">
		<cfargument name="comment_request" type="boolean" required="no" default="0">
		<cfargument name="checker_number" type="numeric" required="no" default="0">
		<cfargument name="is_checker_update_authority" type="boolean" required="no" default="0">
		<cfargument name="access_code" type="string" required="no" default="">
		<cfargument name="warning_password" type="string" required="no" default="">
		<cfargument name="is_confirm_comment_required" type="boolean" required="no" default="0">
		<cfargument name="is_refuse_comment_required" type="boolean" required="no" default="0">
		<cfargument name="is_again_comment_required" type="boolean" required="no" default="0">
		<cfargument name="is_support_comment_required" type="boolean" required="no" default="0">
		<cfargument name="is_cancel_comment_required" type="boolean" required="no" default="0">
		<cfargument name="is_manuel_notification" type="boolean" required="no" default="0">
		<cfargument name="parent_id" type="numeric" required="no" default="0">
		<cfargument name="wrk_log_id" type="numeric" required="no" default="0">
		
		<!--- Customtag dışından kullanımlarda this ile erişilmiyordu, arguments da yoksa this varlığı kontrol edilerek atanması sağlandı --->
		<cfif not len( arguments.process_db ) and isDefined("this.process_db")>
			<cfset arguments.process_db = this.process_db>
		</cfif>

		<cfif not len( arguments.module_type ) and isDefined("this.module_type")>
			<cfset arguments.module_type = this.module_type>
		</cfif>

		<cfif not len( arguments.data_source ) and isDefined("this.data_source")>
			<cfset arguments.data_source = this.data_source>
		</cfif>

		<cfquery name="add_Page_Warnings" datasource="#arguments.data_source#">
			INSERT INTO
				#process_db#PAGE_WARNINGS
				(
					URL_LINK,
					WARNING_HEAD,
					SETUP_WARNING_ID,
					WARNING_DESCRIPTION,
					SMS_WARNING_DATE,
					EMAIL_WARNING_DATE,
					LAST_RESPONSE_DATE,
					RECORD_DATE,
					IS_ACTIVE,
					IS_PARENT,
					RESPONSE_ID,
					RECORD_IP,
					<cfif module_type eq 'e'>RECORD_EMP<cfelseif module_type eq 'p'>RECORD_PAR<cfelseif module_type eq 'w'>RECORD_CON</cfif>,
					POSITION_CODE,
					WARNING_PROCESS,
					OUR_COMPANY_ID,
					PERIOD_ID,
					ACTION_TABLE,
					ACTION_COLUMN,
					ACTION_ID,
					ACTION_STAGE_ID,
					IS_CONFIRM,
					IS_REFUSE,
					IS_AGAIN,
					IS_SUPPORT,
					IS_CANCEL,
					IS_APPROVE_ALL_CHECKERS,
					IS_CONFIRM_FIRST_CHIEF,
					IS_CONFIRM_SECOND_CHIEF,
					IS_CONFIRM_FIRST_CHIEF_RECORDING,
					IS_CONFIRM_SECOND_CHIEF_RECORDING,
					POSITION_CODE_CC,
					SENDER_POSITION_CODE,
					GENERAL_PAPER_ID,
					IS_MANDATE,
					IS_NOTIFICATION,
					PAPER_NO,
					COMMENT_REQUEST,
					CHECKER_NUMBER,
					IS_CHECKER_UPDATE_AUTHORITY,
					ACCESS_CODE,
					WARNING_PASSWORD,
					IS_CONFIRM_COMMENT_REQUIRED,
					IS_REFUSE_COMMENT_REQUIRED,
					IS_AGAIN_COMMENT_REQUIRED,
					IS_SUPPORT_COMMENT_REQUIRED,
					IS_CANCEL_COMMENT_REQUIRED,
					IS_MANUEL_NOTIFICATION,
					WRK_LOG_ID,
					ACTION_PROCESS_CAT_ID
				)
				VALUES
				(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_page#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.warning_head#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_row_id#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(arguments.warning_description,1000)#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.warning_date#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.warning_date#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.warning_date#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_date#">,
				1,
				1,
				0,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_member#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">,
				1,
				<cfif len(arguments.our_company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.period_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#"><cfelse>NULL</cfif>,
				<cfif Len(arguments.action_table)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_table#"><cfelse>NULL</cfif>,
				<cfif Len(arguments.action_column)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_column#"><cfelse>NULL</cfif>,
				<cfif Len(arguments.action_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"><cfelse>NULL</cfif>,
				<cfif Len(arguments.action_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_stage#"><cfelse>NULL</cfif>,
				<cfif len(arguments.is_confirm)><cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.is_confirm#"><cfelse>0</cfif>,
				<cfif len(arguments.is_refuse)><cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.is_refuse#"><cfelse>0</cfif>,
				<cfif len(arguments.is_again)><cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.is_again#"><cfelse>0</cfif>,
				<cfif len(arguments.is_support)><cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.is_support#"><cfelse>0</cfif>,
				<cfif len(arguments.is_cancel)><cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.is_cancel#"><cfelse>0</cfif>,
				<cfif len(arguments.is_approve_all_checkers)><cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.is_approve_all_checkers#"><cfelse>NULL</cfif>,
				<cfif len(arguments.is_confirm_first_chief)><cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.is_confirm_first_chief#"><cfelse>NULL</cfif>,
				<cfif len(arguments.is_confirm_second_chief)><cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.is_confirm_second_chief#"><cfelse>NULL</cfif>,
				<cfif len(arguments.is_confirm_first_chief_recording)><cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.is_confirm_first_chief_recording#"><cfelse>NULL</cfif>,
				<cfif len(arguments.is_confirm_second_chief_recording)><cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.is_confirm_second_chief_recording#"><cfelse>NULL</cfif>,
				<cfif arguments.position_code_cc neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code_cc#"><cfelse>NULL</cfif>,
				<cfif arguments.sender_position_code neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sender_position_code#"><cfelse>NULL</cfif>,
				<cfif arguments.general_paper_id neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.general_paper_id#"><cfelse>NULL</cfif>,
				<cfif arguments.is_mandate neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_mandate#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_notification#">,
				<cfif len(arguments.paper_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.paper_no#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.comment_request#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.checker_number#">,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.is_checker_update_authority#">,
				<cfif len(arguments.access_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.access_code#"><cfelse>NULL</cfif>,
				<cfif len(arguments.warning_password)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.warning_password#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_confirm_comment_required#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_refuse_comment_required#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_again_comment_required#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_support_comment_required#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_cancel_comment_required#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_manuel_notification#">,
				<cfif IsDefined("arguments.wrk_log_id") and len(arguments.wrk_log_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wrk_log_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.action_process_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_process_cat_id#"><cfelse>NULL</cfif>
				)
		</cfquery>
		<cfquery name="Get_Max_Warnings" datasource="#arguments.data_source#">
			SELECT MAX(W_ID) MAX FROM #process_db#PAGE_WARNINGS
		</cfquery>
		<cfquery name="Upd_Warnings" datasource="#arguments.data_source#">
			UPDATE #process_db#PAGE_WARNINGS 
			SET PARENT_ID = <cfif arguments.parent_id eq 0>#Get_Max_Warnings.Max#<cfelse>#arguments.parent_id#</cfif> 
			WHERE W_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Max_Warnings.Max#">
		</cfquery>
		<cfreturn Get_Max_Warnings>
	</cffunction>
	
	<cffunction name="Upd_Page_Warnings" access="public" returntype="boolean">
		<cfargument name="process_db" type="string" required="no" default="">
		<cfargument name="module_type" type="string" required="no" default="">
		<cfargument name="our_company_id" type="numeric" required="no" default="0">
		<cfargument name="period_id" type="numeric" required="no" default="0">
		<cfargument name="action_table" type="string" required="no" default="">
		<cfargument name="action_column" type="string" required="no" default="">
		<cfargument name="action_id" type="numeric" required="no" default="0">
		<cfargument name="old_process_stage" type="numeric" required="no" default="0">
		<cfargument name="data_source" type="string" required="no" default="">

		<cfif not len( arguments.process_db ) and isDefined("this.process_db")>
			<cfset arguments.process_db = this.process_db>
		</cfif>

		<cfif not len( arguments.module_type ) and isDefined("this.module_type")>
			<cfset arguments.module_type = this.module_type>
		</cfif>

		<cfif not len( arguments.data_source ) and isDefined("this.data_source")>
			<cfset arguments.data_source = this.data_source>
		</cfif>

		<cfquery name="Upd_Page_Warnings" datasource="#arguments.data_source#">
			UPDATE
				#arguments.process_db#PAGE_WARNINGS
			SET
				IS_ACTIVE = 0
			WHERE
				<cfif len(arguments.our_company_id)>OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#"> AND</cfif>
				<cfif len(arguments.period_id)>PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#"> AND</cfif>
				ACTION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_table#"> AND
				ACTION_COLUMN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_column#"> AND
				ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> 
				<cfif arguments.old_process_stage neq 0> AND ACTION_STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.old_process_stage#"> </cfif>
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="upd_warnings_checker_number" access="public" returntype="boolean">
		<cfargument name="process_db" type="string" required="no" default="">
		<cfargument name="data_source" type="string" required="no" default="">
		<cfargument name="action_table" type="string" required="no" default="">
		<cfargument name="action_column" type="string" required="no" default="">
		<cfargument name="action_id" type="numeric" required="no" default="0">
		<cfargument name="process_stage" type="numeric" required="no" default="0">

		<cfif not len( arguments.process_db ) and isDefined("this.process_db")>
			<cfset arguments.process_db = this.process_db>
		</cfif>

		<cfif not len( arguments.data_source ) and isDefined("this.data_source")>
			<cfset arguments.data_source = this.data_source>
		</cfif>

		<cfquery name="upd_warnings_checker_number" datasource="#arguments.data_source#">
			UPDATE #process_db#PAGE_WARNINGS
			SET CHECKER_NUMBER = CHECKER_NUMBER + 1
			WHERE 
				ACTION_TABLE = '#arguments.action_table#' 
				AND ACTION_COLUMN = '#arguments.action_column#' 
				AND ACTION_ID = #arguments.action_id#
				AND ACTION_STAGE_ID = #arguments.process_stage#
		</cfquery>

		<cfreturn true>
	</cffunction>

	<cffunction name="add_page_warning_action" access="public" returntype="struct">

		<cfargument name="process_db" type="string" required="no" default="">
		<cfargument name="module_type" type="string" required="no" default="">
		<cfargument name="data_source" type="string" required="no" default="">
		<cfargument name="warning_id" type="numeric" required="yes">
		<cfargument name="url_link" type="string" required="yes">
		<cfargument name="warning_description" type="string" required="yes">
		<cfargument name="action_db" type="string" required="no" default="">
		<cfargument name="action_table" type="string" required="yes">
		<cfargument name="action_column" type="string" required="yes">
		<cfargument name="action_stage_column" type="string" required="yes">
		<cfargument name="action_stage_id" type="numeric" required="yes">
		<cfargument name="action_id" type="numeric" required="yes">
		<cfargument name="action_type" type="string" required="yes">
		<cfargument name="confirm_result" type="numeric" required="no" default="0">
		
		<cfif not len( arguments.process_db ) and isDefined("this.process_db")>
			<cfset arguments.process_db = this.process_db>
		</cfif>

		<cfif not len( arguments.module_type ) and isDefined("this.module_type")>
			<cfset arguments.module_type = this.module_type>
		</cfif>

		<cfif not len( arguments.data_source ) and isDefined("this.data_source")>
			<cfset arguments.data_source = this.data_source>
		</cfif>

		<cfif not len( arguments.action_db )>
			<cfset arguments.action_db = Replace( arguments.process_db, "." , "" )>
		</cfif>

		<cfset response = structNew() />
		<cftry>
			<cfquery name="add_page_warning_action" datasource="#arguments.data_source#" result="queryResult">
				INSERT INTO
					#process_db#PAGE_WARNINGS_ACTIONS
					(
						WARNING_ID,
						URL_LINK,
						WARNING_DESCRIPTION,
						ACTION_DB,
						ACTION_TABLE,
						ACTION_COLUMN,
						ACTION_STAGE_COLUMN,
						ACTION_STAGE_ID,
						ACTION_ID,
						OUR_COMPANY_ID,
						PERIOD_ID,
						IS_CONFIRM,
						IS_REFUSE,
						IS_AGAIN,
						IS_SUPPORT,
						IS_CANCEL,
						CONFIRM_POSITION_CODE,
						CONFIRM_RESULT,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.warning_id#">,
						<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.url_link#">,
						<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.warning_description#">,
						<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.action_db#">,
						<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.action_table#">,
						<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.action_column#">,
						<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.action_stage_column#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_stage_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">,
						#session.ep.company_id#,
						#session.ep.period_id#,
						<cfif arguments.action_type eq 'confirm'>1<cfelse>0</cfif>,
						<cfif arguments.action_type eq 'refuse'>1<cfelse>0</cfif>,
						<cfif arguments.action_type eq 'again'>1<cfelse>0</cfif>,
						<cfif arguments.action_type eq 'support'>1<cfelse>0</cfif>,
						<cfif arguments.action_type eq 'cancel'>1<cfelse>0</cfif>,
						#session.ep.position_code#,
						<cfif arguments.confirm_result neq 0>#arguments.confirm_result#<cfelse>NULL</cfif>,
						#now()#,
						#session.ep.userid#,
						'#cgi.remote_addr#'
					)
			</cfquery>
			<cfset response.status = true>
			<cfset response.queryResult = queryResult>
			<cfcatch>
				<cfset response.status = false>
			</cfcatch>
		</cftry>
		<cfreturn response>
	</cffunction>
	
	<cffunction name="get_Main_File" access="public" returntype="query">
		<cfargument name="process_db" type="string" required="no" default="#this.process_db#">
		<cfargument name="process_stage" type="numeric" required="yes" default="0">

		<cfquery name="get_Main_File" datasource="#this.data_source#">
			SELECT
				(SELECT PT.MAIN_FILE FROM #process_db#PROCESS_TYPE PT WHERE PT.PROCESS_ID = PTR.PROCESS_ID) MAIN_FILE,
				(SELECT PT.IS_MAIN_FILE FROM #process_db#PROCESS_TYPE PT WHERE PT.PROCESS_ID = PTR.PROCESS_ID) IS_MAIN_FILE,
				PTR.IS_ACTION
			FROM 
				#process_db#PROCESS_TYPE_ROWS PTR
			WHERE 
				PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
		</cfquery>
		<cfreturn get_Main_File>
	</cffunction>
	
	<cffunction name="changeAction" access="public" returntype="boolean">
		<cfargument name="process_db" type="string" required="no" default="">
		<cfargument name="data_source" type="string" required="no" default="">
		<cfargument name="actionTable" type="string" required="yes">
		<cfargument name="actionStageColumn" type="string" required="yes">
		<cfargument name="actionStageColumn1" type="string" required="no">
		<cfargument name="actionIdColumn" type="string" required="yes">
		<cfargument name="actionId" type="numeric" required="yes">
		<cfargument name="process_stage" type="numeric" required="yes">
		<cfargument name="termin_date" required="no" type="string">
		<cfif not len( arguments.process_db ) and isDefined("this.process_db")>
			<cfset arguments.process_db = this.process_db>
		</cfif>

		<cfif not len( arguments.data_source ) and isDefined("this.data_source")>
			<cfset arguments.data_source = this.data_source>
		</cfif>
		<cfset result = true>
		<cftry>
			<cfquery name = "changeAction" datasource = "#arguments.data_source#">
				UPDATE #process_db##actionTable# SET #actionStageColumn# = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.process_stage#">
				<cfif isdefined("arguments.actionStageColumn1") and len(arguments.actionStageColumn1) and isdefined("arguments.termin_date") and len(arguments.termin_date)>
					,#actionStageColumn1# = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.termin_date#">
				</cfif>
				WHERE #actionIdColumn# = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.actionId#">
			</cfquery>
		<cfcatch type = "any">
			<cfset result = false>
		</cfcatch>	
		</cftry>
		<cfreturn result>
	</cffunction>

	<!--- //Query --->

	<cffunction name="get_process_row_dynamic_action">
		<cfargument name="process_row_id">

		<cfquery name="query_dynamic_actions" datasource="#dsn#">
			SELECT * FROM PROCESS_TYPE_ROWS_DYNACT
			WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.process_row_id#'>
		</cfquery>

		<cfreturn query_dynamic_actions>
	</cffunction>

</cfcomponent>
