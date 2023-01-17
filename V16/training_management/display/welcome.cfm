<cfinclude template="../query/get_trainings.cfm">
<cfinclude template="../query/get_quizs.cfm">
<cfinclude template="../query/get_training_cats.cfm">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang_main no='28.egitim yonetimi'></td>
  </tr>
</table>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td valign="top">
      <!--- En Yeni Konular 10 adet --->
      <table border="0" width="98%" cellpadding="0" cellspacing="0" class="color-border">
        <tr>
          <td>
            <table border="0" width="100%" cellpadding="2" cellspacing="1">
              <tr class="color-header">
                <td class="form-title" height="22" colspan="6"><cf_get_lang no='71.Yeni Konular'></td>
              </tr>
              <tr class="color-list" height="22">
                <td class="txtboldblue" width="150"><cf_get_lang_main no='68.Konu'></td>
                <td class="txtboldblue"><cf_get_lang no='72.Kimler Almalı'></td>
              </tr>
              <cfoutput query="get_trainings" maxrows="20">
                <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                  <td><a href="#request.self#?fuseaction=training_management.training_subject&train_id=#train_id#" class="tableyazi">#train_head#aaaaaaaaa</a></td>
                  <td>
                    <cfif len(train_partners)>
                      <cf_get_lang_main no='1611.Kurumsal Üyeler'>
                    </cfif>
                    <cfif len(train_partners) and ( len(train_consumers) or len(train_departments) )>
                      ,
                    </cfif>
                    <cfif len(train_consumers)>
                      <cf_get_lang_main no='1609.Bireysel Üyeler'>
                    </cfif>
                    <cfif len(train_consumers) and len(train_departments)>
                      ,
                    </cfif>
                    <cfif len(train_departments)>
                      <cf_get_lang_main no='1463.Çalışanlar'>
                    </cfif>
                  </td>
                </tr>
              </cfoutput>
            </table>
          </td>
        </tr>
      </table>
      <!--- En Yeni Konular Bİtti --->
      <br/>
      <!--- En Yeni testler 10 adet --->
      <table border="0" width="98%" cellpadding="0" cellspacing="0" class="color-border">
        <tr>
          <td>
            <table border="0" width="100%" cellpadding="2" cellspacing="1">
              <tr class="color-header">
                <td class="form-title" height="22" colspan="6"><cf_get_lang_main no='639.Testler'></td>
              </tr>
              <tr class="color-list" height="22">
                <td class="txtboldblue" width="150"><cf_get_lang_main no='1414.Test Başlığı'></td>
                <td class="txtboldblue"><cf_get_lang no='72.Kimler Almalı'></td>
              </tr>
              <cfoutput query="get_quizs" maxrows="20">
                <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                  <td><a href="#request.self#?fuseaction=training_management.quiz&quiz_id=#quiz_id#" class="tableyazi">#QUIZ_HEAD#</a></td>
                  <td>
                    <cfif len(quiz_partners)>
                      <cf_get_lang_main no='1611.Kurumsal Üyeler'>
                    </cfif>
                    <cfif len(quiz_partners) and ( len(quiz_consumers) or len(quiz_departments) )>
                      ,
                    </cfif>
                    <cfif len(quiz_consumers)>
                      <cf_get_lang_main no='1609.Bireysel Üyeler'>
                    </cfif>
                    <cfif len(quiz_consumers) and len(quiz_departments)>
                      ,
                    </cfif>
                    <cfif len(quiz_departments)>
                      <cf_get_lang_main no='1463.Çalışanlar'>
                    </cfif>
                  </td>
                </tr>
              </cfoutput>
            </table>
          </td>
        </tr>
      </table>
      <!--- En Yeni testler Bİtti --->
    </td>
    <td valign="top" width="300">
      <!--- Eğitim kategorileri --->
      <table border="0" width="98%" cellpadding="0" cellspacing="0" class="color-border">
        <tr>
          <td>
            <table border="0" width="100%" cellpadding="2" cellspacing="1">
              <tr class="color-header">
                <td class="form-title" height="22" colspan="6"><cf_get_lang_main no='725.Kategoriler'></td>
              </tr>
              <cfoutput query="get_training_cats" maxrows="20">
                <tr class="color-row" height="20">
                  <td><a href="#request.self#?fuseaction=training_management.list_training_subjects&training_cat_id=#training_cat_id#" class="tableyazi">#training_cat#bbbbb</a></td>
                </tr>
              </cfoutput>
            </table>
          </td>
        </tr>
      </table>
      <!--- eğitim kategorileri --->
      <br/>
      <br/>
    </td>
  </tr>
</table>

