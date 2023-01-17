<cfif isdefined("attributes.is_view") and len(attributes.is_view)>
	<cfset list_view = '#attributes.is_view#'>
<cfelse>
	<cfset list_view = ''>
</cfif>

<cfif isdefined("attributes.is_insert") and len(attributes.is_insert)>
	<cfset list_insert = '#attributes.is_insert#'>
<cfelse>
	<cfset list_insert = ''>
</cfif>

<cfif isdefined("attributes.is_delete") and len(attributes.is_delete)>
	<cfset list_delete = '#attributes.is_delete#'>
<cfelse>
	<cfset list_delete = ''>
</cfif>

<cfset list_1 = '#list_view#,#list_insert#,#list_delete#'>
<cfset list_2 = listdeleteduplicates(list_1)>
<cfquery name="GET_MAX_ID" datasource="#DSN#">
   SELECT MAX(DENIED_PAGE_ID) AS MAX_ID FROM COMPANY_PARTNER_DENIED
</cfquery>
<cfquery name="DEL_FACTION" datasource="#DSN#">
	DELETE FROM COMPANY_PARTNER_DENIED WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
</cfquery>
<cfloop list="#list_2#" index="i">
	<cfquery name="ADD_PARTNER_DENIED" datasource="#DSN#">
		INSERT INTO
			COMPANY_PARTNER_DENIED
			(
				DENIED_PAGE_ID,
				DENIED_PAGE,
				MENU_ID,
				PARTNER_ID,
				IS_VIEW,
				IS_DELETE,
				IS_INSERT
			)
			VALUES
			(
				<cfif len(GET_MAX_ID.MAX_ID)>#GET_MAX_ID.MAX_ID#+1,<cfelse>1,</cfif>
				'objects2.#i#',
				#attributes.menu_id#,
				#attributes.pid#,
				<cfif isdefined("form.is_view") and len(form.is_view) and listfind(form.is_view,i)>1,<cfelse>0,</cfif>
				<cfif isdefined("form.is_delete") and len(form.is_delete) and listfind(form.is_delete,i)>1,<cfelse>0,</cfif>
				<cfif isdefined("form.is_insert") and len(form.is_insert) and listfind(form.is_insert,i)>1<cfelse>0</cfif>
			)
	</cfquery>
</cfloop>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		self.close();
	<cfelseif isdefined("attributes.draggable")>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
</script>

