<cfinclude template="get_comp_cons_cat.cfm">
<cfquery name="FORUMLIST" datasource="#DSN#">
	SELECT
		FORUMID,
		FORUMNAME,
		ADMIN_POS,
		ADMIN_CONS,
		ADMIN_PARS,
		FORUM_CONS_CATS,
		FORUM_COMP_CATS,
		FORUM_EMPS,
		DESCRIPTION,
		LAST_MSG_USERKEY,
		LAST_MSG_DATE,
		REPLY_COUNT,
		TOPIC_COUNT
	FROM
		FORUM_MAIN
	WHERE
		STATUS = 1 AND
		<cfif isdefined('attributes.forum_ids') and len(attributes.forum_ids)>
			FORUMID IN (#attributes.forum_ids#) AND 
		</cfif>
		<cfif isDefined("session.ww.userid")>
			IS_INTERNET = 1 OR
			FORUM_CONS_CATS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cons_cat.consumer_cat_id#,%">
		<cfelseif isDefined("session.pp.userid")>
			FORUM_COMP_CATS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cons_cat.companycat_id#,%">
		<cfelse>
			IS_INTERNET = 1 AND
			MYCUBE_GROUP_ID IS NULL
		</cfif>
</cfquery>
