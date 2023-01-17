<cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
	SELECT 
    	SUBSCRIPTION_STAGE, 
        SUBSCRIPTION_TYPE_ID, 
        SHIP_COUNTY_ID,
        INVOICE_COUNTY_ID,
        CONTACT_COUNTY_ID,
        SHIP_CITY_ID,
        INVOICE_CITY_ID,
        CONTACT_CITY_ID,
        SHIP_COUNTRY_ID,
        INVOICE_COUNTRY_ID,
        CONTACT_COUNTRY_ID,
        SUBSCRIPTION_HEAD,
        PARTNER_ID,
        REF_PARTNER_ID,
        REF_CONSUMER_ID,
        REF_EMPLOYEE_ID,
        SALES_EMP_ID,
        SALES_PARTNER_ID,
        SALES_CONSUMER_ID,
        PAYMENT_TYPE_ID,
        CONTRACT_NO,
        FINISH_DATE,
        START_DATE,
        MONTAGE_DATE,
        MONTAGE_EMP_ID,
        SHIP_COORDINATE_1,
        SHIP_COORDINATE_2,
        SHIP_ADDRESS,
        SHIP_POSTCODE,
        INVOICE_ADDRESS,
        INVOICE_POSTCODE,
        CONTACT_ADDRESS,
        CONTACT_POSTCODE   
    FROM 
    	SUBSCRIPTION_CONTRACT 
    WHERE 
    	SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
</cfquery>
<cfquery name="GET_SERVICE_STAGE" datasource="#DSN#">
	SELECT
  		STAGE,
		PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS
	WHERE
		PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.subscription_stage#">
</cfquery>
<cfquery name="GET_SUBSCRIPTION_TYPE" datasource="#DSN3#">
	SELECT SUBSCRIPTION_TYPE_ID,SUBSCRIPTION_TYPE FROM SETUP_SUBSCRIPTION_TYPE WHERE SUBSCRIPTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.subscription_type_id#">
</cfquery>

<cfset county_list = ''>
<cfset city_list = ''>
<cfset country_list = ''>

<cfset county_list = Listappend(county_list,'#get_subscription.ship_county_id#,#get_subscription.invoice_county_id#,#get_subscription.contact_county_id#',',')>
<cfset city_list = ListAppend(city_list,'#get_subscription.ship_city_id#,#get_subscription.invoice_city_id#,#get_subscription.contact_city_id#',',')>
<cfset country_list = ListAppend(country_list,'#get_subscription.ship_country_id#,#get_subscription.invoice_country_id#,#get_subscription.contact_country_id#',',')>

<cfset county_list = ListSort(ListDeleteDuplicates(county_list),'Numeric','ASC',',')>
<cfset city_list = ListSort(ListDeleteDuplicates(city_list),'Numeric','ASC',',')>
<cfset country_list = ListSort(ListDeleteDuplicates(country_list),'Numeric','ASC',',')>
<cfif len(county_list)>
	<cfquery name="GET_COUNTY" datasource="#DSN#">
		SELECT COUNTY_NAME,COUNTY_ID FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_list#) ORDER BY COUNTY_ID
	</cfquery>
	<cfset main_county_list = listsort(listdeleteduplicates(valuelist(get_county.county_id,',')),'numeric','ASC',',')>
<cfelse>
	<cfset main_county_list = ''>
</cfif>

<cfif len(city_list)>
	<cfquery name="GET_CITY" datasource="#DSN#">
		SELECT CITY_NAME,CITY_ID FROM SETUP_CITY WHERE CITY_ID IN (#city_list#) ORDER BY CITY_ID
	</cfquery>
	<cfset main_city_list = listsort(listdeleteduplicates(valuelist(get_city.city_id,',')),'numeric','ASC',',')>
</cfif>

<cfif len(country_list)>
	<cfquery name="GET_COUNTRY" datasource="#DSN#">
		SELECT COUNTRY_NAME,COUNTRY_ID FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_list#) ORDER BY COUNTRY_ID
	</cfquery>
	<cfset main_country_list = listsort(listdeleteduplicates(valuelist(get_country.country_id,',')),'numeric','ASC',',')>
</cfif>

<cfif get_subscription.recordcount>
	<table style="width:100%">
		<cfif isdefined('attributes.is_subscription_objects') and attributes.is_subscription_objects eq 1>
            <tr>
                <td colspan="4" align="right" style="text-align:right;">
                    <form name="list_call_center" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.list_service_call_center">
                        <input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#get_subscription.subscription_id#</cfoutput>">
                        <input type="hidden" name="subscription_no" id="subscription_no" value="<cfoutput>#get_subscription.subscription_no#</cfoutput>">
                        <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                    </form>
                    <form name="list_service" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.list_service">
                        <input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#get_subscription.subscription_id#</cfoutput>">
                        <input type="hidden" name="subscription_no" id="subscription_no" value="<cfoutput>#get_subscription.subscription_no#</cfoutput>">
                        <input type="hidden" name="is_submit" id="is_submit" value="1">
                    </form>
                    <a href="<cfoutput>#request.self#?fuseaction=objects2.add_service&subscription_id=#attributes.subscription_id#</cfoutput>"><img src="/images/care_plus.gif" title="<cf_get_lang no ='1463.Servis Başvurusu Ekle'>" border="0" align="absmiddle"></a>
                    <a href="javascript:list_service.submit();"><img src="/images/care.gif" title="<cf_get_lang no='465.Servis Başvuruları'>" border="0" align="absmiddle"></a>
                    <a href="<cfoutput>#request.self#?fuseaction=objects2.add_service_callcenter_system&subscription_id=#attributes.subscription_id#&subs_no=#get_subscription.subscription_no#</cfoutput>"><img src="/images/tel.gif" title="<cf_get_lang no ='1464.Şikayet/Talep'>" border="0" align="absmiddle"></a>
                    <a href="javascript:list_call_center.submit();"><img src="/images/content_plus.gif" title="Şikayet/Talepler" border="0" align="absmiddle"></a>
                </td>
            </tr>
        </cfif>
        <tr class="color-row" style="height:20px;">
            <td class="txtbold" style="width:100px;"><cf_get_lang_main no='821.Tanım'></td>
            <td colspan="3"><cfoutput>#get_subscription.subscription_head#</cfoutput></td>
        </tr>
	<tr class="color-row" style="height:20px;">
		<td class="txtbold"><cf_get_lang_main no='45.Müşteri'></td>
		<td style="width:275px;">
			<cfif len(get_subscription.partner_id)>
				<cfoutput>#get_par_info(get_subscription.partner_id,0,1,0)#</cfoutput>
			<cfelse>
				<cfoutput>#get_cons_info(get_subscription.consumer_id,2,0)#</cfoutput>
			</cfif>
		</td>
		<td class="txtbold" style="width:100px;"><cf_get_lang_main no='166.Yetkili'></td>
		<td><cfif len(get_subscription.partner_id)>
				<cfoutput>#get_par_info(get_subscription.partner_id,0,-1,0)#</cfoutput>
			<cfelse>
				<cfoutput>#get_cons_info(get_subscription.consumer_id,0,0)#</cfoutput>
			</cfif>
		</td>
	</tr>
	<tr class="color-row" style="height:20px;">
		<td class="txtbold"><cf_get_lang no='458.Referans Müşteri'></td>
		<td><cfoutput>#get_par_info(get_subscription.ref_partner_id,0,1,0)#</cfoutput></td>
		<td class="txtbold"><cf_get_lang_main no='166.Yetkili'></td>
		<td><cfif len(get_subscription.ref_partner_id)>
				<cfoutput>#get_par_info(get_subscription.ref_partner_id,0,-1,0)#</cfoutput>
			<cfelseif len(get_subscription.ref_consumer_id)>
				<cfoutput>#get_cons_info(get_subscription.ref_consumer_id,0,0)#</cfoutput>
			<cfelseif len(get_subscription.ref_employee_id)>
				<cfoutput>#get_emp_info(get_subscription.ref_employee_id,0,0)#</cfoutput>
			</cfif>
		</td>
	</tr>
	<tr class="color-row" style="height:20px;">
		<td class="txtbold"><cf_get_lang no='459.Satış Temsilcisi'></td>
		<td><cfif len(get_subscription.sales_emp_id)>
				<cfoutput>#get_emp_info(get_subscription.sales_emp_id,0,0)#</cfoutput>
			</cfif>
		</td>
		<td class="txtbold"><cf_get_lang no='429.Satış Ortağı'></td>
		<td><cfif len(get_subscription.sales_partner_id)>
				<cfoutput>#get_par_info(get_subscription.sales_partner_id,0,-1,0)#</cfoutput>
			<cfelseif len(get_subscription.sales_consumer_id)>
				<cfoutput>#get_cons_info(get_subscription.sales_consumer_id,1,0)#</cfoutput>
			</cfif>
		</td>
	</tr>
	<tr class="color-row" style="height:20px;">
		<td class="txtbold"><cf_get_lang_main no='70.Aşama'></td>
		<td><cfoutput>#get_service_stage.stage#</cfoutput></td>
		<td class="txtbold"><cf_get_lang_main no='74.Kategori'></td>
		<td><cfoutput>#get_subscription_type.subscription_type#</cfoutput></td>
	</tr>
	<tr class="color-row" style="height:20px;">
		<td class="txtbold"><cf_get_lang_main no='1104.Ödeme Yöntemi'></td>
		<td><cfif len(get_subscription.payment_type_id)>
			<cfquery name="GET_PAYMENT_TYPE" datasource="#DSN#">
				SELECT PAYMETHOD_ID,PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.payment_type_id#">
			</cfquery>
			<cfoutput>#get_payment_type.paymethod#</cfoutput>
			</cfif>
		</td>
		<td class="txtbold"><cf_get_lang_main no='2247.Sözleşme No'></td>
		<td><cfoutput>#get_subscription.contract_no#</cfoutput></td>
	</tr>
	<tr class="color-row" style="height:20px;">
		<td class="txtbold"><cf_get_lang_main no='336.İptal Tarihi'></td>
		<td><cfoutput>#dateformat(get_subscription.finish_date,'dd/mm/yyyy')#</cfoutput></td>
		<td class="txtbold"><cf_get_lang_main no='335.Sözleşme Tarihi'></td>
		<td><cfoutput>#dateformat(get_subscription.start_date,'dd/mm/yyyy')#</cfoutput></td>
	</tr>
	<tr class="color-row" style="height:20px;">
		<td class="txtbold"><cf_get_lang dictionary_id='60559.Kurulum Tarihi'></td>
		<td><cfoutput>#dateformat(get_subscription.montage_date,'dd/mm/yyyy')#</cfoutput></td>
		<td class="txtbold"><cf_get_lang dictionary_id='60560.Kurulum Çalışanı'></td>
		<td><cfif len(get_subscription.montage_emp_id)>
				<cfoutput>#get_emp_info(get_subscription.montage_emp_id,0,0)#</cfoutput>
			</cfif> 
		</td>
	</tr>
    <tr class="color-row" style="height:20px;">
		<td class="txtbold"><cf_get_lang_main no='1137.Koordinatlar'></td>
		<td colspan="3">
			<cfoutput>
				<cf_get_lang_main no='1141.E'> :
				#get_subscription.ship_coordinate_1#
				<cf_get_lang_main no='1179.B'> :
				#get_subscription.ship_coordinate_2#
				<cfif len(get_subscription.ship_coordinate_1) and len(get_subscription.ship_coordinate_2)>
					<a href="javascript://" >
						<img src="/images/gmaps.gif" border="0" title="Haritada Göster" onclick="windowopen('#request.self#?fuseaction=objects.popup_view_map&coordinate_1=#get_subscription.ship_coordinate_1#&coordinate_2=#get_subscription.ship_coordinate_2#&title=#get_subscription.ship_address#','list','popup_view_map')" align="absmiddle">
					</a>
				</cfif>
			</cfoutput>
		</td>
	</tr>
</table>
<br/>
<!--- adresler --->
<table style="width:100%">
    <cfif isDefined('attributes.is_ship_address') and attributes.is_ship_address eq 1>
        <tr class="color-row" style="height:20px;">
            <td class="txtbold">&nbsp;<cf_get_lang dictionary_id='60563.Kurulum Adresi'></td>
        </tr>
        <tr class="color-row" style="height:20px;">
            <td>&nbsp;&nbsp;
                <cfoutput>
                    #get_subscription.ship_address# &nbsp;&nbsp;&nbsp;
                    <cfif len(get_subscription.ship_county_id)>#get_county.county_name[listfind(main_county_list,get_subscription.ship_county_id,',')]#</cfif>
                    <cfif len(get_subscription.ship_city_id)>- #get_city.city_name[listfind(main_city_list,get_subscription.ship_city_id,',')]#</cfif> - 
                    #get_subscription.ship_postcode# 
                    <cfif len(get_subscription.ship_country_id)>- #get_country.country_name[listfind(main_country_list,get_subscription.ship_country_id,',')]#</cfif>
                </cfoutput>
            </td>
        </tr>
    </cfif>
    <cfif isDefined('attributes.is_invoice_address') and attributes.is_invoice_address eq 1>
        <tr class="color-row" style="height:20px;">
            <td class="txtbold">&nbsp;<cf_get_lang no='220.Fatura Adresi'></td>
        </tr>
        <tr class="color-row" style="height:20px;">
            <td>&nbsp;&nbsp;
                <cfoutput>
                    #get_subscription.invoice_address# &nbsp;&nbsp;&nbsp;
                    <cfif len(get_subscription.invoice_county_id)>#get_county.county_name[listfind(main_county_list,get_subscription.invoice_county_id,',')]#</cfif>
                    <cfif len(get_subscription.invoice_city_id)>- #get_city.city_name[listfind(main_city_list,get_subscription.invoice_city_id,',')]# </cfif>
                    - #get_subscription.invoice_postcode# 
                    <cfif len(get_subscription.invoice_country_id)>- #get_country.country_name[listfind(main_country_list,get_subscription.invoice_country_id,',')]#</cfif>
                </cfoutput>
            </td>
        </tr>
    </cfif>
    <cfif isDefined('attributes.is_contact_address') and attributes.is_contact_address eq 1>
        <tr class="color-row" style="height:20px;">
            <td class="txtbold">&nbsp;<cf_get_lang no='463.İrtibat Adresi'></td>
        </tr>
        <tr class="color-row" style="height:20px;">
            <td>&nbsp;&nbsp;
                <cfoutput>
                    #get_subscription.contact_address# &nbsp;&nbsp;&nbsp;
                    <cfif len(get_subscription.contact_county_id)>#get_county.county_name[listfind(main_county_list,get_subscription.contact_county_id,',')]#</cfif>
                    <cfif len(get_subscription.contact_city_id)>- #get_city.city_name[listfind(main_city_list,get_subscription.contact_city_id,',')]# </cfif>
                    - #get_subscription.contact_postcode# 
                    <cfif len(get_subscription.contact_country_id)>- #get_country.country_name[listfind(main_country_list,get_subscription.contact_country_id,',')]#</cfif>
                </cfoutput> 
            </td>
        </tr>
    </cfif>
</table>
<!--- adresler --->
<br/>
<!--- siparişler --->
<cfset order_currency_list="Açık,Tedarik,Kapatıldı,-,Üretim,Sevk,Eksik Teslimat,Fazla Teslimat,İptal,Kapatıldı(Manuel)"><!--- siparis asamaları 4. eleman bos --->
<cfquery name="GET_ORDER_ROW" datasource="#DSN3#">
	SELECT
		ORDERS.ORDER_ID,
		ORDERS.ORDER_NUMBER,
		ORDER_ROW.PRODUCT_NAME,
		ORDER_ROW.QUANTITY,
		ORDER_ROW.ORDER_ROW_CURRENCY,
		ORDER_ROW.UNIT,
		ORDERS.ORDER_DATE
	FROM
		SUBSCRIPTION_CONTRACT_ORDER,
		ORDERS,
		ORDER_ROW
	WHERE
		SUBSCRIPTION_CONTRACT_ORDER.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#"> AND
		SUBSCRIPTION_CONTRACT_ORDER.ORDER_ID = ORDERS.ORDER_ID AND
		ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID
	ORDER BY
		ORDERS.ORDER_ID ASC,
		ORDER_ROW.ORDER_ROW_ID ASC
</cfquery>

<cfif isDefined('attributes.is_subscription_sales') and attributes.is_subscription_sales eq 1>
	<table style="width:100%">
        <tr class="color-row" style="height:20px;">
            <td class="txtbold" colspan="10"><cf_get_lang no='464.Siparişler'></td>
        </tr>
        <tr class="color-header">
            <td class="form-title" style="width:100px;"><cf_get_lang_main no='799.Siparis No'></td>
            <td class="form-title" align="center" style="width:65px;"><cf_get_lang_main no='330.Tarih'></td>
            <td class="form-title"><cf_get_lang_main no='245.Ürün'></td>
            <td class="form-title"><cf_get_lang_main no='70.Aşama'></td>
            <td align="right" class="form-title" style="text-align:right; width:70px;"><cf_get_lang_main no='223.Miktar'></td>
            <td class="form-title" align="center" style="width:50px;"><cf_get_lang_main no='224.Birim'></td>
		</tr>
        <cfif get_order_row.recordcount>
			<cfoutput query="get_order_row">
           		<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
                    <td>#order_number#</td>
                    <td align="center">#dateformat(order_date,'dd/mm/yyyy')#</td>
                    <td>#product_name#</td>
                    <td><cfif len(order_row_currency)>#ListGetAt(order_currency_list,(order_row_currency*-1),",")#</cfif></td>
                    <td align="right" style="text-align:right;">#tlformat(quantity)#</td>
                    <td align="center">#unit#</td>
              	</tr>
            </cfoutput>	
        </cfif>
	</table>
</cfif>
<!--- siparişler --->
<br/>
<!---
<!--- servis basvuruları --->
<cfquery name="get_services" datasource="#dsn3#">
	SELECT
		S.SERVICE_ID,
		S.SERVICE_NO,
		S.ISREAD,
		S.APPLY_DATE,
 		S.SERVICE_HEAD,
		S.SERVICE_PARTNER_ID,
		S.SERVICE_CONSUMER_ID,
		S.SERVICE_EMPLOYEE_ID,
		S.SERVICE_SUBSTATUS_ID,
		S.PRODUCT_NAME,
		S.SUBSCRIPTION_ID,
		PTR.STAGE
	FROM
		SERVICE S,
		#dsn_alias#.PROCESS_TYPE_ROWS AS PTR
	WHERE
		S.SERVICE_STATUS_ID = PTR.PROCESS_ROW_ID AND
		S.SUBSCRIPTION_ID = #attributes.subscription_id#
	ORDER BY
		S.RECORD_DATE
</cfquery>
<table width="100%">
	<tr class="color-row" height="20">
		<td class="txtbold" colspan="10"><cf_get_lang no='465.Servis Başvuruları'></td>
	</tr>
	<tr class="color-header">
		<td class="form-title" width="70"><cf_get_lang_main no='75.No'></td>
		<td class="form-title" width="65" align="center"><cf_get_lang_main no='330.Tarih'></td>
		<td class="form-title"><cf_get_lang_main no='68.Konu'></td>
		<td class="form-title" width="70"><cf_get_lang_main no='70.Aşama'></td>
		<td class="form-title"><cf_get_lang no='40.Başvuru Sahibi'></td>
	  </tr>
	<cfif get_services.recordcount>
	<cfoutput query="get_services">
	  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
	  	<td>#service_no#</td>
	  	<td width="100">
			<cfif isdefined("session.pp.time_zone")>
				#dateformat(date_add('h',session.pp.time_zone,get_services.APPLY_DATE),'dd/mm/yyyy')# 
				#timeformat(date_add('h',session.pp.time_zone,get_services.APPLY_DATE),'HH:MM')#
			<cfelse>
				#dateformat(date_add('h',session.ww.time_zone,get_services.APPLY_DATE),'dd/mm/yyyy')# 
				#timeformat(date_add('h',session.ww.time_zone,get_services.APPLY_DATE),'HH:MM')#
			</cfif>
		</td>
	  	<td><a href="#request.self#?fuseaction=objects2.upd_service&id=#get_services.service_id#&type=1" class="tableyazi">#service_head#</a></td>
	  	<td>#STAGE#</td>
		<td><cfif get_services.service_partner_id neq 0>#get_par_info(service_partner_id,0,0,0)#</cfif>
			<cfif get_services.service_consumer_id neq 0>#get_cons_info(service_consumer_id,0,0)#</cfif>
			<cfif get_services.service_employee_id neq 0>#get_emp_info(service_employee_id,0,0)#</cfif>
		</td>
	  </tr>
	</cfoutput>	
	</cfif>
</table>
<!--- servis basvuruları --->
--->
<cfelse>
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr class="color-row">
			<td colspan="9" height="20"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		</tr>
	</table>	
</cfif>
