<div class="ui-info-text">
	<h1>Workcube Parameter Settings</h1>
</div>
<div class="col-md-12 paddingLess">
    <div class="panel panel-default">
        <div class="panel-body">
            <cfoutput>
                <div class="col-md-12">Workcube parameter settings are necessary for your system to function.</div>
                <div class="col-md-12">Some settings need to be adjusted according to your usage pattern.</div>
            </cfoutput>
        </div>
    </div>
</div>
<cfform name="installation_3" id="installation_3" type="formControl" method="post" action="#installUrl#">
	<div class="ui-form-list">
		<div class="col-md-12 paddingLess">
			<table class="ui-table-list" id="paramsettings">
				<thead>
					<tr>
						<th style="width:50px;">Required</th>
						<th>Parameter Name</th>
						<th>Parameter Value</th>
						<th><a href = "javascript://" onclick="add_row();"><i class="fa fa-plus"></i></a></th>
					</tr>
				</thead>
				<tbody>
					<cfset params_controller = createObject( "component", "cfc/params_controller" ) />
					<cfset getParamsSetting = params_controller.getParamsSetting() />
					<cfset data = getParamsSetting.data />
					<cfset hasChildParamList = getParamsSetting.hasChildParamList />
					<cfset currentRow = 1>
					<cfoutput>
					<cfloop collection="#data#" item="key">
						<cfif ArrayFindNoCase( hasChildParamList, key )>
							<cfloop collection="#data[key]#" item="childKey">
								<tr id="param_#currentrow#">
									<td align="center">#iif((data[key][childKey]['required']), DE('*'), DE(''))#</td>
									<td><input type="text" class="form-control" style="width:100%;" value="#LCase(key)#.#LCase(childKey)#" #iif((data[key][childKey]['required']), DE('required'), DE(''))# #iif((data[key][childKey]['readonlyKey']), DE('readonly'), DE(''))# placeholder="Paremeter name" name="name_row#currentrow#" id="name_row#currentrow#"></td>
									<td>
                                        <cfif data[key][childKey]['type'] eq "select">
                                            <select name="value_row#currentrow#" id="value_row#currentrow#" class="form-control">
                                                <cfloop array="#data[key][childKey]['option']#" index="i" item="item">
                                                    <option value="#item.value#" #data[key][childKey]['val'] eq item.value ? 'selected' : ''#>#item.text#</option>
                                                </cfloop>
                                            </select>
                                        <cfelse>
                                            <input type="#data[key][childKey]['type']#" class="form-control" style="width:100%;" value="#data[key][childKey]['val']#" #iif((data[key][childKey]['required']), DE('required'), DE(''))# #iif((data[key][childKey]['readonlyValue']), DE('readonly'), DE(''))# placeholder="Parameter Value" name="value_row#currentrow#" id="value_row#currentrow#">
                                        </cfif>
                                    </td>
									<td><a href = "##" onclick="del_row('param_#currentrow#', #iif((data[key][childKey]['required']), DE('1'), DE('0'))#);return false;"><i class="fa fa-minus"></i></a></td>
								</tr>
							</cfloop>
						<cfelse>
							<tr id="param_#currentrow#">
								<td align="center">#iif((data[key]['required']), DE('*'), DE(''))#</td>
								<td><input type="text" class="form-control" style="width:100%;" value="#LCase(key)#" #iif((data[key]['required']), DE('required'), DE(''))# #iif((data[key]['readonlyKey']), DE('readonly'), DE(''))# placeholder="Parameter Name" name="name_row#currentrow#" id="name_row#currentrow#"></td>
								<td>
                                    <cfif data[key]['type'] eq "select">
                                        <select name="value_row#currentrow#" id="value_row#currentrow#" class="form-control">
                                            <cfloop array="#data[key]['option']#" index="i" item="item">
                                                <option value="#item.value#" #data[key]['val'] eq item.value ? 'selected' : ''#>#item.text#</option>
                                            </cfloop>
                                        </select>
                                    <cfelse>
                                        <input type="#data[key]['type']#" class="form-control" style="width:100%;" value="#data[key]['val']#" #iif((data[key]['required']), DE('required'), DE(''))# #iif((data[key]['readonlyValue']), DE('readonly'), DE(''))# placeholder="Parameter Value" name="value_row#currentrow#" id="value_row#currentrow# ">
                                    </cfif>
                                </td>
								<td><a href = "##" onclick="del_row('param_#currentrow#', #iif((data[key]['required']), DE('1'), DE('0'))#);return false;"><i class="fa fa-minus"></i></a></td>
							</tr>
						</cfif>
						<cfset currentRow = currentRow + 1>
					</cfloop>
					</cfoutput>
				</tbody>
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

	(function() {
        function toJSONString( form ) {
            var obj = {};
            var elements = form.querySelectorAll( "input,select" );
            for( var i = 0; i < elements.length-1;i=i+2 ) {
               var element = elements[i];
                var name = element.name;
                var value = element.value;
                value = value.replace(/"/g,'');
                value = value.replace(/'/g,'');
                value = value.replace(/</g,'');
                value = value.replace(/>/g,'');
                value = value.replace(/`/g,'');
                value = value.replace(/ /g,'');
                var element2 = elements[i+1];
                var name2 = element2.name;
                var value2 = element2.value;
                value2 = value2.replace(/"/g,'');
                value2 = value2.replace(/'/g,'');
                value2 = value2.replace(/</g,'');
                value2 = value2.replace(/>/g,'');
                value2 = value2.replace(/`/g,'');
                if( value ) {
                    obj[value] = value2;
                }  
            }
            return JSON.stringify( obj );
        }
        document.addEventListener( "DOMContentLoaded", function() {
            document.getElementById( "installation_3" ).addEventListener( "submit", function( e ) {
                if(confirm('If you are sure that all your parameter settings are correct, you can proceed by pressing the OK button!')){
                    e.preventDefault();
                    params = toJSONString( this );
                    $.ajax({
                        type:'POST',
                        url:'cfc/install_schema.cfc?method=updateParams',
                        data: { params : params },
                        dataType: "json",
                        success: function ( response ) {
						    
							if( response.STATUS ){
                                location.href = "<cfoutput>#installUrl#?installation_type=4</cfoutput>";
                            }else alert("An error occurred while saving your parameter settings!");
							
                        },
                        error: function (msg)
                        {
                            alert("There is an error!");
                            return false;
                        }
                    });
                }else return false;
            }, false);
        });
    })();

	function add_row() {
        var table = $("table#paramsettings");
        var elements = $(table).find("input[type=text]");
        var currentrow = elements.length/2;
        var row = '<tr id="param_'+currentrow+'"><td></td><td><input type="text" class="form-control" style="width:100%;" placeholder="Parameter Name" name="name_row'+currentrow+'" id="name_row'+currentrow+'"></td><td><input type="text" class="form-control" style="width:100%;" placeholder="Parameter Value" name="value_row'+currentrow+'" id="value_row'+currentrow+'"></td><td><a href = "javascript://" onclick="del_row(\'param_'+currentrow+'\',0);return false;"><i class="fa fa-minus"></i></a></td></tr>';
        $(table).find("tbody").prepend(row);
        return false;
    }
    function del_row(currentrow, required) {
        if( !required ){
            var confirmed = confirm('Are you sure you want to delete?');
            if(confirmed) document.getElementById(currentrow).remove();
        }else alert("You cannot remove required field!");
    }

</script>