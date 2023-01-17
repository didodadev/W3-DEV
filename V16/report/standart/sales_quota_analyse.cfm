<!--- 20080520 SM Kota ve satış analizi --->
<!---
	attributes.report_type 1 : Çalışan Bazında
	attributes.report_type 2 : Satış Bölgesi Bazında
	attributes.report_type 3 : Şube Bazında
	attributes.report_type 4 : Satış Takımı Bazında
	attributes.report_type 5 : Mikro Bölge Bazında
	attributes.report_type 6 : Müşteri Bazında
	attributes.report_type 7 : Ürün Kategorisi Bazında
 --->
<cfparam name="attributes.module_id_control" default="20,11">
<cfinclude template="report_authority_control.cfm">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.report_type" default="">
<cfparam name="attributes.plan_month1" default="">
<cfparam name="attributes.plan_month2" default="">
<cfparam name="attributes.graph_type" default="">
<cfparam name="attributes.report_action_type" default="1">
<cfparam name="attributes.plan_year" default="#session.ep.period_year#">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.ims_code_name" default="">
<cfparam name="attributes.ims_code_id" default="">
<cfparam name="attributes.team_name" default="">
<cfparam name="attributes.team_id" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.company_cat" default="">
<cfparam name="attributes.price_catid" default="">
<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
	SELECT PROCESS_CAT_ID,PROCESS_CAT,PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (50,52,53,531,58,561,54,55,51,63,48,49) ORDER BY PROCESS_CAT
</cfquery>
<cfquery name="PRICE_CATS" datasource="#DSN3#">
	SELECT PRICE_CATID, PRICE_CAT FROM PRICE_CAT ORDER BY PRICE_CAT
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfset month_list=''>
	<cfset tarih_farki = (attributes.plan_month2-attributes.plan_month1)>
	<cfloop from="#attributes.plan_month1#" to="#attributes.plan_month1+tarih_farki#" index="i">
		<cfset month_list=listappend(month_list,i)>
	</cfloop>
	<cfset new_dsn2 = '#dsn#_#attributes.plan_year#_#session.ep.company_id#'>
	<cfinclude template="../query/get_sales_quota_analyse.cfm">
</cfif>
<cfquery name="get_zone" datasource="#dsn#">
	SELECT * FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
</cfquery>
<cfquery name="get_company_cat" datasource="#dsn#">
	<!--- SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT --->
	SELECT DISTINCT	
		COMPANYCAT_ID,
		COMPANYCAT
	FROM
		GET_MY_COMPANYCAT
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		COMPANYCAT
</cfquery>
<cfquery name="get_all_period" datasource="#dsn#">
	SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH WHERE BRANCH_STATUS=1 ORDER BY BRANCH_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="rapor" action="#request.self#?fuseaction=report.sales_quota_analyse" method="post">
	<cf_report_list_search title="#getLang('report',997)# #getLang('report',945)#">
		<cf_report_list_search_area> 
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='164.Çalışan'></label>
									<div class="col col-12">
										<div class="input-group">
											<cf_wrk_employee_positions form_name='rapor' pos_code='employee_id' emp_name='employee_name'>
											<input type="hidden" name="employee_id" id="employee_id"  value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
											<input type="text" name="employee_name" id="employee_name" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','170');" autocomplete="off" style="width:170px;" value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" maxlength="255">
											<span class="input-group-addon btnPointer icon-ellipsis"  onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=rapor.employee_id&field_code=rapor.employee_id&field_name=rapor.employee_name&select_list=1,9','list');"></span>	
										</div>
									</div>		
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='722.Mikro Bölge Kodu'></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfif len(attributes.ims_code_name)><cfoutput>#attributes.ims_code_id#</cfoutput></cfif>">
											<input type="text" name="ims_code_name" id="ims_code_name" style="width:170px;" value="<cfif len(attributes.ims_code_name)><cfoutput>#attributes.ims_code_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('ims_code_name','IMS_CODE,IMS_CODE_NAME','IMS_NAME','get_ims_code','','IMS_CODE_ID','ims_code_id','','3','200');">
											<span class="input-group-addon btnPointer icon-ellipsis"  onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=rapor.ims_code_name&field_id=rapor.ims_code_id','list');"></span>					
										</div>
									</div>		
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang no ='564.Satış Takımı'></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="team_id" id="team_id" value="<cfif len(attributes.team_name)><cfoutput>#attributes.team_id#</cfoutput></cfif>">
											<input type="text" name="team_name" id="team_name" style="width:170px;" value="<cfif len(attributes.team_name)><cfoutput>#attributes.team_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('team_name','TEAM_NAME','TEAM_NAME,SZ_NAME','get_team','','TEAM_ID','team_id','','3','150');">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_sales_zones_team&field_sz_team_name=rapor.team_name&field_sz_team_id=rapor.team_id','list');">
											</span>		
										</div>
									</div>		
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='388.İşlem Tipi'></label>
									<div class="col col-12">
										<select name="process_type" id="process_type" style="width:170px; height:60px;" multiple>
											<cfoutput query="get_process_cat">
												<option value="#process_cat_id#" <cfif listfind(attributes.process_type,process_cat_id,',')>selected</cfif>>#process_cat#</option>
											</cfoutput>
										</select>
									</div>		
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='247.Satış Bölgesi'></label>
									<div class="col col-12">
										<select name="zone_id">
											<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
											<cfoutput query="get_zone">
												<option value="#sz_id#" <cfif attributes.zone_id eq sz_id>selected</cfif>>#sz_name#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='41.Şube'></label>
									<div class="col col-12">
										<select name="branch_id" id="branch_id">
											<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
											<cfoutput query="get_branch">
												<option value="#branch_id#"<cfif attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
											</cfoutput>
										</select>
									</div>	
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='1197.Üye Kategorisi'></label>
									<div class="col col-12">
										<select name="company_cat" id="company_cat">
											<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
											<cfoutput query="get_company_cat">
												<option value="#companycat_id#" <cfif attributes.company_cat eq companycat_id>selected</cfif>>#companycat#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='1552.Fiyat Listesi'></label>
									<div class="col col-12">
										<select name="price_catid" id="price_catid" style="width:150px; height:60px;" multiple>
											<cfloop query="price_cats">
												<cfoutput><option value="#price_catid#" <cfif listfind(attributes.price_catid,price_catid,',')>selected</cfif>>#price_cat#</option></cfoutput>
											</cfloop>
										</select>
									</div>
								</div>		
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='1312.Ay'></label>
									<div class="col col-6">
											<select name="plan_month1">
											<cfloop list="#ay_list()#" index="i">
												<cfoutput>
													<option value="#listfind(ay_list(),i)#" <cfif listfind(ay_list(),i) eq attributes.plan_month1>selected</cfif>>#i#</option>
												</cfoutput>
											</cfloop>
										</select>
									</div>
									<div class="col col-6">
											<select name="plan_month2">
											<cfloop list="#ay_list()#" index="i">
												<cfoutput>
													<option value="#listfind(ay_list(),i)#" <cfif listfind(ay_list(),i) eq attributes.plan_month2>selected</cfif>>#i#</option>
												</cfoutput>
											</cfloop>
										</select>
									</div>  
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='1060.Dönem'></label>
									<div class="col col-12">
										<select name="plan_year" id="plan_year">
											<cfoutput query="get_all_period">
												<option value="#period_year#" <cfif period_year eq attributes.plan_year>selected</cfif>>#period_year#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='1548.Rapor Tipi'></label>
									<div class="col col-12">
										<select name="report_type" id="report_type" style="width:120px;">
											<option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang no ='1001.Çalışan Bazında'></option>
											<option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang no ='541.Satış Bölgesi Bazında'></option>
											<option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang no ='629.Şube Bazında'></option>
											<option value="4" <cfif attributes.report_type eq 4>selected</cfif>><cf_get_lang no ='530.Satış Takımı Bazında'></option>
											<option value="5" <cfif attributes.report_type eq 5>selected</cfif>><cf_get_lang no ='632.Mikro Bölge Bazında'></option>
											<option value="6" <cfif attributes.report_type eq 6>selected</cfif>><cf_get_lang no ='536.Müşteri Bazında'></option>
											<option value="7" <cfif attributes.report_type eq 7>selected</cfif>><cf_get_lang no ='1002.Ürün Kategorisi Bazında'></option>
											<option value="8" <cfif attributes.report_type eq 8>selected</cfif>><cf_get_lang no ='374.Marka Bazında'></option>
											<option value="9" <cfif attributes.report_type eq 9>selected</cfif>><cf_get_lang no ='1011.Üye Kategorisi Bazında'></option>
										</select>						
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='538.Grafik'></label>
									<div class="col col-12">
										<select name="graph_type" id="graph_type" style="width:120px;">
											<option value="" selected><cf_get_lang_main no='322.Seçiniz'></option>
											<option value="bar"<cfif attributes.graph_type eq 'bar'> selected</cfif>><cf_get_lang_main no='251.Bar'></option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no='247.Satış Bölgesi'></label>
									<div class="col col-12">
										<label> 
											<input name="report_action_type" id="report_action_type" type="radio" value="1" <cfif attributes.report_action_type eq 1>checked</cfif>><cf_get_lang_main no ='29.Fatura'>
										</label>
										<label>
											<input name="report_action_type" id="report_action_type" type="radio" value="2" <cfif attributes.report_action_type eq 2>checked</cfif>><cf_get_lang_main no ='199.Sipariş'>	
										</label>
										<label>
										<cfif len(session.ep.money2)>
												<input name="is_doviz2" id="is_doviz2" type="checkbox" value="1" <cfif isdefined("attributes.is_doviz2")>checked</cfif>>2. <cf_get_lang_main no='265.Döviz'>
											</cfif>
										</label>
									</div>
								</div>
							</div>		
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
								<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang_main no='446.Excel Getir'> <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
								<input type="hidden" name="form_submitted" id="form_submitted" value="">
								<cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'>					
							</div>	  
					</div>
				</div>
			</div>
		</cf_report_list_search_area>	
  </cf_report_list_search>   
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>	
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cf_report_list>
		<cfif get_all_quotas.recordcount>
			<cfif attributes.report_type eq 1>
				<cfset emp_id_list = listsort(listdeleteduplicates(valuelist(get_all_quotas.employee_id,',')),'numeric','ASC',',')>
				<cfquery name="get_process" datasource="#dsn#">
					SELECT 
						<cfif database_type is "MSSQL">
							EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS PROCESS_NAME,
						<cfelseif database_type is "DB2">
							EMPLOYEE_NAME || ' ' || EMPLOYEE_SURNAME AS PROCESS_NAME,
						</cfif>
						EMPLOYEE_ID AS PROCESS_ID 
					FROM 
						EMPLOYEES 
					WHERE 
						EMPLOYEE_ID IN (#emp_id_list#) 
						<cfif isdefined("attributes.employee_name") and len(attributes.employee_name) and len(attributes.employee_id)>
							AND EMPLOYEE_ID = #attributes.employee_id#
						</cfif>
						<cfif isdefined("attributes.zone_id") and len(attributes.zone_id)>
							AND EMPLOYEE_ID IN
							(
								SELECT DISTINCT 
									EP.EMPLOYEE_ID 
								FROM 
									SALES_ZONES_TEAM SZT,
									SALES_ZONES_TEAM_ROLES IMC,
									EMPLOYEE_POSITIONS EP 
								WHERE 
									SZT.TEAM_ID = IMC.TEAM_ID 
									AND IMC.POSITION_CODE = EP.POSITION_CODE 
									AND SZT.SALES_ZONES=#attributes.zone_id#
								
							)
						</cfif>
						<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
							AND EMPLOYEE_ID IN
							(
								SELECT DISTINCT 
									EP.EMPLOYEE_ID 
								FROM 
									SALES_ZONES_TEAM SZT,
									SALES_ZONES_TEAM_ROLES IMC,
									EMPLOYEE_POSITIONS EP 
								WHERE 
									SZT.TEAM_ID = IMC.TEAM_ID 
									AND IMC.POSITION_CODE = EP.POSITION_CODE 
									AND SZT.RESPONSIBLE_BRANCH_ID=#attributes.branch_id#
							)
						</cfif>
						<cfif isdefined("attributes.team_name") and len(attributes.team_name) and len(attributes.team_id)>
							AND EMPLOYEE_ID IN
							(
								SELECT DISTINCT 
									EP.EMPLOYEE_ID 
								FROM 
									SALES_ZONES_TEAM SZT,
									SALES_ZONES_TEAM_ROLES IMC,
									EMPLOYEE_POSITIONS EP 
								WHERE 
									SZT.TEAM_ID = IMC.TEAM_ID 
									AND IMC.POSITION_CODE = EP.POSITION_CODE 
									AND SZT.TEAM_ID=#attributes.team_id#
							)
						</cfif>
						<cfif isdefined("attributes.ims_code_name") and len(attributes.ims_code_name) and len(attributes.ims_code_id)>
							AND EMPLOYEE_ID IN
							(
								SELECT DISTINCT 
									EP.EMPLOYEE_ID 
								FROM 
									SALES_ZONES_TEAM SZT,
									SALES_ZONES_TEAM_ROLES IMC,
									SALES_ZONES_TEAM_IMS_CODE SZTIMS,
									EMPLOYEE_POSITIONS EP 
								WHERE 
									SZT.TEAM_ID = IMC.TEAM_ID 
									AND SZT.TEAM_ID = SZTIMS.TEAM_ID 
									AND IMC.POSITION_CODE = EP.POSITION_CODE 
									AND SZTIMS.IMS_ID=#attributes.ims_code_id#
							)
						</cfif>
					ORDER BY 
						EMPLOYEE_NAME,
						EMPLOYEE_SURNAME
				</cfquery>
			<cfelseif attributes.report_type eq 2>
				<cfset zone_id_list = listsort(listdeleteduplicates(valuelist(get_all_quotas.zone_id,',')),'numeric','ASC',',')>
				<cfquery name="get_process" datasource="#dsn#">
					SELECT 
						SZ_NAME AS PROCESS_NAME,
						SZ_ID AS PROCESS_ID 
					FROM 
						SALES_ZONES 
					WHERE 
						SZ_ID IN (#zone_id_list#) 
						AND IS_ACTIVE=1 
						<cfif isdefined("attributes.employee_name") and len(attributes.employee_name) and len(attributes.employee_id)>
							AND SZ_ID IN
							(
								SELECT DISTINCT 
									SZT.SALES_ZONES
								FROM 
									SALES_ZONES_TEAM SZT,
									SALES_ZONES_TEAM_ROLES IMC,
									EMPLOYEE_POSITIONS EP 
								WHERE 
									SZT.TEAM_ID = IMC.TEAM_ID 
									AND IMC.POSITION_CODE = EP.POSITION_CODE 
									AND EP.EMPLOYEE_ID=#attributes.employee_id#						
							)
						</cfif>
						<cfif isdefined("attributes.zone_id") and len(attributes.zone_id)>
							AND SZ_ID = #attributes.zone_id#
						</cfif>
						<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
							AND RESPONSIBLE_BRANCH_ID=#attributes.branch_id#
						</cfif>
						<cfif isdefined("attributes.team_name") and len(attributes.team_name) and len(attributes.team_id)>
							AND SZ_ID IN
							(
								SELECT DISTINCT 
									SALES_ZONES
								FROM 
									SALES_ZONES_TEAM
								WHERE 	
									TEAM_ID=#attributes.team_id#
							)
						</cfif>
						<cfif isdefined("attributes.ims_code_name") and len(attributes.ims_code_name) and len(attributes.ims_code_id)>
							AND SZ_ID IN
							(
								SELECT DISTINCT 
									SALES_ZONES
								FROM 
									SALES_ZONES_TEAM SZT,
									SALES_ZONES_TEAM_IMS_CODE SZTIMS
								WHERE 
									SZT.TEAM_ID = SZTIMS.TEAM_ID 
									AND SZTIMS.IMS_ID=#attributes.ims_code_id#
							)
						</cfif>
					ORDER BY 
						SZ_NAME
				</cfquery>
			<cfelseif attributes.report_type eq 3>
				<cfset branch_id_list = listsort(listdeleteduplicates(valuelist(get_all_quotas.branch_id,',')),'numeric','ASC',',')>
				<cfquery name="get_process" datasource="#dsn#">
					SELECT 
						BRANCH_NAME AS PROCESS_NAME,
						BRANCH_ID AS PROCESS_ID 
					FROM 
						BRANCH 
					WHERE 
						BRANCH_ID IN (#branch_id_list#) 
						AND BRANCH_STATUS=1 
						<cfif isdefined("attributes.employee_name") and len(attributes.employee_name) and len(attributes.employee_id)>
							AND BRANCH_ID IN
							(
								SELECT DISTINCT 
									SZT.RESPONSIBLE_BRANCH_ID
								FROM 
									SALES_ZONES_TEAM SZT,
									SALES_ZONES_TEAM_ROLES IMC,
									EMPLOYEE_POSITIONS EP 
								WHERE 
									SZT.TEAM_ID = IMC.TEAM_ID 
									AND IMC.POSITION_CODE = EP.POSITION_CODE 
									AND EP.EMPLOYEE_ID=#attributes.employee_id#						
							)
						</cfif>
						<cfif isdefined("attributes.zone_id") and len(attributes.zone_id)>
							AND BRANCH_ID IN(SELECT RESPONSIBLE_BRANCH_ID FROM SALES_ZONES WHERE SZ_ID = #attributes.zone_id#)
						</cfif>
						<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
							AND BRANCH_ID = #attributes.branch_id#
						</cfif>
						<cfif isdefined("attributes.team_name") and len(attributes.team_name) and len(attributes.team_id)>
							AND BRANCH_ID IN
							(
								SELECT DISTINCT 
									RESPONSIBLE_BRANCH_ID
								FROM 
									SALES_ZONES_TEAM
								WHERE 	
									TEAM_ID=#attributes.team_id#
							)
						</cfif>
						<cfif isdefined("attributes.ims_code_name") and len(attributes.ims_code_name) and len(attributes.ims_code_id)>
							AND BRANCH_ID IN
							(
								SELECT DISTINCT 
									RESPONSIBLE_BRANCH_ID
								FROM 
									SALES_ZONES_TEAM SZT,
									SALES_ZONES_TEAM_IMS_CODE SZTIMS
								WHERE 
									SZT.TEAM_ID = SZTIMS.TEAM_ID 
									AND SZTIMS.IMS_ID=#attributes.ims_code_id#
							)
						</cfif>
					ORDER BY 
						BRANCH_NAME
				</cfquery>
			<cfelseif attributes.report_type eq 4>
				<cfset team_id_list = listsort(listdeleteduplicates(valuelist(get_all_quotas.team_id,',')),'numeric','ASC',',')>
				<cfquery name="get_process" datasource="#dsn#">
					SELECT 
						TEAM_NAME AS PROCESS_NAME,
						TEAM_ID AS PROCESS_ID 
					FROM 
						SALES_ZONES_TEAM 
					WHERE 
						TEAM_ID IN (#team_id_list#)
						<cfif isdefined("attributes.employee_name") and len(attributes.employee_name) and len(attributes.employee_id)>
							AND TEAM_ID IN
							(
								SELECT DISTINCT 
									SZT.TEAM_ID
								FROM 
									SALES_ZONES_TEAM SZT,
									SALES_ZONES_TEAM_ROLES IMC,
									EMPLOYEE_POSITIONS EP 
								WHERE 
									SZT.TEAM_ID = IMC.TEAM_ID 
									AND IMC.POSITION_CODE = EP.POSITION_CODE 
									AND EP.EMPLOYEE_ID=#attributes.employee_id#						
							)
						</cfif>
						<cfif isdefined("attributes.zone_id") and len(attributes.zone_id)>
							AND SALES_ZONES = #attributes.zone_id#
						</cfif>
						<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
							AND TEAM_ID IN
							(
								SELECT DISTINCT 
									TEAM_ID
								FROM 
									SALES_ZONES_TEAM
								WHERE 	
									RESPONSIBLE_BRANCH_ID=#attributes.branch_id#
							)
						</cfif>
						<cfif isdefined("attributes.team_name") and len(attributes.team_name) and len(attributes.team_id)>
							AND TEAM_ID = #attributes.team_id#
						</cfif>
						<cfif isdefined("attributes.ims_code_name") and len(attributes.ims_code_name) and len(attributes.ims_code_id)>
							AND TEAM_ID IN
							(
								SELECT DISTINCT 
									TEAM_ID
								FROM 
									SALES_ZONES_TEAM_IMS_CODE SZTIMS
								WHERE 
									SZTIMS.IMS_ID=#attributes.ims_code_id#
							)
						</cfif>
					ORDER BY 
						TEAM_NAME
				</cfquery>
			<cfelseif attributes.report_type eq 5>
				<cfset ims_id_list = listsort(listdeleteduplicates(valuelist(get_all_quotas.ims_code_id,',')),'numeric','ASC',',')>
				<cfquery name="get_process" datasource="#dsn#">
					SELECT 
						IMS_CODE_NAME AS PROCESS_NAME,
						IMS_CODE_ID AS PROCESS_ID 
					FROM 
						SETUP_IMS_CODE 
					WHERE 
						IMS_CODE_ID IN (#ims_id_list#) 
						<cfif isdefined("attributes.employee_name") and len(attributes.employee_name) and len(attributes.employee_id)>
							AND IMS_CODE_ID IN
							(
								SELECT DISTINCT 
									SZTIMS.IMS_ID
								FROM 
									SALES_ZONES_TEAM SZT,
									SALES_ZONES_TEAM_ROLES IMC,
									SALES_ZONES_TEAM_IMS_CODE SZTIMS,
									EMPLOYEE_POSITIONS EP 
								WHERE 
									SZT.TEAM_ID = IMC.TEAM_ID 
									AND SZT.TEAM_ID = SZTIMS.TEAM_ID 
									AND IMC.POSITION_CODE = EP.POSITION_CODE 
									AND EP.EMPLOYEE_ID=#attributes.employee_id#						
							)
						</cfif>
						<cfif isdefined("attributes.zone_id") and len(attributes.zone_id)>
							AND IMS_CODE_ID IN
							(
								SELECT DISTINCT 
									IMS_ID
								FROM 
									SALES_ZONES_TEAM SZT,
									SALES_ZONES_TEAM_IMS_CODE SZTIMS
								WHERE 
									SZT.TEAM_ID = SZTIMS.TEAM_ID 
									AND SZT.SALES_ZONES=#attributes.zone_id#
							)
						</cfif>
						<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
							AND IMS_CODE_ID IN
							(
								SELECT DISTINCT 
									IMS_ID
								FROM 
									SALES_ZONES_TEAM SZT,
									SALES_ZONES_TEAM_IMS_CODE SZTIMS
								WHERE 
									SZT.TEAM_ID = SZTIMS.TEAM_ID 
									AND SZT.RESPONSIBLE_BRANCH_ID=#attributes.branch_id#
							)
						</cfif>
						<cfif isdefined("attributes.team_name") and len(attributes.team_name) and len(attributes.team_id)>
							AND IMS_CODE_ID IN
							(
								SELECT DISTINCT 
									IMS_ID
								FROM 
									SALES_ZONES_TEAM_IMS_CODE SZTIMS
								WHERE 
									SZTIMS.TEAM_ID=#attributes.team_id#
							)
						</cfif>
						<cfif isdefined("attributes.ims_code_name") and len(attributes.ims_code_name) and len(attributes.ims_code_id)>
							AND IMS_CODE_ID = #attributes.ims_code_id#
						</cfif>
					ORDER BY 
						IMS_CODE_NAME
				</cfquery>
			<cfelseif attributes.report_type eq 6>
				<cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_all_quotas.company_id,',')),'numeric','ASC',',')>
				<cfquery name="get_process" datasource="#dsn#">
					SELECT
						FULLNAME AS PROCESS_NAME,
						COMPANY_ID AS PROCESS_ID 
					FROM
						COMPANY
					WHERE
						COMPANY_ID IN (#company_id_list#)
						<cfif len(attributes.company_cat)>
							AND COMPANYCAT_ID = #attributes.company_cat#
						</cfif>
					ORDER BY 
						FULLNAME
				</cfquery>
			<cfelseif attributes.report_type eq 7>
				<cfset productcat_id_list = listsort(listdeleteduplicates(valuelist(get_all_quotas.productcat_id,',')),'numeric','ASC',',')>
				<cfquery name="get_process" datasource="#dsn3#">
					SELECT
						PRODUCT_CAT AS PROCESS_NAME,
						PRODUCT_CATID AS PROCESS_ID 
					FROM
						PRODUCT_CAT
					WHERE
						PRODUCT_CATID IN (#productcat_id_list#)
					ORDER BY 
						PRODUCT_CAT
				</cfquery>
			<cfelseif attributes.report_type eq 8>
				<cfset brand_id_list = listsort(listdeleteduplicates(valuelist(get_all_quotas.brand_id,',')),'numeric','ASC',',')>
				<cfquery name="get_process" datasource="#dsn3#">
					SELECT
						BRAND_NAME AS PROCESS_NAME,
						BRAND_ID AS PROCESS_ID 
					FROM
						PRODUCT_BRANDS
					WHERE
						BRAND_ID IN (#brand_id_list#)
					ORDER BY 
						BRAND_NAME
				</cfquery>
			<cfelseif attributes.report_type eq 9>
				<cfset companycat_id_list = listsort(listdeleteduplicates(valuelist(get_all_quotas.companycat_id,',')),'numeric','ASC',',')>
				<cfquery name="get_process" datasource="#dsn#">
					SELECT
						COMPANYCAT AS PROCESS_NAME,
						COMPANYCAT_ID AS PROCESS_ID 
					FROM
						COMPANY_CAT
					WHERE
						COMPANYCAT_ID IN (#companycat_id_list#)
					ORDER BY 
						COMPANYCAT
				</cfquery>
			</cfif>
			<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>	
				<cfset attributes.startrow=1>
				<cfset attributes.maxrows=get_process.recordcount>
			</cfif>
			<cfparam name="attributes.totalrecords" default="#get_process.recordcount#">
	 	<cfelse>
			<cfparam name="attributes.totalrecords" default="0">
		</cfif>
			<cfset genel_toplam = 0>
			<cfset genel_toplam2 = 0>
			<cfset g_genel_toplam = 0>
			<cfset g_genel_toplam2 = 0>
				<thead>
					<tr>
						<!-- sil --><th></th><!-- sil -->
						<th></th>
						<th></th>
						<th width="1" nowrap></th>
						<cfloop list="#month_list#" index="k">
							<cfif isdefined("attributes.is_doviz2")>
								<cfset colspan_ = 11>
							<cfelse>
								<cfset colspan_ = 7>
							</cfif>
							<cfoutput><th align="center" colspan="#colspan_#" nowrap>#listgetat(ay_list(),k,',')#</th></cfoutput>
							<th width="1" nowrap></th>
							<cfquery name="get_quota_#k#" dbtype="query">
								SELECT * FROM get_all_quotas WHERE MONTH_VALUE = #k# 
								ORDER BY 
								<cfif attributes.report_type eq 1>
									EMPLOYEE_ID
								<cfelseif attributes.report_type eq 2>
									ZONE_ID
								<cfelseif attributes.report_type eq 3>
									BRANCH_ID
								<cfelseif attributes.report_type eq 4>
									TEAM_ID
								<cfelseif attributes.report_type eq 5>
									IMS_CODE_ID
								<cfelseif attributes.report_type eq 6>
									COMPANY_ID
								<cfelseif attributes.report_type eq 7>
									PRODUCTCAT_ID
								<cfelseif attributes.report_type eq 8>
									BRAND_ID
								<cfelseif attributes.report_type eq 9>
									COMPANYCAT_ID
								</cfif>
							</cfquery>
							<cfset 'ay_cat_list_#k#' = ''>
							<cfset 'toplam_ay_#k#' = 0>
							<cfset 'toplam_ay_2_#k#' = 0>
							<cfset 'g_toplam_ay_#k#' = 0>
							<cfset 'g_toplam_ay_2_#k#' = 0>
							<cfset quota_query = evaluate('get_quota_#k#')>
							<cfif quota_query.recordcount>
								<cfif attributes.report_type eq 1>
									<cfset 'ay_cat_list_#k#' = listsort(valuelist(quota_query.employee_id,','),'numeric','ASC',',')>
								<cfelseif attributes.report_type eq 2>
									<cfset 'ay_cat_list_#k#' = listsort(valuelist(quota_query.zone_id,','),'numeric','ASC',',')>
								<cfelseif attributes.report_type eq 3>
									<cfset 'ay_cat_list_#k#' = listsort(valuelist(quota_query.branch_id,','),'numeric','ASC',',')>
								<cfelseif attributes.report_type eq 4>
									<cfset 'ay_cat_list_#k#' = listsort(valuelist(quota_query.team_id,','),'numeric','ASC',',')>
								<cfelseif attributes.report_type eq 5>
									<cfset 'ay_cat_list_#k#' = listsort(valuelist(quota_query.ims_code_id,','),'numeric','ASC',',')>
								<cfelseif attributes.report_type eq 6>
									<cfset 'ay_cat_list_#k#' = listsort(valuelist(quota_query.company_id,','),'numeric','ASC',',')>	
								<cfelseif attributes.report_type eq 7>
									<cfset 'ay_cat_list_#k#' = listsort(valuelist(quota_query.productcat_id,','),'numeric','ASC',',')>	
								<cfelseif attributes.report_type eq 8>
									<cfset 'ay_cat_list_#k#' = listsort(valuelist(quota_query.brand_id,','),'numeric','ASC',',')>	
								<cfelseif attributes.report_type eq 9>
									<cfset 'ay_cat_list_#k#' = listsort(valuelist(quota_query.companycat_id,','),'numeric','ASC',',')>						
								</cfif>
							</cfif>
						</cfloop>
						<cfif isdefined("attributes.is_doviz2")>
							<cfset colspan_= 15>
						<cfelse>
							<cfset colspan_= 5>
						</cfif>
						<cfoutput>
							<th nowrap colspan="#colspan_#" align="center"><cf_get_lang_main no ='80.Toplam'></th>
						</cfoutput>
					</tr>
					<tr>
						<!-- sil --><th nodraw="1"></th><!-- sil -->
						<th><cf_get_lang_main no ='75.No'></th>
						<th>
							<cfif attributes.report_type eq 1>
								<cf_get_lang_main no ='164.Çalışan'>
							<cfelseif attributes.report_type eq 2>
								<cf_get_lang_main no ='247.Satış Bölgesi'>
							<cfelseif attributes.report_type eq 3>
								<cf_get_lang_main no='41.Şube'>
							<cfelseif attributes.report_type eq 4>
								<cf_get_lang no ='564.Satış Takımı'>
							<cfelseif attributes.report_type eq 5>
								<cf_get_lang no ='359.Mikro Bölge'>
							<cfelseif attributes.report_type eq 6>
								<cf_get_lang_main no='45.Müşteri'>
							<cfelseif attributes.report_type eq 7>
								<cf_get_lang_main no='1604.Ürün Kategorisi'>
							<cfelseif attributes.report_type eq 8>
								<cf_get_lang_main no='1435.Marka'>
							<cfelseif attributes.report_type eq 9>
								<cf_get_lang_main no='1197.Üye Kategorisi'>
							</cfif>
						</th>
						<th width="1" nowrap></th>
						<cfloop list="#month_list#" index="k">
							<th style="text-align:right;" nowrap width="50"><cf_get_lang_main no='1457.Planlanan'></th>
							<th nowrap><cf_get_lang_main no ='77.Para Br'></th>
							<th style="text-align:right;" nowrap><cf_get_lang no ='1004.Gerçekleşen'></th>
							<th nowrap><cf_get_lang_main no ='77.Para Br'></th>
							<cfif isdefined("attributes.is_doviz2")>
								<th style="text-align:right;" nowrap><cf_get_lang_main no='1457.Planlanan'></th>
								<th nowrap><cf_get_lang_main no ='77.Para Br'></th>
								<th style="text-align:right;" nowrap><cf_get_lang no ='1004.Gerçekleşen'></th>
								<th nowrap><cf_get_lang_main no ='77.Para Br'></th>
							</cfif>
							<th style="text-align:right;" nowrap><cf_get_lang_main no='1044.Oran'></th>
							<th style="text-align:right;" nowrap><cf_get_lang no ='1005.Planlanan Kar %'></th>
							<th style="text-align:right;" nowrap><cf_get_lang no ='1006.Gerçekleşen Kar %'></th>
							<th width="1" nowrap></th>
						</cfloop>
						<th style="text-align:right;" nowrap width="50"><cf_get_lang_main no='1457.Planlanan'></th>
						<th nowrap><cf_get_lang_main no ='77.Para Br'></th>
						<th style="text-align:right;" nowrap><cf_get_lang no ='1004.Gerçekleşen'></th>
						<th nowrap><cf_get_lang_main no ='77.Para Br'></th>
						<cfif isdefined("attributes.is_doviz2")>
							<th style="text-align:right;" nowrap><cf_get_lang_main no='1457.Planlanan'></th>
							<th nowrap><cf_get_lang_main no ='77.Para Br'></th>
							<th style="text-align:right;" nowrap><cf_get_lang no ='1004.Gerçekleşen'></th>
							<th nowrap><cf_get_lang_main no ='77.Para Br'></th>
						</cfif>
						<th style="text-align:right;" nowrap><cf_get_lang_main no='1044.Oran'></th>
					</tr>
				</thead>
				<cfif get_all_quotas.recordcount>
					<cfif attributes.page neq 1>
						<cfoutput query="get_process" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfset cat_toplam = 0>
							<cfset cat_toplam2 = 0>
							<cfset g_cat_toplam = 0>
							<cfset g_cat_toplam2 = 0>
							<cfloop list="#month_list#" index="ay_ind">
								<cfset quota_query = evaluate('get_quota_#ay_ind#')>
								<cfset indx = listfind(evaluate('ay_cat_list_#ay_ind#'),process_id,',')>
								<cfif indx>
									<cfset cat_toplam = cat_toplam + quota_query.row_total[indx]>
									<cfset 'toplam_ay_#ay_ind#' = evaluate('toplam_ay_#ay_ind#') + quota_query.row_total[indx]>					
									<cfif isdefined("attributes.is_doviz2")>
										<cfset cat_toplam2 = cat_toplam2 + quota_query.row_total2[indx]>
										<cfset 'toplam_ay_2_#ay_ind#' = evaluate('toplam_ay_2_#ay_ind#') + quota_query.row_total2[indx]>
									</cfif>
									<cfset g_cat_toplam = g_cat_toplam + quota_query.net_total[indx]>
									<cfset 'g_toplam_ay_#ay_ind#' = evaluate('g_toplam_ay_#ay_ind#') + quota_query.net_total[indx]>
									<cfif isdefined("attributes.is_doviz2")>
										<cfset g_cat_toplam2 = g_cat_toplam2 + quota_query.net_total2[indx]>
										<cfset 'g_toplam_ay_2_#ay_ind#' = evaluate('g_toplam_ay_2_#ay_ind#') + quota_query.net_total2[indx]>
									</cfif>
								</cfif>
							</cfloop>
							<cfset genel_toplam = genel_toplam + cat_toplam> 
							<cfset genel_toplam2 = genel_toplam2 + cat_toplam2>
							<cfset g_genel_toplam = g_genel_toplam + g_cat_toplam> 
							<cfset g_genel_toplam2 = g_genel_toplam2 + g_cat_toplam2>
						</cfoutput>
					</cfif>
					<tbody>
						<cfoutput query="get_process" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfset cat_toplam = 0>
							<cfset cat_toplam2 = 0>
							<cfset g_cat_toplam = 0>
							<cfset g_cat_toplam2 = 0>
							<tr class="nohover" style="width:10px;">
								<!-- sil -->
								<cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
									<td nodraw="1" id="emp_row#currentrow#" nowrap>
										<a href="javascript://" onClick="gizle_goster_image('emp_gizle#currentrow#','emp_goster#currentrow#','emp_detail#currentrow#');connectAjax('#process_id#','#currentrow#');">
											<img  src="/images/listele.gif" border="0" id="emp_goster#currentrow#" title="<cf_get_lang no ='1020.Grafik'><cf_get_lang_main no='1184.Göster'> "  style="display:;cursor:pointer;">
										</a>
										<a href="javascript://" onClick="gizle_goster_image('emp_gizle#currentrow#','emp_goster#currentrow#','emp_detail#currentrow#')" connectAjax('#process_id#','#currentrow#');>
											<img src="/images/listele_down.gif" border="0" title="<cf_get_lang_main no ='1216.Gizle'>" id="emp_gizle#currentrow#"  style="display:none;cursor:pointer;">
										</a>							
									</td>
								<cfelse>
									<td nodraw="1"></td>
								</cfif>
								<!-- sil -->
								<td>#currentrow#</td>
								<td nowrap>
									<cfif attributes.report_type eq 1>
										<cfif type_ eq 1>
											#process_name#
										<cfelse>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#process_id#','medium')">
											#process_name#
										</a>								
										</cfif>
									<cfelseif attributes.report_type eq 6>
										<cfif type_ eq 1>
											#process_name#
										<cfelse>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#process_id#','list')">
												#process_name#
											</a>								
										</cfif>
									<cfelse>
										#process_name#
									</cfif>
								</td>
								<td width="1" nowrap></td>
								<cfloop list="#month_list#" index="ay_ind">
									<cfset quota_query = evaluate('get_quota_#ay_ind#')>
									<cfset indx = listfind(evaluate('ay_cat_list_#ay_ind#'),process_id,',')>
									<cfif indx>
										<td style="text-align:right;" nowrap format="numeric">#TlFormat(quota_query.row_total[indx])# </td>
										<td style="text-align:center;">#session.ep.money#</td>
										<td style="text-align:right;" nowrap format="numeric">#TlFormat(quota_query.net_total[indx])# </td>
										<td style="text-align:center;">#session.ep.money#</td>
										<cfif isdefined("attributes.is_doviz2")>
											<td style="text-align:right;" nowrap format="numeric">#TlFormat(quota_query.row_total2[indx])# </td>
											<td style="text-align:center;">#session.ep.money2#</td>
											<td style="text-align:right;" nowrap format="numeric">#TlFormat(quota_query.net_total2[indx])# </td>
											<td style="text-align:center;">#session.ep.money2#</td>
											<cfset cat_toplam2 = cat_toplam2 + quota_query.row_total2[indx]>
											<cfset g_cat_toplam2 = g_cat_toplam2 + quota_query.net_total2[indx]>
											<cfset 'toplam_ay_2_#ay_ind#' = evaluate('toplam_ay_2_#ay_ind#') + quota_query.row_total2[indx]>
											<cfset 'g_toplam_ay_2_#ay_ind#' = evaluate('g_toplam_ay_2_#ay_ind#') + quota_query.net_total2[indx]>
										</cfif>
										<td style="text-align:right;" nowrap format="numeric">%<cfif quota_query.row_total[indx] gt 0>#TLFormat(quota_query.net_total[indx]*100/quota_query.row_total[indx])#<cfelse>#TLFormat(100)#</cfif></td>
										<td style="text-align:right;" nowrap format="numeric">% #TlFormat(quota_query.row_profit[indx])#</td>
										<td style="text-align:right;" nowrap format="numeric">%<cfif quota_query.net_total[indx] neq 0>#TlFormat(quota_query.net_kar[indx]*100/quota_query.net_total[indx])#<cfelse>0</cfif></td>
										<cfset cat_toplam = cat_toplam + quota_query.row_total[indx]>
										<cfset g_cat_toplam = g_cat_toplam + quota_query.net_total[indx]> 
										<cfset 'toplam_ay_#ay_ind#' = evaluate('toplam_ay_#ay_ind#') + quota_query.row_total[indx]>
										<cfset 'g_toplam_ay_#ay_ind#' = evaluate('g_toplam_ay_#ay_ind#') + quota_query.net_total[indx]>
									<cfelse>
										<td style="text-align:right;" nowrap>#TlFormat(0)#</td>
										<td style="text-align:center;">#session.ep.money#</td>
										<td style="text-align:right;" nowrap>#TlFormat(0)#</td>
										<td style="text-align:center;">#session.ep.money#</td>
										<cfif isdefined("attributes.is_doviz2")>
											<td style="text-align:right;" nowrap>#TlFormat(0)#</td>
											<td style="text-align:center;">#session.ep.money#</td>
											<td style="text-align:right;" nowrap>#TlFormat(0)#</td>
											<td style="text-align:center;">#session.ep.money#</td>
										</cfif>
										<td style="text-align:right;" nowrap>% #TlFormat(0)#</td>
										<td style="text-align:right;" nowrap>% #TlFormat(0)#</td>
										<td style="text-align:right;" nowrap>% #TlFormat(0)#</td>
									</cfif>
									<td width="1" nowrap></td>
								</cfloop>
								<td style="text-align:right;" nowrap>#TlFormat(cat_toplam)# </td>
								<td style="text-align:center;">#session.ep.money#</td>
								<td style="text-align:right;" nowrap>#TlFormat(g_cat_toplam)# </td>
								<td style="text-align:center;">#session.ep.money#</td>
								<cfif isdefined("attributes.is_doviz2")>
									<td style="text-align:right;" nowrap>#TlFormat(cat_toplam2)# </td>
									<td style="text-align:center;">#session.ep.money2#</td>
									<td style="text-align:right;" nowrap>#TlFormat(g_cat_toplam2)# </td>
									<td style="text-align:center;">#session.ep.money2#</td>
								</cfif>
								<td style="text-align:right;" nowrap>%<cfif cat_toplam gt 0>#TlFormat(g_cat_toplam*100/cat_toplam)#<cfelse>#TLFormat(100)#</cfif></td>
								<cfset genel_toplam = genel_toplam + cat_toplam> 
								<cfset genel_toplam2 = genel_toplam2 + cat_toplam2>
								<cfset g_genel_toplam = g_genel_toplam + g_cat_toplam> 
								<cfset g_genel_toplam2 = g_genel_toplam2 + g_cat_toplam2>
							</tr>
							<cfif isdefined("attributes.is_doviz2")>
								<cfset colspan_other = 19+(listlen(month_list)*12)>
							<cfelse>
								<cfset colspan_other = 9+(listlen(month_list)*8)>
							</cfif>
							<!-- sil -->
							<cfif type_ eq 0>
								<tr id="emp_detail#currentrow#" class="nohover" style="display:none">
									<td colspan="#colspan_other#">
										<div style="text-align:left;" id="display_emp_detail#currentrow#"></div>
									</td>
								</tr>
							</cfif>
							<!-- sil -->
						</cfoutput>
					</tbody>
					<tfoot>
							<tr>
								<cfoutput>
								<!-- sil --><td nodraw="1"></td><!-- sil -->
								<td colspan="2" style="text-align:right;" class="txtbold"><cf_get_lang_main no='80.Toplam'></td>
								<td width="1" nowrap></td>
								<cfloop list="#month_list#" index="ay_ind">
									<td style="text-align:right;" nowrap class="txtbold">#TlFormat(evaluate('toplam_ay_#ay_ind#'))# </td>
									<td style="text-align:center;" class="txtbold">#session.ep.money#</td>
									<td style="text-align:right;" nowrap class="txtbold">#TlFormat(evaluate('g_toplam_ay_#ay_ind#'))# </td>
									<td style="text-align:center;" class="txtbold">#session.ep.money#</td>
									<cfif isdefined("attributes.is_doviz2")>
										<td style="text-align:right;" nowrap class="txtbold">#TlFormat(evaluate('toplam_ay_2_#ay_ind#'))# </td>
										<td style="text-align:center;" class="txtbold">#session.ep.money2#</td>
										<td style="text-align:right;" nowrap class="txtbold">#TlFormat(evaluate('g_toplam_ay_2_#ay_ind#'))# </td>
										<td style="text-align:center;" class="txtbold">#session.ep.money2#</td>
									</cfif>
									<td style="text-align:right;" nowrap class="txtbold">%<cfif evaluate('toplam_ay_#ay_ind#') gt 0>#TlFormat(evaluate('g_toplam_ay_#ay_ind#')*100/evaluate('toplam_ay_#ay_ind#'))#<cfelse>#TLFormat(100)#</cfif></td>
									<td></td>
									<td></td>
									<td width="1" nowrap></td>
								</cfloop>
								<td style="text-align:right;" nowrap class="txtbold">#TlFormat(genel_toplam)# </td>
								<td style="text-align:center;" class="txtbold">#session.ep.money#</td>
								<td style="text-align:right;" nowrap class="txtbold">#TlFormat(g_genel_toplam)# </td>
								<td style="text-align:center;" class="txtbold">#session.ep.money#</td>
								<cfif isdefined("attributes.is_doviz2")>
									<td style="text-align:right;" nowrap class="txtbold">#TlFormat(genel_toplam2)#</td>
									<td style="text-align:center;" class="txtbold">#session.ep.money2#</td>
									<td style="text-align:right;" nowrap class="txtbold">#TlFormat(g_genel_toplam2)# </td>
									<td style="text-align:center;" class="txtbold">#session.ep.money2#</td>
								</cfif>
								<td style="text-align:right;" nowrap class="txtbold">%<cfif genel_toplam gt 0>#TlFormat(g_genel_toplam*100/genel_toplam)#<cfelse>#TLFormat(100)#</cfif></td>
								</cfoutput>
							</tr>
						</tfoot>
				<cfelse>
					<cfif isdefined("attributes.is_doviz2")>
						<cfset colspan_other = 13+(listlen(month_list)*12)>
					<cfelse>
						<cfset colspan_other = 9+(listlen(month_list)*8)>
					</cfif>
					<tr>
				<cfoutput><td colspan="#colspan_other#"><cf_get_lang_main no='72.Kayıt Yok'>!</td></cfoutput>
					</tr>
				</cfif>
	</cf_report_list>
	<cfif len(attributes.graph_type) and isdefined('get_all_quotas.recordcount') and get_all_quotas.recordcount>
			<cfset chart_width = listlen(month_list)*150+100>
			<script src="JS/Chart.min.js"></script> 
			<canvas id="myChart" style="float:left;max-width:600px;max-height:600px;"></canvas>
			<script>
				var ctx = document.getElementById('myChart');
					var myChart = new Chart(ctx, {
						type: '<cfoutput>#graph_type#</cfoutput>',
						data: {
							labels: [<cfloop list="#month_list#" index="ay_indx">
											<cfoutput>"#listgetat(ay_list(),ay_indx,',')#"</cfoutput>,</cfloop>"Toplam"],
							datasets: [{
								label: "Planlanan",
								backgroundColor: [<cfloop list="#month_list#" index="ay_indx">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>'rgb(255, 99, 132)'],
								data: [<cfloop list="#month_list#" index="ay_indx"><cfoutput>#NumberFormat(evaluate('toplam_ay_#ay_indx#'),'00')#</cfoutput>,</cfloop><cfoutput><cfif genel_toplam eq 0>0.1<cfelse>#NumberFormat(genel_toplam,'00.00')#</cfif></cfoutput>],
							},
							{
								label: "Gerçekleşen",
								backgroundColor: [<cfloop list="#month_list#" index="ay_indx">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>'rgba(255, 99, 132, 0.2)'],
								data: [<cfloop list="#month_list#" index="ay_indx"><cfoutput>#NumberFormat(evaluate('g_toplam_ay_#ay_indx#'),'00')#</cfoutput>,</cfloop><cfoutput>#NumberFormat(g_genel_toplam,'00.00')#</cfoutput>],
							}
							]
						},
						options: {}
				})
			</script>									
	</cfif> 
	<cfset adres = "">
	<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres = "report.sales_quota_analyse&form_submitted=1">
			<!--- <cfset adres = "#adres#&plan_month1=#attributes.plan_month1#">
			<cfset adres = "#adres#&plan_month2=#attributes.plan_month2#">
			<cfset adres = "#adres#&plan_year=#attributes.plan_year#">
			<cfset adres = "#adres#&action_type=#attributes.report_action_type#">
			<cfset adres = "#adres#&report_type=#attributes.report_type#"> --->
			<cfif len(attributes.plan_month1)>
				<cfset adres = "#adres#&plan_month1=#attributes.plan_month1#">
			</cfif>
			<cfif len(attributes.plan_month2)>
				<cfset adres = "#adres#&plan_month2=#attributes.plan_month2#">
			</cfif>
			<cfif len(attributes.plan_year)>
				<cfset adres = "#adres#&plan_year=#attributes.plan_year#">
			</cfif>
			<cfif len(attributes.report_action_type)>
				<cfset adres = "#adres#&report_action_type=#attributes.report_action_type#">
			</cfif>
			<cfif len(attributes.report_type)>
				<cfset adres = "#adres#&report_type=#attributes.report_type#">
			</cfif>
			<cfif len(attributes.module_id_control)>
				<cfset adres = "#adres#&module_id_control=#attributes.module_id_control#">
			</cfif>
			<cfif len(attributes.employee_id)>
				<cfset adres = "#adres#&employee_id=#attributes.employee_id#">
			</cfif>
			<cfif len(attributes.graph_type) and isDefined("attributes.graph_type")>
				<cfset adres = "#adres#&graph_type=#attributes.graph_type#">
			</cfif>
			<cfif len(attributes.employee_name)>
				<cfset adres = "#adres#&employee_name=#attributes.employee_name#">
			</cfif>
			<cfif len(attributes.ims_code_id)>
				<cfset adres = "#adres#&ims_code_id=#attributes.ims_code_id#">
			</cfif>
			<cfif len(attributes.ims_code_name)>
				<cfset adres = "#adres#&ims_code_name=#attributes.ims_code_name#">
			</cfif>
			<cfif len(attributes.team_id)>
				<cfset adres = "#adres#&team_id=#attributes.team_id#">
			</cfif>
			<cfif len(attributes.team_name)>
				<cfset adres = "#adres#&team_name=#attributes.team_name#">
			</cfif>
			<cfif len(attributes.zone_id)>
				<cfset adres = "#adres#&zone_id=#attributes.zone_id#">
			</cfif>
			<cfif len(attributes.process_type)>
				<cfset adres = "#adres#&process_type=#attributes.process_type#">
			</cfif>
			<cfif len(attributes.price_catid)>
				<cfset adres = "#adres#&price_catid=#attributes.price_catid#">
			</cfif>
			<cfif len(attributes.company_cat)>
				<cfset adres = "#adres#&company_cat=#attributes.company_cat#">
			</cfif>
			<cfif len(attributes.branch_id)>
				<cfset adres = "#adres#&branch_id=#attributes.branch_id#">
			</cfif>			
     		<cfif isdefined("attributes.is_doviz2")>
				<cfset adres = "#adres#&is_doviz2=#attributes.is_doviz2#">
			</cfif> 
			<cf_paging 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#">
	</cfif>
</cfif>
<script type="text/javascript">
	function control()
	{
		if(((document.rapor.plan_month1.value) - (document.rapor.plan_month2.value)) > 0)
		{
			alert("<cf_get_lang_main no='1537.Başlangıç Ayı Bitiş Ayından Büyük Olamaz'>")
			return false;
		}

		if(document.rapor.is_excel.checked==false)
		{
			document.rapor.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
			return true;
		}
		else
			document.rapor.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_sales_quota_analyse</cfoutput>";
	}
	function connectAjax(process_id,crtrow)
	{
		if(rapor.report_action_type[0].checked)
			act_type = 1;
		else
			act_type = 2;
		if(document.rapor.graph_type.value == '')
			grp_type = 'bar';
		else
			grp_type = document.rapor.graph_type.value;
		price_catid = document.rapor.price_catid.value;
		process_type = document.rapor.process_type.value;
		var bb = '<cfoutput>#request.self#?fuseaction=report.popupajax_detail_quota_graph</cfoutput>&process_type='+process_type+'&price_catid='+price_catid+'&plan_month1='+document.rapor.plan_month1.value+'&plan_month2='+document.rapor.plan_month2.value+'&plan_year='+document.rapor.plan_year.value+'&report_type='+document.rapor.report_type.value+'&report_action_type='+act_type+'&graph_type='+grp_type+'&process_id='+ process_id;
		AjaxPageLoad(bb,'display_emp_detail'+crtrow,1);
	}
</script>