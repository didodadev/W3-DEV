<cfinclude template="../query/get_main_process_cats.cfm">
<cf_flat_list>
  <tbody>
      <tr>
        <cfif get_main_process_cats.recordcount>
          <cfoutput query="get_main_process_cats">
            <tr>
              <td width="15" align="right" valign="baseline"><i class="fa fa-cube" style="color:##FF9800;"></i></td>
              <td><a href="#request.self#?fuseaction=settings.form_upd_main_process_cat&process_cat_id=#main_process_cat_id#">#main_process_cat#</a></td>
            </tr>  
          </cfoutput>  
        <cfelse>
          <tr>
            <td width="15" align="right" valign="baseline"><i class="fa fa-cube" style="color:##FF9800;"></i></td>
            <td><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
          </tr>
        </cfif>
      </tr>
  </tbody>
</cf_flat_list>

