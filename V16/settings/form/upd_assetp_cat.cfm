<cf_get_lang_set module_name="settings">
<cfquery name="category" datasource="#dsn#">
    SELECT 
        ASSETP_CATID, 
        ASSETP_CAT, 
        ASSETP_RESERVE, 
        LIBRARY, 
        IT_ASSET, 
        MOTORIZED_VEHICLE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
        ASSET_P_CAT 
    WHERE 
        ASSETP_CATID = #url.id#
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='58021.ÖTV'></cfsavecontent>
	<cf_box title="#getLang('','Fiziki Varlık Kategorileri','42235')#" add_href="#request.self#?fuseaction=settings.add_assetp_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
			<cfinclude template="../display/list_assetp_cat.cfm">
		</div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="asset_p" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_assetp_cat">
                <input type="hidden" name="assetp_catid" id="assetp_catid" value="<cfoutput>#url.id#</cfoutput>">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="item-assetp_cat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='33281.Kategori Girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="assetP_Cat" size="60" value="#category.assetp_cat#" maxlength="50" required="Yes" message="#message#" style="width:150px;">
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                        table_name="ASSET_P_CAT" 
                                        column_name="ASSETP_CAT" 
                                        column_id_value="#url.id#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="ASSETP_CATID" 
                                        control_type="0">
                                    </span>
                                </div>
							</div>
						</div>
						<div class="form-group" id="item-assetp_reserve">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42309.Rezerve Edilir'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
								<input type="checkbox" name="assetp_reserve" id="assetp_reserve" value="#category.assetp_reserve#" <cfif category.assetp_reserve>checked</cfif>>
							</div>
						</div>
						<div class="form-group" id="item-it_asset">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31848.IT Varlıkları'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
								<input type="checkbox" name="it_asset" id="it_asset" value="#category.it_asset#" onclick="kontrol();"<cfif category.it_asset>checked</cfif>>
                                <input type="hidden" name="old_it_asset" id="old_it_asset" value="#category.it_asset#">
							</div>
						</div>
						<div class="form-group" id="item-motorized_vehicle">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42311.Motorlu Taşıt'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
								<input type="checkbox" name="motorized_vehicle" id="motorized_vehicle" value="#category.motorized_vehicle#" onclick="kontrol();"<cfif category.motorized_vehicle>checked</cfif>>
                                <input type="hidden" name="old_motorized_vehicle" id="old_motorized_vehicle" value="#category.motorized_vehicle#">
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
                    <cf_record_info query_name="category">
                    <cfquery name="Get_Assetp_Used" datasource="#dsn#" maxrows="1">
                        SELECT TOP 1 ASSETP_CATID FROM ASSET_P WHERE ASSETP_CATID = #attributes.id#
                    </cfquery>
					<cfif Get_Assetp_Used.recordcount>
                        <cf_workcube_buttons is_upd='1' is_delete='0'>
                    <cfelse>
                        <cf_workcube_buttons is_upd='1'  delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_assetp_cat&ASSETP_CATID=#attributes.id#'>
                    </cfif>
				</cf_box_footer>
			</cfform>
		</div>
	</cf_box>
</div>
<script type="text/javascript">
    function kontrol()
    {
        if (document.asset_p.it_asset.checked == true && document.asset_p.motorized_vehicle.checked == true)
        {  
            alert("<cf_get_lang dictionary_id='42813.Aynı Anda İki Kategori Seçemezsiniz'>!");
            document.asset_p.it_asset.checked = false;
            document.asset_p.motorized_vehicle.checked = false;
            return false;
        }	
    }
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
