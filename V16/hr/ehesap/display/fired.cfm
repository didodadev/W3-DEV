<cfif not session.ep.ehesap>
	<cfinclude template="../query/get_emp_branches.cfm">
</cfif>
<cfinclude template="../query/get_ssk_offices.cfm">

<cfquery name="get_fire_detail" datasource="#dsn#">
	SELECT 
    	EIO.EMPLOYEE_ID,
        EIO.FINISH_DATE,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME,
        E.KIDEM_DATE,
        EIO.DETAIL,
        EIO.IS_KIDEM_BAZ ,
        EIO.START_DATE,
        EIO.IN_OUT_ID,
        EIO.EXPLANATION_ID,
        EIO.BRANCH_ID,
        EIO.DEPARTMENT_ID,
        EIO.SALARY,
        EIO.IHBAR_DATE,
        EIO.KIDEM_YEARS,
        EIO.TOTAL_DENEME_DAYS,
        EIO.TOTAL_SSK_MONTHS,
        EIO.IHBAR_DAYS,
        EIO.TOTAL_SSK_DAYS,
        EIO.KULLANILMAYAN_IZIN_COUNT,
        EIO.KIDEM_AMOUNT,
        EIO.HAKEDILEN_YILLIK_IZIN,
        EIO.IHBAR_AMOUNT,
        EIO.GROSS_COUNT_TYPE,
        EIO.KULLANILMAYAN_IZIN_AMOUNT,
        EIO.IN_COMPANY_REASON_ID,
       	EIO.VALIDATOR_POSITION_CODE,
        EIO.IS_EMPTY_POSITION,
        EIO.IS_STATUS_EMPLOYEE,
        EIO.VALID,
        EIO.VALID_EMP,
        EIO.VALID_DATE,
        EIO.ENTRY_DATE,
        EIO.ENTRY_BRANCH_ID,
        EIO.ENTRY_DEPARTMENT_ID,
        EIO.IS_SALARY_TRANSFER,
        EIO.IS_SALARY_DETAIL_TRANSFER,
        EIO.IS_ACCOUNTING_TRANSFER,
        EIO.IS_UPDATE_POSITION,
        EIO.IN_OUT_STAGE,
        EIO.NEW_CARD_ACCOUNT_BILL_TYPE,
        (SELECT TOP 1 SD.DEFINITION FROM EMPLOYEES_IN_OUT_PERIOD EIOP INNER JOIN SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF SD ON EIOP.ACCOUNT_BILL_TYPE=SD.PAYROLL_ID WHERE IN_OUT_ID = EIO.IN_OUT_ID ORDER BY PERIOD_YEAR DESC) AS DEFINITION
    FROM 
    	EMPLOYEES_IN_OUT EIO
        INNER JOIN EMPLOYEES E ON EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
    WHERE 
        EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
</cfquery>
<cfif not get_fire_detail.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='54631.Böyle bir kayıt yok'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_fire_count" datasource="#dsn#" maxrows="2">
	SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.employee_id#">
</cfquery>
<cfquery name="get_assetps" datasource="#dsn#">
	SELECT
		ASSET_P.ASSETP_ID,
		ASSET_P.ASSETP,
		ASSET_P_CAT.ASSETP_CAT
	FROM
		ASSET_P
		LEFT JOIN ASSET_P_CAT ON ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
	WHERE
		ASSET_P.STATUS = 1 AND
		ASSET_P.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.employee_id#">
	ORDER BY
		ASSET_P.ASSETP
</cfquery>
<cfquery name="get_zimmets" datasource="#dsn#">
	SELECT 
		ERZR.* 
	FROM 
		EMPLOYEES_INVENT_ZIMMET_ROWS ERZR
		INNER JOIN EMPLOYEES_INVENT_ZIMMET EIZ ON ERZR.ZIMMET_ID = EIZ.ZIMMET_ID
	WHERE 
		EIZ.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.employee_id#">
</cfquery>
<cfquery name="get_note" datasource="#dsn#">
	SELECT NOTE_HEAD,NOTE_BODY FROM NOTES WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.employee_id#">
</cfquery>
<cfquery name="get_all_emps" datasource="#dsn#">
	SELECT 
		EMPLOYEES.EMPLOYEE_ID MEMBER_ID,
		EMPLOYEES.EMPLOYEE_NAME MEMBER_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME MEMBER_SURNAME,
		WORKGROUP_EMP_PAR.ROLE_ID ROLE,
		SPR.PROJECT_ROLES
	FROM 
		EMPLOYEES
		INNER JOIN WORKGROUP_EMP_PAR ON EMPLOYEES.EMPLOYEE_ID = WORKGROUP_EMP_PAR.EMPLOYEE_ID
		LEFT JOIN SETUP_PROJECT_ROLES SPR ON WORKGROUP_EMP_PAR.ROLE_ID = PROJECT_ROLES_ID
	WHERE 
		WORKGROUP_EMP_PAR.MAIN_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.employee_id#">
	 ORDER BY
		MEMBER_ID		
</cfquery>
<cfquery name="get_all_emps_related" datasource="#dsn#">
	SELECT 
		EMPLOYEES.EMPLOYEE_ID MEMBER_ID,
		EMPLOYEES.EMPLOYEE_NAME MEMBER_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME MEMBER_SURNAME,
		WORKGROUP_EMP_PAR.ROLE_ID ROLE,
		SPR.PROJECT_ROLES
	FROM
		EMPLOYEES
		INNER JOIN WORKGROUP_EMP_PAR ON EMPLOYEES.EMPLOYEE_ID = WORKGROUP_EMP_PAR.MAIN_EMPLOYEE_ID
		LEFT JOIN SETUP_PROJECT_ROLES SPR ON WORKGROUP_EMP_PAR.ROLE_ID = PROJECT_ROLES_ID
	WHERE 
		WORKGROUP_EMP_PAR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.employee_id#"> AND
		WORKGROUP_EMP_PAR.MAIN_EMPLOYEE_ID IS NOT NULL
	 ORDER BY
		MEMBER_ID
</cfquery>
<cfset updateable = session.ep.ehesap or ListFindNoCase(emp_branch_list,get_fire_detail.branch_id, ',')>
<cfif len(get_fire_detail.FINISH_DATE)>
	<cfquery name="get_puantaj_id" datasource="#dsn#">
		SELECT
			*
		FROM
			EMPLOYEES_PUANTAJ
			INNER JOIN EMPLOYEES_PUANTAJ_ROWS ON EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
		WHERE
			EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.employee_id#">
			AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(get_fire_detail.finish_date)#">
			AND EMPLOYEES_PUANTAJ.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#month(get_fire_detail.finish_date)#">
	</cfquery>
</cfif>
<cfset attributes.sal_mon = month(get_fire_detail.FINISH_DATE)>
<cfset attributes.sal_year = year(get_fire_detail.FINISH_DATE)>
<cfset attributes.employee_id = get_fire_detail.employee_id>
<cfquery name="get_emp_kidem_dahil_odeneks" datasource="#dsn#">
	SELECT
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID,
		EMPLOYEES_PUANTAJ_ROWS.SALARY,
		EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY,
		EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT,
		EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT_2,
		EMPLOYEES_PUANTAJ.SAL_MON,
		EMPLOYEES_PUANTAJ.SAL_YEAR,
		EMPLOYEES_PUANTAJ.SSK_OFFICE,
		EMPLOYEES_PUANTAJ.SSK_OFFICE_NO,
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID,
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID
	FROM
		EMPLOYEES_PUANTAJ_ROWS_EXT,
		EMPLOYEES_PUANTAJ_ROWS,
		EMPLOYEES_PUANTAJ
	WHERE
		EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
		AND EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.PUANTAJ_ID
		AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
		AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID
		AND EMPLOYEES_PUANTAJ_ROWS_EXT.IS_KIDEM = 1
		AND EMPLOYEES_PUANTAJ_ROWS_EXT.EXT_TYPE = 0
		AND
		(
			(
			EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
			EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
			)				
			OR
			(
			EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
			EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year-2#"> AND
			EMPLOYEES_PUANTAJ.SAL_MON > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
			)
		)
	ORDER BY
		EMPLOYEES_PUANTAJ.SAL_YEAR DESC,
		EMPLOYEES_PUANTAJ.SAL_MON DESC
</cfquery>

<!--- kıdem toplamı gün yüzde dikkate alınarak toplanacak ortalaması alınacak --->
<cfset TEMP_AVG = 0>
<cfoutput query="get_emp_kidem_dahil_odeneks">
	<cfif AMOUNT_2 EQ 0><!--- ARTI --->
		<cfset TEMP_AVG = TEMP_AVG + AMOUNT>
	<cfelse><!--- YÜZDE --->
		<cfset TEMP_AVG = TEMP_AVG + AMOUNT_2>
	</cfif>
</cfoutput>
<cfif get_fire_detail.is_kidem_baz eq 1>
	<cfset datediff_ = datediff('d',get_fire_detail.kidem_date,get_fire_detail.finish_date)/30>
<cfelse>
	<cfset datediff_ = datediff('d',get_fire_detail.start_date,get_fire_detail.finish_date)/30>
</cfif>
<cfif datediff_ eq 0>
	<cfset datediff_ = 1>
</cfif>
<cfif datediff_ mod 30 neq 0>
	<cfset datediff_ = Int(datediff_)+1>
</cfif>
<cfif datediff_ gt 12>
	<cfset datediff_ = 12>
</cfif>
<cfset kidem_dahil_odenek = TEMP_AVG / datediff_>
<cfquery name="GET_SIGORTA" datasource="#dsn#" maxrows="1">
	SELECT
		(VERGI_ISTISNA_SSK + VERGI_ISTISNA_VERGI + VERGI_ISTISNA_DAMGA) AS TOPLAM_SIGORTA
	FROM
		EMPLOYEES_PUANTAJ_ROWS EPR
		INNER JOIN EMPLOYEES_PUANTAJ EP ON EPR.PUANTAJ_ID = EP.PUANTAJ_ID
	WHERE
		EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND
		EPR.TOTAL_DAYS > 0 AND		
		EP.PUANTAJ_TYPE = -1 AND
		(
			(
			EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
			AND
			EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
			)
			OR
			(
			EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#YEAR(get_fire_detail.FINISH_DATE)#">
			AND
			EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#MONTH(get_fire_detail.FINISH_DATE)#">
			)
			OR
			(
			EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
			)
		)
	ORDER BY 
		EP.SAL_YEAR DESC,
		EP.SAL_MON DESC
</cfquery>
<cfscript>
		get_fire_xml = createObject("component","V16.hr.ehesap.cfc.get_fire_xml");
		get_fire_xml.dsn = dsn;
		get_fire_xml_ = get_fire_xml.get_xml_det(property:'x_tax_acc');
		get_fire_xml_control = get_fire_xml.get_xml_det(property:'x_is_salaryparam_get_control');
		
		if ((get_fire_xml_.recordcount and get_fire_xml_.property_value eq 1) or get_fire_xml_.recordcount eq 0)
			x_tax_acc = 1;
		else
			x_tax_acc = 0;
		sigorta_toplam = 0;
		if (GET_SIGORTA.recordcount and GET_SIGORTA.TOPLAM_SIGORTA gt 0 and x_tax_acc eq 1)
			sigorta_toplam = GET_SIGORTA.TOPLAM_SIGORTA;
		if (get_fire_detail.explanation_id neq 18 and get_fire_xml_control.recordcount) //çıkış nakil değilse bu kontrole girecek
			x_is_salaryparam_get_control = get_fire_xml_control.property_value;
		else
			x_is_salaryparam_get_control = 0;
		ayni_yardim_total = 0;
</cfscript>
<cfquery name="get_ayni_yardims" datasource="#dsn#">
	SELECT
		SUM(AMOUNT_PAY) AS AYNI_TOTAL
	FROM
		SALARYPARAM_PAY
	WHERE
		IS_AYNI_YARDIM = 1 AND
		START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
		END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
		TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
		IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.in_out_id#">
</cfquery>
<cfif get_ayni_yardims.recordcount and len(get_ayni_yardims.AYNI_TOTAL)>
	<cfset ayni_yardim_total = get_ayni_yardims.AYNI_TOTAL>
</cfif>
<cfquery name="get_zimmet" datasource="#DSN#">
	SELECT ZIMMET_ID FROM EMPLOYEES_INVENT_ZIMMET WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>
<cfset this_in_out_ = attributes.in_out_id>
<!--- ücret kartına ait çıkış yapılan tarihten ileri tarihli olan kesintileri listeler--->
<cfscript>
    get_kesintis = createObject("component","V16.hr.ehesap.cfc.get_salaryparam_get");
    get_kesintis.dsn = dsn;
    get_kesintis_ = get_kesintis.get_salary_get(
        in_out_id : this_in_out_,
        term : attributes.sal_year,
        sal_mon_ : attributes.sal_mon
    );
</cfscript>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="5 - #getLang('','Çıkış Onay İşlemleri','33070')#" scroll="1" collapsable="1" resize="1"
     popup_box="#iif(isdefined("attributes.draggable"),1,0)#"
      print_href="#request.self#?fuseaction=objects.popup_print_files&action_id=#url.in_out_id#&print_type=179&iid=#attributes.employee_id#">

        <cfform name="upd_fire2" id="upd_fire2" action="#request.self#?fuseaction=ehesap.emptypopup_upd_fire" method="post">
            <input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_fire_detail.employee_id#</cfoutput>">
            <input type="hidden" name="is_kidem_baz" id="employee_id" value="<cfoutput>#get_fire_detail.is_kidem_baz#</cfoutput>">
            <input type="hidden" name="counter" id="counter" value=""> 
            <cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#"> 
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-employee_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                        <label class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfoutput>#get_fire_detail.employee_name# #get_fire_detail.employee_surname#</cfoutput>
                        </label>
                    </div>
                    <div class="form-group" id="item-explanation_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52990.Gerekçe'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif updateable>
                                <select name="explanation_id" id="explanation_id">
                                <cfloop list="#reason_order_list()#" index="ccc">
                                    <cfset value_name_ = listgetat(reason_list(),ccc,';')>
                                    <cfset value_id_ = ccc>
                                    <cfoutput><option value="#value_id_#" <cfif get_fire_detail.explanation_id eq value_id_>selected</cfif>>#value_name_#</option></cfoutput>
                                </cfloop>
                                </select>
                            <cfelse>
                            :
                                #get_explanation_name(get_fire_detail.explanation_id)#  
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_fire_detail.branch_id#</cfoutput>">
                            <cfset attributes.branch_id = get_fire_detail.branch_id>
                            <cfinclude template="../query/get_branch_ssk.cfm">
                            <cfif session.ep.ehesap>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57453.Şube'></cfsavecontent>					
                                <cfinput type="text" name="branch_name" value="#get_branch_ssk.BRANCH_NAME#-#get_branch_ssk.SSK_OFFICE#-#get_branch_ssk.SSK_NO#" required="yes" message="#message#" readonly="yes">
                            <cfelse>                    
                                : <cfoutput>#get_branch_ssk.BRANCH_NAME#-#get_branch_ssk.SSK_OFFICE#-#get_branch_ssk.SSK_NO#</cfoutput>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-DEPARTMENT">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif len(get_fire_detail.department_id)>
                                <cfquery name="DEPARTMENT" datasource="#DSN#">
                                SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.department_id#">
                                </cfquery>
                                <cfset department_name = DEPARTMENT.DEPARTMENT_HEAD>
                            <cfelse>
                                <cfset department_name = "">
                            </cfif>
                            <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_fire_detail.department_id#</cfoutput>">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57572.Departman'></cfsavecontent>  
                            <cfinput type="text" name="department_name" value="#department_name#" required="yes" message="#message#" readonly="yes">
                        </div>
                    </div>
                    <div class="form-group" id="item-salary">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53234.Maaş'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif updateable>
                                <input type="text" class="moneybox" name="salary" id="salary"  value="<cfoutput>#TLFormat(get_fire_detail.salary)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));">
                            <cfelse>
                            : <cfoutput>#TLFormat(get_fire_detail.salary)#</cfoutput>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-kidem_years">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52995.Toplam Çalıştığı Yıl'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif updateable>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='52995.Toplam Çalıştığı Yıl'></cfsavecontent>
                                <cfinput type="text" name="kidem_years" validate="integer" value="#get_fire_detail.kidem_years#" message="#message#">
                            <cfelse>
                                : <cfoutput>#get_fire_detail.kidem_years#</cfoutput>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-total_ssk_months">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53000.Toplam Çalıştığı Ay'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif updateable>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='53000.Toplam Çalıştığı Ay'></cfsavecontent>
                                <cfinput type="text" name="total_ssk_months" validate="integer" value="#get_fire_detail.total_ssk_months#" message="#message#">
                            <cfelse>
                                : <cfoutput>#get_fire_detail.total_ssk_months#</cfoutput>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-total_ssk_days">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52996.Toplam Çalıştığı Gün'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif updateable>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='52996.Toplam Çalıştığı Gün'></cfsavecontent>
                                <cfinput type="text" name="total_ssk_days" validate="integer" value="#get_fire_detail.total_ssk_days#" message="#message#">
                            <cfelse>
                                : <cfoutput>#get_fire_detail.total_ssk_days#</cfoutput>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-warning_employee">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='53647.Uyarılacak Kişi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="warning_employee_id" id="warning_employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                <cfinput type="text" name="warning_employee" value="#get_emp_info(session.ep.userid,0,0)#">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=upd_fire2.warning_employee_id&field_emp_name=upd_fire2.warning_employee</cfoutput>&select_list=1','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-quiz_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53420.İşten Çıkış Formu'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="quiz_id" id="quiz_id" value="">
                                <input type="text" name="quiz_name" id="quiz_name" value="">			
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_form_generators&type=10&is_form_generators=1&field_id=upd_fire2.quiz_id&field_name=upd_fire2.quiz_name</cfoutput>','list');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-fire_detail">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='54355.Çıkış Açıklaması'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                            <textarea name="fire_detail" id="fire_detail" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" style="width:90%;height:60px;"><cfoutput>#get_fire_detail.detail#</cfoutput></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-VALIDATOR_POSITION_CODE">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='53995.Onaylayacak'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfoutput>#get_emp_info(get_fire_detail.VALIDATOR_POSITION_CODE, 1, 1)#</cfoutput>
                            <cfif not len(get_fire_detail.valid)>
                                <cfif updateable>
                                    <cfif x_is_salaryparam_get_control eq 2 and get_kesintis_.recordcount>
                                        <font color="red"><cf_get_lang dictionary_id="41820.Çıkış işlemi yapılan çalışana ait ileri tarihli kesinti tanımları bulunmaktadır. Çıkış işlemi yapamazsınız."></font>
                                    <cfelse> 
                                        <input type="hidden" name="valid" id="valid" value="">
                                    <cfif x_is_salaryparam_get_control eq 1 and get_kesintis_.recordcount>
                                            <font color="red"><cf_get_lang dictionary_id="41820.Çıkış işlemi yapılan çalışana ait ileri tarihli kesinti tanımları bulunmaktadır. Çıkış işlemi yapamazsınız."></font>
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="41819.Çıkış işlemi yapılan çalışana ait  ileri tarihli kesinti tanımları bulunmaktadır. işleminize devam etmek istiyor musunuz?"></cfsavecontent>
                                            <i class="fa fa-thumbs-up" style="color:#13be54!important;" title="Onayla" onClick="if (confirm('<cfoutput>#message#</cfoutput>')) {upd_fire2.valid.value='1';UnformatFields(1);} else {return false;}"></i>
                                        <cfelse>
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='53999.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz'></cfsavecontent>
                                            <i class="fa fa-thumbs-up" style="color:#13be54!important;" title="Onayla" onClick="if (confirm('<cfoutput>#message#</cfoutput>')) {document.upd_fire2.valid.value='1';UnformatFields(1);} else {return false;}"></i>
                                        </cfif>                                
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='54000.Reddetmekte olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir. Reddetmek istediğinizden emin misiniz?	'></cfsavecontent>
                                        &nbsp<i class="fa fa-thumbs-down" style="color:#e7505a!important;" title="Reddet" onClick="if (confirm('<cfoutput>#message#</cfoutput>')) {upd_fire2.valid.value='0';UnformatFields(1);} else {return false;}"></i>
                                    </cfif>
                                <cfelse>
                                    <cf_get_lang dictionary_id='57615.Onay Bekliyor'> !
                                </cfif>
                            <cfelse>
                                <cfoutput>
                                    <cfif get_fire_detail.valid>
                                        <cf_get_lang dictionary_id='53004.Onaylayan'> :
                                    <cfelse>
                                        <cf_get_lang dictionary_id='53005.Reddeden'> :
                                    </cfif>
                                    #get_emp_info(get_fire_detail.valid_emp, 0, 1)# ( #dateformat(get_fire_detail.valid_date,dateformat_style)# )
                                </cfoutput>
                            </cfif>
                        </div>
                    </div>
                        <cfif updateable>
                            <input type="hidden" name="IS_EMPTY_POSITION" id="IS_EMPTY_POSITION" value="<cfoutput>#get_fire_detail.IS_EMPTY_POSITION#</cfoutput>">
                            <input type="hidden" name="IS_STATUS_EMPLOYEE" id="IS_STATUS_EMPLOYEE" value="<cfoutput>#get_fire_detail.IS_STATUS_EMPLOYEE#</cfoutput>">
                        </cfif>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-kidem_amount">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52991.Kıdem Tazminatı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif updateable>
                                <input type="text" class="moneybox" name="kidem_amount" id="kidem_amount" value="<cfoutput>#TLFormat(get_fire_detail.kidem_amount)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));">
                            <cfelse>
                                : <cfoutput>#TLFormat(get_fire_detail.kidem_amount)#</cfoutput>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-ihbar_amount">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52992.İhbar Tazminatı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif updateable>
                                <input type="text" class="moneybox" name="ihbar_amount" id="ihbar_amount"  value="<cfoutput>#TLFormat(get_fire_detail.ihbar_amount)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));">
                            <cfelse>
                                : <cfoutput>#TLFormat(get_fire_detail.ihbar_amount)#</cfoutput>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-fire_reasons">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='53643.Şirket İçi Gerekçe'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif updateable>
                                <cfquery datasource="#dsn#" name="fire_reasons">
                                    SELECT 
                                        REASON_ID, 
                                        REASON, 
                                        REASON_DETAIL, 
                                        RECORD_EMP,
                                        RECORD_IP, 
                                        RECORD_DATE, 
                                        UPDATE_EMP, 
                                        UPDATE_IP, 
                                        UPDATE_DATE 
                                    FROM 
                                        SETUP_EMPLOYEE_FIRE_REASONS 
                                    ORDER BY 
                                        REASON
                                </cfquery>
                                <cf_wrk_combo 
                                    query_name="GET_FIRE_REASONS"
                                    name="reason_id"
                                    value="#get_fire_detail.in_company_reason_id#"
                                    option_value="reason_id"
                                    option_name="reason"
                                    width="125"
                                    where="IS_ACTIVE=1 AND IS_IN_OUT=1"><!---20131107--->
                            <cfelse>
                                <cfif len(get_fire_detail.in_company_reason_id)>
                                    <cfquery datasource="#dsn#" name="fire_reason">
                                        SELECT REASON FROM SETUP_EMPLOYEE_FIRE_REASONS WHERE REASON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.in_company_reason_id#">
                                    </cfquery>
                                    <CFOUTPUT>#fire_reason.REASON#</CFOUTPUT>
                                </cfif>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-start_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57628.Giriş Tarihi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfif updateable>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57628.Giriş Tarihi'></cfsavecontent>
                                    <cfinput type="text" name="start_date" validate="#validate_style#" value="#dateformat(get_fire_detail.start_date,dateformat_style)#" message="#message#" maxlength="10" required="yes">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                    <cfelse>
                                        : <cfoutput>#dateformat(get_fire_detail.start_date,dateformat_style)#</cfoutput>
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-finish_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfif updateable>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></cfsavecontent>
                                    <cfinput type="text" name="finish_date" id="finish_date" validate="#validate_style#" value="#dateformat(get_fire_detail.finish_date,dateformat_style)#" message="#message#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                <cfelse>
                                    :<cfoutput>#dateformat(get_fire_detail.finish_date,dateformat_style)#</cfoutput>
                                    <input type="hidden" name="finish_date" id="finish_date" value="<cfoutput>#get_fire_detail.finish_date#</cfoutput>">
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-ihbar_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52999.İhbar Tarihi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_fire_detail.ihbar_date)>
                                    <cfif updateable>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='52999.İhbar Tarihi'></cfsavecontent>
                                        <cfinput type="text" name="ihbar_date" validate="#validate_style#" value="#dateformat(get_fire_detail.ihbar_date,dateformat_style)#" message="#message#" maxlength="10">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="ihbar_date"></span>
                                    <cfelse>
                                        : <cfoutput>#dateformat(get_fire_detail.ihbar_date,dateformat_style)#</cfoutput>
                                    </cfif>
                                <cfelse>
                                    <cfif updateable>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='52999.İhbar Tarihi'></cfsavecontent>
                                        <cfinput type="text" name="ihbar_date" validate="#validate_style#" value="" message="#message#" maxlength="10">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="ihbar_date"></span>
                                    <cfelse>
                                        -
                                    </cfif>
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-TOTAL_DENEME_DAYS">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53001.Deneme Süresi Gün'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif updateable>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='53001.Deneme Süresi Gün'></cfsavecontent>
                                <cfinput type="text" name="TOTAL_DENEME_DAYS" validate="integer" value="#get_fire_detail.TOTAL_DENEME_DAYS#" message="#message#" style="width:65px;">
                            <cfelse>
                                : <cfoutput>#get_fire_detail.TOTAL_DENEME_DAYS#</cfoutput>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-ihbar_days">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52997.Toplam İhbar Gün'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif updateable>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='52997.Toplam İhbar Gün'></cfsavecontent>
                                <cfinput type="text" name="ihbar_days" validate="integer" value="#get_fire_detail.ihbar_days#" message="#message#" style="width:65px;">
                            <cfelse>
                                : <cfoutput>#get_fire_detail.ihbar_days#</cfoutput>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-KULLANILMAYAN_IZIN_COUNT">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52998.Kullanılmayan Yıllık İzin Gün'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif updateable>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='52998.Kullanılmayan Yıllık İzin Gün'></cfsavecontent>
                                <cfinput type="text" name="KULLANILMAYAN_IZIN_COUNT" validate="float" value="#get_fire_detail.KULLANILMAYAN_IZIN_COUNT#" message="#message#" style="width:65px;">
                            <cfelse>
                                : <cfoutput>#get_fire_detail.KULLANILMAYAN_IZIN_COUNT#</cfoutput>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-HAKEDILEN_YILLIK_IZIN">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53002.Hakedilen Yıllık İzin Gün'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif updateable>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='53002.Hakedilen Yıllık İzin Gün'></cfsavecontent>
                                <cfinput type="text" name="HAKEDILEN_YILLIK_IZIN" validate="integer" value="#get_fire_detail.HAKEDILEN_YILLIK_IZIN#" message="#message#" style="width:65px;">
                            <cfelse>
                                <cfinput type="text" name="HAKEDILEN_YILLIK_IZIN" value="#TLFormat(get_fire_detail.HAKEDILEN_YILLIK_IZIN)#" class="moneybox">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-KULLANILMAYAN_IZIN_AMOUNT">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53003.Kullanılmayan Yıllık İzin Tutarı'> <cfif get_fire_detail.GROSS_COUNT_TYPE eq 1>Net</cfif></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfif updateable>
                                <input type="text" class="moneybox" name="KULLANILMAYAN_IZIN_AMOUNT" id="KULLANILMAYAN_IZIN_AMOUNT" value="<cfoutput>#TLFormat(get_fire_detail.KULLANILMAYAN_IZIN_AMOUNT)#</cfoutput>" style="width:65px;" onKeyUp="return(FormatCurrency(this,event));">
                            <cfelse>
                                : <cfoutput>#TLFormat(get_fire_detail.KULLANILMAYAN_IZIN_AMOUNT)#</cfoutput>
                            </cfif>
                        </div>
                    </div>
                    <cfif get_fire_detail.explanation_id eq 18>
                        <div class="form-group" id="ACCOUNT_BILL_TYPE_PLACE">
                            <cfif get_fire_detail.is_accounting_transfer eq 1>
                                <cfquery name="get_period" datasource="#dsn#">
                                    SELECT 
                                        SP.PERIOD_ID 
                                    FROM 
                                        SETUP_PERIOD SP INNER JOIN OUR_COMPANY OC ON SP.OUR_COMPANY_ID = OC.COMP_ID
                                        INNER JOIN BRANCH B ON OC.COMP_ID = B.COMPANY_ID
                                    WHERE
                                        B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.entry_branch_id#"> AND
                                        SP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(get_fire_detail.entry_date)#">
                                </cfquery>
                                <cfscript>
                                    cmp = createObject("component","V16.hr.cfc.create_account_period");
                                    cmp.dsn = dsn;
                                    get_acc_def = cmp.get_account_definition(period_id : get_period.period_id,branch_id:get_fire_detail.entry_branch_id,department_id:get_fire_detail.entry_department_id);
                                    if(not get_acc_def.recordcount)
                                    {
                                        get_acc_def = cmp.get_account_definition(period_id : get_period.period_id,branch_id:get_fire_detail.entry_branch_id);
                                    }	
                                    if(get_acc_def.recordcount)
                                    {
                                        get_account_bill_type = cmp.get_account_definiton_code_row(account_definition_id:get_acc_def.id);
                                    }
                                    else
                                    {
                                        get_account_bill_type.recordcount = 0;	
                                    }
                                </cfscript>
                                <cfif get_account_bill_type.recordcount>
                                    <input type="hidden" name="account_bill_type_count" id="account_bill_type_count" value="<cfoutput>#get_account_bill_type.recordcount#</cfoutput>">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><b><cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'></b></label>
                                    <cfoutput query="get_account_bill_type">
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <input type="radio" name="account_bill_type" id="account_bill_type" value="#account_bill_type#" <cfif len(get_fire_detail.new_card_account_bill_type) and get_fire_detail.new_card_account_bill_type eq account_bill_type>checked</cfif>> #definition#
                                        </div>
                                    </cfoutput>
                                <cfelse>
                                    <input type="hidden" name="account_bill_type_count" id="account_bill_type_count" value="0">
                                </cfif>
                            </cfif>
                        </div>
                    </cfif>
                    <cfif isdefined("get_emp_kidem_dahil_odeneks") and get_emp_kidem_dahil_odeneks.recordcount>
                        <cf_seperator id="hesap_" title="#getLang('','Hesaplama Detayını Görmek İçin Tıklayınız','59304')#" onClick_function="gizle_goster(detail_pay);">
                        <div id="hesap_"></div>
                        <cf_flat_list id="detail_pay" style="display:none;">
                            <cfquery name="get_emp_kidem_dahil_odeneks_row" dbtype="query">
                                SELECT DISTINCT COMMENT_PAY FROM get_emp_kidem_dahil_odeneks
                            </cfquery>
                            <cfquery name="get_emp_kidem_dahil_odeneks_row_2" dbtype="query">
                                SELECT DISTINCT SAL_MON,SAL_YEAR FROM get_emp_kidem_dahil_odeneks
                            </cfquery>
                            <cfoutput query="get_emp_kidem_dahil_odeneks">
                                <cfif AMOUNT_2 EQ 0>
                                    <cfset "amount_#sal_mon#_#sal_year#_#replacelist(replacelist(comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#" = AMOUNT>
                                <cfelse>
                                    <cfset "amount_#sal_mon#_#sal_year#_#replacelist(replacelist(comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#" = AMOUNT_2>
                                </cfif>
                            </cfoutput>
                            <thead>
                                <tr>
                                    <th colspan="<cfoutput>#get_emp_kidem_dahil_odeneks_row.recordcount+2#</cfoutput>"><cf_get_lang dictionary_id="53399.Ek Ödenekler"></th>
                                </tr>
                                <tr>
                                    <th width="50"><cf_get_lang dictionary_id="58455.Yıl"></th>
                                    <th width="50"><cf_get_lang dictionary_id="58724.Ay"></th>
                                    <cfoutput query="get_emp_kidem_dahil_odeneks_row">
                                        <th nowrap>#comment_pay#</th>
                                    </cfoutput>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="get_emp_kidem_dahil_odeneks_row_2">
                                    <tr>
                                        <td>#sal_year#</td>
                                        <td>#sal_mon#</td>
                                        <cfloop query="get_emp_kidem_dahil_odeneks_row">
                                            <td style="text-align:right">
                                                <cfif isdefined("amount_#get_emp_kidem_dahil_odeneks_row_2.sal_mon#_#get_emp_kidem_dahil_odeneks_row_2.sal_year#_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#")>
                                                    <cfif isdefined("toplam_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#")>
                                                        <cfset "toplam_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#" = evaluate("toplam_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#") + evaluate("amount_#get_emp_kidem_dahil_odeneks_row_2.sal_mon#_#get_emp_kidem_dahil_odeneks_row_2.sal_year#_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#")>
                                                    <cfelse>
                                                        <cfset "toplam_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#" = evaluate("amount_#get_emp_kidem_dahil_odeneks_row_2.sal_mon#_#get_emp_kidem_dahil_odeneks_row_2.sal_year#_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#")>
                                                    </cfif>
                                                    #tlformat(evaluate("amount_#get_emp_kidem_dahil_odeneks_row_2.sal_mon#_#get_emp_kidem_dahil_odeneks_row_2.sal_year#_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#"))#
                                                <cfelse>
                                                    #tlformat(0)#
                                                </cfif>
                                            </td>
                                        </cfloop>
                                    </tr>
                                </cfoutput>
                                <tr class="txtbold">
                                    <td colspan="2"><cf_get_lang dictionary_id="57492.Toplam"></td>
                                    <cfoutput>
                                        <cfloop query="get_emp_kidem_dahil_odeneks_row">
                                            <td style="text-align:right">
                                                <cfif isdefined("toplam_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#")>
                                                    #tlformat(evaluate("toplam_#replacelist(replacelist(get_emp_kidem_dahil_odeneks_row.comment_pay,' ,(,),%,.,-,/,*,+,"',',,,,,,,,'),"'",",")#"))#
                                                <cfelse>
                                                    #tlformat(0)#
                                                </cfif>
                                            </td>
                                        </cfloop>
                                    </cfoutput>
                                </tr>
                                <cfoutput>
                                    <tr class="txtbold">
                                        <td colspan="2"><cf_get_lang dictionary_id="59303.Ek Ödenek Ortalaması"></td>
                                        <td style="text-align:right">#tlformat(kidem_dahil_odenek)#</td>
                                    </tr>
                                    <tr class="txtbold">
                                        <td colspan="2"><cf_get_lang dictionary_id="59302.Özel Sigorta"></td>
                                        <td style="text-align:right">#tlformat(sigorta_toplam)#</td>
                                    </tr>
                                    <tr class="txtbold">
                                        <td colspan="2"><cf_get_lang dictionary_id="59301.Diğer Ödemeler"></td>
                                        <td style="text-align:right">#tlformat(ayni_yardim_total)#</td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </cf_flat_list>
                    </cfif>
                    <!--- <cf_seperator id="kesinti_" title="#getLang('','Kesintiler','38977')#" onClick_function="gizle_goster(detail_emp_get);">
                    <div id="detail_emp_get"></div> --->
                    <cfif isdefined("get_assetps") and get_assetps.recordcount>
                        <cf_seperator id="ekbilgi_" title="#getLang('','Ek Bilgiler','55129')#" onClick_function="gizle_goster(detail_emp_asset);">
                            <div id="ekbilgi_"></div>
                            <cf_flat_list id="detail_emp_asset" style="display:none;">
                                <thead>
                                    <tr>
                                        <th height="25" class="formbold"><cf_get_lang dictionary_id="41817.Çalışan Zimmetleri"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfif get_assetps.recordcount>
                                        <cfoutput query="get_assetps">
                                            <tr>
                                                <td><b>#assetp#</b> / #assetp_cat#</td>
                                            </tr>
                                        </cfoutput>
                                    </cfif>
                                    <cfif get_zimmets.recordcount>
                                        <cfoutput query="get_zimmets">
                                            <tr>
                                                <td><b>#device_name#</b> / No: #inventory_no# (#property#)</td>
                                            </tr>
                                        </cfoutput>
                                    </cfif>
                                    <cfif not (get_assetps.recordcount or get_zimmets.recordcount)>
                                        <tr>
                                            <td><cf_get_lang dictionary_id ='58486.Kayıt Bulunamadı'>!</td>
                                        </tr>
                                    </cfif>
                                </tbody>
                                <thead>
                                    <tr>
                                        <th height="25" class="formbold"><cf_get_lang dictionary_id="33681.Çalışan Notları"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfif get_note.recordcount>
                                        <cfoutput query="get_note">
                                            <tr>
                                                <td class="txtboldblue" height="20"><li>#note_head#</li></td>
                                            </tr>
                                            <tr>
                                                <td>#note_body#</td>
                                            </tr>
                                        </cfoutput>
                                    <cfelse>
                                        <tr>
                                            <td><cf_get_lang dictionary_id ='58486.Kayıt Bulunamadı'>!</td>
                                        </tr>
                                    </cfif>
                                </tbody>
                                <thead>
                                    <tr>
                                        <th height="25" class="formbold"><cf_get_lang dictionary_id="33682.İlişkili Çalışanlar"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfif get_all_emps.recordcount or get_all_emps_related.recordcount>
                                        <cfoutput query="get_all_emps">
                                            <tr>
                                                <td>
                                                    <li>
                                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#member_id#','medium');" class="tableyazi">#member_name# #member_surname#</a>
                                                        <cfif len(project_roles)> - #project_roles#</cfif>
                                                    </li>
                                                </td>
                                            </tr>
                                        </cfoutput>
                                        <cfoutput query="get_all_emps_related">
                                            <tr>
                                                <td>
                                                    <li>
                                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#member_id#','medium');" class="tableyazi">#member_name# #member_surname#</a>
                                                        <cfif len(project_roles)> - #project_roles#</cfif>
                                                    </li>
                                                </td>
                                            </tr>
                                        </cfoutput>
                                    <cfelse>
                                        <tr>
                                            <td><cf_get_lang dictionary_id ='58486.Kayıt Bulunamadı'>!</td>
                                        </tr>
                                    </cfif>
                                </tbody>
                            </cf_flat_list>
                    </cfif>
                </div>
                <cfif get_fire_detail.explanation_id eq 18>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif len(get_fire_detail.in_out_stage)>
                                    <cf_workcube_process is_upd='0' select_value='#get_fire_detail.in_out_stage#' process_cat_width='125' is_detail='1'>
                                <cfelse>
                                    <cf_workcube_process is_upd='0' select_value='' process_cat_width='125' is_detail='0'>
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-entry_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53348.İşe Giriş Tarihi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="entry_date" id="entry_date" style="width:125px;" maxlength="10" validate="#validate_style#" value="<cfif len(get_fire_detail.entry_date)><cfoutput>#dateformat(get_fire_detail.entry_date,dateformat_style)#</cfoutput></cfif>">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="entry_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-branch_">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif len(get_fire_detail.entry_branch_id) and len(get_fire_detail.entry_department_id)>
                                    <cfquery name="get_branch_name" datasource="#dsn#">
                                        SELECT 
                                            D.DEPARTMENT_HEAD,
                                            D.DEPARTMENT_ID,
                                            B.BRANCH_ID,
                                            B.BRANCH_NAME 
                                        FROM
                                            BRANCH B
                                            INNER JOIN DEPARTMENT D ON D.BRANCH_ID = B.BRANCH_ID
                                        WHERE 
                                            B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.entry_branch_id#"> AND
                                            D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.entry_department_id#">
                                    </cfquery>
                                    <cfset attributes.entry_branch_id = get_branch_name.BRANCH_ID>
                                    <cfset attributes.entry_branch_name = get_branch_name.BRANCH_NAME>
                                    <cfset attributes.entry_department_id = get_branch_name.DEPARTMENT_ID>
                                    <cfset attributes.entry_department_name = get_branch_name.DEPARTMENT_HEAD>
                                <cfelse>
                                    <cfset attributes.entry_branch_id = "">
                                    <cfset attributes.entry_branch_name = "">
                                    <cfset attributes.entry_department_id = "">
                                    <cfset attributes.entry_department_name = "">
                                </cfif>
                                <input type="hidden" name="entry_branch_id" id="entry_branch_id" value="<cfoutput>#attributes.entry_branch_id#</cfoutput>">
                                <input type="text" name="branch_" id="branch_" value="<cfoutput>#attributes.entry_branch_name#</cfoutput>" readonly>
                            </div>
                        </div>
                        <div class="form-group" id="item-entry_department_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="entry_department_id" id="entry_department_id" value="<cfoutput>#attributes.entry_department_id#</cfoutput>">
                                    <cfinput type="text" name="entry_department" id="entry_department" value="#attributes.entry_department_name#" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=upd_fire2.entry_department_id&field_name=upd_fire2.entry_department&field_branch_name=upd_fire2.branch_&field_branch_id=upd_fire2.entry_branch_id</cfoutput>&run_function=get_bill_type()','list');"></span>
                                </div>
                            </div>
                        </div>
                        <cfif get_fire_detail.explanation_id eq 18><!--- nakil ise--->
                        <div class="form-group" id="item-get_fire_detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfoutput>#get_fire_detail.definition#</cfoutput>
                            </div>
                        </div>
                        </cfif>
                        <div class="form-group" id="item-is_salary">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <cf_get_lang dictionary_id='53211.Ücret Bilgileri Aktarılsın'>
                            </label>
                            <label class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_salary" id="is_salary" value="1"<cfif get_fire_detail.is_salary_transfer eq 1>checked</cfif>></label>
                        </div>
                        <div class="form-group" id="item-is_salary_detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <cf_get_lang dictionary_id='53225.Ödenek,Kesinti ve İstisnalar Aktarılsın'>
                            </label>
                            <label class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_salary_detail" id="is_salary_detail" value="1" <cfif get_fire_detail.is_salary_detail_transfer eq 1>checked</cfif>></label>
                        </div>
                        <div class="form-group" id="item-is_accounting">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <cf_get_lang dictionary_id='53316.Muhasebe Bilgileri Aktarılsın'>
                            </label>
                            <label class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_accounting" id="is_accounting" onchange="get_bill_type()" value="1" <cfif get_fire_detail.is_accounting_transfer eq 1>checked</cfif>></label>
                        </div>
                        <div class="form-group" id="item-is_update_position">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <cf_get_lang dictionary_id='53418.Pozisyon bilgileri güncellensin'>
                            </label>
                            <label class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_update_position" id="is_update_position" value="1" <cfif get_fire_detail.is_update_position eq 1>checked</cfif>></label>
                        </div>
                    </div>
                </cfif>
            </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="get_fire_detail">
                <cfif updateable>
                    <cfif get_fire_count.recordcount eq 1>
                    <cf_workcube_buttons is_upd='1' is_delete='0' add_function='control()'>
                    <cfelse>
                    <cf_workcube_buttons is_upd='1' is_del='1' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_fire&in_out_id=#attributes.in_out_id#&head=#get_fire_detail.employee_name# #get_fire_detail.employee_surname#' add_function='control()'>
                    </cfif>
                </cfif>
            </cf_box_footer>
        </cfform>
        <cfinclude template="../display/dsp_salaryparam_get.cfm">
    </cf_box>
</div>
<cfif updateable>
    <script type="text/javascript">
        function get_bill_type()
        {	
            if(document.getElementById('is_accounting').checked == true) //muhasebe bilgileri aktarılsın seçili ise çalışsın
            {	
                var branch_id = document.getElementById('entry_branch_id').value;
                var department_id = document.getElementById('entry_department_id').value;
                var startdate =  document.getElementById('start_date').value;
                if (branch_id != "" && department_id!= "")
                { 
                    var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_ajax_list_account_bill_type&branch_id="+branch_id+"&department_id="+department_id+"&startdate="+startdate;
                    AjaxPageLoad(send_address,'ACCOUNT_BILL_TYPE_PLACE',1,'İlişkili Kod Grupları');
                }
            }
        }
        function control()
        {
            // eger şube veya departmana ait birden fazla tanımlı kod grubu var ise 1 tanesini seçmesi gerekiyor SG 20150413
            <cfif get_fire_detail.is_accounting_transfer eq 1>
                if(document.getElementById('finish_date').value != "" && document.getElementById('account_bill_type_count').value > 0)
                {
                    var account = "";
                    for (i = 0; i < document.getElementById('account_bill_type_count').value; i++)
                    {
                        if ( document.upd_fire2.account_bill_type[i].checked) 
                        {
                            account = document.upd_fire2.account_bill_type[i].value;
                            break;
                        }
                    }
                    if(account != undefined && account == "")
                    {
                        alert('<cf_get_lang dictionary_id="54117.Muhasebe Kod Grubu">!');	
                        return false;
                    }
                }
            </cfif>
            UnformatFields();
        }
        function UnformatFields(type)
        {
            if(upd_fire2.finish_date.value == "")
            {
                upd_fire2.valid.value = 0;
            }
            upd_fire2.kidem_amount.value = filterNum(upd_fire2.kidem_amount.value);
            upd_fire2.salary.value = filterNum(upd_fire2.salary.value);
            upd_fire2.ihbar_amount.value = filterNum(upd_fire2.ihbar_amount.value);
            upd_fire2.KULLANILMAYAN_IZIN_AMOUNT.value= filterNum(upd_fire2.KULLANILMAYAN_IZIN_AMOUNT.value);
            if(type == 1)
                $( "#upd_fire2" ).submit();
            return true;
        }
    </script>
</cfif>
