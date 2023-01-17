<!--- doğtaş yarı mamül üretim takip raporu --->
<cfsetting showdebugoutput="yes">
<cfparam name="attributes.module_id_control" default="35">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.is_report_type" default="">
<cfparam name="attributes.is_demand_no" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.cat" default="">
<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
</cfif>	
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
</cfif>
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT 
		PRODUCT_CAT.PRODUCT_CATID, 
		PRODUCT_CAT.HIERARCHY, 
		PRODUCT_CAT.PRODUCT_CAT
	FROM 
		PRODUCT_CAT,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY 
		HIERARCHY
</cfquery>
<cfquery name="GET_W" datasource="#dsn#">
	SELECT 
    	* 
	FROM 
    	#dsn3_alias#.WORKSTATIONS 
	WHERE 
		ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
    	DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
	ORDER BY STATION_NAME ASC
</cfquery>
<cfquery name="check_table" datasource="#dsn3#">
    IF EXISTS(SELECT * FROM tempdb.sys.tables where name='####product_cat_#session.ep.userid#')
    BEGIN
      DROP TABLE ####product_cat_#session.ep.userid#;
    END
    
    CREATE TABLE ####product_cat_#session.ep.userid#
    ( 
        HIERARCHY	nvarchar(250) COLLATE Turkish_CI_AS
    )
</cfquery>
<cfif len(attributes.cat)>
    <cfquery name="add_table" datasource="#dsn3#">
        <cfloop from="1" to="#listlen(attributes.cat)#" index="c"> 
            INSERT INTO ####product_cat_#session.ep.userid#
            (
                HIERARCHY
            )
            VALUES
            (
               '#ListGetAt(attributes.cat,c,',')#.'
            )
        </cfloop>
    </cfquery>
</cfif>
<cfif isdefined('attributes.is_form_submited')>
	<cfquery name="get_yari_mamul_production" datasource="#dsn3#">
		SELECT DISTINCT
			PRODUCTION_ORDERS.P_ORDER_ID,
			PRODUCTION_ORDERS.START_DATE,
			PRODUCTION_ORDERS.FINISH_DATE,
			PRODUCTION_ORDERS.P_ORDER_NO,
			PRODUCTION_ORDERS.STOCK_ID,
			PRODUCTION_ORDERS.QUANTITY,
			PRODUCTION_ORDERS.STATION_ID,
			PRODUCTION_ORDERS.PROD_ORDER_STAGE,
            PRODUCTION_ORDERS.IS_STAGE,
            PRODUCTION_ORDERS.DEMAND_NO,
			STOCKS.PRODUCT_CATID,
			STOCKS.PRODUCT_NAME,
			STOCKS.PRODUCT_ID,
			STOCKS.PROPERTY,
            STOCKS.STOCK_CODE,
			STOCKS.SHORT_CODE_ID,
			STOCKS.PRODUCT_UNIT_ID,
			STOCKS.IS_PROTOTYPE,
			PRODUCTION_ORDERS.SPECT_VAR_NAME,
			(SELECT O.ORDER_NUMBER FROM ORDERS O,ORDER_ROW ORR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.ORDER_ROW_ID = PRODUCTION_ORDERS_ROW.ORDER_ROW_ID) ORDER_NUMBER,
			PC.HIERARCHY,
			PC.PRODUCT_CAT,
			PU.ADD_UNIT
        FROM
			PRODUCTION_ORDERS,
			PRODUCTION_ORDERS_ROW,
			STOCKS
            <cfif len(attributes.cat)>
                 JOIN ####product_cat_#session.ep.userid# ON STOCKS.PRODUCT_CODE LIKE HIERARCHY +'%'	
            </cfif>
			LEFT JOIN PRODUCT_CAT PC ON PC.PRODUCT_CATID = STOCKS.PRODUCT_CATID
            LEFT JOIN PRODUCT_UNIT PU ON PU.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
		WHERE
			PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID
			AND PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID
			<cfif attributes.is_report_type eq 2>
				AND PRODUCTION_ORDERS.IS_STAGE <> <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
            <cfelseif attributes.is_report_type eq 1>
                AND PRODUCTION_ORDERS.IS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
			</cfif>
			<cfif len(attributes.is_demand_no)>
				AND( 
					(PRODUCTION_ORDERS.P_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.is_demand_no#%">)
					OR
					(PRODUCTION_ORDERS.DEMAND_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.is_demand_no#%">))
			</cfif>
			<cfif len(attributes.short_code_id)>
				AND STOCKS.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#">
			</cfif>
			<!--- <cfif len(attributes.cat)>
				 AND STOCKS.PRODUCT_CODE LIKE (SELECT HIERARCHY FROM ####product_cat_#session.ep.userid#)
			</cfif> --->
			<cfif len(attributes.product_id) and len(attributes.product_name)>AND STOCKS.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>
			<cfif len(attributes.station_id)>
				<cfif attributes.station_id eq 0>
					AND PRODUCTION_ORDERS.STATION_ID IS NULL
				<cfelse>
					AND PRODUCTION_ORDERS.STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.station_id#">
				</cfif>
			</cfif>
			<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
				AND PRODUCTION_ORDERS.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		    </cfif>
			<cfif isDefined("attributes.finish_date") and isdate(attributes.finish_date)>
				AND PRODUCTION_ORDERS.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',1,attributes.finish_date)#">
		   </cfif>
		 UNION ALL
		 SELECT DISTINCT
			PRODUCTION_ORDERS.P_ORDER_ID,
			PRODUCTION_ORDERS.START_DATE,
			PRODUCTION_ORDERS.FINISH_DATE,
			PRODUCTION_ORDERS.P_ORDER_NO,
			PRODUCTION_ORDERS.STOCK_ID,
			PRODUCTION_ORDERS.QUANTITY,
			PRODUCTION_ORDERS.STATION_ID,
			PRODUCTION_ORDERS.PROD_ORDER_STAGE,
            PRODUCTION_ORDERS.IS_STAGE,
            PRODUCTION_ORDERS.DEMAND_NO,
			STOCKS.PRODUCT_CATID,
			STOCKS.PRODUCT_NAME,
			STOCKS.PRODUCT_ID,
			STOCKS.PROPERTY,
            STOCKS.STOCK_CODE,
			STOCKS.SHORT_CODE_ID,
			STOCKS.PRODUCT_UNIT_ID,
			STOCKS.IS_PROTOTYPE,
			PRODUCTION_ORDERS.SPECT_VAR_NAME,
			'' ORDER_NUMBER,
            PC.HIERARCHY,
			PC.PRODUCT_CAT,
			PU.ADD_UNIT
		FROM
			PRODUCTION_ORDERS,
			STOCKS
            <cfif len(attributes.cat)>
                 JOIN ####product_cat_#session.ep.userid# ON STOCKS.PRODUCT_CODE LIKE HIERARCHY +'%'	
            </cfif>
            LEFT JOIN PRODUCT_CAT PC ON PC.PRODUCT_CATID = STOCKS.PRODUCT_CATID
            LEFT JOIN PRODUCT_UNIT PU ON PU.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
		WHERE
			PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID
			AND PRODUCTION_ORDERS.P_ORDER_ID NOT IN(SELECT PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID FROM PRODUCTION_ORDERS_ROW WHERE PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID)
			<cfif attributes.is_report_type eq 2>
				AND PRODUCTION_ORDERS.IS_STAGE <> <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
            <cfelseif attributes.is_report_type eq 1>
                AND PRODUCTION_ORDERS.IS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
			</cfif>
			<cfif len(attributes.is_demand_no)>
				AND( 
					(PRODUCTION_ORDERS.P_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.is_demand_no#%">)
					OR
					(PRODUCTION_ORDERS.DEMAND_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.is_demand_no#%">))
			</cfif>
			<cfif len(attributes.short_code_id)>
				AND STOCKS.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#">
			</cfif>
			<!--- <cfif len(attributes.cat)>
				 AND(
				 <cfloop from="1" to="#listlen(attributes.cat)#" index="c"> 
					(STOCKS.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.cat,c,',')#.%">)
					 <cfif C neq listlen(attributes.cat)>OR</cfif>
				</cfloop>)
			</cfif> --->
            <!--- <cfif len(attributes.cat)>
				 AND STOCKS.PRODUCT_CODE LIKE (SELECT HIERARCHY FROM ####product_cat_#session.ep.userid#)
			</cfif> --->
			<cfif len(attributes.product_id) and len(attributes.product_name)>AND STOCKS.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>
			<cfif len(attributes.station_id)>
				<cfif attributes.station_id eq 0>
					AND PRODUCTION_ORDERS.STATION_ID IS NULL
				<cfelse>
					AND PRODUCTION_ORDERS.STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.station_id#">
				</cfif>
			</cfif>
			<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
				AND PRODUCTION_ORDERS.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		    </cfif>
			<cfif isDefined("attributes.finish_date") and isdate(attributes.finish_date)>
				AND PRODUCTION_ORDERS.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',1,attributes.finish_date)#">
		   </cfif>
		 ORDER BY 
		 	PRODUCTION_ORDERS.START_DATE
	</cfquery>
<cfelse>
	<cfset get_yari_mamul_production.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_yari_mamul_production.recordcount#'>
<cfset attributes.startrow = (((attributes.page-1)*attributes.maxrows)) + 1>
<cfform name="search_list" method="post" action="#request.self#?fuseaction=report.production_program_report">
<cfsavecontent variable='title'><cf_get_lang dictionary_id='40720.Üretim Programı'></cfsavecontent>
<cf_report_list_search title="#title#">
	<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40722.Talep'>/<cf_get_lang dictionary_id='40407.Emir'></label>
										<div class="col col-12 col-xs-12">
											<select name="is_report_type" id="is_report_type">
												<option value="1"<cfif attributes.is_report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='40722.Talepler'></option>
												<option value="2"<cfif attributes.is_report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='36656.Emirler'></option>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29473.İstasyonlar'></label>
										<div class="col col-12 col-xs-12">
											<select name="station_id" id="station_id">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option value="0" <cfif attributes.station_id eq 0>selected</cfif>><cf_get_lang dictionary_id='40724.İstasyonu Boş Olanlar'></option>
												<cfoutput query="get_w">
													<option value="#station_id#"<cfif attributes.station_id eq station_id>selected</cfif>>#station_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
												<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
												<input type="text"   name="product_name"  id="product_name" style="width:150px;"  value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','225');" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search_list.stock_id&product_id=search_list.product_id&field_name=search_list.product_name&keyword='+encodeURIComponent(document.search_list.product_name.value),'list');"></span>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58225.Model'></label>
										<div class="col col-12 col-xs-12">	
											<cf_wrkproductmodel
												returninputvalue="short_code_id,short_code_name"
												returnqueryvalue="MODEL_ID,MODEL_NAME"
												width="150"
												fieldname="short_code_name"
												fieldid="short_code_id"
												compenent_name="getProductModel"            
												boxwidth="300"
												boxheight="150"                        
												model_id="#attributes.short_code_id#">
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40723.Talep No'></label>
										<div class="col col-12 col-xs-12">
											<input type="text" value="<cfoutput>#attributes.is_demand_no#</cfoutput>" name="is_demand_no" id="is_demand_no" />
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
										<div class="col col-6">	
											<div class="input-group">
												<cfinput type="text" name="start_date" maxlength="10" validate="#validate_style#" style="width:65px;" value="#dateformat(attributes.start_date,dateformat_style)#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
											</div>
										</div>
										<div class="col col-6">	
											<div class="input-group">
												<cfinput type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" style="width:65px;">
												<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57486.Kategori'></label>
										<div class="col col-12 col-xs-12">
											<select name="cat" id="cat" style="height:115px" multiple>
												<cfoutput query="get_product_cat">
													<cfif listlen(HIERARCHY,".") lte 3>
													<option value="#HIERARCHY#" <cfif isdefined('attributes.cat') and listfind(attributes.cat,HIERARCHY)>selected</cfif>>#HIERARCHY#-#product_cat#</option>
													</cfif>
												</cfoutput>
											</select>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
							<input name="is_form_submited" id="is_form_submited" type="hidden" value="1">
							<cf_wrk_report_search_button search_function='kontrol()' insert_info='#message#' button_type='1' is_excel='1'>
						</div>
					</div>
				</div>
			</div>
	</cf_report_list_search_area>
</cf_report_list_search> 
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset filename="production_program_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="content-type" content="text/plain; charset=utf-8">
	<cfset type_ = 1>
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_yari_mamul_production.recordcount>
</cfif>
<cfif IsDefined("attributes.is_form_submited")>
<cf_report_list>
	<thead>
		<tr>
			<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='58211.Sipariş No'></th>
			<th><cf_get_lang dictionary_id='58881.Plan Tarihi'></th>
			<cfif attributes.is_report_type eq 1>
				<th><cf_get_lang dictionary_id='40723.Talep No'></th>
			<cfelse>
				<th><cf_get_lang dictionary_id='29474.Emir No'></th>
			</cfif>
			<th><cf_get_lang dictionary_id='40725.Bağlı Ürünün Adı'></th>
			<th><cf_get_lang dictionary_id='40726.Bağlı Ürünün Kodu'></th>
			<th><cf_get_lang dictionary_id='40727.Yari Mamul Adı'></th>
			<th><cf_get_lang dictionary_id='40728.Yari Mamul Spec Adı'></th>
			<th><cf_get_lang dictionary_id='40729.Yari Mamul Stok Kodu'></th>
			<th width="50"><cf_get_lang dictionary_id='57635.Miktar'></th>
			<th><cf_get_lang dictionary_id='57636.Birim'></th>
		</tr>
    </thead>
    <tbody>
	<cfif get_yari_mamul_production.recordcount>
		
		<cfquery name="get_all_stocks" datasource="#dsn3#">
			SELECT 
				S.PRODUCT_NAME,
				S.PRODUCT_ID,
				PC.PRODUCT_CAT,
				S.STOCK_ID,
				S.SHORT_CODE_ID,
				S.STOCK_CODE
			FROM 
				STOCKS S,
				PRODUCT_CAT PC
			WHERE
				S.PRODUCT_CATID = PC.PRODUCT_CATID
		</cfquery>
		<cfoutput query="get_yari_mamul_production" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<cfset last_stock_id = ''>
				<cfscript>
					writeTree(p_order_id);
				</cfscript>
				<cfif isdefined("last_stock_id") and len(last_stock_id)>
					<cfquery name="get_row_stock" dbtype="query">
						SELECT * FROM get_all_stocks WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#last_stock_id#">
					</cfquery>
					<cfif get_row_stock.recordcount>
						<cfset row_name = get_row_stock.PRODUCT_NAME>
						<cfset row_cat = get_row_stock.STOCK_CODE>
						<cfset row_id = get_row_stock.PRODUCT_ID>
					<cfelse>
						<cfset row_name = product_name>
						<cfset row_cat = stock_code>
						<cfset row_id = product_id>
					</cfif> 
				<cfelse>
					<cfset row_name = product_name>
					<cfset row_cat = stock_code>
					<cfset row_id = product_id>
				</cfif>
				<cfset plan_tarih_ = "#dateformat(START_DATE,dateformat_style)#-#timeformat(START_DATE,timeformat_style)#">
				<td>#currentrow#</td>
				<td>#order_number#</td>
				<td>#plan_tarih_#</td>
				<cfif attributes.is_report_type eq 1>
					<td>#demand_no#</td>
				<cfelse>
					<td>#p_order_no#</td>
				</cfif>
				<td>
					<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
						#row_name#
					<cfelse>
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#row_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','large');" class="tableyazi">#row_name#</a>
					</cfif>	
				</td>
				<td>#row_cat#</td>
				<td>
					<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
						#product_name#
					<cfelse>
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','large');" class="tableyazi">#product_name#</a>
					</cfif>
					#property#
				</td>
				<td>
					<cfif is_prototype eq 1>
						#spect_var_name#
					</cfif>
				</td>
				<td>#stock_code#</td>
				<td style="text-align:right;" format="numeric">#tlformat(quantity)#</td>
				<td>#ADD_UNIT#</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="11"><cfif isdefined('attributes.is_form_submited')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'> !</cfif></td>
		</tr>
	</cfif>
    </tbody>
</cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "report.production_program_report">
	<cfif isdefined("attributes.is_form_submited") and len(attributes.is_form_submited)>
		<cfset url_str = "#url_str#&is_form_submited=#attributes.is_form_submited#">
	</cfif>
	<cfif isdefined("attributes.is_report_type") and len(attributes.is_report_type)>
		<cfset url_str = "#url_str#&is_report_type=#attributes.is_report_type#">
	</cfif>
	<cfif isDefined('attributes.is_demand_no') and len(attributes.is_demand_no)>
		<cfset url_str = '#url_str#&is_demand_no=#attributes.is_demand_no#'>
	</cfif>
	<cfif isDefined('attributes.cat') and len(attributes.cat)>
		<cfset url_str = '#url_str#&cat=#attributes.cat#'>
	</cfif>
	<cfif isDefined('attributes.product_id') and len(attributes.product_id)>
		<cfset url_str = '#url_str#&product_id=#attributes.product_id#'>
	</cfif>
	<cfif isDefined('attributes.product_name') and len(attributes.product_name)>
		<cfset url_str = '#url_str#&product_name=#attributes.product_name#'>
	</cfif>
	<cfif isDefined('attributes.station_id') and len(attributes.station_id)>
		<cfset url_str = '#url_str#&station_id=#attributes.station_id#'>
	</cfif>
	<cfif isDefined('attributes.start_date') and len(attributes.start_date)>
		<cfset url_str = '#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
	</cfif>
	<cfif isDefined('attributes.finish_date') and len(attributes.finish_date)>
		<cfset url_str = '#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
	</cfif>
	<cfif isDefined('attributes.short_code_id') and len(attributes.short_code_id)>
		<cfset url_str = '#url_str#&short_code_id=#attributes.short_code_id#'>
	</cfif>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url_str#"> 
</cfif>
<cfscript>
	function get_subs(p_order_id)
	{										
		SQLStr = "
				SELECT
					P_ORDER_ID,
					ISNULL(PO_RELATED_ID,0) PO_RELATED_ID,
					STOCK_ID
				FROM 
					PRODUCTION_ORDERS PT
				WHERE
					P_ORDER_ID = #p_order_id#
			";
		query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
		stock_id_ary='';
		for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
		{
			stock_id_ary=listappend(stock_id_ary,query1.P_ORDER_ID[str_i],'█');
			stock_id_ary=listappend(stock_id_ary,query1.PO_RELATED_ID[str_i],'§');
			stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'§');
		}
		return stock_id_ary;
	}
	function writeTree(p_order_id)
	{
		var i = 1;
		var sub_products = get_subs(p_order_id);
		for (i=1; i lte listlen(sub_products,'█'); i = i+1)
		{
			_next_order_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
			_n_related_id_= ListGetAt(ListGetAt(sub_products,i,'█'),2,'§');
			last_stock_id= ListGetAt(ListGetAt(sub_products,i,'█'),3,'§');
			writeTree(_n_related_id_);
		 }
	}	
</cfscript>
<script>
function kontrol()
	{
		if ((document.search_list.start_date.value != '') && (document.search_list.finish_date.value != '') &&
	    !date_check(search_list.start_date,search_list.finish_date,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		if(document.search_list.is_excel.checked==false)
		{
			document.search_list.action="<cfoutput>#request.self#?fuseaction=report.production_program_report</cfoutput>";
			return true;
		}
		else
			document.search_list.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_production_program_report</cfoutput>";
	}
</script>