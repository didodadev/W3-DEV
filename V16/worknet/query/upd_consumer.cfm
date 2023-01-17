<cfif isdefined("attributes.password1") and len(attributes.password1)>
	<cf_CryptedPassword password="#attributes.password1#" output = "PASS" mod="1">
<!---<cfelse>
	<cfset letters = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,r,s,t,u,v,y,z,1,2,3,4,5,6,7,8,9,0">
	<cfset attributes.password1 = ''>
	<cfloop from="1" to="8" index="ind">				     
		 <cfset random = RandRange(1, 33)>
		 <cfset attributes.password1 = "#attributes.password1##ListGetAt(letters,random,',')#">
	</cfloop>
	<cf_CryptedPassword password="#attributes.password1#" output = "PASS" mod="1">--->
</cfif>

<cfif isdefined('attributes.consumer_email') and len(attributes.consumer_email)>
		<!---Kullanici adi ve sifre kontrol ediliyor --->
		<cfquery name="CHECK_CONSUMER" datasource="#DSN#">
			SELECT
				CONSUMER_USERNAME
			FROM
				CONSUMER
			WHERE
				CONSUMER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.consumer_email#"> AND
				CONSUMER_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.consumer_email#"> AND
				CONSUMER_ID <> #attributes.consumer_id#
		</cfquery>
   		<cfif check_consumer.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='139.kullanıcı adı'>/ <cf_get_lang_main no ='140.şifre'><cf_get_lang_main no='781.tekrarı'>..");
				window.history.go(-1);
			</script>
			<cfabort>
   		</cfif>
</cfif>
<cfif isdefined("attributes.birthdate") and len(attributes.birthdate)>
	<cf_date tarih="attributes.birthdate">
</cfif>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>		
		<cfquery name="upd_consumer" datasource="#dsn#">
			UPDATE
			CONSUMER SET
				CONSUMER_STATUS = 1,
				CONSUMER_STAGE = 140,
				CONSUMER_CAT_ID = #attributes.CONSCAT_ID#,
				PERIOD_ID = <cfif isdefined("session.ep")>#session.ep.period_id#<cfelseif isdefined("session.ww")>#session.ww.period_id#<cfelseif isdefined("session.wp")>#session.wp.period_id#<cfelseif isdefined("session.pp")>#session.pp.period_id#</cfif>,
				COMPANY = <cfif isdefined("attributes.company")>'#attributes.company#'<cfelse>NULL</cfif>,
				CONSUMER_EMAIL = <cfif isdefined('attributes.consumer_email') and len(attributes.consumer_email)>'#attributes.consumer_email#'<cfelse>NULL</cfif>,
				CONSUMER_NAME = '#attributes.consumer_name#',
				<cfif isdefined("attributes.password1") and len(attributes.password1)>CONSUMER_PASSWORD = '#pass#',</cfif>
				CONSUMER_SURNAME = '#attributes.consumer_surname#',
				CONSUMER_USERNAME = <cfif isdefined('attributes.consumer_email') and len(attributes.consumer_email)>'#attributes.consumer_email#'<cfelse>NULL</cfif>,
				TC_IDENTY_NO = '#attributes.tc_identity_no#',
				CONSUMER_HOMETEL = <cfif isdefined("attributes.consumer_hometel") and len(attributes.consumer_hometel)>'#attributes.consumer_hometel#'<cfelse>NULL</cfif>,
				CONSUMER_HOMETELCODE = <cfif isdefined("attributes.consumer_hometelcode") and len(attributes.consumer_hometelcode)>'#attributes.consumer_hometelcode#'<cfelse>NULL</cfif>,
				TITLE = <cfif isdefined("attributes.title")>'#attributes.title#'<cfelse>NULL</cfif>,
				MOBIL_CODE = <cfif isdefined("attributes.mobilcat_id") and len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
				MOBILTEL = <cfif isdefined("attributes.mobiltel") and len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
				HOMEADDRESS = <cfif isdefined("attributes.homeaddress") and len(attributes.homeaddress)>'#attributes.homeaddress#'<cfelse>NULL</cfif>,
				HOME_COUNTY_ID = <cfif isdefined("attributes.home_county_id") and len(attributes.home_county_id)>#attributes.home_county_id#<cfelse>NULL</cfif>,
				HOME_CITY_ID = <cfif isdefined("attributes.home_city_id") and len(attributes.home_city_id)>#attributes.home_city_id#<cfelse>NULL</cfif>,
				HOME_COUNTRY_ID = <cfif isdefined("attributes.home_country") and len(attributes.home_country)>#attributes.home_country#<cfelse>NULL</cfif>,
				HOMEPOSTCODE = <cfif isdefined("attributes.homepostcode") and len(form.homepostcode)>'#attributes.homepostcode#'<cfelse>NULL</cfif>,
				BIRTHDATE = <cfif isdefined("attributes.birthdate") and len(attributes.birthdate)>#attributes.birthdate#<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE 
				CONSUMER_ID = #attributes.consumer_id#
		</cfquery>
        <cfquery name="add_cons_education_info" datasource="#dsn#">
            UPDATE
                CONSUMER_EDUCATION_INFO 
            SET
                CONS_ID = #attributes.consumer_id#,
                EDU4_ID = <cfif len(attributes.EDU4_ID)>#attributes.EDU4_ID#<cfelse>NULL</cfif>,
                EDU4_PART_ID = <cfif len(attributes.edu_part_id)>#attributes.edu_part_id#<cfelse>NULL</cfif>,
                RECORD_DATE = #now()#,
                RECORD_IP = '#CGI.REMOTE_ADDR#'
        </cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=worknet.detail_consumer&consumer_id=#attributes.consumer_id#" addtoken="No">
