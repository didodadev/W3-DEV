<!--- File:upd_partner.cfm
    Author: Canan Ebret <cananebret@workcube.com>
    Date: 11.10.2019
    Controller: -
    Description: Kurumsal üye çalışan güncelle  sayfası sorguları member_company.cfc dosyasına taşındı .​
 --->
 <cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
 <!---pdks_number 8 hane olacak sekilde, basina 0 eklenir, 8 haneye tamamlanir--->
 <cfif isdefined("attributes.pdks_number") and len(attributes.pdks_number)>
	 <cfset pdks_number_ = attributes.pdks_number>
	 <cfloop from="1" to="#8-len(pdks_number_)#" index="count">
		 <cfset pdks_number_ = 0&pdks_number_>
	 </cfloop>
 </cfif>
 <cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
 <cfif len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
 <cfif isdefined("attributes.birthdate") and len(attributes.birthdate)><cf_date tarih='attributes.birthdate'></cfif>
 <cfset list="\n,#Chr(13)#,#Chr(10)#"> <!--- Newline karakterlerinin database e yazılmaması için eklenmiştir. --->
 <cfset list2=" , , ">
 <cfset attributes.company_partner_address=replacelist(attributes.company_partner_address,list,list2)>
 <cfset list3="',""">
 <cfset list4=" , ">
 <cfset attributes.company_partner_name=replacelist(trim(attributes.company_partner_name),list3,list4)>
 <cfset attributes.company_partner_surname=replacelist(trim(attributes.company_partner_surname),list3,list4)>
 
 <!--- pdks no kontrol --->
 <cfif len(attributes.pdks_number)>
	 <cfset get_par_pdks_number = company_cmp.GET_HIER_PARTNER(par_pdks_number : 1, pdks_number :attributes.pdks_number, partner_id : attributes.partner_id)> 
	 <cfif get_par_pdks_number.recordcount>
		 <script type="text/javascript">
			 alert('<cfoutput>#get_par_pdks_number.COMPANY_PARTNER_NAME# #get_par_pdks_number.COMPANY_PARTNER_SURNAME# Adlı Çalışan Aynı PDKS Numarası İle Kayıtlı</cfoutput>! Lütfen Düzeltiniz!');
			 history.back();
		 </script>
		 <cfabort>
	 </cfif>
 </cfif>
 <!--- pdks no kontrol --->
 
 <cfif len(attributes.company_partner_password)>
	 <CF_CRYPTEDPASSWORD	PASSWORD='#attributes.company_partner_password#' OUTPUT='PASS' MOD=1>
 </cfif>
 <cfif (len(attributes.company_partner_username)) and (len(attributes.company_partner_password))>
	 <cfset check_username = company_cmp.GET_PARTNER_SECOND(
							 check_username : 1,
							 company_partner_username :attributes.company_partner_username,
							 company_partner_password : '#iIf(isdefined('attributes.company_partner_password') and len(attributes.company_partner_password),"PASS",DE(""))#', 
							 partner_id : attributes.partner_id
						 )> 
	 <cfif check_username.recordcount>
		 <script type="text/javascript">
			 alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='139.kullanıcı adı'>/ <cf_get_lang_main no ='140.şifre'><cf_get_lang_main no='781.tekrarı'>..");
			 window.history.go(-1);
		 </script>
	   <cfabort>
	 </cfif>
 </cfif>

 <cfif not isdefined("form.del_photo")> 	
	 <cfif len(form.photo)>		
		 <cfset file_name = createUUID()>			
		 <cffile action="UPLOAD" 
			 nameconflict="MAKEUNIQUE" 
			 destination="#upload_folder#member#dir_seperator#"					
			 filefield="photo" accept="image/jpeg, image/png, image/bmp, image/gif, image/jpg, image/x-png, image/*"> <!---  accept="image/*" --->

		 <cffile action="rename" source="#upload_folder#member#dir_seperator##cffile.serverfile#" destination="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">
		 <cfset cffile.serverfile = "#file_name#.#cffile.serverfileext#">
		 <cfset path = "#file_web_path#member#dir_seperator##CFFILE.ServerFile#">
		 <cfset upd_photo = company_cmp.UPD_PHOTO(
										 serverfile:'#iIf(isdefined('CFFILE.SERVERFILE') and len(CFFILE.SERVERFILE),"CFFILE.SERVERFILE",DE(""))#', 
										 partner_id:attributes.partner_id
										 )> 						
	 </cfif>
 <cfelse>
	 <cfset get_photo = company_cmp.GET_PARTNER_SECOND(get_photo:1 , partner_id:attributes.partner_id)> 
	 <cfif len(get_photo.photo)>
		 <cf_del_server_file output_file="member/#get_photo.photo#" output_server="#get_photo.photo_server_id#"> 		
		 <cfset UPD_PHOTO = company_cmp.UPD_PHOTO_PARTNER(partner_id:attributes.partner_id)> 
	 </cfif> 
	 <cfif len(attributes.photo)>
		 <cfset file_name = createUUID()>
		 <cffile action="UPLOAD" 
			 nameconflict="MAKEUNIQUE" 
			 destination="#upload_folder#member#dir_seperator#"
			 filefield="photo" accept="image/*">
		 <cffile action="rename"
			 source="#upload_folder#member#dir_seperator##cffile.serverfile#"
			 destination="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">
		 <cfset cffile.serverfile = #file_name#&"."&#cffile.serverfileext#>
		 <cfset path = "#upload_folder#member#dir_seperator##CFFILE.ServerFile#">
		  <cfset UPD_PHOTO = company_cmp.UPD_PHOTO_SECOND(
										  SERVERFILE: '#iIf(isdefined('CFFILE.SERVERFILE') and len(CFFILE.SERVERFILE),"CFFILE.SERVERFILE",DE(""))#',    
										  server_machine:'#iIf(isdefined('fusebox.server_machine'),"fusebox.server_machine",DE(""))#',   
										  partner_id:'#iIf(len(attributes.partner_id),"attributes.partner_id",DE(""))#'
										  )> 
	 </cfif>
 </cfif>
  <cfset UPD_PARTNER = company_cmp.UPD_PARTNER(
				 company_partner_username : '#iIf(isdefined('attributes.company_partner_username') and len(attributes.company_partner_username),"attributes.company_partner_username",DE(""))#',
				 company_partner_password : '#iIf(isdefined('attributes.company_partner_password') and len(attributes.company_partner_password),"PASS",DE(""))#', 
				 tc_identity : '#iIf(isdefined('attributes.tc_identity') and len(attributes.tc_identity),"attributes.tc_identity",DE(""))#',
				 company_partner_name : attributes.company_partner_name, 
				 company_partner_surname :attributes.company_partner_surname, 
				 company_partner_status :'#iIf(isdefined('attributes.company_partner_status') and len(company_partner_status),"company_partner_status" ,DE(""))#',
				 mission : '#iIf(isdefined('attributes.mission') and len(attributes.mission),"attributes.mission",DE(""))#',
				 department : '#iIf(isdefined('attributes.department') and len(attributes.department),"attributes.department",DE(""))#',
				 title :'#iIf(isdefined('attributes.title'),"attributes.title",DE(""))#',
				 company_partner_email :'#iIf(isdefined('attributes.company_partner_email') and len(attributes.company_partner_email),"attributes.company_partner_email",DE(""))#',
				 partner_kep_adress :'#iIf(isdefined('attributes.partner_kep_adress') and len(attributes.partner_kep_adress),"attributes.partner_kep_adress",DE(""))#',
				 sex :'#iIf(isdefined('attributes.sex'),"attributes.sex",DE(""))#',
				 imcat_id : '#iIf(isdefined('attributes.imcat_id') and len(attributes.imcat_id),"attributes.imcat_id",DE(""))#',
				 im : '#iIf(isdefined('attributes.im'),"attributes.im",DE(""))#',
				 imcat2_ID : '#iIf(isdefined('attributes.imcat2_ID') and len(attributes.imcat2_ID),"attributes.imcat2_ID",DE(""))#',
				 im2 : '#iIf(isdefined('attributes.im2'),"attributes.im2",DE(""))#', 
				 mobilcat_id : '#iIf(isdefined('attributes.mobilcat_id') and len(attributes.mobilcat_id),"attributes.mobilcat_id",DE(""))#',
				 mobiltel : '#iIf(isdefined('attributes.mobiltel') and len(attributes.mobiltel),"attributes.mobiltel",DE(""))#',
				 company_partner_telcode : '#iIf(isdefined('attributes.company_partner_telcode') and len(attributes.company_partner_telcode),"attributes.company_partner_telcode",DE(""))#',
				 company_partner_tel : '#iIf(isdefined('attributes.company_partner_tel') and len(attributes.company_partner_tel),"attributes.company_partner_tel",DE(""))#',
				 company_partner_tel_ext : '#iIf(isdefined('attributes.company_partner_tel_ext') and len(attributes.company_partner_tel_ext),"attributes.company_partner_tel_ext",DE(""))#',
				 company_partner_fax : '#iIf(isdefined('attributes.company_partner_fax') and len(attributes.company_partner_fax),"attributes.company_partner_fax",DE(""))#',
				 homepage : '#iIf(isdefined('attributes.homepage') and len(attributes.homepage),"attributes.homepage",DE(""))#',
				 language_id : '#iIf(isdefined('attributes.language_id') and len(attributes.language_id),"attributes.language_id",DE(""))#',
				 start_date : '#iIf(isdefined('attributes.start_date') and len(attributes.start_date),"attributes.start_date",DE(""))#',
				 finish_date : '#iIf(isdefined('attributes.finish_date') and len(attributes.finish_date),"attributes.finish_date",DE(""))#',
				 hier_partner_id : '#iIf(isdefined('attributes.hier_partner_id') and len(attributes.hier_partner_id),"attributes.hier_partner_id",DE(""))#',
				 pdks_number : '#iIf(len(attributes.pdks_number),"pdks_number_",DE(""))#',
				 pdks_type_id : '#iIf(isdefined('attributes.pdks_type_id') and len(attributes.pdks_type_id),"attributes.pdks_type_id",DE(""))#',
				 compbranch_id : '#iIf(isdefined('attributes.compbranch_id'),"attributes.compbranch_id",DE(""))#', 
				 company_partner_address : '#iIf(isdefined('attributes.company_partner_address'),"attributes.company_partner_address",DE(""))#',
				 company_partner_postcode : '#iIf(isdefined('attributes.company_partner_postcode'),"attributes.company_partner_postcode",DE(""))#', 
				 county_id :'#iIf(isdefined('attributes.county_id') and len(attributes.county_id),"attributes.county_id",DE(""))#',
				 city_id : '#iIf(isdefined('attributes.city_id') and len(attributes.city_id),"attributes.city_id",DE(""))#',
				 semt : '#iIf(isdefined('attributes.semt') and len(attributes.semt),"attributes.semt",DE(""))#',
				 district_id : '#iIf(isdefined('attributes.district_id') and len(attributes.district_id),"attributes.district_id",DE(""))#',
				 country : '#iIf(isdefined('attributes.country') and len(attributes.country),"attributes.country",DE(""))#',
				 serverfileext : '#iIf(isdefined('attributes.serverfileext') and len(attributes.serverfileext),"attributes.serverfileext",DE(""))#',
				 server_machine : '#iIf(isdefined('attributes.server_machine') and len(attributes.server_machine),"attributes.server_machine",DE(""))#',
				 status_id : '#iIf(isdefined('attributes.status_id') and len(attributes.status_id),"attributes.status_id",DE(""))#',
				 not_want_email : '#iIf(isdefined('attributes.not_want_email') and len(attributes.not_want_email),"attributes.not_want_email",DE(""))#',
				 not_want_sms : '#iIf(isdefined('attributes.not_want_sms') and len(attributes.not_want_sms),"attributes.not_want_sms",DE(""))#',
				 send_finance_mail : '#iIf(isdefined('attributes.send_finance_mail') and len(attributes.send_finance_mail),"attributes.send_finance_mail",DE(""))#',
				 send_earchive_mail : '#iIf(isdefined('attributes.send_earchive_mail') and len(attributes.send_earchive_mail),"attributes.send_earchive_mail",DE(""))#',
				 birthdate : '#iIf(isdefined('attributes.birthdate') and len(attributes.birthdate),"attributes.birthdate",DE(""))#',
				 partner_id : '#iIf(len(attributes.partner_id),"attributes.partner_id",DE(""))#',
				 resource : '#iIf(isdefined('attributes.resource') and len(attributes.resource),"attributes.resource",DE(""))#',
				 not_want_call : '#iIf(isdefined('attributes.not_want_call') and len(attributes.not_want_call),"attributes.not_want_call",DE(""))#'
				 )>
							 
 <!--- Iliskili Bireysel Uye Varsa Bilgiler Update Edilir FBS 20110131 --->
 <cfset GET_RELATED_CONSUMER_CONTROL = company_cmp.GET_RELATED_CONSUMER_CONTROL(partner_id:attributes.partner_id)>
 <cfif get_related_consumer_control.recordcount>
	 <cfset UPD_RELATED_CONSUMER = company_cmp.UPD_RELATED_CONSUMER(
				 company_partner_username : '#iIf(isdefined('attributes.company_partner_username') and len(attributes.company_partner_username),"attributes.company_partner_username",DE(""))#',
				 company_partner_password : '#iIf(isdefined('attributes.company_partner_password') and len(attributes.company_partner_password),"PASS",DE(""))#',
				 TC_IDENTY_NO : '#iIf(isdefined('attributes.TC_IDENTY_NO') and len(attributes.TC_IDENTY_NO),"attributes.TC_IDENTY_NO",DE(""))#',
				 company_partner_name : '#iIf(isdefined('attributes.company_partner_name') and len(attributes.company_partner_name),"attributes.company_partner_name",DE(""))#',
				 company_partner_surname : '#iIf(isdefined('attributes.company_partner_surname') and len(attributes.company_partner_surname),"attributes.company_partner_surname",DE(""))#',
				 department : '#iIf(isdefined('attributes.department') and len(attributes.department),"attributes.department",DE(""))#',
				 title : '#iIf(isdefined('attributes.title'),"attributes.title",DE(""))#',
				 company_partner_email : '#iIf(isdefined('attributes.company_partner_email') and len(attributes.company_partner_email),"attributes.company_partner_email",DE(""))#',
				 partner_kep_adress :'#iIf(isdefined('attributes.partner_kep_adress') and len(attributes.partner_kep_adress),"attributes.partner_kep_adress",DE(""))#',
				 sex : '#iIf(isdefined('attributes.sex'),"attributes.sex",DE(""))#',
				 imcat_id : '#iIf(isdefined('attributes.imcat_id') and len(attributes.imcat_id),"attributes.imcat_id",DE(""))#',
				 im : '#iIf(isdefined('attributes.im'),"attributes.im",DE(""))#',
				 mobilcat_id : '#iIf(isdefined('attributes.mobilcat_id') and len(attributes.mobilcat_id),"attributes.mobilcat_id",DE(""))#',
				 mobiltel : '#iIf(isdefined('attributes.mobiltel') and len(attributes.mobiltel),"attributes.mobiltel",DE(""))#',
				 company_partner_telcode : '#iIf(isdefined('attributes.company_partner_telcode') and len(attributes.company_partner_telcode),"attributes.company_partner_telcode",DE(""))#',
				 company_partner_tel : '#iIf(isdefined('attributes.company_partner_tel') and len(attributes.company_partner_tel),"attributes.company_partner_tel",DE(""))#',
				 company_partner_tel_ext : '#iIf(isdefined('attributes.company_partner_tel_ext') and len(attributes.company_partner_tel_ext),"attributes.company_partner_tel_ext",DE(""))#',
				 company_partner_telcode : '#iIf(isdefined('attributes.company_partner_telcode') and len(attributes.company_partner_telcode),"attributes.company_partner_telcode",DE(""))#',
				 company_partner_fax : '#iIf(isdefined('attributes.company_partner_fax') and len(attributes.company_partner_fax),"attributes.company_partner_fax",DE(""))#',
				 homepage :  '#iIf(isdefined('attributes.homepage') and len(attributes.homepage),"attributes.homepage",DE(""))#',
				 language_id : '#iIf(isdefined('attributes.language_id') and len(attributes.language_id),"attributes.language_id",DE(""))#',
				 start_date : '#iIf(isdefined('attributes.start_date') and len(attributes.mission),"attributes.start_date",DE(""))#',
				 company_partner_address :'#iIf(isdefined('attributes.company_partner_address'),"attributes.company_partner_address",DE(""))#',
				 company_partner_postcode :  '#iIf(isdefined('attributes.company_partner_postcode'),"attributes.company_partner_postcode",DE(""))#', 
				 county_id : '#iIf(isdefined('attributes.county_id') and len(attributes.county_id),"attributes.county_id",DE(""))#',
				 city_id : '#iIf(isdefined('attributes.city_id') and len(attributes.city_id),"attributes.city_id",DE(""))#',
				 semt : '#iIf(isdefined('attributes.semt') and len(attributes.semt),"attributes.semt",DE(""))#',
				 country : '#iIf(isdefined('attributes.country') and len(attributes.country),"attributes.country",DE(""))#',
				 CONSUMER_ID : get_related_consumer_control.related_consumer_id
		 )>
 </cfif>
 <!--- //Iliskili Bireysel Uye Varsa Bilgiler Update Edilir FBS 20110131 --->
 <cfset GET_COMPANY_NAME = company_cmp.GET_COMPANY_NAME(company_id:attributes.company_id)>
 <!--- Adres Defteri --->
 <cfif not isDefined("attributes.company_partner_status")><cfset attributes.status_ = 0><cfelse><cfset attributes.status_ = 1></cfif>
 <cf_addressbook
	 design		= "2"
	 type		= "2"
	 type_id		= "#attributes.partner_id#"
	 active		= "#attributes.status_#"
	 name		= "#attributes.company_partner_name#"
	 surname		= "#attributes.company_partner_surname#"
	 sector_id	= "#ListFirst(get_company_name.SECTOR_ID)#"
	 company_name= "#get_company_name.fullname#"
	 title		= "#attributes.title#"
	 email		= "#attributes.company_partner_email#"
	 telcode		= "#attributes.company_partner_telcode#"
	 telno		= "#attributes.company_partner_tel#"
	 faxno		= "#attributes.company_partner_fax#"
	 mobilcode	= "#attributes.mobilcat_id#"
	 mobilno		= "#attributes.mobiltel#"
	 web			= "#attributes.homepage#"
	 postcode	= "#attributes.company_partner_postcode#"
	 address		= "#wrk_eval('attributes.company_partner_address')#"
	 semt		= "#attributes.semt#"
	 county_id	= "#attributes.county_id#"
	 city_id		= "#attributes.city_id#"
	 country_id	= "#attributes.country#"
	 kep_address = "#isdefined("attributes.partner_kep_adress") ? attributes.partner_kep_adress : ''#">
 
 <cfset CONTROL_ = company_cmp.CONTROL_(partner_id:attributes.partner_id)>
 <cfif control_.recordcount>
	 <cfset UPD_PARTNER_SETTINGS = company_cmp.UPD_PARTNER_SETTINGS(
								 language_id:'#iIf(isdefined('attributes.language_id'),"attributes.language_id",DE(""))#',   
								 time_zone: '#iIf(isdefined('attributes.time_zone'),"attributes.time_zone",DE(""))#',
								 timeout_limit: '#iIf(isdefined('attributes.timeout_limit'),"attributes.timeout_limit",DE(""))#',
								 partner_id: '#iIf(isdefined('attributes.partner_id'),"attributes.partner_id",DE(""))#'
								 )> 
<cfelse>
	 <cfset ADD_PART_SETTINGS = company_cmp.ADD_PART_SETTINGS_PARNER(
								 partner_id : '#iIf(isdefined('attributes.partner_id'),"attributes.partner_id",DE(""))#',
								 time_zone : '#iIf(isdefined('attributes.time_zone'),"attributes.time_zone",DE(""))#',
								 language_id : '#iIf(isdefined('attributes.language_id'),"attributes.language_id",DE(""))#' , 
								 timeout_limit :  '#iIf(isdefined('attributes.timeout_limit'),"attributes.timeout_limit",DE(""))#' 
								 )>
 </cfif>
 <!---Ek Bilgiler--->
 <cfset attributes.info_id =  attributes.partner_id>
 <cfset attributes.is_upd = 1>
 <cfset attributes.info_type_id = -3>
 <cfinclude template="../../objects/query/add_info_plus2.cfm">
 <!---Ek Bilgiler--->
  <cfset DEL_WRK_APP = company_cmp.DEL_WRK_APP(partner_id:attributes.partner_id)>
 <cfset attributes.actionId=attributes.partner_id> 
 <script type="text/javascript">
	 window.location.href="<cfoutput>#request.self#?fuseaction=member.list_contact&event=upd&pid=#attributes.partner_id#</cfoutput>";
 </script>
 