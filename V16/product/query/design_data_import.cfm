<!--- Yükleme klasörü yoksa oluşturuyor. --->
<cfif Not directoryExists('#upload_folder##dir_seperator#Product-Design-Data')>
	<cfdirectory action="create" directory="#upload_folder##dir_seperator#Product-Design-Data">
</cfif>

<cftry>
    <cfset file_name = createUUID()>
    <cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="template_file" destination="#upload_folder##dir_seperator#Product-Design-Data">
    <cffile action="rename" source="#upload_folder##dir_seperator#Product-Design-Data#dir_seperator##cffile.serverfile#" destination="#upload_folder##dir_seperator#Product-Design-Data#dir_seperator##file_name#.#cffile.serverfileext#">
    

    <cfcatch>
        <cfdump var="#cfcatch#">
        <script type="text/javascript">
            alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
            closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
            openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.design_data&event=import&product_sample_id=#attributes.product_sample_id#&data_type=#attributes.data_type#&main_product_id=#attributes.main_product_id#&stock_id=#attributes.main_stock_id#</cfoutput>','','ui-draggable-box-large');
        </script>
        <cfabort>
    </cfcatch>
</cftry>

<cfset data_component = createObject("component","V16.product.cfc.design_data")>
<cfset add_design_data_import = data_component.ADD_DESIGN_DATA_IMPORT(
    design_data_file_path : "#file_name#.#cffile.serverfileext#",
    product_sample_id : attributes.product_sample_id,
    product_id : attributes.product_id,
    product_desing_data_settings_id : attributes.product_desing_data_settings_id
)>
<script>
    closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
    openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.design_data&event=import&product_sample_id=#attributes.product_sample_id#&data_type=#attributes.data_type#&file_name=#file_name#.#cffile.serverfileext#&file_id=#add_design_data_import.identity#&main_product_id=#attributes.main_product_id#&stock_id=#attributes.main_stock_id#</cfoutput>','','ui-draggable-box-large');
</script>