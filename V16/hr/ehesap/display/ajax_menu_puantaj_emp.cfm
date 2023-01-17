<cfsetting showdebugoutput="no">
<cfparam name="attributes.puantaj_type" default="-1">
<cfquery name="get_puantaj_xml" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = #session.ep.company_id# AND
		FUSEACTION_NAME = 'ehesap.list_puantaj' AND
		PROPERTY_NAME = 'x_select_special_code'
</cfquery>
<cfif (get_puantaj_xml.recordcount and get_puantaj_xml.property_value eq 0) or get_puantaj_xml.recordcount eq 0><cfset x_select_special_code = 0><cfelse><cfset x_select_special_code = 1></cfif>
<cfif isdefined("attributes.employee_id")>
	<cfif x_puantaj_day neq 0>
		<cfif (attributes.sal_year eq year(fusebox.simdi) and attributes.sal_mon eq month(fusebox.simdi)-1 and x_puantaj_day gte day(fusebox.simdi)) or (attributes.sal_year eq year(fusebox.simdi) and attributes.sal_mon eq month(fusebox.simdi))>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id ='53343.Çalışanın Puantajı Varsa Sıfırlanarak Yeniden Oluşturulacak'></cfsavecontent>
			<!--- <cfoutput><a href="##" onClick="if (confirm('#message#')) puantaja_aktar(); else return false;"><img src="/images/out.gif" title="<cf_get_lang dictionary_id='53233.Puantaja Aktar'>" border="0" style="background-color:transparent;"></a></cfoutput> --->
			<cf_workcube_buttons update_status="0" extraButton="1" extraButtonText="#getLang('','Puantaj aktar','53233')#" extraFunction="puantaja_aktar()" right="0">
		</cfif>
	<cfelse>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id ='53343.Çalışanın Puantajı Varsa Sıfırlanarak Yeniden Oluşturulacak'></cfsavecontent>
			<cf_workcube_buttons update_status="0" extraButton="1" extraButtonText="#getLang('','Puantaj aktar','53233')#" extraFunction="puantaja_aktar()" right="0">
			<!--- <cfoutput><a href="##" onClick="if (confirm('#message#')) puantaja_aktar(); else return false;"><img src="/images/out.gif" title="<cf_get_lang dictionary_id='53233.Puantaja Aktar'>" border="0" style="background-color:transparent;"></a></cfoutput> --->
	</cfif>
	<cfoutput><a href="javascript://" class="ui-wrk-btn ui-wrk-btn-success" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_send_puantaj_mails&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&employee_id=#attributes.employee_id#','small');"><i class="col fa-lg fa fa-envelope" title="<cf_get_lang dictionary_id ='53276.Puantajı Mail Olarak Gönder'>"></i></a></cfoutput>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.employee_id")>
		function puantaja_aktar()
		{
			puantaj_type_ = document.getElementById('employee_puantaj_type').value;
			ssk_statue = $("#ssk_statue_emp").val();//ssk durumu
			statue_type = $("#statue_type_emp").val();
			statue_type_individual = $("#statue_type_individual_emp").val();
			
			if(puantaj_type_ == '-3')
			{
				alert("<cf_get_lang dictionary_id='54624.Son Puantaj Fark Puantajı İle Beraber Oluşur. Bu Adımda Son Puantaj Oluşturulamaz'>!");
				return false;
			}
			<cfif isdefined("attributes.sal_mon")>
				sal_mon_ = "<cfoutput>#attributes.sal_mon#</cfoutput>";
				sal_year_ = "<cfoutput>#attributes.sal_year#</cfoutput>";
				emp_id_ = "<cfoutput>#attributes.employee_id#</cfoutput>";
			<cfelse>
				sal_mon_ = document.getElementById('emp_sal_mon').value;
				sal_year_ = document.getElementById('emp_sal_year').value;
				emp_id_ = document.getElementById('employee_id').value;
			</cfif>
			var listParam = sal_mon_+'*'+sal_year_+'*'+emp_id_+"<cfoutput>*#attributes.puantaj_type#</cfoutput>";
			get_puantaj_ = wrk_safe_query('hr_get_puantaj_3','dsn',0,listParam);
			if(get_puantaj_.recordcount>0)
			{
				alert("<cf_get_lang dictionary_id ='53357.Çalışan İçin İleri Tarihli Bir Puantaj Kaydı Var Geçmiş Tarihli Puantaj Çalıştıramazsınız'>!");
				return false;
			}
			//harcırah kontrolü
			var listParam_2 = sal_mon_+'*'+sal_year_+'*'+emp_id_;
			get_puantaj_2 = wrk_safe_query('hr_control_expense_puantaj_2','dsn',0,listParam_2);
			if(get_puantaj_2.recordcount>0)
			{
				alert("<cf_get_lang dictionary_id='54625.Çalışan İçin İleri Tarihli Bir Harcırah Kaydı Var Geçmiş Tarihli Puantaj Çalıştıramazsınız'>!");
				return false;
			}
			var listParam = sal_mon_+'*'+sal_year_+'*'+emp_id_;
			get_branch_id = wrk_safe_query('hr_get_branch_id','dsn',0,listParam);
			var listParam = sal_mon_+'*'+sal_year_+'*'+get_branch_id.BRANCH_ID+"<cfoutput>*#attributes.puantaj_type#</cfoutput>";
			<cfif x_select_special_code eq 1>//özel kod dolu ise özel kodsuz çalışan puantaj var mı diye bakılıyor
				get_puantaj2_ = wrk_safe_query("hr_get_puantaj_4",'dsn',0,listParam);
				if(get_puantaj2_.recordcount>0)
				{
					alert("<cf_get_lang dictionary_id='54626.Şube İçin Genel Puantaj Çalıştırıldığı İçin Puantaj Çalıştıramazsınız'>!");
					return false;
				}
			<cfelse>//Değilse özel kodlu çalışan var mı diye bakılıyor
				get_puantaj2_ = wrk_safe_query("hr_get_puantaj_5",'dsn',0,listParam);
				if(get_puantaj2_.recordcount>0)
				{
					alert("<cf_get_lang dictionary_id='54627.Şube İçin Özel Kod İle Çalıştırıldığı İçin Puantaj Çalıştıramazsınız'>!");
					return false;
				}
			</cfif>
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_add_personal_puantaj&from_employee_payroll=1&puantaj_type=#attributes.puantaj_type#&puantaj_olustur_2=1&renew=1&ssk_statue='+ssk_statue+'&statue_type='+statue_type+'&employee_id='+emp_id_+'&sal_mon='+sal_mon_+'&sal_year='+sal_year_+'&statue_type_individual='+statue_type_individual+'</cfoutput>','menu_puantaj_2','1',"<cf_get_lang dictionary_id ='53361.Puantaj Oluşturuluyor'>");
		}
	</cfif>
</script>
