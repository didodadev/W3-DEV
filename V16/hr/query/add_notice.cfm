<cfif not len(attributes.system_paper_no_add)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='62411.İlan Eklemek İçin Sistemde Belge Numarası Tanımlamanız Gerekmektedir'>.");
		history.back();
    </script>
	<cfabort>
</cfif>
<cfif len(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
<cfif len(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
<cfif len(attributes.notice_no)>
	<cfquery name="control" datasource="#dsn#">
		SELECT NOTICE_ID FROM NOTICES WHERE NOTICE_NO = '#attributes.notice_no#'
	</cfquery>

	<cfif control.RECORDCOUNT> 
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='56316.Aynı ilan no lu kayıt var'> !");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<!--- Hata verdiği için forma alındı. 
	<cfif not Len(attributes.validator_position_code)>
		<script type="text/javascript">
			alert("Onaylayacak Kişiyi Seçiniz!");
			history.back();
		</script>
		<cfabort>
	</cfif> --->
</cfif>

<cfif isDefined("attributes.visual_notice") and len(attributes.visual_notice)>
	<cfset upload_folder = "#upload_folder##dir_seperator#hr#dir_seperator#">
	<cftry>
		<cffile action="UPLOAD"
				filefield="visual_notice"
				destination="#upload_folder#"
				mode="777"
				nameconflict="MAKEUNIQUE">
			<cfset file_name = createUUID()>
			<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
			<cfset attributes.visual_notice = '#file_name#.#cffile.serverfileext#'>
			<!---Script dosyalarını engelle  02092010 FA,ND --->
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='32535.php,jsp,asp,cfm,cfml Formatlarında Dosya Girmeyiniz!!'>");
					history.back();
				</script>
				<cfabort>
			</cfif>	
		<CFCATCH type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='57455.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</CFCATCH>
	</CFTRY>
</cfif>

<!--- Onaylayacak Pozisyon/Çalışan Email Bilgisi --->
<cfquery name="get_emp_email" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES E,
		EMPLOYEE_POSITIONS EP
	WHERE
		EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.validator_position_code#"> AND
		E.EMPLOYEE_ID = EP.EMPLOYEE_ID
</cfquery>

<cfquery name="add_notice" datasource="#dsn#" result="MAXID">
	INSERT INTO
		NOTICES
		(
		NOTICE_CAT_ID,
		NOTICE_HEAD, 
		NOTICE_NO,
		STATUS,
	<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>STATUS_NOTICE,</cfif>
		DETAIL,
	<cfif len(attributes.app_position)>POSITION_NAME,</cfif>
	<cfif len(attributes.POSITION_ID)>POSITION_ID,</cfif>
	<cfif len(attributes.position_cat)>POSITION_CAT_NAME,</cfif>
	<cfif len(attributes.POSITION_CAT_ID)>POSITION_CAT_ID,</cfif>
	<cfif len(INTERVIEW_POSITION_CODE)>
		INTERVIEW_POSITION_CODE, 
	<cfelseif len(INTERVIEW_PAR)>
		INTERVIEW_PAR,
	</cfif>
	<cfif len(validator_position)>
		<cfif len(validator_position_code)>
			VALIDATOR_POSITION_CODE,
		<cfelseif len(validator_par)>
			VALIDATOR_PAR,
		</cfif>
	<cfelse>
		VALID, 
		VALID_DATE, 
		VALID_EMP, 
	</cfif>
		STARTDATE, 
		FINISHDATE, 	
		PUBLISH, 
	<cfif len(attributes.company) and len(attributes.company_id)>
		COMPANY_ID,
	</cfif>
	<cfif len(attributes.company)>
		COMPANY,
	</cfif>
	<cfif len(attributes.our_company) and len(attributes.our_company_id)>
		OUR_COMPANY_ID,
	</cfif>
	<cfif  len(attributes.department) and len(attributes.department_id)>
		DEPARTMENT_ID,
	</cfif>
	<cfif  len(attributes.branch) and len(attributes.branch_id)>
		BRANCH_ID,
	</cfif>
		NOTICE_CITY,
		COUNT_STAFF,
		WORK_DETAIL,
		PIF_ID,
		IS_VIEW_LOGO,
		IS_VIEW_COMPANY_NAME,
		VIEW_VISUAL_NOTICE,
		<cfif isDefined("attributes.visual_notice") and len(attributes.visual_notice)>
			VISUAL_NOTICE,
			SERVER_VISUAL_NOTICE_ID,
		</cfif>
		RECORD_DATE,
		RECORD_IP,
		RECORD_EMP
		)
	VALUES
		(
		<cfif isdefined("attributes.notice_cat_id") and len(attributes.notice_cat_id)>#attributes.notice_cat_id#,<cfelse>NULL,</cfif>
		'#attributes.notice_head#', 
		'#attributes.notice_no#',
	<cfif isdefined('attributes.status')>1<cfelse>0</cfif>,
	<cfif len(attributes.process_stage)>#attributes.process_stage#,</cfif>
		'#FORM.detail#',<!--- '#attributes.detail#', --->
	<cfif len(attributes.app_position)>'#attributes.app_position#',</cfif>
	<cfif len(attributes.position_id)>#attributes.position_id#,</cfif>
	<cfif len(attributes.position_cat)>'#attributes.position_cat#',</cfif>
	<cfif len(attributes.position_cat_id)>#attributes.position_cat_id#,</cfif> 
	<cfif len(attributes.interview_position_code)>
		#attributes.interview_position_code#,
	<cfelseif len(attributes.interview_par)>
		#attributes.interview_par#,
	</cfif>
	<cfif len(attributes.validator_position)>
		<cfif len(validator_position_code)>
			#attributes.validator_position_code#,
		<cfelseif len(validator_par)>
			#attributes.validator_par#,
		</cfif>
	<cfelse>
		1, 
		#now()#, 
		#session.ep.userid#, 
	</cfif>
	<cfif len(attributes.startdate)>
		#attributes.startdate#, 
	<cfelse>
		NULL,
	</cfif>
	<cfif len(attributes.finishdate)>
		#attributes.finishdate#, 	
	<cfelse>
		NULL,
	</cfif>
	<cfif isdefined("attributes.publish")>'#attributes.publish#',<cfelse>NULL,</cfif>
	<cfif len(attributes.company) and len(attributes.company_id)>#attributes.company_id#,</cfif>
	<cfif len(attributes.company) and len(attributes.company_id)>
		'#attributes.company#',
	</cfif>
	<cfif isdefined('attributes.our_company_id') and len(attributes.our_company_id)>
		#attributes.our_company_id#,
	</cfif>
	<cfif len(attributes.department)and len(attributes.department_id)>
		#attributes.department_id#,
	</cfif>
	<cfif len(attributes.branch) and len(attributes.branch_id)>
		#attributes.branch_id#,
	</cfif>		
	<cfif isdefined('attributes.city') and len(attributes.city)>',#attributes.city#,'<cfelse>NULL</cfif>,
	<cfif len(attributes.staff_count)>#attributes.staff_count#<cfelse>NULL</cfif>,
	<cfif len(attributes.work_detail)>'#attributes.work_detail#'<cfelse>NULL</cfif>,
	<cfif len(attributes.pif_id) and len(attributes.pif_name)>#attributes.pif_id#<cfelse>NULL</cfif>,
	<cfif isdefined("attributes.view_logo")>1<cfelse>0</cfif>,
	<cfif isdefined("attributes.view_company_name")>1<cfelse>0</cfif>,
	<cfif isdefined("attributes.view_visual_notice")>1<cfelse>0</cfif>,
	<cfif isDefined("attributes.visual_notice") and len(attributes.visual_notice)>
		'#attributes.visual_notice#',
		#fusebox.server_machine#,
	</cfif>
	#now()#,
	'#cgi.REMOTE_ADDR#',
	#session.ep.userid#
		)
</cfquery>

<!--- EMP_NOTICE_NUMBER Değerini 1 Artır. --->
<cfquery name="UPD_EMP_NOTICE_NUMBER" datasource="#DSN#">
	UPDATE GENERAL_PAPERS_MAIN SET EMP_NOTICE_NUMBER = #attributes.system_paper_no_add# WHERE EMP_NOTICE_NUMBER IS NOT NULL
</cfquery>

<!--- Eklenen İlan ID'sini al --->
<cfquery name="get_last_notice" datasource="#dsn#">
	SELECT MAX(NOTICE_ID) AS LAST_ID FROM NOTICES
</cfquery>

<cfquery name="add_warning" datasource="#dsn#" result="GET_WARNINGS">
    INSERT INTO
        PAGE_WARNINGS
        (
            URL_LINK,
            WARNING_HEAD,
            WARNING_DESCRIPTION,
            RECORD_DATE,
            LAST_RESPONSE_DATE,
            IS_NOTIFICATION,
            IS_ACTIVE,
            RECORD_IP,
            RECORD_EMP,
            POSITION_CODE,
            IS_CONFIRM,
            IS_REFUSE,
            IS_MANUEL_NOTIFICATION
        )
        VALUES
        (
            '#request.self#?fuseaction=hr.list_notice&event=upd&notice_id=#MAXID.IdentityCol#',
            '#getLang('','İK İlanları',55174)#: #MAXID.IdentityCol#',
            <cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#attributes.work_detail#">,
            #NOW()#,
            #NOW()#,
            1,
            1,
            '#CGI.REMOTE_ADDR#',
            #SESSION.EP.USERID#,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.validator_position_code#">,
            1,
            1,
            1
        )
</cfquery>
<cfquery name="UPD_WARNINGS" datasource="#dsn#">
    UPDATE PAGE_WARNINGS SET PARENT_ID = #GET_WARNINGS.IDENTITYCOL# WHERE W_ID = #GET_WARNINGS.IDENTITYCOL#			
</cfquery>

<!--- Onaylayacak Kişiye E-Mail Gönder  --->
<cfif Len(get_emp_email.EMPLOYEE_EMAIL) and Find("@", get_emp_email.EMPLOYEE_EMAIL) and Find(".", get_emp_email.EMPLOYEE_EMAIL)>
	<!--- BU custom tag altında yapılan iş hatalı bu yüzden kaydettikten sonra sayfa yönlenmiyordu
	<cfmail to="#get_emp_email.EMPLOYEE_EMAIL#" from="#session.ep.company#<#session.ep.company_email#>" subject="İlan Onay" type="HTML">
		Onayınızı bekleyen bir ilan bulunmaktadır.
		<br />
		<a href="#employee_domain##request.self#?fuseaction=hr.form_upd_notice&notice_id=#get_last_notice.last_id#">İlgili Forma Buradan Ulaşabilirsiniz...</a><br />
		Gönderen : #session.ep.name# #session.ep.surname#
	</cfmail>
	--->
<cfelse>
	<script>alert("<cf_get_lang dictionary_id='52158.Onaylayacak çalışanın email adresi girilmemiş veya uygun formatta değil'> .\n<cf_get_lang dictionary_id='54590.İlan kaydedildi fakat email gönderilemedi'>!\n\n<cfoutput>#get_emp_email.EMPLOYEE_EMAIL#</cfoutput>");</script>
</cfif>
<cfset attributes.actionId = MAXID.IdentityCol>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_notice&event=upd&notice_id=<cfoutput>#MAXID.IdentityCol#</cfoutput>';
</script>
