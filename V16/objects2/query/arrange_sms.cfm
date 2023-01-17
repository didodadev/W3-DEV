<cfquery name="GET_CONSUMER" datasource="#DSN#">
	SELECT 
		C.CONSUMER_ID,
		C.CONSUMER_STATUS,
		C.CONSUMER_NAME,
		C.CONSUMER_SURNAME,
		C.MOBIL_CODE + C.MOBILTEL AS MOBIL_PHONE ,
		C.CONSUMER_EMAIL AS EMAIL, 
		C.CONSUMER_USERNAME AS USERNAME
	FROM 
		CONSUMER C,
		COMPANY_CONSUMER_DOMAINS CCD,
        MAIN_MENU_SETTINGS MMS 
	WHERE 
    	MMS.MENU_ID = CCD.MENU_ID AND
		MMS.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND 
		C.CONSUMER_ID = CCD.CONSUMER_ID AND
		C.MOBIL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobilcat_id#"> AND
		C.MOBILTEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mobile_phone#"> AND
		C.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tc_identity_no#">
</cfquery>

<cfif get_consumer.recordcount>
	<cfif get_consumer.recordcount eq 1>
		<cfquery name="GET_PASSWORD" datasource="#DSN#">
			SELECT CONSUMER_PASSWORD FROM CP_CONTROL WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.consumer_id#">
		</cfquery>
		<cfif len(get_consumer.consumer_status) and get_consumer.consumer_status eq 1>
			<cfsavecontent variable="sms_body">Sayın <cfoutput>#get_consumer.consumer_name# #get_consumer.consumer_surname#</cfoutput>, Temsilci Numaranız <cfoutput>#get_consumer.username#</cfoutput> ve Şifreniz <cfoutput>#get_password.consumer_password#</cfoutput></cfsavecontent>
			<cfsavecontent variable="sms_body_report">Sayın <cfoutput>#get_consumer.consumer_name# #get_consumer.consumer_surname#</cfoutput>, Temsilci Numaranız <cfoutput>#get_consumer.username#</cfoutput> ve Şifreniz ******</cfsavecontent>

			<cfset attributes.sms_body = sms_body>
			<cfset attributes.sms_body_report = sms_body_report>
			<cfset attributes.member_id = get_consumer.consumer_id>
			<cfset attributes.member_type = 'consumer'>
			<cfset attributes.mobil_phone = get_consumer.mobil_phone>
			<cfset callcenter_include = 1>
			<cfinclude template="../../objects/query/add_send_sms.cfm">
		<cfelseif len(get_consumer.consumer_status) and get_consumer.consumer_status eq 0>
			<script language="javascript">
				alert('Üyeliğiniz Pasif Durumdadır! Çağrı Merkezinden Bilgi Alınız!');
				history.back(-1);
			</script>
			<cfabort>
		</cfif>
	<cfelse>
		<script language="javascript">
			alert('Girmiş olduğunuz bilgiler başka Temsilcimizde kayıtlıdır. Doğru bilgilerle tekrar deneyiniz.');
			history.back(-1);
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<script language="javascript">
		alert('Girmiş olduğunuz bilgiler sistemdeki bilgilerinizle uyuşmamaktadır. Tekrar deneyiniz.');
		history.back(-1);
	</script>
	<cfabort>
</cfif>

<cfif isdefined("attributes.referer")>
	<script type="text/javascript">
		function waitfor(){
		  document.location.href='<cfoutput>#attributes.referer#</cfoutput>';
		}
		setTimeout("waitfor()",3000);  
	</script>
<cfelse>
	<script type="text/javascript">
		function waitfor(){
		  window.close();
		}
		setTimeout("waitfor()",3000);  
	</script>
</cfif>
