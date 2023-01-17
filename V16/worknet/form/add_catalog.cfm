<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_catalog" id="add_catalog">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <cf_duxi name="catalog_status" type="checkbox" label="57493" hint="Aktif"> 
                    <cf_duxi name="process_stage" label="58859" hint="süreç" required="yes">
                        <cf_workcube_process is_upd='0' is_detail='0'>
                    </cf_duxi>   
                    <cf_duxi name="catalog_head" type="text" label="46976" hint="Başlık" required="yes"> 
                    <cf_duxi name="catalog_no" type="text" label="42408" hint="Katalog no" required="yes"> 
                    <cf_duxi name="friendly_url" type="text" label="63171" hint="Friendly url" required="yes"> 
                    <cf_duxi name="catalog_detail" type="textarea" label="57771" hint="Detay" required="yes"> 
                    </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <cf_duxi name="startdate" type="text" data_control="date" label="58053" hint="Başlangıç" required="yes"> 
                    <cf_duxi name="finishdate" type="text" data_control="date" label="57700" hint="Bitiş" required="yes"> 
                    <cf_duxi name="money" type="text" label="55842" hint="Para"> 
                    <cf_duxi name="price" type="text" label="58084" hint="Fiyat">
                    <cf_duxi name="barcod" type="text" label="57633" hint="Barkod"> 
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <cf_duxi name="target_company" type="hidden"> 
                    <cf_duxi name="target" type="text" label="29533" hint="Tedarikçi" threepoint="#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=add_catalog.target_company&field_comp_name=add_catalog.target&select_list=2">
                    <cf_duxi name="campaign_id" type="hidden">
                    <cf_duxi name="camp_name" type="text" label="57446" hint="Kampanya" threepoint="#request.self#?fuseaction=objects.popup_list_campaigns&field_id=add_catalog.campaign_id&field_name=add_catalog.camp_name">
                    <cf_duxi name="validate_date" type="text" data_control="date" label="63845" hint="Hazırlık tarihi"> 
                    <cf_duxi name="valid_emp" type="hidden">
                    <cf_duxi name="valid_name" type="text" label="29775" hint="Hazırlayan" threepoint="#request.self#?fuseaction=objects.popup_list_positions&field_name=add_catalog.valid_name&field_id=add_catalog.valid_emp&select_list=1">                        
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' data_action ="/V16/worknet/cfc/worknet:add_catalog" next_page="#request.self#?fuseaction=watalogy.catalog&event=upd&id=">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>