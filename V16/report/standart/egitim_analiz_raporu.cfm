<cfprocessingdirective suppresswhitespace="yes">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.date" default="">
<cfparam name="attributes.report_type" default="1">
<cfif isdefined("attributes.date") and isdate(attributes.date)>
	<cf_date tarih="attributes.date">
</cfif>
<cfif isdefined("attributes.is_submitted")>
	<cfquery name="get_attenders" datasource="#dsn#">
		SELECT
			TCA.EMP_ID
		FROM
			TRAINING_CLASS_ATTENDER TCA,
			TRAINING_CLASS_SECTIONS TCS
		WHERE
			TCS.CLASS_ID = TCA.CLASS_ID AND
			TCA.EMP_ID IS NOT NULL
		<cfif isdefined("attributes.train_id") and len(attributes.train_id)>
			AND TCS.TRAIN_ID = #attributes.train_id#
		</cfif>
	</cfquery>
	<cfquery name="get_emp_tra" datasource="#dsn#">
		SELECT
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME,
			EP.POSITION_NAME,
			D.DEPARTMENT_HEAD,
			B.BRANCH_NAME,
			OC.NICK_NAME,
			E.GROUP_STARTDATE,
			ED.SEX,
			EI.BIRTH_DATE,
			E.EMPLOYEE_ID
		FROM
			EMPLOYEE_POSITIONS EP,
			DEPARTMENT D,
			BRANCH B,
			OUR_COMPANY OC,
			EMPLOYEES_DETAIL ED,
			EMPLOYEES_IDENTY EI,
			EMPLOYEES E
		WHERE
			D.BRANCH_ID = B.BRANCH_ID AND
			OC.COMP_ID = B.COMPANY_ID AND
			E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
			E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
			E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
			EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			EP.IS_MASTER = 1
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND
			( E.EMPLOYEE_NAME LIKE '%#attributes.keyword#%'
			OR
			E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' )
		</cfif>
	<cfif get_attenders.recordcount>
		<cfif attributes.report_type eq 1>
			AND E.EMPLOYEE_ID IN (#ValueList(get_attenders.EMP_ID,",")#)
		<cfelseif attributes.report_type eq 2>
			AND E.EMPLOYEE_ID NOT IN (#ValueList(get_attenders.EMP_ID,",")#)
		</cfif>
	</cfif>
		<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
			AND OC.COMP_ID = #attributes.comp_id#
		</cfif>
		<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
			AND EP.FUNC_ID = #attributes.func_id#
		</cfif>
		<cfif isdefined("attributes.title_id") and len(attributes.title_id)>
			AND EP.TITLE_ID = #attributes.title_id#
		</cfif>
		<cfif isdefined("attributes.date") and len(attributes.date)>
			AND E.GROUP_STARTDATE < #attributes.date#
		</cfif>
		ORDER BY
			EP.EMPLOYEE_NAME
	</cfquery>
<cfelse>
	<cfset get_emp_tra.recordcount = 0>
</cfif>

<cfquery name="training" datasource="#dsn#">
	SELECT TRAIN_ID,TRAIN_HEAD FROM TRAINING
</cfquery>
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfquery name="get_units" datasource="#dsn#">
	SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT 
</cfquery>
<cfquery name="TITLES" datasource="#dsn#">
	SELECT TITLE_ID,TITLE FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_emp_tra.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
	<tr height="35">
		<td class="color-border">
		  <table width="100%" border="0" cellpadding="2" cellspacing="1" height="100%">        	
		 	<tr>
            <td height="30" align="right" valign="top" class="color-row" style="text-align:right;">
			<table>
				<cfform name="form" action="#request.self#?fuseaction=#attributes.fuseaction#&report_id=#attributes.report_id#" method="post">
				<tr> 
					<input type="hidden" name="is_submitted" id="is_submitted" value="1">
					<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57460.Filtre'> : <cfinput type="text" name="keyword" value="#attributes.keyword#" style="width:180px"></td>
					 <td align="right" style="text-align:right;">
					 	<select name="comp_id" id="comp_id" style="width:180px;">
							<option value=""><cf_get_lang dictionary_id='29531.Şirketler'></option>
							<cfoutput query="get_our_company">
								<option value="#comp_id#"<cfif isdefined("attributes.comp_id") and attributes.comp_id eq comp_id>selected</cfif>>#company_name#</option>
							</cfoutput>
						</select>
					 </td>
					<td align="right" style="text-align:right;">
						<select name="func_id" id="func_id" style="width:180px;">
							<option value=""><cf_get_lang dictionary_id='39392.Fonksiyonlar'></option>
							<cfoutput query="get_units">
								<option value="#unit_id#"<cfif isdefined("attributes.func_id") and attributes.func_id eq get_units.unit_id>selected</cfif>>#unit_name#</option>
							</cfoutput>
						</select>
					</td>
					<td align="right" style="text-align:right;">
						<select name="title_id" id="title_id" style="width:180px;">
							<option value=""><cf_get_lang dictionary_id='55168.Ünvanlar'></option>
							<cfoutput query="titles">
								<option value="#title_id#" <cfif isdefined("attributes.title_id") and attributes.title_id eq title_id>selected</cfif>>#title#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right" style="text-align:right;">
						<select name="train_id" id="train_id" style="width:180px;">
							<option value=""><cf_get_lang dictionary_id='46002.Konular'></option>
							<cfoutput query="training">
							<option value="#TRAIN_ID#"<cfif isdefined("attributes.TRAIN_ID") and attributes.TRAIN_ID eq training.TRAIN_ID>selected</cfif>>#TRAIN_HEAD#</option>
							</cfoutput>
						</select>
					</td>
					<td align="right" style="text-align:right;">
						<select name="report_type" id="report_type" style="width:180px;">
							<option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='39395.Katılmış'></option>
							<option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='39396.Katılmamış'></option>
						</select>
					</td>
					<td colspan="2" align="right" style="text-align:right;"><cf_get_lang dictionary_id='46560.Gruba Giriş Tarihi'>
				  		<cfinput type="text" name="date"  value="#dateformat(attributes.date,dateformat_style)#" validate="#validate_style#" maxlength="10" style="width:85px;">
			     		<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_calender</cfoutput>&alan=form.date','date','popup_calender');"><img src="/images/calendar.gif" align="absmiddle" border="0"></a> 
						<cf_get_lang dictionary_id='39397.den önce'>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#message#">
						<cf_workcube_buttons is_upd='0'>
					</td>
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
				<tr class="color-header" height="22"> 
					<td width="50" class="form-title"><cf_get_lang dictionary_id='58527.Id'></td>
					<td width="150" class="form-title"><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
					<td class="form-title"><cf_get_lang dictionary_id='57574.Şirket'></td>
					<td width="150" class="form-title"><cf_get_lang dictionary_id='35449.Departman'></td>
					<td width="90" class="form-title"><cf_get_lang dictionary_id='58497.Pozisyon'></td>
					<td width="90" class="form-title"><cf_get_lang dictionary_id='46560.Gruba Giriş Tarihi'></td>
					<td width="50" class="form-title"><cf_get_lang dictionary_id='57764.Cinsiyet'></td>
					<td width="50" class="form-title"><cf_get_lang dictionary_id='55745.Yaş'></td>
				</tr>
				<cfif get_emp_tra.recordcount>
					<cfoutput query="get_emp_tra" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td height="20">#EMPLOYEE_ID#</td>
							<td height="20"><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#EMPLOYEE_ID#" class="tableyazi">#employee_name#&nbsp;#employee_surname#</a></td>
							<td>#nick_name#</td>
							<td>#department_head#</td>
							<td>#position_name#</td>
							<td>#dateformat(group_startdate,dateformat_style)#</td>
							<td><cfif sex is 0><cf_get_lang dictionary_id='55621.Bayan'><cfelse><cf_get_lang dictionary_id='58959.Erkek'></cfif></td>
							<td><cfif len(birth_date)>#datediff("yyyy",get_emp_tra.birth_date,now())#</cfif></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr class="color-row">
						<td colspan="8"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
					</tr>
				</cfif>
			</table>
		</td>
	</tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>


	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
		<tr>
		<td><cf_pages page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#attributes.fuseaction#&keyword=#attributes.keyword#&report_id=#attributes.report_id#&report_type=#attributes.report_type#&is_submitted=#attributes.is_submitted#&train_id=#attributes.train_id#&comp_id=#attributes.comp_id#&func_id=#attributes.func_id#&title_id=#attributes.title_id#&date=#dateformat(attributes.date,dateformat_style)#">
		</td>
		<!-- sil --><td align="right" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>
<br/>
</cfprocessingdirective>
