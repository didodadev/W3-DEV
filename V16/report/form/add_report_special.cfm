<script type="text/javascript">
 function control()
 {
	if(add_report.file_name.value=='')
	{
	   alert("<cf_get_lang dictionary_id='39041.Varlığı Seçmediniz'>!!");
	   return(false);
	}
	return(true);
 }
</script>
<cfscript>
	session.report = structNew();
</cfscript>
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
<cf_box title="#getLang('report',2)#">
	<cfform method="post" name="add_report" enctype="multipart/form-data" action="#request.self#?fuseaction=report.emptypopup_add_report_special">
		<cf_box_elements>
			<input type="hidden" name="counter" id="counter" value="">
			<input type="hidden" name="remove_position_id" id="remove_position_id" value="">
			<input type="hidden" name="remove_position_cat_id" id="remove_position_cat_id" value="">
			<input type="hidden" name="positions" id="positions" value="">
			<input type="hidden" name="position_cats" id="position_cats" value="">
			<input type="hidden" name="positions2" id="positions2" value="">
			<div class="col col-6 col-md-12 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='57493.Aktif'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<input type="checkbox" name="report_status" id="report_status" value="1">
					</div>					
				</div>
				<div class="form-group">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='58600.Dosya Oluştur'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<input type="checkbox" name="is_file" id="is_file" value="1">
					</div>					
				</div>
				<cfif session.ep.admin eq 1>
					<div class="form-group">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='38819.Yönetici Yetkisi'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<input type="checkbox" name="admin_status" id="admin_status" value="1">
						</div>						
					</div>
				</cfif>
				<div class="form-group">            
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57486.Kategori'></label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">               	
						<select name="report_cat_id" id="report_cat_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_special_report_cats">
								<option value="#report_cat_id#">
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
								<option value="#MODUL_NO#">#MODULE#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">            
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57434.Rapor'></label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='38811.Rapor Adı girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="Report_Name" id="Report_Name" required="yes" message="#message#" autocomplete="off" maxlength="100" validate="noblanks">
					</div>
				</div>
				<div class="form-group">            
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='38833.Rapor Dosyasi Adi'></label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<input type="text" name="cfm_name" id="cfm_name" disabled>
					</div>
				</div>
				<div class="form-group">            
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57629.Açıklama'></label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
						<textarea name="report_detail" id="report_detail" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
					</div>
				</div>
				<div class="form-group" style="margin-bottom: 5px;">            
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='38800.Rapor Dosyası'></label></div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<input type="file" name="file_name" id="file_name" onChange="document.add_report.cfm_name.value = this.value.substring(this.value.lastIndexOf('\\') + 1,this.value.length);">
					</div>
				</div>
			</div>
			<div class="col col-6 col-md-12 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="col col-6 col-xs-12">
					<cfsavecontent variable="txt1"><cf_get_lang dictionary_id='38942.Yetkili Pozisyonlar'></cfsavecontent>
					<cf_workcube_to_cc 
						is_update="0" 
						to_dsp_name="#txt1#" 
						form_name="add_report" 
						str_list_param="1" 
						data_type="2">
				</div>
				<div class="col col-6 col-xs-12">
					<cf_ajax_list id="td_yetkili2">
						<thead>
							<th>
								<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_position_cats&field_id=add_report.position_cats&field_td=td_yetkili2&is_noclose=1</cfoutput>','list');"><i class="icon-pluss" align="absmiddle" border="0"></i></a>
								<cf_get_lang dictionary_id='38943.Yetkili Pozisyon Tipleri'>
							</th>
						</thead>						
					</cf_ajax_list>
				</div>
			</div>			
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='control()'>
		</cf_box_footer>
	</cfform>
</cf_box>


