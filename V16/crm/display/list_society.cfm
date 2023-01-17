<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submit")>
    <cfquery name="GET_CORP" datasource="#DSN#">
        SELECT 
            * 
        FROM 
            SETUP_CORPORATIONS
        WHERE 
            CORPORATION_ID IS NOT NULL
            <cfif len(attributes.keyword)>
             AND
             (
             CORPORATION_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
             CORPORATION_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
             )
            </cfif>
    </cfquery>
<cfelse>
	<cfset GET_CORP.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.totalrecords" default='#get_corp.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id='51544.Çalışılan Kurumlar'></cfsavecontent>
<cf_box title="#head#" uidrop="1" hide_table_column="1" resize="0" collapsable="0">
  <cfform name="search_corp" action="#request.self#?fuseaction=crm.list_society" method="post">
    <cf_box_search more="0">   
        <input type="hidden" name="form_submit" id="form_submit" value="1" />
        <div class="form-group">
          <cfsavecontent  variable="filtre"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
          <cfinput type="text" name="keyword" placeholder="#filtre#" value="#attributes.keyword#">
        </div>
        <div class="form-group small">
          <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
          <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)">
        </div>
        <div class="form-group">
          <cf_wrk_search_button button_type="4">
        </div>                
    </cf_box_search>
  </cfform>
    <cf_grid_list>
      <thead>
        <tr height="20" class="color-header">
          <th class="form-title" width="30"><cf_get_lang_main no='75.No'></th>
          <th class="form-title" width="200"><cf_get_lang no='38.Kurum Kodu'> </th>
          <th class="form-title" width="350"><cf_get_lang no='39.Kurum Adı'></th>
          <th class="form-title"><cf_get_lang_main no='217.Açıklama'></th>
          <th width="15"><a href="javascript://"  onClick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_add_corp</cfoutput>','small');"><img src="/images/plus_square.gif" alt="<cf_get_lang no='146.Ürün Kategorisi Ekle'>" border="0" align="absmiddle"></a></th>
          <!-- sil -->
        </tr>
      </thead>
      <tbody>
        <cfif get_corp.recordcount>
          <cfoutput query="get_corp" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td>#currentrow#</td>
              <td>#corporation_code#</td>
              <td>#corporation_name#</td>
              <td>#corporation_detail#</td>
              <td width="15" align="right" style="text-align:right;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_upd_corp&c_id=#get_corp.CORPORATION_ID#','small');"><img src="/images/update_list.gif" alt="<cf_get_lang no='146.Ürün Kategorisi Ekle'>" border="0" align="absmiddle"></a></td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr height="20" class="color-row">
            <td colspan="7"><cfif isdefined("attributes.form_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no="289.Filtre Ediniz">!</cfif></td>
          </tr>
        </cfif>
      </tbody>
      <cfif attributes.totalrecords gt attributes.maxrows>
          <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
            <cfset url_string = "#url_string#&keyword=#attributes.keyword#">
          </cfif>
          <cfif isDefined('attributes.form_submit') and len(attributes.form_submit)>
            <cfset url_string = "#url_string#&form_submit=#attributes.form_submit#">
          </cfif>
          <cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="settings.list_society#url_string#">
      </cfif>
    </cf_grid_list>
</cf_box>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
