<cfset faction = '#trim(form.modul_name)#.#trim(form.faction)#'>
<cfquery name="GET_EPD" datasource="#dsn#">
   SELECT DENIED_PAGE FROM EMPLOYEE_POSITIONS_DENIED WHERE DENIED_PAGE= '#faction#'
</cfquery>
<cfif GET_EPD.recordcount >
	<script type="text/javascript">
		alert("<cf_get_lang no ='2515.Seçtiğiniz Modül Hareketi için Önceden tanımlı kayıt var'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_MAX_ID" datasource="#dsn#">
   SELECT MAX(DENIED_PAGE_ID) AS MAX_ID FROM EMPLOYEE_POSITIONS_DENIED
</cfquery>
<cfloop list="#form.list#" index="i">
	<cfif (isdefined("form.is_view_") and listfind(form.is_view_,i)) or (isdefined("form.is_delete_") and listfind(form.is_delete_,i)) or (isdefined("form.is_insert_") and listfind(form.is_insert_,i))>
		<cfquery name="ins" datasource="#dsn#">
			INSERT INTO
			EMPLOYEE_POSITIONS_DENIED
			(
				DENIED_PAGE_ID,
				DENIED_PAGE,
				POSITION_CAT_ID,
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
			<cfif len(GET_MAX_ID.MAX_ID)>#Evaluate(GET_MAX_ID.MAX_ID+1)#,<cfelse>1,</cfif>
				'#faction#',
				#i#,
				#get_module_id(form.modul_name)#,
				<cfif isdefined("form.denied_type")>1,<cfelse>0,</cfif>
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
<cfloop list="#form.list_group#" index="j">
	<cfif (isdefined("form.is_view_group_") and listfind(form.is_view_group_,j)) or (isdefined("form.is_delete_group_") and listfind(form.is_delete_group_,j)) or (isdefined("form.is_insert_group_") and listfind(form.is_insert_group_,j))>
		<cfquery name="ins" datasource="#dsn#">
			INSERT INTO
			EMPLOYEE_POSITIONS_DENIED
			(
				DENIED_PAGE_ID,
				DENIED_PAGE,
				USER_GROUP_ID,
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
				<cfif len(GET_MAX_ID.MAX_ID)>#Evaluate(GET_MAX_ID.MAX_ID+1)#,<cfelse>1,</cfif>
				'#faction#',
				#j#,
				#get_module_id(form.modul_name)#,
				<cfif isdefined("form.denied_type")>1,<cfelse>0,</cfif>
				<cfif isdefined("form.is_view_group_") and listfind(form.is_view_group_,j)>1<cfelse>0</cfif>,
				<cfif isdefined("form.is_delete_group_") and listfind(form.is_delete_group_,j)>1<cfelse>0</cfif>,
				<cfif isdefined("form.is_insert_group_") and listfind(form.is_insert_group_,j)>1<cfelse>0</cfif>,
				#SESSION.EP.USERID#,
				#now()#,
				'#CGI.REMOTE_ADDR#'
			)
		</cfquery>
	</cfif>
</cfloop>
<cfif len(GET_MAX_ID.MAX_ID)>
	<cfset MAX_ID = GET_MAX_ID.MAX_ID+1>
<cfelse>
	<cfset MAX_ID = 1>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.denied_pages&event=upd&faction=#faction#&id=#MAX_ID#" addtoken="no" >
