<cfparam name="attributes.system_company_id" default="#SESSION.EP.COMPANY_ID#">
<!--- <cfinclude template="../query/get_stocks.cfm">  bu include a göre düzenlenebilir(stock_id farkı var) AE20051018--->
<cfquery name="GET_ALL_DEPARTMENTS" datasource="#dsn#">
    SELECT
        D.DEPARTMENT_ID,
        D.DEPARTMENT_HEAD,
		SL.LOCATION_ID,
		SL.COMMENT
    FROM
        BRANCH B,
        DEPARTMENT D,
		STOCKS_LOCATION SL
    WHERE
        B.COMPANY_ID = #session.ep.company_id# AND
        B.BRANCH_ID = D.BRANCH_ID AND
		D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND
		--SL.PRIORITY = 1 AND
        D.IS_STORE <> 2 AND
        D.DEPARTMENT_STATUS = 1 AND 
        B.BRANCH_ID IN (SELECT BRANCH_ID FROM  EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
</cfquery>
	<cfset new_dept_list_ = valuelist(GET_ALL_DEPARTMENTS.DEPARTMENT_ID)>
	<!--- <cfset new_location_list_ = valuelist(GET_ALL_DEPARTMENTS.LOCATION_ID)> --->
<cfif len(new_dept_list_)>
	<cfquery name="GET_STOCKS_ALL" datasource="#dsn2#">
		SELECT
			SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, 
			S.PRODUCT_ID, 
			S.STOCK_ID, 
			S.STOCK_CODE, 
			S.PROPERTY, 
			S.BARCOD,
			SR.STORE AS DEPARTMENT_ID,
			SR.STORE_LOCATION
		FROM
			#dsn1_alias#.STOCKS S,
			STOCKS_ROW SR
		WHERE
			S.STOCK_ID = SR.STOCK_ID AND
			S.STOCK_ID = #attributes.stock_id# AND
			SR.STORE IN (#new_dept_list_#)
			<!---  AND SR.STORE_LOCATION IN (#new_location_list_#) --->
		GROUP BY
			S.PRODUCT_ID, 
			S.STOCK_ID, 
			S.STOCK_CODE, 
			S.PROPERTY, 
			S.BARCOD, 
			SR.STORE,
			SR.STORE_LOCATION
	</cfquery>
	<cfif GET_STOCKS_ALL.recordcount>
		<cfoutput query="GET_STOCKS_ALL">
			<cfset 'dept_amount_#GET_STOCKS_ALL.STOCK_ID#_#GET_STOCKS_ALL.DEPARTMENT_ID#_#GET_STOCKS_ALL.STORE_LOCATION#' = GET_STOCKS_ALL.PRODUCT_STOCK>
		</cfoutput>
	</cfif>
</cfif>
<cfset satir_sayac = 0 >
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td class="headbold" id="urun"><cf_get_lang dictionary_id='32768.Depolar ve Lokasyonlar'>/<cf_get_lang dictionary_id="57657.Ürün">:</td>
  </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
<cfif GET_ALL_DEPARTMENTS.recordcount>
  <tr class="color-border">
    <td>
	<cfform name="add_department">
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr height="22" class="color-header">
          <td class="form-title"><cf_get_lang dictionary_id='58763.Depo'></td>
		  <td width="100"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="33076.Depo Stok Miktar"></td>
          <td width="125" class="form-title"><cf_get_lang dictionary_id="57635.Miktar"></td>
        </tr>
		<cfoutput query="GET_ALL_DEPARTMENTS">
			<cfset satir_sayac = satir_sayac + 1 >
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#DEPARTMENT_HEAD# - #COMMENT#</td>
				<td  style="text-align:right;">
					<cfif isdefined('dept_amount_#attributes.stock_id#_#GET_ALL_DEPARTMENTS.DEPARTMENT_ID#_#GET_ALL_DEPARTMENTS.LOCATION_ID#') and len(evaluate('dept_amount_#attributes.stock_id#_#GET_ALL_DEPARTMENTS.DEPARTMENT_ID#_#GET_ALL_DEPARTMENTS.LOCATION_ID#'))>
						<cfif evaluate('dept_amount_#attributes.stock_id#_#GET_ALL_DEPARTMENTS.DEPARTMENT_ID#_#GET_ALL_DEPARTMENTS.LOCATION_ID#') lt 0>
							<font color="red">#TLFormat(evaluate('dept_amount_#attributes.stock_id#_#GET_ALL_DEPARTMENTS.DEPARTMENT_ID#_#GET_ALL_DEPARTMENTS.LOCATION_ID#'))#</font>
						<cfelse>
							#TLFormat(evaluate('dept_amount_#attributes.stock_id#_#GET_ALL_DEPARTMENTS.DEPARTMENT_ID#_#GET_ALL_DEPARTMENTS.LOCATION_ID#'))#
						</cfif>
					<cfelse>
						#TLFormat(0)#
					</cfif>
					<cfif isdefined("attributes.unit")>#attributes.unit#</cfif>
				</td>
				<td>
					<input name="amount_#DEPARTMENT_ID#_#LOCATION_ID#" id="amount_#DEPARTMENT_ID#_#LOCATION_ID#" type="text" class="moneybox"  onkeyup="return(FormatCurrency(this,event,3));">
					<input name="department#satir_sayac#" id="department#satir_sayac#" type="hidden" value="#DEPARTMENT_ID#">
					<input name="location#satir_sayac#" id="location#satir_sayac#" type="hidden" value="#LOCATION_ID#">		
				</td>
			</tr>
		</cfoutput>
		<input type="hidden" name="array_rows" id="array_rows" value="<cfoutput>#satir_sayac#</cfoutput>">
		<input type="hidden" name="max_product" id="max_product" value="<cfoutput>#attributes.rowCount#</cfoutput>">			
		<tr>
			<td height="20"  colspan="5"  style="text-align:right;" <cfoutput>onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row"</cfoutput>>
			<input type="button" value="<cf_get_lang dictionary_id='57461.Kaydet'>" onClick="kontrol_toplam();">
			</td>
		</tr>			
		</cfform>
      </table>
    </td>
  </tr>
<cfelse>
	<tr>
		<td colspan="5" height="20" class="color-border"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</td>
	</tr>			
</cfif>
</table>
<script type="text/javascript">
s_len=<cfoutput>#attributes.row_id#</cfoutput>;
function load_opener_values()
{
	counter = 1;
	if (opener.departmentArray[s_len] != undefined)
	{
		for(var int_k = 1; int_k < opener.departmentArray[s_len].length ;int_k++)
		{
			if (opener.departmentArray[s_len][int_k][1] != undefined)
			{
				dep = opener.departmentArray[s_len][int_k][1];
				loc = opener.departmentArray[s_len][int_k][2];
				try{
					temp_field = eval('add_department.amount_' + dep + '_' + loc);
					temp_field.value = commaSplit(opener.departmentArray[s_len][int_k][0],3);
					counter++;
				}catch(e){}
			}
		}
	}
}
if (opener.departmentArray[s_len] != undefined)
{
	load_opener_values();
}
function kontrol_toplam()
{
	var en_genel_toplam=0;
	var tempArray = new Array(1);
	var counter = 1;
	tempArray[0] = new Array(1);
	size1 = <cfoutput>#satir_sayac#</cfoutput>;
	for(i = 1; i<= size1 ;i++)
		{
			tempArray[counter] = new Array(1);
			eleman = eval('add_department.amount_' + eval("add_department.department" + i  + ".value") + '_' + eval("add_department.location" + i + ".value") +  '.value');
			eleman == (eleman == "") ? 0 : eleman ;
			if(eleman != 0){
				tempArray[counter][0] = eleman;
				en_genel_toplam += parseFloat(opener.filterNum(tempArray[counter][0],3));
				tempArray[counter][1] = eval('add_department.department' + i  + '.value');
				tempArray[counter][2] = eval('add_department.location' + i + '.value');
				counter++;
			}
		}
	<cfif attributes.rowCount eq 1>
		opener.form_basket.amount.value=commaSplit(en_genel_toplam,3);
	<cfelse>
		opener.form_basket.amount[<cfoutput>#(attributes.row_id-1)#</cfoutput>].value=commaSplit(en_genel_toplam,3);
	</cfif>		
	opener.departman_urun_doldur(<cfoutput>#attributes.row_id#</cfoutput>,counter-1,tempArray);
	opener.hesapla('amount',<cfoutput>#attributes.row_id#</cfoutput>);<!--- 20041221 yoktu problem cikarsa incelensin --->
	window.close();	
}
	<cfif attributes.rowCount eq 1>
		urun.innerHTML += opener.form_basket.product_name.value + '<b> Miktar:</b> ' + opener.form_basket.amount.value + ' ' + opener.form_basket.unit.value ;
	<cfelse>
		urun.innerHTML += opener.form_basket.product_name[<cfoutput>#(attributes.row_id-1)#</cfoutput>].value + ' Miktar: ' + opener.form_basket.amount[<cfoutput>#(attributes.row_id-1)#</cfoutput>].value + ' ' +  opener.form_basket.unit[<cfoutput>#(attributes.row_id-1)#</cfoutput>].value ;
	</cfif>		
</script>
