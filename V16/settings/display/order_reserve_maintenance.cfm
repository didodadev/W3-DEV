<!--- 
Author: Pınar Yıldız
Date: 05.09.2019
Description: Faturalaşmış siparişlerin reserve kayıtlarını silmek için bakım kodu
--->
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box> 
    <cfform name="search_form">
        <cf_box_elements>			
           <!--- <cftry>
                <cfinclude template="../../../design/template/help/reservMaintenance_#session.ep.language#.html"> --->
             <!---   <cfcatch>
                    
                </cfcatch>
            </cftry> --->
          
            <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-action_type_id">
					<div class="col col-12 col-xs-12">
                        <div class="input-group">
                        <cfset today_val = createdate(year(now()),month(now()),day(now()))>
                        <cfinput type="hidden" name="today" value="#dateformat(today_val,dateformat_style)#" validate="#validate_style#">
						<cfsavecontent variable="message"><cf_get_lang_main no ='326.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="date1" value="#attributes.date1#" validate="#validate_style#"  message="#message#" style="width:65px;">
                         <div class="input-group-addon">
                        <cf_wrk_date_image date_field="date1">
                        </div>
                        </div>
					</div>
				</div>	
                <div class="form-group" id="item-action_type_id">
					<div class="col col-12 col-xs-12">
                    <div class="input-group">
						 <cfsavecontent variable="message"><cf_get_lang_main no ='327.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="date2" value="#attributes.date2#" validate="#validate_style#"  message="#message#" style="width:65px;">
                         <div class="input-group-addon">
							<cf_wrk_date_image date_field="date2">
                        </div>
                        </div>
					</div>
				</div>	   
                <div class="form-group">
                    <div class="input-group">
                        <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">   
                        <cf_wrk_search_button button_type ="2" button_name="#getlang('main',1264,'aktar')#"  search_function="control()">
                    </div>  
                </div> 
           
           </div>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <cfinclude template="../../../design/template/help/reservMaintenance_#session.ep.language#.html"> 
            </div>
             <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">

           </div>
      </cf_box_elements>
        <cf_box_search>
    </cfform>
</cf_box >
<cf_box  title="#getLang('settings',2679,'Sipariş Rezerve Bakım Kodu')#">
<cf_grid_list sort="1">
<tbody>
    <cfif isdefined("is_form_submitted")>
        <cfform name="search_form2">
            <cfinput type="hidden" name="set_date1" value="#attributes.date1#">
            <cfinput type="hidden" name="set_date2" value="#attributes.date2#">
            <font color="red" size="2"> <cf_get_lang dictionary_id="51157.Bu işlem kapanmış rezerve kayıtlarının performans amaçlı veritabanından silinmesini sağlar"></font><br>
            <cf_wrk_search_button button_type ="2" button_name="#getlang('main',499,'Çalıştır')#">
        </cfform>
       
    </cfif>
        <cfif isdefined("attributes.set_date1")>
        <tr>
            <td>
            <cfset list_s = "">
            <cfset list_p = "">
            <cfif isdefined("attributes.set_date1") and len(attributes.set_date1)>
                <cf_date tarih="attributes.set_date1">
            </cfif>
            <cfif isdefined("attributes.set_date2") and len(attributes.set_date2)>
                <cf_date tarih="attributes.set_date2">
            </cfif>
            <!--- Sorun oluşması durumu için yedek alınır--->
            <cfquery name="get_r_s" datasource="#dsn3#">
            SELECT *
            INTO order_row_reserved_#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#
            FROM order_row_reserved
            </cfquery>
            <!--- Satış reserveleri --->
            <cfquery name="get_r_s" datasource="#dsn3#">
                select 
                    DISTINCT ORR.ORDER_ID,
                    ORR.PRODUCT_ID,
                    O.ORDER_NUMBER
                from 
                    order_row_reserved ORR 
                    JOIN ORDERS O ON ORR.ORDER_ID = O.ORDER_ID 
                WHERE
                    RESERVE_STOCK_OUT <> 0 AND
                    O.ORDER_DATE < #DateAdd('d', -90, now())#
                    <cfif isdefined("attributes.set_date1") and len(attributes.set_date2)>
                        AND O.ORDER_DATE BETWEEN #attributes.set_date1# AND  #attributes.set_date2#
                    </cfif>
            </cfquery>
            <cfif get_r_s.recordcount>
                <cftransaction>
                <cfloop query="get_r_s">
                    <cfquery name="get_r_result" datasource="#dsn3#">
                        SELECT (RESERVE_STOCK_OUT-STOCK_OUT) AS DEGER,ORDER_ID,PRODUCT_ID FROM GET_ORDER_ROW_RESERVED WHERE ORDER_ID = #get_r_s.ORDER_ID# AND PRODUCT_ID = #get_r_s.PRODUCT_ID#
                    </cfquery>
                    <cfif get_r_result.recordcount and get_r_result.DEGER eq 0>
                        <!--- kapatılmış --->
                       <!--- <cfquery name="get_P" datasource="#dsn3#">
                            SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = #get_r_s.PRODUCT_ID#
                        </cfquery>
                        <cfset list_s = listappend(list_s,'#get_r_s.ORDER_NUMBER#-#get_P.PRODUCT_NAME#<br>')> --->
                        <cfquery name="add_history" datasource="#dsn3#"><!--- History tablosuna kayıt atıyoruz --->
                            INSERT INTO STOCK_RESERVE_ARCHIVE
                            SELECT * FROM ORDER_ROW_RESERVED WHERE ORDER_ID = #get_r_result.ORDER_ID# AND  PRODUCT_ID = #get_r_result.PRODUCT_ID#
                        </cfquery>
                        <cfquery name="del_result" datasource="#dsn3#">
                            DELETE FROM ORDER_ROW_RESERVED WHERE ORDER_ID = #get_r_result.ORDER_ID# AND  PRODUCT_ID = #get_r_result.PRODUCT_ID#
                        </cfquery>
                    </cfif>
                </cfloop>
                </cftransaction>
               <!--- <cfoutput>#list_s#</cfoutput> --->
            </cfif>
            <!--- Satınalma reserveleri --->
            <cfquery name="get_r_p" datasource="#dsn3#">
                select 
                    DISTINCT ORR.ORDER_ID,
                    ORR.PRODUCT_ID,
                    O.ORDER_NUMBER
                from 
                    order_row_reserved ORR 
                    JOIN ORDERS O ON ORR.ORDER_ID = O.ORDER_ID 
                WHERE
                    RESERVE_STOCK_IN <> 0 AND
                    O.ORDER_DATE < #DateAdd('d', -90, now())#
                    <cfif isdefined("attributes.set_date1") and len(attributes.set_date2)>
                        AND O.ORDER_DATE BETWEEN #attributes.set_date1# AND  #attributes.set_date2#
                    </cfif>
            </cfquery>
            <cfif get_r_p.recordcount>
            <cftransaction>
                <cfloop query="get_r_p">
                    <cfquery name="get_r_resultp" datasource="#dsn3#">
                        SELECT (RESERVE_STOCK_IN-STOCK_IN) AS DEGER,ORDER_ID,PRODUCT_ID FROM GET_ORDER_ROW_RESERVED WHERE ORDER_ID = #get_r_p.ORDER_ID# AND PRODUCT_ID = #get_r_p.PRODUCT_ID#
                    </cfquery>
                    <cfif get_r_resultp.recordcount and get_r_resultp.DEGER eq 0>
                        <!--- kapatılmış --->
                      <!---  <cfquery name="get_P" datasource="#dsn3#">
                            SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = #get_r_s.PRODUCT_ID#
                        </cfquery>
                        <cfset list_p = listappend(list_p,'#get_r_p.ORDER_NUMBER#-#get_P.PRODUCT_NAME#<br>')>--->
                        <cfquery name="add_history" datasource="#dsn3#"><!--- History tablosuna kayıt atıyoruz --->
                            INSERT INTO STOCK_RESERVE_ARCHIVE
                            SELECT * FROM ORDER_ROW_RESERVED WHERE ORDER_ID = #get_r_resultp.ORDER_ID# AND  PRODUCT_ID = #get_r_resultp.PRODUCT_ID#
                        </cfquery>
                        <cfquery name="del_result" datasource="#dsn3#">
                            DELETE FROM ORDER_ROW_RESERVED WHERE ORDER_ID = #get_r_resultp.ORDER_ID# AND  PRODUCT_ID = #get_r_resultp.PRODUCT_ID#
                        </cfquery>
                    </cfif>
                </cfloop>
            <cfquery name="upd_Date" datasource="#dsn3#">
                UPDATE #dsn_alias#.OUR_COMPANY_INFO 
                SET STOCK_RESERVE_CLEAN_DATE = #NOW()#
                WHERE COMP_ID = #session.ep.company_id#
            </cfquery>
            </cftransaction>
              <!---  <cffile action="write" file="#file_web_path#temp" output="#list_p#"> --->
            </cfif>
             </td>
    </tr>
        </cfif>
</tbody>
</cf_grid_list>
</cf_box>
</div>
<script type="text/javascript">
    function control(){
        date1 = $("#date1").val();
        date2 = $("#date2").val();
        today = $("#today").val();
        if(date1 != '' && datediff(date1,today,0) < 90){
        	alert("<cf_get_lang dictionary_id='61219.Rezerve temizleme işlemleri 90 günden daha erken tarihli faturalar için yapılamaz'>");
            return false;
        }
        if(date2 != '' && datediff(date2,today,0) < 90){
            alert("<cf_get_lang dictionary_id='61219.Rezerve temizleme işlemleri 90 günden daha erken tarihli faturalar için yapılamaz'>");
            return false;
        }
        return true;
    }
</script>