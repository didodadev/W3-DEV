<cfparam name="attributes.training_sec_id" default="">
<cfparam name="attributes.our_company" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif len(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
</cfif>
<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT COMP_ID, COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfquery name="GET_TRAINING_SEC_NAMES" datasource="#dsn#">
	SELECT
		TRAINING_CAT.TRAINING_CAT_ID,
		TRAINING_SEC.TRAINING_SEC_ID,
		TRAINING_SEC.SECTION_NAME,
		TRAINING_CAT.TRAINING_CAT
	FROM
		TRAINING_SEC,
		TRAINING_CAT
	WHERE
		TRAINING_SEC.TRAINING_CAT_ID = TRAINING_CAT.TRAINING_CAT_ID
	ORDER BY
		TRAINING_CAT.TRAINING_CAT,
		TRAINING_SEC.SECTION_NAME
</cfquery>
<cfquery name="GET_TRAINING" datasource="#dsn#">
	SELECT 
		TRAINING_CLASS.CLASS_ID,
		TRAINING_CLASS.CLASS_NAME,
		TRAINING_CLASS.START_DATE,
		TRAINING_CLASS.FINISH_DATE,
		TRAINING_CLASS.DATE_NO,
		TRAINING_CLASS.HOUR_NO,
		<!--- TRAINING_CLASS.TRAINER_EMP,
		TRAINING_CLASS.TRAINER_PAR,
		TRAINING_CLASS.TRAINER_CONS, --->
		TRAINING_CLASS.CLASS_PLACE,
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.GROUP_STARTDATE
		<cfif len(attributes.our_company)>
		,OC.NICK_NAME
		,D.DEPARTMENT_HEAD
		,EP.POSITION_NAME
		</cfif>
	FROM
		TRAINING_CLASS,
		TRAINING_CLASS_ATTENDER,
		EMPLOYEES
		<cfif len(attributes.our_company)>
		,EMPLOYEE_POSITIONS EP
		,DEPARTMENT D
		,BRANCH B
		,OUR_COMPANY OC
		</cfif>
	WHERE
		TRAINING_CLASS_ATTENDER.EMP_ID = EMPLOYEES.EMPLOYEE_ID AND
		TRAINING_CLASS.CLASS_ID = TRAINING_CLASS_ATTENDER.CLASS_ID
		<cfif len(attributes.start_date)>AND TRAINING_CLASS.START_DATE >= #attributes.start_date#</cfif>
		<cfif len(attributes.finish_date)>AND TRAINING_CLASS.START_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
		<cfif len(attributes.training_sec_id)>AND TRAINING_CLASS.TRAINING_SEC_ID = #attributes.training_sec_id#</cfif>
		<cfif len(attributes.our_company)>
		AND EMPLOYEES.EMPLOYEE_ID = EP.EMPLOYEE_ID
		AND EP.DEPARTMENT_ID = D.DEPARTMENT_ID
		AND D.BRANCH_ID = B.BRANCH_ID 
		AND B.COMPANY_ID = OC.COMP_ID
		AND OC.COMP_ID = #attributes.our_company#
		</cfif>
		<!---<cfif len(attributes.our_company)>
			AND EMPLOYEES.EMPLOYEE_ID IN (
				SELECT
					EP.EMPLOYEE_ID
				FROM
					EMPLOYEE_POSITIONS EP,
					DEPARTMENT D,
					BRANCH B,
					OUR_COMPANY ORS
				WHERE 
					EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
					D.BRANCH_ID = B.BRANCH_ID AND
					B.COMPANY_ID = ORS.COMP_ID AND
					ORS.COMP_ID = #attributes.our_company#
			)
		</cfif>--->
		ORDER BY
			TRAINING_CLASS.RECORD_DATE DESC
		
</cfquery>
<cfquery name="GET_POSITION" datasource="#dsn#">
	SELECT
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME,
		EP.EMPLOYEE_ID,
		OC.COMPANY_NAME,
		DP.DEPARTMENT_HEAD,
		EP.POSITION_NAME
	FROM
		EMPLOYEE_POSITIONS EP,
		OUR_COMPANY OC,
		BRANCH B,
		DEPARTMENT DP
	WHERE
		EP.DEPARTMENT_ID = DP.DEPARTMENT_ID AND
		DP.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = OC.COMP_ID
	ORDER BY 
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME
</cfquery>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_training.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
	  <table cellspacing="1" cellpadding="2" width="100%" border="0">
            <tr height="20" class="color-row">
			  <td align="right" style="text-align:right;">
			  	<table>
					<cfform name="form1" method="post" action="#request.self#?fuseaction=report.detail_report&event=det&report_id=#attributes.report_id#">
					<tr>
						<td>
                            <select name="our_company" id="our_company">
                                <option value=""><cf_get_lang dictionary_id='57574.Şirket'></option>
                                <cfoutput query="get_company">
                                    <option value="#comp_id#" <cfif attributes.our_company eq comp_id>selected</cfif>>#company_name#</option>
                                </cfoutput>
                            </select>
                        </td>
						<td><select name="training_sec_id" id="training_sec_id">
							<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
							<cfoutput query="get_training_sec_names">
								<option value="#training_sec_id#" <cfif attributes.training_sec_id eq training_sec_id>selected</cfif>>#training_cat# / #section_name#</option>
							</cfoutput>
						</select></td>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='41935.Lütfen Başlangıç Tarihini Giriniz'></cfsavecontent>
						<td><cfinput name="start_date" type="text" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#message#">
							<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_calender</cfoutput>&alan=form1.start_date','date');"><img src="/images/calendar.gif" align="absbottom" border="0"></a></td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='50693.Lütfen Bitiş Tarihi Giriniz'></cfsavecontent>
						<td><cfinput name="finish_date" type="text" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#message#">
							<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_calender</cfoutput>&alan=form1.finish_date','date');"><img src="/images/calendar.gif" align="absbottom" border="0"></a></td>
						<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						  <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
						<td><cf_wrk_search_button is_excel="0"></td>
					</tr>
					</cfform>
				</table>
			  </td>
			</tr>
      </table>
    </td>
  </tr>
</table>
<br/>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
	  <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr height="22" class="color-header">
          <td class="form-title" width="25"><cf_get_lang dictionary_id ='57487.No'></td>
		  <td class="form-title"><cf_get_lang dictionary_id ='57574.Şirket'></td>
		  <td class="form-title"><cf_get_lang dictionary_id ='57572.Departman'></td>
		  <td class="form-title"><cf_get_lang dictionary_id ='57570.Ad Soyad'></td>
		  <td class="form-title"><cf_get_lang dictionary_id ='46560.Gruba Giriş Tarihi'></td>
		  <td class="form-title"><cf_get_lang dictionary_id ='58497.Pozisyon'></td>
		  <td class="form-title"><cf_get_lang dictionary_id ='47799.Ders'></td>
		  <td class="form-title"><cf_get_lang dictionary_id ='47799.Ders'> <cf_get_lang dictionary_id ='57487.No'></td>
		  <td class="form-title"><cf_get_lang dictionary_id ='57501.Başlangıç'></td>
		  <td class="form-title"><cf_get_lang dictionary_id ='57502.Bitiş'></td>
		  <td class="form-title"><cf_get_lang dictionary_id ='29513.Süre'> (<cf_get_lang dictionary_id='57490.Gün'>/ <cf_get_lang dictionary_id='57491.Saat'>)</td>
		  <td class="form-title"><cf_get_lang dictionary_id ='53132.Başlangıç Ay'></td>
		  <td class="form-title"><cf_get_lang dictionary_id ='35159.Başlangıç Yıl'></td>
		  <td class="form-title"><cf_get_lang dictionary_id ='55913.Eğitimci'> - <cf_get_lang dictionary_id ='57574.Şirket'></td>
		  <td class="form-title"><cf_get_lang dictionary_id ='46394.Eğitim Yeri'></td>
		  <td class="form-title"><cf_get_lang dictionary_id ='51943.Katılım'> <cf_get_lang dictionary_id= '30111.Durumu'></td>
		</tr>
		<cfif get_training.recordcount>
          	<cfoutput query="get_training" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfquery name="GET_POSITION_ONE" dbtype="query">
				SELECT * FROM GET_POSITION WHERE EMPLOYEE_ID = #employee_id#
			</cfquery>
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			  <td>#currentrow#</td>
			  <td><cfif len(attributes.our_company)>#nick_name#</cfif><!---<cfif len(get_position_one.company_name)>#get_position_one.company_name#</cfif>---></td>
			  <td><cfif len(attributes.our_company)>#department_head#</cfif><!---<cfif len(get_position_one.department_head)>#get_position_one.department_head#</cfif>---></td>
			  <td>#employee_name# #employee_surname#</td>
			  <td>#dateformat(group_startdate,dateformat_style)#</td>
			  <td><cfif len(attributes.our_company)>#position_name#</cfif><!---<cfif len(get_position_one.position_name)>#get_position_one.position_name#</cfif>---></td>
			  <td>#class_name#</td>
			  <td>#class_id#</td>
			  <td>#dateformat(start_date,dateformat_style)# #timeformat(start_date,timeformat_style)#</td>
			  <td>#dateformat(finish_date,dateformat_style)# #timeformat(finish_date,timeformat_style)#</td>
			  <td>#date_no#/#hour_no#</td>
			  <td>#month(start_date)#</td>
			  <td>#year(start_date)#</td>
			  <td>
				<cfquery name="get_trainers" datasource="#dsn#">
					SELECT
						TCT.ID,
						E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS TRAINER,
						'Çalışan' AS TRAINER_DETAIL
					FROM
						TRAINING_CLASS_TRAINERS TCT INNER JOIN EMPLOYEES E
						ON TCT.EMP_ID = E.EMPLOYEE_ID 
					WHERE
						TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_training.class_id#">
					UNION ALL
					SELECT
						TCT.ID,
						CP.COMPANY_PARTNER_NAME+' '+ CP.COMPANY_PARTNER_SURNAME AS TRAINER,
						'Kurumsal' AS TRAINER_DETAIL
					FROM
						TRAINING_CLASS_TRAINERS TCT INNER JOIN COMPANY_PARTNER CP
						ON TCT.PAR_ID =CP.PARTNER_ID 
					WHERE
						TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_training.class_id#">
					UNION ALL
					SELECT
						TCT.ID,
						C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS TRAINER,
						'Bireysel' AS TRAINER_DETAIL
					FROM
						TRAINING_CLASS_TRAINERS TCT INNER JOIN CONSUMER C
						ON TCT.CONS_ID =C.CONSUMER_ID 
					WHERE
						TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_training.class_id#">
				</cfquery>	
				<cfloop query="get_trainers">#TRAINER#,</cfloop>	
			  <!--- <cfif len(trainer_emp)>
			  #get_emp_info(trainer_emp,0,0)#
			  <cfelseif len(trainer_par)>
			  #get_par_info(trainer_par,0,0,0)#
			  <cfelseif len(trainer_cons)>
			  #get_cons_info(trainer_cons,1,0)#
			  </cfif> --->
			  </td>
			  <td>#class_place#</td>
			  <td></td>
			</tr>
          </cfoutput>
        <cfelse>
          <tr class="color-row">
            <td height="21" colspan="30"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>	
	<cfset url_str = "">
	<cfif len(attributes.training_sec_id)>
		<cfset url_str = "#url_str#&training_sec_id=#attributes.training_sec_id#">
	</cfif>
	<cfif len(attributes.our_company)>
		<cfset url_str = "#url_str#&our_company=#attributes.our_company#">
	</cfif>
	<cfif len(attributes.start_date)>
		<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
	</cfif>
	<cfif len(attributes.finish_date)>
		<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
	</cfif>
	<!-- sil -->
	<table width="98%" align="center" cellpadding="0" cellspacing="0" height="35">
    <tr>
      <td><cf_pages page="#attributes.page#"
				  maxrows="#attributes.maxrows#"
				  totalrecords="#attributes.totalrecords#"
				  startrow="#attributes.startrow#"
				  adres="report.detail_report&event=det&report_id=#attributes.report_id##url_str#"></td>
      <td align="right" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'> : #attributes.totalrecords#&nbsp;-&nbsp; <cf_get_lang dictionary_id='57581.Sayfa'> :#attributes.page#/#lastpage#</cfoutput></td>
    </tr>
  </table>
  <!-- sil -->
  <br/>
</cfif>

