<cfinclude template="../query/get_class.cfm">
<cfset attributes.training_id = get_class.training_id>
<cfif len(get_class.start_date)>
	<cfset start_date = date_add('h', session.ep.time_zone, get_class.start_date)>
</cfif>
<cfif len(get_class.finish_date)>
	<cfset finish_date = date_add('h', session.ep.time_zone, get_class.finish_date)>
</cfif>
<!--- Egitimci mailleri  --->
<cfif LEN(get_class.TRAINER_EMP)>
	<cfset attributes.EMPLOYEE_ID=get_class.TRAINER_EMP>
	<cfinclude template="../query/get_employee.cfm">
	<cfset email_value = GET_EMPLOYEE.EMPLOYEE_EMAIL>
<cfelseif LEN(get_class.TRAINER_PAR)>
	<cfset attributes.PARTNER_ID = get_class.TRAINER_PAR>
	<cfinclude template="../query/get_partner.cfm">
	<cfset email_value = GET_PARTNER.COMPANY_PARTNER_EMAIL>
<cfelse>
	<cfset email_value = "">
</cfif>
<!--- // Egitimci Mailleri --->
<table width="650" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='417.Eğitmen Görev Bildirim Yazısı'></td>
    <!-- sil -->
     <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' extra_parameters='mail_list.mails'>
    <!-- sil -->
  </tr>
</table>
<br/>
<table width="650" border="0" align="center">
  <tr>
    <td width="180" height="22" class="txtbold"><cf_get_lang no='113.Eğitimin Adı'></td>
    <td>: <cfoutput>#get_class.class_name#</cfoutput></td>
  </tr>
  <tr>
    <td height="22" class="txtbold"><cf_get_lang_main no='243.Başlangıç Tarihi'> / <cf_get_lang_main no='79.Saat'></td>
    <td> :
      <cfif len(get_class.start_date)>
        <cfoutput>#dateformat(start_date,dateformat_style)# #timeformat(start_date,timeformat_style)#</cfoutput>
      </cfif>
    </td>
  </tr>
  <tr>
    <td height="22" class="txtbold"><cf_get_lang_main no='288.Bitiş Tarihi'> / <cf_get_lang_main no='79.Saat'></td>
    <td>:
      <cfif len(get_class.finish_date)>
        <cfoutput> #dateformat(finish_date,dateformat_style)# #timeformat(finish_date,timeformat_style)#</cfoutput>
      </cfif>
    </td>
  </tr>
  <tr>
    <td height="22" valign="top" class="txtbold"><cf_get_lang no='30.Eğitim Yerinin Adres'>/ <cf_get_lang_main no='87.Telefon'></td>
    <td valign="top">: <strong><cfoutput>#get_class.CLASS_PLACE#</cfoutput></strong> - <cfoutput>#get_class.CLASS_PLACE_ADDRESS#</cfoutput> - <cfoutput>#get_class.CLASS_PLACE_TEL#</cfoutput></td>
  </tr>
  <cfquery name="get_training_poscats_departments" datasource="#dsn#">
	  SELECT 
		  TRAIN_POSITION_CATS, 
		  TRAIN_DEPARTMENTS 
	  FROM 
		  TRAINING WHERE TRAIN_ID
					IN 
					(
							SELECT 
								TRAIN_ID 
							FROM 
								TRAINING_CLASS_SECTIONS 
							WHERE 
								CLASS_ID = #attributes.CLASS_ID#
					)
  </cfquery>
  <!--- <tr>
    <td height="22" class="txtbold"><cf_get_lang no='117.Eğitmen'></td>
    <td>:
      <cfif LEN(get_class.TRAINER_EMP)>
        <cfset attributes.EMPLOYEE_ID=get_class.TRAINER_EMP>
        <cfinclude template="../query/get_employee.cfm">
        <cfoutput>#GET_EMPLOYEE.EMPLOYEE_NAME# #GET_EMPLOYEE.EMPLOYEE_SURNAME#</cfoutput>
      <cfelseif LEN(get_class.TRAINER_PAR)>
        <cfset attributes.PARTNER_ID=get_class.TRAINER_PAR>
        <cfinclude template="../query/get_partner.cfm">
        <cfoutput>#GET_PARTNER.COMPANY_PARTNER_NAME# #GET_PARTNER.COMPANY_PARTNER_SURNAME#</cfoutput>
      </cfif>
    </td>
  </tr> --->
<!--- 		  burada trainer ın maili bulunup eklenecek.. o kadar.. --->
	<form name="mail_list">
	<!--- <input name="mails" type="hidden" value="<cfif Len(mails) gt 1><cfoutput>#Left(mails,Len(mails) - 1)#</cfoutput></cfif>"> --->
		<input name="mails" id="mails" type="hidden" value="<cfoutput>#email_value#</cfoutput>">
	</form>	  
  <tr>
    <td height="22" class="txtbold"><cf_get_lang no='35.Eğitim Yeri Sorumlusu'></td>
    <td>: <cfoutput>#get_class.CLASS_PLACE_MANAGER#</cfoutput> </td>
  </tr>
 <!---  <tr>
    <td height="22" class="txtbold"><cf_get_lang no='138.Program Sorumlusu'></td>
    <td>: <cfoutput>#get_class.CLASS_PLACE_MANAGER#</cfoutput></td>
  </tr> --->
  <tr>
    <td height="22" valign="top" class="txtbold"><cf_get_lang no='427.Ders İçeriği'></td>
    <td>: <cfoutput>#ParagraphFormat(get_class.class_objective)#</cfoutput></td>
  </tr>
  <tr>
    <td height="22" valign="top" class="txtbold"><cf_get_lang no='201.Açıklamalar'></td>
    <td>: <cf_get_lang no='165.Katılımcıların Eğitimden En Az 15 dk Öncesinde Eğitim Yerinde Bulunmaları Gerekmektedir Eğitimlerde Kıyafet Serbesttir'></td>
  </tr>
  <!--- <tr>
    <td colspan="2" class="txtbold"><cf_get_lang_main no='178.Katılımcılar'> :</td>
		  </tr>
            <cfquery name="get_emp_att" datasource="#dsn#">
				SELECT 
					EMP_ID 
				FROM 
					TRAINING_CLASS_ATTENDER 
				WHERE 
					CLASS_ID=#attributes.CLASS_ID#
				AND 
					EMP_ID IS NOT NULL 
				AND 
					PAR_ID IS NULL AND CON_ID IS NULL
            </cfquery>
            <cfset mails = "">
            <cfset admins = "">
            <cfset participations = ""> --->
			<!--- <tr>
			<td colspan="2">
				<table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
				<tr class="color-border"> 
				<td> 
				<table cellspacing="1" cellpadding="2" width="100%" border="0" class="label">
				<tr class="color-header" height="22"> 
				<td class="form-title" width="150"><cf_get_lang_main no='580.Bölge'></td>
				<td class="form-title"><cf_get_lang_main no='158.Ad Soyad'></td>
				<td class="form-title" width="150"><cf_get_lang_main no='162.Şirket'></td>
				<td class="form-title" width="150"><cf_get_lang no='159.Ünvan'></td>
            <cfoutput query="get_emp_att">
            <cfquery name="get_emp_name" datasource="#dsn#">
				SELECT 
					EP.EMPLOYEE_ID,
					EP.EMPLOYEE_NAME, 
					EP.EMPLOYEE_SURNAME, 
					EP.EMPLOYEE_EMAIL,
					EP.POSITION_NAME,
					EP.DEPARTMENT_ID,
					D.BRANCH_ID,
					B.BRANCH_NAME,
					B.COMPANY_ID,
					OC.COMPANY_NAME
				FROM 
					EMPLOYEE_POSITIONS AS EP,
					DEPARTMENT AS D,
					BRANCH AS B,
					OUR_COMPANY AS OC
				WHERE 
					EP.EMPLOYEE_ID=#EMP_ID#
				AND
					D.DEPARTMENT_ID=EP.DEPARTMENT_ID
				AND 
					B.BRANCH_ID=D.BRANCH_ID
				AND
					OC.COMP_ID=B.COMPANY_ID
			    ORDER BY
					B.BRANCH_NAME,
					EP.EMPLOYEE_NAME,
					OC.COMPANY_NAME,
					EP.POSITION_NAME
              </cfquery>
              <cfquery name="get_admin1_name" datasource="#dsn#">
					SELECT 
						BRANCH.ADMIN1_POSITION_CODE 
					FROM 
						EMPLOYEES, 
						EMPLOYEE_POSITIONS AS EP, 
						DEPARTMENT AS DEP, 
						BRANCH 
					WHERE 
						EMPLOYEES.EMPLOYEE_ID = #EMP_ID# 
					AND
						EP.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID 
					AND 
						EP.DEPARTMENT_ID = DEP.DEPARTMENT_ID
					AND 
						DEP.BRANCH_ID = BRANCH.BRANCH_ID
              </cfquery>
              <cfif len(get_admin1_name.ADMIN1_POSITION_CODE)>
                <cfset admins = admins & get_admin1_name.ADMIN1_POSITION_CODE & ",">
              </cfif>
              <cfif len(EMP_ID)>
                <cfset participations = participations & EMP_ID & ",">
              </cfif>
              <cfif len(get_emp_name.EMPLOYEE_EMAIL) and (get_emp_name.EMPLOYEE_EMAIL contains "@") and (Len(get_emp_name.EMPLOYEE_EMAIL) gte 6)>
                <cfset mails = mails & get_emp_name.EMPLOYEE_EMAIL & ",">
              </cfif>			  
				</tr>
				<tr height="20" class="color-row">
				<td>#GET_EMP_NAME.BRANCH_NAME#</td>
				<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#emp_id#','project');" class="tableyazi">#GET_EMP_NAME.EMPLOYEE_NAME#&nbsp;#GET_EMP_NAME.EMPLOYEE_SURNAME#</a></td>
				<td>#GET_EMP_NAME.COMPANY_NAME#</td>
				<td>#GET_EMP_NAME.POSITION_NAME#</td>
				</tr>
				 </cfoutput>
            <cfif Len(admins) gt 1>
              <cfquery name="get_admin1_name" datasource="#dsn#">
				  SELECT 
				  	EMPLOYEES.EMPLOYEE_EMAIL, 
					EMPLOYEES.EMPLOYEE_ID 
				  FROM 
				  	EMPLOYEES ,
					EMPLOYEE_POSITIONS AS EP 
				  WHERE 
				  	EMPLOYEES.EMPLOYEE_ID = EP.EMPLOYEE_ID 
				  AND
				  	EP.POSITION_CODE IN (#Left(admins,Len(admins) - 1)#)	
              </cfquery>
              <cfloop query="get_admin1_name">
                <cfif len(EMPLOYEE_EMAIL) and (EMPLOYEE_EMAIL contains "@") and (Len(EMPLOYEE_EMAIL) gte 6) and not ListFind(participations,EMPLOYEE_ID)>
                  <cfset mails = mails & EMPLOYEE_EMAIL & ",">
                </cfif>
              </cfloop>
            </cfif>
            <form name="mail_list">
              <input name="mails" type="hidden" value="<cfif Len(mails) gt 1><cfoutput>#Left(mails,Len(mails) - 1)#</cfoutput></cfif>">
            </form>				 
				</table>
				</td>
				</tr>
				</table>
				</td>
			  </tr> --->
			  <tr>
			  <td colspan="2">&nbsp;</td>
        </tr>
		  <tr>
    <td colspan="2" valign="top" class="txtbold"> 
      <cf_get_lang no='202.Yukarıda Belirtilen Bilgiler Doğrultusunda İlgili Tarih ve Saatlerde Eğitim Yerinde Bulunmanızı Rica Ederiz'></td>
  </tr>

      </table>
    </td>
  </tr>
</table>

