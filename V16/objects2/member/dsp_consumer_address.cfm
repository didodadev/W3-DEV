<cfquery name="GET_CONSUMER_ADRESS" datasource="#DSN#">
	SELECT
		CONTACT_ID,
		CONTACT_NAME,
		CONTACT_TELCODE,
		CONTACT_TEL1,
		CONTACT_EMAIL,
		CONTACT_COUNTY_ID,
		CONTACT_CITY_ID,
		CONTACT_COUNTRY_ID,
		STATUS		
	FROM
		CONSUMER_BRANCH
	WHERE
		<cfif isdefined("attributes.cid")>
            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
        <cfelse>
            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
        </cfif>
	ORDER BY
		CONTACT_NAME
</cfquery>
<table cellspacing="1" cellpadding="2" border="0" class="color-border" align="center" style="width:100%">
	<tr class="color-row">
		<td>
			<table style="width:100%;">
                <input type="hidden" name="address_count" id="address_count" value="<cfoutput>#get_consumer_adress.recordcount#</cfoutput>">
                <input type="hidden" name="add_adres" id="add_adres" value="0">
                <tr class="header">
                    <td class="txtbold" style="width:16%"><cf_get_lang no='1346.Adres Adı'></td>
                    <td class="txtbold" style="width:16%"><cf_get_lang_main no='731.İletişim'></td>
                    <td class="txtbold" style="width:16%"><cf_get_lang_main no='1226.İlçe'></td>
                    <td class="txtbold" style="width:16%"><cf_get_lang_main no='559.Şehir'></td>
                    <td class="txtbold" style="width:16%"><cf_get_lang_main no='807.Ülke'></td>
                    <td class="txtbold" style="width:16%"><cf_get_lang_main no='344.Durum'></td>
                    <td class="txtbold"><cfif not isdefined("attributes.cid") and attributes.xml_is_upd eq 1><a href="javascript://" onclick="open_ajax();"><img src="../../images/myportal/add_buton.gif" alt="<cf_get_lang_main no='170.Ekle'>" border="0"></a></cfif></td>
			</tr>	
			<cfif get_consumer_adress.recordcount>
                <cfset county_list=''>
                <cfset city_list=''>
                <cfset country_list=''>	
                <cfoutput query="get_consumer_adress">
                    <cfif len(contact_county_id) and not listfind(county_list,contact_county_id)>
                        <cfset county_list = Listappend(county_list,contact_county_id)>
                    </cfif>
                    <cfif len(contact_city_id) and not listfind(city_list,contact_city_id)>
                        <cfset city_list = Listappend(city_list,contact_city_id)>
                    </cfif>
                    <cfif len(contact_country_id) and not listfind(country_list,contact_country_id)>
                        <cfset country_list = Listappend(country_list,contact_country_id)>
                    </cfif>	
                </cfoutput>
                <cfif len(county_list)>
                    <cfset county_list=listsort(county_list,"numeric","ASC",",")>			
                    <cfquery name="GET_COUNTY_NAME" datasource="#DSN#">
                        SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_list#) ORDER BY COUNTY_ID
                    </cfquery>
                    <cfset main_county_list = listsort(listdeleteduplicates(valuelist(get_county_name.county_id,',')),'numeric','ASC',',')>
                </cfif>
                <cfif len(city_list)>
                    <cfset city_list=listsort(city_list,"numeric","ASC",",")>			
                    <cfquery name="GET_CITY_NAME" datasource="#DSN#">
                        SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_list#) ORDER BY CITY_ID
                    </cfquery>
                    <cfset main_city_list = listsort(listdeleteduplicates(valuelist(get_city_name.city_id,',')),'numeric','ASC',',')>
                </cfif>
                <cfif len(country_list)>
                    <cfset country_list=listsort(country_list,"numeric","ASC",",")>			
                    <cfquery name="GET_COUNTRY_NAME" datasource="#DSN#">
                        SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_list#) ORDER BY COUNTRY_ID
                    </cfquery>
                    <cfset main_country_list = listsort(listdeleteduplicates(valuelist(get_country_name.country_id,',')),'numeric','ASC',',')>
                </cfif>
				<cfoutput query="get_consumer_adress">
                    <input type="hidden" name="address_id#currentrow#" id="address_id#currentrow#" value="#contact_id#">
                    <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
					<tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" id="frm_row#currentrow#" style="height:20px;">
                        <td><a href="javascript://" onclick="open_ajax_upd(#contact_id#,#currentrow#);" class="tableyazi" title="<cf_get_lang_main no='52.Güncelle'>">#contact_name#</a></td>
                        <td>
                            <img src="/images/tel.gif" alt="<cf_get_lang_main no='87.Tel'>:#contact_telcode#-#contact_tel1#"> &nbsp;
                            <cfif len(contact_email)>
                                <a href="mailto:#contact_email#"><img src="/images/mail.gif" title="<cf_get_lang_main no='16.E-posta'>:#contact_email#" border="0"></a>
                            </cfif>
                        </td>
                        <td><cfif len(contact_county_id)>#get_county_name.county_name[listfind(main_county_list,get_consumer_adress.contact_county_id,',')]#</cfif></td>
                        <td><cfif len(contact_city_id)>#get_city_name.city_name[listfind(main_city_list,get_consumer_adress.contact_city_id,',')]#</cfif></td>
                        <td><cfif len(contact_country_id)>#get_country_name.country_name[listfind(main_country_list,get_consumer_adress.contact_country_id,',')]#</cfif></td>
                        <td><cfif status eq 1><cf_get_lang_main no='81.Aktif'><cfelse><cf_get_lang_main no='82.Pasif'></cfif></td>
                        <td class="txtbold"><cfif not isdefined("attributes.cid")><a href="javascript://" onclick="open_ajax_upd(#contact_id#,#currentrow#);"><img src="../../images/myportal/upd_buton.gif" title="<cf_get_lang_main no='52.Güncelle'>" border="0"></a></cfif></td>
					</tr>
					<tr class="color-row" id="upd_address_t#currentrow#" style="display:none;">
						<td colspan="7">
                            <div id="upd_address#currentrow#" style="display:none;"></div>
                        </td>
                    </tr>
					</cfoutput>
				<cfelse>
					<tr class="color-row" style="height:20px;">
						<td colspan="7"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</table>
		</td>
	</tr>
	<tr class="color-row" id="add_address_t" style="display:none;">
		<td>
			<div id="add_address" style="display:none;"></div>
		</td>
	</tr>
</table>
<script type="text/javascript">

	for(i=1;i<<cfoutput>#get_consumer_adress.recordcount#</cfoutput>;i++)
	{
	
		goster(eval('upd_address'+i));
		gizle(eval('upd_address'+i));
	}
	
	function open_ajax()
	{   
		gizle_goster(add_address);
		gizle_goster(add_address_t); 
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.popup_add_consumer_address&is_detail_adres=#attributes.is_detail_adres#&is_residence_select=#attributes.is_residence_select#</cfoutput>','add_address',1);
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.popup_add_consumer_address&is_detail_adres=#attributes.is_detail_adres#&is_residence_select=#attributes.is_residence_select#</cfoutput>','add_address',1);			
			if(document.getElementById('add_adres') != undefined)
			if(document.getElementById('add_adres').value == 1)
				document.getElementById('add_adres').value = 0;
			else
				document.getElementById('add_adres').value = 1; 
	}
	
	function open_ajax_upd(address_id,row_id)
	{   
		gizle_goster(eval('upd_address'+row_id));
		gizle_goster(eval('upd_address_t'+row_id));
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.popup_upd_consumer_address&is_detail_adres=#attributes.is_detail_adres#&is_residence_select=#attributes.is_residence_select#</cfoutput>&row_id='+row_id+'&address_id='+address_id,'upd_address'+row_id);
	}
	
	function sil(sy)
	{
		if(confirm("Kayıtlı Adresi Siliyorsunuz emin misiniz?"))
		{
			var my_element=eval("document.getElementById('row_kontrol"+sy+"')");
			my_element.value=0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
			var my_element_1=eval("upd_address"+sy);
			my_element_1.style.display="none";
		}
	}
</script>
