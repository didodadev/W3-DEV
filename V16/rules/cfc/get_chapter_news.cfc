<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction  name="get_chapter_news" access="public" returntype="query">
		<cfargument name="cont_pos_id" default="">
		<cfargument name="spot" default="">
		<cfquery name="GET_MY_POSITION_CAT_USER_GROUP" datasource="#DSN#">
			SELECT POSITION_CAT_ID,USER_GROUP_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		</cfquery>
		<cfquery name="GET_CHAPTER_NEWS" datasource="#dsn#" maxrows="10">
			SELECT 
				CCH.CONTENTCAT_ID, 
				CCH.CHAPTER,
				CC.CONTENTCAT, 
				C.CONTENT_ID,
				C.CONT_HEAD,
				C.PRIORITY,
				C.COMPANY_CAT,
				C.RECORD_MEMBER,
				C.RECORD_DATE,
				C.UPDATE_MEMBER,
				C.UPDATE_DATE,
				C.CONT_SUMMARY,
				C.CONT_POSITION,
				C.CONSUMER_CAT,
				C.COMPANY_CAT,
				C.CONTENT_PROPERTY_ID,
				C.CHAPTER_ID,
				C.SPOT
			FROM 
				CONTENT C,
				CONTENT_CAT CC, 
				CONTENT_CHAPTER CCH
			WHERE 	
				C.CHAPTER_ID = CCH.CHAPTER_ID AND	
				CCH.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
				CC.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#"> AND 
				C.STAGE_ID = -2 AND
				C.CONTENT_STATUS = 1 
				<cfif isdefined("url.contentcat_id") and len(url.contentcat_id)>AND CC.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.contentcat_id#"></cfif>
				<cfif isdefined("url.chapter_id") and len(url.chapter_id)>AND CCH.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.chapter_id#"></cfif>
				<cfif isdefined("arguments.cont_pos_id") and len(arguments.cont_pos_id)>AND CAST(C.CONT_POSITION AS CHAR(6)) LIKE '%#arguments.cont_pos_id#%'</cfif>
				AND
				(
					C.EMPLOYEE_VIEW = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> OR
					','+C.POSITION_CAT_IDS+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_my_position_cat_user_group.position_cat_id#,%">
					<cfif len(get_my_position_cat_user_group.user_group_id)>
						OR ','+C.USER_GROUP_IDS+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_my_position_cat_user_group.user_group_id#,%">
					</cfif>
				)
				<cfif isdefined("arguments.spot") and len(arguments.spot)>AND C.SPOT = 1</cfif>
			ORDER BY
				  (CASE ISNULL(C.PRIORITY,0)
				 WHEN '0' THEN '100' 
				 ELSE C.PRIORITY
				 END), 
				 C.CONTENT_ID DESC
		</cfquery>
		<cfreturn get_chapter_news>
	</cffunction>
	<cffunction  name="get_chapter_news_img" access="public" returntype="query">
		<cfargument name="content_id" default="">
		<cfquery name="GET_CHAPTER_NEWS_IMG" datasource="#dsn#" maxrows="1">
		 	SELECT 
                CONTIMAGE_SMALL
            FROM
                CONTENT_IMAGE
            WHERE
                CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_id#">
            ORDER BY 
                CONTIMAGE_ID DESC
		</cfquery>
		<cfreturn get_chapter_news_img>
	</cffunction>
	<cffunction name="get_chapter" access="public" returntype="query">
		<cfargument name="chapter_id" default="">
		<cfquery name="GET_CHAPTER" datasource="#dsn#">
			SELECT CHAPTER FROM CONTENT_CHAPTER WHERE CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.chapter_id#">
		</cfquery>
		<cfreturn get_chapter>
	</cffunction>
	<cffunction name="get_category" access="public" returntype="query">
		<cfargument name="category_id" default="">
		<cfquery name="GET_CATEGORY" datasource="#dsn#">
			SELECT CONTENTCAT FROM CONTENT_CAT WHERE CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.category_id#">
		</cfquery>
		<cfreturn get_category>
	</cffunction>
</cfcomponent>

