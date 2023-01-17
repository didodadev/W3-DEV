
<cf_box title="#getlang('','Üye Analiz Formu Dönem Ekle',836)#">
  <cfform name="member_analysis_period" method="post" action="#request.self#?fuseaction=settings.emptypopup_member_analysis_period_add">
    <cf_box_elements>
      <div class="col col-3 col-xs-12">
        <div class="scrollbar" style="max-height:403px;overflow:auto;">
          <div id="cc">
            <cfinclude template="../display/list_member_analysis_period.cfm">
          </div>
        </div>
      </div>
      <div class="col col-4 col-xs-12">
        <div class="form-group">
          <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'>*</label>
          <div class="col col-8 col-xs-12">
            <cfinput type="Text" name="period" id="period" style="width:200px;" value="" maxlength="20" required="Yes">
          </div>
        </div>
      </div>
    </cf_box_elements>
    <cf_box_footer>
      <cf_workcube_buttons add_function="kontrol()" is_upd='0'>
    </cf_box_footer>
  </cfform>
</cf_box>
<script>
  function kontrol(){
      if(document.member_analysis_period.period.value == "")
          {
              alert("<cf_get_lang dictionary_id='49186.Dönem girmelisiniz'>!");
              return false;
          }		
  }
</script>