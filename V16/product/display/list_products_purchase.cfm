<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.page" default="1">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.compid")>
	<cfset dsn3 = "#dsn#_#attributes.compid#">
</cfif>
<cfparam name="attributes.product_cat_code" default=''>
<cfparam name="attributes.search_company_id" default=''>
<cfparam name="attributes.employee_id" default=''>
<cfparam name="attributes.keyword" default=''>
<cfif isdefined("attributes.is_submitted") or len(attributes.keyword)>
	<cfinclude template="../query/get_products_purchase.cfm">
	<cfset arama_yapilmali=0>
<cfelse>
	<cfset products.recordcount=0>
	<cfset arama_yapilmali=1>
</cfif>
<cfif products.recordcount>
	<cfparam name="attributes.totalrecords" default="#products.query_count#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="#products.recordcount#">
</cfif>
<cfset url_str = "">
<cfif isdefined("module_name")>
	<cfset url_str = "#url_str#&module_name=#module_name#">
</cfif>
<cfif isdefined("attributes.startdate")>
	<cfset url_str = "#url_str#&startdate=#attributes.startdate#">
</cfif>
<cfif isdefined("attributes.finishdate")>
	<cfset url_str = "#url_str#&finishdate=#attributes.finishdate#">
</cfif>
<cfif isdefined("attributes.price_lists")>
	<cfset url_str = "#url_str#&price_lists=#attributes.price_lists#">
</cfif>
<cfif isdefined("attributes.compid")>
	<cfset url_str = "#url_str#&compid=#attributes.compid#">
</cfif>
<cfif isdefined("attributes.finishdate")>
	<cfset attributes.finishdate2 = attributes.finishdate>
	<cf_date tarih='attributes.finishdate2'>
</cfif>
<cfoutput> 
    <table class="harfler">
        <tr>
            <td>&nbsp;</td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=A">A</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=B">B</a></td> 
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=C">C</a></td> 
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=D">D</a></td> 
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=E">E</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=F">F</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=G">G</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=H">H</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=I">I</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=İ">İ</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=J">J</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=K">K</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=L">L</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=M">M</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=N">N</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=O">O</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=P">P</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=Q">Q</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=R">R</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=S">S</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=Ş">Ş</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=T">T</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=U">U</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=Ü">Ü</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=V">V</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=W">W</a></td> 
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=X">X</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=Y">Y</a></td>
            <td><a href="#request.self#?fuseaction=product.popup_products&#url_str#&var_=#attributes.var_#&keyword=Z">Z</a></td>
            <td>&nbsp;</td>
        </tr>
    </table>    	 
</cfoutput> 
<cfsavecontent variable="message"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></cfsavecontent>
<cf_medium_list_search title="#message#">
    <cfform name="price_cat" action="#request.self#?fuseaction=product.popup_products#url_str#&var_=#attributes.var_#" method="post">
      <input type="hidden" name="is_submitted" id="is_submitted" value="1">
      <cf_medium_list_search_area> 
            <table>
                <tr> 
					<td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
					<td><cfinput type="text" name="keyword" value="#attributes.keyword#" style="width:100px;"></td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><input type="image" src="/images/ara.gif" border="0" onClick="if(!input_control()) return false;"></td>
				</tr>       
			</table>
	  </cf_medium_list_search_area>
      <cf_medium_list_search_detail_area>
			<table>
				<tr>
					<td><cf_get_lang dictionary_id='57544.Sorumlu'></td>
					<td>
						<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
						<input type="text" name="employee" id="employee" style="width:120px;" value="<cfif len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)><cfoutput>#get_emp_info(attributes.employee_id,1,0)#</cfoutput></cfif>" maxlength="255">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=price_cat.employee_id&field_name=price_cat.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.price_cat.employee.value),'list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
					</td>
					<td><cf_get_lang dictionary_id='29533.Tedarikçi'></td>
					<td>
						<input type="hidden" name="search_company_id" id="search_company_id" value="<cfoutput>#attributes.search_company_id#</cfoutput>">
						<input type="text" name="search_company" id="search_company" style="width:120px;" value="<cfif len(attributes.search_company_id) and isdefined("attributes.search_company") and len(attributes.search_company)><cfoutput>#get_par_info(attributes.search_company_id,1,1,0)#</cfoutput></cfif>">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=price_cat.search_company&field_comp_id=price_cat.search_company_id&select_list=2&keyword='+encodeURIComponent(document.price_cat.search_company.value),'list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
					</td>
					<td><cf_get_lang dictionary_id='57486.Kategori'></td>			
					<td>
						<input type="text" name="product_cat_code" id="product_cat_code" style="width:120px;" value="<cfoutput>#attributes.product_cat_code#</cfoutput>">
						<a href="javascript://"onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=3&field_code=price_cat.product_cat_code&keyword='+encodeURIComponent(document.price_cat.product_cat_code.value)</cfoutput>);"><img src="/images/plus_thin.gif" border="0" title="<cf_get_lang dictionary_id='33118.Ürün Kategorisi Ekle'>" align="absmiddle"></a>
					</td>
				</tr>
			</table>
     </cf_medium_list_search_detail_area>
	</cfform>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
        <tr> 
            <th><cf_get_lang dictionary_id='57657.Ürün'></th>
            <th><cf_get_lang dictionary_id='37481.Ürt. Kodu'></th>
            <th width="120" style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'></th>
            <th width="15">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
	<cfset product_id_list=''>
	<cfif products.recordcount>
		<cfoutput query="products">
			<cfif not listfind(product_id_list,product_id)>
				<cfset product_id_list=listappend(product_id_list,product_id)>
			</cfif>
		</cfoutput>
		<cfquery  name="get_discount_pur_all" datasource="#DSN3#">
			SELECT
				DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT4,DISCOUNT5,
				DISCOUNT6,DISCOUNT7,DISCOUNT8,DISCOUNT9,DISCOUNT10,
				PRODUCT_ID,START_DATE,RECORD_DATE
			FROM
				CONTRACT_PURCHASE_PROD_DISCOUNT
			WHERE
				PRODUCT_ID IN (#product_id_list#)
		</cfquery>
		<cfquery name="GET_LAST_PRICE_all" datasource="#dsn3#">
			SELECT 
				PRICE,PRICE_KDV,IS_KDV,MONEY,PRICE_CATID,UNIT,PRODUCT_ID,STARTDATE
			FROM 
				PRICE
			WHERE 
				STARTDATE < #CreateODBCDateTime(attributes.finishdate2)# AND
				PRICE_CATID  IN (#attributes.price_lists#) AND
				PRODUCT_ID IN (#product_id_list#) AND
				<!---ISNULL(STOCK_ID,0)=0 AND--->
				ISNULL(SPECT_VAR_ID,0)=0
		</cfquery>			
		<cfoutput query="products" > 
			<cfquery  name="get_discount_pur" dbtype="query" maxrows="1">
				SELECT
					DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT4,DISCOUNT5,
					DISCOUNT6,DISCOUNT7,DISCOUNT8,DISCOUNT9,DISCOUNT10
				FROM
					get_discount_pur_all
				WHERE
					PRODUCT_ID = #product_id#
				ORDER BY
					START_DATE DESC,
					RECORD_DATE DESC
			</cfquery>
			<cfquery name="GET_LAST_PRICE" dbtype="query" maxrows="1">
				SELECT 
					PRICE,PRICE_KDV,IS_KDV,MONEY,PRICE_CATID
				FROM 
					GET_LAST_PRICE_ALL
				WHERE 
					PRODUCT_ID = #product_id# AND
					UNIT = #products.product_unit_id# 
				ORDER BY
					STARTDATE DESC
			</cfquery>
			<cfscript>
				indirim1 = iif(len(get_discount_pur.DISCOUNT1),get_discount_pur.DISCOUNT1,0);
				indirim2 = iif(len(get_discount_pur.DISCOUNT2),get_discount_pur.DISCOUNT2,0);
				indirim3 = iif(len(get_discount_pur.DISCOUNT3),get_discount_pur.DISCOUNT3,0);
				indirim4 = iif(len(get_discount_pur.DISCOUNT4),get_discount_pur.DISCOUNT4,0);
				indirim5 = iif(len(get_discount_pur.DISCOUNT5),get_discount_pur.DISCOUNT5,0);
				indirim6 = iif(len(get_discount_pur.DISCOUNT6),get_discount_pur.DISCOUNT6,0);
				indirim7 = iif(len(get_discount_pur.DISCOUNT7),get_discount_pur.DISCOUNT7,0);
				indirim8 = iif(len(get_discount_pur.DISCOUNT8),get_discount_pur.DISCOUNT8,0);
				indirim9 = iif(len(get_discount_pur.DISCOUNT9),get_discount_pur.DISCOUNT9,0);
				indirim10 = iif(len(get_discount_pur.DISCOUNT10),get_discount_pur.DISCOUNT10,0);
				if (GET_LAST_PRICE.IS_KDV is 1)
					end_price_2_w_kdv = GET_LAST_PRICE.PRICE_KDV;
				else
					end_price_2_w_kdv = round( (iif(len(GET_LAST_PRICE.PRICE),GET_LAST_PRICE.PRICE,0) * (100+iif(len(tax),tax,0))) / 100 );
			</cfscript>
			<tr>           
				<td style="cursor:pointer" 
				onClick="javascript:opener.add_row('#currentrow#','#product_id#','#product_name#', '#MANUFACT_CODE#', '#iif(len(tax),tax,0)#','#iif(len(tax_purchase),tax_purchase,0)#','#products.add_unit#','#products.product_unit_id#','#products.money#','#indirim1#','#indirim2#','#indirim3#','#indirim4#','#indirim5#','#indirim6#','#indirim7#','#indirim8#','#indirim9#','#indirim10#','#iif(IsNumeric(PRICE),PRICE,0)#','#iif(IsNumeric(PRICE_KDV),PRICE_KDV,0)#','#end_price_2_w_kdv#');">
				#product_name#
				</td> 
				<td>#products.MANUFACT_CODE#</td>
				<td align="right" style="text-align:right;">#TLFormat(products.price)#&nbsp;#money# (#products.add_unit#)</td>
				<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCTS.PRODUCT_ID#','list')"><img src="/images/update_list.gif" border="0"></a></td>
			</tr>
		</cfoutput> 
	<cfelse>
		<tr> 
			<td colspan="4">
				<cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> ! <br/>
				<a href="javascript:window.opener.parent.location='<cfoutput>#request.self#</cfoutput>?fuseaction=product.form_add_product';window.close();" class="tableyazi"> 
				<cf_get_lang dictionary_id='50903.Ürün Kaydetmek İçin Tıklayın'></a></cfif>
			</td>
		</tr>
	</cfif>
    </tbody>
</cf_medium_list>
<cfif attributes.totalrecords gt attributes.maxrows>
<table cellpadding="0" cellspacing="0" border="0" width="98%" align="center" height="35">
	<tr> 
		<td>
			<cfset adres = "product.popup_products">
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.var_)>
				<cfset adres = "#adres#&var_=#attributes.var_#">
			</cfif>
			<cfif isDefined('attributes.product_cat_code') and len(attributes.product_cat_code)>
				<cfset adres = "#adres#&product_cat_code=#attributes.product_cat_code#">
			</cfif>
			<cfif isDefined('attributes.module_name') and len(attributes.module_name)>
				<cfset adres = "#adres#&module_name=#attributes.module_name#">
			</cfif>
			<cfif isdefined("attributes.startdate")>
				<cfset adres = "#adres#&startdate=#attributes.startdate#">
			</cfif>
			<cfif isdefined("attributes.finishdate")>
				<cfset adres = "#adres#&finishdate=#attributes.finishdate#">
			</cfif>
			<cfif isdefined("attributes.price_lists")>
				<cfset adres = "#adres#&price_lists=#attributes.price_lists#">
			</cfif>
			<cfif isdefined("attributes.compid")>
				<cfset adres = "#adres#&compid=#attributes.compid#">
			</cfif>
			<cfif isdefined("is_submitted")>
				<cfset adres="#adres#&is_submitted=1">
			</cfif>
			<cfif isdefined("attributes.employee") and isdefined("attributes.employee_id")>
				<cfset adres = "#adres#&employee=#attributes.employee#&employee_id=#attributes.employee_id#">
			</cfif>
			<cfif isdefined("attributes.search_company") and isdefined("attributes.search_company_id")>
				<cfset adres = "#adres#&search_company=#attributes.search_company#&search_company_id=#attributes.search_company_id#">
			</cfif>
			<cf_pages page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#">
		  </td>
		  <!-- sil -->
		  <td align="right" style="text-align:right;">
		 	 <cfoutput> <cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> 
		  </td>
		  <!-- sil -->
	</tr>
</table>
</cfif>
<script type="text/javascript">
	price_cat.keyword.focus();
	function input_control()
	{	
		if (price_cat.keyword.value.length == 0 && price_cat.employee.value.length == 0 && price_cat.search_company.value.length == 0  && price_cat.product_cat_code.value.length == 0 )
			{
				alert("<cf_get_lang dictionary_id='58950.En az bir alanda filtre etmelisiniz'>!");
				return false;
			}
		else return true;
	}
</script>

