<!---  Tab'ın içinde gönderilen boxları slayt şeklinde ya da normal sayfa şeklinde gösterilmesini sağlar.. İlker Altındal

    kullanım:

    slider = tab'ın slayt şeklinde mi yoksa normal sayfalama şeklinde mi olacağını belirtir.
    defaultOpen = hangi id li tabın açılır geleceğini belirliyor
    divId = tabın içerisinde gelecek divler
    divLang = tabların başlıkları


        Örnek :

         <cf_tab slider="1" defaultOpen="#attributes.divid#" divId="chat_page,warning_page" divLang="#getLang('settings',859)#;#getLang('agenda',8)#">
            <cf_box id="chat_page" box_page="#request.self#?fuseaction=objects.popup_message&employee_id=#attributes.employee_id#"></cf_box>
            <cf_box id="warning_page"  box_page="#request.self#?fuseaction=#attributes.fuseact#"></cf_box>
        </cf_tab>
--->

<cfparam name="attributes.divId" default="">
<cfparam name="attributes.divLang" default="">
<cfparam name="attributes.defaultOpen" default="">
<cfparam name="attributes.slider" default="0">
<cfparam name="attributes.style" default="">
<cfparam name="attributes.beforeFunction" default=""> <!--- Tab butona tıklandığında çalışır --->
<cfparam name="attributes.afterFunction" default=""> <!--- Tab butona tıklandıktan sonra çalışır --->
<cfset Randomize(round(rand()*1000000))/>
<cfset tabid = "tab_#round(rand()*1000000)#">
<cfset funcid = "func_#round(rand()*1000000)#">
<cfset type = ""> <!--- Slide durumunda "slide" sadece tıklama durumunda "click değerini alır"  --->
<cfif attributes.slider eq 1>
    <cfset type = "slide">
<cfelse>
    <cfset type = "click">
</cfif>

<cfif thisTag.executionMode eq "start">   
    
<div class="tabcontent col col-12 col-md-12 col-xs-12" id="<cfoutput>#tabid#</cfoutput>" <cfif attributes.slider eq 1>style="overflow:hidden;"</cfif>>
    
    <div class="tab scrollbarProject" style="overflow-y:hidden;<cfoutput>#attributes.style#</cfoutput>">
   
        <cfif attributes.slider eq 1>
            <div id="Downtab" style="position:relative;">
        </cfif>
            <cfset sayac = 1>
            <cfloop list="#attributes.divId#" index="i">
                <cfoutput>
                    <a class="tablinks" onclick="#((len( attributes.beforeFunction ) and len( listgetat( attributes.beforeFunction, sayac, '|' ) )) ? listgetat( attributes.beforeFunction, sayac, '|' ) & ' && ' : '' )##funcid#(event, 'unique_#i#','#sayac-1#','#tabid#','#type#') #((len( attributes.afterFunction ) and len( listgetat( attributes.afterFunction, sayac, '|' ) )) ? ' && ' & listgetat( attributes.afterFunction, sayac, '|' ) : '' )#;" data-id="#i#" id="defaultOpen">
                        #listgetat(attributes.divLang, sayac, find( attributes.divLang, ',' ) ? ',' : ';')#
                    </a>
                </cfoutput>
                <cfset sayac = sayac + 1>
            </cfloop>
        <cfif attributes.slider eq 1>
            </div>
        </cfif>
    
    </div>
          
    <cfif attributes.slider eq 1>
            <div id="slider" style="position:relative;">
                <div>
    </cfif>

<cfelse>

    <cfif attributes.slider eq 1>
                </div><!---sliderBottom--->
            </div><!---slider--->
    </cfif>
    
</div><!---tabcontent--->

</cfif>     

 

<cfif attributes.slider eq 1>
    <script src="JS/jquery.swipeSlider.js"></script>
</cfif>
<script type="text/javascript">

    var animation = 400;
    var sliderIndex = 0;
    var translateX = -476;
    var tabContentWidth = 0;
    
    $(function(){

        <cfloop list="#attributes.divId#" index="i">
            <cfoutput>var index_ = '#i#';</cfoutput>
            $('#<cfoutput>#tabid#</cfoutput> #unique_'+index_).hide();
            <cfif attributes.defaultOpen neq "">
                $('#<cfoutput>#tabid#</cfoutput> #unique_'+'<cfoutput>#attributes.defaultOpen#</cfoutput>').show();
                $("#<cfoutput>#tabid#</cfoutput> a[data-id = <cfoutput>#attributes.defaultOpen#</cfoutput>]").addClass("active");
            </cfif>
        </cfloop>
        
        <cfif attributes.slider eq 1>

            downtab = $("#<cfoutput>#tabid#</cfoutput> #Downtab").children().length;
            tabLinks = $("#<cfoutput>#tabid#</cfoutput> .tablinks").width();
            tabWidth = (downtab + 3) * tabLinks;  
            $("#<cfoutput>#tabid#</cfoutput> div#Downtab").width(tabWidth);
            var slider = $('#<cfoutput>#tabid#</cfoutput> #slider').swipeSlider();

        
                tabContentWidth = $(".tab").width()+1;
                $("#<cfoutput>#tabid#</cfoutput> #slider div.uniqueBox").css("cssText","width :"+(tabContentWidth)+"px !important;");
                $("#<cfoutput>#tabid#</cfoutput> #slider div.uniqueBox").css('float','left'); 
            

            $(window).resize(function(){//boyut değişirse

                tabContentWidth = $("#<cfoutput>#tabid#</cfoutput>").width();
                $("#<cfoutput>#tabid#</cfoutput> #slider div.uniqueBox").css("cssText","width :"+(tabContentWidth)+"px !important;");
                $("#<cfoutput>#tabid#</cfoutput> #slider div.uniqueBox").css('float','left');
    
            });

        </cfif>

    });

    function <cfoutput>#funcid#</cfoutput>(evt, divName, counter, tabid, type) 
    {
        if(type == "slide"){

            var sliderderWidth = $("#"+tabid+" #slider").width();
            var animationDurationInSecs = '0.' + (animation / 100) + 's';
            sliderIndex = $("#"+tabid+" #slider").attr("data-id");
            translateX = sliderderWidth * counter * -1;
            $("#"+tabid+" .ss-slides").css({ transform: 'translate3d(' + translateX + 'px,0,0)', transition: 'transform ' + animationDurationInSecs + ' ease-out' });
            $("#"+tabid+" #slider").attr({"data-id": counter});
            $("#"+tabid+" div#Downtab button").removeClass("active");	
            $("#"+tabid+" div#Downtab button:eq("+counter+")").addClass("active");
            var slider = $("#"+tabid+" #slider").swipeSlider();
            slider.swipeSlider('setOffset');

        }else if(type == "click"){
            
            $("#"+tabid+" > .uniqueBox").hide();
            $("#"+tabid+" > #"+divName+"").show();
            $("#"+tabid+" > .tab .tablinks").removeClass("active");
            $("#"+tabid+" > .tab .tablinks:eq("+counter+")").addClass("active");

        }
        return true;
    }

</script>