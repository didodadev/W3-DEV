<cfset url_str = "">
<cfif isdefined("attributes.startdate")>
	<cfset url_str = "#url_str#&startdate=#attributes.startdate#">
</cfif>
<cfif isdefined("attributes.finishdate")>
	<cfset url_str = "#url_str#&finishdate=#attributes.finishdate#">
</cfif>
<cfif isdefined("attributes.keyword")>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.eventcat_id")>
	<cfset url_str = "#url_str#&eventcat_id=#attributes.eventcat_id#">
</cfif>
<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
<cfinclude template="../query/get_comp_event_search.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_event_search.recordcount#>  
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31026.Olaylar'></cfsavecontent>
<cf_medium_list_search title='#message#'>
    <cf_medium_list_search_area>
            <cfinclude template="../query/get_event_cats.cfm">
            <table>
                <cfform name="search" method="post" action="#request.self#?fuseaction=myhome.popup_list_comp_buyer_agenda&company_id=#attributes.company_id#">
                <tr>
                <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
                <td>
                <cfif isdefined("keyword") and len(attributes.keyword)>
                    <cfinput type="text" name="keyword" maxlength="100" value="#attributes.keyword#" style="width:100px;">
                <cfelse>
                    <cfinput type="text" name="keyword" maxlength="100" value="" style="width:100px;">
                </cfif>
                </td>
                <td>
                <select name="eventcat_id" id="eventcat_id" style="width:100px;">
                   <option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
                   <cfoutput query="get_event_cats">
                    <cfif isdefined("attributes.eventcat_id")>
                       <option value="#eventcat_id#" <cfif attributes.eventcat_id eq eventcat_id>selected</cfif>>#eventcat#</option>
                    <cfelse>
                       <option value="#eventcat_id#">#eventcat#</option>
                    </cfif>
                   </cfoutput>
                </select>
                </td>
                <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.başlama tarihi girmelisiniz'></cfsavecontent>
                <cfif isdefined("startdate")>
                    <cfinput type="text" name="startdate" value="#dateformat(startdate,dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#">
                <cfelse>
                    <cfinput type="text" name="startdate" value="" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#">
                </cfif>
                <cf_wrk_date_image date_field="startdate">
                </td>
                <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
                <cfif isdefined("finishdate")>
                    <cfinput type="text" name="finishdate" value="#dateformat(finishdate,dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#">
                <cfelse>
                    <cfinput type="text" name="finishdate" value="" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#">
                </cfif>
                <cf_wrk_date_image date_field="finishdate">
                </td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </td>
                <td><cf_wrk_search_button></td>
                </tr>
                </cfform>
            </table>
    </cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
    <thead>
        <tr>
       		<th colspan="4"><cf_get_lang dictionary_id='57574.Şirket'> : <cfoutput>#get_company_partners.fullname#</cfoutput></th>
        </tr>
        <tr>
            <th width="50" class="form-title"><cf_get_lang dictionary_id='57487.No'></th>
            <th class="form-title"><cf_get_lang dictionary_id='57480.Başlık'></th>
            <th width="150" class="form-title"><cf_get_lang dictionary_id='31124.Olay Kategorisi'></th>
            <th width="130" class="form-title"><cf_get_lang dictionary_id='57742.Tarih'></th>
        </tr>
        </thead>
        <tbody>
			<cfif get_event_search.recordcount>
            <cfoutput query="get_event_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>#event_id#</td>
                    <td>
                    <a href="javascript://" onClick="window.opener.location.href='#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#event_id#';self.close();" class="tableyazi">#event_head#</a>
                    </td>
                    <td>#eventcat#</td>
                    <td>#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# - #dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)#</td>
                </tr>
            </cfoutput>
            <cfelse>
            <tr>
                <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_medium_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="99%" align="center">
	  <tr> 
	    <td>
		      <cf_pages page="#attributes.page#"
					  maxrows="#attributes.maxrows#"
					  totalrecords="#attributes.totalrecords#"
					  startrow="#attributes.startrow#"
					  adres="myhome.popup_list_comp_buyer_agenda#url_str#"> 
	    </td>
	    <!-- sil --><td style="text-align:right;"><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:<cfoutput>#attributes.totalrecords#-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
	  </tr>
	</table>
</cfif>
