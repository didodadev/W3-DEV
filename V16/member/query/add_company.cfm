<!--- company tablosundaki pos_code alani crm de kullanildigi icin kaldirilmamistir 
	  burada artik position_code workgroup_emp_par dan cekilmektedir FB 20070528 --->
<cf_xml_page_edit fuseact="member.form_add_company" is_multi_page="1">
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfif isdefined("attributes.startdate") and len(attributes.startdate)><cf_date tarih='attributes.startdate'></cfif>
<cfif isdefined('attributes.organization_start_date') and len(attributes.organization_start_date)><cf_date tarih='attributes.organization_start_date'></cfif>
<cfif isdefined('attributes.birthdate') and len(attributes.birthdate)><cf_date tarih='attributes.birthdate'></cfif>
<cfscript>
	list="',"",\n,#chr(10)#,#chr(13)#"; // Newline karakterlerinin database e yazılmaması için eklenmiştir.
	list2=" , , , ";
	if(isdefined("attributes.name_"))
		attributes.name=replacelist(trim(attributes.name_),list,list2); //Browserlarda name parametresi sapitiyor diye form sayfasindaki name ifadesi name_ seklinde degistirilmistir. M.E.Y 20120809
	else
		attributes.name=""; //Browserlarda name parametresi sapitiyor diye form sayfasindaki name ifadesi name_ seklinde degistirilmistir. M.E.Y 20120809
	attributes.soyad=replacelist(trim(attributes.soyad),list,list2);
	attributes.adres=replacelist(trim(attributes.adres),list,list2);
	a = "";
</cfscript>
<cfloop from="1" to="#listlen(attributes.name,' ')#" index="i">
	<cfif len(listgetat(attributes.name,i,' ')) gt 1>
		<cfset b = ucase(left(listgetat(attributes.name,i,' '),1)) & lcase(replace(right(listgetat(attributes.name,i,' '),len(listgetat(attributes.name,i,' '))-1),"İ", "I", "ALL"))>
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
<cfif isdefined('attributes.our_company_id') and len(attributes.our_company_id) and len(attributes.our_company_name)>
	<cfset GET_OUR_COMPANIES = company_cmp.GET_OUR_COMPANIES(our_company_id:attributes.our_company_id)>
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
	attributes.ozel_kod=replacelist(trim(attributes.ozel_kod),list,list2);
	attributes.ozel_kod_1=replacelist(trim(attributes.ozel_kod_1),list,list2);
	attributes.ozel_kod_2=replacelist(trim(attributes.ozel_kod_2),list,list2);
</cfscript>
<!--- dis gorunum --->
<cfset upload_folder = "#upload_folder#member#dir_seperator#">
<cfif not DirectoryExists("#upload_folder#")>
	<cfdirectory action="create" directory="#upload_folder#">
</cfif>
<cfif isDefined("attributes.asset1") and len(attributes.asset1)>
	<cftry>
		<cffile action="UPLOAD"
				filefield="asset1"
				destination="#upload_folder#"
				mode="777"
				nameconflict="MAKEUNIQUE"
				accept="image/*">
			<cfset file_name = createUUID()>
			<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
			<cfset attributes.asset1 = '#file_name#.#cffile.serverfileext#'>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>

<!--- Kroki --->
<cfif isDefined("attributes.asset2") and len(attributes.asset2)>
	<cftry>
		<cffile action="UPLOAD"
				filefield="asset2"
				destination="#upload_folder#"
				mode="777"
				nameconflict="MAKEUNIQUE"
				accept="image/*">
			<cfset file_name = createUUID()>
			<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
			<cfset attributes.asset2 = '#file_name#.#cffile.serverfileext#'>
	
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>

<!--- Uye Kodu kontrolü  --->
<cfif isDefined("attributes.company_code") and len(attributes.company_code)>
	<cfset GET_COMPANY_CODE = company_cmp.GET_COMPANY_CODE(company_code:trim(attributes.company_code))>
	<cfif get_company_code.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no ='569.Üye Kodu'> <cf_get_lang_main no='781.tekrarı'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset get_x_user_friendly = get_fuseaction_property.get_fuseaction_property(
	company_id : session.ep.company_id,
	fuseaction_name : 'member.detail_company',
	property_name : 'x_is_auto_fill_user_friendly'
	)
>
<cfif x_is_off_same_records eq 0><!--- xml ile kapatılabiliyor --->
	<!--- sirket unvanı ve kısa unvanı kontrolü  --->
	<cfset attributes.fullname = trim(attributes.fullname)>
	<cfset attributes.nickname = trim(attributes.nickname)>
	<cfset GET_COMP = company_cmp.GET_COMP_BY_NAME(fullname:attributes.fullname, nickname:attributes.nickname)>
	<cfif get_comp.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no ='176.şirket ünvanı'> <cf_get_lang_main no='781.tekrarı'> !");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfset ADD_COMPANY = company_cmp.ADD_COMPANY(
			wrk_id:wrk_id,
			process_stage:'#iIf(isdefined('attributes.process_stage'),"attributes.process_stage",DE(""))#', 
			company_status:'#iIf(isdefined("attributes.company_status"),DE(1),DE(0))#',
			companycat_id:attributes.companycat_id,
			period_id:attributes.period_id,
			our_company_id:'#iif(isdefined("attributes.our_company_id") and len(attributes.our_company_id) and len(attributes.our_company_name),"attributes.our_company_id",DE(""))#',
			our_company_name:'#iif(isdefined("attributes.our_company_id") and len(attributes.our_company_id) and len(attributes.our_company_name),"attributes.our_company_name",DE(""))#',
			company_code:'#iIf(len(attributes.company_code),"trim(attributes.company_code)",DE(""))#',
			hierarchy_id:'#iIf(isdefined('attributes.hierarchy_id') and len(attributes.hierarchy_id),"attributes.hierarchy_id",DE(""))#',
			nickname:'#iIf(isdefined('attributes.nickname'),"wrk_eval('attributes.nickname')",DE(""))#',  
			fullname:wrk_eval('attributes.fullname'),
			taxoffice: '#iIf(isdefined('attributes.taxoffice'),"attributes.taxoffice",DE(""))#', 
			taxno:'#iIf(isdefined('attributes.taxno'),"attributes.taxno",DE(""))#',
			email:'#iIf(isdefined('attributes.email'),"trim(attributes.email)",DE(""))#',  
			kep_address:'#iIf(isDefined("attributes.kep_address") and len(attributes.kep_address),"trim(attributes.kep_address)",DE(""))#',
			homepage:'#iIf(isdefined('attributes.homepage'),"trim(attributes.homepage)",DE(""))#',   
			telcod:'#iIf(isdefined('attributes.telcod'),"attributes.telcod",DE(""))#', 
			tel1:'#iIf(isdefined('attributes.tel1'),"attributes.tel1",DE(""))#',
			tel2:'#iIf(isdefined('attributes.tel2'),"attributes.tel2",DE(""))#', 
			tel3:'#iIf(isdefined('attributes.tel3'),"attributes.tel3",DE(""))#', 
			fax: '#iIf(isdefined('attributes.fax'),"attributes.fax",DE(""))#',
			mobilcat_id:'#iIf(isdefined('attributes.mobilcat_id') and len(attributes.mobilcat_id),"attributes.mobilcat_id",DE(""))#',
			mobiltel:'#iIf( isdefined('mobiltel') and len(attributes.mobiltel),"attributes.mobiltel",DE(""))#',
			postcod:'#iIf(isdefined('attributes.postcod'),"attributes.postcod",DE(""))#',  
			adres:'#iIf(isdefined('attributes.adres'),"wrk_eval('attributes.adres')",DE(""))#',   
			district_id:'#iIf(isdefined("attributes.district_id") and Len(attributes.district_id),"attributes.district_id",DE(""))#',
			county_id:'#iIf(isdefined("attributes.county_id") and Len(attributes.county_id),"attributes.county_id",DE(""))#',
			city_id:'#iIf(isdefined("attributes.city_id") and Len(attributes.city_id),"attributes.city_id",DE(""))#',
			country:'#iIf(isdefined("attributes.country") and Len(attributes.country),"attributes.country",DE(""))#',
			userid:session.ep.userid,
			remote_addr:cgi.remote_addr,
			ispotantial:'#iIf(isdefined("attributes.ispotantial"),DE(1),DE(0))#',
			company_size_cat_id:'#iIf(isdefined('attributes.company_size_cat_id') and len(attributes.company_size_cat_id),"attributes.company_size_cat_id",DE(""))#',
			sales_county:'#iIf(isdefined('attributes.sales_county') and len(attributes.sales_county),"attributes.sales_county",DE(""))#',
			is_seller:'#iIf(isdefined("is_seller"),DE(1),DE(0))#',
			is_buyer:'#iIf(isdefined("is_buyer"),DE(1),DE(0))#',
			resource:'#iIf(isdefined('attributes.resource') and len(attributes.resource),"attributes.resource",DE(""))#',
			company_rate:'#iIf(isdefined('attributes.company_rate') and len(attributes.company_rate),"attributes.company_rate",DE(""))#',
			customer_value:'#iIf(isdefined('attributes.customer_value') and len(attributes.customer_value),"attributes.customer_value",DE(""))#',
			glncode:'#iIf(isdefined('attributes.glncode') and len(attributes.glncode),"attributes.glncode",DE(""))#',
			asset1:'#iIf(isdefined('attributes.asset1') and len(attributes.asset1),"attributes.asset1",DE(""))#',
			server_machine:'#iIf(isdefined('attributes.asset1') and len(attributes.asset1),"fusebox.server_machine",DE(""))#',
			asset2:'#iIf(isdefined('attributes.asset2') and len(attributes.asset2),"attributes.asset2",DE(""))#',
			server_machine:'#iIf(isdefined('attributes.asset2') and len(attributes.asset2),"fusebox.server_machine",DE(""))#',
			record_date:now(),
			startdate:'#iIf(isdefined('attributes.startdate') and len(attributes.startdate),"attributes.startdate",DE(""))#',
			organization_start_date:'#iIf(isdefined('attributes.organization_start_date') and len(attributes.organization_start_date),"attributes.organization_start_date",DE(""))#',
			ims_code_id:'#iIf(isdefined('attributes.ims_code_id') and len(attributes.ims_code_id),"attributes.ims_code_id",DE(""))#',
			semt:'#iIf(isdefined('attributes.semt'),"attributes.semt",DE(""))#',    
			ozel_kod:'#iIf(isdefined('attributes.ozel_kod'),"attributes.ozel_kod",DE(""))#',   
			ozel_kod_1: '#iIf(isdefined('attributes.ozel_kod_1'),"attributes.ozel_kod_1",DE(""))#',  
			ozel_kod_2: '#iIf(isdefined('attributes.ozel_kod_2'),"attributes.ozel_kod_2",DE(""))#',
			is_related_company:'#iIf(isdefined("attributes.is_related_company"),DE(1),DE(0))#',
			member_add_option_id:'#iIf(isdefined('attributes.member_add_option_id') and len(attributes.member_add_option_id),"attributes.member_add_option_id",DE(""))#',
			coordinate_1:'#iIf(isdefined('attributes.coordinate_1') and len(attributes.coordinate_1),"attributes.coordinate_1",DE(""))#',
			coordinate_2:'#iIf(isdefined('attributes.coordinate_2') and len(attributes.coordinate_2),"attributes.coordinate_2",DE(""))#',
			camp_id:'#iIf(isdefined('attributes.camp_name') and len(attributes.camp_name) and isdefined('attributes.camp_id') and Len(attributes.camp_id),"attributes.camp_id",DE(""))#',
			firm_type:'#iIf(isdefined('attributes.firm_type') and len(attributes.firm_type),"attributes.firm_type",DE(""))#',
			is_export:'#iIf(isdefined('attributes.is_export'),DE(1),DE(0))#',
			visit_cat_id:'#iIf(isdefined('attributes.visit_cat_id') and len(attributes.visit_cat_id),"visit_cat_id",DE(""))#',
			is_person:'#iIf(isdefined('attributes.is_person'),DE(1),DE(0))#',
			profile_id:'#iIf(isdefined('attributes.profile_id') and len(attributes.profile_id),"profile_id",DE(""))#',
			use_earchive:'#iIf(isdefined('attributes.use_earchive'),DE(1),DE(0))#',
			is_civil:'#iIf(isdefined("attributes.is_civil"),DE(1),DE(0))#'
		)>
        <cfset get_max.max_company = ADD_COMPANY.MAX_COMPANY>
		<!--- Kurumsal uye ekibine temsilci is_master olarak atiliyor --->
		<cfif isdefined('attributes.pos_code') and len(attributes.pos_code)>
			<cfset ADD_WORKGROUP_MEMBER = company_cmp.ADD_WORKGROUP_MEMBER(
				company_id:get_max.max_company,
				pos_code:attributes.pos_code
			)>
		</cfif>
		<cfset ADD_COMP_PERIOD = company_cmp.ADD_COMP_PERIOD(
			company_id:get_max.max_company,
			period_id:attributes.period_id
		)>

		<cfset ADD_PARTNER = company_cmp.ADD_PARTNER(
			company_id:get_max.max_company,
			name:'#iIf(isdefined('attributes.name'),"attributes.name",DE(""))#',
			soyad:'#iIf(isdefined('attributes.soyad'),"attributes.soyad",DE(""))#',
			company_partner_status:'#iIf(isdefined('attributes.company_partner_status'),"attributes.company_partner_status",DE(""))#',
			title:'#iIf(isdefined('attributes.title'),"attributes.title",DE(""))#',
			sex:'#iIf(isdefined('attributes.sex'),"attributes.sex",DE(""))#',
			department:'#iIf(isdefined('attributes.department') and len(attributes.department),"attributes.department",DE(""))#',
			company_partner_email:'#iIf(isdefined('attributes.company_partner_email'),"attributes.company_partner_email",DE(""))#',
			mobilcat_id_partner:'#iIf(isdefined('attributes.mobilcat_id_partner') and len(attributes.mobilcat_id_partner),"attributes.mobilcat_id_partner",DE(""))#',
			mobiltel_partner:'#iIf(isdefined('attributes.mobiltel_partner') and len(attributes.mobiltel_partner),"attributes.mobiltel_partner",DE(""))#',
			telcod:'#iIf(isdefined('attributes.telcod'),"attributes.telcod",DE(""))#',
			tel1:'#iIf(isdefined('attributes.tel1'),"attributes.tel1",DE(""))#',
			tel_local:'#iIf(isdefined('attributes.tel_local'),"attributes.tel_local",DE(""))#',
			fax: '#iIf(isdefined('attributes.fax'),"attributes.fax",DE(""))#',
			homepage:'#iIf(isdefined('attributes.homepage'),"attributes.homepage",DE(""))#',
			mission:'#iIf(isdefined('attributes.mission') and len(attributes.mission),"attributes.mission",DE(""))#',
			adres:'#iIf(isdefined('attributes.adres'),"wrk_eval('attributes.adres')",DE(""))#',
			postcod: '#iIf(isdefined('attributes.postcod'),"attributes.postcod",DE(""))#',
			county_id:'#iIf(isdefined('attributes.county_id') and len(attributes.county_id),"attributes.county_id",DE(""))#',
			city_id:'#iIf(isdefined('attributes.city_id') and len(attributes.city_id),"attributes.city_id",DE(""))#',
			country:'#iIf(isdefined('attributes.country') and len(attributes.country),"attributes.country",DE(""))#',
			semt:'#iIf(isdefined('attributes.semt'),"attributes.semt",DE(""))#',
			tc_identity:'#iIf(isdefined('attributes.tc_identity') and len(attributes.tc_identity),"attributes.tc_identity",DE(""))#',
			birthdate:'#iIf(isdefined('attributes.birthdate') and len(attributes.birthdate),"attributes.birthdate",DE(""))#'
		)>
		<cfset GET_MAX_PARTNER = company_cmp.GET_MAX_PARTNER()>
		<cfset UPD_MEMBER_CODE = company_cmp.UPD_MEMBER_CODE(partner_id:get_max_partner.max_partner_id)>
		<cfset ADD_COMPANY_PARTNER_DETAIL = company_cmp.ADD_COMPANY_PARTNER_DETAIL(partner_id:get_max_partner.max_partner_id)>
		<cfset ADD_PART_SETTINGS = company_cmp.ADD_PART_SETTINGS(partner_id:get_max_partner.max_partner_id)>

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
		
		
		<!--- uye no kontrolü 2. kontrol gerekli kaldırmayın FA--->
		<cfset member_code_ = 'C#get_max.max_company#'>
		<cfif isdefined("attributes.company_code") and not len(attributes.company_code)>
			<cfset GET_COMPANY_CODE = company_cmp.GET_COMPANY_CODE(company_code:trim(member_code_))>
			<cfif get_company_code.recordcount>
				<cfset member_code_ = 'C#get_max.max_company#-2'>
			</cfif>
		</cfif>
		<cfset UPD_MEMBER_CODE = company_cmp.UPD_MEMBER_CODE_COMPANY(company_id:get_max.max_company, member_code:'#iIf(isdefined("attributes.company_code") and len(attributes.company_code),"trim(attributes.company_code)","member_code_")#')>
		<cfset UPD_MANAGER_PARTNER = company_cmp.UPD_MANAGER_PARTNER(company_id:get_max.max_company, partner_id:get_max_partner.max_partner_id)>
		<!--- FB 20070628 Şube sessiondan alinarak iliskilendiriliyor (crm disindakilerde) --->
		<cfif not isdefined("attributes.type")>
			<cfset GET_BRANCH_CID = company_cmp.GET_BRANCH_CID(user_location:listgetat(session.ep.user_location,2,'-'))>
			<cfset ADD_BRANCH_RELATED = company_cmp.ADD_BRANCH_RELATED(company_id:get_max.max_company, our_company_id:get_branch_cid.company_id, user_location:listgetat(session.ep.user_location,2,'-'))>
		</cfif>
        <cfif isdefined("attributes.product_category") and len(attributes.product_category)>
			<cfloop list="#attributes.product_category#" index="i">
				<cfset ADD_PRODUTCT_CAT = company_cmp.ADD_PRODUTCT_CAT(catid:i, company_id:get_max.max_company)>
			</cfloop>
		</cfif>
        <cfif isdefined("attributes.upper_sector_cat") and len(attributes.upper_sector_cat)>
            <cfloop list="#attributes.upper_sector_cat#" index="i">
				<cfset ADD_COMP_SECTOR = company_cmp.ADD_COMP_SECTOR(sector_id:i, company_id:get_max.max_company)>
            </cfloop>
        </cfif>
        
        <cfif isdefined("attributes.company_sector") and len(attributes.company_sector)>
			<cfloop list="#attributes.company_sector#" index="i">
				<cfset ADD_COMP_SECTOR = company_cmp.ADD_COMP_SECTOR(sector_id:i, company_id:get_max.max_company)>
            </cfloop>
        </cfif>
        
		<!--- İliskili Markalar Guncellensin --->
		<cfif isdefined("attributes.related_brand_id") and len(attributes.related_brand_id)>
			<cfloop list="#attributes.related_brand_id#" index="i">
				<cfset add_related_brands = company_cmp.add_related_brands(brand_id:i, company_id:get_max.max_company)>
			</cfloop>
		</cfif>
		<!---// İliskili Markalar Guncellensin --->
        <!--- ihracat yapiliyor ise ihracat yaptigi ulkeleri tutuyor --->
        <cfif isdefined("attributes.is_export") and isdefined('attributes.export_countries') and len(attributes.export_countries)>
			<cfloop list="#attributes.export_countries#" index="f">
				<cfset ADD_RELATION_EXPORT_COUNTRIES = company_cmp.ADD_RELATION_EXPORT_COUNTRIES(country_id:i, company_id:get_max.max_company)>
			</cfloop>
		</cfif>
        
		<!--- Objecst ten eklenen uyelerin uyarilarda vs update sayfasi olarak memberdan goruntulenmesi icin eklendi FBS --->
		<cfif attributes.isModule eq 'objects'>
			<cfset circuit_ = "member">
		<cfelse>
			<cfset circuit_ = listgetat(attributes.fuseaction,1,'.')>
		</cfif>
        <cfif isdefined("get_x_user_friendly.property_value") and get_x_user_friendly.property_value eq 1>
			<cf_workcube_user_friendly x_is_off_same_records="#x_is_off_same_records#" user_friendly_url='#left(attributes.fullname,250)#' action_type='COMPANY_ID' action_id='#get_max.max_company#' action_page='member.form_list_company&event=det&cpid=#get_max.max_company#'>
        </cfif>		
	<cf_workcube_process 
			is_upd='1' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='COMPANY'
			action_column='COMPANY_ID'
			action_id='#get_max.max_company#'
			action_page='#request.self#?fuseaction=#circuit_#.form_list_company&event=upd&cpid=#get_max.max_company#' 
			warning_description = 'Kurumsal Üye : #attributes.fullname#'>
	</cftransaction>
</cflock>

<!--- E-Fatura mukellef mi degil mi kontrolu BK20141118 --->
<cfif session.ep.our_company_info.is_efatura>
	<cfscript>
        ws = createobject("component","V16.member.cfc.CheckCustomerTaxId").CheckCustomerTaxIdMain(Action_Type:"COMPANY",Action_id:get_max.max_company,VKN:attributes.taxno,TCKN:attributes.tc_identity);
    </cfscript>
</cfif>

<!---Ek Bilgiler--->
<cfset attributes.info_id = get_max.max_company>
<cfset attributes.is_upd = 0>
<cfset attributes.info_type_id = -1>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->

<cfif not isDefined("attributes.fuseaction_type")><!--- fiziki varlık ilişkili kayıt --->
	<cfif isdefined("attributes.type")>
		<cflocation url="#request.self#?fuseaction=crm.form_upd_supplier&cpid=#get_max.max_company#&pid=#get_max_partner.max_partner_id#" addtoken="no">
	<cfelse>
		<cfif not isDefined("attributes.isClosed")>
			<cfif attributes.isModule is 'objects'>
				<script type="text/javascript">
					window.close();
				</script>
			<cfelse>	
				<cfif isdefined("attributes.isPopup") and len(attributes.isPopup) and attributes.isPopup eq 1>
					<script type="text/javascript">
						window.close();
					</script>
				<cfelse>
					<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company&event=upd&cpid=#get_max.max_company#&pid=#get_max_partner.max_partner_id#" addtoken="no">
				</cfif>
			</cfif>
		<cfelse>
			<cflocation url="#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#get_max.max_company#&pid=#get_max_partner.max_partner_id#" addtoken="no">
		</cfif>
	</cfif>
</cfif>
