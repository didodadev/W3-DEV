<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cf_get_lang_set module_name="member">
    <cf_xml_page_edit fuseact="member.consumer_list">
    <cfparam name="attributes.period_id" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.search_potential" default="">
    <cfparam name="attributes.search_status" default=1>
    <cfparam name="attributes.related_status" default="">
    <cfparam name="attributes.sales_county" default="">
    <cfparam name="attributes.pos_code_text" default="">
    <cfparam name="attributes.pos_code" default="">
    <cfparam name="attributes.county_id" default="">
    <cfparam name="attributes.city_id" default="">
    <cfparam name="attributes.country_id" default="1">
    <cfparam name="attributes.member_branch" default="">
    <cfparam name="attributes.mem_code" default="">
    <cfparam name="attributes.customer_value" default="">
    <cfparam name="attributes.tc_identy" default="">
    <cfparam name="attributes.card_no" default="">
    <cfparam name="attributes.ref_pos_code" default="">
    <cfparam name="attributes.ref_pos_code_name" default="">
    <cfparam name="attributes.record_emp" default="">
    <cfparam name="attributes.record_name" default="">
    <cfparam name="attributes.cons_cat" default="">
    <cfparam name="attributes.use_efatura" default="">
    <cfinclude template="../member/query/get_consumer_value.cfm">
    <cfinclude template="../member/query/get_consumer_cat.cfm">
    <cfinclude template="../member/query/get_resource.cfm">
    <cfinclude template="../member/query/get_customer.cfm">
    <cfif get_consumer_cat.recordcount>
        <cfset list_cons_cat_id = valuelist(get_consumer_cat.conscat_id,',')>
    <cfelse>
        <cfset list_cons_cat_id = 0>
    </cfif>
    <cfquery name="GET_CITY" datasource="#DSN#">
        SELECT CITY_ID, CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
    </cfquery>
    
    <cfquery name="GET_CONSUMER_STAGE" datasource="#DSN#">
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
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.consumer_list%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfquery name="GET_BRANCH_ALL" datasource="#DSN#">
        SELECT 
            OUR_COMPANY.NICK_NAME, 
            BRANCH.BRANCH_NAME,
            BRANCH.BRANCH_ID,
            BRANCH.COMPANY_ID
        FROM 
            BRANCH, 
            OUR_COMPANY,
            EMPLOYEE_POSITION_BRANCHES
        WHERE
            EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
            EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID AND
            EMPLOYEE_POSITION_BRANCHES.DEPARTMENT_ID IS NULL AND  
            BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
        ORDER BY 
            OUR_COMPANY.COMPANY_NAME,	
            BRANCH.BRANCH_NAME
    </cfquery>
    <cfquery name="GET_PERIOD" datasource="#DSN#">
        SELECT
            OUR_COMPANY.COMP_ID,
            OUR_COMPANY.COMPANY_NAME,
            SETUP_PERIOD.PERIOD_ID,
            SETUP_PERIOD.PERIOD
        FROM
            SETUP_PERIOD,
            OUR_COMPANY,
            EMPLOYEE_POSITION_PERIODS EPP
        WHERE 
            EPP.PERIOD_ID = SETUP_PERIOD.PERIOD_ID AND
            EPP.POSITION_ID = (SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND IS_MASTER = 1) AND
            SETUP_PERIOD.OUR_COMPANY_ID = OUR_COMPANY.COMP_ID 
        ORDER BY 
            OUR_COMPANY.COMPANY_NAME,
            SETUP_PERIOD.PERIOD_YEAR
    </cfquery>
    <cfquery name="GET_COMP" dbtype="query">
        SELECT DISTINCT COMP_ID,COMPANY_NAME FROM GET_PERIOD ORDER BY COMPANY_NAME
    </cfquery>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="GET_OURCMP_INFO" datasource="#DSN#">
            SELECT IS_STORE_FOLLOWUP FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
        <cfscript>
                get_consumer_list_action = CreateObject("component","member.cfc.get_consumer");
                get_consumer_list_action.dsn = dsn;
                get_cons_ct = get_consumer_list_action.get_consumer_list_fnc(
                    is_resource_id : '#iif(isdefined("is_resource_id"),"is_resource_id",DE(""))#' ,
                    is_record_member :'#iif(isdefined("is_record_member"),"is_record_member",DE(""))#' ,
                    is_customer_value : '#iif(isdefined("is_customer_value"),"is_customer_value",DE(""))#' ,
                    is_ref_pos_code: '#iif(isdefined("is_ref_pos_code"),"is_ref_pos_code",DE(""))#' ,
                    list_cons_cat_id: '#iif(isdefined("list_cons_cat_id"),"list_cons_cat_id",DE(""))#' ,
                    period_id: '#iif(isdefined("attributes.period_id"),"attributes.period_id",DE(""))#' ,
                    module_name : fusebox.circuit ,
                    is_store_followup: '#iif(isdefined("get_ourcmp_info.is_store_followup"),"get_ourcmp_info.is_store_followup",DE(""))#' ,
                    member_branch: '#iif(isdefined("attributes.member_branch"),"attributes.member_branch",DE(""))#' ,
                    ref_pos_code: '#iif(isdefined("attributes.ref_pos_code"),"attributes.ref_pos_code",DE(""))#' ,
                    record_emp: '#iif(isdefined("attributes.record_emp"),"attributes.record_emp",DE(""))#' ,
                    customer_value: '#iif(isdefined("attributes.customer_value"),"attributes.customer_value",DE(""))#' ,
                    resource: '#iif(isdefined("attributes.resource"),"attributes.resource",DE(""))#' ,
                    process_stage_type: '#iif(isdefined("attributes.process_stage_type"),"attributes.process_stage_type",DE(""))#' ,
                    search_potential: '#iif(isdefined("attributes.search_potential"),"attributes.search_potential",DE(""))#' ,
                    search_status: '#iif(isdefined("attributes.search_status"),"attributes.search_status",DE(""))#' ,
                    related_status: '#iif(isdefined("attributes.related_status"),"attributes.related_status",DE(""))#' ,
                    cons_cat: '#iif(isdefined("attributes.cons_cat"),"attributes.cons_cat",DE(""))#' ,
                    keyword: '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#' ,
                    database_type: database_type ,
                    sales_county: '#iif(isdefined("attributes.sales_county"),"attributes.sales_county",DE(""))#' ,
                    pos_code: '#iif(isdefined("attributes.pos_code"),"attributes.pos_code",DE(""))#' ,
                    pos_code_text: '#iif(isdefined("attributes.pos_code_text"),"attributes.pos_code_text",DE(""))#',
                    country_id: '#iif(isdefined("attributes.country_id"),"attributes.country_id",DE(""))#' ,
                    city_id: '#iif(isdefined("attributes.city_id"),"attributes.city_id",DE(""))#' ,
                    county_id: '#iif(isdefined("attributes.county_id"),"attributes.county_id",DE(""))#' ,
                    customer_value: '#iif(isdefined("attributes.customer_value"),"attributes.customer_value",DE(""))#' ,
                    is_code_filter: '#iif(isdefined("is_code_filter"),"is_code_filter",DE(""))#' ,
                    mem_code: '#iif(isdefined("attributes.mem_code"),"attributes.mem_code",DE(""))#' ,
                    tc_identy: '#iif(isdefined("attributes.tc_identy"),"attributes.tc_identy",DE(""))#' ,
                    card_no: '#iif(isdefined("attributes.card_no"),"attributes.card_no",DE(""))#' ,
                    row_block : '#iif((session.ep.our_company_info.sales_zone_followup eq 1),"500",DE(""))#',
                    blacklist_status : '#iif(isdefined("attributes.blacklist_status"),"attributes.blacklist_status",DE(""))#' ,
                    order_type : '#iif(isdefined("attributes.order_type"),"attributes.order_type",DE(""))#',
                    startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
                    maxrows :'#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
                    use_efatura : '#iif(isdefined("attributes.use_efatura"),"attributes.use_efatura",DE(""))#'
                );
        </cfscript>
    <cfelse>
        <cfset get_cons_ct.recordcount = 0>
    </cfif>
    <cfif get_cons_ct.recordcount>
        <cfparam name="attributes.totalrecords" default='#get_cons_ct.query_count#'>
    <cfelse>
        <cfparam name="attributes.totalrecords" default='0'>
    </cfif>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
    <cf_xml_page_edit fuseact="member.form_add_consumer" is_multi_page="1">
    <cf_get_lang_set module_name="member">
    <cfinclude template="../member/query/get_mobilcat.cfm">
    <cfinclude template="../member/query/get_im.cfm">
    <cfinclude template="../member/query/get_company_size_cats.cfm">
    <cfinclude template="../member/query/get_partner_positions.cfm">
    <cfinclude template="../member/query/get_partner_departments.cfm">
    <cfinclude template="../member/query/get_country.cfm">
    <cfinclude template="../member/query/get_consumer_value.cfm">
    <!---<cfinclude template="../member/query/get_societies.cfm">--->
    <cfinclude template="../member/query/get_edu_level.cfm">
    <cfinclude template="../member/query/get_identycard_cat.cfm">
    <!--- Sadece aktif kategorilerin gelmesi için --->
    <cfset attributes.is_active_consumer_cat = 1>
    <cfquery name="SZ" datasource="#DSN#">
        SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
    </cfquery>
    <cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1>
        <cfquery name="GET_ZONE_KONTROL" datasource="#DSN#">
            SELECT
                SZ.CITY_ID
            FROM
                SALES_ZONES S,
                SALES_ZONE_GROUP SG,
                SALES_ZONES_TEAM SZ,
                SALES_ZONES_TEAM_ROLES SZR
            WHERE
                S.SZ_ID = SG.SZ_ID AND
                S.SZ_ID = SZ.SALES_ZONES AND
                SZ.TEAM_ID = SZR.TEAM_ID AND
                (SZ.LEADER_POSITION_CODE = #session.ep.position_code# OR SZR.POSITION_CODE = #session.ep.position_code# OR SG.POSITION_CODE = #session.ep.position_code#) AND
                SZ.CITY_ID IS NOT NULL
        </cfquery>
        <cfif get_zone_kontrol.recordcount>
            <cfset kontrol_zone = ''>
            <cfoutput query="get_zone_kontrol">
                <cfquery name="GET_CITY_CODE" datasource="#DSN#">
                    SELECT PLATE_CODE FROM SETUP_CITY WHERE CITY_ID = #get_zone_kontrol.city_id#
                </cfquery>
                <cfif get_city_code.plate_code eq 34>
                    <cfquery name="GET_CITYS" datasource="#DSN#">
                        SELECT CITY_ID FROM SETUP_CITY WHERE PLATE_CODE = '#get_city_code.plate_code#'
                    </cfquery>
                    <cfloop query="get_citys">
                        <cfset kontrol_zone = listappend(kontrol_zone,get_citys.city_id,',')>
                    </cfloop>
                <cfelse>
                    <cfset kontrol_zone = listappend(kontrol_zone,get_zone_kontrol.city_id,',')>
                </cfif>
            </cfoutput>
        <cfelse>
            <cfset kontrol_zone = -1>
        </cfif>
    </cfif>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd' or attributes.event is 'det'>
	<cfsetting showdebugoutput="no">
    <cf_xml_page_edit fuseact="member.form_add_consumer">
    <cf_get_lang_set module_name="member">
    <cfif isDefined('session.ep.member_view_control') and session.ep.member_view_control eq 1>
        <cfquery name="view_control" datasource="#dsn#">
            SELECT
                IS_MASTER
            FROM
                WORKGROUP_EMP_PAR
            WHERE
                CONSUMER_ID = #attributes.cid# AND
                OUR_COMPANY_ID = #session.ep.company_id# AND
                POSITION_CODE = #session.ep.position_code#
        </cfquery>
        <cfif not view_control.recordcount>
            <script type="text/javascript">
                alert("<cf_get_lang no ='459.Bu Üyeyi Görmek İçin Yetkiniz Yok'>");
                history.back();
            </script>
        </cfif>
    </cfif>
    <cfif isnumeric(attributes.cid)>
        <cfinclude template="../member/query/get_consumer.cfm">
    <cfelse>
        <cfset get_consumer.recordcount = 0>
    </cfif>
    <cfif not get_consumer.recordcount>
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='589.Böyle Bir Üye Bulunamadı'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../../dsp_hata.cfm">
    <cfelse>
        <cfinclude template="../objects/display/imageprocess/imcontrol.cfm">
        <cfset session.resim = 1>
        <cfinclude template="../member/query/get_company_cat.cfm">
        <cfinclude template="../member/query/get_im.cfm">
        <cfinclude template="../member/query/get_bank_cons.cfm">
        <cfinclude template="../member/query/get_company_size.cfm">
        <cfinclude template="../member/query/get_partner_positions.cfm">
        <cfinclude template="../member/query/get_partner_departments.cfm">
       <!--- <cfinclude template="../member/query/get_societies.cfm">--->
        <cfinclude template="../member/query/get_income_level.cfm">
        <cfinclude template="../member/query/get_country.cfm">
        <cfinclude template="../member/query/get_consumer_value.cfm">
        <cfinclude template="../member/query/get_edu_level.cfm">
        <cfquery name="GET_WORK_POS" datasource="#DSN#">
            SELECT
                CONSUMER_ID,
                OUR_COMPANY_ID,
                POSITION_CODE,
                IS_MASTER
            FROM
                WORKGROUP_EMP_PAR
            WHERE
                CONSUMER_ID IS NOT NULL AND
                CONSUMER_ID = #attributes.cid# AND
                OUR_COMPANY_ID = #session.ep.company_id# AND
                IS_MASTER = 1
        </cfquery>
        <cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1>
            <cfquery name="get_zone_kontrol" datasource="#dsn#">
                SELECT
                    SZ.CITY_ID
                FROM
                    SALES_ZONES S,
                    SALES_ZONE_GROUP SG,
                    SALES_ZONES_TEAM SZ,
                    SALES_ZONES_TEAM_ROLES SZR
                WHERE
                    S.SZ_ID = SG.SZ_ID AND
                    S.SZ_ID = SZ.SALES_ZONES AND
                    SZ.TEAM_ID = SZR.TEAM_ID AND
                    (SZ.LEADER_POSITION_CODE = #session.ep.position_code# OR SZR.POSITION_CODE = #session.ep.position_code# OR SG.POSITION_CODE = #session.ep.position_code#) AND
                    SZ.CITY_ID IS NOT NULL
            </cfquery>
            <cfif get_zone_kontrol.recordcount>
                <cfset kontrol_zone = ''>
                <cfoutput query="get_zone_kontrol">
                    <cfquery name="get_city_code" datasource="#dsn#">
                        SELECT PLATE_CODE FROM SETUP_CITY WHERE CITY_ID =#get_zone_kontrol.city_id#
                    </cfquery>
                    <cfif get_city_code.plate_code eq 34>
                        <cfquery name="get_citys" datasource="#dsn#">
                            SELECT CITY_ID FROM SETUP_CITY WHERE PLATE_CODE ='#get_city_code.plate_code#'
                        </cfquery>
                        <cfloop query="get_citys">
                            <cfset kontrol_zone = listappend(kontrol_zone,get_citys.city_id,',')>
                        </cfloop>
                    <cfelse>
                        <cfset kontrol_zone = listappend(kontrol_zone,get_zone_kontrol.city_id,',')>
                    </cfif>
                </cfoutput>
            <cfelse>
                <cfset kontrol_zone = -1>
            </cfif>
        </cfif>
        <cfset consumer = get_consumer.consumer_name & ' ' & get_consumer.consumer_surname>
	</cfif>   
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">     
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.event") and attributes.event is 'add' or isdefined("attributes.event") and attributes.event is 'upd'>
		<cfif isdefined("is_adres_detail")>
			$( document ).ready(function() {
				is_adres_detail = '<cfoutput>#is_adres_detail#</cfoutput>';
			});
		<cfelse>
			$( document ).ready(function() {
				is_adres_detail = 0;
			});
		</cfif>
		<cfif isdefined("is_residence_select")>
			$( document ).ready(function() {
				is_residence_select = '<cfoutput>#is_residence_select#</cfoutput>';
			});				
		<cfelse>
			$( document ).ready(function() {
				is_residence_select = 0;
			});					
		</cfif>
		<cfif isdefined("is_req_reference_member")>
			$( document ).ready(function() {
				is_req_reference_member = '<cfoutput>#is_req_reference_member#</cfoutput>';
			});				
		<cfelse>
			$( document ).ready(function() {
				is_req_reference_member = 0;
			});					
		</cfif>
		<cfif isdefined("is_dsp_reference_member")>
			$( document ).ready(function() {
				is_dsp_reference_member = '<cfoutput>#is_dsp_reference_member#</cfoutput>';
			});				
		<cfelse>
			$( document ).ready(function() {
				is_dsp_reference_member = 0;
			});				
		</cfif>
		<cfif isdefined("is_dsp_category")>
			$( document ).ready(function() {
				is_dsp_category = '<cfoutput>#is_dsp_category#</cfoutput>';
			});				
		<cfelse>
			$( document ).ready(function() {
				is_dsp_category = 0;
			});				
		</cfif>
		<cfif isdefined("is_dsp_personal_info")>
			$( document ).ready(function() {
				is_dsp_personal_info = '<cfoutput>#is_dsp_personal_info#</cfoutput>';
			});				
		<cfelse>
			$( document ).ready(function() {
				is_dsp_personal_info = 0;
			});				
		</cfif>
		<cfif isdefined("is_dsp_homeaddress_info")>
			$( document ).ready(function() {
				is_dsp_homeaddress_info = '<cfoutput>#is_dsp_homeaddress_info#</cfoutput>';
			});				
		<cfelse>
			$( document ).ready(function() {
				is_dsp_homeaddress_info = 0;
			});					
		</cfif>
		<cfif isdefined("is_dsp_workaddress_info")>
			$( document ).ready(function() {
				is_dsp_workaddress_info = '<cfoutput>#is_dsp_workaddress_info#</cfoutput>';
			});				
		<cfelse>
			$( document ).ready(function() {
				is_dsp_workaddress_info = 0;
			});				
		</cfif>
		<cfif isdefined("is_fast_add_display")>
			$( document ).ready(function() {
				is_fast_add_display = '<cfoutput>#is_fast_add_display#</cfoutput>';
			});				
		<cfelse>
			$( document ).ready(function() {
				is_fast_add_display = 0;
			});				
		</cfif>
		<cfif isdefined("is_invoice_info_detail")>
			$( document ).ready(function() {
				is_invoice_info_detail = '<cfoutput>#is_invoice_info_detail#</cfoutput>';
			});				
		<cfelse>
			$( document ).ready(function() {
				is_invoice_info_detail = 0;
			});				
		</cfif>
		<cfif isdefined("is_birthday")>
			$( document ).ready(function() {
				is_birthday = '<cfoutput>#is_birthday#</cfoutput>';
			});				
		<cfelse>
			$( document ).ready(function() {
				is_birthday = 0;
			});				
		</cfif>
		<cfif isdefined("is_home_telephone")>
			$( document ).ready(function() {
				is_home_telephone = '<cfoutput>#is_home_telephone#</cfoutput>';
			});				
		<cfelse>
			$( document ).ready(function() {
				is_home_telephone = 0;
			});				
		</cfif>
		<cfif isdefined("is_dsp_photo")>
			$( document ).ready(function() {
				is_dsp_photo = '<cfoutput>#is_dsp_photo#</cfoutput>';
			});				
		<cfelse>
			$( document ).ready(function() {
				is_dsp_photo = 0;
			});				
		</cfif>
		<cfif isdefined("is_resource_info")>
			$( document ).ready(function() {
				is_resource_info = '<cfoutput>#is_resource_info#</cfoutput>';
			});					
		<cfelse>
			$( document ).ready(function() {
				is_resource_info = 0;
			});				
		</cfif>
		<cfif isdefined("is_cari_working")>
			$( document ).ready(function() {
				is_cari_working = '<cfoutput>#is_cari_working#</cfoutput>';
			});				
		<cfelse>
			$( document ).ready(function() {
				is_cari_working = 0;
			});				
		</cfif>
	</cfif>
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		<cfif is_dsp_workaddress_info eq 1>
			$( document ).ready(function() {
				work_country_ = document.form_consumer.work_country.value;
				if(work_country_.length)
					LoadCity(work_country_,'work_city_id','work_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif>);
			});
		</cfif>
		
		<cfif not isdefined('attributes.city_id')>
			$( document ).ready(function() {
				if(is_dsp_homeaddress_info == 1)
				{
						home_country_ = document.form_consumer.home_country.value;
						if(home_country_.length)
							LoadCity(home_country_,'home_city_id','home_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif>);
					
				}
				
				if(is_fast_add_display == 0)
				{
						tax_country_ = document.form_consumer.tax_country.value;
						if(tax_country_.length)
							LoadCity(tax_country_,'tax_city_id','tax_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif>);
				}	
			});
		</cfif>
		function add_kontrol()
		{
			if(document.getElementById("use_efatura").checked == true && document.getElementById("efatura_date").value == "")
			{
				alert("<cf_get_lang_main no='531.Tarih Seçiniz!'>");
				return false;
			}
			if(document.getElementById("use_efatura").checked == false && document.getElementById("efatura_date").value != "")
			{
				alert("<cf_get_lang_main no='2313.E-fatura tarihi girilmiş ancak E-fatura checkboxı seçili değildir, Lütfen kontrol ediniz'>");
				return false;
			}
			if(document.getElementById('consumer_name').value=='')
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='219.Ad'>");
				return false;
			}
			if(document.getElementById('consumer_surname').value=='')
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1314.Soyad'>");
				return false;
			}
			// uye kategorisi gorunsun mu
			if(is_dsp_category == 1 && document.form_consumer.consumer_cat_id != undefined)
			{
				x = document.form_consumer.consumer_cat_id.selectedIndex;
				if (document.form_consumer.consumer_cat_id[x].value == "")
				{ 
					alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1197.Üye Kategorisi'>!");
					return false;
				}
			}
			<cfif xml_mobile_tel_required eq 1>
				//mobil tel zorunlu ise
				if(document.getElementById('mobiltel').value=='')
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='43.Mobil Telefon'>");
					return false;
				}
			</cfif>
			<cfif isdefined('is_fast_add_member_option') and is_fast_add_member_option eq 2> 
				if(document.form_consumer.member_add_option_id.value == '')
				{
					alert("<cf_get_lang no='156.Lütfen üye özel tanımı seçiniz!'>");
					return false;
				}
			</cfif>
			if((document.form_consumer.coordinate_1 != undefined && document.form_consumer.coordinate_1.value.length != "" && document.form_consumer.coordinate_2 != undefined && document.form_consumer.coordinate_2.value.length == "") || (document.form_consumer.coordinate_1 != undefined && document.form_consumer.coordinate_1.value.length == "" && document.form_consumer.coordinate_2 != undefined && document.form_consumer.coordinate_2.value.length != ""))
			{
				alert ("<cf_get_lang no='154.Lütfen koordinat değerlerini eksiksiz giriniz!'>");
				return false;
			}
						
			<cfif is_tc_number eq 1>
				if(document.getElementById('is_verify') != undefined )
				{
					if(document.getElementById('is_verify').value == 0)
					{
						alert("Girdiğiniz TC Kimlik No Geçerli Değil Lütfen Bilgilerinizi Kontrol Ediniz !");
						return false;
					}
				}
			</cfif>
	
			//referans uye gosterilsin mi // zorunlu olsun mu
			if(is_dsp_reference_member == 1 && is_req_reference_member == 1 && document.form_consumer.ref_pos_code_name.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1224.Referans Üye'>!");
				document.getElementById('ref_pos_code_name').focus();
				return false;
			}
			//fatura bilgileri zorunlu olsun mu
			if(is_invoice_info_detail == 1)
			{
				if(document.form_consumer.tax_office != undefined  && document.form_consumer.tax_office.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1350.vergi dairesi'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					document.getElementById('tax_office').focus();
					return false;
				}
				if(document.form_consumer.tax_no != undefined  && document.form_consumer.tax_no.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='340.vergi no'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					document.getElementById('tax_no').focus();
					return false;
				}
				if(document.form_consumer.tax_postcode != undefined  && document.form_consumer.tax_postcode.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='60.posta kodu'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					document.getElementById('tax_postcode').focus();
					return false;
				}
				if(document.form_consumer.tax_country != undefined  && document.form_consumer.tax_country.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='807.ülke'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					return false;
				}
				if(document.form_consumer.tax_city_id != undefined  && document.form_consumer.tax_city_id.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='559.şehir'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					return false;
				}
				if(document.form_consumer.tax_county_id != undefined  && document.form_consumer.tax_county_id.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1226.ilçe'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					return false;
				}
				if(document.form_consumer.tax_semt != undefined  && document.form_consumer.tax_semt.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='720.semt'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					document.getElementById('tax_semt').focus();				
					return false;
				}
				if(is_adres_detail == 0)
				{
					if(document.form_consumer.tax_address != undefined  && document.form_consumer.tax_address.value == "")
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='123.fatura adresi'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
						document.getElementById('tax_address').focus();
						return false;
					}
				}
				else if(is_adres_detail == 1)
				{
					if(document.form_consumer.tax_district_id != undefined  && ((is_residence_select == 0 && document.form_consumer.tax_district.value == "") || (is_residence_select == 1 && document.form_consumer.tax_district_id.value == "")))
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1323.mahalle'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
						if(is_residence_select == 0)
						{
							document.getElementById('tax_district').focus();
						}
						return false;
					}
					if(document.form_consumer.tax_main_street != undefined  && document.form_consumer.tax_main_street.value == "")
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='491.cadde'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
						document.getElementById('tax_main_street').focus();
						return false;
					}
					if(document.form_consumer.tax_street != undefined  && document.form_consumer.tax_street.value == "")
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='492.sokak'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
						document.getElementById('tax_street').focus();					
						return false;
					}
					if(document.form_consumer.tax_door_no != undefined  && document.form_consumer.tax_door_no.value == "")
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='75.no'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
						document.getElementById('tax_door_no').focus();					
						return false;
					}
				}
			}
	
			//dogum tarihi zorunlu olsun mu (kisisel bilgiler yada hizli ekleme varsa)
			if((is_dsp_personal_info == 1 || is_fast_add_display == 1) && is_birthday == 1 && document.form_consumer.birthdate.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1315.Doğum Tarihi!'>!");
				document.getElementById('birthdate').focus();			
				return false;
			}
			
			if((is_dsp_personal_info == 1 || is_fast_add_display == 1) && (document.form_consumer.married.checked == false && document.form_consumer.married_date.value != ''))
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='375.Medeni Durumu'>!");
				document.getElementById('married_date').focus();			
				return false;
			}
			
			//ev telefonu zorunlu olsun mu (kisisel bilgiler yada hizli ekleme varsa)
			if((is_dsp_homeaddress_info == 1 || is_fast_add_display == 1) && is_home_telephone == 1)
			{
				if(document.form_consumer.home_telcode.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='178.Telefon Kodu'>!");
					document.getElementById('home_telcode').focus();				
					return false;
				}
				if(document.form_consumer.home_tel.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='1402.Telefon no'>!");
					document.getElementById('home_tel').focus();
					return false;
				}
			}
			
			if(document.form_consumer.work_address != undefined)
			{
				x = (200 - document.form_consumer.work_address.value.length);
				if ( x < 0 )
				{ 
					alert ("<cf_get_lang no='469.İş Adresi'><cf_get_lang_main no='798.Alanındaki Fazla Karakter Sayısı'>"+ ((-1) * x));
					return false;
				}	
			}
	
			if(document.form_consumer.home_address != undefined)
			{	
				x = (200 - document.form_consumer.home_address.value.length);
				if ( x < 0 )
				{ 
					alert ("<cf_get_lang no='468.Ev Adresi'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayısı'>"+ ((-1) * x));
					return false;
				}
			}
			if(document.form_consumer.tax_address != undefined)
			{	
				x = (750 - document.form_consumer.tax_address.value.length);
				if ( x < 0 )
				{ 
					alert ("<cf_get_lang no='123.Fatura Adresi'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayısı'>:"+ ((-1) * x));
					return false;
				}
			}
			if(document.form_consumer.consumer_password != undefined)
			{
				x = (document.form_consumer.consumer_password.value.length);
				if ((document.form_consumer.consumer_password.value != '')  && ( x < 4 ))
				{ 
					alert ("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no='196.Şifre-En Az Dört Karakter'>");
					return false;
				}		
			}
			if(is_resource_info == 1)
			{
				if(document.form_consumer.resource.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1418.İlişki Şekli'> !");
					return false;
				}
			}
			
			if(is_cari_working == 1)
			{
				if(document.form_consumer.is_cari.checked == false)
				{
					alert("<cf_get_lang no='161.Çalışılabilir Alanı Seçili Olmalıdır!'>");
					return false;
				}
			}	
			
			<cfif session.ep.our_company_info.sales_zone_followup eq 1>	
				if(document.form_consumer.sales_county!=undefined)
				{
				x = document.form_consumer.sales_county.selectedIndex;
				if (document.form_consumer.sales_county[x].value == "")
				{ 
					alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='247.Satış Bölgesi '>!");
					return false;
				}
				if(document.form_consumer.ims_code_id.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='722.Micro Bölge Kodu'> !");
					return false;
				}	
				}		
			</cfif>	
			if(is_dsp_photo == 1)
			{
				var obj =  document.form_consumer.picture.value;
				if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
				{
					alert("<cf_get_lang no='197.Lütfen bir resim dosyasıgif jpg veya png giriniz'>!!");        
					return false;
				}
			}
			<cfif xml_check_cell_phone eq 1>
				if(document.getElementById('mobilcat_id').value != "" && document.getElementById('mobiltel').value != "")
				{
					
					var listParam = document.getElementById('mobilcat_id').value + "*" + document.getElementById('mobiltel').value;
					var get_results = wrk_safe_query('mr_add_cell_phone',"dsn",0,listParam);
					if(get_results.recordcount>0)
					{
						  alert("<cf_get_lang no='157.Girdiğiniz Cep Telefonuna Kayıtlı Başka Temsilci Bulunmaktadır!'>");
						  document.getElementById('mobiltel').focus();
						  return false;
					}              
				}
			</cfif>
			<!---<cfif isdefined('xml_consumer_contract_id') and len(xml_consumer_contract_id)>
				if(document.getElementById('contract_rules').checked!=true)
				{
					alert ("<cf_get_lang no='96.Temsilci sözleşmesini kabul ediyorum seçeneğini seçmelisiniz!'>");
					return false;
				}
			</cfif>--->

			if(process_cat_control())
				if(confirm("<cf_get_lang no='175.Girdiğiniz Bilgileri Kaydetmek Üzeresiniz Lütfen Değişiklikleri Onaylayın'>")) {pre_records();return true;} else return false;
			else
				return false;
				
			return true;				
		}
		
		function pre_records()
		{
			<cfif fusebox.circuit eq 'store'>	
				if(form_consumer.tax_no != undefined)
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_consumer_prerecords&is_store_module=1&consumer_name=' + encodeURIComponent(document.getElementById('consumer_name').value) + '&consumer_surname=' + encodeURIComponent(document.getElementById('consumer_surname').value) + '&tax_no=' + form_consumer.tax_no.value ,'project');
				else
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_consumer_prerecords&is_store_module=1&consumer_name=' + encodeURIComponent(document.getElementById('consumer_name').value) + '&consumer_surname=' + encodeURIComponent(document.getElemetnById('consumer_surname').value) + '&tax_no=0' ,'project');
			<cfelse>
				if(form_consumer.tax_no != undefined)
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_consumer_prerecords&consumer_name=' + encodeURIComponent(document.getElementById('consumer_name').value) + '&consumer_surname=' + encodeURIComponent(document.getElementById('consumer_surname').value) + '&tax_no=' + document.getElementById('tax_no').value ,'project');
				else
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_consumer_prerecords&consumer_name=' + encodeURIComponent(document.getElementById('consumer_name').value) + '&consumer_surname=' + encodeURIComponent(document.getElementById('consumer_surname').value)+'&tax_no=0' ,'project');
			</cfif>
			return false;
		}
		
		function get_ims_code(type)
		{
			if(type == 1)
			{
				get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('home_district_id').value);
				get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('home_district_id').value);
				if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
				{		
					document.getElementById('home_semt').value=get_ims_code_.PART_NAME;
					document.getElementById('home_postcode').value=get_ims_code_.POST_CODE;
				}
				else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
				{
					document.getElementById('home_semt').value = get_district_.PART_NAME;
					document.getElementById('home_postcode').value = get_district_.POST_CODE;
				}
				else
				{
					document.getElementById('home_semt').value = '';
					document.getElementById('home_postcode').value = '';
				}
			}
			else if(type == 2)
			{
				get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('work_district_id').value);
				get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('work_district_id').value);
				if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
				{		
					document.getElementById('work_semt').value=get_ims_code_.PART_NAME;
					document.getElementById('work_postcode').value=get_ims_code_.POST_CODE;
				}
				else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
				{
					document.getElementById('work_semt').value = get_district_.PART_NAME;
					document.getElementById('work_postcode').value = get_district_.POST_CODE;
				}
				else
				{
					document.getElementById('work_semt').value = '';
					document.getElementById('work_postcode').value = '';
				}
			}
			else
			{
				get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('tax_district_id').value);
				get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('tax_district_id').value);
				if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
				{		
					document.getElementById('tax_semt').value=get_ims_code_.PART_NAME;
					document.getElementById('tax_postcode').value=get_ims_code_.POST_CODE;
				}
				else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
				{
					document.getElementById('tax_semt').value = get_district_.PART_NAME;
					document.getElementById('tax_postcode').value = get_district_.POST_CODE;
				}
				else
				{
					document.getElementById('tax_semt').value = '';
					document.getElementById('tax_postcode').value = '';
				}
			}
		}
		function goruntule(obj)
		{
			if(obj.value == 1)
				$( document ).ready(function() {
					goster(married_date);
				});
			else
				$( document ).ready(function() {
					gizle(married_date);
				});
		}
		$( document ).ready(function() {
			document.getElementById('consumer_name').focus();			
		});
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function sayfa_getir()
		{
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=member.emptypopup_create_password','SHOW_PASSWORD',1);
		}
		$( document ).ready(function() {
			if(is_dsp_workaddress_info == 1)
			{
				
				work_country_= document.form_consumer.work_country.value;
				<cfif not len(get_consumer.work_city_id)>
					$( document ).ready(function() {
						if(work_country_.length)
							LoadCity(work_country_,'work_city_id','work_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif>)
					});						
				</cfif>
	
				work_city_= document.form_consumer.work_city_id.value;
				<cfif not len(get_consumer.work_county_id)>
					if(work_city_.length)
						LoadCounty(work_city_,'work_county_id')
				</cfif>

				if(document.form_consumer.work_district_id != undefined)
				{
					work_county_= document.form_consumer.work_county_id.value;
					<cfif not len(get_consumer.work_district_id)>
						if(work_county_.length)
							LoadDistrict(work_county_,'work_district_id')
					</cfif>
				}
			}
			if(is_dsp_homeaddress_info == 1)
			{
				home_country_= document.form_consumer.home_country.value;
				<cfif not len(get_consumer.home_city_id)>
					if(home_country_.length)
						LoadCity(home_country_,'home_city_id','home_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif>)
				</cfif>
	
				home_city_= document.form_consumer.home_city_id.value;
				<cfif not len(get_consumer.home_county_id)>
					if(home_city_.length)
						LoadCounty(home_city_,'home_county_id')
				</cfif>
	
				if(document.form_consumer.home_district_id != undefined)
				{
					home_county_= document.form_consumer.home_county_id.value;
					<cfif not len(get_consumer.home_district_id)>
						if(home_county_.length)
							LoadDistrict(home_county_,'home_district_id')
					</cfif>
				}
			}
		
			tax_country_= document.form_consumer.tax_country.value;
			<cfif not len(get_consumer.tax_city_id)>
				if(tax_country_.length)
					LoadCity(tax_country_,'tax_city_id','tax_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif>)
			</cfif>
			
			tax_city_= document.form_consumer.tax_city_id.value;
			<cfif not len(get_consumer.tax_county_id)>
				if(tax_city_.length)
					LoadCounty(tax_city_,'tax_county_id')
			</cfif>	
		
			if(document.form_consumer.tax_district_id != undefined)
			{
				tax_county_= document.form_consumer.tax_county_id.value;
				<cfif not len(get_consumer.tax_district_id)>
					if(tax_county_.length)
						LoadDistrict(tax_county_,'tax_district_id')
				</cfif>
			}
		});	
		<cfif isdefined('attributes.sub_id')>
			if(<cfoutput>#attributes.sub_id#</cfoutput> != "")
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=<cfoutput>#attributes.sub_id#</cfoutput>','list','upd_subscription_contract');//location.href=""
			}
		</cfif>	
		//document.all.upload_status.style.display = 'none';
		function add_kontrol()
		{
			if(document.getElementById("use_efatura").checked == true && document.getElementById("efatura_date").value == "")
			{
				alert("<cf_get_lang_main no='531.Tarih Seçiniz!'>");
				return false;
			}
			if(document.getElementById("use_efatura").checked == false && document.getElementById("efatura_date").value != "")
			{
				alert("<cf_get_lang_main no='2313.E-fatura tarihi girilmiş ancak E-fatura checkboxı seçili değildir, Lütfen kontrol ediniz'>");
				return false;
			}
			if(document.getElementById('consumer_name').value=='')
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='219.Ad'>");
				return false;
			}
			if(document.getElementById('consumer_surname').value=='')
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1314.Soyad'>");
				return false;
			}
			// uye kategorisi gorunsun mu
			if(is_dsp_category == 1 && document.form_consumer.consumer_cat_id != undefined)
			{
				x = document.form_consumer.consumer_cat_id.selectedIndex;
				if (document.form_consumer.consumer_cat_id[x].value == "")
				{ 
					alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1197.Üye Kategorisi'>!");
					return false;
				}
			}
			<cfif xml_mobile_tel_required eq 1>
				if(document.getElementById('mobiltel').value=='')
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='116.Kod/ Mobil tel'>");
					return false;
				}
			</cfif>
			<cfif xml_only_numeric_password eq 1>
				if(isNaN(document.getElementById('consumer_password').value))
				{
					alert("<cf_get_lang no= '610.Lütfen Numeric Bir Şifre Değeri Giriniz'> !");
					return false;
				}
			</cfif>
			<cfif is_adres_detail eq 1>
			if((document.form_consumer.coordinate_1.value.length != "" && document.form_consumer.coordinate_2.value.length == "") || (document.form_consumer.coordinate_1.value.length == "" && document.form_consumer.coordinate_2.value.length != ""))
			{
				alert ("Lütfen koordinat değerlerini eksiksiz giriniz!");
				return false;
			}
			</cfif>
			
			<cfif isdefined("is_tc_number") and is_tc_number eq 1>
					var is_tc_number = 1;
			<cfelse>
				var is_tc_number = 0;
			</cfif>
			
			if(is_dsp_personal_info == 1 && is_tc_number == 1)
			{
				if(!isTCNUMBER(document.form_consumer.tc_identity_no)) return false;
			}
			
			// uye kategorisi gorunsun mu
			if(is_dsp_category == 1)
			{
				x = document.form_consumer.consumer_cat_id.selectedIndex;
				if (document.form_consumer.consumer_cat_id[x].value == "")
				{ 
					alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='298.Bireysel Üye Kategori'>");
					return false;
				}
			}
			
			//referans uye gosterilsin mi // zorunlu olsun mu
			if(is_dsp_reference_member == 1 && is_req_reference_member == 1 && document.form_consumer.ref_pos_code_name.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1224.Referans Üye'>!");
				document.getElementById('ref_pos_code_name').focus();				
				return false;
			}
			
			if(is_dsp_reference_member == 1)
			{
				if(<cfoutput>#session.ep.admin#</cfoutput> == 1 && document.form_consumer.ref_pos_code.value != '' && document.form_consumer.ref_pos_code_name.value == '')
				{
					if((document.form_consumer.ref_pos_code_row != undefined && document.form_consumer.ref_pos_code_row.value == '' && document.form_consumer.is_upper_member.checked == false) || document.form_consumer.ref_pos_code_row == undefined)
					{
						var get_consumer = wrk_safe_query('mr_get_consumer',"dsn",0,document.form_consumer.consumer_id.value);
						if(get_consumer.recordcount)
						{
							alert("<cf_get_lang no ='515.Referans Üye Bağlantısını Kopardınız! İlgili Üyenin Referans Olduğu Üyeler İçin Referans Bilgisi Girmelisiniz'> !");
							document.form_consumer.consumer_name.focus();
							document.getElementById('open_process').style.display ='';
							AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=member.emptypopup_add_reference_member','open_process',1);
							return false;
						}
					}
				}
				else if(<cfoutput>#session.ep.admin#</cfoutput> == 0 && document.form_consumer.ref_pos_code.value != '' && document.form_consumer.ref_pos_code_name.value == '')
					document.form_consumer.is_upper_ref.value = 1;
				if(<cfoutput>#session.ep.admin#</cfoutput> == 1 && document.form_consumer.hidden_reference_code.value != '' && document.form_consumer.reference_code.value != document.form_consumer.hidden_reference_code.value)
				{
					if((document.form_consumer.ref_pos_code_row != undefined && document.form_consumer.ref_pos_code_row.value == '' && document.form_consumer.is_upper_member != undefined && document.form_consumer.is_upper_member.checked == false && document.form_consumer.is_ref_member != undefined && document.form_consumer.is_ref_member.checked == false) || document.form_consumer.ref_pos_code_row == undefined)
					{
						var get_consumer = wrk_safe_query('mr_get_consumer',"dsn",0,document.form_consumer.consumer_id.value);
						if(get_consumer.recordcount)
						{
							alert("<cf_get_lang no ='514.Referans Üye Bağlantısını Değiştirdiniz! İlgili Üyenin Referans Olduğu Üyeler İçin Referans Bilgisi Girmelisiniz '>!");
							document.form_consumer.ref_pos_code_name.focus();
							document.getElementById('open_process').style.display ='';
							AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=member.emptypopup_add_reference_member&is_upd=1','open_process',1);
							return false;
						}
					}
				}
				else if(<cfoutput>#session.ep.admin#</cfoutput> == 1 && document.form_consumer.hidden_reference_code.value != '' && document.form_consumer.reference_code.value != document.form_consumer.hidden_reference_code.value)
					document.form_consumer.is_upper_ref.value = 1;
			}
			
			//fatura bilgileri zorunlu olsun mu
			if(is_invoice_info_detail == 1)
			{
				if(document.form_consumer.tax_office.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1350.vergi dairesi'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					document.getElementById('tax_office').focus();					
					return false;
				}
				if(document.form_consumer.tax_no.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='340.vergi no'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					document.getElementById('tax_no').focus();					
					return false;
				}
				if(document.form_consumer.tax_postcode.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='60.posta kodu'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					document.getElementById('tax_postcode').focus();					
					return false;
				}
				if(document.form_consumer.tax_country.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='807.ülke'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					return false;
				}
				
				if(document.form_consumer.tax_city_id.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='559.şehir'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					return false;
				}
				
				if(document.form_consumer.tax_county_id.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1226.ilçe'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					return false;
				}
				if(document.form_consumer.tax_semt.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='720.semt'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
					document.getElementById('tax_semt').focus();
					return false;
				}
				if(is_adres_detail == 0)
				{
					if(document.form_consumer.tax_address.value == "")
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='123.fatura adresi'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
						document.getElementById('tax_address').focus();						
						return false;
					}
				}
				else if(is_adres_detail == 1)
				{
					if((is_residence_select == 0 && document.form_consumer.tax_district.value == "") || (is_residence_select == 1 && document.form_consumer.tax_district_id.value == ""))
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1323.mahalle'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
						if(is_residence_select == 0)
						{
							document.getElementById('tax_district').focus();							
						}
						return false;
					}
					if(document.form_consumer.tax_main_street.value == "")
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='491.cadde'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
						document.getElementById('tax_main_street').focus();
						return false;
					}
					if(document.form_consumer.tax_street.value == "")
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='492.sokak'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
						document.getElementById('tax_street').focus();
						return false;
					}
					if(document.form_consumer.tax_door_no.value == "")
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='75.no'> (<cf_get_lang no ='521.Fatura Bilgileri İçin'>)!");
						document.getElementById('tax_door_no').focus();						
						return false;
					}
				}
			}
			//dogum tarihi zorunlu olsun mu (kisisel bilgiler varsa)
			if(is_dsp_personal_info == 1 && is_birthday == 1 && document.form_consumer.birthdate.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1315.Doğum Tarihi!'>!");
				document.getElementById('birthdate').focus();
				return false;
			}
			if(is_dsp_personal_info == 1 && (document.form_consumer.married.checked == false && document.form_consumer.married_date.value != ''))
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='375.Medeni Durumu'>!");
				document.getElementById('married_date').focus();
				return false;
			}
			
			//ev telefonu zorunlu olsun mu (kisisel bilgiler varsa)
			if(is_dsp_homeaddress_info == 1 && is_home_telephone == 1)
			{
				if(document.form_consumer.home_telcode.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='178.Telefon Kodu'>!");
					document.getElementById('home_telcode').focus();
					return false;
				}
				if(document.form_consumer.home_tel.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='1402.Telefon no'>!");
					document.getElementById('home_tel').focus();
					return false;
				}
			}
			
			if(is_cari_working == 1)
			{
				if(document.form_consumer.is_cari.checked == false)
				{
					alert("Çalışılabilir Alanı Seçili Olmalıdır !");
					return false;
				}
			}	
			
			if(document.form_consumer.work_address != undefined)
			{
				y = (75 - document.form_consumer.work_address.value.length);
				if ( y < 0 )
				{ 
					alert ("<cf_get_lang no='469.İş Adresi'><cf_get_lang_main no='798.Alanındaki Fazla Karakter Sayısı'>"+ ((-1) * y));
					return false;
				}
			}
			if(document.form_consumer.home_address != undefined)
			{
				z = (750 - document.form_consumer.home_address.value.length);
				if ( z < 0 )
				{ 
					alert ("<cf_get_lang no='468.Ev Adresi'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayısı'>"+ ((-1) * z));
					return false;
				}
			}
			if(document.form_consumer.tax_address != undefined)
			{
				v = (750 - document.form_consumer.tax_address.value.length);
				if ( v < 0 )
				{ 
					alert ("<cf_get_lang no='123.Fatura Adresi'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayısı'>"+ ((-1) * v));
					return false;
				}
			}
			// is_zone_info Dore firması icin eklendi BK 20101028
			<cfif session.ep.our_company_info.sales_zone_followup eq 1 and not isdefined("attributes.is_zone_info")>	
			if(document.form_consumer.sales_county!=undefined)
			{
				x = document.form_consumer.sales_county.selectedIndex;
				if (document.form_consumer.sales_county[x].value == "")
				{ 
					alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='247.Satış Bölgesi '>");
					return false;
				}
				if(document.form_consumer.ims_code_id.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='722.Micro Bölge Kodu'>");
					return false;
				}
				}
			</cfif>			
			if(is_dsp_photo == 1)
			{
				var obj =  document.form_consumer.picture.value;
				if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
				{
					alert("<cf_get_lang no='197.Lütfen bir resim dosyası(gif,jpg veya png) giriniz !'>");
					return false;
				}
				else if ((obj != "") && ((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
					document.all.upload_status.style.display = '';
			}
			<cfif xml_check_cell_phone eq 1>
				if(document.getElementById('mobilcat_id').value != "" && document.getElementById('mobiltel').value != "")
				{
					
					var listParam = document.getElementById('consumer_id').value + "*" +document.getElementById('mobilcat_id').value + "*" + document.getElementById('mobiltel').value;
					var get_results = wrk_safe_query('mr_upd_cell_phone',"dsn",0,listParam);
					if(get_results.recordcount>0)
					{
						  alert("Girdiginiz Cep Telefonuna Kayitli Baska Temsilci Bulunmaktadir!");
						  document.getElementById('mobiltel').focus();
						  return false;
					}              
				}
			</cfif>
			<cfif xml_use_efatura>
				document.getElementById('use_efatura').disabled = false;
			</cfif>
			if(process_cat_control())
				if(confirm("<cf_get_lang no='175.Girdiğiniz Bilgileri Kaydetmek Üzeresiniz, Lütfen Değişiklikleri Onaylayın'>!")) return true; else return false;
			else
				return false;
		}
		function kontrol_ref_member(type)
		{
			if(type == 0)
			{
				kontrol_inf = 0;
				if(document.form_consumer.consumer_id.value == document.form_consumer.ref_pos_code.value)
				{
					alert("<cf_get_lang no ='513.Üyeyi Kendisi İçin Referans Üye Olarak Ekleyemezsiniz'> !");
					kontrol_inf = 1;
				}
				if(kontrol_inf == 0)
				{
					var get_consumer = wrk_safe_query('mr_get_consumer',"dsn",0,document.form_consumer.ref_pos_code.value);
					if(get_consumer.recordcount)
					{	
						if(list_find(get_consumer.CONSUMER_REFERENCE_CODE[0],document.form_consumer.consumer_id.value,'.'))
						{
							alert("<cf_get_lang no ='512.Üyeyi Referans Olduğu Üyeye Bağlayamazsınız'> !");
							kontrol_inf = 1;
						}
					}
				}
				if(kontrol_inf == 1)
				{
					document.form_consumer.ref_pos_code.value = '';
					document.form_consumer.ref_pos_code_name.value = '';
					document.form_consumer.reference_code.value = '';
					document.form_consumer.dsp_reference_code.value = '';
				}
			}
			else
			{
				kontrol_ = 0;
				if(document.form_consumer.consumer_id.value == document.form_consumer.ref_pos_code_row.value)
				{
					alert("<cf_get_lang no ='513.Üyeyi Kendisi İçin Referans Üye Olarak Ekleyemezsiniz'> !");
					kontrol_ = 1;
				}
				if(kontrol_ == 0)
				{
					var get_consumer =  wrk_safe_query('mr_get_consumer',"dsn",0,document.form_consumer.ref_pos_code_row.value);								
					if(get_consumer.recordcount)
					{	
						if(list_find(get_consumer.CONSUMER_REFERENCE_CODE[0],document.form_consumer.consumer_id.value,'.'))
						{
							alert("<cf_get_lang no ='512.Üyeyi Referans Olduğu Üyeye Bağlayamazsınız'> !");
							kontrol_ = 1;
						}
					}
				}
				if(kontrol_ == 1)
				{
					document.form_consumer.ref_pos_code_row.value = '';
					document.form_consumer.ref_pos_code_name_row.value = '';
					document.form_consumer.reference_code_row.value = '';
					document.form_consumer.dsp_reference_code_row.value = '';
				}
			}	
		}
		
		function LoadPhone(x,y)
		{
			if(x != '')
			{
				get_phone_no = wrk_safe_query("mr_get_phone_no","dsn",0,x);
				if(get_phone_no.COUNTRY_PHONE_CODE != undefined && get_phone_no.COUNTRY_PHONE_CODE != '')
					document.getElementById('load_phone_'+y).innerHTML = '(' + get_phone_no.COUNTRY_PHONE_CODE + ')';
				else
					document.getElementById('load_phone_'+y).innerHTML = '';
			}
			else
				document.getElementById('load_phone_'+y).innerHTML = '';
		}
		function get_ims_code(type)
		{
			if(type == 1)
			{
				get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('home_district_id').value);
				get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('home_district_id').value);
				if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
				{		
					document.getElementById('home_semt').value=get_ims_code_.PART_NAME;
					document.getElementById('home_postcode').value=get_ims_code_.POST_CODE;
				}
				else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
				{
					document.getElementById('home_semt').value = get_district_.PART_NAME;
					document.getElementById('home_postcode').value = get_district_.POST_CODE;
				}
				else
				{
					document.getElementById('home_semt').value = '';
					document.getElementById('home_postcode').value = '';
				}
			}
			else if(type == 2)
			{
				get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('work_district_id').value);
				get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('work_district_id').value);
				if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
				{		
					document.getElementById('work_semt').value=get_ims_code_.PART_NAME;
					document.getElementById('work_postcode').value=get_ims_code_.POST_CODE;
				}
				else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
				{
					document.getElementById('work_semt').value = get_district_.PART_NAME;
					document.getElementById('work_postcode').value = get_district_.POST_CODE;
				}
				else
				{
					document.getElementById('work_semt').value = '';
					document.getElementById('work_postcode').value = '';
				}
			}
			else
			{
				get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('tax_district_id').value);
				get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('tax_district_id').value);
				if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
				{		
					document.getElementById('tax_semt').value=get_ims_code_.PART_NAME;
					document.getElementById('tax_postcode').value=get_ims_code_.POST_CODE;
				}
				else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
				{
					document.getElementById('tax_semt').value = get_district_.PART_NAME;
					document.getElementById('tax_postcode').value = get_district_.POST_CODE;
				}
				else
				{
					document.getElementById('tax_semt').value = '';
					document.getElementById('tax_postcode').value = '';
				}
			}
		}
		$( document ).ready(function() {
			form_consumer.consumer_name.focus();
		});
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'member.consumer_list';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'member/display/list_consumer.cfm';

	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'member.consumer_list';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'member/form/form_add_consumer.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'member/query/add_consumer.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'member.consumer_list&event=upd';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'member.consumer_list';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'member/form/form_upd_consumer.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'member/query/upd_consumer.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'member.consumer_list&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'cid=##attributes.cid##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.cid##';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'form_consumer';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_consumer';
	WOStruct['#attributes.fuseaction#']['upd']['recordQueryRecordEmp'] = 'record_member';
	WOStruct['#attributes.fuseaction#']['upd']['recordQueryIsConsumer'] = '1';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'add_kontrol()';
	if(session.ep.admin eq 1)
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	
	WOStruct['#attributes.fuseaction#']['det']['pageParams'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['pageParams']['size'] = '8-4;8';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'member/query/upd_consumer.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'member.consumer_list&event=det&cid=';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.cid##';

	if(not isdefined('attributes.formSubmittedController'))
	{
		// type'lar include,box,custom tag şekline dönüşecek.
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'member.consumer_list';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'member/display/list_consumer.cfm';
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'] = structNew();
		
		if(isdefined("attributes.event") and not (attributes.event is 'add' or attributes.event is 'list'))
		{
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['type'] = 0; // Include
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceController']  = 'ListConsumer.cfm';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceEvent']  = 'upd';
						
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['file'] = '#request.self#?fuseaction=member.upd_consumer_photo_ajax&cid=#attributes.cid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['id'] = 'photo';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['title'] = '#lang_array.item[105]#';	
			
			controlParam = 1;
			if(get_consumer.consumer_status is 1 and not(get_consumer.ispotantial is 1))
			{
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 1;//Custom Tag
				if(isdefined("attributes.cid"))
					WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_workcube_finance_summary action_id_2="##attributes.cid##" style="1">';
				else if( isdefined("attributes.cpid"))
					WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_workcube_finance_summary action_id="##attributes.cpid##" style="1">';
				controlParam = controlParam + 1;
			}
			if(is_dsp_member_team_right eq 1)
			{
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 1;//Custom Tag
				if(isdefined("attributes.cid"))
					WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_workcube_company_member_team action_id_2="#attributes.cid#" style="1">';
				else if(isdefined("attributes.cpid"))
					WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_workcube_company_member_team action_id_="#attributes.cpid#" style="1">';
				controlParam = controlParam + 1;
			}
			if(is_dsp_member_team_right eq 1)
			{
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 1;//Custom Tag
				if(isdefined("attributes.cid"))
					WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_workcube_member_branch action_id_2="#attributes.cid#" style="1">';
				else if(isdefined("attributes.cpid"))
					WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_workcube_member_branch action_id="#attributes.cpid#" style="1">';
				controlParam = controlParam + 1;
			}
			kontrol_cc_bank = 0;
			if((isdefined("is_credit_bank_kontrol") and is_credit_bank_kontrol eq 1) or not isdefined("is_credit_bank_kontrol"))
			{
				if(get_module_user(16))
					kontrol_cc_bank = 1;
			}
			else if(isdefined("is_credit_bank_kontrol") and is_credit_bank_kontrol eq 0)
				kontrol_cc_bank = 1;
			if(kontrol_cc_bank eq 1)
			{
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 1;
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_workcube_bank_account action_type="CONSUMER" action_id="##attributes.cid##">';
				controlParam = controlParam + 1;
				
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 1;
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_workcube_list_credit_cards action_id_2 ="##attributes.cid##" style="0" design="0">';
				controlParam = controlParam + 1;
			}
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 1;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_member_analysis action_type="MEMBER" consumer_id="##attributes.cid##">';
			controlParam = controlParam + 1;
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 1;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_workcube_domain action_type="CONSUMER" action_id="##attributes.cid##">';
			controlParam = controlParam + 1;
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '#request.self#?fuseaction=member.popupajax_related_associations&cid=#attributes.cid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['id'] = 'get_related';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['title'] = '#lang_array_main.item[1617]#';
			controlParam = controlParam + 1;
			
			if(is_dsp_card_no_info eq 1)
			{
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 1;
				if(isdefined("attributes.cid"))
					WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_workcube_list_customer_cards action_type="CONSUMER_ID" action_id="##attributes.cid##">';
				else if(isdefined("attributes.pid"))
					WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_workcube_list_customer_cards action_type="PARTNER_ID" action_id="##attributes.pid##">';	
				controlParam = controlParam + 1;
			}
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][0]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][0]['file'] = '#request.self#?fuseaction=member.emptypopup_ajax_list_consumer_contact&cid=#attributes.cid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][0]['id'] = 'list_consumer_contact';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][0]['title'] = '#lang_array.item[369]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][1]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][1]['file'] = '#request.self#?fuseaction=objects.emptypopup_ajax_member_relations&relation_info_id=#attributes.cid#&action_type_info=2';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][1]['id'] = 'list_member_rel';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][1]['title'] = '#lang_array.item[134]#';
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
			
			controlParam = 0;
			if (isdefined("xml_secret_question") and xml_secret_question eq 1)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array.item[137]#';//Gizli Soru
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=member.popup_member_secret_answer&consumer_id=#url.cid#','small','popup_member_secret_answer');";
				controlParam = controlParam + 1;
			}
			if (get_module_user(3) and fusebox.use_period)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array.item[489]#';//BSC Raporu
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=report.popup_bsc_company&member_type=consumer&consumer_id=#attributes.cid#&member_name=#consumer#','page_horizantal','popup_bsc_company')";
				controlParam = controlParam + 1;
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array_main.item[61]#';//Tarihçe
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=member.popup_member_history&member_type=consumer&member_id=#attributes.cid#','medium','popup_member_history')";
			controlParam = controlParam + 1;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array_main.item[345]#';//Uyarılar
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=member.detail_consumer&action_name=cid&action_id=#attributes.cid#','list','popup_page_warnings')";
			controlParam = controlParam + 1;
		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array_all.item[38321]#';//Proje Mailleri
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_mail_relation&relation_type=CONSUMER_ID&relation_type_id=#attributes.cid#','wide')";
			controlParam = controlParam + 1;
		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array_main.item[7]#';//Eğitim
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=member.popup_education_info&consumer_id=#attributes.cid#','small','popup_education_info')";
			controlParam = controlParam + 1;
		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array.item[371]#';//Hobi
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=member.popup_upd_consumer_hobbies&consumer_id=#attributes.cid#','small','popup_upd_consumer_hobbies')";
			controlParam = controlParam + 1;
		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array_main.item[495]#';//Yetkinlik
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=member.popup_upd_consumer_req_type&consumer_id=#attributes.cid#','small','popup_upd_consumer_req_type')";
			controlParam = controlParam + 1;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array.item[328]#';//Toplantılar
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=member.popup_list_con_agenda&consumer_id=#attributes.cid#','list','popup_list_con_agenda')";
			controlParam = controlParam + 1;
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array_main.item[535]#';//Anketler
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=member.popup_list_consumer_surveys&consumer_id=#url.cid#&consumer_cat_id=#get_consumer.consumer_cat_id#','list','popup_list_consumer_surveys')";
			controlParam = controlParam + 1;
				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array.item[82]#';//Muhasebe-Çalışma Dönemleri
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_consumer_periods&cpid=#url.cid#','list','popup_list_consumer_periods')";
			controlParam = controlParam + 1;
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array_main.item[264]#';//Teminatlar
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=member.popup_list_securefund&consumer_id=#url.cid#','list','popup_list_securefund')";
			controlParam = controlParam + 1;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array.item[68]#';//Kredi Durumu
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['href'] = "#request.self#?fuseaction=contract.detail_contract_company&consumer_id=#url.cid#";
			controlParam = controlParam + 1;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array_main.item[397]#';//Hesap Ektresi
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=ch.list_company_extre&member_type=consumer&member_id=#url.cid#','page','popup_list_comp_extre')";
			controlParam = controlParam + 1;
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array.item[372]#';//Diger Adres Ekle
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['href'] = "#request.self#?fuseaction=#fusebox.circuit#.add_consumer_contact&cid=#url.cid#";
			controlParam = controlParam + 1;
	
			if (get_module_user(11) and session.ep.our_company_info.subscription_contract eq 1)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array.item[382]#';//Sistemler
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=member.popup_list_subscription_contract&cid=#url.cid#&member_name=#get_consumer.consumer_name#&nbsp;#get_consumer.consumer_surname#','list','popup_list_subscription_contract')";
				controlParam = controlParam + 1;
			}
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array_main.item[163]#';//Üye Bilgileri
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['href'] = "#request.self#?fuseaction=myhome.my_consumer_details&cid=#attributes.cid#";
			controlParam = controlParam + 1;
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['text'] = '#lang_array.item[448]#';//Verdiği Eğitimler
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_training_trainer&consumer_id=#url.cid#','page','popup_training_trainer')";	
			controlParam = controlParam + 1;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=member.consumer_list&event=add','wide')";
/*			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['extra']['text'] = 'Oklar';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['extra']['customTag'] = '<cf_np tablename="consumer" primary_key="consumer_id" where="consumer_status=1" pointer="cid=#attributes.cid#">';
			*/
		}
	}

	
	if(isdefined("attributes.event") and attributes.event is 'info')
	{
		WOStruct['#attributes.fuseaction#']['info'] = structNew();
		WOStruct['#attributes.fuseaction#']['info']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['info']['fuseaction'] = 'member.consumer_list';
		WOStruct['#attributes.fuseaction#']['info']['filePath'] = 'myhome/display/my_consumer_details.cfm';
		WOStruct['#attributes.fuseaction#']['info']['Identity'] = '##attributes.cid##';
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['info'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['info']['menus'] = structNew();

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['info']['menus'][0]['text'] = '#lang_array_main.item[359]#';//Hesap Ekstresi
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['info']['menus'][0]['href'] = "#request.self#?fuseaction=member.consumer_list&event=upd&cid=#attributes.cid#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['info']['menus'][0]['target'] = '_blank';
				
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['info']['menus'][1]['text'] = '#lang_array_main.item[397]#';//Hesap Ekstresi
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['info']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=ch.list_company_extre&member_type=consumer&member_id=#attributes.cid#','page','popup_list_comp_extre');";
	}
	
	if(isdefined("attributes.event") and (attributes.event is 'info' or attributes.event is 'det'))
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	
	if(isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'det' or attributes.event is 'del'))       
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'member.list_it&event=upd&cid=#GET_CONSUMER.CONSUMER_ID#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'member/query/delete_consumer.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'member/query/delete_consumer.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'member.consumer_list';
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ListConsumer';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CONSUMER';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-consumer_code','item-consumer_name','item-consumer_surname','item-consumer_username','item-consumer_password']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
