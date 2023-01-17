<link rel="stylesheet" type="text/css" href="/src/assets/plugin/sweetalert/sweetalert.min.css">
<script  type="text/javascript" src="/src/assets/plugin/sweetalert/sweetalert.min.js"></script>
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

<cfset vue_app = "VUE#encrypt(round(rand()*1000),'VUE_APP','CFMX_COMPAT','Hex')#">

<div id="workcube_button" class="float-right" data-vue-app="<cfoutput>#vue_app#</cfoutput>">
<cfparam name="attributes.type_format" default=0>
<cfparam name="attributes.is_disable" default=1>
<cfparam name="attributes.update_status" default=1>
<cfparam name="attributes.is_upd" default=0>
<cfparam name="attributes.is_cancel" default=1>
<cfparam name="attributes.is_reset" default=0>
<cfparam name="attributes.is_delete" default=1>
<cfparam name="attributes.is_insert" default=1>
<cfparam name="attributes.del_function" default="">
<cfparam name="attributes.del_function_for_submit" default="">
<cfparam name="attributes.add_function" default="">
<cfparam name="attributes.cancel_info" default="#application.functions.getLang('main',50)#"> <!--- Vazgeç --->
<cfparam name="attributes.cancel_alert" default="#application.functions.getLang('main',122)#"> <!--- Sayfadan Çıkıyorsunuz Emin Misiniz? --->
<cfparam name="attributes.reset_info" default="#application.functions.getLang('main',522)#"> <!--- Temizle --->
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
<cfparam name="attributes.extraButtonType" default="button">
<cfparam name="attributes.win_alert" default="1"><!--- Confirm uyarısını kapatır --->
<!--- ? Form yönelendirmesi İçin Ekledi SA27022021 --->
<cfparam name="attributes.data_action" default=""> <!--- * cfc_pathi:medhod /V16/objects2/protein/data/event_data.cfc:add_event  --->
<cfparam name="attributes.next_page" default=""> <!--- * next page --->
<cfparam name="attributes.del_action" default=""> <!--- * cfc_pathi:medhod /V16/objects2/protein/data/event_data.cfc:add_event  --->
<cfparam name="attributes.del_next_page" default=""> <!--- * next page --->
<cfparam name="attributes.after_function" default=""> <!--- * post işleminden sonra response ile beraber çalıştırılacak function --->
<!--- ? --->
<cfif not len(attributes.extraButtonText)>
	<cfset attributes.extraButtonText = application.functions.getLang('main',2638)>
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
		if (not isDefined('attributes.insert_info')) attributes.insert_info = application.functions.getLang('main',52);//Güncelle
		if (not (isDefined('attributes.insert_alert') and len(attributes.insert_alert))) attributes.insert_alert = application.functions.getLang('main',124);//Güncellemek İstediğinizden Emin misiniz?
		data_gate_submit="upd";
		}
	else
		{
		if (not isDefined('attributes.insert_info')) attributes.insert_info = application.functions.getLang('main',49,'');//Kaydet
		if (not (isDefined('attributes.insert_alert') and len(attributes.insert_alert))) attributes.insert_alert = application.functions.getLang('main',123);//Kaydetmek İstediğinizden Emin Misiniz?
		data_gate_submit="add";
	}
	if(attributes.is_delete)
	{
		if (not isDefined('attributes.delete_info')) attributes.delete_info = application.functions.getLang('main',51);//Sil
		if (not isDefined('attributes.delete_alert')) attributes.delete_alert = application.functions.getLang('main',121);//Silmek İstediğinizden Emin Misiniz?	
	}
	if(not isdefined("attributes.delete_info"))
		attributes.delete_info = application.functions.getLang('main',51);
</cfscript>
<cfif not isdefined("caller.module_name")>
    <cfset caller.module_name ="objects" >
</cfif>
<cfif (isdefined("cgi.HTTP_REFERER") and cgi.HTTP_REFERER contains 'emptypopup') or isdefined("caller.attributes.nogoback")>
	<cfset attributes.is_cancel = 0>
</cfif>
<cftry>
	<cfif caller.is_only_show_page eq 0>
        <cfif attributes.update_status is not 0>
            <cfif caller.workcube_mode><!--- sadece development modda 20 dak bir get_buttons query calissin --->
                <cfset application.functions.get_buttons_cached_time = CreateTimeSpan(0,2,0,0)>
            <cfelse>
                <cfset application.functions.get_buttons_cached_time = CreateTimeSpan(0,0,0,0)>
            </cfif>
            <cfif isdefined("session.ep.userid") and len(session.ep.userid)>         
                <cfquery name="GET_EMP_IZINLI_BUTTONS" datasource="#CALLER.DSN#" cachedwithin="#application.functions.get_denied_page_cached_time#">
                    SELECT
                        ED.DENIED_PAGE,
                        ED.IS_INSERT
                    FROM
                        EMPLOYEE_POSITIONS_DENIED ED,
                        EMPLOYEE_POSITIONS E
                    WHERE
                        (ED.IS_INSERT = 1) AND
                        ED.DENIED_TYPE = 1 AND
                        ED.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#application.functions.get_module_id(caller.module_name)#"> AND
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
                                EPD.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#application.functions.get_module_id(caller.module_name)#"> AND
                                EPD.DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#caller.attributes.fuseaction#"> AND
                                EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
                                (
                                    EPD.POSITION_CODE = EP.POSITION_CODE OR
                                    EPD.POSITION_CAT_ID = EP.POSITION_CAT_ID OR
                                    EPD.USER_GROUP_ID = EP.USER_GROUP_ID
                                )
                        )
                </cfquery>
                <cfquery name="GET_EMP_DEL_BUTTONS" datasource="#CALLER.DSN#" cachedwithin="#application.functions.get_denied_page_cached_time#">
                    SELECT
                        ED.DENIED_PAGE,
                        ED.IS_DELETE
                    FROM
                        EMPLOYEE_POSITIONS_DENIED ED,
                        EMPLOYEE_POSITIONS E
                    WHERE
                        (ED.IS_DELETE = 1) AND
                        ED.DENIED_TYPE = 1 AND
                        ED.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#application.functions.get_module_id(caller.module_name)#"> AND
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
                                EPD.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#application.functions.get_module_id(caller.module_name)#"> AND
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
                    <cfquery name="GET_BUTTONS" datasource="#CALLER.DSN#" cachedwithin="#application.functions.get_buttons_cached_time#">
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
				<cftry>								
					<cfquery name="GET_BUTTONS" datasource="#CALLER.DSN#" cachedwithin="#application.functions.get_buttons_cached_time#">
						SELECT
							CPD.IS_DELETE,
							CPD.IS_INSERT,
							CPD.DENIED_PAGE
						FROM
							COMPANY_PARTNER_DENIED AS CPD
						WHERE
							CPD.PARTNER_ID = #session.pp.userid# AND
								CPD.DENIED_PAGE_ID = #caller.GET_PAGE.PAGE_ID#				
					</cfquery>
					<cfcatch>						
					</cfcatch>
				</cftry>
            </cfif>
		</cfif>
		
        
        <cfscript>
            if(isDefined('get_buttons') and get_buttons.recordcount)
                {
                    if(attributes.is_delete)
                        {
                            is_delete = listfind(valuelist(get_buttons.is_delete),false);//1:kullanici sil butonunu kullanabilir
                        }
                    else
                        is_delete = 1;
                    if(attributes.is_insert)
                        {
                            is_insert = listfind(valuelist(get_buttons.is_insert),false);//1:kullanici kaydet/guncelle butonunu kullanabilir
                        }
                    else
                        is_insert = 0;
                }
        //wrk_not:bu kismin alti da cfscript icine alinacak..
        </cfscript>
        <!--- buton kombinasyonu --->
        <script type="text/javascript">
            var obj;
            /* 20050523 CFMX7 geciste cf in kendi degiskenini kullaniyoruz
            var _CF_ERROR = 0; */
            var _CF_error_exists = false;
			function validateControl(){
				return validate().check();
				}
            function waitForDisableAction<cfoutput>#id_count_#</cfoutput>(el)
            {
				<cfif len(attributes.data_action) EQ 0 AND len(attributes.del_action) eq 0>					
					obj = el;
					<cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>
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
						
						return true;
					</cfif>
				</cfif>
            }
            function div_goster()
            {
                get_wrk_message_div("<cfoutput>#application.functions.getLang('main',1932)#</cfoutput>","<cfoutput>#application.functions.getLang('main',1933)#</cfoutput>");<!--- İşleminiz yapılıyor lütfen bekleyiniz --->
            }
            function disableAction(type)//type sadece ajax sayfa içinde çağırılı amacı: Ajax'lı bloğa tekrar tekrar girmesin...
            {
                if(!_CF_error_exists)
                {
                    <cfif attributes.no_show_process neq 1>
                    obj.value="<cfoutput>#application.functions.getLang('main',293)#</cfoutput>"; <!--- İşleniyor --->
                    obj.disabled = true;
                    setTimeout("div_goster()",1000);
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
							data.append('pageHead','<cfoutput>#caller.pageHead#</cfoutput>');
							data.append('controllerFileName','<cfoutput>#caller.pageControllerName#</cfoutput>');
							data.append('event','<cfoutput>#caller.attributes.event#</cfoutput>');
						</cfif>
						<cfif isdefined("caller.mainEvent")><!--- det sayfalarda karışıklıklar oluyordu diye eklendi. --->
							data.append('pageMainEvent','<cfoutput>#caller.mainEvent#</cfoutput>');
						</cfif>

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
				var method = (data != null) ? "POST": "GET";
				$.ajax( {
						url: url,
						type: method,
						data: data,
						processData: false,
						contentType: false,
						success: function(responseData, status, jqXHR)
						{ 
							callback(target, responseData, status, jqXHR); 
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
			function nothing(){
				alertObject({'message':"<cfoutput>#application.functions.getLang('main',120)#</cfoutput>"}); return false;
			}
        </script>
        <cfset submitButtonForTabMenu = 0>
		<cfoutput>
            <div id="ADD_TABLE_HISTORY" style="display:none;"></div>
            <cfif len(attributes.extraInfo)>
            	<div class="workcubeButtonExtraInfo">
                	<span><cfoutput>#attributes.extraInfo#</cfoutput></span>
                </div>
            </cfif>
            <cfif len(attributes.extraButton)>
            	<input <cfif len(attributes.class)>class="#attributes.class#"</cfif> name="wrk_extra_button" id="wrk_extra_button" type="#attributes.extraButtonType#" value="  #attributes.extraButtonText#  " onclick="return (doConfirm(this,'#attributes.extraAlert#') && #attributes.extraFunction# && waitForDisableAction#id_count_#(this))"/>
            </cfif>
            <cfif attributes.update_status is not 0>
                <cfif isDefined('get_buttons') and get_buttons.recordcount>
                    <cfif attributes.is_upd and (not is_delete) and len(attributes.del_function)>
                        <cfif len(attributes.del_function_for_submit)>
                            <input data-gate-action="del"  class="<cfif len(attributes.class)>#attributes.class#</cfif> btn red-mint" name="wrk_delete_button" id="wrk_delete_button" type="button" value="  #attributes.delete_info#  " onclick="javascript:#attributes.del_function#;if(doConfirm(this,'#attributes.delete_alert#') && #attributes.del_function_for_submit#) { waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return;"/>
                        <cfelseif len(attributes.delete_page_url)>
                        	<input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn red-mint"  name="wrk_delete_button" id="wrk_delete_button" type="button" value="  #attributes.delete_info#  " onclick="javascript:#attributes.del_function#;if(doConfirm(this,'#attributes.delete_alert#')) { waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return;"/>
                        <cfelse>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn red-mint"  name="wrk_delete_button" id="wrk_delete_button" type="button" value="  #attributes.delete_info#  " onclick="javascript:#attributes.del_function#;if(doConfirm(this,'#attributes.delete_alert#')) { waitForDisableAction#id_count_#(this,1);} else return;"/>
                        </cfif>
                    <cfelseif attributes.is_upd and (not is_delete) and (not len(attributes.del_function))>
                        <cfif len(attributes.del_function_for_submit)>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif>  btn red-mint"name="wrk_delete_button" id="wrk_delete_button" type="button" value="  #attributes.delete_info#  " onclick="javascript:if(doConfirm(this,'#attributes.delete_alert#') && #attributes.del_function_for_submit#) { waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return;"/>
                        <cfelseif len(attributes.delete_page_url)>
                        	<input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn red-mint" name="wrk_delete_button" id="wrk_delete_button" type="button" value="  #attributes.delete_info#  " onclick="javascript:if(doConfirm(this,'#attributes.delete_alert#')) { waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return;"/>
                        <cfelse>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn red-mint" name="wrk_delete_button" id="wrk_delete_button" type="button" value="  #attributes.delete_info#  " onclick="javascript:if(doConfirm(this,'#attributes.delete_alert#')) { waitForDisableAction#id_count_#(this);} else return;"/>
                        </cfif>
                    </cfif>
                    <cfif attributes.is_insert eq 1 and (not is_insert)>
                        <cfif len(attributes.insert_alert) and len(attributes.add_function)>
                            <input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn btn-primary btn-xawrfc" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="javascript:return (doConfirm(this,'#attributes.insert_alert#') && <cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl()&&</cfif> #attributes.add_function# && waitForDisableAction#id_count_#(this));"/>
                            <cfset submitButtonForTabMenu = 1>
                        <cfelseif len(attributes.insert_alert) and (not len(attributes.add_function))>
                            <input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn btn-primary btn-34qsde" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="javascript:return (doConfirm(this,'#attributes.insert_alert#') && <cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl()&&</cfif> waitForDisableAction#id_count_#(this));"/>
                            <cfset submitButtonForTabMenu = 1>
                        <cfelseif (not len(attributes.insert_alert)) and len(attributes.add_function)>
                            <input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn btn-primary btn-23d3d3" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="javascript:return (<cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl()&&</cfif> #attributes.add_function# && waitForDisableAction#id_count_#(this))"/>
                            <cfset submitButtonForTabMenu = 1>
                        <cfelseif (not len(attributes.insert_alert)) and (not len(attributes.add_function))>
                            <input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn btn-primary btn-32swq3" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="javascript:return(<cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl()&&</cfif> waitForDisableAction#id_count_#(this);)"/>
                            <cfset submitButtonForTabMenu = 1>
                        </cfif>
                    </cfif>
                <cfelse>
                    <cfif attributes.is_delete and attributes.is_upd and len(attributes.del_function)>
                        <cfif len(attributes.del_function_for_submit)>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn red-mint" name="wrk_delete_button" id="wrk_delete_button" type="button" value="#attributes.delete_info#" onclick="javascript:#attributes.del_function#;if(doConfirm(this,'#attributes.delete_alert#') && #attributes.del_function_for_submit#){ waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return false;"/>
                        <cfelseif len(attributes.delete_page_url)>
                           	<input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn red-mint" name="wrk_delete_button" id="wrk_delete_button" type="button" value="#attributes.delete_info#" onclick="javascript:#attributes.del_function#;if(doConfirm(this,'#attributes.delete_alert#')){ waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return false;"/>
                        </cfif>
                    <cfelseif attributes.is_delete and attributes.is_upd and (not len(attributes.del_function))>
                        <cfif len(attributes.del_function_for_submit)>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn red-mint" name="wrk_delete_button" id="wrk_delete_button" type="button" value="#attributes.delete_info#" onclick="javascript:if(doConfirm(this,'#attributes.delete_alert#') && #attributes.del_function_for_submit#){ waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return false;"/>
                       	<cfelseif len(attributes.delete_page_url)>
                        	<input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn red-mint" name="wrk_delete_button" id="wrk_delete_button" type="button" value="#attributes.delete_info#" onclick="javascript:if(doConfirm(this,'#attributes.delete_alert#')){ waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return false;"/>
                        <cfelse>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn red-mint" name="wrk_delete_button" id="wrk_delete_button" type="button" value="#attributes.delete_info#" onclick="javascript:if(doConfirm(this,'#attributes.delete_alert#')){ waitForDisableAction#id_count_#(this);} else return false;"/>
                        </cfif>
                    <cfelseif attributes.is_delete and len(attributes.delete_page_url)>
                        <cfif len(attributes.del_function_for_submit)>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn red-mint" name="wrk_delete_button" id="wrk_delete_button" type="button" value="#attributes.delete_info#" onclick="javascript:if(doConfirm(this,'#attributes.delete_alert#') && #attributes.del_function_for_submit#){ waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return false;"/>
                       	<cfelseif len(attributes.delete_page_url)>
                        	<input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn red-mint" name="wrk_delete_button" id="wrk_delete_button" type="button" value="#attributes.delete_info#" onclick="javascript:if(doConfirm(this,'#attributes.delete_alert#')){ waitForDisableAction#id_count_#(this,1);window.location.href='#attributes.delete_page_url#';} else return false;"/>
                        <cfelse>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn red-mint" name="wrk_delete_button" id="wrk_delete_button" type="button" value="#attributes.delete_info#" onclick="javascript:if(doConfirm(this,'#attributes.delete_alert#')){ waitForDisableAction#id_count_#(this);} else return false;"/>
                        </cfif>
					<cfelseif attributes.is_delete eq 0 and attributes.is_upd eq 1 and isdefined("GET_EMP_DEL_BUTTONS.recordcount") and GET_EMP_DEL_BUTTONS.recordcount>
                    	<input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn red-mint disabledButtons" name="wrk_delete_button" id="wrk_delete_button" type="button" value="  #attributes.delete_info#  " onclick="return nothing();"/>
                    </cfif>
					<cfif attributes.is_insert and len(attributes.insert_alert) and len(attributes.add_function)>
                        <input data-gate-action="#data_gate_submit#" data-gate-message="#attributes.insert_alert#" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn btn-primary btn-1cv3sd" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="javascript:return (<cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl()&&</cfif> #attributes.add_function# && waitForDisableAction#id_count_#(this));"/>
                        <cfset submitButtonForTabMenu = 1>
                    <cfelseif attributes.is_insert and len(attributes.insert_alert) and (not len(attributes.add_function))>
                        <input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#<cfelse>btn-save</cfif> btn btn-primary  btn-q3e2dw" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" data-gate-message="#attributes.insert_alert#" onclick="javascript:return (<cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl()&&</cfif> waitForDisableAction#id_count_#(this));"/>
                        <cfset submitButtonForTabMenu = 1>
                    <cfelseif attributes.is_insert and (not len(attributes.insert_alert)) and len(attributes.add_function)>
                        <input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn btn-primary btn-3dv33" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="javascript:return (<cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl()&&</cfif> #attributes.add_function# && waitForDisableAction#id_count_#(this))"/>
                        <cfset submitButtonForTabMenu = 1>
                    <cfelseif attributes.is_insert>
                        <input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn btn-primary btn-33f3se" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="javascript:return(<cfif isdefined("caller.woStruct#id_count_#") and isdefined("caller.attributes.event")>validateControl()&&</cfif> waitForDisableAction#id_count_#(this);)"/>
                        <cfset submitButtonForTabMenu = 1>
					<cfelse>
						<input data-gate-action="#data_gate_submit#" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn btn-primary btn-e5w3sc disabledButtons" name="wrk_submit_button" id="wrk_submit_button" type="submit" value="#attributes.insert_info#" onclick="return nothing();"/>
                        <cfset submitButtonForTabMenu = 1>
                    </cfif>
                    <cfif attributes.is_delete and attributes.is_upd and len(attributes.del_function) and not len(attributes.delete_page_url)>
                        <cfif len(attributes.del_function) and not len(attributes.delete_page_url)>
                            <input data-gate-action="del" class="<cfif len(attributes.class)>#attributes.class#</cfif> btn red-mint" name="wrk_delete_button" id="wrk_delete_button" type="button" value=" #attributes.delete_info# " onclick="javascript:return (doConfirm(this,'#attributes.delete_alert#') && #attributes.del_function# && waitForDisableAction#id_count_#(this))"/>
                        </cfif>
                    </cfif>
                </cfif>
            </cfif>
            <!--- E.Y tarafından "
            <cfif attributes.is_cancel and caller.attributes.fuseaction contains 'popup'>
                <cfif isdefined("attributes.cancel_function") and len(attributes.cancel_function)>
                    <input class="<cfif len(attributes.class)>#attributes.class#</cfif> btn blue" name="wrk_cancel_button" id="wrk_cancel_button" type="button" value="  #attributes.cancel_info#  " onclick="javascript:if(doConfirm(this,'#attributes.cancel_alert#') && #attributes.cancel_function#) window.close(); else return false;"/>
                <cfelse>
                    <input class="<cfif len(attributes.class)>#attributes.class#</cfif> btn blue" name="wrk_cancel_button" id="wrk_cancel_button" type="button" value="  #attributes.cancel_info#  " onclick="javascript:if(doConfirm(this,'#attributes.cancel_alert#')) window.close(); else return false;"/>
                </cfif>
            <cfelseif attributes.is_cancel>
                <cfif isdefined("attributes.cancel_function") and len(attributes.cancel_function)>
                    <input class="<cfif len(attributes.class)>#attributes.class#</cfif>  btn blue" name="wrk_cancel_button" id="wrk_cancel_button" type="button" value="  #attributes.cancel_info#  " onclick="javascript:if(doConfirm(this,'#attributes.cancel_alert#') && #attributes.cancel_function#) window.history.back(); else return false;"/>
                <cfelse>
                    <input class="<cfif len(attributes.class)>#attributes.class#</cfif> btn blue" name="wrk_cancel_button" id="wrk_cancel_button" type="button" value=" #attributes.cancel_info# " onclick="javascript:if(doConfirm(this,'#attributes.cancel_alert#')) window.history.back(); else return false;"/>
                </cfif>
            </cfif>
			--->
            <cfif attributes.is_reset><input type="reset" value="#attributes.reset_info#"/></cfif>           
        </cfoutput>
    <cfelse>
        <font color="FF0000"><cfoutput>#application.functions.getLang('main',2137)#</cfoutput>...</font><!--- Butonlar Kullanımda--->
    </cfif>
	<cfcatch>#application.functions.getLang('main',2238)#!<cfdump var="#cfcatch#"></cfcatch><!---Workcube Button Error--->
</cftry>
</div>
<cfif len(attributes.data_action) or len(attributes.del_action)>
	<script>	
		var <cfoutput>#vue_app#</cfoutput> = new Vue({
			el : '[data-vue-app="<cfoutput>#vue_app#</cfoutput>"]',
			data : {
				protein : '2020',			
				data_packet : {
					cfc : "",
					method : '',
					action : '',
					form_data : {}
				},				
				error: [],
			},
			methods : {
				sendForm : function(action,formdata){	
					console.log(formdata);
					if(action=='del'){
						var data_action = "<cfoutput>#attributes.del_action#</cfoutput>";
						var data_gate_token= "<cfoutput>#encrypt((len(attributes.del_action))?"#attributes.del_action#":"0",'protein_3d','CFMX_COMPAT','Hex')#</cfoutput>";
						
					}else{
						var data_action = "<cfoutput>#attributes.data_action#</cfoutput>";
						var data_gate_token= "<cfoutput>#encrypt((len(attributes.data_action))?"#attributes.data_action#":"0",'protein_3d','CFMX_COMPAT','Hex')#</cfoutput>";
					}

					this.data_packet.action = action;
					data_action = data_action.split(":");
					this.data_packet.cfc = data_action[0];
					this.data_packet.method = data_action[1];

						
						var form__ = $('[data-vue-app="<cfoutput>#vue_app#</cfoutput>"]').closest('form');
						var formData = new FormData();
						const formStandarData = this.formJson(form__);
						for (const [key, value] of Object.entries(formStandarData)){
							formData.append(key, value);
						}
						// Attach file
						$(form__).find('input[type=file]').each(function(index,item){
							formData.append($(item).attr('name'), $(item)[0].files[0]);
						})
						
						if(action=='del'){
							formData.append("action_id", data_action[2]);							
						}				
					
					var this_ = this;
					axios
					({
						method: "post",
						url: "/datagate",
						data: formData,
						headers: { "Content-Type": "multipart/form-data","protein-data-gate-token": data_gate_token }
					})
					.then(response => {
						console.log(response.data);
						if(response.data.STATUS){
							toastr
							.success(
								response.data.SUCCESS_MESSAGE,
								'', 
								{timeOut: 5000, progressBar : true, closeButton : true}
							);
							try {
								<cfif len(attributes.after_function)>
									<cfoutput>#attributes.after_function#</cfoutput>(response.data);
								</cfif>	
							} catch (error) {
								console.log("NOT FN:<cfoutput>#attributes.after_function#</cfoutput>");
							}
							

							<cfif len(attributes.next_page)>
								if(action != 'del'){
									var identitiy_ = (response.data.IDENTITY) ? response.data.IDENTITY : '';
									var next_page_ = '<cfoutput>#attributes.next_page#</cfoutput>' + identitiy_;
									console.log(next_page_);
									setTimeout(function(){ 
										window.location.href = next_page_;
									}, 3000);
								}								
							</cfif>
							<cfif len(attributes.del_next_page)>
								if(action == 'del'){
									var next_page_ = '<cfoutput>#attributes.del_next_page#</cfoutput>';
									console.log(next_page_);
									setTimeout(function(){ 
										window.location.href = next_page_;
									}, 3000);
								}								
							</cfif>

						}else{
							toastr
							.error(
								response.data.DANGER_MESSAGE,
								'', 
								{timeOut: 5000, progressBar : true, closeButton : true}
							);
						}						
											
					})
					.catch(e => {
						this_.error.push({ecode: 1000, message:"Şuanda İşlem Yapılamıyor...."})
						
					})   						
				},
				formJson : function (e) {
					var o = {};
					var a = e.serializeArray();
					$.each(a, function () {
						if (o[this.name]) {
							if (!o[this.name].push) {
								o[this.name] = [o[this.name]];
							}
							o[this.name].push(this.value || '');
						} else {
							o[this.name] = this.value || '';
						}
					});
					return o;
				}
			},
			mounted () {/* ready */}
		});
		$(document).ready(function() {
			var form_ = $('[data-vue-app="<cfoutput>#vue_app#</cfoutput>"]').closest('form');
			var last_clicked_ = '', confirmMessage_ = '';
			$(form_).submit(function(e) {			
				var clicked = $(this).find("input[type=submit]:focus").data('gate-action');
				var confirmMessage = $(this).find("input[type=submit]:focus").data('gate-message')
				clicked = (clicked) ? clicked : last_clicked_;
				confirmMessage = (confirmMessage) ? confirmMessage : confirmMessage_;
				
				if(confirmMessage != '' && <cfoutput>#attributes.win_alert#</cfoutput> == 1){
					alertMessage({
						title: 'Uyarı!',
						message: confirmMessage,
						confirmFunction: function(result){
							if (result.value) <cfoutput>#vue_app#</cfoutput>.sendForm(clicked);
						}
					});
				}else <cfoutput>#vue_app#</cfoutput>.sendForm(clicked);
				e.preventDefault();			
			});	
			$( "[data-gate-action]" ).click(function() {
				last_clicked_ = $(this).data('gate-action');
				confirmMessage_ = $(this).data('gate-message');
				if(last_clicked_ == 'del'){
					if(confirmMessage_ != '' && <cfoutput>#attributes.win_alert#</cfoutput> == 1){
						alertMessage({
							title: 'Uyarı!',
							message: confirmMessage_,
							confirmFunction: function(result){
								if (result.value) <cfoutput>#vue_app#</cfoutput>.sendForm(last_clicked_);
							}
						});
					}else <cfoutput>#vue_app#</cfoutput>.sendForm(last_clicked_);
				}
			});	
		});

		function doConfirm(elem,confirmMessage){
			$(elem).attr({'data-gate-message': confirmMessage});
			return true;
		}
	</script>
<cfelse>
	<script>
		function doConfirm(elem,confirmMessage){
			return confirm(confirmMessage);
		}
	</script>
</cfif>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">