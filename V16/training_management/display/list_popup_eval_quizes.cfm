<cfparam name="attributes.keyword" default="">
<cfinclude template="../query/get_eval_quizes.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_all_quiz.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
function add_user(q_id,q_head)
{
	<cfif isdefined("attributes.field_quiz_head")>
	opener.<cfoutput>#field_quiz_head#</cfoutput>.value = q_head;
	</cfif>
	<cfif isdefined("attributes.field_quiz_id")>
	opener.<cfoutput>#field_quiz_id#</cfoutput>.value = q_id;
	</cfif>
	<cfif isDefined("attributes.url_direction") AND isDefined("attributes.url_param")>
		<cfoutput>
		windowopen('#request.self#?fuseaction=#attributes.url_direction#&#attributes.url_param#=#evaluate('attributes.'&attributes.url_param)#&PAR_ID='+p_id,'small');
		</cfoutput>
	<cfelse>
		<cfif isdefined("attributes.basket_cheque")>
			opener.reload_basket();
		</cfif>
		window.close();
	</cfif>
}
function reloadopener(){
	wrk_opener_reload();
	window.close();
}
</script>
<cfparam name="select_list" default="1,2,3,4,5,6">
<cfscript>
url_string = '';
if (isdefined('attributes.field_quiz_head')) url_string = '#url_string#&field_quiz_head=#field_quiz_head#';
if (isdefined('attributes.field_quiz_id')) url_string = '#url_string#&field_quiz_id=#field_quiz_id#';
</cfscript>

<table border="0" cellpadding="2" cellspacing="0" align="center" width="98%" height="35">
  <tr> 
    <td class="headbold" style="text-align:right;">
	  <table>
        <cfform name="search_par" action="#request.self#?fuseaction=training_management.popup_list_eval_quizes2#url_string#" method="post">
          <tr> 
            <td class="label"><cf_get_lang_main no='48.Filtre'>:</td>
			<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
            <td><cf_wrk_search_button></td>
          <!--- <td><a href="<cfoutput>#request.self#?fuseaction=objects.popup_form_add_company</cfoutput>"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang no='547.Kurumsal Üye Ekle'>"></a></td>  
	        <td><a href="javascript:history.go(-1);"><img src="/images/back.gif" border="0" alt="<cf_get_lang_main no='20.Geri'>"></a></td>		   --->
          </tr>
        </cfform>
      </table>
	</td>
  </tr>
</table>
<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
<table cellspacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border"> 
    <td> <table cellspacing="1" cellpadding="2" border="0" align="center" width="100%">
        <tr class="color-header" height="22"> 
          <!--- <td class="form-title"><cf_get_lang_main no='75.No'></td> --->
          <td class="form-title"><cf_get_lang no='203.Değerlendirme formu adı'></td>
          
        </tr>
        <cfif get_all_quiz.recordcount>
          <cfoutput query="get_all_quiz" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
           <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <!--- <td><cf_online id="#QUIZ_ID#" zone="pp"></td> --->
              <td>
			   <a href="##" onClick="add_user('#QUIZ_ID#','#QUIZ_HEAD#')" class="tableyazi">
				  #QUIZ_HEAD#</a>
				</td>
            </tr>
          </cfoutput> 
          <cfelse>
          <tr class="color-row"> 
            <td height="20" class="label" colspan="2"><cf_get_lang no='317.Kayıtlı Bölüm Bulunamadı'></td>
          </tr>
        </cfif>
      </table></td>
  </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" border="0" cellpadding="0" cellspacing="0" align="center" height="35">
    <tr> 
      <td> 
	  		<cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="training_management.popup_list_eval_quizes2#url_string#"> 
      </td>
      <!-- sil --><td height="35" style="text-align:right;">
	  	<cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput>
	  </td><!-- sil -->
    </tr>
  </table>
</cfif>
