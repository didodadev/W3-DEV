<cfquery name="GET_BRAND_CATS" datasource="#DSN#">
	SELECT * FROM SETUP_BRAND_CAT ORDER BY	HIERARCHY
</cfquery>
<cfquery name="GET_BRAND" datasource="#DSN#">
	SELECT * FROM SETUP_BRAND_CAT WHERE	BRAND_CAT_ID=#URL.ID#
</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr clasS="color-border">
    <td valign="top">
      <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
        <tr class="color-list" height="35">
          <td align="right" style="text-align:right;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="headbold"><cf_get_lang no ='873.Marka Tip Kategorisi Güncelle'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table>
              <cfform  name="upd_brand_cat" method="post" action='#request.self#?fuseaction=settings.care_cat_upd'>
                <input type="hidden" id="counter" name="counter">
                <input type="hidden" name="brand_cat_id" id="brand_cat_id" value="<cfoutput>#url.id#</cfoutput>">
                <input type="hidden" name="oldHierarchy" id="oldHierarchy" value="<cfoutput>#get_care.hierarchy#</cfoutput>">
                <cfset cat_code=listlast(get_care.hierarchy,".")>
                <cfset ust_cat_code=listdeleteat(get_care.hierarchy,ListLen(get_care.hierarchy,"."),".")>
                <input type="hidden" name="brand_cat_code_old" id="brand_cat_code_old" value="<cfoutput>#brand_code#</cfoutput>">
                <tr>
					<td width="105"><cf_get_lang_main no ='1939.Üst Kategori'></td>
					<td><select name="hierarchy" id="hierarchy" onChange="document.upd_brand_cat.head_cat_code.value=document.upd_brand_cat.hierarchy[document.upd_brand_cat.hierarchy.selectedIndex].value;" style="width:200px;">
					  <option value=""<cfif ust_cat_code eq "">selected</cfif>><cf_get_lang_main no ='322.Seçiniz'></option>
					  <cfoutput query="get_care_cats">
						<cfif hierarchy is not get_brand.hierarchy>
						  <option value="#hierarchy#"<cfif ust_cat_code eq hierarchy and len(ust_cat_code) eq len(hierarchy)> selected</cfif>>#hierarchy# #brand_cat#</option>
						</cfif>
					  </cfoutput>
					</select></td>
                </tr>
                <tr>
					<td><cf_get_lang no ='1406.Kategori Kodu'> *</td>
					<td><input type="text" name="head_cat_code" id="head_cat_code" value="<cfoutput>#ust_cat_code#</cfoutput>" disabled  style="width:80px;">
					  <cfsavecontent variable="message"><cf_get_lang no ='1407.Kategori Kodu Girmelisiniz'> !</cfsavecontent>
					  <cfinput type="text" name="brand_cat_code" value="#brand_code#" maxlength="50" required="yes" message="#message#" style="width:115px;"></td>
                </tr>
                <tr>
					<td><cf_get_lang_main no ='74.Kategori'> *</td>
					<td><cfsavecontent variable="message"><cf_get_lang no ='1187.Kategori Girmelisiniz'> !</cfsavecontent>
					  <cfinput type="text" name="brand_cat" size="60" value="#get_brand.brand_cat#" maxlength="50" required="yes" message="#message#" style="width:200px;"></td>
                </tr>
                <tr>
					<td valign="top"><cf_get_lang_main no ='217.Açıklama'></td>
					<td><textarea name="detail" id="detail" style="width:200px;height:40px;"><cfoutput>#get_brand.detail#</cfoutput></textarea></td>
                </tr>
                
                  <tr>
                    <td><cf_get_lang_main no='71.Kayıt'></td>
                    <td align="left"><cfif len(get_brand.record_emp)><cfoutput>#get_emp_info(get_brand.record_emp,0,1)# #dateformat(get_brand.record_date,dateformat_style)#</cfoutput></cfif></td>
                  </tr>                
                <tr>
					<!--- delete_page_url='#request.self#?fuseaction=product.care_cat_del&PRODUCT_CATID=#URL.ID#&OLDHIERARCHY=#get_care.HIERARCHY#'  --->
					<td></td>
					<td><cf_workcube_buttons is_upd='1' is_delete='0' add_function='form_check()'></td>
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
function form_check()
{
	<!--- Detay uzunluk kontrolü BK --->
	x = (100 - upd_brand_cat.detail.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang_main no='359.Detay'> "+ ((-1) * x) +" <cf_get_lang_main no='1741.Karakter Uzun'>");
		return false;
	}

	/* bosluklar aliniyor ARZU BT*/
	our_pro_str=upd_brand_cat.brand_cat_code.value;
	for(;;)
	{
			if (our_pro_str.search(" ") != -1){      
				our_pro_str = our_pro_str.replace(" ","");
				upd_brand_cat.brand_cat_code.value = our_pro_str;
			}else{
				break;
			}
	}
	
	if (upd_brand_cat.brand_cat_code.value.indexOf('.') != -1)
	{
		alert("<cf_get_lang no ='1408.Ürün özel kategori kodu "" içeremez'> !");
		return false;
	}
	if (upd_brand_cat.brand_cat_code.value != upd_brand_cat.brand_cat_code_old.value)	
	{	
		if (confirm("<cf_get_lang no ='2448.Kategori Kodunda Yaptığınız Değişiklik Marka Hiyerarşisinin Bozulmasına ve  Veri Kaybına Neden Olabilir! Devam Etmek İstiyor musunuz'>?")) 
		{
				return true;
		}	
		else 
		{
			return false;
		}
	}		
	else
	{
		return true;
	}	
}
</script>
