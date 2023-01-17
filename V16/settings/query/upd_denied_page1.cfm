<cfset faction = '#trim(form.modul_name)#.#trim(form.faction)#'>
<cfquery name="control" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS 
	WHERE 
	<cfif isdefined("attributes.POSITION_CAT_ID") and len(attributes.POSITION_CAT_ID)>
		POSITION_CAT_ID = #attributes.POSITION_CAT_ID#
	<cfelse>
		USER_GROUP_ID = #attributes.USER_GROUP_ID#
	</cfif> 
</cfquery>
<cfset listc = valuelist(control.POSITION_CODE)>
<cfif listlen(listc)>
	<cfquery name="del_faction" datasource="#dsn#">
		DELETE FROM EMPLOYEE_POSITIONS_DENIED WHERE DENIED_PAGE = '#faction#' AND POSITION_CODE IN (#listc#)
	</cfquery>
</cfif>
<cfquery name="get_epd" datasource="#dsn#">
   SELECT DENIED_PAGE_ID FROM EMPLOYEE_POSITIONS_DENIED WHERE DENIED_PAGE = '#faction#'
</cfquery>
<cfset attributes.int_denied_page_id = 1>
<cfif get_epd.recordcount >
	<cfset attributes.int_denied_page_id = get_epd.DENIED_PAGE_ID>
<cfelse>
	<cfquery name="GET_MAX_ID" datasource="#dsn#">
	   SELECT MAX(DENIED_PAGE_ID) AS MAX_ID FROM EMPLOYEE_POSITIONS_DENIED
	</cfquery>
	<cfif GET_MAX_ID.recordcount and len(GET_MAX_ID.MAX_ID)>
		<cfset attributes.int_denied_page_id = GET_MAX_ID.MAX_ID>
	<cfelse>
		<cfset attributes.int_denied_page_id = 1>
	</cfif>
</cfif>
<cfloop list="#form.list#" index="i">
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
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				IS_VIEW,
				IS_DELETE,
				IS_INSERT
			)
			VALUES
			(
				<cfif len(attributes.int_denied_page_id)>#attributes.int_denied_page_id#<cfelse>1</cfif>,
				'#faction#',
				#i#,
				#get_module_id(form.modul_name)#,
				<cfif isdefined("form.denied_type")>1,<cfelse>0,</cfif>
				#SESSION.EP.USERID#,
				#NOW()#,
				'#CGI.REMOTE_ADDR#',
				<cfif isdefined("form.is_view_") and listfind(form.is_view_,i)>1,<cfelse>0,</cfif>
				<cfif isdefined("form.is_delete_") and listfind(form.is_delete_,i)>1,<cfelse>0,</cfif>
				<cfif isdefined("form.is_insert_") and listfind(form.is_insert_,i)>1<cfelse>0</cfif>
			)
		</cfquery>
	</cfif>
</cfloop>
<cfif isdefined("attributes.POSITION_CAT_ID")>
	<cflocation url="#request.self#?fuseaction=settings.popup_user_denied1&iframe=1&modul_name=#attributes.modul_name#&faction=#attributes.faction#&id=#attributes.POSITION_CAT_ID#" addtoken="no">
<cfelse>
	<cflocation url="#request.self#?fuseaction=settings.popup_user_denied1&iframe=1&modul_name=#attributes.modul_name#&faction=#attributes.faction#&user_group_id=#attributes.user_group_id#" addtoken="no">
</cfif>
