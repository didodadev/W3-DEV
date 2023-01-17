<!--
    -Hesap Planlarını ve Muhasebe Fişlerini belirlenen Adresten Alımını Sağlar
    -04112021
-->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="WRK_FROM_ACCOUNTER" returntype="any" access="public">
        <cfset response = structNew()>
       
        <cfquery name="GET_PERIOD" datasource="#dsn#">
            SELECT COMP_ID FROM OUR_COMPANY WHERE ACCOUNTER_KEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments[1]["API_KEY"]#">
        </cfquery>
       
        <cfif GET_PERIOD.recordcount>
            <cfset dsn2_alias = '#dsn#_#arguments[1]["PERIOD_YEAR"]#_#GET_PERIOD.COMP_ID#'>
            <!--- <cfdump var="#arguments#" abort> --->
            <cftransaction>
                <cfset control_card = this.GET_CARD_RELATION( service_card_id : arguments[1]["PAPER"][1]["CARD_ID"], dsn2_alias: dsn2_alias )>
                <cfif control_card.recordcount gt 0>
                    <cfif len( arguments[1]["EVENT"] ) and arguments[1]["EVENT"] eq 'del' >
                        <cfset del_card = this.DEL_CARD( card_id: control_card.CARD_ID, dsn2_alias: dsn2_alias )>
                        <cfif del_card.status >
                            <cfset response.status = 1>
                            <cfset response.message = "Silme İşlemi Başarıyla Gerçekleşti, Fiş Bilgileri Karşı Tarafa Başarıyla Gönderildi.">
                        <cfelse>
                            <cfset response.status = 0>
                            <cfset response.message = del_card.message >
                        </cfif>
                    <cfelse>
                        <cfset upd_card = this.UPD_ACCOUNT_CARD( data : arguments[1]["PAPER"], card_id: control_card.CARD_ID, dsn2_alias: dsn2_alias )>
                        <cfset upd_card_rows = this.UPD_ACCOUNT_CARD_ROWS(data : arguments[1]["ROWS"], card_id: control_card.CARD_ID, dsn2_alias: dsn2_alias )>
                        <cfif upd_card.status and upd_card_rows.status >
                            <cfset response.status = 1>
                            <cfset response.message = "Güncelleme İşlemi Başarıyla Gerçekleşti, Fiş Bilgileri Karşı Tarafa Başarıyla Gönderildi.">
                        <cfelse>
                            <cfset response.status = 0>
                            <cfset response.message = ( upd_card.status eq 0 ) ? upd_card.message : upd_card_rows.message >
                        </cfif>
                    </cfif>
                <cfelseif control_card.recordcount eq 0 and not len( arguments[1]["EVENT"] )>
                    <cfset add_card = this.ADD_ACCOUNT_CARD( data : arguments[1]["PAPER"], dsn2_alias: dsn2_alias )>
                    <cfset add_card_rows = this.ADD_ACCOUNT_CARD_ROWS(data : arguments[1]["ROWS"], identity : add_card.identity, dsn2_alias: dsn2_alias )>
                    <cfset add_card_money = this.ADD_ACCOUNT_CARD_MONEY(data : arguments[1]["MONEY"], identity : add_card.identity, dsn2_alias: dsn2_alias )>
                    <cfset add_relation = this.ADD_RELATION( service_card_id : arguments[1]["PAPER"][1]["CARD_ID"], identity: add_card.identity, dsn2_alias: dsn2_alias )>
                    <cfif add_card.status and add_card_rows.status >
                        <cfset response.status = 1>
                        <cfset response.message = "Kayıt İşlemi Başarıyla Gerçekleşti, Fiş Bilgileri Karşı Tarafa Başarıyla Gönderildi.">
                    <cfelse>
                        <cfset response.status = 0>
                        <cfset response.message = ( add_card.status eq 0 ) ? add_card.message : add_card_rows.message >
                    </cfif>
                </cfif>
            </cftransaction>
        <cfelse>
            <cfset response.status = 0>
            <cfset response.message = "Diğer Sisteme Fiş Bilgileri Gönderilemedi. Lütfen Doğrulama Kodunu Kontrol Edin">
        </cfif>
        <cfreturn response>
    </cffunction>

    <cffunction name="WRK_PLAN_FROM_ACCOUNTER" returntype="any" access="public">
        <cfset response = structNew()>
       
        <cfquery name="GET_PERIOD" datasource="#dsn#">
            SELECT COMP_ID FROM OUR_COMPANY WHERE ACCOUNTER_KEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments[1]["API_KEY"]#">
        </cfquery>
       
        <cfif GET_PERIOD.recordcount>
            <cfset dsn2_alias = '#dsn#_#arguments[1]["PERIOD_YEAR"]#_#GET_PERIOD.COMP_ID#'>
            <cftransaction>
                <cfset control_plan = this.GET_PLAN_RELATION( account_code : arguments[1]["ACC_PLAN"][1]["ACCOUNT_CODE"], dsn2_alias: dsn2_alias )>
                <cfif control_plan.recordcount gt 0>
                    <cfif len( arguments[1]["EVENT"] ) and arguments[1]["EVENT"] eq 'del' >
                        <cfset del_plan = this.DEL_ACCOUNT_PLAN( account_code: control_plan.ACCOUNT_CODE, dsn2_alias: dsn2_alias )>
                        <cfif del_plan.status >
                            <cfset response.status = 1>
                            <cfset response.message = "Silme İşlemi Başarıyla Gerçekleşti, Hesap Plan Bilgileri Karşı Tarafa Başarıyla Gönderildi.">
                        <cfelse>
                            <cfset response.status = 0>
                            <cfset response.message = del_plan.message >
                        </cfif>
                    <cfelse>
                        <cfset upd_plan = this.UPD_ACCOUNT_PLAN( data : arguments[1]["ACC_PLAN"], account_code : control_plan.ACCOUNT_CODE, dsn2_alias: dsn2_alias )>
                        <cfif upd_plan.status >
                            <cfset response.status = 1>
                            <cfset response.message = "Güncelleme İşlemi Başarıyla Gerçekleşti, Hesap Plan Bilgileri Karşı Tarafa Başarıyla Gönderildi.">
                        <cfelse>
                            <cfset response.status = 0>
                            <cfset response.message = upd_plan.message >
                        </cfif>
                    </cfif>
                <cfelseif control_plan.recordcount eq 0 and not len( arguments[1]["EVENT"] )>
                    <cfset add_plan = this.ADD_ACCOUNT_PLAN( data : arguments[1]["ACC_PLAN"], dsn2_alias: dsn2_alias )>
                    <cfif add_plan.status >
                        <cfset response.status = 1>
                        <cfset response.message = "Kayıt İşlemi Başarıyla Gerçekleşti, Fiş Bilgileri Karşı Tarafa Başarıyla Gönderildi.">
                    <cfelse>
                        <cfset response.status = 0>
                        <cfset response.message = add_plan.message  >
                    </cfif>
                </cfif>
            </cftransaction>
        <cfelse>
            <cfset response.status = 0>
            <cfset response.message = "Diğer Sisteme Hesap Plan Bilgileri Gönderilemedi. Lütfen Doğrulama Kodunu Kontrol Edin">
        </cfif>
        <cfreturn response>
    </cffunction>

    <cffunction name="DEL_ACCOUNT_PLAN" returntype="any" access="public" hint="Hesap Planı">
        <cfargument name="account_code" required="true">
        <cfset response = structNew()>
        <cftry>
            <cfquery name="DEL_ACCOUNT_PLAN" datasource="#arguments.dsn2_alias#">
                DELETE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.account_code#">
            </cfquery>
            <cfset response.status = 1>
            <cfset response.message = "Silme İşlemi Başarıyla Gerçekleşti">
            <cfcatch>
                <cfset response.status = 0>
                <cfset response.message = "Silme İşlemi Sırasında Bir Sorun Oluştu">
            </cfcatch>
        </cftry>
        <cfreturn response>
    </cffunction>

    <cffunction name="ADD_ACCOUNT_PLAN" returntype="any" access="public" hint="Hesap Planı Bilgileri">
        <cfargument name="data" required="true">
        <cfset response = structNew()>
        <cftry>
            <cfquery name="ADD_ACCOUNT_PLAN" datasource="#arguments.dsn2_alias#">
                INSERT INTO 
				    ACCOUNT_PLAN(
                        ACCOUNT_CODE,
                        ACCOUNT_NAME,
                        SUB_ACCOUNT,
                        IFRS_CODE,
                        IFRS_NAME,
                        ACCOUNT_CODE2,
                        ACCOUNT_NAME2,
                        RECORD_IP,
                        RECORD_DATE
                    )	
                VALUES(
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data[1]["ACCOUNT_CODE"]#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data[1]["ACCOUNT_NAME"]#">,
                    <cfif data[1]["SUB_ACCOUNT"] eq 'YES'>1<cfelse>0</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data[1]["IFRS_CODE"]#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data[1]["IFRS_NAME"]#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data[1]["ACCOUNT_CODE2"]#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data[1]["ACCOUNT_NAME2"]#">,
                    '#cgi.remote_addr#',
                    #now()#
                )
            </cfquery>
            <cfset response.status = 1>
            <cfset response.message = "Belge Kaydı Başarıyla Gerçekleşti">
            <cfcatch>
                <cfset response.status = 0>
                <cfset response.message = "Belge Kaydı Sırasında Bir Sorun Oluştu">
            </cfcatch>
        </cftry>
        <cfreturn response>
    </cffunction>

    <cffunction name="ADD_ACCOUNT_CARD" returntype="any" access="public" hint="Muhasebe Fişi Belge Bilgileri">
        <cfargument name="data" required="true">
        <cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_'&round(rand()*100)>
        <cfset response = structNew()>
        <cftry>
            <cfquery name="ADD_ACCOUNT_CARD" datasource="#arguments.dsn2_alias#" result="MAX_ID">
                INSERT INTO
                    ACCOUNT_CARD
                    (
                        IS_OTHER_CURRENCY,
                        IS_ACCOUNT_CODE2,
                        WRK_ID,
                        ACC_COMPANY_ID,
                        ACC_CONSUMER_ID,
                        CARD_DETAIL,
                        ACTION_TYPE,
                        ACTION_CAT_ID,
                        BILL_NO,
                        CARD_TYPE,
                        CARD_CAT_ID,
                        CARD_TYPE_NO,
                        ACTION_DATE,
                        IS_RATE_DIFF,
                        CARD_DOCUMENT_TYPE,
                        CARD_PAYMENT_METHOD,
                        PAPER_NO,
                        DUE_DATE,
                        RECORD_IP,
                        RECORD_DATE,
                        RECORD_TYPE
                    )
                VALUES
                    (
                        <cfif data[1]["IS_OTHER_CURRENCY"] eq 'YES'><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
                        <cfif data[1]["IS_ACCOUNT_CODE2"] eq 'YES'><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
                        NULL,
                        NULL,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data[1]["CARD_DETAIL"]#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#data[1]["ACTION_TYPE"]#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#data[1]["ACTION_CAT_ID"]#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#data[1]["BILL_NO"]#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#data[1]["CARD_TYPE"]#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#data[1]["CARD_CAT_ID"]#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#data[1]["CARD_TYPE_NO"]#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#data[1]["ACTION_DATE"]#">,
                        <cfif data[1]["IS_RATE_DIFF"] eq 'YES'>1<cfelse>0</cfif>,
                        <cfif len(data[1]["CARD_DOCUMENT_TYPE"])><cfqueryparam cfsqltype="cf_sql_integer" value="#data[1]["CARD_DOCUMENT_TYPE"]#"><cfelse>NULL</cfif>,
                        <cfif len(data[1]["CARD_PAYMENT_METHOD"])><cfqueryparam cfsqltype="cf_sql_integer" value="#data[1]["CARD_PAYMENT_METHOD"]#"><cfelse>NULL</cfif>,
                        <cfif len(data[1]["PAPER_NO"])><cfqueryparam cfsqltype="cf_sql_varchar" value="#data[1]["PAPER_NO"]#"><cfelse>NULL</cfif>,
                        <cfif (data[1]["CARD_DOCUMENT_TYPE"] eq -1 or data[1]["CARD_DOCUMENT_TYPE"] eq -3) and len(data[1]["DUE_DATE"])><cfqueryparam cfsqltype="cf_sql_date" value="#data[1]["DUE_DATE"]#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfif len(data[1]["RECORD_TYPE"])>#data[1]["RECORD_TYPE"]#<cfelse>1</cfif>
                    )
            </cfquery>
            <cfset response.status = 1>
            <cfset response.message = "Belge Kaydı Başarıyla Gerçekleşti">
            <cfset response.identity = MAX_ID.IDENTITYCOL>
        <cfcatch>
            <cfset response.status = 0>
            <cfset response.message = "Belge Kaydı Sırasında Bir Sorun Oluştu">
        </cfcatch>
        </cftry>
        <cfreturn response>
    </cffunction>

    <cffunction name="ADD_ACCOUNT_CARD_ROWS" returntype="any" access="public" hint="Muhasebe Fişi Satır Bilgileri">
        <cfargument name="data" required="true">
        <cfargument name="identity" required="true">
        <cfset response = structNew()>
        <cftry>
            <cfloop from="1" to="#arrayLen(data)#" index="i">
                <cfquery name="ADD_ACCOUNT_CARD_ROWS" datasource="#arguments.dsn2_alias#">
                    INSERT INTO
                        ACCOUNT_CARD_ROWS
                        (
                            CARD_ID,
                            ACCOUNT_ID,
                            BA,
                            QUANTITY, 
                            PRICE,
                            AMOUNT,
                            AMOUNT_CURRENCY,
                            AMOUNT_2,
                            AMOUNT_CURRENCY_2,
                            IFRS_CODE,
                            ACCOUNT_CODE2,
                            OTHER_AMOUNT,
                            OTHER_CURRENCY,	
                            IS_RATE_DIFF_ROW,						
                            ACC_DEPARTMENT_ID,
                            ACC_BRANCH_ID,
                            ACC_PROJECT_ID,
                            DETAIL
                        )				
                    VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.identity#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data[i]["ACCOUNT_ID"]#">,
                            <cfif data[i]["BA"] eq 'NO'><cfqueryparam cfsqltype="cf_sql_bit" value="0"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="1"></cfif>,
                            <cfif data[i]["QUANTITY"] gt 0>'#data[i]["QUANTITY"]#'<cfelse>0</cfif>,
                            <cfif data[i]["PRICE"] gt 0>'#data[i]["PRICE"]#'<cfelse>0</cfif>, 
                            <cfif data[i]["AMOUNT"] gt 0>#data[i]["AMOUNT"]#</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data[i]["AMOUNT_CURRENCY"]#">,
                            <cfif data[i]["AMOUNT_2"] gt 0>#data[i]["AMOUNT_2"]#<cfelse>NULL</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#data[i]["AMOUNT_CURRENCY_2"]#">,
                            <cfif len(data[i]["IFRS_CODE"])>'#data[i]["IFRS_CODE"]#'<cfelse>NULL</cfif>,
                            <cfif len(data[i]["ACCOUNT_CODE2"])>'#data[i]["ACCOUNT_CODE2"]#'<cfelse>NULL</cfif>,
                            <cfif data[i]["OTHER_AMOUNT"] gt 0>#data[i]["OTHER_AMOUNT"]#</cfif>,
                            <cfif data[i]["OTHER_AMOUNT"] gt 0>'#data[i]["OTHER_CURRENCY"]#'</cfif>,
                            <cfif data[i]["IS_RATE_DIFF_ROW"] eq 'YES'>1<cfelse>0</cfif>,
                            <cfif len(data[i]["ACC_DEPARTMENT_ID"])>#data[i]["ACC_DEPARTMENT_ID"]#<cfelse>NULL</cfif>,
                            <cfif len(data[i]["ACC_BRANCH_ID"])>#data[i]["ACC_BRANCH_ID"]#<cfelse>NULL</cfif>,
                            <cfif len(data[i]["ACC_PROJECT_ID"])>#data[i]["ACC_PROJECT_ID"]#<cfelse>NULL</cfif>,
                            <cfif len(data[i]["DETAIL"])>'#data[i]["DETAIL"]#'<cfelse>NULL</cfif>
                        )
                </cfquery>
            </cfloop>
                <cfset response.status = 1>
                <cfset response.message = "Satır Kayıtları Başarıyla Gerçekleşti">
            <cfcatch>
                <cfset response.status = 0>
                <cfset response.message = "Satır Kayıtları Sırasında Bir Sorun Oluştu">
            </cfcatch>
        </cftry>
        <cfreturn response>
    </cffunction>

    <cffunction name="ADD_ACCOUNT_CARD_MONEY" returntype="any" access="public" hint="Muhasebe Fişi Kur Bilgileri">
        <cfargument name="data" required="true">
        <cfargument name="identity" required="true">
        <cfset response = structNew()>
        <cftry>
            <cfloop from="1" to="#arrayLen(data)#" index="i">
                <cfquery name="ADD_ACCOUNT_CARD_MONEY" datasource="#arguments.dsn2_alias#">
                    INSERT INTO
                        ACCOUNT_CARD_MONEY
                        (
                            ACTION_ID,
                            MONEY_TYPE,
                            RATE1,
                            RATE2
                        )
                    VALUES(
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.identity#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data[i]["MONEY"]#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#data[i]["RATE1"]#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#data[i]["RATE2"]#">
                    )
                </cfquery>
            </cfloop>
            <cfset response.status = 1>
            <cfset response.message = "Satır Kayıtları Başarıyla Gerçekleşti">
            <cfcatch>
                <cfset response.status = 0>
                <cfset response.message = "Kur Kayıtları Sırasında Bir Sorun Oluştu">
            </cfcatch>
        </cftry>
        <cfreturn response>
    </cffunction>

    <cffunction name="ADD_RELATION" returntype="any" access="public">
        <cfargument name="service_card_id" required="true">
        <cfargument name="identity" required="true">
        <cfset response = structNew()>
        <cftry>
            <cfquery name="ADD_RELATION" datasource="#arguments.dsn2_alias#">
                INSERT INTO
                    ACC_CARD_SERVICE_RELATION(
                        CARD_ID,
                        SERVICE_CARD_ID
                    )
                VALUES(
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.identity#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_card_id#">
                )
            </cfquery>
                <cfset response.status = 0>
                <cfset response.message = "İlişki Kayıtları Başarıyla Oluşturuldu.">
            <cfcatch>
                <cfset response.status = 0>
                <cfset response.message = "İlişki Kayıt Sırasında Bir Hata Oluştu">
            </cfcatch>  
        </cftry>
        <cfreturn response>
    </cffunction>

    <cffunction name="UPD_ACCOUNT_CARD" returntype="any" access="public" hint="Muhasebe Fişi Belge Güncelleme">
        <cfargument name="data" required="true">
        <cfargument name="card_id" required="true">
        <cfset response = structNew()>
        <cftry>
            <cfquery name="UPD_ACCOUNT_CARD" datasource="#arguments.dsn2_alias#">
                UPDATE
                    ACCOUNT_CARD
                SET
                    IS_OTHER_CURRENCY = <cfif data[1]["IS_OTHER_CURRENCY"] eq 'YES'><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
                    IS_ACCOUNT_CODE2 = <cfif data[1]["IS_ACCOUNT_CODE2"] eq 'YES'><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
                    CARD_DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data[1]["CARD_DETAIL"]#">,
                    CARD_TYPE_NO = <cfqueryparam cfsqltype="cf_sql_integer" value="#data[1]["CARD_TYPE_NO"]#">,
                    CARD_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#data[1]["CARD_CAT_ID"]#">,
                    ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#data[1]["ACTION_TYPE"]#">,
                    ACTION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#data[1]["ACTION_CAT_ID"]#">,
                    CARD_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#data[1]["CARD_TYPE"]#">,
                    ACTION_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#data[1]["ACTION_DATE"]#">,
                    CARD_DOCUMENT_TYPE = <cfif len(data[1]["CARD_DOCUMENT_TYPE"])><cfqueryparam cfsqltype="cf_sql_integer" value="#data[1]["CARD_DOCUMENT_TYPE"]#"><cfelse>NULL</cfif>,
                    CARD_PAYMENT_METHOD = <cfif len(data[1]["CARD_PAYMENT_METHOD"])><cfqueryparam cfsqltype="cf_sql_integer" value="#data[1]["CARD_PAYMENT_METHOD"]#"><cfelse>NULL</cfif>,
                    PAPER_NO = <cfif len(data[1]["PAPER_NO"])><cfqueryparam cfsqltype="cf_sql_varchar" value="#data[1]["PAPER_NO"]#"><cfelse>NULL</cfif>,
                    DUE_DATE = <cfif (data[1]["CARD_DOCUMENT_TYPE"] eq -1 or data[1]["CARD_DOCUMENT_TYPE"] eq -3) and len(data[1]["DUE_DATE"])><cfqueryparam cfsqltype="cf_sql_date" value="#data[1]["DUE_DATE"]#"><cfelse>NULL</cfif>,
                    UPDATE_IP = '#CGI.REMOTE_ADDR#',
                    UPDATE_DATE = #NOW()#,
                    RECORD_TYPE = <cfif len(data[1]["RECORD_TYPE"])>#data[1]["RECORD_TYPE"]#<cfelse>1</cfif>
                WHERE
                    CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_id#">
            </cfquery>
                <cfset response.status = 1>
                <cfset response.message = "Belge Güncelleme Başarıyla Gerçekleşti">
            <cfcatch>
                <cfset response.status = 0>
                <cfset response.message = "Belge Güncelleme Sırasında Bir Sorun Oluştu">
            </cfcatch>
        </cftry>
        <cfreturn response>
    </cffunction>

    <cffunction name="UPD_ACCOUNT_CARD_ROWS" returntype="any" access="public" hint="Muhasebe Fişi Satır Güncelleme">
        <cfargument name="data" required="true">
        <cfargument name="card_id" required="true">
        <cfset response = structNew()>

        <cfquery name="DEL_ROWS" datasource="#arguments.dsn2_alias#">
			DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_id#">
		</cfquery> 
        <cftry>
            <cfloop from="1" to="#arrayLen(data)#" index="i">
                <cfquery name="ADD_ACCOUNT_CARD_ROWS" datasource="#arguments.dsn2_alias#">
                    INSERT INTO
                        ACCOUNT_CARD_ROWS
                        (
                            CARD_ID,
                            ACCOUNT_ID,
                            BA,
                            QUANTITY, 
                            PRICE,
                            AMOUNT,
                            AMOUNT_CURRENCY,
                            AMOUNT_2,
                            AMOUNT_CURRENCY_2,
                            IFRS_CODE,
                            ACCOUNT_CODE2,
                            OTHER_AMOUNT,
                            OTHER_CURRENCY,	
                            IS_RATE_DIFF_ROW,						
                            ACC_DEPARTMENT_ID,
                            ACC_BRANCH_ID,
                            ACC_PROJECT_ID,
                            DETAIL
                        )				
                    VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_id#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data[i]["ACCOUNT_ID"]#">,
                            <cfif data[i]["BA"] eq 'NO'><cfqueryparam cfsqltype="cf_sql_bit" value="0"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="1"></cfif>,
                            <cfif data[i]["QUANTITY"] gt 0>'#data[i]["QUANTITY"]#'<cfelse>0</cfif>,
                            <cfif data[i]["PRICE"] gt 0>'#data[i]["PRICE"]#'<cfelse>0</cfif>, 
                            <cfif data[i]["AMOUNT"] gt 0>#data[i]["AMOUNT"]#</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#data[i]["AMOUNT_CURRENCY"]#">,
                            <cfif data[i]["AMOUNT_2"] gt 0>#data[i]["AMOUNT_2"]#<cfelse>NULL</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#data[i]["AMOUNT_CURRENCY_2"]#">,
                            <cfif len(data[i]["IFRS_CODE"])>'#data[i]["IFRS_CODE"]#'<cfelse>NULL</cfif>,
                            <cfif len(data[i]["ACCOUNT_CODE2"])>'#data[i]["ACCOUNT_CODE2"]#'<cfelse>NULL</cfif>,
                            <cfif data[i]["OTHER_AMOUNT"] gt 0>#data[i]["OTHER_AMOUNT"]#</cfif>,
                            <cfif data[i]["OTHER_AMOUNT"] gt 0>'#data[i]["OTHER_CURRENCY"]#'</cfif>,
                            <cfif data[i]["IS_RATE_DIFF_ROW"] eq 'YES'>1<cfelse>0</cfif>,
                            <cfif len(data[i]["ACC_DEPARTMENT_ID"])>#data[i]["ACC_DEPARTMENT_ID"]#<cfelse>NULL</cfif>,
                            <cfif len(data[i]["ACC_BRANCH_ID"])>#data[i]["ACC_BRANCH_ID"]#<cfelse>NULL</cfif>,
                            <cfif len(data[i]["ACC_PROJECT_ID"])>#data[i]["ACC_PROJECT_ID"]#<cfelse>NULL</cfif>,
                            <cfif len(data[i]["DETAIL"])>'#data[i]["DETAIL"]#'<cfelse>NULL</cfif>
                        )
                </cfquery>
            </cfloop>
                <cfset response.status = 1>
                <cfset response.message = "Satır Kayıtları Başarıyla Gerçekleşti">
            <cfcatch>
                <cfset response.status = 0>
                <cfset response.message = "Satır Kayıtları Sırasında Bir Sorun Oluştu">
            </cfcatch>
        </cftry>
        <cfreturn response>
    </cffunction>

    <cffunction name="DEL_CARD" returntype="any" access="public" hint="Muhasebe Fişi Belge ve Satır Silme">
        <cfargument name="card_id" required="true">
        <cfset response = structNew()>
        <cftry>
            <cfquery name="DEL_CARD" datasource="#arguments.dsn2_alias#">
                DELETE FROM ACCOUNT_CARD WHERE CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_id#">
            </cfquery>
            <cfquery name="DEL_CARD_ROWS" datasource="#arguments.dsn2_alias#">
                DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_id#">
            </cfquery>
            <cfquery name="DEL_CARD_MONEY" datasource="#arguments.dsn2_alias#">
                DELETE FROM ACCOUNT_CARD_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_id#">
            </cfquery>
            <cfquery name="DEL_CARD_RELATION" datasource="#arguments.dsn2_alias#">
                DELETE FROM ACC_CARD_SERVICE_RELATION WHERE CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_id#">
            </cfquery>
            <cfset response.status = 1>
            <cfset response.message = "Silme İşlemi Başarıyla Gerçekleşti">
            <cfcatch>
                <cfset response.status = 0>
                <cfset response.message = "Silme İşlemi Sırasında Bir Sorun Oluştu">
            </cfcatch>
        </cftry>
        <cfreturn response>
    </cffunction>

    <cffunction name="GET_CARD_RELATION" returntype="any" access="public">
        <cfargument name="service_card_id" required="true">
        <cfquery name="GET_CARD_RELATION" datasource="#arguments.dsn2_alias#">
            SELECT CARD_ID FROM ACC_CARD_SERVICE_RELATION WHERE SERVICE_CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_card_id#">
        </cfquery>
        <cfreturn GET_CARD_RELATION>
    </cffunction>

    <cffunction name="GET_PLAN_RELATION" returntype="any" access="public">
        <cfargument name="account_code" required="true">
        <cfquery name="GET_PLAN_RELATION" datasource="#arguments.dsn2_alias#">
            SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.account_code#">
        </cfquery>
        <cfreturn GET_PLAN_RELATION>
    </cffunction>

</cfcomponent>