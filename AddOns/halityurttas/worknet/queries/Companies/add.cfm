<cfinclude template="../../config.cfm">
<cfif not isdefined('attributes.nickname')>
	<cfset attributes.nickname = left(attributes.fullname,150)>
</cfif>

<cfif isdefined('attributes.organization_start_date') and len(attributes.organization_start_date)>
	<cf_date tarih='attributes.organization_start_date'>
<cfelse>
	<cfset attributes.organization_start_date = ''>
</cfif>
<cfif len(attributes.company_partner_email)>
	<cfquery name="CHECK_USERNAME" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_USERNAME 
		FROM 
			COMPANY_PARTNER
		WHERE 
			COMPANY_PARTNER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.company_partner_email)#">
	</cfquery>
	<cfif check_username.recordcount>
		<script type="text/javascript">
			alert("Bu E-Posta ile bir kayıt bulunmaktadır. Şifrenizi unuttuysanız üye girişi ekranından şifre hatırlatma sayfasına ulaşabilirsiniz");
		</script>
	  <cfabort>
	</cfif>
</cfif>

<!--- sirket unvanı ve kısa unvanı kontrolü  --->
<cfquery name="GET_COMP" datasource="#DSN#">
	SELECT
		COMPANY_ID
	FROM
		COMPANY
	WHERE
		FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fullname#"> AND
		NICKNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.nickname#">
</cfquery> 
<cfif get_comp.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='13.uyarı'>:Şirket ünvanı <cf_get_lang_main no='781.tekrarı'>!");
	</script>
	<cfabort>
</cfif>

<cfif isdefined('attributes.password') and len(attributes.password)>
	<cf_cryptedpassword	password='#attributes.password#' output='pass' mod=1>
<cfelse>
	<cfset pass = ''>
</cfif>

<cfif isdefined("session.ep")>
	<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfelse>
	<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_1_'&round(rand()*100)>
</cfif>
<cfscript>
	list="',""";
	list2=" , ";
	attributes.name=replacelist(trim(attributes.name),list,list2);
	attributes.soyad=replacelist(trim(attributes.soyad),list,list2);
	attributes.company_address=replacelist(trim(attributes.company_address),list,list2);
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
<cfscript>
	list="',""";
	list2=" , ";
	attributes.nickname=replacelist(trim(attributes.nickname),list,list2);
	attributes.fullname=replacelist(trim(attributes.fullname),list,list2);
</cfscript>
<cfif isdefined('session.ep.userid')>
	<cfset our_comp_id = session.ep.company_id>
<cfelseif isdefined('session.pp.userid')>
	<cfset our_comp_id = session.pp.our_company_id>
<cfelseif isdefined('session.wp')>
	<cfset our_comp_id = session.wp.our_company_id>
</cfif>
<cfquery name="get_file_size_comp" datasource="#dsn#">
	SELECT FILE_SIZE,IS_FILE_SIZE FROM OUR_COMPANY_INFO WHERE COMP_ID=#our_comp_id#
</cfquery>
<!--- logo --->
<cfset upload_folder = "#upload_folder#member#dir_seperator#">
<cfobject name="fileHelper" component="#addonNS#.components.common.filehelper">
<cfif isDefined("attributes.asset1") and len(attributes.asset1)>
	<cftry>
		<cfset attributes.asset1 = fileHelper.save_uploaded_file('asset1', '#upload_folder#')>
		<cfcatch type="Any">
			<cfdump var="#cfcatch#" abort>
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'>!");
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
	
	<!--- dosya boyutu kontrol --->
	<cfif get_file_size_comp.is_file_size>
		<cfquery name="get_file_size" datasource="#dsn#">
			SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL='#listlast(cffile.serverfile,'.')#'
		</cfquery>
		<cfif get_file_size.recordcount and len(get_file_size.format_size)>
			<cfif fileHelper.remove_exceed_file(get_file_size.format_size, "#upload_folder##attributes.asset1#") eq "1">
				<script type="text/javascript">
					alert('Logo ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
				</script>
				<cfabort>
			</cfif>
			<!---
			<cfset dt_size=get_file_size.format_size * 1048576>
			<cfif INT(dt_size) lte INT(filesize)>
				<cfif FileExists("#upload_folder##attributes.asset1#")>
					<cffile action="delete" file="#upload_folder##attributes.asset1#">
				</cfif>
				<script type="text/javascript">
					alert('Logo ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
					history.back();
				</script>
				<cfabort>
			</cfif>
			--->
		</cfif>
	</cfif>
	<!--- dosya boyutu kontrol --->	
</cfif>
<cfif isDefined("attributes.company_video") and len(attributes.company_video)>
	<cftry>
		<cfset company_video_real_name = fileHelper.save_uploaded_file('company_video', '#upload_folder#')>
		<!---
		<cffile action="UPLOAD"
				filefield="company_video"
				destination="#upload_folder#"
				mode="777"
				nameconflict="MAKEUNIQUE">
			<cfset video_file_name = createUUID()>
			<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##video_file_name#.#cffile.serverfileext#">
			<cfset attributes.company_video = '#video_file_name#.#cffile.serverfileext#'>
			<cfset company_video_real_name = cffile.serverfile>
		--->
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'>!");
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
	<!--- dosya boyutu kontrol --->
	<cfif get_file_size_comp.is_file_size>
		<cfquery name="get_file_size" datasource="#dsn#">
			SELECT FORMAT_SYMBOL,FORMAT_SIZE FROM SETUP_FILE_FORMAT WHERE FORMAT_SYMBOL='#listlast(cffile.serverfile,'.')#'
		</cfquery>
		<cfif fileHelper.remove_exceed_file(get_file_size.format_size, "#upload_folder##attributes.company_video#") eq "1">
			<script type="text/javascript">
				alert('Logo ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
			</script>
			<cfabort>
		</cfif>
		<!---
		<cfif get_file_size.recordcount and len(get_file_size.format_size)>
			<cfset dt_size=get_file_size.format_size * 1048576>
			<cfif INT(dt_size) lte INT(filesize)>
				<cfif FileExists("#upload_folder##attributes.company_video#")>
					<cffile action="delete" file="#upload_folder##attributes.company_video#">
				</cfif>
				 <script type="text/javascript">
					alert('Video ' + <cfoutput>#get_file_size.format_size#</cfoutput> + ' MB dan fazla olmamalıdır.');
					history.back();
				</script>
				<cfabort>
			</cfif>
		</cfif>
		--->
	</cfif>
	<!--- dosya boyutu kontrol --->	
</cfif>

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfif isdefined('attributes.is_status')><cfset attributes.is_status = 1><cfelse><cfset attributes.is_status = 0></cfif>
		<cfif isdefined('attributes.not_want_email')><cfset attributes.not_want_email = 1><cfelse><cfset attributes.not_want_email = 0></cfif>
		<cfif isdefined('attributes.is_potential')><cfset attributes.is_potential = 1><cfelse><cfset attributes.is_potential = 0></cfif>
		<cfif isdefined('attributes.is_related_company')><cfset attributes.is_related_company = 1><cfelse><cfset attributes.is_related_company = 0></cfif>
        <cfparam name="attributes.company_detail_eng" default="">
        <cfparam name="attributes.company_detail_spa" default="">
        <cfif isdefined ("session_base.language")>
        	<cfif session_base.language eq "eng">
				<cfset attributes.company_detail_eng = attributes.company_detail>
                <cfset attributes.company_detail = "" >
            <cfelseif session_base.language eq "spa">
				<cfset attributes.company_detail_spa = attributes.company_detail>
                <cfset attributes.company_detail = "" >
            </cfif>
        </cfif>
		
		<cfif isdefined('attributes.firm_type') and len(attributes.firm_type)><cfset firm_type = attributes.firm_type><cfelse><cfset firm_type = ''></cfif>
		<cfif isdefined('attributes.product_category') and len(attributes.product_category)><cfset product_category = attributes.product_category><cfelse><cfset product_category = ''></cfif>
		<cfset cmp = objectResolver.ResolveByRequest("#addonNS#.components.companies.member") />
		<cfset cmp.addCompany(
				wrk_id:wrk_id,
				is_potential:attributes.is_potential,
				is_status:attributes.is_status,
				process_stage:attributes.process_stage,
				companycat_id:attributes.companycat_id,
				nickname:attributes.nickname,
				fullname:attributes.fullname,
				vd:attributes.taxoffice,
				vno:attributes.taxno,
				company_email:attributes.email,
				homepage:attributes.homepage,
				telcod:attributes.company_telcode,
				tel1:attributes.company_tel1,
				tel2:attributes.company_tel2,
				tel3:attributes.company_tel3,
				fax:attributes.company_fax,
				mobilcat_id:attributes.mobilcat_id,
				mobiltel:attributes.mobiltel,
				postcod:attributes.company_postcode,
				adres:attributes.company_address,
				county_id:attributes.county_id,
				city_id:attributes.city_id,
				country:attributes.country,
				semt:attributes.semt,
				company_sector:attributes.company_sector,
				asset1:attributes.asset1,
				name:attributes.name,
				soyad:attributes.soyad,
				title:attributes.title,
				sex:attributes.sex,
				department:attributes.department,
				company_partner_email:attributes.company_partner_email,
				password:pass,
				mobilcat_id_partner:attributes.mobilcat_id_partner,
				mobiltel_partner:attributes.mobiltel_partner,
				mission:attributes.mission,
				tel_local:attributes.tel_local,
				firm_type:firm_type,
				tc_identity:attributes.tc_identity,
				company_detail:attributes.company_detail,
				company_detail_eng:attributes.company_detail_eng,
				company_detail_spa:attributes.company_detail_spa,
				product_category:product_category,
				organization_start_date:attributes.organization_start_date,
				ozel_kod:attributes.password,
				not_want_email:attributes.not_want_email,
				is_related_company:attributes.is_related_company
			) />
            
		<cfquery name="GET_MAX" datasource="#DSN#">
			SELECT MAX(COMPANY_ID) AS MAX_COMPANY FROM COMPANY WHERE WRK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">
		</cfquery>

		<cfquery name="GET_MAX_PARTNER" datasource="#DSN#">
			SELECT MAX(PARTNER_ID) AS MAX_PART FROM COMPANY_PARTNER
		</cfquery>
		
		<!--- Adres Defteri --->
		<cf_addressbook
			design		= "1"
			type		= "2"
			type_id		= "#get_max_partner.max_part#"
			active		= "1"
			name		= "#attributes.name#"
			surname		= "#attributes.soyad#"
			sector_id	= "#attributes.company_sector#"
			company_name= "#attributes.fullname#"
			title		= "#attributes.title#"
			email		= "#attributes.company_partner_email#"
			telcode		= "#attributes.company_telcode#"
			telno		= "#attributes.company_tel1#"
			faxno		= "#attributes.company_fax#"
			mobilcode	= "#attributes.mobilcat_id#"
			mobilno		= "#attributes.mobiltel#"
			web			= "#attributes.homepage#"
			postcode	= "#attributes.company_postcode#"
			address		= "#wrk_eval('attributes.company_address')#"
			semt		= "#attributes.semt#"
			county_id	= "#attributes.county_id#"
			city_id		= "#attributes.city_id#"
			country_id	= "#attributes.country#">
		
		<cfif isdefined('attributes.company_video') and len(attributes.company_video)>
			<cfset objectResolver.ResolveByRequest("#addonNS#.components.Common.asset").addAsset(
				action_id:GET_MAX.max_company,
				action_section:'COMPANY_ID',
				asset_cat_id:-9,
				file_name:attributes.company_video,
				file_real_name:company_video_real_name,
				asset_name:attributes.fullname
			) />
		</cfif>
		<cfif isdefined("session.ep")>
			<!---<cf_workcube_user_friendly user_friendly_url='#left(attributes.fullname,20)#' action_type='COMPANY_ID' action_id='#get_max.max_company#' action_page='#listgetat(attributes.fuseaction,1,'.')#.detail_company&company_id=#get_max.max_company#'>--->
			<cf_workcube_process 
				is_upd='1' 
				old_process_line='0'
				process_stage='#attributes.process_stage#' 
				record_member='#session.ep.userid#' 
				record_date='#now()#' 
				action_table='COMPANY'
				action_column='COMPANY_ID'
				action_id='#get_max.max_company#'
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_company&cpid=#get_max.max_company#' 
				warning_description = 'Kurumsal Üye : #attributes.fullname#'>
		<cfelse>
			<cf_workcube_process 
				is_upd='1' 
				old_process_line='0'
				process_stage='#attributes.process_stage#' 
				record_member='#GET_MAX_PARTNER.MAX_PART#'
				record_date='#now()#' 
				action_table='COMPANY_PARTNER'
				action_column='PARTNER_ID'
				action_id='#get_max.max_company#'
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_company&cpid=#get_max.max_company#' 
				warning_description = 'Kurumsal Üye : #attributes.fullname#'>
		</cfif>
	</cftransaction>
</cflock>
<!---Ek Bilgiler--->
<!--- my_result nesnesi tanımsız referansı bulunamadı sorulacak!
<cfset attributes.info_id = my_result.IDENTITYCOL>
<cfset attributes.is_upd = 0>
<cfset attributes.info_type_id = -1>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
--->
<!---Ek Bilgiler--->

<cfif isdefined('attributes.type_') and attributes.type_ eq 1>
	<script language="javascript">
		alert('Üyelik kaydınız başarı ile tamamlanmıştır. En kısa zamanda tarafınıza dönülecektir.');
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.welcome</cfoutput>';
	</script>
<cfelse>
	<script type="text/javascript">
	<cfoutput>
	document.location.href = "#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['det']['fuseaction']##get_max.max_company#&pid=#get_max_partner.MAX_PART#";
	</cfoutput>
	</script>
</cfif>
