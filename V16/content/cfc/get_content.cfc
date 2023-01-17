<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_content_list_fnc" returntype="query">
		<cfargument name="record_member_id" default="">
		<cfargument name="record_member" default="">
		<cfargument name="language_id" default="">
		<cfargument name="keyword" default="">
		<cfargument name="stage_id" default="">
		<cfargument name="priority" default="">
		<cfargument name="status" default="">
		<cfargument name="content_property_id" default="">
		<cfargument name="cat" default="">
		<cfargument name="record_date" default="">
		<cfargument name="user_friendly_url" default="">
		<cfargument name="ana_sayfa" default="">
		<cfargument name="ana_sayfayan" default="">
		<cfargument name="bolum_basi" default="">
		<cfargument name="bolum_yan" default="">
		<cfargument name="ch_bas" default="">
		<cfargument name="ch_yan" default="">
		<cfargument name="none_tree" default="">
		<cfargument name="is_viewed" default="">
		<cfargument name="order_type" default="">
		<cfargument name="spot" default="">
		<cfargument name="cntid" default="">
		<cfargument name="is_training" default="">
		<cfargument name="is_rule_popup" default="">
		<cfargument name="is_fulltext_search" default="">
		<cfargument name="mail_c" default="">
		<cfargument name="cont_st" default="" >
		<cfargument name="meta_title" default="">
		<cfargument name="meta_keyword" default="">
		<cfargument name="meta_head" default="">
		<!--- Arguments.together Together anasayfada bulunan widget için eklenmiştir. --->
		<cfif isdefined("arguments.together")>
			<cfif isdefined("session.pp")>
				<cfset session_base = evaluate('session.pp')>
				<cfset session_base.period_is_integrated = 0>
			<cfelseif isdefined("session.ep")>
				<cfset session_base = evaluate('session.ep')>
			<cfelseif isdefined("session.ww")>
				<cfset session_base = evaluate('session.ww')>
			</cfif>
		</cfif>
		<cfif isdefined("cat") and len(cat)>
			<cfif listgetat(cat,1,"-") is "cat">
				<cfset cont_st = "cat">
			<cfelse>
				<cfset cont_st = "ch">
			</cfif>
		</cfif>
		<cfif not (isdefined("cntid") and len(cntid)) and (not isdefined("arguments.mail_c"))>
			<cfquery name="GET_CONTENT" datasource="#DSN#" result="deneme">
				SELECT
				DISTINCT
					<!---C.CATALOG_ID,--->
					C.PROCESS_STAGE,
					C.SPOT,
					C.IS_VIEWED,
					C.INTERNET_VIEW,
					C.CONTENT_ID,
					C.CONT_HEAD,
					C.CONT_BODY,
					C.CONTENT_PROPERTY_ID,
					C.RECORD_DATE,
					C.STAGE_ID,
					C.LANGUAGE_ID,
					C.CONTENT_STATUS,
					C.HIT,
					C.HIT_PARTNER,
					C.HIT_EMPLOYEE,
					C.HIT_GUEST,
					C.IS_RULE_POPUP,
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME,
					E.EMPLOYEE_ID,
					CC.CONTENTCAT,
					CC.CONTENTCAT_ID,
					CCH.CHAPTER,
					C.UPD_COUNT,
					C.RECORD_MEMBER
					<cfif len(arguments.meta_title) or len(arguments.meta_keyword) or len(arguments.meta_head)>
						,M.META_DESC_HEAD
					</cfif>
				FROM
					CONTENT C, 
					CONTENT_CHAPTER CCH,
					CONTENT_CAT CC,
					EMPLOYEES E
					<cfif len(arguments.meta_title) or len(arguments.meta_keyword) or len(arguments.meta_head)>
						,META_DESCRIPTIONS M
					</cfif>
				WHERE
					CC.CONTENTCAT_ID = CCH.CONTENTCAT_ID AND
					CCH.CHAPTER_ID = C.CHAPTER_ID AND
					CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">) AND
					E.EMPLOYEE_ID = C.RECORD_MEMBER
					<cfif len(arguments.meta_title) or len(arguments.meta_keyword) or len(arguments.meta_head)>
					AND	M.ACTION_ID=C.CONTENT_ID AND M.ACTION_TYPE = 'CONTENT_ID'
					</cfif>
					<cfif isdefined ("arguments.record_member_id") and len(arguments.record_member_id) and len(record_member)>
						AND C.RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_member_id#">
					</cfif> 
					<cfif isdefined ("arguments.language_id") and len(arguments.language_id)>
						AND C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#">
						<cfif isdefined('arguments.is_selected_lang') and (arguments.is_selected_lang eq 1)>    
							AND CC.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#">
						</cfif>
					</cfif>     
					<cfif isDefined("arguments.id")>AND C.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#"></cfif>
					<cfif not isDefined("arguments.keyword")>AND CC.CONTENTCAT_ID <> 0</cfif>
					<!---<cfif isdefined("stage_id") and len(stage_id)>AND C.STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stage_id#"></cfif>--->
					<cfif isdefined("arguments.stage_id") and len(arguments.stage_id)>AND C.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stage_id#"></cfif>
					<cfif isdefined("arguments.status") and arguments.status is 1>AND C.CONTENT_STATUS = 1</cfif>
					<cfif isdefined("arguments.status") and arguments.status is 2>AND C.CONTENT_STATUS = 0</cfif>
					<cfif isdefined("arguments.priority") and len(arguments.priority)>AND C.PRIORITY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.priority#"></cfif>
					<cfif isdefined("arguments.content_property_id") and len(arguments.content_property_id)>
						AND C.CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_property_id#">
					</cfif>
					<cfif not isDefined("arguments.cont_st")>AND CC.CONTENTCAT_ID <> 0</cfif>
					<cfif isDefined("arguments.cont_st") and arguments.cont_st is "ch">
						AND C.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.cat,2,"-")#">
					<cfelseif isDefined("arguments.cont_st") and arguments.cont_st is "cat">
						AND CCH.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.cat,2,"-")#">
					</cfif>
					<cfif isdefined ("arguments.record_date") and len(arguments.record_date)>
						AND C.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_date#">
						AND C.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("d",1,arguments.record_date)#">
					</cfif>
					<cfif isdefined("arguments.record_id") and len(arguments.record_id)>AND C.RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_id#"></cfif>
					<cfif isdefined("arguments.update_id") and len(arguments.update_id)>AND C.UPDATE_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.update_id#"></cfif>
					<cfif isdefined("arguments.spot") and len(arguments.spot)>AND C.SPOT = 1</cfif>
					<cfif isdefined("arguments.none_tree")>AND C.NONE_TREE = 1</cfif>
					<cfif isdefined("arguments.is_dsp_header")>AND C.IS_DSP_HEADER = 1</cfif>
					<cfif isdefined("arguments.is_dsp_summary")>AND C.IS_DSP_SUMMARY = 1</cfif>
					<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
						AND (
								<cfif isdefined("arguments.is_fulltext_search") and arguments.is_fulltext_search eq 1 >
									CONTAINS(C.*,'"#arguments.keyword#*"') COLLATE SQL_Latin1_General_CP1_CI_AI
								<cfelse>
									C.USER_FRIENDLY_URL LIKE <!---#sql_unicode()#--->'%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
									C.CONT_HEAD LIKE <!---#sql_unicode()#--->'%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
									C.CONT_SUMMARY LIKE <!---#sql_unicode()#--->'%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
									C.CONT_BODY LIKE <!---#sql_unicode()#--->'%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
								</cfif>
							)
							
					</cfif>
					<cfif isDefined("arguments.user_friendly_url") and len(arguments.user_friendly_url)>
						AND (C.USER_FRIENDLY_URL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.user_friendly_url#%">)
					</cfif>
					<cfif isdefined("arguments.ana_sayfa") and len(arguments.ana_sayfa)>
						AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%1%">
					</cfif>
					<cfif isdefined("arguments.ana_sayfayan") and len(arguments.ana_sayfayan)>
						AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%2%">
					</cfif>
					<cfif isdefined("arguments.bolum_basi") and len(arguments.bolum_basi)>
						AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%3%">
					</cfif>
					<cfif isdefined("arguments.bolum_yan") and len(arguments.bolum_yan)>
						AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%4%">
					</cfif>
					<cfif isdefined("arguments.ch_bas") and len(arguments.ch_bas)>
						AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%5%">
					</cfif>
					<cfif isdefined("arguments.ch_yan") and len(arguments.ch_yan)>
						AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%6%">
					</cfif>
					<cfif isdefined("arguments.none_tree") and len(arguments.none_tree)>
						AND C.NONE_TREE = 1
					</cfif>
					<cfif isdefined("arguments.is_viewed") and len(arguments.is_viewed)>
						AND C.IS_VIEWED = 1
					</cfif>
					<cfif isdefined("arguments.is_training") and arguments.is_training eq 1>
						AND CC.IS_TRAINING = 1
					</cfif>
				<cfif len(arguments.meta_title) or len(arguments.meta_keyword) or len(arguments.meta_head)>
					<cfif len(arguments.meta_title)>
						AND M.META_TITLE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.meta_title#%">
					</cfif>
					<cfif len(arguments.meta_keyword)>
						AND M.META_KEYWORDS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.meta_keyword#%">
					</cfif>
					<cfif len(arguments.meta_head)>
						AND M.META_DESC_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.meta_head#%">
					</cfif>
				</cfif>
					<cfif len(arguments.order_type) and isdefined("arguments.order_type") and arguments.order_type eq 1>
						ORDER BY C.RECORD_DATE DESC
					<cfelseif len(arguments.order_type) and isdefined("arguments.order_type") and arguments.order_type eq 2>
						ORDER BY C.PRIORITY ASC ,
						C.RECORD_DATE DESC
					<cfelseif len(arguments.order_type) and isdefined("arguments.order_type") and order_type eq 3>
						ORDER BY C.HIT DESC
					<cfelseif len(arguments.order_type) and isdefined("arguments.order_type") and order_type eq 4>
						ORDER BY C.HIT_PARTNER DESC
					<cfelseif len(arguments.order_type) and isdefined("arguments.order_type") and order_type eq 5>
						ORDER BY C.HIT_EMPLOYEE DESC
					<cfelseif len(arguments.order_type) and isdefined("arguments.order_type") and order_type eq 6>
						ORDER BY C.HIT_GUEST DESC
					</cfif>
			</cfquery>
		<cfelse>
			<cfquery name="GET_CONTENT" datasource="#DSN#">
				SELECT <cfif isdefined("arguments.together") and isdefined("arguments.list_content_maxrow") and len(arguments.list_content_maxrow)>TOP #arguments.list_content_maxrow#</cfif>
					<!---C.CATALOG_ID,--->
					C.SPOT,
					C.IS_VIEWED,
					C.INTERNET_VIEW,
					C.CAREER_VIEW,
					C.EMPLOYEE_VIEW,
					C.COMPANY_CAT,
					C.CONSUMER_CAT,
					C.POSITION_CAT_IDS,
					C.USER_GROUP_IDS,
					C.CONT_POSITION,
					C.NONE_TREE,
					C.CHAPTER_ID,
					C.IS_DSP_HEADER,
					C.IS_DSP_SUMMARY,
					C.CONT_SUMMARY,
					C.USER_FRIENDLY_URL,
					C.VIEW_DATE_START,
					C.VIEW_DATE_FINISH,
					C.PRIORITY,
					C.PROCESS_STAGE,
					C.OUTHOR_EMP_ID,
					C.OUTHOR_PAR_ID,
					C.OUTHOR_CONS_ID,
					C.WRITING_DATE,
					C.WRITE_VERSION,
					C.VERSION_DATE,
					C.CONT_BODY,
					C.UPD_COUNT,
					C.UPDATE_MEMBER,
					C.UPDATE_DATE,
					C.CONTENT_ID,
					C.CONT_HEAD,
					C.CONTENT_PROPERTY_ID,
					C.RECORD_DATE,
					C.STAGE_ID,
					C.LANGUAGE_ID,
					C.CONTENT_STATUS,
					C.HIT,
					C.HIT_PARTNER,
					C.HIT_EMPLOYEE,
					C.HIT_GUEST,
					C.IS_RULE_POPUP,
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME,
					E.EMPLOYEE_ID,
					CC.CONTENTCAT_ID, 
					CCH.CHAPTER,
					CC.CONTENTCAT,
					C.RECORD_MEMBER
					<cfif len(arguments.meta_title) or len(arguments.meta_keyword) or len(arguments.meta_head)>
						,M.META_DESC_HEAD
					</cfif>
				FROM 
					EMPLOYEES E,
					CONTENT C,
					CONTENT_CAT CC,
					CONTENT_CHAPTER CCH
				<cfif len(arguments.meta_title) or len(arguments.meta_keyword) or len(arguments.meta_head)>
					,META_DESCRIPTIONS M 
				</cfif>
				WHERE 
					C.CHAPTER_ID = CCH.CHAPTER_ID	AND 
					CCH.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
					E.EMPLOYEE_ID = C.RECORD_MEMBER
				<cfif len(arguments.meta_title) or len(arguments.meta_keyword) or len(arguments.meta_head)>
					 AND M.ACTION_ID=C.CONTENT_ID AND M.ACTION_TYPE = 'CONTENT_ID'
				</cfif>

					<cfif isdefined("session.ep.company_id")>AND CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">)</cfif>
				<cfif isdefined('arguments.record_member_id') and len(arguments.record_member_id) and  isdefined('arguments.record_member') and len(arguments.record_member)>
					AND C.RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_member_id#">
				</cfif> 
				<cfif isdefined("arguments.content_property_id") and len(arguments.content_property_id)>
						AND C.CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_property_id#">
				</cfif>
				<cfif not isDefined("arguments.cont_st")>AND CC.CONTENTCAT_ID <> 0</cfif>
					<cfif isDefined("arguments.cont_st") and arguments.cont_st is "ch">
						AND C.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.cat,2,"-")#">
					<cfelseif isDefined("arguments.cont_st") and arguments.cont_st is "cat">
						AND CCH.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.cat,2,"-")#">
				</cfif> 
				<cfif isdefined("arguments.status") and arguments.status is 1>AND C.CONTENT_STATUS = 1</cfif>
					<cfif isdefined("arguments.status") and arguments.status is 2>AND C.CONTENT_STATUS = 0</cfif>	  
				<cfif isDefined("arguments.cntid") and len(arguments.cntid)>
					AND C.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cntid#">
				</cfif>
				<cfif isdefined ("arguments.language_id") and len(arguments.language_id)>
					AND C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#">
					<cfif isdefined('arguments.is_selected_lang') and (arguments.is_selected_lang eq 1)>    
						AND CC.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#">
					</cfif>
				</cfif>  
				<cfif isdefined("arguments.stage_id") and len(arguments.stage_id)>AND 
				      C.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stage_id#">
				</cfif>
				<cfif isdefined("arguments.priority") and len(arguments.priority)>AND 
				      C.PRIORITY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.priority#">
				</cfif>
				<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
					AND (
							<cfif isdefined("arguments.is_fulltext_search") and arguments.is_fulltext_search eq 1 >
								CONTAINS(C.*,'"#arguments.keyword#*"') COLLATE SQL_Latin1_General_CP1_CI_AI
							<cfelse>
								C.USER_FRIENDLY_URL LIKE <!---#sql_unicode()#--->'%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
								C.CONT_HEAD LIKE <!---#sql_unicode()#--->'%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
								C.CONT_SUMMARY LIKE <!---#sql_unicode()#--->'%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
								C.CONT_BODY LIKE <!---#sql_unicode()#--->'%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
							</cfif>
						)
				</cfif>
				<cfif isDefined("arguments.user_friendly_url") and len(arguments.user_friendly_url)>
					AND (C.USER_FRIENDLY_URL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.user_friendly_url#%">)
				</cfif>
				<cfif isdefined("arguments.ana_sayfa") and len(arguments.ana_sayfa)>
					AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%1%">
				</cfif>
				<cfif isdefined("arguments.ana_sayfayan") and len(arguments.ana_sayfayan)>
					AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%2%">
				</cfif>
				<cfif isdefined("arguments.bolum_basi") and len(arguments.bolum_basi)>
					AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%3%">
				</cfif>
				<cfif isdefined("arguments.bolum_yan") and len(arguments.bolum_yan)>
					AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%4%">
				</cfif>
				<cfif isdefined("arguments.ch_bas") and len(arguments.ch_bas)>
					AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%5%">
				</cfif>
				<cfif isdefined("arguments.ch_yan") and len(arguments.ch_yan)>
					AND C.CONT_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%6%">
				</cfif>
				<cfif isdefined("arguments.none_tree") and len(arguments.none_tree)>
					AND C.NONE_TREE = 1
				</cfif>
				<cfif isdefined("arguments.is_viewed") and len(arguments.is_viewed)>
					AND C.IS_VIEWED = 1
				</cfif>
				<cfif isdefined("arguments.is_training") and arguments.is_training eq 1>
					AND CC.IS_TRAINING = 1
				</cfif>
				<cfif isdefined("session.pp.company_category") and isdefined("arguments.together")>
					AND C.STAGE_ID = -2	 
					AND C.CONTENT_STATUS = 1
					AND C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#">
					AND ','+C.COMPANY_CAT+','  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session_base.company_category#%">
					AND
					(
						<cfif isDefined("arguments.list_content_chapter_id") and len(arguments.list_content_chapter_id)>
							(C.CHAPTER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.list_content_chapter_id#" list="yes">))
						<cfelse>
							CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">) 
						</cfif>
					AND INTERNET_VIEW = 1)	
					<cfif isDefined("arguments.list_content_cat_id") and len(arguments.list_content_cat_id)>
						AND CCH.CONTENTCAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.list_content_cat_id#" list="yes">)
					</cfif> 				
				<cfelseif isdefined("session.ww.consumer_category") and isdefined("arguments.together")>
					AND C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#">
					AND ','+C.CONSUMER_CAT+','  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session_base.consumer_category#%">
					AND CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">)
				<cfelseif isdefined("session.cp") and isdefined("arguments.together")>
					AND C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#">
					AND C.CAREER_VIEW = 1
					AND CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">)
				</cfif>
				<cfif len(arguments.meta_title) or len(arguments.meta_keyword) or len(arguments.meta_head)>
					<cfif len(arguments.meta_title)>
						AND M.META_TITLE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.meta_title#%">
					</cfif>
					<cfif len(arguments.meta_keyword)>
						AND M.META_KEYWORDS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.meta_keyword#%">
					</cfif>
					<cfif len(arguments.meta_head)>
						AND M.META_DESC_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.meta_head#%">
					</cfif>
				</cfif>
				ORDER BY 
					<cfif isdefined("arguments.together")>
						C.UPDATE_DATE DESC,
						C.RECORD_DATE DESC
					<cfelse>
						C.CONTENT_ID DESC
					</cfif>
			</cfquery>
		</cfif>
		<cfreturn GET_CONTENT>
	</cffunction>
	<cffunction name="GET_LANGUAGE" access="remote" returntype="any">
		<cfquery name="GET_LANGUAGE" datasource="#DSN#">
			SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE
		</cfquery>
		<cfreturn GET_LANGUAGE>
	</cffunction>
	<cffunction name="GET_CONTENT_PROCESS_STAGES" access="remote" returntype="query">
		<cfargument name="faction" default="content.">
		<cfquery name="GET_CONTENT_PROCESS_STAGES" datasource="#DSN#">
			SELECT 
				PTR.PROCESS_ROW_ID AS STAGE_ID,
				PTR.STAGE STAGE_NAME 
			FROM 
				PROCESS_TYPE PT, 
				PROCESS_TYPE_ROWS PTR 
			WHERE
				PT.IS_ACTIVE = 1 AND
				PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.faction#%"> AND
				PT.PROCESS_ID = PTR.PROCESS_ID
		</cfquery>
		<cfreturn GET_CONTENT_PROCESS_STAGES>
	</cffunction>
	<cffunction  name="GET_PROPERTY_NAME" access="remote" returntype="any">
		<cfargument name="content_property_id_list" default="">
		<cfquery name="GET_PROPERTY_NAME" datasource="#DSN#">
			SELECT NAME,CONTENT_PROPERTY_ID FROM CONTENT_PROPERTY WHERE CONTENT_PROPERTY_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.content_property_id_list#">) ORDER BY CONTENT_PROPERTY_ID 
		</cfquery>
		<cfreturn GET_PROPERTY_NAME>
	</cffunction>
	<cffunction  name="GET_CONTENT_PROCESS_STAGE" access="remote" returntype="any">
		<cfargument name="stage_id_list" default="">
		<cfquery name="GET_CONTENT_PROCESS_STAGE" datasource="#DSN#">
			SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.stage_id_list#">) ORDER BY PROCESS_ROW_ID
		</cfquery>
		<cfreturn GET_CONTENT_PROCESS_STAGE>
	</cffunction>
	<cffunction  name="POSITIONCATEGORIES" access="remote" returntype="any">
		<cfquery name="POSITIONCATEGORIES" datasource="#dsn#">
			SELECT 
				* 
			FROM 
				SETUP_POSITION_CAT 
			ORDER BY 
				POSITION_CAT
		</cfquery>
		<cfreturn POSITIONCATEGORIES>
	</cffunction>
	<cffunction  name="GET_COMPANY_PARTNER" access="remote" returntype="public">
		<cfargument name="outhor_par_id" default="">
		<cfquery name="GET_COMPANY_PARTNER" datasource="#DSN#">
			SELECT COMPANY_ID FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.outhor_par_id#">
		</cfquery>
		<cfreturn GET_COMPANY_PARTNER>
	</cffunction>
	<cffunction  name="CONTENT_INST" access="remote" returntype="any">
		<cfargument name="content_property_id" default="">
		<cfargument name="comp_cat" default="">
		<cfargument name="cunc_cat" default="">
		<cfargument name="position_cat_ids" default="">
		<cfargument name="user_group_ids" default="">
		<cfargument name="outhor_emp_id" default="">
		<cfargument name="outhor_par_id" default="">
		<cfargument name="outhor_cons_id" default="">
		<cfargument name="writing_date" default="">
		<cfargument name="write_version" default="">
		<cfargument name="version_date" default="">
		<cfargument name="cont_body" default="">
		<cfargument name="summary" default="">
		<cfargument name="subject" default="">
		<cfargument name="chapter" default="">
		<cfargument name="company_id" default="">
		<cfargument name="internet_view" default="">
		<cfargument name="career_view" default="">
		<cfargument name="status" default="">
		<cfargument name="none_tree" default="">
		<cfargument name="is_dsp_header" default="">
		<cfargument name="is_dsp_summary" default="">
		<cfargument name="employee_view" default="">
		<cfargument name="is_rule_popup" default="">
		<cfargument name="is_viewed" default="">
		<cfargument name="view_date_start" default="">
		<cfargument name="view_date_finish" default="">
		<cfargument name="process_stage" default="">
		<cfargument name="spot" default="">
		<cfargument name="language_id" default="">
		<cfquery name="CONTENT_INST" datasource="#dsn#" result="MAX_ID">
            INSERT INTO 
                CONTENT 
            (
                WRITING_DATE,
                WRITE_VERSION,
                VERSION_DATE,
                CONT_BODY, 
                CONT_SUMMARY, 
                CONT_HEAD, 
                CONT_POSITION,
                CHAPTER_ID, 
				CONTENT_PROPERTY_ID,
                COMPANY_CAT,
                CONSUMER_CAT,
                POSITION_CAT_IDS,
                USER_GROUP_IDS,
                OUTHOR_EMP_ID,
                OUTHOR_PAR_ID,
                OUTHOR_COMPANY_PAR_ID,
                OUTHOR_CONS_ID,
                INTERNET_VIEW,
                CAREER_VIEW,
                CONTENT_STATUS,
                NONE_TREE,
                IS_DSP_HEADER,
                IS_DSP_SUMMARY,
                PRIORITY,
                EMPLOYEE_VIEW,
                IS_RULE_POPUP,
                IS_VIEWED,
                VIEW_DATE_START,
                VIEW_DATE_FINISH,
                PROCESS_STAGE,
                STAGE_ID,
                SPOT,
                HIT,
                HIT_EMPLOYEE,
                HIT_PARTNER,
                HIT_GUEST,
                LANGUAGE_ID,
                RECORD_MEMBER, 
                RECORD_IP,
                RECORD_DATE          
            )
            VALUES 
            (    
    
                <cfif isdate(arguments.writing_date)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.writing_date#"><cfelse>NULL</cfif>,
                <cfif isDefined("arguments.write_version") and len(arguments.write_version)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.write_version#"><cfelse>NULL</cfif>,
                <cfif isdate(arguments.version_date)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.version_date#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cont_body#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.summary#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subject#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CNT_POS#">,
                <cfif isDefined("arguments.chapter") and len(arguments.chapter)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.chapter#"><cfelse>0</cfif>,
                <cfif isDefined("arguments.content_property_id") and len(arguments.content_property_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_property_id#"><cfelse>NULL</cfif>,
                <cfif isDefined("arguments.COMP_CAT")><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DDCOMP_CAT#"><cfelse>NULL</cfif>,
                <cfif isDefined("arguments.CUNC_CAT")><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DCUNC_CAT#"><cfelse>NULL</cfif>,
                <cfif isDefined("arguments.position_cat_ids")><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.position_cat_ids#"><cfelse>NULL</cfif>,
                <cfif isDefined("arguments.user_group_ids")><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.user_group_ids#"><cfelse>NULL</cfif>,
                <cfif isDefined("arguments.outhor_emp_id") and len(arguments.outhor_emp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.outhor_emp_id#"><cfelse>NULL</cfif>,
                <cfif isDefined("arguments.outhor_par_id") and len(arguments.outhor_par_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.outhor_par_id#"><cfelse>NULL</cfif>,
                <cfif isDefined("arguments.outhor_par_id") and len(arguments.outhor_par_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_company_partner.company_id#"><cfelse>NULL</cfif>,
                <cfif isDefined("arguments.outhor_cons_id") and len(arguments.outhor_cons_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.outhor_cons_id#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.internet_view") and len(arguments.internet_view)>1<cfelse>0</cfif>,
                <cfif isdefined("arguments.career_view") and len(arguments.career_view)>1<cfelse>0</cfif>,
                <cfif isDefined("arguments.status") and len(arguments.status)>1<cfelse>0</cfif>,
                <cfif isDefined("arguments.none_tree") and len(arguments.none_tree)>1<cfelse>0</cfif>,
                <cfif isDefined("arguments.is_dsp_header") and len(arguments.is_dsp_header)>1<cfelse>0</cfif>,
                <cfif isDefined("arguments.is_dsp_summary") and len(arguments.is_dsp_summary)>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.priority#">,
                <cfif isDefined("arguments.employee_view") and len(arguments.employee_view)>1<cfelse>0</cfif>,
                <cfif isDefined("arguments.is_rule_popup") and len(arguments.is_rule_popup)>1<cfelse>0</cfif>,
                <cfif isDefined("arguments.is_viewed") and len(arguments.is_viewed)>1<cfelse>0</cfif>, 					
                <cfif len(arguments.view_date_start)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.view_date_start#"><cfelse>NULL</cfif>,
                <cfif len(arguments.view_date_finish)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.view_date_finish#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                1,
                <cfif isdefined("arguments.spot") and len(arguments.spot)>1<cfelse>0</cfif>,
                0,
                0,
                0,
                0,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">, 
                <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            )
		</cfquery>
		<cfreturn MAX_ID>
	</cffunction>
	<cffunction  name="ADD_CONTENT_RELATION" access="remote" returntype="any">
		<cfargument name="action_type" default="">
		<cfargument name="action_type_id" default="">
		<cfquery name="ADD_CONTENT_RELATION" datasource="#DSN#">
			INSERT INTO
				CONTENT_RELATION
			(
				ACTION_TYPE,
				ACTION_TYPE_ID,
				CONTENT_ID,
				COMPANY_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES 
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_type_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.ep.UserID#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
		</cfquery>
		<cfreturn 1>
	</cffunction>
	<cffunction  name="CONTENT_INST_UPD" access="remote" returntype="any">
		<cfargument name="user_friendly_url" default="">
		<cfargument name="cont_body" default="">
		<cfargument name="summary" default="">
		<cfargument name="subject" default="">
		<cfargument name="cnt_pos" default="">
		<cfargument name="process_stage" default="">
		<cfargument name="chapter" default="">
		<cfargument name="content_property_id" default="">
		<cfargument name="comp_cat" default="">
		<cfargument name="none_tree" default="">
		<cfargument name="cunc_cat" default="">
		<cfargument name="position_cat_ids" default="">
		<cfargument name="is_dsp_header" default="">
		<cfargument name="user_group_ids" default="">
		<cfargument name="is_dsp_summary" default="">
		<cfargument name="status" default="">
		<cfargument name="internet_view" default="">
		<cfargument name="career_view" default="">
		<cfargument name="employee_view" default="">
		<cfargument name="is_viewed" default="">
		<cfargument name="is_rule_popup" default="">
		<cfargument name="view_date_start" default="">
		<cfargument name="view_date_finish" default="">		
		<cfargument name="outhor_emp_id" default="">
		<cfargument name="outhor_par_id" default="">
		<cfargument name="priority" default="">
		<cfargument name="outhor_cons_id" default="">
		<cfargument name="writing_date" default="">
		<cfargument name="write_version" default="">
		<cfargument name="version_date" default="">
		<cfargument name="cntid" default="">
		<cfargument name="company_id" default="">
		<cfargument name="spot" default="">
		<cfargument name="language_id" default="">
		<cfargument name="is_autofill" default="">
		<cfargument name="upd_count" default="">
		<cfquery name="CONTENT_INST" datasource="#DSN#">
			UPDATE 
				CONTENT  
			SET
				USER_FRIENDLY_URL = <cfif isDefined("arguments.user_friendly_url") and len(arguments.user_friendly_url) or arguments.is_autofill eq 1><cfqueryparam cfsqltype="cf_sql_varchar" value="#user_friendly_url#"><cfelse>NULL</cfif>,<!--- buradaki degisken cf_workcube_user_friendly isimli customtagden gelir --->
				CONT_BODY = <cfif isDefined("arguments.cont_body") and len(arguments.cont_body)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cont_body#"><cfelse>NULL</cfif>,
				CONT_SUMMARY = <cfif isDefined("arguments.summary") and len(arguments.summary)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.summary#"><cfelse>NULL</cfif>,
				CONT_HEAD = <cfif isDefined("arguments.subject") and len(arguments.subject)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subject#"><cfelse>NULL</cfif>,
				CONT_POSITION =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cnt_pos#">,
				PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
				CHAPTER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.chapter#">,
				CONTENT_PROPERTY_ID = <cfif len(arguments.content_property_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_property_id#"><cfelse>NULL</cfif>,
				COMPANY_CAT = <cfif isDefined("arguments.comp_cat")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#arguments.comp_cat#,"><cfelse>''</cfif>,
				CONSUMER_CAT = <cfif isDefined("arguments.cunc_cat")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#arguments.cunc_cat#,"><cfelse>''</cfif>,
				POSITION_CAT_IDS = <cfif isDefined("arguments.position_cat_ids")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#arguments.position_cat_ids#,"><cfelse>NULL</cfif>,
				USER_GROUP_IDS = <cfif isDefined("arguments.user_group_ids")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#arguments.user_group_ids#,"><cfelse>NULL</cfif>,
				NONE_TREE = <cfif isDefined("arguments.none_tree") and len(arguments.none_tree)>1<cfelse>0</cfif>,
				IS_DSP_HEADER = <cfif isDefined("arguments.is_dsp_header") and len(arguments.is_dsp_header)>1<cfelse>0</cfif>,
				IS_DSP_SUMMARY = <cfif isDefined("arguments.is_dsp_summary") and len(arguments.is_dsp_summary)>1<cfelse>0</cfif>,
				CONTENT_STATUS = <cfif isDefined("arguments.status") and len(arguments.status)>1<cfelse>0</cfif>,
				INTERNET_VIEW = <cfif isDefined("arguments.internet_view") and len(arguments.internet_view)>1<cfelse>0</cfif>,
				CAREER_VIEW = <cfif isDefined("arguments.career_view") and len(arguments.career_view)>1<cfelse>0</cfif>,
				EMPLOYEE_VIEW = <cfif isDefined("arguments.employee_view") and len(arguments.employee_view)>1<cfelse>0</cfif>,
				IS_VIEWED = <cfif isDefined("arguments.is_viewed") and len(arguments.is_viewed)>1<cfelse>0</cfif>,
				IS_RULE_POPUP = <cfif isDefined("arguments.is_rule_popup") and len(arguments.is_rule_popup)>1<cfelse>0</cfif>,
				VIEW_DATE_START = <cfif len(arguments.view_date_start)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.view_date_start#"><cfelse>NULL</cfif>,
				VIEW_DATE_FINISH = <cfif len(arguments.view_date_finish)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.view_date_finish#"><cfelse>NULL</cfif>,
				OUTHOR_EMP_ID = <cfif isDefined("arguments.outhor_emp_id") and len(arguments.outhor_emp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.outhor_emp_id#"><cfelse>NULL</cfif>,
				OUTHOR_PAR_ID = <cfif isdefined("arguments.outhor_par_id") and len(arguments.outhor_par_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.outhor_par_id#"><cfelse>NULL</cfif>,
				OUTHOR_COMPANY_PAR_ID = <cfif isDefined("arguments.outhor_par_id") and len(arguments.outhor_par_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_company_partner.COMPANY_ID#"><cfelse>NULL</cfif>,
				OUTHOR_CONS_ID = <cfif isDefined("arguments.outhor_cons_id") and len(arguments.outhor_cons_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.outhor_cons_id#"><cfelse>NULL</cfif>,
				WRITING_DATE = <cfif isDate(arguments.writing_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.writing_date#"><cfelse>NULL</cfif>,
				WRITE_VERSION = <cfif isDefined("arguments.write_version") and len(arguments.write_version)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.write_version#"><cfelse>NULL</cfif>,
				VERSION_DATE = <cfif isDate(arguments.version_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.version_date#"><cfelse>NULL</cfif>,
				PRIORITY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.priority#">,
				<!---GUEST = <cfqueryparam cfsqltype="cf_sql_bit" value="#VARIABLES.INT_CAT#">,--->
				UPDATE_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,					
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				UPD_COUNT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.upd_count#">,
				SPOT = <cfif isdefined("arguments.spot") and len(arguments.spot)>1<cfelse>0</cfif>,
				LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#">
			WHERE 
				CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cntid#">
		</cfquery>
		<cfreturn cntid>
	</cffunction>
	<cffunction  name="GET_UPD_COUNT" access="public" returntype="query">
		<cfargument name="cntid" default="">
		<cfquery name="GET_UPD_COUNT" datasource="#DSN#">
			SELECT ISNULL(UPD_COUNT,0) UPD_COUNT FROM CONTENT  WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cntid#">
		</cfquery>
		<cfreturn GET_UPD_COUNT>
	</cffunction>	
	<cffunction  name="get_content" access="remote" returntype="query">
		<cfargument name="cntid" default="">
		<cfquery name="get_content" datasource="#dsn#">
			SELECT CONT_HEAD as HEAD FROM CONTENT WHERE CONTENT_ID = #arguments.CNTID#
		</cfquery>
		<cfreturn get_content>
	</cffunction>
	<cffunction  name="DEL_CONTENT" access="remote" returntype="any">
		<cfargument name="cntid" default="">
		<cfquery name="DEL_CONTENT" datasource="#dsn#">
			DELETE FROM CONTENT WHERE CONTENT_ID = #arguments.CNTID#
		</cfquery>
	</cffunction>
	<cffunction  name="del_content_history" access="remote" returntype="any">
		<cfargument name="cntid" default="">
		<cfquery name="del_content_history" datasource="#dsn#">
			DELETE FROM CONTENT_HISTORY WHERE CONTENT_ID = #arguments.CNTID#
		</cfquery>
	</cffunction>
	<cffunction  name="del_user_friendly" access="remote" returntype="any">
		<cfargument name="cntid" default="">
		<cfquery name="del_user_friendly" datasource="#dsn#">
			DELETE FROM USER_FRIENDLY_URLS WHERE ACTION_ID = #arguments.CNTID# AND ACTION_TYPE = 'CONTENT_ID'
		</cfquery>
	</cffunction>
	<cffunction  name="DEL_CONTENTS" access="remote" returntype="any">
		<cfargument name="content_id" default="">
		<cfquery name="DEL_CONTENTS" datasource="#DSN#">
			DELETE FROM
				CONTENT
			WHERE
				CONTENT_ID = #arguments.content_id#
		</cfquery>
	</cffunction>
	<cffunction  name="GET_POSITION_CATS" access="remote" returntype="query">
		<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
			SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
		</cfquery>
		<cfreturn GET_POSITION_CATS>
	</cffunction>
	<cffunction  name="GET_USER_GROUPS" access="remote" returntype="query">
		<cfquery name="GET_USER_GROUPS" datasource="#DSN#">
			SELECT USER_GROUP_ID,USER_GROUP_NAME FROM USER_GROUP ORDER BY USER_GROUP_NAME
		</cfquery>
		<cfreturn GET_USER_GROUPS>
	</cffunction>
	<cffunction  name="GET_CAT" access="remote" returntype="query">
		<cfquery name="GET_CAT" datasource="#DSN#">
			SELECT TEMPLATE_ID,TEMPLATE_HEAD FROM TEMPLATE_FORMS WHERE TEMPLATE_MODULE = 2
		</cfquery>
		<cfreturn GET_CAT>
	</cffunction>
	<cffunction  name="GET_HISTORY" access="remote" returntype="query">
		<cfargument name="cnth_id" default="">
		<cfquery name="GET_HISTORY" datasource="#DSN#">
			SELECT 
				CONT_BODY, 
				IS_DSP_SUMMARY, 
				CAREER_VIEW, 
				SPOT, 
				CONTENT_STATUS,
				CONTENT_ID, 
				<!---GUEST,---> 
				PRIORITY, 
				INTERNET_VIEW, 
				VIEW_DATE_START, 
				VIEW_DATE_FINISH, 
				IS_VIEWED, 
				EMPLOYEE_VIEW,
				IS_DSP_HEADER, 
				NONE_TREE, 
				CONSUMER_CAT, 
				POSITION_CAT_IDS, 
				USER_GROUP_IDS, 
				CONT_SUMMARY,
				CONT_HEAD, 
				CONT_POSITION, 
				STAGE_ID,
				CHAPTER_ID, 
				COMPANY_CAT, 
				CONTENT_PROPERTY_ID 
			FROM 
				CONTENT_HISTORY 
			WHERE 
				CONTENT_HISTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cnth_id#">
		</cfquery>
		<cfreturn GET_HISTORY>
	</cffunction>
	<cffunction  name="GET_CONTENT_CAT" access="public" returntype="query">
		<cfquery name="GET_CONTENT_CAT" datasource="#dsn#">
			SELECT DISTINCT
				#dsn#.Get_Dynamic_Language(CONTENT_CAT.CONTENTCAT_ID,'#session.ep.language#','CONTENT_CAT','CONTENTCAT',NULL,NULL,CONTENT_CAT.CONTENTCAT) AS CONTENTCAT, CONTENT_CAT.CONTENTCAT_ID 
			FROM 
				CONTENT_CAT 
					LEFT JOIN 
				CONTENT_CAT_COMPANY ON CONTENT_CAT.CONTENTCAT_ID = CONTENT_CAT_COMPANY.CONTENTCAT_ID 
			WHERE 
				<!--- <cfif isdefined('x_is_selected_language') and (x_is_selected_language eq 1)>
					CONTENT_CAT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#"> AND
				</cfif> --->
				(CONTENT_CAT_COMPANY.COMPANY_ID = #session.ep.company_id#) and 
				CONTENT_CAT.CONTENTCAT_ID <> 0									
		</cfquery>
		<cfreturn GET_CONTENT_CAT>
	</cffunction>
	<cffunction  name="GetCompanyCat" access="public" returntype="query">
		<cfquery name="get_company_cat" datasource="#dsn#">
			SELECT 
				COMPANYCAT_ID, 
				COMPANYCAT 
			FROM 
				COMPANY_CAT							
		</cfquery>
		<cfreturn get_company_cat>
	</cffunction>
	<cffunction  name="GetCustomerCat" access="public" returntype="query">
		<cfquery name="get_customer_cat" datasource="#DSN#">
			SELECT 
				CONSCAT_ID, 
				CONSCAT 
			FROM 
				CONSUMER_CAT
				<!--- Ekleme sayfasından geliyorsa kategorinin aktiflik durumuna bakıyor --->		
				<cfif isdefined("form_add")>
					WHERE
						IS_ACTIVE = 1
				</cfif>
			ORDER BY
				HIERARCHY	
		</cfquery>
		<cfreturn get_customer_cat>
	</cffunction>
	<cffunction  name="GetContentCat" access="public" returntype="query">
		<cfquery name="get_content_cat" datasource="#DSN#">
			SELECT  DISTINCT
				CC.CONTENTCAT_ID, 
				CONTENTCAT 
			FROM 
				CONTENT_CAT CC
			WHERE 
				CC.CONTENTCAT_ID <> 0 AND
				(
					CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">)
				)	
			ORDER BY 
				CONTENTCAT
		</cfquery>
		<cfreturn get_content_cat>
	</cffunction>
	<cffunction  name="SetupTemplate" access="public" returntype="query">
		<cfargument name="template_id" default="">
		<cfquery name="setup_template" datasource="#DSN#">
			SELECT
				TEMPLATE_CONTENT
			FROM
				TEMPLATE_FORMS
			<cfif isDefined("attributes.template_id") and len(attributes.template_id)>		
			WHERE
				TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.template_id#">
			</cfif>
		</cfquery>
		<cfreturn setup_template>
	</cffunction>
	<cffunction name="get_related_questions" access="public" returntype="any">
		<cfargument name="cntid" default="">
		<cfquery name="get_related_questions" datasource="#DSN#">
			SELECT
                CQ.QUESTION_ID,
                Q.QUESTION
            FROM
                CONTENT_QUESTIONS CQ
                    INNER JOIN QUESTION Q ON Q.QUESTION_ID = CQ.QUESTION_ID
            WHERE
                CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cntid#">
		</cfquery>
		<cfreturn get_related_questions>
	</cffunction>
	<cffunction name="del_related_questions" access="public" returntype="any">
		<cfargument name="cntid" default="">
		<cfargument name="question_id" default="">
		<cfquery name="del_related_questions" datasource="#DSN#">
            DELETE FROM
                CONTENT_QUESTIONS
            WHERE
                CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cntid#">
                AND
                QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.question_id#">
		</cfquery>
	</cffunction>
	<cffunction name="add_related_questions" access="public" returntype="any">
		<cfargument name="id_list" default="">
            <cftry>
                <cfset responseStruct = structNew()>
                    <cfloop from="1" to="#listlen(arguments.id_list)#" index="i">
                        <cfset CONTENT_ID = listfirst(listgetat(arguments.id_list,i,','),';')>
                        <cfset QUESTION_ID = listlast(listgetat(arguments.id_list,i,','),';')>
                        <cfquery name="get_related_questions" datasource="#dsn#">
                            SELECT
                                QUESTION_ID
                            FROM
                                CONTENT_QUESTIONS
                            WHERE
                                CONTENT_ID=#CONTENT_ID#
                            AND
                                QUESTION_ID=#QUESTION_ID#
                        </cfquery>
                        
                        <cfif NOT get_related_questions.RecordCount>
                            <cfquery name="add_related_questions" datasource="#dsn#">
                                INSERT INTO
                                    CONTENT_QUESTIONS
                                    (
                                        CONTENT_ID,
                                        QUESTION_ID
                                    )
                                VALUES
                                    (
                                        #CONTENT_ID#,
                                        #QUESTION_ID#
                                    )
                            </cfquery>
                        </cfif>
                    </cfloop>
                <cfset responseStruct.message = "İşlem Başarılı">
                <cfset responseStruct.status = true>
                <cfset responseStruct.error = {}>
                <cfset responseStruct.identity = ''>
            <cfcatch type="database">
                    <cftransaction action="rollback">
                    <cfset responseStruct.message = "İşlem Hatalı">
                    <cfset responseStruct.status = false>
                    <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>
    <cfreturn responseStruct>
	</cffunction>
	<cffunction name="get_publish_page" access="public" returntype="query">
        <cfquery name="get_publish_page" datasource="#dsn#">
			 WITH PAGE_ AS( --Action'ın yayınlanabileceği page ler
                    SELECT DISTINCT
                        PG.PAGE_ID,
                        PG.SITE,
                        PG.TITLE,
                        ST.DOMAIN,
                        ST.COMPANY
                    FROM 
                        PROTEIN_PAGES PG
                        LEFT JOIN USER_FRIENDLY_URLS UFU ON PG.PAGE_ID = UFU.PROTEIN_PAGE 
                        LEFT JOIN PROTEIN_SITES ST ON PG.SITE = ST.SITE_ID
                    WHERE
                        PG.PAGE_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"RELATED_WO":"#arguments.faction#"%'>
                        AND PG.PAGE_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"EVENT":"#arguments.event#"%'>
                        AND PG.STATUS = 1
                        AND ST.STATUS = 1
                ),
                PAGE_A AS(-- Var ise set edilen frienldy url datalarını uygun pagelrin yanına getirir
                    SELECT
                        PAGE_.PAGE_ID,
                        PAGE_.SITE,
                        PAGE_.TITLE,
                        PAGE_.DOMAIN,
                        PAGE_.COMPANY,
                        PG_AVAIABLE.USER_FRIENDLY_URL FRIENDLY_URL,
                        PG_AVAIABLE.OPTIONS_DATA,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#"> AS ACTION_TYPE,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AS ACTION_ID,
                        ISNULL(PG_AVAIABLE.STATUS,-1) STATUS,
                        PG_AVAIABLE.USER_URL_ID
                    FROM
                        PAGE_
                        LEFT JOIN USER_FRIENDLY_URLS PG_AVAIABLE ON 
                        PAGE_.PAGE_ID = PG_AVAIABLE.PROTEIN_PAGE
                        AND PG_AVAIABLE.ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">
                        AND PG_AVAIABLE.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                )
                
                SELECT 
                    *,
                    '#arguments.event#' EVENT
                FROM
                    PAGE_A
        </cfquery>
		<cfreturn get_publish_page>
    </cffunction>
</cfcomponent>