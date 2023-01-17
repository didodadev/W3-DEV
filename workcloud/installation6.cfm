<div class="ui-info-text">
    <h1>Fiscal Year Definitions and Create Db Objects</h1>
</div>
<cfform name="installation_6" type="formControl" action="#installUrl#" method="post">
	<div class="ui-form-list">
		<div class="col col-12" id="installList">
			<table class="ui-table-list">
				<tr id="periodDefinitions">
					<td>Period Definitions</td>
					<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
				</tr>
				<tr id="periodControl">
					<td>Create Period Schema, user and login</td>
					<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
				</tr>
				<tr id="periodTables">
					<td>Create Period Tables</td>
					<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
				</tr>
				<tr id="periodViews">
					<td>Create Period Views</td>
					<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
				</tr>
				<tr id="periodProcedures">
					<td>Create Period Procedures</td>
					<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
				</tr>
				<tr id="periodExtraObject">
					<td>Create Period Extra Object</td>
					<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
				</tr>
			</table>
		</div>
	</div>
	<div class="ui-form-list-btn">
		<div class="col-md-12 paddingLess">
			<div class="form-group button-panel">
				<input  class="btn btn-info" type="submit" value="Next Step">
			</div>
		</div>
	</div>
</cfform>

<script>
	
	function startAjaxRequest( processes, row ) {
	
		var flag = $("div#installList table.ui-table-list tr#"+processes[row][1].elementid+" td > i");
		$(flag).removeClass('fa-bookmark-o').addClass('fa-cog fa-spin font-yellow-casablanca');
		$.ajax({
			url: "cfc/install_schema.cfc?method=" + processes[row][1].method,
			dataType: "json",
			method: "post",
			data: processes[row][1].data,
			success: function( response ) {
				if( response.STATUS ){
					$(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagTrue');
					row += 1;
					if( processes[row] != undefined ) startAjaxRequest( processes, row );
					else location.href = '<cfoutput>#installUrl#?installation_type=7</cfoutput>';
				}else{
					$(flag).removeClass('fa-cog fa-spin font-yellow-casablanca').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showInstallMistakeMessage("'+processes[row][0]+'")' }).css({ 'cursor' : 'pointer' });
					
					$('tr#install_'+processes[row][0]+'').remove();

					$(flag).parents('tr').after(
						$('<tr>').attr({ 'id' : 'install_' + processes[row][0] + '' }).append(
							$('<td>').attr({ 'colspan' : 2 }).append(
								$('<table>').addClass('ui-table-list').css({ 'width' : '100%' })
							)
						).hide()
					);
					if( response.MESSAGE != '' ){
						$('tr#install_' + processes[row][0] + ' table').append(
							$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').text( response.MESSAGE ))
						);
					}else{
						$('tr#install_' + processes[row][0] + ' table').append(
							$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Type'), $('<td>').text( response.ERRORMESSAGE.Type )),
							$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Message'), $('<td>').text( response.ERRORMESSAGE.Message )),
							$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Detail'), $('<td>').text( response.ERRORMESSAGE.Detail ))
						);
					}
					if( response.ERRORMESSAGE.queryError != undefined ){
						$('tr#install_' + processes[row][0] + ' table').append(
							$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('queryError'), $('<td>').text( response.ERRORMESSAGE.queryError )),
							$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('Sql'), $('<td>').text( response.ERRORMESSAGE.Sql ))
						);
					}
					$("span.loading").remove();
				}
			}
		});

	}

	$("form[name = installation_6]").submit(function(){

		$("div#installList table.ui-table-list tr td > i").removeClass("fa-bookmark flagFalse").addClass("fa-bookmark-o");

		var form = $(this).serialize();
		var process = {
			periodDefinitions: { method : "periodDefinitions", elementid : "periodDefinitions" , data : form },
			periodControl: { method : "controlPeriod", elementid : "periodControl" , data : "" },
			periodTables : { method : "createObject", elementid : "periodTables" , data : '&object_type=' + 'tables' + '&schema_type=' + 'period' },
			periodViews : { method : "createObject", elementid : "periodViews" , data : '&object_type=' + 'views' + '&schema_type=' + 'period' },
			periodProcedures : { method : "createObject", elementid : "periodProcedures" , data : '&object_type=' + 'procedures' + '&schema_type=' + 'period' },
			periodExtraObject: { method : "createPeriodExtraObject", elementid : "periodExtraObject" , data : "" }
		}

		var processes = new Array();
		for( var i in process ) processes.push([i, process[i]]);

		startAjaxRequest( processes, 0 );

		return false;

	});

	function showInstallMistakeMessage( cmpName ) {
		if( $('tr#install_'+cmpName+'').hasClass("activeTr") ) 
			$('tr#install_'+cmpName+'').hide().removeClass("activeTr");
		else $('tr#install_'+cmpName+'').show().addClass("activeTr");
	}

</script>