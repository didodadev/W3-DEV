<cfif isdefined("attributes.is_view") and len(attributes.is_view)>
	<cfset list_view = '#attributes.is_view#'>
<cfelse>
	<cfset list_view = ''>
</cfif>
<cfquery name="GET_MAX_ID" datasource="#DSN#">
   SELECT MAX(DENIED_PAGE_ID) AS MAX_ID FROM COMPANY_PARTNER_DENIED
</cfquery>
<cfquery name="del_faction" datasource="#DSN#">
	DELETE FROM 
    	COMPANY_PARTNER_DENIED 
    WHERE 
    	 MENU_ID = #attributes.menu_id_# AND
		<cfif isdefined('attributes.pid') and len(attributes.pid)>
            PARTNER_ID = #attributes.pid# 
        <cfelseif isdefined('attributes.position_id_') and len(attributes.position_id_)> 
            PARTNER_POSITION_ID = #attributes.position_id_#
        <cfelse>
            COMPANY_CAT_ID = #attributes.companycat_id_#
        </cfif>
</cfquery>

<cfloop list="#list_view#" index="i">
	<cfquery name="add_partner_position_denied" datasource="#dsn#">
		INSERT INTO
		COMPANY_PARTNER_DENIED
			(
				DENIED_PAGE_ID,
				DENIED_PAGE,
				COMPANY_CAT_ID,
                PARTNER_POSITION_ID,
                PARTNER_ID,
                MENU_ID,
				IS_VIEW,
				IS_DELETE,
				IS_INSERT
			)
		VALUES
			(
				<cfif len(GET_MAX_ID.MAX_ID)>#GET_MAX_ID.MAX_ID#+1,<cfelse>1,</cfif>
				'objects2.#i#',
				<cfif len(attributes.companycat_id_)>#attributes.companycat_id_#,<cfelse>NULL,</cfif>
				<cfif len(attributes.position_id_)>#attributes.position_id_#,<cfelse>NULL,</cfif>
                <cfif len(attributes.pid)>#attributes.pid#,<cfelse>NULL,</cfif>
                #attributes.menu_id_#,
				<cfif isdefined("form.is_view") and len(form.is_view) and listfind(form.is_view,i)>1,<cfelse>0,</cfif>
				0,
				0
			)
	</cfquery>
</cfloop>
<cflocation url="#request.self#?fuseaction=settings.partner_user_denied" addtoken="no">


<!---
<cfset faction = '#FORM.modul_name#.#FORM.faction#'>

<cfquery name="GET_MAX_ID" datasource="#DSN#">
   SELECT MAX(DENIED_PAGE_ID) AS MAX_ID FROM COMPANY_PARTNER_DENIED
</cfquery>

<!---<cfoutput>#faction#</cfoutput><cfabort>--->
<cfloop list="#FORM.LIST#" index="i">
<cfif (isdefined("FORM.is_view_") and listfind(form.is_view_,#i#)) or (isdefined("FORM.is_delete_") and listfind(form.is_delete_,#i#)) or (isdefined("FORM.is_insert_") and listfind(form.is_insert_,#i#))> 
 <cfquery name="control" datasource="#dsn#">
   SELECT * FROM COMPANY_PARTNER_DENIED WHERE COMPANY_CAT_ID = #i# AND DENIED_PAGE='#faction#'
 </cfquery>
 <cfif control.RECORDCOUNT>
   <cfquery name="DEL" datasource="#DSN#">
     DELETE FROM  COMPANY_PARTNER_DENIED WHERE COMPANY_CAT_ID = #i# AND DENIED_PAGE='#faction#' AND PARTNER_ID IS NULL
   </cfquery>
 </cfif>
 
 <cfquery name="ins" datasource="#dsn#">
  INSERT INTO
    COMPANY_PARTNER_DENIED
	(
	 DENIED_PAGE_ID,
	 DENIED_PAGE,
	 COMPANY_CAT_ID,
	 IS_VIEW,
	 IS_DELETE,
	 IS_INSERT
	)
	VALUES
	(
	<cfif LEN(GET_MAX_ID.MAX_ID)>
	   #GET_MAX_ID.MAX_ID#+1,
	  <cfelse>
	  1,
	 </cfif>
	 '#faction#',
	 #i#,
	 <cfif isdefined("FORM.is_view_") and listfind(form.is_view_,#i#)>
	  1,
	  <cfelse>
	  0,
	 </cfif>
	 <cfif isdefined("FORM.is_delete_") and listfind(form.is_delete_,#i#)>
	  1,
	  <cfelse>
	  0,
	 </cfif>
	 <cfif isdefined("FORM.is_insert_") and listfind(form.is_insert_,#i#)>
	  1
	  <cfelse>
	  0
	 </cfif>
	)
 </cfquery>
 </cfif>

</cfloop>

<cfif LEN(GET_MAX_ID.MAX_ID)>
  <cfset max_id = GET_MAX_ID.MAX_ID>
<cfelse>
  <cfset max_id = 1>
</cfif>


<cflocation url="#request.self#?fuseaction=settings.upd_partner_user_denied&faction=#faction#&ID=#max_id#" addtoken="no">
<!---<cflocation url="#request.self#?fuseaction=settings.partner_user_denied" addtoken="no">--->
--->
