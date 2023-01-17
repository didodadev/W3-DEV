<cfsetting showdebugoutput="yes">
<cfparam name="attributes.module_id_control" default="13">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.max_rows" default="20">
<cfparam name="attributes.start_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.finish_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.barcod" default="">
<cfparam name="attributes.stock_code" default="">
<cfparam name="attributes.stock_code_2" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.property" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">		
<cfparam name="row_count" 	default="0">
<cfset attributes.startrow=((attributes.page-1)*attributes.max_rows)+1>
<!--- <cfparam name="attributes.department_id" default=""> --->
<cfparam name="attributes.product_status" default="">
<cfparam name="attributes.process_type_detail" default="">

<!--- BK 20120220 114 Devir Fisi eklendi --->
<cfset islem_tipi = "70,71,72,73,74,75,76,77,78,79,80,81,811,82,83,84,85,86,88,761,110,111,112,113,114,115,116,122,140,141,171,1131,118,1182">
<!---<cfset islem_tipi = "114,171,52,53,54,55,59,62,64,65,66,69,690,591,592,531,532,70,71,72,73,74,75,76,77,78,79,80,81,811,82,83,84,85,86,88,761,110,111,112,113,1131,115,116,140,141,120,122,118,1182">
---><cfif isdate(attributes.start_date)><cf_date tarih="attributes.start_date"><cfelse><cfset attributes.start_date = ""></cfif>
<cfif isdate(attributes.finish_date)><cf_date tarih="attributes.finish_date"><cfelse><cfset attributes.finish_date = ""></cfif>
<cfquery name="get_department" datasource="#dsn#">
	SELECT 
		DEPARTMENT_ID,
		DEPARTMENT_HEAD
	FROM
		BRANCH B,
		DEPARTMENT D
	WHERE
		B.COMPANY_ID = #session.ep.company_id# AND
		B.BRANCH_ID = D.BRANCH_ID AND
		D.IS_STORE <> 2 AND
		D.DEPARTMENT_STATUS = 1 AND
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY 
		DEPARTMENT_HEAD
</cfquery>
<cfset branch_dep_list=valuelist(get_department.department_id,',')>
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT * FROM STOCKS_LOCATION
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="check_table" datasource="#dsn2#">
		IF EXISTS(SELECT * FROM tempdb.sys.tables where name = '####GET_NOSALE_PRODUCTS_#session.ep.userid#')
		BEGIN
			DROP TABLE ####GET_NOSALE_PRODUCTS_#session.ep.userid#
		END     
		CREATE TABLE ####GET_NOSALE_PRODUCTS_#session.ep.userid#
		( 
			PRODUCT_ID INT
		)
	</cfquery>   
	<cfquery name="GET_PRODUCT" datasource="#dsn2#">
		SELECT 
			PRODUCT_ID,
			PRODUCT_NAME,
			PROPERTY,
			BARCOD,
			STOCK_CODE,
			STOCK_CODE_2,
			PRODUCT_STATUS,
			 TOPLAM,
			PROCESS_DATE,
			PROCESS_TYPE
			from
		(
		SELECT
			S.PRODUCT_ID,
			S.PRODUCT_NAME,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_CODE,
			S.STOCK_CODE_2,
			S.PRODUCT_STATUS,
			SUM(SR.STOCK_IN - SR.STOCK_OUT) AS TOPLAM,
			MAX(SR.PROCESS_DATE) AS PROCESS_DATE,
			SR.PROCESS_TYPE
    	FROM 
			#dsn3_alias#.STOCKS S,
			STOCKS_ROW SR
    	WHERE
      	  S.STOCK_ID = SR.STOCK_ID AND
		  SR.PROCESS_TYPE IS NOT NULL AND

		<cfif len(attributes.cat)>
			S.PRODUCT_CODE LIKE '#attributes.cat#.%' AND
		</cfif>
        <cfif len(attributes.product_status)>S.PRODUCT_STATUS = #attributes.product_status# AND</cfif>
        S.STOCK_ID NOT IN
        (
            SELECT
                STOCK_ID
            FROM 
                STOCKS_ROW
            WHERE 
                STOCK_ID IS NOT NULL
			<cfif len(attributes.process_type_detail)>
				AND PROCESS_TYPE IN(#attributes.process_type_detail#)
			<!---<cfelse>
				AND 1 = 0 --->
			</cfif>
			<cfif not len(attributes.start_date) and not len(attributes.finish_date)>
			   AND PROCESS_DATE IS NOT NULL 
			</cfif>
			<cfif len(attributes.start_date)>
			   AND PROCESS_DATE >= #attributes.start_date# 
			</cfif>
			<cfif len(attributes.finish_date)>
				AND PROCESS_DATE <= #attributes.finish_date#
			</cfif>
        	)
		GROUP BY
			S.PRODUCT_ID,
			S.PRODUCT_NAME,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_CODE,
			S.STOCK_CODE_2,
			S.PRODUCT_STATUS,
			SR.PROCESS_TYPE
		UNION ALL 		
		SELECT
			S.PRODUCT_ID,
			S.PRODUCT_NAME,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_CODE,
			S.STOCK_CODE_2,
			S.PRODUCT_STATUS,
			0 TOPLAM,
			NULL PROCESS_DATE,
			'' PROCESS_TYPE
		FROM 
			#dsn3_alias#.STOCKS S
		WHERE
			1 = 1
			<cfif len(attributes.cat)>
				AND S.PRODUCT_CODE LIKE '#attributes.cat#.%' 
			</cfif>
			<cfif len(attributes.product_status)>AND S.PRODUCT_STATUS = #attributes.product_status# </cfif>
			AND S.STOCK_ID NOT IN
			(
				SELECT
					STOCK_ID
				FROM 
					STOCKS_ROW
				WHERE 
					STOCK_ID IS NOT NULL
				<cfif len(attributes.process_type_detail)>
					AND PROCESS_TYPE IN (#attributes.process_type_detail#)
				<!---<cfelse>
					AND 1 = 0 --->
				</cfif>					
				<cfif not len(attributes.start_date) and not len(attributes.finish_date)>
				   AND PROCESS_DATE IS NOT NULL 
				</cfif>
				<cfif len(attributes.start_date)>
				   AND PROCESS_DATE >= #attributes.start_date# 
				</cfif>
				<cfif len(attributes.finish_date)>
					AND PROCESS_DATE <= #attributes.finish_date#
				</cfif>
			)
			AND S.STOCK_ID NOT IN
			( SELECT STOCK_ID FROM STOCKS_ROW WHERE STOCK_ID IS NOT NULL AND PROCESS_TYPE IS NOT NULL )
		) AS XX
		ORDER BY 
			PRODUCT_ID,
			PROCESS_DATE DESC
	</cfquery>

	<cfif GET_PRODUCT.recordCount neq 0>
		<cfquery name="add_" datasource="#dsn3#">
			<cfLOOP QUERY="GET_PRODUCT">
				INSERT INTO 
				####GET_NOSALE_PRODUCTS_#session.ep.userid#
				(PRODUCT_ID)
				VALUES
				(#GET_PRODUCT.PRODUCT_ID#)
			</cfLOOP>
		</cfquery>
	</cfif>
		<cfquery name="get_product_cost_all" datasource="#dsn1#">
			SELECT  
				PRODUCT_ID,
				PURCHASE_NET_SYSTEM,
				PURCHASE_EXTRA_COST_SYSTEM,
				START_DATE,
				RECORD_DATE
			FROM
				PRODUCT_COST
			WHERE
				 PRODUCT_ID IN (SELECT PRODUCT_ID FROM ####GET_NOSALE_PRODUCTS_#session.ep.userid# )
			<cfif len(attributes.start_date)>
				AND START_DATE >= #attributes.start_date#
			</cfif>
			<cfif len(attributes.finish_date)>
				AND START_DATE <= #attributes.finish_date#
			</cfif>
			<cfif not len(attributes.start_date) and not len(attributes.finish_date)>
				AND PRODUCT_COST_STATUS = 1
			</cfif>
			ORDER BY START_DATE DESC,RECORD_DATE DESC
		</cfquery>
		<cfif get_product_cost_all.recordcount>
			<cfloop query="get_product_cost_all">
				<cfscript>
					'product_cost_#PRODUCT_ID#' =PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM;
				</cfscript>
			</cfloop>
		</cfif>
	</cfif>

<cfform name="search_product" method="post" action="#request.self#?fuseaction=report.nosale_products_report">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='40607.Hareket Görmeyen Ürünler'></cfsavecontent>
	<cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57800.Islem Tipi'></label>
										<div class="col col-12">
											<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
												SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
											</cfquery>
											<select name="process_type_detail" id="process_type_detail" style="width:175px; height:118px;" multiple>
												<cfoutput query="get_process_cat" group="process_type">
													<option value="#process_type#" <cfif listfind(attributes.process_type_detail,'#process_type#')> selected</cfif>>#get_process_name(process_type)#</option>										
												</cfoutput>
											</select>
										</div>
									</div>
									<!--- <div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
										<div class="col col-12">
											<div class="input-group">
												<select name="department_id" id="department_id" multiple style="width:175px; height:75px;">
													<cfoutput query="get_department">
														<optgroup label="#department_head#">
															<cfquery name="GET_LOCATION" dbtype="query">
																SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = #get_department.department_id[currentrow]#
															</cfquery>
															<cfif get_location.recordcount>
																<cfloop from="1" to="#get_location.recordcount#" index="s">
																	<option value="#department_id#-#get_location.location_id[s]#" <cfif listfind(attributes.department_id,'#department_id#-#get_location.location_id[s]#',',')>selected</cfif>>&nbsp;&nbsp;#get_location.comment[s]#</option>
																</cfloop>
															</cfif>
														</optgroup>					  
													</cfoutput>
												</select>
											</div>	
										</div>
									</div> --->
								</div>
							</div>
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
										<div class="col col-12">
											<div class="input-group">
												<input type="hidden" name="cat" id="cat" value="<cfif len(attributes.cat) and len(attributes.category_name)><cfoutput>#attributes.cat#</cfoutput></cfif>">
												<input name="category_name" type="text" id="category_name" style="width:170px;" onFocus="AutoComplete_Create('category_name','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','cat','','3','170');" value="<cfif len(attributes.category_name)><cfoutput>#attributes.category_name#</cfoutput></cfif>" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=search_product.cat&field_name=search_product.category_name</cfoutput>');"></span>
											</div>	
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
										<div class="col col-12">
											<select name="product_status" id="product_status" style="width:170px;">
												<option value="" <cfif attributes.product_status eq ''>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
												<option value="1" <cfif attributes.product_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
												<option value="0" <cfif attributes.product_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
										<div class="col col-6">
											<div class="input-group">
												<cfinput name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;">
												<span class="input-group-addon">
												<cf_wrk_date_image date_field="start_date">
												</span>		
											</div>
										</div>
										<div class="col col-6">
											<div class="input-group">
												<cfinput name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;">
												<span class="input-group-addon">
												<cf_wrk_date_image date_field="finish_date">
												</span>		
											</div>                                                 
										</div>
									</div>
								</div>
							</div>
							<div class="col col-12 col-md-3 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="col col-12 col-xs-12">
										<div class="form-group">
											<font style="float:left;" color="##FF0000"><cf_get_lang dictionary_id='40485.Seçili İşlem Tipinde Hareketi Olmayan Ürünler Listeye Gelmektedir.'></font>
										</div>
									</div>	
								</div>		
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
							<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'> <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="max_rows" value="#attributes.max_rows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							<input type="hidden" name="form_submitted" value="1"> 
							<cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'>					
					    </div>	  
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>

<cfif isdefined("attributes.form_submitted")>
	<cfset row_count =attributes.startrow>
	<cfset total_record = 0>
	<cfoutput query="get_product" group="product_id"><!--- Gruplama Yapildigi Icin Satir Toplamlarini Da Gruplayarak Almak Lazim --->
		<cfset total_record = total_record + 1>
	</cfoutput>
	<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
		<cfset filename = "#createuuid()#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-16">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-16">	
			<cfset type_ = 1>
		<cfelse>
			<cfset type_ = 0>
	</cfif>
    <cf_report_list>
			<cfparam name="attributes.totalrecords" default="#total_record#">
			
				<thead>
				<tr> 
					<th width="1%"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57633.Barkod'></th>
					<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
					<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='40608.Son Hareket Tarihi'></th>
					<th style="width:40mm"><cf_get_lang dictionary_id='57942.Bugün'>-<cf_get_lang dictionary_id='40608.Son Hareket Tarihi'></th>
					<th><cf_get_lang dictionary_id='40753.Son Hareket Tipi'></th>
					<th><cf_get_lang dictionary_id='58258.Maliyet'></th>
					<th><cf_get_lang dictionary_id='39112.Stok Miktarı'></th>
				</tr>
				</thead>
				<cfquery name="get_acc_card_type" datasource="#dsn3#">
					SELECT PROCESS_CAT,PROCESS_TYPE FROM SETUP_PROCESS_CAT
				</cfquery>
				<cfif type_ eq 1>
					<cfset attributes.max_rows = attributes.totalrecords>
				</cfif>
				<cfset count="1">
			<cfif get_product.recordcount>	
				<tbody>
					<cfoutput query="get_product" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#" group="product_id">
						<tr>
							<!--- <td width="1%"><!--- #currentrow# --->#row_count#</td> --->
							<td width="1%">#row_count#</td>
							<td style='mso-number-format:"\@"'>#barcod#</td>
							<td>#stock_code_2#</td>
							<td>#stock_code#</td>
							<td>
							<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
								#product_name# #property#
							<cfelse>
								<a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" >#product_name# #property#</a>
							</cfif>
							</td>
							<td><cfif len(get_product.process_date)>#DateFormat(get_product.process_date,dateformat_style)#</cfif></td>
							<td style="text-align:right;"><cfif len(get_product.process_date)>#datediff("d",get_product.process_date,now())#</cfif></td>
							<cfif len(get_product.process_type)>
								<cfquery name="get_acc_card_type_" dbtype="query">
									SELECT PROCESS_CAT FROM GET_ACC_CARD_TYPE WHERE PROCESS_TYPE = #get_product.process_type# 
								</cfquery>
							</cfif>
							<td style="text-align:right;"><cfif isdefined('get_acc_card_type_.process_cat') and len(get_acc_card_type_.process_cat)>#get_acc_card_type_.process_cat#</cfif></td>
							<td style="text-align:right;"><cfif isdefined('product_cost_#product_id#')>#tlformat(Evaluate('product_cost_#product_id#'))# #session.ep.money#<cfelse>-</cfif></td>
							<td style="text-align:right;">#tlformat(toplam)#</td>
						</tr>
						<cfset row_count = row_count + 1>
					</cfoutput>
				</tbody>
			<cfelse>
				<tr>
					<td colspan="10"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
				<tr>
			</cfif>	
    </cf_report_list>
	<cfif attributes.totalrecords gt attributes.max_rows>
		<cfscript>
			str_link = "";
			str_link = "#str_link#&max_rows=#attributes.max_rows#&barcod=#attributes.barcod#&stock_code=#attributes.stock_code#&stock_code_2=#attributes.stock_code_2#&form_submitted=#attributes.form_submitted#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#&start_date=#dateformat(attributes.start_date,dateformat_style)#";
			str_link = "#str_link#&product_name=#attributes.product_name#&product_id=#attributes.product_id#&product_status=#attributes.product_status#&property=#attributes.property#&cat=#attributes.cat#&is_excel=#attributes.is_excel#&process_type_detail=#attributes.process_type_detail#";
		</cfscript>				
		<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.max_rows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="report.nosale_products_report#str_link#">
		
	</cfif>	
</cfif>
<script>
	function control()
	{
        if ((document.search_product.start_date.value != '') && (document.search_product.finish_date.value != '') &&
	    !date_check(search_product.start_date,search_product.finish_date,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	    return false;
		if(document.search_product.is_excel.checked==false)
		{
			document.search_product.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
			return true;
		}
		else
			document.search_product.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_nosale_products_report</cfoutput>";
	}
</script>