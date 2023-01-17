<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.comp_id" default="0">
<cfparam name="attributes.is_form_submit" default="0">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.pro_employee_id" default="">
<cfparam name="attributes.pro_employee" default="">
<cfparam name="attributes.isGrafikGosterim" default="">
<cfparam name="attributes.blood_type" default="">
<cfquery name="get_company_name" datasource="#dsn#">
	SELECT NICK_NAME,COMP_ID,COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID IN 
		(SELECT 
			O.COMP_ID
		FROM 
			BRANCH B,OUR_COMPANY O 
		WHERE 
			B.COMPANY_ID = O.COMP_ID AND
			B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
		)
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME 
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY
		BRANCH_ID
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN(#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<script type="text/javascript">
	function PasifEt(Gonderen, Hedef)
	{
		/*
			Bir SELECT elementinde (Gonderen) selectedIndex = 0 olduğunda, Hedef ID'li nesneyi pasif eden,
			değerini kriterlere göre sıfırlayan (işaretlenebilir araçlar -checkbox, radio- ise seçimi iptal eden, string ise değerini silen)
		*/

		var Hedef = document.getElementById(Hedef);

		if (Gonderen != "")
		{
			Hedef.disabled = true;
			if (Hedef.type == "select-one" || Hedef.type == "select-multiple") // Seçilebilir bir nesne ise
				Hedef.options.selectedIndex = 0;
			else if (Hedef.type == "checkbox" || Hedef.type == "radio") // İşaretlenebilir bir nesne ise
				Hedef.checked = false;
			else if (Hedef.type == "textarea" || Hedef.type == "text" || Hedef.type == "hidden" || Hedef.type == "password") // String  bir nesne ise
				Hedef.value = "";
		}
		else
			Hedef.disabled = false;
	}

<cfif Len(attributes.BLOOD_TYPE)>
	function degerSifirla()
	{
		var KanGrubu = document.getElementById('BLOOD_TYPE');
		if (document.getElementById('isGrafikGosterim').checked)
			KanGrubu.options.selectedIndex = 0;
		else
			KanGrubu.value = <cfoutput>#attributes.BLOOD_TYPE#</cfoutput>;
	}
</cfif>
</script>

<cfif attributes.is_form_submit>
	<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
		<cf_date tarih="attributes.start_date">
	</cfif>
	<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
		<cf_date tarih="attributes.finish_date">
	</cfif>
	<cfquery name="GET_BLOOD_TYPE_RESULTS" datasource="#dsn#">
		SELECT
			ISNULL(EI.BLOOD_TYPE,8) AS KANGRUBU,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			EI.TC_IDENTY_NO,
			D.DEPARTMENT_HEAD,
			B.BRANCH_NAME,
			O.NICK_NAME
		FROM
			EMPLOYEES E,
			EMPLOYEES_IDENTY EI,
			EMPLOYEE_POSITIONS EP,
			DEPARTMENT D,
			BRANCH B,
			OUR_COMPANY O
		WHERE
			E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
			EP.IS_MASTER = 1 AND
			EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
			D.BRANCH_ID = B.BRANCH_ID AND
			B.COMPANY_ID = O.COMP_ID
			<cfif Len(attributes.blood_type)>
				AND ISNULL(EI.BLOOD_TYPE, 8) = #attributes.BLOOD_TYPE#
			</cfif>
			<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
				AND O.COMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
			</cfif>	
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
			</cfif>
			<cfif not session.ep.ehesap>
				AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
				AND O.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
			<cfif isdefined("attributes.department") and len(attributes.department)>
				AND D.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
			</cfif>
			<cfif len(attributes.pro_employee_id) and len(attributes.pro_employee)>
				AND E.EMPLOYEE_ID = #attributes.pro_employee_id#
			</cfif>
		<cfif isdefined("attributes.no_position")><!--- pozisyonu olmayanlar --->
		UNION
			SELECT
			ISNULL(EI.BLOOD_TYPE,8) AS KANGRUBU,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			EI.TC_IDENTY_NO,
			'' AS DEPARTMENT_HEAD,
			'' AS BRANCH_NAME,
			'' AS NICK_NAME
		FROM
			EMPLOYEES E,
			EMPLOYEES_IDENTY EI
		WHERE
			E.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND EMPLOYEE_ID IS NOT NULL) AND
			E.EMPLOYEE_ID = EI.EMPLOYEE_ID
			<cfif Len(attributes.blood_type)>
				AND ISNULL(EI.BLOOD_TYPE, 8) = #attributes.BLOOD_TYPE#
			</cfif>
			<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)><!--- sirket bilgisi istenirse bu kisiler gelmez --->
				AND E.EMPLOYEE_ID IS NULL
			</cfif>	
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)><!--- sirket bilgisi istenirse bu kisiler gelmez --->
				AND E.EMPLOYEE_ID IS NULL
			</cfif>
			<cfif isdefined("attributes.department") and len(attributes.department)><!--- sirket bilgisi istenirse bu kisiler gelmez --->
				AND E.EMPLOYEE_ID IS NULL
			</cfif>
			<cfif len(attributes.pro_employee_id) and len(attributes.pro_employee)>
				AND EI.EMPLOYEE_ID = #attributes.pro_employee_id#
			</cfif>
		</cfif>
	</cfquery>
<cfelse>
	<cfset GET_BLOOD_TYPE_RESULTS.recordcount = 0>
</cfif>
<cfset url_str = "">
<cfif attributes.is_form_submit>
	<cfset url_str = '#url_str#&is_form_submit=1'>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined("attributes.department") and len(attributes.department)>
	  <cfset url_str = "#url_str#&department=#attributes.department#">
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		<cfset url_str="#url_str#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
	  <cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
	</cfif>
	<cfif isdefined("attributes.title_id") and len(attributes.title_id)>
	  <cfset url_str = "#url_str#&title_id=#attributes.title_id#">
	</cfif>
	<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
	  <cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
	</cfif>	
	<cfif isdefined("attributes.quiz_id") and len(attributes.quiz_id)>
	  <cfset url_str = "#url_str#&quiz_id=#attributes.quiz_id#">
	</cfif>
	<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	  <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
	</cfif>
	<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	  <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
	</cfif>
	<cfif isdefined("attributes.no_position")>
	  <cfset url_str = "#url_str#&no_position=1">
	</cfif>
</cfif>


<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#GET_BLOOD_TYPE_RESULTS.recordcount#">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='40719.Kan Grubu Raporu'></cfsavecontent>
    <cf_report_list_search title="#title#">
        <cf_report_list_search_area>
			<cfform name="list_perform" method="post" action="#request.self#?fuseaction=report.blood_group_report">
			<div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
							<input name="is_form_submit" id="is_form_submit" value="1" type="hidden">
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
									<div class="col col-9 col-xs-12">
										<div class="col col-12 col-md-12 col-xs-12">
											<div class="multiselect-z2">
												<cf_multiselect_check 
												query_name="get_company_name"  
												name="comp_id"
												option_value="COMP_ID"
												option_name="COMPANY_NAME"
												option_text="#getLang('main',322)#"
												value="#attributes.comp_id#"
												onchange="get_branch_list(this.value)">
											</div>
										</div>																			
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id="29434.Subeler"></label>
									<div class="col col-9 col-xs-12" id="BRANCH_PLACE">
										<div class="col col-12 col-md-12 col-xs-12">
											<div id="BRANCH_PLACE" class="multiselect-z2">
												<cf_multiselect_check 
												query_name="get_branchs"  
												name="branch_id"
												option_value="BRANCH_ID"
												option_name="BRANCH_NAME"
												option_text="#getLang('main',322)#"
												value="#attributes.branch_id#"
												onchange="get_department_list(this.value)">
											</div>
										</div>																				
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id="57572.Departman"></label>
									<div class="col col-9 col-xs-12" id="DEPARTMENT_PLACE">
										<div class="col col-12 col-md-12 col-xs-12">
											<div class="multiselect-z2" id="DEPARTMENT_PLACE">
												<cf_multiselect_check 
												query_name="get_department"  
												name="department"
												option_text="#getLang('main',322)#" 
												option_value="department_id"
												option_name="department_head"
												value="#iif(isdefined("attributes.department"),"attributes.department",DE(""))#">
											</div>
										</div>										
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
									<div class="col col-9 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="pro_employee_id" id="pro_employee_id" value="<cfif isdefined('attributes.pro_employee_id') and len(attributes.pro_employee)><cfoutput>#attributes.pro_employee_id#</cfoutput></cfif>">
                        				<input type="text" placeholder="<cf_get_lang dictionary_id="57576.calisan">" name="pro_employee" id="pro_employee" value="<cfif isdefined('attributes.pro_employee') and len(attributes.pro_employee)><cfoutput>#attributes.pro_employee#</cfoutput></cfif>" style="width:120px;" onfocus="AutoComplete_Create('pro_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','pro_employee_id','','3','135');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_perform.pro_employee_id&field_name=list_perform.pro_employee&select_list=1','list');"></span>  
									</div>
									</div>
								</div>
								<div class="form-group">
									<div class="col col-9 col-xs-12">
										<select name="BLOOD_TYPE" id="BLOOD_TYPE" onchange="PasifEt(this.value, 'isGrafikGosterim');">
											<option value=""><cf_get_lang dictionary_id="57734.seciniz"></option>
											<option value="0" <cfif attributes.BLOOD_TYPE EQ 0>selected</cfif>>0 Rh+</option>
											<option value="1" <cfif attributes.BLOOD_TYPE EQ 1>selected</cfif>>0 Rh-</option>
											<option value="2" <cfif attributes.BLOOD_TYPE EQ 2>selected</cfif>>A Rh+</option>
											<option value="3" <cfif attributes.BLOOD_TYPE EQ 3>selected</cfif>>A Rh-</option>
											<option value="4" <cfif attributes.BLOOD_TYPE EQ 4>selected</cfif>>B Rh+</option>
											<option value="5" <cfif attributes.BLOOD_TYPE EQ 5>selected</cfif>>B Rh-</option>
											<option value="6" <cfif attributes.BLOOD_TYPE EQ 6>selected</cfif>>AB Rh+</option>
											<option value="7" <cfif attributes.BLOOD_TYPE EQ 7>selected</cfif>>AB Rh-</option>
											<option value="8" <cfif attributes.BLOOD_TYPE EQ 8>selected</cfif>><cf_get_lang no="698.Bilinmiyor"></option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<div class="col col-9 col-xs-12">
										<label for="isGrafikGosterim"><cf_get_lang dictionary_id="29817.Grafik Olarak Göster"><input type="checkbox" name="isGrafikGosterim" id="isGrafikGosterim" <cfif Len(attributes.BLOOD_TYPE)>onclick="degerSifirla();"</cfif> <cfif attributes.isGrafikGosterim EQ 1>checked</cfif> value="1" /></label>
										<label><cf_get_lang dictionary_id="58433.Bos Pozisyonları Göster"><input type="checkbox" name="no_position" id="no_position" <cfif isdefined("attributes.no_position")>checked</cfif> value="1" /></label>
									</div>
								</div>
							</div>
						</div>
					</div>
						<div class="row ReportContentBorder">
							<div class="ReportContentFooter">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
								<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
									<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
								<cfelse>
									<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
								</cfif>
								<cf_wrk_report_search_button button_type="1">
							</div>
						</div>
				</div>
			</div>
			</cfform>
        </cf_report_list_search_area>
    </cf_report_list_search>

<cf_report_list>
        <thead>				
            <tr> 
                <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                <th><cf_get_lang dictionary_id="58025.TC Kimlik No"></th>
                <th><cf_get_lang dictionary_id="57570.Ad Soyad"></th>
                <th><cf_get_lang dictionary_id="57750.İşyeri Adı"></th>
                <th><cf_get_lang dictionary_id="57453.Şube"></th>
                <th><cf_get_lang dictionary_id="57572.Departman"></th>
                <th><cf_get_lang dictionary_id="58441.Kan Grubu"></th>
            </tr>
        </thead>
        <tbody>
            <cfset total_puan_amir1_ = 0>
            <cfset total_kisi_amir1_ = 0>
            <cfset total_puan_amir2_ = 0>
            <cfset total_kisi_amir2_ = 0>
            <cfset total_puan_genel_ = 0>
            <cfset total_kisi_genel_ = 0>
            <cfif GET_BLOOD_TYPE_RESULTS.recordcount>
            <cfif Len(attributes.isGrafikGosterim)>
                <cfquery name="get_blood_types_count" dbtype="query">
                    SELECT
                        KANGRUBU,
                        Count(KANGRUBU) AS Say
                    FROM
                        GET_BLOOD_TYPE_RESULTS
                    GROUP BY
                        KANGRUBU
                    ORDER BY
                        KANGRUBU
                </cfquery>
            </cfif>
            <cfscript>
                function KanGrubuCevir(No)
                {
                    if (No == 0)
                        return "0 Rh(+)";
                    else if (No == 1)
                        return "0 Rh(-)";
                    else if (No == 2)
                        return "A Rh(+)";
                    else if (No == 3)
                        return "A Rh(-)";
                    else if (No == 4)
                        return "B Rh(+)";
                    else if (No == 5)
                        return "B Rh(-)";
                    else if (No == 6)
                        return "AB Rh(+)";
                    else if (No == 7)
                        return "AB Rh(-)";
                    else if (!IsDefined(No) || No == 8)
                        return "Bilinmiyor";
                }
            </cfscript>
            <cfoutput query="GET_BLOOD_TYPE_RESULTS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr>
                <td>#currentrow#</td>
                <td>#TC_IDENTY_NO#</td>
                <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                <td>#nick_name#</td>
                <td>#BRANCH_NAME#</td>
                <td>#DEPARTMENT_HEAD#</td>
                <td>#KanGrubuCevir(KANGRUBU)#</td>
            </tr>
            </cfoutput>
            <cfelse>
            <tr>
                <td colspan="14"><cfif attributes.is_form_submit><cf_get_lang dictionary_id='57484.kayıt yok'><cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'></cfif>!</td>
            </tr>
            </cfif>
        </tbody>
</cf_report_list>
<cfif GET_BLOOD_TYPE_RESULTS.recordcount>
	<cfif Len(attributes.isGrafikGosterim)>
        <table width="99%" cellpadding="0" cellspacing="0">
            <tr>
				<td> 
					<cfsavecontent variable="title"><cf_get_lang dictionary_id='39417.Kan Grubu Dağılımı'></cfsavecontent>
                    <cf_box title="#title#" closable="0" collapsable="0">
                        <cf_ajax_list>
                            <tbody>
                                <tr class="nohover">
									<td width="400" style="text-align:center;">
										<script src="JS/Chart.min.js"></script>
											<div class="col col-2">
											<canvas id="myChart" width="250" height="250"></canvas>
											</div>
											<script>
												var ctx = document.getElementById('myChart').getContext('2d');
													var myChart = new Chart(ctx, {
														type: 'pie',
														data: {
															labels: [<cfloop from="1" to="#get_blood_types_count.recordcount#" index="Sayac"><cfoutput>"#KanGrubuCevir(get_blood_types_count.KANGRUBU[Sayac])#"</cfoutput>,</cfloop>],
															datasets: [{
																label: 'Kan Grubu',
																backgroundColor: [
																		<cfloop from="1" to="#get_blood_types_count.recordcount#" index="Sayac">
																			'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',
																		</cfloop>
																],
																data: [<cfloop from="1" to="#get_blood_types_count.recordcount#" index="Sayac"><cfoutput>#get_blood_types_count.say[Sayac]#</cfoutput>,</cfloop>],
															}]
														},
														options: {}
												});
											</script>
                                    </td>
                                </tr>
                            </tbody>
                        </cf_ajax_list>
                    </cf_box>
                </td>
            </tr>
        </table>
    </cfif>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
		<tr>
			<td> <cf_pages 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="report.blood_group_report#url_str#">
			</td>
			<!-- sil --><td align="right" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		  </tr>
	</table>
</cfif>
<cfif not isdefined('attributes.is_excel')>
<script type="text/javascript">
document.getElementById('pro_employee').focus();
function get_branch_list(gelen)
	{
		checkedValues_b = $("#comp_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
	}

	function get_department_list(gelen)
	{
		checkedValues_b = $("#branch_id").multiselect("getChecked");
		var branch_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(branch_id_list == '')
				branch_id_list = checkedValues_b[kk].value;
			else
				branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
</script>
</cfif>
