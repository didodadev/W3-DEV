<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.search_potential" default="0">
<cfparam name="attributes.search_status" default=1>
<cfinclude template="../query/get_cons_ct.cfm">
<cfinclude template="../query/get_consumer_cat.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_cons_ct.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.CONS_CAT") and len(attributes.CONS_CAT)>
	<cfquery name="GET_SELECTED_CONSCAT" datasource="#dsn#">
		SELECT 
			* 
		FROM 
			CONSUMER_CAT
		WHERE 
			CONSCAT_ID = #attributes.CONS_CAT#
		ORDER BY
			CONSCAT
	</cfquery>
</cfif>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr> 
    <td height="35" class="headbold"><cf_get_lang no='1061.Yeni Müşteri İş Geliştirme Planı ve Değerlendirme Formu'></td>
	  <!-- sil -->
    <td height="35"  valign="bottom" style="text-align:right;"> 
      <table>
		<cfform name="search" action="#request.self#?fuseaction=crm.consumer_list" method="post">
       <tr> 
      <td><cf_get_lang_main no='48.Filtre'>:</td>
	  <td><cfinput type="text" name="keyword" value="#attributes.keyword#" style="width:100px;" maxlength="255"></td>
      <td  style="text-align:right;"> 
        <select name="cons_cat" id="cons_cat">
          <option value=""><cf_get_lang no='115.Üye Kategorisi'>
          <cfoutput query="get_consumer_cat"> 
			<option value="#CONSCAT_ID#" <cfif isdefined("attributes.cons_cat") and attributes.cons_cat is get_consumer_cat.CONSCAT_ID>selected</cfif>>#get_consumer_cat.CONSCAT#</option>
          </cfoutput> 
        </select>
		<select name="search_status" id="search_status">			
			<option value="1" <cfif isDefined('attributes.search_status') and attributes.search_status is 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
			<option value="0" <cfif isDefined('attributes.search_status') and attributes.search_status is 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
			<option value="" <cfif isDefined('attributes.search_status') and not len(attributes.search_status)>selected</cfif>><cf_get_lang no='11.Tümü'></option>
		</select>		
		<select name="search_potential" id="search_potential">
			<option value=""  <cfif not len(attributes.search_potential)>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
			<option value="1" <cfif attributes.search_potential is 1>selected</cfif>><cf_get_lang_main no='165.Potansiyel'></option>
			<option value="0" <cfif attributes.search_potential is 0>selected</cfif>><cf_get_lang no='364.Potansiyel Değil'></option>			
		</select>
      </td>
	  <td>
		<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
		<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
	  </td>
      <td>         
		<cf_wrk_search_button>
      </td>	
	<cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'>   
    </tr>
  </cfform>
  </table>
    </td>
	<!-- sil -->
  </tr>
</table>
<table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border"> 
    <td> 
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header">
		<td class="form-title" width="30" height="22"><cf_get_lang_main no='75.No'></td> 
		  <td class="form-title"><cf_get_lang no='1059.Eczane İsmi'></td>
          <td class="form-title"><cf_get_lang no='88.Gerekli Bütçe'></td>
		  <td class="form-title"><cf_get_lang no='89.Harcanan Tutar'></td>
		  <td class="form-title"><cf_get_lang no='90.Bütçe Gerçekleşme'></td>

		  <td class="form-title"><cf_get_lang no='1062.Realizasyon'> %</td>
		             <td width="15" align="center"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_add_develop_plan_examine</cfoutput>','page');"><img src="/images/plus_square.gif" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a></td>
        </tr>
		<cfif get_cons_ct.recordcount>
		<cfoutput query="get_cons_ct" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
		 <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
             <td></td>
			<td></td>
            <td>&nbsp;</td>
			<td>
			</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  <td><img src="/images/update_list.gif" border="0"></td>
          </tr>
        </cfoutput> 
		<cfelse>
		<tr class="color-row" height="20">
		<td colspan="7"><cf_get_lang_main no='289.Filtre Ediniz'></td>
		</tr>
		</cfif>
      </table>
    </td>
  </tr>
</table>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
  <tr> 
    <td>  	 
     <cfif attributes.totalrecords gt attributes.maxrows>
      <table cellpadding="0" cellspacing="0" border="0" width="100%" height="35">
        <tr> 																																																							
          <td> 
			<cfset adres = attributes.fuseaction>
			<cfset adres = adres&"&search_status="&attributes.search_status>
			<cfset adres = adres&"&search_potential="&attributes.search_potential>
			<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			  <cfset adres = adres&"&keyword="&attributes.keyword>
			</cfif>
			<cfif isDefined('attributes.cons_cat') and len(attributes.cons_cat)>
			  <cfset adres = adres&"&cons_cat="&attributes.cons_cat>
			</cfif>
		  <cf_pages 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#adres#"> 
          </td>
          <!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
        </tr>
      </table>
      </cfif>	
</table>
<!-- sil -->
<script type="text/javascript">
	document.search.keyword.focus();
</script>
<!-- sil -->
