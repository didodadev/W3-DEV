<cfparam name="attributes.priority_cat" default="">
<cfparam name="attributes.currency" default="">
<cfparam name="attributes.keyword_" default="">
<cfparam name="attributes.work_status" default="1">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.pda.maxrows#'>
<cfparam name="attributes.work_milestones" default="1">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfinclude template="../../objects2/project/query/get_prodetail.cfm">

<cfif project_detail.recordcount>
	<script type="text/javascript">
		function satirac(ac)
		{
			if (ac.style.display == "none")
			{
				ac.style.display = "block";
				return false;
			}
			else
			{
				ac.style.display = "none";
				return false;
			}
		}
	</script>
	<cfquery name="GET_PRO_CURRENCY_NAME" datasource="#DSN#">
		SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_detail.pro_currency_id#">
	</cfquery>
	<cfquery name="GET_PRIORITY" datasource="#DSN#">
		SELECT PRIORITY FROM SETUP_PRIORITY,PRO_PROJECTS WHERE PRO_PRIORITY_ID = PRIORITY_ID AND PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
	</cfquery>
    <table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%">
        <tr style="height:35px;">
            <td class="headbold">Proje: <cfoutput>#project_detail.project_number#</cfoutput></td>
            <td align="right"></td>
        </tr>
    </table>
	<table cellpadding="2" cellspacing="1" class="color-border" align="center" style="width:98%">	
		<tr>
			<td class="color-row">
				<table style="width:100%">
                    <tr class="color-row">
                        <td class="form-title"><cf_get_lang_main no='4.Proje'></td>
                        <td><cfoutput>#project_detail.project_head#</cfoutput></td>
                        <td align="right" style="text-align:right;"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_add_mail&id=#attributes.project_id#</cfoutput>','medium');"><img src="/images/mail.gif" title="<cf_get_lang no ='1385.Proje Ekibine Mail Gönder'>" border="0"></a></td>
                    </tr>
                    <tr class="color-row">
                        <td class="form-title"><cf_get_lang_main no='217.Açıklama'></td>
                        <td colspan="2">
                            <cfif len(project_detail.project_detail)>
                                <cfoutput>#project_detail.project_detail#</cfoutput>
                            </cfif>
                        </td>
                    </tr>
                	<tr class="color-row">
                  		<td class="form-title">Proje Hedefi</td>
                  		<td colspan="3">
                    		<cfif len(project_detail.project_target)>
                      			<cfoutput>#project_detail.project_target#</cfoutput>
                    		</cfif>
                  		</td>
                	</tr>
                	<tr class="color-row">
                  		<td class="form-title"><cf_get_lang_main no='246.Üye'></td>
                  		<td>
							<cfoutput>
								<cfif len(project_detail.partner_id)>
                                    #get_par_info(project_detail.partner_id,0,1,0)#
                                <cfelseif len(project_detail.consumer_id)>
                                    #get_cons_info(project_detail.consumer_id,1)#
                                <cfelseif len (project_detail.company_id)>
                                    #get_par_info(project_detail.company_id,1,0,0)#
                                </cfif>
                    		</cfoutput>
                  		</td>
                	</tr>
                	<tr>
                		<td class="form-title">Proje Lideri</td>
                  		<td>
                    		<cfif (project_detail.outsrc_partner_id neq 0) and len(project_detail.outsrc_partner_id)>
								<cfoutput>#get_par_info(project_detail.outsrc_partner_id,0,0,0)#</cfoutput>
                            <cfelseif len(project_detail.project_emp_id)>
                                <cfoutput>#get_emp_info(project_detail.project_emp_id,0,0,0)#</cfoutput>
                            </cfif>
                  		</td>
                	</tr>
                	<tr class="color-row">
                  		<td class="form-title"><cf_get_lang_main no='70.Aşama'></td>
                  		<td><cfoutput>#get_pro_currency_name.stage#</cfoutput></td>
                	</tr>
                	<tr>
                		<td class="form-title"><cf_get_lang_main no='73.Öncelik'></td>
                  		<td><cfoutput query="get_priority">#get_hist_detail.priority#</cfoutput></td>
               	 	</tr>
                	<tr class="color-row">
			  			<td class="form-title">İlişkili Proje</td>
			  			<td>
			  				<cfif len(project_detail.related_project_id)>
								<cfquery name="GET_PRO_NAME" datasource="#DSN#">
									SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_detail.related_project_id#">
								</cfquery>
			  				</cfif>
			  				<cfif len(project_detail.related_project_id)><cfoutput>#get_pro_name.project_head#</cfoutput><cfelse><cf_get_lang_main no='1047.Projesiz'></cfif>
			  			</td>
					</tr>
					<tr>
             			<td class="form-title">Kalan Zaman</td>
			  			<td nowrap><cf_per_cent start_date = '#project_detail.target_start#' finish_date = '#project_detail.target_finish#' color1='66CC33' color2='3399FF' width="175">
				 			<cfset days=abs(datediff("d",project_detail.target_finish,project_detail.target_start))><cfoutput>#days+1# gün</cfoutput>
			  			</td>
            		</tr>
                  	<tr class="color-row">
                      	<td class="form-title">Hedef Tarih</td>
                      	<cfset target_start = date_add('h',session.pda.time_zone,project_detail.target_start)>
                      	<td><cfoutput>#dateformat(target_start,'dd/mm/yyyy')# #timeformat(target_start,'hh:mm')# - </cfoutput>
                      	<cfset target_finish = date_add('h',session.pda.time_zone,project_detail.target_finish)>
                      	<cfoutput>#dateformat(target_finish,'dd/mm/yyyy')# #timeformat(target_finish,'HH:mm')#</cfoutput></td>
                    </tr>
                    <tr class="color-row">
                      	<td colspan="2">
                      	<cfset rec_date = date_add('h',session.pda.time_zone,project_detail.record_date)>
                        <br/>
                      	<cf_get_lang_main no='71.Kayıt'>:
                      	<cfif len(project_detail.record_emp)>
                            <cfoutput>#get_emp_info(project_detail.record_emp,0,0)#</cfoutput>
                   		<cfelseif len(project_detail.record_par)>
                            <cfoutput>#get_par_info(project_detail.record_par,0,1,0)#</cfoutput>
                   		</cfif>
                      	<cfoutput>#Dateformat(rec_date,'dd/mm/yyyy')#</cfoutput></td>
                    </tr> 
 					<cfoutput>
                    <tr>
                    	<td colspan="2"><a href="#request.self#?fuseaction=pda.list_internaldemand_report&project_id=#attributes.project_id#&project_head=#project_detail.project_head#" class="tableyazi">İlişkili Talepler</a></td>
                    </tr>  
                    </cfoutput>           
		  		</table>
            </td>
        </tr>
    </table>
<cfelse>
	<table border="0" cellspacing="0" cellpadding="0" style="width:100%; height:20px;">
		<tr class="color-row">
			<td colspan="9"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		</tr>
	</table>	
</cfif>

<cfquery name="GET_PRO_WORK" datasource="#DSN#">
	SELECT
    	WORK_ID,
		TYPE,
		MILESTONE_WORK_ID,
		COLOR,
		WORK_HEAD,
        PROJECT_ID,
		EMPLOYEE,
		WORK_PRIORITY_ID,
		PRIORITY,
		STAGE,
		TO_COMPLETE
    FROM
    (
        SELECT
            CASE 
                WHEN IS_MILESTONE = 1 THEN WORK_ID
                WHEN IS_MILESTONE <> 1 THEN ISNULL(MILESTONE_WORK_ID,0)
            END AS NEW_WORK_ID,
            CASE 
                WHEN IS_MILESTONE = 1 THEN 0
                WHEN IS_MILESTONE <> 1 THEN 1
            END AS TYPE,
            PW.IS_MILESTONE,
            PW.MILESTONE_WORK_ID,
            PW.WORK_ID,
            PW.WORK_HEAD,
            PW.PROJECT_ID,
            PW.ESTIMATED_TIME,
            (SELECT PTR.STAGE FROM PROCESS_TYPE_ROWS PTR WHERE PTR.PROCESS_ROW_ID= PW.WORK_CURRENCY_ID) STAGE,
            PW.WORK_PRIORITY_ID,
            CASE 
                WHEN PW.PROJECT_EMP_ID IS NOT NULL THEN (SELECT E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = PW.PROJECT_EMP_ID)
                WHEN PW.OUTSRC_PARTNER_ID IS NOT NULL THEN (SELECT C2.NICKNAME+' - '+ CP2.COMPANY_PARTNER_NAME + ' ' + CP2.COMPANY_PARTNER_SURNAME NAME FROM COMPANY_PARTNER CP2,COMPANY C2 WHERE C2.COMPANY_ID = CP2.COMPANY_ID AND CP2.PARTNER_ID = PW.OUTSRC_PARTNER_ID)
            END AS EMPLOYEE,
            PW.TARGET_FINISH,
            PW.TARGET_START,
            PW.REAL_FINISH,
            PW.REAL_START,
            PW.TO_COMPLETE,
            PW.UPDATE_DATE,
            PW.RECORD_DATE,
            SP.PRIORITY,
            SP.COLOR,
            (SELECT PRO_MATERIAL.PRO_MATERIAL_ID FROM PRO_MATERIAL WHERE PRO_MATERIAL.WORK_ID = PW.WORK_ID) PRO_MATERIAL_ID
        FROM
            PRO_WORKS PW,
            SETUP_PRIORITY SP
        WHERE
            PW.WORK_PRIORITY_ID = SP.PRIORITY_ID
            <cfif isDefined('attributes.project_id') and len(attributes.project_id)>
            	AND PW.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfif>
			<cfif len(attributes.keyword_)>
				AND 
				(
					<cfif isNumeric(attributes.keyword_)>
						PW.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.keyword_#"> OR 
					</cfif>
					PW.WORK_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%">
				)
			</cfif>
			<cfif len(attributes.priority_cat)>
				AND PW.WORK_PRIORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.priority_cat#">
			</cfif>
			<cfif len(attributes.currency)>
				AND PW.WORK_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.currency#">
			</cfif>
            <cfif isDefined('attributes.service_id') and len(attributes.service_id)>
				AND PW.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
			</cfif>
			<cfif attributes.work_status eq -1>
				AND (PW.WORK_STATUS = 0 OR PW.IS_MILESTONE = 1)
			<cfelseif attributes.work_status eq 1>
				AND (PW.WORK_STATUS = 1 OR PW.IS_MILESTONE = 1)
			</cfif>
	)T1
	WHERE
		1=1 
		<cfif attributes.work_milestones eq 0>
			AND IS_MILESTONE <> 1
		</cfif>
	ORDER BY
		<cfif isdefined("attributes.ordertype") and attributes.ordertype eq 2>
			ISNULL(UPDATE_DATE,RECORD_DATE) DESC
		<cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 3>
			TARGET_START DESC
		<cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 4>
			TARGET_START
		<cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 5>
			TARGET_FINISH DESC
		<cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 6>
			TARGET_FINISH
		<cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 7>
			WORK_HEAD
		<cfelse>
			WORK_ID DESC
		</cfif>
</cfquery>

<cfparam name="attributes.totalrecords" default='#get_pro_work.recordcount#'> 
<cfset work_h_list = ''>
<cfif get_pro_work.recordcount>
	<cfset work_h_list = valuelist(get_pro_work.work_id)>
	<cfquery name="GET_HARCANAN_ZAMAN" datasource="#DSN#">
		SELECT
			SUM((ISNULL(TOTAL_TIME_HOUR,0)*60) + ISNULL(TOTAL_TIME_MINUTE,0)) AS HARCANAN_DAKIKA,
			WORK_ID
		FROM
			PRO_WORKS_HISTORY
		WHERE
			WORK_ID IN (#work_h_list#)
		GROUP BY
			WORK_ID
	</cfquery>
	<cfset work_h_list = listsort(listdeleteduplicates(valuelist(get_harcanan_zaman.work_id,',')),'numeric','ASC',',')>
</cfif>

<cfset my_our_comp_ = session.pda.our_company_id>
<cfquery name="GET_PROCURRENCY" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_our_comp_#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.works%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfinclude template="../../objects2/project/query/get_priority.cfm">
<cfif isDefined('attributes.project_id') and len(attributes.project_id)>
	<cfset this_div_id_ = attributes.project_id>
<cfelse>
	<cfset this_div_id_ = 1>
</cfif>

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
