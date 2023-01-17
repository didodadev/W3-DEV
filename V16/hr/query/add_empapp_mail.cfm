<cfif not isdefined("attributes.is_performans")>
	<cfset uzunluk_mail = listlen(attributes.EMPLOYEE_EMAIL,',')>
	<cfset uzunluk_empapp_id = listlen(attributes.EMPAPP_ID,',')>
	<cfif uzunluk_mail neq uzunluk_empapp_id>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1728.Listedeki Kullanıcılardan Başka Birine Mail Gönderemezsiniz'>!");
			history.back();
		</script>
	</cfif>
</cfif>
<cfif isdefined("attributes.mail") and len(attributes.mail)>
	<cfset attributes.empapp_id=attributes.mail>
</cfif>
<cfif find('??isim??',attributes.content)>
	<cfset isim_var=1>
<cfelse>
	<cfset isim_var=0>
</cfif>
<cfif isdefined("attributes.cont") and (attributes.cont eq 1)>
	<cfset counter = 1>
	<cfloop list="#attributes.empapp_id#" index="i" delimiters=",">
		<cfif counter lte listlen(attributes.EMPLOYEE_EMAIL)>
			<cfset emp_mail= listgetat(attributes.EMPLOYEE_EMAIL,counter,',')>
		<cfelse>
			<cfset emp_mail = "">
		</cfif>
		<cfif isim_var>
			<cfquery name="get_name" datasource="#dsn#">
				SELECT
					NAME,
					SURNAME
				FROM
					EMPLOYEES_APP
				WHERE
					EMAIL='#emp_mail#'
			</cfquery>
			<cfset attributes.content2=replace(attributes.content,'??isim??','#get_name.name# #get_name.surname#','all')>
		<cfelse>
			<cfset attributes.content2=attributes.content>
		</cfif>
		<cfquery name="ADD_EMPAPP_MAIL" datasource="#DSN#">
		  INSERT  INTO
			EMPLOYEES_APP_MAILS
			(
			  EMPAPP_ID,
			<cfif isdefined('attributes.app_pos_id') and len(attributes.app_pos_id)>APP_POS_ID,</cfif>
			<cfif isdefined('attributes.list_id') and len(attributes.list_id)>LIST_ID,</cfif>
			<cfif isdefined('attributes.list_row_id') and len(attributes.list_row_id)>LIST_ROW_ID,</cfif>
			  MAIL_HEAD,
			<cfif len(emp_mail)>
			  EMPAPP_MAIL,
			</cfif>
			  MAIL_CONTENT,
			  CATEGORY,
			  RECORD_DATE,
			  RECORD_IP,
			  RECORD_EMP
			)
			VALUES
			(
			 #i#,
			<cfif isdefined('attributes.app_pos_id') and len(attributes.app_pos_id)>#ListGetAt(attributes.app_pos_id,counter,',')#,</cfif>
			<cfif isdefined('attributes.list_id') and len(attributes.list_id)>#attributes.list_id#,</cfif>
			<cfif isdefined('attributes.list_row_id') and len(attributes.list_row_id)>#ListGetAt(attributes.list_row_id,counter,',')#,</cfif>
			'#header#',
		   <cfif len(emp_mail)>
			'#emp_mail#',
		   </cfif> 
			'#attributes.content2#',
			 #attributes.CORRCAT#,
			 #now()#,
			'#cgi.REMOTE_ADDR#',
			#session.ep.userid#
			)
		 </cfquery>
  		<cfset counter =counter + 1>
 	</cfloop>
<cfelseif not isdefined("attributes.is_performans")>
	<cfif isim_var>
		<cfquery name="get_name" datasource="#dsn#">
			SELECT
				NAME,
				SURNAME
			FROM
				EMPLOYEES_APP
			WHERE
				EMAIL='#EMPLOYEE_EMAIL#'
		</cfquery>
		<cfset attributes.content2=replace(attributes.content,'??isim??','#get_name.name# #get_name.surname#','all')>
	<cfelse>
		<cfset attributes.content2=attributes.content>
	</cfif>
	<cfquery name="ADD_EMPAPP_MAIL" datasource="#DSN#">
	  INSERT INTO
		EMPLOYEES_APP_MAILS
		(
		  EMPAPP_ID,
		  <cfif isdefined('attributes.app_pos_id') and len(attributes.app_pos_id)>APP_POS_ID,</cfif>
		  <cfif isdefined('attributes.list_id') and len(attributes.list_id)>LIST_ID,</cfif>
		  <cfif isdefined('attributes.list_row_id') and len(attributes.list_row_id)>LIST_ROW_ID,</cfif>
		  MAIL_HEAD,
		  EMPAPP_MAIL,
		  MAIL_CONTENT,
		  CATEGORY,
		  RECORD_DATE,
		  RECORD_IP,
		  RECORD_EMP
		)
		VALUES
		(
		 #empapp_id#,
		 <cfif isdefined('attributes.app_pos_id') and len(attributes.app_pos_id)>#attributes.app_pos_id#,</cfif>
		 <cfif isdefined('attributes.list_id') and len(attributes.list_id)>#attributes.list_id#,</cfif>
		<cfif isdefined('attributes.list_row_id') and len(attributes.list_row_id)>#attributes.list_row_id#,</cfif>
		'#header#',
		'#EMPLOYEE_EMAIL#',
		'#attributes.content2#',
		 #attributes.CORRCAT#,
		 #now()#,
		'#cgi.REMOTE_ADDR#',
		#session.ep.userid#
		)
	</cfquery>
</cfif>
<cfif isDefined("attributes.email") and (attributes.email eq "true")>
	<cfquery name="get_our_company" datasource="#dsn#">
		SELECT EMAIL FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
	</cfquery>
	<cfset sender = "İnsan Kaynakları <#get_our_company.EMAIL#>" >
	<cftry>
		<cfloop list="#attributes.EMPLOYEE_EMAIL#" index="i" delimiters=",">
			<cfif isim_var>
				<cfquery name="get_name" datasource="#dsn#">
					SELECT
						NAME,
						SURNAME
					FROM
						EMPLOYEES_APP
					WHERE
						EMAIL='#i#'
				</cfquery>
				<cfset attributes.content2=replace(attributes.content,'??isim??','#get_name.name# #get_name.surname#','all')>
			<cfelse>
				<cfset attributes.content2=attributes.content>
			</cfif>
		  <cfmail  
			  to = "#i#"
			  from = "#sender#"
			  subject = "#attributes.header#" type="HTML">
				<style type="text/css">
					.color-header{background-color: ##a7caed;}
					.color-border	{background-color:##6699cc;}
					.color-row{	background-color: ##f1f0ff;}
					.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
				</style>
				#attributes.content2#
		  </cfmail>
		 </cfloop>
		  <cfsavecontent variable="css">
			<style type="text/css">
				.color-header{background-color: ##a7caed;}
				.color-border	{background-color:##6699cc;}
				.color-row{	background-color: ##f1f0ff;}
				.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
			</style>
		  </cfsavecontent>	
          <!---<cfset attributes.from = sender>  
		  <cfset attributes.body="#css##attributes.content#">
		  <cfset attributes.to_list="#attributes.EMPLOYEE_EMAIL#">
		  <cfset attributes.type=0>
		  <cfset attributes.module="hr">
		  <cfset attributes.subject="#attributes.header#">
		 <cfinclude template="../../objects/query/add_mail.cfm"> py kapattı 1114--->
			<style type="text/css">
				.color-header{background-color: ##a7caed;}
				.color-border	{background-color:##6699cc;}
				.color-row{	background-color: ##f1f0ff;}
				.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
			</style>	
			<script>
				alert("<cf_get_lang dictionary_id='56815.Mail Başarıyla Gönderildi'>");
				location.href = document.referrer;
			</script>  	   
			
		
		<cfcatch type="any">
	
		<style type="text/css">
			.color-header{background-color: ##a7caed;}
			.color-border	{background-color:##6699cc;}
			.color-row{	background-color: ##f1f0ff;}
			.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
		</style>	
		<table height="100%" width="100%" cellspacing="0" cellpadding="0">
			<tr class="color-border">
				<td valign="top"> 
					<table height="100%" width="100%" cellspacing="1" cellpadding="2">
						<tr class="color-list">
							<td height="35" class="headbold">&nbsp;&nbsp;Workcube E-Mail</td>
						</tr>
						<tr class="color-row">
							<td align="center" class="headbold"><cf_get_lang no ='1729.Kaydedildi Fakat Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz'> </td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		</cfcatch>
	</cftry>
 	<script type="text/javascript">
		<cfif not isdefined("attributes.is_refresh") or isdefined("attributes.is_refresh") and attributes.is_refresh eq 1>
			wrk_opener_reload();
		</cfif>
		function waitfor()
		{
		  window.close();
		}
		setTimeout("waitfor()",7000); 		
	</script>
	<cfabort>	
</cfif>

<script type="text/javascript">
	
		location.href = document.referrer;
	
</script>