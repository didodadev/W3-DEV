<!--- File: upd_company.cfm
    Author: Botan Kaygan -  Canan Ebret 
    Date: 11.10.2019
    Controller: -
    Description: Kurumsal hesaplar güncelleme sayfası, sorguları member_company.cfc dosyasına tasındı.​
 --->
<!--- company tablosundaki pos_code alani crm de kullanildigi icin kaldirilmamistir 
	  burada artik position_code workgroup_emp_par dan cekilmektedir FB 20070528--->
<cfif isdefined("attributes.startdate") and len(attributes.startdate)><cf_date tarih='attributes.startdate'></cfif>
<cfif isdefined("attributes.organization_start_date") and len(attributes.organization_start_date)><cf_date tarih='attributes.organization_start_date'></cfif>
<cfset list="',"",\n,#Chr(13)#,#Chr(10)#"> <!--- Newline karakterlerinin database e yazılmaması için eklenmiştir. --->
<cfset list2=" , , , ">
<cfset attributes.nickname = replacelist(attributes.nickname,list,list2)>
<cfset attributes.fullname=replacelist(attributes.fullname,list,list2)>
<cfset attributes.ozel_kod=replacelist(attributes.ozel_kod,list,list2)>
<cfset attributes.ozel_kod_1=replacelist(attributes.ozel_kod_1,list,list2)>
<cfset attributes.ozel_kod_2=replacelist(attributes.ozel_kod_2,list,list2)>
<cfset attributes.company_address=replacelist(attributes.company_address,list,list2)>
<cfset attributes.nickname = trim(attributes.nickname)>
<cfset attributes.fullname = trim(attributes.fullname)>
<cfset attributes.ozel_kod = trim(attributes.ozel_kod)>
<cfset attributes.ozel_kod_1 = trim(attributes.ozel_kod_1)>
<cfset attributes.ozel_kod_2 = trim(attributes.ozel_kod_2)>
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfset GET_ASSET_COMPANY = company_cmp.GET_ASSET_COMPANY(company_id:attributes.company_id)>
<cfset upload_folder = "#upload_folder#member#dir_seperator#">
<!--- Dis Gorunus Sil --->
<cfif isDefined("attributes.del_asset1") or len(attributes.asset1)>		
	<cfset UPD_ASSET1_NULL = company_cmp.UPD_ASSET1(company_id:attributes.company_id)>
	<cf_del_server_file output_file="member/#get_asset_company.asset_file_name1#" output_server="#get_asset_company.asset_file_name1_server_id#">
</cfif>
<!--- Kroki Sil --->
<cfif isdefined("attributes.del_asset2") or len(attributes.asset2)>
	<cfset UPD_ASSET2 = company_cmp.UPD_ASSET2(company_id:attributes.company_id)>
	<cf_del_server_file output_file="member/#get_asset_company.asset_file_name2#" output_server="#get_asset_company.asset_file_name2_server_id#">
</cfif>
<!--- Dis Gorunus Ekle --->
<cfif isdefined("attributes.asset1") and LEN(attributes.asset1)>
	<cftry>
		<cffile action = "upload" filefield = "asset1" destination = "#upload_folder#" nameconflict = "MakeUnique" mode="777">
		<cfset file_name1 = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name1#.#cffile.serverfileext#">
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##file_name1#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset UPD_ASSET1_VALUE = company_cmp.UPD_ASSET1(company_id:attributes.company_id, file_name:'#file_name1#.#cffile.serverfileext#', server_id:fusebox.server_machine)>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang no='533.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz !'>");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>
<!--- Kroki Ekle --->
<cfif isdefined("attributes.asset2") and LEN(attributes.asset2)>
	<cftry>
		<cffile action = "upload" filefield = "asset2" destination = "#upload_folder#" nameconflict = "MakeUnique" mode="777">
		<cfset file_name2 = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name2#.#cffile.serverfileext#">
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##file_name2#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset UPD_ASSET2_VALUE = company_cmp.UPD_ASSET2(company_id:attributes.company_id, file_name:'#file_name2#.#cffile.serverfileext#', server_id:fusebox.server_machine)>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang no='533.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz !'>");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>
<cfif isDefined("attributes.member_code") and len(attributes.member_code)>
	<cfset GET_COMPANY_CODE = company_cmp.GET_COMPANY_CODE(company_id:attributes.company_id, company_code:trim(attributes.member_code))>
	<cfif get_company_code.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no ='569.Üye Kodu'> <cf_get_lang_main no='781.tekrarı'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfif attributes.x_is_off_same_records eq 0>
	<!--- sirket unvanı ve kısa unvanı kontrolü  --->
	<cfset GET_COMP = company_cmp.GET_COMP_NAME_CONTROL(company_id:attributes.company_id, fullname:attributes.fullname, nickname:attributes.nickname)>
    <cfif get_comp.recordcount>
        <script type="text/javascript">
            alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no ='176.şirket ünvanı'> <cf_get_lang_main no='781.tekrarı'>!");
            history.back();
        </script>
        <cfabort>
    </cfif>

	<cfif len(attributes.user_friendly_url)>
        <cf_workcube_user_friendly user_friendly_url='#attributes.user_friendly_url#' action_type='COMPANY_ID' action_id='#attributes.company_id#' action_page='member.form_list_company&event=det&cpid=#attributes.company_id#'>
	<cfelse>
	    <cfif attributes.is_auto_fill eq 1>
	        <cf_workcube_user_friendly user_friendly_url='#left(attributes.nickname,250)#' action_type='COMPANY_ID' action_id='#attributes.company_id#' action_page='member.form_list_company&event=det&cpid=#attributes.company_id#'>
		<cfelse>
			<cfset DEL_USER_FRIENDLY = company_cmp.DEL_USER_FRIENDLY(company_id:attributes.company_id)>       
        </cfif>    
    </cfif>
</cfif>
<cfscript>
	structdelete(form,"account_code");
	structdelete(form,"hierarcy_company");
</cfscript> 
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<!--- History - Belirtilen kosullarda degisiklik varsa history ye kayit atiyor FBS 20080409 --->
		<cfset hist_cont = company_cmp.hist_cont(wg_company_id:company_id, company_id:attributes.company_id)>
	    <cfset upd_company = company_cmp.upd_company(
				process_stage :'#iIf(isdefined('attributes.process_stage'),"attributes.process_stage",DE(""))#', 
				member_code :'#iIf(isdefined('attributes.member_code'),"attributes.member_code",DE(""))#', 
				company_status:'#iIf(isdefined("attributes.company_status"),DE(1),DE(0))#',
				companycat_id : '#iIf(isdefined('attributes.companycat_id'),"attributes.companycat_id",DE(""))#', 
				period_id :'#iIf(isdefined('attributes.period_id') and len(attributes.period_id),"attributes.period_id",DE(""))#', 
				manager_partner_id :'#iIf(isdefined('attributes.manager_partner_id') and len(attributes.manager_partner_id),"attributes.manager_partner_id",DE(""))#',
				fullname : wrk_eval('fullname'),
				company_size_cat_id : '#iIf(isdefined('attributes.company_size_cat_id') and len(attributes.company_size_cat_id),"attributes.company_size_cat_id",DE(""))#', 
				customer_value : '#iIf(isdefined("attributes.customer_value") and len(attributes.customer_value),"attributes.customer_value",DE(""))#', 
				taxoffice :	'#iIf(isdefined("attributes.taxoffice") and len(attributes.taxoffice),"attributes.taxoffice",DE(""))#',
				taxno : '#iIf(isdefined("attributes.taxno") and len(attributes.taxno),"attributes.taxno",DE(""))#',
				company_email : '#iIf(isdefined("attributes.company_email") and len(attributes.company_email),"attributes.company_email",DE(""))#',
				company_kep_address : '#iIf(isdefined("attributes.company_kep_address") and len(attributes.company_kep_address),"attributes.company_kep_address",DE(""))#',
				homepage :'#iIf(isdefined("attributes.homepage") and len(attributes.homepage),"attributes.homepage",DE(""))#',
				company_telcode : '#iIf(isdefined('attributes.company_telcode') and len(attributes.company_telcode),"attributes.company_telcode",DE(""))#',
				company_tel1 : '#iIf(isdefined('attributes.company_tel1') and len(attributes.company_tel1),"attributes.company_tel1",DE(""))#',
				company_tel2 : '#iIf(isdefined('attributes.company_tel2') and len(attributes.company_tel2),"attributes.company_tel2",DE(""))#',
				company_tel3 : '#iIf(isdefined('attributes.company_tel3') and len(attributes.company_tel3),"attributes.company_tel3",DE(""))#',
				company_fax : '#iIf(isdefined('attributes.company_fax') and len(attributes.company_fax),"attributes.company_fax",DE(""))#',
				mobilcat_id : '#iIf(isdefined('attributes.mobilcat_id') and len(attributes.mobilcat_id),"attributes.mobilcat_id",DE(""))#', 
				mobiltel : '#iIf(isdefined('attributes.mobiltel') and len(attributes.mobiltel),"attributes.mobiltel",DE(""))#',
				company_postcode : '#iIf(isdefined('attributes.company_postcode') and len(attributes.company_postcode),"attributes.company_postcode",DE(""))#',  
				company_address :'#iIf(isdefined('attributes.company_address') and len(attributes.company_address),"wrk_eval('company_address')",DE(""))#', 
				district_id : '#iIf(isdefined('attributes.district_id') and len(attributes.district_id),"attributes.district_id",DE(""))#', 
				county_id : '#iIf(len(attributes.county_id),"attributes.county_id",DE(""))#',
				city_id : '#iIf(len(attributes.city_id),"attributes.city_id",DE(""))#',
				country : '#iIf(isdefined('attributes.country') and len(attributes.country),"attributes.country",DE(""))#',
				watalogy_code : '#iIf(isdefined('attributes.watalogy_code') and len(attributes.watalogy_code),"attributes.watalogy_code",DE(""))#',
				ispotantial : '#iIf(isdefined('attributes.ispotantial') and len(attributes.ispotantial),"attributes.ispotantial",DE(""))#',
				hierarchy_id : '#iIf(isdefined('attributes.hierarchy_id') and len(attributes.hierarchy_id) ,"attributes.hierarchy_id",DE(""))#',
				sales_county : '#iIf(isdefined('attributes.sales_county') and len(attributes.sales_county),"attributes.sales_county",DE(""))#',
				is_buyer : '#iIf(isdefined('attributes.is_buyer') and len(attributes.is_buyer),"attributes.is_buyer",DE(""))#', 
				is_seller : '#iIf(isdefined('attributes.is_seller') and len(attributes.is_seller),"attributes.is_seller",DE(""))#',
				is_related_company : '#iIf(isdefined('attributes.is_related_company') and len(attributes.is_related_company),"attributes.is_related_company",DE(""))#', 
				resource : '#iIf(isdefined('attributes.resource') and len(attributes.resource),"attributes.resource",DE(""))#',
				ozel_kod : '#iIf(isdefined('attributes.ozel_kod'),"attributes.ozel_kod",DE(""))#', 
				ozel_kod_1 :'#iIf(isdefined('attributes.ozel_kod_1'),"attributes.ozel_kod_1",DE(""))#',  
				ozel_kod_2 :'#iIf(isdefined('attributes.ozel_kod_2'),"attributes.ozel_kod_2",DE(""))#',  
				nickname : '#iIf(isdefined('attributes.nickname') and len(attributes.nickname),"wrk_eval('nickname')",DE(""))#',
				startdate : '#iIf(isdefined('attributes.startdate') and len(attributes.startdate),"attributes.startdate",DE(""))#', 
				organization_start_date : '#iIf(isdefined('attributes.organization_start_date') and len(attributes.organization_start_date),"attributes.organization_start_date",DE(""))#', 
				our_company_id : '#iIf(isdefined('attributes.our_company_id') and len(attributes.our_company_id),"attributes.our_company_id",DE(""))#',
				ims_code_id : '#iIf(isdefined('attributes.ims_code_name') and len(attributes.ims_code_id),"attributes.ims_code_id",DE(""))#',
				POS_CODE : '#iIf(isdefined('attributes.POS_CODE') and len(attributes.POS_CODE),"attributes.POS_CODE",DE(""))#',
				semt :  '#iIf(isdefined('attributes.semt') and len(attributes.semt),"attributes.semt",DE(""))#',
				member_add_option_id : '#iIf(isdefined('attributes.member_add_option_id') and len(attributes.member_add_option_id),"attributes.member_add_option_id",DE(""))#',
				glncode : '#iIf(isdefined('attributes.glncode') and len(attributes.glncode),"attributes.glncode",DE(""))#',
				coordinate_1 : '#iIf(isdefined('attributes.coordinate_1') and len(attributes.coordinate_1),"attributes.coordinate_1",DE(""))#',
				coordinate_2 : '#iIf(isdefined('attributes.coordinate_2') and len(attributes.coordinate_2),"attributes.coordinate_2",DE(""))#',
				camp_id :  '#iIf(isdefined('attributes.camp_name') and len(attributes.camp_name) and isdefined('attributes.camp_id') and len(attributes.camp_id) ,"attributes.camp_id",DE(""))#',
				firm_type : '#iIf(isdefined('attributes.firm_type') and len(attributes.firm_type),"attributes.firm_type",DE(""))#',
				company_rate : '#iIf(isdefined('attributes.company_rate') and len(attributes.company_rate),"attributes.company_rate",DE(""))#',
				is_export : '#iIf(isdefined('attributes.is_export'),DE(1),DE(0))#', 
				visit_cat_id : '#iIf(isdefined('attributes.visit_cat_id') and len(attributes.visit_cat_id),"attributes.visit_cat_id",DE(""))#',
				profile_id : '#iIf(isdefined('attributes.profile_id') and len(attributes.profile_id),"attributes.profile_id",DE(""))#',
				is_person : '#iIf(isdefined('attributes.is_person'),"attributes.is_person",DE(""))#',
				earchive_sending_type : '#iIf(isdefined('attributes.earchive_sending_type') and len(attributes.earchive_sending_type),"attributes.earchive_sending_type",DE(""))#',
				company_id : attributes.company_id,
				is_civil : '#iIf(isdefined("attributes.is_civil"),DE(1),DE(0))#'
			)>
        <cf_wrk_get_history  datasource='#DSN#' source_table= 'COMPANY' target_table= 'COMPANY_HISTORY' record_id= '#attributes.company_id#' record_name='COMPANY_ID'>
		<!--- Tüm Çalışan Adresleri Güncellensin --->
		<cfif attributes.xml_upd_par_address eq 1 and isdefined('attributes.upd_par_address')>
			<cfset GET_COMP_ADDRESS = company_cmp.GET_COMP_ADDRESS(company_id:attributes.company_id)>
			<cfset UPD_COMP_PAR_ADDRESS = company_cmp.UPD_COMP_PAR_ADDRESS(
										company_postcode:'#iIf(isdefined('attributes.company_postcode') and len(attributes.company_postcode),"get_comp_address.company_postcode",DE(""))#',
										company_address:'#iIf(isdefined('attributes.company_address') and len(attributes.company_address),"get_comp_address.company_address",DE(""))#',
										city:'#iIf(isdefined('attributes.city') and len(attributes.city),"get_comp_address.city",DE(""))#' ,
										county:'#iIf(isdefined('attributes.county') and len(attributes.county),"get_comp_address.county",DE(""))#',
										country:'#iIf(isdefined('attributes.country') and len(attributes.country),"get_comp_address.country",DE(""))#',
										semt:'#iIf(isdefined('attributes.semt') and len(attributes.semt),"get_comp_address.semt",DE(""))#',
										company_id:attributes.company_id
                                    )>
		</cfif>
		<!---// Tüm Çalışan Adresleri Güncellensin --->
        
		<!--- İliskili Markalar Guncellensin --->
		<cfif isdefined("attributes.related_brand_id") and len(attributes.related_brand_id)>
			<cfset del_member_product_cat = company_cmp.del_member_product_cat( company_id:attributes.company_id)>
			<cfloop list="#attributes.related_brand_id#" index="i">
				<cfset add_related_brands = company_cmp.add_related_brands(brand_id:i, company_id:attributes.company_id)>
			</cfloop>
		</cfif>
		<!---// İliskili Markalar Guncellensin --->
        <!--- ihracat yapiliyor ise ihracat yaptigi ulkeleri tutuyor --->
        <cfif isdefined("attributes.is_export")>
			<cfset del_member_product_cat = company_cmp.del_member_product_cat_export( company_id:attributes.company_id)>
            <cfif isdefined("attributes.export_countries") and len (attributes.export_countries)>
				<cfloop list="#attributes.export_countries#" index="f">
					<cfset ADD_RELATION_EXPORT_COUNTRIES = company_cmp.ADD_RELATION_EXPORT_COUNTRIES(country_id:f, company_id:attributes.company_id)>
				</cfloop>
            </cfif>
		</cfif>
		<cfset UPD_ADDRESSBOOK = company_cmp.UPD_ADDRESSBOOK(
											 company_id:attributes.company_id,
											 company_status : '#iIf(isdefined('attributes.company_status'),"attributes.company_status",DE(""))#'										 
											 )>
		<!--- Kurumsal uye temsilcisinin degismesi durumunda uye ekibine is_master olarak uye atiliyor --->
		<cfif len(attributes.company_id) and len(attributes.pos_code) and (attributes.pos_code neq attributes.old_pos_code)>
			<cfset get_workgroup_master = company_cmp.GET_WORKGROUP_MASTER( company_id:attributes.company_id)>
			<cfif get_workgroup_master.recordcount>
				<cfset UPD_IS_MASTER = company_cmp.UPD_IS_MASTER( company_id:attributes.company_id)>
			</cfif> 
			<cfset ADD_WORK_MEMBER = company_cmp.ADD_WORK_MEMBER( company_id:attributes.company_id,pos_code:attributes.pos_code)>
		</cfif>
		<!--- temsilci alani bosaltilinca tablodan da silinir --->
		<cfif not len(attributes.pos_code_text) and len(attributes.old_pos_code)>
			<cfset del_workgroup_emp_par = company_cmp.del_workgroup_emp_par( company_id:attributes.company_id,pos_code:attributes.pos_code)>
		</cfif>
		<!--- member of product categories --->
		<cfset del_member_product_cat = company_cmp.del_member_product_cat_worknet( company_id:attributes.company_id)>
		<cfif isdefined("attributes.product_category") and len(attributes.product_category)>
			<cfloop list="#attributes.product_category#" index="i">
				<cfset ADD_PRODUTCT_CAT = company_cmp.ADD_PRODUTCT_CAT(catid:i, company_id:attributes.company_id)>
			</cfloop>
		</cfif>
        <cfset del_member_product_cat = company_cmp.del_member_product_cat_sector( company_id:attributes.company_id)>
		<cfif  isdefined("attributes.upper_sector_cat") and len(attributes.upper_sector_cat)>
            <cfloop list="#attributes.upper_sector_cat#" index="i">
				<cfset ADD_PRODUCT_CAT = company_cmp.ADD_COMP_SECTOR(sector_id:i, company_id:attributes.company_id)>
            </cfloop>
        </cfif>
        <cfif isdefined("attributes.sector_cat_id") and len(attributes.sector_cat_id)>
            <cfloop list="#attributes.sector_cat_id#" index="i">
				<cfset ADD_COMP_SECTOR = company_cmp.ADD_COMP_SECTOR(sector_id:i, company_id:attributes.company_id)>
			</cfloop>
        </cfif>
        <cfif isdefined("attributes.tckimlikno")>
			<cfset UPD_COMP_PART_TC = company_cmp.UPD_COMP_PART_TC(tckimlikno:attributes.tckimlikno, manager_partner_id:attributes.manager_partner_id)>
        </cfif>
	</cftransaction>
</cflock>
<!--- E-Fatura mukellef mi degil mi kontrolu BK20141118 --->
<cfif session.ep.our_company_info.is_efatura>
	<cfif isDefined('attributes.tckimlikno')>
		<cfscript>
			ws = createobject("component","V16.member.cfc.CheckCustomerTaxId").CheckCustomerTaxIdMain(Action_Type:"COMPANY",Action_id:attributes.company_id,VKN:attributes.taxno,TCKN:attributes.tckimlikno);
		</cfscript>
	</cfif>
</cfif>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='#attributes.old_process_line#' 
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='COMPANY'
	action_column='COMPANY_ID'
	action_id='#attributes.company_id#'
	action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company&event=upd&cpid=#attributes.company_id#' 
	warning_description = 'Müşteri : #attributes.fullname#'>
<!---Ek Bilgiler--->
<cfset attributes.info_id =  attributes.company_id>
<cfset attributes.is_upd = 1>
<cfset attributes.info_type_id = -1>
<cfinclude template="../../objects/query/add_info_plus2.cfm">

<script type="text/javascript">		
	<cfif isdefined("attributes.type")>
		window.location.href='<cfoutput>#request.self#?fuseaction=crm.form_upd_supplier&cpid=#attributes.company_id#&type=crm</cfoutput>';
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company&event=det&cpid=#attributes.company_id#</cfoutput>';
	</cfif>
</script>
