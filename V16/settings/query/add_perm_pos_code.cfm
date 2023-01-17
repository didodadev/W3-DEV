<cfset faction = '#trim(form.modul_name)#.#trim(form.faction)#'>
<cfquery name="GET_MAX_ID" datasource="#DSN#">
   SELECT MAX(DENIED_PAGE_ID) AS MAX_ID FROM EMPLOYEE_POSITIONS_DENIED
</cfquery>
<cfif isdefined("form.list")>
	<cfloop list="#form.list#" index="i"> 
		<cfquery name="del_faction" datasource="#DSN#">
			DELETE FROM EMPLOYEE_POSITIONS_DENIED WHERE DENIED_PAGE='#faction#' AND POSITION_CODE=#i# AND (POSITION_CAT_ID IS NULL AND USER_GROUP_ID IS NULL)
		</cfquery>
		<cfif (isdefined("form.is_view_") and listfind(form.is_view_,i)) or (isdefined("form.is_delete_") and listfind(form.is_delete_,i)) or (isdefined("form.is_insert_") and listfind(form.is_insert_,i))>
			<cfquery name="ins" datasource="#dsn#">
				INSERT INTO
				EMPLOYEE_POSITIONS_DENIED
				(
					DENIED_PAGE_ID,
					DENIED_PAGE,
					POSITION_CODE,
					MODULE_ID,
					DENIED_TYPE,
					IS_VIEW,
					IS_DELETE,
					IS_INSERT,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
				)
				VALUES
				(
					<cfif len(GET_MAX_ID.MAX_ID)>#GET_MAX_ID.MAX_ID#+1,<cfelse>1,</cfif>
					'#faction#',
					#i#,
					#get_module_id(form.modul_name)#,
					<cfif isdefined("form.denied_type")>1<cfelse>0</cfif>,
					<cfif isdefined("form.is_view_") and listfind(form.is_view_,i)>1<cfelse>0</cfif>,
					<cfif isdefined("form.is_delete_") and listfind(form.is_delete_,i)>1<cfelse>0</cfif>,
					<cfif isdefined("form.is_insert_") and listfind(form.is_insert_,i)>1<cfelse>0</cfif>,
                    #SESSION.EP.USERID#,
                    #now()#,
                    '#CGI.REMOTE_ADDR#'
				)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<script type="text/javascript">
	history.back();
</script>

