<cfparam name="attributes.keyword" default="">
<cfquery name="get_membership_stages" datasource="#dsn#">
	SELECT
		SETUP_MEMBERSHIP_STAGES.RECORD_EMP,
		SETUP_MEMBERSHIP_STAGES.TR_ID,
		SETUP_MEMBERSHIP_STAGES.TR_NAME,
		SETUP_MEMBERSHIP_STAGES.RECORD_DATE
	FROM
		SETUP_MEMBERSHIP_STAGES
	WHERE
		SETUP_MEMBERSHIP_STAGES.TR_ID IS NOT NULL
		<cfif len(attributes.keyword)>AND SETUP_MEMBERSHIP_STAGES.TR_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
	ORDER BY
		SETUP_MEMBERSHIP_STAGES.TR_ID
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_membership_stages.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
  <cf_box>
    <cfform name="search" action="#request.self#?fuseaction=crm.list_membership_stages" method="post">
      <cf_box_search more="0">
          <input type="hidden" value="<cfoutput>#attributes.keyword#</cfoutput>">
          <div class="form-group">
            <cfinput type="text" name="keyword" style="width:100px;" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="255">
          </div>
          <div class="form-group small">
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
          </div>
          <div class="form-group">
            <cf_wrk_search_button button_type="4">
          </div>
      </cf_box_search>
    </cfform>
  </cf_box>
</div>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
  <cfsavecontent variable="title"><cf_get_lang dictionary_id="36249.İlgilİ Sayfa"></cfsavecontent>
  <cf_box title="#title#" uidrop="1" hide_table_column="1">
    <cf_grid_list>
      <thead>
        <tr>
          <th><cf_get_lang dictionary_id='57756.Durum'></th>
          <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
          <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
          <th width="20"><a href="<cfoutput>#request.self#?fuseaction=crm.list_membership_stages&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></td>
        </tr>
      </thead>
      <tbody>
        <cfif get_membership_stages.recordcount>
          <cfoutput query="get_membership_stages" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
          <tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td>#tr_name#</td>
              <td>#get_emp_info(record_emp,0,1)#</td>
              <td>#dateformat(record_date,dateformat_style)#</td>
              <td width="20" align="right" style="text-align:right;"><a href="#request.self#?fuseaction=crm.list_membership_stages&event=upd&tr_id=#tr_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
          </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row" height="20">
            <td height="20" colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı!'></td>
          </tr>
        </cfif>
      </tbody>
  </cf_grid_list>


      <cfif attributes.totalrecords gt attributes.maxrows>
		  <cfset url_str = "">
      <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
        <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
      </cfif>
        <table cellpadding="0" cellspacing="0" border="0" width="99%" height="30" align="center">
          <tr>
            <td><cf_pages page="#attributes.page#"
              maxrows="#attributes.maxrows#"
              totalrecords="#attributes.totalrecords#"
              startrow="#attributes.startrow#"
              adres="settings.list_membership_stages#url_str#"> </td>
            <td align="right" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
          </tr>
        </table>
      </cfif>
    </cf_box>
  </div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
