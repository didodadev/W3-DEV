<!--- tc no kontrol --->
<cfif len(attributes.tc_identy_no) and attributes.xml_is_tc_number eq 1>
	<cfquery name="get_tc_identy_no" datasource="#DSN#">
		SELECT
			EI.TC_IDENTY_NO,
			E.EMPLOYEE_NAME + ' ' +E.EMPLOYEE_SURNAME EMP_NAME
		FROM
			EMPLOYEES E,
			EMPLOYEES_IDENTY EI
		WHERE
			E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
			EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tc_identy_no#">
	</cfquery>
	<cfif get_tc_identy_no.recordcount>
		<script type="text/javascript">
			alert("<cfoutput>#get_tc_identy_no.emp_name# <cf_get_lang no ='5.Adlı Çalışan Aynı TC Kimlik No İle Kayıtlı'></cfoutput>! <cf_get_lang no ='6.Lütfen Düzeltiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<!--- tc no kontrol --->

<cfquery name="get_employee" datasource="#dsn#">
	SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_NAME = '#attributes.employee_name#' AND EMPLOYEE_SURNAME = '#attributes.employee_surname#'
</cfquery>
<cfif get_employee.recordcount>
	<script type="text/javascript">
	if(!(confirm("<cfoutput>#attributes.employee_name# #attributes.employee_surname# adında bir çalışan kaydı daha var!\n Kaydetmek istediğinizen emin misiniz?</cfoutput>")))
	{
		history.back();
	}
	</script>
</cfif>
<cfif len(attributes.employee_password)>
	<cf_cryptedpassword password="#employee_password#" output="sifreli" mod="1">
	<cfset add_iam_cmp = createObject("V16.hr.cfc.add_iam")>
	<cfset add_iam = add_iam_cmp.add_iam(
		username : attributes.employee_username,
		member_name : attributes.employee_name,
		member_sname : attributes.employee_surname,
		password : sifreli,
		pr_mail : len(attributes.employee_email) ? attributes.employee_email : "",
		sec_mail : len(attributes.employee_email_spc) ? attributes.employee_email_spc : "",
		mobile_code : len(attributes.mobilcode) ? attributes.mobilcode : "",
		mobile_no : len(attributes.MOBILTEL) ? attributes.MOBILTEL : "",
		is_add : 1
	)>
</cfif>

<cfif len(attributes.employee_password) and len(attributes.EMPLOYEE_USERNAME)>
	<cfquery name="CHECK_NAME" datasource="#DSN#">
		SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_USERNAME = '#trim(EMPLOYEE_USERNAME)#'
	</cfquery>
	<cfif check_name.recordcount>
		<cfoutput>
			<script type="text/javascript">
				alert("<cf_get_lang no ='1727.Lütfen Başka Bir Kullanıcı Adı Girin'>!");
				history.back();
			</script>
			<cfabort>
		</cfoutput>
	</cfif>
</cfif>

<cfif not isDefined("form.employee_status")>
	<cfset form.employee_status = 0>
</cfif>

<cfif isDefined("photo") and len(form.photo)>
	<cfset upload_folder = "#upload_folder##dir_seperator#hr#dir_seperator#">
	<cftry>
		<cffile action="UPLOAD" filefield="photo" destination="#upload_folder#" mode="777" nameconflict="MAKEUNIQUE" accept="image/*">

		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		
		<!---Script dosyalarını engelle  02092010 FA,ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>		
			
		<cfset form.photo = '#file_name#.#cffile.serverfileext#'>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
</cfif>

<cfif isdate(attributes.expiry_date)><cf_date tarih="attributes.expiry_date"></cfif>
<cftransaction>
	<cfquery name="ADD_EMPLOYEES" datasource="#DSN#" result="my_result">
		INSERT INTO
			EMPLOYEES
		(
			EMPLOYEE_NO,
			<cfif len(EMPLOYEE_STATUS)> EMPLOYEE_STATUS,</cfif>
			<cfif len(attributes.EMPLOYEE_NAME)> EMPLOYEE_NAME,</cfif>
			<cfif len(attributes.EMPLOYEE_SURNAME)> EMPLOYEE_SURNAME,</cfif>
			EMPLOYEE_EMAIL,
			<cfif len(EMPLOYEE_USERNAME)> EMPLOYEE_USERNAME,</cfif>
<!---			<cfif len(IMCAT_ID)>IMCAT_ID,</cfif>
			<cfif len(IM)>IM,</cfif>--->
<!---			<cfif len(IMCAT2_ID)>IMCAT2_ID,</cfif>
			<cfif len(IM2)>IM2,</cfif>--->
			<cfif len(EMPLOYEE_PASSWORD )> EMPLOYEE_PASSWORD,</cfif>
			<cfif len(DIRECT_TELCODE)>DIRECT_TELCODE,</cfif>
			<cfif len(DIRECT_TEL)>DIRECT_TEL,</cfif>
			<cfif len(attributes.dahili_tel)>EXTENSION,</cfif>
			<cfif len(attributes.MOBILCODE)>MOBILCODE,</cfif>
			<cfif isdefined("attributes.MOBILTEL") and len(attributes.MOBILTEL)>MOBILTEL,</cfif>
			<cfif isDefined("form.photo") and len(form.photo)>
			PHOTO,
			PHOTO_SERVER_ID,
			</cfif>
			RECORD_DATE, 
			RECORD_EMP, 
			IS_IP_CONTROL,
			<cfif len(IP_ADDRESS)>IP_ADDRESS,</cfif>
			<cfif len(COMPUTER_NAME)>COMPUTER_NAME,</cfif>
			RECORD_IP,
			HIERARCHY,
			OZEL_KOD2,
			OZEL_KOD,
			IN_COMPANY_REASON_ID,
			IS_CRITICAL,
			EXPIRY_DATE,
			PER_ASSIGN_ID,
			EMPLOYEE_STAGE,
			EMPLOYEE_KEP_ADRESS,
			TEL_TYPE
		)
		VALUES
	    (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.employee_no#">,
			<cfif len(EMPLOYEE_STATUS)>#EMPLOYEE_STATUS#,</cfif>
			<cfif len(attributes.EMPLOYEE_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EMPLOYEE_NAME#">,</cfif>
			<cfif len(attributes.EMPLOYEE_SURNAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EMPLOYEE_SURNAME#">,</cfif>
			<cfif len(attributes.EMPLOYEE_EMAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EMPLOYEE_EMAIL#"><cfelse>NULL</cfif>,
			<cfif len(EMPLOYEE_USERNAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPLOYEE_USERNAME#">,</cfif>
<!---			<cfif len(IMCAT_ID)>#IMCAT_ID#,</cfif>
			<cfif len(IM)><cfqueryparam cfsqltype="cf_sql_varchar" value="#IM#">,</cfif>
			<cfif len(IMCAT2_ID)>#IMCAT2_ID#,</cfif>
			<cfif len(IM2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#IM2#">,</cfif>--->
			<cfif len(EMPLOYEE_PASSWORD)><cfqueryparam cfsqltype="cf_sql_varchar" value="#sifreli#">,</cfif>
			<cfif len(DIRECT_TELCODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#DIRECT_TELCODE#">,</cfif>
			<cfif len(DIRECT_TEL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#DIRECT_TEL#">,</cfif>
			<cfif len(attributes.dahili_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dahili_tel#">,</cfif>
			<cfif len(attributes.MOBILCODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.MOBILCODE#">,</cfif>
			<cfif isdefined("attributes.MOBILTEL") and len(attributes.MOBILTEL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.MOBILTEL#">,</cfif>
			<cfif isDefined("form.photo") and len(form.photo)>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PHOTO#">,
			#fusebox.server_machine#,
			</cfif>
			#now()#,
			#SESSION.EP.USERID#,
			<cfif isdefined("IS_IP_CONTROL")>1<cfelse>0</cfif>,
			<cfif len(IP_ADDRESS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#IP_ADDRESS#">,</cfif>
			<cfif len(COMPUTER_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#COMPUTER_NAME#">,</cfif>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			<cfif Len(attributes.hierarchy)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#"><cfelse>NULL</cfif>,
			<cfif len(attributes.ozel_kod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#"><cfelse>NULL</cfif>,
			<cfif len(attributes.ozel_kod_ilk)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod_ilk#"><cfelse>NULL</cfif>,
			<cfif len(attributes.reason_id)>#attributes.reason_id#,<cfelse>NULL,</cfif>
			<cfif isdefined('attributes.is_critical')>1<cfelse>0</cfif>,
			<cfif isdate(attributes.expiry_date)>#attributes.expiry_date#,<cfelse>NULL,</cfif>
			<cfif isDefined("attributes.per_assign_id") and Len(attributes.per_assign_id)>#attributes.per_assign_id#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.process_stage')>#attributes.process_stage#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.EMPLOYEE_KEP_ADRESS')><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EMPLOYEE_KEP_ADRESS#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.tel_type') and len(attributes.tel_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tel_type#"><cfelse>NULL</cfif>
		)
	</cfquery>
	<cfquery name="LAST_ID" datasource="#DSN#">
		SELECT MAX(EMPLOYEE_ID) AS LATEST_RECORD_ID FROM EMPLOYEES
	</cfquery>
</cftransaction>

<cfquery name="ADD_EMPLOYEES_DETAIL" datasource="#DSN#">
	INSERT INTO 
		EMPLOYEES_DETAIL
	(
		EMPLOYEE_ID,
		SEX,
		EMAIL_SPC,
		<cfif isDefined("ATTRIBUTES.mobilcode_spc")>MOBILCODE_SPC,</cfif>
		MOBILTEL_SPC,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	)
	VALUES
	(			
		#LAST_ID.LATEST_RECORD_ID#,
		#ATTRIBUTES.SEX#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.employee_email_spc#">,
		<cfif isDefined("ATTRIBUTES.mobilcode_spc")><cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.mobilcode_spc#">,</cfif>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.mobiltel_spc#">,
		#now()#,
		#SESSION.EP.USERID#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
	)
</cfquery> 

<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
	UPDATE EMPLOYEES SET MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="E#LAST_ID.LATEST_RECORD_ID#"> WHERE EMPLOYEE_ID = #LAST_ID.LATEST_RECORD_ID#
</cfquery>
<cfquery name="ADD_IDENTY" datasource="#dsn#">
	INSERT INTO
		EMPLOYEES_IDENTY
	(
		EMPLOYEE_ID,
		TC_IDENTY_NO,
		RECORD_DATE,
		RECORD_IP,
		RECORD_EMP
	)
	VALUES
	(
		#LAST_ID.LATEST_RECORD_ID#,	
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.TC_IDENTY_NO#">,
		#now()#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
		#session.ep.userid#
	)
</cfquery>
<cfquery name="add_healty" datasource="#DSN#">
	INSERT INTO
		EMPLOYEE_HEALTY
	(
		EMPLOYEE_ID,
		STATUS,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	)
	VALUES
	(
		#LAST_ID.LATEST_RECORD_ID#,	
		1,
		#NOW()#,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_USER#'
	)
</cfquery>

<!--- Adres Defteri --->
<cf_addressbook
	design		= "1"
	type		= "1"
	type_id		= "#last_id.latest_record_id#"
	name		= "#attributes.employee_name#"
	surname		= "#attributes.employee_surname#"
	email		= "#attributes.employee_email#"
	telcode		= "#attributes.direct_telcode#"
	telno		= "#attributes.direct_tel#"
	mobilcode	= "#attributes.mobilcode#"
	mobilno		= "#attributes.mobiltel#">

<cfquery name="ADD_TIME_ZONE" datasource="#DSN#">
	INSERT INTO
		MY_SETTINGS
	(
		EMPLOYEE_ID,
		DAY_AGENDA,
		MAIN_NEWS,
		TIME_ZONE,
		LANGUAGE_ID,
		INTERFACE_ID,
		INTERFACE_COLOR,
		AGENDA,
		POLL_NOW,
		MYWORKS,
		MY_VALIDS,
		MY_BUYERS,
		MY_SELLERS,
		MAXROWS,
		TIMEOUT_LIMIT
	)
	VALUES
	(
		#LAST_ID.LATEST_RECORD_ID#,
		1,
		1,
		#FORM.TIME_ZONE#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.LANGUAGE#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.design_id#">,
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		20,
		30
	)
</cfquery>
<cfset attributes.ini_employee_id = LAST_ID.LATEST_RECORD_ID>
<cfinclude template="../../myhome/query/initialize_menu_positions.cfm">
<cfif len(attributes.system_paper_no_add)>
	<cfquery name="UPD_GEN_PAP" datasource="#DSN#">
		UPDATE GENERAL_PAPERS_MAIN SET EMPLOYEE_NUMBER = #attributes.system_paper_no_add# WHERE EMPLOYEE_NUMBER IS NOT NULL
	</cfquery>
</cfif>
<!---Ek Bilgiler--->
<cfset attributes.info_id = my_result.IDENTITYCOL>
<cfset attributes.is_upd = 0>
<cfset attributes.info_type_id = -4>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='EMPLOYEES'
	action_column='EMPLOYEE_ID'
	action_id='#LAST_ID.LATEST_RECORD_ID#'
	action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_hr&event=upd&employee_id=#LAST_ID.LATEST_RECORD_ID#' 
	warning_description="#getLang('','Kişi',29831)# : #attributes.employee_name# #attributes.employee_surname#">
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#LAST_ID.LATEST_RECORD_ID#</cfoutput>';
</script>
