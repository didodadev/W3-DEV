<cfset attributes.name = 1>
<!--- 
alınabilecek alanlar:
	field_id : 
	field_name :
	1-Çek 
	2-Senet
	3-Havale
	4-Açık Hesap
	5- Kredi Kart				 	
	PAYMETHOD_ID 
	PAYMETHOD                                                                                            
	DETAIL       
	arzu bt ekledi:0902/2004                                                                                                                                                                                                                                                    
	paymentdate_value:	odeme tarihi dueday eklenecek olan tarih.
	field_duedate :duedate alani
--->
<cfquery name="CARD_PAYMENT_TYPES" datasource="#DSN3#">
	SELECT  
		PAYMENT_TYPE_ID, 
		CARD_NO,
		NUMBER_OF_INSTALMENT, 
		COMMISSION_STOCK_ID,
		COMMISSION_PRODUCT_ID,
		COMMISSION_MULTIPLIER,
		POS_TYPE
	FROM  
		CREDITCARD_PAYMENT_TYPE 
	WHERE 
		IS_ACTIVE = 1
		<cfif isdefined("session.pp.userid")>
			AND IS_PARTNER = 1
		<cfelse>
			AND IS_PUBLIC = 1
		</cfif>
	ORDER BY 
		CARD_NO
</cfquery>
<cfquery name="PAYMETHODS" datasource="#DSN#">
	SELECT
		<cfif isDefined("attributes.names")>
            PAYMETHOD_ID,
            PAYMETHOD
        <cfelse>
            *
        </cfif>
	FROM
		SETUP_PAYMETHOD 
	WHERE 
		PAYMETHOD_STATUS = 1
	ORDER BY
		PAYMENT_VEHICLE,
		DUE_DAY
</cfquery>

<script type="text/javascript">
	function don(id,name,int_due,due_day,paymethod_vehicle,due_date_rate,due_month)
	{ //standart odeme yontemi bilgilerini gonderir ve tanımlıysa kredi kartı odeme yontemi inputlarını bosaltır 
		<cfif isDefined("attributes.field_id")>
			window.opener.<cfoutput>#attributes.field_id#</cfoutput>.value=id;
		</cfif>
		<cfif isDefined("attributes.field_name")>
			window.opener.<cfoutput>#attributes.field_name#</cfoutput>.value=name;
		</cfif>
		<cfif isDefined("attributes.field_duedate")>
			window.opener.<cfoutput>#attributes.field_duedate#</cfoutput>.value=int_due;
		</cfif>
		<cfif isDefined("attributes.field_dueday")>
			window.opener.<cfoutput>#attributes.field_dueday#</cfoutput>.value = due_day;
		</cfif>	
		<cfif isDefined("attributes.field_duedate_rate")>
			window.opener.<cfoutput>#attributes.field_duedate_rate#</cfoutput>.value = due_date_rate;
		</cfif>	
		<cfif isDefined("attributes.field_due_month")>
			window.opener.<cfoutput>#attributes.field_due_month#</cfoutput>.value = due_month;
		</cfif>	
		<cfif isDefined("attributes.field_paymethod_vehicle")>
			window.opener.<cfoutput>#attributes.field_paymethod_vehicle#</cfoutput>.value = paymethod_vehicle;
		</cfif>
		<cfif isDefined("attributes.field_card_payment_id")>
			window.opener.<cfoutput>#attributes.field_card_payment_id#</cfoutput>.value='';
		</cfif>
		<cfif isDefined("attributes.field_comission_stock_id")>
			window.opener.<cfoutput>#attributes.field_comission_stock_id#</cfoutput>.value='';
		</cfif>
		<cfif isDefined("attributes.field_commission_product_id")>
			window.opener.<cfoutput>#attributes.field_commission_product_id#</cfoutput>.value = '';
		</cfif>
		<cfif isDefined("attributes.field_commission_rate")>
			window.opener.<cfoutput>#attributes.field_commission_rate#</cfoutput>.value = '';
		</cfif>
		<cfif isdefined('attributes.FUNCTION_NAME')>
			<cfoutput>window.opener.#attributes.FUNCTION_NAME#();</cfoutput>
		</cfif>
		window.close();
	}
	function add_card_paymethod_info(id,name,stock_id,product_id,rate)
	{ //kredi kartı odeme yontemi bilgilerini gonderir ve tanımlıysa standart odeme yontemi inputlarını bosaltır
		<cfif isDefined("attributes.field_card_payment_id")>
			window.opener.<cfoutput>#attributes.field_card_payment_id#</cfoutput>.value=id;
		</cfif>
		<cfif isDefined("attributes.field_card_payment_name")>
			window.opener.<cfoutput>#attributes.field_card_payment_name#</cfoutput>.value=name;
		</cfif>
		<cfif isDefined("attributes.field_comission_stock_id")>
			window.opener.<cfoutput>#attributes.field_comission_stock_id#</cfoutput>.value=stock_id;
		</cfif>
		<cfif isDefined("attributes.field_commission_product_id")>
			window.opener.<cfoutput>#attributes.field_commission_product_id#</cfoutput>.value = product_id;
		</cfif>
		<cfif isDefined("attributes.field_commission_rate")>
			window.opener.<cfoutput>#attributes.field_commission_rate#</cfoutput>.value = rate;
		</cfif>
		<cfif isDefined("attributes.field_id")>
			window.opener.<cfoutput>#attributes.field_id#</cfoutput>.value='';
		</cfif>
		<cfif isDefined("attributes.field_duedate")>
			window.opener.<cfoutput>#attributes.field_duedate#</cfoutput>.value='';
		</cfif>
		<cfif isDefined("attributes.field_dueday")>
			window.opener.<cfoutput>#attributes.field_dueday#</cfoutput>.value = '';
		</cfif>
			<cfif isDefined("attributes.field_duedate_rate")>
			window.opener.<cfoutput>#attributes.field_duedate_rate#</cfoutput>.value = '';
		</cfif>	
		<cfif isDefined("attributes.field_due_month")>
			window.opener.<cfoutput>#attributes.field_due_month#</cfoutput>.value = '';
		</cfif>	
		<cfif isDefined("attributes.field_paymethod_vehicle")>
			window.opener.<cfoutput>#attributes.field_paymethod_vehicle#</cfoutput>.value = '';
		</cfif>
		<cfif isdefined('attributes.FUNCTION_NAME')>
			<cfoutput>window.opener.#attributes.FUNCTION_NAME#();</cfoutput>
		</cfif>
		window.close();
	}
</script>
<cfparam name="attributes.paymentdate_value" default="">

<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:98%; height:35px;">
  	<tr>
    	<td class="headbold"><cf_get_lang no='377.Standart Ödeme Yöntemleri'></td>
  	</tr>
</table>
<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%;">
  	<tr clasS="color-border">
		<td>
			<table cellpadding="2" cellspacing="1" border="0" style="width:100%;">
	  			<tr class="color-header" style="height:22px;">
					<!--- <td width="30" class="form-title"><cf_get_lang_main no='75.No'></td> --->
                    <td class="form-title"><cf_get_lang no ='1203.Metod'></td>
                    <td class="form-title" style="width:80px;"><cf_get_lang no='367.Vade Gün Toplam'> </td>
                    <td class="form-title" style="width:80px;"><cf_get_lang no='368.Vade Aylık'>(<cf_get_lang no='294.Taksit'>)</td>
                    <td class="form-title" style="width:80px;"><cf_get_lang no='369.Peşinat Oranı'> % </td>				
                </tr>
				<cfif len(attributes.paymentdate_value)><cf_date tarih="attributes.paymentdate_value"></cfif>	
                <cfoutput query="paymethods">
                	<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
                		<cfif len(due_day)>
							<cfif len(attributes.paymentdate_value)>
                            	<cfset new_due_date = dateformat(date_add("d",due_day,attributes.paymentdate_value),"dd/mm/yyyy")>
                            <cfelse>
                            	<cfset new_due_date = "">
                            </cfif>
                        <cfelse>
                            <cfset new_due_date = dateformat(attributes.paymentdate_value,"dd/mm/yyyy") >
                        </cfif>
						<!--- <td><a href="javascript:don('#paymethod_id#','#trim(paymethod)#','#new_due_date#','#DUE_DAY#');" class="tableyazi">#paymethod_id#</a></td> --->
                        <td><a href="javascript://" onClick="don('#paymethod_id#','#paymethod#','#new_due_date#','#due_day#','#payment_vehicle#','#due_date_rate#','#due_month#');" class="tableyazi">#paymethod#</a>
                        <cfswitch expression="#payment_vehicle#">
                            <cfcase value="1"> - <cf_get_lang_main no='595.Çek'></cfcase>
                            <cfcase value="2"> - <cf_get_lang_main no='596.Senet'></cfcase>
                            <cfcase value="3"> - <cf_get_lang no='384.Havale'></cfcase>
                            <cfcase value="4"> - <cf_get_lang no='370.Açık Hesap'></cfcase>
                            <cfcase value="5"> - <cf_get_lang no='371.Kredi Kart'></cfcase>
                            <cfcase value="6"> - <cf_get_lang_main no='1233.Nakit'></cfcase>
                        </cfswitch>
                        </td>
                        <td  style="text-align:right;">#due_day#<cfif len(due_day)><cf_get_lang_main no='78.Gün'></cfif></td>
                        <td  style="text-align:right;">#in_advance#</td>	
        				<td  style="text-align:right;">#due_date_rate#</td>	
        			</tr>
        		</cfoutput>
        	</table>
        </td>
	</tr>
</table>
<cfif card_payment_types.recordcount>
    <table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%;">
        <tr style="height:35px;">
            <td class="headbold"><cf_get_lang no='376.Kredi Kartı Ödeme Yöntemi'></td>
        </tr>
        <tr class="color-border">
            <td>
                <table cellpadding="2" cellspacing="1" border="0" style="width:100%;">
                    <tr class="color-header" style="height:22px;">
                    <td class="form-title"><cf_get_lang no ='1203.Metod'></td>
                    <td class="form-title" style="width:80px;"><cf_get_lang no='373.Taksit Sayısı'></td>
                    <td class="form-title" nowrap style="width:160px;"><cf_get_lang no='374.Hizmet Komisyon Oranı'></td>
                    <td class="form-title" nowrap style="width:60px;"><cf_get_lang no='375.Sanal POS'></td>
                </tr>
                <cfoutput query="card_payment_types">
                    <tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
                        <td><a href="javascript:add_card_paymethod_info('#payment_type_id#','#card_no#','<cfif len(commission_stock_id)>#commission_stock_id#</cfif>','<cfif len(commission_product_id)>#commission_product_id#</cfif>','<cfif len(commission_multiplier)>#commission_multiplier#</cfif>')" class="tableyazi">#card_no#</a></td>
                        <td  style="text-align:right;"><cfif len(number_of_instalment)>#number_of_instalment#<cfelse><cf_get_lang no='380.Peşin'></cfif></td>	
                        <td  style="text-align:right;"><cfif len(commission_multiplier)>%#commission_multiplier#</cfif></td>	
                        <td align="center"><cfif len(pos_type)>*</cfif></td>	
                    </tr>
                </cfoutput>
                </table>
            </td>
        </tr>
    </table>
</cfif> 
