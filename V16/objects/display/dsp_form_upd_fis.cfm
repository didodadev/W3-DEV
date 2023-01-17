<cfquery name="GET_FIS_DET" datasource="#DSN2#">
	SELECT 
		*
	FROM 
		STOCK_FIS,
		STOCK_FIS_ROW
	WHERE 
		STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID AND
		STOCK_FIS.FIS_ID = #attributes.UPD_ID#
</cfquery>
<cfif not get_fis_det.recordcount>
	<br/><font class="txtbold"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfset attributes.cat="">
<cfsavecontent variable="head">
	<cfif get_fis_det.fis_type eq 110><cf_get_lang dictionary_id='29627.Üretimden Çıkış Fişi'></cfif>
	<cfif get_fis_det.fis_type eq 111><cf_get_lang dictionary_id='29628.Sarf Fişi'></cfif>
	<cfif get_fis_det.fis_type eq 112><cf_get_lang dictionary_id='29629.Fire Fişi'></cfif>
	<cfif get_fis_det.fis_type eq 113><cf_get_lang dictionary_id='29630.Ambar Fişi'></cfif>
	<cfif get_fis_det.fis_type eq 114><cf_get_lang dictionary_id='29631.Devir Fişi'></cfif>
	<cfif get_fis_det.fis_type eq 115><cf_get_lang dictionary_id='29632.Sayım Fişi'> </cfif>
	<cfif get_fis_det.fis_type eq 119><cf_get_lang dictionary_id='34060.Üretime Giriş Fişi'></cfif>
</cfsavecontent>
<cf_popup_box title='#head#'>
	<cfform name="form_basket" method="post" action="#request.self#?fuseaction=stock.emptypopup_upd_fis_process" onsubmit="return pre_submit();">
		<table>
			<tr>
				<td class="txtbold"><cf_get_lang dictionary_id='57946.Fiş No'></td>
				<td width="90"><cfoutput>#get_fis_det.fis_number#</cfoutput></td>
				<td width="70" class="txtbold"><cf_get_lang dictionary_id ='34059.Fiş Tarihi'></td>
				<td width="90"><cfoutput>#dateformat(get_fis_det.fis_date,dateformat_style)#</cfoutput>
				<td width="70" class="txtbold"><cf_get_lang dictionary_id='57775.Teslim Alan'></td>
				<td width="90"><cfoutput>#get_emp_info(get_fis_det.employee_id,0,0)#</cfoutput></td>
				<td with="70" class="txtbold"><cf_get_lang dictionary_id ='57629.Açıklama'></td>
				<td rowspan="3" width="110"><cfoutput>#get_fis_det.FIS_DETAIL#</cfoutput></td>
			</tr>
			<tr>
				<td class="txtbold"><cf_get_lang dictionary_id='58784.Referans'></td>
				<td><cfoutput>#get_fis_det.ref_no#</cfoutput></td>
				<td class="txtbold"><cf_get_lang dictionary_id='29428.Çıkış Depo'></td>
				<td>
					<cfif get_fis_det.fis_type neq 110 and get_fis_det.fis_type neq 115>
						<cfif not len(get_fis_det.location_out)>
							<cfset attributes.department_id = get_fis_det.department_out>
							<cfset attributes.department_out_id = get_fis_det.department_out>
						<cfelse>
							<cfset attributes.loc_id = get_fis_det.location_out>
							<cfset attributes.department_id = get_fis_det.department_out>
							<cfset attributes.department_out_id = get_fis_det.department_out &  '-' & get_fis_det.location_out>
						</cfif>
						<cfif len(attributes.department_id)>
							<cfif isDefined('attributes.loc_id') and len(attributes.loc_id)>
								<cfquery name="GET_STORE_LOCATION" datasource="#DSN#">
									SELECT  
										D.DEPARTMENT_HEAD,
										SL.COMMENT
									FROM 
										DEPARTMENT D,
										STOCKS_LOCATION SL
									WHERE 
										D.IS_STORE <> 2
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
										D.IS_STORE <> 2
										AND D.DEPARTMENT_ID = #attributes.department_id#
								</cfquery>
							</cfif>
							  <cfset attributes.DEPARTMENT_OUT_NAME=get_store_location.department_head & " " & get_store_location.comment>
						</cfif>
					</cfif>
					<cfif not isDefined("attributes.department_out_id") or not len(attributes.department_out_id)>
						<cfset attributes.DEPARTMENT_OUT_NAME="">
						<cfset attributes.department_out_id="">
					</cfif>
					<cfoutput>#attributes.DEPARTMENT_OUT_NAME#</cfoutput>	
				</td>
				<td class="txtbold"><cf_get_lang dictionary_id ='34057.Üretim Emir No'></td>
				<td>
					<cfif len(get_fis_det.prod_order_number)>
						<cfquery name="GET_PRODUCTION_ORDER" datasource="#DSN3#">
							SELECT
								P_ORDER_NO
							FROM
								PRODUCTION_ORDERS
							WHERE
								P_ORDER_ID = #get_fis_det.prod_order_number#
						</cfquery>
					</cfif>
					<cfif len(get_fis_det.prod_order_number)><cfoutput>#get_production_order.p_order_no#</cfoutput></cfif>
				</td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td class="txtbold"><cf_get_lang dictionary_id ='33658.Giriş Depo'></td>
				<td>
					<cfif get_fis_det.fis_type neq 111 and get_fis_det.fis_type neq 112>
						<cfif  not  len(get_fis_det.location_in)>
							<cfset attributes.department_id =get_fis_det.department_in>
							<cfset attributes.department_in_id=get_fis_det.department_in>
						<cfelse>
							<cfset attributes.loc_id = get_fis_det.location_in>
							<cfset attributes.department_id = get_fis_det.department_in>
							<cfset attributes.department_in_id = get_fis_det.department_in &  '-' & get_fis_det.location_in>
						</cfif>
						<cfif len(attributes.department_in_id) >
							<cfif isDefined('attributes.loc_id') and len(attributes.loc_id)>
							<cfquery name="GET_STORE_LOCATION" datasource="#DSN#">
									SELECT  
										D.DEPARTMENT_HEAD,
										SL.COMMENT
									FROM 
										DEPARTMENT D,
										STOCKS_LOCATION SL
									WHERE 
										D.IS_STORE <> 2
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
										D.IS_STORE <> 2
										AND D.DEPARTMENT_ID = #attributes.department_id#
								</cfquery>
							</cfif>
							<cfset txt_department_in=get_store_location.department_head & " " & get_store_location.comment>
						</cfif>
					</cfif>
					<cfif not isDefined("attributes.department_in_id") or not len(attributes.department_in_id)>
						<cfset attributes.department_in_id="">
						<cfset txt_department_in="">
					</cfif>
					<cfoutput>#txt_department_in#</cfoutput>
				</td>
				<td class="txtbold">
					<cfif session.ep.our_company_info.project_followup eq 1><cf_get_lang dictionary_id='57416.Proje'></cfif>
				</td>
				<td>
					<cfif session.ep.our_company_info.project_followup eq 1>
						<cfif len(get_fis_det.project_id)>
							<cfquery name="GET_PROJECT" datasource="#DSN#">
								SELECT 
									PROJECT_HEAD 
								FROM 
									PRO_PROJECTS 
								WHERE 
									PROJECT_ID = #get_fis_det.project_id#
							</cfquery>
							<cfoutput>#get_project.project_head#</cfoutput>
						</cfif>
					</cfif>				
				</td>
			</tr>
		</table>
			<cfquery name="GET_FIS_DETAIL" datasource="#DSN2#">
				SELECT
					SF.*,
					SFR.*,
					S.*
				FROM
					STOCK_FIS SF,
					STOCK_FIS_ROW SFR,
					#dsn3_alias#.STOCKS S
				WHERE
					SF.FIS_ID = SFR.FIS_ID AND
					SF.FIS_ID=#attributes.upd_id# AND
					SFR.STOCK_ID=S.STOCK_ID
				ORDER BY
					STOCK_FIS_ROW_ID
			</cfquery>
		<cf_medium_list>
			<thead>
				<tr>
					<th width="45"><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
					<th width="70"><cf_get_lang dictionary_id ='57633.Barkod'></th>
					<th width="70"><cf_get_lang dictionary_id ='58221.Ürün Adı'></th>
					<th width="70"><cf_get_lang dictionary_id ='57635.Miktar'></th>
					<th width="70"><cf_get_lang dictionary_id ='57636.Birim'></th>
					<th width="70"><cf_get_lang dictionary_id ='34299.Spec'></th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="GET_FIS_DETAIL">
					<tr>
						<td>#stock_code#</td>
						<td>#barcod#</td>
						<td>#product_name#</td>
						<td>#amount#</td>
						<td>#unit#</td>
						<td>#spect_var_name#</td>
					</tr>
				</cfoutput>
			</tbody>
		</cf_medium_list>
		<cf_popup_box_footer>
			<cf_record_info query_name="get_fis_det">
			<table style="text-align:right;">
				<tr>
					<td colspan="8" align="center"><input name="Button" id="Button" type="Button" style="width:65px;" onClick="window.close();" value="<cf_get_lang dictionary_id='57553.Kapat'>"></td>
				</tr>
			</table>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
