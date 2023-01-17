<cfset satir_sayisi=20>
<cfset satir_basla=1>
<cfset yazilan_satir=0>
<cfset genel_toplam = 0>
<cfquery name="GET_FIS_DET" datasource="#dsn2#">
	SELECT 
		STOCK_FIS.*,
		(SELECT STOCK_CODE FROM #dsn3_alias#.STOCKS S WHERE S.STOCK_ID = STOCK_FIS_ROW.STOCK_ID) AS STOCK_CODE,
		(SELECT BARCOD FROM #dsn3_alias#.STOCKS S WHERE S.STOCK_ID = STOCK_FIS_ROW.STOCK_ID) AS BARCOD,
		(SELECT PRODUCT_NAME FROM #dsn3_alias#.STOCKS S WHERE S.STOCK_ID = STOCK_FIS_ROW.STOCK_ID) AS PRODUCT_NAME,
		STOCK_FIS_ROW.*,
        CASE
			WHEN 
	    			STOCK_FIS.CONSUMER_ID IS NOT NULL 
			THEN
				(SELECT C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_ID = STOCK_FIS.CONSUMER_ID) 
			WHEN
    				STOCK_FIS.PARTNER_ID IS NOT NULL
			THEN 
		    		(SELECT C.NICKNAME +' - '+CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME FROM #dsn_alias#.COMPANY_PARTNER CP,#dsn_alias#.COMPANY C WHERE CP.PARTNER_ID = STOCK_FIS.PARTNER_ID AND CP.COMPANY_ID=C.COMPANY_ID)
			WHEN 
    				STOCK_FIS.EMPLOYEE_ID IS NOT NULL 
			THEN
				(SELECT E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES E WHERE E.EMPLOYEE_ID = STOCK_FIS.EMPLOYEE_ID) 
		END AS DELIVERED_TO 
	FROM 
		STOCK_FIS,
		STOCK_FIS_ROW
	WHERE 
		STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID
		AND STOCK_FIS.FIS_ID = #attributes.action_id#
	ORDER BY
		STOCK_FIS_ROW.STOCK_FIS_ROW_ID
</cfquery>
<cfset stock_id_list=''>
<cfoutput query="GET_FIS_DET">
	 <cfif not listfind(stock_id_list,get_fis_det.stock_id)>
		<cfset stock_id_list=listappend(stock_id_list,get_fis_det.stock_id)>
	 </cfif>
</cfoutput>
<cfset stock_id_list=listsort(stock_id_list,"numeric","ASC",",")>
<cfif GET_FIS_DET.recordcount>
	<cfset page=Ceiling((GET_FIS_DET.recordcount)/satir_sayisi)>
<cfelse>
	<cfset page=1>
</cfif>

<cfloop from="1" to="#page#" index="i">
<table border="0" cellspacing="0" cellpadding="0" style="width:210mm;height:290mm;">
<tr>
	<td style="width:7mm;">&nbsp;</td>
	<td valign="top">
	<table border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
			  <table>
			  <tr>
			  <td height="30" colspan="4" valign="top" class="headbold"></td>
			  </tr>
			  <tr>
				<td width="100" class="txtbold"><cf_get_lang_main no='1631.Çıkış Depo'> :</td>
				<td width="190">
					<cfif get_fis_det.fis_type neq 110 and get_fis_det.fis_type neq 115>
						<cfif  not  len(get_fis_det.LOCATION_out)>
							<cfset attributes.department_id =get_fis_det.DEPARTMENT_out >
							<cfset attributes.department_out_id=get_fis_det.DEPARTMENT_out>
						<cfelse>
							<cfset attributes.loc_id =	get_fis_det.LOCATION_out >
							<cfset attributes.department_id = get_fis_det.DEPARTMENT_out  >
							<cfset attributes.department_out_id = get_fis_det.DEPARTMENT_out &  '-' & get_fis_det.LOCATION_out>
						</cfif>
						<cfif len(attributes.department_id) >
							<cfif  isDefined('attributes.loc_id')>
								<cfquery name="GET_STORE_LOCATION" datasource="#DSN#">
									SELECT  
										D.DEPARTMENT_HEAD,
										SL.COMMENT
									FROM 
										DEPARTMENT D,
										STOCKS_LOCATION SL
									WHERE 
										D.IS_STORE=1
										AND D.DEPARTMENT_ID =SL.DEPARTMENT_ID
										AND SL.LOCATION_ID=#attributes.loc_id#  
										AND SL.DEPARTMENT_ID=#attributes.department_id#
								</cfquery>
							<cfelse>
								<cfquery name="GET_STORE_LOCATION" datasource="#DSN#">
									SELECT  
										D.DEPARTMENT_HEAD,
										'' AS COMMENT
									FROM 
										DEPARTMENT D
									WHERE 
										D.IS_STORE=1
										AND D.DEPARTMENT_ID = #attributes.department_id#
								</cfquery>
							</cfif>
						<cfset attributes.DEPARTMENT_OUT_NAME=GET_STORE_LOCATION.DEPARTMENT_HEAD & " " & GET_STORE_LOCATION.COMMENT >
						</cfif>
					</cfif>
					<cfif not isDefined("attributes.department_out_id") or NOT  len(attributes.department_out_id)>
						<cfset attributes.DEPARTMENT_OUT_NAME="">
						<cfset attributes.department_out_id="">
					</cfif>
					<cfoutput>#attributes.DEPARTMENT_OUT_NAME#</cfoutput>
					</td>
					<td width="100" class="txtbold"><cf_get_lang_main no='363.Teslim Alan'>:</td>
					<td><cfoutput>#get_fis_det.delivered_to[1]#</cfoutput></td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang_main no='534.Fiş No'> :</td>
					<td width="190"><cfoutput>#get_fis_det.fis_number#</cfoutput></td>
					<td class="txtbold"><cf_get_lang no='1268.Giriş Depo'> :</td>
					<td>
						<cfif get_fis_det.fis_type neq 111 and get_fis_det.fis_type neq 112>
							<cfif  not  len(get_fis_det.LOCATION_IN) >
								<cfset attributes.department_id =get_fis_det.department_in >
								<cfset attributes.department_in_id=get_fis_det.department_in>
							<cfelse>
								<cfset attributes.loc_id = get_fis_det.LOCATION_in >
								<cfset attributes.department_id = get_fis_det.department_in >
								<cfset attributes.department_in_id = get_fis_det.department_in &  '-' & get_fis_det.LOCATION_in>
							</cfif>
							<cfif len(attributes.department_in_id) >
								<cfif  isDefined('attributes.loc_id')>
									<cfquery name="GET_STORE_LOCATION" datasource="#DSN#">
										SELECT  
											D.DEPARTMENT_HEAD,
											SL.COMMENT
										FROM 
											DEPARTMENT D,
											STOCKS_LOCATION SL
										WHERE 
											D.IS_STORE=1
											AND D.DEPARTMENT_ID =SL.DEPARTMENT_ID
											AND SL.LOCATION_ID=#attributes.loc_id#  
											AND SL.DEPARTMENT_ID=#attributes.department_id#
									</cfquery>
								<cfelse>
									<cfquery name="GET_STORE_LOCATION" datasource="#DSN#">
										SELECT  
											D.DEPARTMENT_HEAD,
											'' AS COMMENT
										FROM 
											DEPARTMENT D
										WHERE 
											D.IS_STORE=1
											AND D.DEPARTMENT_ID = #attributes.department_id#
									</cfquery>
								</cfif>
							<cfset txt_department_in=GET_STORE_LOCATION.DEPARTMENT_HEAD & " " & GET_STORE_LOCATION.COMMENT>
							</cfif>
						</cfif>
						<cfif not isDefined("attributes.department_in_id") or NOT  len(attributes.department_in_id)>
						<cfset attributes.department_in_id="">
						<cfset txt_department_in="">
						</cfif>
						<cfoutput>#txt_department_in#</cfoutput>
					</td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang no='1669.Fiş Tarihi'> :</td>
					<td><cfif len(get_fis_det.record_date)><cfoutput>#dateformat(get_fis_det.record_date,dateformat_style)#</cfoutput></cfif></td>
					<td><span class="txtbold"><cf_get_lang_main no='1677.Emir No'> :</span></td>
					<td><cfif len(get_fis_det.PROD_ORDER_NUMBER)><cfoutput>#get_fis_det.PROD_ORDER_NUMBER#</cfoutput></cfif></td>
				</tr>
			</table>
			<br/>
			<br/>
		</td>
	</tr>
	<tr>
		<td valign="top">
			<table border="0" cellspacing="1" cellpadding="2" width="100%">
				<tr class="txtbold">
					<td height="22"> <cf_get_lang_main no='221.Barkod'></td>
					<td><cf_get_lang_main no="106.Stok Kodu"></td>
					<td> <cf_get_lang_main no='809.Ürün Adı'></td>
					<td style="text-align:right;"> <cf_get_lang_main no='223.Miktar'></td>
					<td style="text-align:right;"> <cf_get_lang_main no='224.Birim'></td>
					<td style="text-align:right;"> <cf_get_lang_main no='226.Birim Fiyat'></td>
					<td style="text-align:right;"> <cf_get_lang_main no='261.Tutar'></td>
				</tr>
				<cfoutput query="GET_FIS_DET" startrow="#satir_basla#" maxrows="#satir_sayisi#">
				<cfset yazilan_satir=yazilan_satir+1>
				<tr>
					<td style="width:28mm;">#barcod#</td>
					<td style="width:28mm;">#stock_code#</td>
					<td>#product_name#</td>
					<td style="text-align:right;">#amount#</td>
					<td style="text-align:right;">#unit#</td>
					<td style="text-align:right;">#tlformat(price)#</td>
					<td style="text-align:right;">#tlformat(total)#</td>
				</tr>
				<cfset genel_toplam = genel_toplam + total>
				</cfoutput>
			</table>
		</td>
	</tr>
	<td>
	<br/><br/>
	<cfif i eq page>
	<table border="0" style="width:170mm;" cellspacing="0" cellpadding="0">
		<tr>
		<td></td>
		<td style="text-align:right;">
		<cfoutput>
		<table>
			<tr>
				<td style="width:100mm;">
					<strong><cf_get_lang_main no="2220.Yalnız"> : </strong>
					<cfset mynumber = genel_toplam>
					<cfif session.ep.period_year eq 2004>
						<cf_n2txt number="mynumber" para_birimi="TL"> <cfoutput>#mynumber#</cfoutput> 'dir.
					<cfelse>
						<cf_n2txt number="mynumber"> <cfoutput>#mynumber#</cfoutput> 'dir.
					</cfif>
				</td>
				<td class="txtbold"><cf_get_lang_main no='268.Genel Toplam'></td>
				<td style="text-align:right;">&nbsp;#TLFormat(genel_toplam)#</td>
			</tr>
		</table>	
		</cfoutput>	   
		</td>
		</tr>
	</table>
	</cfif>
	</td>
	</tr>		  
	</table>
    </td>
   </tr>
</table>
<cfset satir_basla=satir_sayisi+satir_basla>
</cfloop>

