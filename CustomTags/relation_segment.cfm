<!---TolgaS 20060224 istenilen bi alanla şirket department gibi alanların ilişkisini kurmak için
	*****RELATION_SEGMENT tablosunda RELATION_ACTION ın anlamı
	our_company_id:1,department_id:2,position_cat_id:3,companycat_id:4,func_id:5,organization_step_id:6,branch_id:7,consumercat_id:8,position_req_type:9,title_id:10
	***** get_relation_list oluşturduğu liste isimleri
	relation_list_comp_id=''; ,	relation_list_dep_id=''; ,	relation_list_branch_id=''; , relation_list_pos_cat_id=''; , relation_list_comp_cat_id='';	relation_list_func_id=''; ,	relation_list_org_step_id=''; ,relation_list_pos_req_type_id='' , relation_list_title_id='';
	***** relation_segment_select(msg) javascript fonksiyonunu customtagin olduğu sayfaya koyulursa bir alan seçmek zorunlu olur
	kullanım:		
	<cf_relation_segment
		is_upd='1'  //0 sa add sayfası 1 ise update sayfasıdır default 0 alır
		is_form='1' //formu yoksa action sayfasımı default 1 olur form gelir
		is_del='1' //1 ise silme işlemi yapar çalışması için is_upd ve is_form un 0 olması lazım default 0 alır
		field_id='#attributes.targetcat_id#'
		table_name='TARGET_CAT'
		action_table_name='RELATION_SEGMENT' kayıtların atılacağı ilişki tablosu hr için :RELATION_SEGMENT ,training için:RELATION_SEGMENT_TRAINING
		is_year=  yil select boxları gelsinmi
		year_value='2006' databese e eklenmek istenen yıl verile bilir
		tag_head='başlık'  ekranda gözükecek başlık bölümü
		select_list='1,2...' tiplere göre gözükmesini istediklerinizi vererek alanları kısıtlamak için
		get_list= 1 eger 1 veya 2 olursa uygun ilişki listelerini getirir 1 ise liste ile birlikte form veya actionda çalışır ancak 2 verilirse sadece liste oluşturur
	>
--->
<cfparam name="attributes.action_table_name" default="RELATION_SEGMENT">
<cfparam name="attributes.select_list" default=""><!---form ve actionda aynı olmalı o yüzden set edilmediğnde boş olsunki hiç bir işlem yapmasın--->
<cfparam name="attributes.form" default="1">
<cfparam name="attributes.is_upd" default="0">
<cfparam name="attributes.is_del" default="0">
<cfparam name="attributes.get_list" default="0">
<cfscript>
	if (listfind(attributes.select_list,'1',',')) our_comp_var=1;
	if (listfind(attributes.select_list,'2',',')) dep_var=1;
	if (listfind(attributes.select_list,'3',',')) pos_cat_var=1;
	if (listfind(attributes.select_list,'4',',')) comp_cat_var=1;
	if (listfind(attributes.select_list,'5',',')) func_var=1;
	if (listfind(attributes.select_list,'6',',')) org_step_var=1;
	if (listfind(attributes.select_list,'7',',')) branch_var=1;
	if (listfind(attributes.select_list,'8',',')) cons_cat_var=1;
	if (listfind(attributes.select_list,'9',',')) position_req_type_var=1;
	if (listfind(attributes.select_list,'10',',')) title_var=1;
</cfscript>
<cfif len(attributes.get_list) and attributes.get_list gt 0>
	<cfquery name="GET_RELATION" datasource="#CALLER.DSN#">
		SELECT 
			RELATION_ACTION,
			RELATION_ACTION_ID
		FROM 
			#attributes.action_table_name#
		WHERE
			RELATION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.table_name#"> AND
			RELATION_FIELD_ID IN(#attributes.field_id#)
			<cfif isdefined('attributes.year_value') and attributes.year_value eq 1>
				AND RELATION_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.year_value#">
			</cfif>
	</cfquery>
<cfscript>
	relation_list_our_comp_id='';
	relation_list_dep_id='';
	relation_list_branch_id='';
	relation_list_pos_cat_id='';
	relation_list_comp_cat_id='';
	relation_list_cons_cat_id='';
	relation_list_func_id='';
	relation_list_org_step_id='';
	relation_list_pos_req_type_id='';
	relation_list_title_id='';
	for(i=1;i lte GET_RELATION.RECORDCOUNT;i=i+1)
	{
		if(GET_RELATION.RELATION_ACTION[i] eq 1)
			relation_list_our_comp_id=listappend(relation_list_our_comp_id,GET_RELATION.RELATION_ACTION_ID[i],',');
		else if(GET_RELATION.RELATION_ACTION[i] eq 2)
			relation_list_dep_id=listappend(relation_list_dep_id,GET_RELATION.RELATION_ACTION_ID[i],',');
		else if(GET_RELATION.RELATION_ACTION[i] eq 3)
			relation_list_pos_cat_id=listappend(relation_list_pos_cat_id,GET_RELATION.RELATION_ACTION_ID[i],',');
		else if(GET_RELATION.RELATION_ACTION[i] eq 4)
			relation_list_comp_cat_id=listappend(relation_list_comp_cat_id,GET_RELATION.RELATION_ACTION_ID[i],',');
		else if(GET_RELATION.RELATION_ACTION[i] eq 5)
			relation_list_func_id=listappend(relation_list_func_id,GET_RELATION.RELATION_ACTION_ID[i],',');
		else if(GET_RELATION.RELATION_ACTION[i] eq 6)
			relation_list_org_step_id=listappend(relation_list_org_step_id,GET_RELATION.RELATION_ACTION_ID[i],',');
		else if(GET_RELATION.RELATION_ACTION[i] eq 7)
			relation_list_branch_id=listappend(relation_list_branch_id,GET_RELATION.RELATION_ACTION_ID[i],',');
		else if(GET_RELATION.RELATION_ACTION[i] eq 8)
			relation_list_cons_cat_id=listappend(relation_list_cons_cat_id,GET_RELATION.RELATION_ACTION_ID[i],',');
		else if(GET_RELATION.RELATION_ACTION[i] eq 9)
			relation_list_pos_req_type_id=listappend(relation_list_pos_req_type_id,GET_RELATION.RELATION_ACTION_ID[i],',');	
		else if(GET_RELATION.RELATION_ACTION[i] eq 10)
			relation_list_pos_req_type_id=listappend(relation_list_title_id,GET_RELATION.RELATION_ACTION_ID[i],',');				
	}
	caller.relation_list_our_comp_id='#relation_list_our_comp_id#';
	caller.relation_list_dep_id='#relation_list_dep_id#';
	caller.relation_list_branch_id='#relation_list_branch_id#';
	caller.relation_list_pos_cat_id='#relation_list_pos_cat_id#';
	caller.relation_list_comp_cat_id='#relation_list_comp_cat_id#';
	caller.relation_list_func_id='#relation_list_func_id#';
	caller.relation_list_org_step_id='#relation_list_org_step_id#';
	caller.relation_list_cons_cat_id='#relation_list_cons_cat_id#';
	caller.relation_list_pos_req_type_id='#relation_list_pos_req_type_id#';
	caller.relation_list_title_id='#relation_list_title_id#';
</cfscript>
</cfif>
<cfif attributes.get_list neq 2>
	<cfif attributes.is_form eq 1>
		<cfif isdefined("comp_cat_var")>
			<cfquery name="GET_COMPANYCAT" datasource="#CALLER.DSN#">
				SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
			</cfquery>
		</cfif>
		<cfif isdefined("func_var")>
			<cfquery name="GET_FONK" datasource="#CALLER.DSN#">
				SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT ORDER BY UNIT_NAME
			</cfquery>
		</cfif>
        <cfif isdefined("title_var")>
			<cfquery name="GET_TITLE" datasource="#CALLER.DSN#">
				SELECT TITLE_ID,TITLE FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
			</cfquery>
		</cfif>
		<cfif isdefined("org_step_var")>
			<cfquery name="get_organization_steps" datasource="#CALLER.DSN#">
				SELECT ORGANIZATION_STEP_ID,ORGANIZATION_STEP_NAME FROM SETUP_ORGANIZATION_STEPS ORDER BY ORGANIZATION_STEP_NAME
			</cfquery>
		</cfif>
		<cfif isdefined("cons_cat_var")>
			<cfquery name="GET_CONSUMERCAT" datasource="#CALLER.DSN#">
				SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY CONSCAT
			</cfquery>
		</cfif>
		<cfif isdefined("position_req_type_var")>
			<cfquery name="GET_POS_REQ_TYPE" datasource="#CALLER.DSN#">
				SELECT REQ_TYPE_ID,REQ_TYPE FROM POSITION_REQ_TYPE ORDER BY REQ_TYPE
			</cfquery>
		</cfif>
		<cfif attributes.is_upd eq 1>
			<cfif isdefined("our_comp_var")>
				<cfquery name="GET_RELATION_COMP" datasource="#CALLER.DSN#">
					SELECT 
						RELATION_ID,
						RELATION_ACTION,
						RELATION_ACTION_ID,
						RELATION_YEAR,
						IS_FILL,
						OUR_COMPANY.NICK_NAME
					FROM 
						#attributes.action_table_name# RELATION_SEGMENT,
						OUR_COMPANY
					WHERE
						RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.field_id#"> AND
						RELATION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.table_name#"> AND
						RELATION_ACTION = 1 AND
						OUR_COMPANY.COMP_ID = RELATION_SEGMENT.RELATION_ACTION_ID
				</cfquery>
			</cfif>
			<cfif isdefined("dep_var")>
				<cfquery name="GET_RELATION_DEP" datasource="#CALLER.DSN#">
					SELECT 
						RELATION_ID,
						RELATION_ACTION,
						RELATION_ACTION_ID,
						RELATION_YEAR,
						IS_FILL,
						DEPARTMENT_HEAD
					FROM 
						#attributes.action_table_name# RELATION_SEGMENT,
						DEPARTMENT
					WHERE 
						RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.field_id#">AND
						RELATION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.table_name#">  AND
						RELATION_ACTION = 2 AND
						DEPARTMENT.DEPARTMENT_ID = RELATION_SEGMENT.RELATION_ACTION_ID
				</cfquery>
			</cfif>
			<cfif isdefined("pos_cat_var")>
				<cfquery name="GET_RELATION_POS_CAT" datasource="#CALLER.DSN#">
					SELECT 
						RELATION_ID,
						RELATION_ACTION,
						RELATION_ACTION_ID,
						RELATION_YEAR,
						IS_FILL,
						SETUP_POSITION_CAT.POSITION_CAT
					FROM 
						#attributes.action_table_name# RELATION_SEGMENT,
						SETUP_POSITION_CAT
					WHERE 
						RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.field_id#">AND
						RELATION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.table_name#">  AND
						RELATION_ACTION = 3 AND
						SETUP_POSITION_CAT.POSITION_CAT_ID = RELATION_SEGMENT.RELATION_ACTION_ID
				</cfquery>
			</cfif>
			<cfif isdefined("comp_cat_var")>
				<cfquery name="GET_RELATION_COMP_CAT" datasource="#CALLER.DSN#">
					SELECT 
						RELATION_ID,
						RELATION_ACTION,
						RELATION_ACTION_ID,
						RELATION_YEAR,
						IS_FILL,
						COMPANY_CAT.COMPANYCAT
					FROM 
						#attributes.action_table_name# RELATION_SEGMENT,
						COMPANY_CAT
					WHERE 
						RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.field_id#">AND
						RELATION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.table_name#">  AND
						RELATION_ACTION = 4 AND
						COMPANY_CAT.COMPANYCAT_ID = RELATION_SEGMENT.RELATION_ACTION_ID
				</cfquery>
			</cfif>
			<cfif isdefined("func_var")>
				<cfquery name="GET_RELATION_FONK" datasource="#CALLER.DSN#">
					SELECT 
						RELATION_ID,
						RELATION_ACTION,
						RELATION_ACTION_ID,
						RELATION_YEAR,
						IS_FILL,
						SETUP_CV_UNIT.UNIT_NAME
					FROM 
						#attributes.action_table_name# RELATION_SEGMENT,
						SETUP_CV_UNIT
					WHERE 
						RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.field_id#">AND
						RELATION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.table_name#">  AND
						RELATION_ACTION = 5 AND
						SETUP_CV_UNIT.UNIT_ID = RELATION_SEGMENT.RELATION_ACTION_ID
				</cfquery>
			</cfif>
			<cfif isdefined("org_step_var")>
				<cfquery name="GET_RELATION_ORG_STEP" datasource="#CALLER.DSN#">
					SELECT 
						RELATION_ID,
						RELATION_ACTION,
						RELATION_ACTION_ID,
						RELATION_YEAR,
						IS_FILL,
						SETUP_ORGANIZATION_STEPS.ORGANIZATION_STEP_NAME
					FROM 
						#attributes.action_table_name# RELATION_SEGMENT,
						SETUP_ORGANIZATION_STEPS
					WHERE 
						RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.field_id#"> AND
						RELATION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.table_name#">  AND
						RELATION_ACTION = 6 AND
						SETUP_ORGANIZATION_STEPS.ORGANIZATION_STEP_ID = RELATION_SEGMENT.RELATION_ACTION_ID
				</cfquery>
			</cfif>
			<cfif isdefined("branch_var")>
				<cfquery name="GET_RELATION_BRANCH" datasource="#CALLER.DSN#">
					SELECT 
						RELATION_ID,
						RELATION_ACTION,
						RELATION_ACTION_ID,
						RELATION_YEAR,
						IS_FILL,
						BRANCH.BRANCH_NAME
					FROM 
						#attributes.action_table_name# RELATION_SEGMENT,
						BRANCH
					WHERE 
						RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.field_id#"> AND
						RELATION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.table_name#">  AND
						RELATION_ACTION = 7 AND
						BRANCH.BRANCH_ID = RELATION_SEGMENT.RELATION_ACTION_ID
				</cfquery>
			</cfif>
			<cfif isdefined("cons_cat_var")>
				<cfquery name="GET_RELATION_CONS_CAT" datasource="#CALLER.DSN#">
					SELECT 
						RELATION_ID,
						RELATION_ACTION,
						RELATION_ACTION_ID,
						RELATION_YEAR,
						IS_FILL,
						CONSUMER_CAT.CONSCAT
					FROM 
						#attributes.action_table_name# RELATION_SEGMENT,
						CONSUMER_CAT
					WHERE 
						RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.field_id#"> AND
						RELATION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.table_name#">  AND
						RELATION_ACTION = 8 AND
						CONSUMER_CAT.CONSCAT_ID = RELATION_SEGMENT.RELATION_ACTION_ID
				</cfquery>
			</cfif>
			<cfif isdefined("position_req_type_var")>
				<cfquery name="GET_RELATION_POS_REQ_TYPE" datasource="#CALLER.DSN#">
					SELECT 
						RELATION_ID,
						RELATION_ACTION,
						RELATION_ACTION_ID,
						RELATION_YEAR,
						IS_FILL,
						POSITION_REQ_TYPE.REQ_TYPE
					FROM 
						#attributes.action_table_name# RELATION_SEGMENT,
						POSITION_REQ_TYPE
					WHERE 
						RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.field_id#"> AND
						RELATION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.table_name#">  AND
						RELATION_ACTION = 9 AND
						POSITION_REQ_TYPE.REQ_TYPE_ID = RELATION_SEGMENT.RELATION_ACTION_ID
				</cfquery>
			</cfif>
            <cfif isdefined("title_var")>
				<cfquery name="GET_RELATION_TITLE" datasource="#CALLER.DSN#">
					SELECT 
						RELATION_ID,
						RELATION_ACTION,
						RELATION_ACTION_ID,
						RELATION_YEAR,
						IS_FILL,
						SETUP_TITLE.TITLE
					FROM 
						#attributes.action_table_name# RELATION_SEGMENT,
						SETUP_TITLE
					WHERE 
						RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.field_id#">AND
						RELATION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.table_name#">  AND
						RELATION_ACTION = 10 AND
						SETUP_TITLE.TITLE_ID = RELATION_SEGMENT.RELATION_ACTION_ID
				</cfquery>
			</cfif>
		</cfif>
        <div class="row">
		  <div class="col col-12 col-xs-12 uniqueRow">
            <div id="list_address_menu">
				<cfif isdefined("our_comp_var") or isdefined("dep_var") or isdefined("branch_var")>
					<div class="col col-3 col-xs-12">
						<cf_seperator id="organizasyon" header="<cfoutput>#caller.getLang('main',1288)#</cfoutput>"> <!--- Organizasyon Birimleri  --->
						<div id="organizasyon">
							<cfif isdefined("our_comp_var")>
								<input type="hidden" name="relation_our_comp_record_num" id="relation_our_comp_record_num" value="<cfif isdefined("GET_RELATION_COMP.RECORDCOUNT")><cfoutput>#GET_RELATION_COMP.RECORDCOUNT#</cfoutput><cfelse>0</cfif>">
								<cf_grid_list>
									<thead>
										<tr>
											<th width="15"><a href="javascript://" onClick="add_row_our_comp();"><i class="fa fa-plus" title="<cfoutput>#caller.getLang('main',170)#</cfoutput>"></i></a></th>
											<th><cfoutput>#caller.getLang('main',162)#</cfoutput></th> <!--- Sirket --->
										</tr>
									</thead>
									<tbody id="relation_our_comp_table">
									<cfif attributes.is_upd eq 1>
										<cfoutput query="GET_RELATION_COMP">
										<tr id="frm_our_comp_row#currentrow#">
											<td width="15"><cfif IS_FILL neq 1><a href="javascript://" onclick="sil_our_comp(#currentrow#);"><i class="fa fa-minus"> </i></a></cfif> </td>
											<td>
												<input type="hidden" name="relation_our_comp_id#currentrow#" id="relation_our_comp_id#currentrow#" value="#RELATION_ACTION_ID#">
												<input type="text" name="relation_our_comp_name#currentrow#" id="relation_our_comp_name#currentrow#" value="#NICK_NAME#" style="width:90%!important">
												<input  type="hidden"  value="#RELATION_ID#" id="#RELATION_ID#"  name="our_comp_relation_id#currentrow#">
												<input type="hidden"  value="1"  name="relation_our_comp_row_kontrol#currentrow#" id="relation_our_comp_row_kontrol#currentrow#"><cfif IS_FILL neq 1><i style="right:10px" class="icon-ellipsis btnPointer" onclick="javascript:opage_our_comp(#currentrow#)"></i></cfif>
											</td>
										</tr>
										</cfoutput>
									</cfif>
									</tbody>
								</cf_grid_list>
							</cfif>
							<cfif isdefined("branch_var")>
								<input type="hidden" name="relation_branch_record_num" id="relation_branch_record_num" value="<cfif isdefined("GET_RELATION_BRANCH.RECORDCOUNT")><cfoutput>#GET_RELATION_BRANCH.RECORDCOUNT#</cfoutput><cfelse>0</cfif>">
								<cf_grid_list>
									<thead>
										<tr>
											<th id="add_dep_0" width="15"><a href="javascript://" onClick="add_row_branch();"><i class="fa fa-plus" title="<cfoutput>#caller.getLang('main',170)#</cfoutput>"></i></a></th>
											<th><cfoutput>#caller.getLang('main',41)#</cfoutput></th> <!--- Sube --->
										</tr>
									</thead>
									<tbody id="relation_branch_table">
									<cfif attributes.is_upd eq 1>
										<cfoutput query="GET_RELATION_BRANCH">
											<tr id="frm_branch_row#currentrow#">
												<td width="15"><cfif IS_FILL neq 1><a href="javascript://" onclick="sil_branch(#currentrow#);"><i class="fa fa-minus"></i></a></cfif></td>
												<td>
													<input type="hidden" name="relation_branch_id#currentrow#" id="relation_branch_id#currentrow#" value="#RELATION_ACTION_ID#">
													<input type="text" name="relation_branch_name#currentrow#" id="relation_branch_name#currentrow#" value="#BRANCH_NAME#" style="width:90%!important">
													<input  type="hidden"  value="#RELATION_ID#"  name="branch_relation_id#currentrow#" id="branch_relation_id#currentrow#">
													<input  type="hidden"  value="1"  name="relation_branch_row_kontrol#currentrow#" id="relation_branch_row_kontrol#currentrow#"><cfif IS_FILL neq 1><i class="icon-ellipsis btnPointer" onclick="javascript:opage_branch(#currentrow#);"></i></cfif>
												</td>
											</tr>
										</cfoutput>
									</cfif>
									</tbody>
								</cf_grid_list>
							</cfif>
							<cfif isdefined("dep_var")>
								<input type="hidden" name="relation_dep_record_num" id="relation_dep_record_num" value="<cfif isdefined("GET_RELATION_DEP.RECORDCOUNT")><cfoutput>#GET_RELATION_DEP.RECORDCOUNT#</cfoutput><cfelse>0</cfif>">
								<cf_grid_list>
									<thead>
										<tr>
											<th id="add_dep_0" width="15"><a href="javascript://" onClick="add_row_dep();"><i class="fa fa-plus" title="<cfoutput>#caller.getLang('main',170)#</cfoutput>"></i></a></th>
											<th><cfoutput>#caller.getLang('main',160)#</cfoutput></th> <!--- Departman --->
										</tr>
									</thead>
									<tbody id="relation_dep_table">
									<cfif attributes.is_upd eq 1>
										<cfoutput query="GET_RELATION_DEP">
										<tr id="frm_dep_row#currentrow#">
											<td  width="15"><cfif IS_FILL neq 1><a href="javascript://" onclick="sil_dep(#currentrow#);"><i class="fa fa-minus"></i></a></cfif> </td>
											<td>
												<input type="hidden" name="relation_dep_id#currentrow#" id="relation_dep_id#currentrow#" value="#RELATION_ACTION_ID#">
												<input type="text" name="relation_dep_name#currentrow#" id="relation_dep_name#currentrow#" value="#DEPARTMENT_HEAD#" class="formfieldright" style="width:90%!important">
												<input  type="hidden" value="#RELATION_ID#" name="dep_relation_id#currentrow#" id="dep_relation_id#currentrow#">
												<input  type="hidden" value="1" name="relation_dep_row_kontrol#currentrow#" id="relation_dep_row_kontrol#currentrow#"><cfif IS_FILL neq 1><i class="icon-ellipsis btnPointer"  onclick="javascript:opage_dep(#currentrow#);"></i></cfif>
											</td>
										</tr>
										</cfoutput>
									</cfif>
									</tbody>
								</cf_grid_list>
							</cfif>
						</div>
					</div>
				</cfif>
                <cfif isdefined("pos_cat_var") or isdefined("func_var") or isdefined("org_step_var") or isdefined("title_var") or isdefined("position_req_type_var")> 
                    <div class="col col-3 col-xs-12">
                        <cf_seperator id="pozisyon" header="<cfoutput>#caller.getLang('main',1299)#</cfoutput>"><!--- Pozisyon Degerleri --->
                        <div id="pozisyon" style="z-index:88; display:none; overflow:auto;">
                            <cfif isdefined("pos_cat_var")>
                                <cf_grid_list>
                                    <input type="hidden" name="relation_pos_cat_record_num" id="relation_pos_cat_record_num" value="<cfif isdefined("GET_RELATION_POS_CAT.RECORDCOUNT")><cfoutput>#GET_RELATION_POS_CAT.RECORDCOUNT#</cfoutput><cfelse>0</cfif>">
                                    <thead>
                                        <tr>
                                            <th id="add_pos_cat_0" width="15"><a href="javascript://" onClick="add_row_pos_cat();"><i class="fa fa-plus" title="<cfoutput>#caller.getLang('main',170)#</cfoutput>"></i></a></th>
                                            <th><cfoutput>#caller.getLang('main',367)#</cfoutput></th> <!--- Pozisyon Tipleri --->
                                        </tr>
                                    </thead>
                                    <tbody id="relation_pos_cat_table">
                                        <cfif attributes.is_upd eq 1>
                                            <cfoutput query="GET_RELATION_POS_CAT">
                                            <tr id="frm_pos_cat_row#currentrow#">
                                                <td  width="15"><cfif IS_FILL neq 1><a href="javascript://" onclick="sil_pos_cat(#currentrow#);"><i class="fa fa-minus"></i></a></cfif> </td>
                                                <td>
													<input type="hidden" name="relation_pos_cat_id#currentrow#" id="relation_pos_cat_id#currentrow#" value="#RELATION_ACTION_ID#">
													<input type="text" name="relation_pos_cat_name#currentrow#" id="relation_pos_cat_name#currentrow#" value="#POSITION_CAT#" style="width:90%!important">
													<input type="hidden"  value="#RELATION_ID#"  name="pos_cat_relation_id#currentrow#" id="pos_cat_relation_id#currentrow#">
													<input type="hidden"  value="1" name="relation_pos_cat_row_kontrol#currentrow#" id="relation_pos_cat_row_kontrol#currentrow#"><cfif IS_FILL neq 1><i class="icon-ellipsis btnPointer"  onclick="javascript:opage_pos_cat(#currentrow#);"></i></cfif>
                                                </td>
                                            </tr>
                                            </cfoutput>
                                        </cfif>
                                    </tbody>
                                </cf_grid_list>
                            </cfif>
                            <cfif isdefined("func_var")>
                                <input type="hidden" name="relation_fonk_record_num" id="relation_fonk_record_num" value="<cfif isdefined("GET_RELATION_FONK.RECORDCOUNT")><cfoutput>#GET_RELATION_FONK.RECORDCOUNT#</cfoutput><cfelse>0</cfif>">
                                <cf_grid_list>
                                    <thead>
                                        <tr>
                                            <th id="add_comp_cat_0" width="15"><a href="javascript://" onClick="add_row_fonk();"><i class="fa fa-plus" title="<cfoutput>#caller.getLang('main',1300)#</cfoutput>"></i></a></th><!--- Fonksiyon Ekle ---> 
                                            <th><cfoutput>#caller.getLang('main',1289)#</cfoutput></th> <!--- Fonksiyon --->
                                        </tr>
                                    </thead>
                                    <tbody id="relation_fonk_table">
                                        <cfif attributes.is_upd eq 1>
                                            <cfoutput query="GET_RELATION_FONK">
                                            <tr id="frm_fonk_row#currentrow#">
                                                <td width="15"><cfif IS_FILL neq 1><a href="javascript://" onclick="sil_fonk(#currentrow#);"><i class="fa fa-minus"></i></a></cfif> </td>
                                                <td><input type="hidden" value="#RELATION_ID#" name="fonk_relation_id#currentrow#" id="fonk_relation_id#currentrow#">
                                                    <input type="hidden" value="1" name="relation_fonk_row_kontrol#currentrow#" id="relation_fonk_row_kontrol#currentrow#">
                                                    <cfif IS_FILL neq 1>
                                                        <select name="relation_fonk_id#currentrow#" id="relation_fonk_id#currentrow#" style="width:135px;">
                                                            <option value=""><cfoutput>#caller.getLang('main',322)#</cfoutput></option>
                                                        <cfloop query="GET_FONK">
                                                            <option value="#UNIT_ID#" <cfif get_relation_fonk.relation_action_id[#get_relation_fonk.currentrow#] eq unit_id>selected</cfif>>#unit_name#</option>
                                                        </cfloop>
                                                        </select>
                                                    <cfelse>
                                                        <input type="text" name="relation_fonk_id#currentrow#" id="relation_fonk_id#currentrow#" value="<cfloop query='GET_FONK'><cfif get_relation_fonk.relation_action_id[#get_relation_fonk.currentrow#] eq unit_id>#unit_name#</cfif></cfloop>" readonly>
                                                    </cfif>
                                                </td>
                                            </tr>
                                            </cfoutput>
                                        </cfif>
                                    </tbody>
                                </cf_grid_list>
                            </cfif>
                            <cfif isdefined("org_step_var")>
								<cf_grid_list>
									<input type="hidden" name="relation_org_step_record_num" id="relation_org_step_record_num" value="<cfif isdefined("GET_RELATION_ORG_STEP.RECORDCOUNT")><cfoutput>#GET_RELATION_ORG_STEP.RECORDCOUNT#</cfoutput><cfelse>0</cfif>">
									<thead>
										<tr>
											<th id="add_org_step_0" width="15"><a href="javascript://" onClick="add_row_org_step();"><i class="fa fa-plus" title="<cfoutput>#caller.getLang('main',1291)#</cfoutput>"></i></a></th> <!--- Kademe Ekle --->
											<th><cfoutput>#caller.getLang('main',1298)#</cfoutput></th> <!--- Kademe --->
										</tr>
									</thead>
									<tbody id="relation_org_step_table">
										<cfif attributes.is_upd eq 1>
											<cfoutput query="GET_RELATION_ORG_STEP">
											<tr id="frm_org_step_row#currentrow#">
												<td width="15"><cfif IS_FILL neq 1><a href="javascript://" onclick="sil_org_step(#currentrow#);"><i class="fa fa-minus"></i></a></cfif> </td>
												<td><input  type="hidden"  value="#RELATION_ID#" name="org_step_relation_id#currentrow#" id="org_step_relation_id#currentrow#"><input  type="hidden"  value="1" name="relation_org_step_row_kontrol#currentrow#" id="relation_org_step_row_kontrol#currentrow#">
													<cfif IS_FILL neq 1>
														<select name="relation_org_step_id#currentrow#" id="relation_org_step_id#currentrow#">
														<option value=""><cfoutput>#caller.getLang('main',322)#</cfoutput></option><!---Seciniz --->
														<cfloop query="get_organization_steps">
															<option value="#ORGANIZATION_STEP_ID#" <cfif GET_RELATION_ORG_STEP.RELATION_ACTION_ID[#GET_RELATION_ORG_STEP.currentrow#] eq ORGANIZATION_STEP_ID>selected</cfif>>#ORGANIZATION_STEP_NAME#</option>
														</cfloop>
														</select>
													<cfelse>
														<input type="text" name="relation_org_step_id#currentrow#" id="relation_org_step_id#currentrow#" value="<cfloop query='get_organization_steps'><cfif GET_RELATION_ORG_STEP.RELATION_ACTION_ID[#GET_RELATION_ORG_STEP.currentrow#] eq ORGANIZATION_STEP_ID>#ORGANIZATION_STEP_NAME#</cfif></cfloop>" readonly>
													</cfif>
												</td>
											</tr>
											</cfoutput>
										</cfif>
									</tbody>
								</cf_grid_list>
                            </cfif>
                            <cfif isdefined("title_var")>
                                <input type="hidden" name="relation_title_record_num" id="relation_title_record_num" value="<cfif isdefined("GET_RELATION_TITLE.RECORDCOUNT")><cfoutput>#GET_RELATION_TITLE.RECORDCOUNT#</cfoutput><cfelse>0</cfif>">
                                <cf_grid_list>
                                    <thead>
                                        <tr>
                                            <th id="add_title_0" width="15"><a href="javascript://" onClick="add_row_title();"><i class="fa fa-plus" title="<cfoutput>#caller.getLang('main',170)#</cfoutput>"></i></a></th><!--- Ünvan Ekle ---> 
                                            <th><cfoutput>#caller.getLang('main',159)#</cfoutput></th> <!--- Ünvan --->
                                        </tr>
                                    </thead>
                                    <tbody id="relation_title_table">
                                        <cfif attributes.is_upd eq 1>
                                            <cfoutput query="GET_RELATION_TITLE">
                                            <tr id="frm_title_row#currentrow#">
                                                <td width="15"><cfif IS_FILL neq 1><a href="javascript://" onclick="sil_title(#currentrow#);"><i class="fa fa-minus"></i></a></cfif> </td>
                                                <td><input type="hidden" value="#RELATION_ID#" name="title_relation_id#currentrow#" id="title_relation_id#currentrow#">
                                                    <input type="hidden" value="1" name="relation_title_row_kontrol#currentrow#" id="relation_title_row_kontrol#currentrow#">
                                                    <cfif IS_FILL neq 1>
                                                        <select name="relation_title_id#currentrow#" id="relation_title_id#currentrow#" style="width:135px;">
                                                            <option value=""><cfoutput>#caller.getLang('main',322)#</cfoutput></option>
                                                        <cfloop query="GET_TITLE">
                                                            <option value="#TITLE_ID#" <cfif get_relation_title.relation_action_id[#get_relation_title.currentrow#] eq title_id>selected</cfif>>#title#</option>
                                                        </cfloop>
                                                        </select>
                                                    <cfelse>
                                                        <input type="text" name="relation_title_id#currentrow#" id="relation_title_id#currentrow#" value="<cfloop query='GET_TITLE'><cfif get_relation_title.relation_action_id[#get_relation_title.currentrow#] eq title_id>#title#</cfif></cfloop>" readonly>
                                                    </cfif>
                                                </td>
                                            </tr>
                                            </cfoutput>
                                        </cfif>
                                    </tbody>
                                </cf_grid_list>
                            </cfif>
							<cfif isdefined("position_req_type_var")>
								<input type="hidden" name="relation_req_type_record_num" id="relation_req_type_record_num" value="<cfif isdefined("GET_RELATION_POS_REQ_TYPE.RECORDCOUNT")><cfoutput>#GET_RELATION_POS_REQ_TYPE.RECORDCOUNT#</cfoutput><cfelse>0</cfif>">
								<cf_grid_list>
									<thead>
										<tr>
											<th id="add_req_type_0" width="15"><a href="javascript://" onClick="add_row_req_type();"><i class="fa fa-plus" title="<cfoutput>#caller.getLang('main',170)#</cfoutput>" ></i></a></th>
											<th><cfoutput>#caller.getLang('main',1297)#</cfoutput></th>
										</tr>
									</thead>
									<tbody id="relation_req_type_table">
										<cfif attributes.is_upd eq 1>
											<cfoutput query="GET_RELATION_POS_REQ_TYPE">
											<tr id="frm_req_type_row#currentrow#">
												<td width="15"><cfif IS_FILL neq 1><a href="javascript://" onclick="sil_req_type(#currentrow#);"><i class="fa fa-minus"></i></a></cfif> </td>
												<td>
													<input type="hidden" name="relation_req_type_id#currentrow#" id="relation_req_type_id#currentrow#" value="#RELATION_ACTION_ID#"><input type="text" name="relation_req_type_name#currentrow#" id="relation_req_type_name#currentrow#" value="#REQ_TYPE#" class="formfieldright" style="width:90%!important">
													<input  type="hidden"  value="#RELATION_ID#"  name="req_type_relation_id#currentrow#" id="req_type_relation_id#currentrow#"><input  type="hidden"  value="1"  name="relation_req_type_row_kontrol#currentrow#" id="relation_req_type_row_kontrol#currentrow#"><cfif IS_FILL neq 1><i class="icon-ellipsis btnPointer"  onclick="javascript:opage_req_type(#currentrow#);"></i></cfif></td>
											</tr>
											</cfoutput>
										</cfif>
									</tbody>
								</cf_grid_list>
							</cfif>
                        </div>
                    </div>
                </cfif>
                <cfif isdefined("comp_cat_var")>
                    <div class="col col-3 col-xs-12">
                        <cf_seperator id="kurumsal_uyeler" header="<cfoutput>#caller.getLang('','Kurumsal Üyeler',29408)#</cfoutput>"><!--- Kurumsal Uyeler --->
                        <div id="kurumsal_uyeler" style="z-index:88; display:none; overflow:auto;">
                            <cfif isdefined("comp_cat_var")>
                            <cf_grid_list>
                                <input type="hidden" name="relation_comp_cat_record_num" id="relation_comp_cat_record_num" value="<cfif isdefined("GET_RELATION_COMP_CAT.RECORDCOUNT")><cfoutput>#GET_RELATION_COMP_CAT.RECORDCOUNT#</cfoutput><cfelse>0</cfif>">
                                    <thead>
                                        <tr>
                                            <th id="add_comp_cat_0" width="15"><a href="javascript://" onClick="add_row_comp_cat();"><i class="fa fa-plus" title="<cfoutput>#caller.getLang('main',170)#</cfoutput>"></i></a></th>
                                            <th><cfoutput>#caller.getLang('main',1293)#</cfoutput></th> <!--- Kurumsal Uye Kategorisi --->
                                        </tr>
                                    </thead>
                                    <tbody id="relation_comp_cat_table">
                                    <cfif attributes.is_upd eq 1>
                                        <cfoutput query="GET_RELATION_COMP_CAT">
                                        <tr id="frm_comp_cat_row#currentrow#">
                                            <td width="15"><cfif IS_FILL neq 1><a href="javascript://" onclick="sil_comp_cat(#currentrow#);"><i class="fa fa-minus"></i></a></cfif> </td>
                                            <td><input  type="hidden"  value="#RELATION_ID#" name="comp_cat_relation_id#currentrow#" id="comp_cat_relation_id#currentrow#"><input  type="hidden"  value="1"  name="relation_comp_cat_row_kontrol#currentrow#" id="relation_comp_cat_row_kontrol#currentrow#">
                                                <cfif IS_FILL neq 1>
                                                    <select name="relation_companycat_id#currentrow#" id="relation_companycat_id#currentrow#"><option value=""><cfoutput>#caller.getLang('main',322)#</cfoutput></option><cfloop query="get_companycat"><option value="#get_companycat.companycat_id#" <cfif GET_RELATION_COMP_CAT.RELATION_ACTION_ID[#GET_RELATION_COMP_CAT.currentrow#] eq get_companycat.companycat_id>selected</cfif>>#get_companycat.companycat#</option></cfloop></select>
                                                <cfelse>
                                                    <input type="text" name="relation_companycat_id#currentrow#" id="relation_companycat_id#currentrow#" value="<cfloop query='get_companycat'><cfif get_companycat.RELATION_ACTION_ID[#get_companycat.currentrow#] eq get_companycat.companycat_id>#get_companycat.companycat#</cfif></cfloop>" readonly>
                                                </cfif>
                                            </td>
                                        </tr>
                                        </cfoutput>
                                    </cfif>
                                    </tbody>
                                </cf_grid_list>
                            </cfif>
                        </div>
                    </div>
                </cfif>
                <cfif isdefined("cons_cat_var")>
                    <div class="col col-3 col-xs-12">
                        <cf_seperator id="bireysel_uyeler" header="<cfoutput>#caller.getLang('','Bireysel Üyeler',29406)#</cfoutput>"><!--- Bireysel Uyeler --->
                        <div id="bireysel_uyeler" style="z-index:88; display:none; overflow:auto;">
                            <cfif isdefined("cons_cat_var")>
                                <input type="hidden" name="relation_cons_cat_record_num" id="relation_cons_cat_record_num" value="<cfif isdefined("GET_RELATION_CONS_CAT.RECORDCOUNT")><cfoutput>#GET_RELATION_CONS_CAT.RECORDCOUNT#</cfoutput><cfelse>0</cfif>">
                                <cf_grid_list>
                                <thead>
                                    <tr>
                                        <th id="add_cons_cat_0" width="15"><a href="javascript://" onClick="add_row_cons_cat();"> <i class="fa fa-plus" title="<cfoutput>#caller.getLang('main',170)#</cfoutput>"></i></a></th>
                                        <th><cfoutput>#caller.getLang('main',1295)#</cfoutput></th>
                                    </tr>
                                </thead>
                                <tbody id="relation_cons_cat_table">
                                    <cfif attributes.is_upd eq 1>
                                        <cfoutput query="GET_RELATION_CONS_CAT">
                                        <tr id="frm_cons_cat_row#currentrow#">
                                            <td width="15"><cfif IS_FILL neq 1><a href="javascript://" onclick="sil_cons_cat(#currentrow#);"><i class="fa fa-minus"></i></a></cfif> </td>
                                            <td><input  type="hidden"  value="#RELATION_ID#"  name="cons_cat_relation_id#currentrow#" id="cons_cat_relation_id#currentrow#"><input  type="hidden"  value="1"  name="relation_cons_cat_row_kontrol#currentrow#" id="relation_cons_cat_row_kontrol#currentrow#">
                                                <cfif IS_FILL neq 1>
                                                    <select name="relation_consumercat_id#currentrow#" id="relation_consumercat_id#currentrow#"><option value=""><cfoutput>#caller.getLang('main',322)#</cfoutput></option><cfloop query="get_consumercat"><option value="#get_consumercat.CONSCAT_ID#" <cfif GET_RELATION_CONS_CAT.RELATION_ACTION_ID[#GET_RELATION_CONS_CAT.currentrow#] eq get_consumercat.CONSCAT_ID>selected</cfif>>#get_consumercat.CONSCAT#</option></cfloop></select>
                                                <cfelse>
                                                    <input type="text" name="relation_consumercat_id#currentrow#" id="relation_consumercat_id#currentrow#" value="<cfloop query='get_consumercat'><cfif get_consumercat.RELATION_ACTION_ID[#get_consumercat.currentrow#] eq get_consumercat.CONSCAT_ID>#get_consumercat.CONSCAT#</cfif></cfloop>" readonly>
                                                </cfif>
                                            </td>
                                        </tr>
                                        </cfoutput>
                                    </cfif>
                                </tbody>
                            </cf_grid_list>
                            </cfif>
                        </div>
                    </div>
                </cfif>
            </div>
		  </div>
        </div>
		<script type="text/javascript">
			<cfif isdefined("our_comp_var")>
				function sil_our_comp(sy)
				{
					var my_element=eval("document.all.relation_our_comp_row_kontrol"+sy);
					my_element.value=0;
					var my_element=eval("frm_our_comp_row"+sy);
					my_element.style.display="none";	
				}
				
				var our_comp_row_count=<cfif isdefined("GET_RELATION_COMP.RECORDCOUNT")><cfoutput>#GET_RELATION_COMP.RECORDCOUNT#</cfoutput><cfelse>0</cfif>;
				function add_row_our_comp()
				{
					our_comp_row_count++;
					var newRow;
					var newCell;
					newRow = document.all.relation_our_comp_table.insertRow();	
					newRow.setAttribute("name","frm_our_comp_row" + our_comp_row_count);
					newRow.setAttribute("id","frm_our_comp_row" + our_comp_row_count);		
					
					document.all.relation_our_comp_record_num.value=our_comp_row_count;		
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<a onclick="sil_our_comp('+ our_comp_row_count +');"><i class="fa fa-minus"></i></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<input type="hidden" name="relation_our_comp_id' + our_comp_row_count + '" id="relation_our_comp_id' + our_comp_row_count + '" value=""><input type="text" name="relation_our_comp_name' + our_comp_row_count + '" id="relation_our_comp_name' + our_comp_row_count + '" class="formfieldright" style="width:90%!important" value="">';	
					newCell.innerHTML += '<input  type="hidden"  value="1"  name="relation_our_comp_row_kontrol' + our_comp_row_count +'" > <i class="icon-ellipsis btnPointer" onclick="javascript:opage_our_comp(' + our_comp_row_count +');"></i>';
				}
				function opage_our_comp(deger)
				{
					openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_our_companies&field_id=all.relation_our_comp_id' + deger + '&field_name=all.relation_our_comp_name' + deger);
				}
			</cfif>
			<cfif isdefined("branch_var")>
				function sil_branch(sy)
				{
					var my_element=eval("document.all.relation_branch_row_kontrol"+sy);
					my_element.value=0;
					var my_element=eval("frm_branch_row"+sy);
					my_element.style.display="none";	
				}
				
				var branch_row_count=<cfif isdefined("GET_RELATION_BRANCH.RECORDCOUNT")><cfoutput>#GET_RELATION_BRANCH.RECORDCOUNT#</cfoutput><cfelse>0</cfif>;
				function add_row_branch()
				{
					branch_row_count++;
					var newRow;
					var newCell;
					newRow = document.all.relation_branch_table.insertRow();	
					newRow.setAttribute("name","frm_branch_row" + branch_row_count);
					newRow.setAttribute("id","frm_branch_row" + branch_row_count);		
					
					document.all.relation_branch_record_num.value=branch_row_count;		
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<a onclick="sil_branch('+ branch_row_count +');"><i class="fa fa-minus"></i></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<input type="hidden" name="relation_branch_id' + branch_row_count + '" id="relation_branch_id' + branch_row_count + '"><input type="text" name="relation_branch_name' + branch_row_count + '" id="relation_branch_name' + branch_row_count + '" style="width:90%!important">';	
					newCell.innerHTML += '<input type="hidden" value="1" name="relation_branch_row_kontrol' + branch_row_count +'" > <i class="icon-ellipsis btnPointer" onclick="javascript:opage_branch(' + branch_row_count +');"></i>';
				}
				function opage_branch(deger)
				{
					openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=all.relation_branch_id' + deger + '&field_branch_name=all.relation_branch_name' + deger);
				}
			</cfif>
			<cfif isdefined("dep_var")>
				var dep_row_count=<cfif isdefined("GET_RELATION_DEP.RECORDCOUNT")><cfoutput>#GET_RELATION_DEP.RECORDCOUNT#</cfoutput><cfelse>0</cfif>;
				function add_row_dep()
				{
					dep_row_count++;
					var newRow;
					var newCell;
					newRow = document.all.relation_dep_table.insertRow();	
					newRow.setAttribute("name","frm_dep_row" + dep_row_count);
					newRow.setAttribute("id","frm_dep_row" + dep_row_count);
					
					document.all.relation_dep_record_num.value=dep_row_count;		
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<a  onclick="sil_dep('+ dep_row_count +');"><i class="fa fa-minus"></i></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<input type="hidden" name="relation_dep_id' + dep_row_count + '" id="relation_dep_id' + dep_row_count + '" value=""><input type="text" name="relation_dep_name' + dep_row_count + '" id="relation_dep_name' + dep_row_count + '" class="formfieldright" style="width:90%!important" value="">';	
					newCell.innerHTML += '<input type="hidden" value="1" name="relation_dep_row_kontrol' + dep_row_count +'" > <i class="icon-ellipsis btnPointer" onclick="javascript:opage_dep(' + dep_row_count +');"></i>';
				}
				function opage_dep(deger)
				{
					//bu departman popupında javasxript opener.documnet.--değer-- şeklinde yazımış diğer leri gibi yapılmalı ve sonra burdaki yer düzeltilmeli
					openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=all.relation_dep_id' + deger + '&field_name=all.relation_dep_name' + deger);
				}
				function sil_dep(sy)
				{
					var my_element=eval("document.all.relation_dep_row_kontrol"+sy);
					my_element.value=0;
					var my_element=eval("frm_dep_row"+sy);
					my_element.style.display="none";	
				}
			</cfif>
			<cfif isdefined("pos_cat_var")>
				var pos_cat_row_count=<cfif isdefined("GET_RELATION_POS_CAT.RECORDCOUNT")><cfoutput>#GET_RELATION_POS_CAT.RECORDCOUNT#</cfoutput><cfelse>0</cfif>;
				function add_row_pos_cat()
				{
					pos_cat_row_count++;
					var newRow;
					var newCell;
					newRow = document.all.relation_pos_cat_table.insertRow();	
					newRow.setAttribute("name","frm_pos_cat_row" + pos_cat_row_count);
					newRow.setAttribute("id","frm_pos_cat_row" + pos_cat_row_count);
					
					document.all.relation_pos_cat_record_num.value=pos_cat_row_count;		
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<a onclick="sil_pos_cat('+ pos_cat_row_count +');"><i class="fa fa-minus" align="absmiddle" border="0" alt="<cf_get_lang_main no='51.sil'>"></i></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<input type="hidden" name="relation_pos_cat_id' + pos_cat_row_count + '" id="relation_pos_cat_id' + pos_cat_row_count + '"><input type="text" name="relation_pos_cat_name' + pos_cat_row_count + '" id="relation_pos_cat_name' + pos_cat_row_count + '" style="width:90%!important">';	
					newCell.innerHTML += '<input  type="hidden"  value="1"  name="relation_pos_cat_row_kontrol' + pos_cat_row_count +'" > <i class="icon-ellipsis btnPointer" onclick="javascript:opage_pos_cat(' + pos_cat_row_count +');"></i>';
				}
				function opage_pos_cat(deger)
				{
					openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_position_cats&field_cat_id=all.relation_pos_cat_id' + deger + '&field_cat=all.relation_pos_cat_name' + deger);
				}
				function sil_pos_cat(sy)
				{
					var my_element=eval("document.all.relation_pos_cat_row_kontrol"+sy);
					my_element.value=0;
					var my_element=eval("frm_pos_cat_row"+sy);
					my_element.style.display="none";	
				}
			</cfif>
			<cfif isdefined("comp_cat_var")>
				var comp_cat_row_count=<cfif isdefined("GET_RELATION_COMP_CAT.RECORDCOUNT")><cfoutput>#GET_RELATION_COMP_CAT.RECORDCOUNT#</cfoutput><cfelse>0</cfif>;
				function add_row_comp_cat()
				{
					comp_cat_row_count++;
					var newRow;
					var newCell;
					newRow = document.all.relation_comp_cat_table.insertRow();	
					newRow.setAttribute("name","frm_comp_cat_row" + comp_cat_row_count);
					newRow.setAttribute("id","frm_comp_cat_row" + comp_cat_row_count);		
					
					document.all.relation_comp_cat_record_num.value=comp_cat_row_count;		
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<a onclick="sil_comp_cat('+ comp_cat_row_count +');"><i class="fa fa-minus" onclick="sil_comp_cat('+ comp_cat_row_count +');"></i></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<input  type="hidden"  value="1"  name="relation_comp_cat_row_kontrol' + comp_cat_row_count +'" ><select name="relation_companycat_id' + comp_cat_row_count +'"><option value=""><cfoutput>#caller.getLang("main",322)#</cfoutput></option><cfoutput query="get_companycat"><option value="#companycat_id#">#companycat#</option></cfoutput></select>';	
				}
				
				function sil_comp_cat(sy)
				{
					var my_element=eval("document.all.relation_comp_cat_row_kontrol"+sy);
					my_element.value=0;
					var my_element=eval("frm_comp_cat_row"+sy);
					my_element.style.display="none";	
				}
			</cfif>
			<cfif isdefined("cons_cat_var")>
				var cons_cat_row_count=<cfif isdefined("GET_RELATION_CONS_CAT.RECORDCOUNT")><cfoutput>#GET_RELATION_CONS_CAT.RECORDCOUNT#</cfoutput><cfelse>0</cfif>;
				function add_row_cons_cat()
				{
					cons_cat_row_count++;
					var newRow;
					var newCell;
					newRow = document.all.relation_cons_cat_table.insertRow();	
					newRow.setAttribute("name","frm_cons_cat_row" + cons_cat_row_count);
					newRow.setAttribute("id","frm_cons_cat_row" + cons_cat_row_count);		
					
					document.all.relation_cons_cat_record_num.value=cons_cat_row_count;		
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<a onclick="sil_cons_cat('+ cons_cat_row_count +');"><i class="fa fa-minus" ></i></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<input  type="hidden"  value="1"  name="relation_cons_cat_row_kontrol' + cons_cat_row_count +'" ><select name="relation_consumercat_id' + cons_cat_row_count +'"><option value=""><cfoutput>#caller.getLang("main",322)#</cfoutput></option><cfoutput query="get_consumercat"><option value="#conscat_id#">#conscat#</option></cfoutput></select>';	
				}
				function sil_cons_cat(sy)
				{
					var my_element=eval("document.all.relation_cons_cat_row_kontrol"+sy);
					my_element.value=0;
					var my_element=eval("frm_cons_cat_row"+sy);
					my_element.style.display="none";	
				}
			</cfif>
			<cfif isdefined("func_var")>
				var fonk_row_count=<cfif isdefined("GET_RELATION_FONK.RECORDCOUNT")><cfoutput>#GET_RELATION_FONK.RECORDCOUNT#</cfoutput><cfelse>0</cfif>;
				function add_row_fonk()
				{
					fonk_row_count++;
					var newRow;
					var newCell;
					newRow = document.all.relation_fonk_table.insertRow();	
					newRow.setAttribute("name","frm_fonk_row" + fonk_row_count);
					newRow.setAttribute("id","frm_fonk_row" + fonk_row_count);		
					
					document.all.relation_fonk_record_num.value=fonk_row_count;		
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<a onclick="sil_fonk('+ fonk_row_count +');"><i class="fa fa-minus"></i></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<input  type="hidden" value="1" name="relation_fonk_row_kontrol' + fonk_row_count +'" ><select name="relation_fonk_id' + fonk_row_count +'"><option value=""><cf_get_lang_main no="322.Seciniz"></option><cfoutput query="GET_FONK"><option value="#UNIT_ID#">#UNIT_NAME#</option></cfoutput></select>';	
				}
				function sil_fonk(sy)
				{
					var my_element=eval("document.all.relation_fonk_row_kontrol"+sy);
					my_element.value=0;
					var my_element=eval("frm_fonk_row"+sy);
					my_element.style.display="none";	
				}
			</cfif>
			<cfif isdefined("title_var")>
				var title_row_count=<cfif isdefined("GET_RELATION_TITLE.RECORDCOUNT")><cfoutput>#GET_RELATION_TITLE.RECORDCOUNT#</cfoutput><cfelse>0</cfif>;
				function add_row_title()
				{
					title_row_count++;
					var newRow;
					var newCell;
					newRow = document.all.relation_title_table.insertRow();	
					newRow.setAttribute("name","frm_title_row" + title_row_count);
					newRow.setAttribute("id","frm_title_row" + title_row_count);		
					
					document.all.relation_title_record_num.value=title_row_count;		
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<a onclick="sil_title('+ title_row_count +');"><i class="fa fa-minus"></i></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<input  type="hidden" value="1" name="relation_title_row_kontrol' + title_row_count +'" ><select name="relation_title_id' + title_row_count +'"><option value=""><cf_get_lang_main no="322.Seciniz"></option><cfoutput query="GET_TITLE"><option value="#TITLE_ID#">#TITLE#</option></cfoutput></select>';	
				}
				function sil_title(sy)
				{
					var my_element=eval("document.all.relation_title_row_kontrol"+sy);
					my_element.value=0;
					var my_element=eval("frm_title_row"+sy);
					my_element.style.display="none";	
				}
			</cfif>
			<cfif isdefined("org_step_var")>
				var org_step_row_count=<cfif isdefined("GET_RELATION_ORG_STEP.RECORDCOUNT")><cfoutput>#GET_RELATION_ORG_STEP.RECORDCOUNT#</cfoutput><cfelse>0</cfif>;
				function add_row_org_step()
				{
					org_step_row_count++;
					var newRow;
					var newCell;
					newRow = document.all.relation_org_step_table.insertRow();	
					newRow.setAttribute("name","frm_org_step_row" + org_step_row_count);
					newRow.setAttribute("id","frm_org_step_row" + org_step_row_count);		
					
					document.all.relation_org_step_record_num.value=org_step_row_count;		
					newCell = newRow.insertCell();
					newCell.innerHTML = '<a onclick="sil_org_step('+ org_step_row_count +');"><i class="fa fa-minus"></i></a>';
					newCell = newRow.insertCell();
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<input  type="hidden"  value="1"  name="relation_org_step_row_kontrol' + org_step_row_count +'" ><select name="relation_org_step_id' + org_step_row_count +'"><option value=""><cf_get_lang_main no="322.Seciniz"></option><cfoutput query="get_organization_steps"><option value="#ORGANIZATION_STEP_ID#">#ORGANIZATION_STEP_NAME#</option></cfoutput></select>';	
				}
				function sil_org_step(sy)
				{
					var my_element=eval("document.all.relation_org_step_row_kontrol"+sy);
					my_element.value=0;
					var my_element=eval("frm_org_step_row"+sy);
					my_element.style.display="none";	
				}
			</cfif>
			<cfif isdefined("position_req_type_var")>
				var req_type_row_count=<cfif isdefined("GET_RELATION_POS_REQ_TYPE.RECORDCOUNT")><cfoutput>#GET_RELATION_POS_REQ_TYPE.RECORDCOUNT#</cfoutput><cfelse>0</cfif>;
				function add_row_req_type()
				{
					req_type_row_count++;
					var newRow;
					var newCell;
					newRow = document.all.relation_req_type_table.insertRow();	
					newRow.setAttribute("name","frm_req_type_row" + req_type_row_count);
					newRow.setAttribute("id","frm_req_type_row" + req_type_row_count);
					
					document.all.relation_req_type_record_num.value=req_type_row_count;		
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<a onclick="sil_req_type('+ req_type_row_count +');"><i class="fa fa-minus"></i></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');	
					newCell.innerHTML = '<input type="hidden" name="relation_req_type_id' + req_type_row_count + '" id="relation_req_type_id' + req_type_row_count + '"><input type="text" name="relation_req_type_name' + req_type_row_count + '" id="relation_req_type_name' + dep_row_count + '" class="formfieldright" style="width:90%!important">';	
					newCell.innerHTML += '<input  type="hidden"  value="1"  name="relation_req_type_row_kontrol' + req_type_row_count +'" > <i class="icon-ellipsis btnPointer" onclick="javascript:opage_req_type(' + req_type_row_count +');"></i>';
				}
				function opage_req_type(deger)
				{
					//bu departman popupında javasxript opener.documnet.--değer-- şeklinde yazımış diğer leri gibi yapılmalı ve sonra burdaki yer düzeltilmeli
					openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_req&field_id=all.relation_req_type_id' + deger + '&field_name=all.relation_req_type_name' + deger);
				}
				function sil_req_type(sy)
				{
					var my_element=eval("document.all.relation_req_type_row_kontrol"+sy);
					my_element.value=0;
					var my_element=eval("frm_req_type_row"+sy);
					my_element.style.display="none";	
				}
			</cfif>
		</script>
	<!---silme işlemi--->		
	<cfelseif attributes.is_del eq 1>
		<cfquery name="del_req_type" datasource="#caller.dsn#">
			DELETE FROM	#attributes.action_table_name# WHERE RELATION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.table_name#"> AND RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.field_id#">
		</cfquery>
	<!--- ekle ve güncelle--->
	<cfelseif attributes.is_form eq 0>
		<cfif isdefined("our_comp_var")>
			<cfloop from="1" to="#caller.relation_our_comp_record_num#" index="i">
				<cfif isdefined("caller.relation_our_comp_row_kontrol#i#") and evaluate("caller.relation_our_comp_row_kontrol#i#") eq 1>
					<cfif isdefined("caller.relation_our_comp_id#i#") and len(evaluate("caller.relation_our_comp_id#i#")) and len(evaluate("caller.relation_our_comp_name#i#"))>
						<cfif isdefined("caller.our_comp_relation_id#i#") and len(evaluate("caller.our_comp_relation_id#i#"))>
							<cfquery name="upd_comp_target" datasource="#caller.dsn#">
								UPDATE
									#attributes.action_table_name#
								SET
									RELATION_TABLE='#attributes.table_name#',
									RELATION_FIELD_ID=#attributes.field_id#,
									RELATION_ACTION=1,
									RELATION_ACTION_ID=#evaluate("caller.relation_our_comp_id#i#")#,
									RELATION_YEAR=<cfif isdefined("caller.relation_our_comp_year#i#")>#evaluate("caller.relation_our_comp_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								WHERE
									RELATION_ID=#evaluate("caller.our_comp_relation_id#i#")#
							</cfquery>
						<cfelse>
							<cfquery name="add_comp_target" datasource="#caller.dsn#">
								INSERT INTO 
									#attributes.action_table_name#
								(
									RELATION_TABLE,
									RELATION_FIELD_ID,
									RELATION_ACTION,
									RELATION_ACTION_ID,
									RELATION_YEAR
								)
								VALUES
								(
									'#attributes.table_name#',
									#attributes.field_id#,
									1,
									#evaluate("caller.relation_our_comp_id#i#")#,
									<cfif isdefined("caller.relation_our_comp_year#i#")>#evaluate("caller.relation_our_comp_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								)
							</cfquery>
						</cfif>
					</cfif>
				<cfelseif isdefined("caller.relation_our_comp_row_kontrol#i#") and evaluate("caller.relation_our_comp_row_kontrol#i#") eq 0>
					<cfif isdefined("caller.our_comp_relation_id#i#") and len(evaluate("caller.our_comp_relation_id#i#"))>
						<cfquery name="del_target_rel" datasource="#caller.dsn#">
							DELETE FROM	#attributes.action_table_name# WHERE RELATION_ID=#evaluate("caller.our_comp_relation_id#i#")#
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfif isdefined("branch_var")>
			<cfloop from="1" to="#caller.relation_branch_record_num#" index="i">
				<cfif isdefined("caller.relation_branch_row_kontrol#i#") and evaluate("caller.relation_branch_row_kontrol#i#") eq 1>
					<cfif isdefined("caller.relation_branch_id#i#") and len(evaluate("caller.relation_branch_id#i#")) and len(evaluate("caller.relation_branch_name#i#"))>
						<cfif isdefined("caller.branch_relation_id#i#") and len(evaluate("caller.branch_relation_id#i#"))>
							<cfquery name="upd_branch_target" datasource="#caller.dsn#">
								UPDATE
									#attributes.action_table_name#
								SET
									RELATION_TABLE='#attributes.table_name#',
									RELATION_FIELD_ID=#attributes.field_id#,
									RELATION_ACTION=7,
									RELATION_ACTION_ID=#evaluate("caller.relation_branch_id#i#")#,
									RELATION_YEAR=<cfif isdefined("caller.relation_branch_year#i#")>#evaluate("caller.relation_branch_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								WHERE
									RELATION_ID=#evaluate("caller.branch_relation_id#i#")#
							</cfquery>
						<cfelse>
							<cfquery name="add_branch_target" datasource="#caller.dsn#">
								INSERT INTO 
									#attributes.action_table_name#
								(
									RELATION_TABLE,
									RELATION_FIELD_ID,
									RELATION_ACTION,
									RELATION_ACTION_ID,
									RELATION_YEAR
								)
								VALUES
								(
									'#attributes.table_name#',
									#attributes.field_id#,
									7,
									#evaluate("caller.relation_branch_id#i#")#,
									<cfif isdefined("caller.relation_branch_year#i#")>#evaluate("caller.relation_branch_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								)
							</cfquery>
						</cfif>
					</cfif>
				<cfelseif isdefined("caller.relation_branch_row_kontrol#i#") and evaluate("caller.relation_branch_row_kontrol#i#") eq 0>
					<cfif isdefined("caller.branch_relation_id#i#") and len(evaluate("caller.branch_relation_id#i#"))>
						<cfquery name="del_branch_rel" datasource="#caller.dsn#">
							DELETE FROM	#attributes.action_table_name# WHERE RELATION_ID=#evaluate("caller.branch_relation_id#i#")#
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>		
		
		<cfif isdefined("dep_var")>
			<cfloop from="1" to="#caller.relation_dep_record_num#" index="i">
				<cfif isdefined("caller.relation_dep_row_kontrol#i#") and evaluate("caller.relation_dep_row_kontrol#i#") eq 1>
					<cfif isdefined("caller.relation_dep_id#i#") and len(evaluate("caller.relation_dep_id#i#")) and len(evaluate("caller.relation_dep_name#i#"))>
						<cfif isdefined("caller.dep_relation_id#i#") and len(evaluate("caller.dep_relation_id#i#"))>
							<cfquery name="upd_dep_target" datasource="#caller.dsn#">
								UPDATE
									#attributes.action_table_name#
								SET
									RELATION_TABLE='#attributes.table_name#',
									RELATION_FIELD_ID=#attributes.field_id#,
									RELATION_ACTION=2,
									RELATION_ACTION_ID=#evaluate("caller.relation_dep_id#i#")#,
									RELATION_YEAR=<cfif isdefined("caller.relation_dep_year#i#")>#evaluate("caller.relation_dep_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								WHERE
									RELATION_ID=#evaluate("caller.dep_relation_id#i#")#
							</cfquery>
						<cfelse>
							<cfquery name="add_dep_target" datasource="#caller.dsn#">
								INSERT INTO 
									#attributes.action_table_name#
								(
									RELATION_TABLE,
									RELATION_FIELD_ID,
									RELATION_ACTION,
									RELATION_ACTION_ID,
									RELATION_YEAR
								)
								VALUES
								(
									'#attributes.table_name#',
									#attributes.field_id#,
									2,
									#evaluate("caller.relation_dep_id#i#")#,
									<cfif isdefined("caller.relation_dep_year#i#")>#evaluate("caller.relation_dep_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								)
							</cfquery>
						</cfif>
					</cfif>
				<cfelseif isdefined("caller.relation_dep_row_kontrol#i#") and evaluate("caller.relation_dep_row_kontrol#i#") eq 0>
					<cfif isdefined("caller.dep_relation_id#i#") and len(evaluate("caller.dep_relation_id#i#"))>
						<cfquery name="del_dep_target" datasource="#caller.dsn#">
							DELETE FROM	#attributes.action_table_name# WHERE RELATION_ID=#evaluate("caller.dep_relation_id#i#")#
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfif isdefined("pos_cat_var")>
			<cfloop from="1" to="#caller.relation_pos_cat_record_num#" index="i">
				<cfif isdefined("caller.relation_pos_cat_row_kontrol#i#") and evaluate("caller.relation_pos_cat_row_kontrol#i#") eq 1>
					<cfif isdefined("caller.relation_pos_cat_id#i#") and len(evaluate("caller.relation_pos_cat_id#i#")) and len(evaluate("caller.relation_pos_cat_name#i#"))>
						<cfif isdefined("caller.pos_cat_relation_id#i#") and len(evaluate("caller.pos_cat_relation_id#i#"))>
							<cfquery name="upd_pos_cat_target" datasource="#caller.dsn#">
								UPDATE
									#attributes.action_table_name#
								SET
									RELATION_TABLE='#attributes.table_name#',
									RELATION_FIELD_ID=#attributes.field_id#,
									RELATION_ACTION=3,
									RELATION_ACTION_ID=#evaluate("caller.relation_pos_cat_id#i#")#,
									RELATION_YEAR=<cfif isdefined("caller.pos_cat_year#i#")>#evaluate("caller.pos_cat_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								WHERE
									RELATION_ID=#evaluate("caller.pos_cat_relation_id#i#")#
							</cfquery>
						<cfelse>
							<cfquery name="add_pos_cat_target" datasource="#caller.dsn#">
								INSERT INTO 
									#attributes.action_table_name#
								(
									RELATION_TABLE,
									RELATION_FIELD_ID,
									RELATION_ACTION,
									RELATION_ACTION_ID,
									RELATION_YEAR
								)
								VALUES
								(
									'#attributes.table_name#',
									#attributes.field_id#,
									3,
									#evaluate("caller.relation_pos_cat_id#i#")#,
									<cfif isdefined("caller.relation_pos_cat_year#i#")>#evaluate("caller.relation_pos_cat_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								)
							</cfquery>
						</cfif>
					</cfif>
				<cfelseif isdefined("caller.relation_pos_cat_row_kontrol#i#") and evaluate("caller.relation_pos_cat_row_kontrol#i#") eq 0>
					<cfif isdefined("caller.pos_cat_relation_id#i#") and len(evaluate("caller.pos_cat_relation_id#i#"))>
						<cfquery name="del_pos_cat_target" datasource="#caller.dsn#">
							DELETE FROM	#attributes.action_table_name# WHERE RELATION_ID=#evaluate("caller.pos_cat_relation_id#i#")#
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfif isdefined("comp_cat_var")>
			<cfloop from="1" to="#caller.relation_comp_cat_record_num#" index="i">
				<cfif isdefined("caller.relation_comp_cat_row_kontrol#i#") and evaluate("caller.relation_comp_cat_row_kontrol#i#") eq 1>
					<cfif isdefined("caller.relation_companycat_id#i#") and len(evaluate("caller.relation_companycat_id#i#"))>
						<cfif isdefined("caller.comp_cat_relation_id#i#") and len(evaluate("caller.comp_cat_relation_id#i#"))>
							<cfquery name="upd_comp_cat_target" datasource="#caller.dsn#">
								UPDATE
									#attributes.action_table_name#
								SET
									RELATION_TABLE='#attributes.table_name#',
									RELATION_FIELD_ID=#attributes.field_id#,
									RELATION_ACTION=4,
									RELATION_ACTION_ID=#evaluate("caller.relation_companycat_id#i#")#,
									RELATION_YEAR=<cfif isdefined("caller.relation_comp_cat_year#i#")>#evaluate("caller.relation_comp_cat_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								WHERE
									RELATION_ID=#evaluate("caller.comp_cat_relation_id#i#")#
							</cfquery>
						<cfelse>
							<cfquery name="add_comp_cat_target" datasource="#caller.dsn#">
								INSERT INTO 
									#attributes.action_table_name#
								(
									RELATION_TABLE,
									RELATION_FIELD_ID,
									RELATION_ACTION,
									RELATION_ACTION_ID,
									RELATION_YEAR
								)
								VALUES
								(
									'#attributes.table_name#',
									#attributes.field_id#,
									4,
									#evaluate("caller.relation_companycat_id#i#")#,
									<cfif isdefined("caller.relation_comp_cat_year#i#")>#evaluate("caller.relation_comp_cat_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								)
							</cfquery>
						</cfif>
					</cfif>
				<cfelseif isdefined("caller.relation_comp_cat_row_kontrol#i#") and evaluate("caller.relation_comp_cat_row_kontrol#i#") eq 0>
					<cfif isdefined("caller.comp_cat_relation_id#i#") and len(evaluate("caller.comp_cat_relation_id#i#"))>
						<cfquery name="del_comp_cat_target" datasource="#caller.dsn#">
							DELETE FROM	#attributes.action_table_name# WHERE RELATION_ID=#evaluate("caller.comp_cat_relation_id#i#")#
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfif isdefined("cons_cat_var")>
			<cfloop from="1" to="#caller.relation_cons_cat_record_num#" index="i">
				<cfif isdefined("caller.relation_cons_cat_row_kontrol#i#") and evaluate("caller.relation_cons_cat_row_kontrol#i#") eq 1>
					<cfif isdefined("caller.relation_consumercat_id#i#") and len(evaluate("caller.relation_consumercat_id#i#"))>
						<cfif isdefined("caller.cons_cat_relation_id#i#") and len(evaluate("caller.cons_cat_relation_id#i#"))>
							<cfquery name="upd_comp_cat_target" datasource="#caller.dsn#">
								UPDATE
									#attributes.action_table_name#
								SET
									RELATION_TABLE='#attributes.table_name#',
									RELATION_FIELD_ID=#attributes.field_id#,
									RELATION_ACTION=8,
									RELATION_ACTION_ID=#evaluate("caller.relation_consumercat_id#i#")#,
									RELATION_YEAR=<cfif isdefined("caller.relation_cons_cat_year#i#")>#evaluate("caller.relation_cons_cat_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								WHERE
									RELATION_ID=#evaluate("caller.cons_cat_relation_id#i#")#
							</cfquery>
						<cfelse>
							<cfquery name="add_cons_cat_target" datasource="#caller.dsn#">
								INSERT INTO 
									#attributes.action_table_name#
								(
									RELATION_TABLE,
									RELATION_FIELD_ID,
									RELATION_ACTION,
									RELATION_ACTION_ID,
									RELATION_YEAR
								)
								VALUES
								(
									'#attributes.table_name#',
									#attributes.field_id#,
									8,
									#evaluate("caller.relation_consumercat_id#i#")#,
									<cfif isdefined("caller.relation_cons_cat_year#i#")>#evaluate("caller.relation_cons_cat_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								)
							</cfquery>
						</cfif>
					</cfif>
				<cfelseif isdefined("caller.relation_cons_cat_row_kontrol#i#") and evaluate("caller.relation_cons_cat_row_kontrol#i#") eq 0>
					<cfif isdefined("caller.cons_cat_relation_id#i#") and len(evaluate("caller.cons_cat_relation_id#i#"))>
						<cfquery name="del_cons_cat_target" datasource="#caller.dsn#">
							DELETE FROM	#attributes.action_table_name# WHERE RELATION_ID=#evaluate("caller.cons_cat_relation_id#i#")#
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>		
		
		<cfif isdefined("func_var")>
			<cfloop from="1" to="#caller.relation_fonk_record_num#" index="i">
				<cfif isdefined("caller.relation_fonk_row_kontrol#i#") and evaluate("caller.relation_fonk_row_kontrol#i#") eq 1>
					<cfif isdefined("caller.relation_fonk_id#i#") and len(evaluate("caller.relation_fonk_id#i#"))>
						<cfif isdefined("caller.fonk_relation_id#i#") and len(evaluate("caller.fonk_relation_id#i#"))>
							<cfquery name="upd_fonk_target" datasource="#caller.dsn#">
								UPDATE
									#attributes.action_table_name#
								SET
									RELATION_TABLE='#attributes.table_name#',
									RELATION_FIELD_ID=#attributes.field_id#,
									RELATION_ACTION=5,
									RELATION_ACTION_ID=#evaluate("caller.relation_fonk_id#i#")#,
									RELATION_YEAR=<cfif isdefined("caller.relation_fonk_year#i#")>#evaluate("caller.relation_fonk_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								WHERE
									RELATION_ID=#evaluate("caller.fonk_relation_id#i#")#
							</cfquery>
						<cfelse>
							<cfquery name="add_fonk_target" datasource="#caller.dsn#">
								INSERT INTO 
									#attributes.action_table_name#
								(
									RELATION_TABLE,
									RELATION_FIELD_ID,
									RELATION_ACTION,
									RELATION_ACTION_ID,
									RELATION_YEAR
								)
								VALUES
								(
									'#attributes.table_name#',
									#attributes.field_id#,
									5,
									#evaluate("caller.relation_fonk_id#i#")#,
									<cfif isdefined("caller.relation_fonk_year#i#")>#evaluate("caller.relation_fonk_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								)
							</cfquery>
						</cfif>
					</cfif>
				<cfelseif isdefined("caller.relation_fonk_row_kontrol#i#") and evaluate("caller.relation_fonk_row_kontrol#i#") eq 0>
					<cfif isdefined("caller.fonk_relation_id#i#") and len(evaluate("caller.fonk_relation_id#i#"))>
						<cfquery name="del_fonk_target" datasource="#caller.dsn#">
							DELETE FROM	#attributes.action_table_name# WHERE RELATION_ID=#evaluate("caller.fonk_relation_id#i#")#
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
        
        <cfif isdefined("title_var")>
			<cfloop from="1" to="#caller.relation_title_record_num#" index="i">
				<cfif isdefined("caller.relation_title_row_kontrol#i#") and evaluate("caller.relation_title_row_kontrol#i#") eq 1>
					<cfif isdefined("caller.relation_title_id#i#") and len(evaluate("caller.relation_title_id#i#"))>
						<cfif isdefined("caller.title_relation_id#i#") and len(evaluate("caller.title_relation_id#i#"))>
							<cfquery name="upd_title_target" datasource="#caller.dsn#">
								UPDATE
									#attributes.action_table_name#
								SET
									RELATION_TABLE='#attributes.table_name#',
									RELATION_FIELD_ID=#attributes.field_id#,
									RELATION_ACTION=10,
									RELATION_ACTION_ID=#evaluate("caller.relation_title_id#i#")#,
									RELATION_YEAR=<cfif isdefined("caller.relation_title_year#i#")>#evaluate("caller.relation_title_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								WHERE
									RELATION_ID=#evaluate("caller.title_relation_id#i#")#
							</cfquery>
						<cfelse>
							<cfquery name="add_title_target" datasource="#caller.dsn#">
								INSERT INTO 
									#attributes.action_table_name#
								(
									RELATION_TABLE,
									RELATION_FIELD_ID,
									RELATION_ACTION,
									RELATION_ACTION_ID,
									RELATION_YEAR
								)
								VALUES
								(
									'#attributes.table_name#',
									#attributes.field_id#,
									10,
									#evaluate("caller.relation_title_id#i#")#,
									<cfif isdefined("caller.relation_title_year#i#")>#evaluate("caller.relation_title_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								)
							</cfquery>
						</cfif>
					</cfif>
				<cfelseif isdefined("caller.relation_title_row_kontrol#i#") and evaluate("caller.relation_title_row_kontrol#i#") eq 0>
					<cfif isdefined("caller.title_relation_id#i#") and len(evaluate("caller.title_relation_id#i#"))>
						<cfquery name="del_title_target" datasource="#caller.dsn#">
							DELETE FROM	#attributes.action_table_name# WHERE RELATION_ID=#evaluate("caller.title_relation_id#i#")#
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfif isdefined("org_step_var")>
			<cfloop from="1" to="#caller.relation_org_step_record_num#" index="i">
				<cfif isdefined("caller.relation_org_step_row_kontrol#i#") and evaluate("caller.relation_org_step_row_kontrol#i#") eq 1>
					<cfif isdefined("caller.relation_org_step_id#i#") and len(evaluate("caller.relation_org_step_id#i#"))>
						<cfif isdefined("caller.org_step_relation_id#i#") and len(evaluate("caller.org_step_relation_id#i#"))>
							<cfquery name="upd_fonk_target" datasource="#caller.dsn#">
								UPDATE
									#attributes.action_table_name#
								SET
									RELATION_TABLE='#attributes.table_name#',
									RELATION_FIELD_ID=#attributes.field_id#,
									RELATION_ACTION=6,
									RELATION_ACTION_ID=#evaluate("caller.relation_org_step_id#i#")#,
									RELATION_YEAR=<cfif isdefined("caller.relation_org_step_year#i#")>#evaluate("caller.relation_org_step_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								WHERE
									RELATION_ID=#evaluate("caller.org_step_relation_id#i#")#
							</cfquery>
						<cfelse>
							<cfquery name="add_fonk_target" datasource="#caller.dsn#">
								INSERT INTO 
									#attributes.action_table_name#
								(
									RELATION_TABLE,
									RELATION_FIELD_ID,
									RELATION_ACTION,
									RELATION_ACTION_ID,
									RELATION_YEAR
								)
								VALUES
								(
									'#attributes.table_name#',
									#attributes.field_id#,
									6,
									#evaluate("caller.relation_org_step_id#i#")#,
									<cfif isdefined("caller.relation_org_step_year#i#")>#evaluate("caller.relation_org_step_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								)
							</cfquery>
						</cfif>
					</cfif>
				<cfelseif isdefined("caller.relation_org_step_row_kontrol#i#") and evaluate("caller.relation_org_step_row_kontrol#i#") eq 0>
					<cfif isdefined("caller.org_step_relation_id#i#") and len(evaluate("caller.org_step_relation_id#i#"))>
						<cfquery name="del_org_step_target" datasource="#caller.dsn#">
							DELETE FROM	#attributes.action_table_name# WHERE RELATION_ID=#evaluate("caller.org_step_relation_id#i#")#
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfif isdefined("position_req_type_var")>
			<cfloop from="1" to="#caller.relation_req_type_record_num#" index="i">
				<cfif isdefined("caller.relation_req_type_row_kontrol#i#") and evaluate("caller.relation_req_type_row_kontrol#i#") eq 1>
					<cfif isdefined("caller.relation_req_type_id#i#") and len(evaluate("caller.relation_req_type_id#i#")) and len(evaluate("caller.relation_req_type_name#i#"))>
						<cfif isdefined("caller.req_type_relation_id#i#") and len(evaluate("caller.req_type_relation_id#i#"))>
							<cfquery name="upd_req_type_target" datasource="#caller.dsn#">
								UPDATE
									#attributes.action_table_name#
								SET
									RELATION_TABLE='#attributes.table_name#',
									RELATION_FIELD_ID=#attributes.field_id#,
									RELATION_ACTION=9,
									RELATION_ACTION_ID=#evaluate("caller.relation_req_type_id#i#")#,
									RELATION_YEAR=<cfif isdefined("caller.relation_req_type_year#i#")>#evaluate("caller.relation_req_type_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								WHERE
									RELATION_ID=#evaluate("caller.req_type_relation_id#i#")#
							</cfquery>
						<cfelse>
							<cfquery name="add_req_type_target" datasource="#caller.dsn#">
								INSERT INTO 
									#attributes.action_table_name#
								(
									RELATION_TABLE,
									RELATION_FIELD_ID,
									RELATION_ACTION,
									RELATION_ACTION_ID,
									RELATION_YEAR
								)
								VALUES
								(
									'#attributes.table_name#',
									#attributes.field_id#,
									9,
									#evaluate("caller.relation_req_type_id#i#")#,
									<cfif isdefined("caller.relation_req_type_year#i#")>#evaluate("caller.relation_req_type_year#i#")#<cfelseif isdefined("attributes.year_value")>#attributes.year_value#<cfelse>NULL</cfif>
								)
							</cfquery>
						</cfif>
					</cfif>
				<cfelseif isdefined("caller.relation_req_type_row_kontrol#i#") and evaluate("caller.relation_req_type_row_kontrol#i#") eq 0>
					<cfif isdefined("caller.req_type_relation_id#i#") and len(evaluate("caller.req_type_relation_id#i#"))>
						<cfquery name="del_req_type_target" datasource="#caller.dsn#">
							DELETE FROM	#attributes.action_table_name# WHERE RELATION_ID=#evaluate("caller.req_type_relation_id#i#")#
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
</cfif>
