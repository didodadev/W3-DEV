<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="add_main_process_cat" datasource="#dsn#" result="MAX_ID">
			INSERT INTO 
				SETUP_MAIN_PROCESS_CAT
			(
				MAIN_PROCESS_CAT,
				MAIN_PROCESS_TYPE,
				MAIN_PROCESS_MODULE,				
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PROCESS_CAT#">,
				#attributes.PROCESS_TYPE_ID#,
				#attributes.MODULE_ID#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				#session.ep.userid#
			)	
		</cfquery>
		<!--- positions --->
		<cfif isdefined("attributes.to_pos_codes")>
		<cfloop list="#attributes.to_pos_codes#" delimiters="," index="i">
			<cfquery name="add_process_position" datasource="#dsn#">
				INSERT INTO 
					SETUP_MAIN_PROCESS_CAT_ROWS
					(MAIN_PROCESS_CAT_ID,MAIN_POSITION_CODE)
				VALUES
					(#MAX_ID.IDENTITYCOL#,#i#)
			</cfquery>
		</cfloop>
		</cfif>
		<cfif isdefined("attributes.position_cats")>
			<cfloop list="#attributes.position_cats#" delimiters="," index="i">
				<cfquery name="add_process_position_cat" datasource="#dsn#">
					INSERT INTO SETUP_MAIN_PROCESS_CAT_ROWS
						(MAIN_PROCESS_CAT_ID,MAIN_POSITION_CAT_ID)
					VALUES
						(#MAX_ID.IDENTITYCOL#,#i#)
				</cfquery>
			</cfloop>
		</cfif>
		<!--- module isimleri gonderiliyor. --->
		<cfif isdefined("attributes.fuse_names") and len(trim(attributes.fuse_names)) >
			<cfloop list="#attributes.fuse_names#" delimiters="," index="i">
				<cfquery name="add_fus_names" datasource="#dsn#">
					INSERT INTO SETUP_MAIN_PROCESS_CAT_FUSENAME
						(MAIN_PROCESS_CAT_ID,FUSE_NAME)
					VALUES
						(#MAX_ID.IDENTITYCOL#,<cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">)
				</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>

<cflocation url="#request.self#?fuseaction=settings.form_upd_main_process_cat&process_cat_id=#MAX_ID.IDENTITYCOL#" addtoken="no">
