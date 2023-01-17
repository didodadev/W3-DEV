<cfsetting requestTimeOut = "10000">

<cfif isDefined("upload")>
    <cfinclude template="../query/import_dictionary.cfm">
    <cfabort>
</cfif>
<cfquery name="get_language" datasource="#dsn#">
    SELECT * FROM SETUP_LANGUAGE
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Sözlük Import',63028)#">
        <cfform name="import_dictionary" enctype="multipart/form-data" method="post" action="">
            <input type="hidden" name="upload" id="upload" value="1">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold"><cf_get_lang dictionary_id='63039.Import Etmek istediğiniz dilleri seçiniz'>. <cf_get_lang dictionary_id='63040.Max 3 adet seçebilirsiniz'>!</label>
                    </div>
                    <cfoutput query="get_language">
                        <div class="form-group" id="item-">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">#language_set#</label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" name="langs" id="langs" value="#UCase(LANGUAGE_SHORT)#">
                            </div>
                        </div>
                    </cfoutput>
                    <div class="form-group" id="item-">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'> *</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
						<label style="font-size:17px;"><b><cf_get_lang dictionary_id='58594.Format'></b></label>
					</div>
                    <div class="form-group" id="item-exp1">
                        <cfset getImportExpFormat("import_dictionary") />
					</div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

<script type="text/javascript">
    function kontrol()
    {
        if($("#langs:checked").length == 0){
            alert('<cf_get_lang dictionary_id='63032.En az bir dil seçiniz!'>');
            return false;
        }
        if($("#langs:checked").length > 3){
            alert("<cf_get_lang dictionary_id='63040.Max 3 adet seçebilirsiniz'>");
            return false;
        }
        if(import_dictionary.uploaded_file.value.length==0)
        {
            alert("<cf_get_lang dictionary_id ='43930.İmport Edilecek Belge Girmelisiniz'>!");
            return false;
        }
        return true;
    }
</script>