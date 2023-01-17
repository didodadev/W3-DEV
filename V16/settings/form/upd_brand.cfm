<cfsavecontent variable="header"><cf_get_lang dictionary_id='42904.Markalar'></cfsavecontent>
<cfquery name="GET_BRANDS" datasource="#DSN#">
	SELECT 
    	BRAND_ID, 
        BRAND_NAME, 
        IT_ASSET, 
        MOTORIZED_VEHICLE, 
        PHYSICAL_ASSET,
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_BRAND 
    WHERE 
	    BRAND_ID = #attributes.brand_id#
</cfquery>
<div class="col col-12 col-xs-12">
    <cf_box title="#header#" add_href="#request.self#?fuseaction=settings.add_brand">
        <cfform name="upd_brand" method="post"  action="#request.self#?fuseaction=settings.emptypopup_upd_brand">        
            <input type="hidden" name="brand_id" id="brand_id" value="<cfoutput>#get_brands.brand_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-3 col-xs-12">
                    <div class="scrollbar" style="max-height:403px;overflow:auto;">
                        <div id="cc">
                            <cfinclude template="../display/list_brand.cfm">
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-xs-12">	
                    <div class="form-group" id="item-brand_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka Adı'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group large">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='42786.Marka Girmelisiniz'>!</cfsavecontent>
                                <cfinput type="text" name="brand_name" value="#trim(get_brands.brand_name)#" maxlength="50" required="yes" message="#message#">
                                <span class="input-group-addon">
                                <cf_language_info 
                                    table_name="SETUP_BRAND" 
                                    column_name="BRAND_NAME" 
                                    column_id_value="#attributes.brand_id#" 
                                    maxlength="500" 
                                    datasource="#dsn#" 
                                    column_id="BRAND_ID" 
                                    control_type="0">
                                </span>
                            </div>
                        </div>
                    </div>           
                    <div class="form-group" id="item-it_asset">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="42310.IT Varlıkları"></label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="it_asset" id="it_asset" value=<cfoutput>"#get_brands.it_asset#"</cfoutput><cfif get_brands.it_asset eq 1>checked</cfif>>
                        </div>
                    </div>
                    <div class="form-group" id="item-motorized_vehicle">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='42311.Motorlu Taşıt'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="motorized_vehicle" id="motorized_vehicle" value=<cfoutput>"#get_brands.motorized_vehicle#"</cfoutput><cfif get_brands.motorized_vehicle eq 1>checked</cfif>>
                        </div>
                    </div>
                    <div class="form-group" id="item-physical_asset">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58833.Fiziki Varlık"></label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="physical_asset" id="physical_asset" value=<cfoutput>"#get_brands.physical_asset#"</cfoutput><cfif get_brands.physical_asset eq 1>checked</cfif>>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6 col-xs-12">
                    <cf_record_info query_name="get_brands">
                </div>
                <div class="col col-6 col-xs-12">
                    <cf_workcube_buttons is_upd='1' is_delete='0' add_function='control()'>
                </div>
            </cf_box_footer>        
        </cfform>        
    </cf_box>
</div>
<script type="text/javascript">
function control()
{
	if ((document.upd_brand.it_asset.checked) && (document.upd_brand.motorized_vehicle.checked))
	{  
		alert("<cf_get_lang no='830.Aynı Anda İki Kategoriyi Seçemezsiniz'>!");
		document.upd_brand.it_asset.checked = false;
		document.upd_brand.motorized_vehicle.checked = false;
		document.upd_brand.it_asset.focus();
		return false;
	}
	return true;
}
</script>
