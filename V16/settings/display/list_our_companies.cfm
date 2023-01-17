<cfinclude template="../query/get_our_companies.cfm">
<ul class="ui-list">
  <cfif OUR_COMPANY.recordcount>
    <cfoutput query="OUR_COMPANY">
      <li>
        <a onclick="send_ajax(#comp_id#)">
          <div class="ui-list-left">
            #COMPANY_NAME#
          </div>
        <div class="ui-list-right">
          <i class="fa fa-pencil"></i>
        </div>
      </a>
    </li>
    </cfoutput>
  <cfelse>
    <cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!
   </cfif>
</ul>
<script>
  function send_ajax(id){
    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=settings.form_upd_our_company&callAjax=1&is_settings_page=1&ourcompany_id=</cfoutput>' + id,'detail_div');               
  }
</script>
