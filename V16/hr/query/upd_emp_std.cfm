<!--- ayni calisan no olmamali --->
 <!--- <cfquery name="check_no" datasource="#DSN#">
	SELECT
		EMPLOYEE_ID,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_ID <> #attributes.EMPLOYEE_ID# AND
		EMPLOYEES.EMPLOYEE_NO = '#trim(EMPLOYEE_NO)#'
</cfquery>
<cfif check_no.recordcount>
	<cfoutput>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1749.Aynı Çalışan No ile Kayıt Var '>!<cf_get_lang_main no ='164.Çalışan'>: #check_no.employee_name# #check_no.employee_surname#");
			history.back();
		</script>
		<cfabort>
	</cfoutput>
</cfif> --->
<!--- tc no kontrol --->
<cfif len(attributes.tc_identy_no)>
	<cfquery name="get_tc_identy_no" datasource="#DSN#">
		SELECT
			EI.TC_IDENTY_NO,
			E.EMPLOYEE_NAME + ' ' +E.EMPLOYEE_SURNAME EMP_NAME
		FROM
			EMPLOYEES E,
			EMPLOYEES_IDENTY EI
		WHERE
			E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
			E.EMPLOYEE_STATUS = 1 AND
			EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tc_identy_no#"> AND
			E.EMPLOYEE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
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
<cfscript>
	SetEncoding("form","utf-8");
	if (isDefined("form.hr")) structdelete(form,"hr"); //image process ile ilgili olan field i siliyoruz
</cfscript>

<cfif len(employee_password)>
	<cf_cryptedpassword password="#employee_password#" output="employee_password" mod="1">
	<cfset workcube_license = createObject("V16.settings.cfc.workcube_license").get_license_information() />
	<cfset add_iam_cmp = createObject("V16.hr.cfc.add_iam")>
	<cfset add_iam = add_iam_cmp.add_iam(
		username : attributes.employee_username,
		member_name : attributes.employee_name,
		member_sname : attributes.employee_surname,
		password : employee_password,
		pr_mail : len(attributes.employee_email) ? attributes.employee_email : "",
		sec_mail : len(attributes.employee_email_spc) ? attributes.employee_email_spc : "",
		mobile_code : len(attributes.mobilcode) ? attributes.mobilcode : "",
		mobile_no : len(attributes.MOBILTEL) ? attributes.MOBILTEL : "",
		is_add : 0
	)>
</cfif>
<!--- 20040729 habersiz degismesin, cok onemli !!!
- Ayni kullanici adina sahip kullanici varsa (sifrelere bakmayalim) yeni bir kullanici adi girilmesi istensin
--->
<cfif len(attributes.EMPLOYEE_USERNAME)>
	<cfquery name="CHECK_USERNAME" datasource="#DSN#">
		SELECT
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME
		FROM
			EMPLOYEES
		WHERE
			EMPLOYEES.EMPLOYEE_ID <> #attributes.EMPLOYEE_ID# AND
			EMPLOYEES.EMPLOYEE_USERNAME = '#attributes.EMPLOYEE_USERNAME#'
	</cfquery>
	
	<cfif check_username.recordcount>
		<cfoutput>
			<script type="text/javascript">
				alert("Bu Kullanıcı Adı Kullanılıyor : #CHECK_USERNAME.EMPLOYEE_NAME# #CHECK_USERNAME.EMPLOYEE_SURNAME#");
				history.back();
			</script>
			<cfabort>
		</cfoutput>
	</cfif>
</cfif>

<cfquery name="RESIM" datasource="#DSN#">
	SELECT 
		PHOTO,
		PHOTO_SERVER_ID,
		EMPLOYEE_ID
	FROM 
		EMPLOYEES
	WHERE 
		EMPLOYEE_ID=#EMPLOYEE_ID#
</cfquery>

<cfset upload_folder = "#upload_folder#hr#dir_seperator#">

<cfif isDefined("del_photo")>
<!--- sadece varsa resmi sil --->
	<cfif len(resim.photo)>
		<cf_del_server_file output_file="hr/#resim.photo#" output_server="#resim.photo_server_id#">
	</cfif>
	<cfset form.photo = "">
<cfelse>
	<cfif isDefined("form.photo") and len(form.photo)>
	<!--- eski varsa sil --->
		<cfif len(resim.photo)>
			<cf_del_server_file output_file="hr/#resim.photo#" output_server="#resim.photo_server_id#">
		</cfif>
	<!--- yeni upload --->
		<cftry>
			<cffile
				action="UPLOAD" 
				filefield="photo" 
				destination="#upload_folder#" 
				mode="777" 
				nameconflict="MAKEUNIQUE"
				>
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
					history.back();
				</script>
				<cfabort>
			</cfcatch>  
		</cftry>

		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfset form.photo = '#file_name#.#cffile.serverfileext#'>

	<cfelse>
	<!--- eski deðeri yerine yaz --->
		<cfset form.photo = resim.photo>
	</cfif>
</cfif>

<cfif not isDefined("form.employee_status")>
	<cfset form.employee_status = 0>
</cfif>
<!--- standart bilgiler kaydedilir --->
<cfif isDefined("cffile.ServerFile")>
	<cfset path = "#upload_folder##form.photo#">
	<cfif ( findnocase("bmp","#path#",1) neq 0) and (session.resim eq 1)>  
		<cfx_WorkcubeImage name="image"
		                   action="rotate"
		                   src="#path#"
						   dst="#path#"
						   parameters="0">
		<cftry>
			<cffile action="DELETE" file="#path#">
		<cfcatch type="Any">
		   <script type="text/javascript">
			window.reload();
		   </script>
		</cfcatch>
		</cftry>
		<cfset session.resim = 2>
	<cfscript>
		form.photo = listgetat(form.photo,1,".")&"."&"jpg";
	</cfscript>
	</cfif>
</cfif>

<cf_date tarih="group_start">
<cfif isdate(attributes.kidem_date)>
	<cf_date tarih="attributes.kidem_date">
</cfif>
<cfif isdate(attributes.izin_date)>
	<cf_date tarih="attributes.izin_date">
</cfif>
<cfif isdate(attributes.expiry_date)>
	<cf_date tarih="attributes.expiry_date">
</cfif>
<!--- <cfoutput>#attributes.process_stage#</cfoutput> --->
<cfquery name="UPD_EMPLOYEES" datasource="#DSN#">
	UPDATE
		EMPLOYEES
	SET
	<cfif isdefined("attributes.EMPLOYEE_NO") and len(EMPLOYEE_NO)>
		EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPLOYEE_NO#">,
	</cfif>
    <cfif isdefined("IS_IP_CONTROL")>IS_IP_CONTROL = 1,<cfelse>IS_IP_CONTROL = 0,</cfif>
   <cfif isdefined("IP_ADDRESS") and len(IP_ADDRESS)>
	IP_ADDRESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#IP_ADDRESS#">,
	<cfelse>
	IP_ADDRESS = NULL,
   </cfif>
   <cfif isdefined("COMPUTER_NAME") and len(COMPUTER_NAME)>
	COMPUTER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#COMPUTER_NAME#">,
   </cfif>
	<cfif len(EMPLOYEE_STATUS)>EMPLOYEE_STATUS = #EMPLOYEE_STATUS#,</cfif>
	<cfif len(attributes.EMPLOYEE_NAME)>EMPLOYEE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.EMPLOYEE_NAME)#">,</cfif>
	<cfif len(attributes.EMPLOYEE_SURNAME)>EMPLOYEE_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.EMPLOYEE_SURNAME)#">,</cfif>
	EMPLOYEE_EMAIL = <cfif len(attributes.EMPLOYEE_EMAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPLOYEE_EMAIL#"><cfelse>NULL</cfif>,
	<cfif len(EMPLOYEE_USERNAME)>EMPLOYEE_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPLOYEE_USERNAME#">,<cfelse>EMPLOYEE_USERNAME = NULL,</cfif>
	<cfif len(EMPLOYEE_PASSWORD)>
		EMPLOYEE_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#employee_password#">,
	</cfif>
		DIRECT_TELCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DIRECT_TELCODE#">,
		DIRECT_TEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DIRECT_TEL#">,
		EXTENSION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EXTENSION#">,
		MOBILCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MOBILCODE#">, 
		MOBILTEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MOBILTEL#">, 
	<cfif len(PHOTO)>
		PHOTO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PHOTO#">,
		PHOTO_SERVER_ID = #fusebox.server_machine#,
	<cfelse>
		PHOTO = NULL, 
		PHOTO_SERVER_ID = NULL,
	</cfif>
	    GROUP_STARTDATE = #group_start#,
		KIDEM_DATE = <cfif isdate(attributes.kidem_date)>#attributes.kidem_date#<cfelse>NULL</cfif>,
		IZIN_DATE = <cfif isdate(attributes.izin_date)>#attributes.izin_date#<cfelse>NULL</cfif>,
		OLD_SGK_DAYS = <cfif isdefined("attributes.old_sgk_days") and len(attributes.old_sgk_days)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_sgk_days#"><cfelse>NULL</cfif>,
		IN_COMPANY_REASON_ID = <cfif len(attributes.reason_id)>#attributes.reason_id#<cfelse>NULL</cfif>,
		HIERARCHY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.HIERARCHY#">,
		OZEL_KOD=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.OZEL_KOD#">,
		OZEL_KOD2 = <cfif len(attributes.ozel_kod2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod2#">,<cfelse>NULL,</cfif>
        CORBUS_TEL= <cfif len(attributes.corbus_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.corbus_tel#">,<cfelse>NULL,</cfif>
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		IS_CRITICAL = <cfif isdefined('attributes.is_critical')>1<cfelse>0</cfif>,
		EXPIRY_DATE = <cfif isdate(attributes.expiry_date)>#attributes.expiry_date#<cfelse>NULL</cfif>,
		EMPLOYEE_STAGE = <cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
		EMPLOYEE_KEP_ADRESS = <cfif isdefined('attributes.EMPLOYEE_KEP_ADRESS') and len(attributes.EMPLOYEE_KEP_ADRESS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EMPLOYEE_KEP_ADRESS#"><cfelse>NULL</cfif>,
		TEL_TYPE = <cfif isdefined('attributes.tel_type') and len(attributes.tel_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tel_type#"><cfelse>NULL</cfif>
	WHERE
		EMPLOYEE_ID = #EMPLOYEE_ID#
</cfquery>

<cfquery name = "upd_timezone" datasource = "#dsn#">
		UPDATE
			MY_SETTINGS
		SET
			TIME_ZONE = <cfqueryparam cfsqltype="cf_sql_float" value="#TIME_ZONE#">
		WHERE
			EMPLOYEE_ID = #EMPLOYEE_ID#
</cfquery>

<cfquery name="add_Info" datasource="#dsn#">
INSERT INTO EMPLOYEES_HISTORY
(	EH.EMPLOYEE_ID
	,EH.EMPLOYEE_NAME
    ,EH.EMPLOYEE_SURNAME
    ,EH.EMPLOYEE_STATUS
    ,EH.EMPLOYEE_USERNAME
    ,EH.DIRECT_TELCODE
    ,EH.DIRECT_TEL
    ,EH.MOBILCODE
    ,EH.MOBILTEL
    ,EH.IS_IP_CONTROL
    ,EH.IP_ADDRESS
    ,EH.COMPUTER_NAME
    ,EH.GROUP_STARTDATE
    ,EH.HIERARCHY
    ,EH.OZEL_KOD
    ,EH.OZEL_KOD2
    ,EH.KIDEM_DATE
    ,EH.IZIN_DATE				
    ,EH.IN_COMPANY_REASON_ID
    ,EH.IS_CRITICAL
    ,EH.EXPIRY_DATE
    ,EH.EMPLOYEE_STAGE
	,EH.EMPLOYEE_NO
    ,EH.RECORD_DATE
    ,EH.RECORD_EMP
    ,EH.RECORD_IP
)
VALUES
(#EMPLOYEE_ID#,
	<cfif len(attributes.EMPLOYEE_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EMPLOYEE_NAME#">,<cfelse>NULL,</cfif>
	<cfif len(attributes.EMPLOYEE_SURNAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EMPLOYEE_SURNAME#">,<cfelse>NULL,</cfif>
	<cfif len(EMPLOYEE_STATUS)>#EMPLOYEE_STATUS#,<cfelse>NULL,</cfif>
	<cfif len(EMPLOYEE_USERNAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPLOYEE_USERNAME#">,<cfelse>NULL,</cfif>
	<cfif len(DIRECT_TELCODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#DIRECT_TELCODE#"><cfelse>NULL</cfif>,
	<cfif len(DIRECT_TEL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#DIRECT_TEL#">,<cfelse>NULL,</cfif>
	<cfif len(MOBILCODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#MOBILCODE#"><cfelse>NULL</cfif>, 
	<cfif len(MOBILTEL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#MOBILTEL#"><cfelse>NULL</cfif>, 
    <cfif isdefined("IS_IP_CONTROL")>1,<cfelse>0,</cfif>
    <cfif isdefined("IP_ADDRESS") and len(IP_ADDRESS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#IP_ADDRESS#">,<cfelse>NULL,</cfif>
   	<cfif isdefined("COMPUTER_NAME") and len(COMPUTER_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#COMPUTER_NAME#">,<cfelse>NULL,</cfif>
	<cfif len(group_start)>#group_start#<cfelse>NULL</cfif>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.HIERARCHY#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.OZEL_KOD#">,
	<cfif len(attributes.ozel_kod2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod2#">,<cfelse>NULL,</cfif>
	<cfif isdate(attributes.kidem_date)>#attributes.kidem_date#<cfelse>NULL</cfif>,
	<cfif isdate(attributes.izin_date)>#attributes.izin_date#<cfelse>NULL</cfif>,
	<cfif len(attributes.reason_id)>#attributes.reason_id#,<cfelse>NULL,</cfif>
	<cfif isdefined('attributes.is_critical')>1<cfelse>0</cfif>,
	<cfif isdate(attributes.expiry_date)>#attributes.expiry_date#<cfelse>NULL</cfif>,
	<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
	<cfif len(EMPLOYEE_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPLOYEE_NO#"><cfelse>NULL</cfif>, 
	#now()#,
	#SESSION.EP.USERID#,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
)
</cfquery>

<cfquery name="UPD_EMPLOYEES_IDENTY" datasource="#DSN#">
	UPDATE
		EMPLOYEES_IDENTY
	SET
		TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.TC_IDENTY_NO#">
	WHERE
		EMPLOYEE_ID = #EMPLOYEE_ID#
</cfquery>

<cfquery name="UPD_EMPLOYEES_SEX" datasource="#DSN#">
	UPDATE
		EMPLOYEES_DETAIL
	SET
		SEX = #ATTRIBUTES.SEX#,
		EMAIL_SPC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.employee_email_spc#">
		<cfif isDefined("attributes.mobilcode_spc")>
			,MOBILCODE_SPC = <cfif len(ATTRIBUTES.mobilcode_spc)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.mobilcode_spc#"><cfelse>NULL</cfif>
		</cfif>
		<cfif isdefined('attributes.mobiltel_spc')>
			,MOBILTEL_SPC = <cfif len(ATTRIBUTES.mobiltel_spc)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.mobiltel_spc#"><cfelse>NULL</cfif>
		</cfif>
	WHERE
		EMPLOYEE_ID = #EMPLOYEE_ID#
</cfquery>

<cfquery name="upd_position_emp_name" datasource="#dsn#">
	UPDATE 
		EMPLOYEE_POSITIONS
	SET
		EMPLOYEE_EMAIL = <cfif len(attributes.EMPLOYEE_EMAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPLOYEE_EMAIL#"><cfelse>NULL</cfif>,
		EMPLOYEE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPLOYEE_NAME#">,
		EMPLOYEE_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPLOYEE_SURNAME#">,
		HIERARCHY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.HIERARCHY#">
	WHERE
		EMPLOYEE_ID = #EMPLOYEE_ID#
</cfquery>

<cfif fusebox.dynamic_hierarchy and isdefined("attributes.dynamic_hierarchy")>
	<cfquery name="upd_position_emp_name" datasource="#dsn#">
		UPDATE 
			EMPLOYEE_POSITIONS
		SET
			DYNAMIC_HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.DYNAMIC_HIERARCHY#">,
			DYNAMIC_HIERARCHY_ADD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.DYNAMIC_HIERARCHY_ADD#">
		WHERE
			EMPLOYEE_ID = #EMPLOYEE_ID# AND
			IS_MASTER = 1
	</cfquery>
</cfif>

<!--- Adres Defteri --->
<cf_addressbook
	design		= "2"
	type		= "1"
	type_id		= "#attributes.employee_id#"
	active		= "#form.employee_status#"
	name		= "#attributes.employee_name#"
	surname		= "#attributes.employee_surname#"
	email		= "#attributes.employee_email#"
	telcode		= "#attributes.direct_telcode#"
	telno		= "#attributes.direct_tel#"
	mobilcode	= "#attributes.mobilcode#"
	mobilno		= "#attributes.mobiltel#">
    
<!---Ek Bilgiler--->
<cfset attributes.info_id =  attributes.employee_id>
<cfset attributes.is_upd = 1>
<cfset attributes.info_type_id = -4>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
<cfif employee_username neq old_employee_username or (len(employee_password) and employee_password neq old_employee_password)>
	<cf_add_log  log_type="0" action_id="#attributes.employee_id#" action_name="Kullanıcı Adı Şifre Güncelle :#get_emp_info(attributes.employee_id,0,0)#(#attributes.employee_id#)">
</cfif>

<cf_workcube_process 
	is_upd='1' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#'
	action_table='EMPLOYEES'
	action_column='EMPLOYEE_ID'
	action_id='#attributes.employee_id#' 
	action_page='#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#attributes.employee_id#' 
	warning_description='Çalışan : #attributes.employee_name# #attributes.employee_surname#'>
<script type="text/javascript">
<cfif isdefined("attributes.callAjax") and len(attributes.callAjax)>
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#attributes.employee_id#</cfoutput>','ajax_right');
<cfelse>
	window.location.href='<cfoutput>#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#attributes.employee_id#</cfoutput>';
</cfif>
</script> 
