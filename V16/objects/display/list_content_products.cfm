<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isDefined("attributes.PRODUCT_CAT")>
  <cfset url_str = "#url_str#&PRODUCT_CAT=#attributes.PRODUCT_CAT#">
<cfelse>
  <cfset attributes.PRODUCT_CAT = "">
</cfif>

<cfif isdefined("attributes.send")>
  	<cfquery name="add_catalog_relation" datasource="#DSN#">
		INSERT INTO 
			CONTENT_RELATION 
		(
			ACTION_TYPE,
			ACTION_TYPE_ID,
			CONTENT_ID,
			RECORD_EMP,
			RECORD_DATE
		)
		VALUES
		(
			'PRODUCT_ID',
			#attributes.product_id#,
			<cfif isdefined("attributes.content_id") and len(attributes.content_id)>#attributes.CONTENT_ID#,<cfelse>NULL,</cfif>
			#session.ep.userid#,
			#now()#
		)	  
  </cfquery>
<script type="text/javascript">
 wrk_opener_reload();
 window.close();
 </script>
</cfif>
<cfparam name="attributes.product_status" default="1">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfinclude template="../query/get_content_products.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default=50>
<cfparam name="attributes.totalrecords" default=#get_content_products.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfquery name="GET_CATS" datasource="#DSN3#">
	SELECT
		PRODUCT_CATID,
		PRODUCT_CAT
	FROM
		PRODUCT_CAT
	ORDER BY
		PRODUCT_CAT
</cfquery>

<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
  <tr>
    <td clasS="headbold"><cf_get_lang dictionary_id='57564.Ürünler'></td>
	<td  style="text-align:right;">
	<table>
        <cfform name="price_cat" action="#request.self#?fuseaction=objects.popup_content_products" method="post">          	
			<input type="hidden" value="<cfif isdefined("attributes.content_id")><cfoutput>#attributes.content_id#</cfoutput></cfif>" name="content_id" id="content_id">			
			<input type="hidden" value="<cfif isdefined("attributes.training_id")><cfoutput>#attributes.TRAINING_ID#</cfoutput></cfif>" name="training_id" id="training_id">			
		  <cfif isdefined("attributes.send")><input type="hidden" value="1" name="send" id="send"></cfif>
		  <tr> 
            <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
			<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
			<td><cf_get_lang dictionary_id='57657.Ürün'></td>
			<td>
				<input type="hidden" id="product_id" name="product_id" <cfif len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
				<input name="product_name" type="text" id="product_name" style="width:125px;" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','product_id','price_cat','3','250');" value="<cfif len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" autocomplete="off">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=price_cat.product_id&field_name=price_cat.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.price_cat.product_name.value),'list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
			</td>
			<td>
			  <select name="PRODUCT_CAT" id="PRODUCT_CAT" style="width:100px;">
			    <option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
				<cfoutput query="GET_CATS">
                    <option value="#PRODUCT_CATID#" <cfif isDefined("attributes.PRODUCT_CAT") and len(attributes.PRODUCT_CAT) AND (attributes.PRODUCT_CAT EQ PRODUCT_CATID)>SELECTED</cfif>>#PRODUCT_CAT#</option>
                </cfoutput>
			  </select>
			</td>
			<td>
				<select name="product_status" id="product_status">
					<option value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
					<option value="1" <cfif attributes.product_status eq 1>selected</cfif>><cf_get_lang dictionary_id ='57493.Aktif'></option>
					<option value="0" <cfif attributes.product_status eq 0>selected</cfif>><cf_get_lang dictionary_id ='57494.Pasif'></option>
				</select>
			</td>
			<td>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
		  <td><cf_wrk_search_button></td>
          </tr>
        </cfform>
      </table>
	</td>
  </tr>
</table>

<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr clasS="color-border">
<td>
<table cellpadding="2" cellspacing="1" border="0" width="100%">
	<tr clasS="color-header" height="22">
		<td width="30" class="form-title"><cf_get_lang dictionary_id='57487.No'></td>
		<td class="form-title"><cf_get_lang dictionary_id='58221.Ürün Adı'></td>
	</tr>
<cfif get_content_products.recordcount>
<cfoutput query="get_content_products" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		<td>#product_ID#</td>
		<td><a href="#request.self#?fuseaction=objects.popup_content_products<cfif isdefined("attributes.content_id") and len(attributes.content_id)>&content_id=#attributes.content_id#</cfif><cfif isdefined("attributes.training_id") and len(attributes.training_id)>&training_id=#attributes.training_id#</cfif>&product_id=#product_id#&send=1" class="tableyazi">#product_name#</a></td>
	</tr>
</cfoutput>
<cfelse>
    <tr class="color-row" height="20">
    	<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
    </tr>
</cfif>
</table>
</td>
</tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
<cfif isdefined("attributes.content_id")>
	<cfset url_str = "#url_str#&content_id=#attributes.content_id#">
</cfif>
<cfif isdefined("attributes.training_id")>
	<cfset url_str = "#url_str#&training_id=#attributes.training_id#">
</cfif>
<cfif isdefined("attributes.product_id")>
	<cfset url_str = "#url_str#&product_id=#attributes.product_id#">
</cfif>
<cfif isdefined("attributes.product_name")>
	<cfset url_str = "#url_str#&product_name=#attributes.product_name#">
</cfif>
<cfif isdefined("attributes.product_status")>
	<cfset url_str = "#url_str#&product_status=#attributes.product_status#">
</cfif>
<table cellpadding="0" cellspacing="0" border="0" width="98%" align="center" height="35">
  <tr> 
    <td><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="objects.popup_content_products#url_str#"></td>
      <!-- sil --><td  style="text-align:right;"> <cfoutput> <cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> 
      </td><!-- sil -->
  </tr>
</table>
</cfif>

