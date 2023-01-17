<cf_get_lang_set module_name="settings">
<cfquery name="GET_ASSET_P_CAT" datasource="#dsn#">
	SELECT ASSETP_CAT,ASSETP_CATID FROM ASSET_P_CAT ORDER BY ASSETP_CAT
</cfquery>
<cfquery name="GET_ASSETP_SUB_CAT" datasource="#dsn#">
	SELECT ASSETP_CATID,ASSETP_SUB_CAT,ASSETP_SUB_CATID,ASSETP_CATID,ASSETP_DETAIL,RECORD_DATE,RECORD_EMP,RECORD_IP,UPDATE_DATE,UPDATE_EMP,UPDATE_IP FROM ASSET_P_SUB_CAT WHERE ASSETP_SUB_CATID = #attributes.sub_cat#
</cfquery>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#getLang('','Fiziki Varlık Alt Kategorileri','59283')#" add_href="#request.self#?fuseaction=settings.add_assetp_sub_cat" is_blank="0">
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
				<cfinclude template="../display/list_assetp_sub_cat.cfm">
			</div>
			<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
				<cfform name="add_assetp_sub_cat" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_assetp_sub_cat&sub_cat=#attributes.sub_cat#">
					<cf_box_elements>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
							<div class="form-group" id="item-GET_ASSET_P_CAT">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
								<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
									<select name="assetp_cat" id="assetp_cat">
										<option value=""><cf_get_lang_main no="322.Seciniz"></option>
										<cfoutput query="GET_ASSET_P_CAT">
											<option value="#ASSETP_CATID#" <cfif GET_ASSET_P_CAT.ASSETP_CATID eq GET_ASSETP_SUB_CAT.ASSETP_CATID>selected</cfif>>#ASSETP_CAT#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-assetp_sub_cat">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='61282.Servis Alt Kategorisi'></label>
								<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
									<div class="input-group">
										<cfinput type="text" name="assetp_sub_cat" id="assetp_sub_cat" value="#GET_ASSETP_SUB_CAT.ASSETP_SUB_CAT#" maxlength="150" size="60">
										<span class="input-group-addon">
											<cf_language_info	
											table_name="ASSET_P_SUB_CAT"
											column_name="ASSETP_SUB_CAT" 
											column_id_value="#attributes.sub_cat#" 
											maxlength="500" 
											datasource="#dsn#" 
											column_id="ASSETP_SUB_CATID" 
											control_type="0">
										</span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-assetp_detail">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
								<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
									<textarea name="assetp_detail" id="assetp_detail" cols="75"><cfoutput>#GET_ASSETP_SUB_CAT.assetp_detail#</cfoutput></textarea>
								</div>
							</div>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<cf_record_info query_name="GET_ASSETP_SUB_CAT">
						<cfquery name="Get_Assetp_Used" datasource="#dsn#">
							SELECT COUNT(ASSETP_CATID) AS SAY FROM ASSET_P WHERE ASSETP_SUB_CATID = #attributes.sub_cat#
						</cfquery>
						<cfif Get_Assetp_Used.say gt 0>
							<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
						<cfelse>
							<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_assetp_sub_cat&sub_cat=#attributes.sub_cat#'>
						</cfif>
					</cf_box_footer>
				</cfform>
			</div>
			</td>
		</cf_box>
	</div>
<script type="text/javascript">
	document.getElementById('assetp_sub_cat').focus();
	function kontrol()
	{
		if(document.getElementById('assetp_cat').value=="")
		{
			alert('<cf_get_lang dictionary_id='58947.Kategori Seçmelisiniz'>!');
			document.getElementById('assetp_cat').focus();
			return false;
			}
		if(document.getElementById('assetp_sub_cat').value == "")
		{			
			alert('<cf_get_lang dictionary_id='49552.Alt Kategori'> <cf_get_lang dictionary_id='57734.Seçiniz'>!');
			document.getElementById('assetp_sub_cat').focus();
			return false;
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
	