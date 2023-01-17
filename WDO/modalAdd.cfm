<cfquery name="GET_MODELS" datasource="#DSN#">
	SELECT
    	M1.MODELID, 
        M1.MODELNAME, 
        M1.MODELLANG, 
        M1.MODELTYPE, 
        M1.MODELINDEX, 
        M1.MODELRELATION, 
        M1.MODELMETHOD, 
        M1.MODELMAXROW, 
        M1.MODELADDROW
	FROM
    	MODEL AS M1
	WHERE
    	M1.MODELUSERFRIENLY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userFriendly#">
	ORDER BY
    	M1.MODELTYPE,
        M1.MODELINDEX
</cfquery>
<!---<cfdump var="#GET_MODELS#">--->

<div class="row">
    <div class="col col-4 col-xs-12 scrollContent scroll-x6">
		<cfoutput query="GET_MODELS">
            <div class="row">
                <div class="col col-12 portBox togglePort">                                                    
                    <div class="portHead bg-green-meadow bg-font-green-meadow">
                        <span>#MODELNAME#</span>
                    </div>
                    <div class="portBody" style="display: block;">       
                        <cfquery name="GET_MODEL_ROW" datasource="#dsn#">
                            SELECT * FROM MODELROW WHERE MODELID = #MODELID#
                        </cfquery>   
                        <div id="div#currentrow#" class="connectedElementSortable" style="min-height:30px;">
                            <cfloop query="GET_MODEL_ROW">
                                <div class="form-group">
                                    <label class="col col-4 col-xs-12">#ELEMENTNAME#</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfswitch expression="#ELEMENTTYPE#">
                                            <cfcase value="1"><input type="text" /></cfcase>
                                            <cfcase value="2"><input type="text" /></cfcase>
                                            <cfcase value="3"><select><option value=""><cf_get_lang_main no="322.Seçiniz"></option></select></cfcase>
                                            <cfcase value="4"><select><option value=""><cf_get_lang_main no="322.Seçiniz"></option></select></cfcase>
                                            <cfcase value="5"><textarea></textarea></cfcase>
                                            <cfcase value="6"><input type="radio" /></cfcase>
                                            <cfcase value="7"><input type="checkbox" /></cfcase>
                                            <cfcase value="8"><input type="checkbox" /></cfcase>
                                            <cfcase value="9"><input type="checkbox" /></cfcase>
                                        </cfswitch>
                                    </div>
                                </div>
                            </cfloop>
                        </div>
                    </div>
                </div>
            </div>
        </cfoutput>  
	<div class="row">
        <div class="col col-12 portBox">                                                    
            <div class="portHead bg-green-meadow bg-font-green-meadow">
                <span>Bu Senin Loopun</span>
            </div>
            <div class="portBody" style="display: block;">       
                <div class="connectedElementSortable" style="min-height:30px;">                
                    <div class="connectedElementSortable connectedLoop">
                    	<div class="form-group">
                        	<label>Elma <input type="checkbox" /></label>
                        </div>
                    	<div class="form-group">
                        	<label>Armut<input type="checkbox" /></label>
                        </div>
                    	<div class="form-group">
                        	<label>Karpuz<input type="checkbox" /></label>
                        </div>
                    	<div class="form-group">
                        	<label>Kavun<input type="checkbox" /></label>
                        </div>
                    	<div class="form-group">
                        	<label>Vişne<input type="checkbox" /></label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</div>
</div>
	
    <div class="col col-8 col-xs-12">
        <div class="row">
            <div class="col col-12 formDesignerButtons">
                <span class="btn green-jungle" id="formRowAdd">Satır Ekle</span>
                <span class="btn blue-sharp" id="formColAdd">Sütun Ekle</span>
            </div>
        </div>
        <div id="rowsContent" class="connectedRow">

        </div>
    </div> 
</div>

<div  id="baseDiv" style="display:none;">
    <div Base class="col col-4 col-xs-12 padding-0 dotted border-blue-sharp">
        <div class="sorterHead">
            <div class="pull-right colNumber">
                <select name="sel" onchange="setColSettings(this);">
                    <cfoutput>
                        <cfloop index="ind" from="1" to="12">
                            <option value="col-#ind#" <cfif ind eq 3>selected</cfif>>col-#ind#</option>
                        </cfloop>
                    </cfoutput>
                </select>
            </div>
        </div>
        <div class="row">
        	<div class="connectedElementSortable" style="min-height:30px;"></div> 
        </div>
	</div>
</div>

<script type="text/javascript">
	$(function() {		
		$(".connectedElementSortable").sortable({
			connectWith: ".connectedElementSortable",
			placeholder: "elementSortArea",
			opacity			: '0.6',
			start: function(e, ui ){
				 ui.placeholder.height(ui.helper.outerHeight());
			},
		}).disableSelection();
		
		$(".connectedCol").sortable({
			connectWith: ".connectedCol",
			opacity			: '0.6',
			revert			: 300,
			start: function(e, ui ){
				 ui.placeholder.height(ui.helper.outerHeight());
				 ui.placeholder.width(ui.helper.outerWidth());
			},
		}).disableSelection()
		
		$(".connectedRow").sortable({
			connectWith: ".connectedRow",
			placeholder: "rowSortArea",
			opacity			: '0.6',
			revert			: 300,
			start: function(e, ui ){
				 ui.placeholder.height(ui.helper.outerHeight());
			},
		}).disableSelection()
		$(".connectedLoop").sortable({
			connectWith: ".connectedLoop",
			placeholder: "elementSortArea",
			opacity			: '0.6',
			revert			: 300,
			start: function(e, ui ){
				 ui.placeholder.height(ui.helper.outerHeight());
			},
		}).disableSelection()
	});//ready
	$(".portBox.togglePort").click(function() {
		$(this)
	});

	$("#formRowAdd").click(function() {
		$( "#rowsContent .row" ).removeClass("formRowActive");
		$('<div>')
			.attr({id:'rowid'})
			.addClass('row border-1 border-green-jungle connectedCol formRowActive')
			.append('')
			.appendTo('#rowsContent');			
			$("#rowsContent .row").click(function() {$( "#rowsContent .row" ).removeClass("formRowActive");$( this ).addClass("formRowActive");});
	});
	
	$("#rowsContent .row").click(function() {$("#rowsContent .row").removeClass("formRowActive");$( this ).addClass("formRowActive");});
	
	$("#formColAdd").click(function() {
		$('#rowsContent .formRowActive').append($("#baseDiv").html());
		
		$(".connectedElementSortable").sortable({
			connectWith: ".connectedElementSortable",
			placeholder: "elementSortArea",
			opacity			: '0.6',
			start: function(e, ui ){
				 ui.placeholder.height(ui.helper.outerHeight());
			},
		}).disableSelection();
		
		$(".connectedCol").sortable({
			connectWith: ".connectedCol",
			opacity			: '0.6',
			revert			: 300,
			start: function(e, ui ){
				 ui.placeholder.height(ui.helper.outerHeight());
				 ui.placeholder.width(ui.helper.outerWidth());
			},
		}).disableSelection()
		
		$(".connectedRow").sortable({
			connectWith: ".connectedRow",
			placeholder: "rowSortArea",
			opacity			: '0.6',
			revert			: 300,
			start: function(e, ui ){
				 ui.placeholder.height(ui.helper.outerHeight());
			},
		}).disableSelection()
		$(".connectedLoop").sortable({
			connectWith: ".connectedLoop",
			placeholder: "elementSortArea",
				opacity			: '0.6',
				revert			: 300,
			start: function(e, ui ){
				 ui.placeholder.height(ui.helper.outerHeight());
			},
		}).disableSelection()
		
	});
	
	function setColSettings(element)
	{
		$($(element).closest('div[Base]').removeClass().addClass(' padding-0 dotted border-blue-sharp col col-xs-12 '+$(element).val()));
	}
</script>
