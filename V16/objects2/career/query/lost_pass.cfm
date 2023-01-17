<cfquery name="GET_MAIL" datasource="#DSN#">
	SELECT 
		EMPAPP_ID, 
		NAME, 
		SURNAME, 
		EMAIL, 
		EMPAPP_PASSWORD 
	FROM 
		EMPLOYEES_APP 
	WHERE
		EMAIL= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mail#">
</cfquery>
<cfif get_mail.recordcount>
	<cfset letters = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,r,s,t,u,v,y,z,1,2,3,4,5,6,7,8,9,0">
	<cfset password = ''>
	<cfloop from="1" to="8" index="ind">				     
		 <cfset random = RandRange(1, 33)>
		 <cfset password = "#password##ListGetAt(letters,random,',')#">
	</cfloop>		
  	<!---yeni şifre üretilip güncelleniyor--->
  	<cf_cryptedpassword password="#password#" output="sifre">
  	<cfquery name="ADD_USER_PASS" datasource="#DSN#">
  		UPDATE EMPLOYEES_APP SET EMPAPP_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifre#"> WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_mail.empapp_id#">
  	</cfquery>
	<cfquery name="GET_INFO" datasource="#DSN#">
		SELECT EMAIL FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">
	</cfquery>
	<cfsavecontent variable="msg"><cf_get_lang_main no ='814.Şifre Hatırlatıcı'></cfsavecontent>
	<cfquery name="CHECK" datasource="#DSN#">
		SELECT ASSET_FILE_NAME1 FROM OUR_COMPANY WHERE COMP_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">
	</cfquery>
  	<cfmail to="#attributes.mail#" from="#get_info.email#" subject="#msg#" type="html" charset="utf-8">
		<table width="90%"  border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td><cfif len(check.asset_file_name1)><cfoutput><img src="#user_domain##file_web_path#settings/#check.asset_file_name1#" border="0" title="<cf_get_lang_main no='1225.Logo'>" alt="<cf_get_lang_main no='1225.Logo'>"/></cfoutput></cfif></td>
			</tr>
			<tr>
				<td><span><cf_get_lang no ='1494.Değerli Üyemiz'>; </span></td>
			</tr>
			<tr>
				<td><p><cf_get_lang no ='1493.Sistemimizde yer alan e-posta adresiniz ve şifreniz aşağıda bildirilmiştir'>:</p></td>
			</tr>
			<tr>
				<td><strong><cf_get_lang no ='1492.E-posta adresiniz'>:</strong></td>
			</tr>
			<tr>
				<td><font size="-1" face="Tahoma">#get_mail.email#</font></td>
			</tr>
			<tr>
				<td><strong><cf_get_lang no ='1405.Şifreniz'>:</strong></td>
			</tr>
			<tr>
				<td><cfoutput><font size="-1" face="Tahoma">#password#</font></cfoutput></td>
			</tr>
			<tr>
				<td><p><cf_get_lang no ='1491.Şirketimize gösterdiğiniz ilgi için teşekkür ederiz'>.</p></td>
			</tr>
		</table>
  	</cfmail>
  	<script type="text/javascript">
		alert("<cf_get_lang no ='1488.Şifreniz Mail Adresinize Gönderilmiştir'>...");
		window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.kariyer_login';
	</script>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1489.Mail Adresiniz sistemimizde bulunamamıştır Lütfen tekrar deneyiniz'>.");
		window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.kariyer_login';
	</script>
</cfif>

