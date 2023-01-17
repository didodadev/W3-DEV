<!--- Seri No Liste Sayfası --->
<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
<cfset fuseaction_ = replace(fuseaction_,'emptypopup_','')>
<cfparam name="authority_station_id_list" default="0">
<cfquery name="GET_W" datasource="#dsn#">
	SELECT 
		STATION_ID 
	FROM 
		#dsn3_alias#.WORKSTATIONS W
	WHERE 
		W.ACTIVE = 1 AND
		W.EMP_ID LIKE '%,#session.ep.userid#,%'
	ORDER BY 
		STATION_NAME
</cfquery>
<cfset authority_station_id_list = ValueList(get_w.station_id,',')>
<cfif isdefined("is_form_submitted")>
	<cfquery name="get_serial_no" datasource="#dsn3#">
		SELECT
				PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
				PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
				SUM(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT) QUANTITY,
				PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID PROCESS_ID,
				PRODUCTION_ORDER_RESULTS.P_ORDER_ID,
				PRODUCTION_ORDER_RESULTS.RESULT_NO PROCESS_NUMBER,
				PRODUCTION_ORDER_RESULTS.FINISH_DATE PROCESS_DATE,
				PRODUCTION_ORDER_RESULTS.START_DATE DELIVER_DATE,
				PRODUCTION_ORDER_RESULTS.STATION_ID,
				PRODUCTION_ORDER_RESULTS.PRODUCTION_LOC_ID LOCATION_IN,
				PRODUCTION_ORDER_RESULTS.PRODUCTION_DEP_ID DEPARTMENT_IN,
				PRODUCTION_ORDER_RESULTS.EXIT_LOC_ID LOCATION_OUT,
				PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID DEPARTMENT_OUT,
				(SELECT TOP 1
						SG.SERIAL_NO
					FROM
						SERVICE_GUARANTY_NEW AS SG
					WHERE
						STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND
						PROCESS_ID = PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID AND
						SG.PERIOD_ID = #session.ep.period_id#) SERIAL_NO
			FROM
				PRODUCTION_ORDER_RESULTS,
				PRODUCTION_ORDER_RESULTS_ROW,
				STOCKS
			WHERE
				PRODUCTION_ORDER_RESULTS.PRODUCTION_DEP_ID IS NOT NULL AND
				PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID IS NOT NULL AND
				PRODUCTION_ORDER_RESULTS_ROW.TYPE = 1 AND
				PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID = PRODUCTION_ORDER_RESULTS.PR_ORDER_ID AND
				PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID = STOCKS.STOCK_ID AND
				STOCKS.IS_SERIAL_NO = 1
			GROUP BY 
				PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
				PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
				PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID,
				PRODUCTION_ORDER_RESULTS.P_ORDER_ID,
				PRODUCTION_ORDER_RESULTS.RESULT_NO,
				PRODUCTION_ORDER_RESULTS.FINISH_DATE,
				PRODUCTION_ORDER_RESULTS.START_DATE,		
				PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ROW_ID,
				PRODUCTION_ORDER_RESULTS.STATION_ID,
				PRODUCTION_ORDER_RESULTS.PRODUCTION_LOC_ID,
				PRODUCTION_ORDER_RESULTS.PRODUCTION_DEP_ID,
				PRODUCTION_ORDER_RESULTS.EXIT_LOC_ID,
				PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID
			ORDER BY
				PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ROW_ID DESC
	</cfquery>
	<cfif len(authority_station_id_list)>
		<cfquery name="get_serial_no_" dbtype="query">
			SELECT 
				*
			FROM
				get_serial_no
			WHERE
				P_ORDER_ID IS NOT NULL AND
				<cfif len(authority_station_id_list)>
					(STATION_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#authority_station_id_list#" list="yes">) AND STATION_ID IS NOT NULL)
				<cfelse>
					1 = 0
				</cfif>
			ORDER BY
				P_ORDER_ID DESC
		</cfquery>
	<cfelse>
		<cfset get_serial_no_.recordcount = 0>
	</cfif>
<cfelse>
	<cfset get_serial_no_.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif get_serial_no_.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_serial_no_.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfif get_serial_no_.recordcount>
	<cfset p_order_id_list = ''>
	<cfset stock_id_list = ''>
	<cfset dept_in_list = ''>
	<cfset dept_out_list = ''>
	<cfoutput query="get_serial_no_" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfif len(p_order_id) and not listfind(p_order_id_list,p_order_id)>
			<cfset p_order_id_list=listappend(p_order_id_list,p_order_id)>
		</cfif>
		<cfif len(stock_id) and not listfind(stock_id_list,stock_id)>
			<cfset stock_id_list=listappend(stock_id_list,stock_id)>
		</cfif>
		<cfif len(DEPARTMENT_IN) and not listfind(dept_in_list,DEPARTMENT_IN)>
			<cfset dept_in_list=listappend(dept_in_list,DEPARTMENT_IN)>
		</cfif>
		<cfif len(DEPARTMENT_OUT) and not listfind(dept_out_list,DEPARTMENT_OUT)>
			<cfset dept_out_list=listappend(dept_out_list,DEPARTMENT_OUT)>
		</cfif>
		<cfif len(p_order_id_list)>
			<cfset p_order_id_list=listsort(p_order_id_list,"numeric","ASC",",")>
			<cfquery name="get_project" datasource="#dsn#">
				SELECT 
					PROJECT_HEAD,
					PROJECT_ID 
				FROM 
					PRO_PROJECTS 
				WHERE 
					PROJECT_ID IN (
									SELECT
										PROJECT_ID
									FROM
										#dsn3_alias#.PRODUCTION_ORDERS
									WHERE
										P_ORDER_ID IN (#p_order_id_list#) 
								  )
				ORDER BY PROJECT_ID
			</cfquery>
			<cfset p_order_id_list = listsort(listdeleteduplicates(valuelist(get_project.PROJECT_ID,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(stock_id_list)>
			<cfset stock_id_list=listsort(stock_id_list,"numeric","ASC",",")>
			<cfquery name="get_product" datasource="#dsn3#">
				SELECT 
					PRODUCT_NAME,
					STOCK_CODE,
					STOCK_ID 
				FROM 
					STOCKS 
				WHERE 
					STOCK_ID IN (#stock_id_list#)
				ORDER BY STOCK_ID
			</cfquery>
			<cfset stock_id_list = listsort(listdeleteduplicates(valuelist(get_product.STOCK_ID,',')),'numeric','ASC',',')>
		</cfif>
		<cfif listlen(dept_in_list)>
			<cfset dept_in_list = listsort(dept_in_list,"numeric","ASC",",")>
			<cfquery name="get_dept_in" datasource="#DSN#" >
				SELECT
					DEPARTMENT_ID,
					DEPARTMENT_HEAD
				FROM 
					DEPARTMENT
				WHERE
					DEPARTMENT_ID IN (#dept_in_list#)
				ORDER BY
					DEPARTMENT_ID
			</cfquery> 
			<cfset dept_in_list = listsort(listdeleteduplicates(valuelist(get_dept_in.DEPARTMENT_ID,',')),'numeric','ASC',',')>
		</cfif>
		<cfif listlen(dept_out_list)>
			<cfset dept_out_list = listsort(dept_out_list,"numeric","ASC",",")>
			<cfquery name="get_dept_out" datasource="#DSN#" >
				SELECT
					DEPARTMENT_ID,
					DEPARTMENT_HEAD
				FROM 
					DEPARTMENT
				WHERE
					DEPARTMENT_ID IN (#dept_out_list#)
				ORDER BY
					DEPARTMENT_ID
			</cfquery> 
			<cfset dept_out_list = listsort(listdeleteduplicates(valuelist(get_dept_out.DEPARTMENT_ID,',')),'numeric','ASC',',')>
		</cfif>
	</cfoutput>
</cfif>
<cfscript>wrkUrlStrings('url_str','is_form_submitted');</cfscript>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_list" action="#request.self#?fuseaction=production.#fuseaction_#" method="post">
			<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
			<cf_box_search more="0">
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" is_excel='0'>
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray2" href="javascript:history.go(-1);"><i class="fa fa-arrow-left"></i></a>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="box_head"><cf_get_lang dictionary_id='57718.Seri Nolar'></cfsavecontent>
	<cf_box title="#box_head#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='57637.Seri No'></th>
				<th><cf_get_lang dictionary_id='57880.Belge No'></th>
				<th><cf_get_lang dictionary_id='57742.Tarih'></th>
				<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
				<th><cf_get_lang dictionary_id='57657.Ürün'></th>
				<th><cf_get_lang dictionary_id='57416.Proje'></th>
				<th><cf_get_lang dictionary_id='38095.Giriş Depo'></th>
				<th><cf_get_lang dictionary_id='29428.Çıkış Depo'></th>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
			</thead>
			<cfif isdefined("attributes.is_form_submitted") and get_serial_no_.recordcount>
				<cfoutput query="get_serial_no_" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr height="30" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>&nbsp;#currentrow#</td>
						<td>&nbsp;#SERIAL_NO#</td>
						<td>&nbsp;#PROCESS_NUMBER#</td>
						<td>&nbsp;#dateformat(PROCESS_DATE,dateformat_style)#</td>
						<td>&nbsp;
							<cfif len(stock_id_list)>
								#get_product.STOCK_CODE[listfind(stock_id_list,stock_id,',')]#
							</cfif></td>
						<td>&nbsp;
							<cfif len(stock_id_list)>
								#get_product.PRODUCT_NAME[listfind(stock_id_list,stock_id,',')]#
							</cfif>
						</td>
						<td>&nbsp;
							<cfif len(p_order_id_list)>
								#get_project.PROJECT_HEAD[listfind(p_order_id_list,p_order_id,',')]#
							</cfif>
						</td>
						<td>&nbsp;
							<cfif len(dept_in_list)>
								#get_dept_in.DEPARTMENT_HEAD[listfind(dept_in_list,department_in,',')]#
							</cfif>
						</td>
						<td>&nbsp;
							<cfif len(dept_out_list)>
								#get_dept_out.DEPARTMENT_HEAD[listfind(dept_out_list,department_out,',')]#
							</cfif>
						</td>
						<td style="text-align:right">&nbsp;#QUANTITY#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr height="30" class="color-row"><td colspan="10"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td></tr>
			</cfif>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#get_serial_no_.recordcount#" 
				startrow="#attributes.startrow#" 
				adres="production.#fuseaction_##url_str#">
				<!-- sil -->
				<td align="right" style="text-align:right;font-size:14px"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# &nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
				<!-- sil -->
		</cfif>
	</cf_box>
</div>

