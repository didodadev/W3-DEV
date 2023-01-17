<cfset attributes.brand_id = url.id>
<cfquery name="GET_BRAND" datasource="#DSN1#">
	SELECT 
    	BRAND_ID,
        BRAND_CODE,
        BRAND_NAME,
        DETAIL,
        IS_ACTIVE,
        IS_INTERNET,
        RECORD_DATE,
        RECORD_EMP,
        RECORD_IP,
        UPDATE_DATE,
        UPDATE_EMP,
        UPDATE_IP 
	FROM 
		PRODUCT_BRANDS 
	WHERE 
    	BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<cfquery name="GET_BRAND_COMPS" datasource="#dsn1#">
	SELECT * FROM PRODUCT_BRANDS_OUR_COMPANY WHERE BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>

<cfset our_comp_list = valuelist(get_brand_comps.our_company_id)>
<cfinclude template="../query/get_our_companies.cfm">
<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%" class="color-border">
	<tr class="color-list" height="35">
		<td class="headbold" colspan="2"><cf_get_lang dictionary_id='58847.Marka'></td>
	</tr>
	<tr class="color-row" valign="top">
	<cfform action="#request.self#?fuseaction=objects.emptypopup_upd_product_brands" method="post" name="product_cat" enctype="multipart/form-data">
        <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
		<td>
            <table>
                <tr>
                    <td></td>
                    <td>
                        <input type="checkbox" name="is_active" id="is_active" <cfif get_brand.is_active eq 1>checked</cfif> value="1"><cf_get_lang dictionary_id ='57493.Aktif '>
                        <input type="checkbox" name="is_internet" id="is_internet" <cfif get_brand.is_internet eq 1>checked</cfif> value="1"><cf_get_lang dictionary_id ='58079.Internet'>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td width="70"><cf_get_lang dictionary_id='58847.Marka'>*</td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='33073.marka girmelisiniz'></cfsavecontent>
                        <cfinput type="Text" name="brand_name" id="brand_name" value="#get_brand.brand_name#" maxlength="75" required="Yes" message="#message#" style="width:200px;">
                    </td>
                    <td>
                        <cf_language_info 
                            table_name="PRODUCT_BRANDS" 
                            column_name="BRAND_NAME" 
                            column_id_value="#attributes.id#" 
                            maxlength="500" 
                            datasource="#dsn1#" 
                            column_id="BRAND_ID" 
                            control_type="0">
                    </td>
                </tr>
                <tr>
                    <td width="70"><cf_get_lang dictionary_id='58585.Kod'> *</td>
                    <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='33952.Kod Girmelisiniz'> </cfsavecontent>
                        <cfinput type="text" name="brand_code" id="brand_code" value="#get_brand.brand_code#" maxlength="50" required="Yes" message="#message#" style="width:200px;">
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
                    <td>
                        <textarea name="detail" id="detail" style="width:200px;height:80;"><cfif len(get_brand.detail)><cfoutput>#get_brand.detail#</cfoutput></cfif></textarea>
                        </td>
                        <td>
                        <cf_language_info 
                            table_name="PRODUCT_BRANDS" 
                            column_name="DETAIL" 
                            column_id_value="#attributes.id#" 
                            maxlength="500" 
                            datasource="#dsn1#" 
                            column_id="BRAND_ID" 
                            control_type="0">
                        </td>
                </tr>
                <tr>
<!---                    <td align="right" colspan="3" height="35"><cf_workcube_buttons is_upd='1' add_function='kapa_refresh()&&productcat_comp()' delete_page_url='#request.self#?fuseaction=objects.emptypopup_del_product_brands&id=#attributes.id#&old_brand_logo=#get_brand.brand_logo#&old_brand_logo_server_id=#get_brand.brand_logo_server_id#&head=#get_brand.brand_code#'></td>--->
                    <td align="right" colspan="3" height="35"><cf_workcube_buttons is_upd='1' add_function='kapa_refresh()&&productcat_comp()' delete_page_url='#request.self#?fuseaction=objects.emptypopup_del_product_brands&id=#attributes.id#&head=#get_brand.brand_code#'></td>
                </tr>
                <tr>
                    <td colspan="3">
                        <cf_get_lang dictionary_id='57483.Kayit'>: <cfoutput>#get_emp_info(get_brand.record_emp,0,0)# - #dateformat(get_brand.record_date,dateformat_style)#</cfoutput>
                        <cfif len(get_brand.update_emp)>
                            <br/><cf_get_lang dictionary_id='57703.Güncelleme'>: <cfoutput>#get_emp_info(get_brand.update_emp,0,0)# - #dateformat(get_brand.update_date,dateformat_style)#</cfoutput>
                        </cfif>
                    </td>
                </tr>
            </table>
		</td>
		<td>
			<cfinclude template="../../product/display/dsp_product_images.cfm">
			<table>
				<tr> 
					<td class="txtboldblue"><cf_get_lang dictionary_id ='58017.Iliskili Sirketler'></td>
				</tr>
				<tr>
					<td><select multiple="multiple" name="our_company_ids" id="our_company_ids" style="width:180px; height:65px;">
							<cfoutput query="get_our_companies">
								<option value="#comp_id#" <cfif listlen(our_comp_list) and listfindnocase(our_comp_list,comp_id)>selected</cfif>>#nick_name#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
			</table>
			<br/>
			<cf_get_workcube_content action_type ='BRAND_ID' action_type_id ='#attributes.id#' style='0' design='0' width="180">
		</td>
	</tr>
</table>
</cfform>
<script type="text/javascript">
	function productcat_comp()
	{
		var new_our_company_list='';
		
		for(ii=0;ii<document.product_cat.our_company_ids.length; ii++)
		{
			if(product_cat.our_company_ids[ii].selected && product_cat.our_company_ids.options[ii].value.length!='')
				new_our_company_list= new_our_company_list + ',' + product_cat.our_company_ids.options[ii].value;
		}
		<cfloop list="#our_comp_list#" index="k">
			if(!list_find(new_our_company_list,<cfoutput>#k#</cfoutput>,',') )
			{
				var new_dsn3 = '<cfoutput>#dsn#_#k#</cfoutput>';
				var get_productcat = wrk_safe_query("obj_get_productcat",new_dsn3,0,<cfoutput>#url.id#</cfoutput>);
				if (get_productcat.recordcount)
				{
					alert("<cf_get_lang dictionary_id ='33958.İlgili Şirkette Bu Kategori Bir Üründe Kullanılmıştır'>");
					return false;
				}
			}
		</cfloop>
	}
	function kapa_refresh()
	{
		y=(1000-product_cat.detail.value.length);
		if(y<0)
		{
			alert("<cf_get_lang dictionary_id ='57629.Açıklama'> "+((-1)*y)+"<cf_get_lang dictionary_id='29538.Karakter Uzun'> ");
			return false;
		}
		return true;
	}
	function del_images()
	{
		document.product_cat.del_1.style.display='';
		document.product_cat.del_2.style.display='none';
		document.product_cat.old_logo_del.value=1;
	}
</script>
