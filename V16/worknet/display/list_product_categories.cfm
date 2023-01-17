<!--- bu dosyayı standarda almayın mümkünse worknet dosyalarına dokunmayın.
	İrtibat NO: 0535 711 77 88 
	Dahili: 1008
	fatihayik@workcube.com
	Fatih AYIK
	19/09/2012
--->
<cfparam name="attributes.return_field" default="">
<cfif isdefined('session.ep')>
	<cfset GET_PRODUCT_CAT = createObject("component","V16.worknet.query.worknet_product").getMainProductCat()>
<cfelse>
	<cfset GET_PRODUCT_CAT = createObject("component","V16.worknet.query.worknet_product").getMainProductCat(is_internet=1)>
</cfif>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang_main no='155.Ürün Kategorileri'></td>
  </tr>
</table>
<table align="center">
	<tr>
    	<td><cf_get_lang no='164.Ana Kategori'></td>
        <td><cf_get_lang no='165.Alt Kategori'></td>
    </tr>
	<tr>
    	<td>
        	<select name="main_category" id="main_category" style="width:275px;height:100px;" size="5" onchange="loadajaxsubcategory();">
                <cfoutput query="GET_PRODUCT_CAT">
                    <option value="#product_catid#">#product_cat#</option>
                </cfoutput>
            </select>
        </td>
        <td>
        	<div id="subProductCategory" style="width:275px;height:100px;">
                <select name="subCategory" id="subCategory" style="width:275px;height:100px;" size="5" ></select>
            </div>
        </td>
    </tr>
</table>
<table align="center">
    <tr>
    	<td align="center"><input type="button" name="" value="<cf_get_lang_main no='170.Ekle'>" onclick="addCompanyCategory();" /></td>
    </tr>
</table>
<table align="center">
    <tr>
    	<td align="center"><select name="companyCategory" id="companyCategory" style="width:550px;height:100px;" size="5" multiple="multiple" ></select></td>
    </tr>
</table>
<table align="center">
    <tr>
    	<td align="center"><input type="button" name="" value="<cf_get_lang_main no='1331.Gönder'>" onclick="sendCompanyCategory();" />&nbsp;<input type="button" name="" value="<cf_get_lang_main no='51.Sil'>" onclick="removeCompanyCategory();" /></td>
    </tr>
</table>
<script language="javascript">
	function loadajaxsubcategory()	
	{
		var send_address = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.subCategory&mainCategoryId=";
		send_address += document.getElementById('main_category').value;
		AjaxPageLoad(send_address,'subProductCategory',1,'Alt Kategoriler');
	}
	function addCompanyCategory()
	{
		catMainIndex = document.getElementById('main_category').selectedIndex;
		catSubIndex = document.getElementById('subCategory').selectedIndex;
		
		if(catMainIndex >= 0 || catSubIndex >= 0)
		{
			cat_main_text = document.getElementById("main_category").options[catMainIndex].text;
			cat_main_id = document.getElementById("main_category").options[catMainIndex].value;
						
			if(catSubIndex >= 0)
			{
				cat_sub_text = document.getElementById("subCategory").options[catSubIndex].text;
				cat_sub_id = document.getElementById("subCategory").options[catSubIndex].value;
			
				var kontrol =0;
				uzunluk=document.getElementById('companyCategory').length;
				for(i=0;i<uzunluk;i++){
					if(document.getElementById('companyCategory').options[i].value==cat_sub_id){
						kontrol=1;
					}
				}
				if(kontrol==0){
					x = document.getElementById('companyCategory').length;
					document.getElementById('companyCategory').length = parseInt(x + 1);
					document.getElementById('companyCategory').options[x].value = cat_sub_id;
					document.getElementById('companyCategory').options[x].text = cat_main_text +' > '+ cat_sub_text;
				}
			}
			else
			{
				var kontrol =0;
				uzunluk=document.getElementById('companyCategory').length;
				for(i=0;i<uzunluk;i++){
					if(document.getElementById('companyCategory').options[i].value==cat_main_id){
						kontrol=1;
					}
				}
				if(kontrol==0){
					x = document.getElementById('companyCategory').length;
					document.getElementById('companyCategory').length = parseInt(x + 1);
					document.getElementById('companyCategory').options[x].value = cat_main_id;
					document.getElementById('companyCategory').options[x].text = cat_main_text;
				}
			}
		}
		else
		{
			alert("<cf_get_lang_main no='1535.Lütfen Kategori Seçiniz'> !");
			return false;
		}
	}
	function removeCompanyCategory()
	{
		for (i=document.getElementById('companyCategory').options.length-1;i>-1;i--)
		{
			if (document.getElementById('companyCategory').options[i].selected==true)
				document.getElementById('companyCategory').options.remove(i);
		}
	}
	function sendCompanyCategory()
	{
		if(document.getElementById('companyCategory').options.length<=0)	{
			alert("<cf_get_lang_main no='1535.Lütfen Kategori Seçiniz'> !");
			return false;
		}
		var m = document.getElementById('companyCategory').length;
		for(i=0;i<m;i++)
		{
			document.getElementById('companyCategory').options[i].selected==true;
			cat_text = document.getElementById("companyCategory").options[i].text;
			cat_id = document.getElementById("companyCategory").options[i].value;
			
			var kontrol =0;
			
			<cfif  Len (attributes.return_field)>
					<cfoutput>
						 uzunluk = window.opener.document.getElementById('#attributes.return_field#').length;
						for(i=0;i<uzunluk;i++){
							if(window.opener.document.getElementById('#attributes.return_field#').options[i].value==cat_id){
								kontrol=1;
							}
						}
						if(kontrol==0){
							x = window.opener.document.getElementById('#attributes.return_field#').length;
							window.opener.document.getElementById('#attributes.return_field#').length = parseInt(x + 1);
							window.opener.document.getElementById('#attributes.return_field#').options[x].value = cat_id;
							window.opener.document.getElementById('#attributes.return_field#').options[x].text = cat_text;
						}
					</cfoutput>
			 <cfelse> 
					<cfoutput>
					 uzunluk = window.opener.document.getElementById('product_category').length;
					for(l=0;l<uzunluk;l++){
						if(window.opener.document.getElementById('product_category').options[l].value==cat_id){
							kontrol=1;
						}
					}
					if(kontrol==0){
						x = window.opener.document.getElementById('product_category').length;
						window.opener.document.getElementById('product_category').length = parseInt(x + 1);
						window.opener.document.getElementById('product_category').options[x].value = cat_id;
						window.opener.document.getElementById('product_category').options[x].text = cat_text;
					}
				</cfoutput>
			 </cfif>
		}
		window.close();
	}
</script>
