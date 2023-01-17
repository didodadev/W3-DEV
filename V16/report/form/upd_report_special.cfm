<cfquery name="get_special_report_cats" datasource="#dsn#">
	SELECT
    	REPORT_CAT_ID,
        REPORT_CAT,
        HIERARCHY        
    FROM
    	SETUP_REPORT_CAT
    ORDER BY
    	HIERARCHY
</cfquery>
<cfset get_queries = createObject("component","V16.process.cfc.qpic_r_main_list")>
<cfset get_modules=get_queries.get_modules()>
<cf_catalystHeader>
<cfinclude template="../query/get_report.cfm">
<cfinclude template="../query/get_report_positions.cfm">
<cfinclude template="../query/get_report_positon_cats.cfm">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='38782.Rapor Güncelle'></cfsavecontent>
<cf_box title="#title#" closable="0" collapsed="0">
	<cfform name="upd_report" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=report.emptypopup_upd_report_special">
		<cf_box_elements>
			<cfoutput>
				<input type="hidden" name="counter" id="counter" value="">
				<input type="hidden" name="report_id" id="report_id" value="#get_report.report_id#">
				<input type="hidden" name="positions" id="positions" value="">
				<input type="hidden" name="position_cats" id="position_cats" value="#ValueList(get_report_position_cats.pos_cat_id)#">
				<input type="hidden" name="positions2" id="positions2" value="#ValueList(get_report_positions.pos_code)#">
			</cfoutput>	
			<div class="col col-6 col-md-12 col-sm-6 col-xs-12" type="column" index="1" sort="true">		
				<div class="form-group">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='57493.Aktif'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<input type="checkbox" name="report_status" id="report_status" value="1" <cfif get_report.report_status eq 1> checked</cfif>>
					</div>
				</div>
				<div class="form-group">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='58600.Dosya Oluştur'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<input type="checkbox" name="is_file" id="is_file" <cfif get_report.is_file eq 1> checked</cfif>>
					</div>						
				</div>
				<cfif session.ep.admin eq 1>
					<div class="form-group">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='38819.Yönetici Yetkisi'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<input type="checkbox" name="admin_status" id="admin_status" <cfif get_report.admin_status eq 1> checked</cfif>>
						</div>							
					</div>
				</cfif>
				<div class="form-group">            
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57486.Kategori'></label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<select name="report_cat_id" id="report_cat_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_special_report_cats">
								<option value="#report_cat_id#" <cfif report_cat_id eq get_report.report_cat_id>selected</cfif>>
									<cfif ListLen(HIERARCHY,".") neq 1>
										<cfloop from="1" to="#ListLen(HIERARCHY,".")#" index="i">&nbsp;</cfloop>
									</cfif>
									#report_cat#
								</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id ='55060.Modül'></label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<select name="module" id="module">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_modules">
								<option value="#MODUL_NO#"<cfif get_report.MODUL_NO eq modul_no> selected</cfif>>#MODULE#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">            
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57434.Rapor'></label></div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='38811.Rapor Adı girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="Report_Name" value="#get_report.report_name#" required="yes" message="#message#" maxlength="100" validate="noblanks">
					</div>
				</div>
				<div class="form-group">           
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='38833.Rapor Dosyasi Adi'></label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<input type="text" name="cfm_name" id="cfm_name" value="<cfoutput>#get_report.cfm_file_name#</cfoutput>" readonly>
					</div>
				</div>		
				<div class="form-group">   
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57629.Açıklama'></label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
						<textarea name="report_detail" id="report_detail" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_report.report_detail#</cfoutput></textarea>
					</div>
				</div>
				<div class="form-group">   
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='38800.Rapor Dosyası'></label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<input type="file" name="file_name" id="file_name" onChange="document.upd_report.cfm_name.value = this.value.substring(this.value.lastIndexOf('\\') + 1,this.value.length);">
					</div>
				</div>
				<div class="form-group">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='39572.Sistemdeki Dosya Adı'></label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12"><cfoutput>#get_report.file_name#</cfoutput></div>
				</div>
			</div>
			<div class="col col-6 col-md-12 col-sm-6 col-xs-12" type="column" index="2" sort="true">				
				<div class="col col-6 col-xs-12">
					<cfsavecontent variable="txt1"><cf_get_lang dictionary_id='38942.Yetkili Pozisyonlar'></cfsavecontent>
					<cf_workcube_to_cc 
						is_update="1" 
						to_dsp_name="#txt1#" 
						form_name="upd_report" 
						str_list_param="1" 
						data_type="2" 
						action_dsn="#DSN#"
						action_id_name="REPORT_ID"
						action_id="#attributes.report_id#"
						str_action_names="POS_CODE AS TO_POS_CODE"
						action_table="REPORT_ACCESS_RIGHTS">
				</div>
				<div class="col col-6 col-xs-12">
					<cf_ajax_list id="td_yetkili2">
						<thead>
							<th>
								<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_position_cats&field_id=upd_report.position_cats&field_td=td_yetkili2&is_noclose=1</cfoutput>','list');"><i class="icon-pluss" align="absmiddle" border="0"></i></a>
								<cf_get_lang dictionary_id='38943.Yetkili Pozisyon Tipleri'>									
							</th>
						</thead>									
						<cfif get_report_position_cats.recordcount>
							<cfoutput query="get_report_position_cats">
								<tbody>
									<td>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=report.emptypopup_del_report_position_cat&report_id=#attributes.REPORT_ID#&pos_cat_id=#POS_CAT_ID#','small');"><img src="/images/delete_list.gif" border="0">#position_cat#</a>
									</td>
								</tbody>
							</cfoutput>
						</cfif>					
					</cf_ajax_list>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>			
			<cf_record_info query_name="get_report" record_emp="record_emp" update_emp="update_emp">
			<cf_workcube_buttons is_upd='1' add_function='control()' delete_page_url='#request.self#?fuseaction=report.emptypopup_del_report_special&report_id=#attributes.report_id#'>
			<cfsavecontent variable="title_"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
			<cf_workcube_buttons update_status="0" extraButton="1" extraButtonText="#title_#" extraFunction='runFunc()' right="1" extraButtonClass="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left">
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
function control()
{
 	if(upd_report.file_name.value!='')
	{
	   return confirm("<cf_get_lang dictionary_id='39573.Eski Dosya Silinip Yerine Yenisi Konacak Emin Misiniz ?'>");
	}
	return(true);
}
function runFunc() {
	upd_report.action ='<cfoutput>#request.self#?fuseaction=report.detail_report&event=det&report_id=#report_id#</cfoutput>';
	upd_report.submit();
}
</script>
