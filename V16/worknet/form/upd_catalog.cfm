<cfset cmp = createObject("component","V16.worknet.cfc.worknet")>
<cfset get_catalog = cmp.get_catalog(catalog_id : attributes.id)>
<cf_box_data asname="data_catalog" function="V16.worknet.cfc.worknet:get_catalog" conditions="catalog_id=attributes.id">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="Kampanya Güncelle" popup_box="1">
        <cfform name="upd_catalog" id="upd_catalog">
            <cf_duxi name="catalog_id" type="hidden" value="#attributes.id#">
            <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <cf_duxi name="catalog_status" type="checkbox" label="57493" hint="Aktif" data="data_catalog.catalog_status" value="1"> 
                        <cf_duxi name="process_stage" label="58859" hint="süreç" required="yes">
                            <cf_workcube_process fusepath="watalogy.catalog" is_upd="0" is_detail='1' select_value="#data_catalog.stage_id#">
                        </cf_duxi>   
                        <cf_duxi name="catalog_head" type="text" label="46976" hint="Başlık" data="data_catalog.catalog_head" required="yes"> 
                        <cf_duxi name="catalog_no" type="text" label="42408" hint="Katalog no" data="data_catalog.catalog_no" required="yes"> 
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <cf_duxi name="friendly_url" type="text" label="63171" hint="Friendly url" data="data_catalog.friendly_url" required="yes"> 
                        <cf_duxi name="startdate" type="text" data_control="date" label="58053" hint="Başlangıç" data="data_catalog.startdate" required="yes"> 
                        <cf_duxi name="finishdate" type="text" data_control="date" label="57700" hint="Bitiş" data="data_catalog.finishdate" required="yes">
                        <cf_duxi name="catalog_detail" type="textarea" label="57771" hint="Detay" data="data_catalog.catalog_detail" required="yes"> 
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <cf_duxi name="target_company" type="hidden" data="data_catalog.target_company"> 
                        <cf_duxi name="target" type="text" label="29533" hint="Tedarikçi" threepoint="#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=add_catalog.target_company&field_comp_name=add_catalog.target&select_list=2" data="data_catalog.fullname">
                        <cf_duxi name="campaign_id" type="hidden" data="data_catalog.campaign_id">
                        <cf_duxi name="camp_name" type="text" label="57446" hint="Kampanya" data="data_catalog.camp_head" threepoint="#request.self#?fuseaction=objects.popup_list_campaigns&field_id=add_catalog.campaign_id&field_name=add_catalog.camp_name">                            
                        <cf_duxi name="validate_date" type="text" data_control="date" label="63845" data="data_catalog.validate_date" hint="Hazırlık tarihi"> 
                        <cf_duxi name="valid_emp" type="hidden" data="data_catalog.valid_emp">
                        <cf_duxi name="valid_name" type="text" label="29775" hint="Hazırlayan" threepoint="#request.self#?fuseaction=objects.popup_list_positions&field_name=add_catalog.valid_name&field_id=add_catalog.valid_emp&select_list=1" data="data_catalog.name">                            
                    </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd="1" data_action ="/V16/worknet/cfc/worknet:upd_catalog" next_page="#request.self#?fuseaction=watalogy.catalog&event=det&id=" del_action="V16/worknet/cfc/worknet:del_catalog:" del_next_page="#request.self#?fuseaction=watalogy.catalog">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>