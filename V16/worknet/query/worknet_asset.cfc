<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn1 = '#dsn#_product'>
	<cfset dsn1_alias= '#dsn1#'>
	<cfset dsn_alias= '#dsn#'>
	
	<cfscript>
		if (isDefined('session.ep.userid') and len(session.ep.language)) lang=ucase(session.ep.language);
		else if (isDefined('session.ww.language') and len(session.ww.language)) lang=ucase(session.ww.language);
		else if (isDefined('session.pp.userid') and len(session.pp.language)) lang=ucase(session.pp.language);
		else if (isDefined('session.pda.userid') and len(session.pda.language)) lang=ucase(session.pda.language);
		else if (isDefined('session.wp') and len(session.wp.language)) lang=ucase(session.wp.language);
	</cfscript>
	
	<!--- ADD ASSET --->
	<cffunction name="addAsset" access="public" returntype="any">
		<cfargument name="action_id" type="numeric" required="yes">
		<cfargument name="action_section" type="string" required="no">
		<cfargument name="asset_cat_id" type="string" required="no">
		<cfargument name="module" type="string" required="no" default="Worknet">
		<cfargument name="module_id" type="string" required="no" default="37">
		<cfargument name="file_name" type="string" required="no" default="">
		<cfargument name="file_real_name" type="string" required="no" default="">
		<cfargument name="asset_name" type="string" required="no" default="">
		<cfargument name="detail" type="string" required="no" default="">
		<cfargument name="property_id" type="string" required="no" default="">
		
		
		<cfquery name="add_asset_file" datasource="#dsn#">
			INSERT INTO
				ASSET
				(
					MODULE_NAME,
					MODULE_ID,
					ACTION_SECTION,
					ACTION_ID,
					COMPANY_ID,
					ASSETCAT_ID,
					ASSET_FILE_NAME,
					ASSET_FILE_REAL_NAME,
					ASSET_FILE_SERVER_ID,
					ASSET_NAME,
					ASSET_DETAIL,
					PROPERTY_ID,
					IS_SPECIAL,
					IS_INTERNET,
					ASSET_STAGE,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_PAR,
					RECORD_IP,
					SERVER_NAME
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.module#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module_id#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_section#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">,
					<cfif isdefined('session.ep.userid')>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
					<cfelseif  isdefined('session.pp.userid')>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.wp.our_company_id#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_cat_id#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.file_name#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.file_real_name#">,
                    <cfif isdefined('fusebox.server_machine') and len(fusebox.server_machine)><cfqueryparam cfsqltype="cf_sql_integer" value="#fusebox.server_machine#"><cfelse>NULL</cfif>,				
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.asset_name#">,
					<cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(arguments.detail,200)#"><cfelse>NULL</cfif>,
					<cfif len(arguments.property_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.property_id#"><cfelse>NULL</cfif>,
					0,
					1,
					(SELECT TOP 1 PTR.PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS PTR,PROCESS_TYPE PT WHERE PT.PROCESS_ID = PTR.PROCESS_ID AND PT.FACTION LIKE '%asset.list_asset%'),
					#now()#,
					<cfif isdefined('session.ep.userid')><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><cfelse>NULL</cfif>,
					<cfif isdefined('session.pp.userid')><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"><cfelse>NULL</cfif>,
					<cfif len(CGI.REMOTE_ADDR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#"><cfelse>NULL</cfif>,
					<cfif len(UCASE(server_name))><cfqueryparam cfsqltype="cf_sql_varchar" value="#UCASE(server_name)#"><cfelse>NULL</cfif>
				)
		</cfquery>
	</cffunction>
	<!--- UPD ASSET --->
	<cffunction name="updAsset" access="public" returntype="any">
		<cfargument name="asset_id" type="numeric" required="yes">
		<cfargument name="action_id" type="numeric" required="yes">
		<cfargument name="action_section" type="string" required="no">
		<cfargument name="asset_cat_id" type="string" required="no">
		<cfargument name="module" type="string" required="no" default="Worknet">
		<cfargument name="module_id" type="string" required="no" default="37">
		<cfargument name="file_name" type="string" required="no">
		<cfargument name="file_real_name" type="string" required="no">
		<cfargument name="asset_name" type="string" required="no">
		<cfargument name="detail" type="string" required="no">
		<cfargument name="property_id" type="string" required="no">
		
		<cfquery name="upd_asset_file" datasource="#dsn#">
			UPDATE
				ASSET
			SET
				<cfif arguments.file_name neq ''>
					ASSET_FILE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.file_name#">,
					ASSET_FILE_REAL_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.file_real_name#">,
					<cfif isdefined('fusebox.server_machine')>ASSET_FILE_SERVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#fusebox.server_machine#">,</cfif>
				</cfif>
				ASSET_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.asset_name#">,
				ASSET_DETAIL = <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(arguments.detail,200)#"><cfelse>NULL</cfif>,
				PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.property_id#">,
				UPDATE_DATE = #now()#,
				<cfif isdefined('session.ep.userid')>UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,</cfif>
				<cfif isdefined('session.pp.userid')>UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">,</cfif>
				<cfif len(CGI.REMOTE_ADDR)>UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,</cfif>
				<cfif len(ucase(server_name))>SERVER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCASE(server_name)#"></cfif>
			WHERE
				ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_id#">
		</cfquery>
	</cffunction>
	<!--- DEL ASSET --->
	<cffunction name="delAsset" access="public" returntype="any">
		<cfargument name="asset_id" type="numeric" required="yes">
		<cfquery name="del_asset_file" datasource="#dsn#">
			DELETE FROM ASSET WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_id#">
		</cfquery>
	</cffunction>
	<!--- Get Asset --->
	<cffunction name="getRelationAsset" access="public" returntype="query">
		<cfargument name="asset_id" type="numeric" required="yes" default="0">
		<cfargument name="action_id" type="numeric" required="yes" default="0">
		<cfargument name="action_section" type="string" required="no" default="">
		<cfargument name="asset_cat_id" type="string" required="no" default="0">
		<cfargument name="module" type="string" required="no" default="Worknet">
		<cfargument name="module_id" type="string" required="no" default="37">
        <cfargument name="is_internet" type="numeric" required="no" default="1">
		
		<cfquery name="GET_RELATION_ASSET" datasource="#DSN#">
			SELECT 
				A.ASSET_ID,
				A.ASSET_FILE_NAME,
				A.ASSET_FILE_SERVER_ID,
				A.ASSET_NAME,
				A.ASSET_DETAIL,
				A.ASSET_DESCRIPTION,
				A.PROPERTY_ID,
				A.ASSETCAT_ID,
				A.RECORD_EMP,
				A.RECORD_PAR,
				AC.ASSETCAT_PATH,
				CP.NAME AS PROPERTY_NAME
			FROM 
				ASSET A
				LEFT JOIN ASSET_CAT AC ON A.ASSETCAT_ID = AC.ASSETCAT_ID
				LEFT JOIN CONTENT_PROPERTY CP ON A.PROPERTY_ID = CP.CONTENT_PROPERTY_ID
			WHERE
				A.IS_INTERNET = #arguments.is_internet# AND 
                A.MODULE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.module#"> AND
				A.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module_id#">
				<cfif len(arguments.asset_cat_id) and arguments.asset_cat_id neq 0>
					AND A.ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_cat_id#">
				</cfif>
				<cfif len(arguments.asset_id) and arguments.asset_id neq 0>
					AND A.ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_id#">
				</cfif>
				<cfif len(arguments.action_id) and arguments.action_id neq 0>
					AND A.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
				</cfif>
				<cfif len(arguments.action_section)>
					AND A.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_section#">
				</cfif>
			ORDER BY 
				A.ASSET_NAME
		</cfquery>
		<cfreturn GET_RELATION_ASSET>
	</cffunction>
	<!--- Get Asset Property --->
	<cffunction name="getAssetProperty" access="public" returntype="query">
		<cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
			SELECT 
				CONTENT_PROPERTY_ID, 
				#dsn_alias#.Get_Dynamic_Language(CONTENT_PROPERTY_ID,'#lang#','CONTENT_PROPERTY','NAME',NULL,NULL,NAME) AS NAME
			FROM 
				CONTENT_PROPERTY 
			ORDER BY 
				NAME
		</cfquery>
		<cfreturn GET_CONTENT_PROPERTY>
	</cffunction>
	<!--- Get Asset Folder --->
	<cffunction name="getAssetFolder" access="public" returntype="query">
		<cfargument name="asset_cat_id" type="string" required="yes">
		<cfquery name="GET_UPLOAD_FOLDER" datasource="#DSN#">
			SELECT ASSETCAT_ID,ASSETCAT_PATH FROM ASSET_CAT WHERE ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_cat_id#">
		</cfquery>
		<cfreturn GET_UPLOAD_FOLDER>
	</cffunction>
</cfcomponent>
