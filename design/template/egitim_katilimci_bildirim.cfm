<!--- Standart Egitim Katilimci Bildirim --->
<cf_get_lang_set module_name="training_management"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="get_class" datasource="#dsn#">
	SELECT
		E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS AD,
		E.EMPLOYEE_EMAIL AS EMAIL,
		EPOS.POSITION_NAME AS POS,
		TCA.EMP_ID,
		TCA.PAR_ID,
		TCA.CON_ID,
		TC.CLASS_NAME,
		TC.TRAINING_ID,
		TC.START_DATE,
		TC.FINISH_DATE,
		TC.CLASS_PLACE,
		TC.CLASS_PLACE_ADDRESS,
		TC.CLASS_PLACE_TEL,
		TC.CLASS_PLACE_MANAGER,
		TC.CLASS_OBJECTIVE,
		TC.CLASS_ANNOUNCEMENT_DETAIL,
		<!--- TC.TRAINER_PAR,
		TC.TRAINER_EMP, --->
		C.NICK_NAME AS NICKNAME
	FROM
		TRAINING_CLASS_ATTENDER TCA,
		TRAINING_CLASS TC,
		EMPLOYEES E,
		EMPLOYEE_POSITIONS EPOS,
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY C
	WHERE
		E.EMPLOYEE_ID = EPOS.EMPLOYEE_ID AND 
		EPOS.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.BRANCH_ID=B.BRANCH_ID AND
		C.COMP_ID=B.COMPANY_ID AND 
		TC.CLASS_ID = TCA.CLASS_ID AND 
		EPOS.EMPLOYEE_ID = TCA.EMP_ID AND 
		TCA.EMP_ID IS NOT NULL AND 
		EPOS.IS_MASTER = 1 AND 
		TCA.CLASS_ID = #attributes.action_id#
	UNION
	SELECT 
		COMP.COMPANY_PARTNER_NAME+' '+COMP.COMPANY_PARTNER_SURNAME AS AD,
		COMP.COMPANY_PARTNER_EMAIL AS EMAIL,
		COMP.TITLE AS POS,
		TCA.EMP_ID,
		TCA.PAR_ID,
		TCA.CON_ID,
		TC.CLASS_NAME,
		TC.TRAINING_ID,
		TC.START_DATE,
		TC.FINISH_DATE,
		TC.CLASS_PLACE,
		TC.CLASS_PLACE_ADDRESS,
		TC.CLASS_PLACE_TEL,
		TC.CLASS_PLACE_MANAGER,
		TC.CLASS_OBJECTIVE,
		TC.CLASS_ANNOUNCEMENT_DETAIL ,
		<!--- TC.TRAINER_PAR,
		TC.TRAINER_EMP, --->
		C.NICKNAME AS NICKNAME
	FROM
		TRAINING_CLASS_ATTENDER TCA,
		TRAINING_CLASS TC,
		COMPANY_PARTNER COMP,
		COMPANY C
	WHERE	
		COMP.COMPANY_ID = C.COMPANY_ID AND 
		TC.CLASS_ID = TCA.CLASS_ID AND
		TCA.CLASS_ID = #attributes.action_id# AND 
		COMP.PARTNER_ID = TCA.PAR_ID  AND 
		TCA.PAR_ID IS NOT NULL
	UNION
	SELECT
		CON.CONSUMER_NAME+' '+CON.CONSUMER_SURNAME AS AD,
		CON.CONSUMER_EMAIL AS EMAIL,
		CON.TITLE AS POS,
		TCA.EMP_ID,
		TCA.PAR_ID,
		TCA.CON_ID,
		TC.CLASS_NAME,
		TC.TRAINING_ID,
		TC.START_DATE,
		TC.FINISH_DATE,
		TC.CLASS_PLACE,
		TC.CLASS_PLACE_ADDRESS,
		TC.CLASS_PLACE_TEL,
		TC.CLASS_PLACE_MANAGER,
		TC.CLASS_OBJECTIVE,
		TC.CLASS_ANNOUNCEMENT_DETAIL,
		<!--- TC.TRAINER_PAR,
		TC.TRAINER_EMP, --->
		CON.COMPANY AS NICKNAME
	FROM
		TRAINING_CLASS_ATTENDER TCA,
		TRAINING_CLASS TC,
		CONSUMER CON
	WHERE
		TC.CLASS_ID = TCA.CLASS_ID AND
		TCA.CLASS_ID = #attributes.action_id# AND 
		CON.CONSUMER_ID = TCA.CON_ID AND 
		TCA.CON_ID IS NOT NULL
</cfquery>

<cfquery name="get_training_poscats_departments" datasource="#dsn#">
	SELECT TRAIN_POSITION_CATS,TRAIN_DEPARTMENTS FROM TRAINING WHERE TRAIN_ID IN (SELECT TRAIN_ID FROM TRAINING_CLASS_SECTIONS WHERE CLASS_ID = #attributes.action_id#)
</cfquery>

<cfset attributes.training_id = get_class.training_id>
<cfif len(get_class.start_date)>
	<cfset start_date = date_add('h', session.ep.time_zone, get_class.start_date)>
</cfif>
<cfif len(get_class.finish_date)>
	<cfset finish_date = date_add('h', session.ep.time_zone, get_class.finish_date)>
</cfif>
<table style="text-align:center" cellpadding="0" cellspacing="0" border="0" height="35" style="width:180mm;">
	<tr><td style="height:10mm;">&nbsp;</td></tr>
    <tr>
		<td class="headbold"><cf_get_lang no='101.EĞİTİM BİLDİRİM FORMU'></td>
		<!---  <!-- sil -->
		<cf_workcube_file_action mail='1' extra_parameters='mail_list.mails'>
		<!-- sil --> --->
	</tr>
</table><br/>
<table border="0" style="text-align:center;width:180mm;">
	<cfoutput>
	<tr>
		<td style="width:15mm;">&nbsp;</td>
        <td style="width:35mm;height:6mm;text-align:left;" class="txtbold"><cf_get_lang no='113.Dersin Adı'></td>
		<td style="width:5mm;"> :</td>
        <td style="text-align:left;">&nbsp;#get_class.class_name#</td>
	</tr>
    <tr>
    	<td style="width:15mm;">&nbsp;</td>
		<td style="width:35mm;height:6mm;text-align:left;" class="txtbold"><cf_get_lang_main no='641.Başlangıç Tarihi'> / <cf_get_lang_main no='79.Saat'></td>
		<td style="width:5mm;"> :</td>
        <td style="text-align:left;">&nbsp;<cfif len(get_class.start_date)>#dateformat(start_date,dateformat_style)# #timeformat(start_date,timeformat_style)#</cfif></td>
	</tr>
	<tr>
    	<td style="width:15mm;">&nbsp;</td>
		<td style="width:35mm;height:6mm;text-align:left;" class="txtbold"><cf_get_lang_main no='288.Bitiş Tarihi'> / <cf_get_lang_main no='79.Saat'></td>
		<td style="width:5mm;"> :</td>
        <td style="text-align:left;">&nbsp;<cfif len(get_class.finish_date)>#dateformat(finish_date,dateformat_style)# #timeformat(finish_date,timeformat_style)#</cfif></td>
	</tr>
	<tr>
    	<td style="width:15mm;">&nbsp;</td>
		<td style="width:35mm;height:6mm;text-align:left;" valign="top" class="txtbold"><cf_get_lang no='30.Eğitim Yerinin Adres'>/ <cf_get_lang_main no='87.Telefon'></td>
		<td style="width:5mm;"> :</td>
		<td style="text-align:left;">&nbsp;<strong>#get_class.CLASS_PLACE#</strong> - #get_class.CLASS_PLACE_ADDRESS# - #get_class.CLASS_PLACE_TEL#</td>
	</tr>
	<tr>
    	<td style="width:15mm;">&nbsp;</td>
		<td style="width:35mm;height:6mm;text-align:left;" class="txtbold"><cf_get_lang no='117.Eğitmen'></td>
		<td style="width:5mm;"> :</td>
		<td style="text-align:left;">&nbsp;<!---<cfif len(get_class.trainer_emp)>#get_emp_info(get_class.trainer_emp,0,0)#<cfelseif len(get_class.trainer_par)>#get_par_info(get_class.trainer_par,0,0,0)#</cfif>---></td>
	</tr>
    <tr>
    	<td style="width:15mm;">&nbsp;</td>
    	<td style="width:35mm;height:6mm;text-align:left;" class="txtbold"><cf_get_lang no='35.Eğitim Yeri Sorumlusu'></td>
		<td style="width:5mm;"> :</td>
        <td style="text-align:left;">&nbsp;#get_class.CLASS_PLACE_MANAGER#</td>
	</tr>
	<tr>
    	<td style="width:15mm;">&nbsp;</td>
		<td style="width:35mm;height:6mm;text-align:left;" class="txtbold"><cf_get_lang no='427.Ders İçeriği'></td>
		<td style="width:5mm;"> :</td>
        <td style="text-align:left;">&nbsp;#get_class.class_objective#</td>
	</tr>
	<tr>
		<td style="width:15mm;">&nbsp;</td>
		<td style="width:35mm;height:6mm;text-align:left;" valign="top" class="txtbold"><cf_get_lang no='201.Açıklamalar'></td>
		<td style="width:5mm;" valign="top"> :</td>
		<td style="text-align:left;">&nbsp;#get_class.CLASS_ANNOUNCEMENT_DETAIL#</td>
	</tr>
	<tr>
    	<td style="width:15mm;">&nbsp;</td>
		<td style="height:6mm;text-align:center;" colspan="3" class="txtbold"><cf_get_lang_main no='178.Katılımcılar'> :</td>
	</tr>
	</cfoutput>
	<!--- <cfset mails = ""> --->
	<cfset admins = "">
	<cfset participations = "">
    <tr>
    	<td style="width:15mm;">&nbsp;</td>
		<td colspan="3">
		<table cellSpacing="0" cellpadding="0" border="0" width="100%" style="text-align:center">
			<tr class="color-border"> 
				<td colspan="3">
				<table border="0" width="100%"><!--- cellspacing="1" cellpadding="2" --->
					<tr class="color-header">
                        <td class="form-title"><cf_get_lang_main no='158.Ad Soyad'></td>
						<td class="form-title"><cf_get_lang_main no='162.Şirket'></td>
						<td class="form-title"><cf_get_lang_main no='1085.Pozisyon'></td>
					</tr>
					<cfoutput query="get_class">
					<!---   <cfif len(EMAIL) and (EMAIL contains "@") and (Len(EMAIL) gte 6)>
					<cfset mails = mails & EMAIL & ",">
					</cfif>  --->
					<tr class="color-row">
						<td>#ad#</td>
						<td>#nickname#</td>
						<td><cfif len(pos)>#pos#</cfif></td>
					</tr>
					<!--- <form name="mail_list">
					<input name="mails" type="hidden" value="<cfif Len(mails) gt 1><cfoutput>#Left(mails,Len(mails) - 1)#</cfoutput></cfif>">
					</form>	  --->
					</cfoutput>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<table border="0" style="width:180mm;">
    <tr><td style="height:8mm;">&nbsp;</td></tr>
    <tr><td style="height:8mm; text-align:center;"><cf_get_lang no="202.Yukarıda Belirtilen Bilgiler Doğrultusunda İlgili Tarih ve Saatlerde Eğitim Yerinde Bulunmanızı Rica Ederiz"></td></tr>
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
