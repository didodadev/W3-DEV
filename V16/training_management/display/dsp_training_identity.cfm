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
<cfinclude template="../query/get_class.cfm">
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
    <!-- sil -->
    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
    <!-- sil -->
  </tr>
</table>
<br/>
<table width="650" border="0" align="center">
  <tr>
    <td width="180" height="22" class="txtbold"><cf_get_lang no='113.Dersin Adı'></td>
    <td>: <cfoutput>#get_class.class_name#</cfoutput></td>
  </tr>
<!---   <tr>
    <td height="22" class="txtbold"><cf_get_lang_main no='243.Başlangıç Tarihi'> / <cf_get_lang_main no='79.Saat'></td>
    <td> : <cfoutput>#dateformat(start_date,dateformat_style)# #timeformat(start_date,timeformat_style)#</cfoutput> </td>
  </tr>
  <tr>
    <td height="22" class="txtbold"><cf_get_lang_main no='288.Bitiş Tarihi'> / <cf_get_lang_main no='79.Saat'></td>
    <td>: <cfoutput> #dateformat(finish_date,dateformat_style)# #timeformat(finish_date,timeformat_style)#</cfoutput> </td>
  </tr> --->
  <tr>
    <td height="22" valign="top" class="txtbold"><cf_get_lang_main no='330.Tarih'> / <cf_get_lang no='187.Yeri'></td>
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
	 	  TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING_CLASS_SECTIONS WHERE CLASS_ID = #attributes.CLASS_ID#)
  </cfquery>
  <tr>
    <td height="22" class="txtbold"><cf_get_lang no='117.Eğitmen'></td>
    <td>:
		<!--- <cfif len(get_class.TRAINER_EMP)>
			<cfset attributes.EMPLOYEE_ID=get_class.TRAINER_EMP>
			<cfinclude template="../query/get_employee.cfm">
			<cfoutput>#GET_EMPLOYEE.EMPLOYEE_NAME# #GET_EMPLOYEE.EMPLOYEE_SURNAME#</cfoutput>
		<cfelseif len(get_class.TRAINER_PAR)>
			<cfset attributes.PARTNER_ID=get_class.TRAINER_PAR>
			<cfinclude template="../query/get_partner.cfm">
			<cfoutput>#GET_PARTNER.COMPANY_PARTNER_NAME# #GET_PARTNER.COMPANY_PARTNER_SURNAME#</cfoutput>
		</cfif> --->
    </td>
  </tr>
  <tr>
    <td height="22" valign="top" class="txtbold"><cf_get_lang_main no='178.Katılımcılar'></td>
    <td>:
		<cfquery name="get_emp_att" datasource="#dsn#">
		  SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#attributes.CLASS_ID# AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
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
		<!--- <cfset str_list_1=listsort(valuelist(get_training_poscats_departments.TRAIN_POSITION_CATS),"Numeric", "Desc")>
		<cfset str_list_2=listsort(valuelist(get_training_poscats_departments.TRAIN_DEPARTMENTS),"Numeric", "Desc")>
		<cfquery name="get_my_emp" datasource="#DSN#">
			SELECT 
				DISTINCT
			<cfif DATABASE_TYPE eq "MSSQL">
				EMPLOYEE_NAME + EMPLOYEE_SURNAME + '(' + POSITION_NAME + ')' + DEPARTMENT_HEAD
				AS ATTAINDERS
			<cfelseif DATABASE_TYPE eq "DB2">
				EMPLOYEE_NAME || EMPLOYEE_SURNAME || '(' || POSITION_NAME || ')' || DEPARTMENT_HEAD
				AS ATTAINDERS
			</cfif>
			FROM 
				EMPLOYEE_POSITIONS, DEPARTMENT WHERE DEPARTMENT.DEPARTMENT_ID=EMPLOYEE_POSITIONS.DEPARTMENT_ID
				AND
				(			
			<cfif ListLen(str_list_2)>
				DEPARTMENT.DEPARTMENT_ID IN (#str_list_2#)
			<cfelse><!--- <cfelseif not ListLen(str_list_1)> --->
				DEPARTMENT.DEPARTMENT_ID IN(-1000)
			</cfif>
			<cfif ListLen(str_list_1)>
				OR POSITION_CAT_ID IN(#str_list_1#)
			</cfif>
				)
		</cfquery>
		<cfoutput>#valuelist(get_my_emp.ATTAINDERS)#</cfoutput>  --->
<!--- 				<cfset str_list_1=listsort(valuelist(get_training_poscats_departments.TRAIN_POSITION_CATS),"Numeric", "Desc")>
				<cfif ListLen(str_list_1)>		
					<cfquery name="get_pos" datasource="#DSN#">
							SELECT
								POSITION_CAT
							FROM
								SETUP_POSITION_CAT
							WHERE
							POSITION_CAT_ID IN (#str_list_1#)
					</cfquery>
					<cfoutput>#ValueList(get_pos.POSITION_CAT)#</cfoutput>
				<cfelse>
				</cfif>
				<cfset str_list_2=listsort(valuelist(get_training_poscats_departments.TRAIN_DEPARTMENTS),"Numeric", "Desc")>
				<cfif ListLen(str_list_2)>
					<cfquery name="get_det" datasource="#DSN#">
							SELECT
								DEPARTMENT_HEAD
							FROM
								DEPARTMENT
							WHERE
							DEPARTMENT_ID IN (#str_list_2#)
					</cfquery>
					<cfoutput>#ValueList(get_det.DEPARTMENT_HEAD)#</cfoutput>
				<cfelse>
				</cfif> --->
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
