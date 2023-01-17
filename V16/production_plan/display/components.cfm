<cf_xml_page_edit fuseact ="prod.add_product_tree" default_value="0">
<cfset getComponent = createObject('component','V16.production_plan.cfc.get_tree')>
<cfset GET_PRO_TREE_ID = getComponent.GET_PRO_TREE_ID(stock_id : attributes.stock_id)>
<cfinclude template="../query/get_product_info.cfm">
<cfif not isDefined("attributes.product_id")><cfset attributes.product_id = get_product.product_id></cfif>
<cfform name="add_versiyon" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_spect_main_versiyon#xml_str#">
    <cf_basket style="width:100%;">
        <div id="SHOW_PRODUCT_TREE"></div>
        <script type="text/javascript">
            $( document ).ready(function() {
            AjaxPageLoad('<cfoutput>#request.self#?fuseaction=prod.emptypopupajax_function_product_tree&pro_tree_id=#attributes._product_tree_id_#&stock_id=#attributes.stock_id#<cfif isdefined("attributes.main_stock_id")>&main_stock_id=#attributes.main_stock_id#</cfif>&is_used_rate=#attributes.is_used_rate#</cfoutput>','SHOW_PRODUCT_TREE',1);
            });
        </script>
        <cf_basket_footer height="40">
            <table width="100%">
                <tr>
                   <td>
                   <input type="hidden" name="pro_tree_id" value="<cfoutput>#attributes._product_tree_id_#</cfoutput>">
                    <cfif isdefined("attributes.main_stock_id")>
                        <input type="hidden" name="main_stock_id" value="<cfoutput>#attributes.main_stock_id#</cfoutput>">
                    </cfif>
                    <input type="hidden" name="is_show_line_number" id="is_show_line_number" value="<cfoutput>#attributes.is_line_number#</cfoutput>">
                    <input type="hidden" name="operation_tree_id_list" id="operation_tree_id_list" value=""><!--- Kaldırmayın ajax ile açılan sayfadan doldurulur.. --->
                    <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
                    <input type="hidden" name="old_main_spec_id" id="old_main_spec_id" value="<cfoutput>#old_main_spec_id#</cfoutput>">
                    <input type="hidden" name="is_used_rate" id="is_used_rate" value="<cfoutput>#attributes.is_used_rate#</cfoutput>">
                  
                   
                    <cf_record_info query_name="GET_PRO_TREE_ID">
                    </td>
                    <td>
                        <div class="ui-form-list flex-list flex-end">
                            <cfif GET_PRO_TREE_ID.recordcount>
                                <div class="form-group" style="padding:0 5px 0 0;">
                                    <label><cf_get_lang dictionary_id="58859.Süreç"></label>
                                    <cf_workcube_process is_upd='0' process_cat_width='120' is_detail='1' select_value='#GET_PRO_TREE_ID.process_stage#' fuseaction="#attributes.fuseaction_#">
                                </div>
                            <cfelse>
                                <div class="form-group" style="padding:0 5px 0 0;">
                                    <label><cf_get_lang dictionary_id="58859.Süreç"></label>
                                    <cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0' fuseaction="#attributes.fuseaction_#">
                                </div>
                            </cfif>
                           
                        <!--- Eğer ürün ağacından üretilmiş bir numune yoksa. --->
                            <cfif attributes.fuseaction_ eq 'prod.list_product_tree'>
                                <div id="div_product_numune" >
                                    <div class="form-group" style="padding:0 5px 0 0;">
                                        <a href="javascript://" class="ui-ripple-btn btn-success" style="margin:1px 0px 1px 0px;"onclick="sample()"><cf_get_lang dictionary_id='65252.Ağacı Numuneye Dönüştür'></a>
                                    </div>
                                </div>
                            </cfif>
                           
                            <cfif not GET_PRO_TREE_ID.recordcount><!--- Eğer ürüne ait oluşturulmuş bir Ağaç Yoksa.. --->
                                <div id="div_product_copy" style="position:absolute; margin-left:-200px;" ></div>
                                <div class="form-group" style="padding:0 5px 0 0;">
                                    <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left" onClick="kontrol_process_2()"><cf_get_lang dictionary_id ='36622.Ağaç Kopyala'></a>
                                </div>
                                <script type="text/javascript">
                                    function copy_product_func(stock_id)
                                    {
                                        if(process_cat_control())
                                            AjaxPageLoad('<cfoutput>#request.self#?fuseaction=prod.emptypopup_copy_product_tree&process_stage_='+add_versiyon.process_stage.value+'&FROM_STOCK_ID='+stock_id+'&to_stock_id=#attributes.stock_id#</cfoutput>','div_product_copy',1)
                                    }
                                </script>
                            </cfif>
                                <div class="form-group" style="padding:0 5px 0 0;">
                                    <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_documenter&module=SHOW_PRODUCT_TREE','small','popup_documenter');"><i class="fa fa-file-excel-o"></i><cf_get_lang dictionary_id ='57858.Excel Getir'></a>
                                </div>
                                <cfif _product_tree_id_ eq 0><!--- Eğer ürün ise bir ağacı olur ve bu şekilde spec kaydedilir...Eğer operasyon ise ağacı kaydet diye birşeyin gelmesine gerek yok... --->
                                <cfif isdefined("is_show_product_del") and is_show_product_del eq 1>
                                    <div class="form-group" style="padding:0 5px 0 0;">
                                        <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-red ui-wrk-btn-addon-left" onClick="kontrol_process_3()"><i class="fa fa-trash"></i><cf_get_lang dictionary_id ='36358.Ağacı Temizle'></a>
                                    </div>
                                </cfif>
                                <div class="form-group">
                                    <input class="ui-wrk-btn ui-wrk-btn-success"  type="button" value="<cf_get_lang dictionary_id ='57461.Ağacı Kaydet'>" onclick="kontrol_process()">
                                </div>
                            </cfif> 
                        </div>
                    </td>
                </tr>
           </table>
        </cf_basket_footer>
    </cf_basket>
</cfform>  
    <div   style="display:none;  min-width: 50%;" class="ui-cfmodal ui-cfmodal__alert">
        <cf_box  closable="0" resize="0">
            <cfform name="samplemodal" method="post" id="samplemodal">
            <div class="ui-cfmodal-close">×</div>
                <cfif len(get_product.brand_id)>
                    <cfinput  name="brand_id_" type="hidden" value="#get_product.brand_id#">
                <cfelse>
                    <cfinput  name="brand_id_" type="hidden" value="0">
                </cfif>
                <cfif len(get_product.product_catid)>
                    <cfinput  name="product_cat_id_" type="hidden" value="#get_product.product_catid#">
                <cfelse>
                    <cfinput  name="product_cat_id_" type="hidden" value="0">
                </cfif>
                <cfif  len(get_product.product_sample_id)>
                    <div class="form-group" style="margin-top: 15px;">
                        <label style="font-size: 15px;margin-left: 10px;"><cf_get_lang dictionary_id='65261.Bu Ürün Numune Çalışması Yaparak Oluşturulmuş'></label>
                    </div>
                    <div class="form-group" style="margin-top: 15px;">
                        <label style="font-size: 15px;margin-left: 10px;"><cf_get_lang dictionary_id='62603.Numune'> : ID  &nbsp;<a style="color: #44b6ae;"href="javascript://" id="link" onClick="window.open('<cfoutput>#request.self#?fuseaction=product.product_sample&event=upd&product_sample_id=#get_product.product_sample_id#</cfoutput>')"><cfoutput><cf_get_lang dictionary_id='55765.Tıklayın'></cfoutput></a>    </label>
                    </div>
                </cfif>
              
                <cfif not  len(get_product.product_sample_id)>
                    <div class="form-group"style="margin-top: 15px;">
                        <label style="font-size: 15px;margin-left: 10px;"><cf_get_lang dictionary_id='65330.Ürün ağacını referans alarak yeni bir numune yaratılacak .Emin misiniz?'>    </label>
                    </div>
                    <div class="form-group" style="margin-top: 15px;margin-left: 10px">
                        <div class="col col-3">
                            <input type="text" style="min-height: 30px;" name="product_name_" id="product_name_" value="<cfoutput>#get_product.product_name#</cfoutput>">
                        </div>
                        <div class="col col-2">		
                            <input class="ui-wrk-btn ui-wrk-btn-success"  type="button"  value="<cf_get_lang dictionary_id='65262.Yeni Numune Oluştur'>" onclick="CreateSample()">	
                        </div>
                    </div>
                
                </cfif>
            </cfform>
        </cf_box>
    </div>
    <style>
        .ui-cfmodal {
            position: fixed;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            z-index: 9999;
            min-width: 50%;
            max-width: 80%;
        }
    </style>
   
    <script>
     $('.ui-cfmodal-close').click(function(){
           $('.ui-cfmodal__alert').fadeOut();
       })
       $('#link').click(function(){
           $('.ui-cfmodal__alert').fadeOut();
       })
    function sample() {
        $('.ui-cfmodal__alert .required_list li').remove();
        $('.ui-cfmodal .portBox').attr('style','box-shadow:none!important');
        $('.ui-cfmodal__alert:first ').attr('style','box-shadow: 0 0 15px 15px rgba(0,0,0,.2)!important');
    $('.ui-cfmodal__alert').fadeIn();
      
    }

 function CreateSample() {
     
        if($("#product_name_").val() =='' || $("#product_name_").val() == undefined){
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='62603.Numune'><cf_get_lang dictionary_id='57897.Adı'>");
        
            return false;
            
        }
     if( confirm( $("#product_name_").val() + " - Ürün adında bir numune oluşturulacaktır ?")) {
         var data = new FormData();  
             data.append("product_sample_name", $("#product_name_").val());
             data.append("PRODUCT_ID",<cfoutput>#get_product.PRODUCT_ID#</cfoutput>);
             data.append("product_catid", $("#product_cat_id_").val());
             data.append("brand_id",  $("#brand_id_").val());
             AjaxControlPostDataJson("V16/production_plan/cfc/get_tree.cfc?method=create_product_sample", data, function(response){
                 if( response.STATUS ){
                     alert(response.MESSAGE);
                     location.reload();
                 }else{
                     alert(response.MESSAGE);
                 }
             });
         return false;
     }else{  
         return false;
     }
 }
  /* function kontrol_process()
	{
		if(!process_cat_control())
			return false;
		else
			AjaxFormSubmit("add_versiyon",'SHOW_PRODUCT_TREE','','','','','','1');
	}
    function kontrol_process_2()
	{
		if(process_cat_control())
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&run_function=copy_product_func&is_production=1&run_function_param=id','page');
		else
			return false;
	}
	function kontrol_process_3()
	{
		if(process_cat_control())
		{
			if(confirm("<cf_get_lang dictionary_id='36366.Ürün Ağacının Bileşenleri Silinecektir'> , <cf_get_lang dictionary_id='36367.Yaptığınız İşlem Geri Alınamaz'> ! <cf_get_lang dictionary_id='58588.Emin misiniz'>?"))
			{
				add_versiyon.action='<cfoutput>#request.self#?fuseaction=prod.emptypopup_del_product_tree</cfoutput>';
				add_versiyon.submit();
			}
			else
				return false;
		}
		else
			return false;
	} */    
</script>