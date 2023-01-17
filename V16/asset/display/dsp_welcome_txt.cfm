
<cfoutput>
 
	<div class="pagemenus_container">
        <cf_box title="#getLang('','Dijital Varlıklar Menü','64059')#">
        <ul class="pagemenus">
            <cfsavecontent variable="head_1"><cf_get_lang_main no='150.Dijital Varlıklar'></cfsavecontent>
                <cf_box title="#head_1#">
                    <cfif not listfindnocase(denied_pages,'asset.list_asset')><li><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i><a href="#request.self#?fuseaction=asset.list_asset"><cf_get_lang_main no='150.Dijital Varlıklar'></a></li></cfif>
                    <cfif not listfindnocase(denied_pages,'asset.form_add_asset')><li><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i><a href="#request.self#?fuseaction=asset.list_asset&event=add"><cf_get_lang no='69.Dijital Varlık Ekle'></a></li></cfif>
                </cf_box>
        </ul>
        <ul class="pagemenus">
                <cfsavecontent variable="head_2"><cf_get_lang no='100.Kütüphane Listesi'></cfsavecontent>
                    <cf_box title="#head_2#">
                    <cfif not listfindnocase(denied_pages,'asset.library')><li><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i><a href="#request.self#?fuseaction=asset.library"><cf_get_lang_main no='285.Kütüphane'></a></li></cfif>
                    <cfif not listfindnocase(denied_pages,'asset.popup_list_lib_book_rezervation')><li><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=asset.popup_list_lib_book_rezervation</cfoutput>','medium')"><cf_get_lang no='7.Rezervasyonlar'></a></li></cfif>
                    <cfif not listfindnocase(denied_pages,'asset.popup_add_list_library_asset')><li><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=asset.popup_add_list_library_asset</cfoutput>','medium')"><cf_get_lang_main no='285.Kütüphane'> <cf_get_lang no='154.Varlığı'>  <cf_get_lang_main no='170.Ekle'></a></li></cfif>
                </cf_box>
            
        </ul>
        <ul class="pagemenus">
                <cfsavecontent variable="head_3"><cf_get_lang no='4.Ortak Kullanım'></cfsavecontent>
                    <cf_box title="#head_3#">
                    <cfif not listfindnocase(denied_pages,'asset.list_assetp')><li><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i><a href="#request.self#?fuseaction=asset.list_assetp"><cf_get_lang no='4.Ortak Kullanım'></a></li></cfif>
                    </cf_box>
            
        </ul>
    </cf_box>
    </div>
</cfoutput>

<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>

