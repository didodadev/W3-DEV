<cfquery name="GET_TOTAL" datasource="#dsn#">
	SELECT COUNT(EMP_ID) AS TOTAL_EMP,COUNT(CON_ID) AS TOTAL_PAR,COUNT(PAR_ID) AS TOTAL_CON FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = #attributes.class_id#
</cfquery>
<cfquery name="GET_CLASS" datasource="#dsn#">
	SELECT MAX_PARTICIPATION FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.class_id#
</cfquery>
<cfset total = get_total.total_emp + get_total.total_par + get_total.total_con> 

<cfif len(get_class.max_participation) and (total gte get_class.max_participation)>
	<script type="text/javascript">
		alert("<cf_get_lang no ='202.Bu Dersin Kontenjanı Dolmuştur'> !");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_CLASS_TRAINING_REQUEST_ROWS" datasource="#dsn#">
	SELECT CLASS_ID,EMPLOYEE_ID FROM TRAINING_REQUEST_ROWS WHERE CLASS_ID = #attributes.class_id# AND EMPLOYEE_ID = #attributes.EMP_ID#
</cfquery>
<cfif GET_CLASS_TRAINING_REQUEST_ROWS.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang no ='203.Daha önce bu ders için talepte bulunmuşsunuz'> !");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_CLASS_TRAINING_ATTENDER" datasource="#dsn#">
	SELECT CLASS_ID,EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = #attributes.class_id# AND EMP_ID = #attributes.EMP_ID#
</cfquery>
<cfif GET_CLASS_TRAINING_ATTENDER.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang no ='204.Bu Derste Katılımcısınız Tekrar Talepte Bulunamazsınız'> !");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfquery name="get_class" datasource="#dsn#">
	SELECT * FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.CLASS_ID#
</cfquery>
<cfquery name="get_class_emp_att" datasource="#dsn#">
	SELECT 
		TRAINING_CLASS.START_DATE ,
		TRAINING_CLASS.FINISH_DATE
	FROM
		TRAINING_CLASS,
		TRAINING_CLASS_ATTENDER 
	WHERE 
		TRAINING_CLASS_ATTENDER.CLASS_ID=TRAINING_CLASS.CLASS_ID 
		AND TRAINING_CLASS_ATTENDER. EMP_ID = #attributes.EMP_ID#
		AND
		 (
		   (
			  TRAINING_CLASS.START_DATE >= #CreateODBCDateTime(get_class.START_DATE)#
				AND
			  TRAINING_CLASS.START_DATE < #CreateODBCDateTime(get_class.FINISH_DATE)#
			)
			  OR
			(
			  TRAINING_CLASS.FINISH_DATE >= #CreateODBCDateTime(get_class.START_DATE)#
				AND
			  TRAINING_CLASS.FINISH_DATE < #CreateODBCDateTime(get_class.FINISH_DATE)#
			) 
		 )
</cfquery>
<cfif get_class_emp_att.recordcount>
	<script type="text/javascript">
		alert("<cfoutput>#get_emp_info(attributes.EMP_ID,0,0)#</cfoutput> Bu tarihler arasında başka bir eğitimde katılımcısınız");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfif isdefined("attributes.announce_id") and len(attributes.announce_id)>
	<cfquery name="ADD_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
		INSERT INTO
			TRAINING_REQUEST_ROWS
			(
				EMPLOYEE_ID,
				CLASS_ID,
				ANNOUNCE_ID,
				IS_CHIEF_VALID,
				IS_VALID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				#attributes.EMP_ID#,
				#attributes.CLASS_ID#,
				#attributes.announce_id#,
				0,
				0,
				#Now()#,
				#session.ep.userid#,
				'#REMOTE_ADDR#'
			)
	</cfquery>
	<cfquery name="UPD_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
		UPDATE
			TRAINING_CLASS_ANNOUNCE_ATTS
		SET
			CLASS_ID = #attributes.CLASS_ID#
		WHERE
			ANNOUNCE_ID = #attributes.announce_id# AND
			EMPLOYEE_ID = #attributes.EMP_ID#
	</cfquery>
<cfelse>
	<cfquery name="ADD_TRAINING_JOIN_REQUESTS" datasource="#dsn#" result="MAX_ID">
		INSERT INTO
			TRAINING_REQUEST_ROWS
			(
			EMPLOYEE_ID,
			CLASS_ID,
			IS_CHIEF_VALID,
			IS_VALID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
			)
			VALUES
			(
			#attributes.EMP_ID#,
			#attributes.CLASS_ID#,
			0,
			0,
			#Now()#,
			#session.ep.userid#,
			'#REMOTE_ADDR#'
			)
	</cfquery>
</cfif>
<cfquery name="GET_LIST_EMPLOYEE_CLASS" datasource="#dsn#">
	SELECT 
		TC.CLASS_ID,
		TC.CLASS_NAME,
		TC.START_DATE, 
		TC.FINISH_DATE, 
		TC.MONTH_ID,
		TC.CLASS_PLACE,
		TC.CLASS_ANNOUNCEMENT_DETAIL
	FROM 
		TRAINING_CLASS AS TC
	WHERE
		TC.CLASS_ID = #attributes.CLASS_ID#
</cfquery>

<cfquery name="get_upper_position" datasource="#dsn#">
	SELECT
		POSITION_ID,
		UPPER_POSITION_CODE,
		EMPLOYEE_ID,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		EMPLOYEE_ID = #attributes.EMP_ID#
</cfquery>
<cfif get_upper_position.recordcount and len(get_upper_position.UPPER_POSITION_CODE)>
	<!--- EĞİTİM TALEBİ İÇİN AMİRE MAİL --->
	<cfquery name="get_emps_detail" datasource="#dsn#">
		SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE =  #get_upper_position.UPPER_POSITION_CODE#
	</cfquery>
	<cfif get_emps_detail.recordcount and len(get_emps_detail.EMPLOYEE_ID)>
		<cfquery name="emps" datasource="#DSN#">
			SELECT EMPLOYEE_EMAIL,EMPLOYEE_SURNAME,EMPLOYEE_ID,EMPLOYEE_NAME
			FROM EMPLOYEES
			WHERE EMPLOYEE_ID = #get_emps_detail.EMPLOYEE_ID#
		</cfquery>
		<cfset subject = 'Eğitim Talebi'>
		<cfif emps.recordcount and len(emps.EMPLOYEE_EMAIL)>
			<cfmail to="#emps.EMPLOYEE_EMAIL#" from="#session.ep.company#<#session.ep.company_email#>"
				subject="Eğitim Talebi" type="HTML">
				#get_upper_position.EMPLOYEE_NAME# #get_upper_position.EMPLOYEE_SURNAME# #dateformat(GET_LIST_EMPLOYEE_CLASS.START_DATE,dateformat_style)# tarihinde başlayan #GET_LIST_EMPLOYEE_CLASS.CLASS_NAME# adlı eğitime katılım<br/>
				talebinde bulunmuştur. Eğitim talebini onaylamak için <a href="#employee_domain##request.self#?fuseaction=training.list_class_valid" target="_blank"><b>tıklayınız</b></a><br/><br/>
				<b>Eğitim Bilgileri :</b> <br/><br/>
				<b>Başlangıç :</b>#dateformat(GET_LIST_EMPLOYEE_CLASS.START_DATE,dateformat_style)# / #timeformat(date_add('h',session.ep.time_zone,GET_LIST_EMPLOYEE_CLASS.START_DATE),timeformat_style)#<br/>
				<b>Bitiş : </b>#dateformat(GET_LIST_EMPLOYEE_CLASS.FINISH_DATE,dateformat_style)# / #timeformat(date_add('h',session.ep.time_zone,GET_LIST_EMPLOYEE_CLASS.FINISH_DATE),timeformat_style)#<br/>
				<b>Dersin Adı :</b> #GET_LIST_EMPLOYEE_CLASS.CLASS_NAME#<br/>
				<b>Eğitim Yeri :</b> #GET_LIST_EMPLOYEE_CLASS.CLASS_PLACE#<br/>
				<b>Eğitim İçeriği : </b>#GET_LIST_EMPLOYEE_CLASS.CLASS_ANNOUNCEMENT_DETAIL#<br/> 
			</cfmail>
		</cfif>
	</cfif>
	<!--- EĞİTİM TALEBİ İÇİN AMİRE MAİL  --->
<cfelse>
	<cfquery name="UPD_TRAINING_REQUEST_ROWS" datasource="#dsn#">
		UPDATE TRAINING_REQUEST_ROWS SET IS_CHIEF_VALID = 1 WHERE REQUEST_ROW_ID = #MAX_ID.IDENTITYCOL#
	</cfquery>
</cfif>
<cfif isdefined("attributes.mail") and len(attributes.mail) and attributes.mail eq 1>
	<cflocation url="#request.self#?fuseaction=training.list_class_announce" addtoken="no">
<cfelseif isdefined("attributes.is_class_detail_form")>
	<cflocation url="#request.self#?fuseaction=training.view_class&class_id=#attributes.class_id#" addtoken="no">
<cfelse>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>
