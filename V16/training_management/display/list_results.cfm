<cfinclude template="../query/get_training_cats.cfm">
<cfinclude template="../query/get_quizs.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_quizs.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.training_cat_id")>
	<cfset url_str = "#url_str#&training_cat_id=#training_cat_id#">
</cfif>
<cfif isdefined("attributes.attenders")>
	<cfset url_str = "#url_str#&attenders=#attenders#">
</cfif>
<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0">
  <tr> 
      <td valign="top"> 

	  <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
        <tr> 
          <td class="headbold">
		   <cfif isdefined("attributes.training_cat_id")>
		  	<cfset attributes.training_cat_id = attributes.training_cat_id>
			<cfinclude template="../query/get_training_cat.cfm">
			<cfoutput>#get_training_cat.training_cat#</cfoutput>
		  <cfelse>
		  	<cf_get_lang no='9.Test Sonuçları'>
		   </cfif>
		  </td>
          <td valign="bottom" style="text-align:right;"> 
            <table>
              <cfform method="post" action="#request.self#?fuseaction=training_management.list_results">
                <tr> 
                  <td class="label"><cf_get_lang_main no='48.Filtre'>:</td>
                  <td> 
			  <cfif isdefined("attributes.keyword")>
                    <cfinput type="text" name="keyword" value="#attributes.keyword#">
				<cfelse>
                    <cfinput type="text" name="keyword">
				</cfif>
                  </td>
                  <td> 
                    <select name="training_cat_id" id="training_cat_id" style="width:125px;">
                        <option value="0" selected><cf_get_lang_main no='28.Egitim Yonetimi'>
                        <cfoutput query="get_training_cats"> 
                            <cfif isdefined("attributes.keyword")>
                            	<option value="#training_cat_id#" <cfif isdefined("attributes.training_cat_id") and len(attributes.training_cat_id) and attributes.training_cat_id eq training_cat_id>selected</cfif>>#training_cat# 
                            <cfelse>
                            	<option value="#training_cat_id#">#training_cat# 
                            </cfif>
                        </cfoutput> 
                    </select>
                  </td>
				<td>
					<select name="attenders" id="attenders">
					<cfif isdefined("attributes.attenders")>
						<option value="0" <cfif attributes.attenders eq 0>selected</cfif>><cf_get_lang_main no='540.Herkes'>
						<option value="1" <cfif attributes.attenders eq 1>selected</cfif>><cf_get_lang_main no='1463.Çalışanlar'>
						<option value="2" <cfif attributes.attenders eq 2>selected</cfif>><cf_get_lang_main no='1611.Kurumsal Üyeler'>
						<option value="3" <cfif attributes.attenders eq 3>selected</cfif>><cf_get_lang_main no='1609.Bireysel Üyeler'>
					<cfelse>
						<option value="0"><cf_get_lang_main no='540.Herkes'>
						<option value="1"><cf_get_lang_main no='1463.Çalışanlar'>
						<option value="2"><cf_get_lang_main no='1611.Kurumsal Üyeler'>
						<option value="3"><cf_get_lang_main no='1609.Bireysel Üyeler'>
					</cfif>
					</select>
                  </td>
                  <td> 
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                  </td>
                  <td><cf_wrk_search_button></td> 
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
      <table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
        <tr class="color-border"> 
          <td> 
            <table cellspacing="1" cellpadding="2" width="100%" border="0">
              <tr class="color-header"> 
                <td height="22" class="form-title" ><cf_get_lang_main no='1414.Test Başlığı'></td>
                <td class="form-title" ><cf_get_lang no='32.Amaç'></td>
                <td class="form-title" ><cf_get_lang no='42.Kimler Katılmalı'></td>
                <td class="form-title" ><cf_get_lang_main no='487.Kaydeden'></td>
                <td class="form-title" ><cf_get_lang_main no='215.Kayıt Tarihi'></td>
              </tr>
              <cfif get_quizs.recordcount>
              <cfoutput query="get_quizs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                  <td height="22"><a href="#request.self#?fuseaction=training_management.quiz_results&quiz_id=#quiz_id#" class="tableyazi">#QUIZ_HEAD#</a></td>
                  <td>#quiz_objective#</td>
                  <td> 
                    <cfif len(quiz_partners)>
                    <cf_get_lang_main no='173.Kurumsal Üyeler'>
                    </cfif>
                    <cfif len(quiz_partners) and ( len(quiz_consumers) or len(quiz_departments) )>
                    , 
                    </cfif>
                    <cfif len(quiz_consumers)>
                    <cf_get_lang_main no='174.Bireysel Üyeler'>
                    </cfif>
                    <cfif len(quiz_consumers) and len(quiz_departments)>
                    , 
                    </cfif>
                    <cfif len(quiz_departments)>
                    <cf_get_lang_main no='164.Çalışanlar'>
                    </cfif>
                  </td>
				  <td>
				  <cfif len(get_quizs.RECORD_EMP)>
	                   <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_quizs.RECORD_EMP#','medium')" class="tableyazi">#get_emp_info(RECORD_EMP,0,1)#</a>
				  <cfelseif len(RECORD_PAR)>
	                  <cfset attributes.partner_id = RECORD_PAR>
	                  <cfinclude template="../query/get_partner.cfm">
	                  <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_partner.PARTNER_ID#','medium');" class="tableyazi">#get_partner.company_partner_name# #get_partner.company_partner_surname#</a>
				  </cfif>
				  </td>
                  <td>#dateformat(record_date,dateformat_style)#</td>
                </tr>
              </cfoutput> 
              <cfelse>
              <tr class="color-row" height="20"> 
                <td colspan="5"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
              </tr>
              </cfif>
            </table>
          </td>
        </tr>
      </table>
      <cfif get_quizs.recordcount>
	  <cfif attributes.totalrecords gt attributes.maxrows>
      <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
        <tr> 
          <td> <cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="training_management.list_results#url_str#"> 
          </td>
          <!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
        </tr>
      </table>
      </cfif>
	  </cfif>
    </td>
  </tr>
</table>

