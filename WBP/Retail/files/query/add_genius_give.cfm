<cf_date tarih='attributes.give_date'>
<cfset yil_ = year(attributes.give_date)>
<cfset ay_ = month(attributes.give_date)>
<cfset gun_ = day(attributes.give_date)>

<cflock timeout="30">
    <cfquery name="get_cont" datasource="#dsn_Dev#">
        SELECT CON_ID FROM POS_CONS WHERE CON_DATE = #attributes.give_date# AND ZNO = '#attributes.z_number#' AND KASA_NUMARASI = #attributes.kasa_numarasi#
    </cfquery>
    
    <cfquery name="get_money_dolar" datasource="#dsn#">
        SELECT TOP 1 RATE3 FROM MONEY_HISTORY WHERE MONEY = 'USD' AND VALIDATE_DATE <= #attributes.give_date# ORDER BY VALIDATE_DATE DESC
    </cfquery>
    <cfquery name="get_money_euro" datasource="#dsn#">
        SELECT TOP 1 RATE3 FROM MONEY_HISTORY WHERE MONEY = 'EUR' AND VALIDATE_DATE <= #attributes.give_date# ORDER BY VALIDATE_DATE DESC
    </cfquery>
    <cfset dolar_carpan = get_money_dolar.RATE3>
    <cfset euro_carpan = get_money_euro.RATE3>
    
    <cfset attributes.kayit_user = attributes.employee_id>
    <cfif get_cont.recordcount>
        <cfquery name="del_p" datasource="#dsn_dev#">
            DELETE FROM POS_CONS_PAYMENTS WHERE CON_ID = #get_cont.CON_ID#
        </cfquery>
        <cfquery name="del_R" datasource="#dsn_dev#">
            DELETE FROM POS_CONS_BANKNOTES WHERE CON_ID = #get_cont.CON_ID#
        </cfquery>
    </cfif>    
    
    <cfquery name="get_banknot_types" datasource="#dsn_dev#">
        SELECT * FROM BANKNOTE_TYPES ORDER BY TYPE_MULTIPLIER DESC
    </cfquery>
    
    <cfset toplam_iade_tutar_ = 0>
    
    <cfif get_cont.recordcount>
        <cfquery name="upd_" datasource="#dsn_dev#">
            UPDATE
                POS_CONS
            SET
                CON_DATE = #attributes.give_date#,
                KASA_NUMARASI = #attributes.kasa_numarasi#,
                ZNO = '#attributes.z_number#',
                KASIYER_NO = #attributes.employee_id#,
                SATIS_TOPLAM = #filternum(attributes.satis_toplam)#,
                IADE_TOPLAM = #filternum(attributes.iade_toplam)#,
                TESLIMAT_TOPLAM = #filternum(attributes.teslimat_toplam)#,
                ACIK_TOPLAM = #filternum(attributes.kasiyer_acik_toplam)#,
                FAZLA_TOPLAM = #filternum(attributes.kasiyer_fazla_toplam)#,
                KDV_MATRAH0 = #filternum(attributes.KDV_MATRAH0)#,
                KDV_MATRAH1 = #filternum(attributes.KDV_MATRAH1)#,
                KDV_MATRAH8 = #filternum(attributes.KDV_MATRAH8)#,
                KDV_MATRAH18 = #filternum(attributes.KDV_MATRAH18)#,
                KDV0 = #filternum(attributes.KDV0)#,
                KDV8 = #filternum(attributes.KDV8)#,
                KDV1 = #filternum(attributes.KDV1)#,
                KDV18 = #filternum(attributes.KDV18)#,
                KDVLI0 = #filternum(attributes.KDVLI0)#,
                KDVLI1 = #filternum(attributes.KDVLI1)#,
                KDVLI8 = #filternum(attributes.KDVLI8)#,
                KDVLI18 = #filternum(attributes.KDVLI18)#,
                UPDATE_EMP = #session.ep.userid#, 
                UPDATE_DATE = #now()#,
                DOLAR_CARPAN = #DOLAR_CARPAN#,
                EURO_CARPAN = #EURO_CARPAN#
           WHERE
                CON_ID = #get_cont.CON_ID#
        </cfquery>
        <cfset max_id_con_id = get_cont.CON_ID>
    <cfelse>
        <cfquery name="add_" datasource="#dsn_dev#" result="max_r">
            INSERT INTO
                POS_CONS
                (
                CON_DATE,
                KASA_NUMARASI,
                ZNO,
                KASIYER_NO,
                IADE_TOPLAM,
                SATIS_TOPLAM,
                TESLIMAT_TOPLAM,
                ACIK_TOPLAM,
                FAZLA_TOPLAM,
                KDV_MATRAH0,
                KDV_MATRAH1,
                KDV_MATRAH8,
                KDV_MATRAH18,
                KDV0,
                KDV8,
                KDV1,
                KDV18,
                KDVLI0,
                KDVLI1,
                KDVLI8,
                KDVLI18,
                RECORD_EMP,
                RECORD_DATE,
                UPDATE_EMP,
                UPDATE_DATE,
                DOLAR_CARPAN,
                EURO_CARPAN
                )
                VALUES
                (
                #attributes.give_date#,
                #attributes.kasa_numarasi#,
                '#attributes.z_number#',
                #attributes.employee_id#,
                #filternum(attributes.iade_toplam)#,
                #filternum(attributes.satis_toplam)#,
                #filternum(attributes.teslimat_toplam)#,
                #filternum(attributes.kasiyer_acik_toplam)#,
                #filternum(attributes.kasiyer_fazla_toplam)#,
                #filternum(attributes.KDV_MATRAH0)#,
                #filternum(attributes.KDV_MATRAH1)#,
                #filternum(attributes.KDV_MATRAH8)#,
                #filternum(attributes.KDV_MATRAH18)#,
                #filternum(attributes.KDV0)#,
                #filternum(attributes.KDV8)#,
                #filternum(attributes.KDV1)#,
                #filternum(attributes.KDV18)#,
                #filternum(attributes.KDVLI0)#,
                #filternum(attributes.KDVLI1)#,
                #filternum(attributes.KDVLI8)#,
                #filternum(attributes.KDVLI18)#,
                #session.ep.userid#,
                #now()#,
                #session.ep.userid#,
                #now()#,
                #DOLAR_CARPAN#,
                #EURO_CARPAN#
                )
        </cfquery>
        <cfset max_id_con_id = max_r.identitycol>
    </cfif>
    
    <cfif attributes.kasiyer_acik_toplam lt 0>
    	<cfquery name="upd_" datasource="#dsn_dev#">
        	UPDATE
            	POS_CONS
            SET
            	ODEME_ACIK_TUTAR = # filternum(attributes.kasiyer_acik_toplam) + 4.5#
            WHERE
            	CON_ID = #max_id_con_id#
        </cfquery>
    <cfelse>
    	<cfquery name="upd_" datasource="#dsn_dev#">
        	UPDATE
            	POS_CONS
            SET
            	ODEME_ACIK_TUTAR = 0
            WHERE
            	CON_ID = #max_id_con_id#
        </cfquery>
    </cfif>
    
    <cftransaction>
        <cfoutput query="get_banknot_types">
            <cfquery name="add_banknot" datasource="#dsn_dev#">
                INSERT INTO
                    POS_CONS_BANKNOTES
                    (
                    CON_ID,
                    TYPE_ID,
                    TYPE_ADET,
                    TYPE_TUTAR,
                    TYPE_MULTIPLIER
                    )
                    VALUES
                    (
                    #max_id_con_id#,
                    #TYPE_ID#,
                    <cfif len(evaluate("attributes.MONEY_ADET_#TYPE_ID#"))>
                        #filternum(evaluate("attributes.MONEY_ADET_#TYPE_ID#"))#,
                        #filternum(evaluate("attributes.MONEY_TUTAR_#TYPE_ID#"))#,
                    <cfelse>
                        0,
                        0,
                    </cfif>
                    #evaluate("attributes.MONEY_#TYPE_ID#")#
                    )
            </cfquery>
        </cfoutput>
        
        <cfloop from="1" to="#attributes.odeme_satir#" index="row_id">
            <cfif len(evaluate("attributes.teslim_tutar_#row_id#")) and (filterNum(evaluate("attributes.teslim_tutar_#row_id#")) gt 0 or filterNum(evaluate("attributes.satis_tutar_#row_id#")) gt 0)>
                <cfquery name="add_rows" datasource="#dsn_dev#">
                    INSERT INTO
                        POS_CONS_PAYMENTS
                        (
                        CON_ID,
                        ODEME_TURU,
                        SATIS_TUTAR,
                        TESLIM_TUTAR,
                        IADE_TUTAR,
                        KASA_ACIK_TUTAR,
                        KASA_FAZLA_TUTAR,
                        DOLAR_TUTAR,
                        EURO_TUTAR
                        )
                        VALUES
                        (
                        #max_id_con_id#,
                        '#evaluate("attributes.odeme_turu_#row_id#")#',
                        #filterNum(evaluate("attributes.satis_tutar_#row_id#"))#,
                        #filterNum(evaluate("attributes.teslim_tutar_#row_id#"))#,
                        #filterNum(evaluate("attributes.iade_tutar_#row_id#"))#,
                        #filterNum(evaluate("attributes.kasa_acik_tutar_#row_id#"))#,
                        #filterNum(evaluate("attributes.kasa_fazla_tutar_#row_id#"))#,
                        #filterNum(evaluate("attributes.kur_tutar_usd_#row_id#"))#,
                        #filterNum(evaluate("attributes.kur_tutar_euro_#row_id#"))#
                        )
                </cfquery>
                <cfset toplam_iade_tutar_ = toplam_iade_tutar_ + filterNum(evaluate("attributes.iade_tutar_#row_id#"))>
            </cfif>
        </cfloop>
    </cftransaction>
    
    <cfset tarih_ = dateformat(attributes.give_date,"dd/mm/yyyy")>
    
    <cfquery name="get_info" datasource="#dsn#">
        SELECT
            PE2.POS_ID,
            B.BRANCH_ID,
            (SELECT TOP 1 D.DEPARTMENT_ID FROM DEPARTMENT D WHERE D.BRANCH_ID = B.BRANCH_ID) AS DEPT
        FROM
            #dsn3_alias#.POS_EQUIPMENT PE2,
            BRANCH B
        WHERE
            PE2.BRANCH_ID = B.BRANCH_ID AND
            PE2.EQUIPMENT_CODE = #attributes.kasa_numarasi#
    </cfquery>
    
    <cfinclude template="../../objects/functions/get_carici.cfm">
    <cfinclude template="../../objects/functions/get_muhasebeci.cfm">
    <cfinclude template="../../objects/functions/get_butceci.cfm">
    <cfinclude template="../../objects/functions/cost_action.cfm">
    <cfinclude template="../../objects/functions/get_cost.cfm">
    <cfinclude template="../../objects/functions/add_company_related_action.cfm">
    <cfinclude template="../../objects/functions/get_process_money.cfm">
    
    <!--- gider pusulası --->
    <cfquery name="get_gider_pusula1" datasource="#dsn_dev#">
        SELECT
            ISNULL((SELECT PP.PERIOD_ID FROM #dsn3_alias#.PRODUCT_PERIOD PP WHERE PP.PRODUCT_ID = S.PRODUCT_ID AND PP.PERIOD_ID = #session.ep.period_id#),0) AS PERIOD_ID, 
            (SELECT TOP 1 D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = B2.BRANCH_ID) AS DEPT,
            GAR2.*,
            (GAR2.SATIR_TOPLAM - GAR2.SATIR_PROMOSYON_INDIRIM - GAR2.SATIR_INDIRIM) AS SATIR_SON_TOPLAM,
            S.PROPERTY,
            S.PRODUCT_ID,
            GA2.FIS_TOPLAM,
            GA2.FIS_TOPLAM_KDV,
            GA2.FIS_NUMARASI,
            GA2.HAREKET_SAYISI
        FROM 
            #dsn_alias#.BRANCH B2,
            GENIUS_ACTIONS GA2,
            GENIUS_ACTIONS_ROWS GAR2,
            #dsn3_alias#.POS_EQUIPMENT PE2,
            #dsn3_alias#.STOCKS S
        WHERE
            S.STOCK_ID = GAR2.STOCK_ID AND
            GAR2.SATIR_IPTALMI = 0 AND 
            GA2.ACTION_ID = GAR2.ACTION_ID AND
            GA2.FIS_IPTAL = 0 AND
            GA2.BELGE_TURU = '2' AND
            PE2.BRANCH_ID = B2.BRANCH_ID AND
            PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
            YEAR(GA2.FIS_TARIHI) = #yil_# AND
            MONTH(GA2.FIS_TARIHI) = #ay_# AND
            DAY(GA2.FIS_TARIHI) = #gun_# AND
            ZNO = '#attributes.z_number#' AND
            GA2.KASA_NUMARASI = #attributes.kasa_numarasi#
        ORDER BY
            GA2.FIS_NUMARASI ASC
    </cfquery>
    
    <cfquery name="get_gider_period_cont" dbtype="query">
    	SELECT * FROM get_gider_pusula1 WHERE PERIOD_ID = 0
	</cfquery>
    
    <cfif get_gider_period_cont.recordcount>
		<br /><br />
        <font color="red">İlgili Kasa İçin Muhasebe Hesapları Tanımsız Ürün Var! Düzetlme Yapınız!</font><br />
		<cfoutput query="get_gider_period_cont">#PROPERTY# Barkod : #barcode# <br /></cfoutput>
        <cfabort>
    </cfif> 
    
    <cfquery name="get_gider_iptaller" datasource="#dsn_dev#">
        SELECT
            (SELECT TOP 1 D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = B2.BRANCH_ID) AS DEPT,
            GAR2.*,
            (GAR2.SATIR_TOPLAM - GAR2.SATIR_PROMOSYON_INDIRIM - GAR2.SATIR_INDIRIM) AS SATIR_SON_TOPLAM,
            S.PROPERTY,
            S.PRODUCT_ID,
            GA2.FIS_TOPLAM,
            GA2.FIS_TOPLAM_KDV,
            GA2.FIS_NUMARASI,
            GA2.HAREKET_SAYISI
        FROM 
            #dsn_alias#.BRANCH B2,
            GENIUS_ACTIONS GA2,
            GENIUS_ACTIONS_ROWS GAR2,
            #dsn3_alias#.POS_EQUIPMENT PE2,
            #dsn3_alias#.STOCKS S
        WHERE
            S.STOCK_ID = GAR2.STOCK_ID AND
            GAR2.SATIR_IPTALMI = 1 AND 
            GA2.ACTION_ID = GAR2.ACTION_ID AND
            GA2.FIS_IPTAL = 0 AND
            GA2.BELGE_TURU = '2' AND
            PE2.BRANCH_ID = B2.BRANCH_ID AND
            PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
            YEAR(GA2.FIS_TARIHI) = #yil_# AND
            MONTH(GA2.FIS_TARIHI) = #ay_# AND
            DAY(GA2.FIS_TARIHI) = #gun_# AND
            ZNO = '#attributes.z_number#' AND
            GA2.KASA_NUMARASI = #attributes.kasa_numarasi#
    </cfquery>
    
    
    <cfif get_gider_iptaller.recordcount>
        <cfoutput query="get_gider_iptaller">
            <cfset miktar_ = miktar>
            <cfset stock_id_ = stock_id>
            <cfset birim_fiyat_ = birim_fiyat>
            <cfset birim_adi_ = birim_adi>
            <cfset fis_no_ = FIS_NUMARASI>
            <cfset row_no_ = currentrow>
            <cfloop from="#get_gider_pusula1.recordcount#" to="1" index="row_" step="-1">
                <cfif miktar_ gt 0 and stock_id_ eq get_gider_pusula1.stock_id[row_] and get_gider_pusula1.miktar[row_] gt 0 and fis_no_ eq get_gider_pusula1.FIS_NUMARASI[row_]>
                    <cfif (birim_adi_ eq 'KG' and miktar_ eq get_gider_pusula1.miktar[row_]) or birim_adi_ neq 'KG'>
						<cfset gercek_miktar_ = get_gider_pusula1.miktar[row_]>
                        <cfif gercek_miktar_ gte miktar_>
                            <cfset new_miktar_ = gercek_miktar_ - miktar_>
                            <cfset miktar_ = 0>
                        <cfelse>
                            <cfset new_miktar_ = 0>
                            <cfset miktar_ = miktar_ - gercek_miktar_>
                        </cfif>
                        <cfscript>
                             querysetcell(get_gider_pusula1,'MIKTAR',new_miktar_,row_);
                             querysetcell(get_gider_pusula1,'SATIR_SON_TOPLAM',(get_gider_pusula1.SATIR_SON_TOPLAM[row_] / gercek_miktar_ * new_miktar_),row_);
                             querysetcell(get_gider_pusula1,'SATIR_TOPLAM',(get_gider_pusula1.SATIR_TOPLAM[row_] / gercek_miktar_ * new_miktar_),row_);
                             querysetcell(get_gider_iptaller,'MIKTAR',miktar_,row_no_);
                        </cfscript>
                    </cfif>
                </cfif>
            </cfloop>
        </cfoutput>
    </cfif>
    
    <cfquery name="get_gider_pusula" dbtype="query">
        SELECT * FROM get_gider_pusula1 WHERE MIKTAR > 0 ORDER BY FIS_NUMARASI ASC
    </cfquery>
        
    <cfif get_gider_pusula.recordcount>
        <cfquery name="get_cash" datasource="#dsn2#">
            SELECT
                *
            FROM
                CASH
            WHERE
                DEPARTMENT_ID = #get_gider_pusula.DEPT#
        </cfquery>
        <cfset form.period_id = session.ep.period_id>
        <cfset form.active_period = session.ep.period_id>
        <cfset form.BASKET_RATE1 = 1>
        <cfset form.BASKET_RATE2 = 1>
        <cfset attributes.BASKET_DUE_VALUE_DATE_ = tarih_>
        <cfset form.note = "Genius Otomatik Fatura">
        <cfset form.ACTION_DETAIL = "Genius Otomatik Fatura">
        <cfset form.project_id = "">
        <cfset form.project_name = "">
        <cfset form.company_id = 510>
        <cfset form.consumer_id = "">
        <cfset form.comp_name = "GIDER PUSULASI CARISI">
        <cfset form.company_name = "GIDER PUSULASI CARISI">
        <cfset form.partner_id = 525>
        <cfset form.invoice_date = tarih_>
        <cfset form.invoice_cat = 55>
        <cfset form.process_cat = 89>
        <cfset form.kasa = get_cash.cash_id>
        <cfset form.cash = 1>
        <cfset form.stopaj = 0>
        <cfset form.stopaj_oran = 0>
        <cfset form.stopaj_yuzde = 0>
        <cfset form.CURRENCY_MULTIPLIER = 1>
        <cfset 'form.str_kasa_parasi#get_cash.cash_id#' = "TL"/>
        <cfset form.inventory_product_exists = 1>
        
        
        <cfset form.CASH_ACTION_TO_COMPANY_ID = 510/>
        <cfset form.CASH_ACTION_TO_CONSUMER_ID = "">
        <cfset form.CASH_ACTION_FROM_CASH_ID = get_cash.cash_id>
        <cfset form.ACTION_DATE = tarih_>
        <cfset form.MONEY_TYPE = 'TL'/>
        <cfset form.PAYER_ID = session.ep.userid>
        <cfset form.ship_date = tarih_>
        
        <cfset xml_import = 2>
        
        <cfquery name="get_money" datasource="#dsn#">
            SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#
        </cfquery>
        
        <cfloop query="get_money">
            <cfset "form.hidden_rd_money_#get_money.currentrow#" = "#GET_MONEY.MONEY#">
            <cfset "form.txt_rate1_#get_money.currentrow#" = "#GET_MONEY.RATE1#">
            <cfset "form.txt_rate2_#get_money.currentrow#" = "#GET_MONEY.RATE2#">
        </cfloop>
        <cfset form.kur_say = get_money.recordcount>
        
        <cfoutput query="get_gider_pusula" group="FIS_NUMARASI">
            <cfset fis_action_id = ACTION_ID>
            <cfset form.sale_product = 0>
            <cfset attributes.department_id = DEPT>
            <cfset attributes.location_id = 1>
            <cfset form.invoice_number = '#FIS_NUMARASI#_#attributes.kasa_numarasi#_#replace(tarih_,"/","","all")#'>
            <cfset form.serial_no = '#FIS_NUMARASI#_#attributes.kasa_numarasi#_#replace(tarih_,"/","","all")#'>
            
            <cfset form.basket_net_total = fis_toplam>
            <cfset form.basket_gross_total = fis_toplam - fis_toplam_kdv>
            <cfset form.basket_tax_total = fis_toplam_kdv>
            <cfset form.BASKET_DISCOUNT_TOTAL = 0>
            <cfset form.basket_otv_total = 0>
            <cfset form.yuvarlama = 0>
            <cfset form.genel_indirim = 0>
            <cfset form.DELIVER_GET_ID = session.ep.userid>
            <cfset form.DELIVER_GET = session.ep.userid>
            <cfset form.basket_money = 'TL'>
            
            <cfset gercek_sayi_ = 0>
            <cfoutput>
                <cfset gercek_sayi_ = gercek_sayi_ + 1>
                
                <cfif birim_adi is 'Metre'>
                	<cfset birim_adi_ = "M">
                <cfelse>
                	<cfset birim_adi_ = birim_adi>
                </cfif>
                
                <cfquery name="get_prod" datasource="#dsn1#">
                    SELECT 
                        *, 
                        P.PRODUCT_NAME+' '+S.PROPERTY NAME_PRODUCT,
                        (SELECT TOP 1 UNIT_ID FROM PRODUCT_UNIT PU WHERE PU.PRODUCT_ID = P.PRODUCT_ID AND ADD_UNIT = '#birim_adi_#') UNIT_ID
                    FROM 
                        PRODUCT P INNER JOIN 
                        STOCKS S ON S.PRODUCT_ID = P.PRODUCT_ID 
                    WHERE 
                        S.STOCK_ID = #stock_id#
                </cfquery>
        
                    <cfset "form.product_name#gercek_sayi_#" = "#get_prod.NAME_PRODUCT#" />
                    <cfset "form.product_id#gercek_sayi_#" = "#get_prod.product_id#" />
                    <cfset "form.stock_id#gercek_sayi_#" = "#get_prod.stock_id#" />
                    
                    <cfset "form.amount#gercek_sayi_#" = "#miktar#" />
                    
                    <cfset "form.unit#gercek_sayi_#" = "#birim_adi_#" />
                    <cfset "form.unit_id#gercek_sayi_#" = "#get_prod.UNIT_ID#" />
    
                    <cfset "form.price#gercek_sayi_#" = "#birim_fiyat#"/>
                    
                    <cfset "form.row_lasttotal#gercek_sayi_#" = "#satir_toplam#" />
                    <cfset "form.row_total#gercek_sayi_#" = "#satir_toplam - satir_kdv_tutar#" />
                    <cfset "form.row_otvtotal#gercek_sayi_#" = "0" />
                    <cfset "form.row_nettotal#gercek_sayi_#" = "#satir_toplam - satir_kdv_tutar#" />
                    <cfset "form.row_taxtotal#gercek_sayi_#" = "#satir_kdv_tutar#" />
                    <cfset "form.tax#gercek_sayi_#" = "#satir_kdv#" />
                    <cfset "form.deliver_date#gercek_sayi_#" = "#tarih_#"/>
                    <cfset "form.deliver_dept#gercek_sayi_#" = "#get_gider_pusula.dept#"/>
                    <cfset "form.deliver_loc#gercek_sayi_#" = "1"/>
                    <cfset "form.other_money#gercek_sayi_#" = "TL"/>
                    <cfset "form.other_money_#gercek_sayi_#" = "TL"/>
                    <cfset "form.other_money_value_#gercek_sayi_#" = "#satir_toplam - satir_kdv_tutar#"/>
                    <cfset "form.price_other#gercek_sayi_#" = "#birim_fiyat#" />
                    <cfset "form.other_money_grosstotal#gercek_sayi_#" = "#satir_toplam#"/>
                    <cfset "form.otv_oran#gercek_sayi_#" = ""/>
                    <cfset "form.is_inventory#gercek_sayi_#" = "1"/>
                    <cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
                    <cfset "form.wrk_row_id#gercek_sayi_#" = "#wrk_id#"/>
                    <cfset "form.spect_id#gercek_sayi_#" = ""/>
                    <cfset "form.spect_name#gercek_sayi_#" = ""/>
            </cfoutput>
            <cfset attributes.rows_ = gercek_sayi_>
            <cfscript>StructAppend(attributes,form);</cfscript>
            
            <cfquery name="cont_" datasource="#dsn_dev#">
                SELECT * FROM POS_CONS_ACTIONS WHERE FIS_ACTION_ID = #fis_action_id# AND ACTION_TYPE = 55
            </cfquery>
            <cfif not cont_.recordcount>
                <cfinclude template="../../invoice/query/add_invoice_purchase.cfm">
                <cfquery name="add_relation" datasource="#dsn_dev#">
                    INSERT INTO
                        POS_CONS_ACTIONS
                        (
                        CON_ID,
                        ACTION_ID,
                        ACTION_TABLE,
                        FIS_ACTION_ID,
                        PERIOD_ID,
                        ACTION_TYPE
                        )
                        VALUES
                        (
                        #max_id_con_id#,
                        #get_invoice_id.max_id#,
                        'INVOICE',
                        #fis_action_id#,
                        #session.ep.period_id#,
                        55
                        )
                </cfquery>
            </cfif>
        </cfoutput>
    </cfif>
    <!--- gider pusulası --->
    
    <cfscript>
        include('add_stock_rows.cfm','\objects\functions');
    </cfscript>
    
    
    <!--- irsaliye --->
    <cfquery name="get_irsaliye1" datasource="#dsn_dev#">
        SELECT
            ISNULL((SELECT PP.PERIOD_ID FROM #dsn3_alias#.PRODUCT_PERIOD PP WHERE PP.PRODUCT_ID = S.PRODUCT_ID AND PP.PERIOD_ID = #session.ep.period_id#),0) AS PERIOD_ID,
            (SELECT TOP 1 D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = B2.BRANCH_ID) AS DEPT,
            GAR2.*,
            (GAR2.SATIR_TOPLAM - GAR2.SATIR_PROMOSYON_INDIRIM - GAR2.SATIR_INDIRIM) AS SATIR_SON_TOPLAM,
            S.PROPERTY,
            S.PRODUCT_ID,
            GA2.FIS_TOPLAM,
            GA2.FIS_TOPLAM_KDV,
            <cfif yil_ gt 2016 or (yil_ eq 2016 and ay_ gt 1)>
            	GA2.ZNO + '_' + GA2.FIS_NUMARASI AS FIS_NUMARASI,
            <cfelse>
            	GA2.FIS_NUMARASI AS FIS_NUMARASI,
            </cfif>
            GA2.MUSTERI_NO,
            GA2.FIS_TOPLAM,
            GA2.HAREKET_SAYISI
        FROM 
            #dsn_alias#.BRANCH B2,
            GENIUS_ACTIONS GA2,
            GENIUS_ACTIONS_ROWS GAR2,
            #dsn3_alias#.POS_EQUIPMENT PE2,
            #dsn3_alias#.STOCKS S
        WHERE
            S.STOCK_ID = GAR2.STOCK_ID AND
            GAR2.SATIR_IPTALMI = 0 AND 
            GA2.ACTION_ID = GAR2.ACTION_ID AND
            GA2.FIS_IPTAL = 0 AND
            GA2.BELGE_TURU = '4' AND
            PE2.BRANCH_ID = B2.BRANCH_ID AND
            PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
            YEAR(GA2.FIS_TARIHI) = #yil_# AND
            MONTH(GA2.FIS_TARIHI) = #ay_# AND
            DAY(GA2.FIS_TARIHI) = #gun_# AND
            ZNO = '#attributes.z_number#' AND
            GA2.KASA_NUMARASI = #attributes.kasa_numarasi#
       	ORDER BY 
            GA2.FIS_NUMARASI ASC,
            GAR2.STOCK_ID ASC,
            GAR2.SATIR_KDV_TUTAR ASC
    </cfquery>
    
    <cfquery name="get_irsaliye1_period_cont" dbtype="query">
    	SELECT * FROM get_irsaliye1 WHERE PERIOD_ID = 0
	</cfquery>
    
    <cfif get_irsaliye1_period_cont.recordcount>
		<br /><br />
        <font color="red">İlgili Kasa İçin Muhasebe Hesapları Tanımsız Ürün Var! Düzetlme Yapınız!</font><br />
		<cfoutput query="get_irsaliye1_period_cont">#PROPERTY# Barkod : #barcode# <br /></cfoutput>
        <cfabort>
    </cfif> 
    
    
    <cfquery name="get_irsaliye_iptaller" datasource="#dsn_dev#">
        SELECT
            (SELECT TOP 1 D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = B2.BRANCH_ID) AS DEPT,
            GAR2.*,
            (GAR2.SATIR_TOPLAM - GAR2.SATIR_PROMOSYON_INDIRIM - GAR2.SATIR_INDIRIM) AS SATIR_SON_TOPLAM,
            S.PROPERTY,
            S.PRODUCT_ID,
            GA2.FIS_TOPLAM,
            GA2.FIS_TOPLAM_KDV,
            <cfif yil_ gt 2016 or (yil_ eq 2016 and ay_ gt 1)>
            	GA2.ZNO + '_' + GA2.FIS_NUMARASI AS FIS_NUMARASI,
            <cfelse>
            	GA2.FIS_NUMARASI AS FIS_NUMARASI,
            </cfif>
            GA2.HAREKET_SAYISI
        FROM 
            #dsn_alias#.BRANCH B2,
            GENIUS_ACTIONS GA2,
            GENIUS_ACTIONS_ROWS GAR2,
            #dsn3_alias#.POS_EQUIPMENT PE2,
            #dsn3_alias#.STOCKS S
        WHERE
            S.STOCK_ID = GAR2.STOCK_ID AND
            GAR2.SATIR_IPTALMI = 1 AND 
            GA2.ACTION_ID = GAR2.ACTION_ID AND
            GA2.FIS_IPTAL = 0 AND
            GA2.BELGE_TURU = '4' AND
            PE2.BRANCH_ID = B2.BRANCH_ID AND
            PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
            YEAR(GA2.FIS_TARIHI) = #yil_# AND
            MONTH(GA2.FIS_TARIHI) = #ay_# AND
            DAY(GA2.FIS_TARIHI) = #gun_# AND
            ZNO = '#attributes.z_number#' AND
            GA2.KASA_NUMARASI = #attributes.kasa_numarasi#
    </cfquery>
    
    <cfif get_irsaliye_iptaller.recordcount>
        <cfoutput query="get_irsaliye_iptaller">
            <cfset miktar_ = miktar>
            <cfset stock_id_ = stock_id>
            <cfset birim_fiyat_ = birim_fiyat>
            <cfset fis_no_ = FIS_NUMARASI>
            <cfset row_no_ = currentrow>
            <cfloop from="1" to="#get_irsaliye1.recordcount#" index="row_">
                <cfif miktar_ gt 0 and stock_id_ eq get_irsaliye1.stock_id[row_] and get_irsaliye1.miktar[row_] gt 0 and fis_no_ eq get_irsaliye1.FIS_NUMARASI[row_]>
                    <cfset gercek_miktar_ = get_irsaliye1.miktar[row_]>
                    <cfif gercek_miktar_ gte miktar_>
                        <cfset new_miktar_ = gercek_miktar_ - miktar_>
                        <cfset miktar_ = 0>
                    <cfelse>
                        <cfset new_miktar_ = 0>
                        <cfset miktar_ = miktar_ - gercek_miktar_>
                    </cfif>
                    <cfscript>
                         querysetcell(get_irsaliye1,'MIKTAR',new_miktar_,row_);
                         querysetcell(get_irsaliye1,'SATIR_SON_TOPLAM',(get_irsaliye1.SATIR_SON_TOPLAM / gercek_miktar_ * new_miktar_),row_);
                         querysetcell(get_irsaliye1,'SATIR_TOPLAM',(get_irsaliye1.SATIR_TOPLAM / gercek_miktar_ * new_miktar_),row_);
                         querysetcell(get_irsaliye_iptaller,'MIKTAR',miktar_,row_no_);
                    </cfscript>
                </cfif>
            </cfloop>
        </cfoutput>
    </cfif>
    
    
    
    <cfquery name="get_irsaliye" dbtype="query">
        SELECT * FROM get_irsaliye1 WHERE MIKTAR > 0 ORDER BY FIS_NUMARASI ASC
    </cfquery>
    

    <cfif get_irsaliye.recordcount>
        <cfquery name="get_cash" datasource="#dsn2#">
            SELECT
                *
            FROM
                CASH
            WHERE
                DEPARTMENT_ID = #get_irsaliye.DEPT#
        </cfquery>
        <cfset form.period_id = session.ep.period_id>
        <cfset form.active_period = session.ep.period_id>
        <cfset form.BASKET_RATE1 = 1>
        <cfset form.BASKET_RATE2 = 1>
        <cfset attributes.BASKET_DUE_VALUE_DATE_ = tarih_>
        <cfset form.note = "Genius Otomatik İrsaliye">
        <cfset form.ACTION_DETAIL = "Genius Otomatik İrsaliye">
        <cfset form.project_id = "">
        <cfset form.project_name = "">
        <cfset form.company_id = 509>
        <cfset form.consumer_id = "">
        <cfset form.comp_name = "FATURA SATIS CARISI">
        <cfset form.company_name = "FATURA SATIS CARISI">
        <cfset form.partner_id = 524>
        <cfset form.ship_date = tarih_>
        <cfset form.invoice_cat = 70>
        <cfset form.process_cat = 114>
        <cfset form.kasa = get_cash.cash_id>
        <cfset form.cash = 1>
        <cfset form.stopaj = 0>
        <cfset form.stopaj_oran = 0>
        <cfset form.stopaj_yuzde = 0>
        <cfset form.CURRENCY_MULTIPLIER = 1>
        <cfset 'form.str_kasa_parasi#get_cash.cash_id#' = "TL"/>
        <cfset form.inventory_product_exists = 1>
        
        <cfset form.CASH_ACTION_FROM_COMPANY_ID = 509/>
        <cfset form.CASH_ACTION_FROM_CONSUMER_ID = "">
        <cfset form.CASH_ACTION_FROM_CASH_ID = get_cash.cash_id>
        <cfset form.ACTION_DATE = tarih_>
        <cfset form.MONEY_TYPE = 'TL'/>
        <cfset form.PAYER_ID = session.ep.userid>
        <cfset form.ship_date = tarih_>
        <cfset form.CASH_ACTION_TO_CASH_ID = get_cash.cash_id>
        <cfset attributes.employee_id = "">
        <cfset form.employee_id = "">
        
        <cfset form.adres = "Adres">
        
        <cfset xml_import = 2>
        
        <cfquery name="get_money" datasource="#dsn#">
            SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#
        </cfquery>
        
        <cfloop query="get_money">
            <cfset "form.hidden_rd_money_#get_money.currentrow#" = "#GET_MONEY.MONEY#">
            <cfset "form.txt_rate1_#get_money.currentrow#" = "#GET_MONEY.RATE1#">
            <cfset "form.txt_rate2_#get_money.currentrow#" = "#GET_MONEY.RATE2#">
        </cfloop>
        <cfset form.kur_say = get_money.recordcount>
       
       
       <cfquery name="get_irsaliye" dbtype="query">
       		SELECT * FROM get_irsaliye ORDER BY FIS_NUMARASI DESC
       </cfquery>
       
        <cfoutput query="get_irsaliye" group="FIS_NUMARASI">
        	<cfif len(MUSTERI_NO)>
        		<cfquery name="get_card" datasource="#dsn2#">
                	SELECT * FROM #dsn_alias#.CUSTOMER_CARDS WHERE CARD_NO = '#MUSTERI_NO#'
                </cfquery>
                <cfif get_card.recordcount>
                	<cfif get_card.ACTION_TYPE_ID is 'CONSUMER_ID'>
                    	<!---
						<cfset form.CASH_ACTION_FROM_COMPANY_ID = "">
        				<cfset form.CASH_ACTION_FROM_CONSUMER_ID = get_card.action_id>
                        <cfset form.consumer_id = get_card.action_id>
                        <cfset form.company_id = "">
                        <cfset form.partner_id = "">
						--->
                    <cfelse>
                    	<cfset form.cash = 0>
						<cfset form.CASH_ACTION_FROM_COMPANY_ID = get_card.action_id/>
        				<cfset form.CASH_ACTION_FROM_CONSUMER_ID = "">
                        <cfset form.company_id = get_card.action_id>
                        <cfquery name="get_partner" datasource="#dsn2#">
                            SELECT * FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID = #get_card.action_id#
                        </cfquery>
                        <cfset form.partner_id = get_partner.PARTNER_ID>
                    </cfif>
                </cfif>
        	</cfif>
        
            <cfset fis_action_id = ACTION_ID>
            <cfset form.sale_product = 1>
            <cfset attributes.rows_ = HAREKET_SAYISI>
            <cfset attributes.department_id = DEPT>
            <cfset attributes.location_id = 1>
        
            <cfset form.ship_number = '#FIS_NUMARASI#_#attributes.kasa_numarasi#_#replace(tarih_,"/","","all")#'>
            <cfset form.serial_no = '#FIS_NUMARASI#_#attributes.kasa_numarasi#_#replace(tarih_,"/","","all")#'>
            
            <cfset form.paper_number = ''>
            
            <cfset form.basket_net_total = fis_toplam>
            <cfset form.basket_gross_total = fis_toplam - fis_toplam_kdv>
            <cfset form.basket_tax_total = fis_toplam_kdv>
            <cfset form.BASKET_DISCOUNT_TOTAL = 0>
            <cfset form.basket_otv_total = 0>
            <cfset form.yuvarlama = 0>
            <cfset form.genel_indirim = 0>
            <cfset form.DELIVER_GET_ID = session.ep.userid>
            <cfset form.DELIVER_GET = session.ep.userid>
            <cfset form.basket_money = 'TL'>
            <cfset form.basket_discount_total = 0>
            <cfset inventory_product_exists = 1>
            
            <cfset form.CASH_ACTION_VALUE = fis_toplam>
            <cfset form.OTHER_CASH_ACT_VALUE = fis_toplam>
            <cfset form.SYSTEM_AMOUNT = fis_toplam>
            <cfset form.REVENUE_COLLECTOR_ID = session.ep.userid>
            
            <cfset form.deliver_date_frm = tarih_>
                
            <cfset gercek_sayi_ = 0>
            <cfoutput>
            	<cfif birim_adi is 'Metre'>
					<cfset birim_adi_ = "M">
                <cfelse>
                    <cfset birim_adi_ = birim_adi>
                </cfif>
            
                <cfset gercek_sayi_ = gercek_sayi_ + 1>
                    <cfquery name="get_prod" datasource="#dsn1#">
                        SELECT 
                            *, 
                            P.PRODUCT_NAME+' '+S.PROPERTY NAME_PRODUCT,
                            (SELECT TOP 1 UNIT_ID FROM PRODUCT_UNIT PU WHERE PU.PRODUCT_ID = P.PRODUCT_ID AND ADD_UNIT = '#birim_adi_#' AND PU.PRODUCT_UNIT_STATUS = 1) UNIT_ID
                        FROM 
                            PRODUCT P INNER JOIN 
                            STOCKS S ON S.PRODUCT_ID = P.PRODUCT_ID 
                        WHERE 
                            S.STOCK_ID = #stock_id#
                    </cfquery>
        
                    <cfset "form.product_name#gercek_sayi_#" = "#get_prod.NAME_PRODUCT#" />
                    <cfset "form.product_id#gercek_sayi_#" = "#get_prod.product_id#" />
                    <cfset "form.stock_id#gercek_sayi_#" = "#get_prod.stock_id#" />
                    
                    <cfset "form.amount#gercek_sayi_#" = "#miktar#" />
                    
                    <cfset "form.unit#gercek_sayi_#" = "#birim_adi_#" />
                    <cfset "form.unit_id#gercek_sayi_#" = "#get_prod.UNIT_ID#" />
                    
                    <cfset kdv_rakam = (satir_kdv + 100) / 100>
                    
                    <cfset "form.price#gercek_sayi_#" = "#SATIR_SON_TOPLAM/miktar/kdv_rakam#"/>
                    <cfset "form.price_other#gercek_sayi_#" = "#SATIR_SON_TOPLAM/miktar/kdv_rakam#" />
                    
                    <cfset "form.row_lasttotal#gercek_sayi_#" = "#SATIR_SON_TOPLAM#" />
                    <cfset "form.row_total#gercek_sayi_#" = "#SATIR_SON_TOPLAM - satir_kdv_tutar#" />
                    <cfset "form.row_otvtotal#gercek_sayi_#" = "0" />
                    <cfset "form.row_nettotal#gercek_sayi_#" = "#SATIR_SON_TOPLAM - satir_kdv_tutar#" />
                    <cfset "form.row_taxtotal#gercek_sayi_#" = "#satir_kdv_tutar#" />
                    <cfset "form.tax#gercek_sayi_#" = "#satir_kdv#" />
                    <cfset "form.deliver_date#gercek_sayi_#" = "#tarih_#"/>
                    <cfset "form.deliver_dept#gercek_sayi_#" = "#get_irsaliye.dept#"/>
                    <cfset "form.deliver_loc#gercek_sayi_#" = "1"/>
                    <cfset "form.other_money#gercek_sayi_#" = "TL"/>
                    <cfset "form.other_money_#gercek_sayi_#" = "TL"/>
                    <cfset "form.other_money_value_#gercek_sayi_#" = "#SATIR_SON_TOPLAM - satir_kdv_tutar#"/>
                    
                    <cfset "form.other_money_grosstotal#gercek_sayi_#" = "#SATIR_SON_TOPLAM#"/>
                    <cfset "form.otv_oran#gercek_sayi_#" = ""/>
                    <cfset "form.is_inventory#gercek_sayi_#" = "1"/>
                    <cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
                    <cfset "form.wrk_row_id#gercek_sayi_#" = "#wrk_id#"/>
                    <cfset "form.spect_id#gercek_sayi_#" = ""/>
                    <cfset "form.spect_name#gercek_sayi_#" = ""/>
            </cfoutput>
            
            <cfset attributes.rows_ = gercek_sayi_>
            <cfscript>StructAppend(attributes,form);</cfscript>
            
            <cfquery name="cont_" datasource="#dsn_dev#">
                SELECT * FROM POS_CONS_ACTIONS WHERE FIS_ACTION_ID = #fis_action_id# AND ACTION_TYPE = 70
            </cfquery>
            
            <cfset function_off = 1>
            <cfif not cont_.recordcount>
				<cfset form.basket_discount_total = 0>
                <cfset inventory_product_exists = 1>
                <cfset xml_import = 2>
                <cfset ship_number = form.ship_number>
                <cfset form.process_cat = 114>
                <cfinclude template="../../stock/query/add_sale.cfm">
                
                <cfset ship_id_ = row_ship_id>
                
                <cfset form.process_cat = 13>
                <cfset form.money_type ='TL'>
                <cfset form.paper_number = "#FIS_NUMARASI#_#attributes.kasa_numarasi#_#replace(tarih_,"/","","all")#">
                
                <cfset attributes.special_definition_id = ship_id_>
                <cfif form.cash eq 1><cfinclude template="../../cash/query/add_cash_revenue.cfm"></cfif>
                <cfquery name="add_relation" datasource="#dsn_dev#">
                    INSERT INTO
                        POS_CONS_ACTIONS
                        (
                        CON_ID,
                        ACTION_ID,
                        ACTION_TABLE,
                        FIS_ACTION_ID,
                        PERIOD_ID,
                        ACTION_TYPE
                        )
                        VALUES
                        (
                        #max_id_con_id#,
                        #ship_id_#,
                        'SHIP',
                        #fis_action_id#,
                        #session.ep.period_id#,
                        70
                        )
                </cfquery>
           </cfif>
        </cfoutput>
    </cfif>
    
    
    
    <cfquery name="upd_" datasource="#dsn2#">
    	UPDATE
            SHIP_ROW
        SET
            OTHER_MONEY = 'TL'
        WHERE
            OTHER_MONEY IS NULL
    </cfquery>
    <!--- irsaliye --->
    
    <!--- fatura --->
    
    <!--- CONTROL --->
    	<cfquery name="get_fatura_cont" datasource="#dsn_dev#">
            SELECT
                
                (SELECT TOP 1 D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = B2.BRANCH_ID) AS DEPT,
                GAR2.*,
                (GAR2.SATIR_TOPLAM - GAR2.SATIR_PROMOSYON_INDIRIM - GAR2.SATIR_INDIRIM) AS SATIR_SON_TOPLAM,
                GA2.FIS_TOPLAM,
                GA2.FIS_TOPLAM_KDV,
                GA2.FIS_NUMARASI,
                GA2.HAREKET_SAYISI,
                GA2.MUSTERI_NO,
                ISNULL((SELECT TOP 1 ACTION_ID FROM GENIUS_ACTIONS_PAYMENTS GAP WHERE GAP.ACTION_ID = GA2.ACTION_ID AND ODEME_TURU = '0' AND ODEME_TIPI = 0),0) NAKIT_MI
            FROM 
                #dsn_alias#.BRANCH B2,
                GENIUS_ACTIONS GA2,
                #dsn3_alias#.POS_EQUIPMENT PE2,
                GENIUS_ACTIONS_ROWS GAR2
            WHERE
                GAR2.SATIR_IPTALMI = 0 AND 
                GA2.ACTION_ID = GAR2.ACTION_ID AND
                GA2.FIS_IPTAL = 0 AND
                GA2.BELGE_TURU = '1' AND
                PE2.BRANCH_ID = B2.BRANCH_ID AND
                PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
                YEAR(GA2.FIS_TARIHI) = #yil_# AND
                MONTH(GA2.FIS_TARIHI) = #ay_# AND
                DAY(GA2.FIS_TARIHI) = #gun_# AND
                ZNO = '#attributes.z_number#' AND
                GA2.KASA_NUMARASI = #attributes.kasa_numarasi# AND
                (GAR2.STOCK_ID IS NULL OR GAR2.STOCK_ID = '')
            ORDER BY 
                GA2.FIS_NUMARASI ASC,
                SATIR_KDV_TUTAR ASC
        </cfquery>
        <cfif get_fatura_cont.recordcount>
        	<script>
				alert('İlgili Kasa İçin Tanımsız Ürün Var! Düzetlme Yapınız!');
				window.close();
			</script>
            <cfabort>
        </cfif>
        
        
    <!--- CONTROL --->
    
    <cfquery name="get_fatura1" datasource="#dsn_dev#">
        SELECT
            ISNULL((SELECT PP.PERIOD_ID FROM #dsn3_alias#.PRODUCT_PERIOD PP WHERE PP.PRODUCT_ID = S.PRODUCT_ID AND PP.PERIOD_ID = #session.ep.period_id#),0) AS PERIOD_ID,
            (SELECT TOP 1 D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = B2.BRANCH_ID) AS DEPT,
            GAR2.*,
            (GAR2.SATIR_TOPLAM - GAR2.SATIR_PROMOSYON_INDIRIM - GAR2.SATIR_INDIRIM) AS SATIR_SON_TOPLAM,
            S.PROPERTY,
            S.PRODUCT_ID,
            GA2.FIS_TOPLAM,
            GA2.FIS_TOPLAM_KDV,
            GA2.FIS_NUMARASI,
            GA2.HAREKET_SAYISI,
            GA2.MUSTERI_NO,
            ISNULL((SELECT TOP 1 ACTION_ID FROM GENIUS_ACTIONS_PAYMENTS GAP WHERE GAP.ACTION_ID = GA2.ACTION_ID AND ODEME_TURU = '0' AND ODEME_TIPI = 0),0) NAKIT_MI
        FROM 
            #dsn_alias#.BRANCH B2,
            GENIUS_ACTIONS GA2,
            GENIUS_ACTIONS_ROWS GAR2,
            #dsn3_alias#.POS_EQUIPMENT PE2,
            #dsn3_alias#.STOCKS S
        WHERE
            S.STOCK_ID = GAR2.STOCK_ID AND
            GAR2.SATIR_IPTALMI = 0 AND 
            GA2.ACTION_ID = GAR2.ACTION_ID AND
            GA2.FIS_IPTAL = 0 AND
            GA2.BELGE_TURU = '1' AND
            PE2.BRANCH_ID = B2.BRANCH_ID AND
            PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
            YEAR(GA2.FIS_TARIHI) = #yil_# AND
            MONTH(GA2.FIS_TARIHI) = #ay_# AND
            DAY(GA2.FIS_TARIHI) = #gun_# AND
            ZNO = '#attributes.z_number#' AND
            GA2.KASA_NUMARASI = #attributes.kasa_numarasi#
        ORDER BY 
            GA2.FIS_NUMARASI ASC,
            SATIR_KDV_TUTAR ASC,
            SATIR_PROMOSYON_INDIRIM ASC
    </cfquery>
    
    <cfquery name="get_fatura_period_cont" dbtype="query">
        SELECT * FROM get_fatura1 WHERE PERIOD_ID = 0
    </cfquery>
    
    <cfif get_fatura_period_cont.recordcount>
        <br /><br />
        <font color="red">İlgili Kasa İçin Muhasebe Hesapları Tanımsız Ürün Var! Düzetlme Yapınız!</font><br />
        <cfoutput query="get_fatura_period_cont">#PROPERTY# Barkod : #barcode# <br /></cfoutput>
        <cfabort>
    </cfif>
    
    <cfquery name="get_fatura_iptaller" datasource="#dsn_dev#">
        SELECT
            (SELECT TOP 1 D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = B2.BRANCH_ID) AS DEPT,
            GAR2.*,
            (GAR2.SATIR_TOPLAM - GAR2.SATIR_PROMOSYON_INDIRIM - GAR2.SATIR_INDIRIM) AS SATIR_SON_TOPLAM,
            S.PROPERTY,
            S.PRODUCT_ID,
            GA2.FIS_TOPLAM,
            GA2.FIS_TOPLAM_KDV,
            GA2.FIS_NUMARASI,
            GA2.HAREKET_SAYISI
        FROM 
            #dsn_alias#.BRANCH B2,
            GENIUS_ACTIONS GA2,
            GENIUS_ACTIONS_ROWS GAR2,
            #dsn3_alias#.POS_EQUIPMENT PE2,
            #dsn3_alias#.STOCKS S
        WHERE
            S.STOCK_ID = GAR2.STOCK_ID AND
            GAR2.SATIR_IPTALMI = 1 AND 
            GA2.ACTION_ID = GAR2.ACTION_ID AND
            GA2.FIS_IPTAL = 0 AND
            GA2.BELGE_TURU = '1' AND
            PE2.BRANCH_ID = B2.BRANCH_ID AND
            PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
            YEAR(GA2.FIS_TARIHI) = #yil_# AND
            MONTH(GA2.FIS_TARIHI) = #ay_# AND
            DAY(GA2.FIS_TARIHI) = #gun_# AND
            ZNO = '#attributes.z_number#' AND
            GA2.KASA_NUMARASI = #attributes.kasa_numarasi#
        ORDER BY 
            GA2.FIS_NUMARASI ASC
    </cfquery>
    
    <cfif get_fatura_iptaller.recordcount>
        <cfoutput query="get_fatura_iptaller">
            <cfset miktar_ = miktar>
            <cfset stock_id_ = stock_id>
            <cfset birim_fiyat_ = birim_fiyat>
            <cfset fis_no_ = FIS_NUMARASI>
            <cfset row_no_ = currentrow>
            <!--- <cfloop from="#get_fatura1.recordcount#" to="1" index="row_" step="-1"> --->
            <cfloop from="1" to="#get_fatura1.recordcount#" index="row_">
                <cfif miktar_ gt 0 and stock_id_ eq get_fatura1.stock_id[row_] and get_fatura1.miktar[row_] gt 0 and fis_no_ eq get_fatura1.FIS_NUMARASI[row_]>
                    <cfset gercek_miktar_ = get_fatura1.miktar[row_]>
                    <cfif gercek_miktar_ gte miktar_>
                        <cfset new_miktar_ = gercek_miktar_ - miktar_>
                        <cfset miktar_ = 0>
                    <cfelse>
                        <cfset new_miktar_ = 0>
                        <cfset miktar_ = miktar_ - gercek_miktar_>
                    </cfif>
                    <cfscript>
                         querysetcell(get_fatura1,'MIKTAR',new_miktar_,row_);
                         querysetcell(get_fatura1,'SATIR_SON_TOPLAM',(get_fatura1.SATIR_SON_TOPLAM / gercek_miktar_ * new_miktar_),row_);
                         querysetcell(get_fatura1,'SATIR_TOPLAM',(get_fatura1.SATIR_TOPLAM / gercek_miktar_ * new_miktar_),row_);
                         querysetcell(get_fatura_iptaller,'MIKTAR',miktar_,row_no_);
                    </cfscript>
                </cfif>
            </cfloop>
        </cfoutput>
    </cfif>
    
    <cfquery name="get_fatura" dbtype="query">
        SELECT * FROM get_fatura1 WHERE MIKTAR > 0 ORDER BY FIS_NUMARASI ASC
    </cfquery>
    
    
    <cfset kredi_kartli_faturali_satis_toplam = 0>
    <cfset kredi_kartli_faturali_satis_toplam_kdvsiz = 0>
    <cfif get_fatura.recordcount>
        <cfquery name="get_cash" datasource="#dsn2#">
            SELECT
                *
            FROM
                CASH
            WHERE
                DEPARTMENT_ID = #get_fatura.DEPT#
        </cfquery>
        <cfset form.period_id = session.ep.period_id>
        <cfset form.active_period = session.ep.period_id>
        <cfset form.BASKET_RATE1 = 1>
        <cfset form.BASKET_RATE2 = 1>
        <cfset attributes.BASKET_DUE_VALUE_DATE_ = tarih_>
        <cfset form.note = "Genius Otomatik Fatura">
        <cfset form.ACTION_DETAIL = "Genius Otomatik Fatura">
        <cfset form.project_id = "">
        <cfset form.project_name = "">
        <cfset form.company_id = 509>
        <cfset form.consumer_id = "">
        <cfset form.comp_name = "FATURA SATIS CARISI">
        <cfset form.company_name = "FATURA SATIS CARISI">
        <cfset form.partner_id = 524>
        <cfset form.invoice_date = tarih_>
        <cfset form.invoice_cat = 52>
        <cfset form.process_cat = 105>
            
        <cfset form.stopaj = 0>
        <cfset form.stopaj_oran = 0>
        <cfset form.stopaj_yuzde = 0>
        <cfset form.CURRENCY_MULTIPLIER = 1>
        <cfset 'form.str_kasa_parasi#get_cash.cash_id#' = "TL"/>
        <cfset form.inventory_product_exists = 1>
        
        <cfset form.CASH_ACTION_TO_COMPANY_ID = 510/>
        <cfset form.CASH_ACTION_TO_CONSUMER_ID = "">
        <cfset form.CASH_ACTION_FROM_CASH_ID = get_cash.cash_id>
        <cfset form.ACTION_DATE = tarih_>
        <cfset form.MONEY_TYPE = 'TL'/>
        <cfset form.PAYER_ID = session.ep.userid>
        <cfset form.ship_date = tarih_>
        
        <cfset xml_import = 2>
        
        <cfquery name="get_money" datasource="#dsn#">
            SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#
        </cfquery>
        
        <cfloop query="get_money">
            <cfset "form.hidden_rd_money_#get_money.currentrow#" = "#GET_MONEY.MONEY#">
            <cfset "form.txt_rate1_#get_money.currentrow#" = "#GET_MONEY.RATE1#">
            <cfset "form.txt_rate2_#get_money.currentrow#" = "#GET_MONEY.RATE2#">
        </cfloop>
        <cfset form.kur_say = get_money.recordcount>
        
        <cfoutput query="get_fatura" group="FIS_NUMARASI">
        	<cfif NAKIT_MI eq 1>
				<cfset kasa_islemi_yap = 1>
                <cfset form.kasa = get_cash.cash_id>
                <cfset form.cash = 1>
            <cfelse>
                <cfset kasa_islemi_yap = 0>
                <cfset form.kasa = "">
                <cfset kredi_kartli_faturali_satis_toplam = kredi_kartli_faturali_satis_toplam + fis_toplam>
                <cfset kredi_kartli_faturali_satis_toplam_kdvsiz = kredi_kartli_faturali_satis_toplam_kdvsiz + (fis_toplam - fis_toplam_kdv)>
            </cfif>
			
			<cfif len(MUSTERI_NO)>
        		<cfquery name="get_card" datasource="#dsn2#">
                	SELECT * FROM #dsn_alias#.CUSTOMER_CARDS WHERE CARD_NO = '#MUSTERI_NO#'
                </cfquery>
                <cfif get_card.recordcount>
                	<cfif get_card.ACTION_TYPE_ID is 'CONSUMER_ID'>
                    	<!---
                    	<cfset form.CASH_ACTION_FROM_COMPANY_ID = "">
        				<cfset form.CASH_ACTION_FROM_CONSUMER_ID = get_card.action_id>
                        <cfset form.consumer_id = get_card.action_id>
                        <cfset form.company_id = "">
                        <cfset form.partner_id = "">
						--->
                    <cfelse>
                    	<cfset form.CASH_ACTION_FROM_COMPANY_ID = get_card.action_id/>
        				<cfset form.CASH_ACTION_FROM_CONSUMER_ID = "">
                        <cfset form.company_id = get_card.action_id>
                        <cfquery name="get_partner" datasource="#dsn2#">
                            SELECT * FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID = #get_card.action_id#
                        </cfquery>
                        <cfset form.partner_id = get_partner.PARTNER_ID>
                    </cfif>
                </cfif>
        	</cfif>
        
            <cfset fis_action_id = ACTION_ID>
            <cfset form.sale_product = 1>
            
            <cfset attributes.department_id = DEPT>
            <cfset attributes.location_id = 1>
            <cfset form.invoice_number = '#FIS_NUMARASI#_#attributes.kasa_numarasi#_#replace(tarih_,"/","","all")#'>
            <cfset form.serial_no = '#FIS_NUMARASI#_#attributes.kasa_numarasi#_#replace(tarih_,"/","","all")#'>
            
            <cfset form.basket_net_total = fis_toplam>
            <cfset form.basket_gross_total = fis_toplam - fis_toplam_kdv>
            <cfset form.basket_tax_total = fis_toplam_kdv>
            <cfset form.BASKET_DISCOUNT_TOTAL = 0>
            <cfset form.basket_otv_total = 0>
            <cfset form.yuvarlama = 0>
            <cfset form.genel_indirim = 0>
            <cfset form.DELIVER_GET_ID = session.ep.userid>
            <cfset form.DELIVER_GET = session.ep.userid>
            <cfset form.basket_money = 'TL'>
            <cfset form.basket_discount_total = 0>
            <cfset inventory_product_exists = 1>
            
                
            <cfset gercek_sayi_ = 0>
            <cfoutput>
            	<cfif birim_adi is 'Metre'>
					<cfset birim_adi_ = "M">
                <cfelse>
                    <cfset birim_adi_ = birim_adi>
                </cfif>
            
                <cfset gercek_sayi_ = gercek_sayi_ + 1>
                    
                    <cfquery name="get_prod" datasource="#dsn1#">
                        SELECT 
                            *, 
                            P.PRODUCT_NAME+' '+S.PROPERTY NAME_PRODUCT,
                            (SELECT UNIT_ID FROM PRODUCT_UNIT PU WHERE PU.PRODUCT_ID = P.PRODUCT_ID AND ADD_UNIT = '#birim_adi_#') UNIT_ID
                        FROM 
                            PRODUCT P INNER JOIN 
                            STOCKS S ON S.PRODUCT_ID = P.PRODUCT_ID 
                        WHERE 
                            S.STOCK_ID = #stock_id#
                    </cfquery>
        
                    <cfset "form.product_name#gercek_sayi_#" = "#get_prod.NAME_PRODUCT#" />
                    <cfset "form.product_id#gercek_sayi_#" = "#get_prod.product_id#" />
                    <cfset "form.stock_id#gercek_sayi_#" = "#get_prod.stock_id#" />
                    
                    <cfset "form.amount#gercek_sayi_#" = "#miktar#" />
                    
                    <cfset "form.unit#gercek_sayi_#" = "#birim_adi_#" />
                    <cfset "form.unit_id#gercek_sayi_#" = "#get_prod.UNIT_ID#" />
                    
                    
                    <cfset "form.price#gercek_sayi_#" = "#SATIR_SON_TOPLAM / MIKTAR#"/>
                    
                    <cfset "form.row_lasttotal#gercek_sayi_#" = "#SATIR_SON_TOPLAM#" />
                    <cfset "form.row_total#gercek_sayi_#" = "#SATIR_SON_TOPLAM - satir_kdv_tutar#" />
                    <cfset "form.row_otvtotal#gercek_sayi_#" = "0" />
                    <cfset "form.row_nettotal#gercek_sayi_#" = "#SATIR_SON_TOPLAM - satir_kdv_tutar#" />
                    <cfset "form.row_taxtotal#gercek_sayi_#" = "#satir_kdv_tutar#" />
                    <cfset "form.tax#gercek_sayi_#" = "#satir_kdv#" />
                    <cfset "form.deliver_date#gercek_sayi_#" = "#tarih_#"/>
                    <cfset "form.deliver_dept#gercek_sayi_#" = "#get_fatura.dept#"/>
                    <cfset "form.deliver_loc#gercek_sayi_#" = "1"/>
                    <cfset "form.other_money#gercek_sayi_#" = "TL"/>
                    <cfset "form.other_money_#gercek_sayi_#" = "TL"/>
                    <cfset "form.other_money_value_#gercek_sayi_#" = "#SATIR_SON_TOPLAM - satir_kdv_tutar#"/>
                    <cfset "form.price_other#gercek_sayi_#" = "#SATIR_SON_TOPLAM / MIKTAR#" />
                    <cfset "form.other_money_grosstotal#gercek_sayi_#" = "#SATIR_SON_TOPLAM#"/>
                    <cfset "form.otv_oran#gercek_sayi_#" = ""/>
                    <cfset "form.is_inventory#gercek_sayi_#" = "1"/>
                    <cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
                    <cfset "form.wrk_row_id#gercek_sayi_#" = "#wrk_id#"/>
                    <cfset "form.spect_id#gercek_sayi_#" = ""/>
                    <cfset "form.spect_name#gercek_sayi_#" = ""/>
            </cfoutput>
            <cfset attributes.rows_ = gercek_sayi_>
            <cfscript>StructAppend(attributes,form);</cfscript>
            <cfquery name="cont_" datasource="#dsn_dev#">
                SELECT * FROM POS_CONS_ACTIONS WHERE FIS_ACTION_ID = #fis_action_id# AND ACTION_TYPE = 52
            </cfquery>
            <cfif not cont_.recordcount>
                <cfinclude template="/invoice/query/add_invoice_sale.cfm">
                <cfquery name="add_relation" datasource="#dsn_dev#">
                    INSERT INTO
                        POS_CONS_ACTIONS
                        (
                        CON_ID,
                        ACTION_ID,
                        ACTION_TABLE,
                        FIS_ACTION_ID,
                        PERIOD_ID,
                        ACTION_TYPE
                        )
                        VALUES
                        (
                        #max_id_con_id#,
                        #get_invoice_id.max_id#,
                        'INVOICE',
                        #fis_action_id#,
                        #session.ep.period_id#,
                        52
                        )
                </cfquery>
           </cfif>
        </cfoutput>
    </cfif>
    <!--- fatura --->
    
    <!--- zraporu --->
    <cfquery name="get_z" datasource="#dsn2#">
        SELECT * FROM INVOICE WHERE INVOICE_CAT = 69 AND INVOICE_NUMBER = 'Z-#attributes.z_number#/#attributes.kasa_numarasi#/#replace(tarih_,"/","","all")#'
    </cfquery>
    
    <cfif get_z.recordcount>
        <cfoutput query="get_z">
            <cfset form.del_invoice_id = get_z.invoice_id>
            <cfset attributes.invoice_id = get_z.invoice_id>
            <cfset form.invoice_id = get_z.invoice_id>
            <cfset form.process_cat = 27>
            <cfset form.old_process_type = 69>
            <cfset form.invoice_number = 'Z-#attributes.z_number#/#attributes.kasa_numarasi#/#replace(tarih_,"/","","all")#'>
            <cfinclude template="del_z_report.cfm">
            <cfscript>
                StructDelete(form,'del_invoice_id');
                StructDelete(form,'invoice_id');
                StructDelete(form,'old_process_type');
                StructDelete(attributes,'invoice_id');
            </cfscript> 
       </cfoutput>
    </cfif>
    
    <cfscript>
        StructDelete(form,'invoice_number');
        StructDelete(attributes,'invoice_number');
    </cfscript> 
    <cfset form.department_id = get_info.DEPT>
    <cfset form.location_id = 1>
    <cfset form.branch_id = get_info.branch_id>
    <cfset form.pos_cash_id = get_info.pos_id>
    <cfset form.invoice_cat = 69>
    <cfset form.process_cat = 27>
    <cfset form.employee_id = attributes.kayit_user>
    <cfset form.employee_name = 'Kullanıcı'>
    <cfset form.note = "Genius Otomatik Z Raporu (zno:#attributes.z_number# / kasa:#attributes.kasa_numarasi#)">
    <cfset form.invoice_date = tarih_>
    <cfset form.invoice_number = 'Z-#attributes.z_number#/#attributes.kasa_numarasi#/#replace(tarih_,"/","","all")#'>
    <cfset form.sale_product = 1>
    
    <cfset form.period_id = session.ep.period_id>
    <cfset form.active_period = session.ep.period_id>
    <cfset form.BASKET_RATE1 = 1>
    <cfset form.BASKET_RATE2 = 1>
    <cfset form.is_cash = 1>
    <cfset form.is_pos = 1>
    <cfset form.x_show_info = 1>
    <cfset attributes.total_diff_amount = 0>
    <cfset toplanan_amount = 0>
    <cfset satir_amount = 0>
    
    
    <cfquery name="get_cash" datasource="#dsn2#">
        SELECT
            *
        FROM
            CASH
        WHERE
            DEPARTMENT_ID = #get_info.DEPT#
    </cfquery>
    
    <cfquery name="get_cekme" datasource="#dsn_dev#">
        SELECT
            ISNULL(SUM(TESLIM_TUTAR),0) AS ODEME_TUTAR
        FROM 
            POS_CONS_PAYMENTS GAP
        WHERE
            GAP.ODEME_TURU IN (26) AND
            GAP.CON_ID = #max_id_con_id#
    </cfquery>
    
    <!---
    <cfquery name="get_odeme_usd" datasource="#dsn_dev#">
        SELECT
            GAP.ODEME_TURU,
            SUM(ODEME_TUTAR) AS ODEME_TUTAR
        FROM 
            GENIUS_ACTIONS GA,
            GENIUS_ACTIONS_PAYMENTS GAP
        WHERE
            GAP.ODEME_TURU = 5 AND
            GAP.ODEME_IPTALMI = 0 AND
            GA.ACTION_ID = GAP.ACTION_ID AND
            GA.FIS_IPTAL = 0 AND
            GA.BELGE_TURU = '0' AND
            YEAR(GA.FIS_TARIHI) = #yil_# AND
            MONTH(GA.FIS_TARIHI) = #ay_# AND
            DAY(GA.FIS_TARIHI) = #gun_# AND
            GA.ZNO = '#attributes.z_number#' AND
            GA.KASA_NUMARASI = #attributes.kasa_numarasi#
        GROUP BY
            GAP.ODEME_TURU
    </cfquery>
	--->
    <cfquery name="get_odeme_usd" datasource="#dsn_dev#">
    	SELECT
        	SUM(TESLIM_TUTAR) AS ODEME_TUTAR,
            ODEME_TURU
        FROM
        	POS_CONS_PAYMENTS
        WHERE
        	CON_ID = #max_id_con_id# AND
            ODEME_TURU = 5
        GROUP BY
        	ODEME_TURU
    </cfquery>
    
    <!---
    <cfquery name="get_odeme_euro" datasource="#dsn_dev#">
        SELECT
            GAP.ODEME_TURU,
            SUM(ODEME_TUTAR) AS ODEME_TUTAR
        FROM 
            GENIUS_ACTIONS GA,
            GENIUS_ACTIONS_PAYMENTS GAP
        WHERE
            GAP.ODEME_TURU = 6 AND
            GAP.ODEME_IPTALMI = 0 AND
            GA.ACTION_ID = GAP.ACTION_ID AND
            GA.FIS_IPTAL = 0 AND
            GA.BELGE_TURU = '0' AND
            YEAR(GA.FIS_TARIHI) = #yil_# AND
            MONTH(GA.FIS_TARIHI) = #ay_# AND
            DAY(GA.FIS_TARIHI) = #gun_# AND
            GA.ZNO = '#attributes.z_number#' AND
            GA.KASA_NUMARASI = #attributes.kasa_numarasi#
        GROUP BY
            GAP.ODEME_TURU
    </cfquery>
	--->
    <cfquery name="get_odeme_euro" datasource="#dsn_dev#">
    	SELECT
        	SUM(TESLIM_TUTAR) AS ODEME_TUTAR,
            ODEME_TURU
        FROM
        	POS_CONS_PAYMENTS
        WHERE
        	CON_ID = #max_id_con_id# AND
            ODEME_TURU = 6
        GROUP BY
        	ODEME_TURU
    </cfquery>
    
    <cfquery name="get_expense" datasource="#dsn2#">
        SELECT * FROM EXPENSE_CENTER WHERE EXPENSE_DEPARTMENT_ID = #get_info.DEPT#
    </cfquery>
    
    <cfset form.expense_center_id = get_expense.expense_id>
    <cfset form.expense_center = get_expense.expense>
    
    <cfset kasa_amount_ = filternum(attributes.teslim_tutar_1) + toplam_iade_tutar_ + get_cekme.ODEME_TUTAR>

    <cfset kasa_acik_tutar_faturadan_ = 0>
	
    
    <cfset fatura_sayisi = 0>
    <cfset irsaliye_sayisi = 0>
    
    <cfset fatura_toplam = 0>
    <cfset irsaliye_toplam = 0>
    
    <cfset fatura_kdv_toplam = 0>
    <cfset irsaliye_kdv_toplam = 0>
    
	<cfif get_fatura.recordcount>
        <cfset fat_ = 0>
        <cfoutput query="get_fatura" group="FIS_NUMARASI">
			<cfset fat_ = fat_ + fis_toplam>
            <cfset fatura_sayisi = fatura_sayisi + 1>
            <cfset fatura_toplam = fatura_toplam + fis_toplam>
            <cfset fatura_kdv_toplam = fatura_kdv_toplam + FIS_TOPLAM_KDV>
            <cfoutput></cfoutput>
        </cfoutput>
        <cfset kasa_amount_ = kasa_amount_ - fat_>
    </cfif>
    
    <cfif kredi_kartli_faturali_satis_toplam gt 0>
    	<cfset kasa_amount_ = kasa_amount_ + kredi_kartli_faturali_satis_toplam>
    </cfif>
    
    <cfif get_irsaliye.recordcount>
        <cfset irs_ = 0>
        <cfoutput query="get_irsaliye" group="FIS_NUMARASI">
			<cfset irs_ = irs_ + fis_toplam>
            <cfset irsaliye_sayisi = irsaliye_sayisi + 1>
            <cfset irsaliye_toplam = irsaliye_toplam + fis_toplam>
            <cfset irsaliye_kdv_toplam = irsaliye_kdv_toplam + FIS_TOPLAM_KDV>
            <cfoutput></cfoutput>
        </cfoutput>
        <cfset kasa_amount_ = kasa_amount_ - irs_>
    </cfif>
    
    <cfif kasa_amount_ lt 0>
    	<cfset kasa_acik_tutar_faturadan_ = kasa_amount_ * -1>
    </cfif>

    <cfset form.cash_amount1 = kasa_amount_>
    <cfset form.kasa1 = get_cash.cash_id>
    <cfset form.system_cash_amount1 = kasa_amount_>
    <cfset form.currency_type1 = 'TL'>
    
    <cfif get_odeme_usd.recordcount>
        <cfset form.cash_amount2 = wrk_round(get_odeme_usd.ODEME_TUTAR / dolar_carpan)>
        <cfif session.ep.period_year gte 2017><cfset form.kasa2 = 9><cfelse><cfset form.kasa2 = 11></cfif>
        <cfset form.system_cash_amount2 = wrk_round(get_odeme_usd.ODEME_TUTAR)>
        <cfset form.currency_type2 = 'USD'>
    <cfelse>
        <cfset form.cash_amount2 = 0>
        <cfif session.ep.period_year gte 2017><cfset form.kasa2 = 9><cfelse><cfset form.kasa2 = 11></cfif>
        <cfset form.system_cash_amount2 = 0>
        <cfset form.currency_type2 = 'USD'>
    </cfif>
    
    <cfif get_odeme_euro.recordcount>
        <cfset form.cash_amount3 = wrk_round(get_odeme_euro.ODEME_TUTAR / euro_carpan)>
        <cfif session.ep.period_year gte 2017><cfset form.kasa3 = 10><cfelse><cfset form.kasa3 = 12></cfif>
        <cfset form.system_cash_amount3 = wrk_round(get_odeme_euro.ODEME_TUTAR)>
        <cfset form.currency_type3 = 'EUR'>
    <cfelse>
        <cfset form.cash_amount3 = 0>
        <cfif session.ep.period_year gte 2017><cfset form.kasa3 = 10><cfelse><cfset form.kasa3 = 12></cfif>
        <cfset form.system_cash_amount3 = 0>
        <cfset form.currency_type3 = 'EUR'>
    </cfif>
    
    <cfset toplanan_amount = toplanan_amount + kasa_amount_>
    <cfset toplanan_amount = toplanan_amount + form.system_cash_amount2>
    <cfset toplanan_amount = toplanan_amount + form.system_cash_amount3>
    
    
    <cfquery name="get_odeme_pos" datasource="#dsn_dev#">
        SELECT
            GAP.ODEME_TURU,
            ACCOUNTS.ACCOUNT_ID,
            ACCOUNTS.ACCOUNT_CURRENCY_ID,
            CPT.PAYMENT_TYPE_ID,
            SUM(TESLIM_TUTAR) AS ODEME_TUTAR
        FROM 
            POS_CONS_PAYMENTS GAP,
            #dsn3_alias#.ACCOUNTS ACCOUNTS,
            #dsn3_alias#.CREDITCARD_PAYMENT_TYPE CPT,
            SETUP_POS_PAYMETHODS SPP
        WHERE
            GAP.ODEME_TURU <> 26 AND
            GAP.CON_ID = #max_id_con_id# AND
            ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
            CPT.IS_ACTIVE = 1 AND 
            ACCOUNTS.ACCOUNT_STATUS = 1 AND
            SPP.CODE = GAP.ODEME_TURU AND
            SPP.WRK_POS_ID = CPT.PAYMENT_TYPE_ID
        GROUP BY
            GAP.ODEME_TURU,
            ACCOUNTS.ACCOUNT_ID,
            ACCOUNTS.ACCOUNT_CURRENCY_ID,
            CPT.PAYMENT_TYPE_ID
    </cfquery>
    
    <cfset form.record_num2 = get_odeme_pos.recordcount>
    
    <cfloop from="1" to="#form.record_num2#" index="ccc">
        <cfset 'form.row_kontrol_2#ccc#' = 1>
        <cfset 'form.pos_amount_#ccc#' = get_odeme_pos.ODEME_TUTAR[ccc]>
        <cfset 'form.system_pos_amount_#ccc#' = get_odeme_pos.ODEME_TUTAR[ccc]>
        <cfset 'form.pos_#ccc#' = '#get_odeme_pos.ACCOUNT_ID[ccc]#;#get_odeme_pos.ACCOUNT_CURRENCY_ID[ccc]#;#get_odeme_pos.PAYMENT_TYPE_ID[ccc]#'>
        <cfset toplanan_amount = toplanan_amount + get_odeme_pos.ODEME_TUTAR[ccc]>
    </cfloop>
    
    <cfquery name="get_money" datasource="#dsn#">
        SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#
    </cfquery>
    
    <cfloop query="get_money">
        <cfset "form.hidden_rd_money_#get_money.currentrow#" = "#GET_MONEY.MONEY#">
        <cfset "form.txt_rate1_#get_money.currentrow#" = "#GET_MONEY.RATE1#">
        <cfset "form.txt_rate2_#get_money.currentrow#" = "#GET_MONEY.RATE2#">
    </cfloop>
    
    <cfset kdv_toplam_satirlar = 0>
    
    <cfset attributes.rows_ = 0>
    <cfset kdv_list = "0,1,8,18">
    <cfset stock_id_list = "25478,25480,25481,25482">
    
    <cfloop from="1" to="4" index="ccc">
        <cfset oran_ = listgetat(kdv_list,ccc)>
        <cfset stock_id = listgetat(stock_id_list,ccc)>
        <cfset deger_ = evaluate("attributes.KDV_MATRAH#oran_#")>
        <cfif len(deger_) and filterNum(deger_) gt 0>
            <cfset attributes.rows_ = attributes.rows_ + 1>
            <cfset gercek_sayi_ = attributes.rows_>
            <cfquery name="get_prod" datasource="#dsn1#">
                SELECT 
                    *, 
                    P.PRODUCT_NAME+' '+S.PROPERTY NAME_PRODUCT,
                    (SELECT UNIT_ID FROM PRODUCT_UNIT PU WHERE PU.PRODUCT_ID = P.PRODUCT_ID AND ADD_UNIT = 'Adet') UNIT_ID
                FROM 
                    PRODUCT P INNER JOIN 
                    STOCKS S ON S.PRODUCT_ID = P.PRODUCT_ID 
                WHERE 
                    S.STOCK_ID = #stock_id#
            </cfquery>
            
            <cfset deger_ = filterNum(evaluate("attributes.KDV_MATRAH#oran_#"))>
            <cfset deger_kdv = filterNum(evaluate("attributes.KDV#oran_#"),4)>
            <cfset deger_kdvli = filterNum(evaluate("attributes.KDVLI#oran_#"))>
            
            <cfset kdv_toplam_satirlar = kdv_toplam_satirlar + deger_kdv>
            <cfset satir_amount = satir_amount + deger_kdvli>
    
            <cfset "form.product_name#gercek_sayi_#" = "#get_prod.NAME_PRODUCT#" />
            <cfset "form.product_id#gercek_sayi_#" = "#get_prod.product_id#" />
            <cfset "form.stock_id#gercek_sayi_#" = "#get_prod.stock_id#" />
            
            <cfset "form.amount#gercek_sayi_#" = 1/>
            
            <cfset kdv_carpan = (100 + oran_) / 100>
            
            <cfset "form.unit#gercek_sayi_#" = "Adet" />
            <cfset "form.unit_id#gercek_sayi_#" = "#get_prod.UNIT_ID#" />
            
            
            <cfset "form.price#gercek_sayi_#" = "#deger_#"/>
            
            <cfset "form.row_lasttotal#gercek_sayi_#" = "#deger_kdvli#" />
            <cfset "form.row_total#gercek_sayi_#" = "#deger_#" />
            <cfset "form.row_otvtotal#gercek_sayi_#" = "0" />
            <cfset "form.row_nettotal#gercek_sayi_#" = "#deger_#" />
            <cfset "form.row_taxtotal#gercek_sayi_#" = "#deger_kdv#" />
            <cfset "form.tax#gercek_sayi_#" = "#oran_#" />
            <cfset "form.basket_tax_#gercek_sayi_#" = "#oran_#" />
            <cfset "form.basket_tax_value_#gercek_sayi_#" = "#deger_kdv#" />
            <cfset "form.deliver_date#gercek_sayi_#" = "#tarih_#"/>
            <cfset "form.deliver_dept#gercek_sayi_#" = "#get_info.dept#"/>
            <cfset "form.deliver_loc#gercek_sayi_#" = "1"/>
            <cfset "form.other_money#gercek_sayi_#" = "TL"/>
            <cfset "form.other_money_#gercek_sayi_#" = "TL"/>
            <cfset "form.other_money_value_#gercek_sayi_#" = "#deger_#"/>
            <cfset "form.price_other#gercek_sayi_#" = "#deger_#" />
            <cfset "form.other_money_grosstotal#gercek_sayi_#" = "#deger_kdvli#"/>
            <cfset "form.otv_oran#gercek_sayi_#" = ""/>
            <cfset "form.is_inventory#gercek_sayi_#" = "1"/>
            <cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
            <cfset "form.wrk_row_id#gercek_sayi_#" = "#wrk_id#"/>
            <cfset "form.spect_id#gercek_sayi_#" = ""/>
            <cfset "form.spect_name#gercek_sayi_#" = ""/>
        </cfif>
    </cfloop>
    
    
    <cfset form.kur_say = 3>
    <cfset form.basket_net_total = satir_amount>
    <cfset form.basket_gross_total = satir_amount - kdv_toplam_satirlar>
    <cfset form.basket_tax_total = kdv_toplam_satirlar>
    <cfset form.BASKET_DISCOUNT_TOTAL = 0>
    <cfset form.basket_otv_total = 0>
    <cfset form.yuvarlama = 0>
    <cfset form.genel_indirim = 0>
    <cfset form.DELIVER_GET_ID = session.ep.userid>
    <cfset form.DELIVER_GET = session.ep.userid>
    <cfset form.basket_money = 'TL'>
    
    
	
	<cfset attributes.total_diff_amount = satir_amount - toplanan_amount - kasa_acik_tutar_faturadan_>
    
    
    <cfif attributes.total_diff_amount gt 0>
        <cfset form.expense_item_id = 170>
        <cfset form.expense_item_name = "197.01.0001 - KASA NOKSANLARI">
    <cfelse>
        <cfset form.expense_item_id = 169>
        <cfset form.expense_item_name = "397.01.001 KASA FAZLASI">
    </cfif>
    
    <cfquery name="get_fisler" datasource="#dsn_dev#">
        SELECT
            GA2.HAREKET_SAYISI
        FROM 
            GENIUS_ACTIONS GA2
        WHERE
            GA2.BELGE_TURU NOT IN ('1','2','4') AND
            YEAR(GA2.FIS_TARIHI) = #yil_# AND
            MONTH(GA2.FIS_TARIHI) = #ay_# AND
            DAY(GA2.FIS_TARIHI) = #gun_# AND
            GA2.ZNO = '#attributes.z_number#' AND
            GA2.KASA_NUMARASI = #attributes.kasa_numarasi#
    </cfquery>
    
    <cfquery name="get_gecerli_fisler" datasource="#dsn_dev#">
        SELECT
            GA2.HAREKET_SAYISI
        FROM 
            GENIUS_ACTIONS GA2
        WHERE
            GA2.FIS_IPTAL = 0 AND
            GA2.BELGE_TURU NOT IN ('1','2','4') AND
            YEAR(GA2.FIS_TARIHI) = #yil_# AND
            MONTH(GA2.FIS_TARIHI) = #ay_# AND
            DAY(GA2.FIS_TARIHI) = #gun_# AND
            GA2.ZNO = '#attributes.z_number#' AND
            GA2.KASA_NUMARASI = #attributes.kasa_numarasi#
    </cfquery>
    
    <cfquery name="get_iptal_fisler" datasource="#dsn_dev#">
        SELECT
            GA2.HAREKET_SAYISI
        FROM 
            GENIUS_ACTIONS GA2
        WHERE
            GA2.FIS_IPTAL = 1 AND
            GA2.BELGE_TURU NOT IN ('1','2','4') AND
            YEAR(GA2.FIS_TARIHI) = #yil_# AND
            MONTH(GA2.FIS_TARIHI) = #ay_# AND
            DAY(GA2.FIS_TARIHI) = #gun_# AND
            GA2.ZNO = '#attributes.z_number#' AND
            GA2.KASA_NUMARASI = #attributes.kasa_numarasi#
    </cfquery>
    
    
    <cfset attributes.total_diff_amount = tlformat(attributes.total_diff_amount)>
    <cfset attributes.total_number_receipt = get_fisler.recordcount><!--- fis sayisi --->
    <cfset attributes.valid_number_receipt = get_gecerli_fisler.recordcount><!--- gecerli fis sayisi --->
    <cfset attributes.cancel_number_receipt = get_iptal_fisler.recordcount><!--- iptal fis sayisi --->
    <cfset attributes.total_number_sales_receipt = 0>
    <cfset attributes.cancel_number_sales_receipt = 0>
    <cfset attributes.total_cancellation = 0>
    <cfset attributes.total_bonus = 0>
    <cfset attributes.total_discount = 0>
    <cfset attributes.total_deposit = 0>
    <cfset attributes.total_discount2 = 0>
    <cfset attributes.cancel_invoice_total = 0>
    <cfset attributes.not_financial_invoice_total = 0>
    <cfset attributes.total_number_invoice = fatura_sayisi + irsaliye_sayisi><!--- fatura sayisi --->
    <cfset attributes.valid_number_invoice = fatura_sayisi + irsaliye_sayisi><!--- gecerli fatura sayisi --->
    <cfset attributes.cancel_number_invoice = 0><!--- iptal fatura sayisi --->
    <cfset attributes.total_invoice = fatura_toplam + irsaliye_toplam><!--- fatura tutar --->
    <cfset attributes.total_kdv_invoice = fatura_kdv_toplam + irsaliye_kdv_toplam><!--- fatura kdv --->
    <cfset attributes.total_cancel_invoice = 0><!--- iptal fatura --->
    <cfset attributes.total_expense_number_receipt = 0>
    <cfset attributes.valid_expense_number_receipt = 0>
    <cfset attributes.cancel_expense_number_receipt = 0>
    <cfset attributes.total_expense = 0>
    <cfset attributes.total_kdv_expense = 0>
    <cfset attributes.total_cancel_expense = 0>
    <cfset attributes.total_number_diplomatic_receipt = 0>
    <cfset attributes.valid_number_diplomatic_receipt = 0>
    <cfset attributes.cancel_number_diplomatic_receipt = 0>
    <cfset attributes.total_diplomatic = 0>
    <cfset attributes.total_cancel_diplomatic = 0>
    <cfset attributes.total_error_number_memory = 0>
    <cfset form.BASKET_TAX_COUNT = attributes.rows_>
    <cfscript>StructAppend(attributes,form);</cfscript>
	
    <cfif attributes.rows_ gt 0>
        <cfinclude template="add_z_report.cfm">
        <cfquery name="del_relation" datasource="#dsn_dev#">
            DELETE FROM POS_CONS_ACTIONS WHERE CON_ID = #max_id_con_id# AND ACTION_TYPE = 69 AND FIS_ACTION_ID = -1
        </cfquery>
        <cfquery name="add_relation" datasource="#dsn_dev#">
            INSERT INTO
                POS_CONS_ACTIONS
                (
                CON_ID,
                ACTION_ID,
                ACTION_TABLE,
                FIS_ACTION_ID,
                PERIOD_ID,
                ACTION_TYPE
                )
                VALUES
                (
                #max_id_con_id#,
                #get_invoice_id.max_id#,
                'INVOICE',
                -1,
                #session.ep.period_id#,
                69
                )
        </cfquery>
	</cfif>
	<!--- zraporu --->
</cflock>
<script>
    window.location.href="<cfoutput>#request.self#?fuseaction=retail.list_pos_equipment&event=upd&CON_ID=#max_id_con_id#</cfoutput>";
</script>