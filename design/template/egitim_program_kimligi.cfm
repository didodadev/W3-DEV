<cf_get_lang_set module_name="training_management"><!--- sayfanin en altinda kapanisi var --->
<cfsavecontent variable="ay1"><cf_get_lang_main no='180.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang_main no='181.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang_main no='182.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang_main no='183.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang_main no='184.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang_main no='185.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang_main no='186.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang_main no='187.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang_main no='188.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang_main no='189.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang_main no='190.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang_main no='191.Aralık'></cfsavecontent>
<cfset aylar = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cffunction name="write_date">
	<cfargument name="date_1">
	<cfargument name="date_2">
	<cfset aylar = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
	<cfset ay_1=DateFormat(date_1,"m")>
	<cfset ay_2=DateFormat(date_2,"m")>	
	<cfset gun_1=DateFormat(date_1,"d")>	
	<cfset gun_2=DateFormat(date_2,"d")>
	<cfset yil_1=DateFormat(date_1,"yyyy")>
	<cfset yil_2=DateFormat(date_2,"yyyy")>
	<cfset my_str="">
	<cfset fark=DateDiff("d",date_1,date_2)>
	
	<cfif (ay_1 neq ay_2 ) or (yil_1 neq  yil_2) >
		<cfif yil_1 eq yil_2>	
			<cfset my_str = "#gun_1# #ListGetAt(aylar,ay_1)# - #gun_2# #ListGetAt(aylar,ay_2)# #yil_1#" >
		<cfelse>
			<cfset my_str = "#gun_1# #ListGetAt(aylar,ay_1)# #yil_1#- #gun_2# #ListGetAt(aylar,ay_2)# #yil_2#" >
		</cfif>
	<cfelse>
		<cfset my_str="#gun_1#">
		<cfloop from="1" to="#fark#" index="kl">
			<cfset my_str="#my_str#-#evaluate(gun_1+kl)#">
		</cfloop>
		<cfset my_str="#my_str# #ListGetAt(aylar,ay_1)# #yil_1# ">
	</cfif>
	<cfset fark=fark+1>
	<cfreturn my_str & " | " & fark>
</cffunction>

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
	<!---<cfif isdefined("attributes.TRAIN_ID")> AND TRAINING_ID = #attributes.TRAIN_ID# </cfif>--->
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
<cfif len(get_class.start_date) >
	<cfset start_date = date_add('h', session.ep.time_zone, get_class.start_date)>
</cfif>
<cfif len(get_class.finish_date) >
	<cfset finish_date = date_add('h', session.ep.time_zone, get_class.finish_date)>
</cfif>
<table width="650" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
	<tr>
		<td class="headbold"><cf_get_lang no='296.program kimliği'></td>
	</tr>
</table>
<br/>
<table width="650" border="0" align="center">
	<tr>
		<td width="180" height="22" class="txtbold"><cf_get_lang no='113.Dersin Adı'></td>
		<td>: <cfoutput>#get_class.class_name#</cfoutput></td>
	</tr>
	<tr>
		<td height="22" valign="top" class="txtbold"><cf_get_lang_main no='330.Tarihi'> / <cf_get_lang no='187.Yeri'></td>
		<td valign="top">:
			<cfif len(get_class.start_date) and len(get_class.finish_date)>
				<cfset my_list=write_date(start_date,finish_date)>
				<strong><cfoutput> #ListGetAt(my_list,1,"|")# #get_class.CLASS_PLACE#</cfoutput></strong>
			<cfelseif len(get_class.MONTH_ID)>
				<cfoutput>#listgetat(aylar,get_class.MONTH_ID)# #SESSION.EP.PERIOD_YEAR#</cfoutput>
			</cfif>
		</td>
	</tr>
	<tr>
		<td height="22" valign="top" class="txtbold"><cf_get_lang_main no='1716.Süresi'> </td>
		<td valign="top">:
		<cfif len(get_class.start_date) and len(get_class.finish_date)>
			<cfoutput> #ListGetAt(my_list,2,"|")# <cf_get_lang_main no='78.gün'></cfoutput>
		<cfelse>
			<cfoutput> #get_class.DATE_NO# <cf_get_lang_main no='78.gün'></cfoutput>
		</cfif>
		</td>
	</tr>  
	<cfquery name="get_training_poscats_departments" datasource="#dsn#">
	  SELECT 
		  TRAIN_POSITION_CATS,
		  TRAIN_DEPARTMENTS 
	  FROM 
		  TRAINING 
	  WHERE 
		  TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING_CLASS_SECTIONS WHERE CLASS_ID = #attributes.action_id#)
	</cfquery>
	<tr>
		<td height="22" class="txtbold"><cf_get_lang no='117.Eğitmen'></td>
		<td>:
			<!--- <cfif len(get_class.TRAINER_EMP)>
				<cfset attributes.EMPLOYEE_ID=get_class.TRAINER_EMP>
				<cfquery name="GET_EMPLOYEE" datasource="#dsn#">
					SELECT 
						EMPLOYEES.EMPLOYEE_ID,
						EMPLOYEES.EMPLOYEE_NAME,
						EMPLOYEES.EMPLOYEE_SURNAME,
						EMPLOYEE_POSITIONS.DEPARTMENT_ID,
						EMPLOYEE_POSITIONS.POSITION_NAME,		
						D.DEPARTMENT_HEAD,
						EMPLOYEES.EMPLOYEE_EMAIL
					FROM 
						EMPLOYEES ,
						EMPLOYEE_POSITIONS,
						DEPARTMENT D
					WHERE 
						EMPLOYEE_POSITIONS.DEPARTMENT_ID=D.DEPARTMENT_ID  AND
						EMPLOYEES.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
						EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
					ORDER BY 
						EMPLOYEES.EMPLOYEE_NAME
				</cfquery>
				<cfoutput>#GET_EMPLOYEE.EMPLOYEE_NAME# #GET_EMPLOYEE.EMPLOYEE_SURNAME#</cfoutput>
			<cfelseif len(get_class.TRAINER_PAR)>
				<cfset attributes.PARTNER_ID=get_class.TRAINER_PAR>
				<cfquery name="GET_PARTNER" datasource="#dsn#">
					SELECT 
						CP.PARTNER_ID,	
						CP.COMPANY_PARTNER_NAME,
						CP.COMPANY_PARTNER_SURNAME,
						CP.COMPANY_ID,
						C.FULLNAME,
						C.COMPANY_ID,
						CP.COMPANY_PARTNER_EMAIL
					FROM 
						COMPANY_PARTNER AS CP,
						COMPANY AS C
					WHERE
						CP.PARTNER_ID = #attributes.PARTNER_ID#
					AND
						C.COMPANY_ID = CP.COMPANY_ID
				</cfquery>						
				<cfoutput>#GET_PARTNER.COMPANY_PARTNER_NAME# #GET_PARTNER.COMPANY_PARTNER_SURNAME#</cfoutput>
			</cfif> --->
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
		</td>
	</tr>
	<tr>
		<td height="22" valign="top" class="txtbold"><cf_get_lang_main no='178.Katılımcılar'></td>
		<td>:
			<cfquery name="get_emp_att" datasource="#dsn#">
			  SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#attributes.action_id# AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
			</cfquery>
			<cfoutput query="get_emp_att">
				<cfquery name="get_emp_name" datasource="#dsn#">
					SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #EMP_ID#
				</cfquery>
				<!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMP_ID#','medium');" class="tableyazi"> --->
				#get_emp_name.EMPLOYEE_NAME# #get_emp_name.EMPLOYEE_SURNAME#
				<!--- </a> --->
				<cfif currentrow neq get_emp_att.recordcount>,</cfif>
			</cfoutput>
		</td>
	</tr>
	<tr>
		<td height="22" class="txtbold"><cf_get_lang no='32.Amaç'></td>
		<td>: <cfoutput>#get_class.CLASS_TARGET#</cfoutput> </td>
	</tr>
	<tr>
		<td height="22" valign="top" class="txtbold"><cf_get_lang no='427.Ders İçeriği'></td>
		<td>: <cfoutput>#get_class.class_objective#</cfoutput> </td>
	</tr>
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
