<!--- bu sayfanın benzeride detail_invoice_subs da var,...
yaptıgınız genel değişiklikleri ordada yapmanız rica olunur... Ayşenur20060614 --->
<cf_xml_page_edit fuseact="objects.popup_detail_invoice">
<cfset toplam_indirim_miktari = 0 >
<cfinclude template="../query/get_sale_det.cfm">
<cfinclude template="../query/get_invoice_store.cfm">
<cfparam name="attributes.period_id" default=""> 
<cfquery name="GET_CARD" datasource="#dsn2#">
	SELECT
		ACS.CARD_ID
	FROM
		ACCOUNT_CARD ACS
	WHERE
		ACS.ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.invoice_cat#"> 
		AND ACS.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SALE_DET.INVOICE_ID#">
</cfquery>
<cfoutput>
<cfsavecontent variable="right">
	<cfoutput>
		<li><a href="#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=iid&action_id=#GET_SALE_DET.INVOICE_ID#" target="_blank" title="Uyarılar"><i class="icon-bell"></i></a></li>
	</cfoutput>
	<cfif get_module_user(5) and get_sale_det.purchase_sales eq 0>
		<li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invoice.popup_get_contract_comparison&iid=#url.id#','page');" title="<cf_get_lang dictionary_id='58751.Anlaşmalara Uygunluk Kontrolü'>"><i class="icn-md fa fa-handshake-o"></i></a> </li>
	</cfif>
	<cfif GET_CARD.recordcount and isdefined("session.ep.user_level") and get_module_user(22)>
        <li><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_sale_det.invoice_cat#</cfoutput>');" title="<cf_get_lang dictionary_id='59032.Muhasebe Hareketleri'>"><i class="icon-fa fa-table"></i></a></li>
    </cfif>
    <cfif get_earchive_det.recordcount>
    	<li><cf_wrk_earchive_display action_id="#GET_SALE_DET.INVOICE_ID#" action_type="INVOICE" action_date="#get_sale_det.invoice_date#" is_display="1" period_id="#attributes.period_id#"></li>
    </cfif>
	<cfif (GET_SALE_DET.INVOICE_TYPE_CODE eq 'SATIS' or GET_SALE_DET.INVOICE_TYPE_CODE eq 'IADE') and (len(get_sale_det.company_id) and get_sale_det_comp.use_efatura eq 1 and datediff('d',get_sale_det_comp.efatura_date,get_sale_det.invoice_date) gte 0) or (len(get_sale_det.consumer_id) and get_cons_name.use_efatura eq 1 and datediff('d',get_cons_name.efatura_date,get_sale_det.invoice_date) gte 0) > 
		 <li><cfif not isDefined("attributes.ID")>
			<cf_wrk_efatura_display action_id="#attributes.iid#" action_type="INVOICE" is_display="1" period_id="#attributes.period_id#">
		<cfelse>
			<cf_wrk_efatura_display action_id="#attributes.id#" action_type="INVOICE" is_display="1" period_id="#attributes.period_id#">
		</cfif></li>
	</cfif>
	<cfif get_efatura_det.recordcount>
		<cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_dsp_efatura_detail&receiving_detail_id=#get_efatura_det.receiving_detail_id#&type=1','wwide');" class="tableyazi"><img src="../images/icons/efatura_black.gif" alt="<cf_get_lang dictionary_id='57757.Uyarılar'>" title="<cf_get_lang dictionary_id='57757.Uyarılar'>" border="0"></a></cfoutput>
	</cfif>	
</cfsavecontent>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58133.Fatura No'></cfsavecontent>
	<cf_box title='#message#: #get_sale_det.invoice_number#' right_images="#right#" scroll="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"> 
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
				<div class="col col-8 col-md-6 col-xs-12">
					<cfif isdefined("comp")>#get_sale_det_comp.fullname#
					<cfelseif isdefined("get_cons_name")>#get_cons_name.consumer_name##get_cons_name.consumer_surname#
					<cfelseif isdefined("get_emp_name")>#get_emp_name.employee_name##get_emp_name.employee_surname#
				</cfif>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
				<div class="col col-8 col-md-6 col-xs-12">
					<cfif isdefined("get_cons_name.consumer_name")>#get_cons_name.consumer_name##get_cons_name.consumer_surname#
					<cfelseif isdefined("get_sale_det_cons.name")>#get_sale_det_cons.name#
				  </cfif>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'></label>
				<div class="col col-8 col-md-6 col-xs-12">
					<cfif len(get_sale_det.deliver_emp) and get_sale_det.purchase_sales eq 0>
						#get_sale_det_deliver_emp.employee_name# #get_sale_det_deliver_emp.employee_surname#
					<cfelse>
						#get_sale_det.deliver_emp#
					</cfif>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
				<div class="col col-8 col-md-6 col-xs-12">
						<cfif isdefined("get_cons_name")>
							<cf_get_lang dictionary_id='57586.Bireysel Üye'>
						<cfelseif isdefined("comp")>
							<cf_get_lang dictionary_id='57585.Kurumsal Üye'>
						<cfelse>
							<cf_get_lang dictionary_id='57576.Çalışan'>
						</cfif>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>	
					<div class="col col-8 col-md-6 col-xs-12">
						<cfif isdefined("get_cons_name")>
						#get_cons_name.tax_adress#
					  <cfelseif isdefined("comp")>
						#get_sale_det_comp.taxoffice#
					</cfif>	
			</div>
		</div>
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57752.Vergi No'></label>
				<div class="col col-8 col-md-6 col-xs-12">
					<cfif isdefined("get_cons_name")>
						#get_cons_name.tax_no#
					<cfelseif isdefined("comp")>
						#get_sale_det_comp.taxno#
					</cfif>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
				<div class="col col-8 col-md-6 col-xs-12">
					<cfif len(get_sale_det.PAY_METHOD)>
						#get_method2.paymethod#
					<cfelseif len(get_sale_det.CARD_PAYMETHOD_ID)>
						#get_method_card.CARD_NO#
					</cfif>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58851.Ödeme Tarihi'></label>
				<div class="col col-8 col-md-6 col-xs-12">
					<cfif len(get_sale_det.DUE_DATE)>
						#dateformat(get_sale_det.due_date,dateformat_style)#
					</cfif>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
				<div class="col col-8 col-md-6 col-xs-12">
					<cfif isdefined("get_cons_name")><!--- Bireysel Uye Fatura Adr. --->
						#get_cons_name.tax_adress# #get_cons_name.tax_semt# #get_cons_name.tax_postcode#<br/>
					<cfif len(get_cons_name.tax_county_id)>
						<cfquery name="GET_COUNTY" datasource="#DSN#">
							SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_cons_name.tax_county_id#
						</cfquery>
						#get_county.county_name#			  
					</cfif>
					<cfif len(get_cons_name.tax_city_id)>
						<cfquery name="GET_CITY" datasource="#DSN#">
							SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_cons_name.tax_city_id#
						</cfquery>
						#get_city.city_name#
					</cfif>
					<cfif len(get_cons_name.tax_country_id)>
						<cfquery name="GET_COUNTRY" datasource="#DSN#">
							SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID =  #get_cons_name.tax_country_id#
						</cfquery>					  
						#get_country.country_name#
					</cfif>
					<cfelseif isdefined("get_sale_det_comp")><!--- Kurumsal Uye Adr. --->
						<!--- #get_sale_det_comp.company_address# #get_sale_det_comp.semt# #get_sale_det_comp.company_postcode#<br/> --->
						#get_sale_det.SHIP_ADDRESS#<br />
					<!--- <cfif len(get_sale_det_comp.county)>
						<cfquery name="GET_COUNTY" datasource="#DSN#">
							SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_sale_det_comp.county#
						</cfquery>
						#get_county.county_name#			  
					</cfif>
					<cfif len(get_sale_det_comp.city)>
						<cfquery name="GET_CITY" datasource="#DSN#">
							SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_sale_det_comp.city#
						</cfquery>
						#get_city.city_name#
					</cfif>
					<cfif len(get_sale_det_comp.country)>
						<cfquery name="GET_COUNTRY" datasource="#DSN#">
							SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID =  #get_sale_det_comp.country#
						</cfquery>					  
						#get_country.country_name#
					</cfif> --->
				</cfif>		
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
				<div class="col col-8 col-md-6 col-xs-12">
					 #get_sale_det.note#
					<cfquery name="control_hobim" datasource="#dsn2#">
						SELECT 
							IM.HOBIM_ID,
							I.INVOICE_ID,
							FE.IS_IPTAL,
							FE.IS_PRINTED,
							FE.IS_SENT,
							FE.RECORD_DATE
						FROM 
							INVOICE_MULTI IM
							RIGHT JOIN INVOICE I ON I.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID
							RIGHT JOIN FILE_EXPORTS FE ON FE.E_ID = IM.HOBIM_ID
						WHERE 
							I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SALE_DET.INVOICE_ID#">
					</cfquery>
				</div>
			</div>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
		<div class="form-group">
			<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				<cfswitch expression="#get_sale_det.invoice_cat#">
					<cfcase value="690,691,29,37"><cf_get_lang dictionary_id='57816.Gider Pusulası'></cfcase>
					<cfcase value="50"><cf_get_lang dictionary_id='32756.Verilen Vade Farki Faturası'></cfcase>
					<cfcase value="51"><cf_get_lang dictionary_id='57763.Alınan Vade Farki Faturası'></cfcase>
					<cfcase value="52"><cf_get_lang dictionary_id='57765.Perakende Satış Faturası'></cfcase>
					<cfcase value="53"><cf_get_lang dictionary_id='57825.Toptan Satış Faturası'></cfcase>
					<cfcase value="54"><cf_get_lang dictionary_id='57824.Parekende Satis Iade Faturasi'></cfcase>
					<cfcase value="55"><cf_get_lang dictionary_id='32950.Toptan Satış Iade Faturası'></cfcase>
					<cfcase value="56"><cf_get_lang dictionary_id='57829.Verilen Hizmet Faturası'></cfcase>
					<cfcase value="57"><cf_get_lang dictionary_id='57770.Verilen Proforma Faturası'></cfcase>
					<cfcase value="58"><cf_get_lang dictionary_id='57830.Verilen Fiyat Farkı Faturası'></cfcase>
					<cfcase value="59"><cf_get_lang dictionary_id='57822.Mal Alım Faturası'></cfcase>
					<cfcase value="60"><cf_get_lang dictionary_id='32955.Alınan Hizmet Faturası'></cfcase>
					<cfcase value="61"><cf_get_lang dictionary_id='57814.Alınan Proforma Faturası'></cfcase>
					<cfcase value="62"><cf_get_lang dictionary_id='57815.Alım Iade Fatura'></cfcase>
					<cfcase value="63"><cf_get_lang dictionary_id='57811.Alınan Fiyat Farkı Faturası'></cfcase>
					<cfcase value="64"><cf_get_lang dictionary_id='57823.Müstahsil Makbuzu'></cfcase>
					<cfcase value="68"><cf_get_lang dictionary_id='29577.Serbest Meslek Makbuzu'></cfcase>
					<cfcase value="65"><cf_get_lang dictionary_id='33604.Sabit Kıymet Alış Faturası'></cfcase>
					<cfcase value="66"><cf_get_lang dictionary_id='58758.Sabit Kıymet Satış Faturası'></cfcase>
				</cfswitch>
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57773.İrsaliye'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				<cfquery name="get_invoice_ship" datasource="#dsn2#">
					SELECT SHIP_NUMBER,SHIP_ID FROM INVOICE_SHIPS WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SALE_DET.INVOICE_ID#">
				</cfquery>
				<cfif not len(get_invoice_ship.ship_number)>
					<cf_get_lang dictionary_id='57774.İrsaliye Yok'>
				<cfelse>
					#ValueList(get_invoice_ship.ship_number)#
				</cfif>
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58133.Fatura No'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				#get_sale_det.invoice_number#
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58759.Fatura Tarihi'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				#dateformat(get_sale_det.invoice_date,dateformat_style)#
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id ='34125.Satışı Yapan'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				#get_emp_info(get_sale_det.sale_emp,0,0,0)#
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58211.Sipariş No'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				<cfquery name="get_order" datasource="#dsn3#">
					SELECT 
						O.ORDER_ID,
						O.ORDER_NUMBER 
					FROM 
						ORDERS_INVOICE OI,
						ORDERS O
					WHERE
						OI.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SALE_DET.INVOICE_ID#"> 
						AND O.ORDER_ID = OI.ORDER_ID
						AND PERIOD_ID= <cfqueryparam value="#session.ep.period_id#" cfsqltype="cf_sql_integer"> 
				</cfquery>
				<cfif not len(get_order.order_number)>
					<cf_get_lang dictionary_id ='34126.Sipariş yok'>
				<cfelse>
					<cfloop query="get_order">
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_order&order_id=#get_order.order_id#','page');" class="tableyazi">#get_order.order_number#</a>
					</cfloop>
				</cfif>
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				<cfif len(get_sale_det.SHIP_METHOD)>
					#get_method.ship_method#
				</cfif>
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				<cfif len(GET_SALE_DET.DEPARTMENT_ID)>
					#get_store.department_head#
				</cfif>
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				<cfif len(get_sale_det.project_id)>#GET_PROJECT_NAME(get_sale_det.project_id)#</cfif>
			</div>
		</div>
		<cfif control_hobim.recordcount>
		<div class="form-group">
			<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57092.Hobim ID'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				<font color="FF0000">
					<cfif control_hobim.is_printed eq 1>
						#control_hobim.hobim_id# / Tarih :<cfoutput>#dateformat(control_hobim.record_date,dateformat_style)#</cfoutput> / <cf_get_lang dictionary_id='57097.Basıldı'>
					<cfelse>
						#control_hobim.hobim_id# / Tarih :<cfoutput>#dateformat(control_hobim.record_date,dateformat_style)#</cfoutput> / <cfif control_hobim.is_printed eq 1><cf_get_lang dictionary_id='57097.Basıldı'><cfelseif control_hobim.is_sent eq 1><cf_get_lang dictionary_id='40102.Gönderildi'></cfif>
					</cfif> 
				   </font>
			</div>
		</div>
	</cfif>
	</div>
		<div class="form-group"></div>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="200"><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<cfif xml_deliver_dept eq 1>
						<th><cf_get_lang dictionary_id='57646.Teslim Depo'></th>
					</cfif>
					<th width="45" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th width="45"><cf_get_lang dictionary_id='57636.Birim'></th>
					<th width="70" style="text-align:right;"><cf_get_lang dictionary_id='57638.B Fiyat'></th>
					<th width="35" style="text-align:right;"><cf_get_lang dictionary_id='57639.KDV'></th>
					<th width="70"><cf_get_lang dictionary_id='57641.İndirim'><cf_get_lang dictionary_id='57492.Toplam'></th> 
					<th width="80" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></th>
					<th width="90" style="text-align:right;"><cf_get_lang dictionary_id ='57677.Döviz'></th> 
					<th width="80" style="text-align:right;"><cf_get_lang dictionary_id='57642.Net Toplam'></th>
				</tr>
			</thead>
			<tbody>
				<cfinclude template="../query/show_sales_basket.cfm">
				<cfset toplam_indirim_miktari=0>
				<cfset list_kdv = ListSort(list_kdv,"textnocase", "asc")>
				<cfloop from="1" to="#arraylen(invoice_bill_upd)#" index="i">
				  <tr>
			   <cfif not listfind("65,66",get_sale_det.invoice_cat,',')><!--- Demirbaş faturalarında stok olmadığı için detail olarak satırdaki açıklama getirildi --->
					<td nowrap="nowrap">
                    	<div class="nohover_div">
                            <table width="100%">
                                <tr>
                                    <td>#invoice_bill_upd[i][2]#</td>
                                    <cfif get_module_user(5)>
                                        <td style="text-align:right;">
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#invoice_bill_upd[i][1]#&sid=#invoice_bill_upd[i][10]#<cfif isdefined("attributes.is_store_module")>&is_store_module=1</cfif>','medium');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='58764.Ürün Detayları'>" border="0" align="absmiddle"></a>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_std_sale&price_type=purc&pid=#invoice_bill_upd[i][1]#','list');"><img src="/images/plus_thin_p.gif" title="<cf_get_lang dictionary_id ='57721.Ürün Fiyat Tarihçe'>" border="0" align="absmiddle"></a>
                                        </td>
                                    </cfif>
                                </tr>
                             </table>
                         </div>
                     </td>
				<cfelse>
					<td>#invoice_bill_upd[i][2]#</td>
				</cfif>
				 <cfif xml_deliver_dept eq 1>
					<td>
						<cfif listlen(listfirst(invoice_bill_upd[i][32],'-'))>
							<cfset attributes.department_id = listfirst(invoice_bill_upd[i][32],'-')>  <!--- listgetat(invoice_bill_upd[i][32],1,'-') --->
							<cfinclude template="../query/get_department.cfm">
							<cfset department_head = get_department.DEPARTMENT_HEAD>
							<cfset attributes.department_location = invoice_bill_upd[i][32]>
							<cfinclude template="../query/get_department_location.cfm">
							<cfset department_head = "#department_head#-#get_department_location.comment#">
							#department_head#
						</cfif>
					</td>
					</cfif>
					<td style="text-align:right;">#invoice_bill_upd[i][4]#</td>
					<td>#invoice_bill_upd[i][5]#</td>
					<td style="text-align:right;">#TLFormat(invoice_bill_upd[i][6],4)#</td>
					<td style="text-align:right;">#invoice_bill_upd[i][7]#</td>
					<td style="text-align:right;">#TLFormat(invoice_bill_upd[i][8],4)#
						 <cfif not len(invoice_bill_upd[i][8])><cfset invoice_bill_upd[i][8]=0></cfif>
						 <cfset toplam_indirim_miktari = toplam_indirim_miktari+invoice_bill_upd[i][8]>
					</td>
					<td style="text-align:right;">#TLFormat(invoice_bill_upd[i][15],4)#</td>
					<td style="text-align:right;">#TLFormat(invoice_bill_upd[i][30],4)#&nbsp;<cfif len(session.ep.money2)>#invoice_bill_upd[i][31]#</cfif></td>
					<td style="text-align:right;">#TLFormat(invoice_bill_upd[i][16],4)#</td>
				  </tr>
				</cfloop>
			 </tbody>
		</cf_grid_list>
		<div class="ui-row">
			<div id="sepetim_total" class="padding-0">
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
					<div class="totalBox">
						<div class="totalBoxHead font-grey-mint">
							<span class="headText"> Döviz </span>
							<div class="collapse">
								<span class="icon-minus"></span>
							</div>
						</div>
						<div class="totalBoxBody" style="display: block;">
						<input type="hidden" id="kur_say" name="kur_say" value="4">
								<table cellspacing="0" id="money_rate_table">
									<tbody>
										<cfloop query="GET_MONEY_INFO_SEC">
										<tr>
									<input type="hidden" id="hidden_rd_money_1" name="hidden_rd_money_1" value="TL">
									<input type="hidden" id="txt_rate1_1" name="txt_rate1_1" value="1,00">
									<td nowrap="nowrap"><input type="radio" class="rdMoney" id="rd_money" name="rd_money" <cfif GET_SALE_DET.OTHER_MONEY eq MONEY_TYPE>checked="checked"<cfelse>disabled="disabled"</cfif> ></td>
									<td nowrap="nowrap">#MONEY_TYPE#</td>
									<td nowrap="nowrap">1/</td>
									<td nowrap="nowrap"><input disabled="disabled" type="text" id="txt_rate2_1" name="txt_rate2_1" value="#TLFormat(RATE2,session.ep.our_company_info.rate_round_num)#" style="width:100%;" class="box"></td>
									</tr>	
								</cfloop>		
								</tbody></table>
						</div>
					</div>
				</div>
				<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
					<div class="totalBox">
						<div class="totalBoxHead font-grey-mint">
							<span class="headText"> <cf_get_lang dictionary_id='57492.Toplam'> </span>
							<div class="collapse">
								<span class="icon-minus"></span>
							</div>
						</div>
						<div class="totalBoxBody">       
							<table>
								<tbody><tr>
									<td width="100" class="txtbold"> <cf_get_lang dictionary_id='57492.Toplam'> </td>
									<td width="75" id="total_default" style="text-align:right;" name="total_default">#TLFormat(get_sale_det.grosstotal,4)#</td>
									<td width="75" id="total_wanted" style="text-align:right;" name="total_wanted">#TLFormat(get_sale_det.grosstotal/GET_MONEY_INFO.rate2,4)#
										<cfset toplam = get_sale_det.grosstotal/GET_MONEY_INFO.rate2></td>
								</tr>

								<tr> <cfif not len(get_sale_det.SA_DISCOUNT)><cfset get_sale_det.SA_DISCOUNT = 0></cfif>
									<td class="txtbold"><cf_get_lang dictionary_id='57649.Toplam İndirim'> </td>
									<td width="75" id="total_discount_default" style="text-align:right;" name="total_discount_default">#TLFormat(toplam_indirim_miktari+get_sale_det.SA_DISCOUNT,4)#</td>
									<td width="75" id="total_discount_wanted" style="text-align:right;" name="total_discount_wanted">
										<cfset doviz_indirim = (toplam_indirim_miktari+get_sale_det.SA_DISCOUNT)/GET_MONEY_INFO.RATE2>
										#TLFormat(doviz_indirim,4)#</td>
								</tr>

								<tr> 
									<td class="txtbold"><cf_get_lang dictionary_id='58765.Satıraltı İndirim'>  </td>
									<td width="75" id="total_discount_default" style="text-align:right;" name="total_discount_default">#TLFormat(get_sale_det.SA_DISCOUNT,4)#</td>
									<td width="75" id="total_discount_wanted" style="text-align:right;" name="total_discount_wanted"></td>
									<cfset satiralti = get_sale_det.SA_DISCOUNT>
								</tr>
								
								<tr> 
									<td class="txtbold"> <cf_get_lang dictionary_id='57710.Yuvarlama'> </td>
									<td width="75" id="brut_total_default" style="text-align:right;" name="total_discount_default">#TLFormat(get_sale_det.ROUND_MONEY,4)#</td>
									<td width="75" id="brut_total_wanted" style="text-align:right;" name="total_discount_wanted"></td>
								</tr>
								<tr> 
									<td class="txtbold"> <cf_get_lang dictionary_id = "48334.Ara toplam">(<cf_get_lang dictionary_id="30024.KDVsiz"> <cf_get_lang dictionary_id="57492.Toplam">) </td>
									<td id="total_tax_default" style="text-align:right;" name="total_tax_default">#TLFormat(toplam-doviz_indirim-satiralti,4 )#</td>
									<td id="total_tax_wanted" style="text-align:right;" name="total_tax_wanted"></td>
								</tr>
								
								<tr> 
									<cfif (GET_SALE_DET.NETTOTAL-GET_SALE_DET.TAXTOTAL+GET_SALE_DET.SA_DISCOUNT) neq 0>
									<cfset kdvcarpan = 1-(GET_SALE_DET.SA_DISCOUNT/(GET_SALE_DET.NETTOTAL-GET_SALE_DET.TAXTOTAL+GET_SALE_DET.SA_DISCOUNT))>
									<cfelse>
									<cfset kdvcarpan = 1>
									</cfif>
									<cfloop from="1" to="#arraylen(sepet.kdv_array)#" index="m">
									<td class="txtbold"> <cf_get_lang dictionary_id='57639.KDV'> % #sepet.kdv_array[m][1]#</td>
									<td id="total_otv_default" style="text-align:right;" name="total_otv_default">#TLFormat(sepet.kdv_array[m][2]*kdvcarpan,4)#</td>
									<td id="total_otv_wanted" style="text-align:right;" name="total_otv_wanted"></td>
								</cfloop>
								</tr>
								
								<tr height="20">
									<td class="txtbold"><cf_get_lang dictionary_id='57643.Toplam KDV'></td>
										<td id="net_total_default" style="text-align:right;" name="net_total_default">#TLFormat(get_sale_det.taxtotal,4)#</td>
										<td id="net_total_wanted" style="text-align:right;" name="net_total_wanted">
											<cfset doviz_toplamkdv = get_sale_det.taxtotal/GET_MONEY_INFO.RATE2>
											#TLFormat(doviz_toplamkdv,4)#</td>
								</tr>
								
								<tr height="20"> 
								</tr><tr> 
									<td class="txtbold"><cf_get_lang dictionary_id='57680.Genel Toplam'>  </td>
									<td id="net_total_default" style="text-align:right;" name="net_total_default">#TLFormat(get_sale_det.nettotal,4)#</td>
									<td id="net_total_wanted" style="text-align:right;" name="net_total_wanted">
										<cfset doviz_tutar = get_sale_det.nettotal/GET_MONEY_INFO.RATE2>
										#TLFormat(doviz_tutar,4)#</td>
								</tr>
							</tbody></table>            
						</div>
					</div>
				</div>
			</div>
		</div>
		<cf_box_footer>
			<cf_record_info query_name="get_sale_det">
		</cf_box_footer>
	</cf_box>
</cfoutput>
<script>
$('#efatura_display img').css("margin-top", "-6px");
</script>