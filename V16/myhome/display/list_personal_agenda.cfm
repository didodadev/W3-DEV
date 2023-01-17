<cf_get_lang_set module_name="myhome">
<cfinclude template="../query/my_sett.cfm">

<cf_box title="Gündem" draggable="1" closable="1" resize="0">
    <cfform action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=right" method="post" name="formGundem">
        <cfif isdefined("attributes.employee_id")>
            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">          
            </cfif>
            <div class="col col-6 col-md-12 col-sm-12">
                <div class="ui-form-list ui-form-block">
                    <div class="col col-12 box-lite-head">
                        <cf_get_lang dictionary_id='30834.Kişisel Gündem'>
                    </div> 					
                    <cfif get_module_user(1)>
                        <div class="form-group">
                            
                                <div class="col col-4">  
                                    <label>
                                        <input type="checkbox" name="myworks" id="myworks" <cfif my_sett.myworks eq 1> checked </cfif>>
                                        <cf_get_lang dictionary_id='30780.İşlerim'>
                                    </label>
                                </div>
                                <div class="col col-8"> 
                                    <select name="show_milestone" id="show_milestone">
                                        <option value="1" <cfif my_sett.show_milestone eq 1>selected</cfif>><cf_get_lang dictionary_id='30781.Milestonelar Dahil'></option>
                                        <option value="0" <cfif my_sett.show_milestone eq 0>selected</cfif>><cf_get_lang dictionary_id='30784.Milestonlar Hariç'></option>
                                    </select>
                                </div>                                                                                      
                           
                        </div>
                    </cfif>
                    <cfif get_module_user(6)> 
                        <div class="form-group">
                                                                                                               
                                <div class="col col-4">  
                                    <label>
                                        <input type="checkbox" name="day_agenda" id="day_agenda" onClick="private_agenda_display();" <cfif my_sett.day_agenda eq 1> checked</cfif>>
                                        <cf_get_lang dictionary_id='30835.Günün Ajandası'>
                                    </label>                                                    
                                </div>
                                <div class="col col-8" id="private_agenda_id" style="display:<cfif my_sett.day_agenda neq 1>none;<cfelse>;</cfif>"> 
                                    <select name="agenda_type" id="agenda_type">
                                        <option value="0"><cf_get_lang dictionary_id='30787.Network Ajandası'></option>
                                        <option value="1"<cfif my_sett.private_agenda eq 1>selected</cfif>><cf_get_lang dictionary_id='31892.Benim Ajandam'></option>
                                        <option value="2"<cfif my_sett.department_agenda eq 1>selected</cfif>><cf_get_lang dictionary_id='30809.Departman Ajandası'></option>
                                        <option value="3"<cfif my_sett.branch_agenda eq 1>selected</cfif>><cf_get_lang dictionary_id='30810.Şube Ajandası'></option>
                                    </select>
                                </div>                                                                             
                           
                        </div>
                    </cfif> 
                        <div class="form-group">
                            
                                <div class="col col-8">  
                                    <label>
                                        <input type="checkbox" name="correspondence" id="correspondence" <cfif my_sett.correspondence eq 1> checked</cfif>>
                                        <cf_get_lang dictionary_id='57459.Yazışmalar'>
                                    </label>
                                </div>                                                                                                                       
                         
                        </div> 
                        <div class="form-group">
                          
                                <div class="col col-8">  
                                    <label>
                                        <input type="checkbox" name="internaldemand" id="internaldemand" <cfif my_sett.internaldemand eq 1> checked</cfif>>
                                        <cf_get_lang dictionary_id='30782.İç Talepler'>                                                        
                                    </label>
                                </div>                                                                                                                       
                        
                        </div>
                        <div class="form-group">
                            
                                <div class="col col-8">  
                                    <label>
                                        <input type="checkbox" name="markets" id="markets" <cfif my_sett.markets eq 1> checked</cfif>>
                                        <cfsavecontent variable="piyasa"><cf_get_lang dictionary_id='30839.Piyasalar'></cfsavecontent>
                                        <cfset piyasa = '#left(piyasa,2)##lcase(mid(piyasa,3,len(piyasa)))#'>
                                        <cfoutput>#piyasa#</cfoutput>                                                       
                                    </label>
                                </div>                                                                                                                       
                          
                        </div>
                        <div class="form-group">
                            
                                <div class="col col-8">  
                                    <label>
                                        <input type="checkbox" name="correspondence" id="correspondence" <cfif my_sett.correspondence eq 1> checked</cfif>>
                                        <cf_get_lang dictionary_id='57459.Yazışmalar'>
                                    </label>
                                </div>                                                                                                                       
                            
                        </div>
                        <div class="form-group">
                            
                                <div class="col col-8">  
                                    <label><input type="checkbox" name="announcement" id="announcement" value="1" <cfif my_sett.announcement eq 1> checked</cfif>> <cf_get_lang dictionary_id='58118.Duyurular'></label>
                                </div>                                                                                                                       
                           
                        </div>
                        <div class="form-group">
                           
                                <div class="col col-8">  
                                    <label><input type="checkbox" name="notes" id="notes" value="1" <cfif my_sett.notes eq 1> checked</cfif>> <cf_get_lang dictionary_id='57422.Notlar'></label>
                                </div>                                                                                                                       
                          
                        </div>	
                        <div class="form-group">
                            
                                <div class="col col-8">  
                                    <label><input type="checkbox" name="poll_now" id="poll_now" value="1" <cfif my_sett.poll_now eq 1> checked</cfif>><cf_get_lang dictionary_id='30840.Gündemdeki Anketler'></label>
                                </div>                                                                                                                       
                            
                        </div>
                        <div class="form-group">
                           
                                <div class="col col-8">  
                                    <label><input type="checkbox" name="main_news" id="main_news" value="1" <cfif my_sett.main_news eq 1> checked</cfif>><cf_get_lang dictionary_id='30779.Workcube Taze İçerik'></label>
                                </div>                                                                                                                       
                           
                        </div>           
                        <div class="form-group">
                            
                                <div class="col col-8">  
                                    <label><input type="checkbox" name="is_kural_popup" id="is_kural_popup" value="1" <cfif my_sett.is_kural_popup eq 1> checked</cfif>><cf_get_lang dictionary_id ='32375.Kural Popupları Açılsın'></label>
                                </div>                                                                                                                       
                           
                        </div>
                        <div class="form-group">
                            
                                <div class="col col-8">  
                                    <label><input type="checkbox" name="is_kariyer" id="is_kariyer" value="1" <cfif my_sett.is_kariyer eq 1> checked</cfif>><cf_get_lang dictionary_id ='31501.Şirket İçi İş İlanları'></label>
                                </div>                                                                                                                       
                            
                        </div>
                        <div class="form-group">
                            
                                <div class="col col-8">  
                                    <label><input type="checkbox" name="is_birthdate" id="is_birthdate" value="1" <cfif my_sett.is_birthdate eq 1> checked</cfif>> <cf_get_lang dictionary_id ='57896.Doğum Günleri'></label>
                                </div>                                                                                                                       
                            
                        </div>
                        <div class="form-group">
                            
                                <div class="col col-8">  
                                    <label><input type="checkbox" name="attending_workers" id="attending_workers" value="1" <cfif my_sett.attending_workers eq 1> checked</cfif>><cf_get_lang dictionary_id ='30852.İşe Yeni Başlayanlar'></label>
                                </div>                                                                                                                       
                            
                        </div>
                        <div class="form-group">
                            
                                <div class="col col-8">  
                                    <label><input type="checkbox" name="is_permittion" id="is_permittion" value="1" <cfif my_sett.is_permittion eq 1> checked</cfif>><cf_get_lang dictionary_id ='32390.İzinliler'></label>
                                </div>                                                                                                                       
                           
                        </div>			
                        <div class="form-group">
                            
                                <div class="col col-8">  
                                    <label><input type="checkbox" name="is_video" id="is_video" value="1" <cfif my_sett.is_video eq 1> checked</cfif>><cf_get_lang dictionary_id ='31919.Videolar'></label>
                                </div>                                                                                                                       
                            
                        </div>
                        <div class="form-group">
                            
                                <div class="col col-8">  
                                    <label><input type="checkbox" name="is_forum" id="is_forum" value="1" <cfif my_sett.is_forum eq 1> checked</cfif>><cf_get_lang dictionary_id ='58128.Forumlar'></label>
                                </div>                                                                                                                       
                            
                        </div>
                        <div class="form-group">
                            
                                <div class="col col-8">  
                                    <label><input type="checkbox" name="social_media" id="social_media" value="1" <cfif my_sett.social_media eq 1> checked</cfif>><cf_get_lang dictionary_id="29529.sosyal medya"></label>
                                </div>                                                                                                                       
                          
                        </div>                                                      
                </div><!---BOX END---> 
                <cfif get_module_user(11)>
                    <div class="ui-form-list ui-form-block">					
                        <div class="col col-12 box-lite-head">
                            <cf_get_lang dictionary_id='30841.Satış Gündemi'>
                        </div> 
                            <div class="form-group">
                               
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="orders_come" id="orders_come" <cfif my_sett.orders_come eq 1> checked</cfif>><cf_get_lang dictionary_id='30842.Alinan Siparişler'></label>
                                    </div>                                                                                                                       
                                
                            </div> 
                            <div class="form-group">
                                
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="social_media" id="social_media" value="1" <cfif my_sett.social_media eq 1> checked</cfif>><cf_get_lang dictionary_id="29529.sosyal medya"></label>
                                    </div>                                                                                                                       
                               
                            </div> 
                          <!---   <div class="form-group">
                                
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="orders_come" id="orders_come" <cfif my_sett.orders_come eq 1> checked</cfif>><cf_get_lang dictionary_id='30842.Alinan Siparişler'></label>
                                    </div>                                                                                                                       
                            </div> ---> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="offer_given" id="offer_given" <cfif my_sett.offer_given eq 1> checked</cfif>><cf_get_lang dictionary_id='30785.Verilen Teklifler'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="sell_today" id="sell_today" <cfif my_sett.sell_today eq 1> checked</cfif>><cf_get_lang dictionary_id='30843.Bugünkü Satışlar (Bugünkü Satış Faturaları)'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="promo_head" id="promo_head" <cfif my_sett.promo_head eq 1> checked</cfif>><cf_get_lang dictionary_id='30844.Fırsat Başvuruları'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="most_sell_stock" id="most_sell_stock" <cfif my_sett.most_sell_stock eq 1> checked</cfif>><cf_get_lang dictionary_id='30788.En Çok Satan Ürünler'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="offer_to_give" id="offer_to_give" <cfif my_sett.offer_to_give eq 1> checked</cfif>><cf_get_lang dictionary_id='30845.Gelen Teklif İstekleri (Verilecek Teklifler)'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="new_stocks" id="new_stocks" <cfif my_sett.new_stocks eq 1> checked</cfif>><cf_get_lang dictionary_id='31486.Stoğa Yeni Gelen Ürünler'></label>
                                    </div>                                                                                                                       
                            </div>                                                                                                           
                                                                            
                    </div><!---BOX END--->                       
                </cfif>
                <cfif get_module_user(36)>                       
                    <div class="ui-form-list ui-form-block">					
                        <div class="col col-12 box-lite-head">
                            <cf_get_lang dictionary_id='30846.Finans Gündemi'>
                        </div>                                
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="pay" id="pay" <cfif my_sett.pay eq 1> checked</cfif>><cf_get_lang dictionary_id='30847.Bugün/Yarın Yapılacak Ödemeler'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="claim" id="claim" <cfif my_sett.claim eq 1> checked</cfif>><cf_get_lang dictionary_id='30848.Bugün Tahsil Edilecek Alacaklar'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="pay_claim" id="pay_claim" <cfif my_sett.pay_claim eq 1> checked</cfif>><cf_get_lang dictionary_id='30849.Borç / Alacak Son Durum (Yöneticiye Özet)'></label>
                                    </div>                                                                                                                       
                            </div>                                                                                                                     
                                                                            
                    </div><!---BOX END---> 
                </cfif>                        
                <div class="ui-form-list ui-form-block">					
                    <div class="col col-12 box-lite-head">
                        <cf_get_lang dictionary_id='30764.Raporlarım'>
                    </div>                               
                        <div class="form-group">
                                <div class="col col-8">  
                                    <label><input type="checkbox" name="report" id="report" <cfif my_sett.report eq 1> checked</cfif>><cf_get_lang dictionary_id='30764.Raporlarım'></label>
                                </div>                                                                                                                       
                        </div>                                                                                                               
                                                                        
                </div><!---BOX END--->                                                                                       
            </div>
            <div class="col col-6 col-md-12 col-sm-12">                       
                <cfif get_module_user(14)>
                     
                    <div class="ui-form-list ui-form-block">					
                        <div class="col col-12 box-lite-head">
                            <cf_get_lang dictionary_id='30857.Servis Gündemi'>
                        </div>                               
                           <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="service_head" id="service_head" <cfif my_sett.service_head eq 1> checked</cfif>><cf_get_lang dictionary_id='30039.Servis Başvuruları'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="spare_part" id="spare_part" <cfif my_sett.spare_part eq 1> checked</cfif>><cf_get_lang dictionary_id='30938.Beklenen Yedek Parçalar'></label>
                                    </div>                                                                                                                       
                            </div>                                                                                                                 
                                                                            
                    </div><!---BOX END---> 
                </cfif>
                <cfif get_module_user(27)>
                    
                    <div class="ui-form-list ui-form-block">					
                        <div class="col col-12 box-lite-head">
                            <cf_get_lang dictionary_id='30816.Call Center Gündemi'>
                        </div>                                
                           <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="call_center_application" id="call_center_application" <cfif my_sett.call_center_application eq 1> checked</cfif>><cf_get_lang dictionary_id='58468.Call Center Başvuruları'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="call_center_interaction" id="call_center_interaction" <cfif my_sett.call_center_interaction eq 1> checked</cfif>><cf_get_lang dictionary_id='30812.Call Center Etkileşimleri'></label>
                                    </div>                                                                                                                       
                            </div>                                                                                                                 
                                                                            
                    </div><!---BOX END---> 
                </cfif>
                <cfif get_module_user(3)>
                     
                    <div class="ui-form-list ui-form-block">					
                        <div class="col col-12 box-lite-head">
                            <cf_get_lang dictionary_id='30858.İK Gündemi'>
                        </div>                              
                           <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="hr" id="hr" <cfif my_sett.hr eq 1> checked</cfif>><cf_get_lang dictionary_id='30799.İK Başvuruları'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="finished_test_times" id="finished_test_times" <cfif my_sett.finished_test_times eq 1> checked</cfif>><cf_get_lang dictionary_id='31121.Deneme Süresi Bitenler'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <!--- Sozlesmesi Bitenler --->
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="sureli_is_finishdate" id="sureli_is_finishdate" <cfif my_sett.sureli_is_finishdate eq 1> checked</cfif>><cf_get_lang dictionary_id ='31989.Sözleşmesi Bitenler'></label>
                                    </div>                                                                                                                       
                            </div> 
                            
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="employee_profile" id="employee_profile"  <cfif my_sett.employee_profile eq 1> checked</cfif>><cf_get_lang dictionary_id='29499.Çalışan Profili'></label>
                                    </div>                                                                                                                       
                            </div>  
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="branch_profile" id="branch_profile"  <cfif my_sett.branch_profile eq 1> checked</cfif>><cf_get_lang dictionary_id='29505.Şube Profili'></label>
                                    </div>                                                                                                                       
                            </div>  
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="hr_agenda" id="hr_agenda"  <cfif my_sett.hr_agenda eq 1> checked</cfif>><cf_get_lang dictionary_id='57415.Ajanda'></label>
                                    </div>                                                                                                                       
                            </div>  
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="hr_in_out" id="hr_in_out"  <cfif my_sett.hr_in_out eq 1> checked</cfif>><cf_get_lang dictionary_id ='29518.Girisler ve Cikislar'></label>
                                    </div>                                                                                                                       
                            </div>   
                            <div class="form-group">
                                <div class="col col-8">  
                                    <label><input type="checkbox" name="mypdks" id="mypdks"  <cfif my_sett.hr_pdks eq 1> checked</cfif>><cf_get_lang dictionary_id='32077.Çalışma Saatlerim'>-<cf_get_lang dictionary_id='58009.PDKS'></label>
                                </div>                                                                                                                       
                        </div>                                                                                                                     
                                                                            
                    </div><!---BOX END---> 
                </cfif>
                <cfif get_module_user(15)>
                    
                    <div class="ui-form-list ui-form-block">					
                        <div class="col col-12 box-lite-head">
                            <cf_get_lang dictionary_id='30859.Kampanya Gündemi'>
                        </div>                              
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="campaign_now" id="campaign_now" <cfif my_sett.campaign_now eq 1> checked</cfif>><cf_get_lang dictionary_id='30800.Gündemdeki Kampanyalar'></label>
                                    </div>                                                                                                                       
                            </div>                                                                                                                  
                                                                            
                    </div><!---BOX END---> 
                </cfif>
                <cfif get_module_user(26)>
                    
                    <div class="ui-form-list ui-form-block">					
                        <div class="col col-12 box-lite-head">
                            <cf_get_lang dictionary_id='30860.Üretim Gündemi'>
                        </div>                              
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="product_orders" id="product_orders" <cfif my_sett.product_orders eq 1> checked</cfif>><cf_get_lang dictionary_id='30804.Üretim Emirleri'></label>
                                    </div>                                                                                                                       
                            </div>                                                                                                                
                                                                            
                    </div><!---BOX END---> 
                </cfif>
                <cfif get_module_user(17)>
                    
                    <div class="ui-form-list ui-form-block">					
                        <div class="col col-12 box-lite-head">
                            <cf_get_lang dictionary_id='57437.Anlaşmalar'>
                        </div>                               
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="old_contracts" id="old_contracts" <cfif my_sett.old_contracts eq 1> checked</cfif>><cf_get_lang dictionary_id='31089.Süresi Dolan Anlaşmalar'></label>
                                    </div>                                                                                                                       
                            </div>                                                                                                                 
                                                                            
                    </div><!---BOX END--->
                </cfif>
                <cfif get_module_user(20)>
                    
                    <div class="ui-form-list ui-form-block">					
                        <div class="col col-12 box-lite-head">
                            <cf_get_lang dictionary_id='30814.Fatura Gündemi'>
                        </div>                              
                           <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="pre_invoice" id="pre_invoice" <cfif my_sett.pre_invoice eq 1> checked</cfif>><cf_get_lang dictionary_id='30801.Kesilecek Faturalar'></label>
                                    </div>                                                                                                                       
                            </div>                                                                                                                
                                                                            
                    </div><!---BOX END--->
                </cfif> 
                <cfif get_module_user(4)>
                     
                    <div class="ui-form-list ui-form-block">					
                        <div class="col col-12 box-lite-head">
                            <cf_get_lang dictionary_id='30856.Üye Yönetimi Gündemi'>
                        </div>                             
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="pot_cons" id="pot_cons" <cfif my_sett.pot_cons eq 1> checked</cfif>><cf_get_lang dictionary_id='30797.Bireysel Üye Başvuruları'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="pot_partner" id="pot_partner" <cfif my_sett.pot_partner eq 1> checked</cfif>><cf_get_lang dictionary_id='30798.Kurumsal Üye Başvuruları'></label>
                                    </div>                                                                                                                       
                            </div>                                                                                                                 
                                                                            
                    </div><!---BOX END--->
                </cfif>   
                 <cfif get_module_user(12)>
                     
                    <div class="ui-form-list ui-form-block">					
                        <div class="col col-12 box-lite-head">
                            <cf_get_lang dictionary_id='30850.Satınalma Gündemi'>
                        </div>                             
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="orders_give" id="orders_give" <cfif my_sett.orders_give eq 1> checked</cfif>><cf_get_lang dictionary_id='30851.Verilen Siparişler'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="offer_taken" id="offer_taken" <cfif my_sett.offer_taken eq 1> checked</cfif>><cf_get_lang dictionary_id='31893.Gelen (Alınan) Teklifler'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="come_again_sip" id="come_again_sip" <cfif my_sett.come_again_sip eq 1> checked</cfif>><cf_get_lang dictionary_id='30792.Yeniden Sipariş Noktasına Gelen Ürünler'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="purchase_today" id="purchase_today" <cfif my_sett.purchase_today eq 1> checked</cfif>><cf_get_lang dictionary_id='30853.Bugünkü Alışlar (Bugünkü Alış Faturaları)'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="more_stocks_id" id="more_stocks_id" <cfif my_sett.more_stocks_id eq 1> checked</cfif>><cf_get_lang dictionary_id='30854.Fazla Stok Ürünler'></label>
                                    </div>                                                                                                                       
                            </div> 
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="send_order" id="send_order" <cfif my_sett.send_order eq 1> checked</cfif>><cf_get_lang dictionary_id='30795.Sevk Emirleri'></label>
                                    </div>                                                                                                                       
                            </div>                          
                            <div class="form-group">
                                    <div class="col col-8">  
                                        <label><input type="checkbox" name="new_product" id="new_product" <cfif my_sett.new_product eq 1> checked</cfif>><cf_get_lang dictionary_id='30796.Yeni Ürünler'></label>
                                    </div>                                                                                                                       
                            </div>                                                                                                                 
                                                                            
                    </div><!---BOX END---> 
                </cfif>    
            </div>                      
            <div id="sonuc" style="display:none"></div>	
            
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="ui-form-list-btn">
                    <div>
                        <div id="SHOW_INFO"></div>
                    </div>
                    <div>
                        <input type="button" value="<cf_get_lang dictionary_id='30819.Default Ayarlara Dön ve Güncelle'>" onClick="AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.emptypopup_settings_process&process=default','SHOW_INFO','','','',pageReload());" /> 
                    </div>
                    <div>
                        <input type="button" value="<cf_get_lang dictionary_id='57464.Güncelle'>" onClick="AjaxFormSubmit('formGundem','SHOW_INFO',1,'<cf_get_lang dictionary_id='29723.Güncelleniyor'>','<cf_get_lang dictionary_id='29724.Güncellendi'>','','',1);" />
                    </div>
                </div>
            </div>
    </cfform>
</cf_box>

<!--- <div class="modal col-8 col-md-9 col-xs-12" id="gundemModal" style="display: none;">
	<div class="modal-dialog">    
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">×</button>
                <span class="pull-right rssLabel"><a href="javascript:;" onclick="pageLoad('myhome.emptypopup_frm_add_widget')"><i class="fa fa-rss" title="RSS Widget"></i></a></span>
                <h4 class="modal-title"><cf_get_lang dictionary_id='57413.Gündem'></h4> 
            </div>
            <div class="modal-body">
            	<div class="row" id="rssContent">                
                </div>
                <cfform action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=right" method="post" name="formGundem">
            	<div class="row">
					<cfif isdefined("attributes.employee_id")>
                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">          
                    </cfif>
                    <div class="col col-6 col-md-12 col-sm-12">
                        <div class="row">
                            <div class="col col-12 box-lite-head">
                                <cf_get_lang dictionary_id='30834.Kişisel Gündem'>
                            </div> 
                            <div class="ui-form-list ui-form-block">					
                                                                           
                                    <cfif get_module_user(1)>
                                        <div class="form-group">
                                            
                                                <div class="col col-4">  
                                                    <label>
                                                        <input type="checkbox" name="myworks" id="myworks" <cfif my_sett.myworks eq 1> checked </cfif>>
                                                        <cf_get_lang dictionary_id='30780.İşlerim'>
                                                    </label>
                                                </div>
                                                <div class="col col-8"> 
                                                    <select name="show_milestone" id="show_milestone">
                                                        <option value="1" <cfif my_sett.show_milestone eq 1>selected</cfif>><cf_get_lang dictionary_id='30781.Milestonelar Dahil'></option>
                                                        <option value="0" <cfif my_sett.show_milestone eq 0>selected</cfif>><cf_get_lang dictionary_id='30784.Milestonlar Hariç'></option>
                                                    </select>
                                                </div>                                                                                      
                                           
                                        </div>
                                    </cfif>
                                    <cfif get_module_user(6)> 
                                        <div class="form-group">
                                                                                                                               
                                                <div class="col col-4">  
                                                    <label>
                                                        <input type="checkbox" name="day_agenda" id="day_agenda" onClick="private_agenda_display();" <cfif my_sett.day_agenda eq 1> checked</cfif>>
                                                        <cf_get_lang dictionary_id='30835.Günün Ajandası'>
                                                    </label>                                                    
                                                </div>
                                                <div class="col col-8" id="private_agenda_id" style="display:<cfif my_sett.day_agenda neq 1>none;<cfelse>;</cfif>"> 
                                                    <select name="agenda_type" id="agenda_type">
                                                        <option value="0"><cf_get_lang dictionary_id='30787.Network Ajandası'></option>
                                                        <option value="1"<cfif my_sett.private_agenda eq 1>selected</cfif>><cf_get_lang dictionary_id='31892.Benim Ajandam'></option>
                                                        <option value="2"<cfif my_sett.department_agenda eq 1>selected</cfif>><cf_get_lang dictionary_id='30809.Departman Ajandası'></option>
                                                        <option value="3"<cfif my_sett.branch_agenda eq 1>selected</cfif>><cf_get_lang dictionary_id='30810.Şube Ajandası'></option>
                                                    </select>
                                                </div>                                                                             
                                           
                                        </div>
                                    </cfif> 
                                        <div class="form-group">
                                            
                                                <div class="col col-8">  
                                                    <label>
                                                        <input type="checkbox" name="correspondence" id="correspondence" <cfif my_sett.correspondence eq 1> checked</cfif>>
                                                        <cf_get_lang dictionary_id='57459.Yazışmalar'>
                                                    </label>
                                                </div>                                                                                                                       
                                         
                                        </div> 
                                        <div class="form-group">
                                          
                                                <div class="col col-8">  
                                                    <label>
                                                        <input type="checkbox" name="internaldemand" id="internaldemand" <cfif my_sett.internaldemand eq 1> checked</cfif>>
                                                        <cf_get_lang dictionary_id='30782.İç Talepler'>                                                        
                                                    </label>
                                                </div>                                                                                                                       
                                        
                                        </div>
                                        <div class="form-group">
                                            
                                                <div class="col col-8">  
                                                    <label>
                                                        <input type="checkbox" name="markets" id="markets" <cfif my_sett.markets eq 1> checked</cfif>>
                                                        <cfsavecontent variable="piyasa"><cf_get_lang dictionary_id='30839.Piyasalar'></cfsavecontent>
                                                        <cfset piyasa = '#left(piyasa,2)##lcase(mid(piyasa,3,len(piyasa)))#'>
                                                        <cfoutput>#piyasa#</cfoutput>                                                       
                                                    </label>
                                                </div>                                                                                                                       
                                          
                                        </div>
                                        <div class="form-group">
                                            
                                                <div class="col col-8">  
                                                    <label>
                                                        <input type="checkbox" name="correspondence" id="correspondence" <cfif my_sett.correspondence eq 1> checked</cfif>>
                                                        <cf_get_lang dictionary_id='57459.Yazışmalar'>
                                                    </label>
                                                </div>                                                                                                                       
                                            
                                        </div>
                                        <div class="form-group">
                                            
                                                <div class="col col-8">  
                                                    <label><input type="checkbox" name="announcement" id="announcement" value="1" <cfif my_sett.announcement eq 1> checked</cfif>> <cf_get_lang dictionary_id='58118.Duyurular'></label>
                                                </div>                                                                                                                       
                                           
                                        </div>
                                        <div class="form-group">
                                           
                                                <div class="col col-8">  
                                                    <label><input type="checkbox" name="notes" id="notes" value="1" <cfif my_sett.notes eq 1> checked</cfif>> <cf_get_lang dictionary_id='57422.Notlar'></label>
                                                </div>                                                                                                                       
                                          
                                        </div>	
                                        <div class="form-group">
                                            
                                                <div class="col col-8">  
                                                    <label><input type="checkbox" name="poll_now" id="poll_now" value="1" <cfif my_sett.poll_now eq 1> checked</cfif>><cf_get_lang dictionary_id='30840.Gündemdeki Anketler'></label>
                                                </div>                                                                                                                       
                                            
                                        </div>
                                        <div class="form-group">
                                           
                                                <div class="col col-8">  
                                                    <label><input type="checkbox" name="main_news" id="main_news" value="1" <cfif my_sett.main_news eq 1> checked</cfif>><cf_get_lang dictionary_id='30779.Workcube Taze İçerik'></label>
                                                </div>                                                                                                                       
                                           
                                        </div>           
                                        <div class="form-group">
                                            
                                                <div class="col col-8">  
                                                    <label><input type="checkbox" name="is_kural_popup" id="is_kural_popup" value="1" <cfif my_sett.is_kural_popup eq 1> checked</cfif>><cf_get_lang dictionary_id ='32375.Kural Popupları Açılsın'></label>
                                                </div>                                                                                                                       
                                           
                                        </div>
                                        <div class="form-group">
                                            
                                                <div class="col col-8">  
                                                    <label><input type="checkbox" name="is_kariyer" id="is_kariyer" value="1" <cfif my_sett.is_kariyer eq 1> checked</cfif>><cf_get_lang dictionary_id ='31501.Şirket İçi İş İlanları'></label>
                                                </div>                                                                                                                       
                                            
                                        </div>
                                        <div class="form-group">
                                            
                                                <div class="col col-8">  
                                                    <label><input type="checkbox" name="is_birthdate" id="is_birthdate" value="1" <cfif my_sett.is_birthdate eq 1> checked</cfif>> <cf_get_lang dictionary_id ='57896.Doğum Günleri'></label>
                                                </div>                                                                                                                       
                                            
                                        </div>
                                        <div class="form-group">
                                            
                                                <div class="col col-8">  
                                                    <label><input type="checkbox" name="attending_workers" id="attending_workers" value="1" <cfif my_sett.attending_workers eq 1> checked</cfif>><cf_get_lang dictionary_id ='30852.İşe Yeni Başlayanlar'></label>
                                                </div>                                                                                                                       
                                            
                                        </div>
                                        <div class="form-group">
                                            
                                                <div class="col col-8">  
                                                    <label><input type="checkbox" name="is_permittion" id="is_permittion" value="1" <cfif my_sett.is_permittion eq 1> checked</cfif>><cf_get_lang dictionary_id ='32390.İzinliler'></label>
                                                </div>                                                                                                                       
                                           
                                        </div>			
                                        <div class="form-group">
                                            
                                                <div class="col col-8">  
                                                    <label><input type="checkbox" name="is_video" id="is_video" value="1" <cfif my_sett.is_video eq 1> checked</cfif>><cf_get_lang dictionary_id ='31919.Videolar'></label>
                                                </div>                                                                                                                       
                                            
                                        </div>
                                        <div class="form-group">
                                            
                                                <div class="col col-8">  
                                                    <label><input type="checkbox" name="is_forum" id="is_forum" value="1" <cfif my_sett.is_forum eq 1> checked</cfif>><cf_get_lang dictionary_id ='58128.Forumlar'></label>
                                                </div>                                                                                                                       
                                            
                                        </div>
                                        <div class="form-group">
                                            
                                                <div class="col col-8">  
                                                    <label><input type="checkbox" name="social_media" id="social_media" value="1" <cfif my_sett.social_media eq 1> checked</cfif>><cf_get_lang dictionary_id="29529.sosyal medya"></label>
                                                </div>                                                                                                                       
                                          
                                        </div>                                                                    
                                                                                    
                            </div>
                        </div><!---BOX END---> 
                        <cfif get_module_user(11)>
                        <div class="row">
                            <div class="col col-12 box-lite-head">
                                <cf_get_lang dictionary_id='30841.Satış Gündemi'>
                            </div> 
                            <div class="ui-form-list ui-form-block">					
                                
                                    <div class="form-group">
                                       
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="orders_come" id="orders_come" <cfif my_sett.orders_come eq 1> checked</cfif>><cf_get_lang dictionary_id='30842.Alinan Siparişler'></label>
                                            </div>                                                                                                                       
                                        
                                    </div> 
                                    <div class="form-group">
                                        
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="social_media" id="social_media" value="1" <cfif my_sett.social_media eq 1> checked</cfif>><cf_get_lang dictionary_id="29529.sosyal medya"></label>
                                            </div>                                                                                                                       
                                       
                                    </div> 
                                    <div class="form-group">
                                        
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="orders_come" id="orders_come" <cfif my_sett.orders_come eq 1> checked</cfif>><cf_get_lang dictionary_id='30842.Alinan Siparişler'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="offer_given" id="offer_given" <cfif my_sett.offer_given eq 1> checked</cfif>><cf_get_lang dictionary_id='30785.Verilen Teklifler'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="sell_today" id="sell_today" <cfif my_sett.sell_today eq 1> checked</cfif>><cf_get_lang dictionary_id='30843.Bugünkü Satışlar (Bugünkü Satış Faturaları)'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="promo_head" id="promo_head" <cfif my_sett.promo_head eq 1> checked</cfif>><cf_get_lang dictionary_id='30844.Fırsat Başvuruları'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="most_sell_stock" id="most_sell_stock" <cfif my_sett.most_sell_stock eq 1> checked</cfif>><cf_get_lang dictionary_id='30788.En Çok Satan Ürünler'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="offer_to_give" id="offer_to_give" <cfif my_sett.offer_to_give eq 1> checked</cfif>><cf_get_lang dictionary_id='30845.Gelen Teklif İstekleri (Verilecek Teklifler)'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="new_stocks" id="new_stocks" <cfif my_sett.new_stocks eq 1> checked</cfif>><cf_get_lang dictionary_id='31486.Stoğa Yeni Gelen Ürünler'></label>
                                            </div>                                                                                                                       
                                    </div>                                                                                                           
                                                                                    
                            </div>
                        </div><!---BOX END--->                       
                        </cfif>
                        <cfif get_module_user(36)>                       
                        <div class="row">
                            <div class="col col-12 box-lite-head">
                                <cf_get_lang dictionary_id='30846.Finans Gündemi'>
                            </div> 
                            <div class="ui-form-list ui-form-block">					
                                                                   
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="pay" id="pay" <cfif my_sett.pay eq 1> checked</cfif>><cf_get_lang dictionary_id='30847.Bugün/Yarın Yapılacak Ödemeler'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="claim" id="claim" <cfif my_sett.claim eq 1> checked</cfif>><cf_get_lang dictionary_id='30848.Bugün Tahsil Edilecek Alacaklar'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="pay_claim" id="pay_claim" <cfif my_sett.pay_claim eq 1> checked</cfif>><cf_get_lang dictionary_id='30849.Borç / Alacak Son Durum (Yöneticiye Özet)'></label>
                                            </div>                                                                                                                       
                                    </div>                                                                                                                     
                                                                                    
                            </div>
                        </div><!---BOX END---> 
                        </cfif>                        
                        <div class="row">
                            <div class="col col-12 box-lite-head">
                                <cf_get_lang dictionary_id='30764.Raporlarım'>
                            </div> 
                            <div class="ui-form-list ui-form-block">					
                                                                   
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="report" id="report" <cfif my_sett.report eq 1> checked</cfif>><cf_get_lang dictionary_id='30764.Raporlarım'></label>
                                            </div>                                                                                                                       
                                    </div>                                                                                                               
                                                                                    
                            </div>
                        </div><!---BOX END--->                                                                                       
                    </div>
                    <div class="col col-6 col-md-12 col-sm-12">                       
                        <cfif get_module_user(14)>
                        <div class="row">
                            <div class="col col-12 box-lite-head">
                                <cf_get_lang dictionary_id='30857.Servis Gündemi'>
                            </div> 
                            <div class="ui-form-list ui-form-block">					
                                                                   
                                   <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="service_head" id="service_head" <cfif my_sett.service_head eq 1> checked</cfif>><cf_get_lang dictionary_id='30039.Servis Başvuruları'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="spare_part" id="spare_part" <cfif my_sett.spare_part eq 1> checked</cfif>><cf_get_lang dictionary_id='30938.Beklenen Yedek Parçalar'></label>
                                            </div>                                                                                                                       
                                    </div>                                                                                                                 
                                                                                    
                            </div>
                        </div><!---BOX END---> 
                        </cfif>
                        <cfif get_module_user(27)>
                        <div class="row">
                            <div class="col col-12 box-lite-head">
                                <cf_get_lang dictionary_id='30816.Call Center Gündemi'>
                            </div> 
                            <div class="ui-form-list ui-form-block">					
                                                                   
                                   <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="call_center_application" id="call_center_application" <cfif my_sett.call_center_application eq 1> checked</cfif>><cf_get_lang dictionary_id='58468.Call Center Başvuruları'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="call_center_interaction" id="call_center_interaction" <cfif my_sett.call_center_interaction eq 1> checked</cfif>><cf_get_lang dictionary_id='30812.Call Center Etkileşimleri'></label>
                                            </div>                                                                                                                       
                                    </div>                                                                                                                 
                                                                                    
                            </div>
                        </div><!---BOX END---> 
                        </cfif>
                        <cfif get_module_user(3)>
                        <div class="row">
                            <div class="col col-12 box-lite-head">
                                <cf_get_lang dictionary_id='30858.İK Gündemi'>
                            </div> 
                            <div class="ui-form-list ui-form-block">					
                                                                   
                                   <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="hr" id="hr" <cfif my_sett.hr eq 1> checked</cfif>><cf_get_lang dictionary_id='30799.İK Başvuruları'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="finished_test_times" id="finished_test_times" <cfif my_sett.finished_test_times eq 1> checked</cfif>><cf_get_lang dictionary_id='31121.Deneme Süresi Bitenler'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <!--- Sozlesmesi Bitenler --->
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="sureli_is_finishdate" id="sureli_is_finishdate" <cfif my_sett.sureli_is_finishdate eq 1> checked</cfif>><cf_get_lang dictionary_id ='31989.Sözleşmesi Bitenler'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="employee_profile" id="employee_profile"  <cfif my_sett.employee_profile eq 1> checked</cfif>><cf_get_lang dictionary_id='29499.Çalışan Profili'></label>
                                            </div>                                                                                                                       
                                    </div>  
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="branch_profile" id="branch_profile"  <cfif my_sett.branch_profile eq 1> checked</cfif>><cf_get_lang dictionary_id='29505.Şube Profili'></label>
                                            </div>                                                                                                                       
                                    </div>  
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="hr_agenda" id="hr_agenda"  <cfif my_sett.hr_agenda eq 1> checked</cfif>><cf_get_lang dictionary_id='57415.Ajanda'></label>
                                            </div>                                                                                                                       
                                    </div>  
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="hr_in_out" id="hr_in_out"  <cfif my_sett.hr_in_out eq 1> checked</cfif>><cf_get_lang dictionary_id ='29518.Girisler ve Cikislar'></label>
                                            </div>                                                                                                                       
                                    </div>                                                                                                                      
                                                                                    
                            </div>
                        </div><!---BOX END---> 
                        </cfif>
                        <cfif get_module_user(15)>
                        <div class="row">
                            <div class="col col-12 box-lite-head">
                                <cf_get_lang dictionary_id='30859.Kampanya Gündemi'>
                            </div> 
                            <div class="ui-form-list ui-form-block">					
                                                                   
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="campaign_now" id="campaign_now" <cfif my_sett.campaign_now eq 1> checked</cfif>><cf_get_lang dictionary_id='30800.Gündemdeki Kampanyalar'></label>
                                            </div>                                                                                                                       
                                    </div>                                                                                                                  
                                                                                    
                            </div>
                        </div><!---BOX END---> 
                        </cfif>
                        <cfif get_module_user(26)>
                        <div class="row">
                            <div class="col col-12 box-lite-head">
                                <cf_get_lang dictionary_id='30860.Üretim Gündemi'>
                            </div> 
                            <div class="ui-form-list ui-form-block">					
                                                                   
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="product_orders" id="product_orders" <cfif my_sett.product_orders eq 1> checked</cfif>><cf_get_lang dictionary_id='30804.Üretim Emirleri'></label>
                                            </div>                                                                                                                       
                                    </div>                                                                                                                
                                                                                    
                            </div>
                        </div><!---BOX END---> 
                        </cfif>
                        <cfif get_module_user(17)>
                        <div class="row">
                            <div class="col col-12 box-lite-head">
                                <cf_get_lang dictionary_id='57437.Anlaşmalar'>
                            </div> 
                            <div class="ui-form-list ui-form-block">					
                                                                   
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="old_contracts" id="old_contracts" <cfif my_sett.old_contracts eq 1> checked</cfif>><cf_get_lang dictionary_id='31089.Süresi Dolan Anlaşmalar'></label>
                                            </div>                                                                                                                       
                                    </div>                                                                                                                 
                                                                                    
                            </div>
                        </div><!---BOX END--->
                        </cfif>
                        <cfif get_module_user(20)>
                        <div class="row">
                            <div class="col col-12 box-lite-head">
                                <cf_get_lang dictionary_id='30814.Fatura Gündemi'>
                            </div> 
                            <div class="ui-form-list ui-form-block">					
                                                                   
                                   <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="pre_invoice" id="pre_invoice" <cfif my_sett.pre_invoice eq 1> checked</cfif>><cf_get_lang dictionary_id='30801.Kesilecek Faturalar'></label>
                                            </div>                                                                                                                       
                                    </div>                                                                                                                
                                                                                    
                            </div>
                        </div><!---BOX END--->
                        </cfif> 
                        <cfif get_module_user(4)>
                        <div class="row">
                            <div class="col col-12 box-lite-head">
                                <cf_get_lang dictionary_id='30856.Üye Yönetimi Gündemi'>
                            </div> 
                            <div class="ui-form-list ui-form-block">					
                                                                   
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="pot_cons" id="pot_cons" <cfif my_sett.pot_cons eq 1> checked</cfif>><cf_get_lang dictionary_id='30797.Bireysel Üye Başvuruları'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="pot_partner" id="pot_partner" <cfif my_sett.pot_partner eq 1> checked</cfif>><cf_get_lang dictionary_id='30798.Kurumsal Üye Başvuruları'></label>
                                            </div>                                                                                                                       
                                    </div>                                                                                                                 
                                                                                    
                            </div>
                        </div><!---BOX END--->
                        </cfif>   
                         <cfif get_module_user(12)>
                        <div class="row">
                            <div class="col col-12 box-lite-head">
                                <cf_get_lang dictionary_id='30850.Satınalma Gündemi'>
                            </div> 
                            <div class="ui-form-list ui-form-block">					
                                                                   
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="orders_give" id="orders_give" <cfif my_sett.orders_give eq 1> checked</cfif>><cf_get_lang dictionary_id='30851.Verilen Siparişler'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="offer_taken" id="offer_taken" <cfif my_sett.offer_taken eq 1> checked</cfif>><cf_get_lang dictionary_id='31893.Gelen (Alınan) Teklifler'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="come_again_sip" id="come_again_sip" <cfif my_sett.come_again_sip eq 1> checked</cfif>><cf_get_lang dictionary_id='30792.Yeniden Sipariş Noktasına Gelen Ürünler'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="purchase_today" id="purchase_today" <cfif my_sett.purchase_today eq 1> checked</cfif>><cf_get_lang dictionary_id='30853.Bugünkü Alışlar (Bugünkü Alış Faturaları)'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="more_stocks_id" id="more_stocks_id" <cfif my_sett.more_stocks_id eq 1> checked</cfif>><cf_get_lang dictionary_id='30854.Fazla Stok Ürünler'></label>
                                            </div>                                                                                                                       
                                    </div> 
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="send_order" id="send_order" <cfif my_sett.send_order eq 1> checked</cfif>><cf_get_lang dictionary_id='30795.Sevk Emirleri'></label>
                                            </div>                                                                                                                       
                                    </div>                          
                                    <div class="form-group">
                                            <div class="col col-8">  
                                                <label><input type="checkbox" name="new_product" id="new_product" <cfif my_sett.new_product eq 1> checked</cfif>><cf_get_lang dictionary_id='30796.Yeni Ürünler'></label>
                                            </div>                                                                                                                       
                                    </div>                                                                                                                 
                                                                                    
                            </div>
                        </div><!---BOX END---> 
                        </cfif>    
                    </div>                      
                    <div id="sonuc" style="display:none"></div>	
                </div>
            </div>  
            <div class="modal-footer">
                 <div id="SHOW_INFO" style="float:left; margin-top:3px; width:145px"></div><input type="button" value="<cf_get_lang dictionary_id='30819.Default Ayarlara Dön ve Güncelle'>" onClick="AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.emptypopup_settings_process&process=default','SHOW_INFO','','','',pageReload());" /> <input type="button" value="<cf_get_lang dictionary_id='57464.Güncelle'>" onClick="AjaxFormSubmit('formGundem','SHOW_INFO',1,'Güncelleniyor','Güncellendi','','',1);" />
            </div>
            </cfform>
        </div>
    </div>
    <div class="modal-backdrop" style="display:none;"></div>
</div>  --->   

<script type="text/javascript">
	function private_agenda_display()
	{
		if(document.getElementById('day_agenda').checked == false)
		{
			gizle(private_agenda_id);
		}
		else if(document.getElementById('day_agenda').checked == true)
			goster(private_agenda_id);
	}
	function pageReload()
	{
		window.location = '<cfoutput>#cgi.http_referer#</cfoutput>';	
	}
	function pageLoad(page){
	 AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction='+page+'&spa=1','rssContent');
	}
</script>


