<!--- YAPILAN DEPİŞİKLİKLER add_cons_member DOSYASINA DA AKTARILSIN! --->

<cfif isDefined("attributes.tc_identity_no") and len(attributes.tc_identity_no)>
	<cfquery name="get_consumer_tc_kontrol" datasource="#DSN#">
		SELECT CONSUMER_ID, TERMINATE_DATE, CONSUMER_STATUS FROM CONSUMER WHERE TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.tc_identity_no)#">
	</cfquery>
	<cfif get_consumer_tc_kontrol.recordcount gte 1>
		<cfif get_consumer_tc_kontrol.consumer_status eq 0>
		   	<script type="text/javascript">
				alert("Girilen TC kimlik No Sistemden Çıkmış Olan Bir Üyeye Ait. Lütfen Sistem Yöneticisine Başvurunuz !");
			   	history.back();
			</script>
		<cfelse>
			<script type="text/javascript">
				alert("Aynı Tc Kimlik Numarası ile kayıtlı bir üye var Lütfen kontrol ediniz !");
				history.back();
		   	</script>
		</cfif>
	<cfabort>
	</cfif>
</cfif>

<cfquery name="GET_STAGE" datasource="#DSN#" maxrows="1">
	SELECT TOP 1
		PTR.STAGE,
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
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		<cfelseif isdefined("session.ww")>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
		<cfelse>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		</cfif>
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_consumer%">
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>
<cfif not get_stage.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='34354.İşlem Tipleri Tanımlı Değil! Lütfen Müşteri Temsilcinize Başvurun'>.");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif len(attributes.CONSUMER_EMAIL)>
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
			alert("<cf_get_lang dictionary_id ='35732.Girdiğiniz Maile sahip başka bir kullanıcı var'>! ");
			window.history.go(-1);
		</script>	
		<cfabort>
	</cfif>
	<cfquery name="GET_OUR_EMAIL" datasource="#dsn#">
		SELECT
			COMPANY_NAME,
			EMAIL
		FROM
			OUR_COMPANY
		WHERE
			<cfif isdefined('session.pp.our_company_id')>
				COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
			<cfelse>
				COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
			</cfif>
	</cfquery>
	<cfset letters = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,r,s,t,u,v,y,z,1,2,3,4,5,6,7,8,9,0">
	<cfset password = ''>
	<cfloop from="1" to="8" index="ind">				     
		 <cfset random = RandRange(1, 33)>
		 <cfset password = "#password##ListGetAt(letters,random,',')#">
	</cfloop>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='29708.Şifre Bilgilendirme İşlemi'></cfsavecontent>		
	<cftry> 				 
		<cfmail  
			to = "#attributes.CONSUMER_EMAIL#"
			from = "#get_our_email.company_name#<#get_our_email.email#>"
			subject = "#cgi.http_host# #message#"
			type="HTML">  
			<style type="text/css">
				.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
				.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
			</style>		  
			<cfinclude template="../../objects/display/view_company_logo.cfm">
			<br/>
			<table width="590" align="center">
			  <tr>
				<td class="headbold" height="35"><cf_get_lang dictionary_id='58226.Şifre Hatırlatıcı'></td>
			  </tr>
			 <tr>
				<td><cf_get_lang dictionary_id ='57551.Kullanıcı Adınız'>:<STRONG>#attributes.CONSUMER_EMAIL#</STRONG></td>
			  </tr>
			  <tr>
				<td><cf_get_lang dictionary_id ='35726.Şifreniz'>:<STRONG>#password#</STRONG></td>
			  </tr>
			</table>
			<br/>
			<cfinclude template="../../objects/display/view_company_info.cfm">
		</cfmail>
		<cf_CryptedPassword password="#password#" output = "PASS">
		<table height="100%" width="100%" cellspacing="0" cellpadding="0">
			<tr class="color-border">
				<td valign="top"> 
					<table height="100%" width="100%" cellspacing="1" cellpadding="2">
						<tr class="color-list">
							<td height="35" class="headbold">&nbsp;&nbsp;Workcube E-Mail</td>
						</tr>
						<tr class="color-row">
							<td align="center" class="headbold"><cf_get_lang dictionary_id ='57513.Mail Başarıyla Gönderildi'></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>			
		<cfcatch type="any">
			<table height="100%" width="100%" cellspacing="0" cellpadding="0">
				<tr class="color-border">
					<td valign="top"> 
						<table height="100%" width="100%" cellspacing="1" cellpadding="2">
							<tr class="color-list">
								<td height="35" class="headbold">&nbsp;&nbsp;Workcube E-Mail</td>
							</tr>
							<tr class="color-row">
								<td align="center" class="headbold">
								<cf_get_lang dictionary_id ='35742.Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz'></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>		
			<cfabort>
		</cfcatch>	
	</cftry>
</cfif>
<cfif not isdefined("attributes.WORKADDRESS")>
	<cfif len(attributes.work_door_no)>
		<cfset work_door_no = '#attributes.work_door_no#'>
	<cfelse>
		<cfset work_door_no = ''>
	</cfif>
	<cfif isdefined("attributes.work_district")>
		<cfset attributes.WORKADDRESS = '#attributes.work_district# #attributes.work_main_street# #attributes.work_street# #work_door_no#'>
	<cfelse>
		<cfset attributes.WORKADDRESS = '#attributes.work_main_street# #attributes.work_street# #work_door_no#'>
	</cfif>
</cfif>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>				
		<cfquery name="ADD_CONSUMER" datasource="#DSN#">
		INSERT INTO CONSUMER 
		(
			CONSUMER_STAGE,
			PERIOD_ID,
			CONSUMER_STATUS,
			ISPOTANTIAL,
			CONSUMER_CAT_ID,
			COMPANY,
			COMPANY_SIZE_CAT_ID,
			CONSUMER_EMAIL,
			CONSUMER_NAME,
			CONSUMER_PASSWORD,
			CONSUMER_SURNAME,
			CONSUMER_USERNAME,
			TC_IDENTY_NO,
			CONSUMER_WORKTEL,
			CONSUMER_WORKTELCODE,
			TITLE,
			MOBIL_CODE,
			MOBILTEL,
            WORKPOSTCODE,
			WORK_COUNTRY_ID,
			WORK_CITY_ID,
			WORK_COUNTY_ID,
			WORKSEMT,
			WORK_DISTRICT,
			WORK_DISTRICT_ID,
			WORK_MAIN_STREET,
			WORK_STREET,
			WORK_DOOR_NO,
            WORKADDRESS,
            CONSUMER_HOMETEL,
			CONSUMER_HOMETELCODE,
			HOMEPOSTCODE,
            HOME_COUNTRY_ID,
            HOME_CITY_ID,
            HOME_COUNTY_ID,
            HOMESEMT,
            HOME_DISTRICT,
            HOME_DISTRICT_ID,
            HOME_MAIN_STREET,
            HOME_STREET,
            HOME_DOOR_NO,
			HOMEADDRESS,
            DEPARTMENT,
			MISSION,
            SEX,
			VOCATION_TYPE_ID,
			SECTOR_CAT_ID,
			CUSTOMER_VALUE_ID,
			HIERARCHY_ID,
			<cfif isdefined('session.pp')>
				RECORD_PAR,
			<cfelse>
				RECORD_CONS,
			</cfif>
			RECORD_DATE
		 )
		VALUES 	 
		(
			#get_stage.PROCESS_ROW_ID#,
			<cfif isdefined('session.pp')>
				#session.pp.period_id#,
			<cfelse>
				#session.ww.period_id#,
			</cfif>
			1,
			1,
			#FORM.CONSUMER_CAT_ID#,
			<cfif isdefined('FORM.COMPANY') and len(FORM.COMPANY)>'#FORM.COMPANY#',<cfelse>NULL,</cfif>
			<cfif isdefined('FORM.COMPANY_SIZE_CAT_ID') and len(FORM.COMPANY_SIZE_CAT_ID)>#FORM.COMPANY_SIZE_CAT_ID#,<cfelse>NULL,</cfif>
			<cfif len(FORM.CONSUMER_EMAIL)>'#FORM.CONSUMER_EMAIL#',<cfelse>NULL,</cfif>
			'#FORM.CONSUMER_NAME#',
			<cfif isdefined('pass') and len(pass)>'#pass#',<cfelse>NULL,</cfif>
			'#FORM.CONSUMER_SURNAME#',
			<cfif len(FORM.CONSUMER_EMAIL)>'#FORM.CONSUMER_EMAIL#',<cfelse>NULL,</cfif>
			<cfif isdefined("attributes.tc_identity_no") and len(attributes.tc_identity_no)>'#attributes.tc_identity_no#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.CONSUMER_WORKTEL") and len(attributes.CONSUMER_WORKTEL)>'#FORM.CONSUMER_WORKTEL#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.CONSUMER_WORKTELCODE") and len(attributes.CONSUMER_WORKTELCODE)>'#FORM.CONSUMER_WORKTELCODE#'<cfelse>NULL</cfif>,
			'#FORM.TITLE#',
			<cfif isdefined("attributes.MOBILCAT_ID") AND attributes.MOBILCAT_ID NEQ 0>'#FORM.MOBILCAT_ID#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.MOBILTEL") AND len(attributes.MOBILTEL)>'#FORM.MOBILTEL#'<cfelse>NULL</cfif>,
			
			<cfif isdefined('attributes.work_postcode') and len(attributes.work_postcode)>'#form.work_postcode#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.country') and len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.city_id') and len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.county_id') and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.semt') and len(attributes.semt)>'#form.semt#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.work_district") and len(attributes.work_district)>'#attributes.work_district#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.work_district_id") and len(attributes.work_district_id)>#attributes.work_district_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.work_main_street") and len(attributes.work_main_street)>'#attributes.work_main_street#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.work_street") and len(attributes.work_street)>'#attributes.work_street#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.work_door_no") and len(attributes.work_door_no)>'#attributes.work_door_no#'<cfelse>NULL</cfif>,
            <cfif isdefined('FORM.WORKADDRESS') and len(FORM.WORKADDRESS)>'#FORM.WORKADDRESS#'<cfelse>NULL</cfif>,
           
		    <cfif isdefined("attributes.CONSUMER_WORKTEL") and len(attributes.CONSUMER_WORKTEL)>'#FORM.CONSUMER_WORKTEL#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.CONSUMER_WORKTELCODE") and len(attributes.CONSUMER_WORKTELCODE)>'#FORM.CONSUMER_WORKTELCODE#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.work_postcode') and len(attributes.work_postcode)>'#form.work_postcode#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.country') and len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.city_id') and len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.county_id') and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.semt') and len(attributes.semt)>'#form.semt#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.work_district") and len(attributes.work_district)>'#attributes.work_district#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.work_district_id") and len(attributes.work_district_id)>#attributes.work_district_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.work_main_street") and len(attributes.work_main_street)>'#attributes.work_main_street#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.work_street") and len(attributes.work_street)>'#attributes.work_street#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.work_door_no") and len(attributes.work_door_no)>'#attributes.work_door_no#'<cfelse>NULL</cfif>,
            <cfif isdefined('FORM.WORKADDRESS') and len(FORM.WORKADDRESS)>'#FORM.WORKADDRESS#'<cfelse>NULL</cfif>,
			
			<cfif isdefined('attributes.department') and len(attributes.department)>#form.department#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.mission') and len(attributes.mission)>#form.mission#<cfelse>NULL</cfif>,
            #attributes.sex#,
			<cfif isdefined('attributes.vocation_type') and len(attributes.vocation_type)>#form.vocation_type#<cfelse>NULL</cfif>,
			<cfif isdefined('FORM.SECTOR_CAT_ID') and len(FORM.SECTOR_CAT_ID)>#FORM.SECTOR_CAT_ID#<cfelse>NULL</cfif>,
			1,
			<cfif isdefined('session.pp')>#session.pp.company_id#<cfelse>NULL</cfif>,
			<cfif isdefined('session.pp')>#session.pp.userid#,<cfelse>#session.ww.userid#,</cfif>
			#NOW()#
		)
		</cfquery>
		<cfquery name="GET_MAX_CONS" datasource="#DSN#">
			SELECT MAX(CONSUMER_ID) AS MAX_CONS FROM CONSUMER
		</cfquery>
		
		<cfsavecontent variable="alert"><cf_get_lang_main no ='174.Bireysel Üye'></cfsavecontent>
		<cf_workcube_process is_upd='1' 
			old_process_line='0'
			process_stage='#get_stage.PROCESS_ROW_ID#' 
			record_date='#now()#' 
			record_member='#get_max_cons.max_cons#'
			action_table='CONSUMER'
			action_column='CONSUMER_ID'
			action_id='#get_max_cons.max_cons#'
			action_page='#request.self#?fuseaction=member.consumer_list&event=det&cid=#GET_MAX_CONS.MAX_CONS#' 
			warning_description='#alert# : #get_max_cons.max_cons#'>
	</cftransaction>
</cflock>
<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
	UPDATE
		CONSUMER
	SET
		MEMBER_CODE = 'C#GET_MAX_CONS.MAX_CONS#'
	WHERE
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_cons.max_cons#">
</cfquery>

<!--- Sozlesme Bilgileri --->

<cfif isdefined("attributes.consumer_contract_id") and len(attributes.consumer_contract_id)>
	<cfquery name="UPD_CONTRACT" datasource="#DSN#">
		UPDATE 
			CONSUMER 
		SET 
			CONTRACT_DATE = #now()#
		<cfif isdefined("session.ww.userid")>
			,CONTRACT_CONS_ID = #session.ww.userid#
		<cfelseif isdefined("session.ep.userid")>
			,CONTRACT_EMP_ID = #session.ep.userid#
		</cfif>
		WHERE 
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_cons.max_cons#">
	</cfquery>
</cfif>

<cfquery name="GET_ACC_INFO" datasource="#dsn#">
	SELECT PUBLIC_ACCOUNT_CODE FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfif isdefined('session.pp')><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"></cfif>
</cfquery>
<cfquery name="ADD_COMP_PERIOD" datasource="#DSN#">
	INSERT INTO
		CONSUMER_PERIOD
	(
		CONSUMER_ID,
		PERIOD_ID,
		ACCOUNT_CODE
	)
	VALUES
	(
		#GET_MAX_CONS.MAX_CONS#,
		<cfif isdefined('session.pp')>
			#session.pp.period_id#,
		<cfelse>
			#session.ww.period_id#,
		</cfif>
		<cfif len(GET_ACC_INFO.PUBLIC_ACCOUNT_CODE)>'#GET_ACC_INFO.PUBLIC_ACCOUNT_CODE#'<cfelse>NULL</cfif>
	)
</cfquery>
<cfif isDefined("session.pp") or isDefined("session.ww")>
    <script type="text/javascript">
        window.location.replace(document.referrer);
    </script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=objects2.upd_my_consumer&consumer_id=#get_max_cons.max_cons#" addtoken="no">
</cfif>