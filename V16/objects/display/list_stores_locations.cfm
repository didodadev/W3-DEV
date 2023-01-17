<!---
	açan penceredeki istenen alana seçilenleri kaydeder
	is_branch : 1 olarak gelirse sadece kendi şubesinin lokasyonlarını seçebilir
	form_name :  Formun adi gelicek
	field_name : departman adinin  gidecegi 
	field_id : departman id si 
	field_location_id : lokasyon id si
	field_location : lokasyon adı
	function_name : opener da calısacak fonksiyon
	fis_type : Eger Stok acilis Fisi ekliyorsak (donem basinda) bir depoda acilis fisi varsa odepoyu listelememsi icin parametre olarak gonderiliyor.
	<a href="#" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=#formunadi#&field_name=##&field_id=##','list')">
	is_no_sale parametresi tanımlı ise depoda satış yapılamaz ifadesi varsa depode link olmaz. BK 20060408
	location_type parametresi eklendi. 1-Hammadde Depo 2- Mal Depo 3-Mamul Depo BK 20060419
	is_delivery parametresi tanımlı ise servis lokasyonu secili olan depo lokasyonları geliyor BK 20060511
	department_id_value parametresi secilen departmana ait lokasyonların gelmesi icin eklendi. BK 20060612	
	dsp_service_loc parametresi tanımlı ise servis lokasyonları, lokasyonun diğer özelliklerine ve  is_no_sale parametresine bakılmaksızın,sayfada linki gelir. OZDEN20070713
	is_authority_branch parameteresi yetkili oldugu subelerin lokasyonlarini getirir.
--->
<cfparam name="attributes.system_company_id" default="#session.ep.company_id#">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.satir" default=""><!--- Basket Çalışmaları için eklendi. Kaldırmayınız. EY20140826--->
<cfset url_string = "">
<cfif isdefined("attributes.form_name")>
	<cfset url_string = "#url_string#&form_name=#attributes.form_name#">
</cfif>
<cfif isdefined("attributes.system_company_id")>
	<cfset url_string = "#url_string#&system_company_id=#attributes.system_company_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_location_id")>
	<cfset url_string = "#url_string#&field_location_id=#attributes.field_location_id#">
</cfif>
<cfif isdefined("attributes.field_location")>
	<cfset url_string = "#url_string#&field_location=#attributes.field_location#">
</cfif>
<cfif isdefined("attributes.branch_id")>
	<cfset url_string = "#url_string#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isdefined("attributes.row_id")>
	<cfset url_string = "#url_string#&row_id=#attributes.row_id#">
</cfif>
<cfif isdefined("attributes.department_id_value")>
	<cfset url_string = "#url_string#&department_id_value=#attributes.department_id_value#">
</cfif>
<cfif isdefined("attributes.satir") and len(attributes.satir)><!--- Basket Çalışmaları için eklendi. Kaldırmayınız. EY20140826--->
	<cfset url_string= "#url_string#&satir=#attributes.satir#">
</cfif>
<cfif isdefined("attributes.is_branch")><cfset url_string = "#url_string#&is_branch=#attributes.is_branch#"></cfif>
<cfinclude template="../query/get_stores.cfm">
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT
		*
	FROM
		STOCKS_LOCATION
	WHERE
		STATUS = 1 <!--- aktif olan lokasyonlar icin --->
  	<cfif isdefined("attributes.location_type") and len(attributes.location_type)>
		AND LOCATION_TYPE IN (#attributes.location_type#)
	</cfif>
  	<cfif isdefined("attributes.is_delivery") and len(attributes.is_delivery)>
		AND DELIVERY = 1
  	</cfif>
  	<cfif isdefined("attributes.department_id_value") and len(attributes.department_id_value)>
		AND DEPARTMENT_ID = #attributes.department_id_value#
  	</cfif>
	<cfif len(attributes.keyword)>
		AND
		( 
			COMMENT LIKE '%#attributes.keyword#%'
			OR
			DEPARTMENT_ID IN (
								SELECT 
									DEPARTMENT_ID 
								FROM 
									DEPARTMENT 
								WHERE 
									DEPARTMENT_HEAD LIKE '%#attributes.keyword#%'
							  )
		)
	</cfif>
  	<cfif isdefined("attributes.is_authority_branch") and len(attributes.is_authority_branch)>
    <!---Depo seçim custom tagindeki şekilde yetki kontrolü düzenlendi.Kodu geri almak isteyen olursa haber verilmesi rica olunur. PY  --->
            AND
            (
                CAST(DEPARTMENT_ID AS NVARCHAR) + '-' + CAST(LOCATION_ID AS NVARCHAR) IN (SELECT LOCATION_CODE FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
                OR
                DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# AND LOCATION_ID IS NULL)
            )
  	</cfif>
	ORDER BY 
		COMMENT
</cfquery>
<cfset temp_recordcount=0>
<script type="text/javascript">
function add_location(in_coming_id,in_coming_name,in_coming_store_name,in_coming_store_id,branch_id)
{
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#form_name#.#field_name#</cfoutput>.value = in_coming_store_name +'-' +in_coming_name;
	</cfif>
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#form_name#.#field_id#</cfoutput>.value = in_coming_id;
	</cfif>
	<cfif isdefined("attributes.branch_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#form_name#.#branch_id#</cfoutput>.value = branch_id;	
	</cfif>
	<cfif isdefined("attributes.function_name")>
		<cfset _form_name_ = ''>
		<cfif isdefined('attributes.FUNCTION_FORM_NAME')>
			<cfset _form_name_ = '#attributes.FUNCTION_FORM_NAME#'>
		</cfif>
		<cfoutput><cfif not isdefined("attributes.draggable")>opener.document</cfif>.#attributes.function_name#('#_form_name_#');</cfoutput>
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
function add_store(in_coming_id, in_coming_name, basket,branch_id)
{
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#form_name#.#field_name#</cfoutput>.value = in_coming_name ;
	</cfif>	
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#form_name#.#field_id#</cfoutput>.value = in_coming_id;
	</cfif>	
	<cfif isdefined("attributes.branch_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#form_name#.#branch_id#</cfoutput>.value = branch_id;	
	</cfif>	
	<cfif isdefined("attributes.function_name")>
		<cfset _form_name_ = ''>
		<cfif isdefined('attributes.FUNCTION_FORM_NAME')>
			<cfset _form_name_ = '#attributes.FUNCTION_FORM_NAME#'>
		</cfif>
		<cfoutput><cfif not isdefined("attributes.draggable")>opener.document</cfif>.#attributes.function_name#('#_form_name_#');</cfoutput>
	</cfif>
	if(basket == 1)
	{
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.clear_fields();
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.form_basket.submit();
	}
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
<cfif isdefined("attributes.field_location_id")>
function add_dept_loc(department_id, location_id, department_name, location_name,branch_id,partner_id,partner_name,partner_surname,company_id,company_name,company_address)
{
	<cfif isdefined("attributes.branch_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#form_name#.#branch_id#</cfoutput>.value = branch_id;	
	</cfif>
	if(location_id != '')
	{
		<cfif isdefined("attributes.field_location")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#form_name#.#field_location#</cfoutput>.value = location_name;	
		</cfif>
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#form_name#.#field_name#</cfoutput>.value = department_name + '-' + location_name;
		</cfif>
		<cfif isdefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#form_name#.#field_id#</cfoutput>.value = department_id;
		</cfif>	
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#form_name#.#field_location_id#</cfoutput>.value = location_id;
	}
	else
	{
		add_store(department_id, department_name,<cfif isdefined('url.basket')>1<cfelse>0</cfif>);
	}
	<cfif isdefined("attributes.is_ingroup")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.form_basket.partner_id.value = partner_id;
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.form_basket.partner_name.value = partner_name+' '+partner_surname;
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.form_basket.company_id.value = company_id;
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.form_basket.comp_name.value = company_name;
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.form_basket.adres.value = company_address;
	</cfif>
	<cfif isdefined("attributes.function_name")>
		<cfset _form_name_ = ''>
		<cfif isdefined('attributes.FUNCTION_FORM_NAME')>
			<cfset _form_name_ = '#attributes.FUNCTION_FORM_NAME#'>
		</cfif>
		<cfoutput><cfif not isdefined("attributes.draggable")>opener.document</cfif>.#attributes.function_name#('#_form_name_#');</cfoutput>
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</cfif>
<cfif isdefined("attributes.row_id")>
function add_dept_loc(department_id,location_id,department_name,location_name)
{
	<cfif isdefined("attributes.satir") and len(attributes.satir)>
		var satir = <cfoutput>#attributes.satir#</cfoutput>;
	<cfelse>
		var satir = -1;
	</cfif>
	if(<cfif not isdefined("attributes.draggable")>window.opener.</cfif>basket && satir > -1) 
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif>updateBasketItemFromPopup(satir, { DELIVER_DEPT: department_id + '-' + location_id, BASKET_ROW_DEPARTMENT: department_name + '-' + location_name }); // Basket Çalışmaları için eklendi. Kaldırmayınız. 20140826
	else
	{
		if(location_id=='')location_id=0;
		if(<cfif not isdefined("attributes.draggable")>opener.</cfif>form_basket.product_id.length != undefined) /* sepet de birden fazla satır var*/
		{
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#form_name#.#field_name#[#attributes.row_id-1#]</cfoutput>.value = department_name + '-' + location_name;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#form_name#.#field_id#[#attributes.row_id-1#]</cfoutput>.value = department_id + '-' + location_id;
		}
		else /* sepet tek satır */
		{
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#form_name#.#field_name#</cfoutput>.value = department_name + '-' + location_name;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#form_name#.#field_id#</cfoutput>.value = department_id + '-' + location_id;
		}
	}
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</cfif>
</script>
<cf_box title="#getLang('','Depolar ve Lokasyonlar',32768)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="list_search" method="post" action="#request.self#?fuseaction=objects.popup_list_stores_locations#url_string#">
		<cf_box_search more="0">
			<cfinput type="hidden" name="satir" value="#attributes.satir#"><!--- Basket Çalışmaları için eklendi. Kaldırmayınız. EY20140826--->
			<cfinput type="hidden" name="is_form_submitted" value="1">
			<div class="form-group" id="item-company_id">
				<cfinput type="text"  placeholder="#getLang('','Filtre',57460)#" maxlength="50" name="keyword" value="#attributes.keyword#">
			</div>
			<div class="form-group">  
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_search' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='58763.Depo'></th>
				<th><cf_get_lang dictionary_id='58585.Kod'></th>
				<th><cf_get_lang dictionary_id='57453.Şube'></th>
				<th width="60"><cf_get_lang dictionary_id='32769.W H D'></th>
			</tr>
		</thead>
		<tbody>
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
					<cfset temp_recordcount=1>
					<tr>
						<td class="txtbold">#department_head#</td>
						<td>#department_id#</td>
						<td>#branch_name#</td>
						<td></td>
					</tr>
					<cfloop from="1" to="#get_location.recordcount#" index="s">							
						<tr>
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
			<cfif temp_recordcount eq 0>
				<tr>
					<td colspan="4"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</cf_box>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
