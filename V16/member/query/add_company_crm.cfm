<!--- 
	Bu sayfanın aynısı Call Center modulu altında bulunmaktadır. 
	Burada yapılan degisiklikler oraya da yansıtılmalıdır.
	BK 051026
 --->
<cfif len(attributes.startdate)><cf_date tarih='attributes.startdate'></cfif>
<cfif len(attributes.organization_start_date)><cf_date tarih='attributes.organization_start_date'></cfif>
<cfif isdefined("attributes.name_") and len(attributes.name_)><cfset attributes.name = attributes.name_></cfif>
<cfscript>
	list="',""";
	list2=" , ";
	attributes.name=replacelist(trim(attributes.name),list,list2);
	attributes.soyad=replacelist(trim(attributes.soyad),list,list2);
	a = "";
</cfscript>
<cfloop from="1" to="#listlen(attributes.name,' ')#" index="i">
	<cfif len(listgetat(attributes.name,i,' ')) gt 1>
		<cfset b = ucase(left(listgetat(attributes.name,i,' '),1)) & lcase(right(listgetat(attributes.name,i,' '),len(listgetat(attributes.name,i,' '))-1))>
	<cfelse>
		<cfset b = ucase(left(listgetat(attributes.name,i,' '),1))>
	</cfif>
	<cfset a = '#a# #b#'>	
</cfloop>
<cfset attributes.name = trim(a)>
<cfset a = "">
<cfloop from="1" to="#listlen(attributes.soyad,' ')#" index="i">
	<cfif len(listgetat(attributes.soyad,i,' ')) gt 1>
		<cfset b = ucase(left(listgetat(attributes.soyad,i,' '),1)) & lcase(right(listgetat(attributes.soyad,i,' '),len(listgetat(attributes.soyad,i,' '))-1))>
	<cfelse>
		<cfset b = ucase(left(listgetat(attributes.soyad,i,' '),1))>
	</cfif>
	<cfset a = '#a# #b#'>	
</cfloop>
<cfif len(attributes.our_company_id) and len(attributes.our_company_name)>
	<cfquery name="get_our_companies" datasource="#dsn#">
		SELECT OUR_COMPANY_ID FROM COMPANY WHERE OUR_COMPANY_ID = #attributes.our_company_id#
	</cfquery>
	<cfif get_our_companies.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='568.Aynı Şirkete Birden Fazla Grup Şirketi Ekleyemezsiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfscript>
	list="',""";
	list2=" , ";
	attributes.nickname=replacelist(trim(attributes.nickname),list,list2);
	attributes.fullname=replacelist(trim(attributes.fullname),list,list2);
</cfscript>
<!--- dış görünüm --->
<cfset upload_folder = "#upload_folder#member#dir_seperator#">
<cfif isDefined("attributes.asset1") and len(attributes.asset1)>
	<CFTRY>
		<cffile action="UPLOAD"
				filefield="asset1"
				destination="#upload_folder#"
				mode="777"
				nameconflict="MAKEUNIQUE">
			<cfset file_name = createUUID()>
			<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
			<!---Script dosyalarını engelle  02092010 FA-ND --->
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
				<script type="text/javascript">
					alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					history.back();
				</script>
				<cfabort>
			</cfif>
		
			<cfset attributes.asset1 = '#file_name#.#cffile.serverfileext#'>
	
		<CFCATCH type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'>!");
				history.back();
			</script>
			<cfabort>
		</CFCATCH>
	</CFTRY>
</cfif>
<!--- dış görünüm --->
<!--- Kroki --->
<cfif isDefined("attributes.asset2") and len(attributes.asset2)>
	<CFTRY>
		<cffile action="UPLOAD"
				filefield="asset2"
				destination="#upload_folder#"
				mode="777"
				nameconflict="MAKEUNIQUE">
			<cfset file_name = createUUID()>
			<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
			<cfset attributes.asset2 = '#file_name#.#cffile.serverfileext#'>
	
		<CFCATCH type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'>!");
				history.back();
			</script>
			<cfabort>
		</CFCATCH>
	</CFTRY>
</cfif>
<!--- Kroki --->
<!--- Uye Kodu kontrolü  --->
<cfif isDefined("attributes.company_code") and len(attributes.company_code)>
	<cfquery name="GET_COMPANY_CODE" datasource="#DSN#">
		SELECT 	
			COMPANY_ID
		FROM 
			COMPANY 
		WHERE 
			MEMBER_CODE = '#trim(attributes.company_code)#'
	</cfquery> 
	<cfif get_company_code.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no ='569.Üye Kodu'> <cf_get_lang_main no='781.tekrarı'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<!--- sirket unvanı ve kısa unvanı kontrolü  --->
<cfset attributes.fullname = trim(attributes.fullname)>
<cfset attributes.nickname = trim(attributes.nickname)>
<cfquery name="GET_COMP" datasource="#DSN#">
	SELECT 	
		COMPANY_ID 
	FROM 
		COMPANY 
	WHERE 
		FULLNAME = '#attributes.fullname#' AND
		NICKNAME = '#attributes.nickname#' 
</cfquery> 
<cfif get_comp.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no ='176.şirket ünvanı'> <cf_get_lang_main no='781.tekrarı'>!");
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
				COMPANY_STATE,
				COMPANY_STATUS,
				COMPANYCAT_ID,
				PERIOD_ID,
				OUR_COMPANY_ID,
				MEMBER_CODE,
				HIERARCHY_ID,
				NICKNAME,
				FULLNAME,
				TAXOFFICE,
				TAXNO,
				COMPANY_EMAIL,
				HOMEPAGE,
				COMPANY_TELCODE,
				COMPANY_TEL1,
				COMPANY_TEL2,
				COMPANY_TEL3,
				COMPANY_FAX,												
				COMPANY_POSTCODE,
				COMPANY_ADDRESS,
				COUNTY,
				CITY,
				COUNTRY,
				RECORD_EMP,
				RECORD_IP,
				ISPOTANTIAL,	
				SECTOR_CAT_ID,
				POS_CODE,
				COMPANY_SIZE_CAT_ID,
				SALES_COUNTY,
				IS_SELLER,
				IS_BUYER,
				RESOURCE_ID,
				COMPANY_RATE,
				COMPANY_VALUE_ID,
				<cfif isDefined("attributes.asset1") and len(attributes.asset1)>
					ASSET_FILE_NAME1,
					ASSET_FILE_NAME1_SERVER_ID,
				</cfif>
				<cfif isDefined("attributes.asset2") and len(attributes.asset2)>
					ASSET_FILE_NAME2,
					ASSET_FILE_NAME2_SERVER_ID,
				</cfif>
				RECORD_DATE,
				START_DATE,
				ORG_START_DATE,
				IMS_CODE_ID,
				SEMT,
				OZEL_KOD,
				OZEL_KOD_1,
				OZEL_KOD_2,
				IS_RELATED_COMPANY
			)
			VALUES
			(
				#attributes.process_stage#,
				<cfif isdefined("attributes.currency")>1<cfelse>0</cfif>,
				#attributes.companycat_id#,
				#attributes.period_id#,
				<cfif len(attributes.our_company_id) and len(attributes.our_company_name)>#attributes.our_company_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.company_code)>'#trim(attributes.company_code)#'<cfelse>NULL</cfif>,
				<cfif len(attributes.hierarchy_id)>#attributes.hierarchy_id#<cfelse>NULL</cfif>,
				'#attributes.nickname#',
				'#attributes.fullname#',
				<cfif isdefined("attributes.taxoffice") and len(attributes.taxoffice)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.taxoffice#"><cfelseif isdefined("attributes.vd") and len(attributes.vd)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.vd#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.taxno") and len(attributes.taxno)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.taxno#"><cfelseif isdefined("attributes.vno") and len(attributes.vno)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.vno#"><cfelse>NULL</cfif>,
				'#trim(attributes.email)#',
				'#trim(attributes.homepage)#',
				'#attributes.telcod#',
				'#attributes.tel1#',				
				'#attributes.tel2#',						
				'#attributes.tel3#',
				'#attributes.fax#',
				'#attributes.postcod#',
				'#attributes.adres#',
				<cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				<cfif isdefined("attributes.ispotential")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.company_sector") and len(attributes.company_sector)>#attributes.company_sector#<cfelse>NULL</cfif>,
				<cfif len(attributes.pos_code)>#attributes.pos_code#<cfelse>NULL</cfif>,
				<cfif len(attributes.company_size_cat_id)>#attributes.company_size_cat_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.sales_county)>#attributes.sales_county#<cfelse>NULL</cfif>,
				<cfif isdefined("is_seller")>1<cfelse>0</cfif>,
				<cfif isdefined("is_buyer")>1<cfelse>0</cfif>,
				<cfif len(attributes.resource)>#attributes.resource#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.company_sector") and len(attributes.company_rate)>#attributes.company_rate#<cfelse>NULL</cfif>,
				<cfif len(attributes.customer_value)>#attributes.customer_value#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.asset1") and len(attributes.asset1)>
					'#attributes.asset1#',
					#fusebox.server_machine#,
				</cfif>
				<cfif isDefined("attributes.asset2") and len(attributes.asset2)>
					'#attributes.asset2#',
					#fusebox.server_machine#,
				</cfif>
				#now()#,
				<cfif isdefined("attributes.startdate") and len(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.organization_start_date") and len(attributes.organization_start_date)>#attributes.organization_start_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.ims_code_id)>#attributes.ims_code_id#<cfelse>NULL</cfif>,
				'#attributes.semt#',
				'#attributes.ozel_kod#',
				'#attributes.ozel_kod_1#',
				'#attributes.ozel_kod_2#',
				<cfif isdefined("attributes.is_related_company")>1<cfelse>0</cfif>
			)
		</cfquery>
		<cfquery name="GET_MAX" datasource="#DSN#">
			SELECT MAX(COMPANY_ID) AS MAX_COMPANY FROM COMPANY
		</cfquery>	
		<cfquery name="ADD_COMP_PERIOD" datasource="#DSN#">
			INSERT INTO
				COMPANY_PERIOD
			(
				COMPANY_ID,
				PERIOD_ID
			)
			VALUES
			(
				#get_max.max_company#,
				#attributes.period_id#
			)
		</cfquery>
		<cfquery name="ADD_PARTNER" datasource="#DSN#">
			INSERT INTO 
				COMPANY_PARTNER 
				(
					<!--- COMPANYCAT_ID, --->
					COMPANY_ID,
					COMPANY_PARTNER_NAME,
					COMPANY_PARTNER_SURNAME,
					COMPANY_PARTNER_STATUS,
					TITLE,
					SEX,
					DEPARTMENT,
					COMPANY_PARTNER_EMAIL,
					MOBIL_CODE,
					MOBILTEL,
					COMPANY_PARTNER_TELCODE,
					COMPANY_PARTNER_TEL,
					COMPANY_PARTNER_TEL_EXT,
					COMPANY_PARTNER_FAX,
					HOMEPAGE,
					MISSION,
					RECORD_DATE,
					MEMBER_TYPE,
					RECORD_MEMBER,
					RECORD_IP,		
					COMPANY_PARTNER_ADDRESS,
					COMPANY_PARTNER_POSTCODE,
					COUNTY,
					CITY,
					COUNTRY,		
					SEMT
				)
				VALUES
				(
					<!--- #attributes.companycat_id#, --->
					#get_max.max_company#,
					'#attributes.name#',
					'#attributes.soyad#',
					#attributes.company_partner_status#,
					'#attributes.title#',
					#attributes.sex#,
					<cfif len(attributes.department)>#attributes.department#<cfelse>NULL</cfif>,
					'#attributes.company_partner_email#',
					'#attributes.mobilcat_id#',
					'#attributes.mobiltel#',
					'#attributes.telcod#',
					'#attributes.tel1#',
					'#attributes.tel_local#',
					'#attributes.fax#',
					'#attributes.homepage#',
					<cfif len(attributes.mission)>#attributes.mission#<cfelse>NULL</cfif>,
					#now()#,
					1,
					#session.ep.userid#,
					'#cgi.remote_addr#',	
					'#attributes.adres#',
					'#attributes.postcod#',
					<cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
					'#attributes.semt#'
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
				15
			)
		</cfquery>
		
		<!--- Adres Defteri --->
		<cfif not isDefined("attributes.county_id")><cfset attributes.county_id = ""></cfif>
		<cfif not isDefined("attributes.city_id")><cfset attributes.city_id = ""></cfif>
		<cfif not isDefined("attributes.country")><cfset attributes.country = ""></cfif>
		<cfif not isDefined("attributes.company_sector")><cfset attributes.company_sector = ""></cfif>
		<cf_addressbook
			design		= "1"
			type		= "2"
			type_id		= "#get_max_partner.max_partner_id#"
			active		= "#attributes.company_partner_status#"
			name		= "#attributes.name#"
			surname		= "#attributes.soyad#"
			sector_id	= "#ListFirst(attributes.company_sector)#"
			company_name= "#wrk_eval('attributes.fullname')#"
			title		= "#attributes.title#"
			email		= "#attributes.company_partner_email#"
			telcode		= "#attributes.telcod#"
			telno		= "#attributes.tel1#"
			faxno		= "#attributes.fax#"
			mobilcode	= "#attributes.mobilcat_id#"
			mobilno		= "#attributes.mobiltel#"
			web			= "#attributes.homepage#"
			postcode	= "#attributes.postcod#"
			address		= "#wrk_eval('attributes.adres')#"
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
	</cftransaction>
</cflock>
<!--- Burada Çalışacak Kod Sürec Kodu HEDEF Crm de cakisacak--->
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='COMPANY'
	action_column='COMPANY_ID'
	action_id='#get_max.max_company#'
	action_page='#request.self#?fuseaction=crm.form_upd_supplier&cpid=#get_max.max_company#&pid=#get_max_partner.max_partner_id#&type=crm' 
	warning_description = 'Kurumsal Üye : #attributes.fullname#'>
<cflocation url="#request.self#?fuseaction=crm.form_upd_supplier&cpid=#get_max.max_company#&pid=#get_max_partner.max_partner_id#&type=crm" addtoken="no">
