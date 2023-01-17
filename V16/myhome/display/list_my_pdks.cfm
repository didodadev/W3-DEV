<cf_xml_page_edit fuseact="hr.list_emp_pdks">
<cfset cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps")>
<cfset cmp_org_step.dsn = dsn>
<cfset attributes.employee_id = session.ep.userid>
<cfset attributes.position_code = session.ep.position_code>
<cfset puantaj_gun_ = daysinmonth(now())>
<cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(year(now()),month(now()),1))>
<cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(year(now()),month(now()),puantaj_gun_)))>
<cfset gecen_ay_ = date_add("m",-1,puantaj_start_)>
<cfset gecen_ay_puantaj_gun_ = daysinmonth(gecen_ay_)>
<cfif isdefined("attributes.aktif_gun") and len(attributes.aktif_gun)>
	<script type="text/javascript">
		windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_edit_daily_in_mail&employee_id=#attributes.employee_id#&aktif_gun=#attributes.aktif_gun#</cfoutput>','small');
	</script>
</cfif>
<cfquery name="get_kart_no" datasource="#dsn#" maxrows="1">
	SELECT
		PDKS_NUMBER
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		EMPLOYEE_ID = #attributes.employee_id#
	ORDER BY IN_OUT_ID DESC
</cfquery>
<cfquery name="get_in_outs" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.employee_id# AND START_DATE BETWEEN #gecen_ay_# AND #puantaj_finish_# AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0
</cfquery>
<cfquery name="GET_TODAY_OFFTIMES" datasource="#DSN#">
	SELECT 
		OFFTIME.VALID, 
		OFFTIME.VALIDDATE,
		OFFTIME.EMPLOYEE_ID, 
		OFFTIME.OFFTIME_ID, 
		OFFTIME.VALID_EMPLOYEE_ID, 
		OFFTIME.STARTDATE, 
		OFFTIME.FINISHDATE, 
		OFFTIME.TOTAL_HOURS, 
		SETUP_OFFTIME.OFFTIMECAT,
		D.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
        CASE 
            WHEN EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
        THEN	
            D.HIERARCHY_DEP_ID
        ELSE 
            CASE WHEN 
                D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID))
            THEN
                (SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
            ELSE
                D.HIERARCHY_DEP_ID
            END
        END AS HIERARCHY_DEP_ID
	FROM 
		OFFTIME,
		EMPLOYEES,
        DEPARTMENT D,
		SETUP_OFFTIME
	WHERE
		OFFTIME.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
		OFFTIME.EMPLOYEE_ID = #attributes.employee_id# AND
		OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.EMPLOYEE_ID=EMPLOYEES.EMPLOYEE_ID
</cfquery>
<cfquery name="get_fees" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_SSK_FEE WHERE EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31900.PDKS Durumu'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#message#">
        <cf_box_elements>
            <cfoutput>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="form-group" id="item-name">
                        <label class="col col-2 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32370.Adı Soyadı'>:</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">#session.ep.name# #session.ep.surname#</div>
                    </div>
                    <div class="form-group" id="item-card-no">
                        <label class="col col-2 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31584.Kart No'>:</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">#get_kart_no.pdks_number#</div>
                    </div>
                    <div class="form-group" id="item-position">
                        <label class="col col-2 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'>:</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">#session.ep.position_name#</div>
                    </div>
                    <div class="form-group" id="item-donem">
                        <label class="col col-2 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'>:</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">#listgetat(ay_list(),month(gecen_ay_))# #year(gecen_ay_)# - #listgetat(ay_list(),month(now()))# #year(now())#</div>
                    </div>
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cf_grid_list>
                        <thead>
                            <tr class="color-header" height="25">
                                <cfset colspan = "5">
                                <th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
                                <th width="50"><cf_get_lang dictionary_id='57490.Gün'></th>
                                <cfif isdefined("is_pdks_multirecord") and is_pdks_multirecord eq 1>
                                    <cfset colspan = colspan + 4>
                                    <th width="5">K</th>
                                    <th width="35"><cf_get_lang dictionary_id ='57554.Giriş'></th>
                                    <th width="35"><cf_get_lang dictionary_id ='57431.Çıkış'></th>
                                    <th width="35"><cf_get_lang dictionary_id ='57554.Giriş'></th>
                                    <th width="35"><cf_get_lang dictionary_id ='57431.Çıkış'></th>
                                </cfif>
                                <th width="35"><cf_get_lang dictionary_id='57554.Giriş'></th>
                                <th width="35"><cf_get_lang dictionary_id='57431.Çıkış'></th>
                                <th width="100"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                                <th width="100"><cf_get_lang dictionary_id='57453.Şube'></th>
                                <th width="300"><cf_get_lang dictionary_id='58575.İzin'></th>
                                <th width="50"><cf_get_lang dictionary_id='58576.Vizite'></th>
                                <th width="35"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfset toplam_gun_ = puantaj_gun_+gecen_ay_puantaj_gun_>
                            <cfif len(pdks_day_value) and toplam_gun_ gt pdks_day_value>
                                <cfset toplam_gun_ = pdks_day_value>
                                <cfset gecen_ay_ = date_add("d",-pdks_day_value,puantaj_finish_)>	
                            </cfif>
                            <cfset aktif_employee_id = attributes.employee_id>
                            <cfinclude template="list_my_pdks_in.cfm">
                        </tbody>
                    </cf_grid_list>
                </div>
            </cfoutput>
        </cf_box_elements>
    </cf_box>
</div>
