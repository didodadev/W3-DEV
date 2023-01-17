<cfsetting showdebugoutput="no">
<cfparam name="attributes.start_date" default="#now()#" >
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.department_id" default=1>
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.product_cat" default="">
<cfif isdefined("attributes.is_submitted")>
	<cf_date tarih = "attributes.start_date">
	<cfquery name="get_fileimports_total_sayim" datasource="#DSN2#">
		SELECT 
			FITS.FILE_AMOUNT,
			FITS.STOCK_AMOUNT,
			FITS.SPECT_MAIN_ID,
			S.STOCK_CODE,
			S.PRODUCT_NAME,
			S.PRODUCT_ID,
			(SELECT SM.SPECT_MAIN_NAME FROM #dsn3_alias#.SPECT_MAIN SM WHERE SM.SPECT_MAIN_ID = FITS.SPECT_MAIN_ID) SPECT_MAIN_NAME,
			ISNULL((SELECT
							TOP 1 (PURCHASE_NET_SYSTEM_LOCATION + PURCHASE_EXTRA_COST_SYSTEM_LOCATION)  
						FROM 
							#dsn3_alias#.PRODUCT_COST GPCP
						WHERE
							GPCP.START_DATE <= FITS.PROCESS_DATE
							AND GPCP.PRODUCT_ID = S.PRODUCT_ID
							AND ISNULL(GPCP.PRODUCT_ID,0) = ISNULL(FITS.SPECT_MAIN_ID,0)
							<cfif listlen(attributes.department_id,'-') eq 1>
								AND GPCP.DEPARTMENT_ID = #attributes.department_id#
							<cfelse>
								AND GPCP.DEPARTMENT_ID = #listfirst(attributes.department_id,'-')#
								AND GPCP.LOCATION_ID = #listlast(attributes.department_id,'-')#
							</cfif>
					ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC, GPCP.PURCHASE_NET_SYSTEM DESC
							),0) AS TOTAL_COST	
		FROM
			FILE_IMPORTS_TOTAL FITS,
			#dsn3_alias#.STOCKS S
		WHERE
			FITS.STOCK_ID = S.STOCK_ID
			AND FITS.PROCESS_DATE =  #attributes.start_date# AND
			ISNULL(FITS.IS_ALL,0)=1
			<cfif len(attributes.product_catid) and len(attributes.product_cat)>
				AND FITS.PRODUCT_CATID = #attributes.product_catid#
			</cfif>
			<cfif listlen(attributes.department_id,'-') eq 1>
				AND FITS.DEPARTMENT_ID = #attributes.department_id#
			<cfelse>
				AND FITS.DEPARTMENT_ID = #listfirst(attributes.department_id,'-')#
				AND FITS.DEPARTMENT_LOCATION = #listlast(attributes.department_id,'-')#
			</cfif>
		UNION ALL
		SELECT
			0 FILE_AMOUNT,
			ISNULL(SUM(STOCK_IN-STOCK_OUT),0) STOCK_AMOUNT,
			'' SPECT_MAIN_ID,
			S.STOCK_CODE,
			S.PRODUCT_NAME,
			S.PRODUCT_ID,
			'' SPECT_MAIN_NAME,
			ISNULL((SELECT
							TOP 1 (PURCHASE_NET_SYSTEM_LOCATION + PURCHASE_EXTRA_COST_SYSTEM_LOCATION)  
						FROM 
							#dsn3_alias#.PRODUCT_COST GPCP
						WHERE
							GPCP.START_DATE <= #attributes.start_date#
							AND GPCP.PRODUCT_ID = S.PRODUCT_ID
							<cfif listlen(attributes.department_id,'-') eq 1>
								AND GPCP.DEPARTMENT_ID = #attributes.department_id#
							<cfelse>
								AND GPCP.DEPARTMENT_ID = #listfirst(attributes.department_id,'-')#
								AND GPCP.LOCATION_ID = #listlast(attributes.department_id,'-')#
							</cfif>
						ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC, GPCP.PURCHASE_NET_SYSTEM DESC
							),0) AS TOTAL_COST
		FROM
			STOCKS_ROW GS,
			#dsn3_alias#.STOCKS S
		WHERE
			GS.STOCK_ID = S.STOCK_ID
			<cfif listlen(attributes.department_id,'-') eq 1>
				AND GS.STORE = #attributes.department_id#
			<cfelse>
				AND GS.STORE = #listfirst(attributes.department_id,'-')#
				AND GS.STORE_LOCATION = #listlast(attributes.department_id,'-')#
			</cfif>	
			<cfif len(attributes.product_catid) and len(attributes.product_cat)>
				AND S.STOCK_CODE LIKE (SELECT PC.HIERARCH FROM #dsn3_alias#.PRODUCT_CAT PC WHERE PC.PRODUCT_CATID = #attributes.product_catid#)+'.%'
			</cfif>		
			AND GS.PROCESS_DATE <=  #attributes.start_date#
			AND GS.STOCK_ID NOT IN
			(
				SELECT 
					FITS.STOCK_ID
				FROM
					FILE_IMPORTS_TOTAL FITS
				WHERE
					FITS.PROCESS_DATE =  #attributes.start_date# AND
					ISNULL(FITS.IS_ALL,0)=1
					<cfif len(attributes.product_catid) and len(attributes.product_cat)>
						AND FITS.PRODUCT_CATID = #attributes.product_catid#
					</cfif>
					<cfif listlen(attributes.department_id,'-') eq 1>
						AND FITS.DEPARTMENT_ID = #attributes.department_id#
					<cfelse>
						AND FITS.DEPARTMENT_ID = #listfirst(attributes.department_id,'-')#
						AND FITS.DEPARTMENT_LOCATION = #listlast(attributes.department_id,'-')#
					</cfif>
			)
		GROUP BY
			S.STOCK_CODE,
			S.PRODUCT_NAME,
			S.PRODUCT_ID
		ORDER BY
			S.STOCK_CODE
	</cfquery>
<cfelse>
	<cfset get_fileimports_total_sayim.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_fileimports_total_sayim.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdate(attributes.start_date)>
	<cfset attributes.start_date = dateformat(attributes.start_date, "dd/mm/yyyy")>
</cfif>
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT 
		D.DEPARTMENT_HEAD,
		SL.DEPARTMENT_ID,
		SL.LOCATION_ID,
		SL.STATUS,
		SL.COMMENT
	FROM 
		STOCKS_LOCATION SL,
		DEPARTMENT D,
		BRANCH B
	WHERE
		D.IS_STORE <> 2 AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.DEPARTMENT_STATUS = 1 AND
		D.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		<cfif session.ep.our_company_info.is_location_follow eq 1>
			AND
			(
				CAST(D.DEPARTMENT_ID AS NVARCHAR) + '-' + CAST(SL.LOCATION_ID AS NVARCHAR) IN (SELECT LOCATION_CODE FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
				OR
				D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# AND LOCATION_ID IS NULL)
			)
		</cfif>
	ORDER BY
		D.DEPARTMENT_HEAD,
		COMMENT
</cfquery>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_fileimports_total_sayim.recordcount>
</cfif>
<table width="100%" cellpadding="0" cellspacing="0" border="0" height="100%">
	<tr>
		<td valign="top"> 
			<cfform name="list_sayimlar" method="post" action="">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
				<cf_big_list_search title="Sayım Karşılaştırma"> 
					<cf_big_list_search_area>
						<table>
							<tr>		  
								<td><cf_get_lang_main no ='467.İşlem Tarihi'></td>
									<cfsavecontent variable="message"><cf_get_lang_main no ='641.Başlangıç Tarihi'></cfsavecontent>
								<td><cfinput type="text" name="start_date" value="#attributes.start_date#" style="width:65px;" validate="eurodate" maxlength="10" message="#message#" required="yes">
									<cf_wrk_date_image date_field="start_date"> </td>
								<td><cf_get_lang_main no='1351.Depo'></td>
								<td>
									<select name="department_id" id="department_id" style="width:250px">
										<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
										<cfoutput query="get_all_location" group="department_id">
											<option value="#department_id#"<cfif attributes.department_id eq department_id> selected</cfif>>#department_head#</option>
										<cfoutput>
											<option <cfif not status>style="color:##FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_id eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#<cfif not status> - <cf_get_lang_main no='82.Pasif'></cfif></option>
										</cfoutput>
										</cfoutput>
									</select>	
								</td>
								<td>
									<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
									<cfinput type="text" name="maxrows" style="width:25px;" onKeyUp="isNumber(this)" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
								</td>
								<td>	
									<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>>
								</td>
								<td><cf_get_lang_main no='446.Excel Getir'></td>
								<td><cf_wrk_search_button is_excel='0' search_function='kontrol_form()'></td>
							</tr>
						</table>
					</cf_big_list_search_area>
				</cf_big_list_search>
			</cfform>
			<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
				<cfset filename = "#createuuid()#">
				<cfheader name="Expires" value="#Now()#">
				<cfcontent type="application/vnd.msexcel;charset=utf-8">
				<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
				<meta http-equiv="content-type" content="text/plain; charset=utf-8">
			</cfif>
			<cf_big_list> 
				<thead>
					<tr>
						<th width="20"><cf_get_lang_main no='75.No'></th>
						<th width="100"><cf_get_lang_main no='106.Stok Kodu'></th>
						<th width="200"><cf_get_lang_main no='245.Ürün'></th>
						<th width="80" style="text-align:right;">Mevcut Stok</th>
						<th width="50" style="text-align:right;">Sayım</th>
						<th width="50" style="text-align:right;"><cf_get_lang_main no='1171.Fark'></th>
						<th width="50" nowrap="nowrap" style="text-align:right;">Birim maliyet</th>
					</tr>
				</thead>
				<tbody>
					<cfif get_fileimports_total_sayim.recordcount>	
						<cfoutput query="get_fileimports_total_sayim" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td>#currentrow#</td>
								<td width="120">#stock_code#</td>
								<td width="300">
									<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
										#product_name#
									<cfelse>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','large');" class="tableyazi">#product_name#</a>
									</cfif>
								</td>
								<td style="text-align:right" nowrap>#tlformat(stock_amount)#</td>
								<td style="text-align:right" nowrap>#tlformat(file_amount)#</td>
								<td style="text-align:right" nowrap>#tlformat(file_amount-stock_amount)#</td>
								<td style="text-align:right" nowrap>#tlformat(total_cost)#</td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr class="color-row" height="20">
							<td colspan="7"><cfif isdefined("attributes.is_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no ='289.Filtre Ediniz'>!</cfif></td>
						</tr>
					</cfif>
				</tbody>
			</cf_big_list> 
			<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
				<cfset url_string = ''>
				<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
					<cfset url_string = '#url_string#&start_date=#attributes.start_date#&is_submitted=1'>
				</cfif>
				<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
					<cfset url_string = '#url_string#&department_id=#attributes.department_id#'>
				</cfif>
				<cfif isdefined("attributes.product_catid") and len(attributes.product_catid)>
					<cfset url_string = '#url_string#&product_catid=#attributes.product_catid#'>
				</cfif>
				<cfif isdefined("attributes.product_cat") and len(attributes.product_cat)>
					<cfset url_string = '#url_string#&product_cat=#attributes.product_cat#'>
				</cfif>
				<table width="99%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
					<tr>
						<td>
						<cf_pages page="#attributes.page#"
							maxrows="#attributes.maxrows#"
							totalrecords="#attributes.totalrecords#"
							startrow="#attributes.startrow#"
							adres="retail.list_fileimports_report#url_string#">
						</td>
					  <!-- sil --><td style="text-align:right"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
					</tr>
				</table>
			</cfif>
		</td>
	</tr>
</table>
<script type="text/javascript">
	function kontrol_form()
	{
		if(document.list_sayimlar.department_id.value == '')
		{
			alert("<cf_get_lang no='61.Lütfen Depo Seçiniz!'>");
			return false;
		}
		if(document.list_sayimlar.is_excel.checked==false)
		{
			document.list_sayimlar.action="<cfoutput>#request.self#?fuseaction=retail.list_fileimports_report</cfoutput>";
			return true;
		}
		else
		{
			document.list_sayimlar.action="<cfoutput>#request.self#?fuseaction=retail.emptypopup_list_fileimports_report</cfoutput>";
			document.list_sayimlar.submit();
			return false;
		}
	}
</script>