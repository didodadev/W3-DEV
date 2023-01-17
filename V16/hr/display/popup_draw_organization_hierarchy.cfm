<cfsetting showdebugoutput="no">
<cffunction name="draw_div" returntype="string">
	<cfargument name="department_id" type="string" required="true">
	<cfargument name="position_id" type="numeric" required="true">
	<cfargument name="last_hie" type="string" required="true">
	<cfargument name="query_row" type="numeric" required="true">
	<cfargument name="yeni_hierarchy" type="string" required="true">
	<cfargument name="employee_id" type="numeric" required="true">
	<cfargument name="position_name" type="string" required="true">
	<cfargument name="title" type="string" required="true">
	<cfargument name="position_cat" type="string" required="true">
	<cfargument name="employee_name" type="string" required="true">
	<cfargument name="employee_surname" type="string" required="true">
	<cfargument name="position_code" type="numeric" required="true">
	<cfargument name="is_critical" type="numeric" required="true">
	<cfargument name="is_vekaleten" type="numeric" required="true">
	<cfargument name="DEPARTMENT_HEAD" type="string" required="true">
	<cfset 'my_resim_#arguments.department_id#' = "">
	
	<cfif arguments.query_row lte get_all_workgroup_roles2.recordcount>
		<cfif find('#arguments.yeni_hierarchy#.',get_all_workgroup_roles2.yeni_hierarchy[arguments.query_row+1])>
			<cfset is_alt = 1>
		<cfelse>
			<cfset is_alt = 0>
		</cfif>
	</cfif>
	
	<cfif listfindnocase(main_employee_list,arguments.employee_id)>
		<cfset 'my_resim_#department_id#' = "#get_resimler.PHOTO[listfind(main_employee_list,employee_id,',')]#">
	</cfif>
	
	<cfset aktif_kademe = listlen(arguments.yeni_hierarchy,'.')-1>
	<cfset my_kademe = 0>
	<cfset my_cizgi_yuksekligi = (aktif_kademe + 1) * cizgi_yuksekligi>
	
	<cfset my_grup_uzunlugu = listlen(arguments.yeni_hierarchy,'.')>
	
	<cfif my_kademe gt aktif_kademe>
		<cfset kademe_eklentisi = ((my_kademe - aktif_kademe) * kutu_yuksekligi)>
	<cfelse>
		<cfset kademe_eklentisi = 0>
	</cfif>
	<cfif last_hie neq 0>
		<cfif (listlen(arguments.yeni_hierarchy,'.') gt last_hie)>
			<cfset my_left = my_left>
		<cfelseif (listlen(arguments.yeni_hierarchy,'.') lt last_hie)>
			<cfset my_left = my_left + kutu_genisligi + 20>
		<cfelseif (listlen(arguments.yeni_hierarchy,'.') eq last_hie)>
			<cfset my_left = my_left + kutu_genisligi + 20>
		</cfif>
	<cfelse>
		<cfset my_left = 30>
	</cfif>
	
	<cfset my_top = (((listlen(arguments.yeni_hierarchy,'.') - (my_default_hie-1))* kutu_yuksekligi)+10)+my_top_eklenti>
	<cfscript>
		div_spe = 'border: 1px';
		if(arguments.EMPLOYEE_ID gt 0)div_spe = div_spe & ' solid';else div_spe = div_spe & ' dashed';
		if(arguments.is_critical eq 1)div_spe = div_spe & ' red;';else div_spe = div_spe & ' ##666666';
		if(arguments.is_vekaleten eq 1)my_vekil= '<b>(V)</b>';else my_vekil= '';
		deger = '<div id="cizim_#arguments.department_id#" style="position:absolute;z-index:2;left:#my_left#px;top:#my_top+15#px;width:#kutu_genisligi#px;height:#kutu_yuksekligi+kademe_eklentisi#px;">';
		deger = deger & '<table width="100%" cellpadding="0" cellspacing="0">';
		deger = deger & '<tr><td style="text-align:center;" height="15"><img src="/images/cizgi_dik_1pix.gif" height="15" width="3"></td></tr>';
		deger = deger & '<tr><td style="#div_spe#"><table cellpadding="2" cellspacing="0" width="100%">';
		if(isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 2 and isdefined("attributes.is_resim") and len(evaluate("my_resim_#department_id#")))
			deger = deger & '<tr><td align="center" height="#resim_yuksekligi#">
			 <img src="/documents/hr/#evaluate("my_resim_#department_id#")#" height="#resim_yuksekligi#" width="#resim_genisligi#">
			</td></tr>';
		else if(isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 2 and isdefined("attributes.is_resim"))
			deger = deger & '<tr><td align="center" height="#resim_yuksekligi#">&nbsp;</td></tr>';
				deger = deger & '<tr>';
		if(isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 1 and isdefined("attributes.is_resim") and len(evaluate("my_resim_#department_id#")))
			deger = deger & '<td width="#resim_genisligi#">
	         <img src="/documents/hr/#evaluate("my_resim_#department_id#")#" height="#resim_yuksekligi#" width="#resim_genisligi#">
			</td>';
		else if(isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 1 and isdefined("attributes.is_resim")) 
			deger = deger & '<td width="#resim_genisligi#">&nbsp;</td>';
		
		deger = deger & '<td style="height:#kutu_yuksekligi_ilk#px;" align="center">';
		deger = deger & '<table align="center" cellpadding="0" cellspacing="0">';
		deger = deger & '<tr><td align="center"><b>#DEPARTMENT_HEAD#</b></td></tr>';
		if(isdefined("attributes.is_pozisyon"))
			deger = deger & '<tr><td align="center">#arguments.POSITION_NAME#</td></tr>';
		if(not isdefined("attributes.is_off_pozisyon"))
			deger = deger & '<tr><td align="center"><a href="javascript://" onclick="windowopen(''#request.self#?fuseaction=objects.popup_emp_det&emp_id=#arguments.EMPLOYEE_ID#'',''medium'');" class="tableyazi">#arguments.EMPLOYEE_NAME# #arguments.EMPLOYEE_SURNAME# #my_vekil#</a></td></tr>';
		if(isdefined("attributes.is_pozisyon_tipi"))
			deger = deger & '<tr><td align="center">#POSITION_CAT#</td></tr>';
		if(isdefined("attributes.is_unvan"))
			deger = deger & '<tr><td align="center">#TITLE#</td></tr>';
		deger = deger & '</table></td></tr></table>';
		if(is_alt eq 1)
			{
				deger = deger & '<tr><td style="text-align:center;" height="#cizgi_yuksekligi#">
				<img src="/images/cizgi_dik_1pix.gif" height="#cizgi_yuksekligi#" width="3">
				</td></tr>';
			}
		deger = deger & '</table></div>';
		my_son_left = my_left + kutu_genisligi;
	</cfscript>
	<cfreturn deger>
</cffunction>
<cfset my_top_eklenti = 5>
<cfset kademe_sayisi = 0>
<cfset kademe_carpani = 20>
<cfset kutu_yuksekligi_ilk = 60>
<cfset kutu_genisligi_ilk = 130>
<cfset resim_yuksekligi = 80>
<cfset resim_genisligi = 60>
<cfset my_default_hie = 1>
<cfset cizgi_yuksekligi = 15>
<cfset my_son_left = 1>
<cfif isdefined("attributes.is_pozisyon")>
	<cfset kutu_yuksekligi_ilk = kutu_yuksekligi_ilk + 15>
</cfif>
<cfif isdefined("attributes.is_unvan")>
	<cfset kutu_yuksekligi_ilk = kutu_yuksekligi_ilk + 15>
</cfif>
<cfif isdefined("attributes.is_pozisyon_tipi")>
	<cfset kutu_yuksekligi_ilk = kutu_yuksekligi_ilk + 15>
</cfif>
<cfif isdefined("attributes.is_resim")>
	<cfset kutu_yuksekligi_ilk = 85>
</cfif>


<cfif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 1 and isdefined("attributes.is_resim")>
	<cfset kutu_genisligi = kutu_genisligi_ilk + resim_genisligi>
	<cfset kutu_yuksekligi = kutu_yuksekligi_ilk + 30>
<cfelseif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 2 and isdefined("attributes.is_resim")>
	<cfset kutu_yuksekligi = kutu_yuksekligi_ilk + resim_yuksekligi + 30>
	<cfset kutu_genisligi = kutu_genisligi_ilk>
<cfelse>
	<cfset kutu_yuksekligi = kutu_yuksekligi_ilk + 30>
	<cfset kutu_genisligi = kutu_genisligi_ilk>
</cfif>

<cfif attributes.baglilik eq 1>
	<cfif (len(attributes.our_company_id) and len(attributes.our_company)) or (len(attributes.headquarters_id) and len(attributes.headquarters_name)) or len(attributes.related_company)>
		<cfset ilk_amir = "MANAGER_POSITION_CODE">
		<cfset ilk_amir_diger = "ADMIN1_POSITION_CODE">
	<cfelse>
		<cfset ilk_amir = "ADMIN1_POSITION_CODE">
	</cfif>
<cfelse>
	<cfif (len(attributes.our_company_id) and len(attributes.our_company)) or (len(attributes.headquarters_id) and len(attributes.headquarters_name)) or len(attributes.related_company)>
		<cfset ilk_amir = "MANAGER_POSITION_CODE2">
		<cfset ilk_amir_diger = "ADMIN2_POSITION_CODE">
	<cfelse>
		<cfset ilk_amir = "ADMIN2_POSITION_CODE">
	</cfif>
</cfif>
<cfset get_all_workgroup_roles = QueryNew("DEPARTMENT_ID,DEPARTMENT_HEAD,POSITION_CODE,POSITION_ID,IS_CRITICAL,IS_VEKALETEN,YENI_HIERARCHY,EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME,POSITION_NAME,POSITION_CAT,TITLE","VarChar,VarChar,Integer,Integer,Integer,Integer,VarChar,Integer,VarChar,VarChar,VarChar,VarChar,VarChar")>
<cfset ROW_OF_QUERY = 0>
<cfset sira_no = 0>
<cfset my_count_ = 0>
<cfset is_yatay_cizgi = 0>
	<cfif len(attributes.headquarters_id) and len(attributes.headquarters_name)>
		<cfquery name="get_upper" datasource="#dsn#">
			SELECT 
				'' AS POSITION_NAME,
				'' AS EMPLOYEE_NAME,
				'' AS EMPLOYEE_SURNAME,
				0 AS EMPLOYEE_ID,
				'' AS POSITION_CAT,
				'' AS TITLE,
				'' AS PHOTO,
				NAME AS ORG_NAME
			FROM  
				SETUP_HEADQUARTERS
			WHERE 
				IS_ORGANIZATION = 1 AND
				HEADQUARTERS_ID = #attributes.headquarters_id#
		</cfquery>
		<cfquery name="get_companies" datasource="#dsn#">
			SELECT
				O.COMP_ID,
				O.NICK_NAME,
				EP.EMPLOYEE_NAME,
				EP.EMPLOYEE_SURNAME,
				EP.POSITION_CODE,
				EP.POSITION_ID,
				EP.IS_CRITICAL,
				EP.IS_VEKALETEN,
				EP.EMPLOYEE_ID,
				EP.POSITION_NAME,
				SPC.POSITION_CAT,
				ST.TITLE
			FROM
				OUR_COMPANY O,
				EMPLOYEE_POSITIONS EP,
				SETUP_POSITION_CAT SPC,
				SETUP_TITLE ST
			WHERE
				O.IS_ORGANIZATION = 1 AND
				O.HEADQUARTERS_ID = #attributes.HEADQUARTERS_ID# AND
				O.#ilk_amir# = EP.POSITION_CODE AND
				EP.TITLE_ID = ST.TITLE_ID AND
				EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID
			UNION ALL
			SELECT
				O.COMP_ID,
				O.NICK_NAME,
				'' AS EMPLOYEE_NAME,
				'' AS EMPLOYEE_SURNAME,
				0 AS POSITION_CODE,
				0 AS POSITION_ID,
				0 AS IS_CRITICAL,
				0 AS IS_VEKALETEN,
				0 AS EMPLOYEE_ID,
				'' AS POSITION_NAME,
				'' AS POSITION_CAT,
				'' AS TITLE
			FROM
				OUR_COMPANY O
			WHERE
				O.IS_ORGANIZATION = 1 AND
				O.HEADQUARTERS_ID = #attributes.HEADQUARTERS_ID# AND
				O.#ilk_amir# IS NULL
		</cfquery>
		<cfif not get_companies.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='56724.Kayıtlı Alt Birim Bulunamadı'>!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset company_id_list = listsort(valuelist(get_companies.COMP_ID),'numeric','ASC',',')>
		<cfset my_employee_list = valuelist(get_companies.employee_id)>
		<cfloop list="#company_id_list#" index="mk">
				<cfscript>
					yeni_hier = get_companies.COMP_ID[listfindnocase(company_id_list,mk,',')];
					dpt_id = 'a' & '#get_companies.COMP_ID[listfindnocase(company_id_list,mk,',')]#';
					if(listlen(yeni_hier,'.') eq 1) is_yatay_cizgi = is_yatay_cizgi + 1; 
					ROW_OF_QUERY = ROW_OF_QUERY + 1;
					QueryAddRow(get_all_workgroup_roles,1);
					QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_ID",dpt_id,ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_HEAD",get_companies.NICK_NAME[listfindnocase(company_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"POSITION_CODE",get_companies.position_code[listfindnocase(company_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"POSITION_ID",get_companies.POSITION_ID[listfindnocase(company_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"IS_CRITICAL",get_companies.IS_CRITICAL[listfindnocase(company_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"IS_VEKALETEN",get_companies.IS_VEKALETEN[listfindnocase(company_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"YENI_HIERARCHY",yeni_hier,ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_ID",get_companies.EMPLOYEE_ID[listfindnocase(company_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_NAME",get_companies.EMPLOYEE_NAME[listfindnocase(company_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_SURNAME",get_companies.EMPLOYEE_SURNAME[listfindnocase(company_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"POSITION_NAME",get_companies.POSITION_NAME[listfindnocase(company_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"POSITION_CAT",get_companies.POSITION_CAT[listfindnocase(company_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"TITLE",get_companies.TITLE[listfindnocase(company_id_list,mk,',')],ROW_OF_QUERY);
				</cfscript>
		</cfloop>
		
			<cfif attributes.alt_cizim_sayisi gt 1>
					<cfquery name="get_branches" datasource="#dsn#">
						SELECT
							B.COMPANY_ID,
							B.BRANCH_ID,
							B.BRANCH_NAME,
							EP.EMPLOYEE_NAME,
							EP.EMPLOYEE_SURNAME,
							EP.POSITION_CODE,
							EP.POSITION_ID,
							EP.IS_CRITICAL,
							EP.IS_VEKALETEN,
							EP.EMPLOYEE_ID,
							EP.POSITION_NAME,
							SPC.POSITION_CAT,
							ST.TITLE
						FROM
							BRANCH B,
							EMPLOYEE_POSITIONS EP,
							SETUP_POSITION_CAT SPC,
							SETUP_TITLE ST
						WHERE
							B.IS_ORGANIZATION = 1 AND
							B.COMPANY_ID IN (#company_id_list#) AND
							B.#ilk_amir_diger# = EP.POSITION_CODE AND
							EP.TITLE_ID = ST.TITLE_ID AND
							EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID
						UNION ALL
						SELECT
							B.COMPANY_ID,
							B.BRANCH_ID,
							B.BRANCH_NAME,
							'' AS EMPLOYEE_NAME,
							'' AS EMPLOYEE_SURNAME,
							0 AS POSITION_CODE,
							0 AS POSITION_ID,
							0 AS IS_CRITICAL,
							0 AS IS_VEKALETEN,
							0 AS EMPLOYEE_ID,
							'' AS POSITION_NAME,
							'' AS POSITION_CAT,
							'' AS TITLE
						FROM
							BRANCH B
						WHERE
							B.IS_ORGANIZATION = 1 AND
							B.COMPANY_ID IN (#company_id_list#) AND
							B.#ilk_amir_diger# IS NULL
					</cfquery>
					<cfif get_branches.recordcount>
						<cfset branch_id_list = listsort(valuelist(get_branches.branch_id),'numeric','ASC',',')>
						<cfloop list="#branch_id_list#" index="mk">
								<cfscript>
									yeni_hier = get_branches.BRANCH_ID[listfindnocase(branch_id_list,mk,',')];
									yeni_hier = '#get_branches.COMPANY_ID[listfindnocase(branch_id_list,mk,',')]#.' & 'b' & get_branches.BRANCH_ID[listfindnocase(branch_id_list,mk,',')];
									dpt_id = 'b' & '#get_branches.BRANCH_ID[listfindnocase(branch_id_list,mk,',')]#';
									my_employee_list = listappend(my_employee_list,get_branches.EMPLOYEE_ID[listfindnocase(branch_id_list,mk,',')]);
									ROW_OF_QUERY = ROW_OF_QUERY + 1;
									QueryAddRow(get_all_workgroup_roles,1);
									QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_ID",dpt_id,ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_HEAD",get_branches.BRANCH_NAME[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"POSITION_CODE",get_branches.position_code[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"POSITION_ID",get_branches.POSITION_ID[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"IS_CRITICAL",get_branches.IS_CRITICAL[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"IS_VEKALETEN",get_branches.IS_VEKALETEN[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"YENI_HIERARCHY",yeni_hier,ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_ID",get_branches.EMPLOYEE_ID[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_NAME",get_branches.EMPLOYEE_NAME[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_SURNAME",get_branches.EMPLOYEE_SURNAME[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"POSITION_NAME",get_branches.POSITION_NAME[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"POSITION_CAT",get_branches.POSITION_CAT[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"TITLE",get_branches.TITLE[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
								</cfscript>
						</cfloop>
						<cfif attributes.alt_cizim_sayisi gt 2>
								<cfquery name="get_all_departments" datasource="#dsn#">
									SELECT
										B.COMPANY_ID,
										D.BRANCH_ID,
										D.DEPARTMENT_ID,
										D.DEPARTMENT_HEAD,
										EP.EMPLOYEE_NAME,
										EP.EMPLOYEE_SURNAME,
										EP.POSITION_CODE,
										EP.POSITION_ID,
										EP.IS_CRITICAL,
										EP.IS_VEKALETEN,
										EP.EMPLOYEE_ID,
										EP.POSITION_NAME,
										SPC.POSITION_CAT,
										ST.TITLE,
										D.HIERARCHY_DEP_ID
									FROM
										DEPARTMENT D,
										EMPLOYEE_POSITIONS EP,
										SETUP_POSITION_CAT SPC,
										SETUP_TITLE ST,
										BRANCH B
									WHERE
										D.IS_ORGANIZATION = 1 AND
										D.BRANCH_ID = B.BRANCH_ID AND
										D.#ilk_amir_diger# = EP.POSITION_CODE AND
										EP.TITLE_ID = ST.TITLE_ID AND
										EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID AND
										D.BRANCH_ID IN (#branch_id_list#)
								UNION ALL
									SELECT
										B.COMPANY_ID,
										D.BRANCH_ID,
										D.DEPARTMENT_ID,
										D.DEPARTMENT_HEAD,
										'' AS EMPLOYEE_NAME,
										'' AS EMPLOYEE_SURNAME,
										0 AS POSITION_CODE,
										0 AS POSITION_ID,
										0 AS IS_CRITICAL,
										0 AS IS_VEKALETEN,
										0 AS EMPLOYEE_ID,
										'' AS POSITION_NAME,
										'' AS POSITION_CAT,
										'' AS TITLE,
										D.HIERARCHY_DEP_ID
									FROM
										DEPARTMENT D,
										BRANCH B
									WHERE
										D.IS_ORGANIZATION = 1 AND
										D.BRANCH_ID = B.BRANCH_ID AND
										D.BRANCH_ID IN (#branch_id_list#) AND
										D.#ilk_amir_diger# IS NULL
								</cfquery>
									<cfset department_id_list = listsort(valuelist(get_all_departments.DEPARTMENT_ID),'numeric','ASC',',')>
									<cfloop list="#department_id_list#" index="mk">
										<cfscript>
											dpt_id = 'c' & '#get_all_departments.DEPARTMENT_ID[listfindnocase(department_id_list,mk,',')]#';
											yeni_hier = get_all_departments.HIERARCHY_DEP_ID[listfindnocase(department_id_list,mk,',')];
											kabul_hie = yeni_hier;
											if(not len(yeni_hier)) {kabul_hie = '#get_all_departments.DEPARTMENT_ID[listfindnocase(department_id_list,mk,',')]#'; yeni_hier = 'c' & '#kabul_hie#';}
											
											get_kademes = cfquery(dbtype:"query",datasource:"#dsn#",sqlstring:"SELECT * FROM  get_all_departments WHERE DEPARTMENT_ID = #listfirst(kabul_hie,'.')#");
											yeni_hier = '#get_kademes.COMPANY_ID#.' & 'b#get_kademes.BRANCH_ID#.' & '#yeni_hier#';
											
											if(listlen(yeni_hier,'.') lte attributes.alt_cizim_sayisi)
											{
												my_employee_list = listappend(my_employee_list,get_all_departments.EMPLOYEE_ID[listfindnocase(department_id_list,mk,',')]);
												ROW_OF_QUERY = ROW_OF_QUERY + 1;
												QueryAddRow(get_all_workgroup_roles,1);
												QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_ID",dpt_id,ROW_OF_QUERY);
												QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_HEAD",get_all_departments.DEPARTMENT_HEAD[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
												QuerySetCell(get_all_workgroup_roles,"POSITION_CODE",get_all_departments.position_code[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
												QuerySetCell(get_all_workgroup_roles,"POSITION_ID",get_all_departments.POSITION_ID[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
												QuerySetCell(get_all_workgroup_roles,"IS_CRITICAL",get_all_departments.IS_CRITICAL[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
												QuerySetCell(get_all_workgroup_roles,"IS_VEKALETEN",get_all_departments.IS_VEKALETEN[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
												QuerySetCell(get_all_workgroup_roles,"YENI_HIERARCHY",yeni_hier,ROW_OF_QUERY);
												QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_ID",get_all_departments.EMPLOYEE_ID[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
												QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_NAME",get_all_departments.EMPLOYEE_NAME[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
												QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_SURNAME",get_all_departments.EMPLOYEE_SURNAME[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
												QuerySetCell(get_all_workgroup_roles,"POSITION_NAME",get_all_departments.POSITION_NAME[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
												QuerySetCell(get_all_workgroup_roles,"POSITION_CAT",get_all_departments.POSITION_CAT[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
												QuerySetCell(get_all_workgroup_roles,"TITLE",get_all_departments.TITLE[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
											}
										</cfscript>
									</cfloop>
						</cfif>				
					</cfif>
			</cfif>
	<cfelseif len(attributes.our_company_id) and len(attributes.our_company)>
		<cfquery name="get_upper" datasource="#dsn#">
			SELECT 
				EMPLOYEE_POSITIONS.POSITION_NAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_ID,
				SETUP_POSITION_CAT.POSITION_CAT,
				SETUP_TITLE.TITLE,
				EMPLOYEES.PHOTO,
				OUR_COMPANY.NICK_NAME AS ORG_NAME
			FROM  
				EMPLOYEE_POSITIONS,
				SETUP_POSITION_CAT,
				SETUP_TITLE,
				EMPLOYEES,
				OUR_COMPANY
			WHERE 
				OUR_COMPANY.IS_ORGANIZATION = 1 AND
				OUR_COMPANY.#ilk_amir# = EMPLOYEE_POSITIONS.POSITION_CODE AND
				EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
				EMPLOYEE_POSITIONS.TITLE_ID = SETUP_TITLE.TITLE_ID AND
				EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID AND
				OUR_COMPANY.COMP_ID = #attributes.our_company_id#
			UNION ALL
			SELECT 
				'' AS POSITION_NAME,
				'' AS EMPLOYEE_NAME,
				'' AS EMPLOYEE_SURNAME,
				0 AS EMPLOYEE_ID,
				'' AS POSITION_CAT,
				'' AS TITLE,
				'' AS PHOTO,
				OUR_COMPANY.NICK_NAME AS ORG_NAME
			FROM  
				OUR_COMPANY
			WHERE 
				OUR_COMPANY.IS_ORGANIZATION = 1 AND
				OUR_COMPANY.COMP_ID = #attributes.our_company_id# AND
				OUR_COMPANY.#ilk_amir# IS NULL
		</cfquery>
		<cfquery name="get_branches" datasource="#dsn#">
			SELECT
				B.BRANCH_ID,
				B.BRANCH_NAME,
				EP.EMPLOYEE_NAME,
				EP.EMPLOYEE_SURNAME,
				EP.POSITION_CODE,
				EP.POSITION_ID,
				EP.IS_CRITICAL,
				EP.IS_VEKALETEN,
				EP.EMPLOYEE_ID,
				EP.POSITION_NAME,
				SPC.POSITION_CAT,
				ST.TITLE
			FROM
				BRANCH B,
				EMPLOYEE_POSITIONS EP,
				SETUP_POSITION_CAT SPC,
				SETUP_TITLE ST
			WHERE
				B.IS_ORGANIZATION = 1 AND
				B.COMPANY_ID = #attributes.our_company_id# AND
				B.#ilk_amir_diger# = EP.POSITION_CODE AND
				EP.TITLE_ID = ST.TITLE_ID AND
				EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID
			UNION ALL
			SELECT
				B.BRANCH_ID,
				B.BRANCH_NAME,
				'' AS EMPLOYEE_NAME,
				'' AS EMPLOYEE_SURNAME,
				0 AS POSITION_CODE,
				0 AS POSITION_ID,
				0 AS IS_CRITICAL,
				0 AS IS_VEKALETEN,
				0 AS EMPLOYEE_ID,
				'' AS POSITION_NAME,
				'' AS POSITION_CAT,
				'' AS TITLE
			FROM
				BRANCH B
			WHERE
				B.IS_ORGANIZATION = 1 AND
				B.COMPANY_ID = #attributes.our_company_id# AND
				B.#ilk_amir_diger# IS NULL
		</cfquery>
		<cfif not get_branches.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='56724.Kayıtlı Alt Birim Bulunamadı!'>");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset branch_id_list = listsort(valuelist(get_branches.branch_id),'numeric','ASC',',')>
		<cfset my_employee_list = valuelist(get_branches.employee_id)>
		<cfloop list="#branch_id_list#" index="mk">
				<cfscript>
					yeni_hier = get_branches.BRANCH_ID[listfindnocase(branch_id_list,mk,',')];
					dpt_id = 'a' & '#get_branches.BRANCH_ID[listfindnocase(branch_id_list,mk,',')]#';
					if(listlen(yeni_hier,'.') eq 1) is_yatay_cizgi = is_yatay_cizgi + 1; 
					ROW_OF_QUERY = ROW_OF_QUERY + 1;
					QueryAddRow(get_all_workgroup_roles,1);
					QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_ID",dpt_id,ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_HEAD",get_branches.BRANCH_NAME[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"POSITION_CODE",get_branches.position_code[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"POSITION_ID",get_branches.POSITION_ID[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"IS_CRITICAL",get_branches.IS_CRITICAL[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"IS_VEKALETEN",get_branches.IS_VEKALETEN[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"YENI_HIERARCHY",yeni_hier,ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_ID",get_branches.EMPLOYEE_ID[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_NAME",get_branches.EMPLOYEE_NAME[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_SURNAME",get_branches.EMPLOYEE_SURNAME[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"POSITION_NAME",get_branches.POSITION_NAME[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"POSITION_CAT",get_branches.POSITION_CAT[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"TITLE",get_branches.TITLE[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
				</cfscript>
		</cfloop>
				<cfif attributes.alt_cizim_sayisi gt 1>
					<cfquery name="get_all_departments" datasource="#dsn#">
						SELECT
							D.BRANCH_ID,
							D.DEPARTMENT_ID,
							D.DEPARTMENT_HEAD,
							EP.EMPLOYEE_NAME,
							EP.EMPLOYEE_SURNAME,
							EP.POSITION_CODE,
							EP.POSITION_ID,
							EP.IS_CRITICAL,
							EP.IS_VEKALETEN,
							EP.EMPLOYEE_ID,
							EP.POSITION_NAME,
							SPC.POSITION_CAT,
							ST.TITLE,
							D.HIERARCHY_DEP_ID
						FROM
							DEPARTMENT D,
							EMPLOYEE_POSITIONS EP,
							SETUP_POSITION_CAT SPC,
							SETUP_TITLE ST
						WHERE
							D.IS_ORGANIZATION = 1 AND
							D.#ilk_amir_diger# = EP.POSITION_CODE AND
							EP.TITLE_ID = ST.TITLE_ID AND
							EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID AND
							D.BRANCH_ID IN (#branch_id_list#)
					UNION ALL
						SELECT
							D.BRANCH_ID,
							D.DEPARTMENT_ID,
							D.DEPARTMENT_HEAD,
							'' AS EMPLOYEE_NAME,
							'' AS EMPLOYEE_SURNAME,
							0 AS POSITION_CODE,
							0 AS POSITION_ID,
							0 AS IS_CRITICAL,
							0 AS IS_VEKALETEN,
							0 AS EMPLOYEE_ID,
							'' AS POSITION_NAME,
							'' AS POSITION_CAT,
							'' AS TITLE,
							D.HIERARCHY_DEP_ID
						FROM
							DEPARTMENT D
						WHERE
							D.IS_ORGANIZATION = 1 AND
							D.BRANCH_ID IN (#branch_id_list#) AND
							D.#ilk_amir_diger# IS NULL
					</cfquery>
						<cfset department_id_list = listsort(valuelist(get_all_departments.DEPARTMENT_ID),'numeric','ASC',',')>
						<cfloop list="#department_id_list#" index="mk">
							<cfscript>
							dpt_id = 'b' & '#get_all_departments.DEPARTMENT_ID[listfindnocase(department_id_list,mk,',')]#';
							yeni_hier = get_all_departments.HIERARCHY_DEP_ID[listfindnocase(department_id_list,mk,',')];
							kabul_hie = yeni_hier;
							if(not len(yeni_hier)) {kabul_hie = '#get_all_departments.DEPARTMENT_ID[listfindnocase(department_id_list,mk,',')]#'; yeni_hier = '#kabul_hie#';}
							
							get_kademes = cfquery(dbtype:"query",datasource:"#dsn#",sqlstring:"SELECT * FROM  get_all_departments WHERE DEPARTMENT_ID = #listfirst(kabul_hie,'.')#");
							yeni_hier = '#get_kademes.BRANCH_ID#.' & '#yeni_hier#';

								if(listlen(yeni_hier,'.') lte attributes.alt_cizim_sayisi)
								{
									my_employee_list = listappend(my_employee_list,get_all_departments.EMPLOYEE_ID[listfindnocase(department_id_list,mk,',')]);
									ROW_OF_QUERY = ROW_OF_QUERY + 1;
									QueryAddRow(get_all_workgroup_roles,1);
									QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_ID",dpt_id,ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_HEAD",get_all_departments.DEPARTMENT_HEAD[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"POSITION_CODE",get_all_departments.position_code[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"POSITION_ID",get_all_departments.POSITION_ID[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"IS_CRITICAL",get_all_departments.IS_CRITICAL[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"IS_VEKALETEN",get_all_departments.IS_VEKALETEN[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"YENI_HIERARCHY",yeni_hier,ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_ID",get_all_departments.EMPLOYEE_ID[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_NAME",get_all_departments.EMPLOYEE_NAME[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_SURNAME",get_all_departments.EMPLOYEE_SURNAME[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"POSITION_NAME",get_all_departments.POSITION_NAME[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"POSITION_CAT",get_all_departments.POSITION_CAT[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"TITLE",get_all_departments.TITLE[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
								}
							</cfscript>
						</cfloop>
				</cfif>
	<cfelseif len(attributes.related_company)>
		<cfquery name="get_upper" datasource="#dsn#" maxrows="1">
			SELECT 
				'' AS POSITION_NAME,
				'' AS EMPLOYEE_NAME,
				'' AS EMPLOYEE_SURNAME,
				0 AS EMPLOYEE_ID,
				'' AS POSITION_CAT,
				'' AS TITLE,
				'' AS PHOTO,
				RELATED_COMPANY AS ORG_NAME
			FROM  
				BRANCH
			WHERE 
				RELATED_COMPANY = '#attributes.related_company#'
		</cfquery>
		<cfquery name="get_branches" datasource="#dsn#">
			SELECT
				B.BRANCH_ID,
				B.BRANCH_NAME,
				EP.EMPLOYEE_NAME,
				EP.EMPLOYEE_SURNAME,
				EP.POSITION_CODE,
				EP.POSITION_ID,
				EP.IS_CRITICAL,
				EP.IS_VEKALETEN,
				EP.EMPLOYEE_ID,
				EP.POSITION_NAME,
				SPC.POSITION_CAT,
				ST.TITLE
			FROM
				BRANCH B,
				EMPLOYEE_POSITIONS EP,
				SETUP_POSITION_CAT SPC,
				SETUP_TITLE ST
			WHERE
				B.IS_ORGANIZATION = 1 AND
				B.RELATED_COMPANY = '#attributes.related_company#' AND
				B.#ilk_amir_diger# = EP.POSITION_CODE AND
				EP.TITLE_ID = ST.TITLE_ID AND
				EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID
			UNION ALL
			SELECT
				B.BRANCH_ID,
				B.BRANCH_NAME,
				'' AS EMPLOYEE_NAME,
				'' AS EMPLOYEE_SURNAME,
				0 AS POSITION_CODE,
				0 AS POSITION_ID,
				0 AS IS_CRITICAL,
				0 AS IS_VEKALETEN,
				0 AS EMPLOYEE_ID,
				'' AS POSITION_NAME,
				'' AS POSITION_CAT,
				'' AS TITLE
			FROM
				BRANCH B
			WHERE
				B.IS_ORGANIZATION = 1 AND
				B.RELATED_COMPANY = '#attributes.related_company#' AND
				B.#ilk_amir_diger# IS NULL
		</cfquery>
		<cfif not get_branches.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='56724.Kayıtlı Alt Birim Bulunamadı'>!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset branch_id_list = listsort(valuelist(get_branches.branch_id),'numeric','ASC',',')>
		<cfset my_employee_list = valuelist(get_branches.employee_id)>
		<cfloop list="#branch_id_list#" index="mk">
				<cfscript>
					yeni_hier = get_branches.BRANCH_ID[listfindnocase(branch_id_list,mk,',')];
					dpt_id = 'a' & '#get_branches.BRANCH_ID[listfindnocase(branch_id_list,mk,',')]#';
					if(listlen(yeni_hier,'.') eq 1) is_yatay_cizgi = is_yatay_cizgi + 1; 
					ROW_OF_QUERY = ROW_OF_QUERY + 1;
					QueryAddRow(get_all_workgroup_roles,1);
					QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_ID",dpt_id,ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_HEAD",get_branches.BRANCH_NAME[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"POSITION_CODE",get_branches.position_code[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"POSITION_ID",get_branches.POSITION_ID[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"IS_CRITICAL",get_branches.IS_CRITICAL[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"IS_VEKALETEN",get_branches.IS_VEKALETEN[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"YENI_HIERARCHY",yeni_hier,ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_ID",get_branches.EMPLOYEE_ID[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_NAME",get_branches.EMPLOYEE_NAME[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_SURNAME",get_branches.EMPLOYEE_SURNAME[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"POSITION_NAME",get_branches.POSITION_NAME[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"POSITION_CAT",get_branches.POSITION_CAT[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
					QuerySetCell(get_all_workgroup_roles,"TITLE",get_branches.TITLE[listfindnocase(branch_id_list,mk,',')],ROW_OF_QUERY);
				</cfscript>
		</cfloop>
				<cfif attributes.alt_cizim_sayisi gt 1>
					<cfquery name="get_all_departments" datasource="#dsn#">
						SELECT
							D.BRANCH_ID,
							D.DEPARTMENT_ID,
							D.DEPARTMENT_HEAD,
							EP.EMPLOYEE_NAME,
							EP.EMPLOYEE_SURNAME,
							EP.POSITION_CODE,
							EP.POSITION_ID,
							EP.IS_CRITICAL,
							EP.IS_VEKALETEN,
							EP.EMPLOYEE_ID,
							EP.POSITION_NAME,
							SPC.POSITION_CAT,
							ST.TITLE,
							D.HIERARCHY_DEP_ID
						FROM
							DEPARTMENT D,
							EMPLOYEE_POSITIONS EP,
							SETUP_POSITION_CAT SPC,
							SETUP_TITLE ST
						WHERE
							D.IS_ORGANIZATION = 1 AND
							D.#ilk_amir_diger# = EP.POSITION_CODE AND
							EP.TITLE_ID = ST.TITLE_ID AND
							EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID AND
							D.BRANCH_ID IN (#branch_id_list#)
					UNION ALL
						SELECT
							D.BRANCH_ID,
							D.DEPARTMENT_ID,
							D.DEPARTMENT_HEAD,
							'' AS EMPLOYEE_NAME,
							'' AS EMPLOYEE_SURNAME,
							0 AS POSITION_CODE,
							0 AS POSITION_ID,
							0 AS IS_CRITICAL,
							0 AS IS_VEKALETEN,
							0 AS EMPLOYEE_ID,
							'' AS POSITION_NAME,
							'' AS POSITION_CAT,
							'' AS TITLE,
							D.HIERARCHY_DEP_ID
						FROM
							DEPARTMENT D
						WHERE
							D.IS_ORGANIZATION = 1 AND
							D.BRANCH_ID IN (#branch_id_list#) AND
							D.#ilk_amir_diger# IS NULL
					</cfquery>
						<cfset department_id_list = listsort(valuelist(get_all_departments.DEPARTMENT_ID),'numeric','ASC',',')>
						<cfloop list="#department_id_list#" index="mk">
							<cfscript>
							dpt_id = 'b' & '#get_all_departments.DEPARTMENT_ID[listfindnocase(department_id_list,mk,',')]#';
							yeni_hier = get_all_departments.HIERARCHY_DEP_ID[listfindnocase(department_id_list,mk,',')];
							kabul_hie = yeni_hier;
							if(not len(yeni_hier)) {kabul_hie = '#get_all_departments.DEPARTMENT_ID[listfindnocase(department_id_list,mk,',')]#'; yeni_hier = '#kabul_hie#';}
							
							get_kademes = cfquery(dbtype:"query",datasource:"#dsn#",sqlstring:"SELECT * FROM  get_all_departments WHERE DEPARTMENT_ID = #listfirst(kabul_hie,'.')#");
							yeni_hier = '#get_kademes.BRANCH_ID#.' & '#yeni_hier#';

								if(listlen(yeni_hier,'.') lte attributes.alt_cizim_sayisi)
								{
									my_employee_list = listappend(my_employee_list,get_all_departments.EMPLOYEE_ID[listfindnocase(department_id_list,mk,',')]);
									ROW_OF_QUERY = ROW_OF_QUERY + 1;
									QueryAddRow(get_all_workgroup_roles,1);
									QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_ID",dpt_id,ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_HEAD",get_all_departments.DEPARTMENT_HEAD[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"POSITION_CODE",get_all_departments.position_code[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"POSITION_ID",get_all_departments.POSITION_ID[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"IS_CRITICAL",get_all_departments.IS_CRITICAL[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"IS_VEKALETEN",get_all_departments.IS_VEKALETEN[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"YENI_HIERARCHY",yeni_hier,ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_ID",get_all_departments.EMPLOYEE_ID[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_NAME",get_all_departments.EMPLOYEE_NAME[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_SURNAME",get_all_departments.EMPLOYEE_SURNAME[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"POSITION_NAME",get_all_departments.POSITION_NAME[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"POSITION_CAT",get_all_departments.POSITION_CAT[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
									QuerySetCell(get_all_workgroup_roles,"TITLE",get_all_departments.TITLE[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
								}
							</cfscript>
						</cfloop>
				</cfif>
	<cfelseif len(attributes.branch_id) and len(attributes.branch)>
		<cfquery name="get_upper" datasource="#dsn#">
			SELECT 
				EMPLOYEE_POSITIONS.POSITION_NAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_ID,
				SETUP_POSITION_CAT.POSITION_CAT,
				SETUP_TITLE.TITLE,
				EMPLOYEES.PHOTO,
				BRANCH.BRANCH_NAME AS ORG_NAME
			FROM  
				EMPLOYEE_POSITIONS,
				SETUP_POSITION_CAT,
				SETUP_TITLE,
				EMPLOYEES,
				BRANCH
			WHERE 
				BRANCH.IS_ORGANIZATION = 1 AND
				BRANCH.#ilk_amir# = EMPLOYEE_POSITIONS.POSITION_CODE AND
				EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
				EMPLOYEE_POSITIONS.TITLE_ID = SETUP_TITLE.TITLE_ID AND
				EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID AND
				BRANCH.BRANCH_ID = #attributes.branch_id#
			UNION ALL
			SELECT 
				'' AS POSITION_NAME,
				'' AS EMPLOYEE_NAME,
				'' AS EMPLOYEE_SURNAME,
				0 AS EMPLOYEE_ID,
				'' AS POSITION_CAT,
				'' AS TITLE,
				'' AS PHOTO,
				BRANCH.BRANCH_NAME AS ORG_NAME
			FROM  
				BRANCH
			WHERE 
				BRANCH.IS_ORGANIZATION = 1 AND
				BRANCH.BRANCH_ID = #attributes.branch_id# AND
				BRANCH.#ilk_amir# IS NULL
		</cfquery>
		
		<cfquery name="get_all_departments" datasource="#dsn#">
				SELECT
					D.DEPARTMENT_ID,
					D.BRANCH_ID,
					D.DEPARTMENT_HEAD,
					EP.EMPLOYEE_NAME,
					EP.EMPLOYEE_SURNAME,
					EP.POSITION_CODE,
					EP.POSITION_ID,
					EP.IS_CRITICAL,
					EP.IS_VEKALETEN,
					EP.EMPLOYEE_ID,
					EP.POSITION_NAME,
					SPC.POSITION_CAT,
					ST.TITLE,
					D.HIERARCHY_DEP_ID
				FROM
					DEPARTMENT D,
					EMPLOYEE_POSITIONS EP,
					SETUP_POSITION_CAT SPC,
					SETUP_TITLE ST
				WHERE
					D.IS_ORGANIZATION = 1 AND
					D.#ilk_amir# = EP.POSITION_CODE AND
					EP.TITLE_ID = ST.TITLE_ID AND
					EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID
			UNION ALL
				SELECT
					D.DEPARTMENT_ID,
					D.BRANCH_ID,
					D.DEPARTMENT_HEAD,
					'' AS EMPLOYEE_NAME,
					'' AS EMPLOYEE_SURNAME,
					0 AS POSITION_CODE,
					0 AS POSITION_ID,
					0 AS IS_CRITICAL,
					0 AS IS_VEKALETEN,
					0 AS EMPLOYEE_ID,
					'' AS POSITION_NAME,
					'' AS POSITION_CAT,
					'' AS TITLE,
					D.HIERARCHY_DEP_ID
				FROM
					DEPARTMENT D
				WHERE
					D.IS_ORGANIZATION = 1 AND
					D.#ilk_amir# IS NULL
		</cfquery>
		<cfquery name="get_branch_dept" dbtype="query">
			SELECT DEPARTMENT_ID FROM get_all_departments WHERE BRANCH_ID = #attributes.branch_id#
		</cfquery>
		<cfif not get_branch_dept.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='56725.Uygun Kayıt Bulunamadı'>");
				window.close();
			</script>
			<cfabort>
		</cfif>
		<cfset ust_dept_list = valuelist(get_branch_dept.department_id)>
		<cfset department_id_list = valuelist(get_branch_dept.department_id)>
		<cfloop query="get_all_departments">
			<cfif len(HIERARCHY_DEP_ID) and listfindnocase(ust_dept_list,listfirst(HIERARCHY_DEP_ID,'.'),',')>
				<cfset department_id_list = listappend(department_id_list,department_id,',')>
			</cfif>
		</cfloop>
		<cfset my_employee_list = "">
		<cfquery name="get_all_departments" dbtype="query">
			SELECT * FROM get_all_departments WHERE DEPARTMENT_ID IN (#department_id_list#)
		</cfquery>
		<cfset department_id_list = listsort(listdeleteduplicates(valuelist(get_all_departments.department_id)),'numeric','ASC',',')>
		<cfloop list="#department_id_list#" index="mk">
				<cfscript>
					yeni_hier = get_all_departments.HIERARCHY_DEP_ID[listfindnocase(department_id_list,mk,',')];
					writeoutput(yeni_hier);
					if(not len(yeni_hier)) yeni_hier = get_all_departments.DEPARTMENT_ID[listfindnocase(department_id_list,mk,',')];
					if(listlen(yeni_hier,'.') eq 1) is_yatay_cizgi = is_yatay_cizgi + 1; 
					//if(listlen(yeni_hier,'.') eq 1 and listfindnocase(ust_dept_list,yeni_hier,','))
						if(listlen(yeni_hier,'.') lte attributes.alt_cizim_sayisi)
						{
							my_employee_list = listappend(my_employee_list,get_all_departments.EMPLOYEE_ID[listfindnocase(department_id_list,mk,',')]);
							ROW_OF_QUERY = ROW_OF_QUERY + 1;
							QueryAddRow(get_all_workgroup_roles,1);
							QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_ID",get_all_departments.DEPARTMENT_ID[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
							QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_HEAD",get_all_departments.DEPARTMENT_HEAD[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
							QuerySetCell(get_all_workgroup_roles,"POSITION_CODE",get_all_departments.position_code[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
							QuerySetCell(get_all_workgroup_roles,"POSITION_ID",get_all_departments.POSITION_ID[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
							QuerySetCell(get_all_workgroup_roles,"IS_CRITICAL",get_all_departments.IS_CRITICAL[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
							QuerySetCell(get_all_workgroup_roles,"IS_VEKALETEN",get_all_departments.IS_VEKALETEN[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
							QuerySetCell(get_all_workgroup_roles,"YENI_HIERARCHY",yeni_hier,ROW_OF_QUERY);
							QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_ID",get_all_departments.EMPLOYEE_ID[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
							QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_NAME",get_all_departments.EMPLOYEE_NAME[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
							QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_SURNAME",get_all_departments.EMPLOYEE_SURNAME[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
							QuerySetCell(get_all_workgroup_roles,"POSITION_NAME",get_all_departments.POSITION_NAME[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
							QuerySetCell(get_all_workgroup_roles,"POSITION_CAT",get_all_departments.POSITION_CAT[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
							QuerySetCell(get_all_workgroup_roles,"TITLE",get_all_departments.TITLE[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
						}
				</cfscript>
		</cfloop>
	<cfelseif len(attributes.department_id) and len(attributes.department)>
		<cfquery name="get_upper" datasource="#dsn#">
			SELECT 
				EMPLOYEE_POSITIONS.POSITION_NAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_ID,
				SETUP_POSITION_CAT.POSITION_CAT,
				SETUP_TITLE.TITLE,
				EMPLOYEES.PHOTO,
				DEPARTMENT.DEPARTMENT_ID,
				DEPARTMENT.HIERARCHY_DEP_ID,
				DEPARTMENT.DEPARTMENT_HEAD AS ORG_NAME
			FROM  
				EMPLOYEE_POSITIONS,
				SETUP_POSITION_CAT,
				SETUP_TITLE,
				EMPLOYEES,
				DEPARTMENT
			WHERE 
				DEPARTMENT.IS_ORGANIZATION = 1 AND
				DEPARTMENT.#ilk_amir# = EMPLOYEE_POSITIONS.POSITION_CODE AND
				EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
				EMPLOYEE_POSITIONS.TITLE_ID = SETUP_TITLE.TITLE_ID AND
				EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID AND
				DEPARTMENT.DEPARTMENT_ID = #attributes.department_id#
			UNION ALL
			SELECT 
				'' AS POSITION_NAME,
				'' AS EMPLOYEE_NAME,
				'' AS EMPLOYEE_SURNAME,
				0 AS EMPLOYEE_ID,
				'' AS POSITION_CAT,
				'' AS TITLE,
				'' AS PHOTO,
				DEPARTMENT.DEPARTMENT_ID,
				DEPARTMENT.HIERARCHY_DEP_ID,
				DEPARTMENT.DEPARTMENT_HEAD AS ORG_NAME
			FROM  
				DEPARTMENT
			WHERE 
				DEPARTMENT.IS_ORGANIZATION = 1 AND
				DEPARTMENT.#ilk_amir# IS NULL AND
				DEPARTMENT.DEPARTMENT_ID = #attributes.department_id#	
		</cfquery>
		<cfquery name="get_all_departments" datasource="#dsn#">
				SELECT
					D.DEPARTMENT_ID,
					D.DEPARTMENT_HEAD,
					EP.EMPLOYEE_NAME,
					EP.EMPLOYEE_SURNAME,
					EP.POSITION_CODE,
					EP.POSITION_ID,
					EP.IS_CRITICAL,
					EP.IS_VEKALETEN,
					EP.EMPLOYEE_ID,
					EP.POSITION_NAME,
					SPC.POSITION_CAT,
					ST.TITLE,
					D.HIERARCHY_DEP_ID
				FROM
					DEPARTMENT D,
					EMPLOYEE_POSITIONS EP,
					SETUP_POSITION_CAT SPC,
					SETUP_TITLE ST
				WHERE
					D.IS_ORGANIZATION = 1 AND
					D.#ilk_amir# = EP.POSITION_CODE AND
					EP.TITLE_ID = ST.TITLE_ID AND
					EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID AND
					(D.HIERARCHY_DEP_ID LIKE '#attributes.department_id#.%' OR D.HIERARCHY_DEP_ID LIKE '%.#attributes.department_id#.%')
			UNION ALL
				SELECT
					D.DEPARTMENT_ID,
					D.DEPARTMENT_HEAD,
					'' AS EMPLOYEE_NAME,
					'' AS EMPLOYEE_SURNAME,
					0 AS POSITION_CODE,
					0 AS POSITION_ID,
					0 AS IS_CRITICAL,
					0 AS IS_VEKALETEN,
					0 AS EMPLOYEE_ID,
					'' AS POSITION_NAME,
					'' AS POSITION_CAT,
					'' AS TITLE,
					D.HIERARCHY_DEP_ID
				FROM
					DEPARTMENT D
				WHERE
					D.IS_ORGANIZATION = 1 AND
					(D.HIERARCHY_DEP_ID LIKE '#attributes.department_id#.%' OR D.HIERARCHY_DEP_ID LIKE '%.#attributes.department_id#.%') AND
					D.#ilk_amir# IS NULL
		</cfquery>	
		<cfif len(get_upper.HIERARCHY_DEP_ID)>
			<cfset my_asil_hie = get_upper.HIERARCHY_DEP_ID>
		<cfelse>
			<cfset my_asil_hie = get_upper.department_id>
		</cfif>
		<CFSET my_silinecek = len(my_asil_hie) + 2>
		<cfset my_employee_list = "">
		<cfset department_id_list = listsort(valuelist(get_all_departments.DEPARTMENT_ID),'numeric','ASC',',')>
		<cfloop list="#department_id_list#" index="mk">
				<cfscript>
					yeni_hier = get_all_departments.HIERARCHY_DEP_ID[listfindnocase(department_id_list,mk,',')];
					yeni_hier = mid(yeni_hier,my_silinecek,(len(yeni_hier)-(my_silinecek-1)));
					if(not len(yeni_hier)) yeni_hier = mk;
					if(listlen(yeni_hier,'.') eq 1) is_yatay_cizgi = is_yatay_cizgi + 1; 
					if(listlen(yeni_hier,'.') lte attributes.alt_cizim_sayisi)
					{
						my_employee_list = listappend(my_employee_list,get_all_departments.EMPLOYEE_ID[listfindnocase(department_id_list,mk,',')]);
						ROW_OF_QUERY = ROW_OF_QUERY + 1;
						QueryAddRow(get_all_workgroup_roles,1);
						QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_ID",get_all_departments.DEPARTMENT_ID[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
						QuerySetCell(get_all_workgroup_roles,"DEPARTMENT_HEAD",get_all_departments.DEPARTMENT_HEAD[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
						QuerySetCell(get_all_workgroup_roles,"POSITION_CODE",get_all_departments.position_code[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
						QuerySetCell(get_all_workgroup_roles,"POSITION_ID",get_all_departments.POSITION_ID[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
						QuerySetCell(get_all_workgroup_roles,"IS_CRITICAL",get_all_departments.IS_CRITICAL[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
						QuerySetCell(get_all_workgroup_roles,"IS_VEKALETEN",get_all_departments.IS_VEKALETEN[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
						QuerySetCell(get_all_workgroup_roles,"YENI_HIERARCHY",yeni_hier,ROW_OF_QUERY);
						QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_ID",get_all_departments.EMPLOYEE_ID[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
						QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_NAME",get_all_departments.EMPLOYEE_NAME[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
						QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_SURNAME",get_all_departments.EMPLOYEE_SURNAME[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
						QuerySetCell(get_all_workgroup_roles,"POSITION_NAME",get_all_departments.POSITION_NAME[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
						QuerySetCell(get_all_workgroup_roles,"POSITION_CAT",get_all_departments.POSITION_CAT[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
						QuerySetCell(get_all_workgroup_roles,"TITLE",get_all_departments.TITLE[listfindnocase(department_id_list,mk,',')],ROW_OF_QUERY);
					}
				</cfscript>
		</cfloop>
	</cfif>
	
	

<cfif listfindnocase(my_employee_list,'0')>
	<cfset my_employee_list = listdeleteat(my_employee_list,listfindnocase(my_employee_list,'0'))>
</cfif>

<cfif listlen(my_employee_list)>
	<cfquery name="get_resimler" datasource="#dsn#">
		SELECT PHOTO,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#listsort(my_employee_list,'numeric','ASC',',')#) ORDER BY EMPLOYEE_ID
	</cfquery>
	<cfset main_employee_list = listsort(listdeleteduplicates(valuelist(get_resimler.EMPLOYEE_ID,',')),'numeric','ASC',',')>
<cfelse>
	<cfset main_employee_list = ''>
</cfif>
	
<cfquery name="get_all_workgroup_roles2" dbtype="query">
	SELECT * FROM get_all_workgroup_roles ORDER BY YENI_HIERARCHY ASC
</cfquery>

<cfquery name="get_all_workgroup_roles_ters" dbtype="query">
	SELECT * FROM get_all_workgroup_roles2 ORDER BY YENI_HIERARCHY DESC
</cfquery>
<cfsavecontent variable="sema_icerik">
<cfoutput>
<div id="main_group" align="center" style="position:absolute;z-index:2;width:#kutu_genisligi#px;height:#kutu_yuksekligi-15#px;left:250px;top:#13+my_top_eklenti+25#px;">
	<table width="100%" cellpadding="0" cellspacing="0">
	<tr><td style="border:1px solid ##666666;">
				<table cellpadding="2" cellspacing="0" width="100%">
				<cfif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 2 and isdefined("attributes.is_resim") and len(get_upper.photo)>
						<tr><td align="center" height="#resim_yuksekligi#">
						 <img src="/documents/hr/#get_upper.photo#" height="#resim_yuksekligi#" width="#resim_genisligi#"> 
						</td></tr>
				<cfelseif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 2 and isdefined("attributes.is_resim")>
						<tr><td align="center" height="#resim_yuksekligi#">&nbsp;</td></tr>
				</cfif>
				<tr>
				<cfif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 1 and isdefined("attributes.is_resim") and len(get_upper.photo)>
						<td width="#resim_genisligi#">
						 <img src="/documents/hr/#get_upper.photo#" height="#resim_yuksekligi#" width="#resim_genisligi#">
						</td>
				<cfelseif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 1 and isdefined("attributes.is_resim")> 
						<td width="#resim_genisligi#">&nbsp;</td>
				</cfif>
					<td style="height:#kutu_yuksekligi_ilk#px;text-align:center;">
						<cfif isdefined("attributes.is_pozisyon")>#get_upper.position_name#<br/></cfif>
						<b>#get_upper.ORG_NAME#</b><br/>
						<cfif not isdefined("attributes.is_off_pozisyon")><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_upper.EMPLOYEE_ID#','medium');" class="tableyazi">#get_upper.employee_name# #get_upper.employee_surname#</a><br/></cfif>
						<cfif isdefined("attributes.is_pozisyon_tipi")>#get_upper.position_cat#<br/></cfif>
						<cfif isdefined("attributes.is_unvan")>#get_upper.title#<br/></cfif>
					</td>
				</tr>
			 </table>
		</td>
	</tr>
		<tr><td style="text-align:center;" height="<cfoutput>#cizgi_yuksekligi#</cfoutput>"><img src="/images/cizgi_dik_1pix.gif" height="<cfoutput>#cizgi_yuksekligi#</cfoutput>" width="3"></td></tr>
	</table>
</div>
</cfoutput>
<cfif is_yatay_cizgi gt 1>
	<div id="yatay_cizgi_top" style="position:absolute;z-index:5;width:2px;height:3px;left:20px;top:<cfoutput>#10+cizgi_yuksekligi+kutu_yuksekligi+my_top_eklenti#</cfoutput>px;"><img src="/images/cizgi_yan_1pix.gif" width="100%" height="3"></div>
</cfif>

<cfset last_hie = 0>
<cfoutput query="get_all_workgroup_roles2">
<cfif isnumeric(employee_id)>#draw_div(department_id,position_id,last_hie,currentrow,yeni_hierarchy,employee_id,POSITION_NAME,title,position_cat,employee_name,employee_surname,position_code,is_critical,is_vekaleten,DEPARTMENT_HEAD)#<cfset last_hie = listlen(get_all_workgroup_roles2.yeni_hierarchy,'.')></cfif></cfoutput>
<cfset top_deger = 0>
<cfloop query="get_all_workgroup_roles_ters">
	<cfif get_all_workgroup_roles_ters.currentrow eq 1>
		<cfset toplam_height = (listlen(get_all_workgroup_roles_ters.yeni_hierarchy,'.') * kutu_yuksekligi) + (listlen(get_all_workgroup_roles_ters.yeni_hierarchy,'.') * 25) + kutu_yuksekligi + 15 + my_top_eklenti + (kutu_genisligi-25)>
	</cfif>
		
	<cfset my_layer_eklenti = 0>
	<cfquery name="get_group_ozel" dbtype="query">
		SELECT * FROM get_all_workgroup_roles_ters WHERE DEPARTMENT_ID <> '#get_all_workgroup_roles_ters.DEPARTMENT_ID#' AND YENI_HIERARCHY LIKE '#get_all_workgroup_roles_ters.yeni_hierarchy#.%' ORDER BY YENI_HIERARCHY DESC
	</cfquery>
	<cfset group_hie = listlen(get_all_workgroup_roles_ters.YENI_HIERARCHY,'.')>
	<cfset ust_id = get_all_workgroup_roles_ters.DEPARTMENT_ID>
	<cfset ozel_list = 0>
	<cfset my_wrk_id = ''>
	<cfset my_first_wrk_id = ''>
	<cfloop query="get_group_ozel">
		<cfif get_group_ozel.currentrow eq get_group_ozel.recordcount>
			<cfset my_first_wrk_id = '#get_group_ozel.DEPARTMENT_ID#'>
		</cfif>
		<cfif (listlen(get_group_ozel.YENI_HIERARCHY,'.') - group_hie) eq 1>
			<cfif ozel_list eq 0>
				<div id="yatay_cizgi_<cfoutput>#ust_id#</cfoutput>" style="position:absolute;z-index:2;width:1;height:3px;left:20px;top:<cfoutput>#cizgi_yuksekligi+my_top_eklenti#</cfoutput>px;"><img src="/images/cizgi_yan_1pix.gif" width="100%" height="3"></div>
				<cfset my_wrk_id = '#get_group_ozel.DEPARTMENT_ID#'>
			</cfif>
			<cfset ozel_list = ozel_list + 1>
		</cfif>
	</cfloop>
		<cfif ozel_list>
			<script type="text/javascript">
				my_yeni_sayi = <cfoutput>#ozel_list#</cfoutput>;
				my_j_layer_eklenti = <cfoutput>#my_layer_eklenti#</cfoutput>;
				my_top_eklenti = <cfoutput>#my_top_eklenti#</cfoutput>;
				my_sag_son = <cfoutput>parseInt(cizim_#my_wrk_id#.style.left) + #kutu_genisligi#</cfoutput>;
				my_top = <cfoutput>parseInt(cizim_#my_wrk_id#.style.top) - <cfoutput>#kutu_genisligi - 25#</cfoutput></cfoutput>;
				my_left_bas = my_sag_son - ((my_yeni_sayi * <cfoutput>#kutu_genisligi#</cfoutput>) + ((my_yeni_sayi-1)*25));
				my_second_left = parseInt(cizim_<cfoutput>#my_first_wrk_id#</cfoutput>.style.left);
				
				if(my_yeni_sayi==1)
					my_orta = my_left_bas;
				else
					my_orta = ((my_sag_son + my_left_bas) / 2)-(<cfoutput>#kutu_genisligi/2#</cfoutput>);
					
				document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left = my_orta + 'px';
				
				document.getElementById('yatay_cizgi_<cfoutput>#ust_id#</cfoutput>').style.left = my_second_left+(<cfoutput>#kutu_genisligi/2#</cfoutput>) + 'px';
				if(my_yeni_sayi>1)
					document.getElementById('yatay_cizgi_<cfoutput>#ust_id#</cfoutput>').style.width = my_sag_son - my_second_left - <cfoutput>#kutu_genisligi#</cfoutput> + 'px';
				  document.getElementById('yatay_cizgi_<cfoutput>#ust_id#</cfoutput>').style.top = parseInt(cizim_<cfoutput>#my_first_wrk_id#</cfoutput>.style.top) + 'px';
			</script>
		</cfif>
		<cfif (top_deger eq 0) and (group_hie eq my_default_hie)>
			<cfset top_deger = 1>
			<script type="text/javascript">
				my_top_cizgi_son = parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left) + 'px';
			</script>
		</cfif>
		<cfif get_all_workgroup_roles_ters.currentrow eq 1>
			<cfset son_hie = listfirst(get_all_workgroup_roles_ters.yeni_hierarchy,'.')>
			<cfquery name="get_group_ilk" dbtype="query">
				SELECT * FROM get_all_workgroup_roles_ters WHERE YENI_HIERARCHY = '#son_hie#'
			</cfquery>
			<cfset my_son_ust_grup_id = get_group_ilk.DEPARTMENT_ID>
		</cfif>
		<cfif get_all_workgroup_roles_ters.currentrow eq get_all_workgroup_roles_ters.recordcount>
			<script type="text/javascript">
				<cfif is_yatay_cizgi gt 1>yatay_cizgi_top.style.left = <cfoutput>parseInt(cizim_#ust_id#.style.left) + (#kutu_genisligi/2#)</cfoutput> + 'px';</cfif>
				<cfif is_yatay_cizgi eq 1>
					document.getElementById('main_group').style.left = parseInt(cizim_<cfoutput>#get_all_workgroup_roles2.department_id[1]#</cfoutput>.style.left) + 'px';
				<cfelse>
					document.getElementById('main_group').style.left = ((<cfoutput>#my_son_left#</cfoutput> - parseInt(cizim_<cfoutput>#ust_id#</cfoutput>.style.left)) / 2) + parseInt(cizim_<cfoutput>#ust_id#</cfoutput>.style.left) - (<cfoutput>#kutu_genisligi/2#</cfoutput>)  + 'px';
				</cfif>
				<cfif is_yatay_cizgi gt 1>
					document.getElementById('yatay_cizgi_top').style.width = (parseInt(cizim_<cfoutput>#my_son_ust_grup_id#</cfoutput>.style.left) + (<cfoutput>#kutu_genisligi/2#</cfoutput>)) - (parseInt(yatay_cizgi_top.style.left)) + 'px';
				</cfif>
			</script>
		</cfif>
</cfloop>
</cfsavecontent>
<table cellspacing="0" cellpadding="0" width="100%" border="0" align="center">
<tr class="color-border">
<td>
		<table cellspacing="1" cellpadding="2" width="100%" border="0">
			<tr class="color-row">
				<td>
					<table>
						<cfform action="#request.self#?fuseaction=hr.emptypopup_sve_hierrchy_drwing">
						<tr>
							<td class="formbold"><cf_get_lang dictionary_id ='56726.Şema Kaydet'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td><cf_get_lang dictionary_id ='56727.Şema Adı'>*</td>
							<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='56728.Çizim Adı Girmelisiniz'></cfsavecontent>
							<td><cfinput type="text" value="" name="draw_name" required="yes" message="#alert#"></td>
							<td><input type="text" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput> <cf_get_lang dictionary_id ='56729.Tarihli Organizayon Şeması'>" style="width:250px;" name="draw_detail" id="draw_detail" maxlength="500"></td>
							<td>
							<textarea name="draw_icerik" id="draw_icerik" style="width:1px;height:1px; display:none;"><cfoutput>#ToBase64(sema_icerik)#</cfoutput></textarea>
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
<cfoutput>#sema_icerik#</cfoutput>
