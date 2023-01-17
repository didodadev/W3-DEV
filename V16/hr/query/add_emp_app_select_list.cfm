<cfif (isdefined("attributes.exp_year_s1") and len(attributes.exp_year_s1)) or (isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2))>
	<cfquery name="get_work_info" datasource="#dsn#">
		SELECT 
			EMPAPP_ID,
			SUM(EXP_FARK)/365 
		FROM 
			EMPLOYEES_APP_WORK_INFO 
		GROUP BY 
			EMPAPP_ID 
		HAVING 
			<cfif isdefined("attributes.exp_year_s1") and len(attributes.exp_year_s1)>Sum(EXP_FARK)/365 >= #exp_year_s1#<cfif  isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2)>AND</cfif></cfif>
			<cfif isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2)>Sum(EXP_FARK)/365 <= #exp_year_s2#</cfif>
	</cfquery>
	<cfif get_work_info.recordcount>
		<cfset  exp_app_list = valuelist(get_work_info.empapp_id,',')>
	<cfelse>
		<cfset  exp_app_list = 0>
	</cfif>
</cfif>
<cfif not isDefined("attributes.list_id") and isDefined("attributes.LIST_EMPAPP_ID")>
	<cfset attributes.list_id = attributes.LIST_EMPAPP_ID>
</cfif>
<cfif ((isdefined("attributes.edu3") and len(attributes.edu3)) or (isdefined("attributes.edu3_part") and len(attributes.edu3_part))) or ((isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))) or ((isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id))) or (isdefined("attributes.edu_finish") and len(attributes.edu_finish))>
	<cfquery name="get_edu_info" datasource="#dsn#">
		SELECT
			EMPAPP_ID
		FROM
			EMPLOYEES_APP_EDU_INFO
		WHERE
			EMPAPP_ID IS NOT NULL
			AND(
		<cfif (isdefined("attributes.edu3") and len(attributes.edu3)) or (isdefined("attributes.edu3_part") and len(attributes.edu3_part))>	
			(EDU_TYPE = 3
			<cfif isdefined("attributes.edu3") and len(attributes.edu3)>
				AND EDU_NAME LIKE '%#attributes.edu3#%' 
			</cfif>
			<cfif isdefined("attributes.edu3_part") and len(attributes.edu3_part)>
				AND EDU_PART_ID = #attributes.edu3_part# 
			</cfif>
			)
		</cfif>
		<cfif ((isdefined("attributes.edu3") and len(attributes.edu3)) or (isdefined("attributes.edu3_part") and len(attributes.edu3_part))) and (((isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))) or ((isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id))))>
			OR
		</cfif>
		<cfif ((isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))) or ((isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id)))>
			(EDU_TYPE = 4
			<cfif (isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))>
				AND
				(	
					<cfif isdefined("attributes.edu4") and len(attributes.edu4)>
						<cfset count=0>
						<cfloop list="#attributes.edu4#" delimiters="," index="i">
						<cfset count=count+1>
						<cfif count gt 1> OR </cfif>
						 EDU_NAME LIKE '%#i#%' 
						</cfloop>
					</cfif>
					<cfif isdefined("attributes.edu4_id") and len(attributes.edu4_id)>
						<cfif isdefined('count')>OR</cfif> 
						EDU_ID IN (#attributes.edu4_id#)
					</cfif>
				)
			</cfif>
			<cfif (isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id))>
				AND
				(	
				<cfif isdefined("attributes.edu4_part") and len(attributes.edu4_part)>
					<cfset count2=0>
					<cfloop list="#attributes.edu4_part#" delimiters="," index="i">
					<cfset count2=count2+1>
					<cfif count2 gt 1> OR </cfif>
					   EDU_PART_NAME LIKE '%#i#%'
					</cfloop>
				</cfif>
				<cfif isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id)>
					<cfif isdefined('count2')>OR</cfif> 
					EDU_PART_ID IN (#attributes.edu4_part_id#)
				</cfif>
				)
			</cfif>
			)
		</cfif>
		)
		<cfif isdefined("attributes.edu_finish") and len(attributes.edu_finish)>
			AND	EDU_FINISH =#attributes.edu_finish#
		</cfif>
	</cfquery>
	<cfif get_edu_info.recordcount>
		<cfset  edu_app_list = listsort(valuelist(get_edu_info.empapp_id,','),"Numeric","ASC",',')>
	<cfelse>
		<cfset  edu_app_list = 0>
	</cfif>
</cfif>
<cfif isdefined("attributes.type") and attributes.type eq 1 and not isdefined("edu_app_list")>
	<cfset  edu_app_list = attributes.list_empapp_id>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
<cfif not isdefined('attributes.old')>
	<cfquery name="add_list" datasource="#dsn#">
	INSERT INTO
		EMPLOYEES_APP_SEL_LIST
		(LIST_NAME,
		LIST_DETAIL,
		LIST_STATUS,
		<cfif len(attributes.notice_id_list)>NOTICE_ID,</cfif>
		<cfif len(attributes.position_id_list)>POSITION_ID,</cfif>
		<cfif len(attributes.position_cat_id_list)>POSITION_CAT_ID,</cfif>
		<cfif len(attributes.company_list) and len(attributes.company_id_list)>COMPANY_ID,</cfif>
		<cfif len(attributes.our_company_id_list)>OUR_COMPANY_ID,</cfif>
		<cfif len(attributes.department_id_list) and len(attributes.department_list)>DEPARTMENT_ID,</cfif>
		<cfif len(attributes.branch_id_list) and len(attributes.branch_list)>BRANCH_ID,</cfif>
		<cfif len(attributes.pif_id)>PIF_ID,</cfif>
		SEL_LIST_STAGE,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP)
	VALUES
		(<cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.list_name#'>,
		<cfif isdefined('attributes.list_detail') and len(attributes.list_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value= '#attributes.list_detail#'><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_nvarchar"></cfif>,
		<cfif isdefined('attributes.list_status') and len(attributes.list_status)><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
		<cfif len(attributes.notice_id_list)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.notice_id_list#">,</cfif>
		<cfif len(attributes.position_id_list)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id_list#">,</cfif>
		<cfif len(attributes.position_cat_id_list)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id_list#">,</cfif> 
		<cfif len(attributes.company_list) and len(attributes.company_id_list)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id_list#">,</cfif>
		<cfif len(attributes.our_company_id_list)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id_list#">,</cfif>
		<cfif len(attributes.department_id_list) and len(attributes.department_list)>
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id_list#">,
		</cfif>
		<cfif  len(attributes.branch_id_list) and len(attributes.branch_list)>
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id_list#">,
		</cfif>
		<cfif len(attributes.pif_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pif_id#">,</cfif>
		<cfif len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_nvarchar"></cfif>,
		#now()#,
		#session.ep.userid#,
		'#cgi.REMOTE_ADDR#')
	</cfquery>
	<cfquery name="get_list" datasource="#dsn#">
		SELECT
			MAX(LIST_ID) AS MAX_LIST_ID
		FROM
			EMPLOYEES_APP_SEL_LIST
		WHERE 
			LIST_NAME='#attributes.list_name#'
	</cfquery>
	<!--- sürecin yetki sorunu nedeni ile action page değeri myhomedan yollanıyor--->	
	<cf_workcube_process 
		is_upd='1' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='EMPLOYEES_APP_SEL_LIST'
		action_column='LIST_ID'
		action_id='#get_list.MAX_LIST_ID#'
		action_page='#request.self#?fuseaction=myhome.upd_emp_app_select_list&list_id=#get_list.MAX_LIST_ID#'
		warning_description = 'Şeçim Listesi Kayıt : #attributes.list_name#'>
	
	<!---YETKİLİLER--->
	<!---uyarı için eklenen list_id veriliyor--->
	<cfset attributes.url_link=attributes.url_link&"&list_id=#get_list.MAX_LIST_ID#">
	<cfloop from="1" to="#attributes.record_count#" index="i">
		<cfif isdefined("WARNING_HEAD#i#")>
			<cfif isdefined("attributes.sms_startdate#i#") and len(evaluate("attributes.sms_startdate#i#"))>
				<cf_date tarih="attributes.sms_startdate#i#">
				<cfset SMS_WARNING_DATE = date_add('h',evaluate("attributes.SMS_START_CLOCK#i#")-session.ep.time_zone,evaluate("attributes.sms_startdate#i#"))>
				<cfset SMS_WARNING_DATE = date_add('n',evaluate("attributes.SMS_START_MIN#i#"),SMS_WARNING_DATE)>
			<cfelse>
				<cfset SMS_WARNING_DATE = "NULL">
			</cfif>
			<cfif isdefined("attributes.email_startdate#i#") and len(evaluate("attributes.email_startdate#i#"))>
				<cf_date tarih="attributes.email_startdate#i#">
				<cfset EMAIL_WARNING_DATE = date_add('h',evaluate("attributes.EMAIL_START_CLOCK#i#")-session.ep.time_zone,evaluate("attributes.email_startdate#i#"))>
				<cfset EMAIL_WARNING_DATE = date_add('n',evaluate("attributes.EMAIL_START_MIN#i#"),EMAIL_WARNING_DATE)>
			<cfelse>
				<cfset EMAIL_WARNING_DATE = "NULL">
			</cfif>
			
			<cfif isDefined("attributes.response_date#i#") and len(evaluate("attributes.response_date#i#"))>
				<cf_date tarih="attributes.response_date#i#">
				<cfset RESPONSE_DATE = date_add('h',evaluate("attributes.response_clock#i#")-session.ep.time_zone,evaluate("attributes.response_date#i#"))>
				<cfset RESPONSE_DATE = date_add('n',evaluate("attributes.response_min#i#"),RESPONSE_DATE)>
			<cfelse>
				<cfset RESPONSE_DATE = "NULL">
			</cfif>
			
			<cfquery name="add_warning" datasource="#dsn#">
				INSERT INTO
					PAGE_WARNINGS
					(
					URL_LINK,
					WARNING_HEAD,
					SETUP_WARNING_ID,
					WARNING_DESCRIPTION,
					SMS_WARNING_DATE,
					EMAIL_WARNING_DATE,
					LAST_RESPONSE_DATE,
					RECORD_DATE,
					IS_ACTIVE,
					IS_PARENT,
					RESPONSE_ID,
					RECORD_IP,
					RECORD_EMP,
					POSITION_CODE
					)
				VALUES
					(
					'#attributes.url_link#',
					'#ListGetAt(evaluate("WARNING_HEAD#i#"),1,"-")#',
					#ListGetAt(evaluate("WARNING_HEAD#i#"),2,"-")#,
					'#wrk_eval("attributes.WARNING_DESCRIPTION#i#")#',
					#SMS_WARNING_DATE#,
					#EMAIL_WARNING_DATE#,
					#RESPONSE_DATE#,
					#NOW()#,
					1,
					1,
					0,
					'#CGI.REMOTE_ADDR#',
					#SESSION.EP.USERID#,
				<cfif isdefined("attributes.position_code#i#") and isdefined("attributes.employee#i#") and len(evaluate("attributes.employee#i#")) and len(evaluate("attributes.position_code#i#"))>
					#evaluate("attributes.position_code#i#")#
				<cfelse>
					NULL
				</cfif>
					)
			</cfquery>
			<cfquery name="GET_WARNINGS" datasource="#dsn#">
				SELECT 
					Max(W_ID) AS max 
				FROM 
					PAGE_WARNINGS
			</cfquery>
			
			<cfquery name="GET_WARNINGS" datasource="#dsn#">
				UPDATE
					PAGE_WARNINGS 
				SET
					PARENT_ID = #GET_WARNINGS.max# 
				WHERE
					W_ID = #GET_WARNINGS.max#			
			</cfquery>
			<!---YETKİLİLER--->
			<cfif isdefined("attributes.position_code#i#") and isdefined("attributes.employee#i#") and len(evaluate("attributes.employee#i#")) and len(evaluate("attributes.position_code#i#"))>
				<cfquery name="get_authority" datasource="#dsn#">
					SELECT 
						POS_CODE
					FROM
						EMPLOYEES_APP_AUTHORITY
					WHERE
						LIST_ID=#get_list.max_list_id# AND
						POS_CODE=#evaluate("attributes.position_code#i#")#
				</cfquery>
				<cfif not get_authority.recordcount>
					<cfquery name="add_authoriyt" datasource="#dsn#">
						INSERT INTO
							EMPLOYEES_APP_AUTHORITY
							(
								AUTHORITY_TYPE,
								LIST_ID,
								POS_CODE
							)VALUES
							(
								1,
								#get_list.max_list_id#,
								#evaluate("attributes.position_code#i#")#
							)
					</cfquery>
				</cfif>
			</cfif>
			<!---YETKİLİLER--->
		</cfif>
	</cfloop>
<cfelseif isdefined('attributes.old') and attributes.old eq 1>
	<cfset get_list.MAX_LIST_ID=listFirst(attributes.list_id)>
</cfif>
<cfif isdefined("attributes.salary_wanted_money") and len(attributes.salary_wanted_money)>
	<cfquery name="GET_RATE" datasource="#dsn#">
		SELECT
			RATE1,
			RATE2,
			MONEY
		FROM
			SETUP_MONEY
		WHERE
			MONEY = '#Trim(attributes.salary_wanted_money)#'
			AND PERIOD_ID = #SESSION.EP.PERIOD_ID#
	</cfquery>
	<cfset RATE_MAIN =GET_RATE.RATE2/GET_RATE.RATE1>
</cfif>
<cfif isdefined("attributes.salary_wanted1") and len(attributes.salary_wanted1) and isdefined("RATE_MAIN")>
	<cfset money_min =attributes.salary_wanted1*RATE_MAIN>
</cfif>
<cfif isdefined("attributes.salary_wanted2") and len(attributes.salary_wanted2) and isdefined("RATE_MAIN")>
	<cfset money_max =attributes.salary_wanted2*RATE_MAIN>
</cfif>	
<cfif isdefined("attributes.birth_date2") and len(attributes.birth_date2)>
	<cfset attributes.date_dogum="01/01/#evaluate(session.ep.period_year-attributes.birth_date2)#">
	<cf_date tarih='attributes.date_dogum'>
</cfif>
<cfif isdefined("attributes.birth_date1") and len(attributes.birth_date1)>
	<cfset attributes.date_dogum_1="01/01/#evaluate(session.ep.period_year-attributes.birth_date1)#">
	<cf_date tarih='attributes.date_dogum_1'>
</cfif>
<cfif isdefined('attributes.search_app_pos') and attributes.search_app_pos eq 1 and isDefined('attributes.list_id') and cgi.HTTP_REFERER contains 'hr.list_cv'>
	<cfloop list="#attributes.list_id#" item="item"> <!--- seçim listesine ekliyor --->
		<cfset get_list = { MAX_LIST_ID: item }>
		<cfquery name="add_list_row_app" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_APP_SEL_LIST_ROWS
				(
					EMPAPP_ID,
					APP_POS_ID,
					STAGE,
					ROW_STATUS,
					LIST_ID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)	
			SELECT
				EMPLOYEES_APP.EMPAPP_ID,
				NULL,
				NULL,
				1,
				#GET_LIST.MAX_LIST_ID#,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			FROM
				EMPLOYEES_APP,
				EMPLOYEES_IDENTY
			WHERE
					EMPLOYEES_IDENTY.EMPAPP_ID=EMPLOYEES_APP.EMPAPP_ID
					AND EMPLOYEES_IDENTY.EMPAPP_ID IS NOT NULL
				<cfif isdefined('attributes.status') and len(attributes.status)>
					AND EMPLOYEES_APP.APP_STATUS = #attributes.status#
				<cfelseif isdefined("attributes.status_app") and len(attributes.status_app)>
					AND EMPLOYEES_APP.APP_STATUS = #attributes.status_app#
				</cfif>
				<cfif isdefined("attributes.app_name") and len(attributes.app_name)>
					AND EMPLOYEES_APP.NAME LIKE '%#attributes.app_name#%'
				</cfif>
				<cfif isdefined("attributes.app_surname") and len(attributes.app_surname)>
					AND EMPLOYEES_APP.SURNAME LIKE '%#attributes.app_surname#%'
				</cfif>
				<cfif isdefined("attributes.email") and len(attributes.email)>
					AND EMPLOYEES_APP.EMAIL LIKE '#attributes.email#'
				</cfif>
				<cfif isdefined("attributes.birth_date1") and len(attributes.birth_date1)>
					AND EMPLOYEES_IDENTY.BIRTH_DATE <= #attributes.date_dogum_1#
				</cfif>
				<cfif isdefined("attributes.birth_date2") and len(attributes.birth_date2)>
					AND EMPLOYEES_IDENTY.BIRTH_DATE >= #attributes.date_dogum#
				</cfif> 
				<cfif (isdefined("attributes.sex") and listlen(attributes.sex))>
					AND EMPLOYEES_APP.SEX IN (#listsort(attributes.sex,"NUMERIC")#) 
				</cfif>
				<cfif (isdefined("attributes.MARRIED") and listlen(attributes.MARRIED))>
					AND EMPLOYEES_IDENTY.MARRIED IN (#listsort(attributes.married,"NUMERIC")#)  
				</cfif>
				<cfif (isdefined("attributes.military_status") and listlen(attributes.military_status))>
					AND EMPLOYEES_APP.MILITARY_STATUS IN (#LISTSORT(attributes.military_status,"NUMERIC")#) 
				</cfif>
				<cfif isdefined("attributes.birth_place") and len(attributes.birth_place)>
					AND EMPLOYEES_IDENTY.BIRTH_PLACE LIKE '%#attributes.birth_place#%'
				</cfif>
				<cfif isdefined("attributes.city") and len(attributes.city)>
					AND EMPLOYEES_IDENTY.CITY LIKE '%#attributes.city#%'
				</cfif>
				<!--- <cfif isdefined("attributes.edu3") and len(attributes.edu3)>
					AND EMPLOYEES_APP.EDU3 LIKE '%#attributes.edu3#%'
				</cfif>
				<cfif isdefined("attributes.edu3_part") and len(attributes.edu3_part)>
					AND EMPLOYEES_APP.EDU3_PART IN (#attributes.edu3_part#)
				</cfif> --->
				<cfif isdefined("attributes.app_reply_date1") and len(attributes.app_reply_date1)>
				AND EMPLOYEES_APP.RECORD_DATE >= #attributes.app_reply_date1# 
				</cfif>
				<cfif isdefined("attributes.app_reply_date2") and len(attributes.app_reply_date2)>
				AND EMPLOYEES_APP.RECORD_DATE <= #attributes.app_reply_date2# 
				</cfif>
				<cfif isdefined("attributes.training_level") and len(attributes.training_level)>
					AND TRAINING_LEVEL IN (#attributes.training_level#)
					<!--- <cfif isdefined("attributes.edu_finish") and len(attributes.edu_finish)>
					AND	(EDU1_FINISH = #attributes.edu_finish#
						OR EDU2_FINISH = #attributes.edu_finish#  
						OR EDU3_FINISH = #attributes.edu_finish#  
						OR EDU4_FINISH = #attributes.edu_finish#
						OR EDU4_FINISH_2 = #attributes.edu_finish# 
						OR EDU5_FINISH = #attributes.edu_finish#
						OR EDU7_FINISH = #attributes.edu_finish#)
					</cfif> --->
				</cfif>
				<cfif isdefined("attributes.driver_licence_type") and len(attributes.driver_licence_type)>
					AND DRIVER_LICENCE_TYPE LIKE '%#attributes.driver_licence_type#%'
				</cfif>
				<cfif isdefined("attributes.driver_licence") and len(attributes.driver_licence)>
					AND (DRIVER_LICENCE <> '' OR DRIVER_LICENCE_TYPE <> '')
				</cfif>
				<cfif isdefined("attributes.sentenced") and len(attributes.sentenced)>
					AND SENTENCED = #attributes.sentenced#
				</cfif>
				<cfif isdefined("attributes.defected") and len(attributes.defected)>
				AND DEFECTED = #attributes.defected#
				</cfif>
				<cfif isdefined("attributes.defected_level") and attributes.defected_level gt 0>
				AND DEFECTED_LEVEL = #attributes.defected_level#
				</cfif>
				<cfif isdefined("attributes.is_trip") and len(attributes.is_trip)>
				AND IS_TRIP = #attributes.is_trip#
				</cfif>
				<cfif isdefined("attributes.referance") and len(attributes.referance)>
				AND
					(
					REF1 LIKE '%#attributes.referance#%' OR
					REF2 LIKE '%#attributes.referance#%' OR
					REF1_EMP LIKE '%#attributes.referance#%' OR
					REF2_EMP LIKE '%#attributes.referance#%'
					)
				</cfif>
				<cfif isdefined("attributes.homecity") and len(attributes.homecity)>
					AND HOMECITY IN (#attributes.homecity#)
				</cfif>
				<cfset city_count=0>
				<cfif isdefined("attributes.prefered_city") and len(attributes.prefered_city)>
					AND (
						<cfloop list="#attributes.prefered_city#" index="i" delimiters=",">
							PREFERED_CITY LIKE '%,#i#,%'
							<cfset city_count=city_count+1>
							<cfif listlen(attributes.prefered_city) neq city_count>
							OR
							</cfif>
						</cfloop>
						)
				</cfif>
				<cfif isdefined("attributes.kurs") and len(attributes.kurs)>
				<cfloop list="#attributes.kurs#" index="i">
					AND
					( KURS1 LIKE '%,#i#,%' OR
					KURS2 LIKE '%,#i#,%' OR
					KURS3 LIKE '%,#i#,%' )
				</cfloop>
				</cfif>
				
				<!--- <cfif isdefined("attributes.exp_year_s1") and len(attributes.exp_year_s1)>
					AND (EXP1_FARK+EXP2_FARK+EXP3_FARK+EXP4_FARK)/365 >= #attributes.exp_year_s1#
				</cfif>
				<cfif isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2)>
					AND	(EXP1_FARK+EXP2_FARK+EXP3_FARK+EXP4_FARK)/365 <= #attributes.exp_year_s2#
				</cfif> --->
				<cfif (isdefined("attributes.exp_year_s1") and len(attributes.exp_year_s1)) or (isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2))>
					AND EMPLOYEES_APP.EMPAPP_ID IN (#exp_app_list#)
				</cfif>
				<cfif isdefined("attributes.tool") and listlen(attributes.tool)>
					AND 
					(
					<cfloop list="#listsort(attributes.tool,'textnocase')#" index="tool_index">
						COMP_EXP LIKE '%#tool_index#%' <cfif ListLast(ListSort(attributes.tool,'textnocase')) neq "#Trim(tool_index)#">OR</cfif>
					</cfloop>
					)
				</cfif> 
				<cfif isdefined("attributes.lang") and len(attributes.lang)>
					AND
					(  
					<cfset lang_count=0>
					<cfloop list="#attributes.lang#" delimiters="," index="i">
						(
							(
								LANG1=#i# AND 
								(LANG1_SPEAK >=#attributes.lang_level# OR
								LANG1_MEAN >=#attributes.lang_level# OR
								LANG1_WRITE >=#attributes.lang_level#)
							) OR
							(
								LANG2=#i# AND
								(LANG2_SPEAK >=#attributes.lang_level# OR
								LANG2_MEAN >=#attributes.lang_level# OR
								LANG2_WRITE >=#attributes.lang_level#)
							) OR
							(
								LANG3=#i# AND
								(LANG3_SPEAK >=#attributes.lang_level# OR
								LANG3_MEAN >=#attributes.lang_level# OR
								LANG3_WRITE >=#attributes.lang_level#)
							) OR
							(
								LANG4=#i# AND
								(LANG4_SPEAK >=#attributes.lang_level# OR
								LANG4_MEAN >=#attributes.lang_level# OR
								LANG4_WRITE >=#attributes.lang_level#)
							) OR
							(
								LANG5=#i# AND
								(LANG5_SPEAK >=#attributes.lang_level# OR
								LANG5_MEAN >=#attributes.lang_level# OR
								LANG5_WRITE >=#attributes.lang_level#)
							)
						)
						<cfset lang_count=lang_count+1>
						<cfif listlen(attributes.lang) neq lang_count>
							#attributes.lang_par#
						</cfif>
					</cfloop>
					)
				</cfif>
				<cfif ((isdefined("attributes.edu3") and len(attributes.edu3)) or (isdefined("attributes.edu3_part") and len(attributes.edu3_part))) or ((isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))) or ((isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id))) or (isdefined("attributes.edu_finish") and len(attributes.edu_finish))>
					AND EMPLOYEES_APP.EMPAPP_ID IN (#edu_app_list#)

				</cfif>
				<!--- <cfif (isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))>
					AND (	
						<cfif isdefined("attributes.edu4") and len(attributes.edu4)>
							<cfset count=0>
							<cfloop list="#attributes.edu4#" delimiters="," index="i">
							<cfset count=count+1>
							<cfif count gt 1> OR </cfif>
							EDU4 LIKE '%#i#%' 
							</cfloop>
						</cfif>
						<cfif isdefined("attributes.edu4_id") and len(attributes.edu4_id)>
							<cfif isdefined('count')>OR</cfif>
							(EDU4_ID IN (#attributes.edu4_id#) OR EDU4_ID_2 IN (#attributes.edu4_id#))
						</cfif>
					)
				</cfif>
				
				<cfif (isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id))>
					AND
					(	
					<cfif isdefined("attributes.edu4_part") and len(attributes.edu4_part)>
						<cfset count2=0>
						<cfloop list="#attributes.edu4_part#" delimiters="," index="i">
						<cfset count2=count2+1>
						<cfif count2 gt 1> OR </cfif>
						EDU4_PART LIKE '%#i#%'
						</cfloop>
					</cfif>
					<cfif isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id)>
						<cfif isdefined('count2')>OR</cfif> 
						(EDU4_PART_ID IN (#attributes.edu4_part_id#)  OR EDU4_PART_ID_2 IN (#attributes.edu4_part_id#))
					</cfif>
					)
				</cfif> --->
		
					<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
					AND
					(
						EMPLOYEES_APP.NAME LIKE '%#attributes.keyword#%'
						OR
						EMPLOYEES_APP.SURNAME LIKE '%#attributes.keyword#%'
					)	
					</cfif>
					<cfif isdefined("attributes.commethod_id") and (attributes.commethod_id neq 0)>
						AND EMPLOYEES_APP.COMMETHOD_ID = #attributes.commethod_id#
					</cfif>	   
					<cfif isdefined("attributes.app_currency_id") and len(attributes.app_currency_id)>
						AND EMPLOYEES_APP.APP_CURRENCY_ID = #attributes.app_currency_id#
					</cfif>
					<cfif isdefined('attributes.martyr_relative') and len(attributes.martyr_relative)>AND EMPLOYEES_APP.MARTYR_RELATIVE =1</cfif>
					<cfif isdefined('attributes.other') and len(attributes.other)>
						AND
						( (EMPLOYEES_APP.EMPAPP_ID IN(SELECT DISTINCT EMPAPP_ID FROM EMPLOYEES_APP_WORK_INFO
						WHERE
						(EXP <cfif attributes.other_if eq 1>NOT</cfif> LIKE '%#attributes.other#%') OR
						(EXP_POSITION <cfif attributes.other_if eq 1>NOT</cfif> LIKE '%#attributes.other#%') OR
						(EXP_EXTRA <cfif attributes.other_if eq 1>NOT</cfif> LIKE '%#attributes.other#%')
						)
						)
						OR
						CLUB <cfif attributes.other_if eq 1>NOT</cfif> LIKE '%#attributes.other#%' OR
						APPLICANT_NOTES <cfif attributes.other_if eq 1>NOT</cfif> LIKE '%#attributes.other#%'
						)
					</cfif>
					<cfif isdefined("attributes.unit_id") and len(attributes.unit_id) and len(attributes.unit_row)>
						AND EMPLOYEES_APP.EMPAPP_ID IN(SELECT DISTINCT EAU.EMPAPP_ID FROM EMPLOYEES_APP_UNIT EAU
													WHERE 
														EAU.UNIT_ID IN (#attributes.unit_id#) 
														AND EAU.UNIT_ROW<=#attributes.unit_row#
														)
					</cfif>
				AND EMPLOYEES_APP.EMPAPP_ID NOT IN(SELECT EMPAPP_ID FROM EMPLOYEES_APP_SEL_LIST_ROWS WHERE LIST_ID=#get_list.max_list_id#)
				AND EMPLOYEES_APP.EMPAPP_ID IN(#attributes.list_empapp_id#)
		</cfquery>
	</cfloop>
</cfif>

<cfif isdefined('attributes.search_app_pos') and attributes.search_app_pos eq 1 and isDefined('attributes.list_id')>
	<cfloop list="#attributes.list_id#" item="item"><!---başvuruları ekliyor--->
		<cfset get_list = { MAX_LIST_ID: item }>
        <cfquery name="add_list_row_pos" datasource="#dsn#">
            INSERT INTO
                EMPLOYEES_APP_SEL_LIST_ROWS
                (
                    EMPAPP_ID,
                    APP_POS_ID,
                    STAGE,
                    ROW_STATUS,
                    LIST_ID,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
            SELECT
                EMPLOYEES_APP.EMPAPP_ID,
                EMPLOYEES_APP_POS.APP_POS_ID,
                NULL,
                1,
                #GET_LIST.MAX_LIST_ID#,
                #now()#,
                #session.ep.userid#,
                '#cgi.REMOTE_ADDR#'
            FROM
                EMPLOYEES_APP,
                EMPLOYEES_APP_POS,
                EMPLOYEES_IDENTY
            WHERE
                EMPLOYEES_APP.EMPAPP_ID=EMPLOYEES_APP_POS.EMPAPP_ID
                AND EMPLOYEES_IDENTY.EMPAPP_ID=EMPLOYEES_APP.EMPAPP_ID
                AND EMPLOYEES_IDENTY.EMPAPP_ID=EMPLOYEES_APP_POS.EMPAPP_ID
                <cfif (isdefined("attributes.salary_wanted1") and len(attributes.salary_wanted1)) or (isdefined("attributes.salary_wanted2") and len(attributes.salary_wanted2))>
                    AND (EMPLOYEES_APP_POS.SALARY_WANTED*#RATE_MAIN#) BETWEEN #money_min# AND #money_max#
                <cfelseif (isdefined("attributes.salary_wanted1") and len(attributes.salary_wanted1)) and not (isdefined("attributes.salary_wanted2")and len(attributes.salary_wanted2)) >
                    AND (EMPLOYEES_APP_POS.SALARY_WANTED*#RATE_MAIN#) >= #money_min#
                <cfelseif (isdefined("attributes.salary_wanted2") and len(attributes.salary_wanted2)) and not (isDefined("attributes.salary_wanted1") and len(attributes.salary_wanted1))>
                    AND (EMPLOYEES_APP_POS.SALARY_WANTED*#RATE_MAIN#) <= #money_max#
                </cfif>
                <cfif isdefined("attributes.app_date1") and len(attributes.app_date1) and not (isdefined("attributes.app_date2") and len(attributes.app_date2))>
                AND EMPLOYEES_APP_POS.APP_DATE >= #attributes.app_date1#
                </cfif>
                <cfif isdefined("attributes.app_date2") and len(attributes.app_date2) and not (isdefined("attributes.app_date1") and len(attributes.app_date1))>
                AND EMPLOYEES_APP_POS.APP_DATE <= #attributes.app_date2#
                </cfif>
                <cfif (isdefined("attributes.app_date1") and len(attributes.app_date1)) and (isdefined("attributes.app_date2") and len(attributes.app_date2))>
                AND (EMPLOYEES_APP_POS.APP_DATE  BETWEEN #attributes.app_date1#  AND #attributes.app_date2#)
                </cfif>
                <cfset city_count=0>
                <cfif isdefined("attributes.prefered_city") and len(attributes.prefered_city)>
                    AND (
                    <cfloop list="#attributes.prefered_city#" index="i" delimiters=",">
                        PREFERED_CITY LIKE '%,#i#,%'
                        <cfset city_count=city_count+1>
                        <cfif listlen(attributes.prefered_city) neq city_count>
                            OR
                        </cfif>
                    </cfloop>
                    )
                </cfif>
                <cfif isdefined("attributes.notice_id") and len(attributes.notice_id)>
                AND EMPLOYEES_APP_POS.NOTICE_ID = #attributes.notice_id#
                </cfif>
                <cfif (isdefined("attributes.position_id") and len(attributes.position_id)) and (isdefined("attributes.app_position") and len(attributes.app_position))>
                    AND EMPLOYEES_APP_POS.POSITION_ID = #attributes.position_id#
                </cfif>
                <cfif (isdefined("attributes.POSITION_CAT_ID") and len(attributes.POSITION_CAT_ID)) and (isdefined("attributes.POSITION_CAT") and len(attributes.POSITION_CAT))>
                    AND EMPLOYEES_APP_POS.POSITION_CAT_ID = #attributes.POSITION_CAT_ID#
                </cfif>
                <cfif isdefined('attributes.status') and len(attributes.status)>
                    AND EMPLOYEES_APP.APP_STATUS = #attributes.status#
                <cfelseif isdefined('attributes.status_app_pos') and len(attributes.status_app_pos)>
                    AND EMPLOYEES_APP_POS.APP_POS_STATUS = #attributes.status_app_pos#
                </cfif>
                <cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
                    AND EMPLOYEES_APP_POS.COMPANY_ID=#attributes.company_id#
                </cfif>
                <cfif isdefined("attributes.department") and len(attributes.department) and isdefined('attributes.department_id') and len(attributes.department_id)>
                    AND EMPLOYEES_APP_POS.DEPARTMENT_ID=#attributes.department_id#
                </cfif>
                <cfif isdefined("attributes.branch") and len(attributes.branch) and isdefined('attributes.branch_id') and len(attributes.branch_id)>
                    AND EMPLOYEES_APP_POS.BRANCH_ID=#attributes.branch_id#
                    <cfif isdefined('attributes.our_company_id') and len(attributes.our_company_id)>
                        AND EMPLOYEES_APP_POS.OUR_COMPANY_ID=#attributes.our_company_id#
                    </cfif>
                </cfif>
            <cfif (isdefined("attributes.sex") and listlen(attributes.sex))>
                AND EMPLOYEES_APP.SEX IN (#listsort(attributes.sex,"NUMERIC")#)
            </cfif>
            <cfif (isdefined("attributes.MARRIED") and listlen(attributes.MARRIED))>
                AND EMPLOYEES_IDENTY.MARRIED IN (#listsort(attributes.married,"NUMERIC")#)
            </cfif>
            <cfif (isdefined("attributes.military_status") and listlen(attributes.military_status))>
                AND EMPLOYEES_APP.MILITARY_STATUS IN (#LISTSORT(attributes.military_status,"NUMERIC")#)
            </cfif>
            <cfif isdefined("attributes.birth_place") and len(attributes.birth_place)>
                AND EMPLOYEES_IDENTY.BIRTH_PLACE LIKE '%#attributes.birth_place#%'
            </cfif>
            <cfif isdefined("attributes.city") and len(attributes.city)>
                AND EMPLOYEES_IDENTY.CITY LIKE '%#attributes.city#%'
            </cfif>
            <cfif (((isdefined("attributes.edu3") and len(attributes.edu3)) or (isdefined("attributes.edu3_part") and len(attributes.edu3_part))) or ((isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))) or ((isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id))) or (isdefined("attributes.edu_finish") and len(attributes.edu_finish))) or isdefined("edu_app_list")>
                AND EMPLOYEES_APP.EMPAPP_ID IN (#edu_app_list#)
            </cfif>
            <cfif isdefined("attributes.lang") and len(attributes.lang)>
                AND
                (
                <cfset lang_count=0>
                <cfloop list="#attributes.lang#" delimiters="," index="i">
                    (
                        (
                            LANG1=#i# AND
                            (LANG1_SPEAK >=#attributes.lang_level# OR
                            LANG1_MEAN >=#attributes.lang_level# OR
                            LANG1_WRITE >=#attributes.lang_level#)
                        ) OR
                        (
                            LANG2=#i# AND
                            (LANG2_SPEAK >=#attributes.lang_level# OR
                            LANG2_MEAN >=#attributes.lang_level# OR
                            LANG2_WRITE >=#attributes.lang_level#)
                        ) OR
                        (
                            LANG3=#i# AND
                            (LANG3_SPEAK >=#attributes.lang_level# OR
                            LANG3_MEAN >=#attributes.lang_level# OR
                            LANG3_WRITE >=#attributes.lang_level#)
                        ) OR
                        (
                            LANG4=#i# AND
                            (LANG4_SPEAK >=#attributes.lang_level# OR
                            LANG4_MEAN >=#attributes.lang_level# OR
                            LANG4_WRITE >=#attributes.lang_level#)
                        ) OR
                        (
                            LANG5=#i# AND
                            (LANG5_SPEAK >=#attributes.lang_level# OR
                            LANG5_MEAN >=#attributes.lang_level# OR
                            LANG5_WRITE >=#attributes.lang_level#)
                        )
                    )
                    <cfset lang_count=lang_count+1>
                    <cfif listlen(attributes.lang) neq lang_count>
                        #attributes.lang_par#
                    </cfif>
                </cfloop>
                )
            </cfif>
            <cfif (isdefined("attributes.exp_year_s1") and len(attributes.exp_year_s1)) or (isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2))>
                AND EMPLOYEES_APP.EMPAPP_ID IN (#exp_app_list#)
            </cfif>
            <cfif isdefined("attributes.driver_licence_type") and len(attributes.driver_licence_type)>
                AND DRIVER_LICENCE_TYPE LIKE '%#attributes.driver_licence_type#%'
            </cfif>
            <cfif isdefined("attributes.driver_licence") and len(attributes.driver_licence)>
                AND (DRIVER_LICENCE <> '' OR DRIVER_LICENCE_TYPE <> '')
            </cfif>
            <cfif isdefined("attributes.sentenced") and len(attributes.sentenced)>
                AND SENTENCED = #attributes.sentenced#
            </cfif>
            <cfif isdefined("attributes.defected") and len(attributes.defected)>
            AND DEFECTED = #attributes.defected#
            </cfif>
            <cfif isdefined("attributes.defected_level") and attributes.defected_level gt 0>
            AND DEFECTED_LEVEL = #attributes.defected_level#
            </cfif>
            <cfif isdefined("attributes.is_trip") and len(attributes.is_trip)>
            AND IS_TRIP = #attributes.is_trip#
            </cfif>
            <cfif isdefined("attributes.referance") and len(attributes.referance)>
            AND
                (
                REF1 LIKE '%#attributes.referance#%' OR
                REF2 LIKE '%#attributes.referance#%' OR
                REF1_EMP LIKE '%#attributes.referance#%' OR
                REF2_EMP LIKE '%#attributes.referance#%'
                )
            </cfif>
            <cfif isdefined("attributes.homecity") and len(attributes.homecity)>
                AND HOMECITY IN (#attributes.homecity#)
            </cfif>
            <cfif len(attributes.list_app_pos_id)>
            AND EMPLOYEES_APP_POS.APP_POS_ID IN (#attributes.list_app_pos_id#)
            </cfif>
            <cfif isdefined('attributes.old')>
                AND EMPLOYEES_APP.EMPAPP_ID NOT IN(SELECT EMPAPP_ID FROM EMPLOYEES_APP_SEL_LIST_ROWS WHERE LIST_ID=#get_list.max_list_id#)
            </cfif>
        </cfquery>
    </cfloop>
</cfif>
<cfif isdefined('attributes.search_app') and attributes.search_app eq 1><!---özgeçmişleri ekliyor--->
	<cfloop list="#attributes.list_id#" item="item">
		<cfset get_list = { MAX_LIST_ID: item }>
		<cfquery name="add_list_row_app" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_APP_SEL_LIST_ROWS
				(
					EMPAPP_ID,
					APP_POS_ID,
					STAGE,
					ROW_STATUS,
					LIST_ID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)	
			SELECT
				EMPLOYEES_APP.EMPAPP_ID,
				NULL,
				NULL,
				1,
				#GET_LIST.MAX_LIST_ID#,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			FROM
				EMPLOYEES_APP,
				EMPLOYEES_IDENTY
			WHERE
					EMPLOYEES_IDENTY.EMPAPP_ID=EMPLOYEES_APP.EMPAPP_ID
					AND EMPLOYEES_IDENTY.EMPAPP_ID IS NOT NULL
				<cfif isdefined('attributes.status') and len(attributes.status)>
					AND EMPLOYEES_APP.APP_STATUS = #attributes.status#
				<cfelseif isdefined("attributes.status_app") and len(attributes.status_app)>
					AND EMPLOYEES_APP.APP_STATUS = #attributes.status_app#
				</cfif>
				<cfif isdefined("attributes.app_name") and len(attributes.app_name)>
					AND EMPLOYEES_APP.NAME LIKE '%#attributes.app_name#%'
				</cfif>
				<cfif isdefined("attributes.app_surname") and len(attributes.app_surname)>
					AND EMPLOYEES_APP.SURNAME LIKE '%#attributes.app_surname#%'
				</cfif>
				<cfif isdefined("attributes.email") and len(attributes.email)>
					AND EMPLOYEES_APP.EMAIL LIKE '#attributes.email#'
				</cfif>
				<cfif isdefined("attributes.birth_date1") and len(attributes.birth_date1)>
					AND EMPLOYEES_IDENTY.BIRTH_DATE <= #attributes.date_dogum_1#
				</cfif>
				<cfif isdefined("attributes.birth_date2") and len(attributes.birth_date2)>
					AND EMPLOYEES_IDENTY.BIRTH_DATE >= #attributes.date_dogum#
				</cfif> 
				<cfif (isdefined("attributes.sex") and listlen(attributes.sex))>
					AND EMPLOYEES_APP.SEX IN (#listsort(attributes.sex,"NUMERIC")#) 
				</cfif>
				<cfif (isdefined("attributes.MARRIED") and listlen(attributes.MARRIED))>
					AND EMPLOYEES_IDENTY.MARRIED IN (#listsort(attributes.married,"NUMERIC")#)  
				</cfif>
				<cfif (isdefined("attributes.military_status") and listlen(attributes.military_status))>
					AND EMPLOYEES_APP.MILITARY_STATUS IN (#LISTSORT(attributes.military_status,"NUMERIC")#) 
				</cfif>
				<cfif isdefined("attributes.birth_place") and len(attributes.birth_place)>
					AND EMPLOYEES_IDENTY.BIRTH_PLACE LIKE '%#attributes.birth_place#%'
				</cfif>
				<cfif isdefined("attributes.city") and len(attributes.city)>
					AND EMPLOYEES_IDENTY.CITY LIKE '%#attributes.city#%'
				</cfif>
				<!--- <cfif isdefined("attributes.edu3") and len(attributes.edu3)>
					AND EMPLOYEES_APP.EDU3 LIKE '%#attributes.edu3#%'
				</cfif>
				<cfif isdefined("attributes.edu3_part") and len(attributes.edu3_part)>
					AND EMPLOYEES_APP.EDU3_PART IN (#attributes.edu3_part#)
				</cfif> --->
				<cfif isdefined("attributes.app_reply_date1") and len(attributes.app_reply_date1)>
				AND EMPLOYEES_APP.RECORD_DATE >= #attributes.app_reply_date1# 
				</cfif>
				<cfif isdefined("attributes.app_reply_date2") and len(attributes.app_reply_date2)>
				AND EMPLOYEES_APP.RECORD_DATE <= #attributes.app_reply_date2# 
				</cfif>
				<cfif isdefined("attributes.training_level") and len(attributes.training_level)>
					AND TRAINING_LEVEL IN (#attributes.training_level#)
					<!--- <cfif isdefined("attributes.edu_finish") and len(attributes.edu_finish)>
					AND	(EDU1_FINISH = #attributes.edu_finish#
						OR EDU2_FINISH = #attributes.edu_finish#  
						OR EDU3_FINISH = #attributes.edu_finish#  
						OR EDU4_FINISH = #attributes.edu_finish#
						OR EDU4_FINISH_2 = #attributes.edu_finish# 
						OR EDU5_FINISH = #attributes.edu_finish#
						OR EDU7_FINISH = #attributes.edu_finish#)
					</cfif> --->
				</cfif>
				<cfif isdefined("attributes.driver_licence_type") and len(attributes.driver_licence_type)>
					AND DRIVER_LICENCE_TYPE LIKE '%#attributes.driver_licence_type#%'
				</cfif>
				<cfif isdefined("attributes.driver_licence") and len(attributes.driver_licence)>
					AND (DRIVER_LICENCE <> '' OR DRIVER_LICENCE_TYPE <> '')
				</cfif>
				<cfif isdefined("attributes.sentenced") and len(attributes.sentenced)>
					AND SENTENCED = #attributes.sentenced#
				</cfif>
				<cfif isdefined("attributes.defected") and len(attributes.defected)>
				AND DEFECTED = #attributes.defected#
				</cfif>
				<cfif isdefined("attributes.defected_level") and attributes.defected_level gt 0>
				AND DEFECTED_LEVEL = #attributes.defected_level#
				</cfif>
				<cfif isdefined("attributes.is_trip") and len(attributes.is_trip)>
				AND IS_TRIP = #attributes.is_trip#
				</cfif>
				<cfif isdefined("attributes.referance") and len(attributes.referance)>
				AND
					(
					REF1 LIKE '%#attributes.referance#%' OR
					REF2 LIKE '%#attributes.referance#%' OR
					REF1_EMP LIKE '%#attributes.referance#%' OR
					REF2_EMP LIKE '%#attributes.referance#%'
					)
				</cfif>
				<cfif isdefined("attributes.homecity") and len(attributes.homecity)>
					AND HOMECITY IN (#attributes.homecity#)
				</cfif>
				<cfset city_count=0>
				<cfif isdefined("attributes.prefered_city") and len(attributes.prefered_city)>
					AND (
						<cfloop list="#attributes.prefered_city#" index="i" delimiters=",">
							PREFERED_CITY LIKE '%,#i#,%'
							<cfset city_count=city_count+1>
							<cfif listlen(attributes.prefered_city) neq city_count>
							OR
							</cfif>
						</cfloop>
						)
				</cfif>
				<cfif isdefined("attributes.kurs") and len(attributes.kurs)>
				<cfloop list="#attributes.kurs#" index="i">
					AND
					( KURS1 LIKE '%,#i#,%' OR
					KURS2 LIKE '%,#i#,%' OR
					KURS3 LIKE '%,#i#,%' )
				</cfloop>
				</cfif>
				
				<!--- <cfif isdefined("attributes.exp_year_s1") and len(attributes.exp_year_s1)>
					AND (EXP1_FARK+EXP2_FARK+EXP3_FARK+EXP4_FARK)/365 >= #attributes.exp_year_s1#
				</cfif>
				<cfif isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2)>
					AND	(EXP1_FARK+EXP2_FARK+EXP3_FARK+EXP4_FARK)/365 <= #attributes.exp_year_s2#
				</cfif> --->
				<cfif (isdefined("attributes.exp_year_s1") and len(attributes.exp_year_s1)) or (isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2))>
					AND EMPLOYEES_APP.EMPAPP_ID IN (#exp_app_list#)
				</cfif>
				<cfif isdefined("attributes.tool") and listlen(attributes.tool)>
					AND 
					(
					<cfloop list="#listsort(attributes.tool,'textnocase')#" index="tool_index">
						COMP_EXP LIKE '%#tool_index#%' <cfif ListLast(ListSort(attributes.tool,'textnocase')) neq "#Trim(tool_index)#">OR</cfif>
					</cfloop>
					)
				</cfif> 
				<cfif isdefined("attributes.lang") and len(attributes.lang)>
					AND
					(  
					<cfset lang_count=0>
					<cfloop list="#attributes.lang#" delimiters="," index="i">
						(
							(
								LANG1=#i# AND 
								(LANG1_SPEAK >=#attributes.lang_level# OR
								LANG1_MEAN >=#attributes.lang_level# OR
								LANG1_WRITE >=#attributes.lang_level#)
							) OR
							(
								LANG2=#i# AND
								(LANG2_SPEAK >=#attributes.lang_level# OR
								LANG2_MEAN >=#attributes.lang_level# OR
								LANG2_WRITE >=#attributes.lang_level#)
							) OR
							(
								LANG3=#i# AND
								(LANG3_SPEAK >=#attributes.lang_level# OR
								LANG3_MEAN >=#attributes.lang_level# OR
								LANG3_WRITE >=#attributes.lang_level#)
							) OR
							(
								LANG4=#i# AND
								(LANG4_SPEAK >=#attributes.lang_level# OR
								LANG4_MEAN >=#attributes.lang_level# OR
								LANG4_WRITE >=#attributes.lang_level#)
							) OR
							(
								LANG5=#i# AND
								(LANG5_SPEAK >=#attributes.lang_level# OR
								LANG5_MEAN >=#attributes.lang_level# OR
								LANG5_WRITE >=#attributes.lang_level#)
							)
						)
						<cfset lang_count=lang_count+1>
						<cfif listlen(attributes.lang) neq lang_count>
							#attributes.lang_par#
						</cfif>
					</cfloop>
					)
				</cfif>
				<cfif ((isdefined("attributes.edu3") and len(attributes.edu3)) or (isdefined("attributes.edu3_part") and len(attributes.edu3_part))) or ((isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))) or ((isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id))) or (isdefined("attributes.edu_finish") and len(attributes.edu_finish))>
					AND EMPLOYEES_APP.EMPAPP_ID IN (#edu_app_list#)

				</cfif>
				<!--- <cfif (isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))>
					AND (	
						<cfif isdefined("attributes.edu4") and len(attributes.edu4)>
							<cfset count=0>
							<cfloop list="#attributes.edu4#" delimiters="," index="i">
							<cfset count=count+1>
							<cfif count gt 1> OR </cfif>
							EDU4 LIKE '%#i#%' 
							</cfloop>
						</cfif>
						<cfif isdefined("attributes.edu4_id") and len(attributes.edu4_id)>
							<cfif isdefined('count')>OR</cfif>
							(EDU4_ID IN (#attributes.edu4_id#) OR EDU4_ID_2 IN (#attributes.edu4_id#))
						</cfif>
					)
				</cfif>
				
				<cfif (isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id))>
					AND
					(	
					<cfif isdefined("attributes.edu4_part") and len(attributes.edu4_part)>
						<cfset count2=0>
						<cfloop list="#attributes.edu4_part#" delimiters="," index="i">
						<cfset count2=count2+1>
						<cfif count2 gt 1> OR </cfif>
						EDU4_PART LIKE '%#i#%'
						</cfloop>
					</cfif>
					<cfif isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id)>
						<cfif isdefined('count2')>OR</cfif> 
						(EDU4_PART_ID IN (#attributes.edu4_part_id#)  OR EDU4_PART_ID_2 IN (#attributes.edu4_part_id#))
					</cfif>
					)
				</cfif> --->
		
					<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
					AND
					(
						EMPLOYEES_APP.NAME LIKE '%#attributes.keyword#%'
						OR
						EMPLOYEES_APP.SURNAME LIKE '%#attributes.keyword#%'
					)	
					</cfif>
					<cfif isdefined("attributes.commethod_id") and (attributes.commethod_id neq 0)>
						AND EMPLOYEES_APP.COMMETHOD_ID = #attributes.commethod_id#
					</cfif>	   
					<cfif isdefined("attributes.app_currency_id") and len(attributes.app_currency_id)>
						AND EMPLOYEES_APP.APP_CURRENCY_ID = #attributes.app_currency_id#
					</cfif>
					<cfif isdefined('attributes.martyr_relative') and len(attributes.martyr_relative)>AND EMPLOYEES_APP.MARTYR_RELATIVE =1</cfif>
					<cfif isdefined('attributes.other') and len(attributes.other)>
						AND
						( (EMPLOYEES_APP.EMPAPP_ID IN(SELECT DISTINCT EMPAPP_ID FROM EMPLOYEES_APP_WORK_INFO
						WHERE
						(EXP <cfif attributes.other_if eq 1>NOT</cfif> LIKE '%#attributes.other#%') OR
						(EXP_POSITION <cfif attributes.other_if eq 1>NOT</cfif> LIKE '%#attributes.other#%') OR
						(EXP_EXTRA <cfif attributes.other_if eq 1>NOT</cfif> LIKE '%#attributes.other#%')
						)
						)
						OR
						CLUB <cfif attributes.other_if eq 1>NOT</cfif> LIKE '%#attributes.other#%' OR
						APPLICANT_NOTES <cfif attributes.other_if eq 1>NOT</cfif> LIKE '%#attributes.other#%'
						)
					</cfif>
					<cfif isdefined("attributes.unit_id") and len(attributes.unit_id) and len(attributes.unit_row)>
						AND EMPLOYEES_APP.EMPAPP_ID IN(SELECT DISTINCT EAU.EMPAPP_ID FROM EMPLOYEES_APP_UNIT EAU
													WHERE 
														EAU.UNIT_ID IN (#attributes.unit_id#) 
														AND EAU.UNIT_ROW<=#attributes.unit_row#
														)
					</cfif>
				AND EMPLOYEES_APP.EMPAPP_ID NOT IN(SELECT EMPAPP_ID FROM EMPLOYEES_APP_SEL_LIST_ROWS WHERE LIST_ID=#get_list.max_list_id#)
				AND EMPLOYEES_APP.EMPAPP_ID IN(#attributes.list_empapp_id#)
		</cfquery>
	</cfloop>
</cfif>
<script type="text/javascript">
	<cfif not isdefined('attributes.old')>
		window.location.href='<cfoutput>#request.self#?fuseaction=hr.emp_app_select_list&event=det&list_id=#GET_LIST.MAX_LIST_ID#</cfoutput>';
	</cfif>
	<cfif isdefined("attributes.draggable") and attributes.draggable eq 1 and not(isdefined("attributes.type") and attributes.type eq 2)>
		$('#select_list .catalyst-refresh').click();
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
	<cfelseif isdefined('attributes.loadToObject') and len( attributes.loadToObject )>
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.popup_select_list_empapp&empapp_id=#attributes.list_empapp_id#</cfoutput>','<cfoutput>#attributes.loadToObject#</cfoutput>');
	<cfelse>
		window.opener.location.href='<cfoutput>#request.self#?fuseaction=hr.emp_app_select_list&event=det&list_id=#GET_LIST.MAX_LIST_ID#</cfoutput>';
		window.close();
	</cfif>
</script>
	</cftransaction>
</cflock>