<link href="/css/assets/template/select2/select2.min.css" rel="stylesheet" />
<script src="/css/assets/template/select2/select2.min.js"></script>
<cfsetting showdebugoutput="no">
<cfset _now_ = date_add('h',session.ep.TIME_ZONE,now())>
		<cfquery name="get_station_times" datasource="#dsn#">
			SELECT * FROM SETUP_SHIFTS WHERE IS_PRODUCTION = 1 AND FINISHDATE > #_now_#
		</cfquery>
		<cfset works_prog = get_station_times.SHIFT_NAME>
		<cfset works_prog_id = get_station_times.SHIFT_ID>
<cfobject name="createcomponent" component="addons.n1-soft.textile.cfc.operation_process">
    <cfscript>
                    "get_size_detail_#attributes.p_operation_id#"=createcomponent.get_operation_row_detail(
                        main_operation_id:attributes.main_operation_id,
                        p_operation_id:attributes.p_operation_id,
                        req_id:attributes.req_id,
                        operation_type_id:attributes.operation_type_id,
                        line:attributes.line
                    );
                    get_w=createcomponent.getWorkStation();
					get_w1=createcomponent.getWorkStation(local : 1);
					get_w2=createcomponent.getWorkStation(local : 2);
			</cfscript>
     
<cf_ajax_list>
    <thead>
        <tr>
            <th>Operasyon</th>
            <th>Stok Kodu</th>
            <th>Özel Kodu</th>
            <th>Stok / Asorti</th>
            <th>Planlanan Miktar</th>
            <th>Önceki Op. Miktar</th>
            <th>Gerçekleşen Op. Miktar</th>
            <th>Üretilen Miktar</th>
            <th>Kalan Miktar</th>
            <th></th>
            <th></th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_size_detail_#attributes.p_operation_id#">
            <cfif len(marj)><cfset marj_=marj><cfelse><cfset marj_=0></cfif>
            <cfset planlanan_miktar=wrk_round(ORDER_ROW_AMOUNT+(ORDER_ROW_AMOUNT*marj_/100),0)>
			<cfset gerceklesen_op_miktar=order_amount>
            <cfset uretilen_miktar=result_amount>
            <cfif this_line gt 1> 
                    <cfset oncekioperasyon_miktar=PREVIOUS_RESULT_AMOUNT>
                    <cfif oncekioperasyon_miktar gt 0>
                      <cfset kalan_miktar=oncekioperasyon_miktar-gerceklesen_op_miktar>
                    <cfelse>
                        <cfset kalan_miktar=planlanan_miktar-gerceklesen_op_miktar>    
                    </cfif>
            <cfelse>
                <cfset oncekioperasyon_miktar=0>
				<cfset kalan_miktar=planlanan_miktar-gerceklesen_op_miktar>
            </cfif>
            <tr>
                <td style="width:10px;">#operation_type#</td>
                <td style="width:10px;">#STOCK_CODE#</td>
                <td style="width:10px;">#STOCK_CODE_2#</td>
                <td style="width:350px;">#product_name# #PROPERTY#</td>
                <td style="width:10px;text-align:right;">#tlformat(planlanan_miktar)#</td>
                <td style="width:10px;text-align:right;">#tlformat(oncekioperasyon_miktar)#</td>
                <td style="width:10px;text-align:right;">#tlformat(gerceklesen_op_miktar)#</td>
                <td style="width:10px;text-align:right;">#tlformat(uretilen_miktar)#</td>
                <td style="width:10px;text-align:right;">#tlformat(kalan_miktar)#</td>
                <td style="width:10px;text-align:right;"><input type="text" style="width:15mm;text-align:right;" name="process_amount_#attributes.p_operation_id#_#currentrow#" id="process_amount_#attributes.p_operation_id#_#currentrow#" value="#tlformat(kalan_miktar)#"></td>
                <input type="hidden" name="order_row_id_#attributes.p_operation_id#_#currentrow#" id="order_row_id_#attributes.p_operation_id#_#currentrow#" value="#order_row_id#">
                <input type="hidden" name="pid_#attributes.p_operation_id#_#currentrow#" id="pid_#attributes.p_operation_id#_#currentrow#" value="#product_id#">
                <input type="hidden" name="stock_id_#attributes.p_operation_id#_#currentrow#" id="stock_id_#attributes.p_operation_id#_#currentrow#" value="#stock_id#">
                <td>
                    <cfif gerceklesen_op_miktar gt 0 and kalan_miktar lte 0>
                        <img src="/images/red_glob.gif" title="İşlem Bitti">
                    <cfelseif gerceklesen_op_miktar eq 0>
                        <img src="/images/blue_glob.gif" title="İşlem Başlamadı">  
                    <cfelseif gerceklesen_op_miktar gt 0 and kalan_miktar gt 0>
                        <img src="/images/green_glob.gif" title="İşlem Başladı">
                    </cfif>
                </td>
                    <!---cfif IS_STAGE eq 4>
                            <cfif IS_GROUP_LOT eq 1>
                                 <img src="/images/g_blue_glob.gif" title="<cf_get_lang no ='579.Gruplandı Fakat Operatöre Gönderilmedi'>">
                            <cfelse>
                                 <img src="/images/blue_glob.gif" title="<cf_get_lang no ='270.Başlamadı'>">
                            </cfif>       
                        <cfelseif IS_STAGE eq 0>
                            <img src="/images/yellow_glob.gif" title="<cf_get_lang no ='578.Operatöre Gönderildi'>">
                        <cfelseif IS_STAGE eq 1>
                            <img src="/images/green_glob.gif" title="<cf_get_lang no ='577.Başladı'>">
                        <cfelseif IS_STAGE eq 2>
                            ">
                        <cfelseif IS_STAGE eq 3>
                            <img src="/images/grey_glob.gif" title="<cf_get_lang no ='580.Üretim Durdu(Arıza)'>">
                      </cfif>--->
                  
            </tr>
        </cfoutput>
    </tbody>
    <cfoutput>
            <tfoot>
                <tr>
                    <td colspan="12" style="text-align:right;" align="right" valign="right">
                        <table border="0" >
                            <tr>
                              
                                <td style="width:25mm;"> <cf_get_lang_main no ='70.Aşama'> : <cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0'></td>
                                <td>Fason/Local
									<select name="fason" style="width:100px;" onchange="ChangeIstasyon(this.value);">
										<option value="">..Seçiniz..</option>
										<option value="1">Fason</option>
										<option value="2">Local</option>
									</select>
								</td>
                                <td id="all">İstasyon
                                    <select class="js-example-basic-single" name="station_id_#attributes.p_operation_id#" id="station_id_#attributes.p_operation_id#" style="width:180px;">
                                        <option value="">...Seçiniz...</option>
										<cfloop query="get_w">
                                            <option value="#station_id#,0,0,0,-1,#EXIT_DEP_ID#,#EXIT_LOC_ID#,#PRODUCTION_DEP_ID#,#PRODUCTION_LOC_ID#">#station_name#</option>
                                        </cfloop>
                                    </select>
                                </td>
								<td id="fason" style="display:none;">İstasyon
                                    <select class="js-example-basic-single" name="station_id_#attributes.p_operation_id#" id="station_id_#attributes.p_operation_id#" style="width:180px;">
                                        <option value="">...Seçiniz...</option>
										<cfloop query="get_w1">
                                            <option value="#station_id#,0,0,0,-1,#EXIT_DEP_ID#,#EXIT_LOC_ID#,#PRODUCTION_DEP_ID#,#PRODUCTION_LOC_ID#">#station_name#</option>
                                        </cfloop>
                                    </select>
                                </td>
								<td id="local" style="display:none;">İstasyon
                                    <select class="js-example-basic-single" name="station_id_#attributes.p_operation_id#" id="station_id_#attributes.p_operation_id#" style="width:180px;">
                                        <option value="">...Seçiniz...</option>
										<cfloop query="get_w2">
                                            <option value="#station_id#,0,0,0,-1,#EXIT_DEP_ID#,#EXIT_LOC_ID#,#PRODUCTION_DEP_ID#,#PRODUCTION_LOC_ID#">#station_name#</option>
                                        </cfloop>
                                    </select>
                                </td>
                                <td nowrap width="140" valign="top">
                                    Vardiya
                                    <div class="nohover_div">
                                        <input type="text" name="work_prog_#attributes.p_operation_id#" id="work_prog_#attributes.p_operation_id#" readonly value="#works_prog#" style="width:120px;">
                                        <input type="hidden" name="work_prog_id_#attributes.p_operation_id#" id="work_prog_id_#attributes.p_operation_id#" value="">
                                        <a href="javascript://" onClick="goster(open_works_prog_#attributes.p_operation_id#);AjaxPageLoad('#request.self#?fuseaction=prod.popup_list_work_prog&rows=#attributes.p_operation_id#&divId=open_works_prog_#attributes.p_operation_id#&fieldName=work_prog_#attributes.p_operation_id#&fieldId=work_prog_id_#attributes.p_operation_id#','open_works_prog_#attributes.p_operation_id#',1);"><img src="/images/plus_thin.gif" border="0" align="absbottom" /></a>
                                        <div style="position:absolute; margin-left:-150px; margin-top:10px; vertical-align:top;" id="open_works_prog_#attributes.p_operation_id#"></div>
                                    </div>
                                </td>
                                <td nowrap>Hedef Başlangıç Tarihi
                                    <input maxlength="10" type="text" id="production_start_date_#attributes.p_operation_id#" name="production_start_date_#attributes.p_operation_id#"  validate="#validate_style#" style="width:65px;" value="#dateformat(now(),dateformat_style)#">
                                    <cf_wrk_date_image date_field="production_start_date_#attributes.p_operation_id#">
                                    <cf_wrkTimeFormat  name="production_start_h_#attributes.p_operation_id#" id="production_start_h_#attributes.p_operation_id#" value="#TimeFormat(now(),'HH')#">	
                                    <select name="production_start_m_#attributes.p_operation_id#" id="production_start_m_#attributes.p_operation_id#">
                                        <cfloop from="0" to="59" index="i">
                                            <option value="#i#" <cfif TimeFormat(now(),'MM') eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                        </cfloop>
                                    </select>
                                </td>
                                <td nowrap>Hedef Bitiş Tarihi
                                    <input maxlength="10" type="text" id="production_finish_date_#attributes.p_operation_id#" name="production_finish_date_#attributes.p_operation_id#"  validate="#validate_style#" style="width:65px;" value="#dateformat(now(),dateformat_style)#">
                                    <cf_wrk_date_image date_field="production_finish_date_#attributes.p_operation_id#">
                                    <cf_wrkTimeFormat  name="production_finish_h_#attributes.p_operation_id#" id="production_finish_h_#attributes.p_operation_id#" value="#TimeFormat(now(),'HH')#">	
                                    <select name="production_finish_m_#attributes.p_operation_id#" id="production_finish_m_#attributes.p_operation_id#">
                                        <cfloop from="0" to="59" index="i">
                                            <option value="#i#" <cfif TimeFormat(now(),'MM') eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                        </cfloop>
                                    </select>
                                </td>
                                <td><button type="button" class="btn btn-success " id="send_prod#attributes.p_operation_id#">Üretim Emri Oluştur</button></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </tfoot>
    </cfoutput>
</cf_ajax_list>
<cfform name="addprod_#attributes.p_operation_id#" id="addprod_#attributes.p_operation_id#" method="post" action="#request.self#?fuseaction=textile.emptypopup_operation_to_prod" target="_blank">
    <input type="hidden" name="main_operation_id" value="<cfoutput>#attributes.main_operation_id#</cfoutput>">
    <input type="hidden" name="p_operation_id" value="<cfoutput>#attributes.p_operation_id#</cfoutput>">
    <input type="hidden" name="previous_operation_type_id" value="<cfoutput>#evaluate("get_size_detail_#attributes.p_operation_id#.PREVIOUS_OPERATION_TYPE_ID")#</cfoutput>">
    <input type="hidden" name="order_id" value="<cfoutput>#attributes.order_id#</cfoutput>">
    <input type="hidden" name="req_id" value="<cfoutput>#attributes.req_id#</cfoutput>">
    <input type="hidden" name="operation_type_id" value="<cfoutput>#attributes.operation_type_id#</cfoutput>">
    <input type="hidden" name="operation_type" value="<cfoutput>#evaluate("get_size_detail_#attributes.p_operation_id#.operation_type")#</cfoutput>">
    <input type="hidden" name="orderrowids" id="orderrowids" value="">
    <input type="hidden" name="stockids" id="stockids" value="">
    <input type="hidden" name="processamounts" id="processamounts" value="">
    <input type="hidden" name="production_start_date" id="production_start_date" value="">
    <input type="hidden" name="production_finish_date" id="production_finish_date" value="">
    <input type="hidden" name="production_start_m" id="production_start_m" value="">
    <input type="hidden" name="production_finish_m" id="production_finish_m" value="">
    <input type="hidden" name="production_start_h" id="production_start_h" value="">
    <input type="hidden" name="production_finish_h" id="production_finish_h" value="">
    <input type="hidden" name="station_id" id="station_id" value="">
    <input type="hidden" name="process_stage_" id="process_stage_" value="">
    <input type="hidden" name="pid" id="pid" value="">
</cfform>

<script>
$(document).ready(function() {
    $('.js-example-basic-single').select2();
});
    var mainoperationid='<cfoutput>#attributes.p_operation_id#</cfoutput>';
    var rowcount='<cfoutput>#evaluate("get_size_detail_#attributes.p_operation_id#.recordcount")#</cfoutput>';
        $("#send_prod"+mainoperationid).click(function()
            {
                var orderrowidlist="";
                var processamountlist="";
                var stockidlist="";
                var pid=""; $("#pid_"+mainoperationid).val();
                   for(var i=1;i<=rowcount;i++)
                   {
                       miktar=$("#process_amount_"+mainoperationid+'_'+i).val();
                       miktar=filterNum(miktar);
                        if(parseFloat(miktar)>0)
                        {
                            orderrowidlist+=$("#order_row_id_"+mainoperationid+'_'+i).val()+',';
                            processamountlist+=miktar+',';
                            stockidlist+=$("#stock_id_"+mainoperationid+'_'+i).val()+',';
                            pid=$("#pid_"+mainoperationid+'_'+i).val();
                        }
                   }
                   if(orderrowidlist=='')
                   {
                       alert('İşlem Yapılabilecek Operasyon Miktarı Bulunamadı!');
                       return false;
                   }

                   $("#addprod_"+mainoperationid+" #orderrowids").val(orderrowidlist);
                   $("#addprod_"+mainoperationid+" #processamounts").val(processamountlist);
                   $("#addprod_"+mainoperationid+" #stockids").val(stockidlist);
                   var psdate= $("#production_start_date_"+mainoperationid).val();
                   var pfdate= $("#production_finish_date_"+mainoperationid).val();
                   var psmdate= $("#production_start_m_"+mainoperationid).val();
                   var pfmdate= $("#production_finish_m_"+mainoperationid).val();
                   var pshdate= $("#production_start_h_"+mainoperationid).val();
                   var pfhdate= $("#production_finish_h_"+mainoperationid).val();
                   var stationid= $("#station_id_"+mainoperationid).val();
                   if(stationid ==''){
					alert("İstasyon Seçiniz");
					return false;
				   }
                   var stage_id= $("#process_stage").val();
                   $("#addprod_"+mainoperationid+" #production_start_date").val(psdate);
                   $("#addprod_"+mainoperationid+" #production_finish_date").val(pfdate);
                   $("#addprod_"+mainoperationid+" #production_start_m").val(psmdate);
                   $("#addprod_"+mainoperationid+" #production_finish_m").val(pfmdate);
                   $("#addprod_"+mainoperationid+" #production_start_h").val(pshdate);
                   $("#addprod_"+mainoperationid+" #production_finish_h").val(pfhdate);
                   $("#addprod_"+mainoperationid+" #station_id").val(stationid);
                   $("#addprod_"+mainoperationid+" #process_stage_").val(stage_id);
                   $("#addprod_"+mainoperationid+" #pid").val(pid); 
                   $("#addprod_"+mainoperationid).submit();

                    
            }
        );
	function ChangeIstasyon(val){
		if(val == 1) 
		{
			$("#fason").css({display:""});
			$("#all").css({display:"none"});
			$("#local").css({display:"none"});
		}
		else if(val == 2){
			$("#local").css({display:""});
			$("#all").css({display:"none"});
			$("#fason").css({display:"none"});
		}
		else{
			$("#local").css({display:"none"});
			$("#fason").css({display:"none"});
			$("#all").css({display:""});
		}
	}
	
	</script>