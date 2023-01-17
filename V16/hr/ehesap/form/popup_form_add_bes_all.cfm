<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cf_xml_page_edit fuseact="ehesap.list_emp_bes">
<cfparam name="attributes.duty_type" default="">
<cfparam name="attributes.func_id" default="">
<cfparam name="attributes.ssk_statute" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.pos_cat_id" default="">
<cfparam name="attributes.collar_type2" default="">
<cfparam name="attributes.branch_id2" default="">
<cfparam name="attributes.inout_statue" default="2">
<cfparam name="attributes.startdate" default="1/#month(now())#/#year(now())#">
<cfparam name="attributes.finishdate" default="#bu_ay_sonu#/#month(now())#/#year(now())#">
<cfparam name="attributes.birthdate" default="">
<cfif isdate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
<cfif isdate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
<cfif isdate(attributes.birthdate)><cf_date tarih = "attributes.birthdate"></cfif>

<cfsavecontent variable="message"><cf_get_lang dictionary_id="57576.Çalışan"></cfsavecontent>
<cfsavecontent variable="message2"><cf_get_lang dictionary_id="53140.İşveren Vekili"></cfsavecontent>
<cfsavecontent variable="message3"><cf_get_lang dictionary_id="53550.İşveren"></cfsavecontent>
<cfsavecontent variable="message4"><cf_get_lang dictionary_id="53152.Sendikalı"></cfsavecontent>
<cfsavecontent variable="message5"><cf_get_lang dictionary_id="53178.Sözleşmeli"></cfsavecontent>
<cfsavecontent variable="message6"><cf_get_lang dictionary_id="53169.Kapsam Dışı"></cfsavecontent>
<cfsavecontent variable="message7"><cf_get_lang dictionary_id="53182.Kısmi İstihdam"></cfsavecontent>
<cfsavecontent variable="message8"><cf_get_lang dictionary_id="53199.Taşeron"></cfsavecontent>
<cfsavecontent variable="message9"><cf_get_lang dictionary_id="54055.Mavi Yaka"></cfsavecontent>	
<cfsavecontent variable="message10"><cf_get_lang dictionary_id="54056.Beyaz Yaka"></cfsavecontent>
<script defer type="text/javascript" src="../JS/temp/multiselect/jquery.multiselect.filter.js"></script>
<script defer type="text/javascript" src="../JS/temp/multiselect/jquery.multiselect.js"></script>
<cfscript>
	duty_type = QueryNew("DUTY_TYPE_ID, DUTY_TYPE_NAME");
	QueryAddRow(duty_type,8);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",2,1);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message#",1);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",1,2);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#message2#',2);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",0,3);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#message3#',3);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",3,4);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#message4#',4);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",4,5);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#message5#',5);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",5,6);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#message6#',6);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",6,7);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#message7#',7);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",7,8);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#message8#',8);
	
	collar_type = QueryNew("COLLAR_TYPE_ID, COLLAR_TYPE_NAME");
	QueryAddRow(collar_type,2);
	QuerySetCell(collar_type,"COLLAR_TYPE_ID",1,1);
	QuerySetCell(collar_type,"COLLAR_TYPE_NAME","#message9#",1);
	QuerySetCell(collar_type,"COLLAR_TYPE_ID",2,2);
	QuerySetCell(collar_type,"COLLAR_TYPE_NAME",'#message10#',2);
		
	cmp_pos_cat = createObject("component","V16.hr.cfc.get_position_cat");
	cmp_pos_cat.dsn = dsn;
	all_pos_cats = cmp_pos_cat.get_position_cat();
	cmp_func = createObject("component","V16.hr.cfc.get_functions");
	cmp_func.dsn = dsn;
	get_func = cmp_func.get_function();
	cmp_title = createObject("component","V16.hr.cfc.get_titles");
	cmp_title.dsn = dsn;
	get_title = cmp_title.get_title();
</cfscript>

<cfinclude template="../query/get_all_branches.cfm">

<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
	<cfquery name="get_poscat_positions" datasource="#dsn#">
		SELECT DISTINCT
			E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,E.EMPLOYEE_NO,E.EMPLOYEE_ID,EIO.IN_OUT_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME
		FROM
			EMPLOYEES_IN_OUT EIO
			INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID=EIO.EMPLOYEE_ID
            LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = EIO.EMPLOYEE_ID
			LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID=EIO.DEPARTMENT_ID
			LEFT JOIN BRANCH B ON D.BRANCH_ID=B.BRANCH_ID
            <cfif len(attributes.birthdate)>
            	LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = EIO.EMPLOYEE_ID
            </cfif>
		WHERE
			1=1
			<cfif len(attributes.collar_type2) or len(attributes.pos_cat_id) or len(attributes.title_id) or len(attributes.func_id)>
				AND EP.IS_MASTER = 1	
			</cfif>
			<cfif len(attributes.branch_id2)>
				AND B.BRANCH_ID IN (#attributes.branch_id2#)
			</cfif>
			<cfif len(attributes.collar_type2)>
				AND EP.COLLAR_TYPE IN (#attributes.collar_type2#)
			</cfif>
			<cfif len(attributes.pos_cat_id)>
				AND EP.POSITION_CAT_ID IN (#attributes.pos_cat_id#)
			</cfif>
			<cfif len(attributes.title_id)>
				AND EP.TITLE_ID IN (#attributes.title_id#) 
			</cfif>
			<cfif isdefined("attributes.duty_type") and len(attributes.duty_type)>
				AND EIO.DUTY_TYPE IN (#attributes.duty_type#)
			</cfif>
			<cfif len(attributes.func_id)>
				AND EP.FUNC_ID IN (#attributes.func_id#) 
			</cfif>
			<cfif len(attributes.SSK_STATUTE)>
				AND EIO.SSK_STATUTE = #attributes.SSK_STATUTE#
			</cfif>
            <cfif len(attributes.birthdate) and isdate(attributes.birthdate)>
                AND EI.BIRTH_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.birthdate#">
                AND EI.BIRTH_DATE IS NOT NULL
            </cfif>
			<cfif isdefined("attributes.inout_statue") and attributes.inout_statue eq 1><!--- Girişler --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfif>
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 0><!--- Çıkışlar --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfif>
				AND	EIO.FINISH_DATE IS NOT NULL
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 2><!--- aktif calisanlar --->
				AND 
				(
					<cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
						<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE IS NULL
							)
						)
						<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
							EIO.FINISH_DATE IS NULL
							)
						)
						<cfelse>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE IS NULL
							)
							OR
							(
							EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
						)
						</cfif>
					<cfelse>
						EIO.FINISH_DATE IS NULL
					</cfif>
				)
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 3><!--- giriş ve çıkışlar Seçili ise --->
				AND 
				(
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
					)
					OR
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
					)
				)
			</cfif>
		ORDER BY
			EMPLOYEE_NAME
	</cfquery>	
</cfif>
<script type="text/javascript">
	<cfif isdefined("get_poscat_positions") and get_poscat_positions.recordcount>
		row_count=<cfoutput>#get_poscat_positions.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
	</cfif>
</script>
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="secmessage"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></cfsavecontent>
<cf_box title="#getLang('','BES','63079')#-#getLang('','Bireysel Emeklilik','63080')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="add_ext_salary_search" action="#request.self#?fuseaction=ehesap.popup_form_add_bes_all" method="post">
		<cf_box_search>
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
				<div class="form-group medium" id="item-position_type">
						<cf_multiselect_check 
						query_name="all_pos_cats"  
						name="pos_cat_id"
						width="150" 
						option_text="#secmessage#"
						option_value="POSITION_CAT_ID"
						option_name="POSITION_CAT"
						value="#attributes.pos_cat_id#">
				</div>
				<div class="form-group medium" id="item-collar_type">
					<cf_multiselect_check 
					query_name="collar_type"  
					name="collar_type2"
					width="100" 
					option_text="#getLang('','Yaka Tipi','43060')#"
					option_value="COLLAR_TYPE_ID"
					option_name="COLLAR_TYPE_NAME"
					value="#attributes.collar_type2#">
				</div>
				<div class="form-group small" id="item-branch_name">
					<cf_multiselect_check 
					query_name="get_all_branches"  
					name="branch_id2"
					width="150" 
					option_text="#getLang('','Şube','57453')#"
					option_value="BRANCH_ID"
					option_name="BRANCH_NAME"
					value="#attributes.branch_id2#">
				</div>
				<div class="form-group medium" id="item-duty_type">
					<cf_multiselect_check 
					query_name="duty_type"  
					name="duty_type"
					width="135" 
					option_text="#getLang('','Görev Tipi','58538')#"
					option_value="DUTY_TYPE_ID"
					option_name="DUTY_TYPE_NAME"
					value="#attributes.duty_type#">
				</div>
				<div class="form-group medium" id="item-unit_name">
					<cf_multiselect_check 
					query_name="get_func"  
					name="func_id"
					width="120" 
					option_text="#getLang('','Fonksiyon','58701')#"
					option_value="UNIT_ID"
					option_name="UNIT_NAME"
					value="#attributes.func_id#">
				</div>
				<div class="form-group medium" id="item-get_title">
					<cf_multiselect_check 
					query_name="get_title"  
					name="title_id"
					width="120" 
					option_text="#getLang('','Ünvan','57571')#"
					option_value="TITLE_ID"
					option_name="TITLE"
					value="#attributes.title_id#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_ext_salary_search' , #attributes.modal_id#)"),DE(""))#">
				</div>
		</cf_box_search>
		<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_ext_salary_search' , #attributes.modal_id#)"),DE(""))#">
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
				<div class="form-group" id="item-birthdate">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58727.Doğum Tarihi"></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="input-group">
							<cfinput type="text" name="birthdate" value="#dateFormat(attributes.birthdate,dateformat_style)#" maxlength="10" validate="#validate_style#" >
							<span class="input-group-addon">
								<cf_wrk_date_image date_field="birthdate">
							</span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-ssk_statute">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53553.SSK Statüsü'></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<select name="ssk_statute" id="ssk_statute">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfset count_ = 0>
							<cfloop list="#list_ucret()#" index="ccn">
								<cfset count_ = count_ + 1>
								<cfoutput><option value="#ccn#" <cfif attributes.ssk_statute eq ccn>selected</cfif>>#listgetat(list_ucret_names(),count_,'*')#</option></cfoutput>
							</cfloop>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-inout_statue">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55539.Çalışma Durumu'></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<select name="inout_statue" id="inout_statue">
							<option value="3"><cf_get_lang dictionary_id='29518.Girişler ve Çıkışlar'></option>
							<option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
							<option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
							<option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id='53226.Aktif Çalışanlar'></option>
						</select>
					</div>
				</div>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
				<div class="form-group" id="item-startdate">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
							<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
								<cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.startdate,dateformat_style)#">
							<cfelse>
								<cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#" >
							</cfif>
							<span class="input-group-addon">
								<cf_wrk_date_image date_field="startdate">
							</span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-finishdate">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
							<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
								<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
							<cfelse>
								<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#" >
							</cfif>
							<span class="input-group-addon">
								<cf_wrk_date_image date_field="finishdate">
							</span>
						</div>
					</div>
				</div>
			</div>
		</cf_box_search_detail>
    </cfform>
    <cfform name="add_ext_salary" action="#request.self#?fuseaction=ehesap.emptypopup_form_add_bes_all" method="post">
		<input type="hidden" name="draggable1" id="draggable1" value="#iif(isdefined("attributes.draggable"),1,0)#">
        <input name="record_num" id="record_num" type="hidden" value="0">
        <cf_grid_list>
            <thead>
				<tr>
					<th colspan="4"></th>
					<th>
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" value="1"  name="row_kontrol_0" id="row_kontrol_0">
								<input type="hidden" name="odkes_id0" id="odkes_id0" value="" />
								<input type="text" name="comment_pay0" id="comment_pay0" value="" readonly onChange="hepsi(row_count,'comment_pay');" onClick="hepsi(row_count,'comment_pay');" placeholder="<cf_get_lang dictionary_id='59665.BES Türü'>">
								<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_bes','medium');"></span>
							</div>
						</div>
					</th>
					<th>
						<div class="form-group">
							<select name="term0" id="term0" onChange="hepsi(row_count,'term')" onClick="hepsi(row_count,'term');">
								<cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="i">
								<cfoutput>
									<option value="#i#"<cfif session.ep.period_year eq i> selected</cfif>>#i#</option>
								</cfoutput>
								</cfloop>
							</select>
						</div>
					</th>
					<th>
						<div class="form-group">
							<select name="start_sal_mon0" id="start_sal_mon0" onChange="hepsi(row_count,'start_sal_mon');" onClick="hepsi(row_count,'start_sal_mon');">
								<cfloop from="1" to="12" index="j">
									<cfoutput><option value="#j#">#listgetat(ay_list(),j,',')#</option></cfoutput>
								</cfloop>
							</select>
						</div>
					</th>
					<th>
						<div class="form-group">
							<select name="end_sal_mon0" id="end_sal_mon0" onChange="hepsi(row_count,'end_sal_mon');" onClick="hepsi(row_count,'end_sal_mon');">
								<cfloop from="1" to="12" index="j">
								<cfoutput><option value="#j#">#listgetat(ay_list(),j,',')#</option></cfoutput>
								</cfloop>
							</select>
						</div>
					</th>
					<th>
						<div class="form-group">
							<input type="text" name="amount_pay0" id="amount_pay0"  class="moneybox" value="" onkeyup="hepsi(row_count,'amount_pay');return(FormatCurrency(this,event));"  onChange="hepsi(row_count,'amount_pay');" onClick="hepsi(row_count,'amount_pay');">
						</div>
					</th>
					<th>
						<cfquery name="GET_SOCIETIES" datasource="#DSN#">
							SELECT SOCIETY_ID,SOCIETY FROM SETUP_SOCIAL_SOCIETY ORDER BY SOCIETY
						</cfquery>
						<div class="form-group" id="society_type_0">
							<select name="society_type0" id="society_type0" onChange="hepsi(row_count,'society_type');" onClick="hepsi(row_count,'society_type');">
								<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
								<cfoutput query="GET_SOCIETIES">
									<option value="#SOCIETY_ID#">#SOCIETY#</option>
								</cfoutput>
							</select>
						</div>
					</th>
				</tr>
                <tr>
                    <th><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" onClick="add_row2();"></i></th>
                    <th style="width:80px;"><cf_get_lang dictionary_id='58487.Çalışan No'></th>
                    <th style="width:135px;"><cf_get_lang dictionary_id='57576.Çalışan'></th>
                    <th style="width:135px;"><cf_get_lang dictionary_id='57453.Şube'>/<cf_get_lang dictionary_id='57572.Departman'></th>
                    <th><cf_get_lang dictionary_id='59344.Otomatik BES'></th>
                    <th style="width:50px;"><cf_get_lang dictionary_id='58472.Dönem'></th>
                    <th style="width:65px;"><cf_get_lang dictionary_id='57501.Başlangıç'></th>
                    <th style="width:65px;"><cf_get_lang dictionary_id='57502.Bitiş'></th>
                    <th><cf_get_lang dictionary_id='45126.BES Oranı'></th>
					<th><cf_get_lang dictionary_id='62968.Sigorta Kurumu'></th>
                </tr>
            </thead>
            <tbody id="link_table">
                <cfif isdefined("attributes.is_submitted") and (get_poscat_positions.recordcount)>
                    <cfoutput query="get_poscat_positions">
                        <tr id="my_row_#currentrow#">
                            <td><a style="cursor:pointer" onclick="sil(#currentrow#);" ><i class="fa fa-minus"></i></a></td>
                            <td><input type="text" name="empno#currentrow#" id="empno#currentrow#" value="#employee_no#" style="width:80px;" readonly></td>
                            <td nowrap>
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" value="1" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#">
										<input type="hidden" name="odkes_id#currentrow#" id="odkes_id#currentrow#" value="" />
										<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="#employee_id#">
										<input type="hidden" name="employee_in_out_id#currentrow#" id="employee_in_out_id#currentrow#" value="#in_out_id#" style="width:20">
										<input name="employee#currentrow#" id="employee#currentrow#" type="text" style="width:120px;" readonly value="#employee_name# #employee_surname#"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript:windowopen('#request.self#?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=add_ext_salary.employee_in_out_id#currentrow#&field_emp_name=add_ext_salary.employee#currentrow#&field_emp_id=add_ext_salary.employee_id#currentrow#&field_branch_and_dep=add_ext_salary.department#currentrow#' ,'list');"></span>
									</div>
								</div>
                            </td>
                            <td><input type="text" name="department#currentrow#" id="department#currentrow#" value="#branch_name#/#department_head#" style="width:135px" readonly></td>
                            <td nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<input type="text" name="comment_pay#currentrow#" id="comment_pay#currentrow#" style="width:120px;" value="">
										<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_list_bes&row_id_=#currentrow#','medium');"></span>
									</div>
								</div>
                            </td>
                            <td>
								<div class="form-group" id="term_#currentrow#">
									<select name="term#currentrow#" id="term#currentrow#">
										<cfloop from="#year(now())-1#" to="#year(now())+2#" index="i">
											<option value="#i#"<cfif year(now()) eq i> selected</cfif>>#i#</option>
										</cfloop>
                                	</select>
								</div>
                          	</td>
                            <td>
								<div class="form-group" id="start_sal_mon_#currentrow#">
									<select name="start_sal_mon#currentrow#" id="start_sal_mon#currentrow#" style="width:65px;" onchange="change_mon('end_sal_mon#currentrow#',this.value);">
										<cfloop from="1" to="12" index="j">
										<option value="#j#">#listgetat(ay_list(),j,',')#</option>
										</cfloop>
									</select>
								</div>
                            </td>
                            <td>
								<div class="form-group" id="end_sal_mon_#currentrow#">
									<select name="end_sal_mon#currentrow#" id="end_sal_mon#currentrow#" style="width:65px;">
										<cfloop from="1" to="12" index="j">
											<option value="#j#">#listgetat(ay_list(),j,',')#</option>
										</cfloop>
                                	</select>
								</div>
                            </td>
                            <td><input type="text" name="amount_pay#currentrow#" id="amount_pay#currentrow#" style="width:90px;" class="moneybox" value=""  onkeyup="return(FormatCurrency(this,event));"></td>
							<td>
								<cfquery name="GET_SOCIETIES" datasource="#DSN#">
									SELECT SOCIETY_ID,SOCIETY FROM SETUP_SOCIAL_SOCIETY ORDER BY SOCIETY
								</cfquery>
								<div class="form-group" id="society_type_#currentrow#">
									<select name="society_type#currentrow#" id="society_type#currentrow#">
										<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
										<cfloop query="GET_SOCIETIES">
											<option value="#SOCIETY_ID#">#SOCIETY#</option>
										</cfloop>
									</select>
								</div>
							</td>
                          </tr>
                    </cfoutput>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
        </cf_box_footer>
    </cfform>

</cf_box>
<script type="text/javascript">
function hepsi(satir,nesne,baslangic)
{
	deger = document.getElementById(nesne + '0');
	if(deger.value.length!=0)/*değer boşdegilse çalıştır foru*/
	{
		if(!baslangic){baslangic=1;}/*başlangıc tüm elemanları değlde sadece bir veya bir kaçtane yapacaksak forun başlayacağı sayıyı vererek okadar dönmesini sağlayabilirz*/
		for(var i=baslangic;i<=satir;i++)
		{
			nesne_tarih=eval('document.getElementById( nesne + i )');
			nesne_tarih.value=deger.value;
		}
	}
}
	
function sil(sy)
{
	var my_element=eval("add_ext_salary.row_kontrol_"+sy);
	my_element.value=0;
	var my_element=eval("my_row_"+sy);
	my_element.style.display="none";
}

function add_row(comment_pay,term,start_sal_mon,end_sal_mon,amount_pay,row_id_,odkes_id,society_type)
{
	if(row_count == 0)
	{
		alert("<cf_get_lang dictionary_id='53611.Satır Eklemediniz'>!");
		return false;
	}
	if(row_id_ != undefined && row_id_ != '')
	{	
		document.getElementById('odkes_id'+row_id_).value = odkes_id;
		document.getElementById('term'+row_id_).value = term ;
		document.getElementById('comment_pay'+row_id_).value = comment_pay;
		document.getElementById('start_sal_mon'+row_id_).value = start_sal_mon;
		document.getElementById('end_sal_mon'+row_id_).value = end_sal_mon;
		document.getElementById('amount_pay'+row_id_).value = amount_pay;
		document.getElementById('society_type'+row_id_).value = society_type;

	}
	else
	{
		document.getElementById('comment_pay0').value=comment_pay;
		hepsi(row_count,'comment_pay');
		document.getElementById('odkes_id0').value=odkes_id;
		hepsi(row_count,'odkes_id');
		document.getElementById('term0').value=term;
		hepsi(row_count,'term');
		document.getElementById('start_sal_mon0').value=start_sal_mon;
		hepsi(row_count,'start_sal_mon');
		document.getElementById('end_sal_mon0').value=end_sal_mon;
		hepsi(row_count,'end_sal_mon');
		document.getElementById('amount_pay0').value=amount_pay;
		hepsi(row_count,'amount_pay');
		document.getElementById('society_type0').value=society_type;
		hepsi(row_count,'society_type');
	}
}
	
function add_row2()
{
	row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
	newRow.setAttribute("name","my_row_" + row_count);
	newRow.setAttribute("id","my_row_" + row_count);		
	newRow.setAttribute("NAME","my_row_" + row_count);
	newRow.setAttribute("ID","my_row_" + row_count);		
				
	document.getElementById('record_num').value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><i class="fa fa-minus"></i></a>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" id="empno' + row_count + '" name="empno' + row_count + '" style="width:80px;" readonly value="">';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.style.whiteSpace = 'nowrap';
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="employee_in_out_id' + row_count +'" id="employee_in_out_id' + row_count +'" style="width:10px;" value=""><input type="text" onFocus="AutoComplete_Create(\'employee'+ row_count +'\',\'MEMBER_NAME\',\'MEMBER_PARTNER_NAME3\',\'get_member_autocomplete\',\'3\',\'EMPLOYEE_ID,IN_OUT_ID,BRANCH_DEPT\',\'employee_id' + row_count +',employee_in_out_id' + row_count +',department' + row_count +'\',\'my_week_timecost\',3,116);" name="employee' + row_count +'" id="employee' + row_count +'" style="width:120px;" value=""><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen(\'<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out</cfoutput>&field_in_out_id=add_ext_salary.employee_in_out_id'+row_count+'&field_emp_name=add_ext_salary.employee'+ row_count + '&field_emp_id=add_ext_salary.employee_id'+ row_count + '&field_emp_no=add_ext_salary.empno'+row_count + '&field_branch_and_dep=add_ext_salary.department'+ row_count + '\' ,\'list\');"></span><input type="Hidden" name="odkes_id' + row_count +'" id="odkes_id' + row_count +'" value=""><input type="hidden" value="" name="employee_id' + row_count +'" id="employee_id' + row_count +'"><input  type="hidden"  value="1"  name="row_kontrol_' + row_count +'" id="row_kontrol_' + row_count +'"></div></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="department' + row_count +'" id="department' + row_count +'" style="width:120px;" readonly value="">';
		
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.style.whiteSpace = 'nowrap';
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="comment_pay' + row_count +'" id="comment_pay' + row_count +'" style="width:120px;" readonly value=""><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="send_bes('+row_count+');"></span></div></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="term' + row_count +'" id="term' + row_count +'"><cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j"><option value="<cfoutput>#j#</cfoutput>" <cfif session.ep.period_year eq j>selected</cfif>><cfoutput>#j#</cfoutput></option></cfloop></select></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="start_sal_mon' + row_count +'" id="start_sal_mon' + row_count +'" style="width:65px;" onchange="change_mon(\'end_sal_mon'+row_count+'\',this.value);"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="end_sal_mon' + row_count +'" id="end_sal_mon' + row_count +'" style="width:65px;"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select></div>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input name="amount_pay' + row_count +'" id="amount_pay' + row_count +'" type="text" style="width:90px;" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event));">';
	
	newCell = newRow.insertCell(newRow.cells.length);
	<cfquery name="GET_SOCIETIES" datasource="#DSN#">SELECT SOCIETY_ID,SOCIETY FROM SETUP_SOCIAL_SOCIETY ORDER BY SOCIETY</cfquery>
	newCell.innerHTML = '<div class="form-group"><select name="society_type' + row_count +'" id="society_type' + row_count +'" ><option value=""><cf_get_lang dictionary_id='57734.seçiniz'> </option> <cfoutput query="GET_SOCIETIES"> <option value="#SOCIETY_ID#"> #SOCIETY#</option></cfoutput></select></div>';			
	hepsi(row_count,'comment_pay',row_count);
	hepsi(row_count,'term',row_count);
	hepsi(row_count,'start_sal_mon',row_count);
	hepsi(row_count,'end_sal_mon',row_count);
	hepsi(row_count,'amount_pay',row_count);
	hepsi(row_count,'society_type',row_count);
	hepsi(row_count,'odkes_id',row_count);
	odenek_text=eval("document.add_ext_salary.comment_pay"+ row_count);
	odenek_text.focus();
	return true;
}
function send_bes(row_count)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_bes&row_id_='+ row_count,'medium');
}
function kontrol()
{
	document.getElementById('record_num').value=row_count;
	if(row_count == 0)
	{
		alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='59665.BES Türü'>");
		return false;
	}
	for(var i=1;i<=row_count;i++)
	{
		 if($('#row_kontrol_'+i).val() == 1 && eval("document.add_ext_salary.amount_pay"+i).value.length == 0)
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='59665.BES Türü'>");
				return false;
			}
	}
	for(var i=1;i<=row_count;i++)
	{
		nesne=eval("document.add_ext_salary.amount_pay"+i);
		nesne.value=filterNum(nesne.value);
	}

	for(var i=1;i<=row_count;i++)
	{
		var new_sql = "SELECT DATEDIFF(YEAR,BIRTH_DATE,GETDATE()) AS YAS,* FROM EMPLOYEES_IDENTY WHERE EMPLOYEE_ID ="+$('#employee_id'+i).val();
		var get_age = wrk_query(new_sql,'dsn');
		var xml_bes_age = <cfoutput>#xml_bes_definition_age#</cfoutput>;
		var emp_age_ = get_age.YAS[0];
		if (emp_age_ > xml_bes_age)
		{
			alert(i + '.satırdaki çalışanın <cf_get_lang dictionary_id="40114.Çalışan Yaşı">' + xml_bes_age + ' <cf_get_lang dictionary_id="64067.yaşından büyük olduğu için Bes sistemine dahil edilemez.">');
			return false;
		}
	}
	return true;
}
	function change_mon(id,i)
	{
		$('#'+id).val(i);
	}	
</script>