<cfinclude template="get_surveys.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default=20>
<cfparam name="attributes.totalrecords" default="#get_surveys.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr class="color-list" height="22">
          <td class="txtboldblue"> 
		  <a href="javascript://" onclick="gizle_goster_img('list_survey_img1','list_survey_img2','list_survey_menu');"><img src="/images/listele_down.gif" title="<cf_get_lang no='116.Ayrıntıları Gizle'>" width="12" height="7" border="0" align="absmiddle" id="list_survey_img1" style="display:;cursor:pointer;"></a>
		  <a href="javascript://" onclick="gizle_goster_img('list_survey_img1','list_survey_img2','list_survey_menu');"><img src="/images/listele.gif" title="<cf_get_lang no='337.Ayrıntıları Göster'>" width="7" height="12" border="0" align="absmiddle" id="list_survey_img2" style="display:none;cursor:pointer;"></a>
		  <cf_get_lang no='83.Gündemdeki Anketler'> </td>
        </tr>
        <tr class="color-row" id="list_survey_menu">
          <td>
            <table cellSpacing="0" cellpadding="0" width="100%" border="0">
                <cfoutput query="get_surveys" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td width="10">*</td>
                    <td><a href="#request.self#?fuseaction=campaign.form_vote_survey&survey_id=#survey_id#" class="tableyazi">#survey_head#</a></td>
                  </tr>
                </cfoutput>
              <cfif not get_surveys.recordcount>
                <tr>
                  <td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<br/>

