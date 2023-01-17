<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cf_box title="#getLang('','Müşteri Bilgisi',52125)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
  <cfform name="formexport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=crm.emptypopupflush_add_branch_value">
    <div class="col col-8 col-md-8 col-sm-12 col-xs-12">
      <cf_box_elements>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
              <div class="form-group">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                  <select name="branch_id" id="branch_id">
                      <cfoutput query="get_branch">
                          <option value="#branch_id#">#branch_name#</option>
                      </cfoutput>
                  </select>
                </div>
              </div>
          <div class="form-group">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59088.Tip'>*</label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
              <select name="document_type" id="document_type">
                  <option value="1">CSV</option>
              </select>
            </div>
          </div>
          <div class="form-group">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
              <input type="file" name="import_file">
            </div>
          </div>
        </div>
      </cf_box_elements>
    </div>
    <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
      <table border="0" align="left">
        <tr>
          <td colspan="2">
            <b><cf_get_lang dictionary_id='58594.Format'></b><br/>
            <cf_get_lang dictionary_id='44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır. Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır .'> 
            <cf_get_lang dictionary_id='62372.Belgede toplam 9 alan olacaktır. Alanlar sırası ile'>;<br/>
          </td>
        </tr>
        <tr>
          <td colspan="2">1 - <cf_get_lang dictionary_id='52115.Hedef Kodu'></td>
        </tr>
        <tr>
          <td colspan="2">2 - <cf_get_lang dictionary_id='58811.Muhasebe Kodu'></td>
        </tr>
        <tr>
          <td colspan="2">3 - <cf_get_lang dictionary_id='30057.Ödeme Şekli'></td>
        </tr>
        <tr>
          <td colspan="2">4 - <cf_get_lang dictionary_id='58984.Puan'></td>
        </tr>
        <tr>
          <td colspan="2">5 - <cf_get_lang dictionary_id='51582.Risk Limiti'></td>
        </tr>
        <tr>
          <td colspan="2">6 - <cf_get_lang dictionary_id='57992.Bölge'></td>
        </tr>
        <tr>
          <td colspan="2">7 - <cf_get_lang dictionary_id='57986.Alt'> <cf_get_lang dictionary_id='57992.Bölge'></td>
        </tr>
        <tr>
          <td colspan="2">8 - <cf_get_lang dictionary_id='52046.Cep Sıra'></td>
        </tr>
        <tr>
          <td colspan="2">9 - <cf_get_lang dictionary_id='51740.uzaklık'></td>
        </tr>
      </table>
		</div>
    <cf_box_footer>
      <cf_workcube_buttons is_upd='0' add_function="control() && loadPopupBox('formexport')">
    </cf_box_footer>
 </cfform>
</cf_box>
<script type="text/javascript">
function control()
{	
	if (formexport.baslik.value == "")
	{
		alert("<cf_get_lang dictionary_id='31595.Lütfen Başlık Giriniz'>!");
		formexport.baslik.focus();
		return false;
	}
	if (formexport.uploaded_file.value == "")
	{
		alert("<cf_get_lang dictionary_id='52351.Lütfen Belge Seçiniz'>!");
		formexport.uploaded_file.focus();
		return false;
	}
}
</script>
