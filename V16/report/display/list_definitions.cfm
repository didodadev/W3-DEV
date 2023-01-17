<cfset url_string = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.in_report")>
  <cfset url_string = "#url_string#&in_report=#attributes.in_report#">
  <cfelse>
  <cfset attributes.in_report = 1>
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/select_report_tables.cfm">
<cfelse>
	<cfset SELECT_REPORT_TABLES.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#SELECT_REPORT_TABLES.recordCount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="100%" cellpadding="0" cellspacing="0" border="0" height="100%">
  <tr>
    <td valign="top">
      <table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td class="headbold"><cf_get_lang dictionary_id='38739.Tablolar'></td>
          <td align="right" style="text-align:right;">
            <table>
              <tr>
                <cfform name="filter" action="" method="post">
                <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                  <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
                  <td><cfinput type="Text" maxlength="255" value="#attributes.keyword#" name="keyword">
                  </td>
                  <td>
                    <select name="in_report" id="in_report">
                      <option value='-1'><cf_get_lang dictionary_id='57708.Tümü'></option>
                      <option value='0'<cfif attributes.in_report eq 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                      <option value='1'<cfif attributes.in_report eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                    </select>
                  </td>
                  <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                  </td>
                  <td><cf_wrk_search_button></td>
                </cfform>
              </tr>
            </table>
          </td>
        </tr>
      </table>
            <table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
              <tr height="22" class="color-header">
                <td class="form-title"><cf_get_lang dictionary_id='38752.Tablo'></td>
                <td class="form-title"><cf_get_lang dictionary_id='38744.Takma Ad'>(<cf_get_lang dictionary_id='38745.Türkçe'>)</td>
                <td class="form-title"><cf_get_lang dictionary_id='38744.Takma Ad'>(<cf_get_lang dictionary_id='38746.İngilizce'>)</td>
                <td class="form-title"><cf_get_lang dictionary_id='38747.Veritabanı'></td>
                <td  width="50" class="form-title"><cf_get_lang dictionary_id='57493.Aktif'></td>
                <td width="15" class="form-title"></td>
                <td width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=report.popup_form_add_table','list');"><img src="/images/plus_square.gif" border="0"  align="absmiddle" title="<cf_get_lang dictionary_id='57516.Tablo Ekle'>"></a></td>
              </tr>
              <cfif SELECT_REPORT_TABLES.recordCount>
                <cfoutput query="SELECT_REPORT_TABLES" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=report.Popup_UpdtTable&table_id=#TABLE_ID#','medium')" class="tableyazi">#TABLE_NAME#</a></td>
                    <td>#NICK_NAME_TR#</td>
                    <td>#NICK_NAME_EN#</td>
                    <td>
                      <cfif period_year neq 0>
					  	<cfquery name="get_company_name" datasource="#dsn#">
							SELECT NICK_NAME FROM OUR_COMPANY WHERE COMP_ID = #COMPANY_ID#
						</cfquery>
                        #GET_COMPANY_NAME.NICK_NAME# - #period_year#
					  <cfelseif company_id neq 0>
					  	<cfquery name="get_company_name" datasource="#dsn#">
							SELECT NICK_NAME FROM OUR_COMPANY WHERE COMP_ID = #COMPANY_ID#
						</cfquery>
                        #GET_COMPANY_NAME.NICK_NAME#
                      <cfelse>
                        <cf_get_lang dictionary_id='58206.Main'> 
                      </cfif>
                    </td>
                    <td><cfif TABLE_INREPORT EQ 0>
                        <cf_get_lang dictionary_id='57496.Hayır'>
                        <cfelse>
                        <cf_get_lang dictionary_id='57495.Evet'>
                      </cfif>
                    </td>
                    <FORM action="#request.self#?fuseaction=report.emptypopup_delTable" method="post">
                      <td>
                        <input type="Hidden" name="Table_ID" id="Table_ID" value="#TABLE_ID#">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='39781.Kayıtlı Tabloyu Siliyorsunuz Emin misiniz'></cfsavecontent>
                        <input type="image" src="/images/delete_list.gif" onClick="javascript:if (confirm('#message#')) submit(); else return false;">
                      </td>
                    </FORM>
                    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=report.popup_list_columns&table_id=#TABLE_ID#','list')"><img src="/images/plus_list.gif" border="0"  align="absmiddle" title="<cf_get_lang dictionary_id='38754.Tabloya Alan Ekle'>"></a></td>
                  </tr>
                </cfoutput>
                <cfelse>
                <tr height="20" class="color-row">
                  <td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                </tr>
              </cfif>
            </table>
      <cfif SELECT_REPORT_TABLES.recordcount AND (attributes.totalrecords gt attributes.maxrows)>
        <table width="98%" border="0" cellpadding="0" cellspacing="0" height="35" align="center">
          <tr>
            <td>
				<cfif len(attributes.form_submitted)>
                	<cfset url_string = "#url_string#&form_submitted=#attributes.form_submitted#">
                </cfif>
            	<cf_pages
                	page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="report.definition#url_string#">
            </td>
            <!-- sil --><td align="right" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
          </tr>
        </table>
      </cfif>
    </td>
  </tr>
</table>
<br/>

