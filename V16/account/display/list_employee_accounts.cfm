<cf_get_lang_set module_name="ehesap">
<cfif not isdefined("attributes.keyword")>
	<cfset arama_yapilmali = 1>
<cfelse>
	<cfset arama_yapilmali = 0>
</cfif>
<cfquery name="get_xml_control" datasource="#dsn#">
    SELECT 
        PROPERTY_VALUE,
        PROPERTY_NAME
    FROM
        FUSEACTION_PROPERTY
    WHERE
        OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="ehesap.popup_list_period"> AND
        PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_add_multi_expense_center">
</cfquery>
<cfif arama_yapilmali eq 1>
	<cfset GET_IN_OUTS.recordcount = 0>
<cfelse>
	<cfinclude template="../../hr/ehesap/query/get_in_outs.cfm">
	<cfif GET_IN_OUTS.recordcount>
        <cfif get_xml_control.property_value eq 0>
            <cfquery name="get_expense_center" datasource="#dsn#">
                SELECT
                    EXPENSE_CENTER_ID,
                    EXPENSE_CODE_NAME,
                    IN_OUT_ID
                 FROM
                    EMPLOYEES_IN_OUT_PERIOD
                 WHERE
                    PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
                    IN_OUT_ID IN(#valuelist(GET_IN_OUTS.in_out_id,',')#)
            </cfquery>
        <cfelse>
            <cfquery name="get_expense_rows" datasource="#dsn2#">
                SELECT 
                    EC.EXPENSE,
                    PR.RATE,
                    PR.IN_OUT_ID
                FROM	
                    EXPENSE_CENTER EC INNER JOIN 
                    #dsn_alias#.EMPLOYEES_IN_OUT_PERIOD_ROW PR
                    ON EC.EXPENSE_ID = PR.EXPENSE_CENTER_ID
                WHERE
                    PR.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
                    PR.IN_OUT_ID IN(#valuelist(GET_IN_OUTS.in_out_id,',')#)
            </cfquery>
        </cfif>
        <cfquery name="get_account_bill" datasource="#dsn#">
			SELECT
            	DEFF.DEFINITION,
                DEFF.PAYROLL_ID,
                IP.IN_OUT_ID
            FROM
            	EMPLOYEES_IN_OUT_PERIOD IP INNER JOIN SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF DEFF
                ON IP.ACCOUNT_BILL_TYPE = DEFF.PAYROLL_ID 
            WHERE
                IP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
            	IP.IN_OUT_ID IN(#valuelist(GET_IN_OUTS.in_out_id,',')#)
        </cfquery>
	</cfif>
</cfif>
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
	
	duty_type = QueryNew("DUTY_TYPE_ID, DUTY_TYPE_NAME");
	QueryAddRow(duty_type,8);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",2,1);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('main',164)#",1);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",1,2);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#getLang('ehesap',194)#',2);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",0,3);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#getLang('ehesap',604)#',3);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",3,4);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#getLang('ehesap',206)#',4);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",4,5);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#getLang('ehesap',232)#',5);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",5,6);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#getLang('ehesap',223)#',6);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",6,7);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#getLang('ehesap',236)#',7);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",7,8);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#getLang('ehesap',253)#',8);
</cfscript>
<cfparam name="attributes.startdate" default="#date_add("m",-1,bu_ay_basi)#">
<cfparam name="attributes.finishdate" default="#Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)#">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.tc_identy_no" default="">
<cfparam name="attributes.duty_type" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.inout_statue" default="2">
<cfinclude template="../../hr/ehesap/query/get_ssk_offices.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_in_outs.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="listEmployeeAccounts" action="#request.self#?fuseaction=account.list_employee_accounts" method="post">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" placeholder="#getlang(48,'Filtre',57460)#" style="width:100px;" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<cfinput type="text" name="hierarchy" id="hierarchy" placeholder="#getlang(377,'Özel Kod',57789)#" style="width:100px;" value="#attributes.hierarchy#" maxlength="50">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							<cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(attributes.startdate,dateformat_style)#">
						<cfelse>
							<cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
						</cfif>
						<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
						<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
							<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
						<cfelse>
							<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
						</cfif>
						<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
					<cf_wrk_search_button button_type="4" search_function="date_check(listEmployeeAccounts.startdate,listEmployeeAccounts.finishdate,'#message_date#')">
					<cf_workcube_file_action pdf='0' mail='0' doc='1' print='0'>                        
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-branch_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-12">
							<select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
								<option value="all" <cfif isdefined("attributes.branch_id") and attributes.branch_id is 'all'>selected</cfif>><cf_get_lang dictionary_id='57453.Şube'></option>
								<cfoutput query="get_ssk_offices">
									<option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#BRANCH_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="DEPARTMENT_PLACE">
						<label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
						<div class="col col-12">
							<select name="department" id="department" style="width:120px;">
								<option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
								<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
									<cfquery name="get_departmant" datasource="#dsn#">
										SELECT * FROM DEPARTMENT WHERE BRANCH_ID = #attributes.branch_id# AND DEPARTMENT_STATUS = 1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
									</cfquery>
									<cfoutput query="get_departmant">
										<option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and (attributes.department eq get_departmant.DEPARTMENT_ID)>selected</cfif>>#DEPARTMENT_HEAD#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-inout_statue">
						<label class="col col-12"><cf_get_lang dictionary_id='53208.Giriş ve Çıkışlar'></label>
						<div class="col col-12">
							<select name="inout_statue" id="inout_statue">
								<option value=""><cf_get_lang dictionary_id='53208.Giriş ve Çıkışlar'></option>
								<option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
								<option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
								<option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id='53226.Aktif Çalışanlar'></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-duty_type">
						<label class="col col-12"><cf_get_lang dictionary_id='58538.Görev Tipi'></label>
						<div class="col col-12">
							<cf_multiselect_check 
								query_name="duty_type"  
								name="duty_type"
								width="135" 
								option_value="DUTY_TYPE_ID"
								option_name="DUTY_TYPE_NAME"
								value="#attributes.duty_type#">
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"> <cf_get_lang dictionary_id="46014.Çalışan Muhasebe Tanımları"> </cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></td>
					<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
					<!---<th width="85"><cf_get_lang dictionary_id ='613.TC Kimlik'></th>
					<th><cf_get_lang dictionary_id='44.Gerekçe'></th>--->
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57572.Departman'></th>
					<th><cf_get_lang dictionary_id='58538.Görev Tipi'></th>
					<th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
					<!---<th style="width:65px;"><cf_get_lang dictionary_id='315.Kıdem Baz'></th>--->
					<th><cf_get_lang dictionary_id='57628.Giriş Tarihi'></th>
					<th><cf_get_lang dictionary_id='29438.cıkıs tarihi'></th>
					<th><cfoutput>#getlang(1171,'Muhasebe Kod Grubu',54117)#</cfoutput></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_in_outs.recordcount>
				<cfset employee_id_list = ''>
				<cfoutput query="get_in_outs" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
					<cfif not listfind(employee_id_list,employee_id)>
						<cfset employee_id_list = listappend(employee_id_list,employee_id)>
					</cfif>
					<cfquery name="GET_POSITIONS" datasource="#dsn#">
						SELECT
							EMPLOYEE_POSITIONS.EMPLOYEE_ID,
							SETUP_POSITION_CAT.POSITION_CAT
						FROM
							EMPLOYEE_POSITIONS,
							SETUP_POSITION_CAT
						WHERE
							SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID AND
							EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND 
							EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (#employee_id_list#) AND
							EMPLOYEE_POSITIONS.IS_MASTER = 1
						ORDER BY
							EMPLOYEE_POSITIONS.EMPLOYEE_ID
					</cfquery>
					<cfset employee_id_list = listsort(listdeleteduplicates(valuelist(GET_POSITIONS.EMPLOYEE_ID,',')),'numeric','ASC',',')>
				</cfoutput>
				<cfoutput query="get_in_outs" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
					<tr <cfif len(FINISH_DATE)>style="color:red;"</cfif>>
						<td>#CURRENTROW#</td>
						<td><cfif len(FINISH_DATE)><font color="##FF0000">#employee_name# #employee_surname#</font><cfelse>#employee_name# #employee_surname#</cfif></td>
						<!---<td>#tc_identy_no#</td>
						<td>
							<cfif not len(finish_date)>
								<cfif len(ex_in_out_id)><cf_get_lang dictionary_id='371.Nakil'>
								<cfelse><cf_get_lang dictionary_id='372.Yeni Giriş'></cfif>
							<cfelse>
								#get_explanation_name(explanation_id)#
							</cfif>
						</td>--->
						<td>#branch_name#</td>
						<td>#department_head#</td>
						<td>
							<cfif duty_type eq 0>
								<cf_get_lang dictionary_id='53550.İşveren'>
								<cfelseif duty_type eq 1>	
								<cf_get_lang dictionary_id='53140.İşveren Vekili'>
								<cfelseif duty_type eq 2>
								<cf_get_lang dictionary_id='57576.Çalışan'>
								<cfelseif duty_type eq 3>
								<cf_get_lang dictionary_id='53152.Sendikalı'>
								<cfelseif duty_type eq 4>
								<cf_get_lang dictionary_id='53178.Sözleşmeli'>
								<cfelseif duty_type eq 5>
								<cf_get_lang dictionary_id='53169.Kapsam Dışı'>
								<cfelseif duty_type eq 6>
								<cf_get_lang dictionary_id='53182.Kısmi İstihdam'>
								<cfelseif duty_type eq 7>
								<cf_get_lang dictionary_id='53199.Taşeron'>
							</cfif>
						</td>
						<td>
							<cfif listfind(employee_id_list,employee_id)>
								#GET_POSITIONS.POSITION_CAT[listfind(employee_id_list,employee_id,',')]#
							</cfif>
						</td>
						<!---<td>#dateformat(KIDEM_DATE,dateformat_style)#</td>--->
						<td>#dateformat(START_DATE,dateformat_style)#</td>
						<td>#dateformat(FINISH_DATE,dateformat_style)#</td>
						<td>
							<cfquery name="get_bill" dbtype="query">
								SELECT * FROM get_account_bill WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id#">
							</cfquery>
							#get_bill.definition#
						</td>
						<!---<td>
							<cfif get_xml_control.property_value eq 0 and isdefined('get_expense_center')>
								<cfquery name="get_expense" dbtype="query">
									SELECT * FROM get_expense_center WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id#"> 
								</cfquery>
								#get_expense.EXPENSE_CODE_NAME#
							<cfelseif get_xml_control.property_value eq 1 and isdefined('get_expense_rows')>
								<cfquery name="get_expense" dbtype="query">
									SELECT * FROM get_expense_rows WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id#">
								</cfquery>
								<cfloop query="get_expense">
									#expense#-#rate#,
								</cfloop>
							</cfif>
						</td>--->
						<!-- sil -->
						<td align="center" nowrap="nowrap">
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.list_employee_accounts&event=upd&in_out_id=#get_in_outs.in_out_id#','medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
						</td>
						<!-- sil -->
					</tr>
				</cfoutput>
				</cfif>
				<cfif not get_in_outs.recordcount>
					<tr>
						<td colspan="14"><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id ='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset adres=attributes.fuseaction>
		<cfset adres = "#adres#&keyword=#attributes.keyword#">
		<cfset adres = "#adres#&hierarchy=#attributes.hierarchy#">
		<cfset adres = "#adres#&branch_id=#attributes.branch_id#">
		<cfset adres = "#adres#&inout_statue=#attributes.inout_statue#">
		<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
			<cfset adres = "#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
		</cfif>
		<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
			<cfset adres = "#adres#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
		</cfif>
		<cfif isdefined("attributes.record_startdate") and isdate(attributes.record_startdate)>
			<cfset adres = "#adres#&record_startdate=#dateformat(attributes.record_startdate,dateformat_style)#">
		</cfif>
		<cfif isdefined("attributes.record_finishdate") and isdate(attributes.record_finishdate)>
			<cfset adres = "#adres#&record_finishdate=#dateformat(attributes.record_finishdate,dateformat_style)#">
		</cfif>
		<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
	}
	
	function tarih_kontrol(date1,date2)
	{
		date_check
		if(date1<date2)
			{
				alert("<cf_get_lang dictionary_id='54641.tarih hatasi'>")
				return false;
			}
		else
			return true;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
