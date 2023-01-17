<cfinclude template="../query/get_product.cfm">
<cfinclude template="../query/get_price_cat.cfm">
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_product_unit.cfm">
<cfif len(GET_PRODUCT.PROD_COMPETITIVE)>
	<cfset attributes.COMPETITIVE_ID=GET_PRODUCT.PROD_COMPETITIVE>
	<cfinclude template="../query/get_competitive_name.cfm">
	<cfset COMPETITIVE_NAME=GET_COMPETITIVE_NAME.COMPETITIVE>
<cfelse>
	<cfset COMPETITIVE_NAME="">
</cfif>

<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border"> 
    <td valign="middle"> 
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle"> 
          <td height="35" class="headbold"><cf_get_lang dictionary_id='37306.Yeni Fiyat'></td>
        </tr>
        <tr class="color-row" valign="top"> 
          <td> 
		    <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
              <tr> 
                <td colspan="2">
					<cfform action="#request.self#?fuseaction=product.emptypopup_add_price" method="post" name="price">
	                    <table border="0">
						<tr><td><cf_get_lang dictionary_id='57657.Ürün'></td><td><cfoutput>#get_product.product_name# - #COMPETITIVE_NAME#</cfoutput></td></tr>
	                      <tr> 
					      <td><cf_get_lang dictionary_id='58964.Fiyat Listesi'></td>
					      <td colspan="3">
						   <select name="price_catid" id="price_catid" style="width:150px;">
					          <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'>
					            <option value="-2" <cfif isDefined("attributes.price_catid") and attributes.price_catid eq -2>selected</cfif>><cf_get_lang dictionary_id='58721.Standart Satış'>
								<option value="-1" <cfif isDefined("attributes.price_catid") and attributes.price_catid eq -1>selected</cfif>><cf_get_lang dictionary_id='58722.Standart Alış'>			 
					          <cfoutput query="get_price_cat">
					            <option value="#price_catid#" <cfif isDefined("attributes.price_catid") and attributes.price_catid eq price_catid>selected</cfif>>#price_cat# 
					          </cfoutput> 
					        </select>
					      </td>
					    </tr>
					    <td><cf_get_lang dictionary_id='37307.Ürün Birimi'></td>
					    <td colspan="3">
					      <select name="unit_id" id="unit_id" style="width:150px;">
							<!--- <option value="<cfoutput>#get_product_unit.main_unit_id#</cfoutput>"><cfoutput>#get_product_unit.main_unit#</cfoutput>  --->
					        <cfoutput query="get_product_unit"> 
					          <option value="#PRODUCT_UNIT_ID#">#add_unit# 
					        </cfoutput> 
					      </select>
					    </td>
					    <tr> 
					      <td width="75"><cf_get_lang dictionary_id='45991.Yeni Fiyat'></td>
					      <td colspan="3"> 
					        <input type="Hidden" name="pid" id="pid" value="<cfoutput>#url.pid#</cfoutput>">
				          <cfsavecontent variable="message"><cf_get_lang dictionary_id='37347.Yeni Fiyat girmelisiniz'></cfsavecontent>
						  <cfinput type="text" name="price" style="width:150px;" required="yes" message="#message#" validate="float" range="0.0001,">					      
						  <cf_get_lang dictionary_id='57489.Para Br '> 
					        <select name="money" id="money" style="width:100px;">
					          <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'>
					          <cfoutput query="get_money"> 
					            <option value="#get_money.money#">#get_money.money# 
					          </cfoutput> 
					        </select>
					      </td>
					      </tr>
					  <cfif isDefined("attributes.price_catid") and (attributes.price_catid neq -1) and  (attributes.price_catid neq -2)>				  
					  <cfset attributes.pcat_id = attributes.price_catid>
					     <cfinclude template="../query/get_price_cat_rows.cfm"> 
						<tr> 
					      <td><cf_get_lang dictionary_id='57501.Baslangic'></td>
					      <td colspan="3"> 
					        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlama girmelisiniz'></cfsavecontent>
							<cfinput required="Yes" validate="#validate_style#" message="#message#" type="text" name="startdate" style="width:75px;" value="#dateformat(get_price_Cat.startdate,dateformat_style)#">
				          	<cf_wrk_date_image date_field="startdate">
							</td>
				        </tr>
					  <cfelse>
						<tr> 
					      <td><cf_get_lang dictionary_id='57501.Baslangic'></td>
					      <td colspan="3"> 
					        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlama girmelisiniz'></cfsavecontent>
							<cfinput required="Yes" validate="#validate_style#" message="#message#" type="text" name="startdate" style="width:75px;">
				         	 <cf_wrk_date_image date_field="startdate">
							</td>
				        </tr>
					 </cfif>
                     <cf_get_lang dictionary_id='58859.süreç'>
							<cf_workcube_process 
								is_upd='0' 
								process_cat_width='130' 
								is_detail='0'>
					    <tr> 
					      <td height="35" colspan="4" align="right" style="text-align:right;"> 
						  <cf_workcube_buttons is_upd='0' add_function='kontrol()' >
					      </td>
					    </tr>
					  </table>
					</cfform>   
				</td>
              </tr>
           </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

<script type="text/javascript">
	function kontrol()
	{
		if(document.price.money.value == 0)
		{
			window.alert("<cf_get_lang dictionary_id='41991.Parabirimi Girmelisiniz'>..");
			return false;
		}
		
		if(document.price.price_catid.value == 0)
		{
			window.alert("<cf_get_lang dictionary_id='45954.Fiyat Listesi Seçmelisiniz'>..");
			return false;
		}
		return true;
	}
</script>
