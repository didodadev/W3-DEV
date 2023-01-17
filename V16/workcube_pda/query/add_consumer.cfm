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
			alert("Girdiğiniz e-posta sistemde kayıtlı. Lütfen farklı bir e-posta adresi giriniz!");
			history.back();
		</script>	
		<cfabort>
	</cfif>
</cfif>

<cflock name="#createUUID()#" timeout="20">
	<cftransaction>			
		<cfquery name="ADD_CONSUMER" datasource="#DSN#">
			INSERT INTO 
				CONSUMER 
				(
					CONSUMER_STATUS,
					CONSUMER_NAME,
					CONSUMER_SURNAME,
					IS_CARI,
					CONSUMER_CAT_ID,
					RESOURCE_ID,
					CUSTOMER_VALUE_ID,
					SALES_COUNTY,
					IMS_CODE_ID,
					HOMEPAGE,
					COMPANY,
					TAX_NO,
					CONSUMER_EMAIL,
					<cfif isdefined("attributes.consumer_hometel") and len(attributes.consumer_hometel)>
						CONSUMER_HOMETEL,
					</cfif>
					<cfif isdefined("attributes.consumer_hometelcode") and len(attributes.consumer_hometelcode)>
						CONSUMER_HOMETELCODE,
					</cfif>
					CONSUMER_FAXCODE,
					CONSUMER_FAX,
					MOBIL_CODE,
					MOBILTEL,
					HOME_COUNTRY_ID,
					HOME_CITY_ID,
					HOME_COUNTY_ID,	
					HOMESEMT,
					HOMEPOSTCODE,
					HOMEADDRESS,
					CONSUMER_STAGE,
					PERIOD_ID,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES 	 
				(
					1,
					'#attributes.consumer_name#',
					'#attributes.consumer_surname#',
					1,
					<cfif isdefined("attributes.consumer_cat_id")>#attributes.consumer_cat_id#<cfelseif isdefined("attributes.cons_cat_id")>#attributes.cons_cat_id#<cfelse>1</cfif>,
					<cfif isdefined("attributes.resource") and len(attributes.resource)>#attributes.resource#<cfelseif isdefined("attributes.consumer_resource_id") and len(attributes.consumer_resource_id)>#attributes.consumer_resource_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>'#attributes.customer_value#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.sales_county") and len(attributes.sales_county)>#attributes.sales_county#,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id)>#attributes.ims_code_id#,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.homepage") and len(attributes.homepage)>'#attributes.homepage#',<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.company") and len(attributes.company)>'#attributes.company#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.tax_no") and len(attributes.tax_no)>'#attributes.tax_no#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.consumer_email') and len(attributes.consumer_email)>'#attributes.consumer_email#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.consumer_hometel") and len(attributes.consumer_hometel)>'#attributes.consumer_hometel#',</cfif>
					<cfif isdefined("attributes.consumer_hometelcode") and len(attributes.consumer_hometelcode)>'#attributes.consumer_hometelcode#',</cfif>
					<cfif isdefined("attributes.work_faxcode") and len(attributes.work_faxcode)>'#attributes.work_faxcode#',<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.work_fax") and len(attributes.work_fax)>'#attributes.work_fax#',<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.mobilcat_id") and len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.mobiltel") and len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.home_country") and len(attributes.home_country)>#attributes.home_country#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.home_city_id") and len(attributes.home_city_id)>#attributes.home_city_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.home_county_id") and len(attributes.home_county_id)>#attributes.home_county_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.homesemt") and len(attributes.homesemt)>'#attributes.homesemt#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.homepostcode") and len(attributes.homepostcode)>'#attributes.homepostcode#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.homeaddress") and len(attributes.homeaddress)>'#attributes.homepostcode#'<cfelse>NULL</cfif>,
					4,
					#session.pda.period_id#,
					#now()#,
					'#cgi.remote_addr#'
				)
		</cfquery>
		<cfquery name="GET_MAX_CONS" datasource="#DSN#">
			SELECT MAX(CONSUMER_ID) AS MAX_CONS FROM CONSUMER
		</cfquery>
        
		<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
			UPDATE 
				CONSUMER 
			SET 
				MEMBER_CODE = 'C#get_max_cons.max_cons#'
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
                WHERE 
                    CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_cons.max_cons#">
            </cfquery>
        </cfif>
		<cfquery name="GET_ACC_INFO" datasource="#DSN#">
			SELECT 
				PUBLIC_ACCOUNT_CODE 
			FROM 
				OUR_COMPANY_INFO 
			WHERE 
				COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">
		</cfquery>
		<cfquery name="ADD_CONS_PERIOD" datasource="#DSN#">
			INSERT INTO
				CONSUMER_PERIOD
				(
					CONSUMER_ID,
					PERIOD_ID,
					ACCOUNT_CODE
				)
				VALUES
				(
					#get_max_cons.max_cons#,
					#session.pda.period_id#,
					<cfif len(get_acc_info.public_account_code)>'#get_acc_info.public_account_code#'<cfelse>NULL</cfif>
				)
		</cfquery>    
	</cftransaction>
</cflock>

<script type="text/javascript">
	alert("Bireysel üye kaydınız başarıyla alınmıştır!");
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=pda.welcome';
</script>
