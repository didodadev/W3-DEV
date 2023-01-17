<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="yes">
<cfset letters = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,r,s,t,u,v,y,z,1,2,3,4,5,6,7,8,9,0">
<cffunction name="add_serial_no" output="false">
	<cfargument name="wrk_row_id" type="string">
	<cfargument name="session_row" type="numeric" required="true">
	<cfargument name="is_insert" type="boolean"><!--- true : ekleme, false guncelleme (sadece depolararasi sevk de kullaniliyor)--->
	<cfargument name="process_type" type="numeric" required="true">
	<cfargument name="process_number" type="string" required="true">
	<cfargument name="process_id" type="numeric" required="true">
	<cfargument name="is_sale" type="boolean" default="false">
	<cfargument name="is_purchase" type="boolean" default="false">
	<cfargument name="dpt_id" type="string" required="true" default=""> <!--- depo id --->
	<cfargument name="loc_id" type="string" default=""> <!--- location_id --->
	<cfargument name="par_id" type="string" default="">
	<cfargument name="promotion_id" type="string" default="">
	<cfargument name="con_id" type="string" default="">
	<cfargument name="main_stock_id" type="string" default="">
	<cfargument name="spect_id" type="string" default="">
	<cfargument name="comp_id" type="string" default="">
    <cfargument name="main_process_id" type="string" default="">
    <cfargument name="main_process_no" type="string" default="">
    <cfargument name="main_process_cat" type="string" default="">
    <cfargument name="main_serial_no" type="string" default="">
    <cfargument name="is_in_out" type="boolean" required="no" default="0">
	<cfif listfindnocase('0,1',arguments.process_type,',')>
		<cfset record_place = 0> <!--- service_guaranty_temp tablosuna yazar --->
	<cfelse>
		<cfset record_place = 1> <!--- service_guaranty_new tablosuna yazar --->
	</cfif>
	<!--- 
		my_in_out = 1 ( giriş) 
		my_in_out = 0 (çıkış)
		my_is_purchase = 1 (alış)
		my_is_sale = 1 (satış)
	--->
	<cfif listfindnocase('73,74,75,76,77,80,82,84,86,87,110,115,140',arguments.process_type,',')><!--- Alış ve giriş --->
		<cfset my_is_purchase = 1>
		<cfset my_is_sale = 0>
		<cfset my_in_out = 1>
		<cfset my_seri_sonu = 0>
	<cfelseif listfindnocase('70,71,72,78,79,88,83,141',arguments.process_type,',')><!--- Satış ve çıkış --->
		<cfset my_is_purchase = 0>
		<cfset my_is_sale = 1>
		<cfset my_in_out = 0>
		<cfset my_seri_sonu = 0>
	<cfelseif listfindnocase('118,116',arguments.process_type,',')><!--- satış alış yok giriş (116-stok virman giriş) --->
		<cfset my_is_purchase = 0>
		<cfset my_is_sale = 0>
        <cfif isdefined("arguments.is_in_out") and arguments.is_in_out eq 0>
        	<cfset my_in_out = 0>
        <cfelse>
        	<cfset my_in_out = 1>
        </cfif>
		<cfset my_seri_sonu = 0>
	<cfelseif listfindnocase('85,111,112,1182',arguments.process_type,',')>
		<cfset my_is_purchase = 0>
		<cfset my_is_sale = 0>
		<cfset my_in_out = 0>
		<cfset my_seri_sonu = 0>
	<cfelseif listfindnocase('171,114',arguments.process_type,',')><!--- TolgaS 20060428 üretim sonucunda üretilen ürünler satılabilir ve in_out 1 set edildi--->
		<cfset my_is_purchase = 0>
		<cfset my_is_sale = 0>
		<cfset my_in_out = 1>
		<cfset my_seri_sonu = 0>
	<cfelseif listfindnocase('1131',arguments.process_type,',')><!--- seri sonu ürünler satılabilir ve in_out 1 set edildi ayrica seri sonu ibaresi de 1 oldu--->
		<cfset my_is_purchase = 0>
		<cfset my_is_sale = 0>
		<cfset my_in_out = 1>
		<cfset my_seri_sonu = 1>
    <cfelseif listfindnocase('81,811,113',arguments.process_type,',')> <!--- depolararası sevk,İTHAL MAL GİRİŞ,ambar fişi giriş ve çıkış kayıtları atılıyor --->
		 <cfif isdefined("arguments.is_in_out") and arguments.is_in_out eq 0>
        	<cfset my_in_out = 0>
            <cfset my_is_purchase = 0>
			<cfset my_is_sale = 1>
        <cfelse>
        	<cfset my_in_out = 1>
            <cfset my_is_purchase = 1>
			<cfset my_is_sale = 0>
        </cfif>
		<cfset my_seri_sonu = 0>
	<cfelse>
		<cfset my_is_purchase = 0>
		<cfset my_is_sale = 0>
		<cfset my_in_out = 0>
		<cfset my_seri_sonu = 0>
	</cfif>

	<cfset is_insert = 1>
	<cfif listfindnocase('73,74,75,86',arguments.process_type,',')>
		<cfset control_sale_purchase = 1>
	<cfelseif listfindnocase('78,79,85',arguments.process_type,',')>
		<cfset control_sale_purchase = 0>
	</cfif>
	<cfif listfindnocase('73,74,75,78,79',arguments.process_type,',')>
		<cfset my_is_return = 1>
	<cfelse>
		<cfset my_is_return = 0>
	</cfif>
	<cfif listfindnocase('85',arguments.process_type,',')>
		<cfset my_is_rma = 1>
	<cfelse>
		<cfset my_is_rma = 0>
	</cfif>
	<cfif listfindnocase('112',arguments.process_type,',')>
		<cfset my_is_trash = 1>
	<cfelse>
		<cfset my_is_trash = 0>
	</cfif>
	<cfif listfindnocase('111',arguments.process_type,',') or listfindnocase('1719',arguments.process_type,',') or (len(arguments.main_stock_id) and listfindnocase('171',arguments.process_type,','))>
		<cfset my_is_sarf = 1>
	<cfelse>
		<cfset my_is_sarf = 0>
	</cfif>
	<cfif not isdefined("temp_date")>
    	<cfif isdefined("attributes.guaranty_cat#session_row#") and len(evaluate('attributes.guaranty_cat#session_row#'))>
            <cfquery name="get_guaranty_time_" datasource="#dsn3#">
                SELECT (SELECT GUARANTYCAT_TIME FROM #dsn_alias#.SETUP_GUARANTYCAT_TIME WHERE GUARANTYCAT_TIME_ID = SETUP_GUARANTY.GUARANTYCAT_TIME) GUARANTYCAT_TIME_ FROM  #dsn_alias#.SETUP_GUARANTY WHERE GUARANTYCAT_ID = #evaluate('attributes.guaranty_cat#session_row#')#
            </cfquery>
        </cfif>
		<cfif isdefined("attributes.guaranty_startdate#arguments.session_row#") and len(evaluate('attributes.guaranty_startdate#arguments.session_row#'))>
			<cfset temp_start_date = evaluate('attributes.guaranty_startdate#arguments.session_row#')>
		</cfif>
		<cfif isdefined("temp_start_date") and isdate(temp_start_date) and isdefined("get_guaranty_time_.GUARANTYCAT_TIME_") and Len(get_guaranty_time_.GUARANTYCAT_TIME_)>
			<cf_date tarih="temp_start_date">
			<cfset temp_date = date_add("m",get_guaranty_time_.GUARANTYCAT_TIME_,temp_start_date)>
		</cfif>
	</cfif>
    
	<cfif isDefined("temp_start_date") and isdate(temp_start_date)><cf_date tarih="temp_start_date"></cfif>
	<cfif isDefined("temp_date") and isdate(temp_date)><cf_date tarih="temp_date"></cfif>
    
    <cfset subscription_id_ = "">
    <cfif listfindnocase('70,71,72,73,74,75,76,77,78,79,80,81,811,82,83,84,88,761,85,86,140,141',arguments.process_type,',') and len(arguments.process_id)><!--- irs --->
		<cfquery name="get_subscription" datasource="#dsn2#">
        	SELECT SUBSCRIPTION_ID FROM SHIP WHERE SHIP_ID = #arguments.process_id#
        </cfquery>
        <cfif get_subscription.recordcount>
			<cfset subscription_id_ = get_subscription.SUBSCRIPTION_ID>
        </cfif>
    <cfelseif listfindnocase('110,111,112,113,114,115,119,1131,118,1182 ',arguments.process_type,',') and len(arguments.process_id)>
    	<cfquery name="get_subscription" datasource="#dsn2#">
        	SELECT SUBSCRIPTION_ID FROM STOCK_FIS WHERE FIS_ID = #arguments.process_id#
        </cfquery>
        <cfif get_subscription.recordcount>
			<cfset subscription_id_ = get_subscription.SUBSCRIPTION_ID>
        </cfif>
    </cfif>
	<cfset aktif_satir = 0>
    <cfif is_insert>
    	<cfset baslangic_degeri = 1>
        <cfset blok_sayisi = 400>
        <cfif listlen(evaluate('attributes.serial_no_start_number#arguments.session_row#')) gt 400>
        	<cfset ilk_deger = listfirst(listlen(evaluate('attributes.serial_no_start_number#arguments.session_row#'))/400,'.')>
            <cfif listlen(evaluate('attributes.serial_no_start_number#arguments.session_row#')) mod 400 neq 0>
            	<cfset ilk_deger = ilk_deger + 1>
            </cfif>
        	<cfset list_uzunluk = ilk_deger>
        <cfelse>
			<cfset list_uzunluk = 1>
        </cfif>
    <cfloop from="1" to="#list_uzunluk#" index="aaa">
    	<cfif blok_sayisi gt listlen(evaluate('attributes.serial_no_start_number#arguments.session_row#'))>
        	<cfset blok_sayisi = listlen(evaluate('attributes.serial_no_start_number#arguments.session_row#'))>
        </cfif>
        <cfif blok_sayisi eq 0>
        	<cfset blok_sayisi = listlen(evaluate('attributes.lot_no'))>
        </cfif>
            <cfquery name="add_guaranty" datasource="#dsn3#" result="xxx"> 
                INSERT INTO
                    SERVICE_GUARANTY_NEW
                (
                    WRK_ID,
                    WRK_ROW_ID,
                    STOCK_ID,
                    MAIN_STOCK_ID,
                    LOT_NO,
                    RMA_NO,
                    REFERENCE_NO,
                    PROMOTION_ID,
                    <cfif evaluate('attributes.guaranty_purchasesales#arguments.session_row#') eq 0>
                        PURCHASE_GUARANTY_CATID,
                        PURCHASE_START_DATE,
                        PURCHASE_FINISH_DATE,
                        <cfif len(arguments.comp_id)>PURCHASE_COMPANY_ID,
                        <cfelseif len(arguments.con_id)>PURCHASE_CONSUMER_ID,</cfif>
                        <cfif len(arguments.par_id)>PURCHASE_PARTNER_ID,</cfif>
                    <cfelse>
                        SALE_GUARANTY_CATID,
                        SALE_START_DATE,
                        SALE_FINISH_DATE,
                        <cfif len(arguments.comp_id)>SALE_COMPANY_ID,
                        <cfelseif len(arguments.con_id)>SALE_CONSUMER_ID,</cfif>
                        <cfif len(arguments.par_id)>SALE_PARTNER_ID,</cfif>
                    </cfif>	
                    IN_OUT,
                    IS_SALE,
                    IS_PURCHASE,
                    IS_SERVICE,
                    IS_SARF,
                    IS_RMA,
                    IS_SERI_SONU,
                    IS_RETURN,
                    PROCESS_ID,
                    PROCESS_NO,
                    PROCESS_CAT,
                    PERIOD_ID,
                    DEPARTMENT_ID,
                    LOCATION_ID,
                    SERIAL_NO,
                    SPECT_ID,
                    MAIN_PROCESS_ID,
                    MAIN_PROCESS_NO,
                    MAIN_PROCESS_TYPE,
                    MAIN_SERIAL_NO,
                    SUBSCRIPTION_ID,
                    <cfif isDefined('session.ep.userid')>
	                    RECORD_EMP,
					</cfif>
                    RECORD_IP,
                    RECORD_DATE
                )
                <cfloop from="#baslangic_degeri#" to="#blok_sayisi#" index="j">
                    <cfif isdefined("attributes.is_dynamic_lot_no")>
                        <cfset password = ''>
                        <cfloop from="1" to="6" index="ind">				     
                            <cfset random = RandRange(1,33)>
                            <cfset password = "#password##ListGetAt(letters,random,',')#">
                        </cfloop>
                        <cfset password = "#ucase(password)#">
                    </cfif>
                    <cfif arguments.process_type eq 141 and isdefined("attributes.out_stock_id")>
                        <cfif attributes.stock_id1 eq attributes.out_stock_id>
                            <cfquery name="check_stock_serial" datasource="#dsn3#" maxrows="1">
                                SELECT GUARANTY_ID FROM SERVICE_GUARANTY_NEW WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.out_stock_id#"> AND SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(evaluate('attributes.serial_no_start_number#arguments.session_row#'),j)#"> AND PROCESS_CAT = 140 AND PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.out_ship_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#"> AND RETURN_SERIAL_NO IS NULL ORDER BY GUARANTY_ID DESC
                            </cfquery>
                            <cfif check_stock_serial.recordcount>
                                <cfset is_insert = 1>
                                <cfset servis_degisim = 0>
                                <cfset GET_MAX.MAX_ID = check_stock_serial.guaranty_id>
                            <cfelse>
                                <cfset servis_degisim = 1> <!--- en altta kullandim --->
                                <cfset is_insert = 1>
                            </cfif>
                        <cfelse>
                            <cfset servis_degisim = 1><!--- en altta kullandim --->
                            <cfset is_insert = 1>
                        </cfif>
                    </cfif>
                
                    <cfif arguments.process_type eq 86>
                        <cfset is_insert = 1>
                    </cfif>
                
                    <cfset aktif_satir = aktif_satir + 1>
                    <cfset servis_degisim = 0>
                     <cfif isDefined('session.ep.userid') and (not isdefined("attributes.lot_no") and not len(evaluate('attributes.lot_no')))>
	                    <cfset wrk_id = '#listgetat(evaluate("attributes.serial_no_start_number#arguments.session_row#"),j)#' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>	
					<cfelseif (not isdefined("attributes.lot_no") and not len(evaluate('attributes.lot_no')))>
	                    <cfset wrk_id = '#listgetat(evaluate("attributes.serial_no_start_number#arguments.session_row#"),j)#' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_'&round(rand()*100)>	                    
                    <cfelse>
	                    <cfset wrk_id = '#evaluate("attributes.lot_no")#' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_'&round(rand()*100)>	                    
                    </cfif>
                    
                    <!--- Burasi Bir Onceki Stok ve Seriye Ait Satis Tipli Islemin Satis Garanti Bilgilerini Kopyalamak Icin Eklendi, Checkbox ile Gelir FBS 20130129 --->
                    <cfif my_is_sale eq 1 and isdefined("attributes.stock_id#arguments.session_row#") and isDefined("attributes.is_last_guaranty_control")>
                        <cfquery name="get_sale_serial_guaranty" datasource="#dsn3#">
                            SELECT TOP 1 SALE_GUARANTY_CATID, SALE_START_DATE, SALE_FINISH_DATE FROM SERVICE_GUARANTY_NEW WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.stock_id#arguments.session_row#')#"> AND SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(evaluate('attributes.serial_no_start_number#arguments.session_row#'),j)#"> AND IS_SALE = 1 ORDER BY GUARANTY_ID DESC
                        </cfquery>
                        <cfif get_sale_serial_guaranty.recordcount>
                            <cfif Len(get_sale_serial_guaranty.sale_guaranty_catid)><cfset "attributes.guaranty_cat#arguments.session_row#" = get_sale_serial_guaranty.sale_guaranty_catid></cfif>
                            <cfif Len(get_sale_serial_guaranty.sale_guaranty_catid)><cfset "temp_start_date" = CreateOdbcDateTime(get_sale_serial_guaranty.sale_start_date)></cfif>
                            <cfif Len(get_sale_serial_guaranty.sale_guaranty_catid)><cfset "temp_date" = CreateOdbcDateTime(get_sale_serial_guaranty.sale_finish_date)></cfif>
                        </cfif>
                    </cfif>
                    <!--- //Burasi Bir Onceki Stok ve Seriye Ait Satis Tipli Islemin Satis Garanti Bilgilerini Kopyalamak Icin Eklendi, Checkbox ile Gelir FBS 20130129 --->
                    <!--- // Eğer seri aktarım ile içeri alınmışsa garanti bilgilerini taşımak için eklendi PY 0515 --->
                    <cfif (not isdefined("attributes.lot_no") and not len(evaluate('attributes.lot_no')))>
                        <cfquery name="get_old_rec" datasource="#dsn3#">
                            SELECT top 1 PURCHASE_START_DATE,PURCHASE_FINISH_DATE,PURCHASE_GUARANTY_CATID FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO = '#trim(listgetat(evaluate('attributes.serial_no_start_number#arguments.session_row#'),j))#' AND STOCK_ID = #evaluate('attributes.stock_id#arguments.session_row#')# AND PROCESS_CAT = 1190 ORDER BY GUARANTY_ID DESC
                        </cfquery>
						<cfif get_old_rec.recordcount>
                            <cfif Len(get_old_rec.PURCHASE_GUARANTY_CATID)><cfset "attributes.guaranty_cat#arguments.session_row#" = get_old_rec.PURCHASE_GUARANTY_CATID></cfif>
                            <cfif Len(get_old_rec.PURCHASE_GUARANTY_CATID)><cfset "temp_start_date" = CreateOdbcDateTime(get_old_rec.PURCHASE_START_DATE)></cfif>
                            <cfif Len(get_old_rec.PURCHASE_GUARANTY_CATID)><cfset "temp_date" = CreateOdbcDateTime(get_old_rec.PURCHASE_FINISH_DATE)></cfif>
                        </cfif>
                    </cfif>
                    SELECT 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
                        <cfif isdefined("arguments.wrk_row_id") and len(arguments.wrk_row_id)>'#arguments.wrk_row_id#',<cfelse>NULL,</cfif>
                        #evaluate('attributes.stock_id#arguments.session_row#')#,
                        <cfif len(arguments.main_stock_id)>#arguments.main_stock_id#,<cfelse>NULL,</cfif>
                        <cfif isdefined("attributes.is_dynamic_lot_no")>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#password#">,
                        <cfelseif isdefined("attributes.row_lot_no#arguments.session_row#") and listgetat(evaluate('attributes.row_lot_no#arguments.session_row#'),aktif_satir,',') is not '*_*'>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(evaluate('attributes.row_lot_no#arguments.session_row#'),aktif_satir,',')#">,
                        <cfelseif evaluate('attributes.lot_no') neq '*_*' and isdefined("attributes.lot_no") and len(evaluate('attributes.lot_no'))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no')#">,
                        <cfelse>
                            '',
                        </cfif>
                        <cfif isdefined("attributes.row_rma_no#arguments.session_row#") and listgetat(evaluate('attributes.row_rma_no#arguments.session_row#'),aktif_satir,',') is not '*_*'>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(evaluate('attributes.row_rma_no#arguments.session_row#'),aktif_satir,',')#">,
                        <cfelse>
                            '',
                        </cfif>
                        <cfif isdefined("attributes.ref_no#arguments.session_row#") and listgetat(evaluate('attributes.ref_no#arguments.session_row#'),aktif_satir,',') is not '*_*'>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(evaluate('attributes.ref_no#arguments.session_row#'),aktif_satir,',')#">,
                        <cfelse>
                            '',
                        </cfif>
                        <cfif len(arguments.promotion_id)>#arguments.promotion_id#,<cfelse>NULL,</cfif>
                        <cfif evaluate('attributes.guaranty_purchasesales#arguments.session_row#') eq 0>
                            <cfif isdefined('attributes.guaranty_cat#arguments.session_row#') and len(evaluate('attributes.guaranty_cat#arguments.session_row#'))>#evaluate('attributes.guaranty_cat#arguments.session_row#')#<cfelse>NULL</cfif>,
                            <cfif isdefined("temp_start_date") and len(temp_start_date)>#temp_start_date#,<cfelse>NULL,</cfif>
                            <cfif isdefined("temp_date") and len(temp_date)>#temp_date#,<cfelse>NULL,</cfif>
                            <cfif len(arguments.comp_id)>#arguments.comp_id#,<cfelseif len(arguments.con_id)>#arguments.con_id#,</cfif>
                            <cfif len(arguments.par_id)>#arguments.par_id#,</cfif>
                        <cfelse>
                            <cfif isdefined('attributes.guaranty_cat#arguments.session_row#') and len(evaluate('attributes.guaranty_cat#arguments.session_row#'))>#evaluate('attributes.guaranty_cat#arguments.session_row#')#<cfelse>NULL</cfif>,
                            <cfif isdefined("temp_start_date") and len(temp_start_date)>#temp_start_date#,<cfelse>NULL,</cfif>
                            <cfif isdefined("temp_date") and len(temp_date)>#temp_date#,<cfelse>NULL,</cfif>
                            <cfif len(arguments.comp_id)>#arguments.comp_id#,<cfelseif len(arguments.con_id)>#arguments.con_id#,</cfif>
                            <cfif len(arguments.par_id)>#arguments.par_id#,</cfif>
                        </cfif>
                        #my_in_out#,
                        #my_is_sale#,
                        #my_is_purchase#,
                        <cfif arguments.process_type eq 140>1,<cfelse>0,</cfif>
                        #my_is_sarf#,
                        #my_is_rma#,
                        #my_seri_sonu#,
                        #my_is_return#,
                        #arguments.process_id#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.process_number#">,
                        #arguments.process_type#,
                        #session_base.period_id#,
                        <cfif len(arguments.dpt_id)>#arguments.dpt_id#<cfelse>NULL</cfif>,
                        <cfif len(arguments.loc_id)>#arguments.loc_id#<cfelse>NULL</cfif>,
                        <cfif listlen(evaluate('attributes.serial_no_start_number#arguments.session_row#')) and trim(listgetat(evaluate('attributes.serial_no_start_number#arguments.session_row#'),j)) is not '---'><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(listgetat(evaluate('attributes.serial_no_start_number#arguments.session_row#'),j))#"><cfelse>NULL</cfif>,
                        <cfif len(arguments.spect_id)>#arguments.spect_id#,<cfelse>NULL,</cfif>
                        <cfif len(arguments.main_process_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.main_process_id#">,<cfelse>NULL,</cfif>
                        <cfif len(arguments.main_process_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.main_process_no#">,<cfelse>NULL,</cfif>
                        <cfif len(arguments.main_process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.main_process_cat#">,<cfelse>NULL,</cfif>
                        <cfif len(arguments.main_serial_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.main_serial_no#">,<cfelse>NULL,</cfif>
                        <cfif len(subscription_id_)><cfqueryparam cfsqltype="cf_sql_varchar" value="#subscription_id_#">,<cfelse>NULL,</cfif>
                        <cfif isDefined('session.ep.userid')>
	                        #session.ep.userid#,
						</cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                        #NOW()#
                        <cfif j neq blok_sayisi>
                            UNION ALL
                        </cfif>
                </cfloop>
            </cfquery>
        	<cfset baslangic_degeri = baslangic_degeri+400>
        	<cfset blok_sayisi = blok_sayisi + 400>
    </cfloop>
    </cfif>
	<cfreturn true>
</cffunction>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
