<cfcomponent>
	<cfinclude template="../../fbx_workcube_param.cfm">
	
	<cfset dsn1 = '#dsn#_product'>
	<cfif isdefined('session.ep')>
		<cfset dsn3 = '#dsn#_#session.ep.COMPANY_ID#'>
	<cfelseif  isdefined('session.pp')>
		<cfset dsn3 = '#dsn#_#session.pp.OUR_COMPANY_ID#'>
	<cfelseif isdefined('session.ww')>
		<cfset dsn3 = '#dsn#_#session.ww.OUR_COMPANY_ID#'>
	<cfelseif isdefined('session.wp')>
		<cfset dsn3 = '#dsn#_#session.wp.OUR_COMPANY_ID#'>
	</cfif>
	<cfset dsn3_alias= '#dsn3#'>
	<cfset dsn1_alias= '#dsn1#'>
	<cfset dsn_alias= '#dsn#'>
	
	<cfscript>
		if (isDefined('session.ep.userid')) 
		{
			lang=ucase(session.ep.language);
			timeZone=session.ep.time_zone;
		}
		else if (isDefined('session.ww')) 
		{
			lang=ucase(session.ww.language);
			timeZone=session.ww.time_zone;
		}
		else if (isDefined('session.pp.userid')) 
		{
			lang=ucase(session.pp.language);
			timeZone=session.pp.time_zone;
		}
		else if (isDefined('session.wp')) 
		{
			lang=ucase(session.wp.language);
			timeZone=session.wp.time_zone;
		}
		
		function ListDeleteDuplicates(list) {
			var i = 1;
			var delimiter = ',';
			var returnValue = '';
			if(ArrayLen(arguments) gte 2)
				delimiter = arguments[2];
			list = ListToArray(list, delimiter);
			for(i = 1; i lte ArrayLen(list); i = i + 1)
				if(not ListFind(returnValue, list[i], delimiter))
					returnValue = ListAppend(returnValue, list[i], delimiter);
			return returnValue;
		}
	</cfscript>
	
	<!--- video --->
	<cffunction name="getVideos" access="public" returntype="any">
		<cfargument name="asset_id" type="string" required="no" default="">
		<cfargument name="asset_catid" type="string" required="no" default="">
		<cfargument name="notassetid" type="numeric" required="no" default="0">
		<cfargument name="recordCount" type="string" required="no" default="">
		<cfargument name="keyword" type="string" required="no" default="">
		<cfargument name="sortdir" type="string" required="no" default="DESC">
		<cfargument name="sortfield" type="string" required="no" default="ASSET_NO ASC,ASSET.UPDATE_DATE">
		
		<cfquery name="GET_ASSET_VIDEOS" datasource="#DSN#">
			SELECT
				<cfif len(arguments.recordCount)>TOP #arguments.recordCount#</cfif>
				ASSET.MODULE_NAME,
				ASSET.ASSET_ID,
				ASSET.ASSET_NAME,
				ASSET.ASSET_DESCRIPTION,
				ASSET.ASSET_DETAIL,
				ASSET.ASSET_FILE_NAME,
				ASSET.ASSET_FILE_PATH_NAME,
				ASSET.ASSET_FILE_SERVER_ID,
				ASSET_CAT.ASSETCAT,
				ASSET_CAT.ASSETCAT_PATH,
				ASSET.ASSETCAT_ID,
				ASSET.RECORD_DATE,
				ASSET_SITE_DOMAIN.SITE_DOMAIN,
				CASE WHEN (ASSET.ASSET_NO IS NULL OR ASSET.ASSET_NO LIKE '%DJ%' OR ASSET.ASSET_NO = '') THEN 1000000 ELSE ASSET.ASSET_NO END AS ASSET_NO
			FROM 
				ASSET
				RIGHT JOIN ASSET_CAT ON ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID
				LEFT JOIN  ASSET_SITE_DOMAIN ON ASSET_SITE_DOMAIN.ASSET_ID = ASSET.ASSET_ID
			WHERE
				ASSET.IS_ACTIVE = 1 AND
				ASSET.IS_INTERNET = 1 AND
				ASSET.ASSET_FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.flv%">
				<cfif len(arguments.asset_id)>
					AND ASSET.ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_id#">
				</cfif>
				<cfif len(arguments.asset_catid)>
					AND ASSET.ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_catid#">
				</cfif>
				<cfif len(arguments.keyword)>
                	AND (ASSET.ASSET_NAME LIKE '%#arguments.keyword#%' OR ASSET.ASSET_DESCRIPTION LIKE '%#arguments.keyword#%')
                </cfif>
				<cfif arguments.notassetid neq 0>
					AND ASSET.ASSET_ID <> #arguments.notassetid#
				</cfif>
			ORDER BY
				#arguments.sortfield# #arguments.sortdir#
		</cfquery>
		
		<cfreturn GET_ASSET_VIDEOS>
	</cffunction>
	<!--- content list --->
	<cffunction name="getContents" access="public" returntype="any">
		<cfargument name="content_id" type="string" required="no" default="">
		<cfargument name="content_cat_id" type="string" required="no" default="">
		<cfargument name="content_chapter_id" type="string" required="no" default="">
		<cfargument name="content_type_id" type="string" required="no" default="">
		
		<cfargument name="recordCount" type="string" required="no" default="">
		<cfargument name="dateCheck" type="string" required="no" default="0">
		<cfargument name="isHomePage" type="string" required="no" default="0" hint="Anasayfada gosterilen icerikler gelir">
		
		<cfargument name="sortdir" type="string" required="no" default="DESC">
		<cfargument name="sortfield" type="string" required="no" default="PRIORITY ASC,C.UPDATE_DATE">
        <cfargument name="writing_date_check" type="string" required="no" default="">
		
		<cfquery name="GET_CONTENT_LIST" datasource="#DSN#">
			SELECT DISTINCT
				<cfif len(arguments.recordCount)>TOP #arguments.recordCount#</cfif>
				C.CONTENT_ID,
				C.CONT_HEAD,
				C.CONT_BODY,
				C.USER_FRIENDLY_URL,
				C.CONT_SUMMARY,
				C.RECORD_DATE,
				C.UPDATE_DATE,
				CASE WHEN (C.PRIORITY = 0) THEN 1000 ELSE C.PRIORITY END AS PRIORITY,
				C.HIT,
				C.HIT_EMPLOYEE,
				C.HIT_PARTNER,
				C.HIT_GUEST,
                C.WRITING_DATE,
                CCAT.CONTENTCAT_ID
			FROM 
				CONTENT AS C 
				LEFT JOIN CONTENT_CHAPTER AS CC ON C.CHAPTER_ID = CC.CHAPTER_ID 
				LEFT JOIN CONTENT_CAT AS CCAT ON CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID
                LEFT JOIN CONTENT_CAT_COMPANY CCC ON CCAT.CONTENTCAT_ID = CCC.CONTENTCAT_ID
			WHERE
				C.INTERNET_VIEW = 1 AND
				C.STAGE_ID = -2 AND	 
				C.CONTENT_STATUS = 1 AND
				<cfif len(arguments.content_id)>
					C.CONTENT_ID IN (#arguments.content_id#) AND
				</cfif>
				<cfif len(arguments.content_cat_id)>
					CC.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_cat_id#"> AND
				</cfif>
				<cfif len(arguments.content_chapter_id)>
					CC.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_chapter_id#"> AND
				</cfif>
				<cfif len(arguments.content_type_id)>
					C.CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_type_id#"> AND
				</cfif>
				<cfif arguments.dateCheck eq 1>
					C.VIEW_DATE_FINISH >= #now()# AND
				</cfif>
				<cfif arguments.isHomePage eq 1>
					C.CONT_POSITION = 1 AND
				</cfif>
				<cfif len(writing_date_check)>
                   year(WRITING_DATE) = #writing_date_check# AND
                </cfif>
				<cfif isdefined("session.pp.company_category")>
					C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
					CCC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
				<cfelseif isdefined("session.ww.consumer_category")>
					C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
					CCC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
				<cfelse>
					C.LANGUAGE_ID = '#session.wp.language#'
				</cfif>
			ORDER BY 
				#arguments.sortfield# #arguments.sortdir#
		</cfquery>
		
		<cfif len(arguments.content_id)>
			<cfoutput query="GET_CONTENT_LIST">
				<cfif isdefined("session.ww.userid") and len(GET_CONTENT_LIST.hit)>
				  <cfset hit_ = GET_CONTENT_LIST.hit + 1>
				<cfelse>
				  <cfset hit_ = 1>
				</cfif>
				<cfif isdefined("session.pp") and len(GET_CONTENT_LIST.hit_partner)>
				  <cfset hit_partner_ = GET_CONTENT_LIST.hit_partner + 1>
				<cfelse>
				  <cfset hit_partner_ = 1>
				</cfif>
				<cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and len(GET_CONTENT_LIST.hit_guest)>
				  <cfset hit_guest_ = GET_CONTENT_LIST.hit_guest + 1>
				<cfelse>
				  <cfset hit_guest_ = 1>
				</cfif>
				<cfquery name="HIT_UPDATE" datasource="#DSN#">
					UPDATE
						CONTENT
					SET
						<cfif isdefined("session.ww")>HIT = #hit_#,</cfif>
						<cfif isdefined("session.pp")>HIT_PARTNER = #hit_partner_#,</cfif>
						<cfif  not isdefined("session.pp") and not isdefined("session.ww.userid")>HIT_GUEST = #hit_guest_#,</cfif>
						LASTVISIT = #now()#
					WHERE
						CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CONTENT_LIST.content_id#">
				</cfquery>
			</cfoutput>
		</cfif>
		
		<cfreturn GET_CONTENT_LIST>
	</cffunction>
	<!--- content detail --->
	<cffunction name="getContent" access="public" returntype="any">
		<cfargument name="content_id" type="string" required="no" default="">
		<cfargument name="content_body_view" type="numeric" required="no" default="1">
		<cfargument name="content_head_view" type="numeric" required="no" default="0">
		<cfargument name="content_summary_view" type="numeric" required="no" default="0">
		
		<cfquery name="GET_CONTENT" datasource="#DSN#" maxrows="1">
			SELECT 
				C.CONTENT_ID,
				C.CONT_HEAD,
				C.CONT_BODY,
				C.USER_FRIENDLY_URL,
				C.CONT_SUMMARY,
				C.HIT,
				C.HIT_EMPLOYEE,
				C.HIT_PARTNER,
				C.HIT_GUEST,
                C.WRITING_DATE
			FROM 
				CONTENT AS C 
				LEFT JOIN CONTENT_CHAPTER AS CC ON C.CHAPTER_ID = CC.CHAPTER_ID 
				LEFT JOIN CONTENT_CAT AS CCAT ON CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID
			WHERE
				C.STAGE_ID = -2 AND	 
				C.CONTENT_STATUS = 1 AND
				C.CONTENT_ID IN (#arguments.content_id#) AND 
				<cfif isdefined("session.pp.userid")>
					C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
				<cfelseif isdefined("session.ww.userid")>
					C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
				<cfelse>
					C.LANGUAGE_ID = '#session.wp.language#' AND
				</cfif>
				INTERNET_VIEW = 1
		</cfquery>
		<cfsavecontent variable="contentDetail">
			<cfoutput>
				<cfif arguments.content_head_view eq 1> 
					#GET_CONTENT.CONT_HEAD#
				</cfif>
				<cfif arguments.content_summary_view eq 1> 
					#GET_CONTENT.CONT_SUMMARY#
				</cfif>
				<cfif arguments.content_body_view eq 1> 
					#GET_CONTENT.cont_body#
				</cfif>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn contentDetail>
	</cffunction>
	
	<!--- content image --->
	<cffunction name="getContentImage" access="public" returntype="any">
		<cfargument name="content_id" type="numeric" required="yes">
		<cfargument name="image_size" type="string" required="no" default="">
		
		<cfquery name="GET_CONTENT_IMAGE" datasource="#DSN#">
			SELECT 
				CONTENT_ID,
				CNT_IMG_NAME,
				CONTIMAGE_SMALL,
				IMAGE_SERVER_ID
			FROM 
				CONTENT_IMAGE
			WHERE
				CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_id#">
				<cfif len(arguments.image_size)>
					AND IMAGE_SIZE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.image_size#">
				</cfif>
		</cfquery>
		
		<cfreturn GET_CONTENT_IMAGE>
	</cffunction>
	
	<!--- content category --->
	<cffunction name="getContentCat" access="public" returntype="any">
		<cfargument name="cat_id" type="numeric" required="no" default="0">
		
		<cfquery name="GET_CONTENT_CAT" datasource="#DSN#">
			SELECT 
				CONTENTCAT_ID,
				#dsn_alias#.Get_Dynamic_Language(CONTENTCAT_ID,'#lang#','CONTENT_CAT','CONTENTCAT',NULL,NULL,CONTENTCAT) AS CONTENTCAT
			FROM 
				CONTENT_CAT
			<cfif arguments.cat_id neq 0>
				WHERE
					CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cat_id#">
			</cfif>
		</cfquery>
		
		<cfreturn GET_CONTENT_CAT>
	</cffunction>
	
	<!--- content chapter --->
	<cffunction name="getContentChapter" access="public" returntype="any">
		<cfargument name="chapter_id" type="numeric" required="no" default="0">
		
		<cfquery name="GET_CONTENT_CHAPTER" datasource="#DSN#">
			SELECT 
				CHAPTER_ID,
				#dsn_alias#.Get_Dynamic_Language(CHAPTER_ID,'#lang#','CONTENT_CHAPTER','CHAPTER',NULL,NULL,CHAPTER) AS CHAPTER
			FROM 
				CONTENT_CHAPTER
			<cfif arguments.chapter_id neq 0>
				WHERE
					CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.chapter_id#">
			</cfif>
		</cfquery>
		
		<cfreturn GET_CONTENT_CHAPTER>
	</cffunction>
	
    <!--- Bir sonraki içeriği getir --->
    <cffunction name="Get_NextPrev" access="public">
    	<cfargument name="content_id" type="numeric" required="yes">
        <cfargument name="type" type="numeric" required="yes">
        	<cfquery name="Get_id" datasource="#dsn#">
            	WITH CTE1 AS (
						SELECT 
                       		C.USER_FRIENDLY_URL,
                            C.CONTENT_ID,
                            C.UPDATE_DATE,
                            CASE WHEN (C.PRIORITY = 0) THEN 1000 ELSE C.PRIORITY END AS PRIORITY
                        FROM 
                            CONTENT AS C 
                            LEFT JOIN CONTENT_CHAPTER AS CC ON C.CHAPTER_ID = CC.CHAPTER_ID 
                            LEFT JOIN CONTENT_CAT AS CCAT ON CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID
                        WHERE
                            C.STAGE_ID = -2 AND	 
                            C.CONTENT_STATUS = 1 AND
                            C.INTERNET_VIEW = 1 AND
							<cfif isdefined("session.pp.userid")>
								C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
							<cfelseif isdefined("session.ww.userid")>
								C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
							<cfelse>
								C.LANGUAGE_ID = '#session.wp.language#' AND
							</cfif>
							C.CHAPTER_ID = (SELECT
													CONTENT.CHAPTER_ID
												FROM 
													CONTENT
												WHERE
													CONTENT.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_id#">
											  )
                            ),
                            CTE2 AS (
                                   SELECT
                                        CTE1.*,
                                        ROW_NUMBER() OVER (ORDER BY PRIORITY ASC,UPDATE_DATE DESC) AS RowNum
                                    FROM
                                        CTE1	
                                    )
                            SELECT 
                                CTE2.*
                            FROM
                                CTE2
                            WHERE 
                                RowNum = (SELECT RowNum FROM CTE2 WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_id#">)<cfif arguments.type eq 1 >+1 <cfelseif arguments.type eq 2>-1</cfif>								  
            </cfquery>
        <cfreturn Get_id>  
    </cffunction>
	
	<!--- kurlar --->
	<cffunction name="getCurrency" access="public" returntype="any">
		<cfquery name="get_currency" datasource="#dsn#">
			SELECT
				SM.MONEY,
				SM.RECORD_DATE,
			<cfif isdefined("session.pp.userid")>
				RATEPP2 AS RATE2,
				RATEPP3 AS RATE3
			<cfelse>
				RATEWW2 AS RATE2,
				RATEWW3 AS RATE3
			</cfif>
			FROM
				SETUP_MONEY AS SM
			WHERE
				MONEY IN ('USD','EURO') AND
			<cfif isdefined("session.pp.userid")>
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND
				MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.money#">
			<cfelseif isdefined("session.ww.userid")>
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"> AND
				MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.money#">
			<cfelse>
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.wp.our_company_id#"> AND
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.wp.period_id#"> AND
				MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.wp.money#">
			</cfif>
			ORDER BY
				SM.RECORD_DATE DESC
		</cfquery>
		
		<cfreturn get_currency>
	</cffunction>
	
	<!--- kurumsal uye kategorileri --->
	<cffunction name="getCompanyCat" access="public" returntype="any">
		<cfargument name="domainCheck" type="numeric" default="0" required="no">
		<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
			SELECT 
				COMPANYCAT_ID, 
				#dsn_alias#.Get_Dynamic_Language(COMPANYCAT_ID,'#lang#','COMPANY_CAT','COMPANYCAT',NULL,NULL,COMPANYCAT) AS COMPANYCAT
			FROM 
				COMPANY_CAT
				<cfif arguments.domainCheck eq 1>
				,CATEGORY_SITE_DOMAIN
				</cfif>
			WHERE
				<cfif arguments.domainCheck eq 1>
					COMPANY_CAT.COMPANYCAT_ID = CATEGORY_SITE_DOMAIN.CATEGORY_ID AND
					CATEGORY_SITE_DOMAIN.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND
					CATEGORY_SITE_DOMAIN.MEMBER_TYPE = 'COMPANY' AND
				</cfif>
				IS_VIEW = 1
		</cfquery>
		
		<cfreturn GET_COMPANYCAT>
	</cffunction>
	
	<!--- member Logo --->
	<cffunction name="getMemberLogo" access="public" returntype="any">
		<cfargument name="recordCount" type="string" required="no" default="">
		<cfargument name="stage_id_list" type="string" required="no" default="">
		<cfargument name="sortfield" type="string" required="no" default="RECORD_DATE">
		<cfargument name="sortdir" type="string" required="no" default="desc">
		
		<cfquery name="GET_MEMBER_LOGO" datasource="#DSN#">
			SELECT 
				<cfif len(arguments.recordCount)>
					TOP #arguments.recordCount#
				</cfif>
				COMPANY_ID,
				FULLNAME,
				ASSET_FILE_NAME1,
				ASSET_FILE_NAME1_SERVER_ID,
				CASE WHEN (SORT IS NULL) THEN 1000000 ELSE SORT END AS SORT
			FROM 
				COMPANY
			WHERE
				<cfif isdefined('session.ep')>
					PERIOD_ID = #session.ep.period_id# AND 
				<cfelseif isdefined('session.pp')>
					PERIOD_ID = #session.pp.period_id# AND 
				<cfelse>
					PERIOD_ID = #session.wp.period_id# AND
				</cfif>
				COMPANYCAT_ID IS NOT NULL AND
				ASSET_FILE_NAME1 IS NOT NULL AND
				COMPANY_STATUS = 1 AND
				ISPOTANTIAL = 0 AND
				IS_HOMEPAGE = 1
				<cfif len(arguments.stage_id_list)>
					AND COMPANY_STATE IN (#arguments.stage_id_list#)
				</cfif>
			ORDER BY 
				#arguments.sortfield# #arguments.sortdir#
		</cfquery>
		
		<cfreturn GET_MEMBER_LOGO>
	</cffunction>
	
	<!--- member follow --->
	<cffunction name="getMemberFollow" access="public" returntype="any">
		<cfargument name="member_id" type="numeric" required="yes">
        <cfargument name="follow_member_id" type="numeric" required="no" default="0">
		<cfargument name="follow_type" type="numeric" required="no" default="1">
		<cfargument name="type_" type="numeric" required="no" default="1">
		<cfargument name="recordCount" type="string" required="no" default="">
        <cfargument name="keyword" type="string" required="no" default="">
		
		<cfquery name="GET_MEMBER_FOLLOW" datasource="#DSN#">
			<cfif arguments.type_ eq 1>
				 SELECT 
					C.COMPANY_ID, 
					C.NICKNAME, 
					C.FULLNAME, 
					CP.TITLE, 
					CP.COMPANY_PARTNER_NAME, 
					CP.COMPANY_PARTNER_SURNAME,
					CP.PARTNER_ID,
					#dsn_alias#.Get_Dynamic_Language(PARTNER_POSITION_ID,'#lang#','SETUP_PARTNER_POSITION','PARTNER_POSITION',NULL,NULL,PARTNER_POSITION) AS PARTNER_POSITION,
					#dsn_alias#.Get_Dynamic_Language(PARTNER_DEPARTMENT_ID,'#lang#','SETUP_PARTNER_DEPARTMENT','PARTNER_DEPARTMENT',NULL,NULL,PARTNER_DEPARTMENT) AS PARTNER_DEPARTMENT,
					B.COMPBRANCH__NAME,
					WS.SESSIONID,
					WS.WORKCUBE_ID,
					CP.PARTNER_ID AS FOLLOW_MEMBER_ID
				FROM 
					COMPANY_PARTNER CP 
					RIGHT JOIN COMPANY C ON CP.COMPANY_ID = C.COMPANY_ID AND C.COMPANY_STATUS = 1 AND C.ISPOTANTIAL = 0 
					LEFT JOIN COMPANY_BRANCH B ON CP.COMPBRANCH_ID = B.COMPBRANCH_ID 
					LEFT JOIN SETUP_PARTNER_POSITION SP ON CP.MISSION = SP.PARTNER_POSITION_ID 
					LEFT JOIN SETUP_PARTNER_DEPARTMENT SPD ON CP.DEPARTMENT = SPD.PARTNER_DEPARTMENT_ID 
					LEFT JOIN WRK_SESSION WS ON WS.USERID = CP.PARTNER_ID AND USER_TYPE = 1 
				WHERE 
					CP.COMPANY_PARTNER_NAME IS NOT NULL AND 
					CP.COMPANY_PARTNER_STATUS = 1 AND 
					CP.PARTNER_ID <> #session.pp.userid# AND
					CP.COMPANY_ID = #session.pp.company_id#
					<cfif len(arguments.keyword)>
						AND (CP.COMPANY_PARTNER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR 
							CP.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR 
							C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
							C.NICKNAME  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
						)
					</cfif>
			   UNION ALL
            </cfif>
            SELECT 
				<cfif len(arguments.recordCount)>
					TOP #arguments.recordCount#
				</cfif>
				C.COMPANY_ID, 
				C.NICKNAME,
                C.FULLNAME,
                CP.TITLE,
				CP.COMPANY_PARTNER_NAME,
				CP.COMPANY_PARTNER_SURNAME,
				MF.FOLLOW_MEMBER_ID AS PARTNER_ID,
				#dsn_alias#.Get_Dynamic_Language(PARTNER_POSITION_ID,'#lang#','SETUP_PARTNER_POSITION','PARTNER_POSITION',NULL,NULL,PARTNER_POSITION) AS PARTNER_POSITION,
				#dsn_alias#.Get_Dynamic_Language(PARTNER_DEPARTMENT_ID,'#lang#','SETUP_PARTNER_DEPARTMENT','PARTNER_DEPARTMENT',NULL,NULL,PARTNER_DEPARTMENT) AS PARTNER_DEPARTMENT,
				B.COMPBRANCH__NAME,
				WS.SESSIONID,
				WS.WORKCUBE_ID
				<cfif isdefined('session.pp')>
					,MF.FOLLOW_MEMBER_ID
				</cfif>
			FROM 
				MEMBER_FOLLOW MF 
				RIGHT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = MF.FOLLOW_MEMBER_ID
				RIGHT JOIN COMPANY C ON C.COMPANY_ID = CP.COMPANY_ID 
				LEFT JOIN COMPANY_BRANCH B ON CP.COMPBRANCH_ID = B.COMPBRANCH_ID
				LEFT JOIN SETUP_PARTNER_POSITION SP ON CP.MISSION = SP.PARTNER_POSITION_ID
				LEFT JOIN SETUP_PARTNER_DEPARTMENT SPD ON CP.DEPARTMENT = SPD.PARTNER_DEPARTMENT_ID
				LEFT JOIN WRK_SESSION WS ON WS.USERID = CP.PARTNER_ID AND USER_TYPE = 1
			WHERE
				CP.COMPANY_PARTNER_STATUS = 1 AND
                C.COMPANY_STATUS = 1 AND
                MF.MY_MEMBER_ID = #arguments.member_id# AND
				MF.FOLLOW_TYPE = #arguments.follow_type#
                <cfif arguments.follow_member_id gt 0>
                	AND MF.FOLLOW_MEMBER_ID = #arguments.follow_member_id#
                </cfif>
                 <cfif len(arguments.keyword)>
                	AND (CP.COMPANY_PARTNER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR 
						CP.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR 
						C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
						C.NICKNAME  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
					)
                </cfif>
		</cfquery>
		
		<cfreturn GET_MEMBER_FOLLOW>
	</cffunction>
	
	<!---member follow 2 --->
	<cffunction name="getFollowMember" access="public" returntype="any">
		<cfargument name="member_id" type="numeric" required="yes">
        <cfargument name="follow_member_id" type="numeric" required="no" default="0">
		<cfargument name="follow_type" type="numeric" required="no" default="1">
		
		<cfquery name="GET_MEMBER_FOLLOW" datasource="#DSN#">
			SELECT  
				MF.FOLLOW_MEMBER_ID AS PARTNER_ID, 
				MF.FOLLOW_MEMBER_ID 
			FROM 
				MEMBER_FOLLOW MF 
			WHERE 
				MF.MY_MEMBER_ID = #arguments.member_id# AND 
				MF.FOLLOW_TYPE = #arguments.follow_type# 
				<cfif arguments.follow_member_id gt 0>
                	AND MF.FOLLOW_MEMBER_ID = #arguments.follow_member_id#
                </cfif> 
		</cfquery>

		<cfreturn GET_MEMBER_FOLLOW>
	</cffunction>
	
	<!--- online / offline --->
	<cffunction name="getMemberStatus" access="public" returntype="any">
		<cfargument name="member_id" type="numeric" required="yes">
        <cfargument name="member_type" type="string" required="yes">
		
		<cfif arguments.member_type is 'company'>
			<cfquery name="GET_COMPANY_PARTNER" datasource="#DSN#">
				SELECT 
					PARTNER_ID
				FROM 
					COMPANY_PARTNER
				WHERE
					COMPANY_PARTNER_STATUS = 1 AND
					COMPANY_ID = <cfqueryparam cfsqltype='cf_sql_integer' value='#arguments.member_id#'>
			</cfquery>
			<cfset partner_id_list = valuelist(GET_COMPANY_PARTNER.PARTNER_ID,',')>
			<cfset arguments.member_type = 'partner'>
		<cfelse>
			<cfset partner_id_list = arguments.member_id>
			<cfset arguments.member_type = 'partner'>
		</cfif>
		
		<cfquery name='GET_ONLINE' datasource='#DSN#' maxrows="1">
			SELECT
				USERID,
				SESSIONID
			FROM
				WRK_SESSION 
			WHERE
			<cfif isdefined('partner_id_list') and len(partner_id_list)>
				USERID IN (#partner_id_list#)
			<cfelse>
				USERID = <cfqueryparam cfsqltype='cf_sql_integer' value='#arguments.member_id#'>
			</cfif>
			<cfif arguments.member_type is 'employee'>
				AND USER_TYPE = 0
			<cfelseif arguments.member_type is 'partner'>
				AND USER_TYPE = 1
			<cfelseif arguments.member_type is 'consumer'>
				AND USER_TYPE = 2
			</cfif>
		</cfquery>
		<cfif GET_ONLINE.recordcount>
			<cfreturn GET_ONLINE.SESSIONID>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<!--- Live Broadcast --->
	<cffunction name="getLiveTv" access="public" returntype="any">
		
		<cfquery name="getLiveTv_" datasource="#dsn#">
			DECLARE @FT_broadcastTV TABLE
			(
				TITLE nvarchar(max),
				BROADCAST_DATE datetime,
				FINISH_DATE datetime
			);
			INSERT INTO @FT_broadcastTV
			SELECT 
				TITLE,
				BROADCAST_DATE,
				CAST(CAST(DATEPART(year, BROADCAST_DATE) AS nvarchar) + '-' + CAST(DATEPART(month, BROADCAST_DATE) AS nvarchar) + '-' + CAST(DATEPART(day, BROADCAST_DATE) AS nvarchar) + ' ' + FINISH_TIME AS datetime) as FINISH_DATE
			FROM 
				BROADCAST_TV
			WHERE
				IS_LIVE = 1
			ORDER BY
				BROADCAST_DATE ASC
				
			SELECT
				*
			FROM
				@FT_broadcastTV
			WHERE
				DATEADD(hour, #timeZone#, GETDATE()) BETWEEN BROADCAST_DATE AND FINISH_DATE
		</cfquery>	
		<cfreturn getLiveTv_>
		
	</cffunction>
    
    <!--- mail template --->
    <cffunction name="getMailTemplate" access="public" returntype="any">
    	<cfargument name="is_status" type="numeric" required="no">
        <cfargument name="mail_to" type="string" required="yes">
        <cfargument name="message" type="string" required="no">
        <cfargument name="subject" type="string" required="no" default="">

		<cfmail from="info@styleturkish.com" to="#arguments.mail_to#" subject="#arguments.subject#" charset="utf-8" type="html">
			<cfoutput>
                <table width="590" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                    	<td colspan="2" align="center"><img src="http://#worknet_url#/documents/templates/worknet/tasarim/header.jpg" width="590" height="116" /></td>
                    </tr>
                    <tr>
                        <cfif arguments.is_status eq 0>
                        <td width="135">
                        	<img src="http://#worknet_url#/documents/templates/worknet/tasarim/icon_iptal.jpg" width="124" height="124" />
                        </td>
                        <td width="455">#message#</td>
                        <cfelseif arguments.is_status eq 1>
                        <td width="135">
                        	<img src="http://#worknet_url#/documents/templates/worknet/tasarim/icon_onay.jpg" width="124" height="124" />
                        </td>
                        <td width="455">#message#</td>
                        <cfelse>
                        <td width="590" colspan="2">#message#</td>
                        </cfif>
                    </tr>
                    <tr>
                    	<td colspan="2">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table width="100%" border="0" cellspacing="0" cellpadding="1">
                                <tr>
                                    <td bgcolor="dadada">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="13">
                                            <tr>
                                                <td align="center" bgcolor="FFFFFF"><span class="yazilar">www.styleturkish.com  |  info@styleturkish.com</span></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                		</td>
                	</tr>
                    <tr>
                        <td height="40" colspan="2" align="center"><img src="http://#worknet_url#/documents/templates/worknet/tasarim/ihkib.jpg" width="56" height="25" border="0" /></td>
                    </tr>
                </table>
			</cfoutput>
		</cfmail>
        <cfreturn true>
	</cffunction>
	
	<!--- egitimler --->
	<cffunction name="getTraining" access="public" returntype="any">
		<cfargument name="member_id" type="numeric" required="no" default="0">
		<cfargument name="training_id" type="numeric" required="no" default="0">
        <cfargument name="training_type" type="string" required="no" default="" hint="0 = Normal egitimler,1= Online Egitimler">
		<cfargument name="cat_id" type="string" required="no" default="">
		<cfargument name="sec_id" type="string" required="no" default="">
		<cfargument name="language" type="string" required="no" default="">
		<cfargument name="price_catid" type="numeric" required="no" default="1">
		
		<cfquery name="get_training" datasource="#dsn#">
			SELECT 
				TC.START_DATE, 
				TC.FINISH_DATE, 
				TC.ONLINE, 
				TC.CLASS_ID, 
				TC.CLASS_NAME, 
				TC.CLASS_PLACE,
				TC.TRAINING_CAT_ID,
				TC.TRAINING_SEC_ID,
				TC.CLASS_TARGET,
				TC.CLASS_OBJECTIVE,
				TC.CLASS_ANNOUNCEMENT_DETAIL,
				<!--- TC.TRAINER_EMP,
				TC.TRAINER_PAR,
				TC.TRAINER_CONS, --->
				TC.RELATED_CLASS_ID,
				<cfif isdefined('session.ww.userid')>
					TC.STOCK_ID,
					PRICE.PRICE_KDV,
					PRICE.MONEY,
				</cfif>
				CASE WHEN RELATED_CLASS_ID IS NOT NULL THEN (SELECT TRAINING_CLASS.CLASS_NAME FROM TRAINING_CLASS WHERE TC.RELATED_CLASS_ID = TRAINING_CLASS.CLASS_ID) END AS RELATED_CLASS_NAME,
				CASE WHEN (TC.MAX_SELF_SERVICE IS NULL OR TC.MAX_SELF_SERVICE = '') THEN 1000000 ELSE TC.MAX_SELF_SERVICE  END AS MAX_SELF_SERVICE,
				#dsn_alias#.Get_Dynamic_Language(TCAT.TRAINING_CAT_ID,'#lang#','TRAINING_CAT','TRAINING_CAT',NULL,NULL,TCAT.TRAINING_CAT) AS TRAINING_CAT,
				#dsn_alias#.Get_Dynamic_Language(TSEC.TRAINING_SEC_ID,'#lang#','TRAINING_SEC','SECTION_NAME',NULL,NULL,TSEC.SECTION_NAME) AS SECTION_NAME
				<cfif arguments.training_id neq 0>
					,SCO.SCO_ID
					,SCO.IS_FREE
				</cfif>
			FROM
				TRAINING_CLASS TC
				LEFT JOIN TRAINING_CAT TCAT ON TCAT.TRAINING_CAT_ID = TC.TRAINING_CAT_ID
				LEFT JOIN TRAINING_SEC TSEC ON TSEC.TRAINING_SEC_ID = TC.TRAINING_SEC_ID
				<cfif arguments.training_id neq 0>
					LEFT JOIN TRAINING_CLASS_SCO SCO ON SCO.CLASS_ID = TC.CLASS_ID
				</cfif>
                <cfif isdefined('session.ww.userid')>
                	LEFT JOIN #dsn3_alias#.PRICE ON PRICE.STOCK_ID = TC.STOCK_ID AND PRICE.PRICE_CATID = #arguments.price_catid#
                </cfif>
			WHERE
				TC.CLASS_ID IS NOT NULL AND
				TC.IS_INTERNET = 1 AND
				TC.IS_ACTIVE = 1 
				<cfif len(arguments.language)>
					AND TC.LANGUAGE = '#arguments.language#'
				</cfif>
				<cfif arguments.training_id gt 0>
					AND TC.CLASS_ID = #arguments.training_id#
				</cfif>
				<cfif len(arguments.training_type) and arguments.training_type eq 1>
					AND TC.ONLINE = 1
					AND TC.FINISH_DATE > #now()#
				<cfelseif len(arguments.training_type) and arguments.training_type eq 0>
					AND TC.ONLINE = 0
				</cfif>
				<cfif len(arguments.cat_id)>
					AND TC.TRAINING_CAT_ID = #arguments.cat_id#
				</cfif>
				<cfif len(arguments.sec_id)>
					AND TC.TRAINING_SEC_ID = #arguments.sec_id#
				</cfif>
			ORDER BY 
				MAX_SELF_SERVICE ASC,
				TC.UPDATE_DATE DESC	
		</cfquery>
		
		<cfreturn get_training>
	</cffunction>
	<!--- Eğitimciler--->
	<cffunction name="get_class_trainers" returntype="query">
		<cfargument name="class_id" default="" type="numeric"/>
		<cfquery name="get_class_trainer" datasource="#this.dsn#">
			SELECT
				TCT.ID,
				E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS TRAINER,
				'Çalışan' AS TRAINER_DETAIL
			FROM
				TRAINING_CLASS_TRAINERS TCT INNER JOIN EMPLOYEES E
				ON TCT.EMP_ID = E.EMPLOYEE_ID 
			WHERE
				TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
			UNION ALL
			SELECT
				TCT.ID,
				CP.COMPANY_PARTNER_NAME+' '+ CP.COMPANY_PARTNER_SURNAME AS TRAINER,
				'Kurumsal' AS TRAINER_DETAIL
			FROM
				TRAINING_CLASS_TRAINERS TCT INNER JOIN COMPANY_PARTNER CP
				ON TCT.PAR_ID =CP.PARTNER_ID 
			WHERE
				TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
			UNION ALL
			SELECT
				TCT.ID,
				C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS TRAINER,
				'Bireysel' AS TRAINER_DETAIL
			FROM
				TRAINING_CLASS_TRAINERS TCT INNER JOIN CONSUMER C
				ON TCT.CONS_ID =C.CONSUMER_ID 
			WHERE
				TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
		</cfquery>
		<cfreturn get_class_trainer/>
	</cffunction>	
	
	<!--- aldigim egitimler --->
	<cffunction name="getTrainingData" access="public" returntype="any">
		<cfargument name="member_id" type="numeric" required="no" default="0">
		<cfargument name="member_type" type="numeric" required="no" default="1">
		
		<cfquery name="get_training_data" datasource="#dsn#">
			 SELECT 
				DISTINCT SCO.SCO_ID, 
				TC.CLASS_ID,
				TC.CLASS_NAME,
				SCO.NAME, 
				SCO.VERSION, 
				SCO_DATA.USER_ID AS USERID, 
				SCO_DATA.USER_TYPE , 
				'' AS TOTAL_TIME, 
				'' AS SCORE, '' AS COMPLETION_STATUS, 
				'' AS SUCCESS_STATUS, '' AS PROGRESS, 
				'' AS DATA_ID
			FROM 
				TRAINING_CLASS_SCO SCO 
				RIGHT JOIN TRAINING_CLASS TC ON TC.CLASS_ID = SCO.CLASS_ID
				RIGHT JOIN TRAINING_CLASS_SCO_DATA SCO_DATA ON SCO.SCO_ID = SCO_DATA.SCO_ID
			 WHERE 
			 	SCO.SCO_ID IS NOT NULL AND
				SCO_DATA.USER_ID = #arguments.member_id# AND 
				SCO_DATA.USER_TYPE = #arguments.member_type#
		</cfquery>
		
		<cfreturn get_training_data>
	</cffunction>
	
	<!--- iliskili egitim kontrol --->
	<cffunction name="getTrainingCompleted" access="public" returntype="any">
		<cfargument name="member_id" type="numeric" required="no" default="0">
		<cfargument name="training_id" type="string" required="no" default="">
		<cfargument name="member_type" type="numeric" required="no" default="1">
		
		<cfquery name="get_training_data" datasource="#dsn#">
			 SELECT 
				VAR_VALUE,
				SCO.IS_FREE
			FROM 
				TRAINING_CLASS_SCO_DATA SCO_DATA
				RIGHT JOIN TRAINING_CLASS_SCO SCO ON SCO.SCO_ID = SCO_DATA.SCO_ID
			 WHERE 
				SCO.SCO_ID IS NOT NULL AND
				(SCO_DATA.VAR_NAME LIKE 'cmi.completion_status' OR SCO_DATA.VAR_NAME LIKE 'cmi.core.lesson_status') AND
				SCO_DATA.USER_ID = #arguments.member_id# AND 
				SCO_DATA.USER_TYPE = #arguments.member_type# AND 
				SCO.CLASS_ID = #arguments.training_id#
		</cfquery>
		<cfif get_training_data.VAR_VALUE is 'completed'>
			<cfreturn 1>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<!---  egitim onerileri --->
	<cffunction name="getTrainingRecommendations" access="public" returntype="any">
		<cfargument name="member_id" type="numeric" required="no" default="0">
		<cfargument name="member_type" type="numeric" required="no" default="1">
		<cfargument name="is_read" type="string" required="no" default="">
		
		<cfquery name="get_training_Recommendation" datasource="#dsn#">
			 SELECT
				CASE TR.RECORDED_TYPE 
				WHEN 0 THEN (SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = TR.RECORDED_ID) 
				WHEN 1 THEN (SELECT C.NICKNAME+' - '+CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER CP RIGHT JOIN COMPANY C ON CP.COMPANY_ID = C.COMPANY_ID  WHERE CP.PARTNER_ID = TR.RECORDED_ID)
				WHEN 2 THEN (SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = TR.RECORDED_ID)
				END AS ONEREN,
				TR.RECORDED_TYPE,
				TR.RECORDED_ID,
				TR.USER_ID,
				TR.CLASS_ID,
				TR.RECORD_DATE,
				TR.DETAIL,
				TC.CLASS_NAME,
				TR.IS_READ
			FROM
				TRAINING_RECOMMENDATIONS TR
				RIGHT JOIN TRAINING_CLASS TC ON TR.CLASS_ID = TC.CLASS_ID
			WHERE
				TR.USER_ID = #arguments.member_id#
				AND TR.USER_TYPE = #arguments.member_type#
				<cfif len(arguments.is_read)>
					AND TR.IS_READ = #arguments.is_read#
				</cfif>
			ORDER BY
				TR.RECORD_DATE DESC
		</cfquery>
		
		<cfreturn get_training_recommendation>
	</cffunction>
	
	<!--- UPD Training Recommendations --->
	<cffunction name="updTrainingRecommendations" access="public" returntype="any">
		<cfargument name="member_id" type="numeric" required="no" default="0">
		<cfargument name="member_type" type="numeric" required="no" default="1">
		
		<cfquery name="upd_training_recommendations" datasource="#dsn#">
			UPDATE
				TRAINING_RECOMMENDATIONS
			SET
				IS_READ = 1
			WHERE
				USER_ID = #arguments.member_id#
				AND USER_TYPE = #arguments.member_type#
				AND IS_READ = 0
		</cfquery>
	</cffunction>
	
	<!--- egitim Testi --->
	<cffunction name="getTrainingQuiz" access="public" returntype="any">
		<cfargument name="training_id" type="numeric" required="no" default="0">
		
		<cfquery name="get_training_Quiz" datasource="#dsn#">
			SELECT 
				TOP 1
				*
			FROM 
				QUIZ_RELATION
			WHERE
				CLASS_ID = #arguments.training_id#
		</cfquery>
		
		<cfreturn get_training_Quiz>
	</cffunction>
	
	<!--- degerlendirme formu --->
	<cffunction name="getFormGenerator" access="public" returntype="any">
		<cfargument name="action_id" type="numeric" required="yes">
        <cfargument name="action_type" type="numeric" required="yes">
		
		<cfquery name="get_form_generator" datasource="#dsn#">
			SELECT 
				 TOP 1
				 SM.SURVEY_MAIN_ID,
				 SM.SURVEY_MAIN_HEAD
			FROM 
				SURVEY_MAIN SM,
				CONTENT_RELATION CR
			WHERE
				SM.SURVEY_MAIN_ID = CR.SURVEY_MAIN_ID AND
				(
					(CR.RELATION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_type#">  AND CR.RELATED_ALL = 1 AND CR.RELATION_CAT IS NULL)
					OR 
					(CR.RELATION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_type#">  AND CR.RELATION_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">)
				)
            ORDER BY
            	SM.RECORD_DATE DESC
		</cfquery>
		
		<cfreturn get_form_generator>
	</cffunction>
	
	<!--- degerlendirme formu sonuc --->
	<cffunction name="getTrainingFormGeneratorResult" access="public" returntype="any">
		<cfargument name="training_id" type="numeric" required="yes">
		<cfargument name="survey_id" type="numeric" required="yes">
		
		<cfquery name="get_result_control" datasource="#dsn#"> 
			SELECT 
				SURVEY_MAIN_RESULT_ID 
			FROM 
				SURVEY_MAIN_RESULT 
			WHERE 
				SURVEY_MAIN_ID = #arguments.survey_id# AND 
				<cfif isdefined('session.pp.userid')>
					PARTNER_ID = #session.pp.userid# AND 
				<cfelseif isdefined('session.pp.userid')>
					CONSUMER_ID = #session.ww.userid# AND 
				<cfelseif isdefined('session.ep.userid')>
					EMP_ID = #session.ep.userid# AND 
				</cfif>
				ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_id#"> AND 
				ACTION_TYPE = 9
		</cfquery>
		
		<cfreturn get_result_control>
	</cffunction>
	
	<!--- abonelik kontrol --->
	<cffunction name="getMemberSubs" access="public" returntype="any">
		
		<cfquery name="get_member_subs" datasource="#dsn3#">
			SELECT 
				SC.SUBSCRIPTION_ID, 
				SPPR.PAYMENT_DATE, 
				SPPR.PAYMENT_FINISH_DATE,
				S.PRODUCT_NAME +' - '+ S.PROPERTY AS PRODUCT_NAME,
				S.STOCK_CODE_2,
				SPPR.ROW_NET_TOTAL,
				S.TAX
			FROM 
				SUBSCRIPTION_CONTRACT SC 
				RIGHT JOIN SUBSCRIPTION_PAYMENT_PLAN_ROW SPPR ON SC.SUBSCRIPTION_ID = SPPR.SUBSCRIPTION_ID 
				LEFT JOIN STOCKS S ON S.STOCK_ID = SPPR.STOCK_ID 
			WHERE 
				SC.COMPANY_ID = #session.pp.company_id# AND
				SC.IS_ACTIVE = 1 AND
				SPPR.IS_PAID = 1 AND
				SPPR.IS_ACTIVE = 1 AND
				SPPR.PAYMENT_FINISH_DATE >= #now()#
		</cfquery>
		
		<cfreturn get_member_subs>
	</cffunction>
	
	<!--- egitim satin alindimi --->
	<cffunction name="getSalesTraining" access="public" returntype="any">
		<cfargument name="stock_id" required="yes" type="any" default="">
		<cfquery name="get_Sales_Training" datasource="#dsn3#">
			SELECT
				O.ORDER_ID
			FROM
				ORDERS O
				RIGHT JOIN ORDER_ROW OROW ON OROW.ORDER_ID = O.ORDER_ID
			WHERE
				O.ORDER_STATUS = 1 AND
				O.IS_PAID = 1 AND
				<cfif isdefined('session.pp')>
					O.COMPANY_ID = #session.pp.company_id# AND
					O.PARTNER_ID = #session.pp.userid# AND
				<cfelseif isdefined('session.ww.userid')>
					O.CONSUMER_ID = #session.ww.userid# AND
				</cfif>
				OROW.STOCK_ID = #arguments.stock_id#
		</cfquery>
		
		<cfreturn get_Sales_Training>
	</cffunction>
	
	<!--- favorilerime eklee cikar --->
	<cffunction name="addRemoveFavorite" access="public" returntype="any">
		<cfargument name="action_id" type="numeric" required="yes" default="">
		<cfargument name="action_type" type="string" required="yes" default="">
		<cfargument name="relation_type" type="numeric" required="no" default="1" hint="1: favorilerim">
		<cfargument name="add" type="numeric" required="no" default="1">
		
		<cfquery name="add_Remove_Favorite" datasource="#dsn#">
			<cfif arguments.add eq 1>
				INSERT INTO
					MY_RELATION_OBJECTS
					(
						ACTION_ID,
						ACTION_TYPE,
						MEMBER_ID,
						MEMBER_TYPE,
						RELATION_TYPE
					)
					VALUES
					(
						#arguments.action_id#,
						'#arguments.action_type#',
						<cfif isdefined('session.pp')>
							#session.pp.userid#,
							'partner',
						<cfelseif isdefined('session.ww.userid')>
							#session.ww.userid#,
							'consumer',
						</cfif>
						#arguments.relation_type#
					)
			<cfelse>
				DELETE FROM 
					MY_RELATION_OBJECTS 
				WHERE
					ACTION_ID = #arguments.action_id# AND
					ACTION_TYPE = '#arguments.action_type#' AND
					RELATION_TYPE = #arguments.relation_type#
					<cfif isdefined('session.pp')>
						AND MEMBER_ID = #session.pp.userid#
						AND MEMBER_TYPE = 'partner'
					<cfelseif isdefined('session.ww.userid')>
						AND MEMBER_ID = #session.ww.userid#
						AND MEMBER_TYPE = 'consumer'
					</cfif>
			</cfif>
		</cfquery>
		
	</cffunction>
	
	<!--- favorilerimi getir --->
	<cffunction name="getFavorite" access="public" returntype="any">
		<cfargument name="action_id" type="numeric" required="no" default="0">
		<cfargument name="action_type" type="string" required="yes" default="">
		<cfargument name="relation_type" type="numeric" required="no" default="1" hint="1: favorilerim">
		
		<cfquery name="get_Favorite" datasource="#dsn#">
			SELECT 
				* 
			FROM 
				MY_RELATION_OBJECTS
			WHERE
				ACTION_TYPE = '#arguments.action_type#' AND
				RELATION_TYPE = #arguments.relation_type#
				<cfif arguments.action_id neq 0>
					AND ACTION_ID = #arguments.action_id#
				</cfif>
				<cfif isdefined('session.pp')>
					AND MEMBER_ID = #session.pp.userid#
					AND MEMBER_TYPE = 'partner'
				<cfelseif isdefined('session.ww.userid')>
					AND MEMBER_ID = #session.ww.userid#
					AND MEMBER_TYPE = 'consumer'
				</cfif>
		</cfquery>
		<cfreturn get_Favorite>
	</cffunction>
	
    <!--- Ziyaret Sayısı --->
    <cffunction name="getVisit" access="public" returntype="any">
    	<cfargument name="process_type" type="string" required="no" default="">
        <cfargument name="process_id" type="numeric" required="no" default="0">
        
         <cfquery name="get_total" datasource="#dsn#">
       		 SELECT 
        		SUM(TOTAL_COUNT) AS TOTAL_VISIT 
       		 FROM 
        		WRK_VISIT_CLICK
       		 WHERE
         		PROCESS_TYPE = '#arguments.process_type#'
        		<cfif arguments.process_id eq 0>  
                	AND PROCESS_ID IN (
                	<cfif process_type is 'demand'>
                   		SELECT DEMAND_ID FROM WORKNET_DEMAND WHERE COMPANY_ID = #session.pp.company_id#
                    <cfelseif  process_type is 'product'>
                    	SELECT PRODUCT_ID FROM #dsn1_alias#.WORKNET_PRODUCT WHERE COMPANY_ID = #session.pp.company_id# AND IS_CATALOG = 0
					<cfelseif  process_type is 'catalog'>
                    	SELECT PRODUCT_ID FROM #dsn1_alias#.WORKNET_PRODUCT WHERE COMPANY_ID = #session.pp.company_id# AND IS_CATALOG = 1
                    </cfif>
                	)
                <cfelse>
                    AND PROCESS_ID = #arguments.process_id#
                </cfif>
       	</cfquery>
        <cfif len(get_total.TOTAL_VISIT)>
			<cfreturn get_total.TOTAL_VISIT>
		<cfelse>
			<cfreturn 0>
		</cfif>
    </cffunction>
	
	<!--- genel arama sonuclari --->
    <cffunction name="getGeneralSearch" access="public" returntype="any">
    	<cfargument name="keyword" type="string" default="">
		<cfargument name="product_cat" type="string" default="">
		<cfargument name="product_catid" type="string" default="">
        
         <cfquery name="get_General_Search" datasource="#dsn#">
			<!--- icerik --->
			SELECT 
			 	1 AS TYPE,
				CONTENT_ID AS ACTION_ID,
				CONT_HEAD AS ACTION_NAME,
				USER_FRIENDLY_URL AS USER_FRIENDLY_URL
			FROM 
				CONTENT 
			WHERE
				STAGE_ID = -2 AND	 
				CONTENT_STATUS = 1
				<cfif isdefined("session.pp.userid")>
					AND LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#">
				<cfelseif isdefined("session.ww.userid")>
					AND LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#">
				<cfelse>
					AND LANGUAGE_ID = '#session.wp.language#'
					AND INTERNET_VIEW = 1
				</cfif>
				<cfif len(arguments.keyword)>
					AND (
						<!---BK 20131012 6 aya kaldirilsin CONT_HEAD LIKE '%#arguments.keyword#%' OR
						OR CONT_BODY LIKE '%#arguments.keyword#%' OR
						CONT_SUMMARY LIKE '%#arguments.keyword#%'--->
						CONTAINS(*,'"#arguments.keyword#"') 
						)
				</cfif>
			<!--- üye --->
				UNION ALL
				SELECT 
					2 AS TYPE,
					C.COMPANY_ID AS ACTION_ID,
					C.FULLNAME AS ACTION_NAME,
					'' AS USER_FRIENDLY_URL
				FROM 
					COMPANY C WITH (NOLOCK)
					<cfif len(arguments.product_cat) and len(arguments.product_catid)>
						LEFT JOIN WORKNET_RELATION_PRODUCT_CAT WRPC ON C.COMPANY_ID = WRPC.COMPANY_ID
					</cfif>
				WHERE 
					<cfif isdefined('session.ep')>
						C.PERIOD_ID = #session.ep.period_id#
					<cfelseif isdefined('session.pp')>
						C.PERIOD_ID = #session.pp.period_id#
					<cfelseif isdefined('session.ww')>
						C.PERIOD_ID = #session.ww.period_id#
					<cfelse>
						C.PERIOD_ID = #session.wp.period_id#
					</cfif>
					AND C.ISPOTANTIAL = 0
					AND C.COMPANY_STATUS = 1
					<cfif len(arguments.keyword)>
						AND 
						(
							C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
							C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
						)
					</cfif>
					<cfif len(arguments.product_cat) and len(arguments.product_catid)>
						AND WRPC.PRODUCT_CATID = #arguments.product_catid#
					</cfif>
				<!--- kisiler --->
				UNION ALL
					SELECT 
						3 AS TYPE,
						CP.PARTNER_ID,
						CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME AS ACTION_NAME,
						'' AS USER_FRIENDLY_URL
					FROM
						COMPANY_PARTNER CP
						RIGHT JOIN COMPANY C ON CP.COMPANY_ID = C.COMPANY_ID AND C.COMPANY_STATUS = 1 AND C.ISPOTANTIAL = 0
						<cfif len(arguments.product_cat) and len(arguments.product_catid)>
							LEFT JOIN WORKNET_RELATION_PRODUCT_CAT WRPC ON CP.COMPANY_ID = WRPC.COMPANY_ID
						</cfif>
					WHERE 
						CP.COMPANY_PARTNER_NAME IS NOT NULL
							AND CP.COMPANY_PARTNER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
						<cfif len(arguments.keyword)>
							AND CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
						</cfif>
						<cfif len(arguments.product_cat) and len(arguments.product_catid)>
							AND WRPC.PRODUCT_CATID = #arguments.product_catid#
						</cfif>
				
			<!--- talep --->
			UNION ALL
				SELECT 
					4 AS TYPE,
					WD.DEMAND_ID AS ACTION_ID,
					WD.DEMAND_HEAD AS ACTION_NAME,
					'' AS USER_FRIENDLY_URL
				FROM 
					WORKNET_DEMAND WD
				WHERE 
					WD.IS_STATUS = 1 AND
					WD.IS_ONLINE = 1
					<cfif isdefined('session.pp.userid')>
						AND (
							WD.ORDER_MEMBER_TYPE = 1 OR
							WD.COMPANY_ID = #session.pp.company_id# OR
							WD.COMPANY_ID IN (SELECT 
												CP.COMPANY_ID
											FROM 
												MEMBER_FOLLOW MF,
												COMPANY_PARTNER CP
											WHERE 
												CP.PARTNER_ID = MF.MY_MEMBER_ID AND
												MF.FOLLOW_TYPE = 1 AND 
												MF.FOLLOW_MEMBER_ID =  #session.pp.userid# AND
												MF.FOLLOW_MEMBER_TYPE = 'PARTNER'
											)
							)
						AND WD.FINISH_DATE >= #now()#
					<cfelseif isdefined('session.wp')>
						AND WD.ORDER_MEMBER_TYPE = 1
						AND WD.FINISH_DATE >= #now()#
					</cfif>
					<cfif len(arguments.keyword)>
						AND (
							WD.DEMAND_HEAD LIKE '%#arguments.keyword#%' OR
							WD.DEMAND_KEYWORD LIKE '%#arguments.keyword#%' OR
							WD.DETAIL LIKE '%#arguments.keyword#%'
							)
					</cfif>
					<cfif len(arguments.product_catid) and len(arguments.product_cat)>AND WD.DEMAND_ID IN (SELECT DEMAND_ID FROM WORKNET_RELATION_PRODUCT_CAT WHERE PRODUCT_CATID = #arguments.product_catid#)</cfif>
				<!--- ürünler --->
					UNION ALL
					SELECT 
						5 AS TYPE,
						WP.PRODUCT_ID AS ACTION_ID,
						WP.PRODUCT_NAME AS ACTION_NAME,
						'' AS USER_FRIENDLY_URL
					FROM
						#dsn1_alias#.WORKNET_PRODUCT WP
					WHERE 
						WP.PRODUCT_STATUS = 1
						AND WP.IS_ONLINE = 1
						AND WP.IS_CATALOG = 0
						<cfif len(arguments.product_catid) and len(arguments.product_cat)>
							AND WP.PRODUCT_CATID = #arguments.product_catid#
						</cfif>
						<cfif len(arguments.keyword)>
							AND (
								WP.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
								WP.PRODUCT_KEYWORD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
								WP.PRODUCT_DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
								WP.PRODUCT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
							)
						</cfif>
				<!--- kataloglar --->
					UNION ALL
					SELECT 
						6 AS TYPE,
						WP.PRODUCT_ID AS ACTION_ID,
						WP.PRODUCT_NAME AS ACTION_NAME,
						'' AS USER_FRIENDLY_URL
					FROM
						#dsn1_alias#.WORKNET_PRODUCT WP
					WHERE 
						WP.PRODUCT_STATUS = 1
						AND WP.IS_ONLINE = 1
						AND WP.IS_CATALOG = 1
						<cfif len(arguments.product_catid) and len(arguments.product_cat)>
							AND WP.PRODUCT_CATID = #arguments.product_catid#
						</cfif>
						<cfif len(arguments.keyword)>
							AND (
								WP.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
								WP.PRODUCT_KEYWORD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
								WP.PRODUCT_DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
								WP.PRODUCT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
							)
						</cfif>
					ORDER BY
						TYPE,
						ACTION_NAME
       		</cfquery>
        <cfreturn get_General_Search>
    </cffunction>
	
	<!--- crate thumbnail Image --->
	<cffunction name="createThumbnailImage" access="public" returntype="any">
    	<cfargument name="maxHeight" type="string" required="no" default="">
        <cfargument name="maxWidth" type="string" required="no" default="">
		<cfargument name="folder" type="string" required="no" default="">
		<cfargument name="path" type="string" required="no" default="">
		
		<!--- set the desired image height ---->
		<cfset thumbHeight_ = arguments.maxHeight>
		
		<!--- read the image ---->
		<cfimage source="../../documents/#arguments.folder#/#path#" name="imgInfo">
		
		<!--- figure out which way to scale the image --->
		<cfif imgInfo.height gt thumbHeight_ or imgInfo.width gt arguments.maxWidth>
			<cfif imgInfo.height gt arguments.maxHeight>
				<cfset thumbWidth_ = imgInfo.width*(thumbHeight_/imgInfo.height)>
				<cfset thumbHeight_ = arguments.maxHeight>
            <cfelse>
            	<cfset thumbWidth_ = imgInfo.width>
			</cfif>
			<cfif thumbWidth_ gt arguments.maxWidth>
				<cfset thumbHeight_ = thumbHeight_*(arguments.maxWidth/thumbWidth_)>
				<cfset thumbWidth_ = arguments.maxWidth>
			</cfif>
			<cfif not isdefined('thumbWidth_')>
				<cfset thumbWidth_ = imgInfo.width>
			</cfif>
			 <cfimage action="resize"
				height="#thumbHeight_#"
				width="#thumbWidth_#"
				source="../../documents/#arguments.folder#/#path#"
				destination="../../documents/thumbnails/#path#"
				overwrite="true"/>
			
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
		
    </cffunction>
	
	<!--- Sanal pos bilgileri --->
    <cffunction name="getSanalPos" access="public" returntype="any">
         <cfquery name="get_Sanal_Pos" datasource="#dsn#">
       		SELECT DISTINCT
				POS_REL.POS_ID,
				POS_REL.POS_NAME
			FROM 
				OUR_COMPANY_POS_RELATION AS POS_REL,
				OUR_COMPANY AS COMP,
				#dsn3_alias#.CREDITCARD_PAYMENT_TYPE CPT
			WHERE
				COMP.COMP_ID = POS_REL.OUR_COMPANY_ID AND
				CPT.POS_TYPE = POS_REL.POS_ID AND
				POS_REL.IS_ACTIVE = 1 AND
				ISNULL(CPT.IS_SPECIAL,0) <> 1 AND
				CPT.IS_ACTIVE = 1 AND
				CPT.IS_PARTNER = 1 AND
				CPT.POS_TYPE IS NOT NULL AND
				<cfif isdefined('session.pp')>
					COMP.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
				<cfelseif isdefined('session.ww.userid')>
					COMP.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
				</cfif>
			ORDER BY
				POS_REL.POS_ID
       	</cfquery>
		
        <cfreturn get_Sanal_Pos>
    </cffunction>
	
	<!--- highlight --->
	<cffunction name="highLightText" access="public" output="false" hint="Given an arbitrary string and a search term, find it, and return a 'cropped' set of text around the match.">
		<cfargument name="string" type="string" required="true" hint="Main blob of text">
		<cfargument name="term" type="string" required="true" hint="Keyword to look for.">
		<cfargument name="size" type="numeric" required="false" hint="Size of result string. Defaults to total size of string. Note this is a bit fuzzy - we split it in two and return that amount before and after the match. The size of term and wrap will therefore impact total string length.">
		<cfargument name="wrap" type="string" required="false" default="<b></b>" hint="HTML to wrap the match. MUST be one pair of HTML tags.">
	
		<cfset var excerpt = "">
	
		<!--- clean the string --->
		<cfset arguments.string = trim(rereplace(arguments.string, "<.*?>", "", "all"))>
	
		<!--- pad is half our total --->
		<cfif not structKeyExists(arguments, "size")>
			<cfset arguments.size = len(arguments.string)>
		</cfif>
		<cfset var pad = ceiling(arguments.size/2)>
	
		<cfset var match = findNoCase(arguments.term, arguments.string)>
		<cfif match lte pad>
			<cfset match = 1>
		</cfif>
		<cfset var end = match + len(arguments.term) + arguments.size>
	
		<!--- now create the main string around the match --->
		<cfif len(arguments.string) gt arguments.size>
			<cfif match gt 1>
				<cfset excerpt = "..." & mid(arguments.string, match-pad, end-match)>
			<cfelse>
				<cfset excerpt = left(arguments.string,end)>
			</cfif>
			<cfif len(arguments.string) gt end>
				<cfset excerpt = excerpt & "...">
			</cfif>
		<cfelse>
			<cfset excerpt = arguments.string>
		</cfif>
	
		<!--- split up my wrap - I bet this can be done better... --->
		<cfset var endInitialTag = find(">",arguments.wrap)>
		<cfset var beginTag = left(arguments.wrap, endInitialTag)>
		<cfset var endTag = mid(arguments.wrap, endInitialTag+1, len(arguments.wrap))>
	
		<cfset excerpt = reReplaceNoCase(excerpt, "(#arguments.term#)", "#beginTag#\1#endTag#","all")>
	
		<cfreturn excerpt>
	</cffunction> 
	
	<!--- Bir önceki ve Sonraki Ürün --->
    <cffunction name="Get_NextPrevProduct" access="public" >
    	<cfargument name="product_id" type="numeric" required="yes">
        <cfargument name="type" type="numeric" required="yes">
            <cfquery name="Get_ids" datasource="#dsn1#">
            WITH CTE1 AS
                (
                    SELECT
                        WP.PRODUCT_ID,
                        WP.PRODUCT_NAME,
                        WP.RECORD_DATE
                    FROM 
                        WORKNET_PRODUCT WP
                    WHERE 
                        WP.PRODUCT_STATUS = 1 
                        AND WP.IS_ONLINE = 1
                        AND WP.IS_CATALOG = 0 
                        AND WP.COMPANY_ID = (SELECT COMPANY_ID FROM WORKNET_PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"> )
                ),
                CTE2 AS (
                            SELECT 
                                CTE1.*,
                                ROW_NUMBER() OVER (ORDER BY RECORD_DATE desc) AS RowNum
                            FROM
                                CTE1
                        )		
                SELECT 
                    CTE2.*
                FROM
                    CTE2
                WHERE RowNum = (SELECT RowNum FROM CTE2 WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">)<cfif arguments.type eq 1>+1<cfelseif arguments.type eq 2>-1</cfif> 
            </cfquery>
        <cfreturn Get_ids>
    </cffunction>
	
	<!--- banner --->
    <cffunction name="getBanner" access="public" >
    	<cfargument name="is_homepage" type="any" required="no" default="">
        <cfargument name="content_id" type="any" required="no" default="">
		<cfargument name="banner_id" type="any" required="no" default="">
		<cfargument name="banner_position" type="any" required="no" default="">
          
		<cfquery name="get_banner_list" datasource="#DSN#">
			SELECT 
				CB.BANNER_ID,
				CB.BANNER_FILE,
				CB.URL_PATH,
				CB.URL,
				CB.IS_FLASH,
				CB.BANNER_TARGET,
				CB.BANNER_NAME,
				CB.BANNER_HEIGHT,
				CB.BANNER_WIDTH,
				CB.BANNER_SERVER_ID,
				CB.BACK_COLOR,
				CASE WHEN (CB.SEQUENCE IS NULL) THEN 0 ELSE CB.SEQUENCE END AS SEQUENCE
			FROM 
				CONTENT_BANNERS CB,
				CONTENT_BANNERS_USERS CBU
			WHERE  
				CBU.IS_INTERNET = 1 AND
				CB.BANNER_ID = CBU.BANNER_ID AND
				'#dateformat(now(),'yyyy-mm-dd')#' BETWEEN CB.START_DATE AND CB.FINISH_DATE AND
				CB.IS_ACTIVE = 1 AND 
				CB.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lang#">
				<cfif len(arguments.banner_position) and arguments.banner_position is 'left'>
					AND CB.BANNER_AREA_ID IN (2,3)
				<cfelseif len(arguments.banner_position) and arguments.banner_position is 'right'>
					AND CB.BANNER_AREA_ID IN (4,5)
				</cfif>
				<cfif len(arguments.is_homepage) and arguments.is_homepage eq 1>AND CB.IS_HOMEPAGE = 1<cfelseif len(arguments.is_homepage) and arguments.is_homepage eq 0>AND CB.IS_HOMEPAGE = 0</cfif>
				<cfif len(arguments.content_id)>AND CB.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_id#"></cfif>
				<cfif len(arguments.banner_id)>AND CB.BANNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.banner_id#"></cfif>
				<!---<cfif isdefined("session.pp.company_category")>
					AND CBU.COMPANYCAT_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_category#">
				<cfelseif isdefined("session.ww.consumer_category")>
					AND CBU.CONSCAT_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.consumer_category#">
				</cfif>--->
			ORDER BY
				SEQUENCE ASC
		</cfquery>
		
		<cfset sequence_list = ListDeleteDuplicates(valuelist(get_banner_list.SEQUENCE,','))>
		<cfsavecontent variable="bannerDetail">
			<cfif get_banner_list.recordcount>
				<cfoutput>
					<cfloop list="#sequence_list#" index="i"> 
						<cfquery name="get_banner_sequence" dbtype="query">
							SELECT * FROM get_banner_list WHERE SEQUENCE = #i#
						</cfquery>
						<cfset 'banner_id_list#i#' = valuelist(get_banner_sequence.banner_id,',')>
					</cfloop>
				</cfoutput>
				<table>
					<cfoutput query="get_banner_list" group="SEQUENCE">
						<!--- rastgele banner getirmek icin --->
						<cfset random_sequence = RandRange(1,listlen(evaluate('banner_id_list#SEQUENCE#'),','))>
						<cfset random_banner_id = ListGetAt(evaluate('banner_id_list#SEQUENCE#'),random_sequence,',')>
						<!--- rastgele banner getirmek icin --->
						
						<cfquery name="get_banner" dbtype="query">
							SELECT * FROM get_banner_list WHERE BANNER_ID = #random_banner_id#
						</cfquery>
						
						<cfloop query="get_banner">
							<tr style="background-color:###get_banner.BACK_COLOR#;">
								<td>
									<cfif len(banner_file) and not len(url_path)>
										<cfif len(url) and is_flash neq 1>
											<cfif banner_target eq 'popup'>
												<a href="javascript://" onClick="windowopen('#url#','online_contact','#listlast(url,'.')#');" title="#banner_name#">
											<cfelse>
												<cfif url contains 'popup_flvplayer'>
													<a href="javascript://" onClick="windowopen('#url#','video');" title="#banner_name#">
												<cfelseif url contains '.html'>
													<a href="javascript://" onClick="windowopen('#url#','wwide');" title="#banner_name#">
												<cfelse>
													<a href="#url#" target="#banner_target#" title="#banner_name#">
												</cfif>
											</cfif>
												<cfif len(banner_height) and len(banner_width)>
													<img src="/documents/content/banner/#banner_file#" width="#banner_width#" height="#banner_height#" alt="#banner_name#" title="#banner_name#" />
												<cfelse>
													<img src="/documents/content/banner/#banner_file#" alt="#banner_name#" title="#banner_name#" />
												</cfif>
											</a> 
										<cfelseif is_flash neq 1 and not len(url)>
											<cfif len(banner_height) and len(banner_width)>
												<img src="/documents/content/banner/#banner_file#" width="#banner_width#" height="#banner_height#" alt="#banner_name#" title="#banner_name#" />
											<cfelse>
												<img src="/documents/content/banner/#banner_file#" alt="#banner_name#" title="#banner_name#" />
											</cfif>
										<cfelse>
											<cfset banner_swf_path = ListFirst(banner_file,'.')>
											<script src="/JS/AC_RunActiveContent.js" type="text/javascript"></script>
											<script type="text/javascript">
												AC_FL_RunContent( 'codebase','','width','#banner_width#','height','#banner_height#','src','/documents/content/banner/#banner_swf_path#','quality','high','wmode','transparent','pluginspage','','flashvars','movie','/documents/content/banner/#banner_swf_path#' ); //end AC code
											</script>
											<noscript>
											<object <cfif len(banner_width)>width="#banner_width#"</cfif> <cfif len(banner_height)>height="#banner_height#"</cfif> classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">
												<param name="movie" value='/documents/content/banner/#banner_file#" output_type="4">'/>
												<param name="wmode" value="transparent"/>
												<param name="quality" value="high"/>
												<embed src='/documents/content/banner/#banner_file#' quality="high" type="application/x-shockwave-flash" <cfif len(banner_width)>width="#banner_width#"</cfif> <cfif len(banner_height)>height="#banner_height#"</cfif> wmode="transparent"></embed>
											</object>
											</noscript>
										</cfif>
									<cfelseif len(url_path)>
										<cfif (len(url)) and (is_flash neq 1)>
											<a href="#url#" target="#banner_target#" title="#banner_name#">
												<cfif len(banner_height) and len(banner_width)>
													<img src="/documents/content/banner/#banner_file#" width="#banner_width#" height="#banner_height#" alt="#banner_name#" title="#banner_name#" />
												<cfelse>
													<img src="/documents/content/banner/#banner_file#" alt="#banner_name#" title="#banner_name#" />
												</cfif>
											</a> 
										<cfelseif (is_flash neq 1) and (not len(url))>
											<cfif len(banner_height) and len(banner_width)>
												<img src="/documents/content/banner/#banner_file#" width="#banner_width#" height="#banner_height#" alt="#banner_name#" title="#banner_name#" />
											<cfelse>
												<img src="/documents/content/banner/#banner_file#" alt="#banner_name#" title="#banner_name#" />
											</cfif>
										<cfelse>
											<cfset banner_swf_path = ListFirst(#banner_file#,'.')>
											<script src="/JS/AC_RunActiveContent.js" type="text/javascript"></script>
											<script type="text/javascript">
												AC_FL_RunContent( 'codebase','','width','#banner_width#','height','#banner_height#','src','/documents/content/banner/#banner_swf_path#','quality','high','wmode','transparent','pluginspage','','flashvars','movie','/documents/content/banner/#banner_swf_path#' ); //end AC code
											</script>
											<noscript>
											<object <cfif len(banner_width)>width="#banner_width#"</cfif> <cfif len(banner_height)>height="#banner_height#"</cfif> classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">
												<param name="movie" value='/documents/content/banner/#banner_file#' />
												<param name="wmode" value="transparent"/>
												<param name="quality" value="high"/>
												<embed src='/documents/content/banner/#banner_file#' quality="high" type="application/x-shockwave-flash" <cfif len(banner_width)>width="#banner_width#"</cfif> <cfif len(banner_height)>height="#banner_height#"</cfif> wmode="transparent"></embed>
											</object>
											</noscript>
										</cfif>
									</cfif>
								</td>
							</tr>
							<tr height="5"><td>&nbsp;</td></tr>
						</cfloop>
					</cfoutput>
				</table>
			</cfif>
		</cfsavecontent>
		
		<cfreturn bannerDetail>
    </cffunction>
    
    <!--- ihracat rakamlari --->
	<cffunction name="ihracatRakamlari" access="public" returntype="any">

        <cfhttp url="http://www.tim.org.tr/ftp/ihrkayit/Tablo.htm" method="GET" resolveurl="Yes" charset="iso-8859-9"/>
        <cfscript>
            GetAllTr = REMatch("<tr.+?</tr>", cfhttp.filecontent);
            ResultTr2 = GetAllTr[2];
            GetAllTr2= REMatch("<td.+?</td>", ResultTr2);
            
            ResultTr2_Td2 = GetAllTr2[2];
            Date1 = REMatch(">(.+?)<",ResultTr2_Td2);
            Date1 = replacelist(ArrayToList(Date1),">,<"," , ");
            
            ResultTr2_Td4 = GetAllTr2[4];
            Date3 = REMatch(">(.+?)<",ResultTr2_Td4);
            Date3 = replacelist(ArrayToList(Date3),">,<"," , ");
            
            ResultTr26 = GetAllTr[26];
            GetAllTr26= REMatch("<td.+?</td>", ResultTr26);
            ResultTr26_Td3 = GetAllTr26[3];
            ResultTr26_Td3 = REMatch(">(.+?)<",ResultTr26_Td3);
            ResultTr26_Td3 = replacelist(ArrayToList(ResultTr26_Td3),">,<"," , ");
            
            ResultTr26_Td9 = GetAllTr26[9];
            ResultTr26_Td9 = REMatch(">(.+?)<",ResultTr26_Td9);
            ResultTr26_Td9 = replacelist(ArrayToList(ResultTr26_Td9),">,<"," , ");
            
            ResultTr26_Td1 = GetAllTr26[1];
            ResultTr26_Td1 = REMatch('</span>(.+?)<',ResultTr26_Td1);
            ResultTr26_Td1 = replacelist(ArrayToList(ResultTr26_Td1),">,<,/span"," , , ");
        
            
            ResultTr3 = GetAllTr[3];
            GetAllTr3= REMatch("<td.+?</td>", ResultTr3);
            ResultTr3_Td10 = GetAllTr3[10];
            ResultTr3_Td10 = REMatch(">(.+?)<",ResultTr3_Td10);
            ResultTr3_Td10 = replacelist(ArrayToList(ResultTr3_Td10),">,<"," , ");
            
            ResultTr3_Td11 = GetAllTr3[11];
            ResultTr3_Td11 = REMatch(">(.+?)<",ResultTr3_Td11);
            ResultTr3_Td11 = replacelist(ArrayToList(ResultTr3_Td11),">,<"," , ");
            
            
            ResultTr26_Td10 = GetAllTr26[10];
            ResultTr26_Td10 = REMatch(">(.+?)<",ResultTr26_Td10);
            ResultTr26_Td10 = replacelist(ArrayToList(ResultTr26_Td10),">,<"," , ");
            
            ResultTr26_Td11 = GetAllTr26[11];
            ResultTr26_Td11 = REMatch(">(.+?)<",ResultTr26_Td11);
            ResultTr26_Td11 = replacelist(ArrayToList(ResultTr26_Td11),">,<"," , ");
        
        </cfscript>
        <cfsavecontent variable="message">
            <cfoutput>
            <table width="100%">
                <tr>
                    <td><font style="font-weight:bold" color="red">#ResultTr26_Td1#</font> 
                    <b>#Date1# : </b><font size="+1">#ResultTr26_Td3# | </font>
                    <b>#Date3# : </b><font size="+1">#ResultTr26_Td9# | </font>
                    <b>#ResultTr3_Td10# : </b><font size="+1">#ResultTr26_Td10# | </font> 
                    <b>#ResultTr3_Td11# : </b><font size="+1">#ResultTr26_Td11#</font> 
                    <font size="+1" color="red">(1000 ABD Doları)</font> 
                    </td>
                </tr>
            </table>
       		</cfoutput>
        </cfsavecontent>
        <cfreturn message>
    
    </cffunction>
</cfcomponent>
