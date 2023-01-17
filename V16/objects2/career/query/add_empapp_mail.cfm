<cfif isdefined("attributes.mail") and len(attributes.mail)>
	<cfset attributes.empapp_id = attributes.mail>
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
		<!--- isim değişkeni geldi ise mail içindeki ?isim? degerini url den yollanan isim yapıyor--->
		<cfquery name="get_name" datasource="#dsn#">
			SELECT
				NAME,
				SURNAME
			FROM
				EMPLOYEES_APP
			WHERE
				EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_mail#">
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
		  MAIL_HEAD,
		<cfif len(emp_mail)>
		  EMPAPP_MAIL,
		</cfif>
		  MAIL_CONTENT,
		  RECORD_DATE,
		  RECORD_IP,
		  RECORD_PAR
		)
		VALUES
		(
		 #i#,
		<cfif isdefined('attributes.app_pos_id') and len(attributes.app_pos_id)>#ListGetAt(attributes.app_pos_id,counter,',')#,</cfif>
		<cfif isdefined('attributes.list_id') and len(attributes.list_id)>#attributes.list_id#,</cfif>
		'#header#',
	   <cfif len(emp_mail)>
		'#emp_mail#',
	   </cfif> 
		'#attributes.content2#',
		 #now()#,
		'#cgi.REMOTE_ADDR#',
		#session.pp.userid#
		)
	 </cfquery>
  <cfset counter =counter + 1>
 </cfloop>
<cfelse>
<cfif isim_var>
	<!--- isim değişkeni geldi ise mail içindeki ?isim? degerini url den yollanan isim yapıyor --->
	<cfquery name="get_name" datasource="#dsn#">
		SELECT
			NAME,
			SURNAME
		FROM
			EMPLOYEES_APP
		WHERE
			EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPLOYEE_EMAIL#">
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
		  MAIL_HEAD,
		  EMPAPP_MAIL,
		  MAIL_CONTENT,
		  RECORD_DATE,
		  RECORD_IP,
		  RECORD_PAR
		)
		VALUES
		(
		 #attributes.empapp_id#,
		 <cfif isdefined('attributes.app_pos_id') and len(attributes.app_pos_id)>#attributes.app_pos_id#,</cfif>
		 <cfif isdefined('attributes.list_id') and len(attributes.list_id)>#attributes.list_id#,</cfif>
		'#header#',
		'#EMPLOYEE_EMAIL#',
		'#attributes.content2#',
		 #now()#,
		'#cgi.REMOTE_ADDR#',
		#session.pp.userid#
		)
	</cfquery>
</cfif>

<cfif isDefined("attributes.email") and (attributes.email eq "true")>
	<cfquery name="get_our_company" datasource="#dsn#"> <!--- Ayarlar sirket akis parametrelerinden girilen Insan kaynaklari mail adresi bilgisi mail from olarak alinmaktadir. --->
		SELECT EMAIL FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.pp.our_company_id#
	</cfquery>
	<cfset sender = "İnsan Kaynakları <#get_our_company.EMAIL#>" >
<cftry>
	<cfloop list="#attributes.EMPLOYEE_EMAIL#" index="i" delimiters=",">
		<cfif isim_var>
			<!--- isim değişkeni geldi ise mail içindeki ?isim? degerini url den yollanan isim yapıyor--->
			<cfquery name="get_name" datasource="#dsn#">
				SELECT
					NAME,
					SURNAME
				FROM
					EMPLOYEES_APP
				WHERE
					EMAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">
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
	 <cfinclude template="../../../objects/query/add_mail.cfm"> py kapattı 1114--->

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
							<td align="center" class="headbold">Mail Başarıyla Gönderildi</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	
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
						<td align="center" class="headbold">Kaydedildi Fakat Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz</td>
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
		function waitfor(){
		  window.close();
		}
		setTimeout("waitfor()",7000); 		
	</script>
	<cfabort>	
</cfif>

<script type="text/javascript">
<cfif not isdefined("attributes.is_refresh") or isdefined("attributes.is_refresh") and attributes.is_refresh eq 1>
	wrk_opener_reload();
</cfif>
	window.close();
</script>

