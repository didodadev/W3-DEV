$(function(){

    var panelStatus = false;
    var totalColumns = 12;
    var halfColumns = 6;
    var quarterColumns = 4;
    var modalPanel = ".wrk-modal-panel";
    var nwButton = ".modalButton";
    var wrkListButton = ".wrk-lst-button";
    var fileUpload = ".fileUpload";
    var typeBoxContent = "#type-box-content";
    var catBar = ".cat-bar";
    var box = ".box-list";
    var baseUrl = $("input[name=baseUrl]").val();

    var lstactive = "lst-active";

    var typeList = "#type-list";
    var typeBox = "#type-box";

    $.intranet = {
       
            changeListType : function(){

                
                var lstButton = $(".wrk-lst-button");

                    lstButton.click(function(){  
                        
                        var type = $(this).attr("type");
                        var listType = $(this).attr("list-type");

                        if(type == "changeColumn"){
                            
                            $(typeList).hide();
                            $(typeBox).show();
                            
                            var columnCount = $(this).attr("column-count");
                            var columnClassNumber = totalColumns / columnCount;
                            var columnClass = "col col-" + columnClassNumber + " col-md-" + quarterColumns + " col-sm-" + halfColumns + " col-xs-" + totalColumns;
                            

                            if(columnCount == 4 || listType == "folder"){
                                boxType = "box-list-small";
                                ImageType = "box-list-image-small";
                                if(listType == "folder"){
                                    $(typeBoxContent).removeClass("col-12").addClass("col-9");
                                    $(catBar).animate({"margin-top" : "0px"},100).show();
                                    var url = baseUrl + "?fuseaction=objects.ajax_get_asset_cat";
		                            AjaxPageLoad(url,"cat-bar");
                                }
                                else{
                                    $(typeBoxContent).removeClass("col-9").addClass("col-12");
                                    $(catBar).animate({"margin-top" : "100px"},100).hide();
                                }
                            } 
                            else if(columnCount == 3){
                                boxType = "box-list-big";
                                ImageType = "box-list-image-big";
                                $(typeBoxContent).removeClass("col-9").addClass("col-12");
                                $(catBar).animate({"margin-top" : "100px"},100).hide();
                            }
                            
                            $(box).each(function(){
                                $(this).removeClass().addClass("box-list " + boxType + " " + columnClass);
                                $(this).find("div.box-list-image").removeClass().addClass("box-list-image " + ImageType);
                            })
                        
                        }else if(type == "changeListType"){
                            $(catBar).hide();
                            $(typeBox).hide();
                            $(typeList).show();
                            
                        }

                        $(wrkListButton).each(function(){
                            if($(this).hasClass(lstactive)){
                                $(this).removeClass(lstactive);
                            }
                        });

                        $(this).addClass(lstactive);
                        $("input[name=list_type]").val(type);
                        $("input[name=listTypeElement]").val(listType);

                    });
                  
            },
            openModal : function(){
                
                $(nwButton).click(function(e){
                    
                    var modalid = $(this).attr("modal-id");

                    $(modalPanel).each(function(){
                        if($(this).attr("id") != modalid){
                            $(this).hide();
                        }
                    });
                    
                    var screenWidth = $(window).width();
                    
                    if(screenWidth <= 415){
                        
                        if(!panelStatus){
                            $("body").css("overflow", "hidden");
                            panelStatus = true;
                        }else{
                            $("body").css("overflow", "auto");
                            panelStatus = false;
                        }

                    }
                    
                    $("#" + modalid).slideToggle("fast");

                });

            },
            justClick : function(){
                
                var element = $("*");

                element.click(function(e){
                    
                    if(
                        
                        (!$(e.target).is(nwButton)) && 
                        (!$(e.target).is(nwButton + " *")) &&
                        (!$(e.target).is(modalPanel)) &&
                        (!$(e.target).is(modalPanel + " *")) &&
                        (!$(e.target).is(fileUpload)) &&
                        (!$(e.target).is(fileUpload + " *")) &&
                        (!$(e.target).is(".fa-edit")) &&
                        (!$(e.target).is(".fa-edit" + " *")) && 
                        (!$(e.target).is(".DynarchCalendar-topCont")) &&
                        (!$(e.target).is(".DynarchCalendar-topCont" + " *"))
                   
                    ){ 
                        $(modalPanel).slideUp();
                    }

                });

            }

    }

});