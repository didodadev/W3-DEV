<script type="text/javascript" src="/JS/widget/domdrag.js"></script>
<script type="text/javascript" src="/JS/widget/homebox.js"></script>
<h3><cf_get_lang no="290.Worknet Dashboards"></h3>
<br>
<div class="row">
    <div class="col col-6 col-xs-12">
        <cfsavecontent variable="message"><cf_get_lang no="291.Üye Başvuruları"></cfsavecontent>
        <cf_box dragDrop="1" id="member" title="#message#" closable="0" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['companies']['fuseaction']#"></cf_box>
        <cfsavecontent variable="message"><cf_get_lang_main no="152.Ürünler"></cfsavecontent>
        <cf_box dragDrop="1" id="product" title="#message#" closable="0" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['products']['fuseaction']#"></cf_box>
        <cfsavecontent variable="message"><cf_get_lang no="182.Kataloglar"></cfsavecontent>
        <cf_box dragDrop="1" id="catalog" title="#message#" closable="0" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['catalogs']['fuseaction']#"></cf_box>
    </div>
    <div class="col col-6 col-xs-12">
        <cfsavecontent variable="message"><cf_get_lang_main no="115.Talepler"></cfsavecontent>
        <cf_box dragDrop="1" id="demand" title="#message#" closable="0" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['demands']['fuseaction']#"></cf_box>
        <cfsavecontent variable="message"><cf_get_lang_main no="1317.Etkileşimler"></cfsavecontent>
        <cf_box dragDrop="1" id="interaction" title="#message#" closable="0" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['interactions']['fuseaction']#"></cf_box>
        <cfsavecontent variable="message"><cf_get_lang no="292.Grafik"></cfsavecontent>
        <cf_box dragDrop="1" id="graphic" title="#message#" closable="0" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['chart']['fuseaction']#"></cf_box>
    </div>
</div>