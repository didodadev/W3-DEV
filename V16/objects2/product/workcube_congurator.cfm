<!--- Sayfa tasarlanırken önce ara ürünlere spec oluşturarak ana ürün için bir spec kaydetmek üzere tasarlandı.Anacak daha sonra  --->
<cfparam name="attributes.deep_level_max" default="2">
<cfset attributes.spect_main_id = ''>
<cfparam name="attributes.order_amount" default="1">
<cfparam name="attributes.is_stock_info_display" default="0">
<cfsetting showdebugoutput="no">
<cfif not len(attributes.spect_main_id) and len(attributes.stock_id)>
	<cfquery name="GET_PRODUCT_INFO" datasource="#DSN3#">
    	SELECT TOP 1 PRODUCT_ID,PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
    </cfquery>
    <cfset attributes.product_id = get_product_info.product_id>
    <cfset attributes.spec_name = get_product_info.product_name>
    <cfinclude template="../../workdata/get_main_spect_id.cfm">
	<cfset _new_main_spec_id_ = get_main_spect_id(attributes.stock_id)>
    <cfset attributes.spect_main_id = _new_main_spec_id_.spect_main_id>
</cfif>
<cfform name="add_production_ordel_all" action="#request.self#?fuseaction=objects2.emptypopup_work_conf_query_page" method="post">
	<cfset production_row_count = 0>
    <!---Değerler sırası ile = stock_id,spect_var_id(sadece ana üründe spect_var id aşağıda ise spect_main_id),miktar,deep_level(oluşturulacak olan rota haritasında işimiz görecek.) --->
    <cfoutput>
    <cfif isdefined('attributes.spect_var_id') and not len(attributes.spect_var_id)>
        <cfset attributes.spect_var_id = 0>
    </cfif>
    <cfquery name="GET_MONEY" datasource="#DSN2#">
        SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY
    </cfquery>
    <cfset money_list =''>
    <cfloop query="get_money">
		<cfset '_money_#money#' = rate2/rate1>
        <!--- <cfset money_list =  '#money_list#,#MONEY#'> --->
    </cfloop>
	<cfset money_list = ValueList(get_money.money,',')>
    <cfset money_rate1_list = ValueList(get_money.rate1,',')>
    <cfset money_rate2_list = ValueList(get_money.rate2,',')>
	<input type="hidden" name="money_list" name="money_list" value="<cfoutput>#money_list#</cfoutput>">
    <input type="hidden" name="money_rate1_list" name="money_rate1_list" value="<cfoutput>#money_rate1_list#</cfoutput>">
    <input type="hidden" name="money_rate2_list" name="money_rate2_list" value="<cfoutput>#money_rate2_list#</cfoutput>">
    </cfoutput>
    <br/>
    <cfscript>
        modul_genel_toplam = 0;
        danısmanlik_genel_toplam =0;
        system_2_money = session_base.money2;
        function get_subs(spect_main_id){
            SQLStr = "
                      SELECT
                        ISNULL(P.IS_PURCHASE,0) IS_PURCHASE,
                        ISNULL(P.IS_PRODUCTION,0)IS_PRODUCTION,
                        ISNULL(SMR.RELATED_MAIN_SPECT_ID,0)AS RELATED_ID,
                        SMR.STOCK_ID,
						SMR.PRODUCT_ID,
                        SMR.AMOUNT,
                        SMR.IS_CONFIGURE,
                        P.PRODUCT_NAME,
                        CASE WHEN P.PRODUCT_DETAIL = '' THEN '-' ELSE ISNULL(P.PRODUCT_DETAIL,'-') END AS PRODUCT_DETAIL,
                        PS.PRICE,PS.PRICE_KDV,PS.MONEY,
                        ISNULL(P.WORK_STOCK_ID,0) AS WORK_STOCK_ID,
                        ISNULL(P.WORK_STOCK_AMOUNT,0) AS WORK_STOCK_AMOUNT,
						PU.PRODUCT_UNIT_ID
                    FROM 
                        SPECT_MAIN_ROW SMR,
                        PRODUCT P,
                        PRICE_STANDART PS,
						PRODUCT_UNIT PU
                    WHERE
						PU.PRODUCT_ID = SMR.PRODUCT_ID AND
						PU.IS_MAIN = 1 AND
                        PS.PRODUCT_ID = SMR.PRODUCT_ID AND
                        P.PRODUCT_ID = SMR.PRODUCT_ID AND
                        SPECT_MAIN_ID = #spect_main_id# AND
                        IS_PROPERTY = 0 AND
                        PS.PRICESTANDART_STATUS = 1 AND
                        PS.PURCHASESALES = 1
                    ORDER BY
                        SMR.LINE_NUMBER,
                        P.PRODUCT_NAME
                     ";
                stock_id_ary ='';
                query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
                for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
                {
                    if(not isdefined('workcube_iscilik_fiyatı#query1.WORK_STOCK_ID[str_i]#') and query1.WORK_STOCK_ID[str_i] gt 0){//işçilik ürünü genelde bir ürün için olduğu için yukarda sadece work_stock_id'yi çekiyorum.burda da her seferinde bir query yapmamak için daha önceden tanımlı olan work_stock_id'i tekrar çekmiyorum ve onun standart satış fiyatını kullanıyorum..
                        GetPriceStaSQLStr = "SELECT PRICE,PRICE_KDV,MONEY,PRODUCT_ID FROM PRICE_STANDART WHERE PRICESTANDART_STATUS = 1 AND PURCHASESALES = 1 AND PRODUCT_ID =(SELECT PRODUCT_ID FROM STOCKS WHERE STOCK_ID =#query1.WORK_STOCK_ID[str_i]#)";
                        GetPriceStaQuery = cfquery(SQLString : GetPriceStaSQLStr, Datasource : dsn3);
                        if(GetPriceStaQuery.recordcount){
                            if(system_2_money neq GetPriceStaQuery.MONEY){//eğerki ürünün para birimi sistem 2.ci para biriminden farklı ise fiyatı hesaplasın..
                                'workcube_iscilik_fiyatı#query1.WORK_STOCK_ID[str_i]#' =(GetPriceStaQuery.PRICE * Evaluate("_money_#GetPriceStaQuery.MONEY#"))/ Evaluate("_money_#system_2_money#");
								'workcube_iscilik_fiyatı_kdv#query1.WORK_STOCK_ID[str_i]#' =(GetPriceStaQuery.PRICE_KDV * Evaluate("_money_#GetPriceStaQuery.MONEY#"))/ Evaluate("_money_#system_2_money#");
							}	
                            else{
                                'workcube_iscilik_fiyatı#query1.WORK_STOCK_ID[str_i]#'= GetPriceStaQuery.PRICE;
								'workcube_iscilik_fiyatı_kdv#query1.WORK_STOCK_ID[str_i]#'= GetPriceStaQuery.PRICE;
							}	
							writeoutput('<input type="hidden" name="danismanlik_urun_info" value="#query1.WORK_STOCK_ID[str_i]#█#GetPriceStaQuery.PRODUCT_ID[str_i]#">');
                        }		
                    }
                    stock_id_ary=listappend(stock_id_ary,query1.RELATED_ID[str_i],'█');//1
                    stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'§');//2
                    stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_NAME[str_i],'§');//3
                    stock_id_ary=listappend(stock_id_ary,query1.AMOUNT[str_i],'§');//4
                    stock_id_ary=listappend(stock_id_ary,query1.IS_PRODUCTION[str_i],'§');//5
                    stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_DETAIL[str_i],'§');//6
                    stock_id_ary=listappend(stock_id_ary,query1.PRICE[str_i],'§');//7777
                    stock_id_ary=listappend(stock_id_ary,query1.MONEY[str_i],'§');//888
                    stock_id_ary=listappend(stock_id_ary,query1.IS_CONFIGURE[str_i],'§');//9
                    stock_id_ary=listappend(stock_id_ary,query1.WORK_STOCK_ID[str_i],'§');//10
                    stock_id_ary=listappend(stock_id_ary,query1.WORK_STOCK_AMOUNT[str_i],'§');//11
					stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_ID[str_i],'§');//12
					stock_id_ary=listappend(stock_id_ary,query1.PRICE_KDV[str_i],'§');//13
					stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_UNIT_ID[str_i],'§');//14
                }
                return stock_id_ary;
        }
        function get_spec_conf(spect_main_id)
        {
            var _get_subs_ =get_subs(spect_main_id);
            for (i=1; i lte listlen(_get_subs_,'█'); i = i+1)
            {
                //leftSpace = RepeatString('&nbsp;', deep_level*5);
                _next_spect_main_id_ = ListGetAt(ListGetAt(_get_subs_,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
                _next_stock_id_ = ListGetAt(ListGetAt(_get_subs_,i,'█'),2,'§');
                _next_product_name_ = ListGetAt(ListGetAt(_get_subs_,i,'█'),3,'§');
                _next_stock_amount_ = ListGetAt(ListGetAt(_get_subs_,i,'█'),4,'§');
                _next_is_production_ = ListGetAt(ListGetAt(_get_subs_,i,'█'),5,'§');
                _next_product_detail_ = ListGetAt(ListGetAt(_get_subs_,i,'█'),6,'§');
                //_next_product_price_ = ListGetAt(ListGetAt(_get_subs_,i,'█'),7,'§');
                writeoutput('
                    <table  style="width:98%; text-align:left" cellpadding="0" cellspacing="0">
						<tr style="height:29px;">
							<td style="background-image:url(../../images/conf1.jpg);width:138px; text-align:left;color:FFFFFF; padding-left:10px;font-weight:bold;font-family: Geneva, Verdana, Arial, sans-serif;font-size:12px;">#_next_product_name_#</td>
							<td style="background-image:url(../../images/conf4.jpg);width:80%;"></td>
						</tr>
                    	<tr>
                    		<td colspan="2">
								<table style="width:100%; text-align:left" cellpadding="0" cellspacing="0">
									<tr>
										<td style="background-repeat:no-repeat;background-image:url(../../images/conf5.jpg);width:2px;" rowspan="4"></td>
									   	<td style="padding-top:15px;padding-left:15px;">
											<!---<font class="headbold">#_next_product_name_#</font>
											<br/><br/>--->
											#_next_product_detail_#
										</td>
									</tr>
                        ');
                 if(_next_is_production_ eq 1 and _next_spect_main_id_ gt 0){
                    _get_subs_2_ = get_subs(_next_spect_main_id_);
                    modul_ara_toplam =0;
                    danısmanlik_ara_toplam=0;
                    if(listlen(_get_subs_2_,'█'))//eğer ürünün altında alt ürünler var ise
                        writeoutput('
                        <tr class="color-row">
                            <td>
                                <table bordercolor="FFFFFF" cellpadding="2" cellspacing="1">
                                    <tr valign="top">
                        ');
                            for (x=1;x lte listlen(_get_subs_2_,'█');x=x+1){
                                _next_stock_id_2_ = ListGetAt(ListGetAt(_get_subs_2_,x,'█'),2,'§');
                                _next_product_name_2 = ListGetAt(ListGetAt(_get_subs_2_,x,'█'),3,'§');
								_next_product_detail_2 = ListGetAt(ListGetAt(_get_subs_2_,x,'█'),6,'§');
								_next_product_amount_2 = ListGetAt(ListGetAt(_get_subs_2_,x,'█'),4,'§');
                                _next_product_price_2_ = ListGetAt(ListGetAt(_get_subs_2_,x,'█'),7,'§');
								_next_product_price_kdv_2_ = ListGetAt(ListGetAt(_get_subs_2_,x,'█'),13,'§');
                                _next_product_money_2_ = ListGetAt(ListGetAt(_get_subs_2_,x,'█'),8,'§');
                                _next_is_configure_2_ = ListGetAt(ListGetAt(_get_subs_2_,x,'█'),9,'§');
                                _next_work_stock_id_2_ = ListGetAt(ListGetAt(_get_subs_2_,x,'█'),10,'§');
                                _next_work_stock_amount_2_ = ListGetAt(ListGetAt(_get_subs_2_,x,'█'),11,'§');
                                _next_product_id_2_ = ListGetAt(ListGetAt(_get_subs_2_,x,'█'),12,'§');
                                _next_product_unit_id_2_ = ListGetAt(ListGetAt(_get_subs_2_,x,'█'),14,'§');
                                if(_next_work_stock_id_2_ gt 0 and isdefined('workcube_iscilik_fiyatı#_next_work_stock_id_2_#'))//ürün için işçilik ürünü girilmiş ise
                                    alt_kırılım_danısmanlik_fiyatı = _next_work_stock_amount_2_ * Evaluate('workcube_iscilik_fiyatı#_next_work_stock_id_2_#');//işçilik ürünün fiyatı ile miktarı carpıyoruz.
                                else
                                    alt_kırılım_danısmanlik_fiyatı = 0;
                                if(_next_is_configure_2_ eq 0)//eğer configure ediliyorsa disabled ve checked olsun..
                                    prod_dis_check = 'disabled checked';//
                                else
                                    prod_dis_check = 'checked';//
                                if(system_2_money neq _next_product_money_2_){	//eğerki ürünün para birimi sistem 2.ci para biriminden farklı ise fiyatı hesaplasın..
                                    _next_product_price_2_ =  (_next_product_price_2_ * Evaluate("_money_#_next_product_money_2_#"))/ Evaluate("_money_#system_2_money#");
									_next_product_price_kdv_2_ =  (_next_product_price_kdv_2_ * Evaluate("_money_#_next_product_money_2_#"))/ Evaluate("_money_#system_2_money#");
                                }
                                modul_ara_toplam = modul_ara_toplam + _next_product_price_2_;
                                danısmanlik_ara_toplam = danısmanlik_ara_toplam + alt_kırılım_danısmanlik_fiyatı;
                                writeoutput('
                                <td height="70" width="70" title="#_next_product_detail_2#" align="center">
                                <input name="urun_secili_#_next_stock_id_#" type="checkbox" #prod_dis_check# onClick="ara_toplam_hesapla(#_next_stock_id_#);">
                                <br/>
                                <font style="font-size:10px">#left(_next_product_name_2,20)#</font>
                                <br/>
								<input type="hidden" id="alt_urunler_values_#_next_stock_id_#" name="alt_urun_info_#_next_stock_id_#_#_next_stock_id_2_#" class="moneybox" style="width:65px;" value="#_next_stock_id_2_#█#_next_product_id_2_#█#_next_product_name_2#█#_next_product_amount_2#█#_next_product_price_2_#█#system_2_money#█#_next_is_configure_2_#█#_next_product_price_kdv_2_#█#_next_product_unit_id_2_#">
                                <input type="hidden" id="alt_urunler_#_next_stock_id_#" name="product_price_#_next_stock_id_#_#_next_stock_id_2_#" class="moneybox" style="width:65px;" value="#_next_product_price_2_#">
                                <input type="hidden" id="alt_danismanlik_#_next_stock_id_#" name="danismanlik_price_#_next_stock_id_#_#_next_stock_id_2_#" class="moneybox" style="width:65px;" value="#alt_kırılım_danısmanlik_fiyatı#">
                                <font color="red">  #tlformat(_next_product_price_2_,0)# #system_2_money#</font>
                                </td>
                            <td width="5"></td>');
                            }
                            modul_genel_toplam = modul_genel_toplam+modul_ara_toplam;
                            danısmanlik_genel_toplam = danısmanlik_genel_toplam+danısmanlik_ara_toplam;
                        writeoutput('</tr></table></td></tr>		
                        ');
                        writeoutput('
                            <tr>
                                <td>
                                    <table style="background-color:F2F2F2;width:100%;" border="0">
                                        <tr>
                                            <td width="30%" style="padding-left:15px;">
                                                <div id="modul_ara_toplam_div_#_next_stock_id_#"><b>Modül <font color="red"> : #tlformat(modul_ara_toplam)# #system_2_money#</font></b></div>
                                                <input id="ara_genel_toplam#_next_stock_id_#" name="ara_genel_toplam" type="hidden" value="#modul_ara_toplam#">
                                            </td>
                                            <td>
                                                <div id="danısmanlik_ara_toplam_div_#_next_stock_id_#"><b> Tavsiye Edilen Adam/Gün Danışmanlık <font color="red"> : #tlformat(danısmanlik_ara_toplam)# #system_2_money#</font></b></div>
                                                <input id="ara_danısmanlik_genel_toplam_#_next_stock_id_#" name="ara_danısmanlik_genel_toplam_" type="hidden" value="#danısmanlik_ara_toplam#">
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        ');
                 }
                writeoutput('</table></td></tr></table><br/>');
            }
            writeoutput('<table  align="center" width="98%" cellpadding="1" cellspacing="1" style="background-color:FE8929;margin-left:-10px;" >
                            <tr style="background-color:FFFFFF;">
                                <td>
                                    <table bordercolor="FFFFFF" cellpadding="2" cellspacing="1">
                                        <tr>
                                            <td>Toplam Lisans Fiyatı</td><td style="text-align:right;" id="modul_genel_toplam_td"><b><font color="red"> #tlformat(modul_genel_toplam)# #system_2_money#</b></font></td> 
                                            <input type="hidden" name="modul_genel_toplam" id="modul_genel_toplam" value="#modul_genel_toplam#">
                                        </tr>
                                        <tr>	
                                            <td>Tavsiye Edilen Danışmanlık Hizmet Bedeli </td>
                                            <td id="danismanlik_genel_toplam_td" align="right" ><b><font color="red">#tlformat(danısmanlik_genel_toplam)# #system_2_money#</b></font></td>
                                            <input type="hidden" name="danismanlik_genel_toplam" id="danismanlik_genel_toplam" value="#danısmanlik_genel_toplam#">
                                        </tr>
                                        <tr valign="top">
                                            <td>Toplam Proje Fiyatı </td><td id="proje_genel_toplam_td" align="right" ><b><font color="red">#tlformat(danısmanlik_genel_toplam+modul_genel_toplam)# #system_2_money#</b></font></td>
                                            <input type="hidden" name="proje_genel_toplam" id="proje_genel_toplam" value="#danısmanlik_genel_toplam+modul_genel_toplam#">
                                        </tr>
                                        <tr>
                                            <td colspan="2" align="right"><!---<input type="button" value="Kaydet" onClick="spec_conf();">---></td>
                                        </tr>	
                                    </table>
                                </td>		
                            </tr>
                        </table>');
        }
        if(len(attributes.spect_main_id))
            get_spec_conf(attributes.spect_main_id);
        else
            writeoutput('Ürüne Ait Bir Ağaç Yok!');	
    
    </cfscript>
    <input type="hidden" name="spec_row_count" id="spec_row_count" value="">
    <input type="hidden" name="stock_id_list" id="stock_id_list" value="">
    <input type="hidden" name="product_id_list" id="product_id_list" value="">
    <input type="hidden" name="product_name_list" id="product_name_list" value="">
    <input type="hidden" name="amount_list" id="amount_list" value="">
    <input type="hidden" name="is_sevk_list" id="is_sevk_list" value="">
    <input type="hidden" name="is_configure_list" id="is_configure_list" value="">
    <input type="hidden" name="is_property_list" id="is_property_list" value="">
    <input type="hidden" name="property_id_list" id="property_id_list" value="">
    <input type="hidden" name="variation_id_list" id="variation_id_list" value="">
    <input type="hidden" name="total_min_list" id="total_min_list" value="">
    <input type="hidden" name="total_max_list" id="total_max_list" value="">
    <input type="hidden" name="diff_price_list" id="diff_price_list" value="">
    <input type="hidden" name="product_price_list" id="product_price_list" value="">
    <input type="hidden" name="product_price_kdv_list" id="product_price_kdv_list" value="">
    <input type="hidden" name="product_unit_id_list" id="product_unit_id_list" value="">
    <input type="hidden" name="product_money_list" id="product_money_list" value="">
    <input type="hidden" name="tolerance_list" id="tolerance_list" value="">
    <input type="hidden" name="main_product_id" id="main_product_id" value="">
    <input type="hidden" name="main_stock_id" id="main_stock_id" value="">
    <input type="hidden" name="spec_name" id="spec_name" value="">
    <input type="hidden" name="spec_total_value" id="spec_total_value" value="">
    <input type="hidden" name="main_product_money" id="main_product_money" value="">
    <input type="hidden" name="spec_other_total_value" id="spec_other_total_value" value="">
    <input type="hidden" name="other_money" id="other_money" value="">
    <input type="hidden" name="related_spect_main_id_list" id="related_spect_main_id_list" value="">
</cfform>
<!--- <div id="denemee"></div> --->
<cfoutput>
<script language="javascript">
	var ust_urun_sayısı =document.getElementsByName('ara_genel_toplam').length;
	function ara_toplam_hesapla(ust_stok_id)
	{//ust_stok_id=>1.ci kırılımdaki ürün,alt_stok_id => 2.ci kırılmmdaki ürün. Ana ürün A,Sarf B(ust_stok_id) diyelim C(alt_stok_id)'de alttaki ürün...
		var product_price =0;
		var danismanlik_price =0;
		var alt_urun_sayısı = document.getElementsByName('alt_urunler_'+ust_stok_id).length;
		if(alt_urun_sayısı==1) var prod_obj =ust_stok_id;
		for(i=0;i<=alt_urun_sayısı-1;i++)
		{
			if(alt_urun_sayısı !=1){var prod_obj = ust_stok_id+'['+i+']';}
			if(eval('document.getElementById("urun_secili_'+prod_obj+'")').checked){//urun secili ise
				product_price+=parseFloat(eval('document.getElementById("alt_urunler_'+prod_obj+'")').value);//alt ürün yani 1.ci kırılmdaki ürünleri kendi içinde topluyoruz...
				danismanlik_price+=parseFloat(eval('document.getElementById("alt_danismanlik_'+prod_obj+'")').value);//alt ürün yani 1.ci kırılmdaki ürünleri kendi içinde topluyoruz...
			}	
		}
		eval("document.getElementById('ara_genel_toplam"+ust_stok_id+"')").value = product_price;//hidden de tuttuğumuz ara toplama atama yapıyoruz..modül fiyatı
		eval("document.getElementById('ara_danısmanlik_genel_toplam_"+ust_stok_id+"')").value = danismanlik_price;//hidden de tuttuğumuz ara toplama atama yapıyoruz..danismanlik fiyatı
		eval("document.getElementById('modul_ara_toplam_div_"+ust_stok_id+"')").innerHTML='<b>Modül <font color="red"> : '+commaSplit(product_price)+' #system_2_money#</font>';//burdada kullanıcıya gösterilmek üzere div'in içine bilgi atıyoruz.
		eval("document.getElementById('danısmanlik_ara_toplam_div_"+ust_stok_id+"')").innerHTML='<b> Tavsiye Edilen Adam/Gün Danışmanlık <font color="red"> : '+commaSplit(danismanlik_price)+' #system_2_money#</font>';//burdada kullanıcıya gösterilmek üzere danışmanlık fiyatı div'in içine atıyoru.
		genel_toplam_hesapla();
	}
	function genel_toplam_hesapla()
	{
		var main_product_price = 0;
		var main_danismanlik_price = 0;
		if(ust_urun_sayısı==1) {var m_prod_obj ='ara_genel_toplam'; var m_prod_obj_danism ='ara_danısmanlik_genel_toplam_';}
		for(x=0;x<=ust_urun_sayısı-1;x++){//ana ürünün altındaki 1.ci kırılım ürünler döndürülüyor..
				if(ust_urun_sayısı !=1){var m_prod_obj = 'ara_genel_toplam['+x+']'; var m_prod_obj_danism ='ara_danısmanlik_genel_toplam_['+x+']';}
			main_product_price += parseFloat(eval('document.getElementById("'+m_prod_obj+'")').value);//modül toplamları
			main_danismanlik_price+= parseFloat(eval('document.getElementById("'+m_prod_obj_danism'")').value);//danışmanlik toplamları
		}
		document.getElementById('modul_genel_toplam').value = parseFloat(main_product_price);
		document.getElementById('modul_genel_toplam_td').innerHTML = '<b><font color="red"> '+commaSplit(main_product_price)+' #system_2_money#</font>';
		
		document.getElementById('danismanlik_genel_toplam').value = parseFloat(main_danismanlik_price);
		document.getElementById('danismanlik_genel_toplam_td').innerHTML = '<b><font color="red"> '+commaSplit(main_danismanlik_price)+' #system_2_money#</font>';
		
		document.getElementById('proje_genel_toplam').value = parseFloat(main_product_price+main_danismanlik_price);
		document.getElementById('proje_genel_toplam_td').innerHTML = '<b><font color="red"> '+commaSplit(main_product_price+main_danismanlik_price)+' #system_2_money#</font>';
	}
	
	function spec_conf()
	{
		//document.getElementById('denemee').innerHTML='';
		var product_unit_id_list ='';
		var record_count = 0;
		var stock_id_list ='';
		var product_id_list ='';
		var product_id_list ='';
		var product_name_list='';
		var amount_list = '';
		var is_sevk_list = '';
		var is_configure_list = '';
		var is_property_list = '';
		var property_id_list = '';
		var variation_id_list ='';
		var total_min_list ='';
		var total_max_list ='';
		var diff_price_list ='';
		var product_price_list ='';
		var product_price_kdv_list ='';
		var product_money_list ='';
		var tolerance_list ='';
		var related_spect_main_id_list='';
		var line_number_list ='';
			for(y=0;y<=ust_urun_sayısı-1;y++){//ana ürünün altındaki 1.ci kırılım ürünler döndürülüyor..
			if(ust_urun_sayısı !=1){var m_prod_obj = 'ara_genel_toplam['+y+']'; var m_prod_obj_danism ='ara_danısmanlik_genel_toplam_['+y+']';}
			var ust_stok_id = list_getat(eval('document.getElementById("'+m_prod_obj_danism+'")').name,5,'_');//inputun adı ara_danısmanlik_genel_toplam_5146 gibi bir değer _ ayracını kullnarak 5.ci elemanı alınca stok_id'lere ulaşmış oluyoruz.
			var alt_urun_sayısı = document.getElementsByName('alt_urunler_'+ust_stok_id).length;
			if(alt_urun_sayısı==1) var prod_obj =ust_stok_id;
			for(i=0;i<=alt_urun_sayısı-1;i++){//ust ürünlerin içindeki ürünler yani 2.ci kırılım ürünleri.
				if(alt_urun_sayısı !=1){var prod_obj = ust_stok_id+'['+i+']';}
				if(eval('document.getElementById("urun_secili_'+prod_obj+'")').checked){//urun secili ise
					var _stock_id_ = list_getat(eval('document.getElementById("alt_urunler_values_'+prod_obj+'")').name,5,'_');
					//#_next_stock_id_2_#█#_next_product_id_2_#█#_next_product_name_2#█#_next_product_amount_2#█#_next_product_price_2_#█#system_2_money#█#_next_is_configure_2_#█#_next_product_price_kdv_2_#█#_next_product_unit_id_2_#
					var product_all_info = document.getElementById('alt_urun_info_'+ust_stok_id+'_'+_stock_id_).value;
					record_count+=1;
					amount_list += list_getat(product_all_info,4,'█')+',';//miktar  █  => alt+987
					stock_id_list +=list_getat(product_all_info,1,'█')+','
					product_id_list +=list_getat(product_all_info,2,'█')+',';
					product_name_list +=list_getat(product_all_info,3,'█')+'|@|';   
					is_sevk_list +=0+',';
					is_configure_list += list_getat(product_all_info,7,'█')+',';
					is_property_list += 0 +',';//sarf olduğu için 0 gönderiliyor
					property_id_list += 0 +',';//sarf oluğı için özelliği yok
					variation_id_list += 0 +',';//sarf olduğu için varyasyonu yok.
					total_min_list += '-' +',';//özellik olmadığı için - gönderiliyor.
					total_max_list += '-' +',';//özellik olmadığı için - gönderiliyor.
					product_price_list+=list_getat(product_all_info,5,'█')+',';//ürünün fiyatları
					product_price_kdv_list+=list_getat(product_all_info,8,'█')+',';//ürünün kdv li  fiyatları
					product_unit_id_list+=list_getat(product_all_info,9,'█')+',';//ürünün kdv li  fiyatları
					diff_price_list+=0 +',';
					product_money_list+='#system_2_money#' +',';
					tolerance_list += '-' +',';
					related_spect_main_id_list+=0 +',';
				}	
			}
		}
		var ust_miktar = 1;
		var main_product_id = '#attributes.product_id#';//Ana ürünün product id'si
		var main_stock_id = '#attributes.stock_id#';//Ana ürünün stock id'si
		var spec_name = '#attributes.spec_name#';//Ana ürünün ismi-spect_name olarak kullanıcaz
		var spec_total_value = document.getElementById('modul_genel_toplam').value;
		if(spec_total_value=='')spec_total_value = 0;
		var main_product_money = '#system_2_money#';
		var spec_other_total_value = spec_total_value;
		var other_money = '#system_2_money#';
		var spec_row_count = record_count;
		if(list_len(stock_id_list,',')-1 > 0)
		{
			document.getElementById('product_name_list').value =product_name_list; // encodeURI(product_name_list); 
			document.getElementById('spec_row_count').value = spec_row_count;
			document.getElementById('stock_id_list').value = stock_id_list;
			document.getElementById('product_id_list').value =product_id_list ;
			document.getElementById('product_name_list').value = product_name_list;
			document.getElementById('amount_list').value =amount_list ;
			document.getElementById('is_sevk_list').value =is_sevk_list ;
			document.getElementById('is_configure_list').value =is_configure_list ;
			document.getElementById('is_property_list').value =is_property_list ;
			document.getElementById('property_id_list').value =property_id_list ;
			document.getElementById('variation_id_list').value = variation_id_list;
			document.getElementById('total_min_list').value = total_min_list;
			document.getElementById('total_max_list').value =total_max_list ;
			document.getElementById('diff_price_list').value =diff_price_list ;
			document.getElementById('product_price_list').value = product_price_list;
			document.getElementById('product_unit_id_list').value = product_unit_id_list;
			document.getElementById('product_price_kdv_list').value = product_price_kdv_list;
			document.getElementById('product_money_list').value = product_money_list;
			document.getElementById('tolerance_list').value = tolerance_list;
			document.getElementById('main_product_id').value =main_product_id ;
			document.getElementById('main_stock_id').value = main_stock_id;
			document.getElementById('spec_name').value = spec_name ;
			document.getElementById('spec_total_value').value = spec_total_value;
			document.getElementById('main_product_money').value =main_product_money ;
			document.getElementById('spec_other_total_value').value = spec_other_total_value;
			document.getElementById('other_money').value = other_money;
			document.getElementById('related_spect_main_id_list').value =related_spect_main_id_list;
			document.add_production_ordel_all.submit();
		}
	}
</script>
</cfoutput>
