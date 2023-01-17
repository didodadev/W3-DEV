<cf_xml_page_edit fuseact="ehesap.popup_form_add_kesinti_all">
	<cfscript>
		bu_ay_basi = CreateDate(year(now()),month(now()),1);
		bu_ay_sonu = DaysInMonth(bu_ay_basi);
	</cfscript>
	<cfset cmp_process = createObject('component','V16.workdata.get_process')>
	<cfset get_process_stage = cmp_process.GET_PROCESS_TYPES(faction_list : 'ehesap.list_payments')>
	<cfset periods = createObject('component','V16.objects.cfc.periods')>
	<cfset period_years = periods.get_period_year()>
	<cfparam name="attributes.duty_type" default="">
	<cfparam name="attributes.func_id" default="">
	<cfparam name="attributes.title_id" default="">
	<cfparam name="attributes.pos_cat_id" default="">
	<cfparam name="attributes.collar_type" default="">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.inout_statue" default="2">
	<cfparam name="attributes.startdate" default="1/#month(now())#/#year(now())#">
	<cfparam name="attributes.finishdate" default="#bu_ay_sonu#/#month(now())#/#year(now())#">
	<cfif isdate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
	<cfif isdate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
	
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
	
	<cfscript>
		duty_type = QueryNew("DUTY_TYPE_ID, DUTY_TYPE_NAME");
		QueryAddRow(duty_type,8);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",2,1);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message#",1);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",1,2);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message2#",2);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",0,3);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message3#",3);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",3,4);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message4#",4);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",4,5);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message5#",5);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",5,6);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message6#",6);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",6,7);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message7#",7);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",7,8);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message8#",8);
		
		collar_type = QueryNew("COLLAR_TYPE_ID, COLLAR_TYPE_NAME");
		QueryAddRow(collar_type,2);
		QuerySetCell(collar_type,"COLLAR_TYPE_ID",1,1);
		QuerySetCell(collar_type,"COLLAR_TYPE_NAME","#message9#",1);
		QuerySetCell(collar_type,"COLLAR_TYPE_ID",2,2);
		QuerySetCell(collar_type,"COLLAR_TYPE_NAME","#message10#",2);
		
		bu_ay_basi = CreateDate(year(now()),month(now()),1);
		bu_ay_sonu = DaysInMonth(bu_ay_basi);
		
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
			SELECT
				E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,E.EMPLOYEE_NO,E.EMPLOYEE_ID,EIO.IN_OUT_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME
			FROM
				EMPLOYEES_IN_OUT EIO
				INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID=EIO.EMPLOYEE_ID
				LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = EIO.EMPLOYEE_ID
				LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID=EIO.DEPARTMENT_ID
				LEFT JOIN BRANCH B ON D.BRANCH_ID=B.BRANCH_ID
			WHERE
				1=1
				<cfif len(attributes.collar_type) or len(attributes.pos_cat_id) or len(attributes.title_id) or len(attributes.func_id)>
					AND EP.IS_MASTER = 1	
				</cfif>
				<cfif len(attributes.branch_id)>
					AND B.BRANCH_ID IN (#attributes.branch_id#)
				</cfif>
				<cfif len(attributes.collar_type)>
					AND EP.COLLAR_TYPE IN (#attributes.collar_type#)
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
	<cf_catalystHeader>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#getLang('','Toplu Kesinti','52968')#">
			<cfform name="add_ext_salary_search" action="#request.self#?fuseaction=ehesap.list_interruption&event=add" method="post">
				<input type="hidden" name="is_submitted" id="is_submitted" value="1">
				<cf_box_elements>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-pos_cat_id">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label></div>
							<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
								<cf_multiselect_check 
								query_name="all_pos_cats"  
								name="pos_cat_id"
								option_text="#getLang('','Seçiniz','57734')#"
								option_value="POSITION_CAT_ID"
								option_name="POSITION_CAT"
								value="#attributes.pos_cat_id#">
							</div>
						</div>
						<div class="form-group" id="item-collar_type">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='30928.Yaka Tipi'></label></div>
							<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
								<cf_multiselect_check 
								query_name="collar_type"  
								name="collar_type"
								option_text="#getLang('','Seçiniz','57734')#"
								option_value="COLLAR_TYPE_ID"
								option_name="COLLAR_TYPE_NAME"
								value="#attributes.collar_type#">
							</div>
						</div>
						<div class="form-group" id="item-branch_id">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57453.Şube'></label></div>
							<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
								<cf_multiselect_check 
								query_name="get_all_branches"  
								name="branch_id"
								option_text="#getLang('','Seçiniz','57734')#"
								option_value="BRANCH_ID"
								option_name="BRANCH_NAME"
								value="#attributes.branch_id#">
							</div>
						</div>
						<div class="form-group" id="item-duty_type">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='58538.Görev Tipi'></label></div>
							<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
								<cf_multiselect_check 
								query_name="duty_type"  
								name="duty_type"
								option_value="DUTY_TYPE_ID"
								option_text="#getLang('','Seçiniz','57734')#"
								option_name="DUTY_TYPE_NAME"
								value="#attributes.duty_type#">
							</div>
						</div>
						<div class="form-group" id="item-inout_statue">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id="55539.Çalışma Durumu"></label></div>
							<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
								<select name="inout_statue" id="inout_statue">
									<option value="3"><cf_get_lang dictionary_id='29518.Girişler ve Çıkışlar'></option>
									<option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
									<option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
									<option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id='55905.Aktif Çalışanlar'></option>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-title_id">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57571.Ünvan'></label></div>
							<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
								<cf_multiselect_check 
								query_name="get_title"  
								name="title_id"
								option_text="#getLang('','Seçiniz','57734')#"
								option_value="TITLE_ID"
								option_name="TITLE"
								value="#attributes.title_id#">
							</div>
						</div>
						<div class="form-group" id="item-func_id">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='58701.Fonksiyon'></label></div>
							<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
								<cf_multiselect_check 
								query_name="get_func"  
								name="func_id"
								option_text="#getLang('','Seçiniz','57734')#"
								option_value="UNIT_ID"
								option_name="UNIT_NAME"
								value="#attributes.func_id#">
							</div>
						</div>
						<div class="form-group" id="item-startdate">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label></div>
							<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
									<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
										<cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.startdate,dateformat_style)#">
									<cfelse>
										<cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#" >
									</cfif>
									<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-finishdate">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label></div>
							<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
									<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
										<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
									<cfelse>
										<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#" >
									</cfif>
									<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
								</div>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cfinput type="submit" class=" ui-wrk-btn ui-wrk-btn-success" name="gonder" value="#getLang('','Kesinti Yapılacak Çalışanları Listele','63288')#">
				</cf_box_footer>
			</cfform>
		</cf_box>
		<cf_box title="#getLang('','Çalışanlar','58875')#-&nbsp#getLang('','kesintiler','38977')#">
			<cfform name="add_ext_salary" action="#request.self#?fuseaction=ehesap.emptypopup_form_add_kesinti_all" method="post">
				<input name="record_num" id="record_num" type="hidden" value="0">
				<cf_box_elements>
					<div id="show_img_baslik1" style="display:none;">
						<div id="show_img0" style="display:none;">
							<input type="hidden" name="show0" id="show0" value="0">
						</div>
					</div>
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53275.Kesinti Türü'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" value="1"  name="row_kontrol_0" id="row_kontrol_0">
									<input type="hidden" name="odkes_id0" id="odkes_id0" value="" />
									<input type="text" name="comment_pay0" id="comment_pay0"  value="" readonly onChange="hepsi(row_count,'comment_pay');" onClick="hepsi(row_count,'comment_pay');">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_kesinti');"></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="term0" id="term0" onChange="hepsi(row_count,'term')" onClick="hepsi(row_count,'term');">
									<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
									<cfoutput>
										<option value="#i#"<cfif session.ep.period_year eq i> selected</cfif>>#i#</option>
									</cfoutput>
									</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-process">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process is_upd='0' is_detail='0' select_name="process_stage0" onclick_function="hepsi(row_count,'process_stage')">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="start_sal_mon0" id="start_sal_mon0" onChange="hepsi(row_count,'start_sal_mon');" onClick="hepsi(row_count,'start_sal_mon');">
									<cfloop from="1" to="12" index="j">
										<cfoutput><option value="#j#">#listgetat(ay_list(),j,',')#</option></cfoutput>
									</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="end_sal_mon0" id="end_sal_mon0" onChange="hepsi(row_count,'end_sal_mon');" onClick="hepsi(row_count,'end_sal_mon');">
									<cfloop from="1" to="12" index="j">
									<cfoutput><option value="#j#">#listgetat(ay_list(),j,',')#</option></cfoutput>
									</cfloop>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="text" name="amount_pay0" id="amount_pay0" class="moneybox" value="" onkeyup="hepsi(row_count,'amount_pay');toplam_hesapla();return(FormatCurrency(this,event));"  onChange="hepsi(row_count,'amount_pay');toplam_hesapla();" onClick="hepsi(row_count,'amount_pay');toplam_hesapla();">
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30368.Çalışan'> <cf_get_lang dictionary_id='29534.Tutar'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="sabit_company_id0" id="sabit_company_id0" value="">
									<input type="hidden" name="sabit_consumer_id0" id="sabit_consumer_id0" value="">
									<cfinput name="sabit_member_name0" id="sabit_member_name0" type="hidden" value="">
									<input type="text" name="total_emp" id="total_emp" value="" class="text-right" readonly="readonly">
									<span class="input-group-addon">/</span>
									<input type="text" name="total_amount" id="total_amount" value="" class="text-right" readonly="readonly">
								</div>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_grid_list>
					<thead>
						<tr>
							<th width="25" class="text-center"><i class="fa fa-plus" onClick="add_row2();"></i></th>
							<th style="width:80px;"><cf_get_lang dictionary_id='58487.Çalışan No'></th>
							<th style="width:135px;"><cf_get_lang dictionary_id='57576.Çalışan'></th>
							<th style="width:135px;"><cf_get_lang dictionary_id='57453.Şube'>/<cf_get_lang dictionary_id='57572.Departman'></th>
							<th id="show_img_baslik2" style="display:none;width:20px" class="text-center"><i class="fa fa-check"></i></th>
							<th style="width:100px;"><cf_get_lang dictionary_id='53083.Kesinti'></th>
							<th style="width:100px;"><cf_get_lang dictionary_id='57629.Açıklama'></th>
							<th style="width:50px;"><cf_get_lang dictionary_id='58472.Dönem'></th>
							<th style="width:65px;"><cf_get_lang dictionary_id='57501.Başlangıç'></th>
							<th style="width:65px;"><cf_get_lang dictionary_id='57502.Bitiş'></th>
							<th style="width:100px;"><cf_get_lang dictionary_id='57673.Tutar'></th>
							<th style="width:120px;" nowrap="nowrap"><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
							<th style="width:120px;" nowrap="nowrap"><cf_get_lang dictionary_id ='58859.Süreç'></th>
						</tr>
					</thead>
					<tbody id="link_table">
						<cfif isdefined("attributes.is_submitted") and (get_poscat_positions.recordcount)>
							<cfoutput query="get_poscat_positions">
								<tr id="my_row_#currentrow#">
									<td width="25" class="text-center"><a style="cursor:pointer" onclick="sil(#currentrow#);" ><i class="fa fa-minus"></i></a></td>
									<td><input type="text" name="empno#currentrow#" id="empno#currentrow#" value="#employee_no#" style="width:80px;" readonly></td>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="odkes_id#currentrow#" id="odkes_id#currentrow#" value="" />
												<input type="hidden" value="1" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#">
												<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="#employee_id#">
												<input type="hidden" name="employee_in_out_id#currentrow#" id="employee_in_out_id#currentrow#" value="#in_out_id#" style="width:20">
												<input name="employee#currentrow#" id="employee#currentrow#" type="text" style="width:120px;" readonly value="#employee_name# #employee_surname#">
												<span class="input-group-addon btnPointer icon-ellipsis" href="javascript:openBoxDraggable('#request.self#?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=add_ext_salary.employee_in_out_id#currentrow#&field_emp_name=add_ext_salary.employee#currentrow#&field_emp_id=add_ext_salary.employee_id#currentrow#&field_branch_and_dep=add_ext_salary.department#currentrow#');"></span>
											</div>
										</div>
									</td>
									<td><input type="text" name="department#currentrow#" id="department#currentrow#" value="#branch_name#/#department_head#" style="width:135px" readonly></td>
									<td id="show_img#currentrow#" style="display:none;" class="text-center">
										<i class="fa fa-check" style="color:red;"></i>
									</td>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="show#currentrow#" id="show#currentrow#" value="0">
												<input type="text" name="comment_pay#currentrow#" id="comment_pay#currentrow#" style="width:120px;" value="">
												<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.popup_list_kesinti&row_id_=#currentrow#');"></span>
											</div>
										</div>
									</td>
									<td><input type="text" name="detail#currentrow#" id="detail#currentrow#" style="width:90px;" value=""></td>
									<td>
										<div class="form-group">
											<select name="term#currentrow#" id="term#currentrow#">
												<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
													<option value="#i#"<cfif year(now()) eq i> selected</cfif>>#i#</option>
												</cfloop>
											</select>
										</div>
									</td>
									<td>
										<div class="form-group">
											<select name="start_sal_mon#currentrow#" id="start_sal_mon#currentrow#" style="width:65px;" onchange="change_mon('end_sal_mon#currentrow#',this.value);">
												<cfloop from="1" to="12" index="j">
												<option value="#j#">#listgetat(ay_list(),j,',')#</option>
												</cfloop>
											</select>
										</div>
									</td>
									<td>
										<div class="form-group">
											<select name="end_sal_mon#currentrow#" id="end_sal_mon#currentrow#" style="width:65px;">
												<cfloop from="1" to="12" index="j">
												<option value="#j#">#listgetat(ay_list(),j,',')#</option>
												</cfloop>
											</select>
										</div>
									</td>
									<td>
										<div class="form-group">
											<input type="text" name="amount_pay#currentrow#" id="amount_pay#currentrow#" class="moneybox" value="" onclick="toplam_hesapla();" onchange="toplam_hesapla();" onkeyup="toplam_hesapla();return(FormatCurrency(this,event));">
										</div>
									</td>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="sabit_company_id#currentrow#" id="sabit_company_id#currentrow#" value="">
												<input type="hidden" name="sabit_consumer_id#currentrow#" id="sabit_consumer_id#currentrow#" value="">
												<cfinput name="sabit_member_name#currentrow#" id="sabit_member_name#currentrow#" type="text" value="" style="width:100px;" onFocus="AutoComplete_Create('sabit_member_name#currentrow#','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','sabit_company_id#currentrow#,sabit_consumer_id#currentrow#','','3','180','');">
												<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=add_ext_salary.sabit_member_name#currentrow#&field_consumer=add_ext_salary.sabit_consumer_id#currentrow#&field_comp_id=add_ext_salary.sabit_company_id#currentrow#&field_member_name=add_ext_salary.sabit_member_name#currentrow#')"></span>
											</div>
										</div>
									</td>
									<td>
										<cf_workcube_process is_upd='0' select_value='' process_cat_width='188' is_detail='0' select_name="process_stage#currentrow#" select_id="process_stage">
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
	</div>
	<script type="text/javascript">
	function hepsi(satir,nesne,baslangic)
	{
		deger = document.getElementById(nesne + '0');
		//deger=eval("document.add_ext_salary."+nesne+"0");
		if(deger.value.length!=0)/*değer boşdegilse çalıştır foru*/
		{
			if(!baslangic){baslangic=1;}/*başlangıc tüm elemanları değlde sadece bir veya bir kaçtane yapacaksak forun başlayacağı sayıyı vererek okadar dönmesini sağlayabilirz*/
			for(var i=baslangic;i<=satir;i++)
			{
				//nesne_tarih=eval("document.add_ext_salary."+nesne+i);
				//nesne_tarih.value=deger.value;
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
		toplam_hesapla();
	}
	
	function goster(show)
	{
		if(show==1)
		{
			show_img_baslik1.style.display='';
			show_img_baslik2.style.display='';
			for(var i=0;i<=row_count;i++)
			{
				satir=eval("show_img"+i);
				satir.style.display='';
			}
		}
		else
		{
			show_img_baslik1.style.display='none';
			show_img_baslik2.style.display='none';
			for(var i=0;i<=row_count;i++)
			{
				satir=eval("document.getElementById('show_img" + i + "')");
				satir.style.display='none';
			}
		}
	}
	
	function add_row(from_salary,show,comment_pay,period_pay,method_pay,term,start_sal_mon,end_sal_mon,amount_pay,calc_days,ehesap,row_id_,account_code,company_id,fullname,account_name,consumer_id,money,acc_type_id,tax,odkes_id)
	{
		if(row_count == 0)
		{
			alert("<cf_get_lang dictionary_id='53611.Satır Eklemediniz'>!");
			return false;
		} 
		if(row_id_ != undefined && row_id_ != '')
		{	
			document.getElementById('show'+row_id_).value = show;
			document.getElementById('odkes_id'+row_id_).value = odkes_id;
			//eval("document.add_ext_salary.show"+row_id_).value=show;
			<!---<cfif xml_from_salary eq 1>
			eval("document.add_ext_salary.from_salary"+row_id_).value=from_salary;
			</cfif>--->
			/*eval("document.add_ext_salary.period_pay"+row_id_).value=period_pay;
			eval("document.add_ext_salary.method_pay"+row_id_).value=method_pay;
			eval("document.add_ext_salary.term"+row_id_).value=term;*/
			document.getElementById('term'+row_id_).value = term ;
			document.getElementById('comment_pay'+row_id_).value = comment_pay;
			document.getElementById('start_sal_mon'+row_id_).value = start_sal_mon;
			document.getElementById('end_sal_mon'+row_id_).value = end_sal_mon;
			document.getElementById('amount_pay'+row_id_).value = amount_pay;
			//document.getElementById('calc_days'+row_id_).value = calc_days;
			document.getElementById('odkes_id'+row_id_).value = odkes_id;
			if(company_id != ''){document.getElementById('sabit_company_id'+row_id_).value = company_id;}
			if(consumer_id != ''){document.getElementById('sabit_consumer_id'+row_id_).value = consumer_id;}
			if(company_id != '' || consumer_id != ''){document.getElementById('sabit_member_name'+row_id_).value = fullname;}
			/*eval("document.add_ext_salary.comment_pay"+row_id_).value=comment_pay;
			eval("document.add_ext_salary.start_sal_mon"+row_id_).value=start_sal_mon;
			eval("document.add_ext_salary.end_sal_mon"+row_id_).value=end_sal_mon;
			eval("document.add_ext_salary.amount_pay"+row_id_).value=amount_pay;
			eval("document.add_ext_salary.calc_days"+row_id_).value=calc_days;*/
		}
		else
		{
			document.getElementById('show0').value=show;
			goster(show);
			hepsi(row_count,'show');
			<!---<cfif xml_from_salary eq 1>
			document.getElementById('from_salary0').value=from_salary;
			hepsi(row_count,'from_salary');
			</cfif>--->
			document.getElementById('comment_pay0').value=comment_pay;
			hepsi(row_count,'comment_pay');
			document.getElementById('odkes_id0').value=odkes_id;
			hepsi(row_count,'odkes_id');
			/*document.getElementById('period_pay0').value=period_pay;
			hepsi(row_count,'period_pay');
			document.getElementById('method_pay0').value=method_pay;
			hepsi(row_count,'method_pay');*/
			document.getElementById('term0').value=term;
			hepsi(row_count,'term');
			document.getElementById('start_sal_mon0').value=start_sal_mon;
			hepsi(row_count,'start_sal_mon');
			document.getElementById('end_sal_mon0').value=end_sal_mon;
			hepsi(row_count,'end_sal_mon');
			document.getElementById('amount_pay0').value=amount_pay;
			hepsi(row_count,'amount_pay');
			/*document.getElementById('calc_days0').value=calc_days;
			hepsi(row_count,'calc_days');*/
			if(company_id != '')
			{
				document.getElementById('sabit_company_id0').value=company_id;
				hepsi(row_count,'sabit_company_id');
			}
			if(consumer_id != '')
			{
				document.getElementById('sabit_consumer_id0').value=consumer_id;
				hepsi(row_count,'sabit_consumer_id');
			}
			if(company_id != '' || consumer_id != '')
			{
				document.getElementById('sabit_member_name0').value=fullname;
				hepsi(row_count,'sabit_member_name');
			}
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
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="employee_in_out_id' + row_count +'" id="employee_in_out_id' + row_count +'" style="width:10px;" value=""><input type="text" onFocus="AutoComplete_Create(\'employee'+ row_count +'\',\'MEMBER_NAME\',\'MEMBER_PARTNER_NAME3\',\'get_member_autocomplete\',\'3\',\'EMPLOYEE_ID,IN_OUT_ID,BRANCH_DEPT\',\'employee_id' + row_count +',employee_in_out_id' + row_count +',department' + row_count +'\',\'my_week_timecost\',3,116);" name="employee' + row_count +'" id="employee' + row_count +'" style="width:120px;" value=""><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable(\'<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out</cfoutput>&field_in_out_id=add_ext_salary.employee_in_out_id'+row_count+'&field_emp_name=add_ext_salary.employee'+ row_count + '&field_emp_id=add_ext_salary.employee_id'+ row_count + '&field_emp_no=add_ext_salary.empno'+row_count + '&field_branch_and_dep=add_ext_salary.department'+ row_count + '\');"></a><input type="Hidden" name="odkes_id' + row_count +'" id="odkes_id' + row_count +'" value=""><input type="hidden" value="" name="employee_id' + row_count +'" id="employee_id' + row_count +'"><input  type="hidden"  value="1"  name="row_kontrol_' + row_count +'" id="row_kontrol_' + row_count +'"></span></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="department' + row_count +'" id="department' + row_count +'" style="width:120px;" readonly value="">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","show_img" + row_count);
		newCell.setAttribute("class","text-center");
		newCell.innerHTML = '<i class="fa fa-check" style="color:red"></i>';
		if(document.getElementById('show0').value==0)/* eklerken satırı show0 değerini göre resim gözüksün gözükmesin ayarı*/
		{
			satir=eval("show_img"+row_count);
			satir.style.display='none';
		}
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.whiteSpace = 'nowrap';
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="show' + row_count +'" id="show' + row_count +'" value="0"><input type="text" name="comment_pay' + row_count +'" id="comment_pay' + row_count +'" style="width:120px;" readonly value=""><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="send_kesinti('+row_count+');"></span></div></div>';
		<!---<cfif xml_from_salary eq 1>
		newCell = newRow.insertCell();
		newCell.innerHTML ='<select name="from_salary'+ row_count +'" id="from_salary'+ row_count +'" style="width:50px;"><option value="0"><cf_get_lang_main no="671.Net"></option><option value="1"><cf_get_lang no="185.Brüt"></option></select>';
		</cfif>--->
		/*newCell = newRow.insertCell();
		newCell.innerHTML = '<select name="period_pay' + row_count +'" id="period_pay' + row_count +'" style="width:60px;"><option value="1"><cf_get_lang no="365.Ayda"></option><option value="2">3 <cf_get_lang no="365.Ayda"></option><option value="3">6 <cf_get_lang no="365.Ayda"></option><option value="4"><cf_get_lang no="366.Yılda"></option></select>';
		
		newCell = newRow.insertCell();
		newCell.innerHTML = '<select name="method_pay' + row_count +'" id="method_pay' + row_count +'" style="width:75px;"><option value="1"><cf_get_lang no="190.Artı"></option><option value="2">%</option></select>';
	*/
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="detail' + row_count +'" id="detail' + row_count +'" value="">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="term' + row_count +'" id="term' + row_count +'"><cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="j"><option value="<cfoutput>#j#</cfoutput>" <cfif session.ep.period_year eq j>selected</cfif>><cfoutput>#j#</cfoutput></option></cfloop></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="start_sal_mon' + row_count +'" id="start_sal_mon' + row_count +'" style="width:65px;" onchange="change_mon(\'end_sal_mon'+row_count+'\',this.value);"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="end_sal_mon' + row_count +'" id="end_sal_mon' + row_count +'" style="width:65px;"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input name="amount_pay' + row_count +'" id="amount_pay' + row_count +'" type="text" style="width:90px;" class="moneybox" value="" onclick="toplam_hesapla();" onchange="toplam_hesapla();" onkeyup="toplam_hesapla();return(FormatCurrency(this,event));"></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("noWrap",true) 
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="sabit_company_id' + row_count +'" id="sabit_company_id' + row_count + '" value=""> <input type="hidden" name="sabit_consumer_id'+row_count+'" id="sabit_consumer_id'+row_count+'" value=""><input name="sabit_member_name'+row_count+'" id="sabit_member_name'+row_count+'" type="text" value="" style="width:100px;"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=add_ext_salary.sabit_member_name'+row_count+'&field_consumer=add_ext_salary.sabit_consumer_id'+row_count+'&field_comp_id=add_ext_salary.sabit_company_id'+row_count+'&field_member_name=add_ext_salary.sabit_member_name'+row_count+'\')"></span></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="process_stage' + row_count +'"  id="process_stage"><cfoutput query="get_process_stage"><option value="#process_row_id#">#stage#</option></cfoutput></select></div>';
		

		hepsi(row_count,'show',row_count);
		<!---<cfif xml_from_salary eq 1>
		hepsi(row_count,'from_salary',row_count);
		</cfif>--->
		hepsi(row_count,'comment_pay',row_count);
		/*hepsi(row_count,'period_pay',row_count);
		hepsi(row_count,'method_pay',row_count);*/
		hepsi(row_count,'term',row_count);
		hepsi(row_count,'start_sal_mon',row_count);
		hepsi(row_count,'end_sal_mon',row_count);
		hepsi(row_count,'amount_pay',row_count);
		//hepsi(row_count,'calc_days',row_count);
		hepsi(row_count,'odkes_id',row_count);
		hepsi(row_count,'sabit_company_id',row_count);
		hepsi(row_count,'sabit_consumer_id',row_count);
		hepsi(row_count,'sabit_member_name',row_count);
		odenek_text=eval("document.add_ext_salary.comment_pay"+ row_count);
		odenek_text.focus();
		return true;
	}
	function send_kesinti(row_count)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_kesinti&row_id_='+ row_count);
	}
	function kontrol()
	{
		document.getElementById('record_num').value=row_count;
		if(row_count == 0)
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='53083.Kesinti'>");
			return false;
		}
		for(var i=1;i<=row_count;i++)
		{
			 if($('#row_kontrol_'+i).val() == 1 && eval("document.add_ext_salary.amount_pay"+i).value.length == 0)
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='53083.Kesinti'>");
					return false;
				}
		}
		for(var i=1;i<=row_count;i++)
		{
			nesne=eval("document.add_ext_salary.amount_pay"+i);
			nesne.value=filterNum(nesne.value);
		}
		process_cat_control();
		
		return true;
	}
		function toplam_hesapla()
		{
			var total_amount = 0;
			var sayac = 0;
			for(var i=1;i<=row_count;i++)
			{
				if(eval("add_ext_salary.row_kontrol_"+i).value != 0 && eval("document.add_ext_salary.amount_pay"+i).value != 0)
				{
					nesne_tarih=eval("document.add_ext_salary.amount_pay"+i);
					total_amount += parseFloat(filterNum(nesne_tarih.value));
					sayac++
				}
			}
			document.getElementById('total_amount').value = parseFloat(total_amount);
			document.getElementById('total_emp').value = sayac;
		}	
		function change_mon(id,i)
		{
			$('#'+id).val(i);
		}	
	</script>
	