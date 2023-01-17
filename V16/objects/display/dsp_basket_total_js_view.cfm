<div id="sepetim_total" basket_footer style="display:<cfoutput>#total_table_display_#</cfoutput>;">
        <cfinclude template="dsp_basket_total_js.cfm">
        <cfif isdefined("attributes.is_retail") and not isDefined("session.pp")>
            <cfinclude template="dsp_basket_total_js_per.cfm">
        <cfelseif isdefined("attributes.is_retail") and isDefined("session.pp") and isdefined("url.iid")>
            <cfinclude template="dsp_basket_total_js_per_partner.cfm">
        </cfif>
        
        <cfif ListFindNoCase(display_list, "is_risc")>
            <cfinclude template="display_member_risk.cfm">           
        </cfif>
        
        <cfif listfind('invoice,',fusebox.circuit,',') or listfind("1,2,3,4,10,14,18,20,21,33,42,43,51,52",attributes.basket_id,",")>               
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" style="display:<cfif StructKeyExists(sepet,'general_prom_id') or StructKeyExists(sepet,'free_prom_id')>block<cfelse>none</cfif>;">
                <div class="totalBox">
                    <div class="totalBoxHead font-grey-mint">
                        <cfif ListFindNoCase(display_list, "is_promotion")>
                            <span class="headText"><cf_get_lang dictionary_id ='57583.Promosyonlar'></span>
                        </cfif>
                    </div>
                    <div class="totalBoxBody" id="general_prom_inputs">         
                        <table>
                          <tr>
                            <td id="general_prom_inputs_1" valign="top"><cfif StructKeyExists(sepet,'general_prom_id')>
                                <cfoutput> <a href="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_detail_promotion_unique&prom_id=#sepet.general_prom_id#</cfoutput>','medium');"><b><cf_get_lang dictionary_id="57492.Toplama"> <cf_get_lang dictionary_id="58560.İndirim"></b></a>
                                  <input type="hidden" id="general_prom_id" name="general_prom_id" value="#sepet.general_prom_id#">
                                  <br/>
                                  <cf_get_lang dictionary_id ='58775.Alışveriş Miktarı'>
                                  <input type="text" id="general_prom_limit" name="general_prom_limit" value="#sepet.general_prom_limit#" class="box" readonly>
                                  <br/>
                                  <cf_get_lang dictionary_id ='58560.İndirim '>
                                  %
                                  <input type="text" id="general_prom_discount" name="general_prom_discount" value="#sepet.general_prom_discount#" class="box" readonly>
                                  <br/>
                                  <cf_get_lang dictionary_id ='57649.Toplam İndirim'>
                                  <input type="text" id="general_prom_amount" name="general_prom_amount" value="#sepet.general_prom_amount#" class="box" readonly>
                                  <br/>
                                </cfoutput>
                                <cfelse>
                                <input type="hidden" id="general_prom_limit" name="general_prom_limit" value="">
                                <input type="hidden" id="general_prom_amount" name="general_prom_amount" value="">
                                <input type="hidden" id="general_prom_discount" name="general_prom_discount" value="">
                              </cfif>
                            </td>
                            <td width="10"></td>
                            <td id="general_prom_inputs_2" valign="top"><cfif StructKeyExists(sepet,'free_prom_id')>
                                <cfoutput> <a href="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_detail_promotion_unique&prom_id=#sepet.free_prom_id#</cfoutput>','medium');"><b><cf_get_lang dictionary_id="58863.İndirim Bedava Ürün"></b></a>
                                  <input type="hidden" id="free_prom_id" name="free_prom_id" value="#sepet.free_prom_id#" readonly="readonly">
                                  <br/>
                                  <input type="hidden" id="free_prom_cost" name="free_prom_cost" value="#sepet.free_prom_cost#" readonly="readonly">
                                  <br/>
                                  <cf_get_lang dictionary_id ='58775.Alışveriş Miktarı'>
                                  <input type="text" id="free_prom_limit" name="free_prom_limit"  value="#sepet.free_prom_limit#" class="box" readonly="readonly">
                                  <br/>
                                  <cf_get_lang dictionary_id ='58776.Kazanılan Ürün'>
                                  <cf_get_lang dictionary_id="58527.ID"> 
                                  <input type="text" id="free_prom_stock_id" name="free_prom_stock_id"  value="#sepet.free_prom_stock_id#" class="box" readonly="readonly">
                                  <br/>
                                  <cf_get_lang dictionary_id ='58777.Ürün Miktarı'>
                                  <input type="text" id="free_prom_amount" name="free_prom_amount"  value="#sepet.free_prom_amount#" class="box" readonly="readonly">
                                  <br/>
                                  <cf_get_lang dictionary_id ='58778.Ürün Fiyatı'>
                                  <input type="text" id="free_stock_price" name="free_stock_price"  value="#sepet.free_stock_price#" class="box" readonly="readonly">
                                  <input type="text" id="free_stock_money" name="free_stock_money"  value="#sepet.free_stock_money#" class="boxtext" readonly="readonly">
                                </cfoutput>
                                <cfelse>
                                <input type="hidden" id="free_prom_limit" name="free_prom_limit" value="">
                              </cfif>
                            </td>
                          </tr>
                        </table>
                    </div>
      			</div>    
            </div>  
        </cfif>
        
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" id="basket_money_totals_table" <cfif not ListFindNoCase(display_list, "is_amount_total")>style="display:none"</cfif>>
            <div class="totalBox">
                <div class="totalBoxHead font-grey-mint">
                    <span class="headText"><cf_get_lang dictionary_id="32823.Toplam Miktar"></span><!--- Toplam Miktar --->
                    <div class="collapse">
                        <span class="icon-minus"></span>
                    </div>
                </div>
                <div class="totalBoxBody" id="totalAmountList">  
                    <table></table>
                </div>
            </div>
        </div>
    </div>
        <!--<div class="col col-3 col-md-3 col-sm-3 col-xs-12" id="otherBox">
            <div class="totalBox">
                <div class="totalBoxHead font-grey-mint">                       
                    <span class="headText"><cf_get_lang dictionary_id ='58156.Diğer'></span>
                </div>
                <div class="totalBoxBody"> 
                    <ul class="hoverList" id="otherBoxList">						
                        <li onclick="$('.totalBoxOther').toggleClass('hide');"><span class="bold btnPointer"><cf_get_lang dictionary_id ='57583.Promosyonlar'></span></li>
                    </ul>                    
                </div>
            </div>             
        </div>-->  

<script>
    $(function(){
        var count = 0;
        $('.collapse').click(function(){
			$(this).parent().parent().find('.totalBoxBody').slideToggle();
			if($(this).find("span").hasClass("icon-minus")){
				$(this).find("span").removeClass("icon-minus").addClass("icon-pluss");
			}
			else{
				$(this).find("span").removeClass("icon-pluss").addClass("icon-minus");
			}
		});
    })
</script>

<!--<script type="text/javascript">

	function sorterFooter(){
		$("ul#otherBoxList").empty();
		var Obj = [];
		var wTop = 0
		var maxWidth = ($( window ).width()/10)-8;	
		$("#totals_table").find("input[type!=radio]").each(function(x){
			var t = $(this).val();
			$(this).removeAttr( "value" );
			$(this).attr( "value",t );
		});//each			
		$("#totals_table").find("div.col").each(function(i){
			var e = $(this)
			var eClass = $(e.context).attr('class');							
			var eWidth = (eClass .split("col x-")[eClass.split("col x-").length -1 ]);
			item = {}
			item ["element"] = e.get(0).outerHTML;
			item ["eWidth"] = eWidth;				
			Obj.push(item);
			e.remove();
		});//each
		
		var maxWidth = ($( window ).width()/10)-23;	
		$("#totals_table").empty();
  		$(Obj).each(function(i){
			var w = $(Obj[i].eWidth).selector;
			var e = $(Obj[i].element);	
			wTop = wTop+parseInt(w);
			if(wTop < maxWidth){
				$("#totals_table").append(e);	
				$("ul#otherBoxList").empty();
				$(".totalBoxOtherClose").remove();
			}else{			
				var boxName =(e).find(".totalBoxHead > span.headText").text();
				var id="other_"+Math.floor(Math.random() * 100);
				$("ul#otherBoxList").append(
					$("<li>").attr('onclick','$('+id+').slideToggle()').append($("<span>").addClass("bold btnPointer").append(boxName))
				)//append
				$("#totals_table").append(
					$("<div>").addClass("totalBoxOther hide").attr("id",id).append(e).hide()
				);//append
				$(e).find('.totalBoxOtherClose').remove();
				$(e).find('.totalBoxHead').append(
					$('<span>')
						.addClass('totalBoxOtherClose icon-minus btnPointer pull-right').attr('onclick','$('+id+').slideToggle()')
					);
			}//if
		});//each 
		var Obj = [];
		
		$("#money_rate_table").find("input[class=rdMoney]").each(function(index,element){
			$(element).bind("click", function() {
				$("input[class=rdMoney][value!="+$(element).val()+"]").removeAttr('checked');
				$(this).attr('checked','checked');
			});
		})
		
	}//sorterFooter function
	
	function dragFooter(){
		$( ".totalBoxOther" ).draggable({
		  cursor: "move"
		});
	}
	
	$(function(){			
		sorterFooter();
		dragFooter();
	});//ready function
	
    var screenWidth = $( window ).width();

	$( window ).resize(function() {
		if(screenWidth != $( window ).width()){
            sorterFooter();
		    dragFooter();
            screenWidth = $( window ).width();
        } 
	});//windows resize function
	

</script>-->