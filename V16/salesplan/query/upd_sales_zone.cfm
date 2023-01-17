<cfquery name="GET_SALES_ZONES" datasource="#DSN#">
	SELECT
		SZ_NAME,
		OZEL_KOD
	FROM
		SALES_ZONES
	WHERE
		SZ_ID <> #attributes.sz_id# AND
		(SZ_NAME = '#attributes.sz_name#' <cfif len(attributes.ozel_kod)>OR OZEL_KOD = '#attributes.ozel_kod#'</cfif>)
</cfquery>
<cfif get_sales_zones.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='192.Bu Bölge Adına veya Özel Koda Ait Kayıt Vardır Lütfen Kontrol Ediniz'>!");
		history.back();
  	</script>
	<cfabort>
</cfif>

<cfset main_sz_id = listlast(attributes.sz_hierarchy, ',')>
<cfset main_sz_hierarchy = listfirst(attributes.sz_hierarchy, ',')>
<cfquery name="ADD_SALES_ZONE" datasource="#DSN#"> 
	UPDATE
		SALES_ZONES
	SET
		<cfif isDefined("SZ_DETAIL")>SZ_DETAIL = '#SZ_DETAIL#',<cfelse>SZ_DETAIL = NULL,</cfif>
		<cfif len(KEY_ACCOUNT_ID) and len(KEY_ACCOUNT)>KEY_ACCOUNT_ID = #KEY_ACCOUNT_ID#,<cfelse>KEY_ACCOUNT_ID = NULL,</cfif>
		<cfif (RESPONSIBLE_BRANCH_ID neq 0) and len(RESPONSIBLE_BRANCH)>RESPONSIBLE_BRANCH_ID = #RESPONSIBLE_BRANCH_ID#,<cfelse>RESPONSIBLE_BRANCH_ID = NULL,</cfif>
		<cfif len(RESPONSIBLE_POSITION_CODE)>RESPONSIBLE_POSITION_CODE = #RESPONSIBLE_POSITION_CODE#,<cfelse>RESPONSIBLE_POSITION_CODE = NULL,</cfif>
		<cfif isDefined("RESPONSIBLE_PAR_ID") and len(RESPONSIBLE_PAR_ID) and len(RESPONSIBLE_PAR)>RESPONSIBLE_PAR_ID = #RESPONSIBLE_PAR_ID#,<cfelse>RESPONSIBLE_PAR_ID = NULL,</cfif>
		<cfif len(RESPONSIBLE_COMPANY_ID) and len(RESPONSIBLE_COMPANY)>RESPONSIBLE_COMPANY_ID = #RESPONSIBLE_COMPANY_ID#,<cfelse>RESPONSIBLE_COMPANY_ID = NULL,</cfif>
		SZ_NAME = '#SZ_NAME#',
		SZ_HIERARCHY = '#main_sz_hierarchy#.#SZ_ID#',
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #SESSION.EP.USERID#,
		OZEL_KOD = '#ATTRIBUTES.OZEL_KOD#',
		<cfif isdefined('attributes.is_active')>IS_ACTIVE=1<cfelse>IS_ACTIVE=0</cfif>
	WHERE
		SZ_ID = #attributes.SZ_ID#
</cfquery> 
<cfset start = len(OLD_HIERARCHY)+2>
<cfquery name="UPD_SUB_HIERARCHIES" datasource="#dsn#">
	UPDATE
		SALES_ZONES
	SET
	<Cfif Database_Type IS 'MSSQL'>
		SZ_HIERARCHY = '#main_sz_hierarchy#.#SZ_ID#.' + SUBSTRING(SZ_HIERARCHY, #START#, len(SZ_HIERARCHY)- #START# + 1 )
	<Cfelseif Database_Type IS 'DB2'>
		SZ_HIERARCHY = '#main_sz_hierarchy#.#SZ_ID#.' || SUBSTR(SZ_HIERARCHY, #START#, LENGTH(SZ_HIERARCHY)- #START# + 1 )
	</Cfif>
	WHERE
		SZ_HIERARCHY LIKE '#OLD_HIERARCHY#.%'
</cfquery>
<cfquery name="DEL_HIERARCHY" datasource="#dsn#">
	DELETE FROM SALES_ZONES_HIERARCHY WHERE SUB_SZ_ID = #attributes.SZ_ID#
</cfquery>
<cfif main_sz_hierarchy neq 0>
	<cfset search_sz_ids = main_sz_hierarchy>
	<cfloop from="1" to="#listlen(main_sz_hierarchy, '.')#" index="i">
		<cfquery name="GET_SZ_ID" datasource="#dsn#">
			SELECT SZ_ID FROM SALES_ZONES WHERE SZ_HIERARCHY = '#search_sz_ids#'
		</cfquery>
		<cfif get_sz_id.recordcount>
			<cfquery name="ADD_HIERARCHY" datasource="#dsn#">
				INSERT
				INTO
					SALES_ZONES_HIERARCHY						
					(
						MAIN_SZ_ID,
						SUB_SZ_ID
					)
					VALUES
					(
						#get_sz_id.sz_id#,
						#attributes.SZ_ID#
					)
			</cfquery>
		</cfif>
		<cfset search_sz_ids = listdeleteat(search_sz_ids,((listlen(main_sz_hierarchy, '.')+1)-i), '.')>
	</cfloop>
</cfif>
<cfset attributes.actionId = attributes.sz_id>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=salesplan.list_plan&event=upd&sz_id=#attributes.sz_id#</cfoutput>";
</script>
