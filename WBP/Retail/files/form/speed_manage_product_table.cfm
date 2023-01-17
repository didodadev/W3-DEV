<cfset last_product_id = "">
<cfset product_id_list = "">
<cfset depo_ceza_query = QueryNew("DEPT_ID,STOCK_ID,PRODUCT_ID,POINT,DEPT_HEAD,TOTAL_PRODUCT,POINT_MULTIPLIER","double,double,double,double,varchar,double,double")>
<!---
<cfset price_query = QueryNew("PRICE_TYPE,STARTDATE,FINISHDATE,P_STARTDATE,P_FINISHDATE,IS_ACTIVE_A,IS_ACTIVE_S","integer,VarChar,VarChar,VarChar,VarChar,integer,integer")>
<cfset price_query_count = 0>
--->
<cfif isdefined("attributes.print_action")>
	<cfquery name="get_price_all" datasource="#dsn_dev#">
    	SELECT
        	*
        FROM
        	PRICE_TABLE
        WHERE
        	ACTION_CODE = '#attributes.ACTION_CODE#'
    </cfquery>
</cfif>


<cfset degismezler = "1,2">
	<table id="manage_table" cellpadding="2" cellspacing="1" style="<cfif not isdefined("attributes.print_action")>background:#99F;<cfelse>background:#ffffff;</cfif>">
    	<thead>
        	<cfoutput>
            <tr class="color-header" id="manage_table_header">
                <cfif not isdefined("attributes.print_action")>
                    <cfloop from="1" to="#listlen(kolon_sira)#" index="ccc">
                        <cfset mmm_ = listgetat(kolon_sira,ccc)>
                        <th style="font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif; color :##333; height:20px; <cfif listfind(hide_col_list,'kolon_#mmm_#')>display:none;</cfif>" data-header="kolon_#mmm_#" rel="kolon_#mmm_#">
                            <cfif mmm_ eq 4>
                                <div rel="is_purchase_div" style="<cfif is_purchase_type neq 0>display:none;</cfif>">A</div>
                                <div rel="is_purchase_c_div" style="<cfif is_purchase_type neq 1>display:none;</cfif>">D</div>
                                <div rel="is_purchase_m_div" style="<cfif is_purchase_type neq 2>display:none;</cfif>">M</div>
                            <cfelseif mmm_ eq 35>
                            	<div rel="is_order_koli_div">2.Birim Sipariş</div>
                                <div rel="is_order_palet_div" style="display:none;">Palet Sipariş</div>
                            <cfelseif mmm_ eq 38>
                            	<div rel="is_order2_koli_div">2.Birim Sipariş 2</div>
                                <div rel="is_order2_palet_div" style="display:none;">Palet Sipariş 2</div>
                            <cfelse>
                                <cfif not isdefined("attributes.print_action")>#mmm_#</cfif>
                                #listgetat(kolon_names_s,mmm_)#
                            </cfif>
                        </th>
                    </cfloop>
               <cfelse>
               		 <cfloop from="1" to="#listlen(kolon_sira)#" index="ccc">
                        <cfset mmm_ = listgetat(kolon_sira,ccc)>
                        <cfif not listfind(hide_col_list,'kolon_#mmm_#') and mmm_ neq 1><!--- printte 1.kolon cikmaz --->
                            <th style="font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif; color :##333; height:20px;" data-header="kolon_#mmm_#" rel="kolon_#mmm_#">
                                <cfif mmm_ eq 4>
                                    <div rel="is_purchase_div" style="<cfif is_purchase_type neq 0>display:none;</cfif>">A</div>
                                    <div rel="is_purchase_c_div" style="<cfif is_purchase_type neq 1>display:none;</cfif>">D</div>
                                    <div rel="is_purchase_m_div" style="<cfif is_purchase_type neq 2>display:none;</cfif>">M</div>
                               	<cfelseif mmm_ eq 35>
                                    <div rel="is_order_koli_div">2.Birim Sipariş</div>
                                    <div rel="is_order_palet_div" style="display:none;">Palet Sipariş</div>
                                <cfelseif mmm_ eq 38>
                                    <div rel="is_order2_koli_div">2.Birim Sipariş 2</div>
                                    <div rel="is_order2_palet_div" style="display:none;">Palet Sipariş 2</div>
                                <cfelse>
                                    <cfif not isdefined("attributes.print_action")>#mmm_#</cfif>
                                    #listgetat(kolon_names_s,mmm_)#
                                </cfif>
                            </th>
                        </cfif>
                    </cfloop>
               </cfif>
            </tr>
            </cfoutput>
       </thead>
        <tbody>
            <cfif not isdefined("attributes.print_action")>
                <tr bgcolor="66FFCC" id="manage_table_fill">
                    <cfsavecontent variable="icerik_1"><td class="form-title" rel="kolon_1" style="width:25px; height:20px;<cfif  listfind(hide_col_list,'kolon_1')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                    <cfsavecontent variable="icerik_2"><td class="form-title" rel="kolon_2" style="width:65px;<cfif  listfind(hide_col_list,'kolon_2')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_3"><td class="form-title" rel="kolon_3" style="<cfif  listfind(hide_col_list,'kolon_3')>display:none;</cfif>" nowrap>
                        <input type="checkbox" name="is_selected_all" id="is_selected_all" value="1" onclick="select_row_all();" checked/>
                        <a href="javascript://" onclick="add_del_product_name('a1');"><img src="/images/plus_small.gif" /></a>
                        <a href="javascript://" onclick="add_del_product_name('d1');"><img src="/images/delete12.gif" /></a>
                        <input type="text" id="add_del_product_name_text" name="add_del_product_name_text" value="" style="width:240px;"/> 
                        <a href="javascript://" onclick="add_del_product_name('d2');"><img src="/images/delete12.gif" /></a>
                        <a href="javascript://" onclick="add_del_product_name('a2');"><img src="/images/plus_small.gif" /></a>
                        <a href="javascript://" onclick="open_all_rows();"><img src="/images/listele_down.gif"/></a>
                    </td></cfsavecontent>
                    <cfsavecontent variable="icerik_4">
                    <td class="form-title" rel="kolon_4" style="width:35px; <cfif  listfind(hide_col_list,'kolon_4')>display:none;</cfif>" title="alt+1 Genel Alış &#13;alt+2 Depo Alış &#13;alt+3 Mağaza Alış">
                        <div rel="is_purchase_div" style="<cfif is_purchase_type neq 0>display:none;</cfif>"><input type="checkbox" name="is_all_pur" id="is_all_pur" value="1" onclick="check_all_special('is_all_pur','is_purchase_');"/></div>
                        <div rel="is_purchase_c_div" style="<cfif is_purchase_type neq 1>display:none;</cfif>"><input type="checkbox" name="is_all_pur_c" id="is_all_pur_c" value="1" onclick="check_all_special('is_all_pur_c','is_purchase_c_');"/></div>
                        <div rel="is_purchase_m_div" style="<cfif is_purchase_type neq 2>display:none;</cfif>"><input type="checkbox" name="is_all_pur_m" id="is_all_pur_m" value="1" onclick="check_all_special('is_all_pur_m','is_purchase_m_');"/></div>
                    </td>
                    </cfsavecontent>
                    <cfsavecontent variable="icerik_5"><td class="form-title" rel="kolon_5" style="width:35px; <cfif  listfind(hide_col_list,'kolon_5')>display:none;</cfif>"><input type="checkbox" name="is_all_sell" id="is_all_sell" value="1" onclick="check_all_special('is_all_sell','is_sales_');"/></td></cfsavecontent>
                    <cfsavecontent variable="icerik_7"><td class="form-title" rel="kolon_7" style="width:35px; <cfif  listfind(hide_col_list,'kolon_7')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_8"><td class="form-title" rel="kolon_8" style="<cfif listfind(hide_col_list,'kolon_8')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_45">
                    <td class="form-title" rel="kolon_45" style="width:35px; <cfif  listfind(hide_col_list,'kolon_45')>display:none;</cfif>;" nowrap>
                    	<select name="price_type_upper" id="price_type_upper">
                            <cfoutput query="get_price_types">
                                <option value="#get_price_types.type_id#">#get_price_types.TYPE_code#</option>
                            </cfoutput>
                        </select>	
                        <a href="javascript://" onclick="set_down_price_type_upper();"><img src="/images/listele_down.gif" /></a>
                    </td>
                    </cfsavecontent>
                    <cfsavecontent variable="icerik_9"><td class="form-title" rel="kolon_9" style="width:35px; <cfif  listfind(hide_col_list,'kolon_9')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_14"><td class="form-title" rel="kolon_14" style="width:25px; <cfif  listfind(hide_col_list,'kolon_14')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_15"><td class="form-title" rel="kolon_15" style="width:35px; <cfif  listfind(hide_col_list,'kolon_15')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_42"><td class="form-title" rel="kolon_42" style="width:35px; <cfif  listfind(hide_col_list,'kolon_42')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_43"><td class="form-title" rel="kolon_43" style="width:35px; <cfif  listfind(hide_col_list,'kolon_43')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_28"><td class="form-title" rel="kolon_28" style="width:35px; <cfif  listfind(hide_col_list,'kolon_28')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_29"><td class="form-title" rel="kolon_29" style="width:35px; <cfif  listfind(hide_col_list,'kolon_29')>display:none;</cfif>">
                    	<input type="checkbox" name="is_all_active_p" id="is_all_active_p" value="1" onclick="check_all_special('is_all_active_p','is_active_p_');"/>
                    </td></cfsavecontent>
                    <cfsavecontent variable="icerik_24"><td class="form-title" rel="kolon_24" style="width:50px; <cfif  listfind(hide_col_list,'kolon_24')>display:none;</cfif>" nowrap>
                        <cfinput type="text" name="p_startdate" id="p_startdate" maxlength="10" value="" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">
                        <cf_wrk_date_image date_field="p_startdate">
                        <a href="javascript://" onclick="set_down_p_startdate();"><img src="/images/listele_down.gif" /></a>
                        <input type="checkbox" name="is_sdate_all" id="is_sdate_all" value="0" />
                    </td></cfsavecontent>
                    <cfsavecontent variable="icerik_25"><td class="form-title" rel="kolon_25" style="width:50px; <cfif  listfind(hide_col_list,'kolon_25')>display:none;</cfif>" nowrap>
                        <cfinput type="text" name="p_finishdate" id="p_finishdate" maxlength="10" value="" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">
                        <cf_wrk_date_image date_field="p_finishdate">
                        <a href="javascript://" onclick="set_down_p_finishdate();"><img src="/images/listele_down.gif" /></a>
                        <input type="checkbox" name="is_fdate_all" id="is_fdate_all" value="0" />
                    </td></cfsavecontent>
                    <cfsavecontent variable="icerik_44">
                    	<td class="form-title" rel="kolon_44" style="width:35px; <cfif  listfind(hide_col_list,'kolon_44')>display:none;</cfif>" nowrap>
                        	<cfinput type="text" name="p_ss_marj_all" id="p_ss_marj_all" maxlength="10" value="" style="width:30px;" onkeyup="return(FormatCurrency(this,event,2));">	
                            <a href="javascript://" onclick="set_down_p_ss_marj();"><img src="/images/listele_down.gif" /></a>
                        </td>
                    </cfsavecontent>
                    <cfsavecontent variable="icerik_12"><td class="form-title" rel="kolon_12" style="width:35px; <cfif  listfind(hide_col_list,'kolon_12')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_19"><td class="form-title" rel="kolon_19" style="width:50px; <cfif  listfind(hide_col_list,'kolon_19')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_26"><td class="form-title" rel="kolon_26" style="text-align:left;width:50px; <cfif  listfind(hide_col_list,'kolon_26')>display:none;</cfif>">
                    <input type="checkbox" name="is_all_active_s" id="is_all_active_s" value="1" onclick="check_all_special('is_all_active_s','is_active_s_');"/>
                    </td></cfsavecontent>
                    <cfsavecontent variable="icerik_27"><td class="form-title" rel="kolon_27" style="width:50px; <cfif  listfind(hide_col_list,'kolon_27')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_46"><td class="form-title" rel="kolon_46" style="width:50px; <cfif  listfind(hide_col_list,'kolon_46')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_10"><td class="form-title" rel="kolon_10" style="<cfif  listfind(hide_col_list,'kolon_10')>display:none;</cfif>" nowrap><!--- <a href="javascript://" onclick="add_product_discount();"><img src="/images/plus_small.gif" /></a> ---></td></cfsavecontent>
                    <cfsavecontent variable="icerik_6">
                    	<td class="form-title" rel="kolon_6" style="width:35px; <cfif  listfind(hide_col_list,'kolon_6')>display:none;</cfif>" nowrap>
                        <input type="checkbox" name="is_all_active_ss" id="is_all_active_ss" value="1" onclick="check_all_special('is_all_active_ss','is_active_ss_');"/>
                    		<select name="std_round_number" id="std_round_number">
                            	<option value="5">0.05</option>
                                <option value="10">0.1</option>
                            </select>
                            <input type="button" value="Yuvarla" onclick="yuvarla_standart_satis();"/>
                    	</td>
                    </cfsavecontent>
                    <cfsavecontent variable="icerik_13"><td class="form-title" rel="kolon_13" style="width:35px; <cfif  listfind(hide_col_list,'kolon_13')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_11"><td class="form-title" rel="kolon_11" style="width:50px; <cfif  listfind(hide_col_list,'kolon_11')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_30"><td class="form-title" rel="kolon_30" style="width:50px; <cfif  listfind(hide_col_list,'kolon_30')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_31"><td class="form-title" rel="kolon_31" style="width:50px; <cfif  listfind(hide_col_list,'kolon_31')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_16"><td class="form-title" rel="kolon_16" style="width:50px; <cfif  listfind(hide_col_list,'kolon_16')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_17"><td class="form-title" rel="kolon_17" style="width:50px; <cfif  listfind(hide_col_list,'kolon_17')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_18"><td class="form-title" rel="kolon_18" style="width:50px; <cfif  listfind(hide_col_list,'kolon_18')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_33"><td class="form-title" rel="kolon_33" style="width:50px; <cfif  listfind(hide_col_list,'kolon_33')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_32"><td class="form-title" rel="kolon_32" style="width:50px; <cfif  listfind(hide_col_list,'kolon_32')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_40"><td class="form-title" rel="kolon_40" style="width:50px; <cfif  listfind(hide_col_list,'kolon_40')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_34">
                    <td class="form-title" rel="kolon_34" style="width:50px; text-align:left; <cfif  listfind(hide_col_list,'kolon_34')>display:none;</cfif>">
                    	<input type="checkbox" name="is_order_all" id="is_order_all" value="1" onclick="select_is_order_all();" <cfif isdefined("attributes.calc_type") and attributes.calc_type neq 0>checked</cfif>/>
                    </td>
                    </cfsavecontent>
                    <cfsavecontent variable="icerik_35"><td class="form-title" rel="kolon_35" style="width:50px; <cfif  listfind(hide_col_list,'kolon_35')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_36"><td class="form-title" rel="kolon_36" style="width:50px; <cfif  listfind(hide_col_list,'kolon_36')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_37">
                    <td class="form-title" rel="kolon_37" style="width:50px; text-align:left; <cfif  listfind(hide_col_list,'kolon_37')>display:none;</cfif>">
                    	<input type="checkbox" name="is_order2_all" id="is_order2_all" value="1" onclick="select_is_order2_all();" <cfif isdefined("attributes.calc_type") and attributes.calc_type neq 0>checked</cfif>/>
                    </td>
                    </cfsavecontent>
                    <cfsavecontent variable="icerik_38"><td class="form-title" rel="kolon_38" style="width:50px; <cfif  listfind(hide_col_list,'kolon_38')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_39"><td class="form-title" rel="kolon_39" style="width:50px; <cfif  listfind(hide_col_list,'kolon_39')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_41"><td class="form-title" rel="kolon_41" style="width:50px; <cfif  listfind(hide_col_list,'kolon_41')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_20"><td class="form-title" rel="kolon_20" style="width:50px; <cfif  listfind(hide_col_list,'kolon_20')>display:none;</cfif>" nowrap>
                        <cfinput type="text" name="startdate" id="startdate" maxlength="10" value="" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">
                        <cf_wrk_date_image date_field="startdate">
                        <a href="javascript://" onclick="set_down_startdate();"><img src="/images/listele_down.gif" /></a>
                    </td></cfsavecontent>
                    <cfsavecontent variable="icerik_21"><td class="form-title" rel="kolon_21" style="width:50px; <cfif  listfind(hide_col_list,'kolon_21')>display:none;</cfif>" nowrap>
                        <cfinput type="text" name="finishdate" id="finishdate" maxlength="10" value="" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">
                        <cf_wrk_date_image date_field="finishdate">
                        <a href="javascript://" onclick="set_down_finishdate();"><img src="/images/listele_down.gif" /></a>
                    </td></cfsavecontent>
                    <cfsavecontent variable="icerik_22"><td class="form-title" rel="kolon_22" style="width:50px; <cfif  listfind(hide_col_list,'kolon_22')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_23"><td class="form-title" rel="kolon_23" style="width:50px; <cfif  listfind(hide_col_list,'kolon_23')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_47"><td class="form-title" rel="kolon_47" style="width:50px; <cfif  listfind(hide_col_list,'kolon_47')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_48"><td class="form-title" rel="kolon_48" style="width:50px; <cfif  listfind(hide_col_list,'kolon_48')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_49"><td class="form-title" rel="kolon_49" style="width:50px; <cfif  listfind(hide_col_list,'kolon_49')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_50"><td class="form-title" rel="kolon_50" style="width:50px; <cfif  listfind(hide_col_list,'kolon_50')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_51"><td class="form-title" rel="kolon_51" style="width:50px; <cfif  listfind(hide_col_list,'kolon_51')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_52"><td class="form-title" rel="kolon_52" style="width:50px; <cfif  listfind(hide_col_list,'kolon_52')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_53"><td class="form-title" rel="kolon_53" style="width:50px; <cfif  listfind(hide_col_list,'kolon_53')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_54"><td class="form-title" rel="kolon_54" style="width:50px; <cfif  listfind(hide_col_list,'kolon_54')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_55"><td class="form-title" rel="kolon_55" style="width:50px; <cfif  listfind(hide_col_list,'kolon_55')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_56"><td class="form-title" rel="kolon_56" style="width:50px; <cfif  listfind(hide_col_list,'kolon_56')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_57"><td class="form-title" rel="kolon_57" style="<cfif listfind(hide_col_list,'kolon_57')>display:none;</cfif>" nowrap>&nbsp;</td></cfsavecontent>
                    <cfsavecontent variable="icerik_58"><td class="form-title" rel="kolon_58" style="width:50px; <cfif  listfind(hide_col_list,'kolon_58')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_59"><td class="form-title" rel="kolon_59" style="<cfif listfind(hide_col_list,'kolon_59')>display:none;</cfif>" nowrap>
                        <cfinput type="text" name="std_p_startdate" id="std_p_startdate" maxlength="10" value="" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">
                        <cf_wrk_date_image date_field="std_p_startdate">
                        <a href="javascript://" onclick="set_down_std_p_startdate();"><img src="/images/listele_down.gif" /></a>
                    </td>
                    </cfsavecontent>
                    <cfsavecontent variable="icerik_73"><td class="form-title" rel="kolon_73" style="<cfif listfind(hide_col_list,'kolon_73')>display:none;</cfif>" nowrap>
                        <cfinput type="text" name="std_s_startdate" id="std_s_startdate" maxlength="10" value="" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">
                        <cf_wrk_date_image date_field="std_s_startdate">
                        <a href="javascript://" onclick="set_down_std_s_startdate();"><img src="/images/listele_down.gif" /></a>
                    </td>
                    </cfsavecontent>
                    <cfsavecontent variable="icerik_60"><td class="form-title" rel="kolon_60" style="width:50px; <cfif  listfind(hide_col_list,'kolon_60')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_61"><td class="form-title" rel="kolon_61" style="width:50px; <cfif  listfind(hide_col_list,'kolon_61')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_62">
                    	<td class="form-title" rel="kolon_62" style="width:50px; <cfif  listfind(hide_col_list,'kolon_62')>display:none;</cfif>" nowrap>
                    		<cfinput type="text" name="s_profit" id="s_profit" value="" style="width:20px;">
                        	<a href="javascript://" onclick="set_down_s_profit();"><img src="/images/listele_down.gif" /></a>
                            <a href="javascript://" onclick="set_down_s_profit_real();"><img src="/images/pod_edit.gif" /></a>
                    	</td>
                    </cfsavecontent>
                    <cfsavecontent variable="icerik_63"><td class="form-title" rel="kolon_63" style="width:50px; <cfif  listfind(hide_col_list,'kolon_63')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_64"><td class="form-title" rel="kolon_64" style="width:50px; <cfif  listfind(hide_col_list,'kolon_64')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_65"><td class="form-title" rel="kolon_65" style="width:50px; <cfif  listfind(hide_col_list,'kolon_65')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_66"><td class="form-title" rel="kolon_66" style="width:50px; <cfif  listfind(hide_col_list,'kolon_66')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_67"><td class="form-title" rel="kolon_67" style="width:50px; <cfif  listfind(hide_col_list,'kolon_67')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_68"><td class="form-title" rel="kolon_68" style="width:50px; <cfif  listfind(hide_col_list,'kolon_68')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                    <cfsavecontent variable="icerik_69"><td class="form-title" rel="kolon_69" style="width:50px; <cfif  listfind(hide_col_list,'kolon_69')>display:none;</cfif>">&nbsp;</td></cfsavecontent>
                    <cfsavecontent variable="icerik_70"><td class="form-title" rel="kolon_70" style="width:50px; <cfif  listfind(hide_col_list,'kolon_70')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_71"><td class="form-title" rel="kolon_71" style="width:50px; <cfif  listfind(hide_col_list,'kolon_71')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_72"><td class="form-title" rel="kolon_72" style="width:50px; <cfif  listfind(hide_col_list,'kolon_72')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_74"><td class="form-title" rel="kolon_74" style="width:50px; <cfif  listfind(hide_col_list,'kolon_74')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_75"><td class="form-title" rel="kolon_75" style="width:50px; <cfif  listfind(hide_col_list,'kolon_75')>display:none;</cfif>"></td></cfsavecontent>
                    <cfsavecontent variable="icerik_76"><td class="form-title" rel="kolon_76" style="width:50px; <cfif  listfind(hide_col_list,'kolon_76')>display:none;</cfif>"></td></cfsavecontent>
					<cfoutput>
                        <cfloop from="1" to="#listlen(kolon_sira)#" index="ccc">
                            <cfset mmm_ = listgetat(kolon_sira,ccc)>
                            <cfif listfind(hide_col_list,'kolon_#mmm_#') and isdefined("attributes.is_only_related_areas")>
                            	<td class="form-title" rel="kolon_#mmm_#" style="width:50px;display:none;"></td>
                            <cfelse>
                            	#evaluate("icerik_#mmm_#")#
                            </cfif>
                        </cfloop>
                    </cfoutput>
                </tr>
            </cfif>
			<cfinclude template="speed_manage_product_table_rows.cfm">
        </tbody>
    </table>