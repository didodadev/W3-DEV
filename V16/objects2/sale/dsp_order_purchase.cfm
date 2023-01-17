<cfset order_currency_list= "Açık,Tedarik,Kapatıldı,Kısmi Üretim,Üretim,Sevk,Eksik Teslimat,Fazla Teslimat,İptal">
<cfinclude template="../query/get_order_det.cfm">
<cfif len(get_order_det.deliver_dept_id)>
	<cfquery name="GET_STORE" datasource="#DSN#">
		SELECT 
			DEPARTMENT_ID,
			DEPARTMENT_HEAD 
		FROM 
			DEPARTMENT 
		WHERE 
			DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.deliver_dept_id#">
	</cfquery>
</cfif>
<cfif len(get_order_det.ship_method)>
	<cfquery name="GET_METHOD" datasource="#DSN#">
		SELECT 
			SHIP_METHOD_ID,
			SHIP_METHOD 
		FROM 
			SHIP_METHOD 
		WHERE 
			SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.ship_method#">
	</cfquery>
</cfif>
<cfquery name="GET_ORDER_MONEY" datasource="#DSN3#">
	SELECT 
		IS_SELECTED,
        MONEY_TYPE,
        RATE2
	FROM 
		ORDER_MONEY
	WHERE
		ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND 
		<cfif isdefined("session.pp.money")>
			MONEY_TYPE <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.money#">
		<cfelse>
			MONEY_TYPE <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.money#">
		</cfif>
</cfquery>
<cfquery name="GET_SELECTED_MONEY" datasource="#DSN3#">
	SELECT MONEY_TYPE,RATE2 FROM ORDER_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND IS_SELECTED=1
</cfquery>
<cfquery name="GET_PROCESS" datasource="#DSN#">
	SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.order_stage#">
</cfquery>
<cfform name="sa_order" action="#request.self#?fuseaction=objects2.emptypopup_upd_order_purchase&order_id=#attributes.order_id#" method="post">
	<table style="width:100%">    
  		<tr style="height:30px;">
			<td class="headbold"><cf_get_lang_main no='799.Siparis No'>: <cfoutput>#get_order_det.order_number#</cfoutput></td>
  		</tr>
  		<tr class="color-row" style="height:50px;">
			<td style="vertical-align:top;">
				<table>
					<cfoutput>
                    <tr>
                        <td class="txtbold" style="width:100px;"><cf_get_lang_main no='107.Cari Hesap'></td>
                        <td>: 
                            <cfif isdefined("comp")>#get_order_det_comp.fullname#
                                <cfelse>#get_cons_name.consumer_name#&nbsp;#get_cons_name.consumer_surname#
                            </cfif>
                            <cfif isdefined("get_cons_name.consumer_name")> / 
                                #get_cons_name.consumer_name#&nbsp;#get_cons_name.consumer_surname#
                            <cfelseif isdefined("get_order_det_cons.name")>
                                #get_order_det_cons.name#
                            </cfif>
                        </td>
                        <td class="txtbold" style="width:100px;"><cf_get_lang_main no='1703.Sevk Yöntemi'></td>
                        <td>: <cfif len(get_order_det.ship_method)>#get_method.ship_method#</cfif></td>
                    </tr>
	  				<tr>
						<td class="txtbold">Sipariş Tarihi</td>
						<td>: #dateformat(get_order_det.order_date,'dd/mm/yyyy')#</td>
                        <td class="txtbold" style="vertical-align:top;"><cf_get_lang_main no='1037.Teslim Yeri'></td>
                        <td valign="top" width="300" colspan="2">: #get_order_det.ship_address#</td>
	  				</tr>
	  				<tr>
	  					<td class="txtbold"><cf_get_lang_main no='233.Teslim Tarihi'></td>
						<td>: #dateformat(get_order_det.deliverdate,'dd/mm/yyyy')#</td>
	  				</tr>
                          <tr>
		<td class="txtbold"><cf_get_lang_main no="1447.Süreç"></td>
		<td><cfif attributes.is_product_buton eq 1><cf_workcube_process is_upd='0' select_value='#get_order_det.order_stage#' process_cat_width='125' is_detail='1'></cfif></td>
		<td colspan="2"><cfif attributes.is_product_buton eq 1><cf_workcube_buttons is_upd='1' is_delete='0'></cfif></td>
	  </tr>
	  </cfoutput>
	</table>
	</td>
  </tr>
  <tr>
	<td valign="top">
	<table width="100%"  border="0" cellspacing="1" cellpadding="2">
	  <tr class="color-header" height="20">
		<td clasS="form-title"><cf_get_lang_main no ='245.Ürün'></td>
		<cfif attributes.is_product_stage eq 1><td clasS="form-title" width="90"><cf_get_lang_main no='70.Aşama'></td></cfif>
		<cfif isdefined('attributes.is_product_name2') and attributes.is_product_name2 eq 1><td clasS="form-title" width="200"><cf_get_lang_main no='217.Açıklama'></td></cfif>
		<td width="45" align="right" clasS="form-title" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></td>
		<td clasS="form-title" width="45"><cf_get_lang_main no='224.Birim'></td>
		<td width="70" align="right" class="form-title" style="text-align:right;"><cf_get_lang_main no='226.B Fiyat'></td>
		<td width="70" align="right" class="form-title" style="text-align:right;"><cf_get_lang no ='1233.Döviz Fiyat'></td>
		<td width="70" align="right" class="form-title" style="text-align:right;"><cf_get_lang_main no='265.Döviz'></td>
		<td width="35" align="right" clasS="form-title" style="text-align:right;"><cf_get_lang_main no='227.KDV'></td>
		<td width="80" align="right" clasS="form-title" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></td>
		<td width="70" align="right" clasS="form-title" style="text-align:right;"><cf_get_lang_main no='229.İndirim'><cf_get_lang_main no='80.Toplam'></td> 
		<td width="80" align="right" clasS="form-title" style="text-align:right;" ><cf_get_lang_main no='230.N Toplam'></td>
	  </tr>
	<cfinclude template="../query/show_order_basket.cfm">
	<cfset toplam_indirim = 0>
	<cfoutput query="get_order_row">
	<input type="hidden" name="order_row_id" id="order_row_id" value="#order_row_id#">
	<input type="hidden" name="quantity_after#currentrow#" id="quantity_after#currentrow#" value="#quantity#">
	<cfset row_grosstotal = PRICE * QUANTITY>
	<cfset toplam_indirim = toplam_indirim+(row_grosstotal-NETTOTAL)>
	  <tr class="color-row">
		<td nowrap>#PRODUCT_NAME#</td>
		<cfif attributes.is_product_stage eq 1>
			<td><select name="order_currency#currentrow#" id="order_currency#currentrow#" style="width:90px;" class="box">
					<cfloop from="1" to="#listlen(order_currency_list)#" index="cur_list">
						<option value="#-1*cur_list#"<cfif get_order_row.order_row_currency eq (-1*cur_list)>selected</cfif>>#ListGetAt(order_currency_list,cur_list,",")#</option>
					</cfloop> 
				</select>
			</td>
		</cfif>
		<cfif isdefined('attributes.is_product_name2') and attributes.is_product_name2 eq 1><td width="200"><input type="text" name="product_name2#currentrow#" id="product_name2#currentrow#" value="#product_name2#" class="box" style="width:190px;"></td></cfif>
		<td align="right" style="text-align:right;">
        	<cfsavecontent variable="message">#currentrow#.<cf_get_lang no ='1449.Satırda Miktar Girmelisiniz'>!</cfsavecontent>
            <cfinput type="text" name="quantity#currentrow#" value="#QUANTITY#" required="yes" message="#message#" class="box" style="width:30px;"></td>
		<td>#UNIT#</td>
		<td align="right" style="text-align:right;">#TLFormat(PRICE)#</td>
		<td align="right" style="text-align:right;">#TLFormat(PRICE_OTHER)#</td>
		<td align="right" style="text-align:right;">#OTHER_MONEY#</td>
		<td align="right" style="text-align:right;">#TLFormat(TAX,0)#</td>
		<td align="right" style="text-align:right;">#TLFormat(row_grosstotal)#</td>
		<td align="right" style="text-align:right;">#TLFormat(row_grosstotal-NETTOTAL)#</td>
		<td align="right" style="text-align:right;">#TLFormat(NETTOTAL)#</td>
	  </tr>
	  <tr>
		<cfif isdefined('attributes.is_spect_var_id') and attributes.is_spect_var_id eq 1>
			<td colspan="10">
			<cfif len(SPECT_VAR_ID)>
			  <a href="javascript://" onClick="gizle_goster(spect#SPECT_VAR_ID#);"><b><font color="##FF0000"><cf_get_lang no ='139.Ürün Bileşenleri'></font></b></a>
			  <cfquery name="GET_SPECT" datasource="#dsn3#">
				SELECT
					SPECTS.SPECT_VAR_NAME,
					SPECTS_ROW.AMOUNT_VALUE,
					SPECTS_ROW.PRODUCT_NAME,
					SPECTS_ROW.TOTAL_VALUE,
					SPECTS_ROW.MONEY_CURRENCY,
					SPECTS_ROW.IS_CONFIGURE,
					SPECTS_ROW.DIFF_PRICE,
					SPECTS.PRODUCT_AMOUNT,
					SPECTS.PRODUCT_AMOUNT_CURRENCY,
					SPECTS_ROW.IS_PROPERTY,
					STOCKS.PRODUCT_DETAIL
				FROM
					SPECTS,
					SPECTS_ROW,
					STOCKS
				WHERE
					SPECTS.SPECT_VAR_ID = SPECTS_ROW.SPECT_ID AND
					SPECTS_ROW.SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spect_var_id#"> AND
					SPECTS_ROW.STOCK_ID = STOCKS.STOCK_ID 
			  </cfquery>
			<table style="display:none;" id="spect#SPECT_VAR_ID#">
			  <tr>
				<td>#GET_SPECT.SPECT_VAR_NAME#</td>
				<td width="40" align="right" style="text-align:right;"></td>
			  <tr> 
			<cfloop query='get_spect'>
			  <tr>
				<td>#product_detail#</td>
				<td width="40" align="right" style="text-align:right;">#amount_value#</td>
			  </tr>
			</cfloop>
			</table>
			</td>
		  </tr>
		  </cfif>
		</td>
		</cfif>
	</cfoutput>
	</table>
	<br/>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td valign="top">
			<table>
			  <tr>
				<td colspan="2" class="txtbold"><cf_get_lang no ='1454.Döviz Kurları'></td>
			  </tr>
			<cfoutput query="get_order_money">
			  <tr>
				<td <cfif IS_SELECTED eq 1>class="txtbold"</cfif> width="60">#MONEY_TYPE#</td>
				<td align="right" style="text-align:right;" <cfif IS_SELECTED eq 1>class="txtbold"</cfif>>#TLFormat(RATE2,4)#</td>
			  </tr>
			</cfoutput>
			</table>
		</td>
		<td width="400" align="right" style="text-align:right;">
		<cfoutput>
			<table border="0">
			  <tr>
				<td>&nbsp;</td>
				<td align="right" class="txtbold" style="text-align:right;">
					<cfoutput>#get_selected_money.money_type#</cfoutput>
				</td>
				<td align="right" class="txtbold" style="text-align:right;">
				<cfif isdefined("session.pp.money")>
					<cfoutput>#session.pp.money#</cfoutput>
				<cfelse>
					<cfoutput>#session.ww.money#</cfoutput>
				</cfif>
				</td>
			  </tr>
			  <tr>
				<td class="txtbold" width="100"><cf_get_lang_main no='80.Toplam'></td>
				<cfset doviz_total = get_order_det.grosstotal / get_selected_money.rate2>
				<td width="90" align="right" style="text-align:right;">&nbsp;#TLFormat(doviz_total)#</td>
				<td align="right" style="text-align:right;">&nbsp;#TLFormat(get_order_det.grosstotal)#</td>
			  </tr>
			  <tr>
				<td class="txtbold"><cf_get_lang_main no='231.Toplam KDV'></td>
				<cfset doviz_kdv= get_order_det.taxtotal / get_selected_money.rate2>
				<td align="right" style="text-align:right;">&nbsp;#TLFormat(doviz_kdv)#</td>
				<td align="right" style="text-align:right;">&nbsp;#TLFormat(get_order_det.taxtotal)#</td>
			 </tr>
			  <tr>
				<td class="txtbold"><cf_get_lang_main no='268.Genel Toplam'></td>
				<td align="right" style="text-align:right;">&nbsp;#TLFormat(get_order_det.other_money_value)#</td>
				<td width="90" align="right" style="text-align:right;">&nbsp;#TLFormat(get_order_det.nettotal)#</td>
			 </tr>
			</table>
		</cfoutput>
		</td>
	  </tr>
	</table>
</td>
</tr>
</cfform>
</table>

