
<cf_xml_page_edit fuseact="objects.expense_cost">
<cf_get_lang_set module_name="objects">
<cfparam name="expense_id" default="">
<cf_catalystHeader>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='60673.Bütçe Uygunluk Kontrolü'></cfsavecontent>
<div class="col col-9 col-xs-12">
    <cf_box title="#title#" 
            closable="0" 
            refresh="1"
            box_page="#request.self#?fuseaction=objects.budget_compliance_check&expense_id=#attributes.expense_id#"
            >
    </cf_box>
</div>
<div class="col col-3 col-xs-12">
    <cf_get_workcube_note period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='49' action_section='EXPENSE_ID' action_id='#attributes.expense_id#'>
    <cf_get_workcube_asset  asset_cat_id='-17' module_id='49' action_section='EXPENSE_ID' action_id='#attributes.expense_id#' period_id='#session.ep.period_id#' company_id='#session.ep.company_id#'>
</div>