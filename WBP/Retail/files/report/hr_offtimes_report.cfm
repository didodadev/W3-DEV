<!--- is bu dosyadaki rapor sube sube olmak kaydiyla son 12 ay icersinde aldiklari ek odenekleri son brut maaslari ve kisisel kidem ve sigorta bilgilerini excel olarak verir--->
<!--- created by yemre YO03032006 gunun son mesai dakikalari--->
<!---<cfif not (get_module_power_user(3) and session.ep.ehesap)>
	<script type="text/javascript">
		alert('Yetkiniz Yok!');
		history.back();
	</script>
	<cfabort>
</cfif>--->
<cfsetting showdebugoutput="no">
<cfparam name="attributes.gun_say" default="365">
<cfparam name="attributes.finish_date" default="#dateformat(now(),'dd/mm/yyyy')#">
<cfparam name="attributes.ssk_type" default="1">
<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
	SELECT START_DATE,FINISH_DATE FROM SETUP_GENERAL_OFFTIMES
</cfquery>
<cfset offday_list = ''>
<cfoutput query="GET_GENERAL_OFFTIMES">
	<cfscript>
		offday_gun = datediff('d',GET_GENERAL_OFFTIMES.start_date,GET_GENERAL_OFFTIMES.finish_date)+1;
		offday_startdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.start_date); 
		offday_finishdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.finish_date);
		
		for (mck=0; mck lt offday_gun; mck=mck+1)
			{
			temp_izin_gunu = date_add("d",mck,offday_startdate);
			daycode = '#dateformat(temp_izin_gunu,'dd/mm/yyyy')#';
			if(not listfindnocase(offday_list,'#daycode#'))
				offday_list = listappend(offday_list,'#daycode#');
			}
	</cfscript>
</cfoutput>
<cfquery name="get_progress_payment_outs" datasource="#dsn#">
	SELECT EMP_ID,START_DATE,FINISH_DATE,PROGRESS_TIME,IS_KIDEM,IS_YEARLY FROM EMPLOYEE_PROGRESS_PAYMENT_OUT
</cfquery>
<cfquery name="get_offtime_limits" datasource="#dsn#">
	SELECT 
		LIMIT_ID,
		<cfloop from="1" to="5" index="i">
		LIMIT_#i#,
		LIMIT_#i#_DAYS,
		</cfloop> 
		MIN_YEARS,
		MAX_YEARS,
		MIN_MAX_DAYS,
		SATURDAY_ON,
		DAY_CONTROL,
		STARTDATE,
		FINISHDATE
	FROM 
		SETUP_OFFTIME_LIMIT
</cfquery>
<cfquery name="get_pos_cats" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
</cfquery>
<cfquery name="get_emp_branch" datasource="#DSN#">
	SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #SESSION.EP.POSITION_CODE#
</cfquery>
<cfset emp_branch_list=valuelist(get_emp_branch.BRANCH_ID)>
<cfquery name="get_branches" datasource="#dsn#">
	SELECT
		BRANCH_ID,
		BRANCH_NAME,
        COMPANY_ID
	FROM 
		BRANCH 
	WHERE 
		BRANCH_STATUS = 1 AND
		BRANCH_ID IS NOT NULL 
	<!---	<cfif not session.ep.ehesap>
			AND BRANCH_ID IN (#emp_branch_list#)
		</cfif>--->
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfquery name="get_our_comps" datasource="#DSN#">
	SELECT NICK_NAME,COMP_ID FROM OUR_COMPANY ORDER BY NICK_NAME
</cfquery>
<cfset ay_listesi ="Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık">
<cf_report_list_search title="#getLang('','İzin Raporu',31157)#">
    <cf_report_list_search_area>
        <cfform name="ara_form" method="post" action="#request.self#?fuseaction=retail.hr_offtimes_report">
            <input type="hidden" name="maxrows" id="maxrows">
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
										<div class="col col-12">
											<select name="comp_id" id="comp_id" onchange="select_branch(this.value)">
                                                <option value=""><cf_get_lang dictionary_id='47851.Şirket Seçiniz'></option>
                                                <cfoutput query="get_our_comps">
                                                    <option value="#comp_id#" <cfif isdefined("attributes.comp_id") and attributes.comp_id eq comp_id>selected</cfif>>#NICK_NAME#</option>
                                                </cfoutput>
                                            </select>
										</div>
									</div>
                                    <div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
										<div class="col col-12">
                                            <select name="branch_id" id="branch_id">
                                                <option value=""><cf_get_lang dictionary_id='30126.Şube Seçiniz'></option>
                                                <cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
                                                    <cfquery name="get_branch" dbtype="query">
                                                        SELECT BRANCH_ID,BRANCH_NAME FROM get_branches WHERE COMPANY_ID= #attributes.comp_id#
                                                    </cfquery>                        
                                                    <cfoutput query="get_branch">
                                                        <option value="#BRANCH_ID#" <cfif attributes.branch_id eq BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
                                                    </cfoutput>
                                                </cfif>
                                            </select>
										</div>
									</div>
                                    <div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
										<div class="col col-12">
                                            <select name="pos_cat_id" id="pos_cat_id">
                                                <option value=""><cf_get_lang dictionary_id='62813.Pozisyon Tipi Seçiniz'></option>
                                                <cfoutput query="get_pos_cats">
                                                    <option value="#POSITION_CAT_ID#" <cfif isdefined("attributes.pos_cat_id") and attributes.pos_cat_id eq POSITION_CAT_ID>selected</cfif>>#POSITION_CAT#</option>
                                                </cfoutput>	
                                            </select>
										</div>
									</div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57490.Gün'></label>
										<div class="col col-12">
											<select name="gun_say" id="gun_say">
                                                <option value="365" <cfif isdefined("attributes.gun_say") and attributes.gun_say eq 365>selected</cfif>>365 <cf_get_lang dictionary_id='39268.Gün Üzerinden'></option>
                                                <option value="360"<cfif isdefined("attributes.gun_say") and attributes.gun_say eq 360>selected</cfif>>360 <cf_get_lang dictionary_id='39268.Gün Üzerinden'></option>
                                            </select>
										</div>
									</div>
                                    <div class="form-group">
										<label class="col col-12 col-xs-12">SGK</label>
										<div class="col col-12">
											<select name="ssk_type" id="ssk_type">
                                                <option value="1" <cfif isdefined("attributes.ssk_type") and attributes.ssk_type eq 1>selected</cfif>><cf_get_lang dictionary_id='54046.SGK lı Çalışan'></option>
                                                <option value="0"<cfif isdefined("attributes.ssk_type") and attributes.ssk_type eq 0>selected</cfif>><cf_get_lang dictionary_id='54047.SGK lı Olmayan'></option>
                                                <option value="2"<cfif isdefined("attributes.ssk_type") and attributes.ssk_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'></option>
                                            </select>
										</div>
									</div>
                                    <div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
										<div class="col col-12">
											<div class="input-group">
                                                <cfinput value="#attributes.finish_date#" type="text" name="finish_date" message=""  validate="eurodate">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                            </div>
										</div>
									</div>
                                </div>
                            </div>
                        </div>
                        <div class="row ReportContentBorder">
                            <div class="ReportContentFooter">
                                <cf_wrk_search_button button_type='1'>
                            </div>	  
                        </div>
                    </div>
                </div>
            </div>
        </cfform>
    </cf_report_list_search_area>
</cf_report_list_search>

    
<cfif isdefined("attributes.branch_id")>
<cf_date tarih = "attributes.finish_date">
<cfset puantaj_gun_ = day(attributes.finish_date)>
<cfset puantaj_start_ = CREATEDATE(year(attributes.finish_date),month(attributes.finish_date),day(attributes.finish_date))>
<cfset puantaj_finish_ = CREATEODBCDATETIME(CREATEDATE(year(attributes.finish_date),month(attributes.finish_date),puantaj_gun_))>
<cfset my_baz_date = puantaj_finish_>
<cfset attributes.months = month(attributes.finish_date)>
<cfset attributes.years = year(attributes.finish_date)>
<cfquery name="get_seniority_comp_max" datasource="#dsn#">
	SELECT ISNULL(SENIORITY_COMPANSATION_MAX,0) AS SENIORITY_COMPANSATION_MAX FROM INSURANCE_PAYMENT WHERE STARTDATE <= #puantaj_start_#  AND FINISHDATE >= #puantaj_start_#
</cfquery>
<cfset kidem_max = get_seniority_comp_max.seniority_compansation_max>
<cfquery name="get_emp" datasource="#dsn#">
	SELECT 
		EI.USE_SSK,
        E.EMPLOYEE_ID,
		E.EMPLOYEE_NO,
		E.EMPLOYEE_NAME EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
		D.DEPARTMENT_HEAD,
		B.BRANCH_NAME,
		B.RELATED_COMPANY,
		EI.START_DATE START_DATE,
		EI.FINISH_DATE,
		EI.FIRST_SSK_DATE,
		EI.SOCIALSECURITY_NO,
		EI.SSK_STATUTE,
		EI.GROSS_NET,
		EII.TC_IDENTY_NO,
		EII.BIRTH_DATE,
		E.GROUP_STARTDATE,
		E.IZIN_DATE,
		E.IZIN_DAYS,
		EXPLANATION_ID,
		E.KIDEM_DATE,
		DATEDIFF(DD,E.KIDEM_DATE,GETDATE()) AS Kıdem_gun,
		ED.SEX,
		ES.M#month(attributes.finish_date)#,
		SPC.POSITION_CAT,
		ST.TITLE,
		EI.BRANCH_ID,
		EI.PUANTAJ_GROUP_IDS
	FROM 
		EMPLOYEES_IN_OUT EI,
		EMPLOYEES E,
		BRANCH B,
		DEPARTMENT D,
		EMPLOYEES_IDENTY EII,
		EMPLOYEES_DETAIL ED,
		EMPLOYEES_SALARY ES,
		EMPLOYEE_POSITIONS EP,
		SETUP_POSITION_CAT SPC,
		SETUP_TITLE ST
	WHERE
		<cfif attributes.ssk_type eq 1>
        	EI.USE_SSK = 1 AND
        </cfif>
        <cfif attributes.ssk_type eq 0>
        	EI.USE_SSK = 0 AND
        </cfif>
		<cfif isdefined("attributes.pos_cat_id") and len(attributes.pos_cat_id)>
			EP.POSITION_CAT_ID = #attributes.pos_cat_id# AND
		</cfif>
		<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
			B.COMPANY_ID = #attributes.comp_id# AND
		</cfif>
		<cfif len(attributes.branch_id)>B.BRANCH_ID = #attributes.branch_id# AND</cfif>
	<!---	<cfif not session.ep.ehesap>B.BRANCH_ID IN (#emp_branch_list#) AND</cfif>--->
		(EI.START_DATE <= #puantaj_finish_# AND EI.START_DATE IS NOT NULL) AND
		( EI.FINISH_DATE IS NULL) AND
		EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		EP.IS_MASTER = 1 AND
		EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID AND
		EP.TITLE_ID = ST.TITLE_ID AND
		ES.IN_OUT_ID = EI.IN_OUT_ID AND
		ES.PERIOD_YEAR = #year(attributes.finish_date)# AND
		ED.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		EII.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		EI.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		EI.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		EI.BRANCH_ID = B.BRANCH_ID 
<cfif not isdefined("attributes.pos_cat_id") or not len(attributes.pos_cat_id)>
UNION ALL
	SELECT 
		EI2.USE_SSK,
        E2.EMPLOYEE_ID,
		E2.EMPLOYEE_NO,
		E2.EMPLOYEE_NAME EMPLOYEE_NAME,
		E2.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
		D2.DEPARTMENT_HEAD,
		B2.BRANCH_NAME,
		B2.RELATED_COMPANY,
		EI2.START_DATE START_DATE,
		EI2.FINISH_DATE,
		EI2.FIRST_SSK_DATE,
		EI2.SOCIALSECURITY_NO,
		EI2.SSK_STATUTE,
		EI2.GROSS_NET,
		EII2.TC_IDENTY_NO,
		EII2.BIRTH_DATE,
		E2.GROUP_STARTDATE,
		E2.IZIN_DATE,
		E2.IZIN_DAYS,
		EI2.EXPLANATION_ID,
		E2.KIDEM_DATE,
		DATEDIFF(DD,E2.KIDEM_DATE,GETDATE()) AS Kıdem_gun,
		ED2.SEX,
		ES2.M#month(attributes.finish_date)#,
		'' AS POSITION_CAT,
		'' AS TITLE,
		EI2.BRANCH_ID,
		EI2.PUANTAJ_GROUP_IDS
	FROM 
		EMPLOYEES_IN_OUT EI2,
		EMPLOYEES E2,
		BRANCH B2,
		DEPARTMENT D2,
		EMPLOYEES_IDENTY EII2,
		EMPLOYEES_DETAIL ED2,
		EMPLOYEES_SALARY ES2
	WHERE
		<cfif attributes.ssk_type eq 1>
        	EI2.USE_SSK = 1 AND
        </cfif>
        <cfif attributes.ssk_type eq 0>
        	EI2.USE_SSK = 0 AND
        </cfif>
        E2.EMPLOYEE_ID NOT IN (SELECT EP2.EMPLOYEE_ID FROM EMPLOYEE_POSITIONS EP2 WHERE EP2.IS_MASTER = 1 AND EP2.EMPLOYEE_ID IS NOT NULL) AND
		<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
			B2.COMPANY_ID = #attributes.comp_id# AND
		</cfif>
		<cfif len(attributes.branch_id)>B2.BRANCH_ID = #attributes.branch_id# AND</cfif>
		<!---<cfif not session.ep.ehesap>B2.BRANCH_ID IN (#emp_branch_list#) AND</cfif>--->
		(EI2.START_DATE <= #puantaj_finish_# AND EI2.START_DATE IS NOT NULL) AND
		( EI2.FINISH_DATE IS NULL) AND
		ES2.IN_OUT_ID = EI2.IN_OUT_ID AND
		ES2.PERIOD_YEAR = #year(attributes.finish_date)# AND
		ED2.EMPLOYEE_ID = E2.EMPLOYEE_ID AND
		EII2.EMPLOYEE_ID = E2.EMPLOYEE_ID AND
		EI2.EMPLOYEE_ID = E2.EMPLOYEE_ID AND
		EI2.DEPARTMENT_ID = D2.DEPARTMENT_ID AND
		EI2.BRANCH_ID = B2.BRANCH_ID 
</cfif>
	ORDER BY
    D.DEPARTMENT_HEAD,
		 EMPLOYEE_NAME,
		 EMPLOYEE_SURNAME,
		 START_DATE DESC
</cfquery>		
<cfset employee_list = valuelist(get_Emp.employee_id)> 
<!---<cfif not get_Emp.recordcount>
	<script type="text/javascript">
		alert('Çalışan Bulunamadı!');
		history.back();
	</script>
	<cfabort>
</cfif>--->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_grid_list>
            <thead>
                <tr>
                      <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                      <th><cf_get_lang dictionary_id='57572.Departman'></th>
                      <th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th> 
                    <th><cf_get_lang dictionary_id='30368.Çalışan'></th>
                    <th><cf_get_lang dictionary_id='58714.SGK'></th>
                    <!---<th><cf_get_lang no="234.İlgili Şirket"></th> --->
                    <!--- <th><cf_get_lang_main no="41.Şube"></th> --->
                    <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                    <!---<th><cf_get_lang_main no="159.Ünvan"></th>  
                    <th><cf_get_lang_main no="1075.Çalışan No"></th> --->
                    <!--- <th><cf_get_lang no="548.Sigorta No"></th>--->
                    
                    <!---<th><cf_get_lang no="708.Gruba Giriş"></th> --->
                    <th><cf_get_lang dictionary_id='39070.İzin Baz Tarihi'></th>
                    <th><cf_get_lang dictionary_id='39279.Şirkete Giriş'></th>
                    <th><cf_get_lang dictionary_id='38907.Kıdem Baz'></th>
                    <th><cf_get_lang dictionary_id='56292.Kıdem Yıl'></th>
                    <!--- <th>Çıkış Tarihi</th> --->
                    <th><cf_get_lang dictionary_id='58727.Doğum Tarihi'></th>
                    <th><cf_get_lang dictionary_id='39316.Son İzin Hakediş Tarihi'></th>
                    <th><cf_get_lang dictionary_id='62814.En Son Hakedilen İzin'></th>
                    <th><cf_get_lang dictionary_id='39287.Toplam Hakedilen İzin Günü'></th>
                    <!---<th>Geçmiş Dönem Kullanılan İzin</th>--->
                    <th><cf_get_lang dictionary_id='39310.Toplam Kullanılan İzin'></th>
                    <th><cf_get_lang dictionary_id='39311.Toplam Kullanılmayan İzin'></th>
                    <!---<th>Tahmini İzin Yükü Brüt</th> --->
                   <!--- <th><cf_get_lang no="594.Tahmini İzin Yükü Net"></th> --->
                     <!---<th>İzin Kullanım Bitiş Tarihi</th>
                    <th>Son Dönem İzni Kullanılan</th>
                    <th>Son Dönem İzni Kalan</th>  --->
                   <!--- <th><cfoutput>#year(attributes.finish_date)-1#</cfoutput> 2. <cf_get_lang no="639.Dönem Mutabakat Tarihi"></th>
                    <th><cfoutput>#year(attributes.finish_date)-1#</cfoutput> 2. <cf_get_lang no="644.Dönem Mutabakat Günü"></th>
                    <th><cfoutput>#year(attributes.finish_date)#</cfoutput> 1. <cf_get_lang no="646.İzin Mutabakat Tarihi"></th>
                    <th><cfoutput>#year(attributes.finish_date)#</cfoutput> 1.<cf_get_lang no="648.İzin Mutabakat Günü"></th>
                    <th><cfoutput>#year(attributes.finish_date)#</cfoutput> 2.<cf_get_lang no="646.İzin Mutabakat Tarihi"></th>
                    <th><cfoutput>#year(attributes.finish_date)#</cfoutput> 2.<cf_get_lang no="648.İzin Mutabakat Günü"></th>
                        <th><cf_get_lang no="663.Ücret Maaş"></th>
                        <th><cf_get_lang no="664.Kıdeme Esas Maaş"></th>
                        <cfoutput>
                            <cfloop from="12" to="1" index="x_ay" step="-1">
                                <th>#month(dateadd("m",(-x_ay+1),puantaj_start_))#-#year(dateadd("m",(-x_ay+1),puantaj_start_))#</th>
                            </cfloop>
                        </cfoutput>
                    <th><cf_get_lang_main no="80.Toplam"> <cf_get_lang no="1265.Ek Ödenek"></th>
                    <th><cf_get_lang no="665.Toplam Geçen Gün"></th>
                    <th><cf_get_lang no="666.Boş Geçen Gün"></th>
                    <th><cf_get_lang no="667.Kıdem Günü"></th>
                    <th><cf_get_lang no="668.Kıdem Matrahı"></th>
                    <th><cf_get_lang no="681.Kıdem Tutarı"></th>
                    <th><cf_get_lang no="685.İhbar Günü"></th>
                    <th><cf_get_lang no="688.İhbar Tutarı"></th>
                    <th><cf_get_lang no="692.İhbar Tutarı Tahmini Net"></th>
                    <th><cf_get_lang no="694.Eski Çalışmalar"></th> --->
                </tr>
            </thead>
            <tbody>
                <cfif get_Emp.recordcount>
                    <cfquery name="get_contracts" datasource="#dsn#">
                        SELECT DISTINCT
                            EOC.OFFTIME_DATE_1,
                            EOC.EMPLOYEE_ID,
                            EOC.OFFTIME_PART_1,
                            EOC.OFFTIME_DATE_2,
                            EOC.OFFTIME_PART_2
                        FROM 
                            EMPLOYEES_OFFTIME_CONTRACT EOC,
                            EMPLOYEES_IN_OUT EI,
                            BRANCH B
                        WHERE 
                            ((EI.FINISH_DATE BETWEEN #puantaj_start_# AND #puantaj_finish_#) OR EI.FINISH_DATE IS NULL) AND
                            <cfif len(attributes.branch_id)>B.BRANCH_ID = #attributes.branch_id# AND</cfif>
                            <!---<cfif not session.ep.ehesap>B.BRANCH_ID IN (#emp_branch_list#) AND</cfif>--->
                            EI.BRANCH_ID = B.BRANCH_ID AND
                            EOC.EMPLOYEE_ID = EI.EMPLOYEE_ID AND 
                            EOC.SAL_YEAR = #year(attributes.finish_date)# 
                        ORDER BY 
                            EOC.EMPLOYEE_ID
                    </cfquery> 
                    <cfset con_employee_list = listsort(listdeleteduplicates(valuelist(get_contracts.EMPLOYEE_ID,',')),'numeric','ASC',',')>
                    <cfquery name="get_contracts_old" datasource="#dsn#">
                        SELECT DISTINCT
                            EOC.OFFTIME_DATE_1,
                            EOC.EMPLOYEE_ID,
                            EOC.OFFTIME_PART_1,
                            EOC.OFFTIME_DATE_2,
                            EOC.OFFTIME_PART_2
                        FROM 
                            EMPLOYEES_OFFTIME_CONTRACT EOC,
                            EMPLOYEES_IN_OUT EI,
                            BRANCH B
                        WHERE 
                            ((EI.FINISH_DATE BETWEEN #puantaj_start_# AND #puantaj_finish_#) OR EI.FINISH_DATE IS NULL) AND
                            <cfif len(attributes.branch_id)>B.BRANCH_ID = #attributes.branch_id# AND</cfif>
                            <!---<cfif not session.ep.ehesap>B.BRANCH_ID IN (#emp_branch_list#) AND</cfif>--->
                            EI.BRANCH_ID = B.BRANCH_ID AND
                            EOC.EMPLOYEE_ID = EI.EMPLOYEE_ID AND 
                            EOC.SAL_YEAR = #year(attributes.finish_date)-1# 
                        ORDER BY 
                            EOC.EMPLOYEE_ID
                    </cfquery>
                    <cfquery name="get_emp_yillik_izins" datasource="#dsn#">
                        SELECT
                            OFFTIME.EMPLOYEE_ID,
                            OFFTIME.STARTDATE,
                            OFFTIME.FINISHDATE
                        FROM
                            OFFTIME,
                            SETUP_OFFTIME
                        WHERE
                            OFFTIME.EMPLOYEE_ID IN (#employee_list#) AND
                            OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
                            OFFTIME.VALID = 1 AND
                            OFFTIME.IS_PUANTAJ_OFF = 0 AND
                            SETUP_OFFTIME.IS_YEARLY = 1
                    </cfquery>
                    <cfquery name="GET_SUM_LAST_12_MONTHS" datasource="#dsn#">
                        SELECT
                            EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID,
                            EMPLOYEES_PUANTAJ.SAL_YEAR,
                            EMPLOYEES_PUANTAJ.SAL_MON,
                            EMPLOYEES_PUANTAJ_ROWS.TOTAL_SALARY as a,
                            (EMPLOYEES_PUANTAJ_ROWS.TOTAL_SALARY - EMPLOYEES_PUANTAJ_ROWS.IHBAR_AMOUNT - EMPLOYEES_PUANTAJ_ROWS.KIDEM_AMOUNT - EMPLOYEES_PUANTAJ_ROWS.YILLIK_IZIN_AMOUNT-EMPLOYEES_PUANTAJ_ROWS.EXT_SALARY) AS TOTAL_SALARY
                        FROM
                            EMPLOYEES_PUANTAJ_ROWS,
                            EMPLOYEES_PUANTAJ
                        WHERE
                            EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID IN (#employee_list#) AND
                            EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
                            EMPLOYEES_PUANTAJ.SAL_YEAR = #year(attributes.finish_date)# 
                            AND EMPLOYEES_PUANTAJ.SAL_MON = #month(attributes.finish_date)#
                        ORDER BY EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID,EMPLOYEES_PUANTAJ.SAL_YEAR DESC,EMPLOYEES_PUANTAJ.SAL_MON DESC
                    </cfquery>
                    <cfquery name="get_old_odeneks" datasource="#dsn#">
                        SELECT 
                            SUM(ERPE.AMOUNT_2) AS TOTAL_AMOUNT,
                            EPR.EMPLOYEE_ID EMPLOYEE_ID,
                            EP.SAL_MON SAL_MON,
                            EP.SAL_YEAR SAL_YEAR
                        FROM
                            EMPLOYEES_PUANTAJ_ROWS_EXT ERPE,
                            EMPLOYEES_PUANTAJ EP,
                            EMPLOYEES_PUANTAJ_ROWS EPR
                        WHERE
                            EPR.EMPLOYEE_ID IN (#employee_list#) AND
                            EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
                            ERPE.IS_KIDEM = 1 AND 
                            EPR.EMPLOYEE_PUANTAJ_ID = ERPE.EMPLOYEE_PUANTAJ_ID AND
                            EP.PUANTAJ_ID = ERPE.PUANTAJ_ID AND 
                            ERPE.EXT_TYPE = 0 AND
                            EP.SAL_YEAR <= #year(attributes.finish_date)# AND
                            EP.SAL_YEAR >= #year(attributes.finish_date)-1#
                        GROUP BY EMPLOYEE_ID,SAL_YEAR,SAL_MON
                    </cfquery>
                    <cfquery name="get_old_calisma" datasource="#dsn#">
                        SELECT 
                            EP.EMPLOYEE_ID,
                            EP.RELATED_COMPANY,
                            EP.STARTDATE,
                            EP.FINISHDATE,
                            B.BRANCH_NAME,
                            O.NICK_NAME
                        FROM 
                            EMPLOYEE_PROGRESS_PAYMENT EP,
                            BRANCH B,
                            OUR_COMPANY O
                        WHERE
                            EP.EMPLOYEE_ID IN (#employee_list#) AND
                            EP.BRANCH_ID = B.BRANCH_ID AND
                            EP.COMP_ID = O.COMP_ID
                        ORDER BY EP.EMPLOYEE_ID DESC,STARTDATE DESC
                    </cfquery>
                    <cfquery name="get_progress_payment_out" datasource="#dsn#">
                        SELECT EMP_ID,START_DATE,FINISH_DATE,PROGRESS_TIME,IS_KIDEM,IS_YEARLY FROM EMPLOYEE_PROGRESS_PAYMENT_OUT WHERE IS_KIDEM = 1
                    </cfquery>
                    <cfoutput query="get_old_calisma">
                        <cfif get_old_calisma.currentrow neq 1 and get_old_calisma.employee_id[currentrow-1] eq get_old_calisma.employee_id>
                            <cfset 'old_calisma_#employee_id#' = evaluate("old_calisma_#employee_id#") & '<b>***</b>' & '#related_company# - #BRANCH_NAME#-#NICK_NAME#/#dateformat(startdate,"dd.mm.yyyy")#-#dateformat(finishdate,"dd.mm.yyyy")#'>
                        <cfelse>
                            <cfset 'old_calisma_#employee_id#' = '#related_company# - #BRANCH_NAME#-#NICK_NAME#/#dateformat(startdate,"dd.mm.yyyy")#-#dateformat(finishdate,"dd.mm.yyyy")#'>
                        </cfif>
                    </cfoutput>
                    <cfset old_con_employee_list = listsort(listdeleteduplicates(valuelist(get_contracts_old.EMPLOYEE_ID,',')),'numeric','ASC',',')>
                        <cfoutput query="get_emp">
                            <cfset employee_id_ = employee_id>
                            <cfset kisi_izin_toplam = 0>
                            <cfset kisi_izin_sayilmayan = 0>
                            
                            <cfset genel_izin_toplam = 0>
                            <cfset izin_sayilmayan = 0>
                            <cfset resmi_izin_sayilmayan = 0>
                            
                            <cfif len(izin_days)>
                                <cfset old_days = izin_days>
                            <cfelse>
                                <cfset old_days = 0>
                            </cfif>
                            <cfset attributes.sal_mon = MONTH(attributes.finish_date)>
                            <cfset attributes.sal_year = YEAR(attributes.finish_date)>
                            <cfset attributes.group_id = "">
                            <cfif len(get_emp.puantaj_group_ids)>
                                <cfset attributes.group_id = "#get_emp.PUANTAJ_GROUP_IDS#,">
                            </cfif>
                            <cfset attributes.branch_id = get_emp.branch_id>
                            <cfset not_kontrol_parameter = 1>
                            <cfinclude template="../../../../v16/hr/ehesap/query/get_program_parameter.cfm">
                            <cfif get_program_parameters.recordcount>
                                <cfset ihbar_1_s_ = get_program_parameters.DENUNCIATION_1_LOW>
                                <cfset ihbar_1_f_ = get_program_parameters.DENUNCIATION_1_HIGH>
                                <cfset ihbar_1_g_ = get_program_parameters.DENUNCIATION_1>
                                
                                <cfset ihbar_2_s_ = get_program_parameters.DENUNCIATION_2_LOW>
                                <cfset ihbar_2_f_ = get_program_parameters.DENUNCIATION_2_HIGH>
                                <cfset ihbar_2_g_ = get_program_parameters.DENUNCIATION_2>
                                
                                <cfset ihbar_3_s_ = get_program_parameters.DENUNCIATION_3_LOW>
                                <cfset ihbar_3_f_ = get_program_parameters.DENUNCIATION_3_HIGH>
                                <cfset ihbar_3_g_ = get_program_parameters.DENUNCIATION_3>
                                
                                <cfset ihbar_4_s_ = get_program_parameters.DENUNCIATION_4_LOW>
                                <cfset ihbar_4_f_ = get_program_parameters.DENUNCIATION_4_HIGH>
                                <cfset ihbar_4_g_ = get_program_parameters.DENUNCIATION_4>
                                
                                <cfset ihbar_5_s_ = get_program_parameters.DENUNCIATION_5_LOW>
                                <cfset ihbar_5_f_ = get_program_parameters.DENUNCIATION_5_HIGH>
                                <cfset ihbar_5_g_ = get_program_parameters.DENUNCIATION_5>
                            
                                <cfset ihbar_6_s_ = get_program_parameters.DENUNCIATION_6_LOW>
                                <cfset ihbar_6_f_ = get_program_parameters.DENUNCIATION_6_HIGH>
                                <cfset ihbar_6_g_ = get_program_parameters.DENUNCIATION_6>
                            <cfelse>
                                <cfset ihbar_1_s_ = 0>
                                <cfset ihbar_1_f_ = 0>
                                <cfset ihbar_1_g_ = 0>
                                
                                <cfset ihbar_2_s_ = 0>
                                <cfset ihbar_2_f_ = 0>
                                <cfset ihbar_2_g_ = 0>
                                
                                <cfset ihbar_3_s_ = 0>
                                <cfset ihbar_3_f_ = 0>
                                <cfset ihbar_3_g_ = 0>
                                
                                <cfset ihbar_4_s_ = 0>
                                <cfset ihbar_4_f_ = 0>
                                <cfset ihbar_4_g_ = 0>
                                
                                <cfset ihbar_5_s_ = 0>
                                <cfset ihbar_5_f_ = 0>
                                <cfset ihbar_5_g_ = 0>
                            
                                <cfset ihbar_6_s_ = 0>
                                <cfset ihbar_6_f_ = 0>
                                <cfset ihbar_6_g_ = 0>
                            </cfif>
                            <cfquery name="get_offtime" datasource="#dsn#">
                                SELECT 
                                    OFFTIME.EMPLOYEE_ID,
                                    OFFTIME.STARTDATE,
                                    OFFTIME.FINISHDATE,
                                    SETUP_OFFTIME.OFFTIMECAT_ID,
                                    SETUP_OFFTIME.OFFTIMECAT
                                FROM 
                                    OFFTIME,
                                    SETUP_OFFTIME
                                WHERE
                                    SETUP_OFFTIME.OFFTIMECAT_ID=OFFTIME.OFFTIMECAT_ID AND
                                    OFFTIME.IS_PUANTAJ_OFF = 0 AND
                                    OFFTIME.VALID = 1 AND
                                    SETUP_OFFTIME.IS_PAID = 1 AND
                                    SETUP_OFFTIME.IS_YEARLY = 1
                                    <cfif len(IZIN_DATE)>
                                        AND
                                        (
                                            OFFTIME.FINISHDATE <= #attributes.finish_date# OR
                                            OFFTIME.STARTDATE < #attributes.finish_date#
                                        )
                                        AND OFFTIME.STARTDATE > <cfqueryparam cfsqltype="cf_sql_date" value="#IZIN_DATE#">
                                    </cfif>
                                    AND EMPLOYEE_ID = #EMPLOYEE_ID#
                                ORDER BY
                                    STARTDATE DESC
                            </cfquery>
                            <cfif get_offtime.recordcount>
                                <cfloop query="get_offtime">
                                    <cfif len(get_emp.IZIN_DATE)>
                                        <cfset kidem=datediff('d',get_emp.IZIN_DATE,get_offtime.startdate)>
                                    <cfelse>
                                        <cfset kidem=0>
                                    </cfif>
                                    <cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
                                        SELECT SATURDAY_ON,DAY_CONTROL FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= '#get_offtime.startdate#'  AND FINISHDATE >= '#get_offtime.startdate#'
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
                                    <cfset kidem_yil=kidem/365>
                                    <cfscript>
                                        temporary_sunday_total = 0;
                                        temporary_resmi_total = 0;
                                        temporary_offday_total=0;
                                        temporary_halfday_total = 0;
                                        total_izin = datediff('d',get_offtime.startdate,get_offtime.finishdate)+1;
                                        izin_startdate = date_add("h", session.ep.time_zone, get_offtime.startdate); 
                                        izin_finishdate = date_add("h", session.ep.time_zone, get_offtime.finishdate);
                                        for (mck=0; mck lt total_izin; mck=mck+1)
                                            {
                                            temp_izin_gunu = date_add("d",mck,izin_startdate);
                                            daycode = '#dateformat(temp_izin_gunu,'dd/mm/yyyy')#';
                                            if (dayofweek(temp_izin_gunu) eq 1)
                                                temporary_sunday_total = temporary_sunday_total + 1;
                                            else if (dayofweek(temp_izin_gunu) eq 7 and saturday_on eq 0)
                                                temporary_sunday_total = temporary_sunday_total + 1;
                                            else if(listfindnocase(offday_list,'#daycode#'))
                                                temporary_resmi_total = temporary_resmi_total + 1;
                                            else if(daycode is '#dateformat(dateadd("h",session.ep.time_zone,get_offtime.finishdate),'dd/mm/yyyy')#' and day_control_ gt 0 and timeformat(dateadd("h",session.ep.time_zone,get_offtime.finishdate),'HH') lt day_control_)
                                                    temporary_halfday_total = temporary_halfday_total + 1;
                                            }
                                        genel_izin_toplam = genel_izin_toplam + total_izin - temporary_sunday_total - temporary_resmi_total  - (0.5 * temporary_halfday_total);
                                        kisi_izin_toplam = kisi_izin_toplam + genel_izin_toplam;
                                        kisi_izin_sayilmayan = kisi_izin_sayilmayan + temporary_sunday_total - temporary_resmi_total;
                                    </cfscript>
                                </cfloop>
                            </cfif>
                            <cfif len(get_emp.IZIN_DATE) and isdate(get_emp.IZIN_DATE)>
                                <cfscript>
                                    tck = 0;
                                    toplam_hakedilen_izin = 0;
                                            my_giris_date = get_emp.IZIN_DATE;
                                            flag = true;
                                            baslangic_tarih_ = my_giris_date;
                                            while(flag)
                                            {
                                            bitis_tarihi_ = createodbcdatetime(date_add("yyyy",1,baslangic_tarih_));
                                            baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
                                            get_bos_zaman_ = cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT * FROM get_progress_payment_outs WHERE EMP_ID = #employee_id_# AND ((START_DATE <= #baslangic_tarih_# AND FINISH_DATE >= #baslangic_tarih_#) OR (START_DATE >= #baslangic_tarih_# AND FINISH_DATE <= #bitis_tarihi_#) OR ((START_DATE BETWEEN #baslangic_tarih_# AND #bitis_tarihi_#) AND FINISH_DATE >= #bitis_tarihi_#))");	
                                            if(get_bos_zaman_.recordcount eq 0)
                                                {
                                                tck = tck + 1; 
                                                kontrol_date = bitis_tarihi_;
                                                get_offtime_limit=cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT * FROM get_offtime_limits WHERE STARTDATE <= #baslangic_tarih_# AND FINISHDATE >= #baslangic_tarih_#");	
                                                    if(get_offtime_limit.recordcount)
                                                        {
                                                        if(tck lte get_offtime_limit.limit_1)
                                                            eklenecek = get_offtime_limit.LIMIT_1_DAYS;
                                                        else if(tck gt get_offtime_limit.limit_1 and tck lte get_offtime_limit.limit_2)
                                                            eklenecek = get_offtime_limit.LIMIT_2_DAYS;
                                                        else if(tck gt get_offtime_limit.limit_2 and tck lte get_offtime_limit.limit_3)
                                                            eklenecek = get_offtime_limit.LIMIT_3_DAYS;
                                                        else 
                                                            eklenecek = get_offtime_limit.LIMIT_4_DAYS;
                                                            
                                                        if(len(get_emp.BIRTH_DATE) and eklenecek lt get_offtime_limit.MIN_MAX_DAYS and (datediff("yyyy",get_emp.BIRTH_DATE,kontrol_date) lt get_offtime_limit.MIN_YEARS or datediff("yyyy",get_emp.BIRTH_DATE,kontrol_date) gt get_offtime_limit.MAX_YEARS) )
                                                            eklenecek = get_offtime_limit.MIN_MAX_DAYS;
                                                        if(tck neq 1 and eklenecek neq 0) 
                                                            {
                                                            toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
                                                            son_baslangic_ = baslangic_tarih_;
                                                            son_bitis_ = bitis_tarihi_;
                                                            }
                                                        }
                                                }
                                            else
                                                {
                                                    eklenecek_gun = 0;
                                                    for(izd = 1; izd lte get_bos_zaman_.recordcount; izd=izd+1)
                                                        {
                                                        if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) gt 0 and len(get_bos_zaman_.finish_date[izd]))
                                                            {
                                                            fark_ = datediff("d",baslangic_tarih_,get_bos_zaman_.finish_date[izd]);
                                                            }
                                                        else if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) lte 0 and len(get_bos_zaman_.PROGRESS_TIME[izd]))
                                                            {
                                                            fark_ = get_bos_zaman_.PROGRESS_TIME[izd];
                                                            }
                                                        else if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) lte 0 and len(get_bos_zaman_.finish_date[izd]))
                                                            {
                                                            fark_ = datediff("d",get_bos_zaman_.start_date[izd],get_bos_zaman_.finish_date[izd]);
                                                            }
                                                        else
                                                            {
                                                            fark_ = 0;
                                                            }
                                                        eklenecek_gun = eklenecek_gun + fark_;
                                                        }
                                                    bitis_tarihi_ = date_add("d",eklenecek_gun,bitis_tarihi_);
                                                        
                                                        tck = tck + 1; 
                                                        kontrol_date = bitis_tarihi_;
                                                        get_offtime_limit=cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT * FROM get_offtime_limits WHERE STARTDATE <= #baslangic_tarih_# AND FINISHDATE >= #baslangic_tarih_#");	
                                                            if(get_offtime_limit.recordcount)
                                                                {
                                                                if(tck lte get_offtime_limit.limit_1)
                                                                    eklenecek = get_offtime_limit.LIMIT_1_DAYS;
                                                                else if(tck gt get_offtime_limit.limit_1 and tck lte get_offtime_limit.limit_2)
                                                                    eklenecek = get_offtime_limit.LIMIT_2_DAYS;
                                                                else if(tck gt get_offtime_limit.limit_2 and tck lte get_offtime_limit.limit_3)
                                                                    eklenecek = get_offtime_limit.LIMIT_3_DAYS;
                                                                else 
                                                                    eklenecek = get_offtime_limit.LIMIT_4_DAYS;
                                                                    
                                                                if(len(get_emp.BIRTH_DATE) and eklenecek lt get_offtime_limit.MIN_MAX_DAYS and (datediff("yyyy",get_emp.BIRTH_DATE,kontrol_date) lt get_offtime_limit.MIN_YEARS or datediff("yyyy",get_emp.BIRTH_DATE,kontrol_date) gt get_offtime_limit.MAX_YEARS) )
                                                                    eklenecek = get_offtime_limit.MIN_MAX_DAYS;
                                                                if(tck neq 1 and eklenecek neq 0) 
                                                                    {
                                                                    toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
                                                                    son_baslangic_ = baslangic_tarih_;
                                                                    son_bitis_ = bitis_tarihi_;
                                                                    }
                                                                }
                                                }	
                                            baslangic_tarih_ = bitis_tarihi_;
                                            bitis_tarihi_ = date_add("yyyy",1,bitis_tarihi_);
                                            if(datediff("yyyy",bitis_tarihi_,my_baz_date) lt 0)				
                                                {
                                                flag = false;
                                                }
                                            }
                                </cfscript>
                            <cfelse>
                                <cfscript>
                                    tck = 0;
                                    toplam_hakedilen_izin = 0;
                                    eklenecek_gun = 0;
                                </cfscript>
                            </cfif>
                            <cfif currentrow eq 1 or (currentrow neq 1 and employee_id neq get_Emp.employee_id[currentrow-1])>
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#department_head#</td>
                                    <td>#TC_IDENTY_NO#</td>
                                    <td><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=hr.list_offtime&employee_id=#employee_id#','list');" class="tableyazi">#employee_name# #employee_surname#</a></td>
                                    <td><cfif USE_SSK eq 1>Var<cfelse>Yok</cfif></td>
                                <!--- <td>#RELATED_COMPANY#</td>
                                    <td>#BRANCH_NAME#</td> --->
                                    <td>#POSITION_CAT#</td>
                                    <!---<td>#title#</td>
                                    <td>#EMPLOYEE_NO#</td>--->
                                <!--- <td>#SOCIALSECURITY_NO#</td>--->
                                    <!--- <td><cfif len(GROUP_STARTDATE)>#dateformat(GROUP_STARTDATE,'dd/mm/yyyy')#<cfelse>-</cfif></td>--->
                                    <td><cfif len(izin_date)>#dateformat(izin_date,'dd/mm/yyyy')#<cfelse>-</cfif></td>
                                    <td>#dateformat(START_DATE,'dd/mm/yyyy')#</td>
                                    <td><cfif len(KIDEM_DATE)>#dateformat(KIDEM_DATE,'dd/mm/yyyy')#<cfelse>-</cfif></td>
                                    <td><cfif len(KIDEM_DATE)>#datediff('yyyy',kidem_date,now())#<cfelse>0</cfif></td>
                                    <!---<td><cfif len(FINISH_DATE)>#dateformat(FINISH_DATE,'dd/mm/yyyy')#<cfelse>-</cfif></td>--->
                                    <td><cfif len(BIRTH_DATE)>#dateformat(BIRTH_DATE,'dd/mm/yyyy')#<cfelse>-</cfif></td>
                                    <td><cfif toplam_hakedilen_izin gt 0>#dateformat(son_baslangic_,'dd/mm/yyyy')#<cfelse>&nbsp;</cfif></td>
                                    <td><cfset bu_yil_isleniyor = 0>
                                        <cfif toplam_hakedilen_izin eq 0>
                                            <cfset bu_yil_ = 0>
                                        <cfelseif len(izin_date) and len(birth_date)>
                                            <cfscript>
                                            my_tck = datediff("yyyy",my_giris_date,my_baz_date) + 1;
                                            get_offtime_limit=cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT * FROM get_offtime_limits WHERE STARTDATE <= #my_baz_date# AND FINISHDATE >= #my_baz_date#");
                                            
                                            if(my_tck lte get_offtime_limit.limit_1)
                                                bu_yil = get_offtime_limit.LIMIT_1_DAYS;
                                            else if(my_tck gt get_offtime_limit.limit_1 and my_tck lte get_offtime_limit.limit_2)
                                                bu_yil = get_offtime_limit.LIMIT_2_DAYS;
                                            else if(my_tck gt get_offtime_limit.limit_2 and my_tck lte get_offtime_limit.limit_3)
                                                bu_yil = get_offtime_limit.LIMIT_3_DAYS;
                                            else 
                                                bu_yil = get_offtime_limit.LIMIT_4_DAYS;
                                                
                                            if(len(get_emp.BIRTH_DATE) and bu_yil lt get_offtime_limit.MIN_MAX_DAYS and (datediff("yyyy",get_emp.BIRTH_DATE,my_baz_date) lt get_offtime_limit.MIN_YEARS or datediff("yyyy",get_emp.BIRTH_DATE,my_baz_date) gt get_offtime_limit.MAX_YEARS) )
                                                bu_yil = get_offtime_limit.MIN_MAX_DAYS;
                                            </cfscript>
                                            <cfset bu_yil_ = bu_yil>
                                            <cfset bu_yil_isleniyor = 1>
                                        <cfelse>
                                            <cfset bu_yil_ = 0>
                                        </cfif>
                                        #bu_yil_#
                                    </td>
                                    <td style="mso-number-format:'0\.00'">#toplam_hakedilen_izin#</td>
                                <!--- <td style="mso-number-format:'0\.00';">#old_days#</td>--->
                                    <td style="mso-number-format:'0\.00';">#genel_izin_toplam + old_days#</td>
                                    <td style="mso-number-format:'0\.00';">#toplam_hakedilen_izin-genel_izin_toplam-old_days#</td>
                                        <cfquery name="get_salary" datasource="#dsn#" maxrows="1">
                                            SELECT 
                                                EPR.SALARY,
                                                EPR.SALARY_TYPE,
                                                EP.SAL_YEAR,
                                                EP.SAL_MON
                                            FROM 
                                                EMPLOYEES_PUANTAJ EP,
                                                EMPLOYEES_PUANTAJ_ROWS EPR
                                            WHERE
                                                EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
                                                EPR.EMPLOYEE_ID = #EMPLOYEE_ID# AND
                                                EP.SAL_YEAR = #year(attributes.finish_date)# AND
                                                EP.SAL_MON = #month(attributes.finish_date)#
                                            ORDER BY
                                                EP.SAL_YEAR DESC,
                                                EP.SAL_MON DESC
                                        </cfquery>
                                        <cfif get_salary.recordcount>
                                            <cfif get_salary.SALARY_TYPE eq 0>
                                                <cfset tahmini_izin_yuku = get_salary.SALARY * 225 / 30 * (toplam_hakedilen_izin - genel_izin_toplam-old_days)>
                                            <cfelseif get_salary.SALARY_TYPE eq 1>
                                                <cfset tahmini_izin_yuku = get_salary.SALARY * (toplam_hakedilen_izin - genel_izin_toplam-old_days)>
                                            <cfelse>
                                                <cfset tahmini_izin_yuku = get_salary.SALARY / 30 * (toplam_hakedilen_izin - genel_izin_toplam-old_days)>
                                            </cfif>
                                        <cfelse>
                                            <cfset tahmini_izin_yuku = 0>
                                        </cfif>
                                        <cfif tahmini_izin_yuku gt 0>
                                            <cfset ssk_payi_ = tahmini_izin_yuku * 15 / 100>
                                            <cfif gross_net eq 0>
                                                <cfset vergi_payi_ = (tahmini_izin_yuku - ssk_payi_) * 15 / 100>
                                            <cfelse>
                                                <cfset vergi_payi_ = (tahmini_izin_yuku) * 15 / 100>
                                            </cfif>
                                            <cfset d_payi_ = tahmini_izin_yuku * 6.6 / 1000>
                                        <cfelse>
                                            <cfset ssk_payi_ = 0>
                                            <cfset vergi_payi_ = 0>
                                            <cfset d_payi_ = 0>
                                        </cfif>
                                        <cfif gross_net eq 0>
                                            <!---<td style="mso-number-format:'0\.00'">#tlformat(tahmini_izin_yuku)#</td>--->
                                            <!--- <td style="mso-number-format:'0\.00'">#tlformat(tahmini_izin_yuku - ssk_payi_ - vergi_payi_ - d_payi_)#</td> --->
                                        <cfelse>
                                            <!---<td style="mso-number-format:'0\.00'">#tlformat(tahmini_izin_yuku + ssk_payi_ + vergi_payi_ + d_payi_)#</td> --->
                                            <!--- <td style="mso-number-format:'0\.00'">#tlformat(tahmini_izin_yuku)#</td> --->
                                        </cfif>
                                        
                                        <!--- <td><cfif toplam_hakedilen_izin gt 0>#dateformat(son_bitis_,'dd/mm/yyyy')#<cfelse>&nbsp;</cfif></td>
                                            <cfif bu_yil_isleniyor eq 1 and get_offtime.recordcount and toplam_hakedilen_izin gt 0>
                                            <cfset son_izin_toplam = 0>
                                                <cfquery name="get_ic" dbtype="query">
                                                    SELECT * FROM get_offtime WHERE EMPLOYEE_ID = #get_emp.EMPLOYEE_ID# AND STARTDATE >= #son_baslangic_# AND FINISHDATE <= #son_bitis_#
                                                </cfquery>
                                                <cfloop query="get_ic">
                                                    <cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
                                                        SELECT SATURDAY_ON,DAY_CONTROL FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= '#get_ic.startdate#'  AND FINISHDATE >= '#get_ic.startdate#'
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
                                                        temporary_sunday_total = 0;
                                                        temporary_resmi_total = 0;
                                                        total_izin = datediff('d',get_ic.startdate,get_ic.finishdate)+1;
                                                        izin_startdate = date_add("h", session.ep.time_zone, get_ic.startdate); 
                                                        izin_finishdate = date_add("h", session.ep.time_zone, get_ic.finishdate);
                                                        for (mck=0; mck lt total_izin; mck=mck+1)
                                                            {
                                                            temp_izin_gunu = date_add("d",mck,izin_startdate);
                                                            daycode = '#dateformat(temp_izin_gunu,'dd/mm/yyyy')#';
                                                            if (dayofweek(temp_izin_gunu) eq 1)
                                                                temporary_sunday_total = temporary_sunday_total + 1;
                                                            else if (dayofweek(temp_izin_gunu) eq 7 and saturday_on eq 0)
                                                                temporary_sunday_total = temporary_sunday_total + 1;
                                                            else if(listfindnocase(offday_list,'#daycode#'))
                                                                temporary_resmi_total = temporary_resmi_total + 1;
                                                            }
                                                        son_izin_toplam = son_izin_toplam + total_izin - temporary_sunday_total - temporary_resmi_total;
                                                    </cfscript>
                                                </cfloop>
                                                <cfset son_donem_kullanilan = son_izin_toplam>
                                            <cfelse>
                                                <cfset son_donem_kullanilan = 0>
                                            </cfif>
                                        <td>#son_donem_kullanilan#</td>
                                        <td>#bu_yil_ - son_donem_kullanilan#</td>--->
                                        <!---<td><cfif listfindnocase(old_con_employee_list,employee_id)>#dateformat(get_contracts_old.OFFTIME_DATE_2[listfind(old_con_employee_list,employee_id,',')],'dd/mm/yyyy')#<cfelse>-</cfif></td>
                                        <td style="mso-number-format:'0\.00'"><cfif listfindnocase(old_con_employee_list,employee_id)>
                                                <cfif get_contracts_old.OFFTIME_PART_2[listfind(old_con_employee_list,employee_id,',')] contains '.'>
                                                #tlformat(get_contracts_old.OFFTIME_PART_2[listfind(old_con_employee_list,employee_id,',')],1)#
                                                <cfelse>
                                                #get_contracts_old.OFFTIME_PART_2[listfind(old_con_employee_list,employee_id,',')]#
                                                </cfif>
                                            <cfelse>
                                            -
                                            </cfif>
                                        </td>
                                        <td><cfif listfindnocase(con_employee_list,employee_id)>#dateformat(get_contracts.OFFTIME_DATE_1[listfind(con_employee_list,employee_id,',')],'dd/mm/yyyy')#<cfelse>-</cfif></td>
                                        <td style="mso-number-format:'0\.00'"><cfif listfindnocase(con_employee_list,employee_id)>
                                                <cfif get_contracts.OFFTIME_PART_1[listfind(con_employee_list,employee_id,',')] contains '.'>
                                                    #tlformat(get_contracts.OFFTIME_PART_1[listfind(con_employee_list,employee_id,',')],1)#
                                                <cfelse>
                                                    #get_contracts.OFFTIME_PART_1[listfind(con_employee_list,employee_id,',')]#
                                                </cfif>
                                            <cfelse>-</cfif>
                                        </td>
                                        <td><cfif listfindnocase(con_employee_list,employee_id)>#dateformat(get_contracts.OFFTIME_DATE_2[listfind(con_employee_list,employee_id,',')],'dd/mm/yyyy')#<cfelse>-</cfif></td>
                                    <td style="mso-number-format:'0\.00'"><cfif listfindnocase(con_employee_list,employee_id)>
                                        <cfif get_contracts.OFFTIME_PART_2[listfind(con_employee_list,employee_id,',')] contains '.'>
                                                #tlformat(get_contracts.OFFTIME_PART_2[listfind(con_employee_list,employee_id,',')],1)#
                                            <cfelse>
                                                #get_contracts.OFFTIME_PART_2[listfind(con_employee_list,employee_id,',')]#
                                            </cfif>
                                        <cfelse>
                                            -
                                        </cfif>
                                    </td>  <cfif len(KIDEM_DATE)>
                                            <cfquery name="get_" dbtype="query" maxrows="1">
                                                SELECT 
                                                    TOTAL_SALARY AS TOPLAM_KAZANC
                                                FROM 
                                                    GET_SUM_LAST_12_MONTHS 
                                                WHERE 
                                                    EMPLOYEE_ID = #employee_id# AND
                                                    (
                                                        (
                                                        SAL_YEAR = #YEAR(puantaj_start_)#
                                                        AND
                                                        SAL_MON = #MONTH(puantaj_start_)#
                                                        )
                                                    OR
                                                        (
                                                        SAL_YEAR = #YEAR(KIDEM_DATE)#
                                                        AND
                                                        SAL_MON >= #MONTH(KIDEM_DATE)#
                                                        )
                                                    )
                                                ORDER BY SAL_YEAR DESC,SAL_MON DESC
                                            </cfquery>
                                            <cfif get_.recordcount and len(get_.TOPLAM_KAZANC)>
                                                <cfset ilk_ucret_ = get_.TOPLAM_KAZANC>
                                            <cfelse>
                                                <cfset ilk_ucret_ = 0>
                                            </cfif>
                                            <td align="right" style="text-align:right;">#TLFormat(evaluate("M#attributes.months#"))#</td>
                                            <td align="right" style="text-align:right;">#TLFormat(ilk_ucret_)#</td>
                                            <cfset total_kidem = 0>
                                            <cfloop from="12" to="1" index="x_ay" step="-1">
                                                <cfquery name="get_this_odenek" dbtype="query">
                                                    SELECT TOTAL_AMOUNT FROM get_old_odeneks WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SAL_MON = #month(dateadd("m",(-x_ay+1),puantaj_start_))# AND SAL_YEAR = #year(dateadd("m",(-x_ay+1),puantaj_start_))#
                                                </cfquery>
                                                <td align="right" style="mso-number-format:'0\.00'; text-align:rigtht;"><cfif get_this_odenek.recordcount>#TLFormat(get_this_odenek.TOTAL_AMOUNT)#<cfelse>#TLFormat(0)#</cfif></td>
                                                <cfif get_this_odenek.recordcount><cfset total_kidem = get_this_odenek.TOTAL_AMOUNT + total_kidem></cfif>
                                            </cfloop>
                                            <td align="right" style="text-align:right;mso-number-format:'0\.00'; ">#TLFormat(total_kidem)#</td>
                                            <td>
                                            <cfscript>
                                                    yillar = ceiling(datediff('yyyy',KIDEM_DATE,puantaj_finish_));
                                                    gun_sayisi = (yillar * attributes.gun_say) + 1;
                                                    if(day(puantaj_finish_) neq day(KIDEM_DATE) or month(puantaj_finish_) neq month(KIDEM_DATE))
                                                        {
                                                        new_year = dateadd("yyyy",yillar,KIDEM_DATE);
                                                        fark = datediff('d',new_year,puantaj_finish_);
                                                        gun_sayisi = gun_sayisi + fark;						
                                                        }
                                                </cfscript>
                                            #gun_sayisi+1#
                                            </td>
                                            <td>
                                                <cfset bos_gecen = 0>
                                                <cfquery name="get_this_" dbtype="query">
                                                    SELECT 
                                                        * 
                                                    FROM 
                                                        get_progress_payment_out 
                                                    WHERE
                                                        EMP_ID = #employee_id#
                                                </cfquery>
                                                <cfif get_this_.recordcount>
                                                    <cfloop query="get_this_">
                                                        <cfif len(get_this_.finish_date)>
                                                            <cfset bos_gecen = bos_gecen + datediff("d",get_this_.start_date,get_this_.finish_date)+1>
                                                        <cfelse>
                                                            <cfset bos_gecen = bos_gecen + datediff("d",get_this_.start_date,puantaj_start_)+1>
                                                        </cfif>
                                                    </cfloop>
                                                </cfif>
                                                #bos_gecen#
                                            </td>
                                            <td>#(gun_sayisi+1)-bos_gecen#</td>
                                            <cfquery name="get_yillik_izin_" dbtype="query">
                                                SELECT 
                                                    *
                                                FROM 
                                                    get_emp_yillik_izins 
                                                WHERE 
                                                    EMPLOYEE_ID = #EMPLOYEE_ID# AND 
                                                    STARTDATE <= #puantaj_start_# AND 
                                                    FINISHDATE >= #createodbcdatetime(KIDEM_DATE)#
                                            </cfquery>
                                            <cfset kideme_dahil_hesap_tutari = ilk_ucret_ + (total_kidem/12)>
                                            <cfset kidem_ihbar_gunu_ = (gun_sayisi-bos_gecen+1)>
                                            <cfscript>
                                            if (kidem_max lte kideme_dahil_hesap_tutari)
                                                kidem_amount_ = (kidem_max * kidem_ihbar_gunu_) / attributes.gun_say;
                                            else
                                                kidem_amount_ = (kideme_dahil_hesap_tutari * kidem_ihbar_gunu_) / attributes.gun_say;
                                            </cfscript>
                                            <td style="mso-number-format:'0\.00';">
                                                <cfif kidem_max lte kideme_dahil_hesap_tutari>
                                                    #tlformat(kidem_max)#
                                                <cfelse>
                                                    #tlformat(kideme_dahil_hesap_tutari)#
                                                </cfif>					
                                            </td>
                                            <td align="right" style="text-align:right;mso-number-format:'0\.00';">
                                            <cfif (gun_say eq 365 and Kıdem_gun gte 365) or (gun_say eq 360 and Kıdem_gun gte 360)>
                                            #tlformat(kidem_amount_)#
                                            <cfelse>
                                            0
                                            </cfif>
                                            </td>
                                            <td><cfif kidem_ihbar_gunu_ gte ihbar_1_s_ and kidem_ihbar_gunu_ lte ihbar_1_f_>
                                                    <cfset ihbar_gunu_ = ihbar_1_g_>
                                                <cfelseif kidem_ihbar_gunu_ gte ihbar_2_s_ and kidem_ihbar_gunu_ lte ihbar_2_f_>
                                                    <cfset ihbar_gunu_ = ihbar_2_g_>
                                                <cfelseif kidem_ihbar_gunu_ gte ihbar_3_s_ and kidem_ihbar_gunu_ lte ihbar_3_f_>
                                                    <cfset ihbar_gunu_ = ihbar_3_g_>
                                                <cfelseif kidem_ihbar_gunu_ gte ihbar_4_s_ and kidem_ihbar_gunu_ lte ihbar_4_f_>
                                                    <cfset ihbar_gunu_ = ihbar_4_g_>
                                                <cfelseif len(ihbar_5_s_) and len(ihbar_5_f_) and (kidem_ihbar_gunu_ gte ihbar_5_s_ and kidem_ihbar_gunu_ lte ihbar_5_f_)>
                                                    <cfset ihbar_gunu_ = ihbar_5_g_>
                                                <cfelseif len(ihbar_6_s_) and len(ihbar_6_f_) and (kidem_ihbar_gunu_ gte ihbar_6_s_ and kidem_ihbar_gunu_ lte ihbar_6_f_)>
                                                    <cfset ihbar_gunu_ = ihbar_6_g_>
                                                <cfelse>
                                                    <cfset ihbar_gunu_ = 0>
                                                </cfif>
                                                #ihbar_gunu_#
                                            </td>
                                            <td style="mso-number-format:'0\.00';"><cfif ihbar_gunu_ gt 0>#tlformat(kideme_dahil_hesap_tutari / 30 * ihbar_gunu_)#</cfif></td>
                                                <td>
                                                    <cfif ihbar_gunu_ gt 0>
                                                        <cfset kes1_ = kideme_dahil_hesap_tutari / 30 * ihbar_gunu_ * 6.6 / 1000>
                                                        <cfset kes2_ = kideme_dahil_hesap_tutari / 30 * ihbar_gunu_ * 15 / 100>
                                                        <cfset ihbar_net_ = (kideme_dahil_hesap_tutari / 30 * ihbar_gunu_) - kes1_ - kes2_>
                                                        #tlformat(ihbar_net_)#
                                                    </cfif>
                                                </td>
                                                <td><cfif isdefined("old_calisma_#employee_id#")>#evaluate("old_calisma_#employee_id#")#</cfif></td>
                                    <cfelse>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <cfloop from="12" to="1" index="x_ay" step="-1">
                                            <td>&nbsp;</td>
                                        </cfloop>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </cfif> --->
                                </tr>	
                            </cfif>
                        </cfoutput>
                <cfelse>
                    <tr>
                        <td  colspan="16"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
                    </tr>        
                </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>
</cfif>
<script type="text/javascript">
	function select_branch(my_comp)
	{
		if(my_comp!='')
		{
			result = wrk_safe_query('rpr_get_branch','dsn',0,my_comp);
			var option_count = document.getElementById('branch_id').options.length; 
			for(x=option_count;x>=0;x--)
				document.getElementById('branch_id').options[x] = null;
			document.getElementById('branch_id').options[0]=new Option("Şube Seçiniz",'');
			for(var i=0;i<result.recordcount;i++)
				document.getElementById('branch_id').options[i+1]=new Option(result.BRANCH_NAME[i],result.BRANCH_ID[i]);
		}
	}	
</script>