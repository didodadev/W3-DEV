<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_trainings.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif Not IsDefined("field_name")>
	<cfset field_name = "">
</cfif> 
<script type="text/javascript">
function dondur(name)
{
	opener.<cfoutput>#field_name#</cfoutput>.value = name;
	window.close();
}
</script>
<cfset url_str = "">
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#field_name#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.training_cat_id")>
	<cfset url_str = "#url_str#&training_cat_id=#training_cat_id#">
</cfif>
<cfif isdefined("attributes.attenders")>
	<cfset url_str = "#url_str#&attenders=#attenders#">
</cfif>
<table width="100%" cellspacing="0" cellpadding="0" height="100%">
  <tr> 
<cfinclude template="../../objects/display/tree_back.cfm">
<td <cfoutput>#td_back#</cfoutput>>
      <table cellpadding="0" cellspacing="0" border="0">
        <tr> 
          <td height="20" class="txtbold" colspan="2">&nbsp;&nbsp;<cf_get_lang no='46.Eğitim Kategorileri'> 
          </td>
        </tr>
        <cfif get_training_cats.recordcount>
        <cfoutput query="get_training_cats"> 
          <tr> 
            <td width="20" style="text-align:right;"><img src="/images/tree_1.gif" width="13" height="15"></td>
            <td><a href="#request.self#?fuseaction=training_management.popup_list_training_subjects&training_cat_id=#training_cat_id#&field_name=#field_name#" class="tableyazi">#training_cat#</a></td>
          </tr>
        </cfoutput> 
        <cfelse>
        <tr> 
          <td class="tableyazi" colspan="2">&nbsp;&nbsp;<cf_get_lang no='208.Eğitim Kategorisi Yok'></td>
        </tr>
        </cfif>
      </table>
    </td>
    <td valign="top"> 
      <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
        <tr> 
          <td class="headbold"> 
            <cfif isdefined("attributes.training_cat_id")>
    	        <cfquery name="GET_CAT" datasource="#dsn#">
	    	        SELECT 
						TRAINING_CAT,
						TRAINING_CAT_ID 
					FROM 
						TRAINING_CAT 
					WHERE 
						TRAINING_CAT_ID=#attributes.TRAINING_CAT_ID# 
            	</cfquery>
	            <cfoutput>#get_cat.training_cat#</cfoutput> 
            <cfelse>
    	        <cf_get_lang no='46.Eğitim Kategorileri'> 
            </cfif>
          </td>
          <td valign="bottom" style="text-align:right;"> 
            <table>
              <cfform name="form1" method="post" action="#request.self#?fuseaction=training_management.popup_list_training_subjects&field_name=#field_name#">
                <tr> 
                  <td class="label"><cf_get_lang_main no='48.Filtre'>:</td>
                  <td><cfinput type="text" name="keyword" value="#attributes.keyword#"></td>
                  <td> 
                    <cfinclude template="../query/get_training_cats.cfm">
                    <select name="training_cat_id" id="training_cat_id" style="width:100px;">
                    	<option value="0" selected><cf_get_lang_main no='1739.Tüm kategoriler'> 
						<cfoutput query="get_training_cats"> 
							<cfif isdefined("attributes.training_cat_id")>
                                <option value="#training_cat_id#" <cfif attributes.training_cat_id eq training_cat_id>selected</cfif>>#training_cat# 
                            <cfelse>
                                <option value="#training_cat_id#">#training_cat# 
                            </cfif>
                        </cfoutput> 
                    </select>
				</td>
				<td>
					<select name="attenders" id="attenders" style="width:100px;">
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
      <table cellSpacing="0" cellpadding="0" border="0" width="97%" align="center">
        <tr class="color-border"> 
          <td> 
            <table cellspacing="1" cellpadding="2" width="100%" border="0">
              <tr class="color-header"> 
                <td height="22" class="form-title"><cf_get_lang_main no='68.Konu Başlığı'></td>
                <td class="form-title"><cf_get_lang no='32.Amaç'></td>
                <td class="form-title"><cf_get_lang no='32.Amaç'></td>
                <td class="form-title"><cf_get_lang no='75.Author(yazar)'></td>
                <td class="form-title" width="100"><cf_get_lang_main no='215.Kayıt Tarihi'></td>
              </tr>
              <cfif get_trainings.recordcount>
              <cfoutput query="get_trainings" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
               <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                  <td><a href="javascript:dondur('#train_head#');" class="tableyazi">#train_head#</a></td>
                  <td>#train_objective#</td>
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
                    <cfif len(train_consumers) and (train_departments )>
                    , 
                    </cfif>
                    <cfif len(train_departments)>
                    <cf_get_lang_main no='1463.Çalışanlar'>
                    </cfif>
                  </td>
                  <td>
				  <cfif len(get_trainings.record_emp)>
					#get_emp_info(get_trainings.record_emp,0,0)#
				  <cfelseif len(record_par)>
				  	<cfset attributes.partner_id = record_par>
					<cfinclude template="../query/get_partner.cfm">
					#get_partner.company_partner_name# #get_partner.company_partner_surname#
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
	<cfif get_trainings.recordcount>
      <cfif attributes.totalrecords gt attributes.maxrows>
      <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr> 
          <td height="35"><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="training_management.popup_list_training_subjects#url_str#"> 
          </td>
          <!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
        </tr>
      </table>
      </cfif>
	</cfif>
    </td>
  </tr>
</table>
