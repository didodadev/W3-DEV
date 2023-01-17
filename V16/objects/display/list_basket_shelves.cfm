<!---
	açan penceredeki istenen alana seçilenleri kaydeder
	form_name :  Formun adi gelicek
	field_shelf_name : raf adının düşürülecegi alan
	field_shelf_code : raf kodunun düşürülecegi alan
	field_department_id : departman id si 
	field_location_id : lokasyon id si
	field_location : lokasyon adı // BK 20060612
	
	fis_type : Eger Stok acilis Fisi ekliyorsak (donem basinda) bir depoda acilis fisi varsa odepoyu listelememsi icin parametre olarak gonderiliyor.
	<a href="#" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=#formunadi#&field_name=##&field_id=##','list')">

	is_no_sale parametresi tanımlı ise depoda satış yapılamaz ifadesi varsa depode link olmaz. BK 20060408
	location_type parametresi eklendi. 1-Hammadde Depo 2- Mal Depo 3-Mamul Depo BK 20060419
	is_delivery parametresi tanımlı ise servis lokasyonu secili olan depo lokasyonları geliyor BK 20060511
	department_id_value parametresi secilen departmana ait lokasyonların gelmesi icin eklendi. BK 20060612	
	dsp_service_loc parametresi tanımlı ise servis lokasyonları, lokasyonun diğer özelliklerine ve  is_no_sale parametresine bakılmaksızın,sayfada linki gelir. OZDEN20070713
--->

<cfparam name="attributes.system_company_id" default="#session.ep.company_id#">
<cfinclude template="../query/get_stores.cfm">
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT
		*
	FROM
		STOCKS_LOCATION
	WHERE
		STATUS = 1 <!--- aktif olan lokasyonlar icin --->
  	<cfif isdefined("attributes.location_type") and len(attributes.location_type)>
		AND LOCATION_TYPE = #attributes.location_type#
	</cfif>
  	<cfif isdefined("attributes.is_delivery") and len(attributes.is_delivery)>
		AND DELIVERY = 1
  	</cfif>
  	<cfif isdefined("attributes.department_id_value") and len(attributes.department_id_value)>
		AND DEPARTMENT_ID = #attributes.department_id_value#
  	</cfif>
</cfquery>
<script type="text/javascript">
function add_location(in_coming_id,in_coming_name,in_coming_store_name,in_coming_store_id,branch_id)
{
	<cfif isdefined("attributes.field_name")>
		opener.document.<cfoutput>#form_name#.#field_name#</cfoutput>.value = in_coming_store_name +'-' +in_coming_name;
	</cfif>
	<cfif isdefined("attributes.field_id")>
		opener.document.<cfoutput>#form_name#.#field_id#</cfoutput>.value = in_coming_id;
	</cfif>
	<cfif isdefined("attributes.branch_id")>
		opener.document.<cfoutput>#form_name#.#branch_id#</cfoutput>.value = branch_id;	
	</cfif>
	window.close();
}
function add_store(in_coming_id, in_coming_name, basket,branch_id)
{
	<cfif isdefined("attributes.field_name")>
		opener.document.<cfoutput>#form_name#.#field_name#</cfoutput>.value = in_coming_name ;
	</cfif>	
	<cfif isdefined("attributes.field_id")>
		opener.document.<cfoutput>#form_name#.#field_id#</cfoutput>.value = in_coming_id;
	</cfif>	
	<cfif isdefined("attributes.branch_id")>
		opener.document.<cfoutput>#form_name#.#branch_id#</cfoutput>.value = branch_id;	
	</cfif>	
	if(basket == 1)
	{
		window.opener.clear_fields();
		opener.form_basket.submit();
	}
	window.close();
}
<cfif isdefined("attributes.field_location_id")>
function add_dept_loc(department_id, location_id, department_name, location_name,branch_id,partner_id,partner_name,partner_surname,company_id,company_name,company_address)
{
	<cfif isdefined("attributes.branch_id")>
		opener.document.<cfoutput>#form_name#.#branch_id#</cfoutput>.value = branch_id;	
	</cfif>	
	if(location_id != '')
	{
		<cfif isdefined("attributes.field_location")>
			opener.document.<cfoutput>#form_name#.#field_location#</cfoutput>.value = location_name;	
		</cfif>
		<cfif isdefined("attributes.field_name")>
			opener.document.<cfoutput>#form_name#.#field_name#</cfoutput>.value = department_name + '-' + location_name;
		</cfif>
		<cfif isdefined("attributes.field_id")>
			opener.document.<cfoutput>#form_name#.#field_id#</cfoutput>.value = department_id;
		</cfif>	
		opener.document.<cfoutput>#form_name#.#field_location_id#</cfoutput>.value = location_id;
	}
	else
	{
		add_store(department_id, department_name,<cfif isdefined('url.basket')>1<cfelse>0</cfif>);
	}
	<cfif isdefined("attributes.is_ingroup")>
		opener.document.form_basket.partner_id.value = partner_id;
		opener.document.form_basket.partner_name.value = partner_name+' '+partner_surname;
		opener.document.form_basket.company_id.value = company_id;
		opener.document.form_basket.comp_name.value = company_name;
		opener.document.form_basket.adres.value = company_address;
	</cfif>
	window.close();
}
</cfif>
<cfif isdefined("attributes.row_id")>
function add_dept_loc(department_id, location_id, department_name, location_name)
{
	if(location_id=='')location_id=0;
	if(opener.form_basket.product_id.length != undefined) /* sepet de birden fazla satır var*/
	{
		opener.document.<cfoutput>#form_name#.#field_name#[#attributes.row_id-1#]</cfoutput>.value = department_name + '-' + location_name;
		opener.document.<cfoutput>#form_name#.#field_id#[#attributes.row_id-1#]</cfoutput>.value = department_id + '-' + location_id;
	}
	else /* sepet tek satır */
	{
		opener.document.<cfoutput>#form_name#.#field_name#</cfoutput>.value = department_name + '-' + location_name;
		opener.document.<cfoutput>#form_name#.#field_id#</cfoutput>.value = department_id + '-' + location_id;
	}
	window.close();
}
</cfif>
</script>

<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
  		<td class="headbold"><cf_get_lang dictionary_id='32768.Depolar ve Lokasyonlar'></td>
	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr class="color-border">
		<td>
		<table width="100%" border="0" cellspacing="1" cellpadding="2">
			<tr height="22" class="color-header">
				<td class="form-title"><cf_get_lang dictionary_id='58763.Depo'></td>
				<td class="form-title"><cf_get_lang dictionary_id='58585.Kod'></td>
				<td class="form-title"><cf_get_lang dictionary_id='57453.Şube'></td>
				<td class="form-title" width="60"><cf_get_lang dictionary_id='32769.W H D'></td>
 			</tr>
	<cfif get_stores.recordcount>
		<cfoutput query="get_stores">
		<cfquery name="GET_LOCATION" dbtype="query">
			SELECT
				*
			FROM
				GET_ALL_LOCATION
			WHERE
				DEPARTMENT_ID = #get_stores.department_id[currentrow]#
		</cfquery>
		<cfif get_location.recordcount>
	 		<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			<td class="txtbold">#department_head#</td>
			<td>#department_id#</td>
			<td>#branch_name#</td>
			<td></td>
		</tr>
	<cfloop from="1" to="#get_location.recordcount#" index="s">							
	  	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			<td nowrap>
		  	<cfif isdefined("attributes.field_location_id") or isdefined("attributes.row_id")>
		 		<cfif isdefined("attributes.is_ingroup")>
					<cfif isdefined('dsp_service_loc') and get_location.delivery[s] eq 1>
				  		<a href="javascript://" onClick="add_dept_loc('#get_stores.department_id#','#get_location.location_id[s]#','#department_head#','#get_location.comment[s]#',#branch_id#,'#partner_id#','#company_partner_name#','#company_partner_surname#','#grp_comp_id#','#fullname#','#company_address#');" class="tableyazi" >&nbsp;&nbsp;#get_location.comment[s]#</a>
					<cfelseif isdefined("attributes.is_no_sale") and get_location.no_sale[s] eq 1><!--- Fatura+Irsaliye (Satıs) --->
						&nbsp;&nbsp;#get_location.comment[s]#
					<cfelse>
				  		<a href="javascript://" onClick="add_dept_loc('#get_stores.department_id#','#get_location.location_id[s]#','#department_head#','#get_location.comment[s]#',#branch_id#,'#partner_id#','#company_partner_name#','#company_partner_surname#','#grp_comp_id#','#fullname#','#company_address#');" class="tableyazi" >&nbsp;&nbsp;#get_location.comment[s]#</a>
					</cfif>
		  		<cfelse>
					<cfif isdefined('dsp_service_loc') and get_location.delivery[s] eq 1>
			  			<a href="javascript://" onClick="add_dept_loc('#get_stores.department_id#','#get_location.location_id[s]#','#department_head#','#get_location.comment[s]#',#branch_id#,'','','','','','');" class="tableyazi" >&nbsp;&nbsp;#get_location.comment[s]#</a>
			  		<cfelseif isdefined("attributes.is_no_sale") and get_location.no_sale[s] eq 1><!--- Fatura+Irsaliye (Satıs) --->
			  			&nbsp;&nbsp;#get_location.comment[s]#
			  		<cfelse>
			  			<a href="javascript://" onClick="add_dept_loc('#get_stores.department_id#','#get_location.location_id[s]#','#department_head#','#get_location.comment[s]#',#branch_id#,'','','','','','');" class="tableyazi" >&nbsp;&nbsp;#get_location.comment[s]#</a>
			  		</cfif>
		  		</cfif>
		  	<cfelse>
		  		<a href="javascript://" onClick="add_location('#get_location.department_location[s]# ','#get_location.comment[s]#','#department_head#','#get_stores.department_id#',#branch_id#)" class="tableyazi" >&nbsp;&nbsp;#get_location.comment[s]#</a> 
			</cfif>
			</td>
			<td>#department_id#-#get_location.location_id[s]#</td>
			<td>#branch_name#</td>
			<td>
				#get_location.width#
				<cfif len(get_location.width)> *</cfif>#get_location.height#
				<cfif len(get_location.height)> *</cfif>#get_location.depth#
			</td>
	  	</tr>
	</cfloop>
	</cfif> 
	</cfoutput>
	<cfelse>
		<tr class="color-row">
			<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
		</tr>
	</cfif>
	</table>
	</td>
  </tr>
</table>
<br/>
