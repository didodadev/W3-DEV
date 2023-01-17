<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box scroll="0">
        <cfform name="addform" method="post" action="#request.self#?fuseaction=jedi.package&event=add" enctype="multipart/formdata">
            <cf_box_elements>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-head">
                        <label class="col col-4 col-xs-12">Paket Adı*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="head" id="head" required>
                        </div>
                    </div>
                    <div class="form-group" id="item-is_active">
                        <label class="col col-4 col-xs-12">Aktif</label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_active" id="is_active" value="1">
                        </div>
                    </div>
                    <div class="form-group" id="item-zipfile">
                        <label class="col col-4 col-xs-12">Zip Dosyası*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="file" name="zipfile" id="zipfile" required>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <div class="row formContentFooter">
                <div class="col col-12">
                    <cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
                </div>
            </div>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    function kontrol() {
        return true;
    }
</script>