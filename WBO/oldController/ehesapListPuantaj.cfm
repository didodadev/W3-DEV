<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_xml_page_edit>
	<cf_get_lang_set module_name="ehesap">
	<cfparam name="attributes.employee_id" default="">
	<cfparam name="attributes.ssk_office" default="0">
	<cfparam name="attributes.hierarchy_puantaj" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.sal_year" default="#year(now())#">
	<cfinclude template="../hr/ehesap/query/get_ssk_offices.cfm">
	<cfif month(now()) eq 1>
		<cfparam name="attributes.sal_mon" default="1">
	<cfelse>
		<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
	</cfif>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		function open_form_ajax()
		{ 
			if(document.getElementById('maxrows').value == '' || document.getElementById('maxrows').value == 0)
			{
				alert('<cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'>');
				return false;
			}
			adres_ = '<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_ajax_view_puantaj</cfoutput>';
			adres_menu_1 = '<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_ajax_menu_puantaj_sube&x_puantaj_day=#x_puantaj_day#&hierarchy_puantaj=#attributes.hierarchy_puantaj#&x_select_process=#x_select_process#</cfoutput>';
			adres_menu_2 = '<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_ajax_menu_puantaj_calisan&x_puantaj_day=#x_puantaj_day#&hierarchy_puantaj=#attributes.hierarchy_puantaj#&sal_mon=' + document.getElementById('emp_sal_mon').value+'&&sal_year=' + document.getElementById('emp_sal_year').value+'</cfoutput>';
			branch_or_user_ = document.getElementById('branch_or_user').value;
			<cfif x_select_special_code eq 1>
				if(branch_or_user_ == 1 && document.getElementById('hierarchy_puantaj').value == '')
				{
					alert("Lütfen Özel Kod Giriniz !");
					return false;
				}
			</cfif>
			if(branch_or_user_==1)
			{
				sal_year_ = document.getElementById('sal_year').value;
				sal_mon_ = document.getElementById('sal_mon').value;
	//			ssk_office_ = list_getat(document.getElementById('ssk_office').value,1,'-');
	//			ssk_no_ = list_getat(document.getElementById('ssk_office').value,2,'-');
	//			branch_id_ = list_getat(document.getElementById('ssk_office').value,3,'-');
				branch_id_ =document.getElementById('ssk_office').value;
				hierarchy_puantaj_ = document.getElementById('hierarchy_puantaj').value;
				puantaj_type_ = document.getElementById('puantaj_type').value;
				adres_= adres_ + '&branch_or_user=1';
				var listParam = sal_mon_ + "*" + sal_year_ + "*" + branch_id_ + "*" + puantaj_type_ +"*"+hierarchy_puantaj_;
				get_puantaj_ = wrk_safe_query("hr_get_puantaj_",'dsn',0,listParam);
				
				if(get_puantaj_.recordcount>0)
				{
					adres_= adres_ + '&puantaj_id='+get_puantaj_.PUANTAJ_ID +'&hierarchy_puantaj='+hierarchy_puantaj_;
					adres_menu_1= adres_menu_1 + '&puantaj_type='+puantaj_type_ +'&puantaj_id='+get_puantaj_.PUANTAJ_ID +'&hierarchy_puantaj='+hierarchy_puantaj_;
					adres_ = adres_ + '&sal_mon=' + document.getElementById('emp_sal_mon').value;
					adres_ = adres_ + '&sal_year=' + document.getElementById('emp_sal_year').value;
					adres_ = adres_ + '&maxrows=' + document.getElementById('maxrows').value;
					<cfoutput>
						adres_ = adres_ + '&startrow=' + #attributes.startrow#;
						adres_ = adres_ + '&page=' + #attributes.page#;
					</cfoutput>
				}
				adres_menu_1 = adres_menu_1 + '&maxrows=' + document.getElementById('maxrows').value;
				<cfoutput>
					adres_menu_1 = adres_menu_1 + '&startrow=' + #attributes.startrow#;
					adres_menu_1 = adres_menu_1 + '&page=' + #attributes.page#;
				</cfoutput>
				AjaxPageLoad(adres_,'puantaj_list_layer','1',"<cf_get_lang no ='945.Puantaj Listeleniyor'>");
				AjaxPageLoad(adres_menu_1,'menu_puantaj_1','1',"<cf_get_lang no ='946.Puantaj Menüsü Yükleniyor'>");
			}
			else if(branch_or_user_==2)
			{
				puantaj_type_ = document.getElementById('employee_puantaj_type').value;
				if(document.getElementById('employee_id').value=='')
				{
					alert("<cf_get_lang no ='1193.Kişi Seçmelisiniz'>");
					return false;
				}
				adres_= adres_ + '&puantaj_type=' + puantaj_type_;
				adres_= adres_ + '&employee_id=' + document.getElementById('employee_id').value;
				adres_= adres_ + '&employee_name=' + document.getElementById('employee_name').value;
				adres_= adres_ + '&sal_mon=' + document.getElementById('emp_sal_mon').value;
				adres_= adres_ + '&sal_year=' + document.getElementById('emp_sal_year').value;
				adres_= adres_ + '&renew=1';
				
				adres_menu_2 = adres_menu_2 + '&puantaj_type=' + puantaj_type_;
				adres_menu_2 = adres_menu_2 + '&employee_id=' + document.getElementById('employee_id').value;
				adres_menu_2 = adres_menu_2 + '&maxrows=' + document.getElementById('maxrows').value;
				<cfoutput>
					adres_menu_2 = adres_menu_2 + '&startrow=' + #attributes.startrow#;
					adres_menu_2 = adres_menu_2 + '&page=' + #attributes.page#;
				</cfoutput>
				AjaxPageLoad(adres_,'puantaj_list_layer','1',"<cf_get_lang no ='945.Puantaj Listeleniyor'>");
				AjaxPageLoad(adres_menu_2,'menu_puantaj_2','1',"<cf_get_lang no ='946.Puantaj Menüsü Yükleniyor'>");
			}
			return false;
		 }
		function create_puantaj()
		{	
			if(branch_or_user_==1)
			{
				puantaj_type_ = document.getElementById('puantaj_type').value;
			}
			else
			{
				puantaj_type_ = document.getElementById('employee_puantaj_type').value;
			}
			
			if(puantaj_type_ == '-3')
			{
				alert(<cf_get_lang dictionary_id='54624.Son Puantaj Fark Puantajı İle Beraber Oluşur!\nBu Adımda Son Puantaj Oluşturulamaz!');
				return false;
			}
			create_adres_ = '<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_add_puantaj_list_from_salary</cfoutput>';
			sal_year_ = document.getElementById('sal_year').value;
			sal_mon_ = document.getElementById('sal_mon').value;
			ssk_office_all_ = document.getElementById('ssk_office').value;
			hierarchy_puantaj_ = document.getElementById('hierarchy_puantaj').value;
	//		ssk_office_ = list_getat(document.getElementById('ssk_office').value,1,'-');
	//		ssk_no_ = list_getat(document.getElementById('ssk_office').value,2,'-');
	//		branch_id_ = list_getat(document.getElementById('ssk_office').value,3,'-');
			branch_id_ = document.getElementById('ssk_office').value;
			process_stage_ = document.getElementById('process_stage').value;
			branch_or_user_ = document.getElementById('branch_or_user').value;
			<cfif x_select_process eq 1>
				x_select_process_=1
			<cfelse>
				x_select_process_=0
			</cfif>
			
			var listParam = sal_mon_ + "*" + sal_year_ + "*" + branch_id_ + "*" + puantaj_type_;
			get_puantaj2_ = wrk_safe_query("hr_get_puantaj_2",'dsn',0,listParam);
			if(get_puantaj2_.recordcount>0)
			{	
				ay_list2 = "<cfoutput>#lang_array_main.item[180]#,#lang_array_main.item[181]#,#lang_array_main.item[182]#,#lang_array_main.item[183]#,#lang_array_main.item[184]#,#lang_array_main.item[185]#,#lang_array_main.item[186]#,#lang_array_main.item[187]#,#lang_array_main.item[188]#,#lang_array_main.item[189]#,#lang_array_main.item[190]#,#lang_array_main.item[191]#</cfoutput>";
				aylar = "";
				for(i=0; i<get_puantaj2_.recordcount; i++)
				{
					if(get_puantaj2_.recordcount > 1 && i >0)
					{	
						aylar = aylar+', ';
					}
					aylar = aylar+list_getat(ay_list2,get_puantaj2_.SAL_MON[i],',');
				}
				alert("<cf_get_lang no ='947.İlgili şubenin ileri tarihli bir puantaj kaydı var geçmiş tarihli puantaj çalıştıramazsınız'>("+ aylar +")");
				return false;
			}
			//harcırah kontrolü
			var listParam_2 = sal_mon_+'*'+sal_year_+'*'+branch_id_;
			get_puantaj_2 = wrk_safe_query('hr_control_expense_puantaj_3','dsn',0,listParam_2);
			if(get_puantaj_2.recordcount>0)
			{
				alert("<cf_get_lang dictionary_id='54625.Çalışan İçin İleri Tarihli Bir Harcırah Kaydı Var Geçmiş Tarihli Puantaj Çalıştıramazsınız'>!");
				return false;
			}
			if(hierarchy_puantaj_ != '')//özel kod dolu ise özel kodsuz çalışan puantaj var mı diye bakılıyor
			{
				get_puantaj2_ = wrk_safe_query("hr_get_puantaj_4",'dsn',0,listParam);
				if(get_puantaj2_.recordcount>0)
				{
					alert("<cf_get_lang dictionary_id='54626.Şube İçin Genel Puantaj Çalıştırıldığı İçin Puantaj Çalıştıramazsınız'>!");
					return false;
				}
			}
			else//Değilse özel kodlu çalışan var mı diye bakılıyor
			{
				get_puantaj2_ = wrk_safe_query("hr_get_puantaj_5",'dsn',0,listParam);
				if(get_puantaj2_.recordcount>0)
				{
					alert("<cf_get_lang dictionary_id='54627.Şube İçin Özel Kod İle Çalıştırıldığı İçin Puantaj Çalıştıramazsınız'>!");
					return false;
				}
			}
		
			create_adres_= create_adres_ + '&sal_mon=';
			create_adres_= create_adres_ + sal_mon_ + '&sal_year=';
			create_adres_= create_adres_ + sal_year_ + '&ssk_office='; 
			create_adres_= create_adres_ + encodeURI(ssk_office_all_);
			create_adres_= create_adres_ + '&hierarchy_puantaj=' + hierarchy_puantaj_;
			create_adres_= create_adres_ + '&process_stage=' + process_stage_;
			create_adres_= create_adres_ + '&renew=1';
			create_adres_= create_adres_ + '&puantaj_type=' + puantaj_type_;
			create_adres_= create_adres_ + '&x_select_process=' + x_select_process_;
			<cfif x_select_process eq 1>
				if (process_cat_control())
					AjaxPageLoad(create_adres_,'menu_puantaj_1','1',"<cf_get_lang no ='415.Puantaj Oluşturuluyor'>");
			<cfelse>
				AjaxPageLoad(create_adres_,'menu_puantaj_1','1',"<cf_get_lang no ='415.Puantaj Oluşturuluyor'>");
			</cfif>
		}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_puantaj';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_puantaj.cfm';
</cfscript>
