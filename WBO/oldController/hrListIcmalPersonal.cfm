<cf_get_lang_set module_name="ehesap">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_xml_page_edit fuseact="ehesap.popup_view_price_compass">
	<cfsetting showdebugoutput="no">
	<cfparam name="attributes.puantaj_type" default="-1">
	<cfparam name="attributes.sal_year" default="#year(now())#">
	<cfparam name="attributes.sal_mon" default="<cfif month(now()) gt 1>#month(now()) - 1#><cfelse>#month(now())#</cfif>">
	<cfparam name="attributes.sal_mon_end" default="#attributes.sal_mon#">
	<cfparam name="attributes.sal_year_end" default="#attributes.sal_year#">
	
	<cfscript>
		main_puantaj_table = "EMPLOYEES_PUANTAJ";
		row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS";
		ext_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_EXT";
		add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD";
		maas_puantaj_table = "EMPLOYEES_SALARY";
		
		function saDk(veri) // Bu fonksiyon saat olarak gelen değeri, Saat:Dakika formatına çevirir.
		{
			saat = ListGetAt(veri, 1, ".");
			dakika = "00";
			if (ListLen(veri, ".") eq 2)
				dakika = Int(ListGetAt(veri, 2, ".") * 60 / 100);
			return saat & ":" & dakika;
		}
		
		if (not ((attributes.fuseaction contains "popup_view_price_compass") or (attributes.fuseaction contains "popupflush_view_puantaj_print")))
		{
			form_submit_action = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_icmal_personal";
			isciye = 0;
		}
		else
		{
			form_submit_action = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_view_price_compass";
			isciye = 1;
		}
		
		if (isdefined("attributes.style") and ((attributes.style is "all") or (attributes.style is "list")))
			toplu = 1;
		else
			toplu = 0;
		
		if (isdefined("attributes.employee_id") and len(attributes.employee_id))
		{
			function QueryRow(Query,Row) 
			{
				var tmp = QueryNew(Query.ColumnList);
				QueryAddRow(tmp,1);
				for(x=1;x lte ListLen(tmp.ColumnList);x=x+1) QuerySetCell(tmp, ListGetAt(tmp.ColumnList,x), query[ListGetAt(tmp.ColumnList,x)][row]);
				return tmp;
			}
		}
	</cfscript>
	<cfif toplu eq 0>
		<cfif (not isdefined("attributes.employee_id")) or (isdefined("attributes.employee_id") and (not len(attributes.employee_id)))>
			<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
		<cfelse>
			<cfif not (isdefined("attributes.employee_id") and len(attributes.employee_id))>
				<script type="text/javascript">
					alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='164.Çalışan'>");
					history.back();
				</script>
				<cfabort>
			</cfif>
			<cfinclude template="../hr/ehesap/query/get_employee_name.cfm">
		</cfif>
	</cfif>
	<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
		<cfif (not isdefined("attributes.style")) or (attributes.style is "one")>
			<cfinclude template="../hr/ehesap/query/get_puantaj_personal.cfm">
			<cfif not get_puantaj_personal.recordcount>
				<script type="text/javascript">
					alert("1- <cf_get_lang no ='829.Bu çalışan için puantaj kaydı'> <cfif not session.ep.ehesap><cf_get_lang no ='82.veya Yetkiniz'></cfif><cf_get_lang_main no='1134.Yok'>!");
					history.back();
				</script>
				<cfabort>
			</cfif>
			
			<cfquery name="get_ogis" datasource="#dsn#"><!--- özel gider indirimi sube ile baglanabilirdi ama gerek yok x yilin y ayinda bir kisi icin bir satir olabilir --->
				SELECT
					OGIR.DAMGA_VERGISI AS OGI_DAMGA_TOPLAM,
					OGIR.ODENECEK_TUTAR AS OGI_ODENECEK_TOPLAM
				FROM
					EMPLOYEES_OZEL_GIDER_IND_ROWS AS OGIR
					INNER JOIN EMPLOYEES_OZEL_GIDER_IND AS OGI ON OGIR.OZEL_GIDER_IND_ID = OGI.OZEL_GIDER_IND_ID
				WHERE
					OGIR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
					<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_mon_end)>
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
								OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
								OGI.PERIOD_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
								OGI.PERIOD_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
							)
						)
					<cfelse>
						OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
						OGI.PERIOD_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
					</cfif>
			</cfquery>
			<cfscript>
				if (not get_ogis.recordcount)
				{
					//20050215 ocak ayinda bu tutarlar puantajdan gelen kisiye bagli olmadigi icin 0 set ediliyor
					get_ogis.ogi_damga_toplam = 0;
					get_ogis.ogi_odenecek_toplam = 0;
				}
				include "../hr/ehesap/query/get_hours.cfm";
				icmal_type = "personal";
				if (attributes.sal_year eq attributes.sal_year_end and attributes.sal_mon eq attributes.sal_mon_end)
					same_mon = 1;
				else
					same_mon = 0;
				if (same_mon neq 1)
					mxrw = 1;
				else
				{
					puantaj_ids = valuelist(get_puantaj_personal.employee_puantaj_id,',');
					mxrw = get_puantaj_personal.recordcount;
				}
			</cfscript>
		<cfelse>
			<cfif attributes.style is 'all'>
				<cfif not len(attributes.ssk_office) and not len(attributes.hierarchy)>
					<script type="text/javascript">
						alert("<cf_get_lang no ='1194.SSK Ofis Bilgileri veya Hierarşi Kodu Eksik'>!");
						window.close();
					</script>
				<cfelse>
					<cfinclude template="../hr/ehesap/query/get_icmal_puantaj_rows.cfm">
					<cfset sayi = 0>
					<cfset puantaj_list = "">
					<cfset employee_list = "">
					<cfoutput query="get_puantaj_rows">
						<cfset puantaj_list = listappend(puantaj_list,get_puantaj_rows.employee_puantaj_id,',')>
						<cfset employee_list = listappend(employee_list,get_puantaj_rows.employee_id,',')>
					</cfoutput>
					<cfset puantaj_list=listsort(puantaj_list,"numeric","ASC",",")>
					<cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
					<cfif listlen(puantaj_list)>
						<cfquery name="get_odeneks_all" datasource="#dsn#">
							SELECT * FROM #ext_puantaj_table# WHERE EMPLOYEE_PUANTAJ_ID IN (#puantaj_list#) ORDER BY COMMENT_PAY
						</cfquery>
					</cfif>
					<cfif listlen(employee_list)>
						<cfquery name="get_ogis_all" datasource="#dsn#"><!--- özel gider indirimi sube ile baglanabilirdi ama gerek yok x yilin y ayinda bir kisi icin bir satir olabilir --->
							SELECT
								OGIR.DAMGA_VERGISI AS OGI_DAMGA_TOPLAM,
								OGIR.ODENECEK_TUTAR AS OGI_ODENECEK_TOPLAM,
								OGIR.EMPLOYEE_ID
							FROM
								EMPLOYEES_OZEL_GIDER_IND_ROWS AS OGIR
								INNER JOIN EMPLOYEES_OZEL_GIDER_IND AS OGI ON OGIR.OZEL_GIDER_IND_ID = OGI.OZEL_GIDER_IND_ID
							WHERE
								OGIR.EMPLOYEE_ID IN (#employee_list#) AND
								<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_mon_end)>
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
											OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
											OGI.PERIOD_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
											OGI.PERIOD_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
										)
									)
								<cfelse>
									OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
									OGI.PERIOD_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
								</cfif>
						</cfquery>
						
						<cfquery name="get_kumulatif_gelir_vergisi_all" datasource="#dsn#">
							SELECT 
								EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI,
								EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID,
								B.BRANCH_ID,
								B.COMPANY_ID
							FROM
								EMPLOYEES_PUANTAJ_ROWS
								INNER JOIN EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
								INNER JOIN BRANCH B ON EMPLOYEES_PUANTAJ.SSK_BRANCH_ID = B.BRANCH_ID
							 WHERE 
								 EMPLOYEES_PUANTAJ.PUANTAJ_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.PUANTAJ_TYPE#"> AND
								 <cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_mon_end)>
								 	(
										(EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
										OR
										(
											EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
											EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
											(
												EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
												(EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
											)
										)
										OR
										(
											EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
											(
												EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
												(EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
											)
										)
										OR
										(
											EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND 
											EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
											EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
											EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
										)
									) AND
								 <cfelse>
								 	EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
								 	EMPLOYEES_PUANTAJ.SAL_MON < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND 
								 </cfif>
								 EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID IN (#employee_list#)
						</cfquery>
					</cfif>
				</cfif>
			<cfelseif attributes.style is 'list' and isdefined("attributes.list_employee_id")>
				<cfinclude template="../hr/ehesap/query/get_icmal_puantaj_rows.cfm">
				<cfset sayi = 0>
				<cfset puantaj_list = "">
				<cfset employee_list = "">
				<cfoutput query="get_puantaj_rows">
					<cfset puantaj_list = listappend(puantaj_list,get_puantaj_rows.EMPLOYEE_PUANTAJ_ID,',')>
					<cfset employee_list = listappend(employee_list,get_puantaj_rows.EMPLOYEE_ID,',')>
				</cfoutput>
				<cfset puantaj_list=listsort(puantaj_list,"numeric","ASC",",")>
				<cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
				<cfif listlen(puantaj_list)>
					<cfquery name="get_odeneks_all" datasource="#dsn#">
						SELECT * FROM #ext_puantaj_table# WHERE EMPLOYEE_PUANTAJ_ID IN (#puantaj_list#) ORDER BY COMMENT_PAY
					</cfquery>
				</cfif>
				<cfif listlen(employee_list)>
					<cfquery name="get_ogis_all" datasource="#dsn#"><!--- özel gider indirimi sube ile baglanabilirdi ama gerek yok x yilin y ayinda bir kisi icin bir satir olabilir --->
						SELECT
							OGIR.DAMGA_VERGISI AS OGI_DAMGA_TOPLAM,
							OGIR.ODENECEK_TUTAR AS OGI_ODENECEK_TOPLAM,
							OGIR.EMPLOYEE_ID
						FROM
							EMPLOYEES_OZEL_GIDER_IND_ROWS AS OGIR
							INNER JOIN EMPLOYEES_OZEL_GIDER_IND AS OGI ON OGIR.OZEL_GIDER_IND_ID = OGI.OZEL_GIDER_IND_ID
						WHERE
							OGIR.EMPLOYEE_ID IN (#employee_list#) AND
							<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_year_end)>
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
										OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
										OGI.PERIOD_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
										OGI.PERIOD_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
									)
								)
							<cfelse>
								OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
								OGI.PERIOD_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
							</cfif>
					</cfquery>
				
					<cfquery name="get_kumulatif_gelir_vergisi_all" datasource="#dsn#">
						SELECT EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI,EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID FROM 
						<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>
							EMPLOYEES_PUANTAJ_VIRTUAL AS EMPLOYEES_PUANTAJ,
							EMPLOYEES_PUANTAJ_ROWS_VIRTUAL AS EMPLOYEES_PUANTAJ_ROWS
						<cfelse>
							EMPLOYEES_PUANTAJ,
							EMPLOYEES_PUANTAJ_ROWS
						</cfif>
						 WHERE 
						 EMPLOYEES_PUANTAJ.PUANTAJ_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_type#"> AND
						 EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND 
						 EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						 EMPLOYEES_PUANTAJ.SAL_MON < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND 
						 EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID IN (#employee_list#)
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
	<cfelseif isdefined("attributes.employee_id")>
		<cfset attributes.action_type = "pusula_görüntüleme">
		<cfquery name="get_relatives" datasource="#dsn#">
			SELECT * FROM EMPLOYEES_RELATIVES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND (RELATIVE_LEVEL = '3' OR RELATIVE_LEVEL = '4' OR RELATIVE_LEVEL = '5')
		</cfquery>
		<cfquery name="get_hr_ssk" datasource="#dsn#">
			SELECT
				E.EMPLOYEE_ID,
				EI.BIRTH_DATE,
				EIO.IN_OUT_ID,
				E.EMPLOYEE_NO,
				E.TASK,
				ED.SEX,
				EIO.GROSS_NET,
				EIO.START_DATE,
				EIO.FINISH_DATE,
				EIO.USE_SSK,
				EIO.USE_TAX,
				EIO.IS_TAX_FREE,
				EIO.IS_DAMGA_FREE,
				EIO.IS_SAKAT_KONTROL,
				EIO.SSK_STATUTE,
				EIO.IS_DISCOUNT_OFF,
				EIO.IS_USE_506,
				EIO.DAYS_506,
				EIO.DEFECTION_LEVEL,
				EIO.SOCIALSECURITY_NO,
				EIO.TRADE_UNION_DEDUCTION,
				EIO.FAZLA_MESAI_SAAT,
				EIO.LAW_NUMBERS,
				EIO.KIDEM_AMOUNT, 
				EIO.IHBAR_AMOUNT, 
				EIO.KULLANILMAYAN_IZIN_AMOUNT,
				EIO.GROSS_COUNT_TYPE,
				EIO.FINISH_DATE,
				EIO.VALID,
				BRANCH.BRANCH_ID,
				BRANCH.DANGER_DEGREE,
				BRANCH.DANGER_DEGREE_NO,
				BRANCH.KANUN_5084_ORAN,
				BRANCH.IS_5615,
				BRANCH.IS_5615_TAX_OFF,
				BRANCH.IS_5510 AS SUBE_IS_5510,
				EIO.IS_5084,
				EIO.IS_5510,
				(SELECT EIOP.EXPENSE_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,BRANCH B2 WHERE B2.BRANCH_ID = EIO.BRANCH_ID AND B2.COMPANY_ID = EIOP.PERIOD_COMPANY_ID AND EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">) AS EXPENSE_CODE,
				(SELECT EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,BRANCH B2 WHERE B2.BRANCH_ID = EIO.BRANCH_ID AND B2.COMPANY_ID = EIOP.PERIOD_COMPANY_ID AND EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">) AS ACCOUNT_CODE,
				(SELECT EIOP.ACCOUNT_BILL_TYPE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,BRANCH B2 WHERE B2.BRANCH_ID = EIO.BRANCH_ID AND B2.COMPANY_ID = EIOP.PERIOD_COMPANY_ID AND EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_year#">) AS ACCOUNT_BILL_TYPE,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				BRANCH.COMPANY_ID,
				DEPARTMENT.DEPARTMENT_HEAD,
				OUR_COMPANY.NICK_NAME COMP_NICK_NAME,
				OUR_COMPANY.COMPANY_NAME COMP_FULL_NAME,
				BRANCH.BRANCH_FULLNAME,
				BRANCH.BRANCH_NAME,
				BRANCH.SSK_OFFICE,
				BRANCH.SSK_NO,
				EIO.BRANCH_ID,
				EIO.PUANTAJ_GROUP_IDS,
				EIO.IS_6486,
				BRANCH.KANUN_6486
			FROM
				EMPLOYEES_IN_OUT EIO
				INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
				INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
				INNER JOIN EMPLOYEES_DETAIL ED ON E.EMPLOYEE_ID = ED.EMPLOYEE_ID
				INNER JOIN DEPARTMENT ON EIO.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
				INNER JOIN BRANCH ON BRANCH.BRANCH_ID = EIO.BRANCH_ID
				INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
			WHERE
				(EIO.IS_PUANTAJ_OFF = 0 OR EIO.IS_PUANTAJ_OFF IS NULL) AND
				EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
				<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_mon_end)>
					AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(attributes.sal_year_end,attributes.sal_mon_end,daysinmonth(CreateDate(sal_year_end,attributes.sal_mon_end,1)))#">
				<cfelse>
					AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(attributes.sal_year,attributes.sal_mon,daysinmonth(CreateDate(sal_year,attributes.sal_mon,1)))#">
				</cfif>
				AND
				(
					(EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(sal_year,attributes.sal_mon,1)#">)
					OR EIO.FINISH_DATE IS NULL
				)
			<cfif not session.ep.ehesap>
				AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
			ORDER BY
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				EIO.START_DATE
		</cfquery>
		<cfif not get_hr_ssk.recordcount>
			<script type="text/javascript">
				alert('Kişi İçin Uygun Giriş - Çıkış Kaydı Bulunamadı!');
				window.close();
			</script>
			<cfabort>
		</cfif>
		<cfinclude template="../hr/ehesap/query/get_hr_compass_loop.cfm">
	</cfif>
	<cfif fusebox.fuseaction is 'popupflush_view_puantaj_print' and not style is 'one'>
		<script type="text/javascript">
			window.print();
		</script>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		function control_date()
		{
			if (parseInt($('#sal_year').val()) == parseInt($('#sal_year_end').val()))
			{
				if (parseInt($('#sal_mon').val()) > parseInt($('#sal_mon_end').val()))
				{
					
					alert('Başlangıç tarihi bitiş tarihinden büyük olmamalıdır.');
					return false;
				}
			}
			else if (parseInt($('#sal_year').val()) > parseInt($('#sal_year_end').val()))
			{
				{
					alert('Başlangıç tarihi bitiş tarihinden büyük olmamalıdır.');
					return false;
				}
			}
			return true;
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_icmal_personal';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_icmal_personal.cfm';
</cfscript>
