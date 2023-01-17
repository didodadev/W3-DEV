<!--- Eğitim yönetiminden çağrılmışsa eğer class id yi alıp katılımcıları çekecek --->
<cfif isdefined("attributes.print_type") and len(attributes.print_type) and attributes.print_type eq 321><!--- Katılımcılar --->
	<cfinclude template="../display/list_class_attenders.cfm">
</cfif>
<cfif isdefined("attributes.print_type") and len(attributes.print_type) and attributes.print_type eq 320><!--- Eğitimci --->
	<cfinclude template="../display/list_class_trainer.cfm">
</cfif>
<!--- Eğitim yönetiminden çağrılmışsa eğer class id yi alıp katılımcıları çekecek --->

<cfquery name="GET_DET_FORM" datasource="#dsn3#">
  	SELECT 
		SPF.TEMPLATE_FILE,
		SPF.FORM_ID,
		SPF.IS_DEFAULT,
		SPF.NAME,
		SPF.PROCESS_TYPE,
		SPF.MODULE_ID,
		SPFC.PRINT_NAME
	FROM 
		SETUP_PRINT_FILES SPF,
		#dsn_alias#.SETUP_PRINT_FILES_CATS SPFC,
		#dsn_alias#.MODULES MOD
	WHERE
		SPF.ACTIVE = 1 AND
		SPF.IS_PARTNER = 1 AND
		SPF.MODULE_ID = MOD.MODULE_ID AND
		SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND 
		SPFC.PRINT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.print_type#">
	ORDER BY
		SPF.NAME
</cfquery>

<cfif get_det_form.recordcount>
	<cfquery name="GET_DEFAULT" dbtype="query">
		SELECT FORM_ID FROM GET_DET_FORM WHERE IS_DEFAULT = 1
	</cfquery>
	<cfset attributes.form_type = get_default.form_id>
</cfif>

<cfset adres = "objects2.emptypopup_print_files_inner">
<cfif isdefined("attributes.iid") and len(attributes.iid)>
	<cfset adres = "#adres#&iid=#attributes.iid#">
</cfif>
<cfif isdefined("attributes.action_id") and len(attributes.action_id)>
	<cfset adres = "#adres#&action_id=#attributes.action_id#">
</cfif>
<cfif isdefined("attributes.action_type") and len(attributes.action_type)>
	<cfset adres = "#adres#&action_type=#attributes.action_type#">
</cfif>
<cfif isdefined("attributes.action_row_id") and len(attributes.action_row_id)>
	<cfset adres = "#adres#&action_row_id=#attributes.action_row_id#">
</cfif>
<cfif isdefined("attributes.date1") and len(attributes.date1)>
	<cfset adres = "#adres#&date1=#attributes.date1#">
</cfif>
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.print_type") and len(attributes.print_type)>
	<cfset adres = "#adres#&print_type=#attributes.print_type#">
</cfif>
<cfif isdefined("attributes.start_count") and len(attributes.start_count)><!--- isbak icin eklendi ST 20150403--->
	<cfset adres = "#adres#&start_count=#attributes.start_count#">
</cfif>
<cfif isdefined("attributes.finish_count") and len(attributes.finish_count)><!--- isbak icin eklendi ST 20150403--->
	<cfset adres = "#adres#&finish_count=#attributes.finish_count#">
</cfif>

<cfparam name="attributes.form_kontrol" default="">
<!-- sil -->
<cfsavecontent variable="right">
<cfform name="page_print" method="post" action="#request.self#?fuseaction=objects.popupflush_print_files&is_special=1">
    <select name="form_type" id="form_type" style="width:200px"  onchange="iframe_gonder();">
        <option value=""><cf_get_lang_main no ='380.Modül İçi Yazıcı Belgeleri'></option>
        <cfoutput query="get_det_form">
            <option value="#form_id#" <cfif is_default eq 1>selected</cfif>>#name# - #print_name#</option> 
        </cfoutput>
    </select>
    <a href="javascript://" onClick="iframe_yazdir();"><img src="/images/print.gif" border="0"></a>
    <cfif isdefined("attributes.print_type") and len(attributes.print_type) and (attributes.print_type eq 321 or attributes.print_type eq 320)><!--- Eğitim yönetimi modülünden çağrılmışsa mail adreslerini formdan alıyor --->
        <cf_workcube_file_action pdf='1' print='0' doc='1' mail='1' flash_paper='0' tag_module='auto_print_page.objects' trail='0' extra_parameters="mail_list.mails">
    <cfelse>
        <cf_workcube_file_action pdf='1' print='0' doc='1' mail='1' flash_paper='0' tag_module='auto_print_page.objects' trail='0' print_type="#attributes.print_type#"  action_id="#attributes.action_id#" simple="1">
        <!---<cf_workcube_file_action pdf='1' print='0' doc='1' mail='1' flash_paper='0' tag_module='auto_print_page.objects' trail='0'>--->
    </cfif>
</cfform>
</cfsavecontent>

<cf_popup_box right_images="#right#">
	<cfif isdefined("attributes.form_type") and len(attributes.form_type)>
        <iframe scrolling="auto" name="auto_print_page" id="auto_print_page" frameborder="0" width="100%" height="450" src="<cfoutput>#request.self#?fuseaction=#adres#&form_type=#attributes.form_type#&iframe=1</cfoutput>"></iframe>
    <cfelse>
        <iframe scrolling="auto" name="auto_print_page" id="auto_print_page" frameborder="0" width="100%" height="450" src="<cfoutput>#request.self#?fuseaction=#adres#&iframe=1</cfoutput>"></iframe>
    </cfif>
</cf_popup_box>

<!-- sil -->
<!---<!-- sil -->
<table cellpadding="0" cellspacing="0" align="center" style="width:100%; height:100%;">
  	<tr class="color-border">
		<td>
			<table border="0" cellspacing="1" cellpadding="2" style="width:100%; height:100%;">
                <tr class="color-row" style="height:35px;">
					<td style="text-align:right;">
						<cfform name="page_print" method="post" action="#request.self#?fuseaction=objects.popupflush_print_files&is_special=1">
							<table>
                                <tr>
                                	<td>
                                        <select name="form_type" id="form_type" style="width:200px"  onchange="iframe_gonder();">
                                            <option value=""><cf_get_lang_main no ='380.Modül İçi Yazıcı Belgeleri'></option>
                                            <cfoutput query="get_det_form">
                                                <option value="#form_id#" <cfif is_default eq 1>selected</cfif>>#name# - #print_name#</option> 
                                            </cfoutput>
                                        </select>
                                	</td>
                                	<td>
                                		<a href="javascript://" onclick="iframe_yazdir();"><img src="/images/print.gif" border="0"></a>
										<cfif isdefined("attributes.print_type") and len(attributes.print_type) and (attributes.print_type eq 321 or attributes.print_type eq 320)><!--- Eğitim yönetimi modülünden çağrılmışsa mail adreslerini formdan alıyor --->
	                                        <cf_workcube_file_action pdf='1' print='0' doc='1' mail='1' flash_paper='0' tag_module='auto_print_page.objects' trail='0' extra_parameters="mail_list.mails">
                                        <cfelse>
    	                                    <cf_workcube_file_action pdf='1' print='0' doc='1' mail='1' flash_paper='0' tag_module='auto_print_page.objects' trail='0'>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfform>
                    </td>
                </tr>
                <tr style="height:100%;">
                    <td class="color-row">
                        <cfif isdefined("attributes.form_type") and len(attributes.form_type)>
                            <iframe scrolling="auto" height="500" name="auto_print_page" id="auto_print_page" frameborder="0" width="750" src="<cfoutput>#request.self#?fuseaction=#adres#&form_type=#attributes.form_type#&iframe=1</cfoutput>"></iframe>
                        <cfelse>
                            <iframe scrolling="auto" height="500" name="auto_print_page" id="auto_print_page" frameborder="0" width="750" src="<cfoutput>#request.self#?fuseaction=#adres#&iframe=1</cfoutput>"></iframe>
                        </cfif>
                    </td>
	 			</tr>
    		</table>
		</td>
  	</tr>
</table>
<!-- sil -->--->
<script type="text/javascript">
	function iframe_gonder()
	{
		secilen_ = document.page_print.form_type;
		if(secilen_.value != '')
		{
			auto_print_page.location.href='<cfoutput>#request.self#?fuseaction=#adres#&iframe=1&form_type=</cfoutput>' + secilen_.value;	
		}
	}
	
	function iframe_yazdir()
	{
		auto_print_page.focus(); 
		auto_print_page.print(); 
	}
</script>
