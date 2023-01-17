<style>
	.txtbold, .headbold {font-weight:bold;}
</style>
<cf_get_lang_set module_name="ehesap"><!--- sayfanin en altinda kapanisi var --->
<cfsetting showdebugoutput="no">
<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
	SELECT START_DATE,FINISH_DATE FROM SETUP_GENERAL_OFFTIMES
</cfquery>
<cfset offday_list_ = ''>
<cfoutput query="GET_GENERAL_OFFTIMES">
	<cfscript>
		offday_gun = datediff('d',GET_GENERAL_OFFTIMES.start_date,GET_GENERAL_OFFTIMES.finish_date)+1;
		offday_startdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.start_date); 
		offday_finishdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.finish_date);
		
		for (mck=0; mck lt offday_gun; mck=mck+1)
			{
			temp_izin_gunu = date_add("d",mck,offday_startdate);
			daycode = '#dateformat(temp_izin_gunu,dateformat_style)#';
			if(not listfindnocase(offday_list_,'#daycode#'))
				offday_list_ = listappend(offday_list_,'#daycode#');
			}
	</cfscript>
</cfoutput>
<cfquery name="GET_OFFTIME" datasource="#DSN#">
	SELECT 
		OFFTIME.*, 
		SETUP_OFFTIME.OFFTIMECAT,
		(SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = OFFTIME.VALIDATOR_POSITION_CODE_1) AS AMIR1_POSITION_NAME,
		(SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = OFFTIME.VALIDATOR_POSITION_CODE_2) AS AMIR2_POSITION_NAME,
		CASE 
            WHEN ISNULL(OFFTIME.SUB_OFFTIMECAT_ID,0) <> 0 THEN (SELECT top 1 OFFTIMECAT FROM SETUP_OFFTIME A WHERE A.OFFTIMECAT_ID = OFFTIME.SUB_OFFTIMECAT_ID)
            WHEN ISNULL(OFFTIME.SUB_OFFTIMECAT_ID,0) = 0 THEN (SELECT top 1  OFFTIMECAT FROM OFFTIME B WHERE B.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID)
        END AS NEW_CAT_NAME
	FROM 
		OFFTIME,
		SETUP_OFFTIME
	WHERE
		OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
		OFFTIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
</cfquery>
<cfif not get_offtime.recordcount>
	<br/><br/><br/><b><cf_get_lang_main no ='1074.Kayıt Bulunamadı'>!</b>
	<cfexit method="exittemplate">
</cfif>
<cfoutput query="get_offtime">
	<cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
		SELECT SATURDAY_ON,DAY_CONTROL FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= '#startdate#'  AND FINISHDATE >= '#startdate#'
	</cfquery>
	
	<cfif get_offtime_cat.recordcount and len(get_offtime_cat.SATURDAY_ON)>
		<cfset saturday_on = get_offtime_cat.SATURDAY_ON>
	<cfelse>
		<cfset saturday_on = 1>
	</cfif>
	<cfif get_offtime_cat.recordcount and len(get_offtime_cat.DAY_CONTROL)>
		<cfset day_control_ = get_offtime_cat.DAY_CONTROL>
	<cfelse>
		<cfset day_control_ = 0>
	</cfif>
	<cfscript>
		temporary_sunday_total_ = 0;
		temporary_offday_total_ = 0;
		temporary_halfday_total = 0;
		total_izin_ = datediff('d',startdate,finishdate)+1;
		izin_startdate_ = date_add("h", session.ep.time_zone, startdate); 
		izin_finishdate_ = date_add("h", session.ep.time_zone, finishdate);
			
		for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
		{
			temp_izin_gunu_ = date_add("d",mck_,izin_startdate_);
			daycode_ = '#dateformat(temp_izin_gunu_,dateformat_style)#';
			if (dayofweek(temp_izin_gunu_) eq 1)
				temporary_sunday_total_ = temporary_sunday_total_ + 1;
			else if (dayofweek(temp_izin_gunu_) eq 7 and saturday_on eq 0)
				temporary_sunday_total_ = temporary_sunday_total_ + 1;
			else if(listlen(offday_list_) and listfindnocase(offday_list_,'#daycode_#'))
				temporary_offday_total_ = temporary_offday_total_ + 1;
			else if(daycode_ is '#dateformat(dateadd("h",2,finishdate),dateformat_style)#' and day_control_ gt 0 and timeformat(dateadd("h",2,finishdate),'HH') lt day_control_)
				temporary_halfday_total = temporary_halfday_total + 1;
		}
			izin_gun = total_izin_ - temporary_sunday_total_ - temporary_offday_total_ - (0.5 * temporary_halfday_total);
	</cfscript>
	<cfset real_days = izin_gun>
</cfoutput>
<cfquery name="get_employee_info" datasource="#dsn#" maxrows="1">
	SELECT
		B.BRANCH_NAME,
		D.DEPARTMENT_HEAD,
		EP.POSITION_NAME,
		OC.NICK_NAME
	FROM
		EMPLOYEES E,
		BRANCH B,
		DEPARTMENT D,
		EMPLOYEE_POSITIONS EP,
		OUR_COMPANY OC
	WHERE
		E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = #get_offtime.employee_id# AND
		EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = OC.COMP_ID AND
		<!---D.DEPARTMENT_STATUS = 1 AND--->
		EP.IS_MASTER = 1
</cfquery>

	<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
	<tr class="color-row" valign="top">
			<td>
			<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
				<tr>
				<td colspan="2">
				<cfset record_=date_add('h',session.ep.time_zone,get_offtime.record_date)>
				<cfset start_=date_add('h',session.ep.time_zone,get_offtime.startdate)>
				<cfset end_=date_add('h',session.ep.time_zone,get_offtime.finishdate)>
				
				<cfif len(get_offtime.WORK_STARTDATE)>
					<cfset work_start_= date_add('h',session.ep.time_zone,get_offtime.WORK_STARTDATE)>
				<cfelse>				
				<cfset work_start_= date_add('d',1,get_offtime.finishdate)>
				<cfset work_start_= date_add('h',session.ep.time_zone,work_start_)>
				</cfif>
				<table cellpadding="0" cellspacing="0" border="0" width="98%">
					<input type="hidden" name="offtime_id" id="offtime_id" value="<cfoutput>#get_offtime.offtime_id#</cfoutput>">
					<input type="hidden" name="valid" id="valid" value="">
					<input type="hidden" name="counter" id="counter">
					<tr>
					<td>
					<table border="0">
						<tr height="20">
							<td width="50" colspan="2" align="center">
					<!---  --->
					<cfquery name="check" datasource="#dsn#">
						SELECT 
							ASSET_FILE_NAME2,
							ASSET_FILE_NAME2_SERVER_ID
						FROM 
							OUR_COMPANY 
						WHERE 
						<cfif isDefined("session.ep.company_id")>
							COMP_ID = #session.ep.company_id#
						<cfelseif isDefined("session.pp.our_company_id")>	
							COMP_ID = #session.pp.our_company_id#
						<cfelseif isDefined("session.ww.our_company_id")>
							COMP_ID = #session.ww.our_company_id#
						<cfelseif isDefined("session.cp.our_company_id")>
							COMP_ID = #session.cp.our_company_id#
						</cfif>
					</cfquery>
					<cfquery name="GET_TEMPLATE_DIMENSION" datasource="#DSN#">
						SELECT
							 *
						FROM
							 SETUP_TEMPLATE_DIMENSION
						<cfif isDefined("attributes.type")>
						WHERE
							 TEMPLATE_TYPE = #attributes.type#
						</cfif>	 
					</cfquery>					
					<cfif len(CHECK.ASSET_FILE_NAME2)>
						<cfset attributes.type = 1>
						<table cellpadding="0" cellspacing="1" bgcolor="FFFFFF" border="0">
							<tr> 
								<td align="center">
									<cf_get_server_file output_file="settings/#CHECK.asset_file_name2#" output_server="#CHECK.asset_file_name2_server_id#" output_type="5">
								</td>
							</tr>
						</table>
					</cfif>
							</td>
						</tr>
					<tr height="90" align="center">
						<td class="headbold" colspan="2"><cf_get_lang no='37.İZİN FORMU'></td>
					</tr>
						<tr height="20">
							<td width="100" class="txtbold"><cf_get_lang_main no='164.Çalışan'>:</td>
							<td>
								<cfif len(get_offtime.employee_id)><cfoutput>#get_emp_info(get_offtime.employee_id,0,0)#</cfoutput></cfif>
							</td>
						</tr>
						<tr height="20">
							<td width="100" class="txtbold"><cf_get_lang_main no ='162.Şirket'>:</td>
							<td>
								<cfoutput>#get_employee_info.nick_name#<!---#session.ep.company#---></cfoutput>
							</td>
						</tr>
						<tr height="20">
							<td width="100" class="txtbold"><cf_get_lang_main no ='41.Şube'>/<cf_get_lang_main no ='160.Departman'>:</td>
							<td>
							<cfoutput>#get_employee_info.BRANCH_NAME#	&nbsp;&nbsp;<cfif Len(get_employee_info.DEPARTMENT_HEAD)>/&nbsp;&nbsp;  #get_employee_info.DEPARTMENT_HEAD#</cfif></cfoutput>	
							</td>
						</tr>
						<tr height="20">
								<td width="100" class="txtbold"><cf_get_lang_main no ='1085.Pozisyon'>:</td>
								<td><cfoutput>#get_employee_info.POSITION_NAME#</cfoutput></td>
						</tr>
						<!--- <tr height="20"> MK 20120702 kapatilmasini istedi.. SS
							<td width="100" class="txtbold">İş Yeri Sicil No:</td>
							<td>
								<cfoutput>#get_employee_info.ssk_m# #get_employee_info.ssk_job# #get_employee_info.ssk_branch# #get_employee_info.ssk_branch_old# #get_employee_info.ssk_no# #get_employee_info.ssk_city# #get_employee_info.ssk_country# #get_employee_info.ssk_cd# #get_employee_info.ssk_agent#</cfoutput>
							</td>
						</tr> --->
						<tr height="20">
							<td class="txtbold"><cf_get_lang_main no='74.Kategori'>:</td>
							<td>
							<cfoutput>#GET_OFFTIME.NEW_CAT_NAME#</cfoutput>
							</td>
						</tr>
						<!--- <tr> 20120702 MK 20120702 kapatilmasini istedi.. SS
							<td class="txtbold" height="20">İzin Hakediş Tarihi:</td>
							<td colspan="2">
							<cfif len(get_offtime.deserve_date)>
								<cfoutput>#dateformat(get_offtime.deserve_date,dateformat_style)#</cfoutput>
							</cfif>
							</td>
						</tr> --->
						<tr height="20">
							<td class="txtbold" height="20"><cf_get_lang_main no='89.Başlama'>:</td>
							<td>
								<cfoutput>#dateformat(start_,dateformat_style)# #timeformat(start_,timeformat_style)#</cfoutput>
							</td>
						</tr>
						<tr height="20">
							<td class="txtbold"><cf_get_lang_main no='90.Bitiş'>:</td>
							<td>
								<cfoutput>#dateformat(end_,dateformat_style)# #timeformat(end_,timeformat_style)#</cfoutput>
							</td>
						</tr>
						<tr height="20">
							<td class="txtbold"><cf_get_lang no='88.İşe Başlama'>:</td>
							<td>
								<cfoutput>#dateformat(work_start_,dateformat_style)# #timeformat(work_start_,timeformat_style)#</cfoutput>
							</td>
						</tr>
						<tr height="20">
							<td class="txtbold"><cf_get_lang_main no='2312.İzin gün sayısı'>:</td>
							<td>
								<cfoutput>#real_days# gün</cfoutput>
							</td>
						</tr>
						<tr>
							<td class="txtbold" height="20"><cf_get_lang_main no='1311.Adres'>:</td>
							<td colspan="3">
								<cfoutput>#get_offtime.address#</cfoutput>
							</td>
						</tr>
						<tr>
							<td class="txtbold" height="20"><cf_get_lang_main no='731.İletişim'>:</td>
							<td colspan="3">
								<cfoutput>#get_offtime.tel_code##get_offtime.tel_no#</cfoutput>
							</td>
						</tr>
						<tr height="20">
							<td class="txtbold"><cf_get_lang_main no='217.Açıklama'>:</td>
							<td><cfoutput>#get_offtime.detail#</cfoutput></td>
						</tr>
						<cfif len(get_offtime.validator_position_code_1) and not len(get_offtime.valid_1)>
							<tr height="20">
								<td class="txtbold">1.<cf_get_lang no='992.Amir Onay'></td>
								<td><cfoutput>#get_emp_info(get_offtime.validator_position_code_1,1,0)#</cfoutput>&nbsp;&nbsp;
								<cf_get_lang_main no ='203.Onay Bekliyor'>!</td>
							</tr>
						<cfelseif len(get_offtime.validator_position_code_1) and len(get_offtime.valid_1) and get_offtime.valid_1 eq 1>
							<tr height="20">
								<td class="txtbold">1.<cf_get_lang no='992.Amir Onay'></td>
								<td><cfoutput>#get_emp_info(get_offtime.validator_position_code_1,1,0)#</cfoutput>&nbsp;&nbsp;
								<cf_get_lang_main no='1287.Onaylandı'>!</td>
							</tr>
						<cfelseif len(get_offtime.validator_position_code_1) and len(get_offtime.valid_1) and get_offtime.valid_1 eq 0>
							<tr height="20">
								<td class="txtbold">1.<cf_get_lang no='992.Amir Onay'></td>
								<td><cfoutput>#get_emp_info(get_offtime.validator_position_code_1,1,0)#</cfoutput>&nbsp;&nbsp;
								<cf_get_lang_main no ='205.Reddedildi'></td>
							</tr>
						</cfif>
						<cfif len(get_offtime.validator_position_code_2) and not len(get_offtime.valid_2)>
							<tr height="20">
								<td class="txtbold">2.<cf_get_lang no='992.Amir Onay'></td>
								<td><cfoutput>#get_emp_info(get_offtime.validator_position_code_2,1,0)#</cfoutput>&nbsp;&nbsp;
								<cf_get_lang_main no ='203.Onay Bekliyor'> !</td>
							</tr>
						<cfelseif len(get_offtime.validator_position_code_2) and len(get_offtime.valid_2) and get_offtime.valid_2 eq 1>
							<tr height="20">
								<td class="txtbold">2.<cf_get_lang no='992.Amir Onay'></td>
								<td><cfoutput>#get_emp_info(get_offtime.validator_position_code_2,1,0)#</cfoutput>&nbsp;&nbsp;
								<cf_get_lang_main no='1287.Onaylandı'>!</td>
							</tr>
						<cfelseif len(get_offtime.validator_position_code_2) and len(get_offtime.valid_2) and get_offtime.valid_2 eq 0>
							<tr height="20">
								<td class="txtbold">2.<cf_get_lang no='992.Amir Onay'></td>
								<td><cfoutput>#get_emp_info(get_offtime.validator_position_code_2,1,0)#</cfoutput>&nbsp;&nbsp;
								<cf_get_lang_main no ='205.Reddedildi'></td>
							</tr>
						</cfif>
						<cfif not len(get_offtime.valid)>
							<tr height="20">
								<td class="txtbold"><cf_get_lang no='1049.Onaylayacak'></td>
								<td>
								<cfif len(get_offtime.validator_position_code)>
									<cfset attributes.employee_id = "">
									<cfset attributes.position_code = get_offtime.validator_position_code>
									<cfquery name="GET_POSITION" datasource="#dsn#">
										SELECT
											EMPLOYEE_POSITIONS.DEPARTMENT_ID,
											DEPARTMENT.DEPARTMENT_HEAD,
											EMPLOYEE_POSITIONS.POSITION_ID,
											EMPLOYEE_POSITIONS.POSITION_CODE,
											EMPLOYEE_POSITIONS.POSITION_NAME,
											EMPLOYEE_POSITIONS.EMPLOYEE_ID,
											EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
											EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
											EMPLOYEES.EMPLOYEE_NO,
											EMPLOYEES.EMPLOYEE_EMAIL,
											BRANCH.BRANCH_NAME,
											BRANCH.BRANCH_ID,
											BRANCH.COMPANY_ID
										FROM
											EMPLOYEE_POSITIONS,
											EMPLOYEES,
											DEPARTMENT,
											BRANCH
										WHERE
											EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
											EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
											DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
										<cfif isDefined("attributes.EMPLOYEE_ID") and len(attributes.EMPLOYEE_ID)>
											AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
											AND EMPLOYEES.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
										</cfif>
										<cfif isDefined("attributes.POSITION_CODE") and len(attributes.POSITION_CODE)>
											AND EMPLOYEE_POSITIONS.POSITION_CODE = #attributes.POSITION_CODE#
										</cfif>
									</cfquery>
									<cfset pos_temp = "#get_position.employee_name# #get_position.employee_surname#">
								<cfelse>
									<cfset pos_temp = "">
								</cfif>
								<cfoutput>&nbsp;#pos_temp#</cfoutput>
								</td>
							</tr>
						<cfelse>
							<tr height="20">
								<td class="txtbold"><cf_get_lang no='96.Onay Durumu'>/<cf_get_lang_main no='1545.İmza'>:</td>
								<td>
								<cfif get_offtime.valid EQ 1>
									<cf_get_lang_main no='1287.Onaylandı'>!
									<cfoutput>
										#get_emp_info(get_offtime.VALID_EMPLOYEE_ID,0,0)# 
										#dateformat(date_add('h',session.ep.time_zone,get_offtime.validdate),dateformat_style)#
										(#timeformat(date_add('h',session.ep.time_zone,get_offtime.validdate),timeformat_style)#)</cfoutput>
								<cfelseif get_offtime.valid EQ 0>
									<cf_get_lang_main no='205.Reddedildi'>!
									<cfoutput>#get_emp_info(get_offtime.VALID_EMPLOYEE_ID,0,0)# 
									#dateformat(date_add('h',session.ep.time_zone,get_offtime.validdate),dateformat_style)#
									(#timeformat(date_add('h',session.ep.time_zone,get_offtime.validdate),timeformat_style)#)
									</cfoutput>
								</cfif>
								</td>
							</tr>
						</cfif>
							<tr height="20">
								<td colspan="2" height="250" valign="middle">
								<table border="0" width="100%">
									<tr>
										<td colspan="2">Yukarıda belirtilen tarihlerde izin talep ediyorum.<br/><br/></td>
									</tr>
									<tr>
										<cfoutput>
										<td style="width:160px;">
											#get_emp_info(get_offtime.employee_id,0,0)#<br/>
											#get_employee_info.POSITION_NAME#
											<br />
											<cf_get_lang_main no="1545.İmza">
										</td>
										<cfif len(get_offtime.validator_position_code_1)>
										<td style="width:160px;">
											#get_emp_info(get_offtime.validator_position_code_1,1,0)#
											<br />#get_offtime.AMIR1_POSITION_NAME#
											<br />
											<cf_get_lang_main no="1545.İmza">
										</td>
										</cfif>
										<cfif len(get_offtime.validator_position_code_2)>
										<td style="width:160px;">
											#get_emp_info(get_offtime.validator_position_code_2,1,0)#
											<br />#get_offtime.AMIR2_POSITION_NAME#
											<br />
											<cf_get_lang_main no="1545.İmza">
										</td>
										</cfif>
										</cfoutput>
									</tr>
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
			</td>
		</tr>
	</table>
<cfif isdefined('attributes.is_print')>
	<script type="text/javascript">
	function waitfor(){
	window.close();
	}	
	setTimeout("waitfor()",3000);
	window.print();
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
