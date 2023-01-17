<cfsetting enablecfoutputonly="yes">
<cfprocessingdirective suppresswhitespace="yes">
<cffunction name="add_consumer_history" returntype="boolean" output="false">
	<cfargument name="consumer_id" required="yes" type="numeric">
	<cfquery name="hist_cont" datasource="#dsn#">
		SELECT
			C.*,
			(	SELECT
					MAX(POSITION_CODE) POS_CODE
				FROM
					WORKGROUP_EMP_PAR
				WHERE
					CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"> AND 
					OUR_COMPANY_ID=	<cfif isdefined("session.cp.our_company_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">
									<cfelseif isdefined("session.pp.company_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
									<cfelseif isdefined("session.ww.our_company_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
									<cfelseif isdefined("session.pda.our_company_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">
									<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"></cfif> AND
					IS_MASTER = 1
			) AGENT_POS_CODE
		FROM
			CONSUMER C
		WHERE
			C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
	</cfquery>
	<cfoutput query="hist_cont">
		<cfif (isdefined("attributes.consumer_password") and attributes.consumer_password neq hist_cont.consumer_password)>
			<cf_cryptedpassword password='#hist_cont.consumer_password#' output='hist_pass' mod='1'>
		</cfif>
		<cfquery name="add_consumer_hist" datasource="#dsn#">
			INSERT INTO
				CONSUMER_HISTORY
			(
				CONSUMER_ID,
				PERIOD_ID,
				CONSUMER_CAT_ID,
				CONSUMER_NAME,
				CONSUMER_SURNAME,
				MEMBER_CODE,
				AGENT_POS_CODE,
				COMPANY,
				CONSUMER_STAGE,
				CONSUMER_EMAIL,
				MOBIL_CODE,
				MOBILTEL,
				CONSUMER_FAXCODE,
				CONSUMER_FAX,
				CONSUMER_HOMETELCODE,
				CONSUMER_HOMETEL,
				HOMEADDRESS,
				HOMEPOSTCODE,
				HOMESEMT,
				HOME_COUNTY_ID,
				HOME_CITY_ID,
				HOME_COUNTRY_ID,
				HOME_DISTRICT,
				HOME_DISTRICT_ID,
				HOME_MAIN_STREET,
				HOME_STREET,
				HOME_DOOR_NO,
				CONSUMER_WORKTELCODE,
				CONSUMER_WORKTEL,
				CONSUMER_TEL_EXT,
				WORKADDRESS,
				WORKPOSTCODE,
				WORKSEMT,
				WORK_COUNTY_ID,
				WORK_CITY_ID,
				WORK_COUNTRY_ID,
				WORK_DISTRICT,
				WORK_DISTRICT_ID,
				WORK_MAIN_STREET,
				WORK_STREET,
				WORK_DOOR_NO,
				TAX_OFFICE,
				TAX_NO,
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
				VOCATION_TYPE_ID,
				TC_IDENTY_NO,
				FATHER,
				MOTHER,
				SALES_COUNTY,
				CONSUMER_STATUS,
				IS_TAXPAYER,
				ISPOTANTIAL,
				IS_CARI,
				IS_RELATED_CONSUMER,
				<cfif isdefined("attributes.consumer_password") and len(consumer_password)>CONSUMER_PASSWORD,</cfif>
				CONSUMER_REFERENCE_CODE,
				REF_POS_CODE,
				PROPOSER_CONS_ID,
				RECORD_DATE,
				<cfif isdefined("session.ep.userid") or isdefined("session.cp.userid") or isdefined("session.pda.userid")>
					RECORD_EMP,
				<cfelseif isdefined("session.ww.userid")>
					RECORD_CONS,
				<cfelseif isdefined("session.pp.userid")>
					RECORD_PAR,
				</cfif>
				RECORD_IP
			)
			VALUES
			(
				#consumer_id#,
				<cfif len(period_id)>#period_id#<cfelse>NULL</cfif>,
				<cfif len(consumer_cat_id)>#consumer_cat_id#<cfelse>NULL</cfif>,
				<cfif len(consumer_name)>'#consumer_name#'<cfelse>NULL</cfif>,
				<cfif len(consumer_surname)>'#consumer_surname#'<cfelse>NULL</cfif>,
				<cfif len(member_code)>'#trim(member_code)#'<cfelse>'B#consumer_id#'</cfif>,
				<cfif len(agent_pos_code)>#agent_pos_code#<cfelse>NULL</cfif>,
				<cfif len(company)>'#company#'<cfelse>NULL</cfif>,
				<cfif len(consumer_stage)>#consumer_stage#<cfelse>NULL</cfif>,
				<cfif len(consumer_email)>'#consumer_email#'<cfelse>NULL</cfif>,
				<cfif len(mobil_code)>'#mobil_code#'<cfelse>NULL</cfif>,
				<cfif len(mobiltel)>'#mobiltel#'<cfelse>NULL</cfif>,
				<cfif len(consumer_faxcode)>'#consumer_faxcode#'<cfelse>NULL</cfif>,
				<cfif len(consumer_fax)>'#consumer_fax#'<cfelse>NULL</cfif>,
				<cfif len(consumer_hometelcode)>'#consumer_hometelcode#'<cfelse>NULL</cfif>,
				<cfif len(consumer_hometel)>'#consumer_hometel#'<cfelse>NULL</cfif>,
				<cfif len(homeaddress)>'#homeaddress#'<cfelse>NULL</cfif>,
				<cfif len(homepostcode)>'#homepostcode#'<cfelse>NULL</cfif>,				
				<cfif len(homesemt)>'#homesemt#'<cfelse>NULL</cfif>,  
				<cfif len(home_county_id)>#home_county_id#<cfelse>NULL</cfif>,
				<cfif len(home_city_id)>#home_city_id#<cfelse>NULL</cfif>,
				<cfif len(home_country_id)>#home_country_id#<cfelse>NULL</cfif>,
				<cfif len(home_district)>'#home_district#'<cfelse>NULL</cfif>,
				<cfif len(home_district_id)>'#home_district_id#'<cfelse>NULL</cfif>,
				<cfif len(home_main_street)>'#home_main_street#'<cfelse>NULL</cfif>,
				<cfif len(home_street)>'#home_street#'<cfelse>NULL</cfif>,
				<cfif len(home_door_no)>'#home_door_no#'<cfelse>NULL</cfif>,
				<cfif len(consumer_worktelcode)>'#consumer_worktelcode#'<cfelse>NULL</cfif>,
				<cfif len(consumer_worktel)>'#consumer_worktel#'<cfelse>NULL</cfif>,
				<cfif len(consumer_tel_ext)>'#consumer_tel_ext#'<cfelse>NULL</cfif>,
				<cfif len(workaddress)>'#workaddress#'<cfelse>NULL</cfif>,
				<cfif len(workpostcode)>'#workpostcode#'<cfelse>NULL</cfif>,
				<cfif len(worksemt)>'#worksemt#'<cfelse>NULL</cfif>,
				<cfif len(work_county_id)>#work_county_id#<cfelse>NULL</cfif>,			
				<cfif len(work_city_id)>#work_city_id#<cfelse>NULL</cfif>,
				<cfif len(work_country_id)>#work_country_id#<cfelse>NULL</cfif>,
				<cfif len(work_district)>'#work_district#'<cfelse>NULL</cfif>,
				<cfif len(work_district_id)>'#work_district_id#'<cfelse>NULL</cfif>,
				<cfif len(work_main_street)>'#work_main_street#'<cfelse>NULL</cfif>,
				<cfif len(work_street)>'#work_street#'<cfelse>NULL</cfif>,
				<cfif len(work_door_no)>'#work_door_no#'<cfelse>NULL</cfif>,
				<cfif len(tax_office)>'#tax_office#'<cfelse>NULL</cfif>,
				<cfif len(tax_no)>'#tax_no#'<cfelse>NULL</cfif>,
				<cfif len(tax_adress)>'#tax_adress#'<cfelse>NULL</cfif>,
				<cfif len(tax_postcode)>'#tax_postcode#'<cfelse>NULL</cfif>,
				<cfif len(tax_semt)>'#tax_semt#'<cfelse>NULL</cfif>,
				<cfif len(tax_county_id)>#tax_county_id#<cfelse>NULL</cfif>,
				<cfif len(tax_city_id)>#tax_city_id#<cfelse>NULL</cfif>,
				<cfif len(tax_country_id)>#tax_country_id#<cfelse>NULL</cfif>,
				<cfif len(tax_district)>'#tax_district#'<cfelse>NULL</cfif>,
				<cfif len(tax_district_id)>'#tax_district_id#'<cfelse>NULL</cfif>,
				<cfif len(tax_main_street)>'#tax_main_street#'<cfelse>NULL</cfif>,
				<cfif len(tax_street)>'#tax_street#'<cfelse>NULL</cfif>,
				<cfif len(tax_door_no)>'#tax_door_no#'<cfelse>NULL</cfif>,
				<cfif len(vocation_type_id)>#vocation_type_id#<cfelse>NULL</cfif>,
				<cfif len(tc_identy_no)>'#tc_identy_no#'<cfelse>NULL</cfif>,
				<cfif len(father)>'#father#'<cfelse>NULL</cfif>,
				<cfif len(mother)>'#mother#'<cfelse>NULL</cfif>,
				<cfif len(sales_county)>#sales_county#<cfelse>NULL</cfif>,
				<cfif len(consumer_status)>#consumer_status#<cfelse>NULL</cfif>,
				<cfif len(is_taxpayer)>#is_taxpayer#<cfelse>NULL</cfif>,
				<cfif len(ispotantial)>#ispotantial#<cfelse>NULL</cfif>,
				<cfif len(is_cari)>#is_cari#<cfelse>NULL</cfif>,
				<cfif len(is_related_consumer)>#is_related_consumer#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.consumer_password") and len(consumer_password)>'#hist_pass#',</cfif>
				<cfif len(consumer_reference_code)>'#consumer_reference_code#'<cfelse>NULL</cfif>,
				<cfif len(ref_pos_code)>#ref_pos_code#<cfelse>NULL</cfif>,
				<cfif len(proposer_cons_id)>#proposer_cons_id#<cfelse>NULL</cfif>,
				#now()#,
				<cfif isdefined("session.ep.userid") or isdefined("session.cp.userid") or isdefined("session.pda.userid")>
					#session.ep.userid#,
				<cfelseif isdefined("session.ww.userid")>
					#session.ww.userid#,
				<cfelseif isdefined("session.pp.userid")>
					#session.pp.userid#,
				</cfif>
				'#cgi.remote_addr#'
			)
		</cfquery>
	</cfoutput>
	<cfreturn 1>
</cffunction>
</cfprocessingdirective>
<cfsetting enablecfoutputonly="no">
