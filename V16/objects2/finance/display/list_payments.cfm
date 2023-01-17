<cfinclude template="../../login/send_login.cfm">
<cfif not isdefined('attributes.start_date')>
	<cfset attributes.start_date = date_add('d',-3,now())>
<cfelse>
	<cf_date tarih = "attributes.start_date">	
</cfif>
<cfif not isdefined('attributes.finish_date')>
	<cfset attributes.finish_date = now()>
<cfelse>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfparam name="attributes.order_info" default="">
<cfif isdefined('attributes.form_submitted')>
    <cfquery name="GET_CC_REVENUE_ACTIONS" datasource="#DSN3#">
        SELECT 
            CCBP.*,
            CCBP.ACTION_CURRENCY_ID AS ACCOUNT_CURRENCY_ID,
            CBT.CARD_NO PAYMETHOD,
            IIF(CCBP2.CREDITCARD_PAYMENT_ID IS NOT NULL,'0','1') AS CANCEL_STATUS
        FROM
            CREDIT_CARD_BANK_PAYMENTS CCBP
            LEFT JOIN CREDITCARD_PAYMENT_TYPE CBT ON CCBP.PAYMENT_TYPE_ID = CBT.PAYMENT_TYPE_ID
            LEFT JOIN CREDIT_CARD_BANK_PAYMENTS CCBP2 ON CCBP.WRK_ID = CCBP2.WRK_ID AND CCBP2.ACTION_TYPE_ID = 245
        WHERE       
            1 = 1     
            <cfif len(attributes.order_info) and attributes.order_info eq 0>
                AND CCBP.ORDER_ID IS NOT NULL
            </cfif>
            <cfif len(attributes.order_info) and attributes.order_info eq 1>
                AND CCBP.ORDER_ID IS NULL
            </cfif>
            <cfif len(attributes.order_info) and attributes.order_info eq 2>
                AND CCBP.CAMPAIGN_ID IS NOT NULL
            </cfif>
            <cfif len(attributes.order_info) and attributes.order_info eq 3>
                AND CCBP.CAMPAIGN_ID IS NULL
            </cfif>
            <cfif isDefined("session.pp")>
                AND CCBP.ACTION_FROM_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
            <cfelse>
                AND CCBP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
            </cfif>
        ORDER BY
            CREDITCARD_PAYMENT_ID DESC
    </cfquery>
<cfelse>
	<cfset get_cc_revenue_actions.recordcount = 0>
</cfif>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.action" default=''>	
<cfparam name="attributes.page" default=1>
<cfif isDefined("session.pp")>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>	
<cfelse>
	<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'>	
</cfif>
<cfparam name="attributes.totalrecords" default='#get_cc_revenue_actions.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<section id="PaymentListSearch">
    
            <cfform name="form" method="post" action="#caller.thisPage#">
                <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <div class="form-row align-items-center">                    
                    <div class="col-3 pb-2">
                        <label class="sr-only" for="order_info"></label>
                        <div class="input-group">                            
                            <select name="order_info" id="order_info" class="form-control"  style="width:155px;">
                                <option value=""><cf_get_lang_main no ='296.Tümü'></option>
                                <option value="0" <cfif attributes.order_info eq 0>selected</cfif>><cf_get_lang dictionary_id='35562.Sipariş İlişkili'></option>
                                <option value="1" <cfif attributes.order_info eq 1>selected</cfif>><cf_get_lang dictionary_id='35563.Sipariş İlişkisiz'></option>
                                <option value="2" <cfif attributes.order_info eq 2>selected</cfif>><cf_get_lang dictionary_id='35564.Kampanya İlişkili'></option>
                                <option value="3" <cfif attributes.order_info eq 3>selected</cfif>><cf_get_lang dictionary_id='48892.Kampanya İlişkisiz'></option>
                            </select>	                            
                        </div>
                    </div>
                    <div class="col-auto pb-2">
                        <label class="sr-only" for="start_date"></label>
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang no='101.Baslangiç Tarihi Girmelisiniz !'></cfsavecontent>
                            <cfinput type="text" name="start_date" id="start_date" class="form-control none-border-r" style=" width: 110px; " value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" required="yes" validate="eurodate" message="#message#">
                            <div class="input-group-text append-icon">
                                <cf_wrk_date_image date_field="start_date">
                            </div>
                        </div>
                    </div>
                    <div class="col-auto pb-2">
                        <label class="sr-only" for="finish_date"></label>
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang no='101.Baslangiç Tarihi Girmelisiniz !'></cfsavecontent>
                            <cfinput type="text" name="finish_date" id="finish_date" class="form-control none-border-r" style=" width: 110px; " value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" required="yes" validate="eurodate" message="#message#">
                            <div class="input-group-text append-icon">
                                <cf_wrk_date_image date_field="finish_date">
                            </div>
                        </div>
                    </div>
                    <div class="col-auto pb-2">
                        <label class="sr-only" for="form"></label>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" id="maxrows" class="form-control" value="#attributes.maxrows#" required="yes" validate="integer" range="1,500" message="#message#" maxlength="3" style="width:50px;">
                    </div>
                    <div class="col-auto mb-2">
                        <cf_wrk_search_button>
                    </div>
                </div>
            </cfform>
        
</section>
<section id="PaymentList">
    
        
            <cfif isDefined("session.pp")>
                <cfquery name="GET_CMP_NAME" datasource="#DSN#">
                    SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                </cfquery> 
                <h5 class="mb-4"><cfoutput>#get_cmp_name.fullname#</cfoutput> Ödemeler</h5>
            <cfelse>
                <cfquery name="GET_CONSUMER" datasource="#DSN#">
                    SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                </cfquery> 
                <h5 class="mb-4"><cfoutput>#get_consumer.consumer_name# #get_consumer.consumer_surname#</cfoutput> Ödemeler</h5>
            </cfif>
        
        		
            <div class="table-responsive">
                <table class="table">
                    <tr class="color-header main-bg-color" style="height:22px;"> 
                        <th class="form-title" style="width:20px;">No</th>
                        <th class="form-title"><cf_get_lang_main no ='330.Tarih'></th>	
                        <th class="form-title"><cf_get_lang dictionary_id='35377.İşlem Adı'></th>
                        <!---<td class="form-title"><cf_get_lang_main no ='240.Hesap'></td>--->
                        <th class="form-title"><cf_get_lang_main no='1104.Ödeme Yöntemi'></th>
                        <th class="form-title"><cf_get_lang_main no ='261.Tutar'></th>
                        <th class="form-title"><cf_get_lang dictionary_id='40324.Döviz Tutarı'></th>
                        <!--- <td style="width:15px;"><a href="javascript://" onclick="windowopen('<cfoutput><cfif use_https>#https_domain#</cfif>#request.self#</cfoutput>?fuseaction=objects2.popup_add_online_pos','medium');"><img src="/images/plus_list.gif" title="<cf_get_lang no ='375.Sanal POS'>" border="0"></a></td> --->
                        <th class="form-title" style="width:20px;"></th>
                    </tr>
                    <cfset type="">
                    <cfif get_cc_revenue_actions.recordcount>
                        <cfoutput query="get_cc_revenue_actions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr style="height:20px;">
                                <td class="color-row">#currentrow#</td>
                                <td class="color-row">#dateformat(store_report_date,"dd/mm/yyyy")#</td>
                                <td class="color-row">#action_type#</td>
                                <!---<td class="color-row">#account_branch#</td>--->
                                <td class="color-row">#paymethod#</td>
                                <td class="color-row" style="text-align:right;">#TLFormat(sales_credit)#&nbsp;#account_currency_id#</td>
                                <td class="color-row" style="text-align:right;">#TLFormat(other_cash_act_value)#&nbsp;#other_money#</td>
                            <!---  <td class="color-row"><a href="javascript://" target="" onclick="windowopen('<cfif use_https>#https_domain#</cfif>#request.self#?fuseaction=objects2.popup_add_online_pos_print&cc_id=#creditcard_payment_id#','medium');"><img src="/images/print2.gif" title="<cf_get_lang_main no='62.Yazdır'>" border="0"></a></td> --->
                                <td class="color-row">
                                    <cfif ACTION_TYPE_ID neq 245 AND CANCEL_STATUS EQ 1>
                                        <a href="javascript://" id="payment_#creditcard_payment_id#" @click="cancel_credit_order_confirm(#creditcard_payment_id#)"><i class="fas fa-credit-card text-danger" title="İptal "></i></a>
                                    </cfif>                           
                                </td>
                            </tr>
                        </cfoutput>   
                    <cfelse>
                        <tr class="color-row" style="height:20px;">
                            <td colspan="8"><cfif isdefined('attributes.form_submitted')><cf_get_lang_main no='72.Kayıt Yok'> !<cfelse><cf_get_lang_main no ='289.Filtre Ediniz'> !</cfif></td>
                        </tr>
                    </cfif>  
                </table>
            </div>
            <cfif attributes.totalrecords gt attributes.maxrows>
                <table align="center" cellpadding="0" cellspacing="0" border="0" style="width:97%; height:35px;">
                    <tr> 
                        <td>
                            <cfset adres = "#caller.thisPage#">
                            <cfif isDefined('attributes.form_submitted') and len(attributes.form_submitted)>
                                <cfset adres = "#adres#&form_submitted=#attributes.form_submitted#">
                            </cfif>
                            <cfif isDefined('attributes.order_info') and len(attributes.order_info)>
                                <cfset adres = "#adres#&order_info=#attributes.order_info#">
                            </cfif>
                            <cfif isdefined('attributes.start_date') and len(attributes.start_date)>
                                <cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
                            </cfif>
                            <cfif isdefined('attributes.finish_date') and  len(attributes.finish_date)>
                                <cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
                            </cfif>
                            <cf_pages page="#attributes.page#"
                                maxrows="#attributes.maxrows#"
                                totalrecords="#attributes.totalrecords#"
                                startrow="#attributes.startrow#"
                                adres="#adres#">
                        </td>
                        <td  style="text-align:right;"><cfoutput><cf_get_lang_main no ='128.Toplam Kayıt'>:#get_cc_revenue_actions.recordcount# -<cf_get_lang_main no ='169.Sayfa'> :#attributes.page#/#lastpage#</cfoutput></td>
                    </tr> 
                </table>
            </cfif>
        
     
    <div class="modal fade" id="confirm_cancel_cradidt_modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">İptal Onay</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <h1 class="card-title text-center text-success" v-if="response_status==true"><i class="far fa-smile"></i></h1>
                    <h1 class="card-title text-center text-danger" v-if="response_status==false"><i class="far fa-frown"></i></h1>
                    <h4 class="card-text text-center text-warning" v-if="status_icon">
                        <i class="fas fa-spinner fa-spin"></i>
                    </h4>
                    <h4 class="card-text text-center" v-else>
                        {{response_error}}
                    </h4>
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary"  data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" v-if="button_status" @click="cancel_credit_order()">Onayla</button>
                </div>
            </div>
        </div>
    </div>
</section>
<script type="text/javascript">
var proteinAppPaymentList = new Vue({
    el: '#PaymentList',
    data: {
      action_id : '',           
      response_error: '',
      response_status: null,
      button_status:true,
      status_icon : false
    },
    methods: {
        cancel_credit_order_confirm : function(id){ 
            proteinAppPaymentList.action_id = id;
            proteinAppPaymentList.response_error = id+' id li kayıt iptal edilecek';
            proteinAppPaymentList.response_status = null;
            proteinAppPaymentList.button_status =  true;
            proteinAppPaymentList.status_icon =  false;
            $('#confirm_cancel_cradidt_modal').modal('show');
            
        },
        cancel_credit_order : function(){  
            console.log(proteinAppPaymentList.action_id);
            proteinAppPaymentList.button_status =  false;
            proteinAppPaymentList.status_icon =  true;
            axios.post( "/?fuseaction=objects2.emptypopup_payment_cancellation&ajax=1", {action_id:proteinAppPaymentList.action_id})
                .then(response => {                     
                    proteinAppPaymentList.response_status = response.data.STATUS;                 
                    proteinAppPaymentList.status_icon =  false;
                    if(proteinAppPaymentList.response_status){
                        $('a#payment_'+proteinAppPaymentList.action_id).remove();
                        proteinAppPaymentList.response_error =  response.data.MSG2;                                               
                    }else{
                        proteinAppPaymentList.response_error =  response.data.ERROR;
                    }                                                           
                })
                .catch(e => {
                    alert="sistem yanıt vermiyor, daha sonra tekrar işlem yapınız."
                })  
            
        },
    },
    mounted () {  
    /* mounted */ 
    }
  })
</script>

