<cfparam name="attributes.cat" default="">
<cfparam name="attributes.keyword" default="">
<cfquery name="GET_SETUP_PRODUCT_CONFIGURATOR" datasource="#DSN3#">
	SELECT 
		SETUP_PRODUCT_CONFIGURATOR.*,
		PRODUCT_CAT.PRODUCT_CAT	
	FROM 
		SETUP_PRODUCT_CONFIGURATOR,
		PRODUCT_CAT
	WHERE
		PRODUCT_CAT.PRODUCT_CATID  = SETUP_PRODUCT_CONFIGURATOR.PRODUCT_CAT_ID
		<cfif len(attributes.keyword)>AND SETUP_PRODUCT_CONFIGURATOR.CONFIGURATOR_NAME LIKE '%#attributes.keyword#%'</cfif>
		<cfif len(attributes.cat)>AND PRODUCT_CAT.PRODUCT_CATID = #attributes.cat#</cfif>
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_setup_product_configurator.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
<tr valign="top">
<td>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
        <tr> 
          <td class="headbold" height="35"><cf_get_lang dictionary_id='37479.Ürün Konfigürasyonları'></td>
		  <!-- sil -->	
          <td align="right" valign="bottom" style="text-align:right;"> 
            <!--- Arama --->
            <table>
              <tr>
                <cfform name="search_product" action="#request.self#?fuseaction=#url.fuseaction#" method="post">
                  <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
                  <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
                  <td><cfinclude template="../query/get_product_cat.cfm">
				 	 <select name="cat" id="cat">
                      <option value="" selected><cf_get_lang dictionary_id='58137.Kategoriler'></option>
                      <cfoutput query="get_product_cat"	>
					  	<cfif listlen(HIERARCHY,".") lte 3>
                        	<option value="#product_catid#" <cfif len(attributes.cat) and attributes.cat eq product_catid>selected</cfif>>#HIERARCHY#-#product_cat#</option>
						</cfif>
                      </cfoutput>
					 </select>
                  </td>
                  <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
                  <td><cf_wrk_search_button></td>
                </cfform>
				</tr>
            </table>  
		  <!--- Arama --->
		  </td>
		  <!-- sil -->	
        </tr>
      </table>	
	  <table cellSpacing="0" cellpadding="0" width="98%" border="0" align="center">
        <tr class="color-border"> 
          <td>
		  	<table cellspacing="1" cellpadding="2" width="100%" border="0">
             <tr height="22" class="color-header">
			 <td class="form-title"><cf_get_lang dictionary_id='57480.Başlık'></td>
			 <td class="form-title"><cf_get_lang dictionary_id='57486.Kategori'></td>
			 <td width="10"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=product.popup_add_product_cat_configuration</cfoutput>','medium');"><img src="/images/plus_square.gif" border="0" title="<cf_get_lang dictionary_id='37191.Özellik Ekle'>"></a></td>
			 </tr>			 
			 <cfif get_setup_product_configurator.recordcount>
			  <cfoutput query="get_setup_product_configurator" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                  <td>#configurator_name#</td>
				  <td>#product_cat#</td>
				  <td width="10"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=product.popup_upd_product_cat_configuration&id=#product_configurator_id#','medium');"><img src="/images/update_list.gif" border="0" title="<cf_get_lang dictionary_id='37203.Özelliğe Varyasyon Ekle'>"></td>
                </tr>
              </cfoutput>
			  <cfelse> 
				  <tr class="color-row"> 
					<td colspan="4" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				  </tr>
				  </cfif>
			  </table>
          </td>
        </tr>
      </table>	
<cfif attributes.totalrecords gt attributes.maxrows>
     <table cellpadding="0" cellspacing="0" border="0" width="98%" height="30" align="center">
       <tr> 
         <td> 
		<cfset adres = url.fuseaction>
		<cfif isDefined('attributes.cat') and len(attributes.cat)>
			<cfset adres = '#adres#&cat=#attributes.cat#'>
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset adres = '#adres#&keyword=#attributes.keyword#'>
		</cfif>
	  		<cf_pages page="#attributes.page#" 
	  			maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#"></td>
         <!-- sil -->
		 <td align="right" style="text-align:right;">
		 <cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage# </cfoutput>
         </td>
		 <!-- sil -->
       </tr>
     </table>
</cfif>
</td>
</tr>
</table>
