<cfset cmp = createObject("component","V16.worknet.cfc.product") />
<cfset getProduct = cmp.getProduct(product_id:attributes.pid)>
<cfset getProductCat = cmp.getProductCat(catid:getProduct.product_catid)>
<cfset getRelatedProduct = cmp.getRelatedProduct(r_product_id:getProduct.related_product_id)>
<link rel="stylesheet" href="/css/assets/template/fileupload/dropzone.css" type="text/css">
<link rel="stylesheet" href="/css/assets/template/fileupload/fileupload-min.css" type="text/css">

<!--- <cfif not getProduct.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1230.Urun Kaydı Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
</cfif> --->
<!--- <table border="0" width="98%" class="headbold" cellpadding="0" cellspacing="0" align="center">
  <tr>
	<td height="35">
	<cfif attributes.fuseaction contains 'product'>
		<cf_get_lang_main no ='245.Ürün'>
	<cfelse>
		<cf_get_lang no='154.Katalog'>
	</cfif>: <cfoutput>#getProduct.product_name#</cfoutput></td>
<!--- 	<td style="text-align:right"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=worknet.popup_product_history&product_id=#attributes.pid#</cfoutput>','medium','popup_product_history');"><img src="/images/history.gif" title="<cf_get_lang_main no='61.Tarihçe'>" border="0"></a></td>
 --->  </tr>
</table> --->
<cf_catalystHeader>
<div class="row"> 
	<div class="col col-9 col-xs-12">
		<cfinclude template="detail_product_content.cfm">
	</div>
	<div class="col col-3 col-xs-12">
		<cfinclude template="detail_product_right.cfm">
	</div>
</div>

<script type="text/javascript" src="/JS/fileupload/dropzone.js"></script>
<script type="text/javascript" src="/JS/fileupload/fileupload-min.js"></script>
<script language="javascript">

	$(function(){
		///for file upload area text
		if($(window).width() < 768){
			$(".dz-default").html("<span><cfoutput>#getLang('assetcare',472)#</cfoutput></span>");
		}

		$(window).resize(function(){
			if($(window).width() < 768){
				$(".dz-default").html("<span><cfoutput>#getLang('assetcare',472)#</cfoutput></span>");
			}else{
				$(".dz-default").html("<span><cfoutput>#getLang('assetcare',309)#</cfoutput></span>");
			}
		});
	});

	function openProductCat()
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.selected_product_cat','showCategory',1,'Loading..');
	}

	function kontrol()
	{
		if(document.getElementById('product_name').value == '')
		{
			alert("<cf_get_lang no ='72.Lütfen Ürün İsmi Giriniz'>!");
			document.getElementById('product_name').focus();
			return false;
		}
		if(document.getElementById('product_keyword').value == '')
		{
			alert("Lütfen ürün anahtar kelime giriniz!");
			document.getElementById('product_keyword').focus();
			return false;
		}
		if(document.getElementById('description').value == '')
		{
			alert("Lütfen özet bilgisi giriniz!");
			document.getElementById('description').focus();
			return false;
		}
		if(CKEDITOR.instances.product_detail.getData() == '')
		{
			alert("Lütfen açıklama giriniz!");
			return false;
		}
		/* if(document.getElementById('product_catid').value == '' || document.getElementById('product_cat').value == '' )
		{
			alert("<cf_get_lang_main no='1535.Lütfen Kategori Seçiniz'> !");
			document.getElementById('product_cat').focus();
			return false;
		} */
		if(document.getElementById('product_code').value == '')
		{
			alert("Lütfen ürün kodu giriniz!");
			document.getElementById('product_code').focus();
			return false;
		}
		if(document.getElementById('r_product_multi_id')!= undefined)
		{
				select_all('r_product_multi_id');
		}
		if(document.getElementById('product_catid')!= undefined)
		{
				select_all('product_catid');
		}
		if(document.getElementById('company_id').value == '' || document.getElementById('company_name').value == '' )
		{
			alert('Lütfen üye seçiniz !');
			document.getElementById('company_name').focus();
			return false;
		}
		if(document.getElementById('partner_id').value == '' || document.getElementById('partner_name').value == '' )
		{
			alert('Lütfen üye seçiniz !');
			document.getElementById('partner_name').focus();
			return false;
		}
		if(document.getElementById('watalogy_con_id').value == '' || document.getElementById('watalogy_con').value == '' )
		{
			alert('Lütfen watalogy bağlantısı yapınız !');
			document.getElementById('watalogy_con').focus();
			return false;
		}
		return true;
	}

	function project_remove()
	{
		for (i=document.getElementById('r_product_multi_id').options.length-1;i>-1;i--)
		{
			if (document.getElementById('r_product_multi_id').options[i].selected==true)
			{
				document.getElementById('r_product_multi_id').options.remove(i);
			}	
		}
	}

	function cat_remove()
	{
		for (i=document.getElementById('product_catid').options.length-1;i>-1;i--)
		{
			if (document.getElementById('product_catid').options[i].selected==true)
			{
				document.getElementById('product_catid').options.remove(i);
			}	
		}
	}

	function select_all(selected_field)
	{
		var m = document.getElementById(selected_field).options.length;
		for(i=0;i<m;i++)
		{
			document.getElementById(selected_field)[i].selected=true;
		}
	}

	function counterr()
	 { 
		if (document.add_product.description.value.length > 250) 
		{
			document.add_product.description.value = document.add_product.description.value.substring(0, 250);
			alert("<cf_get_lang_main no='1324.Maksimum Mesaj Karekteri'>: 250");  
		}
		else 
			document.getElementById('descLen').value = 250 - (document.add_product.description.value.length); 
	 }

	/* function openProductCat()
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.selected_product_cat','showCategory',1,'Loading..');
	} 
	
	function kontrol()
	{
		if(document.getElementById('product_catid').value == '' || document.getElementById('product_cat').value == '' )
		{
			alert("<cf_get_lang_main no='1535.Lütfen Kategori Seçiniz'> !");
			document.getElementById('product_cat').focus();
			return false;
		}
		if(document.getElementById('company_id').value == '' || document.getElementById('company_name').value == '' )
		{
			alert('Lütfen üye seçiniz !');
			document.getElementById('company_name').focus();
			return false;
		}
		if(document.getElementById('product_name').value == '')
		{
			alert("<cf_get_lang no ='72.Lütfen Ürün İsmi Giriniz'>!");
			document.getElementById('product_name').focus();
			return false;
		}
		if(document.getElementById('product_keyword').value == '')
		{
			alert("Lütfen ürün anahtar kelime giriniz!");
			document.getElementById('product_keyword').focus();
			return false;
		}
		if(document.upd_product.description.value == '')
		{
			alert("Lütfen özet bilgisi giriniz!");
			document.getElementById('description').focus();
			return false;
		}
		if(CKEDITOR.instances.product_detail.getData() == '')
		{
			alert("Lütfen açıklama giriniz!");
			return false;
		}
	}
	function counter()
	 { 
		if (document.upd_product.description.value.length > 250) 
		  {
				document.upd_product.description.value = document.upd_product.description.value.substring(0, 250);
				alert("<cf_get_lang_main no='1324.Maksimum Mesaj Karekteri'>: 250"); 
		   }
		else 
			document.getElementById('detailLen').value = 250 - (document.upd_product.description.value.length); 
	 }
	counter();*/
</script>

