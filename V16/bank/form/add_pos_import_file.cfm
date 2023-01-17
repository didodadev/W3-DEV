<cf_catalystHeader>
<cfform name="pos_import" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=bank.emptypopup_add_pos_import_file">
	<div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-4 col-md-6 col-sm-8 col-xs-12" type="column" index="1" sort="true">
                    	<div class="form-group" id="item-bank_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='109.Banka'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="bank_type" id="bank_type" style="width:200px;">
				                    <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
				                    <option value="10"><cf_get_lang dictionary_id="48737.Akbank"></option>
				                    <option value="11"><cf_get_lang dictionary_id="48730.İş Bankası"></option>
				                    <option value="12"><cf_get_lang dictionary_id="48720.HSBC"></option>
				                    <option value="13"><cf_get_lang dictionary_id="57717.Garanti"></option>
				                    <option value="14"><cf_get_lang dictionary_id="42723.YapıKredi"></option>
				                    <option value="15"><cf_get_lang dictionary_id="48765.Finansbank"></option>
				                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-uploaded_file">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='56.Belge'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="file" name="uploaded_file" style="width:200px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-process_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='330.Tarih'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                	<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
									<cfinput required="Yes" value="#dateformat(now(),dateformat_style)#"message="#message#" type="text" name="process_date" style="width:180px;" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="process_date"></span>
                                </div>
                            </div>
                        </div>
                    </div>
    			</div>
                <div class="row formContentFooter">
                    <div class="col col-12">
                        <cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
                    </div>
                </div>
    		</div>
    	</div>
    </div>
</cfform>
<script type="text/javascript">
function kontrol()
{
	if(pos_import.bank_type.value=="")
	{
		alert("<cf_get_lang no ='88.Banka Seçiniz'>!");
		return false;
	}
	return true;
}
</script>
