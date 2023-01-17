<cfinclude template="get_comp_cons_cat.cfm">
<cfquery name="FORUMS" datasource="#DSN#">
	SELECT
		FORUMID,
		FORUMNAME
	FROM
		FORUM_MAIN
	WHERE
		STATUS = 1 AND
		<cfif isDefined("session.ww.userid")>
			FORUM_CONS_CATS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cons_cat.consumer_cat_id#,%">
		<cfelseif isDefined("session.pp.userid")>
			FORUM_COMP_CATS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cons_cat.companycat_id#,%">
		<cfelse><!--- koşullar çok da anlamlı degil!! --->
			IS_INTERNET = 1
		</cfif>
</cfquery>	
	
