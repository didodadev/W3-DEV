<cf_get_lang_set module_name="objects2">
<cfif isDefined("attributes.tc_identity_no") and len(attributes.tc_identity_no)>
	<cfquery name="GET_CONSUMER_TC_KONTROL" datasource="#DSN#">
		SELECT
			CONSUMER_ID,
			TERMINATE_DATE,
			CONSUMER_STATUS
		FROM
			CONSUMER
		WHERE
			TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.tc_identity_no)#">
	</cfquery>
	<cfif get_consumer_tc_kontrol.recordcount gte 1>
		<cfif get_consumer_tc_kontrol.consumer_status eq 0>
			<script type="text/javascript">
				alert("<cf_get_lang no='1630.Girilen TC kimlik No Sistemden Çıkmış Olan Bir Üyeye Ait. Lütfen Sistem Yöneticisine Başvurunuz !'>");
				history.back();
			</script>
		<cfelse>
			<script type="text/javascript">
				alert("<cf_get_lang no='1083.Aynı Tc Kimlik Numarası ile kayıtlı bir üye var Lütfen kontrol ediniz !'>");
				history.back();
			</script>
		</cfif>
		<cfabort>
	</cfif>
</cfif>
<cfif isdefined("attributes.password1") and len(attributes.password1)>
	<cf_CryptedPassword password="#attributes.password1#" output = "PASS" mod="1">
<cfelse>
	<cfset letters = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,r,s,t,u,v,y,z,1,2,3,4,5,6,7,8,9,0">
	<cfset attributes.password1 = ''>
	<cfloop from="1" to="8" index="ind">				     
		 <cfset random = RandRange(1, 33)>
		 <cfset attributes.password1 = "#attributes.password1##ListGetAt(letters,random,',')#">
	</cfloop>
	<cf_CryptedPassword password="#attributes.password1#" output = "PASS" mod="1">
</cfif>

<cfif isdefined('attributes.consumer_email') and len(attributes.consumer_email)>
	<!---Kullanici adi ve sifre kontrol ediliyor --->
	<cfquery name="CHECK_CONSUMER" datasource="#DSN#">
		SELECT
			CONSUMER_USERNAME
		FROM
			CONSUMER
		WHERE
			CONSUMER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.consumer_email#"> OR
			CONSUMER_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.consumer_email#">  
	</cfquery>
	<cfif check_consumer.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1403.Girdiğiniz mail daha önceden sistemde kayıtlı Lütfen farklı bir mail adresi giriniz'>!");
			window.history.go(-1);
		</script>	
		<cfabort>
	</cfif>
</cfif>

<cfif isdefined("attributes.birthdate") and len(attributes.birthdate)>
	<cf_date tarih="attributes.birthdate">
</cfif>

<cfquery name="getConsProcess" datasource="#DSN#" maxrows="1">
	SELECT TOP 1
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		<cfif isdefined("session.pp")>
			PTR.IS_PARTNER = 1 AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		<cfelseif isdefined("session.ww.userid")>
			PTR.IS_CONSUMER = 1 AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
		</cfif>
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_consumer%">
	ORDER BY 
		PTR.PROCESS_ROW_ID
</cfquery>

<cflock name="#createUUID()#" timeout="20">
	<cftransaction>	
		<cfquery name="ADD_CONSUMER" datasource="#DSN#" result="myresult">
			INSERT INTO 
				CONSUMER 
			(
				CONSUMER_STATUS,
				CONSUMER_STAGE,
				CONSUMER_CAT_ID,
				PERIOD_ID,
				COMPANY,
				CONSUMER_EMAIL,
				CONSUMER_NAME,
				CONSUMER_PASSWORD,
				CONSUMER_SURNAME,
				CONSUMER_USERNAME,
				TC_IDENTY_NO,
				CONSUMER_HOMETEL,
				CONSUMER_HOMETELCODE,
				TITLE,
				MOBIL_CODE,
				MOBILTEL,
				HOMEADDRESS,
				HOME_COUNTY_ID,
				HOME_CITY_ID,
				HOME_COUNTRY_ID,
				HOMEPOSTCODE,
				BIRTHDATE,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES 	 
			(
				1,
				#getConsProcess.PROCESS_ROW_ID#,
				#attributes.conscat_id#,
				<cfif isdefined("session.ep")>#session.ep.period_id#<cfelseif isdefined("session.ww")>#session.ww.period_id#<cfelseif isdefined("session.wp")>#session.wp.period_id#<cfelseif isdefined("session.pp")>#session.pp.period_id#</cfif>,
				<cfif isdefined("attributes.company")>'#attributes.company#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.consumer_email') and len(attributes.consumer_email)>'#attributes.consumer_email#'<cfelse>NULL</cfif>,
				'#attributes.consumer_name#',
				<cfif isdefined("attributes.password1")>'#pass#'<cfelse>NULL</cfif>,
				'#attributes.consumer_surname#',
				<cfif isdefined('attributes.consumer_email') and len(attributes.consumer_email)>'#attributes.consumer_email#'<cfelse>NULL</cfif>,
				'#attributes.tc_identity_no#',
				<cfif isdefined("attributes.consumer_hometel") and len(attributes.consumer_hometel)>'#attributes.consumer_hometel#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.consumer_hometelcode") and len(attributes.consumer_hometelcode)>'#attributes.consumer_hometelcode#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.title")>'#attributes.title#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.mobilcat_id") and len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.mobiltel") and len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.homeaddress") and len(attributes.homeaddress)>'#attributes.homeaddress#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.home_county_id") and len(attributes.home_county_id)>#attributes.home_county_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.home_city_id") and len(attributes.home_city_id)>#attributes.home_city_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.home_country") and len(attributes.home_country)>#attributes.home_country#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.homepostcode") and len(form.homepostcode)>'#attributes.homepostcode#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.birthdate") and len(attributes.birthdate)>#attributes.birthdate#<cfelse>NULL</cfif>,
				#now()#,
				'#cgi.remote_addr#'
			)
		</cfquery>
		
		<cfif isdefined("attributes.edu4_id") and len(attributes.edu4_id)>
			<cfquery name="add_cons_education_info" datasource="#dsn#">
				INSERT INTO 
					CONSUMER_EDUCATION_INFO
					(
						CONS_ID,
						EDU4_ID,
						EDU4_PART_ID,
						RECORD_DATE,
						RECORD_IP
					)
					VALUES
					(
						#myresult.identitycol#,
						<cfif len(attributes.EDU4_ID)>#attributes.EDU4_ID#<cfelse>NULL</cfif>,
						<cfif len(attributes.edu_part_id)>#attributes.edu_part_id#<cfelse>NULL</cfif>,
						#now()#,
						'#CGI.REMOTE_ADDR#'
					)
			</cfquery>
		</cfif>
		
		<cfquery name="GET_MAX_CONS" datasource="#DSN#">
			SELECT MAX(CONSUMER_ID) AS MAX_CONS FROM CONSUMER
		</cfquery>
        
		<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
			UPDATE 
				CONSUMER 
			SET 
				MEMBER_CODE = 'C#get_max_cons.max_cons#',
				<cfif isdefined("session.ww.userid")>
					RECORD_CONS = #session.ww.userid#
                <cfelseif isdefined("session.wp.userid")>
                	RECORD_CONS = #session.wp.userid#
				<cfelse>
					RECORD_CONS = #get_max_cons.max_cons#
				</cfif>
			WHERE 
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_cons.max_cons#">
		</cfquery>  
        
		<cfquery name="ADD_CONS_PERIOD" datasource="#DSN#">
			INSERT INTO
				CONSUMER_PERIOD
			(
				CONSUMER_ID,
				PERIOD_ID
			)
			VALUES
			(
				#get_max_cons.max_cons#,
				<cfif isdefined('session.ep')>#session.ep.period_id#<cfelseif isdefined('session.ww')>#session.ww.period_id#<cfelseif isdefined('session.wp')>#session.wp.period_id#<cfelseif isdefined("session.pp")>#session.pp.period_id#</cfif>
			)
		</cfquery>       
	</cftransaction>
</cflock>

<script type="text/javascript">
    alert("Üyelik Kaydınız Başarı İle Yapılmıştır");
    //window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.list_training';
</script>
<cfoutput>
<form name="login" method="post" action="#request.self#?fuseaction=home.act_login">
	<input type="hidden" name="referer" id="referer" value="#request.self#?fuseaction=worknet.list_training">
	<input type="hidden" name="consumer_login" id="consumer_login" value="1">
	<input type="hidden" name="username" id="username" value="#attributes.consumer_email#">
	<input type="hidden" name="password" id="password" value="#attributes.password1#">
</form>
</cfoutput>
<script type="text/javascript">
	login.submit();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
