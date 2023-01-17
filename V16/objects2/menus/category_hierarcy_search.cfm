<!-- sil -->
<cfparam name="attributes.hierarchy_keyword" default="">
<cfparam name="attributes.main_category" default="">
<cfparam name="attributes.main_category2" default="">
<cfparam name="attributes.main_category3" default="">
<cfparam name="attributes.main_category4" default="">
<cfparam name="attributes.brand_id" default="">
<cfquery name="GET_BRANDS" datasource="#DSN1#">
	SELECT 
		PB.BRAND_NAME,
		PB.BRAND_ID
	FROM 
		PRODUCT_BRANDS PB,
		PRODUCT_BRANDS_OUR_COMPANY PBO
	WHERE
		PB.BRAND_ID = PBO.BRAND_ID AND
		PBO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
		PB.IS_ACTIVE = 1 AND
		PB.IS_INTERNET = 1
	ORDER BY 
		PB.BRAND_NAME
</cfquery>

<cfquery name="GET_UST_CATEGORY" datasource="#DSN1#">
	SELECT 
		PC.PRODUCT_CAT,
		PC.PRODUCT_CATID,
		PC.HIERARCHY,
		PC.LIST_ORDER_NO
	FROM 
		PRODUCT_CAT PC,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
		PC.IS_PUBLIC = 1
	ORDER BY 
		PC.LIST_ORDER_NO,PC.HIERARCHY
</cfquery>

<table cellpadding="0" cellspacing="0" width="100%" height="30" class="search_menu">
	<tr>
		<td  class="search_menu" style="text-align:right;">
			<table style="text-align:right;" width="100%">
				<cfform name="form_category" action="#request.self#?fuseaction=objects2.view_product_list" method="post">
				<tr>
					<td valign="top" width="150">
						<select name="main_category" id="main_category" style="width:150px;" onChange="showaltcategory(1);">
								<option value=""><cf_get_lang no='183.Ana Kategori'></option>
							<cfoutput query="get_ust_category">
								<cfif listlen(hierarchy,'.') eq 1>
									<option value="#hierarchy#" <cfif attributes.main_category eq hierarchy>selected</cfif>>#product_cat#</option>
								</cfif>
							</cfoutput>
						</select>
					</td>
					<td valign="top" width="150">
						<div id="altcategory_place" style="width:150px;overflow:none;">
						<select name="main_category2" id="main_category2" style="width:150px;" disabled="disabled" onChange="showaltcategory(2)">
							<option value=""><cf_get_lang dictionary_id='60558.Kurulum Yeri'>/<cf_get_lang_main no='74.Kategori'></option>
							<cfoutput query="get_ust_category">
								<cfif listlen(hierarchy,'.') eq 2>
									<option value="#hierarchy#" <cfif attributes.main_category2 eq hierarchy>selected</cfif>>#product_cat#</option>
								</cfif>
							</cfoutput>
						</select>
						</div>
					</td>
					<td valign="top" width="150">
						<div id="altcategory_place2" style="width:150px;overflow:none;">
						<select name="main_category3" id="main_category3" style="width:150px;" disabled="disabled" onChange="showaltcategory(3)">
							<option value=""><cf_get_lang dictionary_id="60557.Kurulum Tipi">/<cf_get_lang_main no='74.Kategori'></option>
							<cfoutput query="get_ust_category">
								<cfif listlen(hierarchy,'.') eq 3>
									<option value="#hierarchy#" <cfif attributes.main_category3 eq hierarchy>selected</cfif>>#product_cat#</option>
								</cfif>
							</cfoutput>
						</select>
						</div>
					</td>
					<td valign="top" width="150">
						<div id="altcategory_place3" style="width:150px;overflow:none;">
						<select name="main_category4" id="main_category4" disabled="disabled" style="width:150px;">
							<option value=""><cf_get_lang no='185.Tipoloji'></option>
							<cfoutput query="get_ust_category">
								<cfif listlen(hierarchy,'.') eq 4>
									<option value="#hierarchy#" <cfif attributes.main_category4 eq hierarchy>selected</cfif>>#product_cat#</option>
								</cfif>
							</cfoutput>
						</select>
						</div>
					</td>
					<td valign="top">
                    	<select name="brand_id" id="brand_id">
							<option value=""><cf_get_lang_main no='1435.Marka'></option>
							<cfoutput query="get_brands">
								<option value="#brand_id#" <cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and (attributes.brand_id eq brand_id)>selected</cfif>>#brand_name#</option>
							</cfoutput>
						</select>
					</td>
					<td valign="top"><input type="text" name="hierarchy_keyword" id="hierarchy_keyword" style="width:100px;" value="<cfoutput>#attributes.hierarchy_keyword#</cfoutput>"></td>
					<td valign="top"><input type="image" src="../../objects2/image/ara.gif" value="<cf_get_lang_main no='153.Ara'>" onClick="gonder();"></td>
					<td valign="top"><input type="image" src="../../objects2/image/reset.png" value="<cf_get_lang no='191.Reset'>" onClick="temizle();" style="width:20px; height:20px;"></td> 
				</tr>
			<input type="hidden" name="hierarchy" id="hierarchy" value="">
			</cfform>
			</table>
	  	</td>
	</tr>
</table>

<script type="text/javascript">
function showaltcategory(type)
{
	tmp1 = document.getElementById('main_category').selectedIndex;
	tmp1 = document.form_category.main_category[tmp1].value;
	
	tmp2 = document.getElementById('main_category2').selectedIndex;
	tmp2 = document.form_category.main_category2[tmp2].value;
	
	tmp3 = document.getElementById('main_category3').selectedIndex;
	tmp3 = document.form_category.main_category3[tmp3].value;

	if(type==1)
	{	
		var send_address1 = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_get_altcategory&type=1&hierarchy=";
		send_address1 +=tmp1;
		AjaxPageLoad(send_address1,'altcategory_place');
	}

	if(type==2 || type==1)
	{
		var send_address2 = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_get_altcategory&type=2&hierarchy=";
		if(type==2)
			send_address2 +=tmp2;
		else if(type==1)
			send_address2 +=tmp1;
		AjaxPageLoad(send_address2,'altcategory_place2');
	}
	
	if(type==3 || type==2 || type==1)
	{
		var send_address3 = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_get_altcategory&type=3&hierarchy=";
		if(type==3)
			send_address3 +=tmp3;
		else if(type==2)
			send_address3 +=tmp2;
		else if(type==1)
			send_address3 +=tmp1;
		AjaxPageLoad(send_address3,'altcategory_place3');
	}
}
function gonder()
{
	tmp1 = document.getElementById('main_category').selectedIndex;
	tmp1 = document.form_category.main_category[tmp1].value;
	
	tmp2 = document.getElementById('main_category2').selectedIndex;
	tmp2 = document.form_category.main_category2[tmp2].value;
	
	tmp3 = document.getElementById('main_category3').selectedIndex;
	tmp3 = document.form_category.main_category3[tmp3].value;
	
	tmp4 = document.getElementById('main_category4').selectedIndex;
	tmp4 = document.form_category.main_category4[tmp4].value;
	
	if(tmp4!="")
		document.getElementById('hierarchy').value = tmp4;
	else if(tmp3!="")
		document.getElementById('hierarchy').value = tmp3;
	else if(tmp2!="")
		document.getElementById('hierarchy').value = tmp2;
	else if(tmp1!="")
		document.getElementById('hierarchy').value = tmp1;
}
function temizle()
{
	document.getElementById('hierarchy_keyword').value = '';
	document.getElementById('main_category').value = '';
	document.getElementById('main_category2').value = '';
	document.getElementById('main_category3').value = '';
	document.getElementById('main_category4').value = '';
	document.getElementById('brand_id').value = '';
}
</script>
<!-- sil -->
