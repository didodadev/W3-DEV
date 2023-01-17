<cfif not isdefined("attributes.page_type")>
	<cfparam name="attributes.page_type" default="0">
</cfif>
<cfparam name="attributes.is_form_submitted" default="1">
<!--- Sirket ve Donem Kontrolleri Yapilacak Tablolar Burada Belirlenir --->
<cfset Comp_Id_Control_Tables = "OPPORTUNITIES,INTERNALDEMAND,OFFER,ORDERS,PRODUCTION_ORDERS,PRODUCT_TREE,PRODUCTION_ORDER_RESULT,BUDGET_PLAN,CAMPAIGNS,COMPANY_CREDIT,CORRESPONDENCE,SERVICE,SUBSCRIPTION_CONTRACT,SALES_QUOTAS,SUBSCRIPTION_PAYMENT_PLAN,PRICE">
<cfset Period_Id_Control_Tables = "CARI_CLOSED,SHIP,INVOICE,EXPENSE_ITEM_PLAN_REQUESTS">

<!--- modüllerin our_company_id veya period_id kaydedip etmeyeceği, burada yapılan değişiklikler myhome/query/add_warning.cfm sayfasında da uygulanmalı EÖ 20100710--->
<cfset use_period_module = 'finance,cash,bank,cheque,ch,cost,budget,account,defin,fintab,invent,pos,store,stock,account,invoice,contract,executive,worknet,salesplan,credit'>
<cfset use_company_module = 'production,prod,call,sales,purchase,service,campaign,finance,cash,bank,cheque,ch,cost,budget,account,defin,fintab,invent,pos,store,stock,account,invoice,contract,executive,worknet,salesplan,credit'>

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.process_row_id" default="">
<cfparam name="attributes.list_type" default="">
<cfparam name="attributes.process_type_warning" default="">
<cfif not isDefined("attributes.warning_isactive")>
	<cfparam name="attributes.warning_isactive" default="1">
</cfif>
<cfif not isDefined("attributes.warning_condition")>
	<cfparam name="attributes.warning_condition" default="1">
</cfif>
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.action_table" default="">
<cfparam name="attributes.process_mode" default="">
<cfparam name="attributes.is_mandate" default="0">
<cfparam name="attributes.storageFilter" default="0"><!--- Workflow Detayından dönüşlerde filtreler localstorage'dan doldurulsun mu? --->
<cfparam  name="attributes.view_mode" default="list">

<!---- Vekalet edilen kullanıcılar için kontrol uygulanır! ---->
<cfset newPositionCode = ( isDefined("attributes.position_code") and len(attributes.position_code) ) ? attributes.position_code : session.ep.position_code>
<!---- İşlemi yapan kişinin position_id değeri alınır ---->
<cfquery name="GET_POS_ID" datasource="#DSN#">
    SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfscript>
	if(not isDefined('attributes.start_response_date'))
		attributes.start_response_date = date_add('m',-1,now());
	if(not isDefined('attributes.finish_response_date'))
		attributes.finish_response_date = now();
</cfscript>
<cfif isdefined("attributes.is_active_id")>
	<!--- Pasif Update islemi --->
	<cfquery name="upd_page_warning" datasource="#dsn#">
		UPDATE PAGE_WARNINGS SET IS_ACTIVE = 0 WHERE W_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_active_id#">
	</cfquery>
	<cfif isdefined("attributes.is_close")>
		<script type="text/javascript">
			window.close();
		</script>
	</cfif>
</cfif>
<cfif isDefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1 and attributes.storageFilter eq 0>
    <cfinclude template="../query/get_warnings.cfm">
<cfelse>
	<cfset get_warnings.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_warnings.recordcount#">	
<cfset attributes.startrow = ( (attributes.page-1) * attributes.maxrows ) + 1>

<cffunction name="getEngLetterColor">
    <cfargument name="letter" required="yes">
    <!--- CF11 uyumluluğu için düzenlendi UH - 02/05/2020 --->
    <cfreturn "color-#trim(ReplaceList(UCase(arguments.letter),"Ç,Ğ,İ,Ö,Ş,Ü","C,G,I,O,S,U",true))#">
	<!--- <cfreturn "color-#trim(ReplaceListNoCase(arguments.letter,"Ç,Ğ,İ,Ö,Ş,Ü","C,G,I,O,S,U",true))#"> --->
</cffunction>

<cfquery name = "GET_PROCESS" datasource = "#dsn#">
    SELECT
        PROCESS_TYPE.PROCESS_ID,
        PROCESS_TYPE.PROCESS_NAME
    FROM
        PROCESS_TYPE
    WHERE
        PROCESS_TYPE.PROCESS_ID IS NOT NULL
        AND PROCESS_TYPE.IS_ACTIVE = 1
        AND PROCESS_ID IN
        (
            SELECT 
                PTOC.PROCESS_ID
            FROM 
                PROCESS_TYPE_OUR_COMPANY PTOC
            WHERE 
                PTOC.PROCESS_ID = PROCESS_TYPE.PROCESS_ID 
                AND PTOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        )
    ORDER BY PROCESS_NAME
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="warnings_form" id="warnings_form" method="post">
            <cfoutput>
                <cf_box_search>
                    <cfinput type="hidden" name="page_type" id="page_type" value="#attributes.page_type#">
                    <cfinput type="hidden" name="is_mandate" id="is_mandate" value="#attributes.is_mandate#">
                    <cfinput type="hidden" name="position_id" id="position_id" value="#get_pos_id.position_id#">
                    <cfinput type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
                    <cfinput type="hidden" name="view_mode" id="view_mode" value="#attributes.view_mode#">
                    <cfif attributes.fuseaction eq 'process.list_warnings'>
                        <cfinput type="hidden" name="reservedfuseaction" id="reservedfuseaction" value="process.list_warnings">
                    <cfelseif isdefined("attributes.reservedfuseaction") and len( attributes.reservedfuseaction )>
                        <cfinput type="hidden" name="reservedfuseaction" id="reservedfuseaction" value="#attributes.reservedfuseaction#">
                    <cfelse>
                        <cfinput type="hidden" name="reservedfuseaction" id="reservedfuseaction" value="#attributes.fuseaction#">
                    </cfif>
                    <div class="form-group">
                        <input type="text" name="keyword" id="keyword" maxlength="50" range="1,250" value="#attributes.keyword#" placeholder="<cfoutput>#getLang('','Filtre',57460)#</cfoutput>">
                    </div>
                    <div class="form-group">
                        <select name="process_id" id="process_id" onchange="getProcessRows(this)" onload="getProcessRows(this)">
                            <option value=""><cf_get_lang dictionary_id='58859.Süreç'></option>
                            <cfif GET_PROCESS.recordcount>
                                <cfloop query = "GET_PROCESS">
                                    <option value="#PROCESS_ID#" <cfif isDefined('attributes.process_id') and (attributes.process_id eq PROCESS_ID)> selected</cfif>>#PROCESS_NAME#</option>
                                </cfloop>
                            </cfif>
                        </select>
                    </div>
                    <div class="form-group">
                        <select name="process_row_id" id="process_row_id">
                            <option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
                        </select>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <input type="hidden" name="position_code" id="position_code" value="#attributes.position_code#">
                            <input type="hidden" name="employee_id" id="employee_id" value="#attributes.employee_id#">
                            <input type="text" name="employee_name" id="employee_name" value="#urlDecode(attributes.employee_name)#" placeholder="<cfoutput>#getLang('','Çalışan',57576)#</cfoutput>" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID,POSITION_CODE','employee_id,position_code','3','135');">
                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_name=warnings_form.employee_name&field_emp_id=warnings_form.employee_id&field_code=warnings_form.position_code&select_list=1');"></span>
                        </div>
                    </div>
                    <cfif attributes.page_type eq 1>
                        <div class="form-group">
                            <select name="action_table" id="action_table">
                                <option value=""><cf_get_lang dictionary_id='35007.Olay Kategorisi Seçiniz'></option>
                                <option value="OPPORTUNITIES" <cfif attributes.action_table is 'OPPORTUNITIES'>selected</cfif>><cf_get_lang dictionary_id='57612.Fırsat'></option>
                                <option value="OFFER" <cfif attributes.action_table is 'OFFER'>selected</cfif>><cf_get_lang dictionary_id='57545.Teklif'></option>
                                <option value="ORDERS" <cfif attributes.action_table is 'ORDERS'>selected</cfif>><cf_get_lang dictionary_id='40808.Siparişler'></option>
                                <option value="INTERNALDEMAND" <cfif attributes.action_table is 'INTERNALDEMAND'>selected</cfif>><cf_get_lang dictionary_id='30828.Talep'></option>
                                <option value="OFFTIME" <cfif attributes.action_table is 'OFFTIME'>selected</cfif>><cf_get_lang dictionary_id='30820.İzinler'></option>
                            </select>
                        </div>
                    </cfif>
                    <div class="form-group">
                        <div class="input-group">
                            <input type="text" name="start_response_date" id="start_response_date" maxlength="10" validate="#validate_style#" message="#getLang('','Son Cevap Tarihi',30767)#" value="#dateformat(attributes.start_response_date, dateformat_style)#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_response_date"></span>	
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <input type="text" name="finish_response_date" id="finish_response_date" maxlength="10" validate="#validate_style#" value="#dateformat(attributes.finish_response_date, dateformat_style)#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finish_response_date"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <select name="warning_condition" id="warning_condition">
                            <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                            <option value="0" <cfif isDefined('attributes.warning_condition') and (attributes.warning_condition eq 0)> selected</cfif>><cf_get_lang dictionary_id='58975.Giden'></option>
                            <option value="1" <cfif isDefined('attributes.warning_condition') and (attributes.warning_condition eq 1)> selected</cfif>><cf_get_lang dictionary_id='58974.Gelen'></option>
                        </select>
                    </div>
                    <div class="form-group">
                        <select name="warning_isactive" id="warning_isactive">
                            <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                            <option value="1"<cfif isDefined('attributes.warning_isactive') and (attributes.warning_isactive eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                            <option value="0"<cfif isDefined('attributes.warning_isactive') and (attributes.warning_isactive eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                        </select>
                    </div>
                    <div class="form-group">
                        <select name="process_mode" id="process_mode">
                            <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                            <option value="1"<cfif isDefined('attributes.process_mode') and (attributes.process_mode eq 1)> selected</cfif>><cf_get_lang dictionary_id='62204.Tekil Süreç'></option>
                            <option value="2"<cfif isDefined('attributes.process_mode') and (attributes.process_mode eq 2)> selected</cfif>><cf_get_lang dictionary_id='62205.Toplu Süreç'></option>
                        </select>
                    </div>
                    <div class="form-group small">
                        <input type="text" name="maxrows" id="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt sayısı Hatalı',41097)#" maxlength="3">
                    </div>
                    <div class="form-group">
                        <button type="submit" class="ui-btn ui-btn-green wrk_search_button" name="warning_submit_button" id="warning_submit_button" onclick="document.getElementById('view_mode').value = 'list'"><i class="fa fa-search"></i></button>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="ui-btn ui-btn-blue wrk_search_button" name="warning_view__mode" id="warning_view__mode" onclick="document.getElementById('view_mode').value = 'card'"><i class="fa fa-th-large"></i></button>
                    </div>
                </cf_box_search>
            </cfoutput>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Uyarı ve Onaylar',54356)#">
        <cfif attributes.view_mode eq 'list'>
            <cf_flat_list id="workflow_list">
                <thead>
                    <th style="width:250px"><cf_get_lang dictionary_id="58859.Süreç"></th>
                    <th style="width:180px">
                        <div class="item-send">
                            <span>
                                <small title="<cf_get_lang dictionary_id='57066.Gönderen'>">
                                    <cfsavecontent variable="title"><cf_get_lang dictionary_id='32571.Gönderen'></cfsavecontent>
                                    <cfoutput>#Left(title, 1)#</cfoutput>
                                </small>
                            </span>
                            <div class="smal-icon"><i class="fa fa-arrow-right"></i></div>
                            <span>
                                <small title="<cf_get_lang dictionary_id='64077.Alan'>">
                                    <cfsavecontent variable="title"><cf_get_lang dictionary_id='64077.Alan'></cfsavecontent>
                                    <cfoutput>#Left(title, 1)#</cfoutput>
                                </small>
                            </span>
                            <div class="smal-icon"><i class="fa fa-arrow-right"></i></div>
                            <span>
                                <small title="<cf_get_lang dictionary_id='31756.Bilgi Verilen'>">
                                    <cfsavecontent variable="title"><cf_get_lang dictionary_id='31756.Bilgi Verilen'></cfsavecontent>
                                    <cfoutput>#Left(title, 1)#</cfoutput>
                                </small>
                            </span>
                        </div>
                    </th>
                    <th style="width:100px;"><cf_get_lang dictionary_id='57500.Onay'></th>
                    <th style="width:130px;"><i title="<cf_get_lang dictionary_id='29513.Süre'>" class="icon-time margin-right-5"></i><cf_get_lang dictionary_id='47896.Bildirim Tarihi'></th>
                    <th style="width:250px"><cf_get_lang dictionary_id='57574.Şirket'> / <cf_get_lang dictionary_id='58472.Dönem'></th>
                    <th style="width:100px"><cf_get_lang dictionary_id='57880.Belge No'></th>
                    <th style="width:10px;">
                        <a href="javascript://"><i title="<cf_get_lang dictionary_id='62195.Ön Görünüm'>" class="fa fa-file" style="font-size:16px;"></i></a>
                    </th>	
                    <th style="width:10px;">
                        <a href="javascript://"><i title="<cf_get_lang dictionary_id='62196.Kaynak Belge'>" class="icon-detail" style="font-size:16px;"></i></a>
                    </th>
                    <th style="width:10px;">
                        <a href="javascript://">
                            <cfif isDefined("attributes.warning_isactive") and Len(attributes.warning_isactive) and attributes.warning_isactive eq 1>
                                <cfif attributes.page_type neq 3>
                                    <cfif get_warnings.recordcount><input type="checkbox" name="all_warnings" id="all_warnings" value="1" onClick="javascript:wrk_select_all('all_warnings','warning_ids');"></cfif>
                                </cfif>
                            </cfif>
                        </a>
                    </th>
                </thead>
                <tbody>
                    <cfif get_warnings.recordcount>
                        <cfset employee_list = "">
                        <cfset partner_list = "">
                        <cfset consumer_list = "">
                        <cfset position_code_list = "">
                        <cfset period_list = "">
                        <cfset our_company_list = "">
                        <cfoutput query="get_warnings" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfif len(record_emp) and not listfind(employee_list,record_emp)>
                                <cfset employee_list=listappend(employee_list,record_emp)>
                            </cfif>
                            <cfif len(position_code) and not listfind(position_code_list,position_code)>
                                <cfset position_code_list=listappend(position_code_list,position_code)>
                            </cfif>
                            <cfif len(record_par) and not listfind(partner_list,record_par)>
                                <cfset partner_list=listappend(partner_list,record_par)>
                            </cfif>
                            <cfif len(record_con) and not listfind(consumer_list,record_con)>
                                <cfset consumer_list=listappend(consumer_list,record_con)>
                            </cfif>
                            <cfif len(period_id) and not listfind(period_list,period_id)>
                                <cfset period_list=listappend(period_list,period_id)>
                            </cfif>
                            <cfif len(our_company_id) and not listfind(our_company_list,our_company_id)>
                                <cfset our_company_list=listappend(our_company_list,our_company_id)>
                            </cfif>
                        </cfoutput>
                        <cfif len(employee_list)>
                            <cfquery name="get_employees" datasource="#dsn#">
                                SELECT E.EMPLOYEE_ID, E.EMPLOYEE_NAME, E.EMPLOYEE_SURNAME, E.PHOTO, ED.SEX FROM EMPLOYEES AS E LEFT JOIN EMPLOYEES_DETAIL AS ED ON E.EMPLOYEE_ID = ED.EMPLOYEE_ID WHERE E.EMPLOYEE_ID IN (#employee_list#) ORDER BY E.EMPLOYEE_ID
                            </cfquery>
                            <cfset employee_list = listsort(listdeleteduplicates(valuelist(get_employees.employee_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(partner_list)>
                            <cfquery name="get_partners" datasource="#dsn#">
                                SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#partner_list#) ORDER BY PARTNER_ID
                            </cfquery>
                            <cfset partner_list = listsort(listdeleteduplicates(valuelist(get_partners.partner_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(consumer_list)>
                            <cfquery name="get_consumers" datasource="#dsn#">
                                SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME, PICTURE FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
                            </cfquery>
                            <cfset consumer_list = listsort(listdeleteduplicates(valuelist(get_consumers.consumer_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(position_code_list)>
                            <cfquery name="get_positions" datasource="#dsn#">
                                SELECT EP.POSITION_CODE, EP.EMPLOYEE_NAME, EP.EMPLOYEE_SURNAME, E.PHOTO, ED.SEX FROM EMPLOYEE_POSITIONS AS EP LEFT JOIN EMPLOYEES AS E ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID LEFT JOIN EMPLOYEES_DETAIL AS ED ON E.EMPLOYEE_ID = ED.EMPLOYEE_ID WHERE EP.POSITION_CODE IN (#position_code_list#) ORDER BY EP.POSITION_CODE
                            </cfquery>
                            <cfset position_code_list = listsort(listdeleteduplicates(valuelist(get_positions.position_code,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(period_list)>
                            <cfquery name="get_period" datasource="#dsn#">
                                SELECT PERIOD_ID, PERIOD FROM SETUP_PERIOD WHERE PERIOD_ID IN (#period_list#) ORDER BY PERIOD_ID
                            </cfquery>
                            <cfset period_list = listsort(listdeleteduplicates(valuelist(get_period.period_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(our_company_list)>
                            <cfquery name="get_company" datasource="#dsn#">
                                SELECT COMP_ID, COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID IN (#our_company_list#) ORDER BY COMP_ID
                            </cfquery>
                            <cfset our_company_list = listsort(listdeleteduplicates(valuelist(get_company.comp_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfform name="upd_warnings_active" id="upd_warnings_active" action="#request.self#?fuseaction=myhome.emptypopup_upd_list_warning" method="post">				
                            <input type="hidden" name="fuseaction_" id="fuseaction_" value="<cfoutput>#(isdefined('attributes.reservedfuseaction') and len(attributes.reservedfuseaction)) ? attributes.reservedfuseaction : attributes.fuseaction#</cfoutput>"><!--- Pasif Yap sayfasinda kullaniliyor --->
                            <cfoutput query="get_warnings" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <cfif find('popup',get_warnings.url_link)><cfset is_popup=1><cfelse><cfset is_popup=0></cfif><!---sayfa linki popup sa uyarıda açılacak sayfa popup açılıyor--->
                                    <cfset comp_control = ListFind(Comp_Id_Control_Tables,Action_Table) ? true : false />
                                    <cfset per_control = ListFind(Period_Id_Control_Tables,Action_Table) ? true : false />
                                <tr>
                                    <td>
                                    <div class="item-message">
                                        <cfif type eq 0>
        
                                            <cfif parent_id neq ''>
                                                <cfset parent_id_ = contentEncryptingandDecodingAES(isEncode:1,content:parent_id,accountKey:'wrk')>
                                                <cfset w_id_ = contentEncryptingandDecodingAES(isEncode:1,content:w_id,accountKey:'wrk')>
                                                <!--- <a href="##" onClick="warning_redirect('0','#url_link#','#parent_id#','#is_popup#','#w_id#',{ comp_control: #comp_control#, comp_id: '#OUR_COMPANY_ID#', per_control: #per_control#, per_id: '#PERIOD_ID#' },'#parent_id_#','#w_id_#');" class="tableyazi">#warning_head#</a> --->
                                                <div class="desktop other-message other-messsage-bold">#warning_head#</div>
                                                <div class="mobil other-message other-messsage-bold color-#Left(Trim(warning_head), 1)#">#warning_head#</div>
                                            <cfelse>
                                                <div class="other-message color-#Left(Trim(warning_head), 1)#">#warning_head#</div>
                                            </cfif>
        
                                        <cfelse>
                                            <div class="other-message color-#Left(Trim(warning_head), 1)#">#warning_head#</div>
                                        </cfif>
        
                                        <div class="other-message "><cfif len(warning_description) lt 31>#HTMLEditFormat(warning_description)#<cfelse>#Left(HTMLEditFormat(warning_description),31)#...</cfif></div>
                                        <cfif len( pwa_warning_description ) and warning_description neq pwa_warning_description>
                                            <div class="other-message "><cfif len(pwa_warning_description) lt 31>#HTMLEditFormat(pwa_warning_description)#<cfelse>#Left(HTMLEditFormat(pwa_warning_description),31)#...</cfif></div>
                                        </cfif>
                                    </td>
                                    <td>
                                        <div class="item-send">
                                            <cfif len(record_emp)>
                                                <cfif len(get_employees.photo[listfind(employee_list,record_emp,',')]) and FileExists("#upload_folder#hr\#get_employees.photo[listfind(employee_list,record_emp,',')]#")>
                                                    <div class="senderPerson">
                                                        #(Len(IS_MANDATE) and IS_MANDATE eq 1 ) ? "<b style='margin:0 6px 0 -17px;'>V</b>" : ""#
                                                        <img class="img-circle" width="30" height="30" src="../documents/hr/#get_employees.photo[listfind(employee_list,record_emp,',')]#"/>
                                                        <div class="custom-tlt">#(Len(IS_MANDATE) and IS_MANDATE eq 1 ) ? "Vekaleten : " : ""##get_employees.employee_name[listfind(employee_list,record_emp,',')]# #get_employees.employee_surname[listfind(employee_list,record_emp,',')]#</div>
                                                    </div>
                                                <cfelse>
                                                    <span class="#getEngLetterColor(Left(get_employees.employee_name[listfind(employee_list,record_emp,',')], 1))#" style="height:30px;width:30px;">
                                                        #(Len(IS_MANDATE) and IS_MANDATE eq 1 ) ? "<b style='margin:0 6px 0 -17px;'>V</b>" : ""#
                                                        <small>#Left(get_employees.employee_name[listfind(employee_list,record_emp,',')], 1)##Left(get_employees.employee_surname[listfind(employee_list,record_emp,',')], 1)#</small>
                                                        <div class="custom-tlt">#(Len(IS_MANDATE) and IS_MANDATE eq 1 ) ? "Vekaleten : " : ""##get_employees.employee_name[listfind(employee_list,record_emp,',')]# #get_employees.employee_surname[listfind(employee_list,record_emp,',')]#</div>
                                                    </span>
                                                </cfif>	
                                            <cfelseif len(record_par)>
                                                <cfif len(get_partners.photo[listfind(partner_list,record_par,',')]) and FileExists("#upload_folder#hr/#get_partners.photo[listfind(partner_list,record_par,',')]#")>
                                                    <div class="senderPerson">
                                                        #(Len(IS_MANDATE) and IS_MANDATE eq 1 ) ? "<b style='margin:0 6px 0 -17px;'>V</b>" : ""#
                                                        <img class="img-circle" width="30" height="30" src="#upload_folder#hr/#get_partners.photo[listfind(partner_list,record_par,',')]#"/>
                                                        <div class="custom-tlt">#(Len(IS_MANDATE) and IS_MANDATE eq 1 ) ? "Vekaleten : " : ""##get_partners.company_partner_name[listfind(partner_list,record_par,',')]# #get_partners.company_partner_surname[listfind(partner_list,record_par,',')]#</div>
                                                    </div>
                                                <cfelse>
                                                    <span class="#getEngLetterColor(Left(get_partners.company_partner_name[listfind(partner_list,record_par,',')], 1))#">
                                                        <small class="avatext onlineusers">#Left(get_partners.company_partner_name[listfind(partner_list,record_par,',')], 1)##Left(get_partners.company_partner_surname[listfind(partner_list,record_par,',')], 1)#</small>
                                                    </span>
                                                </cfif>
                                            <cfelseif len(record_con)>
                                                <cfif len(get_consumers.picture[listfind(consumer_list,record_con,',')]) and FileExists("#upload_folder#hr/#get_consumers.picture[listfind(consumer_list,record_con,',')]#")>
                                                    <div class="senderPerson">
                                                        <img class="img-circle" width="30" height="30" src="#upload_folder#hr/#get_consumers.picture[listfind(consumer_list,record_con,',')]#"/>
                                                    </div>
                                                <cfelse>
                                                    <span class="#getEngLetterColor(Left(get_consumers.consumer_name[listfind(consumer_list,record_con,',')], 1))#">
                                                        <small class="avatext onlineusers">#Left(get_consumers.consumer_name[listfind(consumer_list,record_con,',')], 1)##Left(get_consumers.consumer_surname[listfind(consumer_list,record_con,',')], 1)#</small>
                                                    </span>
                                                </cfif>
                                            </cfif>
                                            <div class="smal-icon"><i class="fa fa-arrow-right"></i></div>
                                            <cfif Len(position_code)>
                                                <cfif len(get_positions.photo[listfind(position_code_list,position_code,',')]) and FileExists("#upload_folder#hr\#get_positions.photo[listfind(position_code_list,position_code,',')]#")>
                                                    <div class="senderPerson">
                                                        <img class="img-circle" width="30" height="30" src="../documents/hr/#get_positions.photo[listfind(position_code_list,position_code,',')]#"/>
                                                        <div class="custom-tlt">#get_positions.employee_name[listfind(position_code_list,position_code,',')]# #get_positions.employee_surname[listfind(position_code_list,position_code,',')]#</div>
                                                    </div>
                                                <cfelse>
                                                    <span class="#getEngLetterColor(Left(get_positions.employee_name[listfind(position_code_list,position_code,',')], 1))#" style="height:30px;width:30px;">
                                                        <small>
                                                            #Left(get_positions.employee_name[listfind(position_code_list,position_code,',')], 1)##Left(get_positions.employee_surname[listfind(position_code_list,position_code,',')], 1)#
                                                        </small>
                                                        <div class="custom-tlt">#get_positions.employee_name[listfind(position_code_list,position_code,',')]# #get_positions.employee_surname[listfind(position_code_list,position_code,',')]#</div>
                                                    </span>
                                                </cfif>
                                            </cfif>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="item-act">
                                            <!--- 
                                                Süreç aşamasında 
                                                    onay iste seçilmişse ve belge kaydı sonrasında uyarı olarak kaydedilmişse,
                                                    Önizleme zorunlu olsun seçilmemişse,
                                                    Belge detayını görmek zorunlu olsun seçilmemişse
                                            --->
                                            <cfif is_required_preview eq 0 and is_required_action_link eq 0 and is_notification eq 0>
                                                <cfif type eq 0>
                                                    <cfif is_confirm eq 1>
                                                        <cfif not len(PWA_WARNING_ID) and newPositionCode eq POSITION_CODE>
                                                            <span class="popover fa fa-2x fa-thumbs-o-up noAction" onclick="actionClick(this,'valid',#w_id#,#IS_CONFIRM_COMMENT_REQUIRED#, { comp_control: #comp_control#, comp_id: '#OUR_COMPANY_ID#', per_control: #per_control#, per_id: '#PERIOD_ID#' })">
                                                                <div class="custom-tlt"><cf_get_lang dictionary_id ='58475.Onayla'></div>
                                                            </span>
                                                        <cfelseif len(PWA_IS_CONFIRM)>
                                                            <span class="popover fa fa-2x fa-thumbs-o-up #iif((PWA_IS_CONFIRM eq 0), DE('passiveAction'), DE('activeAction'))#" <cfif PWA_IS_CONFIRM eq 1> </cfif>>
                                                                <div class="custom-tlt"><cf_get_lang dictionary_id ='58699.Onaylandı'></div>
                                                            </span>
                                                        <cfelse>
                                                            <span class="popover fa fa-2x fa-thumbs-o-up"></span>
                                                        </cfif>
                                                    </cfif>
                                                    <cfif is_refuse eq 1>
                                                        <cfif not len(PWA_WARNING_ID) and newPositionCode eq POSITION_CODE>
                                                            <span class="popover fa fa-2x fa-thumbs-o-down ml-2 noAction" onclick="actionClick(this,'refusal',#w_id#,#IS_REFUSE_COMMENT_REQUIRED#, { comp_control: #comp_control#, comp_id: '#OUR_COMPANY_ID#', per_control: #per_control#, per_id: '#PERIOD_ID#' })">
                                                                <div class="custom-tlt"><cf_get_lang dictionary_id='58461.Reddet'></div>
                                                            </span>
                                                        <cfelseif len(PWA_IS_REFUSE)>
                                                            <span class="popover fa fa-2x fa-thumbs-o-down ml-2 #iif((PWA_IS_REFUSE eq 0), DE('passiveAction'), DE('activeAction'))#" <cfif PWA_IS_REFUSE eq 1> </cfif>>
                                                                <div class="custom-tlt"><cf_get_lang dictionary_id='57617.Reddedildi'></div>
                                                            </span>
                                                        <cfelse>
                                                            <span class="popover fa fa-2x fa-thumbs-o-down ml-2"></span>
                                                        </cfif>
                                                    </cfif>
                                                    <cfif is_again eq 1>
                                                        <cfif not len(PWA_WARNING_ID) and newPositionCode eq POSITION_CODE>
                                                            <span class="popover fa fa-2x fa-rotate-right ml-2 noAction" onclick="actionClick(this,'again',#w_id#,#IS_AGAIN_COMMENT_REQUIRED#, { comp_control: #comp_control#, comp_id: '#OUR_COMPANY_ID#', per_control: #per_control#, per_id: '#PERIOD_ID#' })">
                                                                <div class="custom-tlt"><cf_get_lang dictionary_id='57214.Tekrar Yap'></div>
                                                            </span>
                                                        <cfelseif len(PWA_IS_AGAIN)>
                                                            <span class="popover fa fa-2x fa-rotate-right ml-2 #iif((PWA_IS_AGAIN eq 0), DE('passiveAction'), DE('activeAction'))#" <cfif PWA_IS_AGAIN eq 1></cfif>>
                                                                <div class="custom-tlt"><cf_get_lang dictionary_id='60112.Tekrar yapılması istendi'></div>
                                                            </span>
                                                        <cfelse>
                                                            <span class="popover fa fa-2x fa-rotate-right ml-2"></span>
                                                        </cfif>
                                                    </cfif>
                                                    <cfif is_support eq 1>
                                                        <cfif not len(PWA_WARNING_ID) and newPositionCode eq POSITION_CODE>
                                                            <span class="popover fa fa-2x fa-support ml-2 noAction" onclick="actionClick(this,'support',#w_id#,#IS_SUPPORT_COMMENT_REQUIRED#, { comp_control: #comp_control#, comp_id: '#OUR_COMPANY_ID#', per_control: #per_control#, per_id: '#PERIOD_ID#' })">
                                                                <div class="custom-tlt"><cf_get_lang dictionary_id='57218.Başkasına Gönder'> / <cf_get_lang dictionary_id='57226.Destek Al'></div>
                                                            </span>
                                                        <cfelseif len(PWA_IS_SUPPORT)>
                                                            <span class="popover fa fa-2x fa-support ml-2 #iif((PWA_IS_SUPPORT eq 0), DE('passiveAction'), DE('activeAction'))#" <cfif PWA_IS_SUPPORT eq 1></cfif>>
                                                                <div class="custom-tlt"><cf_get_lang dictionary_id='60113.Destek alınması istendi'></div>
                                                            </span>
                                                        <cfelse>
                                                            <span class="popover fa fa-2x fa-support ml-2"></span>
                                                        </cfif>
                                                    </cfif>
                                                    <cfif is_cancel eq 1>
                                                        <cfif not len(PWA_WARNING_ID) and newPositionCode eq POSITION_CODE>
                                                            <span class="popover fa fa-2x fa-cut ml-2 noAction" onclick="actionClick(this,'cancel',#w_id#,#IS_CANCEL_COMMENT_REQUIRED#, { comp_control: #comp_control#, comp_id: '#OUR_COMPANY_ID#', per_control: #per_control#, per_id: '#PERIOD_ID#' })">
                                                                <div class="custom-tlt"><cf_get_lang dictionary_id='58506.İptal'></div>
                                                            </span>
                                                        <cfelseif len(PWA_IS_CANCEL)>
                                                            <span class="popover fa fa-2x fa-cut ml-2 #iif((PWA_IS_CANCEL eq 0), DE('passiveAction'), DE('activeAction'))#" <cfif PWA_IS_CANCEL eq 1></cfif>>
                                                                <div class="custom-tlt"><cf_get_lang dictionary_id='59190.İptal Edildi'></div>
                                                            </span>
                                                        <cfelse>
                                                            <span class="popover fa fa-2x fa-cut ml-2"></span>
                                                        </cfif>
                                                    </cfif>
                                                </cfif>
                                                <cfif COMMENT_REQUEST eq 1>
                                                    <cfif not len(PWA_WARNING_ID) and newPositionCode eq POSITION_CODE>
                                                        <span class="popover fa fa-2x fa-comment-o ml-2 noAction" onclick="actionClick(this,'comment',#w_id#,1, { comp_control: #comp_control#, comp_id: '#OUR_COMPANY_ID#', per_control: #per_control#, per_id: '#PERIOD_ID#' })">
                                                            <div class="custom-tlt"><cf_get_lang dictionary_id='32970.Yorum Yap'></div>
                                                        </span>
                                                    <cfelse>
                                                        <span class="popover fa fa-2x fa-comment-o ml-2"></span>
                                                    </cfif>
                                                </cfif>
                                            </cfif>
                                        </div>
                                    </td>
                                    <td>
                                        <cfset last_time = ((ANSWER_HOUR*60)+ANSWER_MINUTE)-DateDiff("n", record_date, Now())>
                                        <cfset last_h = Int(last_time/60)>
                                        <cfset last_m = Int(last_time-(last_h*60))>
                                        <span class="popover icon-time margin-right-5 <cfif last_h lt 0> font-red-flamingo <cfelse> font-green-jungle </cfif>">                                    
                                            <!--- #last_h#h #last_m#m  --->
                                            <div class="custom-tlt <cfif last_h lt 0> font-red-flamingo <cfelse> font-green-jungle </cfif>">#last_h#h #last_m#m</div>
                                        </span>
                                        #dateformat(record_date,dateformat_style)# #timeformat(record_date,timeformat_style)#
                                    </td>
                                    <td>
                                        <cfif isdefined("period_id") and len(period_id)>
                                            #get_period.period[listfind(period_list,period_id,',')]#
                                            <cfinput type="hidden" name="comp_name#w_id#" id="comp_name#w_id#" value="#get_period.period[listfind(period_list,period_id,',')]#">
                                        <cfelseif isdefined("our_company_id") and len(our_company_id)>
                                            #get_company.company_name[listfind(our_company_list,our_company_id,',')]#
                                            <cfinput type="hidden" name="comp_name#w_id#" id="comp_name#w_id#" value="#get_company.company_name[listfind(our_company_list,our_company_id,',')]#">					
                                        </cfif>
                                    </td>
                                    <td>
                                        #len(GENERAL_PAPER_NO) 
                                            ? GENERAL_PAPER_NO 
                                            : ( (len( PAPER_NO ) and PAPER_NO neq 0) ? PAPER_NO : (ACTION_ID neq 0 ? ACTION_ID : ''))#
                                    </td>
                                    <td>
                                        <cfif type eq 0>
                                            <cfset firstLink = ( len( GENERAL_PAPER_ID ) ) ? "#url_link#&gp_id=#GENERAL_PAPER_ID#" : url_link>
                                            <cfset firstLink_ = ( len( ACTION_LIST_ID ) ) ? "#firstLink#&action_list_id=#ACTION_LIST_ID#" : url_link>
                                            <cfset url_link_flow = "#firstLink_#&wrkflow=1#len(WSR_CODE) ? '&wsr_code=' & WSR_CODE : ''#">
                                            <cfset oldFuseaction = ReplaceNoCase(ListFirst(ListLast( url_link_flow, "?"),"&"),"fuseaction=","")>
                                            <cfset oldEvent = ReplaceNoCase(listGetAt(ListLast( url_link_flow, "?"),2,"&"),"event=","")>
                                            <cfset newUrlLink = ( len( DESTINATION_WO ) ? ReplaceNoCase(url_link_flow, oldFuseaction, Trim(DESTINATION_WO) ) : url_link_flow )>
                                            <cfset newUrlLink = ( len( DESTINATION_EVENT ) ? ReplaceNoCase(newUrlLink, oldEvent, Trim(DESTINATION_EVENT) ) : newUrlLink )>
                                            <cfset newFuseaction = ( len( DESTINATION_WO ) ? DESTINATION_WO : oldFuseaction )>
                                            <cfset previewParams = 'action=#oldFuseaction##( not IS_MANUEL_NOTIFICATION ) ? '&action_id=' & ACTION_ID : "&parent_id=" & PARENT_ID##len( GENERAL_PAPER_ID ) ? '&gp_id=' & GENERAL_PAPER_ID : ""#&position_code=#newPositionCode#'>
                                            <cfset url_module = listFirst(newFuseaction,".") />
                                            <cfset comp_control = ListFind(use_company_module,url_module) ? true : false />
                                            <cfset per_control = ListFind(use_period_module,url_module) ? true : false />
                                            <a title="<cf_get_lang dictionary_id='62195.Preview'>" href="javascript://" onclick="goToDetail('preview','#w_id#',{ comp_control: #comp_control#, comp_id: '#OUR_COMPANY_ID#', per_control: #per_control#, per_id: '#PERIOD_ID#' },'#previewParams#');"><i class="fa fa-file" style="font-size:16px;#( is_required_preview eq 1 ) ? 'color:##ff5c5c !important;' : ''#"></i></a>
                                        </cfif>
                                    </td>
                                    <td>
                                        <cfif type eq 0><!--- Uyari/Onaylar --->
                                            <cfset parent_id_ = len( parent_id ) ? contentEncryptingandDecodingAES(isEncode:1,content:parent_id,accountKey:'wrk') : ''>
                                            <cfset w_id_ = contentEncryptingandDecodingAES(isEncode:1,content:w_id,accountKey:'wrk')>
                                            <a href="javascript://" onClick="warning_redirect('1','#newUrlLink#','#parent_id#','#is_popup#','#w_id#',{ comp_control: #comp_control#, comp_id: '#OUR_COMPANY_ID#', per_control: #per_control#, per_id: '#PERIOD_ID#' },'#parent_id_#','#w_id_#');"><i class="icon-detail" title="<cf_get_lang dictionary_id='41669.Kaynak'> <cf_get_lang dictionary_id ='57468.Belge'>" style="font-size:16px; #( is_required_action_link eq 1 ) ? 'color:##ff5c5c !important;' : ''#"></i></a>
                                        </cfif>
                                    </td>
                                    <td>
                                        <cfif isDefined("attributes.warning_isactive") and attributes.warning_isactive eq 1 and attributes.page_type neq 3>
                                            <a href="javascript://"><cfif type eq 0><input type="checkbox" name="warning_ids" id="warning_ids" value="#w_id#"></cfif></a>
                                        </cfif>
                                    </td>
                                    <!-- sil -->
                                    <div id="warning_comment#currentrow#" style="display:none;" class="no-hover">
                                        <div>
                                            <div id="warning_divs#currentrow#"></div>
                                        </div>
                                    </div>
                                </tr>
                            </cfoutput>
                            <input type="hidden" name="valid_ids" id="valid_ids" value="">
                            <input type="hidden" name="refusal_ids" id="refusal_ids" value=""><!--- Onay ve Redlerin Toplu Gonderimi Icin Eklendi --->
                        </cfform>
                    <cfelse>
                        <tr><td colspan="9"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayit Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td></tr>
                    </cfif>
                    <cfscript>
                        url_str = "";
                        if(isdefined("attributes.keyword") and len(attributes.keyword)) url_str = "#url_str#&keyword=#attributes.keyword#";
                        if(isdefined("attributes.process_id") and len(attributes.process_id))url_str='#url_str#&process_id=#attributes.process_id#';
                        if(isdefined("attributes.process_row_id") and len(attributes.process_row_id))url_str='#url_str#&process_row_id=#attributes.process_row_id#';
                        if(isdefined("attributes.employee_name") and len(attributes.employee_name)) url_str='#url_str#&employee_id=#attributes.employee_id#&position_code=#attributes.position_code#&employee_name=#attributes.employee_name#';
                        if(isdefined("attributes.start_response_date") and len(attributes.start_response_date))url_str = "#url_str#&start_response_date=#dateformat(attributes.start_response_date,dateformat_style)#";
                        if(isdefined("attributes.finish_response_date") and len(attributes.finish_response_date))url_str = "#url_str#&finish_response_date=#dateformat(attributes.finish_response_date,dateformat_style)#";
                        if(isdefined("attributes.warning_condition"))url_str='#url_str#&warning_condition=#attributes.warning_condition#';
                        if(isdefined("attributes.warning_isactive"))url_str='#url_str#&warning_isactive=#attributes.warning_isactive#';
                        if(isdefined("attributes.process_mode") and len(attributes.process_mode))url_str='#url_str#&process_mode=#attributes.process_mode#';
                        if(isdefined("attributes.maxrows"))url_str='#url_str#&maxrows=#attributes.maxrows#';
                        if(isdefined("attributes.page_type") and len(attributes.page_type))url_str='#url_str#&page_type=#attributes.page_type#';
                        if(isdefined("attributes.is_mandate") and len(attributes.is_mandate))url_str='#url_str#&is_mandate=#attributes.is_mandate#';
                        if(isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)) url_str='#url_str#&is_form_submitted=#attributes.is_form_submitted#';
                        if(isdefined("attributes.reservedfuseaction") and len(attributes.reservedfuseaction))url_str='#url_str#&reservedfuseaction=#attributes.reservedfuseaction#';
                        if(isdefined("attributes.list_type") and len(attributes.list_type))url_str='#url_str#&list_type=#attributes.list_type#';
                        if(isdefined("attributes.process_type_warning") and len(attributes.process_type_warning))url_str='#url_str#&process_type_warning=#attributes.process_type_warning#';
                        if(isdefined("attributes.action_table") and len(attributes.action_table))url_str='#url_str#&action_table=#attributes.action_table#';
                    </cfscript>
                </tbody>
            </cf_flat_list>
            <cfif isDefined("attributes.warning_isactive") and Len(attributes.warning_isactive) and attributes.warning_isactive eq 1>
                <div class="ui-form-list-btn">
                    <div>
                        <a href="javascript://" class="ui-btn ui-btn-success" name="passive" id="passive" onClick="uyari_kontrol();"><cf_get_lang dictionary_id='48241.Seçili olanları tekrar gösterme'></a>
                    </div>
            
                </div>
            </cfif>
            <cf_paging
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                isAjax="true"
                target="warnings_div_"
                adres="#attributes.fuseaction##url_str#">
        <cfelseif attributes.view_mode eq 'card'>
            <div class="ui-dashboard ui-dashboard_type3">
                <cfif get_warnings.recordcount>
                    <cfquery name = "get_process" datasource="#dsn#" dbtype="query">
                        SELECT
                            PROCESS_ID, PROCESS_NAME, SUM(PROCESS_STAGE_COUNT) AS PROCESS_STAGE_COUNT
                        FROM GET_WARNINGS 
                        GROUP BY PROCESS_ID, PROCESS_NAME
                    </cfquery>
                    <cfoutput query="get_process">
                        <div class="ui-dashboard-item">
                            <div class="ui-dashboard-item-title">
                                #PROCESS_NAME#
                            </div>
                            <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
                                <a href="javascript://">
                                    #PROCESS_STAGE_COUNT# - <cf_get_lang dictionary_id='57492.Toplam'>
                                </a>
                                <cfquery name="get_process_stage" datasource="#dsn#" dbtype="query">
                                    SELECT PROCESS_ROW_ID, STAGE, PROCESS_STAGE_COUNT FROM GET_WARNINGS WHERE PROCESS_ID = #PROCESS_ID# ORDER BY STAGE ASC
                                </cfquery>
                                <cfif get_process_stage.recordcount>
                                    <cfloop query="get_process_stage">
                                        <a style="background-color:##9E9E9E;" href="javascript://" onclick="setProcess('#get_process.PROCESS_ID#','#get_process_stage.PROCESS_ROW_ID#')">
                                            #get_process_stage.PROCESS_STAGE_COUNT# - #get_process_stage.STAGE#
                                        </a>
                                    </cfloop>
                                </cfif>
                            </div>
                        </div>
                            
                    </cfoutput>
                <cfelse>
                    <div class="pdn-r-0 pt-3"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayit Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</div>
                </cfif>
            </div>
        </cfif>
    </cf_box>
    <cfif attributes.fuseaction eq 'process.list_warnings' or (isDefined("attributes.reservedfuseaction") and attributes.reservedfuseaction eq 'process.list_warnings') and attributes.view_mode eq 'list'>
        <cfsavecontent variable='boxTitle'><cf_get_lang dictionary_id = '60444.Süreç Aktarımı'></cfsavecontent>
        <cf_box title="#boxTitle#">
            <!--- <h5 class="padding-5"><cf_get_lang dictionary_id = '60445.Seçili Süreç / Aşamaları aktarmak için ilgili yetkiliyi seçiniz'></h5> --->
            <div class="ui-form-list ui-form-block">
                <div class="col col-2 col-md-2 col-sm-2 col-xs-12 padding-0">
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12 padding-0">
                        <label><cf_get_lang dictionary_id="57467.Not"></label>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <textarea name="process_note" id="process_note"></textarea>
                        </div>
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12 padding-0">
                        <label><cf_get_lang dictionary_id="57578.Yetkili">*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="responsible_employee_pos" id="responsible_employee_pos">
                                <input type="hidden" name="responsible_employee_id" id="responsible_employee_id" >
                                <input type="text" name="responsible_employee" id="responsible_employee" onFocus="AutoComplete_Create('responsible_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3,9\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'1\'','EMPLOYEE_ID,POSITION_CODE','responsible_employee_id,responsible_employee_pos','','3','135');" />
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&field_emp_id=responsible_employee_id&field_name=responsible_employee&field_code=responsible_employee_pos&select_list=1,9','list');"></span>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <a href="javascript://" class="ui-btn ui-btn-success" onClick="uyari_kontrol('changeprocessuser');"><cf_get_lang dictionary_id='58676.Aktar'></a>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box>
    </cfif>
</div>
<script type="text/javascript"> 
	$(function(){

        <!--- Workflow detaydan listeye dönüşte localstorge içerisindeki değerleri form elemanlarına doldurur! --->
        <cfif attributes.storageFilter eq 1>
            for( var i = 0; i < localStorage.length; i++ ){ 
                if( document.getElementById( localStorage.key(i) ) != undefined )
                    document.getElementById( localStorage.key(i) ).value = localStorage.getItem( localStorage.key(i) );
            }
            setTimeout(() => { $("#warnings_form").submit(); }, 500);
        </cfif>

        if( window.outerWidth <= 768 ){
            $(".warning_container").css({ "padding-top" : "64px" });
            $(".flowcard-header label").css({ "width" : "50px", "text-align" : "center" }).find("i:last-child").hide();
        }

        $( window ).resize(function(){ 
            if( window.outerWidth <= 768 ){
                $(".warning_container").css({ "padding-top" : "64px" });
                $(".flowcard-header label").css({ "width" : "75px", "text-align" : "center" }).find("i:last-child").hide();
            }else{
                $(".warning_container").css({ "padding-top" : "0px" });
                $(".flowcard-header label").css({ "width" : "auto", "text-align" : "left" }).find("i:last-child").show();
            }
        });
        
        var elem = $('table.ajax_list'), id, elem_tr = [];
	    if(elem.length > 0){
		    $.each(elem, function(i){
			    id = elem.eq(i).attr("id");
			    $.each(elem.eq(i).find('tbody tr'), function(i){
				    if($(this).find('td').length != 1){
					    for(var k=0; k<$(this).parents('table').find('thead th').length; k++){
						    if($(this).parents('table').find('thead th').eq(k).html() != undefined && $(this).find('td').eq(k).html() != undefined){
							    elem_tr.push({"id":id, "indis":k, "th":$(this).parents('table').find('thead th').eq(k).html(), "td":$(this).find('td').eq(k).html()});
						    }
					    }
				    }
			    });  
			    if($(window).width() < 568){
				    var newTable = $('<table id="mobil'+id+'" class="ajax_list"></table>');
				    elem.eq(i).before(newTable);
				    /*elem.eq(i).parent().prepend('<ul class="ui-icon-list flex-right"><li><a id="standart_design" href="javascript://"><i class="fa fa-laptop"></i></a></li><li><a id="mobil_design" href="javascript://"><i class="fa fa-tablet"></i></a></li></ul>'); */
			    }
		    })
		    if($(window).width() < 568){
			    $.each(elem_tr, function(i){
				    var seperator = $('#'+this.id).find('thead th').length;
				    if(i != 0 && this.indis === 0){
					    $('#mobil'+this.id).append('<tr class="ui-line-bg"><td colspan="'+ seperator +'"></td></tr>');
					    $('#mobil'+this.id).append('<tr class="ui-line"><td colspan="'+ seperator +'"></td></tr>');
					    $('#mobil'+this.id).append('<tr class="ui-line-bg"><td colspan="'+ seperator +'"></td></tr>');
					    $('#mobil'+this.id).append('<tr indis="'+this.indis+'"><td style="background-color:#f9f9f9;">'+ this.th +'</td><td>'+ this.td +'</td></tr>');
				    }
				    else{
					    $('#mobil'+this.id).append('<tr indis="'+this.indis+'"><td style="background-color:#f9f9f9;">'+ this.th +'</td><td>'+ this.td +'</td></tr>');
				    }
                });
		    }
	    }

		$('td span, td div.senderPerson').hover(function(){
			$(this).find('.custom-tlt').stop().fadeToggle();
		});
    
        $("#warnings_form").submit(function(){
            date1 = document.getElementById('start_response_date').value;
            document.getElementById('start_response_date').value = date1.replace(/\*/g,"/");
            date1_ = document.getElementById('start_response_date');

            date2 = document.getElementById('finish_response_date').value;
            document.getElementById('finish_response_date').value = date2.replace(/\*/g,"/");
            date2_ = document.getElementById('finish_response_date');
            if(date1_.value.length == 10 && date2_.value.length == 10)
            {
                if(!date_check(date1_,date2_,"<cfoutput>#getLang('asset',96)#</cfoutput>")) return false;
                else{
                    ///Filtreleri localStorage'a doldurur!
                    if (typeof(Storage) !== "undefined") {
                        var formAll = $(this).serializeArray();
                        var form = $(this).serialize();
                        formAll.forEach(el => { localStorage.setItem(el.name, el.value); });
                    }
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.get_warnings_content&' + form, 'warnings_div_', 1);
                }
            }
            else
            {
                alert("<cf_get_lang dictionary_id='40466.Lütfen Tarih Değerlerini Eksiksiz Doldurunuz'>");
                return false;
            }
            return false;
        });

	});

	var check_list = 0;
	
    function controlPerComp( perCompControlSettings ){

        if(( perCompControlSettings.comp_control && perCompControlSettings.comp_id != '' && perCompControlSettings.comp_id != <cfoutput>#session.ep.company_id#</cfoutput>) || ( perCompControlSettings.per_control && perCompControlSettings.per_id != '' && perCompControlSettings.per_id != <cfoutput>#session.ep.period_id#</cfoutput>))   
		{
            $('.ui-cfmodal__alert .required_list li').remove();
            $('.ui-cfmodal__alert .ui-form-list-btn').remove();
            $('.ui-cfmodal__alert .required_list').append('<li><cfoutput>#getLang("","Bu işlem oturum açtığınız şirket ya da dönemde değil",62369)#</cfoutput></li>');
            $('.ui-cfmodal__alert .required_list').append('<li><cfoutput>#getLang("","İşlem yapılmak istenen Şirket-Dönem",62371)#</cfoutput> : '+perCompControlSettings.cmpName+'</li>');
            $('.ui-cfmodal__alert .required_list').append('<li><cfoutput>#getLang("","Aktif Oturum Şirketi-Dönem",62370)#</cfoutput> : <cfoutput>#session.ep.company# #session.ep.period_year#</cfoutput></li>');
            $('.ui-cfmodal__alert .required_list').append('<div class="ui-form-list-btn"><a href="javascript://" class="ui-btn ui-btn-success mt-3" onclick="changePerComp(\''+ perCompControlSettings.per_id +'\');"><cfoutput>#getLang('','Değiştir',47334)#</cfoutput></a></div>');
            $('.ui-cfmodal__alert').fadeIn();
            return false;
		}
        return true;

    }

	function actionClick( el, type, id, commentRequired, perCompControlSettings) {
        
        perCompControlSettings.cmpName = $("#comp_name"+id+"").val();
        if(controlPerComp( perCompControlSettings )){
            $("div[role = tooltip]").hide();
            if(!$(el).closest("tr").next("tr").hasClass('actionNoteArea')) $(el).closest("tr").after("<tr class='actionNoteArea' style='border-color:#44b6ae;'><td colspan='8'><div id='actionNoteArea_"+id+"' style='padding:10px 0;'></div></td></tr>").css({ "border-color":"#44b6ae" });
            var mandatePositionCode = (document.getElementById("is_mandate").value == 1) ? document.getElementById("position_code").value : "";
            AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_list_warning&mode=getactionnote&fuseaction_='+document.getElementById("fuseaction_").value+'&type='+type+'&id='+id+'&comment_required='+commentRequired+'&mandate_position_code='+mandatePositionCode+'','actionNoteArea_'+id+'');
            return false;
        }
	}
    function goToDetail( type, id, perCompControlSettings, url ) {

        perCompControlSettings.cmpName = $("#comp_name"+id+"").val();
        if(controlPerComp( perCompControlSettings )){
            if( type == 'preview' ) openTab(3, url);
            else if( type == 'source' ) window.open(url,"_blank");
        }

    }
	function uyari_kontrol( mode = "setPassive" )
	{
        var url = '';
		check_list = 0;
		is_secili = 0;
		if(document.getElementsByName("warning_ids").length != undefined) /*n tane*/
		{	
			for (var i=0; i < document.getElementsByName("warning_ids").length; i++)
			{
				if((document.getElementsByName("warning_ids")[i].checked==true)){
                    check_list = check_list + "," + document.getElementsByName("warning_ids")[i].value;
                    window.warningCounter.warningCounter--;
					is_secili = 1;
				}
			}
		}
		else
		{
			if((document.upd_warnings_active.warning_ids.checked==true))
				is_secili = 1;
		}
		
		if(is_secili==0)
		{
			alert('<cf_get_lang dictionary_id="59950.Uyarı Seçmelisiniz">!');
			return false;
		}
		else
		{
            if( mode == 'setPassive' ){
                url = '<cfoutput>#request.self#?fuseaction=myhome.emptypopup_upd_list_warning&warning_ids=</cfoutput>'+check_list+'&fuseaction_='+document.getElementById("fuseaction_").value;
            }else{
                var responsible_employee = document.getElementById('responsible_employee').value;
                var responsible_employee_id = document.getElementById('responsible_employee_id').value;
                var responsible_employee_pos = document.getElementById('responsible_employee_pos').value;
                var process_note = document.getElementById('process_note').value;
                if( responsible_employee != '' && responsible_employee_pos != '' ){
                    url = '<cfoutput>#request.self#?fuseaction=myhome.emptypopup_upd_list_warning&warning_ids=</cfoutput>'+check_list+'&fuseaction_='+document.getElementById("fuseaction_").value + '&mode=' + mode + '&responsible_employee_pos=' + responsible_employee_pos + '&process_note=' + process_note;
                }else{
                    document.getElementById('responsible_employee').focus();
                    alert("<cf_get_lang dictionary_id ='29722.Lütfen Zorunlu Alanları Doldurunuz'>!");
                    return false;
                }
            }
            AjaxPageLoad(url, 'warnings_div_');
            setWarningCounts( window.warningCounter.chatCounter, window.warningCounter.warningCounter, 'WorkFlow' );
        }
	}
	function warning_redirect(x,url,warning_id,is_popup,sub_w_id,perCompControlSettings,enc_warning_id,enc_sub_w_id)
	{  
		if(x == 0)//İlgili Onay Kutusu Aciliyor
		{
			setTimeout(function() { 
				windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_dsp_warning&warning_id=</cfoutput>' + enc_warning_id+'<cfif attributes.page_type neq 1>&warning_is_active=0</cfif>&style=0&sub_warning_id='+enc_sub_w_id ,'medium');
			}, 1000);
			window.open(url,"_blank");
			return false;
		}else goToDetail('source', warning_id, perCompControlSettings, url );
	}
    function changePerComp(id) {
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.emptypopup_settings_process&id=acc_period&employee_idMngPeriod=#session.ep.userid#&moneyFormat=#session.ep.moneyformat_style#&position_idMngPeriod=#GET_POS_ID.POSITION_ID#</cfoutput>&user_period_idMngPeriod='+id,'mysettings_period_header',1);
    }
	function connectAjax(el,row,w_id)
	{
		if($(el).hasClass("openn")){
			$("#warning_comment"+row+"").hide();
			$(el).removeClass("openn").addClass("closee");
		}else{
			$("#warning_comment"+row+"").show();
			var url = '<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_dsp_warning&warning_id='+w_id+'&style=1';
			AjaxPageLoad(url,'warning_divs'+row,1);
			$(el).removeClass("closee").addClass("openn");
		}
	}
	function beforeFunction( userid, nameSurname, position_code, is_mandate ) {
		$("#employee_id").val(userid);
		$("#employee_name").val(nameSurname);
        $("#position_code").val(position_code);
        $("#is_mandate").val(is_mandate);
        $("#warnings_form").submit();
        return false;
    }

    function getProcessRows( element, process_row_id ){
        $("#process_row_id").html('<option value=""><cf_get_lang dictionary_id="57482.Aşama"></option>');
        if( element.value != '' ){
            let get_process_type_rows = wrk_safe_query("get_process_stages",'dsn',20,element.value);
            if( get_process_type_rows.recordcount ){
                for (let i = 0; i < get_process_type_rows.recordcount; i++) {
                    $("<option>").attr({ "value" : get_process_type_rows.PROCESS_ROW_ID[i] }).text( get_process_type_rows.STAGE[i] ).appendTo($("#process_row_id"));
                    if( typeof process_row_id != undefined && process_row_id != '' && process_row_id == get_process_type_rows.PROCESS_ROW_ID[i] )
                        $("#process_row_id").val(get_process_type_rows.PROCESS_ROW_ID[i]);
                }
            }
        }
    }

    function setProcess( process_id, process_row_id ) {
        document.getElementById('process_id').value = process_id;
        getProcessRows( document.getElementById('process_id'), process_row_id );
        document.getElementById('warning_submit_button').click();
    }

    <cfif isDefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1>
        getProcessRows( document.getElementById('process_id'), '<cfoutput>#attributes.process_row_id#</cfoutput>' );
    </cfif>

    setWarningCounts( window.warningCounter.chatCounter, window.warningCounter.warningCounter, 'WorkFlow' );
    
</script>