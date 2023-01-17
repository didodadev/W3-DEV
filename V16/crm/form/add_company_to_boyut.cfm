<!--- Aktarım İşlemi Boyunca Her Şube Geçişinde  Aşağıdaki Listeye Yeni Şubeler Eklenecektir. --->
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT BRANCH_NAME, BRANCH_ID FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cf_box title="#getLang('','',52127)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
      <cfform name="add_company_assistance_info_" method="post" action="#request.self#?fuseaction=crm.emptypopupflush_add_company_to_boyut">
        <cf_box_elements>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="branch_id" id="branch_id">
                            <option value=""><cf_get_lang_main no='41.Şube'></option>
                            <cfoutput query="get_branch">
                                <option value="#branch_id#">#branch_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                   <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58053.B Tarih'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message4"><cf_get_lang_main no='326.Başlangıç Tarihi Girmelisiniz'> </cfsavecontent>
                            <cfinput type="text" name="start_date" value="" maxlength="10" validate="#validate_style#" required="yes" message="#message4#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                   <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarih'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message5"><cf_get_lang dictionary_id='58491.Bitiş Tarihi Giriniz!'></cfsavecontent>
                            <cfinput type="text" name="finish_date" value="" maxlength="10" validate="#validate_style#" required="yes" message="#message5#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59088.Tip'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="insert_type" id="insert_type">
                            <option value="3"><cf_get_lang dictionary_id='52130.Validasyon'></option>
                            <option value="4"><cf_get_lang dictionary_id='58826.Test'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='89.Başlangıç'>*</label>
                    <cfsavecontent variable="date_message"><cf_get_lang no ='685.Lütfen Başlangıç Değeri Giriniz'></cfsavecontent>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cfinput type="text" name="start_count" required="yes" validate="integer" message="#date_message#">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='90.Bitiş'>*</label>
                    <cfsavecontent variable="date_message"><cf_get_lang no ='958.Lütfen Bitiş Değeri Giriniz '></cfsavecontent>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cfinput type="text" name="finish_count" required="yes" validate="integer" message="#date_message#">
                    </div>
                </div>
            </div>
       </cf_box_elements>
       <cf_box_footer><cf_workcube_buttons is_upd='0' add_function="kontrol() && loadPopupBox('add_company_assistance_info_')"></cf_box_footer>
      </cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	confirm("<cf_get_lang no ='959.Yapacağınız Toplu Aktarım Boyutu Etkileyecektir Emin misiniz'> !");
}
</script>
