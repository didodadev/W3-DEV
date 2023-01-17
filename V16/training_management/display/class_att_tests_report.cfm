<cfset xfa.fuseac = "training_management.popup_class_att_tests_report">
<cfset url_str = "">
<cfinclude template="../query/get_class.cfm">
<cfparam name="attributes.keyword_2" default="">
<cfquery name="get_class_results" datasource="#dsn#">
	SELECT
		TC.CLASS_ID,
		TCR.EMP_ID,
		TCR.PAR_ID,
		TCR.CON_ID,
		TC.CLASS_NAME,
		EMP.EMPLOYEE_NAME+ ' '+EMP.EMPLOYEE_SURNAME AS ADSOYAD,
		TCR.PRETEST_POINT,
		TCR.FINALTEST_POINT,
        TCR.THIRDTEST_POINT,
		D.DEPARTMENT_HEAD,
		B.BRANCH_NAME,
		COMP.NICK_NAME AS NICK_NAME
	FROM
		TRAINING_CLASS TC,
		TRAINING_CLASS_RESULTS TCR,
		EMPLOYEES EMP,
		EMPLOYEE_POSITIONS EPOS,
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY COMP
	WHERE
		TC.CLASS_ID = TCR.CLASS_ID AND 
		TCR.EMP_ID = EMP.EMPLOYEE_ID AND
		EMP.EMPLOYEE_ID = EPOS.EMPLOYEE_ID AND
		EPOS.DEPARTMENT_ID = D.DEPARTMENT_ID AND 
		EPOS.IS_MASTER = 1 AND
		D.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = COMP.COMP_ID AND
		B.BRANCH_ID IN (
                        SELECT
                            BRANCH_ID
                        FROM
                            EMPLOYEE_POSITION_BRANCHES
                        WHERE
                            POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">	
                        ) AND
		TCR.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
		<cfif isDefined("attributes.keyword_2") and len(attributes.keyword_2)>
		AND (
			EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME LIKE '%#attributes.keyword_2#%'
			)
		</cfif>
	UNION
	SELECT
		TC.CLASS_ID,
		TCR.EMP_ID,
		TCR.PAR_ID,
		TCR.CON_ID,
		TC.CLASS_NAME,
		COMP.COMPANY_PARTNER_NAME+ ' '+COMP.COMPANY_PARTNER_SURNAME AS ADSOYAD,
		TCR.PRETEST_POINT,
		TCR.FINALTEST_POINT,
        TCR.THIRDTEST_POINT,
		' ' AS DEPARTMENT_HEAD,
		'' AS BRANCH_NAME,
		COM.NICKNAME AS NICK_NAME
	FROM
		TRAINING_CLASS AS TC,
		TRAINING_CLASS_RESULTS AS TCR,
		COMPANY AS COM,
		COMPANY_PARTNER AS COMP
	WHERE
		TC.CLASS_ID = TCR.CLASS_ID AND 
		TCR.PAR_ID = COMP.PARTNER_ID AND
		COMP.COMPANY_ID = COM.COMPANY_ID AND
		TCR.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
		<cfif isDefined("attributes.keyword_2") and len(attributes.keyword_2)>
			AND (
			
				COMP.COMPANY_PARTNER_NAME+' '+COMP.COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword_2#%' 
				
				)
			</cfif>
	UNION
	SELECT
		TC.CLASS_ID,
		TCR.EMP_ID,
		TCR.PAR_ID,
		TCR.CON_ID,
		TC.CLASS_NAME,
		CONS.CONSUMER_NAME+ ' '+CONS.CONSUMER_SURNAME AS ADSOYAD,
		TCR.PRETEST_POINT,
		TCR.FINALTEST_POINT,
        TCR.THIRDTEST_POINT,
		' ' AS DEPARTMENT_HEAD,
		'' AS BRANCH_NAME,
		CONS.COMPANY AS NICK_NAME
	FROM
		TRAINING_CLASS AS TC,
		TRAINING_CLASS_RESULTS AS TCR,
		CONSUMER AS CONS
	WHERE
		TC.CLASS_ID = TCR.CLASS_ID AND 
		TCR.CON_ID = CONS.CONSUMER_ID AND
		TCR.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
		<cfif isDefined("attributes.keyword_2") and len(attributes.keyword_2)>
			AND (
				
				CONS.CONSUMER_NAME+' '+CONS.CONSUMER_SURNAME LIKE '%#attributes.keyword_2#%'
				)
			</cfif>
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#GET_CLASS_RESULTS.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif isdefined("attributes.trail")>
	<cfinclude template="view_class.cfm">
</cfif>
<cfif len(attributes.keyword_2)>
	<cfset url_str = "#url_str#&keyword_2=#attributes.keyword_2#">
</cfif>
<cfif isdefined("attributes.BRANCH_ID")>
	<cfset url_str = "#url_str#&BRANCH_ID=#attributes.BRANCH_ID#">
<cfelse>
	<cfset attributes.BRANCH_ID = "">
</cfif>
<cfif isdefined("attributes.POSITION_CAT_ID")>
	<cfset url_str = "#url_str#&POSITION_CAT_ID=#attributes.POSITION_CAT_ID#">
<cfelse>
	<cfset attributes.POSITION_CAT_ID = "">
</cfif>
<cf_big_list_search title="#getLang('training_management',179)# : #get_class.CLASS_NAME#">
	<cf_big_list_search_area>
	<cfform name="form1" method="post" action="#request.self#?fuseaction=training_management.popup_class_att_tests_report&class_id=#attributes.class_id#">
        <div class="row form-inline">
			<div class="form-group" id="item-keyword_2">
				<div class="input-group x-12">
					<cfinput type="text" name="keyword_2" value="#attributes.keyword_2#" placeholder="#getLang('main',48)#">
				</div>
			</div>	
			<div class="form-group x-3_5">
				<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
            </div>            
            <div class="form-group"><cf_wrk_search_button></div>
             <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
        </div>
    </cfform>
	</cf_big_list_search_area>
</cf_big_list_search>
<!-- sil -->	
<cf_medium_list>
	<thead>
		<tr> 
			<th></th>
			<th><cf_get_lang_main no='158.Ad Soyad'></th>
			<cfsavecontent variable="message"><cf_get_lang no='173.Şirket/Şube/Departman'></cfsavecontent>
			<th><cfoutput>#ListGetAt(message,1,'/')#</cfoutput></th>
			<th><cfoutput>#ListGetAt(message,2,'/')#</cfoutput></th>
			<th><cfoutput>#ListGetAt(message,3,'/')#</cfoutput></th>
			<th><cf_get_lang no='174.Yoklama'></th>
			<th><cf_get_lang no='175.Ön T'></th>
			<th><cf_get_lang no='176.Son T'></th>
            <th><cf_get_lang no='6.3 Test'></th>
			<th><cf_get_lang no='177.D Oranı'></th>
		</tr>
	</thead>
	<tbody>
		<cfif GET_CLASS_RESULTS.RECORDCOUNT>
		<cfset my_list = "">
		<cfoutput query="GET_CLASS_RESULTS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
			<cfquery datasource="#dsn#" name="GET_TRAIN_CLASS_DT">
			SELECT
				TCADT.ATTENDANCE_MAIN,
				TCADT.IS_EXCUSE_MAIN,
				TCADT.EXCUSE_MAIN,
				TCADT.EMP_ID,
				TCADT.PAR_ID,
				TCADT.CON_ID,
				TCA.START_DATE
			FROM
				TRAINING_CLASS_ATTENDANCE TCA,
				TRAINING_CLASS_ATTENDANCE_DT TCADT
			WHERE
				TCA.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class_results.class_id#"> 
				<cfif len(get_class_results.EMP_ID)>AND TCADT.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class_results.emp_id#">
				<cfelseif len(get_class_results.PAR_ID)>AND TCADT.PAR_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class_results.par_id#">
				<cfelseif len(get_class_results.CON_ID)>AND TCADT.CON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class_results.con_id#">
				</cfif> 
				AND TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID
                AND TCADT.IS_TRAINER = 0
			</cfquery>
			<cfif IsNumeric(PRETEST_POINT) AND IsNumeric(FINALTEST_POINT) AND PRETEST_POINT GT 0>
				<cfset oran = (FINALTEST_POINT-PRETEST_POINT)/PRETEST_POINT*100>
				<cfset my_list = ListAppend(my_list,ORAN)>
			<cfelseif IsNumeric(PRETEST_POINT) AND IsNumeric(FINALTEST_POINT) AND PRETEST_POINT IS 0>
				<cfset oran = '-'>
			<cfelse>
				<cfset oran = '-'>
			</cfif>
				<tr>
				<td width="15">#currentrow#</td>
				<td nowrap>
				<cfif len(emp_id)>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#emp_id#','medium');" class="tableyazi">#adsoyad#</a>
					<!--- <input type="hidden" name="EMP_ID_#currentrow#" value="#EMP_ID#"> ---> <!--- 100 güne silinsin --->
				<cfelseif len(con_id)>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#con_id#','medium');" class="tableyazi">#adsoyad#</a>
					<!--- <input type="hidden" name="CON_ID_#currentrow#" value="#CON_ID#"> ---> <!--- 100 güne silinsin --->
				<cfelseif len(par_id)>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#par_id#','medium');" class="tableyazi">#adsoyad#</a>
					<!--- <input type="hidden" name="PAR_ID_#currentrow#" value="#PAR_ID#"> ---> <!--- 100 güne silinsin --->
				</cfif>
				</td>
				<td nowrap>#nick_name#</td>
				<td nowrap>#branch_name#</td>
				<td nowrap>#department_head#</td>
				<td nowrap>
					<cfset emp_dev=0>
					<cfset par_dev=0>
					<cfset con_dev=0>
					<cfloop query="GET_TRAIN_CLASS_DT">			
							<cfif len(EMP_ID) AND len(ATTENDANCE_MAIN)><cfset emp_dev=emp_dev+ATTENDANCE_MAIN></cfif>
							<cfif len(PAR_ID) AND len(ATTENDANCE_MAIN)><cfset par_dev=par_dev+ATTENDANCE_MAIN></cfif>
							<cfif len(CON_ID) AND len(ATTENDANCE_MAIN)><cfset con_dev=con_dev+ATTENDANCE_MAIN></cfif>
					</cfloop>
					<cfif len(get_class_results.EMP_ID)>
					<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=training_management.popup_class_attendance_detail&class_id=#get_class_results.CLASS_ID#&emp_id=#get_class_results.EMP_ID#','small')"><cfif emp_dev gt 0>#emp_dev/GET_TRAIN_CLASS_DT.RECORDCOUNT#</cfif></a>
					<cfelseif len(get_class_results.PAR_ID)>
					<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=training_management.popup_class_attendance_detail&class_id=#get_class_results.CLASS_ID#&par_id=#get_class_results.PAR_ID#','small')"><cfif par_dev gt 0>#par_dev/GET_TRAIN_CLASS_DT.RECORDCOUNT#</cfif></a>
					<cfelseif len(get_class_results.CON_ID)>
					<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=training_management.popup_class_attendance_detail&class_id=#get_class_results.CLASS_ID#&con_id=#get_class_results.CON_ID#','small')"> <cfif con_dev gt 0> #con_dev/GET_TRAIN_CLASS_DT.RECORDCOUNT#</cfif></a>
					</cfif>
				</td>
				<td>#PRETEST_POINT#</td>
				<td>#FINALTEST_POINT#</td>
                <td>#THIRDTEST_POINT#</td>
				<td><cfif IsNumeric(ORAN)>%#Round(ORAN)#<cfelse>#oran#</cfif></td>
		</tr>
		<!--- </cfif> --->		  
		</cfoutput>
		<tr class="color-list">
			<td colspan="10"><cf_get_lang no='178.Grup Ortalaması'>:<cfoutput>%#Round(ArrayAvg(ListToArray(my_list)))#</cfoutput></td> 
		</tr>
		<cfelse>
		<tr class="color-list">
			<td colspan="10"><cf_get_lang_main no='72.Kayıt bulunamadı'>!</td> 
			</tr>
		</cfif> 
	</tbody>
</cf_medium_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr> 
			<td height="35">
				<cf_pages 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#"
					class_id="#attributes.class_id#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="training_management.popup_class_att_tests_report#url_str#&class_id=#class_id#"> 
			</td>
			<td style="text-align:right;"><!-- sil --><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput><!-- sil --></td>
		</tr>
	</table>
</cfif>
