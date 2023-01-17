<cf_catalystHeader>
<cfif fuseaction is "objects.popup_dsp_report" or fuseaction is "objects.popupflush_dsp_report">
	<cfinclude template="../fbx_workcube_funcs.cfm">
</cfif>	
<cf_get_lang_set module_name="report">
<cfinclude template="report_access_rights.cfm">
<cfinclude template="../query/get_report.cfm">
<cfparam name="attributes.schedule_eklenebilir" default="1">
<cfparam name="attributes.dsp_report_info_" default="1">
<cfif (session.ep.admin neq 1) and (get_report.admin_status eq 1)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='29985.Bu Raporu Görüntülemeye Yetkili Değilsiniz'>!");
		window.history.go(-1);
	</script>
	<cfabort>
</cfif>
<div id="report_part">
	<cfif get_report.recordcount>
		<cfif get_report.is_special eq 1 and get_report.is_file neq 1>
			<cfinclude template="/documents/report/#get_report.file_name#">
			<cffile action="read" file="#upload_folder#report#dir_seperator##get_report.file_name#" variable="content" charset="UTF-8">
			<cfif FindNoCase("session.",content)><cfset attributes.schedule_eklenebilir = 0></cfif>
			<cfif not fusebox.fuseaction contains 'emptypopup'>
				<!-- sil -->
				<cfif not attributes.schedule_eklenebilir and  not(isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
					<script type="text/javascript">
						if(document.getElementById('add_schedule') != undefined)
							document.getElementById('add_schedule').innerHTML = '';
					</script>
				</cfif>
				<!-- sil -->
			</cfif>
			<cfexit method="exittemplate">
				<cfelseif get_report.is_special eq 1 and get_report.is_file eq 1>
				<cfinclude template="../..#file_web_path#report/#get_report.file_name#">
			<cfexit method="exittemplate">
		</cfif>
	<cfelse>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
		<cfset hata  = 11>
		<cfset hata_mesaj  = message>
		<cfinclude template="../../dsp_hata.cfm">
	</cfif>
</div>
<cf_get_lang_set module_name="#listgetat(attributes.fuseaction,1,'.')#">
