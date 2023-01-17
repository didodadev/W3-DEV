<cfparam name="attributes.sal_mon" default="#dateformat(now(),'MM')#">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.position_cat_type" default="0">
<cfquery name="get_branches" datasource="#DSN#">
	SELECT DISTINCT
		RELATED_COMPANY
	FROM 
		BRANCH
	WHERE 
		BRANCH_ID IS NOT NULL
	<cfif not session.ep.ehesap>
		AND
		BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							POSITION_CODE = #session.ep.position_code#
					)
	</cfif>
	ORDER BY
		RELATED_COMPANY
</cfquery>
<cfsavecontent variable="message"> <cf_get_lang dictionary_id="56257.Brüt"> </cfsavecontent>
<cfsavecontent variable="message1"><cf_get_lang dictionary_id="56550.Norm Kadro Dağılımı"></cfsavecontent>
<cf_big_list_search title="#message1# #message#">
	<cf_big_list_search_area>
        <cfform name="norm_position" action="#request.self#?fuseaction=hr.list_norm_position_dispersal_show" method="post">
        <input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
        <table style="text-align:right;">
            <tr>
                <td><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></td>
                <td>
                    <select name="position_cat_type" id="position_cat_type">
                        <option value=""><cf_get_lang dictionary_id ='58081.Hepsi'></option>
                        <option value="1" <cfif isdefined("attributes.position_cat_type") and attributes.position_cat_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='58573.Merkez'></option>
                        <option value="0" <cfif isdefined("attributes.position_cat_type") and attributes.position_cat_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='57453.Şube'></option>
                    </select>
                </td>
                <td>
                    <select name="related_company" id="related_company">
                        <option value=""><cf_get_lang dictionary_id ='56392.İlgili Şirket'></option>
                        <cfoutput query="get_branches">
                            <option value="#related_company#" <cfif isdefined("attributes.related_company") and attributes.related_company is '#related_company#'>selected</cfif>>#related_company#</option>
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <select name="sal_mon" id="sal_mon">
                        <cfloop from="1" to="12" index="i">
                            <cfoutput><option value="#i#" <cfif attributes.sal_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option></cfoutput><!---  --->
                        </cfloop>
                    </select>
                </td>
                <td><input name="sal_year" id="sal_year" type="text" value="<cfoutput>#attributes.sal_year#</cfoutput>" readonly style="width:50px;"></td>
                <td><input type="checkbox" name="is_detail_report" id="is_detail_report" value="1" <cfif isdefined("attributes.is_detail_report")>checked</cfif>> <cf_get_lang dictionary_id='56859.Detaylı Dök'></td>
                <td><cf_wrk_search_button search_function='control()'></td>
            </tr>
        </table>
        </cfform>
    </cf_big_list_search_area>
</cf_big_list_search>
<cfif isdefined("attributes.is_form_submit")>
	<cfquery name="get_all_relateds" datasource="#dsn#">
		SELECT DISTINCT
			RELATED_COMPANY
		FROM 
			BRANCH
		WHERE 
		<cfif isdefined("attributes.is_detail_report")>
			RELATED_COMPANY = '#attributes.related_company#' AND
		</cfif>
			BRANCH_ID IS NOT NULL
		<cfif not session.ep.ehesap>
			AND BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							POSITION_CODE = #session.ep.position_code#
					)
		</cfif>
		ORDER BY
			RELATED_COMPANY
	</cfquery>
	
	<cfloop query="get_all_relateds">
		<cfset this_related_ = RELATED_COMPANY>
		<cfquery name="GET_DEPARTMENTS" datasource="#DSN#">
			SELECT DISTINCT
				D.DEPARTMENT_HEAD
			FROM 
				DEPARTMENT D,
				BRANCH B
			WHERE 
				B.RELATED_COMPANY = '#attributes.RELATED_COMPANY#' AND
				D.BRANCH_ID = B.BRANCH_ID
			ORDER BY
				D.DEPARTMENT_HEAD
		</cfquery>
		
		<cfset puantaj_gun_ = daysinmonth(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
		<cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
		<cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(attributes.sal_year,attributes.SAL_MON,puantaj_gun_)))>
		
		<cfquery name="GET_BRANCH_DEPT_POSITIONS_1" datasource="#DSN#">
			SELECT DISTINCT
				D.DEPARTMENT_ID,
				D.DEPARTMENT_HEAD,
				EP.POSITION_CAT_ID,
				EP.POSITION_ID,
				EP.EMPLOYEE_ID
			FROM 
				DEPARTMENT D,
				EMPLOYEE_POSITIONS_HISTORY EP,
				BRANCH B 
			WHERE		
				EP.EMPLOYEE_ID IN (SELECT EIO.EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID AND D.BRANCH_ID = EIO.BRANCH_ID AND (EIO.FINISH_DATE IS NULL OR (EIO.FINISH_DATE >= #puantaj_start_# AND EIO.FINISH_DATE >= #puantaj_finish_#) )) AND
				EP.EMPLOYEE_ID > 0 AND
				EP.POSITION_STATUS = 1 AND
				D.DEPARTMENT_STATUS = 1 AND
				D.IS_STORE <> 1 AND
				EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
				D.BRANCH_ID = B.BRANCH_ID AND
				B.RELATED_COMPANY = '#this_related_#' AND
				((EP.FINISH_DATE >= #puantaj_finish_#) OR EP.FINISH_DATE IS NULL OR EP.FINISH_DATE = ''	)
			ORDER BY
				EP.POSITION_ID DESC
		</cfquery>
		
		<cfquery name="get_branch_dept_positions" dbtype="query">
			SELECT
				DEPARTMENT_HEAD,
				POSITION_CAT_ID,
				COUNT(POSITION_ID) AS CALISAN_SAYISI
			FROM
				GET_BRANCH_DEPT_POSITIONS_1
			GROUP BY
				DEPARTMENT_HEAD,
				POSITION_CAT_ID
		</cfquery>
		
		
		<cfquery name="GET_OLD_VALUES" datasource="#DSN#">
			SELECT 
				<cfloop from="1" to="12" index="i">
					SUM(ENP.EMPLOYEE_COUNT#i#) AS THIS_EMPLOYEE_COUNT#i#,
				</cfloop>
				ENP.POSITION_CAT_ID
			FROM 
				EMPLOYEE_NORM_POSITIONS ENP,
				BRANCH B
			WHERE 
				B.RELATED_COMPANY = '#this_related_#' AND
				ENP.BRANCH_ID = B.BRANCH_ID AND
				ENP.NORM_YEAR = #attributes.sal_year#
			GROUP BY
				ENP.POSITION_CAT_ID
		</cfquery>
		
		<cfloop from="1" to="12" index="i">
			<cfset 'norm_position_list_#i#' = ''>
			<cfset 'norm_count_list_#i#' = ''>
		</cfloop>
		<cfoutput query="get_old_values">
			<cfloop from="1" to="12" index="i">
				<cfif len(evaluate("THIS_EMPLOYEE_COUNT#i#"))>
					<cfset 'deger_#i#_' = evaluate("THIS_EMPLOYEE_COUNT#i#")>
				<cfelse>
					<cfset 'deger_#i#_' = 0>
				</cfif>
				<cfset 'norm_position_list_#i#' = listappend(evaluate("norm_position_list_#i#"),POSITION_CAT_ID)> 
				<cfset 'norm_count_list_#i#' = listappend(evaluate("norm_count_list_#i#"),evaluate("deger_#i#_"))>
			</cfloop>
		</cfoutput>
		<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
			SELECT 
				SPC.*,
				SDN.DEPARTMENT_NAME
			FROM 
				SETUP_POSITION_CAT SPC,
				SETUP_POSITION_CAT_DEPARTMENTS SPCD,
				SETUP_DEPARTMENT_NAME SDN
			WHERE
				SPC.POSITION_CAT_ID = SPCD.POSITION_CAT_ID AND
				SPCD.DEPARTMENT_NAME_ID = SDN.DEPARTMENT_NAME_ID AND
				<cfif isdefined("attributes.position_cat_type") and attributes.position_cat_type eq 0>
					SPC.POSITION_CAT_TYPE = 1 AND
				</cfif>
				<cfif isdefined("attributes.position_cat_type") and attributes.position_cat_type eq 1>
					SPC.POSITION_CAT_UPPER_TYPE = 1 AND
				</cfif>
				SPC.POSITION_CAT_STATUS = 1 AND
				SPC.POSITION_CAT_ID IS NOT NULL

			UNION

			SELECT 
				*,
				' ' AS DEPARTMENT_NAME
			FROM 
				SETUP_POSITION_CAT
			WHERE
				<cfif isdefined("attributes.position_cat_type") and attributes.position_cat_type eq 0>
					POSITION_CAT_TYPE = 1 AND
				</cfif>
				<cfif isdefined("attributes.position_cat_type") and attributes.position_cat_type eq 1>
					POSITION_CAT_UPPER_TYPE = 1 AND
				</cfif>
				POSITION_CAT_ID NOT IN (SELECT POSITION_CAT_ID FROM SETUP_POSITION_CAT_DEPARTMENTS) AND
				POSITION_CAT_STATUS = 1 AND
				POSITION_CAT_ID IS NOT NULL
			ORDER BY
				DEPARTMENT_NAME
		</cfquery>
		
		<cfset position_cat_id_list = ''>
		<cfset calisan_list = ''>
		<cfoutput query="get_branch_dept_positions">
			<cfset position_cat_id_list = listappend(position_cat_id_list,'#POSITION_CAT_ID#-#DEPARTMENT_HEAD#')>
			<cfset calisan_list = listappend(calisan_list,CALISAN_SAYISI)>
		</cfoutput>
		
		<cfquery name="GET_AVERAGE" datasource="#DSN#">
			SELECT * FROM EMPLOYEE_NORM_POSITIONS_AVERAGE WHERE RELATED_COMPANY = '#this_related_#' AND NORM_YEAR = #attributes.sal_year# AND NORM_MONTH = #attributes.sal_mon#
		</cfquery>
		
		<cfquery name="get_average2" datasource="#DSN#">
			SELECT 
				SUM(REAL_SALARY) AS TOTAL_REAL_SALARY,
				SUM(REAL_COST) AS TOTAL_REAL_COST
			FROM 
				EMPLOYEE_NORM_POSITIONS_AVERAGE ENPA,
				DEPARTMENT D,
				BRANCH B
			WHERE 
				ENPA.DEPARTMENT_ID = D.DEPARTMENT_ID AND
				D.BRANCH_ID = B.BRANCH_ID AND
				B.RELATED_COMPANY = '#this_related_#' AND
				ENPA.NORM_YEAR = #attributes.sal_year# AND 
				ENPA.NORM_MONTH = #attributes.sal_mon#
		</cfquery>
		
		<cfquery name="GET_AVERAGES" datasource="#DSN#">
			SELECT 
				ENPA.REAL_SALARY,
				ENPA.REAL_COST,
				D.DEPARTMENT_HEAD
			FROM 
				EMPLOYEE_NORM_POSITIONS_AVERAGE ENPA,
				DEPARTMENT D,
				BRANCH B
			WHERE 
				ENPA.DEPARTMENT_ID = D.DEPARTMENT_ID AND
				D.BRANCH_ID = B.BRANCH_ID AND
				B.RELATED_COMPANY = '#this_related_#' AND
				ENPA.NORM_YEAR = #attributes.sal_year# AND 
				ENPA.NORM_MONTH = #attributes.sal_mon#
		</cfquery>
		<cfset general_average_salary = 0>
		<cfif get_average.recordcount and len(get_average.average_salary)>
			<cfset general_average_salary = get_average.average_salary>
		</cfif>
			<table cellspacing="1" cellpadding="2" width="99%" border="0" align="center" class="color-border">
				<tr id="branch_info" class="color-list">
					<td colspan="<cfoutput>#21 + get_departments.recordcount#</cfoutput>">
						<cfoutput>
						<table>
							<tr>
								<td width="125" class="txtboldblue"><cf_get_lang dictionary_id='56861.Toplam Ciro'></td>
								<td>: <cfif get_average.recordcount and len(get_average.average_salary)>#tlformat(get_average.average_salary,2)# #get_average.money#<cfelse><cf_get_lang dictionary_id='56862.Belirtilmemiş'></cfif></td>
							</tr>
							<tr>
								<td class="txtboldblue"><cf_get_lang dictionary_id='56863.Toplam Brüt Maaş'></td>
								<td>: <cfif get_average2.recordcount and len(get_average2.TOTAL_REAL_SALARY)>#tlformat(get_average2.TOTAL_REAL_SALARY,2)# TL<cfelse><cf_get_lang dictionary_id='56862.Belirtilmemiş'></cfif></td>
							</tr>
							<tr>
								<td class="txtboldblue"><cf_get_lang dictionary_id='56864.Toplam Maliyet'></td>
								<td>: <cfif get_average2.recordcount and len(get_average2.TOTAL_REAL_COST)>#tlformat(get_average2.TOTAL_REAL_COST,2)# TL<cfelse><cf_get_lang dictionary_id='56862.Belirtilmemiş'></cfif></td>
							</tr>
						</table>
						</cfoutput>
					</td>
				</tr>
				<tr class="color-header" height="22" style="text-align:left;">
					<td class="form-title" width="20%"><cf_get_lang dictionary_id ='1466.Norm Kadro Bilgileri'> : <a href="javascript://" onClick="gizle_goster(branch_info);" class="form-title"><cfoutput>#this_related_#</cfoutput></a></td>
					<td class="form-title" style="writing-mode:tb-rl;direction:rtl; width:140px;" style="text-align:right;"><span style="float:left; height:100px;"><cf_get_lang dictionary_id='30010.Ciro'></span></td>
					<td class="form-title" style="writing-mode:tb-rl;direction:rtl; width:140px;" style="text-align:right;"><span style="float:left; height:100px;"><cf_get_lang dictionary_id='56864.Toplam Maliyet'></span></td>
					<td class="form-title" style="writing-mode:tb-rl;direction:rtl; width:140px;" style="text-align:right;"><span style="float:left; height:100px;"><cf_get_lang dictionary_id='58456.Oran'></span></td>
					<td class="form-title" style="writing-mode:tb-rl;direction:rtl; width:100px;" style="text-align:right;"><span style="float:left; height:100px;"><cf_get_lang dictionary_id='58456.Oran'> 2</span></td>
					<td class="form-title" style="writing-mode:tb-rl;direction:rtl; width:100px;" style="text-align:right;"><span style="float:left; height:100px;"><cf_get_lang dictionary_id='58583.Fark'></span></td>
					<cfloop from="1" to="12" index="i">
						<td class="form-title" style="writing-mode:tb-rl;direction:rtl; width:30px;" style="text-align:right;"><span style="float:left; height:100px;"><cfoutput>#listgetat(ay_list(),i)#</cfoutput></span></td>
					</cfloop>
					<td class="color-row"></td>
					<cfoutput query="get_departments"><td class="form-title" style="writing-mode:tb-rl;direction:rtl; width:30px;" style="text-align:right;"><span style="float:left; height:100px;">#department_head#</span></td></cfoutput>
					<td class="form-title" width="20" align="center">T</td>
					<td class="form-title" width="20" align="center" nowrap>F</td>
				</tr>
				<tr class="color-list">
					<td class="txtbold">&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<cfloop from="1" to="12" index="i">
						<td class="txtbold" width="25" align="center"><cfoutput>#i#</cfoutput></td>
					</cfloop>
					<td class="color-header"></td>
					<cfoutput query="get_departments">
					<td class="txtbold" width="25" align="center">G</td>
					</cfoutput>
					<td class="txtbold" width="25" align="center">T</td>
					<td width="25" style="text-align:right;" nowrap bgcolor="red" class="fomr-title" style="text-align:right;">F</td>
				</tr>
				<cfset genel_toplam = 0>
				<cfset fark_toplam = 0>
				<cfloop from="1" to="12" index="i">
					<cfset 'ongorulen_genel_ay_toplam_#i#' = 0>
				</cfloop>
				<cfset count_dept = 0>
				<cfoutput query="GET_POSITION_CATS" group="DEPARTMENT_NAME">
				<cfset count_dept = count_dept + 1>
					<cfif isdefined("attributes.is_detail_report")>
					<tr height="20" class="color-list">
						<td colspan="#23+get_departments.recordcount#" class="txtbold">#DEPARTMENT_NAME#</td>
					</tr>
					</cfif>
					<cfset ara_toplam = 0>
					<cfset ara_fark_toplam = 0>
					<cfset count_ = 0>
					<cfloop query="get_departments">
						<cfset count_ = count_ + 1>
						<cfset 'ara_dept_toplam_#count_#' = 0>
					</cfloop>
					
					<cfloop from="1" to="12" index="i">
						<cfset 'ongorulen_ay_toplam_#i#' = 0>
					</cfloop>				
					
					<cfoutput>
					<cfset this_cat_id_ = POSITION_CAT_ID>
					<cfset toplam_ = 0>
					<cfif isdefined("attributes.is_detail_report")><tr height="20" onMouseOver="this.bgColor='#colorlist#';" onMouseOut="this.bgColor='#colorrow#';" bgcolor="#colorrow#" style="text-align:right;"></cfif>
						<cfif isdefined("attributes.is_detail_report")><td align="left" colspan="6">#position_cat#</td></cfif>
						<cfloop from="1" to="12" index="i">
							<cfset a = evaluate("norm_position_list_#i#")>
							<cfset b = evaluate("norm_count_list_#i#")>
							<cfif listfindnocase(a,this_cat_id_)>
								<cfset ongorulen_ = listgetat(b,listfindnocase(a,this_cat_id_))>
							<cfelse>
								<cfset ongorulen_ = 0>
							</cfif>
							<cfif isdefined("attributes.is_detail_report")><td width="25" nowrap <cfif i eq attributes.sal_mon>class="color-header"</cfif>>#ongorulen_#</td></cfif>
							<cfif i eq attributes.sal_mon>
								<cfset ongorulen_asil_ = ongorulen_>
							</cfif>
							<cfset 'ongorulen_ay_toplam_#i#' = evaluate('ongorulen_ay_toplam_#i#') + ongorulen_>
							<cfset 'ongorulen_genel_ay_toplam_#i#' = evaluate('ongorulen_genel_ay_toplam_#i#') + ongorulen_>
						</cfloop>
						<cfif isdefined("attributes.is_detail_report")><td class="color-header"></td></cfif>
						<cfset count_ = 0>
						<cfloop query="get_departments">
						<cfset count_ = count_ + 1>
							<cfif listlen(position_cat_id_list) and listfindnocase(position_cat_id_list,'#this_cat_id_#-#get_departments.DEPARTMENT_HEAD#')>
								<cfset sira_ = listfindnocase(position_cat_id_list,'#this_cat_id_#-#get_departments.DEPARTMENT_HEAD#')>
								<cfset gerceklesen_ = listgetat(calisan_list,sira_)>
							<cfelse>
								<cfset gerceklesen_ = 0>
							</cfif>
							<cfset toplam_ = toplam_ + gerceklesen_>
							<cfif isdefined("dept_toplam_#count_#")>
								<cfset 'dept_toplam_#count_#' = evaluate("dept_toplam_#count_#") + gerceklesen_>
							<cfelse>
								<cfset 'dept_toplam_#count_#' = gerceklesen_>
							</cfif>
							<cfset 'ara_dept_toplam_#count_#' = evaluate("ara_dept_toplam_#count_#") + gerceklesen_>
							<cfif isdefined("attributes.is_detail_report")>
							<td title="#get_departments.department_head# - Gerçekleşen" width="25" nowrap>
							<cfif gerceklesen_ gt 0>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_norm_position_dispersal_positions&position_cat_id=#this_cat_id_#&sal_year=#attributes.sal_year#&sal_mon=#attributes.sal_mon#&RELATED_COMPANY=#this_related_#','list');" class="tableyazi">#gerceklesen_#</a>
							<cfelse>
								#gerceklesen_#
							</cfif>						
							</td>
							</cfif>
						</cfloop>
						<cfset fark_toplam = fark_toplam + (ongorulen_asil_ - toplam_)>
						<cfset genel_toplam = genel_toplam + toplam_>
						<cfset ara_fark_toplam = ara_fark_toplam + (ongorulen_asil_ - toplam_)>
						<cfset ara_toplam = ara_toplam + toplam_>
					<cfif isdefined("attributes.is_detail_report")>
						<td title="#position_cat# - Toplam" class="color-header">#toplam_#</td>
						<td title="#position_cat# - Fark" bgcolor="red" class="form-title" nowrap>#ongorulen_asil_ - toplam_#</td>
					</tr>
					</cfif>
					</cfoutput>
					<cfquery name="get_average" datasource="#dsn#" maxrows="1">
						SELECT 
							AVERAGE_RATE_#attributes.sal_mon# AS THIS_AVERAGE
						FROM
							EMPLOYEE_NORM_POSITIONS_DEPT_RATE ER,
							DEPARTMENT D,
							BRANCH B
						WHERE
							ER.AVERAGE_RATE_YEAR = #attributes.sal_year# AND
							D.DEPARTMENT_HEAD = '#DEPARTMENT_NAME#' AND
							ER.DEPARTMENT_ID = D.DEPARTMENT_ID AND
							D.BRANCH_ID = B.BRANCH_ID AND
							B.RELATED_COMPANY = '#this_related_#'
					</cfquery>
					<tr height="20" class="color-list">
						<td align="left"><cfif isdefined("attributes.is_detail_report")><font color="red">#DEPARTMENT_NAME# <cf_get_lang_main no='1247.Toplamı'></font><cfelse><strong>#DEPARTMENT_NAME#</strong></cfif></td>
						<td style="text-align:right;">#tlformat(general_average_salary)#</td>
						<cfquery name="get_av_" dbtype="query">
							SELECT * FROM get_averages WHERE DEPARTMENT_HEAD = '#DEPARTMENT_NAME#'
						</cfquery>
						<cfif get_av_.recordcount>
							<cfset this_total_ = get_av_.REAL_COST>
						<cfelse>
							<cfset this_total_ = 0>
						</cfif>
						<td style="text-align:right;">#tlformat(this_total_)#</td>
						<td style="text-align:right;">
							<cfif this_total_ gt 0 and general_average_salary gt 0>
								<cfset oran_ = this_total_ / general_average_salary>
								#wrk_round(oran_,6)#
							<cfelse>
								-
							</cfif>
						</td>
						<td style="text-align:right;">
							<cfif get_average.recordcount>
								#wrk_round(get_average.THIS_AVERAGE,6)#
							<cfelse>
								-
							</cfif>
						</td>
						<td style="text-align:right;">
							<cfif get_average.recordcount and this_total_ gt 0 and general_average_salary gt 0>
								#wrk_round(get_average.THIS_AVERAGE-oran_,6)#
							<cfelse>
							-
							</cfif>
						</td>
						<cfloop from="1" to="12" index="i">
							<td style="text-align:right;" width="25" nowrap <cfif i eq attributes.sal_mon>class="color-header"</cfif>>#evaluate('ongorulen_ay_toplam_#i#')#</td>
						</cfloop>
						<td style="text-align:right;" class="color-header"></td>
						<cfset count_ = 0>
						<cfloop query="get_departments">
							<cfset count_ = count_ + 1>
							<td style="text-align:right;">#evaluate('ara_dept_toplam_#count_#')#</td>
						</cfloop>
						<td style="text-align:right;" title="#department_name# - Toplam" class="color-header">#ara_toplam#</td>
						<td style="text-align:right;" title="#department_name# - Fark" bgcolor="red" class="form-title" nowrap>#ara_fark_toplam#</td>
					</tr>
					<cfif isdefined("attributes.is_detail_report")>
					<tr height="1">
						<td colspan="#21+get_departments.recordcount#"></td>
					</tr>
					</cfif>
				</cfoutput>
				<cfoutput>
					<tr class="color-list">
					<td class="txtbold" style="text-align:right;">&nbsp;</td>
					<td style="text-align:right;">&nbsp;</td>
					<td style="text-align:right;">&nbsp;</td>
					<td style="text-align:right;">&nbsp;</td>
					<td style="text-align:right;">&nbsp;</td>
					<td style="text-align:right;">&nbsp;</td>
					<cfloop from="1" to="12" index="i">
							<td style="text-align:right;" width="25" nowrap <cfif i eq attributes.sal_mon>class="color-header"</cfif>>#evaluate('ongorulen_genel_ay_toplam_#i#')#</td>
						</cfloop>
					<td style="text-align:right;" class="color-header"></td>
					<cfset count_ = 0>
					<cfif get_departments.recordcount>
						<cfloop query="get_departments">
							<cfset count_ = count_ + 1>
							<cfif isdefined("dept_toplam_#currentrow#")>
								<td style="text-align:right;" class="txtbold" width="25">#evaluate('dept_toplam_#currentrow#')#</td>
							<cfelse>
								<td style="text-align:right;" class="txtbold" width="25">0</td>
							</cfif>
						</cfloop>
					</cfif>
					<td style="text-align:right;" class="txtbold" width="25">#genel_toplam#</td>
					<td style="text-align:right;" class="form-title" width="25" bgcolor="red" nowrap>#fark_toplam#</td>
				</tr>
				</cfoutput>
			</table><br />
	</cfloop>
</cfif>
<script type="text/javascript">
function control()
{	
	if (document.norm_position.related_company.value == '')
	{
		alert("<cf_get_lang dictionary_id='56860.İlgili Şirket Seçiniz'>!");
		return false;
	}
	return true;
}
</script>
