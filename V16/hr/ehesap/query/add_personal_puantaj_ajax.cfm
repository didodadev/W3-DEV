<cfsetting showdebugoutput="no">
<cfparam name="attributes.puantaj_type" default="-1">
<cfparam name="attributes.statue_type" default="">
<cfif not(isdefined('attributes.process_stage') and len(attributes.process_stage))><!--- Kişi puantajdan geliyorsa süreç olmadığı için db den ilk kayıt aşamasını alıyoruz. --->
	<cfquery name="get_process_type" datasource="#dsn#">
		SELECT
			PTR.STAGE,
			PTR.PROCESS_ROW_ID 
		FROM
			PROCESS_TYPE_ROWS PTR,
			PROCESS_TYPE_OUR_COMPANY PTO,
			PROCESS_TYPE PT
		WHERE
			PT.IS_ACTIVE = 1 AND
			PT.PROCESS_ID = PTR.PROCESS_ID AND
			PT.PROCESS_ID = PTO.PROCESS_ID AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			(PT.FACTION LIKE '%ehesap.list_puantaj' OR PT.FACTION LIKE '%ehesap.list_puantaj,%') 
		ORDER BY
			PTR.LINE_NUMBER
	</cfquery>
	<cfif get_process_type.recordcount>
		<cfset attributes.process_stage = get_process_type.process_row_id>
	</cfif>
</cfif>
<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
<cfset ext_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_EXT">
<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD">
<cfset maas_puantaj_table = "EMPLOYEES_SALARY">
<cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq 0>
	<cfset maas_puantaj_table = "EMPLOYEES_SALARY_PLAN">
</cfif>
<cfif not isdefined("is_from_branch_puantaj")>
	<cfset puantaj_action = createObject("component", "V16.hr.ehesap.cfc.create_puantaj")>
	<cfset puantaj_action.dsn = dsn />
</cfif>
<!---<cfinclude template="../query/get_program_parameter.cfm">--->
<cfif (not isDefined("attributes.ihbar_amount")) or (not len(attributes.ihbar_amount))>
	<cfset attributes.IHBAR_AMOUNT=0>
<cfelse>
	<cfset attributes.IHBAR_AMOUNT=replacenocase(attributes.IHBAR_AMOUNT,".","","all")>
</cfif>

<cfif (not isDefined("attributes.kidem_amount")) or (not len(attributes.kidem_amount))>
	<cfset attributes.KIDEM_AMOUNT=0>
<cfelse>
	<cfset attributes.KIDEM_AMOUNT=replacenocase(attributes.KIDEM_AMOUNT,".","","all")>
</cfif>
<!--- Puantaj ekleme sayfasında özel kod xml i açıksa ona göre işlem yapılacak --->
<cfquery name="get_puantaj_xml" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = #session.ep.company_id# AND
		FUSEACTION_NAME = 'ehesap.list_puantaj' AND
		PROPERTY_NAME = 'x_select_special_code'
</cfquery>

<cfif not isdefined("attributes.ssk_statue")>
	<cfquery name = "get_ssk_statue" datasource="#dsn#">
		SELECT USE_SSK FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = #attributes.in_out_id#
	</cfquery>
	<cfset attributes.ssk_statue = get_ssk_statue.USE_SSK>
</cfif>
<cfif (get_puantaj_xml.recordcount and get_puantaj_xml.property_value eq 0) or get_puantaj_xml.recordcount eq 0><cfset x_select_special_code = 0><cfelse><cfset x_select_special_code = 1></cfif>
<cfset get_hr_ssk = puantaj_action.get_hr_ssk(sal_mon: attributes.sal_mon,sal_year: attributes.sal_year,employee_id: attributes.employee_id,ssk_statue:attributes.ssk_statue)/>

<cfset attributes.puantaj_ids = ''>

<cfoutput query="get_hr_ssk">
	<cfif len(FINISH_DATE) and not len(valid)><!--- cikis tarihi dolu olan ancak onay verilmemis calisan --->
		<script type="text/javascript">
			alert('Çıkış İşlemi Onaylanmamış Çalışan Tespit Edildi!\nİşleminiz Tamamlanamadı , Lütfen Düzenleme Yapınız!\nÇalışan : #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#');
			<cfif isdefined("attributes.ajax")>
				<cfif attributes.fuseaction is 'ehesap.emptypopup_add_puantaj_list_from_salary'>
					open_form_ajax(1);
				<cfelse>
					open_form_ajax(2);
				</cfif>
			<cfelse>
				history.back();
			</cfif>
		</script>
		<cfabort>
	</cfif>
	<cfif len(FINISH_DATE) and len(valid) and valid eq 0><!--- cikis tarihi dolu olan ancak onay verilmemis calisan --->
		<script type="text/javascript">
			alert('Çıkış İşlemi Reddedilmiş Çalışan Tespit Edildi!\nİşleminiz Tamamlanamadı , Lütfen Düzenleme Yapınız!\nÇalışan : #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#');
			<cfif isdefined("attributes.ajax")>
				<cfif attributes.fuseaction is 'ehesap.emptypopup_add_puantaj_list_from_salary'>
					open_form_ajax(1);
				<cfelse>
					open_form_ajax(2);
				</cfif>
			<cfelse>
				history.back();
			</cfif>
		</script>
		<cfabort>
	</cfif>
	<cfif len(KULLANILMAYAN_IZIN_AMOUNT) and KULLANILMAYAN_IZIN_AMOUNT lt 0><!--- cikis tarihi dolu olan ancak izin parasi eksik olan --->
		<script type="text/javascript">
			alert('Çıkış İşlemi Hatalı Çalışan Tespit Edildi , Lütfen İzin Gün ve Tutarlarında Düzenleme Yapınız!\nÇalışan : #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#');
			<cfif isdefined("attributes.ajax")>
				<cfif attributes.fuseaction is 'ehesap.emptypopup_add_puantaj_list_from_salary'>
					open_form_ajax(1);
				<cfelse>
					open_form_ajax(2);
				</cfif>
			<cfelse>
				history.back();
			</cfif>
		</script>
		<cfabort>
	</cfif>
	<cfif x_select_special_code eq 1><!--- Eğer özel kod ile çalıştırılıyorsa çalışanın özel kodunun ait olduğu puantajı bulsun diye eklendi --->
		<cfset get_action_id = puantaj_action.get_action_id(attributes.puantaj_type,attributes.sal_mon,attributes.sal_year,BRANCH_ID,HIERARCHY,attributes.ssk_statue,attributes.statue_type)/>
	<cfelse>
		<cfset get_action_id = puantaj_action.get_action_id(puantaj_type: attributes.puantaj_type,sal_mon: attributes.sal_mon,sal_year: attributes.sal_year,BRANCH_ID: BRANCH_ID,ssk_statue: attributes.ssk_statue,statue_type: attributes.statue_type)/>
	</cfif>
	<cfif get_action_id.recordcount>
		<cfquery name="get_dekont" datasource="#dsn#">
			SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ_CARI_ACTIONS WHERE PUANTAJ_ID = #get_action_id.puantaj_id#
		</cfquery>
		<cfif get_action_id.is_account eq 1 or get_action_id.is_locked eq 1 or get_action_id.is_budget eq 1 or get_dekont.recordcount>
			<script type="text/javascript">
				alert("Çalışan İçin Yapılan Puantajlardan Biri Carileştiği , Muhasebeleştirildiği , Bütçeleştirildiği ve/veya Kilitlendiği İçin İşlem Yapamazsınız!");
				<cfif isdefined("attributes.ajax")>
					<cfif attributes.fuseaction is 'ehesap.emptypopup_add_puantaj_list_from_salary'>
						open_form_ajax(1);
					<cfelse>
						open_form_ajax(2);
					</cfif>
				<cfelse>
					history.back();
				</cfif>
			</script>
			<cfabort>
		<cfelseif not listfind(attributes.puantaj_ids,get_action_id.PUANTAJ_ID,',')>
			<cfset attributes.puantaj_ids = listappend(attributes.puantaj_ids,get_action_id.PUANTAJ_ID,',')>
		</cfif>
	</cfif>
</cfoutput>


<cfif listlen(attributes.puantaj_ids)>
	<cfset del_puantaj_rows_ext = puantaj_action.del_puantaj_rows_ext(attributes.puantaj_ids,attributes.EMPLOYEE_ID)>
	<cfset del_puantaj_rows_add = puantaj_action.del_puantaj_rows_add(attributes.puantaj_ids,attributes.EMPLOYEE_ID)>
	<cfset control = puantaj_action.control_devir_matrah(attributes.puantaj_ids,attributes.EMPLOYEE_ID)/>
	<cfif control.recordcount>
		<cfoutput query="control">
			<cfset attributes.sal_mon = SAL_MON>
			<cfif len(ssk_devir) and ssk_devir gt 0>
				<cfset update_puantaj_rows_add_devir = puantaj_action.update_puantaj_rows_add_devir_last(ssk_devir,control.puantaj_type,EMPLOYEE_ID,attributes.sal_mon,attributes.sal_year)>
			</cfif>
			<cfif len(ssk_devir_last) and ssk_devir_last gt 0>
				<cfset update_puantaj_rows_add_devir_last = puantaj_action.update_puantaj_rows_add_devir(ssk_devir_last,control.puantaj_type,EMPLOYEE_ID,attributes.sal_mon,attributes.sal_year)>
			</cfif>
		</cfoutput>
	</cfif>
	<cfset del_puantaj_rows = puantaj_action.del_puantaj_rows(attributes.puantaj_ids,attributes.EMPLOYEE_ID)>
</cfif>
<cfset get_relatives = puantaj_action.get_relatives(attributes.EMPLOYEE_ID,attributes.sal_mon,attributes.sal_year)/>

<cfoutput query="get_hr_ssk">
	<cfquery name="get_action_id" datasource="#dsn#">
		SELECT
			PUANTAJ_ID,
			IS_ACCOUNT,
			IS_BUDGET,
			IS_LOCKED
		FROM
			EMPLOYEES_PUANTAJ
		WHERE
			PUANTAJ_TYPE = #attributes.puantaj_type# AND
			SAL_MON = #attributes.sal_mon# AND
			SAL_YEAR = #attributes.sal_year# AND
			SSK_BRANCH_ID = #BRANCH_ID[currentrow]#
			<cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue)>
				AND STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statue#">
				<cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue) and attributes.ssk_statue eq 2 and len(attributes.statue_type)>
					AND STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statue_type#">
				</cfif>
			</cfif>
			<cfif x_select_special_code eq 1 and len(HIERARCHY[currentrow])>
				AND HIERARCHY = '#HIERARCHY[currentrow]#'
			</cfif>
	</cfquery>
	<cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq -2><!--- fark puantaji olusuyor --->
		<cfquery name="get_action_id_son" datasource="#dsn#">
			SELECT
				PUANTAJ_ID,
				IS_ACCOUNT,
				IS_BUDGET,
				IS_LOCKED
			FROM
				EMPLOYEES_PUANTAJ
			WHERE
				PUANTAJ_TYPE = -3 AND
				SAL_MON = #attributes.sal_mon# AND
				SAL_YEAR = #attributes.sal_year# AND
				SSK_BRANCH_ID = #BRANCH_ID[currentrow]#
				<cfif x_select_special_code eq 1 and len(HIERARCHY[currentrow])>
					AND HIERARCHY = '#HIERARCHY[currentrow]#'
				</cfif>
				<cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue)>
					AND STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statue#">
					<cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue) and attributes.ssk_statue eq 2>
						AND STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statue_type#">
					</cfif>
				</cfif>
		</cfquery>
	</cfif>
	<cfif not get_action_id.recordcount>
		<cflock name="#CREATEUUID()#" timeout="20">
			<cftransaction>
				<cfquery name="ADD_PUANTAJ" datasource="#dsn#" result="MAX_ID">
					INSERT INTO
						EMPLOYEES_PUANTAJ
						(
						PUANTAJ_TYPE,
						SAL_MON,
						SAL_YEAR,
						IS_ACCOUNT,
						IS_LOCKED,
						SSK_OFFICE,
						SSK_OFFICE_NO,
                        SSK_BRANCH_ID,
						COMP_NICK_NAME,
						COMP_FULL_NAME,
						PUANTAJ_BRANCH_NAME,
						PUANTAJ_BRANCH_FULL_NAME,
						<cfif x_select_special_code eq 1 and len(HIERARCHY[currentrow])>
							HIERARCHY,
						</cfif>
						STAGE_ROW_ID,
						IS_LOCK_CONTROL,
						RECORD_DATE,
						RECORD_IP,
						RECORD_EMP,
						STATUE,
                        STATUE_TYPE
						)
					VALUES
						(
						#attributes.puantaj_type#,
						#attributes.sal_mon#,
						#attributes.sal_year#,
						0,
						0,
						<cfqueryparam cfsqltype="cf_sql_nvarchar" value='#SSK_OFFICE[currentrow]#'>,
						'#SSK_NO[currentrow]#',
                        #BRANCH_ID[currentrow]#,
						'#COMP_NICK_NAME[currentrow]#',
						'#COMP_FULL_NAME[currentrow]#',
						'#BRANCH_NAME[currentrow]#',
						'#BRANCH_FULLNAME[currentrow]#',
						<cfif x_select_special_code eq 1 and len(HIERARCHY[currentrow])>
							'#HIERARCHY[currentrow]#',
						</cfif>
						<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
						1,
						#now()#,
						'#cgi.remote_addr#',
						#session.ep.userid#,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statue#">,
                                    <cfif isdefined("attributes.statue_type") and len(attributes.statue_type) AND attributes.ssk_statue eq 2><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statue_type#"><cfelse>NULL</cfif>
						)
				</cfquery>
				<cfset GET_PUANTAJ_ID.MAX_ID = MAX_ID.IDENTITYCOL>
				<cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq -2><!--- fark puantaji olusuyor ---> 
					<cfquery name="ADD_PUANTAJ" datasource="#dsn#">
						INSERT INTO
						EMPLOYEES_PUANTAJ
						(
						PUANTAJ_TYPE,
						SAL_MON,
						SAL_YEAR,
						IS_ACCOUNT,
						IS_LOCKED,
						SSK_OFFICE,
						SSK_OFFICE_NO,
                        SSK_BRANCH_ID,
						COMP_NICK_NAME,
						COMP_FULL_NAME,
						PUANTAJ_BRANCH_NAME,
						PUANTAJ_BRANCH_FULL_NAME,
						<cfif x_select_special_code eq 1 and len(HIERARCHY[currentrow])>
							HIERARCHY,
						</cfif>
						RECORD_DATE,
						RECORD_IP,
						RECORD_EMP,
						STATUE,
                        STATUE_TYPE
						)
					VALUES
						(
						-3,
						#attributes.sal_mon#,
						#attributes.sal_year#,
						0,
						0,
						<cfqueryparam cfsqltype="cf_sql_nvarchar" value='#SSK_OFFICE[currentrow]#'>,
						'#SSK_NO[currentrow]#',
                        #BRANCH_ID[currentrow]#,
						'#COMP_NICK_NAME[currentrow]#',
						'#COMP_FULL_NAME[currentrow]#',
						'#BRANCH_NAME[currentrow]#',
						'#BRANCH_FULLNAME[currentrow]#',
						<cfif x_select_special_code eq 1 and len(HIERARCHY[currentrow])>
							'#HIERARCHY[currentrow]#',
						</cfif>
						#now()#,
						'#cgi.remote_addr#',
						#session.ep.userid#,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statue#">,
                        <cfif isdefined("attributes.statue_type") and len(attributes.statue_type) AND attributes.ssk_statue eq 2><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statue_type#"><cfelse>NULL</cfif>
						)
					</cfquery>
					<cfquery name="GET_SON_PUANTAJ_ID" datasource="#dsn#">
						SELECT MAX(PUANTAJ_ID) AS MAX_ID FROM #main_puantaj_table#
					</cfquery>
					<cfset son_puantaj_id = GET_SON_PUANTAJ_ID.MAX_ID>
				</cfif>
			</cftransaction>
		</cflock>
		<cfset puantaj_id = GET_PUANTAJ_ID.MAX_ID>
	<cfelse>
		<cfset puantaj_id = get_action_id.PUANTAJ_ID>
		<cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq -2><!--- fark puantaji olusuyor --->
			<cfset son_puantaj_id = get_action_id_son.PUANTAJ_ID>	
		</cfif>
	</cfif>
	
	<cfset attributes.puantaj_id = puantaj_id>
	<cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq -2><!--- fark puantaji olusuyor --->
		<cfset attributes.son_puantaj_id = son_puantaj_id>
	</cfif>
	<cfset attributes.row_department_head = DEPARTMENT_HEAD>
	<cfset attributes.in_out_id = IN_OUT_ID>
	<cfset attributes.our_company_id = COMPANY_ID>
	<cfset attributes.SOCIALSECURITY_NO = SOCIALSECURITY_NO>
	<cfif not isdefined("attributes.action_type")>
		<cfset attributes.action_type = "puantaj_aktarim_personal">
	</cfif>
	<cfset salary = 0>
	<cfif isdefined('attributes.finish_date_')><!--- SG 20140123 işten çıkış ekranı 1ekranda hesaplama yaparken güne göre hesaplanan ödeneklerin doğru hesaplanması için eklendi--->
		<cfset get_hr_ssk.finish_date = attributes.finish_date_>
	</cfif>
	<cfinclude template="../query/get_hr_compass_loop.cfm">

</cfoutput>
<cfif isdefined("attributes.ajax")>
	<cfif attributes.fuseaction is not 'ehesap.emptypopup_add_puantaj_list_from_salary'>
		<script type="text/javascript">
			<cfif isdefined("attributes.from_list_puantaj") and len(attributes.from_list_puantaj) and attributes.from_list_puantaj eq 1>
				AjaxPageLoad(adres_,'puantaj_list_layer_from_list_puantaj','1','Puantaj Listeleniyor');
			<cfelse>
				AjaxPageLoad(adres_,'puantaj_list_layer','1','Puantaj Listeleniyor');
			</cfif>
			AjaxPageLoad(adres_menu_2,'menu_puantaj_2','1','Puantaj Menüsü Yükleniyor');
		</script>
	</cfif>
</cfif>
