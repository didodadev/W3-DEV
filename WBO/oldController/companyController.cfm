<cf_get_lang_set module_name="member">
<cfset process_cat = 24>
<cfif not IsDefined("attributes.event") or(IsDefined("attributes.event") and attributes.event eq 'list')>
    <cfsetting showdebugoutput="yes">
    <cf_xml_page_edit fuseact="member.list_company">
    <cfparam name="attributes.county_id" default="">
    <cfparam name="attributes.city_id" default="">
    <cfparam name="attributes.country_id" default="1">
    <cfparam name="attributes.sales_zones" default="">
    <cfparam name="attributes.sector_cat_id" default="">
    <cfparam name="attributes.comp_cat" default="">
    <cfparam name="attributes.pos_code_text" default="">
    <cfparam name="attributes.pos_code" default="">
    <cfparam name="attributes.is_sale_purchase" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.keyword_partner" default="">
    <cfparam name="attributes.mem_code" default="">
    <cfparam name="attributes.customer_value" default="">
    <cfparam name="attributes.search_potential" default="">
    <cfparam name="attributes.search_status" default="1">
    <cfparam name="attributes.period_id" default="">
    <cfparam name="attributes.cpid" default="">
    <cfparam name="attributes.record_emp" default="">
    <cfparam name="attributes.record_name" default="">
    <cfparam name="attributes.process_stage_type" default="">
    <cfparam name="attributes.company_status" default="">
    <cfparam name="attributes.use_efatura" default="">
    <cfparam name="attributes.tax_no" default="">
    <cfparam name="attributes.tc_identity" default="">
    <cfquery name="GET_SALES_ZONES" datasource="#DSN#">
        SELECT SZ_ID,#dsn#.Get_Dynamic_Language(SZ_ID,'#session.ep.language#','SALES_ZONES','SZ_NAME',null,null,SZ_NAME) AS SZ_NAME ,SZ_HIERARCHY+'_' SZ_HIERARCHY FROM SALES_ZONES ORDER BY SZ_NAME
    </cfquery>
    <cfquery name="GET_PERIOD" datasource="#DSN#">
        SELECT
            OUR_COMPANY.COMP_ID,
            OUR_COMPANY.COMPANY_NAME,
            SETUP_PERIOD.PERIOD_ID,
            SETUP_PERIOD.PERIOD
        FROM
            SETUP_PERIOD WITH (NOLOCK),
            OUR_COMPANY WITH (NOLOCK),
            EMPLOYEE_POSITION_PERIODS EPP WITH (NOLOCK)
        WHERE 
            EPP.PERIOD_ID = SETUP_PERIOD.PERIOD_ID AND
            EPP.POSITION_ID = (SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid# AND IS_MASTER = 1) AND
            SETUP_PERIOD.OUR_COMPANY_ID = OUR_COMPANY.COMP_ID 
        ORDER BY 
            OUR_COMPANY.COMPANY_NAME,
            SETUP_PERIOD.PERIOD_YEAR
    </cfquery>
    <cfquery name="GET_COMP" dbtype="query">
        SELECT DISTINCT COMP_ID,COMPANY_NAME FROM GET_PERIOD ORDER BY COMPANY_NAME
    </cfquery>
    <cfinclude template="../member/query/get_consumer_value.cfm">
    <cfquery name="GET_COMPANY_STAGE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR WITH (NOLOCK),
            PROCESS_TYPE_OUR_COMPANY PTO WITH (NOLOCK),
            PROCESS_TYPE PT WITH (NOLOCK)
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_list_company%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif isdefined("attributes.form_submitted")>
        <cfinclude template="../member/query/get_company_cat.cfm">
        <cfset company_cat_list = valuelist(get_companycat.companycat_id,',')>
        <cfquery name="GET_OURCMP_INFO" datasource="#DSN#">
            SELECT IS_STORE_FOLLOWUP FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
        <cfscript>
                get_company_list_action = CreateObject("component","member.cfc.get_company");
                get_company_list_action.dsn = dsn;
                get_company = get_company_list_action.get_company_list_fnc2(
                    cpid : '#iif(isdefined("attributes.cpid"),"attributes.cpid",DE(""))#',
                    module_name : 'member',
                    is_store_followup :'#iif(isdefined("get_ourcmp_info.is_store_followup"),"get_ourcmp_info.is_store_followup",DE(""))#' ,
                    row_block : '#iif((session.ep.our_company_info.sales_zone_followup eq 1),"500",DE(""))#',
                    period_id : '#iif(isdefined("attributes.period_id"),"attributes.period_id",DE(""))#' ,
                    responsible_branch_id : '#iif(isdefined("attributes.responsible_branch_id"),"attributes.responsible_branch_id",DE(""))#' ,
                    blacklist_status : '#iif(isdefined("attributes.blacklist_status"),"attributes.blacklist_status",DE(""))#' ,
                    get_companycat_recordcount : '#iif(isdefined("get_companycat.recordcount"),"get_companycat.recordcount",DE(""))#' ,
                    process_stage_type : '#iif(isdefined("attributes.process_stage_type"),"attributes.process_stage_type",DE(""))#' ,
                    record_emp : '#iif(isdefined("attributes.record_emp"),"attributes.record_emp",DE(""))#' ,
                    record_name : '#iif(isdefined("attributes.record_name"),"attributes.record_name",DE(""))#' ,
                    pos_code : '#iif(isdefined("attributes.pos_code"),"attributes.pos_code",DE(""))#' ,
                    pos_code_text : '#iif(isdefined("attributes.pos_code_text"),"attributes.pos_code_text",DE(""))#' ,
                    city :'#iif(isdefined("attributes.city"),"attributes.city",DE(""))#' ,
                    sales_zones :'#iif(isdefined("attributes.sales_zones"),"attributes.sales_zones",DE(""))#' ,
                    sector_cat_id : '#iif(isdefined("attributes.sector_cat_id"),"attributes.sector_cat_id",DE(""))#' ,				
                    search_potential: '#iif(isdefined("attributes.search_potential"),"attributes.search_potential",DE(""))#' ,
                    is_related_company: '#iif(isdefined("attributes.is_related_company"),"attributes.is_related_company",DE(""))#' ,
                    comp_cat: '#iif(isdefined("attributes.comp_cat"),"attributes.comp_cat",DE(""))#' ,
                    search_status: '#iif(isdefined("attributes.search_status"),"attributes.search_status",DE(""))#' ,
                    customer_value: '#iif(isdefined("attributes.customer_value"),"attributes.customer_value",DE(""))#' ,
                    country_id: '#iif(isdefined("attributes.country_id"),"attributes.country_id",DE(""))#' ,
                    city_id: '#iif(isdefined("attributes.city_id"),"attributes.city_id",DE(""))#' ,
                    county_id: '#iif(isdefined("attributes.county_id"),"attributes.county_id",DE(""))#' ,
                    keyword: '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#' ,
                    is_sale_purchase: '#iif(isdefined("attributes.is_sale_purchase"),"attributes.is_sale_purchase",DE(""))#',
                    keyword_partner: '#iif(isdefined("attributes.keyword_partner"),"attributes.keyword_partner",DE(""))#',
                    database_type: '#iif(isdefined("database_type"),"database_type",DE(""))#',
                    get_companycat_companycat_id : '#iif(isdefined("get_companycat.recordcount"),"valuelist(get_companycat.companycat_id,',')",DE(""))#',
                    maxrows: '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
                    startrow:'#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
                    is_fulltext_search: '#iif(isdefined("is_fulltext_search"),"is_fulltext_search",DE(""))#',
                    use_efatura: '#iif(len(attributes.use_efatura),"attributes.use_efatura",DE(""))#',
                    tax_no: '#iif(len(attributes.tax_no),"attributes.tax_no",DE(""))#',
                    tc_identity: '#iif(len(attributes.tc_identity),"attributes.tc_identity",DE(""))#'
                );
        </cfscript>
    <cfelse>
        <cfset get_company.recordcount = 0 >
    </cfif>
    <cfif get_company.recordcount>
        <cfparam name="attributes.totalrecords" default='#get_company.query_count#'>
    <cfelse>
        <cfparam name="attributes.totalrecords" default="0">
    </cfif>
<cfelseif IsDefined("attributes.event") and attributes.event eq 'add'>
	<!--- 
		Bu sayfanin aynisi Call Center modulu altinda bulunmaktadir. 
		Burada yapilan degisiklikler oraya da yansitilmalidir.
		BK 051026
	 --->
	 <cfquery name="GET_EINVOICE" datasource="#DSN#" maxrows="1">
		SELECT COMP_ID FROM OUR_COMPANY_INFO WHERE EINVOICE_TYPE = 1
	</cfquery>
	<cf_xml_page_edit fuseact="member.form_add_company" is_multi_page="1">
	<cfinclude template="../member/query/get_company_sector.cfm">
	<cfinclude template="../member/query/get_company_size.cfm">
	<cfinclude template="../member/query/get_country.cfm">
	<cfinclude template="../member/query/get_partner_positions.cfm">
	<cfinclude template="../member/query/get_partner_departments.cfm">
	<cfinclude template="../member/query/get_periods_all.cfm">
	<cfinclude template="../member/query/get_consumer_value.cfm">
	<cfinclude template="../member/query/get_member_add_options.cfm">
	<cfquery name="SZ" datasource="#DSN#">
		SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE = 1
	</cfquery>
<cfelseif IsDefined("attributes.event") and attributes.event eq 'det'>
	<cfif isdefined("get_company.manager_partner_id") and len(get_company.manager_partner_id)>
        <cfquery name="get_tc" dbtype="query">
            SELECT TC_IDENTITY
            FROM GET_PARTNER_
            WHERE PARTNER_ID = #get_company.manager_partner_id#
        </cfquery>
    </cfif>
</cfif>
<cfif isdefined("attributes.event") and not attributes.event is 'det'>
	<script type="text/javascript">
        <cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'list')>
            $(document).ready(function() {
                //document.getElementById('keyword').focus();
            });
        <cfelseif IsDefined("attributes.event") and attributes.event eq 'add'>
            <cfif not isdefined("attributes.city_id") or (isdefined("attributes.city_id") and not len(attributes.city_id))> <!--- CRM den Kurumsal üye ekle denildiğinde Sehir dolmuyordu --->
                $(document).ready(function() {
                    var country_ = document.form_add_company.country.value;
                    if(country_.length)
                        LoadCity(country_,'city_id','county_id',0);
                });
            </cfif>
            
            <cfif isdefined("attributes.city_id") and len(attributes.city_id)>
                $(document).ready(function() {
                    var city_ = document.form_add_company.city_id.value;
                    LoadCounty(city_,'county_id','telcod');
                });
            </cfif>
            
            function kontrol()
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
                document.getElementById('wrk_submit_button').disabled = true;
                if((document.form_add_company.coordinate_1.value.length != "" && document.form_add_company.coordinate_2.value.length == "") || (document.form_add_company.coordinate_1.value.length == "" && document.form_add_company.coordinate_2.value.length != ""))
                {
                    alert ("<cf_get_lang no='154.Lütfen koordinat değerlerini eksiksiz giriniz!'>");
                    document.getElementById('wrk_submit_button').disabled = false;
                    return false;
                }
                if(document.form_add_company.fullname.value == "")
                {
                    alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='159.Ünvan'>!");
                    form_add_company.fullname.focus();
                    document.getElementById('wrk_submit_button').disabled = false;
                    return false;
                }
                x = document.form_add_company.companycat_id.selectedIndex;
                if (document.form_add_company.companycat_id[x].value == "")
                { 
                    alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='131.Sirket Kategorisi '>!");
                    form_add_company.companycat_id.focus();
                    document.getElementById('wrk_submit_button').disabled = false;
                    return false;
                }
                if(document.form_add_company.nickname.value == "")
                {
                    alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='339.kisa Ad'>!");
                    form_add_company.nickname.focus();
                    document.getElementById('wrk_submit_button').disabled = false;
                    return false;
                }
                <cfif x_is_address eq 1>
                    if (document.getElementById("adres").value == "")
                    {
                        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1311.Adres'>");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                </cfif>
                <cfif is_code_telephone eq 1>
                    if(document.form_add_company.telcod.value == "")
                    {
                        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='178.Telefon Kodu'> !");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                    if(document.form_add_company.tel1.value == "")
                    {
                        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='87.Telefon'> !");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                </cfif>
                if(document.getElementById('name_').value == "")
                {
                    alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='166.yetkili '> <cf_get_lang_main no='485.adı '>!");
                    document.getElementById('name_').focus();
                    document.getElementById('wrk_submit_button').disabled = false;
                    return false;
                }
                if(document.form_add_company.soyad.value == "")
                {
                    alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='166.yetkili '> <cf_get_lang_main no='1138.soyadı '>!");
                    form_add_company.soyad.focus();
                    document.getElementById('wrk_submit_button').disabled = false;
                    return false;
                }
                <cfif session.ep.our_company_info.sales_zone_followup eq 1>	
                    x = document.form_add_company.sales_county.selectedIndex;
                    if(document.form_add_company.sales_county[x].value == "")
                    { 
                        alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='247.satış Bölgesi'>!");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                    if(document.form_add_company.ims_code_id.value == "")
                    {
                        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='722.Micro Bölge Kodu'>!");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }		
                </cfif>
                if(document.form_add_company.process_stage.value == "")
                {
                    alert("<cf_get_lang no='393.Lütfen Süreçlerinizi Tanımlayınız Yada Süreçler Üzerinde Yetkiniz Yok'>!");
                    document.getElementById('wrk_submit_button').disabled = false;
                    return false;
                }
                <cfif isDefined("is_vno_vd_required") and is_vno_vd_required eq 1>
                    if(document.getElementById('tc_identity').value == "" && (document.getElementById('taxoffice').value == "" || document.getElementById('taxno').value == ""))
                    {
                        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1350.Vergi Dairesi'> ve <cf_get_lang_main no='340.Vergi No'>, veya TC Kimlik No!");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;	
                    }
                </cfif>
                <cfif isdefined("attributes.type")>
                    if(document.form_add_company.glncode.value != '' && document.form_add_company.glncode.value.length != 13)
                    {
                        alert("<cf_get_lang no='155.GLN Kod Alanı 13 Hane Olmalıdır '>!");
                        document.form_add_company.glncode.focus();
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                
                    if(document.form_add_company.telcod.value == "")
                    {
                        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='178.Telefon Kodu'> !");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                    if(document.form_add_company.tel1.value == "")
                    {
                        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='87.Telefon'> !");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                    x = document.form_add_company.country.selectedIndex;
                    if (document.form_add_company.country[x].value == "")
                    { 
                        alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='807.Ülke'> !");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                    if(form_add_company.city_id.value == "")
                    {
                        alert("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='1196.il'>!");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                    if(form_add_company.county_id.value == "")
                    {
                        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1226.İlçe'>!");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                    if(form_add_company.semt.value == "")
                    {
                        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='720.Semt'>!");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                    if(form_add_company.semt.value == "")
                    {
                        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='720.Semt'>!");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                    if(form_add_company.ims_code_id.value == "")
                    {
                        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='722.Micro Bölge Kodu'>!");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                    if(form_add_company.ozel_kod.value == "")
                    {
                        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='17.Cari Hesap Kodu'>!");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                    else if(form_add_company.ozel_kod.value.length != 10)
                    {
                        alert("<cf_get_lang no='17.Cari Hesap Kodu'> <cf_get_lang no ='447. Alanı 10 Karakter Olmalıdır'>!");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                    if(form_add_company.ozel_kod_1.value == "")
                    {
                        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1399.muhasebe Kodu'>!");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                    else if(form_add_company.ozel_kod_1.value.length != 10)
                    {
                        alert("<cf_get_lang_main no='377.Özel Kod'><cf_get_lang no ='447. Alanı 10 Karakter Olmalıdır'>!");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                    if(form_add_company.title.value == "")
                    {
                        alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='159.ünvan'>-<cf_get_lang_main no='173.Kurumsal Üye'>!");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                            
                    if(document.form_add_company.companycat_id.value == 125) // 125 Hedefdeki Holding Urun Tedarikcisi kategorisi 
                    {
                        var GET_COMPANY = wrk_safe_query('mr_get_company','dsn',0,document.form_add_company.ozel_kod.value);
                        if(GET_COMPANY.recordcount)
            
                        {
                            alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no ='17.vergi No'> <cf_get_lang_main no='781.tekrarı'>!");
                            document.getElementById('wrk_submit_button').disabled = false;
                            return false;
                        }
                
                        var GET_COMPANY2 = wrk_safe_query('mr_get_company','dsn',0,document.form_add_company.taxno.value);
                        if(GET_COMPANY2.recordcount)
                        {
                            alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no='340.vergi No'> <cf_get_lang_main no='781.tekrarı'>!");
                            document.getElementById('wrk_submit_button').disabled = false;
                            return false;
                        }
                        
                    }
                    
                    form_add_company.action='<cfoutput>#request.self#?fuseaction=member.add_company_crm</cfoutput>';
                </cfif>	
                <cfif xml_show_product_cat eq 1>
                    select_all('product_category');
                </cfif>
                <cfif x_is_related_brands eq 1>
                    select_all('related_brand_id');
                </cfif>
                <cfif x_is_upper_sector eq 1>
                    select_all('upper_sector_cat');
                </cfif>
                <cfif get_einvoice.recordcount>
                    if(document.getElementById('country').value == 1 && document.getElementById('city_id').value == "")
                    {
                        alert("<cf_get_lang no='361.Lutfen Şehir Seciniz'> !");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }			
                    if(document.getElementById('country').value == 1 && document.getElementById('county_id').value == "")
                    {
                        alert("<cf_get_lang no='400.Lutfen İlce Seciniz'> !");
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                </cfif>	
                if(process_cat_control())
                {
                    if(confirm("<cf_get_lang no='175.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!123")) 
                    {
                        kontrol_prerecord();
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    } 
                    else 
                    {
                        document.getElementById('wrk_submit_button').disabled = false;
                        return false;
                    }
                }
                else 
                {
                    document.getElementById('wrk_submit_button').disabled = false;
                    return false;
                }
            }
            function kontrol_prerecord()
            {
                //Hedef icin eklendi
                var temp_fullname = form_add_company.fullname.value.replace(/'/g,"");
                var temp_nickname = form_add_company.nickname.value.replace(/'/g,"");
                <cfif isdefined("attributes.type")>
                    windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_company_prerecords&tax_num='+ encodeURIComponent(form_add_company.taxno.value) +'&fullname='+ encodeURIComponent(temp_fullname) +'&nickname=' + encodeURIComponent(temp_nickname) +'&name='+ encodeURIComponent(form_add_company.name.value) +'&surname='+ encodeURIComponent(form_add_company.soyad.value) +'&tel_code='+ form_add_company.telcod.value +'&telefon=' + form_add_company.tel1.value +'&type=1','project');
                <cfelseif fusebox.circuit eq 'store'>
                    windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_company_prerecords&is_store_module=1&tax_num='+ encodeURIComponent(form_add_company.taxno.value) +'&fullname='+ encodeURIComponent(temp_fullname) +'&nickname=' + encodeURIComponent(temp_nickname) +'&name='+ encodeURIComponent(form_add_company.name.value) +'&surname='+ encodeURIComponent(form_add_company.soyad.value) +'&tel_code='+ form_add_company.telcod.value +'&telefon=' + form_add_company.tel1.value,'project');
                <cfelse>
                    windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_company_prerecords&tax_num='+ encodeURIComponent(form_add_company.taxno.value) +'&fullname='+ encodeURIComponent(temp_fullname) +'&nickname=' + encodeURIComponent(temp_nickname) +'&name='+ encodeURIComponent(form_add_company.name.value) +'&surname='+ encodeURIComponent(form_add_company.soyad.value) +'&tel_code='+ form_add_company.telcod.value +'&telefon=' + form_add_company.tel1.value,'project');
                </cfif>
                return false;
            }
            function get_ims_code()
            {
                get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('district_id').value);
                get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('district_id').value);
                if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
                {		
                    document.getElementById('semt').value=get_ims_code_.PART_NAME;
                    document.getElementById('postcod').value=get_ims_code_.POST_CODE;
                }
                else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
                {
                    document.getElementById('semt').value = get_district_.PART_NAME;
                    document.getElementById('postcod').value = get_district_.POST_CODE;
                }
                else
                {
                    document.getElementById('semt').value = '';
                    document.getElementById('postcod').value = '';
                }
                <cfif x_district_address_required eq 1>
                    if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.IMS_CODE_ID!=undefined)
                    {
                        document.getElementById('ims_code_name').value = get_ims_code_.IMS_CODE;
                        document.getElementById('ims_code_id').value = get_ims_code_.IMS_CODE_ID;
                    }
                    else
                    {
                        document.getElementById('ims_code_name').value = '';
                        document.getElementById('ims_code_id').value = '';
                    }
                </cfif>
            }
            function select_all(selected_field)
            {
                var m = eval("document.form_add_company." + selected_field + ".length");
                for(i=0;i<m;i++)
                {
                    eval("document.form_add_company."+selected_field+"["+i+"].selected=true");
                }
            }
            function remove_field(field_option_name)
            {
                field_option_name_value = document.getElementById(field_option_name);
                for (i=field_option_name_value.options.length-1;i>-1;i--)
                {
                    if (field_option_name_value.options[i].selected==true)
                    {
                        field_option_name_value.options.remove(i);
                    }	
                }
            }
        <cfelseif IsDefined("attributes.event") and attributes.event eq 'det'>
                function LoadPhone(x)
                {
                    if(x != '')
                    {
                        get_phone_no = wrk_safe_query("mr_get_phone_no","dsn",0,x);
            
                        if(get_phone_no.COUNTRY_PHONE_CODE != undefined && get_phone_no.COUNTRY_PHONE_CODE != '')
                            document.getElementById('load_phone').innerHTML = '(' + get_phone_no.COUNTRY_PHONE_CODE + ')';
                        else
                            document.getElementById('load_phone').innerHTML = '';
                    }
                    else
                        document.getElementById('load_phone').innerHTML = '';
                }
                
                function get_ims_code()
                {
                    get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('district_id').value);
                    get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('district_id').value);
                    if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
                    {		
                        document.getElementById('semt').value=get_ims_code_.PART_NAME;
                        document.getElementById('company_postcode').value=get_ims_code_.POST_CODE;
                    }
                    else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
                    {
                        document.getElementById('semt').value = get_district_.PART_NAME;
                        document.getElementById('company_postcode').value = get_district_.POST_CODE;
                    }
                    else
                    {
                        document.getElementById('semt').value = '';
                        document.getElementById('company_postcode').value = '';
                    }
                    <cfif IsDefined("x_district_address_required") and x_district_address_required eq 1>
                        if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.IMS_CODE_ID!=undefined)
                        {
                            document.getElementById('ims_code_name').value = get_ims_code_.IMS_CODE;
                            document.getElementById('ims_code_id').value = get_ims_code_.IMS_CODE_ID;
                        }
                        else
                        {
                            document.getElementById('ims_code_name').value = '';
                            document.getElementById('ims_code_id').value = '';
                        }
                    </cfif>
                }
                
                function getTc()
                {			
                    var get_tc_identy = wrk_query("SELECT TC_IDENTITY FROM COMPANY_PARTNER WHERE PARTNER_ID = "+document.getElementById('manager_partner_id').value,"dsn");
                    if(get_tc_identy.TC_IDENTITY != undefined)
                    {
                        document.getElementById('tckimlikno').value = get_tc_identy.TC_IDENTITY;
                    }
                    else
                        document.getElementById('tckimlikno').value = '';
                }
        </cfif>
    </script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn;
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'member.form_list_company';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'member/form/form_add_company.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'member/query/add_company.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'member.form_list_company&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['model'] = 'modelCompany';

	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'form_add_company';
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'member.form_list_company';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'member/display/detail_company.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'member/query/upd_company.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'member.form_list_company&event=upd&cpid=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'cpid=##attributes.company_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.cpid##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_company';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'form_upd_company';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol()';
	
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'member.form_list_company';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'member/display/list_company.cfm';
	
	WOStruct['#attributes.fuseaction#']['det']['pageParams'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['pageParams']['size'] = '8-4;6-6';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'member/query/upd_company.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'member.form_list_company&event=det&cpid=';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.cpid##';
	
	
	if(not isdefined('attributes.formSubmittedController'))
	{
		// type'lar include,box,custom tag şekline dönüşecek.
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'member.form_list_company';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'member/display/detail_company.cfm';
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'] = structNew();
		
		if(isdefined("attributes.event") and not attributes.event is 'add')
		{
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['type'] = 0; // Include
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceController']  = 'companyController.cfm';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceEvent']  = 'upd';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['type'] = 1; // Custom Tag
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['file'] = '<cf_get_workcube_finance_summary action_id="##attributes.cpid##" style="1">';
		
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['type'] = 1;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['file'] = '<cf_get_workcube_member_branch action_id="##attributes.cpid##" style="1">';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['type'] = 1;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['file'] = '<cf_get_workcube_note action_section="COMPANY_ID" action_id="##attributes.cpid##" style="1">';
		
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['type'] = 1;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['file'] = '<cf_get_workcube_asset asset_cat_id="-9" module_id="4" action_section="COMPANY_ID" action_id="##attributes.cpid##">';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][4]['type'] = 1;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][4]['file'] = '<cf_get_workcube_content action_type ="COMPANY_ID" action_type_id ="##attributes.cpid##" style="0" design="0">';
		
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][5]['type'] = 1;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][5]['file'] = '<cf_get_workcube_bank_account action_type="COMPANY" action_id="##attributes.cpid##">';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][6]['type'] = 1;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][6]['file'] = '<cf_get_workcube_list_credit_cards action_id ="##attributes.cpid##" style="0" design="0">';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][7]['type'] = 1;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][7]['file'] = '<cf_workcube_social_media action_type="COMPANY_ID" action_type_id ="##attributes.cpid##">';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][8]['type'] = 2; // Ajax Page
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][8]['file'] = '#request.self#?fuseaction=objects.emptypopup_show_barcode_ajax&company_id=#attributes.cpid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][8]['id'] = 'workcube_barcode_info';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][8]['title'] = '#lang_array.item[1]#';
		
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][2]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][2]['file'] = '#request.self#?fuseaction=objects.emptypopup_show_barcode_geo&company_id=#attributes.cpid#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][2]['id'] = 'workcube_barcode_geo';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][2]['title'] = '#lang_array.item[173]#';
		
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][0]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][0]['file'] = '#request.self#?fuseaction=objects.emptypopup_ajax_member_relations&relation_info_id=#attributes.cpid#&action_type_info=1';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][0]['id'] = 'list_member_rel';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][0]['title'] = '#lang_array.item[37]#';	
		
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][1]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][1]['file'] = '#request.self#?fuseaction=member.popupajax_my_company_partners&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][1]['id'] = 'list_company_partner';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][1]['title'] = '#lang_array_main.item[1463]#';	
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][3][0]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][3][0]['file'] = '#request.self#?fuseaction=#fusebox.circuit#.popupajax_detail_company_address_branch&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][3][0]['id'] = 'detail_company_address_branch';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][3][0]['title'] = '#lang_array.item[54]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][3][1]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][3][1]['file'] = '#request.self#?fuseaction=member.popupajax_my_company_systems&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][3][1]['id'] = 'LIST_MY_COMPANY_SYSTEMS';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][3][1]['title'] = '#lang_array.item[124]#';
		
		}
		
		// Tab Menus //
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
		// Upd //
		if(isdefined("attributes.event") and (attributes.event is 'det' or attributes.event is 'upd'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = 'BSC';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=report.popup_bsc_company&member_type=partner&company_id=#attributes.cpid#&member_name=##GET_COMPANY.fullname##&finance=1&is_popup=1','page_horizantal','popup_bsc_company')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['text'] = '#lang_array_main.item[61]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=member.popup_member_history&member_type=company&member_id=#attributes.cpid#','medium','popup_member_history')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['text'] = '#lang_array_main.item[345]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=member.detail_company&action_name=cpid&action_id=#attributes.cpid#','list','popup_page_warnings')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][3]['text'] = '#lang_array_main.item[495]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=member.popup_upd_company_partner_req_type&cpid=#attributes.cpid#','small','popup_upd_company_partner_req_type')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][4]['text'] = '#lang_array_main.item[2191]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_mail_relation&relation_type=COMPANY_ID&relation_type_id=#attributes.cpid#','wide')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][5]['text'] = '#lang_array.item[328]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][5]['onClick'] = "windowopen('#request.self#?fuseaction=member.popup_list_comp_agenda&company_id=#attributes.cpid#&partner_id=1','list','popup_list_comp_agenda')";
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][6]['text'] = '#lang_array.item[448]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][6]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_training_trainer&company_id=#attributes.cpid#','list_horizantal','popup_training_trainer')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][7]['text'] = '#lang_array.item[293]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][7]['onClick'] = "windowopen('#request.self#?fuseaction=member.popup_member_schema&cpid=#attributes.cpid#','list','popup_member_schema')";
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=member.form_list_company&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['href'] = "#request.self#?fuseaction=member.form_list_company&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] = '#lang_array_main.item[62]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=dev.popup_fuseaction_history','medium','popup_fuseaction_history')";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'companyController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'COMPANY';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-fullname','item-company_code','item-companycat_id','item-name_','item-soyad']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>