<cfcomponent>
	<cffunction name="cost_action" returntype="numeric" output="TRUE">
        <!---
        by : TolgaS 20061205
            TolgaS 20070601
        notes : 
            .....bir islemden(fatura, irasaliye,stok fis veya uretim) sonra o belge ile ilgili maliyet duzenlemelerinin yapilmasi.....
            fonsiyon bir popup açıyor ve o sayfada cfhttp ile yönlenme yapılıyor ve popup kapanıyor. popup olmasının sebebi sayfanın beklemesini engellemek bu sayade kullanıcı işlemine devam ederken arkada maliyet işlemi çalışmaya devam ediyor...
            PRODUCT_COST_LOG tablosuna kayit atilliyor fonsiyon basinda islem bittimindde objects2.emptypopup_cost_action daki belgede PRODUCT_COST_REFERENCE tablosuna kayit atiyor yani PRODUCT_COST_LOG da kayitli olan ancak PRODUCT_COST_REFERENCE olamyanlar yarim kalmis islemlerdir
        usage :
            cost_action(
                    action_type: 1, (1:fatura, 2:irsaliye, 3: fis, 4:uretim, 5: stok virman,6: masraf fişi)
                    action_id: invoce.invoice_id, (belge idsi)
                    query_type:1 (yapilan islem turu (1:ekleme,2:guncelleme,3:silme))
                );
        --->
        <cfargument name="action_type" type="numeric" required="yes" default="1"> <!--- fatura:1 , irsaliye:2, fis:3, üretim:4 , stok virman:5 --->
        <cfargument name="action_id" type="numeric" required="yes"><!--- islem tipi idsi --->
        <cfargument name="query_type" type="numeric" required="yes" default="1"><!--- islem silme güncelleme mi yoksa eklememi add:1 , update:2 , delete: 3 --->
        <cfargument name="dsn_type" type="string" required="no" default="#dsn3#">
        <cfargument name="period_dsn_type" type="string" required="no" default="#dsn2#">
        <!--- 	
            <cfargument name="user_id" type="numeric" required="no" default="#session.ep.userid#"><!--- islemi yapan 0 bunlar schedulle yollanmalı diger yerlerde gerek yok --->
            <cfargument name="period_id" type="numeric" required="no" default="#session.ep.period_id#"><!--- period bunlar schedulle yollanmalı diger yerlerde gerek yok--->
            <cfargument name="company_id" type="numeric" required="no" default="#session.ep.company_id#"><!--- sirket bunlar schedulle yollanmalı diger yerlerde gerek yok--->
         --->
     <cfargument name="is_popup" type="numeric" required="no" default="1"><!--- popup acılsınmı yoksa mevcut sayfadamı yonlensin 1: popup 0:mevcut sayfa  (satış işlemlerinde kullanılıyor bir sonraki alışı bularak tekrar çalıştığından bu yol izlendi)--->
        <cfargument name="multi_cost_page" type="string" required="no" default=""><!--- Gruplanmış üretim sonuçları için maliyet oluştururken her biri için maliyet oluştursun diye popup isimlerini değiştirmek için eklendi,maliyete bu kısım için bir blok eklenince kaldırılacak. --->
        <cfif isdefined('arguments.multi_cost_page') and arguments.multi_cost_page is 1>
            <cfset popup_page_name = "add_cost_wind_#arguments.action_id#">
        <cfelse>
            <cfset popup_page_name = "add_cost_wind">
        </cfif>
            <script type="text/javascript">
                <cfif isDefined("session.pda")>
                    window.open('<cfoutput>#request.self#?fuseaction=pda.emptypopup_cost_action&action_type=#arguments.action_type#&action_id=#arguments.action_id#&dsn_type=#arguments.dsn_type#&period_dsn_type=#arguments.period_dsn_type#&query_type=#arguments.query_type#&user_id=#session.pda.userid#&period_id=#session.pda.period_id#&company_id=#session.pda.our_company_id#</cfoutput>',"#popup_page_name#","height=75,width=350");
                <cfelse>
                    window.open('<cfoutput>#request.self#?fuseaction=objects.emptypopup_cost_action&action_type=#arguments.action_type#&action_id=#arguments.action_id#&dsn_type=#arguments.dsn_type#&period_dsn_type=#arguments.period_dsn_type#&query_type=#arguments.query_type#&user_id=#session.ep.userid#&period_id=#session.ep.period_id#&company_id=#session.ep.company_id#</cfoutput>',"#popup_page_name#","height=75,width=350");
                </cfif>
            </script>
            <!---<cflocation url="#request.self#?fuseaction=objects.emptypopup_cost_action&action_type=#arguments.action_type#&action_id=#arguments.action_id#&dsn_type=#arguments.dsn_type#&period_dsn_type=#arguments.period_dsn_type#&query_type=#arguments.query_type#&user_id=#arguments.user_id#&period_id=#arguments.period_id#&company_id=#arguments.company_id#" addtoken="no">--->
        <cfquery name="ADD_PROCESS_START" datasource="#dsn1#">
            INSERT INTO 
                PRODUCT_COST_LOG
                (
                    ACTION_TYPE,
                    ACTION_ID,
                    QUERY_TYPE,
                    PERIOD_ID,
                    OUR_COMPANY_ID,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
            VALUES
                (
                    #arguments.action_type#,
                    #arguments.action_id#,
                    #arguments.query_type#,
                    <cfif isDefined("session.pda")>
                        #session.pda.period_id#,
                        #session.pda.our_company_id#,
                        #now()#,
                        #session.pda.userid#,
                    <cfelse>
                        #session.ep.period_id#,
                        #session.ep.company_id#,
                        #now()#,
                        #session.ep.userid#,
                    </cfif>
                    '#cgi.REMOTE_ADDR#'
                )
        </cfquery>
        <cfreturn 1>
    </cffunction>
</cfcomponent>
