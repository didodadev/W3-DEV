<!--- Bu sayfalar daha sonra kullanılmayacak sayfa başlığı verilmedi PY 20121002 --->

<cfinclude template="../query/get_quizs.cfm">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_QUIZS.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<script type="text/javascript">
function add_pos(quiz_id,quiz_head)
{
	<cfif isdefined("attributes.field_quiz_id")>
	opener.<cfoutput>#field_quiz_id#</cfoutput>.value = quiz_id;    /*position_id*/
	</cfif>
	<cfif isdefined("attributes.field_quiz_head")>
	opener.<cfoutput>#field_quiz_head#</cfoutput>.value = quiz_head;
	</cfif>
	window.close();

}
function reloadopener(){
	wrk_opener_reload();
	window.close();
}
</script>

<cfscript>
url_string = '';
if (isdefined('attributes.field_quiz_id')) url_string = '#url_string#&field_quiz_id=#field_quiz_id#';
if (isdefined('attributes.field_quiz_head')) url_string = '#url_string#&field_quiz_head=#field_quiz_head#';
if (isdefined('attributes.keyword') and len(attributes.keyword)) url_string = '#url_string#&keyword=#attributes.keyword#';
</cfscript>

<cf_box title="#getLang('','Değerlendirme',56685)#" scroll="1" collapsable="1" resize="1" uidrop="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">

    <cfform action="#request.self#?fuseaction=hr.popup_app_list_quizs#url_string#" method="post" name="search">
<cf_box_elements>
			<cf_box_search more="0">
                <div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
                    <div class="input-group col col-8 col-xs-12" >
                        <cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                        <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255">
                    </div>
				</div>
                <div class="form-group">
                    <div class="input-group col col-12" >
                        <select name="form_type" id="form_type">
                            <option value="0" selected><cf_get_lang no='395.Tüm Formlar'> 
                            <option value="1" <cfif isdefined("attributes.form_type") AND attributes.form_type eq 1>selected</cfif>><cf_get_lang dictionary_id="57576.Çalışan">
                            <option value="2" <cfif isdefined("attributes.form_type") AND attributes.form_type eq 2>selected</cfif>><cf_get_lang dictionary_id="39318.Başvuru">
                            <option value="3" <cfif isdefined("attributes.form_type") AND attributes.form_type eq 3>selected</cfif>><cf_get_lang dictionary_id="57419.Eğitim">
                            <option value="4" <cfif isdefined("attributes.form_type") AND attributes.form_type eq 4>selected</cfif>><cf_get_lang dictionary_id="30935.Eğitimci">
                            <option value="5" <cfif isdefined("attributes.form_type") AND attributes.form_type eq 5>selected</cfif>><cf_get_lang dictionary_id="30922.Mülakat">
                            <option value="6" <cfif isdefined("attributes.form_type") AND attributes.form_type eq 6>selected</cfif>><cf_get_lang dictionary_id="29776.Deneme Süresi">
                        </select>
                    </div>
				</div>
                <div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" >
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
				</div>
            </cf_box_search>	

    </cf_box_elements>
    </cfform>
<cf_grid_list>
    <thead>
        <tr> 
            <th><cf_get_lang dictionary_id='29764.Form'></th>
            <th width="100"><cf_get_lang dictionary_id='55474.Amaç'></th>
            <th width="100"><cf_get_lang dictionary_id='29775.Hazırlayan'></th>
            <th width="70"><cf_get_lang dictionary_id='57483.Kayıt'></th>
            <th width="70"><cf_get_lang dictionary_id='57627.Kayıt Tarih'></th>
            <th width="45"><cf_get_lang dictionary_id='57482.Aşama'></th>
            <th width="55"><cf_get_lang dictionary_id='29479.Yayın'></th>
        </tr>
    </thead>
    <tbody>
		<cfoutput query="GET_QUIZS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
        <cfset stage = get_quizs.STAGE_ID> 
        <tr>
            <td width="25">#quiz_id#</td>
            <td><a href="javascript://"   onClick="add_pos('#quiz_id#','#quiz_head#')">#quiz_head#</a></td>
            <td>#quiz_objective#</td>
            <td> 
            <cfif len(RECORD_EMP)>
                #get_emp_info(RECORD_EMP,0,0)#
            <cfelseif len(record_par)>
				<cfset attributes.partner_id = RECORD_PAR>
                <cfinclude template="../query/get_partner2.cfm">
                #get_partner.company_partner_name# #get_partner.company_partner_surname# 
            </cfif>
            </td>
            <td>#dateformat(record_date,dateformat_style)#</td>
            <td><cfif IS_ACTIVE IS 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
        </tr>
        </cfoutput>
    </tbody>
</cf_grid_list>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
    <tr>
      <td><cf_pages page="#attributes.page#"
			  maxrows="#attributes.maxrows#"
			  totalrecords="#attributes.totalrecords#"
			  startrow="#attributes.startrow#"
			  adres="hr.popup_list_positions#url_string#"
              isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
            </td>
      <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
    </tr>
  </table>
</cfif>
</cf_box>