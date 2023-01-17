<cf_get_lang_set module_name="objects">
<cfsetting showdebugoutput="no">
<cfif attributes.action_type eq 0><!--- satis --->
	<cfquery name="GET_REQUEST_ROWS" datasource="#DSN#">
		SELECT
			ASSET_P_REQUEST_ROWS.REQUEST_ID,
			ASSET_P_REQUEST_ROWS.ASSETP_ID,
			ASSET_P.ASSETP,
			ASSET_P_REQUEST_ROWS.BRAND_TYPE_ID,
			SETUP_BRAND.BRAND_NAME,
			SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
			ASSET_P_REQUEST_ROWS.REQUEST_TYPE_ID,
			ASSET_P_REQUEST_ROWS.MAKE_YEAR,
			ASSET_P_REQUEST_ROWS.BRANCH_ID,
			ASSET_P_REQUEST_ROWS.EMPLOYEE_ID,
			ASSET_P_REQUEST_ROWS.REQUEST_DATE,
			ASSET_P_REQUEST_ROWS.DETAIL,
			ASSET_P_REQUEST_ROWS.REQUEST_STATE,
			ASSET_P_REQUEST_ROWS.RECORD_EMP,
			ASSET_P_REQUEST_ROWS.RECORD_IP,
			ASSET_P_REQUEST_ROWS.RECORD_DATE,
			ASSET_P_REQUEST_ROWS.UPDATE_DATE,
			ASSET_P_REQUEST_ROWS.UPDATE_EMP,
			ASSET_P_REQUEST_ROWS.UPDATE_IP,
			BRANCH.BRANCH_NAME,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			PROCESS_TYPE_ROWS.LINE_NUMBER
		FROM
			ASSET_P_REQUEST_ROWS,
			SETUP_BRAND_TYPE,
			SETUP_BRAND,
			ASSET_P,
			BRANCH,
			EMPLOYEES,
			PROCESS_TYPE_ROWS
		WHERE
			ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID = #attributes.action_id# AND
			ASSET_P_REQUEST_ROWS.BRANCH_ID = BRANCH.BRANCH_ID AND
			ASSET_P_REQUEST_ROWS.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND
			SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID AND
			ASSET_P_REQUEST_ROWS.ASSETP_ID = ASSET_P.ASSETP_ID AND
			ASSET_P_REQUEST_ROWS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
			ASSET_P_REQUEST_ROWS.REQUEST_STATE = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
		ORDER BY
			ASSET_P_REQUEST_ROWS.REQUEST_ID
	</cfquery>
	<table border="0" align="center" cellpadding="0" cellspacing="0" style="width:210mm">
		<tr class="color-row">
			<td style="width:15mm">&nbsp;</td>
			<td valign="top">
			<cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td height="40" class="txtbold"><cf_get_lang no="834.Talep"> <cf_get_lang_main no="75.No">: #get_request_rows.request_id#<br/><cf_get_lang no="834.Talep"> <cf_get_lang_main no="1165.Sıra"> <cf_get_lang_main no="75.No">: #attributes.action_id#</td>
						<td width="160" class="headbold"><cf_get_lang no="844.ARAÇ İŞLEM FORMU"></td>
					</tr>
					</table>
					<hr>
					<table width="100%">
						<tr>
							<td width="80" class="txtbold"><cf_get_lang_main no='512.Kime'></td>
							<td>: <cf_get_lang no="842.İSGD"></td>
							<td width="120" class="txtbold"><cf_get_lang no='970.Talep Eden'> <cf_get_lang_main no='1351.Depo'> </td>
							<td>: #get_request_rows.branch_name#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang_main no='76.Fax'> <cf_get_lang_main no='75.No'>  </td>
							<td>: (0212) 452 39 39 </td>
							<td class="txtbold"><cf_get_lang no='970.Talep Eden'> <cf_get_lang_main no='88.Kişi'> </td>
							<td>: #get_request_rows.employee_name# #get_request_rows.employee_surname#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang_main no='971.Talep Tarihi'></td>
							<td>: #dateformat(get_request_rows.request_date,dateformat_style)#</td>
							<td class="txtbold"><cf_get_lang no="834.Talep"> <cf_get_lang_main no="218.Tipi"></td>
							<td>: <cf_get_lang no="836.Satış Taleb"></td>
						</tr>
						<tr>
							<td colspan="4"></td>
						</tr>
					</table>
					<hr>
					</td>
				</tr>
				<tr>
					<td style="height:55mm " valign="top">
					<table width="100%">
						<tr class="txtbold">
							<td><cf_get_lang_main no='1656.Plaka'></td>
							<td><cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'></td>
							<td><cf_get_lang_main no='813.Model'></td>
						</tr>
						<cfloop query="get_request_rows">
						<tr>
							<td>#get_request_rows.assetp#</td>
							<td>#get_request_rows.brand_name# - #get_request_rows.brand_type_name#</td>
							<td>#get_request_rows.make_year#</td>
						</tr>
						</cfloop>
					</table>
					<br/><br/><br/><br/>
					</td>
				</tr>
				<tr>
					<td height="260" valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td><hr></td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang_main no='217.Açıklama'> :</td>
						</tr>
						<tr>
							<td>
							<table style="width:178mm" height="140" border="1" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top">#get_request_rows.detail#&nbsp;</td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td>
							<table border="0" style="width:180mm" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<cf_get_lang no="837.Şube Müdürü"><br/>
										<cfquery name="GET_EMP_NAME1" datasource="#DSN#">
											SELECT
												EMPLOYEE_NAME,
												EMPLOYEE_SURNAME
											FROM
												EMPLOYEE_POSITIONS,
												BRANCH
											WHERE
												BRANCH.BRANCH_ID = #get_request_rows.branch_id# AND
												BRANCH.ADMIN1_POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE
										</cfquery>
										<cfif get_emp_name1.recordcount>
											#get_emp_name1.employee_name# #get_emp_name1.employee_surname# 
										</cfif>
									</td>
									<td width="130"></td>
								</tr>
							</table>
							</td>
						</tr>
				</table>
					</td>
				</tr>
				<tr>
					<td>
					<table border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="txtbold"><cf_get_lang no="840.MLHD Onayı"> :</td>
						</tr>
						<tr>
							<td>
							<table style="width:178mm" height="140" border="1" cellpadding="0" cellspacing="0">
								<tr>
									<td>&nbsp;</td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td>
							<table border="0" style="width:180mm" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<cf_get_lang no="841.MLH Direktörü"><br/>
										<cfquery name="GET_EMP_NAME2" datasource="#DSN#">
											SELECT
												EMPLOYEE_NAME,
												EMPLOYEE_SURNAME
											FROM
												DEPARTMENT,
												EMPLOYEE_POSITIONS
											WHERE
												EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
												EMPLOYEE_POSITIONS.POSITION_NAME = 'Müşteri Hizmetleri ve Lojistik Direktörü'
										</cfquery>
										<cfif get_emp_name2.recordcount>
											#get_emp_name2.employee_name# #get_emp_name2.employee_surname# 
										</cfif>
									</td>
									<td width="130"><!--- Hedefdeki Genel Mudur karmasikligindan dolayi --->
										<cf_get_lang no="843.İlaç Genel Müdürü"><br/>
										<cfquery name="GET_EMP_NAME3" datasource="#DSN#">
											SELECT
												EMPLOYEE_NAME,
												EMPLOYEE_SURNAME
											FROM
												DEPARTMENT,
												EMPLOYEE_POSITIONS
											WHERE
												EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
												<!--- DEPARTMENT.BRANCH_ID = #get_request_rows.branch_id# AND --->
												EMPLOYEE_POSITIONS.POSITION_NAME = 'Genel Müdür' AND
												EMPLOYEE_POSITIONS.DEPARTMENT_ID = 5634
										</cfquery>
										<cfif get_emp_name3.recordcount>
											#get_emp_name3.employee_name# #get_emp_name3.employee_surname# 
										</cfif>
									</td>
								</tr>
							</table>
							<br/><br/><br/>
							</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
			</cfoutput>
			</td>
			<td valign="top" style="width:15mm">&nbsp;</td>
		</tr>
	</table>

<cfelseif attributes.action_type eq 1><!--- alis --->
	<cfquery name="GET_REQUEST_ROWS" datasource="#DSN#">
		SELECT
			ASSET_P_REQUEST_ROWS.REQUEST_ID,
			ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID,
			ASSET_P_REQUEST_ROWS.ASSETP_CATID,
			ASSET_P_REQUEST_ROWS.USAGE_PURPOSE_ID,
			ASSET_P_REQUEST_ROWS.BRAND_TYPE_ID,
			ASSET_P_REQUEST_ROWS.MAKE_YEAR,
			ASSET_P_REQUEST_ROWS.PERT_ID,
			ASSET_P_REQUEST_ROWS.ASSETP_ID,
			ASSET_P_REQUEST_ROWS.EMPLOYEE_ID,
			ASSET_P_REQUEST_ROWS.BRANCH_ID,
			ASSET_P_REQUEST_ROWS.DETAIL,
			ASSET_P_REQUEST_ROWS.REQUEST_DATE,
			ASSET_P_REQUEST_ROWS.REQUEST_STATE,
			ASSET_P_REQUEST_ROWS.RECORD_EMP,
			ASSET_P_REQUEST_ROWS.RECORD_IP,
			ASSET_P_REQUEST_ROWS.RECORD_DATE,
			ASSET_P_REQUEST_ROWS.UPDATE_DATE,
			ASSET_P_REQUEST_ROWS.UPDATE_EMP,
			ASSET_P_REQUEST_ROWS.UPDATE_IP,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			SETUP_BRAND.BRAND_NAME,
			SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
			BRANCH.BRANCH_NAME,
			PROCESS_TYPE_ROWS.LINE_NUMBER,
			ASSET_P.ASSETP
		FROM 
			ASSET_P_REQUEST_ROWS,
			
			ASSET_P_REQUEST,
			
			SETUP_BRAND_TYPE,
			SETUP_BRAND,
			EMPLOYEES,
			BRANCH,
			PROCESS_TYPE_ROWS,
			ASSET_P
		WHERE
			ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID = #attributes.action_id# AND
			ASSET_P_REQUEST.REQUEST_ID = ASSET_P_REQUEST_ROWS.REQUEST_ID AND
			ASSET_P_REQUEST_ROWS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
			ASSET_P_REQUEST_ROWS.BRANCH_ID = BRANCH.BRANCH_ID AND
			ASSET_P_REQUEST_ROWS.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND
			SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID AND
			ASSET_P_REQUEST_ROWS.PERT_ID  = ASSET_P.ASSETP_ID AND
			ASSET_P_REQUEST_ROWS.REQUEST_STATE = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
			
		UNION ALL
	
		SELECT
			ASSET_P_REQUEST_ROWS.REQUEST_ID,
			ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID,
			ASSET_P_REQUEST_ROWS.ASSETP_CATID,
			ASSET_P_REQUEST_ROWS.USAGE_PURPOSE_ID,
			ASSET_P_REQUEST_ROWS.BRAND_TYPE_ID,
			ASSET_P_REQUEST_ROWS.MAKE_YEAR,
			ASSET_P_REQUEST_ROWS.PERT_ID,
			ASSET_P_REQUEST_ROWS.ASSETP_ID,
			ASSET_P_REQUEST_ROWS.EMPLOYEE_ID,
			ASSET_P_REQUEST_ROWS.BRANCH_ID,
			ASSET_P_REQUEST_ROWS.DETAIL,
			ASSET_P_REQUEST_ROWS.REQUEST_DATE,
			ASSET_P_REQUEST_ROWS.REQUEST_STATE,
			ASSET_P_REQUEST_ROWS.RECORD_EMP,
			ASSET_P_REQUEST_ROWS.RECORD_IP,
			ASSET_P_REQUEST_ROWS.RECORD_DATE,
			ASSET_P_REQUEST_ROWS.UPDATE_DATE,
			ASSET_P_REQUEST_ROWS.UPDATE_EMP,
			ASSET_P_REQUEST_ROWS.UPDATE_IP,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			SETUP_BRAND.BRAND_NAME,
			SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
			BRANCH.BRANCH_NAME,
			PROCESS_TYPE_ROWS.LINE_NUMBER,
			'' AS ASSETP
		FROM 
			ASSET_P_REQUEST_ROWS,
			ASSET_P_REQUEST,
			SETUP_BRAND_TYPE,
			SETUP_BRAND,
			EMPLOYEES,
			PROCESS_TYPE_ROWS,
			BRANCH
		WHERE 
			ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID = #attributes.action_id# AND
			ASSET_P_REQUEST.REQUEST_ID = ASSET_P_REQUEST_ROWS.REQUEST_ID AND
			ASSET_P_REQUEST_ROWS.PERT_ID IS NULL AND
			ASSET_P_REQUEST_ROWS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
			ASSET_P_REQUEST_ROWS.BRANCH_ID = BRANCH.BRANCH_ID AND
			ASSET_P_REQUEST_ROWS.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND
			SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID AND
			ASSET_P_REQUEST_ROWS.REQUEST_STATE = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
		ORDER BY
			REQUEST_ROW_ID
	</cfquery>
	
	<table border="0" align="center" cellpadding="0" cellspacing="0" style="width:210mm">
		<tr class="color-row">
			<td style="width:13mm">&nbsp;</td>
			<td valign="top">
			<cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td height="30" class="txtbold"><cf_get_lang no="834.Talep"> <cf_get_lang_main no="75.No">: #get_request_rows.request_id#<br/><cf_get_lang no="834.Talep"> <cf_get_lang_main no="1165.Sıra"> <cf_get_lang_main no="75.No">: #attributes.action_id#</td>
							<td width="160" class="headbold"><cf_get_lang no="844.ARAÇ İŞLEM FORMU"></td>
						</tr>
					</table>
					<hr>
					<br/>
					<table width="100%">
						<tr>
							<td width="80" class="txtbold"><cf_get_lang_main no='512.Kime'></td>
							<td>: <cf_get_lang no="842.İSGD"></td>
							<td width="120" class="txtbold"><cf_get_lang no='970.Talep Eden'> <cf_get_lang_main no='1351.Depo'> </td>
							<td>: #get_request_rows.branch_name#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang_main no='76.Fax'> <cf_get_lang_main no='75.No'>  </td>
							<td>: (0212) 452 39 39 </td>
							<td class="txtbold"><cf_get_lang_main no='970.Talep Eden'> <cf_get_lang_main no='88.Kişi'>  </td>
							<td>: #get_request_rows.employee_name# #get_request_rows.employee_surname#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang_main no='971.Talep Tarihi'></td>
							<td>: #dateformat(get_request_rows.request_date,dateformat_style)#</td>
							<td class="txtbold"><cf_get_lang no="845.Talep Tipi"> </td>
							<td>:<cf_get_lang no="851.Alış Talebi"></td>
						</tr>
						<tr>
							<td colspan="4"></td>
						</tr>
					</table>
					<hr>
					</td>
				</tr>
				<tr>
					<td valign="top" style="height:55mm">
					<table width="100%">
						<tr class="txtbold">
							<td><cf_get_lang no="858.Araç Tipi"></td>
							<td><cf_get_lang no="235.Kullanım Amacı"></td>
							<td><cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'></td>
							<td><cf_get_lang_main no='813.Model'></td>
							<td><cf_get_lang no="859.Pert"><cf_get_lang_main no='1656.Plaka'></td>
						</tr>
						<cfloop query="GET_REQUEST_ROWS">
						<tr>
							<td>
								<cfquery name="GET_ASSETP_CAT" datasource="#DSN#">
									SELECT ASSETP_CAT FROM ASSET_P_CAT WHERE ASSETP_CATID = #get_request_rows.assetp_catid#   
								</cfquery>
								#get_assetp_cat.assetp_cat#
							</td>
							<td>
								<cfquery name="GET_USAGE_PURPOSE" datasource="#DSN#">
									SELECT USAGE_PURPOSE FROM SETUP_USAGE_PURPOSE WHERE USAGE_PURPOSE_ID = #get_request_rows.usage_purpose_id#   
								</cfquery>				
								#get_usage_purpose.usage_purpose#
							</td>
							<td>#get_request_rows.brand_name# - #get_request_rows.brand_type_name#</td>
							<td>#get_request_rows.make_year#</td>
							<td>#get_request_rows.assetp#</td>
						</tr>
						</cfloop>
					</table>
					</td>
				</tr>
				<tr>
					<td height="260" valign="top">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td height="7">
								<hr>
							</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang_main no='217.Açıklama'> :</td>
						</tr>
						<tr>
							<td>
							<table style="width:178mm" height="140" border="1" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top">#get_request_rows.detail#&nbsp;</td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td>
							<table border="0" style="width:180mm" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<cf_get_lang no="837.Şube Müdürü"><br/>
										<cfquery name="GET_EMP_NAME1" datasource="#DSN#">
											SELECT
												EMPLOYEE_NAME,
												EMPLOYEE_SURNAME
											FROM
												EMPLOYEE_POSITIONS,
												BRANCH
											WHERE
												BRANCH.BRANCH_ID = #get_request_rows.branch_id# AND
												BRANCH.ADMIN1_POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE
										</cfquery>
										<cfif get_emp_name1.recordcount>
										#get_emp_name1.employee_name# #get_emp_name1.employee_surname# 
										</cfif>
									</td>
									<td width="130"></td>
								</tr>
							</table>
							</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td>
					<table border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="txtbold"><cf_get_lang no="840.MLHD Onayı"> :</td>
						</tr>
						<tr>
							<td>
							<table style="width:178mm" height="140" border="1" cellpadding="0" cellspacing="0">
								<tr>
									<td>&nbsp;</td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td>
							<table border="0" style="width:180mm" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<cf_get_lang no="841.MLH Direktörü"><br/>
										<cfquery name="GET_EMP_NAME2" datasource="#DSN#">
											SELECT
												EMPLOYEE_NAME,
												EMPLOYEE_SURNAME
											FROM
												DEPARTMENT,
												EMPLOYEE_POSITIONS
											WHERE
												EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
												EMPLOYEE_POSITIONS.POSITION_NAME = 'Müşteri Hizmetleri ve Lojistik Direktörü'
										</cfquery>
										<cfif get_emp_name2.recordcount>
											#get_emp_name2.employee_name# #get_emp_name2.employee_surname# 
										</cfif>
									</td>
									<td width="130"><!--- Hedefdeki Genel Mudur karmasikligindan dolayi --->
									<cf_get_lang no="843.İlaç Genel Müdürü"><br/>
									<cfquery name="GET_EMP_NAME3" datasource="#DSN#">
										SELECT
											EMPLOYEE_NAME,
											EMPLOYEE_SURNAME
										FROM
											DEPARTMENT,
											EMPLOYEE_POSITIONS
										WHERE
											EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
											<!--- DEPARTMENT.BRANCH_ID = #get_request_rows.branch_id# AND --->
											EMPLOYEE_POSITIONS.POSITION_NAME = 'Genel Müdür' AND
											EMPLOYEE_POSITIONS.DEPARTMENT_ID = 5634 
									</cfquery>
									<cfif get_emp_name3.recordcount>
										#get_emp_name3.employee_name# #get_emp_name3.employee_surname# 
									</cfif>				  
								</td>
								</tr>
							</table>
							</td>
						</tr>
					</table>
					<br/><br/><br/>
					</td>
				</tr>
			</table>
			</cfoutput>
			</td>
			<td valign="top" style="width:15mm">&nbsp;</td>
		</tr>
	</table>	
<cfelseif attributes.action_type eq 2><!--- iade --->
	<cfquery name="GET_REQUEST_ROWS" datasource="#DSN#">
		SELECT
			ASSET_P_REQUEST_ROWS.REQUEST_ID,
			ASSET_P_REQUEST_ROWS.ASSETP_ID,
			ASSET_P.ASSETP,
			ASSET_P_REQUEST_ROWS.BRAND_TYPE_ID,
			SETUP_BRAND.BRAND_NAME,
			SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
			ASSET_P_REQUEST_ROWS.REQUEST_TYPE_ID,
			ASSET_P_REQUEST_ROWS.MAKE_YEAR,
			ASSET_P_REQUEST_ROWS.BRANCH_ID,
			ASSET_P_REQUEST_ROWS.EMPLOYEE_ID,
			ASSET_P_REQUEST_ROWS.REQUEST_DATE,
			ASSET_P_REQUEST_ROWS.DETAIL,
			ASSET_P_REQUEST_ROWS.REQUEST_STATE,
			ASSET_P_REQUEST_ROWS.RECORD_EMP,
			ASSET_P_REQUEST_ROWS.RECORD_IP,
			ASSET_P_REQUEST_ROWS.RECORD_DATE,
			ASSET_P_REQUEST_ROWS.UPDATE_DATE,
			ASSET_P_REQUEST_ROWS.UPDATE_EMP,
			ASSET_P_REQUEST_ROWS.UPDATE_IP,
			BRANCH.BRANCH_NAME,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			PROCESS_TYPE_ROWS.LINE_NUMBER
		FROM
			ASSET_P_REQUEST_ROWS,
			SETUP_BRAND_TYPE,
			SETUP_BRAND,
			ASSET_P,
			BRANCH,
			EMPLOYEES,
			PROCESS_TYPE_ROWS
		WHERE
			ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID = #attributes.action_id# AND
			ASSET_P_REQUEST_ROWS.BRANCH_ID = BRANCH.BRANCH_ID AND
			ASSET_P_REQUEST_ROWS.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND
			SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID AND
			ASSET_P_REQUEST_ROWS.ASSETP_ID = ASSET_P.ASSETP_ID AND
			ASSET_P_REQUEST_ROWS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
			ASSET_P_REQUEST_ROWS.REQUEST_STATE = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
		ORDER BY
			ASSET_P_REQUEST_ROWS.REQUEST_ID
	</cfquery>
	
	<table border="0" align="center" cellpadding="0" cellspacing="0" style="width:210mm">
		<tr class="color-row">
			<td style="width:15mm">&nbsp;</td>
			<td valign="top">
			<cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td height="40" class="txtbold"><cf_get_lang no="834.Talep"> <cf_get_lang_main no="75.No">: #get_request_rows.request_id#<br/><cf_get_lang no="834.Talep"> <cf_get_lang_main no="1165.Sıra"> <cf_get_lang_main no="75.No">: #attributes.action_id#</td>
							<td width="160" class="headbold"><cf_get_lang no="844.ARAÇ İŞLEM FORMU"></td>
						</tr>
					</table>
					<hr>
					<table width="100%">
						<tr>
							<td width="80" class="txtbold"><cf_get_lang_main no='512.Kime'></td>
							<td>: <cf_get_lang no="842.İSGD"></td>
							<td width="120" class="txtbold"><cf_get_lang no='970.Talep Eden'> <cf_get_lang_main no='1351.Depo'> </td>
							<td>: #get_request_rows.branch_name#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang_main no='76.Fax'> <cf_get_lang_main no='75.No'>  </td>
							<td>: (0212) 452 39 39 </td>
							<td class="txtbold"><cf_get_lang_main no='970.Talep Eden'> <cf_get_lang_main no='88.Kişi'>  </td>
							<td>: #get_request_rows.employee_name# #get_request_rows.employee_surname#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang_main no='971.Talep Tarihi'></td>
							<td>: #dateformat(get_request_rows.request_date,dateformat_style)#</td>
							<td class="txtbold"><cf_get_lang no="845.Talep Tipi"> </td>
							<td>: <cf_get_lang no="861.İade Talebi"></td>
						</tr>
						<tr>
							<td colspan="4"></td>
						</tr>
					</table>
					<hr>
					</td>
				</tr>
				<tr>
					<td style="height:55mm " valign="top">
					<table width="100%">
						<tr class="txtbold">
							<td><cf_get_lang_main no='1656.Plaka'></td>
							<td><cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'></td>
							<td><cf_get_lang_main no='813.Model'></td>
						</tr>
						<cfloop query="get_request_rows">
						<tr>
							<td>#get_request_rows.assetp#</td>
							<td>#get_request_rows.brand_name# - #get_request_rows.brand_type_name#</td>
							<td>#get_request_rows.make_year#</td>
						</tr>
						</cfloop>
					</table>
					<br/><br/><br/><br/>
					</td>
				</tr>
				<tr>
					<td height="260" valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td><hr></td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang_main no='217.Açıklama'> :</td>
						</tr>
						<tr>
							<td>
							<table style="width:178mm" height="140" border="1" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top">#get_request_rows.detail#&nbsp;</td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td>
							<table border="0" style="width:180mm" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<cf_get_lang no="837.Şube Müdürü"><br/>
										<cfquery name="GET_EMP_NAME1" datasource="#DSN#">
											SELECT
												EMPLOYEE_NAME,
												EMPLOYEE_SURNAME
											FROM
												EMPLOYEE_POSITIONS,
												BRANCH
											WHERE
												BRANCH.BRANCH_ID = #get_request_rows.branch_id# AND
												BRANCH.ADMIN1_POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE
										</cfquery>
										<cfif get_emp_name1.recordcount>
											#get_emp_name1.employee_name# #get_emp_name1.employee_surname# 
										</cfif>
									</td>
									<td width="130"></td>
								</tr>
							</table>
							</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td>
					<table border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="txtbold"><cf_get_lang no="840.MLHD Onayı"> :</td>
						</tr>
						<tr>
							<td>
							<table style="width:178mm" height="140" border="1" cellpadding="0" cellspacing="0">
								<tr>
									<td>&nbsp;</td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
						<td>
						<table border="0" style="width:180mm" cellspacing="0" cellpadding="0">
							<tr>
								<td>
									<cf_get_lang no="841.MLH Direktörü"><br/>
									<cfquery name="GET_EMP_NAME2" datasource="#DSN#">
										SELECT
											EMPLOYEE_NAME,
											EMPLOYEE_SURNAME
										FROM
											DEPARTMENT,
											EMPLOYEE_POSITIONS
										WHERE
											EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
											EMPLOYEE_POSITIONS.POSITION_NAME = 'Müşteri Hizmetleri ve Lojistik Direktörü'
									</cfquery>
									<cfif get_emp_name2.recordcount>
										#get_emp_name2.employee_name# #get_emp_name2.employee_surname# 
									</cfif>
								</td>
								<td width="130"><!--- Hedefdeki Genel Mudur karmasikligindan dolayi --->
									<cf_get_lang no="843.İlaç Genel Müdürü"><br/>
									<cfquery name="GET_EMP_NAME3" datasource="#DSN#">
										SELECT
											EMPLOYEE_NAME,
											EMPLOYEE_SURNAME
										FROM
											DEPARTMENT,
											EMPLOYEE_POSITIONS
										WHERE
											EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
											<!--- DEPARTMENT.BRANCH_ID = #get_request_rows.branch_id# AND --->
											EMPLOYEE_POSITIONS.POSITION_NAME = 'Genel Müdür' AND
											EMPLOYEE_POSITIONS.DEPARTMENT_ID = 5634
									</cfquery>
									<cfif get_emp_name3.recordcount>
										#get_emp_name3.employee_name# #get_emp_name3.employee_surname# 
									</cfif>	
								</td>
							</tr>
						</table>
						<br/><br/><br/>
						</td>
					</tr>
					</table>
					</td>
				</tr>
			</table>
			</cfoutput>
			</td>
			<td valign="top" style="width:15mm">&nbsp;</td>
		</tr>
	</table>
<cfelseif attributes.action_type eq 3><!--- degistirme --->
	<cfquery name="GET_REQUEST_ROWS" datasource="#DSN#">
		SELECT
			ASSET_P_REQUEST_ROWS.REQUEST_ID,
			ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID,
			ASSET_P_REQUEST_ROWS.ASSETP_CATID,
			ASSET_P_REQUEST_ROWS.USAGE_PURPOSE_ID,
			ASSET_P_REQUEST_ROWS.BRAND_TYPE_ID,
			ASSET_P_REQUEST_ROWS.BRANCH_ID,		
			ASSET_P_REQUEST_ROWS.MAKE_YEAR,
			ASSET_P_REQUEST_ROWS.PERT_ID,
			ASSET_P_REQUEST_ROWS.OLD_MAKE_YEAR,
			ASSET_P_REQUEST_ROWS.OLD_BRAND_TYPE_ID,		
			ASSET_P_REQUEST_ROWS.REQUEST_STATE,
			ASSET_P_REQUEST_ROWS.ASSETP_ID,
			ASSET_P_REQUEST_ROWS.EMPLOYEE_ID,
			ASSET_P_REQUEST_ROWS.REQUEST_DATE,
			ASSET_P_REQUEST_ROWS.DETAIL,
			ASSET_P_REQUEST_ROWS.RECORD_EMP,
			ASSET_P_REQUEST_ROWS.RECORD_IP,
			ASSET_P_REQUEST_ROWS.RECORD_DATE,
			ASSET_P_REQUEST_ROWS.UPDATE_DATE,
			ASSET_P_REQUEST_ROWS.UPDATE_EMP,
			ASSET_P_REQUEST_ROWS.UPDATE_IP,
			SETUP_OLD_BRAND.BRAND_NAME OLD_BRAND_NAME,
			SETUP_NEW_BRAND.BRAND_NAME,
			SETUP_BRAND_TYPE_BRAND_TYPE_ID.BRAND_TYPE_NAME BRAND_TYPE_NAME,
			SETUP_BRAND_TYPE_OLD_BRAND_TYPE_ID.BRAND_TYPE_NAME OLD_BRAND_TYPE_NAME,
			ASSET_P_CAT.ASSETP_CAT,
			ASSET_P.ASSETP,
			SETUP_USAGE_PURPOSE.USAGE_PURPOSE,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			BRANCH.BRANCH_NAME,
			PROCESS_TYPE_ROWS.LINE_NUMBER
		FROM 
			ASSET_P_REQUEST_ROWS,
			ASSET_P_CAT,
			SETUP_USAGE_PURPOSE,
			SETUP_BRAND_TYPE SETUP_BRAND_TYPE_BRAND_TYPE_ID,
			SETUP_BRAND_TYPE SETUP_BRAND_TYPE_OLD_BRAND_TYPE_ID,
			SETUP_BRAND SETUP_OLD_BRAND,
			SETUP_BRAND SETUP_NEW_BRAND,
			EMPLOYEES,
			BRANCH,
			ASSET_P,
			PROCESS_TYPE_ROWS
		WHERE 
			ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID = #attributes.action_id# AND
			ASSET_P_REQUEST_ROWS.BRAND_TYPE_ID = SETUP_BRAND_TYPE_BRAND_TYPE_ID.BRAND_TYPE_ID AND
			ASSET_P_REQUEST_ROWS.OLD_BRAND_TYPE_ID =  SETUP_BRAND_TYPE_OLD_BRAND_TYPE_ID.BRAND_TYPE_ID AND
			SETUP_BRAND_TYPE_BRAND_TYPE_ID.BRAND_ID = SETUP_NEW_BRAND.BRAND_ID AND
			SETUP_BRAND_TYPE_OLD_BRAND_TYPE_ID.BRAND_ID = SETUP_OLD_BRAND.BRAND_ID AND
			ASSET_P_REQUEST_ROWS.ASSETP_ID = ASSET_P.ASSETP_ID AND
			ASSET_P_REQUEST_ROWS.USAGE_PURPOSE_ID  = SETUP_USAGE_PURPOSE.USAGE_PURPOSE_ID AND
			ASSET_P_REQUEST_ROWS.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
			ASSET_P_REQUEST_ROWS.BRANCH_ID = BRANCH.BRANCH_ID AND
			ASSET_P_REQUEST_ROWS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
			ASSET_P_REQUEST_ROWS.REQUEST_STATE = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
		ORDER BY
			ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID
	</cfquery>
	
	<table border="0" align="center" cellpadding="0" cellspacing="0" style="width:210mm">
		<tr class="color-row">
			<td style="width:15mm">&nbsp;</td>
			<td valign="top">
			<cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td height="40" class="txtbold"><cf_get_lang no="834.Talep"> <cf_get_lang_main no="75.No">: #get_request_rows.request_id#<br/><cf_get_lang no="834.Talep"> <cf_get_lang_main no="1165.Sıra"> <cf_get_lang_main no="75.No">: #attributes.action_id#</td>
							<td width="160" class="headbold"><cf_get_lang no="844.ARAÇ İŞLEM FORMU"></td>
						</tr>
					</table>
					<hr>
					<table width="100%">
						<tr>
							<td width="80" class="txtbold"><cf_get_lang_main no='512.Kime'></td>
							<td>: <cf_get_lang no="842.İSGD"></td>
							<td width="120" class="txtbold"><cf_get_lang no='970.Talep Eden'> <cf_get_lang_main no='1351.Depo'> </td>
							<td>: #get_request_rows.branch_name#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang_main no='76.Fax'> <cf_get_lang_main no='75.No'>  </td>
							<td>: (0212) 452 39 39 </td>
							<td class="txtbold"><cf_get_lang_main no='970.Talep Eden'> <cf_get_lang_main no='88.Kişi'>  </td>
							<td>: #get_request_rows.employee_name# #get_request_rows.employee_surname#</td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang_main no='971.Talep Tarihi'></td>
							<td>: #dateformat(get_request_rows.request_date,dateformat_style)#</td>
							<td class="txtbold"><cf_get_lang no="845.Talep Tipi"> </td>
							<td>: <cf_get_lang no="846.Değiştirme Talebi"></td>
						</tr>
						<tr>
							<td colspan="4"></td>
						</tr>
					</table>
					<hr>
					</td>
				</tr>
				<tr>
					<td style="height:55mm" valign="top">
					<table width="100%">
						<tr class="txtbold">
							<td><cf_get_lang no="848.Eski Araç"></td>
							<td><cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'></td>
							<td><cf_get_lang_main no='813.Model'></td>
							<td><cf_get_lang no="864.Yeni Araç Tipi"></td>
							<td><cf_get_lang no="235.Kullanım Amacı"></td>
							<td><cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'></td>
							<td><cf_get_lang_main no='813.Model'></td>
						</tr>
						<cfloop query="GET_REQUEST_ROWS">
						<tr>
							<td>#get_request_rows.assetp#</td>
							<td>#get_request_rows.old_brand_name# - #get_request_rows.old_brand_type_name#</td>
							<td>#get_request_rows.old_make_year#</td>
							<td>
								<cfquery name="GET_ASSETP_CAT" datasource="#dsn#">
									SELECT ASSETP_CAT FROM ASSET_P_CAT WHERE ASSETP_CATID = #get_request_rows.assetp_catid#   
								</cfquery>
								#get_assetp_cat.assetp_cat#
							</td>
							<td>
								<cfquery name="GET_USAGE_PURPOSE" datasource="#dsn#">
									SELECT USAGE_PURPOSE FROM SETUP_USAGE_PURPOSE WHERE USAGE_PURPOSE_ID = #get_request_rows.usage_purpose_id#   
								</cfquery>				
								#get_usage_purpose.usage_purpose#
							</td>			
							<td>#get_request_rows.brand_name# - #get_request_rows.brand_type_name#</td>
							<td>#get_request_rows.make_year#</td>
						</tr>
						</cfloop>
					</table>
					<br/><br/><br/><br/>
					</td>
				</tr>
				<tr>
					<td height="260" valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td><hr></td>
						</tr>
						<tr>
							<td class="txtbold"><cf_get_lang_main no='217.Açıklama'> :</td>
						</tr>
						<tr>
							<td>
							<table style="width:178mm" height="140" border="1" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top">#get_request_rows.detail#&nbsp;</td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td>
							<table border="0" style="width:180mm" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<cf_get_lang no="837.Şube Müdürü"><br/>
										<cfquery name="GET_EMP_NAME1" datasource="#DSN#">
											SELECT
												EMPLOYEE_NAME,
												EMPLOYEE_SURNAME
											FROM
												EMPLOYEE_POSITIONS,
												BRANCH
											WHERE
												BRANCH.BRANCH_ID = #get_request_rows.branch_id# AND
												BRANCH.ADMIN1_POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE
										</cfquery>
										<cfif get_emp_name1.recordcount>
											#get_emp_name1.employee_name# #get_emp_name1.employee_surname# 
										</cfif>			
									</td>
									<td width="130"></td>
								</tr>
							</table>
							</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td>
					<table border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="txtbold"><cf_get_lang no="840.MLHD Onayı"> :</td>
						</tr>
						<tr>
							<td>
							<table style="width:178mm" height="140" border="1" cellpadding="0" cellspacing="0">
								<tr>
									<td>&nbsp;</td>
								</tr>
							</table>
							</td>
						</tr>
						<tr>
							<td>
							<table border="0" style="width:180mm" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<cf_get_lang no="841.MLH Direktörü"><br/>
										<cfquery name="GET_EMP_NAME2" datasource="#DSN#">
											SELECT
												EMPLOYEE_NAME,
												EMPLOYEE_SURNAME
											FROM
												DEPARTMENT,
												EMPLOYEE_POSITIONS
											WHERE
												EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
												EMPLOYEE_POSITIONS.POSITION_NAME = 'Müşteri Hizmetleri ve Lojistik Direktörü'
										</cfquery>
										<cfif get_emp_name2.recordcount>
											#get_emp_name2.employee_name# #get_emp_name2.employee_surname# 
										</cfif>
									</td>
									<td width="130"><!--- Hedefdeki Genel Mudur karmasikligindan dolayi --->
										<cf_get_lang no="843.İlaç Genel Müdürü"><br/>
										<cfquery name="GET_EMP_NAME3" datasource="#DSN#">
											SELECT
												EMPLOYEE_NAME,
												EMPLOYEE_SURNAME
											FROM
												DEPARTMENT,
												EMPLOYEE_POSITIONS
											WHERE
												EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
												<!--- DEPARTMENT.BRANCH_ID = #get_request_rows.branch_id# AND --->
												EMPLOYEE_POSITIONS.POSITION_NAME = 'Genel Müdür' AND
												EMPLOYEE_POSITIONS.DEPARTMENT_ID = 5634
										</cfquery>
										<cfif get_emp_name3.recordcount>
											#get_emp_name3.employee_name# #get_emp_name3.employee_surname# 
										</cfif>				  
									</td>
								</tr>
							</table>
							<br/><br/><br/>
							</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
			</cfoutput>
			</td>
			<td valign="top" style="width:15mm">&nbsp;</td>
		</tr>
	</table>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
