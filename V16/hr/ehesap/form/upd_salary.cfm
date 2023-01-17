<!---
    File: V16\hr\ehesap\form\upd_salary.cfm
    Edit Author: Esma R. Uysal <esmauysal@workcube.com>
    Edit Date: 2021-05-24        
--->
<cfset in_out_cmp = createObject("component","V16.hr.ehesap.cfc.employees_in_out") />
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>

<cfif (not session.ep.ehesap)>
	<!--- üst düzey ik değilse yetkili olduğu şubeler --->
	<cfset get_emp_branch = in_out_cmp.get_emp_branch()>
	<!--- üst düzey ik değilse yetkili olduğu şubeler listesi --->
	<cfset emp_branch_list=valuelist(get_emp_branch.BRANCH_ID)>
	<cfif LEN(emp_branch_list)>
		<cfset emp_branch_list=ListSort("#emp_branch_list#,#ListGetAt(session.ep.user_location,2,"-")#","Numeric")>
	<cfelse>
		<cfset emp_branch_list=ListGetAt(session.ep.user_location,2,"-")>
	</cfif>
</cfif>

<cfset get_emp_ssk = in_out_cmp.get_emp_ssk(in_out_id : attributes.in_out_id)>

<cfset attributes.employee_id = GET_EMP_SSK.EMPLOYEE_ID>
<cfset url.employee_id = GET_EMP_SSK.EMPLOYEE_ID>
<cfif GET_EMP_SSK.recordcount>
	<cfif (not session.ep.ehesap) and (not listFind(emp_branch_list, GET_EMP_SSK.branch_id))>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !");
			history.back();
		</script>
		<!--- yetki dışı kullanım için mail şablonu hazırlanmalı erk 20030911--->
		<cfabort>
	</cfif>	
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='53670.Çalışan İçin İşe Giriş-Çıkış Kaydı Bulunamadı'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfset get_worktimes_xml = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.list_ext_worktimes',
    property_name : 'is_extwork_type'
    )
    >
<cf_catalystHeader>
<cfinclude template="upd_emp_work_info.cfm">
<script>
	 $( document ).ready(function() {
		<cfif isdefined("attributes.type") and len(attributes.type)>
			openAjaxFnc(<cfoutput>#attributes.type#,#attributes.employee_id#,#attributes.in_out_id#</cfoutput>);
		<cfelse>
			openAjaxFnc(<cfoutput>1,#attributes.employee_id#,#attributes.in_out_id#</cfoutput>);
		</cfif>
	}); 
    function openAjaxFnc(type,employee_id,in_out_id) 
	{ 
		// type---> 1 :Ücret Kartı /V16/hr/ehesap/form/upd_emp_work_info.cfm
		switch(type) {
			case 1 : // type---> 1 : Ücret Kartı
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.list_salary&event=salary_info&in_out_id=#attributes.in_out_id#&employee_id=#attributes.employee_id#&ismultiselect_used=1</cfoutput>','ajax_right');
			//	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.list_salary&event=salary_card&in_out_id=#attributes.in_out_id#&employee_id=#attributes.employee_id#&fuseaction=#attributes.fuseaction#&event=#attributes.event#</cfoutput>','ajax_right');
				break;
			case 2:// type---> 2 : Maaş Planlaması
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_list_salary_plan&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>','ajax_right');
				break;
			case 3:// type---> 3 : Muhasebe Kodu
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_list_period&event=upd&in_out_id=#attributes.in_out_id#&from_upd_salary=1</cfoutput>','ajax_right');
				break;
			case 4:// type---> 4 : Sigorta Hesap Fişi
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_upd_fuse&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>','ajax_right');
				break;
			case 5:// type---> 5 : Ek Ödenek
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_upd_odenek_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#&from_upd_salary=1</cfoutput>','ajax_right');
				break;
			case 6:// type---> 6 : Kesintiler
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_upd_kesinti_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#&from_upd_salary=1</cfoutput>','ajax_right');
				break;
			case 7:// type---> 7 : Vergi İstisnaları
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_upd_vergi_istisna_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#&from_upd_salary=1</cfoutput>','ajax_right');
				break;
			case 8:// type---> 8 : Otomatik Bes Tanımları
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_upd_bes_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#&from_upd_salary=1</cfoutput>','ajax_right');
				break;
			case 9:// type---> 9 : Fazla Mesailer
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_add_emp_ext_worktimes&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#&from_upd_salary=1</cfoutput>','ajax_right');
				break;	
			case 10:// type---> 10 : Fazla Mesailer
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_upd_ext_worktimes&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#&from_upd_salary=1</cfoutput>','ajax_right');
				break;	
			case 11:// type---> 11 : Ücret Tarihçesi
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_pay_history&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>','ajax_right');
				break;	
			case 12:// type---> 12 : Giriş Çıkış Tarihçesi
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_in_out_history&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>','ajax_right');
				break;	
			case 13:// type---> 13 : Çalışan Giriş Çıkışları
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_list_multi_in_out&employee_id=#attributes.employee_id#</cfoutput>','ajax_right');
				break;		
			case 14:// type---> 14 : Çalışan Giriş Çıkışları
				window.open('<cfoutput>#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#</cfoutput>','ajax_right');
				break;
			case 15:// type---> 15 : Uzaktan çalışma planı
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_list_remote_plan&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>','ajax_right');
				break;
		}
	}

</script>