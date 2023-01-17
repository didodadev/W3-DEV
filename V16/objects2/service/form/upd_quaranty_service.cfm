<cfoutput>
    <!---<table cellspacing="1" cellpadding="2" style="width:100%;">
      	<tr style="height:22px;">
        	<td class="headbold"><cf_get_lang no='601.Garanti Bilgisi'></td>
      	</tr>
      	<tr class="color-row" style="height:22px;">
            <td>
            	<table>
              		<tr>
                		<td class="txtbold">#get_pro_guaranty.product_name#</td>
              		</tr>
              		<tr>
                		<td><b><cf_get_lang_main no='330.Tarih'> :</b> #dateformat(get_pro_guaranty.sale_start_date,'dd/mm/yyyy')# - #dateformat(get_pro_guaranty.sale_finish_date,'dd/mm/yyyy')#</td>
              		</tr> 
              		<tr>
                		<td><b><cf_get_lang no='116.Kalan Süre'> :</b>
							<cfset kalan_sure = datediff("d",now(),get_pro_guaranty.sale_finish_date)>
                      		<cfif kalan_sure gt 0>#kalan_sure# gün<cfelse>#garanti_bilgisi#</cfif>
                		</td>
              		</tr> 
            	</table>
            </td>
      	</tr>
    </table>--->
	<cf_seperator title="Kabul Bilgisi" id="kabul_bilgisi">
    <table id="kabul_bilgisi">
        <tr>
            <td>Garanti Tarih</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no='29.Başvuru Tarihi'></cfsavecontent>
                <cfif isdefined('attributes.service_id') and len(attributes.service_id)>
                    <cfinput type="text" name="guaranty_start_date" id="guaranty_start_date" value="#dateformat(get_service_detail.guaranty_start_date,'dd/mm/yyyy')#" validate="eurodate" message="#message#" style="width:65px;">
                <cfelse>
                    <cfinput type="text" name="guaranty_start_date" id="guaranty_start_date" value="#dateformat(now(),'dd/mm/yyyy')#" validate="eurodate" message="#message#" style="width:65px;">
                </cfif>
                <cf_wrk_date_image date_field="guaranty_start_date">
            </td>
        </tr>
        <tr>
            <td>Getiren</td>
            <td><input type="text" name="bring_name" id="bring_name" value="<cfif isdefined("attributes.service_id")>#get_service_detail.bring_name#</cfif>" maxlength="150" style="width:140px;"></td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='1703.Sevk Yöntemi'></td>
            <td>
                <cfif isdefined("get_service_detail.bring_ship_method_id") and len(get_service_detail.bring_ship_method_id)>
                    <cfset attributes.ship_method_id=get_service_detail.bring_ship_method_id>
                    <cfinclude template="../../../service/query/get_ship_method.cfm">
                    <input type="hidden" name="bring_ship_method_id" id="bring_ship_method_id" value="<cfoutput>#get_service_detail.bring_ship_method_id#</cfoutput>">
                    <input type="text" name="bring_ship_method_name" id="bring_ship_method_name" value="<cfoutput>#ship_method.ship_method#</cfoutput>" style="width:140px;" onFocus="AutoComplete_Create('bring_ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','bring_ship_method_id','','3','125');" autocomplete="off">
                <cfelse>
                    <input type="hidden" name="bring_ship_method_id" id="bring_ship_method_id" value="">
                    <input type="text" name="bring_ship_method_name" id="bring_ship_method_name" value="" style="width:140px;" onFocus="AutoComplete_Create('bring_ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','bring_ship_method_id','','3','125');" autocomplete="off">
                </cfif>
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_ship_methods&field_name=upd_service_stage.bring_ship_method_name&field_id=upd_service_stage.bring_ship_method_id','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='1195.Firma'></td>
            <td>
                <input type="text" name="applicator_comp_name" id="applicator_comp_name" value="<cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.applicator_comp_name#</cfoutput><cfelseif isdefined("attributes.applicator_comp_name")><cfoutput>#attributes.applicator_comp_name#</cfoutput></cfif>" maxlength="150" style="width:140px;">
                <cfset str_linke_ait="field_name=add_service.bring_name&field_comp_name=add_service.applicator_comp_name&field_tel=add_service.bring_tel_no&field_mobile_tel=add_service.bring_mobile_no&field_address=add_service.service_address&field_city_id=add_service.service_city_id&field_county_id=add_service.service_county_id&field_county=add_service.service_county_name"><!--- &field_long_address --->
                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_pars&#str_linke_ait#&select_list=7,8&is_form_submitted=1&keyword='+encodeURIComponent(document.add_service.applicator_comp_name.value)</cfoutput>,'list','popup_list_all_pars');"><img src="/images/plus_thin.gif" title="<cf_get_lang no ='275.Basvuru Yapan Seç'>" align="absmiddle" border="0"></a>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='87.Telefon'></td>
            <td>
                <input type="text" name="bring_tel_no" id="bring_tel_no" value="<cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.bring_tel_no#</cfoutput><cfelseif isdefined("attributes.bring_tel_no")><cfoutput>#attributes.bring_tel_no#</cfoutput></cfif>" maxlength="15" onKeyUp="isNumber(this);" style="width:140px;">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='1401.Mobil Telefonu'></td>
            <td>
                <input type="text" name="bring_mobile_no"  id="bring_mobile_no" value="<cfif len(get_service_detail.bring_mobile_no)><cfoutput>#get_service_detail.bring_mobile_no#</cfoutput></cfif>" maxlength="15" onKeyUp="isNumber(this);" style="width:140px;">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='16.E-Mail'></td>
            <td>
                <input type="text" name="bring_email" id="bring_email" value="<cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.bring_email#</cfoutput><cfelseif isdefined("attributes.bring_email")><cfoutput>#attributes.bring_email#</cfoutput></cfif>" maxlength="150" style="width:140px;">
            </td>
        </tr>
        <tr>
            <td>Servis Adresi</td>
            <td>
                <textarea name="service_address" id="service_address" style="width:140px;height:70px;"><cfif isdefined("get_service_detail.service_address")><cfoutput>#get_service_detail.service_address#</cfoutput></cfif></textarea>
                <a href="javascript://" onClick="add_adress('1');"><img border="0" src="/images/plus_thin.gif" align="absmiddle"></a>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='1196.İl'></td>
            <td>
                <select name="service_city_id" id="service_city_id" style="width:140px;">
                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                    <cfloop query="get_city">
                        <cfif isdefined("get_service_detail.service_city_id")>
                            <option value="#city_id#" <cfif city_id eq get_service_detail.service_city_id>selected</cfif>>#city_name#</option>
                        <cfelseif isdefined("attributes.service_city_id")>
                            <option value="#city_id#" <cfif city_id eq attributes.service_city_id>selected</cfif>>#city_name#</option>
                        <cfelse>
                            <option value="#city_id#">#city_name#</option>
                        </cfif>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='1226.İlçe'></td>
            <td>
                <cfif (isdefined("get_service_detail.service_county_id") and len(get_service_detail.service_county_id)) or (isdefined("attributes.service_county_id") and len(attributes.service_county_id))>
                    <cfif isdefined("get_service_detail.service_county_id") and len(get_service_detail.service_county_id)>
                        <cfset county_id_ = get_service_detail.service_county_id>
                    <cfelseif isdefined("attributes.service_county_id") and len(attributes.service_county_id)>
                        <cfset county_id_ = attributes.service_county_id>
                    </cfif>
                    <cfquery name="GET_COUNTY" datasource="#DSN#">
                        SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#county_id_#">
                    </cfquery>
                    <cfset county_ = get_county.county_name>
                    <input type="text" name="service_county_name" id="service_county_name" value="<cfoutput>#county_#</cfoutput>" style="width:140px;">
                    <input type="hidden" name="service_county_id" id="service_county_id" value="<cfoutput>#county_id_#</cfoutput>">
                <cfelse>
                    <input type="text" name="service_county_name" id="service_county_name" value="" style="width:140px;">
                    <input type="hidden" name="service_county_id" id="service_county_id" value="">
                </cfif>
                <a href="javascript://" onClick="pencere_ac();"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no ='322.Seçiniz'>" border="0" align="absmiddle"></a>
            </td>
        </tr>
        <tr>
            <td>Kabul Belge No</td>
            <td>
                <input type="text" name="doc_no" id="doc_no" value="<cfif isdefined('get_service_detail.doc_no')><cfoutput>#get_service_detail.doc_no#</cfoutput></cfif>" maxlength="150" style="width:140px;">
            </td>
        </tr>
    </table>
   	<cf_seperator title="Teslim Bilgisi" id="teslim_bilgisi">
    <table id="teslim_bilgisi">
        <tr>
            <td>Teslim Alacak</td>
            <td><input type="text" name="service_county" id="service_county" value="#get_service_detail.service_county#" style="width:140px;" maxlength="100"></td>
        </tr>
        <tr>
            <td>Teslim Belge No</td>
            <td><input type="text" name="service_city" id="service_city" value="" style="width:140px;"></td>
        </tr>
        <tr>
            <td>Teslim Adresi</td>
            <td>
                <cfif isdefined("attributes.bring_detail")>
                    <textarea name="bring_detail" id="bring_detail" style="width:140px;height:70px;"><cfoutput>#attributes.bring_detail#</cfoutput></textarea>
                <cfelse>
                    <textarea name="bring_detail" id="bring_detail" style="width:140px;height:70px;"></textarea>
                </cfif>
                <a href="javascript://" onClick="add_adress('2');" style="vertical-align:top;"><img border="0" src="/images/plus_list.gif" align="top" style="vertical-align:top;"></a>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='1703.Sevk Yöntemi'></td>
            <td>
                <input type="hidden" name="ship_method" id="ship_method" value="<cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.ship_method#</cfoutput></cfif>">
                <cfif isdefined("attributes.service_id") and len(get_service_detail.ship_method)>
                    <cfset attributes.ship_method_id=get_service_detail.ship_method>
                    >><cfinclude template="../../../service/query/get_ship_method.cfm">
                </cfif>
                <input type="text" name="ship_method_name" id="ship_method_name" value="<cfif isdefined("attributes.service_id") and len(get_service_detail.ship_method)><cfoutput>#ship_method.ship_method#</cfoutput></cfif>" style="width:140px;">
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_ship_methods&field_name=upd_service_stage.ship_method_name&field_id=upd_service_stage.ship_method','list');" title="Sevk Yöntemi Seçiniz"><img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="Sevk Yöntemi Seçiniz"></a>
            </td>
        </tr>
    </table>
</cfoutput>
<br/>
