<script type="text/javascript" src='/JS/jquery.resizableColumns.js'></script>
<script type="text/javascript" src='/JS/ruler_tool/jquery.ruler.js'></script>
<script type="text/javascript" src='/JS/ruler_tool/modernizr-custom.js'></script>
<link rel="stylesheet" href="/css/assets/template/ruler_tool/ruler.css" type="text/css">
<script type="text/javascript" src="JS/temp/colorpicker/jscolor.js"></script>

<cfset getPrintTemplate = createObject("component","cfc.get_print_template")>
<cfif isNumeric(attributes.template_id)>
    <cfset get_templates_css = getPrintTemplate.get_template( template_id : attributes.template_id )>
<cfelse>
    <script>
        alert("<cf_get_lang dictionary_id='65358.Seçilen Şablon Tasarıma Uygun Değil'>!");
        window.close();	
    </script>
</cfif>
<cfset fileDir =  "#get_templates_css.OUTPUT_TEMPLATE_PATH#" />
<cfset SCHEMA_TYPE = '#get_templates_css.SCHEMA_MARKUP#'>
<cfscript>
    use_logo = 1;
    use_adress = 1;
    rule_unit = "mm";
    page_width = 210;
    page_height  = "";
    page_header_height = "";
    page_footer_height = "";
    page_margin_left = "";
    page_margin_right = "";
    page_margin_top = "";
    page_margin_bottom = "";  
    if (get_templates_css.recordcount neq 0){
        colNames = listToArray(get_templates_css.columnList);
        for(i in colNames){
            if(len(evaluate("get_templates_css.#i#"))) "#i#" = evaluate("get_templates_css.#i#");
        }
        if(rule_unit eq 2) rule_unit = 'in';
        else rule_unit = 'mm';
    }                        
</cfscript> 
<style>
    .under_line{text-decoration: underline;}
    .italic{font-style: italic;}
    .designer{
        border-width: 1px;
        overflow: hidden;
        border-color: rgb(255, 255, 255);
        border-style: solid;
        background-color: rgb(255, 255, 255);
        background-image: url(data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PHBhdHRlcm4gaWQ9ImdyaWQiIHdpZHRoPSI0MCIgaGVpZ2h0PSI0MCIgcGF0dGVyblVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHBhdGggZD0iTSAwIDEwIEwgNDAgMTAgTSAxMCAwIEwgMTAgNDAgTSAwIDIwIEwgNDAgMjAgTSAyMCAwIEwgMjAgNDAgTSAwIDMwIEwgNDAgMzAgTSAzMCAwIEwgMzAgNDAiIGZpbGw9Im5vbmUiIHN0cm9rZT0iI2QwZDBkMCIgb3BhY2l0eT0iMC4yIiBzdHJva2Utd2lkdGg9IjEiLz48cGF0aCBkPSJNIDQwIDAgTCAwIDAgMCA0MCIgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjZDBkMGQwIiBzdHJva2Utd2lkdGg9IjEiLz48L3BhdHRlcm4+PC9kZWZzPjxyZWN0IHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIGZpbGw9InVybCgjZ3JpZCkiLz48L3N2Zz4=);
        background-position: 8px 2px;
        display: flex;
        justify-content: center;
    }
    .rc-handle-container {
    position: relative;
    }
    .rc-handle {
    position: absolute;
    width: 7px;
    cursor: ew-resize;
    margin-left: -3px;
    z-index: 2;
    }
    table.rc-table-resizing {
    cursor: ew-resize;
    }
    table.rc-table-resizing thead,
    table.rc-table-resizing thead > th,
    table.rc-table-resizing thead > th > a {
    cursor: ew-resize;
}
</style>
 
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="temp"><cf_get_lang dictionary_id='63663.Şablon Tasarımcısı'> - <cf_get_lang dictionary_id='62038.Beta'></cfsavecontent>

    <cf_box title="#temp#">
        <div class="designer">
            <div id="woc_preview" class="ruler_des" style="border:1px solid #afafaf;">
                
                <cfinclude template="../display/woc_asset.cfm">
                <div class="popover_cont" style="display:none;position:absolute">
                    <form id="myform">
                        <div style="background-color: rgba(233,182,182,0.9);z-index:1!important;" class="tour_box tour_box-type2">
                            <div class="tour_box_text">
                                <div>
                                    <p class="bold"><cf_get_lang dictionary_id='57685.Font'></p>
                                    <div class="tour_box_close" style="color:#000000;top:3px">
                                        ×
                                    </div>
                                </div>
                                <button id="hide_element" type="button"><i class="fa fa-eye-slash" title="<cf_get_lang dictionary_id='58628.Gizle'>"></i></button>
                                <select id="fface" title="<cf_get_lang dictionary_id='57685.Font'>"> 
                                    <option value="Arial"><cf_get_lang dictionary_id='32807.Arial'></option>
                                    <option value="Verdana"><cf_get_lang dictionary_id='32785.Verdana'> </option>
                                    <option value="Impact">Impact </option>
                                    <option value="Comic Sans MS"><cf_get_lang dictionary_id='32781.Comic Sans MS'></option>
                                    <option value="COURIER"><cf_get_lang dictionary_id='32808.Courier'></option>
                                    <option value="HELVETICA"><cf_get_lang dictionary_id='32816.Helvetica'></option>
                                    <option value="Times_roman"><cf_get_lang dictionary_id='32827.Times New Roman'></option>
                                    <option value="ZAPFDINGBATS"><cf_get_lang dictionary_id='32863.Zapfdingbats'></option>
                                </select>
                                <input type="number" name="fsize" id="fsize" title="<cf_get_lang dictionary_id='58952.Font Ölçüsü'>" style="width:50px">   
                                <button id="in_bold" type="button" title="<cf_get_lang dictionary_id='57503.Kalın'>"><i class="fa fa-bold"></i></button>
                                <button id="in_underline" type="button" title="<cf_get_lang dictionary_id='57505.Altı Çizili'>"><i class="fa fa-underline"></i></button>
                                <button id="in_italic" type="button" title="<cf_get_lang dictionary_id='57504.İtalik'>"><i class="fa fa-italic"></i></button>
                                <input type="text" name="font_color" id="font_color" title="<cf_get_lang dictionary_id='36463.Font Rengi'>" maxlength="6"  class="colorpicker" />
                                <div class="margin-top-10"></div>
                                <div class="border_style" style="display:none">
                                    <p class="bold"><cf_get_lang dictionary_id='50602.Border'></p>
                                    <input type="number" name="border_size" id="border_size" title="<cf_get_lang dictionary_id='46825.Border Ölçüsü'>" style="width:50px">   
	                                <input type="text" name="border_color" id="border_color" title="<cf_get_lang dictionary_id='57138.Border Rengi'>" maxlength="6"  class="colorpicker" />
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div>
                    <table class="print_page"><tr><td><table id="temp_table" width="100%"><cfinclude template="../../../#fileDir#"></table></td></tr></table>
                </div>
            </div>
        </div>
        <div style="background-color: rgba(120, 120, 120, 0.8);width:500px!important" class="tour_box tour_box-type2 margin-top-10" id="item_trash">
            <div class="tour_box_title">
                <h1><cf_get_lang dictionary_id='65356.Kullanılmayanlar'></h1>
            </div>
            <div class="tour_box_text" id="trash"></div>
        </div>
        <cf_box_footer>
            <cfsavecontent  variable="extra"><cf_get_lang dictionary_id='61209.Return to Default'></cfsavecontent>
			<cf_workcube_buttons is_upd='0' add_function="designed()" extraButton="1" extraButtonText="#extra#" extraFunction="reset()">
        </cf_box_footer>
    </cf_box>
</div>
<script>
    $("#item_trash").css("left",$("#woc_preview").position().left);
    $(function() {
        $('.ruler_des').ruler({
            vRuleSize: 18,
            hRuleSize: 18,
            startX: 2,
            startY: 36,
            showMousePos: false
        });     
    });
    $(".print_page").css({"margin-left": "-20px","margin-top":"-17.6px"});
    $('#woc_preview').width($('#woc_preview').width()+20)

    $( ".popover_cont" ).click(function() {
        $( ".popover_cont" ).draggable();
    });

    $( "#item_trash" ).click(function() {
        $( "#item_trash" ).draggable();
    });

    function rgb2hex(rgb){
        rgb = rgb.match(/^rgba?[\s+]?\([\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?/i);
        return (rgb && rgb.length === 4) ? 
        ("0" + parseInt(rgb[1],10).toString(16)).slice(-2) +
        ("0" + parseInt(rgb[2],10).toString(16)).slice(-2) +
        ("0" + parseInt(rgb[3],10).toString(16)).slice(-2) : '';
    }

    var data = "";
    var is_table= "";

    $("td").each(function (index) {
        $(this).attr("id", "col"+index);
    });

    $(document).on("click", "#temp_table td", function (e) {
        data = this.id;
        is_table= 0;
        left_pos = $(this).offset().left;
        top_pos = $(this).offset().top;

        hex = rgb2hex($("#"+data).css('border-color')).toUpperCase();
        $("#font_color").val(hex);
        $("#font_color").css('background-color',$("#"+data).css('border-color'));

        data_width= parseInt($("#"+data).css('font-size'), 10);
        $("#fsize").val(data_width);

        $('.popover_cont').css({"left":left_pos+70,"top":top_pos-50});
        $(".popover_cont").show();
        $('#hide_element').show();
        $('.border_style').hide();
        return false;
    });
    
    $(".print_border").click(function() { 
        data = this.id;
        is_table= 1;
        hex = rgb2hex($("#"+data).css('border-color')).toUpperCase();
        $("#border_color").val(hex);
        $("#border_color").css('background-color',$("#"+data).css('border-color'));

        data_width= parseInt($("#"+data).css('border-width'), 10);
        $("#border_size").val(data_width);

        $('.popover_cont').css({"left":$(this).offset().left+70,"top":$(this).offset().top-50});
        $(".popover_cont").show();
        $('#hide_element').show();
        $('.border_style').show();
        return false;
    });

    $('#in_bold').click(function() {
        if($("#"+data).hasClass("bold") || document.getElementById(data).style.cssText.includes("font-weight: bold")) {
            $("#"+data).removeClass("bold");
        } 
        else{
            $("#"+data).addClass("bold");
        }
    });

    $('#in_italic').click(function() { 
        if(is_table == 1){
            if($("#"+data+" th,#"+data+" td").hasClass('italic') || document.getElementById(data).style.cssText.includes("font-style:italic")) {
                $("#"+data+" th,#"+data+" td").removeClass("italic");
            }
            else{
                $("#"+data+" th,#"+data+" td").addClass("italic");
            }
        }
        else{
            if($("#"+data).hasClass('italic') || document.getElementById(data).style.cssText.includes("font-style:italic")) {
                $("table tbody tr td#"+data).removeClass("italic");
            }
            else{
                $("table tbody tr td#"+data).addClass("italic");
            }
        }
    });

    $('#in_underline').click(function() { 
        if(is_table == 1){
            if($("#"+data+" th,#"+data+" td").hasClass('under_line') || document.getElementById(data).style.cssText.includes("text-decoration:underline")) {
                $("#"+data+" th,#"+data+" td").removeClass("under_line");
            }
            else{
            $("#"+data+" th,#"+data+" td").addClass("under_line");
            }
        }
        else{
            if($("#"+data).hasClass('under_line') || document.getElementById(data).style.cssText.includes("text-decoration:underline")) {
                $("table tbody tr td#"+data).removeClass("under_line");
            }
            else{
            $("table tbody tr td#"+data).addClass("under_line");
            }
        }
    });

    $("#fsize").on('change', function () {
        if(is_table == 1){
            $("#"+data+" th,#"+data+" td").attr('style', 'font-size:'+$(this).val()+'px!important');
            
        }
        else{
            $("#"+data).css("font-size", $(this).val() + "px");
        }
    });

    $("#fface").on('change', function () {
        var x = $(this).val();
        if(is_table == 1){
            $("#"+data+" td").attr('style', 'font-family:'+x+'!important');
            $("#"+data+" th").attr('style', 'font-family:'+x+'!important');
        }
        else{
            $("table tbody tr td#"+data).attr('style', 'font-family:'+x+'!important');
        }
    });

    $("#font_color").on('change', function () {
        if(is_table == 1){
            $("#"+data+" td,#"+data+" th").css("color", "#"+$(this).val());
        }
        else{
            $("#"+data).css("color", "#"+$(this).val());
        }
    });

    $("#border_size").on('change', function () {
        var prev_color_table = $("#"+data).css('border-color');

        $("#"+data).css("border", $(this).val()+"px solid "+prev_color_table);
        var xx= $(this).val();
        
        $("#"+data+" thead tr td").each(function() {
            $(this).attr('style','border:'+ xx +'px solid '+prev_color_table+'!important');
        });

        $("#"+data+" thead tr th").each(function() {
            $(this).attr('style','border:'+xx+'px solid '+prev_color_table+'!important');
        });

        $("#"+data+" tbody tr td").each(function() {
            $(this).attr('style','border:'+xx+'px solid '+prev_color_table+'!important');
        });
       

    });

    $("#border_color").on('change', function () {
        var prev_size_table = $("#"+data).css('border-width');

        $("#"+data).css("border", prev_size_table+" #"+$(this).val()+" solid");
        $("#"+data+" thead tr td").css("border", prev_size_table+" #"+$(this).val()+" solid");
        $("#"+data+" thead tr th").css("border", prev_size_table+" #"+$(this).val()+" solid");
        $("#"+data+" tbody tr td").css("border", prev_size_table+" #"+$(this).val()+" solid");

    });

    $("#border_size").on('change', function () {
        var prev = $("#"+data).css('border-color');
        $("#"+data).css("border", $(this).val()+"px solid "+prev);
        $("#"+data+"thead tr td").css("border", $(this).val()+"px solid "+prev);
        $("#"+data+"thead tr th").css("border", $(this).val()+"px solid "+prev);
    });

    $("#border_color").on('change', function () {
        var prev = $("#"+data).css('border-width');
        $("#"+data).css("border", prev+" #"+$(this).val()+" solid");
        $("#"+data+"thead tr td").css("border", prev+" #"+$(this).val()+" solid");
        $("#"+data+"thead tr th").css("border", prev+" #"+$(this).val()+" solid");
    });
    $(".tour_box_close").click(function() { 
        $(".popover_cont").hide();
    });

    function show_element(el_id) {
        el_id= $(el_id).attr('id');
        $("#"+el_id).parent().show();
        $("#li_"+el_id).hide();
    }

    $('#hide_element').click(function() { 
       el_hidden= $("#"+data).parent().html();
        $("#trash").append("<li id='li_" + data + "'>"+ el_hidden +"<a onclick='show_element(" + data + ")'><i class='fa fa-eye'></i></a></li>");
        $("#temp_table #"+data).parent().hide();
        $('#hide_element').hide();
    });

    
    $(function() {
        <cfif len(get_templates_css.data_design)>   
            var design = JSON.parse(<cfoutput>#get_templates_css.data_design#</cfoutput>);
            for(var i = 0; i < design.length; i++) {
                $('#' + design[i].key).attr('style',design[i].value);
                $('#' + design[i].key).attr('class',design[i].class);

                if(design[i].value.includes("display: none") ){
                   var el_html=  $('#' + design[i].key).html();
                   var el_id= $(el_html).attr('id');
                   $("#trash").append("<li id='li_" + el_id + "'>"+ el_html +"<a onclick='show_element(" + el_id + ")'><i class='fa fa-eye'></i></a></li>");
                }

            }
        </cfif>
    })
    function designed(){
        var ID = [];
        $("tr").each(function() {
            if (this.id !== '') 
                ID.push({key : this.id, value: document.getElementById(this.id).style.cssText, class: document.getElementById(this.id).className});
            
        });
        $("th").each(function() {
            if (this.id !== '')  
                ID.push({key : this.id, value: document.getElementById(this.id).style.cssText, class: document.getElementById(this.id).className});
            
        });
        $("td").each(function() {
            if (this.id !== '')  
                ID.push({key : this.id, value: document.getElementById(this.id).style.cssText, class: document.getElementById(this.id).className});
            
        });
        $("table .print_border").each(function() {
            if (this.id !== '')  
                ID.push({key : this.id, value: document.getElementById(this.id).style.cssText});
            
        });
        var objects = JSON.stringify(ID);
        var data = new FormData();
        data.append('objects', objects);
        data.append('template_id', '<cfoutput>#attributes.template_id#</cfoutput>');
		AjaxControlPostDataJson( "V16/objects/cfc/woc.cfc?method=design", data, function(response) {
           if(response == true){
               alert('<cf_get_lang dictionary_id='58890.Saved'>!');
               location.reload();
           }
        });
        return false;
    }
    function reset(){
        if(confirm("<cf_get_lang dictionary_id='61209.Return to Default'>?")){
            var data = new FormData();
            data.append('template_id', '<cfoutput>#attributes.template_id#</cfoutput>');
            AjaxControlPostDataJson( "V16/objects/cfc/woc.cfc?method=design", data, function(response) {
            if(response == true){
                alert('<cf_get_lang dictionary_id='61210.Transaction Successful'>!');
                location.reload();
            }
        });
        }
        
    }
</script>