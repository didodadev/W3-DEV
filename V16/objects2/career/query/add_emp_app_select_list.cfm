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
		<cfset exp_app_list = valuelist(get_work_info.empapp_id,',')>
	<cfelse>
		<cfset exp_app_list = 0>
	</cfif>
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
				AND EDU_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.edu3#%"> 
			</cfif>
			<cfif isdefined("attributes.edu3_part") and len(attributes.edu3_part)>
				AND EDU_PART_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.edu3_part#"> 
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
						 EDU_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#i#%"> 
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
					   EDU_PART_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#i#%">
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
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
<cfif not isdefined('attributes.old')>
	<cfquery name="add_list" datasource="#dsn#">
		INSERT INTO
			EMPLOYEES_APP_SEL_LIST
			(
				LIST_NAME,
				LIST_DETAIL,
				LIST_STATUS,
				<cfif len(attributes.notice_id_list)>NOTICE_ID,</cfif>
				<!--- <cfif len(attributes.position_id_list)>POSITION_ID,</cfif>
				<cfif len(attributes.position_cat_id_list)>POSITION_CAT_ID,</cfif>
				<cfif len(attributes.company_list) and len(attributes.company_id_list)>COMPANY_ID,</cfif> --->
				<cfif len(attributes.our_company_id_list)>OUR_COMPANY_ID,</cfif>
				SEL_LIST_STAGE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				'#attributes.list_name#',
				'#attributes.list_detail#',
				<cfif isdefined('attributes.list_status')>1<cfelse>0</cfif>,
				<cfif len(attributes.notice_id_list)>#attributes.notice_id_list#,</cfif>
				<!--- <cfif len(attributes.position_id_list)>#attributes.position_id_list#,</cfif>
				<cfif len(attributes.position_cat_id_list)>#attributes.position_cat_id_list#,</cfif> 
				<cfif len(attributes.company_list) and len(attributes.company_id_list)>#attributes.company_id_list#,</cfif> --->
				<cfif len(attributes.our_company_id_list)>#attributes.our_company_id_list#,</cfif>
				<cfif len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
				#now()#,
				#session.pp.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
	<cfquery name="get_list" datasource="#dsn#">
		SELECT
			MAX(LIST_ID) AS MAX_LIST_ID
		FROM
			EMPLOYEES_APP_SEL_LIST
		WHERE 
			LIST_NAME=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.list_name#">
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
	
<cfelseif isdefined('attributes.old') and attributes.old eq 1>
	<cfset get_list.MAX_LIST_ID=attributes.list_id>
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
		MONEY = '#Trim(attributes.salary_wanted_money)#' AND 
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.PP.PERIOD_ID#">
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

<cfif isdefined('attributes.search_app_pos') and attributes.search_app_pos eq 1>
<cfquery name="add_list_row_pos" datasource="#dsn#"><!---başvuruları ekliyor--->
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
		   AND EMPLOYEES_APP_POS.APP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.app_date1#">
		</cfif>
		<cfif isdefined("attributes.app_date2") and len(attributes.app_date2) and not (isdefined("attributes.app_date1") and len(attributes.app_date1))>
		   AND EMPLOYEES_APP_POS.APP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.app_date2#">
		</cfif>
		<cfif (isdefined("attributes.app_date1") and len(attributes.app_date1)) and (isdefined("attributes.app_date2") and len(attributes.app_date2))>
		   AND (EMPLOYEES_APP_POS.APP_DATE  BETWEEN #attributes.app_date1#  AND #attributes.app_date2#)
		</cfif>	
		<cfset city_count=0>	
		<cfif isdefined("attributes.prefered_city") and len(attributes.prefered_city)>
			AND (
			<cfloop list="#attributes.prefered_city#" index="i" delimiters=",">
			  	PREFERED_CITY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#i#,%"> 
				<cfset city_count=city_count+1>
				<cfif listlen(attributes.prefered_city) neq city_count>
					OR
				</cfif>
			</cfloop>
			)
		</cfif>
		<cfif isdefined("attributes.notice_id") and len(attributes.notice_id)>
		  AND EMPLOYEES_APP_POS.NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.notice_id#">
		</cfif>
		<cfif (isdefined("attributes.position_id") and len(attributes.position_id)) and (isdefined("attributes.app_position") and len(attributes.app_position))>
			AND EMPLOYEES_APP_POS.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
		</cfif>
		<cfif (isdefined("attributes.POSITION_CAT_ID") and len(attributes.POSITION_CAT_ID)) and (isdefined("attributes.POSITION_CAT") and len(attributes.POSITION_CAT))>
			AND EMPLOYEES_APP_POS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.POSITION_CAT_ID#">
		</cfif>
		<cfif isdefined('attributes.status') and len(attributes.status)>
			AND EMPLOYEES_APP.APP_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
		<cfelseif isdefined('attributes.status_app_pos') and len(attributes.status_app_pos)>
			AND EMPLOYEES_APP_POS.APP_POS_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status_app_pos#">
		</cfif>	
		<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
			AND EMPLOYEES_APP_POS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
		<cfif isdefined("attributes.department") and len(attributes.department) and isdefined('attributes.department_id') and len(attributes.department_id)>
			AND EMPLOYEES_APP_POS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
		</cfif>
		<cfif isdefined("attributes.branch") and len(attributes.branch) and isdefined('attributes.branch_id') and len(attributes.branch_id)>
			AND EMPLOYEES_APP_POS.BRANCH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			<cfif isdefined('attributes.our_company_id') and len(attributes.our_company_id)>
				AND EMPLOYEES_APP_POS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
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
		AND EMPLOYEES_IDENTY.BIRTH_PLACE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.birth_place#%">
	</cfif>
	<cfif isdefined("attributes.city") and len(attributes.city)>
		AND EMPLOYEES_IDENTY.CITY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.city#%">
	</cfif>
	<cfif ((isdefined("attributes.edu3") and len(attributes.edu3)) or (isdefined("attributes.edu3_part") and len(attributes.edu3_part))) or ((isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))) or ((isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id))) or (isdefined("attributes.edu_finish") and len(attributes.edu_finish))>
		AND EMPLOYEES_APP.EMPAPP_ID IN (#edu_app_list#)
	</cfif>
	<!--- <cfif isdefined("attributes.edu3") and len(attributes.edu3)>
		AND EMPLOYEES_APP.EDU3 LIKE '%#attributes.edu3#%'
	</cfif>
	<cfif isdefined("attributes.edu3_part") and len(attributes.edu3_part)>
		AND EMPLOYEES_APP.EDU3_PART IN (#attributes.edu3_part#)
	</cfif>
	<cfif (isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))>
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
			(EDU4_PART_ID IN (#attributes.edu4_part_id#) OR EDU4_PART_ID_2 IN (#attributes.edu4_part_id#))
		</cfif>
		)
	</cfif> --->
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
	
	AND EMPLOYEES_APP_POS.APP_POS_ID IN(#attributes.list_app_pos_id#)
	<cfif isdefined('attributes.old')>
		AND EMPLOYEES_APP.EMPAPP_ID NOT IN(SELECT EMPAPP_ID FROM EMPLOYEES_APP_SEL_LIST_ROWS WHERE LIST_ID=#get_list.max_list_id#)
	</cfif>
</cfquery>
</cfif>

<cfif isdefined('attributes.search_app') and attributes.search_app eq 1><!---özgeçmişleri ekliyor--->
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
			#session.pp.userid#,
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
		<!--- <cfif isdefined("attributes.edu3") and len(attributes.edu3)>
			AND EMPLOYEES_APP.EDU3 LIKE '%#attributes.edu3#%'
		</cfif>
		<cfif isdefined("attributes.edu3_part") and len(attributes.edu3_part)>
			AND EMPLOYEES_APP.EDU3_PART IN (#attributes.edu3_part#)
		</cfif>
		<cfif (isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))>
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
</cfif>

<script type="text/javascript">
	window.opener.location.href='<cfoutput>#request.self#?fuseaction=objects2.upd_emp_app_select_list&list_id=#GET_LIST.MAX_LIST_ID#</cfoutput>';
	window.close();
</script>
	</cftransaction>
</cflock>

