<cfset attributes.process_stage = 8>
<cfset hata_mesaj = "">
<cfset sayac = 0>
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfif len(first_card_no) and len(last_card_no)>
    <cfloop from="#attributes.first_card_no#" to="#attributes.last_card_no#" index="kkk">
    	<cfset cc = PrecisionEvaluate(kkk + 0)>
        <cfset cc = listgetat(cc,1,'.')>
    	<cfset sayac = sayac + 1>
        <cfset uye_kod_uyari = "">
    	<cftry>
            <cfquery name="get_consumer_member_code" datasource="#dsn#">
                SELECT CONSUMER_ID FROM CONSUMER WHERE MEMBER_CODE = '#trim(cc)#'
            </cfquery>
            <cfquery name="get_customer_card" datasource="#dsn#">
                SELECT CARD_NO FROM CUSTOMER_CARDS WHERE CARD_NO = '#trim(cc)#'
            </cfquery>
            <cfif get_consumer_member_code.recordcount>
           		<cfset uye_kod_uyari = "Aynı Üye Kodu Kullanılıyor!">
            </cfif>
             <cfif get_customer_card.recordcount>
           		<cfset uye_kod_uyari = "Aynı Kart Numarası Kullanılıyor!">
            </cfif>
            <cfif not get_consumer_member_code.recordcount  and not get_customer_card.recordcount>
                <cftransaction>
                    <cfquery name="ADD_CONSUMER" datasource="#DSN#" result="my_result">
                        INSERT INTO
                            CONSUMER
                            (
                                WRK_ID,
                                CONSUMER_STAGE,
                                CONSUMER_CAT_ID,
                                CONSUMER_NAME,
                                CONSUMER_SURNAME,
                                IS_CARI,
                                USE_EFATURA,
                                ISPOTANTIAL,
                                RECORD_IP,
                                RECORD_MEMBER,
                                RECORD_DATE
                            )
                                VALUES 	 
                            (
                                '#wrk_id#',
                                #attributes.process_stage#,
                                1,
                                #sql_unicode()#'Yeni',
                                #sql_unicode()#'Müşteri',
                                1,
                                0,
                                0,
                                '#cgi.remote_addr#',
                                #session.ep.userid#,
                                #now()#
                       	 )
                    </cfquery>
                     <cfquery name="GET_ACC_INFO" datasource="#dsn#">
                        SELECT PUBLIC_ACCOUNT_CODE FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
                    </cfquery>
                    <cfquery name="ADD_CONS_PERIOD" datasource="#DSN#">
                        INSERT INTO
                            CONSUMER_PERIOD
                                (
                                    CONSUMER_ID,
                                    PERIOD_ID,
                                    ACCOUNT_CODE
                                )
                            VALUES
                                (
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#my_result.IDENTITYCOL#">,
                                    #session.ep.period_id#,
                                    <cfif len(GET_ACC_INFO.PUBLIC_ACCOUNT_CODE)>'#GET_ACC_INFO.PUBLIC_ACCOUNT_CODE#'<cfelse>NULL</cfif>
                                )
                    </cfquery>
                    <cfquery name="Add_Customer_Cards" datasource="#dsn#">
                        INSERT INTO
                            CUSTOMER_CARDS
                        (
                            ACTION_TYPE_ID,
                            ACTION_ID,
                            CARD_NO,
                            CARD_STARTDATE,
                            CARD_FINISHDATE,
                            CARD_STATUS,
                            CARD_DETAIL,
                            CHANGE_TYPE_ID,
                            RECORD_EMP,
                            RECORD_DATE,
                            RECORD_IP
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="CONSUMER_ID">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#my_result.IDENTITYCOL#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cc#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('yyyy',50,now())#">,
                            <cfqueryparam cfsqltype="cf_sql_smallint" value="1">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                        )
                    </cfquery>
                </cftransaction>
                <cftransaction>
                    <cfquery name="GET_LAST_ID" datasource="#dsn_GEN#">
                        SELECT MAX(ID) MAX_ID FROM CUSTOMER
                    </cfquery>
                    <cfset gen_max_id = get_last_id.max_id + 1>
                    <cfquery name="gen_customer_ekle" datasource="#dsn_GEN#">
                        INSERT INTO 
                            CUSTOMER
                        (
                            ID,
                            NAME,
                            CODE
                        )
                        VALUES
                        (
                            #gen_max_id#,
                            'Yeni Müşteri',
                            'C-#my_result.IDENTITYCOL#'
                        )
                    </cfquery>

                    <cfquery name="GET_LAST_LOCATION" datasource="#dsn_GEN#">
                        SELECT MAX(ID) MAX_ID FROM LOCATION
                    </cfquery>
                    <cfquery name="gen_customer_location_ekle" datasource="#dsn_GEN#">
                        INSERT INTO 
                            LOCATION
                        (
                        	ID,
                            CODE,
                            DESCRIPTION,
                            FK_CITY,
                            FK_COUNTRY
                       
                        )
                        VALUES
                        (
                        	#GET_LAST_LOCATION.MAX_ID+1#,
                            '#gen_max_id#',
                            '1',
                            1,
                            1
                        )
                    </cfquery>
                    
                    <cfquery name="GET_LAST_CUSTOMER_EXTENSION_ID" datasource="#dsn_GEN#">
                        SELECT MAX(ID) MAX_ID FROM CUSTOMER_EXTENSION
                    </cfquery>
                    <cfquery name="gen_customer_extension_ekle" datasource="#dsn_GEN#">
                        INSERT INTO 
                            CUSTOMER_EXTENSION
                        (
                        	ID,
                            FK_CUSTOMER,
                            FK_LOCATION_HOME
                       
                        )
                        VALUES
                        (
                        	#GET_LAST_CUSTOMER_EXTENSION_ID.MAX_ID+1#,
                            #gen_max_id#,
                            #GET_LAST_LOCATION.MAX_ID+1#
                        )
                    </cfquery>
                    
                    
                    <cfquery name="GET_LAST_CARD_ID" datasource="#dsn_GEN#">
                        SELECT MAX(ID) MAX_ID FROM CARD
                    </cfquery>
                     <cfquery name="gen_customer_extension_ekle" datasource="#dsn_GEN#">
                        INSERT INTO 
                            CARD
                        (
                            ID,
                            CODE,
                            FK_CUSTOMER,
                            STATUS,
                            GIVEN_DATE,
                            EXPIRE_DATE
                            
                       
                        )
                        VALUES
                        (
                            #GET_LAST_CARD_ID.MAX_ID+1#,
                            '#cc#',
                            #gen_max_id#,
                            2,
                            #createODBCdate(now())#,
                            #createODBCdate(dateadd('yyyy',7,now()))#
                            
                        )
                    </cfquery>
                   </cftransaction>
                    <cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
                        UPDATE 
                            CONSUMER 
                        SET		
                            PERIOD_ID = #session.ep.period_id#,
                            MEMBER_CODE = 'C-#my_result.IDENTITYCOL#',
                            GENIUS_ID = #gen_max_id#
                        WHERE 
                            CONSUMER_ID = #my_result.IDENTITYCOL#
                    </cfquery>
           	<cfelse>
            	<cfsavecontent variable="hata_mesaj">
					<cfoutput>
                    #hata_mesaj#
                    <br>
                    #sayac#. satır #cc# kart numarası için hata : #uye_kod_uyari#
                    </cfoutput>
                </cfsavecontent>
            </cfif>
        <cfcatch>
        	<cfdump var="#cfcatch#">
            <cfsavecontent variable="hata_mesaj">
            <cfoutput>
            	#hata_mesaj#
                <br>
                #sayac#. satır #cc# kart numarası için hata : işlem başarısız.
             </cfoutput>
            </cfsavecontent>
        </cfcatch>
		</cftry>
    </cfloop>
</cfif>
<cf_form_box title="Kart Aktarım Sonucu">
<table>
	<tr>
    	<td>
		  <cfoutput>
            	İşlem Kodu : #wrk_id# <br>
                Başlangıç Numarası: #attributes.first_card_no# <br>
                Bitiş Numarası: #attributes.last_card_no# <br>
                Kayıt Sayısı: #sayac# <br>
              #hata_mesaj#
            </cfoutput>
        </td>
    </tr>
</table>

</cf_form_box>
<script>
    alert('İşlem sağlandı');
    history.back();
</script>