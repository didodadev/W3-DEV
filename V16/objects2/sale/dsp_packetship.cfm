<cfquery name="GET_SHIP_RESULT" datasource="#DSN2#">
	SELECT
		SR.*,
		SM.SHIP_METHOD
	FROM
		SHIP_RESULT SR,
		#dsn_alias#.SHIP_METHOD SM
	WHERE
		SR.SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#"> AND
		SR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID
</cfquery>
<cfif not get_ship_result.recordcount or not len(get_ship_result.service_company_id)>
	<br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'>!</font>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="GET_SHIP_METHOD_PRICE" datasource="#DSN#">
	SELECT 
		*
	FROM 
		SHIP_METHOD_PRICE
	WHERE 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.service_company_id#">
</cfquery>
<!--- Eger ilgili hesap yontemine ait kayit yoksa --->
<cfsavecontent variable="message"><cf_get_lang no ='1457.Şirketine Ait Bir Taşıyıcı Kaydı Yok,Lütfen Kayıtlarınızı Kontrol Ediniz'></cfsavecontent>
<cfif not get_ship_method_price.recordcount>
	<script type="text/javascript">
		alert('<cfoutput>#get_par_info(get_ship_result.service_company_id,1,0,0)#'+' #message#</cfoutput>' );
		window.location.href="<cfoutput>#request.self#?</cfoutput>fuseaction=objects2.list_packetship"
	</script>
</cfif>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr class="color-border">
		<td valign="top">
		<table width="100%" align="center" cellpadding="2" cellspacing="1" border="0">
	  		<tr class="color-row">
				<td>
				<table>
					<tr height="20">
						<td class="txtbold" width="100"><cf_get_lang no ='454.Sevkiyat No'></td>
						<td width="180"><cfoutput>#get_ship_result.ship_fis_no#</cfoutput></td>
						<td width="100" class="txtbold"><cf_get_lang_main no='70.Aşama'></td>
						<td width="180">
							<cfquery name="get_process_type" datasource="#dsn#">
								SELECT STAGE,PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.ship_stage#">
							</cfquery>
							<cfoutput>#get_process_type.stage#</cfoutput>
						</td>
					</tr>
				  	<tr height="20">
						<td class="txtbold"><cf_get_lang_main no='1703.Sevk Yöntemi'></td>
						<td><cfoutput>#get_ship_result.ship_method#</cfoutput></td>
						<td class="txtbold"><cf_get_lang_main no='1631.Çıkış Depo'></td>
						<td><cfoutput>#dateformat(get_ship_result.out_date,'dd/mm/yyyy')# - #hour(get_ship_result.out_date)#:#minute(get_ship_result.out_date)#</cfoutput></td>
				  	</tr>
				  	<tr height="20">
						<td class="txtbold"><cf_get_lang_main no='304.Taşıyıcı'></td>
						<td><cfoutput>#get_par_info(get_ship_result.service_company_id,1,0,0)#</cfoutput></td>
						<td class="txtbold"><cf_get_lang_main no='233.Teslim Tarih'></td>
						<td><cfif len(get_ship_result.delivery_date)>
								<cfoutput>#dateformat(get_ship_result.delivery_date,'dd/mm/yyyy')# - #hour(get_ship_result.delivery_date)#:#minute(get_ship_result.delivery_date)#</cfoutput>
							</cfif>
						</td>
				  	</tr>
				  	<tr height="20">
						<td class="txtbold"><cf_get_lang no ='1462.Taşıyıcı Yetkilisi'></td>
						<td><cfoutput>#get_par_info(get_ship_result.service_member_id,0,-1,0)#</cfoutput></td>
						<td class="txtbold"><cf_get_lang no ='455.Teslim Eden'></td>
						<td><cfoutput>#get_emp_info(get_ship_result.deliver_pos,0,0)#</cfoutput></td>
					</tr>
					<tr height="20">
						<td class="txtbold"><cf_get_lang_main no='1631.Çıkış Depo'></td>
						<td><cfif len(get_ship_result.department_id)>
								<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
									SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.department_id#">
								</cfquery>
								<cfoutput>#get_department.department_head#</cfoutput>
							</cfif>
						</td>
						<td class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
						<td><cfoutput>#get_ship_result.note#</cfoutput></td>
					</tr>
				  	<tr height="20">
						<td class="txtbold"><cf_get_lang no ='1461.Maliyet Tutarı'></td>
						<td><cfoutput>#TlFormat(get_ship_result.cost_value)#</cfoutput>&nbsp;<cfoutput>#session.pp.money#</cfoutput>&nbsp;&nbsp;
					  		<cfoutput>#TlFormat(get_ship_result.cost_value2)#</cfoutput>&nbsp;<cfoutput>#session.pp.money2#</cfoutput>
						</td>			
				  	</tr>
					<tr height="20">
						<td class="txtbold"><cf_get_lang_main no='1311.Adres'></td>
						<td colspan="3">
							<cfoutput>
								#get_ship_result.sending_address# 
								<cfif len(get_ship_result.sending_postcode)> - #get_ship_result.sending_postcode#</cfif>
								<cfif len(get_ship_result.sending_semt)>- #get_ship_result.sending_semt#</cfif>
								<cfif len(get_ship_result.sending_county_id)>
									<cfquery name="GET_COUNTY" datasource="#DSN#">
										SELECT * FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.sending_county_id#">
									</cfquery>					
									 - #get_county.county_name#
								 </cfif>
								<cfif len(get_ship_result.sending_city_id)>
									<cfquery name="GET_CITY" datasource="#DSN#">
										SELECT CITY_NAME,CITY_ID FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.sending_city_id#">
									</cfquery>
									- #get_city.city_name#						
								</cfif>
								<cfif len(get_ship_result.sending_country_id)>
									<cfquery name="GET_COUNTRY" datasource="#DSN#">
										SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.sending_country_id#">
									</cfquery>
									- #get_country.country_name#
								</cfif>
							</cfoutput>
						</td>
					</tr>
				</table>
				</td>
	  		</tr>
			<cfquery name="GET_ROW" datasource="#DSN2#">
				SELECT * FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#">
			</cfquery>
			<tr class="color-row">
				<td>
				<table id="table1">
					<tr class="color-list" height="20">
						<td width="75" class="txtbold"><cfif get_ship_result.is_type neq 2><cf_get_lang_main no='726.İrsaliye No'><cfelse><cf_get_lang_main no ='199.Sipariş'>No</cfif></td>
						<td width="90" class="txtbold"><cf_get_lang_main no ='330.Tarih'></td>
						<td width="120" class="txtbold"><cf_get_lang_main no='1321.Alıcı'></td>
						<td width="100" class="txtbold"><cf_get_lang_main no='1703.Sevk Yöntemi'></td>
						<td width="300" class="txtbold"><cf_get_lang_main no='1311.Adres'></td>
					</tr>
				<cfoutput query="get_row">
				  	<tr id="frm_row#currentrow#">
					<cfif get_ship_result.is_type neq 2>
						<cfquery name="GET_SHIP" datasource="#DSN2#">
							SELECT SHIP_NUMBER FROM SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_id#">
						</cfquery>
					<cfelse>		
						<cfquery name="GET_SHIP" datasource="#DSN3#">
							SELECT ORDER_NUMBER SHIP_NUMBER FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_id#">
						</cfquery>
					</cfif>
						<td>#get_ship.ship_number#</td>
						<td>#dateformat(ship_date,'dd/mm/yyyy')#</td>
						<td>#DELIVER_COMP#</td>
						<td>#deliver_type#</td>
						<td>#deliver_adress#</td>
					</tr>
				</cfoutput>
				</table>
				</td>
			</tr>
			<cfquery name="GET_PACKAGE" datasource="#DSN2#">
				SELECT
					SRP.*,
					'' PACK_NAME
				FROM
					SHIP_RESULT_PACKAGE SRP
				WHERE 
					SRP.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#"> AND
					PACK_EMP_ID IS NULL
				UNION ALL
				SELECT
					SRP.*,
					<cfif (database_type is 'MSSQL')>
					EMPLOYEES.EMPLOYEE_NAME +' '+ EMPLOYEES.EMPLOYEE_SURNAME PACK_NAME
					<cfelseif (database_type is 'DB2')>
					EMPLOYEES.EMPLOYEE_NAME ||' '|| EMPLOYEES.EMPLOYEE_SURNAME PACK_NAME
					</cfif>
				FROM
					SHIP_RESULT_PACKAGE SRP,
					#dsn_alias#.EMPLOYEES EMPLOYEES
				WHERE 
					SRP.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#"> AND
					SRP.PACK_EMP_ID = EMPLOYEES.EMPLOYEE_ID
			</cfquery>
	  		<tr class="color-row">
				<td>
				<table id="table2">
					<tr class="color-list" height="20">
						<td width="75" class="txtbold"><cf_get_lang_main no ='670.Adet'></td>
						<td width="90" class="txtbold"><cf_get_lang no ='478.Paket Tipi'></td>
						<td width="120" class="txtbold"><cf_get_lang no ='479.Ebat'></td>
						<td width="100" class="txtbold"><cf_get_lang_main no ='1987.Ağırlık'> (kg)</td>
						<td width="90" class="txtbold"><cf_get_lang_main no='221.Barkod'></td>
						<td width="150" class="txtbold"><cf_get_lang no ='1460.Paketleyen'></td>
					</tr>		
				<cfoutput query="get_package">
				  <cfquery name="GET_TYPE" datasource="#DSN#">
					SELECT PACKAGE_TYPE, DIMENTION FROM SETUP_PACKAGE_TYPE WHERE PACKAGE_TYPE_ID = <cfif len(package_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#package_type#"><cfelse>0</cfif> 
				  </cfquery>
				 	<tr id="frm_row_other#currentrow#">
						<td>#tlformat(package_piece,0)#</td>
						<td>#GET_TYPE.package_type#</td>
						<td>#get_type.dimention#</td>
						<td>#tlformat(package_weight)#</td>
						<td>#barcode#</td>
						<td>#get_package.pack_name#</td>
					</tr>
				</cfoutput>
				</table>
				</td>
			</tr>
			<tr class="color-row">
				<td>
				<table id="table3">
					<tr class="color-list" height="20">
						<td class="txtbold"><cf_get_lang no ='1459.Sevkiyatın İlişkili Olduğu Faturalar'></td>
					</tr>		
				<cfoutput query="get_row">
					<!---  <cfif get_ship_result.is_type neq 2> --->
						<cfquery name="GET_INVOICE" datasource="#DSN2#">
							SELECT 
								INVOICE_SHIPS.INVOICE_NUMBER,
								INVOICE.RECORD_DATE
							FROM 
								INVOICE,
								INVOICE_SHIPS
							WHERE 
								INVOICE_SHIPS.INVOICE_ID = INVOICE.INVOICE_ID AND
								INVOICE_SHIPS.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_id#">
						</cfquery>
					<!--- <cfelse>		
						<cfquery name="GET_SHIP" datasource="#DSN3#">
							SELECT ORDER_NUMBER SHIP_NUMBER FROM ORDERS WHERE ORDER_ID = #ship_id#
						</cfquery>
					</cfif> --->
						<tr>
							<td class="txtbold">#GET_INVOICE.INVOICE_NUMBER# <cf_get_lang no ='1458.nolu faturanın kayıt tarihi'> #dateformat(GET_INVOICE.record_date,'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,GET_INVOICE.record_date),'HH:MM')#</td>
						</tr>
				</cfoutput>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
