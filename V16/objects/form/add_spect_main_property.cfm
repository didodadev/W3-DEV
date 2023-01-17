<!---20060418 sadece ürünlerin özelliklerini getrir değer aralığı açıklama tutar manual girilir--->
<!--- <cfif spec_purchasesales eq 1>
	<!--- üyenin fiyat listesini bulmak için--->
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<cfquery name="GET_PRICE_CAT_CREDIT" datasource="#dsn#">
			SELECT 
				PRICE_CAT 
			FROM 
				COMPANY_CREDIT 
			WHERE 
				COMPANY_ID = #attributes.company_id#  AND 
				OUR_COMPANY_ID = #session.ep.company_id#
		</cfquery>
		<cfif GET_PRICE_CAT_CREDIT.RECORDCOUNT and len(GET_PRICE_CAT_CREDIT.PRICE_CAT)>
			<cfset attributes.price_catid=GET_PRICE_CAT_CREDIT.PRICE_CAT>
		<cfelse>
			<cfquery name="GET_COMP_CAT" datasource="#dsn#">
				SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
			</cfquery>
			<cfquery name="GET_PRICE_CAT_COMP" datasource="#dsn3#">
				SELECT 
					PRICE_CATID
				FROM
					PRICE_CAT
				WHERE
					COMPANY_CAT LIKE '%,#GET_COMP_CAT.COMPANYCAT_ID#,%'
			</cfquery>
			<cfset attributes.price_catid=GET_PRICE_CAT_COMP.PRICE_CATID>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		<cfquery name="GET_COMP_CAT" datasource="#DSN#">
			SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = #attributes.consumer_id#
		</cfquery>
		<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
			SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE '%,#get_comp_cat.consumer_cat_id#,%'
		</cfquery>
		<cfset attributes.price_catid=get_price_cat.PRICE_CATID>
	</cfif>
	<!--- //üyenin fiyat listesini bulmak için--->
</cfif> --->
<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
	<cfquery name="GET_PRODUCT" datasource="#dsn3#">
		SELECT 
			STOCKS.IS_PROTOTYPE,
			STOCKS.PRODUCT_NAME,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_ID,
			STOCKS.PROPERTY
		FROM 
			STOCKS
		WHERE 
			STOCKS.STOCK_ID = #attributes.stock_id#
	</cfquery>
	<cfset attributes.product_id=GET_PRODUCT.PRODUCT_ID>

	<cfquery name="GET_PROPERTY" datasource="#DSN1#">
		SELECT 
		PRODUCT_DT_PROPERTIES.*,
		PRODUCT_PROPERTY.PROPERTY,
		PRODUCT_PROPERTY.PROPERTY_ID
	FROM 
		PRODUCT_DT_PROPERTIES,
		PRODUCT_PROPERTY
	WHERE 
		PRODUCT_DT_PROPERTIES.PRODUCT_ID = #attributes.product_id# AND
		PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID
	</cfquery>
</cfif>
<!--- <cfif spec_purchasesales eq 1 and isdefined("attributes.price_catid") and len(attributes.price_catid)>
	<cfquery name="GET_PRICE" datasource="#dsn3#">
		SELECT
			PRICE_STANDART.PRODUCT_ID,
			SM.MONEY,
			PRICE_STANDART.PRICE,
			(PRICE_STANDART.PRICE*(SM.RATE2/SM.RATE1)) AS PRICE_STDMONEY,
			(PRICE_STANDART.PRICE_KDV*(SM.RATE2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
			SM.RATE2,
			SM.RATE1
		FROM
			PRICE PRICE_STANDART,	
			PRODUCT_UNIT,
			#dsn_alias#.SETUP_MONEY AS SM
		WHERE
			PRICE_STANDART.PRICE_CATID = #attributes.price_catid# AND
			PRICE_STANDART.STARTDATE < #now()# AND 
			(PRICE_STANDART.FINISHDATE >= #now()# OR PRICE_STANDART.FINISHDATE IS NULL) AND
			PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
			PRICE_STANDART.PRODUCT_ID = #attributes.product_id# AND 
			PRODUCT_UNIT.IS_MAIN = 1 AND
			SM.MONEY = PRICE_STANDART.MONEY AND
			SM.PERIOD_ID = #session.ep.period_id#
	</cfquery>
</cfif> --->
<!--- <cfif not isdefined("GET_PRICE") or GET_PRICE.RECORDCOUNT eq 0>
	<cfquery name="GET_PRICE" datasource="#dsn3#">
		SELECT
			PRICE_STANDART.PRODUCT_ID,
			SM.MONEY,
			PRICE_STANDART.PRICE,
			(PRICE_STANDART.PRICE*(SM.RATE2/SM.RATE1)) AS PRICE_STDMONEY,
			(PRICE_STANDART.PRICE_KDV*(SM.RATE2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
			SM.RATE2,
			SM.RATE1
		FROM
			PRODUCT,
			PRICE_STANDART,
			#dsn_alias#.SETUP_MONEY AS SM
		WHERE
			PRODUCT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
			PURCHASESALES = <cfif spec_purchasesales eq 1>1<cfelse>0</cfif> AND
			PRICESTANDART_STATUS = 1 AND
			SM.MONEY = PRICE_STANDART.MONEY AND
			SM.PERIOD_ID = #session.ep.period_id# AND
			PRODUCT.PRODUCT_ID = #attributes.product_id#
	</cfquery>
</cfif> --->
<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%" class="color-border">
	<tr class="color-list">
	  <td height="35" class="headbold">
		  <table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>	
				<td class="headbold"><cf_get_lang dictionary_id='32446.Spect Ekle'></td>
				<cfif isdefined("attributes.product_id")>
					<td style="text-align:right;"><a href="<cfoutput>#request.self#?fuseaction=objects.popup_list_spect<cfif isdefined("attributes.row_id")>&row_id=#attributes.row_id#</cfif><cfif isdefined("attributes.company_id")>&company_id=#attributes.company_id#</cfif>&stock_id=#attributes.stock_id#</cfoutput>"><img src="/images/cuberelation.gif" align="absmiddle" border="0" title="<cf_get_lang dictionary_id='33920.Konfigüratör'>"></a></td>
				</cfif>
			</tr>
		  </table>
	  </td>
	</tr>
	<tr class="color-row" valign="top">
	  <td>
		<cfform  name="add_spect_variations" action="#request.self#?fuseaction=objects.emptypopup_add_spect_main_property" method="post" enctype="multipart/form-data">
		<input type="hidden" name="is_change" id="is_change" value="1">
		<cfif isdefined("attributes.row_id")><!--- basketen geldi ise basketteki satırı--->
			<input type="hidden" name="row_id" id="row_id" value="<cfoutput>#attributes.row_id#</cfoutput>">
		</cfif>
		<table border="0" width="540">
			<tr>
			  <td colspan="7">
				<table>
					<tr>
						<td width="65"><cf_get_lang dictionary_id='57647.Spec'></td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='32755.Spec girmelisiniz'></cfsavecontent>
							<cfset spec_name=get_product.product_name>
							<cfif len(get_product.PROPERTY)><cfset spec_name="#spec_name# #get_product.PROPERTY#"></cfif>
							<cfinput type="text" name="spect_name" required="yes" message="#message#" style="width:200;" value="#spec_name#" maxlength="50">
							<input type="hidden" name="value_product_id_deger" id="value_product_id_deger" value="<cfoutput>#get_product.product_id#</cfoutput>">
							<input type="hidden" name="value_stock_id" id="value_stock_id" value="<cfoutput>#get_product.stock_id#</cfoutput>">
						</td>
						<td>Fiyatı Güncelle</td>
						<td><input type="checkbox" name="is_price_change" id="is_price_change" value="1" checked></td>
						<td><cfif isdefined('GET_PRODUCT.IS_PROTOTYPE') and GET_PRODUCT.IS_PROTOTYPE><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cfif></td>
					</tr>	
				</table>
			  </td>
			</tr>
			<tr class="color-header" height="20">
				<td class="form-title" width="100"><cf_get_lang dictionary_id='59106.Özellik'></td>
				<td class="form-title" width="110"><cf_get_lang dictionary_id='37249.Varyasyon'></td>
				<td class="form-title" width="180"><cf_get_lang dictionary_id='57629.Açıklama'></td>
				<td class="form-title" width="65"><cf_get_lang dictionary_id='37250.Değer'></td>
				<td class="form-title" width="50"><cf_get_lang dictionary_id='57635.Miktar'></td>
			</tr>
			<tr>
				<td colspan="7" valign="top">
				<cfset satir=0>
				 <input type="hidden" name="pro_record_num" id="pro_record_num" value="<cfoutput>#get_property.recordcount#</cfoutput>">
				  <cfoutput query="get_property">
					<cfset satir=satir+1>
					<cfquery name="GET_VARIATION" datasource="#DSN1#">
						SELECT PROPERTY_DETAIL_ID, PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = #get_property.property_id#
					</cfquery>
				  <table width="100%" border="0">
				  <tr>
					<td width="100"><b>#property#</b></td>
					<td><input type="hidden" name="tree_row_kontrol#satir#" id="tree_row_kontrol#satir#" value="1">
						<select name="pro_variation_id#currentrow#" id="pro_variation_id#currentrow#" style="width:110px;">
						<cfset var_value = get_property.variation_id>
						<option value=""><cf_get_lang dictionary_id='37249.Varyasyon'></option>
						<cfloop query="get_variation">	
							<option value="#PROPERTY_DETAIL_ID#,#PROPERTY_DETAIL#" <cfif var_value eq PROPERTY_DETAIL_ID>selected</cfif>>#PROPERTY_DETAIL#</option>
						</cfloop>
						</select>
					</td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='55805.Sayı Giriniz'>!</cfsavecontent>
					<td><input type="text" name="pro_product_name#currentrow#" id="pro_product_name#currentrow#" value="" style="width:180px" ></td>
					<td><cfinput type="text" name="pro_total_min#currentrow#" value="#TOTAL_MIN#" validate="float" message="#message#" style="width:30px">
						<cfinput type="text" name="pro_total_max#currentrow#" value="#TOTAL_MAX#" validate="float" message="#message#" style="width:30px">
					</td>
					<td><input type="hidden" name="pro_property_id#currentrow#" id="pro_property_id#currentrow#" value="#PROPERTY_ID#">
						
						<cfinput type="text" name="pro_amount#currentrow#" value="#TLFormat(1,3)#" onkeyup="return(FormatCurrency(this,event,3))" validate="float" message="#message#" style="width:50px" class="moneybox" >
					</td>
				  </tr>
				  </table>
				</cfoutput>
			   </td>
			</tr>
		</table>
		  </cfform>
	   </td>
	</tr>
</table>
<script type="text/javascript">
/*function open_product_detail(pro_id,s_id)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+pro_id+'&sid='+s_id,'list'); 
}*/
function kontrol()
{
	//özelikli config yoksa
	for (var r=1;r<=add_spect_variations.pro_record_num.value;r++)
	{
		form_pro_amount = eval('add_spect_variations.pro_amount'+r);
		pro_total_min =eval('add_spect_variations.pro_total_min'+r);
		pro_total_max =eval('add_spect_variations.pro_total_max'+r);
		form_pro_amount.value = filterNum(form_pro_amount.value);
		pro_total_min.value=filterNum(pro_total_min.value);
		pro_total_max.value=filterNum(pro_total_max.value);
	}
}
</script>
