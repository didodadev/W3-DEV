<script>
    $(function() {
        var solutionid = $("input#solutionid").val();
        var familyid = $("input#familyid").val();
        var moduleid = $("input#moduleid").val();
        <cfif isDefined("print_query")>
            loadFamilies(solutionid, 'familyid', 'moduleid', familyid);
            loadModules(familyid, 'moduleid', moduleid);
        </cfif>

        var form = $("form[type=formControl]");
        var validate = true;

        $.install = {
            formControl : function () {
                form.submit(function() {
                validate = true;

                $(this).find(":input[required]").each(function() {
                    var inputType = $(this).attr("type");
                    if (inputType == "text" || inputType == "password" || inputType == "mail" || inputType == "tel" || inputType == "url")
                    {
                        if ($.trim($(this).val()) == '') {
                            $(this).css({"border-color":"red"});
                            alert($(this).attr("message"));
                            validate = false;
                        }
                    } else if (inputType == "file") {
                        var file = $(this).val().split('\\').pop();
                        if (!file) {
                            alert($(this).attr("message"));
                            validate = false;
                        }
                    } else if (inputType == "checkbox" || inputType == "radio") {
                        if (! $(this).is(":checked")) {
                            $(this).css({"border-color":"red"});
                            alert($(this).attr("message"));
                            validate = false;
                        }
                    }
                });
                if (validate) {

                    $("#solution").val($("#solutionid option:selected").text());
                    $("#family").val($("#familyid option:selected").text());
                    $("#module").val($("#moduleid option:selected").text());

                    $.ajax({
                        type: 'POST',
                        url: 'WDO/modalOutput.cfm',
                        data: $(form).serialize() + "&mode=save",
                        success: function(answer) {
                            if (answer == 1) { 
                                alert("Kay??t eklendi"); 
                                setTimeout(() => {
                                    window.location.reload(1);
                                }, (1000));
                            } else {
                                alert("Bir hata olu??tu");
                            }
                        }
                    });
                }
                return false;
            });
            }
        }
        $.install.formControl();
    });

    function loadTool(val){
        $("div.hidetool").hide();
		$("input[name=file_path]").removeAttr('required message');
		$("select[name=eventType]").removeAttr('required message');
		$("#"+val).show("fast");
		
		if(val == "code") {
			$("input[name=file_path]").attr({"required":true,"message":'Dosya yolunu giriniz'});
			$("select[name=eventType]").attr({"required":true,"message":'Event typeni se??iniz'});
		}
		else if(val == "nocode"){

		}
    }

    function loadFamilies(solutionId,target,related,selected)
{
	$('#'+related+" option[value!='']").remove();
	$.ajax({
		  url: '/WMO/GeneralFunctions.cfc?method=getFamily&dsn=<cfoutput>#dsn#</Cfoutput>&solutionId=' + solutionId,
		  success: function(data) {
			if(data)
			{
				$('#'+target+" option[value!='']").remove();
				data = $.parseJSON( data );
				for(i=0;i<data.DATA.length;i++)
				{
					var option = $('<option/>');
					if(selected && selected == data.DATA[i][0])
						option.attr({ 'value': data.DATA[i][0], 'selected':'selected' }).text(data.DATA[i][1]);
					else
						option.attr({ 'value': data.DATA[i][0] }).text(data.DATA[i][1]);
					$('#'+target).append(option);
				}
			}
		  }
	   });
}
function loadModules(familyId,target,selected)
{
	$.ajax({
		  url: '/WMO/GeneralFunctions.cfc?method=getModule&dsn=<cfoutput>#dsn#</Cfoutput>&familyId=' + familyId,
		  success: function(data) {
			if(data)
			{
				$('#'+target+" option[value!='']").remove();
				data = $.parseJSON( data );
				for(i=0;i<data.DATA.length;i++)
				{
					var option = $('<option/>');
					if(selected && selected == data.DATA[i][0])
						option.attr({ 'value': data.DATA[i][0], 'selected':'selected' }).text(data.DATA[i][1]);
					else
						option.attr({ 'value': data.DATA[i][0] }).text(data.DATA[i][1]);
					$('#'+target).append(option);
				}
			}
		  }
	   });
}

    function goFormDetail(option, id) 
	{
		$("#workdevmenu li.workdevActive").attr('class', '');
		$("#workdevmenu li[title="+option+"]").attr('class', 'workdevActive');
		callPage(option, null, null, '&fuseact='+id);
    }

    function publish(fuseact, id) {
        $.get("index.cfm?fuseaction=objects.emptypopup_system&type=event&mode=publish&fuseact="+ fuseact +"&id="+id, function(data) {
            alertify.success(data);
        });
    }
</script>