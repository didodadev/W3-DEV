<cfparam name="attributes.module_id_control" default="34">
<cfparam name="attributes.is_excel" default="">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#"> 
<cfparam name="attributes.sal_year" default="#session.ep.period_id#;#session.ep.period_year#">
<cfquery name="get_period_list" datasource="#dsn#"><!--- sonraki donem kontrol ediliyor --->
	SELECT 
		PERIOD_ID,
		PERIOD_YEAR 
	FROM 
		SETUP_PERIOD 
	WHERE 
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY 
		PERIOD_YEAR DESC
</cfquery>
<cfset dsn2_new = '#dsn#_#listlast(attributes.sal_year,';')#_#session.ep.company_id#'>

<cfif isdefined("attributes.is_submit")>
    <cfset training_gun_ = daysinmonth(CREATEDATE(listlast(attributes.sal_year,';'),attributes.SAL_MON,1))>
    <cfset training_start_ = CREATEODBCDATETIME(CREATEDATE(listlast(attributes.sal_year,';'),attributes.SAL_MON,1))>
    <cfset training_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(listlast(attributes.sal_year,';'),attributes.SAL_MON,training_gun_)))>
	<cfquery name="get_emp_branch" datasource="#dsn#">
		SELECT
			*
		FROM
			EMPLOYEE_POSITION_BRANCHES
		WHERE
			POSITION_CODE = #session.ep.position_code#
	</cfquery>
	<cfset emp_branch_list = listsort(valuelist(get_emp_branch.branch_id),"numeric","ASC",",")>
	
	<cfquery name="get_all_bodies" datasource="#dsn#">
		SELECT
			TC.CLASS_PLACE,
			TC.CLASS_ID,
			TC.CLASS_NAME,
			TC.START_DATE,
			TC.FINISH_DATE,
			TC.INT_OR_EXT,
			TC.TRAINING_STYLE AS STYLE,
			B.BRANCH_NAME,
			B.BRANCH_ID
		FROM 
			TRAINING_CLASS TC,
			TRAINING_CLASS_ATTENDER TCA,
			EMPLOYEE_POSITIONS EP,
			DEPARTMENT D,
			BRANCH B
		WHERE 
			TC.CLASS_ID = TCA.CLASS_ID AND
			TCA.EMP_ID = EP.EMPLOYEE_ID AND
			EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			D.BRANCH_ID = B.BRANCH_ID AND
			TCA.EMP_ID IS NOT NULL AND
			TCA.PAR_ID IS NULL AND 
			TCA.CON_ID IS NULL AND
			B.BRANCH_ID IN (#emp_branch_list#) AND
			EP.IS_MASTER = 1
		ORDER BY
			B.BRANCH_ID DESC
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
			TCCR.COST_DATE,
			TCCR.BRANCH_ID,
			EXPENSE_ITEMS.EXPENSE_ITEM_NAME
		FROM
			TRAINING_CLASS_COST TCC,
			TRAINING_CLASS_COST_ROWS TCCR,
			<cfif fusebox.use_period>#dsn2_new#<cfelse>#dsn_alias#</cfif>.EXPENSE_ITEMS EXPENSE_ITEMS
		WHERE
			TCCR.COST_DATE < #training_finish_# AND 
			TCCR.COST_DATE >= #training_start_# AND
			TCC.TRAINING_CLASS_COST_ID = TCCR.TRAINING_CLASS_COST_ID AND
			TCCR.EXPENSE_ITEM_ID = EXPENSE_ITEMS.EXPENSE_ITEM_ID
	</cfquery>
	<cfset train_list = listsort(valuelist(get_all_giders.CLASS_ID),"numeric")>
	
	<cfquery name="get_giders" dbtype="query">
		SELECT DISTINCT EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME FROM get_all_giders
	</cfquery>
	
	<cfset training_style_list=''>
	<cfoutput query="get_all_bodies">
		 <cfif not listfind(training_style_list,STYLE)>
			<cfset training_style_list=listappend(training_style_list,STYLE)>
		 </cfif>
	</cfoutput>
    
	<cfset training_style_list=listsort(training_style_list,"numeric")>
	<cfif len(training_style_list)>
		 <cfquery name="GET_TRAINING_STYLE" datasource="#dsn#">
			SELECT * FROM SETUP_TRAINING_STYLE WHERE TRAINING_STYLE_ID IN (#training_style_list#) ORDER BY TRAINING_STYLE_ID
		 </cfquery>
	</cfif>
	
	<cfoutput query="get_all_bodies">
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
	
	<cfquery name="get_trainings" dbtype="query">
		SELECT DISTINCT
			CLASS_PLACE,
			CLASS_NAME,
			CLASS_ID,
			START_DATE,
			FINISH_DATE,
			BRANCH_NAME,
			INT_OR_EXT,
			STYLE,
			BRANCH_ID
		FROM
			get_all_bodies
		WHERE
			<cfif listlen(train_list)>
				CLASS_ID IN (#train_list#)
			<cfelse>
				CLASS_ID = -1
			</cfif>
		ORDER BY
			BRANCH_ID DESC
    </cfquery>
    <cfparam name="attributes.page" default='1'>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_trainings.recordcount#'>  
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>
<cfform name="puantaj_" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
<input type="hidden" name="is_submit" id="is_submit" value="1">	
    <cf_report_list_search title="#getLang('report',1633)#">
        <cf_report_list_search_area>
        <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58724.Ay'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="sal_mon" id="sal_mon">
                                                <!--- <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option> --->
                                                <cfloop from="1" to="12" index="i">
                                                    <cfoutput>
                                                        <option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option>
                                                    </cfoutput>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </div>
                                </div>	
                                <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58455.Yıl'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="sal_year" id="sal_year">
                                            <!--- <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option> --->
                                            <cfoutput query="GET_PERIOD_LIST">
                                                <option value="#PERIOD_ID#;#PERIOD_YEAR#" <cfif listfirst(attributes.sal_year,';') eq PERIOD_ID>selected</cfif>>#PERIOD_YEAR#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                            </div>	
                           
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                            <cfelse>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                            </cfif>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
                                <input type="hidden" name="is_submit" id="is_submit" value="1">
                                <cf_wrk_report_search_button  search_function='control()' insert_info='#message#' button_type='1' is_excel="1">   
                        </div>
                    </div>
                </div>
            </div>
         </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset filename="training_maliyet#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="content-type" content="text/plain; charset=utf-16">
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_trainings.recordcount>
	<cfset type_ = 1>
	<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_submit")>
        <cf_report_list>
            <thead>
                <tr>	  	  
                    <th colspan="<cfoutput>#15+(get_giders.recordcount*6)#</cfoutput>" class="formbold" align="center"><cf_get_lang no ='1634.EĞİTİM HARCAMALARI'></th>
                </tr>
            </thead>
            <cfif get_giders.recordcount>
                <cfoutput query="get_trainings" group="branch_id" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfset sube_toplam_ = 0>
                    <cfset sube_toplam_katilimci_ = 0>
                    <cfset sube_katilimci_ = 0>
                    
                    <thead>
                        <tr>
                            <th><cf_get_lang_main no ='75.No'></th>
                            <th><cf_get_lang_main no='41.Şube'></th>
                            <th><cf_get_lang_main no ='7.Eğitim '><cf_get_lang_main no='1181.Tarihi'></th>
                            <th><cf_get_lang_main no='1312.Ay'></th>
                            <th><cf_get_lang no ='570.Tür'></th>
                            <th><cf_get_lang_main no ='7.Eğitim '></th>
                            <th><cf_get_lang_main no ='7.Eğitim '><cf_get_lang_main no ='1252.Yeri'> </th>
                            <th width="50"><cf_get_lang_main no ='80.toplam'><cf_get_lang_main no ='1953.Katılımcı'></th>
                            <th width="50"><cf_get_lang_main no ='1953.Katılımcı'></th>
                            <th nowrap width="1"></th>
                            <cfloop query="get_giders">
                                <th><cf_get_lang_main no='1266.Gider'></th>
                                <th><cf_get_lang_main no='846.Maliyet'><cf_get_lang_main no='1181.Tarihi'></th>
                                <th><cf_get_lang_main no ='670.Adet'></th>
                                <th><cf_get_lang_main no ='226.Birim Fiyat'></th>
                                <th><cf_get_lang_main no ='80.Toplam'></th>
                                <th nowrap width="1"></th>
                            </cfloop>
                            <th><cf_get_lang_main no ='435.Ödeme'></th>
                            <th><cf_get_lang no ='1164.Toplam Harcama'></th>
                            <th><cf_get_lang_main no='482.Statu'></th>
                        </tr>
                    </thead>
                    <cfset class_id_ = class_id>
                    <cfset branch_id_ = branch_id>
                    <cfset this_satir_toplam_ = 0>
                    <cfset class_id_oran_ = 1<!--- evaluate("branch_katil_#branch_id#_#class_id#") / evaluate("egitim_#class_id#") --->>
                    <cfset sube_toplam_katilimci_ = sube_toplam_katilimci_ + evaluate("egitim_#class_id#")>
                    <cfset sube_katilimci_ = sube_katilimci_ + evaluate("branch_katil_#branch_id#_#class_id#")>
                    <tbody>
                        <tr>
                            <td>#currentrow#</td>
                            <td>#branch_name#</td>
                            <td>#dateformat(start_date,dateformat_style)# - #dateformat(finish_date,dateformat_style)#</td>
                            <td>#listgetat(ay_list(),attributes.sal_mon)#</td>
                            <td>
                                #GET_TRAINING_STYLE.TRAINING_STYLE[listfind(training_style_list,STYLE,',')]#	
                            </td>
                            <td>#class_name#</td>
                            <td>#CLASS_PLACE#</td>
                            <td align="center">#evaluate("egitim_#class_id#")#</td>
                            <td align="center">#evaluate("branch_katil_#branch_id#_#class_id#")#</td>
                            <td nowrap width="1"></td>
                            <cfloop query="get_giders">
                                <cfquery name="get_this_#get_trainings.currentrow#" dbtype="query">
                                    SELECT 
                                        * 
                                    FROM 
                                        get_all_giders 
                                    WHERE
                                        CLASS_ID = #class_id_# AND
                                        EXPENSE_ITEM_ID = #get_giders.expense_item_id# AND
                                        BRANCH_ID = #branch_id_#
                                </cfquery>
                                <td>#get_giders.expense_item_name#</td>
                                <cfif evaluate("get_this_#get_trainings.currentrow#.recordcount")>
                                    <td>#dateformat(evaluate("get_this_#get_trainings.currentrow#.cost_date"),dateformat_style)#</td>
                                    <cfset this_satir_toplam_ = this_satir_toplam_ + (evaluate("get_this_#get_trainings.currentrow#.gerceklesen")*class_id_oran_)>
                                    <cfset sube_toplam_ = sube_toplam_ + (evaluate("get_this_#get_trainings.currentrow#.gerceklesen")*class_id_oran_)>
                                    <td>#evaluate("get_this_#get_trainings.currentrow#.gerceklesen_miktar")*class_id_oran_#</td>
                                    <td>#tlformat(evaluate("get_this_#get_trainings.currentrow#.gerceklesen_birim"))#</td>
                                    <td>#tlformat(evaluate("get_this_#get_trainings.currentrow#.gerceklesen")*class_id_oran_)#</td>
                                    <cfif isdefined("adet_#branch_id_#_#get_giders.EXPENSE_ITEM_ID#")>
                                        <cfset 'adet_#branch_id_#_#get_giders.EXPENSE_ITEM_ID#' = evaluate("adet_#branch_id_#_#get_giders.EXPENSE_ITEM_ID#") + (evaluate("get_this_#get_trainings.currentrow#.gerceklesen_miktar")*class_id_oran_)>
                                        <cfset 'birim_#branch_id_#_#get_giders.EXPENSE_ITEM_ID#' = evaluate("birim_#branch_id_#_#get_giders.EXPENSE_ITEM_ID#") + (evaluate("get_this_#get_trainings.currentrow#.gerceklesen_birim")*class_id_oran_)<!--- get_this_.gerceklesen_birim --->>
                                        <cfset 'gercek_#branch_id_#_#get_giders.EXPENSE_ITEM_ID#' = evaluate("gercek_#branch_id_#_#get_giders.EXPENSE_ITEM_ID#") + (evaluate("get_this_#get_trainings.currentrow#.gerceklesen")*class_id_oran_)>
                                    <cfelse>
                                        <cfset 'adet_#branch_id_#_#get_giders.EXPENSE_ITEM_ID#' = (evaluate("get_this_#get_trainings.currentrow#.gerceklesen_miktar")*class_id_oran_)>
                                        <cfset 'birim_#branch_id_#_#get_giders.EXPENSE_ITEM_ID#' = evaluate("get_this_#get_trainings.currentrow#.gerceklesen_birim")>
                                        <cfset 'gercek_#branch_id_#_#get_giders.EXPENSE_ITEM_ID#' = evaluate("get_this_#get_trainings.currentrow#.gerceklesen")*class_id_oran_>
                                    </cfif>
                                <cfelse>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                </cfif>
                                <td nowrap width="1"></td>
                            </cfloop>
                            <td>-</td>
                            <td>#tlformat(this_satir_toplam_)#</td>
                            <td>-</td>
                        </tr>
                        <tr class="total">
                            <td colspan="7"><cf_get_lang_main no='41.Şube'><cf_get_lang no ='1254.Toplamları'></td>
                            <td align="center">#sube_toplam_katilimci_#</td>
                            <td align="center">#sube_katilimci_#</td>
                            <td nowrap width="1"></td>
                            <cfloop query="get_giders">
                                <td></td>
                                <cfif isdefined("adet_#branch_id_#_#get_giders.EXPENSE_ITEM_ID#")>
                                    <td></td>
                                    <td>#evaluate("adet_#branch_id_#_#get_giders.EXPENSE_ITEM_ID#")#</td>
                                    <td>#tlformat(evaluate("birim_#branch_id_#_#get_giders.EXPENSE_ITEM_ID#"))#</td>
                                    <td>#tlformat(evaluate("gercek_#branch_id_#_#get_giders.EXPENSE_ITEM_ID#"))#</td>
                                <cfelse>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                </cfif>
                                <td nowrap width="1"></td>
                            </cfloop>
                            <td>-</td>
                            <td>#tlformat(sube_toplam_)#</td>
                            <td>-</td>
                        </tr>
                </tbody>
                </cfoutput>
               <cfelse>
                <thead>
                    <tr>
                        <th><cf_get_lang_main no ='75.No'></th>
                        <th><cf_get_lang_main no='41.Şube'></th>
                        <th><cf_get_lang_main no ='7.Eğitim '><cf_get_lang_main no='1181.Tarihi'></th>
                        <th><cf_get_lang_main no='1312.Ay'></th>
                        <th><cf_get_lang no ='570.Tür'></th>
                        <th><cf_get_lang_main no ='7.Eğitim '></th>
                        <th><cf_get_lang_main no ='7.Eğitim '><cf_get_lang_main no ='1252.Yeri'> </th>
                        <th width="50"><cf_get_lang_main no ='80.toplam'><cf_get_lang_main no ='1953.Katılımcı'></th>
                        <th width="50"><cf_get_lang_main no ='1953.Katılımcı'></th>
                        <th nowrap width="1"></th>
                        <cfloop query="get_giders">
                            <th><cf_get_lang_main no='1266.Gider'></th>
                            <th><cf_get_lang_main no='846.Maliyet'><cf_get_lang_main no='1181.Tarihi'></th>
                            <th><cf_get_lang_main no ='670.Adet'></th>
                            <th><cf_get_lang_main no ='226.Birim Fiyat'></th>
                            <th><cf_get_lang_main no ='80.Toplam'></th>
                            <th nowrap width="1"></th>
                        </cfloop>
                        <th><cf_get_lang_main no ='435.Ödeme'></th>
                        <th><cf_get_lang no ='1164.Toplam Harcama'></th>
                        <th><cf_get_lang_main no='482.Statu'></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="13"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '></cfif></td>
                    </tr>
                </tbody>
               </cfif>
        </cf_report_list>
</cfif>

<cfset adres = "">
<cfif isdefined("attributes.is_submit") and attributes.totalrecords gt attributes.maxrows>
    <cfset adres = "#attributes.fuseaction#&is_submit=1">
    <cfif isdefined("attributes.sal_mon") and len(attributes.sal_mon)>
		<cfset adres = "#adres#&sal_mon=#attributes.sal_mon#">
    </cfif>
    <cfif isdefined("attributes.sal_year") and len(attributes.sal_year)>
		<cfset adres = "#adres#&sal_year=#attributes.sal_year#">
    </cfif>
    <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
        <tr>
            <td><cf_pages page="#attributes.page#" 
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#adres#">
            </td>
        	<td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
        </tr>
    </table>
</cfif>
<script>
    function control()
    {
        if(document.puantaj_.is_excel.checked==false)
        {
            document.puantaj_.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.training_maliyet"
            return true;
        }
        else{
            
            document.puantaj_.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_training_maliyet</cfoutput>"
        }
        
    }
</script>