<cfparam name="attributes.module_id_control" default="13">
<cfsetting showdebugoutput="yes">
<cfinclude template="report_authority_control.cfm">
<cf_xml_page_edit fuseact="report.ship_dispatch_report">
<script type="text/javascript">
	function sayfa_ac(x,y)
	{
		document.report_special.procat.value=x;	
		document.report_special.hier.value=y;
		document.report_special.submit();
	}
</script>
<cfparam name="attributes.product_cat2" default="">
<cfparam name="attributes.product_catid2" default="">
<cfparam name="attributes.stock_name" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.is_excel" default="">
<cfif not isdefined("attributes.form_varmi")>
	<cfparam name="attributes.store_loc" default="0">
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="20">
<cfparam name="attributes.startdate" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.finishdate" default="#dateformat(now(),dateformat_style)#">
<cfif len(attributes.startdate) is 0>
	<cfset attributes.startdate = dateformat(now(),dateformat_style)>
</cfif>
<cfif len(attributes.finishdate) is 0>
	<cfset attributes.finishdate = dateformat(now(),dateformat_style)>
</cfif>
<cf_date tarih='attributes.finishdate'>
<cf_date tarih='attributes.startdate'>
<cfquery name="STORES" datasource="#DSN#">
	SELECT
		D.DEPARTMENT_ID,
        D.DEPARTMENT_HEAD
	FROM
		DEPARTMENT D
	WHERE 
		D.IS_STORE <> 2 
		<cfif x_show_pasive_departments eq 0>
           AND D.DEPARTMENT_STATUS = 1 
        </cfif>
		<cfif isDefined("get_offer_detail.deliver_place") and len(get_offer_detail.deliver_place)>
			AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer_detail.deliver_place#">
		</cfif>
		<cfif isDefined("get_order_detail.ship_address") and len(get_order_detail.ship_address) and isnumeric(get_order_detail.ship_address)>
			AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.ship_address#">
		</cfif>
		AND BRANCH_ID IN (SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">)
	ORDER BY
		D.DEPARTMENT_HEAD
</cfquery>
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT DEPARTMENT_ID, LOCATION_ID, COMMENT FROM STOCKS_LOCATION <cfif x_show_pasive_departments eq 0>WHERE STATUS = 1</cfif>
</cfquery>

<cfset kdv_haric_toplam = 0>
<cfset kdv_dahil_toplam = 0>

<cfquery name="GET_PRODUCT_UNITS" datasource="#DSN#">
	SELECT UNIT FROM SETUP_UNIT
</cfquery>
<cfoutput query="get_product_units">
	<cfset unit_ = filterSpecialChars(get_product_units.unit)>
	<cfset 'toplam_#unit_#' = 0>
</cfoutput>
<cfif isdefined("attributes.form_varmi")>
	<cfquery name="SEARCH_RESULTS" datasource="#DSN2#">
		SELECT
			D.DEPARTMENT_HEAD AS GIRIS_DEPO,
			D2.DEPARTMENT_HEAD AS CIKIS_DEPO,
			L.COMMENT AS GIRIS_LOKASYON,
			L2.COMMENT AS CIKIS_LOKASYON,
			SI.SHIP_NUMBER NUMBER,
			SI.SHIP_DATE S_DATE,
			SUBSTRING(SI.SHIP_DETAIL,1,50) S_DETAIL,
			P.PRODUCT_NAME,
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			P.PRODUCT_ID,
			SIR.UNIT UNIT,
			SIR.TAX TAX,
			SIR.AMOUNT AMOUNT,
            SIR.WRK_ROW_ID,
			SIR.PRICE PRICE,
			S.STOCK_CODE,
            P.PRODUCT_ID,
            (SELECT PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = P.PRODUCT_ID) AS MULTIPLIER_AMOUNT,
		   (((AMOUNT*PRICE)/100000000000000000000)*((100-DISCOUNT)*(100-DISCOUNT2)*(100-DISCOUNT3)*(100-DISCOUNT4)*(100-DISCOUNT5)*(100-DISCOUNT6)*(100-DISCOUNT7)*(100-DISCOUNT8)*(100-DISCOUNT9)*(100-DISCOUNT10))) AS ROW_NETTOTAL
		FROM
			SHIP_ROW SIR,
			SHIP SI,
			#dsn_alias#.DEPARTMENT D,
			#dsn_alias#.DEPARTMENT D2,
			#dsn_alias#.STOCKS_LOCATION L,
			#dsn_alias#.STOCKS_LOCATION L2,
			#dsn3_alias#.PRODUCT P,
			#dsn1_alias#.PRODUCT_CAT PC,
			#dsn3_alias#.STOCKS S
		WHERE
			<cfif len(attributes.stock_name) gt 0 and len(attributes.stock_id) gt 0>SIR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND</cfif>
			<cfif isdate(attributes.startdate) and isdate(attributes.finishdate)>(SI.SHIP_DATE BETWEEN #attributes.startdate# AND #attributes.finishdate#) AND</cfif>
			<cfif len(attributes.product_catid2) gt 0 and len(attributes.product_cat2) gt 0>PC.PRODUCT_CATID IN (SELECT PRODUCT_CATID FROM #dsn3_alias#.PRODUCT_CAT WHERE HIERARCHY LIKE (SELECT HIERARCHY FROM #dsn3_alias#.PRODUCT_CAT WHERE PRODUCT_CATID = #attributes.product_catid2#) + '%') AND</cfif>
			<cfif isdefined('attributes.type') and len(attributes.type)>SI.SHIP_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type#"> AND</cfif>
			<cfif isdefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_head)>SI.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND</cfif>
			SI.SHIP_TYPE = 81
			AND SIR.SHIP_ID = SI.SHIP_ID
			AND SI.IS_SHIP_IPTAL = 0
			AND PC.PRODUCT_CATID = P.PRODUCT_CATID
			AND SIR.PRODUCT_ID = P.PRODUCT_ID
			AND SIR.STOCK_ID = S.STOCK_ID
			AND D.DEPARTMENT_ID = SI.DEPARTMENT_IN
			AND D2.DEPARTMENT_ID = SI.DELIVER_STORE_ID
			AND D.DEPARTMENT_ID = L.DEPARTMENT_ID 
			AND L.LOCATION_ID = SI.LOCATION_IN
			AND D2.DEPARTMENT_ID = L2.DEPARTMENT_ID 
			AND L2.LOCATION_ID = SI.LOCATION
			<cfif isdefined('attributes.department_in') and len(attributes.department_in)>
				<cfif listlen(attributes.department_in,'-') eq 1>
					AND SI.DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_in#">
				<cfelse>
					AND SI.DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.department_in,'-')#"> 
                    AND SI.LOCATION_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.department_in,'-')#">
				</cfif>		
			</cfif>
			<cfif isdefined('attributes.department_out') and len(attributes.department_out)>
				<cfif listlen(attributes.department_out,'-') eq 1>
					AND SI.DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_out#">
				<cfelse>
					AND SI.DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.department_out,'-')#"> 
                    AND SI.LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.department_out,'-')#">
				</cfif>		
			</cfif>
		GROUP BY
			D.DEPARTMENT_HEAD,
			D2.DEPARTMENT_HEAD,
			L.COMMENT,
			S.STOCK_CODE,
			L2.COMMENT,
			SIR.AMOUNT,
            SIR.WRK_ROW_ID,
			SIR.PRICE,
			SIR.DISCOUNT,
			SIR.DISCOUNT2,
			SIR.DISCOUNT3,
			SIR.DISCOUNT4,
			SIR.DISCOUNT5,
			SIR.DISCOUNT6,
			SIR.DISCOUNT7,
			SIR.DISCOUNT8,
			SIR.DISCOUNT9,
			SIR.DISCOUNT10,
			SIR.TAX,
			SI.NETTOTAL,
			SI.SHIP_NUMBER,
			SI.SHIP_DATE,
			SUBSTRING(SI.SHIP_DETAIL,1,50),
			P.PRODUCT_NAME,
			P.PRODUCT_ID,
			SIR.UNIT,
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
            P.PRODUCT_ID
	UNION
	SELECT
			D.DEPARTMENT_HEAD AS GIRIS_DEPO,
			D2.DEPARTMENT_HEAD AS CIKIS_DEPO,
			L.COMMENT AS GIRIS_LOKASYON,
			L2.COMMENT AS CIKIS_LOKASYON,
			SFI.FIS_NUMBER NUMBER,
			SFI.FIS_DATE S_DATE,
			SUBSTRING(SFI.FIS_DETAIL,1,50) S_DETAIL,
			P.PRODUCT_NAME,
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			P.PRODUCT_ID,
			SFIR.UNIT UNIT,
			SFIR.TAX TAX,
			SFIR.AMOUNT AMOUNT,
            SFIR.WRK_ROW_ID,
			SFIR.PRICE PRICE,
			S.STOCK_CODE,
            P.PRODUCT_ID,
            (SELECT PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = P.PRODUCT_ID) AS MULTIPLIER_AMOUNT,
		   (((AMOUNT*PRICE)/10000000000)*((100-DISCOUNT1)*(100-DISCOUNT2)*(100-DISCOUNT3)*(100-DISCOUNT4)*(100-DISCOUNT5))) AS ROW_NETTOTAL
		FROM
			STOCK_FIS_ROW SFIR,
			STOCK_FIS SFI,
			#dsn_alias#.DEPARTMENT D,
			#dsn_alias#.DEPARTMENT D2,
			#dsn_alias#.STOCKS_LOCATION L,
			#dsn_alias#.STOCKS_LOCATION L2,
			#dsn3_alias#.PRODUCT P,
			#dsn1_alias#.PRODUCT_CAT PC,
			#dsn3_alias#.STOCKS S
		WHERE
			<cfif len(attributes.stock_name) gt 0 and len(attributes.stock_id) gt 0>SFIR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND</cfif>
			<cfif isdate(attributes.startdate) and isdate(attributes.finishdate)>(SFI.FIS_DATE BETWEEN #attributes.startdate# AND #attributes.finishdate#) AND</cfif>
			<cfif len(attributes.product_catid2) gt 0 and len(attributes.product_cat2) gt 0>PC.PRODUCT_CATID IN (SELECT PRODUCT_CATID FROM #dsn3_alias#.PRODUCT_CAT WHERE HIERARCHY LIKE (SELECT HIERARCHY FROM #dsn3_alias#.PRODUCT_CAT WHERE PRODUCT_CATID = #attributes.product_catid2#) + '%') AND</cfif>
			<cfif isdefined('attributes.type') and len(attributes.type)>SFI.FIS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type#"> AND</cfif>
			<cfif isdefined('attributes.project_id') and  len(attributes.project_id) and len(attributes.project_head)>SFI.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND</cfif>
			SFI.FIS_TYPE = 113
			AND SFIR.FIS_ID = SFI.FIS_ID
			AND PC.PRODUCT_CATID = P.PRODUCT_CATID
			AND S.PRODUCT_ID = P.PRODUCT_ID
			AND SFIR.STOCK_ID = S.STOCK_ID
			AND D.DEPARTMENT_ID = SFI.DEPARTMENT_IN
			AND D2.DEPARTMENT_ID = SFI.DEPARTMENT_OUT
			AND D.DEPARTMENT_ID = L.DEPARTMENT_ID
			AND L.LOCATION_ID = SFI.LOCATION_IN
			AND D2.DEPARTMENT_ID = L2.DEPARTMENT_ID
			AND L2.LOCATION_ID = SFI.LOCATION_OUT
			<cfif isdefined('attributes.department_in') and len(attributes.department_in)>
				<cfif listlen(attributes.department_in,'-') eq 1>
					AND SFI.DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_in#">
				<cfelse>
					AND SFI.DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.department_in,'-')#"> 
                    AND SFI.LOCATION_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.department_in,'-')#">
				</cfif>		
			</cfif>
			<cfif isdefined('attributes.department_out') and len(attributes.department_out)>
				<cfif listlen(attributes.department_out,'-') eq 1>
					AND SFI.DEPARTMENT_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_out#">
				<cfelse>
					AND SFI.DEPARTMENT_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.department_out,'-')#"> 
                    AND SFI.LOCATION_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.department_out,'-')#">
				</cfif>		
			</cfif>
		GROUP BY
			D.DEPARTMENT_HEAD,
			D2.DEPARTMENT_HEAD,
			L.COMMENT,
			S.STOCK_CODE,
			L2.COMMENT,
			SFIR.AMOUNT,
            SFIR.WRK_ROW_ID,
			SFIR.PRICE,
			SFIR.DISCOUNT1,
			SFIR.DISCOUNT2,
			SFIR.DISCOUNT3,
			SFIR.DISCOUNT4,
			SFIR.DISCOUNT5,
			SFIR.TAX,
			SFI.FIS_NUMBER,
			SFI.FIS_DATE,
			SUBSTRING(SFI.FIS_DETAIL,1,50),
			P.PRODUCT_NAME,
			P.PRODUCT_ID,
			SFIR.UNIT,
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
            P.PRODUCT_ID	
		ORDER BY
			S_DATE
	</cfquery>
</cfif>
<cfset toplam_multiplier = 0>
<cfform name="report_special" action="#request.self#?fuseaction=#fusebox.circuit#.ship_dispatch_report" method="post">
	<cf_report_list_search title="#getLang('report',710)#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="col col-12 col-md-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang_main no='74.Kategori'></label>
											<div class="col col-12">
												<div class="input-group">
													<input type="hidden" name="product_catid2" id="product_catid2" value="<cfif len(attributes.product_cat2)><cfoutput>#attributes.product_catid2#</cfoutput></cfif>">
													<input type="text" name="product_cat2" id="product_cat2" style="width:150px;" value="<cfif len(attributes.product_cat2)><cfoutput>#attributes.product_cat2#</cfoutput></cfif>" onFocus="AutoComplete_Create('product_cat2','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_catid2','','3','200');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=report_special.product_catid2&field_name=report_special.product_cat2</cfoutput>&keyword='+encodeURIComponent(document.report_special.product_cat2.value));"></span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang_main no='245.Ürün'></label>
											<div class="col col-12">
												<div class="input-group">
													<input type="hidden" name="stock_id" id="stock_id" <cfif len(attributes.stock_name)>value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
													<input type="text" name="stock_name" id="stock_name" style="width:150px;" value="<cfoutput>#attributes.stock_name#</cfoutput>"  onFocus="AutoComplete_Create('stock_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID','stock_id','','3','225');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=report_special.stock_id&field_name=report_special.stock_name','list');"></span>			
												</div>	
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
											<div class="col col-12">
												<div class="input-group">
													<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
												<input type="text" name="project_head" id="project_head" style="width:150px;" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=report_special.project_id&project_head=report_special.project_head');"></span>     
												</div>	      
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-3 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="col col-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang no='691.Giriş Depo'></label>
											<div class="col col-12">
												<select name="department_in" id="department_in">
													<option value=""><cf_get_lang no='487.Tüm Depolar'></option>
													<cfoutput query="stores">
														<option value="#department_id#"<cfif isdefined('attributes.department_in') and attributes.department_in eq department_id>selected</cfif>>#department_head#</option>
														<cfquery name="GET_LOCATION" dbtype="query">
															SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stores.department_id[currentrow]#">
														</cfquery>		 
														<cfif get_location.recordcount>
														<cfloop from="1" to="#get_location.recordcount#" index="s">
															<option value="#department_id#-#get_location.location_id[s]#" <cfif isdefined('attributes.department_in') and attributes.department_in eq '#department_id#-#get_location.location_id[s]#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#get_location.comment[s]#</option>
														</cfloop>
														</cfif>	
													</cfoutput>
												</select>		
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang_main no='1631.Çıkış Depo'></label>
											<div class="col col-12">
												<select name="department_out" id="department_out">
													<option value=""><cf_get_lang no='487.Tüm Depolar'></option>
													<cfoutput query="stores">
														<option value="#department_id#"<cfif isdefined('attributes.department_out') and attributes.department_out eq department_id>selected</cfif>>#department_head#</option>
														<cfquery name="GET_LOCATION" dbtype="query">
															SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stores.department_id[currentrow]#">
														</cfquery>		 
														<cfif get_location.recordcount>
															<cfloop from="1" to="#get_location.recordcount#" index="s">
																<option value="#department_id#-#get_location.location_id[s]#" <cfif isdefined('attributes.department_out') and attributes.department_out eq '#department_id#-#get_location.location_id[s]#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#get_location.comment[s]#</option>
															</cfloop>
														</cfif>	
													</cfoutput>
												</select>
											</div>
										</div>
								    </div>
								</div>
							</div>
							<div class="col col-4 col-md-3 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="col col-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang_main no='1278.Tarih Aralığı'></label>
											<div class="col col-6">
												<div class="input-group">
													<cfsavecontent variable="message1"><cf_get_lang_main no='370.Tarih Değerlerini Kontrol Ediniz !'></cfsavecontent>
													<cfinput type="text" name="startdate" id="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" message="#message1#" style="width:65px;">
													<span class="input-group-addon">
													<cf_wrk_date_image date_field="startdate">
													</span>  
												</div>
											</div>
											<div class="col col-6">
												<div class="input-group">
													<cfinput type="text" name="finishdate" id="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#"  validate="#validate_style#" message="#message1#" style="width:65px;">
													<span class="input-group-addon">
													<cf_wrk_date_image date_field="finishdate">
													</span>	
												</div>                                                 
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang_main no='388.İşlem Tipi'></label>
											<div class="col col-12">
												<select name="type" id="type" style="width:175px;">
													<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
													<option value="81"<cfif isdefined('attributes.type') and len(attributes.type) and attributes.type eq 81>selected</cfif>><cf_get_lang no='693.Depo Sevk İrsaliyesi'></option>
													<option value="113"<cfif isdefined('attributes.type') and len(attributes.type) and attributes.type eq 113>selected</cfif>><cf_get_lang_main no='1833.Ambar Fişi'>(<cf_get_lang no='695.Depolararası'>)</option>
												</select>         
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
							<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang_main no='446.Excel Getir'> <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input name="form_varmi" id="form_varmi" type="hidden" value="1"> 
							<cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'>					
					    </div>	  
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">	
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.form_varmi")>
	<cf_report_list>
		<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
			<cfset attributes.startrow=1>
			<cfset attributes.maxrows = search_results.recordcount>
		</cfif>
		<thead>
			<tr>
				<th><cf_get_lang_main no='106.Stok Kodu'></th>
				<th><cf_get_lang_main no='245.Ürün'></th>
				<th><cf_get_lang no='701.Belge Tarihi'></th>
				<th><cf_get_lang_main no='468.Belge No'></th>
				<th><cf_get_lang_main no='217.Açıklama'></th>
				<th><cf_get_lang no='702.Giriş Depo - Lokasyon'></th>
				<th><cf_get_lang no='703.Çıkış Depo - Lokasyon'></th>
				<th><cf_get_lang_main no='223.Miktar'></th>
				<th><cf_get_lang_main no='224.Birim'></th>
				<th>2.<cf_get_lang_main no='223.Miktar'></th>
				<th style="text-align:right;"><cf_get_lang_main no='227.KDV'> <cf_get_lang no='705.Hariç Tutar'></th>
				<th style="text-align:right;"><cf_get_lang_main no='227.KDV'> <cf_get_lang no='706.Dahil Tutar'></th>
			</tr>
		</thead>
		<cfparam name="attributes.totalrecords" default="#search_results.recordcount#">
		<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
		<cfif search_results.recordcount>
			<cfif attributes.page neq 1>
				<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
					<cfset attributes.startrow=1>
					<cfset attributes.maxrows = search_results.recordcount>
				</cfif>
				<cfoutput query="search_results" startrow="1" maxrows="#attributes.startrow-1#">
					<cfquery name="GET_SON_TOPLAM" dbtype="query">
						SELECT 
							PRODUCT_ID,
							(ROW_NETTOTAL+(ROW_NETTOTAL*(TAX/100))) AS SONTOPLAM,
							NUMBER
						FROM
							search_results
						WHERE
							PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
							AND NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#number#">
						GROUP BY 
							PRODUCT_ID,	
							NUMBER,			
							TAX,
							ROW_NETTOTAL
					</cfquery>
					<cfif row_nettotal gt 0><cfset kdv_haric_toplam = kdv_haric_toplam + row_nettotal></cfif>
					<cfif get_son_toplam.sontoplam gt 0><cfset kdv_dahil_toplam = kdv_dahil_toplam + get_son_toplam.sontoplam></cfif>
					<cfif len(AMOUNT)>
						<cfset unit_ = filterSpecialChars(unit)>
						<cfset 'toplam_#unit_#' = evaluate('toplam_#unit_#') + AMOUNT>
					</cfif>
				</cfoutput>
			</cfif>
			<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
				<cfset attributes.startrow=1>
				<cfset attributes.maxrows = search_results.recordcount>
			</cfif>
			<tbody>
				<cfoutput query="search_results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfquery name="GET_SON_TOPLAM" dbtype="query">
						SELECT 
							PRODUCT_ID,
							(ROW_NETTOTAL+(ROW_NETTOTAL*(TAX/100))) AS SONTOPLAM,
							NUMBER
						FROM
							search_results
						WHERE
							PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
							AND NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#number#">
						GROUP BY 
							PRODUCT_ID,	
							NUMBER,			
							TAX,
							ROW_NETTOTAL
					</cfquery>
					<tr>
						<td>#STOCK_CODE#</td>
						<td>#PRODUCT_NAME#</td>
						<td>#DateFormat(S_DATE,dateformat_style)#</td>
						<td>#NUMBER#</td>
						<td>#S_DETAIL#</td>
						<td>#GIRIS_DEPO# - #GIRIS_LOKASYON#</td>
						<td>#CIKIS_DEPO# - #CIKIS_LOKASYON#</td>
						<td align="right" style="text-align:right;" format="numeric">#TLFormat(AMOUNT)#</td>
						<td align="center">#UNIT#</td>
						<td align="right" style="text-align:right;" format="numeric">
							<cfif len(AMOUNT) and len(MULTIPLIER_AMOUNT)>
								<cfset toplam_multiplier = toplam_multiplier + (AMOUNT/MULTIPLIER_AMOUNT)>
								#TLFormat(AMOUNT/MULTIPLIER_AMOUNT,2)#
							</cfif>
						</td>
						<td align="right" style="text-align:right;" format="numeric">#TLFormat(ROW_NETTOTAL)#</td>
						<td align="right" style="text-align:right;" format="numeric">#TLFormat(get_son_toplam.SONTOPLAM)#</td>
					</tr>
					<cfif ROW_NETTOTAL gt 0><cfset kdv_haric_toplam = kdv_haric_toplam + ROW_NETTOTAL></cfif>
					<cfif get_son_toplam.SONTOPLAM gt 0><cfset kdv_dahil_toplam = kdv_dahil_toplam + get_son_toplam.SONTOPLAM></cfif>
					<cfif len(AMOUNT)>
						<cfset unit_ = filterSpecialChars(unit)>
						<cfset 'toplam_#unit_#' = evaluate('toplam_#unit_#') + AMOUNT>
					</cfif>
				</cfoutput>
			</tbody>
			<cfoutput>
				<tfoot>
					<tr>
						<cfif type_ eq 1>
							<cfset class="txtbold">
						<cfelse>
							<cfset class="txtboldblue">
						</cfif>
						<td colspan="7" style="text-align:right" class="#class#"><cf_get_lang_main no='80.Toplam'></td>
						<cfif type_ eq 1>
							<td colspan="2" style="text-align:right" class="txtbold">
								<cfloop query="get_product_units">
									<cfset unit_ = filterSpecialChars(unit)>
									<cfif evaluate('toplam_#unit_#') gt 0>#Tlformat(evaluate('toplam_#unit_#'))# #get_product_units.unit#</cfif>
								</cfloop>
							</td>
						<cfelse>
							<td colspan="2" style="text-align:right" class="txtbold">
								<cfloop query="get_product_units">
									<cfset unit_ = filterSpecialChars(unit)>
									<cfif evaluate('toplam_#unit_#') gt 0>
										#Tlformat(evaluate('toplam_#unit_#'))# #get_product_units.unit#<br/>
									</cfif>
								</cfloop>
							</td>					
						</cfif>
						<td class="txtbold" style="text-align:right;">#TLFormat(toplam_multiplier,2)#</td>
						<td class="txtbold" style="text-align:right;">#TLFormat(kdv_haric_toplam)#</td>
						<td class="txtbold" style="text-align:right;">#TLFormat(kdv_dahil_toplam)#</td>
					</tr>
				</tfoot>
			</cfoutput>
		<cfelse>
			<tbody>
				<tr>
					<td colspan="12"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
				</tr>
			</tbody>
		</cfif>
	</cf_report_list>
</cfif>	
<cfif isdefined("attributes.form_varmi") and (search_results.recordcount gt attributes.maxrows) >
	<tr>
		<td>
			<cfset send = "#attributes.fuseaction#&form_varmi=1">
			<cfif len(attributes.stock_name) and len(attributes.stock_id)>
				<cfset send = "#send#&stock_name=#attributes.stock_name#&stock_id=#attributes.stock_id#">				  
			</cfif>
			<cfif len(attributes.project_id) and len(attributes.project_id)>
				<cfset send = "#send#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">				  
			</cfif>
			<cfif len(attributes.product_catid2) gt 0 and len(attributes.product_cat2) gt 0>
				<cfset send = "#send#&product_catid2=#attributes.product_catid2#&product_cat2=#attributes.product_cat2#">				  
			</cfif>
			<cfif isdefined('attributes.type') and len(attributes.type)>
				<cfset send = "#send#&type=#attributes.type#">
			</cfif>
			<cfif isdefined('attributes.department_in') and len(attributes.department_in)>
				<cfset send = "#send#&department_in=#attributes.department_in#">
			</cfif>
			<cfif isdefined('attributes.department_out') and len(attributes.department_out)>
				<cfset send = "#send#&department_out=#attributes.department_out#">
			</cfif>
			<cfset send = "#send#&startdate=#dateformat(attributes.startdate,dateformat_style)#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
			<cf_paging
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#search_results.recordcount#"
				startrow="#attributes.startrow#"
				adres="#attributes.fuseaction#&#send#"> 
		</td>
	</tr>
</cfif>	
<script>
	function control()
	{  
		if ((document.report_special.startdate.value != '') && (document.report_special.finishdate.value != '') &&
	    !date_check(report_special.startdate,report_special.finishdate,"<cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	    return false;
		if(document.report_special.is_excel.checked==false)
			{
				document.report_special.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
				return true;
			}
			else
				document.report_special.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_ship_dispatch_report</cfoutput>"
	}
</script>



