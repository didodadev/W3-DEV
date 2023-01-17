<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
  <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.sz_id") and len(attributes.sz_id)>
  <cfset url_str = "#url_str#&sz_id=#attributes.sz_id#">
</cfif>
<cfif isdefined("attributes.send")>
<cfquery name="add_ims_relation" datasource="#DSN#">
	INSERT INTO 
		SALES_ZONES_IMS_RELATION 
	(
		SZ_ID,
		IMS_ID,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP 
	)
		VALUES 
	(
		#attributes.sz_id#,
		#attributes.ims_code_id#,
		#now()#,
		#session.ep.userid#, '#cgi.remote_addr#'
	)
</cfquery>
<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
</cfif>
<cfinclude template="../query/get_ims.cfm">
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='50'>
<cfparam name="attributes.totalrecords" default='#get_ims.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
  <tr>
    <td clasS="headbold"><cf_get_lang dictionary_id='52400.IMS Kodu'></td>
    <td  style="text-align:right;">
      <table>
        <cfform name="ims" action="#request.self#?fuseaction=objects.popup_ims" method="post">
          <cfif isdefined("attributes.sz_id")>
            <input type="hidden" value="<cfoutput>#attributes.sz_id#</cfoutput>" name="sz_id" id="sz_id">
          </cfif>
          <cfif isdefined("attributes.send")>
            <input type="hidden" value="1" name="send" id="send">
          </cfif>
          <tr>
            <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
            <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
            <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
              	<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
  	        <td><cf_wrk_search_button></td>
          </tr>
        </cfform>
      </table>
    </td>
  </tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr clasS="color-border">
    <td>
      <table cellpadding="2" cellspacing="1" border="0" width="100%">
        <tr clasS="color-header" height="22">
          <td width="30" class="form-title"><cf_get_lang dictionary_id='57487.No'></td>
          <td class="form-title"><cf_get_lang dictionary_id='52400.IMS Kodu'></td>
          <td class="form-title"><cf_get_lang dictionary_id='52254.IMS'> <cf_get_lang dictionary_id='57897.Adı'></td>
        </tr>
        <cfif get_ims.recordcount>
          <cfoutput query="get_ims" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td>#ims_code_id#</td>
              <td><a href="#request.self#?fuseaction=objects.popup_ims&ims_code_id=#ims_code_id#&sz_id=#sz_id#&send=1" class="tableyazi">#ims_code#</a></td>
              <td>#ims_code_name#</td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row" height="20">
            <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table cellpadding="0" cellspacing="0" border="0" width="98%" align="center" height="35">
    <tr>
      <td><cf_pages 
		  page="#attributes.page#" 
		  maxrows="#attributes.maxrows#" 
		  totalrecords="#attributes.totalrecords#" 
		  startrow="#attributes.startrow#" 
		  adres="objects.popup_ims#url_str#"></td>
      <!-- sil -->
      <td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td>
      <!-- sil -->
    </tr>
  </table>
</cfif>
