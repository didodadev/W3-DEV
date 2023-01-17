<cfquery name="GET_FIS_DET" datasource="#DSN2#">
	SELECT 
		STOCK_FIS.*,
		STOCK_FIS_ROW.* 
	FROM 
		STOCK_FIS,
		STOCK_FIS_ROW
	WHERE 
		STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID AND
		STOCK_FIS.FIS_ID = #attributes.UPD_ID#
</cfquery>
<cfif not get_fis_det.recordcount>
	<br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfset attributes.cat="">
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=stock.emptypopup_upd_fis_process" onsubmit="return (pre_submit());">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
	<td height="35">
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr class="color-list">
		<td height="35" class="headbold">
		<cfif get_fis_det.fis_type eq 110>Üretimden Çıkış Fişi</cfif>
		<cfif get_fis_det.fis_type eq 111>Sarf Fişi</cfif>
		<cfif get_fis_det.fis_type eq 112>Fire Fişi</cfif>
		<cfif get_fis_det.fis_type eq 113>Ambar Fişi</cfif>
		<cfif get_fis_det.fis_type eq 114> Devir Fişi</cfif>
		<cfif get_fis_det.fis_type eq 115> Sayım Fişi</cfif>
		<cfif get_fis_det.fis_type eq 119>Üretime Giriş Fişi</cfif>
		</td>
	  </tr>
	</table>
    </td>
  </tr>
  <tr>
	<td>
	<table cellspacing="0" cellpadding="0" border="0" width="98%" align="center" height="100%">
	  <tr class="color-border">
		<td>
		<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
		  <tr class="color-row">
			<td valign="top" height="50">
			<table>
			  <tr>
				<td class="txtbold">Fiş No</td>
				<td width="90"><cfoutput>#get_fis_det.fis_number#</cfoutput></td>
				<td width="70" class="txtbold">Fiş Tarihi</td>
				<td width="90"><cfoutput>#dateformat(get_fis_det.fis_date,dateformat_style)#</cfoutput>
				<td width="70" class="txtbold">Teslim Alan</td>
				<td width="90"><cfoutput>#get_emp_info(get_fis_det.employee_id,0,0)#</cfoutput></td>
				<td with="70" class="txtbold">Açıklama</td>
				<td rowspan="3" width="110"><cfoutput>#get_fis_det.FIS_DETAIL#</cfoutput></td>
			  </tr>
			  <tr>
				<td class="txtbold"><cf_get_lang_main no='1372.Ref No'></td>
				<td><cfoutput>#get_fis_det.ref_no#</cfoutput></td>
				<td class="txtbold"><cf_get_lang_main no='1631.Çıkış Depo'></td>
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
					  <cfinclude template="../query/get_store_location.cfm">
					  <cfset attributes.DEPARTMENT_OUT_NAME=get_store_location.department_head & " " & get_store_location.comment>
					</cfif>
				  </cfif>
				  <cfif not isDefined("attributes.department_out_id") or not len(attributes.department_out_id)>
					<cfset attributes.DEPARTMENT_OUT_NAME="">
					<cfset attributes.department_out_id="">
				  </cfif>
					<cfoutput>#attributes.DEPARTMENT_OUT_NAME#</cfoutput>	
				</td>
				<td class="txtbold"><cf_get_lang no='99.Emir No'></td>
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
					<cfif len(get_fis_det.prod_order_number)><cfoutput>#get_production_order.p_order_no#</cfoutput></cfif>				</td>
			  </tr>
			  <tr>
			  	<td></td>
				<td></td>
				<td class="txtbold"><cf_get_lang no='96.Giriş Depo'></td>
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
					  <cfinclude template="../query/get_store_location.cfm">
					  <cfset txt_department_in=get_store_location.department_head & " " & get_store_location.comment>
					</cfif>
				  </cfif>
				  <cfif not isDefined("attributes.department_in_id") or not len(attributes.department_in_id)>
					<cfset attributes.department_in_id="">
					<cfset txt_department_in="">
				  </cfif>
				  <cfoutput>#txt_department_in#</cfoutput>				</td>
				<td class="txtbold">
					<cfif session.ep.our_company_info.project_followup eq 1><cf_get_lang_main no='4.Proje'></cfif></td>
				<td>
				  <cfif session.ep.our_company_info.project_followup eq 1>
					<cfif len(get_fis_det.project_id)>
					  <cfquery name="GET_PROJECT" datasource="#DSN#">
						SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_fis_det.project_id#
					  </cfquery>
					  <cfoutput>#get_project.project_head#</cfoutput>
					</cfif>
				  </cfif>				
				  </td>
			  </tr>
			  <tr>
			  <tr></tr>
				<td colspan="5" class="txtbold">
				  <cfif len(get_fis_det.record_emp)><cf_get_lang_main no='71.Kayıt'> : <cfoutput>#get_emp_info(get_fis_det.record_emp,0,0)# #dateformat(date_add('h',session.ep.time_zone,get_fis_det.record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_fis_det.record_date),timeformat_style)#</cfoutput></cfif>
				  <br/><cfif len(get_fis_det.update_emp)>&nbsp;<cf_get_lang_main no='291.Son Güncelleme'> : <cfoutput>#get_emp_info(get_fis_det.update_emp,0,0)# #dateformat(date_add('h',session.ep.time_zone,get_fis_det.update_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_fis_det.update_date),timeformat_style)#</cfoutput></cfif>				</td>
				<td colspan="4">
					</td>
 				</tr>
				<tr>
					<td colspan="8" align="center"><input name="Button" id="Button" type="Button" style="width:65px;" onClick="window.close();" value="<cf_get_lang_main no='141.Kapat'>"></td>
				</tr>
			</table>
			  </td>
			</tr>
			<tr>
			  <td class="color-row"> 
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
				    <table width="100%"  border="0" cellspacing="1" cellpadding="2">
						<tr class="color-header">
							<td clasS="form-title" width="45">Stok Kodu</td>
							<td class="form-title" width="70">Barkod</td>
							<td clasS="form-title" width="70">Ürün Adı</td>
							<td clasS="form-title" width="70">Miktar</td>
							<td clasS="form-title" width="70">Birim</td>
							<td clasS="form-title" width="70">Spec</td>
						</tr>
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
			</table>
			  </td>
		  </tr>
		</table>
		</td>
	  </tr>
	</table>
	</td>
  </tr>
</table>
</cfform>
