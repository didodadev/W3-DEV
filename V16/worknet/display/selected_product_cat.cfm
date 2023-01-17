<cfsetting showdebugoutput="no">
<cfif isdefined('session.ep')>
	<cfset getMainProductCat = createObject("component","V16.worknet.query.worknet_product").getMainProductCat()>
<cfelse>
	<cfset getMainProductCat = createObject("component","V16.worknet.query.worknet_product").getMainProductCat(is_internet=1)>
</cfif>
<cfif isdefined('attributes.divID') and len(attributes.divID)>
    <table width="650" height="150" align="center" cellpadding="2" cellspacing="1" border="0" id="productCategoriesMain">
        <tr>
            <td> 
                <cf_box id="add_product2" closable="0" collapsable="0">
                    <table>	
                        <tr height="20">
                            <td class="txtboldblue"><cf_get_lang no='164.Ana Kategori'></td>
                            <td class="txtboldblue"><cf_get_lang no='165.Alt Kategori'></td>
                        </tr>
                        <tr>
                            <td>
                                <select name="main_category2" id="main_category2" style="width:300px;height:100px;" size="5" onchange="loadajaxsubcategory2();">
                                    <cfoutput query="getMainProductCat">
                                        <option value="#product_catid#">#product_cat#</option>
                                    </cfoutput>
                                </select>
                            </td>
                            <td>
                                <div id="subProductCategory2" style="width:300px;height:100px;">
                                    <select name="subCategory2" id="subCategory2" style="width:300px;height:100px;" size="5" ></select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align:right;">
                                <div id="buttons" style="width:200px;">
									<input type="button" id="btnSelect" value="<cf_get_lang_main no='1281.Seç'>" onclick="addProductCat2();"/>
									<input type="button" id="btnSelect1" value="<cf_get_lang_main no='50.Vazgeç'>" onclick="closeCategory2();"/>
								</div>
                            </td>
                        </tr>
                    </table>
                </cf_box>
            </td>
        </tr>
    </table>
    
    <script language="javascript">
        function loadajaxsubcategory2()	
        {
		    var send_address = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.subCategory&type=1&mainCategoryId=";
            send_address += document.getElementById('main_category2').value;
            AjaxPageLoad(send_address,'subProductCategory2',1,'Loading...');
        }
        
        function addProductCat2()
        {		
            catMainIndex = document.getElementById('main_category2').selectedIndex;
            catSubIndex = document.getElementById('subCategory2').selectedIndex;
            
            if(catMainIndex >= 0 || catSubIndex >= 0)
            {
                cat_main_text = document.getElementById("main_category2").options[catMainIndex].text;
                cat_main_id = document.getElementById("main_category2").options[catMainIndex].value;
                
                if(catSubIndex >= 0)
                {
                    cat_sub_text = document.getElementById("subCategory2").options[catSubIndex].text;
                    cat_sub_id = document.getElementById("subCategory2").options[catSubIndex].value;
                    
					document.getElementById('product_catid2').value = cat_sub_id;
					document.getElementById('product_cat2').value = cat_main_text +' > '+ cat_sub_text;
                }
                else
                {
					document.getElementById('product_catid2').value = cat_main_id;
					document.getElementById('product_cat2').value = cat_main_text;		
                }
				document.getElementById('<cfoutput>#attributes.divID#</cfoutput>').style.display = 'none';
            }
            else
            {
                alert("<cf_get_lang_main no='1535.Lütfen Kategori Seçiniz'> !");
                return false;
            }
        }
        function closeCategory2()
		{document.getElementById('<cfoutput>#attributes.divID#</cfoutput>').style.display = 'none';}
    </script>
<cfelse>
    <table width="650" height="150" align="center" cellpadding="2" cellspacing="1" border="0" id="productCategoriesMain">
        <tr>
            <td> 
                <cf_box id="add_product" closable="0" collapsable="0">
                    <table>	
                        <tr height="20">
                            <td class="txtboldblue"><cf_get_lang no='164.Ana Kategori'></td>
                            <td class="txtboldblue"><cf_get_lang no='165.Alt Kategori'></td>
                        </tr>
                        <tr>
                            <td>
                                <select name="main_category" id="main_category" style="width:300px;height:100px;" size="5" onchange="loadajaxsubcategory();">
                                    <cfoutput query="getMainProductCat">
                                        <option value="#product_catid#">#product_cat#</option>
                                    </cfoutput>
                                </select>
                            </td>
                            <td>
                                <div id="subProductCategory" style="width:300px;height:100px;">
                                    <select name="subCategory" id="subCategory" style="width:300px;height:100px;" size="5" ></select>
                                </div>
                            </td>
                        </tr>
                       <tr>
                            <td colspan="2" style="text-align:right;">
                                 <div id="buttons" style="width:200px;">
									<input type="button" id="btnSelect" value="<cf_get_lang_main no='1281.Seç'>" onclick="addProductCat();"/>
									<input type="button" id="btnSelect" value="<cf_get_lang_main no='50.Vazgeç'>" onclick="closeCategory();"/>
								</div>
                            </td>
                        </tr>
                    </table>
                </cf_box>
            </td>
        </tr>
    </table>
    
    <script language="javascript">
        function loadajaxsubcategory()	
        {
            var send_address = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.subCategory&type=0&mainCategoryId=";
            send_address += document.getElementById('main_category').value;
            AjaxPageLoad(send_address,'subProductCategory',1,'Alt Kategoriler');
        }
        
        function addProductCat()
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
                    
					document.getElementById('product_catid').value = cat_sub_id;
					document.getElementById('product_cat').value = cat_main_text +' > '+ cat_sub_text;
                }
                else
                {
					document.getElementById('product_catid').value = cat_main_id;
					document.getElementById('product_cat').value = cat_main_text;
                }
				document.getElementById('showCategory').style.display = 'none';
            }
            else
            {
                alert("<cf_get_lang_main no='1535.Lütfen Kategori Seçiniz'> !");
                return false;
            }
        }
        function closeCategory()
			{document.getElementById('showCategory').style.display = 'none';}
    </script>
</cfif>

