<cfinclude template="../query/my_sett.cfm">
<cf_catalystHeader>
<div class="row">
	<div class="col col-12">
		<div  class="row myhomeBox">
			<div class="col col-6 col-xs-12 sortArea">
				<!--- Ajanda --->
				<cfset attributes.to_day = CreateDate(year(now()),month(now()), day(now()))>
				<cfset tarih = dateformat(date_add("h",session.ep.time_zone,attributes.to_day),'dd.mm.yyyy')>
				<cfsavecontent variable="agendamessage"><cf_get_lang dictionary_id='57415.Ajanda'></cfsavecontent>
				<cf_catalyst-widget id="day_agenda" title="#agendamessage#" closable="0"  write_info="#tarih#" add_href="#request.self#?fuseaction=agenda.view_daily&event=add&date=#tarih#" box_page="#request.self#?fuseaction=myhome.emptypopup_dsp_daily_agenda_ajaxagenda&date_interval=1"></cf_catalyst-widget>

				<!---İşe Yeni Başlayanlar--->
				<cfsavecontent variable="workersmessage"><cf_get_lang dictionary_id ='30852.ise yeni baslayanlar'></cfsavecontent>
				<cf_catalyst-widget id="attending_workers" title="#workersmessage#"   closable="0" close_href="javascript:HomeBox.onBoxRemove('attending_workers',false,'attending_workers');" collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_attending_workers_ajaxattending"></cf_catalyst-widget>

				<!---HR Giris-Cikis--->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='29518.Girisler ve Cikislar'></cfsavecontent>
				<cf_catalyst-widget id="hr_in_out" title="#message#"  collapsable="1" closable="0" close_href="javascript:HomeBox.onBoxRemove('hr_in_out',false,'hr_in_out');" box_page="#request.self#?fuseaction=myhome.emptypopup_list_hr_in_out_ajaxhrinout"></cf_catalyst-widget>

				<!--- Deneme Süresi Bitenler --->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31121.Deneme Süresi Bitenler'></cfsavecontent>
				<cf_catalyst-widget id="finished_test_times" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('finished_test_times',false,'finished_test_times');" collapsed="1"  collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_my_perform_emp_ajaxmyperfom"></cf_catalyst-widget>

				<!---Izinliler--->
				 <cfsavecontent variable="permittionmessage"><cf_get_lang dictionary_id ='32390.İzinliler'></cfsavecontent>
				<cf_catalyst-widget id="employee_permittion" title="#permittionmessage#"  closable="0"  box_page="#request.self#?fuseaction=myhome.emptypopup_employee_permittion_ajax&xml_show_offtime_days=1"></cf_catalyst-widget>
				
				
				<!---HR Ajanda--->
				<cfsavecontent variable="message">HR <cf_get_lang dictionary_id ='57415.Ajanda'></cfsavecontent>
				<cf_catalyst-widget id="hr_agenda" title="#message#"  collapsable="1" closable="0" close_href="javascript:HomeBox.onBoxRemove('hr_agenda',false,'hr_agenda');" box_page="#request.self#?fuseaction=myhome.emptypopup_list_hr_agenda_ajaxhragenda&x_hr_agenda=1"></cf_catalyst-widget>

				<!---Kariyerim--->
				<cfsavecontent variable="message"><cfoutput>#session.ep.company_nick# <cf_get_lang dictionary_id ='31532.İş Fırsatları'></cfoutput></cfsavecontent>
				<cf_catalyst-widget id="career" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('career',false,'is_kariyer');" collapsed="1"  collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_dsp_career_ajaxcareer"></cf_catalyst-widget>
			
			</div>
			<div class="col col-6 col-xs-12 sortArea">
				<!--- CV Başvuruları --->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31497.CV Başvuruları'></cfsavecontent>
				<cf_catalyst-widget id="hr" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('hr',false,'hr');" collapsed="1"  collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_apps_ajaxapps"></cf_catalyst-widget>

				<!---Çalışan Profili(HR)--->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='29499.Çalışan Profili'></cfsavecontent>
				<cf_catalyst-widget id="employee_profile" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('employee_profile',false,'employee_profile');"  collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_employee_profile_ajaxempprofile"></cf_catalyst-widget>

				<!---Şirket Profili(HR)--->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='29505.Şirket Profili'></cfsavecontent>
				<cf_catalyst-widget id="branch_profile" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('branch_profile',false,'branch_profile');"  collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_list_branch_profile_ajaxbranchprofile" ></cf_catalyst-widget>

				<!--- Sözleşmesi Bitenler --->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='31989.Sözleşmesi Bitenler'></cfsavecontent>
				<cf_catalyst-widget id="finished_contract" title="#message#" closable="0" close_href="javascript:HomeBox.onBoxRemove('finished_contract',false,'sureli_is_finishdate');" collapsed="1"  collapsable="1" box_page="#request.self#?fuseaction=myhome.emptypopup_finish_contract_ajaxlistcontract"></cf_catalyst-widget>

			</div>
		</div>
    </div>
</div>

<script type="text/javascript">

	$(function() {	
		
		$(".sortArea").sortable({
			connectWith		: '.sortArea',
			items			: '.col',
			handle			: '[id*="handle_"],.portHead',
			cursor			: 'move',
			opacity			: '0.6',
			placeholder		: 'col col-12 elementSortArea',
			tolerance		: 'pointer',
			revert			: 300,
			start: function(e, ui ){
				ui.placeholder.height(ui.helper.outerHeight());
				ui.item.css({'max-width':ui.placeholder.width()});				
			},
			stop: function(e, ui ) {					
				ui.item.css({'max-width':''});
			}//stop
		});	
	});//ready
	
</script>


				
			

								
				
		
		