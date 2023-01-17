<cfinclude template="../query/get_eval_quizes.cfm">
      <table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td class="headbold"><cf_get_lang no='185.Eğitim Değerlendirme Formları'></td>
        </tr>
      </table>
      <table width="98%" align="center" cellpadding="0" cellspacing="0">
        <tr class="color-border">
          <td valign="top">
            <table width="100%" cellspacing="1" cellpadding="2">
              <tr class="color-header" height="22">
                <td class="form-title"><cf_get_lang_main no='1967.form'></td>
				<td width="50" class="form-title"><cf_get_lang_main no='344.Durum'>
				<td width="15"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.form_add_eval_quiz"><img border="0" src="images/plus_square.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></td>				
              </tr>
				<cfparam name="attributes.page" default='1'>
				<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
				<cfparam name="attributes.totalrecords" default='#get_all_quiz.recordcount#'>
				<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
			    <cfif get_all_quiz.RecordCount>
				  <cfoutput query="get_all_quiz" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 			  
					   <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td> 
								<a href="#request.self#?fuseaction=training_management.dsp_eval_quiz&quiz_id=#QUIZ_ID#"  class="tableyazi">#QUIZ_HEAD#</a>
							</td>
							<td> 
							<cfif IS_ACTIVE IS 1>
							  <cf_get_lang_main no='81.Aktif'>
							<cfelse>
							  <cf_get_lang_main no='82.Pasif'>
							</cfif>
							</td>
							<td>
								<a href="#request.self#?fuseaction=training_management.dsp_eval_quiz&quiz_id=#QUIZ_ID#" ><img border="0"  src="images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>"></a>
							</td>							
					  </tr>
				  </cfoutput> 
                <cfelse>
				  <tr class="color-row" height="20"> 
					<td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
				  </tr>
                </cfif>
            </table>
          </td>
        </tr>
      </table>
  	 <cfif get_all_quiz.RECORDCOUNT and (attributes.totalrecords gt attributes.maxrows)>
        <table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
          <tr>
            <td class="label"> <cf_pages 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="training_management.list_training_eval"> </td>
            <!-- sil --><td class="label" style="text-align:right;"> <cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
          </tr>
        </table>
      </cfif>
<br/>

