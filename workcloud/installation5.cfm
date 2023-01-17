<div class="ui-info-text">
    <h1>Company Definitions and Create Db Objects</h1>
</div>
<cfform name="installation_5" type="formControl" action="#installUrl#" method="post">
	<div class="ui-form-list">
		<div class="col-md-12 paddingLess">
			<div class="col-md-6 paddingLess">
				<div class="form-group">
					<label>Company Full Name <font color="red">*</font></label>
					<div class="col-md-12 pdnl">
						<input required class="form-control" message="Enter Company Full Name"  name="nick_name" id="nick_name" type="text" autocomplete="off" value="" />
					</div>
				</div>
				<div class="form-group">
					<label>Company Nick Name <font color="red">*</font></label>
					<div class="col-md-12 pdnl">
						<input required class="form-control" message="Enter Company Nick Name"  name="nick_name2" id="nick_name2" type="text" autocomplete="off" value="" />
					</div>
				</div>
				<div class="form-group">
					<label>Organizational Zone <font color="red">*</font></label>
					<div class="col-md-12 pdnl">
						<input required class="form-control" message="Enter Zone" maxlength="20" name="zone_name" id="zone_name" type="text" autocomplete="off" value="" />
					</div>
				</div>
			</div>
			<div class="col-md-6 paddingLess">
				<div class="form-group">
					<label>Branch Name <font color="red">*</font></label>
					<div class="col-md-12 pdnl pdnr">
						<input required class="form-control" message="Enter Branch" maxlength="20" name="branch_name" id="branch_name" type="text" autocomplete="off" value="" />
					</div>
				</div>
				<div class="form-group">
					<label>Department <font color="red">*</font></label>
					<div class="col-md-12 pdnl pdnr">
						<input required class="form-control" message="Enter Department" maxlength="20" name="department_head" id="department_head" type="text" autocomplete="off" value="" />
					</div>
				</div>
			</div>
		</div>
		<div class="col col-12" id="installList">
			<table class="ui-table-list">
				<tr id="companyDefinitions">
					<td>Company Definitions</td>
					<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
				</tr>
				<tr id="companyControl">
					<td>Create Company Schema, user and login</td>
					<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
				</tr>
				<tr id="companyTables">
					<td>Create Company Tables</td>
					<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
				</tr>
				<tr id="companyViews">
					<td>Create Company Views</td>
					<td style="width:25px" class="text-center"><i class="fa fa-2x fa-bookmark-o"></i></td>
				</tr>
				<tr id="companyProcedures">
					<td>Create Company Procedures</td>
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
					else location.href = '<cfoutput>#installUrl#?installation_type=6</cfoutput>';
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

	$("form[name = installation_5]").submit(function(){

		$("div#installList table.ui-table-list tr td > i").removeClass("fa-bookmark flagFalse").addClass("fa-bookmark-o");

		var form = $(this).serialize();
		var process = {
			companyDefinitions: { method : "companyDefinitions", elementid : "companyDefinitions" , data : form },
			companyControl: { method : "controlCompany", elementid : "companyControl" , data : "" },
			companyTables : { method : "createObject", elementid : "companyTables" , data : '&object_type=' + 'tables' + '&schema_type=' + 'company' },
			companyViews : { method : "createObject", elementid : "companyViews" , data : '&object_type=' + 'views' + '&schema_type=' + 'company' },
			companyProcedures : { method : "createObject", elementid : "companyProcedures" , data : '&object_type=' + 'procedures' + '&schema_type=' + 'company' }
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