<cfset faction = '#FORM.modul_name#.#FORM.faction#'>
<cfquery name="del_faction" datasource="#DSN#">
  DELETE FROM COMPANY_PARTNER_DENIED WHERE DENIED_PAGE = '#faction#' AND COMPANY_CAT_ID IS NOT NULL
</cfquery>
<cfquery name="GET_MAX_ID" datasource="#DSN#">
   SELECT MAX(DENIED_PAGE_ID) AS MAX_ID FROM COMPANY_PARTNER_DENIED
</cfquery>
<cfloop list="#FORM.LIST#" index="i">
<cfif (isdefined("FORM.is_view_") and listfind(form.is_view_,#i#)) or (isdefined("FORM.is_delete_") and listfind(form.is_delete_,#i#)) or (isdefined("FORM.is_insert_") and listfind(form.is_insert_,#i#))>
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
<cflocation url="#request.self#?fuseaction=settings.upd_partner_user_denied&faction=#faction#" addtoken="no">
