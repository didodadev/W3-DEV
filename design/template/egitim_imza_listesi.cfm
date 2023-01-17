<!--- egitim yonetimi imza listesi --->
<table width="650" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
  <tr class="txtbold">
    <td style="text-align:right;"><cf_get_lang_main no='330.Tarih'> : <cfoutput>#dateformat(now(),dateformat_style)#</cfoutput><img title="" border="0" width="100" height="0"></td>
  </tr>
</table>
<cfif isDefined("attributes.training_sec_id") and len(attributes.training_sec_id)>
	<cfquery name="get_class_ids" datasource="#dsn#">
		SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAINING_SEC_ID = #attributes.training_sec_id#
	</cfquery>
	<cfif get_class_ids.recordcount>
		<cfset class_ids = valuelist(get_class_ids.CLASS_ID)>
	</cfif>
</cfif>
<cfquery name="get_class" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_CLASS
	WHERE
		CLASS_ID IS NOT NULL
	<cfif isDefined("attributes.action_id") and len(attributes.action_id)>
		AND CLASS_ID = #attributes.action_id#
	</cfif>
	<cfif isDefined("attributes.online") and len(attributes.online)>
		AND ONLINE = #attributes.ONLINE#
	</cfif>
	<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(CLASS_NAME LIKE '%#attributes.KEYWORD#%' OR CLASS_OBJECTIVE LIKE '%#attributes.KEYWORD#%')
	</cfif>
	<cfif isdefined("attributes.training_sec_id") and get_class_ids.recordcount>
	    AND	CLASS_ID IN (#class_ids#)
	</cfif> 	
	<cfif isDefined("attributes.date1") and len(attributes.date1)>
		<cf_date tarih='attributes.date1'>
		AND	START_DATE >= #attributes.date1#
	</cfif>
	<cfif isdefined("attributes.training_sec_id")>
	   AND TRAINING_SEC_ID = #attributes.training_sec_id#
	</cfif>
</cfquery>
<cfset attributes.training_id = get_class.training_id>
<cfif LEN(get_class.start_date)>
  <cfset start_date = date_add('h', session.ep.time_zone, get_class.start_date)>
</cfif>
<cfif LEN(get_class.finish_date)>
  <cfset finish_date = date_add('h', session.ep.time_zone, get_class.finish_date)>
</cfif>

<table width="650" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
  <tr>
    <td class="headbold"><cf_get_lang_main no='7.Eğitim'>:&nbsp;<cfoutput>#get_class.class_name#</cfoutput></td>
  </tr>
</table>
<table width="650" border="0" align="center">
	<cfif get_class.online eq 1>
	<tr>
		<td class="txtbold" width="165"><cf_get_lang_main no='7.Eğitim'> <cf_get_lang_main no='1251.Şekli'></td>
		<td width="480">:<cfif get_class.online eq 1><cf_get_lang_main no="2218.Online"></cfif></td>
	</tr>
	</cfif>
	<tr>
		<td class="txtbold" nowrap><cf_get_lang_main no='1055.Başlama'> - <cf_get_lang_main no='90.Bitis'></td>
		<td>:
		<cfif Len(get_class.finish_date)>
			<cfoutput>#dateformat(start_date,dateformat_style)# #timeformat(start_date,timeformat_style)#</cfoutput>
		</cfif>
		-
		<cfif Len(get_class.finish_date)>
			<cfoutput> #dateformat(finish_date,dateformat_style)# #timeformat(finish_date,timeformat_style)#</cfoutput>
		</cfif>
		</td>
	</tr>
	<tr>
		<td class="txtbold" nowrap><cf_get_lang_main no='80.Toplam'>&nbsp;<cf_get_lang_main no='78.Gün'> - <cf_get_lang_main no='79.Saat'></td>
		<td>: <cfoutput>#get_class.DATE_NO# - #get_class.HOUR_NO#</cfoutput></td>
	</tr>
	<tr>
		<td class="txtbold" nowrap><cf_get_lang no='1132.Eğitimci'></td>
		<td>: 
			<cfquery name="get_trainers" datasource="#dsn#">
				SELECT
					TCT.ID,
					E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS TRAINER,
					'Çalışan' AS TRAINER_DETAIL
				FROM
					TRAINING_CLASS_TRAINERS TCT INNER JOIN EMPLOYEES E
					ON TCT.EMP_ID = E.EMPLOYEE_ID 
				WHERE
					TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
				UNION ALL
				SELECT
					TCT.ID,
					CP.COMPANY_PARTNER_NAME+' '+ CP.COMPANY_PARTNER_SURNAME AS TRAINER,
					'Kurumsal' AS TRAINER_DETAIL
				FROM
					TRAINING_CLASS_TRAINERS TCT INNER JOIN COMPANY_PARTNER CP
					ON TCT.PAR_ID =CP.PARTNER_ID 
				WHERE
					TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
				UNION ALL
				SELECT
					TCT.ID,
					C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS TRAINER,
					'Bireysel' AS TRAINER_DETAIL
				FROM
					TRAINING_CLASS_TRAINERS TCT INNER JOIN CONSUMER C
					ON TCT.CONS_ID =C.CONSUMER_ID 
				WHERE
					TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
			</cfquery>
			<cfloop query="get_trainers"><cfoutput>#TRAINER#<cfif currentrow neq get_trainers.recordcount>,</cfif></cfoutput></cfloop>
			<!--- <cfif len(get_class.TRAINER_EMP) AND (get_class.TRAINER_EMP NEQ 0)>
				<cfquery name="get_emp_name" datasource="#dsn#">
					SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_class.TRAINER_EMP#
				</cfquery>
				<cfoutput>#get_emp_name.EMPLOYEE_NAME# #get_emp_name.EMPLOYEE_SURNAME#</cfoutput>
			<cfelseif len(get_class.TRAINER_PAR) AND (get_class.TRAINER_PAR NEQ 0)>
				<cfquery name="get_par_name" datasource="#dsn#">
					SELECT COMPANY_PARTNER_NAME , COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = #get_class.trainer_par#
				</cfquery>
				<cfoutput>#get_par_name.COMPANY_PARTNER_NAME# #get_par_name.COMPANY_PARTNER_SURNAME#</cfoutput>
			</cfif> --->
		</td>
	</tr>
	<tr>
		<td class="txtbold" nowrap><cf_get_lang_main no='7.Eğitim'> <cf_get_lang_main no='1252.Yeri'> <cf_get_lang_main no='132.Sorumlusu'></td>
		<td>: <cfoutput>#get_class.CLASS_PLACE_MANAGER#</cfoutput> </td>
	</tr>
</table>
<br/>
<table  width="650" cellspacing="0"  align="center" cellpadding="0">
	<tr>
		<td valign="top">
		<table cellSpacing="0" cellpadding="0" border="0" width="100%" align="center">
			<tr class="color-border">
				<td>
				<table cellspacing="1" cellpadding="2" width="100%" border="0" height="100%">
					<tr class="color-header" height="22">
						<td class="form-title"><cf_get_lang_main no='75.No'></td>
						<td class="form-title"><cf_get_lang_main no='158.Ad Soyad'></td>
						<td class="form-title"><cf_get_lang_main no='162.Şirket'>/<cf_get_lang_main no='41.Şube'></td>
						<td class="form-title"><cf_get_lang_main no='1085.Pozisyon'></td>
						<td class="form-title"><cf_get_lang_main no='1545.İmza'></td>
					</tr>
					<cfquery name="get_emp_att" datasource="#dsn#">
					  SELECT 
						  EMP_ID,
						  PAR_ID,
						  CON_ID,
						  GRP_ID 
					  FROM 
						  TRAINING_CLASS_ATTENDER 
					  WHERE 
						  CLASS_ID = #attributes.action_id#
					</cfquery>
					<cfset attributes.employee_ids=ValueList(get_emp_att.emp_id)>
					<cfset attributes.partner_ids=ValueList(get_emp_att.par_id)>
					<cfset attributes.consumer_ids=ValueList(get_emp_att.con_id)>
					<cfset attributes.group_ids=ValueList(get_emp_att.grp_id)>			 
					<cfif not len(listsort(attributes.employee_ids,"numeric"))>
						<cfset attributes.employee_ids = 0>
					</cfif>
					<cfif not len(LISTSORT(attributes.partner_ids,"NUMERIC"))>
						<cfset attributes.partner_ids = 0> 
					</cfif>
					<cfif not len(LISTSORT(attributes.consumer_ids,"NUMERIC"))>
						<cfset attributes.consumer_ids = 0>
					</cfif>
					<cfif not len(LISTSORT(attributes.group_ids,"NUMERIC"))>
						<cfset attributes.group_ids = 0>
					</cfif>
					<cfquery name="get_class_attender" datasource="#DSN#">
						SELECT
							'employee' AS TYPE,
							TRAINING_CLASS_ATTENDER.CLASS_ID,
							TRAINING_CLASS_ATTENDER.EMP_ID AS K_ID,
							EMPLOYEE_POSITIONS.EMPLOYEE_NAME AS AD,
							EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS SOYAD,
							EMPLOYEE_POSITIONS.EMPLOYEE_ID AS IDS,
							EMPLOYEE_POSITIONS.POSITION_NAME  AS POSITION,
							DEPARTMENT.DEPARTMENT_HEAD AS DEPARTMAN,
							C.NICK_NAME AS NICK_NAME,
							BRANCH.BRANCH_NAME AS BRANCH_NAME
						FROM
							TRAINING_CLASS_ATTENDER,
							EMPLOYEE_POSITIONS,
							DEPARTMENT,
							BRANCH,
							OUR_COMPANY C
						WHERE
							DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
							AND C.COMP_ID=BRANCH.COMPANY_ID
							<cfif  isdefined("attributes.EX_CLASS_ID") and len(attributes.EX_CLASS_ID)>
							AND TRAINING_CLASS_ATTENDER.EX_CLASS_ID = #attributes.EX_CLASS_ID#
							</cfif>
							AND TRAINING_CLASS_ATTENDER.EMP_ID IN (#LISTSORT(attributes.EMPLOYEE_IDS,"NUMERIC")#)
							AND EMPLOYEE_POSITIONS.EMPLOYEE_ID = TRAINING_CLASS_ATTENDER.EMP_ID
							AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
							AND EMPLOYEE_POSITIONS.IS_MASTER = 1
							AND TRAINING_CLASS_ATTENDER.EMP_ID IS NOT NULL
							<cfif isdefined("attributes.action_id") and len(attributes.action_id)>
								AND TRAINING_CLASS_ATTENDER.CLASS_ID=#attributes.action_id#
							</cfif>
					UNION
						SELECT 
							'partner' AS TYPE,
							TRAINING_CLASS_ATTENDER.CLASS_ID,
							TRAINING_CLASS_ATTENDER.PAR_ID K_ID,
							COMPANY_PARTNER.COMPANY_PARTNER_NAME AS AD,
							COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS SOYAD,
							COMPANY_PARTNER.PARTNER_ID AS IDS,
							COMPANY_PARTNER.TITLE AS POSITION,
							' ' AS DEPARTMAN, 	
							COMPANY.NICKNAME AS NICK_NAME,
							' ' AS BRANCH_NAME
						FROM
							TRAINING_CLASS_ATTENDER,
							COMPANY_PARTNER,
							COMPANY
						WHERE	
							TRAINING_CLASS_ATTENDER.CLASS_ID = #attributes.action_id#
							AND TRAINING_CLASS_ATTENDER.PAR_ID IN (#LISTSORT(attributes.PARTNER_IDS,"NUMERIC")#)
							AND COMPANY_PARTNER.PARTNER_ID = TRAINING_CLASS_ATTENDER.PAR_ID
							AND COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
					UNION
						SELECT
							'consumer' AS TYPE,
							TRAINING_CLASS_ATTENDER.CLASS_ID,
							TRAINING_CLASS_ATTENDER.CON_ID AS K_ID,
							CONSUMER.CONSUMER_NAME AS AD,
							CONSUMER.CONSUMER_SURNAME AS SOYAD,
							CONSUMER.CONSUMER_ID AS IDS,
							CONSUMER.TITLE AS POSITION,
							' ' AS DEPARTMAN,
							CONSUMER.COMPANY AS NICK_NAME,
							' ' AS BRANCH_NAME
						FROM
							TRAINING_CLASS_ATTENDER,
							CONSUMER
						WHERE
							TRAINING_CLASS_ATTENDER.CLASS_ID = #attributes.action_id#
							AND TRAINING_CLASS_ATTENDER.CON_ID IN (#LISTSORT(attributes.consumer_ids,"NUMERIC")#)
							AND CONSUMER.CONSUMER_ID = TRAINING_CLASS_ATTENDER.CON_ID
							AND TRAINING_CLASS_ATTENDER.CON_ID IS NOT NULL
					UNION 
						SELECT
								'group' AS TYPE,
								TRAINING_CLASS_ATTENDER.CLASS_ID,
								TRAINING_CLASS_ATTENDER.GRP_ID K_ID,
								USERS.GROUP_NAME AS AD,
								' ' AS SOYAD,
								USERS.GROUP_ID AS IDS,
								' ' AS POSITION,
								' ' AS DEPARTMAN,
								' ' AS NICK_NAME,
								' ' AS BRANCH_NAME
							FROM
								TRAINING_CLASS_ATTENDER,
								USERS
							WHERE
								TRAINING_CLASS_ATTENDER.CLASS_ID = #attributes.action_id#
								AND TRAINING_CLASS_ATTENDER.GRP_ID IN (#LISTSORT(attributes.group_ids,"NUMERIC")#)
								AND USERS.GROUP_ID = TRAINING_CLASS_ATTENDER.GRP_ID
								AND TRAINING_CLASS_ATTENDER.GRP_ID IS NOT NULL
					</cfquery>				 
					<cfif len(attributes.employee_ids) and get_class_attender.RECORDCOUNT>
						<cfoutput query="get_class_attender">
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td>#currentrow#</td>
							<td>
							<!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#emp_id#','project');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a> --->
							<!--- <cfif type eq 'employee'>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#get_class_attender.ids#','project');" class="tableyazi">#ad#&nbsp;#soyad#</a>
							<cfelseif type eq 'partner'>
							<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_class_attender.ids#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
							<cfelseif type eq 'consumer'>
							<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_class_attender.ids#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
							<cfelse> --->
							#ad#&nbsp;#soyad#
							<!--- </cfif> --->
							</td>
							<td><cfif len(nick_name)>#nick_name#</cfif>&nbsp;<cfif BRANCH_NAME eq ' '>&nbsp;<cfelse>/&nbsp;#BRANCH_NAME#</cfif></td>
							<td>#POSITION#</td>
							<td></td>
						</tr>
						</cfoutput>
					<cfelse>
						<tr class="color-list">
							<td colspan="5"><cf_get_lang_main no='1074.Kayıt Bulunamadı'>! </td>
						</tr>
					</cfif>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<br/>
