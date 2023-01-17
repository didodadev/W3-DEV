<cfsetting enablecfoutputonly="no"><cfprocessingdirective suppresswhitespace="Yes">
<!---
Description :

Parameters :
	* cancel_info,insert_info,delete_info,cancel_alert,insert_alert,delete_alert,delete_page_url
	* is_upd=1:sayfanin güncelleme sayfasi oldugunu gosteriyor, '0' sa veya tanimli degilse ekle sayfasini gosteriyor.
	* delete_page_url yazılmazsa http://server/ a gider..
	* _info veya _alert degisken degerleri set edilmek istenirse parametre adi customtag ile birlikte özel olarak set edilebilir.
	* sil butonlari sadece guncelle sayfalarinde cikar..
	* eger bir ekleme veya guncelleme sayfasinda form validation i haric alert gormek istenmiyorsa insert_alert = '' demek yeterlidir
	  bunu denmezse default olarak surekli alert eder..
	* is_delete parametresiyse '0' olarak set edilirse kim olursa olsun sil butonunu gostermez..
	* is_cancel parametresiyse '0' olarak set edilirse vazgeç butonunu gostermez..
	* is_reset parametresiyse '0' olarak set edilirse temizle butonunu gostermez..
	* is_insert parametresiyse '0' olarak set edilirse kim olursa olsun ekle/güncelle butonunu gostermez..
    * is_authority_passive parametresi '1' olarak set edilirse yetki kontrolü yapılmaksızın güncelleme butonu gösterilir...
	* add_function ekle veya guncelle butonlarina ek bir function/functions yazmak istersek
	* del_function sil butonuna ek bir function/functions yazmak istersek
	* del_function_for_submit sil butonuna ek bir function yazarak istenen durumda submit edilip edilmemesini saglamak istersek
	* history_table_list: Historysi alınacak tablo isimleri ',' ile ayrılarak yazılır.
	* history_datasource_list: Historysi alınacak tabloların datasoruceları ',' ile ayrılarak yazılır.
	* history_identy:İlgili tablodaki identy alanın adıa
	* history_action_id:Historysi alınacak kaydın Id si
Syntax :
	<cfsavecontent variable="cancel_info"><cf_get_lang_main no=50.Vazgeç></cfsavecontent>
	<cfsave....</cfsavecontent>
	<cf_wrk_buttons
		zone='ep'
		cancel_info = '#cancel_info#'
		update_status = '#a_query.a_bit#' ; degeri 0 iken ilgili kayit ne guncellenebilir ne de silinebilir (muhasebe tarafinda birlestirilmiş fisler sebebiyle tum finans islemleri dondurulur)
		insert_info = ''
		delete_info = ''
		cancel_alert = ''
		insert_alert = ''
		delete_alert = ''
		delete_page_url = '#request.self#?fuseaction=modul.faction'
		is_upd='1'
		is_delete='1'
		is_cancel='1'
		is_reset='1'
		is_insert='1'
		is_disable='0'
        is_authority_passive='0'
		add_function='some_jscript_function()'
		del_function='some_jscript_function()'
		del_function_for_submit='some_jscript_function()'
		cancel_function='some_jscript_function()'
		history_table_list=''
		history_datasource_list=''
		history_identy=''
		history_action_id=''
		>

	created 20030617
	modified 20030621-20030625-EK20030626-20030802-EK20030811-20031107-20040110-20040607-YO20040917-20040607-20050313
	(YO20040917 is_disable diye yeni bir parametre eklenerek submit edildikten sonra butonun disable olup olmaması olayı parametreye bağlandı...default değeri 1 yani disable oluyor.)
	modified 20090709 SM History ekleme fonksiyonu eklendi.
		history_table_list=''
		history_datasource_list=''
		history_identy=''
		history_action_id=''
	parametreleri kullanılarak güncelleme işlemi yapılmadan önce verilen tablonun history tablosuna kayıt atıyor.
--->
<!---right=1 ise buton sağda gözükür. 0 olursa buton solda gözükür--->
<cfset btn_rnd_id = "#round(rand()*10000000)#">
<cfparam name="attributes.type_format" default=0 type="boolean">
<cfparam name="attributes.right" default="1">
<div id="workcube_button" class="<cfif attributes.right eq 1>pull-right<cfelse>pull-left</cfif>" data-btn-id="<cfoutput>#btn_rnd_id#</cfoutput>">
<cfparam name="attributes.is_disable" default=1>
<cfparam name="attributes.update_status" default=1>
<cfparam name="attributes.is_upd" default=0>
<cfparam name="attributes.is_cancel" default=0>
<cfparam name="attributes.is_reset" default=0>
<cfparam name="attributes.is_authority_passive" default=0>
<cfparam name="attributes.is_delete" default=1>
<cfparam name="attributes.is_insert" default=1>
<cfparam name="attributes.del_function" default="">
<cfparam name="attributes.del_function_for_submit" default="">
<cfparam name="attributes.add_function" default="">
<cfparam name="attributes.cancel_info" default="#caller.getLang('main',50)#"> <!--- Vazgeç --->
<cfparam name="attributes.cancel_alert" default="#caller.getLang('main',122)#"> <!--- Sayfadan Çıkıyorsunuz Emin Misiniz? --->
<cfparam name="attributes.reset_info" default="#caller.getLang('main',522)#"> <!--- Temizle --->
<cfparam name="attributes.delete_page_url" default="">
<cfparam name="attributes.history_table_list" default="">
<cfparam name="attributes.history_datasource_list" default="">
<cfparam name="attributes.history_identy" default="">
<cfparam name="attributes.history_action_id" default="">
<cfparam name="attributes.is_wrkId" default="">
<cfparam name="attributes.history_act_type" default="">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.no_show_process" default=0>
<cfparam name="attributes.excel_input" default="">
<cfparam name="attributes.form_name" default="">
<cfparam name="attributes.post_form_name" default="">
<cfparam name="attributes.processCatControl" default="false">

<cfparam name="attributes.extraButton" default="">
<cfparam name="attributes.extraButtonText" default=""><!--- Ekstra eklenen butonun içerisindeki yazı --->
<cfparam name="attributes.extraAlert" default="">
<cfparam name="attributes.extraFunction" default="">
<cfparam name="attributes.extraInfo" default=""><!--- Butonlardan bağımsız olarak butonun yanında yazan yazı --->
<cfparam name="attributes.extraButtonClass" default="">

<!-- Formun yönlendirileceği hedef cfc ve next event eklendi İlkerA  -->
<cfparam name="attributes.data_action" default=""> <!--- ? cfc_path : method ->  /V16/sale/cfc/orders.cfc:add_event  --->
<cfparam name="attributes.next_page" default=""> <!--- ? next page : "/event=upd&id=" --->
<cfparam name="attributes.del_action" default=""> <!--- ? cfc_path : method ->  /V16/sale/cfc/orders.cfc:add_event  --->
<cfparam name="attributes.del_next_page" default=""> <!--- ? next page : "sales.list_order" --->
<cfparam name="attributes.after_function" default=""> <!--- ? post işleminden sonra response ile beraber çalıştırılacak function --->

<cfif not len(attributes.extraButtonText)>
	<cfset attributes.extraButtonText = caller.getLang('main',2638)>
</cfif>
<cfif not isdefined("caller.module_name")>
    <cfset caller.module_name = "objects">
</cfif>
<cfif len(attributes.excel_input) and len(attributes.form_name)>
	<iframe src="" width="0" height="0" name="is_auto_excel_iframe" id="is_auto_excel_iframe" style="display:none;"></iframe>
</cfif>

<cfset Randomize(round(rand()*1000000))/>
<cfset id_count_ = round(rand()*10000000)>
<cfif len(attributes.delete_page_url)>
	<cfset attributes.delete_page_url = replace(attributes.delete_page_url,"'","","all")>
</cfif><!--- tirnakli gelen degerler sorun yapmasin diye buraya replace konuldu YO27020207--->

<cfscript>
	if (attributes.is_upd)
		{
		if (not isDefined('attributes.insert_info')) attributes.insert_info = caller.getLang('main',52);//Güncelle
		if (not (isDefined('attributes.insert_alert') and len(attributes.insert_alert))) attributes.insert_alert = caller.getLang('main',124);//Güncellemek İstediğinizden Emin misiniz?
		data_gate_submit="upd";
		}
	else
		{
		if (not isDefined('attributes.insert_info')) attributes.insert_info = caller.getLang('main',49);//Kaydet
		if (not (isDefined('attributes.insert_alert') and len(attributes.insert_alert))) attributes.insert_alert = caller.getLang('main',123);//Kaydetmek İstediğinizden Emin Misiniz?
		data_gate_submit="add";
		}
	if(attributes.is_delete)
	{
		if (not isDefined('attributes.delete_info')) attributes.delete_info = caller.getLang('main',51);//Sil
		if (not isDefined('attributes.delete_alert')) attributes.delete_alert = caller.getLang('main',121);//Silmek İstediğinizden Emin Misiniz?	
	}
	if(not isdefined("attributes.delete_info"))
		attributes.delete_info = caller.getLang('main',51);
</cfscript>

<cfif (isdefined("cgi.HTTP_REFERER") and cgi.HTTP_REFERER contains 'emptypopup') or isdefined("caller.attributes.nogoback")>
	<cfset attributes.is_cancel = 0>
</cfif>

<cfset attributes.warning_id = ( IsDefined("caller.attributes.wrkflow") and caller.attributes.wrkflow eq 1 and StructKeyExists( application.deniedPages, caller.attributes.fuseaction ) and StructKeyExists(application.deniedPages[caller.attributes.fuseaction], "WARNING_ID") )
									? application.deniedPages[caller.attributes.fuseaction].WARNING_ID : "" />

<cftry>
	<cfif caller.is_only_show_page eq 0>
        <cfif attributes.update_status is not 0>
            <cfif caller.workcube_mode><!--- sadece development modda 20 dak bir get_buttons query calissin --->
                <cfset caller.get_buttons_cached_time = CreateTimeSpan(0,2,0,0)>
            <cfelse>
                <cfset caller.get_buttons_cached_time = CreateTimeSpan(0,0,0,0)>
            </cfif>
            <cfif isdefined("caller.get_denied_page_cached_time")>
                <cfset caller.get_denied_page_cached_time = caller.get_denied_page_cached_time>
            <cfelse>
                <cfset caller.get_denied_page_cached_time = 0>
            </cfif>
            <cfif isdefined("session.ep.userid") and len(session.ep.userid)>         
                <cfquery name="GET_EMP_IZINLI_BUTTONS" datasource="#CALLER.DSN#" cachedwithin="#caller.get_denied_page_cached_time#">
                    SELECT
                        ED.DENIED_PAGE,
                        ED.IS_INSERT
                    FROM
                        EMPLOYEE_POSITIONS_DENIED ED,
                        EMPLOYEE_POSITIONS E
                    WHERE
                        (ED.IS_INSERT = 1) AND
                        ED.DENIED_TYPE = 1 AND
                        ED.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#caller.get_module_id(caller.module_name)#"> AND
                        ED.DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#caller.attributes.fuseaction#"> AND
                        ED.DENIED_PAGE NOT IN
                        (
                            SELECT
                                DENIED_PAGE
                            FROM
                                EMPLOYEE_POSITIONS_DENIED EPD,
                                EMPLOYEE_POSITIONS EP
                            WHERE
                                (EPD.IS_INSERT = 1) AND
                                EPD.DENIED_TYPE = 1 AND
                                EPD.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#caller.get_module_id(caller.module_name)#"> AND
                                EPD.DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#caller.attributes.fuseaction#"> AND
                                EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
                                (
                                    EPD.POSITION_CODE = EP.POSITION_CODE OR
                                    EPD.POSITION_CAT_ID = EP.POSITION_CAT_ID OR
                                    EPD.USER_GROUP_ID = EP.USER_GROUP_ID
                                )
                        )
					<cfif isdefined("caller.WOStruct") and isdefined("caller.attributes.event")>
                        UNION 
                        SELECT
                            U.OBJECT_NAME AS DENIED_PAGE,
                            <cfif caller.attributes.event contains 'add'>ADD_OBJECT<cfelseif caller.attributes.event contains 'upd' or caller.attributes.event contains 'det'>UPDATE_OBJECT<cfelse>0</cfif> AS IS_INSERT
                        FROM
                            EMPLOYEE_POSITIONS AS E
                            LEFT JOIN USER_GROUP_OBJECT AS U ON E.USER_GROUP_ID = U.USER_GROUP_ID
                        WHERE
                            E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                            AND U.OBJECT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#caller.attributes.fuseaction#">
                    </cfif>
                </cfquery>
                <cfquery name="GET_EMP_DEL_BUTTONS" datasource="#CALLER.DSN#" cachedwithin="#caller.get_denied_page_cached_time#">
                    SELECT
                        ED.DENIED_PAGE,
                        ED.IS_DELETE
                    FROM
                        EMPLOYEE_POSITIONS_DENIED ED,
                        EMPLOYEE_POSITIONS E
                    WHERE
                        (ED.IS_DELETE = 1) AND
                        ED.DENIED_TYPE = 1 AND
                        ED.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#caller.get_module_id(caller.module_name)#"> AND
                        ED.DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#caller.attributes.fuseaction#"> AND
                        ED.DENIED_PAGE NOT IN
                        (
                            SELECT
                                DENIED_PAGE
                            FROM
                                EMPLOYEE_POSITIONS_DENIED EPD,
                                EMPLOYEE_POSITIONS EP
                            WHERE
                                (EPD.IS_DELETE = 1) AND
                                EPD.DENIED_TYPE = 1 AND
                                EPD.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#caller.get_module_id(caller.module_name)#"> AND
                                EPD.DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#caller.attributes.fuseaction#"> AND
                                EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
                                (
                                    EPD.POSITION_CODE = EP.POSITION_CODE OR
                                    EPD.POSITION_CAT_ID = EP.POSITION_CAT_ID OR
                                    EPD.USER_GROUP_ID = EP.USER_GROUP_ID
                                )
                        )
					<cfif isdefined("caller.WOStruct") and isdefined("caller.attributes.event")>
                        UNION 
                        SELECT
                            U.OBJECT_NAME AS DENIED_PAGE,
                            DELETE_OBJECT AS IS_DELETE
                        FROM
                            EMPLOYEE_POSITIONS AS E
                            LEFT JOIN USER_GROUP_OBJECT AS U ON E.USER_GROUP_ID = U.USER_GROUP_ID
                        WHERE
                            E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                            AND U.OBJECT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#caller.attributes.fuseaction#">
                    </cfif>
                </cfquery>

                <cfscript>
                    if(isDefined('get_emp_izinli_buttons') and get_emp_izinli_buttons.recordcount)
					{
						if(attributes.is_insert)
							{
								if (caller.database_type is 'MSSQL' and listfind(valuelist(get_emp_izinli_buttons.is_insert),true))
									attributes.is_insert = 0;
								else if (caller.database_type is 'DB2' and listfind(valuelist(get_emp_izinli_buttons.is_insert),1))
									attributes.is_insert = 0;
								else
									attributes.is_insert = 1;
							}
						else
							attributes.is_insert = 0;
					}

                    if(isDefined('get_emp_del_buttons') and get_emp_del_buttons.recordcount)
					{
						if(attributes.is_delete)
							{
								if (caller.database_type is 'MSSQL' and listfind(valuelist(get_emp_del_buttons.is_delete),true))
									attributes.is_delete = 0;
								else if (caller.database_type is 'DB2' and listfind(valuelist(get_emp_del_buttons.is_delete),1))
									attributes.is_delete = 0;
								else
									attributes.is_delete = 1;
							}
						else
							attributes.is_delete = 0;
					}
                //wrk_not:bu kismin alti da cfscript icine alinacak..
                </cfscript>
                <cfif not get_emp_izinli_buttons.recordcount>
                    <cfquery name="GET_BUTTONS" datasource="#CALLER.DSN#" cachedwithin="#caller.get_buttons_cached_time#">
                        SELECT
                            EPD.IS_DELETE,
                            EPD.IS_INSERT,
                            EPD.DENIED_PAGE
                        FROM
                            EMPLOYEE_POSITIONS_DENIED AS EPD,
                            EMPLOYEE_POSITIONS AS EP
                        WHERE
                            EPD.DENIED_TYPE <> 1 AND
                            EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
                            EPD.DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#caller.attributes.fuseaction#"> AND
                            (
                                EPD.POSITION_CODE = EP.POSITION_CODE OR
                                EPD.POSITION_CAT_ID = EP.POSITION_CAT_ID OR
                                EPD.USER_GROUP_ID = EP.USER_GROUP_ID
                            )
                    </cfquery>
                </cfif>
            <cfelseif isdefined("session.pp.userid") and len(session.pp.userid)>
                <cfquery name="GET_BUTTONS" datasource="#CALLER.DSN#" cachedwithin="#caller.get_buttons_cached_time#">
                    SELECT
                        CPD.IS_DELETE,
                        CPD.IS_INSERT,
                        CPD.DENIED_PAGE
                    FROM
                        COMPANY_PARTNER_DENIED AS CPD
                    WHERE
                        CPD.PARTNER_ID = #session.pp.userid# AND
                        CPD.DENIED_PAGE = '#caller.attributes.fuseaction#'
                </cfquery>
            </cfif>
        </cfif>
		<cfif isdefined("caller.WOStruct")>
        	<cfif isdefined("caller.attributes.event")>
        		<cfset 'caller.woStruct#id_count_#' = caller.woStruct>
                
				<cfset delFuseaction = structNew()>
                <cfset delFuseactionExtraParams = structNew()>
                <cfset eventList = StructKeyList(caller.WOStruct['#caller.attributes.fuseaction#'])>
                <cfloop index="item" from="1" to="#listlen(eventList,',')#">
                    <cfif isStruct(caller.WOStruct['#caller.attributes.fuseaction#'][listgetat(eventList,item,',')])>
                        <cfif not listFindNoCase('print,pageParams,pageObjects,systemObject,extendedForm,det',listgetat(eventList,item,','))>
                            <cfset delFuseaction[listgetat(eventList,item,',')]['fuseaction'] = evaluate(de(caller.WOStruct['#caller.attributes.fuseaction#'][listgetat(eventList,item,',')]['fuseaction']))>	
                            <cfif StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#'][listgetat(eventList,item,',')],'extraParams')>
                                <cfset delFuseactionExtraParams[listgetat(eventList,item,',')]['extraParams'] = caller.WOStruct['#caller.attributes.fuseaction#'][listgetat(eventList,item,',')]['extraParams']>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfloop>
                <cfset delFuseaction = SerializeJSON(delFuseaction)>
                <cfset delFuseactionExtraParams = SerializeJSON(delFuseactionExtraParams)>
                <cfif left(delFuseaction, 2) is "//"><cfset delFuseaction = mid(delFuseaction, 3, len(delFuseaction) - 2)></cfif>
                <cfif left(delFuseactionExtraParams, 2) is "//"><cfset delFuseactionExtraParams = mid(delFuseactionExtraParams, 3, len(delFuseactionExtraParams) - 2)></cfif>
                <cfset delFuseaction = URLEncodedFormat(delFuseaction, "utf-8")>
                <cfset delFuseactionExtraParams = URLEncodedFormat(delFuseactionExtraParams, "utf-8")>
                
            </cfif>
        </cfif>
        
        <cfscript>
            if(isDefined('get_buttons') and get_buttons.recordcount)
			{
				if(attributes.is_delete)
				{
					if (caller.database_type is 'MSSQL')
						is_delete = listfind(valuelist(get_buttons.is_delete),true);//0:kullanici sil butonunu kullanabilir
					else if (caller.database_type is 'DB2')
						is_delete = listfind(valuelist(get_buttons.is_delete),1);//0:kullanici sil butonunu kullanabilir
				}
				else
					is_delete = 1;
				if(attributes.is_insert)
				{
					if (caller.database_type is 'MSSQL')
						is_insert = listfind(valuelist(get_buttons.is_insert),true);//0:kullanici kaydet/guncelle butonunu kullanabilir
					else if (caller.database_type is 'DB2')
						is_insert = listfind(valuelist(get_buttons.is_insert),1);//0:kullanici kaydet/guncelle butonunu kullanabilir
				}
				else
					is_insert = 0;
			}

			if( attributes.is_insert eq 0 ){
				attributes.is_insert = ( IsDefined("caller.attributes.wrkflow") and caller.attributes.wrkflow eq 1 and StructKeyExists( application.deniedPages, caller.attributes.fuseaction ) and StructKeyExists(application.deniedPages[caller.attributes.fuseaction], "IS_CHECKER_UPDATE_AUTHORITY") ) 
				? application.deniedPages[caller.attributes.fuseaction].IS_CHECKER_UPDATE_AUTHORITY : 0;
			}

        //wrk_not:bu kismin alti da cfscript icine alinacak..
        </cfscript>
		
        <!--- buton kombinasyonu --->
        <script type="text/javascript">
            var obj;
            /* 20050523 CFMX7 geciste cf in kendi degiskenini kullaniyoruz
            var _CF_ERROR = 0; */
            var _CF_error_exists = false;
			var login_pass = 1;
			function sessionControl()
			{
				<cfif listfindnocase(caller.employee_url,'#cgi.http_host#',';')>
					$.ajax( {
						url:"index.cfm?fuseaction=home.emptypopup_check_session",
						type: "get",
						data: null,
						async:false,
						processData: false,
						contentType: false,
						success: function(responseData, status, jqXHR)
						{ 
							donus_ = $.trim(responseData);
							if(donus_ == 0 || donus_ == '0')
							{
								login_pass = 0;
							}
							else
							{
								login_pass = 1;
							}
						}
					} );
					
					if(login_pass == 0)
					{
						alert('<cf_get_lang dictionary_id="59049.Oturum Bulunamadı">');
						window.open('index.cfm?fuseaction=home.login','blank');
						return false;
					}
					else
					{
						return true;
					}
				<cfelse>
					return true;
				</cfif>
			}
			
			function validateControl()
			{
				return validate().check();
			}
            function waitForDisableAction<cfoutput>#id_count_#</cfoutput>(el)
            {	
				<cfif not len(attributes.data_action) and not len(attributes.del_action)>		
					if(login_pass == 0)
					{
						alert('<cfoutput>#caller.getLang('main',126)#</cfoutput>');
						return false;
					}
					
					obj = el;
					<cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>
						<cfif attributes.is_disable eq 1>
							setTimeout("disableAction()",10);
						</cfif>
						<cfif attributes.processCatControl is true>
							if(window['_CF_check'+$($(obj).closest('form')[0]).attr("id")] != undefined)
								return(window['_CF_check'+$($(obj).closest('form')[0]).attr("id")](this) && process_cat_control() && spaSubmit<cfoutput>#id_count_#</cfoutput>(obj)); //
							else
								return(process_cat_control() && spaSubmit<cfoutput>#id_count_#</cfoutput>(obj)); //
						<cfelse>
							if(window['_CF_check'+$($(obj).closest('form')[0]).attr("id")] != undefined)
								return (window['_CF_check'+$($(obj).closest('form')[0]).attr("id")](this) && spaSubmit<cfoutput>#id_count_#</cfoutput>(obj)); // 
							else
								return (spaSubmit<cfoutput>#id_count_#</cfoutput>(obj)); // 
						</cfif>
					<cfelse>
						<cfif len(attributes.excel_input) and len(attributes.form_name)>
							if(eval("document.getElementById('<cfoutput>#attributes.excel_input#</cfoutput>').checked")== true)
							{
								eval("document.<cfoutput>#attributes.form_name#</cfoutput>").target = 'is_auto_excel_iframe';
								return true;
							}
							else
								eval("document.<cfoutput>#attributes.form_name#</cfoutput>").target ='';
						</cfif>
						<cfif attributes.is_disable eq 1>
							setTimeout("disableAction()",10);
						<cfelse>
							<cfif attributes.is_upd eq 1 and listlen(attributes.history_table_list) and listlen(attributes.history_datasource_list) and len(attributes.history_identy) and len(attributes.history_action_id)>
								AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_add_history&dsn3=#caller.dsn3#&dsn=#caller.dsn#&dsn2=#caller.dsn2#&dsn1=#caller.dsn1#&is_wrkId=#attributes.is_wrkId#&history_act_type=#attributes.history_act_type#&history_identy=#attributes.history_identy#&history_action_id=#attributes.history_action_id#&history_table_list=#attributes.history_table_list#&history_datasource_list=#attributes.history_datasource_list#</cfoutput>','ADD_TABLE_HISTORY',1);
							</cfif>
						</cfif>
						if(arguments[1] != 1)
						{
							formId = $($(obj).closest('form')[0]).attr("id");
							$("#"+formId).find('input,select,textarea').each(function(index,element){
									if($(element).attr('disabledElement'))
										$(element).prop('disabled',false);
								});
							<cfif isdefined("attributes.post_form_name") and len(attributes.post_form_name)>
								$("#<cfoutput>#attributes.post_form_name#</cfoutput>").submit();
							<cfelse>
								$(obj).closest('form')[0].submit();
							</cfif>
						}
						return false;
					</cfif>
				</cfif>
            }
            function div_goster()
            {
                get_wrk_message_div("<cfoutput>#caller.getLang('main',1932)#</cfoutput>","<cfoutput>#caller.getLang('main',1933)#</cfoutput>");<!--- İşleminiz yapılıyor lütfen bekleyiniz --->
            }
            function disableAction(type)//type sadece ajax sayfa içinde çağırılı amacı: Ajax'lı bloğa tekrar tekrar girmesin...
            {
                
                if(!_CF_error_exists)
                {
                    <cfif attributes.no_show_process neq 1>
                    obj.value="<cfoutput>#caller.getLang('main',293)#</cfoutput>"; <!--- İşleniyor --->
                    obj.disabled = true;
                    <!---<cfif not isdefined("caller.attributes.isAjax")>--->
                        setTimeout("div_goster()",1000);
                    <!---</cfif>--->
                    </cfif>
                }
                <cfif attributes.is_upd eq 1 and listlen(attributes.history_table_list) and listlen(attributes.history_datasource_list) and len(attributes.history_identy) and len(attributes.history_action_id)>
                    if(type == undefined)
                        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_add_history&dsn3=#caller.dsn3#&dsn=#caller.dsn#&dsn2=#caller.dsn2#&dsn1=#caller.dsn1#&is_wrkId=#attributes.is_wrkId#&history_act_type=#attributes.history_act_type#&history_identy=#attributes.history_identy#&history_action_id=#attributes.history_action_id#&history_table_list=#attributes.history_table_list#&history_datasource_list=#attributes.history_datasource_list#</cfoutput>','ADD_TABLE_HISTORY',1);
                    else
                        return true;
                <cfelse>
                    return true;
                </cfif>
            }
			
			function spaSubmit<cfoutput>#id_count_#</cfoutput>(obj)
			{ 
				window.formElements = {};
					if(obj.id == 'wrk_delete_button')
					{
						<cfif isdefined("caller.woStruct#id_count_#")>
							var delFuseactionJSON = $.evalJSON(decodeURIComponent("<cfoutput>#delFuseaction#</cfoutput>"));
							var delFuseactionExtraParamsJSON = $.evalJSON(decodeURIComponent("<cfoutput>#delFuseactionExtraParams#</cfoutput>"));
							if($(obj).closest('form').find("input[name='eventName']").length)
							{
								$(obj).closest('form').find("input[name='eventName']").each(function(index,element){
									fuseactParameters = delFuseactionJSON[$(element).val()]['fuseaction'];

									if(delFuseactionExtraParamsJSON[$(element).val()])
										delFuseactionExtraParams = delFuseactionExtraParamsJSON[$(element).val()]['extraParams'];
									else
										delFuseactionExtraParams = '';
								});
							}
							else if($(obj).closest('form').find("input[name='pageDelEvent']").length)
							{
								$(obj).closest('form').find("input[name='pageDelEvent']").each(function(index,element){
									fuseactParameters = delFuseactionJSON[$(element).val()]['fuseaction'];
									 	fuseactParameters = fuseactParameters + '&pageDelEvent='+ $(element).val();

									if(delFuseactionExtraParamsJSON[$(element).val()])
										delFuseactionExtraParams = delFuseactionExtraParamsJSON[$(element).val()]['extraParams'];
									else
										delFuseactionExtraParams = '';
								});
							}
							else
							{
								fuseactParameters = delFuseactionJSON['del']['fuseaction'];

								if(delFuseactionExtraParamsJSON['del'])
									delFuseactionExtraParams = delFuseactionExtraParamsJSON['del']['extraParams'];
								else
									delFuseactionExtraParams = '';
							}
							
							for(i=2;i<=list_len(fuseactParameters,'&');i++)
							{
								var element = list_getat(fuseactParameters,i,'&');
								window.formElements[list_getat(element,1,'=')] = list_getat(element,2,'=');
							}
							for(i=0;i<=list_len(delFuseactionExtraParams,'&');i++)
							{
								var element = list_getat(delFuseactionExtraParams,i,'&');
								window.formElements[element] = $("#"+element).val();
							}

							<cfif isdefined("caller.woStruct#id_count_#")>
								window.formElements['pageHead'] = "<cfoutput>#caller.pageHead#</cfoutput>";
								window.formElements['controllerFileName'] = '<cfoutput>#caller.pageControllerName#</cfoutput>';
								window.formElements['pageFuseaction'] = '<cfoutput>#caller.attributes.fuseaction#</cfoutput>';
								window.formElements['event'] ='<cfoutput>#caller.attributes.event#</cfoutput>';
							</cfif>
							
							//console.log(window.formElements);
							<cfif isdefined("caller.module_name") and len(caller.module_name)>
								callPostURL("<cfoutput>#request.self#?fuseaction=objects.emptypopup_form_converter&isAjax=1&ajax=1&xmlhttp=1&_cf_nodebug=true&formSubmittedController=1&delEvent=1&moduleForLanguage=#caller.module_name#</cfoutput>",handlerPostForSubmit,{ formElements: encodeURIComponent(JSON.stringify(window.formElements)) });
							<cfelse>
								callPostURL("<cfoutput>#request.self#?fuseaction=objects.emptypopup_form_converter&isAjax=1&ajax=1&xmlhttp=1&_cf_nodebug=true&formSubmittedController=1&delEvent=1</cfoutput>",handlerPostForSubmit,{ formElements: encodeURIComponent(JSON.stringify(window.formElements)) });
							</cfif>
							return false;
						</cfif>
					}
					else
					{
						formId = $($(obj).closest('form')[0]).attr("id");
						$("#"+formId).find('input,select,textarea').each(function(index,element){
								if($(element).attr('disabledElement'))
									$(element).prop('disabled',false);
							});

						data = new FormData($(obj).closest('form')[0]);
						try{
						for(var instanceName in CKEDITOR.instances)
							data.append('CKEDITOR_'+CKEDITOR.instances[instanceName].name,CKEDITOR.instances[CKEDITOR.instances[instanceName].name].getData());
						}
						catch(e){}
						<cfif isdefined("caller.woStruct#id_count_#")>
							data.append('pageHead',"<cfoutput>#caller.pageHead#</cfoutput>");
							data.append('controllerFileName','<cfoutput>#caller.pageControllerName#</cfoutput>');
							data.append('event','<cfoutput>#caller.attributes.event#</cfoutput>');
						</cfif>
						<cfif isdefined("caller.mainEvent")><!--- det sayfalarda karışıklıklar oluyordu diye eklendi. --->
							data.append('pageMainEvent','<cfoutput>#caller.mainEvent#</cfoutput>');
						</cfif>
						data.append('pageFuseaction','<cfoutput>#caller.attributes.fuseaction#</cfoutput>');

						<cfif isdefined("caller.module_name") and len(caller.module_name)>
							callPostURLFormData("<cfoutput>#request.self#?fuseaction=objects.emptypopup_form_converter&isAjax=1&xmlhttp=1&_cf_nodebug=true&formSubmittedController=1&moduleForLanguage=#caller.module_name#</cfoutput>",handlerPostForSubmit,data);
						<cfelse>
							callPostURLFormData("<cfoutput>#request.self#?fuseaction=objects.emptypopup_form_converter&isAjax=1&xmlhttp=1&_cf_nodebug=true&formSubmittedController=1</cfoutput>",handlerPostForSubmit,data);
						</cfif>
						return false;
					}
			}
			
			function callPostURL(url, callback, data, target, async)
			{   
				var method = (data != null) ? "POST": "GET";
				$.ajax({
					async: async != null ? async: true,
					url: url,
					type: method,
					data: data,
					success: function(responseData, status, jqXHR)
					{ 
						callback(target, responseData, status, jqXHR); 
					}
				});
			}
			
			function callPostURLFormData(url, callback, data, target, async)
			{   
				error_message = '';
				error_file = '';
				error_lines = '';
				error_code = '0';
				var method = (data != null) ? "POST": "GET";
				$.ajax( {
						url: url,
						type: method,
						data: data,
						processData: false,
						contentType: false,
						success: function(responseData, status, jqXHR)
						{
							try
							{
								donus_ = JSON.parse($.trim(responseData));
								error_code = donus_.WRK_ERROR_CODE;
							}
							catch(e)
							{
								error_code = 0;
							}
							if(error_code != '0' && error_code != 0 && error_code != undefined)
							{
								wrk_error_message = donus_.WRK_ERROR_MESSAGE;
								system_error_message = donus_.ERRORMESSAGE;
								system_error_code = donus_.ERRORCODE;
								system_error_file = donus_.ERRORFILE;
								system_error_line = donus_.ERRORLINE;
								
								message_ = 'İşlem Hatalı - ' + wrk_error_message;
								
								<cfif isDefined("session.ep.userid") and (session.ep.admin or caller.workcube_mode eq 0)>
									try
									{
										message_ += '\n' + 'Error Code: ' + system_error_code;
										message_ += '\n' + 'Message :' + system_error_message;
										message_ += '\n' + 'File : ' + system_error_file;
										message_ += '\n' + 'Line : ' + system_error_line;
										
										//document.body.innerHTML = JSON.stringify(donus_.cfcatch);
									}
									catch(e)
									{
										//nothing
									}
								</cfif>
								alert(message_);
							}
							else
							{
								callback(target, responseData, status, jqXHR);
							}
						}
					} );
			}
			
			function handlerPostForSubmit(target, responseData, status, jqXHR){
				responseData = $.trim(responseData);
			
				if(responseData.substr(0,2) == '//') responseData = responseData.substr(2,responseData.length-2);
			
				ajax_request_script(responseData);
				
				var SCRIPT_REGEX = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi;
				while (SCRIPT_REGEX.test(responseData)) {
					responseData = responseData.replace(SCRIPT_REGEX, "");
				}
				responseData = responseData.replace(/<!-- sil -->/g, '');
				responseData = responseData.replace(/(\r\n|\n|\r)/gm,'');
			}
			function buttonClickFunction()
			{
				$("#wrk_submit_button").click();
			}
			function nothing(){alertObject({'message':"<cfoutput>#caller.getLang('main',120)#</cfoutput>"}); return false;}

			<cfif len( attributes.warning_id )>
				function actionClick() {
					cfmodal('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_list_warning&mode=getactionnote&fuseaction_=<cfoutput>#caller.attributes.fuseaction#</cfoutput>&type=comment&id=<cfoutput>#attributes.warning_id#</cfoutput>&comment_required=1&view_mode=box','warning_modal');
					return false;
				}
			</cfif>

        </script>
        <cfset submitButtonForTabMenu = 0>
        <cfoutput>
            <cfif attributes.is_upd eq 1 and listlen(attributes.history_table_list) and listlen(attributes.history_datasource_list) and len(attributes.history_identy) and len(attributes.history_action_id)>
            <div id="ADD_TABLE_HISTORY" style="width:0px;height:0px;"></div>
            </cfif>
            <cfif len(attributes.extraInfo)>
            	<div class="workcubeButtonExtraInfo">
                	<span><cfoutput>#attributes.extraInfo#</cfoutput></span>
                </div>
            </cfif>
            <cfif len(attributes.extraButton)>
            	<input class="<cfif len(attributes.extraButtonClass)>#attributes.extraButtonClass#<cfelse>ui-wrk-btn ui-wrk-success</cfif>" name="wrk_extra_button" id="wrk_extra_button" type="button" value="  #attributes.extraButtonText#  " <cfif len(attributes.extraAlert)>onclick="return (confirm('#attributes.extraAlert#') && validateControl() && #attributes.extraFunction# && waitForDisableAction#id_count_#(this))"<cfelse>onclick="return ( validateControl()&&#attributes.extraFunction# && waitForDisableAction#id_count_#(this))"</cfif>/>
            </cfif>
            <cfif attributes.update_status is not 0>
				<cfif len( attributes.warning_id )>
					<input type="button" value="<cf_get_lang dictionary_id = '61116.Bildirim Yap'>" class="ui-wrk-btn ui-wrk-btn-extra" onclick="actionClick()">
				</cfif>
                <cfif isDefined('get_buttons') and get_buttons.recordcount>
					<cfif attributes.is_upd and (not is_delete) and len(attributes.del_function)>
                        <cfif len(attributes.del_function_for_submit)>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-success" name="wrk_delete_button" id="wrk_delete_button" type="button" value="  #attributes.delete_info#  " onclick="javascript:#attributes.del_function#;if(confirm('#attributes.delete_alert#') && #attributes.del_function_for_submit#) { waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return;"/>
                        <cfelseif len(attributes.delete_page_url)>
                        	<input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-success"  name="wrk_delete_button" id="wrk_delete_button" type="button" value="  #attributes.delete_info#  " onclick="javascript:#attributes.del_function#;if(confirm('#attributes.delete_alert#')) { waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return;"/>
                        <cfelse>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn  ui-wrk-btn-success"  name="wrk_delete_button" id="wrk_delete_button" type="button" value="  #attributes.delete_info#  " onclick="javascript:#attributes.del_function#;if(confirm('#attributes.delete_alert#')) { waitForDisableAction#id_count_#(this,1);} else return;"/>
                        </cfif>
                    <cfelseif attributes.is_upd and (not is_delete) and (not len(attributes.del_function))>
                        <cfif len(attributes.del_function_for_submit)>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif>  ui-wrk-btn ui-wrk-btn-success" name="wrk_delete_button" id="wrk_delete_button" type="button" value="  #attributes.delete_info#  " onclick="javascript:if(confirm('#attributes.delete_alert#') && #attributes.del_function_for_submit#) { waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return;"/>
                        <cfelseif len(attributes.delete_page_url)>
                        	<input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-success" name="wrk_delete_button" id="wrk_delete_button" type="button" value="  #attributes.delete_info#  " onclick="javascript:if(confirm('#attributes.delete_alert#')) { waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return;"/>
                        <cfelse>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn  ui-wrk-btn-success" name="wrk_delete_button" id="wrk_delete_button" type="button" value="  #attributes.delete_info#  " onclick="javascript:if(confirm('#attributes.delete_alert#')) { waitForDisableAction#id_count_#(this);} else return;"/>
                        </cfif>
                    </cfif>
                    <cfif attributes.is_insert eq 1 and (not is_insert)>
                        <cfif len(attributes.insert_alert) and len(attributes.add_function)>
                            <input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-success" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="javascript:return (confirm('#attributes.insert_alert#') && <cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl()&&</cfif> #attributes.add_function# && waitForDisableAction#id_count_#(this));"/>
                            <cfset submitButtonForTabMenu = 1>
                        <cfelseif len(attributes.insert_alert) and (not len(attributes.add_function))>
                            <input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn  ui-wrk-btn-success" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="javascript:return (confirm('#attributes.insert_alert#') && <cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl()&&</cfif> waitForDisableAction#id_count_#(this));"/>
                            <cfset submitButtonForTabMenu = 1>
                        <cfelseif (not len(attributes.insert_alert)) and len(attributes.add_function)>
                            <input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-success" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="javascript:return (<cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl()&&</cfif> #attributes.add_function# && waitForDisableAction#id_count_#(this))"/>
                            <cfset submitButtonForTabMenu = 1>
                        <cfelseif (not len(attributes.insert_alert)) and (not len(attributes.add_function))>
                            <input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-success" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="javascript:return(<cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl()&&</cfif> waitForDisableAction#id_count_#(this);)"/>
                            <cfset submitButtonForTabMenu = 1>
                        </cfif>
                    </cfif>
                <cfelse>
                    <cfif attributes.is_delete and attributes.is_upd and len(attributes.del_function)>
                        <cfif len(attributes.del_function_for_submit)>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-red" name="wrk_delete_button" id="wrk_delete_button" type="button" value="#attributes.delete_info#" onclick="javascript:#attributes.del_function#;if(confirm('#attributes.delete_alert#') && #attributes.del_function_for_submit#){ waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return false;"/>
                        <cfelseif len(attributes.delete_page_url)>
                           	<input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-red" name="wrk_delete_button" id="wrk_delete_button" type="button" value="#attributes.delete_info#" onclick="javascript:#attributes.del_function#;if(confirm('#attributes.delete_alert#')){ waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return false;"/>
                        </cfif>
                    <cfelseif attributes.is_delete and attributes.is_upd and (not len(attributes.del_function))>
                        <cfif len(attributes.del_function_for_submit)>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-red" name="wrk_delete_button" id="wrk_delete_button" type="button" value="#attributes.delete_info#" onclick="javascript:if(confirm('#attributes.delete_alert#') && #attributes.del_function_for_submit#){ waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return false;"/>
                       	<cfelseif len(attributes.delete_page_url)>
                        	<input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-red" name="wrk_delete_button" id="wrk_delete_button" type="button" value="#attributes.delete_info#" onclick="javascript:if(confirm('#attributes.delete_alert#')){ waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return false;"/>
                        <cfelse>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-red" name="wrk_delete_button" id="wrk_delete_button" type="button" value="#attributes.delete_info#" onclick="javascript:if(confirm('#attributes.delete_alert#')){ waitForDisableAction#id_count_#(this);} else return false;"/>
                        </cfif>
                    <cfelseif attributes.is_delete and len(attributes.delete_page_url)>
                        <cfif len(attributes.del_function_for_submit)>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-red" name="wrk_delete_button" id="wrk_delete_button" type="button" value="#attributes.delete_info#" onclick="javascript:if(confirm('#attributes.delete_alert#') && #attributes.del_function_for_submit#){ waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return false;"/>
                       	<cfelseif len(attributes.delete_page_url)>
                        	<input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-red" name="wrk_delete_button" id="wrk_delete_button" type="button" value="#attributes.delete_info#" onclick="javascript:if(confirm('#attributes.delete_alert#')){ waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return false;"/>
                        <cfelse>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-red" name="wrk_delete_button" id="wrk_delete_button" type="button" value="#attributes.delete_info#" onclick="javascript:if(confirm('#attributes.delete_alert#')){ waitForDisableAction#id_count_#(this);} else return false;"/>
                        </cfif>
					<cfelseif attributes.is_delete eq 0 and attributes.is_upd eq 1 and GET_EMP_DEL_BUTTONS.recordcount>
                    	<input class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-red disabledButtons" name="wrk_delete_button" id="wrk_delete_button" type="button" value="  #attributes.delete_info#  " onclick="return nothing();"/>
                    </cfif>
					 <cfif attributes.is_delete and attributes.is_upd and len(attributes.del_function) and not len(attributes.delete_page_url)>
                        <cfif len(attributes.del_function) and not len(attributes.delete_page_url)>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-red" name="wrk_delete_button" id="wrk_delete_button" type="button" value=" #attributes.delete_info# " onclick="javascript:return (confirm('#attributes.delete_alert#') && #attributes.del_function# && waitForDisableAction#id_count_#(this))"/>
                        </cfif>
                    </cfif>
                    <cfif (attributes.is_insert or attributes.is_authority_passive) and len(attributes.insert_alert) and len(attributes.add_function)>
                        <input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-success" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="javascript:return (confirm('#attributes.insert_alert#') && sessionControl() && <cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl() &&</cfif> #attributes.add_function# && waitForDisableAction#id_count_#(this));"/>
                        <cfset submitButtonForTabMenu = 1>
                    <cfelseif (attributes.is_insert or attributes.is_authority_passive) and len(attributes.insert_alert) and (not len(attributes.add_function))>
                        <input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-success" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="javascript:return (confirm('#attributes.insert_alert#') && sessionControl() &&  <cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl()&&</cfif> waitForDisableAction#id_count_#(this));"/>
                        <cfset submitButtonForTabMenu = 1>
                    <cfelseif (attributes.is_insert or attributes.is_authority_passive) and (not len(attributes.insert_alert)) and len(attributes.add_function)>
                        <input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-success" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="javascript:return (<cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl()&&</cfif> sessionControl() &&  #attributes.add_function# && waitForDisableAction#id_count_#(this))"/>
                        <cfset submitButtonForTabMenu = 1>
                    <cfelseif (attributes.is_insert or attributes.is_authority_passive)>
                        <input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-success" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="javascript:return(<cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl()&&</cfif> sessionControl() &&  waitForDisableAction#id_count_#(this);)"/>
                        <cfset submitButtonForTabMenu = 1>
					<cfelse>
						<input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-success disabledButtons" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="return nothing();"/>
                        <cfset submitButtonForTabMenu = 1>
                    </cfif>                   
                </cfif>
            </cfif>
			<!--- E.Y tarafından --->
            <cfif attributes.is_cancel and caller.attributes.fuseaction contains 'popup'>
                <cfif isdefined("attributes.cancel_function") and len(attributes.cancel_function)>
                    <input class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-red" name="wrk_cancel_button" id="wrk_cancel_button" type="button" value="  #attributes.cancel_info#  " onclick="javascript:if(confirm('#attributes.cancel_alert#') && #attributes.cancel_function#) window.close(); else return false;"/>
                <cfelse>
                    <input class="<cfif len(attributes.class)>#attributes.class#</cfif>ui-wrk-btn ui-wrk-btn-red" name="wrk_cancel_button" id="wrk_cancel_button" type="button" value="  #attributes.cancel_info#  " onclick="javascript:if(confirm('#attributes.cancel_alert#')) window.close(); else return false;"/>
                </cfif>
            <cfelseif attributes.is_cancel>
                <cfif isdefined("attributes.cancel_function") and len(attributes.cancel_function)>
                    <input class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-red" name="wrk_cancel_button" id="wrk_cancel_button" type="button" value="  #attributes.cancel_info#  " onclick="javascript:if(confirm('#attributes.cancel_alert#') && #attributes.cancel_function#) window.history.back(); else return false;"/>
                <cfelse>
                    <input class="<cfif len(attributes.class)>#attributes.class#</cfif> ui-wrk-btn ui-wrk-btn-red" name="wrk_cancel_button" id="wrk_cancel_button" type="button" value=" #attributes.cancel_info# " onclick="javascript:if(confirm('#attributes.cancel_alert#')) window.history.back(); else return false;"/>
                </cfif>
            </cfif>
			
            <cfif attributes.is_reset><input type="reset" class="ui-wrk-btn ui-wrk-btn-red" value="#attributes.reset_info#"/></cfif>
            <cfif submitButtonForTabMenu eq 1>
                <cfif isdefined("caller.attributes.event")>
                	<cfset pageEv = caller.attributes.event>
				<cfelseif isdefined("caller.mainEvent")>
                	<cfset pageEv = caller.mainEvent>
                </cfif>
                <cfif isdefined("pageEv")>
                	<cfif attributes.is_insert eq 1>
						<cfset caller.tabMenuStruct['#caller.attributes.fuseaction#']['tabMenus']['#pageEv#']['icons']['check']['text'] = "#caller.getLang('main',49)#">
                        <cfset caller.tabMenuStruct['#caller.attributes.fuseaction#']['tabMenus']['#pageEv#']['icons']['check']['onClick'] = "buttonClickFunction()">
                    </cfif>
					<cfif isdefined("caller.WOStruct") and StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#'],'list') and StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#']['list'],'fuseaction')>
						<cfset caller.tabMenuStruct['#caller.attributes.fuseaction#']['tabMenus']['#pageEv#']['icons']['list-ul']['text'] = "#caller.getLang('main',97)#">
                        <cfset caller.tabMenuStruct['#caller.attributes.fuseaction#']['tabMenus']['#pageEv#']['icons']['list-ul']['href'] = "#caller.request.self#?fuseaction=#caller.WOStruct['#caller.attributes.fuseaction#']['list']['fuseaction']#">
                        <cfset caller.tabMenuStruct['#caller.attributes.fuseaction#']['tabMenus']['#pageEv#']['icons']['list-ul']['target'] = "_blank">
                        <cfset caller.tabMenuData = SerializeJSON(caller.tabMenuStruct['#caller.attributes.fuseaction#']['tabMenus'])>
                    </cfif>
                </cfif>
            </cfif>
        </cfoutput>
    <cfelse>
		<cfquery name="get_priority" datasource="#CALLER.DSN#">
			SELECT
				USERID
			FROM
			  	WRK_SESSION
			WHERE
				ACTION_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#caller.attributes.fuseaction#"> 
				AND ACTION_PAGE_Q_STRING = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.QUERY_STRING#">
				AND USERID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> 
		</cfquery>
		<cfscript>
			getHeader = createObject("component","cfc.right_menu_fnc");
			Get_My_Profile = getHeader.GET_PROFILE('#get_priority.USERID#');
		</cfscript>
		<script>
			function go_to_chat(employeeid){
				window.messagepageid = employeeid;
				window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.chatflow&tab=1&subtab=1&userno='+employeeid, '_blank');
    		}
		</script>
		<a class="ui-wrk-btn ui-wrk-btn-busy" href="javascript://" onclick="add_div()">
			<cfoutput>
				<cfif len(Get_My_Profile.PHOTO) and FileExists("#caller.upload_folder#/hr/#Get_My_Profile.PHOTO#")>
					<img class="img-circle" alt="" src="../documents/hr/<cfoutput>#Get_My_Profile.PHOTO#</cfoutput>" />
				<cfelse>
					<span class="avatextCt onlineusers color-<cfoutput>#Left(Get_My_Profile.NAME, 1)#</cfoutput>"style="width: 25px !important; float: left;margin-top: 3px; margin-right: 8px; height: 25px; display: inline-block;"><small class="avatext onlineusers" style="font-size:11px; top:-6px; width:26px !important;right: 0px"><cfoutput>#Left(Get_My_Profile.NAME, 1)##Left(Get_My_Profile.SURNAME, 1)#</cfoutput></small></span>
				</cfif>
				<label>#caller.getLang('','Burada çalışan var','63777')#:)</label>
			</cfoutput>
		</a>
		<div class="popover_content" style="display:none">
			<a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_priority.USERID#</cfoutput>','','ui-draggable-box-medium')"><b><cfoutput>#Get_My_Profile.NAME# #Get_My_Profile.SURNAME#</cfoutput></b></a>
			<span class="avatextCt color-<cfoutput>#Left(Get_My_Profile.NAME, 1)#</cfoutput>" onclick="go_to_chat(<cfoutput>#get_priority.USERID#</cfoutput>);" style="height:30px;width:30px;padding-right:6px" title="<cf_get_lang dictionary_id='57543.Mesaj'>">
				<small class="avatext"><i class="fa fa-comments" style="line-height:50px;"></i></small>
			</span>
		</div>
		
		<!--- Butonlar Kullanımda--->
    </cfif>
	<cfcatch>#caller.getLang('main',2238)#!<cfdump var="#cfcatch#"></cfcatch><!---Workcube Button Error--->
</cftry>
</div>
<script>
	function add_div() {
		$('.popover_content').css('left',$(".ui-wrk-btn-busy").position().left+20);
		$('.popover_content').css('top',$(".ui-wrk-btn-busy").position().top+48);
		$('.popover_content').toggle();
	}
</script>

<cfif len(attributes.data_action) or len(attributes.del_action)>
	<script>
		var form_id = $($('[data-btn-id="<cfoutput>#btn_rnd_id#</cfoutput>"]').closest('form')[0]).attr("id");
		$("#"+form_id).prepend("<input type='hidden' id='data_action' name='data_action' value='<cfoutput>#attributes.data_action#</cfoutput>'>");
		$("#"+form_id).prepend("<input type='hidden' id='next_page' name='next_page' value='<cfoutput>#attributes.next_page#</cfoutput>'>");
		<cfif isdefined("caller.attributes.draggable") and len(caller.attributes.draggable)>
			$("#"+form_id).prepend("<input type='hidden' id='data_action_modal_id' name='data_action_modal_id' value='<cfoutput>#caller.attributes.modal_id#</cfoutput>'>");
			$("#"+form_id).prepend("<input type='hidden' id='data_action_draggable' name='data_action_draggable' value='1'>");
		</cfif>

		function sendForm(action){
			if(action == 'del'){
				var data_action = "<cfoutput>#attributes.del_action#</cfoutput>";
				var method = 'delActions';
			}else{
				var data_action = "<cfoutput>#attributes.data_action#</cfoutput>";
				var method = 'formConverter';
			}
			var next_url = $("input#next_page").val();
			var data = new FormData();
				data.append('cfc', data_action.split(":")[0]);
				data.append('function', data_action.split(":")[1]);
				data.append('event', action);
				data.append('fuseaction', "<cfoutput>#caller.attributes.fuseaction#</cfoutput>");

				if(action == 'del'){
					var del_action_parameters = data_action.split(":")[2];
					if( del_action_parameters.includes('&')){
                            del_action_parameters = del_action_parameters.split("&");
                            for(i = 0; i < del_action_parameters.length; i++){
                                data.append(del_action_parameters[i].split("=")[0], del_action_parameters[i].split("=")[1])
                            }
                        }else{
                            data.append(del_action_parameters.split("=")[0], del_action_parameters.split("=")[1]);
                        }
				}else{
					data.append('form_data', $.toJSON( $('[data-btn-id="<cfoutput>#btn_rnd_id#</cfoutput>"]').closest('form').serializeArray()) );
				}
				
				AjaxControlPostDataJson('/WMO/datagate.cfc?method='+method+'', data, function(response) {
					if( response.STATUS ){
						if(action == 'del'){ 
							if( isDefined('draggable') && draggable == 1)
							{
								alertObject({message:"<cfoutput>#caller.getLang('','',36146)#</cfoutput>",type:"success"});                             
                            	setTimeout(function(){location.href = document.referrer;} , 2000);
							}								
							else
							{
								alertObject({message:"<cfoutput>#caller.getLang('','',36146)#</cfoutput>",type:"success"});                             
                            	setTimeout(function(){window.location.href = '<cfoutput>#attributes.del_next_page#</cfoutput>';} , 2000);
							}
							
						}else{							
							if(response.DRAGGABLE)
								openService(response.MESSAGE,response.IDENTITY);
							else{
								alertObject({message:(response.MESSAGE)?response.MESSAGE:"<cfoutput>#caller.getLang('','',47470)#</cfoutput>",type:"success"});
								setTimeout(function(){window.location.href = next_url + response.IDENTITY;} , 2000);							
							}
						}
					}else{
						if(response.DRAGGABLE){
							alertObject({message:"<cfoutput>#caller.getLang('','',57541)#</cfoutput> : " + response.MESSAGE ,type:"danger"});
							setTimeout(function(){closeBoxDraggable(response.MODAL_ID)} , 2000);
						}
						else							
							alertObject({message:"<cfoutput>#caller.getLang('','',57541)#</cfoutput> : " + response.MESSAGE ,type:"danger"});
					}
				});
				return false;
		}

		$(document).ready(function() {
			var form_ = $('[data-btn-id="<cfoutput>#btn_rnd_id#</cfoutput>"]').closest('form');
			last_clicked_ = ''
			$(form_).submit(function(e) {			
				var clicked = $(this).find("input[type=submit]:focus").data('gate-action');
				clicked = (clicked) ? clicked : last_clicked_;
				sendForm(clicked);
				e.preventDefault();			
			});	
			$( "[data-gate-action]" ).click(function() {
				last_clicked_ = $(this).data('gate-action');
				if(last_clicked_ == 'del')sendForm(last_clicked_);
			});	
		});
	</script>
</cfif>

<cfif (attributes.is_insert or attributes.is_authority_passive) and len(attributes.add_function)>
    <script>
        //Seri no popup üzerinden irsaliye güncelleme işlemleri için eklendi!!
        function updateButton() {
            return (sessionControl() && <cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl() &&</cfif> <cfif isDefined("attributes.add_function") and len(attributes.add_function)><cfoutput>#attributes.add_function#</cfoutput> &&</cfif> waitForDisableAction<cfoutput>#id_count_#</cfoutput>($("#wrk_submit_button")));
        }
    </script>
</cfif>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">