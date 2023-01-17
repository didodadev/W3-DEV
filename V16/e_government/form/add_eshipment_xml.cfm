<div class="col col-12">
<cf_box draggable="1" title="XML Ekle" closable="1">
    <cfset eshipment = createObject("component","V16.e_government.cfc.eirsaliye.common")>
    <cfset get_our_company = eshipment.get_our_company_fnc(session.ep.company_id)>
    <cfif len(get_our_company.is_eshipment)>
        <cfform name="upload_form_page" enctype="multipart/form-data" action="V16/e_government/query/add_eshipment_xml.cfm">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-file">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'> *</label>
                        <div class="col col-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;">
                        </div>
                    </div>
                    <!--- <div class="form-group" id="item-process">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>
                        </div>
                    </div> --->
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0' is_cancel="0" is_delete=0 add_function='ekle_form_action()'>
                </div>
            </cf_box_footer>
        </cfform>
    <cfelse>
        <cf_get_lang dictionary_id="57532.Yetkiniz yok!">   
    </cfif>
</cf_box>
</div>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="54246.Belge Seçmelisiniz"></cfsavecontent>
<script type="text/javascript">
    function ekle_form_action()
    {
        if(document.getElementById('uploaded_file').value == "")
        {
            alertObject({message:"<cfoutput>#message#</cfoutput>"})
            return false;
        }
      //  return process_cat_control();
    }
</script>