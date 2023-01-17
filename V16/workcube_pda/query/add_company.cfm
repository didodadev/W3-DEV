<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.organization_start_date" default="">
<cfparam name="attributes.currency" default="1">
<cfparam name="attributes.our_company_id" default="">
<cfparam name="attributes.our_company_name" default="">
<cfparam name="attributes.period_id" default="#session.pda.period_id#">
<cfparam name="attributes.company_code" default="">
<cfparam name="attributes.hierarchy_id" default="">
<cfparam name="attributes.vd" default="">
<cfparam name="attributes.vno" default="">
<cfparam name="attributes.homepage" default="">
<cfparam name="attributes.tel2" default="">
<cfparam name="attributes.tel3" default="">
<cfparam name="attributes.fax" default="">
<cfparam name="attributes.postcod" default="">
<cfparam name="attributes.company_sector" default="">
<cfparam name="attributes.company_size_cat_id" default="">
<cfparam name="attributes.sales_county" default="">
<cfparam name="attributes.resource" default="">
<cfparam name="attributes.company_rate" default="">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.ozel_kod" default="">
<cfparam name="attributes.ozel_kod_1" default="">
<cfparam name="attributes.ozel_kod_2" default="">
<cfparam name="attributes.pos_code" default="#session.pda.position_code#">
<cfparam name="attributes.company_partner_status" default="1">
<cfparam name="attributes.title" default="">
<cfparam name="attributes.sex" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.company_partner_email" default="">
<cfparam name="attributes.mobilcat_id" default="">
<cfparam name="attributes.mobiltel" default="">
<cfparam name="attributes.tel_local" default="">
<cfparam name="attributes.mission" default="">
<cfparam name="form.companycat_id" default="#attributes.companycat_id#">

<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.pda.userid#_'&round(rand()*100)>
<!--- sirket unvanı ve kısa unvanı kontrolü  --->
<cfset attributes.fullname = trim(attributes.fullname)>
<cfquery name="GET_COMP" datasource="#DSN#">
	SELECT TOP 1 
		CSR.SECTOR_ID SECTOR_CAT_ID,
        C.COMPANY_ID 
    FROM 
    	COMPANY_SECTOR_RELATION CSR,
        COMPANY C 
    WHERE 
    	C.COMPANY_ID = CSR.COMPANY_ID AND 
        C.FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fullname#">
</cfquery> 
<cfif get_comp.recordcount><!--- ve Kısa Ünvanı  --->
	<script type="text/javascript">
		alert("Şirketin tam ünvanı ile kayıtlı bir şirket var. Lütfen kontrol ediniz!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>					
		<cfquery name="ADD_COMPANY" datasource="#DSN#">
			INSERT INTO 
				COMPANY
				(
					WRK_ID,
					COMPANY_STATE,
					COMPANY_STATUS,
					COMPANY_EMAIL,
					COMPANYCAT_ID,
					PERIOD_ID,
					OUR_COMPANY_ID,
					MEMBER_CODE,
					HIERARCHY_ID,
					NICKNAME,
					FULLNAME,
					TAXOFFICE,
					TAXNO,
					COMPANY_TELCODE,
					COMPANY_TEL1,
					MOBIL_CODE,
					MOBILTEL,
					COMPANY_ADDRESS,
					COUNTRY,					
					CITY,
					COUNTY,
					COMPANY_VALUE_ID,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					SALES_COUNTY,								
					IMS_CODE_ID,
                    IS_BUYER,
					SEMT
				)
				VALUES
				(
					'#wrk_id#',
					4,
					1,
					<cfif isdefined('attributes.email') and len(attributes.email)>#trim(attributes.email)#<cfelse>NULL</cfif>,
					#attributes.companycat_id#,
					#attributes.period_id#,
					#session.pda.our_company_id#,
					NULL,
					<cfif len(attributes.hierarchy_id)>#attributes.hierarchy_id#<cfelse>NULL</cfif>,
					'#attributes.nickname#',
					'#attributes.fullname#',
					'#attributes.tax_office#',
					'#attributes.tax_no#',
					<cfif isdefined('attributes.telcod') and len(attributes.telcod)>'#attributes.telcod#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.tel1') and len(attributes.tel1)>'#attributes.tel1#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.telcod') and len(attributes.telcod)>'#attributes.telcod#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.mobilcat_id') and len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.mobiltel') and len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
					<cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,				
					<cfif len(attributes.city_id) and len(attributes.city)>#attributes.city_id#<cfelse>NULL</cfif>,	
					<cfif len(attributes.county_id) and len(attributes.county)>#attributes.county_id#<cfelse>NULL</cfif>,
					<cfif isDefined('attributes.customer_value') and len(attributes.customer_value)>#attributes.customer_value#<cfelse>NULL</cfif>,
					#session.pda.userid#,
					'#cgi.remote_addr#',
					#now()#,
					<cfif len(attributes.sales_county)>#attributes.sales_county#<cfelse>NULL</cfif>,
					<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>#attributes.ims_code_id#<cfelse>NULL</cfif>,
                    1,
					'#attributes.semt#'
				)
		</cfquery>
		
		<cfquery name="GET_MAX" datasource="#DSN#">
			SELECT MAX(COMPANY_ID) AS MAX_COMPANY FROM COMPANY WHERE WRK_ID = '#wrk_id#'
		</cfquery>
				
		<cfquery name="ADD_PARTNER" datasource="#DSN#">
			INSERT INTO 
				COMPANY_PARTNER 
			(
				COMPANY_ID,
				COMPANY_PARTNER_NAME,
				COMPANY_PARTNER_SURNAME,
				COMPANY_PARTNER_STATUS,
				SEX,					
				RECORD_DATE,
				MEMBER_TYPE,
				RECORD_MEMBER,
				RECORD_IP
			)
			VALUES
			(
				#get_max.max_company#,
				'#attributes.name#',
				'#attributes.surname#',
				1,
				#attributes.sex#,
				#now()#,
				1,
				#session.pda.userid#,
				'#cgi.remote_addr#'
			)
		</cfquery>
		<cfquery name="GET_MAX_PARTNER" datasource="#DSN#">
			SELECT
				MAX(PARTNER_ID) MAX_PARTNER_ID
			FROM
				COMPANY_PARTNER
		</cfquery>
		
		<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
			UPDATE
				COMPANY_PARTNER
			SET
				MEMBER_CODE = 'CP#get_max_partner.max_partner_id#'
			WHERE
				PARTNER_ID = #get_max_partner.max_partner_id#
		</cfquery>
		<cfquery name="ADD_COMPANY_PARTNER_DETAIL" datasource="#DSN#">
			INSERT INTO
				COMPANY_PARTNER_DETAIL
			(
				PARTNER_ID
			)
			VALUES
			(
				#get_max_partner.max_partner_id#
			)
		</cfquery>
		<cfquery name="ADD_PART_SETTINGS" datasource="#DSN#">
			INSERT INTO 
				MY_SETTINGS_P 
			(
				PARTNER_ID,
				TIME_ZONE,
				MAXROWS,
				TIMEOUT_LIMIT
			)
			VALUES 
			(
				#get_max_partner.max_partner_id#,
				2,
				20,
				30
			)
		</cfquery>
		
		<!--- Adres Defteri --->
		<cf_addressbook
			design		= "1"
			type		= "2"
			type_id		= "#get_max_partner.max_partner_id#"
			name		= "#attributes.name#"
			surname		= "#attributes.surname#"
			sector_id	= "#ListFirst(get_comp.sector_cat_id)#"
			company_name= "#attributes.fullname#"
			title		= "#attributes.title#"
			email		= "#attributes.company_partner_email#"
			telcode		= "#attributes.telcod#"
			telno		= "#attributes.tel1#"
			faxno		= "#attributes.fax#"
			mobilcode	= "#attributes.mobilcat_id#"
			mobilno		= "#attributes.mobiltel#"
			web			= "#attributes.homepage#"
			postcode	= "#attributes.postcod#"
			address		= "#wrk_eval('attributes.address')#"
			semt		= "#attributes.semt#"
			county_id	= "#attributes.county_id#"
			city_id		= "#attributes.city_id#"
			country_id	= "#attributes.country#">
		
		<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
			UPDATE 
				COMPANY 
			SET		
			<cfif isdefined("attributes.company_code") and len(attributes.company_code)>
				MEMBER_CODE='#trim(attributes.company_code)#'
			<cfelse>
				MEMBER_CODE='C#get_max.max_company#'
			</cfif>
			WHERE 
				COMPANY_ID = #get_max.max_company#
		</cfquery>
		<cfquery name="UPD_MANAGER_PARTNER" datasource="#DSN#">
			UPDATE
				COMPANY
			SET
				MANAGER_PARTNER_ID = #get_max_partner.max_partner_id#
			WHERE
				COMPANY_ID = #get_max.max_company#
		</cfquery>
		<cfif not isdefined("attributes.type")>
			<cfquery name="GET_BRANCH_CID" datasource="#DSN#"><!--- Subenin company_id si --->
				SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = #listgetat(session.pda.user_location,2,'-')#
			</cfquery>
			<cfquery name="ADD_BRANCH_RELATED" datasource="#DSN#">
				INSERT INTO
					COMPANY_BRANCH_RELATED
				(
					COMPANY_ID,
					OUR_COMPANY_ID,
					BRANCH_ID,
					OPEN_DATE,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					#get_max.max_company#,
					#get_branch_cid.company_id#,
					#listgetat(session.pda.user_location,2,'-')#,
					#now()#,
					#session.pda.userid#,
					#now()#,
					'#cgi.remote_addr#'
				)
			</cfquery>
		</cfif>		
		<cfif isdefined("session.ep")>
			<cfscript>
				StructDelete(session,'ep'); 
			</cfscript>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_company&cpid=#get_max.max_company#&pid=#get_max_partner.max_partner_id#" addtoken="no">
