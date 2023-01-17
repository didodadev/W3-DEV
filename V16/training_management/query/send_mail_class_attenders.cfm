<!--- Katilimcilara Mail Gonderimi --->
<cfquery name="get_mailfrom" datasource="#dsn#">
	SELECT
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_EMAIL<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER_EMAIL</cfif>
	FROM		
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEES<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER</cfif>		
	WHERE
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.USERID#">
		<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.USERID#"></cfif>
</cfquery>
<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
	<cfset sender = "#get_mailfrom.EMPLOYEE_EMAIL#">
<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
	<cfset sender = "#get_mailfrom.COMPANY_PARTNER_EMAIL#">
</cfif>
<cfset trainer = "">
<cfscript>
	get_trainers = createObject("component","V16.training_management.cfc.get_class_trainers");
	get_trainers.dsn = dsn;
	get_trainer_names = get_trainers.get_class_trainers
					(
						module_name : fusebox.circuit,
						class_id : attributes.class_id
					);
</cfscript>
<cfif get_trainer_names.recordcount>
	<cfset trainer = valuelist(get_trainer_names.trainer,',')>
</cfif>
<cfif isdefined("attributes.send_mail_") and attributes.send_mail_ eq 1>
	<cfquery name="get_class" datasource="#dsn#">
		SELECT
			T.CLASS_ID,
			T.CLASS_NAME,
			T.START_DATE,
			T.FINISH_DATE,
			<!--- T.TRAINER_EMP,
			T.TRAINER_PAR,
			T.TRAINER_CONS, --->
			T.CLASS_ANNOUNCEMENT_DETAIL,
			(SELECT TC.TRAINING_CAT FROM TRAINING_CAT TC WHERE TC.TRAINING_CAT_ID = T.TRAINING_CAT_ID) AS TRAINING_CAT,
			(SELECT TS.SECTION_NAME FROM TRAINING_SEC TS WHERE TS.TRAINING_SEC_ID = T.TRAINING_SEC_ID) AS SECTION_NAME,
			CLASS_PLACE
		FROM 
			TRAINING_CLASS T
		WHERE 
			CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
	</cfquery>
	
	<!--- <cfif len(get_class.TRAINER_EMP) AND (get_class.TRAINER_EMP neq 0)>
		<cfquery name="get_emp_name" datasource="#dsn#">
			SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS TRAINER FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.TRAINER_EMP#">
		</cfquery>
		<cfset trainer = get_emp_name.trainer > 
	<cfelseif len(get_class.TRAINER_PAR) AND (get_class.TRAINER_PAR neq 0)>
		<cfquery name="get_par_name" datasource="#dsn#">
			SELECT COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER_SURNAME AS TRAINER FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.trainer_par#">
		</cfquery>
		<cfset trainer = get_par_name.trainer>
	<cfelseif len(get_class.TRAINER_CONS) AND (get_class.TRAINER_CONS neq 0)>
		<cfquery name="get_cons_name" datasource="#dsn#">
			SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME AS TRAINER FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.TRAINER_CONS#">
		</cfquery>
		<cfset trainer = get_cons_name.trainer>
	</cfif> --->
	<cfquery name="get_logo" datasource="#dsn#">
		SELECT ASSET_FILE_NAME2,ASSET_FILE_NAME2_SERVER_ID FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	</cfquery>
	<cfset startdate = date_add('h', session.ep.time_zone, get_class.start_date)>
	<cfset finishdate = date_add('h', session.ep.time_zone, get_class.finish_date)>
	
	<cfset emp_id_list = ''>
	<cfset par_id_list = ''>
	<cfset cons_id_list = ''>
	<cfset type = ''>
	<cfset mail_subject = ''>
	<cfloop from="1" to="#listlen(attributes.id_list)#" index="i">
		<cfif (listfirst(listgetat(attributes.id_list,i,','),';') eq 'employee' or listfirst(listgetat(attributes.id_list,i,','),';') eq 'inf_employee')>
			<cfif LEFT(listfirst(listgetat(attributes.id_list,i,','),';'),4) eq 'inf_'>
				<cfset type = 0><!---bilgilendirilecekler --->
				<cfset mail_subject = 'Eğitim Bilgilendirme:#get_class.class_name#'>
			<cfelse>
				<cfset type = 1><!--- katılımcılar--->
				<cfset mail_subject = get_class.class_name>
			</cfif>
			<cfquery name="get_employee" datasource="#dsn#">
				SELECT 
					EMPLOYEE_EMAIL,
					EMPLOYEE_SURNAME,
					EMPLOYEE_ID,
					EMPLOYEE_NAME,
					(SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND IS_MASTER=1) AS POSITION_NAME
				FROM 
					EMPLOYEES
				WHERE 
					EMPLOYEE_ID = #listlast(listgetat(attributes.id_list,i,','),';')# AND 
					NOT (EMPLOYEE_EMAIL IS NULL OR EMPLOYEE_EMAIL = '')
			</cfquery>
			
			<!--- mail gonder--->
			<cfif get_employee.recordcount>
			<cfmail to="#get_employee.employee_name# #get_employee.employee_surname#<#get_employee.EMPLOYEE_EMAIL#>" from="#session.ep.company#<#session.ep.company_email#>" subject="#mail_subject#" type="HTML" charset="utf-8">
				<cfinclude template="../../objects/display/view_company_logo.cfm">
				Sayın #get_employee.employee_name# #get_employee.employee_surname#(#get_employee.position_name#), <br /><br />
				<cfif type eq 1>
				Aşağıda detayları verilmiş olan eğitime katılımcı olarak eklendiniz.<br /><br />
				<cfelse>
				Workcube’de adınıza yapılmış bir bilgilendirme bulunmaktadır.<br /><br />
				</cfif>
				<b>Kategori/Bölüm :</b> #get_class.training_cat#/#get_class.section_name#<br/><br/>
				<b>Ders :</b> #get_class.class_name#<br/><br/>
				<b>Tarih :</b> #dateformat(startdate,dateformat_style)# (#timeformat(startdate,timeformat_style)#) - #dateformat(finishdate,dateformat_style)# (#timeformat(finishdate,timeformat_style)#)<br/><br/>
				<b>Duyuru :</b> #get_class.CLASS_ANNOUNCEMENT_DETAIL# <br/><br/>
				<b>Eğitimci :</b> #trainer#<br/><br/>
				<b>Eğitim Yeri :</b> #get_class.class_place#
			</cfmail>
			</cfif>
			<!--- //mail gonder finish--->
		</cfif>
		<cfif (listfirst(listgetat(attributes.id_list,i,','),';') eq 'partner' or listfirst(listgetat(attributes.id_list,i,','),';') eq 'inf_partner')>
			<cfif LEFT(listfirst(listgetat(attributes.id_list,i,','),';'),4) eq 'inf_'>
				<cfset type = 0><!---bilgilendirilecekler --->
				<cfset mail_subject = 'Eğitim Bilgilendirme:#get_class.class_name#'>
			<cfelse>
				<cfset type = 1><!--- katılımcılar--->
				<cfset mail_subject = get_class.class_name>
			</cfif>
			<cfquery name="get_partner" datasource="#dsn#">
				SELECT 
					COMPANY_PARTNER_EMAIL,
					COMPANY_PARTNER_SURNAME,
					PARTNER_ID,
					COMPANY_PARTNER_NAME
				FROM 
					COMPANY_PARTNER
				WHERE 
					PARTNER_ID = #listlast(listgetat(attributes.id_list,i,','),';')# AND 
					NOT (COMPANY_PARTNER_EMAIL IS NULL OR COMPANY_PARTNER_EMAIL = '')
			</cfquery>
			<!--- mail gonder--->
			<cfif get_partner.recordcount>
			<cfmail from="#session.ep.company#<#session.ep.company_email#>" to="#get_partner.company_partner_name# #get_partner.company_partner_surname#<#get_partner.company_partner_email#>" subject="#mail_subject#" type="HTML" charset="utf-8">
				<cfinclude template="../../objects/display/view_company_logo.cfm">
				Sayın #get_partner.company_partner_name# #get_partner.company_partner_surname#, <br /><br />
				<cfif type eq 1>
				Aşağıda detayları verilmiş olan eğitime katılımcı olarak eklendiniz.<br /><br />
				<cfelse>
				Workcube’de adınıza yapılmış bir bilgilendirme bulunmaktadır.<br /><br />
				</cfif>
				<b>Kategori/Bölüm :</b> #get_class.training_cat#/#get_class.section_name#<br/><br/>
				<b>Ders :</b> #get_class.class_name#<br/><br/>
				<b>Tarih :</b> #dateformat(startdate,dateformat_style)# (#timeformat(startdate,timeformat_style)#) - #dateformat(finishdate,dateformat_style)# (#timeformat(finishdate,timeformat_style)#)<br/><br/>
				<b>Duyuru :</b> #get_class.class_announcement_detail# <br/><br/>
				<b>Eğitimci :</b> #trainer# <br/><br/>
				<b>Eğitim Yeri :</b> #get_class.class_place#
			</cfmail>
			</cfif>
			<!--- //mail gonder finish--->
		</cfif>
		<cfif (listfirst(listgetat(attributes.id_list,i,','),';') eq 'consumer' or listfirst(listgetat(attributes.id_list,i,','),';') eq 'inf_consumer')>
			<cfif LEFT(listfirst(listgetat(attributes.id_list,i,','),';'),4) eq 'inf_'>
				<cfset type = 0><!---bilgilendirilecekler --->
				<cfset mail_subject = 'Eğitim Bilgilendirme:#get_class.class_name#'>
			<cfelse>
				<cfset type = 1><!--- katılımcılar--->
				<cfset mail_subject = get_class.class_name>
			</cfif>
			<cfquery name="get_consumer" datasource="#dsn#">
				SELECT 
					CONSUMER_EMAIL,
					CONSUMER_SURNAME,
					CONSUMER_ID,
					CONSUMER_NAME
				FROM 
					CONSUMER
				WHERE 
					CONSUMER_ID = #listlast(listgetat(attributes.id_list,i,','),';')# AND 
					NOT (CONSUMER_EMAIL IS NULL OR CONSUMER_EMAIL = '')
			</cfquery>
			<!--- mail gonder--->
			<cfif get_consumer.recordcount>
			<cfmail from="#session.ep.company#<#session.ep.company_email#>" to="#get_consumer.consumer_name# #get_consumer.consumer_surname#<#get_consumer.consumer_email#>" subject="#mail_subject#" type="HTML" charset="utf-8">
				<cfinclude template="../../objects/display/view_company_logo.cfm">
				Sayın #get_consumer.consumer_name# #get_consumer.consumer_surname#, <br /><br />
				<cfif type eq 1>
				Aşağıda detayları verilmiş olan eğitime katılımcı olarak eklendiniz.<br /><br />
				<cfelse>
				Workcube’de adınıza yapılmış bir bilgilendirme bulunmaktadır.<br /><br />
				</cfif>
				<b>Kategori/Bölüm :</b> #get_class.training_cat#/#get_class.section_name#<br/><br/>
				<b>Ders :</b> #get_class.class_name#<br/><br/>
				<b>Tarih :</b> #dateformat(startdate,dateformat_style)# (#timeformat(startdate,timeformat_style)#) - #dateformat(finishdate,dateformat_style)# (#timeformat(finishdate,timeformat_style)#)<br/><br/>
				<b>Duyuru :</b> #get_class.class_announcement_detail# <br/><br/>
				<b>Eğitimci :</b> #trainer#<br/><br/>
				<b>Eğitim Yeri :</b> #get_class.class_place#
			</cfmail>
			</cfif>
			<!--- //mail gonder finish--->
		</cfif>
	</cfloop>
	<cfif isdefined("attributes.class_id")>
		<script type="text/javascript">
			alert("Mail Gönderildi!");
		</script>
	</cfif>
</cfif>
