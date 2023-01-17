<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_xml_page_edit fuseact="ehesap.popup_view_price_compass">
	<cfscript>
		function saDk(veri) // Bu fonksiyon saat olarak gelen değeri, Saat:Dakika formatına çevirir.
		{
			saat = ListGetAt(veri, 1, ".");
			dakika = "00";
			if (ListLen(veri, ".") eq 2)
				dakika = Int(ListGetAt(veri, 2, ".") * 60 / 100);
			return saat & ":" & dakika;
		}
		
		include "../hr/ehesap/query/get_code_cat.cfm";
	</cfscript>
	<cfquery name="get_ssk_offices" datasource="#dsn#">
		SELECT
			B.BRANCH_ID,
			B.BRANCH_NAME,	
			B.BRANCH_FULLNAME,	
			B.SSK_OFFICE,
			B.COMPANY_ID,
			B.SSK_NO,
			B.BRANCH_TAX_NO,
			O.NICK_NAME,
			B.BRANCH_TAX_OFFICE
		FROM
			BRANCH B
			INNER JOIN OUR_COMPANY O ON B.COMPANY_ID = O.COMP_ID
		WHERE
			B.SSK_NO IS NOT NULL AND
			B.BRANCH_STATUS = 1 AND
			B.SSK_OFFICE IS NOT NULL AND
			B.SSK_BRANCH IS NOT NULL AND
			B.SSK_NO <> '' AND
			B.SSK_OFFICE <> '' AND
			B.SSK_BRANCH <> ''
			<cfif not session.ep.ehesap>
			AND B.BRANCH_ID IN (
	                            SELECT
	                                BRANCH_ID
	                            FROM
	                                EMPLOYEE_POSITION_BRANCHES
	                            WHERE
	                                EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
	                            )
			</cfif>
		ORDER BY
			O.NICK_NAME,
			O.COMP_ID,
			B.BRANCH_NAME,
			B.SSK_OFFICE
	</cfquery>
	<cfquery name="get_units" datasource="#DSN#">
		SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT WHERE IS_ACTIVE = 1 ORDER BY UNIT_NAME
	</cfquery>
	<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
        SELECT
        	EXPENSE_CODE,
            EXPENSE
        FROM
        	EXPENSE_CENTER
        WHERE
        	EXPENSE_ACTIVE = 1 
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            	AND (EXPENSE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR EXPENSE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
            </cfif>
            <cfif isDefined("attributes.code") and len(attributes.code)>
            	AND EXPENSE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.code#%">
            </cfif>
            <cfif isdefined("attributes.is_store_module") and len(attributes.is_store_module)>
            	AND EXPENSE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,'-')#">
            </cfif>
        ORDER BY
        	EXPENSE_CODE
    </cfquery>
    <cfif isdefined("attributes.sal_mon")>
		<cfset list_status = 1>
		<cfif attributes.sal_year eq attributes.sal_year_end>
			<cfif attributes.sal_mon gt attributes.sal_mon_end>
				<cfset list_status = 0>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır'>");
				</script>
			</cfif>
		<cfelseif attributes.sal_year gt attributes.sal_year_end>
			<cfset list_status = 0>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır'>");
			</script>
		</cfif>
	</cfif>
	
	<cfif isdefined("list_status") and list_status eq 1>
		<cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id)>
			<script type="text/javascript">
				get_department_list();
			</script>
		</cfif>
		
		<cfquery name="GET_PUANTAJ" datasource="#dsn#">
			SELECT
				EP.*
			FROM
				EMPLOYEES_PUANTAJ EP
				INNER JOIN BRANCH B ON EP.SSK_BRANCH_ID = B.BRANCH_ID
			WHERE
				<cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id)>
					B.BRANCH_ID IN (#attributes.branch_id#) AND
				</cfif>
				(
					(EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					OR
					(
						EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						(
							EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
							(EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						(
							EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
							(EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND 
						EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
						EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
					)
				)
		</cfquery>
		
		<cfif not get_puantaj.recordcount>
			<cfset kayit_yok = 1>
		<cfelse>
			<cfset attributes.puantaj_id_list = listdeleteduplicates(valuelist(get_puantaj.puantaj_id))>
		</cfif>
		
		<cfif not isdefined("kayit_yok")>
	    	<cfset puantaj_type_ = -1>
			<cfinclude template="../hr/ehesap/query/get_puantaj_rows.cfm">
			<cfif not get_puantaj_rows.recordcount>
				<cfset kayit_yok = 1>
			</cfif>
		</cfif>
		
		<cfinclude template="../hr/query/get_emp_codes.cfm">
		
		<cfquery name="get_ogis" datasource="#dsn#"><!--- özel gider indirimi sube ile baglanabilirdi ama gerek yok x yilin y ayinda bir kisi icin bir satir olabilir --->
			SELECT
				SUM(OGIR.DAMGA_VERGISI) AS OGI_DAMGA_TOPLAM,
				SUM(OGIR.ODENECEK_TUTAR) AS OGI_ODENECEK_TOPLAM
			FROM
				EMPLOYEES_OZEL_GIDER_IND_ROWS AS OGIR
				INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = OGIR.EMPLOYEE_ID
				INNER JOIN EMPLOYEES_OZEL_GIDER_IND AS OGI ON OGIR.OZEL_GIDER_IND_ID = OGI.OZEL_GIDER_IND_ID
				INNER JOIN BRANCH B ON OGI.SSK_NO = B.SSK_NO AND OGI.SSK_OFFICE = B.SSK_OFFICE
			WHERE
				<cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id)>
				B.BRANCH_ID IN (#attributes.branch_id#) AND
				</cfif>
				(
					(OGI.PERIOD_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND OGI.PERIOD_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					OR
					(
						OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						OGI.PERIOD_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						(
							OGI.PERIOD_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
							(OGI.PERIOD_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						OGI.PERIOD_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						(
							OGI.PERIOD_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
							(OGI.PERIOD_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
						OGI.PERIOD_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						OGI.PERIOD_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
					)
				)
			<cfif fusebox.dynamic_hierarchy>
				<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
					<cfif database_type is "MSSQL">
						AND ('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
					<cfelseif database_type is "DB2">
						AND ('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
					</cfif>
				</cfloop>
			<cfelse>
				<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
					<cfif database_type is "MSSQL">
						AND ('.' + EMPLOYEES.HIERARCHY + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
					<cfelseif database_type is "DB2">
						AND ('.' || EMPLOYEES.HIERARCHY || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
					</cfif>
				</cfloop>
			</cfif>
		</cfquery>
		
		<cfquery name="get_kumulatif_gelir_vergisi" datasource="#dsn#">
			SELECT 
				SUM(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI) AS TOPLAM
			FROM
				EMPLOYEES
				INNER JOIN EMPLOYEES_PUANTAJ_ROWS ON EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
				INNER JOIN EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
				INNER JOIN BRANCH B ON EMPLOYEES_PUANTAJ.SSK_OFFICE = B.SSK_OFFICE AND EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = B.SSK_NO
			WHERE
				<cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id)>
				B.BRANCH_ID IN (#attributes.branch_id#) AND
				</cfif>
				(
					(EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					OR
					(
						EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						(
							EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
							OR
							(EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						(
							EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
							OR
							(EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
						EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
					)
				)
			<cfif fusebox.dynamic_hierarchy>
				<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
					<cfif database_type is "MSSQL">
						AND ('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
					<cfelseif database_type is "DB2">
						AND ('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
					</cfif>
				</cfloop>
			<cfelse>
				<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
					<cfif database_type is "MSSQL">
						AND ('.' + EMPLOYEES.HIERARCHY + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
					<cfelseif database_type is "DB2">
						AND ('.' || EMPLOYEES.HIERARCHY || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
					</cfif>
				</cfloop>
			</cfif>
		</cfquery>
		
		<cfif not isdefined("kayit_yok") and get_puantaj_rows.recordcount>
			<cfquery name="get_odeneks" datasource="#dsn#">
				SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID IN (#valuelist(get_puantaj_rows.employee_puantaj_id)#) AND EXT_TYPE = 0 ORDER BY COMMENT_PAY
			</cfquery>
			
			<cfquery name="get_kesintis" datasource="#dsn#">
				SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID IN (#valuelist(get_puantaj_rows.employee_puantaj_id)#) AND EXT_TYPE = 1 ORDER BY COMMENT_PAY
			</cfquery>
			
			<cfquery name="get_vergi_istisnas" datasource="#dsn#">
				SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID IN (#valuelist(get_puantaj_rows.employee_puantaj_id)#) AND EXT_TYPE = 2 ORDER BY COMMENT_PAY
			</cfquery>
			
			<cfset query_name = "get_puantaj_rows">
			<cfset icmal_type = "genel">
			<cfset kisi_say = get_puantaj_rows.recordcount>
			
			<cfquery name="get_personel_male_aylik" dbtype="query">
				SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SEX = 1 AND SALARY_TYPE = 2
			</cfquery>
			
			<cfquery name="get_personel_female_aylik" dbtype="query">
				SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SEX = 0 AND SALARY_TYPE = 2
			</cfquery>
		
			<cfquery name="get_personel_male_yovmiyeli" dbtype="query">
				SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SEX = 1 AND SALARY_TYPE = 1
			</cfquery>
		
			<cfquery name="get_personel_female_yovmiyeli" dbtype="query">
				SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SEX = 0 AND SALARY_TYPE = 1
			</cfquery>
		
			<cfquery name="get_personel_male_saat" dbtype="query">
				SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SEX = 1 AND SALARY_TYPE = 0
			</cfquery>
		
			<cfquery name="get_personel_female_saat" dbtype="query">
				SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SEX = 0 AND SALARY_TYPE = 0
			</cfquery>
		
			<cfquery name="get_personel_cirak" dbtype="query">
				SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SSK_STATUTE IN (3,4,11)
			</cfquery>
		
			<cfquery name="get_personel_hastalik" dbtype="query">
				SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SSK_STATUTE = 17
			</cfquery>
			
			<cfquery name="get_personel_sigorta" dbtype="query">
				SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SSK_STATUTE = 1
			</cfquery>
		
			<cfquery name="get_personel_emekli" dbtype="query">
				SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SSK_STATUTE = 2
			</cfquery>
		
			<cfquery name="get_personel_memur" dbtype="query">
				SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SSK_STATUTE IN (70,50)
			</cfquery>
		
			<cfquery name="get_personel_izin_ucret" dbtype="query">
				SELECT
					SUM((TOTAL_SALARY/TOTAL_DAYS)*IZIN_PAID_COUNT) AS IZIN_PAID_COUNT
				FROM
					get_puantaj_rows
			</cfquery>
			
			<cfquery name="get_ssk_gun" dbtype="query">
				SELECT SUM(TOTAL_DAYS) AS TOTAL_SSK_DAY FROM get_puantaj_rows WHERE SSK_STATUTE IN (1,6,5)
			</cfquery>
		</cfif>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		function get_department_list()
		{
			<cfif isdefined("attributes.department") and listlen(attributes.department)>
				dept_list = '<cfoutput>#attributes.department#</cfoutput>';
			<cfelse>
				dept_list = '';
			</cfif>
			document.getElementById('department').options.length = 0;
			var document_id = document.getElementById('branch_id').options.length;	
			var document_name = '';
			for(i=0;i<document_id;i++)
			{
				if(document.employee.branch_id.options[i].selected && document_name.length==0)
					document_name = document_name + document.employee.branch_id.options[i].value;
				else if(document.employee.branch_id.options[i].selected)
					document_name = document_name + ',' + document.employee.branch_id.options[i].value;
			}
			var get_department_name = wrk_safe_query('hr_get_department_name','dsn',0,document_name);
			document.employee.department.options[0]=new Option("<cf_get_lang_main no='1424.Lutfen Departman Seciniz'>",'0')
			if(get_department_name.recordcount != 0)
			{
				for(var xx=0;xx<get_department_name.recordcount;xx++)
				{
					document.employee.department.options[xx+1]=new Option(get_department_name.DEPARTMENT_HEAD[xx],get_department_name.DEPARTMENT_ID[xx]);
					document.employee.department.options[xx+1].title = get_department_name.DEPARTMENT_HEAD[xx];
					if(dept_list != '' && list_find(dept_list,get_department_name.DEPARTMENT_ID[xx]))
						document.employee.department.options[xx+1].selected = true;	
				}
			}
		}
		function change_mon(i)
		{
			$('#sal_mon_end').val(i);
		}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_icmal';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_icmal.cfm';
</cfscript>
