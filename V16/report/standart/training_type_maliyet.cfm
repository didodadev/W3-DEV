<cfparam name="attributes.module_id_control" default="34">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.sal_mon" default=""> 
<cfparam name="attributes.sal_year" default="">
<cfprocessingdirective suppresswhitespace="yes">
<cfparam name="attributes.training_style_id" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=0>
<cfparam name="get_cost_record.recordcount" default=0>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<style>
    .t_foot_td{
        padding: 8px 10px;
        height: 30px;
        font-family: sans-serif !important;
        font-size: 12px;
    }
    .t_foot_tr{
        background:#f5f4f0!important;
    }
    .t_foot_tr:hover{
        background:#f2dbd1!important;
    }
</style>
<cfquery name="get_training_style" datasource="#dsn#">
	SELECT 
	    TRAINING_STYLE_ID, 
        TRAINING_STYLE, 
        DETAIL
    FROM 
    	SETUP_TRAINING_STYLE
</cfquery>
<cfquery name="GET_PERIOD_LIST" datasource="#DSN#"><!--- sonraki donem kontrol ediliyor --->
	SELECT 
		PERIOD_ID,PERIOD_YEAR 
	FROM 
		SETUP_PERIOD 
	WHERE 
		OUR_COMPANY_ID=#session.ep.company_id#
	ORDER BY 
		PERIOD_YEAR DESC
</cfquery>
<cfset dsn2_new = '#dsn#_#listlast(attributes.sal_year,';')#_#session.ep.company_id#'>
<cfif isdefined("attributes.is_submitted")>
    <cfif (attributes.sal_mon==0)>
        <cfset attributes.sal_mon=1> 
    </cfif>
    <cfset training_gun_ = daysinmonth(CREATEDATE(listlast(attributes.sal_year,';'),attributes.SAL_MON,1))>
    <cfset training_start_ = CREATEODBCDATETIME(CREATEDATE(listlast(attributes.sal_year,';'),attributes.SAL_MON,1))>
    <cfset training_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(listlast(attributes.sal_year,';'),attributes.SAL_MON,training_gun_)))>
        <cfquery name="get_emp_branch" datasource="#DSN#">
            SELECT
                BRANCH_ID, 
                POSITION_CODE, 
                DEPARTMENT_ID
            FROM
                EMPLOYEE_POSITION_BRANCHES
            WHERE
                POSITION_CODE = #SESSION.EP.POSITION_CODE#
        </cfquery>
        <cfset emp_branch_list=valuelist(get_emp_branch.BRANCH_ID)>
        <cfquery name="get_all_bodies" datasource="#dsn#">
            SELECT
                TC.CLASS_PLACE,
                TC.CLASS_ID,
                TC.CLASS_NAME,
                TC.START_DATE,
                TC.FINISH_DATE,
                TC.INT_OR_EXT,
                B.BRANCH_NAME,
                B.BRANCH_ID,
                STS.TRAINING_STYLE,
                STS.TRAINING_STYLE_ID
            FROM 
                TRAINING_CLASS TC,
                TRAINING_CLASS_ATTENDER TCA,
                EMPLOYEE_POSITIONS EP,
                DEPARTMENT D,
                BRANCH B,
                SETUP_TRAINING_STYLE STS
            WHERE 
                TC.CLASS_ID = TCA.CLASS_ID AND
                TCA.EMP_ID = EP.EMPLOYEE_ID AND
                EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                D.BRANCH_ID = B.BRANCH_ID AND
                TCA.EMP_ID IS NOT NULL AND
                TCA.PAR_ID IS NULL AND 
                TCA.CON_ID IS NULL AND
                TC.START_DATE < #training_finish_# AND 
                TC.FINISH_DATE >= #training_start_# AND
                <cfif len(attributes.training_style_id)>
                STS.TRAINING_STYLE_ID = #attributes.training_style_id# AND
                </cfif>
                B.BRANCH_ID IN (#emp_branch_list#) AND
                EP.IS_MASTER = 1 AND
                TC.TRAINING_STYLE = STS.TRAINING_STYLE_ID
            ORDER BY B.BRANCH_ID DESC
        </cfquery>
        <cfset class_list = listsort(listdeleteduplicates(valuelist(get_all_bodies.class_id,',')),'numeric','ASC',',')>
        <cfif len(class_list)>
            <cfquery name="get_cost_record" datasource="#dsn#">
                SELECT 
                    TRAINING_CLASS_COST_ID, 
                    CLASS_ID, 
                    CLASS_COST 
                FROM 
                    TRAINING_CLASS_COST 
                WHERE 
                    CLASS_ID IN (#class_list#)
            </cfquery>
        </cfif>
        <cfset attributes.totalrecords=get_cost_record.recordcount>
        <cfif isdefined("get_cost_record") and get_cost_record.recordcount>
            <cfset class_list_2 = listsort(listdeleteduplicates(valuelist(get_cost_record.class_id,',')),'numeric','ASC',',')>
            <cfquery name="get_all_bodies_" dbtype="query">
                    SELECT
                        CLASS_PLACE,
                        CLASS_ID,
                        CLASS_NAME,
                        START_DATE,
                        FINISH_DATE,
                        INT_OR_EXT,
                        BRANCH_NAME,
                        BRANCH_ID,
                        TRAINING_STYLE,
                        TRAINING_STYLE_ID
                    FROM
                        get_all_bodies
                    WHERE
                        CLASS_ID IN (#class_list_2#)
                </cfquery>
            <cfquery name="get_all_giders" datasource="#dsn#">
                SELECT
                    TCC.TRAINING_CLASS_COST_ID,
                    TCC.CLASS_ID,
                    TCCR.EXPENSE_ITEM_ID,
                    TCCR.EXPLANATION,
                    TCCR.GERCEKLESEN,
                    TCCR.ONGORULEN,
                    TCCR.GERCEKLESEN_BIRIM,
                    TCCR.ONGORULEN_BIRIM,
                    TCCR.GERCEKLESEN_MIKTAR,
                    TCCR.ONGORULEN_MIKTAR,
                    EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                    STS.TRAINING_STYLE_ID
                FROM
                    TRAINING_CLASS TC,
                    TRAINING_CLASS_COST TCC,
                    TRAINING_CLASS_COST_ROWS TCCR,
                    SETUP_TRAINING_STYLE STS,
                    <cfif fusebox.use_period>#dsn2_new#<cfelse>#dsn_alias#</cfif>.EXPENSE_ITEMS EXPENSE_ITEMS
                WHERE
                    TC.CLASS_ID = TCC.CLASS_ID AND
                    TCC.CLASS_ID IN (#class_list_2#) AND
                    TC.TRAINING_STYLE = STS.TRAINING_STYLE_ID AND
                    TCC.TRAINING_CLASS_COST_ID = TCCR.TRAINING_CLASS_COST_ID AND
                    TCCR.EXPENSE_ITEM_ID = EXPENSE_ITEMS.EXPENSE_ITEM_ID
            </cfquery>
            <cfquery name="get_giders" dbtype="query">
                SELECT DISTINCT EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,CLASS_ID,TRAINING_STYLE_ID FROM get_all_giders
            </cfquery>
            <cf_basket id="type_maliyet_basket">
            <cfoutput query="get_all_bodies_">
                <cfif isdefined("branch_katil_#branch_id#_#class_id#")>
                    <cfset 'branch_katil_#branch_id#_#class_id#' = evaluate("branch_katil_#branch_id#_#class_id#") + 1>
                <cfelse>
                    <cfset 'branch_katil_#branch_id#_#class_id#' = 1>
                </cfif>
                
                <cfif isdefined("egitim_#class_id#")>
                    <cfset 'egitim_#class_id#' = evaluate("egitim_#class_id#") + 1>
                <cfelse>
                    <cfset 'egitim_#class_id#' = 1>
                </cfif>	
            </cfoutput>
            <cfquery name="get_styles" dbtype="query">
                SELECT DISTINCT
                    TRAINING_STYLE,
                    TRAINING_STYLE_ID
                FROM
                    get_all_bodies_
                ORDER BY
                    TRAINING_STYLE_ID DESC
            </cfquery>
            <cfquery name="get_branches" dbtype="query">
                SELECT DISTINCT
                    BRANCH_ID,
                    BRANCH_NAME
                FROM
                    get_all_bodies_
                ORDER BY
                    BRANCH_ID DESC
            </cfquery>
        </cfif>
    </cfif>
<cfform name="puantaj_" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
    <cf_report_list_search id="search" title="#getLang('report',1636)#">
    <cf_report_list_search_area>
        <div class="row">
            <div class="col col-12 col-xs-12">
                <div class="row formContent">
                    <div class="row" type="row">
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                 <!---Aylar Select Box Start--->
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='1260.Aylar'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="sal_mon" id="sal_mon">
                                            <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfloop from="1" to="12" index="i">
                                                <cfoutput>
                                                    <option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option>
                                                </cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>
                                </div>
                                <!---Aylar Select Box Finish--->
                            </div>	
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                <!---Yıllar Select Box Start--->
                               <div class="form-group">
                                   <label class="col col-12 col-xs-12"><cfoutput>#getLang('report',1267)#</cfoutput></label>
                                   <div class="col col-12 col-xs-12">
                                        <select name="sal_year" id="sal_year"><!---  <cfif isdefined('selected_ship_period') and len(selected_ship_period)>onchange="control_period(this.value,<cfoutput>#selected_ship_period#</cfoutput>);"</cfif> --->
                                            <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="GET_PERIOD_LIST">
                                                <option value="#PERIOD_ID#;#PERIOD_YEAR#" <cfif listfirst(attributes.sal_year,';') eq PERIOD_ID>selected</cfif>>#PERIOD_YEAR#</option>
                                            </cfoutput>
                                        </select> 
                                   </div>
                               </div>
                               <!---Yıllar Select Box Finish--->
                           </div>	
                           <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                <!---Eğitim Şekli Select Box Start--->
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='7.Eğitim'><cf_get_lang_main no ='1251.Şekli'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="training_style_id" id="training_style_id">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_training_style">
                                                <option value="#training_style_id#" <cfif isdefined("attributes.training_style_id") and (attributes.training_style_id eq training_style_id)>selected</cfif>>#training_style#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <!----Eğitim Şekli Box Finish--->
                            </div>				
                        </div>
                    </div>
                </div>
                <div class="row ReportContentBorder">
                    <div class="ReportContentFooter">
                        <label><cf_get_lang_main no='446.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                        <cfelse>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </cfif>
                        <cfsavecontent variable="message"><cf_get_lang_main no ='499.Çalıştır'></cfsavecontent>
                        <input type="hidden" name="is_submitted" id="is_submitted" value="1">
                        <cf_wrk_report_search_button  search_function='control()' insert_info='#message#' button_type='1' is_excel="1">     
                    </div>
            	</div>
            </div>
        </div>
    </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
    <cfset filename="training_type_maliyet#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-16">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="content-type" content="text/plain; charset=utf-16">
    <cfset attributes.startrow=1>
    <cfset attributes.maxrows=get_cost_record.recordcount>
</cfif>
<cfif isdefined("attributes.is_submitted")>
    <cf_report_list>
        <cfif isdefined("get_cost_record") and get_cost_record.recordcount>
            <thead>
                <tr>
                    <th></th>
                    <cfoutput query="get_branches"><th class="formbold" align="center" colspan="3">#branch_name#</th></cfoutput>
                </tr>
                <tr>
                    <th></th>
                    <cfoutput query="get_branches">
                        <th><cf_get_lang_main no='1457.Planlanan'></th>
                        <th><cf_get_lang no ='1004.Gerçekleşen'></th>
                        <th width="65"><cf_get_lang_main no ='1044.Oran'></th>
                    </cfoutput>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="get_styles" >
                    <tr>
                        <td colspan="#1+(get_branches.recordcount*3)#" class="formbold" height="25" align="center">#TRAINING_STYLE#</td>
                    </tr>
                    <cfset style_ = TRAINING_STYLE_ID>
                    <cfloop query="get_giders">
                        <cfset class_id_ = get_giders.class_id>
                        <cfquery name="get_this_" dbtype="query">
                            SELECT 
                                SUM(ONGORULEN) AS HEDEF_TOPLAM,
                                SUM(GERCEKLESEN) AS GERCEK_TOPLAM 
                            FROM 
                                get_all_giders 
                            WHERE
                                CLASS_ID = #get_giders.class_id# AND
                                EXPENSE_ITEM_ID = #get_giders.EXPENSE_ITEM_ID# AND
                                TRAINING_STYLE_ID = #style_#
                        </cfquery>
                        <cfif get_this_.recordcount and len(get_this_.HEDEF_TOPLAM) and len(get_this_.GERCEK_TOPLAM)>
                        </cfif>
                    <tr>
                        <td>#EXPENSE_ITEM_NAME#</td>
                        <cfloop query="get_branches">
                            <cfif isdefined("branch_katil_#get_branches.branch_id#_#class_id_#") and get_this_.recordcount and len(get_this_.HEDEF_TOPLAM) and len(get_this_.GERCEK_TOPLAM)>
                                <cfset tutar_payi_hedef_ = get_this_.HEDEF_TOPLAM / evaluate("egitim_#class_id_#") * evaluate("branch_katil_#get_branches.branch_id#_#class_id_#")>
                                <cfset tutar_payi_gercek_ = get_this_.GERCEK_TOPLAM / evaluate("egitim_#class_id_#") * evaluate("branch_katil_#get_branches.branch_id#_#class_id_#")>
                                <cfif get_this_.GERCEK_TOPLAM eq 0 or get_this_.HEDEF_TOPLAM eq 0>
                                    <cfset tutar_payi_oran_ = 0>
                                <cfelse>
                                    <cfset tutar_payi_oran_ = wrk_round(get_this_.GERCEK_TOPLAM * 100 / get_this_.HEDEF_TOPLAM)>
                                </cfif>
                            <cfelse>
                                <cfset tutar_payi_hedef_ = 0>
                                <cfset tutar_payi_gercek_ = 0>
                                <cfset tutar_payi_oran_ = 0>
                            </cfif>
                            <cfif isdefined("hedef_#get_branches.branch_id#_#style_#")>
                                <cfset 'hedef_#get_branches.branch_id#_#style_#' = evaluate("hedef_#get_branches.branch_id#_#style_#") + tutar_payi_hedef_>
                                <cfset 'gercek_#get_branches.branch_id#_#style_#' = evaluate("gercek_#get_branches.branch_id#_#style_#") + tutar_payi_gercek_>
                            <cfelse>
                                <cfset 'hedef_#get_branches.branch_id#_#style_#' = tutar_payi_hedef_>
                                <cfset 'gercek_#get_branches.branch_id#_#style_#' = tutar_payi_gercek_>
                            </cfif>
                            <cfif isdefined("hedef_#get_branches.branch_id#")>
                                <cfset 'hedef_#get_branches.branch_id#' = evaluate("hedef_#get_branches.branch_id#") + tutar_payi_hedef_>
                                <cfset 'gercek_#get_branches.branch_id#' = evaluate("gercek_#get_branches.branch_id#") + tutar_payi_gercek_>
                            <cfelse>
                                <cfset 'hedef_#get_branches.branch_id#' = tutar_payi_hedef_>
                                <cfset 'gercek_#get_branches.branch_id#' = tutar_payi_gercek_>
                            </cfif>
                            <td>#tlformat(tutar_payi_hedef_)#</td>
                            <td>#tlformat(tutar_payi_gercek_)#</td>
                            <td>% #tutar_payi_oran_#</td>
                        </cfloop>
                    </tr>
                    </cfloop>
                    <tr>
                        <td class="txtbold">#TRAINING_STYLE# <cf_get_lang_main no ='80.Toplam'></td>
                        <cfloop query="get_branches">
                            <cfif isdefined("hedef_#get_branches.branch_id#_#style_#") and evaluate("hedef_#get_branches.branch_id#_#style_#") gt 0>
                                <td class="txtbold">#tlformat(evaluate("hedef_#get_branches.branch_id#_#style_#"))#</td>
                                <td class="txtbold">#tlformat(evaluate("gercek_#get_branches.branch_id#_#style_#"))#</td>
                                <td class="txtbold">% #wrk_round(evaluate("gercek_#get_branches.branch_id#_#style_#") * 100 / evaluate("hedef_#get_branches.branch_id#_#style_#"))#</td>
                            <cfelse>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                            </cfif>
                        </cfloop>
                    </tr>
                </cfoutput>
            </tbody>
            <tfoot>
                <cfoutput>
                    <tr class="t_foot_tr">
                        <td class="t_foot_td"><cf_get_lang_main no ='268.Genel Toplam'></td>
                        <cfloop query="get_branches">
                            <cfif isdefined("hedef_#get_branches.branch_id#") and evaluate("hedef_#get_branches.branch_id#") gt 0>
                                <td class="t_foot_td">#tlformat(evaluate("hedef_#get_branches.branch_id#"))#</td>
                                <td class="t_foot_td">#tlformat(evaluate("gercek_#get_branches.branch_id#"))#</td>
                                <td class="t_foot_td">% #wrk_round(evaluate("gercek_#get_branches.branch_id#") * 100 / evaluate("hedef_#get_branches.branch_id#"))#</td>
                            <cfelse>
                                <td class="t_foot_td">-</td>
                                <td class="t_foot_td">-</td>
                                <td class="t_foot_td">-</td>
                            </cfif>
                        </cfloop>
                    </tr>
                </cfoutput>
            </tfoot>
            <cfelse>
                <thead>
                    <tr>
                        <th></th>
                        <cfoutput>
                            <th><cf_get_lang_main no='1457.Planlanan'></th>
                            <th><cf_get_lang no ='1004.Gerçekleşen'></th>
                            <th width="65"><cf_get_lang_main no ='1044.Oran'></th>
                        </cfoutput>
                    </tr>
                </thead>
            <tbody>
                <tr>
                    <td colspan="16"><cfif isdefined("attributes.is_submitted")><cf_get_lang_main no='72.Kayıt yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz '>!</cfif></td>
                </tr>
            </tbody>
            </cfif>
    </cf_report_list>
</cfif>
</cfprocessingdirective>
<script type="text/javascript">
    function control(){
		if(document.puantaj_.is_excel.checked==false)
        {
            document.puantaj_.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.training_type_maliyet"
            return true;
        }
        else{
            document.puantaj_.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_training_type_maliyet</cfoutput>"
        }
	}
</script>