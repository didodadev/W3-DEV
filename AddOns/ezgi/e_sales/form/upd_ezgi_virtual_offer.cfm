<cfset attributes.power_stage = 85><!--- Firmaya Göre Depişir--->
<cfquery name="get_virtual_offer" datasource="#DSN3#">
	SELECT 
    	*,
        ISNULL(REVISION_NO,0) N_REVISION_NO,
        ISNULL(REVISION_ID,0) N_REVISION_ID,
        ISNULL((
        	SELECT        
            	MAX(ISNULL(REVISION_NO,0)) AS MAX_REV_NO
			FROM           
            	EZGI_VIRTUAL_OFFER A
          	WHERE       
            	REVISION_ID = E.REVISION_ID OR REVISION_ID = E.VIRTUAL_OFFER_ID
			GROUP BY 
            	REVISION_ID
        ),0) AS MAX_REV_NO,
        ISNULL((SELECT TOP (1) VIRTUAL_OFFER_ID FROM EZGI_VIRTUAL_OFFER WHERE REVISION_ID = E.REVISION_ID),0) AS IS_REVISION,
        VIRTUAL_OFFER_STAGE
   	FROM 
    	EZGI_VIRTUAL_OFFER E
   	WHERE 
    	VIRTUAL_OFFER_ID = #attributes.virtual_offer_id#
</cfquery>
<!---<cfdump var="#get_virtual_offer#">--->
<cfquery name="get_virtual_offer_row" datasource="#DSN3#">
	SELECT 
    	*,
        ISNULL(QUANTITY,0) AS AMOUNT, 
        ISNULL(PRICE,0) AS SALES_PRICE, 
        ISNULL(OTHER_MONEY,'#session.ep.money#') AS MONEY,
        ISNULL(PURCHASE_PRICE,0) AS PURCHASE_PRICE_, 
        ISNULL(PURCHASE_PRICE_MONEY,'#session.ep.money#') AS PURCHASE_PRICE_MONEY_, 
        ISNULL(P_PURCHASE_PRICE,0) P_PURCHASE_PRICE_, 
        ISNULL(P_PURCHASE_PRICE_MONEY,'#session.ep.money#') AS P_PURCHASE_PRICE_MONEY_, 
        ISNULL(P_DISCOUNT_1,0) P_DISCOUNT_1, 
        ISNULL(P_DISCOUNT_2,0) P_DISCOUNT_2, 
        ISNULL(P_DISCOUNT_3,0) P_DISCOUNT_3, 
        ISNULL(P_DISCOUNT_4,0) P_DISCOUNT_4, 
        ISNULL(P_DISCOUNT_5,0) P_DISCOUNT_5,
        ISNULL(COST_PRICE,0) AS COST_PRICE_, 
        ISNULL(COST_PRICE_MONEY,'#session.ep.money#') AS COST_PRICE_MONEY_,
        ISNULL(DISCOUNT_1,0) AS DISCOUNT1, 
        ISNULL(DISCOUNT_2,0) AS DISCOUNT2, 
        ISNULL(DISCOUNT_3,0) AS DISCOUNT3, 
        ISNULL(DISCOUNT_COST,0) AS DISCOUNT_TUT,
        ISNULL(COST,0) AS HIZMET,
        ISNULL(DELIVER_AMOUNT,0) AS DELIVER_AMOUNT_ ,
        ISNULL((SELECT OFFER_ID FROM OFFER_ROW WHERE WRK_ROW_ID = E.WRK_ROW_RELATION_ID),0) AS OFFER_ID,
        (SELECT ISNULL(IS_TERAZI,0) AS IS_TERAZI FROM STOCKS WHERE STOCK_ID = E.STOCK_ID) AS IS_TERAZI
  	FROM 
    	EZGI_VIRTUAL_OFFER_ROW E
   	WHERE 
    	VIRTUAL_OFFER_ID = #attributes.virtual_offer_id#
 	ORDER BY
    	VIRTUAL_OFFER_ROW_ID
</cfquery>
<cfquery name="get_del_control" dbtype="query">
	SELECT * FROM get_virtual_offer_row WHERE OFFER_ID > 0
</cfquery>
<cfset page_name = 'prod.upd_ezgi_virtual_offer&virtual_offer_id=#attributes.virtual_offer_id#'>
<cfquery name="get_upd_control" datasource="#dsn#">
	SELECT ACTION_PAGE, NAME, SURNAME FROM WRK_SESSION WHERE ACTION_PAGE = '#page_name#' AND USERID <> #session.ep.userid#
</cfquery>
<cfif get_upd_control.recordcount>
	<script type="text/javascript">
		alert("Kullanmak İstediğiniz Sayfayı <CFOUTPUT>#get_upd_control.NAME# #get_upd_control.SURNAME#</CFOUTPUT> Kullandığından Butonlar Görünmemektedir.!");
		window.close()
	</script>
</cfif>
<cfquery name="get_money" datasource="#dsn#">
	SELECT MONEY_ID,MONEY, RATE2, RATE1 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfquery name="get_virtual_offer_money" datasource="#DSN3#">
	SELECT        
    	MONEY_TYPE, 
        RATE2, 
        RATE1, 
        IS_SELECTED
	FROM            
    	EZGI_VIRTUAL_OFFER_MONEY
	WHERE        
    	ACTION_ID = #attributes.virtual_offer_id#
</cfquery>
<cfif isdefined('attributes.virtual_offer_id')>
	<cfoutput query="get_virtual_offer_money">
        <cfset 'RATE1_#MONEY_TYPE#' = RATE1>
        <cfset 'RATE2_#MONEY_TYPE#' = RATE2>
    </cfoutput>
<cfelse>
	<cfoutput query="get_money">
        <cfset 'RATE1_#MONEY#' = RATE1>
        <cfset 'RATE2_#MONEY#' = RATE2>
    </cfoutput>
</cfif>
<cfquery name="get_virtual_offer_money_selected" dbtype="query">
	SELECT 
    	<cfif isdefined('attributes.virtual_offer_id')>       
    		MONEY_TYPE,
        <cfelse>
        	MONEY as MONEY_TYPE,
        </cfif> 
        RATE2
	FROM     
		<cfif isdefined('attributes.virtual_offer_id')>
        	get_virtual_offer_money
        <cfelse>       
    		get_money
        </cfif>
	WHERE
    	<cfif isdefined('attributes.virtual_offer_id')>        
    		IS_SELECTED = 1
        <cfelse>
        	MONEY = '#session.ep.money#'
        </cfif>
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id# AND BRANCH_STATUS = 1 ORDER BY BRANCH_NAME
</cfquery>
<cfset virtual_offer_row_id_list = ''>
<cfinclude template="../../../../V16/sales/query/get_moneys.cfm">
<cfinclude template="../../../../V16/sales/query/get_priorities.cfm">
<cfset process_action = 'virtual_offer'>
<cfset process_fuse = 'upd'>
<cfset attributes.priority_id = get_virtual_offer.priority_id>
<cfset attributes.project_id = get_virtual_offer.PROJECT_ID>
<cfparam name="attributes.country_id1" default="">
<cfparam name="attributes.consumer_reference_code" default="">
<cfparam name="attributes.partner_reference_code" default="">
<cfparam name="attributes.sales_reference_code" default="">
<cfparam name="attributes.sales_partner_id" default="#get_virtual_offer.PARTNER_COMPANY_ID#">
<cfparam name="attributes.ship_method" default="#get_virtual_offer.SHIP_METHOD#">
<cfparam name="attributes.paymethod_id" default="#get_virtual_offer.PAYMETHOD#">
<cfset attributes.branch_id = get_virtual_offer.branch_id>
<cfset attributes.virtual_offer_date = DateFormat(get_virtual_offer.virtual_offer_DATE,'dd/mm/yyyy')>
<cfset attributes.deliverdate = DateFormat(get_virtual_offer.DELIVERDATE,'dd/mm/yyyy')>
<cfset attributes.finishdate = DateFormat(get_virtual_offer.FINISHDATE,'dd/mm/yyyy')>
<cfset attributes.virtual_offer_head = get_virtual_offer.virtual_offer_HEAD>
<cfset attributes.virtual_offer_detail = get_virtual_offer.virtual_offer_DETAIL>
<cfset attributes.deliver_dept_name="">
<cfset attributes.deliver_dept_id= get_virtual_offer.DELIVER_DEPT_ID>
<cfset attributes.deliver_loc_id= get_virtual_offer.LOCATION_ID>
<cfSET attributes.basket_due_value_date_= DateFormat(get_virtual_offer.DUE_DATE,'dd/mm/yyyy')>
<cfSET attributes.basket_due_value= get_virtual_offer.DUE_VALUE>
<cfSET attributes.ref_no = get_virtual_offer.ref_no>
<cfset attributes.process_stage = get_virtual_offer.virtual_offer_STAGE>
<cfset attributes.virtual_offer_status = get_virtual_offer.virtual_offer_status>
<cfset attributes.ref_company_id = "">
<cfset attributes.ref_member_type = "">
<cfset attributes.ref_member_id = "">
<cfif len(get_virtual_offer.company_id)>
	<cfset attributes.company_id = get_virtual_offer.company_id>
    <cfset attributes.partner_id = get_virtual_offer.partner_id>
    <cfset attributes.member_type = get_virtual_offer.member_type>
    <cfset attributes.musteri_id = get_virtual_offer.company_id>
<cfelseif len(get_virtual_offer.consumer_id)>
	<cfset attributes.member_type = get_virtual_offer.member_type>
	<cfset attributes.consumer_id = get_virtual_offer.consumer_id>
    <cfset attributes.musteri_id = get_virtual_offer.consumer_id>
</cfif>

<table class="dph">
  	<tr>
    	<cfoutput>
        <td class="dpht" style="text-align:center">
            <a href="javascript:gizle_goster_basket(detail_inv_menu);">&raquo;</a>Teklif Güncelle : <cfoutput>#get_virtual_offer.virtual_offer_NUMBER#</cfoutput>
            <cfif get_virtual_offer.n_revision_no gt 0>
            	<cfquery name="get_minus" datasource="#dsn3#">
                	SELECT        
                    	TOP (1) VIRTUAL_OFFER_ID
					FROM            
                    	EZGI_VIRTUAL_OFFER
					WHERE        
                    	(REVISION_ID = #get_virtual_offer.REVISION_ID# OR VIRTUAL_OFFER_ID = #get_virtual_offer.REVISION_ID#)  AND 
                        ISNULL(REVISION_NO,0) < #get_virtual_offer.n_revision_no#
					ORDER BY 
                    	REVISION_NO DESC
                </cfquery>
				<cfif len(get_minus.VIRTUAL_OFFER_ID)>
                    <a href="#request.self#?fuseaction=prod.upd_ezgi_virtual_offer&virtual_offer_id=#get_minus.VIRTUAL_OFFER_ID#">
                        <img src="/images/list_minus.gif" border="0" style="vertical-align:top" title="#getLang('objects2',179)#" >
                    </a>
                </cfif>
            </cfif>
        	<cfoutput><cfif get_virtual_offer.max_rev_no gt 0><span style="color:red;"> Rev : <cfif len(get_virtual_offer.revision_no)>#get_virtual_offer.revision_no#<cfelse>0</cfif></span></cfif></cfoutput>
          	<cfif get_virtual_offer.n_revision_no lt get_virtual_offer.max_rev_no>
                	<cfquery name="get_major" datasource="#dsn3#">
                    	<cfif get_virtual_offer.N_REVISION_ID>
                            SELECT        
                                TOP (1) VIRTUAL_OFFER_ID
                            FROM     
                                EZGI_VIRTUAL_OFFER
                            WHERE        
                                REVISION_ID = #get_virtual_offer.N_REVISION_ID# AND 
                                REVISION_NO > #get_virtual_offer.n_revision_no#
                            ORDER BY 
                                REVISION_NO
                     	<cfelse>
                     		SELECT        
                                TOP (1) VIRTUAL_OFFER_ID
                            FROM     
                                EZGI_VIRTUAL_OFFER
                            WHERE        
                                REVISION_ID = #attributes.virtual_offer_id# AND 
                                REVISION_NO > #get_virtual_offer.n_revision_no#
                            ORDER BY 
                                REVISION_NO
                        </cfif>
                    </cfquery>
                    <cfif len(get_major.VIRTUAL_OFFER_ID)>
                        <a href="#request.self#?fuseaction=prod.upd_ezgi_virtual_offer&virtual_offer_id=#get_major.VIRTUAL_OFFER_ID#">
                            <img src="/images/list_plus.gif" border="0" style="vertical-align:top" title="#getLang('objects2',180)#">
                        </a>
                    </cfif>
       		</cfif>
        </td>
        <td class="dphb">
            <table align="right">
                <tr><td></td></tr>
            </table>
        </td>
        <td style="width:200px; text-align:right">
            <a href="#request.self#?fuseaction=prod.list_ezgi_virtual_offer"><img src="/images/refer.gif" border="0" title="#getLang('main',2853)#" ></a>
            <cfif isdefined('attributes.company_id')>
            	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#attributes.musteri_id#','list');">
            		<img src="/images/dashboard.gif" border="0" title="<cf_get_lang_main no='107.Cari Hesap'>" id="uye_takip">
                </a>
           	<cfelse>
            	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#attributes.musteri_id#','list');">
            		<img src="/images/dashboard.gif" border="0" title="<cf_get_lang_main no='107.Cari Hesap'>" id="uye_takip">
                </a>
           	</cfif>
        	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.popup_list_ezgi_virtual_offer_pluses&virtual_offer_id=#url.virtual_offer_id#','page');">
            	<img src="/images/quiz.gif" border="0" title="<cf_get_lang_main no='3388.Takipler'>" id="dsp_takip">
           	</a>
            <cfif attributes.power_stage eq get_virtual_offer.VIRTUAL_OFFER_STAGE>
            <a style="cursor:pointer" onclick="transfer_virtual_offer();">
            	<img src="/images/target_customer.gif" title="Satış Teklifi Oluştur" border="0">
          	</a>
            </cfif>
        	<a href="#request.self#?fuseaction=prod.add_ezgi_virtual_offer">
            	<img src="/images/plus1.gif" title="Teklif Oluştur" id="new_virtual_offer" border="0">
          	</a>
            
            <a style="cursor:pointer" onclick="cpy_virtual_offer(1);">
            	<img src="/images/plus.gif" alt="Teklif Kopyala" id="copy_virtual_offer" title="Teklif Kopyala" border="0">		
          	</a>
            <a style="cursor:pointer" onclick="cpy_virtual_offer(2);">
            	<img src="/images/config.gif" alt="Teklif Revizyonu" id="revision_virtual_offer" title="Teklif Revizyonu" border="0">		
          	</a>
        	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#url.virtual_offer_id#&print_type=287','page');">
            	<img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>" id="dsp_print">
           	</a> 
		</td>
        </cfoutput>					
  	</tr>
</table>
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_virtual_offer">
	<cfinput type="hidden" name="virtual_offer_id" value="#attributes.virtual_offer_id#">
    <cfinput type="hidden" name="virtual_offer_money" id="virtual_offer_money" value="#get_virtual_offer_money_selected.MONEY_TYPE#">
    <cfinput type="hidden" name="virtual_offer_rate2" id="virtual_offer_rate2" value="#TlFormat(get_virtual_offer_money_selected.RATE2,4)#">
    <cfif get_virtual_offer.max_rev_no gt get_virtual_offer.N_REVISION_NO>
        <cfinput type="hidden" name="is_revision_small" value="1">
        <cfset is_revision_small = 1>
    <cfelse>
        <cfset is_revision_small = 0>
    </cfif>
	<cf_basket_form id="detail_inv_menu">
		<cfinclude template="header_ezgi_virtual_offer.cfm">
    </cf_basket_form>
	<cfinclude template="basket_ezgi_virtual_offer.cfm">
    <cfif ListFind(session.ep.power_user_level_id,2188)>
    	<cfinclude template="footer_ezgi_virtual_offer.cfm">
    </cfif>
    <cfif len(get_virtual_offer.revision_id)>
    	<cfinput type="hidden" name="is_revision" value="1">
        <cfinput type="hidden" name="revision_id" value="#get_virtual_offer.revision_id#">
    </cfif>
    
</cfform>
<cfloop query="get_virtual_offer_row">


</cfloop>
<script type="text/javascript">
	function transfer_virtual_offer()
	{
		anahtar = 0;
		<cfloop query="get_virtual_offer_row">
			<cfif virtual_offer_ROW_CURRENCY eq 2>
				anahtar = 1;
			</cfif>
		</cfloop>
		if(anahtar ==1)
		{
			soru = confirm('Onaylı Satırları Gerçek Teklife Çeviririyorsunuz !');
			if(soru==true)
				window.location ="<cfoutput>#request.self#?fuseaction=sales.emptypopup_trf_ezgi_virtual_offer&virtual_offer_id=#attributes.virtual_offer_id#</cfoutput>";
			else
				return false;
		}
		else
		{
			alert('Onaylı Kayıt Bulunamdı !');
			return false;
		}
	}
	function cpy_virtual_offer(type)
	{
		if(type == 1)
		{
			soru = confirm('Teklifin Kopyasını Oluşturuyorsunuz !');
			if(soru==true)
				window.location ="<cfoutput>#request.self#?fuseaction=prod.emptypopup_add_ezgi_virtual_offer&cpy_virtual_offer_id=#attributes.virtual_offer_id#</cfoutput>";
			else
				return false;	
		}
		else if(type == 2)
		{
			soru = confirm('Teklifi Revize Ediyorsunuz !');
			if(soru==true)
				window.location ="<cfoutput>#request.self#?fuseaction=prod.emptypopup_add_ezgi_virtual_offer&rvs_virtual_offer_id=#attributes.virtual_offer_id#</cfoutput>";
			else
				return false;	
		}
	}
</script>