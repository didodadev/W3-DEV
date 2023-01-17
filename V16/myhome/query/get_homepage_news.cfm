<!--- Duyurular ve Taze Icerik Ortak Hale Getirildi FBS 20120807 --->
<cfquery name="GET_MY_POSITION_CAT_USER_GROUP" datasource="#DSN#" >
	SELECT POSITION_CAT_ID,USER_GROUP_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfquery name="GET_HOMEPAGE_NEWS" datasource="#DSN#" maxrows="10">
	SELECT  DISTINCT
		C.CONTENT_ID,
		C.POSITION_CAT_IDS,
		C.USER_GROUP_IDS,
		C.CONT_HEAD,
		C.RECORD_MEMBER,
		C.RECORD_DATE,
		C.CONT_SUMMARY,
        C.UPDATE_DATE,
		C.PRIORITY
	FROM 
		CONTENT C,
		CONTENT_CAT CC, 
		CONTENT_CHAPTER CCH
	WHERE 	
		<cfif isDefined("is_announcement")><!--- Duyurular --->
			IS_VIEWED = 1 AND 
		</cfif>
		C.CONTENT_STATUS = 1 AND
		C.STAGE_ID = -2 AND
		CCH.CHAPTER_ID <> 0 AND
		(
			C.EMPLOYEE_VIEW = 1 OR
			','+C.POSITION_CAT_IDS+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_my_position_cat_user_group.position_cat_id#,%">
			<cfif len(get_my_position_cat_user_group.USER_GROUP_ID)>
				OR ','+C.USER_GROUP_IDS+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_my_position_cat_user_group.user_group_id#,%">
               	OR C.USER_GROUP_IDS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" 
value="%,#get_my_position_cat_user_group.user_group_id#">
               	OR C.USER_GROUP_IDS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" 
value="#get_my_position_cat_user_group.user_group_id#,%">
			</cfif>
		) AND
		(
			(	
            	(C.VIEW_DATE_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR C.VIEW_DATE_START IS NULL) AND
				(C.VIEW_DATE_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR C.VIEW_DATE_START IS NULL)
			)
			<cfif not isDefined("is_announcement")><!--- Duyurular Degil --->
				OR (C.VIEW_DATE_START IS NULL AND C.VIEW_DATE_FINISH IS NULL)
			</cfif>
		) AND
		<cfif not isDefined("is_announcement")><!--- Duyurular Degil --->
			CAST(C.CONT_POSITION AS CHAR(6)) LIKE '%1%' AND
		</cfif>
		<!---CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">) AND--->
		C.CHAPTER_ID = CCH.CHAPTER_ID AND
		CCH.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
		C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	ORDER BY
		C.UPDATE_DATE DESC,
		C.PRIORITY ASC
</cfquery>
