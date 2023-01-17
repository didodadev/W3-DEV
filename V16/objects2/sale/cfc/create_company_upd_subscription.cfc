<cfcomponent extends="V16.member.cfc.member_company">
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
    <cfelseif isdefined("session.qq")>
        <cfset session_base = evaluate('session.qq')>
    </cfif>

    <cfset dsn = application.systemParam.systemParam().dsn />
    <cfset dsn3 = "#dsn#_#session_base.company_id#" />
    <cfset workcube_mode = application.systemParam..systemParam().workcube_mode />

    <cfset siteMethods = createObject("component","catalyst/AddOns/Yazilimsa/Protein/cfc/siteMethods") />

    <cffunction name="f_control_company" returntype = "query" access = "public">
        <cfargument name="email" type="any" >

        <cfquery name="q_control_company" datasource="#dsn#">
            SELECT C.COMPANY_ID, CP.PARTNER_ID FROM 
            COMPANY AS C
            LEFT JOIN COMPANY_PARTNER AS CP ON C.COMPANY_ID = CP.COMPANY_ID
            WHERE COMPANY_EMAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.email#">
        </cfquery>
        <cfreturn q_control_company>
    </cffunction>

    <cffunction name = "create_company_partner" returnType = "any" returnformat = "JSON" access = "remote" description = "add company">
        <cfargument name="wrk_id" type="string" default="#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session_base.userid#_'&round(rand()*100)#">
        <cfargument name="userid" type="any" default="#session_base.userid#">
        <cfargument name="remote_addr" type="any" default="#cgi.remote_addr#">
        
        <cftry>

            <cfif isDefined("session.storage")>

                <cfset arguments.company_partner_status = 1 />
                    
                <cftransaction>
                    <cfset arguments.nickname = arguments.subscription_head = arguments.fullname />
                    <cfset arguments.telcod_company = arguments.telcod = len(arguments.phone_number) ? left(ReplaceList(arguments.phone_number,'(,), ',''),3) : '' />
                    <cfset arguments.tel1_company = arguments.tel1 = len(arguments.phone_number) ? right(ReplaceList(arguments.phone_number,'(,), ',''),7) : '' />

                    <cfset ADD_COMPANY = this.ADD_COMPANY( argumentCollection = arguments ) />
                    <cfset get_max.max_company = ADD_COMPANY.MAX_COMPANY>
                    
                    <cfset arguments.company_id = get_max.max_company /> 
                    <cfset arguments.pos_code = arguments.mission />
                    <cfset arguments.telcod = arguments.partner_mobile_code = left(ReplaceList(arguments.partner_mobile_phone,'(,), ',''),3) />
                    <cfset arguments.tel1 = arguments.partner_mobile_tel = right(ReplaceList(arguments.partner_mobile_phone,'(,), ',''),7) />

                    <cfset this.update_company_member_code( company_id: get_max.max_company ) />
                    <cfif isdefined('arguments.postcod') and len(arguments.postcod)>
                        <cfset this.ADD_WORKGROUP_MEMBER( argumentCollection = arguments ) />
                    </cfif>
                    <cfset this.ADD_COMP_PERIOD( argumentCollection = arguments ) />
                    <cfset this.ADD_PARTNER( argumentCollection = arguments ) />
                    
                    <cfset get_max.max_partner = this.GET_MAX_PARTNER().MAX_PARTNER_ID />
                    <cfset arguments.partner_id = get_max.max_partner />

                    <cfset this.UPD_MEMBER_CODE(partner_id: get_max.max_partner) />
                    <cfset this.ADD_COMPANY_PARTNER_DETAIL(partner_id: get_max.max_partner) />
                    <cfset this.ADD_PART_SETTINGS(partner_id: get_max.max_partner) />

                    <cfif isdefined("arguments.sector_cat_id")>
                        <cfif isArray( arguments.sector_cat_id ) and arrayLen(arguments.sector_cat_id)>
                            <cfloop array="#arguments.sector_cat_id#" index="i" item="item">
                                <cfset this.ADD_COMP_SECTOR(sector_id:arguments.sector_cat_id[i], company_id:get_max.max_company)>
                            </cfloop>
                        <cfelseif len( arguments.sector_cat_id )>
                            <cfset this.ADD_COMP_SECTOR(sector_id:arguments.sector_cat_id, company_id:get_max.max_company)>
                        </cfif>
                    </cfif>

                    <cfsavecontent variable="topicContent">
                        <cfoutput>
                            #arguments.name# #arguments.soyad# "#arguments.fullname#" All In One / Watom talebinde bulunmuştur.
                            <b>Firma Bilgileri</b>

                            Firma: #arguments.fullname#<br>
                            E Mail: #arguments.email#<br>
                            Sabit Telefon: #arguments.telcod_company# #arguments.tel1_company#<br>

                            <hr><br>

                            <b>Yetkili Bilgileri</b>

                            Ad: #arguments.name#<br>
                            Soyad: #arguments.soyad#<br>
                            E Mail: #arguments.company_partner_email#<br>
                            Mobil Telefon: #arguments.partner_mobile_code# #arguments.partner_mobile_tel#
                        </cfoutput>
                    </cfsavecontent>

                    <cfhttp url="https://networg.workcube.com/wex.cfm/helpdesk/add_customer_help" result="respHelpDesk" charset="utf-8">
                        <cfhttpparam name="partner_id" type="formfield" value="#arguments.partner_id#">
                        <cfhttpparam name="company_id" type="formfield" value="#arguments.company_id#">
                        <cfhttpparam name="consumer_id" type="formfield" value="">
                        <cfhttpparam name="app_cat" type="formfield" value="11">
                        <cfhttpparam name="interaction_cat" type="formfield" value="1">
                        <cfhttpparam name="interaction_date" type="formfield" value="#now()#">
                        <cfhttpparam name="subject" type="formfield" value="#topicContent#">
                        <cfhttpparam name="process_stage" type="formfield" value="29">
                        <cfhttpparam name="detail" type="formfield" value="#arguments.name# #arguments.soyad# - #arguments.fullname#">
                        <cfhttpparam name="applicant_name" type="formfield" value="#arguments.name# #arguments.soyad#">
                        <cfhttpparam name="applicant_mail" type="formfield" value="#arguments.email#">
                        <cfhttpparam name="is_reply_mail" type="formfield" value="0">
                        <cfhttpparam name="is_reply" type="formfield" value="0">
                        <cfhttpparam name="tel_code" type="formfield" value="#arguments.telcod_company#">
                        <cfhttpparam name="tel_no" type="formfield" value="#arguments.tel1_company#">
                        <cfhttpparam name="record_emp" type="formfield" value="1">
                        <cfhttpparam name="record_date" type="formfield" value="#now()#">
                        <cfhttpparam name="record_ip" type="formfield" value="#cgi.remote_addr#">
                    </cfhttp>

                    <cfif respHelpDesk.Statuscode eq '200 OK'>
                        <cfset respHelpDeskWexJson = respHelpDesk.FileContent />
                        <cfset respHelpDeskWex = deserializeJson(respHelpDeskWexJson) />
                        <cfif respHelpDeskWex.status>
                            <cfset response = { status: true, success_message: "İşlem Başarılı" } />
                        <cfelse>
                            <cftransaction action="rollback"/>
                            <cfset response = { status: false, danger_message: "Etkileşim kaydı sırasında bir hata oluştu" } />
                        </cfif>
                    <cfelse>
                        <cftransaction action="rollback"/>
                        <cfset response = { status: false, danger_message: "Etkileşim kaydı sırasında bir hata oluştu" } />
                    </cfif>
                </cftransaction>

                <cfset storage = deserializeJson(session.storage) />
                <cfset structAppend( storage, arguments ) />
                <cfset session.storage = replace( serializeJSON(storage), '//', '' ) />
            <cfelse>
                <cfset response = { data: { status: false, danger_message: "Lütfen önce sepete bir ürün ekleyiniz!" } } />
            </cfif>
            
            <cfcatch type = "any">
                <cfset response = { data: { status: false, danger_message: "Bir hata oluştu" } } />
            </cfcatch>
        </cftry>

        <cfreturn replace(SerializeJSON(response),'//','') />
    </cffunction>

    <!--- <cffunction name = "get_it_asset" returnType = "any" access = "public" description = "Get IT Asset">
        <cfargument name="quantity" type="numeric" required="true">
        
        <cfquery name="q_get_it_asset" datasource="#dsn#">
            SELECT * FROM ASSET_P WHERE STATUS = 1 AND ASSETP_CATID = 6
        </cfquery>
        <cfif q_get_it_asset.recordcount>

        </cfif>

    </cffunction> --->

    <cffunction name = "site_reserve" returnType = "any" returnformat = "JSON" access = "remote" description = "Reserve site - Update subscription">
        <cfargument name="widget_id">

        <cfif isDefined("session.storage")>

            <cftry>
                <cfset getWidget = deserializeJSON(siteMethods.get_widget(id: arguments.widget_id)) />
                <cfset xml_settings = deserializeJSON(getWidget.DATA[1].WIDGET_DATA) >

                <cfset structAppend(arguments, deserializeJSON(session.storage)) />
                <cfset default_subscription_cat_id = arguments.product[1].PRODUCT_ID eq 8818 ? listFirst(xml_settings.default_subscription_cat_id) : listLast(xml_settings.default_subscription_cat_id) />

                <cfset subscription_contract = createObject("component","V16/sales/cfc/subscription_contract") />

                <cfquery name="get_subscription" datasource="#dsn3#">
                    SELECT TOP 1 SC.SUBSCRIPTION_ID, SC.SUBSCRIPTION_NO, SIP.PROPERTY16
                    FROM SUBSCRIPTION_CONTRACT AS SC
                    JOIN SUBSCRIPTION_INFO_PLUS SIP ON SC.SUBSCRIPTION_ID = SIP.SUBSCRIPTION_ID
                    WHERE 
                        SUBSCRIPTION_STAGE = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#xml_settings.default_subscription_process_stage#">
                        AND SUBSCRIPTION_TYPE_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#default_subscription_cat_id#">
                </cfquery>

                <cfif get_subscription.recordcount>

                    <cfset arguments.subscription_id = get_subscription.SUBSCRIPTION_ID />
                    <cfset arguments.subscription_no = get_subscription.SUBSCRIPTION_NO />

                    <cfset arguments.record_date = now() />
                    <cfset arguments.start_date = now() />
                    <cfset arguments.finish_date = dateAdd("yyyy", 1, arguments.start_date) />
                    <cfset arguments.process_stage = xml_settings.update_subscription_process_stage />

                    <cfif isDefined("arguments.is_same_with_company")>
                        <cfset arguments.invoice_country_id = arguments.country />
                        <cfset arguments.invoice_city_id = arguments.city_id />
                        <cfset arguments.invoice_county_id = arguments.county_id />
                        <cfset arguments.invoice_postcode = arguments.postcod />
                        <cfset arguments.invoice_address = arguments.adres />
                    </cfif>

                    <cfset arguments.dsn = dsn3 />

                    <cftransaction>
                        <cfif len(get_subscription.PROPERTY16)>

                            <cfset employee_password = "" />

                            <cfset strAlpha = "abcdefghijklmnopqrstuvwxyz" />
                            <cfset strNumbers = "0123456789" />
                            <cfset strSpecial = ".!?*%" />

                            <cfset strAllValidChars = ( strAlpha & strNumbers & strSpecial ) />

                            <cfloop from="1" to="12" index="intChar">
                                <cfset employee_password &= (Mid(strAllValidChars, RandRange( 1, Len( strAllValidChars ) ), 1)) />
                            </cfloop>

                            <!--- Abone güncelleme işlemleri yapılır --->
                            <cfset subscription_contract.UPD_SUBSCRIPTION_CONTRACT( argumentCollection = arguments ) />
                            <cfloop array = "#arguments.product#" item = "item" index = "i">
                                <cfset subscription_contract.UPD_SUBSCRIPTION_CONTRACT_ROW(
                                    subscription_id: arguments.subscription_id,
                                    stock_id: arguments.product[i].STOCK_ID,
                                    amount: arguments.product[i].AMOUNT
                                ) />
                            </cfloop>

                            <cfset arguments.subscription_domain = get_subscription.PROPERTY16 />
                            
                            <!--- Rezerve edilen domaine wex üzerinden yeni bilgiler atanır --->
                            <cfhttp url="https://#arguments.subscription_domain#/wex.cfm/reserve_site/run_application" result="respReserveSiteOperations" charset="utf-8">
                                <cfhttpparam name="company_fullname" type="formfield" value="#arguments.fullname#">
                                <cfhttpparam name="company_website" type="formfield" value="#arguments.homepage#">
                                <cfhttpparam name="company_email" type="formfield" value="#arguments.email#">
                                <cfhttpparam name="company_telcode" type="formfield" value="#arguments.telcod_company#">
                                <cfhttpparam name="company_tel1" type="formfield" value="#arguments.tel1_company#">
                                <cfhttpparam name="company_tax_office" type="formfield" value="#arguments.taxoffice#">
                                <cfhttpparam name="company_tax_no" type="formfield" value="#arguments.taxno#">
                                <cfhttpparam name="company_address" type="formfield" value="#arguments.adres#">
                                <cfhttpparam name="partner_name" type="formfield" value="#arguments.name#">
                                <cfhttpparam name="partner_surname" type="formfield" value="#arguments.soyad#">
                                <cfhttpparam name="partner_email" type="formfield" value="#arguments.company_partner_email#">
                                <cfhttpparam name="partner_mobile_telcode" type="formfield" value="#arguments.telcod#">
                                <cfhttpparam name="partner_mobile_tel" type="formfield" value="#arguments.tel1#">
                                <cfhttpparam name="partner_password" type="formfield" value="#employee_password#">
                            </cfhttp>
        
                            <cfif respReserveSiteOperations.Statuscode eq '200 OK'>
                                <cfset respReserveSiteOperationsWexJson = respReserveSiteOperations.FileContent />
                                <cfset respReserveSiteOperationsWex = deserializeJson(respReserveSiteOperationsWexJson) />
                                <cfif respReserveSiteOperationsWex.status>
                                    <cfset storage = deserializeJson(session.storage) />
                                    <cfset storage.subscription_id = arguments.subscription_id />
                                    <cfset storage.subscription_no = arguments.subscription_no />
                                    <cfset storage.subscription_domain = arguments.subscription_domain />
                                    <cfset storage.employee_password = employee_password />
                                    <cfset session.storage = replace( serializeJSON(storage), '//', '' ) />
                                    
                                    <!--- Networg sistemi üzerinde iam user oluşturulur --->
                                    <cfhttp url="https://networg.workcube.com/wex.cfm/iam/ADD_IAM" result="resp" charset="utf-8">
                                        <cfhttpparam name="company_id" type="formfield" value="5">
                                        <cfhttpparam name="subscription_no" type="formfield" value="#arguments.subscription_no#">
                                        <cfhttpparam name="iam_user_active" type="formfield" value="1">
                                        <cfhttpparam name="iam_user_username" type="formfield" value="admin">
                                        <cfhttpparam name="iam_user_name" type="formfield" value="#arguments.name#">
                                        <cfhttpparam name="iam_user_surname" type="formfield" value="#arguments.soyad#">
                                        <cfhttpparam name="iam_user_password" type="formfield" value="#employee_password#">
                                        <cfhttpparam name="iam_user_first_email" type="formfield" value="#arguments.company_partner_email#">
                                        <cfhttpparam name="iam_user_second_email" type="formfield" value="#arguments.company_partner_email#">
                                        <cfhttpparam name="iam_user_mobile_code" type="formfield" value="#arguments.telcod#">
                                        <cfhttpparam name="iam_user_mobile_tel" type="formfield" value="#arguments.tel1#">
                                        <cfhttpparam name="user_comp_name" type="formfield" value="#arguments.fullname#">
                                        <cfhttpparam name="domain" type="formfield" value="#arguments.subscription_domain#">
                                    </cfhttp>

                                    <cfif resp.Statuscode eq '200 OK'>
                                        <cfset responseWexJson = resp.FileContent />
                                        <cfset responseWex = deserializeJson(responseWexJson) />
                                        <cfif responseWex.status>
                                            <cfset this.mailSender() />
                                            <cfset response = { status: true, message: "İşlem Başarılı!" } />
                                        <cfelse>
                                            <cfset response = { status: false, message: "IAM User oluşturulurken bir sorun oluştu!" } />
                                        </cfif>
                                    <cfelse>
                                        <cfset response = { status: false, message: "IAM User Oluşturma servisleri yanıt vermiyor!" } />
                                    </cfif>
                                <cfelse>
                                    <cftransaction action="rollback"/>
                                    <cfset response = { status: false, message: "Rezerve edilmiş sistemin bilgileri güncellenirken bir hata oluştu", catch: respReserveSiteOperationsWex.catch } />
                                </cfif>
                            <cfelse>
                                <cftransaction action="rollback"/>
                                <cfset response = { status: false, message: "Rezerve edilmiş sistemin servisleri yanıt vermiyor" } />
                            </cfif>

                        <cfelse>
                            <cfset response = { status: false, message: "Rezerve edilmiş abonenin domaini atanmamış!" } />
                        </cfif>
                    </cftransaction>

                <cfelse>
                    <cfset response = { status: false, message: "Rezerve edilmiş abone kaydı bulunamadı!" } />
                </cfif>
                <cfcatch type = "any">
                    <cfset response = { data: { status: false, message: "Bir hata oluştu", catch: cfcatch } } />
                </cfcatch>
            </cftry>

        <cfelse>
            <cfset response = { status: false, message: "Bir Hata Oluştu!" } />
        </cfif>
        
        <cfreturn Replace(SerializeJSON(response),'//','')>
    </cffunction>

    <cffunction name="mailSender" access="remote" returnType="any" retunFormat="JSON">
        
        <cfset response = structNew() />
        
        <cfif isDefined("session.storage")>
    
            <cftry>
                <cfset storage = deserializeJSON(session.storage) />

                <cfmail to="#storage.company_partner_email#" from="Workcube Toplulugu<workcube@workcube.com>" subject="Workcube Kurulumunuz Tamamlandı" type="HTML">
                    Merhaba #storage.name# #storage.soyad#;<br><br>
                    
                    Workcube kurulumunuz başarıyla tamamlandı!<br><br>
                    Sistem Yöneticisi olarak kullanıcınız açıldı.<br><br>
                    Aşağıdaki bağlantıya tıklayarak kullanıcı adı ve şifrenizle giriş yapabilirsiniz.<br><br>

                    İşletmenizin Domaini: <a href="https://#storage.subscription_domain#/index.cfm?fuseaction=home.login" target="_blank">https://#storage.subscription_domain#</a><br>
                    Kullanıcı Adınız: admin<br>
                    Şifreniz: #storage.employee_password#
                </cfmail>

                <cfset response = { "status": true } />

                <cfcatch type="any">
                    <cfset response = { "status": false, "message": "Mail gönderimi sırasında bir hata oluştu!", "catch": cfcatch } />
                </cfcatch>
            </cftry>

        <cfelse>
            <cfset response = { "status": false, "message": "Lütfen önce sepete bir ürün ekleyiniz!" } />
        </cfif>
        <cfreturn Replace(SerializeJSON(response),'//','')>   
    </cffunction>

</cfcomponent>