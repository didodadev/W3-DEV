<div style="position:absolute; margin:35px; left:400px;" id="showCategory"></div>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.sector" default="">
<cfparam name="attributes.product_status" default="">
<cfparam name="attributes.is_catalog" default="">
<cfparam name="attributes.product_stage" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<!--- urun ve katalog, ayni sayfada calistigindan ayirt etmek adina fuseaction kontrolu konuldu --->
<cfif attributes.fuseaction contains 'product'>
	<cfset attributes.is_catalog = 0>
<cfelse>
	<cfset attributes.is_catalog = 1>
</cfif>
	
<cfset getProcess = createObject("component","V16.worknet.query.worknet_process").getProcess(fuseaction:attributes.fuseaction)/>
<cfif isdefined('attributes.form_submitted')>
	<cfset cmp = createObject("component","V16.worknet.query.worknet_product") />
	<cfset getProduct = cmp.getProduct(
		keyword:attributes.keyword,
		product_catid:attributes.product_catid,
		product_cat:attributes.product_cat,
		product_status:attributes.product_status,
		company_id:attributes.company_id,
		company_name:attributes.company_name,
		product_stage:attributes.product_stage,
		is_catalog:attributes.is_catalog
	) />
<cfelse>
	<cfset getProduct.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#getProduct.recordcount#">
<cfform name="search_product" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
	<cfif attributes.is_catalog eq 0>
		<cfset title = "#getLang('main',152)#">
<cfelse>
		<cfset title = "#getLang('main',182)#">
	</cfif> 
<cf_medium_list_search title="Ürünler">
<cf_medium_list_search_area>
<table>
	<tr>
		<td>
        	<input type="hidden" name="field_id" id="field_id" value="<cfif isdefined("attributes.field_id")><cfoutput>#attributes.field_id#</cfoutput></cfif>" />
            <input type="hidden" name="field_name" id="field_name" value="<cfif isdefined("attributes.field_name")><cfoutput>#attributes.field_name#</cfoutput></cfif>"/>
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_get_lang_main no='48.Filtre'>
            <cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" style="width:125px;">
        </td>
        <td><!--- Uye Bilgisi --->
            <cf_get_lang_main no ='246.Üye'>
			<input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
			<input type="text" name="company_name" id="company_name" style="width:130px;" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','form','3','250');" value="<cfif len(attributes.company_name)><cfoutput>#attributes.company_name#</cfoutput></cfif>" autocomplete="off">
            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=search_product.company_id&field_comp_name=search_product.company_name&select_list=2</cfoutput>&keyword='+encodeURIComponent(search_product.company_name.value),'list','popup_list_pars');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>
         </td>
         <td>
         	<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px; text-align:center">
         </td>
         <td>	
            <cf_wrk_search_button is_excel="0">
         </td>
    </tr>
</table> 
</cf_medium_list_search_area>        
<cf_medium_list_search_detail_area>
<table>
	<tr>         	
         <td>		<!--- Asama --->
            <select name="product_stage" id="product_stage">
                <option value=""><cf_get_lang_main no='70.Aşama'></option>
                <cfoutput query="getProcess">
                    <option value="#process_row_id#" <cfif attributes.product_stage eq process_row_id>selected</cfif>>#stage#</option>
                </cfoutput>
            </select>
         </td>
         <td><!--- Aktif/Pasif Durumu --->
            <select name="product_status" id="product_status">
                <option value=""><cf_get_lang_main no ='344.Durum'></option>
                <option value="1" <cfif attributes.product_status eq 1>selected</cfif>><cf_get_lang_main no ='81.Aktif'></option>
                <option value="0" <cfif attributes.product_status eq 0>selected</cfif>><cf_get_lang_main no ='82.Pasif'></option>
            </select>
        </td>
        <td><!--- Urun Kategorileri --->
            <input type="hidden" name="product_catid" id="product_catid" value="<cfif isdefined('attributes.product_catid') and len(attributes.product_catid)><cfoutput>#attributes.product_catid#</cfoutput></cfif>" />
            <input type="text" name="product_cat" id="product_cat" style="width:150px;" value="<cfif isdefined('attributes.product_cat') and len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput><cfelse><cf_get_lang_main no='155.Ürün Kategorileri'></cfif>" <!---onfocus="goster(showCategory);openProductCat();"--->/>
            <a href="javascript://" onClick="goster(showCategory);openProductCat();" class="tableyazi"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>
        </td>
	</tr>
</table>
</cf_medium_list_search_detail_area>  
</cf_medium_list_search> 
</cfform>

<cf_medium_list>
	<thead>
    	<tr>
        	<th><cf_get_lang_main no='75.No'></th>
        	<th><cf_get_lang_main no ='1225.Logo'></th>
            <th><cfif attributes.is_catalog eq 0 ><cf_get_lang_main no='245.Ürün'><cfelse><cf_get_lang no='154.Katalog'></cfif><cf_get_lang_main no='485.Adı'></th>
            <th><cf_get_lang_main no='640.Özet'></th>
            <th><cf_get_lang_main no='70.Aşama'></th>
            <th><cf_get_lang_main no ='344.Durum'></th>
            <th><cf_get_lang_main no='74.Kategori'></th>
            <th><cf_get_lang_main no='162.Şirket'></th>
            <th><cf_get_lang_main no='166.Yetkili'></th>
        </tr>
   	</thead>
    <tbody>
	<cfif getProduct.recordcount>
	<cfoutput query="getProduct" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
        <tr>
            <td>
                #currentrow#
            </td>
            <td style="width:52px;" align="center">
                <cfif len(path)>
                    <cf_get_server_file output_file="product/#path#" output_server="#path_server_id#" output_type="0" image_width="50" image_height="40">
                <cfelse>
                    <img src="/images/no_photo.gif" width="50" height="50">
                </cfif>
            </td>
            <td><a href="javascript://" onclick="atama('#PRODUCT_ID#','#PRODUCT_NAME#');"class="tableyazi">#product_name#</a></td>
            <td>#product_description#</td>
                <cfset getProductProcess = createObject("component","V16.worknet.query.worknet_process").getProcess(fuseaction:attributes.fuseaction,process_row_id:getProduct.product_stage)/>
            <td>#getProductProcess.stage#</td>
            <td><cfif product_status eq 1><cf_get_lang_main no ='81.Aktif'><cfelse><cf_get_lang_main no ='82.Pasif'></cfif></td>
            <td><cfif len(product_cat)>#product_cat#</cfif></td>
            <td>#fullname#</td>
            <td>#partner_name#</td>
        </tr>
	</cfoutput>
        <cfelse>
                <tr>
                    <td colspan="9"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
                </tr>
        </cfif>
     </tbody>
</cf_medium_list>

<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif isDefined("attributes.form_submitted")>
		<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
	</cfif>
    <cfif isDefined("attributes.field_id")>
		<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
	</cfif>
    <cfif isDefined("attributes.field_name")>
		<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
	</cfif>
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.company_id)>
		<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
	</cfif>
	<cfif len(attributes.company_name)>
		<cfset url_str = "#url_str#&company_name=#attributes.company_name#">
	</cfif>
	<cfif len(attributes.product_stage)>
		<cfset url_str = "#url_str#&product_stage=#attributes.product_stage#">
	</cfif>
	<cfif len(attributes.product_status)>
		<cfset url_str = "#url_str#&product_status=#attributes.product_status#">
	</cfif>
	<cfif len(attributes.product_catid)>
		<cfset url_str = "#url_str#&product_catid=#attributes.product_catid#">
	</cfif>
	<cfif len(attributes.product_cat)>
		<cfset url_str = "#url_str#&product_cat=#attributes.product_cat#">
	</cfif>
	<cfif len(attributes.is_catalog)>
		<cfset url_str = "#url_str#&is_catalog=#attributes.is_catalog#">
	</cfif>
	<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#" 
	adres="#attributes.fuseaction##url_str#">
			
</cfif>

<script language="javascript">
	function openProductCat()
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.selected_product_cat','showCategory',1,'Loading..');
	}
	
	function atama (pid,pname)
	{
		<cfif isdefined("attributes.field_id")>
			window.opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value = pid;
		</cfif>
		<cfif isdefined("attributes.field_name")>
			window.opener.document.<cfoutput>#attributes.field_name#</cfoutput>.value = pname;
		</cfif>	
		window.close();
	}
	
</script>

