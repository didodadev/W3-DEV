<cfquery name="get_orders" datasource="#dsn2#">
	SELECT
		SRR.*,
		SR.*,
		SM.SHIP_METHOD
	FROM
		SHIP_RESULT SR,
		SHIP_RESULT_ROW SRR,
		SHIP S,
		#dsn3_alias#.ORDERS_SHIP OS,
		#dsn_alias#.SHIP_METHOD SM
	WHERE
		OS.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND
		OS.SHIP_ID = S.SHIP_ID AND
		SR.SHIP_RESULT_ID = SRR.SHIP_RESULT_ID AND
		SRR.SHIP_ID = S.SHIP_ID AND
		SR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID
</cfquery>
<cfset result_list = listsort(listdeleteduplicates(valuelist(get_orders.SHIP_RESULT_ID,',')),'numeric','ASC',',')>
<cfif get_orders.recordcount>
<cfloop list="#result_list#" index="rl">
<cfquery name="get_sevkiyat" dbtype="query" maxrows="1">
	SELECT * FROM get_orders WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rl#">
</cfquery>
<cfquery name="get_this_orders" dbtype="query">
	SELECT * FROM get_orders WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rl#">
</cfquery>	
	
<table>
	<tr>
		<td height="25" class="formbold" colspan="6"><cf_get_lang no='470.Sevkiyatlar'>: <cfif isdefined("get_order_det.order_number")><cfoutput>#get_order_det.order_number#</cfoutput></cfif></td>
	</tr>
	<tr>
	<cfoutput query="get_sevkiyat">
		<td class="txtbold" width="80"><cf_get_lang no='454.Sevkiyat No'></td>
		<td width="150">#ship_fis_no#</td>
		<td class="txtbold" width="80"><cf_get_lang_main no='1641.Çıkış Tarihi'></td>
		<td width="150">#dateformat(out_date,'dd/mm/yyyy')# #timeformat(out_date,'HH:MM')#</td>
		<td class="txtbold" width="80">Araç</td>
		<td>
			<cfif len(assetp_id)>
				<cfquery name="GET_ASSETP" datasource="#DSN#">
					SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#assetp_id#">
				</cfquery>
				#get_assetp.assetp#
			</cfif>
		</td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang_main no='304.Taşıyıcı'></td>
		<td>#get_par_info(service_company_id,1,0,0)#</td>
		<td class="txtbold"><cf_get_lang no='455.Teslim Eden'></td>
		<td>#get_emp_info(deliver_pos,0,0)#</td>
		<td class="txtbold"><cf_get_lang no='481.Araç Yetkilisi'></td>
		<td><cfif len(deliver_emp)>#get_emp_info(deliver_emp,0,0)#</cfif></td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang no='471.Taşıyıcı Belge No'></td>
		<td>#deliver_paper_no#</td>
		<td class="txtbold"><cf_get_lang_main no='1631.Çıkış Depo'></td>
		<td>
			<cfif len(department_id)>
				<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
					SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#">
				</cfquery>
				#get_department.department_head#
			</cfif>
		</td>
		<td class="txtbold"><cf_get_lang_main no='1656.Plaka'></td>
		<td>#plate#</td>
	</tr>
	<tr>
		<td class="txtbold"><cf_get_lang_main no='1703.Sevk Yöntemi'></td>
		<td>#ship_method#</td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
	</tr>
	</table>
	</cfoutput>
	
	
	<table cellpadding="2" cellspacing="1" width="100%">
		<tr>
			<td height="25" class="formbold"><cf_get_lang no='474.İrsaliyeler'></td>
		</tr>
	</table>
	<table cellpadding="2" cellspacing="1" width="100%">	
		<tr class="color-header" height="22">
			<td class="form-title" width="90"><cf_get_lang_main no='726.İrsaliye No'></td>
			<td class="form-title" width="70"><cf_get_lang no='476.Sevk Tarihi'></td>
			<td class="form-title" width="150"><cf_get_lang_main no='1703.Sevk Yöntemi'></td>
			<td class="form-title"><cf_get_lang no='477.Sevk Adresi'></td>
		</tr>
		<cfif get_this_orders.recordcount>
			<cfoutput query="get_this_orders">
			<tr class="color-row">
				<td>#ship_number#</td>
				<td>#dateformat(ship_date,'dd/mm/yyyy')#</td>
				<td>#deliver_type#</td>
				<td>#deliver_adress#</td>
			</tr>
			</cfoutput>
		<cfelse>
			<tr class="color-row"><td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td></tr>
		</cfif>
	</table>
	<cfquery name="GET_PACKAGE" datasource="#DSN2#">
		SELECT 
			SRP.PACKAGE_PIECE,
			SRP.PACKAGE_WEIGHT,
			SRP.BARCODE,
			SPT.PACKAGE_TYPE,
			SPT.DIMENTION
		FROM 
			SHIP_RESULT_PACKAGE SRP,
			#dsn_alias#.SETUP_PACKAGE_TYPE SPT
		WHERE 
			SRP.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sevkiyat.ship_result_id#"> AND
			SPT.PACKAGE_TYPE_ID = SRP.PACKAGE_TYPE
	</cfquery>
		  
	<table cellpadding="2" cellspacing="1" width="100%">
		<tr>
			<td height="25" class="formbold">Paketler</td>
		</tr>
	</table>
	<table cellpadding="2" cellspacing="1" width="100%">	
		<tr class="color-header" height="22">
			<td class="form-title" width="110"><cf_get_lang_main no='670.Adet'></td>
			<td class="form-title" width="90"><cf_get_lang no='478.Paket Tipi'></td>
			<td class="form-title" width="125"><cf_get_lang no='479.Ebat'></td>
			<td class="form-title" width="200"><cf_get_lang_main no='1987.Ağırlık'></td>
			<td class="form-title" width="200"><cf_get_lang_main no='221.Barkod'></td>
		</tr>
		<cfif GET_PACKAGE.recordcount>
			<cfoutput query="GET_PACKAGE">
			<tr class="color-row">
				<td>#tlformat(package_piece,0)#</td>
				<td>#package_type#</td>
				<td>#dimention#</td>
				<td>#tlformat(package_weight)#</td>
				<td>#barcode#</td>
			</tr>
			</cfoutput>
			<tr><td colspan="6"><hr></td></tr>
		<cfelse>
			<tr class="color-row"><td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td></tr>
		</cfif>
	</table>
</cfloop>
<cfelse>
	<table cellpadding="3" cellspacing="3" class="color-row" width="100%">
	<tr>
		<td>Sevkiyat Bilgisi Bulunamadı!</td>
	</tr>
	</table>
</cfif>

