<cfquery name="GET_EMP_REQ" datasource="#dsn#">
	SELECT
		TCA.ANNOUNCE_ID,
		TCA.EMPLOYEE_ID,
		TCA.CLASS_ID,
		E.EMPLOYEE_ID ID,
		E.EMPLOYEE_NAME AD,
		E.EMPLOYEE_SURNAME SOYAD,
		E.EMPLOYEE_EMAIL AS EMAIL,
		'EMPLOYEE' AS TYPE
	FROM
		TRAINING_CLASS_ANNOUNCE_ATTS TCA,
		EMPLOYEES E
	WHERE
		TCA.ANNOUNCE_ID = #attributes.announce_id# AND
		E.EMPLOYEE_ID=TCA.EMPLOYEE_ID
	UNION ALL
	SELECT
		TCA.ANNOUNCE_ID,
		TCA.PAR_ID,
		TCA.CLASS_ID,
		CP.PARTNER_ID AS ID,
		CP.COMPANY_PARTNER_NAME AS AD,
		CP.COMPANY_PARTNER_SURNAME AS SOYAD,
		CP.COMPANY_PARTNER_EMAIL AS EMAIL,
		'CONSUMER' AS TYPE
	FROM
		TRAINING_CLASS_ANNOUNCE_ATTS TCA,
		COMPANY_PARTNER CP
	WHERE
		TCA.ANNOUNCE_ID = #attributes.announce_id# AND
		CP.PARTNER_ID=TCA.PAR_ID
	UNION ALL
	SELECT
		TCA.ANNOUNCE_ID,
		TCA.CONS_ID,
		TCA.CLASS_ID,
		C.CONSUMER_ID AS ID,
		C.CONSUMER_NAME AS AD,
		C.CONSUMER_SURNAME AS SOYAD,
		C.CONSUMER_EMAIL AS EMAIL,
		'PARTNER' AS TYPE
	FROM
		TRAINING_CLASS_ANNOUNCE_ATTS TCA,
		CONSUMER C
	WHERE
		TCA.ANNOUNCE_ID = #attributes.announce_id# AND
		C.CONSUMER_ID=TCA.CONS_ID
	ORDER BY AD,SOYAD
</cfquery>
<cfquery name="get_announce_detail" datasource="#dsn#">
	SELECT ANNOUNCE_HEAD,START_DATE,FINISH_DATE,DETAIL FROM TRAINING_CLASS_ANNOUNCEMENTS WHERE ANNOUNCE_ID = #attributes.announce_id#
</cfquery>
	<cfset email = valuelist(GET_EMP_REQ.EMAIL,',')>
	<cfset uzunluk = listlen(email)>
<cfset sender = "#session.ep.company#<#session.ep.company_email#>">
<cfloop query="GET_EMP_REQ">
<cfset sender_upper_position = "">
	<cfif GET_EMP_REQ.TYPE is 'employee'>
		<cfquery name="get_upper_position_code" datasource="#dsn#">
			SELECT UPPER_POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #ID#
		</cfquery>
		<cfif get_upper_position_code.recordcount and len(get_upper_position_code.UPPER_POSITION_CODE)>
			<cfquery name="get_upper_position_employee_id" datasource="#dsn#">
				SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #get_upper_position_code.UPPER_POSITION_CODE#
			</cfquery>
			<cfif get_upper_position_employee_id.recordcount and len(get_upper_position_employee_id.employee_id)>
				<cfquery name="get_upper_position_email" datasource="#dsn#">
					SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_upper_position_employee_id.EMPLOYEE_ID#
				</cfquery>
			</cfif>
		</cfif>
		<cfif isdefined("get_upper_position_email") and get_upper_position_email.recordcount and len(get_upper_position_email.EMPLOYEE_EMAIL)>
			<cfset sender_upper_position = get_upper_position_email.EMPLOYEE_EMAIL>
		</cfif>
	</cfif>
	<cfquery name="get_classes_list" datasource="#dsn#">
		SELECT
			TC.CLASS_ID,
			TC.CLASS_NAME,
			TC.START_DATE,
			TC.FINISH_DATE,
			TC.CLASS_PLACE,
			TC.CLASS_PLACE_ADDRESS,
			TCG.ANNOUNCE_CLASS_ID 
		FROM
			TRAINING_CLASS_ANNOUNCE_CLASSES TCG,
			TRAINING_CLASS TC
		WHERE
			TC.CLASS_ID=TCG.CLASS_ID AND
			TCG.ANNOUNCE_ID=#attributes.announce_id# 
	</cfquery>
	<cfif len(GET_EMP_REQ.EMAIL)>
		<cfmail to="#GET_EMP_REQ.EMAIL#"
			cc="<cfif len(sender_upper_position)>#sender_upper_position#</cfif>"
			from="#sender#"
			subject="#get_announce_detail.ANNOUNCE_HEAD#" type="HTML">
			Başlangıç Tarihi :#dateformat(get_announce_detail.START_DATE,dateformat_style)#<br/>
			Bitiş Tarihi : #dateformat(get_announce_detail.FINISH_DATE,dateformat_style)#<br/>
			Konu : #get_announce_detail.ANNOUNCE_HEAD#<br/><br/>
			Sayın #GET_EMP_REQ.AD#  #GET_EMP_REQ.SOYAD#,<br/><br/>
			<cfloop query="get_classes_list">
				#dateformat(get_classes_list.START_DATE,dateformat_style)# tarihinde saat #timeformat(date_add('h',session.ep.time_zone,get_classes_list.START_DATE),timeformat_style)# - #timeformat(date_add('h',session.ep.time_zone,get_classes_list.FINISH_DATE),timeformat_style)# arası <cfif len(get_classes_list.CLASS_PLACE)>#get_classes_list.CLASS_PLACE# eğitim salonunda</cfif> #get_classes_list.CLASS_NAME# <cfif currentrow neq get_classes_list.recordcount>,</cfif><br/>
			</cfloop><br/>
			konulu <cfif get_classes_list.recordcount gt 1>eğitimler<cfelse>eğitim</cfif> düzenlenecektir.Katılmanızı rica eder.<br/><br/>
			İyi Eğitimler Dileriz.<br/><br/>
			Eğitim Talebinde Bulunmak için <a href="#user_domain##request.self#?fuseaction=training.popup_upd_announce_req&announce_id=#attributes.announce_id#&mail=1">Tıklayınız...</a>
		</cfmail>
		<cfoutput>#GET_EMP_REQ.EMAIL#</cfoutput><br />
	</cfif>
</cfloop>
<script type="text/javascript">
 alert("<cf_get_lang_main no ='101.Mail Başarıyla Gitmiştir'>");
 history.back();
</script>
