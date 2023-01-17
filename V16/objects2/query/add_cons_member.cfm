<cfif isDefined("attributes.is_tc_number_required_") and attributes.is_tc_number_required_ eq 1>
	<cfif isDefined("attributes.tc_identity_no") and not len(attributes.tc_identity_no)>
		<script type="text/javascript">
            alert("<cf_get_lang dictionary_id ='58687.Lütfen TC Kimlik No Giriniz!'>!");
            history.back(-1);
        </script>
    </cfif>
</cfif>
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
				alert("<cf_get_lang dictionary_id='35951.Girilen TC kimlik No Sistemden Çıkmış Olan Bir Üyeye Ait. Lütfen Sistem Yöneticisine Başvurunuz !'>");
				history.back();
			</script>
		<cfelse>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='35404.Aynı Tc Kimlik Numarası ile kayıtlı bir üye var Lütfen kontrol ediniz !'>");
				history.back();
			</script>
		</cfif>
		<cfabort>
	</cfif>
</cfif>
<cfquery name="GET_PROCESS" datasource="#DSN#" maxrows="1">
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
		<cfif isdefined("attributes.consumer_stage") and len(attributes.consumer_stage)>
			PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_stage#">
		<cfelse>
			<cfif isdefined("session.pp")>
				PTR.IS_PARTNER = 1 AND
				PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
			<cfelseif isdefined("session.ww")>
				PTR.IS_CONSUMER = 1 AND
				PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
			<cfelse>
				PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			</cfif>
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_consumer%">
		</cfif>
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>

<cfif not get_process.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='34354.İşlem Tipleri Tanımlı Değil! Lütfen Müşteri Temsilcinize Başvurunuz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfif isdefined("attributes.is_password") and attributes.is_password eq 1 and isdefined("attributes.password1") and len(attributes.password1)>
	<cf_CryptedPassword password="#attributes.password1#" output = "PASS">
<cfelseif isdefined("attributes.is_password") and attributes.is_password eq 0>
	<cfset letters = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,r,s,t,u,v,y,z,1,2,3,4,5,6,7,8,9,0">
	<cfset attributes.password1 = ''>
	<cfloop from="1" to="8" index="ind">				     
		 <cfset random = RandRange(1, 33)>
		 <cfset attributes.password1 = "#attributes.password1##ListGetAt(letters,random,',')#">
	</cfloop>
	<cf_CryptedPassword password="#attributes.password1#" output = "PASS">
</cfif>

<cfif isdefined("attributes.birthdate") and len(attributes.birthdate)>
	<cf_date tarih="attributes.birthdate">
</cfif>

<cfif not isdefined("attributes.homeaddress")>
	<cfif isdefined("attributes.home_door_no") and len(attributes.home_door_no)>
		<cfset home_door_no = '#attributes.home_door_no#'>
	<cfelse>
		<cfset home_door_no = ''>
	</cfif>
	<cfif isdefined("attributes.home_district")>
		<cfset attributes.homeaddress = '#attributes.home_district# #attributes.home_main_street# #attributes.home_street# #home_door_no#'>
	<cfelseif isdefined("attributes.home_main_street")>
		<cfset attributes.homeaddress = '#attributes.home_main_street# #attributes.home_street# #home_door_no#'>
	</cfif>
</cfif>
<cfif not isdefined("attributes.workaddress")>
	<cfif isdefined("attributes.work_door_no") and len(attributes.work_door_no)>
		<cfset work_door_no = '#attributes.work_door_no#'>
	<cfelse>
		<cfset work_door_no = ''>
	</cfif>
	<cfif isdefined("attributes.work_district")>
		<cfset attributes.workaddress = '#attributes.work_district# #attributes.work_main_street# #attributes.work_street# #work_door_no#'>
	<cfelseif isdefined("attributes.work_main_street")>
		<cfset attributes.workaddress = '#attributes.work_main_street# #attributes.work_street# #work_door_no#'>
	</cfif>
</cfif>
<cfif isdefined("attributes.is_tax_address") and attributes.is_tax_address eq 1>
	<cfset attributes.tax_address = attributes.homeaddress>
	<cfset attributes.tax_country = attributes.home_country>
	<cfset attributes.tax_county_id = attributes.home_county_id>
	<cfset attributes.tax_city_id = attributes.home_city_id>
	<cfif isdefined("attributes.home_district")>
		<cfset attributes.tax_district = attributes.home_district>
	</cfif>
	<cfif isdefined("attributes.home_district_id")>
		<cfset attributes.tax_district_id = attributes.home_district_id>
	</cfif>
	<cfif isdefined('attributes.home_main_street')>
		<cfset attributes.tax_main_street = attributes.home_main_street>
	</cfif>
	<cfif isdefined('attributes.home_street')>
		<cfset attributes.tax_street = attributes.home_street>
	</cfif>
	<cfif isdefined('attributes.home_door_no')>
		<cfset attributes.tax_door_no = attributes.home_door_no>
	</cfif>
<cfelseif isdefined("attributes.is_tax_address_2")>
	<cfset attributes.tax_address = attributes.workaddress>
	<cfset attributes.tax_country = attributes.work_country>
	<cfset attributes.tax_county_id = attributes.work_county_id>
	<cfset attributes.tax_city_id = attributes.work_city_id>
	<cfif isdefined("attributes.work_district")>
		<cfset attributes.tax_district = attributes.work_district>
	</cfif>
	<cfif isdefined("attributes.work_district_id")>
		<cfset attributes.tax_district_id = attributes.work_district_id>
	</cfif>
	<cfset attributes.tax_main_street = attributes.work_main_street>
	<cfset attributes.tax_street = attributes.work_street>
	<cfset attributes.tax_door_no = attributes.work_door_no>
</cfif>

<cflock name="#createUUID()#" timeout="20">
	<cftransaction>		
		<!---<cfif isdefined("attributes.is_ref_member") and attributes.is_ref_member eq 1 and isdefined("session.ww.userid")>
			<cfquery name="GET_REF_CODE" datasource="#DSN#">
				SELECT CONSUMER_REFERENCE_CODE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			</cfquery>
		</cfif>--->		
		<cfquery name="ADD_CONSUMER" datasource="#DSN#">
			INSERT INTO 
				CONSUMER 
                (
                    CONSUMER_STATUS,
                    CONSUMER_STAGE,
                    RESOURCE_ID,
                    PERIOD_ID,
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
                    <cfif isdefined("attributes.consumer_hometel") and len(attributes.consumer_hometel)>
                        CONSUMER_HOMETEL,
                    </cfif>
                    <cfif isdefined("attributes.consumer_hometelcode") and len(attributes.consumer_hometelcode)>
                        CONSUMER_HOMETELCODE,
                    </cfif>
                    TITLE,
                    MOBIL_CODE,
                    MOBILTEL,
                    MOBIL_CODE_2,
                    MOBILTEL_2,
                    SECTOR_CAT_ID,
                    HOMEADDRESS,
                    HOME_COUNTY_ID,
                    HOME_CITY_ID,
                    HOME_COUNTRY_ID,
                    HOMEPOSTCODE,
                    HOME_DISTRICT,
                    HOME_DISTRICT_ID,
                    HOME_MAIN_STREET,
                    HOME_STREET,
                    HOME_DOOR_NO,
                    WORKADDRESS,
                    WORK_COUNTY_ID,
                    WORK_CITY_ID,
                    WORK_COUNTRY_ID,
                    WORKPOSTCODE,				  
                    WORK_DISTRICT,
                    WORK_DISTRICT_ID,
                    WORK_MAIN_STREET,
                    WORK_STREET,
                    WORK_DOOR_NO,
                    TAX_ADRESS,
                    TAX_POSTCODE,
                    TAX_SEMT,
                    TAX_COUNTY_ID,
                    TAX_CITY_ID,
                    TAX_COUNTRY_ID,
                    TAX_DISTRICT,
                    TAX_DISTRICT_ID,
                    TAX_MAIN_STREET,
                    TAX_STREET,
                    TAX_DOOR_NO,
                    SEX,
                    BIRTHDATE,
                    START_DATE,
                    RECORD_DATE,
                    RECORD_IP,
                    CUSTOMER_VALUE_ID,
                    WANT_EMAIL,
                    WANT_SMS,
                    MEMBER_RULES,
                    TIMEOUT_LIMIT,
                    NATIONALITY,
                    MEMBER_ADD_OPTION_ID,
                    VOCATION_TYPE_ID
                    <cfif isdefined("attributes.is_ref_member") and attributes.is_ref_member eq 1 and isdefined("session.ww.userid")>
                        ,PROPOSER_CONS_ID
                    <cfelseif isdefined("attributes.proposer_cons_id") and len(attributes.proposer_cons_id)>
                        ,PROPOSER_CONS_ID
                    </cfif>
                    ,CONSUMER_REFERENCE_CODE
                    ,REF_POS_CODE
                    <cfif isdefined('attributes.special_code') and len(attributes.special_code)>
                        ,OZEL_KOD
                    </cfif>
                )
                VALUES 	 
                (
                    <cfif isdefined("attributes.is_activation") and len(attributes.is_activation)>
                    	<cfif attributes.is_activation eq 1>
	                    	0,
                        <cfelse>
                        	1,
                        </cfif>
                    <cfelse>
                    	0,
                    </cfif>
                    #get_process.process_row_id#,
                    <cfif isdefined("attributes.resource") and len(attributes.resource)>#attributes.resource#<cfelseif isdefined("attributes.consumer_resource_id") and len(attributes.consumer_resource_id)>#attributes.consumer_resource_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("session.pp")>#session.pp.period_id#,<cfelseif isdefined('session.ww')>#session.ww.period_id#,<cfelse>#session.ep.period_id#,</cfif>
                    1,
                    <cfif isdefined("attributes.consumer_cat_id")>#attributes.consumer_cat_id#<cfelseif isdefined("attributes.cons_cat_id")>#attributes.cons_cat_id#<cfelse>1</cfif>,
                    <cfif isdefined("attributes.company")>'#attributes.company#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.company_size_cat_id") and len(attributes.company_size_cat_id)>#attributes.company_size_cat_id#<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.consumer_email') and len(attributes.consumer_email)>'#attributes.consumer_email#'<cfelse>NULL</cfif>,
                    '#attributes.consumer_name#',
					<cfif isdefined("attributes.password1") and len(attributes.password1)>'#pass#'<cfelse>NULL</cfif>,
                    '#attributes.consumer_surname#',
                    '#attributes.consumer_email#',
                    <cfif isdefined("attributes.tc_identity_no") and len(attributes.tc_identity_no)>'#attributes.tc_identity_no#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.consumer_hometel") and len(attributes.consumer_hometel)>'#attributes.consumer_hometel#',</cfif>
                    <cfif isdefined("attributes.consumer_hometelcode") and len(attributes.consumer_hometelcode)>'#attributes.consumer_hometelcode#',</cfif>
                    <cfif isdefined("attributes.title")>'#attributes.title#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.mobilcat_id") and len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.mobiltel") and len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.mobilcat_id_2") and len(attributes.mobilcat_id_2)>'#attributes.mobilcat_id_2#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.mobiltel_2") and len(attributes.mobiltel_2)>'#attributes.mobiltel_2#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.sector_cat_id") and len(attributes.sector_cat_id)>#attributes.sector_cat_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.homeaddress") and len(attributes.homeaddress)>'#attributes.homeaddress#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.home_county_id") and len(attributes.home_county_id)>#attributes.home_county_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.home_city_id") and len(attributes.home_city_id)>#attributes.home_city_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.home_country") and len(attributes.home_country)>#attributes.home_country#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.homepostcode") and len(attributes.homepostcode)>'#attributes.homepostcode#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.home_district") and len(attributes.home_district)>'#attributes.home_district#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.home_district_id") and len(attributes.home_district_id)>#attributes.home_district_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.home_main_street") and len(attributes.home_main_street)>'#attributes.home_main_street#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.home_street") and len(attributes.home_street)>'#attributes.home_street#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.home_door_no") and len(attributes.home_door_no)>'#attributes.home_door_no#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.workaddress") and len(attributes.workaddress)>'#attributes.workaddress#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.work_county_id") and len(attributes.work_county_id)>#attributes.work_county_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.work_city_id") and len(attributes.work_city_id)>#attributes.work_city_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.work_country") and len(attributes.work_country)>#attributes.work_country#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.workpostcode") and len(attributes.workpostcode)>'#attributes.workpostcode#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.work_district") and len(attributes.work_district)>'#attributes.work_district#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.work_district_id") and len(attributes.work_district_id)>#attributes.work_district_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.work_main_street") and len(attributes.work_main_street)>'#attributes.work_main_street#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.work_street") and len(attributes.work_street)>'#attributes.work_street#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.work_door_no") and len(attributes.work_door_no)>'#attributes.work_door_no#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.tax_address") and len(attributes.tax_address)>'#attributes.tax_address#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.tax_postcode") and len(attributes.tax_postcode)>'#attributes.tax_postcode#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.tax_semt") and len(attributes.tax_semt)>'#attributes.tax_semt#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.tax_county_id") and len(attributes.tax_county_id)>#attributes.tax_county_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.tax_city_id") and len(attributes.tax_city_id)>#attributes.tax_city_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.tax_country") and len(attributes.tax_country)>#attributes.tax_country#<cfelse>NULL</cfif>,					
                    <cfif isdefined("attributes.tax_district") and len(attributes.tax_district)>'#attributes.tax_district#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.tax_district_id") and len(attributes.tax_district_id)>#attributes.tax_district_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.tax_main_street") and len(attributes.tax_main_street)>'#attributes.tax_main_street#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.tax_street") and len(attributes.tax_street)>'#attributes.tax_street#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.tax_door_no") and len(attributes.tax_door_no)>'#attributes.tax_door_no#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.sex")>#attributes.sex#<cfelse>0</cfif>,
                    <cfif isdefined("attributes.birthdate") and len(attributes.birthdate)>#attributes.birthdate#<cfelse>NULL</cfif>,
                    #now()#,
                    #now()#,
                    '#cgi.remote_addr#',
                    1,
                    <cfif isdefined('attributes.want_email')>1<cfelse>0</cfif>,
                    <cfif isdefined('attributes.want_sms')>1<cfelse>0</cfif>,
                    <cfif isdefined('attributes.member_rules')>1<cfelse>0</cfif>,
                    15,
                    1,
                    <cfif isdefined('attributes.member_add_option_id') and len(attributes.member_add_option_id)>#attributes.member_add_option_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.vocation_type") and len(attributes.vocation_type)>#attributes.vocation_type#<cfelse>NULL</cfif>
                    <cfif isdefined("attributes.is_ref_member") and attributes.is_ref_member eq 1 and isdefined("session.ww.userid")>
                        ,#session.ww.userid#
                    <cfelseif isdefined("attributes.proposer_cons_id") and len(attributes.proposer_cons_id)>
                        ,#attributes.proposer_cons_id#
                    </cfif>,
                    <cfif isdefined("attributes.reference_code") and len(attributes.reference_code)>
                        <cfif not listfind(attributes.reference_code,attributes.ref_pos_code,'.')>
                            '#attributes.reference_code#.#attributes.ref_pos_code#'
                        <cfelse>
                            '#attributes.reference_code#'
                        </cfif>
                    <cfelseif isdefined("attributes.ref_pos_code") and len(attributes.ref_pos_code)>
                        '#attributes.ref_pos_code#'
                    <cfelse>
                        NULL
                    </cfif>,
                    <cfif isDefined("attributes.ref_pos_code_name") and len(attributes.ref_pos_code_name) and len(attributes.ref_pos_code)>#attributes.ref_pos_code#<cfelse>NULL</cfif>
                    <cfif isdefined('attributes.special_code') and len(attributes.special_code)>,#attributes.special_code#</cfif>
                )
		</cfquery>
        
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
				<cfelse>
					RECORD_CONS = #get_max_cons.max_cons#
				</cfif>
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
        
		<cfquery name="GET_ACC_INFO" datasource="#DSN#">
			SELECT 
				PUBLIC_ACCOUNT_CODE 
			FROM 
				OUR_COMPANY_INFO 
			WHERE 
				COMP_ID = <cfif isdefined("session.ww")>
                		      <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
						  <cfelseif isdefined("session.pp")>
                          		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
                  		  <cfelse>
                          		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                          </cfif>
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
                    <cfif isdefined("session.ww")>#session.ww.period_id#,<cfelseif isdefined("session.pp")>#session.pp.period_id#,<cfelse>#session.ep.period_id#,</cfif>
                    <cfif len(get_acc_info.public_account_code)>'#get_acc_info.public_account_code#'<cfelse>NULL</cfif>
                )
		</cfquery>        
		<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='57586.Bireysel Üye'></cfsavecontent>
		<cf_workcube_process is_upd='1' 
			old_process_line='0'
			process_stage='#get_process.process_row_id#' 
			record_date='#now()#' 
			record_member='#get_max_cons.max_cons#'
			action_table='CONSUMER'
			action_column='CONSUMER_ID'
			action_id='#get_max_cons.max_cons#'
			action_page='#request.self#?fuseaction=member.consumer_list&event=det&cid=#get_max_cons.max_cons#' 
			warning_description='#alert# : #get_max_cons.max_cons#'>
		<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='35728.Başvuru İşlemi'></cfsavecontent>

		<cfquery name="GET_OUR_EMAIL" datasource="#DSN#">
			SELECT
				COMPANY_NAME,
				EMAIL
			FROM
				OUR_COMPANY
			WHERE
            	<cfif isDefined('session.pp.userid')>
					COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
				<cfelseif isDefined('session.ww')>
					COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">                
                </cfif>
        </cfquery>      
		<cfif not isdefined("attributes.is_activation") or (isDefined('attributes.is_activation') and attributes.is_activation eq 0)><!--- activasyon kodu yollamiyor isek buraya girer --->
			<cfif isdefined("session.ww") and isdefined('attributes.consumer_email') and len(attributes.consumer_email) and isvalid('email',attributes.consumer_email)>
                <cfmail
                    to= "#attributes.consumer_email#"
                    from= "#get_our_email.company_name#<#get_our_email.email#>"
                    subject= "#cgi.http_host# #alert#"
                    type= "HTML">
                    <style type="text/css">
                        .label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
                        .headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
                    </style>
                    <table align="center" style="width:590px;">
                        <tr>
                            <td><cf_get_lang dictionary_id='58780.Sayın'> <strong>#attributes.consumer_name# #attributes.consumer_surname#</strong></td>
                        </tr>
                        <tr>
                            <td>#get_our_email.company_name# ayrıcalıklarından yararlanmak için yaptığınız üyelik başvurunuz tarafımıza ulaşmıştır. Bilgilerinizin doğrulanması amacıyla, en kısa sürede Müşteri Hizmetleri yetkilimiz sizinle irtibata geçecektir. İlginize teşekkür ederiz. Saygılarımızla #get_our_email.company_name#
                            </td>
                        </tr>
                    </table>
                </cfmail>
            </cfif>  
		</cfif>
	</cftransaction>
</cflock>

<cfif isdefined("attributes.is_activation") and attributes.is_activation eq 1><!--- activasyon kodu yolluyor isek sisteme almayacagiz --->
	<cfset attributes.is_cons_login = 0>
</cfif>

<cfif isdefined('attributes.consumer_email') and len(attributes.consumer_email) and isvalid('email',attributes.consumer_email) and isdefined("session.ww") and isdefined("attributes.password1")>
	<cfif isDefined('attributes.is_activation') and attributes.is_activation eq 1>
		<cfsavecontent variable="message"><cfoutput>#cgi.http_host#</cfoutput> Aktivasyon Maili</cfsavecontent>
	<cfelse>
		<cfsavecontent variable="message">Şifre Bilgilendirme İşlemi</cfsavecontent>
	</cfif>
    <cftry> 				 
        <cfmail 
            to = "#attributes.consumer_email#"
            from = "#get_our_email.company_name# <#get_our_email.email#>"
            subject = "#cgi.http_host# #message# "
            type="HTML">  
            <style type="text/css">
                .label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
                .headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
            </style>		  
            <br/>
            <table align="center" style="width:590px;">
				<cfif isdefined("attributes.is_activation") and attributes.is_activation eq 1><!--- activasyon kodu yolluyor isek sisteme almadan önce aktivasyon isteriz --->
					<tr>
                        <td>
                        <br /><br />
                        <br />
                        <cf_get_lang dictionary_id='58780.Sayın'> <cfoutput><strong>#attributes.consumer_name# #attributes.consumer_surname#</strong></cfoutput></td>
                    </tr>
                    <tr>
                        <td>Bu e-posta size size üyelik talebiniz üzerine gönderilmiştir. Eğer böyle bir talebiniz olmadı ise lütfen bu e-posta'yı yoksayınız.</td>
                    </tr>
                    <tr>
                        <td>Üyeliğinizi aktive etmek için lütfen aşağıdaki linke tıklayınız:</td>
                    </tr>
                    <tr>
                        <td>
                            <cfset cont_key = 'wrk'>
                            <cfset act_key_ = encrypt('#attributes.consumer_email#',cont_key,"CFMX_COMPAT","Hex")>
                            <a href="http://#cgi.HTTP_HOST#/index.cfm?fuseaction=home.emptypopup_active_consumer&act_key=#act_key_#">http://#cgi.HTTP_HOST#/index.cfm?fuseaction=home.emptypopup_active_consumer&act_key=#act_key_#</a>
                        </td>
                    </tr>
                    <tr>
                        <td>Eğer link çalışmıyor ise lütfen linki tarayıcınıza kopyalayıp yapıştırarak aktivasyon işlemini gerçekleştirin.</td>
                    </tr>
            	</cfif>
                <tr style="height:35px;">
                    <td class="headbold"><cf_get_lang dictionary_id='58226.Şifre Hatırlatıcı'></td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id ='29709.Kullanıcı Adınız'>:<strong>#attributes.consumer_email#</strong></td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id ='35726.Şifreniz'>:<strong>#attributes.password1#</strong></td>
                </tr>
            </table>
            <br/>
        </cfmail>
        <cfcatch type="any">
            <script type="text/javascript">
                alert("<cf_get_lang dictionary_id ='35727.Mail Gönderiminde Hata Oluştu! Lütfen Bilgilerinizi Kontrol Ediniz'>!");
                history.back();
            </script>		
        <cfabort>
        </cfcatch>	
    </cftry>	
</cfif>

<!---<cfquery name="GET_ACC_INFO" datasource="#DSN#">
	SELECT 
		PUBLIC_ACCOUNT_CODE 
	FROM 
		OUR_COMPANY_INFO 
	WHERE 
		COMP_ID = <cfif isdefined("session.ww")>#session.ww.our_company_id#<cfelseif isdefined("session.pp")>#session.pp.our_company_id#<cfelse>#session.ep.company_id#</cfif>
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
		<cfif isdefined("session.ww")>#session.ww.period_id#,<cfelseif isdefined("session.pp")>#session.pp.period_id#,<cfelse>#session.ep.period_id#,</cfif>
		<cfif len(get_acc_info.public_account_code)>'#get_acc_info.public_account_code#'<cfelse>NULL</cfif>
	)
</cfquery>--->

<!--- site tanımı için gerekli --->
<!--- <cfquery name="ADD_" datasource="#DSN#">
	INSERT INTO
		COMPANY_CONSUMER_DOMAINS
	(
		CONSUMER_ID,
		<!---SITE_DOMAIN,--->
        MENU_ID,
		RECORD_DATE,
		RECORD_CONS,
		RECORD_IP
	)
	VALUES
	(
		#get_max_cons.max_cons#,
        <cfif isDefined('session.pp.userid')>
        	#session.pp.menu_id#,
		<cfelseif isDefined('session.ww')>
        	#session.ww.menu_id#,        
        </cfif>
		<!---'#cgi.http_host#',--->
		#now()#,
		#get_max_cons.max_cons#,
		'#cgi.remote_addr#'
	)
</cfquery> --->

<!--- ilgili not varsa --->
<cfif isdefined('attributes.note') and len(attributes.note)>
	<cfquery name="getConsNote" datasource="#DSN#">
		INSERT INTO 
			NOTES 
		( 
			ACTION_SECTION, 
			ACTION_ID, 
			NOTE_HEAD, 
			NOTE_BODY, 
			IS_SPECIAL, 
			IS_WARNING, 
			COMPANY_ID, 
			RECORD_CONS, 
			RECORD_DATE, 
			RECORD_IP 
		) 
		VALUES 
		( 
			'CONSUMER_ID', 
			#get_max_cons.max_cons#, 
			#sql_unicode()#'#attributes.consumer_name# #attributes.consumer_surname#', 
			#sql_unicode()#'#attributes.note#',
			0, 
			0, 
            <cfif isDefined('session.pp.userid')>
				#session.pp.our_company_id#, 
            <cfelse>            
				#session.ww.our_company_id#, 
			</cfif>
            #get_max_cons.max_cons#, 
			#now()#, 
			'#cgi.remote_addr#' 
		) 
	</cfquery>
</cfif>

<cfif isDefined("session.pp") or isDefined("session.ww")>
    <script type="text/javascript">
        alert("<cf_get_lang dictionary_id ='34892.Kaydınız Başarıyla Alınmıştır !'>");
        window.location.replace(document.referrer);
    </script>
<cfelse>
    <cfif isdefined('attributes.is_cons_login') and attributes.is_cons_login eq 1>
        <cfoutput>
        <form name="login" method="post" action="#request.self#?fuseaction=home.act_login">
            <cfif len(attributes.return_address)>
                <input type="hidden" name="referer" id="referer" value="#attributes.return_address#">
            </cfif>
            <input type="hidden" name="member_type" id="member_type" value="1">
            <input type="hidden" name="username" id="username" value="#attributes.consumer_email#">
            <input type="hidden" name="password" id="password" value="#password1#">
        </form>
        </cfoutput>
        <script type="text/javascript">
            login.submit();
        </script>
    <cfelse>
        <cfif len(attributes.return_address)>
            <script type="text/javascript">
                alert("<cf_get_lang dictionary_id ='34892.Kaydınız Başarıyla Alınmıştır !'>");
                window.location.href='<cfoutput>#attributes.return_address#</cfoutput>';
            </script>
        <cfelse>
            <script type="text/javascript">
                alert("<cf_get_lang dictionary_id ='34892.Kaydınız Başarıyla Alınmıştır !'>");
                window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.welcome';
            </script>
        </cfif>
    </cfif>
</cfif>