<cf_get_lang_set module_name="myhome">
<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#"> 
<cfparam name="attributes.sal_year" default="#year(now())#">
<cfparam name="attributes.employee_id" default="#session.ep.userid#">

<cfif isdefined("attributes.is_submit")>
	<cfset is_bireysel_bordro = 1>
	<cfset attributes.employee_id = session.ep.userid>
	<cfinclude template="../hr/ehesap/query/get_puantaj_personal.cfm">
	<cfif GET_PUANTAJ_PERSONAL.recordcount>
		<cfquery name="get_old_mail_emp" datasource="#dsn#">
			SELECT 
				* 
			FROM 
				EMPLOYEES_PUANTAJ_MAILS 
			WHERE 
				EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.employee_id#"> AND
				BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.branch_id#"> AND 
				SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.sal_mon#"> AND 
				SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.sal_year#">
		</cfquery>
	</cfif>
	<cfif not GET_PUANTAJ_PERSONAL.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no='953.Bu çalışan için puantaj kaydı'> <cfif not session.ep.ehesap><cf_get_lang no='954.veya Yetkiniz'></cfif><cf_get_lang_main no='1134.Yok'>!");
			window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_my_bordro';
		</script>
		<cfabort>
	<cfelseif (not get_old_mail_emp.recordcount or (get_old_mail_emp.recordcount and not len(get_old_mail_emp.first_mail_date) and not len(get_old_mail_emp.last_mail_date) and not len(get_old_mail_emp.cau_mail_date))) and GET_PUANTAJ_PERSONAL.is_locked neq 1>
		<script type="text/javascript">
			alert("<cf_get_lang no='952.Puantaj Tamamlandığına Dair Uyarı Gelmeden veya Puantaj Kilitlenmeden Bordronuzu Kontrol Edemezsiniz'>!");
			window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_my_bordro';
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfquery name="GET_PROTESTS" datasource="#DSN#" maxrows="1">
	SELECT * FROM EMPLOYEES_PUANTAJ_PROTESTS WHERE SAL_MON=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND SAL_YEAR=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> ORDER BY PROTEST_ID DESC
</cfquery>		
<cfif isdefined("attributes.is_submit")>
	<cfquery name="GET_DET_FORM" datasource="#dsn3#">
		SELECT 
			SPF.IS_XML,
			SPF.TEMPLATE_FILE,
			SPF.FORM_ID,
			SPF.IS_DEFAULT,
			SPF.NAME,
			SPF.PROCESS_TYPE,
			SPF.MODULE_ID,
			SPFC.PRINT_NAME
		FROM 
			SETUP_PRINT_FILES SPF,
			#dsn_alias#.SETUP_PRINT_FILES_CATS SPFC,
			#dsn_alias#.MODULES MOD
		WHERE
			SPF.ACTIVE = 1 AND
			SPF.MODULE_ID = MOD.MODULE_ID AND
			SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND 
			SPFC.PRINT_TYPE = 177 AND <!--- bordro--->
			SPF.IS_DEFAULT = 1
		ORDER BY
			SPF.IS_XML,
			SPF.NAME
	</cfquery>
	<cfif GET_DET_FORM.recordcount>
		<cfinclude template="#file_web_path#settings/#GET_DET_FORM.template_file#">
	<cfelse>
		<cfscript>
			function QueryRow(Query,Row) 
				{
				var tmp = QueryNew(Query.ColumnList);
				QueryAddRow(tmp,1);
				for(x=1;x lte ListLen(tmp.ColumnList);x=x+1) QuerySetCell(tmp, ListGetAt(tmp.ColumnList,x), query[ListGetAt(tmp.ColumnList,x)][row]);
				return tmp;
				}
		</cfscript>
		<cfquery name="get_ogis" datasource="#dsn#"><!--- özel gider indirimi sube ile baglanabilirdi ama gerek yok x yilin y ayinda bir kisi icin bir satir olabilir --->
			SELECT
				OGIR.DAMGA_VERGISI AS OGI_DAMGA_TOPLAM,
				OGIR.ODENECEK_TUTAR AS OGI_ODENECEK_TOPLAM
			FROM
				EMPLOYEES_OZEL_GIDER_IND_ROWS AS OGIR,
				EMPLOYEES_OZEL_GIDER_IND AS OGI
			WHERE
				OGIR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
				OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
				OGI.PERIOD_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
				OGIR.OZEL_GIDER_IND_ID = OGI.OZEL_GIDER_IND_ID
		</cfquery>
		<cfif not get_ogis.recordcount>
			<!--- HS20050215 ocak ayinda bu tutarlar puantajdan gelen kisiye bagli olmadigi icin 0 set ediliyor --->
            <cfset get_ogis.OGI_DAMGA_TOPLAM = 0>
            <cfset get_ogis.OGI_ODENECEK_TOPLAM = 0>
		</cfif>
		<cfquery name="get_kumulatif_gelir_vergisi" datasource="#dsn#">
			SELECT SUM(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI) AS TOPLAM FROM EMPLOYEES_PUANTAJ, EMPLOYEES_PUANTAJ_ROWS WHERE EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EMPLOYEES_PUANTAJ.SAL_MON < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfquery>
		<cfquery name="get_odeneks" datasource="#dsn#">
			SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.employee_puantaj_id#"> AND EXT_TYPE = 0 ORDER BY COMMENT_PAY
		</cfquery>
		<cfquery name="get_kesintis" datasource="#dsn#">
			SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.employee_puantaj_id#"> AND EXT_TYPE = 1 ORDER BY COMMENT_PAY
		</cfquery>
		<cfquery name="get_vergi_istisnas" datasource="#dsn#">
			SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.employee_puantaj_id#"> AND EXT_TYPE = 2 ORDER BY COMMENT_PAY
		</cfquery>
		<cfset icmal_type = "personal">
		<cfoutput query="get_puantaj_personal">
			<cfset temp_query_1 = QueryRow(get_puantaj_personal,currentrow)>
            <cfset query_name = "temp_query_1">
		</cfoutput>
	</cfif>
</cfif>
<script type="text/javascript">
	function bordro_onayla(row_id)
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_apply_puantaj&row_id=</cfoutput>'+row_id,'bordro_layer','1',"Bordro Onaylanıyor!");
	}
</script>
<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_my_bordro';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_my_bordro.cfm';
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();

	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'] = structNew();
	
	if (isdefined("attributes.is_submit") and GET_PUANTAJ_PERSONAL.recordcount)
	{	
		if (not get_protests.recordcount)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['text'] = '#lang_array.item[957]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=myhome.popup_add_puantaj_protest&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#&branch_id=#GET_PUANTAJ_PERSONAL.branch_id#','small');";
		}
		if (get_protests.recordcount)
		{	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['text'] = '#lang_array.item[956]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=myhome.popup_list_bordro_protests&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#','list');";
		}
		if (get_protests.recordcount and len(get_protests.answer_date))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][2]['text'] = '#lang_array.item[958]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=myhome.popup_list_bordro_protests&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&emp_puantaj_id=#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#&puantaj_id=#GET_PUANTAJ_PERSONAL.PUANTAJ_ID#','list');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>

