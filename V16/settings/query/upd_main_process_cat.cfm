<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<!--- <cfset df_flag = 0><!--- 20041227 devam edecek ellemeyin --->
		<cfif isdefined("attributes.is_default") and listfind('5,6,7',left(attributes.PROCESS_TYPE,1),',')>
			<cfquery name="upd_process_for_default" datasource="#dsn3#">
				UPDATE SETUP_PROCESS_CAT SET IS_DEFAULT=0
				WHERE
					PROCESS_MODULE=#attributes.MODULE_ID#
				<cfif listfind('51,54,55,59,60,61,63,591',attributes.PROCESS_TYPE,',')><!--- alis faturalari --->
					AND PROCESS_TYPE IN (51,54,55,59,60,61,63,591)
				</cfif>
				<cfif listfind('50,52,53,56,57,58,62,531',attributes.PROCESS_TYPE,',')><!--- satis faturalari --->
					AND PROCESS_TYPE IN (50,52,53,56,57,58,62,531)
				</cfif>
				<cfif listfind('73,74,75,76,77',attributes.PROCESS_TYPE,',')><!--- alis irsaliyeleri --->
					AND PROCESS_TYPE IN (73,74,75,76,77)
				</cfif>
				<cfif listfind('70,71,72,78,79',attributes.PROCESS_TYPE,',')><!--- satis irsaliyeleri --->
					AND PROCESS_TYPE IN (70,71,72,78,79)
				</cfif>
			</cfquery>
			<cfset df_flag = 1>
		</cfif> --->
		<cfquery name="upd_process_cat" datasource="#dsn#">
			UPDATE 
				SETUP_MAIN_PROCESS_CAT
			SET
				MAIN_PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PROCESS_CAT#">,
				MAIN_PROCESS_TYPE = #PROCESS_TYPE#,
				MAIN_PROCESS_MODULE = #MODULE_ID#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_EMP = #session.ep.userid#
			WHERE
				MAIN_PROCESS_CAT_ID = #attributes.process_cat_id#
		</cfquery>

		<cfquery name="DEL_PROCESS_CAT_ROWS" datasource="#dsn#">
			DELETE FROM SETUP_MAIN_PROCESS_CAT_ROWS WHERE MAIN_PROCESS_CAT_ID = #ATTRIBUTES.PROCESS_CAT_ID#
		</cfquery>
		<cfquery name="DEL_PROCESS_FUS" datasource="#dsn#">
			DELETE FROM SETUP_MAIN_PROCESS_CAT_FUSENAME WHERE MAIN_PROCESS_CAT_ID = #ATTRIBUTES.PROCESS_CAT_ID#
		</cfquery>
		
		<cfif isdefined("attributes.to_pos_codes")>
			<cfloop list="#attributes.to_pos_codes#" delimiters="," index="i">
				<cfquery name="add_process_position" datasource="#dsn#">
					INSERT INTO SETUP_MAIN_PROCESS_CAT_ROWS
						(MAIN_PROCESS_CAT_ID,MAIN_POSITION_CODE)
					VALUES
						(#ATTRIBUTES.PROCESS_CAT_ID#,#i#)
				</cfquery>
			</cfloop>
		</cfif>
        <cfloop list="#attributes.position_cats#" delimiters="," index="i">
			<cfquery name="add_process_position_cat" datasource="#dsn#">
				INSERT INTO SETUP_MAIN_PROCESS_CAT_ROWS
					(MAIN_PROCESS_CAT_ID,MAIN_POSITION_CAT_ID)
				VALUES
					(#ATTRIBUTES.PROCESS_CAT_ID#,#i#)
			</cfquery>
		</cfloop>
		<!--- module isimleri gonderiliyor. --->
		<cfif isdefined("attributes.fuse_names") and len(trim(attributes.fuse_names)) >
			<cfloop list="#attributes.fuse_names#" delimiters="," index="i">
				<cfquery name="add_fus_names" datasource="#dsn#">
					INSERT INTO SETUP_MAIN_PROCESS_CAT_FUSENAME
						(MAIN_PROCESS_CAT_ID,FUSE_NAME)
					VALUES
						(#ATTRIBUTES.PROCESS_CAT_ID#,<cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">)
				</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_upd_main_process_cat&process_cat_id=#attributes.process_cat_id#" addtoken="no"> 
