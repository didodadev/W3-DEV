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
<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">

<cfinclude template="../query/get_con_event_search.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_event_search.recordcount#>  
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
	<tr>
		<td class="headbold"><cf_get_lang no='330.Olaylar'></td>
		<td  style="text-align:right;">
			<!-- Filtre --> 
<cfinclude template="../query/get_event_cats.cfm">
<table>
	<cfform name="search" method="post" action="#request.self#?fuseaction=crm.popup_list_con_agenda&consumer_id=#attributes.consumer_id#">
	<tr>
	<td><cf_get_lang_main no='48.Filtre'>:</td>
	<td>
	<cfif isdefined("keyword") and len(attributes.keyword)>
		<cfinput type="text" name="keyword" maxlength="100" value="#attributes.keyword#" style="width:100px;">
	<cfelse>
		<cfinput type="text" name="keyword" maxlength="100" value="" style="width:100px;">
	</cfif>
	</td>
	<td>
	<select name="eventcat_id" id="eventcat_id" style="width:100px;">
	   <option value=""><cf_get_lang_main no='669.Hepsi'></option>
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
	<cfsavecontent variable="alert"><cf_get_lang_main no ='326.Başlangıç tarihini yazınız '></cfsavecontent>
	<cfif isdefined("startdate")>
		<cfinput type="text" name="startdate" value="#dateformat(startdate,dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10" message="#alert#">
	<cfelse>
		<cfinput type="text" name="startdate" value="" style="width:70px;" validate="#validate_style#" maxlength="10" message="#alert#">
	</cfif>
	<cf_wrk_date_image date_field="startdate">
	</td>
	<td>
	<cfsavecontent variable="alert"><cf_get_lang_main no ='327.Bitiş tarihini yazınız'></cfsavecontent>
	<cfif isdefined("finishdate")>
		<cfinput type="text" name="finishdate" value="#dateformat(finishdate,dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10" message="#alert#">
	<cfelse>
		<cfinput type="text" name="finishdate" value="" style="width:70px;" validate="#validate_style#" maxlength="10" message="#alert#">
	</cfif>
	<cf_wrk_date_image date_field="finishdate">
	</td>
	<td>
		<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
		<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
	</td>
	<td><cf_wrk_search_button></td>
	</tr>
	</cfform>
</table>
<!-- //Filtre -->
		</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="0" border="0" width="98%" align="center">
  <tr>
	<td class="color-border">
	<table cellpadding="2" cellspacing="1" border="0" width="100%">
		<tr class="color-list">
		<td height="25" colspan="4" class="txtboldblue"><cf_get_lang_main no='246.Üye'> : 
		<cfinclude template="../query/get_consumer.cfm">
		<cfoutput>		
                  #GET_CONSUMER.consumer_name# #GET_CONSUMER.consumer_surname#
		</cfoutput>
		</td>
		</tr>
		<tr class="color-header" height="22">
			<td width="50" class="form-title"><cf_get_lang_main no='75.No'></td>
			<td class="form-title"><cf_get_lang_main no='68.Başlık'></td>
			<td width="150" class="form-title"><cf_get_lang no='331.Olay Kategorisi'></td>
			<td width="130" class="form-title"><cf_get_lang_main no='330.Tarih'></td>
		</tr>
		<cfif get_event_search.recordcount>
			<cfoutput query="get_event_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td>#event_id#</td>
					<td>
					<a href="javascript://" onClick="window.opener.location.href='#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#event_id#';self.close();" class="tableyazi">#event_head#</a>
					</td>
					<td>#eventcat#</td>
					<td>#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# - #dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr class="color-row" height="20">
				<td colspan="4"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</table>
	</td>
  </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
	  <tr> 
	    <td>
		      <cf_pages page="#attributes.page#"
					  maxrows="#attributes.maxrows#"
					  totalrecords="#attributes.totalrecords#"
					  startrow="#attributes.startrow#"
					  adres="crm.popup_list_con_agenda#url_str#"> 
	    </td>
	    <!-- sil --><td  style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'>:<cfoutput>#attributes.totalrecords#-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
	  </tr>
	</table>
	<br/>
</cfif>
