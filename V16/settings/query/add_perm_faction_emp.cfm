<cfloop list="#attributes.list_pos_denied#" index="i">
	<cfquery name="get_name" datasource="#dsn#">
		SELECT FUSEACTION FROM WRK_OBJECTS WHERE WRK_OBJECTS_ID=#i# ORDER BY FUSEACTION
	</cfquery>
	<cfquery name="CONTROL" datasource="#dsn#">
		SELECT 
            POSITION_CODE
           
        FROM 
            EMPLOYEE_POSITIONS_DENIED 
        WHERE 
            MODULE_ID = #attributes.module_id# AND 
			POSITION_CODE = #form.pos_code# AND 
			FUSEACTION_ID = #i#
	</cfquery>
    <cfif control.recordcount>
		<cfquery name="del" datasource="#dsn#">
			DELETE FROM EMPLOYEE_POSITIONS_DENIED WHERE MODULE_ID=#attributes.module_id# AND POSITION_CODE=#form.pos_code# AND FUSEACTION_ID=#i#
		</cfquery>
	</cfif>
	<cfset attributes.position_code = form.pos_code>
	<cfif isdefined("attributes.is_view_#i#") or isdefined("attributes.is_insert_#i#") or isdefined("attributes.is_delete_#i#")>	
		<cfquery name="GET_MODULE_NAME" datasource="#dsn#">
			SELECT MODULE_SHORT_NAME FROM MODULES WHERE MODULE_ID = #attributes.module_id#
		</cfquery>
		<cfset faction = '#get_module_name.module_short_name#.#get_name.fuseaction#'>
		
		<cfif isdefined("attributes.denied_type_#i#")>
			<cfset izin_type = 1>
		<cfelse>
			<cfset izin_type = 0>
		</cfif>
		<cfquery name="get_denied_type" datasource="#dsn#" maxrows="1">
			SELECT 
				DENIED_TYPE 
			FROM 
				EMPLOYEE_POSITIONS_DENIED
			WHERE 
				DENIED_PAGE = '#faction#'
		</cfquery>
		<cfif get_denied_type.recordcount and get_denied_type.DENIED_TYPE eq 1 and not isdefined("attributes.denied_type_#i#")>
			<script type="text/javascript">
				alert(" <cf_get_lang no ='2555.sayfası İZİN bazlı çalışmaktadır'>. <cf_get_lang no ='2556.Bu sayfaya YASAK bazlı tanımlama yapamazsınız'>!<cf_get_lang_main no ='169.Sayfa'>:<cfoutput>#faction#</cfoutput>");
			</script>
			<cfset izin_type = 1>
		<cfelseif get_denied_type.recordcount and get_denied_type.DENIED_TYPE neq 1 and isdefined("attributes.denied_type_#i#")>
			<script type="text/javascript">
				alert(" <cf_get_lang no ='2558.sayfası YASAK bazlı çalışmaktadır'>.<cf_get_lang no ='2557.Bu sayfaya İZİN bazlı tanımlama yapamazsınız'>!<cf_get_lang_main no ='169.Sayfa'>:<cfoutput>#faction#</cfoutput>");
			</script>
			<cfset izin_type = 0>
		</cfif>
		<cfquery name="ins" datasource="#dsn#">
   			INSERT INTO
				EMPLOYEE_POSITIONS_DENIED
			(
				IS_VIEW,
				IS_DELETE,
				IS_INSERT,
				DENIED_TYPE,
				POSITION_CODE,
				MODULE_ID,
				FUSEACTION_ID,
				POSITION_CAT_ID,
				DENIED_PAGE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				<cfif isdefined("attributes.is_view_#i#")>1,<cfelse>0,</cfif>
				<cfif isdefined("attributes.is_delete_#i#")>1,<cfelse>0,</cfif>
				<cfif isdefined("attributes.is_insert_#i#")>1,<cfelse>0,</cfif>
				#izin_type#,
				#form.pos_code#,
				#attributes.module_id#,
				#i#,
				NULL,
				'#faction#',
				#SESSION.EP.USERID#,
				#now()#,
				'#CGI.REMOTE_ADDR#'
			)
         </cfquery>
  </cfif>		
</cfloop>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emp_denied_pages';
</script>
